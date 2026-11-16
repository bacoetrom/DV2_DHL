#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"

#define PRODUCT_BOM  1
#define QUANTITY_BOM 2
#define WORK_ORDER   3
#define FILEITEM     4

#define PRODUCT      1
#define QUANTITY     2
 
/*/{Protheus.doc} AgeInvReq

Rotina responsável por ler e processar a interface Invoice Request e atualizar os dados referentes ao documento.
Processo para Unidade de Negócio AGE(HP).
	
@author Gustavo Luiz
@since 19/08/2016

@param cFilePath, String, Arquivo a ser processado
/*/
user function Ag2InvReq(cFilePath)

	local lValid        := .T.
	local nBom          := 0
	local lOk			:= .T.
	local lIsItem		:= .T.
	local isValidOrder	:= .F.
	
	private oLogImp     := DHLLogManager():newDHLLogManager()
	private cShipping   := getShipping()
	private cCnpjCli    := getCnpjCustomer()
	private cSalesOrd   := getSalesOrder()
	private cReturn		:= getReturnFlag()
	private cFile       := cFilePath
	private cProds		:= ""
	private aProducts   := retProducts(@lIsItem)
	private lMsErroAuto := .F.
	
	private aDetails2        := {}
	private aDetails         := {}
	private cCliFor			 := ""
	private cLoja			 := ""
	private	cEmail			 := ""
	private cProductionOrder := ""
	private cIdOp			 := ""
	private cItem            := ""
	private cBranchCust		 := ""
	
	isValidOrder := validOrder()
	
	if lIsItem .and. isValidOrder
		BEGIN TRANSACTION
			BEGIN SEQUENCE
			
				lOk := incOutflowOrder()
				
				if !(lOK)
					BREAK
				endif
			
			RECOVER
				DisarmTransaction()
			END SEQUENCE
		END TRANSACTION	
	else
		lOk := .F.
	endIf

return lOk


/**
* Coleta os Items da interface Invoice Request
**/
static function retProducts(lIsItem)
	
	local aItems       := {}
	local nItem        := 1
	local nLenItem     := 0
	
	if ValType(oXml:_INV_REQ:_BODY) <> nil
		if Type("oXml:_INV_REQ:_BODY:_FILEITEM") <> "U"
			if ValType(oXml:_INV_REQ:_BODY:_FILEITEM) == "A"
				
				nLenItem := Len(oXml:_INV_REQ:_BODY:_FILEITEM)
				aItems   := {}
					
				for nItem := 1 to nLenItem
					aAdd(aItems,{getProduct(@nItem),getQuantity(@nItem), getUOM(@nItem)})
				next
					
			elseif ValType(oXml:_INV_REQ:_BODY:_FILEITEM) == "O"
			
				nItem	:= 0
				aItems  := {}
				aAdd(aItems,{getProduct(@nItem),getQuantity(@nItem), getUOM(@nItem)})
					
			endif
		else
			lIsItem := .F.
			setFileLog(cFile,"fail","Interface não pode ser processada, pois não possui a estrutura de itens.")
		endIf
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
static function getUOM(nItem)
	local xRet := ""
	
	if nItem > 0
		xRet := oXml:_INV_REQ:_BODY:_FILEITEM[nItem]:_UOM:TEXT
	else
		xRet := oXml:_INV_REQ:_BODY:_FILEITEM:_UOM:TEXT
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
	local lOk		:= .t.
	
	mountDetail()
	
	aAdd(aHeader,{"C5_TIPO"   , getDocType()                 	 ,nil})
	aAdd(aHeader,{"C5_CLIENTE", cCliFor  					 	 ,nil})
	aAdd(aHeader,{"C5_LOJACLI", cLoja 						 	 ,nil})
	aAdd(aHeader,{"C5_CONDPAG" , GetMV("ZZ_CONDINT")         	 ,nil})
	aAdd(aHeader,{"C5_ZZSHIP"  , cShipping                   	 ,nil})
	aAdd(aHeader,{"C5_ZZTIPO"  , getDocType()   			 	 ,nil})
	aAdd(aHeader,{"C5_ZZORDEX" , getSalesOrder()			 	 ,nil})
	If cReturn == 'S'
		aAdd(aHeader,{"C5_ZZTPPV" , RETORNO_EFETIVO			 	 ,nil})
		aAdd(aHeader,{"C5_ZZSTATU", DHL_PV_PENDENTE_INFORMACAO   ,nil})
	else
		aAdd(aHeader,{"C5_TPFRETE" , 'S'         	 ,nil})
		aAdd(aHeader,{"C5_ZZTPPV" , RETORNO_SIMBOLICO			 ,nil})
	EndIf
	
	MSExecAuto({|x, y, z| Mata410(x, y, z)}, aHeader, aDetails, 3)
	
	if lMsErroAuto
		lOk := .f.
		DisarmTransaction()
		setFileLog(cFile,"fail","Falha ao incluir o pedido de vendas"+CRLF+CRLF+oUtils:getErroAuto())
	else
		if len(aDetails2) > 0
			MSExecAuto({|x, y, z| Mata410(x, y, z)}, aHeader, aDetails2, 3)
			if lMsErroAuto
				lOk := .f.
				DisarmTransaction()
				setFileLog(cFile,"fail","Falha ao incluir o pedido de vendas"+CRLF+CRLF+oUtils:getErroAuto())
			endif
		endif
	endIf
		
	
	
