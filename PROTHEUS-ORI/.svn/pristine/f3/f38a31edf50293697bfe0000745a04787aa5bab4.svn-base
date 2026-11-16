#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} M410LIOK

Validação de linha de pedido

@author Thiago Meschiatti
@since 05/11/2014

@return lógico Se linha é valida ou não.
/*/
User Function M410LIOK()
	local lRet	:= .t.
	local lAuto	   := IsBlind()
	
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		
		if lAuto
			lRet := .t.
		else
			lRet	:= u_DHLValidID("DHL_FIELD_REQUIRED", "C6_ZZID")
			
			if lRet
				lRet	:= u_DHLValidID("DHL_VLD_DUPLIC_LINE", "C6_ZZID")
			endif
			
			if lRet
				lRet	:= u_DHLValidID("DHL_EXIST_ID", "C6_ZZID")
				
			endif
		endif
	endif
	
Return (lRet)

