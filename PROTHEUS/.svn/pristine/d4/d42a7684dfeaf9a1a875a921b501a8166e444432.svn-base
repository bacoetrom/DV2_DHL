#include 'protheus.ch'
#include 'dhl.ch'

/*/{Protheus.doc} User Function Di2GrCpNFS
	Gravação de campos personalizados do pedido de venda para o documento de saída automático e mensagens fiscais.
	@type  Function
	@author Diogo Mesquita Gamba
	@since 24/02/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function Di2GrCpNFS()
	
	local oSql		:= IpSqlObject():newIpSqlObject()
	local oSqlSD2	:= IpSqlObject():newIpSqlObject()
	local oSqlSC6	:= IpSqlObject():newIpSqlObject()
	local cUpd		:= ""
	local cDocRef	:= ""
	local cSerRef	:= ""
	local cCliRef	:= ""
	local cLojRef	:= ""
	local cTes		:= ""
	local oTMsg  	:= FswTemplMsg():newTemplMsg("S", SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA, "SZZ")
	local cMsg		:= ""

	oTMsg:carMsg(.f.)

	oSqlSD2:newTable("SD2", "D2_TES, D2_IDENTB6, D2_ITEM, D2_ZZNFAUT, D2_ZZSEAUT, D2_COD, D2_PEDIDO, D2_ITEMPV, R_E_C_N_O_ RECNO", retQrySD2())
	
	while oSqlSD2:notIsEof()
		oSqlSC6:newTable("SC6", "C6_ZZNFAUT, C6_ZZSEAUT, C6_ZZITAUT, C6_ZZCLAUT, C6_ZZLJAUT", retQrySC6(oSqlSD2))
		
		if oSqlSC6:hasRecords()
			cUpd := retUpdSD2(oSqlSC6)
			oSqlSD2:update("SD2", cUpd, "R_E_C_N_O_ = "+cValtoChar(oSqlSD2:getValue("RECNO")))
			
			cTes := oSql:getFieldValue("SD1", "D1_TES", retQrySD1(oSqlSC6))
			
			if empty(cDocRef) .and. &("StaticCall(Di2ASNConf,ChkItemPV,cTes)")
				cDocRef	:= oSqlSC6:getValue("C6_ZZNFAUT")
				cSerRef	:= oSqlSC6:getValue("C6_ZZSEAUT")
				cCliRef := oSqlSC6:getValue("C6_ZZCLAUT")
				cLojRef := oSqlSC6:getValue("C6_ZZLJAUT")
			endif
			oSqlSC6:close()
			oSql:close()
		endif
		oSqlSD2:skip()
	endDo 
	oSqlSD2:goTop()
	
	if !empty(cDocRef) .and. !empty(cSerRef)

		SF2->(RecLock("SF2", .F.))
	 		SF2->F2_ZZAUTO := 'S'
	 	SF2->(MsUnlock())

		getMsgFiscal(cDocRef, cSerRef, cCliRef, cLojRef, @cMsg)
		
		if !empty(cMsg)
			aadd(oTMsg:aMsg, {"",cMsg})
		endif
		
	endif
	
	oSqlSD2:close()

	oTMsg:grvMsg()
		
Return

/*
** Where para tabela SD2
*/
static function retQrySD2()
	local cQuery := ""
	
	cQuery += "%SD2.XFILIAL% AND D2_DOC = '"+SF2->F2_DOC+"' AND D2_SERIE = '"+SF2->F2_SERIE+"' "
	
return (cQuery)

/*
** Where para tabela SC6
*/
static function retQrySC6(oSqlSD2)
	local cQuery	:= ""
	local cPedido	:= oSqlSD2:getValue("D2_PEDIDO")
	local cItem		:= oSqlSD2:getValue("D2_ITEMPV")
	local cProduto	:= oSqlSD2:getValue("D2_COD")
	
	cQuery := "%SC6.XFILIAL% AND C6_NUM = '"+cPedido+"' AND C6_ITEM = '"+cItem+"' AND C6_PRODUTO = '"+cProduto+"'"
	cQuery += " AND C6_ZZNFAUT <> '" + CriaVar("C6_ZZNFAUT", .F.) + "' "
	cQuery += " AND C6_ZZSEAUT <> '" + CriaVar("C6_ZZSEAUT", .F.) + "' "
	cQuery += " AND C6_ZZITAUT <> '" + CriaVar("C6_ZZITAUT", .F.) + "' "
	cQuery += " AND C6_ZZCLAUT <> '" + CriaVar("C6_ZZCLAUT", .F.) + "' "
	cQuery += " AND C6_ZZLJAUT <> '" + CriaVar("C6_ZZLJAUT", .F.) + "' "
	
