#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} ValidTaxes
Processamento de Validação de Impostos

@type User Function
@author Thiago Meschiatti
@since 06/04/2016
@version 1.0
/*/
User Function ValidTaxes()
	local aArea		:= GetArea()
	local aAreaSD1	:= SD1->(GetArea())
	local cApp		:= ""
	local lRetTax	:= .t.
	local nI		:= 0
	local oTax		:= nil
	local oSql		:= IpSqlObject():newIpSqlObject()
	local oLog 		:= DHLLogManager():newDHLLogManager()
	local lJob		:= GetRemoteType() == -1
	
	if vldTaxes()
		oTax := DHLTaxes():newDHLTaxes()
		if lJob
			cApp := retApp()
			oLog:start(cApp, DHL_IMPORTACAO, )
		endif	
		
		SD1->(dbSetOrder(1))
		for nI := 1 to len(aCols)
			if !gdDeleted(nI,,aCols)
				SD1->(dbSeek(xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) + gdFieldGet("D1_COD", nI) + gdFieldGet("D1_ITEM", nI)))
				oTax:validTaxes(nI)
			endif
		next nI
	
		lRetTax := oTax:hasError()
		if lRetTax
			if (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_MUL)
				oTax:updStatus()
			endif
			oTax:setMsgError()
			if lJob
				oLog:fail("ASN Confirmation", retDadosNF() + oTax:getMsgError())
			else
				if isInCallStack("u_NfSelScr")
					Aviso( "Não foi possível Classificar a NF", retDadosNF() + oTax:getMsgError(), { "OK" }, 3, )
					//Help('',1,'Não foi possível Classificar a NF',,retDadosNF() + oTax:getMsgError(),1,0,.f.)
				else
					Aviso( "Não foi possível Classificar a NF", oTax:getMsgError(), { "OK" }, 3, )
				endif
			endif
		else
			oLog:success()
		endif
		
		RestArea(aAreaSD1)
		RestArea(aArea)
	else
		lRetTax := .f.
	endif

Return (!lRetTax)


/*
** Retorna a Aplicação de acordo com a filial logada
*/
static function retApp()
	local cRet := ""
	
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_MUL)
		cRet := APP_NULOGY
	else
		cRet := APP_DLX
	endif
	
return (cRet)


/*
** Organiza informação para inserir no log
*/ 
static function retDadosNF()
	local cRet := ""
	
	cRet += "Filial: " + alltrim(SF1->F1_FILIAL) + CRLF
	cRet += "NF: " + alltrim(SF1->F1_DOC)
	cRet += " Série: " + alltrim(SF1->F1_SERIE) + CRLF
	
return (cRet)


/*
** Verifica se NF deverá ser validada
*/
static function vldTaxes()
	local lRet 		:= .f.
	local aAreaSD1	:= SD1->(GetArea())
	
	if SD1->(dbSeek(xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)))
		if SD1->D1_ZZTOTAL > 0
			lRet := .t.
		endif
	endif
	
	RestArea(aAreaSD1)
	
return (lRet)