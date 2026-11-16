#Include 'Protheus.ch'
#Include "DHL.CH"

#define DHL_CAMPO 		2
#define CGC				2

/*/{Protheus.doc} ValidLinha
Valida a linha se o produto inserido não contém produtos da Pfizer e Wyeth juntos
@author Gustavo Luiz
@since 30/09/2016
@version 1.0
@return ${boolean}, ${caso tenha, retorna .F. senão .T.}
/*/
User Function VldLinha()
	
	Local nPosicaoCampo	:= -1
	Local cCodigoProduto:= ""
	Local lStatus		:= .F.
	
	Private oLog 		:= DHLLogManager():newDHLLogManager()
	Private lJob		:= GetRemoteType() == -1
	
	nPosicaoCampo 	:= GetPosCampo("D1_COD")
	lStatus			:= IsOk(nPosicaoCampo)
	
Return lStatus

/**
* verifica se existe produtos de diferentes clientes (Pfzer/Wyeth)
**/
Static Function IsOk(nPosicaoCampo)
	local oSqlAux	  := IpSqlObject():newIpSqlObject()	
	Local nI 		:= 0
	Local lStatus	:= .F.
	Local cProduto	:= ""
	Local aRetCliSA7	:= {}		
	Local oDHLAcols		:= DHLAcols():New()
	Local cMensagem		:= ""
	
	For nI:=1 To Len(aCols)
	
		cProduto := aCols[nI][DHL_CAMPO]
		aRetCliSA7 := ExistSA7(cProduto)
	
		If Empty(oDHLAcols:GetCliOficial()) .and. !gdDeleted(nI,,aCols)			
			If Len(aRetCliSA7) == 1
				oDHLAcols:SetCliOficial(aRetCliSA7[1][1])
				lStatus := .T.
			ElseIf Len(aRetCliSA7) == 2
				lStatus := .T.
			Else
				cMensagem := "Produto não amarrado no cadastro Cliente X Produto" 
				GravaLog(cMensagem)
				AVISO("Inconsistência", cMensagem,{"fechar"},1)
				lStatus := .F.
			EndIf		
		Else			
			If Len(aRetCliSA7) == 1 .AND. !gdDeleted(nI,,aCols)			
				If oDHLAcols:GetCliOficial() != aRetCliSA7[1][1]
				
					cMensagem := "Produto não amarrado ao cliente " + oDHLAcols:GetCliOficial()					
					GravaLog(cMensagem)
					AVISO("Inconsistência", cMensagem,{"fechar"},1)					
					lStatus := .F.
					
				EndIF
			ElseIf	Len(aRetCliSA7) == 0 .AND. !gdDeleted(nI,,aCols)
			
				cMensagem := "Produto não amarrado no cadastro Cliente X Produto" 
				GravaLog(cMensagem)
				AVISO("Inconsistência", cMensagem,{"fechar"},1)
				lStatus := .F.
							
			EndIf
						
		EndIf		
	Next nI
	
Return lStatus

/**
* Função que grava no log quando for via Job
**/
Static Function GravaLog(cMensagem)
	
	If lJob
		
		oLog:start(APP_IMPORTADOR_XML, DHL_IMPORTACAO, "ERRO")
		oLog:fail("Falha ao importar arquivo", cMensagem)		
		
	EndIf
	
Return

/**
* Verifica se existe esse produto no cadastro Cliente X Produto
**/
Static Function ExistSA7(cProduto)
	
	Local oSql	  	:= IpSqlObject():newIpSqlObject()	
	Local cQuery	:= ""
	Local aProdutos := {}	
	
	cQuery := " SELECT "                     						+CRLF
	cQuery += "		A1_COD, A1_CGC	"                     			+CRLF
	cQuery += "	FROM "                                				+CRLF
	cQuery += "		%SA7.SQLNAME% "                                	+CRLF
	cQuery += "	INNER JOIN %SA1.SQLNAME% ON "                       +CRLF
	cQuery += "		A1_FILIAL = A7_FILIAL AND "                     +CRLF
	cQuery += "		 (A1_ZZREPRE = ' ' OR A1_ZZREPRE = 'N') AND	"   +CRLF
	cQuery += "		 A1_COD=A7_CLIENTE AND	"                       +CRLF
	cQuery += "		%SA1.NOTDEL%	 "                           	+CRLF
	cQuery += "	 WHERE	"                                    		+CRLF
	cQuery += "		A7_FILIAL = '%SA1.FILIAL%' AND	"               +CRLF
	cQuery += "		A7_PRODUTO = '"+cProduto+"' AND	"               +CRLF
	//cQuery += "		A7_CLIENTE != '000048' AND	"               	+CRLF
	cQuery += "		%SA7.NOTDEL%	"                               +CRLF
	
	oSql:newAlias(cQuery)
	
	while oSql:notIsEof()
		
		aAdd(aProdutos,{oSql:GetValue("A1_COD"),oSql:GetValue("A1_CGC")})
		oSql:skip()
		
	EndDo
	oSql:close()	
	
Return aProdutos

/**
* Obtém a posição do campo no aHeader
**/
Static Function GetPosCampo(cCampo)
	
	Local nPos	:= 0
	
	nPos := aScan(aHeader,{|x| alltrim(x[2]) == cCampo})
	
Return nPos