return (cQuery)

/*
** Expressão update para SD2
*/
static function retUpdSD2(oSqlSC6)
	local cUpd		:= ""
	local cDoc		:= oSqlSC6:getValue("C6_ZZNFAUT")
	local cSerie	:= oSqlSC6:getValue("C6_ZZSEAUT")
	local cItem		:= oSqlSC6:getValue("C6_ZZITAUT")
	local cCliente 	:= oSqlSC6:getValue("C6_ZZCLAUT")
	local cLoja		:= oSqlSC6:getValue("C6_ZZLJAUT")
	
	cUpd := " D2_ZZNFAUT = '"+cDoc+"', D2_ZZSEAUT = '"+cSerie+"', D2_ZZITAUT = '"+cItem+"', D2_ZZCLAUT = '"+cCliente+"', D2_ZZLJAUT = '"+cLoja+"' "
return (cUpd)

/*
** Where para tabela SD1
*/
static function retQrySD1(oSqlSC6)
	local cQuery 	:= ""
	local cDoc		:= oSqlSC6:getValue("C6_ZZNFAUT")
	local cSerie	:= oSqlSC6:getValue("C6_ZZSEAUT")
	local cItem		:= oSqlSC6:getValue("C6_ZZITAUT")
	local cCliente 	:= oSqlSC6:getValue("C6_ZZCLAUT")
	local cLoja 	:= oSqlSC6:getValue("C6_ZZLJAUT")
	
	cQuery := " %SD1.XFILIAL% AND D1_DOC = '"+cDoc+"' AND D1_SERIE = '"+cSerie+"' AND D1_ITEM = '"+cItem+"'"
	cQuery += " AND D1_FORNECE = '" + cCliente + "' AND D1_LOJA = '" + cLoja + " '"
	
return (cQuery)

/*
** Retorna a mensagem fiscal do documento de saída automático, referenciando o documento de entrada
*/
static function getMsgFiscal(cDoc, cSerie, cFornece, cLoja, cMsg)
	
	local aAux		:= retInfoNFE(cDoc, cSerie, cFornece, cLoja)
	local cMsgFis	:= GetNewPar("ZZ_MSGFIS1","Emitida nos termos do art. 137, parte 1 do Anexo VIII do RICMS - MG")

	cMsg += cMsgFis
	cMsg += " número " + alltrim(cDoc) + ", série " + alltrim(cSerie) + ", valor R$ " + alltrim(Transform(aAux[2],PESQPICT("SF1","F1_VALBRUT"))) + ", de " + dtoc(stod(aAux[1])) + "."
		
return

/*
** Obtém a data de emissão e o valor bruto do documento de entrada
*/
static function retInfoNFE(cDoc, cSerie, cFornece, cLoja)

	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cData		:= ""
	local nValor 	:= 0

	cData := oSql:getFieldValue("SF1", 	"F1_EMISSAO", " %SF1.XFILIAL% AND F1_DOC = '"+cDoc+"' AND F1_SERIE = '"+cSerie+"' AND "+;
										"F1_FORNECE = '"+cFornece+"' AND F1_LOJA = '"+cLoja+"' ")
	nValor := oSql:getFieldValue("SF1", "F1_VALBRUT", " %SF1.XFILIAL% AND F1_DOC = '"+cDoc+"' AND F1_SERIE = '"+cSerie+"' AND "+;
										"F1_FORNECE = '"+cFornece+"' AND F1_LOJA = '"+cLoja+"' ")
	oSql:close()

return {cData, nValor}
