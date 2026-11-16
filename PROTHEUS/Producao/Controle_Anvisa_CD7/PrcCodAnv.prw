#Include 'Protheus.ch'
#Include 'dhl.ch'

#DEFINE TIPO_DOC	1
#DEFINE SERIE		2
#DEFINE NUM_DOC		3
#DEFINE CLIFOR		4
#DEFINE LOJA		5

/*/{Protheus.doc} PrcCodAnv

Realiza controle de codigo da anvisa na tabela CD7

@author Thiago Meschiatti
@since 19/07/2018

@param aChave, array, Chave da Nota Fiscal (Entrada ou Saida,Serie,Doc,Cliente ou Fornecedor,Loja)

/*/
User Function PrcCodAnv(aChave)
	
	Local aArea	 	:= GetArea()
	Local aAreaSD1	:= SD1->(GetArea())
	Local aAreaSD2	:= SD2->(GetArea())
	Local aAreaCD7	:= CD7->(GetArea())
	Local cChave 	:= ""
	Local cCodAnv	:= ""
	Local cMotIsen	:= ""
	Local nI	 	:= 0
	
	For nI := 1 to Len(aChave)
		If aChave[nI, 1] == "E" .and. CD7->(FieldPos("CD7_CODANV")) > 0
			DbSelectArea("SD1")
			SD1->(DbSetOrder(1))
			
			DbSelectArea("CD7")
			CD7->(DbSetOrder(1))
			
			If SD1->(DbSeek(xFilial("SD1") + aChave[nI, NUM_DOC] + aChave[nI, SERIE]+ aChave[nI, CLIFOR] + aChave[nI, LOJA]))
				cChave := xFilial("SD1") + aChave[nI, NUM_DOC] + aChave[nI, SERIE]+ aChave[nI, CLIFOR] + aChave[nI, LOJA]
				
				While SD1->(!eof()) .and. SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == cChave
					If CD7->(DbSeek(xFilial("CD7") + aChave[nI, TIPO_DOC] + aChave[nI, SERIE]+ aChave[nI, NUM_DOC] +;
							aChave[nI, CLIFOR] + aChave[nI, LOJA] + SD1->(D1_ITEM + D1_COD)))
						If SD1->D1_FORMUL == 'S' .and. !Empty(SD1->D1_NFORI)
							If FwUnitBusiness() == DHL_BUSINESSUNIT_DIS .and. SD1->D1_SERIE == DHL_ESPECIE_ESPELHO
								getPrdAnvi(.t., @cCodAnv, @cMotIsen)
							Else
								getAnviSai(@cCodAnv, @cMotIsen)
							EndIf
						Else
							cCodAnv 	:= SD1->D1_ZZPRANV
							cMotIsen	:= SD1->D1_ZZMOTME
						EndIf
						CD7->(RecLock("CD7", .F.))
							CD7->CD7_CODANV := cCodAnv
							CD7->CD7_MOTISE	:= cMotIsen
						CD7->(MsUnlock())
					EndIf
					SD1->(DbSkip())
				EndDo
			EndIf
		Else
			If CD7->(FieldPos("CD7_CODANV")) > 0
				DbSelectArea("SD2")
				SD2->(DbSetOrder(3))
				
				DbSelectArea("CD7")
				CD7->(DbSetOrder(1))
				
				If SD2->(DbSeek(xFilial("SD2") + aChave[nI, NUM_DOC] + aChave[nI, SERIE]+ aChave[nI, CLIFOR] + aChave[nI, LOJA]))
					cChave := xFilial("SD2") + aChave[nI, NUM_DOC] + aChave[nI, SERIE]+ aChave[nI, CLIFOR] + aChave[nI, LOJA]
				
					While SD2->(!eof()) .and. SD2->(D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA) == cChave
						If CD7->(DbSeek(xFilial("CD7") + aChave[nI, TIPO_DOC] + aChave[nI, SERIE]+ aChave[nI, NUM_DOC] +;
								aChave[nI, CLIFOR] + aChave[nI, LOJA] + Padr(SD2->D2_ITEM, TamSx3("CD7_ITEM")[1]) + SD2->D2_COD))
							
							getPrdAnvi(, @cCodAnv, @cMotIsen)
								
							CD7->(RecLock("CD7", .F.))
								CD7->CD7_CODANV := cCodAnv//getPrdAnvi()
								CD7->CD7_MOTISE	:= cMotIsen
							CD7->(MsUnlock())
						EndIf
						SD2->(DbSkip())
					EndDo
				EndIf
				
			EndIf
		EndIf
	Next nI
	
	RestArea(aAreaCD7)
	RestArea(aAreaSD2)
	RestArea(aAreaSD1)
	RestArea(aArea)

Return


