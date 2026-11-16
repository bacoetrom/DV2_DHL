#include 'protheus.ch'

/*/{Protheus.doc} M410ICM

Este ponto de entrada retorna o valor do ICMS para ser demonstrado na planilha financeira do pedido de vendas.
Para realizar todo o processo corretamente deve utilizar em conjunto com o ponto de entrada M460ICM com o mesmo tratamento do ponto M410ICM. 
Variaveis disponiveis para uso ou alteração:
_BASEICM, _ALIQICM, _QUANTIDADE, _VALICM, _FRETE, _VALICMFRETE e _DESCONTO

@author Diogo Mesquita
@since 14/05/2020
@version undefined
@type function
@return Nenhum. Variáveis serão alteradas diretamente pelo RdMake.
/*/
user Function M410ICM()

	local nBaseICMS := _BASEICM
	local nAliqICMS := _ALIQICM
	local nValICMS  := _VALICM
	
	U_SetIcmsToNfRet( "M410ICM", @nBaseICMS, @nAliqICMS, @nValICMS )
	
	_BASEICM := nBaseICMS
	_ALIQICM := nAliqICMS
	_VALICM  := nValICMS

return

