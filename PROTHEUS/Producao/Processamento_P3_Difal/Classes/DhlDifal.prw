#include 'totvs.ch'

/*/{Protheus.doc} DhlDifal

Responsável em atualizar as tabelas SD2 e SC6
	
@author Gustavo Luiz
@since 12/08/2016
/*/
user function _Difal;return

CLASS DhlDifal	
	
	METHOD ChangeSD2TES()
	METHOD ChangeSC6TES()
	METHOD New() CONSTRUCTOR

ENDCLASS


METHOD New() CLASS DhlDifal

Return

/*
** Método responsável em atualizar o campo TES da tabela SD2
*/
METHOD ChangeSD2TES(cTes, cProduto, cItem) CLASS DhlDifal	
	
	if SD2->(dbSeek(xFilial("SD2")+cNota+cSerie+cClieFor+cLoja+cProduto+cItem))
		RecLock("SD2",.F.)
		SD2->D2_TES := cTes
		MsUnlock()
	EndIf	

Return

/*
** Método responsável em atualizar o campo TES da tabela SC6
*/
METHOD ChangeSC6TES(cTes, cPedido, cItemPedido, cProduto) CLASS DhlDifal	
	
	local oSqlAux	  := IpSqlObject():newIpSqlObject()
	local cTabela	  := "SC6"
	local cCampos	  := "C6_NUM, C6_ITEM"	
	local cWhere	  := "%SC6.XFILIAL% AND C6_NUM = '" + cPedido + "' AND C6_ITEM = '"+cItemPedido+"' AND C6_PRODUTO = '"+cProduto+"' "
	oSqlAux:newTable(cTabela,cCampos,cWhere )
	
	if oSqlAux:hasRecords()
		SC6->(DbSetOrder(1))		
		if SC6->(dbSeek(xFilial("SC6")+cPedido+cItemPedido+cProduto))
			RecLock("SC6",.F.)
			SC6->C6_TES := cTes
			MsUnlock()
		EndIf		
	endif	

Return