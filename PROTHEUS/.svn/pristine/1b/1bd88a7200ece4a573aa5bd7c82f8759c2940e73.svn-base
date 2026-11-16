#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} GrvCpsSd2
Gravação de campos personalizado do Pedido de Venda para Nota Fiscal

@author Thiago Meschiatti
@since 30/05/2016
@version 1.0
/*/
User Function GrvCpsNF()
	local oSql		:= IpSqlObject():newIpSqlObject()
	local oSqlSD2	:= IpSqlObject():newIpSqlObject()
	local oSqlSC6	:= IpSqlObject():newIpSqlObject()
	local oContrAut	:= DhlDisControl():newDhlDisControl(DHL_NFE_INVOICE_OUTFLOW)
	local lAuto		:= .f.
	local cUpd		:= ""
	local cMsg		:= ""
	local cDocRef	:= ""
	local cSerRef	:= ""
	local cCliRef	:= ""
	local cLojRef	:= ""
	local cTes		:= ""
	
	oSqlSD2:newTable("SD2", "D2_TES, D2_IDENTB6, D2_ITEM, D2_ZZNFAUT, D2_ZZSEAUT, D2_COD, D2_PEDIDO, D2_ITEMPV, R_E_C_N_O_ RECNO", retQrySD2())
	
	while oSqlSD2:notIsEof()
		oSqlSC6:newTable("SC6", "C6_ZZNFAUT, C6_ZZSEAUT, C6_ZZITAUT, C6_ZZCLAUT, C6_ZZLJAUT", retQrySC6(oSqlSD2))
		
		if oSqlSC6:hasRecords()
			cUpd := retUpd(oSqlSC6)
			oSqlSD2:update("SD2", cUpd, "R_E_C_N_O_ = "+cValtoChar(oSqlSD2:getValue("RECNO")))
			
			cTes := oSql:getFieldValue("SD1", "D1_TES", retQrySD1(oSqlSC6))
			
			if empty(cDocRef) .and. oContrAut:hasGeneration(cTes)
				cDocRef	:= oSqlSC6:getValue("C6_ZZNFAUT")
				cSerRef	:= oSqlSC6:getValue("C6_ZZSEAUT")
				cCliRef := oSqlSC6:getValue("C6_ZZCLAUT")
				cLojRef := oSqlSC6:getValue("C6_ZZLJAUT")
			endif
			oSqlSC6:close()
			oSql:close()
		endif
		
		// Adequação DIFAl - Thiago Meschiatti - 10/08/16
		/*
		if validDifal(oSqlSD2:getValue("D2_TES"), oSqlSD2:getValue("D2_IDENTB6"))
			updCpsDifal(oSqlSD2)
		endif
		*/
		oSqlSD2:skip()
	end 
	oSqlSD2:goTop()
	
	if !empty(cDocRef) .and. !empty(cSerRef)
		oContrAut:updAuto(SF2->F2_DOC, SF2->F2_SERIE)
		oContrAut:setMsgAuto(cDocRef, cSerRef, cCliRef, cLojRef)
		oContrAut:recordMsgAuto(SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA)
	endif
	
	oSqlSD2:close()
	
Return


/*
** Where para tabela SD2
*/
static function retQrySD2()
	local cQuery := ""
	
	cQuery += "%SD2.XFILIAL% AND D2_DOC = '"+SF2->F2_DOC+"' AND D2_SERIE = '"+SF2->F2_SERIE+"' "
	
return (cQuery)


/*
** Where para tabela SC5
*/
static function retQrySC6(oSqlSD2)
	local cQuery := ""
	local cPed	 := oSqlSD2:getValue("D2_PEDIDO")
	local cItem	 := oSqlSD2:getValue("D2_ITEMPV")
	local cProd	 := oSqlSD2:getValue("D2_COD")
	
	cQuery := "%SC6.XFILIAL% AND C6_NUM = '"+cPed+"' AND C6_ITEM = '"+cItem+"' AND C6_PRODUTO = '"+cProd+"'"
	cQuery += " AND C6_ZZNFAUT <> '" + CriaVar("C6_ZZNFAUT", .F.) + "' "
	cQuery += " AND C6_ZZSEAUT <> '" + CriaVar("C6_ZZSEAUT", .F.) + "' "
	cQuery += " AND C6_ZZITAUT <> '" + CriaVar("C6_ZZITAUT", .F.) + "' "
	cQuery += " AND C6_ZZCLAUT <> '" + CriaVar("C6_ZZCLAUT", .F.) + "' "
	cQuery += " AND C6_ZZLJAUT <> '" + CriaVar("C6_ZZLJAUT", .F.) + "' "
	
