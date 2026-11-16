#Include 'Protheus.ch'


/*/{Protheus.doc} ProcDtFabric

Processa transferência de conteudo de campo D1_ZZDFABR para D1_DFABRIC
	
@author Thiago Meschiatti
@since 23/05/2016

@param cAliasSD1, caracter, Alias SD1
/*/
User Function ProcDtFabric(cAliasSD1)

	local dDtFabric := (cAliasSD1)->D1_ZZDFABR

	GdFieldPut("D1_DFABRIC", dDtFabric, len(aCols))	

Return