#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} SAPIP150

Rotina responsável por ler e processar a interface SAP IP 150 e realizar o cancelamento das notas fiscais envolvidas no faturamento.
Processo para a Unidade de Negócio AG2(SCJ - PUZZLE)

@author Gustavo Luiz
@since 17/05/2017
/*/
User Function SAPIP150(cFilePath)
	
	local cKey			:= ""
	private oDHLIp150 	:= LoadDadosXML()
	
	cKey := oDHLIp150:GetKeySAP()
	
	oDHLIp150:SetFilePath(cFilePath)
	
	if oDHLIp150:ExistKey(cKey)
		oDHLIp150:DefinRecRCO()
		oDHLIp150:DefinRecRET()
		
		if oDHLIp150:ExistRCO()
			if oDHLIp150:ChecStatusFIMP(oDHLIp150:GetRecnoRCO(), REMESSA_CONTA_ORDEM)				
				if oDHLIp150:ChecStatusFIMP(oDHLIp150:GetRecnoRET(), RETORNO_SIMBOLICO)
					oDHLIp150:SendCancellation(oDHLIp150:GetRecnoRCO())
				endIf				
			endIf
		else
			if oDHLIp150:ChecStatusFIMP(oDHLIp150:GetRecnoRET(), RETORNO_SIMBOLICO)
				oDHLIp150:SendCancellation(oDHLIp150:GetRecnoRET())
			endIf
		endIf		
	endIf
	
Return oDHLIp150:HasError()

/**
* Carrega os dados do XML
**/
static function LoadDadosXML()
	
	local oDHLIp150 := DHLIp150():NewDHLIp150()
	
	oDHLIp150:SetFromPartner(oXml:_SAPIP150:_HEADER:_FROM:_PARTNERNAME:TEXT)
	oDHLIp150:SetToPartner(oXml:_SAPIP150:_HEADER:_TO:_PARTNERNAME:TEXT)
	oDHLIp150:SetSiteCNPJ(oXml:_SAPIP150:_BODY:_FILEHEADER:_SITE_CNPJ:TEXT)
	oDHLIp150:SetKeySAP(oXml:_SAPIP150:_BODY:_FILEHEADER:_KEY:TEXT)
	oDHLIp150:SetDate(oDHLIp150:FormatDate(oXml:_SAPIP150:_BODY:_FILEHEADER:_DATE:TEXT))
	
return oDHLIp150

