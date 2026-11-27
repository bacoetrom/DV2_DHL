#include "totvs.ch"	// Wellington Santana 27/11/2026 - antes protheus.ch (include obsoleto)
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
@history 27/11/2026, Wellington Santana, [RTC-2026/2027] confIbsCbs passa a conferir tambem a base
         (ZB_IBSUFBS/ZB_IBSMUBS/ZB_CBSTXBS), a aliquota (ZB_IBSUFTX/ZB_IBSMUTX/ZB_CBSTXRT), os totais
         da SZA (ZA_IBSUFTO/ZA_IBSMUTO/ZA_IBSTOTA/ZA_CBSTOTA) e o IS. Leitura da F2D isolada em
         U_RtcF2DNf (FWExecStatement), reutilizada pelo PrcNfRet.

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
	Local lReturn		:= .t.	// Wellington Santana 27/11/2026 - retorno do U_PrcXmlNfe (antes sem declaracao)

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
		// Wellington Santana 27/11/2026 - inclui base, aliquota, totais da SZA e IS
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
Confere a NF RCO: IBS UF, IBS municipal, CBS e IS calculados pelo Protheus (motor de
tributos, tabela F2D) contra os valores enviados pelo SAP no IP_040 (SZA/SZB).

Por item (SZB x F2D), para IBS UF, IBS municipal e CBS:
- valor (ZB_IBSUFVL, ZB_IBSMUVL, ZB_CBSTXVL). Na divergencia, o log traz tambem a base
  e a aliquota dos dois lados para facilitar a analise;
- base (ZB_IBSUFBS, ZB_IBSMUBS, ZB_CBSTXBS), quando o valor confere mas a base nao. Aponta,
  por exemplo, a base calculada antes da regravacao do item no bloco de ICMS desonerado;
- item com IBS/CBS no SAP e sem nenhum registro de IBS/CBS na F2D (motor nao calculou).
A aliquota (ZB_IBSUFTX, ZB_IBSMUTX, ZB_CBSTXRT) so entra no log da divergencia de valor:
o SAP envia aliquota efetiva (SAPIP040:getItRate) e a F2D pode ter a aliquota cheia.

IS (Imposto Seletivo): o IP_040 nao tem campo de IS na SZA/SZB. Se o Protheus calcular IS
na nota (codigo do tributo em ZZ_TRIBSIS), gera aviso.

Por nota (SZA x soma da F2D): ZA_IBSUFTO, ZA_IBSMUTO, ZA_CBSTOTA e ZA_IBSTOTA (UF + Mun).

[RTC-2026/2027] Somente leitura. Nao altera a nota nem interrompe o processo: cada
divergencia acima de RTC_TOLERANCIA gera um aviso no log (FWLogMsg WARN). Os valores
do SAP nao sobrescrevem a F2D porque a nota transmitida (nfesefaz/TSSTCIntegration)
usa base, aliquota e totais do motor de tributos; trocar so o valor geraria XML
inconsistente.

Executa somente quando:
- ZZ_RTCCONF = .T. (padrao);
- dDataBase >= MV_RTC55 (inicio da reforma, mesmo parametro do ProcRCOMsa);
- a tabela F2D e o campo D2_IDTRIB existem no dicionario (verificado em U_RtcF2DNf).

