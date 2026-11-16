#Include 'Protheus.ch'

#define DHL_CAMPO 		1
#define DHL_CONTEUDO	2

/*/{Protheus.doc} ProcDesNF

Processa o desmembramento dos itens da NF por quantidade.
	
@author Thiago Meschiatti
@since 31/10/2014

@param aItens, array, Array de itens da pre-nota de entrada.

@return array Array de itens com manipulações efetuadas.
/*/
User Function ProcDesNF(aItens,lPv)
	local aRet		:= {}	
	local nI		:= 0
	local nPosQtd	:= 0 	
	local nQuant	:= 0
	
	default lPv 	:= .F.
	
	for nI := 1 to len(aItens)
		if lPv
			nPosQtd	:= aScan(aItens[nI],{|x| alltrim(x[DHL_CAMPO]) == "C6_QTDVEN"})
		else
			nPosQtd	:= aScan(aItens[nI],{|x| alltrim(x[DHL_CAMPO]) == "D1_QUANT"})
		endif
		nQuant	:= aItens[nI, nPosQtd, DHL_CONTEUDO]	
		if nQuant > 1
			aRet := geraItens(aItens[nI], aRet, nPosQtd, nQuant, lPv)
		else
			aadd(aRet, aClone(aItens[nI]))  
		endif
				
	next nI 
	
	aRet := ajustaItens(aRet, lPv)

Return (aRet)


/*
** Gera itens 
*/
static function geraItens(aItem, aRet, nPosQtd, nQuant, lPv)
	local nJ		:= 0
	local nVlrUnit	:= 0
	local nPosTotal	:= 0
	local nPosVUnit	:= 0
	
	default lPv 	:= .F.
	
	if lPv
		nPosVUnit	:= aScan(aIteM,{|x| alltrim(x[1]) == "C6_PRCVEN"})
	else
		nPosTotal	:= aScan(aIteM,{|x| alltrim(x[1]) == "D1_TOTAL"})
		nPosVUnit	:= aScan(aIteM,{|x| alltrim(x[1]) == "D1_VUNIT"})
	endif

	nVlrUnit := aItem[nPosVUnit, DHL_CONTEUDO]
	
	aItem[nPosQtd, DHL_CONTEUDO] := 1	
	if !lPv
		aItem[nPosTotal, DHL_CONTEUDO] := nVlrUnit
	endif
	
	for nJ := 1 to nQuant
		aadd(aRet, aClone(aItem))
	next nJ
	
return (aRet)


/*
** Ajusta campo de itens do array da rotina 
*/
static function ajustaItens(aItens, lPv)
	local nI		:= 0
	local nPosItem	:= 0
	local cItem		:= 0
	
	default lPv 	:= .F.
	
	if lPv
		cItem := soma1(strzero(nI,TamSX3("C6_ITEM")[1]))
	else
		cItem := soma1(strzero(nI,TamSX3("D1_ITEM")[1]))
	endif
	
	for nI := 1 to len(aItens)
		if lPv
			nPosItem := aScan(aItens[nI],{|x| alltrim(x[DHL_CAMPO]) == "C6_ITEM"})	
		else
			nPosItem := aScan(aItens[nI],{|x| alltrim(x[DHL_CAMPO]) == "D1_ITEM"})
		endif
		aItens[nI, nPosItem, DHL_CONTEUDO] := cItem
		
		if lPv
			cItem := soma1(strzero(nI,TamSX3("C6_ITEM")[1]))
		else
			cItem := soma1(strzero(nI,TamSX3("D1_ITEM")[1]))
		endif 
	next nI
	
return (aItens)