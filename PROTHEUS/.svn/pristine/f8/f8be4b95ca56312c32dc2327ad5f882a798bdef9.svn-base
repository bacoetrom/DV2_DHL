#include 'protheus.ch'

/*/{Protheus.doc} SetIcmsToNfRet

Atualiza a alíquota e o valor do ICMS das notas fiscais de retorno efetivo para atender 
o regime especial do estado do AM.

@author Diogo Mesquita
@since 14/05/2020
@version undefined
@type function
@return undefined
/*/
user function SetIcmsToNfRet( cPE, nBaseICMS, nAliqICMS, nValICMS )
	
	local cIcmFilRE  := SuperGetMv("ZZ_ICMFIRE",,"")
	local cIcmCliRE  := SuperGetMv("ZZ_ICMCLRE",,"")
	local cIcmTesRE  := SuperGetMv("ZZ_ICMTERE",,"")
	local nIcmAliqRE := SuperGetMv("ZZ_ICMALRE",,nAliqICMS)
	local nPosTES    := 0
	local cTES       := ""
	local nI         := 0
	local lCalcIcms  := .f.
			
	if AllTrim(cFilAnt) $ cIcmFilRE
		if AllTrim(SC5->(C5_CLIENTE + C5_LOJACLI)) $ cIcmCliRE
			
			if cPE == "M410ICM"
				if INCLUI .or. ALTERA
					nPosTES := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
					for nI:= 1 to len(aCols)
						cTES := AllTrim(aCols[nI ,nPosTES])
						if cTES $ cIcmTesRE
							lCalcIcms := .t.
							exit
						endIf
					next nI
				else
					setCalcIcms(@lCalcIcms, cIcmTesRE)
				endIf
			else
				setCalcIcms(@lCalcIcms, cIcmTesRE)
			endIf
						
			if lCalcIcms
				//nAliqICMS := AliqIcms( SC5->C5_TIPO, 'S', SC5->C5_TIPOCLI )
				nAliqICMS := nIcmAliqRE
				nValICMS := Round( nBaseICMS * ( nAliqICMS / 100 ), TamSX3("D2_VALICM")[2] )
			endIf
		endIf
	endIf
	
return

/**
* Percorre os itens do pedido de venda e verifica se existe uma TES para cálculo do ICMS.
**/
static function setCalcIcms(lCalcIcms, cIcmTesRE)
	
	local cTES       := ""
	local aAreaSC6   := SC6->(GetArea())
	
	SC6->(dbSetOrder(1))
	SC6->(dbSeek( xFilial("SC6") + SC5->C5_NUM ))
	While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == SC5->C5_NUM
		cTES := AllTrim(SC6->C6_TES)
		if cTES $ cIcmTesRE
			lCalcIcms := .t.
			exit
		endIf
		SC6->(dbSkip())
	Enddo
	RestArea(aAreaSC6)

return


