#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} MA410COR

Ponto de entrada para adicionar cores nas legendas do pedido de venda
	
@author Renato Castro
@since 22/10/2014


@return Array Novas cores
/*/
User Function MA410COR()

	Local aCores := {} //PARAMIXB traz a estrutura do array padrão
	
	aAdd(aCores, {"AllTrim(C5_ZZESPEC) == '"+DHL_ESPECIE_INVENTARIO+"'", "PMSEDT4", "Ajuste de Inventário"})
	aAdd(aCores, {"AllTrim(C5_ZZSTATU) == '"+DHL_PV_PENDENTE_INFORMACAO+"'", "BR_BRANCO", "Pedido de Venda Pendente de Informação"})
	aAdd(aCores, {"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)", "ENABLE", "Pedido em Aberto"})
	aAdd(aCores, {"!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)", "DISABLE", "Pedido Encerrado"})
	aAdd(aCores, {"!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)", "BR_AMARELO", "Pedido Liberado"})
	aAdd(aCores, {"C5_BLQ == '1'", "BR_AZUL", "Pedido Bloquedo por Regra"})
	aAdd(aCores, {"C5_BLQ == '2'", "BR_LARANJA", "Pedido Bloquedo por Verba"})

Return(aCores)

