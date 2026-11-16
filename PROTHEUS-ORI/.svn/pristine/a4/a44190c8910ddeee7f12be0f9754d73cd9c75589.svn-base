#include 'totvs.ch'
#include 'safx2081.ch'
#include 'safx.ch'

/*/{Protheus.doc} DHLSafx2081

Responsavel pelas regras e montagem das informacoes para a exportacao
	
@author Daniel Braga
@since 30/10/2014

/*/
user function _Saf2081;return

class DHLSafx2081 from DHLSafx

	method newDHLSafx2081() constructor
	method getSql()
	method addLine()
	method notFieldRequired()
	method existSX5(cCF)

endClass

//-----------------------------------------------------------------
method newDHLSafx2081() class DHLSafx2081

return

/*/{Protheus.doc} addLine

Cria a lina ‡ ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine(cType)   class DHLSafx2081

	local oDhlLib 	:= DhlLibrary():newDhlLibrary()
	local cCfop		:= ""
	
	default cType := ""	
	
	if empty(cType)
		cCfop := ::getFieldValue("CHAVE")
	else
		cCfop := cType + right(::getFieldValue("CHAVE"),tamsx3("X5_CHAVE")[1]-1)
	endif
		
	
	::addField(DATA_X2081  			, oDhlLib:getLGDate(nil, .T.))
	::addField(COD_CFO				, cCfop)
	::addField(COD_NATUREZA_OP		, ::getFieldValue("F4_NATOPER"))
	
	::notFieldRequired()	
	
return

/*/{Protheus.doc} getSql

Instrucaoo SQL para exportacaoo
	
@author Daniel Braga
@since 30/10/2014

@return string instrucao sql
/*/
method getSql() class DHLSafx2081

	local cQuery := "" 
	
	cQuery := " select x5_chave chave, f4_natoper " 
	cQuery += " from "+retSqlName("SX5")+" sx5 "
	cQuery += " 	inner join "+retSqlName("SF4")+" sf4 on "
	cQuery += "			f4_filial = x5_filial and f4_cf = x5_chave and sf4.d_e_l_e_t_ = ' '  "
	cQuery += " where x5_filial = '"+xFilial("SX5")+"' and x5_tabela = '13' and sx5.d_e_l_e_t_ = ' ' "

return Upper(cQuery)


/*/{Protheus.doc} notFieldRequired

Campos que não precisa passar valor
	
@author Daniel Braga
@since 13/11/2014

/*/
method notFieldRequired()  class DHLSafx2081

	::addField(IND_APLICACAO	, '' )
	::addField(COMPL_CFOP	, '' )
	::addField(DSC_OPERACAO	, '' )
return 


/*/{Protheus.doc} getSql

Verifica existência no SX5
	
@author Daniel Braga
@since 30/10/2014

@return string instrucao sql
/*/
method existSX5(cCF) class DHLSafx2081
	local oSql	 := IpSqlObject():newIpSqlObject()
	local cQuery := "" 
	local lRet	 := .f.
	
	cQuery := " select x5_chave chave " 
	cQuery += " from "+retSqlName("SX5")+" sx5 "
	cQuery += " where x5_filial = '"+xFilial("SX5")+"' and x5_tabela = '13' and x5_chave = '"+cCF+"' and sx5.d_e_l_e_t_ = ' ' "
	
	oSql:newAlias(Upper(cQuery))
	
	if oSql:hasRecords()
		lRet := .t.
	endif
	
	oSql:close()

return (lRet)