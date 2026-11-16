#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} MT103LDV

Este ponto de entrada é executado durante o preenchimento da linhas a serem enviadas para a rotina automatica.

@author Thiago Meschiatti
@since 14/11/2014

/*/
User Function MT103LDV() 

	local aItens := PARAMIXB[1]
	local cSD2	 := PARAMIXB[2]
	local aRetIt := {}
	
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "ENTROU NO P.E. MT103LDV", 0, 0, {})
	
	//TODO THIAGO VALIDAR SPL
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		aRetIt := u_procRetNF(aItens, cSD2)
	endif
	
Return(aRetIt)

