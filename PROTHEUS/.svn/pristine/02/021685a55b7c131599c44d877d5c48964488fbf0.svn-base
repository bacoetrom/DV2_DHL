#include "protheus.ch"
#include "tcbrowse.ch"
#include "rwmake.ch"

#define HEADER_TITLE		1
#define HEADER_FIELD		2
#define HEADER_PICTURE		3
#define HEADER_SIZE			4
#define HEADER_DECIMALS		5
#define HEADER_VALID		6
#define HEADER_USED			7
#define HEADER_TYPE			8
#define HEADER_F3			9
#define HEADER_CONTEXT		10
#define HEADER_CBOX			11
#define HEADER_RELATION		12
#define HEADER_INIBRW		13
#define HEADER_BROWSE		14
#define HEADER_VISUAL		15
#define HEADER_COLUMNS		15

#define BMP_MARK			"LBOK"
#define BMP_UNMARK			"LBNO"

#define DEFAULT_LINE_POS	if(::isCreated(), ::oGrid:nAt, Len(::aLines))
#define DELETED_COL_POS		if(Len(::aColumns) > 0, Len(::aColumns)+1, 0)


/*/{Protheus.doc} IpGridObject

Objeto para manipulação de Grids

@type class
@author Victor Hugo
@since 11/11/2013
/*/
class IpGridObject from IpAdvplObject

	data nCol
	data nRow
	data nWidth
	data nHeight
	data oWnd
	data oGrid
	data aColumns
	data aLines
	data aOldLines
	data bOnMark
	data bOnMarkAll
	data lReadOnly
	data nAccessMode
	data cLinesValidation
	data cDeleteValidation
	data lMarkOne
	data lFiltered
	data lFreeze
	data lCreated
	data aUpdateFields
	data cMarkImage
	data cUnMarkImage
	
	method newIpGridObject() constructor

	method getCol()
	method setCol()
	method getRow()
	method setRow()
	method getWidth()
	method setWidth()
	method getHeight()
	method setHeight()
	method getWnd()
	method setWnd()
	method getGrid()
	method getColumns()
	method getLines()
	method getOnMark()
	method setOnMark()
	method getOnMarkAll()
	method setOnMarkAll()
	method isReadOnly()
	method setReadOnly()
	method getAccessMode()
	method setAccessMode()
	method getLinesValidation()
	method setLinesValidation()
	method getDeleteValidation()
	method setDeleteValidation()
	method isMarkOne()
	method setMarkOne()
	method isFiltered()
	method setFiltered()
	method isFreeze()
	method setFreeze()
	method isCreated()	
	method getUpdateFields()	
	method setUpdateFields()
	method setMarkImage()
	method getMarkImage()
	method setUnMarkImage()
	method getUnMarkImage()

	method addColumn()
	method addSqlColumns()
	method getColumn()
	method addMarkColumn()
	method addBmpColumn()
	method getColumnPosition()
	method getMarkColumnPosition()
	method newLine()
	method removeLine()
	method setValue()
	method getValue()
	method create()
	method clear()
	method markAll()
	method hasMarkColumn()
	method setMarkedLine()
	method isMarkedLine()
	method hasMarkedLines()
	method setDeletedLine()
	method isDeletedLine()
	method setBmpValue()
	method refresh()
	method length()
	method filter()
	method clearFilter()
	method getCursorLine()
	method recordValues()

endClass


/*/{Protheus.doc} newIpGridObject

Construtor

@type method
@author Victor Hugo
@since 11/11/2013

@param nCol, Numerico, Coluna
@param nRow, Numerico, Linha
@param nWidth, Numerico, Largura
@param nHeight, Numerico, Altura
@param oWnd, Objeto, Objeto pai do browse
/*/
method newIpGridObject(nCol, nRow, nWidth, nHeight, oWnd) class IpGridObject

	default nCol 	:= 0
	default nRow 	:= 0
	default nWidth	:= 0
	default nHeight	:= 0
	default oWnd	:= oMainWnd

	::newIpAdvplObject()

	::aColumns	:= {}
	::aLines	:= {}
	::aOldLines	:= {}
	::oGrid		:= nil
	::lCreated	:= .F.

	::setCol(nCol)
	::setRow(nRow)
	::setWidth(nWidth)
	::setHeight(nHeight)
	::setWnd(oWnd)
	::setOnMark({|| Sleep(0) })
	::setOnMarkAll({|| Sleep(0) })
	::setReadOnly(.F.)
	::setAccessMode("insert", "delete", "update")
	::setLinesValidation("AllwaysTrue()")
	::setDeleteValidation("AllwaysTrue()")
	::setMarkOne(.F.)
	::setFiltered(.F.)
	::setFreeze(.F.)	
	::setUpdateFields()
	::setMarkImage(BMP_MARK)
	::setUnMarkImage(BMP_UNMARK)

return


/*/{Protheus.doc} getCol

Coleta a coluna do objeto

@type method
@author Victor Hugo
@since 07/01/2014

@return Numerico Coluna do objeto
/*/
method getCol() class IpGridObject
return ::nCol


/*/{Protheus.doc} setCol

Define a coluna do objeto

@type method
@author Victor Hugo
@since 07/01/2014

@param nCol, Numerico, Coluna do objeto
/*/
method setCol(nCol) class IpGridObject
	::nCol := nCol
return


/*/{Protheus.doc} getRow

Coleta a linha do objeto

@type method
@author Victor Hugo
@since 07/01/2014

@return Numerico Linha do objeto
/*/
method getRow() class IpGridObject
return ::nRow


/*/{Protheus.doc} setRow

Define a linha do objeto

@type method
@author Victor Hugo
@since 07/01/2014

@param nRow, Numerico, Linha do objeto
/*/
method setRow(nRow) class IpGridObject
	::nRow := nRow
return


