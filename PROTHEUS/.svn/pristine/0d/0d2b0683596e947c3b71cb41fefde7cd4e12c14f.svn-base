#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} SAPIP200

Rotina responsável em gerar a interface SAP IP 200
Processo para a Unidade de Negócio AG2(SCJ - PUZZLE)

@author Gustavo Luiz
@since 09/08/2017
/*/
User Function SAPIP200(nRecno, cProtocolo, cProcessDate)
	
	local aArea 	:= getArea()
	local aAreaSF2 	:= SF2->(getArea())
	local aAreaSD2	:= SD2->(getArea())
	local oDHLIp200	:= nil
	local lStatus	:= .F.
	default cProcessDate := ""
	
	SF2->(dbGoTo(nRecno))
	
	if SF2->F2_ZZTPNF == AJUSTE_FISCAL
		
		oDHLIp200 := loadDados(cProtocolo, nRecno, cProcessDate)
		lStatus   := oDHLIp200:geraIP200()	
		
	endIf
	
	restArea(aAreaSD2)
	restArea(aAreaSF2)
	restArea(aArea)
	
Return lStatus

/**
* Carrega os dados
**/
static function loadDados(cProtocolo, nRecno, cProcessDate)
	
	local oDHLIP200 	:= DHLIP200():NewDHLIP200()
	local aItens		:= {}
	local oSQL			:= IpSqlObject():newIpSqlObject()
	local cQuery		:= ""
	local cItem			:= ""
	local cLinhaItem	:= ""
	local nQuantidade	:= 0
	local cUM			:= ""
	local cPlantId		:= ""
	local cUnitPrice  := ""
	local cCfop       := ""
	local cProtocol   := ""
	local cRandomNum  := ""
	local cCheckDigit := ""
	local nValorLiq	  := 0		
	
	oDHLIP200:setDateTime(formatDate(dDataBase))
	oDHLIP200:SetFromPartner("PROTHEUS")
	oDHLIP200:SetToPartner("SAP")
	oDHLIP200:SetSiteCNPJ(SM0->M0_CGC)
	oDHLIP200:SetNfNumber(SF2->F2_DOC)
	oDHLIP200:SetNfSerie(SF2->F2_SERIE)
	oDHLIP200:SetNfProtoc(cProtocolo)
	oDHLIP200:SetNfDate(SF2->F2_EMISSAO)
	oDHLIP200:setProcessDate(StrTran(Substr(cProcessDate,1 ,at(" ",cProcessDate)-1),"-", ""))
	oDHLIP200:setRandomNumb(SubStr(allTrim(SF2->F2_CHVNFE), 36, 8))
	oDHLIP200:setCheckDigit(Right(allTrim(SF2->F2_CHVNFE), 1))
		
	cQuery := getQueryNFSaida(nRecno)
	
	oSQL:newAlias(cQuery)
	
	if oSQL:hasRecords()
		while oSQL:notIsEof()
		
			cItem 		:= allTrim(oSQL:getValue("D2_COD"))
			cLinhaItem 	:= allTrim(oSQL:getValue("D2_ITEM"))
			nQuantidade	:= cValToChar(oSQL:getValue("D2_QUANT"))
			cUM			:= allTrim(oSQL:getValue("D2_UM"))
			cPlantId 	:= allTrim(getPlantID(oSQL:getValue("F2_CLIENTE"),  oSQL:getValue("F2_LOJA")))
			
			nValorLiq 	:= calcVlrLiq(oSQL)
			
			cUnitPrice	:= allTrim(str(nValorLiq))
			cCfop       := allTrim(oSQL:getValue("D2_CF"))
			
			aAdd(aItens, {cItem, cLinhaItem, nQuantidade, cUM, cPlantId, cUnitPrice, cCfop})
			
			oSQL:skip()
			
		endDo
	endIf
	
	oDHLIP200:SetFileItem(aItens)
	
return oDHLIP200

/**
* formata a data para o formato YYYY-MM-DDT00:00:00
**/
static function formatDate(dDataBase)
	
	local cData			:= dTos(dDataBase)
	local cDia			:= substr(cData, 7, 2)
	local cMes			:= substr(cData, 5, 2)
	local cAno			:= substr(cData, 1, 4)
	local cDataFormat	:= cAno + "-" + cMes + "-" + cDia + "T00:00:00"
	
return cDataFormat

/*
** Obtém a query do documento de saída
*/
static function getQueryNFSaida(nRecno)
	
	local cQuery := ""
	
	cQuery := "	SELECT "														+ CRLF
	cQuery += "		SD2.D2_ITEM , SD2.D2_COD, SD2.D2_QUANT, SD2.D2_DOC,"		+ CRLF
	cQuery += "		SD2.D2_SERIE , SD2.D2_LOCAL, SD2.D2_UM, SD2.D2_PICM,"		+ CRLF
	cQuery += "		SF2.R_E_C_N_O_ SF2_RECNO,  SD2.R_E_C_N_O_ SD2_RECNO, "		+ CRLF
	cQuery += "		SD2.D2_NFORI, SD2.D2_SERIORI, SD2.D2_ITEMORI,  "			+ CRLF
	cQuery += "		SD2.D2_CF, TRUNC(SD2.D2_PRCVEN,2) D2_PRCVEN,  "				+ CRLF
	cQuery += "		SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_CHVNFE  "				+ CRLF
	cQuery += "	FROM %SF2.SQLNAME% " 											+ CRLF
	cQuery += "	INNER JOIN %SD2.SQLNAME% ON 1 = 1" 								+ CRLF
	cQuery += "		AND SD2.D2_FILIAL = SF2.F2_FILIAL" 							+ CRLF
	cQuery += "		AND D2_DOC = F2_DOC" 										+ CRLF
	cQuery += "		AND D2_SERIE = F2_SERIE" 									+ CRLF
	cQuery += "		AND D2_CLIENTE = F2_CLIENTE" 								+ CRLF
	cQuery += "		AND %SD2.NOTDEL%"           								+ CRLF
	cQuery += "	WHERE 1 = 1" 													+ CRLF
	cQuery += "		AND SF2.F2_FILIAL = '%SF2.FILIAL%' " 						+ CRLF
	cQuery += "		AND %SF2.NOTDEL%"           								+ CRLF
	cQuery += "		AND SF2.R_E_C_N_O_ = "+cValToChar(nRecno)					+ CRLF
	cQuery += "	ORDER BY D2_ITEM"												+ CRLF

return cQuery

/*
** Obtém o PLANT_ID
*/
static function getPlantID(cCliente, cLoja) 
	
	local cPlantId	:= ""
	
	SA1->(dbSetOrder(1))
	if SA1->(dbSeek(FwxFilial("SA1") + cCliente + cLoja))	
		cPlantId := SA1->A1_ZZPLANT
	endIf
	
return cPlantId

/*
** Calcula o valor líquido
*/
static function calcVlrLiq(oSql)
	
	local nVlrUnitBrut := oSQL:getValue("D2_PRCVEN")
	local nPercICM	   := oSQL:getValue("D2_PICM")
	local nVlrIcm	   := NoRound (nVlrUnitBrut * nPercICM / 100, 2)
	local nVlrUnitLiq  := nVlrUnitBrut -  nVlrIcm
	
return nVlrUnitLiq

