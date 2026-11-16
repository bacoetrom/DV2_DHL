#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} DHLMsgLog
//Retorna em tela a mensagem de LOG
@author admin-gayalalu
@since 11/09/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User function DHLMsgLog(cMsg, cTitulo, nTipo, lEdit)
	
	Local lRetMens := .F.
    Local oDlgMens
    Local oBtnOk, cTxtConf := ""
    Local oBtnCnc, cTxtCancel := ""
    Local oBtnSlv
    Local oFntTxt := TFont():New("Lucida Console",,-015,,.F.,,,,,.F.,.F.)
    Local oMsg
    Local nIni:=1
    Local nFim:=50    
    Default cMsg    := "..."
    Default cTitulo := "DHLMsgLog"
    Default nTipo   := 1 // 1=Ok; 2= Confirmar e Cancelar
    Default lEdit   := .F.
     
    //Definindo os textos dos botões
    If(nTipo == 1)
        cTxtConf:='&Ok'
    Else
        cTxtConf:='&Confirmar'
        cTxtCancel:='C&ancelar'
    EndIf
 
    //Criando a janela centralizada com os botões
    DEFINE MSDIALOG oDlgMens TITLE cTitulo FROM 000, 000  TO 300, 400 COLORS 0, 16777215 PIXEL
        //Get com o Log
        @ 002, 004 GET oMsg VAR cMsg OF oDlgMens MULTILINE SIZE 191, 121 FONT oFntTxt COLORS 0, 16777215 HSCROLL PIXEL
        If !lEdit
            oMsg:lReadOnly := .T.
        EndIf
         
        //Se for Tipo 1, cria somente o botão OK
        If (nTipo==1)
            @ 127, 144 BUTTON oBtnOk  PROMPT cTxtConf   SIZE 051, 019 ACTION (lRetMens:=.T., oDlgMens:End()) OF oDlgMens PIXEL
         
        //Senão, cria os botões OK e Cancelar
        ElseIf(nTipo==2)
            @ 127, 144 BUTTON oBtnOk  PROMPT cTxtConf   SIZE 051, 009 ACTION (lRetMens:=.T., oDlgMens:End()) OF oDlgMens PIXEL
            @ 137, 144 BUTTON oBtnCnc PROMPT cTxtCancel SIZE 051, 009 ACTION (lRetMens:=.F., oDlgMens:End()) OF oDlgMens PIXEL
        EndIf
         
        //Botão de Salvar em Txt
        //@ 127, 004 BUTTON oBtnSlv PROMPT "&Salvar em .txt" SIZE 051, 019 ACTION (fSalvArq(cMsg, cTitulo)) OF oDlgMens PIXEL
    ACTIVATE MSDIALOG oDlgMens CENTERED
	
return