#Include 'Protheus.ch'

/*/{Protheus.doc} AtuNFCob
Atualiza NF com pedido no processo de cobertura
@author Thiago Meschiatti
@since 27/09/2016
@version 1.0

/*/
User Function AtuNFCob(nItem)
	local nPosPC		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
	
	if nPosPC > 0 .and. IsInCallStack("u_DisNfSelScr")
		GdFieldPut("D1_VUNIT", SD1->D1_VUNIT, nItem)
		MaFisRef("IT_PRCUNI", "MT100", SD1->D1_VUNIT)
		GdFieldPut("D1_TOTAL", SD1->D1_TOTAL, nItem)
		MaFisRef("IT_VALMERC", "MT100", SD1->D1_TOTAL)
	endif
Return

