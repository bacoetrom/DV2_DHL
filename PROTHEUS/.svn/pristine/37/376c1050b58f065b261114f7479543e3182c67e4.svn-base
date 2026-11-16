#include "totvs.ch" 
#include "rwmake.ch"
#include "dhl.ch"

#define RETORNO_EFETIVO   "RE"
#define RETORNO_SIMBOLICO "RS"

/*/{Protheus.doc} AglInvReq

Rotina responsável por ler e processar a interface Invoice Request e atualizar os dados referentes ao documento.
	
@author Alberto Diorio
@since 19/02/2020

@param cFilePath, String, Arquivo a ser processado
/*/
user function SplInvReq(cFilePath)
	/*
	local lOk			:= .T.
	private cFile       := cFilePath
	private oXml		:= oXmlnew

	if isRepair()
		lOk := U_RepInvReq(cFilePath)
	else
		if getTipoNota() == RETORNO_EFETIVO				 
			lOk := U_AglRetEfetivo(cFilePath)
		elseif getTipoNota() != RETORNO_EFETIVO	//<SALES ORDER> contem RE ou o numero da NF de Venda. 					
			lOk := U_AglRetSimbolico(cFilePath)
		endif
	endif		
	*/
	
	local lOk 			:= .F.
	local aHeader		:= {}
	local aItems		:= {}
	local aProducts		:= {}
	local cShipNumber 	:= allTrim(oXml:OXML:_INV_REQ:_BODY:_FILEHEADER:_SHIPPING_NUMBER:TEXT)
	local cTypeDoc		:= getDocType() 
	local oUtils		:= IpUtilsObject():newIpUtilsObject()	
	private lMsErroAuto	:= .F.
	private lMsHelpAuto := .T.
	Private mcClifor		:= ""
	Private mcLoja			:= ""
	Private mcEmail			:= ""
	Private mcTipoCliFor	:= ""


	if !getInvRequestProducts(oXml, cFilePath, @aProducts)
		lMsHelpAuto := .F.
		return .F.
	endIf

//	if cTypeDoc 	==  "D"
//		cParam		:= "ZZ_FOINTEG"
//	endif


	fillInvRequestItems(aProducts, @aItems, cTypeDoc)  //AQUI

	getCliFor()

	aAdd(aHeader, {"C5_FILIAL", xFilial("SC5"), nil})
	aAdd(aHeader, {"C5_NUM", getNextSalesOrderNumber(), nil})
	aAdd(aHeader, {"C5_TIPO", cTypeDoc, nil})
	aAdd(aHeader, {"C5_CLIENTE", mcClifor, nil})
	aAdd(aHeader, {"C5_LOJACLI", mcLoja, nil})
	aAdd(aHeader, {"C5_CONDPAG", GetMv("ZZ_CONDINT"), nil})	
	aAdd(aHeader, {"C5_ZZSTATU", DHL_PV_PENDENTE_INFORMACAO, nil})
	aAdd(aHeader, {"C5_ZZSHIP", cShipNumber, nil})		

	MsExecAuto({|x,y,z| MATA410(x,y,z)}, aHeader, aItems, 3)

	if lMsErroAuto
		setFileLog(cFile, "fail", "Falha ao gerar Pedido de Vendas"+CRLF+CRLF+oUtils:getErroAuto())
	else
		lOk := .T.
		oLog:success()	
	endIf

	lMsHelpAuto := .F.
	
return lOk

/**
* Obtém o tipo de nota que o pedido var ser gerado:
* RETORNO EFETIVO ou RETORNO SIMBÓLICO
**/
static function getTipoNota()
	
	local cTipoNota := upper(allTrim(oXml:OXML:_INV_REQ:_BODY:_FILEHEADER:_SALES_ORDER:TEXT))
	
	if cTipoNota == RETORNO_EFETIVO
		cTipoNota := RETORNO_EFETIVO	
	endif
		
return cTipoNota

