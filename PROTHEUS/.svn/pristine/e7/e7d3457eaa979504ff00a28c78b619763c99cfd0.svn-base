#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx2081.ch'
#include 'safx.ch'
#include 'dhl.ch'


/*/{Protheus.doc} SAFX2081MSDW

Respons‡vel por gerar o arquivo SAFX2081
	
@author Daniel Braga
@since 30/10/2014
/*/
user function SAFX2081MSDW(aCompany)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()	
	private lGerouArqs	:= .F.
	
	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf  
			
	SAFX2081()
	
return lGerouArqs

static function SAFX2081()

	local oFileSfx2081 	:= MsafDWFile():newMsafDWFile("2081", SAFX2081_POSICOES)
	local oIpSqlSfx2081 := IpSqlObject():newIpSqlObject()
	local oDHLSafx2081	:= DHLSafx2081():newDHLSafx2081()
	local cError		:= ""
	local cTypes		:= ""
	local aFields		:= {}
	local cAlias		:= ""
	local nCount		:= 0

	oIpSqlSfx2081:newAlias( oDHLSafx2081:getSql() )
	
	cAlias := oIpSqlSfx2081:getAlias()
	nCount := oIpSqlSfx2081:count()
	(cAlias)->( DbGoTop() )
	
	while oIpSqlSfx2081:notIsEof()
		cTypes := ""
		oDHLSafx2081:initialize(SAFX2081_POSICOES,oIpSqlSfx2081)
		
		oDHLSafx2081:addLine()
		
		aFields := oDHLSafx2081:getFields()
		cError	:= oDHLSafx2081:validRequired(VLD_FIELD_2081)
		
		if !Empty(cError)
			oDHLSafx2081:addLog(SAFX2081_ERROR_TITLE,SAFX2081_ERROR_OBRIGAT+cError,oFileSfx2081:getFile())
			oIpSqlSfx2081:skip()
			loop
		endIf
		
		oFileSfx2081:setFields( aFields )
		
		if oFileSfx2081:write()
			lGerouArqs := .T.
			if lGerouArqs
				oDHLSafx2081:initialize(SAFX2081_POSICOES,oIpSqlSfx2081)				
				cTypes += left((cAlias)->CHAVE, 1)
				if left((cAlias)->CHAVE, 1) $ '123'
					while len(cTypes) < 3
						if !('1' $ cTypes)  
							cOperac := '1'
						elseif !('2' $ cTypes)
							cOperac := '2'	
						else
							cOperac := '3'
						endif
						if oDHLSafx2081:existSX5(cOperac + right((cAlias)->CHAVE, tamsx3("X5_CHAVE")[1]-1))
							oDHLSafx2081:addLine(cOperac)
							aFields := oDHLSafx2081:getFields()
							oFileSfx2081:setFields( aFields )
							oFileSfx2081:write()	 		
						endif
						cTypes += cOperac
					enddo
				else
					while len(cTypes) < 3
						if !('5' $ cTypes)
							cOperac := '5'
						elseif !('6' $ cTypes)
							cOperac := '6'
						else
							cOperac := '7'
						endif
						if oDHLSafx2081:existSX5(cOperac + right((cAlias)->CHAVE, tamsx3("X5_CHAVE")[1]-1))
							oDHLSafx2081:addLine(cOperac)
							aFields := oDHLSafx2081:getFields()
							oFileSfx2081:setFields( aFields )
							oFileSfx2081:write()	 		
						endif
						cTypes += cOperac
					enddo
				endif 
			endif
		else
			oDHLSafx2081:addLog(SAFX2081_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx2081:getFile())
			oIpSqlSfx2081:skip()
			loop		
		endif

		oIpSqlSfx2081:skip()	
	endDo
	
	oIpSqlSfx2081:close()
	oFileSfx2081:renameArq("2081", SAFX2081_POSICOES)
	oFileSfx2081:close()
	
return

