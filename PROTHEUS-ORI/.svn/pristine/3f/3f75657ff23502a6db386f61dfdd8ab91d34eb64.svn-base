#include 'protheus.ch'
#include 'dhl.ch'


/*/{Protheus.doc} SAPIP190
Geração de IP 190 no retorno da ASN Confirmation

@author Thiago Meschiatti
@since 16/06/2017
@version undefined
@param cNota, characters, Numero da NF
@param cSerie, characters, Serie da NF
@param cClieFor, characters, Codigo Cliente/Fornecedor
@param cLoja, characters, Loja Cliente/Fornecedor
@type function
/*/
user function SAPIP190(cNota, cSerie, cClieFor, cLoja, cTipo)
	local lWhite        := nil

	private oSql        := ipSqlObject():newIpSqlObject()
	private oFile       := IpFileObject():newIpFileObject()
	private oUtils      := IpUtilsObject():newIpUtilsObject()
	private oLog		:= DHLLogManager():newDHLLogManager()
	private cXmlFile    := ""
	private cQueryAlias := ""
	private cReference  := ""
	private cFileName   := ""
	
	runQueryData()
	
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
			FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Arquivo "+oFile:getFileName(.T.)+" gravado com sucesso!", 0, 0, {})
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
		
	aAdd(aMsgError,{"Nota fiscal " + AllTrim(cNota) + " série " + AllTrim(cSerie) + " não encontrada."               ,ERRO_QUERY })
	aAdd(aMsgError,{"Erro ao atualizar o status da Nota fiscal " + AllTrim(cNota) + " série " + AllTrim(cSerie) + ".",ERRO_UPDATE})
	
	oLog:start(APP_SAP,DHL_EXPORTACAO,cFileName)
	oLog:fail(LOG_MSG_FALHA,aMsgError[nError][1])
	
return


/**
* Monta o arquivo xml da interface ASN
**/
static function MountTags()

	local cFromPartner := OUT_FROMPARTNER
	local cToPartner   := alltrim(GetNewPar("ZZ_ASNPART", "SAP"))//OUT_TOPARTNER
	local cQuantity    := ""
	
	ProcRegua(oSql:count())
	
	cXmlFile := '<?xml version="1.0" encoding="UTF-8"?>'                                   						+ CRLF
	cXmlFile += '<IP_190>'                                                                    						+ CRLF
	cXmlFile += '	<HEADER>'                                                              						+ CRLF
	cXmlFile += '		<DATETIME DATETIMEQUALIFIER="on">' + getDateTime() + '</DATETIME>' 						+ CRLF
	cXmlFile += '		<FROM>'                                                            						+ CRLF
	cXmlFile += '			<PARTNERNAME>' + cFromPartner + '</PARTNERNAME>'               						+ CRLF
	cXmlFile += '		</FROM>'                                                           						+ CRLF
	cXmlFile += '		<TO>'                                                              						+ CRLF
	cXmlFile += '			<PARTNERNAME>' + cToPartner + '</PARTNERNAME>'                 						+ CRLF
	cXmlFile += '		</TO>'                                                             						+ CRLF
	cXmlFile += '	</HEADER>'                                                             						+ CRLF
	cXmlFile += '	<BODY>'                                                                						+ CRLF		
	cXmlFile += '		<FILEHEADER>'                                                      						+ CRLF
	cXmlFile += '			<REFERENCE>'	+ cReference 									 + '</REFERENCE>' 	+ CRLF
	cXmlFile += '			<PURCHASER>'	+ (cQueryAlias)->PURCHASER 						 + '</PURCHASER>' 	+ CRLF
	cXmlFile += '			<PLANT_ID>' 	+  retPlantId(AllTrim((cQueryAlias)->ITEM))	 	 + '</PLANT_ID>'    + CRLF
	cXmlFile += '			<SALES_ORDER>' 	+  AllTrim((cQueryAlias)->DELIVERY_PONUMBER)	 + '</SALES_ORDER>' + CRLF
	
	cXmlFile += '		</FILEHEADER>'                                                     + CRLF
	
	while oSql:notIsEof()
	
		IncProc()
	
		cQuantity := Alltrim(oUtils:strAnyType((cQueryAlias)->QUANTITY))
		
		cXmlFile += '		<FILEITEM>'                                                    			+ CRLF
		cXmlFile += '			<ITEM>'	 	+ AllTrim((cQueryAlias)->ITEM) 		+ '</ITEM>'         + CRLF
		cXmlFile += '			<QUANTITY>' + cQuantity 						+ '</QUANTITY>'     + CRLF
		cXmlFile += '			<UOM>' 		+ (cQueryAlias)->UOM 				+ '</UOM>'          + CRLF
		cXmlFile += '			<LINE_ITEM>'+ AllTrim((cQueryAlias)->ITEM_PO)	+ '</LINE_ITEM>'	+ CRLF
		cXmlFile += '			<LOT>' + AllTrim((cQueryAlias)->LOTE) + '</LOT>'   + CRLF
		cXmlFile += '		</FILEITEM>'                                              			+ CRLF
		
		oSql:skip()
				
	enddo
	
	cXmlFile += '	</BODY>'                                                               + CRLF
	cXmlFile += '</IP_190>'                                                                   + CRLF
		
