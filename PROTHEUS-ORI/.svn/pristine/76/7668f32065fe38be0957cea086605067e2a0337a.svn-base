#Include 'Protheus.ch'

/*/{Protheus.doc} GetPedidoComEspe
Rotina responsável em víncular o documento da pré nota ao pedido de compras retornado do parambox

@author Gustavo Luiz
@since 27/05/2016
@version 1.0
/*/
User Function VincPedidoCompra()
	
	Local	 aArea		 	:= GetArea()
	Local 	 lStatus		:= .T.
	Local   xMV_PAR01		:= MV_PAR01		//necessário para não dar error.log
	Local	 aAreaSD1		:= SD1->(GetArea())
	Local 	 aAreaSC7		:= SC7->(GetArea())
	Local   aAreaSF1		:= SF1->(GetArea())
	Private aRet 			:= {}
	Private cPedidoComp 	:= ""
	Private oSql			:= ipSqlObject():newIpSqlObject()
	Private cClieFor		:= SF1->F1_FORNECE
	Private cBranch			:= SF1->F1_FILIAL
	Private cSerie			:= SF1->F1_SERIE
	Private cNota   		:= SF1->F1_DOC
	Private cLoja   		:= SF1->F1_LOJA
	Private cTipo   		:= SF1->F1_TIPO
	Private cQueryAlias		:= ""
	Private nQtdRegistros	:= 0
	

	If SF1->F1_STATUS == "A"
	
		AVISO("","Nota Fiscal já classificada",{"fechar"},1)
		
	ElseIf Perguntas()
		cPedidoComp:=aRet[1]
		If !empty(cPedidoComp)
			If ExistPedidoCompras(cPedidoComp)
				RunQuery()
				BEGIN TRANSACTION
					BEGIN SEQUENCE
				lStatus:= UpdateTable()
				if !(lStatus)
					BREAK
				Else
					If nQtdRegistros>0 .AND. lStatus
						MsgInfo("Pré-nota "+cNota+ " vinculado com sucesso ao pedido de compras "+cPedidoComp,"")
					ElseIf nQtdRegistros==0
						MsgInfo("Pré-nota "+cNota+ " não vinculado ao pedido de compras nº "+cPedidoComp+". Vínculo existente ao Pedido de Compras "+GetVinculo(),"")
					EndIf
				endif
					RECOVER
						DisarmTransaction()
					END SEQUENCE
				END TRANSACTION
			Else
				MsgInfo("Pedido de Compras "+cPedidoComp+" inexistente","")
			EndIf
		Else
			MsgInfo("Nenhum pedido de compras selecionado","")
		EndIf
		oSql:Close()
	EndIf
	
	SD1->(RestArea(aAreaSD1))
	SC7->(RestArea(aAreaSC7))
	SF1->(RestArea(aAreaSF1))
	RestArea(aArea)
	MV_PAR01 := xMV_PAR01
	
Return

/**
* Função que retorna o pedido que um determinado documento esta vinculado
**/
Static Function GetVinculo()
	Local cPedido:=""
	
	SD1->(DbSetOrder(1))
	If SD1->(DbSeek(xFilial("SD1")+cNota+cSerie+cClieFor+cLoja))
		cPedido := SD1->D1_PEDIDO
	EndIf
	
Return cPedido

/**
* Verifica se existe o pedido de compras
**/
Static Function ExistPedidoCompras(cPedidoComp)
	
	Local lStatus		:= .F.
	Local cPedidoComp := Padr(cPedidoComp,TamSx3("C7_NUM")[1])
	
	SC7->(dbSetOrder(1))
	If SC7->(DbSeek(xFilial("SC7")+cPedidoComp))
		lStatus:=.T.
	EndIf

Return lStatus

