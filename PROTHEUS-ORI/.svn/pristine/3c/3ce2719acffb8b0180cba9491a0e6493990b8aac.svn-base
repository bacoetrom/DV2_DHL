#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} DHLValidID

Validações ID.

@author Thiago Meschiatti
@since 03/11/2014

@param cID, character, ID do produto

@return lógico Retorno se linha é valida.
/*/
user function DHLValidID(cEvent, cField, aColsAux)
	local lOK
	local cEvent	:= Upper(Alltrim(cEvent))
	local aArea		
	local aAreaSX3
	
	default aColsAux := aCols
	
	if cEvent == "DHL_EXIST_ID"
		lOK := validLine(cField)
	elseif cEvent == "DHL_VLD_DUPLIC_LINE"
		lOK := validDupliAcols(cField, aColsAux)
	elseif cEvent == "DHL_FIELD_REQUIRED"
		lOK := fieldRequired(cField, aColsAux)
	elseif cEvent == "DHL_VLD_QUANTITY"
		lOK := validQuantity(cField)
	elseif cEvent == "DHL_EDIT_PRCVEN"
		lOK := editPrcVen()
	elseif cEvent == "DHL_FLDMEM_REQUIRED"
		lOk := fieldMemRequired(cField)
	elseif cEvent == "DHL_INFORM_ID"
		lOk := informId()
	elseif cEvent == "DHL_REF_NF"
		aArea := GetArea()
		aAreaSX3 := SX3->(GetArea())
		lOk := .T.
		if type("M->C6_NFORI") == "C"
			prcIdNfRef(aColsAux)
		endif
		RestArea(aAreaSX3)
		RestArea(aArea)
	endif
	
return (lOK)

/*
** EXIST_ID
*/
static function validLine(cField)
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cID		:= GdFieldGet(cField, n)
	local cWhere	:= getQuery(cID)
	local nDocType	:= if(FunName() == "MATA103", 2, 1)
	local lRet		:= .t.
	
	if !empty(alltrim(cID))
		oSql:newAlias(cWhere)
		if oSql:hasRecords()
			if nDocType == DHL_NF_ENTRADA
//				if oSql:getValue("Z3_SITUACA") == DHL_ID_SITUACAO_NORMAL .and. oSql:getValue("Z3_TPMOV") == 'S'
//					lRet := .f.
//					Help("" ,"", 'ZZID')
//				endif
			elseif nDocType == DHL_NF_SAIDA
				//Usar essa validação e verificar quando depositante, filtrar com cliente e loja.
				if (oSql:getValue("Z3_SITUACA") == DHL_ID_SITUACAO_NORMAL .and. oSql:getValue("Z3_TPMOV") == 'E') .or.;
					(oSql:getValue("Z3_SITUACA") == DHL_ID_SITUACAO_EXCLUIDO .and. !oSql:getValue("Z3_TPMOV") == 'E')
					lRet := .f.
					Help("" ,"", 'ZZID')
				endif
			endif
		endif
	endif
	
return (lRet)

