#include "totvs.ch"
#include "dhl.ch"

#define OPC_INCLUSAO   3
#define INTERFACE_NAME "Stock Adjustment"
#Define QUANTIDADE	   2
#Define PRODUTO		   4
#Define LOTE		   8
#Define DTVALID		   9
#Define TIPO		   10
#Define TERCEIRO	   1
#DEFINE PROPRIO		   2


/*/{Protheus.doc} MulXMLInv

Importa o arquivo XML

@author Gustavo Luiz
@since 20/02/2014

@param cFilePath,Caractere,XML a ser importado
@param cApp,Caractere,Se o XML é do Nulogy ou do Select

@return Logico Indica se foi importado com sucesso
/*/
user function MulXMLInv(cFilePath,cApp)
	
	local lOk 	 	       := .F.
	local cError 	       := ""
	local cWarning 	       := ""
	
	private cXmlArq        := cFilePath
	private oLogImp        := DHLLogManager():newDHLLogManager()
	private oXmlIp 	       := IpXmlObject():newIpXmlObject(cXmlArq)
	private oSql	       := IpSqlObject():newIpSqlObject()
	private cApplication   := cApp
	
	private lMsErroAuto    := .F.
	private lMsHelpAuto    := .T.
	private lAutoErrNoFile := .T.
	private lAjustProprio  := .F. //Thiago Meschiatti - FSW TOTVS IP Campinas - 20/12/2016
	private lTemPoder3 	   := .T.
	private lDesmontagem   := .F.
	
	if !(oXmlIp:doParse())
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"Falha ao ler XML"+CRLF+CRLF+"Error: "+oXmlIp:getError()+CRLF+CRLF+"Aviso: "+oXmlIp:getWarning())
		
		return .F.
	endif
	
	if isLayout(APP_NULOGY)
		
		lOk := procXml(APP_NULOGY)
		
	else
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"Não foi possível definir se o arquivo é do Select ou do Nulogy")
	endif
	
return lOk


/**
* Verifica se o Layout refere-se a determinada Aplicação
*/
static function isLayout(cApp)
	
	local lIsLayout := .F.
	local cXml		:= Upper(AllTrim(cXmlArq))
	
	if (cApp == APP_SELECT)
		lIsLayout := DHL_SELECT_STOCK_ADJUSTMENT $ cXml
	elseif (cApp == APP_NULOGY)
		lIsLayout := !(DHL_SELECT_STOCK_ADJUSTMENT $ cXml)
	endif
	
return lIsLayout

/**
* Retorna a query do saldo do produto
*/
Static Function RunQuerySaldo(cProduto)
	
	Local cQuery 	:= ""
	
	cQuery := " SELECT " 								+ CRLF
	cQuery += " * " 									+ CRLF
	cQuery += " FROM "+RetSqlName("SB2") 				+ CRLF
	cQuery += " WHERE "									+ CRLF
	cQuery += " B2_FILIAL = '"+xFilial("SB2")+"' AND "	+ CRLF
	cQuery += " B2_COD = '"+cProduto+"' AND "			+ CRLF
	cQuery += " B2_STATUS !='2'  AND "					+ CRLF
	cQuery += " D_E_L_E_T_ = ' ' "						+ CRLF
	
	cQuery := ChangeQuery(cQuery)

Return cQuery

/**
* Obtém o saldo do PA
*/
Static Function GetSaldo()

	Local cProduto := Padr(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ITEM:text"), TamSx3("B1_COD")[1], "" )
	Local cQuery   := RunQuerySaldo(cProduto)
	Local nSaldoB2 	:= 0
	Local cCursor	:= CriaTrab(, .F.)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)
	dbSelectArea(cCursor)

	nSaldoSB2:=SaldoSB2(,,,,,cCursor)
	
	DbCloseArea(cCursor)

Return nSaldoSB2

/**
* Valida quando a TAG <CUSTOMER> for DHL, se o insumo é próprio
*/
Static Function GetValidacaoInsumo()
	
	Local cCustomer 	:= Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_CUSTOMER:text")))
	Local cProduto		:= Padr(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ITEM:text"), TamSx3("B1_COD")[1], "" )
	Local nTipoInsumo 	:= GetTipoInsumo(cProduto)
	Local lValid		:= .F.
	
	If cCustomer == "DHL" .AND. nTipoInsumo == PROPRIO
		lValid := .T.
	ElseIf cCustomer != "DHL" .AND. nTipoInsumo == TERCEIRO
		lValid := .T.
	Else
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME," Produto " + AllTrim(cProduto) + " não correponde ao tipo de cliente correto. Ex. Quando Cliente for DHL, o produto deve ser um insumo próprio. ")
	EndIf
	
Return lValid


