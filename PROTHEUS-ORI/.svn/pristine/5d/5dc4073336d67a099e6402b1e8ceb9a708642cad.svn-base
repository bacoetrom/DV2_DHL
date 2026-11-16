#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"

#define ATTRIBUTE_NAME  1
#define ATTRIBUTE_VALUE 2 

/*/{Protheus.doc} MsafRSymbFile

Monta o arquivo Symbolic Return - IP050
	
@author Augusto Krejci Bem-Haja
@since 18/05/2017
/*/
class MsafRSymbFile
	
	data cFile
	data aTags
	
	method newMsafRSymbFile() constructor
	
	method addTag()
	method createTxt()
	
endClass


/*/{Protheus.doc} newMsafRSymbFile

Objeto que representa o arquivo do Symbolic Return - IP050
	
@author Augusto Krejci Bem-Haja
@since 18/05/2017

@param oNFeTags, Object, Objeto do tipo MsafRSymbFile
/*/
method newMsafRSymbFile(oNFeTags) class MsafRSymbFile
		
	::cFile := ""
	::aTags := {}
	
	if (ValType(oNFeTags) == "O")
		::addTag(oNFeTags)
	endIf

return


/*/{Protheus.doc} addTag

Adiciona um objeto tag
	
@author Augusto Krejci Bem-Haja
@since 18/05/2017

@param oTags, Object, Objeto do tipo MsafNFeTag
/*/
method addTag(oTags) class MsafRSymbFile 
	aAdd(::aTags,oTags)
return


/*/{Protheus.doc} createTxt

Cria um arquivo txt com as tags disponNodebilizadas
	
@author Augusto Krejci Bem-Haja
@since 18/05/2017
/*/
method createTxt(cType,cInvoice,cSeries) class MsafRSymbFile

	local lRet	  := .T.
	local nNode := 1
	
	for nNode := 1 to Len(::aTags)
		::cFile += writeTag(::aTags[nNode])
	next nNode
	
	lRet := createFile(::cFile, cType, cInvoice, cSeries)
	
return lRet


/**
* Grava os campos do arquivo texto
**/
static function writeTag(oTags)

	local oUtils	:= IpUtilsObject():newIpUtilsObject()
	local aValues   := oTags:getNodes()
	local xValue    := nil 
	local nNode     := 1
	local cTag      := ""
	local cNameTag  := oTags:getTagName()
	local lWithOpen := withOpen(cNameTag)
	local lWithEnd  := withEnd(cNameTag)
	local lWithCte	:= withCte(cNameTag)
	
	if 	lWithCte
		for nNode := 1 to Len(aValues)
			xValue := aValues[nNode][1]
			if (ValType(xValue) == "O")
				cTag += Alltrim(writeTag(xValue))
			else
				xValue := aValues[nNode][ATTRIBUTE_VALUE]
				if (ValType(xValue) == "N" .and. xValue == 0)
					cTag += DHL_NFE_FORMAT_ZERO+';'+CRLF
				else
					cTag += Alltrim(oUtils:strAnyType(aValues[nNode][ATTRIBUTE_VALUE]))+';'+CRLF
				endIf	
			endIf
		next nNode
	else
		if lWithOpen
			cTag += "--"+cNameTag+"_ini--;"+CRLF
		endif
		
		for nNode := 1 to Len(aValues)
			xValue := aValues[nNode][1]
			if (ValType(xValue) == "O")
				cTag += Alltrim(writeTag(xValue))
			else
				xValue := aValues[nNode][ATTRIBUTE_VALUE]
				if (ValType(xValue) == "N" .and. xValue == 0)
					cTag += DHL_NFE_FORMAT_ZERO+';'+CRLF
				else
					cTag += Alltrim(oUtils:strAnyType(aValues[nNode][ATTRIBUTE_VALUE]))+';'+CRLF
				endIf	
			endIf
		next nNode
		
		if lWithEnd
			cTag += "--"+cNameTag+"_fim--;"+CRLF
		endif
	endif
	
return cTag


/**
* Verifica se deve gravar "_ini" na tag
**/
static function withOpen(cNameTag)

	local lReturn := .T.

	if Empty(cNameTag) .or. Alltrim(cNameTag) == "arquivo"
		lReturn := .F.
	else
		lReturn := .T.
	endif
	
return lReturn


/**
* Verifica se deve gravar "_fim" na tag
**/
static function withEnd(cNameTag)

	local lReturn := .T.

	if Empty(cNameTag)
		lReturn := .F.
	else
		lReturn := .T.
	endif
	
return lReturn


/**
* Verifica se deve gravar "_fim" na tag
**/
static function withCte(cNameTag)

	local lReturn := .T.

	if (cNameTag == "inf_cte") .or. (cNameTag == "inf_sales") 
		lReturn := .T.
	else
		lReturn := .F.
	endif
	
return lReturn


/**
* Função responsável pela criação do arquivo final	
**/
static function createFile(cFile,cType,cInvoice,cSeries)

	local cPrefix	:= ""
	local cCnpj		:= SM0->M0_CGC
	local oLog		:= DHLLogManager():newDHLLogManager()
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local oFile		:= IpFileObject():newIpFileObject("")
	local oUtils	:= IpUtilsObject():newIpUtilsObject()
	local cDir		:= AllTrim(oSqlUtil:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND %SZ1.NOTDEL% AND SZ1.Z1_CODIGO = '" + APP_SAP + "'"))
	local cDate		:= DtoS(dDataBase)
	local cTime		:= StrTran(Time(),":","")
	local cFileName	:= ""
	local lRet		:= .T.
	
	cPrefix	:= "IP050"
	
	cFileName	:= cPrefix + "_" + Alltrim(cCnpj) + "_" + cDate + "_" +cTime + "_"+Alltrim(cInvoice)+"_"+Alltrim(cSeries)+".txt"
	
	oFile:setFile(oUtils:concatDirectory(cDir, cFileName))
	
	lRet	:= oFile:writeLine(cFile)
	
	if !(lRet)
		oLog:start(APP_SAP, DHL_EXPORTACAO,cDir + cFileName )
		oLog:fail("Criação do Arquivo", "Erro ao criar arquivo")
	endIf
	
return lRet