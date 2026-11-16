#Include 'Totvs.ch'
#Include 'Font.ch'
#Include 'Colors.ch'
#Include 'DHL.ch'
#include 'ap5mail.ch'
/*
Author...: EDson Deluca
Programa.: FITLogControl
Descrição: Controla o LOG padrão da DHL
Data.....: 18/08/2018
*/

User Function FITLogControl(_cFunName,_cCodMsg,_cDoc1,cDoc2,cDoc3,_cMsg)

    Local _lRet     := .T.
    Local _aArea    := GetArea()
    Local _nDiasPar := SuperGetMV("ZZ_DIASMSG",,1)
    Local _nDiasMsg := 0

    _cFunName := AllTrim(_cFunName)+Space(15-Len(AllTrim(_cFunName)))
    _cDoc1    := AllTrim(_cDoc1)+Space(60-Len(AllTrim(_cDoc1)))
    _cDoc2    := AllTrim(_cDoc2)+Space(60-Len(AllTrim(_cDoc2)))
    _cDoc3    := AllTrim(_cDoc3)+Space(15-Len(AllTrim(_cDoc3)))

    dbSelectArea("ZZ2")
    dbSetOrder(1)

        
    If !(dbSeek(xFilial("ZZ2") + _cFunName + _cCodMsg + _cDoc1 + cDoc2 + cDoc3,.F.))
       FWLogMsg("WARN", , "BusinessObject", funName(), "", "01", "Não achou ZZ2.", 0, 0, {})
       If RecLock("ZZ2",.T.)
          ZZ2->ZZ2_FILIAL := xFilial("ZZ2")
          ZZ2->ZZ2_ROTINA := _cFunName
          ZZ2->ZZ2_CODMSG := _cCodMsg
          ZZ2->ZZ2_DOC1   := _cDoc1
          ZZ2->ZZ2_DOC2   := _cDoc2
          ZZ2->ZZ2_DOC3   := _cDoc3
          ZZ2->ZZ2_DTINCL := dDataBase
          ZZ2->ZZ2_DATA   := dDataBase
          ZZ2->ZZ2_HORA   := TIME()
          ZZ2->ZZ2_MSG    := _cMsg
          MsUnLock("ZZ2")
          FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Gravou ZZ2.", 0, 0, {})
       EndIf
       _lRet := .T.
    Else
       FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Achou ZZ2.", 0, 0, {})
       _nDiasMsg := Date() - ZZ2->ZZ2_DATA
       If _nDiasMsg >= _nDiasPar .And. Time() > ZZ2->ZZ2_HORA
          If RecLock("ZZ2",.F.)
             ZZ2->ZZ2_DATA   := dDataBase
             ZZ2->ZZ2_HORA   := TIME()
             MsUnLock("ZZ2") 
             FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Atualizou ZZ2.", 0, 0, {})
          EndIf
          _lRet := .T.
       Else
          _lRet := .F.
       EndIf
    EndIf
    
Return(_lRet)

