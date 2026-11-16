#Include 'Totvs.ch'
#Include 'DHL.ch'

#Define GETF_ONLYSERVER 1


/*/{Protheus.doc} Ag2XMLTerceiro
Função para importação de NF de Terceiro
@type function
@author Thiago Meschiatti
@since 25/08/2017
@version 1.0
/*/
User Function Ag2XMLTerceiro()
	Local cXML		:= ""
	Local cArquivo	:= ""
	Local cDirectory:= ""
	Local cCFLocacao:= ""
	Local cCFComod  := ""
	Local cUnidade	:= Alltrim(GetMv("ZZ_CNPJAG"))

	
	If Alltrim(SM0->M0_CGC) == cUnidade

		Tela(@cXML, @cDirectory, @cArquivo, @cCFLocacao, @cCFComod)
	    
		If !Empty(cXML) .and. !Empty(cDirectory) .and. !Empty(cArquivo) .and. !Empty(cCFLocacao) .and. !Empty(cCFComod)
		
			Processa({|| GravaHist(cXML, cDirectory, cArquivo, cCFLocacao, cCFComod) },"Processando...")
			
		Endif	

	Else
		Aviso("CNPJ "+cUnidade,"Rotina específica da unidade HP AG2.",{"OK"})
	Endif

Return Nil

/*
** GravaHist
*/
Static Function GravaHist(cXML, cDirectory, cArquivo, cCFLocacao, cCFComod)
	Local oImpNfe	:= Nil
	Local oLog 		:= Nil
	Local cError	:= ""
	Local aPedido	:= {}
	Private aLogAuto:= {}
	
	ProcRegua(1)
	
	IncProc()
	
	oLog := DHLLogManager():newDHLLogManager()
	oDir := DHLDirectoryManager():newDHLDirectoryManager(cDirectory)
	
	If oDir:startProcess(cXML)
		oLog:start(APP_IMPORTADOR_XML, DHL_IMPORTACAO, cXML)
		oImpNfe	:= TImpNfe():new(cDirectory, cArquivo+".processing", .T.)
		
		oLog:success(cXML)
		oDir:setProcessed(cXML)
		aPedido := GrvDados(oImpNfe, cCFLocacao, cCFComod)
		If Len(aPedido) > 0
			U_Ag2GeraPed(1,aPedido,Nil)
		Endif
	Endif
	
Return Nil


/*
** Retorna Erro
*/		
Static Function retError(aLogAuto)
	Local cError := ""
	Local nI	 := 0
	
	For nI:=1 To Len(aLogAuto)
		If Substr(aLogAuto[nI],1,1) $ "A|E|"
			cError += aLogAuto[nI] +CRLF
		Endif
	Next nI
	
Return (cError)


