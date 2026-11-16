#INCLUDE "TOTVS.CH"
#INCLUDE "TopConn.CH"


/*/{Protheus.doc} CT105QRY

O ponto de entrada CT105QRY e utilizado para manipulacao da string de query de contabilizacao do fonte CTBA105.
Utilizado para casos onde o usuario quer adicionar algum campo na aglutinacao. 
	
@author Thiago Meschiatti
@since 03/02/2015

@param ParamIxb[1], caracter, Query original.
@param ParamIxb[2], logico, Controle de aglutinacao dos dados

@return TipoRet DescricaoRet
/*/
User Function CT105QRY()

	Local cRet 		:= ParamIxb[1]		
	Local lAglutin	:= ParamIxb[2]		
	Local cAux		:= ""
	
	If lAglutin
		
		If At("GROUP BY", cRet) > 0
			cAux	:= "MIN"
		Else
			cAux	:= ""
		EndIf      
		
		// Insere nome do campo a ser transportado para o CT2.
		cRet := Stuff(cRet, At("FROM", cRet), 0, ", " + cAux + "(CTK_ZZHIST) CTK_ZZHIST")
		
		// Insere o nome do campo a ser considerado na aglutinacao.
		If !Empty(cAux)
			cRet := Stuff(cRet, At("ORDER BY", cRet), 0, ", CTK_ZZHIST ")
		EndIf
		
	EndIf

Return(cRet)