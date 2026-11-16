#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#include "TOTVS.CH"
#IFNDEF ENTER
	#Define ENTER Chr(13) + Chr(10)
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImport    บAutor  ณJoใo Zabotto        บ Data ณ  07/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa de importacao de tabelas atrav้s da tabela e      บฑฑ
ฑฑบ          ณ Rotina automatica Informada                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPCSV()

	U_MontaWZ()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPCADPro บAutor  ณJoใo Zabotto        บ Data ณ  07/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImportacao do arquivo selecionado                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPCADPro( oMetGlob,cFile, cDelim,cTipo, ctblImp, cRotImp,cRotpar )
	Local aArea		:= GetArea()
	Local oArq			:= NIL
	Local lFirst	:= .T.
	Local cLinha 	:= ""
	Local aHeader	:= {}
	Local nHdl    	:= 	0
	Local cEnvServ	:= GetEnvServer()
	Local cIniFile	:= GetADV97()
	Local cEnd		:= GetPvProfString(cEnvServ,"StartPath","",cIniFile)
	Local cDtHr 	:= DtoS(dDataBase)+"-"+Substr(time(),1,2)+"-"+Substr(time(),4,2)+"-"+Substr(time(),7,2)
	Local cPath		:= "\IMPORT\"
	Local cTipoLog	:= "Import_"
	Local cNomeLog	:=	cTipoLog+cDtHr+"_Log"
	Local cArq		:=	cEnd+cNomeLog
	Local cLin		:= ""
	Local cCdAlias	:= ""
	Local nQtReg	:= 0
	Local nQtNOk	:= 0
	Local nQtOk		:= 0
	Local aLog		:= {}
	Local lGrava	:= (cTipo == "2")
	Local cRotina	:= ""
	Local nCont		:= 0
	Local nParamRot := ""
	Local lRet:= .F.
	Local cLin2:= ""

	Private oLog		:= ARQLOG():New(,cNomeLog,5)
	Private nNumSim		:= 1
