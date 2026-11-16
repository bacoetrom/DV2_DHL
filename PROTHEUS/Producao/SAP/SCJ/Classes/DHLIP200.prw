#include 'totvs.ch'
#include 'dhl.ch'

#Define ITEM 			1
#Define LINHAITEM 	2
#Define QUANTIDADE	3
#Define UM			4
#Define PLANTID 		5
#Define UNITPRICE		6
#Define CFOP       	7


/*/{Protheus.doc} DHLIp200
Classe auxiliar para a interface DHLIp200
@type class
@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
CLASS DHLIP200
	
	data cDateTime
	data cFromPartner
	data cToPartner
	data cSiteCNPJ
	data cNfNumber
	data cNfSerie
	data cNfProtoc
	data cNfDate
	data cProcessDate	
	data cRandomNumb  	
	data cCheckDigit 	
	data aFileItem
	data oFile     	
	
	Method GetDateTime()
	Method SetDateTime(cDateTime)
	
	Method GetFromPartner()
	Method SetFromPartner(cFromPartner)
	
	Method GetToPartner()
	Method SetToPartner(cToPartner)
	
	Method GetSiteCNPJ()
	Method SetSiteCNPJ(cSiteCNPJ)
	
	Method GetNfNumber()
	Method SetNfNumber(cNfNumber)
	
	Method GetNfSerie()
	Method SetNfSerie(cNfSerie)
	
	Method GetNfProtoc()
	Method SetNfProtoc(cNfProtoc)
	
	Method GetNfDate()
	Method SetNfDate(dNfDate)
	
	Method getProcessDate()
	Method setProcessDate(cProcessDate)
	
	Method getRandomNumb()
	Method setRandomNumb(cRandomNumb)
	
	Method getCheckDigit()
	Method setCheckDigit(cCheckDigit)
	
	Method GetFileItem()
	Method SetFileItem(aFileItem)
	
	Method geraIP200()
	Method GetFolder()
	Method GetFileName()
	Method WriteFile(cXmlFile)
	
	METHOD NewDHLIP200() CONSTRUCTOR
	
ENDCLASS

/*/{Protheus.doc} NewDHLIP200
Método Construtor

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
METHOD NewDHLIP200() CLASS DHLIP200
	
	::cDateTime	   := ''
	::cFromPartner := ''
	::cToPartner   := ''
	::cSiteCNPJ    := ''
	::cNfNumber    := ''
	::cNfSerie     := ''
	::cNfProtoc    := ''
	::cNfDate      := ''
	::cProcessDate := ''
	::cRandomNumb  := ''	
	::cCheckDigit  := ''
	::aFileItem    := {}
	::oFile        := IpFileObject():newIpFileObject()	
	
Return

/*/{Protheus.doc} GetDateTime()
Obtém o DATETIME  do XML

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method GetDateTime() Class DHLIp200

return ::cDateTime

/*/{Protheus.doc} SetDateTime()
Define o DATETIME  do XML

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method SetDateTime(cDateTime) Class DHLIp200
	::cDateTime := cDateTime
return	

/*/{Protheus.doc} GetFromPartner()
Obtém o PARTNERNAME (FROM) do XML

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method GetFromPartner() Class DHLIp200
Return	::cFromPartner

/*/{Protheus.doc} SetFromPartner()
Define o PARTNERNAME (FROM) do XML

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method SetFromPartner(cFromPartner) Class DHLIp200
	::cFromPartner:= alltrim(cFromPartner)
Return
/*/{Protheus.doc} GetToPartner()
Obtém o PARTNERNAME (TO) do XML

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method GetToPartner() Class DHLIp200
Return	::cToPartner

/*/{Protheus.doc} SetToPartner()
Define o PARTNERNAME (TO) do XML

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method SetToPartner(cToPartner) Class DHLIp200
	::cToPartner:= alltrim(cToPartner)
Return
/*/{Protheus.doc} GetSiteCNPJ()
Obtém o CNPJ do site

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method GetSiteCNPJ() Class DHLIp200
Return	::cSiteCNPJ

/*/{Protheus.doc} SetSiteCNPJ()
Define o CNPJ do site

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method SetSiteCNPJ(cSiteCNPJ) Class DHLIp200
	::cSiteCNPJ:= alltrim(cSiteCNPJ)
Return
/*/{Protheus.doc} GetNfNumber()
Obtém a tag NF_NUMBER

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method GetNfNumber() Class DHLIp200
Return	::cNfNumber

/*/{Protheus.doc} SetNfNumber()
Define a tag NF_NUMBER

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method SetNfNumber(cNfNumber) Class DHLIp200
	::cNfNumber:= alltrim(cNfNumber)
Return
/*/{Protheus.doc} GetNfSerie()
Obtém a tag NF_SERIE

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method GetNfSerie() Class DHLIp200
Return	::cNfSerie

/*/{Protheus.doc} SetNfSerie()
Define a tag NF_SERIE

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method SetNfSerie(cNfSerie) Class DHLIp200
	::cNfSerie:= alltrim(cNfSerie)
