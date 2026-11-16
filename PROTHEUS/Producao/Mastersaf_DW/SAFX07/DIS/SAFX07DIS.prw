#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx07.ch'
#include 'safx08.ch'
#include 'safx112.ch'
#include 'safx116.ch'
#include 'safx.ch'
#include "dhl.ch"

/*/{Protheus.doc} SAFX07MSDW

Respons‡vel por gerar o arquivo SAFX07
	
@author Daniel Braga
@since 30/10/2014
/*/
user function SAFX07DIS(aCompany, nType, dDtFrom, dDtUntil)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()
	private lGerouArqs	:= .F.		
	default nType 		:= 3
	default dDtFrom 	:= date()
	default dDtUntil	:= date() 

	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf 
			
	SAFX07(nType,dDtFrom , dDtUntil)
		
return lGerouArqs

/**
 * Processa a Geracao dos Arquivos
 */
static function SAFX07(nType,dDtFrom , dDtUntil)

	local oFileSfx07 	:= MsafDWFile():newMsafDWFile("07"  ,SAFX07_POSICOES)
	local oFlSfx08 		:= MsafDWFile():newMsafDWFile("08"  ,SAFX08_POSICOES)
	local oFlSfx112 	:= MsafDWFile():newMsafDWFile("112" ,SAFX112_POSICOES)
	local oFlSfx116 	:= MsafDWFile():newMsafDWFile("116" ,SAFX116_POSICOES)
	local oIpSqlSfx07 	:= IpSqlObject():newIpSqlObject()
	local oDHLSafx07	:= nil
	local cError		:= ""
	local cAlias		:= ""
	local aFields		:= {}
	local aDocsRef		:= {}
	local nCount        := 0
	
	
	default nType		:= 0
	default dDtFrom		:= stod("")
	default dDtUntil 	:= stod("")
	
	oDHLSafx07 := DHLSafx07Dis():newDHLSafx07Dis()	
	
	oIpSqlSfx07:newAlias( oDHLSafx07:getSql(nType,dDtFrom , dDtUntil) )
	
	cAlias := oIpSqlSfx07:getAlias()
	nCount := oIpSqlSfx07:count()
	(cAlias)->( DbGoTop() )
	
	while oIpSqlSfx07:notIsEof()
		
		if isInventario(cAlias, oDHLSafx07)  .or. isCutover(cAlias, oDHLSafx07)
			oIpSqlSfx07:skip()	
			loop
		endIf
		
		oDHLSafx07:initialize(SAFX07_POSICOES,oIpSqlSfx07)
		
		oDHLSafx07:addLine()
		
		aFields := oDHLSafx07:getFields()
		cError	:= oDHLSafx07:validRequired(VLD_07_FIELD)
		
		if !Empty(cError)
			cError += getIdDoc(cAlias, oDHLSafx07)
			oDHLSafx07:addLog(SAFX07_ERROR_TITLE,SAFX07_ERROR_OBRIGAT+cError,oFileSfx07:getFile())
			oIpSqlSfx07:skip()
			loop
		endIf
		
		oFileSfx07:setFields( aFields )
		
		if oFileSfx07:write()
			lGerouArqs	:= .T.
		else
			oDHLSafx07:addLog(SAFX07_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx07:getFile())
			oIpSqlSfx07:skip()
			loop
		endif
		if !(oDHLSafx07:isDocSupplier())
			U_SAFX08DIS(oIpSqlSfx07 ,@oFlSfx08,@oFlSfx116,@aDocsRef)
		endif
		U_SAFX112DIS(oIpSqlSfx07,@oFlSfx112)
						
		oIpSqlSfx07:skip()	
	endDo
	
	oIpSqlSfx07:close()	
	oFileSfx07:renameArq("07"  ,SAFX07_POSICOES)
	oFileSfx07:close()
	oFlSfx08:renameArq("08"  ,SAFX08_POSICOES)
	oFlSfx08:close()
	oFlSfx112:renameArq("112" ,SAFX112_POSICOES)
	oFlSfx112:close()
	oFlSfx116:renameArq("116" ,SAFX116_POSICOES)
	oFlSfx116:close()
	
return

/**
 * Coleta o ID do Documento para o Log de Erros
 */
static function getIdDoc(cAlias, oDHLSafx07)
	
	local cIdDoc	:= CRLF+CRLF
	local cDoc		:= (cAlias)->(AllTrim(F3_NFISCAL))
	local cSer		:= (cAlias)->(AllTrim(F3_SERIE))
	local cCod		:= (cAlias)->(AllTrim(F3_CLIEFOR))
	local cBranch	:= (cAlias)->(AllTrim(F3_LOJA))		
	local lSaida	:= iif(oDHLSafx07:getTypeDoc(cDoc, cSer,cCod,cBranch) == '1', .T., .F.)
	
	cIdDoc += "Tipo Documento: "+if(lSaida, "Saída", "Entrada")+CRLF
	cIdDoc += "Nota Fiscal: "+(cAlias)->(AllTrim(F3_NFISCAL)+"/"+F3_SERIE)+CRLF
	cIdDoc += "Cliente/Fornecedor: "+(cAlias)->(AllTrim(F3_CLIEFOR)+"-"+F3_LOJA)
	
return cIdDoc

/**
 * Verifica se eh uma NF de Inventario
 */
static function isInventario(cAlias, oDHLSafx07)

	local lInventario	:= .F.
	local cSerie	  	:= (cAlias)->(AllTrim(F3_SERIE))
	local cEspecie	  	:= (cAlias)->(AllTrim(F3_ESPECIE))
	local cDoc		 	:= (cAlias)->(AllTrim(F3_NFISCAL))
	local cSer			:= (cAlias)->(AllTrim(F3_SERIE))
	local cCod			:= (cAlias)->(AllTrim(F3_CLIEFOR))
	local cBranch		:= (cAlias)->(AllTrim(F3_LOJA))		
	local lSaida	  	:= iif(oDHLSafx07:getTypeDoc(cDoc, cSer,cCod,cBranch) == '1', .T., .F.)
	
	if lSaida
		lInventario := (cSerie == DHL_SERIE_INVENTARIO)
	else
		lInventario := (cEspecie == DHL_ESPECIE_INVENTARIO) 
	endIf
	
return lInventario


/**
 * Verifica se eh uma NF de Cutover
 */
static function isCutover(cAlias, oDHLSafx07)

	local lCutover		:= .F.
	local cDoc		 	:= (cAlias)->(AllTrim(F3_NFISCAL))
	local cSer			:= (cAlias)->(AllTrim(F3_SERIE))
	local cCod			:= (cAlias)->(AllTrim(F3_CLIEFOR))
	local cBranch		:= (cAlias)->(AllTrim(F3_LOJA))		
	local cType		  	:= oDHLSafx07:getTypeDoc(cDoc, cSer,cCod,cBranch)
	
	lCutover := oDHLSafx07:isCutover(cType,cDoc,cSer,cCod,cBranch)
	
return lCutover