/*/{Protheus.doc} getWidth

Coleta a largura do objeto

@type method
@author Victor Hugo
@since 07/01/2014

@return Numerico Largura do objeto
/*/
method getWidth() class IpGridObject
return ::nWidth


/*/{Protheus.doc} setWidth

Define a largura do objeto

@type method
@author Victor Hugo
@since 07/01/2014

@param nWidth, Numerico, Largura do objeto
/*/
method setWidth(nWidth) class IpGridObject
	::nWidth := nWidth
return


/*/{Protheus.doc} getHeight

Coleta a altura do objeto

@type method
@author Victor Hugo
@since 07/01/2014

@return Numerico Altura do objeto
/*/
method getHeight() class IpGridObject
return ::nHeight


/*/{Protheus.doc} setHeight

Define a altura do objeto

@type method
@author Victor Hugo
@since 07/01/2014

@param nHeight, Numerico, Altura do objeto
/*/
method setHeight(nHeight) class IpGridObject
	::nHeight := nHeight
return


/*/{Protheus.doc} getWnd

Coleta o objeto pai do grid

@type method
@author Victor Hugo
@since 07/01/2014

@return Objeto Pai do grid
/*/
method getWnd() class IpGridObject
return ::oWnd


/*/{Protheus.doc} setWnd

Define o objeto pai do grid

@type method
@author Victor Hugo
@since 07/01/2014

@param oWnd, Objeto, Pai do grid
/*/
method setWnd(oWnd) class IpGridObject
	::oWnd := oWnd
return


/*/{Protheus.doc} getGrid

Coleta o objeto de grid

@type method
@author Victor Hugo
@since 06/01/2014

@return Objeto Objeto de Grid
/*/
method getGrid() class IpGridObject
return ::oGrid


/*/{Protheus.doc} getColumns

Coleta o array de colunas

@type method
@author Victor Hugo
@since 06/01/2014

@return Array Array de colunas
/*/
method getColumns() class IpGridObject
return ::aColumns


/*/{Protheus.doc} getLines

Coleta o array de linhas

@type method
@author Victor Hugo
@since 06/01/2014

@return Array Array de linhas
/*/
method getLines() class IpGridObject
return ::aLines


/*/{Protheus.doc} getOnMark

Coleta o bloco de código a ser executado quando um registro for marcado

@type method
@author Victor Hugo
@since 06/01/2014

@return CodeBlock, Bloco de código a ser executado quando um registro for marcado
/*/
method getOnMark() class IpGridObject
return ::bOnMark


/*/{Protheus.doc} setOnMark

Define o bloco de código a ser executado quando um registro for marcado

@type method
@author Victor Hugo
@since 06/01/2014

@param bOnMark, CodeBlock, Bloco de código a ser executado quando um registro for marcado
/*/
method setOnMark(bOnMark) class IpGridObject
	::bOnMark := bOnMark
return


/*/{Protheus.doc} getOnMarkAll

Coleta o bloco de código a ser executado quando todos os registros forem marcados

@type method
@author Victor Hugo
@since 06/01/2014

@return CodeBlock, Bloco de código a ser executado quando todos os registros forem marcados
/*/
method getOnMarkAll() class IpGridObject
return ::bOnMarkAll


/*/{Protheus.doc} setOnMarkAll

Define o bloco de código a ser executado quando todos os registros forem marcados

@type method
@author Victor Hugo
@since 06/01/2014

@param bOnMarkAll, CodeBlock, Bloco de código a ser executado quando todos os registros forem marcados
/*/
method setOnMarkAll(bOnMarkAll) class IpGridObject
	::bOnMarkAll := bOnMarkAll
return


/*/{Protheus.doc} isReadOnly

Indica se o grid é somente visualização

@type method
@author Victor Hugo
@since 06/01/2014

@return Logico Somente visualização
/*/
method isReadOnly() class IpGridObject
return ::lReadOnly


/*/{Protheus.doc} setReadOnly

Define se o grid é somente visualização

@type method
@author Victor Hugo
@since 06/01/2014

@param lReadOnly, Logico, Somente visualização
/*/
method setReadOnly(lReadOnly) class IpGridObject
	::lReadOnly := lReadOnly
	if lReadOnly
		::nAccessMode := 0
	endIf
return


/*/{Protheus.doc} getAccessMode

Coleta o modo de acesso ao grid

@type method
@author Victor Hugo
@since 06/01/2014

@return Numerico Modo de acesso ao grid
/*/
method getAccessMode() class IpGridObject
return ::nAccessMode


/*/{Protheus.doc} setAccessMode

Define o modo de acesso ao grid.
Exemplo para todos os acessos: oGrid:setAccessMode("insert", "delete", "update")
Exemplo para não permitir inclusão: oGrid:setAccessMode("delete", "update")

@type method
@author Victor Hugo
@since 06/01/2014

@param cMode1, String, Modo de acesso 1
@param cMode2, String, Modo de acesso 2
@param cMode3, String, Modo de acesso 3
/*/
method setAccessMode(cMode1, cMode2, cMode3) class IpGridObject

	default cMode1 := ""
	default cMode2 := ""
	default cMode3 := ""

	::nAccessMode := 0
	setGdAccessMode(cMode1, @self)
	setGdAccessMode(cMode2, @self)
	setGdAccessMode(cMode3, @self)

return

/**
 * Define o modo de acesso de acordo com as constantes do MsNewGetDados
 */
static function setGdAccessMode(cMode, oGrid)

	cMode := Lower(AllTrim(cMode))

	if (cMode == "insert")
		oGrid:nAccessMode += GD_INSERT
	elseIf (cMode == "delete")
		oGrid:nAccessMode += GD_DELETE
	elseIf (cMode == "update")
		oGrid:nAccessMode += GD_UPDATE
	endIf

return


