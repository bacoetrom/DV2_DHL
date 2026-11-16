#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
/*
DESTA002()

Função para gravar manualmente o documento de referencia Dev/Recusa para SCJ


Emerson Holanda
02/03/2018

*/

User Function DESTA002()
Local   cNfVinc  := SF1->F1_ZZNFDEV //Space(9)
Local   cSerVinc := SF1->F1_ZZSEDEV //Space(3)
Local   dDataDev := SF1->F1_ZZDTDEV //CTOD("  /  /  ")



DEFINE MSDIALOG oDlgRet TITLE "Informar Nf Devolução SCJ" From 4,0 To 13,34 OF oMainWnd

@  4, 006  SAY "Nf Devolução" SIZE 70,7 PIXEL OF oDlgRet
@ 19, 006  SAY "Serie Devolução" SIZE 70,7 PIXEL OF oDlgRet
@ 34, 006  SAY "Data Devolução" SIZE 70,7 PIXEL OF oDlgRet

@  3, 060  MSGET cNfVinc   When .T. PICTURE "@!" 	SIZE 15,7 PIXEL OF oDlgRet
@ 18, 060  MSGET cSerVinc  When .T. PICTURE "@!" 	SIZE 15,7 PIXEL OF oDlgRet
@ 33, 060  MSGET dDataDev  When .T. PICTURE "99/99/9999" SIZE 45,7 PIXEL OF oDlgRet hasbutton


TButton():New( 50, 5, "OK", oDlgRet,{||If (SF1GRAVR(cNfVinc,cSerVinc,dDataDev),oDlgRet:End(),Nil)},;
25, 10,,,.F.,.T.,.F.,,.F.,,,.F. )

TButton():New( 50, 35, "Cancelar", oDlgRet,{||oDlgRet:End()},25, 10,,,.F.,.T.,.F.,,.F.,,,.F. )



ACTIVATE MSDIALOG oDlgRet CENTERED
Return

Static Function SF1GRAVR(cNfVinc,cSerVinc,dDataDev)
Local lRet := .T.

Begin Transaction

If lRet
	SF1->( Reclock("SF1",.F.) )
	
	SF1->F1_ZZSTATU := ""
	SF1->F1_ZZNFDEV := cNfVinc
	SF1->F1_ZZSEDEV := cSerVinc
	SF1->F1_ZZDTDEV := dDataDev
	
	SF1->( MsUnlock() )
	
	MSGINFO("Informações gravadas com sucesso!")
	
EndIf

End Transaction

Return lRet

