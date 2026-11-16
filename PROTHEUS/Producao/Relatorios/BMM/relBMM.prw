#include "protheus.ch"
#include 'fwcommand.ch'
#include "dhl.ch"

/*/{Protheus.doc} RelBMM

Relatório de BMM
	
@author Renato Castro
@since 23/10/2014

/*/
user function RelBMM()
    
	local bParams		:= {|| lInfParams := getParams() }
	local bProcRel		:= {|| procRel() }
	
	private lInfParams	:= .F.
	
	private cDepositDe	:= ""
	private cLojaDe		:= ""
	private cDepositAte	:= ""
	private cLojaAte	:= ""
	private cProdutoDe	:= ""
	private cProdutoAte	:= ""
	private dDataDe		:= CtoD("")
	private dDataAte	:= CtoD("")
	private cTipoAjuste	:= ""
	
	private cNome  		:= "RelBMM"
	private cTitulo 	:= "BMM"
	private cDescricao	:= "Relatório de "+cTitulo
	private cAlias		:= ""
 	
	private oReport		:= nil
	private oSecDados	:= nil
	 	
	private oBreakDados	:= nil
	private oParamBox 	:= IpParamBoxObject():newIpParamBoxObject(cNome)
	
	private oSql		:= nil
	
	oReport := TReport():new(cNome, cTitulo, bParams, bProcRel, cDescricao)
	oReport:setLandscape()
	oReport:printDialog()
        
return

/**
 * Leitura dos parâmetros
 */