return


/**
* Retorna o nome do arquivo xml da interface ASN 
**/
static function getFileName(cReference)

	local cFolder   := getFolder()
	local cFileName := oUtils:concatDirectory(cFolder,"SAPIP190_"+cReference+".XML")
	
return cFileName


/**
* Retorna o diretório de arquivos do WMS Nulogy
**/
static function getFolder()	
return AllTrim(oSql:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '" + APP_SAP + "'"))


/**
* Executa query e cria alias com os dados da Nota Fiscal de Entrada 
**/
static function runQueryData()

	local cQuery := getQuery()

	oSql:newAlias(cQuery)
	
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


/**
 * Monta a Query que retornar os dados para a criação do arquivo
 **/
static function getQuery()

	local cQuery := ""
	local cCnpj  := SM0->M0_CGC
	
	cQuery := "SELECT"                                                    +CRLF
	cQuery += "      '"+cCnpj+"'      PURCHASER"                         +CRLF
	cQuery += "      ,RTRIM(F1_ZZNFVEN)   ||'_'||"                             +CRLF
	cQuery += "      RTRIM(F1_ZZSEVEN) ||'_'||"                             +CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "      A1_CGC           REFERENCE"                     +CRLF
	else
		cQuery += "      A2_CGC           REFERENCE"                     +CRLF
	endif
	cQuery += "      ,B1_COD           ITEM"                              +CRLF      
	cQuery += "      ,D1_UM 		   UOM"								  +CRLF
	cQuery += "      ,D1_ITEM 		   LINE_ITEM"						  +CRLF
	cQuery += "      ,SUM(D1_QUANT)    QUANTITY"                          +CRLF
	cQuery += "      ,SUBSTR(D1_ZZPOEXT, 1, INSTR(D1_ZZPOEXT,'-')-1) DELIVERY_PONUMBER " +CRLF
	cQuery += "      ,SUBSTR(D1_ZZPOEXT, INSTR(D1_ZZPOEXT,'-')+1) ITEM_PO " 			 +CRLF
	cQuery += "      ,D1_ZZLOTE LOTE "						              +CRLF
	cQuery += " FROM %SF1.SQLNAME%"                                       +CRLF
	cQuery += " INNER JOIN %SD1.SQLNAME%"                                 +CRLF
	cQuery += "		ON 1=1 "											  +CRLF
	cQuery += "		AND D1_FILIAL 	= F1_FILIAL "						  +CRLF
	cQuery += "		AND D1_DOC 		= F1_DOC "          				  +CRLF
	cQuery += "   	AND D1_SERIE 	= F1_SERIE "						  +CRLF
	cQuery += "		AND F1_FORNECE 	= D1_FORNECE "   					  +CRLF
	cQuery += "   	AND %SD1.NOTDEL%"                                     +CRLF
	
	if AllTrim(cTipo) $ "D/B"
		cQuery += " INNER JOIN %SA1.SQLNAME%"                                +CRLF
		cQuery += "		ON 1=1 " 											+CRLF
		cQuery += "		AND A1_FILIAL 	= '%SA1.FILIAL%' " 					+CRLF
		cQuery += "		AND A1_COD 		= F1_FORNECE " 						+CRLF
		cQuery += "		AND A1_LOJA 	= F1_LOJA" 							+CRLF
		cQuery += "     AND %SA1.NOTDEL%"                    			 	+CRLF
	else
		cQuery += " INNER JOIN %SA2.SQLNAME%"                                +CRLF
		cQuery += "		ON 1=1" 											+CRLF
		cQuery += "		AND A2_FILIAL 	= '%SA2.FILIAL%' "					+CRLF
		cQuery += "		AND A2_COD 		= F1_FORNECE "						+CRLF
		cQuery += "		AND A2_LOJA 	= F1_LOJA" 							+CRLF
		cQuery += "    	AND %SA2.NOTDEL% "                     				+CRLF
	endif
	
	cQuery += " INNER JOIN %SB1.SQLNAME%"                                  +CRLF
	cQuery += "		ON 1=1" 											  +CRLF
	cQuery += "		AND B1_FILIAL 	= '%SB1.FILIAL%' "                    +CRLF 
	cQuery += "   	AND B1_COD 		= D1_COD "							  +CRLF
	cQuery += "		AND %SB1.NOTDEL% "                       			  +CRLF
	cQuery += " WHERE 1=1 
	cQuery += "      AND F1_FILIAL  = '%SF1.FILIAL%' "                     +CRLF
	cQuery += "      AND F1_DOC     = '"+cNota+"'    "                     +CRLF
	cQuery += "      AND F1_SERIE   = '"+cSerie+"'   "                     +CRLF
	cQuery += "      AND F1_FORNECE = '"+cClieFor+"' "                     +CRLF
	cQuery += "      AND F1_LOJA    = '"+cLoja+"'    "                     +CRLF
	cQuery += "      AND %SF1.NOTDEL%"                                     +CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "GROUP BY A1_CGC,F1_ZZNFVEN,F1_ZZSEVEN,B1_COD,D1_UM,D1_ZZPOEXT,D1_ZZCFOP,D1_ITEM,D1_ZZLOTE"       +CRLF
	else
		cQuery += "GROUP BY A2_CGC,F1_ZZNFVEN,F1_ZZSEVEN,B1_COD,D1_UM,D1_ZZPOEXT,D1_ZZCFOP,D1_ITEM,D1_ZZLOTE"       +CRLF
	endif
	cQuery += " ORDER BY 1,2,3,5"		                                   +CRLF
return cQuery


/*
** Retorna a Planta amarrada no cliente
*/
Static Function retPlantId(cProduct)
	
	Local cRet		:= ""
	Local cQuery	:= ""
	Local oSqlAux   := ipSqlObject():newIpSqlObject()
	
	cQuery += " SELECT A1_ZZPLANT PLANT_ID"
	cQuery += " FROM %SA7.SQLNAME% "
	cQuery += " INNER JOIN %SA1.SQLNAME% ON "
	cQuery += " 		A1_FILIAL 		= A7_FILIAL "
	cQuery += " 		AND A1_COD 		= A7_CLIENTE "
	cQuery += " 		AND A1_LOJA		= A7_LOJA "
	cQuery += " WHERE "
	cQuery += " 		A7_PRODUTO 	= '"+cProduct+"' "
	cQuery += " 		AND %SA7.XFILIAL% "
	cQuery += " 		AND %SA7.NOTDEL% "
	
	oSqlAux:newAlias(cQuery)
	
	If oSqlAux:hasRecords()
		cRet := oSqlAux:getValue("PLANT_ID")
	EndIf
	
	oSqlAux:close()
	
Return (cRet)