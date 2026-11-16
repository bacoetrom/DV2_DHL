#Include 'Protheus.ch'
#Include 'dhl.ch'

#define DOC_BENEFICIAMENTO "B"
#define POS_FORNECEDOR 1
#define POS_LOJA 2
#define POS_TIPO 3

/*/{Protheus.doc} MulAltNf

Altera o cliente / loja da pré nota
	
@author Renato Castro
@since 24/10/2014

/*/
User Function MulAltNf()

	local oDHLLibrary 	:= DHLLibrary():newDHLLibrary()
	local aCodLoja 		:= {}

	if validaDoc()
		aCodLoja := oDHLLibrary:showChangeCliFor()
		if !Empty(aCodLoja)
			gravaFor(aCodLoja)
		endif
	endif

Return


/**
 * Valida se a pré nota pode ser alterada
 */
static function validaDoc()
	
	local lRetorno := .T.
	local oSql := IpSqlObject():newIpSqlObject()

	if SF1->F1_TIPO <> DOC_BENEFICIAMENTO
		lRetorno := .F.
	endif
	 
	if lRetorno
		if oSql:exists("SD1", "D1_FILIAL='"+SF1->F1_FILIAL+"' AND D1_DOC='"+SF1->F1_DOC+"' AND D1_SERIE='"+SF1->F1_SERIE+"' AND D1_FORNECE='"+SF1->F1_FORNECE+"' AND D1_LOJA='"+SF1->F1_LOJA+"' AND D1_TES <> '' ")
			lRetorno := .F.
		endif
	endif
	
	if !lRetorno
		MsgAlert("Este documento não pode ser alterado ! Verifique se ele é do tipo BENEFICIAMENTO e se já foi classificado.")
		return
	endif

return(lRetorno)


/**
 * Altera o fornecedor e loja da pré nota
 */
static function gravaFor(aCodLoja)

	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cWhere    := "D1_FILIAL='"+SF1->F1_FILIAL+"' AND D1_DOC='"+SF1->F1_DOC+"' AND D1_SERIE='"+SF1->F1_SERIE+"' AND D1_FORNECE='"+SF1->F1_FORNECE+"' AND D1_LOJA='"+SF1->F1_LOJA+"' "
	local cTipo 	:= ""
	
	if aCodLoja[POS_TIPO]=='cliente'
		cTipo := 'B'
	else
		cTipo := 'N'
	endif
	
	oSql:update("SD1","D1_FORNECE = '"+aCodLoja[POS_FORNECEDOR]+"' ,D1_LOJA = '"+aCodLoja[POS_LOJA]+"', D1_TIPO = '"+cTipo+"' ",cWhere)

	RecLock("SF1",.F.)
	SF1->F1_FORNECE := aCodLoja[POS_FORNECEDOR]
	SF1->F1_LOJA 	:= aCodLoja[POS_LOJA]
	SF1->F1_TIPO 	:= cTipo
	SF1->F1_ZZSTATU := ""	
	SF1->(MsUnLock())
	
	MsgAlert("Fornecedor alterado com sucesso.")
	
return