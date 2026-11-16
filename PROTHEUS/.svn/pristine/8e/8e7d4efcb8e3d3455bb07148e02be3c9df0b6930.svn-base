#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} M410PVNF
Ponto de entrada para validação. M410PVNF - Geração de notas fiscais

@author Thiago Meschiatti
@since 02/06/2016
@version undefined
@type function

/*/
User Function M410PVNF()
	local nRec			:= PARAMIXB
	local lRet			:= .t.
	local aArea			:= GetArea()
	local aAreaSC5		:= SC5->(GetArea())
	local lModelo3		:= alltrim(GetNewPar("ZZ_MODEFAT", "1")) $ "3"
	local oModelo3		:= DHLModelo3():NewDHLModelo3()
	local cUserFat		:= GetMV("ZZ_USERFAT")
	local cEstCBENEF	:= superGetMv("ZZ_UFBENEF", , "PR/RJ")
	local dCorteCBENEF 	:= superGetMv("ZZ_DTCTCBE", , sTod("99991231"))
	//RONI SILVA INICIO
	CMODFAT3 := POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_ZZMODFA")
	IF alltrim(CMODFAT3) $ "1" .AND. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
		lModelo3 := .T.
	endif
	//RONI SILVA SILVA
	if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		lRet := u_ValidFat(nRec)
	endif

	if FWUnitBusiness() == DHL_BUSINESSUNIT_AGE .OR. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
		if AllTrim(SC5->C5_ZZSTATU) == DHL_PV_PENDENTE_INFORMACAO
			MsgAlert("Pedido de venda não pode ser faturado. Pendente de ação.")
			lRet := .F.
		endif
	endif

	if FWUnitBusiness() == DHL_BUSINESSUNIT_PKG

		if AllTrim(SC5->C5_ZZSTATU) == DHL_PV_PENDENTE_INFORMACAO
			MsgAlert("Pedido de venda não pode ser faturado. Pendente de ação.")
			lRet := .F.
		else
			if lModelo3  //RONI SILVA AJUSTAR PARA MODELO3 MUL PELO CLIENTE
				if SC5->C5_ZZTPPV == RETORNO_INDUSTRIALIZACAO
					lRet := oModelo3:ValidFaturamento(SC5->C5_ZZPVREF)
				endIf
			endIf
		endif

	endIf

	if FWUnitBusiness() == DHL_BUSINESSUNIT_MUL

		if AllTrim(SC5->C5_ZZSTATU) == DHL_PV_PENDENTE_INFORMACAO
			MsgAlert("Pedido de venda não pode ser faturado. Pendente de ação.")
			lRet := .F.
		else
			if lModelo3  //RONI SILVA AJUSTAR PARA MODELO3 MUL PELO CLIENTE
				if SC5->C5_ZZTPPV == RETORNO_INDUSTRIALIZACAO
					lRet := oModelo3:ValidFaturamento(SC5->C5_ZZPVREF)
				endIf
			endIf
		endif

	endIf

	if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2

		if AllTrim(SC5->C5_ZZSTATU) == DHL_PV_PENDENTE_INFORMACAO
			MsgAlert("Pedido de venda não pode ser faturado. Pendente de ação.")
			lRet := .F.
		else
			If SC5->C5_TIPO $ "N"
				If (Alltrim(SC5->C5_ZZESPEC) == DHL_ESPECIE_INVENTARIO) .or. (Alltrim(SC5->C5_ZZTPPV) == RETORNO_EFETIVO) .or. (Alltrim(SC5->C5_ZZTPPV) == AJUSTE_FISCAL) .or. (AllTrim(__cUserID) $ cUserFat)
					lRet := .T.
				else
					MsgAlert("Pedido de venda não pode ser faturado! Somente é permitido o faturamento de pedidos de venda do tipo INV, Retorno Efetivo ou Ajuste Fiscal ou por usuários autorizados.")
					lRet := .F.
				endIf
			EndIf
		endif

	endIf

	if cFilAnt == AGE_MONDELEZ

		if SUPERGETMV( "ZZ_VLDVINC", .F., .T. )
			if SC5->C5_TIPO == "N"
				if !isItensAmarrado(SC5->C5_NUM)
					lRet := .F.
					MsgAlert("Pedido " +  SC5->C5_NUM + " não pode ser faturado, pois não foi realizado o vínculo do XML de Terceiro")
				endIf
			endIf
		endIf

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

		lRet := validCanInvoice(SC5->C5_NUM)

	endIf

	if lRet .and. cFilAnt == AGE_PFIZER

		lRet := vldFatPfzer()

	endIf

	if FWUnitBusiness() == DHL_BUSINESSUNIT_AGL
		if lRet .and. (SC5->C5_ZZTPPV == REMESSA_CONTA_ORDEM .or. SC5->C5_ZZTPPV == RETORNO_SIMBOLICO) .and.;
			!Empty(SC5->C5_ZZNFTER) .and. !Empty(SC5->C5_ZZSETER)

			lRet := .f.
			MsgAlert("Pedido " +  SC5->C5_NUM + " não pode ser faturado, processo de triângulação de saída.")
		endif
	endif

	if FWUnitBusiness() == DHL_BUSINESSUNIT_DI2
		lRet := u_Di2VlGerNFS(nRec)
	endif

	RestArea(aAreaSC5)
	RestArea(aArea)

Return (lRet)

/**
* Verifica se os itens do pedido estão amarrados sem as notas de origem
**/
static function isItensAmarrado(cNumPedido)

	local lIsItensAmarracao 	:= .T.
	local cQuery 				:= ""
	local oSql					:= IpSqlObject():newIpSqlObject()

	cQuery := " SELECT  "															                                   + CRLF
	cQuery += "    SC6.C6_NFORI, SC6.C6_SERIORI, SC6.C6_ITEMORI, SC6.C6_IDENTB6 "	                                   + CRLF
	cQuery += " FROM %SC5.SQLNAME%" 												                                   + CRLF
	cQuery += " INNER JOIN %SC6.SQLNAME% ON 1 = 1" 									                                   + CRLF
	cQuery += "    AND SC5.C5_FILIAL = SC6.C6_FILIAL" 								                                   + CRLF
	cQuery += "    AND SC5.C5_NUM = SC6.C6_NUM" 									                                   + CRLF
	cQuery += "    AND %SC6.NOTDEL%" 												                                   + CRLF
	cQuery += " WHERE 1 = 1" 														                                   + CRLF
	cQuery += "    AND %SC5.XFILIAL% " 												                                   + CRLF
	cQuery += "    AND SC5.C5_NUM = '"+cNumPedido+"' " 								                                   + CRLF
	cQuery += "    AND (SC6.C6_NFORI = ' ' OR SC6.C6_SERIORI = ' ' OR SC6.C6_ITEMORI = ' ' OR SC6.C6_IDENTB6 = ' ')"   + CRLF
	cQuery += "    AND %SC5.NOTDEL% " 												                                   + CRLF

	oSql:newAlias(cQuery)

	if oSql:notIsEOF()

		lIsItensAmarracao := .F.

	endIf

	oSql:close()

