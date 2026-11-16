#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} ag2CanDlNf

Rotina responsável verificar se pode efetuar a exclusão da nota.
Processo para a Unidade de Negócio AG2(SCJ - PUZZLE)

@author Gustavo Luiz
@since 09/08/2017
/*/
User Function ag2CanDlNf()	
	
	local cNf 		:= ""
	local cSerie 	:= ""
	local cItem	 	:= ""
	local cQuery 	:= ""
	local oSQL	 	:= IpSQLObject():newIpSQLObject()
	local cItem	 	:= ""
	local cIdCob 	:= ""
	local cProd	 	:= ""
	local lTipoMov2	:= .F.
	
	getNfRetornoRCO(@cNf, @cSerie)	
	
	cQuery := getQuerySZ4(cNf, cSerie)
	
	oSQL:newAlias(cQuery)
	
	if oSQL:hasRecords()
		while oSQL:NotIsEof()
			
			cItem  		:= oSql:GetValue("Z4_ITEM")
			cProd  		:= oSql:GetValue("Z4_PRODUTO")
			cIdCob 		:= oSql:GetValue("Z4_IDCOB")
			lTipoMov2	:= isTipoMov2(cIdCob)
			
			if lTipoMov2
				msgAlert("Não é possível realizar a exclusão. Processo de cobertura já realizado." )
				exit
			endIf
			
			oSQL:skip()
		endDo		
		
	endIf
	
	oSQL:close()

Return !lTipoMov2

/**
* Obtém a Nf e Serie da nota de retorna da RCO (pré nota)
**/
static function getNfRetRCO(cNf, cSerie)
	
	local aArea := getArea()
	local aAreaSD2	:= SD2->(getArea())
	
	SD2->(dbSetOrder(1))
	SD2->(dbSeek(fwxFilial("SD2") + SF2->(F2_DOC + F2_SERIE + F2_FORNECE + F2_LOJA)))
	
	restArea(aAreaSD2)
	restArea(aArea)
	
return

/**
* Obtém a query da tabela SZ4
**/
static function getQuerySZ4(cNf, cSerie, cIdCob)
	
	local cQuery 	:= ""
	
	default cNf 	:= ""
	default cSerie 	:= ""
	default cIdCob 	:= ""
	
	cQuery := "	SELECT " 														+ CRLF
	cQuery += "		* " 														+ CRLF
	cQuery += "	FROM %SZ4.SQLNAME% " 											+ CRLF
	cQuery += "	WHERE 1 = 1" 													+ CRLF
	cQuery += "		AND SZ4.Z4_FILIAL = '%SZ4.FILIAL%' " 						+ CRLF
	cQuery += "		AND %SZ4.NOTDEL%"           								+ CRLF
	
	if !empty(cNf) .and. !empty(cSerie)
		cQuery += "		AND SZ4.Z4_DOC = '"+cNf+"'"           					+ CRLF
		cQuery += "		AND SZ4.Z4_SERIE = '"+cSerie+"'"           				+ CRLF
	else
		cQuery += "		AND SZ4.Z4_IDCOB = '"+cIdCob+"'"           				+ CRLF
		cQuery += "		AND SZ4.Z4_TIPMOV = '2'"           						+ CRLF
	endIf
	
return cQuery

/**
* Verifica se o tipo de movimento é 2
**/
static function isTipoMov2(cIdCob)
	
	local cQuery 	:= getQuerySZ4(nil, nil, cIdCob)
	local oSQL	 	:= IpSQLObject():newIpSQLObject()
	local lTipo2	:= .F.
	
	oSQL:newAlias(cQuery)
	
	if oSQL:hasRecords()
		lTipo2 := .T.
	endIf
	
	oSQL:close()
	
return lTipo2

/**
* Obtém a nota fiscal e série da nota de retorno da RCO (pré nota)
**/
static function getNfRetornoRCO(cNf, cSerie)
	
	local oSQL	 	:= IpSQLObject():newIpSQLObject()
	local cQuery 	:= getQueryAJustImpos(SF2->(recno()))
	
	oSQL:newAlias(cQuery)
	
	if oSQL:hasRecords()
		cNf 	:= oSQL:getValue("F1_DOC")
		cSerie	:= oSQL:getValue("F1_SERIE")
	endIf
	oSQL:close()
	
return

