#include "totvs.ch"
#include "dhl.ch"


/*/{Protheus.doc} MA103BUT

Inclusao de Botao na Barra de Ferramentas da tela de inclusao da Nota de Entrada
	
@author Winston Dellano de Castro
@since 07/01/2015
/*/
user function MA103BUT()
	
	local aRet := {}
	
	aAdd(aRet,{"CONTAINR",{ || showMessages() },"Dados Adicionais"})
		
return aRet


/**
* Mostra os dados adcionais da Nota Fiscal
**/
static function showMessages()

	local oTMsg := FswTemplMsg():newTemplMsg("E",SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,"SZZ")
	local lGravado	:= .t.
	
	oTMsg:addField("F1_VOLUME1",SF1->F1_VOLUME1)
	oTMsg:addField("F1_ESPECI1",SF1->F1_ESPECI1)
	oTMsg:addField("F1_PESOL"  ,SF1->F1_PESOL  )
	oTMsg:addField("F1_PBRUTO" ,SF1->F1_PBRUTO )
	oTMsg:addField("F1_TRANSP" ,SF1->F1_TRANSP )
	oTMsg:addField("F1_PLACA"  ,SF1->F1_PLACA  )
	oTMsg:addField("F1_ZZMARCA",SF1->F1_ZZMARCA)
	
	oTMsg:intDadosNF(lGravado)

return