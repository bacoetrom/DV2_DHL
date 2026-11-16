#include "totvs.ch"
#include "dhl.ch"

#define LOG_MSG_FALHA "Falha ao gerar interface ASN"
#define ERRO_QUERY    1
#define ERRO_UPDATE   2


/*/{Protheus.doc} Ag2AsnGen
Geração da ASN Generate

@author Thiago Meschiatti
@since 03/05/2017
@version undefined

@type function
/*/
user function Ag2AsnGen()

	local lWhite        := nil

	private oSql        := ipSqlObject():newIpSqlObject()
	private oFile       := IpFileObject():newIpFileObject()
	private oUtils      := IpUtilsObject():newIpUtilsObject()
	private oLog		  := DHLLogManager():newDHLLogManager()
	private cSerie      := SF1->F1_SERIE
	private cNota       := SF1->F1_DOC
	private cClieFor    := SF1->F1_FORNECE
	private cLoja       := SF1->F1_LOJA
	private cTipo       := SF1->F1_TIPO
	private cXmlFile    := ""
	private cQueryAlias := ""
	private cReference  := ""
	private cFileName   := ""
	
	If cTipo=="N"
		If vldPerg()
			If !Perguntas()
				Return
			EndIf
		EndIf
	EndIf
	
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
			Aviso(FunDesc(),"Arquivo "+oFile:getFileName(.T.)+" gravado com sucesso!",{"OK"},3)
			
			updZZStatus()
		endif
		
		oFile:close()
	else
		ViewError(ERRO_QUERY)
	endif
	
	oSql:close()
	
return


/**
* Atualiza o status da Nota Fiscal
**/
static function updZZStatus()

	local cWhere := ""
	local lError := .F.

	cWhere := "F1_FILIAL  = '%SF1.FILIAL%' AND "
	cWhere += "F1_DOC     = '"+cNota+"'    AND "
	cWhere += "F1_SERIE   = '"+cSerie+"'   AND "
	cWhere += "F1_FORNECE = '"+cClieFor+"' AND "
	cWhere += "F1_LOJA    = '"+cLoja+"'    AND "
	cWhere += "F1_ZZSTATU = '"+DHL_DOC_PENDENTE_ACAO+"' "
	
	lError := oSql:update("SF1","F1_ZZSTATU = '"+DHL_DOC_AGUARDANDO_CONFIRMACAO+"'",cWhere)
	
	if !(lError)
		ViewError(ERRO_UPDATE)
	endif
	
return


/**
* Mostra o erro
**/
static function ViewError(nError)

	local aMsgError := {}
		
	aAdd(aMsgError,{"Nota fiscal " + AllTrim(cNota) + " série " + AllTrim(cSerie) + " não encontrada."               ,ERRO_QUERY })
	aAdd(aMsgError,{"Erro ao atualizar o status da Nota fiscal " + AllTrim(cNota) + " série " + AllTrim(cSerie) + ".",ERRO_UPDATE})
	
	msgAlert(aMsgError[nError][1])
	
	oLog:start(APP_DLX,DHL_EXPORTACAO,cFileName)
	oLog:fail(LOG_MSG_FALHA,aMsgError[nError][1])
	
return


