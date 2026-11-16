#include 'protheus.ch'
#include 'dhl.ch'

/*/{Protheus.doc} User Function Di2GrMsgNFS
	Gravação da mensagem fiscal no documento de saída, referenciando um ou mais documentos de saída automáticos, caso tenha.
	@type  Function
	@author Diogo Mesquita Gamba
	@since 26/02/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function Di2GrMsgNFS()
	
	local oSqlSD2	:= IpSqlObject():newIpSqlObject()
	local oSqlRef	:= IpSqlObject():newIpSqlObject()
	local cDocRef	:= ""
	local cSerRef	:= ""
	local cCliRef	:= ""
	local cLojRef	:= ""
	local lAuto		:= SF2->F2_ZZAUTO = 'S'
	local oTMsg  	:= FswTemplMsg():newTemplMsg("S", SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA, "SZZ")
	local cMsg		:= ""
	
	oTMsg:carMsg(.f.)

	if !(lAuto)
				
		oSqlSD2:newTable("SD2", "D2_NFORI, D2_SERIORI, D2_ITEMORI", retQrySD2())
		
		while oSqlSD2:notIsEof()
			oSqlRef:newTable("SD2", "D2_DOC, D2_SERIE, D2_ITEM, D2_CLIENTE, D2_LOJA", retQryRef(oSqlSD2))
			while oSqlRef:notIsEof()
				cDocRef	:= oSqlRef:getValue("D2_DOC")
				cSerRef	:= oSqlRef:getValue("D2_SERIE")
				cCliRef	:= oSqlRef:getValue("D2_CLIENTE")
				cLojRef	:= oSqlRef:getValue("D2_LOJA")
				
				getMsgFiscal(cDocRef, cSerRef, cCliRef, cLojRef, @cMsg)
				
				oSqlRef:skip()
			end
			oSqlRef:close()
			oSqlSD2:skip()
		end
		oSqlSD2:close()

		if !empty(cMsg)
			aadd(oTMsg:aMsg, {"",cMsg})
		endif

	endif

	oTMsg:grvMsg()
	
Return

/*
** Where para tabela SD2 do documento fiscal que está sendo faturado
*/
static function retQrySD2()
	local cQuery := ""
	
	cQuery += "%SD2.XFILIAL% AND D2_DOC = '"+SF2->F2_DOC+"' AND D2_SERIE = '"+SF2->F2_SERIE+"' AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"'"
	cQuery += " AND D2_LOJA = '"+SF2->F2_LOJA+"'"
	
return (cQuery)

/*
** Where para tabela SD2 do documento de saída automático, gerado a partir do documento de entrada
*/
static function retQryRef(oSqlSD2)
	local cQuery	:= ""
	local cDoc		:= oSqlSD2:getValue("D2_NFORI")  	
	local cSerie	:= oSqlSD2:getValue("D2_SERIORI")
	local cItem		:= oSqlSD2:getValue("D2_ITEMORI")
		
	cQuery += "%SD2.XFILIAL% AND D2_ZZNFAUT = '"+cDoc+"' AND D2_ZZSEAUT = '"+cSerie+"' AND D2_ZZITAUT = '"+cItem+"'"
	
return (cQuery)

/*
** Retorna a mensagem fiscal do documento de saída, referenciando o(s) documento(s) de saída automático(s)
*/
static function getMsgFiscal(cDoc, cSerie, cCliente, cLoja, cMsg)

	local cAux		:= ""
	local aAux		:= {}
	local cMsgFis	:= GetNewPar("ZZ_MSGFIS2","Emitida nos termos do art. 138, inciso I do Anexo VIII do RICMS - MG")

	if !empty(cDoc)
		aAux := retInfoNFSAuto(cDoc, cSerie, cCliente, cLoja)

		if !(upper(alltrim(cDoc)) $ cMsg) .and. empty(cMsg)
			cAux += cMsgFis
			cAux += " número " + alltrim(cDoc) + ", série " + alltrim(cSerie) + ", valor R$ " + alltrim(Transform(aAux[2],PESQPICT("SF2","F2_VALBRUT"))) + ", de " + dtoc(stod(aAux[1])) + "."
		elseif !(upper(alltrim(cDoc)) $ cMsg) .and. !(empty(cMsg))
			cAux += substr(cMsg, 1, len(cMsg)-2)
			cAux += ", número " + alltrim(cDoc) + ", série " + alltrim(cSerie) + ", valor R$ " + alltrim(Transform(aAux[2],PESQPICT("SF2","F2_VALBRUT"))) + ", de " + dtoc(stod(aAux[1])) + "."
		endif
		cMsg := cAux
	endif
	
return

/*
** Obtém a data de emissão e o valor bruto do documento de saída automático
*/
static function retInfoNFSAuto(cDoc, cSerie, cCliente, cLoja)

	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cData		:= ""
	local nValor 	:= 0

	cData := oSql:getFieldValue("SF2", 	"F2_EMISSAO", " %SF2.XFILIAL% AND F2_DOC = '"+cDoc+"' AND F2_SERIE = '"+cSerie+"' AND "+;
										"F2_CLIENTE = '"+cCliente+"' AND F2_LOJA = '"+cLoja+"' ")
	nValor := oSql:getFieldValue("SF2", "F2_VALBRUT", " %SF2.XFILIAL% AND F2_DOC = '"+cDoc+"' AND F2_SERIE = '"+cSerie+"' AND "+;
										"F2_CLIENTE = '"+cCliente+"' AND F2_LOJA = '"+cLoja+"' ")
	oSql:close()

return {cData, nValor}
