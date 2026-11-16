//campos do layout
#define COD_EMPRESA                    {1,3}
#define COD_ESTAB                      {2,6}
#define DATA_FISCAL                    {3,8}
#define MOVTO_E_S                      {4,1}
#define NORM_DEV                       {5,1}
#define COD_DOCTO                      {6,5}
#define IND_FIS_JUR                    {7,1}
#define COD_FIS_JUR                    {8,14}
#define NUM_DOCFIS                     {9,12}
#define SERIE_DOCFIS                   {10,3}
#define SUB_SERIE_DOCFIS               {11,2}
#define COD_OBS_LANCTO_FISCAL          {12,8}
#define NUM_DOCFIS_REF                 {13,12}
#define SERIE_DOCFIS_REF               {14,3}
#define SUB_SERIE_DOCFIS_REF           {15,2}
#define MOVTO_E_S_REF                  {16,1}
#define IND_FIS_JUR_REF                {17,1}
#define COD_FIS_JUR_REF                {18,14}
#define DATA_FISCAL_REF                {19,8}
#define COD_MODELO_REF                 {20,2}
#define NUM_AUTENTIC_NFE			   {21,80}


//quantidade de colunas
#define SAFX116_POSICOES		21


//Titulo do erro 
#define SAFX116_ERROR_TITLE				"Falha da Exportacao SAFX116"
#define SAFX116_ERROR_OBRIGAT 			"Obrigatorio - "

// campos obrigatorios
#define VLD_116_FIELD 			   {{COD_EMPRESA				,"CODIGO EMPRESA" },;
										 {COD_ESTAB  				,"CODIGO DO ESTABELECIMENTO"},;
										 {DATA_FISCAL 			,"DATA DA ESCRITA FISCAL"},;
										 {MOVTO_E_S	 			,"MOVIMENTO ENTRADA/SAIDA"},;
										 {NORM_DEV	 				,"NORMAL OU DEVOLUCAO"},;
										 {COD_DOCTO  				,"TIPO DO DOCUMENTO"},;
										 {IND_FIS_JUR				,"INDICADOR PESSOA FISICA /JURIDICA"},;
										 {COD_FIS_JUR				,"CODIGO DO DESTINATARIO/EMITENTE"},;
										 {NUM_DOCFIS				,"NUMERO DO DOCUMENTO FISCAL"},;
										 {NUM_DOCFIS_REF		    ,"NUMERO DO DOCUMENTO FISCAL"},;
										 {MOVTO_E_S_REF			,"MOVIMENTO ENTRADA/SAIDA"},;
										 {IND_FIS_JUR_REF			,"INDICADOR PESSOA FISICA/JURIDICA REF"},;
										 {COD_FIS_JUR_REF			,"CODIGO PESSOA FISICA /JURIDICA REF"	},;
										 {DATA_FISCAL_REF			,"DATA DE EMISSAO"},;
										 {COD_MODELO_REF			,"MODELO DO DOCUMENTO"}    }	 