//MAKEDIR(cEnd+cPath)

	&&Validacao do arquivo para importacao
	If !File(cFile) .OR. Empty(cFile)
		ApMsgStop("Problemas com arquivo informado!")
		RestArea(aArea)
		Return
	EndIf

	&& Inicia processo de Log
	oLog:lGrvData	:= .F.
	oLog:lGrvHora	:= .F.
	oLog:StartProcess()


	&&Identifica Alias, Rotina e param๊tro de importacao
	cCdAlias	:= Alltrim(ctblImp)
	cRotina	:= Alltrim(cRotImp)
	nParamRot := nRotpar

	&&Inicia Log
	AAdd(aLog, Replicate( '=', 80 ) )
	AAdd(aLog, 'INICIANDO O LOG - I M P O R T A C A O   D E   D A D O S' )
	AAdd(aLog, Replicate( '-', 80 ) )
	AAdd(aLog, 'DATABASE...........: ' + DtoC( dDataBase ) )
	AAdd(aLog, 'DATA...............: ' + DtoC( Date() ) )
	AAdd(aLog, 'HORA...............: ' + Time() )
	AAdd(aLog, 'ENVIRONMENT........: ' + GetEnvServer() )
	AAdd(aLog, 'PATCH..............: ' + GetSrvProfString( 'StartPath', '' ) )
	AAdd(aLog, 'ROOT...............: ' + GetSrvProfString( 'RootPath', '' ) )
	AAdd(aLog, 'VERSรO.............: ' + GetVersao() )
	AAdd(aLog, 'MำDULO.............: ' + 'SIGA' + cModulo )
	AAdd(aLog, 'EMPRESA / FILIAL...: ' + SM0->M0_CODIGO + '/' + SM0->M0_CODFIL )
	AAdd(aLog, 'NOME EMPRESA.......: ' + Capital( Trim( SM0->M0_NOME ) ) )
	AAdd(aLog, 'NOME FILIAL........: ' + Capital( Trim( SM0->M0_FILIAL ) ) )
	AAdd(aLog, 'USUมRIO............: ' + SubStr( cUsuario, 7, 15 ) )
	AAdd(aLog, 'TABELA IMPORT......: ' + cCdAlias )
	AAdd(aLog, 'ARQUIVO IMPORT.....: ' + cFile )
	AAdd(aLog, 'DELIMITADOR........: ' + cDelim )
	AAdd(aLog, 'MODO PROCESSAMENTO.: ' + IIf(lGrava,"Atualizacao","Simulacao") )
	AAdd(aLog, Replicate( ':', 80 ) )
	AAdd(aLog, '' )

	AAdd(aLog, "Import = INICIO - Data "+DtoC(dDataBase)+ " as "+Time() )

	&&Leitura do arquivo
	oArq := ArqTxt():New(cFile,,1)
	If oArq:AbrirTxt()

		nTot := oArq:nTamFile
		nAtu := 0

		oMetGlob:SetTotal(nTot)
		CursorWait()

		While !FT_FEOF()
			nAtu++
			oMetGlob:Set(nAtu)

			cLinha := oArq:LeLinha()

			&&Tratamento de colunas
			aCols := {}
			aCols := TrataCols(Alltrim(cLinha),cDelim)
			If lFirst
				aHeader := aClone(aCols)
				lFirst := .F.

				&&Valida nomes das colunas
				cCpos := ImpVldCols(cCdAlias,aHeader)
				If !Empty(cCpos)
					ApMsgStop("Problemas na estrutura do arquivo, faltam as seguintes colunas "+cCpos)
					Return
				EndIf

			Else
				nQtReg++

				&&Validacao de campos obrigatorios
				cMsg := ImpObrigat(cCdAlias,aCols,aHeader)
				If !Empty(cMsg)
					AtuLog("NO MOT: CAMPOS OBRIGATORIOS - REGISTRO IGNORADO - "+cMsg,@aLog,nAtu)
					nQtNOk++
					FT_FSKIP()
					Loop
				EndIf


				&&Chamada de rotina automatica de inclusao
				If lGrava
					aRet := {}
					aRet := ImpGrava(cCdAlias,cRotina,aCols,aHeader,nParamRot)
					If aRet[1]
						nQtOk++
						AtuLog("OK MOT:REGISTRO INCLUIDO"+aRet[2],@aLog,nAtu)

					Else
						AtuLog("NO MOT: PROBLEMAS NA GRAVACAO ROTINA AUTOMATICA - "+cRotina+" - "+aRet[2],@aLog,nAtu)
						nQtNOk++

					EndIF
				Else
					nQtOk++
					AtuLog("OK MOT:REGISTRO INCLUIDO",@aLog,nAtu)
				EndIf
			EndIf
			FT_FSKIP()
		EndDo
	Else

	EndIf

	AAdd(aLog, "Import = Total de Registros = "+ Alltrim(Str(nQtReg)))
	AAdd(aLog, "Import = Registros Nao importados = "+ Alltrim(Str(nQtNOk)))
	AAdd(aLog, "Import = Registros importados = "+ Alltrim(Str(nQtOk)))

	AAdd(aLog, "Import = FIM Data "+DtoC(dDataBase)+ " as "+Time() )

	&&Cria arquivo de log
	lRet  := 	oArq:CriaLog(cArq)

//nHdl  := 	fCreate(cArq)

	If !lRet
		MsgAlert("O arquivo  "+cArq+" nao pode ser criado!","Atencao!")
		fClose(oArq:nFOpened)
		fErase(cArq)
		RestArea(aArea)
		Return()
	EndIf

	For nCont:=1 to Len(aLog)

		oLog:WriteStr(aLog[nCont])

		If !lRet
			fClose(nHdl)
			fErase(cArq)
			cLin:=""
			RestArea(aArea)
			Return()
		EndIf

		cLin:=""
	Next

	oArq:FechaTxt()
	oLog:EndProcess()

	oLog:ViewRpt()

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuLog    บAutor  ณJoใo Zabotto        บ Data ณ  07/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza Array de Log                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuLog(cMsg,aLog,nAtu)

	AAdd(aLog, " Import = Linha "+StrZero(nAtu,12)+" = "+;
		" LOG = "+cMsg )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLeLinha   บAutor  ณJoใo Zabotto        บ Data ณ  07/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTratamento de leitura de linha TXT, principalmente para     บฑฑ
