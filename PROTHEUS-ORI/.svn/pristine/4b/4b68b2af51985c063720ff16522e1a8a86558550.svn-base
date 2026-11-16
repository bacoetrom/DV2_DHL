#include "totvs.ch"


/*/{Protheus.doc} DHLIdF3

Consulta Específica de ID de Produtos

@author Victor Hugo
@since 30/10/2014
/*/
user function DHLIdF3()
	
	local lOk       := .F.
	local oId		:= nil
	local oIdFinder := DHLIdFinder():newDHLIdFinder(, .f.)
	local aIds		:= {}
	
	private aDels	:= {}
	
	public _F3DhlId	:= .f.
	
	lOk := validPrd()
	
	if lOk
	
		getIds(@oIdFinder)
		
		_F3DhlId := .t.
		if oIdFinder:show()
			lOk := .T.
			oId := oIdFinder:getSelectedId()
			//		ApMsgInfo("ID Selecionado: "+oId:getId()+" - "+AllTrim(oId:getDescription())+" - "+oId:getSequence())
			putData()
		else
			lOk := .f.
			_F3DhlId := .f.
		endIf
	else
		alert("Favor inserir o Código do  Produto!")
	endif
	
return lOk


/*
** Preechimento de informações
*/
static function putData()
	local cDoc		:= SZ3->Z3_DOC
	local cSeries	:= SZ3->Z3_SERIE
	local cItem		:= SZ3->Z3_ITEM
	local cIdent	:= SZ3->Z3_IDENTB6
	local cProduct	:= SZ3->Z3_PRODUTO
	local cEntity	:= ""
	local cUnit		:= ""
	local cType		:= ""
	
	if FunName() == "MATA410"
		if INCLUI .or. ALTERA
			cEntity	:= M->C5_CLIENTE
			cUnit	:= M->C5_LOJACLI
			cType	:= M->C5_TIPO
//		else
//			cEntity	:= SC5->C5_CLIENTE
//			cUnit	:= SC5->C5_LOJACLI
//			cType	:= SC5->C5_TIPO
		endif
		putDataSC6(cDoc, cSeries, cItem, cIdent, cEntity, cUnit, cType, cProduct)
		
	elseif (FunName() == "MATA103") .or. (FunName() == "MATA140")
		if INCLUI
			cType	:= cTipo  
		else
			cType	:= SF1->F1_TIPO
		endif
		
		putDataSD1(cDoc, cSeries, cItem, cIdent, cType, cProduct)
		
	endif
	
return

/*
** Coleta IDs para processos especificos
*/
static function getIds(oIdFinder)
	local cQuery	:= getQuery()
	local aIds		:= {}
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local nI		:= 0
	
	if empty(cQuery)
		//oIdFinder := DHLProductId():newDHLProductId()
	else
		oSql:newAlias(cQuery)
		while oSql:notIsEof()
			
			oId := DHLProductId():newDHLProductId(oSql:getValue("R_E_C_N_O_"))
			aAdd(aIds, oId)
			
			oSql:skip()
		enddo
		oSql:close()
		for nI:=1 to len(aDels)
			cQuery	:= getDelQuery(aDels[nI,1], aDels[nI,2])
			oSql:newAlias(cQuery)
			if oSql:hasRecords()
				oId := DHLProductId():newDHLProductId(oSql:getValue("R_E_C_N_O_"))
				aAdd(aIds, oId)
			endif
			oSql:close()
		next nI
		oIdFinder:setIds(aIds)
		
	endif
	
return()


