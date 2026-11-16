#include "totvs.ch"
#include "oracle_gl.ch"
#include "dhl.ch"
#include "rwmake.ch"

#define DHL_DEBITO "1"
#define DHL_CREDITO "2"

/*/{Protheus.doc} ExpOraGL

Rotina responsável pela integração com Oracle GL
	
@author Diego de Angelo
@since 28/10/2014

/*/
user function ExpOraGL()
	
	private oParamBox	:= nil
	private oLog 		:= DHLLogManager():newDHLLogManager()
	private lErro		:= .F.
	private aErros		:= {}
	private cCnpj		:= ""
	private cOrgId		:= ""
	private cLoteDe		:= ""
	private cLoteAte	:= ""
	private cSbLoteDe	:= ""
	private cSbLoteAte	:= ""
	private dDataDe		:= ""
	private dDataAte	:= ""
	private cDocDe		:= ""
	private cDocAte		:= ""
	
	
	private cItemLcto	:= ""
	
	if !filialOk()
		return
	endif
	
	if !exibeParametros()
		MsgBox("Processamento abortado", "Atenção", "ALERT") 
		return .F.
	endif
	Processa( {|| processaLote() }, "Aguarde...", "Processando...",.F.)
return


/*
*	Função responsável pelo processamento das notas fiscais.
*/
static function processaLote()
	
	local oSqlLancCont	:= IpSqlObject():newIpSqlObject()
	local cQryLancCont	:= getLanctoCont()
	local cLinhaTrailler	:= ""
	local cLinhaLctoCont	:= ""
	local oArquivo		:= nil
	local nTotRegs		:= 0	
	local nRegsLcto		:= 0
	local nRegsHeader		:= 1
	local nRegsTrailler	:= 1 
	local nRegs			:= 0
	local nTotCred		:= 0
	local nTotDeb			:= 0
	local cErroLote		:= ""

	cCnpj	:= retCnpj(cFilAnt)
	
	oSqlLancCont:newAlias(cQryLancCont)
	
	if oSqlLancCont:isEof()
		MsgBox("Lote não encontrado.", "Aviso", "INFO")
		return .f.
	endif
	
	nRegs := oSqlLancCont:count()

	ProcRegua(nRegs)
	
	cLote		:= alltrim(oSqlLancCont:getValue("CT2_LOTE"))
	
	if !criaArquivo(@oArquivo)
		return .f.
	endif
	
	cLinhaHeader	:= criaHeader()
	
	oArquivo:writeLine(cLinhaHeader)
	
	while oSqlLancCont:notIsEof()
		cItemLcto	:= alltrim(oSqlLancCont:getValue("CT2_LINHA"))
			
		IncProc("Processando [Lote: "+ alltrim(cLote)+"] ...")
		
		cLinhaLctoCont	:= criaLctoCont(oSqlLancCont,@nTotCred, @nTotDeb)		
		oArquivo:writeLine(cLinhaLctoCont)
	
		nRegsLcto++
		oSqlLancCont:skip()
	endDo
	
	nTotReg	:= nRegsHeader + nRegsTrailler + nRegsLcto
	
	oSqlLancCont:close()
	
	cLinhaTrailler	:= criaTrailler(nTotReg, nTotDeb, nTotCred)
	oArquivo:writeLine(cLinhaTrailler)
	
	if lErro .OR. !alteraStatusLcto() .OR. !copiaArquivo(@oArquivo)
		oLog:start(APP_ORACLE_GL, DHL_EXPORTACAO)
		cErroLote	+= "Registro LOG: " + oLog:getId() + " Lote: " + cLote + CRLF
		oLog:fail("Validação dos Campos",retornaErro())
	endif
	
	oArquivo:delete()	
	
	if lErro
		Aviso("Atenção","Os lotes abaixo não foram processados, verifique a tabela de log. "  + CRLF + cErroLote ,{"OK"},3)	
	else
		MsgBox("Lote processado com sucesso.", "Aviso", "INFO")
	endif
