#Include 'Protheus.ch'
#include 'dhl.ch'
#include 'cutover.ch'


/*/{Protheus.doc} GeraPvCutover

Rotina de geração de Pedido de Vendas baseados em arquivo de importação.
	
@author Thiago Meschiatti
@since 23/02/2015

/*/
User Function GeraPvCutover()
	local cArqTxt 		:= ""	
	local lExeFun		
	local aArrSay 		:= {}
	local aArrBut 		:= {}
	
	private aHeader	 	:= {}
	private aItems		:= {}
	private lMsErroAuto := .F.
	
	aadd(aArrSay, 'Esta rotina tem por objetivo gerar Pedidos de Venda para atualização do estoque')
	aadd(aArrSay, 'e poder de terceiros, sem atualizações fiscais. ')
	 
	aadd(aArrBut, {1, .T., {|| lExeFun := .T., FechaBatch()}})
	aadd(aArrBut, {2, .T., {|| lExeFun := .F., FechaBatch()}})
	 
	FormBatch('Geraçaão de Pedido de Venda - Cutover', aArrSay, aArrBut)
	
	if lExeFun
		Processa( {|| execNfs() }, "Aguarde...", "Processando...",.F.)
	endif
Return()

/*
**
*/
static function execNfs()
	local oFile 	:= nil	
	local cDoc		:= ""
	local cSerie	:= ""  
	local cCnpj		:= ""
	local cCliFor	:= ""
	local cLoja		:= ""
	local cChvCurren:= ""
	local aNfs		:= {}	
	local nI 		:= 0
	local lCreate	:= .f.
	
	private lMsErroAuto := .f.
	private aLog		:= {}
	
	aNfs 	:= importaArq(oFile)
	ProcRegua(len(aNfs))
	
	aNfs := aSort(aNfs,,, {|x,y| x[NUMERO_NF] + x[SERIE_NF] + x[ITEM_NF_REF] < Y[NUMERO_NF] + Y[SERIE_NF] + y[ITEM_NF_REF]})

	for nI:=1 to len(aNfs)	
		IncProc("Processando...")	
		cChvCurrent := getKeyCurrent(aNfs[nI])
		lCreate := .f.
						
		if nI == 1	
				
			cDoc	:= padl(alltrim(aNfs[1, NUMERO_NF]), tamsx3("F1_DOC")[1], '0')
			cSerie	:= padr(alltrim(aNfs[1, SERIE_NF]) , tamsx3("F1_SERIE")[1], ' ')
			cCnpj	:= formatCnpj(aNfs[1, CNPJ_PROPRIETARIO])
			getClieFor(@cCliFor, @cLoja, cCnpj)
			
			if vldCliFor(cCliFor, cLoja)
				mountHeader(cDoc, cSerie, cCliFor, cLoja)
				mountDetail(cDoc, cSerie, cCliFor, cLoja, cCnpj, aNfs[nI], @lCreate)
			else
				aadd(aLog, "Não existe cliente/fornecedor para o CNPJ: " + cCnpj + " Doc: "+cDoc+" Série: " +cSerie)
			endif
			
		else			
	
			if upper(alltrim((cDoc + cSerie + cCnpj))) == upper(alltrim(cChvCurrent))
				if len(aHeader) > 0
					mountDetail(cDoc, cSerie, cCliFor, cLoja, cCnpj, aNfs[nI])
				endif
			else
				salesOrder(@lCreate)			
				getClieFor(@cCliFor, @cLoja, formatCnpj(aNfs[nI, CNPJ_PROPRIETARIO]))
				
				if vldCliFor(cCliFor, cLoja)				
					mountHeader(padl(alltrim(aNfs[nI, NUMERO_NF]), tamsx3("F1_DOC")[1], '0'), padr(alltrim(aNfs[nI, SERIE_NF]), tamsx3("F1_SERIE")[1], ' '), cCliFor, cLoja)
					mountDetail(padl(alltrim(aNfs[nI, NUMERO_NF]), tamsx3("F1_DOC")[1], '0'), padr(alltrim(aNfs[nI, SERIE_NF]), tamsx3("F1_SERIE")[1], ' '),;
								 cCliFor, cLoja, formatCnpj(aNfs[nI, CNPJ_PROPRIETARIO]), aNfs[nI], @lCreate)
