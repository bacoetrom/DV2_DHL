#include "totvs.ch"
#include "dhl.ch"
#include "topconn.ch"


/*/{Protheus.doc} DHLIdManager

Objeto para Manipulação dos IDs de Produtos

@author Victor Hugo
@since 30/10/2014
/*/
class DHLIdManager
	
	data cMsg
	
	method newDHLIdManager() constructor
	
	method getMsg()
	
	method createId()
	method inflowInvoice()
	method outflowInvoice()
	method validExclusion()
	method updateOutDoc()
	method retStatusId()
	method getRefNfId()
	
endClass


/*/{Protheus.doc} newDHLIdManager

Construtor

@author Victor Hugo
@since 05/11/2014
/*/
method newDHLIdManager() class DHLIdManager
	
	::cMsg := ""
	
return self


/*/{Protheus.doc} getMsg

Coleta as Mensagens do Objeto

@author Victor Hugo
@since 05/11/2014

@return String Mensagens do Objeto
/*/
method getMsg() class DHLIdManager
return ::cMsg


/*/{Protheus.doc} createId

Criação de novos IDs

@author Victor Hugo
@since 05/11/2014

@param oId, DHLProductId, ID de Produtos

@return Logico Indica se o ID foi criado
/*/
method createId(oId) class DHLIdManager
	
	local aData := {}
	local oSql  := IpSqlObject():newIpSqlObject()
	
	setIdValues(@oId)
	
	aAdd(aData, {"Z3_FILIAL", oId:getBranch()})
	aAdd(aData, {"Z3_ID", oId:getId()})
	aAdd(aData, {"Z3_PRODUTO", oId:getProduct()})
	aAdd(aData, {"Z3_DESC", oId:getDescription()})
	aAdd(aData, {"Z3_VUNIT", oId:getUnitValue()})
	aAdd(aData, {"Z3_DTMOV", oId:getDate()})
	aAdd(aData, {"Z3_HRMOV", oId:getTime()})
	aAdd(aData, {"Z3_TPMOV", oId:getType()})
	aAdd(aData, {"Z3_DOC", oId:getDocument()})
	aAdd(aData, {"Z3_SERIE", oId:getSeries()})
	aAdd(aData, {"Z3_CLIFOR", oId:getEntity()})
	aAdd(aData, {"Z3_LOJA", oId:getUnit()})
	aAdd(aData, {"Z3_ITEM", oId:getItem()})
	aAdd(aData, {"Z3_STATUS", oId:getStatus()})
	aAdd(aData, {"Z3_IDENTB6", oId:getIdentB6()})
	aAdd(aData, {"Z3_SEQUEN", oId:getSequence()})
	aAdd(aData, {"Z3_VALICM", oId:getIcmsValue()})
	aAdd(aData, {"Z3_VALIPI", oId:getIpiValue()})
	aAdd(aData, {"Z3_VALIBUF", oId:getIBSUfValue()})
	aAdd(aData, {"Z3_VALIBMU", oId:getIBSMunValue()})
	aAdd(aData, {"Z3_VALCBS", oId:getCBSValue()})
	aAdd(aData, {"Z3_SITUACA", oId:getSituation()})
	aAdd(aData, {"Z3_TIPODOC", oId:getTypeDoc()})
	
return oSql:insert("SZ3", aData)

/**
* Trata os Campos ID e Sequencia
*/
static function setIdValues(oId)
	
	local cMaxId	:= ""
	local cMaxSeq	:= ""
	local cBranch 	:= oId:getBranch()
	local cId 	  	:= oId:getId()
	local cSequence	:= oId:getSequence()
	local cUpd		:= ""
	local oSql 		:= IpSqlObject():newIpSqlObject()
	
	if Empty(cId)
		oSql:newTable("SZ3", "MAX(Z3_ID) MAXID", "Z3_FILIAL = '"+cBranch+"'")
		cMaxId   := oSql:getValue("MAXID")
		cId	   	 := if (Empty(cMaxId), StrZero(1, Len(SZ3->Z3_ID)), Soma1(cMaxId))
		cSequence:= StrZero(1, Len(SZ3->Z3_SEQUEN))
		execUpd(oId, cId)
	else
		oSql:newTable("SZ3", "MAX(Z3_SEQUEN) MAXSEQ", "Z3_FILIAL = '"+cBranch+"' AND Z3_ID = '"+cId+"'")
		cMaxSeq   := oSql:getValue("MAXSEQ")
		cSequence := Soma1(cMaxSeq)
	endIf
	
	oId:setId(cId)
	oId:setSequence(cSequence)
	
	oSql:close()
	
