#include 'Protheus.ch'
#include 'dhl.ch'
#include 'fwcommand.ch'
#include "rwmake.ch"

/*/{Protheus.doc} RelNfRec

Relatório de Notas Fiscais de Entrada Recusadas

@author Diego de Angelo
@since 29/10/2014

/*/
user function RelNfRec()
	
	local bParams		:= {|| oParamBox:show() }
	local bProcRel		:= {|| procRel() }

	private cCliTipo	:= ""
	private cCnpjRemet	:= ""
	private cNomeRemet	:= ""
	
	private oSqlNotas	:= nil
	
	private cFornecDe	:= ""
	private cFornecAte	:= ""
	
	private cLojaDe		:= ""
	private cLojaAte	:= ""
	
	private cUfDe		:= ""
	private cUfAte		:= ""
	
	private cNotaDe		:= ""
	private cNotaAte	:= ""
	
	private cSerieDe	:= ""
	private cSerieAte	:= ""
	
	private dDtDgtDe	:= CtoD("")
	private dDtDgtAte	:= CtoD("")
	
	private dDtEmisDe	:= CtoD("")
	private dDtEmisAte	:= CtoD("")
	
	private cStatus		:= ""
	
	private cTipoNota	:= ""
	
	private cFormProprio:= ""
	
	private cNome  		:= "RelNfRec"
	private cTitulo 	:= "Notas fiscais de entrada e recusadas"
	private cDescricao	:= "Relatório de "+cTitulo
	
	private oReport		:= nil
	private oSecNotas	:= nil
	
	private oParamBox 	:= IpParamBoxObject():newIpParamBoxObject(cNome)
	
	private oSqlNotas	:= nil
	
	criaParams()
	
	oReport := TReport():new(cNome,cTitulo,bParams,bProcRel,cDescricao)
	
	criaSecao()
	
	oReport:setLandscape()
	oReport:printDialog()
	
return


