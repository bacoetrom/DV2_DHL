#include 'totvs.ch'

/*/{Protheus.doc} IPVLDCNPJ
Ponto de entrada para validações adicionais do CNPJ do destinatário conforme necessidade.
@author Diogo Mesquita
@since 17/06/2019
@version 1.0
@return Logical, Retorna se o CNPJ do destinatário é válido

@type function
/*/
User Function IPVLDCNPJ()
	local cCnpjAux	:= PARAMIXB[1]
	local cCNPJDep 	:= SuperGetMV("ZZ_CNPJDEP",,"") //Acrescentado por Edson Deluca - Fit GEstão - 08/08/18
	local lRet		:= .t.
	
	If !(AllTrim(cCnpjAux) $ AllTrim(cCNPJDep))
		lRet := .f.
	EndIf
	
Return lRet

