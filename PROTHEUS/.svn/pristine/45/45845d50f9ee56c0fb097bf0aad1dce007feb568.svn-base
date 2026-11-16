#Include 'Protheus.ch'


#Define OP 			1
#Define COD			2
#Define D3LOCAL		3
#Define NUMSEQ		4
#Define QUANTIDADE 	5
#Define NUMDOC		6
#Define CHAVE		7
#Define D3RECNO 	8
#Define ESTORNO		5

/*/{Protheus.doc} MulBkNegativAdjust

Rotina que realiza o ajuste negativo do BackFlush

@author Gustavo Luiz
@since 14/02/2017
/*/
User Function MulBkNegativAdjust(oDHLBackFlush)
	
	Local aApontProducao		:= {}
	Local nI					:= 0
	Local aEstornaApontamento	:= {}
	Local nQtdASerApon			:= 0
	Local nQtdApontado			:= 0
	Local nQtdUltmApont			:= 0
	Local nSaldo				:= 0
	
	If oDhlBAckFlush:GetQtyBom() > 0
		
		aApontProducao := GetApontProducao(oDHLBackFlush:GetSubLote(), oDHLBackFlush:GetProjectID())
		
		If Len(aApontProducao) > 0
		
			If ExistSaldo(aApontProducao, oDHLBackFlush)
			
				Begin Transaction
			
					oDHLBackFlush:SetQuantPaNegativ(oDHLBackFlush:GetQtyBom()) //GUARDA A QUANTIDADE ORIGINAL DO PA QUE VEIO DA INTERFACE
				
					For nI := 1 To Len(aApontProducao)
						
						nQtdUltmApont	:= aApontProducao[nI][QUANTIDADE]
					
						If nQtdUltmApont >= oDHLBackFlush:GetQtyBom()
						
							nSaldo := nQtdUltmApont - oDHLBackFlush:GetQtyBom()
							
							oDHLBackFlush:SetQtyBom(nQtdUltmApont)
							oDHLBackFlush:SetOrdemProducao(aApontProducao[nI][OP])
							EstornaConsumo(aApontProducao[nI], oDHLBackFlush)
							EstornaApontamento(aApontProducao[nI], oDHLBackFlush)
							
							//SÓ REQUISITA E APONTA CASO TENHA QUANTIDADE: SALDO > 0
							If nSaldo > 0
							
								oDHLBackFlush:SetQtyBom(nSaldo)
								CalculaProporInsumos(oDHLBackFlush, nQtdUltmApont)
								oDHLBackFlush:SetExistMOD(.F.)
								If !oDHLBackFlush:HasErroOperacao()
									oDHLBackFlush:GeraConsumo()
									oDHLBackFlush:ApontProducao()
								Else
									DisarmTransaction()
									oDHLBackFlush:SetFileLog(oDHLBackFlush:GetFilePath(),"fail","Falha processar ajuste negativo"+CRLF+CRLF+oDHLBackFlush:GetErrorMsg())
									exit
								EndIf
							
							EndIf
							
							exit
							
						ElseIf nQtdUltmApont < oDHLBackFlush:GetQtyBom()
								
							nSaldo := oDHLBackFlush:GetQtyBom() - nQtdUltmApont
							
							oDHLBackFlush:SetQtyBom(nQtdUltmApont)
							oDHLBackFlush:SetOrdemProducao(aApontProducao[nI][OP])
							EstornaConsumo(aApontProducao[nI], oDHLBackFlush)
							If oDHLBackFlush:HasErroOperacao()								
								exit
							EndIf
							
							EstornaApontamento(aApontProducao[nI], oDHLBackFlush)
							oDHLBackFlush:SetQtyBom(nSaldo)
						
						EndIf
					
					Next nI
					
					If oDHLBackFlush:HasErroOperacao()
					
						DisarmTransaction()
						oDHLBackFlush:SetFileLog(oDHLBackFlush:GetFilePath(),"fail","Falha processar ajuste negativo"+CRLF+CRLF+ oDHLBackFlush:GetMsgErro())
						oDHLBackFlush:SetErroOperacao(.T.)
				
					EndIf
					
				End Transaction
			
			Else
			
				DisarmTransaction()
				oDHLBackFlush:SetFileLog(oDHLBackFlush:GetFilePath(),"fail","Falha ao apontar a Ordem de Produção"+CRLF+CRLF+"Não há saldo suficiente para realizar o ajuste negativo. SUBLOTE = " + oDHLBackFlush:GetSubLote() + " e PROJECT_ID = " + oDHLBackFlush:GetProjectID())
				oDHLBackFlush:SetErroOperacao(.T.)
			
			EndIf
		Else
			DisarmTransaction()
			oDHLBackFlush:SetFileLog(oDHLBackFlush:GetFilePath(),"fail","Falha ao ajustar a Ordem de Produção"+CRLF+CRLF+"Não há saldo suficiente para realizar o ajuste negativo. SUBLOTE = " + oDHLBackFlush:GetSubLote() + " e PROJECT_ID = " + oDHLBackFlush:GetProjectID())
			oDHLBackFlush:SetErroOperacao(.T.)
		EndIf
	
	Else
	
		oDHLBackFlush:SetFileLog(oDHLBackFlush:GetFilePath(),"fail","Falha processar ajuste negativo"+CRLF+CRLF+"Não possu saldo suficiente para realizar o ajuste negativo. SUBLOTE = " + oDHLBackFlush:GetSubLote() + " e PROJECT_ID = " + oDHLBackFlush:GetProjectID())
		oDHLBackFlush:SetErroOperacao(.T.)
	
	EndIf
	
