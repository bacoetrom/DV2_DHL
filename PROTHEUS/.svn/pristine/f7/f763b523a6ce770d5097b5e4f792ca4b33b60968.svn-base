#include "protheus.ch"		
 
/*/{Protheus.doc} IpParamObject
 
Objeto que representa uma parâmetro da classe IpParamBoxObject

@type class	
@author Victor Hugo
@since 11/11/2013
/*/
class IpParamObject from IpAdvplObject	
	
	data cId
	data cType
	data cDataType
	data cDescription
	data cInitializer
	data cPicture
	data cValidation
	data cF3
	data cWhen
	data nWidth
	data nSize
	data lRequired
	data aValues
	data cFileTypes
	data cFileStartDirectory
	data nFileParams
	data cFilterAlias
	data cFilterWhen
	data nHeight
	data lBold			
	
	method newIpParamObject() constructor	
	
	method getId()
	method setId()
	method getType()
	method setType()
	method getDataType()
	method setDataType()
	method getDescription()
	method setDescription()
	method getInitializer()
	method setInitializer()
	method getPicture()
	method setPicture()
	method getValidation()
	method setValidation()
	method getF3()
	method setF3()
	method getWhen()
	method setWhen()
	method getWidth()
	method setWidth()
	method getSize()
	method setSize()
	method isRequired()
	method setRequired()
	method getValues()
	method setValues()
	method getFileTypes()
	method setFileTypes()	
	method getFileStartDirectory()
	method setFileStartDirectory()
	method getFileParams()
	method setFileParams()
	method getFilterAlias()
	method setFilterAlias()
	method getFilterWhen()
	method setFilterWhen()
	method getHeight()
	method setHeight()	
	method isBold()
	method setBold()
	
	method toArray()
	
endClass


/*/{Protheus.doc} newIpParamObject

Construtor

@type method
@author Victor Hugo
@since 11/11/2013

@param cId, String, Id do Parametro
@param cType, String, Tipo do Parametro. Valores aceitos: "get","combo","radio","checkbox","file","filter","password","say","range","memo" e "user_filter".
@param cDescription, String, Descrição a ser exibida
@param cDataType, String, Tipo de dados. Ex.: "C","N","D" e "L"
@param nWidth, Numerico, Largura do componente visual
@param nSize, Numerico, Tamanho do conteúdo para parametros tipo "get"
/*/
method newIpParamObject(cId, cType, cDescription, cDataType, nWidth, nSize) class IpParamObject	
	
	default cId 			:= ""
	default cType 			:= "get"
	default cDescription 	:= ""
	default cDataType		:= getDefDataType(cType)
	default nWidth			:= 10
	default nSize			:= 10
	
	::newIpAdvplObject()
	
	if (cDataType == "D")
		nWidth := 60
		nSize  := 8
	endIf
	
	::setId(cId)
	::setType(cType)
	::setDescription(cDescription)
	::setDataType(cDataType)
	::setWidth(nWidth)	
	::setSize(nSize)
	::setInitializer(getDefInitializer(cType, cDataType, nSize))
	::setPicture("")
	::setValidation("") 
	::setF3("")
	::setWhen("")
	::setRequired(.F.)
	::setValues({"novalues"})
	::setFileTypes("")
	::setFileStartDirectory("")
	::setFileParams(0)
	::setFilterAlias("")
	::setFilterWhen("")
	::setHeight(10)
	::setBold(.F.)
					
return	

/**
 * Coleta o tipo de dados padrão de acordo com o tipo de parametro
 */
static function getDefDataType(cType)
	
	local cDataType := ""
	
	cType := Lower(AllTrim(cType))
	
	if (cType $ "combo,radio")
		cDataType := "N"
	elseIf (cType == "checkbox")
		cDataType := "L"
	else
		cDataType := "C"		
	endIf
	
return cDataType

/**
 * Coleta o inicializador padrão de acordo com o tipo de parametro e o tipo de dados
 */
static function getDefInitializer(cType, cDataType, nSize)
	
	local xDefInit := nil
	
	cType := Lower(AllTrim(cType))
	
	if (cDataType == "N")
		if (cType $ "combo,radio")
			xDefInit := 1
		else
			xDefInit := 0
		endIf	
	elseIf (cDataType == "D")
		xDefInit := CtoD("")
	elseIf (cDataType == "L")
		xDefInit := .F.
	else
		if (cType != "get")
			nSize := 500
		endIf		 
		xDefInit := Space(nSize)
	endIf 
	
return xDefInit