/**
* Verifica se o depositante é do tipo Reparador
**/
static function isRepair()
	local oSqlUtil		:= IpSqlObject():newIpSqlObject()
	local lRet	 		:= .f.
	local cDocType		:= getDocType()  //
	local cCNPJCustomer := getCnpjCustomer()
	
	if cDocType == 'N'
		oSqlUtil:newTable("SA1", "A1_COD, A1_LOJA, A1_ZZREPAR", "A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = '" + cCNPJCustomer + "' ")
		if oSqlUtil:hasRecords()
			if oSqlUtil:getValue("A1_ZZREPAR") == "S"
				lRet := .t.
			endIf
		endIf
	else
		oSqlUtil:newTable("SA2", "A2_COD, A2_LOJA, A2_ZZREPAR", "A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = '" + cCNPJCustomer + "' ")
		if oSqlUtil:hasRecords()
			if oSqlUtil:getValue("A2_ZZREPAR") == "S"
				lRet := .t.
			endIf
		endIf
	endIf
	oSqlUtil:close()

return lRet

/**
* Coleta o Document Type
**/
static function getDocType()
return oXml:OXML:_INV_REQ:_BODY:_FILEHEADER:_DOCUMENT_TYPE:TEXT

/**
* Coleta o Customer CNPJ
**/
static function getCnpjCustomer()
return oXml:OXML:_INV_REQ:_BODY:_FILEHEADER:_CUSTOMER_CNPJ:TEXT

/*
** Obtém o cliente/fornecedor
*/
static function getCliFor(cClifor, cLoja, cEmail, cTipoCliFor)
	
	local oSqlUtil		:= IpSqlObject():newIpSqlObject()
	local lOk	 		:= .t.
	local cCnpjCli		:= ""
	
	default cClifor 	:= ""
	default cLoja 		:= ""
	default cEmail 		:= ""
	default cTipoCliFor := ""

	
	cCnpjCli = getCnpjCustomer()
	
	if getDocType() == 'N'
		oSqlUtil:newTable("SA1", "A1_COD, A1_LOJA, A1_EMAIL", "A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = '" + cCnpjCli + "' ")
		if oSqlUtil:hasRecords()
			mcClifor		:= oSqlUtil:getValue("A1_COD")
			mcLoja			:= oSqlUtil:getValue("A1_LOJA")
			mcEmail			:= oSqlUtil:getValue("A1_EMAIL")
			mcTipoCliFor	 := "C"
		else
			lOk := .f.
		endif
	else
		oSqlUtil:newTable("SA2", "A2_COD, A2_LOJA, A2_EMAIL", "A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = '" + cCnpjCli + "' ")
		if oSqlUtil:hasRecords()
			mcClifor		:= oSqlUtil:getValue("A2_COD")
			mcLoja			:= oSqlUtil:getValue("A2_LOJA")
			mcEmail			:= oSqlUtil:getValue("A2_EMAIL")
			mcTipoCliFor 	:= "F"
		else
			lOk := .f.
		endif
	endif
	
	oSqlUtil:close()
	
return (lOk)

******************************************************************************************************************
Static Function getNextSalesOrderNumber()
******************************************************************************************************************	
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
/**
* Obtém o código do produto, cliente e loja
**/
static function doDePara(cCodPrdCli)
	
	local oSql	:= IpSqlObject():newIpSqlObject()
	local cRet	:= ""
	
	oSql:newTable("SA7","A7_PRODUTO, A7_CLIENTE, A7_LOJA","A7_FILIAL = '"+xFilial("SA7")+"' AND A7_CODCLI = '"+cCodPrdCli+"'")
		
	if oSql:notIsEof()
		cRet := oSql:GetValue("A7_PRODUTO")
		if empty(cClieFor) .and. empty(cLoja)
			cClieFor := oSql:GetValue("A7_CLIENTE")
			cLoja	 := oSql:GetValue("A7_LOJA")
		endIf
	endIf
		
	oSql:close()
	