return


/*/{Protheus.doc} inflowInvoice

Trata eventos dos Documentos de Entrada. Se não informados os parâmetros considera o documento posicionado.

@author Victor Hugo
@since 05/11/2014

@param nEvent, Numerico, Evento a ser tratado (DHL_INCLUSAO ou DHL_EXCLUSAO)
@param cBranch, String, Código da Filial
@param cDocument, String, Número do Documento
@param cSeries, String, Série do Documento
@param cEntity, String, Código do Cliente/Fornecedor
@param cUnit, String, Loja do Cliente/Fornecedor
/*/
method inflowInvoice(nEvent, cBranch, cDocument, cSeries, cEntity, cUnit, cItem) class DHLIdManager
	
	local nI		  := 0
	local aIds 		  := {}
	default cBranch   := SF1->F1_FILIAL
	default cDocument := SF1->F1_DOC
	default cSeries   := SF1->F1_SERIE
	default cEntity   := SF1->F1_FORNECE
	default cUnit     := SF1->F1_LOJA
	default	cItem	  := ""
	
	aIds := loadInvoiceIds(DHL_NF_ENTRADA, nEvent, cBranch, cDocument, cSeries, cEntity, cUnit, self, cItem)
	
	for nI := 1 to Len(aIds)
		::createId(aIds[nI])
	next nI
	
return


/*/{Protheus.doc} outflowInvoice

Trata eventos das Notas Fiscais de Saida. Se não informados os parâmetros considera o documento posicionado.

@author Victor Hugo
@since 05/11/2014

@param nEvent, Numerico, Evento a ser tratado (DHL_INCLUSAO ou DHL_EXCLUSAO)
@param cBranch, String, Código da Filial
@param cDocument, String, Número do Documento
@param cSeries, String, Série do Documento
/*/
method outflowInvoice(nEvent, cBranch, cDocument, cSeries) class DHLIdManager
	
	local nI		  := 0
	local aIds 		  := {}
	default cBranch   := SF2->F2_FILIAL
	default cDocument := SF2->F2_DOC
	default cSeries   := SF2->F2_SERIE
	
	aIds := loadInvoiceIds(DHL_NF_SAIDA, nEvent, cBranch, cDocument, cSeries,,,Self)
	
	for nI := 1 to Len(aIds)
		::createId(aIds[nI])
	next nI
	
return

/**
* Coleta os IDs de uma Nota Fiscal
*/
static function loadInvoiceIds(nDocType, nEvent, cBranch, cDocument, cSeries, cEntity, cUnit, oself, cItem)
	
	local oId	 	 := nil
	local aIds   	 := {}
	local cType		 := if (nDocType == DHL_NF_ENTRADA, "E", "S")
	local cSituation := if (nEvent == DHL_EXCLUSAO, DHL_ID_SITUACAO_EXCLUIDO, DHL_ID_SITUACAO_NORMAL)
	local cStatus	 := ""
	local oSql   	 := getSqlInvoice(nDocType, cBranch, cDocument, cSeries, cEntity, cUnit, cItem)
	
	while oSql:notIsEof()
		
		oId := DHLProductId():newDHLProductId()
		oId:setBranch(oSql:getValue("BRANCH"))
		oId:setId(oSql:getValue("ID"))
		oId:setProduct(oSql:getValue("PRODUCT"))
		oId:setUnitValue(oSql:getValue("UNITVALUE"))
		oId:setDate(oSql:getValue("DATEDIG"))
		oId:setTime(Time())
		oId:setType(cType)
		oId:setDocument(oSql:getValue("DOCUMENT"))
		oId:setSeries(oSql:getValue("SERIES"))
		oId:setEntity(oSql:getValue("ENTITY"))
		oId:setUnit(oSql:getValue("UNIT"))
		oId:setItem(oSql:getValue("ITEM"))
		if nEvent == DHL_EXCLUSAO .and. empty(oSql:getValue("STATUS"))
			if empty(oSql:getValue("ID"))
				loop	
			else
				cStatus := oself:retStatusId(oSql:getValue("BRANCH"), oSql:getValue("ID"))
				oId:setStatus(cStatus)
			endif
		else 
			oId:setStatus(oSql:getValue("STATUS"))
		endif
		oId:setIdentB6(oSql:getValue("IDENTB6"))
		oId:setSituation(cSituation)
		oId:setTypeDoc(oSql:getValue("TYPEDOC"))
		
		if (nEvent == DHL_INCLUSAO)
			getTaxes(@oId, oSql:getValue("TYPEDOC"))
			oId:setIBSUfValue(oSql:getValue("IBSUF_VALOR"))
			oId:setIBSMunValue(oSql:getValue("IBSMUN_VALOR"))
			oId:setCBSValue(oSql:getValue("CBS_VALOR"))
		endif
		
		aAdd(aIds, oId)
		
		oSql:skip()
	endDo
	
	oSql:close()
	
