#include 'totvs.ch'	// Wellington Santana 27/11/2026 - antes protheus.ch (include obsoleto)
#include "dhl.ch"

#define POS_DELIVERY	1
#define POS_CLIENTE	2
#define POS_LOJA		3
#define POS_QUANT		4
#define POS_ITENS		5

#define POS_NUMPV		1
#define POS_ITEMPV		2
#define POS_PRODUTO		3

/*/{Protheus.doc} PrcNfRet
Processamento NF Retorno Simbólico
@author Diogo Mesquita
@since 25/05/2017
@version undefined
@history 27/11/2026, Wellington Santana, [RTC-2026/2027] Apos gerar a NF de retorno simbolico (MaPvlNFS),
         registra no log o IBS UF/IBS Mun/CBS/IS calculado pelo motor de tributos (F2D) e avisa quando
         a nota nao tem IBS/CBS na F2D (audRtcRet). Os valores do SAP (SZB) sao da venda e nao sao
         usados no retorno. Somente leitura.

@type function
/*/
user function PrcNfRet(cDocument, cSeries)
	
	local lRet			:= .t.
	local nRecno		:= 0
	local aAreas		:= {}
	local aDadosNF	:= {}
	local lImpMsaNfe	:= .f.
	
	private oIp040  	:= DhlIp040Sap():newDhlIp040Sap()
	private cMsgError	:= ""
	private oSqlSZB 	:= nil
	private aItLibPV	:= {}
	private oLog		:= DHLLogManager():newDHLLogManager()
	private cArq		:= ""
	
	default cDocument	:= ""
	default cSeries		:= ""
	
	aAreas	:= oIp040:oUtils:saveAreas({"SZA","SZB","SC5","SC6"})
	
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "*********************INICIO FONTE PrcNfRet.PRW " + time() + " USUARIO " + __cUserID  + " ********************" + CRLF, 0, 0, {})
	
	//BEGIN TRANSACTION //Emerson Holanda 23/03/18 - Teste faturamento simultaneo
		//BEGIN SEQUENCE //Emerson Holanda 23/03/18 - Teste faturamento simultaneo
			
			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO FONTE PrcNfRet.PRW  BUSCA SZA L:47" + time() + " USUARIO " + __cUserID  + " ********************" + CRLF, 0, 0, {})
			if !Empty(cDocument) .and. !Empty(cSeries)
				oIp040:oSql:newTable("SZA", "R_E_C_N_O_", "ZA_FILIAL = '%SZA.FILIAL%' AND ZA_NFRCO = '"+cDocument+"' AND ZA_SERIRCO = '"+cSeries+"' ")
				nRecno := oIp040:oSql:getValue("R_E_C_N_O_")
				oIp040:oSql:close()
				
				SZA->(DbSelectArea("SZA"))
				SZA->(DbSetOrder(0))
				SZA->(DbGoTo(nRecno))
				lImpMsaNfe := .t.
			endif
			
			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO FONTE PrcNfRet.PRW  VAILIDACAO ZA_NFRET SZA L:59" + time() + " USUARIO " + __cUserID  + " ********************" + CRLF, 0, 0, {})
			if Empty(SZA->ZA_NFRET) .and. Empty(SZA->ZA_SERIRET)
				
				if !prepRET(lImpMsaNfe)
					if lImpMsaNfe
						//disarmTransaction() //Emerson Holanda 23/03/18 - Faturamento simultaneo  
						setFileLog("fail",cMsgError)
						lRet := .f. //Emerson Holanda 23/03/18 - Faturamento simultaneo  
					Else //Emerson Holanda 27/03/18 - Faturamento simultaneo
						MsgAlert("Erro ao gerar a nota fiscal de retorno simbólico.")
						lRet := .f.
					endIf
					//BREAK //Emerson Holanda 23/03/18 - Teste faturamento simultaneo   --aqui
				endif

				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO FONTE PrcNfRet.PRW  ANTES EXECRET L:69" + time() + " USUARIO " + __cUserID  + " ********************" + CRLF, 0, 0, {})
				If lRet //Emerson Holanda 27/03/18 - Teste faturamento simultaneo   --aqui
					aDadosNF := execRET()
					if !Empty(aDadosNF)
						SZA->(RecLock("SZA", .F. ))
						SZA->ZA_NFRET   := aDadosNF[1]
						SZA->ZA_SERIRET := aDadosNF[2]
						SZA->(MsUnlock())
						
						_cDOCSCJ      := SZA->ZA_DOCSCJ
						_cSERISCJ     := SZA->ZA_SERISCJ
						_cNF          := aDadosNF[1]
						_cSerie       := aDadosNF[2] 
						
						U_GRAVAFCP(_cSerie,_cNF,_cDOCSCJ,_cSERISCJ) //Acrescentado por Edson Deluca - FIT Gestão - 22.06.2018 - NF 4.0

						// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027] Auditoria do IBS/CBS/IS do retorno
						// simbolico calculado pelo motor de tributos (F2D). Somente leitura: registra no log.
						audRtcRet(aDadosNF[1], aDadosNF[2])
						// FIM Wellington Santana 27/11/2026
					else
						if !lImpMsaNfe
							MsgAlert("Erro ao gerar a nota fiscal de retorno simbólico.") 
							lRet := .f.
						else
						//DisarmTransaction() //Emerson Holanda 23/03/18 - Faturamento simultaneo
						setFileLog("fail","Erro ao gerar a nota fiscal de retorno simbólico.")
						lRet := .f.
						endif
					//BREAK //Emerson Holanda 23/03/18 - Faturamento simultaneo 
					endif
				EndIf//Emerson Holanda 27/03/18 - Teste faturamento simultaneo   --aqui
			endif
			
		//RECOVER //Emerson Holanda 23/03/18 - Faturamento simultaneo
			
			//lRet := .f. //Emerson Holanda 27/03/18 - Faturamento simultaneo
			//DisarmTransaction() //Emerson Holanda 23/03/18 - Faturamento simultaneo
			
			If !Empty(cMsgError)
				Aviso("Atenção", cMsgError, {"OK"}, 3)
			EndIf
			
		//END SEQUENCE //Emerson Holanda 23/03/18 - Faturamento simultaneo
	//END TRANSACTION//Emerson Holanda 23/03/18 - Faturamento simultaneo
	
	oIp040:oUtils:restAreas(aAreas)
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************FIM FONTE PrcNfRet.PRW " + time() + " USUARIO " + __cUserID  + " ********************" + CRLF, 0, 0, {})
	
