#include 'protheus.ch'
#include 'dhl.ch'

#define LOTE	 	19
#define INF_ADIC 	25

/*/{Protheus.doc} InfMedPrd
Inclusão de informacao de lote nos dados adicionais do produto.
@author TOTVS IP
@since 28/06/2023
@version 1.0
@type function
/*/
user function InfLotePrd(aProd, aInfoItem, aNota)
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cSeries	:= aNota[01]
	local cDoc		:= aNota[02]
	local cTipo		:= aNota[04]
	local cTipoNF	:= aNota[05]
	local cInfLotNew:= AllTrim(GetNewPar("ZZ_CLLTNEW", ""))
	local lInfLotNew:= GetMv("ZZ_CLLTNEW", .t.)
	local cMsgMed	:= ""
	local nI        := 0

	if cTipo == DHL_NFE_INVOICE_OUTFLOW

		If lInfLotNew
			If Alltrim(SF2->F2_CLIENTE) $ Alltrim(cInfLotNew) .OR. cInfLotNew == "*"
				for nI := 1 to len(aProd)
					if !empty(aProd[nI, LOTE])
						cMsgMed := ""
						oSql:newTable("F0A", "*", retQrySD2(cDoc, cSeries, aInfoItem[nI, 4]))

						if oSql:hasRecords()
							cMsgMed += "Lote: " + alltrim(oSql:getValue("F0A_LOTE")) + " "
							cMsgMed += "Qtd.: " + alltrim(str(oSql:getValue("F0A_QTDLOT"))) + " "
							cMsgMed += "Dt. Valid.: " + dtoc(stod(oSql:getValue("F0A_VALID"))) + " "
							cMsgMed += "Dt. Fabric.: " + dtoc(stod(oSql:getValue("F0A_FABRIC"))) + " "
						endif


						if empty(aProd[nI,INF_ADIC])
							aProd[nI,INF_ADIC] := cMsgMed
						else
							aProd[nI,INF_ADIC] += " / " + cMsgMed
						endif
						oSql:close()
					endif
				next nI
			EndIf
		EndIf

	endif
return

/*
** Where para tabela SD2
*/
static function retQrySD2(cDoc, cSeries, cItem)
	local cQuery := ""

	cQuery += "%F0A.XFILIAL% AND F0A_TPMOV = 'S' AND F0A_DOC = '" + cDoc + "' AND F0A_SERIE = '" + cSeries + "'"
	cQuery += " AND F0A_ITEM = '" + cItem + "' "

return (cQuery)
