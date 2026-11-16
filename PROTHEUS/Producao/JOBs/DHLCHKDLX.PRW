#DEFINE CRLF CHR(13)+CHR(10)
#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"

/*
Rotina desenvolvida para verificar se tem arquivo travado na pasta do dlx,
caso tenha arquivos travados derrubar o serviço do dlx.
Emerson Holanda 27/05/2020
*/
User Function DHLCHKDLX()

	Local oConnection 	:= Connection():newConnection(CCONN, CSERVERADDR, NPORT)
	Local EmpExec       :="10"
	Local FilExec       :="149AG2014901" //SCJ
	Local ctpArq        := ""
	Private cDirectory 	:= ""
	Private cFile 		:= ""
	Private cCodApli	:= "99"
	Private nRecnoSZ2   := 0

	RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv(EmpExec,FilExec,,,,, {} )
	

	cDirectory 			:= oConnection:getDirectory(APP_DLX)
	Conout("Execução da rotina DHLCHKDLX -  procurando arquivos DLX parados")
	
	ctpArq := "D"
	renArqProcessing(ctpArq)

	cDirectory 			:= oConnection:getDirectory(APP_MASTERSAF_NFE)
	Conout("Execução da rotina DHLCHKDLX -  procurando arquivos MasterSaf parados")
	
	ctpArq := "M"
	renArqProcessing(ctpArq)

Return 


/**
* obtém os arquivos .PROCESSING e renomeia para o nome original. (SOmente os arquivos que não estão locados)
**/
static function renArqProcessing(cTipo)

	Local aInfArquivos	:= Directory(allTrim(cDirectory) +"*.PROCESSING", , , , 2) 
	Local nI			:= 0
