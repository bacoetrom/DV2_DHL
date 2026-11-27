#include 'protheus.ch'
#include 'dhl.ch'

#define NF_TABELA 					"01"

// Wellington Santana 27/11/2026 - [RTC-2026/2027] tolerancia de arredondamento por item na conferencia de IBS/CBS
#define RTC_TOLERANCIA	0.01

/*/{Protheus.doc} PrcNfRco
Processamento NF Remessa por Conta e Ordem
@author Thiago Meschiatti
@since 20/05/2017
@version undefined
@param lGerarRet, logical, Determina se efetuará somente a geração da NF Ret
@history 27/11/2026, Wellington Santana, [RTC-2026/2027] Antes de gerar a NF RCO (MATA920), confere os
         totais de IBS/CBS da SZA (ZA_IBSUFTO/ZA_IBSMUTO/ZA_IBSTOTA/ZA_CBSTOTA) com a soma dos itens da
         SZB e os itens com valor de IBS/CBS sem base (vldRtcSzb). Somente aviso no log.

@type function
/*/

user function PrcNfRco(lGerarRet)

	Local aArea			:= GetArea()
	Local lRet			:= .f.
	Local aHeader 		:= {}
	Local aItems  		:= {}
	Local lIsCreateRCO	:= .F.
	Local lOk			:= .t.
	local lNfRco		:= .F.
	Local lBreak        := .F.

	Private oIp040  	:= DhlIp040Sap():newDhlIp040Sap()
	Private cSerie 	 	:= PadR(GetNewPar("ZZ_SERIRCO", '1'), TamSx3("F2_SERIE")[1]) //Verfiicar série
	Private cDoc		:= ""
	Private cMsgError 	:= ""
	Private oSqlSZB 	:= nil
	Private lTesUpdate	:= .F.

	Default lGerarRet	:= .f.

	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "*********************INICIO FONTE PrcNfRco.PRW " + time() + " USUARIO " + PswRet()[1][2]  + " ********************" + CRLF, 0, 0, {})

	If !lGerarRet
		if isCreateRCO(@lNfRco)
			if lNfRco
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO FONTE PrcNfRco.PRW SETNEWNUMSX5" + time() + " USUARIO " + PswRet()[1][2]  + " ********************" + CRLF, 0, 0, {})
				if empty(SZA->ZA_NFRCOX5)
					lOk := setNewNumSX5()
				endIf
			endIf
		else
			lOk := .f.
			oIp040:showLogError()
		endIf
	EndIf

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO FONTE PrcNfRco.PRW BEGIN TRANSACTION" + time() + " USUARIO " + PswRet()[1][2]  + " ********************" + CRLF, 0, 0, {})
	if lOk
		//BEGIN TRANSACTION   //Emerson Holanda 23/03/18 - Teste faturamento simultaneo
		//BEGIN SEQUENCE    //Emerson Holanda 23/03/18 - Teste faturamento simultaneo

		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO FONTE PrcNfRco.PRW PRCNFRET L:55" + time() + " USUARIO " + PswRet()[1][2]  + " ********************" + CRLF, 0, 0, {})
		If lGerarRet
			If !u_PrcNfRet() //!u_PrcNfRet() //Emerson Holanda 27/03/18 - Faturamento simultaneo
				//BREAK //Emerson Holanda 23/03/18 - Faturamento simultaneo
				lBreak := .T.  //Emerson Holanda 27/03/18 - Faturamento simultaneo
				BackSZB() //Emerson Holanda 07/05/18 // JOJ 24/05/2018
				saveNumSZA("","",.t. /* limpa sza */) // JOJ 24/05/2018
			EndIf
		Else

			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO FONTE PrcNfRco.PRW PREPRCO L:62" + time() + " USUARIO " + PswRet()[1][2]  + " ********************" + CRLF, 0, 0, {})
			If !prepRCO(@aHeader, @aItems, @oSqlSZB)
				//BREAK //Emerson Holanda 23/03/18 - Teste faturamento simultaneo
				lBreak := .T.  //Emerson Holanda 27/03/18 - Faturamento simultaneo
				BackSZB() //Emerson Holanda 07/05/18 // JOJ 24/05/2018
				saveNumSZA("","",.t. /* limpa sza */) // JOJ 24/05/2018
			EndIf
			If !lBreak  //Emerson Holanda 07/05/18
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO FONTE PrcNfRco.PRW HASNFRET L:67" + time() + " USUARIO " + PswRet()[1][2]  + " ********************" + CRLF, 0, 0, {})
				If oIp040:hasNfRet()
					If !u_PrcNfRet()
						//BREAK //Emerson Holanda 23/03/18 - Faturamento simultaneo
						lBreak := .T.  //Emerson Holanda 27/03/18 - Faturamento simultaneo
						BackSZB() //Emerson Holanda 07/05/18
						saveNumSZA("","",.t. /* limpa sza */) // JOJ 24/05/2018
					Endif
				Else
					If !lBreak //Emerson Holanda 29/03/18 - Faturamento simultaneo
						FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO FONTE PrcNfRco.PRW EXECRCO L:74" + time() + " USUARIO " + PswRet()[1][2]  + " ********************" + CRLF, 0, 0, {})
						lRet := execRCO(aHeader, aItems, oSqlSZB)

						if !lRet   //Emerson Holanda 12/06/18
							BackSZB() //Emerson Holanda 07/05/18 // JOJ 24/05/2018

							SZA->(reclock("SZA", .F.))
							SZA->ZA_NFRCOX5 := ""
							SZA->(msUnlock())

							lBreak := .T.

						endIf
					EndIf
				EndIf
			EndIf
		EndIf

		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO FONTE PrcNfRco.PRW U_PRCGRVRCO L:88" + time() + " USUARIO " + PswRet()[1][2]  + " ********************" + CRLF, 0, 0, {})
		If lRet  .And. !lBreak
			dbSelectArea("SF2")
			SF2->(dbSetOrder(1))
			If SF2->(dbSeek(FwXFilial("SF2") + cDoc + cSerie))
				_cDOCSCJ      := SZA->ZA_DOCSCJ
				_cSERISCJ     := SZA->ZA_SERISCJ
				_cNF          := cDoc
				_cSerie       := cSerie

				U_GRAVAFCP(_cSerie,_cNF,_cDOCSCJ,_cSERISCJ) //Acrescentado por Edson Deluca - FIT Gestão - 22.06.2018 - NF 4.0
				If u_PrcGrvRco()
					MsgInfo("NF RCO gerada com sucesso! Doc.: " + cDoc + " Série: " + cSerie)
				Else
					MsgAlert("NF RCO não foi gerada. Por favor verifique!")
					FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********************* NF RCO não foi gerada. Por favor verifique! *********************", 0, 0, {})
					lBreak := .T.
					//BREAK //Emerson Holanda 23/03/18 - Teste faturamento simultaneo
				Endif
			EndIf
		Endif

		//RECOVER //Emerson Holanda 23/03/18 - Teste faturamento simultaneo

		//DisarmTransaction()//Emerson Holanda 23/03/18 - Teste faturamento simultaneo

		//oIp040:showLogError()

		//END SEQUENCE //Emerson Holanda 23/03/18 - Teste faturamento simultaneo
		//END TRANSACTION //Emerson Holanda 23/03/18 - Teste faturamento simultaneo

		//Emerson Holanda 30/04/18 - Apresenta erros caso exista.
		If lBreak
			DisarmTransaction()
			oIp040:showLogError()
		EndIf

	endif

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************FIM FONTE PrcNfRco.PRW " + time() + " USUARIO " + PswRet()[1][2]  + " ********************" + CRLF, 0, 0, {})
	RestArea(aArea)
