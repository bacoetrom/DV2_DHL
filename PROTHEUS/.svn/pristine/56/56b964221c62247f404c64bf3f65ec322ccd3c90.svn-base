#include "totvs.ch"
#include "dhl.ch"

#define OPC_INCLUSAO   3

#define PRODUCT        1
#define QUANTITY       2

/*/{Protheus.doc} SplImpInv
Importação da Interface Stock Adjustment - Select New.

@author Diogo Mesquita
@since 29/11/2021

@param cFilePath,Caractere,XML a ser importado

@return Logico Indica se foi importado com sucesso
/*/
user function SplImpInv(cFilePath)

	local lOk 	        	:= .T.
	private cFile       	:= cFilePath	
	private oXml			:= nil
		
	if !parserFile()
		return .F.
	endIf

	private cClieFor		:= ""
	private cLoja			:= ""
	private aItems			:= {}
	private lMsErroAuto		:= .F.
	private lMsHelpAuto		:= .T.
	private lAutoErrNoFile	:= .T.		
	
	lOk := procXml()
	
return lOk


/**
 * Processa os Arquivos
 */
static function procXml()
	
	local lOk  := .T.
	
	if isPreNota()		
		lOk := geraPreNota()
	elseIf isPedidoVenda()
		lOk := geraPedidoVenda()	
	else
		lOk := .F.
		setFileLog(cFile,"fail","Não foi possível definir o movimento de ajuste de estoque a ser gerado")
	endif
								
return lOk

/**
 * Verifica se deve gerar uma Pre-Nota
 */
static function isPreNota()
return Upper(AllTrim(oXml:_STK_ADJ:_BODY:_FILEHEADER:_TYPE:TEXT)) == "P"

/**
 * Verifica se deve gerar um pedido de venda
 */
static function isPedidoVenda()
return Upper(AllTrim(oXml:_STK_ADJ:_BODY:_FILEHEADER:_TYPE:TEXT)) == "N"

/**
 * Gera a Pre-Nota de Entrada
 */
static function geraPreNota(cApp)
	
	local lOk		:= .t.
	local aCab   	:= {}
	local aItens 	:= {}
	local cErro  	:= ""
	local cModuloBkp := cModulo
	
	cModulo := "EIC"
	
	if !getDadosPreNota(@aCab,@aItens)
		return .f.
	endIf

	aItens	:= u_ProcDesNF(aItens)

	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| MATA140(x,y,z)},aCab,aItens,OPC_INCLUSAO)
	
	cModulo := cModuloBkp
	
	if lMsErroAuto
		RollBackSX8()
		cErro := mostraErroRotAuto()
		lOk := .f.
		setFileLog(cFile,"fail","Erro na rotina automática MATA140"+CRLF+CRLF+cErro)
	else
		ConfirmSX8()
	endif
	
return lOk

/**
 * Gera o pedido de venda
 */
static function geraPedidoVenda()
	
	local lOk    := .t.
	local aCab   := {}
	local aItens := {}
	local cErro  := ""
	
	if !getDadosPedVenda(@aCab,@aItens)
		return .f.
	endIf
	 
	aItens	:= u_ProcDesNF(aItens,.T.)
	
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| MATA410(x,y,z)},aCab,aItens,OPC_INCLUSAO)
	
	if lMsErroAuto
		cErro := mostraErroRotAuto()
		lOk	  := .f.
		setFileLog(cFile,"fail","Erro na rotina automática MATA410"+CRLF+CRLF+cErro)
	endif
		
return lOk

/**
 * Obtem os arrays da rotina automática de pré nota de entrada
 */