return


/*
*	Criação da string da seção Header
*/
static function criaHeader()
	local aLinha 	:= Array(HEADER_TOTAL_CAMPOS_HEADER)
	local cLinha	:= ""
	
	setValorLinha(@aLinha,HEADER_TIPO_DE_LINHA	, "1"	)
 	setValorLinha(@aLinha,HEADER_IDENTIFICACAO	, "INTERFACEGL")
 	setValorLinha(@aLinha,HEADER_DATA				, dDataBase)
 	
	cLinha	:= criaLinha(aLinha)
return cLinha


/*
*	Função responsável pela criação da string da seção lançamentos
*/
static function criaLctoCont(oSqlLancCont, nTotCred, nTotDeb)
	
	local aLinha 		:= Array(LANC_TOTAL_CAMPOS_LANC)
	local cLinha		:= ""
	local nValorDeb	:= 0
	local nValorCred	:= 0
	local cChave		:= oSqlLancCont:getValue("CT2_DATA") + oSqlLancCont:getValue("CT2_LOTE") + oSqlLancCont:getValue("CT2_DOC")
	
	if oSqlLancCont:getValue("CT2_DC") == DHL_DEBITO
		cItem		:= oSqlLancCont:getValue("CT2_ITEMD")
		cCCusto	:= oSqlLancCont:getValue("CT2_CCD")
		cClassVlr	:= oSqlLancCont:getValue("CT2_CLVLDB")
		cConta		:= oSqlLancCont:getValue("CT2_DEBITO")
		cEntCont5	:= oSqlLancCont:getValue("CT2_EC05DB")
		cEntCont6	:= oSqlLancCont:getValue("CT2_EC06DB")
		nValorDeb	:= oSqlLancCont:getValue("CT2_VALOR")
		nTotDeb	+= nValorDeb
	else
		if oSqlLancCont:getValue("CT2_DC") == DHL_CREDITO
			nValorCred	:= oSqlLancCont:getValue("CT2_VALOR")
		endif
		cItem		:= oSqlLancCont:getValue("CT2_ITEMC")
		cCCusto	:= oSqlLancCont:getValue("CT2_CCC")
		cClassVlr	:= oSqlLancCont:getValue("CT2_CLVLCR")
		cConta		:= oSqlLancCont:getValue("CT2_CREDIT")
		cEntCont5	:= oSqlLancCont:getValue("CT2_EC05CR")
		cEntCont6	:= oSqlLancCont:getValue("CT2_EC06CR")
		nTotCred	+= nValorCred
	endif
	
	setValorLinha(@aLinha,LANC_TIPO_DE_LINHA						,"2")
	setValorLinha(@aLinha,LANC_STATUS								,"NEW")
	setValorLinha(@aLinha,LANC_LEDGER_ID							,superGetMv("ZZ_OFBOOKS",.T.,""))
	setValorLinha(@aLinha,LANC_CURRENCY_CODE						,"BRL")
	setValorLinha(@aLinha,LANC_DATE_CREATED						,dDataBase)
	setValorLinha(@aLinha,LANC_ACCOUNTING_DATE					,oSqlLancCont:getValue("CT2_DATA"))
	setValorLinha(@aLinha,LANC_ACTUAL_FLAG							,"A")
	setValorLinha(@aLinha,LANC_USER_JE_CATEGORY_NAME				,superGetMv("ZZ_UCATORA",.T.,""))
	setValorLinha(@aLinha,LANC_USER_JE_SOURCE_NAME				,"PROTHEUS")
	setValorLinha(@aLinha,LANC_SEGMENT1							,cItem)
	setValorLinha(@aLinha,LANC_SEGMENT2							,cCCusto)
	setValorLinha(@aLinha,LANC_SEGMENT3							,cClassVlr)
	setValorLinha(@aLinha,LANC_SEGMENT4							,cConta)
	setValorLinha(@aLinha,LANC_SEGMENT5							,cEntCont5)
	setValorLinha(@aLinha,LANC_SEGMENT6							,cEntCont6)
	setValorLinha(@aLinha,LANC_ENTERED_DR							,nValorDeb)
	setValorLinha(@aLinha,LANC_ENTERED_CR							,nValorCred)
	setValorLinha(@aLinha,LANC_ACCOUNTED_DR						,nValorDeb)
	setValorLinha(@aLinha,LANC_ACCOUNTED_CR						,nValorCred)
	setValorLinha(@aLinha,LANC_REFERENCE1							,oSqlLancCont:getValue("CT2_LOTE"))
	setValorLinha(@aLinha,LANC_REFERENCE4							,cChave)
	setValorLinha(@aLinha,LANC_REFERENCE10							,oSqlLancCont:getValue("CT2_ZZHIST"))
	setValorLinha(@aLinha,LANC_SET_OF_BOOKS_ID					,superGetMv("ZZ_OFBOOKS",.T.,""))

	cLinha	:= criaLinha(aLinha)
