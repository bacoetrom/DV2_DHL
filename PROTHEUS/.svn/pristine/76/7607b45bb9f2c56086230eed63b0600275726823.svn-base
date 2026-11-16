#include "totvs.ch"
#include "dhl.ch"

#define ASN_APROVADA  "A"
#define ASN_REPROVADA "R"

#define PRODUCT         1
#define QUANTITY        2
#define LOT			    3
#define EXPIRATION_DATE 4

#define ALTER_INVOICE 4


/*/{Protheus.doc} AgeASNConf
Importação da Interface ASN Confirmation.

@author Alberto Diorio
@since 18/02/2020
@version undefined

@param cFilePath, characters, Caminho do arquivo.
@type function
/*/
user function AglASNConf(cFilePath)

	local lValid             := .T.
	local lValcBenef 		 := SuperGetMV("ZZ_VALCBEN",,.F.)

	private cNota            := getNota()
	private cSerie           := getSerie()
	private cCnpj            := getCnpj()
	private cClieFor         := getClieFor()
	private cLoja            := getLoja()
	private cStatus          := getStatus() 
	private aItems           := getItems()
	private cReceiveOrder    := getReceiveOrder()
	private cROExternalIdent := getROExternalIdent()
	private cTipo	         := ""
	
	private lMsErroAuto      := .F.
	private aHeader          := {}
	private aDetail          := {}
	private cFile            := cFilePath

	setDocInfo()
	if isRepair(cClieFor,cLoja,cTipo)
		u_DlxASNConf(cFilePath)
		return
	endIf

	if cStatus == ASN_APROVADA

		lValid := validItem()

		if lValid

			updZZStatus(DHL_DOC_LIMPAR_STATUS)

			if isClassify()
				classifyInvoice()
				if !lError
					if lValcBenef
						lError := checkCBnefXMLIsCDV(cNota, cSerie, cClieFor, cLoja)
					endIf					
				endIf
			endif

			updReceiveOrder()

		else
			//DisarmTransaction()
			lError := .T.		
			updZZStatus(DHL_DOC_CONFIRMACAO_NEGADA)
		endif
	elseif cStatus == ASN_REPROVADA
		updZZStatus(DHL_DOC_CANCELADO)
	endif

return


/**
* Verifica se deve classificar a Nota Fiscal
**/
static function isClassify()

	local isClassify  := .T.
	local cCfops      := GetMv("ZZ_CFCOB")
	local cCfop       := ""
	local cQuery      := ""

	cQuery := "SELECT DISTINCT D1_ZZCFOP FROM %SD1.SQLNAME%"                               +CRLF
	cQuery += "WHERE D1_FILIAL = '%SD1.FILIAL%' AND D1_DOC = '" + cNota + "' AND"          +CRLF
	cQuery += "      D1_SERIE = '" + cSerie + "' AND D1_FORNECE = '" + cClieFor + "' AND " +CRLF
	cQuery += "      D1_LOJA = '" + cLoja + "' AND %SD1.NOTDEL%"                           +CRLF 

	oSql:newAlias(cQuery)

	while oSql:notIsEof()

		cCfop := AllTrim(oSql:getValue("D1_ZZCFOP"))

		if cCfop $ cCfops
			isClassify  := .F.
		endif

		oSql:skip()
	enddo

	oSql:close()

return isClassify


/**
* Atualiza o Receive Order e o Receive Order External Identifier da Nota Fiscal
**/
static function updReceiveOrder()

	local cWhere  := ""
	local lUpdate := nil

	cWhere := "F1_FILIAL  = '%SF1.FILIAL%' AND "
	cWhere += "F1_DOC     = '" + cNota + "'    AND "
	cWhere += "F1_SERIE   = '" + cSerie + "'   AND "
	cWhere += "F1_FORNECE = '" + cClieFor + "' AND "
	cWhere += "F1_LOJA    = '" + cLoja + "'"

	if !empty(cReceiveOrder) .and. !empty(cReceiveOrder)
		lUpdate := oSql:update("SF1","F1_ZZRORD = '"+cReceiveOrder+"',F1_ZZROEXT = '"+cROExternalIdent+"' ",cWhere)


		if !(lUpdate)
			lError := .T.
			setFileLog(cFile,"fail","Falha ao atualiza o Receive Order e o Receive Order External Identifier da Nota Fiscal"+CRLF+CRLF+oSql:getLastError())
		endif
	endif