return (lRet)


/*
** Prepara informações para RET
*/
Static Function prepRET(lImpMsaNfe)
	
	local lRet			:= .t.
	local aDeliverys 	:= {}
	local nI			:= 0
	local nY			:= 0
	local nPos			:= 0
	local cShipment		:= SZA->ZA_SHIPNUM
	local cDelivery		:= ""
	local aCodLoja		:= Array(3)
	local aAux			:= {}
	local aTransp		:= {}
	local cCliente		:= ""
	local cLoja			:= ""
	local lValidCliProd	:= .F.
	local cCliAux		:= ""
	local cLojaAux		:= ""
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO prepRET IN PrcNfRet.prw " + time() + " ********************" + CRLF, 0, 0, {})
	
	oSqlSZB 	  := oIp040:getItensSZB(SZA->ZA_KENFSCJ)
	lValidCliProd := validCliProd(oSqlSZB, @cCliAux, @cLojaAux)
	
	if lValidCliProd
	
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************INICIO prepRET IN PrcNfRet.prw  LACO VALIDACAO CLIENTE X PRODUTO " + time() + " ********************" + CRLF, 0, 0, {})
		while oSqlSZB:notIsEof()
		
			if cCliAux == oSqlSZB:getValue("A7_CLIENTE") .and. cLojaAux == oSqlSZB:getValue("A7_LOJA")
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "*********************INICIO prepRET IN PrcNfRet.prw  LACO VALIDACAO CLIENTE X PRODUTO L:139" + time() + " ********************" + CRLF, "01", "", 0, 0, {})
//				If updMvaPrd(oSqlSZB:getValue("ZB_ITEM"))
//					lRet 		:= .F.
//					exit
//				EndIf
		
				nPos := aScan(aDeliverys,{|x| x[POS_DELIVERY] + x[POS_CLIENTE] + x[POS_LOJA] == oSqlSZB:getValue("ZB_DELIVER") + oSqlSZB:getValue("A7_CLIENTE") + oSqlSZB:getValue("A7_LOJA")})
				if nPos == 0
					aAdd(aDeliverys, {oSqlSZB:getValue("ZB_DELIVER"),oSqlSZB:getValue("A7_CLIENTE"),oSqlSZB:getValue("A7_LOJA"), oSqlSZB:getValue("ZB_QUANTIT"), {oSqlSZB:getValue("ZB_ITEM")}})
				else
					aAdd(aDeliverys[nPos,POS_ITENS],oSqlSZB:getValue("ZB_ITEM"))
					aDeliverys[nPos,POS_QUANT] += oSqlSZB:getValue("ZB_QUANTIT")
				endif
				
			else
				cMsgError 	:= "Foi encontrado divergência na amarração entre produto x cliente. Produto: " + AllTrim(oSqlSZB:getValue("ZB_ITEM"))
				lRet 		:= .F.
				exit
			endIf
			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "*********************INICIO prepRET IN PrcNfRet.prw  LACO VALIDACAO CLIENTE X PRODUTO L:158" + time() + " ********************" + CRLF, "01", "", 0, 0, {})
			oSqlSZB:skip()
		
		enddo
		
		If ( Select ( "TRB" ) <> 0 )
			dbSelectArea ("TRB")
			dbCloseArea ()
		End
		
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "*********************INICIO prepRET IN PrcNfRet.prw CHAMA FOR ALTCLI DELIVERYS L:168" + time() + " ********************" + CRLF, "01", "", 0, 0, {})
		if lRet
			for nI := 1 to len(aDeliverys)
				aTransp := {}
		
				cDelivery := aDeliverys[nI,POS_DELIVERY]
		
				aCodLoja[1] := aDeliverys[nI,POS_CLIENTE]
				aCodLoja[2] := aDeliverys[nI,POS_LOJA]
				aCodLoja[3] := "cliente"
				
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "*********************INICIO prepRET IN PrcNfRet.prw QUERY SC5 L:179" + time() + " ********************" + CRLF, "01", "", 0, 0, {})
				oIp040:oSql:newTable("SC5", "R_E_C_N_O_", "C5_FILIAL = '%SC5.FILIAL%' AND C5_ZZSHIP = '"+cShipment+"' AND C5_ZZORDEX = '"+cDelivery+"' ")
				nRecno := oIp040:oSql:getValue("R_E_C_N_O_")
				oIp040:oSql:close()
		
				SC5->(DbSelectArea("SC5"))
				SC5->(DbSetOrder(0))
				SC5->(DbGoTo(nRecno))
		
				aAdd(aTransp, "")
				aAdd(aTransp, "")
				aAdd(aTransp, aDeliverys[nI, POS_QUANT])
				aAdd(aTransp, "CAIXA")
				
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "*********************INICIO prepRET IN PrcNfRet.prw CHAMADA AG2ALTCLI L:193" + time() + " ********************" + CRLF, "01", "", 0, 0, {})
				aAux := u_Ag2AltCli(aCodLoja,aDeliverys[nI,POS_ITENS],lImpMsaNfe, aTransp)
		
				if !aAux[1]
					lRet := .f.
					EXIT
				else
					for nY := 1 to len(aAux[2])
						aAdd(aItLibPV,aAux[2][nY])
					next nY
				endif
		
			next nI
	
			if !empty(cArq)
				eraseFileTemp()
			endIf
		endIf
	else
		cMsgError 	:= "Foi encontrado divergência na amarração entre produto x cliente"
		lRet := .F.
	endIf

	
	oSqlSZB:Close()
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "*********************FIM prepRET IN PrcNfRet.prw " + time() + " ********************" + CRLF, "01", "", 0, 0, {})
	
