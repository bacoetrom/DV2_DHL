#Include 'Protheus.ch'
#Include 'topconn.ch'

#Define	VALOR_IGUAL	'I'	// Alterado valor igual
#Define VALOR_MAIOR 'P' // Alterado valor do SB6 maior (NF Complemento)
#Define VALOR_MENOR	'N' // Alterado valor do SB6 menor
#Define SALDO_NFS	'V' // Saldo em varias NFs


/*/{Protheus.doc} PrcDivEst
Relatório com possibilidade de alteração de registros com divergência de estoque
@type function
@author Thiago Meschiatti
@since 12/01/2018
@version 1.0
/*/
User Function PrcDivEst()
	Local oSqlSd2 	:= IpSqlObject():newIpSqlObject()
	Local oSqlIgual	:= IpSqlObject():newIpSqlObject()
	
	local bParams		:= {|| lInfParams := getParams() }
	local bProcRel		:= {|| procRel() }
	
	private lInfParams	:= .F.
	
	private cNome  		:= "RelDivEst"
	private cTitulo 	:= "Divergência de Estoque"
	private cDescricao	:= "Relatório de "+cTitulo
	private cAlias		:= ""
 	
	private oReport		:= nil
	private oSecDados	:= nil
	 	
	private oParamBox 	:= IpParamBoxObject():newIpParamBoxObject(cNome)
	
	private oSql		:= nil
	
	oReport := TReport():new(cNome, cTitulo, bParams, bProcRel, cDescricao)
	oReport:setLandscape()
	oReport:printDialog()
	
Return


/**
 * Processamento do Relatório
 */
static function procRel()

	if (!lInfParams .and. !getParams())
		MsgBox("Processamento abortado", "Atenção", "ALERT")
		return
	endIf
	
	dDataAte		:= oParamBox:getValue("dataAte")
	 
	retSD2(dDataAte, .t.)
	criaSecoes()
	
	procImpressao(MsgYesNo("Processar Impressão do Relatório e efetuar atualizações das tabelas?"))
	
return


/**
 * Processamento da Impressão
 */
static function procImpressao(lUpdTab)
	Local oSqlIgual 	:= IpSqlObject():newIpSqlObject()
	Local oSqlMaior 	:= IpSqlObject():newIpSqlObject()
	Local oSqlMenor 	:= IpSqlObject():newIpSqlObject()
	Local oSqlSaldo		:= IpSqlObject():newIpSqlObject()

	Local cDocSugerido 	:= ""
	Local cSerSugerido	:= ""
	Local cItemSugerido	:= ""
	Local cDataSugerido	:= ""
	Local cDtEntSugerido:= ""
	Local cIdentSugerido:= ""
	Local cPrdSugerido	:= ""
	Local nSaldo		:= ""
	Local nPrecoSugerido:= 0
	Local nDifPreco		:= 0
	Local nDifPrcTotal	:= 0
	Local cCond			:= ""
	Local cAtualizado	:= ""
	
	Local lCopiar		:= Aviso("Atenção","'Copiar' - Apenas copiar tabelas ou 'Processar' - Copiar e processar Relatório",{"Copiar","Processar"},3) == 1//MsgYesNo("Apenas copiar tabelas?")
	
	Default lUpdTab 	:= .f.
	
	
	If lCopiar
		oReport:SetMeter(2)
		
		copytoSB6()
		oReport:IncMeter()
		copytoSD2()
		oReport:IncMeter()
	Else
		oReport:startPage()
		oSecDados:init()
		
		oReport:SetMeter(oSql:count()+2)
		copytoSB6()
		oReport:IncMeter()
		copytoSD2()
		oReport:IncMeter()
	EndIf
	
	