/**
* Processa os Arquivos
*/
static function procXml(cApp)
	
	local lOk  := .F.
	Local  aInsumosPropMod := {}
	Local  aInsumosTerceiro:= {}
	Local  nSaldo		   := 0
	Local nQtdPAInterface  :=  val(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_QUANTITY:text"))
	Local cCodProd  	   := oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ITEM:text")
	
		
	nSaldo := GetSaldo()

	If GetTipoProduto() == "PA"
		If !SubLoteIsEmpty()
			If nSaldo >= nQtdPAInterface
				Begin Transaction
					If u_MulDesmontagem(aInsumosPropMod, aInsumosTerceiro)
						lDesmontagem := .T.
						lOk			 := .T.
					Else
						DisarmTransaction()
					EndIf
				End Transaction
			Else
				oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
				oLogImp:fail(INTERFACE_NAME,"Produto PA " + cCodProd + " sem saldo suficiente para realizar a desmontagem. Saldo no sistema: " + cValToChar(nSaldo) + ". Saldo requerido: " + cValToChar(nQtdPAInterface))
			EndIf
		EndIf
	Else
		If GetValidacaoInsumo()
			if isMovimentoInterno(cApp)
				lOk := geraMovimentoInterno(cApp)
			elseIf isPreNota(cApp)
				lOk := geraPreNota(cApp)
			elseIf isPedidoVenda(cApp)
				lOk := geraPedidoVenda(cApp)
			else
				oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
				oLogImp:fail(INTERFACE_NAME,"Não foi possível definir o movimento de Ajuste a ser gerado")
			EndIf
		EndIf
	EndIf
	
	
return lOk


/**
* Obtém os itens do pedido de vendas 
**/
Static Function GetItensPedVenda(aItens, cProduto, cLote, cExpDate, nQuant)

	Local nI 		:= 0
	Local nTotPrice	:= 0
	Local aAux		:= {}
	Local aItens	:= {}
	Local cCodProd 	:= ""
	local oSql		:= IpSqlObject():newIpSqlObject()
	Local cItem		:= StrZero(0,TamSx3("D1_ITEM")[1])
	
		
	oSql:newTable("SB1","B1_COD,B1_LOCPAD","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+cProduto+"'")
			
	nVUnit := oSql:getFieldValue("SB2","B2_CM1","B2_FILIAL = '"+xFilial("SB2")+"' AND B2_COD = '"+oSql:getValue("B1_COD")+"' AND B2_LOCAL = '"+oSql:getValue("B1_LOCPAD")+"'")
			
	oSql:close()
	
	aAux  := {}
	cItem := Soma1(cItem)
			
	nTotPrice := A410Arred(nQuant * nVUnit ,"C6_VALOR")
	
	aAdd(aAux,{"C6_ITEM"    ,cItem		 	 	,nil})
	aAdd(aAux,{"C6_PRODUTO" ,cProduto		  	,nil})
	aAdd(aAux,{"C6_QTDVEN"  ,nQuant		 	    ,nil})
	aAdd(aAux,{"C6_PRCVEN"  ,nVUnit		 	    ,nil})
	aAdd(aAux,{"C6_VALOR"   ,nTotPrice	 	    ,nil})
	aAdd(aAux,{"C6_QTDLIB"  ,0			 	    ,nil})
	aAdd(aAux,{"C6_TES"     ,GetNewPar("ZZ_TESSAI", ""),nil})
	aAdd(aAux,{"C6_PRUNIT"  , nVUnit,	nil})
	if ProdutControlLote(cProduto)
		aAdd(aAux,{"C6_LOTECTL",Padr(cLote, TamSx3("C6_LOTECTL")[1], ""),nil})
		aAdd(aAux,{"C6_DTVALID",sTod(cExpDate)  						,nil})
	endif
	
	aAdd(aItens,aAux)

Return 

/**
* Verifica se existe amarração dos produtos com o cliente
**/
Static Function IsAmarrProdClient(aInsumos, cCliFor, cLoja, nTipoInsumo)
	
	Local nI 		:= 0
	Local lOk		:= .T.
	Local cTipo		:= ""
	
	For nI := 1 To Len(aInsumos)
		
		cCodProd := aInsumos[nI][PRODUTO]
		cTipo	 := aInsumos[nI][TIPO]
		If !("MOD" $ cCodProd) .AND. !("MO" $ cTipo)
			If !ExistCodProd(@cCliFor, @cLoja, cCodProd, @lOk, nTipoInsumo)
		
				oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
				
				If nTipoInsumo == PROPRIO
					oLogImp:fail(INTERFACE_NAME,"Amarração PRODUTO X CLIENTE não cadastrada." +CRLF+CRLF+"Produto: " + cCodProd)
				ElseIf nTipoInsumo == TERCEIRO
					oLogImp:fail(INTERFACE_NAME,"Amarração PRODUTO X FORNECEDOR não cadastrada." +CRLF+CRLF+"Produto: " + cCodProd)
				EndIf
				lOk := .F.
				exit
			
			EndIf
		EndIf
	
	Next nI

Return lOk


/**
* Obtém o tipo do produto BOM
**/
Static Function GetTipoProduto()
	
	Local cCodProd  := Padr(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ITEM:text"), TamSx3("B1_COD")[1], "" )
	Local aArea		:= GetArea()
	Local aAreaSB1	:= SB1->(GetArea())
	Local cTipo		:= ""
	
	SB1->(DbSetOrder(1))
	
	If SB1->(DbSeek(xFilial("SB1") +  cCodProd))
		cTipo := SB1->B1_TIPO
	EndIf
	
	RestArea(aAreaSB1)
	RestArea(aArea)
	
Return cTipo


/**
* Verifica se a TAG <SUBLOTE> esta vazia
**/
Static Function SubLoteIsEmpty()
	
	Local lEmpty 	:= .F.
	Local cSubLote	:= ""
	
	cSubLote := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SUBLOT:text")))
	
	If Empty(cSubLote)
		lEmpty := .T.
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"TAG SUBLOTE vazio")
	EndIf
	
Return lEmpty

/**
* Verifica se deve gerar uma Pre-Nota
*/
static function isPreNota(cApp)
	
	local lIsPreNota := .F.
	
	if (cApp == APP_SELECT)
		lIsPreNota := Val(oXmlIp:getNodeValue("Pip4C1InventoryReportNotification:_InventoryReport:_InventoryReportLineItem:_InventoryProductQuantity:_ProductQuantity:text"))>0
	elseif (cApp == APP_NULOGY)
		lIsPreNota := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_TYPE:text")))=="P"
	endif
	
return lIsPreNota


/**
* Verifica se deve gerar um pedido de venda
*/
static function isPedidoVenda(cApp)
	
	local lIsPedVenda := .F.
	
	if (cApp == APP_SELECT)
		lIsPedVenda := Val(oXmlIp:getNodeValue("Pip4C1InventoryReportNotification:_InventoryReport:_InventoryReportLineItem:_InventoryProductQuantity:_ProductQuantity:text")) < 0
	elseif (cApp == APP_NULOGY)
		lIsPedVenda := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_TYPE:text"))) == "N"
	endif
	
return lIsPedVenda


/**
* Verifica se deve gerar um movimento interno
*/
static function isMovimentoInterno(cApp)
	
	local lIsMovimentoInterno := .F.
	local cTipoMov := alltrim(GetNewPar("ZZ_TPINVNE", "SD3")) //Thiago Meschiatti - FSW TOTVS IP Campinas - 20/12/2016
	local lNegativ := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_TYPE:text"))) == "N"
	
	if (cApp == APP_NULOGY)
		lIsMovimentoInterno := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_CUSTOMER:text"))) == "DHL"
		
		//INICIO - Thiago Meschiatti - FSW TOTVS IP Campinas - 20/12/2016
		if lIsMovimentoInterno .and. cTipoMov == "SD2" .and. lNegativ
			lAjustProprio 		:= .t.
			lIsMovimentoInterno := .f.
		endif
		//FIM
	endif
	
return lIsMovimentoInterno


/**
* Gera a Pre-Nota de Entrada
*/
static function geraPreNota(cApp)
	
	local lOk    := .F.
	local aCab   := {}
	local aItens := {}
	local cErro  := ""
	
	If getDadosPreNota(cApp,@aCab,@aItens)
		
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| MATA140(x,y,z)},aCab,aItens,OPC_INCLUSAO)
		
		if lMsErroAuto
			RollBackSX8()
			
			cErro := mostraErroRotAuto()
			
			oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
			oLogImp:fail(INTERFACE_NAME,"Erro de rotina automática"+CRLF+CRLF+cErro)
		else
			ConfirmSX8()
			
			lOk := .T.
		endif
		
	EndIf
	
