#include "protheus.ch"
#include "dhl.ch"

// Wellington Santana 23/11/2026 - [RTC-2026/2027] tolerancia de arredondamento por item na conferencia de IBS/CBS
#define RTC_TOLERANCIA	0.01


/*/{Protheus.doc} PrcGrvRco
Realiza processamento final da NF RCO - Referência do Fonte M460FIM
@author Thiago Meschiatti
@since 21/05/2017
@version undefined
@history 23/11/2026, Wellington Santana, [RTC-2026/2027] Conferência do IBS/CBS calculado pelo Protheus (F2D)
         com o enviado pelo SAP no IP_040 (confIbsCbs). Somente aviso no log, sem alterar a nota.

@type function
/*/
User Function PrcGrvRco()
	
	Local oUtils      	:= IpUtilsObject():newIpUtilsObject()
	Local aAreas		:= {}
	Local oTMsg  	 	:= FswTemplMsg():newTemplMsg("S",SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,"SZZ")
	Local oDHLProcValid	:= nil
	Local oSqlSZB		:= nil
	Local oSqlGroup		:= nil
	Local cTipoNf		:= SF2->F2_TIPO
	Local cNota			:= SF2->F2_DOC
	Local cSerie		:= SF2->F2_SERIE
	Local cClieFor		:= SF2->F2_CLIENTE
	Local cLoja			:= SF2->F2_LOJA
	Local cNotaOri		:= SF2->F2_NFORI
	Local cSerieOri		:= SF2->F2_SERIORI
	Local cTipo			:= DHL_NFE_INVOICE_OUTFLOW
	Local cKeyScj		:= SZA->ZA_KENFSCJ
	Local nPLiqui	 	:= 0
	Local aUpdSZA		:= {}
	Local aUpdSF2		:= {}
	Local aIdItens		:= {}
	Local lSerCont		:= aScan(separa(GetNewPar("ZZ_SERCONT", ""), ";"), {|x| x == upper(alltrim(cSerie))}) > 0
	Local lRet			:= .t.

	// Inicio TOTVS IP Campinas iVan Oliveira - 15/06/2021 - SCJ - ICMS desonerado
	Local _lIcmDeso	    := SZA->ZA_ICMSDES == 'S'
	Local _nTamDoc		:= TamSx3("ZA_DOCSCJ")[1]
	Local _nTamSer		:= TamSx3("ZA_SERISCJ")[1]
	Local _nIt			:= 0
	Local _lCont        := .T.
	Local nI			:= 0
	Local cCfop			:= ""
	Local cAliq			:= ""
	Local lOk			:= .t.
	Local lOkPos		:= .t.
	Local nTotDesZfr	:= 0
	
	oSqlSZB   := oIp040:getItensSZB(cKeyScj)
	oSqlGroup := oIp040:getGroupSZB(cKeyScj)

	if .T. //!_lIcmDeso
		_lCont    := oIp040:validValues(oSqlSZB, oSqlGroup)
	Endif

	if _lCont

		// Inicio TOTVS IP Campinas iVan Oliveira Final(07/07/2021) de/para especifico para Desoneração ICMS-SuFrama - 
		if _lIcmDeso

			aAreas := oUtils:saveAreas({"SF2", "SD2", "SF3", "SFT", "CD2"})
			openTables()

			oSqlSZB:goTop()
			While oSqlSZB:notIsEof()
				
				If !lOkPos
					exit
				EndIf
				
				lOk := .f.
				If SD2->(DbSeek(SF2->(F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) + oSqlSZB:getValue("ZB_ITEM") + padl(alltrim(oSqlSZB:getValue("ZB_LINITEM")),2, '0')))
					If SFT->(DbSeek(SD2->(D2_FILIAL + "S" + D2_SERIE + D2_DOC + D2_CLIENTE + D2_LOJA + PadR(D2_ITEM, TamSx3("FT_ITEM")[1]) + D2_COD)))
						
						// Atualiza campos da SD2
						RecLock("SD2",.F.)
						SD2->D2_TOTAL	:= oSqlSZB:getValue("ZB_TOTVLIT") - oSqlSZB:getValue("ZB_VLDIICM")
						SD2->D2_PRCVEN 	:= (oSqlSZB:getValue("ZB_TOTVLIT") - oSqlSZB:getValue("ZB_VLDIICM")) / SD2->D2_QUANT
						SD2->D2_DESCZFR := oSqlSZB:getValue("ZB_VLDIICM")
						SD2->D2_VALBRUT	:= (oSqlSZB:getValue("ZB_TOTVLIT") + oSqlSZB:getValue("ZB_ICMSTVL")) - oSqlSZB:getValue("ZB_VLDIICM")
						SD2->(MsUnlock())

						// Atualiza campos da SFT
						RecLock("SFT",.F.)
						SFT->FT_TOTAL	:= oSqlSZB:getValue("ZB_TOTVLIT") - oSqlSZB:getValue("ZB_VLDIICM")
						SFT->FT_DESCZFR	:= oSqlSZB:getValue("ZB_VLDIICM")
						SFT->FT_VALCONT := (oSqlSZB:getValue("ZB_TOTVLIT") + oSqlSZB:getValue("ZB_ICMSTVL")) - oSqlSZB:getValue("ZB_VLDIICM")
						SFT->FT_ISENICM := (oSqlSZB:getValue("ZB_TOTVLIT") - oSqlSZB:getValue("ZB_DISCICM"))
						SFT->FT_PRCUNIT := (oSqlSZB:getValue("ZB_TOTVLIT") - oSqlSZB:getValue("ZB_VLDIICM")) / SD2->D2_QUANT
						SFT->FT_BSICMOR := oSqlSZB:getValue("ZB_TOTVLIT")
						SFT->(MsUnlock())

						// Atualiza campos da CD2	
						If CD2->(dbSeek(SD2->(D2_FILIAL + "S" + D2_SERIE + D2_DOC + D2_CLIENTE + D2_LOJA + PadR(D2_ITEM, TamSx3("FT_ITEM")[1]) + D2_COD) + "SOL"))
							RecLock("CD2",.F.)
							CD2->CD2_DESONE := oSqlSZB:getValue("ZB_VLDIICM")
							CD2->(MsUnlock())
						EndIf
						
					Else
						lOkPos := .f.
					EndIf
				Else
					lOkPos := .f.
				EndIf
				
				nTotDesZfr += oSqlSZB:getValue("ZB_VLDIICM")

				oSqlSZB:skip()
			EndDo

			If lOkPos
				oSqlGroup:goTop()
				While oSqlGroup:notIsEof()
					cCfop	:= ""
					
					If (SF2->F2_EST == GetNewPar("MV_ESTADO", ""))
						cCfop := oSqlGroup:getValue("CFOP")
					Else
						cCfop := "6" + Subs( oSqlGroup:getValue("CFOP"),2,Len( oSqlGroup:getValue("CFOP") ) - 1 ) 
					Endif
					
					If oSqlGroup:getValue("ZB_PREDBAS") > 0
						cAliq := "0.00"
					Else
						cAliq := str(oSqlGroup:getValue("ALIQICM"), 5, 2)
					EndIf
					
					If SF3->(DbSeek(SF2->(F2_FILIAL + Dtos(F2_EMISSAO) + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) + cCfop + cAliq))
						
						// Atualiza campos da SF3
						RecLock("SF3",.F.)
						SF3->F3_VALOBSE	:= nTotDesZfr
						SF3->F3_DESCZFR	:= nTotDesZfr
						SF3->F3_VALICM  := 0
						SF3->F3_BASEICM	:= 0
						SF3->F3_VALCONT := SZA->ZA_TOTVALU
						SF3->F3_ISENICM := 0
						SF3->F3_BSICMOR := SZA->ZA_ICMTBAS
						SF3->(MsUnlock())	
						
					Else
						lOkPos := .f.
						exit
					EndIf
				
					oSqlGroup:skip()
				EndDo
			EndIf

			// Atualiza campos da SF2
			RecLock("SF2",.F.)
			SF2->F2_DESCZFR	:= nTotDesZfr
			SF2->F2_VALICM 	:= 0
			SF2->F2_BASEICM := 0
			SF2->F2_VALMERC := SZA->ZA_TOTVALU - SZA->ZA_ICMSTVT
			SF2->(MsUnlock())

			oUtils:restAreas(aAreas)

			/* INICIO - LOGICA DO IVAN
			_nVlrZero := _nVlrBrut := _nVlrDIICM := _nVlrICM := _nVlrPrVen := _nVlrTot :=  _nVlrTotAlu:= 0

			//Campos a alterar do De/Para
			_aCpos := { {"F2_DESCZFR" , "_nVlrDIICM" },;
						{"F2_BASEICM" , "_nVlrZero"  },;
						{"F2_VALICM"  , "_nVlrZero"  },;  
						{"F3_VALOBSE" , "_nVlrDIICM" },;
						{"F3_DESCZFR" , "_nVlrDIICM" },; 
						{"F3_VALCONT" , "_nVlrTotAlu"},;
						{"F3_ISENICM" , "_nVlrZero"  },; 
						{"F3_VALICM"  , "_nVlrZero"  },; 
						{"F3_BASEICM" , "_nVlrZero"  },; //
						{"D2_PRCVEN"  , "_nVlrPrVen" },; 
						{"D2_VALBRUT" , "_nVlrBrut " },; 
						{"D2_TOTAL"   , "_nVlrTot"   },; 
						{"D2_DESCZFR" , "_nVlrICM"   },;   
						{"FT_DESCZFR" , "_nVlrICM"   },; 
						{"FT_VALCONT" , "_nVlrCont"  },; 
						{"FT_ISENICM" , "_nVlrZero"  },;  
						{"FT_PRCUNIT" , "_nVlrPrVen" },; 
						{"FT_TOTAL"   , "_nVlrTot"   }}
 
			// Posicionando ip040
			_nVlrTotAlu += SZA->ZA_TOTVALU

			// Altera campo valores específicos dos itens(sd2/sft)
			dbSelectArea("SZB")
			SZB->( dbSetOrder(1) )
			If SZB->( dbSeek(xFilial("SZB")+SZA->ZA_KENFSCJ) )
				While !SZB->( EOF() ) .And. SZB->ZB_KENFSCJ == SZA->ZA_KENFSCJ

					_cProdIt    := PadR(Alltrim(SZB->ZB_ITEM), TamSx3("D2_COD")[1]) +  StrZero(Val(SZB->ZB_LINITEM), TamSx3("D2_ITEM")[1])
					_nVlrDIICM	+= SZB->ZB_VLDIICM
					
					// Itens da NF Saída
					dbSelectArea("SD2")
					SD2->( dbSetOrder(3) )
					if SD2->(DbSeek(SF2->(F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) + _cProdIt ) )

						_nVlrPrVen := (SZB->ZB_TOTVLIT - SZB->ZB_VLDIICM) / SD2->D2_QUANT
						_nVlrTot   := SZB->(ZB_TOTVLIT - ZB_VLDIICM)
						_nVlrICM   := SZB->ZB_VLDIICM
						_nVlrCont  := SZB->(ZB_TOTVLIT + ZB_ICMSTVL - ZB_VLDIICM)
						_nVlrBrut  := SZB->(ZB_TOTVLST - ZB_VLDIICM )

						_nPos := Ascan(_aCpos,{|x| Left(x[1],2) =='D2'}) 
						for _nIt := _nPos to len(_aCpos)

							oIp040:updateFields( 'SD2', _aCpos[_nIt][01] , &(_aCpos[_nIt][02] ))
							if left(_aCpos[_nIt][01],2) # 'D2'

								exit

							Endif	
						Next

					endIf

					// Itens da NF Saída(Fiscal)
					_cProdIt := PadR(Alltrim(SD2->D2_ITEM), TamSx3("FT_ITEM")[1]) + PadR(Alltrim(SD2->D2_COD), TamSx3("FT_PRODUTO")[1])   
					dbSelectArea("SFT")
					SFT->( dbSetOrder(1) )
					If SFT->(DbSeek(SF2->(F2_FILIAL + "S" + F2_SERIE + F2_DOC +  F2_CLIENTE + F2_LOJA + _cProdIt)))
					
						_nPos := Ascan(_aCpos,{|x| Left(x[1],2) =='FT'}) 
						for _nIt := _nPos to len(_aCpos)

							oIp040:updateFields( 'SFT', _aCpos[_nIt][01] , &(_aCpos[_nIt][02] ))

							if left(_aCpos[_nIt][01],2) # 'FT'

								exit

							Endif	
						Next

					endIf

					SZB->( dbSkip() )

				Enddo

				// Altera campo valores específicos do cabeçalho(sf2/sf3) 
				_nPos := Ascan(_aCpos,{|x| Left(x[1],2) =='F2'}) 
				for _nIt := _nPos to len(_aCpos)

					oIp040:updateFields( 'SF2', _aCpos[_nIt][01] , &(_aCpos[_nIt][02] ))

					if left(_aCpos[_nIt][01],2) # 'F2'

						exit

					Endif	
				Next
				
				DbSelectArea("SF3")
				SF3->(DbSetOrder(1))
				
				If SF3->(DbSeek(SF2->(F2_FILIAL + Dtos(F2_EMISSAO) + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) ))
				
					_nPos := Ascan(_aCpos,{|x| Left(x[1],2) =='F3'}) 
					for _nIt := _nPos to len(_aCpos)

						oIp040:updateFields( 'SF3', _aCpos[_nIt][01] , &(_aCpos[_nIt][02] ))

						if left(_aCpos[_nIt][01],2) # 'F3'

							exit

						Endif	
					Next

				endIf
				
			Endif
			FIM - LOGICA DO IVAN */

		Endif
		// FInal TOTVS IP Campinas iVan Oliveira Final(07/07/2021) de/para especifico para Desoneração ICMS-SuFrama - 

		// Final TOTVS IP Campinas iVan Oliveira - 15/06/2021 - SCJ - ICMS desonerado
		
		oIp040:updateFields("SZA", "ZA_NFRCO"  , cNota)
		oIp040:updateFields("SZA", "ZA_SERIRCO", cSerie)
		oIp040:updateFields("SF2", "F2_ZZPLACA", "DHL1234"            )
		oIp040:updateFields("SF2", "F2_ZZUFPLA", "SP"                 )
		oIp040:updateFields("SF2", "F2_ZZDTSAI", dDatabase            )
		oIp040:updateFields("SF2", "F2_ZZHRSAI", Time()               )
		oIp040:updateFields("SF2", "F2_ZZMARCA", CriaVar("F2_ZZMARCA"))
		oIp040:updateFields("SF2", "F2_ZZNUMER", CriaVar("F2_ZZNUMER"))
		oIp040:updateFields("SF2", "F2_ZZTPNF" , REMESSA_CONTA_ORDEM  )
		oIp040:updateFields("SF2", "F2_TPFRETE", "T")
		oIp040:updateFields("SF2", "F2_TRANSP" , oIp040:getCarrier(SZA->ZA_CNPJCAR)  )
		oIp040:updateFields("SF2", "F2_VOLUME1", SZA->ZA_NUMPACK  )
		oIp040:updateFields("SF2", "F2_ESPECI1", "VOL"  )
		oIp040:updateFields("SF2", "F2_HORA", SUBSTR(TIME(), 1, 5)  )
		
		fGravaMsg(oTMsg, oSqlSZB)
		
		fAtuSf3(cNota, cSerie, cClieFor, cLoja)

		// INICIO Wellington Santana 23/11/2026 - [RTC-2026/2027] Confere o IBS/CBS calculado pelo Protheus
		// (motor de tributos - F2D) com o enviado pelo SAP no IP_040 (SZB). Somente leitura: avisa no log.
		confIbsCbs(oSqlSZB)
		// FIM Wellington Santana 23/11/2026

		// ATENÇÃO: Esse bloco de código refere-se a Geração do Arquivo de NFe para o Mastersaf e deve
		// 			SEMPRE SER O ÚLTIMO PROCESSAMENTO do PE.
		if !IsInCallStack("u_ImpMsaNfe")
			if ExistBlock("PrcXmlNfe")
				oDHLProcValid	:= DHLProcessValidator():newDHLProcessValidator()
				if oDHLProcValid:validDocumentType(cTipo, nil, cSerie)
					lReturn := U_PrcXmlNfe(cTipo, cSerie, cNota, cClieFor, cLoja, cNotaOri, cSerieOri)
					if lSerCont
						u_PrcConti(DHL_NF_SAIDA, DHL_OPC_INCLUSAO,  SF2->(Recno()))
					endif
				endIf
			endif
		endIf
	Else
		oIp040:updateFields("SZA", "ZA_NFRCO"  , cNota)
		oIp040:updateFields("SZA", "ZA_SERIRCO", cSerie)
		oIp040:updateFields("SF2", "F2_ZZTPNF" , REMESSA_CONTA_ORDEM  )
		lRet := .f.
	EndIf
	
