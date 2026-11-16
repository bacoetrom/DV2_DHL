#Include 'Protheus.ch'
#include "dhl.ch"

#define SALDO_B2	0
#define SALDO_B6	0
#define SALDO_B8	0

#define RETORNO_EFETIVO		"RE"
#define RETORNO_SIMBOLICO	"RS"

/*/{Protheus.doc} AglVerificBalanc

Rotina responsável por ler verificar os saldos entre as tabelas SB2 SB6 e SB8.
	
@author Alberto Diorio
@since 19/02/2020

@param aDetails
/*/

User Function AglVerificBalanc(aDetails, cTipoRetorno)
	local cErrorMsg 	:= ""
	local aErrorSaldo 	:= {}	
	local aErrorBalanc  := {}
	local aErrorSC6Qtd  := {}
	local cErrorSaldo	:= ""
	local cErrorBalanc  := ""
	local cErrorSC6Qtd  := ""
	
	createOraclTable()
	
	if isSaldoSuf(aDetails, aErrorSaldo)
			if verifyBalancTables(aDetails, aErrorBalanc)
				if cTipoRetorno == RETORNO_EFETIVO //Retorno simbolico apenas irá ter DOC ORI no vinculo da NF de 3o;
					if !isCanCreateInv(aDetails, aErrorSC6Qtd)
						cErrorSC6Qtd := arrayToStr(aErrorSC6Qtd)
						//DisarmTransaction()
						cErrorMsg = cErrorSC6Qtd
					endIf
				endif	
			else
				cErrorBalanc := arrayToStr(aErrorBalanc)
				//DisarmTransaction()
				cErrorMsg = cErrorBalanc
			endIf
	else
		cErrorSaldo := arrayToStr(aErrorSaldo)
		//DisarmTransaction()
		cErrorMsg = cErrorSaldo
	endIf	
		
Return cErrorMsg


/**
* Verifica se o saldo é suficiente para o processamento
**/
static function isSaldoSuf(aDetails, aErrorSaldo)	

	local nI			:= 0
	local cProduto		:= ""	
	local cLote			:= ""	
	local cArmazem		:= ""		
	local aDetail		:= {}
	local aArea			:= getArea()
	local lSuf        	:= .T.

	for nI := 1 to len(aDetails)

		aDetail := aDetails[nI]	

		cProduto:= aDetail[getPosField(aDetail,"C6_PRODUTO")][2]
		cLote	:= aDetail[getPosField(aDetail,"C6_LOTECTL")][2]
		cArmazem:= aDetail[getPosField(aDetail,"C6_LOCAL")][2]
		nQtdVen	:= aDetail[getPosField(aDetail,"C6_QTDVEN")][2]			

		nSaldoB2 	:= getSaldoSB2(cProduto, cArmazem)	

		if nQtdVen > nSaldoB2			
			aAdd(aErrorSaldo, {"Produto/Lote " + allTrim(cProduto) + "/" +allTrim(cLote)+ " não possui saldo em estoque disponível: " + cValtoChar(nSaldoB2) + ". Quantidade do produto a ser processado: " +cValtoChar(nQtdVen)})
			lSuf := .F.		
		endIf

	next nI 	

	restArea(aArea)

return lSuf

/**
* Verifica o balanceamento das tabelas 
**/
static function verifyBalancTables(aDetails, aErrorBalanc)

	local lBalancTables := .T.
	local aProdutos		:= {}
	local nI			:= 0
	local cProduto		:= ""	
	local cLote			:= ""	
	local cArmazem		:= ""			
	local aArea			:= getArea()		

	for nI := 1 to len(aDetails)

		aDetail := aDetails[nI]	

		cProduto:= aDetail[getPosField(aDetail,"C6_PRODUTO")][2]
		cLote	:= aDetail[getPosField(aDetail,"C6_LOTECTL")][2]
		cArmazem:= aDetail[getPosField(aDetail,"C6_LOCAL")][2]
		nQtdVen	:= aDetail[getPosField(aDetail,"C6_QTDVEN")][2]			

		aAdd(aProdutos, {cProduto, cLote, cArmazem, nQtdVen, SALDO_B2, SALDO_B6, SALDO_B8})	

		nSaldoB2 	:= getSaldoB2(cProduto, cArmazem)		
		nSaldoB6    := getSaldoB6(cProduto, cArmazem)

		if !empty(cLote)
			nSaldoB8 := getSaldoB8(cProduto, cArmazem)

			if (nSaldoB8 != nSaldoB6) .OR.  (nSaldoB8 != nSaldoB2) .OR. (nSaldoB6 != nSaldoB2)
				lBalancTables := .F.
				aAdd(aErrorBalanc, {"Produto/Lote " + allTrim(cProduto) + "/" +allTrim(cLote)+ " com desbalanceamento entre as tabelas SB2/SB6/SB8. Qtd. SB2: " + cValToChar(nSaldoB2) + " Qtd. SB6: " + cValToChar(nSaldoB6)+ " Qtd. SB8: " + cValToChar(nSaldoB8)})
			endIf

		else
			if (nSaldoB6 != nSaldoB2)
				lBalancTables := .F.
				aAdd(aErrorBalanc, {"Produto " + allTrim(cProduto) + " com desbalanceamento entre as tabelas SB2/SB6. Qtd. SB2: " + cValToChar(nSaldoB2) + " Qtd. SB6: " + cValToChar(nSaldoB6)})
			endIf
		endIf

	next nI 	

	restArea(aArea)