return


/**
* Classifica a Nota Fiscal de Entrada
**/
static function classifyInvoice()

	local aDetails := {}
	local cKeySF1  := ""
	local cKeySD1  := ""

	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)

	if !(SF1->(Found()))
		return
	endif

	cKeySF1 := xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

	mountHeader()

	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(cKeySF1)

	if !(SD1->(Found()))
		return
	endif

	while !(SD1->(Eof()))

		cKeySD1 := SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

		if cKeySD1 != cKeySF1
			exit
		endif

		mountDetail()

		aAdd(aDetails,aDetail)

		SD1->(dbSkip())
	enddo

	if Len(aDetails) > 0

		ordenaDetailsByItem(@aDetails)

		//begin transaction
		MSExecAuto({ |x,y,z| MATA103(x,y,z) },aHeader,aDetails,ALTER_INVOICE)
		//end transaction

		if lMsErroAuto
			//DisarmTransaction()
			setFileLog(cFile,"fail","Falha ao classificar a Nota Fiscal de Entrada"+CRLF+CRLF+oUtils:getErroAuto())

			lError := .T. 
		endif
	endif

return


/**
* Monta o cabelhaço da Nota Fiscal
**/
static function mountHeader()

	aHeader := { {"F1_TIPO"   ,SF1->F1_TIPO   ,nil},;
	{"F1_FORMUL" ,SF1->F1_FORMUL ,nil},;
	{"F1_DOC"    ,SF1->F1_DOC    ,nil},;
	{"F1_SERIE"  ,SF1->F1_SERIE  ,nil},;
	{"F1_EMISSAO",SF1->F1_EMISSAO,nil},;
	{"F1_DTDIGIT",SF1->F1_DTDIGIT,nil},;
	{"F1_RECBMTO",SF1->F1_RECBMTO,nil},;
	{"F1_FORNECE",SF1->F1_FORNECE,nil},;
	{"F1_LOJA"   ,SF1->F1_LOJA   ,nil},;
	{"F1_COND"   ,SF1->F1_COND   ,nil},;
	{"F1_EST"    ,SF1->F1_EST    ,nil},;
	{"F1_ESPECIE",SF1->F1_ESPECIE,nil} }                 
return


/**
* Monta os items da Nota Fiscal
**/
static function mountDetail()

	local nCount	:= 0
	local aCposSX3	:= FWSX3Util():GetAllFields("SD1", .f.)

	aDetail := {}

	aAdd(aDetail,{"D1_ITEM"   ,SD1->D1_ITEM   ,nil})
	aAdd(aDetail,{"D1_COD"    ,SD1->D1_COD    ,nil})
	aAdd(aDetail,{"D1_UM"     ,SD1->D1_UM     ,nil})
	aAdd(aDetail,{"D1_QUANT"  ,SD1->D1_QUANT  ,nil})
	aAdd(aDetail,{"D1_VUNIT"  ,SD1->D1_VUNIT  ,nil})
	aAdd(aDetail,{"D1_TOTAL"  ,SD1->D1_TOTAL  ,nil})
	aAdd(aDetail,{"D1_LOCAL"  ,SD1->D1_LOCAL  ,nil})
	aAdd(aDetail,{"D1_LOTEFOR",SD1->D1_LOTEFOR,nil})
	aAdd(aDetail,{"D1_LOTECTL",SD1->D1_LOTECTL,nil})
	aAdd(aDetail,{"D1_DFABRIC",SD1->D1_ZZDFABR,nil})
	aAdd(aDetail,{"D1_DTVALID",SD1->D1_DTVALID,nil})
	aAdd(aDetail,{"D1_EMISSAO",SD1->D1_EMISSAO,nil})
	aAdd(aDetail,{"D1_TES"    ,getTes()       ,nil})

	for nCount := 1 to len(aCposSX3)

		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U"
			aAdd(aDetail,{AllTrim(aCposSX3[nCount]),&("SD1->" + AllTrim(aCposSX3[nCount])),nil})
		endIf

	next nCount

	aDetail:= FwVetByDic(aDetail, "SD1")

