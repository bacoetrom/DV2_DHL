#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"

#define PRODUCT_BOM  1
#define QUANTITY_BOM 2
#define WORK_ORDER   3
#define FILEITEM     4

#define PRODUCT      1
#define QUANTITY     2

#define RETORNO_EFETIVO "RE"
#define RETORNO_SIMBOLICO "RS"


/*/{Protheus.doc} AgeInvReq

Rotina responsável por ler e processar a interface Invoice Request e atualizar os dados referentes ao documento.
Processo para Unidade de Negócio AGE(HP).

@author Gustavo Luiz
@since 19/08/2016

@param cFilePath, String, Arquivo a ser processado
/*/
user function AgeInvReq(cFilePath)
	
	local lValid        := .T.
	local nBom          := 0
	local lOk			:= .T.
	
	private oLogImp     := DHLLogManager():newDHLLogManager()
	private cShipping   := getShipping()
	private cCnpjCli    := getCnpjCustomer()
	private cSalesOrd   := getSalesOrder()
	private cFile       := cFilePath
	private cProds		:= ""
	private aProducts   := retProducts()
	private lMsErroAuto := .F.
	
	private aDetails2        := {}
	private aDetails         := {}
	private cCliFor			 := ""
	private cLoja			 := ""
	private	cEmail			 := ""
	private cProductionOrder := ""
	private cIdOp			 := ""
	private cItem            := ""
	private cDeliveryCust	 := ""
	private cBranchCust		 := ""
	private lNewAge          := SuperGetMV("ZZ_NEWAGE",,.F.)
	private lAutomatic       := SuperGetMV("ZZ_AUTOMAT",,.F.)
	
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Inicio do processamento da Rotina...", 0, 0, {})
	
	BEGIN TRANSACTION
		BEGIN SEQUENCE
		if cFilAnt == AGE_MONDELEZ .and. getTipoNota() == RETORNO_EFETIVO				 
					
				lOk := U_MondRetEfetivo(cFilePath)
				
			elseIf cFilAnt == AGE_MONDELEZ .and. getTipoNota() == RETORNO_SIMBOLICO					
				
				lOk := U_MondRetSimbolico(cFilePath)
				
			else	
		
			if incCustomer()
				lOk := incOutflowOrder()
			else
				DisarmTransaction()
				_cFunName := "AgeInvReq"
				_cMsg     := "Cliente não localizado no Protheus - CNPJ: "+alltrim(cCnpjCli)+"."
				_cDoc1    := alltrim(cCnpjCli)
				_cDoc2    := ""
				_cDoc3    := ""
				_cCodMsg  := "01"
				If lNewAge .And. lAutomatic
					If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
						setFileLog(cFile,"fail",_cMsg)
					EndIf
				Else
					setFileLog(cFile,"fail",_cMsg)
				EndIf
				
				lOk := .f.
			
				FWLogMsg("ERROR", "LAST", "BusinessObject", funName(), "", "01", "Falha no processamento da Rotina...", 0, 0, {})
			endif
			if !(lOK)
				FWLogMsg("ERROR", "LAST", "BusinessObject", funName(), "", "01", "Saindo da Rotina por Break...", 0, 0, {})
				BREAK
			endif
		
		endIf
		RECOVER
			DisarmTransaction()
		END SEQUENCE
	END TRANSACTION
	
return lOk


/**
* Coleta os Items da interface Invoice Request
**/
static function retProducts()
	
	local aItems       := {}
	local nItem        := 1
	local nLenItem     := 0
	
	if ValType(oXml:_INV_REQ:_BODY) <> nil
		if ValType(oXml:_INV_REQ:_BODY:_FILEITEM) == "A"
			
			nLenItem := Len(oXml:_INV_REQ:_BODY:_FILEITEM)
			aItems   := {}
			
			for nItem := 1 to nLenItem
				aAdd(aItems,{getProduct(@nItem),getQuantity(@nItem), getLote(@nItem), getUOM(@nItem), getSubLote(@nItem), getExpDate(@nItem)})
			next
			
		elseif ValType(oXml:_INV_REQ:_BODY:_FILEITEM) == "O"
			
			nItem	:= 0
			aItems  := {}
			
			aAdd(aItems,{getProduct(@nItem),getQuantity(@nItem), getLote(@nItem), getUOM(@nItem) , getSubLote(@nItem), getExpDate(@nItem)})
			
		endif
		
	else
		aAdd(aItems,{})
	endif
	
