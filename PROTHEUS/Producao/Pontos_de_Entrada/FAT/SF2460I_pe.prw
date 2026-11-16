#Include 'Protheus.ch'
#include "dhl.ch"

/*/{Protheus.doc} SF2460I

Ponto de entrada localizado após a atualização das tabelas referentes à nota fiscal (SF2/SD2), mas antes da contabilização. 
Este ponto de entrada está dentro da transação na gravação das tabelas do documento
	
@author Thiago Meschiatti
@since 30/05/2016

/*/
user function SF2460I()
	if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		u_GrvCpsNF()
	elseIf FWUnitBusiness() == DHL_BUSINESSUNIT_DI2
		u_Di2GrCpNFS()
	else 
		u_GrvPedToNf()
	endif
return