/*
** Coleta query
*/
static function getQuery()
	local cQuery	:= ""
	local cWhere	:= ""
	local cCodProd	:= ""
	local cEntity	:= ""
	local cUnit		:= ""
	local oSql 		:= IpSqlObject():newIpSqlObject()
	
	if FunName() == "MATA410"
		cCodProd := GdFieldGet("C6_PRODUTO", n)
	elseif (FunName() == "MATA103") .or. (FunName() == "MATA140")
		cCodProd := GdFieldGet("D1_COD", n)
		if INCLUI
			cEntity	:= ca100for
			cUnit	:= cloja
		else
			cEntity	 := SF1->F1_FORNECE
			cUnit 	 := SF1->F1_LOJA
		endif
	endif
	
	cQuery := "  SELECT MAX(Z3_SEQUEN) SEQUEN, Z3_ID "
	cQuery += "  FROM %SZ3.SQLNAME% "
	cQuery += "  WHERE "
	cQuery += "		Z3_FILIAL	  = '%SZ3.FILIAL%' "
	if !empty(cCodProd)
		cQuery += "     AND Z3_PRODUTO = '"+cCodProd+"' "
	endif
	if  FunName() == "MATA410"
	else
		cQuery += " AND Z3_CLIFOR 	= '"+cEntity+"' "
		cQuery += " AND Z3_LOJA 	= '"+cUnit+"' "
	endif
	cQuery += "     AND Z3_TIPODOC NOT IN ('I','C','P')  "
	cQuery += "     AND %SZ3.NOTDEL%  "
	if empty(cCodProd)
		cQuery += " AND ROWNUM < 300 "
	endif
	cQuery += "  GROUP BY Z3_ID "
	oSql:newAlias(cQuery)
	getSeqDel(@oSql, @cQuery, cCodProd, cEntity, cUnit)
	
	oSql:newAlias(cQuery)
	
	if oSql:hasRecords()
		cWhere := getWhere(oSql)
		cQuery := "  SELECT R_E_C_N_O_ "
		cQuery += "  FROM %SZ3.SQLNAME% "
		cQuery += "  WHERE "
		cQuery += "		Z3_FILIAL	  = '%SZ3.FILIAL%' "
		if !empty(cCodProd)		
			cQuery += "     AND Z3_PRODUTO = '"+cCodProd+"' "
		endif
		if  FunName() == "MATA410"
			cQuery += " AND Z3_TPMOV = 'E' AND Z3_SITUACA = 'N'"
		else
			cQuery += " AND Z3_TPMOV = 'S' AND Z3_SITUACA = 'N'"
			cQuery += " AND Z3_CLIFOR 	= '"+cEntity+"' "
			cQuery += " AND Z3_LOJA 	= '"+cUnit+"' "
		endif
		if !empty(cWhere)
			cQuery += cWhere
		endif
		cQuery += "     AND Z3_TIPODOC NOT IN ('I','C','P')  "
		cQuery += " 	AND Z3_SITUACA = 'N' "
		cQuery += "     AND %SZ3.NOTDEL%  "
		
		cQuery += " ORDER BY 1"
	endif
	
	oSql:close()
	
return (cQuery)


/*
** Monta where para seleção de IDs
*/
static function getWhere(oSql)
	local cWhere := ""	
	
	while oSql:notIsEof()
		
		cWhere +=" ( Z3_ID = '"+oSql:getValue("Z3_ID")+"' AND Z3_SEQUEN = '"+oSql:getValue("SEQUEN")+"' ) OR"
		
		oSql:skip()
	enddo
	
	cWhere := "AND (" + substr(cWhere, 1, len(cWhere)-2) + " )"
	
return(cWhere)


/*
** Localiza NF de sequencia de doc. entrada para encerramento passo 4.
*/
static function getSqlDepos()
	local cQuery	:= ""
	local cId		:= ""
	local cCodProd	:= ""
	local cEntity	:= ""
	local cUnit		:= ""
	local oSql 		:= IpSqlObject():newIpSqlObject()
	
	cEntity	 := M->C5_CLIENTE
	cUnit 	 := M->C5_LOJACLI
	cCodProd := SZ3->Z3_PRODUTO
	cId		 := SZ3->Z3_ID
	
	cQuery :=" SELECT Z3_DOC, Z3_SERIE, Z3_ITEM, Z3_IDENTB6 FROM %SZ3.SQLNAME% "
	cQuery +=" WHERE "
	cQuery +=" 		Z3_SEQUEN = (SELECT MAX(Z3_SEQUEN) SEQUEN FROM "+RetSqlName("SZ3")+" SZ3X "
	cQuery +=" 					WHERE "
	cQuery +=" 						Z3_ID = '"+cId+"' "
	cQuery +=" 						AND Z3_FILIAL 		= '%SZ3.FILIAL%' "
	cQuery +=" 						AND Z3_SITUACA 		= 'N'"
	cQuery +=" 						AND Z3_CLIFOR 		= '"+cEntity+"'"
	cQuery +=" 						AND Z3_LOJA 		= '"+cUnit+"'"
	cQuery +=" 						AND SZ3X.D_E_L_E_T_ = ' '  ) "
	cQuery +=" 		AND Z3_FILIAL 	= '%SZ3.FILIAL%' " "
	cQuery +="		AND Z3_ID 		= '"+cId+"' "
	cQuery +="		AND Z3_SITUACA 	= 'N' "
	cQuery +="		AND %SZ3.NOTDEL% "
	
	oSql:newAlias(cQuery)
