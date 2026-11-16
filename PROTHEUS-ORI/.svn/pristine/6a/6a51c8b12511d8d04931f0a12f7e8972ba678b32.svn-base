#Include 'Protheus.ch'
#Include 'dhl.ch'

#define INTERFACE_NAME "Stock Adjustment"
#Define INSUMOS_PROPRIOS  "RE0"
#Define INSUMOS_TERCEIROS "RE9"
#Define MAO_DE_OBRA		  "RE0"
#Define PRODUCAO		  "PR0"
#Define QUANTIDADE			2
#Define CUSTO				3
#Define PRODUTO				4
#Define RATEIO 				5
#Define PROPORCAO			6
#Define LOTE				8
#Define EXP_DATE			9


/*/{Protheus.doc} MulDesmontagem

Processa a desmontagem do kit
	
@author Gustavo Luiz
@since 20/02/2014

@return Logico Indica se foi processado com sucesso
/*/
User Function MulDesmontagem(aInsumosPropMod, aInsumosTerceiro)

	Local lStatus 		   := .T.
	Local lErro			   := .F.
	Local cQuery 		   := ""
	Local cOP	 		   := ""
	Local cDoc	 		   := ""
	Local cDocReq		   := ""
	Local aInsumosUnificad := {}
	Local aMaoDeObra	   := {}
	Local aProduto		   := {}
	Local aRetorno		   := {}
	Local nPercentual	   := 0
	local nQuantApontada   := 0
	Local cPalle 		   := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SUBLOT:text")))
	
	Private cProdRefugo	   := Padr(GetNewPar("ZZ_CODREFU", ""), TamSx3("D3_COD")[1], "")
	Private lMsErroAuto    := .F.
	Private lMsHelpAuto	   := .F.
	
	Public aDesmontagem	   := {}
	
	If !Empty(cProdRefugo)
		If !LoteIsEmpty()
		
			GetOP(@cOP, @cDoc, @cDocReq)
		
			If !Empty(cOP)
		
				aRetorno 		 := GetConsumo(cOP, cDoc, cDocReq)
				aInsumosPropMod  := aRetorno[1]
				aInsumosTerceiro := aRetorno[2]
				aProduto		 := aRetorno[3]
			
				nPercentual := GetPercentual(aInsumosTerceiro)
			
				CalculoRateio(aInsumosPropMod  , nPercentual)
				CalculoProporc(aInsumosPropMod , aProduto)
				CalculoProporc(aInsumosTerceiro, aProduto)
			
				aInsumosUnificad := UnificaInsumos(aInsumosPropMod, aInsumosTerceiro)
			
				Begin Transaction
									
					lErro := ExecutaDesmontagem(aInsumosUnificad, aProduto)
						
					If lErro
						
						DisarmTransaction()
						lStatus := .F.
						oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
						oLogImp:fail(INTERFACE_NAME,"Não foi possível realizar a desmontagem" + cPalle )
						
					EndIf
				
				End Transaction
			EndIf
		EndIf
	Else
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"Parâmetro ZZ_CODREFU vazio")
		lStatus := .F.
	EndIf

Return lStatus

/**
 * Unifica os insumos
**/
Static Function UnificaInsumos(aInsumosPropMod, aInsumosTerceiro)

	Local aInsumo := {}
	Local nI	  := 0	
	
	For nI := 1 To Len(aInsumosTerceiro)
	
		aAdd(aInsumo, aClone(aInsumosTerceiro[nI]))
		
	Next nI
	
	For nI := 1 To Len(aInsumosPropMod)
		
		aAdd(aInsumo, aClone(aInsumosPropMod[nI]))
	
	Next nI
	

Return aInsumo

/**
 * Realiza a desmontagem
**/
Static Function ExecutaDesmontagem(aInsumos, aProduto)
	
	Local aHeader 	:= GetAHeader(aProduto)
	Local aItens	:= GetItens(aInsumos)
	Local cErro		:= ""
	Local lErro		:= .F.
	
	nModulo			:= 4
	
	MSExecAuto({|v,x,y,z| Mata242(v,x,y,z)},aHeader,aItens,3,.T.)
	
	lMsErroAuto := .F. //TODO. FICAR COMO FALSE ATÉ ANÁLISE
	
	If lMsErroAuto
	
		cErro := Mostraerro()
		lErro := .T.
	EndIf

