#include 'protheus.ch'
#include 'parmtype.ch'
#include 'dhl.ch'

/*/{Protheus.doc} Item_PE
Ponto de entrada referente ao fonte MATA010 em MVC
@author gusluiz_supplier
@since 01/07/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function Item()

	local xRet := .T.

	if FWUnitBusiness() == DHL_BUSINESSUNIT_AGE .or. FWUnitBusiness() == DHL_BUSINESSUNIT_AGL

		xRet := geraArqItemMaintence()

	endIf

Return xRet

/**
* Gera o arquivo ItemMaintence
**/
static function geraArqItemMaintence()

	Local aParam 	:= PARAMIXB
	Local xRet 		:= .T.
	Local oObj 		:= ""
	Local cIdPonto 	:= ""
	Local cIdModel 	:= ""	
	Local cMsg 		:= ""
	Local nOper 	:= -1 

	If aParam != NIL

		oObj 		:= aParam[1]
		cIdPonto 	:= aParam[2]
		cIdModel 	:= aParam[3]

		if cIdPonto == "MODELCOMMITNTTS"
			nOper := oObj:nOperation 

			if nOper == 3 .or. nOper == 4

				// Inicio Customização TOTVS IP Solicitação Sr. Adriano Louzada inclusão das TAGS
				// PROGRAM CLIENT e PROGRAM CLIENT_CNPJ - 17/05/2021

				if FWUnitBusiness() == DHL_BUSINESSUNIT_AGL

					u_AglItemMaint()

				Else
					u_AgeItemMaint()
				endIf

				// Inicio Customização TOTVS IP Solicitação Sr. Adriano Louzada inclusão das TAGS
				// PROGRAM CLIENT e PROGRAM CLIENT_CNPJ - 17/05/2021

			endif

		endIf

	endIf

return xRet