return


/*
** Prepara informações para RCO
*/
Static Function prepRCO(aHeader, aItems, oSqlSZB)

	Local lRet		:= .t.
	// Inicio TOTVS IP Campinas iVan Oliveira - 15/06/2021 - SCJ - ICMS desonerado
	Local _lIcmDeso	:= SZA->ZA_ICMSDES == 'S'
	// Final  TOTVS IP Campinas iVan Oliveira - 15/06/2021 - SCJ - ICMS desonerado

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO prepRCO IN PrcNfRco.PRW " + time() + " ********************" + CRLF, 0, 0, {})

	oSqlSZB := oIp040:getItensSZB(SZA->ZA_KENFSCJ)

	If !oIp040:validations(oSqlSZB)
		lRet := .f.
	EndIf

	// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027] Confere IBS/CBS do IP_040 (SZA x SZB) antes
	// de gerar a NF RCO. Somente aviso no log: o calculo da nota e do motor de tributos (F2D).
	If lRet
		vldRtcSzb(oSqlSZB)
	EndIf
	// FIM Wellington Santana 27/11/2026

	If lRet .and. !oIp040:HasNfRet()
		mountHeader(@aHeader)

		While oSqlSZB:notIsEof()

			if updPrd(oSqlSZB:getValue("ZB_ITEM"), "B1_PICMRET" , oSqlSZB:getValue("ZB_MVA"))

				lRet := mountDetails(@aItems, oSqlSZB, _lIcmDeso)

				if !lRet
					//Emerson Holanda 30/04/18 - Gravar no log o erro
					FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "**********Retornou falso da funcao mountDetails " + time() + " ********************" + CRLF, 0, 0, {})
					exit
				endIf

			else
				//Emerson Holanda 30/04/18 - Gravar no log o erro
				FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "**********Retornou falso da funcao UPDPRD " + time() + " ********************" + CRLF, 0, 0, {})
				lRet := .F.
				exit

			endIf

			oSqlSZB:skip()
		EndDo
	EndIf

	oSqlSZB:close()

	If !lRet
		DisarmTransaction() //Diogo 26/08/19 - Necessário colocar o DisarmTransaction() para voltar a informação dos campos ZB_PEDIDO e ZB_ITEMPV para vazio, para permitir um novo processamento.
	EndIf

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************FIM prepRCO IN PrcNfRco.PRW " + time() + " ********************" + CRLF, 0, 0, {})

