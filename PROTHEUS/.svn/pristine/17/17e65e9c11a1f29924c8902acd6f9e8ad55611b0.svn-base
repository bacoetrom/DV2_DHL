#include "totvs.ch"
#include "dhl.ch"

#define ASN_APROVADA  "A"
#define ASN_REPROVADA "R"

#define PRODUCT       1
#define QUANTITY      2
#define LOT			  3
#define ALTER_INVOICE 4

#define NF_DEVOLUCAO	'D'

/*/{Protheus.doc} ASNConfirmation

Rotina responsável por ler e processar a interface ASN Confirmation e atualizar os dados referentes ao documento.
Processamento para a Unidade de Negócio DIS.

@author Thiago Meschiatti
@since 17/05/2016
/*/
user function DisASNConf(cFilePath)

	local lValid             := .T.
	local lTransito          := .F.
	private cNota            := getNota()
	private cSerie           := getSerie()
	private cCnpj            := getCnpj()
	private cClieFor         := getClieFor()
	private lRepresentant	 := IsRepresentant()
	private cLoja            := getLoja()
	private cStatus          := getStatus()
	private aItems           := getItems()
	private cReceiveOrder    := getReceiveOrder()
	private cROExternalIdent := getROExternalIdent()
	private cType			 := ""   
	private cChvDev			 := "" 

	private lMsErroAuto      := .F.
	private aHeader          := {}
	private aDetail          := {}
	private cFile            := cFilePath

	if cStatus == ASN_APROVADA

		lValid := validItem()

		if lValid

			updZZStatus(DHL_DOC_LIMPAR_STATUS)

			if isClassify()
				classifyInvoice()
			endif

			updReceiveOrder()

			if cType == NF_DEVOLUCAO
				lTransito := ValidTran() //Verifica se a nota ainda esta em transito - Emerson Holanda - 14/07/18
				If lTransito
					moveLocTran()
				EndIf
			endif
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
* Verifica se o cliente é um representante
**/
Static Function IsRepresentant()

	Local cCliRepresent	:= AllTrim(oSql:getFieldValue("SA2","A2_ZZCODRE","A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = 	'" + cCnpj + "'"))
	Local lStatus		:= .F.

	If Empty(cCliRepresent)
		lStatus := .F.
	Else
		lStatus := .T.
	EndIf

Return lStatus


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
		ElseIf IsDevolucaoRepresen()
			isClassify  := .F.
		endif

		oSql:skip()
	enddo

	oSql:close()

return isClassify

/**
* Verifica se é pertencente a um representante
**/
Static Function IsDevolucaoRepresen()

	Local lStatus	:= .F.

	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)

	if (SF1->(Found()))
		If SF1->F1_TIPO=="D" .and. lRepresentant
			lStatus := .T.
		EndIf
	endif

