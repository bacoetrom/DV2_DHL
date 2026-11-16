#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} MT410ALT

PE Está localizado na rotina de alteração do pedido.

@author Thiago Meschiatti
@since 18/11/2014

/*/
User Function MT410ALT()
	
	if (cEmpAnt == "99" .or. FWUnitBusiness() == DHL_BUSINESSUNIT_SPL)
		if ExistBlock("ProcGrvImp")
			u_ProcGrvImp()
		endif
	endif
	
	if FWUnitBusiness() != DHL_BUSINESSUNIT_REV
		if ExistBlock("DHLSelPE")
			u_DHLSelPE("MT410ALT")
		endif
	endif
return