/*
** Query
*/
static function getQuery(cID)
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cQuery 	:= ""
	local cEntity	:= "" 
	local cUnit		:= ""
	local lDepos	:= ""
	
	//TODO Thiago Alterar Oracle
	if (FunName() == "MATA103" .or. isincallstack("MATA103"))
		cQuery += " SELECT * FROM ( "
		//		cQuery += " SELECT DISTINCT TOP 1 D1_ZZID, Z3_SEQUEN, Z3_TPMOV, Z3_SITUACA" +CRLF
		cQuery += " SELECT DISTINCT D1_ZZID, Z3_SEQUEN, Z3_TPMOV, Z3_SITUACA" +CRLF
		cQuery += " FROM %SD1.SQLNAME%" +CRLF
		cQuery += " INNER JOIN %SF1.SQLNAME% ON" +CRLF
		cQuery += "		D1_FILIAL 	= F1_FILIAL AND" +CRLF
		cQuery += "   	D1_DOC 		= F1_DOC AND" +CRLF
		cQuery += "   	D1_SERIE 	= F1_SERIE AND" +CRLF
		cQuery += "   	D1_FORNECE 	= F1_FORNECE AND" +CRLF
		cQuery += "  	D1_LOJA 	= F1_LOJA AND" +CRLF
		cQuery += "  	F1_STATUS 	= '"+criavar("F1_STATUS", .F.)+"' AND" +CRLF
		cQuery += "  	%SF1.NOTDEL% "  +CRLF
		cQuery += " INNER JOIN %SZ3.SQLNAME% ON " +CRLF
		cQuery += " 	D1_FILIAL 	= Z3_FILIAL AND " +CRLF
		cQuery += " 	D1_ZZID 	= Z3_ID AND " +CRLF
		cQuery += "  	%SZ3.NOTDEL% "  +CRLF
		cQuery += " WHERE" +CRLF
		cQuery += "		D1_FILIAL 	= '%SD1.FILIAL%' AND" +CRLF
		cQuery += "  	D1_ZZID = '"+cID+"' AND" +CRLF
		cQuery += "  	%SD1.NOTDEL% " +CRLF
		cQuery += " ORDER BY 2 DESC " +CRLF
		cQuery += " ) WHERE ROWNUM = 1" +CRLF
		
	else
		cEntity := M->C5_CLIENT
		cUnit	:= M->C5_LOJACLI
		if M->C5_TIPO $ 'B|D|'
			lDepos	:= oSql:getFieldValue("SA2", "A2_ZZDEPOS", " %SA2.XFILIAL% AND A2_COD = '" + cEntity + "' "+; 
												"AND A2_LOJA = '" + cUnit + "' ") $ 'S'
		else
			lDepos  := oSql:getFieldValue("SA1", "A1_ZZDEPOS", " %SA1.XFILIAL% AND A1_COD = '"+cEntity+"' AND A1_LOJA = '"+cUnit+"' ") $ 'S'
		endif
													
		cQuery += " SELECT * FROM ( "
		cQuery += " SELECT DISTINCT C6_ZZID, Z3_SEQUEN, Z3_TPMOV, Z3_SITUACA" +CRLF
		cQuery += " FROM %SC6.SQLNAME%" +CRLF
		cQuery += " INNER JOIN %SZ3.SQLNAME% ON " +CRLF
		cQuery += " 	C6_FILIAL 	= Z3_FILIAL AND " +CRLF
		cQuery += " 	C6_ZZID 	= Z3_ID AND " +CRLF
		cQuery += "  	%SZ3.NOTDEL% "  +CRLF
		cQuery += " WHERE" +CRLF
		cQuery += "		C6_FILIAL 	= '%SC6.FILIAL%' AND" +CRLF
		cQuery += "  	C6_ZZID 	= '"+cID+"' AND" +CRLF
		cQuery += "  	C6_NOTA 	= '"+criavar("C6_NOTA", .F.)+"' AND" +CRLF
		cQuery += "  	C6_SERIE 	= '"+criavar("C6_SERIE", .F.)+"' AND" +CRLF
		cQuery += "  	C6_NUM	 	<> '"+M->C5_NUM+"' AND" +CRLF
		if lDepos
			cQuery += "  	C6_CLI	 	= '"+cEntity+"' AND" +CRLF
			cQuery += "  	C6_LOJA 	= '"+cUnit+"' AND" +CRLF
		endif
		cQuery += "  	%SC6.NOTDEL% " +CRLF
		cQuery += " ORDER BY 2 DESC " +CRLF
		cQuery += " ) WHERE ROWNUM = 1" +CRLF
	endif
	
return (cQuery)


/*
** Valida conteudo duplicado de um campo no acols - VLD_DUPLIC_LINE
*/
static function validDupliAcols(cField, aCols)
	local cContents := ""
	local nI		:= 0
	local nLine		:= n
	local lRet		:= .t.
	local lOkAcols	:= !empty(aCols)
	
	if !empty(cField)
		if !gdDeleted(nLine,,aCols) .and. lOkAcols
			cContents := gdFieldGet(cField, nLine,,,aCols)
		endif
	endif
	
	if !empty(cContents)
		for nI:=1 to len(aCols)
			if !gdDeleted(nI,,aCols)
				if (upper(alltrim(gdFieldGet(cField, nI,,,aCols))) == upper(alltrim(cContents))) .and. nI != nLine
					lRet := .f.
					Help("" ,"", 'ZID2')
					exit
				endif
			endif
		next nI
	endif
	
