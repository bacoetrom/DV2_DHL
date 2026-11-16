#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx112.ch'
#include 'safx.ch'


user function AGL112(oSqlHeader,oFile)

	local oFileSfx112 		:= nil
	local oDHLAGL112		:= DHLAGL112():newDHLAGL112() //fix here
	local cError			:= ""
	local aFields			:= {}
	local lContinue			:= .t.
	local cTypeMsg			:= "01"
		
	oFileSfx112 := oFile
	
	oDHLAGL112:initialize(SAFX112_POSICOES,oSqlHeader)	
	while lContinue
		lContinue := oDHLAGL112:addLine(@cTypeMsg)
		   
		aFields 	:= oDHLAGL112:getFields()
		cError		:= oDHLAGL112:validRequired(VLD_112_FIELD)
		
		if !Empty(cError)
			oDHLAGL112:addLog(SAFX112_POSICOES,AGL112_ERROR_OBRIGAT+cError,oFile:getFile())
			oFileSfx112:Close()
			return 
		endIf
		
		oFileSfx112:setFields( aFields )
		
		if !oFileSfx112:write()
			oDHLAGL112:addLog(SAFX112_ERROR_TITLE,ERROR_QTD_CAMPOS,oFile:getFile())
			oFileSfx112:Close()
			return		
		endif
	end
	
return 