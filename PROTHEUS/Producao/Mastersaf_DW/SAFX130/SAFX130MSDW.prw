#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx130.ch'
#include 'safx.ch'
#include 'dhl.ch'


/*/{Protheus.doc} SAFX130MSDW

Responsa‡vel por gerar o arquivo SAFX130
	
@author Daniel Braga
@since 30/10/2014
/*/
user function SAFX130MSDW(aCompany,dDtFrom , dDtUntil)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()	
	private lGerouArqs	:= .F.
	default dDtFrom 	:= date()-1
	default dDtUntil 	:= date()-1
	
	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf 	 
			
	SAFX130(dDtFrom , dDtUntil)
			
return lGerouArqs

static function SAFX130(dDtFrom , dDtUntil)
	
	local oFileSfx130 	:= MsafDWFile():newMsafDWFile("130", SAFX130_POSICOES)
	local oIpSqlSfx130 	:= IpSqlObject():newIpSqlObject()
	local oDHLSafx130	:= DHLSafx130():newDHLSafx130()
	local cError		:= ""
	local aFields		:= {}
	local cAlias		:=	""
	local nCount		:= 0
	
	oIpSqlSfx130:newAlias( oDHLSafx130:getSql(dDtFrom , dDtUntil) )
	
	cAlias := oIpSqlSfx130:getAlias()
	nCount := oIpSqlSfx130:count()
	(cAlias)->( DbGoTop() )
	
	while oIpSqlSfx130:notIsEof()
		
		if isInventario(cAlias) .or. isCutover(cAlias, oDHLSafx130)
			oIpSqlSfx130:skip()
			loop
		endIf
		
		oDHLSafx130:initialize(SAFX130_POSICOES,oIpSqlSfx130)
		
		oDHLSafx130:addLine()
		
		aFields := oDHLSafx130:getFields()
		cError	:= oDHLSafx130:validRequired(VLD_FIELD_130)
		
		if !Empty(cError)
			cError += getIdDoc(cAlias)
			oDHLSafx130:addLog(SAFX130_ERROR_TITLE,SAFX130_ERROR_OBRIGAT+cError,oFileSfx130:getFile())
			oIpSqlSfx130:skip()
			loop
		endIf
		
		oFileSfx130:setFields( aFields )
		
		if oFileSfx130:write()
			lGerouArqs := .T.
		else
			oDHLSafx130:addLog(SAFX130_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx130:getFile())
			oIpSqlSfx130:skip()
			loop
		endif

		oIpSqlSfx130:skip()	
	endDo
	
	oIpSqlSfx130:close()
	oFileSfx130:renameArq("130", SAFX130_POSICOES)
	oFileSfx130:close()
	
return

/**
 * Coleta o ID do Documento para o Log de Erros
 */
static function getIdDoc(cAlias)
	
	local cIdDoc := CRLF+CRLF
	
	cIdDoc += "Tipo Documento: "+if((cAlias)->(Val(F3_CFO) >= 500), "Saída", "Entrada")+CRLF
	cIdDoc += "Nota Fiscal: "+(cAlias)->(AllTrim(F3_NFISCAL)+"/"+F3_SERIE)+CRLF
	cIdDoc += "Cliente/Fornecedor: "+(cAlias)->(AllTrim(F3_CLIEFOR)+"-"+F3_LOJA)
	
return cIdDoc

/**
 * Verifica se eh uma NF de Inventario
 */
static function isInventario(cAlias)

	local lInventario := .F.
	local cSerie	  := (cAlias)->(AllTrim(F3_SERIE))
	local cEspecie	  := (cAlias)->(AllTrim(F3_ESPECIE))
	local lSaida	  := (cAlias)->(Val(F3_CFO) >= 500)
	
	if lSaida
		lInventario := (cSerie == DHL_SERIE_INVENTARIO)
	else
		lInventario := (cEspecie == DHL_ESPECIE_INVENTARIO) 
	endIf
	
return lInventario


/**
 * Verifica se eh uma NF de Cutover
 */
static function isCutover(cAlias, oDHLSafx130)

	local lCutover		:= .F.
	local cDoc		 	:= (cAlias)->(AllTrim(F3_NFISCAL))
	local cSer			:= (cAlias)->(AllTrim(F3_SERIE))
	local cCod			:= (cAlias)->(AllTrim(F3_CLIEFOR))
	local cBranch		:= (cAlias)->(AllTrim(F3_LOJA))		
	local cType		  	:= oDHLSafx130:getTypeDoc(cDoc, cSer,cCod,cBranch) 
	
	lCutover := oDHLSafx130:isCutover(cType,cDoc,cSer,cCod,cBranch)
	
return lCutover