Return (lRet)


/*/{Protheus.doc} confIbsCbs
Confere, item a item, o IBS UF, o IBS municipal e a CBS da NF RCO calculados pelo
Protheus (motor de tributos, tabela F2D) com os valores enviados pelo SAP no IP_040
(ZB_IBSUFVL, ZB_IBSMUVL e ZB_CBSTXVL).

[RTC-2026/2027] Somente leitura. Nao altera a nota nem interrompe o processo: cada
divergencia acima de RTC_TOLERANCIA gera um aviso no log (FWLogMsg WARN). Os valores
do SAP nao sobrescrevem a F2D porque a nota transmitida (nfesefaz/TSSTCIntegration)
usa base, aliquota e totais do motor de tributos; trocar so o valor geraria XML
inconsistente.

Executa somente quando:
- ZZ_RTCCONF = .T. (padrao);
- dDataBase >= MV_RTC55 (inicio da reforma, mesmo parametro do ProcRCOMsa);
- a tabela F2D e o campo D2_IDTRIB existem no dicionario.

Codigos dos tributos na F2D: ZZ_TRIBSUF, ZZ_TRIBSMU e ZZ_TRIBCBS (mesmos parametros
e padroes do DHLIdManager).

@type function
@author Wellington Santana
@since 23/11/2026
@param oSqlSZB, object, Itens do IP_040 (DHLIp040Sap:getItensSZB)
@return nil
/*/
Static Function confIbsCbs(oSqlSZB)

	Local aArea		:= GetArea()
	Local lConfere	:= SuperGetMv("ZZ_RTCCONF", .F., .T.)
	Local dDataRTC	:= SuperGetMv("MV_RTC55", .F., SToD("20260105"))
	Local cTribUF	:= ""
	Local cTribMun	:= ""
	Local cTribCBS	:= ""
	Local cQuery	:= ""
	Local cAliasQry	:= ""
	Local cChave	:= ""
	Local nTamItem	:= TamSx3("D2_ITEM")[1]
	Local aProth	:= {}
	Local aSap		:= {}
	Local aNomes	:= {"IBS UF", "IBS Mun", "CBS"}
	Local nPos		:= 0
	Local nI		:= 0
	Local nDiverg	:= 0
	Local cNfLog	:= AllTrim(SF2->F2_DOC) + "/" + AllTrim(SF2->F2_SERIE)

	If !lConfere .or. dDataBase < dDataRTC .or. !AliasInDic("F2D") .or. SD2->(FieldPos("D2_IDTRIB")) == 0
		RestArea(aArea)
		Return
	EndIf

	cTribUF		:= SuperGetMv("ZZ_TRIBSUF", .F., "TR0002")
	cTribMun	:= SuperGetMv("ZZ_TRIBSMU", .F., "TR0003")
	cTribCBS	:= SuperGetMv("ZZ_TRIBCBS", .F., "TR0001")

	// Valores do Protheus por item da nota (uma unica query, fora do laco)
	cQuery := " SELECT SD2.D2_COD, SD2.D2_ITEM, "
	cQuery += " SUM(CASE WHEN F2D.F2D_TRIB = '" + cTribUF  + "' THEN F2D.F2D_VALOR ELSE 0 END) VLIBSUF, "
	cQuery += " SUM(CASE WHEN F2D.F2D_TRIB = '" + cTribMun + "' THEN F2D.F2D_VALOR ELSE 0 END) VLIBSMU, "
	cQuery += " SUM(CASE WHEN F2D.F2D_TRIB = '" + cTribCBS + "' THEN F2D.F2D_VALOR ELSE 0 END) VLCBS "
	cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " LEFT JOIN " + RetSqlName("F2D") + " F2D ON F2D.F2D_FILIAL = '" + xFilial("F2D") + "' "
	cQuery += " 	AND F2D.F2D_IDREL = SD2.D2_IDTRIB "
	cQuery += " 	AND F2D.F2D_TABELA = 'SD2' "
	cQuery += " 	AND F2D.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " 	AND SD2.D2_DOC = '" + SF2->F2_DOC + "' "
	cQuery += " 	AND SD2.D2_SERIE = '" + SF2->F2_SERIE + "' "
	cQuery += " 	AND SD2.D2_CLIENTE = '" + SF2->F2_CLIENTE + "' "
	cQuery += " 	AND SD2.D2_LOJA = '" + SF2->F2_LOJA + "' "
	cQuery += " 	AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY SD2.D2_COD, SD2.D2_ITEM "
	cQuery := ChangeQuery(cQuery)

	cAliasQry := GetNextAlias()
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	While (cAliasQry)->(!Eof())
		aAdd(aProth, {AllTrim((cAliasQry)->D2_COD) + "|" + AllTrim((cAliasQry)->D2_ITEM), ;
			{(cAliasQry)->VLIBSUF, (cAliasQry)->VLIBSMU, (cAliasQry)->VLCBS}})
		(cAliasQry)->(dbSkip())
	EndDo
	(cAliasQry)->(dbCloseArea())

	// Compara com o SAP (mesma chave produto + item usada no posicionamento da SD2 deste fonte)
	oSqlSZB:goTop()
	While oSqlSZB:notIsEof()

		cChave	:= AllTrim(oSqlSZB:getValue("ZB_ITEM")) + "|" + PadL(AllTrim(oSqlSZB:getValue("ZB_LINITEM")), nTamItem, "0")
		aSap	:= {oSqlSZB:getValue("ZB_IBSUFVL"), oSqlSZB:getValue("ZB_IBSMUVL"), oSqlSZB:getValue("ZB_CBSTXVL")}
		nPos	:= aScan(aProth, {|x| x[1] == cChave})

		If nPos == 0
			nDiverg++
			FWLogMsg("WARN", , "BusinessObject", "PrcGrvRco", "", "01", ;
				"[RTC-2026/2027] NF RCO " + cNfLog + ": item " + cChave + " do IP_040 nao encontrado na SD2 para conferir IBS/CBS.", 0, 0, {})
		Else
			For nI := 1 To Len(aSap)
				If Abs(aSap[nI] - aProth[nPos][2][nI]) > RTC_TOLERANCIA
					nDiverg++
					FWLogMsg("WARN", , "BusinessObject", "PrcGrvRco", "", "01", ;
						"[RTC-2026/2027] NF RCO " + cNfLog + ", item " + cChave + ": " + aNomes[nI] + ;
						" SAP = " + AllTrim(Str(aSap[nI], 14, 2)) + " / Protheus = " + AllTrim(Str(aProth[nPos][2][nI], 14, 2)), 0, 0, {})
				EndIf
			Next nI
		EndIf

		oSqlSZB:skip()
	EndDo

	If nDiverg > 0
		FWLogMsg("WARN", , "BusinessObject", "PrcGrvRco", "", "01", ;
			"[RTC-2026/2027] NF RCO " + cNfLog + ": " + cValToChar(nDiverg) + " divergencia(s) de IBS/CBS entre SAP e Protheus. Chave NF SCJ: " + ;
			AllTrim(SZA->ZA_KENFSCJ), 0, 0, {})
	EndIf

	RestArea(aArea)

