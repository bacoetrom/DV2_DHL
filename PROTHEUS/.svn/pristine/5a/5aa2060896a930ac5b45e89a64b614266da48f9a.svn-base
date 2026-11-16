#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} ValidFat
Efetua validação do faturamento.

@author Thiago Meschiatti
@since 02/06/2016
@version undefined

@type function
/*/
user function ValidFat(nRec)
	local oSql			:= IpSqlObject():newIpSqlObject()
	local oControlAut	:= DhlDisControl():newDhlDisControl()
	local lValid		:= GetNewPar("ZZ_NFEAUTO", .t.)
	local lOk			:= .t.
	local cDoc          := ""
	local cSeries       := ""
	local cItem         := ""
	local cIdentB6		:= ""
	local cEntity       := ""
	local cUnit         := ""
	
	if lValid
		retCliente(oControlAut)
		oSql:newAlias(retQrySC6(nRec))
		
		while oSql:notIsEof()
			cDoc          := oSql:getValue("C6_NFORI")
			cSeries       := oSql:getValue("C6_SERIORI")
			cItem         := oSql:getValue("C6_ITEMORI")
			cIdentB6	  := oSql:getValue("C6_IDENTB6")
			
			oControlAut:validAutorization(cDoc, cSeries, cItem, cIdentB6)
			
			if oControlAut:hasError()
				lOk := .f.
				oControlAut:showError()
				exit
			endif
			oSql:skip()
		end
		
		oSql:close()
	endif
	
return (lOk)


/*
** Query para SC6
*/
static function retQrySC6(nRec)
	local cQuery := ""
	
	cQuery += " SELECT C6_NFORI, C6_SERIORI, C6_ITEMORI, C6_IDENTB6		" + CRLF
	cQuery += " FROM %SC5.SQLNAME%                              		" + CRLF
	cQuery += " INNER JOIN %SC6.SQLNAME% ON                     		" + CRLF
	cQuery += " 	 		C6_FILIAL 	= C5_FILIAL         			" + CRLF
	cQuery += " 	AND		C6_NUM		= C5_NUM	            		" + CRLF
	cQuery += " 	AND		%SC6.NOTDEL%                        		" + CRLF
	cQuery += "  WHERE                                          		" + CRLF
	cQuery += "  			SC5.R_E_C_N_O_ 	= " + cValtoChar(nRec) 	+ " " + CRLF
	cQuery += "  	AND 	%SC5.XFILIAL%                       		" + CRLF
	cQuery += "  	AND		%SC5.NOTDEL%                        		" + CRLF
	
return (cQuery)


/*
** Retornar cliente DHL
*/
static function retCliente(oControlAut)
	local oSql	 := IpSqlObject():newIpSqlObject()
	local cQuery := ""
	
	cQuery += "%SA1.XFILIAL% AND A1_CGC = '"+SM0->M0_CGC+"' "
	
	oSql:newTable("SA1", "A1_COD COD, A1_LOJA LOJA" , cQuery)
	
	oControlAut:setEntityAuto(oSql:getValue("COD"))
	oControlAut:setUnitAuto(oSql:getValue("LOJA"))
	
	oSql:close()
return