return


/**
* Atualiza o status da Nota Fiscal
**/
static function updZZStatus(cStatus)

	local cWhere  := ""
	local lUpdate := nil

	cWhere := "F1_FILIAL  = '%SF1.FILIAL%' AND "
	cWhere += "F1_DOC     = '"+cNota+"'    AND "
	cWhere += "F1_SERIE   = '"+cSerie+"'   AND "
	cWhere += "F1_FORNECE = '"+cClieFor+"' AND "
	cWhere += "F1_LOJA    = '"+cLoja+"'"

	lUpdate := oSql:update("SF1","F1_ZZSTATU = '"+cStatus+"'",cWhere)

	if !(lUpdate)
		lError := .T.
		setFileLog(cFile,"fail","Falha ao atualiza o status da Nota Fiscal"+CRLF+CRLF+oSql:getLastError())
	endif

return


/**
* Valida os Itens da Nota Fiscal
**/
static function validItem()

	local nItem       := 1
	local cQuery      := ""
	local lValid      := .T.
	local cQueryAlias := ""

	cQuery  := getQuery("")

	oSql:newAlias(cQuery)

	if oSql:isEof()
		cClieFor         := getClieFor(.t.)
		cLoja            := getLoja(.t.)

		cQuery  := getQuery("")
		oSql:newAlias(cQuery)

		if oSql:isEof() 
			Valid := .F.
			setFileLog(cFile,"warn","Não existe registro para a Nota " + cNota + " Série " + cSerie + " Fornecedor " + cClieFor + " Loja " + cLoja)
		endif
	endif

	oSql:close()

	if lValid
		//Thiago Meschiatti - FSW TOTVS IP Campinas - 08/02/2016
		if len(aItems) != getCountQry()
			lValid := .F.
			setFileLog(cFile,"warn","Quantidade de Itens entre ASN e a Nota " + cNota + " Série " + cSerie + " Fornecedor " + cClieFor + " Loja " + cLoja + " estão divergentes.")
		else

			for nItem := 1 to Len(aItems)
				
				cQuery  := getQuery(aItems[nItem][PRODUCT], aItems[nItem][LOT])
				
				oSql:newAlias(cQuery)

				if oSql:isEof()
					lValid := .F.
					setFileLog(cFile,"warn","Não existe registro para a Nota " + cNota + " Série " + cSerie + " Fornecedor " + cClieFor + " Loja " + cLoja + " Produto " + aItems[nItem][PRODUCT] + " ",;
					+ if(!empty(aItems[nItem][LOT]), "e Lote " + aItems[nItem][LOT], "")+" no Protheus.")
					exit
				endif

				cQueryAlias := oSql:getAlias()

				while oSql:notIsEof()

					if AllTrim((cQueryAlias)->ITEM) != AllTrim(aItems[nItem][PRODUCT])
						lValid := .F.
						setFileLog(cFile,"warn","Divergências entre os códigos " + AllTrim((cQueryAlias)->ITEM) + " e " + AllTrim(aItems[nItem][PRODUCT]))
						exit
					else
						if AllTrim((cQueryAlias)->LOT_NF) != AllTrim(aItems[nItem][LOT])
							lValid := .F.
							setFileLog(cFile,"warn","Divergências entre os lotes do Produto: " + AllTrim((cQueryAlias)->ITEM))
							exit
						else 
							if AllTrim((cQueryAlias)->LOT_VALID) != AllTrim(aItems[nItem][EXPIRATION_DATE])
								lValid := .F.
								setFileLog(cFile,"warn","Divergências entre data de validade do Lote: " + AllTrim((cQueryAlias)->LOT_NF))
								exit
							endif	
						endif						
					endif

					if (cQueryAlias)->QUANT != aItems[nItem][QUANTITY]
						lValid := .F.
						setFileLog(cFile,"warn","Divergências na quantidade do Item " + AllTrim(aItems[nItem][PRODUCT]) + " entre DLX e Protheus")
						exit
					endif

					oSql:skip()
				enddo

				oSql:close()		
			next
		endif
	endif

return lValid