return aItems


/**
* Coleta o produto acabado (BOM)
**/
static function getBomProduct(nPallet)
	local xRet	:= ""
	
	if nPallet > 0
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_BOM:TEXT)
	else
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_BOM:TEXT)
	endif
	
return (xRet)



/**
* Coleta a quantidade do BOM
**/
static function getBomQuantity(nPallet)
	local xRet := ""
	
	if nPallet > 0
		xRet := Val(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_QUANTITY:TEXT)
	else
		xRet := Val(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_QUANTITY:TEXT)
	endif
	
return (xRet)


/**
* Coleta o Produto
**/
static function getProduct(nItem)
	local xRet := ""
	local oDhlPrdDepara := DhlPrdDepara():newDhlPrdDepara()
	
	if nItem > 0
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEITEM[nItem]:_ITEM:TEXT)
	else
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEITEM:_ITEM:TEXT)
	endif
	
	xRet := oDhlPrdDepara:getPrdProtheus(xRet, cCnpjCli)
	
return (xRet)


/**
* Coleta a Quantidade
**/
static function getQuantity(nItem)
	local xRet := ""
	
	if nItem > 0
		xRet := Val(oXml:_INV_REQ:_BODY:_FILEITEM[nItem]:_QUANTITY:TEXT)
	else
		xRet := Val(oXml:_INV_REQ:_BODY:_FILEITEM:_QUANTITY:TEXT)
	endif
return (xRet)


/**
* Coleta a Quantidade
**/
static function getUOM(nItem)
	local xRet := ""
	
	if nItem > 0
		xRet := oXml:_INV_REQ:_BODY:_FILEITEM[nItem]:_UOM:TEXT
	else
		xRet := oXml:_INV_REQ:_BODY:_FILEITEM:_UOM:TEXT
	endif
return (xRet)



/**
* Coleta o sublote
**/
static function getExpDate(nItem)
	local xRet 	:= ""
	local aData	:= {}
	local cMes  := ""
	local cDia	:= ""
	local cAno	:= ""
	
	if nItem > 0
		xRet := oXml:_INV_REQ:_BODY:_FILEITEM[nItem]:_EXPIRATION_DATE:TEXT
	else
		xRet := oXml:_INV_REQ:_BODY:_FILEITEM:_EXPIRATION_DATE:TEXT
	endif
	
	if !empty(xRet)
		aData:=StrToKarr(xRet, "-")
		cAno := aData[1]
		cMes := aData[2]
		cDia := aData[3]
		
		xRet:=cAno+cMes+cDia
	endif
	
return (xRet)

/**
* Coleta o sublote
**/
static function getSubLote(nItem)
	local xRet := ""
	
	if nItem > 0
		xRet := oXml:_INV_REQ:_BODY:_FILEITEM[nItem]:_SUBLOT:TEXT
	else
		xRet := oXml:_INV_REQ:_BODY:_FILEITEM:_SUBLOT:TEXT
	endif
return (xRet)


/**
* Coleta a Quantidade
**/
static function getLote(nItem)
	local xRet := ""
	
	if nItem > 0
		xRet := oXml:_INV_REQ:_BODY:_FILEITEM[nItem]:_LOT:TEXT
	else
		xRet := oXml:_INV_REQ:_BODY:_FILEITEM:_LOT:TEXT
	endif
return (xRet)



/**
* Coleta a unidade de medida do Produto
**/
static function UnitMeasure(cProduct)
return AllTrim(oSql:getFieldValue("SB1","B1_UM","B1_FILIAL = '%SB1.FILIAL%' AND B1_COD = '" + cProduct + "'"))

