#Include 'Protheus.ch'


/*/{Protheus.doc} procGrvImp

Processa gravação de impostos de acordo com a regra

@author Thiago Meschiatti
@since 19/11/2014

@param xParam, TipoParam, DescricaoDoParam

@return TipoRet DescricaoRet
/*/
User Function ProcGrvImp()
	local nI		:= 0
	local nVlrUnit	:= 0
	local nVlrIcm	:= 0
	local nVlrIpi	:= 0
	local nVlrTotal := 0
	local nVlrTotIpi:= 0
	local nVlrTotIcm:= 0
	local cId		:= ""
	local cProd		:= ""
	local cTypeEntit:= ""
	local cField	:= ""
	local cMsg		:= ""
	local oSql		:= nil
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local oUtils    := IpUtilsObject():newIpUtilsObject()
	
	if SC5->C5_TIPO $ 'B|D|'
		cTypeEntit  := oSqlUtil:getFieldValue("SA2", "A2_ZZDEPOS", " %SA2.XFILIAL% AND A2_COD = '"+SC5->C5_CLIENTE+"' AND A2_LOJA = '"+SC5->C5_LOJACLI+"' ")		
	else
		cTypeEntit  := oSqlUtil:getFieldValue("SA1", "A1_ZZDEPOS", " %SA1.XFILIAL% AND A1_COD = '"+SC5->C5_CLIENTE+"' AND A1_LOJA = '"+SC5->C5_LOJACLI+"' ")
	endif
	
	for nI := 1 to len(aCols)
		cId		:= GdFieldGet("C6_ZZID", nI)
		cProd	:= GdFieldGet("C6_PRODUTO", nI)
		oSql	:= getQuery(cId, cProd)
		if oSql:hasRecords()
			if nI == 1
				if oSql:getValue("Z3_STATUS") == 'G' .and. cTypeEntit != 'S'
					cField := "C5_DESPESA"
				elseif oSql:getValue("Z3_STATUS") == 'G' .and. cTypeEntit == 'S'
					cField := "C5_MENNOTA"
				endif
			endif
			nVlrUnit	:= oSql:getValue("Z3_VUNIT")
			nVlrIcm		:= oSql:getValue("Z3_VALICM")
			nVlrIpi		:= oSql:getValue("Z3_VALIPI")
		endif
		nVlrTotal	+= nVlrUnit + nVlrIcm + nVlrIpi
		nVlrTotIcm 	+= nVlrIcm 
		nVlrTotIpi	+= nVlrIpi
		oSql:close()
	next
	
	if cField == "C5_DESPESA"
		//oSql:update("SC5", "C5_DESPESA = "+oUtils:strAnyType(nVlrTotal)+" ", "C5_FILIAL = '"+SC5->C5_FILIAL+"' AND C5_NUM = "+SC5->C5_NUM+" ")
	elseif cField == "C5_MENNOTA"
		if nVlrTotIcm > 0 .and. GetNewPar("ZZ_ICSTDEV", .T.)
			cMsg := alltrim(SC5->C5_MENNOTA) +" - Valor de ICMS Retido: R$ "+oUtils:strAnyType(nVlrTotIcm)+" e "
		endif
		if nVlrTotIpi > 0 
			cMsg += "Valor Total de IPI: R$ "+oUtils:strAnyType(nVlrTotIpi)+"."
		endif
		if !empty(cMsg)
			oSql:update("SC5", "C5_MENNOTA = '"+substr(cMsg, 1, TAMSX3("C5_MENNOTA")[1])+"' ", "C5_FILIAL = '"+SC5->C5_FILIAL+"' AND C5_NUM = "+SC5->C5_NUM+" ")
		endif
	endif
	
return()


/*
** Coleta query
*/
static function getquery(cId, cProd)
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	
	cQuery :=" SELECT Z3_STATUS, Z3_VUNIT, Z3_VALICM, Z3_VALIPI FROM %SZ3.SQLNAME% "
	cQuery +=" WHERE "
	cQuery +=" 		Z3_SEQUEN = (SELECT MAX(Z3_SEQUEN) SEQUEN FROM "+RetSqlName("SZ3")+" SZ3X "
	cQuery +=" 					WHERE "
	cQuery +=" 						Z3_ID = '"+cId+"' "
	cQuery +=" 						AND Z3_PRODUTO 		= '"+cProd+"' "
	cQuery +=" 						AND Z3_FILIAL 		= '%SZ3.FILIAL%' "
	cQuery +=" 						AND Z3_SITUACA 		= 'N'"
	cQuery +=" 						AND SZ3X.D_E_L_E_T_ = ' '  ) "
	cQuery +=" 		AND Z3_FILIAL 	= '%SZ3.FILIAL%' " "
	cQuery +="		AND Z3_ID 		= '"+cId+"' "
	cQuery +=" 		AND Z3_PRODUTO 	= '"+cProd+"' "
	cQuery +="		AND Z3_SITUACA 	= 'N' "
	cQuery +="		AND %SZ3.NOTDEL% "
	
	oSql:newAlias(cQuery)
return(oSql)