/**
* Monta a Query para validação dos Itens da Nota Fiscal
**/
static function getQuery(cProduct, cLot)

	local cQuery   := ""
	local lProduct := if(Empty(cProduct),.F.,.T.)
	local lLot	   := if(Empty(cLot),.F.,.T.)	

	cQuery := "SELECT"                                                      +CRLF
	cQuery += "      B1_COD        ITEM, "                                  +CRLF      
	cQuery += "      SUM(D1_QUANT) QUANT, "                                 +CRLF
	cQuery += "      D1_LOTECTL LOT_NF, "                                	+CRLF 
	cQuery += "      D1_DTVALID LOT_VALID, "                               	+CRLF
	cQuery += "      F1_TIPO "			                                	+CRLF
	cQuery += "FROM %SF1.SQLNAME% "                                         +CRLF
	cQuery += "INNER JOIN %SD1.SQLNAME% "                                   +CRLF
	cQuery += "ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND "           +CRLF
	cQuery += "   D1_SERIE = F1_SERIE AND F1_FORNECE = D1_FORNECE AND "     +CRLF
	cQuery += "   D1_LOJA = F1_LOJA AND "                                   +CRLF                                       
	if lProduct
		cQuery += "   D1_COD = '"+cProduct+"' AND "                         +CRLF		
	endif
	if lLot
		cQuery += "   D1_LOTECTL 	= '"+cLot+"' AND "                  	+CRLF
	endif	
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
	cQuery += "GROUP BY B1_COD, D1_LOTECTL, D1_DTVALID, F1_TIPO"            +CRLF

return cQuery


/**
* Coleta os Itens da Nota Fiscal
**/
static function getItems()
	local nItem    := 1
	local nLength  := 0
	local aItems   := {}
	local nPos     := 0
	local cProduct := ""
	local cLot	   := ""
	local cExpDate := "" 
	
	if ValType(oXml:_ASN_CONF:_BODY:_FILEITEM) == "A"

		nLength := Len(oXml:_ASN_CONF:_BODY:_FILEITEM)

		for nItem := 1 to nLength

			cProduct	:= getPrdDepara(oXml:_ASN_CONF:_BODY:_FILEITEM[nItem]:_ITEM:TEXT)
			cLot	 	:= oXml:_ASN_CONF:_BODY:_FILEITEM[nItem]:_LOT:TEXT
			cExpDate	:= oXml:_ASN_CONF:_BODY:_FILEITEM[nItem]:_EXPIRATION_DATE:TEXT
			
			nPos := aScan(aItems,{|x| upper(alltrim(x[1] + x[3])) == upper(alltrim(cProduct + cLot + cExpDate))})
			
			if nPos == 0
				aAdd(aItems,{cProduct,;
				Val(oXml:_ASN_CONF:_BODY:_FILEITEM[nItem]:_RECEIVED_QUANTITY:TEXT),;
				cLot, cExpDate})
			else
				aItems[nPos][QUANTITY] += Val(oXml:_ASN_CONF:_BODY:_FILEITEM[nItem]:_RECEIVED_QUANTITY:TEXT)
			endif
		next
	else
		aAdd(aItems,{getPrdDepara(oXml:_ASN_CONF:_BODY:_FILEITEM:_ITEM:TEXT),;
		Val(oXml:_ASN_CONF:_BODY:_FILEITEM:_RECEIVED_QUANTITY:TEXT),;
		oXml:_ASN_CONF:_BODY:_FILEITEM:_LOT:TEXT, oXml:_ASN_CONF:_BODY:_FILEITEM:_EXPIRATION_DATE:TEXT})
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
* Coleta o Receive Order External Identifier da ASN Confirmation
**/
static function getROExternalIdent()

	local cReturn := Substr(AllTrim(oXml:_ASN_CONF:_BODY:_FILEHEADER:_RECEIVE_ORDER_EXTERNAL_IDENTIFIER:TEXT),1,40)