return lOk


/**
* Gera o pedido de venda
*/
static function geraPedidoVenda(cApp)
	
	local lOk    := .F.
	local aCab   := {}
	local aItens := {}
	local cErro  := ""
	
	lOk := getDadosPedVenda(cApp,@aCab,@aItens)
	
	if !(lTemPoder3)
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"Não há saldo em poder de terceiros para os itens do pedido "+CRLF+CRLF+cErro)
		return
	endif
	
	if lOk
	
		lOk := .F.
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| MATA410(x,y,z)},aCab,aItens,OPC_INCLUSAO)
		
		if lMsErroAuto
			cErro := mostraErroRotAuto()
			
			oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
			oLogImp:fail(INTERFACE_NAME,"Erro de rotina automática"+CRLF+CRLF+cErro)
		else
			lOk := .T.
		endif
	endif
	
return lOk


/**
* Gera o movimento interno
*/
static function geraMovimentoInterno(cApp)
	
	local lOk    := .F.
	local aDados := {}
	local aItens := {}
	local cErro  := ""
	
	getDadosMovInterno(cApp,@aDados,@aItens)
	
	lMsErroAuto := .F.
	//MSExecAuto({|x,y| MATA240(x,y)},aDados,OPC_INCLUSAO)
	MSExecAuto({|x,y,z| MATA241(x,y,z)},aDados,aItens,OPC_INCLUSAO)
	if lMsErroAuto
		cErro := mostraErroRotAuto()
		
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"Erro de rotina automática"+CRLF+CRLF+cErro)
	else
		lOk := .T.
	endif
	
return lOk


/**
* Obtem as arrays da rotina automática de mov. interno
*/
static function getDadosMovInterno(cApp,aDados,aItens)
	
	local cControle  := ""
	local cCodProd 	 := ""
	local cCnpj 	 := ""
	local cFilialNum := ""
	local cTM		 := ""
	local nQuant 	 := 0
	local nI		 := 0
	local aItensXML  := {}
	local aItemAux	 := {}
	Local cLote	 	 := ""
	Local cExpDate	 := ""
	
	if (cApp == APP_NULOGY)
		
		if Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_TYPE:text"))) == "P"
			cTM := GetMV("ZZ_TMDEV")
		else
			cTM := GetMV("ZZ_TMREQ")
		endif
		
		aItensXML := oXmlIp:getNodeArray("STK_ADJ:_BODY:_FILEHEADER")
		
		for nI := 1 to Len(aItensXML)
			
			cCodProd  := AllTrim(aItensXML[nI]:_ITEM:text)
			cCnpj     := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SITE_CNPJ:text"))
			
			nQuant    := Val(aItensXML[nI]:_QUANTITY:text)
			cControle := oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ADJUSTMENT_ID:text")

			if nI == 1
				aDados := {{"D3_FILIAL"  ,xFilial("SD3"),nil},;
					{"D3_DOC"     ,"INVENT" 	 ,nil},;
					{"D3_TM"      ,cTM 			 ,nil},;
					{"D3_EMISSAO" ,dDataBase 	 ,nil}}
			endif

			aAdd(aItemAux,{"D3_COD"     ,cCodProd      ,nil})
			aAdd(aItemAux,{"D3_QUANT"   ,nQuant 		 ,nil})
			aAdd(aItemAux,{"D3_ZZADJID" ,cControle     ,nil})

			If ProdutControlLote(cCodProd)
				cLote	  := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_LOT:text"))
				cExpDate  := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_EXPIRATION_DATE:text"))
				
				cExpDate := "20" + right(cExpDate, 2) + substr(cExpDate, 3, 2) + left(cExpDate, 2) 
				
				aAdd(aItemAux,{"D3_LOTECTL"     ,Padr(cLote, TamSx3("D3_LOTECTL")[1], "")     ,nil})
				aAdd(aItemAux,{"D3_DTVALID"     ,sTod(cExpDate)		 						,nil})
				
			EndIf

			aadd(aItens, aItemAux)
			
			aDados := FwVetByDic(aDados, "SD3")
			aItens := FWVetByDic( aItens , "SD3" , .T. )
			
		next
		
	endif
	
return