return(oSql)


/*
** Insere conteúdo na SC6
*/
static function putDataSC6(cDoc, cSeries, cItem, cIdent, cEntity, cUnit, cType, cProduct)
	local nItemPrice := 0
	local oSql 		 := nil
	local oSqlUtil	 := IpSqlObject():newIpSqlObject()
	local cTypeEntit := ""
	local aAreaSC6	 := SC6->(GetArea())
	
	if cType $ 'B|D|'
		cTypeEntit  := oSqlUtil:getFieldValue("SA2", "A2_ZZDEPOS", " %SA2.XFILIAL% AND A2_COD = '"+cEntity+"' AND A2_LOJA = '"+cUnit+"' ")
	else
		cTypeEntit  := oSqlUtil:getFieldValue("SA1", "A1_ZZDEPOS", " %SA1.XFILIAL% AND A1_COD = '"+cEntity+"' AND A1_LOJA = '"+cUnit+"' ")
	endif
	
	//TODO - THIAGO - GOOD/BAD FASE 2 - FORMAÇÃO DE PREÇO
	if SZ3->Z3_STATUS == 'G' .and. cTypeEntit != 'S'
		if GetNewPar("ZZ_ICSTDEV", .T.)
			nItemPrice := SZ3->(Z3_VUNIT + Z3_VALICM + Z3_VALIPI)
		else
			nItemPrice := SZ3->(Z3_VUNIT + Z3_VALIPI)
		endif
	elseif SZ3->Z3_STATUS == 'G' .and. cTypeEntit == 'S'
		nItemPrice := SZ3->Z3_VUNIT
	elseif SZ3->Z3_STATUS == 'B'
		nItemPrice := SZ3->Z3_VUNIT
	endif
	
	if empty(GdFieldGet("C6_PRODUTO", n))
		GdFieldPut("C6_PRODUTO", cProduct, n)
		GdFieldPut("C6_DESCRI", oSqlUtil:getFieldValue("SB1", "B1_DESC", " %SB1.XFILIAL% AND B1_COD = '"+cProduct+"' "), n)
		GdFieldPut("C6_UM", oSqlUtil:getFieldValue("SB1", "B1_UM", " %SB1.XFILIAL% AND B1_COD = '"+cProduct+"' "), n)
		GdFieldPut("C6_LOCAL", oSqlUtil:getFieldValue("SD1", "D1_LOCAL", " %SD1.XFILIAL% AND D1_DOC = '"+cDoc+"' AND D1_SERIE = '"+cSeries+"' AND "+;
					" D1_FORNECE = '"+SZ3->Z3_CLIFOR+"' AND D1_LOJA = '"+SZ3->Z3_LOJA+"' AND D1_ITEM = '"+SZ3->Z3_ITEM+"'"), n)
		
		dbselectarea("SC6")
		If ExistTrigger('C6_PRODUTO')       
			RunTrigger(2,n,nil,,'C6_PRODUTO')
		Endif	 
	endif
	
	GdFieldPut("C6_QTDVEN"	, 1, n)
	GdFieldPut("C6_PRCVEN"	, nItemPrice, n)
	GdFieldPut("C6_VALOR"	, A410Arred(nItemPrice,"C6_VALOR"), n)
	GdFieldPut("C6_NFORI"	, cDoc, n)
	GdFieldPut("C6_SERIORI" , cSeries, n)
	GdFieldPut("C6_ITEMORI" , cItem, n)
	GdFieldPut("C6_IDENTB6" , cIdent, n)
	
	RestArea(aAreaSC6)
