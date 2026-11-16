#include "totvs.ch"
#include "dhl.ch"

#define ASN_APROVADA  "A"
#define ASN_REPROVADA "R"

#define PRODUCT         1
#define QUANTITY        2

/*/{Protheus.doc} SplASNConf
Importação da Interface ASN Confirmation - Select New.

@author Diogo Mesquita
@since 22/11/2021
@version undefined

@param cFilePath, characters, Caminho do arquivo.
@type function
/*/
user function SplASNConf(cFilePath)

	local lOk             	 := .T.
	
	private cFile            := cFilePath
	private oXml			 := nil
		
	if !parserFile()
		return .F.
	endIf
	
	private cNota            := getNota()
	private cSerie           := getSerie()
	private cCnpj            := getCnpj()
	private cClieFor         := getClieFor()
	private cLoja            := getLoja()
	private cStatus          := getStatus() 
	private aItems           := getItems()
	private cReceiveOrder    := getReceiveOrder()
	
	setDocInfo()
	
	if cStatus == ASN_APROVADA
	
		if asnAlreadyConfirmed()
			return .F.
		endIf

		lOk := validAsnProducts()		

		updateAsnData(lOk)
	
	elseif cStatus == ASN_REPROVADA
	
		updateStatus(DHL_DOC_CANCELADO)
	
	endif

return lOk

/**
* Coleta os Itens da Nota Fiscal
**/
static function getItems()
	local nItem    := 1
	local nLength  := 0
	local aItems   := {}
	local nPos     := 0
	local cProduct := ""
	
	if ValType(oXml:_ASN_CONF:_BODY:_FILEITEM) == "A"

		nLength := Len(oXml:_ASN_CONF:_BODY:_FILEITEM)

		for nItem := 1 to nLength

			cProduct	:= getPrdDepara(oXml:_ASN_CONF:_BODY:_FILEITEM[nItem]:_ITEM:TEXT)
			
			nPos := aScan(aItems,{|x| upper(alltrim(x[PRODUCT])) == upper(alltrim(cProduct))})
			
			if nPos == 0
				aAdd(aItems,{cProduct,;
				Val(oXml:_ASN_CONF:_BODY:_FILEITEM[nItem]:_RECEIVED_QUANTITY:TEXT)})
			else
				aItems[nPos][QUANTITY] += Val(oXml:_ASN_CONF:_BODY:_FILEITEM[nItem]:_RECEIVED_QUANTITY:TEXT)
			endif
		next
	else
		aAdd(aItems,{getPrdDepara(oXml:_ASN_CONF:_BODY:_FILEITEM:_ITEM:TEXT),;
		Val(oXml:_ASN_CONF:_BODY:_FILEITEM:_RECEIVED_QUANTITY:TEXT)})
	endif

return aItems

/**
* Coleta o status da ASN Confirmation
**/
static function getStatus()	
return AllTrim(oXml:_ASN_CONF:_BODY:_FILEHEADER:_STATUS:TEXT)

/**
* Coleta o Receive Order da ASN Confirmation
**/
static function getReceiveOrder()	
return AllTrim(oXml:_ASN_CONF:_BODY:_FILEHEADER:_RECEIVE_ORDER:TEXT)

/**
* Coleta a Serie da Nota Fiscal
**/
static function getSerie()

	local cSerie := ""
	local nBegin := Len(AllTrim(cNota)) + 2

	cSerie := Substr(oXml:_ASN_CONF:_BODY:_FILEHEADER:_REFERENCE:TEXT,nBegin,4)	
	cSerie := SubStr(cSerie,1,Rat("_",cSerie)-1)
	cSerie := Padr(cSerie,3)

	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "ASN Confirmation - Serie: " + cSerie, 0, 0, {})

return cSerie

