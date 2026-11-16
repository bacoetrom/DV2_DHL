#include "totvs.ch"
#include "dhl.ch"

#define TYPE_START		"1"
#define TYPE_WARN		"2"
#define TYPE_FAIL		"3"
#define TYPE_ERROR		"4"

/*/{Protheus.doc} DHLLogManager

Objeto para Controle de Logs
	
@author Victor Hugo
@since 14/10/2014
/*/
class DHLLogManager
	
	data cId
	data nRecno
	data lInJob
	data lEmail
	data oMail
	
	method newDHLLogManager() constructor
	
	method getId()
	method getRecno()
	
	method start()
	method success()
	method warn()
	method fail()
	method hasMail()
	
endClass


/*/{Protheus.doc} newDHLLogManager

Construtor
	
@author Victor Hugo
@since 14/10/2014
/*/
method newDHLLogManager(lMail) class DHLLogManager
	
	::cId 	:= ""
	::nRecno := 0
	::lInJob := (Type("oMainWnd") != "O")		
	::lEmail := .F.
	::oMail  := nil
 			
return self


/*/{Protheus.doc} getId

Coleta o ID do Log
	
@author Victor Hugo
@since 14/10/2014

@return String ID do Log
/*/
method getId() class DHLLogManager
return ::cId


/*/{Protheus.doc} getRecno

Coleta o Recno do registro de Log
	
@author Victor Hugo
@since 14/10/2014

@return Numerico Recno do registro de Log
/*/
method getRecno() class DHLLogManager
return ::nRecno


/*/{Protheus.doc} getRecno

Verfica se Filial possui envio de log por e-mail
	
@author Thiago Meschiatti
@since 10/02/2017

@return Logico Indica se possui envio de e-mail
/*/
method hasMail() class DHLLogManager
return (::lEmail)


/*/{Protheus.doc} start

Inicia um novo log. Será criado um registro tipo Processamento Iniciado.
	
@author Victor Hugo
@since 14/10/2014

@param cApplication, String, Código da Aplicação
@param cProcess, String, Código do Processo
@param cFile, String, Arquivo de Integração (Opcional)

@return Logico Indica se o Log foi iniciado com sucesso
/*/
method start(cApplication, cProcess, cFile) class DHLLogManager
	
	local oSql		:= IpSqlObject():newIpSqlObject()
	local lOk		:= .F.
	local aData 	:= {}
	local cCodUser	:= ""
	local cLoginUser:= ""
	local cDescApp	:= oSql:getFieldValue("SZ1", "Z1_DESCRI", "Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '"+cApplication+"'")
	default cFile	:= ""		
	
	if ::lInJob
		cCodUser   := "000000"
		cLoginUser := "Administrador"
	else
		cCodUser   := __cUserId
		cLoginUser := cUserName	
	endIf
	
	::cId := getNextId()
	
	aAdd(aData, {"Z2_FILIAL", xFilial("SZ2")})
	aAdd(aData, {"Z2_ID", ::cId})
	aAdd(aData, {"Z2_TIPO", TYPE_START})
	aAdd(aData, {"Z2_CODAPLI", cApplication})
	aAdd(aData, {"Z2_DESAPLI", cDescApp})
	aAdd(aData, {"Z2_DATA", Date()})
	aAdd(aData, {"Z2_HORA", Time()})
	aAdd(aData, {"Z2_CODUSER", cCodUser})
	aAdd(aData, {"Z2_LOGUSER", cLoginUser})
	aAdd(aData, {"Z2_PROC", cProcess})
	aAdd(aData, {"Z2_ARQUIVO", getNoProcessingFile(cFile)})	
	
	lOk := oSql:insert("SZ2", aData, @::nRecno)	
	
return lOk

/**
 * Coleta o proximo ID
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


/*/{Protheus.doc} success

Define que o processo foi realizado com sucesso. O registro do Log será removido permanentemente.
	
@author Victor Hugo
@since 14/10/2014

@param cMessage, String, Mensagem sobre o resultado do processamento
/*/
method success() class DHLLogManager
	
	local lClear := .T.
	local oSql   := IpSqlObject():newIpSqlObject()
	
	if Empty(::nRecno)
		return .F.
	endIf	
	
return oSql:delete("SZ2", "R_E_C_N_O_ = "+AllTrim(Str(::nRecno)), lClear)


/*/{Protheus.doc} warn

Log de Alerta
	
@author Victor Hugo
@since 14/10/2014

@param cMessage, String, Mensagem resumida sobre a Alerta. Ex.: Registro já existente
@param cCode, String, Log do Alerta

