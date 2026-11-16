#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx116.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} SAFX116MSDW

Respons‡vel por gerar o arquivo SAFX116
	
@author Daniel Braga
@since 30/10/2014

/*/
user function SAFX116MSDW(oSqlHeader,oFile,cCusSupDv,cBranch,cDocOri,cSerOri,cItenOri,lCobert,aDocsRef)

	local oFileSfx116 		:= nil
	local oDHLSafx116			:= DHLSafx116():newDHLSafx116()
	local oIpSqlSfx116 		:= IpSqlObject():newIpSqlObject()
	local cError				:= ""
	local aFields				:= {}
	
	default lCobert := .f.
	
	oFileSfx116 := oFile
	
	oDHLSafx116:initialize(SAFX116_POSICOES,oSqlHeader)
	
	oIpSqlSfx116:newAlias(oDHLSafx116:getSql(cCusSupDv,cBranch,cDocOri,cSerOri,cItenOri,lCobert))
	
	oDHLSafx116:setDetailSql(oIpSqlSfx116)
	
	while oIpSqlSfx116:notIsEof()
		
		oDHLSafx116:addLine(lCobert , oIpSqlSfx116)
		
		aFields 	:= oDHLSafx116:getFields()
		aFields[NUM_DOCFIS_REF[1]] 		:= cDocOri
		aFields[SERIE_DOCFIS_REF[1]]	:= cSerOri
		cError		:= oDHLSafx116:validRequired(VLD_116_FIELD)
		
		if (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG .and. lCobert) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_REP)
			if oDHLSafx116:validDocRef(aDocsRef, aFields)
				oIpSqlSfx116:Skip()
				loop 
			endif
		endif
		
		if !Empty(cError)
			oDHLSafx116:addLog(SAFX116_ERROR_TITLE,SAFX116_ERROR_OBRIGAT+cError,oFile:getFile())
			oIpSqlSfx116:Skip()
			loop 
		endIf
		
		oFileSfx116:setFields( aFields )
		aadd(aDocsRef, aClone(aFields))
		
		if !oFileSfx116:write()
			oDHLSafx116:addLog(SAFX116_ERROR_TITLE,ERROR_QTD_CAMPOS,oFile:getFile())
			oIpSqlSfx116:Skip()
			loop		
		endif
		oIpSqlSfx116:Skip()
	endDo	

	oIpSqlSfx116:close()
return 