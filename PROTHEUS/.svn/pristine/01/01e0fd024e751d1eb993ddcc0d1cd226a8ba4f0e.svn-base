#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} ProcCancEmb
Processamento do Cancelamento do Embarque
@type function
@author Thiago Meschiatti
@since 26/12/2016
@version 1.0
@return NIL, Nenhum
/*/
User Function ProcCancEmb()
	local oEmbarque := ClassShipment():newClassShipment()
	local oSql		:= IpSqlObject():newIpSqlObject()
	local aArea		:= GetArea()
	local aAreaSC5	:= SC5->(GetArea())
	local cNumPed	:= SC5->C5_NUM
	local lRet		:= .t.
	local nI		:= 0
	
	oEmbarque:setSalesOrder(cNumPed)
	oEmbarque:separaOps(oEmbarque:retOpsSalesOrd())
	
	Begin Transaction 
	
	for nI := 1 to len(oEmbarque:aOps)
		oSql:newTable("SC2", "C2_FILIAL, C2_ITEM, C2_NUM, C2_SEQUEN, C2_ITEMGRD, C2_PRODUTO, C2_LOCAL", "%SC2.XFILIAL% AND C2_NUM = '" + alltrim(oEmbarque:aOps[nI]) + "'")
		
		if oSql:hasRecords()
			if exec(oSql, oEmbarque)
				DisarmTransaction()
				exit
			endif
		else
			loop
		endif
		oSql:close()
		
	next nI
	
	if oEmbarque:hasError()
		oEmbarque:showError()		
		lRet := .f.			 
	else
		if len(oEmbarque:aOps) > 0
			MsgInfo("OP(s) e apontamento(s) excluídos com sucesso!" + CRLF + CRLF + oEmbarque:retOpsSalesOrd(), "Concluído")
		endif
	endif
	
	End Transaction 
	
	RestArea(aAreaSC5)
	RestArea(aArea)
Return (lRet)


/*
** Execução
*/
static function exec(oSql, oEmbarque)
	local aArraySD3 := estrutApont(oSql, oEmbarque)
	local aArraySC2 := estrutOP(oSql, oEmbarque)
	
	DbSelectArea("SD3")
	SD3->(dbSetOrder(1))
	SD3->(dbSeek(oEmbarque:getIndexSD3()))
	oEmbarque:execAuto250(aArraySD3, 5)
	
	if !oEmbarque:hasError()
		DbSelectArea("SC2")
		SC2->(dbSetOrder(1))
		SC2->(dbSeek(oEmbarque:getIndexSC2()))
			
		oEmbarque:execAuto650(aArraySC2, 5)		
	endif 
	
	if oEmbarque:hasError()
		oEmbarque:setMsgErro("Exclusão de OP(s) ["+oEmbarque:retOpsSalesOrd()+"] e apontamento(s) não foram realizados. Verifique o motivo e tente novamente" + CRLF + CRLF+;
							 oEmbarque:getMsgErro())
	endif							
	
return (oEmbarque:hasError())


/*
** Monta array do SC2
*/
static function estrutOP(oSql, oEmbarque)
	local aArray := {}
	
	//C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
	oEmbarque:setIndexSC2(oSql:getValue("C2_FILIAL + C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD"))
	
	aArray:=  {{"C2_ITEM",		oSql:getValue("C2_ITEM")	,NIL},;
				{"C2_NUM",		oSql:getValue("C2_NUM")		,NIL},;
				{"C2_PRODUTO",	oSql:getValue("C2_PRODUTO") ,NIL},;
				{"C2_LOCAL",	oSql:getValue("C2_LOCAL")	,NIL}}
				
return aClone(aArray)


/*
** Monta array do SD3
*/
static function estrutApont(oSql, oEmbarque)
	local aArray := {}
	
	//D3_FILIAL+D3_OP+D3_COD+D3_LOCAL
	oEmbarque:setIndexSD3(oSql:getValue("C2_FILIAL + C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD + C2_PRODUTO + C2_LOCAL"))
	
	aArray:=   {{"D3_OP",		oSql:getValue("C2_NUM") + oSql:getValue("C2_ITEM") + oSql:getValue("C2_SEQUEN") + oSql:getValue("C2_ITEMGRD"),NIL},;
				{"D3_COD",		oSql:getValue("C2_PRODUTO"),NIL},;
				{"D3_LOCAL",	oSql:getValue("C2_LOCAL"),NIL}}
				
return aClone(aArray)