@return Logico Indica se o log foi gravado com sucesso
/*/
method warn(cMessage, cLog) class DHLLogManager
return updateLog(self, cMessage, cLog, TYPE_WARN)		


/*/{Protheus.doc} fail

Log de Falha
	
@author Victor Hugo
@since 14/10/2014

@param cMessage, String, Mensagem resumida sobre a Falha. Ex.: Falha ao Incluir Doc. de Entrada
@param cCode, String, Log da Falha

@return Logico Indica se o log foi gravado com sucesso
/*/
method fail(cMessage, cLog) class DHLLogManager
return updateLog(self, cMessage, cLog, TYPE_FAIL)


/**
 * Atualização do LOG
 */
static function updateLog(oSelf, cMessage, cLog, nType)
	
	local aAreaSZ2 := SZ2->(GetArea()) 
	
	fLoadMail(@oSelf)
	
	if (Empty(oSelf:nRecno))
		return .F.
	endIf 
	
	SZ2->(dbGoTo(oSelf:nRecno))
	SZ2->(RecLock("SZ2", .F.))
		SZ2->Z2_TIPO := nType
		SZ2->Z2_MSG  := cMessage
		SZ2->Z2_LOG  := cLog		
	SZ2->(MsUnlock())		
	
	RestArea(aAreaSZ2)
	
	if (nType == TYPE_WARN) 
		__lHasWarnLogDHL := .T.
		if oSelf:hasMail()
			fEnvMail(@oSelf)
		endif
	elseIf (nType == TYPE_FAIL)
		__lHasFailLogDHL := .T.
		if oSelf:hasMail()
			fEnvMail(@oSelf)
		endif
	endIf
	
return .T.

/**
 * Retorna o nome do arquivo sem a extensão .processing
 */
static function getNoProcessingFile(cFile)
	
	cFile := AllTrim(Lower(cFile))
	
	if (Right(cFile, 11) == PROCESSING_EXTENSION)
		cFile := StrTran(cFile, PROCESSING_EXTENSION, "")
	endIf
	
return cFile

/*
** Função para envio de e-mail, notificando a rejeição da NF Automática
*/
static function fEnvMail(oSelf)
	
	local aAreaSZ2 		:= SZ2->(GetArea()) 
	local cEmailFrom	:= alltrim(GetMv("MV_RELFROM"))
	local cEmailTo		:= GetNewPar("ZZ_MAILLOG", "")
	local cDescrResu 	:= ""	
	local cDescrCompl 	:= ""
	local cMsg			:= ""
	
	SZ2->(dbGoTo(oSelf:nRecno))
	
	cMsg += "<html><head>Log de Integrações</head><body>"
	cMsg += "<br/>"
	cMsg += "Filial:"
	cMsg += "ID do Log: " 	+ alltrim(SZ2->Z2_FILIAL) 	+ "<br/>" 
	cMsg += "Aplicação: " 	+ alltrim(SZ2->Z2_DESAPLI)	+ "<br/>"
	cMsg += "Data: " 		+ dtoc(SZ2->Z2_DATA) 		+ "<br/>"
	cMsg += "Hora: " 		+ alltrim(SZ2->Z2_HORA) 	+ "<br/>"
	cMsg += "Arquivo: " 	+ alltrim(SZ2->Z2_ARQUIVO)	+ "<br/>"
	cMsg += "Mensagem: " 	+ alltrim(SZ2->Z2_MSG) 	+ "<br/>"
	cMsg += "Log: " 		+ alltrim(SZ2->Z2_LOG) 	+ "<br/>"
	cMsg += "</body></html>"
		
	oSelf:oMail:cFrom	 	:= cEmailFrom
	oSelf:oMail:cTo			:= cEmailTo
	oSelf:oMail:cSubject	:= "Log de Integrações - Filial: " + SZ2->Z2_FILIAL
	oSelf:oMail:cBody		:= cMsg
	oSelf:oMail:lSilence	:= .T.
	
	Conout("[" + DToC(dDataBase) + " - " + Time() + "] - Envio de e-mail de  "+cEmailFrom  )
	Conout("[" + DToC(dDataBase) + " - " + Time() + "] - Para: " + cEmailTo )
	
	if oSelf:oMail:send()
		Conout("================= [" + DToC(dDataBase) + " - " + Time() + "] - Enviado com sucesso.")
	else
		Conout("================= [" + DToC(dDataBase) + " - " + Time() + "] - Não foi possível enviar e-mail.")
	endif
			
	RestArea(aAreaSZ2)
		
return


/*
** Carrega paramentro para a filial logada
*/
static function fLoadMail(oSelf)
	oSelf:oMail	:= DHLSndMail():Create()
	oSelf:lEmail 	:= GetNewPar("ZZ_LOGMAIL", .f.)
return