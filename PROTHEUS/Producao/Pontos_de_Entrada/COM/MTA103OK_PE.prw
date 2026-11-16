#Include 'Protheus.ch'

/*/{Protheus.doc} MTA103OK
(Altera a validação da linha retornando verdadeiro ou falso). Documento de entrada.
@author Gustavo Luiz
@since 30/09/2016
@version 1.0
@return ${return}, ${return_description}
/*/
User Function MTA103OK()
	
	Local lStatus := .T.
	
	If CFORMUL == "S" .AND. CTIPO == "D"
	
		lStatus := u_vldLinha()
	
	EndIf
	
Return lStatus

