#Include 'Protheus.ch'
#Include 'TopConn.ch'

#define X1_HELP		41

Static cPerg	:= 'FITR01'

//_____________________________________________________________________________
/*/{Protheus.doc} FITSCJ01
Neste relatorio será impresso as notas fiscais para CERAS JOHNSON;
NF Venda | NF Remessa | NF Ret Simbolico | NF Conta Ordem

@author Icaro Queiroz
@since 29 de Dezembro de 2017
@version P11
@owner FIT Gestao & Tecnologia - Solicitante: DHL
/*/
//_____________________________________________________________________________
User Function FITSCJ01()
Local aRegs		:= {}

Private oReport

************************
*Monta pergunte do Log *
************************
//CriaPerg()

If Pergunte( cPerg, .T. )
	Processa( { || ProcRank() }, 'Processando....' )
EndIf

If Select( 'TRBVLDE' ) > 0
	TRBVLDE->( dbCloseArea() )
EndIf

Return( Nil )


//_____________________________________________________________________________
/*/{Protheus.doc} ProcRank
Carrega os dados conforme parametrizacao feita pelo usuario;

@author Icaro Queiroz
@since 29 de Dezembro de 2017
@version P11
@owner FIT Gestao & Tecnologia - Solicitante: DHL
/*/
//_____________________________________________________________________________
Static Function ProcRank()

If Select( 'TRBVLDE' ) > 0
	TRBVLDE->( dbCloseArea() )
EndIf

BEGINSQL ALIAS 'TRBVLDE'
	 SELECT 	ZA_DOCSCJ NF_VENDA,
		ZA_SERISCJ SER_VENDA,
		ZA_DTEMSCJ EMIS_VENDA,
		D2_NFORI NF_REMESSA,
		D2_SERIORI SER_REMESSA,
		(SELECT D1_EMISSAO  FROM %table:SD1% SD1A WHERE D1_FILIAL = D2_FILIAL AND D1_DOC = D2_NFORI AND D1_SERIE = D2_SERIORI AND SD1A.%NotDel%  AND ROWNUM = 1 ) DT_REMESSA,
		(SELECT D1_CF FROM %table:SD1% SD1B WHERE D1_FILIAL = D2_FILIAL AND D1_DOC = D2_NFORI AND D1_SERIE = D2_SERIORI AND SD1B.%NotDel%  AND ROWNUM = 1 )  CFOP,
		D2_COD MATERIAL,
		ZA_NFRET NF_RET,
		ZA_SERIRET SER_RET,
		'1432243' PARCEIRO,
		'DHL LOGISTICS (BRAZIL) LTDA' NOME_PARC,
		CASE WHEN SUBSTRING( D2_CF, 1, 1 ) = '1' THEN '1' || SUBSTRING( D2_CF, 2, 3 ) ELSE '2' || SUBSTRING( D2_CF, 2, 3 ) END CFOP_RET,
		D2_QUANT QTDE,
		D2_UM UN,
		'4920' PLTA,
		D2_PRUNIT UNITARIO,
		D2_PRUNIT UNITARIO_ARRED,
		D2_TOTAL TOTAL_IT,
		D2_BASEICM ICMS_BASE,
		D2_BASEORI OUT_BASE_ICMS,
		D2_VALICM IMP_ICMS,
		D2_PICM PERC_ICMS,
		D2_BRICMS BASE_ICMS_ST,
		D2_ICMSRET ICMS_ST,
		CASE WHEN D2_ICMSRET = 0 THEN 0 ELSE D2_ALIQSOL END PERC_ICMS_ST,	
		F2_CHVNFE CHAVE,
		ZA_NFRCO NF_RCO,
		ZA_SERIRCO SER_RCO
	 FROM %table:SZA% SZA
	LEFT JOIN %table:SF2% SF2 ON SF2.%NotDel% AND F2_FILIAL = ZA_FILIAL AND F2_DOC = ZA_NFRET AND F2_SERIE = ZA_SERIRET 
	INNER JOIN %table:SD2% SD2 ON SD2.%NotDel% AND D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA
	WHERE SZA.%NotDel%
	  AND ZA_FILIAL = %exp:xFilial('SFT')%
	  AND ZA_DTEMSCJ BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	ORDER BY ZA_DTEMSCJ, ZA_DOCSCJ, ZA_SERISCJ