/**
* Inclui o Pedido de Venda
**/
static function incOutflowOrder()
	
	local aHeader	:= {}
	Local aDetails  := {}
	local lOk		:= .t.
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Entrou na Rotina de Inclusão do Pedido...", 0, 0, {})
	
	If !(validorder())
		Return(lOk)
	EndIf
	
	aDetails := mountDetail()
	
	aAdd(aHeader,{"C5_TIPO"   , getDocType()                 ,nil})
	aAdd(aHeader,{"C5_CLIENTE", cCliFor  					 ,nil})
	aAdd(aHeader,{"C5_LOJACLI", cLoja 						 ,nil})
	if !empty(cDeliveryCust)
		aAdd(aHeader,{"C5_CLIENT"	, cDeliveryCust			,nil})
		aAdd(aHeader,{"C5_LOJAENT"	, cBranchCust 			,nil})
	endif
	aAdd(aHeader,{"C5_CONDPAG" , GetMV("ZZ_CONDINT")         ,nil})
	aAdd(aHeader,{"C5_ZZSHIP"  , cShipping                   ,nil})
	aAdd(aHeader,{"C5_ZZTIPO"  , getDocType()   			 ,nil})
	aAdd(aHeader,{"C5_ZZORDEX" , getSalesOrder()			 ,nil})
	//acrescentado por Edson Deluca - FIT Gestao - 07/06/2018 - Projeto Automação Braskem
	If (FWUnitBusiness() == DHL_BUSINESSUNIT_AGE)
		If lNewAge .And. lAutomatic
			aAdd(aHeader,{"C5_ZZTPPV"  , "4"			             ,nil})
			aAdd(aHeader,{"C5_TPFRETE" , "S"			             ,nil})
		EndIf
	EndIf
	//Fim das Alterações por Edson Deluca - FIT Gestao - 07/06/2018 - Projeto Automação Braskem
	
	MSExecAuto({|x, y, z| Mata410(x, y, z)}, aHeader, aDetails, 3)
	
	if lMsErroAuto
		lOk := .f.
		DisarmTransaction()
		_cFunName := "AgeInvReq"
		_cMsg     := "Falha ao incluir o pedido de vendas"+oUtils:getErroAuto()
		_cDoc1    := cShipping
		_cDoc2    := ""
		_cDoc3    := ""
		_cCodMsg  := "02"
		If lNewAge .And. lAutomatic
			If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
				setFileLog(cFile,"fail",_cMsg)
			EndIf
		Else
			setFileLog(cFile,"fail",_cMsg)
		EndIf
		
		FWLogMsg("ERROR", "LAST", "BusinessObject", funName(), "", "01", "Falha ao incluir o Pedido de Venda..."+CRLF+CRLF+oUtils:getErroAuto(), 0, 0, {})
	else
		if len(aDetails2) > 0
			MSExecAuto({|x, y, z| Mata410(x, y, z)}, aHeader, aDetails2, 3)
			if lMsErroAuto
				lOk := .f.
				DisarmTransaction()
				_cFunName := "AgeInvReq"
				_cMsg     := "Falha ao incluir o pedido de vendas"+oUtils:getErroAuto()
				_cDoc1    := cShipping
				_cDoc2    := ""
				_cDoc3    := ""
				_cCodMsg  := "03"
				If lNewAge .And. lAutomatic
					If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
						setFileLog(cFile,"fail",_cMsg)
					EndIf
				Else
					setFileLog(cFile,"fail",_cMsg)
				EndIf
				
				FWLogMsg("ERROR", "LAST", "BusinessObject", funName(), "", "01", "Falha ao incluir o Pedido de Venda 2...", 0, 0, {})
			endif
		endif
	endIf
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Saindo da Rotina de Inclusão de Pedido de Venda...", 0, 0, {})
	
return (lOk)