/*/{Protheus.doc} getId

Coleta o Id do parâmetro
	
@type method
@author Victor Hugo
@since 13/01/2014

@return String Id do Parâmetro
/*/
method getId() class IpParamObject
return ::cId


/*/{Protheus.doc} setId

Define o Id do parâmetro

@type method	
@author Victor Hugo
@since 13/01/2014

@return String Id do Parâmetro
/*/
method setId(cId) class IpParamObject
	::cId := cId
return


/*/{Protheus.doc} getType

Coleta o Tipo do Parâmetro. Valores aceitos: "get","combo","radio","checkbox","file","filter","password","say","range","memo" e "user_filter"
	
@type method	
@author Victor Hugo
@since 13/01/2014

@return String Tipo do Parâmetro
/*/
method getType() class IpParamObject
return ::cType


/*/{Protheus.doc} setType

Define o Tipo do Parâmetro

@type method	
@author Victor Hugo
@since 13/01/2014

@param cType, String, Tipo do Parâmetro
/*/
method setType(cType) class IpParamObject
	::cType := Lower(AllTrim(cType))
return


/*/{Protheus.doc} getDataType

Coleta o Tipo de dados do parâmetro

@type method	
@author Victor Hugo
@since 13/01/2014

@return String Tipo de dados do parâmetro
/*/
method getDataType() class IpParamObject
return ::cDataType


/*/{Protheus.doc} setDataType

Define o Tipo de dados do parâmetro

@type method	
@author Victor Hugo
@since 13/01/2014

@param cDataType, String, Tipo de dados do parâmetro
/*/
method setDataType(cDataType) class IpParamObject
	::cDataType := cDataType
return


/*/{Protheus.doc} getDescription

Coleta a Descrição do parâmetro

@type method	
@author Victor Hugo
@since 13/01/2014

@return String Descrição do parâmetro
/*/
method getDescription() class IpParamObject
return ::cDescription


/*/{Protheus.doc} setDescription

Define a Descrição do parâmetro

@type method	
@author Victor Hugo
@since 13/01/2014

@param cDescription, String, Descrição do parâmetro
/*/
method setDescription(cDescription) class IpParamObject
	::cDescription := cDescription
return


/*/{Protheus.doc} getInitializer

Coleta o Inicializador padrão

@type method	
@author Victor Hugo
@since 13/01/2014

@return String Inicializador padrão
/*/
method getInitializer() class IpParamObject
return ::cInitializer


/*/{Protheus.doc} setInitializer

Define o Inicializador padrão

@type method	
@author Victor Hugo
@since 13/01/2014

@param cInitializer, String, Inicializador padrão
/*/
method setInitializer(cInitializer) class IpParamObject
	::cInitializer := cInitializer
return


/*/{Protheus.doc} getPicture

Coleta a Picture

@type method	
@author Victor Hugo
@since 13/01/2014

@return String Picture
/*/
method getPicture() class IpParamObject
return ::cPicture


/*/{Protheus.doc} setPicture

Define a Picture
	
@type method
@author Victor Hugo
@since 13/01/2014

@param cPicture, String, Picture
/*/
method setPicture(cPicture) class IpParamObject
	::cPicture := cPicture
return


/*/{Protheus.doc} getValidation

Coleta a Validação
	
@type method	
@author Victor Hugo
@since 13/01/2014

@return String Validação
/*/
method getValidation() class IpParamObject
return ::cValidation


/*/{Protheus.doc} setValidation

Define a Validação

@type method	
@author Victor Hugo
@since 13/01/2014

@param cValidation, String, Validação
/*/
method setValidation(cValidation) class IpParamObject
	::cValidation := cValidation
return


/*/{Protheus.doc} getF3

Coleta a Consulta F3

@type method	
@author Victor Hugo
@since 13/01/2014

@return String Consulta F3
/*/
method getF3() class IpParamObject
return ::cF3


/*/{Protheus.doc} setF3

Define a Consulta F3

@type method	
@author Victor Hugo
@since 13/01/2014

@param cF3, String, Consulta F3
/*/
method setF3(cF3) class IpParamObject
	::cF3 := cF3
return


/*/{Protheus.doc} getWhen

Coleta a Validação When

@type method	
@author Victor Hugo
@since 13/01/2014

@return String Validação When
/*/
method getWhen() class IpParamObject
return ::cWhen


/*/{Protheus.doc} setWhen

Define a Validação When

@type method	
@author Victor Hugo
@since 13/01/2014

@param cWhen, String, Validação When
/*/
method setWhen(cWhen) class IpParamObject
	::cWhen := cWhen
return


