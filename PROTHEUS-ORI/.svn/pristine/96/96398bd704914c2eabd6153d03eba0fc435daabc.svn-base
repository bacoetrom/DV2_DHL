#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} SD1140I

Ponto de entrada após a gravação da pré nota, ITEM A ITEM
	
@author Renato Castro
@since 06/11/2014

/*/
User Function SD1140I()

	if (FWUnitBusiness() != DHL_BUSINESSUNIT_REV .and. FWUnitBusiness() != DHL_BUSINESSUNIT_REP .and. !(FWUnitBusiness() == DHL_BUSINESSUNIT_AGL .and. isRepair(SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_TIPO)))
		U_VincCobert()
	endif

Return

/**
* Verifica se o depositante é do tipo Reparador
**/
static function isRepair(cClieFor,cLoja,cTipo)
	local oSqlUtil		:= IpSqlObject():newIpSqlObject()
	local lRet	 		:= .f.
	
	if AllTrim(cTipo) $ "D/B"
		oSqlUtil:newTable("SA1", "A1_COD, A1_LOJA, A1_ZZREPAR", "A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '" + cClieFor + "' AND A1_LOJA = '" + cLoja + "' ")
		if oSqlUtil:hasRecords()
			if oSqlUtil:getValue("A1_ZZREPAR") == "S"
				lRet := .t.
			endIf
		endIf
	else
		oSqlUtil:newTable("SA2", "A2_COD, A2_LOJA, A2_ZZREPAR", "A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = '" + cClieFor + "' AND A2_LOJA = '" + cLoja + "' ")
		if oSqlUtil:hasRecords()
			if oSqlUtil:getValue("A2_ZZREPAR") == "S"
				lRet := .t.
			endIf
		endIf
	endIf
	oSqlUtil:close()

return lRet
