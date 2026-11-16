#include 'protheus.ch'
#include 'dhl.ch'

/*/{Protheus.doc} ValidExFat
Valida exclusão do faturamento.
@author Thiago Meschiatti
@since 07/06/2016
@version undefined

@type function
/*/
user function ValidExFat()
	local oContrAut := nil
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cDoc		:= ""
	local cSer		:= ""
	local cItem		:= ""
	local lRet		:= .t.
	
	oContrAut := DhlDisControl():newDhlDisControl(DHL_NFE_INVOICE_OUTFLOW)	
	retCliente(oContrAut)
	oSql:newTable("SD2", "D2_DOC, D2_SERIE, D2_ITEM, D2_CLIENTE, D2_LOJA, D2_NFORI, D2_SERIORI, D2_ITEMORI, D2_IDENTB6", retQrySD2())

	while oSql:notIsEof()
		
		cDoc 	:= oSql:getValue("D2_DOC")
		cSer 	:= oSql:getValue("D2_SERIE")
		cItem	:= oSql:getValue("D2_ITEM")
		cEntity	:= oSql:getValue("D2_CLIENTE")
		cUnit	:= oSql:getValue("D2_LOJA")
		oContrAut:validExclusion(cDoc, cSer, cItem, cEntity, cUnit)

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
static function retQrySD2()
	local cQuery := ""
	
	cQuery += "%SD2.XFILIAL% AND D2_DOC = '" + SF2->F2_DOC + "' AND D2_SERIE = '" + SF2->F2_SERIE + "' "
	cQuery += "AND D2_CLIENTE = '" + SF2->F2_CLIENTE + "' AND D2_LOJA = '" + SF2->F2_LOJA + "'
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


/*
** Consulta para NF de saída automática
*/
static function retQryAuto(oSql)
	local cQuery	:= ""
	local cDoc	 	:= oSql:getValue("D2_NFORI")
	local cSeries	:= oSql:getValue("D2_SERIORI")	
	local cItem		:= oSql:getValue("D2_ITEMORI")
	local cIdentB6	:= oSql:getValue("D2_IDENTB6")
	
	cQuery += " SELECT F2_DOC DOC, F2_SERIE SERIE, 				" + CRLF
	cQuery += " F2_EMISSAO EMISSAO , D2_ITEM ITEM         		" + CRLF
	cQuery += " FROM %SD2.SQLNAME%                              " + CRLF
	cQuery += " INNER JOIN %SF2.SQLNAME% ON                     " + CRLF
	cQuery += " 	 			F2_FILIAL 	= D2_FILIAL         " + CRLF
	cQuery += " 	AND		F2_DOC		= D2_DOC            	" + CRLF
	cQuery += " 	AND		F2_SERIE	= D2_SERIE            	" + CRLF
	cQuery += " 	AND		F2_CLIENTE	= D2_CLIENTE            " + CRLF
	cQuery += " 	AND		F2_LOJA		= D2_LOJA            	" + CRLF
	cQuery += "  	AND 	F2_ZZAUTO	= 'S'    				" + CRLF
	cQuery += " 	AND		%SF2.NOTDEL%                        " + CRLF
	cQuery += " INNER JOIN %SB6.SQLNAME% ON                     " + CRLF
    cQuery += "		B6_FILIAL       	= D2_FILIAL             " + CRLF
    cQuery += "		AND B6_DOC      	= D2_ZZNFAUT            " + CRLF
    cQuery += "		AND B6_SERIE    	= D2_ZZSEAUT            " + CRLF
    cQuery += "		AND B6_PRODUTO  	= D2_COD                " + CRLF
    cQuery += "		AND B6_IDENT  		= '"+cIdentB6+"'        " + CRLF
    cQuery += "		AND B6_TPCF 		= 'C'                   " + CRLF
    cQuery += "		AND B6_PODER3 		= 'R'                   " + CRLF
    cQuery += "		AND SB6.D_E_L_E_T_ 	= ' '                   " + CRLF
	cQuery += "  WHERE                                          " + CRLF
	cQuery += "  			D2_ZZNFAUT 	= '" + cDoc 	+ "'    " + CRLF
	cQuery += "  	AND 	D2_ZZSEAUT 	= '" + cSeries 	+ "'    " + CRLF
	cQuery += "  	AND 	D2_ZZITAUT 	= '" + cItem 	+ "'    " + CRLF
	cQuery += "  	AND 	%SD2.XFILIAL%                       " + CRLF
	cQuery += "  	AND		%SD2.NOTDEL%                        " + CRLF
	
return (cQuery)