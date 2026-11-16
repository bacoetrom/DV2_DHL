#include "protheus.ch"
#include "dhl.ch"
#include "topconn.ch"

/*/{Protheus.doc} AglGrvRet
Realiza processamento final da NF RET
@author TOTVS IP
@since 07/11/2023
@version 1.0

@type function
/*/
User Function AglGrvRet()

	local oSql		:= IpSqlObject():newIpSqlObject()
	local oSqlSA1	:= IpSqlObject():newIpSqlObject()
	local oSqlSYA	:= IpSqlObject():newIpSqlObject()
	local oDadosSZ8	:= IpSqlObject():newIpSqlObject()
	local cDoc		:= SF2->F2_ZZNFTER
	local cSerie	:= SF2->F2_ZZSETER
	local cCliente	:= SF2->F2_ZZCLTER
	local cLoja		:= SF2->F2_ZZLJTER
	local lNFRet	:= (SF2->F2_ZZTPNF == RETORNO_SIMBOLICO .and. (FwIsInCallStack("u_ImpMsaNfe") .or. FwIsInCallStack("u_AglControleFaturamento")))
	local oTMsg		:= FswTemplMsg():newTemplMsg("S",SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,"SZZ")
	local cDocRco	:= ""
	local cSerRco	:= ""
	local cMsg		:= ""
	local cCpsSa1	:= "A1_NOME, A1_END, A1_MUN, A1_EST, A1_CGC, A1_INSCR, A1_TIPO, A1_PAIS"
	local dEmiRco 	:= ctod("  /  /  ")

	if lNFRet
		oDadosSZ8:newTable("SZ8", "Z8_NFRCO, Z8_SERRCO, Z8_CLIRCO, Z8_LOJRCO", "Z8_FILIAL = '%SZ8.FILIAL%' "+;
			" AND %SZ8.NOTDEL%  " +;
			" AND SZ8.Z8_DOC = '" + cDoc + "' "+;
			" AND SZ8.Z8_SERIE = '" + cSerie + "' "+;
			" AND SZ8.Z8_CLIEMIT = '" + cCliente + "' "+;
			" AND SZ8.Z8_LOJEMIT = '" + cLoja + "' ")

		oTMsg:carMsg(.F.)

		if oDadosSZ8:hasRecords()
			oSql:newTable("SF2", "F2_DOC, F2_SERIE, F2_EMISSAO, F2_CLIENTE, F2_LOJA", " %SF2.XFILIAL% "+;
				" AND F2_DOC = '" + oDadosSZ8:getValue("Z8_NFRCO") + "' " +;
				" AND F2_SERIE = '" + oDadosSZ8:getValue("Z8_SERRCO") + "' " +;
				" AND F2_CLIENTE = '" + oDadosSZ8:getValue("Z8_CLIRCO") + "' " +;
				" AND F2_LOJA = '" + oDadosSZ8:getValue("Z8_LOJRCO") + "' ")

			oSql:setField("F2_EMISSAO", "D")

			if oSql:hasRecords()
				cDocRco := oSql:getValue("F2_DOC")
				cSerRco := oSql:getValue("F2_SERIE")
				dEmiRco := oSql:getValue("F2_EMISSAO")

				if !Empty(cDocRco) .and. !Empty(cSerRco)

					cMsg += "NF de Remessa por conta e ordem n. " + alltrim(cDocRco) + ", sr. " + alltrim(cSerRco) + ", de " + dtoc(dEmiRco) + ", "
					cMsg += "emitida por " + AllTrim(SM0->M0_NOMECOM) + ", conforme NF de venda do depositante "

					oSqlSA1:newTable("SA1", cCpsSa1, getQrySa1(oSql:getValue("F2_CLIENTE"), oSql:getValue("F2_LOJA")))

				endif

				If oSqlSA1:hasRecords()

					cMsg += "emitida para " + AllTrim(oSqlSA1:getValue("A1_NOME")) + ", situada a " + AllTrim(oSqlSA1:getValue("A1_END")) + " "
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
			EndIf
			oSql:close()
		EndIf
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