/*/{Protheus.doc} getLinesValidation

Coleta a validação ao trocar de linhas

@type method
@author Victor Hugo
@since 11/01/2014

@return String Validação ao trocar de linhas
/*/
method getLinesValidation() class IpGridObject
return ::cLinesValidation


/*/{Protheus.doc} setLinesValidation

Define a validação ao trocar de linhas

@type method
@author Victor Hugo
@since 11/01/2014

@param cLinesValidation, String, Validação ao trocar de linhas
/*/
method setLinesValidation(cLinesValidation) class IpGridObject
	::cLinesValidation := cLinesValidation
return


/*/{Protheus.doc} getDeleteValidation

Coleta a validação ao deletar linhas

@type method
@author Victor Hugo
@since 11/01/2014

@return String Validação ao deletar de linhas
/*/
method getDeleteValidation() class IpGridObject
return ::cDeleteValidation


/*/{Protheus.doc} setDeleteValidation

Define a validação ao deletar linhas

@type method
@author Victor Hugo
@since 11/01/2014

@param cDeleteValidation, String, Validação ao deletar linhas
/*/
method setDeleteValidation(cDeleteValidation) class IpGridObject
	::cDeleteValidation := cDeleteValidation
return


/*/{Protheus.doc} isMarkOne

Indica se Marca somente um registro do grid

@type method
@author Victor Hugo
@since 20/01/2014

@return Logico Marca somente um registro do grid
/*/
method isMarkOne() class IpGridObject
return ::lMarkOne


/*/{Protheus.doc} setMarkOne

Define se Marca somente um registro do grid

@type method
@author Victor Hugo
@since 20/01/2014

@param lMarkOne, Logico, Marca somente um registro do grid
/*/
method setMarkOne(lMarkOne) class IpGridObject
	::lMarkOne := lMarkOne
return


/*/{Protheus.doc} isFiltered

Indica se o Grid está filtrado

@type method
@author Victor Hugo
@since 07/02/2014

@return Logico Grid está filtrado
/*/
method isFiltered() class IpGridObject
return ::lFiltered


/*/{Protheus.doc} setFiltered

Define se o Grid está filtrado

@type method
@author Victor Hugo
@since 07/02/2014

@param lFiltered, Logico, Se o grid está filtrado
/*/
method setFiltered(lFiltered) class IpGridObject
	::lFiltered := lFiltered
return


/*/{Protheus.doc} isCreated

Indica se o Grid foi criado

@type method
@author Victor Hugo
@since 14/02/2014

@return Logico Grid já foi criado
/*/
method isCreated() class IpGridObject
return ::lCreated


/*/{Protheus.doc} getUpdateFields

Retorna Array com os Campos que podem ser Alterados na Grid, quando Grid com opção de Alteração

@type method
@author Carlos Eduardo Niemeyer Rodrigues
@since 23/07/2014

@return Array com os Campos que podem ser Alterados na Grid, quando Grid com opção de Alteração
/*/
method getUpdateFields() class IpGridObject
return (::aUpdateFields)

/*/{Protheus.doc} setUpdateFields

Define Array com os Campos que podem ser Alterados na Grid, quando Grid com opção de Alteração

@type method
@author Carlos Eduardo Niemeyer Rodrigues
@since 23/07/2014

@param aUpdateFields, Array, Array com os Campos que podem ser Alterados na Grid, quando Grid com opção de Alteração
/*/
method setUpdateFields(aUpdateFields) class IpGridObject
	default aUpdateFields := Nil
	
	::aUpdateFields := aUpdateFields
	
	setPropertyReadOnly(self)

return
      
/*/{Protheus.doc} getMarkImage

Recupera o Nome do Recurso de Imagem para representação da Coluna Mark Marcada

@type method
@author Carlos Eduardo Niemeyer Rodrigues
@since 10/11/2014

@return cMarkImage, Array, Nome do Recurso de Imagem para representação da Coluna Mark Marcada
/*/
method getMarkImage() class IpGridObject
return (::cMarkImage)
             
/*/{Protheus.doc} setMarkImage

Define o Nome do Recurso de Imagem para representação da Coluna Mark Marcada

@type method
@author Carlos Eduardo Niemeyer Rodrigues
@since 10/11/2014

@param cMarkImage, Caracter, Nome do Recurso de Imagem para representação da Coluna Mark Marcada
/*/
method setMarkImage(cMarkImage) class IpGridObject
	default cMarkImage := BMP_MARK 
	::cMarkImage := cMarkImage
return

/*/{Protheus.doc} getUnMarkImage

Recupera o Nome do Recurso de Imagem para representação da Coluna Mark Desmarcada

@type method
@author Carlos Eduardo Niemeyer Rodrigues
@since 10/11/2014

@return cUnMarkImage, Caracter, Nome do Recurso de Imagem para representação da Coluna Mark Desmarcada
/*/
method getUnMarkImage() class IpGridObject
return (::cUnMarkImage)

/*/{Protheus.doc} setUnMarkImage

Define o Nome do Recurso de Imagem para representação da Coluna Mark Desmarcada

@type method
@author Carlos Eduardo Niemeyer Rodrigues
@since 10/11/2014

@param cUnMarkImage, Caracter, Nome do Recurso de Imagem para representação da Coluna Mark Desmarcada
/*/
method setUnMarkImage(cUnMarkImage) class IpGridObject
	default cUnMarkImage := BMP_UNMARK
	::cUnMarkImage := cUnMarkImage
return


/*/{Protheus.doc} isFreeze

Indica se Congela a primeira coluna

@type method
@author Victor Hugo
@since 14/02/2014

@return Logico Congela a primeira coluna
/*/
method isFreeze() class IpGridObject
return ::lFreeze


