#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx08.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} SAFX08MSDW

Respons‡vel por gerar o arquivo SAFX08
	
@author Daniel Braga
@since 30/10/2014

/*/
user function SAFX08DIS(oSqlHeader,oFile,oFlSfx116,aDocsRef)

	local oFileSfx08 		:= nil
	local oIpSqlSfx08 		:= IpSqlObject():newIpSqlObject()
	local oDHLSafx08		:= DHLSafx08Dis():newDHLSafx08Dis()
	local oSqlDev			:= nil
	local oSqlCob			:= nil
	local cError			:= ""
	local cCusSupDv			:= ""
	local cBranch			:= ""
	local cDocOri			:= ""
	local cSerOri			:= ""
	local cItenOri			:= ""
	local cChvNfRef			:= ""
	local aFields			:= {}
	local cPrefix			:= ""
	local cId				:= ""
	local lIdRef			:= .f.		
	local lCobert			:= .f.		
	
	oFileSfx08	:= oFile
	
	oDHLSafx08:initialize(SAFX08_POSICOES,oSqlHeader,oIpSqlSfx08)
	
	oIpSqlSfx08:newAlias( oDHLSafx08:getSqlFt() )

	oDHLSafx08:setDetailSql(oIpSqlSfx08)
	oDHLSafx08:setItem("01")
	
	while oIpSqlSfx08:notIsEof()
		lIdRef := .f.
		   
		oDHLSafx08:addLine(@cItenOri, @cId, @lIdRef)
		    
		aFields 	:= oDHLSafx08:getFields()
		cError		:= oDHLSafx08:validRequired(VLD_08_FIELD)
		    
		if !Empty(cError)
			oDHLSafx08:addLog(SAFX08_ERROR_TITLE,SAFX08_ERROR_OBRIGAT+cError,oFile:getFile())
			oIpSqlSfx08:skip()
			loop
		endIf
		
		
		oFileSfx08:setFields( aFields )
		
		if !oFileSfx08:write()
			oDHLSafx08:addLog(SAFX08_ERROR_TITLE,ERROR_QTD_CAMPOS,oFile:getFile())
			oIpSqlSfx08:skip()
			loop
		
		endif
		
		cPrefix		:= oDHLSafx08:cPrefix
		cCusSupDv 	:= oIpSqlSfx08:getValue(cPrefix+"_CLIEFOR")	
		cBranch		:= oIpSqlSfx08:getValue(cPrefix+"_LOJA")
		cDocOri		:= oIpSqlSfx08:getValue(cPrefix+"_NFORI")
		cSerOri		:= oIpSqlSfx08:getValue(cPrefix+"_SERORI")
		if empty(cItenOri)
			cItenOri	:= oIpSqlSfx08:getValue(cPrefix+"_ITEMORI")
		endif
		
		if cSerOri == DHL_SERIE_ESPELHO
			cChvNfRef 	:= retRefDev(oIpSqlSfx08, cPrefix)
			cDocOri		:= left(cChvNfRef, tamSx3("F1_DOC")[1])
			cSerOri		:= substr(cChvNfRef, tamSx3("F1_DOC")[1] + 1, tamSx3("F1_SERIE")[1])
			cItenOri	:= substr(cChvNfRef, (tamSx3("F1_DOC")[1] + tamSx3("F1_SERIE")[1]) + 1, tamSx3("D1_ITEM")[1])
			cCusSupDv	:= substr(cChvNfRef, len(cChvNfRef) - tamSx3("F1_LOJA")[1] - tamSx3("F1_FORNECE")[1]+1, tamSx3("F1_FORNECE")[1])
			cBranch		:= right(cChvNfRef, tamSx3("F2_LOJA")[1])
		endif
		
		oSqlCob := retCob(oIpSqlSfx08, cPrefix)
		if oSqlCob:hasRecords() 
			lCobert		:= .t.
			cCusSupDv	:= oSqlCob:getValue("Z4_CLIFOR")
			cBranch		:= oSqlCob:getValue("Z4_LOJA")
			cDocOri		:= oSqlCob:getValue("Z4_DOC")
			cSerOri		:= oSqlCob:getValue("Z4_SERIE")
			cItenOri	:= oSqlCob:getValue("Z4_ITEM")
		endif
		oSqlCob:close()
		
		
		U_SAFX116DIS(oSqlHeader,@oFlSfx116,cCusSupDv,cBranch,cDocOri,cSerOri,cItenOri,lCobert,@aDocsRef)
		
		oIpSqlSfx08:skip()	
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
** Localiza NF de referência 
*/
static function retRefDev(oIpSqlSfx08, cPrefix)
	local oDev		:= DHLDisDevRec():newDHLDisDevRec()
	local cDoc		:= oIpSqlSfx08:getValue(cPrefix+"_NFISCAL")
	local cSeries	:= oIpSqlSfx08:getValue(cPrefix+"_SERIE")
	local cItem		:= oIpSqlSfx08:getValue(cPrefix+"_ITEM")
	local cChvNf	:= ""
	
	cChvNf := oDev:getKeyNf(cDoc, cSeries, cItem)
	
return (cChvNf)