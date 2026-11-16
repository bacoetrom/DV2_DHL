#INCLUDE "msobject.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³ SCLogger ºAutor  ³Matheus Nogueira    º Data ³  06/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Classe para manipulação de um arquivo de log.               ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºProjeto   ³ SigaCampinas                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Microsiga Protheus                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function __SCLogger;Return

Class SCLogger

	Data nHdl			as Integer	&& Handler do arquivo a ser gravado
	Data cDir			as String	&& Nome do diretorio de log
	Data cFileName		as String	&& Nome do arquivo de log
	Data cFileAndPath	as String	&& Path e Nome do arquivo de log
	Data cFileExtens	as String	&& Extensao do arquivo de log
	Data cEOF			as String	&& EOF
	Data lGrvData		as String	&& Determina se vai ser gravado a data da transacao
	Data lGrvHora		as String	&& Determina se vai ser gravado a hora da transacao
	Data SeqMsErro		as Integer	&& Sequencia do arquivo de MSErroAuto
	Data cAster			as String	&& String de asteriscos

	Method New(cDir,cFile,lAtivo) Constructor	&& Construtor
	Method StartProcess()						&& Inicia um novo processo de log
	Method EndProcess()							&& Finaliza o processo de log
	Method DecodeArray(aArray)          	    && Converte o conteudo do array em uma String
	Method Write(xVar1,xVar2)					&& Grava informacoes no arquivo de log
	Method WriteStr(cBuff,lMostra,lDatHor)		&& Grava informacoes no arquivo de log
	Method AddErroMsAuto(cReferencia) 			&& Grava informacoes de log de uma rotina execAuto
	Method ViewRpt() 							&& Metodo para visualizacao/impressao do relatorio
	Method PrintRpt(Cabec1,Cabec2,Titulo,nLin)  && Metodo para visualizacao/impressao do relatorio
	Method CloseFile() 							&& Metodo para fechar o arquivo de log

EndClass


************************************************************************************************************************************************************************
&& Metodo construtor
************************************************************************************************************************************************************************
Method New(cDir,cFile,lAtivo) Class SCLogger

Local nSeq	:= 0
Local cStartPath	:= GetSrvProfString("StartPath","")

Default cFile	:= ""
Default cDir	:= "" 
Default lAtivo	:= .T.

	cFile	:= AllTrim(cFile)
	cDir	:= AllTrim(cDir)

	&& Verifica se foi passado o nome do arquivo de log
	If Empty(cFile)
		cFile := "LOG_DT_" + DtoS(Date()) + ".TXT"
	Endif
	
	&& Verifica se foi passado o nome do diretorio de log
	If Empty(cDir)
		cDir := cStartPath + "LOGS\"
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
	::lGrvData		:= .T.
	::lGrvHora		:= .T.
	::SeqMsErro		:= 0
	::cAster		:= Replicate("*",100)

	If lAtivo
	
		&& Cria ou abre o arquivo de log
		If File(::cFileAndPath+::cFileExtens)
			::nHdl := FOpen(::cFileAndPath+::cFileExtens,1)
			If ::nHdl >= 0
				FSeek(::nHdl,0,2)
			EndIf
		Else
			::nHdl := FCreate(::cFileAndPath+::cFileExtens)
		EndIf
		
	Endif
		
Return


************************************************************************************************************************************************************************
&& Metodo para iniciar um novo processo de log
************************************************************************************************************************************************************************
Method StartProcess() Class SCLogger

	::WriteStr(::cEOF,,.F.)
	::WriteStr(::cEOF,,.F.)
	::WriteStr(::cAster + ::cEOF,,.F.)
	::WriteStr("INICIANDO PROCESSO" + ::cEOF,,.F.)
	::WriteStr(::cAster + ::cEOF,,.F.)

Return


************************************************************************************************************************************************************************
&& Metodo para finalizar o processo de log
************************************************************************************************************************************************************************
Method EndProcess() Class SCLogger

	::WriteStr(::cEOF,,.F.)
	::WriteStr(::cAster + ::cEOF,,.F.)
	::WriteStr("FINALIZANDO PROCESSO" + ::cEOF,,.F.)
	::WriteStr(::cAster + ::cEOF,,.F.)
	
	::CloseFile()

Return


************************************************************************************************************************************************************************
&& Metodo para gravacao das informacoes do log
************************************************************************************************************************************************************************
Method Write(xVar1,xVar2) Class SCLogger

Local cVar1	:= ""
Local cVar2	:= ""

