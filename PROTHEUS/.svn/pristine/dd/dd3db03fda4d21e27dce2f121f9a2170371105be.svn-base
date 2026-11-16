#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"     
#INCLUDE "tbiconn.ch"
#INCLUDE "FILEIO.CH"
#include "dhl.ch"

#DEFINE CRLF chr(13) + chr(10)


/*/{Protheus.doc} ImportBRKL
Função de importação de dados via arquivo CSV para alimentar as notas fiscais de entrada
U_ImportBRKL()
@author julyanevale
@since 17/05/2018
@version P11 R5
/*/

USER FUNCTION ImportBRKL()
	Private aAuxError := {}
	Private nArq := 0
	Private cCamArq := "importInv\logImportStatus_"+STRTran(DTOS(ddatabase), '/', '-')+".txt"
	Private nItem := 0 
	Private nIt	:= 0
	Private cIdOper := "" 
	Private nIdOper := 0
	Private lMsErroAuto := .F.
	Private _cFilNew := xFilial()
	Private _cFilOld := '095AGE009596' 
	//Private cFiliaAnt := '02' 
	Private cQueryI := ""
	Private cQuery	:= ""
	Private cNfR	:= ""
	Private cSerieR  := 	""
	Private cLote  := ""
	Private nQtde := 0
	Private cUM := ""
	Private cLocal := ""
	Private cFF := ""
	Private cDataEmis	:= ""
	Private dDataEmi
	Private aCab := {}
	Private _aLinha := {}
	Private aItens := {}
	Private cLotAt := ""
	Private cNumSq := ""
	Private aNFSe:= {}
	Private nValor := 0
	Private aItem := {}

	Private  	cArqCsv  		:= ""            		//Nome do arquivo csv
	Private  	lSaiu    		:= .F.
	
	Private oTempTable	:= nil

	//Monta a tela de escolha do arquivo csv e retorna o nome do arquivo selecionado
	MontaTelaIni()

	//Se clicou no sair da tela inicial de escolha do arquivo	
	If lSaiu
		return
	EndIf

	//----------------------------------------------------------Validando CSV---------------------------------------------------------------------------------------------------------------
	If Empty(alltrim(cArqCsv))
		MsgAlert("Selecione o arquivo antes de iniciar a importação!")          
	Endif	

	//Caminho do arquivo selecionado na tela de escolha do arquivo
	cFile := cArqCsv     

	//Se não encontrou o arquivo ou se deixou em vazio	
	If !File(cFile) .and. !Empty(cFile) 
		MsgAlert("Arquivo CSV não encontrado no Private selecionado!")
		lSaiu := .T.
	Endif	

	Processa( {|| RunProc(cFile) }, "Aguarde...", "Carregando dados...",.F.)

	Return                        

	******************************
