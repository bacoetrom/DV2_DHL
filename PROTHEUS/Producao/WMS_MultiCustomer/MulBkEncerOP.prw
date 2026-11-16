#Include 'Protheus.ch'

/*/{Protheus.doc} MulBkEncerOP

Rotina responável em encerrar uma OP

@author Gustavo Luiz
@since 14/02/2017
/*/
User Function MulBkEncerOP(oDHLBackFlush)

	Local aApontProducao := {}
	Local nI			 := 0
	Local aApontamEncerr := 0
	Local lOk			 := .T.
	
	aApontProducao := oDHLBackFlush:GetApontProducao()
	aApontamEncerr := GetApontamenEncerramen(aApontProducao)
	
	If Len(aApontamEncerr) > 0
	
		Begin Transaction
				oDHLBackFlush:EncerraApontamento(aApontamEncerr[1])
				
				If oDHLBackFlush:HasErroOperacao()
					lOk := .F.
				EndIf
				
			If lOk
			
				For nI := 1 To Len(aApontProducao)
				
				//SE ESTA VAZIO, É PORQUE NÃO HOUVE APONTAMENTO, ENTÃO EXLUI A OP
					If Empty(aApontProducao[1][1])
						oDHLBackFlush:ExcluiOP(aApontProducao[1])
					EndIf
			
				Next nI
			
			EndIf
		
			If oDHLBackFlush:HasErroOperacao()
					
				DisarmTransaction()
				oDHLBackFlush:SetFileLog(oDHLBackFlush:GetFilePath(),"fail","Falha ao encerrar o apontamento "+CRLF+CRLF+oDHLBackFlush:GetMsgErro())
			
			EndIf
		End Transaction
	
	Else
		oDHLBackFlush:SetErroOperacao(.T.)
		oDHLBackFlush:SetFileLog(oDHLBackFlush:GetFilePath(),"fail","Falha ao encerrar o apontamento"+CRLF+CRLF+"Não existe Pallet ID (Sublote) correpondente ao número " + oDHLBackFlush:GetSubLote())
	EndIf

Return

/**
* Obtém os apontamentos a serem encerrados
**/
Static Function GetApontamenEncerramen(aApontProducao)

	Local nI 				:= 0
	Local aApontamEncerr	:= {}
	Local cOp				:= ""
	Local nPos				:= 0
	
	For nI := 1 To Len(aApontProducao)
		
		cOp		:= aApontProducao[nI][1]
		nPos 	:= aScan(aApontamEncerr, {|x| Alltrim(cOp) == AllTrim(x[1])})
		
		If nPos == 0
			//							OP						COD_PROD			LOCAL					NUMSEQ					QUANT				DOC		 				CHAVE 						RECNO				CF						EMISSAO					CC						UM						CONTA					TM						ZZ_PALLE
			aAdd(aApontamEncerr, {aApontProducao[nI][1], aApontProducao[nI][2], aApontProducao[nI][3], aApontProducao[nI][4], aApontProducao[nI][5], aApontProducao[nI][6], aApontProducao[nI][7], aApontProducao[nI][8], aApontProducao[nI][9], aApontProducao[nI][10], aApontProducao[nI][11], aApontProducao[nI][12], aApontProducao[nI][13], aApontProducao[nI][14],  aApontProducao[nI][15] })
		
		EndIf
		
	Next nI
	
	aSort(aApontamEncerr,,, {|x,y| x[8] < y[8]})

Return aApontamEncerr