return aIds

/**
* Monta objeto SQL de IDs de uma Nota Fiscal
*/
static function getSqlInvoice(nDocType, cBranch, cDocument, cSeries, cEntity, cUnit, cItem)
	
	local cQuery := ""
	local cTribIBSUF := SuperGetMv("ZZ_TRIBSUF", .F., "TR0002")
	local cTribIBSMun := SuperGetMv("ZZ_TRIBSMU", .F., "TR0003")
	local cTribCBS := SuperGetMv("ZZ_TRIBCBS", .F., "TR0001")
	local oSql   := IpSqlObject():newIpSqlObject()
	
	if (nDocType == DHL_NF_ENTRADA)
		cQuery := " SELECT D1_FILIAL BRANCH, D1_ZZID ID, D1_COD PRODUCT, D1_VUNIT UNITVALUE, "
		cQuery += " 	   D1_DTDIGIT DATEDIG, D1_DOC DOCUMENT, D1_SERIE SERIES, D1_FORNECE ENTITY, "
		cQuery += " 	   D1_LOJA UNIT, D1_ITEM ITEM, F4_ZZSTATU STATUS, D1_IDENTB6 IDENTB6, "
		cQuery += " 	   D1_VALICM ICMSVALUE, D1_VALIPI IPIVALUE, D1_TIPO TYPEDOC, "
		cQuery += "		   NVL(IBSUF.F2D_VALOR, 0) IBSUF_VALOR, "
		cQuery += "		   NVL(IBSMUN.F2D_VALOR, 0) IBSMUN_VALOR, "
		cQuery += "		   NVL(CBS.F2D_VALOR, 0) CBS_VALOR "
		cQuery += " FROM %SD1.SQLNAME% "
		cQuery += " 	LEFT JOIN %SF4.SQLNAME% ON "
		cQuery += " 		F4_FILIAL = '%SF4.FILIAL%' AND F4_CODIGO = D1_TES AND F4_ZZSTATU != ' ' AND %SF4.NOTDEL% "
		cQuery += " OUTER APPLY ( "
		cQuery += " 	SELECT F2D_VALOR FROM %F2D.SQLNAME% "
		cQuery += " 	WHERE F2D_FILIAL = '"+cBranch+"'  "
		cQuery += " 		AND F2D_IDREL = D1_IDTRIB "
		cQuery += " 		AND F2D_TABELA = 'SD1' "
		cQuery += " 		AND F2D_TRIB = '" + cTribIBSUF + "' "
		cQuery += " 		AND %F2D.NOTDEL% "
		cQuery += " ) IBSUF "
		cQuery += " OUTER APPLY ( "
		cQuery += " 	SELECT F2D_VALOR FROM %F2D.SQLNAME% "
		cQuery += " 	WHERE F2D_FILIAL = '"+cBranch+"'  "
		cQuery += " 		AND F2D_IDREL = D1_IDTRIB "
		cQuery += " 		AND F2D_TABELA = 'SD1' "
		cQuery += " 		AND F2D_TRIB = '" + cTribIBSMun + "' "
		cQuery += " 		AND %F2D.NOTDEL%  "
		cQuery += " ) IBSMUN "
		cQuery += " OUTER APPLY ( "
		cQuery += " 	SELECT F2D_VALOR FROM %F2D.SQLNAME% "
		cQuery += " 	WHERE F2D_FILIAL = '"+cBranch+"'  "
		cQuery += " 		AND F2D_IDREL = D1_IDTRIB "
		cQuery += " 		AND F2D_TABELA = 'SD1' "
		cQuery += " 		AND F2D_TRIB = '" + cTribCBS + "' "
		cQuery += " 		AND %F2D.NOTDEL% "
		cQuery += " ) CBS "
		cQuery += " WHERE D1_FILIAL = '"+cBranch+"' AND D1_DOC = '"+cDocument+"' AND D1_SERIE = '"+cSeries+"' AND "
		cQuery += " 	  D1_FORNECE = '"+cEntity+"' AND D1_LOJA = '"+cUnit+"' AND %SD1.NOTDEL% "
		if !empty(cItem)
			cQuery += " 	  AND D1_ITEM = '"+cItem+"' "
		endif
		cQuery += " ORDER BY D1_ITEM "
	elseIf (nDocType == DHL_NF_SAIDA)
		cQuery := " SELECT D2_FILIAL BRANCH, D2_ZZID ID, D2_COD PRODUCT, D2_PRCVEN UNITVALUE, "
		cQuery += " 	   D2_EMISSAO DATEDIG, D2_DOC DOCUMENT, D2_SERIE SERIES, D2_CLIENTE ENTITY, "
		cQuery += " 	   D2_LOJA UNIT, D2_ITEM ITEM, F4_ZZSTATU STATUS, D2_IDENTB6 IDENTB6, "
		cQuery += " 	   D2_VALICM ICMSVALUE, D2_VALIPI IPIVALUE, D2_TIPO TYPEDOC, "
		cQuery += "		   NVL(IBSUF.F2D_VALOR, 0) IBSUF_VALOR, "
		cQuery += "		   NVL(IBSMUN.F2D_VALOR, 0) IBSMUN_VALOR, "
		cQuery += "		   NVL(CBS.F2D_VALOR, 0) CBS_VALOR "
		cQuery += " FROM %SD2.SQLNAME% "
		cQuery += " 	INNER JOIN %SF4.SQLNAME% ON "
		cQuery += " 		F4_FILIAL = '%SF4.FILIAL%' AND F4_CODIGO = D2_TES AND F4_ZZSTATU != ' ' AND %SF4.NOTDEL% "
		cQuery += " OUTER APPLY ( "
		cQuery += " 	SELECT F2D_VALOR FROM %F2D.SQLNAME% "
		cQuery += " 	WHERE F2D_FILIAL = '"+cBranch+"'  "
		cQuery += " 		AND F2D_IDREL = D2_IDTRIB "
		cQuery += " 		AND F2D_TABELA = 'SD2' "
		cQuery += " 		AND F2D_TRIB = '" + cTribIBSUF + "' "
		cQuery += " 		AND %F2D.NOTDEL% "
		cQuery += " ) IBSUF "
		cQuery += " OUTER APPLY ( "
		cQuery += " 	SELECT F2D_VALOR FROM %F2D.SQLNAME% "
		cQuery += " 	WHERE F2D_FILIAL = '"+cBranch+"'  "
		cQuery += " 		AND F2D_IDREL = D2_IDTRIB "
		cQuery += " 		AND F2D_TABELA = 'SD2' "
		cQuery += " 		AND F2D_TRIB = '" + cTribIBSMun + "' "
		cQuery += " 		AND %F2D.NOTDEL%  "
		cQuery += " ) IBSMUN "
		cQuery += " OUTER APPLY ( "
		cQuery += " 	SELECT F2D_VALOR FROM %F2D.SQLNAME% "
		cQuery += " 	WHERE F2D_FILIAL = '"+cBranch+"'  "
		cQuery += " 		AND F2D_IDREL = D2_IDTRIB "
		cQuery += " 		AND F2D_TABELA = 'SD2' "
		cQuery += " 		AND F2D_TRIB = '" + cTribCBS + "' "
		cQuery += " 		AND %F2D.NOTDEL% "
		cQuery += " ) CBS "
		cQuery += " WHERE D2_FILIAL = '"+cBranch+"' AND D2_DOC = '"+cDocument+"' AND D2_SERIE = '"+cSeries+"' AND %SD2.NOTDEL% "
		cQuery += " ORDER BY D2_ITEM "
	endIf
	
	oSql:newAlias(cQuery)
	
	oSql:setField("DATEDIG", "D")
	
