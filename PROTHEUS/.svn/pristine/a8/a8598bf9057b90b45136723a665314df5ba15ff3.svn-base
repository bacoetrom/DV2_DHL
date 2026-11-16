#Include 'Protheus.ch'
/*/{Protheus.doc} relNfCredDeb

Relatorio Notas Fiscais Credito e Debito

@author Cassiano Gonçalves Ribeiro
@since 13/06/2016
/*/
user function relNfCredDeb()
	
	local oReport := Nil
	
	private oFont14		:= TFont():New("Arial",09,14,		,.T.,,,,,.F.) // Parametros TFonte("Tipo Fonte",,Tamanho Fonte,,,Italico (.T./.F.))
	private oFont12B	:= TFont():New("Arial",09,12,		,.T.,,,,,.F.) // Negrito
	private oFont12Bs	:= TFont():New("Arial",09,12,.T.	,.T.,,,,,.T.) // Negrito - Sublinhado
	private oFont12		:= TFont():New("Arial",09,12,   	,.F.,,,,,.F.) // Nornal
	private oFont10		:= TFont():New("Arial",08,08,		,.F.,,,,,.F.) // Normal
	private oFont10a	:= TFont():New("MS Sans Serif",09,09,,.F.,,,,,.F.)// Normal
	private oFont3 		:= TFont():New("Arial",09,10,.T.	,.T.,,,,,.F.) // Negrito
	private oFont4 		:= TFont():New("Arial",09,14,.T.	,.T.,,,,,.T.) // Negrito - Sublinhado
	private oFont5 		:= TFont():New("Arial",09,10,   	,.F.,,,,,.F.) // Negrito
	private oFont16B	:= TFont():New("Arial",09,16,.T.	,.T.,,,,,.F.) // Negrito
	
	if perg()
		
		oReport := ReportDef()
		
		//Configurando layout e no. pagina.
		oReport:SetPageNumber(1)
		oReport:PrintDialog()
	endIf
	
return

// Definição do layout do Relatório
static function ReportDef()
	
	local oReport   := nil
	local oSection  := nil
