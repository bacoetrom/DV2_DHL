#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"

#define PRODUCT_BOM  1
#define QUANTITY_BOM 2
#define WORK_ORDER   3
#define FILEITEM     4

#define PRODUCT      1
#define QUANTITY     2

 
/*/{Protheus.doc} DlxInvReq

Rotina responsável por ler e processar a interface Invoice Request e atualizar os dados referentes ao documento.
	
@author Winston Dellano de Castro
@since 13/11/2014

@param cFilePath, String, Arquivo a ser processado
/*/
user function DlxInvReq(cFilePath)

	local lValid        := .T.
	local nBom          := 0
	local lOk			:= .T.
	
	private oLogImp     := DHLLogManager():newDHLLogManager()
	private cShipping   := getShipping()
	private cCnpjCli    := getCnpjCustomer()
	private cSalesOrd   := getSalesOrder()
	private cFile       := cFilePath
	private aProducts   := retProducts()
	private lMsErroAuto := .F.
	private lTemPoder3	:= .T.
	private lVldPrdPrice	:= .T.
	
	private aDetail          := {}
	private aDetails         := {}
	private cCliFor			 := ""
	private cLoja			 := ""
	private cProductionOrder := ""
	private cIdOp			 := ""
	private cItem            := ""
	
	BEGIN TRANSACTION
		BEGIN SEQUENCE
			lOk := incOutflowOrder()
		RECOVER
			DisarmTransaction()
		END SEQUENCE
	END TRANSACTION

return lOk

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
				aAdd(aItems,{getProduct(@nItem),getQuantity(@nItem), getLote(@nItem)})
			next
					
		elseif ValType(oXml:_INV_REQ:_BODY:_FILEITEM) == "O"
			
			nItem	:= 0
			aItems  := {}
			aAdd(aItems,{getProduct(@nItem),getQuantity(@nItem), getLote(@nItem)})
					
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
	
	if nItem > 0
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEITEM[nItem]:_ITEM:TEXT)
	else
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEITEM:_ITEM:TEXT)
	endif
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
static function getLote(nItem)
	local xRet := ""
	
	if nItem > 0
		xRet := Val(oXml:_INV_REQ:_BODY:_FILEITEM[nItem]:_LOT:TEXT)
	else
		xRet := Val(oXml:_INV_REQ:_BODY:_FILEITEM:_LOT:TEXT)
	endif
return (xRet)



/**
* Coleta a unidade de medida do Produto
**/
static function UnitMeasure(cProduct)
return AllTrim(oSql:getFieldValue("SB1","B1_UM","B1_FILIAL = '%SB1.FILIAL%' AND B1_COD = '" + cProduct + "'"))


/**
* Define o número da Ordem de Produção
**/
static function setNumOP()	
	
	local cQuery  := " SELECT MAX(C2_NUM) MAXNUM FROM %SC2.SQLNAME% WHERE %SC2.XFILIAL% AND %SC2.NOTDEL% "
	local cMaxNum := ""
	
	if !Empty(cProductionOrder)
		cProductionOrder := Soma1(cProductionOrder)
		return
	endIf
	
	oSql:newAlias(cQuery)	
	cMaxNum := oSql:getValue("MAXNUM")
	oSql:close()
	
	if Empty(cMaxNum)
		cProductionOrder := StrZero(1, Len(SC2->C2_NUM))
	else
		cProductionOrder := Soma1(cMaxNum)
	endIf		
	
return 