/**
* Obtém a query do faturamento de ajuste de imposto para coletar informações
**/
static function getQueryAJustImpos(nRecno)
	
	local cQuery := ""
	
	cQuery := " SELECT  				"										+ CRLF
	cQuery += " 	SC5.R_E_C_N_O_ SC5_RECNO, SF1.R_E_C_N_O_ SF1_RECNO,		"	+ CRLF
	cQuery += " 	SF1.F1_DOC, SF1.F1_SERIE		"							+ CRLF
	cQuery += "	FROM %SF2.SQLNAME% " 											+ CRLF
	
	cQuery += "	INNER JOIN %SD2.SQLNAME% ON 1 = 1 "								+ CRLF
	cQuery += "		AND SD2.D2_FILIAL = SF2.F2_FILIAL "							+ CRLF
	cQuery += "		AND SD2.D2_DOC = SF2.F2_DOC "								+ CRLF
	cQuery += "		AND SD2.D2_CLIENTE = SF2.F2_CLIENTE "						+ CRLF
	cQuery += "		AND SD2.D2_LOJA = SF2.F2_LOJA "								+ CRLF
	cQuery += "		AND %SD2.NOTDEL% "											+ CRLF
		
	cQuery += "	INNER JOIN %SC6.SQLNAME% ON 1 = 1 "								+ CRLF
	cQuery += "		AND SC6.C6_FILIAL = SD2.D2_FILIAL "							+ CRLF
	cQuery += "		AND SC6.C6_NUM = SD2.D2_PEDIDO "							+ CRLF
	cQuery += "		AND SC6.C6_NOTA = SD2.D2_DOC "                              + CRLF
	cQuery += "		AND SC6.C6_SERIE = SD2.D2_SERIE "                           + CRLF
	cQuery += "		AND SC6.C6_PRODUTO = SD2.D2_COD "                           + CRLF
	cQuery += "		AND %SC6.NOTDEL%  "                                 		+ CRLF
   	
	cQuery += "	INNER JOIN %SC5.SQLNAME% ON 1 = 1 "								+ CRLF
	cQuery += "		AND SC5.C5_FILIAL = SD2.D2_FILIAL "							+ CRLF
	cQuery += "		AND SC5.C5_NUM = SD2.D2_PEDIDO "							+ CRLF
	cQuery += "		AND SC5.C5_NOTA = SD2.D2_DOC "                              + CRLF
	cQuery += "		AND SC5.C5_SERIE = SD2.D2_SERIE "                           + CRLF
	cQuery += "		AND %SC5.NOTDEL%  "                                 		+ CRLF
   	
	cQuery += "	INNER JOIN %SF1.SQLNAME% ON 1 = 1 "								+ CRLF
	cQuery += "		AND SF1.F1_FILIAL = SD2.D2_FILIAL "							+ CRLF
	cQuery += "		AND SF1.F1_DOC = SD2.D2_NFORI "								+ CRLF
	cQuery += "		AND SF1.F1_SERIE = SD2.D2_SERIORI  "                		+ CRLF
	cQuery += "		AND SF1.F1_FORNECE = SC6.C6_ZZFOROR  "              		+ CRLF
	cQuery += "		AND SF1.F1_LOJA = SC6.C6_ZZLOJOR "                  		+ CRLF
	cQuery += "		AND %SF1.NOTDEL%  "											+ CRLF
   	
	cQuery += "	INNER JOIN %SD1.SQLNAME% ON 1 = 1 "								+ CRLF
	cQuery += "		AND SD1.D1_FILIAL = SD2.D2_FILIAL "							+ CRLF
	cQuery += "		AND SD1.D1_DOC = SD2.D2_NFORI "								+ CRLF
	cQuery += "		AND SD1.D1_SERIE = SD2.D2_SERIORI  "                		+ CRLF
	cQuery += "		AND SD1.D1_FORNECE = SC6.C6_ZZFOROR  "              		+ CRLF
	cQuery += "		AND SD1.D1_LOJA = SC6.C6_ZZLOJOR "                  		+ CRLF
	cQuery += "		AND SD1.D1_COD = SC6.C6_PRODUTO "                   		+ CRLF
	cQuery += "		AND %SD1.NOTDEL%  "											+ CRLF
   	
	cQuery += "	WHERE 1 = 1 "                                                   + CRLF
	cQuery += "		AND SF2.F2_FILIAL = '%SF1.FILIAL%' "                    	+ CRLF
	cQuery += "		AND %SF2.NOTDEL% "                                 			+ CRLF
	cQuery += "		AND SF2.R_E_C_N_O_ = "+cValToChar(nRecno)+" "				+ CRLF
   
return cQuery

