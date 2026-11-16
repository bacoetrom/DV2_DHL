#include 'Protheus.ch'
#include 'dhl.ch'
#include 'fwcommand.ch'
#include "rwmake.ch"


/*/{Protheus.doc} RelSaldos

Relatório de Saldos de Produtos

@author Thiago Meschiatti
@since 13/05/2015

/*/
User Function RelSaldos()
	local bParams		:= {|| oParamBox:show() }
	local bProcRel		:= {|| procRel() }

	private oSqlItens	:= nil
	
	private cStatusId	:= ""
	private dDtDgtAte	:= CtoD("")	
	
	private cProdDe		:= ""
	private cProdAte	:= ""
	
	private cNotaDe		:= ""
	private cNotaAte	:= ""
	
	private cSerieDe	:= ""
	private cSerieAte	:= ""
	
	private cNome  		:= "RelSaldos"
	private cTitulo 	:= "Saldos de Estoque"
	private cDescricao	:= "Relatório de "+cTitulo
	
	private oReport		:= nil
	private oSecItens	:= nil
	
	private oParamBox 	:= IpParamBoxObject():newIpParamBoxObject(cNome)
	
	private oSqlItens	:= nil
	
	criaParams()
	
	oReport := TReport():new(cNome, cTitulo, bParams, bProcRel, cDescricao)
	oReport:lOnPageBreak := .f.
	
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
	
	oParam := IpParamObject():newIpParamObject("status", "combo", "Status", "C", 60)
	oParam:setValues({"G=Good", "B=Bad", "T=Todos"})
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dtAte", "get", "Data até", "D", 60, TamSX3("F2_EMISSAO")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("codPrdDe", "get", "Produto de", "C", 60, TamSX3("B1_COD")[1])
	oParam:setF3("SB1")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("codPrdAte", "get", "Produto até", "C", 60, TamSX3("B1_COD")[1])
	oParam:setF3("SB1")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("notaDe", "get", "Nota Fiscal de", "C", 60, TamSX3("F1_DOC")[1])
	oParam:setF3("SD1NF")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("notaAte", "get", "Nota Fiscal até", "C", 60, TamSX3("F1_DOC")[1])
	oParam:setF3("SD1NF")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serieDe", "get", "Série de", "C", 60, TamSX3("F1_SERIE")[1])
	oParam:setF3("01")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serieAte", "get", "Série  até", "C", 60, TamSX3("F1_SERIE")[1])
	oParam:setF3("01")
	oParamBox:addParam(oParam)	
	
return


/**
* Função responsável pelo processamento do relatório.
*/
static function procRel()

	cStatusId	:= oParamBox:getValue("status")
	dDtDgtAte	:= oParamBox:getValue("dtAte")
	cProdDe		:= oParamBox:getValue("codPrdDe")
	cProdAte	:= oParamBox:getValue("codPrdAte")
	cNotaDe		:= oParamBox:getValue("notaDe")
	cNotaAte	:= oParamBox:getValue("notaAte")
	cSerieDe	:= oParamBox:getValue("serieDe")
	cSerieAte	:= oParamBox:getValue("serieAte")
	
	if empty(dDtDgtAte)
		dDtDgtAte := dDataBase
	endif
		
	getItens()
	procImpressao()
	
return