/**
* Função responsável pela criação dos parâmetros
*/
static function criaParams()
	
	local oParam := nil
	local cHelp  := ""
	
	oParamBox:setTitle(cTitulo)
	
	oParam := IpParamObject():newIpParamObject("fornecDe", "get", "Fornecedor de", "C", 60, TamSX3("A2_COD")[1])
	oParam:setF3("SA2A")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("lojaDe", "get", "Loja de", "C", 30, TamSX3("F1_LOJA")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("fornecAte", "get", "Fornecedor até", "C", 60, TamSX3("A2_COD")[1])
	oParam:setF3("SA2A")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("lojaAte", "get", "Loja até", "C", 30, TamSX3("F1_LOJA")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("ufDe", "get", "UF Fornecedor de", "C", 60, TamSX3("F1_EST")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("ufAte", "get", "UF Fornecedor até", "C", 60, TamSX3("F1_EST")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("notaDe", "get", "Nota de", "C", 60, TamSX3("F1_DOC")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("notaAte", "get", "Nota até", "C", 60, TamSX3("F1_DOC")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serieDe", "get", "Série de", "C", 60, TamSX3("F1_SERIE")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serieAte", "get", "Série até", "C", 60, TamSX3("F1_SERIE")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataDigitDe", "get", "Dt. Digitação de", "D", 60, TamSX3("F1_DTDIGIT")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataDigitAte", "get", "Dt. Digitação até", "D", 60, TamSX3("F1_DTDIGIT")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dtEmisDe", "get", "Dt. Emissão de", "D", 60, TamSX3("F1_EMISSAO")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dtEmisAte", "get", "Dt. Emissão até", "D", 60, TamSX3("F1_EMISSAO")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("tipoNota", "combo", "Tipo da Nota", "C", 60)
	oParam:setValues({"N=Normal", "D=Devolução", "I=Compl. ICMS", "B=Beneficiamento", "C=Compl. Preço/Frete", "T=Todos"})
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("formProprio", "combo", "Formulário Próprio", "C", 60)
	oParam:setValues({"S=Sim", "N=Não", "T=Todos"})
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("status", "combo", "Status", "C", 60)
	oParam:setValues({"Não Transmitida", "T=Transmitida", "D=Uso Denegado", "N=Não Autorizada", "S=Autorizada", "C=Cancelada", "X=Cancelamento não Autorizado", "TD=Todos"})
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("helpStatus", "memo", "Descrição Status", "C", 60)
	cHelp	:= "Para visualização de notas fiscais recusadas, a seguinte combinação de parâmetros deverá ser considerada: Tipo da Nota: Devolução e Formulário Próprio: Sim"
	oParam:setInitializer(cHelp)
	oParam:setWhen(".F.")
	oParamBox:addParam(oParam)
	
return


/**
* Função responsável pelo processamento do relatório.
*/
static function procRel()

	cFornecDe	:= oParamBox:getValue("fornecDe")
	cFornecAte	:= oParamBox:getValue("fornecAte")
	cLojaDe		:= oParamBox:getValue("lojaDe")
	cLojaAte	:= oParamBox:getValue("lojaAte")
	cUfDe		:= oParamBox:getValue("ufDe")
	cUfAte		:= oParamBox:getValue("ufAte")
	cNotaDe		:= oParamBox:getValue("notaDe")
	cNotaAte	:= oParamBox:getValue("notaAte")
	cSerieDe	:= oParamBox:getValue("serieDe")
	cSerieAte	:= oParamBox:getValue("serieAte")
	dDtDgtDe	:= oParamBox:getValue("dataDigitDe")
	dDtDgtAte	:= oParamBox:getValue("dataDigitAte")
	dDtEmisDe	:= oParamBox:getValue("dtEmisDe")
	dDtEmisAte	:= oParamBox:getValue("dtEmisAte")
	cStatus		:= oParamBox:getValue("status")
	cTipoNota	:= oParamBox:getValue("tipoNota")
	cFormProprio:= oParamBox:getValue("formProprio")
	
	getNotas()
	procImpressao()
	
return


/**
* Função responsável pela criação da seção.
*/
static function criaSecao()
	
	local aOrdem := criaIndice()
	
	oSecNotas := TRSection():new(oReport,,,aOrdem)
	//oSecNotas:lHeaderBreak:= .T.
	
	TRCell():new(oSecNotas, "FILIAL_CLIENTE"	, 		  					, "Cliente(Filial)"		, 	nil									, 20						,,,,,"RIGHT")
	TRCell():new(oSecNotas, "SITE"				,	      					, "Site(Empresa)"		, 	nil									, 20						,,,,,"RIGHT")
	TRCell():new(oSecNotas, "RAZAO_DESTINAT"	, 							, "Razão Social Dest."	, 	nil									, TamSX3("A1_NOME")[1]		,,,,,"RIGHT")
	TRCell():new(oSecNotas, "CNPJ_DESTINAT"		, 							, "CPF/CNPJ Dest."		,	nil									, TamSX3("A1_CGC")[1]		,,,,,"RIGHT")
	TRCell():new(oSecNotas, "RAZAO_REMETENT"	, 							, "Razão Social Remet."	,	nil									, TamSX3("A1_NOME")[1]		,,,,,"RIGHT")
	TRCell():new(oSecNotas, "CNPJ_REMETENT"		, 							, "CPF/CNPJ Remet."		,	nil									, TamSX3("A1_CGC")[1]		,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_EST"			, 							, "UF Remetente"		, 	nil									, TamSX3("F1_EST")[1]		,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_TIPO"			, 							, "Tipo da Nota"		, 	nil									, TamSX3("F1_TIPO")[1]		,,,,,"RIGHT")
	if FwUnitBusiness() == DHL_BUSINESSUNIT_MUL
		TRCell():new(oSecNotas, "TIPO_DESC"		, 							, "Desc. Tipo da Nota"	, 	nil									, 20						,,,,,"RIGHT")
	endif 
	TRCell():new(oSecNotas, "F1_DOC"			, 							, "Nota Fiscal"			, 	nil									, TamSX3("F1_DOC")[1]		,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_SERIE"			,							, "Série"				, 	nil									, TamSX3("F1_SERIE")[1]		,,,,,"RIGHT")
	if FwUnitBusiness() == DHL_BUSINESSUNIT_MUL
		TRCell():new(oSecNotas, "CFOP"			, 							, "CFOP"				, 	nil									, 5							,,,,,"RIGHT")
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AG2  .or. cFilAnt == AGL_LOTE_005
		TRCell():new(oSecNotas, "CFOP"			, 							, "CFOP"				, 	nil									, 5							,,,,,"RIGHT") //Emerson Holanda 29/08/23
		TRCell():new(oSecNotas, "TES"			, 							, "TES"				, 	nil									    , 3							,,,,,"RIGHT") //Emerson Holanda 29/08/23
		TRCell():new(oSecNotas, "NF_SAIDA"			, 						, "NFs Saída"				, 	nil								, 70	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "SERIE_NF_SAIDA"	,						, "Série NFs Saída"		, 	nil									, 70	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "DT_EMI_NF_SAIDA"	,						, "Dt. Emissão NFs Saída", 	nil									, 70	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "VLR_TOT_NF_SAIDA",						, "Vlr. Total NFs Saída"	, 	nil									, 70	,,,,,"RIGHT")
		
		TRCell():new(oSecNotas, "NF_EST_ICMS"			,					, "NFs Estorno ICMS"			, 	nil								, 70	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "SERIE_NF_EST_ICMS"	,					, "Série NFs Est. ICMS"		, 	nil								, 70	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "DT_EMI_NF_EST_ICMS"	,					, "Dt. Emissão NFs Est. ICMS", 	nil								, 70	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "VLR_TOT_NF_EST_ICMS"	,					, "Vlr. Total NFs Est. ICMS", 	nil								, 70	,,,,,"RIGHT")
		
		TRCell():new(oSecNotas, "NF_REM_SIMB"			,					, "NFs Rem. Simb."			, 	nil								, 70	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "SERIE_NF_REM_SIMB"	,					, "Série NFs Rem. Simb."		, 	nil								, 70	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "DT_EMI_NF_REM_SIMB"	,					, "Dt. Emissão NFs Rem. Simb.",	nil								, 70	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "VLR_TOT_NF_REM_SIMB"	,					, "Vlr. Total NFs Rem. Simb.", 	nil								, 70	,,,,,"RIGHT")
					
	endif 
	TRCell():new(oSecNotas, "F1_FORMUL"			,							, "Form. Próprio?"		, 	nil									, 4							,,,,,"RIGHT")
	TRCell():new(oSecNotas, "QTD_LINHAS"		,							, "Qtd. SKU/Linhas"		, 	nil									, 4							,,,,,"RIGHT")
	TRCell():new(oSecNotas, "QTD_PECAS"			,							, "Qtd. Peças"			, 	PesqPict("SD1", "D1_QUANT")			, TamSX3("D1_QUANT")[1]		,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_ZZCTEAW"		,							, "Ctrc/Awb"			, 	PesqPict("SF1", "F1_ZZCTEAW")		, TamSX3("F1_ZZCTEAW")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_DTDIGIT"		,							, "Expedição/Ent.Doca"	, 	nil									, TamSX3("F1_DTDIGIT")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_EMISSAO"		,							, "Data Emissão"		, 	nil									, TamSX3("F1_EMISSAO")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_USERLGI"		,							, "Recebido por"		, 	nil									, 20						,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_BASEIPI"		,							, "Base IPI"			, 	PesqPict("SF1", "F1_BASEIPI")		, TamSX3("F1_BASEIPI")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_BASEICM"		,							, "Base ICMS"			, 	PesqPict("SF1", "F1_BASEICM")		, TamSX3("F1_BASEICM")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_BRICMS"			,							, "Base ST"				, 	PesqPict("SF1", "F1_BRICMS")		, TamSX3("F1_BRICMS")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_VALIPI"			,							, "Valor IPI"			, 	PesqPict("SF1", "F1_VALIPI")		, TamSX3("F1_VALIPI")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_VALICM"			,							, "Valor ICMS"			, 	PesqPict("SF1", "F1_VALICM")		, TamSX3("F1_VALICM")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_ICMSRET"		,							, "Valor ST"			, 	PesqPict("SF1", "F1_ICMSRET")		, TamSX3("F1_ICMSRET")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "VLR_ICMANT"		,							, "Valor ICMS Antec."	, 	PesqPict("SD1", "D1_VALANTI")		, TamSX3("D1_VALANTI")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_VALMERC"		,							, "Valor Mercadoria"	, 	PesqPict("SF1", "F1_VALMERC")		, TamSX3("F1_VALMERC")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_VALBRUT"		,							, "Valor Total"			, 	PesqPict("SF1", "F1_VALBRUT")		, TamSX3("F1_VALBRUT")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_FIMP"			,							, "Status"				, 	nil									, TamSX3("F1_FIMP")[1]		,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_CHVNFE"			,							, "Chave NFe"			, 	PesqPict("SF1", "F1_CHVNFE")		, TamSX3("F1_CHVNFE")[1]	,,,,,"RIGHT")
	
return


/**
* Processamento da Impressão
*/
static function procImpressao()

	local cQuery	:= ""
	local aFilEmp	:= FWArrFilAtu(cEmpAnt, cFilAnt)
	local cNomeFil	:= aFilEmp[SM0_NOME]
	local cDescEmp	:= aFilEmp[SM0_NOMECOM]
	local cUnidNeg	:= aFilEmp[SM0_DESCUN]
	local cCnpj		:= Transform(aFilEmp[SM0_CGC], "@R 99.999.999/9999-99")
	local oLibDHL	:= DHLLibrary():newDHLLibrary()
	local cCriadoPor:= ""
	local cStatus	:= ""
	local aAux := {}
	
	oSecNotas:cAlias := oSqlNotas:getAlias()
	oReport:startPage()
	oSecNotas:init()
	oSqlNotas:setField("F1_DTDIGIT","D")
	oSqlNotas:setField("F1_EMISSAO","D")
	
	oReport:SetMeter(oSqlNotas:count())

	while oSqlNotas:notIsEof()
		oReport:IncMeter()
		if validaPreNota(oSqlNotas:getValue("F1_DOC"), oSqlNotas:getValue("F1_SERIE"), oSqlNotas:getValue("F1_FORNECE"), oSqlNotas:getValue("F1_LOJA"))
			oSqlNotas:skip()
			loop
		endIf
		
		retInfCliForn(oSqlNotas:getValue("F1_FORNECE"),oSqlNotas:getValue("F1_LOJA"),oSqlNotas:getValue("F1_TIPO"))
		
		oSecNotas:Cell("FILIAL_CLIENTE"):setValue(cNomeFil)
		oSecNotas:Cell("SITE"):setValue(cUnidNeg)
		
		oSecNotas:Cell("RAZAO_DESTINAT"):setValue(cDescEmp)
		oSecNotas:Cell("CNPJ_DESTINAT"):setValue(cCnpj)
		
		oSecNotas:Cell("RAZAO_REMETENT"):setValue(cNomeRemet)
		oSecNotas:Cell("CNPJ_REMETENT"):setValue(cCnpjRemet)
		
		cCriadoPor	:= retFullName(oLibDHL:getLGUser(oSqlNotas:getValue("F1_USERLGI")))
		oSecNotas:Cell("F1_USERLGI"):setValue(cCriadoPor)
		
		cStatus	:= retNotaStatus(Alltrim(oSqlNotas:getValue("F1_FIMP")), Alltrim(oSqlNotas:getValue("F1_ESPECIE")))
		oSecNotas:Cell("F1_FIMP"):setValue(cStatus)
		
		if FwUnitBusiness() == DHL_BUSINESSUNIT_MUL
			
			oSecNotas:Cell("TIPO_DESC"):setValue(retTipoDoc(oSqlNotas))
			oSecNotas:Cell("CFOP"):setValue(retCfop(oSqlNotas))
		
		elseif FwUnitBusiness() == DHL_BUSINESSUNIT_AG2 .or. cFilAnt == AGL_LOTE_005
			oSecNotas:Cell("CFOP"):setValue(retCfop(oSqlNotas)) //Emerson Holanda 29/08/23
			oSecNotas:Cell("TES"):setValue(retTES(oSqlNotas)) //Emerson Holanda 29/08/23
			aAux := getNFsRef(oSqlNotas,"1")
			oSecNotas:Cell("NF_SAIDA"):setValue(aAux[1])
			oSecNotas:Cell("SERIE_NF_SAIDA"):setValue(aAux[2])
			oSecNotas:Cell("DT_EMI_NF_SAIDA"):setValue(aAux[3])
			oSecNotas:Cell("VLR_TOT_NF_SAIDA"):setValue(aAux[4])
		
			aAux := getNFsRef(oSqlNotas,"2")
			oSecNotas:Cell("NF_EST_ICMS"):setValue(aAux[1])
			oSecNotas:Cell("SERIE_NF_EST_ICMS"):setValue(aAux[2])
			oSecNotas:Cell("DT_EMI_NF_EST_ICMS"):setValue(aAux[3])
			oSecNotas:Cell("VLR_TOT_NF_EST_ICMS"):setValue(aAux[4])
		
			aAux := getNFsRef(oSqlNotas,"3")
			oSecNotas:Cell("NF_REM_SIMB"):setValue(aAux[1])
			oSecNotas:Cell("SERIE_NF_REM_SIMB"):setValue(aAux[2])
			oSecNotas:Cell("DT_EMI_NF_REM_SIMB"):setValue(aAux[3])
			oSecNotas:Cell("VLR_TOT_NF_REM_SIMB"):setValue(aAux[4])
		
		endif
		
		oSecNotas:printLine()
		
		oSqlNotas:skip()
		
	endDo
	
	oSecNotas:finish()
	oSqlNotas:close()
return


/**
* Função responsável pela montagem da consulta SQL.
*/
static function getNotas()
	
	local cQuery := ""
	local nIndice:= oSecNotas:getOrder()
	
	cQuery	:= "SELECT " +CRLF
	cQuery	+= "	SF1.F1_FILIAL, " +CRLF
	cQuery	+= "	SF1.F1_FORNECE, " +CRLF
	cQuery	+= "	SF1.F1_LOJA, " +CRLF
	cQuery	+= "	SF1.F1_EST, " +CRLF
	cQuery	+= "	SF1.F1_TIPO, " +CRLF
	cQuery	+= "	SF1.F1_DOC, " +CRLF
	cQuery	+= "	SF1.F1_SERIE, " +CRLF
	cQuery	+= "	CASE "
	cQuery	+= "		WHEN SF1.F1_FORMUL = 'S' THEN 'S' " +CRLF
	cQuery	+= "		WHEN SF1.F1_FORMUL = ' ' THEN 'N' " +CRLF
	cQuery	+= "	END F1_FORMUL, "
	cQuery	+= "	SUM(SD1.D1_QUANT) QTD_PECAS, " +CRLF
	cQuery	+= "	COUNT(SD1.D1_ITEM) QTD_LINHAS, " +CRLF
	cQuery	+= "	SF1.F1_ZZCTEAW, " +CRLF
	cQuery	+= "	SF1.F1_DTDIGIT, " +CRLF
	cQuery	+= "	SF1.F1_EMISSAO, " +CRLF
	cQuery	+= "	SF1.F1_BASEIPI, " +CRLF
	cQuery	+= "	SF1.F1_BASEICM, " +CRLF
	cQuery	+= "	SF1.F1_BRICMS, " +CRLF
	cQuery	+= "	SF1.F1_VALIPI, " +CRLF
	cQuery	+= "	SF1.F1_VALICM, " +CRLF
	cQuery	+= "	SF1.F1_ICMSRET, " +CRLF
	cQuery	+= "	SUM(SD1.D1_VALANTI) VLR_ICMANT, " +CRLF
	cQuery	+= "	SF1.F1_VALMERC, " +CRLF
	cQuery	+= "	SF1.F1_VALBRUT, " +CRLF
	cQuery	+= "	SF1.F1_FIMP," +CRLF
	cQuery	+= "	SF1.F1_CHVNFE, " +CRLF
	cQuery	+= "	SF1.F1_USERLGI, " +CRLF
	cQuery	+= "	SF1.F1_ESPECIE " +CRLF
	cQuery	+= "FROM " +CRLF
	cQuery	+= "	%SF1.SQLNAME% " +CRLF
	cQuery	+= "INNER JOIN %SD1.SQLNAME% ON " +CRLF
	cQuery += " 	SD1.D1_FILIAL = SF1.F1_FILIAL" + CRLF
	cQuery += "   AND %SD1.NOTDEL% " + CRLF
	cQuery	+= "	AND SD1.D1_DOC = SF1.F1_DOC " +CRLF
	cQuery	+= "	AND SD1.D1_SERIE = SF1.F1_SERIE " +CRLF
	cQuery	+= "	AND SD1.D1_FORNECE = SF1.F1_FORNECE " +CRLF
	cQuery	+= "	AND SD1.D1_LOJA = SF1.F1_LOJA" +CRLF
	cQuery += " WHERE " +CRLF
	cQuery += " 	SF1.F1_FILIAL = '%SF1.FILIAL%' " + CRLF
	cQuery += "   AND %SF1.NOTDEL% " + CRLF
	cQuery	+= "	AND SF1.F1_DOC >= '"+cNotaDe+"' " + CRLF
	cQuery	+= "	AND SF1.F1_DOC <= '"+cNotaAte+"' " + CRLF
	cQuery	+= "	AND SF1.F1_SERIE >= '"+cSerieDe+"' " + CRLF
	cQuery	+= "	AND SF1.F1_SERIE <= '"+cSerieAte+"' " + CRLF
	cQuery	+= "	AND SF1.F1_FORNECE >= '"+cFornecDe+"' " + CRLF
	cQuery	+= "	AND SF1.F1_FORNECE <= '"+cFornecAte +"' " +CRLF
	cQuery	+= "	AND SF1.F1_LOJA >= '"+cLojaDe+"' " + CRLF
	cQuery	+= "	AND SF1.F1_LOJA <= '"+cLojaAte+"' " + CRLF
	cQuery	+= "	AND SF1.F1_DTDIGIT >= '"+dtos(dDtDgtDe)+"' " + CRLF
	cQuery	+= "	AND SF1.F1_DTDIGIT <= '"+dtos(dDtDgtAte)+"' " + CRLF
	cQuery	+= "	AND SF1.F1_EMISSAO >= '"+dtos(dDtEmisDe)+"' " + CRLF
	cQuery	+= "	AND SF1.F1_EMISSAO <= '"+dtos(dDtEmisAte)+"' " + CRLF
	cQuery	+= "	AND SF1.F1_EST >= '"+cUfDe+"' " + CRLF
	cQuery	+= "	AND SF1.F1_EST <= '"+cUfAte+"' " + CRLF
	
	if cStatus	<> "TD"
		if cStatus == "Não Transmitida"
			cStatus	:= Space(TamSx3("F1_FIMP")[1])
		endIf
		cQuery	+= "	AND SF1.F1_FIMP = '"+cStatus+"' " + CRLF
	endIf
	
	if cTipoNota <> "T"
		cQuery	+= "	AND SF1.F1_TIPO = '"+cTipoNota+"' " + CRLF
	endIf
	
	if cFormProprio <> "T"
		cQuery	+= "	AND SF1.F1_FORMUL = '"+cFormProprio+"'" + CRLF
	endIf
	
	cQuery	+= "GROUP BY" +CRLF
	cQuery	+= "	SF1.F1_FORNECE," +CRLF
	cQuery	+= "	SF1.F1_LOJA," +CRLF
	cQuery	+= "	SF1.F1_EST," +CRLF
	cQuery	+= "	SF1.F1_TIPO," +CRLF
	cQuery	+= "	SF1.F1_DOC, " +CRLF
	cQuery	+= "	SF1.F1_SERIE, " +CRLF
	cQuery	+= "	SF1.F1_FORMUL," +CRLF
	cQuery	+= "	SF1.F1_ZZCTEAW," +CRLF
	cQuery	+= "	SF1.F1_DTDIGIT," +CRLF
	cQuery	+= "	SF1.F1_EMISSAO," +CRLF
	cQuery	+= "	SF1.F1_USERLGI," +CRLF
	cQuery	+= "	SF1.F1_BASEIPI," +CRLF
	cQuery	+= "	SF1.F1_BASEICM," +CRLF
	cQuery	+= "	SF1.F1_BRICMS," +CRLF
	cQuery	+= "	SF1.F1_VALIPI," +CRLF
	cQuery	+= "	SF1.F1_VALICM," +CRLF
	cQuery	+= "	SF1.F1_ICMSRET," +CRLF
	cQuery	+= "	SF1.F1_VALMERC," +CRLF
	cQuery	+= "	SF1.F1_VALBRUT," +CRLF
	cQuery	+= "	SF1.F1_FIMP," +CRLF
	cQuery	+= "	SF1.F1_CHVNFE," +CRLF
	cQuery	+= "	SF1.F1_ESPECIE," +CRLF
	cQuery	+= "	SF1.F1_FILIAL" +CRLF
	cQuery	+= "ORDER BY" +CRLF
	
	if nIndice == 1	
		cQuery	+= "F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO" +CRLF
	else
		cQuery	+= "F1_FILIAL, F1_FORNECE, F1_LOJA, F1_DOC" +CRLF
	endIf
	
	oSqlNotas	:= IpSqlObject():newIpSqlObject()
	oSqlNotas:newAlias(cQuery)
return

/*
* Função responsável pelo retorno da descrição do status da nota
*/
static function retNotaStatus(cCodStat,cEspecie)

	local cTitulo	:= ""
	
	Do Case
	Case cCodStat == "S"
		cTitulo	:= "NF Autorizada"
	Case cCodStat	== "T"
		cTitulo	:= "NF Transmitida"
	Case cCodStat	== "D"
		cTitulo	:= "NF Uso Denegado"
	Case cCodStat	== "N"
		cTitulo	:= "NF Não Autorizada"
	Case cCodStat	== "C"
		cTitulo	:= "NF Cancelada"
	Case cCodStat	== "X"
		cTitulo	:= "Cancelamento não Autorizado"
	Case Empty(cCodStat) .AND. Alltrim(cEspecie) == "SPED"
		cTitulo	:= "NF Não Transmitida"
	OtherWise
		cTitulo	:= ""
	End Case
	
return cTitulo


/*
* Função responsável pelo retorno do nome e cnpj do remetende
*/
static function retInfCliForn(cCod,cLoja,cTipoNF)

	local oSqlUtil := IpSqlObject():newIpSqlObject()
	
	if AllTrim(cTipoNF) $ "DB"
		oSqlUtil:newTable("SA1", "A1_NOME, A1_CGC, A1_PESSOA", "A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '" + cCod + "' AND A1_LOJA = '" + cLoja + "'")
		cNomeRemet	:= oSqlUtil:getValue("A1_NOME")
		cCnpjRemet	:= oSqlUtil:getValue("A1_CGC")
		cCliTipo	:= oSqlUtil:getValue("A1_PESSOA")
	else
		oSqlUtil:newTable("SA2", "A2_NOME, A2_CGC, A2_TIPO", "A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = '" + cCod + "' AND A2_LOJA = '" + cLoja + "'")
		cNomeRemet	:= oSqlUtil:getValue("A2_NOME")
		cCnpjRemet	:= oSqlUtil:getValue("A2_CGC")
		cCliTipo	:= oSqlUtil:getValue("A2_TIPO")
	endIf
	
	cCnpjRemet := Transform(cCnpjRemet,Substr(PicPes(cCliTipo),1,at("%",PicPes(cCliTipo))-1))
	
	oSqlUtil:close()
return


/*
* Função responsável pela criação do indice.
*/
static function criaIndice()

	local aOrdem := {}
	
	aAdd(aOrdem, "Numero + Serie + Fornecedor + Loja + Tipo da Nota")
	aAdd(aOrdem, "Fornecedor + Loja + Numero")
	
return aOrdem


/*
* Função responsável pela validação da nota, verificando se a mesma é pré-nota.
**/
static function validaPreNota(cDoc, cSerie, cFornec, cLoja)

	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local cTes		:= oSqlUtil:getFieldValue("SD1", "D1_TES", "D1_FILIAL = '%SD1.FILIAL%' AND %SD1.NOTDEL% AND D1_DOC ='"+cDoc+"' AND D1_SERIE ='"+cSerie+"' AND D1_FORNECE ='"+cFornec+"' AND D1_LOJA='"+cLoja+"'")
	local lRet		:= .F.
	
	if Empty(cTes)
		lRet	:= .T. 
	endIf
	
	oSqlUtil:close()
return lRet


/*
** Retorna o tipo do documento
*/
static function retTipoDoc(oSqlNotas)
	local oSql 	:= IpSqlObject():newIpSqlObject()
	local cRet	:= "" 
	
	oSql:newTable("SZ4", "Z4_TIPMOV", 	" %SZ4.XFILIAL% AND "+;
										" Z4_DOC 	= '" + oSqlNotas:getValue("F1_DOC") 	+ "' AND "+;
										" Z4_SERIE 	= '" + oSqlNotas:getValue("F1_SERIE") 	+ "' AND "+;
										" Z4_CLIFOR = '" + oSqlNotas:getValue("F1_FORNECE") + "' AND "+;
										" Z4_LOJA 	= '" + oSqlNotas:getValue("F1_LOJA") 	+ "' ")
	
	if oSql:hasRecords()
		if oSql:getValue("Z4_TIPMOV") == '1'
			cRet := '1 - Fornecedor'
		elseif oSql:getValue("Z4_TIPMOV") == '2'
			cRet := '2 - Cobertura'
		endif
	else
		if oSqlNotas:getValue("F1_TIPO") == 'B' .and. oSqlNotas:getValue("F1_FORMUL") == 'N'
			cRet := "3 - Entrada Normal(Beneficiamento)"
		elseif oSqlNotas:getValue("F1_TIPO") == 'N' .and. oSqlNotas:getValue("F1_FORMUL") == 'N'
			cRet := "3 - Entrada Normal(Normal)"
		elseif oSqlNotas:getValue("F1_FORMUL") == 'S'
			cRet := "4 - Formulário Próprio"
		endif
	endif
	
	oSql:close()
	
return (cRet)


/*
** Retorna o tipo do documento
*/
static function retCfop(oSqlNotas)
	local oSql 	:= IpSqlObject():newIpSqlObject()
	local cRet	:= "" 
	
	oSql:newAlias(retSqlCfop(oSqlNotas))
	
	if oSql:hasRecords()
		cRet := oSql:getValue("D1_CF")
	endif
	
	oSql:close()
	
return (cRet)

/*
** Retorna o tipo do documento
*/
static function retTES(oSqlNotas)
	local oSql 	:= IpSqlObject():newIpSqlObject()
	local cRet	:= "" 
	
	oSql:newAlias(retSqlCfop(oSqlNotas))
	
	if oSql:hasRecords()
		cRet := oSql:getValue("D1_TES")
	endif
	
	oSql:close()
	
return (cRet)

/*
** Retorna o tipo do documento
*/
static function retSqlCfop(oSqlNotas)
	local cQuery	:= ""
	
	cQuery += " SELECT D1_CF,D1_TES	                                                   "+CRLF
	cQuery += " FROM %SD1.SQLNAME%                                                     "+CRLF
	cQuery += " WHERE                                                                  "+CRLF
	cQuery += " 	%SD1.XFILIAL%                                                      "+CRLF
	cQuery += " 	AND %SD1.NOTDEL%                                                   "+CRLF
	cQuery += " 	AND D1_DOC		= '" + oSqlNotas:getValue("F1_DOC") 	+ "'       "+CRLF
	cQuery += " 	AND D1_SERIE	= '" + oSqlNotas:getValue("F1_SERIE") 	+ "'       "+CRLF
	cQuery += " 	AND D1_FORNECE	= '" + oSqlNotas:getValue("F1_FORNECE") + "'       "+CRLF
	cQuery += " 	AND D1_LOJA		= '" + oSqlNotas:getValue("F1_LOJA") 	+ "'       "+CRLF
	cQuery += " ORDER BY D1_DOC, D1_SERIE, D1_ITEM 	                                   "+CRLF
	
return (cQuery)


/*
** Retorna as informações das notas fiscais referenciadas
*/
static function getNFsRef(oSqlNotas,cTpQry)
	
	local oSql 	:= IpSqlObject():newIpSqlObject()
	local oSqlAux	:= IpSqlObject():newIpSqlObject()
	local aRet		:= {"","","",""} 
	local cQuery	:= ""
	local nI		:= 1
	local cChaves	:= ""
	
	if cTpQry == "1" //NFs Saída
		
		cQuery := " SELECT DISTINCT D1_NFORI, D1_SERIORI "									+ CRLF
		cQuery += " FROM %SD1.SQLNAME% "														+ CRLF
		cQuery += " WHERE "																		+ CRLF
		cQuery += " 	%SD1.XFILIAL% "															+ CRLF
		cQuery += " 	AND %SD1.NOTDEL% "														+ CRLF
		cQuery += " 	AND D1_DOC		= '" + oSqlNotas:getValue("F1_DOC") 	+ "' "			+ CRLF
		cQuery += " 	AND D1_SERIE	= '" + oSqlNotas:getValue("F1_SERIE") 	+ "' "			+ CRLF
		cQuery += " 	AND D1_FORNECE = '" + oSqlNotas:getValue("F1_FORNECE") + "' "		+ CRLF
		cQuery += " 	AND D1_LOJA	 = '" + oSqlNotas:getValue("F1_LOJA") 	+ "' "			+ CRLF
		cQuery += " ORDER BY D1_NFORI, D1_SERIORI "											+ CRLF
	
		oSql:newAlias(cQuery)
				
		while oSql:notIsEof()
			
			oSqlAux:newTable("SF2", "F2_EMISSAO, F2_VALBRUT", 	" %SF2.XFILIAL% AND "+;
										" F2_DOC 	= '" + oSql:getValue("D1_NFORI") 	+ "' AND "+;
										" F2_SERIE = '" + oSql:getValue("D1_SERIORI") + "' ")
			oSqlAux:setField("F2_EMISSAO", "D")
			
			if oSqlAux:hasRecords()
				aRet[1] += "(" + Alltrim(Str(nI)) + ") " + Alltrim(oSql:getValue("D1_NFORI")) + " | "
				aRet[2] += "(" + Alltrim(Str(nI)) + ") " + Alltrim(oSql:getValue("D1_SERIORI")) + " | "
				aRet[3] += "(" + Alltrim(Str(nI)) + ") " + Alltrim(DtoC(oSqlAux:getValue("F2_EMISSAO"))) + " | "
				aRet[4] += "(" + Alltrim(Str(nI)) + ") " + AllTrim(Transform(oSqlAux:getValue("F2_VALBRUT"),PesqPict("SF2","F2_VALBRUT"))) + " | "
				nI++
			endif
			
			oSqlAux:close()
			
			oSql:skip()
		end
		
		oSql:close()
		
	elseif cTpQry == "2" //NFs Estorno ICMS
		
		cQuery := " SELECT DISTINCT D2_DOC, D2_SERIE, F2_EMISSAO, F2_VALBRUT "		+ CRLF
		cQuery += " FROM %SD2.SQLNAME% " 													+ CRLF
		cQuery += " INNER JOIN %SF2.SQLNAME% "												+ CRLF
		cQuery += "	ON  SF2.F2_FILIAL = SD2.D2_FILIAL "								+ CRLF
		cQuery += "	AND SF2.F2_DOC = SD2.D2_DOC "										+ CRLF
		cQuery += "	AND SF2.F2_SERIE = SD2.D2_SERIE "									+ CRLF
		cQuery += "	AND SF2.F2_CLIENTE = SD2.D2_CLIENTE "								+ CRLF
		cQuery += "	AND SF2.F2_LOJA = SD2.D2_LOJA "										+ CRLF
		cQuery += "	AND %SF2.NOTDEL% "													+ CRLF
		cQuery += " WHERE "																	+ CRLF
		cQuery += " 	%SD2.XFILIAL% "														+ CRLF
		cQuery += " 	AND %SD2.NOTDEL% "													+ CRLF
		cQuery += " 	AND SD2.D2_NFORI	= '" + oSqlNotas:getValue("F1_DOC") + "' "	+ CRLF
		cQuery += " 	AND SD2.D2_SERIORI = '" + oSqlNotas:getValue("F1_SERIE") + "' "+ CRLF
		cQuery += " ORDER BY D2_DOC, D2_SERIE " 											+ CRLF
		
		oSql:newAlias(cQuery) 
		
		oSql:setField("F2_EMISSAO", "D")
				
		while oSql:notIsEof()
			
			aRet[1] += "(" + Alltrim(Str(nI)) + ") " + Alltrim(oSql:getValue("D2_DOC")) + " | "
			aRet[2] += "(" + Alltrim(Str(nI)) + ") " + Alltrim(oSql:getValue("D2_SERIE")) + " | "
			aRet[3] += "(" + Alltrim(Str(nI)) + ") " + Alltrim(DtoC(oSql:getValue("F2_EMISSAO"))) + " | "
			aRet[4] += "(" + Alltrim(Str(nI)) + ") " + AllTrim(Transform(oSql:getValue("F2_VALBRUT"),PesqPict("SF2","F2_VALBRUT"))) + " | "
			nI++
		
			oSql:skip()
		end
		
		oSql:close()
	
	elseif cTpQry == "3" //NFs Remessa Simbólica
	
		cQuery += " SELECT Z4_IDCOB "															+ CRLF
		cQuery += " FROM %SZ4.SQLNAME% "														+ CRLF
		cQuery += " WHERE "																		+ CRLF
		cQuery += " 	%SZ4.XFILIAL% "															+ CRLF
		cQuery += " 	AND %SZ4.NOTDEL% "														+ CRLF
		cQuery += " 	AND Z4_DOC		= '" + oSqlNotas:getValue("F1_DOC") 	+ "' "			+ CRLF
		cQuery += " 	AND Z4_SERIE	= '" + oSqlNotas:getValue("F1_SERIE") 	+ "' "			+ CRLF
		cQuery += " 	AND Z4_CLIFOR = '" + oSqlNotas:getValue("F1_FORNECE") + "' "		+ CRLF
		cQuery += " 	AND Z4_LOJA	 = '" + oSqlNotas:getValue("F1_LOJA") 	+ "' "			+ CRLF
		cQuery += " 	AND Z4_TIPMOV	 = '1' "													+ CRLF
		cQuery += " ORDER BY Z4_IDCOB "															+ CRLF
	
		oSql:newAlias(cQuery)
				
		while oSql:notIsEof()
			
			cQuery := " SELECT Z4_DOC, Z4_SERIE, F1_EMISSAO, F1_VALBRUT "					+ CRLF
			cQuery += " FROM %SZ4.SQLNAME% " 													+ CRLF
			cQuery += " INNER JOIN %SF1.SQLNAME% "												+ CRLF
			cQuery += "	ON  SF1.F1_FILIAL = SZ4.Z4_FILIAL "								+ CRLF
			cQuery += "	AND SF1.F1_DOC = SZ4.Z4_DOC "										+ CRLF
			cQuery += "	AND SF1.F1_SERIE = SZ4.Z4_SERIE "									+ CRLF
			cQuery += "	AND SF1.F1_FORNECE = SZ4.Z4_CLIFOR "								+ CRLF
			cQuery += "	AND SF1.F1_LOJA = SZ4.Z4_LOJA "										+ CRLF
			cQuery += "	AND %SF1.NOTDEL% "													+ CRLF
			cQuery += " WHERE "																	+ CRLF
			cQuery += " 	%SZ4.XFILIAL% "														+ CRLF
			cQuery += " 	AND %SZ4.NOTDEL% "													+ CRLF
			cQuery += " 	AND SZ4.Z4_IDCOB	= '" + oSql:getValue("Z4_IDCOB") + "' "		+ CRLF
			cQuery += " 	AND SZ4.Z4_TIPMOV	 = '2' "											+ CRLF
		
			oSqlAux:newAlias(cQuery)
			
			oSqlAux:setField("F1_EMISSAO", "D")
			
			if oSqlAux:hasRecords()
				if !(Alltrim(oSqlAux:getValue("Z4_DOC")) + Alltrim(oSqlAux:getValue("Z4_SERIE")) $ cChaves)
					aRet[1] += "(" + Alltrim(Str(nI)) + ") " + Alltrim(oSqlAux:getValue("Z4_DOC")) + " | "
					aRet[2] += "(" + Alltrim(Str(nI)) + ") " + Alltrim(oSqlAux:getValue("Z4_SERIE")) + " | "
					aRet[3] += "(" + Alltrim(Str(nI)) + ") " + Alltrim(DtoC(oSqlAux:getValue("F1_EMISSAO"))) + " | "
					aRet[4] += "(" + Alltrim(Str(nI)) + ") " + AllTrim(Transform(oSqlAux:getValue("F1_VALBRUT"),PesqPict("SF1","F1_VALBRUT"))) + " | "
					nI++
					cChaves += Alltrim(oSqlAux:getValue("Z4_DOC")) + Alltrim(oSqlAux:getValue("Z4_SERIE")) + "/"
				endif
			endif
			
			oSqlAux:close()
			
			oSql:skip()
		end
		
		oSql:close()
		
	endif
	
return (aRet)


/**
* Retorna Nome do Usuário
**/
Static Function retFullName(cCodUsr)
Return UsrFullName(cCodUsr)
