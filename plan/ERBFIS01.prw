//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDEF.ch"
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} User Function ERBFIS01
Conciliacao Livro Fiscal
@author Milcio Gutierrez
@since 07/11/2023
@version 1.0
/*/

User Function ERBFIS01()
	Local aArea     := FWGetArea()
    Local cPerg  	:="ERBFIS01"

    CriaPerg(cPerg)

    If 	Pergunte(cPerg,.T.)
        Processa({|| fGeraExcel()})
    EndIf

	FWRestArea(aArea)
Return

/*/{Protheus.doc} fGeraExcel
Criacao do arquivo Excel na funcao ERBFIS01
@author Milcio Gutierrez
@since 07/11/2023
@version 1.0
/*/

Static Function fGeraExcel()
	Local cQryDad  := ""
	Local oFWMsExcel
	Local oExcel
	Local cArquivo    := GetTempPath() + 'ERBFIS01' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.xml'
	Local cWorkSheet := "Livro_Fiscal"
	Local cTitulo    := "Conciliacao Livro Fiscal"
	Local nAtual := 0
	Local nTotal := 0


	//Montando consulta de dados
	cQryDad := " SELECT SFT.FT_FILIAL, SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CHVNFE, SFT.FT_CSTPIS, SFT.FT_BASEDES, SFT.FT_DIFAL, SFT.FT_PDDES, SFT.FT_CSTCOF, " + CRLF
	cQryDad += " SFT.FT_CLIEFOR AS FT_CLIEFOR, SFT.FT_LOJA, SFT.FT_ENTRADA, SFT.FT_EMISSAO, SFT.FT_TIPOMOV, SFT.FT_TES, SFT.FT_CFOP, SFT.FT_PRODUTO, "	+ CRLF
	cQryDad += " SFT.FT_ITEM, SFT.FT_ESPECIE, SFT.FT_CODISS, SFT.FT_CONTA, SFT.FT_QUANT, SFT.FT_PRCUNIT, SFT.FT_DESCONT, SFT.FT_VALCONT, SFT.FT_TOTAL, "	+ CRLF
	cQryDad += " SFT.FT_BASEPIS, SFT.FT_ALIQPIS, SFT.FT_VALPIS, SFT.FT_BASECOF, SFT.FT_ALIQCOF, SFT.FT_VALCOF, SFT.FT_ALIQICM, SFT.FT_BASEICM, SFT.FT_VALICM, "	+ CRLF
	cQryDad += " SFT.FT_ISENICM, SFT.FT_OUTRICM, SFT.FT_BASEIPI, SFT.FT_VALIPI, SFT.FT_ISENIPI, SFT.FT_OUTRIPI, SFT.FT_BASERET, SFT.FT_ICMSRET, SFT.FT_OBSERV, "	+ CRLF
	cQryDad += " SFT.FT_ICMSCOM, SFT.FT_ICMSDIF, SFT.FT_IPIOBS, SFT.FT_DTCANC, SFT.FT_ALIQIPI, SFT.FT_CLASFIS, SFT.FT_CTIPI, SFT.FT_FRETE, SFT.FT_SEGURO, "	+ CRLF
	cQryDad += " SFT.FT_DESPESA, SFT.FT_ALIQIRR, SFT.FT_BASEIRR, SFT.FT_VALIRR, SFT.FT_BASEINS, SFT.FT_ALIQINS, SFT.FT_VALINS, SFT.FT_POSIPI, SFT.FT_ESTOQUE, "	+ CRLF
	cQryDad += " SFT.FT_NFORI, SFT.FT_SERORI, SFT.FT_ITEMORI, SFT.FT_BASECSL, SFT.FT_ALIQCSL, SFT.FT_VALCSL, SFT.FT_RECISS, SFT.FT_CSTISS, SFT.FT_BRETPIS, "	+ CRLF
	cQryDad += " SFT.FT_BRETCOF, SFT.FT_BRETCSL, SFT.FT_VRETPIS, SFT.FT_VRETCOF, SFT.FT_VRETCSL, SFT.FT_ARETPIS, SFT.FT_ARETCOF, SFT.FT_ARETCSL, SFT.FT_AGREG, "	+ CRLF
	cQryDad += " SF4.F4_TEXTO, SF4.F4_ATUATF, SB1.B1_DESC, SD1.D1_UM, SD1.D1_VALICM, SD1.D1_ITEMCTA, SD1.D1_CC, SD1.D1_ALIQISS AS ALIQISS, SD1.D1_BASEISS AS BASEISS, SD1.D1_VALISS AS VALISS, "	+ CRLF
    cQryDad += " SD1.D1_PEDIDO AS PEDIDO, CT1_DESC01, X5_DESCRI,"	+ CRLF
	cQryDad += " CASE "	+ CRLF
	cQryDad += "     WHEN SFT.FT_TIPO = 'D' THEN "	+ CRLF
	cQryDad += "       SA1.A1_NOME "	+ CRLF
	cQryDad += "     ELSE "	+ CRLF
	cQryDad += " 	  SA2.A2_NOME "	+ CRLF
	cQryDad += "     END AS A2_NOME, "	+ CRLF
 	cQryDad += " CASE "	+ CRLF
	cQryDad += "     WHEN SFT.FT_TIPO = 'D' THEN "	+ CRLF
	cQryDad += "        SA1.A1_EST "	+ CRLF
	cQryDad += "     ELSE "	+ CRLF
	cQryDad += "        SA2.A2_EST"	+ CRLF 
	cQryDad += " 	END AS A2_EST,"	+ CRLF
	
	cQryDad += " (SELECT F2D_VALOR  "	+ CRLF
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSEST' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
 	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
 	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
 	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
 	cQryDad += " AND F2D_TABELA = 'SD1'   "	+ CRLF
 	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
	cQryDad += " ) VLTRIBIBS,  "	+ CRLF

	cQryDad += " (SELECT F2D_BASE  "	+ CRLF
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSEST' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
 	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
 	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
 	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
 	cQryDad += " AND F2D_TABELA = 'SD1'   "	+ CRLF
 	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
	cQryDad += " ) BASORIIBS,"	+ CRLF

	cQryDad += " (SELECT F2D_ALIQ  "	+ CRLF
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSEST' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
 	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
 	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
 	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
 	cQryDad += " AND F2D_TABELA = 'SD1'   "	+ CRLF
 	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
	cQryDad += " ) ALIQORIBS,  "	+ CRLF

	cQryDad += " (SELECT DISTINCT CJ3_CST "	+ CRLF 
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D"	+ CRLF  
 	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSEST' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('CJ3') + " CJ3 ON (F2D_ID = CJ3_IDF2D AND CJ3.D_E_L_E_T_ <> '*') "	+ CRLF
 	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
 	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
 	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
 	cQryDad += " AND F2D_TABELA = 'SD1'   "	+ CRLF
 	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
	cQryDad += " ) CJ3_CSTIBS,  "	+ CRLF

	cQryDad += " (SELECT F2D_VALOR  "	+ CRLF
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'CBSFED' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
 	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
 	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
 	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
 	cQryDad += " AND F2D_TABELA = 'SD1'   "	+ CRLF
 	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
 	cQryDad += " ) VLTRIBCBS,  "	+ CRLF

	cQryDad += " (SELECT F2D_BASE  "	+ CRLF
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'CBSFED' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
 	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
 	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
 	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
 	cQryDad += " AND F2D_TABELA = 'SD1'   "	+ CRLF
 	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
	cQryDad += " ) BASORICBS,  "	+ CRLF

	cQryDad += " (SELECT F2D_ALIQ  "	+ CRLF
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'CBSFED' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
 	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
 	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
 	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
 	cQryDad += " AND F2D_TABELA = 'SD1'   "	+ CRLF
 	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
	cQryDad += " ) ALIQORCBS,   "	+ CRLF

	cQryDad += " (SELECT DISTINCT CJ3_CST "	+ CRLF 
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D"	+ CRLF  
 	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'CBSFED' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('CJ3') + " CJ3 ON (F2D_ID = CJ3_IDF2D AND CJ3.D_E_L_E_T_ <> '*') "	+ CRLF
 	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
 	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
 	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
 	cQryDad += " AND F2D_TABELA = 'SD1'   "	+ CRLF
 	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
	cQryDad += " ) CJ3_CSTCBS,"	+ CRLF

	cQryDad += " (SELECT F2D_VALOR  "	+ CRLF
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSMUN' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
 	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
 	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
 	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
 	cQryDad += " AND F2D_TABELA = 'SD1'   "	+ CRLF
 	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
	cQryDad += " ) VLTRIBIBMUN,  "	+ CRLF

	cQryDad += " (SELECT F2D_BASE  "	+ CRLF
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSMUN' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
 	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
 	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
 	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
 	cQryDad += " AND F2D_TABELA = 'SD1'   "	+ CRLF
 	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
	cQryDad += " ) BASORIIBMUN,  "	+ CRLF

	cQryDad += " (SELECT F2D_ALIQ  "	+ CRLF
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSMUN' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
 	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
 	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
 	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
 	cQryDad += " AND F2D_TABELA = 'SD1'   "	+ CRLF
 	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
	cQryDad += " ) ALIQORIBMUN,  "	+ CRLF

	cQryDad += " (SELECT DISTINCT CJ3_CST "	+ CRLF 
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSMUN' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
 	cQryDad += " INNER JOIN " + RetSqlName('CJ3') + " CJ3 ON (F2D_ID = CJ3_IDF2D AND CJ3.D_E_L_E_T_ <> '*') "	+ CRLF
 	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
 	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
 	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
 	cQryDad += " AND F2D_TABELA = 'SD1'   "	+ CRLF
 	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
	cQryDad += " ) CSTIBMUN,  "	+ CRLF

	cQryDad += " (SELECT SAH.AH_DESCPO"	+ CRLF 
 	cQryDad += " FROM " + RetSqlName('SAH') + " SAH "	+ CRLF
 	cQryDad += " WHERE SAH.D_E_L_E_T_ = ' ' "	+ CRLF
 	cQryDad += " AND SAH.AH_UNIMED = (SELECT SD1.D1_UM"	+ CRLF 
	cQryDad += " 	FROM " + RetSqlName('SD1') + " SD1 "	+ CRLF
	cQryDad += " 	WHERE SD1.D_E_L_E_T_ =' ' "	+ CRLF
	cQryDad += " 	AND SD1.D1_FILIAL = SFT.FT_FILIAL "	+ CRLF
	cQryDad += " 	AND SD1.D1_DOC = SFT.FT_NFISCAL "	+ CRLF
	cQryDad += " 	AND SD1.D1_SERIE = SFT.FT_SERIE "	+ CRLF
	cQryDad += " 	AND SD1.D1_FORNECE = SFT.FT_CLIEFOR "	+ CRLF
	cQryDad += " 	AND SD1.D1_LOJA = SFT.FT_LOJA "	+ CRLF
	cQryDad += " 	AND SD1.D1_COD = SFT.FT_PRODUTO "	+ CRLF
	cQryDad += " 	AND SD1.D1_ITEM = SFT.FT_ITEM)"	+ CRLF
	cQryDad += " ) AS AH_DESCPO, "	+ CRLF

	cQryDad += "  CASE "	+ CRLF
	cQryDad += "   WHEN SFT.FT_TIPO = 'S' THEN 'ISS' "	+ CRLF
	cQryDad += "   ELSE SFT.FT_TIPO "	+ CRLF
	cQryDad += "  END AS FT_TIPO "	+ CRLF

	cQryDad += "FROM " + RetSqlName('SFT') + " SFT "		+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('SA1') + " SA1 ON (SFT.FT_CLIEFOR = SA1.A1_COD AND SFT.FT_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ <> '*')"	+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('SA2') + " SA2 ON (SFT.FT_CLIEFOR = SA2.A2_COD AND SFT.FT_LOJA = SA2.A2_LOJA AND SA2.D_E_L_E_T_ <> '*')"	+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('SF4') + " SF4 ON (SFT.FT_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ <> '*')"	+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('SB1') + " SB1 ON (SFT.FT_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ <> '*')"	+ CRLF
	cQryDad += " LEFT JOIN " + RetSqlName('SD1') + " SD1 ON (SFT.FT_FILIAL = SD1.D1_FILIAL AND SFT.FT_NFISCAL = SD1.D1_DOC AND SFT.FT_SERIE = SD1.D1_SERIE AND SFT.FT_CLIEFOR = SD1.D1_FORNECE AND SFT.FT_LOJA = SD1.D1_LOJA AND SFT.FT_PRODUTO = SD1.D1_COD AND SFT.FT_ITEM = SD1.D1_ITEM AND SD1.D_E_L_E_T_ <> '*')"	+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('CT1') + " CT1 ON (SFT.FT_CONTA = CT1.CT1_CONTA AND CT1.D_E_L_E_T_ <> '*')"	+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('SX5') + " SX5 ON (SFT.FT_ESPECIE = SX5.X5_CHAVE AND SX5.X5_TABELA ='42' AND SX5.D_E_L_E_T_ <> '*')"	+ CRLF

	cQryDad += "WHERE SFT.D_E_L_E_T_ <> '*' "		+ CRLF
	cQryDad += " AND SFT.FT_ENTRADA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"	+ CRLF
	cQryDad += " AND SFT.FT_FILIAL BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"	+ CRLF
	cQryDad += " AND SFT.FT_TIPOMOV ='E'"		+ CRLF

	cQryDad += " UNION "	+ CRLF
 	cQryDad += " SELECT SFT.FT_FILIAL, SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CHVNFE, SFT.FT_CSTPIS, SFT.FT_BASEDES, SFT.FT_DIFAL, SFT.FT_PDDES, SFT.FT_CSTCOF, "	+ CRLF
	cQryDad += " SFT.FT_CLIEFOR AS FT_CLIEFOR, SFT.FT_LOJA, SFT.FT_ENTRADA, SFT.FT_EMISSAO, SFT.FT_TIPOMOV, SFT.FT_TES, SFT.FT_CFOP, SFT.FT_PRODUTO, SFT.FT_ITEM, "	+ CRLF
	cQryDad += " SFT.FT_ESPECIE, SFT.FT_CODISS, SFT.FT_CONTA, SFT.FT_QUANT, SFT.FT_PRCUNIT, SFT.FT_DESCONT, SFT.FT_VALCONT, SFT.FT_TOTAL, SFT.FT_BASEPIS, "	+ CRLF
	cQryDad += " SFT.FT_ALIQPIS, SFT.FT_VALPIS, SFT.FT_BASECOF, SFT.FT_ALIQCOF, SFT.FT_VALCOF, SFT.FT_ALIQICM, SFT.FT_BASEICM, SFT.FT_VALICM, SFT.FT_ISENICM, "	+ CRLF
	cQryDad += " SFT.FT_OUTRICM, SFT.FT_BASEIPI, SFT.FT_VALIPI, SFT.FT_ISENIPI, SFT.FT_OUTRIPI, SFT.FT_BASERET, SFT.FT_ICMSRET, SFT.FT_OBSERV, SFT.FT_ICMSCOM, "	+ CRLF
	cQryDad += " SFT.FT_ICMSDIF, SFT.FT_IPIOBS, SFT.FT_DTCANC, SFT.FT_ALIQIPI, SFT.FT_CLASFIS, SFT.FT_CTIPI, SFT.FT_FRETE, SFT.FT_SEGURO, SFT.FT_DESPESA, "	+ CRLF
	cQryDad += " SFT.FT_ALIQIRR, SFT.FT_BASEIRR, SFT.FT_VALIRR, SFT.FT_BASEINS, SFT.FT_ALIQINS, SFT.FT_VALINS, SFT.FT_POSIPI, SFT.FT_ESTOQUE, SFT.FT_NFORI, "	+ CRLF
	cQryDad += " SFT.FT_SERORI, SFT.FT_ITEMORI, SFT.FT_BASECSL, SFT.FT_ALIQCSL, SFT.FT_VALCSL, SFT.FT_RECISS, SFT.FT_CSTISS, SFT.FT_BRETPIS, SFT.FT_BRETCOF, "	+ CRLF
	cQryDad += " SFT.FT_BRETCSL, SFT.FT_VRETPIS, SFT.FT_VRETCOF, SFT.FT_VRETCSL, SFT.FT_ARETPIS, SFT.FT_ARETCOF, SFT.FT_ARETCSL, SFT.FT_AGREG, SF4.F4_TEXTO, "	+ CRLF
	cQryDad += " SF4.F4_ATUATF, SB1.B1_DESC, SD2.D2_UM, SD2.D2_VALICM, SD2.D2_ITEMCC, SD2.D2_CCUSTO, SD2.D2_ALIQISS AS ALIQISS, SD2.D2_BASEISS BASEISS, SD2.D2_VALISS AS VALISS, "	+ CRLF
    cQryDad += " SD2.D2_PEDIDO  AS PEDIDO, CT1_DESC01, X5_DESCRI,"	+ CRLF
	cQryDad += " CASE "	+ CRLF
	cQryDad += "     WHEN SFT.FT_TIPO = 'D' THEN "	+ CRLF
	cQryDad += "       SA1.A1_NOME "	+ CRLF
 	cQryDad += "    ELSE "	+ CRLF
	cQryDad += " 	  SA2.A2_NOME "	+ CRLF
	cQryDad += "     END AS A2_NOME, "	+ CRLF
	cQryDad += "  CASE "	+ CRLF
	cQryDad += "     WHEN SFT.FT_TIPO = 'D' THEN "	+ CRLF
	cQryDad += "        SA1.A1_EST "	+ CRLF
	cQryDad += "     ELSE "	+ CRLF
	cQryDad += "        SA2.A2_EST"	+ CRLF 
	cQryDad += " 	END AS A2_EST,"	+ CRLF
	
	cQryDad += " (SELECT F2D_VALOR  "	+ CRLF
 	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
	cQryDad += " INNER JOIN F2B010 F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSEST' AND F2B.D_E_L_E_T_ <> '*') "	+ CRLF
	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
  	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
  	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
  	cQryDad += " AND F2D_TABELA = 'SD2'   "	+ CRLF
  	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
 	cQryDad += " ) VLTRIBIBS,  "	+ CRLF

 	cQryDad += " (SELECT F2D_BASE  "	+ CRLF
  	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
  	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSEST' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
  	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
  	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
  	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
  	cQryDad += " AND F2D_TABELA = 'SD2'   "	+ CRLF
  	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
 	cQryDad += " ) BASORIIBS,"	+ CRLF

 	cQryDad += " (SELECT F2D_ALIQ  "	+ CRLF
  	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
  	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSEST' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
  	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
  	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
  	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
  	cQryDad += " AND F2D_TABELA = 'SD2'   "	+ CRLF
  	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
 	cQryDad += " ) ALIQORIBS,  "	+ CRLF

 	cQryDad += " (SELECT DISTINCT CJ3_CST "	+ CRLF 
  	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
  	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSEST' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
  	cQryDad += " INNER JOIN " + RetSqlName('CJ3') + " CJ3 ON (F2D_ID = CJ3_IDF2D AND CJ3.D_E_L_E_T_ <> '*') "	+ CRLF
  	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
  	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
  	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
  	cQryDad += " AND F2D_TABELA = 'SD2'   "	+ CRLF
  	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
 	cQryDad += " ) CJ3_CSTIBS,  "	+ CRLF

 	cQryDad += " (SELECT F2D_VALOR  "	+ CRLF
  	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
  	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'CBSFED' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
  	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
  	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
  	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
  	cQryDad += " AND F2D_TABELA = 'SD2'   "	+ CRLF
   	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
   	cQryDad += " ) VLTRIBCBS,  "	+ CRLF

  	cQryDad += " (SELECT F2D_BASE  "	+ CRLF
   	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
   	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'CBSFED' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
   	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
   	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
   	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
   	cQryDad += " AND F2D_TABELA = 'SD2'   "	+ CRLF
   	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
  	cQryDad += " ) BASORICBS,  "	+ CRLF

  	cQryDad += " (SELECT F2D_ALIQ  "	+ CRLF
   	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
   	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'CBSFED' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
   	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
   	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
   	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
   	cQryDad += " AND F2D_TABELA = 'SD2'   "	+ CRLF
   	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
  	cQryDad += " ) ALIQORCBS,   "	+ CRLF

  	cQryDad += " (SELECT DISTINCT CJ3_CST "	+ CRLF 
   	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
   	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'CBSFED' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
   	cQryDad += " INNER JOIN " + RetSqlName('CJ3') + " CJ3 ON (F2D_ID = CJ3_IDF2D AND CJ3.D_E_L_E_T_ <> '*') "	+ CRLF
   	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
   	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
   	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
   	cQryDad += " AND F2D_TABELA = 'SD2'   "	+ CRLF
   	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
  	cQryDad += " ) CJ3_CSTCBS,"	+ CRLF

  	cQryDad += " (SELECT F2D_VALOR  "	+ CRLF
   	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
   	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSMUN' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
   	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
   	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
   	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
   	cQryDad += " AND F2D_TABELA = 'SD2'   "	+ CRLF
   	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
  	cQryDad += " ) VLTRIBIBMUN,  "	+ CRLF

  	cQryDad += " (SELECT F2D_BASE  "	+ CRLF
   	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
   	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSMUN' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
   	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
   	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
   	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
   	cQryDad += " AND F2D_TABELA = 'SD2'   "	+ CRLF
   	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
  	cQryDad += " ) BASORIIBMUN,  "	+ CRLF

  	cQryDad += " (SELECT F2D_ALIQ  "	+ CRLF
   	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
   	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSMUN' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
   	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
   	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
   	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
   	cQryDad += " AND F2D_TABELA = 'SD2'   "	+ CRLF
   	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
  	cQryDad += " ) ALIQORIBMUN,  "	+ CRLF

  	cQryDad += " (SELECT DISTINCT CJ3_CST "	+ CRLF 
   	cQryDad += " FROM " + RetSqlName('F2D') + " F2D  "	+ CRLF
   	cQryDad += " INNER JOIN " + RetSqlName('F2B') + " F2B ON (F2B_FILIAL = FT_FILIAL AND F2B.F2B_ALTERA = '2' AND F2D.F2D_TRIB = F2B.F2B_REGRA AND F2B.F2B_TRIB = 'IBSMUN' AND F2B.D_E_L_E_T_ <> '*')  "	+ CRLF
   	cQryDad += " INNER JOIN " + RetSqlName('CJ3') + " CJ3 ON (F2D_ID = CJ3_IDF2D AND CJ3.D_E_L_E_T_ <> '*') "	+ CRLF
   	cQryDad += " WHERE F2D.D_E_L_E_T_ <> '*'  "	+ CRLF
   	cQryDad += " AND F2D.F2D_FILIAL = SFT.FT_FILIAL  "	+ CRLF
   	cQryDad += " AND F2D.F2D_IDREL = SFT.FT_IDTRIB  "	+ CRLF
   	cQryDad += " AND F2D_TABELA = 'SD2'   "	+ CRLF
   	cQryDad += " AND F2D_DTEXCL = ' '  "	+ CRLF
  	cQryDad += " ) CSTIBMUN,  "	+ CRLF

  	cQryDad += " (SELECT SAH.AH_DESCPO"	+ CRLF 
   	cQryDad += " FROM " + RetSqlName('SAH') + " SAH "	+ CRLF
   	cQryDad += " WHERE SAH.D_E_L_E_T_ = ' ' "	+ CRLF
   	cQryDad += " AND SAH.AH_UNIMED = (SELECT SD2.D2_UM"	+ CRLF 
  	cQryDad += " 	FROM " + RetSqlName('SD2') + " SD2 "	+ CRLF
  	cQryDad += " 	WHERE SD2.D_E_L_E_T_ =' ' "	+ CRLF
  	cQryDad += " 	AND SD2.D2_FILIAL = SFT.FT_FILIAL "	+ CRLF
  	cQryDad += " 	AND SD2.D2_DOC = SFT.FT_NFISCAL "	+ CRLF
  	cQryDad += " 	AND SD2.D2_SERIE = SFT.FT_SERIE "	+ CRLF
  	cQryDad += " 	AND SD2.D2_CLIENTE = SFT.FT_CLIEFOR "	+ CRLF
  	cQryDad += " 	AND SD2.D2_LOJA = SFT.FT_LOJA "	+ CRLF
  	cQryDad += " 	AND SD2.D2_COD = SFT.FT_PRODUTO "	+ CRLF
  	cQryDad += " 	AND SD2.D2_ITEM = SFT.FT_ITEM)"	+ CRLF
  	cQryDad += " ) AS AH_DESCPO, "	+ CRLF

  	cQryDad += "  CASE "	+ CRLF
  	cQryDad += "   WHEN SFT.FT_TIPO = 'S' THEN 'ISS' "	+ CRLF
  	cQryDad += "   ELSE SFT.FT_TIPO "	+ CRLF
  	cQryDad += "  END AS FT_TIPO "	+ CRLF

	cQryDad += "FROM " + RetSqlName('SFT') + " SFT "		+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('SA1') + " SA1 ON (SFT.FT_CLIEFOR = SA1.A1_COD AND SFT.FT_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ <> '*')"	+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('SA2') + " SA2 ON (SFT.FT_CLIEFOR = SA2.A2_COD AND SFT.FT_LOJA = SA2.A2_LOJA AND SA2.D_E_L_E_T_ <> '*')"	+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('SF4') + " SF4 ON (SFT.FT_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ <> '*')"	+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('SB1') + " SB1 ON (SFT.FT_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ <> '*')"	+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('SD2') + " SD2 ON (SFT.FT_FILIAL = SD2.D2_FILIAL AND SFT.FT_NFISCAL = SD2.D2_DOC AND SFT.FT_SERIE = SD2.D2_SERIE AND SFT.FT_CLIEFOR = SD2.D2_CLIENTE AND SFT.FT_LOJA = SD2.D2_LOJA AND SFT.FT_PRODUTO = SD2.D2_COD AND SFT.FT_ITEM = SD2.D2_ITEM AND SD2.D_E_L_E_T_ <> '*')"	+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('CT1') + " CT1 ON (SFT.FT_CONTA = CT1.CT1_CONTA AND CT1.D_E_L_E_T_ <> '*')"	+ CRLF
  	cQryDad += " LEFT JOIN " + RetSqlName('SX5') + " SX5 ON (SFT.FT_ESPECIE = SX5.X5_CHAVE AND SX5.X5_TABELA ='42' AND SX5.D_E_L_E_T_ <> '*')"	+ CRLF

	//Executando consulta e setando o total da regua
	cQryDad += "WHERE SFT.D_E_L_E_T_ <> '*' "		+ CRLF
	cQryDad += " AND SFT.FT_ENTRADA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"	+ CRLF
	cQryDad += " AND SFT.FT_FILIAL BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"	+ CRLF
	cQryDad += " AND SFT.FT_TIPOMOV ='S'"		+ CRLF

memowrit("C:\TEMP\ERBFIS01.TXT",cQryDad)

	TCQUERY cQryDad NEW ALIAS "QRY_DAD"
	Count To nTotal

	DbSelectArea("QRY_DAD")
	QRY_DAD->(DbGoTop())

	//Cria a planilha do excel
	oFWMsExcel := FWMSExcel():New()

	//Criando a aba da planilha
	oFWMsExcel:AddworkSheet(cWorkSheet)

	//Criando a Tabela e as colunas
	oFWMsExcel:AddTable(cWorkSheet, cTitulo)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Filia", 1, 1, .F.)  //1
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Nota Fiscal", 1, 1, .F.)  //2
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Serie", 1, 1, .F.)  //3
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Chave NFE", 1, 1, .F.)  //4
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "CST PIS", 1, 1, .F.)  //5
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "CST COFINS", 1, 1, .F.)  //6
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Codigo Cli/For", 1, 1, .F.)  //7
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Loja", 1, 1, .F.)  //8
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Nome Cli/For", 1, 1, .F.)  //9
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Estado", 1, 1, .F.) //10
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Data Entrada", 1, 4, .F.) //11
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Data Emissao", 1, 4, .F.) //12
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Tipo Movimento", 1, 1, .F.) //13
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "TES", 1, 1, .F.) //14
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Descricao TES", 1, 1, .F.) //15
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Atualiza Ativo", 1, 1, .F.) //16
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "CFOP", 1, 1, .F.) //17
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Produto", 1, 1, .F.) //18
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Item ", 1, 1, .F.) //19
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Descricao do Produto", 1, 1, .F.) //20
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Unidade de Medida", 1, 1, .F.) //21
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Descricao Unidade", 1, 1, .F.) //22
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Especie", 1, 1, .F.) //23
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Descricao da Especie", 1, 1, .F.) //24
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Codigo ISS", 1, 1, .F.) //25
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Conta Contabil", 1, 1, .F.) //26
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Descricao Conta", 1, 1, .F.) //27
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Quantidade", 1, 2, .F.) //28
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Preco Unitario", 1, 2, .F.) //29
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Desconto", 1, 2, .F.) //30
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor Contabil", 1, 2, .F.) //31
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor Total", 1, 2, .F.) //32
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base PIS Apuracao", 1, 2, .F.) //33
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota PIS Apuracao", 1, 2, .F.) //34
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor PIS Apuracao", 1, 2, .F.) //35
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base COFINS Apuracao", 1, 2, .F.) //36
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota COFINS Apuracao", 1, 2, .F.) //37
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor COFINS Apuracao", 1, 2, .F.) //38
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquita ICMS", 1, 2, .F.) //39
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base ICMS", 1, 2, .F.) //40
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor ICMS", 1, 2, .F.) //41
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor Isen ICMS", 1, 2, .F.) //42
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor Outros ICMS", 1, 2, .F.) //43
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base IPI", 1, 2, .F.) //44
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor IPI", 1, 2, .F.) //45
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor Isen IPI", 1, 2, .F.) //46
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor Outros IPI", 1, 2, .F.) //47
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor Base ST", 1, 2, .F.) //48
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor ICMS ST", 1, 2, .F.) //49
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Observacao Livro", 1, 1, .F.) //50
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Tipo", 1, 1, .F.) //51
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor ICMS Com", 1, 2, .F.) //52
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor ICMS Dif", 1, 2, .F.) //53
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor IPI OBS", 1, 2, .F.) //54
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Data Cancelamento", 1, 4, .F.) //55
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota IPI", 1, 2, .F.) //56
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Situacao Tributaria", 1, 1, .F.) //57
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Tributa IPI", 1, 1, .F.) //58
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor Frete", 1, 2, .F.) //59
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor Seguro", 1, 2, .F.) //60
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor Despesa", 1, 2, .F.) //61
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota IRRF", 1, 2, .F.) //62
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base IRRF", 1, 2, .F.) //63
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor IRRF", 1, 2, .F.) //64
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base INSS", 1, 2, .F.) //65
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota INSS", 1, 2, .F.) //66
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor INSS", 1, 2, .F.) //67
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Codigo NCM", 1, 1, .F.) //68
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Movimenta Estoque", 1, 1, .F.) //69
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "NF Original", 1, 1, .F.) //70
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Serie NF Original", 1, 1, .F.) //71
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Item NF Original", 1, 1, .F.) //72
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base CSLL", 1, 2, .F.) //73
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota CSLL", 1, 2, .F.) //74
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor CSLL", 1, 2, .F.) //75
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "ISS Retido", 1, 2, .F.) //76
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Sit Trib ISS", 1, 1, .F.) //77
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base PIS Retido", 1, 2, .F.) //78
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base COFINS Retido", 1, 2, .F.) //79
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base CSLL Retido", 1, 2, .F.) //80
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor PIS Retido", 1, 2, .F.) //81
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor COFINS Retido", 1, 2, .F.) //82
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor CSLL Retido", 1, 2, .F.) //83
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota PIS Retido", 1, 2, .F.) //84
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota COFINS Retido", 1, 2, .F.) //85
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota CSLL Retido", 1, 2, .F.) //86
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base Difal", 1, 2, .F.) //87
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota Difal", 1, 2, .F.) //88
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor Difal", 1, 2, .F.) //89
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "ICMS Escriturado", 1, 2, .F.) //90
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Projeto/Ordem", 1, 2, .F.) //91
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Centro de Custo", 1, 2, .F.) //92
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor IBS Estadual", 1, 2, .F.) //93
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base IBS Estadual", 1, 2, .F.) //94
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota IBS Estadual", 1, 2, .F.) //95
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "CST IBS Estadual", 1, 2, .F.) //96
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor CBS", 1, 2, .F.) //97
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base CBS", 1, 2, .F.) //98
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota CBS", 1, 2, .F.) //99
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "CST CBS", 1, 2, .F.) //100
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor IBS Municipal", 1, 2, .F.) //101
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base IBS Municipal", 1, 2, .F.) //102
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota IBS Municipal", 1, 2, .F.) //103
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "CST IBS Municipal", 1, 2, .F.) //104
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Aliquota ISS", 1, 2, .F.) //105
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Base ISS", 1, 2, .F.) //106
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Valor ISS", 1, 2, .F.) //107
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Agrega Valor", 1, 1, .F.) //108
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Pedido", 1, 1, .F.) //109

	Count To nTotal
	ProcRegua(nTotal)
	QRY_DAD->(DbGoTop())

	While !(QRY_DAD->(EoF()))

		nAtual++
		IncProc("Adicionando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
		oFWMsExcel:AddRow(cWorkSheet, cTitulo, {;
			QRY_DAD->FT_FILIAL,;   //1
			QRY_DAD->FT_NFISCAL,;   //2
			QRY_DAD->FT_SERIE,;   //3
			QRY_DAD->FT_CHVNFE,;   //4
			QRY_DAD->FT_CSTPIS,;  //5
			QRY_DAD->FT_CSTCOF,;  //6
			QRY_DAD->FT_CLIEFOR,;  //7
			QRY_DAD->FT_LOJA,;  //8
			QRY_DAD->A2_NOME,;  //9
			QRY_DAD->A2_EST,; //10
			STOD(QRY_DAD->FT_ENTRADA),; //11
			STOD(QRY_DAD->FT_EMISSAO),; //12
			QRY_DAD->FT_TIPOMOV,; //13
			QRY_DAD->FT_TES,; //14
			QRY_DAD->F4_TEXTO,; //15
			QRY_DAD->F4_ATUATF,; //16
			QRY_DAD->FT_CFOP,; //17
			QRY_DAD->FT_PRODUTO,; //18
			QRY_DAD->FT_ITEM,; //19
			QRY_DAD->B1_DESC,; //20
			QRY_DAD->D1_UM,; //21
			QRY_DAD->AH_DESCPO,; //22
			QRY_DAD->FT_ESPECIE,; //23
			QRY_DAD->X5_DESCRI,; //24
			QRY_DAD->FT_CODISS,; //25
			QRY_DAD->FT_CONTA,; //26
			QRY_DAD->CT1_DESC01,; //27
			QRY_DAD->FT_QUANT,; //28
			QRY_DAD->FT_PRCUNIT,; //29
			QRY_DAD->FT_DESCONT,; //30
			QRY_DAD->FT_VALCONT,; //31
			QRY_DAD->FT_TOTAL,; //32
			QRY_DAD->FT_BASEPIS,; //33
			QRY_DAD->FT_ALIQPIS,; //34
			QRY_DAD->FT_VALPIS,; //35
			QRY_DAD->FT_BASECOF,; //36
			QRY_DAD->FT_ALIQCOF,; //37
			QRY_DAD->FT_VALCOF,; //38
			QRY_DAD->FT_ALIQICM,; //39
			QRY_DAD->FT_BASEICM,; //40
			QRY_DAD->FT_VALICM,; //41
			QRY_DAD->FT_ISENICM,; //42
			QRY_DAD->FT_OUTRICM,; //43
			QRY_DAD->FT_BASEIPI,; //44
			QRY_DAD->FT_VALIPI,; //45
			QRY_DAD->FT_ISENIPI,; //46
			QRY_DAD->FT_OUTRIPI,; //47
			QRY_DAD->FT_BASERET,; //48
			QRY_DAD->FT_ICMSRET,; //49
			QRY_DAD->FT_OBSERV,; //50
			QRY_DAD->FT_TIPO,; //51
			QRY_DAD->FT_ICMSCOM,; //52
			QRY_DAD->FT_ICMSDIF,; //53
			QRY_DAD->FT_IPIOBS,; //54
			STOD(QRY_DAD->FT_DTCANC),; //55
			QRY_DAD->FT_ALIQIPI,; //56
			QRY_DAD->FT_CLASFIS,; //57
			QRY_DAD->FT_CTIPI,; //58
			QRY_DAD->FT_FRETE,; //59
			QRY_DAD->FT_SEGURO,; //60
			QRY_DAD->FT_DESPESA,; //61
			QRY_DAD->FT_ALIQIRR,; //62
			QRY_DAD->FT_BASEIRR,; //63
			QRY_DAD->FT_VALIRR,; //64
			QRY_DAD->FT_BASEINS,; //65
			QRY_DAD->FT_ALIQINS,; //66
			QRY_DAD->FT_VALINS,; //67
			QRY_DAD->FT_POSIPI,; //68
			QRY_DAD->FT_ESTOQUE,; //69
			QRY_DAD->FT_NFORI,; //70
			QRY_DAD->FT_SERORI,; //71
			QRY_DAD->FT_ITEMORI,; //72
			QRY_DAD->FT_BASECSL,; //73
			QRY_DAD->FT_ALIQCSL,; //74
			QRY_DAD->FT_VALCSL,; //75
			QRY_DAD->FT_RECISS,; //76
			QRY_DAD->FT_CSTISS,; //77
			QRY_DAD->FT_BRETPIS,; //78
			QRY_DAD->FT_BRETCOF,; //79
			QRY_DAD->FT_BRETCSL,; //80
			QRY_DAD->FT_VRETPIS,; //81
			QRY_DAD->FT_VRETCOF,; //82
			QRY_DAD->FT_VRETCSL,; //83
			QRY_DAD->FT_ARETPIS,; //84
			QRY_DAD->FT_ARETCOF,; //85
			QRY_DAD->FT_ARETCSL,; //86
			QRY_DAD->FT_BASEDES,; //87
			QRY_DAD->FT_PDDES,; //88
			QRY_DAD->FT_DIFAL,; //89
			QRY_DAD->D1_VALICM,; //90
			QRY_DAD->D1_ITEMCTA,; //91
			QRY_DAD->D1_CC,; //92
			QRY_DAD->VLTRIBIBS,; //93
            QRY_DAD->BASORIIBS,; //94
            QRY_DAD->ALIQORIBS,; //95
            QRY_DAD->CJ3_CSTIBS,; //96
            QRY_DAD->VLTRIBCBS,; //97
            QRY_DAD->BASORICBS,; //98
            QRY_DAD->ALIQORCBS,; //99
            QRY_DAD->CJ3_CSTCBS,; //100
            QRY_DAD->VLTRIBIBMUN,; //101
            QRY_DAD->BASORIIBMUN,; //102
            QRY_DAD->ALIQORIBMUN,; //103
            QRY_DAD->CSTIBMUN,; //104
			QRY_DAD->ALIQISS,; //105
			QRY_DAD->BASEISS,; //106
			QRY_DAD->VALISS,; //107
			QRY_DAD->FT_AGREG,; //108
			QRY_DAD->PEDIDO; //108
		})

		QRY_DAD->(DbSkip())
	EndDo
	QRY_DAD->(DbCloseArea())

	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)
	oExcel := MsExcel():New()
	oExcel:WorkBooks:Open(cArquivo)
	oExcel:SetVisible(.T.)
	oExcel:Destroy()

Return

Static Function CriaPerg(c_Perg)
Local o_Perguntas	:= clsComponentes():New()

//PutSx1(cGrupo,cOrdem,c_Pergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
o_Perguntas:mtdPutSX1( c_Perg, "01", "Data Entrada Inicial? 	", "", "", "mv_ch2", "D", 08, 0, 0, "G", "" , "MV_PAR01", ""    , "", "", "", "", ""   , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" )
o_Perguntas:mtdPutSX1( c_Perg, "02", "Data Entrada Final? 	    ", "", "", "mv_ch3", "D", 08, 0, 0, "G", "" , "MV_PAR02", ""    , "", "", "", "", ""   , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" )
o_Perguntas:mtdPutSX1( c_Perg, "03", "Filial Inicial?           ", "", "", "mv_ch1", "C", 04, 0, 0, "G", "" , "MV_PAR03", ""    , "", "", "", "", ""   , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0"   , "", "", "", "", "" )
o_Perguntas:mtdPutSX1( c_Perg, "04", "Filial Final?             ", "", "", "mv_ch1", "C", 04, 0, 0, "G", "" , "MV_PAR04", ""    , "", "", "", "", ""   , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0"   , "", "", "", "", "" )
Return

