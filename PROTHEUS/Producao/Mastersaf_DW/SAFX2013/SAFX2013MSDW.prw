#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx2013.ch'
#include 'safx.ch'
#include 'dhl.ch'


/*/{Protheus.doc} SAFX2013MSDW

Responsa‡vel por gerar o arquivo SAFX2013
	
@author Daniel Braga
@since 30/10/2014
/*/
user function SAFX2013MSDW(aCompany)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()	
	private lGerouArqs	:= .F.
	
	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf  
			
	SAFX2013()
				
return lGerouArqs

static function SAFX2013()

	local oFileSfx2013 	:= MsafDWFile():newMsafDWFile("2013", SAFX2013_POSICOES)
	local oDHLSafx2013	:= DHLSafx2013():newDHLSafx2013()
	local cError		:= ""
	local aFields		:= {}
	local cTable		:= "SB1"
			
	dbSelectArea(cTable)
	(cTable)->( dbSetOrder(1) ) 
	nCount := (cTable)->(recCount())
	(cTable)->( dbGoTop() )	
	
	while (cTable)->(!eof())
	
		if (cTable)->(B1_MSBLQL) == SAFX2013_PROD_ATIVO
		
			if (cTable)->(B1_FILIAL) != xFilial("SB1") 
				(cTable)->( DbSkip() )
				loop
			endIf
			
			oDHLSafx2013:initialize(SAFX2013_POSICOES,Upper(cTable))
			
			oDHLSafx2013:addLine()
			
			if !oDHLSafx2013:validateExport()
				(cTable)->(DbSkip())
				loop
			endIf
			
			aFields := oDHLSafx2013:getFields()
			cError	:= oDHLSafx2013:validRequired(VLD_FIELD_2013)
			
			if !Empty(cError)
				cError += CRLF+CRLF+"Produto: "+(cTable)->(AllTrim(B1_COD)+" - "+B1_DESC)
				oDHLSafx2013:addLog(SAFX2013_ERROR_TITLE,SAFX2013_ERROR_OBRIGAT+cError,oFileSfx2013:getFile())
				(cTable)->(DbSkip())
				loop
			endIf
			
			oFileSfx2013:setFields( aFields )
			
			if oFileSfx2013:write()
				lGerouArqs := .T.
			else	
				oDHLSafx2013:addLog(SAFX2013_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx2013:getFile())
				(cTable)->(DbSkip())
				loop
			endif
			
			oDHLSafx2013:salveDateExp()
		endif
		
		(cTable)->(DbSkip())	
	endDo
	oFileSfx2013:renameArq("2013", SAFX2013_POSICOES)
	oFileSfx2013:close()
	
return