return()


/*
** Insere conteúdo na SD1
*/
static function putDataSD1(cDoc, cSeries, cItem, cIdent, cType, cProduct) 
	local nItemPrice:= 0
	local oSqlUtil	 := IpSqlObject():newIpSqlObject()
	
	if cType $ 'B|D|'
		GdFieldPut("D1_NFORI", 	cDoc, n)
		MaFisRef("IT_NFORI", "MT100", cDoc)
		GdFieldPut("D1_SERIORI", cSeries, n)
		MaFisRef("IT_SERORI", "MT100", cSeries)
		GdFieldPut("D1_ITEMORI", cItem, n)
//		GdFieldPut("D1_IDENTB6", cIdent, n)
	endif
	
	nItemPrice := SZ3->Z3_VUNIT
	
	if empty(GdFieldGet("D1_COD", n))
		GdFieldPut("D1_COD", cProduct, n)
		MaFisRef("IT_PRODUTO", "MT100", cProduct)
		GdFieldPut("D1_UM", oSqlUtil:getFieldValue("SB1", "B1_UM", " %SB1.XFILIAL% AND B1_COD = '"+cProduct+"' "), n)
		GdFieldPut("D1_LOCAL", oSqlUtil:getFieldValue("SB1", "B1_LOCPAD", " %SB1.XFILIAL% AND B1_COD = '"+cProduct+"' "), n)
	endif
	
	GdFieldPut("D1_QUANT", 1, n)
	MaFisRef("IT_QUANT", "MT100", 1)
	GdFieldPut("D1_VUNIT", nItemPrice, n)
	MaFisRef("IT_PRCUNI", "MT100", nItemPrice)
	GdFieldPut("D1_TOTAL", nItemPrice, n)
	MaFisRef("IT_VALMERC", "MT100", nItemPrice)
return


/*
** Busca IDs quando possuí estorno
*/
static function getSeqDel(oSql, cQuery, cCodProd, cEntity, cUnit)
	local cDels 	:= ""
	local cDepos	:= Alltrim(GetNewPar("ZZ_FORNDEP", ""))
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local oSqlSZ3	:= IpSqlObject():newIpSqlObject()
		
	while oSql:notIsEof()
		oSqlSZ3:newTable("SZ3", "Z3_CLIFOR,Z3_LOJA,Z3_STATUS,Z3_DOC,Z3_SERIE,Z3_TPMOV", " %SZ3.XFILIAL% AND Z3_ID = '"+oSql:getValue("Z3_ID")+"' AND Z3_SEQUEN = '"+oSql:getValue("SEQUEN")+"' ")
		
		if oSqlUtil:getFieldValue("SZ3", "Z3_SITUACA", " %SZ3.XFILIAL% AND Z3_ID = '"+oSql:getValue("Z3_ID")+"' AND Z3_SEQUEN = '"+oSql:getValue("SEQUEN")+"' ")  == 'E'
			aadd(aDels, {oSql:getValue("Z3_ID"), iif(oSqlSZ3:getValue("Z3_TPMOV") == 'S','E','S')})
			
//			if (alltrim(oSqlSZ3:getValue("Z3_CLIFOR") + oSqlSZ3:getValue("Z3_LOJA")) != cDepos) .and. (oSqlSZ3:getValue("Z3_STATUS") != 'G') 
//				cDels += "'"+oSql:getValue("Z3_ID")+"',"
//			endif
		endif
		oSqlUtil:close()
		oSql:skip()
	enddo
	oSqlSZ3:close()

	if !empty(cDels)
		cDels := substr(cDels, 1, len(cDels)-1)
		cQuery += "  UNION "
		cQuery += "  SELECT MAX(Z3_SEQUEN) SEQUEN, Z3_ID "
		cQuery += "  FROM %SZ3.SQLNAME% "
		cQuery += "  WHERE "
		cQuery += "		Z3_FILIAL	  = '%SZ3.FILIAL%' "
		if !empty(cCodProd)
			cQuery += "     AND Z3_PRODUTO = '"+cCodProd+"' "
		endif
		if  FunName() == "MATA410"
			cQuery += " AND Z3_TPMOV = 'E' "
		else
			cQuery += " AND Z3_TPMOV 	= 'S' "
			cQuery += " AND Z3_CLIFOR 	= '"+cEntity+"' "
			cQuery += " AND Z3_LOJA 	= '"+cUnit+"' "
		endif
		cQuery += " 	AND Z3_SITUACA 	= 'N' "
		cQuery += " 	AND Z3_ID 		IN ("+cDels+") "
		cQuery += "     AND %SZ3.NOTDEL%  "
		cQuery += "  GROUP BY Z3_ID "
	endif
	
	oSql:close()