return lIsItensAmarracao

/**
* processa a validação do CBENEF
**/
static function prcValidCBENEF()

	local aC6Origens 	:= getC6Origens()
	local lValidOrigens := .F.

	lValidOrigens := validOrigens(aC6Origens)	

return lValidOrigens

/**
* valida as informações na Entrada
**/
static function validOrigens(aC6Origens)

	local aArea 	:= getArea()
	local aAreaSD1 	:= SD1->(getArea())
	local aAreaSC5  := SC5->(getArea())
	local aAreaSC6  := SC6->(getArea())
	local aAreaSA4	:= SA4->(getArea())
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

	//aInf  := StaticCall(MATN410B, A410LancAp)
	aInf  := &("StaticCall(MATA017, A0170LancAp)")	

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
* Valida se o pedido pode ser faturado
**/
static function validCanInvoice(cPedido)

	local lCanValidCanInvoice 	:= .T.
	local nSaldoB6ByProd		:= 0
	local nQtdC6ByProd			:= 0
	local cAliasSC6				:= getNextAlias()
	local aArea					:= getArea()
	local aAreaSC6				:= SC6->(getArea())
	local aAreaSC5				:= SC5->(getArea()) 
	local cChave				:= fwxFilial("SC5") + cPedido
	local cProduto				:= ""
	local cIdent				:= ""	
	local cMsgErro				:= ""

	SC5->(dbSetOrder(1))
	if SC5->(dbSeek(cChave))

		BeginSql Alias cAliasSC6
			SELECT SUM(SC6.C6_QTDVEN) QTDVEN,SC6.C6_PRODUTO PRODUTO,SC6.C6_IDENTB6 IDENTB6,SC6.C6_TES TESPV
			FROM %Table:SC6% SC6
			WHERE
			SC6.C6_FILIAL	= %Exp:SC5->C5_FILIAL% AND
			SC6.C6_NUM 		= %Exp:SC5->C5_NUM% AND	
			SC6.%NotDel%
			GROUP BY SC6.C6_PRODUTO, SC6.C6_IDENTB6,  SC6.C6_TES
		EndSql

		If (cAliasSC6)->(!Eof())
			while (cAliasSC6)->(!eof())
				If ContrPoder((cAliasSC6)->TESPV) //Emerson Holanda 24/09/21 -- Valida o saldo de terceiro apenas se a Tes controlar terceiro
					cProduto 		:= (cAliasSC6)->PRODUTO
					cIdent 			:= (cAliasSC6)->IDENTB6
					nQtdC6ByProd	:= (cALiasSC6)->QTDVEN
					nSaldoB6ByProd	:= getSaldoB6ByProd(cProduto, cIdent)

					if SC5->C5_TIPO <> "C" //Pedidos de complemento não devem verificar saldo.
						if nQtdC6ByProd > nSaldoB6ByProd
							cMsgErro         += "Para o produto " + allTrim(cProduto) + " não possui saldo em poder de terceiro. Quantidade do Pedido: " + cValToChar(nQtdC6ByProd) + ". Quantidade em poder de terceiro: " +cValToChar(nSaldoB6ByProd) + CRLF + CRLF
							lCanValidCanInvoice := .F.
						endIf
					else
						lCanValidCanInvoice := .T.
					endif
				EndIf
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