Static Function RunProc(cFile)
	******************************
	//------------------------------------------------------------------------------------------------------------------------------------------------------------
	//Efetuando a leitura do arquivo de enderecamento e verificando as validações

	//Abre o arquivo como leitura (0)
	FT_FUSE(cFile)
	FT_FGOTOP()

	//Valida primeira linha do arquivo 
	aLinha := {}
	bError := .F.

	cLinha  := FT_FREADLN()
	aLinha  := Separa(cLinha, ";" , .T.)

	//Validando cabeçalho
	If  alltrim(StrTran( aLinha[1] , '"' , '' )) <> 'FILIAL' 
		bError := .T.
	endif

	if  alltrim(StrTran( aLinha[2] , '"' , '' )) <> 'PRODUTO' 
		bError := .T.
	endif 

	if  alltrim(StrTran( aLinha[3] , '"' , '' )) <> 'NF' 
		bError := .T.
	endif

	if  alltrim(StrTran( aLinha[4] , '"' , '' )) <> 'SERIENF' 
		bError := .T.
	endif

	if  alltrim(StrTran( aLinha[5] , '"' , '' )) <> 'DATANF' 
		bError := .T.
	endif

	if  alltrim(StrTran( aLinha[6] , '"' , '' )) <> 'LOTE' 
		bError := .T.
	endif  

	if  alltrim(StrTran( aLinha[7] , '"' , '' )) <> 'ARMAZEM' 
		bError := .T.
	endif

	If alltrim(StrTran( aLinha[8] , '"' , '' )) <> 'QUANTIDADE' 
		bError := .T.
	endif

	If alltrim(StrTran( aLinha[9] , '"' , '' )) <> 'UM' 
		bError := .T.
	endif

	if bError 
		MsgAlert("Arquivo com cabeçalho inválido!")
		return
	endif   

	//Montando vetor dos itens do vetor 
	FT_FSKIP()                                         			//pula primeira linha do cabeçalho   

	nRegOK 	:= 0
	nNumItens := 1
	cAuxError := ""

	//-------------------------------------------Abre o arquivo para gravar os logs-------------------------------------------------------------------------
	lPasta := ExistDir("\importInv")
	If lPasta==.F.
		MakeDir("\importInv") //cria a pasta     
	Endif

	// TESTE SE JÁ EXISTE O ARQUIVO
	if file(cCamArq ) == .t. 
		// ABRE O ARQUIVO
		FErase(cCamArq)
	Endif

	nArq := fCreate( cCamArq)

	if nArq <= 0 
		alert("Erro ao tentar criar ou abrir o arquivo " + cCamArq + ".txt") 
		return 
	endif
	cMsg := "IMPORTACAO - INICIO "  + CRLF   
	fWrite( nArq, cMsg, len(cMsg))
	fClose(nArq)

	cAuxError:=""


	aCposTRB	:= {{ "FILIAL"     , "C", TAMSX3("D1_FILIAL")[1], 0 },;  // filial
	{ "PRODUTO"      , "C", TAMSX3("D1_COD")[1], 0 },;  // produto
	{ "NFR"  , "C", TAMSX3("D1_DOC")[1], 0 },;  // nf
	{ "SERIER"    , "C", TAMSX3("D1_SERIE")[1], 0 },;  // serie
	{ "EMISSAO"   , "D", TAMSX3("D1_EMISSAO")[1], 0 },;  // data emissao
	{ "LOTE"   , "C", TAMSX3("D1_LOTECTL")[1], 0 },;  // lote
	{ "LOCAL"   , "C", TAMSX3("D1_LOCAL")[1], 0 },;  // armazem
	{ "QUANT"   , "N", TAMSX3("D1_QUANT")[1], 2 },;  // quant
	{ "UM"  , "C", TAMSX3("B1_UM")[1], 0 },;
	{ "DEL"  , "C", 1, 0 }}	  // DELETADO

	If oTempTable <> Nil
		oTempTable:Delete()
		oTempTable := Nil
	Endif

	oTempTable := FWTemporaryTable():New("TRB", aCposTRB)
	oTempTable:AddIndex("1", {"FILIAL", "NFR", "SERIER", "PRODUTO", "LOTE", "LOCAL"} )
	oTempTable:Create()

	If Select( "TRB" ) > 0
		dbSelectArea( "TRB" )
		dbCloseArea()
	EndIf

	While !FT_FEOF()                                      		//Percorre todo arquivo

		cLinha  := FT_FREADLN()
		aLinha  := Separa(cLinha, ";" , .T.)      

		cAuxError := ""
		If len(aLinha)	> 0

			cFF       := alltrim(StrTran(aLinha[1] , '"' , '' ))
			cCodProd  := alltrim(StrTran(aLinha[2] , '"' , '' ))+Space(TAMSX3("D1_COD")[1]-Len(alltrim(StrTran(aLinha[2], '"' , '' ))))
			cNfR      := alltrim(StrTran(aLinha[3] , '"' , '' ))
			cSerieR   := alltrim(StrTran(aLinha[4], '"' , '' ))+Space(TAMSX3("D1_SERIE")[1]-Len(alltrim(StrTran(aLinha[4], '"' , '' ))))
			cDataEmis := alltrim(StrTran(aLinha[5] , '"' , '' )) 
			cLote     := alltrim(StrTran(aLinha[6], '"' , '' ))+Space(TAMSX3("D1_LOTECTL")[1]-Len(alltrim(StrTran(aLinha[6], '"' , '' ))))  
			cLocal    := alltrim(StrTran(aLinha[7], '"' , '' ))  
			nQtde     := Val(alltrim(StrTran(StrTran(aLinha[8],".",""),",","."))) 
			cUM       := alltrim(StrTran(aLinha[9], '"' , '' ))  

			nNumItens++

			If Right(Substr(cDataEmis, 1,3),1) == '-'
				cDataEmis := Strtran(cDataEmis, '-', '')
			Else
				cDataEmis := Strtran(cDataEmis, '/', '')
			EndIf	 

			cDataEmis := Substr(cDataEmis, 5,4) + Substr(cDataEmis, 3,2) + Substr(cDataEmis, 1,2)
			dDataEmi := StoD(cDataEmis)

			if Empty(cCodProd)
				cAuxError   += "CSV - Linha " +  alltrim(str(nNumItens)) + " - O código do Produto não foi informado. " + CRLF     
			endif

			if Empty(cNfR)  
				cAuxError += "CSV - Linha " +  alltrim(str(nNumItens)) + " -   Numero da NF Remessa não foi informado. " + CRLF
			endif  

			if Empty(cSerieR)  
				cAuxError += "CSV - Linha " +  alltrim(str(nNumItens)) + " -   A Série da Remessa não foi informada. " + CRLF   
			endif

			if Empty(cLote) .And. getRastro(cCodProd) == "L"
				cAuxError += "CSV - Linha " +  alltrim(str(nNumItens)) + "  -   O Lote do produto não foi informado." + CRLF   
			endif

			if Empty(nQtde)  
				cAuxError += "CSV - Linha " +  alltrim(str(nNumItens)) + "  -   A Quantidade do lote não foi informada." + CRLF   
			endif

			if Empty(cDataEmis)  
				cAuxError += "CSV - Linha " +  alltrim(str(nNumItens)) + "  -   A Data de Emissão da NF Remessa não foi informada." + CRLF   
			endif

			if Empty(cUM)  
				cAuxError += "CSV - Linha " +  alltrim(str(nNumItens)) + "  -   A Unidade de medida não foi informada." + CRLF   
			endif

			If Empty(cLocal)  
				cAuxError += "CSV - Linha " +  alltrim(str(nNumItens)) + "  -   O armazém não foi informada." + CRLF   
			endif

			If Empty(cFF)  
				cAuxError += "CSV - Linha " +  alltrim(str(nNumItens)) + "  -   A Filial não foi informada." + CRLF   
			endif

			If !Empty(cAuxError)   	      //corrigido por Edson Deluca
				GravaLog(cAuxError,cCamArq)
				cAuxError:=""
			EndIf                         //corrigido por Edson Deluca
			//Verifica se já foi realizada a importação de dados caso sim não realiza a importação.	      
			If !Empty(cCodProd) .and. !Empty(cNfR)  .and. !Empty(cSerieR)   /*.and. !Empty(cLote)*/   .and. !Empty(cFF) .and. !Empty(cUM) .and. !Empty(cLocal) .and. !Empty(nQtde)  .and. !Empty(dDataEmi)  

				dbSelectArea("TRB")
				If dbSeek(cFF + cNFR + cSERIER + cCodProd + cLOTE + cLOCAL,.F.)
					cAuxError += "CSV - Linha " +  alltrim(str(nNumItens)) + "  -   Está duplicada na planilha." + CRLF   
					GravaLog(cAuxError,cCamArq)
					cAuxError:=""
				Else
					If RecLock("TRB", .T.)
						Replace FILIAL		With cFF
						Replace PRODUTO		With cCodProd
						Replace NFR			With cNfR
						Replace SERIER   	With cSerieR
						Replace EMISSAO		With dDataEmi
						Replace LOTE		With cLote
						Replace LOCAL		With cLocal
						Replace QUANT		With nQtde
						Replace UM			With cUM
						Replace DEL 		With " "
						MsUnLock()
					EndIf
				EndIf
			EndIf
		EndIf

		FT_FSKIP()		

	End 

	FT_FUSE()

	ProcImport()

	Return   

	****************************
