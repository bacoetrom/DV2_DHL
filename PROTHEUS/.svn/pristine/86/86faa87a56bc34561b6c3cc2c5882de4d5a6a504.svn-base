#Include 'Protheus.ch'
#include "dhl.ch"

/*/{Protheus.doc} M410STTS

Este ponto de entrada pertence à rotina de pedidos de venda, MATA410().
Está em todas as rotinas de inclusão, alteração, exclusão, cópia e devolução de compras.

@author Gustavo Luiz
@since 25/04/2019

@param
nOper --> Tipo: Numérico - Descrição: Operação que está sendo executada, sen
@return
/*/
User Function M410STTS()
	
	local lInclui := INCLUI
	local lAltera := ALTERA
	
	if cFilAnt == AGE_MONDELEZ		
		if  !lInclui  
			if !lAltera
				if  funname() == "MATA410"			
					desvincSZ8()				
				endIf				
			endIf			
		endIf		
	endIf
	
Return

/**
* Atualiza a SZ8 realizando o desvínculo
**/
static function desvincSZ8()
	
	local aArea 	:= getArea()
	local aAreaSZ8 	:= SZ8->(getArea())
	local cNota     := StrZero(Val(Substr(SC5->C5_ZZORDEX,1,RAT("-", allTrim(SC5->C5_ZZORDEX)))),9,0)
	local cSerie	:= Substr(SC5->C5_ZZORDEX,RAT("-", allTrim(SC5->C5_ZZORDEX)) + 1,2)+Space(1)
	
	SZ8->(dbSetOrder(1))
	
	if SZ8->(dbSeek(xFilial("SZ8")+cNota+cSerie,.F.))
		
		RecLock("SZ8",.F.)
		SZ8->Z8_PEDIDO  := " "
		SZ8->(MsUnLock())
		
	endif
	
	restArea(aAreaSZ8)
	restArea(aArea)
	
return

