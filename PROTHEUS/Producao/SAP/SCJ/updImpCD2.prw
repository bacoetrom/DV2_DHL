#include "totvs.ch"
#include "dhl.ch"


/*/{Protheus.doc} updImpCD2
Rotina para atualizar a CD2 campos CD2_PFCP, CD2_VFCP, CD2_BFCP (Fundo de Pobreza) quando houver uma devolução
@author Gustavo Luiz
@since 30/07/2018
@version 1.1
@history 21/11/2026, Pablo Regis, [RTC-2026/2027] Correções de comunicação entre NF original
         e NF de devolução/crédito: condição do While, MsUnlock ausente em CD2/SFT, loja do
         cliente da saída, série original no vínculo SZA, nomes físicos via %XXX.SQLNAME%,
         consulta da chave IP_040 fora do laço. Chamada estendida (MT103FIM) para Nota de
         Crédito finNFe 5 de devolução/recusa (subtipos parametrizados em ZZ_UPDCD2C).
@type function
@example
U_updImpCD2() // SF1 posicionada
/*/
User Function updImpCD2()

	local cFilialSF1 	:= SF1->F1_FILIAL
	local cDoc			:= SF1->F1_DOC
	local cSerie		:= SF1->F1_SERIE
	local cCliForEnt	:= SF1->F1_FORNECE
	local cLoja			:= SF1->F1_LOJA
	local cChaveSD1		:= cFilialSF1 + cDoc + cSerie + cCliForEnt + cLoja
	local cNfOri		:= ""
	local cSerieOri		:= ""
	local cItemOri		:= ""
	local cCodProd		:= ""
	local cItemSD1		:= ""
	local aFCP_ICM		:= {}
	local aFCP_SOL		:= {}
	local aArea			:= getArea()
	local aAreaSD1		:= SD1->(getArea())
	local cCliForSai	:= ""
	local cLojaSaid		:= ""
	local cUTRIB		:= ""
	local nQTRIB		:= 0
	local cKey040		:= ""

	if cDoc != "000000000"

		// [RTC-2026/2027] A chave IP_040 depende só do documento de entrada: consulta uma vez (antes: 1 query por item - G2)
		cKey040 := getKey040()

		SD1->(dbSetOrder(1))
		if SD1->(dbSeek(cChaveSD1))

			// [RTC-2026/2027] Correção: antes "SD1->(!eof()) == SD1->(chave) == cChaveSD1" comparava
			// lógico com caractere (precedência incorreta) e não delimitava o documento.
			while SD1->(!eof()) .and. SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == cChaveSD1

				cNfOri		:= SD1->D1_NFORI
				cSerieOri	:= SD1->D1_SERIORI
				cItemOri	:= SD1->D1_ITEMORI
				cCodProd	:= SD1->D1_COD
				cItemSD1	:= SD1->D1_ITEM
				cCliForSai	:= ""
				cLojaSaid	:= ""
				cUTRIB		:= ""
				nQTRIB		:= 0

				if !Empty(cNfOri)

					getCliLojSaid(cNfOri, cSerieOri, @cCliForSai, @cLojaSaid)

					// [RTC-2026/2027] Correção: a CD2 da saída é gravada com a loja do cliente da NF
					// original (cLojaSaid); antes usava a loja da entrada (cLoja).
					aFCP_ICM	:= getValoresFCP(cNfOri, cSerieOri, cItemOri, cCodProd, cCliForSai, cLojaSaid, "ICM")
					aFCP_SOL	:= getValoresFCP(cNfOri, cSerieOri, cItemOri, cCodProd, cCliForSai, cLojaSaid, "SOL")

					if len(aFCP_ICM) > 0
						atualizCD2Entr(cDoc, cSerie, cItemSD1, cCodProd, cCliForEnt, cLoja, "ICM", aFCP_ICM)
						atualizSFT(cDoc, cSerie, cItemSD1, cCodProd, cCliForEnt, cLoja, "ICM", aFCP_ICM)
					endIf

					if len(aFCP_SOL) > 0
						atualizCD2Entr(cDoc, cSerie, cItemSD1, cCodProd, cCliForEnt, cLoja, "SOL", aFCP_SOL)
						atualizSFT(cDoc, cSerie, cItemSD1, cCodProd, cCliForEnt, cLoja, "SOL", aFCP_SOL)
					endIf

					getTRIB(@cUTRIB, @nQTRIB, cKey040, cNfOri, cSerieOri, cCodProd)
					atualizSD2Trib(cUTRIB, nQTRIB)

				endIf

				SD1->(dbSkip())

			endDo
		endIf
	endIf

	restArea(aAreaSD1)
	restArea(aArea)

