#include "totvs.ch"
#include "dhl.ch"

#define LOG_MSG_FALHA "Falha ao gerar interface ASN DLX"
#define ERRO_QUERY    1
#define ERRO_UPDATE   2

/*/{Protheus.doc} ASNDLXGenerate

Rotina Responsável por gerar a interface ASN DLX
	
@author Winston Dellano de Castro
@since 19/11/2014
 
@param cNota, String, Número da Nota Fiscal de Saída
@param cSerie, String, Série da Nota Fiscal de Saída 
@param cClieFor, String, Cliente da Nota Fiscal de Saída
@param cLoja, String, Loja do Cliente
@param cTransaction, String, Tipo da transação
/*/

user function ASNDLXGenerate(cNota,cSerie,cClieFor,cLoja,cTransaction,cTipo)

	local lWhite         := nil

	private oSql         := ipSqlObject():newIpSqlObject()
	private oFile        := IpFileObject():newIpFileObject()
	private oUtils       := IpUtilsObject():newIpUtilsObject()
	private oLog		 := DHLLogManager():newDHLLogManager()
	private cXmlFile     := ""
	private cQueryAlias  := ""
	private cReference   := ""
	private cFileName    := ""
	
	default cSerie       := ""
	default cNota        := ""
	default cClieFor     := ""
	default cLoja        := ""
	default cTransaction := ""
	
	if (FWUnitBusiness() <> DHL_BUSINESSUNIT_AGL) .AND. !(validShipping(cTipo,cClieFor,cLoja)) 
		msgAlert("Cliente/Fornecedor não está marcado para enviar ASN DLX")
		return
	endif

	//Elmo, em 21/07/2023: Tratamento Não processar ASN - INÍCIO
	if  (FWUnitBusiness() == DHL_BUSINESSUNIT_AGL) .AND. !(AGLvalidShipping(cTipo,cClieFor,cLoja)) 
		msgAlert("Cliente/Fornecedor não está marcado para enviar ASN DLX - AGL")
		return
	endif
	//Elmo, em 21/07/2023: Tratamento Não processar ASN - FINAL
		
	runQueryData(cNota,cSerie,cClieFor,cLoja,cTransaction,cTipo)
	
	if oSql:notIsEof()
	
		cQueryAlias := oSql:getAlias()
		cReference  := AllTrim((cQueryAlias)->REFERENCE)
		cFileName   := getFileName(cReference)
		
		oFile:setFile(cFileName)
		
		if oFile:exists()
			oFile:delete()
		endif
		
		Processa({|| MountTags(cNota,cSerie,cClieFor,cLoja,cTransaction,cTipo)})
		
		lWhite := oFile:writeLine(cXmlFile)
		
		if lWhite
			Aviso(FunDesc(),"Arquivo "+oFile:getFileName(.T.)+" gravado com sucesso!",{"OK"},3)
		endif
		
		oFile:close()
	else
		ViewError(ERRO_QUERY,cNota,cSerie)
	endif
	
	oSql:close()
	
return


/**
* Mostra o erro
**/
static function ViewError(nError,cNota,cSerie)

	local aMsgError := {}
		
	aAdd(aMsgError,{"Nota fiscal " + AllTrim(cNota) + " série " + AllTrim(cSerie) + " não encontrada."               ,ERRO_QUERY })
	aAdd(aMsgError,{"Erro ao atualizar o status da Nota fiscal " + AllTrim(cNota) + " série " + AllTrim(cSerie) + ".",ERRO_UPDATE})
	
	msgAlert(aMsgError[nError][1])
	
	oLog:start(APP_DLX,DHL_EXPORTACAO,cFileName)
	oLog:fail(LOG_MSG_FALHA,aMsgError[nError][1])
	
return


/**
* Retorna o nome do arquivo xml da interface ASN DLX 
**/
static function getFileName(cReference)

	local cFolder   := getFolder()
	local cFileName := oUtils:concatDirectory(cFolder,"ASN_DLX_"+cReference+".XML")
	
return cFileName