return cReturn


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

	local cClieFor := ""

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

	local cLoja := ""

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

	local cInterface := "ASN Confirmation"

	oLog:start(APP_DLX,DHL_IMPORTACAO,cFile)

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
* Conta quantidade de itens do documento.
**/
static function getCountQry()

	local cQuery  	:= ""	
	local nRet		:= 0
	local oSqlUtil 	:= IpSqlObject():newIpSqlObject()

	cQuery += "SELECT COUNT(D1_COD) QTD_ITEM FROM ( "                     		+CRLF
	cQuery += "	SELECT D1_COD, D1_LOTECTL, D1_DTVALID "             			+CRLF
	cQuery += "	FROM %SF1.SQLNAME%"                                          	+CRLF
	cQuery += "	INNER JOIN %SD1.SQLNAME%"                                    	+CRLF
	cQuery += "	ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND"            	+CRLF
	cQuery += "   	D1_SERIE = F1_SERIE AND F1_FORNECE = D1_FORNECE AND"      	+CRLF
	cQuery += "   	D1_LOJA = F1_LOJA AND"                                    	+CRLF
	cQuery += "   	%SD1.NOTDEL%"                                             	+CRLF
	cQuery += "	INNER JOIN %SB1.SQLNAME%"                                    	+CRLF
	cQuery += "	ON B1_FILIAL = '%SB1.FILIAL%' AND"                           	+CRLF
	cQuery += "   	B1_COD = D1_COD AND %SB1.NOTDEL%"                         	+CRLF
	cQuery += "	WHERE F1_FILIAL  = '%SF1.FILIAL%' AND"                       	+CRLF
	cQuery += "      F1_DOC     = '"+cNota+"'    AND"                       	+CRLF
	cQuery += "      F1_SERIE   = '"+cSerie+"'   AND"                       	+CRLF
	cQuery += "      F1_FORNECE = '"+cClieFor+"' AND"                       	+CRLF
	cQuery += "      F1_LOJA    = '"+cLoja+"'    AND"                       	+CRLF
	cQuery += "      %SF1.NOTDEL%"                                          	+CRLF
	cQuery += "GROUP BY D1_COD, D1_LOTECTL, D1_DTVALID) "                  		+CRLF
	oSqlUtil:newAlias(cQuery)

	if oSqlUtil:hasRecords()
		nRet := oSqlUtil:getValue("QTD_ITEM")
	endif

	oSqlUtil:close()

return nRet

/**
* Obtém o código do produto do depara (SA7)
**/
static function getPrdDepara(cProduto, cCnpjCli)

	local oDhlPrdDepara := DhlPrdDepara():newDhlPrdDepara()
	default cCnpjCli	:= ""

	cProduto := oDhlPrdDepara:getPrdProtheus(cProduto, cCnpjCli)

return allTrim(cProduto)

/**
* ordena os array por item
**/
static function ordenaDetailsByItem(aDetails)

	aSort(aDetails, , , {|x, y| x[1][2] < y[1][2]})

return