/**
* Valida o faturamento. Verifica se realmente pode ocorrer o faturamento, e não desbalancear a tabela SB6
**/
static function vldFatPfzer()

	local aDetails 		:= getDetails()
	local aErrorSC6Qtd	:= {}
	local cErrorSC6Qtd	:= ""
	local aErrorSaldo	:= {}
	local cErrorSaldo	:= ""
	local aErrorBalanc	:= {}
	local cErrorBalanc  := ""
	local lValid		:= .T.
	local lJob			:= .F.	
	local lIsContEstoq	:= .F.

	if getNewPar("ZZ_ISPRPFI", .T.)
		if isSaldoSuf(aDetails , aErrorSaldo, @lIsContEstoq)
			if lIsContEstoq
				if &("StaticCall(DisInvReq, verifyBalancTables	, aDetails , aErrorBalanc)")
					if !&("StaticCall(DisInvReq, isCanCreateInv, aDetails , aErrorSC6Qtd)")
					cErrorSC6Qtd := &("StaticCall(DisInvReq, arrayToStr, aErrorSC6Qtd)")    
					u_DHLMsgLog(cErrorSC6Qtd, "LOG", 1, .F.)
					lValid := .F.
					endIf
				else
				lValid := .F.
				cErrorBalanc := &("StaticCall(DisInvReq, arrayToStr, aErrorBalanc)")
				u_DHLMsgLog(cErrorBalanc, "LOG", 1, .F.)
				endIf
			endIf
		else
			lValid := .F.
			cErrorSaldo := &("StaticCall(DisInvReq, arrayToStr, aErrorSaldo)")
			u_DHLMsgLog(cErrorSaldo, "LOG", 1, .F.)
		endIf
		&("StaticCall(DisInvReq, createOraclTable)")
		&("StaticCall(DisInvReq, saveLog				, fwxFilial('SC5') , SC5->C5_NUM, dTos(dDataBase), time(), 'FATURAMENTO' , lValid)")
	endIf

return lValid

/**
* Obtém os itens do pedido de vendas
**/
static function getDetails()

	local cPedido 	:= SC5->C5_NUM
	local aArea 	:= getArea()
	local aAreaSC5 	:= SC5->(getArea())
	local aAreaSC6 	:= SC6->(getArea())
	local cChaveSC6 := fwxFilial("SC6") + cPedido
	local aDetail	:= {}
	local aDetails	:= {}

	SC6->(dbSetOrder(1))

	if SC6->(dbSeek(cChaveSC6))

		while SC6->(!eof()) .and. SC6->(C6_FILIAL + C6_NUM) == cChaveSC6

			aDetail := {}

			aDetail := {{"C6_ITEM"			, SC6->C6_ITEM 	}	, ;
			{"C6_PRODUTO"		, SC6->C6_PRODUTO			}	, ;
			{"C6_LOTECTL"		, SC6->C6_LOTECTL			}	, ;
			{"C6_LOCAL"			, SC6->C6_LOCAL	 			}	, ;
			{"C6_QTDVEN"		, SC6->C6_QTDVEN			}	, ;
			{"C6_IDENTB6"		, SC6->C6_IDENTB6			}	, ;		
			{"C6_NFORI"			, SC6->C6_NFORI				}	, ;
			{"C6_SERIORI"		, SC6->C6_SERIORI			}	, ;			
			{"C6_ITEMORI"		, SC6->C6_ITEMORI			}	, ;	
			{"C6_TES"			, SC6->C6_TES				}	, ;	
			{"C6_NUM"			, SC6->C6_NUM				}}			

			aAdd(aDetails, aDetail)

			SC6->(dbSkip())

		endDo

	endIf

	restArea(aAreaSC6)
	restArea(aAreaSC5)
	restArea(aArea)	

