#include 'protheus.ch'
#include 'topconn.ch'
#include 'safx3008.ch'
#include 'safxrtc.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} SAFX3008MSDW

Gera as linhas da interface SAFX3008 (itens dos documentos fiscais baseados
nas tabelas da Reforma Tributaria).

Segue o conceito da SAFX08: nao abre cursor proprio nem repete a selecao do
documento. Recebe do SAFX3007MSDW o cursor de cabecalho, o cursor de itens
(SFT + produto + tributos da Reforma ja pre-agregados por item) e o arquivo
de destino, e percorre os itens do documento corrente.

A granularidade e o item fiscal (SFT). Cabecalho e item nunca se misturam: o
que vem do documento chega pelo contexto aCtx, montado uma unica vez pelo
SAFX3007MSDW.

@type  function
@author Pablo Regis
@since 23/11/2026
@param oSqlCab,   object, cursor do cabecalho (SF3 agregada + SA1/SA2)
@param oSqlIten,  object, cursor de itens do documento
@param oFile3008, object, MsafDWFile da interface 3008
@param aCtx,      array,  contexto do documento no formato {valor, nome}
@return logical, indica se alguma linha foi gravada
/*/
user function SAFX3008MSDW(oSqlCab, oSqlIten, oFile3008, aCtx)

	local oDHL3008 := DHLSafx3008():newDHLSafx3008()
	local aFields  := {}
	local cError   := ""
	local lGerou   := .F.

	default aCtx := {}

	if oSqlIten == nil .or. oFile3008 == nil
		return .F.
	endIf

	oSqlIten:goTop()

	while oSqlIten:notIsEof()

		oDHL3008:initialize(SAFX3008_POSICOES, oSqlCab, oSqlIten)
		oDHL3008:setCtx(aCtx)
		oDHL3008:addLine()

		aFields := oDHL3008:getFields()
		cError  := oDHL3008:validRequired(VLD_3008_FIELD)

		if !Empty(cError)
			oDHL3008:addLog(SAFX3008_ERROR_TITLE,;
				SAFX3008_ERROR_OBRIGAT + cError + idIten(oSqlCab, oSqlIten), oFile3008:getFile())
			oSqlIten:skip()
			loop
		endIf

		if posNil(aFields)
			oDHL3008:addLog(SAFX3008_ERROR_TITLE,;
				SAFX3008_ERROR_NIL + idIten(oSqlCab, oSqlIten), oFile3008:getFile())
			oSqlIten:skip()
			loop
		endIf

		oFile3008:setFields( aFields )

		if oFile3008:write()
			lGerou := .T.
		else
			oDHL3008:addLog(SAFX3008_ERROR_TITLE,;
				ERROR_QTD_CAMPOS + idIten(oSqlCab, oSqlIten), oFile3008:getFile())
		endIf

		oSqlIten:skip()
	endDo

	oSqlIten:goTop()

return lGerou

/*/{Protheus.doc} posNil
Verifica se alguma posicao do leiaute ficou sem preenchimento, antes de
entregar o array ao MsafDWFile.

@type   function
@author Pablo Regis
@since  23/11/2026
@param  aFields, array, posicoes do leiaute
@return logical, .T. quando existe posicao nao preenchida
/*/
static function posNil(aFields)
return aScan(aFields, {|x| x == nil }) > 0

/*/{Protheus.doc} idIten
Identificacao do item para o log de erros, sem expor valor fiscal.

@type   function
@author Pablo Regis
@since  23/11/2026
@param  oSqlCab,  object, cursor do cabecalho
@param  oSqlIten, object, cursor de itens
@return character, texto de identificacao
/*/
static function idIten(oSqlCab, oSqlIten)

	local cId := CRLF + CRLF

	cId += "Nota Fiscal: " + AllTrim(oSqlCab:getValue("F3_NFISCAL")) + "/" + AllTrim(oSqlCab:getValue("F3_SERIE")) + CRLF
	cId += "Cliente/Fornecedor: " + AllTrim(oSqlCab:getValue("F3_CLIEFOR")) + "-" + AllTrim(oSqlCab:getValue("F3_LOJA")) + CRLF
	cId += "Item: " + AllTrim(oSqlIten:getValue("FT_ITEM")) + " Produto: " + AllTrim(oSqlIten:getValue("FT_PRODUTO"))

return cId