return (lRet)


/*
** Validação de campo obrigatório. - FIELD_REQUIRED
*/
static function fieldRequired(cField, aCols)
	local lRet
	local nLine    := n
	local aAreaSX3 := SX3->(GetArea())
	
	if !gdDeleted(n,,aCols)
		lRet := !empty(gdFieldGet(cField, nLine,,, aCols))
		if !lRet
			Help( ,, 'OBRIGA',, 'O preenchimento do campo '+alltrim(Posicione("SX3", 2, cField, "X3Titulo()" ))+' é obrigatório', 1, 0 )
		endif
	else
		lRet := .t.
	endif
	
	RestArea(aAreaSX3)
	
return(lRet)

/*
** Valida quantidade de um campo aCols - SPL - VLD_QUANTITY
*/
static function validQuantity(cField)
	local lRet		:= .t.
	local lEntrada	:= "D1_" $ cField
	local nLine 	:= n
	local aAreaSX3 	:= SX3->(GetArea())
	
	//TODO THIAGO HABILITAR VALIDAÇÃO
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		
		if !empty(cField)
			if tamsx3(cField)[3] == "N"
				if lEntrada
					lRet := (&("M->"+cField) == 1)
				else
					lRet := (gdFieldGet(cField, nLine) == 1)
				endif
			else
				Help( ,, 'VLDQTD',, 'O campo informado para validação não é do tipo numérico', 1, 0 )
			endif
		endif
		
		if !lRet
			Help( ,, 'VLDQTD',, 'Não é permitido informar quantidade diferente de 1.', 1, 0 )
		endif
		
	endif
	
	RestArea(aAreaSX3)
	
return(lRet)


/*
** Mensagem de confirmação para usuário campo C6_PRCVEN
*/
static function editPrcVen()
	local lRet := .t.
	
	//TODO THIAGO VALIDAR SPL
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		lRet := MsgYesNo("Deseja realmente alterar o Prç. Unitário? A alteração do Prç. Unitário causará diferenças no inventário.")
	endif
	
return(lRet)


/*
** Campo obrigatório que esta na memória
*/
static function fieldMemRequired(cField)
	local lRet	   := .t.
	local aAreaSX3 := SX3->(GetArea())
	
	//TODO THIAGO VALIDAR SPL
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		lRet := !empty(&("M->"+cField))
		if !lRet
			Help( ,, 'OBRIGA',, 'O preenchimento do campo '+alltrim(Posicione("SX3", 2, cField, "X3Titulo()" ))+' é obrigatório', 1, 0 )
		endif
	endif
	
	RestArea(aAreaSX3)
return(lRet)


/*
** Informar na exclusão do documento a utilização do ID
*/
static function informId()
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	local cIn		:= ""
	local cMsg		:= ""
	local cFornec	:= SF1->F1_FORNECE
	local cLojaFor	:= SF1->F1_LOJA
	
	oSql:newAlias("SELECT * FROM %SD1.SQLNAME% "+; 
				" WHERE %SD1.XFILIAL% AND %SD1.NOTDEL% AND D1_DOC = '"+SF1->F1_DOC+"' AND D1_SERIE = '"+SF1->F1_SERIE+"' "+;
				" AND D1_FORNECE = '"+SF1->F1_FORNECE+"' AND D1_LOJA = '"+SF1->F1_LOJA+"' ")				
	
	while oSql:notIsEof()
		cIn += "'"+oSql:getValue("D1_ZZID")+"',"		
		oSql:skip()
	end
	oSql:close()
	
	cIn := substr(cIn, 1, len(cIn)-1)
	if !empty(cIn)
			oSql:newAlias(getSqlId(cIn, cFornec, cLojaFor))
			
			if oSql:hasRecords() 
				while oSql:notIsEof()
					cMsg += alltrim(oSql:getValue("C6_NUM"))+","
					oSql:skip()
				end
			else 
				return .t.
			endif
			oSql:close()
		
		Aviso("ATENÇÃO!","O(s) Pedido(s) de Venda "+cMsg+" esta(ão) em aberto e possui(em) itens não faturados com"+;
		  " o(s) ID(s) dessa Nota Fiscal. Ao excluir este Documento necessário atualizar o(s) pedido(s) antes"+;
		  " de ser faturado.",{"OK"})
	endif
	