/**
* Monta o arquivo xml da interface ASN
**/
static function MountTags()

	local cFromPartner := OUT_FROMPARTNER
	local cToPartner   := alltrim(GetNewPar("ZZ_ASNPART", "DLX"))//OUT_TOPARTNER
	local cQuantity    := ""
	local cCustomer	   := if(empty((cQueryAlias)->CUSTOMER), (cQueryAlias)->VENDOR, (cQueryAlias)->CUSTOMER)
	
	ProcRegua(oSql:count())
	
	cXmlFile := '<?xml version="1.0" encoding="UTF-8"?>'                                   						+ CRLF
	cXmlFile += '<ASN>'                                                                    						+ CRLF
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
	cXmlFile += '			<VENDOR>' 	+ (cQueryAlias)->VENDOR 	+ '</VENDOR>'                				+ CRLF
	cXmlFile += '			<PURCHASER>'+ Alltrim((cQueryAlias)->PURCHASER) 	+ '</PURCHASER>'      						+ CRLF
	cXmlFile += '			<CUSTOMER>' + cCustomer 				+ '</CUSTOMER>'          					+ CRLF
	cXmlFile += '			<REFERENCE>'+ cReference 				+ '</REFERENCE>'                			+ CRLF
	cXmlFile += '			<ASN_TYPE>' + (cQueryAlias)->TIPO 		+ '</ASN_TYPE>'              				+ CRLF
	If (cQueryAlias)->TIPO == "B"
		cXmlFile += '			<DELIVERY>' + AllTrim((cQueryAlias)->DELIVERY_PONUMBER) + '</DELIVERY>'    		+ CRLF
		cXmlFile += '			<PO_NUMBER></PO_NUMBER>'              + CRLF
	Else
		cXmlFile += '			<DELIVERY></DELIVERY>'          + CRLF
		cXmlFile += '			<PO_NUMBER>' + AllTrim((cQueryAlias)->DELIVERY_PONUMBER) + '</PO_NUMBER>'  		+ CRLF
	EndIf
	cXmlFile += '			<PLANT_ID>' +  retPlantId(AllTrim((cQueryAlias)->ITEM))	 	 + '</PLANT_ID>'        + CRLF
	
	cXmlFile += '		</FILEHEADER>'                                                     + CRLF
	
	while oSql:notIsEof()
	
		IncProc()
	
		cQuantity := Alltrim(oUtils:strAnyType((cQueryAlias)->QUANTITY))
		
		cXmlFile += '		<FILEITEM>'                                                    			+ CRLF
		cXmlFile += '			<ITEM>'	 	+ AllTrim((cQueryAlias)->ITEM) 		+ '</ITEM>'         + CRLF
		cXmlFile += '			<QUANTITY>' + cQuantity 						+ '</QUANTITY>'     + CRLF
		cXmlFile += '			<UOM>' 		+ (cQueryAlias)->UOM 				+ '</UOM>'          + CRLF
		cXmlFile += '			<PO_ITEM>' 	+ AllTrim((cQueryAlias)->ITEM_PO) 	+ '</PO_ITEM>'		+ CRLF
		cXmlFile += '			<CFOP>' 	+ AllTrim((cQueryAlias)->CFOP) 		+ '</CFOP>'         + CRLF
		cXmlFile += '			<LOT>' + AllTrim((cQueryAlias)->LOTE) + '</LOT>'   + CRLF
		cXmlFile += '		</FILEITEM>'                                                   			+ CRLF
		
		oSql:skip()
				
	enddo
	
	cXmlFile += '	</BODY>'                                                               + CRLF
	cXmlFile += '</ASN>'                                                                   + CRLF
		
return


/**
* Retorna o nome do arquivo xml da interface ASN 
**/
static function getFileName(cReference)

	local cFolder   := getFolder()
	local cFileName := oUtils:concatDirectory(cFolder,"ASN_"+cReference+".XML")
	
return cFileName