/**
* Obtem as arrays da rotina automática de pré nota
*/
static function getDadosPreNota(cApp,aCab,aItens)
	
	local cControle  := ""
	local cCodProd 	 := ""
	local cCnpj 	 := ""
	local cFilialNum := ""
	local cSerie 	 := DHL_SERIE_INVENTARIO
	local cTipoNf  	 := SuperGetMv("MV_TPNRNFS")
	local cFornece	 := ""
	local cLoja		 := ""
	local cNumero	 := ""
	local cLote		 := ""
	local cExpDate	 := ""
	local cManufDt	 := ""
	local cItem 	 := StrZero(0,TamSx3("D1_ITEM")[1])
	local cTipo		 := "B"
	local cTes		 := GetMv("ZZ_TESENT")
	local nQuant 	 := 0
	local aAux 		 := {}
	local aItensXML  := {}
	local nVUnit 	 := 0
	local nTotPrice	 := 0
	Local lOk		 := .T.
	Local nTipoInsumo:= 0
		
	if (cApp == APP_NULOGY)
		
		cCodProd  := oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ITEM:text")
		cControle := oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ADJUSTMENT_ID:text")
		cCnpj     := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SITE_CNPJ:text"))
		
		If ProdutControlLote(cCodProd)
		
			cLote	  := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_LOT:text"))
			cExpDate  := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_EXPIRATION_DATE:text"))
			cManufDt  := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_MANUFACTURE_DATE:text"))
			
			cExpDate := "20" + right(cExpDate, 2) + substr(cExpDate, 3, 2) + left(cExpDate, 2) 
			cManufDt := "20" + right(cManufDt, 2) + substr(cManufDt, 3, 2) + left(cManufDt, 2) 
		
		EndIf
		
		nTipoInsumo := GetTipoInsumo(cCodProd) //1 ->TERCEIRO 2 -> PROPRIO
		
		If lOk
			
			cNumero := NxtSX5Nota(cSerie, NIL, cTipoNf)
			
			aAdd(aCab,{"F1_FILIAL"  ,xFilial("SF1")  			  ,nil})
			aAdd(aCab,{"F1_DOC"     ,cNumero				 	  ,nil})
			aAdd(aCab,{"F1_SERIE"   ,cSerie       				  ,nil})
			aAdd(aCab,{"F1_FORNECE" ,Left(GetMv("ZZ_CLINTEG"),6)  ,nil})
			aAdd(aCab,{"F1_LOJA"    ,Right(GetMv("ZZ_CLINTEG"),2) ,nil})
			aAdd(aCab,{"F1_EMISSAO" ,dDataBase 		              ,nil})
			aAdd(aCab,{"F1_TIPO"    ,"B"       		              ,nil})
			aAdd(aCab,{"F1_FORMUL"  ,"S"       		              ,nil})
			aAdd(aCab,{"F1_ESPECIE" ,"INV"      		          ,nil})
			aAdd(aCab,{"F1_ZZADJID"	,cControle 		              ,nil})
			aAdd(aCab,{"F1_ZZSTATU"	, DHL_DOC_PENDENTE_ACAO       ,nil})
			
			aItensXML := oXmlIp:getNodeArray("STK_ADJ:_BODY:_FILEHEADER")
			
			for nI := 1 to Len(aItensXML)
				
				cCodProd 	:= AllTrim(aItensXML[nI]:_ITEM:text)
				nQuant   	:= Val(aItensXML[nI]:_QUANTITY:text)
				nVUnit		:= retVUnit(cCodProd, cLote)
				aAux  		:= {}
				cItem 		:= Soma1(cItem)
				
				nTotPrice := A410Arred(nQuant * nVUnit ,"D1_TOTAL")
				if nTotPrice < 0.01
					nTotPrice   := 0.01
					nVUnit 		:= A410Arred(nTotPrice / nQuant ,"D1_VUNIT")
				endif
				
				aAdd(aAux,{"D1_ITEM"  ,cItem		 	 ,nil})
				aAdd(aAux,{"D1_COD"   ,cCodProd	 	 	 ,nil})
				aAdd(aAux,{"D1_QUANT" ,nQuant		 	 ,nil})
				aAdd(aAux,{"D1_VUNIT" ,nVUnit		 	 ,nil})
				aAdd(aAux,{"D1_TOTAL" ,nTotPrice	 	 ,nil})
				aAdd(aAux,{"D1_ZZTES" ,cTes				 ,nil})
				if !empty(cLote)
					aAdd(aAux,{"D1_LOTECTL"	,cLote			 ,nil})
					aAdd(aAux,{"D1_DTVALID"	,sTod(cExpDate)	 ,nil})
					aAdd(aAux,{"D1_ZZDFABR"	,sTod(cManufDt)	 ,nil})
				endif
				
				aAux := FwVetByDic(aAux, "SD1")
				
				aAdd(aItens,aAux)
				
			next
		EndIf
	EndIf
	
return lOk


