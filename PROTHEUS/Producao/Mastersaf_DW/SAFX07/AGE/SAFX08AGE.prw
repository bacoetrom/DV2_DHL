#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx08.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} SAFX08AGE

Respons‡vel por gerar o arquivo SAFX08
	
@author Thiago Meschiatti
@since 05/09/2016

/*/
user function SAFX08AGE(oSqlHeader,oFile,oFlSfx116,aDocsRef,oDHLSafx07)

	local oFileSfx08 		:= nil
	local oIpSqlSfx08 		:= IpSqlObject():newIpSqlObject()
	local oDHLSafx08		:= DHLSafx08Age():newDHLSafx08Age()
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
	local cOrigem           := ""
	local cCFOP				:= ""
	local cTipo				:= ""
	local npos			:= 0
	local aItDel			:= {}
	private lNewAge	:= SuperGetMV("ZZ_NEWAGE",,.F.)	
	
	oFileSfx08	:= oFile
	
	oDHLSafx08:initialize(SAFX08_POSICOES,oSqlHeader,oIpSqlSfx08)
	
	//oIpSqlSfx08:newAlias( oDHLSafx08:getSqlFt() )

	//oDHLSafx08:setDetailSql(oIpSqlSfx08)
	oDHLSafx08:setItem("01")
	
	//while oIpSqlSfx08:notIsEof()

	while (cSFT_)->(!eof())
		lIdRef := .f.
		
		
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

		oDHLSafx08:addLine(@cItenOri, @cId, @lIdRef , oIpSqlSfx08  )  // envia obj para addline
		    
		aFields 	:= oDHLSafx08:getFields()
		cError		:= oDHLSafx08:validRequired(VLD_08_FIELD)
		    
		if !Empty(cError)
			oDHLSafx08:addLog(SAFX08_ERROR_TITLE,SAFX08_ERROR_OBRIGAT+cError,oFile:getFile())
			//oIpSqlSfx08:skip()
			(cSFT_)->(dbSkip())
			loop
		endIf
			    
		
		oFileSfx08:setFields( aFields )
		
		if !oFileSfx08:write()
			oDHLSafx08:addLog(SAFX08_ERROR_TITLE,ERROR_QTD_CAMPOS,oFile:getFile())
			//oIpSqlSfx08:skip()
			(cSFT_)->(dbSkip())
			loop
		
		endif
		
		cPrefix		:= oDHLSafx08:cPrefix
		
		if oDHLSafx07:hasDocRef()
			oSqlRef := retRef(oIpSqlSfx08, cPrefix)
			if oSqlRef:hasRecords() 
				cCusSupDv	:= oSqlRef:getValue("Z8_CLIENTE")
				cBranch		:= oSqlRef:getValue("Z8_LOJA")
				cDocOri		:= oSqlRef:getValue("Z8_DOC")
				cSerOri		:= oSqlRef:getValue("Z8_SERIE")
				cItenOri	:= ""
				U_SAFX116AGE(oSqlHeader,@oFlSfx116,cCusSupDv,cBranch,cDocOri,cSerOri,cItenOri,lCobert,@aDocsRef,oDHLSafx07)
			endif
			oSqlRef:close()
			oDHLSafx07:setDocRef(.f.)
		endif
		
		cCusSupDv 	:= (Csf3_)->F3_CLIEFOR   //oIpSqlSfx08:getValue(cPrefix+"_CLIEFOR")	
		cBranch		:= (Csf3_)->F3_LOJA      //oIpSqlSfx08:getValue(cPrefix+"_LOJA")
		cDocOri		:= (CSFT_)->FT_NFORI     //oIpSqlSfx08:getValue(cPrefix+"_NFORI")
		cSerOri		:= (CSFT_)->FT_SERORI    //oIpSqlSfx08:getValue(cPrefix+"_SERORI")
		if empty(cItenOri)
			cItenOri:= (CSFT_)->FT_ITEMORI   //oIpSqlSfx08:getValue(cPrefix+"_ITEMORI")
		endif
		
		cTipo := (cSF3_)->TIPO //(cSF3_)->ENT_SAI //oSqlHeader:getValue("TIPO") // jj 2018/06/18
		cCFOP := (CSFT_)->FT_CFOP            //ALLTRIM(oIpSqlSfx08:GETVALUE(cPrefix+"_CFOP"))
		
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
		
		
		/*
		// NÃO SERÁ MAIS NECESSÁRIO 23/10/2017 
		
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
		*/
	
		U_SAFX116AGE(oSqlHeader,@oFlSfx116,cCusSupDv,cBranch,cDocOri,cSerOri,cItenOri,lCobert,@aDocsRef,oDHLSafx07,cOrigem)
		
		//oIpSqlSfx08:skip()
        (cSFT_)->(dbSkip())		
	endDo
	
	//oIpSqlSfx08:close()

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
** Retorna NF de Referencia(Locação ou Comodato)
*/
static function retRef(oIpSqlSfx08, cPrefix)
	local cQuery	:= ""
	local oSql		:= IpSqlObject():newIpSqlObject()
	
	cQuery += " SELECT Z8_DOC, Z8_SERIE, Z8_CLIENTE, Z8_LOJA "+CRLF
	cQuery += " FROM %SF2.SQLNAME%                                                   "+CRLF
	cQuery += " INNER JOIN %SZ8.SQLNAME% ON                                          "+CRLF
	cQuery += "		Z8_FILIAL = F2_FILIAL                                            "+CRLF      
	cQuery += "    	AND Z8_DOC = F2_ZZNFTER                                          "+CRLF
	cQuery += "    	AND Z8_SERIE = F2_ZZSETER                                        "+CRLF
	
	if cFilAnt == AGE_MONDELEZ		
		cQuery += "    	AND Z8_CLIEMIT = F2_CLIENTE                                      "+CRLF
		cQuery += "    	AND Z8_LOJEMIT = F2_LOJA                                      "+CRLF		
	elseIf !lNewAge .and. FWUnitBusiness() == DHL_BUSINESSUNIT_AGE 
		cQuery += "    	AND Z8_CLIEMIT = F2_ZZCLTER                                      "+CRLF
		cQuery += "    	AND Z8_LOJEMIT = F2_ZZLJTER                                      "+CRLF
	else
		cQuery += "    	AND Z8_CLIEMIT = F2_CLIENTE                                      "+CRLF
		cQuery += "    	AND Z8_LOJEMIT = F2_LOJA                                      "+CRLF
	endif
	
	cQuery += " 	AND %SZ8.NOTDEL%		                                         "+CRLF
	cQuery += " WHERE                                                                "+CRLF
	cQuery += " 	%SF2.XFILIAL%                                                    "+CRLF
	cQuery += " 	AND %SF2.NOTDEL%                                                 "+CRLF
	cQuery += " 	AND SF2.F2_DOC		= '"+  (cSF3_)->(F3_NFISCAL) + "' " //oIpSqlSfx08:getValue(cPrefix+"_NFISCAL")+"' "+CRLF
	cQuery += " 	AND SF2.F2_SERIE    = '"+ (cSF3_)->(F3_SERIE) +"' " //oIpSqlSfx08:getValue(cPrefix+"_SERIE")+"' 		"+CRLF
	cQuery += " 	AND SF2.F2_CLIENTE	= '"+ (cSF3_)->(F3_CLIEFOR) + "' " //oIpSqlSfx08:getValue(cPrefix+"_CLIEFOR")+"' 	"+CRLF
	cQuery += " 	AND SF2.F2_LOJA		= '"+ (cSF3_)->(F3_LOJA) + "' " //oIpSqlSfx08:getValue(cPrefix+"_LOJA")+"'    	"+CRLF
	
	oSql:newAlias(cQuery)
	
return (oSql)