Return

/**
* Atualiza a CD2 (Entrada)
**/
static function atualizCD2Entr(cDoc, cSerie, cItemSD1, cCodProd, cCliForEnt, cLoja, cImposto, aFCP_IMPOSTO)

	local cChaveCD2 := fwxFilial("CD2") + "E" + cSerie + cDoc + cCliForEnt + cLoja + cItemSD1 + cCodProd + cImposto
	local aArea 	:= getArea()
	local aAreaCD2	:= CD2->(getArea())

	CD2->(dbSetOrder(1))

	if CD2->(dbSeek(cChaveCD2))

		if CD2->(reclock("CD2", .F.))

			CD2->CD2_PFCP := aFCP_IMPOSTO[1][1]
			CD2->CD2_VFCP := aFCP_IMPOSTO[2][1]
			CD2->CD2_BFCP := aFCP_IMPOSTO[3][1]
			// [RTC-2026/2027] Correção: faltava liberar o registro (lock mantido até o fim da thread)
			CD2->(msUnlock())

		endIf

	endIf

	restArea(aAreaCD2)
	restArea(aArea)

return


/**
* obtém os valores do fundo de pobreza
**/
static function getValoresFCP(cNfOri, cSerieOri, cItemOri, cCodProd, cCliForSai, cLojaSaid, cImposto)

	local cChaveCD2 := fwxFilial("CD2") + "S" + cSerieOri + cNfOri + cCliForSai + cLojaSaid + cItemOri + cCodProd + cImposto
	local nPFCP		:= 0
	local nVFCP		:= 0
	local nBFCP		:= 0
	local aValFCP	:= {}
	local aArea		:= getArea()
	local aAreaCD2	:= CD2->(getArea())

	CD2->(dbSetOrder(1))

	if CD2->(dbSeek(cChaveCD2))

		nPFCP := CD2->CD2_PFCP
		nVFCP := CD2->CD2_VFCP
		nBFCP := CD2->CD2_BFCP

		if nPFCP != 0 .or. nVFCP != 0 .or. nBFCP != 0
			aAdd(aValFCP, {nPFCP, "PFCP", cImposto })
			aAdd(aValFCP, {nVFCP, "VFCP", cImposto })
			aAdd(aValFCP, {nBFCP, "BFCP", cImposto })
		endIf

	endIf

	restArea(aAreaCD2)
	restArea(aArea)

return aValFCP

/**
* obtém o cliente/loja da saída
**/
static function getCliLojSaid(cNfOri, cSerieOri, cCliForSai, cLojaSaid)

	local aArea 	:= getArea()
	local aAreaSF2	:= SF2->(getArea())
	local cChaveSF2	:= fwxFilial("SF2") + cNfOri + cSerieOri

	SF2->(dbSetOrder(1))

	if SF2->(dbSeek(cChaveSF2))

		cCliForSai   := SF2->F2_CLIENTE
		cLojaSaid	 := SF2->F2_LOJA

	endIf

	restArea(aAreaSF2)
	restArea(aArea)

return