Static Function ProcImport()
	****************************

	Local nQtde := 0

	dbSelectArea("TRB")  
	dbGoTop()

	ProcRegua(RecCount())

	nQtde := TRB->(RecCount())

	While !TRB->(EOF()) 

		IncProc()

		DBSELECTAREA("SB1")
		/*	If (DBSEEK(xFilial()+TRB->PRODUTO))
		If SB1->B1_RASTRO <> "L"
		RecLock("SB1" , .F.)
		SB1->B1_RASTRO := 'L'
		MSUNLOCK()
		EndIf
		EndIf	
		*/                                   
		_cFilial := TRB->FILIAL
		_cNF     := TRB->NFR
		_cSerie  := TRB->SERIER

		_aCab := FazCab(_cFilial,_cNF,_cSerie)

		_aItens := {}

		dbSelectArea("TRB")

		While !Eof() .And. AllTrim(TRB->FILIAL)==AllTrim(_cFilial) .And. AllTrim(_cNF)==AllTrim(TRB->NFR) .And. AllTrim(TRB->SERIER)==AllTrim(_cSerie)

			_aItens := FazItem(_aItens)

			dbSelectArea("TRB")
			dbSkip()

		End    

		If !ExisteNF(_cFilial,_cNF,_cSerie)    
			FazNF(_aCab,_aItens)      
		EndIf

	End	

	cAuxError := "------------------------------------------------------------"+ CRLF
	cAuxError += "!!!!!!!!!!!!!!!FIM DA IMPORTAÇÃO !!!!!!!!!!!!!!!!!!!!!!!!!!" + CRLF      
	cAuxError += "------------------------------------------------------------"+ CRLF
	GravaLog(cAuxError,cCamArq)


	MsgAlert("Importação finalizada")
	For nI= 1 to Len(aAuxError)
		fWrite( nArq, aAuxError[nI][1], len(aAuxError[nI][1]))
	Next nI

	fClose( nArq)

	Return

	*********************************************