ENDSQL

oReport := ReportDef()

If oReport == Nil
	Return( Nil )
EndIf

oReport:PrintDialog()

Return( Nil )


//_____________________________________________________________________________
/*/{Protheus.doc} ReportDef
Monta impressao via TReport;

@author Icaro Queiroz
@since 29 de Dezembro de 2017
@version P11
@owner FIT Gestao & Tecnologia - Solicitante: DHL
/*/
//_____________________________________________________________________________
Static Function ReportDef()
Local oFirst
Local nOrd	:= 1

dbSelectArea( 'TRBVLDE' )

oReport := TReport():New( 'FITR001', 'Compras por fornecedor - De: ' + DtoC( MV_PAR01 ) + " até: " + DtoC( MV_PAR02 ), cPerg, {|oReport| ReportPrint( oReport ), 'Este relatório irá imprimir as compras por fornecedores ordenados pelo maior valor, respeitando os parâmetros informados pelo usuário' } )
oReport:lParamReadOnly := .T.
oReport:SetLandScape()

oReport:SetTotalInLine( .F. )

oFirst := TRSection():New( oReport, 'DHL | FIT Gestão', { 'TRBVLDE', 'SZA', 'SD2', 'SF2' },,, )

oFirst:SetTotalInLine( .F. )

TRCell():New( oFirst, 'NF_VENDA',	'TRBVLDE', RetTitle( 'ZA_DOCSCJ' ),	PesqPict( 'SZA', 'ZA_DOCSCJ' ),		TamSx3( 'ZA_DOCSCJ' )[1],,	{ || TRBVLDE->NF_VENDA } )
TRCell():New( oFirst, 'SER_VENDA',	'TRBVLDE', RetTitle( 'ZA_SERISCJ' ),PesqPict( 'SZA', 'ZA_SERISCJ' ),	TamSx3( 'ZA_SERISCJ' )[1],,	{ || TRBVLDE->SER_VENDA } )
TRCell():New( oFirst, 'EMIS_VENDA',	'TRBVLDE', RetTitle( 'ZA_SERISCJ' ),PesqPict( 'SZA', 'ZA_SERISCJ' ),	TamSx3( 'ZA_SERISCJ' )[1],,	{ || StoD( TRBVLDE->EMIS_VENDA ) } )
TRCell():New( oFirst, 'NF_REMESSA',	'TRBVLDE', RetTitle( 'D2_NFORI' ),	PesqPict( 'SD2', 'D2_NFORI' ),		TamSx3( 'D2_NFORI' )[1],,	{ || TRBVLDE->NF_REMESSA } )
TRCell():New( oFirst, 'SER_REMESSA','TRBVLDE', RetTitle( 'D2_SERIORI' ),PesqPict( 'SD2', 'D2_SERIORI' ),	TamSx3( 'D2_SERIORI' )[1],,	{ || TRBVLDE->SER_REMESSA } )
TRCell():New( oFirst, 'DT_REMESSA',	'TRBVLDE', "DATA",PesqPict("DA4","DA4_DATNAS") ,	TamSx3( 'ZA_SERISCJ' )[1],,	{ || StoD( TRBVLDE->DT_REMESSA ) } )
TRCell():New( oFirst, 'CFOP',	'TRBVLDE', RetTitle( 'D2_CF' ),		PesqPict( 'SD2', 'D2_CF' ),			TamSx3( 'D2_CF' )[1],,		{ || sfcfop( TRBVLDE->CFOP ) } )
TRCell():New( oFirst, 'MATERIAL',	'TRBVLDE', RetTitle( 'D2_COD' ),	PesqPict( 'SD2', 'D2_COD' ),		TamSx3( 'D2_COD' )[1],,		{ || TRBVLDE->MATERIAL } )
TRCell():New( oFirst, 'NF_RET',		'TRBVLDE', RetTitle( 'ZA_NFRET' ),	PesqPict( 'SZA', 'ZA_NFRET' ),		TamSx3( 'ZA_NFRET' )[1],,	{ || TRBVLDE->NF_RET } )
TRCell():New( oFirst, 'SER_RET',	'TRBVLDE', RetTitle( 'ZA_SERIRET' ),PesqPict( 'SZA', 'ZA_SERIRET' ),	TamSx3( 'ZA_SERIRET' )[1],,	{ || TRBVLDE->SER_RET } )
TRCell():New( oFirst, 'PARCEIRO',	'TRBVLDE', 'Parceiro'				,'@!',								10,,						{ || TRBVLDE->PARCEIRO } )
TRCell():New( oFirst, 'NOME_PARC',	'TRBVLDE', 'Nome Parceiro'			,'@!',								40,,						{ || TRBVLDE->NOME_PARC } )
TRCell():New( oFirst, 'CFOP_RET',	'TRBVLDE', RetTitle( 'D2_CF' ),		PesqPict( 'SD2', 'D2_CF' ),			TamSx3( 'D2_CF' )[1],,		{ || TRBVLDE->CFOP_RET } )
TRCell():New( oFirst, 'QTDE',		'TRBVLDE', RetTitle( 'D2_QUANT' ),	PesqPict( 'SD2', 'D2_QUANT' ),		TamSx3( 'D2_QUANT' )[1],,	{ || TRBVLDE->QTDE } )
TRCell():New( oFirst, 'UN',			'TRBVLDE', RetTitle( 'D2_UM' ),		PesqPict( 'SD2', 'D2_UM' ),			TamSx3( 'D2_UM' )[1],,		{ || TRBVLDE->UN } )
TRCell():New( oFirst, 'PLTA',		'TRBVLDE', 'PLTA',					'@!',								5,,							{ || TRBVLDE->PLTA } )
TRCell():New( oFirst, 'UNITARIO',	'TRBVLDE', RetTitle( 'D2_PRUNIT' ),	PesqPict( 'SD2', 'D2_PRUNIT' ),		TamSx3( 'D2_PRUNIT' )[1],,	{ || TRBVLDE->UNITARIO } )
//TRCell():New( oFirst, 'UNITARIO_ARRED',	'TRBVLDE', 'Valor Arre',	PesqPict( 'SD2', 'D2_PRUNIT' ),		TamSx3( 'D2_PRUNIT' )[1],,	{ || TRBVLDE->UNITARIO_ARRED } )
TRCell():New( oFirst, 'TOTAL_IT',	'TRBVLDE', RetTitle( 'D2_TOTAL' ),	PesqPict( 'SD2', 'D2_TOTAL' ),		TamSx3( 'D2_TOTAL' )[1],,	{ || TRBVLDE->TOTAL_IT } )
TRCell():New( oFirst, 'ICMS_BASE',	'TRBVLDE', RetTitle( 'D2_BASEICM' ),PesqPict( 'SD2', 'D2_BASEICM' ),	TamSx3( 'D2_BASEICM' )[1],,	{ || TRBVLDE->ICMS_BASE } )
TRCell():New( oFirst, 'OUT_BASE_ICMS','TRBVLDE', RetTitle( 'D2_BASEORI' ),PesqPict( 'SD2', 'D2_BASEORI' ),	TamSx3( 'D2_BASEORI' )[1],,	{ || TRBVLDE->OUT_BASE_ICMS } )
TRCell():New( oFirst, 'IMP_ICMS',	'TRBVLDE', RetTitle( 'D2_VALICM' ),	PesqPict( 'SD2', 'D2_VALICM' ),		TamSx3( 'D2_VALICM' )[1],,	{ || TRBVLDE->IMP_ICMS } )
TRCell():New( oFirst, 'PERC_ICMS',	'TRBVLDE', RetTitle( 'D2_PICM' ),	PesqPict( 'SD2', 'D2_PICM' ),		TamSx3( 'D2_PICM' )[1],,	{ || TRBVLDE->PERC_ICMS } )
TRCell():New( oFirst, 'BASE_ICMS_ST','TRBVLDE', RetTitle( 'D2_BRICMS' ),PesqPict( 'SD2', 'D2_BRICMS' ),		TamSx3( 'D2_BRICMS' )[1],,	{ || TRBVLDE->BASE_ICMS_ST } )
TRCell():New( oFirst, 'ICMS_ST',	'TRBVLDE', RetTitle( 'D2_ICMSRET' ),PesqPict( 'SD2', 'D2_ICMSRET' ),	TamSx3( 'D2_ICMSRET' )[1],,	{ || TRBVLDE->ICMS_ST } )
TRCell():New( oFirst, 'PERC_ICMS_ST','TRBVLDE', RetTitle( 'D2_ALIQSOL' ),PesqPict( 'SD2', 'D2_ALIQSOL' ),	TamSx3( 'D2_ALIQSOL' )[1],,	{ || TRBVLDE->PERC_ICMS_ST } )
TRCell():New( oFirst, 'CHAVE',		'TRBVLDE', RetTitle( 'F2_CHVNFE' ),	PesqPict( 'SF2', 'F2_CHVNFE' ),		TamSx3( 'F2_CHVNFE' )[1],,	{ || TRBVLDE->CHAVE } )
TRCell():New( oFirst, 'NF_RCO',		'TRBVLDE', RetTitle( 'ZA_NFRCO' ),	PesqPict( 'SZA', 'ZA_NFRCO' ),		TamSx3( 'ZA_NFRCO' )[1],,	{ || TRBVLDE->NF_RCO } )
TRCell():New( oFirst, 'SER_RCO',	'TRBVLDE', RetTitle( 'ZA_SERIRCO' ),PesqPict( 'SZA', 'ZA_SERIRCO' ),	TamSx3( 'ZA_SERIRCO' )[1],,	{ || TRBVLDE->SER_RCO } )


