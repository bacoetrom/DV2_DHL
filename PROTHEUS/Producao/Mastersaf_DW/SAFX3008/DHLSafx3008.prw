#include 'protheus.ch'
#include 'safx3008.ch'
#include 'safxrtc.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} DHLSafx3008

Regras e montagem da linha de item para a interface SAFX3008 (Reforma
Tributaria). Equivale a MontLinha() da especificacao, na granularidade do
item fiscal.

Le o item do cursor aberto pelo SAFX3007MSDW - SFT, produto e os tributos de
IBS/CBS/IS pre-agregados pela DHLSafxRtc - e o que e do documento chega pelo
contexto aCtx, de modo que cabecalho e item nao se misturem nem sejam
recalculados por item.

A classe NAO calcula tributo: exporta o que o Configurador de Tributos
registrou para aquele item.

@type  class
@author Pablo Regis
@since 23/11/2026
/*/
user function _Safx3008;return

class DHLSafx3008 from DHLSafx

	data aCtx as Array

	method newDHLSafx3008() constructor

	method addLine()
	method notFieldRequired()

	method setCtx(aCtx)
	method getCtx()

	method getCab(cField)
	method getIten(cField)
	method getCtxVal(cField)
	method getPartic(cFldSA1,cFldSA2)

endclass

//-----------------------------------------------------------------
method newDHLSafx3008() class DHLSafx3008

	::aCtx := {}

return self

method setCtx(aCtx) class DHLSafx3008
	::aCtx := aCtx
return

method getCtx() class DHLSafx3008
return ::aCtx

/*/{Protheus.doc} getCab
Valor de um campo do cursor de cabecalho.

@type   method
@author Pablo Regis
@since  23/11/2026
@param  cField, character, nome da coluna
@return variant, valor da coluna
/*/
method getCab(cField) class DHLSafx3008
return ::oHeaderSql:getValue(cField)

/*/{Protheus.doc} getIten
Valor de um campo do item corrente.

@type   method
@author Pablo Regis
@since  23/11/2026
@param  cField, character, nome da coluna
@return variant, valor da coluna
/*/
method getIten(cField) class DHLSafx3008
return ::oDetailSql:getValue(cField)

/*/{Protheus.doc} getCtxVal
Valor do contexto do documento montado pelo SAFX3007MSDW.

@type   method
@author Pablo Regis
@since  23/11/2026
@param  cField, character, nome do item de contexto
@return variant, valor do contexto
/*/
method getCtxVal(cField) class DHLSafx3008
return ::getFieldValue(cField, ::aCtx)

/*/{Protheus.doc} getPartic
Valor do participante, escolhendo a coluna da SA1 (cliente) ou da SA2
(fornecedor) conforme o indicador que o cabecalho ja resolveu.

@type   method
@author Pablo Regis
@since  23/11/2026
@param  cFldSA1, character, coluna da SA1
@param  cFldSA2, character, coluna da SA2
@return variant, valor do participante
/*/
method getPartic(cFldSA1,cFldSA2) class DHLSafx3008

	local xValue := ""

	if ::getCtxVal("INDFISJUR") == "1"
		xValue := ::getCab(cFldSA2)
	else
		xValue := ::getCab(cFldSA1)
	endIf

return xValue

/*/{Protheus.doc} addLine
Monta a linha do item conforme o leiaute de safx3008.ch.

