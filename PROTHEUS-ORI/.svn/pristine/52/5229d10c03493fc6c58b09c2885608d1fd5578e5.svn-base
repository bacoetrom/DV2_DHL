#include "protheus.ch"
#include "rwmake.ch"

/*/{Protheus.doc} IpUtilsObject

Objeto com funcionalidades genéricas

@type class
@author Victor Hugo
@since 11/11/2013
/*/
class IpUtilsObject from IpAdvplObject

	method newIpUtilsObject() constructor

	/* Declare e implemente os métodos em ordem alfabética para facilitar a busca */

	method checkAdvplCode()
	method concatDirectory()
	method getAge()
	method getDefaultValue()
	method getErroAuto()
	method getObjectProperty()
	method hasOnlyNumbers()
	method isInJob()
	method isOnServer()
	method isWorkDay()
	method noAccent()
	method padrSx3()
	method restAreas()
	method saveAreas()
	method showHelp()
	method strAnyType()
	method weekOfMonth()

endClass


/*/{Protheus.doc} newIpUtilsObject

Construtor

@type method
@author Victor Hugo
@since 11/11/2013
/*/
method newIpUtilsObject() class IpUtilsObject

	::newIpAdvplObject()

return


/*/{Protheus.doc} checkAdvplCode

Validação de expressõs Advpl

@type method
@author Victor Hugo
@since 04/01/2014

@param cCode, String, Código a ser validado

@return Logico Indica se o código é valido
/*/
method checkAdvplCode(cCode) class IpUtilsObject

	local lOk		:= .T.
	local bError 	:= ErrorBlock({ |oError| MsgBox(cCode+CRLF+CRLF+oError:Description, "Expressão Inválida", "ALERT"), lOk := .F. })
	default cCode	:= &(ReadVar())

	&(AllTrim(cCode))

	ErrorBlock(bError)

return lOk


