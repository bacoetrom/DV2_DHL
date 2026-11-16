#Include 'Protheus.ch'
#include "dhl.ch"


/*/{Protheus.doc} updImpCD2
Rotina para atualizar a CD2 campos CD2_PFCP, CD2_VFCP, CD2_BFCP (Fundo de Pobreza) quando houver uma devolução
@author Gustavo Luiz
@since 30/07/2018
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
User Function updImpCD2()
	
	local cFilialSF1 	:= SF1->F1_FILIAL
	local cDoc			:= SF1->F1_DOC
	local cSerie		:= SF1->F1_SERIE
	local cCliForEnt	:= SF1->F1_FORNECE
	local cLoja			:= SF1->F1_LOJA
	local cChaveSD1		:= cFilialSF1 + cDoc + cSerie + cCliForEnt + cLoja
	local cNfOri		:= ""
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

	if cDoc != "000000000"
		SD1->(dbSetOrder(1))
		if SD1->(dbSeek(cChaveSD1))
			
			while SD1->(!eof()) == SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == cChaveSD1
				
				cNfOri		:= SD1->D1_NFORI
				cSerieOri	:= SD1->D1_SERIORI
				cItemOri	:= SD1->D1_ITEMORI
				cCodProd	:= SD1->D1_COD
				cItemSD1	:= SD1->D1_ITEM
				
				getCliLojSaid(cNfOri, cSerieOri, @cCliForSai, @cLojaSaid)
				
				aFCP_ICM	:= getValoresFCP(cNfOri, cSerieOri, cItemOri, cCodProd, cCliForSai, cLoja, "ICM")
				aFCP_SOL	:= getValoresFCP(cNfOri, cSerieOri, cItemOri, cCodProd, cCliForSai, cLoja, "SOL")
				
				if len(aFCP_ICM) > 0
					atualizCD2Entr(cDoc, cSerie, cItemSD1, cCodProd, cCliForEnt, cLoja, "ICM", aFCP_ICM)
					atualizSFT(cDoc, cSerie, cItemSD1, cCodProd, cCliForEnt, cLoja, "ICM", aFCP_ICM)
				endIf
				
				if len(aFCP_SOL) > 0
					atualizCD2Entr(cDoc, cSerie, cItemSD1, cCodProd, cCliForEnt, cLoja, "SOL", aFCP_SOL)
					atualizSFT(cDoc, cSerie, cItemSD1, cCodProd, cCliForEnt, cLoja, "SOL", aFCP_SOL)
				endIf
				
				getTRIB(@cUTRIB, @nQTRIB, cNfOri, cSerieOri, cItemOri, cCodProd)
				atualizSD2Trib(cUTRIB, nQTRIB)
				
				SD1->(dbSkip())
				
			endDo
		endIf
	endIf
	
Return

/**
* Atualiza a CD2 (Entrada)
**/
static function atualizCD2Entr(cDoc, cSerie, cItemSD1, cCodProd, cCliForEnt, cLoja, cImposto, aFCP_IMPOSTO)
	
	local cChaveCD2 := fwxFilial("CD2") + "E" + cSerie + cDoc + cCliForEnt + cLoja + cItemSD1 + cCodProd + cImposto
	local nPFCP		:= 0
	local nVFCP		:= 0
	local nBFCP		:= 0
	local aValFCP	:= {}
	local aArea 	:= getArea()
	local aAreaCD2	:= CD2->(getArea())
	
	CD2->(dbSetOrder(1))
	
	if CD2->(dbSeek(cChaveCD2))
		
		nPFCP := aFCP_IMPOSTO[1][1]
		nVFCP := aFCP_IMPOSTO[2][1]
		nBFCP := aFCP_IMPOSTO[3][1]
		
		if CD2->(reclock("CD2", .F.))
			
			CD2->CD2_PFCP := nPFCP
			CD2->CD2_VFCP := nVFCP
			CD2->CD2_BFCP := nBFCP
		
		endIf
		
	endIf
	
	restArea(aAreaCD2)
	restArea(aArea)
	
return


/**
* obtém os valores do fundo de pobreza
**/
static function getValoresFCP(cNfOri, cSerieOri, cItemOri, cCodProd, cCliForEnt, cLoja, cImposto)
	
	local cChaveCD2 := fwxFilial("CD2") + "S" + cSerieOri + cNfOri + cCliForEnt + cLoja + cItemOri + cCodProd + cImposto
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
* obtém a unidade tributável e quantidade tributável
**/
static function getTRIB(cUTRIB, nQTRIB, cNfOri, cSerieOri, cItemOri, cCodProd)
	
	local cQuery 	:= ""
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cKey040	:= ""
	local aArea 	:= getArea()
	local aAreaSF2	:= SF2->(getArea())
	local cChaveSF2	:= fwxFilial("SF2") + cNfOri + cSerieOri
	
	cQuery := "SELECT         ZA_KENFSCJ "								+ CRLF
	cQuery += "FROM           SZA100 SZA " 								+ CRLF
	cQuery += "INNER JOIN     SD1100 SD1 ON " 							+ CRLF
	cQuery += "    SZA.ZA_NFRCO = SD1.D1_NFORI AND " 					+ CRLF
	cQuery += "    SZA.ZA_SERIRCO = SD1.D1_SERIE AND " 					+ CRLF
	cQuery += "    SZA.ZA_FILIAL = SD1.D1_FILIAL " 						+ CRLF
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
	
	SF2->(dbSetOrder(1))
	
	if SF2->(dbSeek(cChaveSF2))		
		If SF2->F2_ZZTPNF == REMESSA_CONTA_ORDEM
	
			cUtrib 	:= oSql:getFieldValue("SZB", "ZB_UTRIB", "ZB_KENFSCJ = '" + cKey040 + "' AND ZB_ITEM = '" + cCodProd + "'  AND %SZB.XFILIAL% AND %SZB.NOTDEL%")
			nQTRIB	:= oSql:getFieldValue("SZB", "ZB_QTRIB", "ZB_KENFSCJ = '" + cKey040 + "' AND ZB_ITEM = '" + cCodProd + "'  AND %SZB.XFILIAL% AND %SZB.NOTDEL%")
			
		endIf
	endIf
	
	oSql:close()
	
	restArea(aAreaSF2)
	restArea(aArea)
	
return

/**
* grava a unidade tributável e quantidade tributável na SD1
**/
static function atualizSD2Trib(cUTRIB, nQTRIB)
	
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
		endIf
		
	endIf
	
	restArea(aAreaSFT)
	restArea(aArea)
	
return