/*
** Busca Cod. anvisa na entrada
*/
Static Function getPrdAnvi(lDevolucao, cCodAnv, cMotIsen)
	Local oSql		:= IpSqlObject():newIpSqlObject()
	Local cQuery 	:= ""
	Local cRet		:= ""
	Local cDoc 	    := ""
	Local cSerie 	:= ""
	Local cItem	    := ""
	Local cFornece  := ""
	Local cLoja	    := ""
	Local cCod	    := ""
	Local cLote	    := ""
	Local cVldLote  := ""
	
	Default lDevolucao 	:= .f.
	Default cCodAnv 	:= ""
	Default cMotIsen 	:= ""
	
	If lDevolucao
		cDoc 	:= substr(SD1->D1_ZZCHVNF, 1, TamSx3("D1_DOC")[1])
		cSerie 	:= substr(SD1->D1_ZZCHVNF, 10, TamSx3("D1_SERIE")[1])
		cItem	:= substr(SD1->D1_ZZCHVNF, 13, TamSx3("D1_ITEM")[1])
		cFornece:= substr(SD1->D1_ZZCHVNF, 17, TamSx3("D1_FORNECE")[1])
		cLoja	:= substr(SD1->D1_ZZCHVNF, 23, TamSx3("D1_LOJA")[1])
		cCod	:= SD1->D1_COD
		cLote	:= SD1->D1_LOTECTL
		cVldLote:= dtos(SD1->D1_DTVALID)
	EndIf
	
	cQuery += " SELECT D1_ZZPRANV, D1_ZZMOTME                      			"+CRLF
	cQuery += " FROM %SD1.SQLNAME%                                 			"+CRLF
	cQuery += " WHERE                                              			"+CRLF
	cQuery += " 	%SD1.XFILIAL%                                  			"+CRLF
	If lDevolucao
		cQuery += " 	AND D1_DOC 		= '" + cDoc + "'      			"+CRLF
		cQuery += " 	AND D1_SERIE	= '" + cSerie + "'    			"+CRLF
		cQuery += " 	AND D1_ITEM		= '" + cItem + "'    			"+CRLF
		cQuery += " 	AND D1_COD		= '" + cCod + "'        		"+CRLF
		cQuery += " 	AND D1_LOTECTL	= '" + cLote + "'    			"+CRLF
		cQuery += " 	AND D1_DTVALID	= '" + cVldLote + "'    		"+CRLF
		cQuery += " 	AND D1_FORNECE	= '" + cFornece + "'    		"+CRLF
		cQuery += " 	AND D1_LOJA		= '" + cLoja + "'    			"+CRLF
	Else
		cQuery += " 	AND D1_DOC 		= '" + SD2->D2_NFORI + "'      			"+CRLF
		cQuery += " 	AND D1_SERIE	= '" + SD2->D2_SERIORI + "'    			"+CRLF
		cQuery += " 	AND D1_ITEM		= '" + SD2->D2_ITEMORI + "'    			"+CRLF
		cQuery += " 	AND D1_COD		= '" + SD2->D2_COD + "'        			"+CRLF
		cQuery += " 	AND D1_LOTECTL	= '" + SD2->D2_LOTECTL + "'    			"+CRLF
		cQuery += " 	AND D1_DTVALID	= '" + dtos(SD2->D2_DTVALID) + "'    	"+CRLF
		cQuery += " 	AND D1_IDENTB6	= '" + SD2->D2_IDENTB6 + "'    			"+CRLF
	EndIf
	cQuery += " 	AND %SD1.NOTDEL% "+CRLF
	
	oSql:newAlias(cQuery)
	
	If oSql:hasRecords()
		cCodAnv		:= oSql:getValue("D1_ZZPRANV")
		cMotIsen 	:= oSql:getValue("D1_ZZMOTME")
	EndIf
	
	oSql:close()
		
Return


/*
** Busca Cod. anvisa na entrada
*/
Static Function getAnviSai(cCodAnv, cMotIsen)
	Local oSql		:= IpSqlObject():newIpSqlObject()
	Local cQuery 	:= ""
	Local cRet		:= ""
	
	Default cCodAnv 	:= ""
	Default cMotIsen 	:= ""
	
	cQuery += " SELECT CD7_CODANV, CD7_MOTISE                      			"+CRLF
	cQuery += " FROM %CD7.SQLNAME%                                 			"+CRLF
	cQuery += " WHERE                                              			"+CRLF
	cQuery += " 	%CD7.XFILIAL%                                  			"+CRLF
	cQuery += " 	AND CD7_DOC 	= '" + SD1->D1_NFORI + "'      			"+CRLF
	cQuery += " 	AND CD7_SERIE	= '" + SD1->D1_SERIORI + "'    			"+CRLF
	cQuery += " 	AND CD7_TPMOV	= 'S'    								"+CRLF
	cQuery += " 	AND CD7_ITEM	= '" + SD1->D1_ITEMORI + "'    			"+CRLF
	cQuery += " 	AND CD7_COD		= '" + SD1->D1_COD + "'        			"+CRLF
	cQuery += " 	AND CD7_LOTE	= '" + SD1->D1_LOTECTL + "'    			"+CRLF
	cQuery += " 	AND CD7_VALID	= '" + dtos(SD1->D1_DTVALID) + "'    	"+CRLF
	cQuery += " 	AND %CD7.NOTDEL% "+CRLF
		
	oSql:newAlias(cQuery)
	
	If oSql:hasRecords()
		cCodAnv 	:= oSql:getValue("CD7_CODANV")
		cMotIsen	:= oSql:getValue("CD7_MOTISE")
	EndIf
	
	oSql:close()
		
Return
