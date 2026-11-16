#include 'protheus.ch'

/*/{Protheus.doc} M460ICM

P.E. para recalculo do ICMS. Variaveis disponiveis para uso ou alteracao:
_ALIQICM, _QUANTIDADE, _BASEICM, _VALICM, _FRETE, _VALICMFRETE, _DESCONTO,
_VALRATICM, _ACRESFIN

@author Diogo Mesquita
@since 14/05/2020
@version undefined
@type function
@return Nenhum. Variáveis serão alteradas diretamente pelo RdMake.
/*/
user Function M460ICM()

	local nBaseICMS := _BASEICM
	local nAliqICMS := _ALIQICM
	local nValICMS  := _VALICM
	
	U_SetIcmsToNfRet( "M460ICM", @nBaseICMS, @nAliqICMS, @nValICMS )
	
	_BASEICM := nBaseICMS
	_ALIQICM := nAliqICMS
	_VALICM  := nValICMS

return
