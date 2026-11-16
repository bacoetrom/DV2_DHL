#Include 'Totvs.ch'
#Include 'Font.ch'
#Include 'Colors.ch'
#Include 'DHL.ch'
#include 'ap5mail.ch'

/*/{Protheus.doc} AgeVincNFTer - Tela de seleção das Nf´s de Comodato.
		
		Processo para a Unidade de Negócio HP AGE.
		
		@author 	Cassandra J. Silva
		@since 		05/09/2016
		@version 	1.0
		@type 		Function
/*/

// campo do pedido para fazer amarração: C5_ZZORDEX = Z8_DOC + Z8_SERIE

*********************************************************************************************************************************************************************
User Function _AgeMailVinc(cParam1,cParam2)
*********************************************************************************************************************************************************************
    
    Local _nI

    RpcSetEnv(cParam1,cParam2)
    
	private lNewAge       := SuperGetMV("ZZ_NEWAGE",,.F.)	
    private lAutomatic    := SuperGetMv("ZZ_AUTOMAT",,.F.)		
	
    If lNewAge .And. lAutomatic

	   BeginSql Alias "QRY"
	      SELECT *
	      FROM %Table:SC5% SC5
	      WHERE
		     SC5.C5_FILIAL = %xFilial:SC5% AND
		     SC5.C5_NOTA = '         ' AND
		     SC5.%NotDel%
	   EndSql
		
	   QRY->(dbGoTop())
	   If QRY->(Eof())
	      FWLogMsg("WARN", , "BusinessObject", funName(), "", "01", "Não existem Pedidos sem vínculos. Verifique!", 0, 0, {})
       Else
          SC5GeraTxt()
	   Endif

	   If Select("QRY") <> 0
		  QRY->(dbCloseArea())
	   Endif

	   BeginSql Alias "QRY"
		  SELECT *
		  FROM %Table:SZ8% SZ8
		  WHERE
			 SZ8.Z8_FILIAL = %xFilial:SZ8% AND
			 SZ8.Z8_NFRET = '         ' AND
			 SZ8.%NotDel%
	   EndSql
		
	   QRY->(dbGoTop())
	   If QRY->(Eof())
		  FWLogMsg("WARN", , "BusinessObject", funName(), "", "01", "Não existem NF sem vínculos. Verifique!", 0, 0, {})
       Else
          SZ8GeraTxt()
	   Endif

       If Select("QRY") <> 0
	      QRY->(dbCloseArea())
       Endif
    
    EndIf

    RpcClearEnv()
     
Return Nil

****************************
Static Function SC5GeraTxt()
****************************

Local _cTexto := ""

dbSelectArea("QRY")
dbGoTop()

While !Eof()
   
   _cTexto += "Pedido de Venda: " + QRY->C5_NUM + SPACE(05) + "Emissao: "+DtoC(StoD(QRY->C5_EMISSAO)) + CRLF 

   dbSelectArea("QRY")
   dbSkip()

End

MailDHL(_cTexto)

Return

****************************
Static Function SZ8GeraTxt()
****************************
Local _cTexto := ""

dbSelectArea("QRY")
dbGoTop()

While !Eof()
   
   _cTexto += "N.F.: " + QRY->Z8_SERIE + QRY->Z8_DOC + SPACE(05) + "Emissao: "+DtoC(StoD(QRY->Z8_EMISSAO)) + CRLF 

   dbSelectArea("QRY")
   dbSkip()

End

MailDHL(_cTexto)

Return

********************************
Static Function MailDHL(_cTexto)
********************************

local nEmails

Local _cServer   := SuperGetMv("MV_RELSERV")
Local _cMail     := SuperGetMv("MV_RELACNT")
Local _cUser     := SuperGetMv("MV_RELACNT")
Local _cSenha    := SuperGetMv("MV_RELPSW")
Local _lAuth     := SuperGetMv("MV_RELAUTH")
Local _cFrom     := SuperGetMv("MV_RELFROM")
Local _cTo        := SuperGetMv("ZZ_MAILTER",,"daniela.barbosa@dhl.com")
Local _cAssunto   := "Documentos sem Vinculos Terceiros" + " - " + Time()
Local _cBody      := "Segue Lista de Documentos sem vínculos:"+CRLF+CRLF+_cTexto
Local _lOk        := .T.  
Local _lJob       := .T.

CONNECT SMTP SERVER _cServer ACCOUNT _cUser PASSWORD _cSenha Result _lOk

lEnviado := MailSend(_cFrom, {_cTo},{},{}, _cAssunto, _cBody,,.F.)

If !lEnviado
    cError := MailGetErr()
    _cMensagem :="***[_AgeMailVinc]*** Falha na conexao: "+cError

    If (_lJob)
       FWLogMsg("ERROR", , "BusinessObject", funName(), "", "01", _cMensagem, 0, 0, {})
    Else
       MsgInfo(_cMensagem,"Informação")
    EndIf
Endif

DISCONNECT SMTP SERVER result _lOk

return()               


