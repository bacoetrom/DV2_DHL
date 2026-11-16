#Include 'Protheus.ch'
#Include 'dhl.ch'

#define TRANSP_CNPJ		1
#define TRANSP_NOME		2
#define TRANSP_INSCR_EST	3
#define TRANSP_ENDERECO	4
#define TRANSP_MUNICIPIO	5
#define TRANSP_ESTADO		6
#define TRANSP_EMAIL		7


/*/{Protheus.doc} Ag2NfCarrier
Realiza tratamento para adequação de dados da trasnportadora da NF RCO
@type function
@author Thiago Meschiatti
@since 23/08/2017
@version 1.0
@param aProd, array, Array de produtos da NFe
@param aInfoItem, array, Arrai de informaçoes dos itens da NFe
@param aNota, array, Array de informacoes da NFe
@param aTransp, array, Array de informacoes da transportadora
/*/
User Function Ag2NfCarrier(aProd, aInfoItem, aNota, aTransp)
	Local cTipo := aNota[04]
	
	If (cTipo == DHL_NFE_INVOICE_OUTFLOW)
		If (SF2->F2_ZZTPNF == REMESSA_CONTA_ORDEM)
			If Len(aTransp) > 0
				updEndCarrier(@aTransp)
			EndIf
		EndIf
	EndIf

Return

/*
** Atualiza dados do array da transportadora da NFe
*/
Static Function updEndCarrier(aTransp)
	Local oSql 	:= IpSqlObject():newIpSqlObject()
	Local cEnd	:= "" 
	Local cBairro	:= ""
	
	oSql:newTable("SA4", "A4_BAIRRO", "%SA4.XFILIAL% AND A4_CGC = '" + aTransp[TRANSP_CNPJ] + "'")
	
	If oSql:hasRecords()
		cEnd 	:= AllTrim(aTransp[TRANSP_ENDERECO]) + ", "
		cBairro	:= AllTrim(oSql:getValue("A4_BAIRRO"))
		
		aTransp[TRANSP_ENDERECO] := SubStr(cEnd + cBairro, 1, 60)
	EndIf
	
	oSql:close()
Return