//	Local aArquivos		:= {}
	Local cArquivo		:= ""
	Local cNewNomArq	:= ""
	Local nStatusRenom	:= -10
	Local lStopDLX 		:= .F.
	Local lStopMASTERSAF:= .F.
	Local cId 			:= ""
	Local lRecorrencia 	:= .F.
	Default cTipo 		:= "D"
	
	for nI := 1 to len(aInfArquivos)
		lRecorrencia  := .F.
		nRecnoSZ2 := 0
		Conout("Achou arquivos:"+aInfArquivos[nI][1]+" hora:"+aInfArquivos[nI][4])
		If aInfArquivos[nI][3] <> ddatabase //aInfArquivos[1][3]
			If !lStopDLX .and. ctipo == "D"
				cFile := aInfArquivos[nI][1]
				lRecorrencia := LocArq(cFile,"98")
				If lRecorrencia
					MailSche("D")
					Conout("1-Envia email alertando possivel dead Lock")

					//Colocar aqui a opção de parar o serviço
					WaitRunSrv("net stop p12_job_dlx",.T.,"E:\")
					Conout("10-parando servico dlx")

					WaitRunSrv("net stop p12_job_importacao_mastersaf",.T.,"E:\")
					Conout("20-parando servico mastersaf")
						
					Sleep( 30000 ) //Aguarda 30 segundo para renomear o arquivo							


					cArquivo := allTrim(aInfArquivos[nI][1])
					If !isLocked(cArquivo)	
						//Renomei o arquivo .processing que causou o dead lock, para que seja processado novamente.
						cNewNomArq 		:= strTran(cArquivo, ".PROCESSING", "")
						nStatusRenom 	:= FRename( cDirectory + cArquivo, cDirectory + cNewNomArq, nil  )		
					Else
						Sleep( 20000 )//Aguarda 20 segundos para tentar renomear o arquivo novamente.
						If !isLocked(cArquivo)	
							//Renomei o arquivo .processing que causou o dead lock, para que seja processado novamente.
							cNewNomArq 		:= strTran(cArquivo, ".PROCESSING", "")
							nStatusRenom 	:= FRename( cDirectory + cArquivo, cDirectory + cNewNomArq, nil  )	
						EndIf		
					
					EndIf
					//Altera o registro da SZ2, para informar que o arquivo foi renomeado e parou os serviços
					If nRecnoSZ2 > 0 
						SZ2->(DbGoto(nRecnoSZ2))
						RecLock("SZ2",.F.)
						SZ2->Z2_TIPO := "9"
						SZ2->Z2_MSG := "JOB MASTERSAF E JOB DLX REINICIADOS AUTOMATICAMENTE"
						SZ2->(MsUnlock())
					EndIf

					Sleep( 50000 ) //Aguarda 50 segundos para iniciar os JOBS
					//inicia os JOBs
					WaitRunSrv("net start p12_job_dlx",.T.,"E:\")
					Conout("11-Iniciando servico dlx")
						
					WaitRunSrv("net start p12_job_importacao_mastersaf",.T.,"E:\")
					Conout("21-Iniciando servico mastersaf")
				
				Else
					cId := getNextId()
					dbSelectArea("SZ2")	
					RecLock("SZ2", .T.)
							Z2_FILIAL :=  xFilial("SZ2")
							Z2_ID := cId
							Z2_TIPO := "3"
							Z2_CODAPLI :=  "99"
							Z2_DESAPLI :=  "Possivel DeadLock - DLX"
							Z2_DATA :=  Date()
							Z2_HORA := Time()
							Z2_CODUSER :=  "000000"
							Z2_LOGUSER :=  "Administrador"
							Z2_PROC :=  "98"
							Z2_ARQUIVO :=  cFile	
					SZ2->(MsUnlock())
				EndIf
			EndIf
			If !lStopMASTERSAF  .and. ctipo == "M"
				cFile := aInfArquivos[nI][1]
				lRecorrencia := LocArq(cFile,"99")
				If lRecorrencia
					MailSche("M")
					Conout("2-Envia email alertando possivel dead Lock")
					// parar o serviço
					Conout("20-parando servico mastersaf")
					WaitRunSrv("net stop p12_job_importacao_mastersaf",.T.,"E:\")
														
					Sleep( 30000 ) //Aguarda 30 segundo para renomear o arquivo

					cArquivo := allTrim(aInfArquivos[nI][1])
					If !isLocked(cArquivo)	
						//Renomei o arquivo .processing que causou o dead lock, para que seja processado novamente.
						cNewNomArq 		:= strTran(cArquivo, ".PROCESSING", "")
						nStatusRenom 	:= FRename( cDirectory + cArquivo, cDirectory + cNewNomArq, nil  )		
					Else
						Sleep( 30000 )//Aguarda 30 segundos para tentar renomear o arquivo novamente.
						If !isLocked(cArquivo)	
							//Renomei o arquivo .processing que causou o dead lock, para que seja processado novamente.
							cNewNomArq 		:= strTran(cArquivo, ".PROCESSING", "")
							nStatusRenom 	:= FRename( cDirectory + cArquivo, cDirectory + cNewNomArq, nil  )	
						EndIf		
					EndIf
					
					//Altera o registro da SZ2, para informar que o arquivo foi renomeado e parou os serviços
					If nRecnoSZ2 > 0 
						SZ2->(DbGoto(nRecnoSZ2))
						RecLock("SZ2",.F.)
						SZ2->Z2_TIPO := "9"
						SZ2->Z2_MSG := "JOB MASTERSAF REINICIADO AUTOMATICAMENTE"
						SZ2->(MsUnlock())
					EndIf					

					Sleep( 50000 )//Aguarda 50 segundos para iniciar o JOB.
					//Inicia o serviço do JOb
					Conout("21-Iniciando servico mastersaf")
					WaitRunSrv("net start p12_job_importacao_mastersaf",.T.,"E:\")

				
				Else
					cId := getNextId()
					dbSelectArea("SZ2")	
					RecLock("SZ2", .T.)
						Z2_FILIAL :=  xFilial("SZ2")
						Z2_ID := cId
						Z2_TIPO := "3"
						Z2_CODAPLI :=  "99"
						Z2_DESAPLI :=  "Possivel DeadLock - MASTERSAF"
						Z2_DATA :=  Date()
						Z2_HORA := Time()
						Z2_CODUSER :=  "000000"
						Z2_LOGUSER :=  "Administrador"
						Z2_PROC :=  "99"
						Z2_ARQUIVO :=  cFile	
					SZ2->(MsUnlock())
				EndIf	
			EndIf
		Else
			If !lStopDLX .and. ctipo == "D"
				If ElapTime( aInfArquivos[nI][4], TIME() ) > "00:010:00" //Se o arquivo for da mesma data, porem esta a mais de 10 minutos na pasta. Derrubar o job DLX e renomear o arquivo.
				Conout("Verifica o tempo que o arquivo DLX esta parado, hora atual:"+TIME())

					cFile := aInfArquivos[nI][1]
					lRecorrencia := LocArq(cFile,"98")
					If lRecorrencia
						MailSche("D")
						Conout("3-Envia email alertando possivel dead Lock")


						//Colocar aqui a opção de parar o serviço
						Conout("10-parando servico dlx")
						WaitRunSrv("net stop p12_job_dlx",.T.,"E:\")
						
						Conout("20-parando servico mastersaf")
						WaitRunSrv("net stop p12_job_importacao_mastersaf",.T.,"E:\")
						
						Sleep( 30000 ) //Aguarda 30 segundo para renomear o arquivo							

						cArquivo := allTrim(aInfArquivos[nI][1])
						If !isLocked(cArquivo)	
							//Renomei o arquivo .processing que causou o dead lock, para que seja processado novamente.
							cNewNomArq 		:= strTran(cArquivo, ".PROCESSING", "")
							nStatusRenom 	:= FRename( cDirectory + cArquivo, cDirectory + cNewNomArq, nil  )		
						Else
							Sleep( 30000 )//Aguarda 30 segundos para tentar renomear o arquivo novamente.
							If !isLocked(cArquivo)	
								//Renomei o arquivo .processing que causou o dead lock, para que seja processado novamente.
								cNewNomArq 		:= strTran(cArquivo, ".PROCESSING", "")
								nStatusRenom 	:= FRename( cDirectory + cArquivo, cDirectory + cNewNomArq, nil  )	
							EndIf		
						EndIf
						//Altera o registro da SZ2, para informar que o arquivo foi renomeado e parou os serviços
						If nRecnoSZ2 > 0 
							SZ2->(DbGoto(nRecnoSZ2))
							RecLock("SZ2",.F.)
							SZ2->Z2_TIPO := "9"
							SZ2->Z2_MSG := "JOB MASTERSAF E JOB DLX REINICIADOS AUTOMATICAMENTE"
							SZ2->(MsUnlock())
						EndIf						
						
						Sleep( 50000 ) //Aguarda 30 segundos para iniciar os JOBS
						//inicia os JOBs
						WaitRunSrv("net start p12_job_dlx",.T.,"E:\")
						Conout("11-Iniciando servico dlx")
						
						WaitRunSrv("net start p12_job_importacao_mastersaf",.T.,"E:\")
						Conout("21-Iniciando servico mastersaf")
						
					Else
						//Grava Log
						cId := getNextId()
						dbSelectArea("SZ2")	
						RecLock("SZ2", .T.)
							Z2_FILIAL :=  xFilial("SZ2")
							Z2_ID := cId
							Z2_TIPO := "3"
							Z2_CODAPLI :=  "99"
							Z2_DESAPLI :=  "Possivel DeadLock - DLX"
							Z2_DATA :=  Date()
							Z2_HORA := Time()
							Z2_CODUSER :=  "000000"
							Z2_LOGUSER :=  "Administrador"
							Z2_PROC :=  "98"
							Z2_ARQUIVO :=  cFile	
						SZ2->(MsUnlock())
					 EndIf	
					EndIf
			EndIf
			cArquivo := allTrim(aInfArquivos[nI][1])
			If !lStopMASTERSAF  .and. ctipo == "M"
					If ElapTime( aInfArquivos[nI][4], TIME() ) > "00:015:00" //Se o arquivo for da mesma data, porem esta a mais de 10 minutos na pasta. Derrubar o job DLX e renomear o arquivo.
					Conout("Verifica o tempo que o arquivo DLX esta parado, hora atual:"+TIME())
						cFile := aInfArquivos[nI][1]
						lRecorrencia := LocArq(cFile,"99")
						If lRecorrencia
							MailSche("M")
							Conout("4-Envia email alertando possivel dead Lock")
							// parar o serviço
							Conout("20-parando servico mastersaf")
							WaitRunSrv("net stop p12_job_importacao_mastersaf",.T.,"E:\")
														
							Sleep( 30000 ) //Aguarda 30 segundo para renomear o arquivo
		
							cArquivo := allTrim(aInfArquivos[nI][1])
							If !isLocked(cArquivo)	
								//Renomei o arquivo .processing que causou o dead lock, para que seja processado novamente.
								cNewNomArq 		:= strTran(cArquivo, ".PROCESSING", "")
								nStatusRenom 	:= FRename( cDirectory + cArquivo, cDirectory + cNewNomArq, nil  )		
							Else
								Sleep( 30000 )//Aguarda 30 segundos para tentar renomear o arquivo novamente.
								If !isLocked(cArquivo)	
									//Renomei o arquivo .processing que causou o dead lock, para que seja processado novamente.
									cNewNomArq 		:= strTran(cArquivo, ".PROCESSING", "")
									nStatusRenom 	:= FRename( cDirectory + cArquivo, cDirectory + cNewNomArq, nil  )	
								EndIf		
							EndIf

							//Altera o registro da SZ2, para informar que o arquivo foi renomeado e parou os serviços
							If nRecnoSZ2 > 0 
								SZ2->(DbGoto(nRecnoSZ2))
								RecLock("SZ2",.F.)
								SZ2->Z2_TIPO := "9"
								SZ2->Z2_MSG := "JOB MASTERSAF REINICIADO AUTOMATICAMENTE"
								SZ2->(MsUnlock())
							EndIf						

							Sleep( 50000 )//Aguarda 30 segundos para iniciar o JOB.
							//Inicia o serviço do JOb
							WaitRunSrv("net start p12_job_importacao_mastersaf",.T.,"E:\")
							Conout("21-Iniciando servico mastersaf")

						Else
								cId := getNextId()
								dbSelectArea("SZ2")	
								RecLock("SZ2", .T.)
									Z2_FILIAL :=  xFilial("SZ2")
									Z2_ID := cId
									Z2_TIPO := "3"
									Z2_CODAPLI :=  "99"
									Z2_DESAPLI :=  "Possivel DeadLock - MASTERSAF"
									Z2_DATA :=  Date()
									Z2_HORA := Time()
									Z2_CODUSER :=  "000000"
									Z2_LOGUSER :=  "Administrador"
									Z2_PROC :=  "99"
									Z2_ARQUIVO :=  cFile	
								SZ2->(MsUnlock())
						EndIf	
				    EndIf
			EndIf
			
		EndIf
	next nI

Return

/**
* verifica se o arquivo esta lockado
**/
static function isLocked(cArquivo)

	Local lIsLocked := .T.

	//SE CONSEGUIR LOCKAR, É PQ NÃO ESTA LOCKADO EM OUTRO PROCESSO
	If lockByname(upper(cArquivo), .F., .F.)
		lIsLocked := .F.
		unLockByName(upper(cArquivo), .F., .F.)		
	EndIf

Return lIsLocked

//Envia e-mail de possivel dead lock
Static Function MailSche(cTipo)

//local nEmails

Local _cServer   := SuperGetMv("MV_RELSERV")
//Local _cMail     := SuperGetMv("MV_RELACNT")
Local _cUser     := SuperGetMv("MV_RELACNT")
Local _cSenha    := SuperGetMv("MV_RELPSW")
//Local _lAuth     := SuperGetMv("MV_RELAUTH")
Local _cFrom     := SuperGetMv("MV_RELFROM")
Local _cTo        := SuperGetMv("ZZ_EMASCH",,"emerson.holanda@fitgestao.com.br")
Local _cAssunto   := "" //"Possivel dead lock identificado" //+ " - " + Time()
Local _cBody      := "" //"Foi identificado um possivel dead lock nos serviços do DLX ou do MasterSaf"+CRLF+CRLF//+_cTexto
Local _lOk        := .T.
Local _lJob       := .T.
Default cTipo     := "D"

If cTipo == "D"
	_cAssunto:= "Possivel dead lock identificado no JOB DLX"
	_cBody:= "Foi identificado um possivel dead lock no serviço do DLX no arquivo: " + cFile 
Else
	_cAssunto:= "Possivel dead lock identificado no JOB MASTERSAF"
	_cBody:= "Foi identificado um possivel dead lock no serviço do MasterSaf no arquivo: " + cFile 
EndIf
	
CONNECT SMTP SERVER _cServer ACCOUNT _cUser PASSWORD _cSenha Result _lOk

lEnviado := MailSend(_cFrom, {_cTo},{},{}, _cAssunto, _cBody,,.F.)

If !lEnviado
	cError := MailGetErr()
	_cMensagem :="***[MailSche]*** Falha na conexao: "+cError
	
	If (_lJob)
		FWLogMsg(_cMensagem)		
	Else
		MsgInfo(_cMensagem,"Informação")
	EndIf
Endif

DISCONNECT SMTP SERVER result _lOk
Conout("email enviado alertando possivel dead Lock")
return()

/**
 * Coleta o proximo ID da tabela de Log SZ2
 */
static function getNextId()
	
	local cNextId := ""
	local oSql    := IpSqlObject():newIpSqlObject()
	
	oSql:newAlias(" SELECT MAX(Z2_ID) MAXID FROM %SZ2.SQLNAME% "+;
				  " WHERE Z2_FILIAL = '%SZ2.FILIAL%' AND %SZ2.NOTDEL% ")
	
	cNextId := oSql:getValue("Soma1(MAXID)")
	
	if Empty(cNextId)
		cNextId := StrZero(1, Len(SZ2->Z2_ID))
	endIf
	
	oSql:close()
	
return cNextId

//Procura recorrência do travamento do arquivo.
Static Function LocArq(cArq,cProc)

Local CQUERY := ""
Local lRet := .F.

CQUERY := " SELECT SZ2.R_E_C_N_O_ RECNO" 
CQUERY += " FROM "      +RetSqlName ('SZ2')+" SZ2 "
CQUERY += " WHERE SZ2.D_E_L_E_T_<> '*' "
CQuery += " AND     SZ2.Z2_FILIAL  = '"+ xFilial("SZ2") + "' AND SZ2.Z2_PROC = '" + cProc+ "' "
CQuery += " AND     SZ2.Z2_CODAPLI = '"+ cCodApli + "' AND SZ2.Z2_ARQUIVO = '" + cArq+ "' "

IF SELECT("TD2")<> 0
	TD2->(DBCLOSEAREA())
ENDIF

TCQUERY CQUERY NEW ALIAS "TD2"

TD2->(DBGOTOP())

If !TD2->(EOF())
	lRet := .T.
	nRecnoSZ2 := TD2->RECNO
EndIf

Return lRet
