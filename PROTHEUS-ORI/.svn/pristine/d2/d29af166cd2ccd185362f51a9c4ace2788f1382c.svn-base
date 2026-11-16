#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT103TRV
PE que realiza o lock das tabelas SA1/SA2/SB2 por demanda.
@author Diogo Mesquita
@since 27/08/2019
@version 12.1.23
@return array, lista lógica para ligar ou desligar a trava nas tabelas SA1, SA2 e SB2

@type function
/*/
user function MT103TRV()

	local cFornece	:= ParamIXB[1] // Codigo do Fornecedor/Cliente 
	local cLoja 	:= ParamIXB[2] // Codigo da Loja 
	local cTipo 	:= ParamIXB[3] // C = Cliente (SA1) / F = Fornecedor (SA2) 
	local aRet 		:= Array(4) 
	local lTravaSA1 := .F. // Liga (.t.) / Desliga (.f.) trava da tabela SA1 
	local lTravaSA2 := .F. // Liga (.t.) / Desliga (.f.) trava da tabela SA2 
	local lTravaSB2 := .F. // Liga (.t.) / Desliga (.f.) trava da tabela SB2
	local lAtuAcumu	:= .T. // Atualiza os Acumulados somente no final da gravação dos itens da NFE
	
	aRet[1] := lTravaSA1
	aRet[2] := lTravaSA2
	aRet[3] := lTravaSB2
	aRet[4] := lAtuAcumu

	conout("[MT103TRV] - Realiza o lock das tabelas SA1/SA2/SB2 por demanda.")

return(aRet)
	