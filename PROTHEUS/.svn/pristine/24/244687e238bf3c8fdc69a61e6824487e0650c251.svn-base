#include 'totvs.ch'
#include 'safx2009.ch'
#include 'safx.ch'

/*/{Protheus.doc} DHLSafx2009

Responsável pelas regras e montagem das informações para a exportação
	
@author Daniel Braga
@since 30/10/2014

/*/
user function _Saf2009;return

class DHLSafx2009 from DHLSafx

	method newDHLSafx2009() constructor
	method validateExport()
	method addLine() 
	

endclass

//-----------------------------------------------------------------
method newDHLSafx2009() class DHLSafx2009

return


/*/{Protheus.doc} addLine

Cria a lina á ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine() class DHLSafx2009 
	
	local oDhlLib := DHLLibrary():newDHLLibrary()	

	::addField(COD_OBSERVACAO  , ::getFieldValue("ZZ9_CODIGO"))
	::addField(DATA_X2009      , oDhlLib:getLGDate(::getFieldValue("ZZ9_USERGI"), .T.))
	::addField(DESCRICAO       , ::getFieldValue("ZZ9_DESCR"))
	::addField(TIPO_OBSERVACAO , ::getFieldValue("ZZ9_TIPO"))

return 


/*/{Protheus.doc} validateExport

(Descrição da Função, Classe ou Método)
	
@author Daniel Braga
@since 30/10/2014

@return logico validação da regra
/*/
method validateExport() class DHLSafx2009
	
	local lExport  := .T.
	local lInJob   := Type("oMainWnd") != "O"
	local oDHLLib  :=  DHLLibrary():newDHLLibrary()
	local dDtLga   := oDHLLib:getLGDate(  ::getFieldValue("ZZ9_USERLGA") )      
	
	if lInJob
		lExport := Empty(::getFieldValue("ZZ9_ZZMSDW") )  .or. ::getFieldValue("ZZ9_ZZMSDW") < dDtLga
	endIf
	
return lExport