Return

/**
* Verifica se existe saldo suficiente para o ajuste negativo
**/
Static Function ExistSaldo(aApontProducao, oDHLBackFlush)
	
	Local nI 			:= 0
	Local nQtdAjuste	:= oDHLBackFlush:GetQtyBom()
	Local nSaldo		:= 0
	Local lStatus		:= .F.
	
	For nI := 1 To Len(aApontProducao)
		nSaldo += aApontProducao[nI][5]
	Next nI
	
	If nSaldo >= nQtdAjuste
		
		lStatus := .T.
		
	EndIf

Return lStatus

/**
* Calcula a proporcionalidade dos insumos
	POSIÇÃO INSUMOS. ARRAY ALIMENTADO PELA FUNÇÃO DHLBACKFLUSH - GetInsumos()
	INSUMOS[1]   - D3_TIPO
	INSUMOS[2]   - D3_FILIAL
	INSUMOS[3]   - D3_COD
	INSUMOS[4]   - D3_TM
	INSUMOS[5]   - D3_DOC
	INSUMOS[6]   - D3_QUANT
	INSUMOS[7]   - D3_OP
	INSUMOS[8]   - D3_LOCAL
	INSUMOS[9]   - D3_DOC
	INSUMOS[10]  - D3_EMISSAO
	INSUMOS[11]  - D3_NUMSEQ
	INSUMOS[12]  - D3_CHAVE
	INSUMOS[13]  - D3_LOTECTL
	INSUMOS[14]  - R_E_C_N_O_
	INSUMOS[15]  - D3_UM
	INSUMOS[16]  - D3_DTVALID		
	
	POSIÇÃO AITENS. ARRAY ALIMENTADO QUANDO FAZ A LEITURA DO XML READBKFLUSH - LoadDadosXML()	
	
	AITENS[1] - EXPIRATION DATE
	AITENS[2] - ITEM
	AITENS[3] - LOT
	AITENS[4] - QUANTITY
	AITENS[5] - UOM
	
**/
Static Function CalculaProporInsumos(oDHLBackFlush, nQtdUltmApont)
	
	Local aInsumos 		:= aClone(oDHLBackFlush:GetInsumos())
	Local aItens		:= {}
	Local nQuantInsu	:= 0
	Local nQuantNovaPA	:= oDHLBackFlush:GetQtyBom()
	Local nNovaProporc  := 0
	Local cProduto		:= ""
	Local lIsProporcion	:= .F.
		
	For nI := 1 To Len(aInsumos)
		
		cProduto			:= aInsumos[nI][3]
		nQuantInsu 			:= aInsumos[nI][6]
		nNovaProporc   		:= (nQuantNovaPA * nQuantInsu)/nQtdUltmApont
		aInsumos[nI][6]   	:= nNovaProporc
		lIsProporcion		:= .T.		
		
		If lIsProporcional
		
		//			  			EXPIRATION DATE       ITEM               LOT            QUANTITY              UOM
			aAdd(aItens, {sTod(aInsumos[nI][16]), aInsumos[nI][3], aInsumos[nI][13], aInsumos[nI][6], aInsumos[nI][15]})
			
		ElseIf !("MOD" $ aInsumos[nI][3]) .AND. !(aInsumos[nI][15] == "HR")
				
			oDHLBackFlush:SetErrorMsg("Quantidade do insumo " + AllTrim(aInsumos[nI][3]) + " não esta proporcional. Quantidade insumo interface: " + cValToChar(nQuantInsu) + ". Quantidade proporcionalmente correta: " + cValToChar(nNovaProporc))
			oDHLBackFlush:SetErroOperacao(.T.)
			exit
					
		EndIf
		
		If "MOD" $ aInsumos[nI][3] .AND. aInsumos[nI][15] == "HR"
			oDHLBackFlush:SetExistMOD(.T.)
		EndIf
		
	Next nI
	
	oDHLBackFlush:SetItens(aItens)
	oDHLBackFlush:SetInsumos(aInsumos)
	
Return

/**
* Verifica se a proporcionalidade esta correta com a interface
**/
Static Function IsProporcional(oDHLBackFlush, cProduto, nQuantNovaPA, nNovaProporc)

	Local aItens 			:= oDHLBackFlush:GetItens()
	Local nQuantPAInterface	:= oDHLBackFlush:GetQuantPaNegativ()
	Local nQuantInsInterface:= 0
	Local nPos	 			:= 0
	Local nProporInterface	:= 0
	Local lStatus			:= .F.	
	
	nPos := aScan(aItens, {|x| Upper(Alltrim(cProduto)) == Upper(Alltrim(x[2]))})
	
	If nPos != 0
	
		nQuant 			 := Val(aItens[nI][4])
		nProporInterface := (nQuantNovaPA * nQuant) / nQuantPAInterface
		
		If nNovaProporc ==  nProporInterface
			lStatus := .T.
		EndIf
		
	EndIf

