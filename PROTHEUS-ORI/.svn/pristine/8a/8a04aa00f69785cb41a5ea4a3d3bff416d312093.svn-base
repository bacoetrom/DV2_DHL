#include "totvs.ch"
#include "dhl.ch"

#define LOG_MSG_FALHA "Falha ao gerar interface Fiscal Coverage"
#define ERRO_QUERY    1
#define ERRO_UPDATE   2

#define FIRSTLEG  "1"
#define SECONDLEG "2"

#define SZ4_FILIAL 1
#define SZ4_DOC    2
#define SZ4_SERIE  3
#define SZ4_CLIFOR 4
#define SZ4_LOJA   5


/*/{Protheus.doc} AgeFiscalCoverage

Função responsável por gerar a interface Fiscal Coverage para a Unidade de Negócio AGE(HP)
	
@author Gustavo Luiz
@since 18/08/2016

@param aNFCobertas, Array, Array com informações da Notas Fiscais Cobertas
/*/
user function AgeFiscalCoverage(aNFCobertas)

	local   cQuery      := ""
	
	private cBranch     := SF1->F1_FILIAL
	private cSerie      := SF1->F1_SERIE
	private cNota       := SF1->F1_DOC
	private cClieFor    := SF1->F1_FORNECE
	private cLoja       := SF1->F1_LOJA
	private cTipo       := SF1->F1_TIPO
	
	private oSql        := ipSqlObject():newIpSqlObject()
	private oFile       := IpFileObject():newIpFileObject()
	private oUtils      := IpUtilsObject():newIpUtilsObject()
	private oLog		:= DHLLogManager():newDHLLogManager()
	private cXmlFile    := ""
	private cQueryAlias := ""
	private cReference  := ""
	private cFileName   := ""
	
	default aNFCobertas := {}
		
	if !(validation())
		return
	endif
		
	if Len(aNFCobertas) == 0
	
		cQuery := "SELECT Z4_FILIAL,Z4_DOC,Z4_SERIE,Z4_CLIFOR,Z4_LOJA"           +CRLF
		cQuery += "FROM %SZ4.SQLNAME%"                                           +CRLF
		cQuery += "WHERE Z4_FILIAL = '%SF1.FILIAL%' AND"                         +CRLF
		cQuery += "      Z4_TIPMOV = '" + FIRSTLEG + "' AND"                     +CRLF
		cQuery += "      %SZ4.NOTDEL% AND"                                       +CRLF
		cQuery += "      Z4_IDCOB IN (SELECT Z4_IDCOB"                           +CRLF
		cQuery += "                   FROM %SZ4.SQLNAME%"                        +CRLF
		cQuery += "                   WHERE Z4_FILIAL = '%SF1.FILIAL%' AND"      +CRLF
		cQuery += "                         Z4_TIPMOV = '" + SECONDLEG + "' AND" +CRLF
		cQuery += "                         Z4_DOC    = '" + cNota + "' AND"     +CRLF
		cQuery += "                         Z4_SERIE  = '" + cSerie + "' AND"    +CRLF
		cQuery += "                         %SZ4.NOTDEL%)"                       +CRLF
	
		oSql:newAlias(cQuery)
	
		if oSql:IsEof()
			ViewError(ERRO_QUERY)
		else
			cQueryAlias := oSql:getAlias()
		endif
		
		while oSql:notIsEof()
		
			aAdd(aNFCobertas,{(cQueryAlias)->Z4_FILIAL,(cQueryAlias)->Z4_DOC,(cQueryAlias)->Z4_SERIE,(cQueryAlias)->Z4_CLIFOR,(cQueryAlias)->Z4_LOJA})
			
			oSql:skip()
					
		enddo
		
		oSql:close()
	endif
	
	createFile(aNFCobertas)

return

/**
* Valida se é Nota Fiscal de Cobertura e se está classificada
**/
static function validation()

	local lValidation := .T.
	local cQuery      := ""
	
	cQuery := "Z4_FILIAL = '%SF1.FILIAL%'      AND "
	cQuery += "Z4_TIPMOV = '" + SECONDLEG + "' AND "
	cQuery += "Z4_DOC    = '" + cNota + "'     AND "
	cQuery += "Z4_SERIE  = '" + cSerie + "'"
	
	if !(oSql:exists("SZ4",cQuery))
		msgAlert("Nota Fiscal " + AllTrim(cNota) + " Série " + AllTrim(cSerie) + " não é uma Nota Fiscal de Cobertura.")
		lValidation := .F.
	endif
	
	cQuery := "D1_FILIAL  = '" + cBranch + "'  AND "
	cQuery += "D1_DOC     = '" + cNota + "'    AND "
	cQuery += "D1_SERIE   = '" + cSerie + "'   AND " 
	cQuery += "D1_FORNECE = '" + cClieFor + "' AND "
	cQuery += "D1_LOJA    = '" + cLoja + "'    AND " 
	cQuery += "D1_TIPO    = '" + cTipo + "'    AND "
	cQuery += "RTRIM(D1_TES) <> ' '"     
		
	if !(oSql:exists("SD1",cQuery))
		msgAlert("Nota Fiscal " + AllTrim(cNota) + " Série " + AllTrim(cSerie) + " não classificada.")
		lValidation := .F.
	endif
	
