#include "protheus.ch"
#include "dhl.ch"

/*/{Protheus.doc} DHLProcessValidator

Regras de validações de processos genéricas da DHL.

@author Waldir Baldin
@since 24/10/2014

/*/
class DHLProcessValidator

	data lisAllowedAlter
	
	method newDHLProcessValidator() constructor 
	method isAllowedAlter()
	method setAllowedAlter()
	method inflowPreInvoiceValidate()
	method outFlowInvoiceCancelValidate()
	method validDocumentType()
	method validSendInterface()
	method validDelUpdPO()

endclass


/*/{Protheus.doc} newDHLProcessValidator

Método construtor da classe DHLProcessValidator
	
@author Waldir Baldin
@since 24/10/2014

/*/
method newDHLProcessValidator() class DHLProcessValidator

	setAllowedAlter(self,.T.)
	
return


/*/{Protheus.doc} isAllowedAlter

Indica se a nota fiscal que está sendo validada, pode ser alterada
	
@author Waldir Baldin
@since 24/10/2014

@return logico	Indicando se a nota fiscal que está sendo analisada, pode ser alterada

/*/
method isAllowedAlter() class DHLProcessValidator

return(::lisAllowedAlter)


/*/{Protheus.doc} inflowPreInvoiceValidate

Método de validação da Pré-Nota de entrada da nota. Se não informado os parametros, assume o Doc. posicionado.
	
@author Waldir Baldin
@since 24/10/2014

@param cCodFil,	String,		Código da Filial
@param cDoc,	String,		Número da Nota Fiscal
@param cSerie,	String,		Série da Nota Fiscal
@param cCliFor,	String,		Código do Cliente / Fornecedor
@param cLoja,	String,		Loja do Cliente / Fornecedor

@return Logico		Retorno que informa se o processo pode continuar ou não

/*/
method inflowPreInvoiceValidate(cCodFil, cDoc, cSerie, cCliFor, cLoja, lClassif) class DHLProcessValidator

	local lRetorno	:= .T.
	local oSql		:= IpSqlObject():newIpSqlObject()

	default cCodFil := SF1->F1_FILIAL
	default cDoc	:= SF1->F1_DOC
	default cSerie	:= SF1->F1_SERIE
	default cCliFor	:= SF1->F1_FORNECE
	default cLoja	:= SF1->F1_LOJA
	default lClassif:= .f.
	
	oSql:newTable(	"SF1",										;
					"F1_ESPECIE ESPECIE, F1_ZZSTATU STATUS",	; 
	  				"F1_FILIAL = '"		+ cCodFil	+ "' AND "+	;
	  				"F1_DOC = '"		+ cDoc		+ "' AND "+	;
	  				"F1_SERIE = '"		+ cSerie	+ "' AND "+	;
	  				"F1_FORNECE = '"	+ cCliFor	+ "' AND "+	;
	  				"F1_LOJA = '"		+ cLoja		+ "'"		)
			
	if oSql:getValue("AllTrim(ESPECIE)") == DHL_ESPECIE_INVENTARIO
		if !lClassif
			msgAlert("Pré-nota de ajuste de inventário não pode ser alterada.")
			setAllowedAlter(self,.F.)
		endif
	endif
	
	if oSql:getValue("AllTrim(STATUS)") == DHL_DOC_PENDENTE_ACAO
		msgAlert("Não é possível alterar/classificar documentos com status 'Docto. Pendente de Ação'")
		setAllowedAlter(self,.F.)
	endif

	if oSql:getValue("AllTrim(STATUS)") == DHL_DOC_CANCELADO
		msgAlert("Não é possível alterar/classificar documentos com status 'Docto. Cancelado'")
		setAllowedAlter(self,.F.)
	endif

	if lRetorno
		if oSql:getValue("STATUS") == DHL_DOC_AGUARDANDO_CONFIRMACAO .or. oSql:getValue("STATUS") == DHL_DOC_CONFIRMACAO_NEGADA
			msgAlert("Não é possível alterar/classificar o documento enquanto a confirmação não for efetivada.")
			setAllowedAlter(self,.F.)
		endif
	endif
	
	oSql:close()
	
return


/**
* Define se permite ou não a alteração da Nota Fiscal
*/
static function setAllowedAlter(oResource,lAttribute)
	oResource:lisAllowedAlter := lAttribute
return


