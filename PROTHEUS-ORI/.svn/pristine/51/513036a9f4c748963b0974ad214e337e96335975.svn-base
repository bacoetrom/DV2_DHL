#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} A103CLAS

Ponto de Entrada que permite manipular o item do aCols      
	
@author Thiago Meschiatti
@since 25/11/2014

/*/
User Function A103CLAS()

	local cAliasSD1 := PARAMIXB[1]

	if FWUnitBusiness() != DHL_BUSINESSUNIT_SPL
		if ExistBlock("ProcTesIn")
			u_ProcTesIn(cAliasSD1)
		endif
		if (FWUnitBusiness(cAliasSD1) = DHL_BUSINESSUNIT_DIS) .or. (FWUnitBusiness(cAliasSD1) = DHL_BUSINESSUNIT_MUL)
			u_ProcDtFabric(cAliasSD1)
		endif
	endif

return