/*/{Protheus.doc} setFreeze

Define se Congela a primeira coluna

@type method
@author Victor Hugo
@since 14/02/2014

@param lFreeze, Logico, Congela a primeira coluna
/*/
method setFreeze(lFreeze) class IpGridObject
	::lFreeze := lFreeze
return


/*/{Protheus.doc} addColumn

Adiciona uma coluna do browse. Pode receber uma String com um campo contido no SX3 ou um objeto IpColumnObject.

@type method
@author Victor Hugo
@since 06/01/2014

@param xColumn, Indefinido, ID do Campo ou Objeto IpColumnObject

@return Objeto Retorna a coluna criada
/*/
method addColumn(xColumn) class IpGridObject

	local oCol := nil

	if (ValType(xColumn) == "C")
		oCol := IpColumnObject():newIpColumnObject(xColumn)
	else
		oCol := xColumn
	endIf
	
	setPropertyReadOnly(self,oCol)

	aAdd(::aColumns, oCol)

return oCol


/*/{Protheus.doc} addSqlColumns

Adiciona colunas no browse a partir de uma query SQL

@type method
@author Victor Hugo
@since 06/01/2014

@param cQuery, String, Consulta SQL
@param lFill, Logico, Indica se preenche as linhas com o conteúdo da query. Por padrão assume .T.
/*/
method addSqlColumns(cQuery, lFill) class IpGridObject

	local oSql 		:= IpSqlObject():newIpSqlObject()
	default lFill	:= .T.

	oSql:newAlias(cQuery)

	createSqlColumns(@self, oSql)

	if lFill
		fillLinesFromSql(@self, oSql)
	endIf

	oSql:close()

return

/**
 * Cria as colunas a partir do objeto IpSqlObject
 */
static function createSqlColumns(oGrid, oSql)

	local nI		:= 0
	local nSize  	:= 0
	local cField	:= ""
	local cType		:= ""
	local oCol		:= nil
	local aStruct	:= oSql:getStruct()

	for nI := 1 to Len(aStruct)
		cField	:= aStruct[nI,1]
		cType	:= aStruct[nI,2]
		nSize	:= aStruct[nI,3]
		oCol 	:= IpColumnObject():newIpColumnObject(cField)
		if !oCol:isSx3()
			oCol:setTitle(Capital(cField))
			oCol:setType(cType)
			oCol:setSize(nSize)
		endIf
		oGrid:addColumn(oCol)
	next nI

return

/**
 * Preenche as linhas do grid a partir de um objeto IpSqlObject
 */
static function fillLinesFromSql(oGrid, oSql)

	local cField  := ""
	local aStruct := oSql:getStruct()
	local nI      := 0

	while !oSql:isEof()
		oGrid:newLine()
		for nI := 1 to Len(aStruct)
			cField := aStruct[nI,1]
			oGrid:setValue(cField, oSql:getValue(cField))
		next nI
		oSql:skip()
	endDo

return


/*/{Protheus.doc} getColumn

Coleta uma coluna do grid

@type method
@author Victor Hugo
@since 06/01/2014

@param cId, String, ID do Objeto IpColumnObject
/*/
method getColumn(cId) class IpGridObject

	local oCol := nil
	local nPos := ::getColumnPosition(cId)

	if (nPos > 0)
		oCol := ::aColumns[nPos]
	endIf

return oCol


/*/{Protheus.doc} addMarkColumn

Adiciona uma coluna de seleção de registros

@type method
@author Victor Hugo
@since 06/01/2014

@param bOnMark, CodeBlock, Bloco de código a ser executado quando um registro for marcado
@param bOnMarkAll, CodeBlock, Bloco de código a ser executado quando todos os registros forem marcados

@return TipoRet DescricaoRet
/*/
method addMarkColumn(bOnMark, bOnMarkAll) class IpGridObject

	default bOnMark 	:= {|| Sleep(0) }
	default bOnMarkAll	:= {|| Sleep(0) }

	::setOnMark(bOnMark)
	::setOnMarkAll(bOnMarkAll)

	::addColumn(IpColumnObject():newIpColumnObject("@mark"))

	checkMarkColumn(@self)

return

/**
 * Ajusta a coluna de marcação
 */
static function checkMarkColumn(oGrid)

	local nI		:= 0
	local oMarkCol	:= nil
	local aNewCols	:= {}
	local aCols 	:= oGrid:getColumns()

	for nI := 1 to Len(aCols)
		if (aCols[nI]:isMarkColumn())
			oMarkCol := aCols[nI]
			exit
		endIf
	next nI

	if (ValType(oMarkCol) != "O")
		return
	endIf

	aAdd(aNewCols, oMarkCol)

	for nI := 1 to Len(aCols)
		if (aCols[nI]:isMarkColumn())
			loop
		endIf
		aAdd(aNewCols, aCols[nI])
	next nI

	oGrid:aColumns := aNewCols

return


/*/{Protheus.doc} addBmpColumn

Cria uma coluna tipo bitmap

@type method
@author Victor Hugo
@since 07/01/2014

@param cId, String, Id da coluna
/*/
method addBmpColumn(cId) class IpGridObject

	::addColumn(IpColumnObject():newIpColumnObject("@bmp", cId))

return


/*/{Protheus.doc} getColumnPosition

Coleta a posição de uma coluna

@type method
@author Victor Hugo
@since 06/01/2014

@param cId, String, ID da Coluna

@return Numerico Posição da coluna
/*/
method getColumnPosition(cId) class IpGridObject

	local nI 	:= 0
	local nPos	:= 0

	for nI := 1 to Len(::aColumns)
		if (::aColumns[nI]:getId() == cId)
			nPos := nI
			exit
		endIf
	next nI

return nPos


