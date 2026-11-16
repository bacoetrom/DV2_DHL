#Include 'Protheus.ch'
#Include 'dhl.ch'

#define CNPJ_CLIENTE 1
#define COD_CLIENTE	 2
#define PRODUTOS	"SB1"

/*/{Protheus.doc} SAPIP210

Rotina responsável por ler e processar a interface SAP IP 210 e realizar a atualização dos dados da pré nota recebida da Devolução/Recusa
Processo para a Unidade de Negócio AG2(SCJ - PUZZLE)

@author Gustavo Luiz
@since 17/05/2017
/*/
User Function SAPIP210(cFilePath)
	
	private oDHLIp210 	:= LoadDadosXML(cFilePath)
	
	if !empty(oDHLIp210:GetCusCNPJRetRCO()) .and. !oDHLIp210:hasError()
		oDHLIp210:SetCNPJCustomer(oDHLIp210:GetCusCNPJRetRCO(), CNPJ_CLIENTE)
	elseIf !oDHLIp210:hasError()
		oDHLIp210:SetCNPJCustomer(oDHLIp210:GetCusCdRetRCO(), COD_CLIENTE)
	endIf
	
	begin transaction
		if !oDHLIp210:hasError()
			oDHLIp210:CheckClientes()
			oDHLIp210:PosicDocEntrad(oDHLIp210:GetNfRetRCO(), oDHLIp210:GetSerieRetRCO(), oDHLIp210:GetCNPJCustomer())
			if !oDHLIp210:hasError()
				oDHLIp210:AtualizInfDoc()
				if !oDHLIp210:hasError()
					if !oDHLIp210:IsRecusa(SF1->(recno()))
						oDHLIp210:GerPedidoVend()
						if !oDHLIp210:hasError()
							oDHLIp210:FaturarPedido()
						endIf
					endIf
				endIf
			endIf
		endIf
	end transaction
	
Return oDHLIp210:HasError()

/**
* Carrega os dados do XML
**/
static function LoadDadosXML(cFilePath)
	
	local oDHLIp210 := DHLIp210():NewDHLIp210()
	local aItens	:= {}
	local nI		:= 0
	
	oDHLIP210:SetApp(APP_SAP)
	oDHLIP210:SetMensagemLog("Falha ao importar arquivo IP_SAP_210")	
	oDHLIp210:SetLog(oLog)
	oDHLIp210:SetFilePath(cFilePath)
	oDHLIp210:SetFromPartner(oXml:_IP_210:_HEADER:_FROM:_PARTNERNAME:TEXT)
	oDHLIp210:SetToPartner(oXml:_IP_210:_HEADER:_TO:_PARTNERNAME:TEXT)
	oDHLIp210:SetSiteCNPJ(oXml:_IP_210:_BODY:_FILEHEADER:_SITE_CNPJ:TEXT)
	oDHLIp210:SetNfDev(oXml:_IP_210:_BODY:_FILEHEADER:_NF_DEV:TEXT)
	oDHLIp210:SetSerDev(oXml:_IP_210:_BODY:_FILEHEADER:_SERIE_DEV:TEXT)
	oDHLIp210:SetKeyDev(oXml:_IP_210:_BODY:_FILEHEADER:_KEY_DEV:TEXT)
	oDHLIp210:SetCustCodDev(oXml:_IP_210:_BODY:_FILEHEADER:_CUSTOMER_CODE_DEV:TEXT)
	oDHLIp210:SetCustCNPJDev(oXml:_IP_210:_BODY:_FILEHEADER:_CUSTOMER_CNPJ_DEV:TEXT)
	oDHLIp210:SetDtDev(oXml:_IP_210:_BODY:_FILEHEADER:_DATE_DEV:TEXT)
	oDHLIp210:SetNfRetRCO(oXml:_IP_210:_BODY:_FILEHEADER:_NF_RET_RCO:TEXT)
	
	if !oDHLIp210:HasError()
	
		oDHLIp210:SetSerieRetRCO(oXml:_IP_210:_BODY:_FILEHEADER:_SERIE_RET_RCO:TEXT)
		
		if !oDHLIp210:HasError()
		
			oDHLIp210:SetKeyRetRCO(oXml:_IP_210:_BODY:_FILEHEADER:_KEY_RET_RCO:TEXT)
			oDHLIp210:SetCusCdRetRCO(oXml:_IP_210:_BODY:_FILEHEADER:_CUTOMER_CODE_RET_RCO:TEXT)
			oDHLIp210:SetCusCNPJRetRCO(oXml:_IP_210:_BODY:_FILEHEADER:_CUSTOMER_CNPJ_RET_RCO:TEXT)
			oDHLIp210:SetDateRetRCO(oXml:_IP_210:_BODY:_FILEHEADER:_DATE_RET_RCO:TEXT)
	
	//PARA QUANDO TIVER SOMENTE 1 ITEM
			if type("oXml:_IP_210:_BODY:_FILEITEM") == "O"
	
				aAdd(aItens, {oXml:_IP_210:_BODY:_FILEITEM:_ITEM:TEXT,  ;			//1
				val(oXml:_IP_210:_BODY:_FILEITEM:_QUANTITY:TEXT), 		;			//2
				oXml:_IP_210:_BODY:_FILEITEM:_NF_REF_RCO:TEXT,		;			//3
				oXml:_IP_210:_BODY:_FILEITEM:_SERIE_REF_RCO:TEXT,	;			//4
				oXml:_IP_210:_BODY:_FILEITEM:_ITEM_REF_RCO:TEXT,	;			//5
				oXml:_IP_210:_BODY:_FILEITEM:_KEY_REF_RCO:TEXT})				//6
			
			else
		
				for nI := 1 to len(oXml:_IP_210:_BODY:_FILEITEM)
					aAdd(aItens, {oXml:_IP_210:_BODY:_FILEITEM[nI]:_ITEM:TEXT,  ;	//1
					val(oXml:_IP_210:_BODY:_FILEITEM[nI]:_QUANTITY:TEXT), 	;	//2
					oXml:_IP_210:_BODY:_FILEITEM[nI]:_NF_REF_RCO:TEXT,		;	//3
					oXml:_IP_210:_BODY:_FILEITEM[nI]:_SERIE_REF_RCO:TEXT,	;	//4
					oXml:_IP_210:_BODY:_FILEITEM[nI]:_ITEM_REF_RCO:TEXT,	;	//5
					oXml:_IP_210:_BODY:_FILEITEM[nI]:_KEY_REF_RCO:TEXT})		//6
				next nI
		
			endIf
	
			oDHLIp210:SetFileItem(aItens)
			oDHLIp210:CheckGroupTrib(PRODUTOS)
	
		endIf
	endIf
	
return oDHLIp210



