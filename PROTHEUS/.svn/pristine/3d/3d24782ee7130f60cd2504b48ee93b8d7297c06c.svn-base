#include "totvs.ch"
#include "dhl.ch"


/*/{Protheus.doc} MT440AT

Ponto de Entrada para Validação da Liberação de Pedidos de Vendas
	
@author Victor Hugo
@since 24/11/2014
/*/
user function MT440AT()
	
	local lOk := .T.
	
	if (cEmpAnt == "99" .or. FwUnitBusiness() == DHL_BUSINESSUNIT_SPL)
		if ExistBlock("DHLSelPE")
			lOk := u_DHLSelPE("MT440AT")
		endif
	endif
	
return lOk