return .t.


/*
** Query para retornar pedidos de venda
*/
static function getSqlId(cIn, cFornec, cLojaFor)
	local cQuery := ""
	
	cQuery += " SELECT C6_NUM, SC6.* FROM %SC6.SQLNAME% "+CRLF
	cQuery += " INNER JOIN SC5100 SC5 ON                "+CRLF
	cQuery += " 	%SC5.NOTDEL%                        "+CRLF
	cQuery += " 	AND C6_FILIAL 	= C6_FILIAL         "+CRLF
	cQuery += " 	AND C5_NUM 		= C6_NUM            "+CRLF
	cQuery += " 	AND C5_TIPO 	= 'N'               "+CRLF
	cQuery += " WHERE                                   "+CRLF
	cQuery += " 	%SC6.XFILIAL%                       "+CRLF
	cQuery += " 	AND %SC6.NOTDEL%                    "+CRLF
	cQuery += " 	AND C6_ZZID 	IN("+cIn+")         "+CRLF
	cQuery += " 	AND C6_NOTA 	= '"+CriaVar("C6_NOTA", .f.)+"' "+CRLF
	cQuery += " 	AND C6_SERIE 	= '"+CriaVar("C6_SERIE", .f.)+"' "+CRLF
	cQuery += " 	AND C6_CLI || C6_LOJA  <> '"+cFornec+cLojaFor+"'"+CRLF
	
return (cQuery)

/*
** Busca ID para NF de referência para NFs de complementos
*/
static function prcIdNfRef(aCols)
	local cNF	 := GdFieldGet("C6_NFORI", n)
	local cSerie := GdFieldGet("C6_SERIORI", n)
	local cItem  := GdFieldGet("C6_ITEMORI", n)
	local cCliFor:= M->C5_CLIENTE
	local cLoja	 := M->C5_LOJACLI
	local lCompl := M->C5_TIPO $ "I|C|P|"
	local nPosId := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ZZID"})
	
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		if lCompl
			aCols[n ,nPosId] := retIdRef(cNF, cSerie, cItem, cCliFor, cLoja)
		endif
	endif
return


/*
** Query para retornar pedidos de venda
*/
static function retIdRef(cNF, cSerie, cItem, cCliFor, cLoja)
	local cQuery := ""
	local cId	 := ""
	local oSql 	 := IpSqlObject():newIpSqlObject()
	
	cQuery += " SELECT D2_ZZID FROM %SD2.SQLNAME% 			"+CRLF
	cQuery += " WHERE                                   	"+CRLF
	cQuery += " 	%SD2.XFILIAL%                       	"+CRLF
	cQuery += " 	AND %SD2.NOTDEL%                    	"+CRLF
	cQuery += " 	AND D2_DOC 		= '" + cNF + "' 		"+CRLF
	cQuery += " 	AND D2_SERIE 	= '" + cSerie + "' 		"+CRLF
	cQuery += " 	AND D2_ITEM 	= '" + cItem + "'		"+CRLF
	cQuery += " 	AND D2_CLIENTE 	= '" + cCliFor + "' 	"+CRLF
	cQuery += " 	AND D2_LOJA 	= '" + cLoja + "' 	"+CRLF
	
	oSql:newAlias(cQuery)
	
	if oSql:hasRecords()
		cId := oSql:getValue("D2_ZZID")
	endif
	
	oSql:close()
	
return (cId)