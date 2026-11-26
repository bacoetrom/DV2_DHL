#include 'protheus.ch'
#include 'safx3007.ch'
#include 'safxrtc.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} DHLSafx3007

Regras e montagem da linha do cabecalho do documento fiscal para a interface
SAFX3007 (Reforma Tributaria). Equivale a funcao MontLinha() sugerida na
especificacao - no conceito da pasta Mastersaf_DW a serializacao e um metodo
addLine() de classe derivada de DHLSafx, para que as variantes por unidade de
negocio possam sobrepor apenas o que muda.

A classe NAO calcula tributo: le o que o Configurador de Tributos registrou,
ja pre-agregado pela DHLSafxRtc e totalizado pelo driver.

Origem dos dados:
  ::oHeaderSql - cursor de cabecalho (SF3 agregada + SA1/SA2)
  ::oDetailSql - cursor de itens (SFT + SB1 + tributos), no primeiro item
  ::aTotRtc    - totais do documento no formato {valor, nome de coluna}

@type  class
@author Pablo Regis
@since 23/11/2026
/*/
user function _Safx3007;return

class DHLSafx3007 from DHLSafx

	data aTotRtc    as Array
	data cType      as String
	data cTpMovto   as String
	data cIndFisJur as String
	data cCodFisJur as String
	data cCodEstab  as String

	method newDHLSafx3007() constructor

	method addLine()
	method notFieldRequired()

	method setTotRtc(aTotRtc)
	method getTotRtc()

	method getTpMovto()
	method getIndFisJur()
	method getCodFisJur()
	method getCodEstab()

	method getCab(cField)
	method getIten(cField)
	method getTot(cField)
	method getPartic(cFldSA1,cFldSA2)

endclass

//-----------------------------------------------------------------
method newDHLSafx3007() class DHLSafx3007

	::aTotRtc    := {}
	::cType      := ""
	::cTpMovto   := ""
	::cIndFisJur := ""
	::cCodFisJur := ""
	::cCodEstab  := ""

return self

method setTotRtc(aTotRtc) class DHLSafx3007
	::aTotRtc := aTotRtc
return

method getTotRtc() class DHLSafx3007
return ::aTotRtc

method getTpMovto() class DHLSafx3007
return ::cTpMovto

method getIndFisJur() class DHLSafx3007
return ::cIndFisJur

method getCodFisJur() class DHLSafx3007
return ::cCodFisJur

method getCodEstab() class DHLSafx3007
return ::cCodEstab

/*/{Protheus.doc} getCab
Valor de um campo do cursor de cabecalho.

@type   method
@author Pablo Regis
@since  23/11/2026
@param  cField, character, nome da coluna
@return variant, valor da coluna
/*/
method getCab(cField) class DHLSafx3007
return ::oHeaderSql:getValue(cField)

/*/{Protheus.doc} getIten
Valor de um campo do cursor de itens, na posicao corrente (o driver mantem o
cursor no primeiro item quando monta o cabecalho).

@type   method
@author Pablo Regis
@since  23/11/2026
@param  cField, character, nome da coluna
@return variant, valor da coluna
/*/
method getIten(cField) class DHLSafx3007
return ::oDetailSql:getValue(cField)

/*/{Protheus.doc} getTot
Valor totalizado do documento.

@type   method
@author Pablo Regis
@since  23/11/2026
@param  cField, character, nome da coluna de total
@return variant, valor totalizado
/*/
method getTot(cField) class DHLSafx3007
return ::getFieldValue(cField, ::aTotRtc)

/*/{Protheus.doc} getPartic
Valor do participante do documento, escolhendo a coluna da SA1 (cliente) ou
da SA2 (fornecedor) conforme o indicador resolvido por
DHLSafx:indFisJurPorTipo(). O cursor traz as duas tabelas por LEFT JOIN, de
modo que a nota de credito/debito nao fica sem participante.