@type   method
@author Pablo Regis
@since  23/11/2026
/*/
method addLine() class DHLSafx3008

	local cChave := ""

	if Empty(::aFields)
		return
	endIf

	cChave := AllTrim(::getCtxVal("CHVNFE"))
	if Empty(cChave)
		cChave := AllTrim(::getIten("FT_CHVNFE"))
	endIf

	// ---------------------------------------------------------------
	// Identificacao - o que e do documento vem do contexto
	// ---------------------------------------------------------------
	::addField(F3008_COD_EMPRESA   , "SOL")                 // mesmo literal da SAFX08
	::addField(F3008_COD_ESTAB     , ::getCtxVal("CODESTAB"))
	::addField(F3008_DATA_FISCAL   , ::getCtxVal("DTESCRIT"))
	::addField(F3008_NORM_DEV      , ::getCtxVal("TPMOVTO"))
	::addField(F3008_COD_DOCTO     , "NFE")
	::addField(F3008_IND_FIS_JUR   , ::getPartic("A1_ZZINDDW", "A2_ZZINDDW"))
	::addField(F3008_COD_FIS_JUR   , ::getCtxVal("CODFISJUR"))
	::addField(F3008_NUM_DOCFIS    , ::getCab("F3_NFISCAL"))
	::addField(F3008_SERIE_DOCFIS  , ::getCab("F3_SERIE"))
	::addField(F3008_CHAVE_DOCFIS  , cChave)

	if ::getCtxVal("CTYPE") == "1"
		::addField(F3008_MOVTO_E_S , SAFX_DOCUMENTO_ENTRADA)
	else
		::addField(F3008_MOVTO_E_S , SAFX_DOCUMENTO_SAIDA)
	endIf

	// ---------------------------------------------------------------
	// Item
	// ---------------------------------------------------------------
	::addField(F3008_NUM_ITEM        , ::getIten("FT_ITEM"))
	::addField(F3008_IND_PRODUTO     , ::getProdType(::getIten("B1_TIPO")))
	::addField(F3008_COD_PRODUTO     , ::getIten("FT_PRODUTO"))
	::addField(F3008_DESCRICAO_COMPL , ::getIten("B1_DESC"))
	::addField(F3008_COD_NBM         , ::getIten("B1_POSIPI"))
	::addField(F3008_COD_CFO         , ::getIten("FT_CFOP"))
	::addField(F3008_COD_NATUREZA_OP , ::getIten("FT_NATOPER"))
	::addField(F3008_QUANTIDADE      , ::getIten("FT_QUANT")  , .F.)
	::addField(F3008_COD_MEDIDA      , ::getIten("B1_UM"))
	::addField(F3008_VLR_UNIT        , ::getIten("FT_PRCUNIT"), .F.)
	::addField(F3008_VLR_ITEM        , ::getIten("FT_TOTAL")  , .F.)
	::addField(F3008_VLR_DESCONTO    , ::getIten("FT_DESCONT"), .F.)
	::addField(F3008_VLR_FRETE_ITEM  , ::getIten("FT_FRETE")  , .F.)
	::addField(F3008_VLR_SEGURO_ITEM , ::getIten("FT_SEGURO") , .F.)
	::addField(F3008_VLR_OUTRAS_ITEM , ::getIten("FT_DESPESA"), .F.)

	// ---------------------------------------------------------------
	// IBS estadual, IBS municipal, CBS e Imposto Seletivo do item.
	// lFormatZero = .F.: item sem tributo novo exporta zero, nao o
	// marcador de nulo "@" - ver PEND-04 na documentacao da interface.
	// ---------------------------------------------------------------
	::addField(F3008_COD_CLASS_TRIB   , ::getIten(RTC_COL_CLSTRIB))

	::addField(F3008_VLR_BASE_IBS_UF  , ::getIten(RTC_COL_BAS_UF), .F.)
	::addField(F3008_ALIQ_IBS_UF      , ::getIten(RTC_COL_ALQ_UF), .F.)
	::addField(F3008_VLR_IBS_UF       , ::getIten(RTC_COL_VLR_UF), .F.)
	::addField(F3008_CST_IBS_UF       , ::getIten(RTC_COL_CST_UF))

	::addField(F3008_VLR_BASE_IBS_MUN , ::getIten(RTC_COL_BAS_MU), .F.)
	::addField(F3008_ALIQ_IBS_MUN     , ::getIten(RTC_COL_ALQ_MU), .F.)
	::addField(F3008_VLR_IBS_MUN      , ::getIten(RTC_COL_VLR_MU), .F.)
	::addField(F3008_CST_IBS_MUN      , ::getIten(RTC_COL_CST_MU))

	::addField(F3008_VLR_BASE_CBS     , ::getIten(RTC_COL_BAS_CB), .F.)
	::addField(F3008_ALIQ_CBS         , ::getIten(RTC_COL_ALQ_CB), .F.)
	::addField(F3008_VLR_CBS          , ::getIten(RTC_COL_VLR_CB), .F.)
	::addField(F3008_CST_CBS          , ::getIten(RTC_COL_CST_CB))

	::addField(F3008_VLR_BASE_IS      , ::getIten(RTC_COL_BAS_IS), .F.)
	::addField(F3008_ALIQ_IS          , ::getIten(RTC_COL_ALQ_IS), .F.)
	::addField(F3008_VLR_IS           , ::getIten(RTC_COL_VLR_IS), .F.)
	::addField(F3008_CST_IS           , ::getIten(RTC_COL_CST_IS))

	// ---------------------------------------------------------------
	// Documento e item de origem
	// ---------------------------------------------------------------
	::addField(F3008_NUM_DOCFIS_REF   , ::getIten("FT_NFORI"))
	::addField(F3008_SERIE_DOCFIS_REF , ::getIten("FT_SERORI"))
	::addField(F3008_NUM_ITEM_REF     , ::getIten("FT_ITEMORI"))

	::notFieldRequired()

return

/*/{Protheus.doc} notFieldRequired
Posicoes preenchidas em branco ou com zero, por decisao ou por pendencia
documentada. Toda posicao tem de ser preenchida: MsafDWFile:write()
concatena a linha inteira e um nil derruba o processamento.