return lBalancTables


/**
* Verifica se pode dar prosseguimento na criação do pedido
**/
static function isCanCreateInv(aDetails, aErrorSC6Qtd)

	local lCanCreateInv := .T.	
	local nI			:= 0
	local cProduto		:= ""	
	local cLote			:= ""	
	local cArmazem		:= ""		
	local aDetail		:= {}
	local aArea			:= getArea()	
	local cIdentB6		:= ""
	local cNfOri		:= ""
	local cSeriOri		:= ""
	local cItemOri		:= ""
	local nQtdRest		:= 0	
	local cPedido		:= ""	

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

		if getPosField(aDetail,"C6_NUM") > 0
			cPedido:= aDetail[getPosField(aDetail,"C6_NUM")][2]
		endIf		

		if empty(cPedido)
			//PASSAR COM NIL, PARA A FUNÇÃO ASSUMIR O VALOR DEFAULT. UTILIZADO NA INVOICE
			cPedido := nil
		endIf

		nSaldoB6    		:= getDocOrigSaldoB6(cProduto, cArmazem, cIdentB6, cNfOri, cSeriOri, cItemOri)
		nQtdC6InPedSemFat	:= getQtdInPedSemFat(cProduto, cArmazem, cIdentB6, cPedido)	
		nQtdRest			:= nSaldoB6 - nQtdC6InPedSemFat 

		if nQtdVen > nQtdRest		
			aAdd(aErrorSC6Qtd, {"Item " + allTrim(cItem) + ", Produto " + allTrim(cProduto) + " com quantidade requisitada superior ao saldo na tabela [SALDO EM PODER DE TERCEIROS] disponíveis. Qtd Saldo Poder de Terceiro: "+cValToChar(nSaldoB6)+" Qtd em Itens Pedidos Sem Faturar: " + cValToChar(nQtdC6InPedSemFat) + ". Saldo disponível: " + cValToChar(nQtdRest) + ". Qtd do produto a ser processado: "+cValToChar(nQtdVen)})
			aAdd(aErrorSC6Qtd, {"-----------------------------------------"})
			lCanCreateInv := .F.
		endIf			

	next nI 	

	restArea(aArea)

return lCanCreateInv

/**
* Cria a tabela temporária
**/
static function createOraclTable()

	local aFields	 		:= getStruct()
	local cTableName 		:= createTempTable(aFields)

return

/**
* Obtém a estrutura da tabella temporaria
**/
static function getStruct()

	local aFields := {}

	aAdd(aFields,{"FILIAL"	  	,TamSx3("F2_FILIAL")[3]		,TamSx3("F2_FILIAL")[1]								,TamSx3("F2_FILIAL")[1]		})
	aAdd(aFields,{"TP_PROCES"	,"C"						,15													,0							})
	aAdd(aFields,{"DT_PROCES"	,"C"						,10													,0							})
	aAdd(aFields,{"HR_PROCES"	,"C"						,10													,0							})
	aAdd(aFields,{"ID_PROCES"	,"C"						,20													,0							})
	aAdd(aFields,{"ST_PROCES"	,"L"						,1													,0							})	

return aFields

