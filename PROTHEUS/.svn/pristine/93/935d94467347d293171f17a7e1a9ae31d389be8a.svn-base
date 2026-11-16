#Include "Protheus.ch"

#Define		CAMPO_CFOP_XML		"D1_ZZCFOP"

/*/{Protheus.doc} verCFRemSim
Rotina que verifica se a CFOP pertence a Remessa Simbolica

@type		Function
@author 	Julio Lisboa
@since 		25/08/2016
@return 	lRet, Retorna .T. caso a CFOP pertencer a Remessa Simbolica
/*/
User Function verCFRemSim( cDoc, cSerie, cFornec, cLoja )
	
	Local lRet			:= .T.
	Local lExistCPO		:= SD1->(FieldPos(CAMPO_CFOP_XML)) > 0
	
	Local aAreaSD1		:= SD1->(GetArea())
	
	Local cChave		:= ""
	Local cCFOP			:= GetNewPar( "ZZ_CFREMSI" , "5934" )
	
	Default cDoc		:= SF1->F1_DOC
	Default cSerie		:= SF1->F1_SERIE
	Default cFornec		:= SF1->F1_FORNECE
	Default cLoja		:= SF1->F1_LOJA
	
	SD1->(DbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	If SD1->(DbSeek( xFilial("SD1") + cDoc + cSerie + cFornec + cLoja )) .AND. lExistCPO
		cChave	:= cDoc + cSerie + cFornec + cLoja
	
		While SD1->(!Eof()) .AND. SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == xFilial("SD1") + cChave .AND. lRet
			
			//Verifica se o CFOP não está contido no parametro de Remessa simbólica
			If !( AllTrim( SD1->&( CAMPO_CFOP_XML )) $ cCFOP)
				lRet	:= .F.
			EndIf
			
			SD1->(DbSkip())
		EndDo
	Else
		lRet	:= .F.
	EndIf
	
	RestArea( aAreaSD1 )
	
Return lRet