static function getParams()
	
	local oParam := nil
	
	oParamBox:setTitle(cTitulo)
	
	oParam := IpParamObject():newIpParamObject("depositanteDe", "get", "Depositante de", "C", 60, TamSX3("A1_COD")[1])
	oParam:setF3("SA1")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("lojaDe", "get", "Loja de", "C", 30, TamSX3("A1_LOJA")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("depositanteAte", "get", "Depositante até", "C", 60, TamSX3("A1_COD")[1])
	oParam:setF3("SA1")
	oParam:setRequired(.T.)
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("lojaAte", "get", "Loja até", "C", 30, TamSX3("A1_LOJA")[1])
	oParam:setRequired(.T.)
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("produtoDe", "get", "Produto de", "C", 60, TamSX3("B1_COD")[1])
	oParam:setF3("SB1")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("produtoAte", "get", "Produto até", "C", 60, TamSX3("B1_COD")[1])
	oParam:setF3("SB1")
	oParam:setRequired(.T.)
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataDe", "get", "Data de", "D", 60, TamSX3("F2_EMISSAO")[1])
	oParam:setRequired(.T.)
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataAte", "get", "Data até", "D", 60, TamSX3("F2_EMISSAO")[1])
	oParam:setRequired(.T.)
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("tipoAjuste", "combo", "Tipo de ajuste", "C", 60)
	oParam:setValues({"Negativo","Positivo","Todos"}) 
	oParamBox:addParam(oParam)
	
return oParamBox:show()


/**
 * Processamento do Relatório
 */
static function procRel()

	if (!lInfParams .and. !getParams())
		MsgBox("Processamento abortado", "Atenção", "ALERT")
		return
	endIf
	
	cDepositDe		:= oParamBox:getValue("depositanteDe")
	cLojaDe			:= oParamBox:getValue("lojaDe")
	cDepositAte		:= oParamBox:getValue("depositanteAte")
	cLojaAte		:= oParamBox:getValue("lojaAte")
	cProdutoDe		:= oParamBox:getValue("produtoDe")
	cProdutoAte		:= oParamBox:getValue("produtoAte")
	dDataDe	  		:= oParamBox:getValue("dataDe")
	dDataAte		:= oParamBox:getValue("dataAte")
	cTipoAjuste		:= oParamBox:getValue("tipoAjuste")
	 
	getDadosRel()
	criaSecoes()
	procImpressao()
	
return


/**
 * Cria as Seções do Relatório
 */
static function criaSecoes()
	
	local lEndSection 	:= .F.
	local lEndReport  	:= .F.
	local bFormula		:= nil
		
	oSecDados := TRSection():new(oReport)
	TRCell():new(oSecDados, "DEPOSITANTE", 	cALias, "Depositante", 	nil, 							TamSX3("A1_NOME")[1])
	TRCell():new(oSecDados, "CNPJ", 		nil	  , "CNPJ", 		nil, 							TamSX3("A1_CGC")[1])
	TRCell():new(oSecDados, "DATA", 		cALias, "Data", 		nil, 							15)
	TRCell():new(oSecDados, "TIPO", 		cALias, "Tipo", 		nil, 							10)
	TRCell():new(oSecDados, "NOTA", 		cALias, "Nota", 		nil, 							TamSX3("F2_DOC")[1])
	TRCell():new(oSecDados, "SERIE", 		cALias, "Série", 		nil, 							10)
	TRCell():new(oSecDados, "PRODUTO", 		cALias, "Produto",		nil, 							TamSX3("B1_COD")[1])
	TRCell():new(oSecDados, "DESCRICAO", 	cALias, "Descrição", 	nil, 							TamSX3("B1_DESC")[1])
	TRCell():new(oSecDados, "UNMED",		cALias, "UM", 			nil, 							6 )
	TRCell():new(oSecDados, "NCM", 			cALias, "NCM", 			nil, 							TamSX3("B1_POSIPI")[1])
	TRCell():new(oSecDados, "QTD", 			cALias, "Qtd.", 		PesqPict("SD2", "D2_QUANT"), 	TamSX3("D2_QUANT")[1],,,,,"RIGHT")
	TRCell():new(oSecDados, "VLUNIT", 		cALias, "Vl.Unit", 		PesqPict("SD2", "D2_PRCVEN"), 	TamSX3("D2_PRCVEN")[1],,,,,"RIGHT")
	TRCell():new(oSecDados, "TOTAL", 		cALias, "Vl.Total", 	PesqPict("SD2", "D2_TOTAL"), 	TamSX3("D2_TOTAL")[1],,,,,"RIGHT")
	
	oBreakDados := TRBreak():new(oSecDados, {|| oSql:isEof()}, "Totais")
	
	TRFunction():new(oSecDados:cell("TOTAL"), "totalValor", "SUM", oBreakDados, "", PesqPict("SD2", "D2_TOTAL"), bFormula, lEndSection, lEndReport)
	
return


/**
 * Processamento da Impressão
 */
static function procImpressao()
	local cDeposit	:= ""
	local aFilEmp	:= FWArrFilAtu(cEmpAnt, cFilAnt) 
	local cCnpj		:= ""
	
	oReport:startPage()
	oSecDados:init()
	
	while oSql:notIsEof()
		cDeposit	:=	Alltrim(oSql:getValue("DEPOSITANTE"))	
		
		if cDeposit == "DHL"
			cCnpj	:= aFilEmp[SM0_CGC]
		else
			cCnpj	:= oSql:getValue("CNPJ")
		endIf
		
		oSecDados:Cell("CNPJ"):setValue(cCnpj)	
		
		oSecDados:printLine()
			
		oSql:skip()
		
	endDo
	
	oSecDados:finish()
	
	oSql:close()
	
return


/**
 * Monta a Query
 */
static function getDadosRel()
	
	local cQuery := ""
	local cTMReq := AllTrim(GetMV("ZZ_TMREQ"))
	local cTMDev := AllTrim(GetMV("ZZ_TMDEV"))
	
	cQuery += " SELECT * FROM ( " + CRLF
	cQuery += " 	SELECT " + CRLF
	cQuery += " 		A1_NOME DEPOSITANTE, " + CRLF
	cQuery += " 		A1_CGC CNPJ, " + CRLF
	cQuery += " 		F2_EMISSAO DATA, " + CRLF
	cQuery += " 		'NEGATIVO' TIPO, " + CRLF
	cQuery += " 		F2_DOC NOTA, " + CRLF
	cQuery += " 		F2_SERIE SERIE, " + CRLF
	cQuery += " 		D2_COD PRODUTO, " + CRLF
	cQuery += " 		RTRIM(B1_DESC) DESCRICAO, " + CRLF
	cQuery += " 		B1_UM UNMED, " + CRLF
	cQuery += " 		B1_POSIPI NCM, " + CRLF
	cQuery += " 		D2_QUANT QTD, " + CRLF
	cQuery += " 		D2_PRCVEN VLUNIT, " + CRLF
	cQuery += " 		D2_TOTAL TOTAL " + CRLF
	cQuery += " 	FROM %SF2.SQLNAME% " + CRLF
   	cQuery += " 	INNER JOIN %SD2.SQLNAME% ON " + CRLF
   	cQuery += " 		D2_FILIAL = F2_FILIAL AND " + CRLF
   	cQuery += " 		D2_DOC = F2_DOC AND " + CRLF
   	cQuery += " 		D2_SERIE = F2_SERIE AND " + CRLF
   	cQuery += " 		D2_CLIENTE = F2_CLIENTE AND " + CRLF
   	cQuery += " 		D2_LOJA = F2_LOJA AND " + CRLF
   	cQuery += " 		%SD2.NOTDEL% " + CRLF
   	cQuery += " 	INNER JOIN %SA1.SQLNAME% ON " + CRLF
   	cQuery += " 		A1_FILIAL = '%SA1.FILIAL%' AND " + CRLF
	cQuery += " 		A1_COD = F2_CLIENTE AND " + CRLF
	cQuery += " 		A1_LOJA = F2_LOJA AND " + CRLF
	cQuery += " 		%SA1.NOTDEL% " + CRLF
	cQuery += " 	INNER JOIN %SB1.SQLNAME% ON " + CRLF
	cQuery += " 		B1_FILIAL = '%SB1.FILIAL%' AND " + CRLF
	cQuery += " 		B1_COD = D2_COD AND " + CRLF
	cQuery += "			B1_COD BETWEEN '"+cProdutoDe+"' AND '"+cProdutoAte+"' AND " + CRLF
	cQuery += " 		%SB1.NOTDEL% " + CRLF
	cQuery += " 	WHERE " + CRLF
	cQuery += " 		F2_FILIAL = '%SF2.FILIAL%' AND " + CRLF
	cQuery += "			F2_CLIENTE BETWEEN '"+cDepositDe+"' AND '"+cDepositAte+"' AND " + CRLF
	cQuery += "			F2_LOJA BETWEEN '"+cLojaDe+"' AND '"+cLojaAte+"' AND " + CRLF
	cQuery += "			F2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' AND " + CRLF
	cQuery += "			F2_SERIE = '" + DHL_SERIE_INVENTARIO + "' AND " + CRLF
	cQuery += " 		%SF2.NOTDEL% " + CRLF

	cQuery += " 	UNION ALL " + CRLF

	cQuery += " 	SELECT " + CRLF 
	cQuery += " 		A1_NOME, " + CRLF
	cQuery += " 		A1_CGC, " + CRLF
	cQuery += " 		F1_EMISSAO, " + CRLF
	cQuery += " 		'POSITIVO', " + CRLF
	cQuery += " 		F1_DOC, " + CRLF
	cQuery += " 		F1_SERIE, " + CRLF
	cQuery += " 		D1_COD, " + CRLF
	cQuery += " 		RTRIM(B1_DESC) DESCRICAO, " + CRLF
	cQuery += " 		B1_UM, " + CRLF
	cQuery += " 		B1_POSIPI, " + CRLF
	cQuery += " 		D1_QUANT, " + CRLF
	cQuery += " 		D1_VUNIT, " + CRLF
	cQuery += " 		D1_TOTAL  " + CRLF
	cQuery += " 	FROM %SF1.SQLNAME% " + CRLF
	cQuery += " 	INNER JOIN %SD1.SQLNAME% ON " + CRLF
	cQuery += " 		D1_FILIAL = F1_FILIAL AND " + CRLF
	cQuery += " 		D1_DOC = F1_DOC AND " + CRLF
	cQuery += " 		D1_SERIE = F1_SERIE AND " + CRLF
	cQuery += " 		D1_FORNECE = F1_FORNECE AND " + CRLF
	cQuery += " 		D1_LOJA = F1_LOJA AND " + CRLF
	cQuery += " 		%SD1.NOTDEL% " + CRLF
	cQuery += " 	INNER JOIN %SA1.SQLNAME% ON " + CRLF
	cQuery += " 		A1_FILIAL = '%SA1.FILIAL%' AND " + CRLF
	cQuery += " 		A1_COD = F1_FORNECE AND " + CRLF
	cQuery += " 		A1_LOJA = F1_LOJA AND " + CRLF
	cQuery += " 		%SA1.NOTDEL% " + CRLF
	cQuery += " 	INNER JOIN %SB1.SQLNAME% ON " + CRLF
	cQuery += " 		B1_FILIAL = '%SB1.FILIAL%' AND " + CRLF
	cQuery += " 		B1_COD = D1_COD AND " + CRLF
	cQuery += "			B1_COD BETWEEN '"+cProdutoDe+"' AND '"+cProdutoAte+"' AND " + CRLF
	cQuery += " 		%SB1.NOTDEL% " + CRLF
	cQuery += " 	WHERE " + CRLF
	cQuery += " 		F1_FILIAL = '%SF1.FILIAL%' AND " + CRLF
	cQuery += "			F1_FORNECE BETWEEN '"+cDepositDe+"' AND '"+cDepositAte+"' AND " + CRLF
	cQuery += "			F1_LOJA BETWEEN '"+cLojaDe+"' AND '"+cLojaAte+"' AND " + CRLF
	cQuery += "			F1_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' AND " + CRLF
	cQuery += "			RTRIM(F1_ESPECIE) = '" + DHL_ESPECIE_INVENTARIO + "' AND " + CRLF
	cQuery += " 		%SF1.NOTDEL% " + CRLF

	cQuery += " 	UNION ALL " + CRLF

	cQuery += " 	SELECT " + CRLF
	cQuery += " 		'DHL', " + CRLF
	cQuery += " 		'', " + CRLF
	cQuery += " 		D3_EMISSAO, " + CRLF
	cQuery += " 		CASE D3_TM " + CRLF
	cQuery += " 			WHEN '"+cTMDev+"' THEN 'POSITIVO' " + CRLF
	cQuery += " 			WHEN '"+cTMReq+"' THEN 'NEGATIVO' " + CRLF
	cQuery += " 		END, " + CRLF
	cQuery += " 		D3_NUMSEQ, " + CRLF
	cQuery += " 		'', " + CRLF
	cQuery += " 		D3_COD, " + CRLF
	cQuery += " 		RTRIM(B1_DESC) DESCRICAO, " + CRLF
	cQuery += " 		B1_UM, " + CRLF
	cQuery += " 		B1_POSIPI, " + CRLF
	cQuery += " 		D3_QUANT, " + CRLF
	cQuery += " 		CASE WHEN D3_QUANT = 0 THEN 0 ELSE D3_CUSTO1/D3_QUANT END VUNIT, " + CRLF
	cQuery += " 		D3_CUSTO1 " + CRLF
	cQuery += " 	FROM %SD3.SQLNAME% " + CRLF
	cQuery += " 	INNER JOIN %SB1.SQLNAME% ON " + CRLF
	cQuery += " 		B1_FILIAL = '%SB1.FILIAL%' AND " + CRLF
	cQuery += " 		B1_COD = D3_COD AND " + CRLF
	cQuery += "			B1_COD BETWEEN '"+cProdutoDe+"' AND '"+cProdutoAte+"' AND " + CRLF
	cQuery += " 		%SB1.NOTDEL% " + CRLF
	cQuery += " 	WHERE " + CRLF
	cQuery += " 		D3_FILIAL = '%SD3.FILIAL%' AND " + CRLF
	cQuery += "			D3_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' AND " + CRLF
	cQuery += "			RTRIM(D3_DOC) = 'INVENT' AND " + CRLF
	if cTipoAjuste == "Todos"
		cQuery += " 		%SD3.NOTDEL% ) TMP ORDER BY DATA " + CRLF
	else
		cQuery += " 		%SD3.NOTDEL% ) TMP WHERE TIPO = '"+cTipoAjuste+"' ORDER BY DATA " + CRLF
	endif
	
	oSql := IpSqlObject():newIpSqlObject()
	
	oSql:newAlias(cQuery)
	oSql:setField("DATA", "D")
	
	cAlias := oSql:getAlias()
	
return