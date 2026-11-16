#include "protheus.ch"
#include "dhl.ch"
#include "topconn.ch"

/*/{Protheus.doc} PrcGrvRet
Realiza processamento final da NF RET
@author Diogo Mesquita
@since 29/05/2017
@version undefined

@type function
/*/
User Function PrcGrvRet()
	
	local oSql		:= IpSqlObject():newIpSqlObject()
	local oSqlSA1	:= IpSqlObject():newIpSqlObject()
	local oSqlSYA	:= IpSqlObject():newIpSqlObject()
	local cDoc		:= SF2->F2_DOC
	local cSerie		:= SF2->F2_SERIE
	local cCliente	:= SF2->F2_CLIENTE
	local cLoja		:= SF2->F2_LOJA
	local cChvNfScj 	:= SZA->ZA_KENFSCJ
	local lNFRet		:= SF2->F2_ZZTPNF = RETORNO_SIMBOLICO
	local oTMsg		:= FswTemplMsg():newTemplMsg("S",SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,"SZZ")
	local cDocScj		:= ""
	local cSerScj		:= ""
	local cDocRco		:= ""
	local cSerRco		:= ""
	local cBuyCod		:= ""
	local cMsg		:= ""
	local cCpsSa1		:= "A1_NOME, A1_END, A1_MUN, A1_EST, A1_CGC, A1_INSCR, A1_TIPO, A1_PAIS"
	local dEmiRco := ctod("  /  /  ")
	local dEmiScj	:= ctod("  /  /  ")
	local oIp040	:= DhlIp040Sap():newDhlIp040Sap()
	local cQuery := ""
	local nSZARecno := 0
	local aSZAArea := SZA->(GetArea())
	
	if lNFRet
		//Inicio -- Validação Referência - NF SCJ > NF RET
		cQuery := " SELECT R_E_C_N_O_ AS SZARECNO"
		cQuery += " FROM " + RetSqlName("SZA")
		cQuery += " WHERE ZA_FILIAL = '"+xFilial("SZA")+"'"
		cQuery += " AND ZA_NFRET = '"+cDoc+"'"
		cQuery += " AND ZA_SERIRET = '"+cSerie+"'"
		cQuery += " AND D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)
		
		TCQUERY cQuery NEW ALIAS "QSZA"
		If QSZA->(!Eof())
			nSZARecno := QSZA->SZARECNO
		EndIf
		QSZA->(DbCloseArea())

		If nSZARecno > 0
			SZA->(DbSelectArea("SZA"))
			SZA->(DbGoTo(nSZARecno))
			If SZA->ZA_KENFSCJ <> cChvNfScj
				fEnvEmail(SZA->ZA_KENFSCJ,cChvNfScj)		
			EndIf
		EndIf
		RestArea(aSZAArea)
		//Fim -- Validação Referência - NF SCJ > NF RET
		
		oTMsg:carMsg(.F.)
		
		oSql:newTable("SZA", "ZA_DOCSCJ, ZA_SERISCJ, ZA_DTEMSCJ, ZA_NFRCO, ZA_SERIRCO, ZA_BUYCODE, ZA_DUEDATE", " %SZA.XFILIAL% AND ZA_KENFSCJ = '"+cChvNfScj+"'")
		
		oSql:setField("ZA_DTEMSCJ", "D")
		
		cDocScj := oSql:getValue("ZA_DOCSCJ")
		cSerScj := oSql:getValue("ZA_SERISCJ")
		dEmiScj := oSql:getValue("ZA_DUEDATE")
		cDocRco := oSql:getValue("ZA_NFRCO")
		cSerRco := oSql:getValue("ZA_SERIRCO")
		cBuyCod := oSql:getValue("ZA_BUYCODE")
		oSql:close()
		
		cMsg += "NF de venda do depositante nr. " + alltrim(cDocScj) + ", sr. " + alltrim(cSerScj) + ", de " + dToc(stod(dEmiScj)) + ". "
		
		if !Empty(cDocRco) .and. !Empty(cSerRco)
			oSql:newTable("SF2", "F2_EMISSAO, F2_CLIENTE, F2_LOJA, F2_CLIENT, F2_LOJENT", "F2_FILIAL = '%SF2.FILIAL%' AND F2_DOC = '"+cDocRco+"' AND F2_SERIE = '"+cSerRco+"' AND F2_CLIENTE = '" + oIp040:getCustomerUnit(cBuyCod)[1] + "' AND F2_LOJA = '" + oIp040:getCustomerUnit(cBuyCod)[2] + "' ")
			
			oSql:setField("F2_EMISSAO", "D")
			
			dEmiRco := oSql:getValue("F2_EMISSAO")
			
	
			cMsg += "RCO n. " + alltrim(cDocRco) + ", sr. " + alltrim(cSerRco) + ", de " + dtoc(dEmiRco) + ", " 
			cMsg += "emitida por " + AllTrim(SM0->M0_NOMECOM) + ", conforme NF de venda do depositante."
			
			oSqlSA1:newTable("SA1", cCpsSa1, getQrySa1(oSql:getValue("F2_CLIENTE"), oSql:getValue("F2_LOJA"), oSql:getValue("F2_CLIENT"), oSql:getValue("F2_LOJENT")))
			oSql:close()
		else
			oSqlSA1:newTable("SA1", cCpsSa1, getQrySa1(oIp040:getCustomerUnit(cBuyCod)[1], oIp040:getCustomerUnit(cBuyCod)[2]))
		endif
		
		If oSqlSA1:hasRecords()
		
			cMsg += " Emitida para " + AllTrim(oSqlSA1:getValue("A1_NOME")) + ", situada a " + AllTrim(oSqlSA1:getValue("A1_END")) + " "
			cMsg += + AllTrim(oSqlSA1:getValue("A1_MUN")) + "/" + AllTrim(oSqlSA1:getValue("A1_EST"))
			
			If (oSqlSA1:getValue("A1_TIPO") <> "X")
				cMsg += ", CNPJ " + AllTrim(Transform(oSqlSA1:getValue("A1_CGC"), "@R 99.999.999/9999-99"))
				If Empty(oSqlSA1:getValue("A1_INSCR"))
					cMsg += "."
				Else	
					cMsg += ", I.E. " + AllTrim(oSqlSA1:getValue("A1_INSCR")) + "."
				EndIf
			Else
				If Empty(oSqlSA1:getValue("A1_PAIS"))
					cMsg += "."
				Else	
					oSqlSYA:newTable("SYA", "YA_DESCR", "%SYA.XFILIAL% AND YA_CODGI = '" + oSqlSA1:getValue("A1_PAIS") + "'")
					If oSqlSYA:hasRecords()
						cMsg += ", País " + AllTrim(oSqlSYA:getValue("YA_DESCR")) + "."	
					endIf
					oSqlSYA:close()
				EndIf
			EndIf
		EndIf
		
		oSqlSA1:close()

		aadd(oTMsg:aMsg, {"",cMsg})
		
		oTMsg:grvMsg()
		
	endif
	