/**
* Retorna o diretório de arquivos do WMS Nulogy
**/
static function getFolder()	
return AllTrim(oSql:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '" + APP_DLX + "'"))


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
	if AllTrim(cTipo) $ "D/B"
		cQuery += "      A1_CGC           VENDOR"                        +CRLF
	else
		cQuery += "      A2_CGC           VENDOR"                        +CRLF
	endif
	cQuery += "      ,'"+cCnpj+"'      PURCHASER"                         +CRLF
	cQuery += "      ,RTRIM(F1_DOC)   ||'_'||"                             +CRLF
	cQuery += "      RTRIM(F1_SERIE) ||'_'||"                             +CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "      A1_CGC           REFERENCE"                     +CRLF
	else
		cQuery += "      A2_CGC           REFERENCE"                     +CRLF
	endif
	cQuery += "      ,F1_ZZCNPJ        CUSTOMER"                  		  +CRLF
	cQuery += "      ,B1_COD           ITEM"                              +CRLF      
	cQuery += "      ,D1_UM 		   UOM"								  +CRLF
	cQuery += "      ,SUM(D1_QUANT)    QUANTITY"                          +CRLF
	cQuery += "      ,F1_TIPO    	   TIPO"		                      +CRLF
	cQuery += "      ,SUBSTR(D1_ZZPOEXT, 1, INSTR(D1_ZZPOEXT,'-')-1) DELIVERY_PONUMBER " +CRLF
	cQuery += "      ,SUBSTR(D1_ZZPOEXT, INSTR(D1_ZZPOEXT,'-')+1) ITEM_PO " 			 +CRLF
	cQuery += "      ,D1_ZZCFOP 		   CFOP"								  +CRLF
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
		cQuery += "GROUP BY A1_CGC,F1_DOC,F1_SERIE,B1_COD,F1_ZZCNPJ,D1_UM,F1_TIPO,D1_ZZPOEXT,D1_ZZCFOP,D1_ZZLOTE"       +CRLF
	else
		cQuery += "GROUP BY A2_CGC,F1_DOC,F1_SERIE,B1_COD,F1_ZZCNPJ,D1_UM,F1_TIPO,D1_ZZPOEXT,D1_ZZCFOP,D1_ZZLOTE"       +CRLF
	endif
	cQuery += " ORDER BY 2,3,9,10"		                                   +CRLF
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


/**
 * Tela de parametros para informar os dados da nota fiscal de venda à ordem
 **/
Static Function Perguntas()
	
	Local oDlg				:= Nil
	Local cNumeroNF			:= ""
	Local cSerieNf			:= ""
	Local cData    			:= ""
	Local oNfFVendaOrdem 		:= Nil
	Local oSerieNfVendOrdem 	:= Nil
	Local oEmisNfVendOrdem		:= Nil
	Local lStatus				:= .T.
	
	cNfFVendaOrdem 	:= Space(TamSx3("F1_ZZNFVEN")[1])
	cSerieNfVendOrdem	:= Space(TamSx3("F1_ZZSEVEN")[1])
	dEmisNfVendOrdem	:= cTod("")
	
	LoadDadosSF1(@cNfFVendaOrdem,@cSerieNfVendOrdem,@dEmisNfVendOrdem)
	
	Define MsDialog oDlg from 0,0 to 200,400 pixel Title "Nota fiscal de Industrialização" //Style 128
	@010,010 Say "Número da NF:" 		PIXEL Of oDlg
	@025,010 Say "Série da NF:" 		PIXEL Of oDlg
	@040,010 Say "Dt. Emissão NF:" 		PIXEL Of oDlg
	
	
	@009,080 MsGet oNfFVendaOrdem		Var cNfFVendaOrdem 				PICTURE "@!" SIZE 060,8 WHEN .T. Pixel of oDlg //F3 "SA3"
	@024,080 MsGet oSerieNfVendOrdem	Var cSerieNfVendOrdem  			PICTURE "@!" SIZE 060,8 WHEN .T. Pixel of oDlg
	@039,080 MsGet oEmisNfVendOrdem		Var dEmisNfVendOrdem  			PICTURE "@D" SIZE 040,8 WHEN .T. Pixel of oDlg
	
	
	@080,130 Button "Ok" 		of oDlg Size 30,10 Pixel Action (lStatus:= ProcessInformacoes(cNfFVendaOrdem, cSerieNfVendOrdem, dEmisNfVendOrdem, oDlg))
	@080,170 Button "Cancelar" 	of oDlg Size 30,10 Pixel Action(lStatus := .F., oDlg:End())
	
	Activate MsDialog oDlg Centered
	
Return lStatus


/**
 * Carrega as informações da Nf de venda de acordo com a chave
 **/
Static Function LoadDadosSF1(cNfFVendaOrdem,cSerieNfVendOrdem,dEmisNfVendOrdem)
	
	Local cWhere:= " R_E_C_N_O_ = " + cValToChar(SF1->(Recno())) +""
	
	cNfFVendaOrdem 	:= oSql:getFieldValue("SF1","F1_ZZNFVEN",cWhere)
	cSerieNfVendOrdem	:= oSql:getFieldValue("SF1","F1_ZZSEVEN",cWhere)
	dEmisNfVendOrdem	:= sTod(AllTrim(oSql:getFieldValue("SF1","F1_ZZDEMVE",cWhere)))

Return


/**
 * Processa as informações, validando as variaveis, e salvando na tabela SF1
 **/
Static Function ProcessInformacoes(cNfFVendaOrdem, cSerieNfVendOrdem, dEmisNfVendOrdem, oDlg)
	
	Local lStatus:=.F.
	
	If ValidInformacoes(cNfFVendaOrdem, cSerieNfVendOrdem, dEmisNfVendOrdem)
		SaveDadosNfOrder(cNfFVendaOrdem, cSerieNfVendOrdem, dEmisNfVendOrdem)
		oDlg:End()
		lStatus := .T.
	EndIf

Return lStatus


/**
 * Valida se os campos não estão vazios
 **/
Static Function ValidInformacoes(cNfFVendaOrdem, cSerieNfVendOrdem, dEmisNfVendOrdem, oDlg)
	
	Local lStatus 		:= .T.
	Local aPartes := StrToKarr(dToc(dEmisNfVendOrdem),"/")
	
	
	If Empty(cNfFVendaOrdem)
		lStatus:=.F.
		MsgInfo("Campo Número da NF em branco")
	ElseIf Empty(cSerieNfVendOrdem)
		lStatus:=.F.
		MsgInfo("Campo Série da NF em branco")
	Else
		For nI := 1 To Len(aPartes)
			If Empty(aPartes[nI])
				MsgInfo("Campo data em branco")
				lStatus:=.F.
				exit
			EndIf
		Next nI
	EndIf

Return lStatus


/**
* Salva as informações:  NF Venda à Ordem, Serie da NF Venda à Ordem,  Dt. Emissão da NF Venda à Ordem
**/
Static Function SaveDadosNfOrder(cNfFVendaOrdem, cSerieNfVendOrdem, dEmisNfVendOrdem)

	Local nRecno 			:= SF1->(Recno())	
	
	lUpdOk := oSql:update("SF1", "F1_ZZNFVEN = '"+cNfFVendaOrdem+"',F1_ZZSEVEN = '"+cSerieNfVendOrdem+"',F1_ZZDEMVE = '"+dTos(dEmisNfVendOrdem)+"'",;
		"R_E_C_N_O_ =" +AllTrim(Str(nRecno)))

Return


/*
** Valida de exibe pergunta
*/
Static Function vldPerg()
	Local cQuery  	:= ""	
	Local lRet		:= .f.
	Local oSqlUtil 	:= IpSqlObject():newIpSqlObject()
	
	cQuery := "SELECT D1_ZZCFOP, D1_TIPO "                                  +CRLF
	cQuery += "FROM %SF1.SQLNAME%"                                          +CRLF
	cQuery += "INNER JOIN %SD1.SQLNAME%"                                    +CRLF
	cQuery += "ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND"            +CRLF
	cQuery += "   D1_SERIE = F1_SERIE AND F1_FORNECE = D1_FORNECE AND"      +CRLF
	cQuery += "   D1_LOJA = F1_LOJA AND"                                    +CRLF                                       
	cQuery += "   %SD1.NOTDEL%"                                             +CRLF	
	cQuery += "INNER JOIN %SB1.SQLNAME%"                                    +CRLF
	cQuery += "ON B1_FILIAL = '%SB1.FILIAL%' AND"                           +CRLF 
	cQuery += "   B1_COD = D1_COD AND %SB1.NOTDEL%"                         +CRLF
	cQuery += "WHERE F1_FILIAL  = '%SF1.FILIAL%' AND"                       +CRLF
	cQuery += "      F1_DOC     = '"+cNota+"'    AND"                       +CRLF
	cQuery += "      F1_SERIE   = '"+cSerie+"'   AND"                       +CRLF
	cQuery += "      F1_FORNECE = '"+cClieFor+"' AND"                       +CRLF
	cQuery += "      F1_LOJA    = '"+cLoja+"'    AND"                       +CRLF
	cQuery += "      %SF1.NOTDEL%"                                          +CRLF
	
	oSqlUtil:newAlias(cQuery)
	
	if oSqlUtil:hasRecords()
		If AllTrim(oSqlUtil:getValue("D1_ZZCFOP")) $ GetNewPar("ZZ_TEIP190", "")
			lRet 	:= .t.
		EndIf
	endif
	
	oSqlUtil:close()

Return (lRet)