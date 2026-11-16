#include "totvs.ch"
#INCLUDE "msobject.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "protheus.ch"

/*/{Protheus.doc}	DHLSndMail
Classe de Envio de e-mails DHL

@author				Gustavo Luiz - TOTVS IP Campinas
@since				18/05/2016 
@return				nil
/*/
Class DHLSndMail

	Data cVersion	as 	Character
	Data cFrom		as 	Character
	Data cTo		as 	Character
	Data cCC		as	Character
	Data cBCC		as	Character
	Data cSubject	as	Character
	Data cAttached	as	Character
	Data aAttached	as	Character
	Data cBody		as	Character
	Data lSilence	as	Boolean

	Data cServer	as Character
	Data cAccount	as Character
	Data cPassword	as Character
	Data lAuth		as Boolean		

	Method	Create()	Constructor
	Method 	Send()
	Method	Make(lOk,cFrom,cTo,cCC,cBCC,cSubject,cAttached,cBody,aAttached)

EndClass

Method Create() Class DHLSndMail

	::cVersion	:= '1.0'
	::cFrom		:= ''
	::cTo		:= ''
	::cCC		:= ''
	::cBCC		:= ''
	::cSubject	:= ''
	::cAttached	:= ''
	::aAttached	:= {}
	::cBody		:= ''
	::lSilence	:= .f.
	
	::cServer	:= AllTrim(GetMV("MV_RELSERV")) // Servidor SMTP
	::cAccount	:= ""	// Conta sem dominio
	::cPassword	:= ""	// Senha 
	::lAuth		:= GetMv("MV_RELAUTH")
	
Return

Method Send() Class DHLSndMail
	Local	lOk		:= .F.

	If ::lSilence
		::Make(@lOk,::cFrom,::cTo,::cCC,::cBCC,::cSubject,::cAttached,::cBody,::aAttached)
	Else
		MsgRun('Enviando E-mails, Aguarde...','',{ || CursorWait(), ::Make(@lOk,::cFrom,::cTo,::cCC,::cBCC,::cSubject,::cAttached,::cBody,::aAttached), CursorArrow() })
	Endif

Return(lOk)

Method Make(lOk,cFrom,cTo,cCC,cBCC,cSubject,cAttached,cBody,aAttached) Class DHLSndMail
	
	Local	cMsgError	:= ''
	Local	cServer		:= ::cServer
	Local	cAccount	:= ::cAccount
	Local	cPassword	:= ::cPassword
	Local 	lAuth		:= ::lAuth
	
	Connect Smtp Server cServer Account cAccount Password cPassword Result lOk
	
	if lOk
	 	if lAuth
		 	if !MailAuth(cAccount,cPassword)
				Get Mail Error cMsgError
				Help('',1,'AVG0001056',,'Error (1) :' + cMsgError,2,0)
				Disconnect Smtp Server Result lOk
				if !lOk
					Get Mail Error cMsgError
					Help('',1,'AVG0001056',,'Error (2) :' + cMsgError,2,0)
				endif
				Return( .f. )
			endif
		endif
		
		// Tratamento de anexos quando for = a 1
		If Len(aAttached) == 1
	        Send Mail From cFrom To cTo;
		 	CC cCC;
	       	BCC cBCC;
	        Subject cSubject;
	        Body cBody;
	        Attachment aAttached[1];
	        Result lOk
		Else
		// Tratamento de anexos quando maior que 1
			If Len(aAttached) > 1
	       	 Send Mail From cFrom To cTo;
		 		CC cCC;
		       	BCC cBCC;
	        	Subject cSubject;
	        	Body cBody;
	        	Attachment aAttached[1],aAttached[2];
	        	Result lOk
	    	else
	        	Send Mail From cFrom To cTo;
		 		CC cCC;
		       	BCC cBCC;
	        	Subject cSubject;
	        	Body cBody;
	        	Attachment cAttached;
	        	Result lOk
        endIf
       endIf

		if !lOk
			Get Mail Error cMsgError
			Help('',1,'AVG0001056',,'Error (3) :' + cMsgError,2,0)
			Return( .f. )
		endif

	else

		Get Mail Error cMsgError
		Help('',1,'AVG0001056',,'Error (4) :' + cMsgError,2,0)
		Return( .f. )
	endif

	Disconnect Smtp Server

Return( .t. )
