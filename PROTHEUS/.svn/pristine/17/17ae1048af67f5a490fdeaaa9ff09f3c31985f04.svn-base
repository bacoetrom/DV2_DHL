#include 'Protheus.ch'
#include 'dhl.ch'
#include 'cutover.ch'

#define ALTER_INVOICE 4

/*/{Protheus.doc} ClassCutover

Realiza o ajuste e a classificação das Pré Notas
	
@author Thiago Meschiatti
@since 20/02/2015

/*/
user function ClassCutover()
	local cArqTxt 		:= ""
	local lExeFun		
	local aArrSay 		:= {}
	local aArrBut 		:= {}
	
	private aHeader	 	:= {}
	private aDetails	:= {}
	private lMsErroAuto := .F.
	
	aadd(aArrSay, 'Esta rotina tem por objetivo classificar Pré Notas de Entrada que foram importadas ')
	aadd(aArrSay, 'para o processo de Cutover.')
	 
	aadd(aArrBut, {1, .T., {|| lExeFun := .T., FechaBatch()}})
	aadd(aArrBut, {2, .T., {|| lExeFun := .F., FechaBatch()}})
	 
	FormBatch('Classificação Cutover', aArrSay, aArrBut)
	
	if lExeFun
		Processa( {|| processInvoice() }, "Aguarde...", "Processando...",.F.)
	endif
return


/*
** 
*/
static function processInvoice()
	local oFile 		:= nil	
	local cQuery		:= "" 
	local cChvCurrent	:= ""
	local lClassif		:= .f.
	local aLog			:= {}
	
	private oSql 			:= IpSqlObject():newIpSqlObject()
	
	aNfs 	:= importaArq(oFile)
	cQuery  := getQuery()
	oSql:newAlias(cQuery)
	
	if oSql:hasRecords()
		ProcRegua(oSql:count())
		oSql:goTop()
		cChvCurrent :=  oSql:getValue("F1_FILIAL") + oSql:getValue("F1_DOC") + oSql:getValue("F1_SERIE") + oSql:getValue("F1_FORNECE") +;
						oSql:getValue("F1_LOJA")
		
		while oSql:notIsEof(oSql)
			IncProc("Processando...")	
			lClassif := .f.
			if 	cChvCurrent == (oSql:getValue("F1_FILIAL") + oSql:getValue("F1_DOC") + oSql:getValue("F1_SERIE") + oSql:getValue("F1_FORNECE") +;
				oSql:getValue("F1_LOJA"))				
				
				if empty(aHeader) 
					mountHeader(oSql)
				endif
				mountDetail(oSql, @lClassif)
			else
				classifyInvoice(@lClassif, aNfs, aLog)
				if empty(aHeader) 
					mountHeader(oSql)
				endif
				mountDetail(oSql, @lClassif)
			endif
			
			cChvCurrent :=  oSql:getValue("F1_FILIAL") + oSql:getValue("F1_DOC") + oSql:getValue("F1_SERIE") + oSql:getValue("F1_FORNECE") +;
						oSql:getValue("F1_LOJA")
			
			oSql:skip()		
		end
		if !lClassif
			classifyInvoice(@lClassif, aNfs, aLog)
		endif
	endif
	if len(aLog) > 0
		saveLog(aLog)
	endif
	
return()


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
* Monta o cabelhaço da Nota Fiscal
**/
static function mountHeader(oSql)

	aHeader := { {"F1_TIPO"   ,oSql:getValue("F1_TIPO")   ,nil},;
                 {"F1_FORMUL" ,oSql:getValue("F1_FORMUL") ,nil},;
                 {"F1_DOC"    ,oSql:getValue("F1_DOC")    ,nil},;
                 {"F1_SERIE"  ,oSql:getValue("F1_SERIE")  ,nil},;
                 {"F1_EMISSAO",oSql:getValue("F1_EMISSAO"),nil},;
                 {"F1_DTDIGIT",oSql:getValue("F1_DTDIGIT"),nil},;
                 {"F1_RECBMTO",oSql:getValue("F1_RECBMTO"),nil},;
                 {"F1_FORNECE",oSql:getValue("F1_FORNECE"),nil},;
                 {"F1_LOJA"   ,oSql:getValue("F1_LOJA")   ,nil},;
                 {"F1_COND"   ,oSql:getValue("F1_COND")   ,nil},;
                 {"F1_EST"    ,oSql:getValue("F1_EST")    ,nil},;
                 {"F1_ESPECIE",oSql:getValue("F1_ESPECIE"),nil},; 
                 {"F1_ZZCUTOV",'S'						  ,nil},;
                 {"F1_ZZSTATU",' '						  ,nil}}                 
return

