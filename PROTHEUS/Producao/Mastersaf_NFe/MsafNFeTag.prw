#include "totvs.ch"

// INICIO CUSTOM.
#include "dhl.ch"  

#define ATTRIBUTE_NAME  1
#define ATTRIBUTE_VALUE 2 

/*/{Protheus.doc} MsafNFetag

Objeto que representa as tags do Invoice Issue
	
@author Winston Dellano de Castro
@since 24/10/2014
/*/
class MsafNFetag

	data cName
	data aNodes

	method newMsafNFetag() constructor

	method getTagName()
	method setTagName()
	method getAttributeValue()
	method setAttributeValue()
	method addElementNode()
	method getNodes()

endClass


/*/{Protheus.doc} newMsafNFetag

Tags do Invoice Issue
	
@author Winston Dellano de Castro
@since 24/10/2014

@param cName, String, Nome da tag
/*/

method newMsafNFetag(cName) class MsafNFetag

	default cName := ""

	::setTagName(cName)

	::aNodes := {}

return


/*/{Protheus.doc} getTagName

Coleta o nome da tag
	
@author Winston Dellano de Castro
@since 24/10/2014

@return String nome da tag
/*/
method getTagName() class MsafNFetag
return ::cName


/*/{Protheus.doc} setTagName

Define o nome da tag
	
@author Winston Dellano de Castro
@since 24/10/2014

@param var, String, Nome da tag
/*/
method setTagName(cName) class MsafNFetag
	::cName := cName
return


/*/{Protheus.doc} getAttributeValue

Coleta o valor de um atributo
	
@author Winston Dellano de Castro
@since 24/10/2014

@return Indefinido Valor do atributo
/*/
method getAttributeValue(cAttribute) class MsafNFetag

	local xValue    := nil
	local nPosition := getAttributePos(self,cAttribute)

	if (nPosition > 0)
		xValue := ::aNodes[nPosition][ATTRIBUTE_VALUE]
	endIf

return xValue


/*/{Protheus.doc} setAttributeValue

Define o valor de um atributo
	
@author Winston Dellano de Castro
@since 24/10/2014

@param cAttribute, String, Nome do atributo
@param xValue, Indefinido, Valor do atributo
/*/
method setAttributeValue(cAttribute,xValue,lAddNode,lFormatAccent) class MsafNFetag

	local oUtils    := IpUtilsObject():newIpUtilsObject()
	local nPosition := getAttributePos(self,cAttribute)
	
	default lAddNode := .f.
	default lFormatAccent := .t.
	
	if lAddNode
		nPosition := 0
	endif

	if (ValType(xValue) == "C")
		If lFormatAccent .and. FWUnitBusiness() # DHL_BUSINESSUNIT_AGL 
			xValue := oUtils:noAccent(xValue)
		EndIf
	endIf

	if (nPosition > 0)
		::aNodes[nPosition][ATTRIBUTE_VALUE] := xValue
	else
		aAdd(::aNodes,{cAttribute,xValue})
	endIf

return


/*/{Protheus.doc} addElementNode

Define o Tag filha
	
@author Winston Dellano de Castro
@since 28/10/2014

@param oElement, Object, Objeto tag a ser incluído como tag filha
/*/
method addElementNode(oElement) class MsafNFetag
	aAdd(::aNodes,{oElement,nil})
return


/*/{Protheus.doc} getNodes

Coleta o objeto que representa as tags do objeto
	
@author Winston Dellano de Castro
@since 29/10/2014

@return Object objeto que representa as tags da Nfe
/*/
method getNodes() class MsafNFetag
return ::aNodes


/**
* Pesquisa a posição de um atributo no array de nós
*/
static function getAttributePos(oResource,cAttribute)
return aScan(oResource:aNodes, { |x| Lower(AllTrim(x[1])) == Lower(AllTrim(cAttribute)) })