/**
* Inclui o Pedido de Venda
**/
static function incOutflowOrder()

	local aHeader	:= {} 
	local lOk		:= .t.		
	
	lOk := getCliFor()
	
	if lOk 
		mountDetail()
		
		aAdd(aHeader,{"C5_TIPO"   , getDocType()                 ,nil})
		aAdd(aHeader,{"C5_CLIENTE", cCliFor  					 ,nil})
		aAdd(aHeader,{"C5_LOJACLI", cLoja 						 ,nil})
		aAdd(aHeader,{"C5_CONDPAG", GetMV("ZZ_CONDINT")          ,nil})
		aAdd(aHeader,{"C5_ZZSHIP" , cShipping                    ,nil})
		aAdd(aHeader,{"C5_ZZTIPO" , getDocType()   				 ,nil})
		aAdd(aHeader,{"C5_ZZORDEX", getSalesOrder()				 ,nil})	
		
		if isSky()
			if !(lVldPrdPrice)
				setFileLog(cFile,"fail","O arquivo possui o mesmo SKU com valores unitários diferentes "+CRLF+CRLF+oUtils:getErroAuto())
				lOk := .f.
				return lOk
			endIf
		endIf 
		
		if !(lTemPoder3)
			setFileLog(cFile,"fail","Não há saldo em poder de terceiros para os itens do pedido "+CRLF+CRLF+oUtils:getErroAuto())
			lOk := .f.
			return lOk 
		endif
		
		MSExecAuto({|x, y, z| Mata410(x, y, z)}, aHeader, aDetails, 3)
		
		if lMsErroAuto
			lOk := .f.
			DisarmTransaction()
			setFileLog(cFile,"fail","Falha ao incluir o pedido de vendas"+CRLF+CRLF+oUtils:getErroAuto())	
		endIf
	else
		setFileLog(cFile,"fail","Falha ao incluir o pedido de vendas. Cliente/Fornecedor não localizado"+CRLF+CRLF+oUtils:getErroAuto())
	endif
return lOk 


/**
* Monta os Itens do Pedido de Venda
**/
static function mountDetail()

	local nI		 := 0
	local nUnitPrice := 0
	local nQuantity  := 0
	local nTotPrice	 := 0
	local nSld   	:= 0
	local nSaldo 	:= 0
	local nVlrParcial, nVlrUnit, nSldTotal := 0
	local cProduct   := ""
	local cOP		 := ""
	local cQuery	:= ""
	
	aDetails := {}
	cItem    := Replicate("0",Len(SC6->C6_ITEM))
	
	groupProducts()
	
	for nI := 1 to Len(aProducts)
		aDetail   		:= {}
		cProduct  		:= aProducts[nI,1]
		nQuantity 		:= aProducts[nI,2]
		cLote	  		:= aProducts[nI,3]
		
		cQuery := getQueryItens(cProduct, cLote)
		oSql:newAlias(cQuery)
		
		if isSky()
			lVldPrdPrice := hasDifUnitPrice(oSql)
			if !lVldPrdPrice
				exit
			endIf
		endIf
		
		nSld := nQuantity
		
		if oSql:hasRecords()
			while oSql:notIsEof()
			
				lTemPoder3 := .T.
				aAux := {}
				
				nVlrParcial:= 0
				nVlrUnit := 0
				nSldTotal := 0
				
				if nSld <= oSql:getValue("B6_SALDO")
					nSaldo 		:= nSld
				else
					nSaldo 		:= oSql:getValue("B6_SALDO")
				endif
				
				if nSaldo < oSql:getValue("B6_QUANT")
					nSldTotal 	:= oSql:getValue("B6_QUANT")
					
					nVlrUnit    := oSql:getValue("D1_VUNIT")
					nVlrParcial := nVlrUnit * nSaldo
				else
					nVlrParcial	:= oSql:getValue("D1_TOTAL")
					nVlrUnit 	:= nVlrParcial / nSaldo
				endif
				
				if nSaldo * A410Arred(nVlrUnit ,"C6_PRCVEN") < 0.01
					oLogImp:start("PV","PV","")
					oLogImp:warn("REGISTRO IGNORADO PEDIDO "+SC5->C5_NUM, "Valor total item "+oSql:getValue("B6_PRODUTO")+" para NF "+oSql:getValue("D1_DOC")+;
						"/"+oSql:getValue("D1_SERIE")+" não atingiu valor minimo 0,01.")
					oSql:skip()
					loop
				endif
				
				cItem := Soma1(cItem)
									
				aAdd(aAux,{"C6_ITEM"   ,cItem                      ,nil})
				aAdd(aAux,{"C6_PRODUTO",oSql:getValue("B6_PRODUTO"),nil})
				aAdd(aAux,{"C6_QTDVEN" ,nSaldo                     ,nil})
				aAdd(aAux,{"C6_PRCVEN" ,A410Arred(nVlrUnit ,"C6_PRCVEN")  ,nil})
				aAdd(aAux,{"C6_VALOR"  ,A410Arred(nVlrParcial,"C6_VALOR"),nil})
				aAdd(aAux,{"C6_QTDLIB" ,nSaldo                     ,nil})
				aAdd(aAux,{"C6_TES"    ,getTes(@oSql)              ,nil})
				aAdd(aAux,{"C6_LOCAL"  ,oSql:getValue("D1_LOCAL")  ,nil})
				if !(getDocType() $ 'B')
					aAdd(aAux,{"C6_NFORI"  ,oSql:getValue("D1_DOC")    ,nil})
					aAdd(aAux,{"C6_SERIORI",oSql:getValue("D1_SERIE")  ,nil})
					aAdd(aAux,{"C6_ITEMORI",oSql:getValue("D1_ITEM")   ,nil})
					aAdd(aAux,{"C6_IDENTB6",oSql:getValue("B6_IDENT")  ,nil})
				endif
				
