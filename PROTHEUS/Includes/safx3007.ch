// Layout Mastersaf / ONESOURCE Tax One - SAFX3007
// Documento fiscal (cabecalho) baseado nas tabelas da Reforma Tributaria
//
// ===========================================================================
// ATENCAO - LEIAUTE PRELIMINAR (NAO HOMOLOGADO)
// ===========================================================================
// O manual oficial da SAFX3007 (versao / data) NAO esta disponivel no projeto.
// Ver Plano_Execucao_NFe_2027_IBS_CBS.md, Fase 0 item 4 - pre-requisito
// BLOQUEANTE. Enquanto o manual nao chegar:
//
//   1. a ORDEM, o TAMANHO, as DECIMAIS e a OBRIGATORIEDADE de cada campo
//      abaixo sao PRELIMINARES. O bloco de identificacao (1 a 28) espelha a
//      semantica da SAFX07, que e o unico leiaute de documento fiscal
//      confirmado no projeto (PROTHEUS/Includes/safx07.ch);
//   2. o arquivo gerado NAO deve ser enviado ao importador da Thomson
//      Reuters. A geracao fica desligada pelo parametro ZZ_SFX3007
//      (default .F.) - ver SAFX3007MSDW.prw;
//   3. ao receber o manual, ajustar SOMENTE este include. Os fontes
//      DHLSafx3007.prw e SAFX3008MSDW.prw referenciam os campos por nome,
//      nunca por posicao literal.
//
// Os defines usam o prefixo F3007_ de proposito: SAFX3007MSDW.prw inclui
// safx3007.ch e safx3008.ch no mesmo fonte, e os nomes curtos (COD_EMPRESA,
// NUM_DOCFIS, ...) colidem entre os leiautes da familia SAFX.
//
// Pablo Regis 23/11/2026
// ===========================================================================

// ---------------------------------------------------------------------------
// Identificacao do documento (espelha a semantica da SAFX07 - A CONFIRMAR)
// ---------------------------------------------------------------------------
#define F3007_COD_EMPRESA                 {1,3}
#define F3007_COD_ESTAB                   {2,6}
#define F3007_MOVTO_E_S                   {3,1}
#define F3007_NORM_DEV                    {4,1}
#define F3007_COD_DOCTO                   {5,5}
#define F3007_IDENT_FIS_JUR               {6,1}
#define F3007_COD_FIS_JUR                 {7,14}
#define F3007_NUM_DOCFIS                  {8,12}
#define F3007_SERIE_DOCFIS                {9,3}
#define F3007_SUB_SERIE_DOCFIS            {10,2}
#define F3007_COD_MODELO                  {11,2}
#define F3007_COD_CLASS_DOC_FIS           {12,1}
#define F3007_DATA_EMISSAO                {13,8}
#define F3007_DATA_SAIDA_REC              {14,8}
#define F3007_DATA_ESCRITURACAO           {15,8}
#define F3007_CHAVE_DOCFIS                {16,44}
#define F3007_COD_SIT_DOCFIS              {17,2}
#define F3007_SITUACAO                    {18,1}
#define F3007_DATA_CANCELAMENTO           {19,8}
#define F3007_CHAVE_DOCFIS_REF            {20,44}
#define F3007_NUM_DOCFIS_REF              {21,12}
#define F3007_SERIE_DOCFIS_REF            {22,3}
#define F3007_IND_FINALIDADE              {23,1}
#define F3007_UF_ORIG_DEST                {24,2}
#define F3007_COD_MUNIC_ORIG              {25,7}
#define F3007_COD_MUNIC_DEST              {26,7}
#define F3007_COD_CFO                     {27,4}
#define F3007_COD_NATUREZA_OP             {28,3}

// ---------------------------------------------------------------------------
// Valores do documento
// ---------------------------------------------------------------------------
#define F3007_VLR_PRODUTO                 {29,17,2}
#define F3007_VLR_TOT_NOTA                {30,17,2}
#define F3007_VLR_DESCONTO                {31,17,2}
#define F3007_VLR_FRETE                   {32,17,2}
#define F3007_VLR_SEGURO                  {33,17,2}
#define F3007_VLR_OUTRAS                  {34,17,2}

// ---------------------------------------------------------------------------
// IBS estadual - F2D / parametro ZZ_TRIBSUF
// ---------------------------------------------------------------------------
#define F3007_VLR_BASE_IBS_UF             {35,17,2}
#define F3007_ALIQ_IBS_UF                 {36,7,4}
#define F3007_VLR_IBS_UF                  {37,17,2}
#define F3007_VLR_RED_IBS_UF              {38,17,2}
#define F3007_VLR_DIF_IBS_UF              {39,17,2}
#define F3007_VLR_CRED_PRES_IBS_UF        {40,17,2}
#define F3007_CST_IBS_UF                  {41,3}

