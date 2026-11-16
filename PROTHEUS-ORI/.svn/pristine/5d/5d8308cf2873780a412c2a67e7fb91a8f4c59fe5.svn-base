#include 'protheus.ch'
#include 'dhl.ch'

user function MT140TOK()
	local lRet := .t.

	if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		if INCLUI .or. ALTERA
			lRet := u_VldLote()
		endif					
	endif
	
return (lRet)