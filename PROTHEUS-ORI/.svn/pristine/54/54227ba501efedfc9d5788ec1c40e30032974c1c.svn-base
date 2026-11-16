#Include 'Protheus.ch'
#Include 'Dhl.ch'

#Define FROM_PARTNERNAME 	'PROTHEUS'
#Define TO_PARTNERNAME 		'SAP'

#Define SHIPPING    	1
#Define REFERENCE   	2
#Define CUSTOMER		3  
#Define PURCHASER   	4
#Define SALES_ORDER 	5
#Define DOCUMENT_TYPE	6
#Define PLANT_ID    	7
#Define DATA_EMISSAO	8
#Define NF_ORI      	9
#Define SERIE_ORI   	10
#Define ITEMS        	11

#Define ITEM        	1
#Define QUANTITY    	2
#Define UOM			3        
#Define ITEM_ORI    	4
#Define ITEM_VALUE	5




/*/{Protheus.doc} Ag2GeIP180

Rotina responsável em gerar a interface IP180 no retorno da autorização do MASTERSAF

@author Gustavo Luiz
@since 24/05/2017

/*/
User Function Ag2GeIP180(cNota,cSerie,cClieFor,cLoja,cTipo)
	
	private oSql        := ipSqlObject():newIpSqlObject()
	private oFile       := IpFileObject():newIpFileObject()
	private oUtils      := IpUtilsObject():newIpUtilsObject()
	private oLog		:= DHLLogManager():newDHLLogManager()
	private cXmlFile    := ""
	private cQueryAlias := ""
	private cReference  := ""
	private cFileName   := ""
	
	runQueryData(cNota,cSerie,cClieFor,cLoja,cTipo)
	
Return

/**
* Executa query e cria alias com os dados da Nota Fiscal de Saída
**/
static function runQueryData(cNota,cSerie,cClieFor,cLoja,cTipo)
	
	local cQuery := getQuery(cNota,cSerie,cClieFor,cLoja,cTipo)
	local nI		:= 0
	
	Private aDocs	 := {}
	
	oSql:newAlias(cQuery)
	
	aDocs := splitDocs()
	
	oSql:GoTop()
	
	For nI := 1 to Len(aDocs)
		
		cQueryAlias := oSql:getAlias()
		cReference  := AllTrim(aDocs[nI, REFERENCE])
		cFileName   := getFileName(cReference)
		
		oFile:setFile(cFileName)
		
		if oFile:exists()
			oFile:delete()
		endif
		
		//Processa({|| MountTags()})
		MountTags(nI)
		
		lWhite := oFile:writeLine(cXmlFile)
		
		if lWhite
			Aviso(FunDesc(),"Arquivo "+oFile:getFileName(.T.)+" gravado com sucesso!",{"OK"},3)
		endif
		
		oFile:close()
	Next nI
	
	oSql:close()
	
return