/**
* Monta os Itens do Pedido de Venda
**/
static function mountDetail()
	
	local nI		:= 0
	local nUnitPrice:= 0
	local nQuantity := 0
	local cProduct  := ""
	local cQuery	:= ""
	local cUnidMed	:= ""
	local cTes		:= alltrim(GetNewPar("ZZ_TESSAI"))
	Local _cTesBsk  := AllTrim(GetNewPar("ZZ_TESINV")) //Adicionado por Edson Deluca - FIT Gestao - Projeto Automação Braskem - 07/06/2018
	local aAux := {}
	local _cRastro := ""
	
	aDetails  := {}
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Entrando na Rotina MountDetail...", 0, 0, {})
	
	groupProducts()
	
	/*
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Passou os grupos de produtos na Rotina MountDetail...", 0, 0, {})
	
	If lNewAge .And. lAutomatic            	 //acrescentado por Edson Deluca - FIT Gestão - 06/08/2018
		If existBlock("DHLPE01")              //acrescentado por Edson Deluca - FIT Gestão - 04/05/2018
			aProducts := U_DHLPE01(aProducts)  //acrescentado por Edson Deluca - FIT Gestão - 04/05/2018
		EndIf                                 //acrescentado por Edson Deluca - FIT Gestão - 04/05/2018
	EndIf                                    //acrescentado por Edson Deluca - FIT Gestão - 04/05/2018
	*/
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Passou DHLPE01 na Rotina MountDetail...", 0, 0, {})
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Quantidade de produtos: "+str(len(aProducts),3,0), 0, 0, {})
	
	for nI := 1 to Len(aProducts)
		
		aAux 	  := {}
		cProduct  := aProducts[nI,1]
		nQuantity := aProducts[nI,2]
		
		if productControLote(cProduct)
			cLote	  := aProducts[nI,3]
		else
			cLote	  := ""
		endIf		
		cUnidMed  := aProducts[nI,4]
		nPrecoUnit:= GetPrecoUnit(cProduct)
		
		if len(aDetails) == 0
			cItem := "01"
		else
			cItem := Soma1(aDetails[len(aDetails),1,2])
		endif
		
		aAdd(aAux,{"C6_ITEM"   	,cItem           								,nil})
		aAdd(aAux,{"C6_PRODUTO"	,cProduct		 								,nil})
		
		//Alterado por Edson Deluca - FIT Gestao - Projeto Automação Braskem - 06/07/2018
		
		If (FWUnitBusiness() == DHL_BUSINESSUNIT_AGE)
			If lNewAge .And. lAutomatic
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial("SB1")+cProduct,.F.)
					_cSegUmSB1 := SB1->B1_SEGUM
					_cTipConv  := SB1->B1_TIPCONV
					_nConv     := SB1->B1_CONV
					_cRastro	:= SB1->B1_RASTRO
					
					If cUnidMed==_cSegUmSB1
						//		            nPrecoUnit := IIF(_cTipConv="M",nPrecoUnit/_nConv,nPrecoUnit*_nConv)
						_nQuantity := IIF(_cTipConv="M",nQuantity/_nConv,nQuantity*_nConv)
						aAdd(aAux,{"C6_PRCVEN" 	,nPrecoUnit      								,nil})
						aAdd(aAux,{"C6_QTDVEN"  ,_nQuantity                                     ,nil})
						aAdd(aAux,{"C6_VALOR" 	,A410Arred(_nQuantity * nPrecoUnit ,"C6_VALOR")	,nil})
					Else
						aAdd(aAux,{"C6_QTDVEN" 	,nQuantity       								,nil})
						aAdd(aAux,{"C6_PRCVEN" 	,nPrecoUnit      								,nil})
						aAdd(aAux,{"C6_VALOR" 	,A410Arred(nQuantity * nPrecoUnit ,"C6_VALOR")	,nil})
					EndIf
				EndIf
			Else
				aAdd(aAux,{"C6_QTDVEN" 	,nQuantity       								,nil})
				aAdd(aAux,{"C6_UOM" 	    ,cUnidMed            						   ,nil})
				aAdd(aAux,{"C6_PRCVEN" 	,nPrecoUnit      								,nil})
				aAdd(aAux,{"C6_VALOR" 	,A410Arred(nQuantity * nPrecoUnit ,"C6_VALOR")	,nil})
			EndIf
		Else
			aAdd(aAux,{"C6_QTDVEN" 	,nQuantity       								,nil})
			aAdd(aAux,{"C6_UOM" 	    ,cUnidMed            						   ,nil})
			aAdd(aAux,{"C6_PRCVEN" 	,nPrecoUnit      								,nil})
			aAdd(aAux,{"C6_VALOR" 	,A410Arred(nQuantity * nPrecoUnit ,"C6_VALOR")	,nil})
		EndIf
		aAdd(aAux,{"C6_TES" 	,cTes                 							,nil})     //TIRADO _cTesBsk
		
		//Fim de alteração
		
		if lNewAge .And. lAutomatic
			If _cRastro = "L"
				aAdd(aAux,{"C6_ZZLOTE" 	,cLote        								,nil})
				aAdd(aAux,{"C6_LOTECTL"	,cLote                              		,nil})	//acrescentado por Edson Deluca - FIT Gestão - 04/05/2018
			Else
				aAdd(aAux,{"C6_ZZLOTE" 	," "        								,nil})
				aAdd(aAux,{"C6_LOTECTL"	," "                              		    ,nil})
			EndIf
			//		    aAdd(aAux,{"C6_NUMLOTE"	,aProducts[nI,5]       		                ,nil})  //acrescentado por Edson Deluca - FIT Gestão - 04/05/2018
			//		    aAdd(aAux,{"C6_DTVALID"	,aProducts[nI,6]          		            ,nil})  //acrescentado por Edson Deluca - FIT Gestão - 04/05/2018
		endif
		
		aAdd(aDetails,aAux)
		
	next nI
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Saindo da Rotina MountDetail...", 0, 0, {})
	
