#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} MT100LOK

Validação de linhda para inclusão/alteração NF de entrada.
	
@author Thiago Meschiatti
@since 03/11/2014

@return lógico Se linha é valida ou não.
/*/
User Function MT100LOK()
	local lRet	:= .t.
	local cID	:= GdFieldGet("D1_ZZID", n)

	//Emerson Holanda 29/06/2021
	Local aAreaSD2 :=  SD2->(GetArea())
	Local cDocOri  := GdFieldGet("D1_NFORI", n)
	Local cSeriOri := GdFieldGet("D1_SERIORI", n)
	Local cItemOri := GdFieldGet("D1_ITEMORI", n)
	Local cCF      := GdFieldGet("D1_CF", n)
	Local cItem    := GdFieldGet("D1_ITEM", n)
	Local cUFCli   := ""

	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "ENTROU NO P.E. MT100LOK", 0, 0, {})

	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		lRet	:= u_DHLValidID("DHL_VLD_DUPLIC_LINE", "D1_ZZID")
		if lRet
			lRet	:= u_DHLValidID("DHL_EXIST_ID", "D1_ZZID")
		endif
	endif
	
	//Emerson Holanda 29/06/21 -- Tratamento para atualizar a CFOP do primeiro item, quando for nota de recusa e operação interestadual
	If cFilAnt == AG2_SCJ
		If cTipo == "D" .and. cFormul == "S"
			cUFCli:= Posicione("SA1",1,xFilial("SA1")+ca100for+cLoja,"A1_EST")
			SD2->(DbSetOrder(3))
			If SD2->(DbSeek(xFilial("SD2")+cDocOri+cSeriOri))
				If SD2->D2_EST <> cUFCli .and. cItem == "0001"
					cCF := "2"+Substr(cCF,2,3)
					GdFieldPut("D1_CF",cCF, n)
				EndIf
			EndIf
		EndIf
	EndIf

	RestArea(aAreaSD2)

Return (lRet)