/**
* Monta os items da Nota Fiscal
**/
static function mountDetail(oSql, lClassif)

	local aAreaSD1	:= SD1->(getArea())
	local aDetail	:= {}
	local cKeySD1	:= ""
	local nCount	:= 0
	local aCposSX3	:= FWSX3Util():GetAllFields("SD1",.f.)	
	
	lClassif := .f.
	
	aAdd(aDetail,{"D1_ITEM"   ,oSql:getValue("D1_ITEM")   	,nil})
	aAdd(aDetail,{"D1_COD"    ,oSql:getValue("D1_COD")    	,nil})
	aAdd(aDetail,{"D1_UM"     ,oSql:getValue("D1_UM")     	,nil})
	aAdd(aDetail,{"D1_QUANT"  ,oSql:getValue("D1_QUANT")  	,nil})
	aAdd(aDetail,{"D1_VUNIT"  ,oSql:getValue("D1_VUNIT")  	,nil})
	aAdd(aDetail,{"D1_TOTAL"  ,oSql:getValue("D1_TOTAL")  	,nil})
	aAdd(aDetail,{"D1_LOCAL"  ,oSql:getValue("D1_LOCAL")  	,nil})
	aAdd(aDetail,{"D1_LOTEFOR",oSql:getValue("D1_LOTEFOR")	,nil})
	aAdd(aDetail,{"D1_LOTECTL",oSql:getValue("D1_LOTECTL")	,nil})
	aAdd(aDetail,{"D1_EMISSAO",oSql:getValue("D1_EMISSAO")	,nil})
	aAdd(aDetail,{"D1_TES"    ,GetNewPar("ZZ_TESENCO","0AA"),nil})
	aAdd(aDetail,{"D1_ZZTES"  ,GetNewPar("ZZ_TESENCO","0AA"),nil})

	cKeySD1 :=  oSql:getValue("D1_FILIAL")+oSql:getValue("D1_DOC")+oSql:getValue("D1_SERIE")+oSql:getValue("D1_FORNECE")+oSql:getValue("D1_LOJA")+;
				oSql:getValue("D1_COD")+oSql:getValue("D1_ITEM")
	
	dbSelectArea("SD1") 
	dbSetOrder(1)
	dbSeek(cKeySD1)
	
	for nCount := 1 to len(aCposSX3)
	
		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U" .and. AllTrim(aCposSX3[nCount]) <> "D1_ZZTES" 
			aAdd(aDetail,{AllTrim(aCposSX3[nCount]),&("SD1->" + AllTrim(aCposSX3[nCount])),nil})
		endIf
	
	next nCount
	
	restArea(aAreaSD1)
	
	aAdd(aDetails,aDetail)
	
return


/**
* Coleta o Código do Fornecedor da Nota Fiscal
**/
static function getCnpj(cCliFor, cLoja)
	local cCnpj := ""
	
	cCnpj := AllTrim(oSql:getFieldValue("SA1","A1_CGC","A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '" + cCliFor + "' AND A1_LOJA = '"+cLoja+"'"))
	
	if Empty(cCnpj)
		cCliFor := AllTrim(oSql:getFieldValue("SA2","A2_CGC","A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = '" + cCliFor + "' AND A2_LOJA = '"+cLoja+"'"))
	endif
	
return (cCnpj)


/*
**
*/
static function getQuery()
	local cQuery := ""
	
	cQuery += " SELECT *"                             +CRLF
	cQuery += " FROM %SF1.SQLNAME%"                   +CRLF
	cQuery += " INNER JOIN %SD1.SQLNAME% ON"          +CRLF
	cQuery += "		%SD1.NOTDEL%"                     +CRLF
	cQuery += "		AND D1_FILIAL = F1_FILIAL"        +CRLF
	cQuery += "		AND D1_DOC 		= F1_DOC"         +CRLF
	cQuery += "		AND D1_SERIE 	= F1_SERIE"       +CRLF
	cQuery += "		AND D1_FORNECE	= F1_FORNECE"     +CRLF
	cQuery += "		AND D1_LOJA		= F1_LOJA"        +CRLF
	cQuery += "		AND D1_TES		= '"+CriaVar("D1_TES", .F.)+"'"        +CRLF
	cQuery += " WHERE"                                +CRLF
	cQuery += "		%SF1.NOTDEL%"                     +CRLF
	cQuery += "		AND %SF1.XFILIAL%"                +CRLF
//	cQuery += "		AND F1_DTDIGIT = '20150423' "         +CRLF
	cQuery += " ORDER BY 2 "                +CRLF
	
return (cQuery)


