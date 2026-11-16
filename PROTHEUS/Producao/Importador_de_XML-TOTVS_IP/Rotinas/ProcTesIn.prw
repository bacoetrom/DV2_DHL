#Include 'Protheus.ch'


/*/{Protheus.doc} ProcTesIn

Processa transferência de conteudo de campo D1_ZZTES para D1_TES
	
@author Thiago Meschiatti
@since 25/11/2014

@param cAliasSD1, caracter, Alias SD1
/*/
User Function ProcTesIn(cAliasSD1)

	local cTes := (cAliasSD1)->D1_ZZTES

	GdFieldPut("D1_TES", cTes, len(aCols))	

Return