#Include "Protheus.ch"

/*/{Protheus.doc} classifNFe
Rotina que classifica a NF

@type		Function
@author 	Julio Lisboa
@since 		25/08/2016
@return 	nil, nulo
/*/
User Function classifNFe()

	Local aAreaSD1		:= SD1->(GetArea())

	Local aCabec		:= {}
	Local aItens		:= {}
	Local aLinha		:= {}
	
	Local cChave		:= ""

	Local cDoc			:= SF1->F1_DOC
	Local cSerie		:= SF1->F1_SERIE
	Local cFornec		:= SF1->F1_FORNECE
	Local cLoja			:= SF1->F1_LOJA
	
	Private lMsErroAuto	:= .F.
	
	If FunName() == "MATA140"
	
		SD1->(DbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		If SD1->(DbSeek( xFilial("SD1") + cDoc + cSerie + cFornec + cLoja ))
			aAdd(aCabec,	{"F1_TIPO",		SF1->F1_TIPO })
			aAdd(aCabec,	{"F1_DOC",		SF1->F1_DOC })
			aAdd(aCabec,	{"F1_SERIE",	SF1->F1_SERIE })
			aAdd(aCabec,	{"F1_EMISSAO",	SF1->F1_EMISSAO })
			aAdd(aCabec,	{"F1_FORNECE",	SF1->F1_FORNECE })
			aAdd(aCabec,	{"F1_LOJA",		SF1->F1_LOJA })
			aAdd(aCabec,	{"F1_ESPECIE",	SF1->F1_ESPECIE })

			cChave	:= cDoc + cSerie + cFornec + cLoja
	
			While SD1->(!Eof()) .AND. SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == xFilial("SD1") + cChave
				aLinha := {}
				aadd(aLinha,{"D1_ITEM",		SD1->D1_ITEM,		nil})
				aadd(aLinha,{"D1_COD",		SD1->D1_COD,		nil})
				aadd(aLinha,{"D1_QUANT",	SD1->D1_QUANT,		nil})
				aadd(aLinha,{"D1_VUNIT",	SD1->D1_VUNIT,		nil})
				aadd(aLinha,{"D1_TOTAL",	SD1->D1_TOTAL,		nil})
				aadd(aLinha,{"D1_TES",		SD1->D1_ZZTES,		nil})
				aadd(aItens,aLinha)
			
				SD1->(DbSkip())
			EndDo

			BEGIN TRANSACTION
			
			If RecLock( "SF1" ,.F.)
				SF1->F1_ZZSTATU	:= ""
			EndIf			
			
			MSExecAuto({ |x,y,z| MATA103(x,y,z) },aCabec,aItens,4)
			
			If !lMsErroAuto
				MsgAlert("Nota [" + SF1->F1_DOC + "/" + SF1->F1_SERIE + "] classificada com sucesso !",ProcName())
			Else
				DisarmTransaction()
				MostraErro()
			EndIf
			
			END TRANSACTION
		EndIf
	EndIf
	
	RestArea( aAreaSD1 )

Return
