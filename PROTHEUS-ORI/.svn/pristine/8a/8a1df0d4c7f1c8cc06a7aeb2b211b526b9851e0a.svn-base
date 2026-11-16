#include "protheus.ch"	
#include "topconn.ch"
 
/*/{Protheus.doc} IpColumnObject
 
Colunas do objeto IpGridObject

@type class	
@author Victor Hugo
@since 06/01/2014
/*/
class IpColumnObject from IpAdvplObject	
	
	data cId
	data cBmpId
	data cTitle
	data cType
	data nSize
	data cPicture
	data nDecimals
	data cValidation
	data cF3
	data cComboBox
	data cInitializer
	data lReadOnly	
	data cContext
	data cBrowseInitializer
	data cShowOnBrowse
	data lMarkColumn
	data lBmpColumn
	data lSx3
	data lRequired
	
	method newIpColumnObject() constructor	
	
	method getId()
	method setId()
	method getBmpId()
	method setBmpId()
	method getTitle()
	method setTitle()
	method getType()
	method setType()
	method getSize()
	method setSize()
	method getPicture()
	method setPicture()
	method getDecimals()
	method setDecimals()
	method getValidation()
	method setValidation()
	method getF3()
	method setF3()
	method getComboBox()
	method setComboBox()
	method getInitializer()
	method setInitializer()
	method isReadOnly()
	method setReadOnly()
	method getContext()
	method setContext()
	method getBrowseInitializer()
	method setBrowseInitializer()
	method getShowOnBrowse()
	method setShowOnBrowse()
	method isMarkColumn()
	method isBmpColumn()
	method isSx3()
	method isRequired()
	method setRequired()
	
	method getEmptyValue()
	
endClass


/*/{Protheus.doc} newIpColumnObject

Construtor

@type method
@author Victor Hugo
@since 06/01/2014

@param cId, String, Id da Coluna. Informe @mark para criar uma coluna de marcação ou @bmp para criar uma de bitmap.
@param cTitle, String, Titulo da Coluna. Para mark ou bitmap o titulo refere-se ao id da coluna.
@param cType, String, Tipo da Coluna ("C","N","D")
@param nSize, Numerico, Largura da Coluna
@param nDecimals, Numerico, Decimais da Coluna
@param cPicture, String, Picture da Coluna 
/*/
method newIpColumnObject(cId, cTitle, cType, nSize, nDecimals, cPicture) class IpColumnObject	
	
	default cId			:= ""
	default cTitle 		:= ""
	default cType  		:= "C"
	default nSize	 	:= 10
	default nDecimals	:= 0
	default cPicture	:= ""	
	
	::newIpAdvplObject()
	
	::cId := cId
	::setBmpId("")
	::setTitle(cTitle)
	::setType(cType)
	::setSize(nSize)
	::setDecimals(nDecimals)
	::setPicture(cPicture)
	::setValidation("")
	::setF3("")
	::setComboBox("")
	::setInitializer("")
	::setReadOnly(.F.)
	::setContext("V")    	
	::setBrowseInitializer("")
	::setShowOnBrowse("S")
	::setRequired(.F.)
	
	::lMarkColumn	:= .F.
	::lBmpColumn 	:= .F.
	::lSx3			:= .F.
	
	checkMarkBmp(@self)
	checkSx3(@self)
	
return	

/**
 * Verifica se a coluna é um mark ou bitmap
 */
static function checkMarkBmp(oCol)
	
	local cId 	:= Lower(AllTrim(oCol:getId()))
	local lMark	:= (Left(cId, 5) == "@mark")
	local lBmp	:= (Left(cId, 4) == "@bmp")
	
	if (lMark .or. lBmp)
		oCol:setId("CHECKBOL")
		oCol:setBmpId(oCol:getTitle()) 
		oCol:setTitle("")
		oCol:setPicture("@BMP")
		oCol:setSize(10)
		oCol:setType("C") 
		oCol:setContext("V")
		oCol:setBrowseInitializer(if(lMark, "mark", "legenda"))
		oCol:setShowOnBrowse("V")
		oCol:setReadOnly(.T.)
		oCol:lMarkColumn := lMark
		oCol:lBmpColumn  := lBmp		
	endIf
	
