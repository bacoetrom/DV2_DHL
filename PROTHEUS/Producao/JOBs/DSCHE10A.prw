#DEFINE CRLF CHR(13)+CHR(10)
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDSCHE10A  บAutor  ณEmerson Holanda     บ Data ณ  23/04/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina responsavel por verificar ose schedule esta ok      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 		Dhl                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DSCHE10A()

Local _cQry			:= "" 						//Variavel para Query
Local _cEmail		:= ""                      	//Variavel para armazenar os destinatarios
Local _cAliasSch	:= GetNextAlias()         	//Alias para query
Local _cAliasEml	:= GetNextAlias()			//Alias para query
Local _nI			:= 1						//Variavel para contador
Local _aRegs		:= {}                      //Array para armazenar o que serแ enviado
Local aAbreTab 		:= {"SCHDTSK"}
Local EmpExec       :="10"
Local FilExec       :="016DIS001663"
Local cData			:= CTOD("")
Local cCodAge		:= ""

RpcClearEnv()
RPCSetType(3)
//RpcSetEnv(EmpExec,FilExec,,,,,{})
//PREPARE ENVIRONMENT EMPRESA cEmp  FILIAL  cFil  MODULO  cModName
RpcSetEnv(EmpExec,FilExec,,,,, {} )

cCodAge :=  GetNewPar("ZZ_CODSCH","000025")
dData   :=  GetNewPar("ZZ_EXESCH",ddatabase)

If dData <> ddatabase
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEncontra o que hแ para ser enviado, agrupandoณ
	//ณpor cliente, vencimento e tipo de envio.     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cQry	:= " SELECT TSK_CODIGO,TSK_DIA, TSK_STATUS "+ CRLF
	_cQry	+= " FROM SCHDTSK "+ CRLF
	_cQry	+= " WHERE D_E_L_E_T_ <> '*' "+ CRLF
	//_cQry	+= " AND TSK_CODIGO = '000025' "+ CRLF   
	_cQry	+= " AND TSK_CODIGO = '"+cCodAge+"' " + CRLF
	_cQry	+= " AND TSK_DIA = '"+Dtos(dDatabase-1)+"' " + CRLF
	_cQry	+= " AND TSK_STATUS = '0' "+ CRLF
	_cQry	:= ChangeQuery(_cQry)
	
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,_cQry),_cAliasSch, .F., .T.)
	(_cAliasSch)->(DbGoTop())
	
	If !(_cAliasSch)->(Eof())		
		FWLogMsg("DSCHE10A - Envia E-mail informando que o schedule nใo executou a ultima rotina do dia corretamente: ["+DtoC(dDatabase)+" - "+Time()+"] Fim chamada")
		
		MailSche()
	Else
		FWLogMsg("DSCHE10A - Verificou e o schedule executou a ultima rotina do dia corretamente: ["+DtoC(dDatabase)+" - "+Time()+"] Fim chamada")
	EndIf
	
	PutMv("ZZ_EXESCH",ddatabase)
	
EndIf

Return




Static Function MailSche()//(_cTexto)

local nEmails

Local _cServer   := SuperGetMv("MV_RELSERV")
Local _cMail     := SuperGetMv("MV_RELACNT")
Local _cUser     := SuperGetMv("MV_RELACNT")
Local _cSenha    := SuperGetMv("MV_RELPSW")
Local _lAuth     := SuperGetMv("MV_RELAUTH")
Local _cFrom     := SuperGetMv("MV_RELFROM")
Local _cTo        := SuperGetMv("ZZ_EMASCH",,"emerson.holanda@fitgestao.com.br")
Local _cAssunto   := "A ultima rotina do SCHEDULE agendada no dia anterior nใo foi executada" //+ " - " + Time()
Local _cBody      := "A ultima rotina agendada do dia anterior " +DtoC(dDatabase-1)+" nใo foi executada, favor verificar o SCHEDULE do configurador."+CRLF+CRLF//+_cTexto
Local _lOk        := .T.
Local _lJob       := .T.

CONNECT SMTP SERVER _cServer ACCOUNT _cUser PASSWORD _cSenha Result _lOk

lEnviado := MailSend(_cFrom, {_cTo},{},{}, _cAssunto, _cBody,,.F.)

If !lEnviado
	cError := MailGetErr()
	_cMensagem :="***[MailSche]*** Falha na conexao: "+cError
	
	If (_lJob)
		FWLogMsg(_cMensagem)		
	Else
		MsgInfo(_cMensagem,"Informa็ใo")
	EndIf
Endif

DISCONNECT SMTP SERVER result _lOk

return()