/**
* verifica se a nota de 2º perna (Cobertura) contém em seu XML (D1_ZZCBENE) a mesma informação criada na CDV para a nota de Fornecedor (1º perna)
**/
static function checkCBnefXMLIsCDV(cNota, cSerie, cClieFor, cLoja)

	local aArea 				:= getArea()
	local aAreaSD1 				:= SD1->(getArea())
	local cAliasCDV				:= getNextAlias()
	local cItem1Per				:= ""
	local cProd1Per 			:= ""
	local cCodBenefCDV 			:= ""
	local cCodAjuD1Cob  		:= ""
	local cEspeci				:= padr("SPED", tamSx3("CDV_ESPECI")[1], "")
	local cChaveCDV 			:= fwxFilial("CDV") + "E" + cEspeci + " " +  cNota + cSerie + cClieFor + cLoja
	local lError				:= .F.
	local cMsgErro				:= ""
	local lProcesWithError		:= superGetMV("ZZ_JBPRCBE",,.T.)
	local lJob					:= IIF(getRemoteType() == -1, .T., .F.)

	CDV->(dbSetOrder(4))

	if CDV->(dbSeek(cChaveCDV))		
		while CDV->(!eof()) .and. CDV->(CDV_FILIAL + CDV_TPMOVI + CDV_ESPECI + CDV_FORMUL + CDV_DOC + CDV_SERIE + CDV_CLIFOR + CDV_LOJA) == cChaveCDV
			cItem 			:= CDV->CDV_NUMITE
			cCodBenefCDV 	:= CDV->CDV_CODAJU
			cCFOP           := CDV->CDV_CFOP
			cProduto        := getProd(cNota, cSerie, cClieFor, cLoja, cItem, cCFOP)
			if !isCodAjuCDVLikeD1Cob(cNota, cSerie, cClieFor, cLoja, cProduto, cCodBenefCDV, @cCodAjuD1Cob)

				cMsgErro += "No produto "+allTrim(cProduto)+", o sistema esta parametrizado com o código de beneficiamento "+allTrim(cCodBenefCDV)+", porém, na NF do FORNECEDOR consta o código de beneficiamento "+allTrim(cCodAjuD1Cob) + CRLF + CRLF

			endIf
			CDV->(dbSkip())
		endDo

		if !empty(cMsgErro)
			if lJob
				if lProcesWithError
					setFileLog(cFile,"fail","CBENEF - parâmetro ZZ_JBPRCBE habilitado. Log gerado, porém será dado continuidade na classificação normalmente."+CRLF+CRLF+cMsgErro)
				else
					disarmTransaction()
					setFileLog(cFile,"fail","CBENEF - parâmetro ZZ_JBPRCBE desabilitado. Log gerado, não será dado continuidade na classificação da nota."+CRLF+CRLF+cMsgErro)
					lError := .T.
				endIf
			endIf
		endif
	else
		if lJob
			if lProcesWithError
				setFileLog(cFile,"fail","CBENEF - parâmetro ZZ_JBPRCBE habilitado. Log gerado, porém será dado continuidade na classificação normalmente."+CRLF+CRLF+;
				"Foi identificado que existe CBENEF na (NF COBERTURA) porém não foi encontrado a devida parametrização para a (NF FORNECEDOR). Verifique a amarração do produto x código CBENEF/NF do fornecedor.")
			else
				setFileLog(cFile,"fail","CBENEF - parâmetro ZZ_JBPRCBE desabilitado. Log gerado, não será dado continuidade na classificação da nota."+CRLF+CRLF+;
				"Foi identificado que existe CBENEF na (NF COBERTURA) porém não foi encontrado a devida parametrização para a (NF FORNECEDOR). Verifique a amarração do produto x código CBENEF/NF do fornecedor.")
				lError := .T.
			endIf
		endIf
	endIf	

	restArea(aAreaSD1)
	restArea(aArea)

return lError

/**
* verifica se na nota de Cobertura (2ºperna) contém o código CBENEF (D1_ZZCBENE)
**/
static function isExistCBEFInCobertura(cDoc2Per, cSerie2Per, cFornece2Per, cLoja2Per,cCodAjuD1Cob)

	local lExistCBENEFCobert := .F.	
	local cAliasSD1 	:= getNextAlias()	
	local aArea 		:= getArea()  
	local aAreaSD1  	:= SD1->(getArea())

	BeginSql Alias cAliasSD1
		SELECT COUNT(*) QTD_REGISTRO
		FROM %Table:SD1% SD1
		WHERE
		SD1.D1_FILIAL	= %xFilial:SD1% AND
		SD1.D1_DOC 	= %Exp:cDoc2Per% AND
		SD1.D1_SERIE 	= %Exp:cSerie2Per% AND		
		SD1.D1_FORNECE 	= %Exp:cFornece2Per% AND	
		SD1.D1_LOJA 	= %Exp:cLoja2Per% AND			
		SD1.D1_ZZCBENE    != ' ' AND		
		SD1.%NotDel%
	EndSql	

	If (cAliasSD1)->(!Eof())		
		nQtdRegistros :=  (cAliasSD1)->QTD_REGISTRO		
		if 	nQtdRegistros > 0
			lExistCBENEFCobert := .T.
		endIf
	EndIf 	

	(cAliasSD1)->(dbCloseArea())	

	restArea(aAreaSD1)
	restArea(aArea)

return lExistCBENEFCobert