Return


/*
** Grava informação na tabela de template Mensagens NF (SZZ)
*/
static function fGravaMsg(oTMsg, oSqlSZB)
	Local cMsg 		:= ""
	Local cNfScj		:= SZA->ZA_DOCSCJ
	Local cSerNfScj	:= SZA->ZA_SERISCJ
	Local cDate		:= dToc(SZA->ZA_DUEDATE)
	Local cMsgAdic	:= AllTrim(SZA->ZA_MSGADIC)
	Local oSql		:= IpSqlObject():newIpSqlObject()
	
	oTMsg:carMsg(.F.)
	
	If !Empty(cMsgAdic)
		aAdd(oTMsg:aMsg, {"901", cMsgAdic})
	EndIf
	
	oSql:newTable("SA1", "*", "%SA1.XFILIAL% AND A1_CGC = '" + SZA->ZA_CNPJSCJ + " '")
	
	If oSql:hasRecords()
		cMsg += "RCO conforme NF de venda do depositante n. " + AllTrim(cNfScj) + ", série " + alltrim(cSerNfScj) + ", de " + cDate + ","
		 			
		cMsg += " emitida por " + AllTrim(oSql:getValue("A1_NOME")) + " " + AllTrim(oSql:getValue("A1_END")) + " - " + AllTrim(oSql:getValue("A1_BAIRRO"))
		cMsg += " Cep:" +AllTrim(Transform(oSql:getValue("A1_CEP"), "@R 99999-999")) + " "+  AllTrim(oSql:getValue("A1_MUN")) + "/" + AllTrim(oSql:getValue("A1_EST"))							
		cMsg += " CNPJ " + AllTrim(Transform(oSql:getValue("A1_CGC"), "@R 99.999.999/9999-99")) + " "
		cMsg += " I.E. " + AllTrim(oSql:getValue("A1_INSCR")) + "."
		
		aAdd(oTMsg:aMsg, {"902",cMsg})
	EndIf
	
	oSql:close()
	
	cMsg := ""
	oSqlSZB:goTop()
	While oSqlSZB:notIsEof()
		If !Empty(oSqlSZB:getValue("ZB_POCUSTO"))
			If !(AllTrim(oSqlSZB:getValue("ZB_POCUSTO")) $ cMsg)
				cMsg += AllTrim(oSqlSZB:getValue("ZB_POCUSTO")) + " / "		
			EndIf	
		EndIf
		oSqlSZB:skip()
	EndDo
	
	If !Empty(cMsg)
		cMsg := "Pedido(s) do cliente: " + SubStr(cMsg,1,Len(cMsg)-3) + "."
		aadd(oTMsg:aMsg, {"903",cMsg})
	EndIf
	
	If Len(oTMsg:aMsg) > 0 
		oTMsg:grvMsg()
	EndIf
		
return()


/*
** Atualiza campo de reprocessamento da NF no fiscal
*/
Static Function fAtuSf3(cNota, cSerie, cClieFor, cLoja)
	
	Local oSql		:= IpSqlObject():newIpSqlObject()
	Local cWhere	:= ""
	Local cUpd 		:= "F3_REPROC = 'N'"
	
	cWhere += " 1=1                                    "+CRLF
	cWhere += " AND %SF3.XFILIAL%                      "+CRLF
	cWhere += " AND F3_NFISCAL	= '" + cNota + "'      "+CRLF
	cWhere += " AND F3_SERIE	= '" + cSerie + "'     "+CRLF
	cWhere += " AND F3_CLIEFOR	= '" + cClieFor + "'   "+CRLF
	cWhere += " AND F3_LOJA		= '" + cLoja + "'      "+CRLF
	
	oSql:update("SF3", cUpd, cWhere)

	oSql:close()
Return

/*
** Abrir tabelas
*/
Static Function openTables()
	
	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	
	DbSelectArea("SF3")
	SF3->(DbSetOrder(1))
	
	DbSelectArea("SFT")
	SFT->(DbSetOrder(1))
	
	DbSelectArea("CD2")
	CD2->(DbSetOrder(1))
	
return