@type function
@author Wellington Santana
@since 23/11/2026
@history 27/11/2026, Wellington Santana, [RTC-2026/2027] Base, aliquota, totais da SZA e IS.
@param oSqlSZB, object, Itens do IP_040 (DHLIp040Sap:getItensSZB)
@return nil
/*/
Static Function confIbsCbs(oSqlSZB)

	Local aArea		:= GetArea()
	Local lConfere	:= SuperGetMv("ZZ_RTCCONF", .F., .T.)
	Local dDataRTC	:= SuperGetMv("MV_RTC55", .F., SToD("20260105"))
	Local cChave	:= ""
	Local nTamItem	:= TamSx3("D2_ITEM")[1]
	Local aRetF2D	:= {}
	Local aProth	:= {}
	Local aSapVal	:= {}
	Local aSapBas	:= {}
	Local aSapAli	:= {}
	Local aNomes	:= {"IBS UF", "IBS Mun", "CBS"}
	Local aTotPro	:= {0, 0, 0, 0}
	Local aTotSza	:= {}
	Local aNomTot	:= {"IBS UF (ZA_IBSUFTO)", "IBS Mun (ZA_IBSMUTO)", "CBS (ZA_CBSTOTA)", "IBS total (ZA_IBSTOTA)"}
	Local lBaseAli	:= .F.
	Local lF2D		:= .F.
	Local nPos		:= 0
	Local nI		:= 0
	Local nItens	:= 0
	Local nDiverg	:= 0
	Local nTolTot	:= 0
	Local cNfLog	:= AllTrim(SF2->F2_DOC) + "/" + AllTrim(SF2->F2_SERIE)

	If lConfere .and. dDataBase >= dDataRTC

		// Valores do Protheus por item da nota (uma unica query, fora do laco)
		aRetF2D		:= U_RtcF2DNf(SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA)
		lF2D		:= aRetF2D[1]
		lBaseAli	:= aRetF2D[2]
		aProth		:= aRetF2D[3]

	EndIf

	If lF2D

		// Totais do Protheus: IBS UF, IBS Mun, CBS e IS
		For nPos := 1 To Len(aProth)
			For nI := 1 To Len(aTotPro)
				aTotPro[nI] += aProth[nPos][2][nI]
			Next nI
		Next nPos

		// Compara com o SAP (mesma chave produto + item usada no posicionamento da SD2 deste fonte)
		oSqlSZB:goTop()
		While oSqlSZB:notIsEof()

			nItens++
			cChave	:= AllTrim(oSqlSZB:getValue("ZB_ITEM")) + "|" + PadL(AllTrim(oSqlSZB:getValue("ZB_LINITEM")), nTamItem, "0")
			aSapVal	:= {oSqlSZB:getValue("ZB_IBSUFVL"), oSqlSZB:getValue("ZB_IBSMUVL"), oSqlSZB:getValue("ZB_CBSTXVL")}
			aSapBas	:= {oSqlSZB:getValue("ZB_IBSUFBS"), oSqlSZB:getValue("ZB_IBSMUBS"), oSqlSZB:getValue("ZB_CBSTXBS")}
			aSapAli	:= {oSqlSZB:getValue("ZB_IBSUFTX"), oSqlSZB:getValue("ZB_IBSMUTX"), oSqlSZB:getValue("ZB_CBSTXRT")}
			nPos	:= aScan(aProth, {|x| x[1] == cChave})

			If nPos == 0
				nDiverg++
				logRtc(cNfLog, "item " + cChave + " do IP_040 nao encontrado na SD2 para conferir IBS/CBS.")
			ElseIf aProth[nPos][5] == 0 .and. (aSapVal[1] + aSapVal[2] + aSapVal[3]) > RTC_TOLERANCIA
				nDiverg++
				logRtc(cNfLog, "item " + cChave + " com IBS/CBS no SAP e sem registro de IBS/CBS na F2D " + ;
					"(motor de tributos nao calculou). Revisar a TES e o cadastro de tributos.")
			Else
				nDiverg += confItem(cNfLog, cChave, aNomes, aSapVal, aSapBas, aSapAli, aProth[nPos], lBaseAli)
			EndIf

			oSqlSZB:skip()
		EndDo
		oSqlSZB:goTop()

		// IS: o IP_040 nao traz Imposto Seletivo (SAP equivale a zero)
		If aTotPro[4] > RTC_TOLERANCIA
			nDiverg++
			logRtc(cNfLog, "IS calculado pelo Protheus = " + fmtVal(aTotPro[4]) + ", mas o IP_040 nao possui campo " + ;
				"de Imposto Seletivo (SAP = 0). Conferir a TES e o cadastro de tributos.")
		EndIf

		// Totais da nota: SZA (gravada pelo SAPIP040 com a soma dos itens) x soma da F2D
		nTolTot	:= RTC_TOLERANCIA * Max(nItens, 1)
		aTotSza	:= {SZA->ZA_IBSUFTO, SZA->ZA_IBSMUTO, SZA->ZA_CBSTOTA, SZA->ZA_IBSTOTA}
		aTotPro[4] := aTotPro[1] + aTotPro[2]	// posicao 4 passa a ser o IBS total (IS ja conferido acima)
		For nI := 1 To Len(aTotSza)
			If Abs(aTotSza[nI] - aTotPro[nI]) > nTolTot
				nDiverg++
				logRtc(cNfLog, "total " + aNomTot[nI] + " SAP = " + fmtVal(aTotSza[nI]) + " / Protheus = " + fmtVal(aTotPro[nI]))
			EndIf
		Next nI

		If nDiverg > 0
			logRtc(cNfLog, cValToChar(nDiverg) + " divergencia(s) de IBS/CBS/IS entre SAP e Protheus. Chave NF SCJ: " + ;
				AllTrim(SZA->ZA_KENFSCJ))
		EndIf

	EndIf

	RestArea(aArea)

Return


/*/{Protheus.doc} confItem
Confere um item da NF RCO: valor e base de IBS UF, IBS municipal e CBS (SAP x F2D).

