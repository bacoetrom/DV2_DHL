#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx128.ch'
#include 'safx.ch'
#include 'dhl.ch'


/*/{Protheus.doc} SAFX128MSDW

Respons‡vel por gerar o arquivo SAFX128
	
@author Daniel Braga
@since 30/10/2014
/*/
user function SAFX128MSDW(aCompany)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()	
	private lGerouArqs	:= .F.
	
	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf 
			
	SAFX128()
				
return lGerouArqs

static function SAFX128()

	local oFileSfx128 	:= MsafDWFile():newMsafDWFile("128", SAFX128_POSICOES)
	local oDHLSafx128	:=  DHLSafx128():newDHLSafx128()
	local cError		:= ""
	local aFields		:= {}
	local cAlias		:= "SB1"
	local nCount		:= 0
		
	dbSelectArea(cAlias)
	(cAlias)->( dbSetOrder(1) ) 
	nCount := (cAlias)->(RecCount())
	(cAlias)->( dbGoTop() )	
	
	while (cAlias)->(!eof())
	
		if (cAlias)->(B1_MSBLQL) == SAFX128_PROD_ATIVO
		
			if (cAlias)->(B1_FILIAL) != xFilial("SB1") 
				(cAlias)->( DbSkip() )
				loop
			endIf
			
			oDHLSafx128:initialize(SAFX128_POSICOES,cAlias)
	
			oDHLSafx128:addLine()
			
			if !oDHLSafx128:validateExport()
				(cAlias)->(Dbskip())
				loop
			endIf
			
			aFields := oDHLSafx128:getFields()
			cError	:= oDHLSafx128:validRequired(VLD_FIELD_128)
			
			if !Empty(cError)
				cError += CRLF+CRLF+"Produto: "+(cAlias)->(AllTrim(B1_COD)+" - "+B1_DESC)
				oDHLSafx128:addLog(SAFX128_ERROR_TITLE,SAFX128_ERROR_OBRIGAT+cError,oFileSfx128:getFile())
				(cAlias)->(Dbskip())
				loop
			endIf
			
			oFileSfx128:setFields( aFields )
			
			if oFileSfx128:write()
				lGerouArqs := .T.
			else
				oDHLSafx128:addLog(SAFX128_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx128:getFile())
				(cAlias)->(Dbskip())
				loop
			endif
			
			oDHLSafx128:salveDateExp("ZZMSDW2")
		endif
		
		(cAlias)->(DbSkip())	
	endDo
	
	oFileSfx128:renameArq("128", SAFX128_POSICOES)
	oFileSfx128:Close()
	
return