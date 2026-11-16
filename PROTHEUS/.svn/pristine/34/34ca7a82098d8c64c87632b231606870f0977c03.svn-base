#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} SD1100E

Ponto de entrada após a exclusão do documento de entrada, ITEM a ITEM

@author Renato Castro
@since 10/11/2014

/*/
User Function SD1100E()
	local oIdManager := DHLIdManager():newDHLIdManager()
	local cItem := SD1->D1_ITEM
	
	//TODO THIAGO VALIDAR SPL
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		oIdManager:inflowInvoice(DHL_EXCLUSAO,,,,,,cItem)
	endif
	
	U_ExcVinculo()
	
Return