/**
* Obtém o produto
**/
static function getProd(cNota, cSerie, cClieFor, cLoja, cItem, cCFOP)	

	local cAliasSD1 := getNextAlias()	
	local aArea 	:= getArea()  
	local aAreaSD1  := SD1->(getArea())
	local cProduto  := ""

	BeginSql Alias cAliasSD1
		SELECT SD1.D1_COD 
		FROM %Table:SD1% SD1
		WHERE
		SD1.D1_FILIAL	= %xFilial:SD1% AND
		SD1.D1_DOC 	= %Exp:cNota% AND
		SD1.D1_SERIE 	= %Exp:cSerie% AND		
		SD1.D1_FORNECE 	= %Exp:cClieFor% AND	
		SD1.D1_LOJA 	= %Exp:cLoja% AND
		SD1.D1_CF      = %Exp:cCFOP% AND		
		SD1.D1_ITEM    = %Exp:cItem% AND		
		SD1.%NotDel%
	EndSql	

	If (cAliasSD1)->(!Eof())		
		cProduto:=  (cAliasSD1)->D1_COD 		
	EndIf 	

	(cAliasSD1)->(dbCloseArea())	

	restArea(aAreaSD1)
	restArea(aArea)

return cProduto

/**
* Verifica se o código de ajuste da CDV é igual ao código da D1_ZZBENEF da Cobertura
**/
static function isCodAjuCDVLikeD1Cob(cDoc, cSerie, cFornece, cLoja, cProduto, cCodBenefCDV,cCodAjuD1Cob)

	local lIsLikeD1 	:= .F.
	local cAliasSD1 	:= getNextAlias()	
	local aArea 		:= getArea()  
	local aAreaSD1  	:= SD1->(getArea())

	BeginSql Alias cAliasSD1
		SELECT * 
		FROM %Table:SD1% SD1
		WHERE
		SD1.D1_FILIAL	= %xFilial:SD1% AND
		SD1.D1_DOC 	= %Exp:cDoc% AND
		SD1.D1_SERIE 	= %Exp:cSerie% AND		
		SD1.D1_FORNECE 	= %Exp:cFornece% AND	
		SD1.D1_LOJA 	= %Exp:cLoja% AND			
		SD1.D1_COD    = %Exp:cProduto% AND		
		SD1.%NotDel%
	EndSql	

	If (cAliasSD1)->(!Eof())		
		cCodAjuD1Cob:=  (cAliasSD1)->D1_ZZCBENE			
	EndIf 	

	(cAliasSD1)->(dbCloseArea())

	if allTrim(cCodAjuD1Cob) == allTrim(cCodBenefCDV)
		lIsLikeD1 := .T.
	endIf

	restArea(aAreaSD1)
	restArea(aArea)

return lIsLikeD1

/**
* Obtém informações de cabeçalho do documento de entrada
**/
static function setDocInfo()

	local cQuery      := ""
	
	cQuery  := getQuery("")
	oSql:newAlias(cQuery)

	if oSql:isEof()
		cClieFor  := getClieFor(.t.)
		cLoja     := getLoja(.t.)

		cQuery  := getQuery("")
		oSql:newAlias(cQuery)

		if !oSql:isEof() 
			cTipo := oSql:getValue("F1_TIPO")
		endif
	else
		cTipo := oSql:getValue("F1_TIPO")
	endif

	oSql:close()

return

/**
* Verifica se o depositante é do tipo Reparador
**/
static function isRepair(cClieFor,cLoja,cTipo)
	local oSqlUtil		:= IpSqlObject():newIpSqlObject()
	local lRet	 		:= .f.
	
	if AllTrim(cTipo) $ "D/B"
		oSqlUtil:newTable("SA1", "A1_COD, A1_LOJA, A1_ZZREPAR", "A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '" + cClieFor + "' AND A1_LOJA = '" + cLoja + "' ")
		if oSqlUtil:hasRecords()
			if oSqlUtil:getValue("A1_ZZREPAR") == "S"
				lRet := .t.
			endIf
		endIf
	else
		oSqlUtil:newTable("SA2", "A2_COD, A2_LOJA, A2_ZZREPAR", "A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = '" + cClieFor + "' AND A2_LOJA = '" + cLoja + "' ")
		if oSqlUtil:hasRecords()
			if oSqlUtil:getValue("A2_ZZREPAR") == "S"
				lRet := .t.
			endIf
		endIf
	endIf
	oSqlUtil:close()

return lRet
