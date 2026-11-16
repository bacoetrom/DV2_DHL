#include 'Protheus.ch'

/*/{Protheus.doc}	A140ALT

Ponto de entrada na alteração da pré nota
	
@author				Renato Castro
@since				22/10/2014

@return				logic	Indica se a pré nota pode ser alterada

/*/
User Function A140ALT()

	local lRetorno			:= .T.
	local oDHLProcValid		:= DHLProcessValidator():newDHLProcessValidator()
	
	oDHLProcValid:inflowPreInvoiceValidate()
	lRetorno := oDHLProcValid:isAllowedAlter()
	
Return(lRetorno)