ฑฑบ          ณcasos de ultrapassar 1Kb por linha                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LeLinha()
	Local cLinhaTmp := ""
	Local cLinhaM100 := ""

	cLinhaTmp := FT_FReadLN()

	If !Empty(cLinhaTmp)
		cIdent:= Substr(cLinhaTmp,1,1)
		If Len(cLinhaTmp) < 1023
			cLinhaM100 := cLinhaTmp
		Else
			cLinAnt := cLinhaTmp
			cLinhaM100 += cLinAnt
			Ft_FSkip()
			cLinProx:= Ft_FReadLN()
			If Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent
				While Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent .and. !Ft_fEof()
					cLinhaM100 += cLinProx
					Ft_FSkip()
					cLinProx := Ft_fReadLn()
					If Len(cLinProx) < 1023 .and. Substr(cLinProx,1,1) <> cIdent
						cLinhaM100 += cLinProx
					Endif
				Enddo
			Else
				cLinhaM100 += cLinProx
			Endif
		Endif
	Endif

Return(cLinhaM100)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTrataCols บAutor  ณJoใo Zabotto        บ Data ณ  07/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna array com as colunas da linha informada             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TrataCols(cLinha,cSep)
	Local aRet 		:= {}
	Local nPosSep	:= 0


	nPosSep	:= At(cSep,cLinha)
	While nPosSep <> 0
		AAdd(aRet, SubStr(cLinha,1,nPosSep-1)  )
		cLinha := SubStr(cLinha,nPosSep+1)
		nPosSep	:= At(cSep,cLinha)
	EndDo
	AAdd(aRet, Alltrim(cLinha) )
Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetCol    บAutor  ณJoใo Zabotto        บ Data ณ  07/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna conteudo de coluna especifica                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetCol(cCpo,aCols,aHeader)
	Local cRet 	:= ""
	Local nPos	:= 0
	Local aSX3Area	:= SX3->(GetArea())

	nPos := AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim(cCpo)) })

	If !Empty(nPos)
		DbSelectArea("SX3")
		DbSetOrder(2)
		If MsSeek(cCpo)
			If SX3->X3_TIPO == "D"
				cRet := StoD(AllTrim(aCols[nPos]))
			ElseIf SX3->X3_TIPO == "N"
				cRet := Val(AllTrim(aCols[nPos]))
			Else
				cRet := PadR(Upper(AllTrim(aCols[nPos])),TamSX3(cCpo)[1])
			EndIf
		Else
			cRet := Upper(AllTrim(aCols[nPos]))
		EndIf
	EndIf

