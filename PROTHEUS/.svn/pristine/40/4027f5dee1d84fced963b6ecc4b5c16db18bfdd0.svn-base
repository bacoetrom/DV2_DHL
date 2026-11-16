#include 'Protheus.ch'
#include 'dhl.ch'
#include 'fwcommand.ch'
#include "rwmake.ch"

/*/{Protheus.doc} RelNfCli

Relatório de Notas Fiscais de Cliente

@author Diego de Angelo
@since 31/10/2014

/*/
user function RelNfCli()
	
	local bParams		:= {|| oParamBox:show() }
	local bProcRel		:= {|| procRel() }

	private cCliTipo	:= ""
	private cCnpjRemet	:= ""
	private cNomeRemet	:= ""
	
	private oSqlNotas	:= nil
	
	private cClientDe	:= ""
	private cClientAte	:= ""
	
	private cLojaDe		:= ""
	private cLojaAte	:= ""
	
	private cUfDe		:= ""
	private cUfAte		:= ""
	
	private cNotaDe		:= ""
	private cNotaAte	:= ""
	
	private cSerieDe	:= ""
	private cSerieAte	:= ""
	
	//private dDtDgtDe	:= CtoD("")
	//private dDtDgtAte	:= CtoD("")
	
	private dDtEmisDe	:= CtoD("")
	private dDtEmisAte	:= CtoD("")
	
	private dDtPedDe	:= CtoD("")
	private dDtPedAte	:= CtoD("")
	
	private cNome  		:= "RelNfCli"
	private cTitulo 	:= "NF. Clientes"
	private cDescricao	:= "Relatório de "+cTitulo
	
	private oReport		:= nil
	private oSecNotas	:= nil
	
	private oParamBox 	:= IpParamBoxObject():newIpParamBoxObject(cNome)
	
	private oSqlNotas	:= nil
	
	criaParams()
	
	oReport := TReport():new(cNome, cTitulo, bParams, bProcRel, cDescricao)
	
	criaSecao()
	
	oReport:setLandscape()
	oReport:printDialog()
	
return


