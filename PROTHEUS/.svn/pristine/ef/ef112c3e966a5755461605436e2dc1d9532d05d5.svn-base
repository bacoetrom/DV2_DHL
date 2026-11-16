#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT410TRV
PE para liberação da trava de registros para as tabelas SA1/SA2/SB2.
@author Diogo Mesquita
@since 27/08/2019
@version 12.1.23
@return array, lista lógica para ligar ou desligar a trava nas tabelas SA1, SA2 e SB2

@type function
/*/
user function MT410TRV()
	
	local cCliForn 	:= ParamIXB[1] // Codigo do Fornecedor/Cliente 
	local cLoja 	:= ParamIXB[2] // Codigo da Loja 
	local cTipo 	:= ParamIXB[3] // C = Cliente (SA1) / F = Fornecedor (SA2) 
	local aRet 		:= Array(3) 
	local lTravaSA1 := .F. // Liga (.t.) / Desliga (.f.) trava da tabela SA1 
	local lTravaSA2 := .F. // Liga (.t.) / Desliga (.f.) trava da tabela SA2 
	local lTravaSB2 := .F. // Liga (.t.) / Desliga (.f.) trava da tabela SB2 
	
	aRet[1] := lTravaSA1 
	aRet[2] := lTravaSA2 
	aRet[3] := lTravaSB2 
		
	conout("[MT410TRV] - Liberação da trava de registros para as tabelas SA1/SA2/SB2.")
	
return(aRet)
