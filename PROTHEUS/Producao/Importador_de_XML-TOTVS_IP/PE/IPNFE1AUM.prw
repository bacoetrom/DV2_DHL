#include 'totvs.ch'

/*/{Protheus.doc} IPNFE1AUM
Ponto de entrada para tratar o valor das variáveis nPriQtd e nPriVlr conforme necessidade.
@author Diogo Mesquita
@since 17/06/2019
@version 1.0
@return Array, Retorna array contendo o valor das variáveis nPriQtd e nPriVlr

@type function
/*/
User Function IPNFE1AUM()
	local nPriQtd		:= PARAMIXB[1]
	local nPriVlr		:= PARAMIXB[2]
	local aDet			:= PARAMIXB[3]
	local lNewAge       := SuperGetMV("ZZ_NEWAGE",,.F.)
	local lAutomatic    := SuperGetMV("ZZ_AUTOMAT",,.F.)
	local aRet			:= {nPriQtd,nPriVlr}
	
	If lNewAge .And. lAutomatic                                                                    
		aRet[1] := iif(SB1->B1_TIPCONV == "M", aDet[6] / SB1->B1_CONV,aDet[6] * SB1->B1_CONV)
		aRet[2]	:= iif(SB1->B1_TIPCONV == "M", aDet[7] * SB1->B1_CONV,aDet[7] / SB1->B1_CONV)
	EndIf

Return aRet