/*/{Protheus.doc} getMarkColumnPosition

Coleta a posição de uma coluna tipo marcação

@type method
@author Victor Hugo
@since 06/01/2014

@return Numerico Posição da coluna de marcação
/*/
method getMarkColumnPosition() class IpGridObject

	local nI 	:= 0
	local nPos 	:= 0
	local aCols	:= ::getColumns()

	for nI := 1 to Len(aCols)
		if aCols[nI]:isMarkColumn()
			nPos := nI
			exit
		endIf
	next nI

return nPos


/*/{Protheus.doc} newLine

Adiciona uma nova linha no browse

@type method
@author Victor Hugo
@since 06/01/2014
/*/
method newLine() class IpGridObject

	local nCols 	:= Len(::aColumns)
	local nPosDel	:= (nCols + 1)
	local nI        := 1

	if (nCols == 0)
		return
	endIf

	aAdd(::aLines, Array(nCols + 1))
	aTail(::aLines)[nPosDel] := .F.

	for nI := 1 to nCols
		aTail(::aLines)[nI] := ::aColumns[nI]:getEmptyValue()
	next nI

	if (ValType(::oGrid) == "O")
		::oGrid:nAt 	:= Len(::aLines)
		::oGrid:aCols	:= ::aLines
	endIf

return


/*/{Protheus.doc} removeLine

Remove linhas do grid

@type method
@author Victor Hugo
@since 07/02/2014

@param nLine, Numerico, Linha a ser removida. Se não informado considera a linha posicionada.
/*/
method removeLine(nLine) class IpGridObject

	local nI 		:= 0
	local aNewLines	:= {}
	default nLine	:= DEFAULT_LINE_POS

	for nI := 1 to Len(::aLines)
		if (nI != nLine)
			aAdd(aNewLines, ::aLines[nI])
		endIf
	next nI

	::aLines 		:= aNewLines
	::oGrid:aCols	:= ::aLines

	::refresh()

return


/*/{Protheus.doc} setValue

Define valores para as linhas do browse

@type method
@author Victor Hugo
@since 06/01/2014

@param cId, String, Id da Coluna
@param xValue, Indefinido, Valor a ser atribuido
@param nLine, Numerico, Linha do grid. Se não informado considera a linha posicionada.
/*/
method setValue(cId, xValue, nLine) class IpGridObject

	local nColPos	:= ::getColumnPosition(cId)
	default nLine	:= DEFAULT_LINE_POS

	if (nColPos > 0 .and. nLine > 0 .and. Len(::aLines) >= nLine)
		::aLines[nLine,nColPos] := xValue
	endIf

return


/*/{Protheus.doc} getValue

Coleta valores das linhas do browse

@type method
@author Victor Hugo
@since 06/01/2014

@param cId, String, Id da Coluna
@param nLine, Numerico, Linha do grid. Se não informado considera a linha posicionada.
@param lOldValue, Logico, Indica se deve considerar sempre o valor anterior do grid e não o valor que está sendo digitado no momento. Por padrão assume .F.

@return Indefinido Valor da coluna
/*/
method getValue(cId, nLine, lOldValue) class IpGridObject

	local xValue 		:= nil
	local cMemVar 		:= "M->"+cId
	local nColPos		:= ::getColumnPosition(cId)
	default nLine		:= DEFAULT_LINE_POS
	default lOldValue	:= .F.

	if (nColPos > 0 .and. nLine > 0)
		if (!lOldValue .and. Type(cMemVar) != "U" .and. nLine == DEFAULT_LINE_POS)
			xValue := &cMemVar
		elseif (Len(::aLines) >= nLine)
			xValue := ::aLines[nLine,nColPos]
		endIf
	endIf

return xValue


/*/{Protheus.doc} create

Cria o objeto de grid. Deve ser invocado após a criação das colunas e linhas.

@type method
@author Victor Hugo
@since 06/01/2014
/*/
method create() class IpGridObject

	local nI			:= 0
	local nFreeze		:= if(::isFreeze(), 1, 0)
	local nMax			:= 999
	local nOpc			:= ::getAccessMode()
	local cColId		:= ""
	local cLineVld		:= ::getLinesValidation()
	local cLinOk		:= if(Empty(cLineVld), "", cLineVld + " .and. ")+"u_IpGridLineOk()"
	local cDelOk		:= ::getDeleteValidation()
	local cTudoOk		:= "AllwaysTrue()"
	local cFieldOk		:= "u_IpGridFieldOk()"
	local cIniCpos		:= nil
	local cSuperDel		:= nil
	local oCol			:= nil
	local aHeader		:= {}
	local lHasMarkCol 	:= .F.
	public __oIpGrid	:= @self
	
	If !Empty(cDelOk)
		cDelOk += " .And. "
	Endif
	cDelOk += "u_IpGridDelOk()"

	createPublicVars()

	for nI := 1 to Len(::aColumns)
		oCol	:= ::aColumns[nI]
		fillHeader(@aHeader, oCol)
		if oCol:isMarkColumn()
			lHasMarkCol := .T.
		endIf
		If !oCol:isReadOnly()
			addUpdateField(@self,oCol:getID())
		Endif
	next nI

	if (Len(::aLines) == 0)
		::newLine()
	endIf

	::oGrid  := MsNewGetDados():new(::nRow, ::nCol, ::nHeight, ::nWidth, nOpc, cLinOk, cTudoOk, cIniCpos, ::aUpdateFields, nFreeze, nMax, cFieldOk, cSuperDel, cDelOk, ::oWnd, aHeader, ::aLines)
	::aLines := ::oGrid:aCols

	if lHasMarkCol
		::oGrid:oBrowse:blDblClick := {|| onDoubleClick(@self) }
	endIf

	::lCreated := .T.

return

