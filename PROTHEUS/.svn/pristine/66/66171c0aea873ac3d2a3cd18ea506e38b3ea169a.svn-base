#Include 'Protheus.ch'

/*/{Protheus.doc} ValidCob

Validação de a NF de cobertura pode ser excluída
	
@author Renato Castro
@since 10/11/2014

@param lExclusao, Logico, indica se é estorno

@return Lógico Permite ou não a exclusão
/*/
User Function ValidCob()

	local lRet := .T.
	local oSql := IpSqlObject():newIpSqlObject()
	local oSql2 := IpSqlObject():newIpSqlObject()
	local cUser := GetMV("ZZ_USREXC")
	
	public __lOk := .T.
	
	//Elmo, em 31/07/2023 - Processo sendo cexecutado - INICIO
	If FWIsInCallStack("u_ImpMsaNfe") .or. FWIsInCallStack("u_TESTEEFT")
		Return(lRet)
	Endif
	//Elmo, em 31/07/2023 - Processo sendo cexecutado - FINAL

	oSql:newTable("SD1", "D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, D1_CF", "D1_FILIAL='"+SF1->F1_FILIAL+"' AND D1_DOC='"+SF1->F1_DOC+;
		"' AND D1_SERIE='"+SF1->F1_SERIE+"' AND D1_FORNECE='"+SF1->F1_FORNECE+"' AND D1_LOJA='"+SF1->F1_LOJA+"'")
		
	while oSql:notIsEof()
		//if AllTrim(oSql:getValue("D1_CF")) $ getMV("ZZ_CFCOB")
			if oSql2:exists("SZ4", "Z4_FILIAL='"+oSql:getValue("D1_FILIAL")+"' AND Z4_DOC='"+oSql:getValue("D1_DOC")+;
					"' AND Z4_SERIE='"+oSql:getValue("D1_SERIE")+"' AND Z4_CLIFOR='"+oSql:getValue("D1_FORNECE")+;
					"' AND Z4_LOJA='"+oSql:getValue("D1_LOJA")+"' AND Z4_PRODUTO='"+oSql:getValue("D1_COD")+;
					"' AND Z4_ITEM='"+oSql:getValue("D1_ITEM")+"' AND Z4_TIPMOV='1' AND Z4_SALDO = 0 ")
				lRet := .F.
				__lOk := .F.
				MsgAlert("Documento não pode ser excluído/estornado ! Verifique se há vínculo com notas de cobertura de 2ª perna.")
				exit
			elseif oSql2:exists("SZ4", "Z4_FILIAL='"+oSql:getValue("D1_FILIAL")+"' AND Z4_DOC='"+oSql:getValue("D1_DOC")+;
					"' AND Z4_SERIE='"+oSql:getValue("D1_SERIE")+"' AND Z4_CLIFOR='"+oSql:getValue("D1_FORNECE")+;
					"' AND Z4_LOJA='"+oSql:getValue("D1_LOJA")+"' AND Z4_PRODUTO='"+oSql:getValue("D1_COD")+;
					"' AND Z4_ITEM='"+oSql:getValue("D1_ITEM")+"' AND Z4_TIPMOV='1' ")
				if !(__cUserID $ cUser)
					lRet := .F.
					__lOk := .F.
					MsgAlert("Usuário não autorizado a excluir NF´s do processo de cobertura ! Verifique o parametro ZZ_USREXC")
					exit
				endif
			endif
			oSql:skip()
		//endif
	end
		
	
	
	if lRet
		
		while oSql:notIsEof()
			if oSql2:exists("SZ4", "Z4_FILIAL='"+oSql:getValue("D1_FILIAL")+"' AND Z4_DOC='"+oSql:getValue("D1_DOC")+;
					"' AND Z4_SERIE='"+oSql:getValue("D1_SERIE")+"' AND Z4_CLIFOR='"+oSql:getValue("D1_FORNECE")+;
					"' AND Z4_LOJA='"+oSql:getValue("D1_LOJA")+"' AND Z4_PRODUTO='"+oSql:getValue("D1_COD")+;
					"' AND Z4_ITEM='"+oSql:getValue("D1_ITEM")+"' AND Z4_TIPMOV='2' ")
				if !(__cUserID $ cUser)
					lRet := .F.
					__lOk := .F.
					MsgAlert("Usuário não autorizado a excluir NF´s do processo de cobertura ! Verifique o parametro ZZ_USREXC")
					exit
				endif
			endif
			oSql:skip()
		end
	endif
	
	oSql:close()

Return(lRet)