Return (lRet)


/*
** Execução da NF RET
*/
Static Function execRET()
	
	local aArea		:= GetArea()
	local aRet			:= {}
	local lContinua	:= .t.
	local nI			:= 0
	local nX			:= 0
	local aPvlNfs		:= {}
	local aAreas		:= {}
	local aLockSX6 		:= {}
	local cModAtu		:= cModulo
	local nModAtu		:= nModulo
	local nRegDAK   	:= 0
	local lMostraCtb 	:= .F.
	local lAglutCtb  	:= .F.
	local lCtbOnLine 	:= .F.
	local lCtbCusto  	:= .F.
	local lReajuste  	:= .F.
	local nCalAcrs   	:= 0
	local nArrePrcLis	:= 0
	local lAtuSA7		:= .T.
	local cNota		:= ""
	local cSerie		:= getSerie(isExistRCO())
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "*********************INICIO execRET IN PrcNfRet.prw " + time() + " ********************" + CRLF, "01", "", 0, 0, {})
	
	aAreas	:= oIp040:oUtils:saveAreas({"SC5","SC6","SC9","SE4","SB1","SB2","SF4"})
	
	cModulo := 'FAT'
	nModulo := 5
	
	for nI := 1 to len(aItLibPV)
		
		// Gera nota
		SC5->(DbSelectArea("SC5"))
		SC5->(DbSetOrder(1))
		
		if SC5->(DbSeek(xFilial("SC5") + aItLibPV[nI,POS_NUMPV],.F.))
			
			SC6->(DbSelectArea("SC6"))
			SC6->(DbSetOrder(1))
			
			if SC6->(DbSeek(xFilial("SC6") + SC5->C5_NUM + aItLibPV[nI,POS_ITEMPV] + aItLibPV[nI,POS_PRODUTO],.F.))
				
				SC9->(DbSelectArea("SC9"))
				SC9->(DBSetOrder(2))
				
				if SC9->(MsSeek( xFilial("SC9") + SC5->C5_CLIENTE + SC5->C5_LOJACLI + SC6->C6_NUM + SC6->C6_ITEM,.F.))
					
					// Posiciona na condicao de pagamento
					SE4->(DbSelectArea("SE4"))
					SE4->(DbSetOrder(1))
					SE4->(DbSeek(xFilial("SE4") + SC5->C5_CONDPAG,.F.))
					
					// Posiciona no produto
					SB1->(DbSelectArea("SB1"))
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1") + SC6->C6_PRODUTO,.F.))
					
					// Posiciona no saldo em estoque
					SB2->(DbSelectArea("SB2"))
					SB2->(DbSetOrder(1))
					SB2->(DbSeek(xFilial('SB2') + SC6->C6_PRODUTO + SC6->C6_LOCAL,.F.))
					
					// Posiciona no TES
					SF4->(DbSelectArea("SF4"))
					SF4->(DbSetOrder(1))
					SF4->(DbSeek(xFilial('SF4') + SC6->C6_TES,.F.))
					
					// Monta array para gerar a nota fiscal
					aAdd(aPvlNfs,{SC9->C9_PEDIDO,;
						SC9->C9_ITEM,;
						SC9->C9_SEQUEN,;
						SC9->C9_QTDLIB,;
						SC9->C9_PRCVEN,;
						SC9->C9_PRODUTO,;
						.F.,;
						SC9->(RecNo()),;
						SC5->(RecNo()),;
						SC6->(RecNo()),;
						SE4->(RecNo()),;
						SB1->(RecNo()),;
						SB2->(RecNo()),;
						SF4->(RecNo()),;
						SC6->C6_LOCAL,;
						nRegDAK,;
						SC9->C9_QTDLIB2})
				else
					lContinua := .f.
					EXIT
				endif
			else
				lContinua := .f.
				EXIT
			endif
		else
			lContinua := .f.
			EXIT
		endif
		
	next nI
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "*********************INICIO execRET IN PrcNfRet.prw VALIDACAO CONTINUA L:328 " + time() + " ********************" + CRLF, "01", "", 0, 0, {})
	if lContinua
		aLockSX6 := SX6->(DBRLockList())
		
		For nX := 1 To Len(aLockSX6)
			
			SX6->(DBGoTo(aLockSX6[nX]))
			SX6->(MSUnLock())
			
		Next nX
		
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "*********************INICIO execRET IN PrcNfRet.prw MAPVLNFS L:339 " + time() + " ********************" + CRLF, "01", "", 0, 0, {})
		
		abreTabelas()
		
		cNota := MaPvlNFS(	aPvlNfs		, cSerie	, lMostraCtb , lAglutCtb ,;
			lCtbOnLine	, lCtbCusto	, lReajuste  , nCalAcrs  ,;
			nArrePrcLis, lAtuSA7)
		
		aLockSX6 := SX6->(DBRLockList())
		
		For nX := 1 To Len(aLockSX6)
			
			SX6->(DBGoTo(aLockSX6[nX]))
			SX6->(MSUnLock())
			
		Next nX
		
		if !Empty(cNota)
			aRet := { padr( cNota, TamSx3('D2_DOC')[1]), cSerie }
		endif
		
		SX6->(MsUnlock())
	endif
	
	cModulo	:= cModAtu
	nModulo	:= nModAtu
	
	oIp040:oUtils:restAreas(aAreas)
	RestArea(aArea)
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "*********************FIM execRET IN PrcNfRet.prw " + time() + " ********************" + CRLF, "01", "", 0, 0, {})
	
