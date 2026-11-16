#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} SAPIP160

Rotina responsável em gerar a interface SAP IP 160.
Processo para a Unidade de Negócio AG2(SCJ - PUZZLE)

@author Gustavo Luiz
@since 17/05/2017
/*/
User Function SAPIP160(oDHLIp150)
	
	local oDHLIp160 := nil
	
	oDHLIp160:= DHLIp160():NewDHLIp160()
	oDHLIp160:DefineDocSerSCJ(oDHLIp150:GetTipoNf(), oDHLIp150:GetNfRetSimb(), oDHLIp150:GetSerRetSimb())
	oDHLIp160:SetKeyRET(oDHLIp150:GetKeyRET())
					
	if oDHLIp160:IsRCOVinculado(oDHLIp150:GetNfRetSimb(), oDHLIp150:GetSerRetSimb())
		if !oDHLIp160:ValidStatusCanc(oDHLIp160:GetNfRCO(), oDHLIp160:GetSerRCO())
			oDHLIp160:SetError(.T.)
		endIf
	endIf
					
	if !oDHLIp160:HasError()
		cXmlFile := oDHLIp160:MountTags()
		cReference  := "_" + oDHLIp160:GetDocSCJ()+ "_" + oDHLIp160:GetSerieSCJ()
		cFileName   := oDHLIp160:getFileName(cReference)
		oDHLIp160:WriteFile(cXmlFIle)
	endIf

Return

