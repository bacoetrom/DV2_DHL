#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} M460MARK

Valida os itens

@author Gustavo Luiz
@since 23/04/2019

@return lógico Se processa ou não
/*/
User Function M460MARK()

	local cMark 	:= PARAMIXB[1]
	local lRet		:= .T.
	local aArea		:= getArea()
	local aAreaSC9 	:= SC9->(getArea())
	local aAreaSC5  := SC5->(getArea())
	local cAlias	:= ""
	local cMsg      := ""
	local cEstCBENEF:= superGetMv("ZZ_UFBENEF", , "PR/RJ")
	local dCorteCBENEF 	:= superGetMv("ZZ_DTCTCBE", , sTod("99991231"))

	if cFilAnt == AGE_MONDELEZ

		if SUPERGETMV( "ZZ_VLDVINC", .F., .T. )

			FWMsgRun(, {|| cAlias := getAliasSC9(cMark)},,"Aguarde, executando consulta")

			if (cAlias)->(!eof())
				while (cAlias)->(!eof())
					if posicionaSC5((cAlias)->C9_PEDIDO)
						if SC5->C5_TIPO == "N"
							if !&("StaticCall(M410PVNF_PE, isItensAmarrado	, SC5->C5_NUM)")
								lRet := .F.
								cMsg += "Pedido " +  SC5->C5_NUM + " não pode ser faturado, pois não foi realizado o vínculo do XML de Terceiro" + CRLF
							endIf
						endIf
					endIf
					(cAlias)->(dbSkip())
				endDo
				(cAlias)->(dbCloseArea())
			endIf
		endIf

	endIf

	if !lRet
		Aviso('Pedidos sem vínculo XML de Terceiro', cMsg,{"Ok"}, 3)
	endIf

	if allTrim(SM0->M0_ESTENT) $ allTrim(cEstCBENEF) .and. lRet

		if cFilAnt == AGE_MONDELEZ
			if dDataBase >= dCorteCBENEF
				lRet := prcValidCBENEF()
			endIf
		else
			if cFilAnt != PEG
				if lRet
					lRet := prcValidCBENEF() 	
				endIf
			endIf
		endIf	

	endIf
	
	if lRet .and. (cFilAnt == AGE_BRASKEM .or. cFilAnt == AGE_BRASKEM_MOV)

		lRet := prcVldInvoice(cMark)		

	endIf
	
	if lRet .and. cFilAnt == AGE_PFIZER
		
		Aviso('Atenção', 'Para a operação Pfizer, só é possível faturar pelo Prep. Doc',{"Ok"}, 3)
		lRet := .F.
	endIf

	restArea(aAreaSC5)
	restArea(aAreaSC9)
	restArea(aArea)

Return lRet

/**
* valida as informações na Entrada
**/
static function validOrigens(aC6Origens)	

	local aArea 	:= getArea()
	local aAreaSD1 	:= {} 
	local aAreaSC5  := {}
	local aAreaSC6  := {} 
	local aAreaSA4	:= {} 
	local nI		:= 0
	local cFilSD1   := ""
	local cForneSD1 := ""
	local cLojaSD1  := ""
	local cDocSD1   := ""
	local cSerSD1   := ""
	local cItemSD1  := ""
	local cCbenefD1 := ""
	local cCbenefCDV:= ""
	local nRecnoSC6 := 0
	local nRecnoSC5 := 0
	local lValid	:= .T.
	local cMsgErro	:= ""
	local cProduto  := "" 
	local nRecnoSC6 := 0

	SD1->(dbSelectArea("SD1"))
	SA4->(dbSelectArea("SA4"))

	aAreaSD1 := SD1->(getArea())
	aAreaSC5 := SC5->(getArea())
	aAreaSC6 := SC6->(getArea())
	aAreaSA4 := SA4->(getArea())

	for nI := 1 to len(aC6Origens)

		cFilSD1   := aC6Origens[nI][1]
		cForneSD1 := aC6Origens[nI][2]
		cLojaSD1  := aC6Origens[nI][3]
		cDocSD1   := aC6Origens[nI][4]
		cSerSD1   := aC6Origens[nI][5]
		cItemSD1  := aC6Origens[nI][6] 	
		nRecnoSC6 := aC6Origens[nI][7] 		

		cCbenefD1 := getCbenfD1(cFilSD1, cForneSD1, cLojaSD1, cDocSD1, cSerSD1, cItemSD1)		

		nRecnoSC5 := SC5->(recno())
		SC6->(dbSetOrder(1))

		SC6->(dbGoTo(nRecnoSC6))
		
		cCbenefCDV:= getCbenfCDV(nRecnoSC5 , nRecnoSC6)
		cProduto  := allTrim(SC6->C6_PRODUTO)

		if allTrim(cCbenefD1) != allTrim(cCbenefCDV)
			if empty(cCbenefD1)
				cMsgErro += "PRODUTO ["+cProduto+"]: CBENEF ENTRADA [VAZIO], CBENEF SAIDA["+allTrim(cCbenefCDV)+"]" + CRLF + CRLF
			elseIf empty(cCbenefCDV)
				cMsgErro += "PRODUTO ["+cProduto+"]: CBENEF ENTRADA ["+allTrim(cCbenefD1)+"], CBENEF SAIDA[VAZIO]" + CRLF + CRLF
			else
				cMsgErro += "PRODUTO ["+cProduto+"]: CBENEF ENTRADA ["+allTrim(cCbenefD1)+"], CBENEF SAIDA["+allTrim(cCbenefCDV)+"]" + CRLF + CRLF
			endIf			
		endif	

	next nI	

	if !empty(cMsgErro)

		if !empty(cMsgErro)
			u_DHLMsgLog(cMsgErro, "LOG", 1, .F.)
		endIf

		if ApMsgNoYes( "Foi identificado divergências com o CBENEF da entrada com o CBENEF da saída.<br><br>"+;
		"<b>Solução:</b> Verifique a amarração do produto x código CBENEF/NF de Entrada. Deseja abandonar a geração da Nota de Saída?","Atenção")

			lValid := .F.

		endIf
	endIf

	restArea(aAreaSA4)
	restArea(aAreaSC6)
	restArea(aAreaSC5)
	restArea(aAreaSD1)
	restArea(aArea)	