Static Function FazCab(_cFilial,_cNF,_cSerie)
	*********************************************

	Local cQuery := ""
	Local _aCab  := {}

	cQuery:=  " 	SELECT *                      						               " + CRLF 
	cQuery += " 	FROM  " + RetSqlName("SF1") + " 					          	   " + CRLF
	cQuery += " 	WHERE										 		           	   " + CRLF
	cQuery += "		D_E_L_E_T_ <>  '*'									               " + CRLF
	cQuery += "		AND F1_FILIAL =  '"	+ _cFilOld  +"'					               " + CRLF
	cQuery += "		AND F1_DOC	 =  '" +   _cNF   +"' AND F1_SERIE = '" + _cSerie + "' " + CRLF 

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMF",.F.,.T.)

	dbSelectArea("TMF")
	dbGoTop()

	If Empty(TMF->F1_DOC) .Or. Eof()
		cAuxError := "------------------------------------------------------------"+ CRLF
		cAuxError += "IMPORTACAO - NF NÃO REALIZADA. " + CRLF
		cAuxError += "MOTIVO: NF NAO EXISTENTE NA FILIAL ORIGEM " + CRLF
		cAuxError += "NF/SERIE: "+_cNF+"/"+_cSerie+" " + CRLF
		cAuxError += "------------------------------------------------------------"+ CRLF
		GravaLog(cAuxError,cCamArq)
		cAuxError:=""
	Else
		aAdd(_aCab,{"F1_DOC"     ,_cNF				 	 ,nil})
		aAdd(_aCab,{"F1_SERIE"   ,_cSerie       			 ,nil})
		aAdd(_aCab,{"F1_FORNECE" ,TMF->F1_FORNECE 		 ,nil})
		aAdd(_aCab,{"F1_LOJA"    ,TMF->F1_LOJA 	         ,nil})
		aAdd(_aCab,{"F1_EMISSAO" ,TRB->EMISSAO 		     ,nil})
		aAdd(_aCab,{"F1_TIPO"    ,TMF->F1_TIPO      	     ,nil})
		aAdd(_aCab,{"F1_FORMUL"  ,"N"                     ,nil})
		aAdd(_aCab,{"F1_ESPECIE" ,"SPED"                   ,nil})			
		aAdd(_aCab,{"F1_ZZADJID"	,TMF->F1_ZZADJID		 ,nil})
		aAdd(_aCab,{"F1_ZZMARCA"	,TMF->F1_ZZMARCA		 ,nil})
		aAdd(_aCab,{"F1_ZZCTEAW"	,TMF->F1_ZZCTEAW		 ,nil})
		aAdd(_aCab,{"F1_ZZSTATU"	,TMF->F1_ZZSTATU		 ,nil})
		aAdd(_aCab,{"F1_ZZDSNFE"	,TMF->F1_ZZDSNFE		 ,nil})
		aAdd(_aCab,{"F1_ZZRORD"	,TMF->F1_ZZRORD		     ,nil})
		aAdd(_aCab,{"F1_ZZROEXT"	,TMF->F1_ZZROEXT		 ,nil})
		aAdd(_aCab,{"F1_ZZCUTOV"	,TMF->F1_ZZCUTOV		 ,nil})
		aAdd(_aCab,{"F1_ZZNFVEN"	,TMF->F1_ZZNFVEN		 ,nil})
		aAdd(_aCab,{"F1_ZZSEVEN"	,TMF->F1_ZZSEVEN		 ,nil})
		aAdd(_aCab,{"F1_ZZDEMVE"	,TMF->F1_ZZDEMVE		 ,nil})
		aAdd(_aCab,{"F1_ZZAUTO"	,TMF->F1_ZZAUTO		     ,nil})
		aAdd(_aCab,{"F1_ZZNFDEV"	,TMF->F1_ZZNFDEV		 ,nil})
		aAdd(_aCab,{"F1_ZZSEDEV"	,TMF->F1_ZZSEDEV		 ,nil})
		aAdd(_aCab,{"F1_ZZDTDEV"	,TMF->F1_ZZDTDEV		 ,nil})
		aAdd(_aCab,{"F1_EST"		,TMF->F1_EST			 ,nil})
		aAdd(_aCab,{"F1_DTDIGIT"	,TMF->F1_DTDIGIT		 ,nil})
		aAdd(_aCab,{"F1_IMPORT"	,TMF->F1_IMPORT		     ,nil})
		aAdd(_aCab,{"F1_HORA"	,TMF->F1_HORA		 	 ,nil})
		aAdd(_aCab,{"F1_TIPODOC"	,TMF->F1_TIPODOC		 ,nil})
		aAdd(_aCab,{"F1_MENPAD"	,TMF->F1_MENPAD		     ,nil})
		//  aAdd(_aCab,{"F1_TRANSP"	," "		         ,nil})
		aAdd(_aCab,{"F1_MENNOTA"	,TMF->F1_MENNOTA		 ,nil})	
		aAdd(_aCab,{"F1_CHVNFE"	,TMF->F1_CHVNFE		     ,nil})	
	Endif

	dbSelectArea("TMF")
	DbCloseArea("TMP")

	Return(_aCab)


	********************************