Return


/*
** Query para SA1
*/
Static Function getQrySa1(cCustomer, cUnit, cCustDelivey, cUniDelivery)
	Local cQuery := ""
	
	Default cCustDelivey 	:= ""
	Default cUniDelivery	:= ""
	
	If Empty(cCustDelivey)
		cQuery += " %SA1.XFILIAL% AND A1_COD = '" + cCustomer + "' AND A1_LOJA = '" + cUnit + "' "
	Else
		cQuery += " %SA1.XFILIAL% AND A1_COD = '" + cCustDelivey + "' AND A1_LOJA = '" + cUniDelivery + "' "
	EndIf 
	
Return (cQuery)

/*
** Função para envio de e-mail, notificando a identificação da Referência incorreta - NF SCJ > NF RET
*/
static function fEnvEmail(cKeNFSCJOk,cKeNFSCJNoOk)
	
	local oMail			:= DHLSndMail():Create()
	local cEmailFrom		:= AllTrim(GetMv("MV_RELFROM"))
	local cEmailTo		:= GETMV("ZZ_MAILRET")
	local cDesc1	 		:= ""
	local cDesc2		 	:= ""
	local cMsg				:= ""
	local oLog				:= DHLLogManager():newDHLLogManager()
	
	cMsg += "<html><head>Referência incorreta - NF SCJ > NF RET</head><body><br/>"
	cMsg += "Chave NF-e SCJ Correta: " + cKeNFSCJOk + "<br/>"
	cMsg += "Chave NF-e SCJ Incorreta: " + cKeNFSCJNoOk + "<br/>"
	cMsg += "</body></html>"
	
	oMail:cFrom	 	:= cEmailFrom
	oMail:cTo			:= cEmailTo
	oMail:cSubject	:= "Referência incorreta - NF SCJ > NF RET"
	oMail:cBody		:= cMsg
	oMail:lSilence	:= .T.
	
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "[" + DToC(dDataBase) + " - " + Time() + "] - Envio de e-mail de: " + cEmailFrom  , 0, 0, {})
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "[" + DToC(dDataBase) + " - " + Time() + "] - Para: " + cEmailTo , 0, 0, {})
	
	If oMail:Send()
		FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "================= [" + DToC(dDataBase) + " - " + Time() + "] - E-mail enviado com sucesso.", 0, 0, {})
	Else
		cDesc1 := "E-mail"
		cDesc2 := "Não foi possível enviar o e-mail - Referência incorreta - NF SCJ > NF RET"
		oLog:start(APP_SAP, DHL_IMPORTACAO)
		oLog:fail(cDesc1,cDesc2)
	EndIf
	
return