//				else
//					aadd(aLog,  "Não existe cliente/fornecedor para o CNPJ: " + aNfs[nI, CNPJ_PROPRIETARIO] + " Doc: "+aNfs[nI, NUMERO_NF]+;
//								" Série: " +aNfs[nI, SERIE_NF])
				endif
			endif
			
			cDoc	:= padl(alltrim(aNfs[nI, NUMERO_NF]), tamsx3("F1_DOC")[1], '0')  
			cSerie	:= padr(alltrim(aNfs[nI, SERIE_NF]) , tamsx3("F1_SERIE")[1], ' ')
			cCnpj	:= formatCnpj(aNfs[nI, CNPJ_PROPRIETARIO])
			getClieFor(@cCliFor, @cLoja, cCnpj)
			
			if !vldCliFor(cCliFor, cLoja)
				aadd(aLog,  "Não existe cliente/fornecedor para o CNPJ: " + cCnpj + " Doc: "+cDoc+" Série: " +cSerie)
			endif
		endif
	next nI	
	if !lCreate
		salesOrder(@lCreate)
	endif
	saveLog()
return


/*
** Importação do arquivo de cutover.
*/
static function importaArq()
	local oFile := nil 
	local cDir 	:= "\cutover\arq_notas_entradas2.txt"
	local aNfs	:= {}
	
	oFile := IpFileObject():newIpFileObject(upper(cDir))
	
	oFile:open()
		while oFile:notIsEof()
			aadd(aNfs, separa(oFile:readLine(), ';') )		
			oFile:skipLine()
		end
	oFile:close()
	
return aclone(aNfs)


/**
* Coleta o Código do Fornecedor da Nota Fiscal
**/
static function getClieFor(cCliFor, cLoja, cCnpj)
	local oSql := IpSqlObject():newIpSqlObject()
	
	cCliFor := AllTrim(oSql:getFieldValue("SA1","A1_COD","A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = '" + cCnpj + "'"))
	
	if Empty(cCliFor)
		cCliFor := AllTrim(oSql:getFieldValue("SA2","A2_COD","A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = '" + cCnpj + "'"))
		if !empty(cCliFor)
			cLoja := AllTrim(oSql:getFieldValue("SA2","A2_LOJA","A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = '" + cCnpj + "'"))
		endif
	else
		cLoja := AllTrim(oSql:getFieldValue("SA1","A1_LOJA","A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = '" + cCnpj + "'"))
	endif
	
	oSql:close()
	
return  


/**
* Monta o cabelhaço da Nota Fiscal
**/
static function mountHeader(cDoc, cSerie, cCliFor, cLoja)
	local oSql := IpSqlObject():newIpSqlObject()
	
	oSql:newAlias(getHeader(cDoc, cSerie, cCliFor, cLoja))
	
	if oSql:hasRecords()

		aAdd(aHeader,{"C5_FILIAL" , xFilial("SC5")				 ,nil})
		aAdd(aHeader,{"C5_NUM"	  , getNextSalesOrderNumber()	 ,nil})
		aAdd(aHeader,{"C5_TIPO"   , "N"                          ,nil})
		aAdd(aHeader,{"C5_CLIENTE", oSql:getValue("F1_FORNECE")  ,nil})
		aAdd(aHeader,{"C5_LOJACLI", oSql:getValue("F1_LOJA") 	 ,nil})
		aAdd(aHeader,{"C5_CONDPAG", '001'						 ,nil})
		aAdd(aHeader,{"C5_ZZSTATU", ' '							 ,nil})
		aAdd(aHeader,{"C5_ZZESPEC", DHL_ESPECIE_CUTOVER			 ,nil})
	                             
	endif
	
	oSql:close()
		                             
return()