//	If MsgYesNo("Apens copiar tabelas?")
//		copytoSB6()
//		oReport:IncMeter()
//		copytoSD2()
//	Else
//		oReport:IncMeter()
//	EndIf
//	
	oSql:goTop()
	
	If !lCopiar
		BEGIN TRANSACTION 
			while oSql:notIsEof()
				oReport:IncMeter()
				cDocSugerido 	:= ""
				cSerSugerido	:= ""
				cItemSugerido	:= ""
				cDataSugerido	:= ""
				cDtEntSugerido	:= ""
				cIdentSugerido	:= ""
				cPrdSugerido	:= ""
				nSaldo			:= ""
				nPrecoSugerido	:= 0
				nDifPreco		:= 0
				nDifPrcTotal	:= 0
				cCond			:= ""
				cAtualizado		:= ""
				
				oSecDados:Cell("D2_DOC"):setValue(oSql:getValue("D2_DOC"))	
				oSecDados:Cell("D2_SERIE"):setValue(oSql:getValue("D2_SERIE"))	 	
				oSecDados:Cell("D2_ITEM"):setValue(oSql:getValue("D2_ITEM"))	 		
				oSecDados:Cell("D2_EMISSAO"):setValue(oSql:getValue("D2_EMISSAO"))		
				oSecDados:Cell("D2_IDENTB6"):setValue(oSql:getValue("D2_IDENTB6"))	 	
				oSecDados:Cell("D2_COD"):setValue(oSql:getValue("D2_COD"))		
				oSecDados:Cell("D2_NFORI"):setValue(oSql:getValue("D2_NFORI"))	 	
				oSecDados:Cell("D2_SERIORI"):setValue(oSql:getValue("D2_SERIORI"))	 	
				oSecDados:Cell("D2_ITEMORI"):setValue(oSql:getValue("D2_ITEMORI"))		
				oSecDados:Cell("D2_QUANT"):setValue(oSql:getValue("D2_QUANT"))	
				oSecDados:Cell("D2_PRCVEN"):setValue(oSql:getValue("D2_PRCVEN"))	 	
				oSecDados:Cell("D2_TOTAL"):setValue(oSql:getValue("D2_TOTAL"))	 	
				
				oSqlIgual:newAlias(qrySugIgual(	oSql:getValue("D2_COD"),;
												oSql:getValue("D2_QUANT"),; 
												oSql:getValue("D2_PRCVEN"),;
												oSql:getValue("D2_CLIENTE"),;
												oSql:getValue("D2_LOJA"),;
												oSql:getValue("D2_EMISSAO")))
				
				oSqlIgual:setField("B6_EMISSAO", "D")
				oSqlIgual:setField("B6_DTDIGIT", "D")
				
				If oSqlIgual:hasRecords()
					cDocSugerido 	:= oSqlIgual:getValue("B6_DOC")
					cSerSugerido	:= oSqlIgual:getValue("B6_SERIE")
					cItemSugerido	:= oSqlIgual:getValue("D1_ITEM")
					cDataSugerido	:= oSqlIgual:getValue("B6_EMISSAO")
					cDtEntSugerido	:= oSqlIgual:getValue("B6_DTDIGIT")
					cIdentSugerido	:= oSqlIgual:getValue("B6_IDENT")
					cPrdSugerido	:= oSqlIgual:getValue("B6_PRODUTO")
					nSaldo			:= oSqlIgual:getValue("B6_SALDO")
					nPrecoSugerido	:= oSqlIgual:getValue("B6_PRUNIT")
					nDifPreco		:= oSqlIgual:getValue("B6_PRUNIT") - oSql:getValue("D2_PRCVEN")
					nDifPrcTotal	:= oSql:getValue("D2_QUANT") * nDifPreco
					cCond			:= "R$ IGUAL"
					
					updSB6(oSql, oSqlIgual)
					
					If lUpdTab
						If updSD2(oSql, oSqlIgual, VALOR_IGUAL)
							DisarmTransaction()
							cAtualizado := "Não"
							
							Alert("Não foi possível atualizar regitro, operação será abortada! " +;
									oSql:getValeu("D2_DOC") + CRLF + ;
									oSql:getValeu("D2_SERIE") + CRLF + ;
									oSql:getValeu("D2_EMISSAO") + CRLF + ;
									oSql:getValeu("D2_IDENTB6") + CRLF + ;
									oSql:getValeu("D2_COD") + CRLF + ;
									oSql:getValeu("D2_ITEM") + CRLF + ;
									oSql:getValeu("D2_PRCVEN") + CRLF + ;
									oSql:getValeu("D2_QUANT"))
						Else
							cAtualizado := "Sim"
						EndIf
					EndIf
					
					oSqlIgual:close()
				Else
					oSqlIgual:close()
					oSqlMaior:newAlias(qrySugMaior(	oSql:getValue("D2_COD"),;
													oSql:getValue("D2_QUANT"),; 
													oSql:getValue("D2_PRCVEN"),;
													oSql:getValue("D2_CLIENTE"),;
													oSql:getValue("D2_LOJA"),;
													oSql:getValue("D2_EMISSAO")))
													
					oSqlMaior:setField("B6_EMISSAO", "D")
					oSqlMaior:setField("B6_DTDIGIT", "D")
					
					If oSqlMaior:hasRecords()
						cDocSugerido 	:= oSqlMaior:getValue("B6_DOC")
						cSerSugerido	:= oSqlMaior:getValue("B6_SERIE")
						cItemSugerido	:= oSqlMaior:getValue("D1_ITEM")
						cDataSugerido	:= oSqlMaior:getValue("B6_EMISSAO")
						cDtEntSugerido	:= oSqlMaior:getValue("B6_DTDIGIT")
						cIdentSugerido	:= oSqlMaior:getValue("B6_IDENT")
						cPrdSugerido	:= oSqlMaior:getValue("B6_PRODUTO")
						nSaldo			:= oSqlMaior:getValue("B6_SALDO")
						nPrecoSugerido	:= oSqlMaior:getValue("B6_PRUNIT")
						nDifPreco		:= oSqlMaior:getValue("B6_PRUNIT") - oSql:getValue("D2_PRCVEN")
						nDifPrcTotal	:= oSql:getValue("D2_QUANT") * nDifPreco
						cCond			:= "DIFERENÇA MENOR (EMITIR COMPLEMENTO)"//"R$ NF SALDO MAIOR QUE NF VENDA"
						
						updSB6(oSql, oSqlMaior)
						
						If lUpdTab
							If updSD2(oSql, oSqlMaior, VALOR_MAIOR)
								DisarmTransaction()
								cAtualizado := "Não"
								
								Alert("Não foi possível atualizar regitro, operação será abortada! " +;
										oSql:getValeu("D2_DOC") + CRLF + ;
										oSql:getValeu("D2_SERIE") + CRLF + ;
										oSql:getValeu("D2_EMISSAO") + CRLF + ;
										oSql:getValeu("D2_IDENTB6") + CRLF + ;
										oSql:getValeu("D2_COD") + CRLF + ;
										oSql:getValeu("D2_ITEM") + CRLF + ;
										oSql:getValeu("D2_PRCVEN") + CRLF + ;
										oSql:getValeu("D2_QUANT"))
							Else
								cAtualizado := "Sim"
							EndIf	
						EndIf
						
						oSqlMaior:close()
					Else
						oSqlMaior:close()
						oSqlMenor:newAlias(qrySugMenor(	oSql:getValue("D2_COD"),;
														oSql:getValue("D2_QUANT"),; 
														oSql:getValue("D2_PRCVEN"),;
														oSql:getValue("D2_CLIENTE"),;
														oSql:getValue("D2_LOJA"),;
														oSql:getValue("D2_EMISSAO")))
														
						oSqlMenor:setField("B6_EMISSAO", "D")
						oSqlMenor:setField("B6_DTDIGIT", "D")
													
						If oSqlMenor:hasRecords()	
							cDocSugerido 	:= oSqlMenor:getValue("B6_DOC")
							cSerSugerido	:= oSqlMenor:getValue("B6_SERIE")
							cItemSugerido	:= oSqlMenor:getValue("D1_ITEM")
							cDataSugerido	:= oSqlMenor:getValue("B6_EMISSAO")
							cDtEntSugerido	:= oSqlMenor:getValue("B6_DTDIGIT")
							cIdentSugerido	:= oSqlMenor:getValue("B6_IDENT")
							cPrdSugerido	:= oSqlMenor:getValue("B6_PRODUTO")
							nSaldo			:= oSqlMenor:getValue("B6_SALDO")
							nPrecoSugerido	:= oSqlMenor:getValue("B6_PRUNIT")
							nDifPreco		:= oSqlMenor:getValue("B6_PRUNIT") - oSql:getValue("D2_PRCVEN")
							nDifPrcTotal	:= oSql:getValue("D2_QUANT") * nDifPreco
							cCond			:= "DIFERENÇA MAIOR"//"R$ NF SALDO MENOR QUE NF VENDA"
							
							updSB6(oSql, oSqlMenor)
		
							If lUpdTab
								If updSD2(oSql, oSqlMenor, VALOR_MENOR)
									DisarmTransaction()
									cAtualizado := "Não"
									
									Alert("Não foi possível atualizar regitro, operação será abortada! " +;
											oSql:getValeu("D2_DOC") + CRLF + ;
											oSql:getValeu("D2_SERIE") + CRLF + ;
											oSql:getValeu("D2_EMISSAO") + CRLF + ;
											oSql:getValeu("D2_IDENTB6") + CRLF + ;
											oSql:getValeu("D2_COD") + CRLF + ;
											oSql:getValeu("D2_ITEM") + CRLF + ;
											oSql:getValeu("D2_PRCVEN") + CRLF + ;
											oSql:getValeu("D2_QUANT"))
								Else
									cAtualizado := "Sim"
								EndIf		
							EndIf
							
							oSqlMenor:close()
						Else
							oSqlMenor:close()
							oSqlSaldo:newAlias(qrySaldo(	oSql:getValue("D2_COD"),;
															oSql:getValue("D2_QUANT"),; 
															oSql:getValue("D2_PRCVEN"),;
															oSql:getValue("D2_CLIENTE"),;
															oSql:getValue("D2_LOJA"),;
															oSql:getValue("D2_EMISSAO")))
															
							If oSqlSaldo:hasRecords()
								If oSqlSaldo:getValue("SALDO") >= oSql:getValue("D2_QUANT")
									cDocSugerido 	:= "XXXXX"//oSqlSaldo:getValue("B6_DOC")
									cSerSugerido	:= "XXXXX"//oSqlSaldo:getValue("B6_SERIE")
									cItemSugerido	:= "XXXXX"//oSqlSaldo:getValue("D1_ITEM")
									cDataSugerido	:= "XXXXX"//oSqlSaldo:getValue("B6_EMISSAO")
									cDtEntSugerido	:= "XXXXX"//oSqlSaldo:getValue("B6_DTDIGIT")
									cIdentSugerido	:= "XXXXX"//oSqlSaldo:getValue("B6_IDENT")
									cPrdSugerido	:= oSqlSaldo:getValue("B6_PRODUTO")
									nSaldo			:= oSqlSaldo:getValue("SALDO")
									nPrecoSugerido	:= oSqlSaldo:getValue("PRECO_MEDIO")
									nDifPreco		:= oSqlSaldo:getValue("PRECO_MEDIO") - oSql:getValue("D2_QUANT")
									nDifPrcTotal	:= oSql:getValue("D2_QUANT") * nDifPreco
									cCond			:= "COM SALDO EM DIVERSAS NOTAS"
									
									updSB6Nfs(oSql, oSqlSaldo)
				
									If lUpdTab
										If updSD2(oSql, oSqlSaldo, SALDO_NFS)
											DisarmTransaction()
											cAtualizado := "Não"
											
											Alert("Não foi possível atualizar regitro, operação será abortada! " +;
													oSql:getValeu("D2_DOC") + CRLF + ;
													oSql:getValeu("D2_SERIE") + CRLF + ;
													oSql:getValeu("D2_EMISSAO") + CRLF + ;
													oSql:getValeu("D2_IDENTB6") + CRLF + ;
													oSql:getValeu("D2_COD") + CRLF + ;
													oSql:getValeu("D2_ITEM") + CRLF + ;
													oSql:getValeu("D2_PRCVEN") + CRLF + ;
													oSql:getValeu("D2_QUANT"))
										Else
											cAtualizado := "Sim"
										EndIf		
									EndIf
									
									oSqlSaldo:close()
								Else
									cCond			:= "SEM SALDO"
									oSqlSaldo:close()
								EndIf
							Else
								cCond			:= "SEM SALDO"
								oSqlSaldo:close()
							EndIf
						EndIf
					EndIf
				EndIf
				
				
				oSecDados:Cell("B6_DOC"):setValue(cDocSugerido)			
				oSecDados:Cell("B6_SERIE"):setValue(cSerSugerido)	 	
				oSecDados:Cell("D1_ITEM"):setValue(cItemSugerido)	 		
				oSecDados:Cell("B6_EMISSAO"):setValue(cDataSugerido)
				oSecDados:Cell("B6_DTDIGIT"):setValue(cDtEntSugerido)
				oSecDados:Cell("B6_IDENT"):setValue(cIdentSugerido)		
				oSecDados:Cell("B6_PRODUTO"):setValue(cPrdSugerido)	 	
				oSecDados:Cell("B6_SALDO"):setValue(nSaldo)		
				oSecDados:Cell("D1_VUNIT"):setValue(nPrecoSugerido)	 	
				oSecDados:Cell("DIFUNIT"):setValue(nDifPreco)
				oSecDados:Cell("DIFTOTAL"):setValue(nDifPrcTotal)
				oSecDados:Cell("COND"):setValue(cCond)	
				oSecDados:Cell("ATUALIZ"):setValue(cAtualizado)	
				
				oSecDados:printLine()
					
				oSql:skip()
				
			endDo
			
			oSecDados:finish()
		END TRANSACTION
	EndIf
	
	oSql:close()
	