/*/{Protheus.doc} clear

Limpa todos os registros do grid

@type method
@author Victor Hugo / Carlos Eduardo Niemeyer Rodrigues
@since 07/02/2014 / 14/04/2016

@param [lAddNewLine], Lógico, Adiciona uma nova linha após limpar a Grid
/*/
method clear(lAddNewLine) class IpGridObject
	Default lAddNewLine := .F.
	
	::aLines := {}

	if (ValType(::oGrid) == "O")
		::oGrid:aCols := {}
	endIf

	::setFiltered(.F.)
	
	If lAddNewLine
		::newLine()
	Endif
	
	::refresh()

return

/**
 * Trata o duplo click nas linhas do grid
 */
static function onDoubleClick(oObj)

	local oGrid 	:= oObj:oGrid
	local nI		:= 0
	local nAt		:= oGrid:nAt
	local nColMark	:= oObj:getMarkColumnPosition()
	local bOnMark	:= oObj:getOnMark()

	if (oObj:length() == 0) .or. (Len(oObj:oGrid:aCols) == 0)
		return
	endIf

	if oObj:isMarkOne()
		for nI := 1 to Len(oGrid:aCols)
			oObj:setMarkedLine(.F., nI)
		next nI
	endIf

	oGrid:editCell()
	oGrid:aCols[nAt,nColMark] := if(oGrid:aCols[nAt,nColMark] == oObj:getMarkImage(), oObj:getUnMarkImage(), oObj:getMarkImage())
	Eval(bOnMark)

	oObj:refresh()

return

/**
 * Trata o evento ao alterar campos
 */
user function IpGridFieldOk()

	/* Compatibilidade com a função ExistTrigger */
	dbSelectArea("SX7")

	/* Mantém o aLines igual ao aCols */
	__oIpGrid:aLines := __oIpGrid:oGrid:aCols

return .T.

/**
 * Trata o evento ao trocar de linhas
 */
user function IpGridLineOk()

	local lOk := .F.

	begin sequence

		if !chkRequiredFields()
			break
		endIf
		
		lOk := .T.

	end sequence

return lOk

/**
 * Verificação dos campos obrigatórios
 */
static function chkRequiredFields()

 	local lOk			:= .T.
	local nI 			:= 0
	local nLine			:= __oIpGrid:oGrid:nAt
	local aLines 		:= __oIpGrid:aLines
	local aCols			:= __oIpGrid:getColumns()
	local lReadOnly		:= __oIpGrid:isReadOnly()
	local nPosCol		:= 0
	local nPosDel		:= Len(aCols)+1
	local xEmptyValue 	:= nil
	local cEmptyFields	:= ""
	local oUtils		:= IpUtilsObject():newIpUtilsObject()
                     
 	if !lReadOnly        
		if Len(aLines) > 0 .And. aLines[nLine,nPosDel]
			return .T.
		endif
		
		for nI := 1 to Len(aCols)
			if !aCols[nI]:isRequired()
				loop
			endIf
			xEmptyValue := aCols[nI]:getEmptyValue()
			nPosCol	   := __oIpGrid:getColumnPosition(aCols[nI]:getId())
			if (aLines[nLine,nPosCol] == xEmptyValue)
				if !Empty(cEmptyFields)
					cEmptyFields += ", "
				endIf
				cEmptyFields += aCols[nI]:getTitle()
			endIf
		next nI
	
		if !Empty(cEmptyFields)
			lOk := .F.
			MsgBox("Campos obrigatórios não preenchidos: "+CRLF+CRLF+cEmptyFields, "Atenção", "ALERT")
		endIf
   endif
   
return lOk

/**
 * Trata o evento ao exclusão de registros
 */
user function IpGridDelOk()

	/* Mantém o aLines igual ao aCols */
	__oIpGrid:aLines := __oIpGrid:oGrid:aCols

return .T.

/**
 * Cria variaveis publicas para resolver bugs da MsNewGetDados ... :S
 */
static function createPublicVars()
	public A 	:= if(Type("A") == "U", .T., A)
	public N 	:= if(Type("N") == "U", .T., A)
return

/**
 * Preenche o aHeader
 */
static function fillHeader(aHeader, oCol)

	aAdd(aHeader, Array(HEADER_COLUMNS))
	aTail(aHeader)[HEADER_FIELD] 	:= oCol:getId()
	aTail(aHeader)[HEADER_TITLE] 	:= oCol:getTitle()
	aTail(aHeader)[HEADER_PICTURE] 	:= oCol:getPicture()
	aTail(aHeader)[HEADER_SIZE] 	:= oCol:getSize()
	aTail(aHeader)[HEADER_TYPE] 	:= oCol:getType()
	aTail(aHeader)[HEADER_VISUAL] 	:= if(oCol:isReadOnly(), "V", "A")
	if (oCol:isMarkColumn() .or. oCol:isBmpColumn())
		aTail(aHeader)[HEADER_VISUAL] := "S"
	endIf
	aTail(aHeader)[HEADER_DECIMALS]	:= oCol:getDecimals()
	aTail(aHeader)[HEADER_VALID]	:= oCol:getValidation()
	aTail(aHeader)[HEADER_F3]		:= oCol:getF3()
	aTail(aHeader)[HEADER_CBOX]		:= oCol:getComboBox()
	aTail(aHeader)[HEADER_RELATION]	:= oCol:getInitializer()
	aTail(aHeader)[HEADER_CONTEXT]	:= oCol:getContext()
	aTail(aHeader)[HEADER_INIBRW]	:= oCol:getBrowseInitializer()
	aTail(aHeader)[HEADER_BROWSE]	:= oCol:getShowOnBrowse()
	aTail(aHeader)[HEADER_USED]		:= ""

return