return lValid

/**
*obtém o codigo CBENEF da CDV
**/
static function   getCbenfCDV(nRecnoSC5 , nRecnoSC6)

	local cCbenefCDV := ""
	local aArea		 := getArea()
	local aAreaSC5   := SC5->(getArea())
	local aAreaSC6   := SC6->(getArea())
	local aAreaSA4   := SA4->(getArea())
	local aTransp    := {"",""}
	local cProduto   := ""
	local cTes       := ""
	local nQtd       := 0	
	local nValMerc   := 0
	local nTotal	 := 0
	local cCliPed	 := ""

	SC5->(dbSetOrder(1))
	SC5->(dbGoTo(nRecnoSC5))

	SC6->(dbSetOrder(1))	
	SC6->(dbGoTo(nRecnoSC6))

	SA4->(dbSetOrder(1))
	If SA4->(dbSeek(xFilial("SA4")+SC5->C5_TRANSP)) 
		aTransp[01] := SA4->A4_EST		
		aTransp[02] := SA4->A4_TPTRANS	
	Endif

	MaFisSave()
	MaFisEnd()

	nTotal	+= (SC5->C5_FRETE+SC5->C5_DESPESA+SC5->C5_SEGURO)

	cCliPed := SC5->C5_CLIENTE

	MaFisIni(IIf(!Empty(cCliPed),cCliPed,Iif(Empty(SC5->C5_CLIENT),SC5->C5_CLIENTE,SC5->C5_CLIENT)),;// 1-Codigo Cliente/Fornecedor
	SC5->C5_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
	IIf(SC5->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
	SC5->C5_TIPO,;				// 4-Tipo da NF
	SC5->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")

	cProduto  := SC6->C6_PRODUTO
	cTes	  := SC6->C6_TES
	nQtd	  := SC6->C6_QTDVEN
	nPreco	  := SC6->C6_PRCVEN
	nValMerc  := SC6->C6_QTDVEN * SC6->C6_PRCVEN
	cCFOP	  := SC6->C6_CF
	cClasFis  := SC6->C6_CLASFIS


	MaFisAdd(cProduto,;   	// 1-Codigo do Produto ( Obrigatorio )
	cTes,;	   	// 2-Codigo do TES ( Opcional )
	nQtd,;  	// 3-Quantidade ( Obrigatorio )
	0,;		  	// 4-Preco Unitario ( Obrigatorio )
	0,; 	// 5-Valor do Desconto ( Opcional )
	"",;	   			// 6-Numero da NF Original ( Devolucao/Benef )
	"",;				// 7-Serie da NF Original ( Devolucao/Benef )
	,;					// 8-RecNo da NF Original no arq SD1/SD2
	0,;					// 9-Valor do Frete do Item ( Opcional )
	0,;					// 10-Valor da Despesa do item ( Opcional )
	0,;					// 11-Valor do Seguro do item ( Opcional )
	0,;					// 12-Valor do Frete Autonomo ( Opcional )
	nValMerc,;			// 13-Valor da Mercadoria ( Obrigatorio )
	0,;					// 14-Valor da Embalagem ( Opiconal )	
	,;					// 15
	,;					// 16
	,; //17
	0,;					// 18-Despesas nao tributadas - Portugal
	0,;					// 19-Tara - Portugal
	cCFOP,; // 20-CFO
	{},;            // 21-Array para o calculo do IVA Ajustado (opcional)	
	,;// 22-Codigo Retencao - Equador
	,; //23-Valor Abatimento ISS
	,; // 24-Lote Produto
	,;	// 25-Sub-Lote Produto
	,;
	,;
	cClasFis,; // 28-Classificação fiscal
	,; //29
	,; //30
	,; //31
	,; //32
	" ") // 33 - Tipo de Operação.

	aInf  := &("StaticCall(MATN410B, A410LancAp)")  

	if len(aInf) > 0
		cCbenefCDV := aInf[1][2]
	endIf

	restArea(aAreaSA4)
	restArea(aAreaSC6)
	restArea(aAreaSC5)
	restArea(aArea)

return cCbenefCDV

/**
* Obtém as origens da SC6
**/
static function getC6Origens()

	local aC6Origens:= {}
	local aArea 	:= getArea()
	local aAreaSC6 	:= SC6->(getArea())
	local cChaveSC6 := SC5->C5_FILIAL + SC5->C5_NUM

	SC6->(dbSetOrder(1))

	if SC6->(dbSeek(cChaveSC6))
		while SC6->(C6_FILIAL + C6_NUM) == cChaveSC6

			aAdd(aC6Origens, {SC6->C6_FILIAL, SC6->C6_CLI, SC6->C6_LOJA, SC6->C6_NFORI, SC6->C6_SERIORI, SC6->C6_ITEMORI, SC6->(recno())})

			SC6->(dbSkip())
		endDo

	endIf

	restArea(aAreaSC6)
	restArea(aArea)

return aC6Origens

/**
* Obtém o CBENEF da origem (SD)
**/
static function getCbenfD1(cFilSD1, cForneSD1, cLojaSD1, cDocSD1, cSerSD1, cItemSD1)	

	local cAliasSD1 	:= getNextAlias()	
	local aArea 		:= getArea()  
	local aAreaSD1  	:= SD1->(getArea())
	local cCodAjuD1Cob	:= ""

	BeginSql Alias cAliasSD1
		SELECT SD1.D1_ZZCBENE 
		FROM %Table:SD1% SD1
		WHERE
		SD1.D1_FILIAL	= %Exp:cFilSD1% AND
		SD1.D1_DOC 		= %Exp:cDocSD1% AND
		SD1.D1_SERIE 	= %Exp:cSerSD1% AND		
		SD1.D1_FORNECE 	= %Exp:cForneSD1% AND	
		SD1.D1_LOJA 	= %Exp:cLojaSD1% AND			
		SD1.D1_ITEM    = %Exp:cItemSD1% AND		
		SD1.%NotDel%
	EndSql	

	If (cAliasSD1)->(!Eof())		
		cCodAjuD1Cob:=  (cAliasSD1)->D1_ZZCBENE			
	EndIf 	

	(cAliasSD1)->(dbCloseArea())	

	restArea(aAreaSD1)
	restArea(aArea)

return cCodAjuD1Cob

/**
* processa a validação do CBENEF
**/
static function prcValidCBENEF(cMark) 

	local aC6Origens 	:= ""
	local lValidOrigens := .T.	
	local cAlias		:= ""

	FWMsgRun(, {|| cAlias := getAliasSC9(cMark)},,"Aguarde, executando consulta")

	if (cAlias)->(!eof())
		while (cAlias)->(!eof()) .and. lValidOrigens
			if posicionaSC5((cAlias)->C9_PEDIDO)
				aC6Origens    :=  getC6Origens()
				lValidOrigens := validOrigens(aC6Origens)				
			endIf
			(cAlias)->(dbSkip())
		endDo
		(cAlias)->(dbCloseArea())
	endIf

return lValidOrigens

/**
* Obtem os itens SC9 marcados
**/
static function getAliasSC9(cMark)

	local cQuery := ""
	local cAlias := getNextAlias()

	cQuery := " SELECT * FROM " +RetSqlName("SC9") +" SC9 "								+ CRLF
	cQuery += " INNER JOIN "+RetSqlName("SC6") + " SC6 ON 1 = 1 " 						+ CRLF
	cQuery += "    AND SC9.C9_FILIAL = SC6.C6_FILIAL" 									+ CRLF
	cQuery += "    AND SC9.C9_PEDIDO = SC6.C6_NUM" 										+ CRLF
	cQuery += "    AND SC9.C9_ITEM = SC6.C6_ITEM" 										+ CRLF
	cQuery += "    AND SC9.C9_PRODUTO = SC6.C6_PRODUTO" 								+ CRLF
	cQuery += "    AND SC6.D_E_L_E_T_ = ' ' " 											+ CRLF
	cQuery += " WHERE 1 = 1 "															+ CRLF
	cQuery += "    AND SC9.C9_OK = '"+ cMark +"'" 										+ CRLF
	cQuery += "    AND SC9.C9_FILIAL =  '" + xFilial("SC9") + "' " 						+ CRLF
	cQuery += "    AND SC9.D_E_L_E_T_ =  ' ' " 											+ CRLF

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T. )

return cAlias

/**
* posiciona SC5
**/
static function posicionaSC5(cPedido)

	local cChaveSC5 := fwxFilial("SC5") + cPedido
	local lPosiciona:= .F.

	SC5->(dbSetOrder(1))

	if SC5->(dbSeek(cChaveSC5))
		lPosiciona := .T.
	endIf

return lPosiciona

/**
* posiciona SC6
**/
static function posicSC6(cPedido, cItem, cProduto)

	local cChaveSC6 := fwxFilial("SC6") + cPedido + cItem + cProduto
	local lPosiciona:= .F.

	SC6->(dbSetOrder(1))

	if SC6->(dbSeek(cChaveSC6))
		lPosiciona := .T.
	endIf

return lPosiciona

/**
* Valida se pode faturar. 
**/
static function prcVldInvoice(cMark)	

	local cAlias		:= ""
	local lVldInvoice	:= .T.

	FWMsgRun(, {|| cAlias := getAliasSC9(cMark)},,"Aguarde, executando consulta")

	if (cAlias)->(!eof())
		while (cAlias)->(!eof()) 
			if posicSC6((cAlias)->C9_PEDIDO, (cAlias)->C9_ITEM, (cAlias)->C9_PRODUTO )
				lVldInvoice := validCanInvoice(SC6->C6_NUM, SC6->C6_ITEM, SC6->C6_PRODUTO)
				if !lVldInvoice
					exit
				endIf			
			endIf
			(cAlias)->(dbSkip())
		endDo
		(cAlias)->(dbCloseArea())
	endIf

return lVldInvoice

/**
* Valida se o pedido pode ser faturado
**/
static function validCanInvoice(cPedido, cItem, cProduto)

	local lCanValidCanInvoice 	:= .T.
	local nSaldoB6ByProd		:= 0
	local nQtdC6ByProd			:= 0
	local cAliasSC6				:= getNextAlias()
	local aArea					:= getArea()
	local aAreaSC6				:= SC6->(getArea())
	local aAreaSC5				:= SC5->(getArea()) 
	local cChave				:= fwxFilial("SC6") + cPedido + cItem + cProduto	
	local cIdent				:= ""	
	local cMsgErro				:= ""

	SC6->(dbSetOrder(1))
	if SC6->(dbSeek(cChave))

		BeginSql Alias cAliasSC6
			SELECT SUM(SC6.C6_QTDVEN) QTDVEN,SC6.C6_PRODUTO PRODUTO,SC6.C6_IDENTB6 IDENTB6
			FROM %Table:SC6% SC6
			WHERE
			SC6.C6_FILIAL	= %Exp:SC6->C6_FILIAL% AND
			SC6.C6_NUM 		= %Exp:SC6->C6_NUM% AND	
			SC6.C6_ITEM 	= %Exp:SC6->C6_ITEM% AND	
			SC6.C6_PRODUTO	= %Exp:SC6->C6_PRODUTO% AND	
			SC6.%NotDel%
			GROUP BY SC6.C6_PRODUTO, SC6.C6_IDENTB6 
		EndSql	

		If (cAliasSC6)->(!Eof())		
			while (cAliasSC6)->(!eof())

				cProduto 		:= (cAliasSC6)->PRODUTO 
				cIdent 			:= (cAliasSC6)->IDENTB6 
				nQtdC6ByProd	:= (cALiasSC6)->QTDVEN
				nSaldoB6ByProd	:= getSaldoB6ByProd(cProduto, cIdent)					
				
				if nQtdC6ByProd > nSaldoB6ByProd
					cMsgErro         += "Para o produto " + allTrim(cProduto) + " não possui saldo em poder de terceiro. Quantidade do Pedido: " + cValToChar(nQtdC6ByProd) + ". Quantidade em poder de terceiro: " +cValToChar(nSaldoB6ByProd) + CRLF + CRLF
					lCanValidCanInvoice := .F.
				endIf 
				
				(cAliasSC6)->(dbSkip())
			endDo
		EndIf 	

		(cAliasSC6)->(dbCloseArea())	

		if !empty(cMsgErro)

			u_DHLMsgLog(cMsgErro, "LOG", 1, .F.)

		endIf

	endIf

	restArea(aAreaSC6)
	restArea(aAreaSC5)
	restArea(aArea)

return lCanValidCanInvoice

/**
* Obtém o sado na SB6
**/
static function getSaldoB6ByProd(cProduto, cIdent)

	local cAliasSB6 := getNextAlias()
	local nSaldoSB6 := 0
	local aArea		:= getArea()
	local aAreaSB6  := SB6->(getArea())

	BeginSql Alias cAliasSB6

		SELECT SUM(SB6.B6_SALDO) SALDO 
		FROM %Table:SB6% SB6
		WHERE
		SB6.B6_FILIAL	= %Exp:fwxFilial("SB6")% AND
		SB6.B6_PRODUTO	= %Exp:cProduto% AND
		SB6.B6_IDENT	= %Exp:cIdent% AND
		SB6.B6_PODER3	= "R" AND	
		SB6.%NotDel%

	EndSql	

	If (cAliasSB6)->(!Eof())		
		nSaldoSB6  := (cAliasSB6)->SALDO
	EndIf 	
	
	(cAliasSB6)->(dbCloseArea())
	
	restArea(aAreaSB6)
	restArea(aArea)

return nSaldoSB6