return


/*
** validPrd
*/
static function validPrd()
	local cCodProd 	:= ""
	local lRet		:= .t.
	
	if FunName() == "MATA410"
		cCodProd := GdFieldGet("C6_PRODUTO", n)
	elseif (FunName() == "MATA103") .or. (FunName() == "MATA140")
		cCodProd := GdFieldGet("D1_COD", n)
	endif
	
	if empty(cCodProd)
		lRet := .f.
	endif
	
return lRet


/*
** Coleta query
*/
static function getDelQuery(cID, cTpMov)
	local cQuery	:= ""
	local cWhere	:= ""
	local cCodProd	:= ""
	local cEntity	:= ""
	local cUnit		:= ""
	local oSql 		:= IpSqlObject():newIpSqlObject()
	
	if FunName() == "MATA410"
		cCodProd := GdFieldGet("C6_PRODUTO", n)
	elseif (FunName() == "MATA103") .or. (FunName() == "MATA140")
		cCodProd := GdFieldGet("D1_COD", n)
		if INCLUI
			cEntity	:= ca100for
			cUnit	:= cloja
		else
			cEntity	 := SF1->F1_FORNECE
			cUnit 	 := SF1->F1_LOJA
		endif
	endif
	
	cQuery := "  SELECT MAX(Z3_SEQUEN) SEQUEN, Z3_ID "
	cQuery += "  FROM %SZ3.SQLNAME% "
	cQuery += "  WHERE "
	cQuery += "		Z3_FILIAL	  = '%SZ3.FILIAL%' "
	if !empty(cCodProd)
		cQuery += "     AND Z3_PRODUTO = '"+cCodProd+"' "
	endif
	if  !(FunName() == "MATA410")
		cQuery += " AND Z3_CLIFOR 	= '"+cEntity+"' "
		cQuery += " AND Z3_LOJA 	= '"+cUnit+"' "
	endif
	cQuery += " AND Z3_TPMOV = '"+cTpMov+"' "
	cQuery += " AND Z3_ID	 = '"+cID+"' "
	cQuery += " AND Z3_TIPODOC NOT IN ('I','C','P')  "
	cQuery += " AND %SZ3.NOTDEL%  "
	if empty(cCodProd)
		cQuery += " AND ROWNUM < 300 "
	endif
	cQuery += "  GROUP BY Z3_ID "
	oSql:newAlias(cQuery)
	
	if oSql:hasRecords()
		cWhere := getWhere(oSql)
		cQuery := "  SELECT R_E_C_N_O_ "
		cQuery += "  FROM %SZ3.SQLNAME% "
		cQuery += "  WHERE "
		cQuery += "		Z3_FILIAL	  = '%SZ3.FILIAL%' "
		if !empty(cCodProd)		
			cQuery += "     AND Z3_PRODUTO = '"+cCodProd+"' "
		endif
		if  FunName() == "MATA410"
			cQuery += " AND Z3_TPMOV = 'E' AND Z3_SITUACA = 'N'"
		else
			cQuery += " AND Z3_TPMOV = 'S' AND Z3_SITUACA = 'N'"
			cQuery += " AND Z3_CLIFOR 	= '"+cEntity+"' "
			cQuery += " AND Z3_LOJA 	= '"+cUnit+"' "
		endif
		if !empty(cWhere)
			cQuery += cWhere
		endif
		cQuery += "     AND Z3_TIPODOC NOT IN ('I','C','P')  "
		cQuery += " 	AND Z3_SITUACA = 'N' "
		cQuery += "     AND %SZ3.NOTDEL%  "
		
		cQuery += " ORDER BY 1"
	endif
	
	oSql:close()
	
return (cQuery)