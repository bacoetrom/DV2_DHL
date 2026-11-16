#include 'totvs.ch'
#include 'dhl.ch'

#define FROM_PARTNERNAME 	"PROTHEUS"
#define TO_PARTNERNAME 		"SAP"

/*/{Protheus.doc} DHLIp160
Classe auxiliar para a interface IP160 herdada da classe IP150
@type class
@author Gustavo Luiz
@since 18/05/2017
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
Class DHLIp160	From DHLIp150
	
	data oSql
	data oUtils
	data oFile
	data cDocSCJ
	data cSerieSCJ
	
	Method NewDHLIp160() CONSTRUCTOR
	
	Method GetDocSCJ()
	Method SetDocSCJ()
	
	Method GetSerieSCJ()
	Method SetSerieSCJ()
	
	Method IsRCOVinculado(cNfRet, cSerieRet)
	Method ValidStatusCanc(cNf, cSerie)
	Method MountTags()
	Method GetFolder()
	Method GetFileName(cReference)
	Method WriteFile()
	Method DefineDocSerSCJ(cTipo, cDocProtheus, cSerieProtheus)
	
ENDCLASS

/*/{Protheus.doc} DHLIp160
Método Construtor

@author Gustavo Luiz
@since 18/05/2017
@version 1.0
@example
(examples)
/*/
Method NewDHLIp160() CLASS DHLIp160
	
	::NewDHLIp150()
	
	::oSql 		:= ipSqlObject():newIpSqlObject()
	::oUtils	:= IpUtilsObject():newIpUtilsObject()
	::oFile     := IpFileObject():newIpFileObject()
	::cDocSCJ	:= ""
	::cSerieSCJ := ""
	
Return

/*/{Protheus.doc} GetDocSCJ
Obtém o doc SCJ gravado na SZA 

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetDocSCJ() Class DHLIp160

return ::cDocSCJ

/*/{Protheus.doc} SetDocSCJ
Define o doc SCJ gravado na SZA 

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetDocSCJ(cDocSCJ) Class DHLIp160
	::cDocSCJ := cDocSCJ
return

/*/{Protheus.doc} GetSerieSCJ
Obtém a série SCJ gravado na SZA 

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetSerieSCJ() Class DHLIp160

return ::cSerieSCJ

/*/{Protheus.doc} SetSerieSCJ
Define a série SCJ gravado na SZA 

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetSerieSCJ(cSerieSCJ) Class DHLIp160
	::cSerieSCJ := cSerieSCJ
return

/*/{Protheus.doc} MountTags
Monta as tags do XML

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method MountTags() Class DHLIp160
	
	local cXMLFile := ""
	
	cXmlFile := '<?xml version="1.0" encoding="UTF-8"?>'                                   + CRLF
	cXmlFile += '<SAPIP160>'                                                               + CRLF
	cXmlFile += '	<HEADER>'                                                              + CRLF
	cXmlFile += '		<DATETIME DATETIMEQUALIFIER="on">' + getDateTime() + '</DATETIME>' + CRLF
	cXmlFile += '		<FROM>'                                                            + CRLF
	cXmlFile += '			<PARTNERNAME>' + FROM_PARTNERNAME + '</PARTNERNAME>'           + CRLF
	cXmlFile += '		</FROM>'                                                           + CRLF
	cXmlFile += '		<TO>'                                                              + CRLF
	cXmlFile += '			<PARTNERNAME>' + TO_PARTNERNAME + '</PARTNERNAME>'             + CRLF
	cXmlFile += '		</TO>'                                                             + CRLF
	cXmlFile += '	</HEADER>'                                                             + CRLF
	cXmlFile += '	<BODY>'                                                                + CRLF
	cXmlFile += '		<FILEHEADER>'                                                      + CRLF
	cXmlFile += '			<KEY_RCO>' + ::GetKeyRCO() + 			'</KEY_RCO>'           + CRLF
	cXmlFile += '			<KEY_RET>' + ::GetKeyRET() + 			'</KEY_RET>'       	   + CRLF
	cXmlFile += '			<DATE>' + TransfDateToXML(dDataBase) +  '</DATE>'              + CRLF
	cXmlFile += '		</FILEHEADER>'                                                     + CRLF
	cXmlFile += '	</BODY>'                                                               + CRLF
	cXmlFile += '</SAPIP160>'                                                              + CRLF
	
return cXmlFile