/*
** Gravação de informações
*/
Static Function GrvDados(oImpNfe, cCFLocacao, cCFComod)
	Local aRetorno 	:= {}
	Local aItens	:= {}
	Local cCliFor	:= ""
	Local cLoja		:= ""
	Local nCont		:= 0
	
	//--- Destinatário:
	SA1->(dbSetOrder(3))
	If SA1->(dbSeek( xFilial("SA1") + Padr(oImpNfe:Dest:_CNPJ:Text,Len(SA1->A1_CGC)) ))		
		cCliFor  := SA1->A1_COD
		cLoja    := SA1->A1_LOJA
	Else
		cCliFor  := oImpNfe:aCab[03,2]
		cLoja    := oImpNfe:aCab[04,2]		
	Endif
	
	SZ8->(dbSetOrder(1))
	If !SZ8->(dbSeek( xFilial("SZ8") + oImpNfe:aCab[01,2] + oImpNfe:aCab[02,2] + cCliFor + cLoja ))
		
		aItens := oImpNfe:aItens //--- Vetor contendo os itens da nota fiscal
		
		//--- Cabecalho:
		RecLock("SZ8",.T.)
		SZ8->Z8_FILIAL	:= xFilial("SZ8")
		SZ8->Z8_DOC 		:= oImpNfe:aCab[01,2]
		SZ8->Z8_SERIE   	:= oImpNfe:aCab[02,2]
		
		SZ8->Z8_CLIENTE := cCliFor 
		SZ8->Z8_LOJA    := cLoja   
		
		SZ8->Z8_EMISSAO 	:= oImpNfe:aCab[05,2] // oImpNfe:aCab[8,2]
		SZ8->Z8_EST		:= oImpNfe:aCab[06,2]
		SZ8->Z8_TIPO		:= oImpNfe:aCab[07,2]
		SZ8->Z8_ESPECIE	:= oImpNfe:aCab[09,2]
		SZ8->Z8_CHVNFE	:= oImpNfe:aCab[10,2]
		SZ8->Z8_TPNF   	:= If(aItens[1,ascan(aItens[1], {|x| x[1] == "D1_ZZCFOP"}),2] $ cCFLocacao,"L","C") //--- Locacal ou Comodato
		SZ8->Z8_USUARIO	:= cUserName
		SZ8->Z8_STATUS	:= "I"
			
		//--- Emitente:
		SA1->(dbSetOrder(3))
		SA1->(dbSeek( xFilial("SA1") + Padr(oImpNfe:Emitente:_CNPJ:Text,Len(SA1->A1_CGC)) ))
		SZ8->Z8_CLIEMIT := SA1->A1_COD
		SZ8->Z8_LOJEMIT := SA1->A1_LOJA
		SZ8->Z8_EMITENT := oImpNfe:Emitente:_xNome:Text
		SZ8->(MsUnLock())
			
		//--- Itens:
		For nCont:=1 To Len(aItens)
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek( xFilial("SB1") + Padr(aItens[nCont,ascan(aItens[nCont], {|x| x[1] == "D1_COD"}),2],Len(SB1->B1_COD)) ))
				RecLock("SZ9",.T.)
				SZ9->Z9_FILIAL 		:= xFilial("SZ9")
				SZ9->Z9_DOC			:= SZ8->Z8_DOC
				SZ9->Z9_SERIE		  	:= SZ8->Z8_SERIE
				SZ9->Z9_CLIENTE     	:= SZ8->Z8_CLIENTE
				SZ9->Z9_LOJA        	:= SZ8->Z8_LOJA
				SZ9->Z9_ITEM			:= StrZero(Val(aItens[nCont,ascan(aItens[nCont], {|x| x[1] == "D1_ITEM"}),2]),Len(SZ9->Z9_ITEM))
				SZ9->Z9_COD			:= SB1->B1_COD
				SZ9->Z9_UM			:= SB1->B1_UM
				SZ9->Z9_QUANT			:= aItens[nCont,ascan(aItens[nCont], {|x| x[1] == "D1_QUANT"}),2]				
				SZ9->Z9_PRCVEN		:= aItens[nCont,ascan(aItens[nCont], {|x| x[1] == "D1_VUNIT"}),2]
				SZ9->Z9_TOTAL			:= aItens[nCont,ascan(aItens[nCont], {|x| x[1] == "D1_TOTAL"}),2]
				SZ9->Z9_CF			:= aItens[nCont,ascan(aItens[nCont], {|x| x[1] == "D1_ZZCFOP"}),2]								
				SZ9->Z9_TP   			:= "I"
				SZ9->(MsUnLock())
			Endif
		Next
			
		aAdd(aRetorno, xFilial("SZ8") + SZ8->Z8_DOC + SZ8->Z8_SERIE + SZ8->Z8_CLIENTE + SZ8->Z8_LOJA )
	Else
		Alert("Nota já importada. Verifique!")
		lRetorno := .F.
	Endif
	
Return aRetorno


/*
** Geração de pedido de venda
*/
User Function Ag2GeraPed(nOpt, aPedido, oModel)
	Local nOperation:= 0
	
	If nOpt == 2 //--- Inclusao Manual
		FWFormCommit(oModel)
		nOperation:= oModel:GetOperation()
		
		If nOperation == 3   
			aAdd(aPedido, xFilial("SZ8") + SZ8->Z8_DOC + SZ8->Z8_SERIE + SZ8->Z8_CLIENTE + SZ8->Z8_LOJA )
		ElseIf nOperation == 5  
			SC5->(dbSetOrder(1))
			SC5->(dbSeek( xFilial("SC5") + SZ8->Z8_PEDIDO ))
			GravaPed(5,nOpt)    
		Endif
	Endif
	
	If Len(aPedido) > 0
		SZ8->(dbSetOrder(1))
		If SZ8->(dbSeek( aPedido[1] ))
			SZ9->(dbSetOrder(1))
			If SZ9->(dbSeek( aPedido[1] ))
				GravaPed(3,nOpt)
			Endif
		Endif
	Endif
	
Return .T.


