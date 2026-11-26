// Layout Mastersaf / ONESOURCE Tax One - SAFX3008
// Itens do documento fiscal baseados nas tabelas da Reforma Tributaria
//
// ===========================================================================
// ATENCAO - LEIAUTE PRELIMINAR (NAO HOMOLOGADO)
// ===========================================================================
// Mesma condicao do safx3007.ch: o manual oficial da SAFX3008 nao esta
// disponivel no projeto (Plano_Execucao_NFe_2027_IBS_CBS.md, Fase 0 item 4,
// BLOQUEANTE). O bloco de identificacao (1 a 27) espelha a semantica da
// SAFX08 (PROTHEUS/Includes/safx08.ch), unico leiaute de item confirmado.
// A geracao fica desligada pelo parametro ZZ_SFX3007 (default .F.).
//
// Prefixo F3008_ pelo mesmo motivo descrito no safx3007.ch.
//
// Pablo Regis 23/11/2026
// ===========================================================================

// ---------------------------------------------------------------------------
// Identificacao do item (espelha a semantica da SAFX08 - A CONFIRMAR)
// ---------------------------------------------------------------------------
#define F3008_COD_EMPRESA                 {1,3}
#define F3008_COD_ESTAB                   {2,6}
#define F3008_DATA_FISCAL                 {3,8}
#define F3008_MOVTO_E_S                   {4,1}
#define F3008_NORM_DEV                    {5,1}
#define F3008_COD_DOCTO                   {6,5}
#define F3008_IND_FIS_JUR                 {7,1}
#define F3008_COD_FIS_JUR                 {8,14}
#define F3008_NUM_DOCFIS                  {9,12}
#define F3008_SERIE_DOCFIS                {10,3}
#define F3008_SUB_SERIE_DOCFIS            {11,2}
#define F3008_CHAVE_DOCFIS                {12,44}
#define F3008_NUM_ITEM                    {13,5}
#define F3008_IND_PRODUTO                 {14,1}
#define F3008_COD_PRODUTO                 {15,35}
#define F3008_DESCRICAO_COMPL             {16,50}
#define F3008_COD_NBM                     {17,10}
#define F3008_COD_CFO                     {18,4}
#define F3008_COD_NATUREZA_OP             {19,3}
#define F3008_QUANTIDADE                  {20,17,6}
#define F3008_COD_MEDIDA                  {21,3}
#define F3008_VLR_UNIT                    {22,19,4}
#define F3008_VLR_ITEM                    {23,17,2}
#define F3008_VLR_DESCONTO                {24,17,2}
#define F3008_VLR_FRETE_ITEM              {25,17,2}
#define F3008_VLR_SEGURO_ITEM             {26,17,2}
#define F3008_VLR_OUTRAS_ITEM             {27,17,2}
#define F3008_COD_CLASS_TRIB              {28,6}

// ---------------------------------------------------------------------------
// IBS estadual - F2D / parametro ZZ_TRIBSUF
// ---------------------------------------------------------------------------
#define F3008_VLR_BASE_IBS_UF             {29,17,2}
#define F3008_ALIQ_IBS_UF                 {30,7,4}
#define F3008_VLR_IBS_UF                  {31,17,2}
#define F3008_VLR_RED_IBS_UF              {32,17,2}
#define F3008_VLR_DIF_IBS_UF              {33,17,2}
#define F3008_VLR_CRED_PRES_IBS_UF        {34,17,2}
#define F3008_CST_IBS_UF                  {35,3}

// ---------------------------------------------------------------------------
// IBS municipal - F2D / parametro ZZ_TRIBSMU
// ---------------------------------------------------------------------------
#define F3008_VLR_BASE_IBS_MUN            {36,17,2}
#define F3008_ALIQ_IBS_MUN                {37,7,4}
#define F3008_VLR_IBS_MUN                 {38,17,2}
#define F3008_VLR_RED_IBS_MUN             {39,17,2}
#define F3008_VLR_DIF_IBS_MUN             {40,17,2}
#define F3008_VLR_CRED_PRES_IBS_MUN       {41,17,2}
#define F3008_CST_IBS_MUN                 {42,3}

// ---------------------------------------------------------------------------
// CBS - F2D / parametro ZZ_TRIBCBS
// ---------------------------------------------------------------------------
#define F3008_VLR_BASE_CBS                {43,17,2}
#define F3008_ALIQ_CBS                    {44,7,4}
#define F3008_VLR_CBS                     {45,17,2}
#define F3008_VLR_RED_CBS                 {46,17,2}
#define F3008_VLR_DIF_CBS                 {47,17,2}
#define F3008_VLR_CRED_PRES_CBS           {48,17,2}
#define F3008_CST_CBS                     {49,3}

// ---------------------------------------------------------------------------
// Imposto Seletivo - F2D / parametro ZZ_TRIBSEL
// ---------------------------------------------------------------------------
#define F3008_VLR_BASE_IS                 {50,17,2}
#define F3008_ALIQ_IS                     {51,7,4}
#define F3008_VLR_IS                      {52,17,2}
#define F3008_CST_IS                      {53,3}

// ---------------------------------------------------------------------------
// Documento / item referenciado e rastreio
// ---------------------------------------------------------------------------
#define F3008_NUM_DOCFIS_REF              {54,12}
#define F3008_SERIE_DOCFIS_REF            {55,3}
#define F3008_NUM_ITEM_REF                {56,5}
#define F3008_CHAVE_DOCFIS_REF            {57,44}
#define F3008_IDENTIF_DOCFIS              {58,128}
#define F3008_COD_SISTEMA_ORIG            {59,4}

// quantidade de colunas
#define SAFX3008_POSICOES    59

// titulo do erro
#define SAFX3008_ERROR_TITLE     "Falha da Exportacao SAFX3008"
#define SAFX3008_ERROR_OBRIGAT   "Obrigatorio - "
#define SAFX3008_ERROR_NIL       " Posicao do layout nao preenchida pela rotina "

// campos obrigatorios - somente identificacao (ver nota no safx3007.ch)
#define VLD_3008_FIELD  {  {F3008_COD_EMPRESA      ,"CODIGO EMPRESA"},;
                           {F3008_COD_ESTAB        ,"CODIGO DO ESTABELECIMENTO"},;
                           {F3008_DATA_FISCAL      ,"DATA DA ESCRITA FISCAL"},;
                           {F3008_MOVTO_E_S        ,"MOVIMENTO ENTRADA/SAIDA"},;
                           {F3008_NORM_DEV         ,"NORMAL OU DEVOLUCAO"},;
                           {F3008_COD_DOCTO        ,"TIPO DO DOCUMENTO"},;
                           {F3008_IND_FIS_JUR      ,"INDICADOR PESSOA FISICA/JURIDICA"},;
                           {F3008_COD_FIS_JUR      ,"CODIGO DO DESTINATARIO/EMITENTE"},;
                           {F3008_NUM_DOCFIS       ,"NUMERO DO DOCUMENTO FISCAL"},;
                           {F3008_SERIE_DOCFIS     ,"SERIE DO DOCUMENTO FISCAL"},;
                           {F3008_NUM_ITEM         ,"ITEM DA NOTA FISCAL"},;
                           {F3008_COD_PRODUTO      ,"PRODUTO"},;
                           {F3008_COD_MEDIDA       ,"UNIDADE DE MEDIDA"}  }