/**
* Obtem as arrays da rotina automática de pedido de venda
*/
static function getDadosPedVenda(cApp,aCab,aItens)
	
	local cControle  	:= ""
	local cProduto 	 	:= ""
	local cCliFor	 	:= "" //Thiago Meschiatti - FSW TOTVS IP Campinas - 20/12/2016
	local cLoja		 	:= "" //Thiago Meschiatti - FSW TOTVS IP Campinas - 20/12/2016
	local nQuant 	 	:= 0
	local cItem 	 	:= StrZero(0,TamSx3("C6_ITEM")[1])
	local aAux 		 	:= {}
	local aItensXML  	:= {}
	local cCnpj 	 	:= ""
	local cFilialNum 	:= ""
	local nVUnit 	 	:= 0
	local nTotPrice	 	:= 0
	local lOk		 	:= .t. //Thiago Meschiatti - FSW TOTVS IP Campinas - 21/12/2016
	local oSql			:= IpSqlObject():newIpSqlObject()
	local oSqlCli		:= IpSqlObject():newIpSqlObject()
	Local nTipoInsumo	:= ""
	Local cCustomer		:= Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_CUSTOMER:text")))
	
	If (cApp == APP_NULOGY)
		
		cCnpj       := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SITE_CNPJ:text"))
		cLote		:= oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_LOT:text")
		cSubLote	:= oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SUBLOT:text")
		cProduto	:= oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ITEM:text")
		nQuant 		:= val(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_QUANTITY:text"))
		cExpDate  	:= AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_EXPIRATION_DATE:text"))
		cManufDt  	:= AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_MANUFACTURE_DATE:text"))
		
		cExpDate := "20" + right(cExpDate, 2) + substr(cExpDate, 3, 2) + left(cExpDate, 2) 
		cManufDt := "20" + right(cManufDt, 2) + substr(cManufDt, 3, 2) + left(cManufDt, 2) 
		
		//RETORNA O CLIENTE DHL DE ACORDO COM O CGC DO  SM0->M0_CGC
		If cCustomer == "DHL"
			
			nTipoInsumo := GetTipoInsumo(cProduto)
			lOk 		:= retCliDhl(@cCliFor, @cLoja)
			
			If lOk
			
				aCab 		:= GetCabecalho(cCliFor, cLoja, nTipoInsumo)
				getItensDhl(aItens, cCliFor, cLoja)
			
			Else
			
				oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
				oLogImp:fail(INTERFACE_NAME,"Não foi possível localizar o cliente DHL com o seguinte CGC: " + SM0->M0_CGC)
			
			EndIf
		
		ElseIf cCustomer != "DHL"
			nTipoInsumo := GetTipoInsumo(cProduto)
		
			cCliFor := Left(GetMv("ZZ_CLINTEG"),6) 
			cLoja	:= Right(GetMv("ZZ_CLINTEG"),2)
		
			aCab := GetCabecalho(cCliFor, cLoja, nTipoInsumo)
		
			GetItensPedVenda(aItens, cProduto, cLote, cExpDate, nQuant)
		
		EndIf
				
	EndIf
	
return (lOK)

/**
* Verifica se existe amarração Produto x Cliente
**/
Static Function ExitProdxCliente(cProduto, cCliForParam, cLojaParam)
	
	Local oSqlSA7 	:= IpSqlObject():newIpSqlObject()
	Local lExist	:= .F.
	Local cCliente	:= cCliForParam
	Local cLoja		:= cLojaParam
	
	oSqlSA7:newTable("SA7","A7_CLIENTE, A7_LOJA","A7_FILIAL = '"+xFilial("SA7")+"' AND A7_PRODUTO = '"+cProduto+"' AND A7_CLIENTE = '"+cCliente+"' AND A7_LOJA = '"+cLoja+"'")
		
	cCliente  := oSqlSA7:GetValue("A7_CLIENTE")
	cLoja	 := oSqlSA7:GetValue("A7_LOJA")
	
	If !Empty(cCliente)
		lExist := .T.
	Else
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"Produto : " + cProduto + " não amarrado ao cliente " + cCliForParam + " loja " + cLojaParam)
	EndIf
		
	oSql:close()

Return lExist


