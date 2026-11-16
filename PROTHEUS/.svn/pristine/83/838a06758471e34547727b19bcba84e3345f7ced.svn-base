#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx2009.ch'
#include 'safx.ch'
#include 'dhl.ch'


/*/{Protheus.doc} SAFX2009MSDW

Respons‡vel por gerar o arquivo SAfx2009
	
@author Daniel Braga
@since 30/10/2014
/*/
user function SAFX2009MSDW(aCompany)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()	
	private lGerouArqs	:= .F.
	
	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf 			
			
	SAFX2009()
	
return lGerouArqs

static function SAFX2009()

	local oFileSfx2009 	:= MsafDWFile():newMsafDWFile("2009", SAFX2009_POSICOES)
	local oDHLSafx2009	:= DHLSafx2009():newDHLSafx2009()
	local cError		:= ""
	local aFields		:= {}
	local cAlias		:= "ZZ9"
	local nCount		:= 0
	
	dbSelectArea(cAlias)
	(cAlias)->( dbSetOrder(1) ) 
	nCount := (cAlias)->(RecCount())
	(cAlias)->( dbGoTop() )	
	
	while (cAlias)->(!eof())
		
		if (cAlias)->(ZZ9_FILIAL) != xFilial("ZZ9")
			(cAlias)->( DbSkip() )
			loop
		endIf
		
		oDHLSafx2009:initialize(SAFX2009_POSICOES,cAlias)

		oDHLSafx2009:addLine()
		
		if !oDHLSafx2009:validateExport()
			(cAlias)->(Dbskip())
			loop
		endIf
		
		aFields := oDHLSafx2009:getFields()
		cError	:= oDHLSafx2009:validRequired(VLD_FIELD_2009)
		
		if !Empty(cError)
			cError += CRLF+CRLF+"Observação: "+(cAlias)->(AllTrim(ZZ9_CODIGO)+" - "+ZZ9_DESCR)
			oDHLSafx2009:addLog(SAFX2009_ERROR_TITLE, SAFX2009_ERROR_OBRIGAT+cError,oFileSfx2009:getFile())
			(cAlias)->(Dbskip())
			loop
		endIf
		
		oFileSfx2009:setFields( aFields )
		
		if oFileSfx2009:write()
			lGerouArqs := .T.
		else
			oDHLSafx2009:addLog(SAFX2009_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx2009:getFile())
			(cAlias)->(Dbskip())
			loop
		endif
		
		oDHLSafx2009:salveDateExp()
		
		(cAlias)->(DbSkip())	
	endDo
	
	oFileSfx2009:renameArq("2009", SAFX2009_POSICOES)
	oFileSfx2009:Close()
	
return