return


/*
** Atualiza Temp de saldo
*/
Static Function updSB6(oSqlSd2, oSqlSb6)
	Local oUpd 		:= IpSqlObject():newIpSqlObject()
	Local cUpd		:= ""
	Local cSaldo	:= 0
	
	cSaldo :=  AllTrim(str(oSqlSb6:getValue("B6_SALDO") - oSqlSd2:getValue("D2_QUANT"))) 
	
	cUpd += "UPDATE SB6BKP "
	cUpd += "	SET B6_SALDO = " + cSaldo 
	cUpd += " WHERE "
	cUpd += "	SB6BKP.R_E_C_N_O_ = "+cValToChar(oSqlSb6:getValue("REC"))		
	
	If TcSqlExec(cUpd) != 0
		FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Erro", 0, 0, {})
	Else
		FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "OK", 0, 0, {})
	EndIf
	
//	oUpd:update("SB6BKP", " B6_SALDO = " + cSaldo + " ", "SB6BKP.R_E_C_N_O_ = "+cValToChar(oSqlSb6:getValue("REC"))+" "	)
	
Return


/*
** Atualiza Temp de saldo
*/
Static Function updSB6Nfs(oSqlSd2, oSqlSb6)
	Local oUpd 		:= IpSqlObject():newIpSqlObject()
	Local oSqlNfs	:= IpSqlObject():newIpSqlObject()
	Local cUpd		:= ""
	Local nSaldoOrig:= oSqlSd2:getValue("D2_QUANT")
	Local cSaldo	:= 0
	
