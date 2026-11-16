#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx08.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} 08AG2SAFX

Respons‡vel por gerar o arquivo SAFX08
	
@author Thiago Meschiatti
@since 18/07/2017

/*/
user function 08AG2SAFX(oSqlHeader,oFile,oFlSfx116,aDocsRef,oDHLSafx07)

	local oFileSfx08 		:= nil
	local oIpSqlSfx08 		:= IpSqlObject():newIpSqlObject()
	local oDHLSafx08		:= DHLSafx08Ag2():newDHLSafx08Ag2()
	local oSqlRef			:= nil
	local oSqlCob			:= nil
	local cError			:= ""
	local cCusSupDv			:= ""
	local cBranch			:= ""
	local cDocOri			:= ""
	local cSerOri			:= ""
	local cItenOri			:= ""
	local aFields			:= {}
	local cPrefix			:= ""
	local cId				:= ""
	local lCobert			:= .f.
	local cOrigem			:= ""
	local nX			:= 0
	Local aItDel			:= {}
	local npos			:= 0
	
	oFileSfx08	:= oFile
	
	oDHLSafx08:initialize(SAFX08_POSICOES,oSqlHeader,oIpSqlSfx08)
	
	oDHLSafx08:setItem("01")
	
	while (cSFT_)->(!eof())
	
		if !empty((cSF3_)->f3_dtcanc)
			// para previnir entrar dois itens. caso uma seja cancelada nao filtra f1/d1 f2/d2 com d_e_l_e_t_
			// entao por precaucao faz procedimento
			npos := ascan( aItDel , {|Z| Z[1] == (cSFT_)->ft_item })
			if npos == 0
				aadd( aItDel , { (cSFT_)->ft_item , "" })
			else
				(cSFT_)->(dbskip())
				loop
			endif
		endif
		
		oDHLSafx08:addLine(@cItenOri, @cId ,oIpSqlSfx08 )
		    
		aFields 	:= oDHLSafx08:getFields()
		cError		:= oDHLSafx08:validRequired(VLD_08_FIELD)
		    
		if !Empty(cError)
			oDHLSafx08:addLog(SAFX08_ERROR_TITLE,SAFX08_ERROR_OBRIGAT+cError,oFile:getFile())
			(cSFT_)->(dbSkip())
			loop
		endIf
		
		
		oFileSfx08:setFields( aFields )
		
		if !oFileSfx08:write()
			oDHLSafx08:addLog(SAFX08_ERROR_TITLE,ERROR_QTD_CAMPOS,oFile:getFile())
			(cSFT_)->(dbSkip())
			loop
		
		endif
		
		cPrefix		:= oDHLSafx08:cPrefix
		
		oSqlRef := retRef(oIpSqlSfx08, cPrefix)
		if oSqlRef:hasRecords()
			oDHLSafx07:setDocRef(.t.)
			cCusSupDv	:= oSqlRef:getValue("A1_COD")
			cBranch		:= oSqlRef:getValue("A1_LOJA")
			cDocOri		:= oSqlRef:getValue("ZA_DOCSCJ")
			cSerOri		:= oSqlRef:getValue("ZA_SERISCJ")
			cItenOri		:= ""
			U_116AG2SAFX(oSqlHeader,@oFlSfx116,cCusSupDv,cBranch,cDocOri,cSerOri,cItenOri,lCobert,@aDocsRef,oDHLSafx07)
		endif
		oSqlRef:close()
		oDHLSafx07:setDocRef(.f.)
		
		cCusSupDv 	:= (Csf3_)->F3_CLIEFOR //oIpSqlSfx08:getValue(cPrefix+"_CLIEFOR")
		cBranch		:= (Csf3_)->F3_loja //oIpSqlSfx08:getValue(cPrefix+"_LOJA")
		cDocOri		:= (CSFT_)->FT_NFORI //oIpSqlSfx08:getValue(cPrefix+"_NFORI")
		cSerOri		:= (CSFT_)->FT_SERORI //pSqlSfx08:getValue(cPrefix+"_SERORI")
		if empty(cItenOri)
			cItenOri	:= (CSFT_)->FT_ITEMORI //oIpSqlSfx08:getValue(cPrefix+"_ITEMORI")
		endif
		
		cTipo := (cSF3_)->tipo //(cSF3_)->ENT_SAI //oSqlHeader:getValue("TIPO")// jj 2018/06/19
		cCFOP := (cSFT_)->FT_CFOP //ALLTRIM(oIpSqlSfx08:GETVALUE(cPrefix+"_CFOP"))
		
		cOrigem := getOrigem(cTipo, cCFOP)
		
		U_116AG2SAFX(oSqlHeader,@oFlSfx116,cCusSupDv,cBranch,cDocOri,cSerOri,cItenOri,lCobert,@aDocsRef,oDHLSafx07, cOrigem)
		
		(cSFT_)->(dbSkip())
	endDo
	
	oIpSqlSfx08:close()

return

/*
**
*/
static function retId(cId)
	local cQuery	:= ""
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cCliDep	:= left(GetNewPar("ZZ_FOINTEG"),6)
	local cLojDep	:= right(GetNewPar("ZZ_FOINTEG"),2)
	
	cQuery += " SELECT MAX(Z3_SEQUEN), Z3_DOC, Z3_SERIE, Z3_ITEM, Z3_CLIFOR, Z3_LOJA "+CRLF
	cQuery += " FROM %SZ3.SQLNAME%                                                   "+CRLF
	cQuery += " WHERE                                                                "+CRLF
	cQuery += " 	%SZ3.XFILIAL%                                                    "+CRLF
	cQuery += " 	AND %SZ3.NOTDEL%                                                 "+CRLF
	cQuery += " 	AND Z3_ID		= '"+cId+"'                                      "+CRLF
	cQuery += " 	AND Z3_SITUACA	= 'N'                                            "+CRLF
	cQuery += " 	AND Z3_CLIFOR	= '"+cCliDep+"'                                  "+CRLF
	cQuery += " 	AND Z3_LOJA		= '"+cLojDep+"'                                  "+CRLF
	cQuery += " 	AND Z3_STATUS	= 'G'                                            "+CRLF
	cQuery += " 	AND Z3_TPMOV	= 'E'                                            "+CRLF
	cQuery += " GROUP BY Z3_DOC, Z3_SERIE, Z3_ITEM, Z3_CLIFOR, Z3_LOJA               "+CRLF
	
	oSql:newAlias(cQuery)
	