/**
* Classifica a Nota Fiscal de Entrada
**/
static function classifyInvoice(lClassif, aNfs, aLog)
	local oUtils    := IpUtilsObject():newIpUtilsObject()
	local oExeUpd 	:= IpSqlObject():newIpSqlObject()
	local nPosDoc	:= aScan( aHeader, { |x| AllTrim( x[1] ) == "F1_DOC" } )
	local nPosSer	:= aScan( aHeader, { |x| AllTrim( x[1] ) == "F1_SERIE" } )
	local nPosCli	:= aScan( aHeader, { |x| AllTrim( x[1] ) == "F1_FORNECE" } )
	local nPosLoj	:= aScan( aHeader, { |x| AllTrim( x[1] ) == "F1_LOJA" } )
	local cDoc		:= aHeader[nPosDoc, 2]
	local cSerie	:= aHeader[nPosSer, 2]
	local cCliFor	:= aHeader[nPosCli, 2]
	local cLoja		:= aHeader[nPosLoj, 2]
	local lErro		:= .F.

	lMsErroAuto := .F.	

	if Len(aDetails) > 0
		lClassif := .t.
		
		begin transaction
			lErro := updStatus(cDoc, cSerie, cCliFor, cLoja, aNfs)
			
			if lErro
			
				MSExecAuto({ |x,y,z| MATA103(x,y,z) },aHeader,aDetails,ALTER_INVOICE)
				
				if lMsErroAuto
					DisarmTransaction()
					aadd(aLog, {"DOC: "+cDoc+" SERIE: "+cSerie+" CLI/FOR: "+cCliFor+" LOJA: "+cLoja , oUtils:getErroAuto()})
					//mostraerro()
					aHeader		:= {}
					aDetails	:= {}
				else
					if !updDtTrans(cDoc, cSerie, cCliFor, cLoja, aNfs)
						aadd(aLog, {"DOC: "+cDoc+" SERIE: "+cSerie+" CLI/FOR: "+cCliFor+" LOJA: "+cLoja , "Não foi possível alterar a data do documento! Doc. não classificado."})										
						DisarmTransaction()
					end
					aHeader		:= {}
					aDetails	:= {}
				endif
			else
				DisarmTransaction()
			endif
		end transaction
	endif
	
return


/*
** Altera status para efetuar classificação
*/
static function updStatus(cDoc, cSerie, cCliFor, cLoja, aNfs)
	local oExeUpd 	:= IpSqlObject():newIpSqlObject()
	local lRet		:= .T.
	
	lRet := oSql:update("SF1", "F1_ZZSTATU = ' ' ", "%SF1.XFILIAL% AND F1_DOC = '"+cDoc+"' AND F1_SERIE = '"+cSerie+"' AND F1_FORNECE = '"+cCliFor+"' "+;
						" AND F1_LOJA = '"+cLoja+"'")
	
return(lRet)


/*
** Altera data de transação F1_DTDIGIT e D1_DTDIGIT
*/
static function updDtTrans(cDoc, cSerie, cCliFor, cLoja, aNfs)
	local oExeUpd 	:= IpSqlObject():newIpSqlObject()
	local nPosDt	:= 0
	local cCnpj		:= ""
	local lRet		:= .f.
	
	cCnpj := getCnpj(cCliFor, cLoja)
	nPosDt := 	aScan( aNfs, { |x|  right(alltrim(x[CNPJ_PROPRIETARIO]),14) + padl(alltrim(x[NUMERO_NF]), tamsx3("F1_DOC")[1], '0') + padr(alltrim(x[SERIE_NF]), tamsx3("F1_SERIE")[1], ' ')  == ;
				alltrim(cCnpj) + cDoc + cSerie} )
	if nPosDt > 0
		lRet		:= oSql:update("SF1", "F1_DTDIGIT = "+ dTos(cTod(strTran(aNfs[nPosDt,DATA_TRANSACAO],'-','/')))+" ", "%SF1.XFILIAL% AND F1_DOC = '"+cDoc+"' "+;
								   " AND F1_SERIE = '"+cSerie+"' AND F1_FORNECE = '"+cCliFor+"' AND F1_LOJA = '"+cLoja+"'")
		if lRet
			lRet		:= oSql:update("SD1", "D1_DTDIGIT = "+ dTos(cTod(strTran(aNfs[nPosDt,DATA_TRANSACAO], '-', '/')))+" ", "%SD1.XFILIAL% AND D1_DOC = '"+cDoc+"' "+;
								   " AND D1_SERIE = '"+cSerie+"' AND D1_FORNECE = '"+cCliFor+"' AND D1_LOJA = '"+cLoja+"'")
		endif								   
	endif

return(lRet)

/*
** Gravação de log
*/
static function saveLog(aLog)
	Local 	oLog
	Local 	nCntLog		:= 0
	Local	nJ			:= 0
	Local 	cDirLog		:= "\cutover\"
	local 	cArqLog		:= DTOS(dDataBase)+"_"+Subst(Time(),1,2) + Subst(Time(),4,2) + Subst(Time(),7,2)+"_CUTOVER_CLASSIFY"
	
	if len(aLog) > 0 
		oLog := SCLogger():New(cDirLog,cArqLog )
		oLog:StartProcess()
		For nCntLog := 1 To Len(aLog)
			for nJ:=1 to len(aLog[nCntLog])
				oLog:WriteStr(aLog[nCntLog, nJ] + " - ",.F.,.F.)
			next nJ
			oLog:WriteStr(CRLF,.F.,.F.)
		Next nCntLog
		oLog:EndProcess()
		msgInfo("Verifique arquivo de log!")
	endif
return