@type   method
@author Pablo Regis
@since  23/11/2026
@param  cFldSA1, character, coluna da SA1
@param  cFldSA2, character, coluna da SA2
@return variant, valor do participante
/*/
method getPartic(cFldSA1,cFldSA2) class DHLSafx3007

	local xValue := ""

	if ::cIndFisJur == "1"
		xValue := ::getCab(cFldSA2)
	else
		xValue := ::getCab(cFldSA1)
	endIf

return xValue

/*/{Protheus.doc} addLine
Monta a linha do cabecalho conforme o leiaute de safx3007.ch.

@type   method
@author Pablo Regis
@since  23/11/2026
/*/
method addLine() class DHLSafx3007

	local cDoc     := ""
	local cSer     := ""
	local cCod     := ""
	local cLoja    := ""
	local cTipoDoc := ""
	local cChave   := ""
	local cMunPart := ""
	local cMunEstb := ""
	local lCanc    := .F.
	local nTotIbs  := 0
	local nTotTrib := 0

	if Empty(::aFields)
		return
	endIf

	cDoc     := AllTrim(::getCab("F3_NFISCAL"))
	cSer     := AllTrim(::getCab("F3_SERIE"))
	cCod     := AllTrim(::getCab("F3_CLIEFOR"))
	cLoja    := AllTrim(::getCab("F3_LOJA"))
	cTipoDoc := ::getCab("F3_TIPO")
	lCanc    := !Empty(::getCab("F3_DTCANC"))

	::cType      := ::getCab("ENT_SAI")
	::cIndFisJur := ::indFisJurPorTipo(::cType, cTipoDoc)
	::cCodEstab  := AllTrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp()))
	::cCodFisJur := ::cCodEstab + cCod + cLoja

	// tipo de movimento: a query devolve a regra binaria historica e o metodo
	// da classe base aplica a matriz de credito/debito do fiscal (anexo 8)
	::cTpMovto := ::tpMovtoFiscal(::cType, cTipoDoc, ::getCab("TIPO_MOV"),;
	                              cDoc, cSer, cCod, cLoja)

	// chave: a SF3 e a fonte; caindo vazia usa a do item (SFT)
	cChave := AllTrim(::getCab("F3_CHVNFE"))
	if Empty(cChave)
		cChave := AllTrim(::getIten("FT_CHVNFE"))
	endIf

	cMunPart := ::getPartic("A1_COD_MUN", "A2_COD_MUN")
	cMunEstb := SM0->M0_CODMUN

	nTotIbs  := ::getTot(RTC_COL_VLR_UF) + ::getTot(RTC_COL_VLR_MU)
	nTotTrib := nTotIbs + ::getTot(RTC_COL_VLR_CB) + ::getTot(RTC_COL_VLR_IS)

	// ---------------------------------------------------------------
	// Identificacao
	// ---------------------------------------------------------------
	::addField(F3007_COD_EMPRESA        , "SOL")                 // mesmo literal da SAFX07
	::addField(F3007_COD_ESTAB          , ::cCodEstab)
	::addField(F3007_COD_DOCTO          , "NFE")
	::addField(F3007_IDENT_FIS_JUR      , ::getPartic("A1_ZZINDDW", "A2_ZZINDDW"))
	::addField(F3007_COD_FIS_JUR        , ::cCodFisJur)
	::addField(F3007_NUM_DOCFIS         , cDoc)
	::addField(F3007_SERIE_DOCFIS       , cSer)
	::addField(F3007_COD_MODELO         , "55")
	::addField(F3007_COD_CLASS_DOC_FIS  , "1")
	::addField(F3007_NORM_DEV           , ::cTpMovto)
	::addField(F3007_CHAVE_DOCFIS       , cChave)
	::addField(F3007_DATA_EMISSAO       , ::getCab("F3_EMISSAO"))
	::addField(F3007_DATA_ESCRITURACAO  , ::getCab("F3_ENTRADA"))
	::addField(F3007_COD_NATUREZA_OP    , ::getIten("FT_NATOPER"))

	if ::cType == "1"
		::addField(F3007_MOVTO_E_S      , SAFX_DOCUMENTO_ENTRADA)
		::addField(F3007_DATA_SAIDA_REC , ::getCab("F3_ENTRADA"))
		::addField(F3007_UF_ORIG_DEST   , ::getCab("F3_ESTADO"))
		::addField(F3007_COD_MUNIC_ORIG , cMunPart)
		::addField(F3007_COD_MUNIC_DEST , cMunEstb)
	else
		::addField(F3007_MOVTO_E_S      , SAFX_DOCUMENTO_SAIDA)
		::addField(F3007_DATA_SAIDA_REC , ::getCab("F3_EMINFE"))
		::addField(F3007_UF_ORIG_DEST   , SM0->M0_ESTENT)
		::addField(F3007_COD_MUNIC_ORIG , cMunEstb)
		::addField(F3007_COD_MUNIC_DEST , cMunPart)
	endIf

	// situacao do documento: cancelado permanece no livro
	if lCanc
		::addField(F3007_COD_SIT_DOCFIS   , "02")
		::addField(F3007_SITUACAO          , "S")
		::addField(F3007_DATA_CANCELAMENTO , ::getCab("F3_DTCANC"))
	else
		::addField(F3007_COD_SIT_DOCFIS   , "00")
		::addField(F3007_SITUACAO          , "N")
		::addField(F3007_DATA_CANCELAMENTO , " ")
	endIf

	// finalidade: F*_TIPO "5" credito e "6" debito sao os tipos criados pela
	// Reforma; qualquer outro valor segue como operacao normal
	if AllTrim(cTipoDoc) == SAFX3007_FIN_CREDITO
		::addField(F3007_IND_FINALIDADE, SAFX3007_FIN_CREDITO)
	elseIf AllTrim(cTipoDoc) == SAFX3007_FIN_DEBITO
		::addField(F3007_IND_FINALIDADE, SAFX3007_FIN_DEBITO)
	else
		::addField(F3007_IND_FINALIDADE, SAFX3007_FIN_NORMAL)
	endIf

	// documento referenciado: numero e serie vem do item fiscal
	::addField(F3007_NUM_DOCFIS_REF  , ::getIten("FT_NFORI"))
	::addField(F3007_SERIE_DOCFIS_REF, ::getIten("FT_SERORI"))

	// ---------------------------------------------------------------
	// Valores do documento. Mercadoria, desconto, frete e seguro saem da
	// soma dos itens fiscais; total e outras despesas saem da propria SF3,
	// que e o que o livro fiscal registra.
	// ---------------------------------------------------------------
	::addField(F3007_VLR_PRODUTO  , ::getTot(TOT_COL_PROD) , .F.)
	::addField(F3007_VLR_TOT_NOTA , ::getCab("F3_VALCONT") , .F.)
	::addField(F3007_VLR_DESCONTO , ::getTot(TOT_COL_DESC) , .F.)
	::addField(F3007_VLR_FRETE    , ::getTot(TOT_COL_FRETE), .F.)
	::addField(F3007_VLR_SEGURO   , ::getTot(TOT_COL_SEG)  , .F.)
	::addField(F3007_VLR_OUTRAS   , ::getCab("F3_DESPESA") , .F.)

	// ---------------------------------------------------------------
	// IBS estadual, IBS municipal, CBS e Imposto Seletivo.
	// lFormatZero = .F. de proposito: o documento sem tributo novo exporta
	// zero, e nao o marcador de nulo "@" - ver pendencia PEND-04 na
	// documentacao da interface.
	// ---------------------------------------------------------------
	::addField(F3007_VLR_BASE_IBS_UF , ::getTot(RTC_COL_BAS_UF), .F.)
	::addField(F3007_ALIQ_IBS_UF     , ::getTot(RTC_COL_ALQ_UF), .F.)
	::addField(F3007_VLR_IBS_UF      , ::getTot(RTC_COL_VLR_UF), .F.)
	::addField(F3007_CST_IBS_UF      , ::getTot(RTC_COL_CST_UF))

	::addField(F3007_VLR_BASE_IBS_MUN, ::getTot(RTC_COL_BAS_MU), .F.)
	::addField(F3007_ALIQ_IBS_MUN    , ::getTot(RTC_COL_ALQ_MU), .F.)
	::addField(F3007_VLR_IBS_MUN     , ::getTot(RTC_COL_VLR_MU), .F.)
	::addField(F3007_CST_IBS_MUN     , ::getTot(RTC_COL_CST_MU))

	::addField(F3007_VLR_BASE_CBS    , ::getTot(RTC_COL_BAS_CB), .F.)
	::addField(F3007_ALIQ_CBS        , ::getTot(RTC_COL_ALQ_CB), .F.)
	::addField(F3007_VLR_CBS         , ::getTot(RTC_COL_VLR_CB), .F.)
	::addField(F3007_CST_CBS         , ::getTot(RTC_COL_CST_CB))

	::addField(F3007_VLR_BASE_IS     , ::getTot(RTC_COL_BAS_IS), .F.)
	::addField(F3007_ALIQ_IS         , ::getTot(RTC_COL_ALQ_IS), .F.)
	::addField(F3007_VLR_IS          , ::getTot(RTC_COL_VLR_IS), .F.)
	::addField(F3007_CST_IS          , ::getTot(RTC_COL_CST_IS))

	::addField(F3007_VLR_TOT_IBS      , nTotIbs , .F.)
	::addField(F3007_VLR_TOT_TRIB_RTC , nTotTrib, .F.)
	::addField(F3007_COD_CLASS_TRIB   , ::getTot(RTC_COL_CLSTRIB))

	::notFieldRequired()

return

/*/{Protheus.doc} notFieldRequired
Posicoes que a rotina preenche em branco ou com zero, por decisao ou por
pendencia documentada. Toda posicao do leiaute tem de ser preenchida: sem
isso MsafDWFile:write() concatena um nil e derruba o processamento.