Return (lRet)


/*/{Protheus.doc} vldRtcSzb
Confere os dados de IBS/CBS recebidos do SAP no IP_040 antes da geracao da NF RCO:
- totais da SZA (ZA_IBSUFTO, ZA_IBSMUTO, ZA_CBSTOTA e ZA_IBSTOTA = UF + Mun) contra a
  soma dos itens da SZB (ZB_IBSUFVL, ZB_IBSMUVL, ZB_CBSTXVL). O SAPIP040 grava o total
  pela soma dos itens; divergencia aqui indica SZA/SZB alterada depois da importacao;
- item com valor de IBS UF, IBS Mun ou CBS e sem a base correspondente
  (ZB_IBSUFBS, ZB_IBSMUBS, ZB_CBSTXBS);
- IP_040 sem IBS/CBS em nenhum item (aviso informativo).

[RTC-2026/2027] Somente leitura e somente aviso no log: nao bloqueia a NF RCO, cujo
IBS/CBS/IS e calculado pelo motor de tributos (F2D) no MATA920. A conferencia SAP x F2D
e feita depois, no PrcGrvRco (confIbsCbs). O IP_040 nao tem campo de IS.

Executa somente com ZZ_RTCCONF = .T. (padrao) e dDataBase >= MV_RTC55.
Ao final o cursor da SZB volta para o primeiro registro.

@type function
@author Wellington Santana
@since 27/11/2026
@param oSqlSZB, object, Itens do IP_040 (DHLIp040Sap:getItensSZB)
@return nil
/*/
Static Function vldRtcSzb(oSqlSZB)

	Local lConfere	:= SuperGetMv("ZZ_RTCCONF", .F., .T.)
	Local dDataRTC	:= SuperGetMv("MV_RTC55", .F., SToD("20260105"))
	Local aCpoVal	:= {"ZB_IBSUFVL", "ZB_IBSMUVL", "ZB_CBSTXVL"}
	Local aCpoBas	:= {"ZB_IBSUFBS", "ZB_IBSMUBS", "ZB_CBSTXBS"}
	Local aSomaSzb	:= {0, 0, 0, 0}
	Local aTotSza	:= {}
	Local aNomes	:= {"IBS UF (ZA_IBSUFTO)", "IBS Mun (ZA_IBSMUTO)", "CBS (ZA_CBSTOTA)", "IBS total (ZA_IBSTOTA)"}
	Local nItens	:= 0
	Local nI		:= 0
	Local nTolTot	:= 0
	Local nDiverg	:= 0
	Local cItem		:= ""
	Local cChvLog	:= "[RTC-2026/2027] IP_040 NF SCJ " + AllTrim(SZA->ZA_DOCSCJ) + "/" + AllTrim(SZA->ZA_SERISCJ) + ": "

	If lConfere .and. dDataBase >= dDataRTC

		oSqlSZB:goTop()
		While oSqlSZB:notIsEof()

			nItens++
			cItem := AllTrim(oSqlSZB:getValue("ZB_ITEM")) + "|" + AllTrim(oSqlSZB:getValue("ZB_LINITEM"))

			For nI := 1 To Len(aCpoVal)
				aSomaSzb[nI] += oSqlSZB:getValue(aCpoVal[nI])
				If oSqlSZB:getValue(aCpoVal[nI]) > 0 .and. oSqlSZB:getValue(aCpoBas[nI]) <= 0
					nDiverg++
					FWLogMsg("WARN", , "BusinessObject", "PrcNfRco", "", "01", cChvLog + "item " + cItem + " com " + ;
						aCpoVal[nI] + " = " + AllTrim(Str(oSqlSZB:getValue(aCpoVal[nI]), 16, 2)) + " e " + aCpoBas[nI] + " zerada.", 0, 0, {})
				EndIf
			Next nI

			oSqlSZB:skip()
		EndDo
		oSqlSZB:goTop()

		aSomaSzb[4]	:= aSomaSzb[1] + aSomaSzb[2]
		aTotSza		:= {SZA->ZA_IBSUFTO, SZA->ZA_IBSMUTO, SZA->ZA_CBSTOTA, SZA->ZA_IBSTOTA}
		nTolTot		:= RTC_TOLERANCIA * Max(nItens, 1)

		For nI := 1 To Len(aTotSza)
			If Abs(aTotSza[nI] - aSomaSzb[nI]) > nTolTot
				nDiverg++
				FWLogMsg("WARN", , "BusinessObject", "PrcNfRco", "", "01", cChvLog + "total " + aNomes[nI] + " = " + ;
					AllTrim(Str(aTotSza[nI], 16, 2)) + " diferente da soma dos itens da SZB = " + AllTrim(Str(aSomaSzb[nI], 16, 2)), 0, 0, {})
			EndIf
		Next nI

		If nItens > 0 .and. (aSomaSzb[3] + aSomaSzb[4]) == 0
			FWLogMsg("INFO", , "BusinessObject", "PrcNfRco", "", "01", cChvLog + "SAP nao enviou IBS/CBS nos itens. " + ;
				"A NF RCO sera gerada com o calculo do motor de tributos (F2D).", 0, 0, {})
		EndIf

		If nDiverg > 0
			FWLogMsg("WARN", , "BusinessObject", "PrcNfRco", "", "01", cChvLog + cValToChar(nDiverg) + ;
				" inconsistencia(s) de IBS/CBS no IP_040. Chave NF SCJ: " + AllTrim(SZA->ZA_KENFSCJ), 0, 0, {})
		EndIf

	EndIf