/**
* Coleta o Número da Nota Fiscal
**/
static function getNota()

	local cNota := ""

	cNota := Substr(oXml:_ASN_CONF:_BODY:_FILEHEADER:_REFERENCE:TEXT,1,10)
	cNota := Substr(cNota,1,Rat("_",cNota)-1)
	cNota := Padr(cNota,9)

	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "ASN Confirmation - Nota: " + cNota, 0, 0, {})

return cNota

/**
* Coleta o Cnpj do Fornecedor
**/
static function getCnpj()

	local cCnpj := ""
	local nBegin := Len(AllTrim(cNota)) + Len(AllTrim(cSerie)) + 3

	cCnpj := Substr(oXml:_ASN_CONF:_BODY:_FILEHEADER:_REFERENCE:TEXT,nBegin,14)		

	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "ASN Confirmation - Cnpj: " + cCnpj, 0, 0, {})

return cCnpj

/**
* Coleta o Código do Fornecedor da Nota Fiscal
**/
static function getClieFor(lCliente)

	local cClieFor	:= ""
	local oSql		:= ipSqlObject():newIpSqlObject()

	default lCliente := .f.

	if lCliente
		cClieFor := AllTrim(oSql:getFieldValue("SA1","A1_COD","A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = '" + cCnpj + "'"))
	else

		cClieFor := AllTrim(oSql:getFieldValue("SA2","A2_COD","A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = '" + cCnpj + "'"))

		if Empty(cClieFor)
			cClieFor := AllTrim(oSql:getFieldValue("SA1","A1_COD","A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = '" + cCnpj + "'"))
		endif

		FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "ASN Confirmation - ClieFor: " + cClieFor, 0, 0, {})
	endif
	
return cClieFor 

/**
* Coleta a Loja do Fornecedor da Nota Fiscal
**/
static function getLoja(lCliente)

	local cLoja		:= ""
	local oSql		:= ipSqlObject():newIpSqlObject()
	
	default lCliente := .f.

	if lCliente
		cLoja := AllTrim(oSql:getFieldValue("SA1","A1_LOJA","A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = '" + cCnpj + "'"))
	else

		cLoja := AllTrim(oSql:getFieldValue("SA2","A2_LOJA","A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = '" + cCnpj + "'"))

		if Empty(cLoja)
			cLoja := AllTrim(oSql:getFieldValue("SA1","A1_LOJA","A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = '" + cCnpj + "'"))
		endif

		FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "ASN Confirmation - Loja: " + cLoja, 0, 0, {})
	endif

return cLoja 

/**
* Coleta a TES para classificar a Nota Fiscal
**/
static function getTes()	
return Alltrim(SD1->D1_ZZTES)

/**
* Define os Logs de acordo com os tipos de arquivos
*/
static function setFileLog(cFile,cLogType,cLogText,cTag,cValue)

	local cInterface := "ASN Confirmation - Select New"
	
	if !(Empty(cTag))
		cLogText += CRLF+CRLF+"Tag: "+cTag
	endIf

	if !(Empty(cValue))
		cLogText += CRLF+CRLF+"Valor: "+cValue
	endIf

	if (cLogType == "fail")
		oLog:fail(cInterface,cLogText)
	elseIf (cLogType == "warn")
		oLog:warn(cInterface,cLogText)
	endIf	

return

/**
* Obtém o código do produto do depara (SA7)
**/
static function getPrdDepara(cProduto, cCnpjCli)

	local oDhlPrdDepara := DhlPrdDepara():newDhlPrdDepara()
	default cCnpjCli	:= ""

	cProduto := oDhlPrdDepara:getPrdProtheus(cProduto, cCnpjCli)

return allTrim(cProduto)