Return lStatus


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

	//Aviso(FunDesc(),oSql:getLastError(),{"OK"},3)
	//Aviso(FunDesc(),oSql:getLastQuery(),{"OK"},3)

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
	aAdd(aDetail,{"D1_EMISSAO",SD1->D1_EMISSAO,nil})
	aAdd(aDetail,{"D1_TES"    ,getTes()       ,nil})
	aAdd(aDetail,{"D1_DFABRIC",SD1->D1_ZZDFABR,nil})
	aAdd(aDetail,{"D1_DTVALID",SD1->D1_DTVALID,nil})

	for nCount := 1 to len(aCposSX3)
	
		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U"
			aAdd(aDetail,{AllTrim(aCposSX3[nCount]),&("SD1->" + AllTrim(aCposSX3[nCount])),nil})
		endIf
	
	next nCount

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

	//Aviso(FunDesc(),oSql:getLastError(),{"OK"},3)
	//Aviso(FunDesc(),oSql:getLastQuery(),{"OK"},3)

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
		lValid := .F.
		setFileLog(cFile,"warn","Não existe registro para a Nota " + cNota + " Série " + cSerie + " Fornecedor " + cClieFor + " Loja " + cLoja)
	endif

	oSql:close()

	if lValid
		//Thiago Meschiatti - FSW TOTVS IP Campinas - 08/02/2016
		if len(aItems) != getCountQry()
			lValid := .F.
			setFileLog(cFile,"warn","Quantidade de Itens entre ASN e a Nota " + cNota + " Série " + cSerie + " Fornecedor " + cClieFor + " Loja " + cLoja + " estão divergentes.")
		else
			if Len(aItems) > 0
				for nItem := 1 to Len(aItems)

					cQuery  := getQuery(aItems[nItem][PRODUCT], aItems[nItem][LOT])

					oSql:newAlias(ChangeQuery(cQuery))

					if oSql:isEof()
						lValid := .F.
						setFileLog(cFile,"warn","Não existe registro para a Nota " + cNota + " Série " + cSerie + " Fornecedor " + cClieFor + " Loja " + cLoja + " Produto " + aItems[nItem][PRODUCT] + " ",;
						+ if(!empty(aItems[nItem][LOT]), "e Lote " + aItems[nItem][LOT], "")+" no Protheus.")
						exit
					endif

					cQueryAlias := oSql:getAlias()

					//cType := (cQueryAlias)->TYPE // inibido Emerson Holanda 17/07/20
					//cChvDev := (cQueryAlias)->CHV_DEV // inibido Emerson Holanda 17/07/20
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
				
				//Emerson Holanda 17/07/2020 - Tratamento chave nota devolucao para transferencia do transito.
				nItem := iif(nItem==1,nItem,nItem-1)
				cQuery  := TrGetQuery(aItems[nItem][PRODUCT], aItems[nItem][LOT])

				oSql:newAlias(ChangeQuery(cQuery))

				if oSql:isEof()
					lValid := .F.
					setFileLog(cFile,"warn","Não existe registro para a Nota " + cNota + " Série " + cSerie + " Fornecedor " + cClieFor + " Loja " + cLoja + " Produto " + aItems[nItem][PRODUCT] + " ",;
					+ if(!empty(aItems[nItem][LOT]), "e Lote " + aItems[nItem][LOT], "")+" no Protheus.")
				endif

				cQueryAlias := oSql:getAlias()

				cType := (cQueryAlias)->TYPE
				cChvDev := (cQueryAlias)->CHV_DEV
				
				oSql:close()
			endIf
		endif
	endif

return lValid


/**
* Monta a Query para validação dos Itens da Nota Fiscal
**/
static function getQuery(cProduct, cLot, cType, cChvNF)

	local cQuery   := ""
	local lProduct := if(Empty(cProduct),.F.,.T.)

	default cLot 	:= ""
	default cType	:= ""

	if cType == NF_DEVOLUCAO
		cQuery := "SELECT"                                                      +CRLF
		cQuery += "      SD1.R_E_C_N_O_ REC_SD1"                                 +CRLF
		cQuery += "FROM %SD1.SQLNAME%"                                          +CRLF
		cQuery += "INNER JOIN %SB1.SQLNAME%"                                    +CRLF
		cQuery += "ON B1_FILIAL = '%SB1.FILIAL%' AND"                           +CRLF
		cQuery += "   B1_COD = D1_COD AND %SB1.NOTDEL%"                         +CRLF
		cQuery += "WHERE D1_FILIAL  = '%SD1.FILIAL%' AND"                       +CRLF
		cQuery += "		 D1_DOC || D1_SERIE || D1_ITEM || D1_FORNECE || D1_LOJA = '"+cChvNF+"' AND" +CRLF
		cQuery += "      %SD1.NOTDEL%"                                          +CRLF
	else
		cQuery := "SELECT"                                                      +CRLF
		cQuery += "      D1_TIPO       TYPE,"                                   +CRLF
		cQuery += "      B1_COD        ITEM,"                                   +CRLF
		cQuery += "      SUM(D1_QUANT) QUANT, "                                 +CRLF
		cQuery += "      D1_LOTECTL LOT_NF "                                	+CRLF 
		// Incluida o campo de chave da nf de devolução  - Emerson Holanda 23/07/2018 
		//cQuery += "      ,D1_ZZCHVNF CHV_DEV "                                	+CRLF //inibido Emerson Holanda 17/07/20 retirado a chave da nota da query
		cQuery += "FROM %SF1.SQLNAME%"                                          +CRLF
		cQuery += "INNER JOIN %SD1.SQLNAME%"                                    +CRLF
		cQuery += "ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND"            +CRLF
		cQuery += "   D1_SERIE = F1_SERIE AND F1_FORNECE = D1_FORNECE AND"      +CRLF
		cQuery += "   D1_LOJA = F1_LOJA AND"                                    +CRLF
		if lProduct
			cQuery += "   D1_COD 		= '"+cProduct+"' AND "                  +CRLF
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
		//cQuery += "GROUP BY B1_COD,D1_LOTECTL,D1_TIPO,D1_ZZCHVNF "              +CRLF //inibido Emerson Holanda retirada o agrupamento da chave
		cQuery += "GROUP BY B1_COD,D1_LOTECTL,D1_TIPO "              +CRLF
	endif

