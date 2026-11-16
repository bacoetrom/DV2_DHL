#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx52.ch'
#include 'safx.ch'
#include 'dhl.ch'


/*/{Protheus.doc} SAFX52MSDW

Respons‡vel por gerar o arquivo SAFX52
	
@author Daniel Braga
@since 30/10/2014

/*/
user function SAFX52MSDW(aCompany,dDtInvent)
	
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
	local oDHLSafx52	:= DHLSafx52():newDHLSafx52()
	local cError		:= ""
	local aFields		:= {}
	local cAlias		:= ""
	local nCount		:= 0
	local nSldTerc		:= 0
	local lContSB6		:= .f.
	local lTerceiro		:= .f.
	default dDtInvent   := oDHLSafx52:getDateDefault()
	
	dDtInvent   := iif(empty(dDtInvent), oDHLSafx52:getDateDefault(), dDtInvent)
	
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		oIpSqlSfx52:newAlias(oDHLSafx52:getSqlSPL(dDtInvent))
	else		
		//oIpSqlSfx52:newAlias(oDHLSafx52:getSql())
		oIpSqlSfx52:newAlias(oDHLSafx52:getSql(dDtInvent)) //Emerson Holanda 16/08/21
	endif
	
	cAlias := oIpSqlSfx52:getAlias()
	nCount := oIpSqlSfx52:count()
	(cAlias)->( DbGoTop() )	
	
	while oIpSqlSfx52:notIsEof()
		lContSB6 := .f.
		nSaldo 	 := 0
		if (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_REP) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_DI2)
			//nSldTerc := oDHLSafx52:getSldTerc(oIpSqlSfx52:getValue("B2_COD"),dDtInvent)
			nSldTerc := oDHLSafx52:getSldTerc(oIpSqlSfx52:getValue("B9_COD"),dDtInvent) //Emerson Holanda 16/08/21
		else
			nSldTerc := 0 
		endif
		
		oDHLSafx52:initialize(SAFX52_POSICOES,oIpSqlSfx52)
		
		oDHLSafx52:addLine(dDtInvent, lTerceiro, @lContSB6)
		
		if lContSB6
			if nSldTerc > 0
				SAFX52SB6(dDtInvent, oFileSfx52, oIpSqlSfx52, oDHLSafx52)
				oIpSqlSfx52:skip()
			else
				oIpSqlSfx52:skip()
			endif
		else 
			if nSaldo == 0			
				oIpSqlSfx52:skip()
			else		
				aFields := oDHLSafx52:getFields()
				cError	:= oDHLSafx52:validRequired(VLD_FIELD_52)
				
				if !Empty(cError)
					cError += getIdSldEst(cAlias)
					oDHLSafx52:addLog(SAFX52_ERROR_TITLE,SAFX52_ERROR_OBRIGAT+cError,oFileSfx52:getFile())
					oIpSqlSfx52:skip()
					loop
				endIf
				
				oFileSfx52:setFields(aFields)
				
				if oFileSfx52:write()
					lGerouArqs := .T.
				else
					oDHLSafx52:addLog(SAFX52_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx52:getFile())
					oIpSqlSfx52:skip()
					loop		
				endif
				
				if lGerouArqs
					if FWUnitBusiness() == DHL_BUSINESSUNIT_PKG 
						if nSldTerc > 0
							SAFX52SB6(dDtInvent, oFileSfx52, oIpSqlSfx52, oDHLSafx52)
						endif
					endif 
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
		/* Inibido por Emerson Holanda 16/08/21, A busca sera feita pela SB9
		cId += "Produto: "+(cAlias)->(B2_COD)+CRLF
		cId += "Local: "+(cAlias)->(B2_LOCAL)
		*/
		cId += "Produto: "+(cAlias)->(B9_COD)+CRLF
		cId += "Local: "+(cAlias)->(B9_LOCAL)

	endif
	
return cId


/*
** Processa linhas do detalhamento de poder de terceiros
*/ 
static function SAFX52SB6(dDtInvent, oFileSfx52, oIpSqlSfx52, oDHLSafx52)

	local oSqlSfxb6 	:= IpSqlObject():newIpSqlObject()
	local oSqlSb6Alg 	:= IpSqlObject():newIpSqlObject()
	local oDHLSafxB6	:= DHLSafx52():newDHLSafx52()
	//local cProduct		:= oIpSqlSfx52:getValue("B2_COD")
	local cProduct		:= oIpSqlSfx52:getValue("B9_COD") //Emerson Holanda 16/08/21
	local cType			:= ""
	local cError		:= ""
	local aFields		:= {}
	local cAlias		:= ""
	local nCount		:= 0
	local lTerceiro		:= .t.
	default dDtInvent   := oDHLSafx52:getDateDefault()
	
	dDtInvent   := iif(empty(dDtInvent), oDHLSafx52:getDateDefault(), dDtInvent)
	
	oSqlSfxb6:newAlias(oDHLSafx52:getSqlSb6(cProduct, dDtInvent))
	
	while oSqlSfxb6:notIsEof()		
		if oSqlSfxb6:getValue("SALDO") <= 0
			oSqlSfxb6:skip()
			loop
		endif 
		cType := oSqlSfxb6:getValue("TIPO") 
		oSqlSb6Alg:newAlias(oDHLSafx52:getAglutB6(cProduct, cType, dDtInvent, oSqlSfxb6:getValue("CLIFOR"), oSqlSfxb6:getValue("LOJA") ))
		 
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