Return
/*/{Protheus.doc} GetNfProtoc()
Obtém a tag NF_PROTOCOL

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method GetNfProtoc() Class DHLIp200
Return	::cNfProtoc

/*/{Protheus.doc} SetNfProtoc()
Define a tag NF_PROTOCOL

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method SetNfProtoc(cNfProtoc) Class DHLIp200
	::cNfProtoc:= alltrim(cNfProtoc)
Return


/*/{Protheus.doc} GetNfDate()
Obtém a tag NF_DATE

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method GetNfDate() Class DHLIp200
Return	::cNfDate

/*/{Protheus.doc} SetNfDate()
Define a tag NF_DATE

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method SetNfDate(dNfDate) Class DHLIp200
	::cNfDate:= dTos(dNfDate)
Return


/*/{Protheus.doc} getProcessDate()
Obtém a tag PROCESS_DATE

@author Thiago Meschiatti
@since 20/09/17
@version 1.0
@example
(examples)
/*/
Method getProcessDate() Class DHLIp200
Return	::cProcessDate


/*/{Protheus.doc} setProcessDate()
Define a tag PROCESS_DATE

@author Thiago Meschiatti
@since 20/09/17
@version 1.0
@example
(examples)
/*/
Method setProcessDate(cProcessDate) Class DHLIp200
	::cProcessDate:= cProcessDate
Return


/*/{Protheus.doc} getRandomNumb()
Obtém a tag RANDOM_NUMBER

@author Thiago Meschiatti
@since 20/09/17
@version 1.0
@example
(examples)
/*/
Method getRandomNumb() Class DHLIp200
Return	::cRandomNumb


/*/{Protheus.doc} setRandomNumb()
Define a tag RANDOM_NUMBER

@author Thiago Meschiatti
@since 20/09/17
@version 1.0
@example
(examples)
/*/
Method setRandomNumb(cRandomNumb) Class DHLIp200
	::cRandomNumb:= cRandomNumb
Return


/*/{Protheus.doc} getCheckDigit()
Obtém a tag CHECK_DIGIT

@author Thiago Meschiatti
@since 20/09/17
@version 1.0
@example
(examples)
/*/
Method getCheckDigit() Class DHLIp200
Return	::cCheckDigit


/*/{Protheus.doc} setCheckDigit()
Define a tag CHECK_DIGIT

@author Thiago Meschiatti
@since 20/09/17
@version 1.0
@example
(examples)
/*/
Method setCheckDigit(cCheckDigit) Class DHLIp200
	::cCheckDigit:= cCheckDigit
Return


/*/{Protheus.doc} GetFileItem()
Obtém os itens

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method GetFileItem() Class DHLIp200
Return	::aFileItem

/*/{Protheus.doc} SetFileItem()
Define os itens

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method SetFileItem(aFileItem) Class DHLIp200
	::aFileItem:=aFileItem
Return

/*/{Protheus.doc} geraIP200
gera a interface IP200

@author Gustavo Luiz
@since 08/08/17
@version 1.0
@example
(examples)
/*/
Method geraIP200() Class DHLIp200
	
	local cXMLFile  	:= mountTags(self)	
	local lStatus		:= .F.
	
	lStatus := ::WriteFile(cXMLFile)
	
return lStatus

/*/{Protheus.doc} WriteFile
Gera o xml no local especificado

@author Gustavo Luiz
@since 09/08/2017
@version 1.0
@example
(examples)
/*/
Method WriteFile(cXmlFile) Class DHLIp200
	
	local lStatus := .F.	
	local cFileName	:= 	::getFileName()
	
	lStatus := ::oFile:writeLine(cXmlFile)
	
return lStatus

/*/{Protheus.doc} getFolder
Retorna o diretório de arquivos SAP

@author Gustavo Luiz
@since 09/08/2017
@version 1.0
@example
(examples)
/*/
Method GetFolder() Class DHLIp200
	local oSql := IpSqlObject():newIpSqlObject()