//	local oCel1 	:= nil
//	local oCel2 	:= nil
//	local oCel3 	:= nil
//	local oCel4 	:= nil
//	local oCel5 	:= nil
//	local oCel6 	:= nil
//	local oCel7 	:= nil
//	local oCel8 	:= nil
//	local oCel9 	:= nil
//	local oCel10 	:= nil
//	local oCel11	:= nil
//	local oCel12	:= nil
//	local oCel13	:= nil
//	local oCel14	:= nil
//	local oCel15	:= nil
	local nTamData  := Len(DTOC(MsDate()))
	
	oReport := TReport():New("RELNFCREDEB","RELATÓRIO DE NOTAS FISCAIS DE CRÉDITO E DÉBITO - "+"De: "+DtoC(MV_PAR07)+" Até: "+DtoC(MV_PAR08),	{|| Perg()},{|oReport| PrintReport(oReport) })
	oReport:SetLandScape()	// Impressao em Paisagem
	oReport:SetTotalInLine(.F.)
	
	oSection := TRSection():New(oReport,"Notas de Remessa + Cobertura + Recusa (formulário proprio e XML)" + Space(100) + "Nota de ICMS (Débito)" + Space(100) + "Notas para os Representantes + Devolução para a Pfizer ou Wyeth" + Space(100) + "Nota de ICMS (Crédito / Estorno do Débito)" + Space(100) + "Recusas (Formulário Proprio e XML do Representante)")
	oSection:AutoSize()
	oSection:SetTotalInLine(.F.)
		
	oCel1 := TRCell():New(oSection,"P6CLIENTE"				,"", "Cliente"			,Nil,TamSX3("A1_NOME")[1])
	oCel1:oFontBody := oFont10	
	oCel2 := TRCell():New(oSection,"P3DOC"					,"", "Documento"		,Nil,TamSX3("F1_DOC")[1] + 5)
	oCel2:oFontBody := oFont10	
	oCel3 := TRCell():New(oSection,"P3SERIE"				,"", "Série"			,Nil,TamSX3("F1_SERIE")[1])
	oCel3:oFontBody := oFont10
	oCel4 := TRCell():New(oSection,"P3DTDIGIT"				,"", "Digitação"		,Nil,nTamData)
	oCel4:oFontBody := oFont10
	oCel5 := TRCell():New(oSection,"P3CFOP"					,"", "CFOP"				,Nil,TamSX3("F4_CF")[1])
	oCel5:oFontBody := oFont10
	oCel6 := TRCell():New(oSection,"P3TES"					,"", "TES"				,Nil,TamSX3("F4_CODIGO")[1])
	oCel6:oFontBody := oFont10
	oCel7 := TRCell():New(oSection,"P3QUANT"				,"", "Qtde."			,PesqPict("SD1","D1_QUANT"),TamSX3("D1_QUANT")[1])
	oCel7:oFontBody := oFont10
	oCel8 := TRCell():New(oSection,"P3PRECO"				,"", "Preço"			,PesqPict("SD1","D1_VUNIT"),TamSX3("D1_VUNIT")[1])
	oCel8:oFontBody := oFont10
	oCel9 := TRCell():New(oSection,"P3TOTAL"				,"", "Total"			,PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1])
	oCel9:oFontBody := oFont10
	oCel10 := TRCell():New(oSection,"P3VALICM"				,"", "ICMS"				,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel10:oFontBody := oFont10
	oCel11 := TRCell():New(oSection,"P3UF"					,"", "UF Origem"		,Nil,TamSX3("F1_EST")[1])
	oCel11:oFontBody := oFont10
	oCel12 := TRCell():New(oSection,"P3DIFAL"				,"", "ICMS Origem"		,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel12:oFontBody := oFont10
	oCel13 := TRCell():New(oSection,"P3ICMSDIFAL"			,"", "ICMS Destino"		,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel13:oFontBody := oFont10
	oCel14 := TRCell():New(oSection,"P3VFCPDIF"				,"", "FECP"				,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel14:oFontBody := oFont10
		
	oCel15 := TRCell():New(oSection,"P5DOC"					,"", "Documento"		,Nil,TamSX3("F1_DOC")[1] + 5)
	oCel15:oFontBody := oFont10	
	oCel16 := TRCell():New(oSection,"P5SERIE"				,"", "Série"			,Nil,TamSX3("F1_SERIE")[1])
	oCel16:oFontBody := oFont10
	oCel17 := TRCell():New(oSection,"P5DTDIGIT"				,"", "Digitação"		,Nil,nTamData)
	oCel17:oFontBody := oFont10
	oCel18 := TRCell():New(oSection,"P5CFOP"				,"", "CFOP"				,Nil,TamSX3("F4_CF")[1])
	oCel18:oFontBody := oFont10
	oCel19 := TRCell():New(oSection,"P5TES"					,"", "TES"				,Nil,TamSX3("F4_CODIGO")[1])
	oCel19:oFontBody := oFont10
	oCel20 := TRCell():New(oSection,"P5QUANT"				,"", "Qtde."			,PesqPict("SD1","D1_QUANT"),TamSX3("D1_QUANT")[1])
	oCel20:oFontBody := oFont10
	oCel21 := TRCell():New(oSection,"P5PRECO"				,"", "Preço"			,PesqPict("SD1","D1_VUNIT"),TamSX3("D1_VUNIT")[1])
	oCel21:oFontBody := oFont10
	oCel22 := TRCell():New(oSection,"P5TOTAL"				,"", "Total"			,PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1])
	oCel22:oFontBody := oFont10
	oCel23 := TRCell():New(oSection,"P5VALICM"				,"", "ICMS"				,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel23:oFontBody := oFont10
	
	oCel25 := TRCell():New(oSection,"P6DOC"					,"", "Documento"		,Nil,TamSX3("F1_DOC")[1] + 5)
	oCel25:oFontBody := oFont10	
	oCel26 := TRCell():New(oSection,"P6SERIE"				,"", "Série"			,Nil,TamSX3("F1_SERIE")[1])
	oCel26:oFontBody := oFont10
	oCel27 := TRCell():New(oSection,"P6DTDIGIT"				,"", "Digitação"		,Nil,nTamData)
	oCel27:oFontBody := oFont10
	oCel28 := TRCell():New(oSection,"P6CFOP"					,"", "CFOP"				,Nil,TamSX3("F4_CF")[1])
	oCel28:oFontBody := oFont10
	oCel29 := TRCell():New(oSection,"P6TES"					,"", "TES"				,Nil,TamSX3("F4_CODIGO")[1])
	oCel29:oFontBody := oFont10
	oCel30 := TRCell():New(oSection,"P6QUANT"				,"", "Qtde."			,PesqPict("SD1","D1_QUANT"),TamSX3("D1_QUANT")[1])
	oCel30:oFontBody := oFont10
	oCel31 := TRCell():New(oSection,"P6PRECO"				,"", "Preço"			,PesqPict("SD1","D1_VUNIT"),TamSX3("D1_VUNIT")[1])
	oCel31:oFontBody := oFont10
	oCel32 := TRCell():New(oSection,"P6TOTAL"				,"", "Total"			,PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1])
	oCel32:oFontBody := oFont10
	oCel33 := TRCell():New(oSection,"P6VALICM"				,"", "ICMS"				,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel33:oFontBody := oFont10
	oCel34 := TRCell():New(oSection,"P6UF"					,"", "UF Origem"		,Nil,TamSX3("F1_EST")[1])
	oCel34:oFontBody := oFont10
	oCel35 := TRCell():New(oSection,"P6DIFAL"				,"", "ICMS Origem"		,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel35:oFontBody := oFont10
	oCel36 := TRCell():New(oSection,"P6ICMSDIFAL"			,"", "ICMS Destino"		,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel36:oFontBody := oFont10
	oCel37 := TRCell():New(oSection,"P6VFCPDIF"				,"", "FECP"				,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel37:oFontBody := oFont10
	
	oCel39:= TRCell():New(oSection,"P5ADOC"					,"", "Documento"		,Nil,TamSX3("F1_DOC")[1] + 5)
	oCel39:oFontBody := oFont10	
	oCel40 := TRCell():New(oSection,"P5ASERIE"				,"", "Série"			,Nil,TamSX3("F1_SERIE")[1])
	oCel40:oFontBody := oFont10
	oCel41 := TRCell():New(oSection,"P5ADTDIGIT"			,"", "Digitação"		,Nil,nTamData)
	oCel41:oFontBody := oFont10
	oCel42 := TRCell():New(oSection,"P5ACFOP"				,"", "CFOP"				,Nil,TamSX3("F4_CF")[1])
	oCel42:oFontBody := oFont10
	oCel43 := TRCell():New(oSection,"P5ATES"				,"", "TES"				,Nil,TamSX3("F4_CODIGO")[1])
	oCel43:oFontBody := oFont10
	oCel44:= TRCell():New(oSection,"P5AQUANT"				,"", "Qtde."			,PesqPict("SD1","D1_QUANT"),TamSX3("D1_QUANT")[1])
	oCel44:oFontBody := oFont10
	oCel45:= TRCell():New(oSection,"P5APRECO"				,"", "Preço"			,PesqPict("SD1","D1_VUNIT"),TamSX3("D1_VUNIT")[1])
	oCel45:oFontBody := oFont10
	oCel46:= TRCell():New(oSection,"P5ATOTAL"				,"", "Total"			,PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1])
	oCel46:oFontBody := oFont10
	oCel47 := TRCell():New(oSection,"P5AVALICM"				,"", "ICMS"				,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel47:oFontBody := oFont10
	
	oCel48 := TRCell():New(oSection,"P7DOC"					,"", "Documento"		,Nil,TamSX3("F1_DOC")[1] + 5)
	oCel48:oFontBody := oFont10	
	oCel49 := TRCell():New(oSection,"P7SERIE"				,"", "Série"			,Nil,TamSX3("F1_SERIE")[1])
	oCel49:oFontBody := oFont10
	oCel50 := TRCell():New(oSection,"P7DTDIGIT"				,"", "Digitação"		,Nil,nTamData)
	oCel50:oFontBody := oFont10
	oCel51 := TRCell():New(oSection,"P7CFOP"					,"", "CFOP"				,Nil,TamSX3("F4_CF")[1])
	oCel51:oFontBody := oFont10
	oCel52 := TRCell():New(oSection,"P7TES"					,"", "TES"				,Nil,TamSX3("F4_CODIGO")[1])
	oCel52:oFontBody := oFont10
	oCel53 := TRCell():New(oSection,"P7QUANT"				,"", "Qtde."			,PesqPict("SD1","D1_QUANT"),TamSX3("D1_QUANT")[1])
	oCel53:oFontBody := oFont10
	oCel54 := TRCell():New(oSection,"P7PRECO"				,"", "Preço"			,PesqPict("SD1","D1_VUNIT"),TamSX3("D1_VUNIT")[1])
	oCel54:oFontBody := oFont10
	oCel55 := TRCell():New(oSection,"P7TOTAL"				,"", "Total"			,PesqPict("SD1","D1_TOTAL"),TamSX3("D1_TOTAL")[1])
	oCel55:oFontBody := oFont10
	oCel56 := TRCell():New(oSection,"P7VALICM"				,"", "ICMS"				,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel56:oFontBody := oFont10
	oCel57 := TRCell():New(oSection,"P7UF"					,"", "UF Origem"		,Nil,TamSX3("F1_EST")[1])
	oCel57:oFontBody := oFont10
	oCel58 := TRCell():New(oSection,"P7DIFAL"				,"", "ICMS Origem"		,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel58:oFontBody := oFont10
	oCel59 := TRCell():New(oSection,"P7ICMSDIFAL"			,"", "ICMS Destino"		,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel59:oFontBody := oFont10
	oCel60 := TRCell():New(oSection,"P7VFCPDIF"				,"", "FECP"				,PesqPict("SD1","D1_VALICM"),TamSX3("D1_VALICM")[1])
	oCel60:oFontBody := oFont10
	
	/*
	oCel3:SetAlign("RIGHT")
	oCel4:SetAlign("RIGHT")
	oCel5:SetAlign("RIGHT")
	oCel7:SetAlign("RIGHT")
	oCel8:SetAlign("RIGHT")
	oCel9:SetAlign("RIGHT")
	oCel10:SetAlign("RIGHT")
	oCel11:SetAlign("RIGHT")
	oCel12:SetAlign("RIGHT")
	oCel13:SetAlign("RIGHT")
	oCel14:SetAlign("RIGHT")
	oCel15:SetAlign("RIGHT")*/
	
return (oReport)

// Impressão da informações
static function PrintReport(oReport)
			
	local oSec1		:= oReport:Section(1)
	local cAlias	:= GetNextAlias()
//	local oBreak	:= Nil
//	local oTotTipo	:= Nil	
//	local oTotTipo1 := Nil
//	local oTotTipo2 := Nil
//	local oTotTipo3 := Nil
//	local oTotTipo4 := Nil
//	local oTotGeral	:= Nil
//	local oTotGeral2:= Nil
//	local oTotGeral3:= Nil
//	local oTotGeral4:= Nil
//	local oTotGeral5:= Nil
//	local oTotGeral6:= Nil
//	local oTotGeral7:= Nil
	
	oSec1:BeginQuery()
	
		BeginSql Alias cAlias
			
			%noparser%
			COLUMN P3DTDIGIT AS DATE
			COLUMN P5DTDIGIT AS DATE
			COLUMN P5ADTDIGIT AS DATE
			COLUMN P6DTDIGIT AS DATE
			COLUMN P7DTDIGIT AS DATE
			
			SELECT P3.F1_DOC AS P3DOC, P3.F1_SERIE AS P3SERIE, P3.F1_DTDIGIT AS P3DTDIGIT, P3.F4_CF AS P3CFOP, P3.D1_TES AS P3TES, 
			       P3.D1_QUANT AS P3QUANT, P3.D1_VUNIT AS P3PRECO, P3.D1_TOTAL AS P3TOTAL, P3.D1_VALICM AS P3VALICM, P3.F1_EST AS P3UF, P3.D1_DIFAL AS P3DIFAL, P3.D1_ICMSDIF AS P3ICMSDIFAL,
				   P3.VFCPDIF AS P3VFCPDIF,
				   
				   P5.F2_DOC AS P5DOC, P5.F2_SERIE AS P5SERIE, P5.F2_DTDIGIT AS P5DTDIGIT, P5.F4_CF AS P5CFOP, P5.D2_TES AS P5TES, P5.D2_QUANT AS P5QUANT, 
				   P5.D2_PRCVEN AS P5PRECO, P5.D2_TOTAL AS P5TOTAL, P5.D2_VALICM AS P5VALICM,
				   
				   P6.A1_NOME AS P6CLIENTE, P6.F2_DOC AS P6DOC, P6.F2_SERIE AS P6SERIE, P6.F2_DTDIGIT AS P6DTDIGIT, P6.F4_CF AS P6CFOP, P6.D2_TES AS P6TES, P6.D2_QUANT AS P6QUANT, 
				   P6.D2_PRCVEN AS P6PRECO, P6.D2_TOTAL AS P6TOTAL, P6.D2_VALICM AS P6VALICM, P6.F2_EST AS P6UF, P6.D2_DIFAL AS P6DIFAL, P6.D2_ICMSCOM AS P6ICMSDIFAL,
				   P6.VFCPDIF AS P6VFCPDIF,
				   
				   P5A.F1_DOC AS P5ADOC, P5A.F1_SERIE AS P5ASERIE, P5A.F1_DTDIGIT AS P5ADTDIGIT, P5A.F4_CF AS P5ACFOP, P5A.D1_TES AS P5ATES, P5A.D1_QUANT AS P5AQUANT, 
				   P5A.D1_VUNIT AS P5APRECO, P5A.D1_TOTAL AS P5ATOTAL, P5A.D1_VALICM AS P5AVALICM,
				   
				   P7.D1_DOC AS P7DOC, P7.D1_SERIE AS P7SERIE, P7.D1_DTDIGIT AS P7DTDIGIT, P7.F4_CF AS P7CFOP, P7.D1_TES AS P7TES, P7.D1_QUANT AS P7QUANT, P7.D1_VUNIT AS P7PRECO, 
				   P7.D1_TOTAL AS P7TOTAL, P7.D1_VALICM AS P7VALICM, P7.F1_EST AS P7UF, P7.D1_DIFAL AS P7DIFAL, P7.D1_ICMSDIF AS P7ICMSDIF, P7.VFCPDIF AS P7VFCPDIF
			  FROM 
			  
			  (SELECT F2_DOC, F2_SERIE, F2_DTDIGIT, F4_CF, D2_TES, D2_COD,
								   D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_VALICM, F2_EST, A1_NOME,
								   D2_DIFAL, D2_ICMSCOM, B6_CLIFOR, B6_LOJA, D2_NFORI, D2_SERIORI, D2_ITEMORI,
								   (SELECT CD2_VFCP 
									  FROM %TABLE:CD2% CD2 
									 WHERE CD2_FILIAL = D2_FILIAL 
									   AND CD2_TPMOV = 'E' 
									   AND CD2_SERIE = D2_SERIE 
									   AND CD2_DOC = D2_DOC 
									   AND CD2_CODCLI = D2_CLIENTE
									   AND CD2_LOJCLI = D2_LOJA 
									   AND CD2_ITEM = D2_ITEM 
									   AND CD2_CODPRO  = D2_COD
									   AND CD2.D_E_L_E_T_ = ' ' ) AS VFCPDIF
							  FROM %TABLE:SD2% D2
									INNER JOIN %TABLE:SF2% F2
											ON F2_FILIAL = D2_FILIAL 
										   AND F2_DOC = D2_DOC
										   AND F2_SERIE = D2_SERIE
										   AND F2_CLIENTE = D2_CLIENTE
										   AND F2_LOJA = D2_LOJA
										   AND F2.D_E_L_E_T_ = ' '
									INNER JOIN %TABLE:SF4% F4
											ON F4_FILIAL = D2_FILIAL 
										   AND F4_CODIGO = D2_TES
										   AND F4.D_E_L_E_T_ = ' '
									INNER JOIN %TABLE:SB6% B6 
									        ON B6_FILIAL       	= D2_FILIAL
											AND B6_PRODUTO  	= D2_COD
											AND B6_IDENT  		= D2_IDENTB6
											AND B6_TPCF 		= 'C'
											AND B6_PODER3 		= 'R'
											AND B6.D_E_L_E_T_ 	= ' '
									INNER JOIN %TABLE:SA1% A1
											ON A1_FILIAL = D2_FILIAL
										   AND A1_COD = D2_CLIENTE
										   AND A1_LOJA = D2_LOJA
										   AND A1.D_E_L_E_T_ = ' '
							 WHERE D2_COD BETWEEN %EXP:MV_PAR09% AND %EXP:MV_PAR10%
							   AND D2_EMISSAO BETWEEN %EXP:MV_PAR07% AND %EXP:MV_PAR08%
							   AND D2_FILIAL = %EXP:xFilial("SD2")%
							   AND D2.D_E_L_E_T_ = ' ' ) P6
			   LEFT JOIN 
							(SELECT F1_DOC, F1_SERIE, F1_DTDIGIT, F4_CF, D1_TES, D1_COD,
							       D1_QUANT, D1_VUNIT, D1_TOTAL, D1_VALICM, F1_EST, 
								   D1_DIFAL, D1_ICMSDIF, D1_ITEM, D1_FORNECE, D1_LOJA, 
								   (SELECT CD2_VFCP 
								      FROM %TABLE:CD2% CD2 
									 WHERE CD2_FILIAL = D1_FILIAL 
									   AND CD2_TPMOV = 'E' 
									   AND CD2_SERIE = D1_SERIE 
									   AND CD2_DOC = D1_DOC 
									   AND CD2_CODCLI = D1_FORNECE 
									   AND CD2_LOJCLI = D1_LOJA 
									   AND CD2_ITEM = D1_ITEM 
									   AND CD2_CODPRO  = D1_COD
									   AND CD2.D_E_L_E_T_ = ' ' ) AS VFCPDIF
							  FROM %TABLE:SD1% D1
									INNER JOIN %TABLE:SF1% F1
									        ON F1_FILIAL = D1_FILIAL 
										   AND F1_DOC = D1_DOC
										   AND F1_SERIE = D1_SERIE
										   AND F1_FORNECE = D1_FORNECE
										   AND F1_LOJA = D1_LOJA
										   AND F1.D_E_L_E_T_ = ' '
									INNER JOIN %TABLE:SF4% F4
									        ON F4_FILIAL = D1_FILIAL
										   AND F4_CODIGO = D1_TES
										   AND F4.D_E_L_E_T_ = ' '
									INNER JOIN %TABLE:SA1% A1
									        ON A1_FILIAL = D1_FILIAL
										   AND A1_COD = D1_FORNECE
										   AND A1_LOJA = D1_LOJA
										   AND A1.D_E_L_E_T_ = ' '
							 WHERE D1_TIPO = 'B'
							   AND D1_FORNECE BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR03%
							   AND D1_LOJA BETWEEN %EXP:MV_PAR02% AND %EXP:MV_PAR04%
							   AND D1_COD BETWEEN %EXP:MV_PAR09% AND %EXP:MV_PAR10%
							   AND D1_DTDIGIT BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%
							   AND D1_EMISSAO BETWEEN %EXP:MV_PAR07% AND %EXP:MV_PAR08%
							   AND D1_FILIAL = %EXP:xFilial("SD1")%
							   AND D1.D_E_L_E_T_ = ' ') P3
					 ON P3.F1_DOC = P6.D2_NFORI
					AND P3.F1_SERIE = P6.D2_SERIORI
					AND P3.D1_ITEM = P6.D2_ITEMORI
					AND P3.D1_FORNECE = P6.B6_CLIFOR
					AND P3.D1_LOJA = P6.B6_LOJA
			   LEFT JOIN
							(SELECT F2_DOC, F2_SERIE, F2_DTDIGIT, F4_CF, D2_TES, D2_COD, D2_ITEM,
								   D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_VALICM, D2_ZZNFAUT, 
								   D2_ZZSEAUT, D2_ZZITAUT, D2_ZZCLAUT, D2_ZZLJAUT, D2_CLIENTE, D2_LOJA
							  FROM %TABLE:SD2% D2
									INNER JOIN %TABLE:SF2% F2
											ON F2_FILIAL = D2_FILIAL 
										   AND F2_DOC = D2_DOC
										   AND F2_SERIE = D2_SERIE
										   AND F2_CLIENTE = D2_CLIENTE
										   AND F2_LOJA = D2_LOJA
										   AND F2.D_E_L_E_T_ = ' '
									INNER JOIN %TABLE:SF4% F4
											ON F4_FILIAL = D2_FILIAL 
										   AND F4_CODIGO = D2_TES
										   AND F4.D_E_L_E_T_ = ' '
							 WHERE F2_ZZAUTO = 'S' 
							   AND D2.D_E_L_E_T_ = ' ') P5
					 ON P3.F1_DOC = P5.D2_ZZNFAUT 
					AND P3.F1_SERIE = P5.D2_ZZSEAUT
					AND P3.D1_ITEM = P5.D2_ZZITAUT
					AND P3.D1_FORNECE = P5.D2_ZZCLAUT
					AND P3.D1_LOJA = P5.D2_ZZLJAUT				
				LEFT JOIN	
							(SELECT F1_DOC, F1_SERIE, F1_DTDIGIT, F4_CF, D1_TES, D1_COD,
								    D1_QUANT, D1_VUNIT, D1_TOTAL, D1_VALICM, D1_NFORI, D1_SERIORI, D1_ITEMORI, D1_FORNECE, D1_LOJA
							   FROM %TABLE:SD1% D1
									INNER JOIN %TABLE:SF1% F1
											ON F1_FILIAL = D1_FILIAL
										   AND F1_DOC = D1_DOC
										   AND F1_SERIE = D1_SERIE
										   AND F1_FORNECE = D1_FORNECE
										   AND F1_LOJA = D1_LOJA
										   AND F1.D_E_L_E_T_ = ' '
									INNER JOIN %TABLE:SF4% F4
											ON F4_FILIAL = D1_FILIAL
										   AND F4_CODIGO = D1_TES
										   AND F4.D_E_L_E_T_ = ' '
							 WHERE F1_ZZAUTO = 'S' 
							   AND D1.D_E_L_E_T_ = ' ' ) P5A
					 ON P5.F2_DOC = P5A.D1_NFORI
					AND P5.F2_SERIE = P5A.D1_SERIORI
					AND P5.D2_ITEM = P5A.D1_ITEMORI
					AND P5.D2_CLIENTE = P5A.D1_FORNECE
					AND P5.D2_LOJA = P5A.D1_LOJA
				LEFT JOIN
							(SELECT D1A.D1_DOC, D1A.D1_SERIE, D1A.D1_DTDIGIT, F4_CF, D1A.D1_TES, D1A.D1_COD,
								    D1A.D1_QUANT, D1A.D1_VUNIT, D1A.D1_TOTAL, D1A.D1_VALICM, F1_EST, 
								    D1A.D1_DIFAL, D1A.D1_ICMSDIF, D1.D1_ZZCHVNF,
									(SELECT CD2_VFCP 
									  FROM %TABLE:CD2% CD2 
									 WHERE CD2_FILIAL = D1A.D1_FILIAL 
									   AND CD2_TPMOV = 'E' 
									   AND CD2_SERIE = D1A.D1_SERIE 
									   AND CD2_DOC = D1A.D1_DOC 
									   AND CD2_CODCLI = D1A.D1_FORNECE 
									   AND CD2_LOJCLI = D1A.D1_LOJA 
									   AND CD2_ITEM = D1A.D1_ITEM 
									   AND CD2_CODPRO  = D1A.D1_COD
									   AND CD2.D_E_L_E_T_ = ' ' ) AS VFCPDIF
							   FROM %TABLE:SD1% D1
									INNER JOIN %TABLE:SD1% D1A
									        ON D1.D1_DOC || D1.D1_SERIE || D1.D1_ITEM || D1.D1_FORNECE || D1.D1_LOJA = D1A.D1_ZZCHVNF
										   AND D1A.D1_TIPO = 'D'
									INNER JOIN %TABLE:SF1% F1
											ON F1_FILIAL = D1A.D1_FILIAL 
										   AND F1_DOC = D1A.D1_DOC
										   AND F1_SERIE = D1A.D1_SERIE
										   AND F1_FORNECE = D1A.D1_FORNECE
										   AND F1_LOJA = D1A.D1_LOJA
										   AND F1.D_E_L_E_T_ = ' '
									INNER JOIN %TABLE:SF4% F4
											ON F4_FILIAL = D1A.D1_FILIAL
										   AND F4_CODIGO = D1A.D1_TES
										   AND F4.D_E_L_E_T_ = ' '
							 WHERE D1.D1_TIPO = 'B' 
							   AND D1.D1_SERIE = 'DEV'
							   AND D1.D1_FILIAL = %EXP:xFilial("SD1")%
							   AND D1.D_E_L_E_T_ = ' ' ) P7
					ON P3.F1_DOC || P3.F1_SERIE || P3.D1_ITEM || P3.D1_FORNECE || P3.D1_LOJA = P7.D1_ZZCHVNF
			
		EndSql
	oSec1:EndQuery()
	
//	Aviso("Atenção", getLastQuery()[2], {"OK"}, 3, FunDesc())
	
	Count to nCnt
	(cAlias)->(dbGoTop())
	if !(nCnt > 0)
		MsgAlert("Não há dados para os parâmetros informados!")
		oReport:CancelPrint()
	else
		oReport:SetMeter(nCnt)
		if !oReport:Cancel()
//			
//			// Sub Total por Titulo
//			oBreak	:= TRBreak():New(oReport,oSec1:Cell("DOC"),"Total por Titulo")
//			oBreak:oFontBody := oFont12B
//			oTotTipo1:= TRFunction():New(oSec1:Cell("VLR_PAGTO"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
//			oTotTipo1:oFontBody := oFont12B			
//			oTotTipo2:= TRFunction():New(oSec1:Cell("VLR_REAIS_PAGTO"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
//			oTotTipo2:oFontBody := oFont12B
//			oTotTipo3:= TRFunction():New(oSec1:Cell("VLR_ATIV"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
//			oTotTipo3:oFontBody := oFont12B
//			oTotTipo4:= TRFunction():New(oSec1:Cell("VLR_PASS"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
//			oTotTipo4:oFontBody := oFont12B
//			oTotTipo5:= TRFunction():New(oSec1:Cell("SALDO_ESTRANGEIRA"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
//			oTotTipo5:oFontBody := oFont12B
//			oTotTipo6:= TRFunction():New(oSec1:Cell("SLD_REAIS"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
//			oTotTipo6:oFontBody := oFont12B
//			oTotTipo7:= TRFunction():New(oSec1:Cell("SLD_REAIS_ATU"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
//			oTotTipo7:oFontBody := oFont12B
//			
//			// Total Geral do Relatório
//			oBreak2 := TRBreak():New( oReport, {|| }, "Total Geral") //"Total Geral"
//			oTotGeral:= TRFunction():New(oSec1:Cell("VLR_PAGTO"),NIL,"SUM",oBreak2,"Total Geral",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
//			oTotGeral:oFontBody := oFont12B
//			oTotGeral2:= TRFunction():New(oSec1:Cell("VLR_REAIS_PAGTO"),NIL,"SUM",oBreak2,"Total Geral",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
//			oTotGeral2:oFontBody := oFont12B
//			oTotGeral3:= TRFunction():New(oSec1:Cell("VLR_ATIV"),NIL,"SUM",oBreak2,"Total Geral",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
//			oTotGeral3:oFontBody := oFont12B
//			oTotGeral4:= TRFunction():New(oSec1:Cell("VLR_PASS"),NIL,"SUM",oBreak2,"Total Geral",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
//			oTotGeral4:oFontBody := oFont12B
//			
			oSec1:Print()
		EndIf
	EndIf
	
	(cAlias)->(dbCloseArea())
	
return

static function perg()
	
	local aParBox 	:= {}
	local cPerg		:= "Relatório de NF Cred e Deb"
	
	aAdd(aParBox,{1,"Cliente De"	,space(TamSX3("A1_COD")[1]),	"",	"",	"SA1",	"", 50, .f.})	// MV_PAR01
	aAdd(aParBox,{1,"Loja De"		,space(TamSX3("A1_LOJA")[1]),	"",	"",	"",		"", 02, .f.})	// MV_PAR02
	aAdd(aParBox,{1,"Cliente Até"	,space(TamSX3("A1_COD")[1]),	"",	"",	"SA1",	"", 50, .f.})	// MV_PAR03
	aAdd(aParBox,{1,"Loja Até"		,space(TamSX3("A1_LOJA")[1]),	"",	"",	"",		"", 02, .f.})	// MV_PAR04
	
	aAdd(aParBox,{1,"Digitação de"	,STOD(""),	"",	"",	""	,	"",	 50, .f.})						// MV_PAR05
	aAdd(aParBox,{1,"Digitação Até"	,STOD(""),	"",	"",	""	,	"",	 50, .f.})						// MV_PAR06
	
	aAdd(aParBox,{1,"Emissão de"	,STOD(""),	"",	"",	""	,	"",	 50, .f.})						// MV_PAR07
	aAdd(aParBox,{1,"Emissão Até"	,STOD(""),	"",	"",	""	,	"",	 50, .f.})						// MV_PAR08
	
	aAdd(aParBox,{1,"Produto De"	,space(TamSX3("B1_COD")[1]),	"",	"",	"SB1",	"", 50, .f.})	// MV_PAR09
	aAdd(aParBox,{1,"Produto Até"	,space(TamSX3("B1_COD")[1]),	"",	"",	"SB1",	"", 50, .f.})	// MV_PAR10
	
return ParamBox(aParBox,"Relatorio NF Credito e Debito",,,,,,,,cPerg,.T.,.T.)