/**
* Monta o arquivo xml da interface Invoice Confirmation
**/
static function MountTags(nI)
	
	local cQuantity	:= ""
	local cItemValue  := ""
	local nJ			:= 0  
	
	ProcRegua(oSql:count())
	
	cXmlFile := '<?xml version="1.0" encoding="UTF-8"?>'                                                							+ CRLF
	cXmlFile += '<SAPIP180>'                                                                              							+ CRLF
	cXmlFile += '	<HEADER> '                                                                          								+ CRLF
	cXmlFile += '		<DATETIME DATETIMEQUALIFIER="on">' + Alltrim(getDateTime()) + '</DATETIME> '    							+ CRLF
	cXmlFile += '		<FROM> '                                                                        							+ CRLF
	cXmlFile += '			<PARTNERNAME>' +FROM_PARTNERNAME + '</PARTNERNAME> '                  									+ CRLF
	cXmlFile += '		</FROM> '                                                                       							+ CRLF
	cXmlFile += '		<TO> '                                                                          							+ CRLF
	cXmlFile += '			<PARTNERNAME>' + TO_PARTNERNAME + '</PARTNERNAME> '                    									+ CRLF
	cXmlFile += '		</TO>'                                                                          							+ CRLF
	cXmlFile += '	</HEADER> '                                                                         								+ CRLF
	cXmlFile += '	<BODY>  '                                                                           								+ CRLF
	cXmlFile += '		<FILEHEADER> '                                                                  							+ CRLF
	cXmlFile += '			<SHIPPING_NUMBER>' + Alltrim(aDocs[nI, SHIPPING]) + '</SHIPPING_NUMBER>'								+ CRLF
	cXmlFile += '			<REFERENCE>' + Alltrim(cReference) + '</REFERENCE>'                         							+ CRLF
	cXmlFile += '			<CUSTOMER>' + Alltrim(aDocs[nI, CUSTOMER]) + '</CUSTOMER>'              								+ CRLF
	cXmlFile += '			<PURCHASER>' + Alltrim(aDocs[nI, PURCHASER]) + '</PURCHASER>'           								+ CRLF
	cXmlFile += '			<SALES_ORDER>' + Alltrim(aDocs[nI, SALES_ORDER]) + '</SALES_ORDER>'     								+ CRLF
	cXmlFile += '			<DOCUMENT_TYPE>' + Alltrim(aDocs[nI, DOCUMENT_TYPE]) + '</DOCUMENT_TYPE>'								+ CRLF
	cXmlFile += '			<PLANT_ID>' + Alltrim(aDocs[nI, PLANT_ID]) + '</PLANT_ID>'   											+ CRLF
	cXmlFile += '			<DATE>' + Alltrim(aDocs[nI, DATA_EMISSAO]) + '</DATE>'       											+ CRLF
	cXmlFile += '			<NF_REFERECE>' + Alltrim(aDocs[nI, NF_ORI]) + "-" + Alltrim(aDocs[nI, SERIE_ORI]) + '</NF_REFERECE>' 	+ CRLF
	cXmlFile += '		</FILEHEADER> '                                                                 							+ CRLF
	//documento de referencia
	
	
	For nJ := 1 to Len(aDocs[nI, ITEMS])
		
		IncProc()
		
		cQuantity  := Alltrim(oUtils:strAnyType(aDocs[nI, ITEMS, nJ, QUANTITY]))
		cItemValue := Alltrim(oUtils:strAnyType(aDocs[nI, ITEMS, nJ, ITEM_VALUE]))
		
		cXmlFile += '		<FILEITEM>'                                                    		+ CRLF
		cXmlFile += '			<ITEM>'     + Alltrim(aDocs[nI, ITEMS, nJ, ITEM]) 				+ '</ITEM>'     + CRLF
		cXmlFile += '			<QUANTITY>' + Alltrim(cQuantity)           						+ '</QUANTITY>' + CRLF
		cXmlFile += '			<UOM>'      + Alltrim(aDocs[nI, ITEMS, nJ, UOM])  				+ '</UOM>'      + CRLF
		cXmlFile += '			<LINE_ITEM>'+ Alltrim(aDocs[nI, ITEMS, nJ, ITEM_ORI])  			+ '</LINE_ITEM>'+ CRLF
		cXmlFile += '			<ITEM_VALUE>'+ Alltrim(cItemValue)			+ '</ITEM_VALUE>'+ CRLF
		cXmlFile += '		</FILEITEM>'                                                   	 + CRLF
		//valor do item
		//item de referencia -  
		
		oSql:skip()
		
	Next nJ
	
	cXmlFile += '	</BODY> '+ CRLF
	cXmlFile += '</SAPIP180>'+ CRLF
	
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
	cQuery += "      B1_COD          ITEM,"                              + CRLF
	cQuery += "      D2_UM         	  UOM,"                               	+ CRLF
	cQuery += "      SUM(D2_QUANT)   QUANTITY,"                          + CRLF
	cQuery += "      C5_ZZSHIP    	  SHIPPING,"                          + CRLF
	cQuery += "      C5_ZZORDEX      SALES_ORDER,"                        + CRLF
	cQuery += "      F2_TIPO         DOCUMENT_TYPE,"                      + CRLF
	cQuery += "      A1_ZZPLANT      PLANT_ID,"                           + CRLF
	cQuery += "      F2_EMISSAO      DATA_EMISSAO,"                       + CRLF
	cQuery += "      D2_NFORI	      NF_ORI,"                             + CRLF
	cQuery += "      D2_SERIORI      SERIE_ORI,"                          + CRLF
	cQuery += "      D2_ITEMORI      ITEM_ORI,"                            + CRLF
	cQuery += "      D2_TOTAL        ITEM_VALUE"                            + CRLF
	
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
		cQuery += "GROUP BY A1_CGC,F2_DOC,F2_SERIE,B1_COD,D2_UM,C5_ZZSHIP, C5_ZZORDEX, F2_TIPO, A1_ZZPLANT, F2_EMISSAO, D2_NFORI, D2_SERIORI, D2_ITEMORI, D2_TOTAL" + CRLF
	else
		cQuery += "GROUP BY A1_CGC,F2_DOC,F2_SERIE,B1_COD,D2_UM,C5_ZZSHIP, C5_ZZORDEX, F2_TIPO, A1_ZZPLANT, F2_EMISSAO, D2_NFORI, D2_SERIORI, D2_ITEMORI, D2_TOTAL" + CRLF
	endif
	