/**
* query que retorna os itens do Pedido de compras que serão vinculados a uma pré nota
**/
Static Function RunQuery()

	Local cQuery	:= ""
	/*
	cQuery := " SELECT "													  			+CRLF
	cQuery += " 	SC7.R_E_C_N_O_ SC7_RECNO, SD1.R_E_C_N_O_ SD1_RECNO,  "    			+CRLF
	cQuery += " 	D1_PEDIDO, D1_ITEMPC, D1_QUANT, D1_COD, "  				  			+CRLF
	cQuery += " 	C7_FILIAL, C7_ITEM, C7_QUANT, ISNULL(C7_PRODUTO, ' ') PRODUTO, "	+CRLF
	cQuery += " 	C7_QUJE, C7_QTDACLA, C7_TOTAL, "                          			+CRLF
	cQuery += " 	C7_FORNECE, C7_LOJA, C7_FILENT, C7_NUM, "                 			+CRLF
	cQuery += " 	C7_QUANT-C7_QUJE-C7_QTDACLA SOMASC7 "                     			+CRLF
	*/
	
	cQuery := " SELECT "													  									+CRLF
	cQuery += " 	C7_NUM, C7_ITEM, C7_PRODUTO, C7_QUANT,D1_PEDIDO,  D1_ITEMPC, ISNULL(C7_PRODUTO, ' ') PRODUTO,  "  +CRLF
	cQuery += " 	SD1.R_E_C_N_O_ SD1_RECNO, SC7.R_E_C_N_O_ SC7_RECNO, (C7_QUANT-C7_QUJE-C7_QTDACLA) SALDO, D1_QUANT, D1_DOC, D1_ITEM, D1_DOC, D1_COD  "  +CRLF
	
	
	cQuery += " FROM %SD1.SQLNAME%"                                         			+CRLF
	cQuery += " LEFT JOIN %SC7.SQLNAME% ON "                               				+CRLF
	cQuery += " 	C7_FILIAL=D1_FILIAL "                                 				+CRLF
	cQuery += " 	AND C7_FORNECE=D1_FORNECE "                               			+CRLF
	cQuery += " 	AND C7_ITEM = D1_ITEM "                               			+CRLF
	cQuery += " 	AND C7_PRODUTO=D1_COD "                                   			+CRLF
	cQuery += " 	AND C7_LOJA=D1_LOJA "                                     			+CRLF
	cQuery += " 	AND C7_RESIDUO=' ' "                                      			+CRLF
	cQuery += " 	AND C7_TPOP!='P' "                                        			+CRLF
	cQuery += " 	AND C7_QUANT-C7_QUJE-C7_QTDACLA>0 "                       			+CRLF
	cQuery += " 	AND C7_NUM='"+cPedidoComp+"' "                            			+CRLF
	cQuery += " 	AND SC7.D_E_L_E_T_= ' ' "                                 			+CRLF
	cQuery += " WHERE "                                                     			+CRLF
	cQuery += " 	D1_FILIAL='%SD1.FILIAL%'   "   		    	                		+CRLF
	cQuery += " 	AND (D1_PEDIDO='' AND D1_ITEMPC='') "                     			+CRLF
	cQuery += " 	AND D1_FORNECE='"+cClieFor+"' "                     			    +CRLF
	cQuery += " 	AND D1_DOC='"+cNota+"' "                            		  		+CRLF
	cQuery += " 	AND SD1.D_E_L_E_T_= ' ' "                                 			+CRLF
	
	cQuery += " 	GROUP BY "                                 						+CRLF
	cQuery += " C7_NUM, C7_PRODUTO, C7_QUANT,D1_PEDIDO,  D1_ITEMPC, C7_PRODUTO, " + CRLF
	cQuery += " SD1.R_E_C_N_O_, SC7.R_E_C_N_O_,  D1_QUANT,(C7_QUANT-C7_QUJE-C7_QTDACLA), C7_ITEM, D1_QUANT, D1_DOC, D1_ITEM, D1_DOC, D1_COD" + CRLF
	cQuery += "  ORDER BY D1_QUANT DESC, SALDO DESC  " + CRLF
	
	MemoWrite("SQLVINCULO.TXT",(oSql:PARSEQUERY(cQuery)))
	oSql:NewAlias(ChangeQuery(cQuery))
	nQtdRegistros:= oSql:Count()
	
Return


