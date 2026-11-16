#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx2017.ch'
#include 'safx.ch'
#include 'dhl.ch'
   
/*/{Protheus.doc} SAFX2017MSDW

Respons‡vel por gerar o arquivo SAFX2017
	
@author Daniel Braga
@since 30/10/2014
/*/
user function SAFX2017MSDW(aCompany)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()	
	private lGerouArqs	:= .F.
	
	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf 	 
			
	SAFX2017()
	
return lGerouArqs

static function SAFX2017()

	local oFileSfx2017 	:= MsafDWFile():newMsafDWFile("2017", SAFX2017_POSICOES)
	local oDHLSafx2017	:= DHLSafx2017():newDHLSafx2017()
	local cError		:= ""
	local aFields		:= {}
	local cAlias		:= "SAH"
	local nCount		:= 0
	local lInJob		:= Type("oMainWnd") != "O"
	
	dbSelectArea(cAlias)
	(cAlias)->( dbSetOrder(1))
	(cAlias)->(dbGotop())
	nCount	:= (cAlias)->(recCount())

	while (cAlias)->( !eof() )
		
		if (cAlias)->(AH_FILIAL) != xFilial("SAH") 
			(cAlias)->( DbSkip() )
			loop
		endIf
		
		oDHLSafx2017:initialize(SAFX2017_POSICOES,cAlias)
		
		if lInJob .and. !Empty(oDHLSafx2017:getFieldValue("AH_ZZMSDW2"))
			(cAlias)->( DbSkip() )
			loop
		endIf
		
		oDHLSafx2017:addLine()
		
		aFields := oDHLSafx2017:getFields()
		cError	:= oDHLSafx2017:validRequired(VLD_FIELD_2017)
		
		if !Empty(cError)
			oDHLSafx2017:addLog(SAFX2017_ERROR_TITLE,SAFX2017_ERROR_OBRIGAT+cError,oFileSfx2017:getFile())
			(cAlias)->( DbSkip()	)
			loop
		endIf
		
		oFileSfx2017:setFields( aFields )
		
		if oFileSfx2017:write()
			lGerouArqs := .T.
		else	
			oDHLSafx2017:addLog(SAFX2017_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx2017:getFile())
			(cAlias)->(DbSkip()	)
			loop
		endif
		
		oDHLSafx2017:salveDateExp("ZZMSDW2")
		
		(cAlias)->( DbSkip()	)
	endDo
	
	oFileSfx2017:renameArq("2017", SAFX2017_POSICOES)
	oFileSfx2017:close()
	
return