#Include 'Protheus.ch'

/*/{Protheus.doc} RollBackDifal

Função para retornar a TES substituta Difal

@author Gustavo Luiz
@since 12/08/2016

/*/
User Function RollBackDifal()
	
	private cSerie      := SF2->F2_SERIE
	private cNota       := SF2->F2_DOC
	private cClieFor    := SF2->F2_CLIENT
	private cLoja       := SF2->F2_LOJA
	private cTipo       := SF2->F2_TIPO
	
	Process()	

Return

/*
** Função responsável voltar o conteúdo da TES (C6_TES) de acordo com a TES do campo personalizado F4_ZZTESD
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
	Local cTes		  := ""
	Local cTesReferen := ""
	
	oSqlAux:NewTable(cTabela,cCampos,cWhere)
	
	while !(oSqlAux:IsEof())
		
		cTes 		:= oSqlAux:GetValue("D2_TES")
		cTesReferen	:= GetTesReferSF4(cTes)
		if !Empty(cTesReferen)
			
			cItemOri 	:= oSqlAux:GetValue("D2_ITEMORI")
			cSerieOri	:= oSqlAux:GetValue("D2_SERIORI")
			cProduto	:= oSqlAux:GetValue("D2_COD")
			cItem		:= Padr(oSqlAux:GetValue("D2_ITEM"),TamSx3("FT_ITEM")[1])
			cPedido		:= oSqlAux:GetValue("D2_PEDIDO")
			cItemPedido := oSqlAux:GetValue("D2_ITEMPV")
			
			ChangeTES(cTesReferen, cProduto, cItem, cPedido, cItemPedido)			
		
		endIf	
		
		oSqlAux:skip()
		
	EndDo


Return

/*
** Função responsável em alterar a TES oficial que controle 3º para a TES de referência que não controla 3º 
*/
Static Function ChangeTES(cTesReferen, cProduto, cItem, cPedido, cItemPedido)
	
	Local oDhlDifal	:= DhlDifal():New()
	local aAreaSD2	:= SD2->(GetArea())
	local aAreaSC6	:= SC6->(GetArea())
	
	SD2->(DbSetOrder(3))
	
	//oDhlDifal:ChangeSD2TES(cTesReferen, cProduto, cItem)	/* Comentado, pois ao excluir a nota, nao estava escluido o B6
	oDhlDifal:ChangeSC6TES(cTesReferen, cPedido, cItemPedido, cProduto)		
	
	SC6->(RestArea(aAreaSC6))
	SD2->(RestArea(aAreaSD2))
	
Return


/*
** Função responsável em obter o conteúdo da TES de referência
*/
Static Function GetTesReferSF4(cTes)
	
	local oSqlAux	:= IpSqlObject():newIpSqlObject()
	local cTesRefere:= ""
	
	oSqlAux:newTable("SF4", "F4_ZZTESDI", "%SF4.XFILIAL% AND F4_CODIGO = '" + cTes + "'")
	
	if oSqlAux:hasRecords()
		cTesRefere := oSqlAux:GetValue("F4_ZZTESDI")
	endif
	
	oSqlAux:close()
	
return (cTesRefere)
