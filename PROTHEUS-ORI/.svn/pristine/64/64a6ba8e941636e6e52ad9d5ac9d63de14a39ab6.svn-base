#Include 'Protheus.ch'

/*/{Protheus.doc} A140EXC

Ponto de entrada de validação da exclusão da pré nota
	
@author Renato Castro
@since 18/11/2014

@return logico indica se pode ou não excluir
/*/
User Function A140EXC()

local lRet := .T.

	if existBlock("VALIDCOB")
		lRet := U_ValidCob()
	endif
	
	dbSelectArea("SZZ")
	dbSetOrder(1)
    If dbSeek(xFilial("SZZ")+"E"+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.F.) 
       While !Eof() .And. xFilial("SZZ")==SZZ->ZZ_FILIAL .And. SZZ->ZZ_TIPODOC="E" .And. SZZ->ZZ_DOC==SF1->F1_DOC .And. SZZ->ZZ_SERIE==SF1->F1_SERIE .And. SZZ->ZZ_CLIFOR==SF1->F1_FORNECE .And. SZZ->ZZ_LOJA==SF1->F1_LOJA 
          
          If RecLock("SZZ",.F.)
             dbDelete()
             MsUnLock("SZZ")
          EndIf

          dbSelectArea("SZZ")
          dbSkip()
       End
    EndIf
Return(lRet)

