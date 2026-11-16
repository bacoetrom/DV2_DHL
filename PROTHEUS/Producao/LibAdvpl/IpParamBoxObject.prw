#include "protheus.ch"

/*/{Protheus.doc} IpParamBoxObject

Objeto para apresentação de uma tela de parâmetros

@type class
@author Victor Hugo
@since 11/11/2013
/*/
class IpParamBoxObject from IpAdvplObject

	data cId
	data cTitle
	data aParams
	data bValidation
	data lCanSave
	data lUserSave
	data lCentered
	data cSomething
	data aValues
	data aMvs

	method newIpParamBoxObject() constructor

	method getId()
	method setId()
	method getTitle()
	method setTitle()
	method getParams()
	method getValidation()
	method setValidation()
	method isCanSave()
	method setCanSave()
	method isUserSave()
	method setUserSave()
	method isCentered()
	method setCentered()

	method addParam()
	method show()
	method getValue()

endClass


/*/{Protheus.doc} newIpParamBoxObject

Construtor

@type method
@author Victor Hugo
@since 13/01/2013

@param cId, String, Id do grupo de parametros
@param cTitle, String, Título da tela de parametros
@param bValidation, CodeBlock, Bloco de codigo para validacao quando o usuário clicar em OK
/*/
method newIpParamBoxObject(cId, cTitle, bValidation) class IpParamBoxObject

	default cId 		:= ""
	default cTitle		:= "IpParamBoxObject"
	default bValidation	:= {|| .T. }

	::newIpAdvplObject()

	::aParams := {}
	::aValues := {}
	::aMvs	  := {}

	::setId(cId)
	::setTitle(cTitle)
	::setValidation(bValidation)
	::setCanSave(.T.)
	::setUserSave(.T.)
	::setCentered(.T.)

return

/*/{Protheus.doc} getId

Coleta o ID do objeto

@type method
@author Victor Hugo
@since 13/01/2014

@return String ID do objeto
/*/
method getId() class IpParamBoxObject
return ::cId


/*/{Protheus.doc} setId

Define o ID do objeto

@type method
@author Victor Hugo
@since 13/01/2014

@param cId, String, ID do objeto
/*/
method setId(cId) class IpParamBoxObject
	::cId := cId
return


/*/{Protheus.doc} getTitle

Coleta o Titulo da tela de parametros

@type method
@author Victor Hugo
@since 14/01/2014

@return String Titulo da tela de parametros
/*/
method getTitle() class IpParamBoxObject
return ::cTitle


/*/{Protheus.doc} setTitle

Define o Titulo da tela de parametros

@type method
@author Victor Hugo
@since 14/01/2014

@param cTitle, String, Titulo da tela de parametros
/*/
method setTitle(cTitle) class IpParamBoxObject
	::cTitle := cTitle
return


/*/{Protheus.doc} getParams

Coleta os Parâmetros do objeto

@type method
@author Victor Hugo
@since 13/01/2014

@return Array Parâmetros do objeto
/*/
method getParams() class IpParamBoxObject
return ::aParams


/*/{Protheus.doc} getValidation

Coleta a Validação ao clicar no botão OK da tela de parâmetros

@type method
@author Victor Hugo
@since 13/01/2014

@return CodeBlock Validação ao clicar no botão OK da tela de parâmetros
/*/
method getValidation() class IpParamBoxObject
return ::bValidation


/*/{Protheus.doc} setValidation

Define o Validação ao clicar no botão OK da tela de parâmetros

@type method
@author Victor Hugo
@since 13/01/2014

@param bValidation, CodeBlock, Validação ao clicar no botão OK da tela de parâmetros
/*/
method setValidation(bValidation) class IpParamBoxObject
	::bValidation := bValidation
return


/*/{Protheus.doc} isCanSave

Indica se pode salvar as respostas dos parametros

@type method
@author Victor Hugo
@since 14/01/2014

@return Logico Indica se pode salvar as respostas dos parametros
/*/
method isCanSave() class IpParamBoxObject
return ::lCanSave