/**
* Retorna o diretório de arquivos do WMS DLX
**/
static function getFolder()	
return AllTrim(oSql:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '" + APP_DLX + "'"))


/**
* Executa query e cria alias com os dados da Nota Fiscal de Saída 
**/
static function runQueryData(cNota,cSerie,cClieFor,cLoja,cTransaction,cTipo)

	local cQuery := getQuery(cNota,cSerie,cClieFor,cLoja,cTransaction,cTipo)

	oSql:newAlias(cQuery)
	
return


/**
 * Monta a Query que retorna os dados para a criação do arquivo
 **/
static function getQuery(cNota,cSerie,cClieFor,cLoja,cTransaction,cTipo)

	local cQuery  := ""
	local lOnlyOP := isOnlyOP(cNota,cSerie,cClieFor,cLoja,cTransaction) 
	
	cQuery := "SELECT"                                                    + CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "  A2_CGC          CUSTOMER,"                           + CRLF
	else
		cQuery += "  A1_CGC          CUSTOMER,"                           + CRLF
	endif
	cQuery += "      RTRIM(F2_DOC)   ||'_'||"                             + CRLF
	cQuery += "      RTRIM(F2_SERIE) ||'_'||"                             + CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "  A2_CGC          REFERENCE,"                          + CRLF
	else
		cQuery += "  A1_CGC          REFERENCE,"                          + CRLF
	endif
	cQuery += "      B1_COD          ITEM,"                               + CRLF
	cQuery += "      D2_SEGUM        UOM,"                                + CRLF
	cQuery += "      SUM(D2_QUANT)   QUANTITY"                            + CRLF
	cQuery += "FROM %SF2.SQLNAME%"                                        + CRLF
	cQuery += "INNER JOIN %SD2.SQLNAME%"                                  + CRLF
	cQuery += "ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND"          + CRLF
	cQuery += "   D2_SERIE = F2_SERIE AND F2_CLIENTE = D2_CLIENTE"        + CRLF
	if !(IsDeleted(cTransaction))
		cQuery += "  AND %SD2.NOTDEL%"                                    + CRLF
	endif
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
	cQuery += "INNER JOIN %SC6.SQLNAME%"                                  + CRLF
	cQuery += "ON C6_FILIAL = '%SC6.FILIAL%' AND C6_NUM = D2_PEDIDO AND"  + CRLF
	cQuery += "   C6_ITEM = D2_ITEMPV AND C6_PRODUTO = D2_COD AND"        + CRLF
	if lOnlyOP
	cQuery += "   RTRIM(C6_ZZOP) > ' ' AND"                               + CRLF
	endif 
	cQuery += "   %SC6.NOTDEL%"                                           + CRLF
	cQuery += "WHERE F2_FILIAL  = '%SF2.FILIAL%' AND"                     + CRLF
	cQuery += "      F2_DOC     = '" + cNota + "'    AND"                 + CRLF
	cQuery += "      F2_SERIE   = '" + cSerie + "'   AND"                 + CRLF
	cQuery += "      F2_CLIENTE = '" + cClieFor + "' AND"                 + CRLF
	cQuery += "      F2_LOJA    = '" + cLoja + "'"                        + CRLF
	if !(IsDeleted(cTransaction))
		cQuery += "  AND %SF2.NOTDEL%"                                    + CRLF
	endif
	cQuery += "GROUP BY A1_CGC,F2_DOC,F2_SERIE,B1_COD,D2_SEGUM"           + CRLF

return cQuery


/**
* Verifica se existe OP criada para os itens da nota
**/
static function isOnlyOP(cNota,cSerie,cClieFor,cLoja,cTransaction)

	local lReturn := .F.
	local cQuery  := ""
	
	cQuery += "SELECT C6_ZZOP "                           + CRLF
	cQuery += "FROM %SD2.SQLNAME%"                        + CRLF
	cQuery += "INNER JOIN %SC6.SQLNAME%"                  + CRLF
	cQuery += "ON C6_FILIAL = '%SC6.FILIAL%' AND"         + CRLF
	cQuery += "   C6_NUM = D2_PEDIDO AND"                 + CRLF
	cQuery += "   C6_ITEM = D2_ITEMPV AND"                + CRLF
	cQuery += "   C6_PRODUTO = D2_COD AND"                + CRLF
	cQuery += "   RTRIM(C6_ZZOP) > ' ' AND %SC6.NOTDEL%"  + CRLF
	cQuery += "WHERE D2_FILIAL = '%SD2.FILIAL%' AND"      + CRLF 
	cQuery += "      D2_DOC = '" + cNota + "' AND"        + CRLF
	cQuery += "      D2_SERIE = '" + cSerie + "' AND"     + CRLF
	cQuery += "      D2_CLIENTE = '" + cClieFor + "' AND" + CRLF
	cQuery += "      D2_LOJA = '" + cLoja + "'"           + CRLF
	if !(IsDeleted(cTransaction))
		cQuery += "  AND %SD2.NOTDEL%"                    + CRLF
	endif
	
	oSql:newAlias(cQuery)
	
	if oSql:notIsEof()
		lReturn := .T.
	endif
	
	oSql:close()

return lReturn


/**
* Verifica se é uma nota fiscal cancelada
**/
static function IsDeleted(cTransaction)
return if(cTransaction == "04",.T.,.F.)


/**
* Monta o arquivo xml da interface ASN DLX
**/
static function MountTags(cNota,cSerie,cClieFor,cLoja,cTransaction,cTipo)

	local cFromPartner := AllTrim(OUT_FROMPARTNER)
	local cToPartner   := alltrim(GetNewPar("ZZ_ASNPART", "PACKING_P"))//AllTrim(OUT_TOPARTNER)
	local cQuantity    := ""
	local cRaType      := "PACK" // cNota,cSerie,cClieFor,cLoja
	local cCnpj        := SM0->M0_CGC
	local cLineNumber  := "000"
	local cProduto	   := ""
	local nQuant2	   := 0
	
	ProcRegua(oSql:count())

	cXmlFile := '<?xml version="1.0" encoding="UTF-8"?>'                                            + CRLF
	cXmlFile += '<ASN_DLX>'                                                                         + CRLF
	cXmlFile += '	<HEADER>'                                                                       + CRLF
	cXmlFile += '		<DATETIME DATETIMEQUALIFIER="on">' + getDateTime() + '</DATETIME>'          + CRLF
	cXmlFile += '		<FROM>'                                                                     + CRLF
	cXmlFile += '			<PARTNERNAME>' + cFromPartner + '</PARTNERNAME>'                        + CRLF
	cXmlFile += '		</FROM>'                                                                    + CRLF
	cXmlFile += '		<TO>'                                                                       + CRLF
	cXmlFile += '			<PARTNERNAME>' + cToPartner + '</PARTNERNAME>'                          + CRLF
	cXmlFile += '		</TO>'                                                                      + CRLF
	cXmlFile += '	</HEADER>'                                                                      + CRLF
	cXmlFile += '	<BODY>'                                                                         + CRLF
	cXmlFile += '		<FILEHEADER>'                                                               + CRLF
	cXmlFile += '			<TRANSACTION_ACTION>' + AllTrim(cTransaction) + '</TRANSACTION_ACTION>' + CRLF
	cXmlFile += '			<RA_TYPE>' + AllTrim(cRaType) + '</RA_TYPE>'                            + CRLF
	cXmlFile += '			<RA_NUMBER>' + AllTrim(cNota) + '</RA_NUMBER>'                          + CRLF
	cXmlFile += '			<VENDOR_ID>' + AllTrim(cCnpj) + '</VENDOR_ID>'                          + CRLF
	cXmlFile += '			<CUSTOMER_ID>' + AllTrim((cQueryAlias)->CUSTOMER) + '</CUSTOMER_ID>'    + CRLF
	cXmlFile += '			<NF_SERIE>' + AllTrim(cSerie) + '</NF_SERIE>'                           + CRLF
	cXmlFile += '			<VARIABLE_FIELD_01></VARIABLE_FIELD_01>'                                + CRLF
	cXmlFile += '			<VARIABLE_FIELD_02></VARIABLE_FIELD_02>'                                + CRLF
	cXmlFile += '			<VARIABLE_FIELD_03></VARIABLE_FIELD_03>'                                + CRLF
	cXmlFile += '			<VARIABLE_FIELD_04></VARIABLE_FIELD_04>'                                + CRLF
	cXmlFile += '			<VARIABLE_FIELD_05></VARIABLE_FIELD_05>'                                + CRLF
	cXmlFile += '		</FILEHEADER> '                                                             + CRLF
	
	while oSql:notIsEof()
	
		IncProc()
		
		cProduto	:= (cQueryAlias)->ITEM
		
		cQuantity   := Alltrim(oUtils:strAnyType((cQueryAlias)->QUANTITY))
		nQuant2   	:= unidadeMedida(cNota,cSerie,cClieFor,cLoja,cTipo,cProduto,(cQueryAlias)->QUANTITY)
		if nQuant2 > 0
			 cQuantity   := Alltrim(oUtils:strAnyType(nQuant2))
		endif
		cLineNumber := Soma1(cLineNumber)

		cXmlFile += '		<FILEITEM> '                                                              + CRLF
		cXmlFile += '			<TRANSACTION_ACTION>' + AllTrim(cTransaction)+'</TRANSACTION_ACTION>' + CRLF
		cXmlFile += '			<RA_TYPE>' + AllTrim(cRaType)+'</RA_TYPE>'                            + CRLF
		cXmlFile += '			<RA_NUMBER>' + AllTrim(cNota)+'</RA_NUMBER>'                          + CRLF
		cXmlFile += '			<NF_SERIE>' + AllTrim(cSerie)+'</NF_SERIE>'                           + CRLF
		cXmlFile += '			<LINE_NUMBER>' + AllTrim(cLineNumber)+'</LINE_NUMBER>'                + CRLF
		cXmlFile += '			<ITEM_NUMBER>' + AllTrim((cQueryAlias)->ITEM)+'</ITEM_NUMBER>'        + CRLF
		cXmlFile += '			<INVENTORY_STATUS></INVENTORY_STATUS>'                                + CRLF
		cXmlFile += '			<QUANTITY>' + cQuantity+'</QUANTITY>'                                 + CRLF
		cXmlFile += '		</FILEITEM>'                                                              + CRLF
		
		oSql:skip()
				
	enddo
	
	cXmlFile += '	</BODY>'+ CRLF
	cXmlFile += '</ASN_DLX>'+ CRLF

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
	
return AllTrim(cDateTime)


/**
* Verifica se é para gerar a ASN DLX para o cliente/fornecedor
**/
static function validShipping(cTipo,cClieFor,cLoja)

	local lShipping := .T.
	local cShipping := ""
	local oSql      := ipSqlObject():newIpSqlObject()
	
	if AllTrim(cTipo) $ "D/B"
		cShipping := AllTrim(oSql:getFieldValue("SA2","A2_ZZEASN","A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = '" + cClieFor + "' AND A2_LOJA = '" + cLoja + "'"))
	else
		cShipping := AllTrim(oSql:getFieldValue("SA1","A1_ZZEASN","A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '" + cClieFor + "' AND A1_LOJA = '" + cLoja + "'"))
	endif
	
	lShipping := if(cShipping == "N",.F.,.T.)
	
return lShipping

/**
 * Ajusta as Unidades de Medida dos Produtos
 */
static function unidadeMedida(cNota,cSerie,cClieFor,cLoja,cTipo,cProduto,nQuantity)
	
	local nQtd1UM	 	:= 0
	local nQtd2UM		:= 0
	local cSegUM	 	:= ""
	local cCliFor		:= ""
	local cCpoCliFor 	:= ""
	local cCpoLoja   	:= ""
	local cCpoProduto 	:= ""
	local cCpoUmNfe		:= ""
	local cWhere		:= ""
	local oSql 			:= IpSqlObject():newIpSqlObject()	
	
	cCliFor := cClieFor
	cLoja   := cLoja
	cAlias	:= "SA7"
	if (cTipo $ "DB")
		cAlias	:= "SA5"
	endIf				
	
	if (cAlias == "SA5")
		cCpoCliFor 	:= "A5_FORNECE"
		cCpoLoja   	:= "A5_LOJA"
		cCpoProduto := "A5_PRODUTO"
		cCpoUmNfe	:= "A5_UMNFE"
	elseIf (cAlias == "SA7")
		cCpoCliFor 	:= "A7_CLIENTE"
		cCpoLoja   	:= "A7_LOJA"
		cCpoProduto := "A7_PRODUTO"
		cCpoUmNfe	:= "A7_UMNFE"
	endIf	

	cWhere := " %"+cAlias+".XFILIAL% AND "+cCpoCliFor+" = '"+cCliFor+"' AND "+cCpoLoja+" = '"+cLoja+"' AND "
	cWhere += cCpoProduto+" = '"+cProduto+"' "
	
	oSql:newTable(cAlias, cCpoUmNfe+" UMNFE ", cWhere)	
	
	if oSql:hasRecords() .and. oSql:getValue("UMNFE == '2'")
		dbselectarea("SB1")
		SB1->(dbsetorder(1))
		if SB1->(dbseek((xFilial("SB1") + cProduto)))
			nQtd2UM 	:= ConvUM(cProduto, nQuantity, 0, 2)
		endif 
	endIf
	
	oSql:close()
	
return (nQtd2UM)



/**
* Verifica se é para gerar a ASN DLX para o cliente/fornecedor
**/
static function AGLvalidShipping(cTipo,cClieFor,cLoja)

	local lShipping := .T.
	local cShipping := ""
	local oSql      := ipSqlObject():newIpSqlObject()
	
	if AllTrim(cTipo) $ "D/B"
		cShipping := AllTrim(oSql:getFieldValue("SA1","A1_ZZEVASN","A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '" + cClieFor + "' AND A1_LOJA = '" + cLoja + "'"))
	else
		cShipping := AllTrim(oSql:getFieldValue("SA2","A2_ZZEVASN","A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = '" + cClieFor + "' AND A2_LOJA = '" + cLoja + "'"))
	endif
	
	lShipping := if(cShipping $ "1N",.F.,.T.)
	
return lShipping