return cQuery

/**
* Retorna o nome do arquivo xml da interface Invoice Confirmation
**/
static function getFileName(cReference)
	
	local cFolder   := getFolder()
	local cFileName := oUtils:concatDirectory(cFolder,"SAPIP180_"+cReference+".XML")
	
return cFileName

/**
* Retorna o diretório de arquivos do WMS Nulogy
**/
static function getFolder()
return AllTrim(oSql:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '" + APP_SAP + "'"))

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


/*
** Separa a execução para mutliplos arquivos 
*/
static function splitDocs()

	local nPos		:= 0
	local aDocs		:= {}

	while oSql:notIsEof()
		nPos := aScan(aDocs, {|x| AllTrim(x[NF_ORI]) + AllTrim(x[SERIE_ORI]) == AllTrim(oSql:GetValue("NF_ORI")) + AllTrim(oSql:GetValue("SERIE_ORI"))})
		if nPos == 0
			aAdd(aDocs, {})
			aAdd(aDocs[Len(aDocs)], AllTrim(oSql:GetValue("SHIPPING")))    	
			aAdd(aDocs[Len(aDocs)], AllTrim(oSql:GetValue("REFERENCE")))   	
			aAdd(aDocs[Len(aDocs)], AllTrim(oSql:GetValue("CUSTOMER")))		
			aAdd(aDocs[Len(aDocs)], AllTrim(oSql:GetValue("PURCHASER")))   	
			aAdd(aDocs[Len(aDocs)], AllTrim(oSql:GetValue("SALES_ORDER"))) 	
			aAdd(aDocs[Len(aDocs)], AllTrim(oSql:GetValue("DOCUMENT_TYPE")))
			aAdd(aDocs[Len(aDocs)], AllTrim(oSql:GetValue("PLANT_ID")))    	
			aAdd(aDocs[Len(aDocs)], AllTrim(oSql:GetValue("DATA_EMISSAO")))	
			aAdd(aDocs[Len(aDocs)], AllTrim(oSql:GetValue("NF_ORI")))
			aAdd(aDocs[Len(aDocs)], AllTrim(oSql:GetValue("SERIE_ORI")))
			aAdd(aDocs[Len(aDocs)], {})
			aAdd(aDocs[Len(aDocs), Len(aDocs[Len(aDocs)])], {	AllTrim(oSql:GetValue("ITEM")),;
						oSql:GetValue("QUANTITY"),;    	
						AllTrim(oSql:GetValue("UOM")),;
						AllTrim(oSql:GetValue("ITEM_ORI")),;
						oSql:GetValue("ITEM_VALUE")}) 
		else
		
			aAdd(aDocs[nPos, ITEMS], {	AllTrim(oSql:GetValue("ITEM")),;
								oSql:GetValue("QUANTITY"),;    	
								AllTrim(oSql:GetValue("UOM")),;
								AllTrim(oSql:GetValue("ITEM_ORI")),;
								oSql:GetValue("ITEM_VALUE")}) 	  
		endIf
		oSql:skip()
	endDo
	
return aDocs