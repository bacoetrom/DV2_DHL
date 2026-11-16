#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} M410PCDV

Preenchimento do gride no retorno da NF de saída
	
@author Thiago Meschiatti
@since 17/11/2014

/*/
User Function M410PCDV()
	local cAliasSd1 := PARAMIXB[1]
	
	//TODO THIAGO VALIDAR SPL
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		u_procRetNF(,cAliasSd1)
	endif

Return