return (aDetails)

/**
* Função que pega o preço unitário do produto
*/
Static Function GetPrecoUnit(cProduto)
	
	local oSqlAux	  := IpSqlObject():newIpSqlObject()
	local cTabela	  := "SB1"
	local cCampos	  := "B1_PRV1"
	local cWhere	  := "%SB1.XFILIAL% AND B1_COD = '" + cProduto + "'"
	local nPrecoUni	  := 0
	
	oSqlAux:newTable(cTabela,cCampos,cWhere )
	
	if oSqlAux:hasRecords()
		nPrecoUni	:= oSqlAux:GetValue("B1_PRV1")
	endif
	
	oSqlAux:Close()
	
Return nPrecoUni

/**
* Agrupa os Produtos do Pedido de Vendas
*/
static function groupProducts()
	
	local nI	   	 := 0
	local nScan		 := 0
	local nQuantity  := 0
	local cProduct   := ""
	local cLote		 := ""
	local cUnidMedi	 := ""
	local aGroupProd := {}
	
	for nI := 1 to Len(aProducts)
		
		cProduct  := aProducts[nI,1]
		nQuantity := aProducts[nI,2]
		cLote	  := aProducts[nI,3]
		cUnidMedi := aProducts[nI,4]
		
		if isProdutLote(cProduct)
			nScan	  := aScan(aGroupProd, {|x| x[1] == cProduct .and. x[3] == cLote} )
		else
			nScan	  := aScan(aGroupProd, {|x| x[1] == cProduct} )
		endIf	
		
		if (nScan > 0)
			aGroupProd[nScan,2] += nQuantity
		else
			aAdd(aGroupProd, {cProduct, nQuantity, cLote, cUnidMedi})
		endIf
		
	next nI
	
	aProducts := aClone(aGroupProd)
	
return

/**
* Coleta o preço de Venda
**/
static function getUnitPrice(cProduct,nUnitPrice)
	
	local cQuery := ""
	
	cQuery += "SELECT B1_PRV1,B2_CM1"                +CRLF
	cQuery += "FROM %SB1.SQLNAME%"                   +CRLF
	cQuery += "LEFT JOIN %SB2.SQLNAME%"              +CRLF
	cQuery += "ON B2_FILIAL = B1_FILIAL AND"         +CRLF
	cQuery += "   B2_COD = B1_COD AND"               +CRLF
	cQuery += "   B2_LOCAL = B1_LOCPAD AND"          +CRLF
	cQuery += "   %SB2.NOTDEL%"                      +CRLF
	cQuery += "WHERE B1_FILIAL = '%SB1.FILIAL%' AND" +CRLF
	cQuery += "      B1_COD = '"+cProduct+"' AND"    +CRLF
	cQuery += "      %SB1.NOTDEL%"                   +CRLF
	
	oSql:newAlias(cQuery)
	
	nUnitPrice := oSql:getValue("B1_PRV1")
	
	if nUnitPrice == 0
		nUnitPrice := oSql:getValue("B2_CM1")
	endif
	
	oSql:close()
	
