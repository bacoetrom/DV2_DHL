#Include 'Protheus.ch'
#Include 'topconn.ch'

User Function GrvF0A(cEntSai,cSerie,cDoc,cClieFor,cLoja,lUsaSped)
	Local lTabF0A 	:= AliasInDic("F0A")
	Local cMVRastro	:= Alltrim(SuperGetMv("MV_RASTRO",,"N"))
	Local cMVMedica := ""
	Local cGrpRasNFE:= ""
	Local cVerGrup	:= ""
	Local lExiste
	Local cLoteOri	:= ""
	Local dDtFabOri
	Local dDataFabric
	Local dDataValid
	Local aArea		:= GetArea()
	Local lret      := .F.
	Local cQuery	:= ""
	Local cAlias	:= ""
	
	Default lUsaSped :=	cPaisLoc == "BRA"
	
	cAlias := GetNextAlias()
	cQuery := "SELECT " + CRLF
	cQuery += "	X6_CONTEUD AS CONTEUD " + CRLF
	cQuery += "FROM " + CRLF
	cQuery += "	" + RetSqlName("SX6") + " " + CRLF
	cQuery += "WHERE 1=1" + CRLF
	cQuery += "	AND X6_FIL = '" + FWxFilial("SX6") + "' " + CRLF
	cQuery += "	AND X6_VAR LIKE 'MV_MEDIC%' " + CRLF
	cQuery += "	AND D_E_L_E_T_ = ' ' " + CRLF
	TcQuery cQuery NEW Alias &cAlias
	
	If (cAlias)->(!Eof())
		While (cAlias)->(!Eof())
			If !Empty((cAlias)->CONTEUD)
				cMVMedica += "/" + AllTrim((cAlias)->CONTEUD)
			EndIf
			(cAlias)->(DbSkip())
		EndDo
	EndIf
	
	(cAlias)->(DbCloseArea())
	
	cAlias := GetNextAlias()
	cQuery := "SELECT " + CRLF
	cQuery += "	X5_CHAVE AS CHAVE " + CRLF
	cQuery += "FROM " + CRLF
	cQuery += "	" + RetSqlName("SX5") + " " + CRLF
	cQuery += "WHERE 1=1" + CRLF
	cQuery += "	AND X5_FILIAL = '" + FWxFilial("SX5") + "' " + CRLF
	cQuery += "	AND X5_TABELA = 'T0' " + CRLF
	cQuery += "	AND D_E_L_E_T_ = ' ' " + CRLF
	TcQuery cQuery NEW Alias &cAlias
	
	If (cAlias)->(!Eof())
		While (cAlias)->(!Eof())
			cGrpRasNFE += "/" + AllTrim((cAlias)->CHAVE)
			(cAlias)->(DbSkip())
		EndDo
	EndIf
	
	(cAlias)->(DbCloseArea())
	
	cVerGrup	:= Alltrim(cMVMedica) + AllTrim(cGrpRasNFE)
	If !Empty(cVerGrup) .And. lUsaSped .And. "S"$cMVRastro
	
		If cEntSai=="E"
			DbSelectArea("SD1")
			SD1->(DbSetOrder())
			If SD1->(DbSeek(xFilial("SD1") + cDoc + cSerie + cClieFor + cLoja))
				While SD1->(!Eof()) .and. ;
					 (xFilial("SD1") + cDoc + cSerie + cClieFor + cLoja == SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA))
					
					Posicione("SB1", 1, xFilial("SB1") + SD1->D1_COD, "!Eof()")
					If lTabF0A .And. ( (AllTrim(SB1->B1_GRUPO) $ cGrpRasNFE) .Or. (AllTrim(SB1->B1_GRUPO) $ cMVMedica) )
						dbSelectArea("F0A")
						F0A->(dbSetOrder(1))
						lExiste	:= F0A->(dbSeek(xFilial("F0A")+cEntSai+cSerie+PADR(cDoc,TamSX3("F0A_DOC")[1])+cClieFor+cLoja+SD1->D1_ITEM))
						cLoteOri  := GetAdvFVal( "F0A", "F0A_LOTE", xFilial("F0A")+"S"+SD1->D1_SERIORI+PADR(SD1->D1_NFORI,TamSX3("F0A_DOC")[1])+cClieFor+cLoja+SD1->D1_ITEMORI, 1 , "")
						dDtFabOri := GetAdvFVal( "F0A", "F0A_FABRIC", xFilial("F0A")+"S"+SD1->D1_SERIORI+PADR(SD1->D1_NFORI,TamSX3("F0A_DOC")[1])+cClieFor+cLoja+SD1->D1_ITEMORI, 1 , "")
			 
						If !Empty(SD1->D1_LOTECTL) .Or. !Empty(cLoteOri)
							If !lExiste
								DbSelectarea("SB8")
								SB8->(DbSetOrder(5))
								SB8->(DbSeek(xFilial("SB8")+SD1->D1_COD+SD1->D1_LOTECTL+SD1->D1_NUMLOTE+DTOS(SD1->D1_DTVALID)))
								If SB8->(FieldPos("B8_DFABRIC")) >0 .and. !Empty(DTOS(SB8->B8_DFABRIC) )
									dDataFabric	:= SB8->B8_DFABRIC
								Else
									dDataFabric	:= SD1->D1_DFABRIC
								EndIf
								If SB8->(FieldPos("B8_DTVALID")) >0 .and. !Empty(DTOS(SB8->B8_DTVALID) )
									dDataValid	:= SB8->B8_DTVALID
								Else
									dDataValid	:= SD1->D1_DTVALID
								EndIf
						
								RecLock("F0A",.T.)
								F0A->F0A_FILIAL	:= SD1->D1_FILIAL
								F0A->F0A_TPMOV	:= "E"
								F0A->F0A_DOC	:= SD1->D1_DOC
								F0A->F0A_SERIE	:= SD1->D1_SERIE
								F0A->F0A_CLIFOR	:= SD1->D1_FORNECE
								F0A->F0A_LOJA	:= SD1->D1_LOJA
								F0A->F0A_ITEM	:= SD1->D1_ITEM
								F0A->F0A_COD	:= SD1->D1_COD
								F0A->F0A_LOTE	:= IIf(Empty(cLoteOri),SD1->D1_LOTECTL,cLoteOri)
								F0A->F0A_VALID	:= dDataValid
								F0A->F0A_QTDLOT	:= SD1->D1_QUANT
								F0A->F0A_FABRIC	:= IIf(Empty(dDtFabOri), dDataFabric, dDtFabOri)
							Else
								RecLock("F0A",.F.)
								F0A->F0A_LOTE	:= SD1->D1_LOTECTL
								F0A->F0A_VALID	:= SD1->D1_DTVALID
							EndIf
							MsUnLock()
							FkCommit()
			    	
							lret := .T.
						EndIf
					Endif
					SD1->(DbSkip())
				EndDo
			EndIf
		EndIf
	EndIf
	RestArea(aArea)
	
return( lret )
