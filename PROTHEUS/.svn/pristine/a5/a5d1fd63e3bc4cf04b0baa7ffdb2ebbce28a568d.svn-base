#include 'totvs.ch'
#include 'dhl.ch'

/*/{Protheus.doc} copiaLinhaPV
Rotina responsável por copiar a linha do pedido de venda. A mesma é chamada através de gatilho no campo personalizado C6_ZZCOPY.

@author Diogo Mesquita
@since 20/10/2017
@version 1.0
/*/
User Function copiaLinhaPV()

	local aArea	:= SX7->(GetArea())
	local nItem	:= GdFieldPos("C6_ITEM",aHeader)
	local nCopy	:= GdFieldPos("C6_ZZCOPY",aHeader)
	local cItem	:= "" 
	local nY	:= 0
	
	if (M->C6_ZZCOPY == "S")
	
		cItem := Soma1(aCols[len(aCols),nItem])
	
		Aadd(aCols,Array(len(aHeader)+1)) 
		aCols[len(aCols), len(aHeader)+1] := .F.
			
		for nY := 1 to len(aCols[n])
			if nY == nItem
				aCols[len(aCols),nY] := cItem 
			elseif nY == nCopy
				aCols[len(aCols),nY] := Space(Len(aCols[n][nCopy]))
			else
				aCols[len(aCols),nY] := aCols[n,nY]
			endif
		next nY
		
	endif
	
	RestArea(aArea)

Return (space(TamSx3("C6_ZZCOPY")[1]))