Return


/*
** Execução da NF RCO
*/
Static Function execRCO(aHeader, aItems, oSqlSZB)

	Local lRet := .t.
	Private lMsErroAuto	:= .f.

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO execRCO IN PrcNfRco.PRW " + time() + " ********************" + CRLF, 0, 0, {})

	If Empty(cMsgError)
		MsExecAuto({|x,y,z| mata920(x,y,z)},aHeader,aItems,3)

		If lMsErroAuto
			MostraErro()
			//DisarmTransaction()
			lRet := .f.
		EndIf
	EndIf

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************FIM execRCO IN PrcNfRco.PRW " + time() + " ********************" + CRLF, 0, 0, {})

Return (lRet)


/*
** Monta cabeçalho da NF RCO
*/
Static Function mountHeader(aHeader)
	Local oSql     := IpSqlObject():newIpSqlObject()
	Local aLockSX6 := {}

	cDoc	   := substr(SZA->ZA_NFRCOX5, 1 ,TamSx3("F2_DOC")[1])
	/*
	aLockSX6 := SX6->(DBRLockList())

	cDoc := AllTrim(oSql:getFieldValue("SX5", "X5_DESCRI", "%SX5.XFILIAL% AND X5_TABELA = '"+NF_TABELA+"' AND X5_CHAVE = '"+cSerie+"'"))
	contrSx5(cDoc, cSerie)
	//TODO Momento de execução de NF de entrada, função esta pulando duas numerações
	//cDoc := NxtSX5Nota(cSerie, NIL, GetNewPar("MV_TPNRNFS", "1"))
	oSql:close()

	aLockSX6 := SX6->(DBRLockList())

	For nX := 1 To Len(aLockSX6)

	SX6->(DBGoTo(aLockSX6[nX]))
	SX6->(MSUnLock())

	Next nX
	*/


	aAdd(aHeader, {"F2_TIPO"	, PadR( "N", TamSx3("F2_TIPO")[1] )			, nil})
	aAdd(aHeader, {"F2_FORMUL"	, 'S'										, nil})
	aAdd(aHeader, {"F2_DOC"		, PadR( cDoc, TamSx3("F2_DOC")[1] )			, nil})
	aAdd(aHeader, {"F2_SERIE"	, PadR( cSerie, TamSx3("F2_SERIE")[1] ) 	, nil})
	aAdd(aHeader, {"F2_EMISSAO"	, dDataBase									, nil})
	aAdd(aHeader, {"F2_CLIENTE"	, oIp040:getCustomerUnit(SZA->ZA_BUYCODE)[1]	, nil})
	aAdd(aHeader, {"F2_LOJA"	, oIp040:getCustomerUnit(SZA->ZA_BUYCODE)[2]	, nil})
	If !empty(SZA->ZA_DELCODE)
		aAdd(aHeader, {"F2_CLIENT"	, oIp040:getCustomerUnit(SZA->ZA_DELCODE)[1]	, nil})
		aAdd(aHeader, {"F2_LOJENT"	, oIp040:getCustomerUnit(SZA->ZA_DELCODE)[2]	, nil})
	EndIf
	aAdd(aHeader, {"F2_ESPECIE"	, PadR( "SPED", TamSx3("F2_ESPECIE")[1] )	, nil})
	aAdd(aHeader, {"F2_COND"	, PadR( "001", TamSx3("F2_COND")[1] )		, nil})
	aAdd(aHeader, {"F2_DESCONT"	, SZA->ZA_TDISAMO							, nil})
	aAdd(aHeader, {"F2_FRETE"	, 0											, nil})
	aAdd(aHeader, {"F2_SEGURO"	, 0											, nil})
	aAdd(aHeader, {"F2_DESPESA"	, 0											, nil})
	aAdd(aHeader, {"F2_TRANSP"	, oIp040:getCarrier(SZA->ZA_CNPJCAR)					, nil})
	aAdd(aHeader, {"F2_PLIQUI"  , SZA->ZA_NETWEIG                           , nil})
	aAdd(aHeader, {"F2_PBRUTO"  , SZA->ZA_GROWEIG                           , nil})
	aAdd(aHeader, {"F2_VOLUME1" , "VOL"                                     , nil})
	aAdd(aHeader, {"F2_ESPECI1" , Str(SZA->ZA_NUMPACK)                      , nil})
	aAdd(aHeader, {"F2_HORA" 	, SUBSTR(TIME(), 1, 5)                      , nil})