//oBreakT := TRBreak():New( oFirst, { || }, 'Total geral' )
//TRFunction():New( oFirst:Cell( 'TOTAL' ),	'', 'SUM', oBreakT,,,, .F., .F. )

oFirst:SetColSpace(7)

Return( oReport )


//_____________________________________________________________________________
/*/{Protheus.doc} ReportPrint
Rotina responsavel pela busca e carregamentos dos dados a serem impressos;

@author Icaro Queiroz
@since 29 de Dezembro de 2017
@version P11
@owner FIT Gestao & Tecnologia - Solicitante: DHL
/*/
//_____________________________________________________________________________
Static Function ReportPrint( oReport )

MakeAdvplExpr( cPerg )
oReport:Section(1):Enable()

dbSelectArea( 'TRBVLDE' )
oReport:Section(1):Print()

Return( Nil )

static function sfcfop( ccfop_i )
local ccfop_o 	:="" 
local cini		:= substr( ccfop_i ,1,1 )

ccfop_o := if(cini="1","5",if(cini="2","6","7")) + substr( ccfop_i , 2,3 )

return( ccfop_o )

Static Function  CriaPerg()

	local cValid	:= ""
	local cF3		:= ""
	local cPicture	:= ""
	local cDef01	:= ""
	local cDef02	:= ""
	local cDef03	:= ""
	local cDef04	:= ""
	local cDef05	:= ""
	local i			:= 0
	local j			:= 0
	local nTamSX1	:= 0
	local aRegs		:= {}
	local aAreaSX1 	:= SX1->(GetArea())
	local oObj
	
	oObj := FWSX1Util():New()	
	oObj:AddGroup(cPerg)
    oObj:SearchGroup()
    nTamSX1 := len(oObj:aGrupo[1][1])
	cPerg := PadR(cPerg,nTamSX1)
	
	aAdd(aRegs,{cPerg/*X1_GRUPO*/, "01"/*X1_ORDEM*/, "Data Emissao de?"/*X1_PERGUNT*/,""/*X1_PERSPA*/,""/*X1_PERENG*/,"MV_CH1"/*X1_VARIAVL*/, "D"/*X1_TIPO*/,8/*X1_TAMANHO*/,0/*X1_DECIMAL*/,1/*X1_PRESEL*/, "G"/*X1_GSC*/, "NaoVazio()"/*X1_VALID*/, "MV_PAR01"/*X1_VAR01*/, cDef01/*X1_DEF01*/, ""/*X1_DEFSPA1*/,""/*X1_DEFENG1*/,""/*X1_CNT01*/,""/*X1_VAR02*/,cDef02/*X1_DEF02*/,""/*X1_DEFSPA2*/,""/*X1_DEFENG2*/,""/*X1_CNT02*/,""/*X1_VAR03*/,cDef03/*X1_DEF03*/,""/*X1_DEFSPA3*/,""/*X1_DEFENG3*/,""/*X1_CNT03*/,""/*X1_VAR04*/,cDef04/*X1_DEF04*/,""/*X1_DEFSPA4*/,""/*X1_DEFENG4*/,""/*X1_CNT04*/,""/*X1_VAR05*/,cDef05/*X1_DEF05*/,""/*X1_DEFSPA5*/,""/*X1_DEFENG5*/,""/*X1_CNT05*/,cF3/*X1_F3*/, ""/*X1_PYME*/, ""/*X1_GRPSXG*/, "Informe a data de emissao de"/*X1_HELP*/, cPicture/*X1_PICTURE*/,""/*X1_IDFIL*/})
	aAdd(aRegs,{cPerg/*X1_GRUPO*/, "02"/*X1_ORDEM*/, "Data Emissao ate?"/*X1_PERGUNT*/,""/*X1_PERSPA*/,""/*X1_PERENG*/,"MV_CH2"/*X1_VARIAVL*/, "D"/*X1_TIPO*/,8/*X1_TAMANHO*/,0/*X1_DECIMAL*/,1/*X1_PRESEL*/, "G"/*X1_GSC*/, "(mv_par02 >= mv_par01)"/*X1_VALID*/, "MV_PAR02"/*X1_VAR01*/, cDef01/*X1_DEF01*/, ""/*X1_DEFSPA1*/,""/*X1_DEFENG1*/,""/*X1_CNT01*/,""/*X1_VAR02*/,cDef02/*X1_DEF02*/,""/*X1_DEFSPA2*/,""/*X1_DEFENG2*/,""/*X1_CNT02*/,""/*X1_VAR03*/,cDef03/*X1_DEF03*/,""/*X1_DEFSPA3*/,""/*X1_DEFENG3*/,""/*X1_CNT03*/,""/*X1_VAR04*/,cDef04/*X1_DEF04*/,""/*X1_DEFSPA4*/,""/*X1_DEFENG4*/,""/*X1_CNT04*/,""/*X1_VAR05*/,cDef05/*X1_DEF05*/,""/*X1_DEFSPA5*/,""/*X1_DEFENG5*/,""/*X1_CNT05*/,cF3/*X1_F3*/, ""/*X1_PYME*/, ""/*X1_GRPSXG*/, "Informe a data de emissao ate"/*X1_HELP*/, cPicture/*X1_PICTURE*/,""/*X1_IDFIL*/})
	
	for i := 1 to Len(aRegs)
		if !SX1->(dbSeek(cPerg+aRegs[i,2]))
			SX1->(RecLock("SX1", .T.))
			for j := 1 to SX1->(FCount())
				if j <= Len(aRegs[i])
					if j <> X1_HELP
						SX1->(FieldPut(j, aRegs[i,j]))
					else
						if !empty(aRegs[i,j])
							SX1->(FieldPut(j, "P."+AllTrim(cPerg)+AllTrim(aRegs[i,2])+"."))
							PutHelp("P."+AllTrim(cPerg)+AllTrim(aRegs[i,2])+".", {aRegs[i,j]}, {aRegs[i,j]}, {aRegs[i,j]}, .T. )
						endif
					endif
				endIf
			next j
			SX1->(MsUnlock("SX1"))
		endif
	next i
	
	RestArea(aAreaSX1)

Return