return (oSql)


/*
** Retorna NF de cobertura
*/
static function retCob(oIpSqlSfx08, cPrefix)
	local cQuery	:= ""
	local oSql		:= IpSqlObject():newIpSqlObject()
	
	cQuery += " SELECT SZ4REF.Z4_DOC,SZ4REF.Z4_SERIE,SZ4REF.Z4_ITEM, SZ4REF.Z4_CLIFOR, SZ4REF.Z4_LOJA "+CRLF
	cQuery += " FROM %SZ4.SQLNAME%                                                   "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("SZ4")+" SZ4REF ON                           "+CRLF
	cQuery += " 	SZ4REF.D_E_L_E_T_ = ' '                                          "+CRLF
	cQuery += " 	AND SZ4.Z4_IDCOB = SZ4REF.Z4_IDCOB                               "+CRLF
	cQuery += " 	AND SZ4REF.Z4_TIPMOV = '2'                                       "+CRLF
	cQuery += " WHERE                                                                "+CRLF
	cQuery += " 	SZ4.%SZ4.XFILIAL%                                                    "+CRLF
	cQuery += " 	AND %SZ4.NOTDEL%                                                 "+CRLF
	cQuery += " 	AND SZ4.Z4_DOC		= '"+oIpSqlSfx08:getValue(cPrefix+"_NFISCAL")+"' "+CRLF
	cQuery += " 	AND SZ4.Z4_SERIE    = '"+oIpSqlSfx08:getValue(cPrefix+"_SERIE")+"' 		"+CRLF
	cQuery += " 	AND SZ4.Z4_ITEM		= '"+oIpSqlSfx08:getValue(cPrefix+"_ITEM")+"'  		"+CRLF
	cQuery += " 	AND SZ4.Z4_CLIFOR	= '"+oIpSqlSfx08:getValue(cPrefix+"_CLIEFOR")+"' 	"+CRLF
	cQuery += " 	AND SZ4.Z4_LOJA		= '"+oIpSqlSfx08:getValue(cPrefix+"_LOJA")+"'    	"+CRLF
	cQuery += " 	AND SZ4.Z4_TIPMOV = '1'                                              	"+CRLF
	
	oSql:newAlias(cQuery)
	
