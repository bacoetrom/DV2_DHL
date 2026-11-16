#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"

#define ADD  	'A'
#define UPD	 	'U'
#define DEL   	'D'

#define PRODUCT      1
#define QUANTITY     2
#define UM		     3
#define PRICE     	 4
#define OPERATION    5

 
/*/{Protheus.doc} ImpPedCom

Rotina responsável por ler e processar a interface P2P63 e atualizar os dados referentes ao documento.
	
@author Thiago Meschiatti
@since 12/05/2016

@param cFilePath, String, Arquivo a ser processado
/*/
user function ImpPedCom(cFilePath)

	local lValid        := .T.
	local nBom          := 0
	local lOk			:= .T.
	
	private oLogImp     := DHLLogManager():newDHLLogManager()
	private cSupplierId := getSupplier()
	private cPONumber  	:= getPONumber()
	private cFile       := cFilePath
	private aProducts   := retProducts()
	private lExistPO	:= existPO()
	private lMsErroAuto := .F.
	private lTemPoder3	:= .T.
	
	private aDetails         := {}
	private cCliFor			 := ""
	private cLoja			 := ""
	private cProdsError      := ""
	
	BEGIN TRANSACTION
		BEGIN SEQUENCE
			if lExistPO
				lOk := delPurchaseOrd()
			endif
			if lOk
				lOk := incPurchaseOrd()
			endif
		RECOVER
			DisarmTransaction()
		END SEQUENCE
	END TRANSACTION

return lOk

/**
* Coleta o Shipping Number
**/
static function getSupplier()
return oXml:_P2P63:_BODY:_FILEHEADER:_SUPPLIER_ID:TEXT


/**
* Coleta o Customer CNPJ
**/
static function getPONumber()
return oXml:_P2P63:_BODY:_FILEHEADER:_DOCUMENT_NUMBER:TEXT


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
	
	if ValType(oXml:_P2P63:_BODY) <> nil
		if ValType(oXml:_P2P63:_BODY:_FILEITEM) == "A"
				
			nLenItem := Len(oXml:_P2P63:_BODY:_FILEITEM)
			aItems   := {}
					
			for nItem := 1 to nLenItem
				aAdd(aItems,{getProduct(@nItem),getQuantity(@nItem), getUM(@nItem), getPrice(@nItem), getOperation(@nItem)})
			next
					
		elseif ValType(oXml:_P2P63:_BODY:_FILEITEM) == "O"
			
			nItem	:= 0
			aItems  := {}
			aAdd(aItems,{getProduct(@nItem),getQuantity(@nItem), getUM(@nItem), getPrice(@nItem), getOperation(@nItem)})
					
		endif
				
	else
		aAdd(aItems,{})
	endif
	
return aItems


/**
* Coleta o Produto
**/
static function getProduct(nItem)
	local xRet := ""
	
	if nItem > 0
		xRet := AllTrim(oXml:_P2P63:_BODY:_FILEITEM[nItem]:_ITEM:TEXT)
	else
		xRet := AllTrim(oXml:_P2P63:_BODY:_FILEITEM:_ITEM:TEXT)
	endif
return (xRet)


/**
* Coleta a Quantidade
**/
static function getQuantity(nItem)
	local xRet := ""
	
	if nItem > 0
		xRet := Val(oXml:_P2P63:_BODY:_FILEITEM[nItem]:_QUANTITY:TEXT)
	else
		xRet := Val(oXml:_P2P63:_BODY:_FILEITEM:_QUANTITY:TEXT)
	endif
return (xRet)


/**
* Coleta a Unidae de Medida
**/
static function getUM(nItem)
	local xRet := ""
	
	if nItem > 0
		xRet := oXml:_P2P63:_BODY:_FILEITEM[nItem]:_UOM:TEXT
	else
		xRet := oXml:_P2P63:_BODY:_FILEITEM:_UOM:TEXT
	endif
return (xRet)


/**
* Coleta o Preço
**/
static function getPrice(nItem)
	local xRet := ""
	
	if nItem > 0
		xRet := Val(oXml:_P2P63:_BODY:_FILEITEM[nItem]:_PRICE:TEXT)
	else
		xRet := Val(oXml:_P2P63:_BODY:_FILEITEM:_PRICE:TEXT)
	endif
