#include "totvs.ch"
#include "dhl.ch"


/*/{Protheus.doc} MT103INC

Ponto de Entrada executado na rotina que verifica se o documento de entrada pode ser incluído ou classificado
	
@author Winston Dellano de Castro
@since 11/11/2014

@param lClass, Logico, Indica se é uma classificação

@return lReturn Indica se pode continuar a classificação
/*/
user function MT103INC(lClass)

	local lClass      := ParamIxb
	local lReturn     := .T.
	local oValidation := nil
	
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "ENTROU NO P.E. MT103INC", 0, 0, {})
	
	if lClass
		oValidation := DHLProcessValidator():newDHLProcessValidator()
		
		oValidation:inflowPreInvoiceValidate(,,,,,lClass)
		
		lReturn := oValidation:isAllowedAlter()
	endif
		
return lReturn