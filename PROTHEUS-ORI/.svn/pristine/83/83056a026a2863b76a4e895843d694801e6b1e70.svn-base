#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx235.ch'
#include 'safx.ch'
#include 'dhl.ch'


/*/{Protheus.doc} SAFXPKG235

Respons‡vel por gerar o arquivo SAFX235
	
@author Gustavo Luiz
@since 14/12/2018

/*/
user function SAFXPKG235(aCompany, dDtFrom , dDtUntil)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()
	private lGerouArqs	:= .F.
		
	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf
	
	Processa({||  SAFX235(dDtFrom , dDtUntil)},"Gerando SAFX235")
	
return lGerouArqs

/** 
* processa a SAFX 235
**/
static function SAFX235(dDtFrom , dDtUntil)
	local cLocal		:= ''
	local oFileSfx235 	:= MsafDWFile():newMsafDWFile("235", SAFX235_POSICOES)
	local oIpSqlSfx235 	:= IpSqlObject():newIpSqlObject()
	local oDHLSafx235	:= DHLPkgSafx235():newDHLPkgSafx235()
	local cError		:= ""
	local aFields		:= {}
	local cAlias		:= ""
	local nCount		:= 0 
	local nSldTerc		:= 0
	local lContSB6		:= .f.
	local lTerceiro		:= .f.
	
	local nLinha		:= 1
	
	if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS .or. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL .or. FWUnitBusiness() == DHL_BUSINESSUNIT_PKG
		
		FWMsgRun(, {|| oIpSqlSfx235:newAlias(oDHLSafx235:getSql(dDtFrom, dDtUntil)) },,"Aguarde, realizando consulta")
		
		cAlias := oIpSqlSfx235:getAlias()
		nCount := oIpSqlSfx235:count()
	
		if nCount > 0
			(cAlias)->( DbGoTop() )
		
			procRegua(nCount)
		
			while oIpSqlSfx235:notIsEof()
			
				incProc()
			
				FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "PROCESSANDO LINHA " + cValtoChar(nLinha) + " DE " + cValToChar(nCount) + " LINHAS", 0, 0, {})
				
				oDHLSafx235:initialize(SAFX235_POSICOES,oIpSqlSfx235)
				oDHLSafx235:addLine()
				aFields := oDHLSafx235:getFields()
				cError	:= oDHLSafx235:validRequired(VLD_FIELD_235)
				
				if !Empty(cError)
					oDHLSafx235:addLog(SAFX235_ERROR_TITLE,SAFX235_ERROR_OBRIGAT+cError,oFileSfx235:getFile())
					oIpSqlSfx235:skip()
					loop
				endIf
				
				oFileSfx235:setFields(aFields)
				
				if oFileSfx235:write()
					lGerouArqs := .T.
				else
					oDHLSafx235:addLog(SAFX235_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx235:getFile())
					oDHLSafx235:skip()
					loop
				endif
			
				nLinha++
				oIpSqlSfx235:skip()
					
			endDo
		
			oIpSqlSfx235:close()
			oFileSfx235:renameArq("235", SAFX235_POSICOES)
			oFileSfx235:close()
		
		endIf
		
	else
	
		MsgInfo("Geração do bloco K não permitido para a unidade de negócio " + allTrim(FWUnitBusiness()),"")
		
	endif
	
return
