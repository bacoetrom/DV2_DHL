#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} MT120ALT
(long_description)
@author Thiago Meschiatti
@since 16/05/2016
@version 1.0
@return ${return}, ${return_description}
/*/
User Function MT120ALT()
	local lRet			:= .t.
	local nOperation	:= PARAMIXB[1]
	local oDHLProcValid	:= nil

	if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		if nOperation == DHL_OPC_ALTERACAO .or. nOperation == DHL_OPC_EXCLUSAO
			oDHLProcValid	:= DHLProcessValidator():newDHLProcessValidator()
			lRet := oDHLProcValid:validDelUpdPO(nOperation)
		endif
	endif

Return lRet

