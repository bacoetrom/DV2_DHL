// Colunas e parametros da leitura dos tributos da Reforma Tributaria
// (Configurador de Tributos - F2D / CJ3) para a familia SAFX.
//
// Usado por DHLSafxRtc.prw (monta a SQL) e pelas classes DHLSafx3007 /
// DHLSafx3008 (leem os valores do cursor). Os nomes tem no maximo 8
// caracteres de proposito: colunas de query via TOPCONN viram nomes de campo
// de alias, limitados a 10 caracteres.
//
// Pablo Regis 23/11/2026

// chave de ligacao com a SFT (FT_IDTRIB) / SD1-SD2 (D1_IDTRIB / D2_IDTRIB)
#define RTC_COL_IDREL     "IDREL"

// IBS estadual
#define RTC_COL_BAS_UF    "RTCBASUF"
#define RTC_COL_ALQ_UF    "RTCALQUF"
#define RTC_COL_VLR_UF    "RTCVLRUF"
#define RTC_COL_CST_UF    "RTCCSTUF"

// IBS municipal
#define RTC_COL_BAS_MU    "RTCBASMU"
#define RTC_COL_ALQ_MU    "RTCALQMU"
#define RTC_COL_VLR_MU    "RTCVLRMU"
#define RTC_COL_CST_MU    "RTCCSTMU"

// CBS
#define RTC_COL_BAS_CB    "RTCBASCB"
#define RTC_COL_ALQ_CB    "RTCALQCB"
#define RTC_COL_VLR_CB    "RTCVLRCB"
#define RTC_COL_CST_CB    "RTCCSTCB"

// Imposto Seletivo
#define RTC_COL_BAS_IS    "RTCBASIS"
#define RTC_COL_ALQ_IS    "RTCALQIS"
#define RTC_COL_VLR_IS    "RTCVLRIS"
#define RTC_COL_CST_IS    "RTCCSTIS"

// Classificacao tributaria (cClassTrib) - campo da CJ3 definido em ZZ_SFXCCLT
#define RTC_COL_CLSTRIB   "RTCCLSTR"

// Parametros (SX6) e defaults. Os tres primeiros ja existem no projeto,
// usados pelo DHLIdManager.prw.
#define RTC_PAR_TRIB_UF   "ZZ_TRIBSUF"
#define RTC_DEF_TRIB_UF   "TR0002"
#define RTC_PAR_TRIB_MU   "ZZ_TRIBSMU"
#define RTC_DEF_TRIB_MU   "TR0003"
#define RTC_PAR_TRIB_CB   "ZZ_TRIBCBS"
#define RTC_DEF_TRIB_CB   "TR0001"
#define RTC_PAR_TRIB_IS   "ZZ_TRIBSEL"
#define RTC_PAR_CCLASTR   "ZZ_SFXCCLT"

// Alias da tabela derivada com os tributos pre-agregados
#define RTC_ALIAS_AGREG   "RTC"