/*/{Protheus.doc} getWidth

Coleta a Largura do parametro

@type method	
@author Victor Hugo
@since 14/01/2014

@return Numerico Largura do parametro
/*/
method getWidth() class IpParamObject
return ::nWidth


/*/{Protheus.doc} setWidth

Define o Largura do parametro

@type method	
@author Victor Hugo
@since 14/01/2014

@param nWidth, Numerico, Largura do parametro
/*/
method setWidth(nWidth) class IpParamObject
	::nWidth := nWidth
return


/*/{Protheus.doc} getSize

Coleta o Tamanho de parametros tipo "get"

@type method	
@author Victor Hugo
@since 14/01/2014

@return Numerico Tamanho de parametros tipo "get"
/*/
method getSize() class IpParamObject
return ::nSize


/*/{Protheus.doc} setSize

Define o Tamanho de parametros tipo "get"

@type method	
@author Victor Hugo
@since 14/01/2014

@param nSize, Numerico, Tamanho de parametros tipo "get"
/*/
method setSize(nSize) class IpParamObject
	::nSize := nSize
return


/*/{Protheus.doc} isRequired

Indica se parâmetro é obrigatório

@type method	
@author Victor Hugo
@since 13/01/2014

@return Logico Indica se parâmetro é obrigatório
/*/
method isRequired() class IpParamObject
return ::lRequired


/*/{Protheus.doc} setRequired

Define se parâmetro é obrigatório

@type method	
@author Victor Hugo
@since 13/01/2014

@param lRequired, Logico, Indica se parâmetro é obrigatório
/*/
method setRequired(lRequired) class IpParamObject
	::lRequired := lRequired
return


/*/{Protheus.doc} getValues

Coleta Valores para parametros tipo Combo ou Radio

@type method	
@author Victor Hugo
@since 13/01/2014

@return Array Valores para parametros tipo Combo ou Radio
/*/
method getValues() class IpParamObject
return ::aValues


/*/{Protheus.doc} setValues

Define o Valores para parametros tipo Combo ou Radio

@type method	
@author Victor Hugo
@since 13/01/2014

@param aValues, Array, Valores para parametros tipo Combo ou Radio
/*/
method setValues(aValues) class IpParamObject
	::aValues := aValues
return


/*/{Protheus.doc} getFileTypes

Coleta os Tipos de arquivos para parametros tipo "file"

@type method	
@author Victor Hugo
@since 13/01/2014

@return String Tipos de arquivos para parametros tipo "file"
/*/
method getFileTypes() class IpParamObject
return ::cFileTypes


/*/{Protheus.doc} setFileTypes

Define os Tipos de arquivos para parametros tipo "file"

@type method	
@author Victor Hugo
@since 13/01/2014

@param cFileTypes, String, Tipos de arquivos para parametros tipo "file"
/*/
method setFileTypes(cFileTypes) class IpParamObject
	::cFileTypes := cFileTypes
return


/*/{Protheus.doc} getFileStartDirectory

Coleta o Diretório inicial para parametros tipo "file"

@type method	
@author Victor Hugo
@since 13/01/2014

@return String Diretório inicial para parametros tipo "file"
/*/
method getFileStartDirectory() class IpParamObject
return ::cFileStartDirectory


/*/{Protheus.doc} setFileStartDirectory

Define o Diretório inicial para parametros tipo "file"

@type method	
@author Victor Hugo
@since 13/01/2014

@param cFileStartDirectory, String, Diretório inicial para parametros tipo "file"
/*/
method setFileStartDirectory(cFileStartDirectory) class IpParamObject
	::cFileStartDirectory := cFileStartDirectory
return


/*/{Protheus.doc} getFileParams

Coleta os Parametros de objetos tipo "file"

@type method	
@author Victor Hugo
@since 13/01/2014

@return Numerico Parametros de objetos tipo "file"
/*/
method getFileParams() class IpParamObject
return ::nFileParams


/*/{Protheus.doc} setFileParams

Define os Parametros de objetos tipo "file"

@type method	
@author Victor Hugo
@since 13/01/2014

@param nFileParams, Numerico, Parametros de objetos tipo "file"
/*/
method setFileParams(nFileParams) class IpParamObject
	::nFileParams := nFileParams
return


/*/{Protheus.doc} getFilterAlias

Coleta o Alias para parametros tipo "filter"

@type method	
@author Victor Hugo
@since 13/01/2014

@return String Alias para parametros tipo "filter"
/*/
method getFilterAlias() class IpParamObject
return ::cFilterAlias


