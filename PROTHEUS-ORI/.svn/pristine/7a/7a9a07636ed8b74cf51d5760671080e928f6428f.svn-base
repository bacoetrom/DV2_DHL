#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} MT103IPC
Atualiza campos customizados no Documento de Entrada
@author Thiago Meschiatti
@since 27/09/2016
@version 1.0

/*/
User Function MT103IPC()
	local nItem := PARAMIXB[1]
	
	if FwUnitBusiness() == DHL_BUSINESSUNIT_DIS
		u_AtuNFCob(nItem)
	endif
	
Return