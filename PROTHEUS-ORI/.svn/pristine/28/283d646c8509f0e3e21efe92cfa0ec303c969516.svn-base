#include 'protheus.ch'
#include 'dhl.ch'


/*/{Protheus.doc} GrvInfNfEnt
Grava informações da NF saída referente a crédito de ICMS.
Grava campo F1_ZZAUTO quando a NF for manual. 

@author Thiago Meschiatti
@since 03/06/2016
@version undefined

@type function
/*/
user function GrvInfNfEnt()
	local oSqlSD2	:= IpSqlObject():newIpSqlObject()
	local oSqlSD1	:= IpSqlObject():newIpSqlObject()
	local oContrAut	:= DhlDisControl():newDhlDisControl(DHL_NFE_INVOICE_INFLOW)
	local cDocRef	:= ""
	local cSerRef	:= ""
	local cCliRef	:= ""
	local cLojRef	:= ""
	local cTes		:= ""

	oSqlSD1:newTable("SD1", "D1_DOC, D1_SERIE, D1_NFORI, D1_SERIORI, D1_ITEMORI, D1_FORNECE, D1_LOJA", retQrySD1())
	
	while oSqlSD1:notIsEof()
		oSqlSD2:newAlias(retQrySD2(oSqlSD1))
		
		if oSqlSD2:hasRecords()
		
			cTes := oSqlSD2:getValue("D1_TES")
		
			if empty(cDocRef) .and. oContrAut:hasGeneration(cTes)
				cDocRef	:= oSqlSD1:getValue("D1_DOC")
				cSerRef	:= oSqlSD1:getValue("D1_SERIE")
				cCliRef := oSqlSD1:getValue("D1_FORNECE")
				cLojRef := oSqlSD1:getValue("D1_LOJA")
			endif
		endif
		oSqlSD2:close()
		oSqlSD1:skip()
	end
	
	oSqlSD1:close()
	
	if !empty(cDocRef) .and. !empty(cSerRef)
		oContrAut:updAuto(cDocRef, cSerRef)
	endif
	
return


/*
** Where para tabela SD1
*/
static function retQrySD1()
	local cQuery := ""
	
	cQuery += "%SD1.XFILIAL% AND D1_DOC = '"+SF1->F1_DOC+"' AND D1_SERIE = '"+SF1->F1_SERIE+"' AND D1_FORNECE = '"+SF1->F1_FORNECE+"'"
	cQuery += " AND D1_LOJA = '"+SF1->F1_LOJA+"'"
	
return (cQuery)


/*
** Where para tabela SD2
*/
static function retQrySD2(oSqlSD1)
	local cQuery := ""
	local cDoc	 := oSqlSD1:getValue("D1_NFORI")
	local cSerie := oSqlSD1:getValue("D1_SERIORI")
	local cItem	 := oSqlSD1:getValue("D1_ITEMORI")
	
	cQuery += " SELECT D1_TES "
	cQuery += " FROM %SD2.SQLNAME% "
	cQuery += " INNER JOIN %SD1.SQLNAME% ON "
	cQuery += " 		D1_FILIAL 		= D2_FILIAL "
	cQuery += " 	AND D1_DOC 			= D2_ZZNFAUT "
	cQuery += " 	AND D1_SERIE 		= D2_ZZSEAUT "
	cQuery += " 	AND D1_ITEM 		= D2_ZZITAUT "
	cQuery += " 	AND %SD1.NOTDEL% "
	cQuery += " WHERE "
	cQuery += " %SD2.XFILIAL% AND %SD2.NOTDEL% AND D2_DOC = '"+cDoc+"' AND D2_SERIE = '"+cSerie+"' AND D2_ITEM = '"+cItem+"'" "
	
return (cQuery)