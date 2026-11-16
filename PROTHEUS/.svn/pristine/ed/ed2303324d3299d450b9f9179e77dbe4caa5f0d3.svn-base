#include 'protheus.ch'
#include 'dhl.ch'

/*/{Protheus.doc} MT120OK
PE para validar inclusão do Pedido de Compra
@author Thiago Meschiatti
@since 12/09/2016
@version undefined

@return lógico, se permite ou não a gravação do pedido

@type function
/*/
user function MT120OK()
	local lRet := .t.

	if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		if INCLUI
			lRet := u_ValidIncPO()
		endif
	endif
	
return (lRet)