/**
* obtém a chave da interface IP_040 (ZA_KENFSCJ) vinculada à NF original da entrada posicionada
* [RTC-2026/2027] Nomes físicos via %XXX.SQLNAME% (antes SZA100/SD1100 fixos) e filtro D_E_L_E_T_ na SZA.
* Vínculo pela série ORIGINAL (D1_SERIORI); antes comparava ZA_SERIRCO com a série da entrada (D1_SERIE).
**/
static function getKey040()

	local cQuery 	:= ""
	local cKey040	:= ""
	local oSql		:= IpSqlObject():newIpSqlObject()

	cQuery := "SELECT         ZA_KENFSCJ "								+ CRLF
	cQuery += "FROM           %SZA.SQLNAME% " 							+ CRLF
	cQuery += "INNER JOIN     %SD1.SQLNAME% ON " 						+ CRLF
	cQuery += "    SZA.ZA_NFRCO   = SD1.D1_NFORI AND " 					+ CRLF
	cQuery += "    SZA.ZA_SERIRCO = SD1.D1_SERIORI AND " 				+ CRLF
	cQuery += "    SZA.ZA_FILIAL  = SD1.D1_FILIAL AND " 				+ CRLF
	cQuery += "    %SZA.NOTDEL% " 										+ CRLF
	cQuery += "WHERE SD1.D1_DOC 	= '" + SF1->F1_DOC + "' AND "  		+ CRLF
	cQuery += "		 SD1.D1_SERIE 	= '" + SF1->F1_SERIE + "' AND " 	+ CRLF
	cQuery += "		 SD1.D1_FORNECE = '" + SF1->F1_FORNECE + "' AND " 	+ CRLF
	cQuery += "		 SD1.D1_LOJA 	= '" + SF1->F1_LOJA + "' AND " 		+ CRLF
	cQuery += "		%SD1.XFILIAL% AND %SD1.NOTDEL% "

	oSql:newAlias(cQuery)

	While oSql:notIsEof()
		cKey040 := AllTrim(oSql:getValue("ZA_KENFSCJ"))
		oSql:skip()
	EndDo

	oSql:close()

return cKey040

/**
* obtém a unidade tributável e quantidade tributável
**/
static function getTRIB(cUTRIB, nQTRIB, cKey040, cNfOri, cSerieOri, cCodProd)

	local oSql		:= nil
	local aArea 	:= getArea()
	local aAreaSF2	:= SF2->(getArea())
	local cChaveSF2	:= fwxFilial("SF2") + cNfOri + cSerieOri

	if !Empty(cKey040)

		SF2->(dbSetOrder(1))

		if SF2->(dbSeek(cChaveSF2))
			If SF2->F2_ZZTPNF == REMESSA_CONTA_ORDEM

				oSql	:= IpSqlObject():newIpSqlObject()
				cUtrib 	:= oSql:getFieldValue("SZB", "ZB_UTRIB", "ZB_KENFSCJ = '" + cKey040 + "' AND ZB_ITEM = '" + cCodProd + "'  AND %SZB.XFILIAL% AND %SZB.NOTDEL%")
				nQTRIB	:= oSql:getFieldValue("SZB", "ZB_QTRIB", "ZB_KENFSCJ = '" + cKey040 + "' AND ZB_ITEM = '" + cCodProd + "'  AND %SZB.XFILIAL% AND %SZB.NOTDEL%")

			endIf
		endIf

	endIf

	restArea(aAreaSF2)
	restArea(aArea)

return

/**
* grava a unidade tributável e quantidade tributável na SD1
* [RTC-2026/2027] Só grava quando houver valor: não apaga D1_ZZUTRIB/D1_ZZQTRIB de NF sem vínculo IP_040.
**/
static function atualizSD2Trib(cUTRIB, nQTRIB)

	if Empty(cUTRIB) .and. Empty(nQTRIB)
		return
	endIf

	if SD1->(reclock("SD1", .F.))

		SD1->D1_ZZUTRIB := cUTRIB
		SD1->D1_ZZQTRIB := nQTRIB
		SD1->(msUnlock())

	endIf

return


/**
* Atualiza a SFT (Entrada)
**/
static function atualizSFT(cDoc, cSerie, cItemSD1, cCodProd, cCliForEnt, cLoja, cImposto, aFCP_IMPOSTO)

	local cChaveSFT := fwxFilial("SFT") + "E" + cSerie + cDoc + cCliForEnt + cLoja + cItemSD1 + cCodProd
	local nVFCP		:= 0
	local aArea 	:= getArea()
	local aAreaSFT	:= SFT->(getArea())

	SFT->(dbSetOrder(1))

	if SFT->(dbSeek(cChaveSFT))

		nVFCP := aFCP_IMPOSTO[2][1]

		if SFT->(reclock("SFT", .F.))

			If cImposto == "ICM"
				SFT->FT_VALFECP := nVFCP
			ElseIf cImposto == "SOL"
				SFT->FT_VFECPST := nVFCP
			EndIf
			// [RTC-2026/2027] Correção: faltava liberar o registro
			SFT->(msUnlock())
		endIf

	endIf

	restArea(aAreaSFT)
	restArea(aArea)

return
