#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} VincCobert

Grava vínculo da NF de cobertura
	
@author Renato Castro
@since 06/11/2014

@param xParam, TipoParam, DescricaoDoParam

@return TipoRet DescricaoRet
/*/
user function VincCobert()

	if AllTrim(SD1->D1_ZZCFOP) $ getMV("ZZ_CFCOB")
		If cFilAnt <> AG2_SCJ 
			gravaVinculo()
		Else			
			grvVincSCJ()
		EndIf
	endif

return

/**
 * Grava vínculo da NF de cobertura, tabela SZ4
 */
static function gravaVinculo()

	local oSql	:= IpSqlObject():newIpSqlObject()
	local cWhere := "Z4_FILIAL='"+SD1->D1_FILIAL+"' AND Z4_DOC='"+SD1->D1_DOC+;
			"' AND Z4_SERIE='"+SD1->D1_SERIE+"' AND Z4_CLIFOR='"+SD1->D1_FORNECE+;
			"' AND Z4_LOJA='"+SD1->D1_LOJA+"' AND Z4_PRODUTO='"+SD1->D1_COD+;
			"' AND Z4_ITEM='"+SD1->D1_ITEM+"' "

	if oSql:exists("SZ4", cWhere)
		oSql:update("SZ4","Z4_QUANT = "+cValtoChar(SD1->D1_QUANT)+", Z4_IDENT = '"+SD1->D1_NUMSEQ+"', Z4_SALDO = "+cValtoChar(SD1->D1_QUANT)+" ",cWhere)
	else
		RecLock("SZ4",.T.)
		SZ4->Z4_FILIAL 	:= xFilial("SZ4")
		SZ4->Z4_DOC 	:= SD1->D1_DOC
		SZ4->Z4_SERIE 	:= SD1->D1_SERIE
		SZ4->Z4_CLIFOR 	:= SD1->D1_FORNECE
		SZ4->Z4_LOJA 	:= SD1->D1_LOJA
		SZ4->Z4_PRODUTO	:= SD1->D1_COD
		SZ4->Z4_QUANT	:= SD1->D1_QUANT
		SZ4->Z4_TIPMOV	:= "1"
		SZ4->Z4_IDENT	:= SD1->D1_NUMSEQ
		SZ4->Z4_SALDO	:= SD1->D1_QUANT
		SZ4->Z4_IDCOB	:= SZ4->(GetSXENum("SZ4","Z4_IDCOB"))
		SZ4->Z4_ITEM	:= SD1->D1_ITEM
		SZ4->(MsUnlock())
		SZ4->(ConfirmSx8())
	endif

return

/**
 * Grava vínculo da NF de cobertura, tabela SZ4, específico para filial AG2 SCJ 
 */
static function grvVincSCJ()

	local oSql	:= IpSqlObject():newIpSqlObject()
	local cWhere := "Z4_FILIAL='"+SD1->D1_FILIAL+"' AND Z4_DOC='"+SD1->D1_DOC+;
			"' AND Z4_SERIE='"+SD1->D1_SERIE+"' AND Z4_CLIFOR='"+SD1->D1_FORNECE+;
			"' AND Z4_LOJA='"+SD1->D1_LOJA+"' AND Z4_ITEM='"+SD1->D1_ITEM+"' "
	
	if oSql:exists("SZ4", cWhere)
		oSql:update("SZ4","Z4_QUANT = "+cValtoChar(SD1->D1_QUANT)+", Z4_IDENT = '"+SD1->D1_NUMSEQ+"', Z4_SALDO = "+cValtoChar(SD1->D1_QUANT)+", Z4_PRODUTO = '"+SD1->D1_COD+"' ",cWhere)
	else
		RecLock("SZ4",.T.)
		SZ4->Z4_FILIAL 	:= xFilial("SZ4")
		SZ4->Z4_DOC 	:= SD1->D1_DOC
		SZ4->Z4_SERIE 	:= SD1->D1_SERIE
		SZ4->Z4_CLIFOR 	:= SD1->D1_FORNECE
		SZ4->Z4_LOJA 	:= SD1->D1_LOJA
		SZ4->Z4_PRODUTO	:= SD1->D1_COD
		SZ4->Z4_QUANT	:= SD1->D1_QUANT
		SZ4->Z4_TIPMOV	:= "1"
		SZ4->Z4_IDENT	:= SD1->D1_NUMSEQ
		SZ4->Z4_SALDO	:= SD1->D1_QUANT
		SZ4->Z4_IDCOB	:= getNewIdCob()
		SZ4->Z4_ITEM	:= SD1->D1_ITEM
		SZ4->(MsUnlock())
		SZ4->(ConfirmSx8())
	endif

return

/**
 * Obtém o próximo IDCOB, tabela SZ4, específico para filial AG2 SCJ 
 */
Static Function getNewIdCob()
	
	Local aArea		:= SZ4->(GetArea())
	Local cNewId	:= STRZERO(0,TamSx3("Z4_IDCOB")[1])
	Local cQry		:= ""

	cQry := " SELECT"+chr(13)+chr(10)
	cQry += " MAX(Z4_IDCOB) IDCOB"+chr(13)+chr(10)
	cQry += " FROM "+RetSQlName("SZ4")+ " SZ4 "+chr(13)+chr(10)
	cQry += " WHERE Z4_FILIAL = '"+cFilAnt+"'"+chr(13)+chr(10)
	cQry += " AND SZ4.D_E_L_E_T_ <> '*' "

	cQry := ChangeQuery(cQry)

	If Select("SZ4IDCOB") > 0
		SZ4IDCOB->(DbCloseArea())
	Endif
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry), "SZ4IDCOB", .T., .F.)
	
	If Empty(SZ4IDCOB->IDCOB)
		cNewId := Soma1(cNewId)
	Else
		cNewId := Soma1(SZ4IDCOB->IDCOB)
	EndIf
	SZ4IDCOB->(DbCloseArea())
			
	SZ4->(RestArea(aArea))

Return cNewId
