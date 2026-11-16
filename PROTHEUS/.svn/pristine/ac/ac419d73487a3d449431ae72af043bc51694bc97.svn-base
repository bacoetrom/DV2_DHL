#Include 'Protheus.ch'


/*/{Protheus.doc} DHL089CD

Este ponto de entrada é utilizado para complementar as regras de validação do TES Inteligente.
	
@author Thiago Meschiatti
@since 24/11/2014

/*/
User Function DHL089CD()
	//As variaveis foram carregada com paramixb somente para verificar o condeudo original.
	local bCond 	:=	PARAMIXB[1] //Condicao que avalia os campos do SFM
	local bSort 	:=	PARAMIXB[2] //Forma de ordenacao do array onde o 1o elemento sera utilizado. Esse array inicialmente possui 9 posicoes
	local bIRWhile	:=	PARAMIXB[3] //Regra de selecao dos registros do SFM
	local bAddTes 	:=	PARAMIXB[4] //Conteudo a ser acrescentado no array
	local cTabela	:=	PARAMIXB[5] //Tabela que esta sendo tratada
	
	if (cTabela $ "SD2")  // Necessario verificar se cTabela vazia devido as vendas do Loja e Front Loja
		cCfop	:= SA1->A1_TIPO
		bCond	:= {||( cCfop == (cAliasSFM)->FM_ZZCFOP .Or. Empty((cAliasSFM)->FM_ZZTPCLI) ) } //Acrescenta compo novo a regra, esse campo devera ser acrescentdo no X2_UNICO do SFM.
		bSort	:= {|x,y| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[10]+x[11] > y[1]+y[2]+y[3]+y[4]+y[5]+y[6]+y[7]+y[10]+y[11]}//Altero a ordem do array, posicao 10, para considerar o campo especifico acrescentado na linha abaixo
		bIRWhile:= {||.T.}
		bAddTes	:= {||aAdd(aTes[Len(aTes)],(cAliasSFM)->FM_ZZTPCLI ) }//Acrescento campo a ser considerado na TES Inteligente.
	elseif cTabela $ "SD1" .or. isinCallStack("u_DHLMaTes")
		cCfop	:= if(type("aInfProd") == "A", aInfProd[9], SD1->D1_ZZCFOP)
				bCond	:= {||((alltrim(cCfop)==alltrim((cAliasSFM)->FM_ZZCFOP)) .OR. EMPTY((cAliasSFM)->FM_ZZCFOP))  } //Acrescenta compo novo a regra, esse campo devera ser acrescentdo no X2_UNICO do SFM.
		bSort	:= {|x,y| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[10]+x[11] > y[1]+y[2]+y[3]+y[4]+y[5]+y[6]+y[7]+y[10]+y[11]}//Altero a ordem do array, posicao 10, para considerar o campo especifico acrescentado na linha abaixo
		bIRWhile:= {||.T.}
		bAddTes	:= {||aAdd(aTes[Len(aTes)],alltrim((cAliasSFM)->FM_ZZCFOP ))	 }//Acrescento campo a ser considerado na TES Inteligente.
	else
		bCond	:= {||.T.}
		bSort	:= bSort
		bIRWhile:= {||.T.}
		bAddTes	:= {||.T.}
	endif
	
Return({bCond,bSort,bIRWhile,bAddTes,,cCfop})

