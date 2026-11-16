#include 'protheus.ch'
#include 'dhl.ch'

#define INF_ADIC 	25

/*/{Protheus.doc} InfLtAgePrd
Inclusão de informacao de lote personalizado nos dados adicionais do produto.
@author Diogo Mesquita
@since 19/10/2017
@version undefined
@type function
/*/
user function InfLtAgePrd(aProd, aNota)
	local aAreas 	:= Lj7GetArea({"SC6","SD2"})
	local cTipo	:= aNota[04]
	local cChave	:= SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA
	local nT		:= 0
	
	if cTipo == DHL_NFE_INVOICE_OUTFLOW
		// Lote personalizado do item do PV
		for nT := 1 to len(aProd)
			SD2->(dbSelectArea("SD2"))
			SD2->(dbSetOrder(3))//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			if SD2->(dbSeek(xFilial("SD2")+cChave+aProd[nT][2]+StrZero(aProd[nT][1],tamSX3("D2_ITEM")[1])))
				SC6->(dbSelectArea("SC6"))
				SC6->(dbSetOrder(1))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
				if SC6->(dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
					if !empty(SC6->C6_ZZLOTE)
						aProd[nT][INF_ADIC] += alltrim(SC6->C6_ZZLOTE) + " "
					endif
				endif
			endif
		next nT
	endif
	
	Lj7RestArea(aAreas)
	
return
