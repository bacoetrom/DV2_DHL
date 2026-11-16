#INCLUDE "msobject.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"

#define LOGNONE 	0
#define LOGERROR 	1
#define LOGWARN 	2
#define LOGINFO 	3
#define LOGDEBUG 	4

***************************************************************************************************************************************************
&& Criado por Zabotto
***************************************************************************************************************************************************
User Function _ArqLog; Return && 'dummy' function - Uso Interno


***************************************************************************************************************************************************
&& Definicao da classe
***************************************************************************************************************************************************
Class ARQLOG

	Data nHdl				as Integer	&& Handler do arquivo a ser gravado
	Data cDir				as String	&& Nome do diretorio de log
	Data cFileName			as String	&& Nome do arquivo de log
	Data cFileAndPath		as String	&& Path e Nome do arquivo de log
	Data cFileExtens		as String	&& Extensao do arquivo de log
	Data cEOF				as String	&& EOF
	Data nLogLevel			as Integer	&& Define o nivel de LOG do objeto
	Data nLoggingLevel	as Integer	&& Define o nivel de LOG da mensagem enviada
	Data lGrvData			as String	&& Determina se vai ser gravado a data da transacao
	Data lGrvHora			as String	&& Determina se vai ser gravado a hora da transacao
	Data cAster			as String	&& String de asteriscos

	Method New(cDir,cFile,nLogLevel) Constructor	&& Construtor
	Method StartProcess()				 			&& Inicia um novo processo de log
	Method EndProcess()								&& Finaliza o processo de log
	Method WriteStr(cBuff)							&& Grava informacoes no arquivo de log
	Method ViewRpt() 								&& Metodo para visualizacao/impressao do relatorio
	Method PrintRpt(Cabec1,Cabec2,Titulo,nLin)		&& Metodo para visualizacao/impressao do relatorio
	Method CloseFile() 								&& Metodo para fechar o arquivo de log

EndClass 

***************************************************************************************************************************************************
&& Metodo construtor
***************************************************************************************************************************************************
Method New(cDir,cFile,nLogLevel) Class ARQLOG

Local nSeq	:= 0
Local cStartPath	:= GetSrvProfString("StartPath","")

Default cDir		:= "" 
Default cFile		:= ""
Default nLogLevel   := LOGDEBUG

	cFile	:= AllTrim(cFile)
	cDir	:= AllTrim(cDir)

	&& Verifica se foi passado o nome do arquivo de log
	If Empty(cFile)
		cFile := "LOG_DT_" + DtoS(Date()) + ".TXT"
	Endif
	
	&& Verifica se foi passado o nome do diretorio de log
	If Empty(cDir)
		cDir := cStartPath + "IMPORT\"
	Else
		If Substr(cDir,Len(cDir),1) != "\"
			cDir += "\"
		Endif
	Endif
	
	If !lIsDir(cDir)
		MontaDir(cDir)
	Endif

	&& Instacia os atributos
	::nHdl			:= -1
	::cDir			:= cDir
	::cFileName		:= cFile
	::cFileAndPath	:= cDir + cFile
	::cFileExtens	:= ".TXT"
	::cEOF			:= Chr(13) + Chr(10)
	::nLoggingLevel	:= nLogLevel
	::nLogLevel		:= nLogLevel
	::lGrvData		:= .T.
	::lGrvHora		:= .T.
	::cAster		:= Replicate("*",100)

	&& Cria ou abre o arquivo de log
	Conout("ARQLOG - Checking file [" + ::cFileAndPath+::cFileExtens + "], DOS error ", fError() )
	If File(::cFileAndPath+::cFileExtens)
		Conout("ARQLOG - File found [" + ::cFileAndPath+::cFileExtens + "], DOS error ", fError() )
		::nHdl := FOpen(::cFileAndPath+::cFileExtens,66)
		If ::nHdl >= 0
			Conout("ARQLOG - File open [" + ::cFileAndPath+::cFileExtens + "], DOS error ", fError() )
			FSeek(::nHdl,0,2)
		Else
			Conout("ARQLOG - No handler [" + ::cFileAndPath+::cFileExtens + "], DOS error ", fError() )
			If fError() != 0
           		Conout("ARQLOG - Cannot open file [" + ::cFileAndPath+::cFileExtens + "], DOS error ", fError() )
   			Endif
		EndIf
	Else
		::nHdl := FCreate(::cFileAndPath+::cFileExtens)
		FClose(::nHdl)
		
		::nHdl := FOpen(::cFileAndPath+::cFileExtens,66)
		If ::nHdl >= 0
			Conout("ARQLOG - File open [" + ::cFileAndPath+::cFileExtens + "], DOS error ", fError() )
			FSeek(::nHdl,0,2)
		Else
			Conout("ARQLOG - No handler [" + ::cFileAndPath+::cFileExtens + "], DOS error ", fError() )
			If fError() != 0
           		Conout("ARQLOG - Cannot open file [" + ::cFileAndPath+::cFileExtens + "], DOS error ", fError() )
   			Endif
		EndIf
				
		Conout("ARQLOG - Create file [" + ::cFileAndPath+::cFileExtens + "], DOS error ", fError() )
		If fError() != 0
        	Conout("ARQLOG - Cannot create file [" + ::cFileAndPath+::cFileExtens + "], DOS error ", fError() )
		EndIf		
	EndIf
		
