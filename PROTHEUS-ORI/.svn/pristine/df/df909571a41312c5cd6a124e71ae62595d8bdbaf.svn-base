#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"

/*/{Protheus.doc} DHLSelPE

Pontos de Entrada da Integração com WMS Select
	
@author Victor Hugo
@since 24/11/2014

@param cPE, String, Ponto de Entrada

@return Indefinido Retorna de acordo com o PE
/*/
user function DHLSelPE(cPE)
	
	if Empty(cPE)
		return
	endIf
	
	if (cPE == "MT410ALT")
		updInvRequestStatus()
	elseIf (cPE == "MT440AT")
		return chkInvRequestItems()		
	endIf
	
return

/**
 * Atualiza o Status da Invoice Request (Pedido de Venda)
 */
static function updInvRequestStatus()
	
	local aArea := GetArea()
	
	if SC5->(C5_CLIENTE+C5_LOJACLI) != AllTrim(GetMv("ZZ_CLINTEG"))
		SC5->(RecLock("SC5", .F.))
			SC5->C5_ZZSTATU := ""
		SC5->(MsUnlock())	
	endIf
	
	RestArea(aArea)
	
return

/**
 * Validação dos Itens na Preparação dos Documentos de Saída das Invoices Request
 */
static function chkInvRequestItems()	
	
	local lOk := .T.
	
	if AllTrim(SC5->C5_ZZSTATU) == DHL_PV_PENDENTE_INFORMACAO
		lOk := .F.
		MsgBox("Não é possível Liberar o Pedido "+AllTrim(SC5->C5_NUM)+;
			   " pois o mesmo consta como Pendente de Informação", "Atenção", "ALERT")	
	endIf
	
return lOk