/**
* Monta os items da Nota Fiscal
**/
static function mountDetail(cDoc, cSerie, cCliFor, cLoja, cCnpj, aItem, lCreate)
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local aDetail  	:= {}
	local cKeySD1  	:= ""
	local cProduto	:= alltrim(aItem[CODIGO_ITEM])
	local cItem		:= padl(alltrim(aItem[ITEM_NF_REF]), tamsx3("D1_ITEM")[1], '0')
	local nSaldo	:= 0
		
	oSql:newAlias(getDetail(cDoc, cSerie, cCliFor, cLoja, cProduto, cItem))
	if !(oSql:hasRecords())
		oSql:close()
		oSql:newAlias(getDetail(cDoc, cSerie, cCliFor, cLoja, alltrim(cValtochar(val(cProduto))), cItem))
	endif
	
	if oSql:hasRecords()
	
		lCreate := .f.
		
		if val(aItem[SALDO]) == oSql:getValue("B6_SALDO")
			nSaldo := 0
		elseif val(aItem[SALDO]) == 0
			nSaldo := oSql:getValue("B6_SALDO")
		else
			nSaldo := oSql:getValue("B6_SALDO") - val(aItem[SALDO])
		endif
		
		if nSaldo > 0
	
			aAdd(aDetail, {"C6_ITEM"	, if(empty(aItems),'01',getItem())	, nil})
			aAdd(aDetail, {"C6_PRODUTO"	, oSql:getValue("D1_COD")			, nil})
			aAdd(aDetail, {"C6_QTDVEN"	, nSaldo							, nil})
			aAdd(aDetail, {"C6_PRCVEN"	, oSql:getValue("D1_VUNIT")			, nil})
			aAdd(aDetail, {"C6_VALOR"	, A410Arred(nSaldo * oSql:getValue("D1_VUNIT") ,"C6_VALOR") , nil})
			aAdd(aDetail, {"C6_TES"		, GetNewPar("ZZ_TESSACO","5AA")		, nil})
			aAdd(aDetail, {"C6_NFORI"	, oSql:getValue("D1_DOC")			, nil})
			aAdd(aDetail, {"C6_SERIORI"	, oSql:getValue("D1_SERIE")			, nil})
			aAdd(aDetail, {"C6_ITEMORI"	, oSql:getValue("D1_ITEM")			, nil})
			aAdd(aDetail, {"C6_IDENTB6"	, oSql:getValue("B6_IDENT")			, nil})
		
			
			aAdd(aItems, aDetail)
		else
			aadd(aLog, "O Produto: " + cProduto + " do Doc: " + cDoc + " Serie: " + cSerie + " Cnpj: " + cCnpj + " não possuí saldo a ajustar!")	
		endif	
	else
		//logar arquivo
		aadd(aLog, "O Produto: " + cProduto + " do Doc: " + cDoc + " Serie: " + cSerie + " Cnpj: " + cCnpj + " não foi localizado no protheus!") 
	endif
	
	oSql:close()
	
return


/*
** Localiza NF na tabela na SF1
*/
static function getHeader(cDoc, cSerie, cCliFor, cLoja)
	local cQuery := ""

	cQuery += " SELECT * FROM %SF1.SQLNAME%   			"+CRLF
	cQuery += " WHERE                         			"+CRLF
	cQuery += " 	%SF1.XFILIAL%               		"+CRLF
	cQuery += " 	AND %SF1.NOTDEL%           		"+CRLF
	cQuery += " 	AND F1_DOC 		= '"+cDoc+"'    "+CRLF
	cQuery += " 	AND F1_SERIE 	= '"+cSerie+"'   "+CRLF
	cQuery += " 	AND F1_FORNECE  = '"+cCliFor+"'    	"+CRLF
	cQuery += " 	AND F1_LOJA		= '"+cLoja+"'    	"+CRLF
	
return (cQuery)


/*
** Localiza NF na tabela na SF1
*/
static function getDetail(cDoc, cSerie, cCliFor, cLoja, cProduto, cItem)
	local cQuery := ""

	cQuery := " SELECT * "
	cQuery += " FROM %SD1.SQLNAME% "
	cQuery += " INNER JOIN %SB6.SQLNAME% ON "
	cQuery += "     D1_FILIAL 		= B6_FILIAL "
	cQuery += " 	AND D1_NUMSEQ 	= B6_IDENT "
	cQuery += " WHERE "
	cQuery += " 	%SD1.XFILIAL%"
	cQuery += "		AND %SD1.NOTDEL%"
	cQuery += "     AND D1_DOC 		= '"+cDoc+"' "
	cQuery += "     AND D1_SERIE 	= '"+cSerie+"' "
	cQuery += "     AND D1_ITEM 	= '"+cItem+"' "
	cQuery += "     AND D1_FORNECE 	= '"+cCliFor+"' "
	cQuery += "     AND D1_LOJA 	= '"+cLoja+"' "
	cQuery += "     AND D1_COD 		= '"+cProduto+"' "
	