return oSql

/*
** Monta expressão de update para preencher campo ID
*/
static function execUpd(oID, cId)
	local cType		:= oId:getType()
	local cUpd		:= ""
	local oSqlUpd	:= IpSqlObject():newIpSqlObject()
	
	if cType == 'E'
		cUpd	:= " D1_FILIAL = '"+oId:getBranch()+"' AND D1_DOC = '"+oId:getDocument()+"' AND D1_SERIE = '"+oId:getSeries()+"' AND D1_ITEM = '"+oId:getItem()+"'" +CRLF
		cUpd	+= " AND D1_FORNECE = '"+oId:getEntity()+"' AND D1_LOJA = '"+oId:getUnit()+"' "
		
		oSqlUpd:update("SD1", "D1_ZZID = '"+cId+"' ", cUpd)
		//	else
		//		cUpd	:= " D2_FILIAL = '"+oId:getBranch()+"' AND D2_DOC = '"+oId:getDocument()+"' AND D2_SERIE = '"+oId:getSeries()+"' AND D2_ITEM = '"+oId:getItem()+"'"
		//
		//		oSqlUpd:update("SD2", "D2_ZZID = '' ", cUpd)
	endif
	
return()

/*/{Protheus.doc} nomeDaFuncaoClasseOuMetodo

(Descrição da Função, Classe ou Método)

@author Thiago Meschiatti
@since 07/11/2014

@param xParam, TipoParam, DescricaoDoParam

@return TipoRet DescricaoRet
/*/
method validExclusion(nDocType) class DHLIdManager
	
	local oSql   	:= nil
	local oSqlAlias	:= IpSqlObject():newIpSqlObject()
	local oSqlValid	:= IpSqlObject():newIpSqlObject()
	local cDepos	:= Alltrim(GetNewPar("ZZ_FORNDEP", ""))
	local cBranch   := if(nDocType == DHL_NF_ENTRADA, SF1->F1_FILIAL	, SF2->F2_FILIAL)
	local cDocument := if(nDocType == DHL_NF_ENTRADA, SF1->F1_DOC		, SF2->F2_DOC)
	local cSeries   := if(nDocType == DHL_NF_ENTRADA, SF1->F1_SERIE		, SF2->F2_SERIE)
	local cEntity   := if(nDocType == DHL_NF_ENTRADA, SF1->F1_FORNECE 	, "")
	local cUnit     := if(nDocType == DHL_NF_ENTRADA, SF1->F1_LOJA		, "")
	local cField	:= ""
	local cQry		:= ""
	local lRet		:= .t.
	
	if (nDocType == DHL_NF_ENTRADA)
		cQry	:= " D1_FILIAL = '"+cBranch+"' AND D1_DOC = '"+cDocument+"' AND D1_SERIE = '"+cSeries+"' " +CRLF
		cQry	+= " AND D1_FORNECE = '"+cEntity+"' AND D1_LOJA = '"+cUnit+"' "
		
		cField := "D1_ZZID"
		oSqlAlias:newTable("SD1", cField, cQry)
	elseIf (nDocType == DHL_NF_SAIDA)
		cQry	:= " D2_FILIAL = '"+cBranch+"' AND D2_DOC = '"+cDocument+"' AND D2_SERIE = '"+cSeries+"' "
		
		cField := "D2_ZZID"
		oSqlAlias:newTable("SD2", cField, cQry)
	endif
	
	
	
	while oSqlAlias:notIsEof()
		
		oSql := getSqlValidate(nDocType, cBranch, cDocument, cSeries, cEntity, cUnit, oSqlAlias:getValue(cField), cDepos)
		
		if ((cEntity + cUnit) $ cDepos) .and. (nDocType == DHL_NF_ENTRADA)
			if oSql:getValue("SEQ_MAX") == oSql:getValue("SEQ_CURRENT")
				lRet := .t.
			else
				nResto := abs(val(oSql:getValue("SEQ_CURRENT")) - val(oSql:getValue("SEQ_MAX")))
				oSqlValid:newTable( "SZ3", "COUNT(Z3_FILIAL) NREGS", " Z3_FILIAL = '"+cBranch+"' AND Z3_ID = '"+oSqlAlias:getValue(cField)+"' "+;
									" AND Z3_SEQUEN > '"+oSql:getValue("SEQ_CURRENT")+"' AND Z3_SITUACA = 'E'")
				if (nResto/2) == oSqlValid:getValue("NREGS")
					lRet := .t.
				else
					lRet 	:= .f.
					::cMsg  := "O ID "+ oSqlAlias:getValue(cField) + " já possuí movimentações posteriores e não pode ser excluído."
					exit
				endif
				oSqlValid:close()
			endif
		else
			if oSql:getValue("SEQ_MAX") > oSql:getValue("SEQ_CURRENT")
				lRet 	:= .f.
				::cMsg  := "O ID "+ oSqlAlias:getValue(cField) + " já possuí movimentações posteriores e não pode ser excluído."
				exit
			endif
		endif
		
		oSqlAlias:skip()
		oSql:close()
	endDo
	
	oSqlAlias:close()
	
