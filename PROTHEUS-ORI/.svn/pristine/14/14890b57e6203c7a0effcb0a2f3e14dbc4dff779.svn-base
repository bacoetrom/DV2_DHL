#Include 'Protheus.ch'

/*/{Protheus.doc} UpdTablesDifal

Função que atualiza os campos das tabelas pertinentes ao DIFAL

@author Gustavo Luiz
@since 12/08/2016

/*/
User Function UpdTablesDifal()
	
	
	Local cTes		:= ""
	local oSql		:= IpSqlObject():newIpSqlObject()
	
	private cSerie      := SF2->F2_SERIE
	private cNota       := SF2->F2_DOC
	private cClieFor    := SF2->F2_CLIENT
	private cLoja       := SF2->F2_LOJA
	private cTipo       := SF2->F2_TIPO
	
	Process()	

Return

/*
** Função responsável em percorrer a tebela SD2, verificando se atualiza ou não
** as tabelas SFT, SF3 de acordo com a TES do item da SD2
*/
Static Function Process()
	
	local oSqlAux	  := IpSqlObject():newIpSqlObject()
	local cTabela	  := "SD2"
	local cCampos	  := "D2_TES, D2_ITEM, D2_ITEMORI, D2_NFORI, D2_COD, D2_SERIORI, D2_PEDIDO, D2_ITEMPV "
	local cWhere	  := "%SD2.XFILIAL% AND D2_SERIE = '" + cSerie + "' AND D2_DOC = '" + cNota + "' AND D2_CLIENTE = '" + cClieFor + "' AND D2_LOJA = '" + cLoja + "' AND D2_TIPO = '" + cTipo + "'"
	local cItemOri	  := ""
	local cObservacao := ""
	local cItem		  := ""
	local cProduto    := ""
	local cTesPod3	  := ""
	local cPedido	  := ""
	local cItemPedido := ""
	
	oSqlAux:newTable(cTabela,cCampos,cWhere )
	
	while !(oSqlAux:IsEof())
		
		If validDifal(oSqlAux:GetValue("D2_TES"))
			cItemOri 	:= oSqlAux:GetValue("D2_ITEMORI")
			cSerieOri	:= oSqlAux:GetValue("D2_SERIORI")
			cObservacao	:="Dev. terc. N.F.ORIG.: " + oSqlAux:GetValue("D2_NFORI")
			cProduto	:= oSqlAux:GetValue("D2_COD")
			cItem		:= Padr(oSqlAux:GetValue("D2_ITEM"),TamSx3("FT_ITEM")[1])
			cPedido		:= oSqlAux:GetValue("D2_PEDIDO")
			cItemPedido := oSqlAux:GetValue("D2_ITEMPV")
			cTesPod3	:= GetTESPod3(oSqlAux:GetValue("D2_TES"))
			
			UpdSFT(cItemOri, cObservacao, cProduto, cItem)
			UpdSF3(cObservacao, cSerieOri)			
			ChangeTES(cTesPod3, cProduto, cItem, cPedido, cItemPedido)
			U_ProcPod3()
		EndIf
		oSqlAux:skip()
		
	EndDo

Return

/*
** Função responsável em obter a TES de poder de 3º
*/
Static Function GetTESPod3(cTes)
	
	local oSqlAux	  := IpSqlObject():newIpSqlObject()
	local cTabela	  := "SF4"
	local cCampos	  := "F4_CODIGO"
	local cWhere	  := "%SF4.XFILIAL% AND F4_ZZTESDI = '" + cTes + "'"
	local cTesPod3	  := ""
	
	oSqlAux:newTable(cTabela,cCampos,cWhere )
	
	if oSqlAux:hasRecords()
		cTesPod3	:= oSqlAux:GetValue("F4_CODIGO")
	endif
	
Return cTesPod3

/*
** Função responsável em alterar a TES temporária para a TES que controla 3º
*/
Static Function ChangeTES(cTesPod3, cProduto, cItem, cPedido, cItemPedido)
	
	Local oDhlDifal	:= DhlDifal():New()
	local aAreaSD2	:= SD2->(GetArea())
	local aAreaSC6	:= SC6->(GetArea())
	
	SD2->(DbSetOrder(3))
	
	oDhlDifal:ChangeSD2TES(cTesPod3, cProduto, cItem)	
	oDhlDifal:ChangeSC6TES(cTesPod3, cPedido, cItemPedido, cProduto)		
	
	SC6->(RestArea(aAreaSC6))
	SD2->(RestArea(aAreaSD2))
	
Return

/*
** Função responsável em atualizar os campos FT_ITEMORI e FT_OBSERV da tabela SFT
*/
Static Function UpdSFT(cItemOri, cObservacao, cProduto, cItem)
	
	local aAreaSFT		:= SFT->(GetArea())
	
	SFT->(DbSetOrder(1))
	
	if SFT->(dbSeek(xFilial("SFT")+"S"+cSerie+cNota+cClieFor+cLoja+cItem+cProduto))
		RecLock("SFT",.F.)
		SFT->FT_ITEMORI := cItemOri
		SFT->FT_OBSERV	:= cObservacao
		MsUnlock()
	EndIf
	
	SFT->(RestArea(aAreaSFT))
	
Return

/*
** Função responsável em atualizar os campos F3_OBSERV da tabela SF3
*/
Static Function UpdSF3(cObservacao, cSerieOri)
	
	local aAreaSF3		:= SF3->(GetArea())
	
	SF3->(DbSetOrder(4))
	
	if SF3->(dbSeek(xFilial("SF3")+cClieFor+cLoja+cNota+cSerie))
		RecLock("SF3",.F.)
		SF3->F3_OBSERV	:= cObservacao+"/"+cSerieOri
		MsUnlock()
	EndIf
	
	SF3->(RestArea(aAreaSF3))
	
Return

/*
** Verifica se rotina deve realizar procedimento de atualizaçoes de campos do Difal
*/
static function validDifal(cTes)
	local oSqlAux	:= IpSqlObject():newIpSqlObject()
	local lRet		:= .f.
	
	oSqlAux:newTable("SF4", "F4_CODIGO", "%SF4.XFILIAL% AND F4_ZZTESDI = '" + cTes + "'")
	
	if oSqlAux:hasRecords()
		lRet := .t.
	endif
	
	oSqlAux:close()
	
return (lRet)

