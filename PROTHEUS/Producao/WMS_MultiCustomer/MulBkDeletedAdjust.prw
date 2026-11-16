#Include 'Protheus.ch'

/*/{Protheus.doc} MulBkDeletedAdjust

Rotina que realiza o ajuste para quando for um Pallet deletado

@author Gustavo Luiz
@since 17/02/2017
/*/
User Function MulBkDeletedAdjust(oDHLBackFlush)

	Local aApontProducao := {}
	Local nI			 := 0
	
	aApontProducao := GetApontProducao(oDHLBackFlush:GetSubLote(), oDHLBackFlush:GetProjectID())
	
	If Len(aApontProducao) > 0
	
		Begin Transaction
			For nI := 1 To Len(aApontProducao)
				If !Empty(aApontProducao[nI][1])
					EstornaConsumo(aApontProducao[nI], oDHLBackFlush)
					oDHLBackFlush:EstornaApontamento(aApontProducao[nI])
				EndIf
			Next nI
		
			If oDHLBackFlush:HasErroOperacao()
					
				DisarmTransaction()
				oDHLBackFlush:SetFileLog(oDHLBackFlush:GetFilePath(),"fail","Falha ao estornar o apontamento"+CRLF+CRLF+oUtils:getErroAuto())
			
			EndIf
		End Transaction
	
	Else
		oDHLBackFlush:SetFileLog(oDHLBackFlush:GetFilePath(),"fail","Falha ao estornar o apontamento"+CRLF+CRLF+"Não existe Pallet ID (Sublote) correpondente ao número" + oDHLBackFlush:GetSubLote())
	EndIf

Return

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
	
	If !Empty(aApontProducao[1])
	
		oDHLBackFlush:EstornaApontamento(aApontProducao)
	
		If oDHLBackFlush:HasError()
		
			oDHLBackFlush:SetErroOperacao(.T.)
		
		EndIf
	
	EndIf
	
Return

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
			aAdd(aApontProduc, {oSql:getValue("D3_OP"), oSql:getValue("D3_COD"), oSql:getValue("D3_LOCAL") ,oSql:getValue("D3_NUMSEQ"), oSql:getValue("D3_QUANT"), oSql:getValue("D3_DOC") , oSql:getValue("D3_CHAVE") , oSql:getValue("R_E_C_N_O_"), oSql:getValue("D3_ZZPALLE"), oSql:getValue("D3_ZZDOCBK") })
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