return ( aRet )


/*/{Protheus.doc} audRtcRet
Auditoria do IBS UF, IBS municipal, CBS e IS da NF de retorno simbolico.

O retorno simbolico e gerado pelo MaPvlNFS a partir do pedido (C6_TES) e o IBS/CBS/IS
vem do motor de tributos (F2D). O IP_040 (SZA/SZB) traz o IBS/CBS da venda do
depositante, por isso nao e comparado aqui. A funcao:
- registra no log (INFO) os totais de IBS UF, IBS Mun, CBS e IS da nota;
- avisa (WARN) quando nenhum item, ou parte dos itens, tem IBS/CBS na F2D: a nota pode
  sair sem o grupo IBSCBS (CST/cClassTrib). Conferir a TES e o cClassTrib do retorno.

[RTC-2026/2027] Somente leitura. Nao altera a nota nem interrompe o processo.
Executa somente com ZZ_RTCCONF = .T. (padrao), dDataBase >= MV_RTC55 e com a funcao
U_RtcF2DNf compilada (PrcGrvRco.prw).

@type function
@author Wellington Santana
@since 27/11/2026
@param cNota, character, Numero da NF de retorno simbolico
@param cSerie, character, Serie da NF de retorno simbolico
@return nil
/*/
Static Function audRtcRet(cNota, cSerie)

	Local aArea		:= GetArea()
	Local lConfere	:= SuperGetMv("ZZ_RTCCONF", .F., .T.)
	Local dDataRTC	:= SuperGetMv("MV_RTC55", .F., SToD("20260105"))
	Local aRetF2D	:= {}
	Local aItens	:= {}
	Local aTot		:= {0, 0, 0, 0}
	Local nSemF2D	:= 0
	Local nI		:= 0
	Local nJ		:= 0
	Local cNfLog	:= "[RTC-2026/2027] NF retorno simbolico " + AllTrim(cNota) + "/" + AllTrim(cSerie) + ": "

	If lConfere .and. dDataBase >= dDataRTC .and. FindFunction("U_RtcF2DNf")

		aRetF2D := U_RtcF2DNf(cNota, PadR(cSerie, TamSx3("D2_SERIE")[1]), "", "")

		If aRetF2D[1]
			aItens := aRetF2D[3]

			For nI := 1 To Len(aItens)
				If aItens[nI][5] == 0
					nSemF2D++
				EndIf
				For nJ := 1 To Len(aTot)
					aTot[nJ] += aItens[nI][2][nJ]
				Next nJ
			Next nI

			If Len(aItens) > 0 .and. nSemF2D == Len(aItens)
				FWLogMsg("WARN", , "BusinessObject", "PrcNfRet", "", "01", cNfLog + "nenhum item com IBS/CBS na F2D. " + ;
					"A nota pode sair sem o grupo IBSCBS. Conferir a TES do pedido (C6_TES) e o cClassTrib do retorno.", 0, 0, {})
			ElseIf nSemF2D > 0
				FWLogMsg("WARN", , "BusinessObject", "PrcNfRet", "", "01", cNfLog + cValToChar(nSemF2D) + " de " + ;
					cValToChar(Len(aItens)) + " item(ns) sem IBS/CBS na F2D. Conferir a TES do pedido (C6_TES).", 0, 0, {})
			EndIf

			FWLogMsg("INFO", , "BusinessObject", "PrcNfRet", "", "01", cNfLog + "IBS UF = " + AllTrim(Str(aTot[1], 16, 2)) + ;
				", IBS Mun = " + AllTrim(Str(aTot[2], 16, 2)) + ", CBS = " + AllTrim(Str(aTot[3], 16, 2)) + ;
				", IS = " + AllTrim(Str(aTot[4], 16, 2)) + " (motor de tributos; nao comparado com o IP_040, que traz a venda).", 0, 0, {})
		EndIf

	EndIf

	RestArea(aArea)