// ---------------------------------------------------------------------------
// IBS municipal - F2D / parametro ZZ_TRIBSMU
// ---------------------------------------------------------------------------
#define F3007_VLR_BASE_IBS_MUN            {42,17,2}
#define F3007_ALIQ_IBS_MUN                {43,7,4}
#define F3007_VLR_IBS_MUN                 {44,17,2}
#define F3007_VLR_RED_IBS_MUN             {45,17,2}
#define F3007_VLR_DIF_IBS_MUN             {46,17,2}
#define F3007_VLR_CRED_PRES_IBS_MUN       {47,17,2}
#define F3007_CST_IBS_MUN                 {48,3}

// ---------------------------------------------------------------------------
// CBS - F2D / parametro ZZ_TRIBCBS
// ---------------------------------------------------------------------------
#define F3007_VLR_BASE_CBS                {49,17,2}
#define F3007_ALIQ_CBS                    {50,7,4}
#define F3007_VLR_CBS                     {51,17,2}
#define F3007_VLR_RED_CBS                 {52,17,2}
#define F3007_VLR_DIF_CBS                 {53,17,2}
#define F3007_VLR_CRED_PRES_CBS           {54,17,2}
#define F3007_CST_CBS                     {55,3}

// ---------------------------------------------------------------------------
// Imposto Seletivo - F2D / parametro ZZ_TRIBSEL
// ---------------------------------------------------------------------------
#define F3007_VLR_BASE_IS                 {56,17,2}
#define F3007_ALIQ_IS                     {57,7,4}
#define F3007_VLR_IS                      {58,17,2}
#define F3007_CST_IS                      {59,3}

// ---------------------------------------------------------------------------
// Totalizadores e rastreio
// ---------------------------------------------------------------------------
#define F3007_VLR_TOT_IBS                 {60,17,2}
#define F3007_VLR_TOT_TRIB_RTC            {61,17,2}
#define F3007_COD_CLASS_TRIB              {62,6}
#define F3007_IDENTIF_DOCFIS              {63,128}
#define F3007_COD_SISTEMA_ORIG            {64,4}

// quantidade de colunas
#define SAFX3007_POSICOES    64

// titulo do erro
#define SAFX3007_ERROR_TITLE     "Falha da Exportacao SAFX3007"
#define SAFX3007_ERROR_OBRIGAT   "Obrigatorio - "
#define SAFX3007_ERROR_NIL       " Posicao do layout nao preenchida pela rotina "

// campos obrigatorios - somente identificacao.
// Campos de valor NAO entram aqui: formatValue() converte zero em "@" (nulo)
// e validRequired() trataria o zero legitimo como ausencia.
#define VLD_3007_FIELD  {  {F3007_COD_EMPRESA        ,"CODIGO EMPRESA"},;
                           {F3007_COD_ESTAB          ,"CODIGO DO ESTABELECIMENTO"},;
                           {F3007_MOVTO_E_S          ,"MOVIMENTO ENTRADA/SAIDA"},;
                           {F3007_NORM_DEV           ,"NORMAL OU DEVOLUCAO"},;
                           {F3007_COD_DOCTO          ,"TIPO DO DOCUMENTO"},;
                           {F3007_IDENT_FIS_JUR      ,"INDICADOR PESSOA FISICA/JURIDICA"},;
                           {F3007_COD_FIS_JUR        ,"CODIGO DO DESTINATARIO/EMITENTE"},;
                           {F3007_NUM_DOCFIS         ,"NUMERO DO DOCUMENTO FISCAL"},;
                           {F3007_DATA_EMISSAO       ,"DATA EMISSAO"},;
                           {F3007_COD_MODELO         ,"MODELO DE DOCUMENTO"},;
                           {F3007_COD_CLASS_DOC_FIS  ,"CLASSIFICACAO DO DOCUMENTO FISCAL"},;
                           {F3007_SITUACAO           ,"SITUACAO DA NOTA"}  }

// Finalidade do documento na Reforma Tributaria (F*_TIPO)
#define SAFX3007_FIN_NORMAL      "1"
#define SAFX3007_FIN_CREDITO     "5"
#define SAFX3007_FIN_DEBITO      "6"

// Nomes das colunas do array de totais do documento, totalizado pelo driver
// a partir do cursor de itens (SFT) e consumido por DHLSafx3007 via
// DHLSafx:getFieldValue(cCampo, aTotRtc). Convivem no mesmo array com as
// colunas RTC_COL_* definidas em safxrtc.ch.
#define TOT_COL_PROD     "TOTPROD"
#define TOT_COL_DESC     "TOTDESC"
#define TOT_COL_FRETE    "TOTFRETE"
#define TOT_COL_SEG      "TOTSEG"
#define TOT_COL_OUTRA    "TOTOUTRA"
#define TOT_COL_CONT     "TOTCONT"