@type function
@author Wellington Santana
@since 27/11/2026
@param cNfLog, character, Nota/serie para o log
@param cChave, character, Produto|item
@param aNomes, array, Nomes dos tributos {"IBS UF", "IBS Mun", "CBS"}
@param aSapVal, array, Valores do SAP
@param aSapBas, array, Bases do SAP
@param aSapAli, array, Aliquotas do SAP
@param aItProth, array, Item retornado por U_RtcF2DNf
@param lBaseAli, logical, F2D com base e aliquota disponiveis
@return numeric, Quantidade de divergencias do item
/*/
Static Function confItem(cNfLog, cChave, aNomes, aSapVal, aSapBas, aSapAli, aItProth, lBaseAli)

	Local nI		:= 0
	Local nDiverg	:= 0
	Local cDetalhe	:= ""

	For nI := 1 To Len(aNomes)
		If Abs(aSapVal[nI] - aItProth[2][nI]) > RTC_TOLERANCIA
			nDiverg++
			cDetalhe := ""
			If lBaseAli
				cDetalhe := " (base SAP " + fmtVal(aSapBas[nI]) + " x Protheus " + fmtVal(aItProth[3][nI]) + ;
					"; aliquota SAP " + fmtVal(aSapAli[nI]) + " x Protheus " + fmtVal(aItProth[4][nI]) + ")"
			EndIf
			logRtc(cNfLog, "item " + cChave + ": " + aNomes[nI] + " SAP = " + fmtVal(aSapVal[nI]) + ;
				" / Protheus = " + fmtVal(aItProth[2][nI]) + cDetalhe)
		ElseIf lBaseAli .and. (aSapVal[nI] + aItProth[2][nI]) > 0 .and. Abs(aSapBas[nI] - aItProth[3][nI]) > RTC_TOLERANCIA
			// Base so e conferida quando ha tributo: IBS municipal zerado (2026) pode vir sem base no SAP
			nDiverg++
			logRtc(cNfLog, "item " + cChave + ": base de " + aNomes[nI] + " SAP = " + fmtVal(aSapBas[nI]) + ;
				" / Protheus = " + fmtVal(aItProth[3][nI]))
		EndIf
	Next nI

Return nDiverg


/*/{Protheus.doc} logRtc
Registra aviso da conferencia IBS/CBS/IS da NF RCO no log (FWLogMsg WARN).

