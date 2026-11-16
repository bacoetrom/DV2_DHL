#include 'protheus.ch'
#include 'dhl.ch'

/*/{Protheus.doc} ValidExc
Validar Exclusão de Documentod e Entrada para NF Automática
@author Thiago Meschiatti
@since 30/05/2016
@version 1.0

/*/
user function ValidExc()
	local oContrAut := nil
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cDoc		:= ""
	local cSer		:= ""
	local cItem		:= ""
	local lRet		:= .t.
	
	oContrAut := DhlDisControl():newDhlDisControl(DHL_NFE_INVOICE_INFLOW)
	retCliente(oContrAut)	
	oSql:newTable("SD1", "D1_DOC, D1_SERIE, D1_ITEM, D1_FORNECE, D1_LOJA", retQrySD1())
	
	while oSql:notIsEof()
		cDoc 	:= oSql:getValue("D1_DOC")
		cSer 	:= oSql:getValue("D1_SERIE")
		cItem	:= oSql:getValue("D1_ITEM")
		oContrAut:validExclusion(cDoc, cSer, cItem, oContrAut:getEntityAuto(), oContrAut:getUnitAuto())
		
		if oContrAut:hasError()
			lRet := .f.
			oContrAut:showError()
			exit
		endif
		
		oSql:skip()
	end
	oSql:close()
return (lRet)


/*
** Where para tabela SD1
*/
static function retQrySD1()
	local cQuery := ""
	
	cQuery += "%SD1.XFILIAL% AND D1_DOC = '" + SF1->F1_DOC + "' AND D1_SERIE = '" + SF1->F1_SERIE + "' "
	cQuery += "AND D1_FORNECE = '" + SF1->F1_FORNECE + "' AND D1_LOJA = '" + SF1->F1_LOJA + "'
return (cQuery)


/*
** Retorna cliente DHL
*/
static function retCliente(oContrAut)
	local oSql	 := IpSqlObject():newIpSqlObject()
	local cQuery := ""
	
	cQuery += "%SA1.XFILIAL% AND A1_CGC = '"+SM0->M0_CGC+"' "
	
	oSql:newTable("SA1", "A1_COD COD, A1_LOJA LOJA" , cQuery)
	
	oContrAut:setEntityAuto(oSql:getValue("COD"))
	oContrAut:setUnitAuto(oSql:getValue("LOJA"))
	
	oSql:close()
return