Return


/**
* Define os Logs
*/
static function setFileLog(cLogType,cLogText)
	
	local cInterface := "SAP IP_040"
	
	oLog:start(APP_SAP, DHL_IMPORTACAO)
	
	if (cLogType == "fail")
		oLog:fail(cInterface, cLogText)
	elseIf (cLogType == "warn")
		oLog:warn(cInterface, cLogText)
	endIf
	
return


/*
** Atualiza MVA do Produto para 0 para geração de NF de Retorno Simbolico sem imposto
*/
Static Function updMvaPrd(cItem)
	Local oSql	:= IpSqlObject():newIpSqlObject()
	Local cWhere	:= ""
	Local cUpd	:= ""
	Local lError	:= .f.
	
	cWhere += " %SB1.XFILIAL% AND "
	cWhere += " B1_COD 		= '" + cItem + "'"
	
	cUpd	 := "B1_PICMRET  = 0 "
	
	if !oSql:update("SB1", cUpd, cWhere)
		lError := .T.
		setFileLog("fail","Falha ao atualizar o campo B1_PICMRET." + CRLF + CRLF + oSql:getLastError())
	endif
	
	oSql:close()
Return (lError)

/*
** Apaga o arquivo temporario
*/
static function eraseFileTemp()
	
	TRB->(dbCloseArea())
	FErase(cArq + GetDbExtension())
	FErase( cArq + OrdBagExt())
	