Static Function FazItem(_aItens) 
	********************************

	Local cQuery   := ""
	Local _aLinha  := {}

	cQuery:=  " 	SELECT *                      						               " + CRLF 
	cQuery += " 	FROM  " + RetSqlName("SD1") + " 					          	   " + CRLF
	cQuery += " 	WHERE										 		           	   " + CRLF
	cQuery += "		D_E_L_E_T_ <>  '*'									               " + CRLF
	cQuery += "		AND D1_FILIAL =  '"	+ _cFilOld  +"'					               " + CRLF
	cQuery += "		AND D1_DOC	 =  '" +   TRB->NFR   +"' AND D1_SERIE = '" + TRB->SERIER + "' AND D1_COD = '"+TRB->PRODUTO+"' " + CRLF 

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMD",.F.,.T.)

	dbSelectArea("TMD")
	dbGoTop()

	If Empty(TMD->D1_DOC) .Or. Eof()
		cAuxError := "------------------------------------------------------------"+ CRLF
		cAuxError += "IMPORTACAO - NF NÃO REALIZADA. " + CRLF
		cAuxError += "MOTIVO: ITEM NAO EXISTENTE NA NOTA FISCAL DA FILIAL ORIGEM " + CRLF
		cAuxError += "NF/SERIE: "+TRB->NFR+"/"+TRB->SERIER+" " + CRLF
		cAuxError += "PRODUTO: "+TRB->PRODUTO+" " + CRLF
		cAuxError += "LOTE: "+TRB->LOTE +" " + CRLF
		cAuxError += "QUANTIDADE: "+STR(TRB->QUANT) +" " + CRLF
		cAuxError += "------------------------------------------------------------"+ CRLF
		GravaLog(cAuxError,cCamArq)
		cAuxError:=""
	Else
		If TMD->D1_UM <> TRB->UM 
			If TMD->D1_UM == POSICIONE("SB1",1,xFilial()+TRB->PRODUTO, "B1_SEGUM")
				IF POSICIONE("SB1",1,xFilial()+TRB->PRODUTO, "B1_TIPCONV")== 'M'
					nValor := TMD->D1_VUNIT * POSICIONE("SB1", 1, xFilial()+TRB->PRODUTO, "B1_CONV")
				Else
					nValor := TMD->D1_VUNIT / POSICIONE("SB1", 1, xFilial()+TRB->PRODUTO, "B1_CONV")
				EndIf
			ElseIf 	TMD->D1_UM == POSICIONE("SB1",1,xFilial()+TRB->PRODUTO, "B1_UM") .AND. TRB->UM == POSICIONE("SB1",1,xFilial()+TRB->PRODUTO, "B1_SEGUM")
				IF POSICIONE("SB1",1,xFilial()+TRB->PRODUTO, "B1_TIPCONV")== 'M'
					nValor := TMD->D1_VUNIT / POSICIONE("SB1", 1, xFilial()+TRB->PRODUTO, "B1_CONV")
				Else
					nValor := TMD->D1_VUNIT * POSICIONE("SB1", 1, xFilial()+TRB->PRODUTO, "B1_CONV")
				EndIf
			EndIf
		Else
			nValor := TMD->D1_VUNIT
		EndIf	

		Aadd(_aLinha,{"D1_COD"          ,TRB->PRODUTO    								 				,Nil})
		Aadd(_aLinha,{"D1_UM"          ,TMD->D1_UM    									      ,Nil})
		Aadd(_aLinha,{"D1_QUANT"     ,TRB->QUANT         												,Nil})
		Aadd(_aLinha,{"D1_VUNIT"     ,nValor     							   			  ,Nil})
		Aadd(_aLinha,{"D1_TOTAL"     , nValor * TRB->QUANT    					  			  ,Nil})
		Aadd(_aLinha,{"D1_LOTECTL"     ,TRB->LOTE        												,Nil})	
		If !Empty(TRB->LOTE)
			Aadd(_aLinha,{"D1_DTVALID"     ,Date()+365        												,Nil})
		Else
			Aadd(_aLinha,{"D1_DTVALID"     ,ctod("")       												,Nil})
		EndIf    	
		Aadd(_aLinha,{"D1_TES"          ,"099"       								  			 ,Nil})
		Aadd(_aLinha,{"D1_FORNECE"     ,TMD->D1_FORNECE 							   			 ,Nil})
		Aadd(_aLinha,{"D1_LOJA"          ,TMD->D1_LOJA      						   			 ,Nil})
		Aadd(_aLinha,{"D1_LOCAL"     ,TMD->D1_LOCAL     							    		 ,Nil})
		Aadd(_aLinha,{"D1_DOC"          ,TRB->NFR   										 		 ,Nil})
		Aadd(_aLinha,{"D1_EMISSAO"     ,TRB->EMISSAO   										 		 ,Nil})
		Aadd(_aLinha,{"D1_TIPO"          ,TMD->D1_TIPO        							     ,Nil})
		Aadd(_aLinha,{"D1_SERIE"     ,TRB->SERIER   									  			,Nil})
		Aadd(_aLinha,{"D1_SEGUM"     ,TMD->D1_SEGUM       							         ,Nil})
		Aadd(_aLinha,{"D1_CF"     ,TMD->D1_CF       							         		,Nil})
		Aadd(_aLinha,{"D1_DESC"     ,TMD->D1_DESC       							        	 ,Nil})
		Aadd(_aLinha,{"D1_DTDIGIT"     ,TMD->D1_DTDIGIT       							     ,Nil})
		Aadd(_aLinha,{"D1_GRUPO"     ,TMD->D1_GRUPO       							         ,Nil})
		Aadd(_aLinha,{"D1_TP"     ,TMD->D1_TP       							      			 ,Nil})
		Aadd(_aLinha,{"D1_NUMSEQ"     ,ProxNum()       							         ,Nil})
		Aadd(_aLinha,{"D1_DATACUS"     ,TMD->D1_DATACUS       							     ,Nil})
		Aadd(_aLinha,{"D1_ORIGLAN"     ,TMD->D1_ORIGLAN       							     ,Nil})
		Aadd(_aLinha,{"D1_LOCPAD"     ,TMD->D1_LOCPAD       							         	,Nil})
		Aadd(_aLinha,{"D1_TIPODOC"     ,TMD->D1_TIPODOC       							         ,Nil})
		Aadd(_aLinha,{"D1_ZZCFOP"     ,TMD->D1_ZZCFOP       							         	,Nil})
		Aadd(_aLinha,{"D1_ZZTES"     ,TMD->D1_ZZTES       							        	 ,Nil})
		Aadd(_aLinha,{"D1_ZZFCI"     ,TMD->D1_ZZFCI       							    	     ,Nil})
		Aadd(_aLinha,{"D1_ZZID"     ,TMD->D1_ZZID       							       			  ,Nil})
		Aadd(_aLinha,{"D1_ZZQCONF"     ,TMD->D1_ZZQCONF       							         ,Nil})
		Aadd(_aLinha,{"D1_ZZCHVNF"     ,TMD->D1_ZZCHVNF       							         ,Nil})
		Aadd(_aLinha,{"D1_ZZNFAUT"     ,TMD->D1_ZZNFAUT       							         ,Nil})
		Aadd(_aLinha,{"D1_ZZSEAUT"     ,TMD->D1_ZZSEAUT       							         ,Nil})
		Aadd(_aLinha,{"D1_ZZITAUT"     ,TMD->D1_ZZITAUT       							         ,Nil})
		Aadd(_aLinha,{"D1_ZZCLAUT"     ,TMD->D1_ZZCLAUT       							         ,Nil})
		Aadd(_aLinha,{"D1_ZZLJAUT"     ,TMD->D1_ZZLJAUT       							         ,Nil})
		Aadd(_aLinha,{"D1_ZZPOEXT"     ,TMD->D1_ZZPOEXT       							         ,Nil})
		Aadd(_aLinha,{"AUTDELETA"      ,"N"     							  				         ,Nil})  
		Aadd(_aItens,_aLinha)
	Endif

	dbSelectArea("TMD")
	DbCloseArea("TMD")

	Return(_aItens)


	************************************