return (oSql)


/*
** Retorna NF de Referencia de venda para NF de conta e ordem
*/
static function retRef(oIpSqlSfx08, cPrefix)
	local cQuery	:= ""
	local oSql		:= IpSqlObject():newIpSqlObject()
	
	cQuery += " SELECT ZA_DOCSCJ, ZA_SERISCJ, A1_COD, A1_LOJA "+CRLF
	cQuery += " FROM %SF2.SQLNAME%                                                   		"+CRLF
	cQuery += " INNER JOIN %SZA.SQLNAME% ON                                          		"+CRLF
	cQuery += "		ZA_FILIAL 		= F2_FILIAL                                         	"+CRLF
	cQuery += "    	AND ZA_NFRET		= F2_DOC                                          	"+CRLF
	cQuery += "    	AND ZA_SERIRET	= F2_SERIE                                        	"+CRLF
	cQuery += " 		AND %SZA.NOTDEL%		                                       			"+CRLF
	cQuery += " INNER JOIN %SA1.SQLNAME% ON                                          		"+CRLF
	cQuery += "		A1_FILIAL 		= ZA_FILIAL                                         	"+CRLF
	cQuery += "    	AND A1_CGC		= ZA_CNPJSCJ                                         	"+CRLF
	cQuery += " 		AND %SA1.NOTDEL%		                                       			"+CRLF
	cQuery += " WHERE                                                                		"+CRLF
	cQuery += " 	%SF2.XFILIAL%                                                    			"+CRLF
	cQuery += " 	AND %SF2.NOTDEL%                                                 			"+CRLF
	cQuery += " 	AND SF2.F2_DOC		= '"+ (cSF3_)->(F3_NFISCAL) + "' " //oIpSqlSfx08:getValue(cPrefix+"_NFISCAL")+"' 	"+CRLF
	cQuery += " 	AND SF2.F2_SERIE    	= '"+ (cSF3_)->(F3_SERIE) +"' " //oIpSqlSfx08:getValue(cPrefix+"_SERIE")+"' 		"+CRLF
	cQuery += " 	AND SF2.F2_CLIENTE	= '"+ (cSF3_)->(F3_CLIEFOR) + "' " //oIpSqlSfx08:getValue(cPrefix+"_CLIEFOR")+"' 	"+CRLF
	cQuery += " 	AND SF2.F2_LOJA		= '"+ (cSF3_)->(F3_LOJA) + "' " //oIpSqlSfx08:getValue(cPrefix+"_LOJA")+"'    	"+CRLF
	
	oSql:newAlias(cQuery)
	
return (oSql)

/*
** Obtém a origem
*/
static function getOrigem(cTipo, cCFOP)
	
	local cOrigem := ""
	
	if !empty(cCFOP)
			// NOTA DE ENTRADA
		if val(cCFOP) <= 4999
			IF cTipo == "1"
				cOrigem := "SD2"
			else
				cOrigem := "SD1"
			endif
			// NOTA DE SAIDA	
		else
			IF cTipo == "1"
				cOrigem := "SD1"
			else
				cOrigem := "SD2"
			endif
		endif
	endif
	
return cOrigem