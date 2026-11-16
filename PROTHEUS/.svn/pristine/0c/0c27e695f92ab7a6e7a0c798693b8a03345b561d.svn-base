#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx112.ch'
#include 'safx.ch'


/*/{Protheus.doc} SAFX112DIS

Respons‡vel por gerar o arquivo SAFX112
	
@author Thiago Meschiatti
@since 15/07/2016

/*/
user function SAFX112DIS(oSqlHeader,oFile)

	local oFileSfx112 		:= nil
	local oDHLSafx112		:= DHLSafx112Dis():newDHLSafx112Dis()
	local cError			:= ""
	local aFields			:= {}
	local lContinue			:= .t.
	local cTypeMsg			:= "01"
		
	oFileSfx112 := oFile
	
	oDHLSafx112:initialize(SAFX112_POSICOES,oSqlHeader)	
	while lContinue
		lContinue := oDHLSafx112:addLine(@cTypeMsg)
		   
		aFields 	:= oDHLSafx112:getFields()
		cError		:= oDHLSafx112:validRequired(VLD_112_FIELD)
		
		if !Empty(cError)
			oDHLSafx112:addLog(SAFX112_ERROR_TITLE,SAFX112_ERROR_OBRIGAT+cError,oFile:getFile())
			oFileSfx112:Close()
			return 
		endIf
		
		oFileSfx112:setFields( aFields )
		
		if !oFileSfx112:write()
			oDHLSafx112:addLog(SAFX112_ERROR_TITLE,ERROR_QTD_CAMPOS,oFile:getFile())
			oFileSfx112:Close()
			return		
		endif
	end
	
return 