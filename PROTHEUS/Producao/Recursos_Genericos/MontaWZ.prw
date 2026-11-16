#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaWZ   ºAutor  ³João Zabotto        º Data ³  07/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa de importacao de tabelas                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MontaWZ()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local oWizard
	Local nMetGlob
	Local nMetParc
	Local oSay1
	Local otblImp
	Local oRotImp
	Local oRotpar

	Local cText
	Local cFile			:= replicate( " ", 80 )
	Local cHeader 		:= "Importação de dados"
	Local cTpArq		:= "Delimitado (*.csv)|*.CSV|"
	Local cDelim		:= AllTrim(SuperGetMV("MV_TPDELI",.F.,';'))
	Local nLinCabec		:= 1 // Padrão sem linha de cabeçalho
	Local cCabec		:= "" // String com o cabeçalho do arquivo original, se houver
	Local nQtdCab		:= 1 // String com o cabeçalho do arquivo original, se houver
	Local cNmAlias		:= "Clientes (SA1)"
	Local cTipo			:= "1"
	Local cTextRot      := ""

	Private INCLUI	:= .T.
	Private ALTERA	:= .F.
	Private ctblImp := "   "
	Private cRotImp := replicate( " ", 40 )
	Private nRotpar := 0

	cText 	:= 	 "Esta rotina tem por objetivo importar registros, através " + ;
		"de um arquivo padrão CSV (delimitado) , e armazena-los na tabela "+ ;
		"correspondente do sistema."+ CRLF + ;
		"Os nomes das colunas devem ser os mesmos nomes de campos a serem atualizados."+ CRLF + CRLF + ;
		"Ao final da importação será gerado um arquivo de log contendo as "+ ;
		"inconsistências." + CRLF + CRLF + CRLF + CRLF + CRLF + CRLF + CRLF + CRLF + CRLF + ;
		"Desenvolvido por João Zabotto";

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Primeiro Painel - Abertura     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DEFINE WIZARD oWizard 	TITLE "Importação de dados" ;
		HEADER cHeader ;
		MESSAGE "Apresentação." ;
		TEXT cText ;
		NEXT { || .T. } ;
		FINISH {|| .T.} PANEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Segundo Painel - Arquivo e Contrato ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CREATE PANEL oWizard 	HEADER cHeader ;
		MESSAGE "Selecione os tabela que deseja importar" ;
		BACK {|| .T. } ;
		NEXT {|| .T. } ;
		FINISH {|| .F. } ;
		PANEL

	oPanel := oWizard:GetPanel( 2 )

	@ 15, 08 GROUP oGrpCon 	TO 120, 230 LABEL "Cadastro a ser importado" OF oPanel PIXEL DESIGN

	@ 026, 020 SAY oSay1 PROMPT "Tabela" SIZE 021, 007 OF oPanel COLORS 0, 16777215 PIXEL
	@ 026, 050 MSGET otblImp VAR ctblImp SIZE 044, 010 OF oPanel COLORS 0, 16777215 F3 "SX21" PIXEL
	@ 040, 020 SAY oSay1 PROMPT "Rotina" SIZE 021, 007 OF oPanel COLORS 0, 16777215 PIXEL
	@ 040, 050 MSGET oRotImp VAR cRotImp SIZE 044, 010 OF oPanel COLORS 0, 16777215 PIXEL
	@ 056, 020 SAY oSay1 PROMPT "Parâmetros" SIZE 023, 007 OF oPanel COLORS 0, 16777215 PIXEL
	@ 056, 050 MSGET oRotpar VAR nRotpar SIZE 044, 010 OF oPanel COLORS 0, 16777215 PIXEL

	cTextRot:= "Informe a quantidade de paramêtros da rotina, Exemplo para rotina " + ;
		" GPEA010 possui 4 paramêtros, GPEA010(a,b,c,d), informe o valor 4 " ;

		@ 075, 020 SAY oSay1 PROMPT cTextRot SIZE 200, 50 OF oPanel COLOR CLR_HBLUE PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Segundo Painel - Arquivo e Contrato ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CREATE PANEL oWizard 	HEADER cHeader ;
		MESSAGE "Selecione o arquivo para importação." ;
		BACK {|| .T. } ;
		NEXT {|| ! empty( cDelim ) .and. ! empty( cFile ) } ;
		FINISH {|| .F. } ;
		PANEL

	oPanel := oWizard:GetPanel( 3 )

	@ 10, 08 GROUP oGrpCon 	TO 40, 280 LABEL "Selecione um arquivo." ;
		OF oPanel ;
		PIXEL ;
		DESIGN

	@ 20, 15 MSGET oArq 	VAR cFile WHEN .F. OF oPanel SIZE 140, 10 PIXEL ;
		MESSAGE "Utilize o botão ao lado para selecionar" ;

		DEFINE SBUTTON oButArq 	FROM 21, 160 ;
		TYPE 14 ;
		ACTION cFile := cGetFile(cTpArq, , 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE) ;
		OF oPanel ;
		ENABLE

	@ 50, 08 GROUP oGrpCon 	TO 130, 280 LABEL "Informe as configurações do arquivo." ;
		OF oPanel ;
		PIXEL ;
		DESIGN

	@ 60,20 SAY "Delimitador" OF oPanel SIZE 35,8 PIXEL
	@ 60,60 MSGET oDelim	VAR cDelim  ;
		PICTURE "@!" ;
		VALID !empty(cDelim) ;
		MESSAGE "Informe um delimitador de campo." ;
		OF oPanel SIZE 10,8 PIXEL

	@ 80,20 SAY "Tipo" OF oPanel SIZE 35,8 PIXEL
	@ 80,60 COMBOBOX oTipo  Var cTipo ITEMS {"1=Somente Log","2=Log + Importação"} 	SIZE 200,010 OF oPanel PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Terceiro Painel - Confirmacao  / Processamento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CREATE PANEL oWizard 	HEADER cHeader ;
		MESSAGE "Confirmação dos dados e início de processamento." ;
		BACK {|| .T. } ;
		NEXT {|| .T. } ;
		FINISH {|| .F. } ;
		PANEL

	oPanel := oWizard:GetPanel( 4 )

	@ 010, 010 SAY "Arquivo" OF oPanel SIZE 140, 8 PIXEL
	@ 010, 050 SAY cFile  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL

	@ 030, 010 SAY  "Delimitador" OF oPanel SIZE 140, 8 PIXEL
	@ 030, 050 SAY  cDelim  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL


	@ 050, 010 SAY  "Alias" OF oPanel SIZE 140, 8 PIXEL
	@ 050, 050 SAY  ctblImp  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL


	@ 070, 010 SAY  "Tipo Proc.:" OF oPanel SIZE 140, 8 PIXEL
	@ 070, 050 SAY  IIf(cTipo=="1","Somente Log","Log+Importação")  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quarto Painel - Processamento                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CREATE PANEL oWizard 	HEADER cHeader ;
		MESSAGE "Processamento da Importação." ;
		BACK {|| .F. } ;
		NEXT {|| .T. } ;
		FINISH {|| .T. } ;
		EXEC {|| CursorWait(), U_IMPCADPro( oMetGlob, cFile, cDelim, cTipo, cTblImp, cRotImp,nRotpar ), CursorArrow() } ;
		PANEL

	oPanel := oWizard:GetPanel( 5 )

	@ 25, 30 SAY "Importação" OF oPanel SIZE 140, 8 PIXEL
	@ 40, 30 METER oMetGlob 	VAR nMetGlob ;
		TOTAL 100 ;
		SIZE 224,10 OF oPanel PIXEL UPDATE DESIGN ;
		BARCOLOR CLR_BLACK,CLR_WHITE ;
		COLOR CLR_WHITE,CLR_BLACK ;
		NOPERCENTAGE


	ACTIVATE WIZARD oWizard CENTER

	Return NIL
