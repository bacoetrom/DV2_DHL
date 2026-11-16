#include "protheus.ch"
#include "dhl.ch"

/*/{Protheus.doc} MT410ACE

Ponto de entrada na alteração do pedido de venda
	
@author Renato Castro
@since 22/10/2014

@return Logico Indica se o pedido pode ser alterado
/*/
User Function MT410ACE()

	local lRetorno := .T.
	
	if (Type("l410Auto") != "L")
		l410Auto := .F.
	endIf
	
	if !(l410Auto)	
		if Altera
			if (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_MUL)	
				if AllTrim(SC5->C5_ZZESPEC) == DHL_ESPECIE_INVENTARIO
					MsgAlert("Pedido de ajuste de inventário não pode ser alterado.")
					lRetorno := .F.
				endif
			
			
				if AllTrim(SC5->C5_ZZSTATU) == DHL_PV_PENDENTE_INFORMACAO
					lRetorno := .F.
					MsgAlert("Não é possível alterar o Pedido " + AllTrim(SC5->C5_NUM) + " pois o mesmo consta como Pendente de Informação.")	
				endIf
			endif
			if (FWUnitBusiness() == DHL_BUSINESSUNIT_AGE) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_AG2)	
				if AllTrim(SC5->C5_ZZSTATU) == DHL_PV_PENDENTE_INFORMACAO .and. (!IsInCallStack("u_ImpMsaNfe") .and. !(FunName() == "MONIP040"))
					lRetorno := .F.
					MsgAlert("Não é possível alterar o Pedido " + AllTrim(SC5->C5_NUM) + " pois o mesmo consta como Pendente de Informação.")	
				endIf
			endif				
		endif	
	endif
	
	
return lRetorno