#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} MT410TOK

Validar confirmação da operação

@author Thiago Meschiatti
@since 10/11/2014

@return lógico Se valida a operação ou não.
/*/
User Function MT410TOK()
	local nOpt	:= PARAMIXB[1]
	local lRet	:= .t.
	local lAuto	   := IsBlind()

	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		if INCLUI .or. ALTERA
			if ExistBlock("VldIdEnd")
				if lAuto
					lRet := .t.
				else
					lRet := u_VldIdEnd(DHL_NF_SAIDA)
				endif
			endif
		endif
	elseif FwUnitBusiness() == DHL_BUSINESSUNIT_PKG
		if !(INCLUI) .AND. !(ALTERA)
			lRet := u_ProcCancEmb()
		endif		
	endif
	
Return (lRet)