return

/*
** Obtém a série específica
*/
static function getSerie(lExitRCO)
	
	local cSerie := ""
	
	if lExitRCO
		cSerie := AllTrim(GetNewPar("ZZ_SERRET", '1')) //AM - Manaus
	else
		cSerie := AllTrim(GetNewPar("ZZ_SERIRET", '1')) //SP - São Paulo
	endIf
	
return cSerie

/*
** Verifica se existe RCO
*/
static function isExistRCO()
	
	local lExist 		:= .F.
	local aArea	 		:= getArea()
	local aAreaSZA		:= SZA->(getArea())
	local nfRCO			:= SZA->ZA_NFRCO
	local cSerRCO		:= SZA->ZA_SERIRCO
	
	if !empty(SF2->F2_DOC) .and. !empty(SF2->F2_SERIE)
		if !empty(SZA->ZA_NFRCO) .and. !empty(SZA->ZA_SERIRCO)
			if allTrim(SF2->F2_DOC) == allTrim(SZA->ZA_NFRCO) .and. allTrim(SF2->F2_SERIE) == allTrim(SZA->ZA_SERIRCO)
				lExist := .T.
			endIf
		endIf
	endIf
	
	restArea(aAreaSZA)
	restArea(aArea)
	
return lExist

/*
** Valida amarração
*/
static function validCliProd(oSqlSZB,  cCliAux, cLojaAux)
	
	local lValid   := .T.
	
	cCliAux 	:= oSqlSZB:getValue("A7_CLIENTE")
	cLojaAux    := oSqlSZB:getValue("A7_LOJA")
	
	if empty(cCliAux) .or. empty(cLojaAux)
		lValid := .F.
	endIf
	