/*/{Protheus.doc} markAll

Seleciona todos os registros do grid caso exista a coluna de marcação

@type method
@author Victor Hugo
@since 10/01/2014
/*/
method markAll() class IpGridObject

	local nI 		:= 0
	local nMarks	:= 0
	local nPosMark	:= 0
	local lMark		:= .F.

	if !::hasMarkColumn()
		return
	endIf

	nPosMark := ::getMarkColumnPosition()

	for nI := 1 to Len(::aLines)
		if ::isMarkedLine(nI)
			nMarks++
		endIf
	next nI

	lMark := (nMarks < Len(::aLines))

	for nI := 1 to Len(::aLines)
		::setMarkedLine(lMark, nI)
	next nI

	Eval(::bOnMarkAll)

	::refresh()

return


/*/{Protheus.doc} hasMarkColumn

Verifica se existe uma coluna de marcação no grid

@type method
@author Victor Hugo
@since 10/01/2014

@return Logico Indica se existe uma coluna de marcação no grid
/*/
method hasMarkColumn() class IpGridObject

	local nPosMark			:= ::getMarkColumnPosition()
	local lHasMarkColumn	:= (nPosMark > 0)

return lHasMarkColumn


/*/{Protheus.doc} setMarkedLine

Define se a linha do grid está marcada

@type method
@author Victor Hugo
@since 07/01/2014

@param lMark, Logico, Linha marcada
@param nLine, Numerico, Linha do grid. Se não informado considera a linha posicionada.
/*/
method setMarkedLine(lMark, nLine) class IpGridObject

	local nPosMark	:= ::getMarkColumnPosition()
	local cBmp	 	:= if(lMark, ::getMarkImage(), ::getUnMarkImage())
	default nLine	:= DEFAULT_LINE_POS

	if (nPosMark > 0 .and. nLine > 0 .and. nLine <= Len(::aLines))
		::aLines[nLine,nPosMark] := cBmp
	endIf

return


/*/{Protheus.doc} isMarkedLine

Verifica se a linha do grid está marcada

@type method
@author Victor Hugo
@since 07/01/2014

@param nLine, Numerico, Linha do grid. Se não informado considera a linha posicionada.

@return Logico Indica se a linha está marcada
/*/
method isMarkedLine(nLine) class IpGridObject

	local lIsMarked 	:= .F.
	default nLine   	:= DEFAULT_LINE_POS

	if !::hasMarkColumn()
		return .F.
	endIf

	lIsMarked := (::aLines[nLine,::getMarkColumnPosition()] == ::getMarkImage() )

return lIsMarked


/*/{Protheus.doc} hasMarkedLines

Verifica se existe ao menos uma linha selecionada no grid
	
@type method
@author Victor Hugo
@since 24/07/2014

@param lDeleted, Logico, Indica se deve considerar linhas deletadas. Por padrão assume .F.

@return Logico Indica se existe ao menos uma linha selecionada 
/*/
method hasMarkedLines(lDeleted) class IpGridObject
	
	local nLine			  := 0
	local lHasMarkedLines := .F.
	default lDeleted	  := .F.
	
	for nLine := 1 to ::length()
		if ::isMarkedLine(nLine)
			lHasMarkedLines := .T.	
			if ::isDeletedLine(nLine) .and. !lDeleted
				lHasMarkedLines := .F.
			endIf
		endIf 
		if lHasMarkedLines
			exit
		endIf
	next nLine
	
return lHasMarkedLines


/*/{Protheus.doc} setDeletedLine

Define uma linha como deletada

@type method
@author Victor Hugo
@since 11/01/2014

@param lDeleted, Logico, Indica se a linha deve ficar deletada
@param nLine, Numerico, Linha do grid. Se não informado considera a linha posicionada.
/*/
method setDeletedLine(lDeleted, nLine) class IpGridObject

	local nPosDel	:= DELETED_COL_POS
	default nLine	:= DEFAULT_LINE_POS

	if (nPosDel > 0 .and. Len(::aLines) > 0)
		::aLines[nLine,nPosDel] := lDeleted
		::refresh()
	endIf

return


/*/{Protheus.doc} isDeletedLine

Indica se a linha está deletada

@type method
@author Victor Hugo
@since 11/01/2014

@param nLine, Numerico, Linha do grid. Se não informado considera a linha posicionada.

@return Logico Linha deletada
/*/
method isDeletedLine(nLine) class IpGridObject

	local nPosDel	:= DELETED_COL_POS
	local lDeleted	:= .F.
	default nLine	:= DEFAULT_LINE_POS

	if (nPosDel > 0 .and. Len(::aLines) > 0)
		lDeleted := ::aLines[nLine,nPosDel]
	endIf

return lDeleted

/*/{Protheus.doc} setBmpValue

Define o valor de um bitmap do grid

@type method
@author Victor Hugo
@since 07/01/2014

@param cId, String, Id do Bitmap
@param cBmp, String, Bitmap a ser atribuido. Ex.: (ENABLE, DISABLE, CLR_BLACK, etc.)
@param nLine, Numerico, Linha do grid. Se não informado considera a linha posicionada.
/*/
method setBmpValue(cId, cBmp, nLine) class IpGridObject

	local nI		:= 0
	local nPosBmp	:= 0
	default nLine	:= DEFAULT_LINE_POS

	for nI := 1 to Len(::aColumns)
		if (::aColumns[nI]:isBmpColumn() .and. ::aColumns[nI]:getBmpId() == cId)
			nPosBmp := nI
			exit
		endIf
	next nI

	if (nPosBmp > 0 .and. nLine > 0 .and. nLine <= Len(::aLines))
		::aLines[nLine,nPosBmp] := cBmp
	endIf

return


/*/{Protheus.doc} refresh

Atualização do grid

@type method
@author Victor Hugo
@since 11/01/2014
/*/
method refresh() class IpGridObject

	if (ValType(::oGrid) == "O")
		::oGrid:oBrowse:refresh()
	endIf

return