Return cRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpVldColsบAutor  ณJoใo Zabotto        บ Data ณ  07/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAnalise de colunas obrigatorias para cada alias             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpVldCols(cCdAlias,aHeader)
	Local cRet 		:= ""
	Local cFilSA1 	:= ""
	Local lRet := .F.
	Local aArea := GetArea()
	Local nI	:= 0
	
	dbSelectArea(cCdAlias)
	dbGotop()

	aArea := GetArea()

	&& Montagem do Cabecalho dos campos
	For nI := 1 To Fcount()
		_cDado := FieldName(nI)    && Pega o nome do Campo
		lRet:= X3OBRIGAT(_cDado) && Verifico se o campo ้ obrigat๓rio
		If lRet
			If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim(_cDado)) })	== 0
				cRet += IIf(Empty(cRet),"","/") + _cDado
			EndIf
		EndIf
		RestArea(aArea)
	Next nI

	RestArea(aArea)

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpObrigatบAutor  ณJoใo Zabotto        บ Data ณ  07/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida preenchimento/conteudo de campos obrigatorios        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpObrigat(cCdAlias,aCols,aHeader)
	Local cRet := ""
	Local lRet := .F.
	Local aEstrX3 := {}
	Local aArea := {}
	Local nI := 0
	
	dbSelectArea(cCdAlias)
	dbGotop()

	aArea:= GetArea()

	&& Montagem do Cabecalho dos campos
	For nI := 1 To Fcount()
		_cDado := FieldName(nI)    && Pega o nome do Campo
		lRet:= X3OBRIGAT(_cDado)
		If lRet
			If Empty(RetCol(_cDado,aCols,aHeader))
				cRet += " / Coluna " +  _cDado  + " esta vazia! "
			EndIf
		EndIf
		RestArea(aArea)
	Next nI


	RestArea(aArea)

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpGrava  บAutor  ณJoใo Zabotto        บ Data ณ  07/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChamada da rotina automatica de gravacao                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpGrava(cCdAlias,cRotina,aCols,aHeader,nParamRot)
	Local nX			:= 0
	Local cRotAuto		:= ""
	Local lOk			:= .F.
	Local cMsg			:= ""
	Local lGeraNumSeq	:= .T.
	Local cArqErro		:= "ERRO_AUTO.TXT"
	Local lTemFilial	:= .F.
	Local cCpoFilial 	:= IIf( SubStr(cCdAlias,1,1) == "S", SubStr(cCdAlias,2,2), cCdAlias) + "_FILIAL"
	Local cFilAlias		:= xFilial(cCdAlias)
	Local aCabec := {}
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private aReg		:= {}

	&&Ordena o Array aHeader e retorna ordenado conforme estrutura do SX3
	&&aCabec := RetOrd(aHeader)

	&&Monta array com os campos do registro                          ณ

	For nX:=1 to Len(aHeader)

		AAdd(aReg, {	Upper(Alltrim(aHeader[nX])),RetCol(Alltrim(aHeader[nX]),aCols,aHeader), Nil} )

		&&Verifica se informou filial no arquivo              ณ
		If Upper(Alltrim(aHeader[nX])) == cCpoFilial
			lTemFilial := .T.
			CFILANT := aReg[nX,2]
		EndIf
	Next

	If !lTemFilial
		AAdd(aReg, {cCpoFilial					    ,;
			xFilial(cCdAlias)						,;
			Nil} )
	EndIf

	&&Chamada da rotina automatica verificando a quantidade de param๊tro informado no wizard.

	DbSelectArea(cCdAlias)

	If nParamRot = 1
		cRotAuto:= "MSExecAuto({|a|" + cRotina + "(a)},aReg,3)"  //-- Opcao 3 - Inclusao registro
	ElseIF nParamRot = 2
		cRotAuto:= "MSExecAuto({|a,b|" + cRotina + "(a,b)},aReg,3)"  //-- Opcao 3 - Inclusao registro
	ElseIF nParamRot = 3
		cRotAuto:= "MSExecAuto({|a,b,c|" + cRotina + "(a,b,c)},NIL,aReg,3)"  //-- Opcao 3 - Inclusao registro
	ElseIF nParamRot = 4
		cRotAuto:= "MSExecAuto({|a,b,c,d|" + cRotina + "(a,b,c,d)},NIL,NIL,aReg,3)"  //-- Opcao 3 - Inclusao registro
	ElseIF nParamRot = 5
		cRotAuto:= "MSExecAuto({|a,b,c,d,e|" + cRotina + "(a,b,c,d,e)},NIL,NIL,NIL,aReg,3)"  //-- Opcao 3 - Inclusao registro
	ElseIf Alltrim(Upper(cRotina)) == 'CTBA102'
	
	EndIf

	&&Executa a rotina automแtica
	&cRotAuto

	If lMsErroAuto
		nNumSim++
		cErroTemp:= Mostraerro("C:\temp\LOG\","Erro_" + cFilAnt + "_" + STRZERO(nNumSim,6) + ".log")
		MostraErro( GetSrvProfString("Startpath","") , cArqErro )
		&&MostraErro()
		cMsg := MemoRead(  GetSrvProfString("Startpath","") + '\' + cArqErro )
	Else
		lOk := .T.
	EndIf

Return {lOk, cMsg }

User Function MyMata270 //U_MYMATA270()
	Local aVetor := {}
	PRIVATE lMsErroAuto := .F.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
// Abertura do ambiente 
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aVetor := {;
		{"B7_FILIAL" , xFilial("SB7"),Nil},;
		{"B7_COD","010007",Nil},;
		{"B7_DOC","INVTST",Nil},;
		{"B7_QUANT",10,Nil},;
		{"B7_LOCAL","01",Nil},;
		{"B7_DATA",Date(),Nil} }
	MSExecAuto({|x,y| mata270(x,y)},aVetor,.F.,3)
	If lMsErroAuto
		MostraErro()
		ConOut(OemToAnsi("Erro!"))
	Else
		ConOut(OemToAnsi("Cadastrado com sucesso!"))
	Endif
Return Nil