return

/**
 * Verifica se o campo existe no SX3
 */
static function checkSx3(oCol)
	
	local cId		:= oCol:getId()
	local cQuery	:= ""
	local cAlias	:= ""
	
	if (Empty(cId) .or. "@" $ cId)
		return
	endIf
	
	cAlias	:= GetNextAlias()
	
	cQuery := "SELECT " + CRLF
	
	#ifdef SPANISH
		cQuery += "	X3_TITSPA AS X3TITULO, " + CRLF
	#else
		#ifdef ENGLISH
			cQuery += "	X3_TITENG AS X3TITULO, " + CRLF
		#else
			cQuery += "	X3_TITULO AS X3TITULO, " + CRLF
		#endif
	#endif
		
	cQuery += "	X3_TIPO AS X3TIPO, " + CRLF
	cQuery += "	X3_TAMANHO AS X3TAMANHO, " + CRLF
	cQuery += "	X3_PICTURE AS X3PICTURE, " + CRLF
	cQuery += "	X3_DECIMAL AS X3DECIMAL, " + CRLF
	cQuery += "	X3_VALID AS X3VALID, " + CRLF
	cQuery += "	X3_F3 AS X3F3, " + CRLF
	cQuery += "	X3_CBOX AS X3CBOX, " + CRLF
	cQuery += "	X3_RELACAO AS X3RELACAO, " + CRLF
	cQuery += "	X3_VISUAL AS X3VISUAL " + CRLF
	cQuery += "FROM " + CRLF
	cQuery += "	" + RetSqlName("SX3") + " " + CRLF
	cQuery += "WHERE 1=1" + CRLF
	cQuery += "	AND X3_CAMPO  = '" + cId + "' " + CRLF
	cQuery += "	AND D_E_L_E_T_ = ' ' " + CRLF
	
	TcQuery cQuery NEW Alias &cAlias
	
	If (cAlias)->(!Eof())
		oCol:setTitle(AllTrim((cAlias)->X3TITULO))
		oCol:setType((cAlias)->X3TIPO)
		oCol:setSize((cAlias)->X3TAMANHO)
		oCol:setPicture((cAlias)->X3PICTURE)
		oCol:setDecimals((cAlias)->X3DECIMAL)
		oCol:setValidation((cAlias)->X3VALID)
		oCol:setF3((cAlias)->X3F3)
		oCol:setComboBox((cAlias)->X3CBOX)
		oCol:setInitializer((cAlias)->X3RELACAO)
		oCol:setReadOnly((cAlias)->X3VISUAL == "V")	
		oCol:lSx3 := .T.
	EndIf
	
	(cAlias)->(DbCloseArea())

return


/*/{Protheus.doc} getId

Coleta o ID da coluna
	
@type method
@author Victor Hugo
@since 06/01/2014

@return String ID da Coluna
/*/
method getId() class IpColumnObject
return ::cId


/*/{Protheus.doc} setId

Define o ID da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@param cId, String, ID da Coluna
/*/
method setId(cId) class IpColumnObject
	::cId := cId
	checkMarkBmp(@self)
	checkSx3(@self)
return


/*/{Protheus.doc} getBmpId

Coleta o ID de Bitmap da coluna
	
@type method
@author Victor Hugo
@since 06/01/2014

@return String ID de Bitmap
/*/
method getBmpId() class IpColumnObject
return ::cBmpId


/*/{Protheus.doc} setBmpId

Define o ID de Bitmap da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@param cId, String, ID de Bitmap
/*/
method setBmpId(cBmpId) class IpColumnObject
	::cBmpId := cBmpId
return


/*/{Protheus.doc} getTile

Coleta o Título da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@return String Título da coluna
/*/
method getTitle() class IpColumnObject
return ::cTitle


