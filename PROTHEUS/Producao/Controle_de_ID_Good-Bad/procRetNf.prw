#Include 'Protheus.ch'


/*/{Protheus.doc} procRetNf

Processa retorno da NF incluindo Ids na NF de entrada

@author Thiago Meschiatti
@since 14/11/2014

@param aItens, array, Itens da nf
/*/
User Function procRetNf(aItens, cAliasTmp)
	local cId	:= ""
	
	default := {}
	
	if empty(aItens)
		cId := (cAliasTmp)->D1_ZZID
		gdFieldPut("C6_ZZID", cId,  len(aCols))		
	else
		cId := (cAliasTmp)->D2_ZZID
		aadd(aItens, {"D1_ZZID", cId, NIL})
	endif
	
Return aClone(aItens)