return (cQuery)


/*
** Geração do Pedido de venda
*/
static function salesOrder(lCreate)
	local oUtils    := IpUtilsObject():newIpUtilsObject()
	local cAuxMod	:= 0
	
	lMsErroAuto := .f.
	
	lCreate := .t.
	
	if !empty(aItems)
		cAuxMod := cModulo
		cModulo := 05
		MsExecAuto({|x,y,z| MATA410(x,y,z)}, aHeader, aItems, 3)
		
		cModulo := cAuxMod 
		
		if lMsErroAuto
			aadd(aLog,oUtils:getErroAuto())	
		else
		
		endIf
		aHeader := {}
		aItems	:= {}	
	endif

return


/*
** Gravação de log
*/
static function saveLog()
	Local 	oLog
	Local 	nCntLog		:= 0
	Local 	cDirLog		:= "\cutover\"
	local 	cArqLog		:= DTOS(dDataBase)+"_"+Subst(Time(),1,2) + Subst(Time(),4,2) + Subst(Time(),7,2)+"_CUTOVER"
	
	if len(aLog) > 0 
		oLog := SCLogger():New(cDirLog,cArqLog )
		oLog:StartProcess()
		For nCntLog := 1 To Len(aLog)
			oLog:WriteStr(aLog[nCntLog]+CRLF,.F.,.F.)
		Next nCntLog
		oLog:EndProcess()
		msgInfo("Verifique arquivo de log!")
	endif
return


/*
** Valida a existência de fornecedor
*/
static function vldCliFor(cCliFor, cLoja)
	local lRet := .t.
	
	if empty(cCliFor) .or. empty(cCliFor)
		lRet := .f.
	endif
return(lRet)


/*
** Coleta chave para verificação da sequencia atual 
*/
static function getKeyCurrent(aItem)
	local cKey := ""
	
	cKey := padl(alltrim(aItem[NUMERO_NF]), tamsx3("F1_DOC")[1], '0') + padr(alltrim(aItem[SERIE_NF]), tamsx3("F1_SERIE")[1], ' ') + formatCnpj(aItem[CNPJ_PROPRIETARIO])

return(cKey)


/*
** Controla sequencial de itens do pedido
*/
static function getItem()
	local nPosItem	:= aScan( aItems[len(aItems)], { |x| AllTrim( x[1] ) == "C6_ITEM" } )
	local cLast		:= aItems[len(aItems), nPosItem, 2]
	local cRet		:= ""
	
	cRet := soma1(cLast)
	
return(cRet)


/**
 * Coleta o próximo número de pedidos de vendas
 */
static function getNextSalesOrderNumber()
	
	local cMaxNumber  := ""
	local cNextNumber := ""
	local oSql		  := IpSqlObject():newIpSqlObject()
	
	oSql:newAlias(" SELECT MAX(C5_NUM) MAXNUMBER "+;
				  " FROM %SC5.SQLNAME% "+;
				  " WHERE %SC5.XFILIAL% ")
	
	cMaxNumber := oSql:getValue("MAXNUMBER")
	
	if Empty(cMaxNumber)
		cNextNumber := StrZero(1, Len(SC5->C5_NUM))
	else
		cNextNumber := Soma1(cMaxNumber)
	endIf
	
	oSql:close()
	
return cNextNumber


/*
** Formata Cnpj
*/
static function formatCnpj(cCnpj)
	local cRetCnpj := ""
	if len(alltrim(cCnpj)) > 14 
		cRetCnpj := right(alltrim(cCnpj), 14)
	else 
		cRetCnpj := alltrim(cCnpj)
	endif
return(cRetCnpj)