#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} M460ORD
Este ponto de entrada é executado após a montagem da chave de processamento da tabela de itens de pedido liberados ( SC9 ).
@author Thiago Meschiatti
@since 03/08/2016
@version undefined

@type function
/*/
User Function M460ORD()
	local cChave := PARAMIXB
	
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_MUL)
		cChave := "C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO"
	endif

Return (cChave)

