#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx.ch'
#include 'safx10.ch' 
#include 'dhl.ch' 

/*/{Protheus.doc} SAFX10DIS

Respons‡vel por gerar o arquivo SAFX10
	
@author Thiago Meschiatti
@since 22/07/2016

/*/
user function SAFX10DIS(aCompany,dDtFrom,dDtUntil)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()
	private lGerouArqs	:= .F.
	default aCompany	:=  {}	
	default dDtFrom 	:= ctod("01/"+ cValToChar(Month(Date()-1)) + "/" + cValToChar(Year(Date()-1)))
	default dDtUntil	:= Date()-1
	
	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf
	 				
	SAFX10(dDtFrom, dDtUntil)	
	
return lGerouArqs

static function SAFX10(dDtFrom,dDtUntil)

	local oFileSfx10 	:= MsafDWFile():newMsafDWFile("10", SAFX10_POSICOES)
	local oIpSqlSfx10 	:= IpSqlObject():newIpSqlObject()
	local oDHLSafx10	:= DHLSafx10Dis():newDHLSafx10Dis()
	local aFields		:= {}
	local cError		:= ""
	local cAlias		:= ""
	local nCount		:= 0 	
	default dDtFrom 	:= ctod("/ /")
	default dDtUntil	:= ctod("/ /")
			
	oIpSqlSfx10:newAlias( oDHLSafx10:getSql(dDtFrom,dDtUntil) )
	
	cAlias := oIpSqlSfx10:getAlias()
	nCount := oIpSqlSfx10:count()
	(cAlias)->( DbGoTop() )
	
	while oIpSqlSfx10:notIsEof()
		
		oDHLSafx10:initialize(SAFX10_POSICOES,oIpSqlSfx10)
			
		oDHLSafx10:addLine()
		
		aFields := oDHLSafx10:getFields()
		cError	:= oDHLSafx10:validRequired(VLD_FIELD_10)
		
		if !Empty(cError)
			cError += getIdMovimento(oDHLSafx10)
			oDHLSafx10:addLog(SAFX10_ERROR_TITLE,SAFX10_ERROR_OBRIGAT+cError,oFileSfx10:getFile())
			oIpSqlSfx10:skip()
			loop
		endIf
		
		oFileSfx10:setFields( aFields )
		
		if oFileSfx10:write()
			lGerouArqs := .T.
		else
			oDHLSafx10:addLog(SAFX10_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx10:getFile())
			oIpSqlSfx10:skip()
			loop		
		endif

		oIpSqlSfx10:skip()	
	endDo
	oIpSqlSfx10:close()
	oFileSfx10:renameArq("10", SAFX10_POSICOES)
	oFileSfx10:close()
return 

	
/**
 * Coleta o ID do Movimento para o Log de Erros
 */
static function getIdMovimento(oDHLSafx10)
	
	local cIdMov  := CRLF+CRLF
	local cTpMov  := ""
	local cTabela := Upper(oDHLSafx10:getFieldValue("ARQ")) 
	local cDoc	  := AllTrim(oDHLSafx10:getFieldValue("NUM_DOCTO"))
	local cSerie  := oDHLSafx10:getFieldValue("SERIE_DOCFIS")
	local dData	  := StoD(oDHLSafx10:getFieldValue("DATA_MOVTO"))
	
	if (cTabela == "SD1")
		cTpMov := "NF Entrada"
	elseIf (cTabela == "SD2")
		cTpMov := "NF Saida"
	elseIf (cTabela == "SD3")
		cTpMov := "Movimento Interno"	
	endIf	
	
	if !Empty(cSerie)
		cDoc += "/"+cSerie
	endIf
	
	cIdMov += "Tipo Movimento: "+cTpMov+CRLF
	cIdMov += "Documento: "+cDoc+CRLF
	cIdMov += "Data: "+DtoC(dData)
	
return cIdMov
	