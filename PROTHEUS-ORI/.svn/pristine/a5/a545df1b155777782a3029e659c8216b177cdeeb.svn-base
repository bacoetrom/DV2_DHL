#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"

/*/{Protheus.doc} LogManTst

Função para testes da classe DHLLogManager
	
@author Victor Hugo
@since 14/10/2014
/*/
user function LogManTst()
	
	local oLog  := DHLLogManager():newDHLLogManager()
	
	oLog:start(APP_ORACLE_AR, DHL_EXPORTACAO, "oracle_error.xml")
	oLog:warn("Atenção", "Teste ...")							
		
return