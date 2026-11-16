#Include "Protheus.ch"
#INCLUDE "dhl.ch"

#Define		CAMPO_CFOP_XML		"D1_ZZCFOP"

/*/{Protheus.doc} EntrSimb
Rotina de Entrada Simbólica

@type		Function
@author 	Julio Lisboa
@since 		25/08/2016
@return 	nil, nulo
/*/
User Function EntrSimb()

	Local aAreaAtu		:= GetArea()
	Local aAreaSF1		:= SF1->(GetArea())
	Local aAreaSD1		:= SD1->(GetArea())
	
	Local cCFOP			:= GetNewPar( "ZZ_CFREMSI" , "5934" )
	
	Local lExistCPO		:= SD1->(FieldPos(CAMPO_CFOP_XML)) > 0
	
	If lExistCPO .AND. ExistBlock("verCFRemSim")
		If U_verCFRemSim()
			If ExistBlock("classifNFe")
				U_classifNFe()
			EndIf
		Else
			MsgAlert("A nota [" + SF1->F1_DOC + "/" + SF1->F1_SERIE + "] não tem CFOP de Remessa Simbólica [" + cCFOP + "].")
		EndIf
	EndIf
	
	RestArea( aAreaSD1 )
	RestArea( aAreaSF1 )
	RestArea( aAreaAtu )

Return