return(lRet)

/**
* Monta objeto SQL de validação
*/
static function getSqlValidate(nDocType, cBranch, cDocument, cSeries, cEntity, cUnit, cId, cDepos)
	
	local cQuery := ""
	local oSql   := IpSqlObject():newIpSqlObject()
	
	cQuery := " SELECT
	cQuery += "     (SELECT MAX(Z3_SEQUEN)  FROM "+RetSqlName("SZ3")+" SZ3AUX "
	cQuery += "     WHERE "
	cQuery += "        Z3_FILIAL 	= '"+cBranch+"' "
	cQuery += "        AND Z3_ID 	= '"+cId+"' "
	cQuery += "        AND Z3_DOC 	= '"+cDocument+"'"
	cQuery += "        AND Z3_SERIE = '"+cSeries+"' "
	if (nDocType == DHL_NF_ENTRADA)
		cQuery += "        AND Z3_CLIFOR 	= '"+cEntity+"' "
		cQuery += "        AND Z3_LOJA 		 = '"+cUnit+"' "
	endif
	cQuery += "    	   AND Z3_SITUACA = 'N' "
	cQuery += "        AND SZ3AUX.D_E_L_E_T_ = ' ') SEQ_CURRENT, "
	cQuery += "     MAX(Z3_SEQUEN) SEQ_MAX "
	cQuery += " FROM %SZ3.SQLNAME% "
	cQuery += " WHERE "
	cQuery += "    Z3_FILIAL 		  = '"+cBranch+"' "
	cQuery += "    AND Z3_ID 		  = '"+cId+"' "
	if !(((cEntity + cUnit) $ cDepos) .and. (nDocType == DHL_NF_ENTRADA))
		cQuery += "    AND Z3_SITUACA 	  = 'N' "
	endif
	cQuery += "    AND %SZ3.NOTDEL% "
	cQuery += " GROUP BY 2"
	
	oSql:newAlias(cQuery)
	
