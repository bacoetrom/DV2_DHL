#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "dhl.ch"

/*  Emerson Holanda 02/09/22
Correção chave das notas de devolução da Pfizer que contem apenas 43 caracteres.
*/

User Function DFATA083()

	Private oDlgf 	      := nil
	Private nUltNf        := ''
	Private nTotNf        := 0
	Private cNfConfirm    := Space(43)
	Private lEncerra      :=  .F.
	Private lOk 		  := .F.
	Private nOpcA
	Static oDlgf

	If FwUnitBusiness() <> DHL_BUSINESSUNIT_DIS
		ApMsgStop("Rotina permitida apenas para a unidade de negocio DIS","Atenção")
		Return
	EndIf

	DEFINE MSDIALOG oDlgf TITLE "Corrigir chave nota" FROM 0,0 TO 210,370 PIXEL

	@ 58, 010 SAY "Chave DANFE: " SIZE 70,10 PIXEL OF oDlgf
	@ 58, 050 MSGET oNfConfirm VAR cNfConfirm PICTURE "@R " SIZE 138,10 PIXEL VALID ValidaNf()

	ACTIVATE MSDIALOG oDlgf ON INIT EnchoiceBar( oDlgf,{|| ConfTela()},{|| Encerra()} )CENTERED

Return

Static Function ValidaNf()
	Local lRet      := .T.
	Local cNota     := ""
	Local cSerie    := ""
	Local cChave    := ""
	Local cOriChave := ""
	Local cDigit    := ""
	Local aArea          := GetArea()
	If Empty(cNfConfirm)
		cNfConfirm := Space(43)
		oNFConfirm:Refresh()
		oNFConfirm:SetFocus()
	Else
		If !Empty(cNfConfirm)
			dbSelectArea("SF1")
			dbSetOrder(8) //F1_FILIAL + F1_CHVNFE
			If dbSeek(xFilial("SF1")+Alltrim(cNfConfirm))
				If ApMsgYesNo("Tem certeza que deseja corrigir a chave da nota: "+SF1->F1_DOC+"-"+SF1->F1_SERIE,"Atenção")
					While !SF1->(EOF()) .And. Alltrim(SF1->F1_CHVNFE) == Alltrim(cNfConfirm)
						If Len(Alltrim(SF1->F1_CHVNFE)) == 43
							cNota     := SF1->F1_DOC
							cSerie    := SF1->F1_SERIE
							cOriChave := Alltrim(SF1->F1_CHVNFE)
							cDigit    := Modulo11(cOriChave)
							cChave    := Alltrim(cOriChave) + Alltrim(cDigit)

							Reclock("SF1",.F.)

							SF1->F1_CHVNFE := cChave

							SF1->( MsUnlock() )

							CQUERY := " SELECT R_E_C_N_O_ RECSF3 "
							CQUERY += " FROM "       +RetSqlName ('SF3')+" SF3 "
							CQUERY += " WHERE SF3.D_E_L_E_T_<> '*' "
							CQuery += " AND   SF3.F3_FILIAL    = '"+ SF1->F1_FILIAL+"' AND SF3.F3_CHVNFE   = '" + cOriChave+ "' "

							IF SELECT("TD3")<> 0
								TD3->(DBCLOSEAREA())
							ENDIF

							TCQUERY CQUERY NEW ALIAS "TD3"

							TD3->(DBGOTOP())
							If !TD3->(EOF())
								While !TD3->(EOF())
									dbSelectArea("SF3")
									dbGoTo(TD3->RECSF3)
									If Len(Alltrim(SF3->F3_CHVNFE)) == 43
										Reclock("SF3",.F.)

										SF3->F3_CHVNFE := cChave

										SF3->( MsUnlock() )
									EndIf
									TD3->(Dbskip())
								End
							EndIf
							ApmsgInfo("Chave corrigida da nota: "+cNota+"-"+cSerie,"Atenção")

							cNfConfirm := Space(43)
							oNFConfirm:Refresh()
							oNFConfirm:SetFocus()

						Else
							ApmsgInfo("Ja contem 44 digitos a chave da nota: "+SF1->F1_DOC+"-"+SF1->F1_SERIE,"Atenção")
							cNfConfirm := Space(43)
							oNFConfirm:Refresh()
							oNFConfirm:SetFocus()
						EndIf
						SF1->(Dbskip())
					end
					cNfConfirm := Space(43)
					oNFConfirm:Refresh()
					oNFConfirm:SetFocus()
				Else
					ApmsgInfo("Escolhido para nao corrigir a chave da nota: "+SF1->F1_DOC+"-"+SF1->F1_SERIE,"Atenção")
					cNfConfirm := Space(43)
					oNFConfirm:Refresh()
					oNFConfirm:SetFocus()
				EndIf
			Else
				Help( ,, 'HELP',, "Chave DANFE invalida!", 1, 0,)
				lRet := .F.
			EndIf
		Else
			lRet := .F.
		EndIf
	EndIf

	RestArea(aArea)

Return lRet

Static Function Encerra()

	oDlgf:End()

Return

Static Function ConfTela()



	oDlgf:end()


Return