/**
* Função responsável pela criação da seção.
*/
static function criaSecao()
	
	local aOrdem	:= criaIndice()
	
	oSecItens := TRSection():new(oReport,,,aOrdem)	
	oSecItens:lHeaderBreak := .f.
	
	TRCell():new(oSecItens, "FILIAL_CLIENTE"	, 	, , nil								, 20						,,,,,"RIGHT")
	TRCell():new(oSecItens, "SITE"				,	, , nil								, 20						,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_ZZID"			, 	, , nil								, TamSX3("Z3_ID")[1]		,,,,,"RIGHT")
	TRCell():new(oSecItens, "Z3_STATUS" 		,	, ,	nil								, TamSX3("Z3_STATUS")[1]	,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_COD"			, 	, , nil								, TamSX3("D1_COD")[1]		,,,,,"RIGHT")	
	TRCell():new(oSecItens, "B1_UM"         	, 	, ,	nil								, TamSX3("B1_UM")[1]		,,,,,"RIGHT")
	TRCell():new(oSecItens, "B1_POSIPI"    		, 	, ,	nil								, TamSX3("A1_CGC")[1]		,,,,,"RIGHT")
	TRCell():new(oSecItens, "B1_ORIGEM"   		, 	, , nil								, TamSX3("B1_ORIGEM")[1]	,,,,,"RIGHT")
	TRCell():new(oSecItens, "B1_DESC"   	 	,	, , nil								, TamSX3("B1_DESC")[1]		,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_DTDIGIT"		,	, , nil								, TamSX3("D1_DTDIGIT")[1]	,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_EMISSAO"		,	, , nil								, TamSX3("D1_EMISSAO")[1]	,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_DOC"    		,	, , nil								, TamSX3("D1_DOC")[1]		,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_SERIE"  		,	, , nil								, TamSX3("D1_SERIE")[1]		,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_FORMUL" 		,	, , nil								, TamSX3("D1_FORMUL")[1]	,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_TES"   			,	, , nil								, TamSX3("D1_TES")[1]		,,,,,"RIGHT")
	TRCell():new(oSecItens, "F4_FINALID"   		,	, , nil								, TamSX3("F4_FINALID")[1]	,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_CF"	    		,	, , nil								, TamSX3("D1_CF")[1]		,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_VUNIT"  		,	, , PesqPict("SD1", "D1_VUNIT")		, TamSX3("D1_VUNIT")[1]		,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_PICM" 			,	, , PesqPict("SD1", "D1_PICM")		, TamSX3("D1_PICM")[1]		,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_VALICM" 		,	, , PesqPict("SD1", "D1_VALICM")	, TamSX3("D1_VALICM")[1]	,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_IPI"  			,	, , PesqPict("SD1", "D1_IPI")		, TamSX3("D1_IPI")[1]		,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_VALIPI"   		,	, , PesqPict("SD1", "D1_VALIPI")	, TamSX3("D1_VALIPI")[1]	,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_ICMSRET"		,	, "Valor ICMS ST" , PesqPict("SD1", "D1_ICMSRET")	, TamSX3("D1_ICMSRET")[1]	,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_TOTAL" 			,	, , PesqPict("SD1", "D1_TOTAL")		, TamSX3("D1_TOTAL")[1]		,,,,,"RIGHT")
	TRCell():new(oSecItens, "D1_VALANTI" 		,	, , PesqPict("SD1", "D1_VALANTI")	, TamSX3("D1_VALANTI")[1]	,,,,,"RIGHT")
	TRCell():new(oSecItens, "F1_CHVNFE"			,	, , PesqPict("SF1", "F1_CHVNFE")	, TamSX3("F1_CHVNFE")[1]	,,,,,"RIGHT")
	TRCell():new(oSecItens, "TES"				,	,"TES", nil							, (TamSX3("F4_TEXTO")[1]) + 6 ,,,"CENTER",,"CENTER",,,.t.)
		
return


/**
* Processamento da Impressão
*/
static function procImpressao()
	local cQuery		:= ""
	local aFilEmp		:= FWArrFilAtu(cEmpAnt, cFilAnt)
	local cNomeFil		:= aFilEmp[SM0_NOME]
	local cDescEmp		:= aFilEmp[SM0_NOMECOM]
	local cUnidNeg		:= aFilEmp[SM0_DESCUN]
	local cIDStat		:= ""
	local nValTot		:= 0
	
	oSecItens:cAlias	:= oSqlItens:getAlias()
	oReport:startPage()
	oSecItens:init()
	oSqlItens:setField("D1_DTDIGIT", "D")
	oSqlItens:setField("D1_EMISSAO", "D")
	
	oReport:SetMeter(oSqlItens:count())

	while oSqlItens:notIsEof()
		if oReport:lCanceled
			exit
		endif
		oReport:IncMeter()
		
		oSecItens:Cell("FILIAL_CLIENTE"):setValue(cNomeFil)
		oSecItens:Cell("SITE"):setValue(cUnidNeg)
		
		cIDStat := retIdStatus(oSqlItens)
		if (cStatusId $ "T") .or.(cStatusId $ cIDStat) 
			oSecItens:Cell("Z3_STATUS"):setValue(cIDStat)
		else
			oSqlItens:skip()
			loop
		endif
		
		if GetNewPar("ZZ_ICSTDEV", .T.)
			nValTot := oSqlItens:getValue("D1_VUNIT") + oSqlItens:GetValue("D1_VALIPI") + oSqlItens:getValue("D1_ICMSRET")
		else
			oSecItens:Cell("D1_ICMSRET"):setValue(0)
			nValTot := oSqlItens:getValue("D1_VUNIT") + oSqlItens:GetValue("D1_VALIPI")
		endif
		
		oSecItens:Cell("D1_TOTAL"):setValue(Round(nValTot,2))
		
		oSecItens:printLine()
		
		oSqlItens:skip()
	endDo
	
	oSecItens:finish()
	oSqlItens:close()
return


/**
* Função responsável pela montagem da consulta SQL.
*/
static function getItens()
	
	local cQuery := ""
	local nIndice:= oSecItens:getOrder()
	
	cQuery += " SELECT 	DISTINCT D1_ZZID,D1_COD, B1_UM, B1_ORIGEM, B1_DESC, "+CRLF
	cQuery += " 		D1_DTDIGIT, D1_EMISSAO, D1_DOC, D1_SERIE, D1_TES, D1_VUNIT, D1_PICM,		 "+CRLF
	cQuery += " 		D1_TES || ' - ' || F4_TEXTO TES,											 "+CRLF
	cQuery += " 		D1_VALICM, D1_IPI, D1_VALIPI, D1_ICMSRET, D1_TOTAL, D1_VALANTI, F1_CHVNFE,	 "+CRLF
	cQuery += " 		D1_FILIAL, D1_ITEM, B1_POSIPI, D1_CF, F4_FINALID, 							 "+CRLF
	cQuery += " 		CASE WHEN D1_FORMUL = 'S' THEN 'S' ELSE 'N' END D1_FORMUL				 	 "+CRLF
	cQuery += " FROM %SD1.SQLNAME%  			                                                     "+CRLF
	cQuery += " INNER JOIN %SF4.SQLNAME% ON                                                          "+CRLF
  	cQuery += " 	%SF4.NOTDEL%                                                                     "+CRLF
	cQuery += " 	AND F4_FILIAL = D1_FILIAL                                                        "+CRLF
	cQuery += " 	AND F4_CODIGO = D1_TES                                                           "+CRLF
	cQuery += " INNER JOIN %SB1.SQLNAME% ON				                                             "+CRLF
	cQuery += " 	%SB1.NOTDEL%		                                                             "+CRLF
	cQuery += " 	AND D1_FILIAL 	= B1_FILIAL                                                      "+CRLF
	cQuery += " 	AND D1_COD		= B1_COD                                                         "+CRLF
	cQuery += " INNER JOIN %SF1.SQLNAME%  ON                                                         "+CRLF
	cQuery += " 	%SF1.NOTDEL%   		                                                             "+CRLF
	cQuery += " 	AND D1_FILIAL 	= F1_FILIAL                                                      "+CRLF
	cQuery += " 	AND D1_DOC		= F1_DOC		                                                 "+CRLF
	cQuery += " 	AND D1_SERIE	= F1_SERIE 		                                                 "+CRLF
	cQuery += " 	AND D1_FORNECE	= F1_FORNECE           		                                     "+CRLF
	cQuery += " 	AND D1_LOJA		= F1_LOJA           		                                     "+CRLF
	cQuery += " LEFT JOIN %SD2.SQLNAME% ON				                                             "+CRLF
	cQuery += " 	%SD2.NOTDEL%  			                                                         "+CRLF
	cQuery += " 	AND D1_FILIAL 	= D2_FILIAL                                                  	 "+CRLF
	cQuery += " 	AND D1_ZZID 	= D2_ZZID                                                        "+CRLF
	cQuery += " 	AND D1_DOC		= D2_NFORI                                                       "+CRLF
	cQuery += " 	AND	D1_SERIE	= D2_SERIORI                                                     "+CRLF
	cQuery += " 	AND D1_ITEM		= D2_ITEMORI                                                     "+CRLF
	cQuery += " 	AND D2_EMISSAO <= '"+dtos(dDtDgtAte)+"'                                          "+CRLF
	cQuery += " LEFT JOIN %SF2.SQLNAME% ON				                                             "+CRLF
	cQuery += " 	%SF2.NOTDEL%                  		                                             "+CRLF
	cQuery += " 	AND D2_FILIAL	= F2_FILIAL                                                      "+CRLF
	cQuery += " 	AND	D2_DOC		= F2_DOC                                                         "+CRLF
	cQuery += " 	AND D2_SERIE	= F2_SERIE                                                       "+CRLF
	cQuery += " 	AND (F2_FIMP 	= 'S' OR                                                         "+CRLF
	cQuery += " 	((F2_SERIE = '"+DHL_SERIE_INVENTARIO+"' AND F2_FIMP = ' ') OR					 "+CRLF
	cQuery += " 	(F2_SERIE = '"+DHL_SERIE_CUTOVER+"' AND F2_FIMP = ' ')))  						 "+CRLF
	cQuery += " WHERE                                                                                "+CRLF
	cQuery += " 	%SD1.XFILIAL% 			                                                         "+CRLF
	cQuery += " 	AND %SD1.NOTDEL%	                                                             "+CRLF
	cQuery += " 	AND D1_DTDIGIT 	<= '"+dtos(dDtDgtAte)+"'                                         "+CRLF
	cQuery += " 	AND D1_COD 		BETWEEN '"+cProdDe+"'  and '"+cProdAte+"'                        "+CRLF
	cQuery += " 	AND D1_DOC 	 	BETWEEN '"+cNotaDe+"'  and '"+cNotaAte+"'                        "+CRLF
	cQuery += " 	AND D1_SERIE 	BETWEEN '"+cSerieDe+"' and '"+cSerieAte+"'                       "+CRLF
	cQuery += " 	AND D1_TES <> '"+criavar("D1_TES", .F.)+"'										 "+CRLF
	cQuery += " 	AND D2_DOC IS NULL                       "+CRLF
	cQuery += " ORDER BY                                                              				 "+CRLF
	
	if nIndice == 1	
		cQuery	+= "D1_FILIAL, D1_DTDIGIT" +CRLF
	elseif nIndice == 2
		cQuery	+= "D1_FILIAL, D1_DOC, D1_SERIE " +CRLF
	else
		cQuery	+= "D1_FILIAL, D1_ZZID" +CRLF
	endIf
	
	oSqlItens	:= IpSqlObject():newIpSqlObject()
	oSqlItens:newAlias(cQuery)
return


/*
*	Função responsável pela criação do indice.
*/
static function criaIndice()
	local aOrdem	:= {}
	
	aADD(aOrdem, "Filial + Data")
	aADD(aOrdem, "Filial + Número Nota Fiscal + Serie ")
	aADD(aOrdem, "Filial + ID ")
return aOrdem


/*
** Coleta útltimo sequencial do ID
*/
static function retIdStatus(oSqlItens)
	local oSql	 := IpSqlObject():newIpSqlObject()
	local cQuery := ""
	local cRet	 := ""

	cQuery += " SELECT MAX(Z3_SEQUEN), Z3_STATUS FROM %SZ3.SQLNAME% "+CRLF
	cQuery += " WHERE                                    "+CRLF
	cQuery += " 	%SZ3.NOTDEL%                        "+CRLF
	cQuery += " 	AND %SZ3.XFILIAL%                    "+CRLF
	cQuery += " 	AND Z3_ID		= '"+oSqlItens:getValue("D1_ZZID")+"'       "+CRLF
	cQuery += " 	AND Z3_PRODUTO	= '"+oSqlItens:getValue("D1_COD")+"'        "+CRLF
	cQuery += " 	AND Z3_DOC		= '"+oSqlItens:getValue("D1_DOC")+"'        "+CRLF
	cQuery += " 	AND Z3_SERIE	= '"+oSqlItens:getValue("D1_SERIE")+"'      "+CRLF
	cQuery += " 	AND Z3_ITEM		= '"+oSqlItens:getValue("D1_ITEM")+"'       "+CRLF
	cQuery += " 	AND Z3_TPMOV	= 'E'             							"+CRLF
	cQuery += " GROUP BY Z3_STATUS "+CRLF

	oSql:newAlias(cQuery)
	if oSql:hasRecords()
		cRet := oSql:getValue("Z3_STATUS")
	endif	

	oSql:close()
return (cRet)