return oSql


/*
** Busca impostos para NFs
*/
static function getTaxes(oId, cTypeDoc)
	local oSql   	:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	
	cQuery := " CD2_FILIAL = '"+oId:getBranch()+"' AND CD2_TPMOV = '"+oId:getType()+"' AND CD2_SERIE = '"+oId:getSeries()+"' AND CD2_DOC = '"+oId:getDocument()+"' "
	cQuery += " AND CD2_ITEM = '"+oId:getItem()+"' AND CD2_CODPRO = '"+oId:getProduct()+"' "
	if oId:getType() == 'E'
		if cTypeDoc $ "B|D|"
			cQuery += " AND CD2_CODCLI = '"+oId:getEntity()+"' AND CD2_LOJCLI = '"+oId:getUnit()+"' "
		else
			cQuery += " AND CD2_CODFOR = '"+oId:getEntity()+"' AND CD2_LOJFOR = '"+oId:getUnit()+"' "			
		endif
	else
		if cTypeDoc $ "B|D|"
			cQuery += " AND CD2_CODFOR = '"+oId:getEntity()+"' AND CD2_LOJFOR = '"+oId:getUnit()+"' "
		else
			cQuery += " AND CD2_CODCLI = '"+oId:getEntity()+"' AND CD2_LOJCLI = '"+oId:getUnit()+"' "
		endif
	endif
	
	oSql:newTable("CD2", "CD2_IMP, CD2_VLTRIB", cQuery)
	
	while oSql:notIsEof()
		if Upper(alltrim(oSql:getValue("CD2_IMP"))) == "SOL"
			oId:setIcmsValue(oSql:getValue("CD2_VLTRIB"))
		elseif Upper(alltrim(oSql:getValue("CD2_IMP"))) == "IPI"
			oId:setIpiValue(oSql:getValue("CD2_VLTRIB"))
		endif
		
		oSql:skip()
	enddo
	
	oSql:close()
	