/*
** GravaPed
*/
Static Function GravaPed(nOperacao,nOpt)
	Local aSC5 		:= {}
	Local aSC6 		:= {}
	Local aDetail 	:= {}
	Local cTesNfp4	:= GetMv("ZZ_TESNFP4")
	Private lMsErroAuto	:= .F.
	
	//--- Cabecalho Pedido Venda:
	aAdd(aSC5,{"C5_FILIAL" 	, If(nOperacao == 5, SC5->C5_FILIAL , xFilial("SC5"))			,Nil})
	aAdd(aSC5,{"C5_NUM"	  	, If(nOperacao == 5, SC5->C5_NUM 	, getNextSalesOrderNumber()),Nil})
	aAdd(aSC5,{"C5_TIPO"   	, If(nOperacao == 5, SC5->C5_TIPO 	, "N")                      ,Nil})
	aAdd(aSC5,{"C5_CLIENTE"	, If(nOperacao == 5, SC5->C5_CLIENTE, SZ8->Z8_CLIEMIT)  		,Nil})
	aAdd(aSC5,{"C5_LOJACLI"	, If(nOperacao == 5, SC5->C5_LOJACLI, SZ8->Z8_LOJEMIT) 	 		,Nil})
	aAdd(aSC5,{"C5_CONDPAG"	, If(nOperacao == 5, SC5->C5_CONDPAG, Alltrim(GetMv("ZZ_CONDINT"))),Nil})
	aAdd(aSC5,{"C5_ZZNFTER"	, If(nOperacao == 5, SC5->C5_ZZNFTER, SZ8->Z8_DOC) 	 			,Nil}) //--- NF Origem
	aAdd(aSC5,{"C5_ZZSETER"	, If(nOperacao == 5, SC5->C5_ZZSETER, SZ8->Z8_SERIE)	 		,Nil}) //--- Série da NF Origem
	aAdd(aSC5,{"C5_ZZCLTER"	, If(nOperacao == 5, SC5->C5_ZZCLTER, SZ8->Z8_CLIEMIT)  		,Nil}) //--- Emitente
	aAdd(aSC5,{"C5_ZZLJTER"	, If(nOperacao == 5, SC5->C5_ZZLJTER, SZ8->Z8_LOJEMIT)  		,Nil}) //--- Loja do Emitente	
	aAdd(aSC5,{"C5_ZZESPEC"	, If(nOperacao == 5, SC5->C5_ZZLJTER, DHL_ESPECIE_INVENTARIO) ,Nil}) //--- Loja do Emitente
			
	//--- Itens Pedido Venda:
	If nOperacao == 5
		SC6->(dbSetOrder(1))
		SC6->(dbSeek( xFilial("SC6") + SC5->C5_NUM ))
		While SC6->(!Eof()) .and. SC6->C6_FILIAL == SC5->C5_FILIAL .and. SC6->C6_NUM == SC5->C5_NUM
			aDetail := {}
			aAdd(aDetail, {"C6_ITEM"		, SC6->C6_ITEM		, Nil})
			aAdd(aDetail, {"C6_PRODUTO"	, SC6->C6_PRODUTO	, Nil})
			aAdd(aDetail, {"C6_QTDVEN"		, SC6->C6_QTDVEN	, Nil})
			aAdd(aDetail, {"C6_PRCVEN"		, SC6->C6_PRCVEN	, Nil})
			aAdd(aDetail, {"C6_VALOR"		, SC6->C6_VALOR 	, Nil})
			aAdd(aDetail, {"C6_TES"		, SC6->C6_TES		, Nil})
			aAdd(aSC6, aDetail)
			SC6->(dbSkip())
		Enddo
	Else
		While SZ9->(!Eof()) .and. SZ9->Z9_FILIAL+SZ9->Z9_DOC+SZ9->Z9_SERIE+SZ9->Z9_CLIENTE+SZ9->Z9_LOJA == SZ8->Z8_FILIAL+SZ8->Z8_DOC+SZ8->Z8_SERIE+SZ8->Z8_CLIENTE+SZ8->Z8_LOJA				
			aDetail := {}
			aAdd(aDetail, {"C6_ITEM"		, StrZero(Len(aSC6)+1,Len(SC6->C6_ITEM))			, Nil})
			aAdd(aDetail, {"C6_PRODUTO"	, SZ9->Z9_COD		, Nil})
			aAdd(aDetail, {"C6_QTDVEN"		, SZ9->Z9_QUANT		, Nil})
			aAdd(aDetail, {"C6_PRCVEN"		, SZ9->Z9_PRCVEN	, Nil})
			aAdd(aDetail, {"C6_VALOR"		, A410Arred(SZ9->Z9_PRCVEN * SZ9->Z9_QUANT,"C6_VALOR") , Nil})
			aAdd(aDetail, {"C6_TES"		, Alltrim(cTesNfp4), Nil})
			aAdd(aSC6, aDetail)					
			SZ9->(dbSkip())
		Enddo
	Endif
			
	If Len(aSC5) > 0 .and. Len(aSC6) > 0

		lMsErroAuto := .F.
		MsExecAuto({|x,y,z| MATA410(x,y,z)}, aSC5, aSC6, nOperacao)
		
		If lMsErroAuto
			MostraErro()
		ElseIf nOperacao == 3
			RecLock("SZ8",.F.)
			SZ8->Z8_PEDIDO 	:= SC5->C5_NUM
			SZ8->(MsUnLOck()) 
			
			Aviso("LOCAÇÃO","Gerado pedido de venda no. "+SC5->C5_NUM+".",{"OK"})
		ElseIf nOperacao == 5
			RecLock("SZ8",.F.)
			SZ8->Z8_PEDIDO 	:= " "
			SZ8->(MsUnLOck()) 
			
			Aviso("LOCAÇÃO","EXCLUÍDO o pedido de venda no. "+SC5->C5_NUM+".",{"OK"})
		EndIf
	Endif
			
