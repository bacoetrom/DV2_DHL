#include 'totvs.ch'
#include 'safx2006.ch'
#include 'safx.ch'

/*/{Protheus.doc} DHLSafx2006

Responsável pelas regras e montagem das informações para a exportação
	
@author Daniel Braga
@since 30/10/2014

/*/
user function _Saf2006;return

class DHLSafx2006 from DHLSafx

	method newDHLSafx2006() constructor
	method addLine(dDtUser)
	method notFieldRequired()

endclass

//-----------------------------------------------------------------
method newDHLSafx2006() class DHLSafx2006

return

/*/{Protheus.doc} addLine

Cria a lina á ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine(dDtUser) class DHLSafx2006
	
	local oDhlLib := DhlLibrary():newDhlLibrary()	
	
	::addField(DATA_X2006			, if(empty(dDtUser),oDhlLib:getLGDate(::getFieldValue("CD1_USERGI"), .T.), dDtUser))
	::addField(COD_NATUREZA_OP		, ::getFieldValue("CD1_CODNAT") )
	::addField(DESCRICAO			, ::getFieldValue("CD1_DESCR"))
	
	::notFieldRequired()

return


/*/{Protheus.doc} notFieldRequired

Campos que n„o precisa passar valor
	
@author Daniel Braga
@since 13/11/2014

/*/
method notFieldRequired() class DHLSafx2006

	::addField(ENT_SAI				, '')
	::addField(IND_FIS_JUR			, '')
	::addField(COD_NATUREZA_OP_SPED , '')
	
return
