#Include 'Protheus.ch'

/*/{Protheus.doc} MT140LOK
(Altera a validação da linha retornando verdadeiro ou falso). Pré nota
@author Gustavo Luiz
@since 30/09/2016
@version 1.0
@return ${return}, ${return_description}
/*/
User Function MT140LOK()

	Local lStatus := .T.	
	
	If CFORMUL == "S" .AND. CTIPO == "D"
	
		lStatus := u_vldLinha()
		
	EndIf	
	
Return lStatus