return cLinha


/*
*	Função responsável pela criação da string da seção Trailler
*/
static function criaTrailler(nTotReg, nTotDeb, nTotCred)
	
	local aLinha 		:= Array(TRAILLER_TOTAL_CAMPOS_TRAILLER)
	local cLinha		:= ""
	
	setValorLinha(@aLinha,TRAILLER_TIPO_DE_LINHA 		, "9")	
	setValorLinha(@aLinha,TRAILLER_TOTAL_DE_REGISTROS, nTotReg)	
	setValorLinha(@aLinha,TRAILLER_TOTAL_A_DEBITO 	, nTotDeb)	
	setValorLinha(@aLinha,TRAILLER_TOTAL_A_CREDITO 	, nTotCred)	
	
	cLinha	:= criaLinha(aLinha)
return cLinha


/*
*	Função responsável pelo tratamento dos valores de acordo com o tipo.
*/
static function trataValor(xValor)
	local oTrataValor	:= DHLLibrary():newDHLLibrary()
	if ValType(xValor) == "N"
		xValor	:= cValToChar(oTrataValor:fatorNumber(xValor))
	elseif ValType(xValor) == "D"
		xValor	:= DtoS(xValor)
	elseif ValType(xValor) == "C"
		xValor	:= alltrim(xValor)
	endif
return xValor


/*
*	Função responsável pelo retorno do CNPJ de acordo com a filial logada / executada via job.
*/
static function retCnpj(cFilAtu)
	local cCnpj		:= ""
	local aArea		:= GetArea()
	local aAreaSM0	:= SM0->(GetArea())
	 
	DbSelectArea("SM0")
	SM0->(DBGoTop())
	
	while SM0->(!eof())
		if alltrim(SM0->M0_CODFIL) == alltrim(cFilAtu)
			cCnpj	:= alltrim(SM0->M0_CGC)
			exit
		endif
		SM0->(dbSkip())
	endDo
	
	restArea(aAreaSM0)
	restArea(aArea)
return	cCnpj


/*
*	Função responsável pela validação da filial.
**	Alterado por Cassiano em 04/01/2016 - mudança da logica para considerar consulta em cadastro pesonalizado de filiais autorizadas
*/
static function filialOk()
	//local lOk  := aScan(DHL_FILIAIS_AUTORIZADAS,cFilAnt) > 0
	local lOk	:= .F.
	local cMsg	:= "Filial não autorizada."
	local cAlias	:= getNextAlias()

	beginSql Alias cAlias
		SELECT Z7_FILORAC
		  FROM %TABLE:SZ7% Z7
		 WHERE Z7_FILIAL = ' '
		   AND Z7_TIPO = 'GL'
		   AND Z7_FILORAC = %EXP:cFilAnt%
		   AND Z7.%NOTDEL%
	endSql
	(cAlias)->(dbGoTop())
	
	lOk :=  !(cAlias)->(eof())
	
	if !(lOk)
		oLog:start(APP_ORACLE_AR, DHL_EXPORTACAO)
		oLog:warn(cMsg, cMsg)
		
		MsgBox(cMsg,"Atenção","ALERT")
	endif	

	(cAlias)->(dbCloseArea())