/**
*	cria a tabela temporária
**/
static function createTempTable(aFields)

	local cTableName 	:= "LOG_AG_LOTE"
	local cAliasTable 	:= "TBL_TEMP"
	local cChave		:= "FILIAL"		

	//DisarmTransaction()

	if !MsFile(cTableName)
		DBCreate (cTableName,aFields, "TOPCONN" )
		dbUseArea(.T., "TOPCONN", cTableName, cAliasTable, .t., .f.)
		DBCreateIndex ( cTableName, cChave)		
		dbSetOrder(1)
	else	
		if Select(cAliasTable) == 0
			dbUseArea(.T., "TOPCONN", cTableName, cAliasTable, .t., .f.)
		endIf
	endIf

	dbSelectArea(cAliasTable)	

return cTableName

/**
* Obtém a posição do campo no array
**/
static function getPosField(aDetail, cCampo)

	local nPosField := aScan(aDetail, {|x| allTrim(x[1]) == cCampo})

return nPosField

/**
* Obtém o saldo da SB2
**/
static function getSaldoSB2(cProduto, cLocPad)

	local nSaldo := 0

	cProduto := padr(cProduto, tamSx3("B1_COD")[1], "")

	dbSelectArea("SB2")
	if SB2->(dbSeek(xFilial("SB2") + cProduto + cLocPad))		
		nSaldo := SaldoSb2()
	endIf

return nSaldo

/**
* Obtém o saldo da SB2
**/
static function getSaldoB2(cProduto, cArmazem)

	local nSaldoB2 := 0
	local cQuery   := ""
	local cAlias   := getNextAlias()
	local oSql 	   := IpSqlObject():newIpSqlObject()


	cQuery := " SELECT SB2.B2_COD, SUM(SB2.B2_QATU) SALDO FROM " + retSqlName("SB2") + " SB2" 	+ CRLF
	cQuery += " WHERE 1 = 1 " 																	+ CRLF
	cQuery += "    AND SB2.B2_FILIAL = '"+fwxFilial("SB2")+"' " 								+ CRLF
	cQuery += "    AND SB2.B2_COD = '"+cProduto+"' " 											+ CRLF
	/* Inibido por Emerson Holanda 09/09/2020 - Analise de saldo geral em todos os armazens
	cQuery += "    AND SB2.B2_LOCAL = '"+cArmazem+"' " 											+ CRLF
	*/
	cQuery += "    AND SB2.D_E_L_E_T_ = ' ' " 													+ CRLF
	cQuery += "  GROUP BY SB2.B2_COD " 															+ CRLF

	oSql:newAlias(cQuery)	

	if oSql:hasRecords()
		nSaldoB2 := oSql:getValue("SALDO")
	endif

	oSql:close()

return nSaldoB2

/**
* Obtém o saldo da SB6
**/
static function getSaldoB6(cProduto, cArmazem)

	local nSaldoB6 := 0
	local cQuery   := ""
	local cAlias   := getNextAlias()
	local oSql 	   := IpSqlObject():newIpSqlObject()


	cQuery := " SELECT SB6.B6_PRODUTO, SUM(SB6.B6_SALDO) SALDO FROM " + retSqlName("SB6") + " SB6" 	+ CRLF
	cQuery += " WHERE 1 = 1 " 																	+ CRLF
	cQuery += "    AND SB6.B6_FILIAL = '"+fwxFilial("SB6")+"' " 								+ CRLF
	cQuery += "    AND SB6.B6_PRODUTO = '"+cProduto+"' " 										+ CRLF
	/* Inibido por Emerson Holanda 09/09/2020 - Analise de saldo geral em todos os armazens
	cQuery += "    AND SB6.B6_LOCAL = '"+cArmazem+"' " 											+ CRLF
	*/
	cQuery += "    AND SB6.D_E_L_E_T_ = ' ' " 													+ CRLF
	cQuery += "  GROUP BY SB6.B6_PRODUTO " 														+ CRLF

	oSql:newAlias(cQuery)	

	if oSql:hasRecords()
		nSaldoB6 := oSql:getValue("SALDO")
	endif

	oSql:close()

return nSaldoB6

/**
* Obtém o saldo da SB8
**/
static function getSaldoB8(cProduto, cArmazem)

	local nSaldoB8 := 0
	local cQuery   := ""
	local cAlias   := getNextAlias()
	local oSql 	   := IpSqlObject():newIpSqlObject()


	cQuery := " SELECT SB8.B8_PRODUTO, SUM(SB8.B8_SALDO) SALDO FROM " + retSqlName("SB8") + " SB8 " + CRLF
	cQuery += " WHERE 1 = 1 " 																	+ CRLF
	cQuery += "    AND SB8.B8_FILIAL = '"+fwxFilial("SB8")+"' " 								+ CRLF
	cQuery += "    AND SB8.B8_PRODUTO = '"+cProduto+"' " 										+ CRLF
	/* Inibido por Emerson Holanda 09/09/2020 - Analise de saldo geral em todos os armazens
	cQuery += "    AND SB8.B8_LOCAL = '"+cArmazem+"' " 											+ CRLF
	*/
	cQuery += "    AND SB8.D_E_L_E_T_ = ' ' " 													+ CRLF
	cQuery += "  GROUP BY SB8.B8_PRODUTO " 														+ CRLF

	oSql:newAlias(cQuery)	

	if oSql:hasRecords()
		nSaldoB8 := oSql:getValue("SALDO")
	endif

	oSql:close()