//	cSaldo :=  AllTrim(str(oSqlSb6:getValue("B6_SALDO") - oSqlSd2:getValue("D2_QUANT"))) 

	oSqlNfs:newAlias(qryNfsSaldo(	oSql:getValue("D2_COD"),;
									oSql:getValue("D2_QUANT"),; 
									oSql:getValue("D2_PRCVEN"),;
									oSql:getValue("D2_CLIENTE"),;
									oSql:getValue("D2_LOJA"),;
									oSql:getValue("D2_EMISSAO")))

	While oSqlNfs:notIsEof()
		cSaldo	:= 0 
		cUpd 	:= ""
		
		If nSaldoOrig > oSqlNfs:getValue("B6_SALDO")
			nSaldoOrig	:= nSaldoOrig - oSqlNfs:getValue("B6_SALDO")
			cSaldo 		:= "0"
		Else //nSaldoOrig < oSqlNfs:getValue("B6_SALDO")
			cSaldo 		:= AllTrim(str(oSqlNfs:getValue("B6_SALDO") - nSaldoOrig))
			nSaldoOrig  := 0
		EndIf
		
		cUpd += "UPDATE SB6BKP "
		cUpd += "	SET B6_SALDO = " + cSaldo 
		cUpd += " WHERE "
		cUpd += "	SB6BKP.R_E_C_N_O_ = "+cValToChar(oSqlNfs:getValue("REC"))
		
		If TcSqlExec(cUpd) != 0
			FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Erro", 0, 0, {})
		Else
			FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "OK", 0, 0, {})
		EndIf
	
		If nSaldoOrig = 0
			exit
		EndIf
		
		oSqlNfs:skip()
	EndDo									
	
	oSqlNfs:close()
//	oUpd:update("SB6BKP", " B6_SALDO = " + cSaldo + " ", "SB6BKP.R_E_C_N_O_ = "+cValToChar(oSqlSb6:getValue("REC"))+" "	)
	
Return


/*
** Atualiza Temp de saldo
*/
Static Function updSD2(oSqlSd2, oSqlSb6, cStatus)
	Local oUpd 		:= IpSqlObject():newIpSqlObject()
	Local cUpd		:= ""
	Local lErro		:= .f.
	
	If cStatus = SALDO_NFS
//		cUpd += " UPDATE SD2BKP "
//		cUpd += " SET "
//		cUpd += " 	 D2_ZZMODIF	= '" + cStatus + "' "
//		cUpd += " WHERE "
//		cUpd += "	SD2BKP.R_E_C_N_O_ = "+cValToChar(oSqlSd2:getValue("RECSD2"))
	
		cUpd += " UPDATE SD2100 SD2 "
		cUpd += " SET "
		cUpd += " 	 D2_ZZMODIF	= '" + cStatus + "' "
		cUpd += " WHERE "
		cUpd += "	SD2.R_E_C_N_O_ = "+cValToChar(oSqlSd2:getValue("RECSD2"))
	Else
	
//		cUpd += " UPDATE SD2BKP "
//		cUpd += " SET "
//		cUpd += " 	 D2_NFORI 	= '" + oSqlSb6:getValue("B6_DOC") + "' "
//		cUpd += " 	,D2_SERIORI	= '" + oSqlSb6:getValue("B6_SERIE") + "' "
//		cUpd += " 	,D2_ITEMORI = '" + oSqlSb6:getValue("D1_ITEM") + "' "
//		cUpd += " 	,D2_IDENTB6	= '" + oSqlSb6:getValue("B6_IDENT") + "' " // ou D1_IDENTB6
//		cUpd += " 	,D2_ZZMODIF	= '" + cStatus + "' "
//		cUpd += " WHERE "
//		cUpd += "	SD2BKP.R_E_C_N_O_ = "+cValToChar(oSqlSd2:getValue("RECSD2"))		
		
		cUpd += " UPDATE SD2100 SD2 "
		cUpd += " SET "
		cUpd += " 	 D2_NFORI 	= '" + oSqlSb6:getValue("B6_DOC") + "' "
		cUpd += " 	,D2_SERIORI	= '" + oSqlSb6:getValue("B6_SERIE") + "' "
		cUpd += " 	,D2_ITEMORI = '" + oSqlSb6:getValue("D1_ITEM") + "' "
		cUpd += " 	,D2_IDENTB6	= '" + oSqlSb6:getValue("B6_IDENT") + "' " // ou D1_IDENTB6
		cUpd += " 	,D2_ZZMODIF	= '" + cStatus + "' "
		cUpd += " WHERE "
		cUpd += "	SD2.R_E_C_N_O_ = "+cValToChar(oSqlSd2:getValue("RECSD2"))
	EndIf		
	
	If TcSqlExec(cUpd) != 0
		FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Erro Upd", 0, 0, {})
		lErro := .t.
	Else
		FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "OK Upd", 0, 0, {})
	EndIf
	
//	oUpd:update("SB6BKP", " B6_SALDO = " + cSaldo + " ", "SB6BKP.R_E_C_N_O_ = "+cValToChar(oSqlSb6:getValue("REC"))+" "	)
	
Return (lErro)