/*/{Protheus.doc} getFolder
Retorna o diretório de arquivos SAP

@author Gustavo Luiz
@since 21/05/2017
@version 1.0
@example
(examples)
/*/
Method GetFolder() Class DHLIp160
return AllTrim(::oSql:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '" + APP_SAP + "'"))

/*/{Protheus.doc} getFileName
Retorna o nome do arquivo xml da interface IP160

@author Gustavo Luiz
@since 21/05/2017
@version 1.0
@example
(examples)
/*/
Method getFileName(cReference) Class DHLIp160
	
	local cFolder   := ::getFolder()
	local cFileName := ::oUtils:concatDirectory(cFolder,"SAPIP160"+cReference+".XML")
	
	::oFile:setFile(cFileName)
	
	if ::oFile:exists()
		::oFile:delete()
	endif
	
return cFileName


/*/{Protheus.doc} WriteFile
Gera o xml no local especificado

@author Gustavo Luiz
@since 21/05/2017
@version 1.0
@example
(examples)
/*/
Method WriteFile(cXmlFile) Class DHLIp160
	
	local lStatus := .F.
	
	lStatus := ::oFile:writeLine(cXmlFile)
	
return lStatus

/*/{Protheus.doc} IsRCOVinculado
Verifica se existe RCO vinculado ao RET

@author Gustavo Luiz
@since 21/05/2017
@version 1.0
@example
(examples)
/*/
Method IsRCOVinculado(cNfRet, cSerieRet) Class DHLIp160
	
	local cNfRCO 	:= ""
	local cSerieRCO	:= ""
	local nRecnoRCO	:= 0
	local lRCOVinc  := .F.
	
	::GetAreas()
	
	::oSql:newTable("SZA", "ZA_NFRCO, ZA_SERIRCO", "%SZA.XFILIAL% AND ZA_NFRET = '" + cNfRet  + "' AND ZA_SERIRET = '" + cSerieRet + "'")
	
	if ::oSql:hasRecords()
		
		cNfRCO		:= ::oSql:GetValue("ZA_NFRCO")
		cSerieRCO	:= ::oSql:GetValue("ZA_SERIRCO")
		
		::SetNfRetSimb(cNfRet)
		::SetSerRetSimb(cSerieRet)
		
		if !empty(cNfRCO) .and. !empty(cSerieRCO)
		
			::SetNfRCO(cNfRCO)
			::SetSerRCO(cSerieRCO)
			lRCOVinc := .T.
		
		endIf
		
	endIf
	
	::oSql:Close()
	
	::RestAreas()
	
Return lRCOVinc

/*/{Protheus.doc} ValidStatusCanc
Valida o status de cancelamento da nota RCO no sefaz

@author Gustavo Luiz
@since 21/05/2017
@version 1.0
@example
(examples)
/*/
Method ValidStatusCanc(cNf, cSerie) Class DHLIp160
	
	local cDataCancelamento := ""
	local lValidCanc		:= .F.
	local nRecno			:= 0
	::GetAreas()
	
	::oSql:newTable("SF3",;
		"F3_DTCANC, F3_CHVNFE, R_E_C_N_O_",;
		"%SF3.XFILIAL% AND F3_NFISCAL = '" + cNf  + "' AND F3_SERIE = '" + cSerie + "' AND F3_DTCANC != ' '")
	
	if ::oSql:hasRecords()
		
		cDataCancelamento		:= ::oSql:GetValue("F3_DTCANC")
		::cKeyRCO				:= ::oSql:GetValue("F3_CHVNFE")
		nRecno					:= ::oSql:GetValue("R_E_C_N_O_")
		lValidCanc 				:= .T.
		
	endIf
	
	::oSql:Close()
	
	::RestAreas()
	
return lValidCanc

/*/{Protheus.doc} DefineDocSerSCJ
Define o documento e série (SCJ) gravado na tabela SZA 

@author Gustavo Luiz
@since 21/05/2017
@version 1.0
@example
(examples)
/*/
Method DefineDocSerSCJ(cTipo, cDocProtheus, cSerieProtheus) Class DHLIp160

	local cCampoDoc := ""
	local cCampoSeri:= ""
	
	if cTipo == REMESSA_CONTA_ORDEM
		cCampoDoc := "ZA_NFRCO"
		cCampoSeri:= "ZA_SERIRCO"
	else
		cCampoDoc := "ZA_NFRET"
		cCampoSeri:= "ZA_SERIRET"
	endIf
	
	
	::oSql:newTable("SZA",;
		"ZA_DOCSCJ, ZA_SERISCJ",;
		"%SZA.XFILIAL% AND "+cCampoDoc+" = '" + cDocProtheus  + "' AND "+cCampoSeri+" = '" + cSerieProtheus + "'")
		
	if ::oSql:hasRecords()
	
		::cDocSCJ 	:= allTrim(::oSql:GetValue("ZA_DOCSCJ"))
		::cSerieSCJ := allTrim(::oSql:GetValue("ZA_SERISCJ"))
	
	else
		::SetError(.T.)
		::SetMsgError("Documento/Série da nota SCJ não localizado.")
	endIf
		
	::oSql:Close()
	
return

/**
* Retorna a string com a data formatada AAAA-MM-DD
**/
static function TransfDateToXML(dData)
	
	local cAno		:= ""
	local cMes		:= ""
	local cDia		:= ""
	local cNewDate  := ""
	
	If !Empty(dTos(dData))
		cNewDate	:= dTos(dData)
		cAno	    := Substr(cNewDate,1,4)
		cMes		:= Substr(cNewDate,5,2)
		dia			:= Substr(cNewDate,7,2)
		cNewDate:= cAno + cMes + dia
	EndIf
	
return cNewDate

/**
* Retorna a string com o Datetime
**/
static function getDateTime()
	
	local cDateTime := Dtos(Date())
	local cYear     := Substr(cDateTime,1,4)
	local cMonth    := Substr(cDateTime,5,2)
	local cDay      := Substr(cDateTime,7,2)
	local cHour     := "T00:00:00"
	
	cDateTime := cYear + "-" + cMonth + "-" + cDay + cHour
	
return AllTrim(cDateTime)