return AllTrim(oSql:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '" + APP_SAP + "'"))

/*/{Protheus.doc} getFileName
Retorna o nome do arquivo xml da interface IP200

@author Gustavo Luiz
@since 09/08/2017
@version 1.0
@example
(examples)
/*/
Method getFileName() Class DHLIp200
	
	local cFolder   	:= ::getFolder()
	local cReference  	:= getReference(self)
	local oUtils		:= IpUtilsObject():newIpUtilsObject()
	local cFileName 	:= oUtils:concatDirectory(cFolder,"SAPIP200"+cReference+".XML")
	
	::oFile:setFile(cFileName)
	
	if ::oFile:exists()
		::oFile:delete()
	endif
	
return cFileName

/**
* Monta as tags a interface IP200
**/
static function mountTags(oIPDHL200)
	
	local cXmlFile := ""
	local aItens   := oIPDHL200:getFileItem()	
	
	cXmlFile := '<?xml version="1.0" encoding="UTF-8"?>'                                   				+ CRLF
	cXmlFile += '<IP_200>'                                                               				+ CRLF
	cXmlFile += '	<HEADER>'                                                              					+ CRLF
	cXmlFile += '		<DATETIME DATETIMEQUALIFIER="on">' + oIPDHL200:GetDateTime() + '</DATETIME>' 		+ CRLF
	cXmlFile += '		<FROM>'                                                            				+ CRLF
	cXmlFile += '			<PARTNERNAME>' + oIPDHL200:GetFromPartner() + '</PARTNERNAME>'           		+ CRLF
	cXmlFile += '		</FROM>'                                                           				+ CRLF
	cXmlFile += '		<TO>'                                                              				+ CRLF
	cXmlFile += '			<PARTNERNAME>' + oIPDHL200:GetToPartner() + '</PARTNERNAME>'             		+ CRLF
	cXmlFile += '		</TO>'                                                             				+ CRLF
	cXmlFile += '	</HEADER>'                                                             					+ CRLF
	cXmlFile += '	<BODY>'                                                                					+ CRLF
	cXmlFile += '		<FILEHEADER>'                                                      				+ CRLF
	cXmlFile += '			<SITE_CNPJ>' 		+ oIPDHL200:GetSiteCNPJ() 	+ 			'</SITE_CNPJ>'      	+ CRLF
	cXmlFile += '			<NF_NUMBER>' 		+ oIPDHL200:GetNfNumber() 	+ 			'</NF_NUMBER>'      	+ CRLF
	cXmlFile += '			<NF_SERIES>' 		+ oIPDHL200:GetNfSerie() 	+ 			'</NF_SERIES>'      	+ CRLF
	cXmlFile += '			<NF_PROTOCOL>' 	+ oIPDHL200:GetNfProtoc() 	+ 			'</NF_PROTOCOL>'    	+ CRLF
	cXmlFile += '			<NF_DATE>' 		+ oIPDHL200:GetNfDate() 	+ 			'</NF_DATE>'       	+ CRLF
	cXmlFile += '			<PROCESS_DATE>' 	+ oIPDHL200:getProcessDate() 	+ 		'</PROCESS_DATE>'     	+ CRLF
	cXmlFile += '			<RANDOM_NUMBER>' 	+ oIPDHL200:getRandomNumb() 	+ 		'</RANDOM_NUMBER>'    	+ CRLF
	cXmlFile += '			<CHECK_DIGIT>' 	+ oIPDHL200:getCheckDigit() 	+ 		'</CHECK_DIGIT>'      	+ CRLF
	cXmlFile += '		</FILEHEADER>'                                                     				+ CRLF
	
	for nI := 1 to len(aItens)
	
		cXmlFile += '	<FILEITEM>'                                                     								+ CRLF
		cXmlFile += '		<ITEM>' 				+ aItens[nI][ITEM] 		+ '</ITEM> '								+ CRLF
		cXmlFile += '		<LINE_ITEM>' 			+ aItens[nI][LINHAITEM] 	+ '</LINE_ITEM> '  						+ CRLF
		cXmlFile += '		<QUANTITY>' 			+ aItens[nI][QUANTIDADE] 	+ '</QUANTITY> ' 							+ CRLF
		cXmlFile += '		<UM>' 				+ aItens[nI][UM] 			+'</UM> '  								+ CRLF
		cXmlFile += '		<PLANT_ID>' 			+ aItens[nI][PLANTID] 		+ '</PLANT_ID> '  						+ CRLF
		cXmlFile += '		<UNIT_PRICE>'			+ aItens[nI][UNITPRICE] 	+ '</UNIT_PRICE> '  						+ CRLF
		cXmlFile += '		<CFOP>' 				+ aItens[nI][CFOP] 		+ '</CFOP> '  							+ CRLF
		cXmlFile += '	</FILEITEM>'                                                     								+ CRLF

	next nI
	
	cXmlFile += '	</BODY>'                                                               				+ CRLF
	cXmlFile += '</IP_200>'                                                              				+ CRLF

return cXmlFile

/**
* Obtém a recerence: Nome que será criada a interface
**/
static function getReference(oIPDHL200)
	
	local cSiteCNPJ 	:= oIPDHL200:getSiteCnpj()
	local cDataHora		:= getDataHora()
	local cReference	:= ""
	
	cReference := "_" + cSiteCNPJ + "_" + cDataHora
	
return cReference

/**
* Obtém a data e hora AAAAMMDDHHMMSS
**/
static function getDataHora()
	
	local cData			:= dTos(dDataBase)
	local cDia			:= substr(cData, 7, 2)
	local cMes			:= substr(cData, 5, 2)
	local cAno			:= substr(cData, 1, 4)
	local cTime			:= time()
	local cHora			:= substr(cTime, 1, 2)
	local cMinuto		:= substr(cTime, 4, 2)
	local cSegundo		:= substr(cTime, 7, 2)
	local cDataHora		:= cAno + cMes + cDia + cHora + cMinuto + cSegundo
	
return cDataHora
