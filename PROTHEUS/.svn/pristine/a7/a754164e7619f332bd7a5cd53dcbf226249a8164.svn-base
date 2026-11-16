#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} RelIds

Relatório de IDs e Status de Peças
	
@author Thiago Meschiatti
@since 19/11/2014

/*/
User Function RelIds()

	local bParams		:= {|| oParamBox:show() }
	local bProcRel		:= {|| procRel() }
	
	private cIdDe		:= ""
	private cIdAte		:= ""
	private cProdDe		:= ""
	private cProdAte	:= ""
	private dDtMovtDe	:= CtoD("")
	private dDtMovAte	:= CtoD("")
	
	private cNome  		:= "RelIds"
	private cTitulo 	:= "IDs e Status de Peças (Good / Bad)"
	private cDescricao	:= "Relatório de "+cTitulo
	
	private oReport		:= nil
	private oSecMov		:= nil
	private oSecId		:= nil	
	
	private oParamBox 	:= IpParamBoxObject():newIpParamBoxObject(cNome)
	private oSqlIds	:= nil
	
	criaParams()
	
	oReport := TReport():new(cNome, cTitulo, bParams, bProcRel, cDescricao)
	
	criaSecao()
	
	oReport:setLandscape()
	oReport:printDialog()

Return()


/**
* Função responsável pela criação dos parâmetros
*/
static function criaParams()
	
	local oParam 	:= nil
	local cHelp	:= ""
	
	oParamBox:setTitle(cTitulo)
	
	oParam := IpParamObject():newIpParamObject("IdDe", "get", "ID de", "C", 60, TamSX3("Z3_ID")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("IdAte", "get", "ID até", "C", 60, TamSX3("Z3_ID")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("ProdDe", "get", "Produto de", "C", 60, TamSX3("B1_COD")[1])
	oParam:setF3("SB1")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("ProdAte", "get", "Produto Ate", "C", 60, TamSX3("B1_COD")[1])
	oParam:setF3("SB1")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataMovDe", "get", "Dt. Movimentação de", "D", 60, TamSX3("Z3_DTMOV")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataMovtAte", "get", "Dt. Movimentação até", "D", 60, TamSX3("Z3_DTMOV")[1])
	oParamBox:addParam(oParam)
	
return()


/**
* Função responsável pelo processamento do relatório.
*/
static function procRel()

	cIdDe		:= oParamBox:getValue("IdDe")
	cIdAte		:= oParamBox:getValue("IdAte")
	cProdDe		:= oParamBox:getValue("ProdDe")
	cProdAte	:= oParamBox:getValue("ProdAte")
	dDtMovtDe	:= oParamBox:getValue("dataMovDe")
	dDtMovAte	:= oParamBox:getValue("dataMovtAte")
	
	getNotas()
	procImpressao()
	
return


/**
* Função responsável pela criação da seção.
*/
static function criaSecao()
	
	local aOrdem	:= criaIndice()
	
	oSecMov	:= TRSection():new(oReport,,,aOrdem)
	oSecMov:lLineStyle := .T.
	oSecId := TRSection():new(oSecMov,,,)
	//oSecNotas:lHeaderBreak:= .T.
	
	TRCell():new(oSecMov, "Z3_ID"		, 		, " ID"			, 	nil									, TamSX3("Z3_ID")[1]		,,,"CENTER",,"CENTER",,,)
	TRCell():new(oSecMov, "Z3_PRODUTO"	,	    , " Produto"	, 	nil									, TamSX3("Z3_PRODUTO")[1]	,,,"CENTER",,"CENTER",,,)
	TRCell():new(oSecMov, "Z3_DESC"		, 		, " Descrição"	, 	nil									, TamSX3("Z3_DESC")[1]		,,,"CENTER",,"CENTER",,,)
	TRCell():new(oSecMov, "CLASSFIC"	, 		, " Clas. Fis."	,	nil									, 30						,,,"CENTER",,"CENTER",,,)
	TRCell():new(oSecMov, "B1_UM"		, 		, " UM"			, 	nil									, TamSX3("B1_UM")[1]		,,,"CENTER",,"CENTER",,,)
		
	TRCell():new(oSecId, "Z3_VUNIT"		, 		, "Vlr. Unit."				,	PesqPict("SZ3", "Z3_VUNIT")	, TamSX3("Z3_VUNIT")[1]	,,,"RIGHT",,"CENTER",,,.t.)
	TRCell():new(oSecId, "Z3_DTMOV"		, 		, "Dt. Moviment."			, 	nil							, TamSX3("Z3_DTMOV")[1]	,,,"CENTER",,"CENTER",,,.t.)
	TRCell():new(oSecId, "Z3_HRMOV"		, 		, "Hr. Moviment."			, 	nil							, TamSX3("Z3_HRMOV")[1]	,,,"CENTER",,"CENTER",,,.t.)
	TRCell():new(oSecId, "Z3_TPMOV"		, 		, "Tp. Mov."				, 	nil							, TamSX3("Z3_DOC")[1]	,,,"CENTER",,"CENTER",,,.t.)
	TRCell():new(oSecId, "Z3_DOC"		,		, "Doc."					, 	nil							, TamSX3("Z3_DOC")[1]	,,,"CENTER",,"CENTER",,,.t.)
	TRCell():new(oSecId, "Z3_SERIE"		,		, "Série"					, 	nil							, TamSX3("Z3_SERIE")[1]	,,,"CENTER",,"CENTER",,,.t.)
	TRCell():new(oSecId, "CLIFOR"		, 		, "Cliente / Fornecedor"	,	nil							, TamSX3("A1_COD")[1] + TamSX3("A1_LOJA")[1]	,,,"CENTER",,"CENTER",,,.t.)
	TRCell():new(oSecId, "Z3_STATUS"	,		, "Status"					, 	nil							, TamSX3("Z3_STATUS")[1],,,"CENTER",,"CENTER",,,.t.)
	TRCell():new(oSecId, "Z3_SEQUEN"	,		, "Seq."					, 	nil							, TamSX3("Z3_SEQUEN")[1],,,"CENTER",,"CENTER",,,.t.)
	TRCell():new(oSecId, "Z3_SITUACA"	,		, "Situação"				, 	nil							, TamSX3("Z3_SITUACA")[1],,,"CENTER",,"CENTER",,,.t.)
	TRCell():new(oSecId, "Z3_VALICM"	,		, "Vlr. ICMS"				, 	PesqPict("SZ3", "Z3_VALICM"), TamSX3("Z3_VALICM")[1],,,"RIGHT",,"CENTER",,,.t.)
	TRCell():new(oSecId, "Z3_VALIPI"	,		, "Vlr. IPI"				, 	PesqPict("SZ3", "Z3_VALIPI"), TamSX3("Z3_VALICM")[1],,,"RIGHT",,"CENTER",,,.t.)
	TRCell():new(oSecId, "TES"			,		, "TES"						, 	nil							, (TamSX3("F4_TEXTO")[1]) + 6 ,,,"CENTER",,"CENTER",,,.t.)
	
return


/**
* Processamento da Impressão
*/
static function procImpressao()
	local cIdAtual	:= ""
	
	oSecMov:cAlias	:= oSqlIds:getAlias()
	oSecId:cAlias	:= oSqlIds:getAlias()
	
	oReport:startPage()
	oSqlIds:setField("Z3_DTMOV", "D")
	
	oReport:SetMeter(oSqlIds:count())
		
	cIdAtual := oSqlIds:getValue("Z3_ID")

	oSecMov:init()
	oSecMov:printLine()
	oSecId:init()	
	
	while oSqlIds:notIsEof() 
		oReport:IncMeter()
		if cIdAtual != oSqlIds:getValue("Z3_ID")
			oSecId:finish()
			oSecMov:finish()
			oSecMov:init()
			oSecMov:printLine()
			oSecId:init()	
			cIdAtual := oSqlIds:getValue("Z3_ID")
		endif
		
		oSecId:Cell("TES"):setValue(retTes(oSqlIds))
		oSecId:printLine()
		
		oSqlIds:skip()
		
	endDo
	
	oSecId:finish()
	oSecMov:finish()
	oSqlIds:close()
return


/**
* Função responsável pela montagem da consulta SQL.
*/
static function getNotas()
	
	local cQuery := ""
	local nIndice:= oSecMov:getOrder()
	
	cQuery += " SELECT  Z3_ID, Z3_PRODUTO, Z3_DESC, B1_ORIGEM || ' - ' || B1_CLASFIS CLASSIFIC, B1_UM, Z3_VUNIT, Z3_DTMOV, Z3_HRMOV, Z3_TPMOV, "  
	cQuery += "       	Z3_DOC, Z3_SERIE, Z3_CLIFOR || ' - ' || Z3_LOJA CLIFOR, Z3_STATUS, Z3_SEQUEN, Z3_VALICM, Z3_VALIPI, Z3_SITUACA, Z3_ITEM, Z3_CLIFOR, Z3_LOJA "
	cQuery += " FROM %SZ3.SQLNAME% "
	cQuery += " INNER JOIN %SB1.SQLNAME% ON " 
	cQuery += "       B1_FILIAL   = Z3_FILIAL "
	cQuery += "   AND B1_COD      = Z3_PRODUTO "
	cQuery += "   AND %SB1.NOTDEL% "
	cQuery += " WHERE "
	cQuery += " 	%SZ3.XFILIAL% "
	cQuery += "   AND Z3_ID BETWEEN '"+cIdDe+"' AND '"+cIdAte+"'"
	cQuery += "   AND Z3_PRODUTO BETWEEN '"+cProdDe+"' AND '"+cProdAte+"'"
	cQuery += "   AND Z3_DTMOV BETWEEN '"+dtos(dDtMovtDe)+"' AND '"+dtos(dDtMovAte)+"'"
	cQuery += "   AND %SZ3.NOTDEL% "
	cQuery += " ORDER BY Z3_ID, Z3_SEQUEN"
	
	oSqlIds	:= IpSqlObject():newIpSqlObject()
	oSqlIds:newAlias(cQuery)
return()	


/*
*	Função responsável pela criação do indice.
*/
static function criaIndice()
	local aOrdem	:= {}
	
	aADD(aOrdem, "Filial + ID")
return aOrdem


/*
** Retorna Tes do registro 
*/ 
static function retTes(oSqlIds)
	local cAlias	:= ""
	local cTes		:= ""
	local cFil		:= xFilial("SZ3")
	local cDoc		:= oSqlIds:getValue("Z3_DOC")
	local cSerie	:= oSqlIds:getValue("Z3_SERIE")
	local cProduto	:= oSqlIds:getValue("Z3_PRODUTO")
	local cItem		:= oSqlIds:getValue("Z3_ITEM")
	local cId		:= oSqlIds:getValue("Z3_ID")
	local cCliFor	:= oSqlIds:getValue("Z3_CLIFOR")
	local cLoja		:= oSqlIds:getValue("Z3_LOJA")
	local cStatus	:= oSqlIds:getValue("Z3_SITUACA")
	local cTpMov	:= oSqlIds:getValue("Z3_TPMOV") 
	local oSql		:= IpSqlObject():newIpSqlObject()
	
	if cStatus != DHL_ID_SITUACAO_EXCLUIDO
		if cTpMov == "E"
			cTes := oSql:getFieldValue("SD1", "D1_TES", " D1_FILIAL = '"+cFil+"'  AND D1_DOC = '"+cDoc+"' AND D1_SERIE = '"+cSerie+"' AND D1_COD = '"+cProduto+"' "+;
										"AND D1_ITEM = '"+cItem+"' AND D1_ZZID = '"+cId+"' AND D1_FORNECE = '"+cCliFor+"' AND D1_LOJA = '"+cLoja+"' "  )
		else
			cTes := oSql:getFieldValue("SD2", "D2_TES", " D2_FILIAL = '"+cFil+"'  AND D2_DOC = '"+cDoc+"' AND D2_SERIE = '"+cSerie+"' AND D2_COD = '"+cProduto+"' "+;
										"AND D2_ITEM = '"+cItem+"' AND D2_ZZID = '"+cId+"' "  )
		endif
		cTes := alltrim(cTes) + " - " + alltrim(oSql:getFieldValue("SF4", "F4_TEXTO", " F4_FILIAL = '"+cFil+"' AND F4_CODIGO = '"+cTes+"' "))
	endif
	
return (cTes)