/**
* Verifica se a Pre-Nota já foi classificada
*/
static function asnAlreadyConfirmed()

	local lAlreadyConfirmed := .F.
	local oSql 				:= IpSqlObject():newIpSqlObject()

	oSql:newAlias(" SELECT 1 FROM %SF1.SQLNAME% "+;
	" 	INNER JOIN %SD1.SQLNAME% ON "+;
	" 		D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND "+;
	"			D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND D1_TES != ' ' AND %SD1.NOTDEL% "+;
	" WHERE F1_FILIAL = '%SF1.FILIAL%' AND F1_DOC = '" + cNota + "' AND F1_SERIE = '" + cSerie + "' AND "+;
	" F1_FORNECE = '" + cClieFor + "' AND F1_LOJA = '" + cLoja + "' AND %SF1.NOTDEL%")

	if oSql:hasRecords()
		lAlreadyConfirmed := .T.
		setFileLog(cFile, "warn", "Doc. de Entrada já classificado")
	endIf	

	oSql:close()

return lAlreadyConfirmed

/**
* Valida as Quantidades dos Produtos da ASN Confirmation	
*/
static function validAsnProducts()

	local lOk		:= .F.
	local nI		:= 0
	local nScan		:= 0
	local nQuant	:= 0
	local nSaldo	:= 0
	local cProduct  := ""
	local cErrors	:= "" 
	local aErpProds := {}
	local aXmlProds	:= aClone(aItems)
	local oSql 	 	:= IpSqlObject():newIpSqlObject() 	

	oSql:newAlias(" SELECT D1_COD PRODUCT, SUM(D1_QUANT) QUANT, SUM(D1_ZZQCONF) QTDCONF "+;
	" FROM %SF1.SQLNAME% "+;
	" 	INNER JOIN %SD1.SQLNAME% ON "+;
	" 		D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND "+;
	"			D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND %SD1.NOTDEL% "+;
	" WHERE F1_FILIAL = '%SF1.FILIAL%' AND F1_DOC = '" + cNota + "' AND F1_SERIE = '" + cSerie + "' AND "+;
	" F1_FORNECE = '" + cClieFor + "' AND F1_LOJA = '" + cLoja + "' AND %SF1.NOTDEL% "+;
	" GROUP BY D1_COD "+;
	" ORDER BY D1_COD ")

	while oSql:notIsEof()		
		aAdd(aErpProds, {oSql:getValue("PRODUCT"), oSql:getValue("QUANT"), oSql:getValue("QTDCONF")})		
		oSql:skip()
	endDo

	oSql:close()	

	for nI := 1 to Len(aXmlProds)
		cProduct := AllTrim(aXmlProds[nI,1])
		nQuant   := aXmlProds[nI,2]
		nScan 	 := aScan(aErpProds, {|x| AllTrim(x[1]) == cProduct })
		if (nScan == 0)
			cErrors += "- Produto não encontrado no Documento do Protheus: "+cProduct+CRLF+CRLF
		else
			nSaldo := (aErpProds[nScan,2] - aErpProds[nScan,3]) 
			if (nQuant > nSaldo)
				cErrors += "- Quantidade do Produto "+cProduct+" maior que o Saldo a Confirmar. Quantidade no Arquivo do Select: "+AllTrim(Str(nQuant))+". Saldo no Doc. do Protheus: "+AllTrim(Str(nSaldo))+CRLF+CRLF
			endIf				
		endIf	 
	next nI

	if Empty(cErrors)
		lOk := .T.
	else
		setFileLog(cFile, "warn", "Divergências entre Select e Protheus"+CRLF+CRLF+cErrors)
	endIf					

return lOk