return lValidation


/**
* Cria a interface Fiscal Coverage
**/
static function createFile(aNFCobertas)

	local lWhite := nil
	
	runQueryData()
	
	if oSql:notIsEof()
	
		cQueryAlias := oSql:getAlias()
		cReference  := AllTrim((cQueryAlias)->REFERENCE)
		cFileName   := getFileName(cReference)
		
		oFile:setFile(cFileName)
		
		if oFile:exists()
			oFile:delete()
		endif
		
		Processa({|| MountTags(aNFCobertas,AllTrim((cQueryAlias)->PURCHASER))})
		
		lWhite := oFile:writeLine(cXmlFile)
		
		if lWhite
			Aviso(FunDesc(),"Arquivo "+oFile:getFileName(.T.)+" gravado com sucesso!",{"OK"},3)
		endif
		
		oFile:close()
	else
		ViewError(ERRO_QUERY)
	endif
	
	oSql:close()
	
return


/**
* Mostra o erro
**/
static function ViewError(nError)

	local aMsgError := {}
		
	aAdd(aMsgError,{"Nota Fiscal " + AllTrim(cNota) + " Série " + AllTrim(cSerie) + " não encontrada."               ,ERRO_QUERY })
	aAdd(aMsgError,{"Erro ao atualizar o status da Nota Fiscal " + AllTrim(cNota) + " série " + AllTrim(cSerie) + ".",ERRO_UPDATE})
	
	msgAlert(aMsgError[nError][1])
	
	oLog:start(APP_DLX,DHL_EXPORTACAO,cFileName)
	oLog:fail(LOG_MSG_FALHA,aMsgError[nError][1])
	
return


/**
* Monta o arquivo xml da interface Fiscal Coverage
**/
static function MountTags(aNFCobertas,cPurchaser)

	local cFromPartner := OUT_FROMPARTNER
	local cToPartner   := alltrim(GetNewPar("ZZ_ASNPART", "PACKING_P"))//OUT_TOPARTNER
	local nProcRegua   := oSql:count() * Len(aNFCobertas)
	local nNota        := 1
	local bMulti	   := SuperGetMV("ZZ_AGEMUL",,.F.)
	
	ProcRegua(nProcRegua)
	
	cXmlFile := '<?xml version="1.0" encoding="UTF-8"?>'                                          +CRLF
	cXmlFile += '<FISC_COV>'                                                                      +CRLF
	cXmlFile += '	<HEADER>'                                                                     +CRLF
	cXmlFile += '		<DATETIME DATETIMEQUALIFIER="on">'+getDateTime()+'</DATETIME>'            +CRLF
	cXmlFile += '		<FROM>'                                                                   +CRLF
	cXmlFile += '			<PARTNERNAME>'+cFromPartner+'</PARTNERNAME>'                          +CRLF
	cXmlFile += '		</FROM>'                                                                  +CRLF
	cXmlFile += '		<TO>'                                                                     +CRLF
	cXmlFile += '			<PARTNERNAME>'+cToPartner+'</PARTNERNAME>'                            +CRLF
	cXmlFile += '		</TO>'                                                                    +CRLF
	cXmlFile += '	</HEADER>'                                                                    +CRLF
	cXmlFile += '	<BODY>'                                                                       +CRLF
	cXmlFile += '		<FILEHEADER>'                                                             +CRLF
	cXmlFile += '			<FISCAL_COVERAGE_REFERENCE>'+cReference+'</FISCAL_COVERAGE_REFERENCE>'+CRLF
	cXmlFile += '			<PURCHASER>' + cPurchaser + '</PURCHASER>'                            + CRLF
	
	//Para o cenário de AGE MUL deve-se enviar o plantid
	If (bMulti)
		cXmlFile += '			<PLANT_ID>' + getPlantId() + '</PLANT_ID>'                         + CRLF
	EndIf
	
	cXmlFile += '		</FILEHEADER>'                                                            +CRLF
	
	for nNota := 1 to Len(aNFCobertas)
	
		IncProc()
	
		cXmlFile += '		<FILERECEIVE>'                                                                                                   +CRLF
		cXmlFile += '			<ASN_REFERENCE>'+getAsnRefer(aNFCobertas[nNota])+'</ASN_REFERENCE>'                                          +CRLF
		cXmlFile += '			<CUSTOMER_REFERENCE>'+getCustomerRef(aNFCobertas[nNota])+'</CUSTOMER_REFERENCE>'                                          +CRLF
		cXmlFile += '			<RECEIVE_ORDER>'+getReceiveOrder(aNFCobertas[nNota])+'</RECEIVE_ORDER>'                                      +CRLF
		cXmlFile += '			<RECEIVE_ORDER_EXTERNAL_IDENTIFIER>'+getROExternal(aNFCobertas[nNota])+'</RECEIVE_ORDER_EXTERNAL_IDENTIFIER>'+CRLF
		cXmlFile += '		</FILERECEIVE>'                                                                                                  +CRLF
	
	next
		
	cXmlFile += '	</BODY> '+CRLF
	cXmlFile += '</FISC_COV>'+CRLF
