#Include 'Protheus.ch'
#include "dhl.ch"

/*/{Protheus.doc} GWItemMaint
Rotina responsável em disponibilizar as interfaces Item Maintenance para 
integração das informações de Itens entre os sistemas ERP Protheus e DLX {Filial DHL_BUSINESSUNIT_AGL}
	
@author iVan Oliveira - TotvsIP
@since 17/05/2021
/*/
User Function AglItemMaint()
	
	private cXmlFile	:= ""
	private oDHLItMain 	:= DHLAgeItemMaint():New()		

	Processa({|| MountTags()})
	oDHLItMain:SaveFile(cXmlFile)	
	
Return

/**
* Gera os dados dos campos SB1 em formato XML
**/
Static Function MountTags()

	_cProdFor := oDHLItMain:GetItem()
	_cPlantID := AllTrim(GetAdvFVal("SB1","B1_ZZPLANT", FwxFilial("SB1") + _cProdFor ,1," ")) 
	
	cXmlFile := '<?xml version="1.0" encoding="UTF-8"?>'									    + CRLF
	cXmlFile += '<ITEM_MAINT>'                                  							    + CRLF
	cXmlFile += '	<HEADER>'                                   							    + CRLF
	cXmlFile += '	<DATETIME DATETIMEQUALIFIER="on">' +oDHLItMain:GetDataTime()+ '</DATETIME>'	+ CRLF
	cXmlFile += '	<FROM>'                                   								    + CRLF
	cXmlFile += '		<PARTNERNAME>'+oDHLItMain:GetPartNmFrom()+'</PARTNERNAME>'    	        + CRLF
	cXmlFile += '	</FROM>'                                   								    + CRLF
	cXmlFile += '	<TO>'                                   								    + CRLF
	cXmlFile += '		<PARTNERNAME>'+oDHLItMain:GetPartNmTo()+'</PARTNERNAME>'                + CRLF
	cXmlFile += '	</TO>'                                   								    + CRLF
	cXmlFile += '	</HEADER>'                                  							    + CRLF
	cXmlFile += '	<BODY>'                                   								    + CRLF
	cXmlFile += '		<FILEHEADER>'                           							    + CRLF
	cXmlFile += '			<SITE_CNPJ>'+oDHLItMain:GetCnpjFilial()+'</SITE_CNPJ>'       		+ CRLF
	cXmlFile += '			<ITEM>'+ _cProdFor +'</ITEM>'                 			    		+ CRLF
	cXmlFile += '			<DESCRIPTION>'+oDHLItMain:GetDescription()+'</DESCRIPTION>'   	    + CRLF
	cXmlFile += '			<TYPE>'+oDHLItMain:GetType()+'</TYPE>'                 			    + CRLF
	cXmlFile += '			<UOM>'+oDHLItMain:GetUom()+'</UOM>'                   			    + CRLF
	cXmlFile += '			<WAREHOUSE>'+oDHLItMain:GetWareHouse()+'</WAREHOUSE>'       		+ CRLF
	cXmlFile += '			<LOT_CONTROL>'+oDHLItMain:GetLotControl()+'</LOT_CONTROL>'   		+ CRLF
	cXmlFile += '			<PLANT_ID>'+_cPlantID+'</PLANT_ID>'   								+ CRLF
	cXmlFile += '		</FILEHEADER>'                          							    + CRLF
	cXmlFile += '	</BODY>'                                   								    + CRLF
	cXmlFile += '</ITEM_MAINT>'                                 							    + CRLF                                            		
		
Return