/*/{Protheus.doc} setFilterAlias

Define o Alias para parametros tipo "filter"

@type method	
@author Victor Hugo
@since 13/01/2014

@param cFilterAlias, String, Alias para parametros tipo "filter"
/*/
method setFilterAlias(cFilterAlias) class IpParamObject
	::cFilterAlias := cFilterAlias
return


/*/{Protheus.doc} getFilterWhen

Coleta a Validação When de parametros tipo "filter"

@type method	
@author Victor Hugo
@since 13/01/2014

@return String Validação When de parametros tipo "filter"
/*/
method getFilterWhen() class IpParamObject
return ::cFilterWhen


/*/{Protheus.doc} setFilterWhen

Define a Validação When de parametros tipo "filter"

@type method	
@author Victor Hugo
@since 13/01/2014

@param cFilterWhen, String, Validação When de parametros tipo "filter"
/*/
method setFilterWhen(cFilterWhen) class IpParamObject
	::cFilterWhen := cFilterWhen
return


/*/{Protheus.doc} getHeight

Coleta a Altura de parametros tipo "say"

@type method	
@author Victor Hugo
@since 13/01/2014

@return Numerico Altura de parametros tipo "say"
/*/
method getHeight() class IpParamObject
return ::nHeight


/*/{Protheus.doc} setHeight

Define a Altura de parametros tipo "say"

@type method	
@author Victor Hugo
@since 13/01/2014

@param nHeight, Numerico, Altura de parametros tipo "say"
/*/
method setHeight(nHeight) class IpParamObject
	::nHeight := nHeight
return


/*/{Protheus.doc} isBold

Indica se o parametro tipo "say" será exibido em negrito

@type method	
@author Victor Hugo
@since 14/01/2014

@return Logico Indica se o parametro tipo "say" será exibido em negrito
/*/
method isBold() class IpParamObject
return ::lBold


/*/{Protheus.doc} setBold

Define se o parametro tipo "say" será exibido em negrito

@type method	
@author Victor Hugo
@since 14/01/2014

@param lBold, Logico, Indica se o parametro tipo "say" será exibido em negrito
/*/
method setBold(lBold) class IpParamObject
	::lBold := lBold
return


/*/{Protheus.doc} toArray

Converte o parametro em Array para a função ParamBox

@type method	
@author Victor Hugo
@since 14/01/2014

@return Array Array para a função ParamBox
/*/
method toArray() class IpParamObject
	
	local aArray	:= {}
	local cType		:= Lower(AllTrim(::getType()))
	
	if (cType == "get")
		aArray := {1, ::getDescription(), ::getInitializer(), ::getPicture(), ::getValidation(), ::getF3(), ::getWhen(), ::getWidth(), ::isRequired()}
	elseIf (cType == "combo") 
		aArray := {2, ::getDescription(), ::getInitializer(), ::getValues(), ::getWidth(), ::getValidation(), ::isRequired()}
	elseIf (cType == "radio")
		aArray := {3, ::getDescription(), ::getInitializer(), ::getValues(), ::getWidth(), ::getValidation(), ::isRequired(), ::getWhen()}
	elseIf (cType == "checkbox")
		aArray :=	 {4, ::getDescription(), ::getInitializer(), nil, ::getWidth(), ::getValidation(), ::isRequired()}
	elseIf (cType == "file")
		aArray := {6, ::getDescription(), ::getInitializer(), ::getPicture(), ::getValidation(), ::getWhen(), ::getWidth(), ::isRequired(), ::getFileTypes(), ::getFileStartDirectory(), ::getFileParams()}
	elseIf (cType == "filter")
		aArray := {7, ::getDescription(), ::getFilterAlias(), ::getInitializer(), ::getFilterWhen()}
	elseIf (cType == "password")
		aArray := {8, ::getDescription(), ::getInitializer(), ::getPicture(), ::getValidation(), ::getF3(), ::getWhen(), ::getWidth(), ::isRequired()}
	elseIf (cType == "say")
		aArray := {9, ::getDescription(), ::getWidth(), ::getHeight(), ::isBold()}
	elseIf (cType == "range")
		aArray := {10, ::getDescription(), ::getInitializer(), ::getF3(), ::getWidth(), ::getDataType(), 500, ::getWhen()}
	elseIf (cType == "memo")
		aArray := {11, ::getDescription(), ::getInitializer(), ::getValidation(), ::getWhen(), ::isRequired()}
	elseIf (cType == "user_filter")
		aArray := {12, ::getDescription(), ::getFilterAlias(), ::getInitializer(), ::getWhen()}
	endIf
	
return aArray