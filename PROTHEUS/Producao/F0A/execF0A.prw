#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'topconn.ch'


/*/{Protheus.doc} execF0A
Elimina os registros duplicados da F0A
@author gusluiz_supplier
@since 01/07/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function execF0A()

	local aRegGrupDuplic := aGetRegGrupDuplic()
	local nI 		 := 0
	local nJ		 := 0

	for nI := 1 to len(aRegGrupDuplic)
		
		conout("Processando " + cValToChar(nI) + " de " + cValtoChar(len(aRegGrupDuplic)))
		processDuplic(aRegGrupDuplic[nI])

	next nI

return

/**
* processDuplic
**/
static function processDuplic(aRegGrupDuplic)

	local nI 		:= 0
	local cFilF0A 	:= aRegGrupDuplic[1]
	local cTpMov    := aRegGrupDuplic[2]
	local cSerie	:= aRegGrupDuplic[3]
	local cDoc		:= aRegGrupDuplic[4]
	local cCliFor	:= aRegGrupDuplic[5]
	local cLoja		:= aRegGrupDuplic[6]
	local cItem		:= aRegGrupDuplic[7]
	local cCod		:= aRegGrupDuplic[8]
	local nQtdDuplic:= aRegGrupDuplic[9]
	local nRecno	:= -1	
	local aArea		:= getArea()
	local aAreaF0A	:= F0A->(getARea())
	local nControl  := 1
	local cAlias	:= getNextAlias()
	local aRecnos	:= {}
	local nCount	:= 0

	cQuery := " SELECT F0A.F0A_FILIAL, F0A.F0A_TPMOV, F0A.F0A_SERIE, F0A.F0A_DOC, F0A.F0A_CLIFOR, F0A.F0A_LOJA, F0A.F0A_ITEM, F0A.F0A_COD, F0A.R_E_C_N_O_ RECNO" 	+ CRLF
	cQuery += " FROM " + retSqlName("F0A") + " F0A " 																												+ CRLF
	cQuery += " WHERE 1 = 1 " 																																		+ CRLF
	cQuery += "   AND F0A.D_E_L_E_T_ =  ' ' " 																														+ CRLF
	cQuery += "   AND F0A.F0A_FILIAL =  '"+cFilF0A+"' " 																											+ CRLF
	cQuery += "   AND F0A.F0A_TPMOV =  '"+cTpMov+"' " 																												+ CRLF
	cQuery += "   AND F0A.F0A_SERIE =  '"+cSerie+"' " 																												+ CRLF
	cQuery += "   AND F0A.F0A_DOC =  '"+cDoc+"' " 																													+ CRLF
	cQuery += "   AND F0A.F0A_CLIFOR =  '"+cCliFor+"' " 																											+ CRLF
	cQuery += "   AND F0A.F0A_LOJA =  '"+cLoja+"' " 																												+ CRLF
	cQuery += "   AND F0A.F0A_ITEM =  '"+cItem+"' " 																												+ CRLF
	cQuery += "   AND F0A.F0A_COD =  '"+cCod+"' " 																													+ CRLF

	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)

	COUNT to nCount

	if nCount > 0
		(cAlias)->(dbGoTop())
		while (cAlias)->(!eof())
			aAdd(aRecnos, (cAlias)->RECNO)
			(cAlias)->(dbSkip())
		endDo
		(cAlias)->(dbCloseArea())	

		F0A->(dbSetOrder(1))

		for nI := 1 to len(aRecnos)
			if nControl == 1
				nControl++				
				loop
			else
				nRecno := aRecnos[nI] 
				F0A->(dbGoTo(nRecno))
				if F0A->(recLock("F0A", .F.))				
					F0A->(dbDelete())
					F0A->(msUnLock())
				endIf				
			endIf	
		next nI
	endIf
	restArea(aAreaF0A)
	restArea(aArea)

return

/**
** Obtém os registros duplicados agrupados
**/
static function aGetRegGrupDuplic()

	local cQuery 		:= ""
	local cAlias 		:= getNextAlias()
	local nQtdRegs		:= 0
	local aRegDuplicado := {}
	local nI			:= 0

	cQuery := " SELECT F0A.F0A_FILIAL, F0A.F0A_TPMOV, F0A.F0A_SERIE, F0A.F0A_DOC, F0A.F0A_CLIFOR, F0A.F0A_LOJA, F0A.F0A_ITEM, F0A.F0A_COD, COUNT(*) QTD_DUPL " 	+ CRLF
	cQuery += " FROM " + retSqlName("F0A") + " F0A " 																											+ CRLF
	cQuery += " WHERE 1 = 1 " 																																	+ CRLF
	cQuery += " AND F0A.D_E_L_E_T_ =  ' ' " 																													+ CRLF
	cQuery += " GROUP BY F0A.F0A_FILIAL, F0A.F0A_TPMOV, F0A.F0A_SERIE, F0A.F0A_DOC, F0A.F0A_CLIFOR, F0A.F0A_LOJA, F0A.F0A_ITEM, F0A.F0A_COD " 					+ CRLF
	cQuery += " HAVING COUNT(*) > 1 " 																														    + CRLF
	cQuery += " ORDER BY COUNT(*) DESC " 																														+ CRLF

	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)      

	if (cAlias)->(!eof())    

		while (cAlias)->(!eof())

			aAdd(aRegDuplicado, {(cAlias)->F0A_FILIAL, (cAlias)->F0A_TPMOV, (cAlias)->F0A_SERIE, (cAlias)->F0A_DOC, (cAlias)->F0A_CLIFOR, (cAlias)->F0A_LOJA, (cAlias)->F0A_ITEM, (cAlias)->F0A_COD, (cALias)->QTD_DUPL, -1})

			(cAlias)->(dbSkip())

		endDo

		(cAlias)->(dbCloseArea())

	endIf

return aRegDuplicado