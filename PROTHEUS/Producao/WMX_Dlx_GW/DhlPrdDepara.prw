#include 'totvs.ch'

#define A7CODCLI		"1"
#define A7PRODUTO		"2"

/*/{Protheus.doc} DhlPrdDepara
Classe auxilizar para realizar o DEPARA de produto
@type class
@author Gustavo Luiz
@since 23/11/2017
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
CLASS DhlPrdDepara
	
	data cCodPrdProtheus
	data cCodPrdCliente
	data cCodCli
	data cLojCli
	data lExecDepara
	
	
	method getPrdProtheus(cProduto, cCnpjCli)
	method getPrdCliente(cProduto, cCnpjCli)
	method hasDepara()
	method getCodLojaCli()
	method isExecDepara()
	
	method NewDhlPrdDepara() CONSTRUCTOR

ENDCLASS


/*/{Protheus.doc} NewDhlPrdDepara
Método Construtor

@author Gustavo Luiz
@since 23/11/2017
@version 1.0
@example
(examples)
/*/
METHOD NewDhlPrdDepara() CLASS DhlPrdDepara
	
	::cCodPrdProtheus:= ""
	::cCodPrdCliente := ""
	::cCodCli        := ""
	::cLojCli        := ""
	::lExecDepara	 := .F.
	
Return

/*/{Protheus.doc} getPrdProtheus
Obtém o produto Protheus a partir de um código originado de uma interface

@author Gustavo Luiz
@since 23/11/2017
@version 1.0
@example
(examples)
/*/
Method getPrdProtheus(cProduto, cCnpjCli) CLASS DhlPrdDepara
	
	::getCodLojaCli(cCnpjCli)
	
	lIsDepara := ::hasDepara(cProduto, ::cCodCli, ::cLojCli, A7CODCLI)
	
	if lIsDepara
		cProduto := ::cCodPrdProtheus
	endIf
		
Return allTrim(cProduto)

/*/{Protheus.doc} isExecDepara
Verifica se vai ser executado o DEPARA

@author Gustavo Luiz
@since 23/11/2017
@version 1.0
@example
(examples)
/*/
Method isExecDepara() CLASS DhlPrdDepara
		
Return ::lExecDepara


/*/{Protheus.doc} getPrdCliente
Obtém o produto Cliente (SA7) a partir de um código de produto originado do Protheus

@author Gustavo Luiz
@since 23/11/2017
@version 1.0
@example
(examples)
/*/
Method getPrdCliente(cProduto, cCnpjCli) CLASS DhlPrdDepara
	
	::getCodLojaCli(cCnpjCli)
	
	lIsDepara := ::hasDepara(cProduto, ::cCodCli, ::cLojCli, A7PRODUTO)
	
	if lIsDepara
		cProduto := ::cCodPrdCliente
	endIf
		
Return allTrim(cProduto)

/*/{Protheus.doc} hasDepara
Verifica se vai ser considerado o DEPARA

@author Gustavo Luiz
@since 23/11/2017
@version 1.0
@example
(examples)
/*/
Method hasDepara(cProduto, cCodCli, cLoja, cOrigem) CLASS DhlPrdDepara
	
	local oSql 			:= IpSqlObject():newIpSqlObject()
	local lHasDepara	:= .F.
	local cCampoOrigem	:= ""
	
	cCampoOrigem := getCampo(cOrigem)
	
	if !empty(cCodCli) .and. !empty(cLoja)
		oSql:newTable("SA7", "A7_ZZDEPAR, A7_CODCLI, A7_PRODUTO", "%SA7.XFILIAL% AND " + cCampoOrigem + " = '"+cProduto+"' AND A7_CLIENTE = '"+cCodCli+"' AND A7_LOJA = '"+cLoja+"'" )
	else
		oSql:newTable("SA7", "A7_ZZDEPAR, A7_CODCLI, A7_PRODUTO", "%SA7.XFILIAL% AND " + cCampoOrigem + " = '"+cProduto+"'" )
	endIf
	
	if oSql:hasRecords()
		lHasDepara := iif(oSql:getValue("A7_ZZDEPAR") == "S", .T., .F.)
		if lHasDepara
			::lExecDepara := .t.
			if cOrigem == A7CODCLI
				::cCodPrdProtheus := oSql:getValue("A7_PRODUTO")
			else
				::cCodPrdCliente := oSql:getValue("A7_CODCLI")
			endIf
		endIf
	endIf
	
	oSql:Close()
		
Return lHasDepara

/*/{Protheus.doc} getCodLojaCli
Obtém o código/loja do cliente a partir do CNPJ

@author Gustavo Luiz
@since 23/11/2017
@version 1.0
@example
(examples)
/*/
Method getCodLojaCli(cCnpj) CLASS DhlPrdDepara
	
	local aArea 	:= getArea()
	local aAreaSA1	:= SA1->(getArea())
	local cChaveSA1	:= fwXFilial("SA1") + Padr(allTrim(cCnpj), TamSx3("A1_CGC")[1], "")
	
	if !empty(cCnpj)
	
		SA1->(DbSetOrder(3))
	
		if SA1->(DbSeek(cChaveSA1))
		
			::cCodCli := SA1->A1_COD
			::cLojCli:= SA1->A1_LOJA
		
		endIf
	
	endIf
	
	restArea(aAreaSA1)
	restArea(aArea)
		
Return

/**
* Obtém o campo que será utilizado na query:
* A7CODCLI 	= A7_CODCLI
* A7PRODUTO = A7_PRODUTO
**/
static function getCampo(cOrigem)
	
	local cCampoOrigem := ""
	
	if cOrigem == A7CODCLI
		cCampoOrigem := "A7_CODCLI"
	else
		cCampoOrigem := "A7_PRODUTO"
	endIf
	
return cCampoOrigem