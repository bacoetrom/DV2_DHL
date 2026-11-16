#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} M461TRV
PE para liberação da trava dos registros da tabela SB2.
@author Diogo Mesquita
@since 27/08/2019
@version 12.1.23
@return lógico, ativa (.t.) ou desativa (.f.) a trava dos registros da tabela SB2

@type function
/*/
user function M461TRV()
	
	local lRet	:= .F. //Desativa a trava dos registros
	
	conout("[M461TRV] - Libera a trava dos registros da tabela SB2.")
	
return(lRet)