Pendencias que esta rotina NAO tem como resolver hoje:

  PEND-01  Reducao de base, diferimento e credito presumido de IBS/CBS - os
           campos correspondentes da F2D nao estao confirmados no dicionario.
           Saem zerados; nao sao estimados. Conferir com a consulta ao SX3
           registrada em DHLSafx3007:notFieldRequired().

  PEND-02  Chave do documento referenciado. A SFT guarda numero, serie e
           item de origem, nao a chave. Quem resolve documento referenciado
           hoje e a familia DHLSafx116.

  PEND-05  Unidade de medida: esta saindo a unidade padrao do produto
           (B1_UM). A unidade da linha esta em D1_UM / D2_UM, que exigiria
           juntar SD1/SD2 ao cursor de itens. Confirmar no manual qual das
           duas a interface espera antes de trocar.

@type   method
@author Pablo Regis
@since  23/11/2026
/*/
method notFieldRequired() class DHLSafx3008

	::addField(F3008_SUB_SERIE_DOCFIS , " ")

	// PEND-01 - sem campo confirmado na F2D
	::addField(F3008_VLR_RED_IBS_UF       , 0, .F.)
	::addField(F3008_VLR_DIF_IBS_UF       , 0, .F.)
	::addField(F3008_VLR_CRED_PRES_IBS_UF , 0, .F.)
	::addField(F3008_VLR_RED_IBS_MUN      , 0, .F.)
	::addField(F3008_VLR_DIF_IBS_MUN      , 0, .F.)
	::addField(F3008_VLR_CRED_PRES_IBS_MUN, 0, .F.)
	::addField(F3008_VLR_RED_CBS          , 0, .F.)
	::addField(F3008_VLR_DIF_CBS          , 0, .F.)
	::addField(F3008_VLR_CRED_PRES_CBS    , 0, .F.)

	// PEND-02
	::addField(F3008_CHAVE_DOCFIS_REF , " ")

	// rastreio - semantica a confirmar no manual oficial
	::addField(F3008_IDENTIF_DOCFIS   , " ")
	::addField(F3008_COD_SISTEMA_ORIG , " ")

return