/*/{Protheus.doc} setCanSave

Define se pode salvar as respostas dos parametros

@type method
@author Victor Hugo
@since 14/01/2014

@param lCanSave, Logico, Indica se pode salvar as respostas dos parametros
/*/
method setCanSave(lCanSave) class IpParamBoxObject
	::lCanSave := lCanSave
return


/*/{Protheus.doc} isUserSave

Indica se o usuário comum pode salvar as repostas dos parâmetros

@type method
@author Victor Hugo
@since 14/01/2014

@return Logico Indica se o usuário comum pode salvar as repostas dos parâmetros
/*/
method isUserSave() class IpParamBoxObject
return ::lUserSave


/*/{Protheus.doc} setUserSave

Define se o usuário comum pode salvar as repostas dos parâmetros

@type method
@author Victor Hugo
@since 14/01/2014

@param lUserSave, Logico, Indica se o usuário comum pode salvar as repostas dos parâmetros
/*/
method setUserSave(lUserSave) class IpParamBoxObject
	::lUserSave := lUserSave
return


/*/{Protheus.doc} isCentered

Indica se exibe a tela de parametros centralizada

@type method
@author Victor Hugo
@since 14/01/2014

@return Logico Indica se exibe a tela de parametros centralizada
/*/
method isCentered() class IpParamBoxObject
return ::lCentered


/*/{Protheus.doc} setCentered

Define o Indica se exibe a tela de parametros centralizada

@type method
@author Victor Hugo
@since 14/01/2014

@param lCentered, Logico, Indica se exibe a tela de parametros centralizada
/*/
method setCentered(lCentered) class IpParamBoxObject
	::lCentered := lCentered
return


/*/{Protheus.doc} addParams

Adiciona parâmetros tipo IpParamObject

@type method
@author Victor Hugo
@since 13/01/2014

@param oParam, IpParamObject, Parâmetro tipo IpParamObject
/*/
method addParam(oParam) class IpParamBoxObject

	local nI	  	:= 0
	local cMvPar	:= ""
	local lExists	:= .F.

	if (ValType(oParam) != "O")
		return
	endIf

	for nI := 1 to Len(::aParams)
		if (::aParams[nI]:getId() == oParam:getId())
			::aParams[nI] := oParam
			lExists := .T.
			exit
		endIf
	next nI

	if !lExists
		aAdd(::aParams, oParam)
	endIf

return


/*/{Protheus.doc} show

Exibição da tela de parâmetros. Não afeta o conteúdo das variáveis públicas MV_PARs.

@type method
@author Victor Hugo
@since 13/01/2014

@return Logico Indica se o usuário clicou em OK
/*/
method show() class IpParamBoxObject

	local lOk			:= .F.
	local aRet			:= {}
	local aParamBox		:= {}
	local cLoad			:= ::getId()
	local lCanSave		:= ::isCanSave()
	local lUserSave 	:= ::isUserSave()
	local lCentered 	:= ::isCentered()
	local bVldParams	:= ::getValidation()
	private cCadastro	:= ::getTitle()

	if Empty(cLoad)
		MsgBox("Id do grupo de parâmetros não definido", "IpParamBoxObject", "ALERT")
		return
	endIf

	saveMvs(@self:aMvs)

	fillParamBoxArray(self, @aParamBox)

	if ParamBox(aParamBox, "Parâmetros", @aRet, bVldParams, nil, lCentered, nil, nil, nil, cLoad, lCanSave, lUserSave)
		lOk := .T.
		saveMvs(@self:aValues)
		restoreMvs(@self)
	endIf

return lOk

/**
* Salva as variaveis publicas de parâmetros em um vetor
*/
static function saveMvs(aValues)

	local nI 	:= 0
	local cMvPar:= ""

	aValues := {}

	for nI := 1 to 99
		cMvPar := "MV_PAR" + StrZero(nI,2)
		if (fTypeVar(cMvPar))
			aAdd(aValues, &cMvPar)
		else
			aAdd(aValues, nil)
		endIf
	next nI