/*
** O QUE TEM NO SD2 E NAO TEM NO SB6
*/
Static Function retSD2(dDataAte, lProc)
	Local cQuery 	:= ""
	
	Default dDataAte := dToS(dDataAte)
	Default lProc 	 := .F.

	cQuery += " SELECT 	D2_DOC, D2_SERIE,D2_EMISSAO, D2_IDENTB6,D2_COD, D2_ITEM,D2_PRCVEN, D2_QUANT, 	"+CRLF
	cQuery += " 		D2_TOTAL, D2_NFORI, D2_ITEMORI, D2_SERIORI, B6_DOC, SD2.R_E_C_N_O_ RECSD2,	  	"+CRLF
	cQuery += " 		D2_CLIENTE, D2_LOJA															  	"+CRLF
	cQuery += " FROM %SD2.SQLNAME%                                                        				"+CRLF
	cQuery += " INNER JOIN %SF4.SQLNAME% ON                                               				"+CRLF
	cQuery += " 	F4_FILIAL 		= D2_FILIAL                                           				"+CRLF
	cQuery += " 	AND F4_CODIGO 	= D2_TES                                              				"+CRLF
	cQuery += " 	AND F4_ESTOQUE 	= 'S'                                                 				"+CRLF
	cQuery += " 	AND F4_PODER3 	= 'D'                                                 				"+CRLF
	cQuery += " 	AND %SF4.NOTDEL%                                                      				"+CRLF
	cQuery += " LEFT JOIN %SB6.SQLNAME% ON                                                				"+CRLF
	cQuery += "     B6_FILIAL   	= D2_FILIAL                                           				"+CRLF
	cQuery += "     AND B6_DOC      = D2_DOC                                              				"+CRLF
	cQuery += "     AND B6_SERIE    = D2_SERIE                                            				"+CRLF
	cQuery += "     AND B6_PRODUTO  = D2_COD                                              				"+CRLF
	cQuery += "     AND B6_IDENT    = D2_IDENTB6                                          				"+CRLF
	cQuery += "     AND %SB6.NOTDEL%                                                      				"+CRLF
	cQuery += "                                                                           				"+CRLF
	cQuery += " WHERE                                                                     				"+CRLF
	cQuery += "     %SD2.XFILIAL%                                                         				"+CRLF
	cQuery += "     AND %SD2.NOTDEL%                                                      				"+CRLF
//	cQuery += " 	AND D2_COD 			= '663820'                                        				"+CRLF
	cQuery += " 	AND D2_EMISSAO		<= '"+dToS(dDataAte)+"'                           				"+CRLF
	cQuery += "     AND B6_DOC IS NULL                                                    				"+CRLF
	cQuery += " ORDER BY D2_EMISSAO,D2_DOC, D2_SERIE, D2_ITEM                             				"+CRLF
	
	If lProc
		oSql := IpSqlObject():newIpSqlObject()
		
		oSql:newAlias(cQuery)
		oSql:setField("D2_EMISSAO", "D")
		
		cAlias := oSql:getAlias()
	EndIf
	
Return (cQuery)                                                                      

/*
** Com saldo no 
*/
Static Function qrySugIgual(cProduto, nQuant, nPreco, cCliente, cLoja, dEmissao)
	Local cQuery := ""

	cQuery += " SELECT B6_DOC, B6_SERIE, B6_EMISSAO, B6_DTDIGIT, B6_IDENT, B6_PRODUTO, B6_SALDO, B6_PRUNIT, D1_ITEM, D1_VUNIT, SB6BKP.R_E_C_N_O_  REC"+CRLF
	cQuery += " FROM SB6BKP                                                                       		 "+CRLF
	cQuery += " INNER JOIN %SD1.SQLNAME% ON                                                              "+CRLF
	cQuery += "     D1_FILIAL           = B6_FILIAL                                                      "+CRLF
	cQuery += "     AND D1_DOC          = B6_DOC                                                         "+CRLF
	cQuery += "     AND D1_SERIE        = B6_SERIE                                                       "+CRLF
	cQuery += "     AND D1_FORNECE      = B6_CLIFOR                                                      "+CRLF
	cQuery += "     AND D1_LOJA	        = B6_LOJA	                                                     "+CRLF
	cQuery += "     AND D1_COD          = B6_PRODUTO                                                     "+CRLF
	cQuery += "     AND D1_IDENTB6      = B6_IDENT                                                       "+CRLF
	cQuery += "     AND %SD1.NOTDEL%                                                                     "+CRLF
	cQuery += " WHERE                                                                                    "+CRLF
	cQuery += " 	SB6BKP.B6_FILIAL 	= '%SB6.FILIAL%'                                                 "+CRLF
	cQuery += " 	AND B6_PRODUTO		=  '" + cProduto + "'                                            "+CRLF
	cQuery += " 	AND B6_PRUNIT		=  " + Str(nPreco) + "                                           "+CRLF
	cQuery += " 	AND B6_SALDO 		>= " + Str(nQuant) + "                                           "+CRLF
	cQuery += " 	AND B6_DTDIGIT 		<= '" + Dtos(dEmissao) + "' 									 "+CRLF 
	cQuery += " 	AND B6_CLIFOR 		= '" + cCliente + "'			                                 "+CRLF
	cQuery += " 	AND B6_LOJA 		= '" + cLoja + "'			                                     "+CRLF
	cQuery += " 	AND B6_TPCF 		= 'C'				                                             "+CRLF
	cQuery += " 	AND B6_PODER3 		= 'R'				                                             "+CRLF
	cQuery += " 	AND SB6BKP.D_E_L_E_T_ = ' '                                                          "+CRLF
	cQuery += " ORDER BY 1,2,3,4,5, SB6BKP.B6_DTDIGIT, SB6BKP.B6_IDENT                                   "+CRLF
	
Return (cQuery)