return cQuery


/**
* Coleta os Itens da Nota Fiscal
**/
static function getItems()

	local nItem   := 1
	local nLength := 0
	local aItems  := {}
	local nPos    := 0
	local cProduct:= ""
	local cLot	  := ""

	if ValType(oXml:_ASN_CONF:_BODY:_FILEITEM) == "A"

		nLength := Len(oXml:_ASN_CONF:_BODY:_FILEITEM)

		for nItem := 1 to nLength

			cProduct	:= oXml:_ASN_CONF:_BODY:_FILEITEM[nItem]:_ITEM:TEXT
			cLot	 	:= oXml:_ASN_CONF:_BODY:_FILEITEM[nItem]:_LOT:TEXT

			nPos := aScan(aItems,{|x| upper(alltrim(x[1] + x[3])) == upper(alltrim(cProduct + cLot))})

			if nPos == 0
				aAdd(aItems,{cProduct,;
				Val(oXml:_ASN_CONF:_BODY:_FILEITEM[nItem]:_RECEIVED_QUANTITY:TEXT),;
				cLot})
			else
				aItems[nPos][QUANTITY] += Val(oXml:_ASN_CONF:_BODY:_FILEITEM[nItem]:_RECEIVED_QUANTITY:TEXT)
			endif
		next
	else
		aAdd(aItems,{oXml:_ASN_CONF:_BODY:_FILEITEM:_ITEM:TEXT,;
		Val(oXml:_ASN_CONF:_BODY:_FILEITEM:_RECEIVED_QUANTITY:TEXT),;
		oXml:_ASN_CONF:_BODY:_FILEITEM:_LOT:TEXT})
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
static function getClieFor()

	local cCliente 		:= ""
	local cFornecedor 	:= ""
	Local cClienteRepre	:= ""
	Local cCliFor		:= ""

	cFornecedor 	:= AllTrim(oSql:getFieldValue("SA2","A2_COD","A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = 		'" + cCnpj + "'"))
	cCliRepresent	:= AllTrim(oSql:getFieldValue("SA2","A2_ZZCODRE","A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = 	'" + cCnpj + "'"))

	If !Empty(cFornecedor)
		If !Empty(cCliRepresent)
			cCliFor:=cCliRepresent
		Else
			cCliFor:=cFornecedor
		EndIf
	Else
		cCliFor:= AllTrim(oSql:getFieldValue("SA1","A1_COD","A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = 		'" + cCnpj + "'"))
	EndIf

	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "ASN Confirmation - ClieFor: " + cCliFor, 0, 0, {})

return cCliFor


/**
* Coleta a Loja do Fornecedor da Nota Fiscal
**/
static function getLoja()

	local cCliente 		:= ""
	local cFornecedor 	:= ""
	Local cClienteRepre	:= ""
	Local cLoja			:= ""

	cLojaFornecedor 	:= AllTrim(oSql:getFieldValue("SA2","A2_LOJA","A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = 		'" + cCnpj + "'"))
	cLojaRepre			:= AllTrim(oSql:getFieldValue("SA2","A2_ZZLOJRE","A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = 	'" + cCnpj + "'"))

	If !Empty(cLojaFornecedor)
		If !Empty(cLojaRepre)
			cLoja:=cLojaRepre
		Else
			cLoja:=cLojaFornecedor
		EndIf
	Else
		cLoja:= AllTrim(oSql:getFieldValue("SA1","A1_LOJA","A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = 		'" + cCnpj + "'"))
	EndIf

	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "ASN Confirmation - Loja: " + cLoja, 0, 0, {})

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
	cQuery += "	SELECT D1_COD, D1_LOTECTL "                     				+CRLF
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
	cQuery += "GROUP BY D1_COD, D1_LOTECTL) "	                        		+CRLF

	oSqlUtil:newAlias(cQuery)

	if oSqlUtil:hasRecords()
		nRet := oSqlUtil:getValue("QTD_ITEM")
	endif

	oSqlUtil:close()

