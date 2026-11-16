#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} IpSqlObject
 
Objeto para manipulação de instruções SQL

@type class	
@author Victor Hugo
@since 11/11/2013
/*/
class IpSqlObject from IpAdvplObject
	
	data cAlias 
	data cLastQuery
	data cLastError
	data cDataBase	
	data aReportCells
	data nErpConnection
	data nExternalConnection			
	
	method newIpSqlObject() constructor
	
	method newAlias()
	method setField()
	method getAlias()
	method getLastQuery()
	method getLastError()
	method getStruct()
	method aliasExists()
	method newTable()
	method close()
	method count()
	method hasRecords()
	method skip()
	method goTop()
	method isEof()
	method notIsEof()
	method getValue()
	method execute()
	method update()	
	method insert()
	method delete()
	method exists()
	method parseQuery()
	method exportToCsv()
	method showReport()
	method setReportCellProperty()	
	method saveQuery()
	method getFieldValue()
	method setErpConnection()
	method setExternalConnection()
	method hasExternalConnection()
	
endClass


/*/{Protheus.doc} newIpSqlObject

Construtor do objeto

@type method
@author Victor Hugo
@since 11/11/2013	
/*/
method newIpSqlObject() class IpSqlObject		
	
	::newIpAdvplObject()
	
	::cLastQuery			:= ""
	::cLastError			:= ""
	::aReportCells			:= {}
	::nErpConnection		:= AdvConnection()
	::nExternalConnection	:= -1
	
return self


/*/{Protheus.doc} newAlias

Gera um novo alias a partir de uma consulta SQL

@type method
@author Victor Hugo
@since 11/11/2013

@param cQuery, String, Consulta SQL
/*/
method newAlias(cQuery) class IpSqlObject			
	
	if ::aliasExists()
		(::cAlias)->(dbCloseArea())
	endIf
	
	::cAlias 	 := GetNextAlias()
	::cLastQuery := cQuery								
	cQuery 		 := ::parseQuery(cQuery)
	
	TCQUERY cQuery NEW ALIAS &::cAlias
			
return


/*/{Protheus.doc} setField

Define o tipo de dado ou precisão, para um campo/coluna do alias. Método equivalente à função TcSetField()
	
@type method	
@author Victor Hugo
@since 04/02/2014

@param cField, String, Campo do alias
@param cType, String, Tipo de dado (C=Caracter, N=Numerico, D=Data ou L=Logico)
@param nSize, Numerico, Tamanho do campo (usado apenas para campos tipo "C" ou "N")
@param nDecimals, Numerico, Decimais de campos numericos
/*/
method setField(cField, cType, nSize, nDecimals) class IpSqlObject
	
	local cAlias		:= ::getAlias()
	default nSize 		:= 0
	default nDecimals	:= 0
	
	if (cType == "D")
		nSize := 8
	elseIf (cType == "L")
		nSize := 1
	endIf		 	
	
	TcSetField(cAlias, cField, cType, nSize, nDecimals)
	
return


/*/{Protheus.doc} getAlias

Retorna o alias do objeto

@type method
@author Victor Hugo
@since 11/11/2013
	
@return String Alias do objeto
/*/
method getAlias() class IpSqlObject
return ::cAlias


/*/{Protheus.doc} getLastQuery

Retorna a ultima query definida para o objeto

@type method
@author Victor Hugo
@since 18/02/2014
	
@return String Ultima query definida
/*/
method getLastQuery() class IpSqlObject
return ::cLastQuery


/*/{Protheus.doc} getLastError

Retorna o ultimo erro do objeto

@type method
@author Victor Hugo
@since 18/02/2014
	
@return String Ultimo erro
/*/
method getLastError() class IpSqlObject
return ::cLastError


/*/{Protheus.doc} getStruct

Retorna o array de estrutura do alias

@type method
@author Victor Hugo
@since 11/11/2013
	
