#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} User Function Di2VldFatura
	Valida a geração do documento de saída, que pode estar referenciando um ou mais documentos de saída automáticos, caso tenha.	
	@type  Function
	@author Diogo Mesquita Gamba
	@since 27/02/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function Di2VlGerNFS(nRec)

	local oSql		:= IpSqlObject():newIpSqlObject()
	local lValid	:= GetNewPar("ZZ_NFEAUTO", .t.)
	local lOk		:= .t.
	local cDoc      := ""
	local cSerie    := ""
	local cItem     := ""
	local cIdentB6	:= ""
	
	if lValid
		oSql:newAlias(retQrySC6(nRec))
		
		while oSql:notIsEof()
			cDoc      := oSql:getValue("C6_NFORI")
			cSerie    := oSql:getValue("C6_SERIORI")
			cItem     := oSql:getValue("C6_ITEMORI")
			cIdentB6  := oSql:getValue("C6_IDENTB6")
			
			if !NFSAutoAutorizada(cDoc, cSerie, cItem, cIdentB6)
				lOk := .f.
				exit
			endif
			oSql:skip()
		end
		
		oSql:close()
	endif
	
Return (lOk)

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
** Valida se o documento de saída automático já foi autorizado pelo Sefaz
*/
static function NFSAutoAutorizada(cDoc, cSerie, cItem, cIdentB6)

	local oSql := IpSqlObject():newIpSqlObject()
	local cMsg := ""
	local lRet := .t.
	
	oSql:newAlias(retQrySF2(cDoc, cSerie, cItem, cIdentB6))
	
	if oSql:hasRecords()
		if oSql:getValue("FIMP") <> 'S'
			lRet := .f.
			cMsg := "Nota Fiscal não pode ser gerada. " + CRLF +;
					"Nota Fiscal abaixo de Débito ICMS não foi autorizada pela Sefaz!" + CRLF +;
					" Doc.: " + alltrim(oSql:getValue("DOC"))+; 
					" Série:" + alltrim(oSql:getValue("SERIE")) +; 
					" Data: "  + dtoc(stod(oSql:getValue("EMISSAO"))) + ". " + CRLF +;
					"Processo de faturamento será abortado. Emissão será possível apenas quando a NF mencionada for regularizada!"
			Aviso("Atenção",cMsg,{"OK"},3)
		endif
	endif
	
	oSql:close()
	
return lRet

/*
** Where para as tabelas SF2, SD2 e SB6
*/
static function retQrySF2(cDoc, cSerie, cItem, cIdentB6)
	
	local cQuery := ""
	
	cQuery += " SELECT F2_DOC DOC, F2_SERIE SERIE, 			" + CRLF
	cQuery += " F2_EMISSAO EMISSAO ,F2_FIMP FIMP         	" + CRLF
	cQuery += " FROM %SD2.SQLNAME%                          " + CRLF
	cQuery += " INNER JOIN %SF2.SQLNAME% ON                 " + CRLF
	cQuery += " 	F2_FILIAL 		= D2_FILIAL    			" + CRLF
	cQuery += " 	AND	F2_DOC		= D2_DOC            	" + CRLF
	cQuery += " 	AND	F2_SERIE	= D2_SERIE            	" + CRLF
	cQuery += " 	AND	F2_CLIENTE	= D2_CLIENTE            " + CRLF
	cQuery += " 	AND	F2_LOJA		= D2_LOJA            	" + CRLF
	cQuery += " 	AND	%SF2.NOTDEL%                        " + CRLF
	cQuery += " INNER JOIN %SB6.SQLNAME% ON                 " + CRLF
    cQuery += "		B6_FILIAL       = D2_FILIAL 	        " + CRLF
    cQuery += "		AND B6_DOC      = D2_ZZNFAUT    	    " + CRLF
    cQuery += "		AND B6_SERIE    = D2_ZZSEAUT        	" + CRLF
    cQuery += "		AND B6_PRODUTO  = D2_COD            	" + CRLF
    cQuery += "		AND B6_IDENT  	= '"+cIdentB6+"'   		" + CRLF
    cQuery += "		AND B6_TPCF 	= 'C'              		" + CRLF
    cQuery += "		AND B6_PODER3 	= 'R'              		" + CRLF
    cQuery += "		AND %SB6.NOTDEL%                   		" + CRLF
	cQuery += "  WHERE                                      " + CRLF
	cQuery += "  	D2_ZZNFAUT 		= '" + cDoc 	+ "'    " + CRLF
	cQuery += "  	AND D2_ZZSEAUT 	= '" + cSerie 	+ "'    " + CRLF
	cQuery += "  	AND D2_ZZITAUT 	= '" + cItem 	+ "'    " + CRLF
	cQuery += "  	AND %SD2.XFILIAL%                       " + CRLF
	cQuery += "  	AND	%SD2.NOTDEL%                        " + CRLF
              
return (cQuery)
