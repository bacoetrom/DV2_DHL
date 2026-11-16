#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx52.ch'
#include 'safx.ch'
#include 'dhl.ch'


/*/{Protheus.doc} SAFX52REP

Respons‡vel por gerar o arquivo SAFX52

@author Daniel Braga
@since 30/10/2014

/*/
user function SAFX52REP(aCompany,dDtInvent)

	local oDhlSafx		:= DhlSafx():newDhlSafx()	
	private lGerouArqs	:= .F.

	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf 	 

	SAFX52(dDtInvent)

return lGerouArqs

static function SAFX52(dDtInvent)

	local oFileSfx52 	:= MsafDWFile():newMsafDWFile("52", SAFX52_POSICOES)
	local oIpSqlSfx52 	:= IpSqlObject():newIpSqlObject()
	local oDHLRepSafx52	:= DHLRepSafx52():newDHLRepSafx52()
	local cError		:= ""
	local aFields		:= {}
	local cAlias		:= ""
	local nCount		:= 0
	local nSldTerc		:= 0
	local lContSB6		:= .f.
	local lTerceiro		:= .f.
	local nforma		:= SuperGetMv("ZZ_NFOSAFX",,1)
	default dDtInvent   := oDHLRepSafx52:getDateDefault()

	dDtInvent   := iif(empty(dDtInvent), oDHLRepSafx52:getDateDefault(), dDtInvent)
	
	if nforma == 0
		oIpSqlSfx52:newAlias(oDHLRepSafx52:getSql())
	else
		oIpSqlSfx52:newAlias(oDHLRepSafx52:getSqlSB9(dDtInvent))		
	endif	

	cAlias := oIpSqlSfx52:getAlias()
	nCount := oIpSqlSfx52:count()
	(cAlias)->( DbGoTop() )	

	while oIpSqlSfx52:notIsEof()
		lContSB6 := .f.
		nSaldo 	 := 0	

		nSldTerc := oDHLRepSafx52:getSldTerc(oIpSqlSfx52:getValue("B2_COD"),dDtInvent)		

		if nSldTerc == 0
			oIpSqlSfx52:skip()
			loop
		endIf

			oDHLRepSafx52:initialize(SAFX52_POSICOES,oIpSqlSfx52)

			oDHLRepSafx52:addLine(dDtInvent, lTerceiro, @lContSB6)

			if lContSB6
				if nSldTerc > 0
					SAFX52SB6(dDtInvent, oFileSfx52, oIpSqlSfx52, oDHLRepSafx52)
					oIpSqlSfx52:skip()
				endif
			else 
				if nSaldo == 0			
					oIpSqlSfx52:skip()
				else		
					aFields := oDHLRepSafx52:getFields()
					cError	:= oDHLRepSafx52:validRequired(VLD_FIELD_52)

					if !Empty(cError)
						cError += getIdSldEst(cAlias)
						oDHLRepSafx52:addLog(SAFX52_ERROR_TITLE,SAFX52_ERROR_OBRIGAT+cError,oFileSfx52:getFile())
						oIpSqlSfx52:skip()
						loop
					endIf

					oFileSfx52:setFields(aFields)

					if oFileSfx52:write()
						lGerouArqs := .T.
					else
						oDHLRepSafx52:addLog(SAFX52_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx52:getFile())
						oIpSqlSfx52:skip()
						loop		
					endif

					oIpSqlSfx52:skip()

				endif	
			endif	
	endDo

	oIpSqlSfx52:close()
	oFileSfx52:renameArq("52", SAFX52_POSICOES)
	oFileSfx52:close()

return

/**
* Coleta o ID do Saldo em Estoque para o Log de Erros
*/
static function getIdSldEst(cAlias)

	local cId := CRLF+CRLF

	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		cId += "Produto: "+(cAlias)->(D1_COD)+CRLF
		cId += "Local: "+(cAlias)->(B1_LOCPAD)
	else
		cId += "Produto: "+(cAlias)->(B2_COD)+CRLF
		cId += "Local: "+(cAlias)->(B2_LOCAL)
	endif

return cId


/*
** Processa linhas do detalhamento de poder de terceiros
*/ 
static function SAFX52SB6(dDtInvent, oFileSfx52, oIpSqlSfx52, oDHLRepSafx52)

	local oSqlSfxb6 	:= IpSqlObject():newIpSqlObject()
	local oSqlSb6Alg 	:= IpSqlObject():newIpSqlObject()
	local oDHLSafxB6	:= DHLRepSafx52():newDHLRepSafx52()
	local cProduct		:= oIpSqlSfx52:getValue("B2_COD")
	local cType			:= ""
	local cError		:= ""
	local aFields		:= {}
	local cAlias		:= ""
	local nCount		:= 0
	local lTerceiro		:= .t.
	default dDtInvent   := oDHLRepSafx52:getDateDefault()

	dDtInvent   := iif(empty(dDtInvent), oDHLRepSafx52:getDateDefault(), dDtInvent)

	oSqlSfxb6:newAlias(oDHLRepSafx52:getSqlSb6(cProduct, dDtInvent))

	while oSqlSfxb6:notIsEof()		
		if oSqlSfxb6:getValue("SALDO") <= 0
			oSqlSfxb6:skip()
			loop
		endif 
		cType := oSqlSfxb6:getValue("TIPO") 
		oSqlSb6Alg:newAlias(oDHLRepSafx52:getAglutB6(cProduct, cType, dDtInvent, oSqlSfxb6:getValue("CLIFOR"), oSqlSfxb6:getValue("LOJA") ))

		cAlias := oIpSqlSfx52:getAlias()

		while oSqlSb6Alg:notIsEof()			
			oDHLSafxB6:initialize(SAFX52_POSICOES,oSqlSb6Alg)

			oDHLSafxB6:addLine(dDtInvent, lTerceiro)

			aFields := oDHLSafxB6:getFields()
			cError	:= oDHLSafxB6:validRequired(VLD_FIELD_52)

			if !Empty(cError)
				cError += getIdSldEst(cAlias)
				oDHLSafxB6:addLog(SAFX52_ERROR_TITLE,SAFX52_ERROR_OBRIGAT+cError,oFileSfx52:getFile())
				oSqlSb6Alg:skip()
				loop
			endIf

			oFileSfx52:setFields(aFields)

			if oFileSfx52:write()
				lGerouArqs := .T.
			else
				oDHLSafxB6:addLog(SAFX52_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx52:getFile())
				oSqlSb6Alg:skip()
				loop		
			endif

			oSqlSb6Alg:skip() 
		enddo
		oSqlSfxb6:skip()	
	endDo

	oSqlSb6Alg:close()
	oSqlSfxb6:close()
	oFileSfx52:close()

return