#include "rwmake.ch"
#include "Topconn.ch"
#INCLUDE "PROTHEUS.CH"

#define X1_HELP		41

User Function DESTR082()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DESTR082  ºAutor ³Emerson Costa Holandaº Data ³  19/06/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio Movimentação de estoque 		                 º±±
±±Entrada Nf X Entrada 3º X Saida Produçao X Saida NF X Saida 3º    	 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DHL                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Local aArea := GetArea()
Private cAliasDoc // tabela temporaria de documentos
Private oReport

//CriaPerg()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao -- Excel                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= ReportDef()
oReport:PrintDialog()

RestArea(aArea)
GFEDelTab(cAliasDoc)

Return NIL

//--------------------------------------------------------------------------------------------------------
/*/ {Protheus.doc}  ReportDef
A funcao estatica ReportDef devera ser criada para todos os relatorios que poderao ser agendados pelo usuario.
@return oReport Objeto do Relatorio.
/*/
//--------------------------------------------------------------------------------------------------------

Static Function ReportDef()
Local oReport, oSection

//+------------------------------------------------------------------------+
//| "Criacao do componente de impressao                                      | "
//| "                                                                        | "
//| "TReport():New                                                           | "
//| "ExpC1 : Nome do relatorio                                               | "
//| "ExpC2 : Titulo                                                          | "
//| "ExpC3 : Pergunte                                                        | "
//| "ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  | "
//| "ExpC5 : Descricao                                                       | "
//| "                                                                        | "
//+------------------------------------------------------------------------+

oReport := TReport():New("DESTR082 - Mov. Est. X Prod. x Terc.","Mov. Est. X Prod. x Terc.","DESTR082", {|oReport| ReportPrint(oReport)},"Emite relatório com a movimentação do estoque. produção e terceiros"/*Descricao do relatório*/)
oReport:SetLandscape(.T.)   //Define a oriadmientação de página do relatório como paisagem  ou retrato. .F.=Retrato; .T.=Paisagem
oReport:SetTotalInLine(.T.) //Define se os totalizadores serão impressos em linha ou coluna
//oReport:HideParamPage() //Oculta página de parametros
If !Empty(oReport:uParam)
	Pergunte(oReport:uParam,.F.)