Return


/*
** Monta itens da NF RCO
*/
Static Function mountDetails(aItems, oSqlSZB, __lIcmDeso)

	Local oSql		:= IpSqlObject():newIpSqlObject()
	Local aAux		:= {}
	Local cItem		:= ""
	local lStatus	:= .T.

	if len(aItems) == 0
		cItem := "01"
	else
		cItem := Soma1(aItems[len(aItems),1,2])
	endif

	if oSqlSZB:getValue("ZB_PREDBAS") != 0 .and. !lTesUpdate
		If getCstTes(oSqlSZB:getValue("ZB_TES")) $ "20"
			if !oSql:update("SF4", "F4_BASEICM = " + str(oSqlSZB:getValue("ZB_PREDBAS")) + " ", "%SF4.XFILIAL% AND F4_CODIGO = '" + oSqlSZB:getValue("ZB_TES") + "'")
				lStatus 	:= .F.
				oIp040:setMsgError("Não foi possível atualizar o campo F4_BASEICM. O processamento será abortado")
				MsgAlert("Não foi possível atualizar o campo F4_BASEICM. O processamento será abortado")

			endIf
			lTesUpdate 	:= .T.
		else
		EndIf
	endIf

	aAdd(aAux, {"D2_ITEM"	, cItem													   	,nil})
	aAdd(aAux, {"D2_COD"	, PadR( oSqlSZB:getValue("ZB_ITEM"), TamSx3("D2_COD")[1] ) 	, nil})

	// Inicio TOTVS IP Campinas iVan Oliveira - 15/06/2021 - SCJ - ICMS desonerado
	_nVlrUni := oSqlSZB:getValue("ZB_UNIVALU")

	if  .F. //__lIcmDeso

		_nAlICMDes:= if(Val(oSqlSZB:getValue("ZB_ICMEXRE"))>0, Val(oSqlSZB:getValue("ZB_ICMEXRE")), 7)
		_nVlrTmp  := (_nVlrUni * _nAlICMDes) / 100
		_nVlrUni  := _nVlrUni - _nVlrTmp

	Endif
	// Final TOTVS IP Campinas iVan Oliveira - 15/06/2021 - SCJ - ICMS desonerado

	aAdd(aAux, {"D2_QUANT"	, oSqlSZB:getValue("ZB_QUANTIT")						   			, nil})
	aAdd(aAux, {"D2_PRCVEN"	, _nVlrUni						   									, nil})
	aAdd(aAux, {"D2_TOTAL"	, A410Arred(oSqlSZB:getValue("ZB_QUANTIT") * _nVlrUni ,"C6_VALOR")	, nil})
	aAdd(aAux, {"D2_TES"	, PadR( oSqlSZB:getValue("ZB_TES"), TamSx3("D2_TES")[1] )			, nil})
	aAdd(aAux, {"D2_NFORI"	, 	SZA->ZA_DOCSCJ						   							, nil})
	aAdd(aAux, {"D2_SERIORI", 	SZA->ZA_SERISCJ						   							, nil})
	aAdd(aAux, {"D2_ITEMORI", 	oSqlSZB:getValue("ZB_LINITEM")			   						, nil})

	aAdd(aItems, aAux)