return

/**
* Coleta o Customer Refence
**/
static function getCustomerRef(aNFCobertas)	
return AllTrim(oSql:getFieldValue("SF1","F1_ZZCNPJ","F1_FILIAL = '%SF1.FILIAL%' AND F1_DOC = '" + aNFCobertas[SZ4_DOC] + "' AND F1_SERIE = '" + aNFCobertas[SZ4_SERIE] + "' AND F1_FORNECE = '" + aNFCobertas[SZ4_CLIFOR] + "' AND F1_LOJA = '" + aNFCobertas[SZ4_LOJA] + "'"))


/**
* Coleta o Receive Order
**/
static function getReceiveOrder(aNFCobertas)	
return AllTrim(oSql:getFieldValue("SF1","F1_ZZRORD","F1_FILIAL = '%SF1.FILIAL%' AND F1_DOC = '" + aNFCobertas[SZ4_DOC] + "' AND F1_SERIE = '" + aNFCobertas[SZ4_SERIE] + "' AND F1_FORNECE = '" + aNFCobertas[SZ4_CLIFOR] + "' AND F1_LOJA = '" + aNFCobertas[SZ4_LOJA] + "'"))


/**
* Coleta o Receive Order External
**/
static function getROExternal(aNFCobertas)	
return AllTrim(oSql:getFieldValue("SF1","F1_ZZROEXT","F1_FILIAL = '%SF1.FILIAL%' AND F1_DOC = '" + aNFCobertas[SZ4_DOC] + "' AND F1_SERIE = '" + aNFCobertas[SZ4_SERIE] + "' AND F1_FORNECE = '" + aNFCobertas[SZ4_CLIFOR] + "' AND F1_LOJA = '" + aNFCobertas[SZ4_LOJA] + "'"))

/**
* Coleta o PlantId para AGE MUL
**/

static function getPlantId
	local cQuery := ""
	local cPlantId	:= ""
	
	private cBranch     := SF1->F1_FILIAL
	private cSerie      := SF1->F1_SERIE
	private cNota       := SF1->F1_DOC

	private oSql        := ipSqlObject():newIpSqlObject()
	private oUtils      := IpUtilsObject():newIpUtilsObject()
	private oLog		:= DHLLogManager():newDHLLogManager()
	
	cQuery := "SELECT B1_ZZPLANT "           							+CRLF
	cQuery += "FROM %SB1.SQLNAME% "          							+CRLF
	cQuery += "INNER JOIN %SD1.SQLNAME% ON "   							+CRLF
	cQuery += "SD1.D1_COD = SB1.B1_COD AND "  							+CRLF
	cQuery += "SD1.D1_FILIAL = SB1.B1_FILIAL "          				+CRLF
	cQuery += "WHERE	D1_FILIAL = '%SD1.FILIAL%' AND "    			+CRLF
	cQuery += "   		D1_DOC = '" + cNota + "' AND" 					+CRLF
	cQuery += "   		D1_SERIE = '" + cSerie + "' AND ROWNUM = 1" 	+CRLF
	
	oSql:newAlias(cQuery)
	
	if oSql:IsEof()
			ViewError(ERRO_QUERY)
	else
			cQueryAlias := oSql:getAlias()
			cPlantId = AllTrim((cQueryAlias)->B1_ZZPLANT)
	endif		
	
