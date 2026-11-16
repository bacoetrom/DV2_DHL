#include 'totvs.ch'
#include 'dhl.ch'


/*/{Protheus.doc} ClassShipment
Classe para utlização em funções/rotinas relacionadas ao embarque
@type class
@author Thiago Meschiatti
@since 26/12/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
class ClassShipment
	data aOps
	data cSalesOrder
	data lError
	data cMsgErro
	data cIndexSC2
	data cIndexSD3
	data oUtils

	method newClassShipment() CONSTRUCTOR
	method separaOps()
	method retOpsSalesOrd()
	method execAuto250()
	method execAuto650()
	method showError()
	
	method addOps()
	method getOps()
	method cleanOps()
	method setSalesOrder()
	method getSalesOrder()
	method setMsgErro()
	method getMsgErro()
	method setError()
	method hasError()
	method setIndexSC2()
	method getIndexSC2()
	method setIndexSD3()
	method getIndexSD3()

endclass


/*/{Protheus.doc} newClassShipment
Método Construtor

@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@example
(examples)
/*/
method newClassShipment() class ClassShipment
	::oUtils		:= IpUtilsObject():newIpUtilsObject()
	::aOps 			:= {}
	::cSalesOrder	:= ""
	::cMsgErro		:= ""
	::cIndexSC2		:= ""
	::cIndexSD3		:= ""
	::lError		:= .f.
Return


/*/{Protheus.doc} addOps
Método - Adiciona items no atributo aOPs
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method addOps(cOp) class ClassShipment
	aadd(::aOps, cOp)
return


/*/{Protheus.doc} getOps
Metodo - Retorna array de OPs
@type class
@author Thiago Meschiatti
@since 28/12/2016
@return array, Array de OPs
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method getOps() class ClassShipment
return aClone(::aOps)


/*/{Protheus.doc} cleanOps
Metodo - Limpa atributo de OPs
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method cleanOps() class ClassShipment
	::aOps := {}
return


/*/{Protheus.doc} setSalesOrder
Metodo - Seta numero do pedido
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method setSalesOrder(cSalesOrder) class ClassShipment
	::cSalesOrder := cSalesOrder
return 


/*/{Protheus.doc} getSalesOrder
Metodo - Retorna numero do pedido
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@return caracter, numero do pedido de venda
@example
(examples)
@see (links_or_references)
/*/
method getSalesOrder() class ClassShipment
return (::cSalesOrder)


/*/{Protheus.doc} setMsgErro
Metodo - Seta mensagem de erro
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method setMsgErro(cMsgErro) class ClassShipment
	::cMsgErro := cMsgErro
return 


/*/{Protheus.doc} getMsgErro
Metodo - Retorna mensagem de erro 
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@return caracter, mensagem de erro
@example
(examples)
@see (links_or_references)
/*/
method getMsgErro() class ClassShipment
return (::cMsgErro)


/*/{Protheus.doc} setError
Metodo - Seta se possui erro
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method setError(lError) class ClassShipment
	::lError := lError
return 


/*/{Protheus.doc} hasError
Metodo - Verifica se possui erro
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@return logico, se possui erro
@example
(examples)
@see (links_or_references)
/*/
method hasError() class ClassShipment
return (::lError)


/*/{Protheus.doc} setIndexSC2
Metodo - Seta indice SC2
@type class 
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method setIndexSC2(cIndexSC2) class ClassShipment
	::cIndexSC2 := cIndexSC2
return 


/*/{Protheus.doc} getIndexSC2
Metodo - Retorna indice SC2
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@return caracter, string de indice
@example
(examples)
@see (links_or_references)
/*/
method getIndexSC2() class ClassShipment
return (::cIndexSC2)


/*/{Protheus.doc} setIndexSD3
Metodo - Seta indice SD3
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method setIndexSD3(cIndexSD3) class ClassShipment
	::cIndexSD3 := cIndexSD3
return 


/*/{Protheus.doc} getIndexSD3
Metodo - Retorna indice SD3
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@return caracter, string de indice
@example
(examples)
@see (links_or_references)
/*/
method getIndexSD3() class ClassShipment
return (::cIndexSD3)


/*/{Protheus.doc} retOpsSalesOrd
Metodo - Retorna Ordens de Producao amarradas no pedido pelo campo C6_ZZOP
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@return caracter, string de OPs
@example
(examples)
@see (links_or_references)
/*/
method retOpsSalesOrd() class ClassShipment
	local cRet	 := ""
	local oSql	 := IpSqlObject():newIpSqlObject()
	
	oSql:newTable("SC6", "C6_ZZOP", "%SC6.XFILIAL% AND C6_NUM = '" + ::getSalesOrder() + " '")
	
	while oSql:notIsEof()
		cRet += alltrim(oSql:getValue("C6_ZZOP"))
		
		oSql:skip()
	end
	
	oSql:close()
	
return (cRet)


/*/{Protheus.doc} separaOps
Metodo - Transforma lista de OPs em array e atribui ao atributo de array de OPs
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method separaOps(cOps) class ClassShipment
	::aOps	 := separa(cOps, ";")	
return


/*/{Protheus.doc} execAuto250
Metodo - Executa rotina automatica Mata250
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method execAuto250(aArray, nOpc) class ClassShipment
	Private lMsErroAuto := .f.
	
	MsExecAuto({|x,y| mata250(x,y)}, aArray, nOpc)
	if lMsErroAuto
		::setError(.t.)
		::setMsgErro(::oUtils:getErroAuto())
	endif
return


/*/{Protheus.doc} execAuto650
Metodo - Executa rotina automatica Mata650
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method execAuto650(aArray, nOpc) class ClassShipment
	Private lMsErroAuto := .f.
	
	MsExecAuto({|x,y| mata650(x,y)}, aArray, nOpc)
	if lMsErroAuto
		::setError(.t.)
		::setMsgErro(::oUtils:getErroAuto())
	endif
return


/*/{Protheus.doc} showError
Metodo - Exibe tela de mensagem de erro
@type class
@author Thiago Meschiatti
@since 28/12/2016
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
method showError() class ClassShipment
	Aviso("Atenção",::getMsgErro(),{"OK"},3)
return
