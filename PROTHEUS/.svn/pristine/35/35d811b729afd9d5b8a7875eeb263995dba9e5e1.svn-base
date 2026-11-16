#Include 'Protheus.ch'

/*/{Protheus.doc} ClassCutover

Realiza o ajuste e a classificação das Pré Notas
	
@author Thiago Meschiatti
@since 20/02/2015

/*/
User Function atuRegSZ3()
	local lExeFun		
	local aArrSay 		:= {}
	local aArrBut 		:= {}
	
	aadd(aArrSay, 'Executar atualizações!')
	 
	aadd(aArrBut, {1, .T., {|| lExeFun := .T., FechaBatch()}})
	aadd(aArrBut, {2, .T., {|| lExeFun := .F., FechaBatch()}})
	 
	FormBatch('Atualização SZ3', aArrSay, aArrBut)
	
	if lExeFun
		Processa( {|| process() }, "Aguarde...", "Processando...",.F.)
	endif
return

static function process()
	local oSql		:= IpSqlObject():newIpSqlObject()
	local oSqlUpd	:= IpSqlObject():newIpSqlObject()
	local lOk		:= .f. 
	
	oSql:newAlias(retSql())
	ProcRegua(oSql:count())
	oSql:goTop()
	
	begin transaction 
		while oSql:notIsEof()
			IncProc("Processando...")			
			if (oSql:getValue("EMISSAO_SAIDA") < oSql:getValue("DT_MOV_SZ3")) .and. (oSql:getValue("DT_MOV_SZ3") != oSql:getValue("DT_MOV_ENTRADA"))
				lRet := oSql:update("SZ3", "Z3_DTMOV = '"+oSql:getValue("DT_MOV_ENTRADA")+"' ", "R_E_C_N_O_ = "+cValtoChar(oSql:getValue("RECSZ3"))+" ")
				if !lRet
					DisarmTransaction()
					alert("ERRO NA ATUALIZAÇÃO DE CAMPO!")
					exit
				endif
			endif
			oSql:skip()
		end
	end transaction

Return

static function retSql()
	local cQuery	:= "" 

	cQuery += " SELECT 	SZ3.R_E_C_N_O_ RECSZ3,SZ3.Z3_DTMOV DT_MOV_SZ3, SZ3.Z3_DOC, SZ3.Z3_SERIE, SZ3.Z3_ITEM, "+CRLF
	cQuery += " 		SD1.D1_DTDIGIT DT_MOV_ENTRADA, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_ITEM, SZ3F2.Z3_DTMOV EMISSAO_SAIDA "+CRLF
	cQuery += " FROM "+RetSqlName("SD1")+" SD1 "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("SF1")+" SF1 ON "+CRLF  
	cQuery += " 	SF1.D_E_L_E_T_ 	= ' ' "+CRLF
	cQuery += " 	AND D1_FILIAL 	= F1_FILIAL "+CRLF
	cQuery += " 	AND D1_DOC 		= F1_DOC "+CRLF
	cQuery += " 	AND D1_SERIE 	= F1_SERIE "+CRLF
	cQuery += " 	AND D1_FORNECE 	= F1_FORNECE "+CRLF
	cQuery += " 	AND D1_LOJA 	= F1_LOJA "+CRLF
	cQuery += " 	AND F1_ZZCUTOV 	= 'S' "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("SZ3")+" SZ3 ON "+CRLF
	cQuery += " 	SZ3.D_E_L_E_T_ 	= ' ' "+CRLF
	cQuery += " 	AND D1_ZZID 	= Z3_ID "+CRLF
	cQuery += " 	AND Z3_TPMOV 	= 'E' "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("SD2")+" SD2 ON  "+CRLF
	cQuery += " 	SD2.D_E_L_E_T_ 	= ' ' "+CRLF
	cQuery += " 	AND D1_FILIAL	= D2_FILIAL "+CRLF
	cQuery += " 	AND D1_DOC 		= D2_NFORI "+CRLF
	cQuery += " 	AND D1_SERIE 	= D2_SERIORI "+CRLF
    cQuery += "     AND D1_ITEM 	= D2_ITEMORI "+CRLF
    cQuery += " INNER JOIN "+RetSqlName("SZ3")+" SZ3F2 ON "+CRLF
    cQuery += "     D2_DOC 			= SZ3F2.Z3_DOC "+CRLF    cQuery += "     AND D2_SERIE 	= SZ3F2.Z3_SERIE "+CRLF    cQuery += "     AND D2_ITEM 	= SZ3F2.Z3_ITEM "+CRLF
    cQuery += "     AND SZ3F2.Z3_SITUACA = 'N' "+CRLF    cQuery += " WHERE "+CRLF    cQuery += "     SD1.D_E_L_E_T_ 	= ' ' "+CRLF    cQuery += "     AND D1_FILIAL 	= '"+xFilial("SD1")+"' "+CRLF    cQuery += "     AND SZ3F2.Z3_DTMOV < SZ3.Z3_DTMOV "+CRLF
    cQuery += " ORDER BY 3,4,5return (cQuery) 