Return lStatus


/*
** Coleta o CST da Tes (ICMS)
*/
Static Function getCstTes(cTes)
	Local oSql	:= IpSqlObject():newIpSqlObject()
	Local cRet	:= ""

	cRet := oSql:getFieldValue("SF4", "F4_SITTRIB", " %SF4.XFILIAL% AND F4_CODIGO = '"+ cTes +"'")

	oSql:close()
Return (cRet)

/*
** Atualiza o MVA (B1_PICMRET) do item no cadastro de produtos
*/
Static Function updPrd(cItem, cField , xValue)
	Local oSqlSB1	:= IpSqlObject():newIpSqlObject()
	Local cWhere	:= ""
	Local cUpd		:= ""
	Local lStatus 	:= .T.

	cWhere += " %SB1.XFILIAL% AND "
	cWhere += " B1_COD 		= '" + cItem + "'"

	If ValType(xValue) == "C"
		cUpd	 := cField + " = '" + xValue + "'"
	Else
		cUpd	 := cField + " = " + Str(xValue)
	Endif

	if !oSqlSB1:update("SB1", cUpd, cWhere)
		lStatus := .F.
		oIp040:setMsgError("Não foi possível atualizar o campo B1_PICMRET. O processamento será abortado")
	endif

	oSqlSB1:close()
Return lStatus


/*
** Controla numeração do SX5
*/
static function contrSx5(cNumDoc, cSerie)
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cNumSx5	:= Soma1(cNumDoc)
	local cTipoNf  	:= SuperGetMv("MV_TPNRNFS")
	local cUpd		:= "X5_DESCRI = '"+cNumSx5+"', X5_DESCSPA = '"+cNumSx5+"', X5_DESCENG = '"+cNumSx5+"'"
	local nDif 		:= 0

	oSql:update("SX5",cUpd,"%SX5.XFILIAL% AND X5_TABELA = '"+NF_TABELA+"' AND X5_CHAVE = '"+cSerie+"'")
	oSql:close()
return()

