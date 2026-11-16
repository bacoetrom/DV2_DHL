#Include 'Protheus.ch'
#Include 'dhl.ch'

#define DOC_BENEFICIAMENTO "B"
#define POS_FORNECEDOR 1
#define POS_LOJA 2
#define POS_TIPO 3

/*/{Protheus.doc} AglAltNf

Altera o cliente / loja da pré nota
	
@author Alberto Diorio
@since 18/02/2020

/*/
User Function AglAltNf()

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
	
	lRetorno := IsDocOk()


	if (SF1->F1_TIPO != DOC_BENEFICIAMENTO) .and. (SF1->F1_ESPECIE != DHL_ESPECIE_INVENTARIO)
		lRetorno := .F.
	endif
	 
//	if lRetorno
//		if oSql:exists("SD1", "D1_FILIAL='"+SF1->F1_FILIAL+"' AND D1_DOC='"+SF1->F1_DOC+"' AND D1_SERIE='"+SF1->F1_SERIE+"' AND D1_FORNECE='"+SF1->F1_FORNECE+"' AND D1_LOJA='"+SF1->F1_LOJA+"' AND D1_TES <> '' ")
//			lRetorno := .F.
//		endif
//	endif
	
	if !lRetorno
		MsgAlert("Este documento não pode ser alterado!")
		return
	endif
	
return(lRetorno)

Static Function IsDocOk()

	local oSql	  	  	:= IpSqlObject():newIpSqlObject()
	local lIsRegistro 	:= .F.
	local cQuery 		:= ""
	
	cQuery := " SELECT "
	cQuery += " 	F1_DOC "	
	cQuery += " FROM "
	cQuery += " 	%SF1.SQLNAME% "
	cQuery += " INNER JOIN %SD1.SQLNAME% ON	"
	cQuery += " 	D1_DOC=F1_DOC AND "
    cQuery += " 	D1_SERIE=F1_SERIE AND "
    cQuery += " 	D1_FORNECE=F1_FORNECE AND "
    cQuery += " 	D1_LOJA=F1_LOJA AND "
    cQuery += " 	D1_TIPO=F1_TIPO "	
	cQuery += " WHERE "
	cQuery += " 	F1_FILIAL = '%SF1.FILIAL%' AND "
	cQuery += " 	D1_FILIAL = '%SD1.FILIAL%' AND "
	cQuery += " 	D1_TES = ' ' AND "
	cQuery += " 	F1_TIPO = 'B' AND "
	cQuery += " 	F1_DOC='"+SF1->F1_DOC+"' AND "
	cQuery += " 	%SD1.NOTDEL% AND"
	cQuery += " 	%SF1.NOTDEL% "
	
	oSql:newAlias(changeQuery(cQuery))
	lIsRegistro := oSql:hasRecords()
	oSql:Close()
	
Return lIsRegistro


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