Pendencias que esta rotina NAO tem como resolver hoje:

  PEND-01  Reducao de base, diferimento e credito presumido de IBS/CBS.
           Os campos correspondentes da F2D nao estao confirmados no
           dicionario - somente F2D_BASE, F2D_ALIQ, F2D_VALOR, F2D_TRIB,
           F2D_IDREL, F2D_TABELA, F2D_DTEXCL e F2D_ID, todos em uso no
           projeto. Saem zerados; nao sao estimados.
           Conferir com:
             SELECT X3_CAMPO, X3_TIPO, X3_TAMANHO, X3_DECIMAL, X3_TITULO
               FROM SX3010 WHERE D_E_L_E_T_ = ' ' AND X3_ARQUIVO = 'F2D'
              ORDER BY X3_ORDEM;

  PEND-02  Chave do documento referenciado. A SF3 nao guarda a chave do
           referenciado e o item fiscal so tem numero, serie e item de
           origem. Hoje quem resolve documento referenciado e a familia
           DHLSafx116; integrar as duas depende do leiaute oficial.

  PEND-03  Sub-serie e CFOP do cabecalho seguem em branco, como na SAFX07.

@type   method
@author Pablo Regis
@since  23/11/2026
/*/
method notFieldRequired() class DHLSafx3007

	::addField(F3007_SUB_SERIE_DOCFIS , " ")
	::addField(F3007_COD_CFO          , " ")
	::addField(F3007_CHAVE_DOCFIS_REF , " ")

	// PEND-01 - sem campo confirmado na F2D
	::addField(F3007_VLR_RED_IBS_UF       , 0, .F.)
	::addField(F3007_VLR_DIF_IBS_UF       , 0, .F.)
	::addField(F3007_VLR_CRED_PRES_IBS_UF , 0, .F.)
	::addField(F3007_VLR_RED_IBS_MUN      , 0, .F.)
	::addField(F3007_VLR_DIF_IBS_MUN      , 0, .F.)
	::addField(F3007_VLR_CRED_PRES_IBS_MUN, 0, .F.)
	::addField(F3007_VLR_RED_CBS          , 0, .F.)
	::addField(F3007_VLR_DIF_CBS          , 0, .F.)
	::addField(F3007_VLR_CRED_PRES_CBS    , 0, .F.)

	// rastreio - semantica a confirmar no manual oficial
	::addField(F3007_IDENTIF_DOCFIS   , " ")
	::addField(F3007_COD_SISTEMA_ORIG , " ")

return