return cPlantId

/**
* Coleta o ASN Reference 
**/
static function getAsnRefer(aNFCobertas)
	
	local cAsnRefer := ""
	local cTipoNota := oSql:getFieldValue("SF1","F1_TIPO","F1_FILIAL = '%SF1.FILIAL%' AND F1_DOC = '" + aNFCobertas[SZ4_DOC] + "' AND F1_SERIE = '" + aNFCobertas[SZ4_SERIE] + "' AND F1_FORNECE = '" + aNFCobertas[SZ4_CLIFOR] + "' AND F1_LOJA = '" + aNFCobertas[SZ4_LOJA] + "'")
	
	cAsnRefer := AllTrim(aNFCobertas[SZ4_DOC]) + "_" + AllTrim(aNFCobertas[SZ4_SERIE]) + "_"
	
	if AllTrim(cTipoNota) $ "D/B"
		cAsnRefer += oSql:getFieldValue("SA1","A1_CGC","A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '" + aNFCobertas[SZ4_CLIFOR] + "' AND A1_LOJA = '" + aNFCobertas[SZ4_LOJA] + "'")
	else
		cAsnRefer += oSql:getFieldValue("SA2","A2_CGC","A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = '" + aNFCobertas[SZ4_CLIFOR] + "' AND A2_LOJA = '" + aNFCobertas[SZ4_LOJA] + "'")
	endif
	 
return AllTrim(cAsnRefer)


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
	
return cDateTime


/**
* Executa query e cria alias com os dados da Nota Fiscal de Entrada 
**/
static function runQueryData()

	local cQuery := getQuery()

	oSql:newAlias(cQuery)
	
return


/**
 * Monta a Query que retornar os dados para a criação do arquivo
 **/
static function getQuery()
	
	local cQuery := ""
	local cCnpj  := SM0->M0_CGC
		
	cQuery := "SELECT"                                                        +CRLF
	cQuery += "      '"+cCnpj+"'      PURCHASER,"                         +CRLF
	cQuery += "      RTRIM(F1_DOC)   ||'_'||"                                 +CRLF
	cQuery += "      RTRIM(F1_SERIE) ||'_'||"                                 +CRLF
	
	if AllTrim(cTipo) $ "D/B"
		cQuery += "      RTRIM(A1_CGC)         REFERENCE"                     +CRLF
	else
		cQuery += "      RTRIM(A2_CGC)         REFERENCE"                     +CRLF
	endif
	
	cQuery += "FROM %SF1.SQLNAME%"                                            +CRLF
	cQuery += "INNER JOIN %SD1.SQLNAME%"                                      +CRLF
	cQuery += "ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND"              +CRLF
	cQuery += "   D1_SERIE = F1_SERIE AND F1_FORNECE = D1_FORNECE AND"        +CRLF
	cQuery += "   %SD1.NOTDEL%"                                               +CRLF
		
	if AllTrim(cTipo) $ "D/B"
		cQuery += "INNER JOIN %SA1.SQLNAME%"                                  +CRLF
		cQuery += "ON A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = F1_FORNECE AND" +CRLF
		cQuery += "   A1_LOJA = F1_LOJA AND %SA1.NOTDEL%"                     +CRLF
	else
		cQuery += "INNER JOIN %SA2.SQLNAME%"                                  +CRLF
		cQuery += "ON A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = F1_FORNECE AND" +CRLF
		cQuery += "   A2_LOJA = F1_LOJA AND %SA2.NOTDEL%"                     +CRLF
	endif
	
	cQuery += "WHERE F1_FILIAL  = '%SF1.FILIAL%' AND"                         +CRLF
	cQuery += "      F1_DOC     = '"+cNota+"'    AND"                         +CRLF
	cQuery += "      F1_SERIE   = '"+cSerie+"'   AND"                         +CRLF
	cQuery += "      F1_FORNECE = '"+cClieFor+"' AND"                         +CRLF
	cQuery += "      F1_LOJA    = '"+cLoja+"'    AND"                         +CRLF
	cQuery += "      %SF1.NOTDEL%"                                            +CRLF

return cQuery


/**
* Retorna o nome do arquivo xml da interface Fiscal Coverage 
**/
static function getFileName(cReference)

	local cFolder   := getFolder()
	local cFileName := oUtils:concatDirectory(cFolder,"FISC_COV_"+cReference+".XML")
	
return cFileName


/**
* Retorna o diretório de arquivos do WMS Nulogy
**/
static function getFolder()	
return AllTrim(oSql:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '" + APP_DLX + "'"))