/*/{Protheus.doc} outFlowInvoiceCancellationValidate

Método de validação do cancelamento da nota fiscal de saída.
	
@author Diego de Angelo
@since 11/11/2014

@return Logico		Retorno lógico permitindo o ou não o cancelamento.

/*/
method outFlowInvoiceCancelValidate() class DHLProcessValidator
	local lFunc 	:= IIF(Alltrim(Funname())=='MATA521A',.T.,.F.)
	local lRet		:= .T.
	local lSerCont	:= aScan(separa(GetNewPar("ZZ_SERCONT", ""), ";"), {|x| x == upper(alltrim(SF2->F2_SERIE))}) > 0
     
	if lFunc
		if lSerCont
			return(.T.)
		else		
			if Empty(SF2->F2_FIMP) .OR. SF2->F2_FIMP $ 'ND' //Nota não transmitida (), Não Autorizada (N), Denegada (D) permite cancelamento
				return(.T.)
			elseIf SF2->F2_FIMP == 'T'  //Nota transmitida (T) não permite cancelamento, 
				MsgAlert("Esta nota esta aguardando retorno do SEFAZ!")
				return(.F.)
			elseIf SF2->F2_FIMP == 'C'  //Nota cancelada (C) aguardando retorno de cancelamento
				MsgAlert("Nota já cancelada, aguardando retorno do SEFAZ!")
				return(.F.)
			elseIf SF2->F2_FIMP == 'X'  //Cancelamento não autorizado pelo SEFAZ (X)
				MsgAlert("Cancelamento não autorizado pela SEFAZ!")
				return(.F.)
			endif
		endif
	else
		lRet := .t.
	endif
return lRet


/*/{Protheus.doc} validDocumentType

Método para validação da espécie do documento (entrada) e a série (saída).
	
@author Diego de Angelo
@since 17/11/2014

@return Logico		Retorno lógico permitindo o ou não o envio.

/*/
method validDocumentType(cType, cDocType, cSeries) class DHLProcessValidator
	local lRet		:= .T.
    
   if cType == DHL_NFE_INVOICE_INFLOW
		if Alltrim(cDocType) == "INV" 
			lRet	:= .F.
		ElseIf Alltrim(cDocType) == "DEV"
			lRet	:= .F.
		endIf
	elseif cType == DHL_NFE_INVOICE_OUTFLOW
		if Alltrim(cSeries) == "INV" .or. Alltrim(cSeries) == "INI"
			lRet	:= .F.
		endIf
	endIf
		
return lRet

/*/{Protheus.doc} validSendInterface

Valida se deve ou não enviar a interface ao Mastersaf NFe.
	
@author Thiago Meschiatti
@since 21/01/2015

@return Logico		Retorno lógico permitindo o ou não o envio da interface.

/*/
method validSendInterface(cTipo) class DHLProcessValidator
	local lFunc 	:= IIF(Alltrim(Funname())=='MATA521A',.T.,.F.)
	local lRet		:= .T.
    
    if cTipo == DHL_NFE_INVOICE_OUTFLOW 
		if lFunc
			if SF2->F2_FIMP $ 'S' 
				return(.T.)
			else
				return(.F.)
			endif
		else
			lRet := .t.
		endif
	elseif cTipo == DHL_NFE_INVOICE_INFLOW
		if SF1->F1_FIMP $ 'S' 
			return(.T.)
		else
			return(.F.)
		endif
	endIf
return lRet


method validDelUpdPO(nOperation) class DHLProcessValidator
	local oSql		:= IpSqlObject():newIpSqlObject()
	local lOk	 	:= .t.
	local cQuery	:= ""
	
	cQuery += " SELECT D1_DOC " 
	cQuery += " FROM %SC7.SQLNAME% "
	cQuery += " INNER JOIN %SD1.SQLNAME% ON "
	cQuery += "		D1_FILIAL 		= C7_FILIAL " 
	cQuery += "		AND D1_PEDIDO 	= C7_NUM "
	cQuery += "		AND %SD1.XFILIAL% "
	cQuery += "		AND %SD1.NOTDEL% "
	cQuery += " WHERE "
	cQuery += " 	C7_NUM = '"+SC7->C7_NUM+"' "
	cQuery += "		AND %SC7.XFILIAL% "
	cQuery += "		AND %SC7.NOTDEL% "

	oSql:newAlias(cQuery)
	
	if oSql:hasRecords()
		if nOperation == DHL_OPC_ALTERACAO
			Alert("Este Pedido não pode ser alterado, pois já possuí movimentação para ele!")
			lOk := .f.
		elseif nOperation == DHL_OPC_EXCLUSAO
			Alert("Este Pedido não pode ser excluído, pois já possuí movimentação para ele!")
			lOk := .f.
		endif
	endif
	
	oSql:close()
	
return (lOk)