static function getDadosPreNota(aCab,aItens)

	local oSql		 := IpSqlObject():newIpSqlObject()
	local cControle  := ""
	local cCodProd 	 := ""
	local cSerie 	 := DHL_SERIE_INVENTARIO
	local cTipoNf  	 := SuperGetMv("MV_TPNRNFS")
	local cNumero	 := ""
	local cItem 	 := StrZero(0,TamSx3("D1_ITEM")[1])
	local cTes		 := GetMv("ZZ_TESENT")
	local nQuant 	 := 0	
	local nVUnit 	 := 0
	local aAux 		 := {}
	local nI		 := 0
	
	if !getItems()
		return .f.
	endIf

	cControle := allTrim(oXml:_STK_ADJ:_BODY:_FILEHEADER:_ADJUSTMENT_ID:TEXT)		
	
	SX3->(DbSetOrder(1))
	if (SX3->(dbSeek("SD9"))) .And. cTipoNf == "3"
		cNumero := MA461NumNf(.T., cSerie)	
	elseIf cTipoNf == "1"
		cNumero := NxtSX5Nota(cSerie, NIL, cTipoNf)	
	else
		setFileLog(cFile,"fail","Não foi possível atribuir número de NF! Verifique o conteúdo do parâmetro MV_TPNRNFS")
		return .f.
	endIf
	
	aAdd(aCab,{"F1_FILIAL"  ,xFilial("SF1")				,nil})
	aAdd(aCab,{"F1_DOC"     ,cNumero				 	,nil})
	aAdd(aCab,{"F1_SERIE"   ,cSerie       				,nil})
	aAdd(aCab,{"F1_FORNECE" ,cClieFor					,nil})
	aAdd(aCab,{"F1_LOJA"    ,cLoja 						,nil})
	aAdd(aCab,{"F1_EMISSAO" ,dDataBase 		            ,nil})
	aAdd(aCab,{"F1_TIPO"    ,"B"       		            ,nil})
	aAdd(aCab,{"F1_FORMUL"  ,"S"       		            ,nil})
	aAdd(aCab,{"F1_ESPECIE" ,"INV"      		        ,nil})			
	aAdd(aCab,{"F1_ZZADJID"	,cControle 		            ,nil})
	
	for nI := 1 to Len(aItems)
	
		cCodProd := aItems[nI,PRODUCT]
		nQuant   := aItems[nI,QUANTITY]
		
		oSql:newTable("SB1","B1_COD,B1_LOCPAD","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+cCodProd+"'")
		
		nVUnit := retVUnit(cCodProd)
		
		oSql:close()
	
		aAux  := {}			
		cItem := Soma1(cItem)

		aAdd(aAux,{"D1_ITEM"  ,cItem		 	 ,nil})
		aAdd(aAux,{"D1_COD"   ,cCodProd	 	 	 ,nil})
		aAdd(aAux,{"D1_QUANT" ,nQuant		 	 ,nil})
		aAdd(aAux,{"D1_VUNIT" ,nVUnit		 	 ,nil})
		aAdd(aAux,{"D1_TOTAL" ,nQuant * nVUnit 	 ,nil})
		aAdd(aAux,{"D1_TES"   ,cTes				 ,nil})

		aAdd(aItens,aAux)
		
	next
	
return .t.

/**
 * Obtem os arrays da rotina automática de pedido de venda
 */
static function getDadosPedVenda(aCab,aItens)

	local oSql		 := IpSqlObject():newIpSqlObject()
	local cControle  := ""
	local cCodProd 	 := ""
	local cItem 	 := StrZero(0,TamSx3("C6_ITEM")[1])
	local cTes		 := GetNewPar("ZZ_TESSAI", "")
	local nQuant 	 := 0
	local nVUnit 	 := 0
	local aAux 		 := {}
	local nI		 := 0
	
	if !getItems()
		return .f.
	endIf

	cControle := allTrim(oXml:_STK_ADJ:_BODY:_FILEHEADER:_ADJUSTMENT_ID:TEXT)		
	
	aAdd(aCab,{"C5_FILIAL"  ,xFilial("SC5")				  ,nil})
	aAdd(aCab,{"C5_TIPO" 	,"N"       					  ,nil})
	aAdd(aCab,{"C5_CLIENTE" ,cClieFor  					  ,nil})
	aAdd(aCab,{"C5_LOJACLI" ,cLoja 						  ,nil})
	aAdd(aCab,{"C5_CONDPAG"	,AllTrim(GetMv("ZZ_CONDINT")) ,nil})
	aAdd(aCab,{"C5_ZZADJID"	,cControle 		              ,nil})
	aAdd(aCab,{"C5_ZZESPEC" ,"INV"       		          ,nil})	
	
	for nI := 1 to Len(aItems)
	
		cCodProd := aItems[nI,PRODUCT]
		nQuant   := Abs(aItems[nI,QUANTITY])
		
		oSql:newTable("SB1","B1_COD,B1_LOCPAD","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+cCodProd+"'")
		
		nVUnit := oSql:getFieldValue("SB2","B2_CM1","B2_FILIAL = '"+xFilial("SB2")+"' AND B2_COD = '"+oSql:getValue("B1_COD")+"' AND B2_LOCAL = '"+oSql:getValue("B1_LOCPAD")+"'")
		
		oSql:close()
	
		aAux  := {}			
		cItem := Soma1(cItem)
		
		aAdd(aAux,{"C6_ITEM"    ,cItem		 	 	,nil})
		aAdd(aAux,{"C6_PRODUTO" ,cCodProd		  	,nil})
		aAdd(aAux,{"C6_QTDVEN"  ,nQuant		 	    ,nil})
		aAdd(aAux,{"C6_PRCVEN"  ,nVUnit		 	    ,nil})
		aAdd(aAux,{"C6_TES"     ,cTes				,nil})

		aAdd(aItens,aAux)
		
	next
	
return .t.

/**
 *	Retorna o erro da rotina automática
 */
static function mostraErroRotAuto()

	local aErro  := {}
	local nI 	 := 0
	local cError := ""
	
	aErro := GetAutoGRLog()
	
    for nI := 1 to Len(aErro)
    	cError += aErro[nI] +CRLF
    next nI

return cError

/* 
** Retorna valor unitário através de LIFO
*/
static function retVUnit(cCodProd)
	local oSql	:= IpSqlObject():newIpSqlObject()
	local cQuery 	:= ""	
	local nRet		:= 0
	
	cQuery += " Select * from (SELECT MAX(SD1.R_E_C_N_O_) RECNO, D1_VUNIT, D1_VALIPI, D1_ICMSRET FROM %SD1.SQLNAME%       "+CRLF
	cQuery += " INNER JOIN %SF4.SQLNAME% ON                                                      "+CRLF
	cQuery += " 	%SF4.NOTDEL%                                                                 "+CRLF
	cQuery += " 	AND D1_FILIAL 	= F4_FILIAL                                                  "+CRLF
	cQuery += " 	AND D1_TES 		= F4_CODIGO                                                  "+CRLF
	cQuery += " 	AND F4_ZZSTATU 	=  'G'                                                       "+CRLF
	cQuery += " WHERE                                                                            "+CRLF
	cQuery += " 	%SD1.NOTDEL%                                                                 "+CRLF
	cQuery += " 	AND %SD1.XFILIAL%                                                            "+CRLF
	cQuery += " 	AND D1_COD 			= '"+cCodProd+"'                                         "+CRLF
	cQuery += " 	AND D1_FORNECE		= '"+cClieFor+"'   										 "+CRLF
	cQuery += " 	AND D1_LOJA			= '"+cLoja+"' 											 "+CRLF
	cQuery += " GROUP BY D1_VUNIT, D1_VALIPI, D1_ICMSRET Order by RECNO DESC) Where rownum = 1   "+CRLF
	
	oSql:newAlias(cQuery)
	
	if oSql:hasRecords()
		if GetNewPar("ZZ_ICSTDEV", .T.)
			nRet := oSql:getValue("D1_VUNIT") + oSql:getValue("D1_VALIPI") + oSql:getValue("D1_ICMSRET")
		else
			nRet := oSql:getValue("D1_VUNIT") + oSql:getValue("D1_VALIPI")
		endif
	endif
	
	oSql:close() 
return(nRet)

/**
* Faz o parser do arquivo xml
**/
static function parserFile()

	local cError    := ""
	local cWarning  := ""
	local lParsed	:= .T.

	oXml := XmlParserFile(cFile,"_",@cError,@cWarning)

	if !(Empty(cError)) .or. !(Empty(cWarning))	
		lParsed:= .F.
		setFileLog(cFile,"fail","Falha no parser do arquivo " + cFile+CRLF+CRLF+cError+CRLF+CRLF+cWarning)
	endif

return lParsed

/**
* Define os Logs de acordo com os tipos de arquivos
*/
static function setFileLog(cFile,cLogType,cLogText,cTag,cValue)

	local cInterface := "Stock Adjustment - Select New"
	
	if !(Empty(cTag))
		cLogText += CRLF+CRLF+"Tag: "+cTag
	endIf

	if !(Empty(cValue))
		cLogText += CRLF+CRLF+"Valor: "+cValue
	endIf

	if (cLogType == "fail")
		oLog:fail(cInterface,cLogText)
	elseIf (cLogType == "warn")
		oLog:warn(cInterface,cLogText)
	endIf	

return

/**
* Coleta os itens da interface
**/
static function getItems()
	local lOk		:= .t.
	local nItem		:= 1
	local nLength	:= 0
	local nPos		:= 0
	local cProduto	:= ""
	
	if ValType(oXml:_STK_ADJ:_BODY:_FILEHEADER) == "A"
		nLength := Len(oXml:_STK_ADJ:_BODY:_FILEHEADER)
		for nItem := 1 to nLength
			cProduto := doDePara(oXml:_STK_ADJ:_BODY:_FILEHEADER[nItem]:_ITEM:TEXT)
			if !empty(cProduto)
				nPos := aScan(aItems,{|x| upper(alltrim(x[PRODUCT])) == upper(alltrim(cProduto))})
				
				if nPos == 0
					aAdd(aItems,{cProduto,Val(oXml:_STK_ADJ:_BODY:_FILEHEADER[nItem]:_QUANTITY:TEXT)})
				else
					aItems[nPos][QUANTITY] += Val(oXml:_STK_ADJ:_BODY:_FILEHEADER[nItem]:_QUANTITY:TEXT)
				endif
			else
				lOk := .f.
				setFileLog(cFile,"fail","Não foi possível identificar a Amarração Produto x Cliente para o Código do Produto no Cliente "+cCodPrdCli)
				exit
			endIf
		next
	else
		cProduto := doDePara(oXml:_STK_ADJ:_BODY:_FILEHEADER:_ITEM:TEXT)
		if !empty(cProduto)
			aAdd(aItems,{cProduto,Val(oXml:_STK_ADJ:_BODY:_FILEHEADER:_QUANTITY:TEXT)})
		else
			lOk := .f.
			setFileLog(cFile,"fail","Não foi possível identificar a Amarração Produto x Cliente para o Código do Produto no Cliente "+cCodPrdCli)
		endIf
	endif

return lOk

/**
* Obtém o código do produto, cliente e loja
**/
static function doDePara(cCodPrdCli)
	
	local oSql	:= IpSqlObject():newIpSqlObject()
	local cRet	:= ""
	
	oSql:newTable("SA7","A7_PRODUTO, A7_CLIENTE, A7_LOJA","A7_FILIAL = '"+xFilial("SA7")+"' AND A7_CODCLI = '"+cCodPrdCli+"'")
		
	if oSql:notIsEof()
		cRet := oSql:GetValue("A7_PRODUTO")
		if empty(cClieFor) .and. empty(cLoja)
			cClieFor := oSql:GetValue("A7_CLIENTE")
			cLoja	 := oSql:GetValue("A7_LOJA")
		endIf
	endIf
		
	oSql:close()
	
return cRet