return nSaldoB8

/**
* Obtém o saldo da SB6 do documento de origem
**/
static function getDocOrigSaldoB6(cProduto, cArmazem, cIdentB6, cNfOri, cSeriOri, cItemOri)

	local nSaldoB6 := 0
	local cQuery   := ""
	local cAlias   := getNextAlias()
	local oSql 	   := IpSqlObject():newIpSqlObject()


	cQuery := " SELECT SB6.B6_PRODUTO, SUM(SB6.B6_SALDO) SALDO FROM " + retSqlName("SB6") + " SB6" 	+ CRLF
	cQuery += " WHERE 1 = 1 " 																		+ CRLF
	cQuery += "    AND SB6.B6_FILIAL = '"+fwxFilial("SB6")+"' " 									+ CRLF
	cQuery += "    AND SB6.B6_PRODUTO = '"+cProduto+"' " 											+ CRLF
	cQuery += "    AND SB6.B6_LOCAL = '"+cArmazem+"' " 												+ CRLF
	cQuery += "    AND SB6.B6_DOC = '"+cNfOri+"' " 													+ CRLF
	cQuery += "    AND SB6.B6_SERIE = '"+cSeriOri+"' " 												+ CRLF
	cQuery += "    AND SB6.B6_IDENT = '"+cIdentB6+"' " 												+ CRLF		
	cQuery += "    AND SB6.D_E_L_E_T_ = ' ' " 														+ CRLF
	cQuery += "  GROUP BY SB6.B6_PRODUTO " 															+ CRLF

	oSql:newAlias(cQuery)	

	if oSql:hasRecords()
		nSaldoB6 := oSql:getValue("SALDO")
	endif

	oSql:close()

return nSaldoB6

/** 
* Obtem a quantidades de itens na SC6 referente ao prduto + identb6 que não foram faturados
**/
static function  getQtdInPedSemFat(cProduto, cArmazem, cIdentB6, cPedido)

	local nQtdVen  := 0
	local cQuery   := ""
	local cAlias   := getNextAlias()
	local oSql 	   := IpSqlObject():newIpSqlObject()

	default cPedido := ""

	cQuery := " SELECT SC6.C6_PRODUTO, SUM(SC6.C6_QTDVEN) QTDVEND FROM " + retSqlName("SC6") + " SC6"	+ CRLF
	cQuery += " WHERE 1 = 1 " 																			+ CRLF
	cQuery += "    AND SC6.C6_FILIAL = '"+fwxFilial("SC6")+"' " 										+ CRLF
	cQuery += "    AND SC6.C6_PRODUTO = '"+cProduto+"' " 												+ CRLF
	cQuery += "    AND SC6.C6_LOCAL = '"+cArmazem+"' " 													+ CRLF
	cQuery += "    AND SC6.C6_IDENTB6 = '"+cIdentB6+"' " 												+ CRLF
	
	//UTILIZADO NO PE M410PVNF PARA NÃO CONSIDERAR O PEDIDO NA SOMA
	if !empty(cPedido)
		cQuery += "    AND SC6.C6_NUM NOT IN('"+cPedido+"') " 												+ CRLF
	endIf

	cQuery += "    AND SC6.C6_NOTA = ' ' " 																+ CRLF	
	cQuery += "    AND SC6.D_E_L_E_T_ = ' ' " 															+ CRLF
	cQuery += "  GROUP BY SC6.C6_PRODUTO " 																+ CRLF

	oSql:newAlias(cQuery)	

	if oSql:hasRecords()
		nQtdVen := oSql:getValue("QTDVEND")
	endif

	oSql:close()

return nQtdVen

/**
* Obtém a string do array
**/
static function arrayToStr(aError)

	local cStr 	:= ""
	local nI	:= 0

	for nI := 1 to len(aError)
		cStr += aError[nI][1] + space(100) + CRLF
	next nI

return cStr
