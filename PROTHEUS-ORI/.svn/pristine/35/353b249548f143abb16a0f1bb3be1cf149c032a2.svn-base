#include 'totvs.ch'
#include 'safx2017.ch'
#include 'safx.ch'
 

/*/{Protheus.doc} DHLSafx2017

Responsável pelas regras e montagem das informações para a exportaçãÁ„o
	
@author Daniel Braga
@since 30/10/2014

/*/
user function _Saf2017;return

class DHLSafx2017 from DHLSafx

	method newDHLSafx2017() constructor
	method addLine()
	method notFieldRequired()
	
endclass

//-----------------------------------------------------------------
method newDHLSafx2017() class DHLSafx2017

return

/*/{Protheus.doc} addLine

Cria a lina á ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine() class DHLSafx2017
   
   	local oDhlLib := DhlLibrary():newDhlLibrary()
   
	::addField(DATA_X2017		, oDhlLib:getLGDate(::getFieldValue("AH_USERLGI"), .T.))
	::addField(COD_UND_PADRAO	, ::getFieldValue("AH_UNIMED"))
	::addField(DESCRICAO		, ::getFieldValue("AH_DESCPO"))
	
	::notFieldRequired()

return

/*/{Protheus.doc} notFieldRequired

Campos que n„o precisa passar valor
	
@author Daniel Braga
@since 13/11/2014

/*/
method notFieldRequired()  class DHLSafx2017

	::addField(IND_UNID_FRAC, '')
	
return 