Return


***************************************************************************************************************************************************
&& Metodo para iniciar um novo processo de log
***************************************************************************************************************************************************
Method StartProcess() Class ARQLOG

	::WriteStr(::cAster)
	::WriteStr("INICIANDO PROCESSO")
	::WriteStr(::cAster)

Return


***************************************************************************************************************************************************
&& Metodo para finalizar o processo de log
***************************************************************************************************************************************************
Method EndProcess() Class ARQLOG


	::WriteStr(::cAster)
	::WriteStr("FINALIZANDO PROCESSO")
	::WriteStr(::cAster)
	::WriteStr(" " + ::cEOF)
	::WriteStr("Arquivo log Criado: " + ::cFileAndPath+::cFileExtens)
	::CloseFile()

Return

***************************************************************************************************************************************************
&& Metodo para gravacao das informacoes do log
***************************************************************************************************************************************************
Method WriteStr(cBuff) Class ARQLOG

Local cStr	:= ""

Default cBuff	:= ""
	
	If !Empty(cBuff) .and. ::nHdl >= 0

		&& Informa o nivel do log
		If ::nLoggingLevel == 0 
			cStr += "[NONE]  "		
		ElseIf ::nLoggingLevel == 1 
			cStr += "[ERROR] "
		ElseIf ::nLoggingLevel == 2 
			cStr += "[WARN]  "
		ElseIf ::nLoggingLevel == 3 
			cStr += "[INFO]  "
		ElseIf ::nLoggingLevel == 4 
			cStr += "[DEBUG] " 
		Endif		
		/*
		&& Adiciona informacoes do usuario
		If Type("cUserName") <> "U"
			cStr += "- User: " + cUserName + " - "		
		Endif
		*/
		&& Determina se sera gravada a informacao de data e hora
		If ::lGrvData .or. ::lGrvHora
			cStr += Iif(::lGrvData, DtoC(Date()), "")
			cStr += Iif(::lGrvData .and. ::lGrvHora, "-", "")
			cStr += Iif(::lGrvHora, Time(), "")
			cStr += Iif(::lGrvData .or. ::lGrvHora, "-> ", "")
		Endif
				
		FWrite(::nHdl,cStr + cBuff + ::cEOF,Len(cStr + cBuff + ::cEOF))
				
	Endif

Return

***************************************************************************************************************************************************
&& Metodo para fechar o arquivo de log
***************************************************************************************************************************************************
Method CloseFile() Class ARQLOG

	If ::nHdl >= 0
		FClose(::nHdl)
		::nHdl := -1
	Endif
	
Return


****************************************************************************************************************************************************
&& Metodo para visualizar o conteudo do array aErros em um relatorio padrao SIGA
****************************************************************************************************************************************************
Method ViewRpt() Class ARQLOG
	
	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := "Relatorio de Log"
	Local cPict         := ""
	Local titulo       	:= "Relatorio de Log"
	Local nLin         	:= 80
	Local Cabec1       	:= "Ref.    Erro"
	Local Cabec2      	:= ""
	Local imprime      	:= .T.
	Local aOrd 			:= {}
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 132
	Private tamanho     := "M"
	Private nomeprog    := "GENERIC" 
	Private nTipo       := 15
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "GENERIC" 	
	Private cString	 	:= ""
	
	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	RptStatus({|| ::PrintRpt(Cabec1,Cabec2,Titulo,nLin) },Titulo)	

Return 


****************************************************************************************************************************************************
&& Metodo para impressao do relatorio padrao SIGA
****************************************************************************************************************************************************
Method PrintRpt(Cabec1,Cabec2,Titulo,nLin) Class ARQLOG

Local nTotLin	:= 0
Local cLinha	:= ""

	::CloseFile()

	FT_FUse(::cFileAndPath+::cFileExtens)
	FT_FGotop()
		
	nTotLin := FT_FLASTREC()
	SetRegua(nTotLin)
	Conout( "Total de Linhas: " + AllTrim(Str(nTotLin)) )
	
	FT_FGotop()
	While ( !FT_FEof() ) .and. nTotLin > 0
	
		IncRegua()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 55 
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			Conout( "Imprimindo nova pagina: " )
		Endif
			
		cLinha := FT_FREADLN()
		
		@nLin,01 PSAY cLinha
		
		nLin++
				
		FT_FSkip()
		
	EndDo    
	
	Conout( "Fora do loop" )
	
	FT_FUse()
	
	Conout( "Fechando arquivo" )
	
	Set Device To Screen
	
	If aReturn[5]==1
	   dbCommitAll()
	   Set Printer To
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()      
	
	Conout( "Fim da rotina" )
	
Return 


****************************************************************************************************************************************************
&& Fim da rotina
****************************************************************************************************************************************************