/*/{Protheus.doc} setTitle

Define o Título da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@param cTitle, String, Título da Coluna
/*/
method setTitle(cTitle) class IpColumnObject
	::cTitle := cTitle
return


/*/{Protheus.doc} getType

Coleta o Tipo da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@return String Tipo da coluna
/*/
method getType() class IpColumnObject	
return ::cType


/*/{Protheus.doc} setType

Define o Tipo da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@param cType, String, Tipo da Coluna
/*/
method setType(cType) class IpColumnObject
	::cType := cType
return


/*/{Protheus.doc} getSize

Coleta o Tamanho da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@return Numerico Tamanho da coluna
/*/
method getSize() class IpColumnObject
return ::nSize


/*/{Protheus.doc} setSize

Define o Tamanho da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@param nSize, Numerico, Tamanho da Coluna
/*/
method setSize(nSize) class IpColumnObject
	::nSize := nSize
return


/*/{Protheus.doc} getPicture

Coleta a Picture da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@return String Picture da coluna
/*/	
method getPicture() class IpColumnObject
return ::cPicture


/*/{Protheus.doc} setPicture

Define a Picture da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@param cPicture, String, Picture da Coluna
/*/
method setPicture(cPicture) class IpColumnObject
	::cPicture := cPicture
return


/*/{Protheus.doc} getDecimals

Coleta os Decimais da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@return String Decimais da coluna
/*/
method getDecimals() class IpColumnObject
return ::nDecimals


/*/{Protheus.doc} setDecimals

Define os Decimais da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@param nDecimals, Numerico, Decimais da Coluna
/*/
method setDecimals(nDecimals) class IpColumnObject
	::nDecimals := nDecimals
return 


/*/{Protheus.doc} getValidation

Coleta a Validação da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@return String Validação da coluna
/*/	
method getValidation() class IpColumnObject
return ::cValidation


/*/{Protheus.doc} setValidation

Define a Validação da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@param cValidation, String, Validação da Coluna
/*/
method setValidation(cValidation) class IpColumnObject
	::cValidation := cValidation
return


/*/{Protheus.doc} getF3

Coleta a consulta F3 da coluna
	
@type method	
@author Victor Hugo
@since 06/01/2014

@return String Consulta F3 da coluna
/*/
method getF3() class IpColumnObject
return ::cF3


/*/{Protheus.doc} setF3

Define a Consulta F3 da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@param cF3, String, Consulta F3 da Coluna
/*/
method setF3(cF3) class IpColumnObject
	::cF3 := cF3
return


/*/{Protheus.doc} getComboBox

Coleta o ComboBox da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@return String ComboBox da coluna
/*/
method getComboBox() class IpColumnObject
return ::cComboBox


/*/{Protheus.doc} setComboBox

Define o ComboBox da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@param cComboBox, String, ComboBox da Coluna
/*/
method setComboBox(cComboBox) class IpColumnObject
	::cComboBox := cComboBox
return


/*/{Protheus.doc} getInitializer

Coleta o Inicializador padrão da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@return String Inicializador da coluna
/*/
method getInitializer() class IpColumnObject
return ::cInitializer


/*/{Protheus.doc} setInitializer

Define o Inicializador padrão da coluna

@type method	
@author Victor Hugo
@since 06/01/2014

@param cInitializer, String, Inicializador padrão da Coluna
/*/
method setInitializer(cInitializer) class IpColumnObject
	::cInitializer := cInitializer
return


/*/{Protheus.doc} isReadOnly

Indica se a coluna é somente visualização

@type method	
@author Victor Hugo
@since 06/01/2014

@return Logico Somente visualização
/*/
method isReadOnly() class IpColumnObject
return ::lReadOnly


/*/{Protheus.doc} setReadOnly

Define se a coluna é somente visualização

@type method	
@author Victor Hugo
@since 06/01/2014

@param lReadOnly, Logico, Somente visualização
/*/
method setReadOnly(lReadOnly) class IpColumnObject
	::lReadOnly := lReadOnly
return