return nRet


/*
** Mover estoque em trânsito
*/
static function moveLocTran()
	local oSql		:= IpSqlObject():newIpSqlObject()
	local oSqlAux	:= IpSqlObject():newIpSqlObject()
	local cQuery 	:= ""

	oSql:newTable("SD1", "D1_ZZCHVNF", retQrySD1())

	dbSelectArea("SD1")
	SD1->(dbSetOrder(0))
	while oSql:notIsEof()
		oSqlAux:newAlias(getQuery(,,NF_DEVOLUCAO, oSql:getValue("D1_ZZCHVNF")))

		SD1->(dbgoto(oSqlAux:getValue("REC_SD1")))

		// Chamada da rotina padrão responsavel por retornar o material para o armazem original - Emerson Holanda 20/07/2018
		&("StaticCall(MATA103,A103TrfSld,.f.,2)")
		oSqlAux:close()
		oSql:skip()
	end

return


/*
** Where para tabela SD1
*/
static function retQrySD1()
	local cQuery := ""

	cQuery += "%SD1.XFILIAL% AND D1_DOC = '"+cNota+"' AND D1_SERIE = '"+cSerie+"' AND D1_FORNECE = '"+cClieFor+"'"
	cQuery += " AND D1_LOJA = '"+cLoja+"'"

return (cQuery)



/** Emerson Holanda  - 14/07/2018
* Valida os Itens da Nota Fiscal em transito
**/
static function ValidTran()

	local nItem       := 1
	local cQuery      := ""
	local lValid      := .T.
	local cQueryAlias := ""

	cQuery  := TraQuery("")

	oSql:newAlias(cQuery)

	if oSql:isEof()
		lValid := .F.
		setFileLog(cFile,"warn","Não existe registro em transito para a Nota " + cNota + " Série " + cSerie + " Fornecedor " + cClieFor + " Loja " + cLoja)
	endif

	oSql:close()

Return lValid

/** Emerson Holanda  - 14/07/2018
* Monta a Query para validação dos Itens da Nota Fiscal em transito.
**/
static function TraQuery(cProduct, cLot, cType, cChvNF)

	local cQuery   := ""
	local lProduct := if(Empty(cProduct),.F.,.T.)

	default cLot 	:= ""
	default cType	:= ""
	/*
	cQuery := "SELECT"                                                      +CRLF
	cQuery += "      SD1.R_E_C_N_O_ REC_SD1"                                 +CRLF
	cQuery += "FROM %SD1.SQLNAME%"                                          +CRLF
	cQuery += "INNER JOIN %SB1.SQLNAME%"                                    +CRLF
	cQuery += "ON B1_FILIAL = '%SB1.FILIAL%' AND"                           +CRLF
	cQuery += "   B1_COD = D1_COD AND %SB1.NOTDEL%"                         +CRLF
	cQuery += "WHERE D1_FILIAL  = '%SD1.FILIAL%' AND"                       +CRLF
	cQuery += "		 D1_DOC || D1_SERIE || D1_ITEM || D1_FORNECE || D1_LOJA = '"+cChvNF+"' AND" +CRLF
	cQuery += "      %SD1.NOTDEL% AND D1_TRANSIT = 'S' "                                          +CRLF
	*/
	cQuery := "SELECT"                                                      +CRLF
	cQuery += "      D1_TIPO       TYPE,"                                   +CRLF
	cQuery += "      B1_COD        ITEM,"                                   +CRLF
	cQuery += "      SUM(D1_QUANT) QUANT, "                                 +CRLF
	cQuery += "      D1_LOTECTL LOT_NF, "                                	+CRLF 
	cQuery += "      D1_ZZCHVNF CHV_NF_DEV "                               	+CRLF
	cQuery += "FROM %SF1.SQLNAME%"                                          +CRLF
	cQuery += "INNER JOIN %SD1.SQLNAME%"                                    +CRLF
	cQuery += "ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND"            +CRLF
	cQuery += "   D1_SERIE = F1_SERIE AND F1_FORNECE = D1_FORNECE AND"      +CRLF
	cQuery += "   D1_LOJA = F1_LOJA AND"                                    +CRLF
	if lProduct
		cQuery += "   D1_COD 		= '"+cProduct+"' AND "                  +CRLF
		cQuery += "   D1_LOTECTL 	= '"+cLot+"' AND "                  	+CRLF
	endif
	cQuery += "   %SD1.NOTDEL%"                                             +CRLF
	cQuery += "INNER JOIN %SB1.SQLNAME%"                                    +CRLF
	cQuery += "ON B1_FILIAL = '%SB1.FILIAL%' AND"                           +CRLF
	cQuery += "   B1_COD = D1_COD AND %SB1.NOTDEL%"                         +CRLF
	cQuery += "WHERE F1_FILIAL  = '%SF1.FILIAL%' AND"                       +CRLF
	/*
	cQuery += "      F1_DOC     = '"+cNota+"'    AND"                       +CRLF
	cQuery += "      F1_SERIE   = '"+cSerie+"'   AND"                       +CRLF
	cQuery += "      F1_FORNECE = '"+cClieFor+"' AND"                       +CRLF
	cQuery += "      F1_LOJA    = '"+cLoja+"'    AND"                       +CRLF
	*/
	cQuery += "      F1_DOC     = '"+Substr(cChvDev,1,9)+"'      AND"       +CRLF
	cQuery += "      F1_SERIE   = '"+Substr(cChvDev,10,3)+"'     AND"       +CRLF
	cQuery += "      F1_FORNECE = '"+Substr(cChvDev,17,6)+"'     AND"       +CRLF
	cQuery += "      F1_LOJA    = '"+Substr(cChvDev,23,2)+"'     AND"       +CRLF
	cQuery += "      %SF1.NOTDEL%"                                          +CRLF  
	cQuery += "      AND D1_TRANSIT = 'S' "                                 +CRLF
	cQuery += "GROUP BY B1_COD,D1_LOTECTL,D1_TIPO,D1_ZZCHVNF "              +CRLF

