#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx116.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} SAFX116AGE

Respons‡vel por gerar o arquivo SAFX116
	
@author Thiago Meschiatti
@since 05/09/2016

/*/
user function AGL116(oSqlHeader,oFile,cCusSupDv,cBranch,cDocOri,cSerOri,cItenOri,lCobert,aDocsRef,oDHLSafx07,cOrigem)

	local oFileSfx116 		:= nil
	local oDHLSafx116		:= DHLAGL116():newDHLAGL116()
	local oIpSqlSfx116 		:= IpSqlObject():newIpSqlObject()
	local cError			:= ""
	local aFields			:= {}
	
	default lCobert := .f.
	default cOrigem := ""
	
	oFileSfx116 := oFile
	
	oDHLSafx116:initialize(SAFX116_POSICOES,oSqlHeader)
	
	//xxx := oDHLSafx116:getSql(cCusSupDv,cBranch,cDocOri,cSerOri,cItenOri,lCobert,oDHLSafx07,cOrigem)

	oIpSqlSfx116:newAlias(oDHLSafx116:getSql(cCusSupDv,cBranch,cDocOri,cSerOri,cItenOri,lCobert,oDHLSafx07,cOrigem))
	
	oDHLSafx116:setDetailSql(oIpSqlSfx116)
	
	while oIpSqlSfx116:notIsEof()
		
		oDHLSafx116:addLine(lCobert, oDHLSafx07, oIpSqlSfx116)
		
		aFields 	:= oDHLSafx116:getFields()
		aFields[NUM_DOCFIS_REF[1]] 		:= cDocOri
		aFields[SERIE_DOCFIS_REF[1]]	:= cSerOri
		cError		:= oDHLSafx116:validRequired(VLD_116_FIELD)
		
		if (FWUnitBusiness() == DHL_BUSINESSUNIT_AGE .or. FWUnitBusiness() == DHL_BUSINESSUNIT_REP .or. FWUnitBusiness() == DHL_BUSINESSUNIT_AGL /*.and. lCobert Alterado por Thiago Meschiatti */)
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