return()

/*/{Protheus.doc} updateOutDoc

Atualiza IDs do item de acordo com o do pedido de venda
	
@author Thiago Meschiatti
@since 11/11/2014

@param cBranch, caracter, Fililal
@param cNumber, caracter, Numero do Pedido
@param cItem, caracter, Item do Pedido
@param nRecno, numerico, Recno do item a atualizar

@return TipoRet DescricaoRet
/*/
method updateOutDoc(cBranch, cNumber, cItem, nRecno) class DHLIdManager
	local nI		:= 0
	local cId		:= ''
	local oSql 		:= IpSqlObject():newIpSqlObject()
	
	oSql:newTable("SC6", "C6_ZZID", "C6_FILIAL = '"+cBranch+"' AND C6_NUM = '"+cNumber+"' AND C6_ITEM = '"+cItem+"'")
	cId := oSql:getValue("C6_ZZID")
	oSql:close()
	
	oSql:update("SD2", "D2_ZZID = '"+cId+"' ", "R_E_C_N_O_ = "+cValtoChar(nRecno)+" ")
	
return()


/*/{Protheus.doc} retStatusId

Retorna o status da maior sequencia do id
	
@author Thiago Meschiatti
@since 11/11/2014

@param cBranch, caracter, Id
@param cId, caracter, Id

@return caracter Status da última sequencia do Id
/*/
method retStatusId(cBranch, cId, cEvent) class DHLIdManager
	local oSql 	 	:= IpSqlObject():newIpSqlObject()
	local cQuery 	:= ""
	local cStatus	:= "" 
	local cTypeMov	:= iif(cEvent == DHL_NF_SAIDA, 'E', 'S')
	
	default cBranch := xFilial("SZ3")

	cQuery := " SELECT MAX(Z3_SEQUEN) SEQ, Z3_STATUS FROM %SZ3.SQLNAME% "  
	cQuery += " WHERE"
	cQuery += "		Z3_FILIAL = '"+cBranch+"'" 
    cQuery += "		AND Z3_ID = '"+cId+"'"
    cQuery += "		AND Z3_SITUACA <> 'E' "
    cQuery += "		AND Z3_TPMOV = '"+cTypeMov+"' "        
    cQuery += "		AND SZ3.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY Z3_STATUS"
	
	oSql:newAlias(cQuery)
	if oSql:hasRecords()
		cStatus := oSql:getValue("Z3_STATUS")
	endif

	oSql:close()

return(cStatus)


/*/{Protheus.doc} getRefNfId

Retorna instrução sql para localizar NF do primeiro passo
	
@author Thiago Meschiatti
@since 03/16/2015

@param cBranch, caracter, filial
@param cId, caracter, Id

@return caracter Status da última sequencia do Id
/*/
method getRefNfId(cBranch, cId, cClieFor, cLoja) class DHLIdManager
	local cQuery 	:= ""
	
	default cBranch := xFilial("SZ3")

	cQuery := " SELECT MIN(Z3_SEQUEN) SEQ, Z3_DOC, Z3_SERIE, Z3_ITEM FROM %SZ3.SQLNAME% "  
	cQuery += " WHERE"
	cQuery += "		Z3_FILIAL = '"+cBranch+"'" 
    cQuery += "		AND Z3_ID = '"+cId+"'"
    cQuery += "		AND Z3_SITUACA 	= 'N' "
    cQuery += "		AND Z3_TPMOV 	= 'E' "
    cQuery += "		AND Z3_CLIFOR 	= '" + cClieFor + "' "        
    cQuery += "		AND Z3_LOJA 	= '" + cLoja + "' "                
    cQuery += "		AND SZ3.D_E_L_E_T_ = ' ' "
    cQuery += "	GROUP BY "
    cQuery += "		Z3_SEQUEN, Z3_DOC, Z3_SERIE, Z3_ITEM "
	 
return(cQuery)
