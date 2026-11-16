#include "totvs.ch"
#include "dhl.ch"


/*/{Protheus.doc} MA920BUT

Ponto de entrada na pesquisa da NF de saidas para visualização da NF.
	
@author Winston Dellano de Castro
@since 07/01/2015
/*/
user function MA920BUT()
	
	local aRet := {}
	
	aAdd(aRet,{"CONTAINR",{ || showMessages() },"Dados Adicionais","Dados Adicionais"})
	
return aRet


/**
* Mostra os dados adcionais da Nota Fiscal
**/
static function showMessages()

	local oTMsg 	:= FswTemplMsg():newTemplMsg("S",SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,"SZZ")
	local lGravado	:= .t.
	
	oTMsg:addField("F2_ESPECI1",SF2->F2_ESPECI1) 
	oTMsg:addField("F2_VOLUME1",SF2->F2_VOLUME1)
	oTMsg:addField("F2_PLIQUI" ,SF2->F2_PLIQUI )
	oTMsg:addField("F2_PBRUTO" ,SF2->F2_PBRUTO )
	oTMsg:addField("F2_TRANSP" ,SF2->F2_TRANSP )
	oTMsg:addField("F2_REDESP" ,SF2->F2_REDESP )
	
	oTMsg:intDadosNF(lGravado)

return