/*
** Define o número da nota
*/
static function setNewNumSX5()

	local aArea 		:= getArea()
	local aAreaSX5	:= {} 
	local aAreaSX3	:= {} 
	local aAreaSD9  := {}
	local cTpNrNfs	:= SuperGetMV("MV_TPNRNFS")
	local cNumDoc		:= ""
	local lOk		:= .t.
	local oSql		:= IpSqlObject():newIpSqlObject()
	
	dbSelectArea("SD9")
	aAreaSD9 := SD9->(getArea())
	aAreaSX5 := SX5->(getArea())
	aAreaSX3 := SX3->(getArea())
	//	cNumDoc := AllTrim(oSql:getFieldValue("SX5", "X5_DESCRI", "%SX5.XFILIAL% AND X5_TABELA = '"+NF_TABELA+"' AND X5_CHAVE = '"+cSerie+"'"))

	//	contrSx5(cNumDoc, cSerie)
	
	dbselectArea("SX3")
	SX3->(DbSetOrder(1))
	If (SX3->(dbSeek("SD9"))) .And. cTpNrNfs == "3"
		conout("** PRCNFRCO** OBTENDO NUMERACAO MA461NumNf ALIAS: " + alias() + " data/hora " + time() + " " + cValToChar(dDataBase) )
		cNumDoc := MA461NumNf(.T., cSerie)
		conout("** PRCNFRCO** OBTIDO NUMERACAO MA461NumNf ALIAS: " + alias() + " data/hora " + time() + " " + cValToChar(dDataBase) )
	Else
		Alert("Não foi possível atribuir número de NF! Verifique o conteúdo do parâmetro MV_TPNRNFS.")
		lOk := .f.
	EndIf

	saveNumSZA(cNumDoc, cSerie,.f.)

	SX3->(restArea(aAreaSX3))
	SX5->(restArea(aAreaSX5))
	SD9->(restArea(aAreaSD9))
	restArea(aArea)

	oSql:close()

return (lOk)

/*
** salva a nmeração reservadoa para a nota SCJ
*/
static function saveNumSZA(cNumDoc, cSerie, lLimpaSZA )

	Default lLimpaSZA	:= .f. //joj 24/05/2018

	If lLimpaSZA
		SZA->(reclock("SZA", .F.))

		SZA->ZA_NFRCOX5 := ""

		msUnlock("SZA")

	else
		if empty(SZA->ZA_NFRCOX5)
			SZA->(reclock("SZA", .F.))

			SZA->ZA_NFRCOX5 := cNumDoc + cSerie

			msUnlock("SZA")
		endIf
	endif
return

/*
** verifica se vai ser criado a RCO
*/
static function isCreateRCO(lNfRco)

	local oSqlSZB 	:= oIp040:getItensSZB(SZA->ZA_KENFSCJ)
	local lRet		:= .T.

	lRet := validQtd(oSqlSZB:COUNT(), SZA->ZA_KENFSCJ, oIp040)

	if lRet
		lNfRco := oIp040:hasNfRco(oSqlSZB)
	endIf

	if lRet
		While oSqlSZB:notIsEof()

			If lNfRco != oIp040:hasNfRco(oSqlSZB)
				oIp040:addMsgError(&("StaticCall(DHLIp040Sap, fMsgOrigDep)"))
				lRet := .f.
			EndIf

			oSqlSZB:skip()
		EndDo
	endIf

	oSqlSZB:goTop()

	If lRet .and. !lNfRco
		oIp040:setNfRet(.t.)
	EndIf

return lRet


/*
** limpa dados SZ, quando encontra problemas em processos após atualização da SZB.
*/
Static Function BackSZB()

	Local lRet		:= .t.

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO BackSZB IN PrcNfRco.PRW " + time() + " ********************" + CRLF, 0, 0, {})

	dbSelectArea("SZB")
	SZB->( dbSetOrder(1) )
	If SZB->( dbSeek(xFilial("SZB")+SZA->ZA_KENFSCJ) )
		While !SZB->( EOF() ) .And. SZB->ZB_KENFSCJ == SZA->ZA_KENFSCJ
			RecLock("SZB",.F.)
			SZB->ZB_PEDIDO = ''
			SZB->ZB_ITEMPV = ''
			SZB->( MsUnlock() )

			BackSB6(SZB->ZB_FILIAL,SZB->ZB_ITEM) //Emerson Holanda 12/06/18 - Retorna o saldo inicial disponivel da tabela de terceiros SZB

			SZB->( dbSkip() )
		end
	EndIf

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************FIM BackSZB IN PrcNfRco.PRW " + time() + " ********************" + CRLF, 0, 0, {})