return lOk


/*
*	Função responsável pela criação do arquivo no diretório temp.
*/
static function criaArquivo(oArquivo)
	
	local cHora		 := StrTran(Time(),":","")
	local cData		 := DtoS(dDataBase)
	local lRet		 := .T.
	local cLog		 := ""
	local cArqOrigem := ""	
	local cNomeArq   := ""
	
	cNomeArq	:= "ORA_GL_"+cCnpj+"_"+cData+"_"+cHora+"_"+cLote+".TXT
	cArqOrigem	:= getFilePath(cNomeArq)
	oArquivo	:= IpFileObject():newIpFileObject(cArqOrigem)
	
	lRet	:= oArquivo:writeLine("")
	
	if !lRet
		lErro	:= .T.
		cLog	:= "Não foi possível criar o arquivo ("+cNomeArq+")"
		salvaErro(cLog)
	else
		oArquivo:goTop()
	endif
		
return lRet


/*
*	Função responsável pela realização da cópia do arquivo.
*/
static function copiaArquivo(oArquivo)
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local cDirExp		:= alltrim(oSqlUtil:getFieldValue("SZ1", "Z1_DIREXP", "Z1_FILIAL = '%SZ1.FILIAL%' AND %SZ1.NOTDEL% AND SZ1.Z1_CODIGO ='"+APP_ORACLE_GL+"'"))
	local cLog			:= "Diretório não encontrado."
	local lRet			:= .T.
	local cNomeArq	:= oArquivo:getFileName()
	
	lRet	:= oArquivo:copy(cDirExp+cNomeArq)
	
	if !lRet	
		lErro	:= .T.
		salvaErro(cLog)
	endif
return lRet


/*
*	Função responsável pelo retorno das classes contábeis do item da nota fiscal.
*/
static function getLanctoCont()
	local cQuery	:= ""
	local cLote		:= SuperGetMv("ZZ_LTORAGL",, "EST001")
	
	dDataDe		:= oParamBox:getValue("dataDe")	
	dDataAte	:= oParamBox:getValue("dataAte")			
	
	cQuery	:= "SELECT 
	cQuery	+= "	CT2_DOC, " + CRLF
	cQuery	+= "	CT2_DATA, " + CRLF
	cQuery	+= "	CT2_LINHA, " + CRLF
	cQuery	+= "	CT2_VALOR, " + CRLF
	cQuery	+= "	CT2_LOTE, " + CRLF
	cQuery	+= "	CT2_ZZHIST, " + CRLF
	cQuery	+= "	CT2_ITEMD, " + CRLF
	cQuery	+= "	CT2_ITEMC, " + CRLF
	cQuery	+= "	CT2_CCD, " + CRLF
	cQuery	+= "	CT2_CCC, " + CRLF
	cQuery	+= "	CT2_DC, " + CRLF
	cQuery	+= "	CT2_EC06DB, " + CRLF
	cQuery	+= "	CT2_EC06CR, " + CRLF
	cQuery	+= "	CT2_CLVLCR, " + CRLF
	cQuery	+= "	CT2_CLVLDB, " + CRLF
	cQuery	+= "	CT2_DEBITO, " + CRLF
	cQuery	+= "	CT2_CREDIT, " + CRLF
	cQuery	+= "	CT2_EC05DB, " + CRLF
	cQuery	+= "	CT2_EC05CR " + CRLF
	cQuery	+= "FROM " + CRLF
	cQuery	+= "	%CT2.SQLNAME% " + CRLF
	cQuery	+= " WHERE " + CRLF
	cQuery	+= "	CT2_FILIAL = '%CT2.FILIAL%' " + CRLF	
	cQuery	+= "	AND %CT2.NOTDEL% " + CRLF
	cQuery	+= "	AND CT2_DATA >= '"+DtoS(dDataDe)+"' " + CRLF
	cQuery	+= "	AND CT2_DATA <= '"+DtoS(dDataAte)+"' " + CRLF
	cQuery	+= "	AND CT2_LOTE = '"+cLote+"' " + CRLF