return


/**
* Define os Logs de acordo com os tipos de arquivos
*/
static function setFileLog(cFile,cLogType,cLogText,cTag,cValue)
	
	local cInterface := "Invoice Request"
	
	oLog:start(APP_DLX,DHL_IMPORTACAO,cFile)
	
	if !(Empty(cTag))
		cLogText += CRLF+CRLF+"Tag: "+cTag
	endIf
	
	if !(Empty(cValue))
		cLogText += CRLF+CRLF+"Valor: "+cValue
	endIf
	
	if (cLogType == "fail")
		oLog:fail(cInterface, cLogText)
	elseIf (cLogType == "warn")
		oLog:warn(cInterface, cLogText)
	endIf
	
return


/*
**
*/
static function getCliFor()
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local lOk	 	:= .t.
	
	if getDocType() == 'N'
		oSqlUtil:newTable("SA1", "A1_COD, A1_LOJA, A1_EMAIL", "A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = '" + cCnpjCli + "' ")
		if oSqlUtil:hasRecords()
			cClifor	:= oSqlUtil:getValue("A1_COD")
			cLoja	:= oSqlUtil:getValue("A1_LOJA")
			cEmail	:= oSqlUtil:getValue("A1_EMAIL")
		else
			lOk := .f.
		endif
	else
		oSqlUtil:newTable("SA2", "A2_COD, A2_LOJA, A2_EMAIL", "A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = '" + cCnpjCli + "' ")
		if oSqlUtil:hasRecords()
			cClifor	:= oSqlUtil:getValue("A2_COD")
			cLoja	:= oSqlUtil:getValue("A2_LOJA")
			cEmail	:= oSqlUtil:getValue("A2_EMAIL")
		else
			lOk := .f.
		endif
	endif
	
	oSqlUtil:close()
	
return (lOk)


/**
* Obtem a query dos itens do pedido de venda
*/
static function getQueryItens(cProduct, cLote)
	
	local cQuery := ""
	
	cQuery := "SELECT D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_ITEM,D1_VUNIT,D1_LOCAL,D1_TOTAL,D1_EMISSAO,B6_FILIAL,B6_PRODUTO,B6_QUANT,"
	cQuery += "       B6_CLIFOR,B6_LOJA,B6_PODER3,B6_TPCF,B6_TIPO,B6_IDENT,B6_PRUNIT,(B6_SALDO - B6_QULIB) B6_SALDO,F4_TESDV, D1_LOTECTL, D1_DTVALID "
	cQuery += "FROM " + RetSqlName("SB6") + " SB6,"
	cQuery +=           RetSqlName("SD1") + " SD1,"
	cQuery +=           RetSqlName("SF4") + " SF4 "
	cQuery += "WHERE B6_FILIAL = '" + xFilial("SB6") + "' AND "
	cQuery += "      B6_PODER3 = 'R' AND "
	cQuery += "      B6_TPCF   = 'C' AND "
	cQuery += "      B6_TIPO   = 'D' AND "
	cQuery += "      (B6_SALDO - B6_QULIB)  > 0 AND "
	cQuery += " 	 SB6.D_E_L_E_T_ = ' ' AND "
	cQuery += "      D1_NUMSEQ = B6_IDENT AND "
	cQuery += "      D1_FILIAL = '" + xFilial("SD1") + "' AND "
	cQuery += "      D1_COD    = '" + cProduct + "' AND "
	if empty(cLote)
		cQuery += "      D1_LOTECTL    = '" + CriaVar("D1_LOTECTL", .f.) + "' AND "
	else
		cQuery += "      D1_LOTECTL    = '" + cLote + "' AND "
	endif
	cQuery += " SD1.D_E_L_E_T_ = ' ' AND "
	cQuery += "      F4_FILIAL = '" + xFilial("SF4") + "' AND "
	cQuery += "      F4_CODIGO = B6_TES AND "
	cQuery += " SF4.D_E_L_E_T_ = ' ' "
	if empty(cLote)
		cQuery += " ORDER BY D1_EMISSAO "
	else
		cQuery += " ORDER BY D1_DTVALID "
	endif
	
return cQuery