return aDetails

/**
* Verifica se possui saldo suficiente na SB2
**/
static function isSaldoSuf(aDetails , aErrorSaldo, lIsContEstoq)

	local lIsSaldoSuf 	:= .F.
	local nSaldoB2 		:= 0 
	local nI			:= 0
	local aDetail		:= {}
	local cProduto		:= ""
	local cLote			:= ""
	local cArmazem		:= ""
	local nQtdVen		:= 0
	local lVerify		:= .F.

	for nI := 1 to len(aDetails)

		aDetail := aDetails[nI]	

		cItem	:= aDetail[getPosField(aDetail,"C6_ITEM")][2]
		cProduto:= aDetail[getPosField(aDetail,"C6_PRODUTO")][2]
		cLote	:= aDetail[getPosField(aDetail,"C6_LOTECTL")][2]
		cArmazem:= aDetail[getPosField(aDetail,"C6_LOCAL")][2]
		nQtdVen	:= aDetail[getPosField(aDetail,"C6_QTDVEN")][2]	
		cIdentB6:= aDetail[getPosField(aDetail,"C6_IDENTB6")][2]	
		cNfOri	:= aDetail[getPosField(aDetail,"C6_NFORI")][2]	
		cSeriOri:= aDetail[getPosField(aDetail,"C6_SERIORI")][2]
		cItemOri:= aDetail[getPosField(aDetail,"C6_ITEMORI")][2]
		cPedido := aDetail[getPosField(aDetail,"C6_NUM")][2]
		cTes 	:= aDetail[getPosField(aDetail,"C6_TES")][2]

		if isTesContrEstoq(cTes)
			lVerify 	  := .T.	
			lIsContEstoq  := .T.
		else
			lIsSaldoSuf := .T.
			lVerify 	:= .F.			
		endIf

		if lVerify

		nSaldoB2 			:= &("StaticCall(DisInvReq, getSaldoB2	, cProduto , cArmazem)")	
		nQtdC6InPedSemFat	:= &("StaticCall(DisInvReq, getQtdInPedSemFat	, cProduto , cArmazem, cIdentB6, cPedido)")	

			if nSaldoB2 > 0
				if 	nQtdC6InPedSemFat <= nSaldoB2
				lIsSaldoSuf := .T.
				else
				aAdd(aErrorSaldo, {"Produto/Lote " + allTrim(cProduto) + "/" +allTrim(cLote)+ " não possui saldo em estoque disponível: " + cValtoChar(nSaldoB2) + ". Quantidade do produto a ser processado: " +cValtoChar(nQtdVen)})
				endIf
			else
				aAdd(aErrorSaldo, {"Produto/Lote " + allTrim(cProduto) + "/" +allTrim(cLote)+ " não possui saldo em estoque disponível: " + cValtoChar(nSaldoB2) + ". Quantidade do produto a ser processado: " +cValtoChar(nQtdVen)})
			endIf

		endIf

	next nI
	
	if len(aErrorSaldo) > 0
		lIsSaldoSuf := .F.
	endIf

return lIsSaldoSuf

/**
* obtém a posiçãomdo campo no array
**/
static function getPosField(aDetail, cCampo)

	local nPosField := aScan(aDetail, {|x| allTrim(x[1]) == cCampo})

return nPosField

/**
* Verifica se a TES controla estoque
**/
static function isTesContrEstoq(cTes)

	local aArea 			:= getArea()
	local aAreaSF4 			:= SF4->(getArea())
	local lIsTesContrEstoq 	:= .F.
	local cChave			:= fwxFilial("SF4") + cTes

	if SF4->(dbSeek(cChave))
		if SF4->F4_ESTOQUE == "S"
			lIsTesContrEstoq := .T.
		endIf
	endIf

	restArea(aAreaSF4)
	restArea(aArea)

return lIsTesContrEstoq

/**
* Emerson Holanda 24/09/21
* Verifica se a TES controla poder de terceiro
**/
static function ContrPoder(cTes)

	local aArea 			:= getArea()
	local aAreaSF4 			:= SF4->(getArea())
	local lIsTesContrPoder 	:= .F.
	local cChave			:= fwxFilial("SF4") + cTes

	if SF4->(dbSeek(cChave))
		if SF4->F4_PODER3 <> "N"
			lIsTesContrPoder := .T.
		endIf
	endIf

	restArea(aAreaSF4)
	restArea(aArea)

return lIsTesContrPoder