Return (lRet)


/*
Emerson Holanda - 12/06/18
** Limpa campo B6_XDTUMOV, para que a analise do saldo seja efetuada novamente para o proximo processo
utilizando o campo o campo B6_SALDO inves do campo B6_XQTDMOV

*/
Static Function BackSB6(cB6FIL,cProdut)

	Local lRet		:= .t.
	Local cAliasNew := GetNextAlias()
	Local cQuery    := ""

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO BackSB6 IN PrcNfRco.PRW - CHaVe: "+SZA->ZA_KENFSCJ +' - ' + time() + " ********************" + CRLF, 0, 0, {})

	cQuery := " SELECT R_E_C_N_O_ RECSB6  "
	cQuery += " FROM "+RetSqlName('SB6')+" SB6 "
	cQuery += " WHERE SB6.B6_FILIAL = '"+cB6FIL+"'"
	cQuery += " AND   SB6.B6_PRODUTO    = '"+cProdut+"'"
	cQuery += " AND   SB6.D_E_L_E_T_ <> '*' "
	cQuery += " AND   SB6.B6_XDTUMOV   = '"+Dtos(dDataBase) +"'"
	cQuery += " AND   SB6.B6_PODER3 = 'R' "
	cQuery += " AND   SB6.B6_SALDO > 0 "
	cQuery += " ORDER BY SB6.B6_DTDIGIT "
	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasNew,.F.,.T.)

	(cAliasNew)->( DbGoTop() )

	If !(cAliasNew)->( Eof() )
		While !(cAliasNew)->( Eof() )
			dbSelectArea("SB6")
			dbGoTo( (cAliasNew)->( RECSB6 ) )
			//Altera Registros
			Reclock("SB6",.F.)

			SB6->B6_XDTUMOV := CToD("  /  /  ")
			SB6->B6_XQTDMOV := SB6->B6_SALDO - SB6->B6_QULIB

			SB6->( MsUnlock() )

			(cAliasNew)->( DbSkip() )
		End
		(cAliasNew)->( DbCloseArea() )

		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************Executou BackSB6 IN PrcNfRco.PRW - CHaVe: "+SZA->ZA_KENFSCJ +' - ' + time() + " ********************" + CRLF, 0, 0, {})

	EndIf

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************FIM BackSZB IN PrcNfRco.PRW " + time() + " ********************" + CRLF, 0, 0, {})

Return (lRet)

/**
* Valida se a quaantidade resultado da query amarração SA7 é a mesma referente a quantidade dos itens SZB
**/
static function validQtd(nQtdSZBSA7, cChaveSZA, oIp040)

	local lValidQtd 	:= .F.
	local cQuery    	:= ""	
	local cAliasSZB		:= GetNextAlias()
	local nQtdItensSZB 	:= 0
	local aArea			:= getArea()
	local aAreaSZB      := SZB->(getArea())

	BeginSql Alias cAliasSZB
		SELECT COUNT(*) QTD_ITENS
		FROM %Table:SZB% ZB
		WHERE
		ZB_FILIAL	= %xFilial:SZB% AND
		ZB_KENFSCJ 	= %Exp:cChaveSZA% AND		
		ZB.%NotDel%
	EndSql	

	If (cAliasSZB)->(!Eof())
		nQtdItensSZB := (cAliasSZB)->QTD_ITENS
	EndIf 

	if nQtdItensSZB ==  nQtdSZBSA7
		lValidQtd := .T.
	else
		oIp040:addMsgError("Quantidade retornado da amarração Produto x Cliente diferente da quantidade de itens na SZB. Amarração Produto x Cliente: " + cValToChar(nQtdSZBSA7) + ". Quantidade SZB itens: " + cValToChar(nQtdItensSZB))
	endIf

	(cAliasSZB)->(dbCloseArea())
	
	restArea(aAreaSZB)
	restArea(aArea)

return lValidQtd