/**
* Coleta a Tes a ser utilizada
**/
static function getTes(oSql)
	
	local cTes 		:= ""
	local cTesAux	:= ""
	local oSqlAux	:= IpSqlObject():newIpSqlObject()
	
	if upper(alltrim(SC5->C5_ZZESPEC)) ==  DHL_ESPECIE_INVENTARIO
		cTes := AllTrim(GetMv("ZZ_TESINV"))
	else
		if getDocType() $ 'B'
			cTes := GetNewPar("ZZ_TESREP", "")
			/*
		else
			// Adequação DIFAl - Thiago Meschiatti - 10/08/16
			cTes 	:= oSql:getValue("F4_TESDV")
			cTesAux	:= oSqlAux:getFieldValue("SF4", "F4_ZZTESDI", "%SF4.XFILIAL% AND F4_CODIGO = '"+cTes+"' ")
			if !empty(cTesAux)
				cTes := cTesAux
			endif
			*/
		else
			cTes 	:= oSql:getValue("F4_TESDV")
		endif
	endif
	
return cTes


/*
** Verifica se existe cliente/fornecedor
*/
static function incCustomer()
	
	lOk := getCliFor()
	
return (lOk)


/*
** Coleta o Código do Município
*/
static function getCodMun(cCity)
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cCodMun	:= ""
	
	cCodMun := oSql:getFieldValue("CC2", "CC2_CODMUN", " %CC2.XFILIAL% AND CC2_MUN = '"+NoAcento(upper(cCity))+"' ")
	
	osql:close()
return (cCodMun)


/*
** Valida se Inv. Req. pode ser importada.
*/
static function validOrder()
	local oSql 	:= IpSqlObject():newIpSqlObject()
	local lOk	:= .t.
	
	oSql:newTable("SC5", "C5_NUM", " %SC5.XFILIAL% AND C5_ZZSHIP = '" + upper(cShipping) + "' AND C5_ZZORDEX = '" + upper(cSalesOrd) + "' ")
	
	if oSql:hasRecords()
		_cFunName := "AgeInvReq"
		_cMsg     := "Shippment: "+alltrim(cShipping)+" e Sales Order: "+alltrim(cSalesOrd)+" já utilizados no Protheus."
		_cDoc1    := alltrim(cShipping)
		_cDoc2    := alltrim(cSalesOrd)
		_cDoc3    := ""
		_cCodMsg  := "04"
		If lNewAge .And. lAutomatic
			If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
				setFileLog(cFile,"fail",_cMsg)
			EndIf
		Else
			setFileLog(cFile,"fail",_cMsg)
		EndIf
		
		lOk := .f.
	endif
	
	oSql:close()
	
return (lOk)
/**
* Coleta o Shipping Number
**/
static function getShipping()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_SHIPPING_NUMBER:TEXT


/**
* Coleta o Customer CNPJ
**/
static function getCnpjCustomer()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_CUSTOMER_CNPJ:TEXT


/**
* Coleta o Sales Order
**/
static function getSalesOrder()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_SALES_ORDER:TEXT

/**
* Coleta o Document Type
**/
static function getDocType()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_DOCUMENT_TYPE:TEXT

/**
* Coleta o Net Weight
**/
static function getNetWeight()
return val(oXml:_INV_REQ:_BODY:_FILEHEADER:_NET_WEIGHT:TEXT)

/**
* Coleta o Gross Weight
**/
static function getGrossWeight()
return val(oXml:_INV_REQ:_BODY:_FILEHEADER:_GROSS_WEIGHT:TEXT)

/**
* Coleta o Volume
**/
static function getVolume()
return val(oXml:_INV_REQ:_BODY:_FILEHEADER:_VOLUME:TEXT)

/**
* Coleta o Delivery Customer
**/
static function getDeliveryCustomer()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_DELIVERY_CUSTOMER:TEXT

/**
* Coleta o Adress
**/
static function getAdress()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_ADDRESS:TEXT

/**
* Coleta o Complement Adress
**/
static function getComplement()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_COMPLEMENT_ADDRESS:TEXT

/**
* Coleta o District Adress
**/
static function getDistrict()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_DISTRICT_ADDRESS:TEXT

/**
* Coleta o State Adress
**/
static function getStateAdress()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_STATE_ADDRESS:TEXT