/**
* Atualiza os dados do Documento da ASN Confirmation 	
*/
static function updateAsnData(lStatusOk)

	local lUpdOk	:= .F.
	local cStatus 	:= if(lStatusOk, updateAsnItems(), DHL_DOC_CONFIRMACAO_NEGADA)
	local oSql    	:= IpSqlObject():newIpSqlObject()
	local cRecOrder	:= cReceiveOrder
	local cWhere 	:= ""

	cWhere := "F1_FILIAL  = '%SF1.FILIAL%' AND "
	cWhere += "F1_DOC     = '" + cNota + "'    AND "
	cWhere += "F1_SERIE   = '" + cSerie + "'   AND "
	cWhere += "F1_FORNECE = '" + cClieFor + "' AND "
	cWhere += "F1_LOJA    = '" + cLoja + "'"

	if Empty(cRecOrder)
		cRecOrder := Space(1)
	else
		cRecOrder := Left(AllTrim(cRecOrder), Len(SF1->F1_ZZRORD))
	endIf

	lUpdOk := oSql:update("SF1", "F1_ZZSTATU = '"+cStatus+"', F1_ZZRORD = '"+cRecOrder+"' ",cWhere)
	
	if !lUpdOk
		setFileLog(cFile, "fail", "Falha interna ao atualizar o Doc. de Entrada: "+oSql:getLastError())	
	endIf

	if (lUpdOk .and. lStatusOk)
		oLog:success()
	endIf			

return lUpdOk

/**
* Atualiza os Itens da ASN Confirmation
*/
static function updateAsnItems()

	local nI		:= 0
	local cStatus 	:= ""
	local aXmlProds	:= aClone(aItems)
	local oSql    	:= IpSqlObject():newIpSqlObject()

	for nI := 1 to Len(aXmlProds)
		putAsnQuantConf(aXmlProds[nI,1], aXmlProds[nI,2])
	next nI	

	oSql:newAlias(" SELECT SUM(D1_QUANT - D1_ZZQCONF) SLDCONF "+;
	" FROM %SD1.SQLNAME% "+;
	" 	INNER JOIN %SF1.SQLNAME% ON " +;
	"			F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND "+;
	"			F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND "+;
	"			F1_LOJA = D1_LOJA AND %SF1.NOTDEL% "+;
	" WHERE D1_FILIAL = '%SD1.FILIAL%' AND D1_DOC = '" + cNota + "' AND D1_SERIE = '" + cSerie + "' AND "+;
	" D1_FORNECE = '" + cClieFor + "' AND D1_LOJA = '" + cLoja + "' AND %SD1.NOTDEL%")

	if (oSql:getValue("SLDCONF") == 0)
		cStatus := DHL_DOC_LIMPAR_STATUS
	else
		cStatus := DHL_DOC_CONFIRMACAO_PARCIAL
	endIf

	oSql:close()

return cStatus

/**
* Grava a Quantidade Confirma de um item da ASN Confirmation
*/
static function putAsnQuantConf(cProduct, nQuant)

	local nRecno    := 0
	local nSldConf  := 0
	local nPutSld	:= 0
	local aErpProds	:= {}
	local oSql    	:= IpSqlObject():newIpSqlObject()

	oSql:newAlias(" SELECT SD1.R_E_C_N_O_ RECSD1, (D1_QUANT - D1_ZZQCONF) SLDCONF "+;
	" FROM %SD1.SQLNAME% "+;
	" 	INNER JOIN %SF1.SQLNAME% ON "+;
	"			F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND "+;
	"			F1_SERIE = D1_SERIE AND F1_FORNECE = D1_FORNECE AND "+;
	"			F1_LOJA = D1_LOJA AND %SF1.NOTDEL% "+;
	" WHERE D1_FILIAL = '%SD1.FILIAL%' AND D1_DOC = '" + cNota + "' AND D1_SERIE = '" + cSerie + "' AND "+;
	" D1_FORNECE = '" + cClieFor + "' AND D1_LOJA = '" + cLoja + "' AND D1_COD = '"+cProduct+"' AND %SD1.NOTDEL%")

	while oSql:notIsEof()		
		aAdd(aErpProds, {oSql:getValue("RECSD1"),oSql:getValue("SLDCONF")})			
		oSql:skip()
	endDo

	oSql:close()

	for nI := 1 to Len(aErpProds)		

		nRecno   := aErpProds[nI,1]
		nSldConf := aErpProds[nI,2]
		nPutSld  := if(nQuant > nSldConf, nSldConf, nQuant)
		nQuant   -= nPutSld

		oSql:update("SD1", "D1_ZZQCONF = (D1_ZZQCONF + "+AllTrim(Str(nPutSld))+")", "R_E_C_N_O_ = "+AllTrim(Str(nRecno)))

		if (nQuant == 0)
			exit
		endIf

	next nI