Static Function FazNF(_aCab,_aItens)
	************************************

	If Len(_aCab) > 0 .AND. Len(_aItens) > 0
		lMsErroAuto := MATA103(_aCab,_aItens,3,,,,,,,,) 
		If lMsErroAuto
			Mostraerro("\importInv\", "MostraErro_NF"+_aCab[1][2])+".txt" 
		EndIf
	EndIf

	Return   

	***********************************************
Static Function ExisteNF(_cFilial,_cNF,_cSerie)
	***********************************************

	Local cQuery := ""
	Local _lRet  := .F.

	cQuery:=  " 	SELECT 	F1_DOC                    						           " + CRLF 
	cQuery += " 	FROM  " + RetSqlName("SF1") + " 					          	   " + CRLF
	cQuery += " 	WHERE										 		           	   " + CRLF
	cQuery += "		D_E_L_E_T_ <>  '*'									               " + CRLF
	cQuery += "		AND F1_FILIAL =  '"	+ _cFilNew  +"'					               " + CRLF
	cQuery += "		AND F1_DOC	 =  '" +   _cNF   +"' AND F1_SERIE = '" + _cSerie + "' " + CRLF 

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.F.,.T.)

	dbSelectArea("QRY")
	dbGoTop()

	If !Empty(QRY->F1_DOC)
		cAuxError := "------------------------------------------------------------"+ CRLF
		cAuxError += "IMPORTACAO - NF NÃO REALIZADA. " + CRLF
		cAuxError += "MOTIVO: NF JA EXISTENTE NA FILIAL DESTINO " + CRLF
		cAuxError += "NF/SERIE: "+_cNF+"/"+_cSerie+" " + CRLF
		cAuxError += "------------------------------------------------------------"+ CRLF
		GravaLog(cAuxError,cCamArq)
		cAuxError:=""
		_lRet:=.T.
	EndIf

	dbSelectArea("QRY")
	DbCloseArea("QRY")

	Return(_lRet)

	******************************
