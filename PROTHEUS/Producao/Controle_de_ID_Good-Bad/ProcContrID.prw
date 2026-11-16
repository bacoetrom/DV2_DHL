#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} ProcContrID

Processa inclusão de Id ou sequencia para o Id.
	
@author Thiago Meschiatti
@since 07/11/2014

@param nOpt, numérico, Opção selecionada pelo o usuário.
/*/
User Function ProcContrID(nOpt, lConfirm)
	local oIdManager := DHLIdManager():newDHLIdManager()
	
	if lConfirm
		if (nOpt == DHL_OPC_ALTERACAO .or. nOpt == DHL_OPC_INCLUSAO).and. !Empty(SD1->D1_TES)
			oIdManager:inflowInvoice(DHL_INCLUSAO)
		endif
	endif
		
Return ()

