#include 'totvs.ch'
#include 'safx2007.ch'
#include 'safx.ch'


/*/{Protheus.doc} DHLSafx2007

Responsável pelas regras e montagem das informações para a exportação
	
@author Daniel Braga
@since 30/10/2014

/*/
user function _Saf2007;return

class DHLSafx2007 from DHLSafx

	method newDHLSafx2007() constructor
	method addLine()
	method notFieldRequired()
	
endclass

//-----------------------------------------------------------------
method newDHLSafx2007() class DHLSafx2007

return

/*/{Protheus.doc} addLine

Cria a lina á ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine() class DHLSafx2007

	local oDhlLib := DhlLibrary():newDhlLibrary()	

	::addField(DATA_X2007			, oDhlLib:getLGDate(::getFieldValue("AH_USERLGI"), .T.))
	::addField(COD_MEDIDA			, ::getFieldValue("AH_UNIMED"))
	::addField(DESCRICAO			, ::getFieldValue("AH_DESCPO"))
	
	::notFieldRequired()
	
return

/*/{Protheus.doc} notFieldRequired

Campos que n„o precisa passar valor
	
@author Daniel Braga
@since 13/11/2014

/*/
method notFieldRequired() class DHLSafx2007
	
	::addField(IND_UNID_FRAC, '')
		
return