return

/**
* Atualiza o status da Nota Fiscal de Entrada
*/
static function updateStatus(cStatus)

	local cWhere	:= ""
	local lUpdOk	:= .F.
	local oSql		:= IpSqlObject():newIpSqlObject()

	cWhere := "F1_FILIAL  = '%SF1.FILIAL%' AND "
	cWhere += "F1_DOC     = '"+cNota+"'    AND "
	cWhere += "F1_SERIE   = '"+cSerie+"'   AND "
	cWhere += "F1_FORNECE = '"+cClieFor+"' AND "
	cWhere += "F1_LOJA    = '"+cLoja+"'"

	lUpdOk := oSql:update("SF1","F1_ZZSTATU = '"+cStatus+"'",cWhere)

	if !(lUpdOk)
		setFileLog(cFile,"fail","Falha ao atualizar o status do Doc. de Entrada"+CRLF+CRLF+oSql:getLastError())
	else
		oLog:success()
	endif

return lUpdOk

/**
* Faz o parser do arquivo xml
**/
static function parserFile()

	local cError    := ""
	local cWarning  := ""
	local lParsed	:= .T.

	oXml := XmlParserFile(cFile,"_",@cError,@cWarning)

	if !(Empty(cError)) .or. !(Empty(cWarning))	
		lParsed:= .F.
		setFileLog(cFile,"fail","Falha no parser do arquivo " + cFile+CRLF+CRLF+cError+CRLF+CRLF+cWarning)
	endif

return lParsed

/**
* Obtém informações de cabeçalho do documento de entrada
**/
static function setDocInfo()

	local oSql		:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	
	cQuery  := getQuery()
	oSql:newAlias(cQuery)

	if oSql:isEof()
		cClieFor  := getClieFor(.t.)
		cLoja     := getLoja(.t.)
	endif

	oSql:close()

return

/**
* Monta a Query para validação dos itens da Nota Fiscal de Entrada
**/
static function getQuery()

	local cQuery   := ""
	
	cQuery := "SELECT"                                                      +CRLF
	cQuery += "      B1_COD        ITEM, "                                  +CRLF      
	cQuery += "      SUM(D1_QUANT) QUANT "                                  +CRLF
	cQuery += "FROM %SF1.SQLNAME% "                                         +CRLF
	cQuery += "INNER JOIN %SD1.SQLNAME% "                                   +CRLF
	cQuery += "ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND "           +CRLF
	cQuery += "   D1_SERIE = F1_SERIE AND F1_FORNECE = D1_FORNECE AND "     +CRLF
	cQuery += "   D1_LOJA = F1_LOJA AND "                                   +CRLF                                       
	cQuery += "   %SD1.NOTDEL%"                                             +CRLF	
	cQuery += "INNER JOIN %SB1.SQLNAME%"                                    +CRLF
	cQuery += "ON B1_FILIAL = '%SB1.FILIAL%' AND"                           +CRLF 
	cQuery += "   B1_COD = D1_COD AND %SB1.NOTDEL%"                         +CRLF
	cQuery += "WHERE F1_FILIAL  = '%SF1.FILIAL%' AND"                       +CRLF
	cQuery += "      F1_DOC     = '"+cNota+"'    AND"                       +CRLF
	cQuery += "      F1_SERIE   = '"+cSerie+"'   AND"                       +CRLF
	cQuery += "      F1_FORNECE = '"+cClieFor+"' AND"                       +CRLF
	cQuery += "      F1_LOJA    = '"+cLoja+"'    AND"                       +CRLF
	cQuery += "      %SF1.NOTDEL%"                                          +CRLF
	cQuery += "GROUP BY B1_COD"									            +CRLF

return cQuery