@return Array Estrutura do alias
/*/
method getStruct() class IpSqlObject

	local aStruct := {}
	
	if ::aliasExists()
		aStruct := (::cAlias)->(dbStruct())
	endIf

return aStruct

/*/{Protheus.doc} aliasExists

Indica se o alias do objeto existe

@type method
@author Victor Hugo
@since 11/11/2013

@return Logico Existência do Alias
/*/
method aliasExists() class IpSqlObject
return (Select(::cAlias) > 0)


/*/{Protheus.doc} newTable

Cria um novo alias para uma tabela. (ex.: oSql:newTable("SB1", "B1_FILIAL,B1_COD", "%SB1.XFILIAL% AND B1_COD = '"+cProduto+"'")

@type method
@author Victor Hugo
@since 11/11/2013

@param cTable, String, Tabela do Protheus
@param cFields, String, Campos a serem considerados
@param cWhere, String, Expressão 'where' para consulta
@param cGroupBy, String, Campos da expressão 'group by' (opcional)
@param cOrderBy, String, Campos da expressão 'order by' (opcional)
/*/
method newTable(cTable, cFields, cWhere, cGroupBy, cOrderBy) class IpSqlObject
	
	local cQuery 		:= ""
	default cGroupBy	:= ""
	default cOrderBy	:= ""
	
	cQuery := " SELECT "+cFields+" FROM %"+cTable+".SQLNAME% "
	cQuery += " WHERE "+cWhere+" AND %"+cTable+".NOTDEL% "
	if !Empty(cGroupBy)
		cQuery += " GROUP BY "+cGroupBy
	endIf	
	if !Empty(cOrderBy)
		cQuery += " ORDER BY "+cOrderBy
	endIf
	
	::cLastQuery := cQuery
	
	::newAlias(cQuery)
	
return

/*/{Protheus.doc} close

Fecha o alias aberto

@type method
@author Victor Hugo
@since 11/11/2013
/*/
method close() class IpSqlObject
	
	if ::aliasExists()
		(::cAlias)->(dbCloseArea())
	endIf
	
	if ::hasExternalConnection()
		::setErpConnection()
	endIf
	
return


/*/{Protheus.doc} count

Conta os registros do alias

@type method
@author Victor Hugo
@since 11/11/2013

@return Numerico Quantidade de registros
/*/
method count() class IpSqlObject
	
	local nRegs := 0
	local aArea := GetArea()
	
	if ::aliasExists()
		dbSelectArea(::cAlias)
		count to nRegs
		::goTop()							
	endIf
	
	RestArea(aArea)
	
return nRegs


/*/{Protheus.doc} hasRecords

Verifica se existem registros para o alias

@type method
@author Victor Hugo
@since 11/11/2013

@return Logico Existência de ao menos um registro
/*/
method hasRecords() class IpSqlObject	
return (::count() > 0)


/*/{Protheus.doc} skip

Avança uma linha do alias

@type method
@author Victor Hugo
@since 11/11/2013
/*/
method skip() class IpSqlObject
	
	if ::aliasExists()
		(::cAlias)->(dbSkip())
	endIf
	
return


/*/{Protheus.doc} goTop

Posiciona na primeira linha do alias

@type method
@author Victor Hugo
@since 11/11/2013
/*/
method goTop() class IpSqlObject
	
	if ::aliasExists()
		(::cAlias)->(dbGoTop())
	endIf
	
return


/*/{Protheus.doc} isEof

Indica se o alias esta em fim de arquivo

@type method
@author Victor Hugo
@since 11/11/2013

@return Logico Fim de arquivo
/*/
method isEof() class IpSqlObject
	
	local lIsEof := .F.
	
	if ::aliasExists()
		lIsEof := (::cAlias)->(eof())
	endIf
	
return lIsEof


/*/{Protheus.doc} notIsEof

Indica se o alias NAO está em fim de arquivo. Pode ser usado para laços, por exemplo: while oSql:notIsEof()

@type method
@author Victor Hugo
@since 04/02/2014

@return Logico Fim de arquivo
/*/
method notIsEof() class IpSqlObject	
return !::isEof()


/*/{Protheus.doc} getValue

Coleta o valor de um campo do registro posicionado. O valor do campo pode ser uma expressão ADVPL.

@type method
@author Victor Hugo
@since 11/11/2013

@param cField, String, Campo requisitado 

@return Indefinido Valor do campo
/*/
method getValue(cField) class IpSqlObject
	
	local xValue := nil
	
	if ::aliasExists()
		xValue := (::cAlias)->&cField
	endIf
	
return xValue


/*/{Protheus.doc} execute

Executa uma instrução SQL

@type method
@author Victor Hugo
@since 11/11/2013

@param cQuery, String, Instrução SQL
@param cRefreshAlias, String, Alias a ser atualizado no DBAccess (opcional)

@return Logico Indica se a instrução foi processada com sucesso
/*/	
method execute(cQuery, cRefreshAlias) class IpSqlObject
	
	local lOk := .F.
	default cRefreshAlias := ""
	
	::cLastQuery := cQuery
	
	cQuery := ::parseQuery(cQuery)	
	
	if (TcSqlExec(cQuery) == 0)
		lOk := .T.			
		if !Empty(cRefreshAlias)
			TcRefresh(RetSqlName(cRefreshAlias))		
		endIf
	else			                          
		setLastError(@self, "execute", TcSqlError())
	endIf		

return lOk


/*/{Protheus.doc} update

Executa update em uma tabela. (ex.: oSql:update("ZZ1", "ZZ1_ID = '', ZZ1_VALOR = 0", "%ZZ1.XFILIAL% AND ZZ1_DOC = '"+cDoc+"'"))

@type method
@author Victor Hugo
@since 11/11/2013

@param cTable, String, Tabela do Protheus
@param cFields, String, Expressão de Update dos campos
@param cWhere, String, Expressão 'where' para filtro

@return Logico Indica se a instrução foi processada com sucesso
/*/	
method update(cTable, cFields, cWhere) class IpSqlObject
	
	local cQuery := ""
	
	cQuery := " UPDATE "+RetSqlName(cTable)
	cQuery += " SET "+cFields
	cQuery += " WHERE "+cWhere+" AND D_E_L_E_T_ = ' ' "	
	
return ::execute(cQuery, cTable)


/*/{Protheus.doc} insert

Inclusão de um registro em uma tabela (ex.: oSql:insert("SB1", aDados))

@type method
@author Victor Hugo
@since 11/11/2013

@param cTable, cString, Tabela a ser atualizada
@param aData, Array, Registros a serem inseridos (ex.: aAdd(aData, {"B1_FILIAL",xFilial("SB1")}))
@param nRecno, Numerico, Recno do registro gerado (Opcional)

@return Logico Indica se os registros foram gravados
/*/	
method insert(cTable, aData, nRecno) class IpSqlObject
	
	local lOk 		:= .F.
	local nI  		:= 0
	local cField	:= ""
	local xValue  	:= nil	
	default nRecno	:= 0
	
	if (cTable)->(RecLock(cTable, .T.))
		for nI := 1 to Len(aData)
			cField := aData[nI,1]
			xValue := aData[nI,2]
			if (cTable)->(FieldPos(cField) > 0) .and. (ValType(xValue) != "U")
				(cTable)->&cField := xValue
			endIf	
		next nI		
		(cTable)->(MsUnlock())	
		nRecno := (cTable)->(Recno()) 
		lOk    := .T.
	endIf	
		
return lOk	


/*/{Protheus.doc} delete

Deleta registros de uma tabela. (ex.: oSql:delete("ZZ1", "%ZZ1.XFILIAL% AND ZZ1_DOC = '"+cDoc+"'"))

@type method
@author Victor Hugo
@since 11/11/2013

@param cTable, String, Tabela do Protheus
@param cWhere, String, Expressão 'where' para filtro
@param lClear, Logico, Indica se remove fisicamente os registros. Se não informado assume .F. (apenas marca como deletado)

@return Logico Indica se a instrução foi processada com sucesso
/*/
method delete(cTable, cWhere, lClear) class IpSqlObject
	
	local lOk		:= .F.
	local oSql		:= IpSqlObject():newIpSqlObject()
	default lClear  := .F.
	
	if lClear
		lOk := ::execute("DELETE FROM "+RetSqlName(cTable)+" WHERE "+cWhere+" AND D_E_L_E_T_ = ' ' ", cTable)
	else
		oSql:newTable(cTable, "R_E_C_N_O_ NUMREC", cWhere)
		while oSql:notIsEof()
			(cTable)->(dbGoTo(oSql:getValue("NUMREC")))
			(cTable)->(RecLock(cTable, .F.))
				(cTable)->(dbDelete())
			(cTable)->(MsUnlock())
			oSql:skip()
			lOk := .T.
		endDo
		oSql:close()
	endIf
	
return lOk


/*/{Protheus.doc} exists

Verifica se existem registros ativos em uma tabela (ex.: oSql:exists("SB1", "B1_COD = '"+cProduto+"'"))

@type method
@author Victor Hugo
@since 11/11/2013

@param cTable, cString, Tabela a ser consultada
@param cWhere, String, Expressão 'where' para consulta do registro. O método irá considerar somente registros ativos (D_E_L_E_T_ = ' ')

@return Logico Indica se existem registros
/*/	
method exists(cTable, cWhere) class IpSqlObject
	
	local oSql   := IpSqlObject():newIpSqlObject()
	local cQuery := "SELECT 1 FROM %"+cTable+".SQLNAME% WHERE "+cWhere+" AND %"+cTable+".NOTDEL% "	
	
	::cLastQuery := cQuery
	
	oSql:newAlias(cQuery)
	
	lExists := oSql:hasRecords()
	
	oSql:close()
	
return lExists


/*/{Protheus.doc} parseQuery

Realiza o parser de uma Query

@type method
@author Victor Hugo
@since 11/11/2013

@param cQuery, String, Query para processamento do parser

@return String Query a ser enviada para o banco de dados
/*/
method parseQuery(cQuery) class IpSqlObject
	
	local nI			:= 0
	local nPos			:= 0  
	local nSizeAlias 	:= 3
	local cAlias		:= ""
	local cSavQuery		:= Upper(AllTrim(cQuery))		
	local aCmds			:= {"SQLNAME%","FILIAL%","XFILIAL%","NOTDEL%"} 
	
	cQuery := cSavQuery	
	
	for nI := 1 to Len(aCmds)
		
		cCmd := aCmds[nI]	
		
		while ((nPos := At("."+cCmd, cQuery)) > 0)    
			
			cAlias := SubStr(cQuery, nPos-nSizeAlias, nSizeAlias)
			
			if Empty(RetSqlName(cAlias))
				setLastError(@self, "parseQuery", "Falha ao interpretar Query: "+cSavQuery) 
				return cSavQuery
			endIf
			
			cFind := "%"+cAlias+"."+cCmd
			
			if ("SQLNAME" $ cCmd) 
				cReplace:= RetSqlName(cAlias)+" "+cAlias 
			elseIf ("FILIAL" == Left(cCmd, 6)) 
				cReplace:= xFilial(cAlias)
			elseIf ("XFILIAL" $ cCmd) 
				cReplace:= PrefixoCpo(cAlias)+"_FILIAL = '"+xFilial(cAlias)+"'"
			elseIf ("NOTDEL" $ cCmd)
				cReplace := cAlias+".D_E_L_E_T_ = ' ' "
			endIf
			
			cQuery := StrTran(cQuery, cFind, cReplace)
			
		endDo
		
	next nI		
	
return cQuery


/*/{Protheus.doc} exportToCsv

Exporta o conteúdo do alias para um arquivo CSV

@type method
@author Victor Hugo
@since 11/11/2013

@param cFile, String, Arquivo CSV a ser gerado
@param lShowProgress, Logico, Indica se deve mostrar a barra de processamento da função Processa(). Por padrão assume .F.

@return Logico Indica se o arquivo foi gerado	 
/*/	
method exportToCsv(cFile, lShowProgress) class IpSqlObject
	
	local nRecs			 := 0
	local nRecAtu		 := 0
	local lOk 			 := .F.
	local oFile			 := IpFileObject():newIpFileObject(cFile)
	default lShowProgress:= .F.
	
	if !::aliasExists()
		return .F.
	endIf
	
	if (oFile:exists() .and. !oFile:delete())
		return .F.
	endIf
	
	if !oFile:writeLine(getCsvFields(self))
		return .F.
	endIf
	
	if lShowProgress
		nRecs := ::count()
		ProcRegua(nRecs)
	endIf
	
	::goTop()
	while ::notIsEof()		
		if !oFile:writeLine(getCsvLine(self))
			return .F.		
		endIf			
		::skip()
		if lShowProgress
			nRecAtu++
			IncProc("Gravando CSV [registro "+AllTrim(Str(nRecAtu))+" de "+AllTrim(Str(nRecs))+"] ...") 
		endIf
	endDo
	
	lOk := oFile:exists()
	
return lOk

/**
 * Coleta os campos do arquivo CSV
 */
static function getCsvFields(oObj)
	
	local nI		:= 0		
	local cFields	:= ""
	local cAlias	:= oObj:getAlias()				
	local aStruct	:= (cAlias)->(dbStruct())	
		
	For nI := 1 To Len(aStruct)		
		cFields += AllTrim(aStruct[nI,1])+";"
	Next nI	
	
return cFields

/**
 * Coleta uma linha do arquivo CSV
 */
static function getCsvLine(oObj)
	
	local nI		:= 0		
	local xValue	:= nil	
	local cField	:= ""
	local cType		:= ""     
	local cLine		:= ""
	local cStrVal	:= ""
	local cAlias	:= oObj:getAlias()				
	local aStruct	:= (cAlias)->(dbStruct())	
		
	for nI := 1 to Len(aStruct)
		
		cField := aStruct[nI,1]
		cType  := aStruct[nI,2]
		xValue := (cAlias)->&cField
		
		if (cType == "N") 
			cStrVal := AllTrim(Str(xValue))		
		elseIf (cType == "D")
			cStrVal := DtoC(xValue)		
		else
			cStrVal := AllTrim(xValue)
		endIf		 
		
		cLine += cStrVal+";"
			
	next nI	
		
return cLine


/*/{Protheus.doc} showReport

Exibe o conteúdo de uma consulta SQL através da classe TReport

@type method
@author Victor Hugo
@since 11/11/2013
/*/
method showReport(cName, cTitle, cDescription) class IpSqlObject

	local oReport		:= nil
	local cParams		:= "" 
 	default cName  		:= "IpSqlObject:showReport"
 	default cTitle 		:= "Impressão de Consulta SQL"
 	default cDescription:= cTitle
	
	oReport := TReport():new(cName, cTitle, cParams, { || procReport(@self, @oReport) }, cDescription)
	oReport:printDialog()
	
return

/**
 * Processa o Relatório
 */
static function procReport(oSelf, oReport)
	
	local oSection := TRSection():new(oReport)
	
	createSection(@oSelf, @oSection)
	
	oReport:setMeter(oSelf:count())
	
	oSection:init()
	
	oSelf:goTop()
	while oSelf:notIsEof()		
		oReport:incMeter()
		oSection:printLine()		
		oSelf:skip()
	endDo                    	
	oSelf:goTop()
	
	oSection:finish()
	
return

/**
 * Criação das Seções do Relatório
 */
static function createSection(oSelf, oSection)
 	
 	local nI	 	:= 0
 	local nScan		:= 0
 	local nSize		:= 0
 	local cId	 	:= ""
 	local cTitle	:= ""
 	local cPicture	:= ""
 	local cAliasObj	:= oSelf:getAlias()
 	local aStruct	:= (cAliasObj)->(dbStruct())
 	local cQuery	:= ""
	local cAlias	:= ""
 	
 	for nI := 1 to Len(aStruct)
 		cId 	:= aStruct[nI,1]
 		nScan	:= aScan(oSelf:aReportCells, {|x| x[1] == cId })
 		if (nScan > 0)
 			cTitle   := oSelf:aReportCells[nScan,2]
 			cPicture := oSelf:aReportCells[nScan,3]
 			nSize	 := oSelf:aReportCells[nScan,4]
 		else
	 		
	 		cAlias := GetNextAlias()
	
			cQuery := "SELECT " + CRLF
			cQuery += "	X3_CAMPO AS CAMPO, " + CRLF
			
			#ifdef SPANISH
				cQuery += "	X3_TITSPA AS TITULO, " + CRLF
			#else
				#ifdef ENGLISH
					cQuery += "	X3_TITENG AS TITULO, " + CRLF
				#else
					cQuery += "	X3_TITULO AS TITULO, " + CRLF
				#endif
			#endif
				
			cQuery += "	X3_TAMANHO AS TAMANHO, " + CRLF
			cQuery += "	X3_PICTURE AS PICTURE " + CRLF
			cQuery += "FROM " + CRLF
			cQuery += "	" + RetSqlName("SX3") + " " + CRLF
			cQuery += "WHERE 1=1" + CRLF
			cQuery += "	AND X3_CAMPO  = '" + cId + "' " + CRLF
			cQuery += "	AND D_E_L_E_T_ = ' ' " + CRLF
			
			TcQuery cQuery NEW Alias &cAlias
	 		
	 		if (cAlias)->(!Eof()) .and. AllTrim(Upper(cId)) == Upper(AllTrim((cAlias)->CAMPO))
	 			cTitle   := (cAlias)->TITULO
	 			cPicture := (cAlias)->PICTURE
	 			nSize	 := (cAlias)->TAMANHO	
	 		else
	 			cTitle   := cId
	 			cPicture := ""
	 			nSize	 := nil		
	 		endIf
	 		
	 		(cAlias)->(DbCloseArea())
	 		
	 	endIf	
 		TRCell():new(oSection, cId, cAliasObj, cTitle, cPicture, nSize)
 	next nI
	
return

/*/{Protheus.doc} setReportCellProperty

Define propriedades das células para geração de Relatório de Consultas

@type method
@author Victor Hugo
@since 13/11/2013

@param cId, String, ID da Coluna
@param cTitle, String, Título da Coluna
@param cPicture, cString, Picture da Coluna
@param nSize, Numerico, Largura da coluna
/*/
method setReportCellProperty(cId, cTitle, cPicture, nSize) class IpSqlObject
 	
	local nScan := aScan(::aReportCells, {|x| x[1] == cId })
 	
 	if (nScan == 0)
 		aAdd(::aReportCells, Array(4))
 		nScan := Len(::aReportCells)
 	endIf
 	
 	::aReportCells[nScan,1] := cId
 	::aReportCells[nScan,2] := cTitle
 	::aReportCells[nScan,3] := cPicture
	::aReportCells[nScan,4] := nSize
 	
return


/*/{Protheus.doc} saveQuery

Salva uma query em arquivo texto

@type method	
@author Victor Hugo
@since 18/02/2014

@param cFile, String, Arquivo a ser gerado
@param cQuery, String, Instrução SQL. Se não informado considera a última query definida para o objeto.

@return Logico Indica se o arquivo foi gerado
/*/
method saveQuery(cFile, cQuery) class IpSqlObject
	
	local lOk		:= .F.
	local oFile 	:= IpFileObject():newIpFileObject(cFile)
	default cQuery	:= ::getLastQuery()
	
	cQuery := ::parseQuery(cQuery)
	
	if oFile:exists()
		oFile:delete()
	endIf	
	
	lOk	:= oFile:writeLine(cQuery)
	
	oFile:close()
	
return lOk


/*/{Protheus.doc} getFieldValue

Coleta o valor de um campo em um Alias
	
@type method
@author Victor Hugo
@since 16/06/2014

@param cAlias, String, Alias da Tabela do Protheus
@param cField, String, Campo da Tabela (NÃO pode ser informada nenhuma função SQL ou AdvPL)
@param cWhere, String, Expressão WHERE

@return Indefinido Valor do Campo
/*/
method getFieldValue(cAlias, cField, cWhere) class IpSqlObject
	
	local xValue := nil
	local oSql   := IpSqlObject():newIpSqlObject()
	
	oSql:newTable(cAlias, cField, cWhere)
	
	xValue := oSql:getValue(cField)
	
	oSql:close()
	
return xValue



/*/{Protheus.doc} setErpConnection

Define a Conexão do Objeto com o Banco de Dados do Protheus

@type method	
@author Victor Hugo
@since 06/10/2014
/*/
method setErpConnection() class IpSqlObject
	
	if ::hasExternalConnection()
		TcUnlink(::nExternalConnection)
		::nExternalConnection := -1
	endIf
	
	TcSetConn(::nErpConnection)
	
return


/*/{Protheus.doc} setExternalConnection

Define a Conexão do Objeto com um Banco de Dados Externo

@type method	
@author Victor Hugo
@since 06/10/2014

@param cDriver, String, Driver do Banco de Dados ("MYSQL", "ORACLE", "MSSQL", "DB2", etc.)
@param cDataBase, String, Nome da Configuração do BD no DBAccess
@param cServer, String, IP do Servidor DBAccess (por padrão assume 127.0.0.1)
@param nPort, Numerico, Porta que o DBAccess está ouvindo (por padrão assume 7890)

@return Logico Indica se a conexão foi realizada
/*/
method setExternalConnection(cDriver, cDataBase, cServer, nPort) class IpSqlObject
	
	local lOk		:= .F.
	local cError	:= ""
	default cServer := "127.0.0.1"
	default nPort	:= 7890
	
	begin sequence
		
		if Empty(cDataBase)
			cError := "Configuração do BD Externo não definida"
			break
		endIf
		
		if ::hasExternalConnection()
			cError := "Objeto já conectado a um BD Externo"
			break
		endIf
		
		TcConType("TCPIP")
		::nExternalConnection := TcLink(Upper(AllTrim(cDriver))+"/"+cDatabase, cServer, nPort)
		
		if ::hasExternalConnection()
			TcSetConn(::nExternalConnection)
		else
			cError := "Falha na Conexão com Banco de Dados Externo: "+cDataBase+", "+cServer+", "+AllTrim(Str(nPort))+CRLF
			cError += "Erro do DBAccess: "+AllTrim(Str(::nExternalConnection))
			break				
		endIf
		
		lOk := .T.
		
	end sequence
	
	if !Empty(cError)
		setLastError(@self, "setExternalConnection", cError)
	endIf	
	
return lOk


/*/{Protheus.doc} hasExternalConnection

Indica se existe conexão ativa com Banco de Dados Externo

@type method	
@author Victor Hugo
@since 06/10/2014

@return Logico Conexão ativa com Banco de Dados Externo
/*/
method hasExternalConnection() class IpSqlObject
return (::nExternalConnection > 0)


/**
 * Define as Mensagens de Erro do Objeto
 */
static function setLastError(oSelf, cMethod, cError)
	
	oSelf:cLastError := "[ IpSqlObject - ERRO - "+DtoC(Date())+" - "+Time()+" - "+AllTrim(cMethod)+"() ] "
	oSelf:cLastError += cError
	
	FWLogMsg("ERROR", , "BusinessObject", funName(), "", "01", oSelf:cLastError, 0, 0, {})
	
return