return (cQuery)


/*
** Expressão Update para SD2
*/
static function retUpd(oSqlSC6)
	local cUpd := ""
	local cDoc := oSqlSC6:getValue("C6_ZZNFAUT")
	local cSer := oSqlSC6:getValue("C6_ZZSEAUT")
	local cItem:= oSqlSC6:getValue("C6_ZZITAUT")
	local cCli := oSqlSC6:getValue("C6_ZZCLAUT")
	local cLoj := oSqlSC6:getValue("C6_ZZLJAUT")
	
	cUpd := " D2_ZZNFAUT = '"+cDoc+"', D2_ZZSEAUT = '"+cSer+"', D2_ZZITAUT = '"+cItem+"', D2_ZZCLAUT = '"+cCli+"', D2_ZZLJAUT = '"+cLoj+"' "
return (cUpd)


/*
** Where para tabela SD1
*/
static function retQrySD1(oSqlSC6)
	local cQuery := ""
	local cDoc := oSqlSC6:getValue("C6_ZZNFAUT")
	local cSer := oSqlSC6:getValue("C6_ZZSEAUT")
	local cItem:= oSqlSC6:getValue("C6_ZZITAUT")
	local cCli := oSqlSC6:getValue("C6_ZZCLAUT")
	local cLoj := oSqlSC6:getValue("C6_ZZLJAUT")
	
	cQuery := " %SD1.XFILIAL% AND D1_DOC = '"+cDoc+"' AND D1_SERIE = '"+cSer+"' AND D1_ITEM = '"+cItem+"'"
	cQuery += " AND D1_FORNECE = '" + cCli + "' AND D1_LOJA = '" + SF2->F2_LOJA + " '"
	
return (cQuery)


/*
** Verifica se rotina deve realizar procedimento de atualizaçoes de campos do Difal
*/
static function validDifal(cTes, cIdentB6)
	local oSqlAux	:= IpSqlObject():newIpSqlObject()
	local lRet		:= .f.
	
	oSqlAux:newTable("SF4", "F4_CODIGO", "%SF4.XFILIAL% AND F4_ZZTESDI = '" + cTes + "'")
	
	if oSqlAux:hasRecords() .and. empty(cIdentB6)
		lRet := .t.
	endif
	
	oSqlAux:close()
	
return (lRet)


/*
** Atualiza informações do SD2
*/
static function updCpsDifal(oSqlSD2)
	local oSqlAux	:= IpSqlObject():newIpSqlObject()
	local cPedido	:= oSqlSD2:getValue("D2_PEDIDO")
	local cItemPv	:= oSqlSD2:getValue("D2_ITEMPV")
	local cProd		:= oSqlSD2:getValue("D2_COD")
	local ItemNf	:= oSqlSD2:getValue("D2_ITEM")
	local aAreaSD2	:= SD2->(GetArea())
	
	oSqlAux:newTable("SC6", "C6_IDENTB6", "%SC6.XFILIAL% AND C6_NUM = '" + cPedido + "' AND C6_ITEM = '" + cItemPv + "'")
	
	if oSqlAux:hasRecords()
		dbSelectArea("SD2")
		SD2->(dbSetOrder(3))
		if SD2->(dbSeek(SF2->(F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) + cProd + ItemNf ))
			SD2->(Reclock("SD2", .F.))
				SD2->D2_IDENTB6 := oSqlAux:getValue("C6_IDENTB6")
			SD2->(MsUnlock())
		endif
	endif
	
	oSqlAux:close()
	RestArea(aAreaSD2)
return