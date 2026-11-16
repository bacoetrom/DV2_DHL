#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx2007.ch'
#include 'safx.ch'
#include 'dhl.ch'


/*/{Protheus.doc} SAFX2007MSDW

Respons‡vel por gerar o arquivo SAFX2007
	
@author Daniel Braga
@since 30/10/2014
/*/
user function SAFX2007MSDW(aCompany)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()	
	private lGerouArqs	:= .F.
	
	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf
	
	SAFX2007()
	
return lGerouArqs

static function SAFX2007()

	local oFileSfx2007 	:= MsafDWFile():newMsafDWFile("2007", SAFX2007_POSICOES)
	local oDHLSafx2007	:= DHLSafx2007():newDHLSafx2007()
	local cError		:= ""
	local aFields		:= {}
	local cAlias		:= "SAH"
	local nCount		:= 0 
	local lInJob		:= Type("oMainWnd") != "O"
	
	DbSelectArea(cAlias)
	(cAlias)->(dbSetOrder(1))
	nCount := (cAlias)->(recCount())
	(cAlias)->(DbGoTop())	

	while (cAlias)->(!EOF())
		
		if (cAlias)->(AH_FILIAL) != xFilial("SAH") 
			(cAlias)->( DbSkip() )
			loop
		endIf
		
		oDHLSafx2007:initialize(SAFX2007_POSICOES,cAlias)	
		
		if lInJob .and. !Empty(oDHLSafx2007:getFieldValue("AH_ZZMSDW"))
			(cAlias)->( DbSkip() )
			loop
		endIf
		
		oDHLSafx2007:addLine()
		
		aFields := oDHLSafx2007:getFields()
		cError	:= oDHLSafx2007:validRequired(VLD_FIELD_2007)
		
		if !Empty(cError)
			oDHLSafx2007:addLog(SAFX2007_ERROR_TITLE,SAFX2007_ERROR_OBRIGAT+cError,oFileSfx2007:getFile())
			(cAlias)->( DbSkip() )
			loop
		endIf
		
		oFileSfx2007:setFields( aFields )
		
		if oFileSfx2007:write()
			lGerouArqs := .T.
		else	
			oDHLSafx2007:addLog(SAFX2007_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx2007:getFile())
			(cAlias)->( DbSkip() )
			loop		
		endif
		
		oDHLSafx2007:salveDateExp()

		(cAlias)->( DbSkip() )
	endDo
	
	oFileSfx2007:renameArq("2007", SAFX2007_POSICOES)
	oFileSfx2007:close()
	
    
return