/*/{Protheus.doc} concatDirectory

Concatena uma string com o diretório de um arquivo

@type method
@author Victor Hugo
@since 21/01/2014

@param cDirectory, String, Diretório
@param cFile, String, Arquivo

@return String String concatenada com o diretório e o arquivo
/*/
method concatDirectory(cDirectory, cFile) class IpUtilsObject

	local cRet := ""
	local cBar := ""	
	
	if ("/" $ cDirectory)
		cBar := "/"
	elseIf ("\" $ cDirectory)
		cBar := "\"
	endIf	

	cDirectory := AllTrim(cDirectory)
	
	if Empty(cBar)
		cDirectory := "\"+cDirectory+"\"
	else
		if (Right(cDirectory, 1) != cBar)
			cDirectory += cBar
		endIf
	endIf	

	cRet := cDirectory+AllTrim(cFile)

return cRet


/*/{Protheus.doc} getAge

Coleta Idade a partir de uma Data de Nascimento
	
@type method	
@author Victor Hugo
@since 19/01/2015

@param dBirth, Date, Data de Nascimento
@param dDateRef, Date, Data de Referência

@return Numerico Idade calculada
/*/
method getAge(dBirth, dDateRef) class IpUtilsObject
	
	local nAge       := 0
	local nDay		 := Day(dBirth)
	local nMonth	 := Month(dBirth)
	local dAux		 := (dBirth + 1)
	default dDateRef := dDataBase
	
	while (dAux <= dDateRef)
		if (Day(dAux) == nDay .and. Month(dAux) == nMonth)
			nAge++
		endIf               
		dAux++
	endDo
	
return AllTrim(Str(nAge))


/*/{Protheus.doc} getDefaultValue

Coleta o Valor padrão de acordo com o tipo de dados. Ex.: C="", N=0, D=CtoD(""), L=.F., O=nil

@type method	
@author Victor Hugo
@since 05/09/2014

@param cValType, String, Tipo de dados. Ex.: C=String, N=Numerico, D=Data, L=Lógico, O=Objeto

@return Indefinido Valor padrão de acordo com o tipo de dados
/*/
method getDefaultValue(cValType) class IpUtilsObject

	local xValue     := nil
	default cValType := ""
	
	if (cValType == "C")
		xValue := ""
	elseIf (cValType == "N")
		xValue := 0
	elseIf (cValType == "D")
		xValue := CtoD("")
	elseIf (cValType == "L")
		xValue := .F.
	elseIf (cValType == "O")
		xValue := nil
	endIf
	
return xValue


/*/{Protheus.doc} getErroAuto

Coleta erros de rotinas automáticas a partir dos arquivos gerados no servidor

@type method
@author Victor Hugo
@since 04/01/2014

@return String Mensagem de erro
/*/
method getErroAuto() class IpUtilsObject
	
	local cErroAuto := ""
	local cFile     := NomeAutoLog()

	if !Empty(cFile) .and. File(cFile)
		cErroAuto := MemoRead(cFile)
		FErase(cFile)
	endIf
	
	/*
	local aErro		:= {}
	local nX		:= 0
	
	aErro := GetAutoGrLog()
	if len(aErro) > 0
		for nX := 1 to len(aErro)
			cErroAuto += aErro[nX] + CRLF
		next nX
	endIf
	*/
return cErroAuto


/*/{Protheus.doc} getObjectProperty

Coleta propriedades de um objeto testando sua existência
	
@type method	
@author Victor Hugo
@since 08/01/2015

@param oObject, Objeto, Instância do objeto
@param cProperty, String, Propriedade do objeto

@return Indefinido Valor da Propriedade
/*/
method getObjectProperty(oObject, cProperty) class IpUtilsObject
	
	local xValue  := nil
	local cMacro  := ""
	private _oObj := oObject
	
	cMacro := "_oObj:"+cProperty
	
	if (Type(cMacro) != "U")
		xValue := &cMacro
	endIf
	
return xValue


/*/{Protheus.doc} hasOnlyNumbers

Verifica se uma string possui apenas números

@type method
@author Victor Hugo
@since 04/01/2014

@param cString, String, String a ser verificada

@return Logico Indica se a string possui apenas números
/*/
method hasOnlyNumbers(cString) class IpUtilsObject

	local nI		   	:= 0
	local cChr			:= ""
	local cNumbers		:= "0123456789"
	local lOnlyNumbers 	:= .T.

	cString := AllTrim(cString)

	for nI := 1 to Len(cString)
		cChr := SubStr(cString, nI, 1)
		if !(cChr $ cNumbers)
			lOnlyNumbers := .F.
			exit
		endIf
	next nI

return lOnlyNumbers


/*/{Protheus.doc} isInJob

Verifica se está executando em Job (sem interface de usuário)

@type method
@author Victor Hugo
@since 04/01/2014

@return Logico Indica se está em Job
/*/
method isInJob() class IpUtilsObject
return (Type("oMainWnd") <> "O")


/*/{Protheus.doc} isOnServer

Indica se um recurso está no Servidor do Protheus (rootpath)

@type method	
@author Victor Hugo
@since 01/09/2014

@param cSrc, String, Diretório ou Arquivo

@return Logico Indica se o recurso informado está no Servidor
/*/
method isOnServer(cSrc) class IpUtilsObject
	
	local lServer 		:= .F.
	local lWindowsLocal	:= .F.
	
	if (ValType(cSrc) != "C")
		return .F.				
	endIf
	
	cSrc 		  := AllTrim(cSrc)	
	lWindowsLocal := (SubStr(cSrc, 2, 1) == ":") 
	lUnixLocal	  := ("/" $ cSrc)
	lServer 	  := (!lWindowsLocal .and. !lUnixLocal)
				
return lServer


/*/{Protheus.doc} noAccent

Remove acentos ou caracteres especiais de uma string

@type method
@author Victor Hugo
@since 04/01/2014

@param cString, String, String a ser tratada

@return String String sem acentos ou caracteres especiais
/*/
method noAccent(cString) class IpUtilsObject

	local nI     		:= 0
	local nY     		:= 0
	local nAt			:= 0
	local aChrsEsp		:= {}
	local cChr			:= ""
	local cVogais		:= "aeiouAEIOU"
	local cAgudos		:= "áéíóú"+"ÁÉÍÓÚ"
	local cCircunflexos := "âêîôû"+"ÂÊÎÔÛ"
	local cTremas 		:= "äëïöü"+"ÄËÏÖÜ"
	local cCrases 		:= "àèìòù"+"ÀÈÌÒÙ"
	local cTios   		:= "ãõ"
	local cCecidilhas 	:= "çÇ"

	cString := AllTrim(cString)

	aAdd(aChrsEsp, {cAgudos,cVogais})
	aAdd(aChrsEsp, {cCircunflexos,cVogais})
	aAdd(aChrsEsp, {cTremas,cVogais})
	aAdd(aChrsEsp, {cCrases,cVogais})
	aAdd(aChrsEsp, {cTios,"ao"})
	aAdd(aChrsEsp, {cCecidilhas,"cC"})

	for nI := 1 to Len(cString)
		cChr := SubStr(cString, nI, 1)
		for nY := 1 to Len(aChrsEsp)
			nAt := At(cChr, aChrsEsp[nY,1])
			if (nAt > 0)
				cString := StrTran(cString, cChr, SubStr(aChrsEsp[nY,2], nAt, 1))
			endIf
		next nI
		if (Asc(cChr) < 32 .or. Asc(cChr) > 123 .or. cChr $ "&")
			cString := StrTran(cString, cChr, ".")
		endIf
	next nI

return _NoTags(cString)


/*/{Protheus.doc} padrSx3

Coloca espaços à direita em uma String conforme um campo do SX3

@type method
@author Victor Hugo
@since 04/01/2014

@param cString, String, String a ser tratada
@param cField, String, Campo do SX3

@return String String tratada
/*/
method padRSx3(cString, cField) class IpUtilsObject

	local aAreaSX3 := SX3->(GetArea())

	cStr := PadR(AllTrim(cString), GetSx3Cache(cField,"X3_TAMANHO"))

	RestArea(aAreaSX3)

return cString


/*/{Protheus.doc} saveAreas

Salva várias áreas de aliases

@type method
@author Victor Hugo
@since 04/01/2014

@param aAreas, Array, Aliases a serem salvos. Ex.: aAreas := {"SB1","SA1","SA3"}

@return Array Array contendo as áreas salvas
/*/
method saveAreas(aAreas) class IpUtilsObject

	local nI		:= 0
	local aSave 	:= {}
	local cAlias	:= ""
	default aAreas	:= {}

	for nI := 1 to Len(aAreas)
		cAlias := aAreas[nI]
		aAdd(aSave, (cAlias)->(GetArea()))
	next nI

	aAdd(aSave, GetArea())

return aSave


/*/{Protheus.doc} restAreas

Restaura várias áreas de aliases

@type method
@author Victor Hugo
@since 04/01/2014

@param aAreas, Array, Áreas salvas pelo método IpUtilsObject():saveAreas()
/*/
method restAreas(aAreas) class IpUtilsObject

	local nI 		:= 0
	default aAreas 	:= {}

	for nI := 1 to Len(aAreas)
		RestArea(aAreas[nI])
	next nI

return


/*/{Protheus.doc} showHelp

Exibe um diálogo de help

@type method
@author Victor Hugo
@since 04/01/2014

@param cTitle, String, Título do Diálogo
@param cProblem, String, Mensagem de problema
@param cSolution, String, Mensagem de solução
/*/
method showHelp(cTitle, cProblem, cSolution) class IpUtilsObject

	local aProblem  := {}
	local aSolution := {}

	default cTitle    := "IpUtilsObject():showHelp()"
	default cProblem  := ""
	default cSolution := ""

	aProblem  := getHelpVetor(cProblem)
	aSolution := getHelpVetor(cSolution)

	ShowHelpDlg(cTitle, aProblem, Len(aProblem), aSolution, Len(aSolution))

return

/**
 * Retorna os vetores para o método showHelp()
 */
static function getHelpVetor(cText)

	local nLin    := 0
	local nMaxCol := 42
	local aVetor  := {}

	for nLin := 1 to MlCount(cText, nMaxCol)
		aAdd(aVetor, MemoLine(cText, nMaxCol, nLin))
	next nI

return aVetor


/*/{Protheus.doc} strAnyType

Converte qualquer valor para String. Ex.: oUtils:strAnyType(dData, "DDMMAA"), oUtils:strAnyType(nValor, "@E 999,999,999.99")

@type method
@author Victor Hugo
@since 04/01/2014

@param xValue, Indefinido, Valor a ser convertido
@param cPicture, String, Máscara para conversão

@return String Valor convertido em String
/*/
method strAnyType(xValue, cPicture) class IpUtilsObject

	local cString 	:= ""
	local cType   	:= ValType(xValue)
	default cPicture:= ""

	if (cType == "C")
		cString := xValue
	elseIf (cType == "N")
		cString := if(Empty(cPicture), AllTrim(Str(xValue)), AllTrim(Transform(xValue, cPicture)))
	elseIf (cType == "D")
		cString := strData(xValue, cPicture)
	elseIf (cType == "L")
		cString := if(xValue, "true", "false")
	elseIf (cType == "O")
		cString := "object"
	elseIf (cType == "A")
		cString := "array"
	endIf

return cString

/**
 * Conversão de datas
 */
static function strData(xValue, cPicture)

	local nScan		:= 0
	local cString	:= ""
	local aPics		:= {}
	local cDate  	:= DtoS(xValue)
	local cDay		:= Right(cDate, 2)
	local cMonth 	:= SubStr(cDate, 5, 2)
	local cYear4	:= Left(cDate, 4)
	local cYear2	:= Right(cYear4, 2)

	if Empty(cPicture)
		return DtoC(xValue)
	endIf

	cPicture := Upper(AllTrim(cPicture))

	aAdd(aPics, {"DDMMAA", cDay+cMonth+cYear2})
	aAdd(aPics, {"DDMMAAAA", cDay+cMonth+cYear4})
	aAdd(aPics, {"DD/MM/AA", cDay+"/"+cMonth+"/"+cYear2})
	aAdd(aPics, {"DD/MM/AAAA", cDay+"/"+cMonth+"/"+cYear4})

	aAdd(aPics, {"MMDDAA", cMonth+cDay+cYear2})
	aAdd(aPics, {"MMDDAAAA", cMonth+cDay+cYear4})
	aAdd(aPics, {"MM/DD/AA", cMonth+"/"+cDay+"/"+cYear2})
	aAdd(aPics, {"MM/DD/AAAA", cMonth+"/"+cDay+"/"+cYear4})

	aAdd(aPics, {"AAMMDD", cYear2+cMonth+cDay})
	aAdd(aPics, {"AAAAMMDD", cYear4+cMonth+cDay})
	aAdd(aPics, {"AA/MM/DD", cYear2+"/"+cMonth+"/"+cDay})
	aAdd(aPics, {"AA-MM-DD", cYear2+"-"+cMonth+"-"+cDay})
	aAdd(aPics, {"AAAA/MM/DD", cYear4+"/"+cMonth+"/"+cDay})
	aAdd(aPics, {"AAAA-MM-DD", cYear4+"-"+cMonth+"-"+cDay})

	nScan := aScan(aPics, {|x| x[1] == cPicture})

	if (nScan > 0)
		cString := aPics[nScan, 2]
	endIf

return cString


/*/{Protheus.doc} weekOfMonth

Retorna o número da semana do mês de determinada data

@type method
@author Victor Hugo
@since 19/02/2014

@param dDate, Data, Data a ser considerada

@return Numerico Numero da semana no mês da Data
/*/
method weekOfMonth(dDate) class IpUtilsObject

	local aMonth		:= {}
	local nScan			:= 0
	local nDayOfWeek	:= 0
	local nWeekOfMonth	:= 0
	local nWeek			:= 1
	local nSunday		:= 1
	local nMonday		:= 2
	local nSaturday		:= 7
	local nFirstMonthDay:= DoW(FirstDay(dDate))
	local dDay			:= FirstDay(dDate)
	local dLastDay		:= LastDay(dDate)

	if (nFirstMonthDay == nMonday .or. nFirstMonthDay == nSaturday .or. nFirstMonthDay == nSunday)
		nWeek := 0
	endIf

	while (dDay <= dLastDay)
		nDayOfWeek := DoW(dDay)
		if (nDayOfWeek == nMonday)
			nWeek++
		endIf
		aAdd(aMonth, {dDay,nWeek})
		dDay++
	endDo

	nScan 		 := aScan(aMonth, {|x| x[1] == dDate})
	nWeekOfMonth := aMonth[nScan,2]

	if (nWeekOfMonth == 0)
		nWeekOfMonth := 1
	endIf

return nWeekOfMonth


/*/{Protheus.doc} isWorkDay

Verifica se é dia útil em determinada data

@type method
@author Victor Hugo
@since 13/03/2014

@param dDate, Data, Data a ser analisada

@return Logico Indica se é dia útil
/*/
method isWorkDay(dDate) class IpUtilsObject

	local lNextDay     := .T.
	local dNextWorkDay := DataValida(dDate, lNextDay)

return (dNextWorkDay == dDate)