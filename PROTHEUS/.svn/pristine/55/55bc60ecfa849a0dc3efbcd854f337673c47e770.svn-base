#include "totvs.ch"
#include "dhl.ch"

#define LOG_MSG_FALHA				"Falha ao Importar Arquivo de Retorno"
#define ERRO_QUERY    1
#define ERRO_UPDATE   2

/*/{Protheus.doc} InvConfirmation

Rotina Responsável por gerar a interface Invoice Confirmation
	
@author Winston Dellano de Castro
@since 19/11/2014
 
@param cNota, String, Número da Nota Fiscal de Saída
@param cSerie, String, Série da Nota Fiscal de Saída 
@param cClieFor, String, Cliente da Nota Fiscal de Saída
@param cLoja, String, Loja do Cliente
/*/

user function InvConfirmation(cNota,cSerie,cClieFor,cLoja,cTipo)

	local lWhite        := nil

	private oSql        := ipSqlObject():newIpSqlObject()
	private oFile       := IpFileObject():newIpFileObject()
	private oUtils      := IpUtilsObject():newIpUtilsObject()
	private oLog		:= DHLLogManager():newDHLLogManager()
	private cXmlFile    := ""
	private cQueryAlias := ""
	private cReference  := ""
	private cFileName   := ""
		
	runQueryData(cNota,cSerie,cClieFor,cLoja,cTipo)
	
	if oSql:notIsEof()
	
		cQueryAlias := oSql:getAlias()
		cReference  := AllTrim((cQueryAlias)->REFERENCE)
		cFileName   := getFileName(cReference)
		
		oFile:setFile(cFileName)
		
		if oFile:exists()
			oFile:delete()
		endif
		
		Processa({|| MountTags()})
		
		lWhite := oFile:writeLine(cXmlFile)
		
		if lWhite
			Aviso(FunDesc(),"Arquivo "+oFile:getFileName(.T.)+" gravado com sucesso!",{"OK"},3)
		endif
		
		oFile:close()
	else
		ViewError(ERRO_QUERY,cNota,cSerie,cClieFor,cLoja)
	endif
	
	oSql:close()
	
return


/**
* Mostra o erro
**/
static function ViewError(nError,cNota,cSerie,cClieFor,cLoja)

	local aMsgError := {}
		
	aAdd(aMsgError,{"Nota fiscal " + AllTrim(cNota) + " série " + AllTrim(cSerie) + " não encontrada."               ,ERRO_QUERY })
	aAdd(aMsgError,{"Erro ao atualizar o status da Nota fiscal " + AllTrim(cNota) + " série " + AllTrim(cSerie) + ".",ERRO_UPDATE})
	
	msgAlert(aMsgError[nError][1])
	
	oLog:start(APP_NULOGY,DHL_EXPORTACAO,cFileName)
	oLog:fail(LOG_MSG_FALHA,aMsgError[nError][1])
	
return


/**
* Retorna o nome do arquivo xml da interface Invoice Confirmation 
**/
static function getFileName(cReference)

	local cFolder   := getFolder()
	local cFileName := oUtils:concatDirectory(cFolder,"INV_CONF_"+cReference+".XML")
	
return cFileName