Static Function MontaTelaIni()
	******************************

	DEFINE MSDIALOG _oPT00005 FROM  50, 050 TO 300,550 TITLE OemToAnsi('Busca de Arquivo de Enderecos') PIXEL	

	@ 060,063 Button OemToAnsi("Escolhe Arquivo")    Size 056,016 Action (GetArqCsv(@cArqCsv))
	@ 060,126 Button OemToAnsi("Ok")                 Size 056,016 Action (lsaiu:=.F., _oPT00005:End())
	@ 060,189 Button OemToAnsi("Sair")               Size 056,016 Action (lsaiu:=.T., _oPT00005:End(),  cArqCsv:="")

	Activate Dialog _oPT00005 CENTERED

	Return

	********************************
Static Function GetArqCSV(cFile)
	********************************

	cPasta := "\importInv"
	lPasta := ExistDir(cPasta)
	if lPasta==.F.
		MakeDir(cPasta) //cria a pasta     
	end if

	If Empty(cArqCsv)
		cFile := cGetFile(  "Arquivo de Endereco (*.csv) | *.csv",        ;    //Mascara do arquivo 
		"Selecione o Arquivo de Endereços CSV", ,cPasta)
	End if    

	Return cFile  

	**************************************
Static Function GravaLog(cMsg,cCamArq)
	**************************************

	nHandle := fopen(cCamArq,FO_READWRITE + FO_SHARED )

	If nHandle == -1
		MsgStop('Erro de abertura no LOG: FERROR '+str(ferror(),4))
	Else
		FSeek(nHandle, 0, FS_END)     
		fWrite( nHandle, cMsg, len(cMsg))
		fclose(nHandle) // Fecha arquivo
	Endif

Return                  

static function getRastro(cCodProd)
	local oSql	  := IpSqlObject():newIpSqlObject()

return AllTrim(oSql:getFieldValue("SB1","B1_RASTRO","B1_FILIAL = '%SB1.FILIAL%' AND B1_COD = '" + cCodProd + "'"))
