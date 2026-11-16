#include 'totvs.ch'
#include 'safx130.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} DHLSafx130Dis

Respons‡vel pelas regras e montagem das informacoees para a exportacao
	
@author Thiago Meschiatti
@since 30/10/2014

/*/

user function _Saf130Dis;return 

class DHLSafx130Dis from DHLSafx

	method newDHLSafx130Dis() constructor
	method getSql()
	method addLine()
	method getModeloDoc()
	method getSituacaoNota()
	method notFieldRequired()

endclass

//-----------------------------------------------------------------
method newDHLSafx130Dis() class DHLSafx130Dis

return

/*/{Protheus.doc} getSql

Instrucao SQL para exportacao
	
@author Daniel Braga
@since 30/10/2014

@return string instrucao sql
/*/
method getSql(dDtFrom , dDtUntil) class DHLSafx130Dis

	local cQuery := ""
	
	cQuery+= "select * from "+retSqlName("SF3")+" where " 
	cQuery+= "f3_filial = '"+xfilial("SF3")+"' and "
	cQuery+= "f3_emissao between '"+dtos(dDtFrom)+"' and  '"+dtos(dDtUntil)+"' and "
	cQuery+= "f3_especie <> '" + DHL_ESPECIE_ESPELHO + "' and "
	cQuery+= "(f3_observ = 'DENEGADA' or f3_observ ='"+getMV("ZZ_TXTINUT")+"') and d_e_l_e_t_ = ' ' " 

return Upper(cQuery)


/*/{Protheus.doc} addLine

Cria a lina ‡ ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/

method addLine() class DHLSafx130Dis

	::addField(COD_EMPRESA		, alltrim(GetNewPar("ZZ_IDEMPDW", "SOL")))
	::addField(COD_ESTAB		, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())))
	::addField(MOVTO_E_S		, Iif(val(::getFieldValue("F3_CFO")) < 5000 , iif( alltrim(::getFieldValue("F3_FORMUL")) $ 'S', SAFX_DOC_ENTRADA_FORM_PROP, SAFX_DOCUMENTO_ENTRADA),;
								  SAFX_DOCUMENTO_SAIDA))
	::addField(NUM_DOCFIS_INI	, ::getFieldValue("F3_NFISCAL"))
	::addField(NUM_DOCFIS_FIN	, ::getFieldValue("F3_NFISCAL"))
	::addField(SERIE_DOCFIS		, ::getFieldValue("F3_SERIE"))
	::addField(SUB_SERIE_DOCFIS	, ' ')
	::addField(DATA_REF			, ::getFieldValue("F3_EMISSAO"))
	::addField(COD_MODELO		, ::getModeloDoc())
	::addField(IND_SITUACAO		, ::getSituacaoNota())
	::addField(NUM_AUTENTIC_NFE	, ::getFieldValue("F3_CHVNFE"))

	::notFieldRequired()

return 


/*/{Protheus.doc} getModeloDoc

Regra do campo COD_MODELO
	
@author Daniel Braga
@since 31/10/2014

/*/
method getModeloDoc() class DHLSafx130Dis

	local cEspecie := allTrim(::getFieldValue("F3_ESPECIE"))

	if (cEspecie == "SPED")
		return "55"
	elseIf (cEspecie == "CTE")
		return "57"
	endIf
return 


/*/{Protheus.doc} getSituacaoNota

Regra do campo IND_SITUACAO
	
@author Daniel Braga
@since 31/10/2014

/*/
method getSituacaoNota() class DHLSafx130Dis

	local cSituacao :=  ::getFieldValue("F3_OBSERV")
	
	if allTrim(cSituacao) $ "DENEGADA"
		return "1"
	elseIf alltrim(upper(cSituacao)) $ alltrim(upper(::getFieldValue("ZZ_TXTINUT")))
		return "2"
	endIf

return ""

/*/{Protheus.doc} notFieldRequired

Campos que não precisa passar valor
	
@author Daniel Braga
@since 13/11/2014

/*/
method notFieldRequired()  class DHLSafx130Dis

	::addField(INSC_ESTADUAL	,'')
	
return 
