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
User Function _AgeMaiNFCob(cParam1,cParam2)
*********************************************************************************************************************************************************************
    
    Local _nI

    RpcSetEnv(cParam1,cParam2)
    
	private lNewAge       := SuperGetMV("ZZ_NEWAGE",,.F.)	
    private lAutomatic    := SuperGetMv("ZZ_AUTOMAT",,.F.)		
	
    If lNewAge .And. lAutomatic

	   BeginSql Alias "QRY"
          SELECT DISTINCT SF1.F1_DOC,SF1.F1_SERIE,SF1.F1_FORNECE,SF1.F1_LOJA
          FROM %Table:SF1% SF1 
          WHERE SF1.F1_FILIAL = %Exp:xFilial("SF1")% AND 
          SF1.F1_XNFTRF  = ' ' AND 
          SF1.%NotDel% AND 
          SF1.F1_DOC NOT IN (SELECT Z42.Z4_DOC FROM %Table:SZ4% Z42 WHERE Z42.Z4_FILIAL = %Exp:xFilial("SZ4")% AND Z42.Z4_DOC = SF1.F1_DOC AND Z42.Z4_SERIE = SF1.F1_SERIE AND Z42.Z4_TIPMOV  = '2' AND Z42.%NotDel%) AND 
          SF1.F1_DOC IN (SELECT Z41.Z4_DOC FROM SZ4100 Z41 WHERE Z41.Z4_FILIAL = %Exp:xFilial("SZ4")% AND Z41.Z4_DOC = SF1.F1_DOC AND Z41.Z4_SERIE = SF1.F1_SERIE AND Z41.Z4_TIPMOV  = '1' AND Z41.Z4_SALDO<>0 AND Z41.%NotDel%) 
	   EndSql
		
	   dbSelectArea("QRY")	
	   QRY->(dbGoTop())
	   
	   If QRY->(Eof())
		  FWLogMsg("WARN", , "BusinessObject", funName(), "", "01", "Não existem Notas a Vincular Cobertura. Verifique!", 0, 0, {})
       Else
          SZ4GeraTxt()
	   Endif

	   If Select("QRY") <> 0
		  QRY->(dbCloseArea())
	   Endif

    EndIf
    
    RpcClearEnv()
     
Return Nil

****************************
Static Function SZ4GeraTxt()
****************************

Local _cTexto := ""

dbSelectArea("QRY")
dbGoTop()

While !Eof()
   
   _cTexto += "NF sem Vínculo: "+QRY->F1_DOC+Space(5)+"Serie: "+QRY->F1_SERIE+Space(5)+"Fornecedor: "+QRY->F1_FORNECE+Space(5)+"loja: "+QRY->F1_LOJA+CRLF 

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
Local _cAssunto   := "Documentos sem Cobertura Fiscal" + " - " + Time()
Local _cBody      := "Segue Lista de Documentos sem vínculos:"+CRLF+CRLF+_cTexto
Local _lOk        := .T.  
Local _lJob       := .T.

CONNECT SMTP SERVER _cServer ACCOUNT _cUser PASSWORD _cSenha Result _lOk

lEnviado := MailSend(_cFrom, {_cTo},{},{}, _cAssunto, _cBody,,.F.)

If !lEnviado
    cError := MailGetErr()
    _cMensagem :="***[_AgeMailCob]*** Falha na conexao: "+cError

    If (_lJob)
    	FWLogMsg("ERROR", , "BusinessObject", funName(), "", "01", _cMensagem, 0, 0, {})
    Else
    	MsgInfo(_cMensagem,"Informação")
    EndIf
Endif

DISCONNECT SMTP SERVER result _lOk

return()               


