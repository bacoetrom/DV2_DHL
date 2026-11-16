#Include 'Totvs.ch'
#Include 'DHL.ch'

/*/{Protheus.doc} IPDESTNFE
		Ponto de Entrada para alterar o CNPJ do destinatário da NFe
		
		@type		Function
		@author 	Julio Lisboa
		@since 		19/08/2016
		@return		cCNPJ, Novo CNPJ a ser considerado
/*/
User Function IPDESTNFE()

	Local cCNPJ		:= PARAMIXB[01]
	Local cNewCNPJ	:= ""
	
	If (FWUnitBusiness() == DHL_BUSINESSUNIT_AGE) .or.(FWUnitBusiness() == DHL_BUSINESSUNIT_AG2) .or.(FWUnitBusiness() == DHL_BUSINESSUNIT_AGL)
		cNewCNPJ		:= GetNewPar("ZZ_CNPJAG","")
		cCNPJ			:= cNewCNPJ
	EndIf
	
Return (cCNPJ)