return (xRet)


/**
* Coleta o Status da Linha
**/
static function getOperation(nItem)
	local xRet := ""
	
	if nItem > 0
		xRet := oXml:_P2P63:_BODY:_FILEITEM[nItem]:_OPERATION_TYPE:TEXT
	else
		xRet := oXml:_P2P63:_BODY:_FILEITEM:_OPERATION_TYPE:TEXT
	endif
return (xRet)


/**
* Coleta a unidade de medida do Produto
**/
static function UnitMeasure(cProduct)
return AllTrim(oSql:getFieldValue("SB1","B1_UM","B1_FILIAL = '%SB1.FILIAL%' AND B1_COD = '" + cProduct + "'"))


/**
* Inclui o Pedido de Compras
**/
static function incPurchaseOrd()

	local aHeader	:= {} 
	local lOk		:= .t.		
	
	lOk := getCliFor()
	
	if lOk 
		lOk := mountDetail()
		
		aadd(aHeader,{"C7_FILIAL"  , xFilial("SC7")})	
		aadd(aHeader,{"C7_EMISSAO" , dDataBase})	
		aadd(aHeader,{"C7_FORNECE" , cCliFor})	
		aadd(aHeader,{"C7_LOJA"    , cLoja})	
		aadd(aHeader,{"C7_COND"    , GetNewPar("ZZ_CONDINT", "")})	
		aadd(aHeader,{"C7_CONTATO" , "AUTO"})
		aadd(aHeader,{"C7_FILENT"  , cFilAnt})
		
		if lOk
			adjDetails()
			MSExecAuto({|x,y,w,z| MATA120(x,y,w,z)},1,aHeader,aDetails,3)
			
			if lMsErroAuto
				lOk := .f.
				DisarmTransaction()
				setFileLog(cFile,"fail","Falha ao incluir o pedido de compras"+CRLF+CRLF+oUtils:getErroAuto())	
			endIf
		endif
	endif
return lOk 


/**
* Inclui o Pedido de Compras
**/
static function delPurchaseOrd()

	local oSqlDel	:= IpSqlObject():newIpSqlObject()
	local aHeader	:= {}
	local lOk		:= .t.
	local cQuery	:= "%SC7.XFILIAL% AND C7_ZZPOEXT = '" + cPONumber + "' "
	
	lOk := validPO()
		
	if lOk
		oSqlDel:newTable("SC7", "*", cQuery)
		
		aadd(aHeader,{"C7_FILIAL"  , oSqlDel:getValue("C7_FILIAL")})
		aadd(aHeader,{"C7_NUM"     , oSqlDel:getValue("C7_NUM")})
		aadd(aHeader,{"C7_EMISSAO" , oSqlDel:getValue("C7_EMISSAO")})
		aadd(aHeader,{"C7_FORNECE" , oSqlDel:getValue("C7_FORNECE")})
		aadd(aHeader,{"C7_LOJA"    , oSqlDel:getValue("C7_LOJA")})
		aadd(aHeader,{"C7_COND"    , oSqlDel:getValue("C7_COND")})
		aadd(aHeader,{"C7_CONTATO" , oSqlDel:getValue("C7_CONTATO")})
		aadd(aHeader,{"C7_FILENT"  , oSqlDel:getValue("C7_FILENT")})
		
		lOk := mountDetail(.t., oSqlDel)
			
		if lOk
			dbSelectArea("SC7")
			SC7->(dbSetOrder(1))
			nModulo := 2
			MSExecAuto({|x,y,w,z| MATA120(x,y,w,z)},1,aHeader,aDetails,5)
				
			if lMsErroAuto
				lOk := .f.
				DisarmTransaction()
				setFileLog(cFile,"fail","Falha ao excluir o pedido de compras"+CRLF+CRLF+oUtils:getErroAuto())
			endIf
		endif
	endif
return lOk 