Return lErro

/**
 * Obtém os itens da desmontagem
**/
Static Function GetItens(aInsumos)
	
	Local cCodProBOM 	:= Padr(Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ITEM:text"))), TamSx3("D3_COD")[1] , "")
	Local cPallet		:= Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SUBLOT:text")))
	Local aItemRefug	:= {}
	Local aItemInsum	:= {}
	Local cLocalPad		:= GetLocalPad(cCodProBOM)
	Local cLocalInsu	:= ""
	Local aItens		:= {}
	Local cProdRefugo	:= Padr(GetMv("ZZ_CODREFU"), TamSx3("D3_COD")[1], "")
	Local nI			:= 1
	Local aItensTes		:= {}
	
	
	For nI := 1 To Len(aInsumos)
		
		aItemInsum := {}
		
		If "MOD" $ aInsumos[nI][PRODUTO] .AND. "MO" $ aInsumos[nI][10] 
		      
			aAdd(aItemInsum, {"D3_COD"			, 	cProdRefugo						, Nil})
			aAdd(aItemInsum, {"D3_LOCAL"		, 	cLocalPad						, Nil})
			aAdd(aItemInsum, {"D3_QUANT"		, 	aInsumos[nI][PROPORCAO]			, Nil})
			aAdd(aItemInsum, {"D3_CUSTO1"  		,   CriaVar("D3_CUSTO1")       		, Nil})
			aAdd(aItemInsum, {"D3_RATEIO"		, 	aInsumos[nI][RATEIO]			, Nil})
			
		Else
			cLocalInsu := GetLocalPad(aInsumos[nI][PRODUTO])		
			
			aAdd(aItemInsum, {"D3_COD"			, 	aInsumos[nI][PRODUTO]			, Nil})
			aAdd(aItemInsum, {"D3_LOCAL"		, 	cLocalInsu						, Nil})
			aAdd(aItemInsum, {"D3_QUANT"		, 	aInsumos[nI][PROPORCAO]			, Nil})
			aAdd(aItemInsum, {"D3_CUSTO1"  		,   CriaVar("D3_CUSTO1")       		, Nil})
			aAdd(aItemInsum, {"D3_RATEIO"		, 	aInsumos[nI][RATEIO]			, Nil})
				
			If ProdutControlLote(aInsumos[nI][PRODUTO])
				
				aAdd(aItemInsum, {"D3_NUMLOTE"		, 	CriaVar("D3_NUMLOTE"), 			  Nil})
				aAdd(aItemInsum, {"D3_LOTECTL"		, 	aInsumos[nI][LOTE], 			  Nil})
				aAdd(aItemInsum, {"D3_DTVALID"		, 	sToD(aInsumos[nI][EXP_DATE]), 	  Nil})			
			
			EndIF
		
		EndIf
		
		aItemInsum := FWVetByDic( aItemInsum, 'SD3')
		
		aAdd(aItens, aItemInsum)
		
	Next nI

Return aItens

/**
* Verifica se o produto controla lote
**/
Static Function ProdutControlLote(cProduct)
	
	local oSql				:= IpSqlObject():newIpSqlObject()
	Local cControlLote		:= ""
	Local lControla			:= .T.
	
	cControlLote := oSql:getFieldValue("SB1","B1_RASTRO","B1_FILIAL = '%SB1.FILIAL%' AND B1_COD = '" + cProduct + "'")
	
	If cControlLote == "N"
		lControla := .F.
	EndIf
	
	oSql:close()
	
Return lControla

/**
 * Obtém o cabeçalho para ser passado pela rotina automática
**/
Static Function GetAHeader(aProduto)
	
	Local aHeader 		:= {}
	Local cCodProBOM 	:= Padr(Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ITEM:text"))), TamSx3("D3_COD")[1] , "")
	Local nQtdBOM		:= Val(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_QUANTITY:text"))
	Local cLocalPad		:= GetLocalPad(cCodProBOM)
	Local cDocumento	:= ""
	Local aArea			:= GetArea()
	Local aAreaSD3		:= SD3->(GetArea())
	
	SD3->(DbSetOrder(2))
	
	cDocumento := NextNumero("SD3", 2, "D3_DOC", .T.)
	cDocumento := A261RetINV(cDocumento)
	
	aAdd(aHeader, {"cProduto"	, cCodProBOM				, 	Nil})
	aAdd(aHeader, {"cLocOrig" 	, cLocalPad					, 	Nil})
	aAdd(aHeader, {"nQtdOrig" 	, nQtdBOM					, 	Nil}) //QUANTIDADE DO FILEBOM A SER AJUSTADO
	aAdd(aHeader, {"cDocumento" , cDocumento				, 	Nil})
	
	
	If ProdutControlLote(cCodProBOM)
		aAdd(aHeader, {"cNumLote"   , aProduto[1][4]   		,   Nil}) //D3_NUMLOTE
		aAdd(aHeader, {"cLoteDigi"  , aProduto[1][5]   		,   Nil}) //D3_LOTECTL
		aAdd(aHeader, {"dDtValid"   , sTod(aProduto[1][6])	,   Nil}) //D3_DTVALID
	Else
		aAdd(aHeader, {"cNumLote"   , CriaVar("D3_NUMLOTE") ,   Nil}) //D3_NUMLOTE
		aAdd(aHeader, {"cLoteDigi"  , CriaVar("D3_LOTECTL") ,   Nil}) //D3_LOTECTL
		aAdd(aHeader, {"dDtValid"   , CriaVar("D3_DTVALID")	,   Nil}) //D3_DTVALID
	EndIf
	
	aAdd(aHeader, {"nPotencia"  , CriaVar("D3_POTENCI")  	,   Nil}) //D3_LOCALIZ
	aAdd(aHeader, {"cLocaliza"  , CriaVar("D3_LOCALIZ")		,   Nil}) //D3_LOCALIZ
	aAdd(aHeader, {"cNumSerie"  , CriaVar("D3_NUMSERI")  	,   Nil}) //D3_NUMSERI
	
	RestArea(aAreaSD3)
	RestArea(aArea)
	
Return aHeader

/**
 * Retorna o local padrao do produto
**/
Static Function GetLocalPad(cCodProd)
	
	Local aArea 	:= GetArea()
	Local aAreaSB1 	:= SB1->(GetArea())
	Local cLocalPad	:= ""
	
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1") + cCodProd))
		cLocalPad := SB1->B1_LOCPAD
	EndIf
	
	RestArea(aAreaSB1)
	RestArea(aArea)
	
Return cLocalPad

/**
 * Realiza o calculo de proporcionalidade 
**/
Static Function CalculoProporc(aInsumos, aProduto)

	Local nI 			 := 0
	Local nQuantInsumo	 := 0
	Local nProporcao	 := 0
	Local nQuantInterfac := Val(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_QUANTITY:text"))
	Local nQuantApontada := aProduto[1][2]
	
	For nI := 1 To Len(aInsumos)
		
		nQuantInsumo 			:= aInsumos[nI][QUANTIDADE]
		nProporcao   			:= NoRound(((nQuantInsumo * nQuantInterfac) / nQuantApontada), 5)
		aInsumos[nI][PROPORCAO] := nProporcao
	
	Next nI

Return

/**
 * Obtém o pecertual para ser utilizado na regra de 3
**/
Static Function GetPercentual(aInsumosTerceiro)
	
	Local nI 			:= 1
	Local nPercentual	:= 100
	Local nRateio		:= 0
	
	For nI := 1 To Len(aInsumosTerceiro)
		nRateio += aInsumosTerceiro[nI][RATEIO]
	Next nI
	
	nPercentual := nPercentual - nRateio

Return nPercentual

/**
 * Calcula os insumos obtendo o valor total do custo do PA, rateando o valor induvidual do insumo
**/
Static Function CalculoRateio(aInsumo, nPercentual)
	
	Local nI 				:= 1
	Local nVlrCustoTotal	:= 0
	Local nVlrRateioIndv	:= 0
	
	//OBTÉM O VALOR TOTAL DO CUSTO DO PA
	For nI := 1 To Len(aInsumo)
		
		nVlrCustoTotal += aInsumo[nI][CUSTO]
		
	Next nI
	
	//RATEIA O VALOR INDIVIDUAL DO INSUMO
	For nI := 1 To Len(aInsumo)
		
		nVlrRateioIndv 			   :=  (aInsumo[nI][CUSTO] * nPercentual) / nVlrCustoTotal
		aInsumo[nI][RATEIO]		   :=  nVlrRateioIndv
		
	Next nI	

Return

/**
 * Obtém os consumos referente a ordem de produção passada considerando o último apontamento
**/
Static Function GetConsumo(cOP, cDoc, cDocReq)
	
	Local cQuery := ""
	Local oSqlCon:= ipSqlObject():newIpSqlObject()
	Local aInsumosPropMod  := {}
	Local aInsumosTerceiro := {}
	Local aProduto		   := {}
	
	cQuery := GetQueryConsumo(cOP, cDoc, cDocReq)
		
	oSqlCon:NewAlias(cQuery)
		
	If oSqlCon:HasRecords()
		While oSqlCon:NotIsEOF()
		
			If oSqlCon:GetValue("D3_CF") == PRODUCAO
				
				aAdd(aProduto, ;
					{oSqlCon:GetValue("D3_OP"),		;
					oSqlCon:GetValue("D3_QUANT"),	;
					oSqlCon:GetValue("D3_QTSEGUM"),;
					oSqlCon:GetValue("D3_NUMLOTE"),;
					oSqlCon:GetValue("D3_LOTECTL"),;
					oSqlCon:GetValue("D3_DTVALID"),;
					oSqlCon:GetValue("D3_POTENCI"),;
					oSqlCon:GetValue("D3_LOCALIZ"),;
					oSqlCon:GetValue("D3_NUMSERI"),;
					oSqlCon:GetValue("D3_TIPO")})
				
			ElseIf oSqlCon:GetValue("D3_CF") == INSUMOS_PROPRIOS .AND. oSqlCon:GetValue("D3_TIPO") != "MO"
		
				aAdd(aInsumosPropMod, 				;
					{oSqlCon:GetValue("D3_OP"), 	;
					oSqlCon:GetValue("D3_QUANT"), 	;
					oSqlCon:GetValue("D3_CUSTO1"), 	;
					oSqlCon:GetValue("D3_COD"),		;
					0,								;
					0,								;
					oSqlCon:GetValue("R_E_C_N_O_"),	;
					oSqlCon:GetValue("D3_LOTECTL"), ;
					oSqlCon:GetValue("D3_DTVALID"), ; 
					oSqlCon:GetValue("D3_TIPO")})
			
			ElseIf 	 oSqlCon:GetValue("D3_CF") == INSUMOS_TERCEIROS .AND. oSqlCon:GetValue("D3_TIPO") != "MO
				
				aAdd(aInsumosTerceiro, 				;
					{oSqlCon:GetValue("D3_OP"), 	;
					oSqlCon:GetValue("D3_QUANT"), 	;
					oSqlCon:GetValue("D3_CUSTO1"), 	;
					oSqlCon:GetValue("D3_COD"),		;
					0.01,							;
					0,								;
					oSqlCon:GetValue("R_E_C_N_O_"),	;
					oSqlCon:GetValue("D3_LOTECTL"), ;
					oSqlCon:GetValue("D3_DTVALID"), ; 
					oSqlCon:GetValue("D3_TIPO")})
				
			ElseIf oSqlCon:GetValue("D3_CF") == MAO_DE_OBRA .AND. oSqlCon:GetValue("D3_TIPO") == "MO
				
				aAdd(aInsumosPropMod, 					;
					{oSqlCon:GetValue("D3_OP"), 	;
					oSqlCon:GetValue("D3_QUANT"), 	;
					oSqlCon:GetValue("D3_CUSTO1"), 	;
					oSqlCon:GetValue("D3_COD"),		;
					0,								;
					0,								;
					oSqlCon:GetValue("R_E_C_N_O_"),	;
					oSqlCon:GetValue("D3_LOTECTL"), ;
					oSqlCon:GetValue("D3_DTVALID"), ; 
					oSqlCon:GetValue("D3_TIPO")})
				
			EndIf
			
			oSqlCon:Skip()
			
		EndDo
			
	EndIf
	
	oSqlCon:Close()
	
Return {aInsumosPropMod, aInsumosTerceiro, aProduto}

/**
 * Obtém a OP baseado no sublote (D3_ZZPALLE)
**/
Static Function GetOP(cOP, cDoc, cDocReq)
		
	Local cQuery := ""
	Local cPalle := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SUBLOT:text")))
	Local oSqlSD3:= ipSqlObject():newIpSqlObject()
	
	cQuery := GetQueryOP(cPalle)
		
	oSqlSD3:NewAlias(cQuery)
		
	If oSqlSD3:HasRecords()
	
		cOP  	:= oSqlSD3:GetValue("D3_OP")
		cDoc 	:= oSqlSD3:GetValue("D3_DOC")
		cDocReq := oSqlSD3:GetValue("D3_ZZDOCBK")
	Else
	
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"Não foi encontrado OP referente ao SUBLOT" + cPalle )
			
	EndIf
	
	oSqlSD3:Close()
	
Return

/**
 * Verifica se a TAG <LOT> esta vazia
**/
Static Function LoteIsEmpty()

	Local lEmpty 	:= .F.
	Local cLot		:= Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_LOT:text")))
	/*
	If Empty(cLot)
		lEmpty := .T.
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"TAG LOT vazio")
	EndIf
	*///TODO COMENTADO TEMPORARIAMENTE
Return lEmpty


/**
 * Retorna a query referente a tabela de apontamento SD3
**/
Static Function GetQueryOP(cPalle)

	Local cQuery := ""
	
	cQuery += " SELECT D3_OP, D3_DOC, D3_ZZDOCBK	"                    	 +CRLF
	cQuery += " 	FROM %SD3.SQLNAME%"                   					 +CRLF
	cQuery += " WHERE D3_FILIAL = '%SD3.FILIAL%' AND" 					 	 +CRLF
	cQuery += " 	SD3.D3_ZZPALLE = '" + cPalle + "' AND "					 +CRLF
	cQuery += " 	SD3.D3_CF =  'PR0' AND  "    		 		 	 		 +CRLF
	cQuery += " 	%SD3.NOTDEL%"                   		 				 +CRLF
	cQuery += " ORDER BY R_E_C_N_O_ DESC" 					 	 			 +CRLF
	
Return cQuery

/**
 * Retorna a query referente aos consumos
**/
Static Function GetQueryConsumo(cOP, cDoc, cDocReq)

	Local cQuery 	:= ""
	Local cZZPellet	:= oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SUBLOT:text")
	
	cQuery += " SELECT SD3.R_E_C_N_O_, SD3.D3_TIPO, SD3.*	"        			+CRLF
	cQuery += " FROM %SD3.SQLNAME%"                   					 		+CRLF
	cQuery += " WHERE D3_FILIAL 	= '%SD3.FILIAL%' AND" 					 	+CRLF
	cQuery += " SD3.D3_OP 			= '" + cOP + "' AND "					 	+CRLF
	cQuery += " SD3.D3_ZZPALLE 		= '" + cZZPellet + "' AND "					+CRLF
	cQuery += " (SD3.D3_DOC  		= '" + cDoc + "' OR "					 	+CRLF
	cQuery += " SD3.D3_DOC  		= '" + cDocReq + "')"					 	+CRLF
	
	MemoWrite("consumo.txt", oSql:Parsequery(cquery))

Return cQuery