return cRet
/**
* Preenche o array de items do Pedido de Vendas da Invoice Request
*/ 
static function fillInvRequestItems(aProducts, aItems, cTypeDoc)

	local nI 		:= 0
	local nY 		:= 0
	local nQuant	:= 0
	local nItem		:= 0
	local aItem		:= {}
	local cProduct	:= ""
	local cTes		:= GetMv("ZZ_TESSAI")

	default cTypeDoc := "N"

	aItems := {}

	for nI := 1 to Len(aProducts)		
		cProduct := aProducts[nI,1]
		nQuant	 := aProducts[nI,2]		
		for nY := 1 to nQuant	
			aItem := {}		
			aAdd(aItem, {"C6_ITEM", StrZero(++nItem, Len(SC6->C6_ITEM)), nil})
			aAdd(aItem, {"C6_PRODUTO", cProduct, nil})
			aAdd(aItem, {"C6_QTDVEN", 1, nil})
			aAdd(aItem, {"C6_PRCVEN", 1, nil})
			aAdd(aItem, {"C6_VALOR", 1, nil})
			aAdd(aItem, {"C6_TES", cTes, nil})			
			if cTypeDoc $ "D"
				aAdd(aItem, {"C6_NFORI", "X", nil})		
			endif
			aAdd(aItems, aItem)				
		next nY		
	next nI

return


/**
* Coleta os itens da Invoice Request
*/ 
static function getInvRequestProducts(oXml, cFile, aProducts)

	local nI	 	:= 0
	local nQuantity := 0
	local nScan		:= 0
	local cTag 	 	:= ""
	local cProduct  := ""
	local cNotExists:= ""
	local aItems 	:= {}
	local oSql		:= IpSqlObject():newIpSqlObject()

//	cTag := "INV_REQ:_BODY:_FILEITEM:_ITEM:TEXT"
	cTag := "INV_REQ:_BODY:_FILEITEM"
	
	aItems := oXml:getNodeArray(cTag)

	if (Len(aItems) == 0)
		setFileLog(cFile, "fail", "Não foi possível ler os itens da Invoice Request", cTag)
		return .F.	
	endIf

	for nI := 1 to Len(aItems)
		cProduct  := aItems[nI]:_ITEM:TEXT
		nQuantity := nQuantity := Val(aItems[nI]:_QUANTITY:TEXT)
		nScan	  := aScan(aProducts, {|x| x[1] == cProduct})
		if (nScan == 0)
			aAdd(aProducts, {cProduct,nQuantity})
		else
			aProducts[nScan,2] += nQuantity
		endIf
	next nI	

	for nI := 1 to Len(aProducts)
		if !oSql:exists("SB1", "B1_COD = '"+aProducts[nI,1]+"'")
			cNotExists += if(Empty(cNotExists), "", ", ")	
			cNotExists += AllTrim(aProducts[nI,1])		
		endIf
	next nI

	if !Empty(cNotExists)
		setFileLog(cFile, "fail", "Os seguintes produtos não estão cadastrados no Protheus: "+CRLF+CRLF+cNotExists)
		return .F.	
	endIf

return .T.


/**
* Verifica se o documento é do tipo de devolução
*/
static function getTypeDocument(oXml)

	local nI		  	:= 0
	local lOk		  	:= .F.
	local cDocTag		:= ""
	local cText			:= ""
	local cBusinessId 	:= ""
	local aBusinessId 	:= {}	

	cTag := "INV_REQ:_BODY:_FILEITEM"

	aBusinessId := oXml:getNodeArray(cDocTag)

	for nI := 1 to Len(aBusinessId)
		if !existDocumentTag(aBusinessId[nI])
			loop
		endIf
		cBusinessId := AllTrim(Lower(aBusinessId[nI]:_proprietaryBusinessIdentifier:text))
		if (cBusinessId == "ref2")
			cText := aBusinessId[nI]:_proprietaryDomainIdentifier:text
			exit
		endIf
	next nI

	if "IRISO" $ alltrim(upper(cText))
		lOk := .t.		 
	endif

return lOk