return

/**
* Popula o array da funcao ParamBox
*/
static function fillParamBoxArray(oParObj, aParamBox)

	local nI 		:= 0
	local aParams	:= oParObj:getParams()

	aParamBox := {}

	for nI := 1 to Len(aParams)
		aAdd(aParamBox, aParams[nI]:toArray())
	next nI

return

/**
* Restaura as variaveis publicas de parâmetros
*/
static function restoreMvs(oObj)

	local nI 	:= 0
	local xValue:= nil

	for nI := 1 to Len(oObj:aMvs)
		cMvPar := "MV_PAR" + StrZero(nI,2)
		xValue := oObj:aMvs[nI]
		if (fTypeVar(cMvPar) .or. ValType(xValue) != "U")
			&cMvPar := xValue
		endIf
	next nI

return

/*/{Protheus.doc} getValue

Coleta o valor de um parâmetro informado pelo usuário

@type method
@author Victor Hugo
@since 13/01/2014

@param cParamId, String, Id do parâmetro

@return Indefinido Valor informado pelo usuário para o parâmetro
/*/
method getValue(cParamId) class IpParamBoxObject

	local nI		:= 0
	local xValue 	:= nil
	local oParam	:= nil
	local cMvPar	:= ""
	local lHasValues:= (Len(::aValues) > 0)
	local oUtils   	:= IpUtilsObject():newIpUtilsObject()

	if !lHasValues
		lHasValues := loadLastValues(@self)
	endIf

	for nI := 1 to Len(::aParams)
		oParam := ::aParams[nI]
		if (oParam:getId() == cParamId)
			if lHasValues
				xValue := ::aValues[nI]
				if (oParam:getType() $ "combo,radio")
					xValue := getComboValue(xValue, oParam)
				endIf
			else
				xValue := oUtils:getDefaultValue(oParam:getDataType())
			endIf
			exit
		endIf
	next nI

return xValue

/**
* Carrega as últimas respostas do usuário
*/
static function loadLastValues(oSelf)

	local oFile	   := nil
	local xValue   := nil
	local cLoad	   := oSelf:getId()
	local cPrbFile := ""
	local cValType := ""
	local cStrValue:= ""

	if Empty(cLoad)
		return .F.
	endIf

	cPrbFile := "\profile\"+__cUserId+"_"+cLoad+".prb"
	oFile    := IpFileObject():newIpFileObject(cPrbFile)

	if !oFile:exists()
		return .F.
	endIf

	oSelf:aValues := {}

	oFile:goTop()
	oFile:skipLine()

	while oFile:notIsEof()

		xValue	  := nil
		cValType  := oFile:readLine(1, 1)
		cStrValue := oFile:readLine(2)

		if (cValType == "C")
			xValue := cStrValue
		elseIf (cValType == "N")
			xValue := Val(cStrValue)
		elseIf (cValType == "D")
			xValue := CtoD(cStrValue)
		elseIf (cValType == "L")
			xValue := if("F" $ cStrValue, .F., .T.)
		endIf

		aAdd(oSelf:aValues, xValue)

		oFile:skipLine()
	endDo

	oFile:close()

return (Len(oSelf:aValues) > 0)

/**
* Coleta o valor de parametros tipo "combo"
*/
static function getComboValue(xMvValue, oParam)

	local xValue	:= nil
	local cDataType	:= oParam:getDataType()
	local aValues	:= oParam:getValues()

	if (ValType(xMvValue) == "N")
		if (cDataType == "N")
			xValue := xMvValue
		else
			xValue := aValues[xMvValue]
		endIf
	elseIf (ValType(xMvValue) == "C")
		if (cDataType == "N")
			xValue := aScan(aValues, xMvValue)
		else
			xValue := xMvValue
		endIf
	endIf

	if (ValType(xValue) == "C")
		xValue := AllTrim(xValue)
	endIf

return xValue


/*
Verifica o tipo da variável
*/
Static Function fTypeVar(cVar)
Return ( Type(cVar) != "U")