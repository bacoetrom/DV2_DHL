#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx2006.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} SAFX2006MSDW

Respons‡vel por gerar o arquivo SAFX2006
	
@author Daniel Braga
@since 30/10/2014

/*/
user function SAFX2006MSDW(aCompany,dDtUser)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()	
	private lGerouArqs	:= .F.
	
	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf
				
	SAFX2006(dDtUser)
		
return lGerouArqs

static function SAFX2006(dDtUser)

	local oFileSfx2006 	:= MsafDWFile():newMsafDWFile("2006", SAFX2006_POSICOES)
	local oDHLSafx2006	:= DHLSafx2006():newDHLSafx2006()
	local cError		:= ""
	local aFields		:= {}
	local cAlias		:= "CD1"
	local nCount		:= 0
	local lInJob		:= Type("oMainWnd") != "O"
	
	DbSelectArea(cAlias)
	(cAlias)->(dbSetOrder(1))
	nCount := (cAlias)->(recCount())
	(cAlias)->(DbGoTop())	
	
	while (cAlias)->(!eof())		
		
		if (cAlias)->(CD1_FILIAL) != xFilial("CD1")
			(cAlias)->( DbSkip() )
			loop
		endIf
		
		oDHLSafx2006:initialize(SAFX2006_POSICOES,cAlias)		
		
		if lInJob .and. !Empty(oDHLSafx2006:getFieldValue("CD1_ZZMSDW"))
			(cAlias)->( DbSkip() )
			loop
		endIf		
		
		oDHLSafx2006:addLine(dDtUser)
		
		aFields := oDHLSafx2006:getFields()
		cError	:= oDHLSafx2006:validRequired(VLD_FIELD_2006)
		
		if !Empty(cError)
			cError += CRLF+CRLF+"Natureza de Operação: "+(cAlias)->(AllTrim(CD1_CODNAT)+" - "+CD1_DESCR)
			oDHLSafx2006:addLog(SAFX2006_ERROR_TITLE,SAFX2006_ERROR_OBRIGAT+cError,oFileSfx2006:getFile())
			(cAlias)->( DbSkip() )
			loop
		endIf
		
		oFileSfx2006:setFields( aFields )
		
		if oFileSfx2006:write()
			lGerouArqs := .T.
		else	
			oDHLSafx2006:addLog(SAFX2006_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx2006:getFile())
			(cAlias)->( DbSkip() )
			loop		
		endif

		oDHLSafx2006:salveDateExp()
		
		(cAlias)->( DbSkip() )
	endDo
	
	oFileSfx2006:renameArq("2006", SAFX2006_POSICOES)
	oFileSfx2006:close()
	
return