/*/{Protheus.doc} length

Retorna o número de linhas do grid

@type method
@author Victor Hugo
@since 11/01/2014

@return Numerico Número de linhas do grid
/*/
method length() class IpGridObject

	/* Mantém o aLines igual ao aCols */
	If ValType(::oGrid) == "O" .And. ValType(::oGrid:aCols) == "A" .And. !( Len(::aLines) == Len(::oGrid:aCols) )		
		::aLines := ::oGrid:aCols
	Endif
	
return Len(::aLines)


/*/{Protheus.doc} filter

Filtra o grid. Permitido somente se o grid for somente leitura ( oGrid:setReadOnly(.T.) ).

@type method
@author Victor Hugo
@since 07/02/2014

@param cFilter, String, Expressão de Filtro
@param xColumns, Indefinido, Coluna(s) a ser(em) filtrada(s). Pode receber uma String com o ID de uma coluna ou um vetor com vários IDs. Se não informado considera todas as colunas.
/*/
method filter(cFilter, xColumns) class IpGridObject

	local nI		 	:= 0
	local aLines		:= {}
	local aFilteredLines:= {}
	default xColumns 	:= ""

	if !::isReadOnly()
		MsgBox("Não é possível filtrar um IpGridObject editável", "Atenção", "ALERT")
		return
	endIf

	if Empty(cFilter)
		::clearFilter()
		return
	endIf

	if (Len(::aOldLines) == 0)
		::aOldLines := aClone(::aLines)
	endIf

	aLines := aClone(::aOldLines)

	for nI := 1 to Len(aLines)
		if validFilter(@self, cFilter, xColumns, aLines[nI])
			aAdd(aFilteredLines, aLines[nI])
		endIf
	next nI

	::aLines 	  	:= aClone(aFilteredLines)
	::oGrid:aCols 	:= ::aLines

	::setFiltered(.T.)
	::refresh()

return

/**
 * Valida o Filtro para uma Linha do grid
 */
static function validFilter(oGrid, cFilter, xColumns, aLine)

	local nI		:= 0
	local cColId	:= ""
	local cValue	:= ""
	local aCols		:= oGrid:getColumns()
	local cColumns 	:= getFilterColumns(xColumns)
	local oCol		:= nil
	local oUtils	:= IpUtilsObject():newIpUtilsObject()

	cFilter := Upper(AllTrim(cFilter))

	for nI := 1 to Len(aCols)
		oCol   := aCols[nI]
		cColId := oCol:getId()
		if !(oCol:isMarkColumn() .or. oCol:isBmpColumn()) .and. !Empty(cColumns) .and. !(cColId $ cColumns)
			loop
		endIf
		cValue := Upper(oUtils:strAnyType(aLine[nI]))
		if (cFilter $ cValue) .or. (cFilter == cValue)
			return .T.
		endIf
	next nI

return .F.

/**
 * Define as colunas a serem filtradas
 */
static function getFilterColumns(xColumns)

	local nI	:= 0
	local cRet 	:= ""

	if Empty(xColumns)
		return cRet
	endIf

	if (ValType(xColumns) == "C")
		cRet := xColumns
	elseIf (ValType(xColumns) == "A")
		for nI := 1 to Len(xColumns)
			cRet += if(Empty(cRet), "", ",")
			cRet += xColumns[nI]
		next nI
	endIf

return cRet


/*/{Protheus.doc} clearFilter

Limpa o último filtro aplicado

@type method
@author Victor Hugo
@since 07/02/2014
/*/
method clearFilter() class IpGridObject

	if !::isFiltered()
		return
	endIf

	::aLines 		:= aClone(::aOldLines)
	::oGrid:aCols 	:= ::aLines
	::aOldLines 	:= {}

	::setFiltered(.F.)
	::refresh()

return


/*/{Protheus.doc} getCursorLine

Retorna a linha posicionada

@type method
@author Victor Hugo
@since 14/02/2014

@return Numerico Linha posicionada
/*/
method getCursorLine() class IpGridObject

	local nLine := 0

	if ::isCreated()
		nLine := ::oGrid:nAt
	endIf

return nLine
                
/*    
	Atualiza a Propriedade ReadOnly das colunas conforme o Atributos aUpdateFields
*/
static function setPropertyReadOnly(oObj,oCol)
	
	local nField	:= 0  
	local cField	:= ""
	
	default oCol	:= Nil
	
	If ValType(oObj:aUpdateFields) == "A" .And. Len(oObj:aUpdateFields) > 0
		If ValType(oCol) == "O"
			cField := oCol:getId()
			If isUpdateField(oObj,cField)
				oCol:setReadOnly(.F.)
			Endif
		ElseIf oCol == Nil
			For nField:= 1 To Len(oObj:aColumns)
				oCol := oObj:aColumns[nField]				
				If ValType(oCol) == "O"
					cField := oCol:getId()
					If isUpdateField(oObj,cField)
						oCol:setReadOnly(.F.)
					Else				
						oCol:setReadOnly(.T.)
					Endif
				Endif
			Next nField
		Endif
	Endif

return
        
/*
	Verifica se o Campo faz parte dos campos editáveis
*/
static function isUpdateField(oObj,cField)
	
	local nField := 0                
	local lRet	 := .F.
	
	For nField:= 1 to Len(oObj:aUpdateFields)
		If Upper(AllTrim(oObj:aUpdateFields[nField])) == Upper(AllTrim(cField))
			lRet := .T.
		Endif
	Next nField
	
return (lRet)
                                   
/*
	Atualiza o Array aUpdateFields de acordo com o Campo informado
*/
static function addUpdateField(oObj,cID)

	local nPos := 0
	
	nPos := aScan( oObj:aUpdateFields , {|Record| Upper(AllTrim(Record)) == Upper(AllTrim(cID)) } )
	If nPos == 0
		If ValType(oObj:aUpdateFields) <> "A"
			oObj:aUpdateFields := {}
		Endif
		aAdd( oObj:aUpdateFields , cID )
	Endif
	
return