return cQuery
 
 
/*
*	Funçao responsável pela montagem da linha.
*/
 static function criaLinha(aLinha)
 	local nI		:= ""
 	local cLinha	:= ""
 	local xValor	:= nil
 		
 	for nI := 1 to Len(aLinha)
		xValor := aLinha[nI]		
		if ValType(xValor) != "U"
			cLinha += xValor
		endif
		cLinha += ";"
	next nI	
		
return cLinha		


/*
*	Função responsável pela atriguição do valor para a posição do array.
*/
static function setValorLinha(aLinha, aPosicao, xValor)
	
	local nPos    := aPosicao[1]
	local cTitulo := aPosicao[2]
	
	if ValType(xValor) != "U"
		xValor	:= trataValor(xValor)
		if Empty(xValor)
			lErro	:= .T.
			geraLog(cTitulo)
		else
			aLinha[nPos] := xValor
		endif
	endif
	
return


/*
*	Atibui o valor para a posição do array.
*/
static function geraLog(cTitulo)
	local cLog	:=  "Campo(s) não preenchidos: " + cTitulo + " Lote: " + cLote + " Linha Lcto.: " + cItemLcto
	salvaErro(cLog)
return


/*
*	Função responsável pela exibição da tela de parâmetros.
*/
static function exibeParametros()
	local cNome		:= "ExpOraGL" 
	local cTitulo		:= "Informe o Lote Contábil"
	
	oParamBox 	:= IpParamBoxObject():newIpParamBoxObject(cNome)
	
	oParamBox:setTitle(cTitulo)
	
	oParam := IpParamObject():newIpParamObject("dataDe", "get", "Data de:", "D", 9, 10)
	oParam:setRequired(.F.)
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataAte", "get", "Data até:", "D", 9, 10)
	oParam:setRequired(.F.)
	oParamBox:addParam(oParam)
	
return oParamBox:show()


/*
*	Função responsável pelo preenchimento do array de erros.
*/
static function salvaErro(cLog)
	aADD(aErros, cLog)
return 


/*
*	Função responsável pelo retorno da string com todos os erros gerados durante o processo.
*/
static function retornaErro()
	local nI	:= 1
	local cLog	:= ""
	
	for nI := 1 to Len(aErros)
		cLog	+= aErros[nI] + CRLF
	next nI
return cLog


/*
*	Função responsável pela alteração do lançamento para processado.
*/
static function alteraStatusLcto()
	local oSqlUtil := IpSqlObject():newIpSqlObject()
	local lRet	:= oSqlUtil:update("CT2", "CT2_ZZSTOR = 'S'", "CT2_LOTE = '"+cLote+"' AND CT2_FILIAL = '%CT2.FILIAL%'")
	local cLog	:= "Falha ao alterar status do lançamento processado. Lote: " + cLote
	
	if !lRet
		lErro	:= .T.
		salvaErro(cLog)
	endif
return lRet


/**
* Retorna o caminho dos arquivos do Oracle GL
**/
static function getFilePath(cNomeArq)

	local oSql   := ipSqlObject():newIpSqlObject()
	local oUtils := IpUtilsObject():newIpUtilsObject()
	local cPath  := ""
	
	cPath := AllTrim(oSql:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '" + APP_ORACLE_GL + "'"))
	
	cPath := oUtils:concatDirectory(cPath,cNomeArq)
	
return cPath