/*
** Com saldo no 
*/
Static Function qrySugMaior(cProduto, nQuant, nPreco, cCliente, cLoja, dEmissao)
	Local cQuery := ""

	cQuery += " SELECT B6_DOC, B6_SERIE, B6_EMISSAO, B6_DTDIGIT, B6_IDENT, B6_PRODUTO, B6_SALDO, B6_PRUNIT, D1_ITEM, D1_VUNIT, SB6BKP.R_E_C_N_O_  REC"+CRLF
	cQuery += " FROM SB6BKP                                                                       		 "+CRLF
	cQuery += " INNER JOIN %SD1.SQLNAME% ON                                                              "+CRLF
	cQuery += "     D1_FILIAL           = B6_FILIAL                                                      "+CRLF
	cQuery += "     AND D1_DOC          = B6_DOC                                                         "+CRLF
	cQuery += "     AND D1_SERIE        = B6_SERIE                                                       "+CRLF
	cQuery += "     AND D1_FORNECE      = B6_CLIFOR                                                      "+CRLF
	cQuery += "     AND D1_LOJA	        = B6_LOJA	                                                     "+CRLF
	cQuery += "     AND D1_COD          = B6_PRODUTO                                                     "+CRLF
	cQuery += "     AND D1_IDENTB6      = B6_IDENT                                                       "+CRLF
	cQuery += "     AND %SD1.NOTDEL%                                                                     "+CRLF
	cQuery += " WHERE                                                                                    "+CRLF
	cQuery += " 	SB6BKP.B6_FILIAL 	= '%SB6.FILIAL%'                                                 "+CRLF
	cQuery += " 	AND B6_PRODUTO		=  '" + cProduto + "'                                            "+CRLF
	cQuery += " 	AND B6_PRUNIT		>  " + Str(nPreco) + "                                           "+CRLF
	cQuery += " 	AND B6_SALDO 		>= " + Str(nQuant) + "                                           "+CRLF
	cQuery += " 	AND B6_CLIFOR 		= '" + cCliente + "'			                                 "+CRLF
	cQuery += " 	AND B6_DTDIGIT 		<= '" + Dtos(dEmissao) + "' 									 "+CRLF
	cQuery += " 	AND B6_LOJA 		= '" + cLoja + "'			                                     "+CRLF
	cQuery += " 	AND B6_TPCF 		= 'C'				                                             "+CRLF
	cQuery += " 	AND B6_PODER3 		= 'R'				                                             "+CRLF
	cQuery += " 	AND SB6BKP.D_E_L_E_T_ = ' '                                                          "+CRLF
	cQuery += " ORDER BY 1,2,3,4,5, SB6BKP.B6_DTDIGIT, SB6BKP.B6_IDENT                                   "+CRLF
	
Return (cQuery)


/*
** Com saldo no 
*/
Static Function qrySugMenor(cProduto, nQuant, nPreco, cCliente, cLoja, dEmissao)
	Local cQuery := ""

	cQuery += " SELECT B6_DOC, B6_SERIE, B6_EMISSAO, B6_DTDIGIT, B6_IDENT, B6_PRODUTO, B6_SALDO, B6_PRUNIT, D1_ITEM, D1_VUNIT, SB6BKP.R_E_C_N_O_  REC"+CRLF
	cQuery += " FROM SB6BKP                                                                       		 "+CRLF
	cQuery += " INNER JOIN %SD1.SQLNAME% ON                                                              "+CRLF
	cQuery += "     D1_FILIAL           = B6_FILIAL                                                      "+CRLF
	cQuery += "     AND D1_DOC          = B6_DOC                                                         "+CRLF
	cQuery += "     AND D1_SERIE        = B6_SERIE                                                       "+CRLF
	cQuery += "     AND D1_FORNECE      = B6_CLIFOR                                                      "+CRLF
	cQuery += "     AND D1_LOJA	        = B6_LOJA	                                                     "+CRLF
	cQuery += "     AND D1_COD          = B6_PRODUTO                                                     "+CRLF
	cQuery += "     AND D1_IDENTB6      = B6_IDENT                                                       "+CRLF
	cQuery += "     AND %SD1.NOTDEL%                                                                     "+CRLF
	cQuery += " WHERE                                                                                    "+CRLF
	cQuery += " 	SB6BKP.B6_FILIAL 	= '%SB6.FILIAL%'                                                 "+CRLF
	cQuery += " 	AND B6_PRODUTO		=  '" + cProduto + "'                                            "+CRLF
	cQuery += " 	AND B6_PRUNIT		<  " + Str(nPreco) + "                                           "+CRLF
	cQuery += " 	AND B6_SALDO 		>= " + Str(nQuant) + "                                           "+CRLF
	cQuery += " 	AND B6_DTDIGIT 		<= '" + Dtos(dEmissao) + "' 									 "+CRLF
	cQuery += " 	AND B6_CLIFOR 		= '" + cCliente + "'			                                 "+CRLF
	cQuery += " 	AND B6_LOJA 		= '" + cLoja + "'			                                     "+CRLF
	cQuery += " 	AND B6_TPCF 		= 'C'				                                             "+CRLF
	cQuery += " 	AND B6_PODER3 		= 'R'				                                             "+CRLF
	cQuery += " 	AND SB6BKP.D_E_L_E_T_ = ' '                                                          "+CRLF
	cQuery += " ORDER BY 1,2,3,4,5, SB6BKP.B6_DTDIGIT, SB6BKP.B6_IDENT                                   "+CRLF
	
Return (cQuery)


/*
** Com saldo no 
*/
Static Function qrySaldo(cProduto, nQuant, nPreco, cCliente, cLoja, dEmissao)
	Local cQuery := ""

	cQuery += " SELECT B6_PRODUTO, SUM(B6_SALDO) SALDO, AVG(D1_VUNIT) PRECO_MEDIO   "+CRLF
	cQuery += " FROM  SB6BKP SB6                                  "+CRLF
	cQuery += " INNER JOIN %SD1.SQLNAME% ON                       "+CRLF
	cQuery += "         D1_FILIAL       = B6_FILIAL               "+CRLF
	cQuery += "     AND D1_IDENTB6      = B6_IDENT                "+CRLF
	cQuery += "     AND %SD1.NOTDEL% 		                  	  "+CRLF
	cQuery += " INNER JOIN %SF4.SQLNAME% ON                       "+CRLF
	cQuery += "         F4_FILIAL       = D1_FILIAL               "+CRLF
	cQuery += "     AND F4_CODIGO       = D1_TES                  "+CRLF
	cQuery += "     AND %SF4.NOTDEL%                     		  "+CRLF
	cQuery += " WHERE                                             "+CRLF
	cQuery += "     SB6.B6_FILIAL 	= '%SB6.FILIAL%'              "+CRLF
	cQuery += "     AND B6_TPCF         = 'C'                     "+CRLF
	cQuery += "     AND B6_PODER3       = 'R'                     "+CRLF
	cQuery += "     AND B6_TIPO         = 'D'                     "+CRLF
	cQuery += "     AND B6_PRODUTO      = '" + cProduto + "'      "+CRLF