return lValid

User Function GravaFCP(_cSerie,_cNF,_cDOCSCJ,_cSERISCJ)
/*

=> SZA->ZA_FCPTOTA

=>  <SUB_TRIB_FCP_RATE>0</SUB_TRIB_FCP_RATE>   ---> SZB->ZB_FCPRATE
=>  <SUB_TRIB_FCP_AMOUNT>0</SUB_TRIB_FCP_AMOUNT> -> SZB->ZB_FCPAMOU
=>  <SUB_TRIB_FCP_BASE>0</SUB_TRIB_FCP_BASE ------> SZB->ZB_FCPBASE*/
  
  Local _lRet  := .T.
  Local _aArea := GetArea()
 
  dbSelectArea("SZA")
  dbSetOrder(2)
      
  If dbSeek(xFilial("SZA")+_cSERISCJ+_cDOCSCJ,.F.)
     _cKENFSCJ   := SZA->ZA_KENFSCJ
     _nFCPTOTA   := SZA->ZA_FCPTOTA
  
     GravaCab(_cSerie,_cNF,_nFCPTOTA)
  
  EndIf
     
  dbSelectArea("SZB")
  dbSetOrder(1)
  dbSeek(xFilial("SZB")+_cKENFSCJ,.T.)
  
  While !Eof() .And. SZB->ZB_FILIAL = xFilial("SZB") .And. _cKENFSCJ == SZB->ZB_KENFSCJ
  
      GravaItens(_cSerie,_cNF)       
   
      dbSelectArea("SZB")
      dbSkip()

  End

  RestArea(_aArea)

Return(_lRet)


/*
** Grava Informações SFT
*/
Static Function GravaCab(_cSerie,_cNF,_nFCPTOTA)
	Local lIcmSt	:= SZA->ZA_ICMSTVT > 0

	dbSelectArea("SF3")
	dbSetOrder(6)
	If dbSeek(xFilial("SF3")+_cNF+_cSerie,.F.)
		If RecLock("SF3",.F.)
			If lIcmSt
				SF3->F3_VFECPST := SZA->ZA_FCPTOTA
			Else
				SF3->F3_VALFECP := SZA->ZA_FCPTOTA
			EndIf
			SF3->F3_BSFCPST := _nFCPTOTA
			MsUnLock("SF3")
		EndIf
	EndIf

Return