return (lOk)


/**
* Monta os Itens do Pedido de Venda
**/
static function mountDetail()

	local oSqlAux	:= IpSqlObject():newIpSqlObject()
	local nI		:= 0
	local nUnitPrice:= 0
	local nQuantity := 0
	local cProduct  := ""
	local cQuery	:= ""
	local cUnidMed	:= ""
	local cTes		:= alltrim(GetNewPar("ZZ_TESSAI"))
	local aAux := {}
	
	aDetails  := {}
	
	groupProducts()
	
	If incCustomer(aProducts[1,1])
	
		for nI := 1 to Len(aProducts)
			
			aAux 	  	:= {}
			cProduct  	:= PadR(aProducts[nI,1], TamSx3("B1_COD")[1])
			nQuantity 	:= aProducts[nI,2]
			cUnidMed	:= oSqlAux:getFieldValue("SB1", "B1_UM", "%SB1.XFILIAL% AND B1_COD = '"+cProduct+"' ")
			nPrecoUnit	:= GetPrecoUnit(cProduct)
			
			if len(aDetails) == 0
				cItem := "01"
			else
				cItem := Soma1(aDetails[len(aDetails),1,2])
			endif
														
			aAdd(aAux,{"C6_ITEM"   	,cItem           		,nil})
			aAdd(aAux,{"C6_PRODUTO"	,cProduct		 		,nil})
			aAdd(aAux,{"C6_QTDVEN" 	,nQuantity       		,nil})
			aAdd(aAux,{"C6_PRCVEN" 	,nPrecoUnit      		,nil})
			aAdd(aAux,{"C6_VALOR" 	,nQuantity*nPrecoUnit   ,nil})
			aAdd(aAux,{"C6_TES" 	,cTes            		,nil})
			aAdd(aAux,{"C6_UOM" 	,cUnidMed        		,nil})
			
			aAdd(aDetails,aAux)
			
		next nI
	Else
		DisarmTransaction()
		setFileLog(cFile,"fail","Interface não pode ser processada. Cliente não localizado no Protheus - CNPJ: "+alltrim(cCnpjCli)+".")
		lOk := .f.
	EndIf
	
