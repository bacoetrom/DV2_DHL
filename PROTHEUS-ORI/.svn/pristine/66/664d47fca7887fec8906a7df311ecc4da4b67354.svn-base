#include 'totvs.ch'
#include 'safx128.ch'
#include 'safx.ch'

/*/{Protheus.doc} DHLSafx128

Responsável pelas regras e montagem das informações para a exportação
	
@author Daniel Braga
@since 30/10/2014

/*/
user function _Saf128;return

class DHLSafx128 from DHLSafx

	method newDHLSafx128() constructor
	method validateExport()
	method addLine() 
	

endclass

//-----------------------------------------------------------------
method newDHLSafx128() class DHLSafx128

return

/*/{Protheus.doc} addLine

Cria a lina á ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine() class DHLSafx128 


	::addField(IND_PRODUTO		, ::getProdType(::getFieldValue("B1_TIPO")))
	::addField(COD_PRODUTO		, ::getFieldValue("B1_COD"))
	::addField(COD_MEDIDA_ORIG	, ::getFieldValue("B1_UM"))
	::addField(COD_MEDIDA_DEST	, ::getFieldValue("B1_SEGUM")) 
	
	::addField(VLR_FATOR_CONV	, ::getFieldValue("B1_CONV"))

return                          


/*/{Protheus.doc} validateExport

(Descrição da Função, Classe ou Método)
	
@author Daniel Braga
@since 30/10/2014


@return logico validação da regra
/*/

method validateExport() class DHLSafx128
	
	local lExport  := .T.
	local lInJob   := Type("oMainWnd") != "O"
	local oDHLLib  :=  DHLLibrary():newDHLLibrary()
	local dDtLga   := oDHLLib:getLGDate(  ::getFieldValue("B1_USERLGA") )
	
	if lInJob
		lExport := Empty(::getFieldValue("B1_ZZMSDW2") )  .or. ::getFieldValue("B1_ZZMSDW2") < dDtLga
	endIf
	
	if lExport
		lExport := !Empty(::getFieldValue("B1_SEGUM")) .and. ::getFieldValue("B1_CONV") > 0 
	endIf
	
return lExport