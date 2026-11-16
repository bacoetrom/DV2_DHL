#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} GrvMsgNFAut
Gravação de mensagem fiscal para NF de Saída estadual.

@author Thiago Meschiatti
@since 06/06/2016
/*/
User Function GrvMsgNFAut()
	local oContrAut	:= DhlDisControl():newDhlDisControl(DHL_NFE_INVOICE_INFLOW)
	local oSqlSD2	:= IpSqlObject():newIpSqlObject()
	local oSqlRef	:= IpSqlObject():newIpSqlObject()
	local cDocRef	:= SF2->F2_DOC
	local cSerRef   := SF2->F2_SERIE
	local cCliRef   := SF2->F2_CLIENTE
	local cLojRef   := SF2->F2_LOJA
	local lAuto		:= SF2->F2_ZZAUTO = 'S'
	local cDocAux	:= ""

	if !(lAuto)
		oSqlSD2:newTable("SD2", "D2_NFORI, D2_SERIORI, D2_ITEMORI", retQrySD2())
		
		while oSqlSD2:notIsEof()
			oSqlRef:newTable("SD2", "D2_DOC, D2_SERIE, D2_ITEM, D2_CLIENTE, D2_LOJA", retQryRef(oSqlSD2, oContrAut))
			while oSqlRef:notIsEof()
				cDocRef	:= oSqlRef:getValue("D2_DOC")
				cSerRef	:= oSqlRef:getValue("D2_SERIE")
				cCliRef	:= oSqlRef:getValue("D2_CLIENTE")
				cLojRef	:= oSqlRef:getValue("D2_LOJA")
				
				oContrAut:setMsgAuto(cDocRef, cSerRef, cCliRef, cLojRef)
				oSqlRef:skip()
			end
			oSqlRef:close()
			oSqlSD2:skip()
		end
		oSqlSD2:close()
		oContrAut:recordMsgAuto(SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA)
	endif
	
Return


/*
** Where para tabela SD2
*/
static function retQrySD2()
	local cQuery := ""
	
	cQuery += "%SD2.XFILIAL% AND D2_DOC = '"+SF2->F2_DOC+"' AND D2_SERIE = '"+SF2->F2_SERIE+"' AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"'"
	cQuery += " AND D2_LOJA = '"+SF2->F2_LOJA+"'"
	
return (cQuery)


/*
** Where para tabela SD2
*/
static function retQryRef(oSqlSD2, oContrAut)
	local cQuery	:= ""
	local cDoc		:= oSqlSD2:getValue("D2_NFORI")  	
	local cSer		:= oSqlSD2:getValue("D2_SERIORI")
	local cItem		:= oSqlSD2:getValue("D2_ITEMORI")
	
	
	cQuery += "%SD2.XFILIAL% AND D2_ZZNFAUT = '"+cDoc+"' AND D2_ZZSEAUT = '"+cSer+"' AND D2_ZZITAUT = '"+cItem+"'"
	
return (cQuery)