/**
* Monta os Itens do Pedido de Compras
**/
static function mountDetail(lDel, oSql)

	local nI,nJ		 := 0
	local nUnitPrice := 0
	local nQuantity  := 0
	local nPos		 := 0
	local cProduct   := ""
	local cQuery	 := ""
	local cUm		 := ""
	local cPrice	 := ""
	local cOperation := ""
	local lErro		 := .f.
	local lAlter	 := .f.
	local aAux		 := {}
	
	default lDel := .f.
	
	//Thiago Meschiatti - FSW TOTVS IP Campinas - 03/10/2016
	lAlter := len(aDetails) > 0
	
	if !lAlter
		aDetails := {}
	endif
	
	if lDel
		while oSql:notIsEof()
			aAux := {}
			
			aAdd(aAux,{"C7_PRODUTO"	, oSql:getValue("C7_PRODUTO")	,nil})
			aAdd(aAux,{"C7_QUANT"	, oSql:getValue("C7_QUANT")		,nil})
			aAdd(aAux,{"C7_UM" 		, oSql:getValue("C7_UM") 		,nil})
			aAdd(aAux,{"C7_PRECO" 	, oSql:getValue("C7_PRECO") 	,nil})
			aAdd(aAux,{"C7_TOTAL"   , oSql:getValue("C7_TOTAL")  	,nil})
			aAdd(aAux,{"C7_ZZPOEXT" , oSql:getValue("C7_ZZPOEXT")	,nil})
			aAdd(aAux,{"C7_ZZAUTO"  , oSql:getValue("C7_ZZAUTO") 	,nil})
			aadd(aAux,{"C7_REC_WT"  , oSql:getValue("R_E_C_N_O_")   ,Nil})
					
			aAdd(aDetails,aAux)
			oSql:skip()
		end
	else
		for nI := 1 to Len(aProducts)
		
			aAux := {}
		
			if lErro
				exit
			endif
		
			cProduct  := aProducts[nI,PRODUCT]
			nQuantity := aProducts[nI,QUANTITY]
			cUm	  	  := aProducts[nI,UM]
			cPrice 	  := aProducts[nI,PRICE]
			cOperation:= aProducts[nI,OPERATION]
			
			if alltrim(cOperation) $ alltrim(ADD)
			
				lErro := retCodProd(@cProduct)
					
				aAdd(aAux,{"C7_PRODUTO"	, cProduct      		,nil})
				aAdd(aAux,{"C7_QUANT"	, nQuantity				,nil})
				aAdd(aAux,{"C7_UM" 		, cUm           		,nil})
				aAdd(aAux,{"C7_PRECO" 	, cPrice  				,nil})
				aAdd(aAux,{"C7_TOTAL"   , nQuantity * cPrice	,nil})
				aAdd(aAux,{"C7_ZZPOEXT" , cPONumber				,nil})
				aAdd(aAux,{"C7_ZZAUTO"  , 'S'					,nil})
						
				aAdd(aDetails,aAux)
			
			elseif alltrim(cOperation) $ alltrim(UPD)
			
				lErro := retCodProd(@cProduct)
				
				if !lErro
					
					for nJ:= 1 to len(aDetails)
						nPos := aScan(aDetails[nJ],{|x| AllTrim(x[2]) == alltrim(cProduct)})
						if (nPos > 0)
							exit
						endif
					next nJ
					
					if (nPos > 0)
						aDetails[nJ, 2, 2]	:= nQuantity			
						aDetails[nJ, 4, 2]	:= cPrice  			
						aDetails[nJ, 5, 2]	:= nQuantity * cPrice
						aDetails[nJ, 6, 2]	:= cPONumber			
						aDetails[nJ, 7, 2]	:= 'S'
					else
						lErro := .t.
						setFileLog(cFile,"fail","Falha ao incluir o pedido de compras: "+CRLF+CRLF+"Produto: "+alltrim(cProduct)+" não foi localizado no pedido de compra!" )
					endif
				endif
			else
			
				lErro := retCodProd(@cProduct)
				
				if !lErro
					for nJ:= 1 to len(aDetails)
						nPos := aScan(aDetails[nJ],{|x| AllTrim(x[2]) == alltrim(cProduct)})
						if (nPos > 0)
							exit
						endif
					next nJ
					
					aDel(aDetails, nJ)
					aSize(aDetails, len(aDetails)-1)				
				endif
			endif
					
		next nI
	endif
	
	if !(lDel)
		if len(aDetails) <= 0
			lErro := .t.
			setFileLog(cFile,"fail","Falha ao incluir o pedido de compras: "+CRLF+CRLF+"Todas linhas do Pedido foram deletadas." )	
		endif
	endif
	
