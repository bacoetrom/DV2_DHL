#Include 'Protheus.ch'
#include "dhl.ch"

/*/{Protheus.doc} GWItemMaint
Rotina responsável em disponibilizar as interfaces Item Maintenance para 
integração das informações de Itens entre os sistemas ERP Protheus e DLX
	
@author Gustavo Luiz 
@since 18/08/2016
/*/
User Function AgeItemMaint()
	
	private cXmlFile	:= ""
	private oDHLItMain 	:= DHLAgeItemMaint():New()		

	Processa({|| MountTags()})
	oDHLItMain:SaveFile(cXmlFile)	
	
Return

/**
* Gera os dados dos campos SB1 em formato XML
**/
Static Function MountTags()
	
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
	cXmlFile += '			<ITEM>'+oDHLItMain:GetItem()+'</ITEM>'                 			    + CRLF
	cXmlFile += '			<DESCRIPTION>'+oDHLItMain:GetDescription()+'</DESCRIPTION>'   	    + CRLF
	cXmlFile += '			<TYPE>'+oDHLItMain:GetType()+'</TYPE>'                 			    + CRLF
	cXmlFile += '			<UOM>'+oDHLItMain:GetUom()+'</UOM>'                   			    + CRLF
	cXmlFile += '			<WAREHOUSE>'+oDHLItMain:GetWareHouse()+'</WAREHOUSE>'       		+ CRLF
	cXmlFile += '			<LOT_CONTROL>'+oDHLItMain:GetLotControl()+'</LOT_CONTROL>'   		+ CRLF
	cXmlFile += '		</FILEHEADER>'                          							    + CRLF
	cXmlFile += '	</BODY>'                                   								    + CRLF
	cXmlFile += '</ITEM_MAINT>'                                 							    + CRLF                                            		
		
Return