return

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
	local cUnidMedi	 := ""
	local aGroupProd := {}
	
	for nI := 1 to Len(aProducts)
		
		cProduct  := aProducts[nI,1]
		nQuantity := aProducts[nI,2]
		cUnidMedi := aProducts[nI,3]
		nScan	  := aScan(aGroupProd, {|x| x[1] == cProduct })
		
		if (nScan > 0)
			aGroupProd[nScan,2] += nQuantity
		else
			aAdd(aGroupProd, {cProduct, nQuantity, cUnidMedi})
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
static function getCliFor(cProduct)
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	local lOk	 	:= .t.
	
	cQuery += " SELECT "
	
	if getDocType() == 'N'
		cQuery += " A1_COD CODIGO, A1_LOJA LOJA"
		cQuery += " FROM %SA7.SQLNAME% "
		cQuery += " INNER JOIN %SA1.SQLNAME% ON "
		cQuery += " 		A1_FILIAL 	= A7_FILIAL "
		cQuery += " 		AND A1_COD 		= A7_CLIENTE "
		cQuery += " 		AND A1_LOJA		= A7_LOJA "
		cQuery += " WHERE "
		cQuery += " 		A7_PRODUTO 	= '"+cProduct+"' "
		cQuery += " 		AND %SA7.XFILIAL% "
		cQuery += " 		AND %SA7.NOTDEL% "
	else
		cQuery += " A2_COD CODIGO, A2_LOJA LOJA"
		cQuery += " FROM %SA5.SQLNAME% "
		cQuery += " INNER JOIN %SA5.SQLNAME% ON "
		cQuery += " 		A1_FILIAL 		= A5_LOJA "
		cQuery += " 		AND A1_COD 		= A5_FORNECE "
		cQuery += " 		AND A1_LOJA		= A5_LOJA "
		cQuery += " WHERE "
		cQuery += " 		A5_PRODUTO 	= '"+cProduct+"' "
		cQuery += " 		AND %SA5.XFILIAL% "
		cQuery += " 		AND %SA5.NOTDEL% "
	endif
	
	oSqlUtil:newAlias(cQuery)
	
	If oSqlUtil:hasRecords()
		cCliFor := oSqlUtil:getValue("CODIGO")
		cLoja   := oSqlUtil:getValue("LOJA")
	Else
		lOk := .f.
	EndIf
	
	oSqlUtil:close()
	
return (lOk)


/**
 * Obtem a query dos itens do pedido de venda
 */
static function getQueryItens(cProduct)

	local cQuery := ""
	
	cQuery := "SELECT D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_ITEM,D1_VUNIT,D1_LOCAL,D1_TOTAL,D1_EMISSAO,B6_FILIAL,B6_PRODUTO,B6_QUANT,"
	cQuery += "       B6_CLIFOR,B6_LOJA,B6_PODER3,B6_TPCF,B6_TIPO,B6_IDENT,B6_PRUNIT,(B6_SALDO - B6_QULIB) B6_SALDO,F4_TESDV"
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
	cQuery += " SD1.D_E_L_E_T_ = ' ' AND "
	cQuery += "      F4_FILIAL = '" + xFilial("SF4") + "' AND "
	cQuery += "      F4_CODIGO = B6_TES AND "
	cQuery += " SF4.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY D1_EMISSAO "

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
static function incCustomer(cProduct)
	
	lOk := getCliFor(cProduct)
			
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
		setFileLog(cFile,"fail","Interface não pode ser processada. Shippment: "+alltrim(cShipping)+" e Delivery: "+alltrim(cSalesOrd)+" já utilizados no Protheus.")
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
* Coleta o Return Flag
**/
static function getReturnFlag()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_RETURN_FLAG:TEXT



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

/**
* Verifica se existe o SHIPPING_NUMBER e SALES_ORDER (Delivery)
**/
static function existShipDeliv(cShipping, cSalesOrd)
	
	local oSql 				:= IpSQLObject():newIpSQLObject()
	local lExistShipDeliv	:= .F.
	
	
	
	
return