/**
* Retorna o diretório de arquivos do WMS Nulogy
**/
static function getFolder()	
return AllTrim(oSql:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '" + APP_NULOGY + "'"))


/**
* Executa query e cria alias com os dados da Nota Fiscal de Saída 
**/
static function runQueryData(cNota,cSerie,cClieFor,cLoja,cTipo)

	local cQuery := getQuery(cNota,cSerie,cClieFor,cLoja,cTipo)

	oSql:newAlias(cQuery)
	
return


/**
 * Monta a Query que retornar os dados para a criação do arquivo
 **/
static function getQuery(cNota,cSerie,cClieFor,cLoja,cTipo)

	local cQuery := ""
	local cCnpj  := SM0->M0_CGC
		
	cQuery := "SELECT"                                                    + CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "      A2_CGC          CUSTOMER,"                       + CRLF
	else
		cQuery += "      A1_CGC          CUSTOMER,"                       + CRLF
	endif
	cQuery += "      '"+cCnpj+"'      PURCHASER,"                         +CRLF
	cQuery += "      RTRIM(F2_DOC)   ||'_'||"                             + CRLF
	cQuery += "      RTRIM(F2_SERIE) ||'_'||"                             + CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "      A2_CGC           REFERENCE,"                     + CRLF
	else
		cQuery += "      A1_CGC           REFERENCE,"                     + CRLF
	endif
	cQuery += "      B1_COD           ITEM,"                              + CRLF
	cQuery += "      D2_SEGUM         UOM,"                               + CRLF
	cQuery += "      SUM(D2_QUANT)    QUANTITY,"                          + CRLF
	cQuery += "      C5_ZZSHIP    	  SHIPPING"                           + CRLF
	cQuery += "FROM %SF2.SQLNAME%"                                        + CRLF
	cQuery += "INNER JOIN %SD2.SQLNAME%"                                  + CRLF
	cQuery += "ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND"          + CRLF
	cQuery += "   D2_SERIE = F2_SERIE AND F2_CLIENTE = D2_CLIENTE AND"    + CRLF
	cQuery += "   %SD2.NOTDEL%"                                           + CRLF
	cQuery += "INNER JOIN %SC5.SQLNAME% ON " 							  + CRLF
	cQuery += "		C5_FILIAL = D2_FILIAL AND "							  + CRLF
	cQuery += "		C5_NUM = D2_PEDIDO AND "							  + CRLF
	cQuery += "		%SC5.NOTDEL%"  										  + CRLF
	if AllTrim(cTipo) $ "D/B"
	cQuery += "INNER JOIN %SA2.SQLNAME%"                                  + CRLF
	cQuery += "ON A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = F2_CLIENTE AND" + CRLF
	cQuery += "   A2_LOJA = F2_LOJA AND %SA2.NOTDEL%"                     + CRLF
	else
	cQuery += "INNER JOIN %SA1.SQLNAME%"                                  + CRLF
	cQuery += "ON A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = F2_CLIENTE AND" + CRLF
	cQuery += "   A1_LOJA = F2_LOJA AND %SA1.NOTDEL%"                     + CRLF
	endif
	cQuery += "INNER JOIN %SB1.SQLNAME%"                                  + CRLF
	cQuery += "ON B1_FILIAL = '%SB1.FILIAL%' AND"                         + CRLF
	cQuery += "   B1_COD = D2_COD AND %SB1.NOTDEL%"                       + CRLF
	cQuery += "WHERE F2_FILIAL  = '%SF2.FILIAL%' AND"                     + CRLF
	cQuery += "      F2_DOC     = '"+cNota+"'    AND"                     + CRLF
	cQuery += "      F2_SERIE   = '"+cSerie+"'   AND"                     + CRLF
	cQuery += "      F2_CLIENTE = '"+cClieFor+"' AND"                     + CRLF
	cQuery += "      F2_LOJA    = '"+cLoja+"'    AND"                     + CRLF
	cQuery += "      %SF2.NOTDEL%"                                        + CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "GROUP BY A2_CGC,F2_DOC,F2_SERIE,B1_COD,D2_SEGUM,C5_ZZSHIP" + CRLF
	else
		cQuery += "GROUP BY A1_CGC,F2_DOC,F2_SERIE,B1_COD,D2_SEGUM,C5_ZZSHIP" + CRLF
	endif

return cQuery


/**
* Monta o arquivo xml da interface Invoice Confirmation
**/
static function MountTags()

	local cFromPartner := alltrim(GetNewPar("ZZ_CODINVF", "PROTHEUS_P"))//OUT_FROMPARTNER
	local cToPartner   := alltrim(GetNewPar("ZZ_ASNPART", "PACKING_P"))//OUT_TOPARTNER
	local cQuantity    := ""
	
	ProcRegua(oSql:count())

	cXmlFile := '<?xml version="1.0" encoding="UTF-8"?>'                                                + CRLF
	cXmlFile += '<INV_CONF>'                                                                            + CRLF
	cXmlFile += '	<HEADER> '                                                                          + CRLF
	cXmlFile += '		<DATETIME DATETIMEQUALIFIER="on">' + Alltrim(getDateTime()) + '</DATETIME> '    + CRLF
	cXmlFile += '		<FROM> '                                                                        + CRLF
	cXmlFile += '			<PARTNERNAME>' + Alltrim(cFromPartner) + '</PARTNERNAME> '                  + CRLF
	cXmlFile += '		</FROM> '                                                                       + CRLF
	cXmlFile += '		<TO> '                                                                          + CRLF
	cXmlFile += '			<PARTNERNAME>' + Alltrim(cToPartner) + '</PARTNERNAME> '                    + CRLF
	cXmlFile += '		</TO>'                                                                          + CRLF
	cXmlFile += '	</HEADER> '                                                                         + CRLF
	cXmlFile += '	<BODY>  '                                                                           + CRLF
	cXmlFile += '		<FILEHEADER> '                                                                  + CRLF
	cXmlFile += '			<SHIPPING_NUMBER>' + Alltrim((cQueryAlias)->SHIPPING) + '</SHIPPING_NUMBER>'+ CRLF
	cXmlFile += '			<REFERENCE>' + Alltrim(cReference) + '</REFERENCE>'                         + CRLF
	cXmlFile += '			<CUSTOMER>' + Alltrim((cQueryAlias)->CUSTOMER) + '</CUSTOMER>'              + CRLF
	cXmlFile += '			<PURCHASER>' + Alltrim((cQueryAlias)->PURCHASER) + '</PURCHASER>'           + CRLF
	cXmlFile += '		</FILEHEADER> '                                                                 + CRLF
	
	while oSql:notIsEof()
	
		IncProc()
	
		cQuantity := Alltrim(oUtils:strAnyType((cQueryAlias)->QUANTITY))
		
		cXmlFile += '		<FILEITEM>'                                                    + CRLF
		cXmlFile += '			<ITEM>'     + Alltrim((cQueryAlias)->ITEM) + '</ITEM>'     + CRLF
		cXmlFile += '			<QUANTITY>' + Alltrim(cQuantity)           + '</QUANTITY>' + CRLF
		cXmlFile += '			<UOM>'      + Alltrim((cQueryAlias)->UOM)  + '</UOM>'      + CRLF
		cXmlFile += '		</FILEITEM>'                                                   + CRLF
		
		oSql:skip()
				
	enddo
	
	cXmlFile += '	</BODY> '+ CRLF
	cXmlFile += '</INV_CONF>'+ CRLF

return


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