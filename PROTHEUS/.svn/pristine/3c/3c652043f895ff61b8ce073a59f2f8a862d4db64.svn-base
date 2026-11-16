#include "totvs.ch"


/*/{Protheus.doc} IpKeyValuesObject

Lista de Valores com Chaves associadas

@type class	
@author Victor Hugo
@since 21/11/2014
/*/
class IpKeyValuesObject from IpAdvplObject
	
	data aValues
	data xDefaultValue
	
	method newIpKeyValuesObject() constructor
	
	method put()
	method get()
	method clear() 
	method setDefaultValue()
	
endClass


/*/{Protheus.doc} newIpKeyValuesObject

Construtor
	
@type method
@author Victor Hugo
@since 21/11/2014
/*/
method newIpKeyValuesObject() class IpKeyValuesObject
	
	::newIpAdvplObject()
	
	::aValues 		:= {}
	::xDefaultValue := nil
	
return self


/*/{Protheus.doc} put

Armazena um valor

@type method	
@author Victor Hugo
@since 21/11/2014

@param cKey, String, Chave do valor
@param xValue, Indefinido, Valor a ser armazenado
/*/
method put(cKey, xValue) class IpKeyValuesObject
	
	local nScan := scanKey(self, cKey)
	
	if (nScan == 0)
		aAdd(::aValues, {cKey, xValue})
	else
		::aValues[nScan,2] := xValue
	endIf
	
return


/*/{Protheus.doc} get

Coleta um valor
	
@type method
@author Victor Hugo
@since 21/11/2014

@param cKey, String, Chave do valor

@return Indefinido Valor a ser armazenado referente a chave
/*/
method get(cKey) class IpKeyValuesObject
	
	local xValue := ::xDefaultValue
	local nScan  := scanKey(self, cKey)
	
	if (nScan > 0)
		xValue := ::aValues[nScan,2]
	endIf
	
return xValue


/**
 * Busca a posição de uma chave
 */
static function scanKey(oSelf, cKey)	
return aScan(oSelf:aValues, {|x| Lower(AllTrim(x[1])) == Lower(AllTrim(cKey)) })


/*/{Protheus.doc} clear

Limpa a lista de valores

@type method	
@author Victor Hugo
@since 21/11/2014
/*/
method clear() class IpKeyValuesObject
	
	::aValues := {}
	
return


/*/{Protheus.doc} setDefaultValue

Define um Valor Padrão para a Lista de Valores

@type method	
@author Victor Hugo
@since 03/02/2015
/*/
method setDefaultValue(xValue) class IpKeyValuesObject
	
	::xDefaultValue := xValue
	
return