//				montaItens(@aAux)
				
				aAdd(aDetails,aAux)
				
				nSld -= iif(nSld <= oSql:getValue("B6_SALDO"),nSld,oSql:getValue("B6_SALDO"))
					
				if nSld == 0
					exit
				endif
			
				oSql:skip()
			
			enddo
			if nSld > 0
				lTemPoder3 := .F.
				exit
			endif
		else
			lTemPoder3 := .F.
			exit
		endif
		
	next nI
	
return

/**
 * Agrupa os Produtos do Pedido de Vendas
 */
static function groupProducts()
	
	local nI	   	 := 0
	local nScan		 := 0
	local nQuantity  := 0
	local cProduct   := ""
	local cLote		 := ""
	local aGroupProd := {}
	
	for nI := 1 to Len(aProducts)
		
		cProduct  := aProducts[nI,1]
		nQuantity := aProducts[nI,2]
		cLote	  := aProducts[nI,3]
		nScan	  := aScan(aGroupProd, {|x| x[1] == cProduct })	
		
		if (nScan > 0)
			aGroupProd[nScan,2] += nQuantity
		else
			aAdd(aGroupProd, {cProduct, nQuantity, cLote})
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
		oSqlUtil:newTable("SA1", "A1_COD, A1_LOJA", "A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = '" + cCnpjCli + "' ")
		if oSqlUtil:hasRecords()
			cClifor	:= oSqlUtil:getValue("A1_COD")
			cLoja	:= oSqlUtil:getValue("A1_LOJA")
		else
			lOk := .f.
		endif
	else
		oSqlUtil:newTable("SA2", "A2_COD, A2_LOJA", "A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = '" + cCnpjCli + "' ")
		if oSqlUtil:hasRecords()
			cClifor	:= oSqlUtil:getValue("A2_COD")
			cLoja	:= oSqlUtil:getValue("A2_LOJA")
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
	
	if isSky()
		cQuery := "SELECT D1_FORNECE,D1_LOJA, D1_VUNIT,D1_LOCAL,SUM(D1_TOTAL) D1_TOTAL,B6_FILIAL,B6_PRODUTO,SUM(B6_QUANT) B6_QUANT,"
		cQuery += "       B6_CLIFOR,B6_LOJA,B6_PODER3,B6_TPCF,B6_TIPO,SUM(B6_SALDO)B6_SALDO ,F4_TESDV "	
	else
		cQuery := "SELECT D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_ITEM,D1_VUNIT,D1_LOCAL,D1_TOTAL,D1_EMISSAO,B6_FILIAL,B6_PRODUTO,B6_QUANT,"
		cQuery += "       B6_CLIFOR,B6_LOJA,B6_PODER3,B6_TPCF,B6_TIPO,B6_IDENT,B6_PRUNIT,B6_SALDO,F4_TESDV "
	endIf
	
	cQuery += "FROM " + RetSqlName("SB6") + " SB6,"
	cQuery +=           RetSqlName("SD1") + " SD1,"
	cQuery +=           RetSqlName("SF4") + " SF4 "
	cQuery += "WHERE B6_FILIAL = '" + xFilial("SB6") + "' AND "
	if empty(cLote) .and. getDocType() <> 'B'
		cQuery += "      B6_CLIFOR = '" + cCliFor + "' AND "
		cQuery += "      B6_LOJA   = '" + cLoja + "' AND "
	endif
	cQuery += "      B6_PODER3 = 'R' AND "
	cQuery += "      B6_TPCF   = 'C' AND "
	cQuery += "      B6_TIPO   = 'D' AND "
	cQuery += "      B6_SALDO  > 0 AND "
	cQuery += " 	 SB6.D_E_L_E_T_ = ' ' AND "
	cQuery += "      D1_NUMSEQ = B6_IDENT AND "
	cQuery += "      D1_FILIAL = '" + xFilial("SD1") + "' AND "
	cQuery += "      D1_COD    = '" + cProduct + "' AND "
	if !empty(cLote)
		cQuery += "      D1_LOTECTL    = '" + cLote + "' AND "
	endif
	cQuery += " SD1.D_E_L_E_T_ = ' ' AND "
	cQuery += "      F4_FILIAL = '" + xFilial("SF4") + "' AND "
	cQuery += "      F4_CODIGO = B6_TES AND "
	cQuery += " SF4.D_E_L_E_T_ = ' ' "
	
	if isSky()
		cQuery += "GROUP BY D1_FORNECE,D1_LOJA,D1_LOCAL,B6_FILIAL,B6_PRODUTO, "
		cQuery += "       B6_CLIFOR,B6_LOJA,B6_PODER3,B6_TPCF,B6_TIPO,F4_TESDV, D1_VUNIT "
	else
		if empty(cLote)
			cQuery += " ORDER BY D1_EMISSAO "
		else
			cQuery += " ORDER BY D1_DTVALID "
		endif
		//FIFO
		// COM LOTE: PROD + LOTE + DATA DE VALID.
		// SEM LOTE: PROD + DATA DO DOCUMENTO
	endIf
	
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", cQuery, 0, 0, {})
	
return cQuery


/**
* Coleta a Tes a ser utilizada
**/
static function getTes(oSql)

	local cTes := ""
	
	if upper(alltrim(SC5->C5_ZZESPEC)) ==  DHL_ESPECIE_INVENTARIO
		cTes := AllTrim(GetMv("ZZ_TESINV"))
	else
		if getDocType() $ 'B'
			cTes := GetNewPar("ZZ_TESREP", "")
		else
			cTes := oSql:getValue("F4_TESDV")
		endif
	endif
	
return cTes


/*
*	Função responsável por verificar se deve ou não executar as regras especificas da SKY.
*/
static function isSky()
	local lRet	:= .F.
	
	if FWUnitBusiness() == DHL_BUSINESSUNIT_REP .AND. getDocType() $ 'B'
		lRet	:= .T.
	endIf
return lRet 


/*
*	Função responsável por verificar se o SKU possui valores unitários diferentes.
*/
static function hasDifUnitPrice(oSql)
	local lRet	:= .T.
	
	if oSql:count() > 1
		lRet	:= .F.
	endIf
return lRet