return !(lErro)


/**
 * Define os Logs de acordo com os tipos de arquivos
 */
static function setFileLog(cFile,cLogType,cLogText,cTag,cValue)
	
	local cInterface := "P2P63 - Pedido de Compra"
	
	oLog:start(APP_SUPPLYME,DHL_IMPORTACAO,cFile)
	
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
	
	oSqlUtil:newTable("SA2", "A2_COD, A2_LOJA", "A2_FILIAL = '%SA2.FILIAL%' AND A2_ZZIDEXT = '" + cSupplierId + "' ")
	if oSqlUtil:hasRecords()
		cClifor	:= oSqlUtil:getValue("A2_COD")
		cLoja	:= oSqlUtil:getValue("A2_LOJA")
	else
		setFileLog(cFile,"fail","Falha ao incluir o pedido de compras. Cliente/Fornecedor não localizado.")
		lOk := .f.
	endif
	
	oSqlUtil:close()
	
return (lOk)


/*
** Amarração Produto x Fornecedor
*/
static function retCodProd(cProduct)
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local lErro	 	:= .f.

	oSqlUtil:newTable("SA5", "A5_PRODUTO",	"A5_FILIAL = '%SA5.FILIAL%' AND A5_CODPRF = '" + cProduct + "' AND "+;
											"A5_FORNECE = '"+cCliFor+"' AND A5_LOJA = '"+cLoja+"' ")
	if oSqlUtil:hasRecords()
		if oSqlUtil:count() > 1
			setFileLog(cFile,"fail","Falha ao incluir o pedido de compras. Produto: " + alltrim(cProduct) + " possuí amarração com mais de um fornecedor.")
			lErro := .t. 
		else
			cProduct := oSqlUtil:getValue("A5_PRODUTO")
		endif
	else
		setFileLog(cFile,"fail","Falha ao incluir o pedido de compras. Produto: " + alltrim(cProduct) + " não possuí amarração Produto x Fornecedor.")
		lErro := .t. 
	endif
	oSqlUtil:close()
return lErro


/*
** Valida se PC possuí movimentação
*/
static function validPO()
	local oSql		:= IpSqlObject():newIpSqlObject()
	local lOk	 	:= .t.
	local cQuery	:= ""
	
	cQuery += " SELECT D1_DOC " 
	cQuery += " FROM %SC7.SQLNAME% "
	cQuery += " INNER JOIN %SD1.SQLNAME% ON "
	cQuery += "		D1_FILIAL 		= C7_FILIAL " 
	cQuery += "		AND D1_PEDIDO 	= C7_NUM "
	cQuery += "		AND %SD1.XFILIAL% "
	cQuery += "		AND %SD1.NOTDEL% "
	cQuery += " WHERE "
	cQuery += " 	C7_ZZPOEXT = '"+cPONumber+"' "
	cQuery += "		AND %SC7.XFILIAL% "
	cQuery += "		AND %SC7.NOTDEL% "

	oSql:newAlias(cQuery)
	
	if oSql:hasRecords()
		setFileLog(cFile,"fail","Falha ao alterar pedido de compras. Pedido de Compra com Purchase Order: " + cPONumber + " já possuí movimentações no Protheus.")
		lOk := .f.
	endif
	
	oSql:close()
	
return (lOk)


/*
** Verifica se existe Pedido de Compra no Protheus para PO do Cliente
*/
static function existPO()
	local oSql	:= IpSqlObject():newIpSqlObject()
	local lRet	:= .f.

	oSql:newTable("SC7", "C7_NUM",	"%SC7.XFILIAL% AND C7_ZZPOEXT = '" + cPONumber + "' ")
	
	if oSql:hasRecords()
		lRet := .t.
	endif
	
	oSql:close()
return (lRet)


/*
** Ajusta array de detalhes
*/
static function adjDetails()
	local nI, nPos := 0
	
	for nI:=1 to len(aDetails)
		nPos := aScan(aDetails[nI],{|x| AllTrim(x[1]) == "C7_REC_WT"})
		
		if ( nPos > 0)
			aDel(aDetails[nI], nPos)
			aSize(aDetails[nI], len(aDetails[nI])-1)
		endif
	next nI
return