//	cQuery += "     AND B6_SALDO        > " + Str(nQuant) + "     "+CRLF
	cQuery += "     AND B6_SALDO        > 0					      "+CRLF
	cQuery += " 	AND B6_DTDIGIT 		<= '" + Dtos(dEmissao) + "'"+CRLF
	cQuery += "     AND B6_CLIFOR       = '" + cCliente + "'      "+CRLF
	cQuery += "     AND B6_LOJA         = '" + cLoja + "'         "+CRLF
	cQuery += "     AND SB6.D_E_L_E_T_  = ' '                     "+CRLF
	cQuery += " GROUP BY B6_PRODUTO                               "+CRLF
	
Return (cQuery)


/*
** Com saldo no 
*/
Static Function qryNfsSaldo(cProduto, nQuant, nPreco, cCliente, cLoja, dEmissao)
	Local cQuery := ""

	cQuery += " SELECT B6_DOC, B6_SERIE, B6_EMISSAO, B6_DTDIGIT, B6_IDENT, B6_PRODUTO, B6_SALDO, B6_PRUNIT, D1_ITEM, D1_VUNIT, SB6BKP.R_E_C_N_O_ REC"+CRLF
	cQuery += " FROM  SB6BKP SB6BKP                               "+CRLF
	cQuery += " INNER JOIN %SD1.SQLNAME% ON                       "+CRLF
	cQuery += "         D1_FILIAL       = B6_FILIAL               "+CRLF
	cQuery += "     AND D1_IDENTB6      = B6_IDENT                "+CRLF
	cQuery += "     AND %SD1.NOTDEL% 		                  	  "+CRLF
	cQuery += " INNER JOIN %SF4.SQLNAME% ON                       "+CRLF
	cQuery += "         F4_FILIAL       = D1_FILIAL               "+CRLF
	cQuery += "     AND F4_CODIGO       = D1_TES                  "+CRLF
	cQuery += "     AND %SF4.NOTDEL%                     		  "+CRLF
	cQuery += " WHERE                                             "+CRLF
	cQuery += "     SB6BKP.B6_FILIAL 	= '%SB6.FILIAL%'          "+CRLF
	cQuery += "     AND B6_TPCF         = 'C'                     "+CRLF
	cQuery += "     AND B6_PODER3       = 'R'                     "+CRLF
	cQuery += "     AND B6_TIPO         = 'D'                     "+CRLF
	cQuery += "     AND B6_PRODUTO      = '" + cProduto + "'      "+CRLF
	cQuery += "     AND B6_SALDO        > 0     				  "+CRLF
	cQuery += " 	AND B6_DTDIGIT 		<= '" + Dtos(dEmissao) + "'"+CRLF
	cQuery += "     AND B6_CLIFOR       = '" + cCliente + "'      "+CRLF
	cQuery += "     AND B6_LOJA         = '" + cLoja + "'         "+CRLF
	cQuery += "     AND SB6BKP.D_E_L_E_T_  = ' '                  "+CRLF
	cQuery += " ORDER BY 1,2,3,4,5, SB6BKP.B6_DTDIGIT, SB6BKP.B6_IDENT                                   "+CRLF
	
Return (cQuery)


Static Function copytoSB6()
	local nI := 1
	local aEstru 	:= {}
	Local cQuery	:= ""
	local cCampos 	:= retCampos()
	Local oSqlTab	:= IpSqlObject():newIpSqlObject()
	
	dbselectarea("SB6")
	aEstru := SB6->(dbstruct())
 
	IF TCCanOpen("SB6BKP")
		TCDelFile("SB6BKP")
	endIf
  
	cAliasTmp:= dbcreate("SB6BKP",aEstru,"TOPCONN")
	DbUseArea(.T.,"TOPCONN","SB6BKP","SB6BKP")
	SB6BKP->(dbsetorder(0))
	SB6BKP->(dbGoTop())
 
	SET DELETED OFF
//	oSqlTab:newAlias("SELECT * FROM %SB6.SQLNAME% WHERE     B6_FILIAL = '149AG2014901'     AND B6_SALDO > 0     AND B6_TPCF = 'C' AND B6_PRODUTO = '663820'    AND %SB6.NOTDEL% ORDER BY B6_DOC, B6_SERIE, B6_EMISSAO, B6_IDENT")
	oSqlTab:newAlias("SELECT * FROM %SB6.SQLNAME% WHERE     B6_FILIAL = '149AG2014901'     AND B6_SALDO > 0     AND B6_TPCF = 'C'   AND %SB6.NOTDEL% ORDER BY B6_DOC, B6_SERIE, B6_EMISSAO, B6_IDENT")
	while oSqlTab:notIsEof()
		cQuery := "INSERT INTO " + "SB6BKP" + " ( " + cCampos + ", D_E_L_E_T_, R_E_C_N_O_  ) SELECT "+ cCampos+", D_E_L_E_T_, R_E_C_N_O_  FROM "+retSqlName("SB6")+" WHERE R_E_C_N_O_ = "+cValToChar(oSqlTab:getValue("R_E_C_N_O_"))+" "
  
		cRet := TcSqlExec(cQuery)
  
		oSqlTab:Skip()
	endDo
	SET DELETED ON
	oSqlTab:close()
return


/*
* Função responsável pelo retorno dos campos da tabela
*/
static function retCampos()
	local nI  := 0
	local aCampos := SB6->(dbStruct())
	local cCampos := ""
 
	for nI := 1 To Len(aCampos)
		cCampos += aCampos[nI][1]
		if nI <> len(aCampos)
			cCampos += ', '
		endIf
	next nI
return (cCampos)


Static Function copytoSD2()
	local nI := 1
	local aEstru 	:= {}
	Local cQuery	:= ""
	local cCampos 	:= retCpsSd2()
	Local oSqlTab	:= IpSqlObject():newIpSqlObject()
	
	dbselectarea("SD2")
	aEstru := SD2->(dbstruct())
 
	IF TCCanOpen("SD2BKP")
		TCDelFile("SD2BKP")
	endIf
  
	cAliasTmp:= dbcreate("SD2BKP",aEstru,"TOPCONN")
	DbUseArea(.T.,"TOPCONN","SD2BKP","SD2BKP")
	SB6BKP->(dbsetorder(0))
	SB6BKP->(dbGoTop())
 
	SET DELETED OFF
	oSqlTab:newAlias(retSd2(dDataAte))
	while oSqlTab:notIsEof()
		cQuery := "INSERT INTO " + "SD2BKP" + " ( " + cCampos + ", D_E_L_E_T_, R_E_C_N_O_  ) SELECT "+ cCampos+", D_E_L_E_T_, R_E_C_N_O_  FROM "+retSqlName("SD2")+" WHERE R_E_C_N_O_ = "+cValToChar(oSqlTab:getValue("RECSD2"))+" "
  
		cRet := TcSqlExec(cQuery)
  
		oSqlTab:Skip()
	endDo
	SET DELETED ON
	oSqlTab:close()
