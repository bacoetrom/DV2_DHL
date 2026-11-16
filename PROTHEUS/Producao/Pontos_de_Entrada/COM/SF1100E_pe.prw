#Include "Protheus.ch"
#Include "dhl.ch"


/*/{Protheus.doc} SF1100E

Ponto de Entrada executado na exclusão da Nota Fiscal.

@author Thiago Meschiatti
@since 30/10/2014

@return lógico Determina se exclui ou não a NF
/*/
User Function SF1100E()
	
	Local lRet   := .T.
	Local oTMsg  := FswTemplMsg():newTemplMsg("E",SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,"SZZ")

	//exclui mensagens da NF
	oTMsg:excMsg()
	
Return(lRet)