/**
* Coleta o City Adress
**/
static function getCityAdress()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_CITY_ADDRESS:TEXT

/**
* Coleta o Zipcode Adress
**/
static function getZipcodeAdress()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_ZIPCODE_ADRRESS:TEXT

********************************
User Function DHLPE01(aProducts)
	********************************
	
	Local _lPrimeira     := .T.
	Local _nI            := 0
	local _I             := 0
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Entrou na rotina DHLPE01...", 0, 0, {})
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Quantidade de produtos na rotina DHLPE01: "+str(len(aProducts),3,0), 0, 0, {})
	
	For _nI := 1 to Len(aProducts)
		
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Entrou no For Next _nI: "+str(_nI,3,0), 0, 0, {})
		
		_cZZLote    := aProducts[_nI,3]
		_cProduto   := aProducts[_nI,1]
		
		if productControLote(_cProduto)
			
			_nQuant     := aProducts[_nI,2]
			_cLote	    := ""
			_cSubLote   := ""
			_dDtValid   := ""
			_cUnidMed   := aProducts[_nI,4]
			_nPrecoUnit := GetPrecoUnit(_cProduto)
			_nQtdVen    := 0.0000
			
			For _I := 1 to Len(_cZZLOTE)
				
				If Substr(_cZZLOTE,_I,6)="Lote: "
					
					_cLote   := Substr(_cZZLOTE,_I+6,10)
					_nQtdVen := IIF(_cUnidMed=="TO",Val(Substr(_cZZLOTE,_I+18,06))/1000,Val(Substr(_cZZLOTE,_I+18,06)))
					If _lPrimeira
						aProducts[_nI,1] := _cProduto
						aProducts[_nI,2] := _nQtdVen
						aProducts[_nI,3] := _cLote
						_lPrimeira := .F.
					Else
						aAdd(aProducts,{_cProduto,_nQtdVen, _cLote, _cUnidMed, _cSubLote, _dDtValid})
					EndIf
					
				EndIf
				
			Next _I
		endIf
		//        EndIf
	Next _nI
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Quantidade de produtos na saida da rotina DHLPE01: "+str(len(aProducts),3,0), 0, 0, {})
	
Return(aProducts)

/**
* Verifica se o produto controle lote
**/
static function productControLote(cProduto)
	
	local aArea 			:= getArea()
	local aAreaSB1 			:= SB1->(getArea())
	local cChaveSb1			:= fwxFilial("SB1") + padr(cProduto, tamsx3("B1_COD")[1], "")
	local lProdContrLote 	:= .F.
	
	SB1->(dbSetOrder(1))
	
	if SB1->(dbSeek(cChaveSb1))
		if SB1->B1_RASTRO == "L"
			lProdContrLote := .T.
		endIf
	endIf
	
	restArea(aAreaSB1)
	restArea(aArea)
	
return lProdContrLote

/**
* Obtém o tipo de nota que o pedido var ser gerado:
* RETORNO EFETIVO ou RETORNO SIMBÓLICO
**/
static function getTipoNota()
	
	local cTipoNota := upper(allTrim(oXml:_INV_REQ:_BODY:_FILEHEADER:_SALES_ORDER:TEXT))
	
	if cTipoNota == RETORNO_EFETIVO
		cTipoNota := RETORNO_EFETIVO
	else
		cTipoNota := RETORNO_SIMBOLICO
	endIf
	
return cTipoNota

/**
** Verifica se o produto controla lote
**/
static function  isProdutLote(cCodProd)
	
	local lIsProdlote	:= .F.
	local aArea 		:= getArea()
	local aAreaSB1 		:= SB1->(getArea())
	local cChaveSB1		:= ""
	
	cCodProd := padr(cCodProd, tamSx3("B1_COD")[1], "")
	cChaveSB1:= fwxFilial("SB1") + cCodProd
	
	SB1->(dbSetOrder(1))
	
	if SB1->(dbSeek(cChaveSB1))
		if SB1->B1_RASTRO = "L"
			lIsProdlote := .T.
		endif
	endIf
	
	restArea(aAreaSB1)
	restArea(aArea)
	
return lIsProdlote