return cQuery

/** Emerson Holanda 17/07/2020
* Monta a Query para extrair a chave da nota de devolucao correspondente utilizar na transferencia do transito.
**/
static function TrGetQuery(cProduct, cLot, cType, cChvNF)

	local cQuery   := ""
	local lProduct := if(Empty(cProduct),.F.,.T.)

	default cLot 	:= ""
	default cType	:= ""

	if cType == NF_DEVOLUCAO
		cQuery := "SELECT"                                                      +CRLF
		cQuery += "      SD1.R_E_C_N_O_ REC_SD1"                                 +CRLF
		cQuery += "FROM %SD1.SQLNAME%"                                          +CRLF
		cQuery += "INNER JOIN %SB1.SQLNAME%"                                    +CRLF
		cQuery += "ON B1_FILIAL = '%SB1.FILIAL%' AND"                           +CRLF
		cQuery += "   B1_COD = D1_COD AND %SB1.NOTDEL%"                         +CRLF
		cQuery += "WHERE D1_FILIAL  = '%SD1.FILIAL%' AND"                       +CRLF
		cQuery += "		 D1_DOC || D1_SERIE || D1_ITEM || D1_FORNECE || D1_LOJA = '"+cChvNF+"' AND" +CRLF
		cQuery += "      %SD1.NOTDEL%"                                          +CRLF
	else
		cQuery := "SELECT"                                                      +CRLF
		cQuery += "      D1_TIPO       TYPE,"                                   +CRLF
		cQuery += "      B1_COD        ITEM,"                                   +CRLF
		cQuery += "      SUM(D1_QUANT) QUANT, "                                 +CRLF
		cQuery += "      D1_LOTECTL LOT_NF "                                	+CRLF 
		// Incluida o campo de chave da nf de devolução  - Emerson Holanda 23/07/2018 
		cQuery += "      ,D1_ZZCHVNF CHV_DEV "                                	+CRLF
		cQuery += "FROM %SF1.SQLNAME%"                                          +CRLF
		cQuery += "INNER JOIN %SD1.SQLNAME%"                                    +CRLF
		cQuery += "ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND"            +CRLF
		cQuery += "   D1_SERIE = F1_SERIE AND F1_FORNECE = D1_FORNECE AND"      +CRLF
		cQuery += "   D1_LOJA = F1_LOJA AND"                                    +CRLF
		if lProduct
			cQuery += "   D1_COD 		= '"+cProduct+"' AND "                  +CRLF
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
		cQuery += "GROUP BY B1_COD,D1_LOTECTL,D1_TIPO,D1_ZZCHVNF "              +CRLF
	endif

return cQuery