/*/{Protheus.doc} getContext

Coleta o contexto do campo ("R"=Real, "V"=Virtual)

@type method	
@author Victor Hugo
@since 06/01/2014

@return String Contexto do campo
/*/
method getContext() class IpColumnObject
return ::cContext


/*/{Protheus.doc} setContext

Define o contexto do campo ("R"=Real, "V"=Virtual)

@type method	
@author Victor Hugo
@since 06/01/2014

@param cContext, String, Contexto do campo
/*/
method setContext(cContext) class IpColumnObject
	::cContext := cContext
return


/*/{Protheus.doc} getBrowseInitializer

Coleta o inicializador do browse

@type method	
@author Victor Hugo
@since 06/01/2014

@return String Inicializador do browse
/*/
method getBrowseInitializer() class IpColumnObject
return ::cBrowseInitializer


/*/{Protheus.doc} setBrowseInitializer

Define o inicializador do browse

@type method	
@author Victor Hugo
@since 06/01/2014

@param cBrowseInitializer, String, Inicializador do browse
/*/
method setBrowseInitializer(cBrowseInitializer) class IpColumnObject
	::cBrowseInitializer := cBrowseInitializer
return


/*/{Protheus.doc} getShowOnBrowse

Indica se exibe a coluna em Browses ("S","N")

@type method	
@author Victor Hugo
@since 06/01/2014

@return String Exibe a coluna em Browses
/*/
method getShowOnBrowse() class IpColumnObject 
return ::cShowOnBrowse


/*/{Protheus.doc} setShowOnBrowse

Define se exibe a coluna em Browses ("S"/"N")

@type method	
@author Victor Hugo
@since 06/01/2014

@param cShowOnBrowse, String, Exibe a coluna em Browses
/*/
method setShowOnBrowse(cShowOnBrowse) class IpColumnObject
	::cShowOnBrowse := cShowOnBrowse
return
	

/*/{Protheus.doc} isMarkColumn

Indica se é uma coluna de seleção de registros

@type method	
@author Victor Hugo
@since 06/01/2014

@return Logico Coluna de seleção de registros
/*/
method isMarkColumn() class IpColumnObject	
return ::lMarkColumn


/*/{Protheus.doc} isBmpColumn

Indica se é uma coluna tipo bitmap
	
@type method	
@author Victor Hugo
@since 06/01/2014

@return Logico Coluna tipo bitmap
/*/
method isBmpColumn() class IpColumnObject	
return ::lBmpColumn 


/*/{Protheus.doc} isSx3

Indica se a coluna foi criada a partir do SX3

@type method	
@author Victor Hugo
@since 06/01/2014

@return Logico Coluna criada a partir do SX3
/*/
method isSx3() class IpColumnObject	
return ::lSx3 


/*/{Protheus.doc} isRequired

Indica se é um campo de preenchimento obrigatório

@type method	
@author Victor Hugo
@since 06/01/2014

@return Logico Campo de preenchimento obrigatório
/*/
method isRequired() class IpColumnObject
return ::lRequired


/*/{Protheus.doc} setRequired

Define se é um campo de preenchimento obrigatório

@type method	
@author Victor Hugo
@since 06/01/2014

@param lRequired, Logico, Campo de preenchimento obrigatório
/*/
method setRequired(lRequired) class IpColumnObject
	::lRequired := lRequired
return

/*/{Protheus.doc} getEmptyValue

Retorna um valor para uma coluna vazia

@type method	
@author Victor Hugo
@since 10/01/2014

@return Indefinido Valor para uma coluna vazia
/*/
method getEmptyValue() class IpColumnObject
	
	local xValue 	:= nil
	local cType  	:= ::getType()
	local nSize		:= ::getSize()
	
	if ::isSx3()
		xValue := CriaVar(::getId(), .T.)
	else
		if (cType $ "C,M")
			xValue := Space(nSize)	
		elseIf (cType == "N")
			xValue := 0
		elseIf (cType == "D")
			xValue := CtoD("")
		elseIf (cType == "L")
			xValue := .F.			
		endIf
	endIf		
	
return xValue