@type function
@author Wellington Santana
@since 27/11/2026
@param cNfLog, character, Nota/serie
@param cMsg, character, Mensagem
@return nil
/*/
Static Function logRtc(cNfLog, cMsg)

	FWLogMsg("WARN", , "BusinessObject", "PrcGrvRco", "", "01", "[RTC-2026/2027] NF RCO " + cNfLog + ": " + cMsg, 0, 0, {})

Return


/*/{Protheus.doc} fmtVal
Formata valor numerico com 2 casas para o log.

@type function
@author Wellington Santana
@since 27/11/2026
@param nValor, numeric, Valor
@return character, Valor formatado
/*/
Static Function fmtVal(nValor)
Return AllTrim(Str(nValor, 16, 2))


/*/{Protheus.doc} RtcF2DNf
Le na F2D (motor de tributos) o IBS UF, o IBS municipal, a CBS e o IS calculados para
cada item de uma nota fiscal de saida. Usada pela conferencia da NF RCO (PrcGrvRco) e
pela auditoria da NF de retorno simbolico (PrcNfRet).

Codigos dos tributos (F2D_TRIB) lidos dos parametros:
- ZZ_TRIBSUF (IBS UF), ZZ_TRIBSMU (IBS Mun) e ZZ_TRIBCBS (CBS): mesmos parametros e
  padroes do DHLIdManager;
- ZZ_TRIBSIS (IS): sem padrao. Vazio = IS nao lido (retorna zero).
Ignora tributo excluido (F2D_DTEXCL preenchido), como o padrao (FISA175/tciclass).
Base e aliquota so sao lidas quando F2D_BASE e F2D_ALIQ existem no dicionario.

@type function
@author Wellington Santana
@since 27/11/2026
@param cDoc, character, Numero da nota (F2_DOC)
@param cSerie, character, Serie (F2_SERIE)
@param cCliente, character, Cliente (F2_CLIENTE). Vazio = nao filtra cliente/loja
@param cLoja, character, Loja (F2_LOJA)
@return array, {lF2D, lBaseAli, aItens}
        lF2D     - F2D e D2_IDTRIB existem no dicionario (consulta executada)
        lBaseAli - base e aliquota disponiveis
        aItens   - {cChave (D2_COD|D2_ITEM), {vlIBSUF, vlIBSMun, vlCBS, vlIS},
                    {bsIBSUF, bsIBSMun, bsCBS}, {alIBSUF, alIBSMun, alCBS}, nQtdIBSCBS}