return


/*
* Função responsável pelo retorno dos campos da tabela
*/
static function retCpsSd2()
	local nI  := 0
	local aCampos := SD2->(dbStruct())
	local cCampos := ""
 
	for nI := 1 To Len(aCampos)
		cCampos += aCampos[nI][1]
		if nI <> len(aCampos)
			cCampos += ', '
		endIf
	next nI
return (cCampos)


/**
 * Cria as Seções do Relatório
 */
static function criaSecoes()
	
	local lEndSection 	:= .F.
	local lEndReport  	:= .F.
	local bFormula		:= nil
		
	oSecDados := TRSection():new(oReport)
	TRCell():new(oSecDados, "D2_DOC", 		cALias, "Documento", 				nil, 							TamSX3("D2_DOC")[1])
	TRCell():new(oSecDados, "D2_SERIE", 	cALias, "Série", 					nil, 							TamSX3("D2_SERIE")[1])
	TRCell():new(oSecDados, "D2_ITEM", 		cALias, "Item", 					nil, 							TamSX3("D2_ITEM")[1])
	TRCell():new(oSecDados, "D2_EMISSAO", 	cALias, "Emissão", 					PesqPict("SD2", "D2_EMISSAO"),	TamSX3("D2_EMISSAO")[1])
	TRCell():new(oSecDados, "D2_IDENTB6", 	cALias, "IdentB6", 					nil, 							TamSX3("D2_IDENTB6")[1])
	TRCell():new(oSecDados, "D2_COD", 		cALias, "Produto", 					nil, 							TamSX3("D2_COD")[1])
	TRCell():new(oSecDados, "D2_NFORI", 	cALias, "NF Ref.",					nil, 							TamSX3("D2_NFORI")[1])
	TRCell():new(oSecDados, "D2_SERIORI", 	cALias, "Serie NF Ref", 			nil, 							TamSX3("D2_SERIORI")[1])
	TRCell():new(oSecDados, "D2_ITEMORI",	cALias, "Item Nf Ref", 				nil, 							TamSX3("D2_ITEMORI")[1] )
	TRCell():new(oSecDados, "D2_QUANT", 	cALias, "Quantidade", 				nil, 							TamSX3("D2_QUANT")[1])
	TRCell():new(oSecDados, "D2_PRCVEN", 	cALias, "Preço", 					PesqPict("SD2", "D2_PRCVEN"), 	TamSX3("D2_PRCVEN")[1],,,,,"RIGHT")
	TRCell():new(oSecDados, "D2_TOTAL", 	cALias, "Total", 					PesqPict("SD2", "D2_TOTAL"), 	TamSX3("D2_TOTAL")[1],,,,,"RIGHT")
	TRCell():new(oSecDados, "B6_DOC", 		cALias, "Doc. Sugerido", 			nil, 							TamSX3("B6_DOC")[1])
	TRCell():new(oSecDados, "B6_SERIE", 	cALias, "Série Doc Sugerido", 		nil, 							TamSX3("B6_SERIE")[1])
	TRCell():new(oSecDados, "D1_ITEM", 		cALias, "Item Doc Sugerido", 		nil, 							TamSX3("D1_ITEM")[1])
	TRCell():new(oSecDados, "B6_EMISSAO", 	cALias, "Emissão Doc. Sugerido", 	PesqPict("SB6", "B6_EMISSAO"),	TamSX3("B6_EMISSAO")[1])
	TRCell():new(oSecDados, "B6_DTDIGIT", 	cALias, "Dt. Entrada Doc. Sugerido",PesqPict("SB6", "B6_DTDIGIT"),	TamSX3("B6_DTDIGIT")[1])
	TRCell():new(oSecDados, "B6_IDENT", 	cALias, "IdentB6 Doc. Sugerido", 	nil, 							TamSX3("B6_IDENT")[1])
	TRCell():new(oSecDados, "B6_PRODUTO", 	cALias, "Produto Doc. Sugerido", 	nil, 							TamSX3("B6_PRODUTO")[1])
	TRCell():new(oSecDados, "B6_SALDO", 	cALias, "Saldo Doc. Sugerido", 		nil, 							TamSX3("B6_SALDO")[1])
	TRCell():new(oSecDados, "D1_VUNIT", 	cALias, "Preço Doc. Sugerido", 		PesqPict("SD2", "D2_PRCVEN"), 	TamSX3("D1_VUNIT")[1],,,,,"RIGHT")
	TRCell():new(oSecDados, "DIFUNIT", 		cALias, "Diferença Unit. de R$",	PesqPict("SD2", "D2_PRCVEN"), 	TamSX3("A1_NOME")[1],,,,,"RIGHT")
	TRCell():new(oSecDados, "DIFTOTAL",		cALias, "Diferença Total de R$",	PesqPict("SD2", "D2_PRCVEN"), 	TamSX3("A1_NOME")[1],,,,,"RIGHT")
	TRCell():new(oSecDados, "COND", 		cALias, "Condição", 				nil, 							TamSX3("A1_NOME")[1])
	TRCell():new(oSecDados, "ATUALIZ", 		cALias, "Atualizado?", 				nil, 							TamSX3("A1_NOME")[1])
	
	
return


/**
 * Leitura dos parâmetros
 */
static function getParams()
	
	local oParam := nil
	
	oParamBox:setTitle(cTitulo)
	
	oParam := IpParamObject():newIpParamObject("dataAte", "get", "Data Ate", "D", 60, TamSX3("F2_EMISSAO")[1])
	oParam:setRequired(.T.)
	oParamBox:addParam(oParam)
	
	
return oParamBox:show()