#Include 'Protheus.ch'

/*/{Protheus.doc} DHLRetItemPc

Classe utilizada para retorno do item do pedido de compra para amarração com a pré-nota
	
@author Diego de Angelo
@since 09/06/2016
@type class
/*/
class DHLRetItemPc
	
	data cAliasTmp
	data oTable //Objeto para a classe FwTemporaryTable (Cria tabela temporária no banco de dados)
	data cItem
	data cNumPc
	data nSaldo    
	data aCampos
	data lItemOk
	
	method newDHLRetItemPc() constructor
	
	method iniciaProcesso()
	method retornaInfoPc()
	method finalizaProcesso()
	method getItem()
	method getSuccess()
	 
endClass


/*/{Protheus.doc} getItem

Método responsável pelo retorno do item do pc informado.
	
@author Diego de Angelo
@since 09/06/2016

@return Caracter Item do pedido de compra
/*/
method getSuccess() class DHLRetItemPc
return ::lItemOk


/*/{Protheus.doc} getItem

Método responsável pelo retorno do item do pc informado.
	
@author Diego de Angelo
@since 09/06/2016

@return Caracter Item do pedido de compra
/*/
method getItem() class DHLRetItemPc
return ::cItem


/*/{Protheus.doc} newDHLRetItemPc

Método construtor da classe

@author Diego de Angelo
@since 09/06/2016

/*/
method newDHLRetItemPc() class DHLRetItemPc
return


/*/{Protheus.doc} iniciaProcesso

Método responsável pelo processamento inicial e criação do arquivo temporário

@author Diego de Angelo
@since 09/06/2016
@param cNumPc, Caracter, Número do pedido de compra
/*/
method iniciaProcesso(cNumPc) class DHLRetItemPc
	preencheArq(@self, cNumPc)
return


/*/{Protheus.doc} finalizaProcesso

Método responsável por apagar os arquivos temporários e fechar o alias.

@author Diego de Angelo
@since 09/06/2016
@param cNumPc, Caracter, Número do pedido de compra
/*/
method finalizaProcesso() class DHLRetItemPc
	finalizaProcesso(@self)
return


/*/{Protheus.doc} retornaInfoPc

Método responsável pelo retorno das informações do pedido de compra

@author Diego de Angelo
@since 09/06/2016
@param cNumPc, Caracter, Número do pedido de compra
@param cCodProd, Caracter, Código do produto
@param nQuant, Numerico, Quantidade do item da nota fiscal
/*/
method retornaInfoPc(cNumPc, cCodProd, nQuant) class DHLRetItemPc
	local cAliasTmp	:= ::cAliasTmp
	local cItem		:= ""
	local lItemOk	:= .F.
	
	(cAliasTmp)->(dbGoTop())
	
	while (cAliasTmp)->(!eof()) .AND. alltrim((cAliasTmp)->C7_FILIAL) == alltrim(xFilial("SC7")) .AND. alltrim((cAliasTmp)->C7_NUM) == alltrim(cNumPc) 
		if alltrim((cAliasTmp)->C7_PRODUTO) == alltrim(cCodProd)
			if (cAliasTmp)->SALDO >= nQuant
				lItemOk	:= .T.
				cItem	:= (cAliasTmp)->C7_ITEM
				(cAliasTmp)->(recLock(cAliasTmp,.F.))
					(cAliasTmp)->SALDO := (cAliasTmp)->SALDO - nQuant
				(cAliasTmp)->(msUnlock())
				exit
			endIf
		endIf
		(cAliasTmp)->(dbSkip())
	endDo
	
	::lItemOk	:= lItemOk
	::cItem		:= cItem
return


/*
*	Função responsável pelo retorno da consulta SQL para retorno do item
*/
static function retQryItem(cNumPc)
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	local aItensPc	:= {}
	
	cQuery := "SELECT C7_FILIAL, C7_PRODUTO, C7_NUM, (C7_QUANT-C7_QUJE-C7_QTDACLA) SALDO, C7_ITEM " +CRLF
	cQuery += "FROM %SC7.SQLNAME%" + CRLF
	cQuery += "WHERE " + CRLF
	cQuery += " 	%SC7.NOTDEL% "  +CRLF
	cQuery += " 	AND C7_FILIAL = '%SC7.FILIAL%' "     +CRLF
	cQuery += " 	AND C7_RESIDUO=' ' "            +CRLF
	cQuery += " 	AND C7_TPOP!='P' "          +CRLF
	cQuery += " 	AND (C7_QUANT-C7_QUJE-C7_QTDACLA) > 0 "+CRLF
	cQuery += "		AND C7_NUM = '"+cNumPc+"' " +CRLF
	cQuery += "ORDER BY (C7_QUANT-C7_QUJE-C7_QTDACLA) " +CRLF
	
	oSql:newAlias(cQuery)
	
return oSql


/*
*	Função responsável pelo processamento e criação do arquivo temporário.
*/	
static function preencheArq(oObj,cNumPc)
	local nI		:= 1
	local cAliasTmp	:= oObj:cAliasTmp
	local oSql		:= nil
	local cAlias	:= nil
	local aEstrut 	:= {}
	local nIndex	:= 0
	local lExist	:= .F.
	
	if Select(cAliasTmp) == 0
		criaArq(@oObj)
	endIf
	
	cAliasTmp	:= oObj:cAliasTmp
	dbSelectArea(cAliasTmp)
	
	lExist	:= dbSeek(xFilial("SC7") + cNumPc)
	
	(cAliasTmp)->(dbGoTop())
	
	if !lExist
		oSql		:= retQryItem(cNumPc)
		cAlias		:= oSql:getAlias()
		while oSql:notIsEof()
			(cAliasTmp)->(recLock(cAliasTmp, .T.))
			for nI	:= 1 to len(oObj:aCampos)
				(cAliasTmp)->&(oObj:aCampos[nI][1])	:= oSql:getValue(oObj:aCampos[nI][1])
			next nI
			
			oSql:Skip()
		endDo
		oSql:close()
	endIf
return


/*
*	Função responsável pela criação do arquivo temporário
*/
static function criaArq(oObj)
	local cAliasTmp	:= oObj:cAliasTmp
	local aCampos	:= {}
	
	aAdd(aCampos, {"C7_FILIAL", 	"C", TamSx3("C7_FILIAL")[1], 0})
	aAdd(aCampos, {"C7_ITEM", 		"C", TamSx3("C7_ITEM")[1], 0})
	aAdd(aCampos, {"C7_NUM", 		"C", TamSx3("C7_NUM")[1], 0})
	aAdd(aCampos, {"C7_PRODUTO", 	"C", TamSx3("C7_PRODUTO")[1], 0})
	aAdd(aCampos, {"SALDO", 		"N", TamSx3("C7_QUANT")[1], TamSx3("C7_QUANT")[2]})
		
	cAliasTmp := getNextAlias()
	
	oObj:oTable := FWTemporaryTable():New(cAliasTmp,aCampos)
	oObj:oTable:AddIndex("1", {"C7_FILIAL","C7_NUM","C7_PRODUTO"})
	oObj:oTable:Create()
	
	oObj:cAliasTmp	:= cAliasTmp
	oObj:aCampos	:= aCampos
return


/*
*	Função responsável por apagar os arquivos e fechar o alias.
*/
static function finalizaProcesso(oObj)
	If oObj:oTable <> Nil
		oObj:oTable:Delete()
		oObj:oTable := Nil
	Endif
return