/*/
User Function RtcF2DNf(cDoc, cSerie, cCliente, cLoja)

	Local aTrib			:= {}
	Local aBind			:= {}
	Local aItens		:= {}
	Local aBas			:= {}
	Local aAli			:= {}
	Local lF2D			:= .F.
	Local lBaseAli		:= .F.
	Local lDtExcl		:= .F.
	Local cQuery		:= ""
	Local cAliasQry		:= ""
	Local oStatement	:= nil
	Local nI			:= 0

	Default cCliente	:= ""
	Default cLoja		:= ""

	lF2D := AliasInDic("F2D") .and. !Empty(GetSx3Cache("D2_IDTRIB", "X3_CAMPO"))

	If lF2D

		lBaseAli	:= !Empty(GetSx3Cache("F2D_BASE", "X3_CAMPO")) .and. !Empty(GetSx3Cache("F2D_ALIQ", "X3_CAMPO"))
		lDtExcl		:= !Empty(GetSx3Cache("F2D_DTEXCL", "X3_CAMPO"))
		aTrib		:= {SuperGetMv("ZZ_TRIBSUF", .F., "TR0002"), SuperGetMv("ZZ_TRIBSMU", .F., "TR0003"), ;
						SuperGetMv("ZZ_TRIBCBS", .F., "TR0001"), SuperGetMv("ZZ_TRIBSIS", .F., "")}

		cQuery := " SELECT SD2.D2_COD, SD2.D2_ITEM "
		cQuery += " , SUM(CASE WHEN F2D.F2D_TRIB IN (?, ?, ?) THEN 1 ELSE 0 END) QTDIBSCBS "
		aAdd(aBind, aTrib[1])
		aAdd(aBind, aTrib[2])
		aAdd(aBind, aTrib[3])
		For nI := 1 To 4
			cQuery += " , SUM(CASE WHEN F2D.F2D_TRIB = ? THEN F2D.F2D_VALOR ELSE 0 END) VL" + cValToChar(nI)
			aAdd(aBind, aTrib[nI])
		Next nI
		If lBaseAli
			For nI := 1 To 3
				cQuery += " , SUM(CASE WHEN F2D.F2D_TRIB = ? THEN F2D.F2D_BASE ELSE 0 END) BS" + cValToChar(nI)
				aAdd(aBind, aTrib[nI])
				cQuery += " , MAX(CASE WHEN F2D.F2D_TRIB = ? THEN F2D.F2D_ALIQ ELSE 0 END) AL" + cValToChar(nI)
				aAdd(aBind, aTrib[nI])
			Next nI
		EndIf
		cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
		cQuery += " LEFT JOIN " + RetSqlName("F2D") + " F2D ON F2D.F2D_FILIAL = ? "
		aAdd(aBind, xFilial("F2D"))
		cQuery += " 	AND F2D.F2D_IDREL = SD2.D2_IDTRIB "
		cQuery += " 	AND SD2.D2_IDTRIB <> ' ' "
		cQuery += " 	AND F2D.F2D_TABELA = 'SD2' "
		If lDtExcl
			cQuery += " 	AND F2D.F2D_DTEXCL = ' ' "
		EndIf
		cQuery += " 	AND F2D.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE SD2.D2_FILIAL = ? "
		aAdd(aBind, xFilial("SD2"))
		cQuery += " 	AND SD2.D2_DOC = ? "
		aAdd(aBind, cDoc)
		cQuery += " 	AND SD2.D2_SERIE = ? "
		aAdd(aBind, cSerie)
		If !Empty(cCliente)
			cQuery += " 	AND SD2.D2_CLIENTE = ? "
			aAdd(aBind, cCliente)
			cQuery += " 	AND SD2.D2_LOJA = ? "
			aAdd(aBind, cLoja)
		EndIf
		cQuery += " 	AND SD2.D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY SD2.D2_COD, SD2.D2_ITEM "
		cQuery += " ORDER BY SD2.D2_ITEM "

		oStatement := FWExecStatement():New(ChangeQuery(cQuery))
		For nI := 1 To Len(aBind)
			oStatement:SetString(nI, aBind[nI])
		Next nI
		cAliasQry := oStatement:OpenAlias()

		While (cAliasQry)->(!Eof())
			aBas := {0, 0, 0}
			aAli := {0, 0, 0}
			If lBaseAli
				aBas := {(cAliasQry)->BS1, (cAliasQry)->BS2, (cAliasQry)->BS3}
				aAli := {(cAliasQry)->AL1, (cAliasQry)->AL2, (cAliasQry)->AL3}
			EndIf
			aAdd(aItens, {AllTrim((cAliasQry)->D2_COD) + "|" + AllTrim((cAliasQry)->D2_ITEM), ;
				{(cAliasQry)->VL1, (cAliasQry)->VL2, (cAliasQry)->VL3, (cAliasQry)->VL4}, ;
				aBas, aAli, (cAliasQry)->QTDIBSCBS})
			(cAliasQry)->(dbSkip())
		EndDo

		(cAliasQry)->(dbCloseArea())
		oStatement:Destroy()

	EndIf

Return {lF2D, lBaseAli, aItens}


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