Return Nil


/*
** getNextSalesOrderNumber
*/
Static Function getNextSalesOrderNumber()
	Local cMaxNumber  := ""
	Local cNextNumber := ""
	Local oSql		  := IpSqlObject():newIpSqlObject()
	
	oSql:newAlias(" SELECT MAX(C5_NUM) MAXNUMBER "+;
		" FROM %SC5.SQLNAME% "+;
		" WHERE %SC5.XFILIAL% ")
	
	cMaxNumber := oSql:getValue("MAXNUMBER")
	
	If Empty(cMaxNumber)
		cNextNumber := StrZero(1, Len(SC5->C5_NUM))
	Else
		cNextNumber := Soma1(cMaxNumber)
	EndIf
	
	oSql:close()
	
Return cNextNumber


/*
** Tela
*/
Static Function Tela(cXML, cDirectory, cArquivo, cCFLocacao, cCFComod)
	Local oFont, oTela, oGrp1, oGet1, oGrp2, oGet2, oGrp3, oGet3, oBtn1, oBtn2
	Local lConfirma := .F.
	
	cCFLocacao	:= Alltrim(GetMv("ZZ_CFLOCAG")) //--- CFOP Locacao AGE
	cCFComod	:= Alltrim(GetMv("ZZ_CFCOMAG")) //--- CFOP Comodato AGE
	
	oFont:= TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	oTela:= MSDialog():New( 092,232,250,823,"Importa XML Terceiro",,,.F.,,,,,,.T.,,,.T. )
	
	oGrp3:= TGroup():New( 004,008,028,280,"Arquivo XML:",oTela,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet3:= TGet():New( 012,012,{|u| If(PCount()>0,cXML:=u,cXML)},oGrp3,264,010,'',,CLR_BLACK,CLR_WHITE,oFont,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cXML",,)
	oGet3:Disable()
	                                                                                                            
	oBtn1:= TButton():New( 48,050,"Seleciona XML"  ,oTela,{|x| cXML := cGetFile('Arquivos (*.XML) | *.XML',"Selecione o arquivo para importação",0,,.F.,nOr(GETF_ONLYSERVER,GETF_LOCALHARD)), oGet3:Refresh()},060,012,,,,.T.,,"",,,,.F. )
	oBtn1:= TButton():New( 48,200,"OK"     		,oTela,{|x| oTela:End(), lConfirma:=.T.},037,012,,,,.T.,,"",,,,.F. )
	oBtn2:= TButton():New( 48,244,"Cancela"		,oTela,{|x| oTela:End()},037,012,,,,.T.,,"",,,,.F. )
	
	oTela:Activate(,,,.T.)
	
	If lConfirma .and. !Empty(cXML)
		cDirectory	:= Substr(cXML,1,Rat("\",cXML))
		cArquivo	:= Substr(cXML,Rat("\",cXML)+1,Len(cXML))
		
		If !Empty(cCFLocacao)
			PutMv("ZZ_CFLOCAG", cCFLocacao) //--- CFOP Locacao AGE
		Endif
	    
		If !Empty(cCFComod)
			PutMv("ZZ_CFCOMAG",cCFComod) 	//--- CFOP Comodato AGE
		Endif
	Endif
	
Return Nil