Default xVar1 := ""
Default xVar2 := ""

	If ValType(xVar1) == "C"
		cVar1 := "C>" + AllTrim(xVar1)
	ElseIf ValType(xVar1) == "N"
		cVar1 := "N>" + AllTrim(Str(xVar1))
	ElseIf ValType(xVar1) == "D"
		cVar1 := "D>" + DtoC(xVar1)
	ElseIf ValType(xVar1) == "L"
		cVar1 := "L>" + Iif(xVar1,".T.",".F.")
	ElseIf ValType(xVar1) == "A"
		cVar1 := ::cEOF + ::DecodeArray(xVar1)
	Endif

	If ValType(xVar2) == "C"
		cVar2 := "C>" + AllTrim(xVar2)
	ElseIf ValType(xVar2) == "N"
		cVar2 := "N>" + AllTrim(Str(xVar2))
	ElseIf ValType(xVar2) == "D"
		cVar2 := "D>" + DtoC(xVar2)
	ElseIf ValType(xVar2) == "L"
		cVar2 := "L>" + Iif(xVar2,".T.",".F.")
	ElseIf ValType(xVar2) == "A"
		cVar2 := ::cEOF + ::DecodeArray(xVar2)
	Endif
		
	If !Empty(cVar1) .and. !Empty(cVar2)
		::WriteStr(cVar1 + "=>" + cVar2 + Iif(ValType(xVar2)=="A","",::cEOF) )
	ElseIf !Empty(cVar1)
		::WriteStr(cVar1 + Iif(ValType(xVar2)=="A","",::cEOF) )
	Endif
	
Return


************************************************************************************************************************************************************************
&& Metodo para gravacao das informacoes do log
************************************************************************************************************************************************************************
Method WriteStr(cBuff,lMostra,lDatHor) Class SCLogger

Local cStr	:= ""

Default cBuff	:= ""
Default lMostra	:= .F.
Default lDatHor	:= .T.
	
	If !Empty(cBuff) .and. ::nHdl >= 0
			
		&& Determina se sera gravada a informacao de data e hora
		If lDatHor
			cStr += Iif(::lGrvData, DtoC(Date()), "")
			cStr += Iif(::lGrvData .and. ::lGrvHora, "-", "")
			cStr += Iif(::lGrvHora, Time(), "")
			cStr += Iif(::lGrvData .or. ::lGrvHora, "-> ", "")
		Endif
		
		If !Empty(cStr)
			FWrite(::nHdl,cStr,Len(cStr))
		Endif
	
		FWrite(::nHdl,cBuff,Len(cBuff))
			
		If lMostra
			Alert(cBuff)
		Endif
		
	Endif

Return


************************************************************************************************************************************************************************
&& Metodo Destrutor
************************************************************************************************************************************************************************
Method DecodeArray(aArray,nNivel) Class SCLogger

Local cRet	:= ""
Local cTmp	:= ""
Local nI	:= 0

Default nNivel := 1

	For nI := 1 to Len(aArray)
			
		cTmp := ""
			
		If ValType(aArray[nI]) == "C"
			cTmp := "C>" + AllTrim(aArray[nI])
		ElseIf ValType(aArray[nI]) == "N"
			cTmp := "N>" + AllTrim(Str(aArray[nI]))
		ElseIf ValType(aArray[nI]) == "D"
			cTmp := "D>" + DtoC(aArray[nI])
		ElseIf ValType(aArray[nI]) == "L"
			cTmp := "L>" + Iif(aArray[nI],".T.",".F.")			
		ElseIf ValType(aArray[nI]) == "A"
			cTmp := Iif(nNivel=1,::cEOF,"") + ::DecodeArray(aClone(aArray[nI]),nNivel+1)
		Endif
		
		cRet += Space(nNivel) + StrZero(nNivel,2) + "-" + StrZero(nI,3) + "->" + cTmp + ::cEOF

	Next nI

Return cRet


****************************************************************************************************************************************************
&& Metodo para adicionar o erro ocorrido pela rotina automatica no vetor aErros
****************************************************************************************************************************************************
Method AddErroMsAuto(cReferencia) Class SCLogger

Local cFileErro	:= ::cFileName+"_MsErroAuto"+ StrZero(++::SeqMsErro,5)+::cFileExtens
Local cError	:= ""

	MostraErro(::cDir,cFileErro)
	cError := MemoRead(::cDir+cFileErro)
	::WriteStr(cReferencia + chr(13) + chr(10) + cError,,.F.)

Return 


************************************************************************************************************************************************************************
&& Metodo para fechar o arquivo de log
************************************************************************************************************************************************************************
Method CloseFile() Class SCLogger

	If ::nHdl >= 0
		FClose(::nHdl)
		::nHdl := -1
	Endif
	
Return


****************************************************************************************************************************************************
&& Metodo para visualizar o conteudo do array aErros em um relatorio padrao SIGA
****************************************************************************************************************************************************
Method ViewRpt() Class SCLogger
	
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
Method PrintRpt(Cabec1,Cabec2,Titulo,nLin) Class SCLogger

Local nTotLin	:= 0
Local cLinha	:= ""

	::CloseFile()

	FT_FUse(::cFileAndPath+::cFileExtens)
	FT_FGotop()
		
	nTotLin := FT_FLASTREC()
	SetRegua(nTotLin)
	
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Total de Linhas: " + AllTrim(Str(nTotLin)), 0, 0, {})
	
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
			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Imprimindo nova pagina", 0, 0, {})
		Endif
			
		cLinha := FT_FREADLN()
		
		@nLin,01 PSAY cLinha
		
		nLin++
				
		FT_FSkip()
		
	EndDo    
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Fora do loop", 0, 0, {})
	
	FT_FUse()
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Fechando arquivo", 0, 0, {})
	
	Set Device To Screen
	
	If aReturn[5]==1
	   dbCommitAll()
	   Set Printer To
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()      
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Fim da rotina", 0, 0, {})
Return 


****************************************************************************************************************************************************
&& Fim da rotina
****************************************************************************************************************************************************
