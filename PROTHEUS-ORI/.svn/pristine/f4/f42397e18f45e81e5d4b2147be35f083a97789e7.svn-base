#include 'protheus.ch'
#include 'dhl.ch'

/*/{Protheus.doc} VldLote
Validação de Lote
@author Thiago Meschiatti
@since 29/07/2016
@version undefined

@type function
/*/
user function VldLote()
	local oSql		:= IpSqlObject():newIpSqlObject()
	local oLog 		:= DHLLogManager():newDHLLogManager()
	local lAuto		:= GetRemoteType() == -1
	local lRet 		:= .t.
	local aArea		:= GetArea()
	local aAreaSB1	:= SB1->(GetArea())
	local cCliForDoc:= ""
	local cLojDoc	:= ""
	local cMsg		:= ""
	
	for nI := 1 to len(aCols)
		if !gdDeleted(nI,,aCols)
			if oSql:getFieldValue("SB1", "B1_RASTRO", " %SB1.XFILIAL% AND B1_COD = '" + gdFieldGet("D1_COD", nI) + "' ") == "L"
				if empty(gdFieldGet("D1_LOTECTL", nI))
					lRet := .f.
					cMsg := "Produto " + alltrim(gdFieldGet("D1_COD", nI)) + " como controla Lote e "+;
							"NF: " + alltrim(cNFiscal) + " Serie: " + alltrim(cSerie) + " sem informação de Lote. Verifique!"
					if lAuto
						oLog:start(APP_IMPORTADOR_XML, DHL_IMPORTACAO, )
						oLog:fail("Falha ao importar arquivo", cMsg)
					else
						Aviso("ATENÇÃO!",cMsg,{"OK"})
					endif
				endif
			endif
		endif
	next nI
	
	RestArea(aAreaSB1)
	RestArea(aArea)
	
return (lRet)