Return lStatus


/**
* Verifica se a OP esta encerrada
**/
Static Function IsOpEncerrada(cOP)
	
	Local cQuery 		:= ""
	Local oSql			:= ipSqlObject():newIpSqlObject()
	Local lIsOpEncerrada:= .F.
	
	cQuery += " SELECT *	"                  			 				 +CRLF
	cQuery += " FROM %SC2.SQLNAME%"                   					 +CRLF
	cQuery += " WHERE C2_FILIAL = '%SC2.FILIAL%' AND" 					 +CRLF
	cQuery += " C2_NUM  || C2_ITEM || C2_SEQUEN  = '" + cOP + "' AND" 	 +CRLF
	cQuery += " %SC2.NOTDEL%"                   		 				 +CRLF
	
	oSql:newAlias(cQuery)
	
	If !Empty(oSql:getValue("C2_DATRF"))
		lIsOpEncerrada := .T.
	EndIf
	
	oSql:Close()
	
Return lIsOpEncerrada

/**
* Estorna apontamento
**/
Static Function EstornaConsumo(aApontProducao, oDHLBackFlush)
	
	oDHLBackFlush:EstornaConsumo(aApontProducao)
	
	If oDHLBackFlush:HasError()
		
		oDHLBackFlush:SetErroOperacao(.T.)
		
	EndIf
	
Return

/**
* Estorna apontamento
**/
Static Function EstornaApontamento(aApontProducao, oDHLBackFlush)
	
	Local aStructApont 		:= {}
	
	oDHLBackFlush:EstornaApontamento(aApontProducao)
	
	If oDHLBackFlush:HasError()
		
		oDHLBackFlush:SetErroOperacao(.T.)
		
	EndIf
	
Return

/**
*Retorna a estrutura do apontamento
**/
static function EstrutApont(aApontProducao)
	
	local aArray := {}
	
	aArray:=   {{"D3_OP",aApontProducao[OP]			,Nil},;
		{"D3_COD",		aApontProducao[COD]			,Nil},;
		{"D3_LOCAL",	aApontProducao[D3LOCAL]		,Nil},;
		{"D3_DOC",	aApontProducao[NUMDOC]			,Nil},;
		{"D3_NUMSEQ",	aApontProducao[NUMSEQ]		,Nil},;
		{"D3_QUANT",	aApontProducao[QUANTIDADE]	,Nil},;
		{"INDEX",	4								,Nil}}
	
	
return aClone(aArray)

/**
* Retorna os apontamentos para a ordem de produção em questão
**/
Static Function GetApontProducao(cPalletID, cNumProjeto)
	
	Local cQuery 		:= ""
	Local oSql			:= ipSqlObject():newIpSqlObject()
	Local aApontProduc	:= {}
	
	cQuery := RunQueryApontProd(cPalletID, cNumProjeto)
	
	oSql:newAlias(cQuery)
	
	If oSql:hasRecords()
		while oSql:notIsEof()
			aAdd(aApontProduc, {oSql:getValue("D3_OP"), oSql:getValue("D3_COD"), oSql:getValue("D3_LOCAL") ,oSql:getValue("D3_NUMSEQ"), oSql:getValue("D3_QUANT"), oSql:getValue("D3_DOC") , oSql:getValue("D3_CHAVE") , oSql:getValue("R_E_C_N_O_"), oSql:getValue("D3_ZZPALLET"), oSql:getValue("D3_ZZDOCBK") })
			oSql:skip()
		EndDo
	Endif
	
	oSql:Close()
	
Return aApontProduc

/**
* Obtém a query apontamento de produção
**/
Static Function RunQueryApontProd(cPalletID, cNumProjeto)
	
	Local cQuery 		:= ""
	Local oSql			:= ipSqlObject():newIpSqlObject()
	Local lExiste		:= .F.
	Local aApontProduc 	:= {}
	
	cQuery += " SELECT *	"                  			 				 +CRLF
	cQuery += " FROM %SD3.SQLNAME%"                   					 +CRLF
	cQuery += " WHERE D3_FILIAL = '%SD3.FILIAL%' AND" 					 +CRLF
	cQuery += " D3_ZZPALLE = '" + cPalletID + "' AND" 					 +CRLF
	cQuery += " D3_ZZPROJE = '" + cNumProjeto + "' AND" 				 +CRLF
	cQuery += " D3_ESTORNO = ' ' AND" 					 				 +CRLF
	cQuery += " D3_PARCTOT != 'T' AND" 					 				 +CRLF
	cQuery += " %SD3.NOTDEL%"                   		 				 +CRLF
	cQuery += " ORDER BY D3_OP DESC, R_E_C_N_O_ DESC"                    +CRLF
	oSql:newAlias(cQuery)
	
	MemoWrite("apontamento.txt", oSql:ParseQuery(cQuery))
	
Return cQuery