Static Function GravaItens(_cSerie,_cNF)

	Local lIcmSt	:= .f.
	Local lGrava	:= .f.

	dbSelectArea("SF2")
	dbSetOrder(1)
	If dbSeek(xFilial("SF2")+_cNF+_cSerie,.F.)
		_cCliente := SF2->F2_CLIENTE
		_cLoja    := SF2->F2_LOJA
		_cLinha   := StrZero(Val(SZB->ZB_LINITEM),2,0)
		lIcmSt	  := SZB->ZB_ICMSTBS > 0
	EndIf
  
	dbSelectArea("SD2")
	dbSetOrder(3)
	If dbSeek(xFilial("SD2")+_cNF+_cSerie,.F.)
		While !Eof() .And. SD2->D2_ITEM <> _cLinha
			dbSelectArea("SD2")
			dbSkip()
		End
		If SD2->D2_ITEM==_cLinha .And. (_cNF+_cSerie)==(SD2->D2_DOC+SD2->D2_SERIE)
			If RecLock("SD2",.F.)
				SD2->D2_ALFCPST := SZB->ZB_FCPRATE
				SD2->D2_BSFCPST := SZB->ZB_FCPBASE
				MsUnlock("SD2")
			EndIf
		EndIF
	EndIf
  
	dbSelectArea("SFT")
	dbSetOrder(1)
	If dbSeek(xFilial("SFT")+"S"+_cSerie+_cNF,.F.)
		While !Eof() .And. SFT->FT_ITEM <> _cLinha .And. (_cNF+_cSerie)==(SFT->FT_NFISCAL+SFT->FT_SERIE)
			dbSelectArea("SFT")
			dbSkip()
		End
		If AllTrim(SFT->FT_ITEM)==AllTrim(_cLinha)
			If RecLock("SFT",.F.)
				SFT->FT_ALFCPST := SZB->ZB_FCPRATE
				SFT->FT_BSFCPST := SZB->ZB_FCPBASE
				// Wellington Santana 27/11/2026 - Iif substituido por If/Else (SonarQube CA4000)
				If lIcmSt
					SFT->FT_VALFECP	:= 0
					SFT->FT_VFECPST := SZB->ZB_FCPAMOU
				Else
					SFT->FT_VALFECP	:= SZB->ZB_FCPAMOU
					SFT->FT_VFECPST := 0
				EndIf
				MsUnlock("SFT")
			EndIf
		EndIf
	EndIf

	dbSelectArea("CD2")
	dbSetOrder(1)
	If dbSeek(xFilial("CD2")+"S"+_cSerie+_cNF,.F.)
		While !Eof() .And. AllTrim(CD2->CD2_ITEM) <> AllTrim(_cLinha)
			dbSelectArea("CD2")
			dbSkip()
		End
		while !Eof() .And. AllTrim(CD2->CD2_ITEM)==AllTrim(_cLinha) .And. (_cNF+_cSerie)==(CD2->CD2_DOC+CD2->CD2_SERIE)
			lGrava := .f.
			
			If (lIcmSt .and. AllTrim(CD2->CD2_IMP) == "SOL") .or. (!lIcmSt .and. AllTrim(CD2->CD2_IMP) == "ICM")
				lGrava := .t.
			EndIf
			
			If lGrava
				If RecLock("CD2",.F.)
					CD2->CD2_PFCP := SZB->ZB_FCPRATE
					CD2->CD2_BFCP := SZB->ZB_FCPBASE
					CD2->CD2_VFCP := SZB->ZB_FCPAMOU
					MsUnlock("CD2")
				EndIf
			EndIf
			dbSkip()
		End
	EndIf

//  dbSelectArea("CFC")
//  dbSetOrder(1)
//  If dbSeek(xFilial("CFC")+SM0->M0_ESTCOB+SF2->F2_EST+SD2->D2_COD,.F.)
//     If RecLock("CFC",.F.)
//        CFC->CFC_AFCPST := SZB->ZB_FCPRATE 
//        CFC->CFC_BFCPST := SZB->ZB_FCPBASE + CFC->CFC_BFCPST
//        MsUnlock("CFC")
//     EndIf
//  Else
//    If RecLock("CFC",.T.)
//        CFC->CFC_UFORIG := SM0->M0_ESTCOB
//        CFC->CFC_UFDEST := SF2->F2_EST
//        CFC->CFC_CODPRD := SD2->D2_COD
//        CFC->CFC_AFCPST := SZB->ZB_FCPRATE
//        CFC->CFC_BFCPST := SZB->ZB_FCPBASE
//        MsUnlock("CFC")
//     EndIf
//  EndIf

Return

/**
* Abre as tabelas. Necessário, pois na segunda iteração da nota estava dando ajustar DOC_SEQ.
* É necessário abrir as 3 tabelas
**/
static function abreTabelas()
	
	local lStatus := .F.
	
	If Select('SD1') <= 0
		dbSelectArea('SD1')
	EndIf
	If Select('SD2') <= 0
		dbSelectArea('SD2')
	EndIf
	If Select('SD3') <= 0
		dbSelectArea('SD3')
	EndIf
	
	lStatus := (Select('SD1')>0) .And. (Select('SD2')>0) .And. (Select('SD3')>0)
	
return