/**
* Função que atualiza as tabelas SD1 e SC7
**/
Static Function UpdateTable()
	
	Local lUpdOk		:= .F.
	Local cItemPedido	:= ""
	Local nRecnoSD1	:= 0
	Local nRecnoSC7	:= 0
	local nQtdClassif	:= 0
	local oUtils    	:= IpUtilsObject():newIpUtilsObject()
	Local nSoma		:= 0
	Local lStatus		:= .T.
	Local cProduto	:= ""
	Local cMsg			:= ""//GetMensagItensSD1()
	Local aPedidos
	Local aDocumentos := {}
	Local cDocumento	:= ""
	Local oItemPC		:= Nil
	
	oItemPC:=DHLRetItemPc():newDHLRetItemPc()
	
	While oSql:NotIsEof()
	
		cCodPodutoSD1		:=oSql:GetValue("D1_COD")
		nD1Quant			:=oSql:GetValue("D1_QUANT")
		nRecnoSD1			:=oSql:GetValue("SD1_RECNO")
		
		cProduto 	:= AllTrim(oSql:getFieldValue("SC7","C7_PRODUTO","C7_FILIAL = '%SC7.FILIAL%' AND C7_NUM = 		'" + cPedidoComp + "' AND C7_PRODUTO = 		'" + cCodPodutoSD1 + "' "))
		
		If Empty(cProduto)
			lStatus := .F.
			MsgInfo("Item  "+cCodPodutoSD1+ " não encontrado no pedido de compras","")
			exit
		EndIf
		
		oItemPc:iniciaProcesso(cPedidoComp)
		oItemPc:retornaInfoPc(cPedidoComp, cCodPodutoSD1, nD1Quant)
		
		if oItemPc:getSuccess()
			cItemPc	:= oItemPc:getItem()
			
			nC7Quant	:=	oSql:getFieldValue("SC7","C7_QUANT"	,"C7_FILIAL = '%SC7.FILIAL%' AND C7_NUM = '" + cPedidoComp + "' AND C7_ITEM = '"+cItemPc+"'")
			nC7QUJE	:=	oSql:getFieldValue("SC7","C7_QUJE"		,"C7_FILIAL = '%SC7.FILIAL%' AND C7_NUM = '" + cPedidoComp + "' AND C7_ITEM = '"+cItemPc+"'")
			nC7QTDACLA	:=	oSql:getFieldValue("SC7","C7_QTDACLA"	,"C7_FILIAL = '%SC7.FILIAL%' AND C7_NUM = '" + cPedidoComp + "' AND C7_ITEM = '"+cItemPc+"'")
			nSaldo:= nC7Quant-nC7QUJE-nC7QTDACLA
			If !Empty(cMsg)
				MsgInfo(cMsg,"")
				lStatus:=.F.
				Exit
			ElseIf nD1Quant > nSaldo
				lStatus:=.F.
				MsgInfo("Quantidade do item "+oSql:GetValue("D1_COD")+ " da pré-nota maior que a qtde a classificar do pedido de compras","")
				exit
			Else
				lUpdOk := oSql:update("SD1", "D1_PEDIDO = '"+cPedidoComp+"' ",;
					"R_E_C_N_O_ =" +AllTrim(Str(nRecnoSD1)))
		  		  	 
				lUpdOk := oSql:update("SD1", "D1_ITEMPC = '"+cItemPc+"' ",;
					"R_E_C_N_O_ =" +AllTrim(Str(nRecnoSD1)))
				
				nC7QTDACLA += nD1Quant
			
				lUpdOk := oSql:update("SC7", "C7_QTDACLA = "+cValToChar(nC7QTDACLA)+"", "C7_NUM ='" +cPedidoComp+ "' AND C7_ITEM='"+cItemPc+"'")
			EndIf
		
		Else
			MsgInfo("Quantidade do item "+oSql:GetValue("D1_COD")+ " da pré-nota maior que a qtde a classificar ou já consumido o saldo do pedido de compras","")			
			lStatus:=.F.
			exit
		endIf
		oSql:skip()
	EndDo
	
	oItemPc:finalizaProcesso()
	FreeObj(oItemPc)
		
Return lStatus


/**
* Função que verifica os itens que não existe no pedido de compras mas que tem na pré nota
* e monta a mensagem
**/
Static Function GetMensagItensSD1()
	
	Local cItemSC7 := ""
	Local cItens		:= ""
	Local nCont	:= 0
	Local cMensagem	:= ""
	
	While oSql:notIsEof()
		cItemSC7:=oSql:GetValue("PRODUTO")
		If Empty(cItemSC7)
			If nCont>0
				cItens += "-"
			EndIf
			cItens += oSql:GetValue("D1_COD")
			nCont++
		EndIf
		oSql:skip()
	EndDo
	
	If nCont==1 .AND. !Empty(cItens)
		cMensagem:= "Item "+cItens+" da pré-nota não encontrado no pedido de compras ou já totalmente consumido"
	ElseIf nCont>1 .AND. !Empty(cItens)
		cMensagem:= "Itens "+cItens+" da pré-nota não encontrado no pedido de compras ou já totalmente consumido"
	EndIf
	oSql:GoTop()
	
Return cMensagem


/**
* Caixa selecionar o pedido de compras
**/
Static Function Perguntas()
	
	Local aPergs := {}
	Local nSpace := Space(TamSx3("C7_NUM")[1])
	AADD(aPergs,{1,"Pedido de Compra:",nSpace,"@!",,"ZZSC7",,50,.f.})
	
Return ParamBox(aPergs,"Parametros",aRet,,,,,,,FUNNAME(),.f.,.f.)