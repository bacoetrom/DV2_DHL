#include 'totvs.ch'

/*/{Protheus.doc} IPMail
Classe auxiliar para envio de e-mail
@type class
@author Gustavo Luiz
@since 25/03/2018
@version 1.0
@example
(examples)
@see (links_or_references)
/*/

CLASS IPMail   

    data cSMTPServer
    data cSMTPUser
    data cSMTPPass
    data nSMTPPort
    data cAssunto
    data cTo
    data cCc
    data oMail
    data cError
    data cFrom
    data cMensagem
    data aAttached    

    METHOD NewIPMail() CONSTRUCTOR
    
    method getAttached()
    method setAttached()

    method getSMTPServer()
    method setSMTPServer()    

    method getSMTPUser()
    method setSMTPUser()   

    method getSMTPPass()
    method setSMTPPass()    

    method getSMTPPort()
    method setSMTPPort()    

    method getAssunto()
    method setAssunto()    

    method getTo()
    method setTo()    
    
    method getcCc()
    method setcCc()

    method getError()
    method setError()    

    method getFrom()
    method setFrom()    

    method getMensagem()
    method setMensagem()   

    method init()    
    method send()    

ENDCLASS


/*/{Protheus.doc} NewIPMail
Método Construtor
@author Gustavo Luiz
@since 25/03/2018
@version 1.0
@example
(examples)
/*/

METHOD NewIPMail(lTLS) CLASS IPMail   

    ::oMail          	 := TMailManager():New()    
    ::cTo          		 := ""
    ::cCc				 := ""
    ::oMail:SetUseTLS(.F.)    
    ::oMail:SetUseSSL( .F. )
    ::cError         	:= ""
    ::cFrom          	:= ""
    ::cMensagem      	:= ""
    ::aAttached      	:= {}
    ::cSMTPServer 	    := ""
    ::cSMTPUser   	    := ""
    ::cSMTPPass   		:= ""
    ::nSMTPPort   		:= 0
    ::cAssunto          := ""    

Return

/*/{Protheus.doc} getAttached
Obtém os arquivos para enviar em anexo

@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  getAttached() class IPMail
return ::aAttached


/*/{Protheus.doc} setAttached
Define os arquivos a serem anexados
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  setAttached(aAttached) class IPMail

    ::aAttached := aAttached

return


/*/{Protheus.doc} getSMTPServer
Obtém o server SMTP

@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  getSMTPServer() class IPMail
return ::cSMTPServer


/*/{Protheus.doc} setSMTPServer
Define o server SMTP
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  setSMTPServer(cSMTPServer) class IPMail

    ::cSMTPServer := cSMTPServer

return


/*/{Protheus.doc} getSMTPUser
Obtém o usuário SMTP
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  getSMTPUser() class IPMail

return ::cSMTPUser

/*/{Protheus.doc} setSMTPUser
Define o usuário SMTP
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  setSMTPUser(cSMTPUser) class IPMail
    ::cSMTPUser := cSMTPUser
return


/*/{Protheus.doc} getSMTPPass
Obtém a senha SMTP
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  getSMTPPass() class IPMail
return ::cSMTPPass

/*/{Protheus.doc} setSMTPPass
Define a senha SMTP
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  setSMTPPass(cSMTPPass) class IPMail
    ::cSMTPPass := cSMTPPass
return

/*/{Protheus.doc} getSMTPPort
Obtém a porta SMTP
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  getSMTPPort() class IPMail

return ::nSMTPPort

/*/{Protheus.doc} setSMTPPort
Define a porta SMTP
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  setSMTPPort(nSMTPPort) class IPMail

    ::nSMTPPort := nSMTPPort

return

/*/{Protheus.doc} getAssunto
Obtém o assunto
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  getAssunto() class IPMail
return ::cAssunto

/*/{Protheus.doc} setAssunto
Define o assunto
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  setAssunto(cAssunto) class IPMail
    ::cAssunto := cAssunto
return

/*/{Protheus.doc} getTo
Obtém o e-mail que será enviado
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  getTo() class IPMail

return ::cTo

/*/{Protheus.doc} setTo
Define o e-mail que será enviado
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)

/*/

method  setTo(cTo) class IPMail
    ::cTo := cTo
return

/*/{Protheus.doc} setcCc
Define os e-mais que serão enviado em cópia
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)

/*/

method  setcCc(cCc) class IPMail
    ::cCc := cCc
return

/*/{Protheus.doc} getcCc
Obtém os e-mais que serão enviado em cópia
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  getcCc() class IPMail   
return  ::cCc 

/*/{Protheus.doc} getError
Obtém o erro
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  getError() class IPMail
return ::cError

/*/{Protheus.doc} setError
Define o erro
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  setError(cError) class IPMail
    ::cError := cError
return


/*/{Protheus.doc} getFrom
Obtém o e-mail que esta envindo
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  getFrom() class IPMail
return ::cFrom

/*/{Protheus.doc} setFrom
Define o e-mail que esta envindo
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  setFrom(cFrom) class IPMail
    ::cFrom := cFrom
return

/*/{Protheus.doc} init
Define as configurações da classe TMailManager para
realizar uma conexão com o servidor de e-mail.
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  init() class IPMail

    local nStatus := 0 
    local nErro   := 0
    
    nStatus := ::oMail:Init( '', ::cSMTPServer , ::cSMTPUser, ::cSMTPPass, 0, ::nSMTPPort )
    
    ::oMail:SetSmtpTimeOut( 500 )  

    nErro := ::oMail:SmtpConnect()   

    if nErro !=0
        ::setError(::oMail:GetErrorString(nErro))
    else
     /*
        nErro := ::oMail:SmtpAuth("" ,"")

        if nErro !=0

            ::setError(::oMail:GetErrorString(nErro))

        endIf
         */
    endIf   

return

/*/{Protheus.doc} getMensagem
Obtém a mensagem
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  getMensagem() class IPMail

return ::cMensagem


/*/{Protheus.doc} setMensagem
Define a mensagem
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  setMensagem(cMensagem) class IPMail

    ::cMensagem := cMensagem

return


/*/{Protheus.doc} send
Envia o e-mail
@author Gustavo Luiz
@since 01/09/2019
@version 1.0
@example
(example)
/*/

method  send(cMensagem) class IPMail    

    local oMessage  := TMailMessage():New()
    local nRet		:= 0  
    local lSendMail := .T.

    oMessage:Clear()
    oMessage:cFrom        := ::cFrom
    
    for nI := 1 to len(::aAttached)
    
    	nRet := oMessage:AttachFile( ::aAttached[nI] )
    
    next nI     
    
    oMessage:cTo          := ::cTo
    oMessage:cCc		  := ::cCc
    oMessage:cSubject     := ::cAssunto
    oMessage:cBody        := cMensagem
    oMessage:MsgBodyType( "text/html" )

    nErro := oMessage:Send( ::oMail )    

    if nErro != 0

        ::setError(::oMail:GetErrorString(nErro))
        lSendMail := .F.

    endIf   

    ::oMail:SMTPDisconnect()   

return lSendMail