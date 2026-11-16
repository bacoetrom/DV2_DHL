#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} MT410INC

Está localizado na rotina de alteração do pedido.

@author Thiago Meschiatti
@since 18/11/2014

/*/
User Function MT410INC()
	
	//TODO THIAGO VALIDAR SPL
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		if ExistBlock("ProcGrvImp")
			u_ProcGrvImp()
		endif
	endif
	
Return()