/**
* Retorna se é um produto de terceiro ou próprio
* 1 - Terceiro
* 2 - Próprio
**/
Static Function GetTipoInsumo(cCodProd)

	Local oSqlSB1 	:= IpSqlObject():newIpSqlObject()
	Local cAgregCu	:= ""
	Local nAgregCu	:= 0
	
	oSqlSB1:newTable("SB1","B1_COD,B1_LOCPAD, B1_AGREGCU","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+cCodProd+"'")
				
	cAgregCu := oSqlSB1:getFieldValue("SB1","B1_AGREGCU","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+oSqlSB1:getValue("B1_COD")+"'")
	
	If !Empty(cAgregCu)
		nAgregCu := Val(cAgregCu)
	EndIf
				
	oSqlSB1:Close()
	
Return nAgregCu


/**
* Obtém os itens de insumo próprio quando resultado da desmontagem
**/
Static Function GetItensInsumPropDesm(aItens, cCliFor, cLoja, cCodProd, nQuant)

	local cControle  := ""
	local cCliente	 := ""
	local cLoja		 := ""
	local cItem 	 := StrZero(0,TamSx3("C6_ITEM")[1])
	local aAux 		 := {}
	local aItensXML  := {}
	local cCnpj 	 := ""
	local cFilialNum := ""
	local nVUnit 	 := 0
	local nTotPrice	 := 0
	local lOk		 := .t.
	local nI		 := 0
	local oSql		 := IpSqlObject():newIpSqlObject()
	

	If (cApplication == APP_NULOGY)
		
		if lOk
				
				
			oSql:newTable("SB1","B1_COD,B1_LOCPAD","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+cCodProd+"'")
				
			nVUnit 	:= oSql:getFieldValue("SB2","B2_CM1","B2_FILIAL = '"+xFilial("SB2")+"' AND B2_COD = '"+oSql:getValue("B1_COD")+"' AND B2_LOCAL = '"+oSql:getValue("B1_LOCPAD")+"'")
				
			oSql:close()
			
			aAux  := {}
			cItem := Soma1(cItem)
				
			nTotPrice := A410Arred(nQuant * nVUnit ,"C6_VALOR")
				
			aAdd(aAux,{"C6_ITEM"    ,cItem		 	 	,nil})
			aAdd(aAux,{"C6_PRODUTO" ,cCodProd		  	,nil})
			aAdd(aAux,{"C6_QTDVEN"  ,nQuant		 	    ,nil})
			aAdd(aAux,{"C6_PRCVEN"  ,nVUnit		 	    ,nil})
			aAdd(aAux,{"C6_VALOR"   ,nTotPrice	 	    ,nil})
			aAdd(aAux,{"C6_QTDLIB"  ,0			 	    ,nil})

			if lAjustProprio  //Thiago Meschiatti - FSW TOTVS IP Campinas - 21/12/2016
				aAdd(aAux,{"C6_TES"     , GetNewPar("ZZ_TESINVN", ""),nil})
				aAdd(aAux,{"C6_PRUNIT"  , nVUnit,	nil})
			else
				aAdd(aAux,{"C6_TES"     , GetNewPar("ZZ_TESSAI", ""),nil})
			endif
		
			aAdd(aItens,aAux)
			
		endif
	endif

Return

/**
* Coleta a Tes a ser utilizada
**/
static function getTes(oSql, cEspecNf)

	local cTes := ""
	
	default cEspecNf := ""
	
	if (upper(alltrim(cEspecNf)) ==  DHL_ESPECIE_INVENTARIO)
		cTes := AllTrim(GetMv("ZZ_TESINV"))
	else
		cTes := oSql:getValue("F4_TESDV")
	endif
	
return cTes

/**
* Obtém os itens quando insumo próprio e type = N
**/
Static Function getItensDhl(aItens, cCliFor, cLoja)
	
	local cControle  := ""
	local cCodProd 	 := ""
	local cCliente	 := ""
	local cLoja		 := ""
	local nQuant 	 := 0
	local cItem 	 := StrZero(0,TamSx3("C6_ITEM")[1])
	local aAux 		 := {}
	local aItensXML  := {}
	local cCnpj 	 := ""
	local cFilialNum := ""
	local nVUnit 	 := 0
	local nTotPrice	 := 0
	local lOk		 := .t.
	local nI		 := 0
	local oSql		 := IpSqlObject():newIpSqlObject()
	
	local cLote	  	:= ""
	local cExpDate  := ""
	local cManufDt  := ""
	

	If (cApplication == APP_NULOGY)
		
		if lOk
			
			aItensXML := oXmlIp:getNodeArray("STK_ADJ:_BODY:_FILEHEADER")
			
			for nI := 1 to Len(aItensXML)
			
				cCodProd := AllTrim(aItensXML[nI]:_ITEM:text)
				nQuant   := Val(aItensXML[nI]:_QUANTITY:text)
				
				If ProdutControlLote(cCodProd)
				
					cLote	  := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_LOT:text"))
					cExpDate  := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_EXPIRATION_DATE:text"))
					cManufDt  := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_MANUFACTURE_DATE:text"))
					
					cExpDate := "20" + right(cExpDate, 2) + substr(cExpDate, 3, 2) + left(cExpDate, 2) 
					cManufDt := "20" + right(cManufDt, 2) + substr(cManufDt, 3, 2) + left(cManufDt, 2) 
				
				EndIf
				
				oSql:newTable("SB1","B1_COD,B1_LOCPAD","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+cCodProd+"'")
				
				nVUnit 	:= oSql:getFieldValue("SB2","B2_CM1","B2_FILIAL = '"+xFilial("SB2")+"' AND B2_COD = '"+oSql:getValue("B1_COD")+"' AND B2_LOCAL = '"+oSql:getValue("B1_LOCPAD")+"'")
				
				oSql:close()
			
				aAux  := {}
				cItem := Soma1(cItem)
				
				nTotPrice := A410Arred(nQuant * nVUnit ,"C6_VALOR")
				
				aAdd(aAux,{"C6_ITEM"    ,cItem		 	 	,nil})
				aAdd(aAux,{"C6_PRODUTO" ,cCodProd		  	,nil})
				aAdd(aAux,{"C6_QTDVEN"  ,nQuant		 	    ,nil})
				aAdd(aAux,{"C6_PRCVEN"  ,nVUnit		 	    ,nil})
				aAdd(aAux,{"C6_VALOR"   ,nTotPrice	 	    ,nil})
				aAdd(aAux,{"C6_QTDLIB"  ,0			 	    ,nil})
				if !empty(cLote)
					aAdd(aAux,{"C6_LOTECTL",Padr(cLote, TamSx3("C6_LOTECTL")[1], ""),nil})
					aAdd(aAux,{"C6_DTVALID",sTod(cExpDate)  						,nil})
				endif

				if lAjustProprio
					aAdd(aAux,{"C6_TES"     , GetNewPar("ZZ_TESINVN", ""),nil})
					aAdd(aAux,{"C6_PRUNIT"  , nVUnit,	nil})
				else
					aAdd(aAux,{"C6_TES"     , GetNewPar("ZZ_TESSAI", ""),nil})
				endif
				
				aAux := FwVetByDic(aAux, "SC6")
				
				aAdd(aItens,aAux)
				
			next
		endif
	endif

Return lOk

/**
* Obtém o cabeçalho
**/
Static Function GetCabecalho(cCliFor, cLoja, nTipoInsumo)
	
	local cControle := oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ADJUSTMENT_ID:text")
	Local aCab 		:= {}

	aAdd(aCab,{"C5_FILIAL"  ,xFilial("SC5") 			  ,nil})
	aAdd(aCab,{"C5_TIPO" 	,"N"       					  ,nil})
	aAdd(aCab,{"C5_CLIENTE" ,cCliFor  					  ,nil})
	aAdd(aCab,{"C5_LOJACLI" ,cLoja 						  ,nil})
	aAdd(aCab,{"C5_CONDPAG"	,AllTrim(getMv("ZZ_CONDINT")) ,nil})
	aAdd(aCab,{"C5_ZZADJID"	,cControle 		              ,nil})
	aAdd(aCab,{"C5_ZZESPEC" ,"INV"       		          ,nil})
	
	If nTipoInsumo == PROPRIO
		aAdd(aCab,{"C5_ZZTAJES" ,"P"       		          ,nil})
	Else
		aAdd(aCab,{"C5_ZZSTATU", DHL_PV_PENDENTE_INFORMACAO   ,nil})
	EndIf
	
Return aCab

/**
* Inclui conteúdo no array de alteração da rotina automática. Para contemplar todos os campos.
**/
static function montaItens(aAux)
	
	local nCount	:= 0
	local aCposSX3	:= FWSX3Util():GetAllFields("SC6",.f.)
	
	for nCount := 1 to len(aCposSX3)
	
		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U"
			aAdd(aAux,{AllTrim(aCposSX3[nCount]),&("SC6->" + AllTrim(aCposSX3[nCount])),nil})
		endIf
	
	next nCount
	
return


/**
 * Obtém o saldo do cliente
 */
static function getCliSld(nQuant, cCodProd, cLote, cExpDate, cCliFor, cLoja)

	local cQuery := ""
	
	cQuery := "SELECT B6_CLIFOR,B6_LOJA,B6_EMISSAO "
	cQuery += "       "
	cQuery += "FROM " + RetSqlName("SB6") + " SB6 "
	cQuery += "INNER JOIN %SD1.SQLNAME% ON "
	cQuery += "		D1_FILIAL 	= B6_FILIAL "
	cQuery += "		AND D1_COD 		= B6_PRODUTO "
	if empty(cLote)
		cQuery += "       AND D1_LOTECTL    = '" + CriaVar("D1_LOTECTL", .f.) + "'  "
	else
		cQuery += "      D1_LOTECTL    = '" + cLote + "' "
		cQuery += "      AND D1_DTVALID    = '" + cExpDate + "' "
	endif
	cQuery += "WHERE B6_FILIAL = '" + xFilial("SB6") + "' AND "
	cQuery += "      B6_PODER3 = 'R' AND "
	cQuery += "      B6_TIPO   = 'D' AND "
	cQuery += "      B6_TPCF   = 'C' AND "
	
	cQuery += "      B6_CLIFOR   = '"+cCliFor+"' AND "
	cQuery += "      B6_LOJA   	= '"+cLoja+"' AND "
	
	cQuery += "      B6_PRODUTO   = '" + cCodProd + "' AND "
	cQuery += "      B6_SALDO  >= " + str(nQuant)+  " AND "
	cQuery += " 	 SB6.D_E_L_E_T_ = ' '  "
	cQuery += "GROUP BY "
	cQuery += " 	B6_PRODUTO, B6_CLIFOR, B6_LOJA, B6_EMISSAO "
//	cQuery += "ORDER BY B6_EMISSAO "
	if empty(cLote)
		cQuery += " ORDER BY B6_EMISSAO "
	else
		cQuery += " ORDER BY D1_DTVALID "
	endif

return (cQuery)

/**
 * Obtem a query dos itens do pedido de venda
 */
static function getQueryItens(cCliFor, cLoja, cCodProd, cLote, cExpDate)

	local cQuery := ""
	
	cQuery += " SELECT *	"                  			 				 				+CRLF
	cQuery += " 	FROM %SD1.SQLNAME%"                   				 				+CRLF
	cQuery += " INNER JOIN %SF4.SQLNAME% ON"                   						    +CRLF
	cQuery += " 	F4_FILIAL = '%SF4.FILIAL%' AND"                   	 				+CRLF
	cQuery += " 	SF4.F4_CODIGO = SD1.D1_TES AND"                      				+CRLF
	cQuery += " 	%SD1.NOTDEL%"                   			 		 				+CRLF
	cQuery += " INNER JOIN %SB1.SQLNAME% ON"                   						    +CRLF
	cQuery += " 	SB1.B1_FILIAL = '%SB1.FILIAL%' AND"                   	 			+CRLF
	cQuery += " 	SB1.B1_COD =  SD1.D1_COD AND"                      					+CRLF
	cQuery += " 	%SB1.NOTDEL%"                   			 		 				+CRLF
	cQuery += " INNER JOIN %SB2.SQLNAME% ON"                   						    +CRLF
	cQuery += " 	SB2.B2_FILIAL = '%SB2.FILIAL%' AND"                   	 			+CRLF
	cQuery += " 	SB2.B2_COD =   SB1.B1_COD  AND"                      				+CRLF
	cQuery += " 	SB2.B2_LOCAL = SB1.B1_LOCPAD AND"                      				+CRLF
	cQuery += " 	%SB2.NOTDEL%"                   			 		 				+CRLF
	
	cQuery += " INNER JOIN %SB6.SQLNAME% ON"                   						    +CRLF	
	
	If empty(cLote)
		cQuery += "      B6_CLIFOR = '" + cCliFor + "' AND "
		cQuery += "      B6_LOJA   = '" + cLoja + "' AND "
	endIf
	
	cQuery += " 	SB6.B6_FILIAL = '%SB6.FILIAL%' AND"                   	 			+CRLF
	cQuery += " 	SB6.B6_PODER3 = 'R'   AND"                      					+CRLF
	cQuery += " 	SB6.B6_TPCF = 'C' AND"                      						+CRLF
	cQuery += " 	SB6.B6_TIPO = 'D' AND"                      						+CRLF
	cQuery += " 	SB6.B6_SALDO > 0 AND"                      							+CRLF
	cQuery += " 	SB6.B6_TES = SD1.D1_TES AND"                      					+CRLF
	cQuery += " 	SB6.B6_IDENT =  SD1.D1_NUMSEQ AND"                      			+CRLF
	cQuery += " 	%SB6.NOTDEL%"                   			 		 				+CRLF
		
	cQuery += " WHERE D1_FILIAL = '%SD1.FILIAL%' AND" 					 	 			+CRLF
	cQuery += " D1_COD = '"+cCodProd+"' AND" 					 	 					+CRLF
	
	If empty(cLote)
		cQuery += "		D1_LOTECTL    = '" + CriaVar("D1_LOTECTL", .f.) + "'  AND " 	+CRLF
	Else
		cQuery += "		D1_LOTECTL    = '" + cLote + "'  AND "					    	+CRLF
		cQuery += "		D1_DTVALID    = '" + cExpDate + "' AND "				 		+CRLF
	EndIf	
	
	cQuery += "		%SD1.NOTDEL%"                   		 				 			+CRLF
	
	If empty(cLote)
		cQuery += "	ORDER BY D1_EMISSAO "											 	+CRLF
	Else
		cQuery += " ORDER BY D1_DTVALID "											 	+CRLF
	EndIf
	
	// FIFO
	// COM LOTE: PROD + LOTE + DATA DE VALID.
	// SEM LOTE: PROD + DATA DO DOCUMENTO
	MemoWrite("Saldo3.txt",oSql:ParseQuery(cQuery))
	
return cQuery

/**
*	Função que bucas o cliente/fornecedor na tabela SA7 (Amarração Produto X Cliente) de acordo com o código do produto
**/
Static Function ExistCodProd(cCliFor, cLoja, cCodProd, lOk, nTipoInsumo)
	
	Local oSqlSA7 	:= IpSqlObject():newIpSqlObject()
	Local cCustomer	:= Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_CUSTOMER:text")))
	Local cCnpj		:= ""
	
	If cCustomer != "DHL" .AND. lDesmontagem == .F.
		
		oSqlSA7:newTable("SA7","A7_CLIENTE, A7_LOJA","A7_FILIAL = '"+xFilial("SA7")+"' AND A7_PRODUTO = '"+cCodProd+"'")
		
		cCliFor  := oSqlSA7:GetValue("A7_CLIENTE")
		cLoja	 := oSqlSA7:GetValue("A7_LOJA")
		
		oSql:close()
		
		If Empty(cCliFor)
			
			lOk := .F.
			oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
			oLogImp:fail(INTERFACE_NAME,"Produto " + cCodProd + " não possui amarração com Cliente")
			
		EndIf
		
	ElseIf cCustomer == "DHL" .AND. lDesmontagem == .F.
	
		cCnpj     := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SITE_CNPJ:text"))
		lOk := retCliDhl(@cCliFor, @cLoja)
		
	ElseIf 	lDesmontagem .AND. nTipoInsumo == TERCEIRO
	
		oSqlSA7:newTable("SA7","A7_CLIENTE, A7_LOJA","A7_FILIAL = '"+xFilial("SA7")+"' AND A7_PRODUTO = '"+cCodProd+"'")
		
		cCliFor  := oSqlSA7:GetValue("A7_CLIENTE")
		cLoja	 := oSqlSA7:GetValue("A7_LOJA")
		
		oSql:close()
		
		If Empty(cCliFor)
			
			lOk := .F.
			oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
			oLogImp:fail(INTERFACE_NAME,"Produto " + cCodProd + " não possui amarração com Cliente")
			
		EndIf
	
	ElseIf lDesmontagem .AND. nTipoInsumo == PROPRIO
		lOk := retCliDhl(@cCliFor, @cLoja)
	EndIf
	
Return lOk


/**
*	Função responsável pelo retorno da filial de acordo com o CNPJ.
*/
/*static function retFilial(cCNPJ)
local cFilialNum:= ""
local aArea		:= GetArea()
local aAreaSM0	:= SM0->(GetArea())

DbSelectArea("SM0")
SM0->(DBGoTop())

while SM0->(!eof())
	if alltrim(SM0->M0_CGC) == alltrim(cCNPJ)
		cFilialNum	:= alltrim(SM0->M0_CODFIL)
		exit
	endif
	SM0->(dbSkip())
endDo

restArea(aAreaSM0)
restArea(aArea)

return	cFilialNum*/


/**
*	Retorna o erro da rotina automática
*/
static function mostraErroRotAuto()
	
	local aErro  := {}
	local nI 	 := 0
	local cError := ""
	
	aErro := GetAutoGRLog()
	
	    for nI := 1 to Len(aErro)
	    	cError += aErro[nI] +CRLF
	    next nI
	
return cError


/*
** Retorna valor unitário através de LIFO
*/
static function retVUnit(cCodProd, cLote)
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local cQuery 	:= ""
	local nRet		:= 0
	
	cQuery += " Select * from (SELECT MAX(SD1.R_E_C_N_O_) RECNO, D1_VUNIT FROM %SD1.SQLNAME%       "+CRLF
	cQuery += " WHERE                                                                            "+CRLF
	cQuery += " 	%SD1.NOTDEL%                                                                 "+CRLF
	cQuery += " 	AND %SD1.XFILIAL%                                                            "+CRLF
	cQuery += " 	AND D1_COD 			= '"+cCodProd+"'                                         "+CRLF
	if !empty(cLote)
		cQuery += " 	AND D1_LOTECTL 			= '"+cLote+"'                                    "+CRLF
	endif
	cQuery += " GROUP BY D1_VUNIT Order by RECNO DESC) Where rownum = 1   "+CRLF
	
	oSqlUtil:newAlias(cQuery)
	
	nRet := oSqlUtil:getValue("D1_VUNIT")
	
	oSqlUtil:close()
return(nRet)


/*
** Retorna cliente e loja
*/
static function retCliDhl(cCliente, cLoja)
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cQuery 	:= ""
	local lOk		:= .t.
	Local cQuery	:= ""
	
	cQuery := "%SA1.XFILIAL% AND A1_CGC = '" + SM0->M0_CGC + "'
	
	oSql:newTable("SA1", "A1_COD, A1_LOJA", cQuery)
	
	if oSql:hasRecords()
		cCliente := oSql:getValue("A1_COD")
		cLoja	 := oSql:getValue("A1_LOJA")
	else
		lOk := .f.
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"Cliente DHL não localizado. CNPJ: " + SM0->M0_CGC)
	endif
	
	oSql:close()
	
return (lOk)

/**
* Verifica se o produto controla lote
**/
Static Function ProdutControlLote(cProduct)
	
	local oSql				:= IpSqlObject():newIpSqlObject()
	Local cControlLote		:= ""
	Local lControla			:= .T.
	
	cControlLote := oSql:getFieldValue("SB1","B1_RASTRO","B1_FILIAL = '%SB1.FILIAL%' AND B1_COD = '" + cProduct + "'")
	
	If cControlLote == "N"
		lControla := .F.
	EndIf
	
	oSql:close()
	
Return lControla
