#Include 'Protheus.ch'
#Include 'dhl.ch'


User Function MT100TOK()
	local lRet		:= .t.
	local lAuto	   	:= IsBlind()
	local lValidTax := GetNewPar("ZZ_VALVIMP", .F.)	
	
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "ENTROU NO P.E. MT100TOK", 0, 0, {})
	
	if lValidTax
		if ALTERA
			if ExistBlock("ValidTaxes")
				lRet := u_ValidTaxes()
			endif
		endif
	endif
	
	if lRet
		if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL	
			if !lAuto
				if INCLUI .or. ALTERA
					if ExistBlock("VldIdEnd")
						lRet := u_VldIdEnd(DHL_NF_ENTRADA)
					endif
				endif
			endif
		endif
	endif
	
Return (lRet)