/**
* Função responsável pela criação dos parâmetros
*/
static function criaParams()
	
	local oParam 	:= nil
	local cHelp	:= ""
	
	oParamBox:setTitle(cTitulo)
	
	oParam := IpParamObject():newIpParamObject("clienteDe", "get", "Cliente de", "C", 60, TamSX3("A2_COD")[1])
	oParam:setF3("SA1")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("lojaDe", "get", "Loja de", "C", 30, TamSX3("F2_LOJA")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("clienteAte", "get", "Cliente até", "C", 60, TamSX3("A2_COD")[1])
	oParam:setF3("SA1")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("lojaAte", "get", "Loja até", "C", 30, TamSX3("F2_LOJA")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("ufDe", "get", "UF Cliente de", "C", 60, TamSX3("F2_EST")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("ufAte", "get", "UF Cliente até", "C", 60, TamSX3("F2_EST")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("notaDe", "get", "Nota de", "C", 60, TamSX3("F2_DOC")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("notaAte", "get", "Nota até", "C", 60, TamSX3("F2_DOC")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serieDe", "get", "Série de", "C", 60, TamSX3("F2_SERIE")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serieAte", "get", "Série até", "C", 60, TamSX3("F2_SERIE")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dtEmisDe", "get", "Dt. Emissão de", "D", 60, TamSX3("F2_EMISSAO")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dtEmisAte", "get", "Dt. Emissão até", "D", 60, TamSX3("F2_EMISSAO")[1])
	oParamBox:addParam(oParam)

	oParam := IpParamObject():newIpParamObject("dataPedDe", "get", "Dt. Pedido de", "D", 60, TamSX3("C5_EMISSAO")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataPedAte", "get", "Dt. Pedido até", "D", 60, TamSX3("C5_EMISSAO")[1])
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

	cClientDe		:= oParamBox:getValue("clienteDe")
	cClientAte		:= oParamBox:getValue("clienteAte")
	cLojaDe		:= oParamBox:getValue("lojaDe")
	cLojaAte		:= oParamBox:getValue("lojaAte")
	cUfDe			:= oParamBox:getValue("ufDe")
	cUfAte			:= oParamBox:getValue("ufAte")
	cNotaDe		:= oParamBox:getValue("notaDe")
	cNotaAte		:= oParamBox:getValue("notaAte")
	cSerieDe		:= oParamBox:getValue("serieDe")
	cSerieAte		:= oParamBox:getValue("serieAte")
	//dDtDgtDe		:= oParamBox:getValue("dataDigitDe")
	//dDtDgtAte		:= oParamBox:getValue("dataDigitAte")
	dDtEmisDe		:= oParamBox:getValue("dtEmisDe")
	dDtEmisAte		:= oParamBox:getValue("dtEmisAte")
	cStatus		:= oParamBox:getValue("status")
	dDtPedDe		:= oParamBox:getValue("dataPedDe")
	dDtPedAte		:= oParamBox:getValue("dataPedAte")
		
	getNotas()
	procImpressao()
	
return


/**
* Função responsável pela criação da seção.
*/
static function criaSecao()
	
	local aOrdem	:= criaIndice()
	
	oSecNotas := TRSection():new(oReport,,,aOrdem)
	oSecNotas:lHeaderBreak:= .T.
	
	TRCell():new(oSecNotas, "FILIAL_CLIENTE"	, 		  					, "Cliente(Filial)"		, 	nil									, 20						,,,,,"RIGHT")
	TRCell():new(oSecNotas, "SITE"				,	      					, "Site(Empresa)"		, 	nil									, 20						,,,,,"RIGHT")
	TRCell():new(oSecNotas, "RAZAO_DESTINAT"	, 							, "Razão Social Dest."	, 	nil									, TamSX3("A1_NOME")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "CNPJ_DESTINAT"		, 							, "CPF/CNPJ Dest."		,	nil									, TamSX3("A1_CGC")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_EST"			, 							, "UF Destinatário"		, 	nil									, TamSX3("F2_EST")[1]	,,,,,"RIGHT")	
	TRCell():new(oSecNotas, "RAZAO_REMETENT"	, 							, "Razão Social Remet."	,	nil									, TamSX3("A1_NOME")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "CNPJ_REMETENT"		, 							, "CPF/CNPJ Remet."		,	nil									, TamSX3("A1_CGC")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_DOC"			, 							, "Nota Fiscal"			, 	nil									, TamSX3("F2_DOC")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_SERIE"			,							, "Série"				, 	nil									, TamSX3("F2_SERIE")[1]	,,,,,"RIGHT")
	
	TRCell():new(oSecNotas, "F2_ZZNFREF"		,							, "Nota Fiscal Ref."	, 	nil									, TamSX3("F2_ZZNFREF")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_ZZSEREF"		,							, "Série NF Ref."		, 	nil									, TamSX3("F2_ZZSEREF")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_ZZDTERE"		,							, "Data de emis. Ref."	, 	nil									, TamSX3("F2_ZZDTERE")[1]	,,,,,"RIGHT")
	
	if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2 .or. cFilAnt == AGL_LOTE_005
		If cFilAnt == AGL_LOTE_005
			TRCell():new(oSecNotas, "CFOP"			, 						, "CFOP"				, 	nil									, 5							,,,,,"RIGHT") //Emerson Holanda 29/08/23
		EndIf
		TRCell():new(oSecNotas, "NF_VENDA"			,						, "NF Venda"				, 	nil										, TamSX3("ZA_DOCSCJ")[1]		,,,,,"RIGHT")
		TRCell():new(oSecNotas, "SERIE_NF_VENDA"	,						, "Série NF Venda"		, 	nil										, TamSX3("ZA_SERISCJ")[1]	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "QTD_PECAS_NF_VENDA",						, "Qtd. Peças NF Venda"	, 	PesqPict("SZB", "ZB_QUANTIT")		, TamSX3("ZB_QUANTIT")[1]	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "DT_EMI_NF_VENDA"	,						, "Dt. Emissão NF Venda"	, 	nil										, TamSX3("ZA_DTEMSCJ")[1]	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "VLR_TOT_NF_VENDA",						, "Vlr. Total NF Venda"	, 	PesqPict("SZA", "ZA_TOTVALU")		, TamSX3("ZA_TOTVALU")[1]	,,,,,"RIGHT")
		
		TRCell():new(oSecNotas, "NF_RCO"			,						, "NF RCO"					, 	nil										, TamSX3("ZA_NFRCO")[1]		,,,,,"RIGHT")
		TRCell():new(oSecNotas, "SERIE_NF_RCO"		,						, "Série NF RCO"			, 	nil										, TamSX3("ZA_SERIRCO")[1]	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "QTD_PECAS_NF_RCO",						, "Qtd. Peças NF RCO"	, 	PesqPict("SD2", "D2_QUANT")			, TamSX3("D2_QUANT")[1]		,,,,,"RIGHT")
		TRCell():new(oSecNotas, "DT_EMI_NF_RCO"	,						, "Dt. Emissão NF RCO"	, 	nil										, TamSX3("F2_EMISSAO")[1]	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "VLR_TOT_NF_RCO"	,						, "Vlr. Total NF RCO"	, 	PesqPict("SF2", "F2_VALBRUT")		, TamSX3("F2_VALBRUT")[1]	,,,,,"RIGHT")
		
		TRCell():new(oSecNotas, "NF_RET"			,						, "NF RET"					, 	nil										, TamSX3("ZA_NFRET")[1]		,,,,,"RIGHT")
		TRCell():new(oSecNotas, "SERIE_NF_RET"		,						, "Série NF RET"			, 	nil										, TamSX3("ZA_SERIRET")[1]	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "QTD_PECAS_NF_RET",						, "Qtd. Peças NF RET"	, 	PesqPict("SD2", "D2_QUANT")			, TamSX3("D2_QUANT")[1]		,,,,,"RIGHT")
		TRCell():new(oSecNotas, "DT_EMI_NF_RET"	,						, "Dt. Emissão NF RET"	,	nil										, TamSX3("F2_EMISSAO")[1]	,,,,,"RIGHT")
		TRCell():new(oSecNotas, "VLR_TOT_NF_RET"	,						, "Vlr. Total NF RET"	, 	PesqPict("SF2", "F2_VALBRUT")		, TamSX3("F2_VALBRUT")[1]	,,,,,"RIGHT")
					
	endif 
	
	TRCell():new(oSecNotas, "QTD_LINHAS"		,							, "Qtd. SKU/Linhas"		, 	nil									, 4							,,,,,"RIGHT")
	TRCell():new(oSecNotas, "QTD_PECAS"			,							, "Qtd. Peças"			, 	PesqPict("SD2", "D2_QUANT")			, TamSX3("D1_QUANT")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_ZZCTEAW"		,							, "Ctrc/Awb"			, 	PesqPict("SF2", "F2_ZZCTEAW")		, TamSX3("F2_ZZCTEAW")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "C5_EMISSAO"		,							, "Dt. Pedido"			, 	nil									, TamSX3("C5_EMISSAO")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_EMISSAO"		,							, "Data Emissão"		, 	nil									, TamSX3("F2_EMISSAO")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_HORNFE"			,							, "Hora Emissão"		, 	nil									, TamSX3("F2_HORNFE")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_USERLGI"		,							, "Recebido por"		, 	nil									, 20						,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_BASEIPI"		,							, "Base IPI"			, 	PesqPict("SF2", "F2_BASEIPI")		, TamSX3("F2_BASEIPI")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_BASEICM"		,							, "Base ICMS"			, 	PesqPict("SF2", "F2_BASEICM")		, TamSX3("F2_BASEICM")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_BRICMS"			,							, "Base ST"				, 	PesqPict("SF2", "F2_BRICMS")		, TamSX3("F2_BRICMS")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_VALIPI"			,							, "Valor IPI"			, 	PesqPict("SF2", "F2_VALIPI")		, TamSX3("F2_VALIPI")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_VALICM"			,							, "Valor ICMS"			, 	PesqPict("SF2", "F2_VALICM")		, TamSX3("F2_VALICM")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_ICMSRET"		,							, "Valor ST"			, 	PesqPict("SF2", "F2_ICMSRET")		, TamSX3("F2_ICMSRET")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_VALMERC"		,							, "Valor Mercadoria"	, 	PesqPict("SF2", "F2_VALMERC")		, TamSX3("F2_VALMERC")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_VALBRUT"		,							, "Valor Total"			, 	PesqPict("SF2", "F2_VALBRUT")		, TamSX3("F2_VALBRUT")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_FIMP"			,							, "Status"				, 	nil									, TamSX3("F2_FIMP")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F2_CHVNFE"			,							, "Chave NFe"			, 	PesqPict("SF2", "F2_CHVNFE")		, TamSX3("F2_CHVNFE")[1]	,,,,,"RIGHT")
		
return


/**
* Processamento da Impressão
*/
static function procImpressao()
	local cQuery		:= ""
	local aFilEmp		:= FWArrFilAtu(cEmpAnt, cFilAnt)
	local cNomeFil	:= aFilEmp[SM0_NOME]
	local cDescEmp	:= aFilEmp[SM0_NOMECOM]
	local cUnidNeg	:= aFilEmp[SM0_DESCUN]
	local cCnpj		:= Transform(aFilEmp[SM0_CGC], "@R 99.999.999/9999-99")
	local oLibDHL		:= DHLLibrary():newDHLLibrary()
	local cCriadoPor	:= ""
	local cStatus		:= ""
	local lDeleted		:= .T.
	local aAux := {}
	
	oSecNotas:cAlias	:= oSqlNotas:getAlias()
	oReport:startPage()
	oSecNotas:init()
	oSqlNotas:setField("F2_EMISSAO", "D")
	oSqlNotas:setField("C5_EMISSAO", "D")
	oSqlNotas:setField("F2_ZZDTERE", "D")
	
	oReport:SetMeter(oSqlNotas:count())

	while oSqlNotas:notIsEof()
		lDeleted	:= oSqlNotas:getValue("REG_DEL") == "*"//(oSqlNotas:getAlias())->(Deleted())
		oReport:IncMeter()
		retInfCliForn(oSqlNotas:getValue("F2_CLIENTE"), oSqlNotas:getValue("F2_LOJA"), oSqlNotas:getValue("F2_TIPO"))
		
		oSecNotas:Cell("FILIAL_CLIENTE"):setValue(cNomeFil)
		oSecNotas:Cell("SITE"):setValue(cUnidNeg)
		
		oSecNotas:Cell("RAZAO_DESTINAT"):setValue(cNomeRemet)
		oSecNotas:Cell("CNPJ_DESTINAT"):setValue(cCnpjRemet)
		
		oSecNotas:Cell("RAZAO_REMETENT"):setValue(cDescEmp)
		oSecNotas:Cell("CNPJ_REMETENT"):setValue(cCnpj)
		
		cCriadoPor	:= retFullName(oLibDHL:getLGUser(oSqlNotas:getValue("F2_USERLGI")))
		oSecNotas:Cell("F2_USERLGI"):setValue(cCriadoPor)
		
		cStatus	:= retNotaStatus(Alltrim(oSqlNotas:getValue("F2_FIMP")),Alltrim(oSqlNotas:getValue("F2_ESPECIE")),Alltrim(oSqlNotas:getValue("F2_DOC")),Alltrim(oSqlNotas:getValue("F2_SERIE")),lDeleted )
		oSecNotas:Cell("F2_FIMP"):setValue(cStatus)
		
		if FwUnitBusiness() == DHL_BUSINESSUNIT_AG2 
			
			aAux := getNFsRef(oSqlNotas,"1") //NF Venda
			oSecNotas:Cell("NF_VENDA"):setValue(aAux[1])
			oSecNotas:Cell("SERIE_NF_VENDA"):setValue(aAux[2])
			oSecNotas:Cell("DT_EMI_NF_VENDA"):setValue(aAux[3])
			oSecNotas:Cell("VLR_TOT_NF_VENDA"):setValue(aAux[4])
			oSecNotas:Cell("QTD_PECAS_NF_VENDA"):setValue(aAux[5])
		
			aAux := getNFsRef(oSqlNotas,"2") //NF RCO
			oSecNotas:Cell("NF_RCO"):setValue(aAux[1])
			oSecNotas:Cell("SERIE_NF_RCO"):setValue(aAux[2])
			oSecNotas:Cell("DT_EMI_NF_RCO"):setValue(aAux[3])
			oSecNotas:Cell("VLR_TOT_NF_RCO"):setValue(aAux[4])
			oSecNotas:Cell("QTD_PECAS_NF_RCO"):setValue(aAux[5])
		
			aAux := getNFsRef(oSqlNotas,"3") //NF RET
			oSecNotas:Cell("NF_RET"):setValue(aAux[1])
			oSecNotas:Cell("SERIE_NF_RET"):setValue(aAux[2])
			oSecNotas:Cell("DT_EMI_NF_RET"):setValue(aAux[3])
			oSecNotas:Cell("VLR_TOT_NF_RET"):setValue(aAux[4])
			oSecNotas:Cell("QTD_PECAS_NF_RET"):setValue(aAux[5])
		elseif cFilAnt == AGL_LOTE_005
			aAux := getNFsRef2(oSqlNotas,"1") //NF Venda
			oSecNotas:Cell("CFOP"):setValue(retCfop(oSqlNotas)) //Emerson Holanda 29/08/23
			oSecNotas:Cell("NF_VENDA"):setValue(aAux[1])
			oSecNotas:Cell("SERIE_NF_VENDA"):setValue(aAux[2])
			oSecNotas:Cell("DT_EMI_NF_VENDA"):setValue(aAux[3])
			oSecNotas:Cell("VLR_TOT_NF_VENDA"):setValue(aAux[4])
			oSecNotas:Cell("QTD_PECAS_NF_VENDA"):setValue(aAux[5])
		
			aAux := getNFsRef2(oSqlNotas,"2") //NF RCO
			oSecNotas:Cell("NF_RCO"):setValue(aAux[1])
			oSecNotas:Cell("SERIE_NF_RCO"):setValue(aAux[2])
			oSecNotas:Cell("DT_EMI_NF_RCO"):setValue(aAux[3])
			oSecNotas:Cell("VLR_TOT_NF_RCO"):setValue(aAux[4])
			oSecNotas:Cell("QTD_PECAS_NF_RCO"):setValue(aAux[5])
		
			aAux := getNFsRef2(oSqlNotas,"3") //NF RET
			oSecNotas:Cell("NF_RET"):setValue(aAux[1])
			oSecNotas:Cell("SERIE_NF_RET"):setValue(aAux[2])
			oSecNotas:Cell("DT_EMI_NF_RET"):setValue(aAux[3])
			oSecNotas:Cell("VLR_TOT_NF_RET"):setValue(aAux[4])
			oSecNotas:Cell("QTD_PECAS_NF_RET"):setValue(aAux[5])
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
	cQuery	+= "	SF2.D_E_L_E_T_ REG_DEL, " +CRLF
	cQuery	+= "	SF2.F2_FILIAL, " +CRLF
	cQuery	+= "	SF2.F2_CLIENTE, " +CRLF
	cQuery	+= "	SF2.F2_LOJA, " +CRLF
	cQuery	+= "	SF2.F2_EST, " +CRLF
	cQuery	+= "	SF2.F2_DOC, " +CRLF
	cQuery	+= "	SF2.F2_SERIE, " +CRLF
	
	cQuery	+= "	SF2.F2_ZZNFREF, " +CRLF
	cQuery	+= "	SF2.F2_ZZSEREF, " +CRLF
	cQuery	+= "	SF2.F2_ZZDTERE, " +CRLF
	
	cQuery	+= "	SUM(SD2.D2_QUANT) QTD_PECAS, " +CRLF
	cQuery	+= "	COUNT(SD2.D2_ITEM) QTD_LINHAS, " +CRLF
	cQuery	+= "	SC5.C5_EMISSAO, " +CRLF
	cQuery	+= "	SF2.F2_ZZCTEAW, " +CRLF
	cQuery	+= "	SF2.F2_EMISSAO, " +CRLF
	cQuery	+= "	SF2.F2_HORNFE, " +CRLF
	cQuery	+= "	SF2.F2_BASEIPI, " +CRLF
	cQuery	+= "	SF2.F2_BASEICM, " +CRLF
	cQuery	+= "	SF2.F2_BRICMS, " +CRLF
	cQuery	+= "	SF2.F2_VALIPI, " +CRLF
	cQuery	+= "	SF2.F2_VALICM, " +CRLF
	cQuery	+= "	SF2.F2_ICMSRET, " +CRLF
	cQuery	+= "	SF2.F2_VALMERC, " +CRLF
	cQuery	+= "	SF2.F2_VALBRUT, " +CRLF
	cQuery	+= "	SF2.F2_FIMP," +CRLF
	cQuery	+= "	SF2.F2_CHVNFE, " +CRLF	
	cQuery	+= "	SF2.F2_USERLGI, " +CRLF
	cQuery	+= "	SF2.F2_FORMUL, " +CRLF
	cQuery	+= "	SF2.F2_TIPO, " +CRLF
	cQuery	+= "	SF2.F2_ESPECIE, " +CRLF
	cQuery	+= "	SF2.F2_ZZTPNF " +CRLF
	cQuery	+= "FROM " +CRLF
	cQuery	+= "	%SF2.SQLNAME% " +CRLF
	cQuery	+= "INNER JOIN %SD2.SQLNAME% ON " +CRLF
	cQuery 	+= " 	SD2.D2_FILIAL = SF2.F2_FILIAL" + CRLF
	cQuery	+= "	AND SD2.D2_DOC = SF2.F2_DOC " +CRLF
	cQuery	+= "	AND SD2.D2_SERIE = SF2.F2_SERIE " +CRLF
	cQuery	+= "	AND SD2.D2_CLIENTE = SF2.F2_CLIENTE " +CRLF
	cQuery	+= "	AND SD2.D2_LOJA = SF2.F2_LOJA" +CRLF
	if cStatus $ "S"
		cQuery	+= " AND %SD2.NOTDEL% " +CRLF
	endif
	cQuery 	+= " LEFT JOIN %SC6.SQLNAME% ON                   " +CRLF
	cQuery 	+= " 	SC6.C6_FILIAL = SD2.D2_FILIAL          " +CRLF
	if !(cStatus $ "TD")
		cQuery 	+= " 	AND %SC6.NOTDEL%                " +CRLF
	endif
	cQuery 	+= " 	AND SC6.C6_NUM 	= SD2.D2_PEDIDO        " +CRLF
	cQuery 	+= " 	AND SC6.C6_ITEM = SD2.D2_ITEMPV        " +CRLF
	cQuery 	+= " 	AND SC6.D_E_L_E_T_ =  CASE WHEN SF2.D_E_L_E_T_ = '*' THEN '*' ELSE ' ' END " +CRLF
	cQuery 	+= " LEFT JOIN %SC5.SQLNAME% ON                   " +CRLF
	cQuery 	+= " 	SC5.C5_FILIAL = SC6.C6_FILIAL          " +CRLF
	if !(cStatus $ "TD")
		cQuery 	+= " 	AND %SC5.NOTDEL%               " +CRLF
	endif
	cQuery 	+= " 	AND SC5.C5_NUM = SC6.C6_NUM            " +CRLF
	cQuery 	+= " 	AND SC5.C5_EMISSAO >= '"+dtos(dDtPedDe)+"'       " +CRLF
	cQuery 	+= " 	AND SC5.C5_EMISSAO <= '"+dtos(dDtPedAte)+"'       " +CRLF
	cQuery 	+= " 	AND SC5.D_E_L_E_T_ =  CASE WHEN SF2.D_E_L_E_T_ = '*' THEN '*' ELSE ' ' END " +CRLF
	cQuery 	+= " WHERE " +CRLF
	cQuery 	+= " 	SF2.F2_FILIAL = '%SF2.FILIAL%' " + CRLF
	cQuery	+= "	AND SF2.F2_DOC >= '"+cNotaDe+"' " + CRLF
	cQuery	+= "	AND SF2.F2_DOC <= '"+cNotaAte+"' " + CRLF
	cQuery	+= "	AND SF2.F2_SERIE >= '"+cSerieDe+"' " + CRLF
	cQuery	+= "	AND SF2.F2_SERIE <= '"+cSerieAte+"' " + CRLF
	cQuery	+= "	AND SF2.F2_CLIENTE >= '"+cClientDe+"' " + CRLF
	cQuery	+= "	AND SF2.F2_CLIENTE <= '"+cClientAte +"' " +CRLF
	cQuery	+= "	AND SF2.F2_LOJA >= '"+cLojaDe+"' " + CRLF
	cQuery	+= "	AND SF2.F2_LOJA <= '"+cLojaAte+"' " + CRLF
	cQuery	+= "	AND SF2.F2_EMISSAO >= '"+dtos(dDtEmisDe)+"' " + CRLF
	cQuery	+= "	AND SF2.F2_EMISSAO <= '"+dtos(dDtEmisAte)+"' " + CRLF
	cQuery	+= "	AND SF2.F2_EST >= '"+cUfDe+"' " + CRLF
	cQuery	+= "	AND SF2.F2_EST <= '"+cUfAte+"' " + CRLF
	
	if cStatus	<> "TD"
		if cStatus == "Não Transmitida"
			cStatus	:= Space(TamSx3("F2_FIMP")[1])
		endIf
		cQuery	+= "	AND SF2.F2_FIMP = '"+cStatus+"' " + CRLF
	endIf
		
	cQuery	+= "GROUP BY" +CRLF
	cQuery	+= "	SF2.F2_FILIAL," +CRLF
	cQuery	+= "	SF2.F2_CLIENTE," +CRLF
	cQuery	+= "	SF2.F2_LOJA," +CRLF
	cQuery	+= "	SF2.F2_EST," +CRLF
	cQuery	+= "	SF2.F2_DOC, " +CRLF
	cQuery	+= "	SF2.F2_SERIE, " +CRLF	
	cQuery	+= "	SF2.F2_ZZNFREF, " +CRLF
	cQuery	+= "	SF2.F2_ZZSEREF, " +CRLF
	cQuery	+= "	SF2.F2_ZZDTERE, " +CRLF	
	cQuery	+= "	SF2.F2_ZZCTEAW," +CRLF
	cQuery	+= "	SC5.C5_EMISSAO," +CRLF
	cQuery	+= "	SF2.F2_EMISSAO," +CRLF
	cQuery	+= "	SF2.F2_HORNFE," +CRLF
	cQuery	+= "	SF2.F2_USERLGI," +CRLF
	cQuery	+= "	SF2.F2_BASEIPI," +CRLF
	cQuery	+= "	SF2.F2_BASEICM," +CRLF
	cQuery	+= "	SF2.F2_BRICMS," +CRLF
	cQuery	+= "	SF2.F2_VALIPI," +CRLF
	cQuery	+= "	SF2.F2_VALICM," +CRLF
	cQuery	+= "	SF2.F2_ICMSRET," +CRLF
	cQuery	+= "	SF2.F2_VALMERC," +CRLF
	cQuery	+= "	SF2.F2_VALBRUT," +CRLF
	cQuery	+= "	SF2.F2_FIMP," +CRLF
	cQuery	+= "	SF2.F2_CHVNFE," +CRLF
	cQuery	+= "	SF2.F2_FORMUL, " +CRLF
	cQuery	+= "	SF2.F2_TIPO, " +CRLF
	cQuery	+= "	SF2.F2_ESPECIE," +CRLF
	cQuery	+= "	SF2.F2_ZZTPNF, " +CRLF
	cQuery	+= "	SF2.D_E_L_E_T_" +CRLF

	cQuery	+= "ORDER BY" +CRLF
	
	if nIndice == 1	
		cQuery	+= "F2_FILIAL, F2_DOC, F2_SERIE, F2_EMISSAO, F2_HORNFE " +CRLF		
	elseif nIndice == 2
		cQuery	+= "F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE " +CRLF
	else
		cQuery	+= "F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO " +CRLF
	endIf
	
	oSqlNotas	:= IpSqlObject():newIpSqlObject()
	oSqlNotas:newAlias(cQuery)
return

/*
*	Função responsável pelo retorno da descrição do status da nota
*/
static function retNotaStatus(cCodStat,cEspecie, cNota, cSerie, lDeleted)
	local cTitulo	:= ""
	local lInut		:= existInut(cNota, cSerie)
	
	Do Case
	
	Case lInut
		cTitulo	:= "NF Inutilizada"
	Case lDeleted
		cTitulo	:= "NF Cancelada"
	Case cCodStat	== "S"
		cTitulo	:= "NF Autorizada"
	Case cCodStat	== "T"
		cTitulo	:= "NF Transmitida"
	Case cCodStat	== "D"
		cTitulo	:= "NF Uso Denegado"
	Case cCodStat	== "N"
		cTitulo	:= "NF Não Autorizada"
	Case cCodStat	== "C"
		cTitulo	:= "NF Em Cancelamento"
	Case cCodStat	== "X"
		cTitulo	:= "Cancelamento não Autorizado"
	Case Empty(cCodStat)	//.AND. Alltrim(cEspecie) == "SPED"
		cTitulo	:= "NF Não Transmitida"
	OtherWise
		cTitulo	:= ""
	End Case
	
return cTitulo


/*
*	Função responsável pelo retorno do nome e cnpj do remetente
*/
static function retInfCliForn(cCod, cLoja, cTipoNota)
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	
	if !cTipoNota $ "DB"
		oSqlUtil:newTable("SA1", "A1_NOME, A1_CGC, A1_PESSOA", "A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '"+cCod+"' AND A1_LOJA = '"+cLoja+"'")
		cNomeRemet	:= oSqlUtil:getValue("A1_NOME")
		cCnpjRemet	:= oSqlUtil:getValue("A1_CGC")
		cCliTipo	:= oSqlUtil:getValue("A1_PESSOA")
	else
		oSqlUtil:newTable("SA2", "A2_NOME, A2_CGC, A2_TIPO", "A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = '"+cCod+"' AND A2_LOJA = '"+cLoja+"'")
		cNomeRemet	:= oSqlUtil:getValue("A2_NOME")
		cCnpjRemet	:= oSqlUtil:getValue("A2_CGC")
		cCliTipo	:= oSqlUtil:getValue("A2_TIPO")
	endIf
	cCnpjRemet	:= Transform(cCnpjRemet,Substr(PicPes(cCliTipo),1,at("%",PicPes(cCliTipo))-1))
	oSqlUtil:close()
return


/*
*	Função responsável pela criação do indice.
*/
static function criaIndice()
	local aOrdem	:= {}
	
	aADD(aOrdem, "Número NF + Série + Emissão + Hora")
	aADD(aOrdem, "Número NF + Serie + Cli + Loja + Formulario Proprio + Tipo da Nota")
	aADD(aOrdem, "Cliente + Loja + Número NF + Série")	
return aOrdem


/**
*	Verifica se a nota foi inutilizada
**/
static function existInut(cNota, cSerie)
	local aArea	:= getArea()
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local lExists	:= oSqlUtil:exists("SZ5", "Z5_FILIAL = '%SZ5.FILIAL%' AND Z5_DOC = '"+cNota+"' AND Z5_SERIE = '"+cSerie+"' AND Z5_STATUS = '2' ")
	
	restArea(aArea)
	oSqlUtil:close()
		
return lExists

/*
** Retorna as informações das notas fiscais referenciadas
*/
static function getNFsRef(oSqlNotas,cTpQry)
	
	local oSql 	:= IpSqlObject():newIpSqlObject()
	local oSqlAux	:= IpSqlObject():newIpSqlObject()
	local aRet		:= {"","",CtoD("  /  /  "),0,0} 
	local cQuery	:= ""
	
	if cTpQry == "1" //NF Venda
	
		if (oSqlNotas:getValue("F2_ZZTPNF") == RETORNO_SIMBOLICO) .OR. (oSqlNotas:getValue("F2_ZZTPNF") == REMESSA_CONTA_ORDEM)
		
			cQuery := " SELECT ZA_DOCSCJ, ZA_SERISCJ, ZA_DTEMSCJ, ZA_TOTVALU, "		+CRLF
			cQuery	+= " SUM(ZB_QUANTIT) QTD_PECAS " +CRLF
			
			cQuery += " FROM %SZA.SQLNAME% " 											+CRLF
			
			cQuery += " INNER JOIN %SZB.SQLNAME% ON " +CRLF
			cQuery += " 	1=1 " +CRLF 
			cQuery += " 	AND ZB_FILIAL 	= ZA_FILIAL " +CRLF
			cQuery += " 	AND ZB_KENFSCJ	= ZA_KENFSCJ " +CRLF
			cQuery += " 	AND %SZB.NOTDEL% " +CRLF
		
			cQuery += " WHERE  " 														+CRLF
			if oSqlNotas:getValue("F2_ZZTPNF") == REMESSA_CONTA_ORDEM 
					cQuery += "	ZA_NFRCO = '" + oSqlNotas:getValue("F2_DOC") + "' AND" 			+CRLF
					cQuery += "	ZA_SERIRCO = '" + oSqlNotas:getValue("F2_SERIE") + "' AND" 		+CRLF
			else
					cQuery += "	ZA_NFRET = '" + oSqlNotas:getValue("F2_DOC") + "' AND"			+CRLF
					cQuery += "	ZA_SERIRET = '" + oSqlNotas:getValue("F2_SERIE") + "' AND"		+CRLF
			endif	
			cQuery += " 	%SZA.XFILIAL% AND "											+ CRLF
			cQuery += " 	%SZA.NOTDEL%"           										+CRLF
			
			cQuery	+= " GROUP BY" +CRLF
			cQuery	+= "	ZA_DOCSCJ," +CRLF
			cQuery	+= "	ZA_SERISCJ," +CRLF
			cQuery	+= "	ZA_DTEMSCJ," +CRLF
			cQuery	+= "	ZA_TOTVALU" +CRLF
				
			oSql:newAlias(cQuery)	
			oSql:setField("ZA_DTEMSCJ", "D")
				
			if oSql:hasRecords()
				aRet[1] := oSql:getValue("ZA_DOCSCJ")
				aRet[2] := oSql:getValue("ZA_SERISCJ")
				aRet[3] := oSql:getValue("ZA_DTEMSCJ")
				aRet[4] := oSql:getValue("ZA_TOTVALU")
				aRet[5] := oSql:getValue("QTD_PECAS")
			endif
			
			oSql:close()	
		
		endif	
	
	elseif cTpQry == "2" //NF RCO
			
		if oSqlNotas:getValue("F2_ZZTPNF") == RETORNO_SIMBOLICO
		
			cQuery := " SELECT ZA_NFRCO, ZA_SERIRCO "										+CRLF
			cQuery += " FROM %SZA.SQLNAME% " 												+CRLF
			cQuery += " WHERE  " 															+CRLF
			cQuery += "	ZA_NFRET = '" + oSqlNotas:getValue("F2_DOC") + "' AND"		+CRLF
			cQuery += "	ZA_SERIRET = '" + oSqlNotas:getValue("F2_SERIE") + "' AND"	+CRLF
			cQuery += " 	%SZA.XFILIAL% AND "												+CRLF
			cQuery += " 	%SZA.NOTDEL%"           											+CRLF
		
			oSql:newAlias(cQuery)	
				
			if oSql:hasRecords()
				
				cQuery := " SELECT F2_EMISSAO, F2_VALBRUT, SUM(D2_QUANT) QTD_PECAS "	+CRLF
				cQuery += " FROM %SF2.SQLNAME% " 											+CRLF
				
				cQuery	+= " INNER JOIN %SD2.SQLNAME% ON " 								+CRLF
				cQuery += " 	1=1 " 															+CRLF 
				cQuery += "	AND D2_FILIAL = F2_FILIAL" 									+CRLF
				cQuery	+= "	AND D2_DOC = F2_DOC " 										+CRLF
				cQuery	+= "	AND D2_SERIE = F2_SERIE " 									+CRLF
				cQuery	+= "	AND D2_CLIENTE = F2_CLIENTE " 								+CRLF
				cQuery	+= "	AND D2_LOJA = F2_LOJA" 										+CRLF
				cQuery	+= " 	AND %SD2.NOTDEL% " 											+CRLF
				
				cQuery += " WHERE  " 														+CRLF
				cQuery += " 	1=1 " 															+CRLF 
				cQuery += "	AND F2_DOC = '" + oSql:getValue("ZA_NFRCO") + "' "		+CRLF
				cQuery += "	AND F2_SERIE = '" + oSql:getValue("ZA_SERIRCO") + "' "	+CRLF
				cQuery += " 	AND %SF2.XFILIAL% "											+CRLF
				cQuery += " 	AND %SF2.NOTDEL%"           								+CRLF
				
				cQuery	+= " GROUP BY" 														+CRLF
				cQuery	+= "	F2_EMISSAO, " 												+CRLF
				cQuery	+= "	F2_VALBRUT " 													+CRLF
				
				oSqlAux:newAlias(cQuery)
				
				oSqlAux:setField("F2_EMISSAO", "D")
				if oSqlAux:hasRecords()
					aRet[1] := oSql:getValue("ZA_NFRCO")
					aRet[2] := oSql:getValue("ZA_SERIRCO")
					aRet[3] := oSqlAux:getValue("F2_EMISSAO")
					aRet[4] := oSqlAux:getValue("F2_VALBRUT")
					aRet[5] := oSqlAux:getValue("QTD_PECAS")
				endif
			
				oSqlAux:close()
			endif
			
			oSql:close()
		
		endif		
	
	elseif cTpQry == "3" //NF RET
			
		if oSqlNotas:getValue("F2_ZZTPNF") == REMESSA_CONTA_ORDEM
		
			cQuery := " SELECT ZA_NFRET, ZA_SERIRET "										+CRLF
			cQuery += " FROM %SZA.SQLNAME% " 												+CRLF
			cQuery += " WHERE  " 															+CRLF
			cQuery += "	ZA_NFRCO = '" + oSqlNotas:getValue("F2_DOC") + "' AND"		+CRLF
			cQuery += "	ZA_SERIRCO = '" + oSqlNotas:getValue("F2_SERIE") + "' AND"	+CRLF
			cQuery += " 	%SZA.XFILIAL% AND "												+CRLF
			cQuery += " 	%SZA.NOTDEL%"           											+CRLF
		
			oSql:newAlias(cQuery)	
				
			if oSql:hasRecords()
				
				cQuery := " SELECT F2_EMISSAO, F2_VALBRUT, SUM(D2_QUANT) QTD_PECAS "	+CRLF
				cQuery += " FROM %SF2.SQLNAME% " 											+CRLF
				
				cQuery	+= " INNER JOIN %SD2.SQLNAME% ON " 								+CRLF
				cQuery += " 	1=1 " 															+CRLF 
				cQuery += "	AND D2_FILIAL = F2_FILIAL" 									+CRLF
				cQuery	+= "	AND D2_DOC = F2_DOC " 										+CRLF
				cQuery	+= "	AND D2_SERIE = F2_SERIE " 									+CRLF
				cQuery	+= "	AND D2_CLIENTE = F2_CLIENTE " 								+CRLF
				cQuery	+= "	AND D2_LOJA = F2_LOJA" 										+CRLF
				cQuery	+= " 	AND %SD2.NOTDEL% " 											+CRLF
				
				cQuery += " WHERE  " 														+CRLF
				cQuery += " 	1=1 " 															+CRLF 
				cQuery += "	AND F2_DOC = '" + oSql:getValue("ZA_NFRET") + "' "		+CRLF
				cQuery += "	AND F2_SERIE = '" + oSql:getValue("ZA_SERIRET") + "' "	+CRLF
				cQuery += " 	AND %SF2.XFILIAL% "											+CRLF
				cQuery += " 	AND %SF2.NOTDEL%"           								+CRLF
				
				cQuery	+= " GROUP BY" 														+CRLF
				cQuery	+= "	F2_EMISSAO, " 												+CRLF
				cQuery	+= "	F2_VALBRUT " 													+CRLF
				
				oSqlAux:newAlias(cQuery)	
				
				oSqlAux:setField("F2_EMISSAO", "D")
				if oSqlAux:hasRecords()
					aRet[1] := oSql:getValue("ZA_NFRET")
					aRet[2] := oSql:getValue("ZA_SERIRET")
					aRet[3] := oSqlAux:getValue("F2_EMISSAO")
					aRet[4] := oSqlAux:getValue("F2_VALBRUT")
					aRet[5] := oSqlAux:getValue("QTD_PECAS")
				endif
			
				oSqlAux:close()
			endif
			
			oSql:close()
		
		endif
	
	endif
	
return (aRet)

/*
** Retorna as informações das notas fiscais referenciadas
*/
static function getNFsRef2(oSqlNotas,cTpQry)
	
	local oSql 	:= IpSqlObject():newIpSqlObject()
	local oSqlAux	:= IpSqlObject():newIpSqlObject()
	local aRet		:= {"","",CtoD("  /  /  "),0,0} 
	local cQuery	:= ""
	
	if cTpQry == "1" //NF Venda
	
		if (oSqlNotas:getValue("F2_ZZTPNF") == RETORNO_SIMBOLICO) .OR. (oSqlNotas:getValue("F2_ZZTPNF") == REMESSA_CONTA_ORDEM)
		
			cQuery := " SELECT Z8_DOC, Z8_SERIE, Z8_EMISSAO, SUM(Z9_TOTAL) TOTAL, "		+CRLF
			cQuery	+= " SUM(Z9_QUANT) QTD_PECAS " +CRLF
			
			cQuery += " FROM %SZ8.SQLNAME% " 											+CRLF
			
			cQuery += " INNER JOIN %SZ9.SQLNAME% ON " +CRLF
			cQuery += " 	1=1 " +CRLF 
			cQuery += " 	AND Z9_FILIAL 	= Z8_FILIAL " +CRLF
			cQuery += " 	AND Z9_DOC		= Z8_DOC " +CRLF
			cQuery += " 	AND Z9_SERIE	= Z8_SERIE " +CRLF
			cQuery += " 	AND Z9_CLIENTE	= Z8_CLIENTE " +CRLF
			cQuery += " 	AND Z9_LOJA		= Z8_LOJA " +CRLF
			cQuery += " 	AND %SZ9.NOTDEL% " +CRLF
		
			cQuery += " WHERE  " 														+CRLF
			if oSqlNotas:getValue("F2_ZZTPNF") == REMESSA_CONTA_ORDEM 
					cQuery += "	Z8_NFRCO = '" + oSqlNotas:getValue("F2_DOC") + "' AND" 			+CRLF
					cQuery += "	Z8_SERRCO = '" + oSqlNotas:getValue("F2_SERIE") + "' AND" 		+CRLF
			else
					cQuery += "	Z8_NFRET = '" + oSqlNotas:getValue("F2_DOC") + "' AND"			+CRLF
					cQuery += "	Z8_SERRET = '" + oSqlNotas:getValue("F2_SERIE") + "' AND"		+CRLF
			endif	
			cQuery += " 	%SZ8.XFILIAL% AND "											+ CRLF
			cQuery += " 	%SZ8.NOTDEL%"           										+CRLF
			
			cQuery	+= " GROUP BY" +CRLF
			cQuery	+= "	Z8_DOC," +CRLF
			cQuery	+= "	Z8_SERIE," +CRLF
			cQuery	+= "	Z8_EMISSAO " +CRLF
				
			oSql:newAlias(cQuery)	
			oSql:setField("Z8_EMISSAO", "D")
				
			if oSql:hasRecords()
				aRet[1] := oSql:getValue("Z8_DOC")
				aRet[2] := oSql:getValue("Z8_SERIE")
				aRet[3] := oSql:getValue("Z8_EMISSAO")
				aRet[4] := oSql:getValue("TOTAL")
				aRet[5] := oSql:getValue("QTD_PECAS")
			endif
			
			oSql:close()	
		
		endif	
	
	elseif cTpQry == "2" //NF RCO
			
		if oSqlNotas:getValue("F2_ZZTPNF") == RETORNO_SIMBOLICO
		
			cQuery := " SELECT Z8_NFRCO, Z8_SERRCO "										+CRLF
			cQuery += " FROM %SZ8.SQLNAME% " 												+CRLF
			cQuery += " WHERE  " 															+CRLF
			cQuery += "	Z8_NFRET = '" + oSqlNotas:getValue("F2_DOC") + "' AND"				+CRLF
			cQuery += "	Z8_SERRET = '" + oSqlNotas:getValue("F2_SERIE") + "' AND"			+CRLF
			cQuery += " 	%SZ8.XFILIAL% AND "												+CRLF
			cQuery += " 	%SZ8.NOTDEL%"           										+CRLF
		
			oSql:newAlias(cQuery)	
				
			if oSql:hasRecords()
				
				cQuery := " SELECT F2_EMISSAO, F2_VALBRUT, SUM(D2_QUANT) QTD_PECAS "		+CRLF
				cQuery += " FROM %SF2.SQLNAME% " 											+CRLF
				
				cQuery	+= " INNER JOIN %SD2.SQLNAME% ON " 									+CRLF
				cQuery += " 	1=1 " 														+CRLF 
				cQuery += "	AND D2_FILIAL = F2_FILIAL" 										+CRLF
				cQuery	+= "	AND D2_DOC = F2_DOC " 										+CRLF
				cQuery	+= "	AND D2_SERIE = F2_SERIE " 									+CRLF
				cQuery	+= "	AND D2_CLIENTE = F2_CLIENTE " 								+CRLF
				cQuery	+= "	AND D2_LOJA = F2_LOJA" 										+CRLF
				cQuery	+= " 	AND %SD2.NOTDEL% " 											+CRLF
				
				cQuery += " WHERE  " 														+CRLF
				cQuery += " 	1=1 " 														+CRLF 
				cQuery += "	AND F2_DOC = '" + oSql:getValue("Z8_NFRCO") + "' "				+CRLF
				cQuery += "	AND F2_SERIE = '" + oSql:getValue("Z8_SERRCO") + "' "			+CRLF
				cQuery += " 	AND %SF2.XFILIAL% "											+CRLF
				cQuery += " 	AND %SF2.NOTDEL%"           								+CRLF
				
				cQuery	+= " GROUP BY" 														+CRLF
				cQuery	+= "	F2_EMISSAO, " 												+CRLF
				cQuery	+= "	F2_VALBRUT " 												+CRLF
				
				oSqlAux:newAlias(cQuery)
				
				oSqlAux:setField("F2_EMISSAO", "D")
				if oSqlAux:hasRecords()
					aRet[1] := oSql:getValue("Z8_NFRCO")
					aRet[2] := oSql:getValue("Z8_SERRCO")
					aRet[3] := oSqlAux:getValue("F2_EMISSAO")
					aRet[4] := oSqlAux:getValue("F2_VALBRUT")
					aRet[5] := oSqlAux:getValue("QTD_PECAS")
				endif
			
				oSqlAux:close()
			endif
			
			oSql:close()
		
		endif		
	
	elseif cTpQry == "3" //NF RET
			
		if oSqlNotas:getValue("F2_ZZTPNF") == REMESSA_CONTA_ORDEM
		
			cQuery := " SELECT Z8_NFRET, Z8_SERRET "										+CRLF
			cQuery += " FROM %SZ8.SQLNAME% " 												+CRLF
			cQuery += " WHERE  " 															+CRLF
			cQuery += "	Z8_NFRCO = '" + oSqlNotas:getValue("F2_DOC") + "' AND"		+CRLF
			cQuery += "	Z8_SERRCO = '" + oSqlNotas:getValue("F2_SERIE") + "' AND"	+CRLF
			cQuery += " 	%SZ8.XFILIAL% AND "												+CRLF
			cQuery += " 	%SZ8.NOTDEL%"           											+CRLF
		
			oSql:newAlias(cQuery)	
				
			if oSql:hasRecords()
				
				cQuery := " SELECT F2_EMISSAO, F2_VALBRUT, SUM(D2_QUANT) QTD_PECAS "		+CRLF
				cQuery += " FROM %SF2.SQLNAME% " 											+CRLF
				
				cQuery	+= " INNER JOIN %SD2.SQLNAME% ON " 									+CRLF
				cQuery += " 	1=1 " 														+CRLF 
				cQuery += "	AND D2_FILIAL = F2_FILIAL" 										+CRLF
				cQuery	+= "	AND D2_DOC = F2_DOC " 										+CRLF
				cQuery	+= "	AND D2_SERIE = F2_SERIE " 									+CRLF
				cQuery	+= "	AND D2_CLIENTE = F2_CLIENTE " 								+CRLF
				cQuery	+= "	AND D2_LOJA = F2_LOJA" 										+CRLF
				cQuery	+= " 	AND %SD2.NOTDEL% " 											+CRLF
				
				cQuery += " WHERE  " 														+CRLF
				cQuery += " 	1=1 " 														+CRLF 
				cQuery += "	AND F2_DOC = '" + oSql:getValue("Z8_NFRET") + "' "				+CRLF
				cQuery += "	AND F2_SERIE = '" + oSql:getValue("Z8_SERRET") + "' "			+CRLF
				cQuery += " 	AND %SF2.XFILIAL% "											+CRLF
				cQuery += " 	AND %SF2.NOTDEL%"           								+CRLF
				
				cQuery	+= " GROUP BY" 														+CRLF
				cQuery	+= "	F2_EMISSAO, " 												+CRLF
				cQuery	+= "	F2_VALBRUT " 												+CRLF
				
				oSqlAux:newAlias(cQuery)	
				
				oSqlAux:setField("F2_EMISSAO", "D")
				if oSqlAux:hasRecords()
					aRet[1] := oSql:getValue("Z8_NFRET")
					aRet[2] := oSql:getValue("Z8_SERRET")
					aRet[3] := oSqlAux:getValue("F2_EMISSAO")
					aRet[4] := oSqlAux:getValue("F2_VALBRUT")
					aRet[5] := oSqlAux:getValue("QTD_PECAS")
				endif
			
				oSqlAux:close()
			endif
			
			oSql:close()
		
		endif
	
	endif
	
return (aRet)


/**
* Retorna Nome do Usuário
**/
Static Function retFullName(cCodUsr)
Return UsrFullName(cCodUsr)

/*
** Retorna o tipo do documento
*/
static function retCfop(oSqlNotas)
	local oSql 	:= IpSqlObject():newIpSqlObject()
	local cRet	:= "" 
	
	oSql:newAlias(retSqlCfop(oSqlNotas))
	
	if oSql:hasRecords()
		cRet := oSql:getValue("D2_CF")
	endif
	
	oSql:close()
	
return (cRet)

/*
** Retorna o tipo do documento
*/
static function retSqlCfop(oSqlNotas)
	local cQuery	:= ""
	
	cQuery += " SELECT D2_CF	                                                   "+CRLF
	cQuery += " FROM %SD2.SQLNAME%                                                     "+CRLF
	cQuery += " WHERE                                                                  "+CRLF
	cQuery += " 	%SD2.XFILIAL%                                                      "+CRLF
	cQuery += " 	AND %SD2.NOTDEL%                                                   "+CRLF
	cQuery += " 	AND D2_DOC		= '" + oSqlNotas:getValue("F2_DOC") 	+ "'       "+CRLF
	cQuery += " 	AND D2_SERIE	= '" + oSqlNotas:getValue("F2_SERIE") 	+ "'       "+CRLF
	cQuery += " 	AND D2_CLIENTE	= '" + oSqlNotas:getValue("F2_CLIENTE") + "'       "+CRLF
	cQuery += " 	AND D2_LOJA		= '" + oSqlNotas:getValue("F2_LOJA") 	+ "'       "+CRLF
	cQuery += " ORDER BY D2_DOC, D2_SERIE, D2_ITEM 	                                   "+CRLF
	
return (cQuery)