EndIf
oSection := TRSection():New(oReport,"Mov. Est. X Prod. x Terc.",{"(cAliasDoc)","SB1","SB2","SB6"	},{"Mov. Est. X Prod. x Terc."}/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
//Exemplo utilizando a tabela de clientes.
oSection:SetTotalInLine(.T.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha

//+------------------------------------------------------------------------+
//|Criacao da celulas da secao do relatorio                                |
//|                                                                        |
//|TRCell():New                                                            |
//|ExpO1 : Objeto TSection que a secao pertence                            |
//|ExpC2 : Nome da celula do relatório. O SX3 será consultado              |
//|ExpC3 : Nome da tabela de referencia da celula                          |
//|ExpC4 : Titulo da celula                                                |
//|        Default : X3Titulo()                                            |
//|ExpC5 : Picture                                                         |
//|        Default : X3_PICTURE                                            |
//|ExpC6 : Tamanho                                                         |
//|        Default : X3_TAMANHO                                            |
//|ExpL7 : Informe se o tamanho esta em pixel                              |
//|        Default : False                                                 |
//|ExpB8 : Bloco de código para impressao.                                 |
//|        Default : ExpC2                                                 |
//|                                                                        |
//+------------------------------------------------------------------------+
//	GetSx3Inf @return aRetorno Array {cTitulo,cCbox,cPicture}
//TRCell():New(oSection,/*X3_CAMPO*/,/*Tabela*/,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->B1_FILIAL","(cAliasDoc)"   ,"Filial"             		,GetSx3Inf("B1_FILIAL")[3],/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->B1_COD","(cAliasDoc)"      ,"Produto"            		,GetSx3Inf("B1_COD")[3],/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->B1_DESC","(cAliasDoc)"     ,"Descrição"          		,GetSx3Inf("B1_DESC")[3],/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->B1_TIPO","(cAliasDoc)"     ,"Tipo   "            		,GetSx3Inf("B1_TIPO")[3],/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->B1_UM","(cAliasDoc)"       ,"Unidade"            		,GetSx3Inf("B1_UM")[3],/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->DTFECH","(cAliasDoc)"      ,"Data Fechamento"    		,GetSx3Inf("B9_DATA")[3],/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDFECH","(cAliasDoc)"     ,"Qtd Fechamento"        	,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDDEVP","(cAliasDoc)"     ,"Qtd Entrada Dev. Producao / Inventario"        	,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDENTB2","(cAliasDoc)"    ,"Qtd Entrada NF Fisico e Terceiro"    	,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDENTSP3","(cAliasDoc)"   ,"Qtd Entrada NF Fisico sem Terceiro"    	,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDENTB6","(cAliasDoc)"    ,"Qtd Entrada Terceiros NF" 	,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDDIFENT","(cAliasDoc)"   ,"Dif. Entrada NF Fisico e Terceiro X Entrada Terceiros NF","@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->SAIDINV","(cAliasDoc)"    ,"Qtd Saida Inventario"     ,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDSAID3","(cAliasDoc)"    ,"Qtd Saida Apto Producao"    	,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDSAIB2","(cAliasDoc)"    ,"Qtd Saida NF Fisico e Terceiro"     		,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDSAIP3","(cAliasDoc)"   ,"Qtd Saida NF Fisico sem Terceiro"    	,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDSAIB6","(cAliasDoc)"    ,"Qtd Saida Terceiros (SB6)"   	,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDDIFSAI","(cAliasDoc)"   ,"Dif. Saida Fisico NF X Saida Terceiros NF" 	,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->DTFIM","(cAliasDoc)"       ,"Data Final Analise"    	,GetSx3Inf("B9_DATA")[3],/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDTOTENT","(cAliasDoc)"   ,"Total Entradas + Qtd Fechamento "    		,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDTOTSAI","(cAliasDoc)"   ,"Total Saidas"      		,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"(cAliasDoc)->QTDSLDFIM","(cAliasDoc)"   ,"Saldo Final"   			,"@E 999,999.99",	10/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return oReport
/*/ {Protheus.doc}  ReportPrint
A funcao estatica ReportDef devera ser criada para todos os relatorios que poderao ser agendados pelo usuario.
@param oReport Objeto do relatório
/*/

Static Function ReportPrint(oReport)
Local oSection  := oReport:Section(1)
oSection:Init()
oSection:SetHeaderSection(.T.)

CarregaDados()

While !(cAliasDoc)->(Eof())
	oSection:PrintLine()
	(cAliasDoc)->(dbSkip())
EndDo
oSection:Finish()
Return Nil

/*/ {Protheus.doc}  CriaTabTemp
A funcao estatica CriaTabTemp Cria a struct dos dados do relatório e cria as tabelas temporárias, privadas em GFER051()
@return {aStruDoc} Array com Struct dos campos
/*/

Static Function CriaTabTemp()
Local  aStruDoc

aStruDoc 	:= {;
{"B1_FILIAL"	,"C",TamSX3("B1_FILIAL" )[1],0},;
{"B1_COD"	    ,"C",TamSX3("B1_COD" )[1],0},;
{"B1_DESC"	    ,"C",TamSX3("B1_DESC" )[1],0},;
{"B1_TIPO" 		,"C",TamSX3("B1_TIPO" )[1],0},;
{"B1_UM"   		,"C",TamSX3("B1_UM" )[1],0},;
{"DTFECH"	    ,"D",TamSX3("B9_DATA")[1],TamSX3("B9_DATA" )[2]},;
{"QTDFECH"     	,"N",TamSX3("F2_VALMERC" )[1],TamSX3("F2_VALMERC" )[2]},;
{"QTDDEVP"     	,"N",TamSX3("F2_VALMERC" )[1],TamSX3("F2_VALMERC" )[2]},;
{"QTDENTB2"   	,"N",TamSX3("F2_VALBRUT" )[1],TamSX3("F2_VALMERC" )[2]},;
{"QTDENTSP3"   	,"N",TamSX3("F2_VALBRUT" )[1],TamSX3("F2_VALMERC" )[2]},;
{"QTDENTB6"   	,"N",TamSX3("F2_VALMERC" )[1],TamSX3("F2_VALMERC" )[2]},;
{"QTDDIFENT"   	,"N",TamSX3("F2_VALMERC" )[1],TamSX3("F2_VALMERC" )[2]},;
{"SAIDINV"      ,"N",TamSX3("F2_VALMERC" )[1],TamSX3("F2_VALMERC" )[2]},;
{"QTDSAID3"     ,"N",TamSX3("F2_VALMERC" )[1],TamSX3("F2_VALMERC" )[2]},;
{"QTDSAIB2"   	,"N",TamSX3("F2_VALBRUT" )[1],TamSX3("F2_VALMERC" )[2]},;
{"QTDSAIP3"   	,"N",TamSX3("F2_VALBRUT" )[1],TamSX3("F2_VALMERC" )[2]},;
{"QTDSAIB6"    	,"N",TamSX3("F2_VALMERC" )[1],TamSX3("F2_VALMERC" )[2]},;
{"QTDDIFSAI"   	,"N",TamSX3("F2_VALMERC" )[1],TamSX3("F2_VALMERC" )[2]},;
{"DTFIM"	    ,"D",TamSX3("B9_DATA")[1],TamSX3("B9_DATA" )[2]},;
{"QTDTOTENT"    ,"N",TamSX3("F2_VALMERC" )[1],TamSX3("F2_VALMERC" )[2]},;
{"QTDTOTSAI"   	,"N",TamSX3("F2_VALBRUT" )[1],TamSX3("F2_VALMERC" )[2]},;
{"QTDSLDFIM"   	,"N",TamSX3("F2_VALMERC" )[1],TamSX3("F2_VALMERC" )[2]};
}

cAliasDoc :=  GFECriaTab({aStruDoc,{"B1_FILIAL+B1_COD"}})
(cAliasDoc)->(dbSetOrder(1))

Return {aStruDoc}


/*/{Protheus.doc} CarregaDados()
@description
A função estática CarregaDados alimenta as tabelas temporárias(cAliasDoc)  para uso no relatório
@example
CarregaDados()
/*/

Static Function CarregaDados()


CriaTabTemp()


CQUERY := " SELECT B1_COD, B1_DESC, B1_TIPO,B1_UM "

CQUERY += " ,(  "
CQUERY += " select SUM(SB9.B9_QINI) "
CQUERY += " FROM " +RetSqlName ('SB9')+" SB9 "
CQUERY += " WHERE SB9.D_E_L_E_T_ <> '*' "
CQuery += " AND     SB9.B9_FILIAL  = '"+ cFilAnt + "'AND SB9.B9_FILIAL     <= '" + cFilAnt+ "' "
CQuery += " AND     SB9.B9_DATA    >= '"+ DTOS(MV_PAR01)+"' AND SB9.B9_DATA     <= '" + DTOS(MV_PAR01)+ "' "
CQUERY += " AND     SB1.B1_COD = SB9.B9_COD  "
CQUERY += "   ) TOT_SB9   "

CQUERY += " ,(  "
CQUERY += " select SUM(D3_QUANT)  "
CQUERY += " FROM " +RetSqlName ('SD3')+" SD3 "
CQUERY += " WHERE SD3.D_E_L_E_T_ <> '*' "
CQuery += " AND     SD3.D3_FILIAL  = '"+ cFilAnt + "'AND SD3.D3_FILIAL   <= '" + cFilAnt+ "' "
CQUERY += " AND  D3_COD  = B1_COD AND D3_TM < '500' "
CQuery += " AND     SD3.D3_EMISSAO > '"+ DTOS(MV_PAR01) + "'AND SD3.D3_EMISSAO   <= '" + DTOS(MV_PAR04)+ "' "
CQUERY += "   ) TOT_ENTD3   "

CQUERY += " ,(  "
CQUERY += " select SUM(SD1.D1_QUANT)   "
CQUERY += " FROM " +RetSqlName ('SD1')+" SD1 "
CQUERY += " LEFT JOIN " +RetSqlName ('SF4')+" SF4 "+"  ON SD1.D1_FILIAL = F4_FILIAL AND SD1.D1_TES = F4_CODIGO AND SF4.D_E_L_E_T_ <> '*' "
CQUERY += " WHERE SD1.D_E_L_E_T_ <> '*' "
CQuery += " AND     SD1.D1_FILIAL  = '"+ cFilAnt + "'AND SD1.D1_FILIAL   <= '" + cFilAnt+ "' "
CQUERY += " AND   SD1.D1_COD = B1_COD "
CQUERY += " AND F4_ESTOQUE = 'S' AND F4_PODER3 = 'R'  "
CQuery += " AND     SD1.D1_DTDIGIT > '"+ DTOS(MV_PAR01) + "'AND SD1.D1_DTDIGIT   <= '" + DTOS(MV_PAR04)+ "' "
CQUERY += "   ) TOT_ENTB2   "

CQUERY += " ,(  "
CQUERY += " select SUM(SD1.D1_QUANT)   "
CQUERY += " FROM " +RetSqlName ('SD1')+" SD1 "
CQUERY += " LEFT JOIN " +RetSqlName ('SF4')+" SF4 "+"  ON SD1.D1_FILIAL = F4_FILIAL AND SD1.D1_TES = F4_CODIGO AND SF4.D_E_L_E_T_ <> '*' "
CQUERY += " WHERE SD1.D_E_L_E_T_ <> '*' "
CQuery += " AND     SD1.D1_FILIAL  = '"+ cFilAnt + "'AND SD1.D1_FILIAL   <= '" + cFilAnt+ "' "
CQUERY += " AND   SD1.D1_COD = B1_COD "
CQUERY += " AND F4_ESTOQUE = 'S' AND F4_PODER3 <> 'R'  "
CQuery += " AND     SD1.D1_DTDIGIT > '"+ DTOS(MV_PAR01) + "'AND SD1.D1_DTDIGIT   <= '" + DTOS(MV_PAR04)+ "' "
CQUERY += "   ) TOT_ENTSEMB6   "

CQUERY += " ,(  "
CQUERY += " select SUM(B6_QUANT)   "
CQUERY += " FROM " +RetSqlName ('SB6')+" SB6 "
CQUERY += " WHERE SB6.D_E_L_E_T_ <> '*' "
CQuery += " AND     SB6.B6_FILIAL  = '"+ cFilAnt + "'AND SB6.B6_FILIAL   <= '" + cFilAnt+ "' "
CQUERY += " AND SB6.B6_PRODUTO = SB1.B1_COD AND SB6.B6_PODER3 = 'R'  "
CQuery += " AND     SB6.B6_DTDIGIT > '"+ DTOS(MV_PAR01) + "'AND SB6.B6_DTDIGIT   <= '" + DTOS(MV_PAR04)+ "' "
CQUERY += "   ) TOT_ENTB6   "

CQUERY += " ,(  "
CQUERY += " select SUM(D3_QUANT)  "
CQUERY += " FROM " +RetSqlName ('SD3')+" SD3 "
CQUERY += " WHERE SD3.D_E_L_E_T_ <> '*' "
CQuery += " AND     SD3.D3_FILIAL  = '"+ cFilAnt + "'AND SD3.D3_FILIAL   <= '" + cFilAnt+ "' "
CQUERY += " AND  D3_COD  = B1_COD AND D3_TM = '999' "
CQuery += " AND     SD3.D3_EMISSAO > '"+ DTOS(MV_PAR01) + "'AND SD3.D3_EMISSAO   <= '" + DTOS(MV_PAR04)+ "' "
CQUERY += "   ) TOT_SAID3   "

CQUERY += " ,(  "
CQUERY += " select SUM(D3_QUANT)  "
CQUERY += " FROM " +RetSqlName ('SD3')+" SD3 "
CQUERY += " WHERE SD3.D_E_L_E_T_ <> '*' "
CQuery += " AND     SD3.D3_FILIAL  = '"+ cFilAnt + "'AND SD3.D3_FILIAL   <= '" + cFilAnt+ "' "
CQUERY += " AND  D3_COD  = B1_COD AND D3_TM >= '500' AND D3_TM < '999' "
CQuery += " AND     SD3.D3_EMISSAO > '"+ DTOS(MV_PAR01) + "'AND SD3.D3_EMISSAO   <= '" + DTOS(MV_PAR04)+ "' "
CQUERY += "   ) TOTINVSAID   "

CQUERY += " ,(  "
CQUERY += " select SUM(D2_QUANT)   "
CQUERY += " FROM " +RetSqlName ('SD2')+" SD2 "
CQUERY += " LEFT JOIN " +RetSqlName ('SF4')+" SF4 "+"  ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ <> '*' "
CQUERY += " WHERE SD2.D_E_L_E_T_ <> '*' "
CQuery += " AND     SD2.D2_FILIAL  = '"+ cFilAnt + "'AND SD2.D2_FILIAL   <= '" + cFilAnt+ "' "
CQUERY += " AND D2_COD =  B1_COD "
CQUERY += " AND F4_ESTOQUE = 'S' AND F4_PODER3 = 'D'  "
CQuery += " AND     SD2.D2_EMISSAO > '"+ DTOS(MV_PAR01) + "'AND SD2.D2_EMISSAO  <= '" + DTOS(MV_PAR04)+ "' "
CQUERY += "   ) TOT_SAIB2   "

CQUERY += " ,(  "
CQUERY += " select SUM(D2_QUANT)   "
CQUERY += " FROM " +RetSqlName ('SD2')+" SD2 "
CQUERY += " LEFT JOIN " +RetSqlName ('SF4')+" SF4 "+"  ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ <> '*' "
CQUERY += " WHERE SD2.D_E_L_E_T_ <> '*' "
CQuery += " AND     SD2.D2_FILIAL  = '"+ cFilAnt + "'AND SD2.D2_FILIAL   <= '" + cFilAnt+ "' "
CQUERY += " AND D2_COD =  B1_COD "
CQUERY += " AND F4_ESTOQUE = 'S' AND F4_PODER3 = 'N'  "
CQuery += " AND     SD2.D2_EMISSAO > '"+ DTOS(MV_PAR01) + "'AND SD2.D2_EMISSAO  <= '" + DTOS(MV_PAR04)+ "' "
CQUERY += "   ) TOT_SAIP3   "

CQUERY += " ,(  "
CQUERY += " select SUM(B6_QUANT)   "
CQUERY += " FROM " +RetSqlName ('SB6')+" SB6 "
CQUERY += " WHERE SB6.D_E_L_E_T_ <> '*' "
CQuery += " AND     SB6.B6_FILIAL  = '"+ cFilAnt + "'AND SB6.B6_FILIAL   <= '" + cFilAnt+ "' "
CQUERY += " AND SB6.B6_PRODUTO = SB1.B1_COD AND SB6.B6_PODER3 = 'D'  "
CQuery += " AND     SB6.B6_DTDIGIT > '"+ DTOS(MV_PAR01) + "'AND SB6.B6_DTDIGIT   <= '" + DTOS(MV_PAR04)+ "' "
CQUERY += "   ) TOT_SAIB6   "


CQUERY += " FROM "      +RetSqlName ('SB1')+" SB1 "
CQUERY += " INNER JOIN " +RetSqlName ('SB2')+" SB2 "+"  ON B2_FILIAL = B1_FILIAL AND B2_COD = B1_COD AND SB2.D_E_L_E_T_ <> '*' "

CQUERY += " WHERE SB1.D_E_L_E_T_<> '*' "
CQuery += " AND     SB1.B1_COD    >= '"+ MV_PAR02+"' AND SB1.B1_COD      <= '" + MV_PAR03+ "' "
CQuery += " AND     SB1.B1_FILIAL  = '"+ cFilAnt + "'AND SB1.B1_FILIAL     <= '" + cFilAnt+ "' "
CQuery += " GROUP BY B1_COD,B2_COD,B1_DESC,B1_TIPO,B1_UM "
CQuery += " ORDER BY B1_COD "

IF SELECT("TD2")<> 0
	TD2->(DBCLOSEAREA())
ENDIF

TCQUERY CQUERY NEW ALIAS "TD2"

TD2->(DBGOTOP())
oReport:SetMeter(TD2->(RecCount()))
If !TD2->(EOF())
	While !TD2->(EOF())
		If oReport:Cancel()
			Exit
		EndIf
		
		RecLock((cAliasDoc),.T.)
		
		
		(cAliasDoc)->B1_FILIAL	  		:= cFilAnt
		(cAliasDoc)->B1_COD  	  		:= TD2->B1_COD
		(cAliasDoc)->B1_DESC	  		:= TD2->B1_DESC
		(cAliasDoc)->B1_TIPO	  		:= TD2->B1_TIPO
		(cAliasDoc)->B1_UM		  		:= TD2->B1_UM
		(cAliasDoc)->DTFECH		  		:= MV_PAR01
		(cAliasDoc)->QTDFECH  		    := TD2->TOT_SB9
		(cAliasDoc)->QTDDEVP  		    := TD2->TOT_ENTD3
		
		(cAliasDoc)->QTDENTB2  		    := TD2->TOT_ENTB2 
		(cAliasDoc)->QTDENTSP3  		:= TD2->TOT_ENTSEMB6
		(cAliasDoc)->QTDENTB6	     	:= TD2->TOT_ENTB6   
		(cAliasDoc)->QTDDIFENT	     	:= TD2->TOT_ENTB2 - TD2->TOT_ENTB6 
		
		(cAliasDoc)->SAIDINV  	     	:= TD2->TOTINVSAID
		(cAliasDoc)->QTDSAID3  	     	:= TD2->TOT_SAID3
		(cAliasDoc)->QTDSAIB2  	     	:= TD2->TOT_SAIB2
		(cAliasDoc)->QTDSAIP3  	     	:= TD2->TOT_SAIP3 
		(cAliasDoc)->QTDSAIB6  	     	:= TD2->TOT_SAIB6
		(cAliasDoc)->QTDDIFSAI 	     	:= (TD2->TOT_SAID3+TD2->TOT_SAIB2) - TD2->TOT_SAIB6
		
		(cAliasDoc)->DTFIM  	     	:= MV_PAR04
 
		(cAliasDoc)->QTDTOTENT       	:= TD2->TOT_SB9 + TD2->TOT_ENTD3 + TD2->TOT_ENTB2 + TD2->TOT_ENTSEMB6 
		(cAliasDoc)->QTDTOTSAI       	:= TD2->TOTINVSAID + TD2->TOT_SAID3 + TD2->TOT_SAIB2 + TD2->TOT_SAIP3
		(cAliasDoc)->QTDSLDFIM       	:= (TD2->TOT_SB9 + TD2->TOT_ENTD3 + TD2->TOT_ENTB2+ TD2->TOT_ENTSEMB6 ) - (TD2->TOTINVSAID+TD2->TOT_SAID3 + TD2->TOT_SAIB2+TD2->TOT_SAIP3)		
		

		MsUnlock((cAliasDoc))
		
		
		
		oReport:IncMeter()
		
		TD2->(Dbskip())
	End
EndIf

(cAliasDoc)->(dbGoTop())

Return Nil

Static Function GetSx3Inf(cCampo,aRetorno)
Local nCont := 1
Local aArea := GetArea("SX3")
Default aRetorno := {"","","",""}
For nCont := 1 to 4-Len(aRetorno)
	aAdd(aRetorno,"")
Next
dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek( cCampo )
	aRetorno[1] := X3Titulo()
	aRetorno[2] := X3Cbox()
	aRetorno[3] := X3Picture()
	aRetorno[4] := X3DESCRIC()
EndIf
RestArea(aArea)
Return aRetorno

Static Function  CriaPerg()

	local cPerg		:= "DESTR082"
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
	
	aAdd(aRegs,{cPerg/*X1_GRUPO*/, "01"/*X1_ORDEM*/, "Data Fechamento?"/*X1_PERGUNT*/,""/*X1_PERSPA*/,""/*X1_PERENG*/,"MV_CH1"/*X1_VARIAVL*/, "D"/*X1_TIPO*/,8/*X1_TAMANHO*/,0/*X1_DECIMAL*/,1/*X1_PRESEL*/, "G"/*X1_GSC*/, cValid/*X1_VALID*/, "MV_PAR01"/*X1_VAR01*/, cDef01/*X1_DEF01*/, ""/*X1_DEFSPA1*/,""/*X1_DEFENG1*/,""/*X1_CNT01*/,""/*X1_VAR02*/,cDef02/*X1_DEF02*/,""/*X1_DEFSPA2*/,""/*X1_DEFENG2*/,""/*X1_CNT02*/,""/*X1_VAR03*/,cDef03/*X1_DEF03*/,""/*X1_DEFSPA3*/,""/*X1_DEFENG3*/,""/*X1_CNT03*/,""/*X1_VAR04*/,cDef04/*X1_DEF04*/,""/*X1_DEFSPA4*/,""/*X1_DEFENG4*/,""/*X1_CNT04*/,""/*X1_VAR05*/,cDef05/*X1_DEF05*/,""/*X1_DEFSPA5*/,""/*X1_DEFENG5*/,""/*X1_CNT05*/,cF3/*X1_F3*/, ""/*X1_PYME*/, ""/*X1_GRPSXG*/, "Informe a data do ultimo fechamento para ser utilizada como data inicial para refazer as movimentações de estoque"/*X1_HELP*/, cPicture/*X1_PICTURE*/,""/*X1_IDFIL*/})
	aAdd(aRegs,{cPerg/*X1_GRUPO*/, "02"/*X1_ORDEM*/, "Produto de ?"/*X1_PERGUNT*/,""/*X1_PERSPA*/,""/*X1_PERENG*/,"MV_CH2"/*X1_VARIAVL*/, "C"/*X1_TIPO*/,TamSX3('B1_COD')[01]/*X1_TAMANHO*/,0/*X1_DECIMAL*/,1/*X1_PRESEL*/, "G"/*X1_GSC*/, cValid/*X1_VALID*/, "MV_PAR02"/*X1_VAR01*/, cDef01/*X1_DEF01*/, ""/*X1_DEFSPA1*/,""/*X1_DEFENG1*/,""/*X1_CNT01*/,""/*X1_VAR02*/,cDef02/*X1_DEF02*/,""/*X1_DEFSPA2*/,""/*X1_DEFENG2*/,""/*X1_CNT02*/,""/*X1_VAR03*/,cDef03/*X1_DEF03*/,""/*X1_DEFSPA3*/,""/*X1_DEFENG3*/,""/*X1_CNT03*/,""/*X1_VAR04*/,cDef04/*X1_DEF04*/,""/*X1_DEFSPA4*/,""/*X1_DEFENG4*/,""/*X1_CNT04*/,""/*X1_VAR05*/,cDef05/*X1_DEF05*/,""/*X1_DEFSPA5*/,""/*X1_DEFENG5*/,""/*X1_CNT05*/,"SB1"/*X1_F3*/, ""/*X1_PYME*/, ""/*X1_GRPSXG*/, "Informe o produto inicial, para filtrar, caso queira todos os produtos deixar esse campo em branco"/*X1_HELP*/, cPicture/*X1_PICTURE*/,""/*X1_IDFIL*/})
	aAdd(aRegs,{cPerg/*X1_GRUPO*/, "03"/*X1_ORDEM*/, "Produto até?"/*X1_PERGUNT*/,""/*X1_PERSPA*/,""/*X1_PERENG*/,"MV_CH3"/*X1_VARIAVL*/, "C"/*X1_TIPO*/,TamSX3('B1_COD')[01]/*X1_TAMANHO*/,0/*X1_DECIMAL*/,1/*X1_PRESEL*/, "G"/*X1_GSC*/, cValid/*X1_VALID*/, "MV_PAR03"/*X1_VAR01*/, cDef01/*X1_DEF01*/, ""/*X1_DEFSPA1*/,""/*X1_DEFENG1*/,""/*X1_CNT01*/,""/*X1_VAR02*/,cDef02/*X1_DEF02*/,""/*X1_DEFSPA2*/,""/*X1_DEFENG2*/,""/*X1_CNT02*/,""/*X1_VAR03*/,cDef03/*X1_DEF03*/,""/*X1_DEFSPA3*/,""/*X1_DEFENG3*/,""/*X1_CNT03*/,""/*X1_VAR04*/,cDef04/*X1_DEF04*/,""/*X1_DEFSPA4*/,""/*X1_DEFENG4*/,""/*X1_CNT04*/,""/*X1_VAR05*/,cDef05/*X1_DEF05*/,""/*X1_DEFSPA5*/,""/*X1_DEFENG5*/,""/*X1_CNT05*/,"SB1"/*X1_F3*/, ""/*X1_PYME*/, ""/*X1_GRPSXG*/, "Informe o produto final, para filtrar, caso queira todos os produtos preencher esse campo com ZZZZZZZZZZZZZZZ"/*X1_HELP*/, cPicture/*X1_PICTURE*/,""/*X1_IDFIL*/})
	aAdd(aRegs,{cPerg/*X1_GRUPO*/, "04"/*X1_ORDEM*/, "Data Final?"/*X1_PERGUNT*/,""/*X1_PERSPA*/,""/*X1_PERENG*/,"MV_CH4"/*X1_VARIAVL*/, "D"/*X1_TIPO*/,8/*X1_TAMANHO*/,0/*X1_DECIMAL*/,1/*X1_PRESEL*/, "G"/*X1_GSC*/, cValid/*X1_VALID*/, "MV_PAR04"/*X1_VAR01*/, cDef01/*X1_DEF01*/, ""/*X1_DEFSPA1*/,""/*X1_DEFENG1*/,""/*X1_CNT01*/,""/*X1_VAR02*/,cDef02/*X1_DEF02*/,""/*X1_DEFSPA2*/,""/*X1_DEFENG2*/,""/*X1_CNT02*/,""/*X1_VAR03*/,cDef03/*X1_DEF03*/,""/*X1_DEFSPA3*/,""/*X1_DEFENG3*/,""/*X1_CNT03*/,""/*X1_VAR04*/,cDef04/*X1_DEF04*/,""/*X1_DEFSPA4*/,""/*X1_DEFENG4*/,""/*X1_CNT04*/,""/*X1_VAR05*/,cDef05/*X1_DEF05*/,""/*X1_DEFSPA5*/,""/*X1_DEFENG5*/,""/*X1_CNT05*/,cF3/*X1_F3*/, ""/*X1_PYME*/, ""/*X1_GRPSXG*/, "Informe a data final a ser considerada para refazer as movimentações de estoque"/*X1_HELP*/, cPicture/*X1_PICTURE*/,""/*X1_IDFIL*/})
	
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
