#include "totvs.ch"
#include "dhl.ch"

#define LOG_MSG_FALHA "Falha ao gerar interface ASN"
#define ERRO_QUERY    1
#define ERRO_UPDATE   2

/*/{Protheus.doc} ASNGenerate

Função responsável por gerar a interface ASN 
	
@author Winston Dellano de Castro
@since 07/11/2014

@param cSerie, String, Série da Nota Fiscal de Entrada  
@param cNota, String, Número da Nota Fiscal de Entrada
@param cClieFor, String, Fornecedor da Nota Fiscal de Entrada
@param cLoja, String, Loja do Fornecedor
/*/
user function DisAsnGen()

	local lWhite        := nil
	
	private aRet		:= {}
	private oSql        := ipSqlObject():newIpSqlObject()
	private oFile       := IpFileObject():newIpFileObject()
	private oUtils      := IpUtilsObject():newIpUtilsObject()
	private oLog		:= DHLLogManager():newDHLLogManager()
	private cSerie      := SF1->F1_SERIE
	private cNota       := SF1->F1_DOC
	private cClieFor    := SF1->F1_FORNECE
	private cLoja       := SF1->F1_LOJA
	private cTipo       := SF1->F1_TIPO
	private cXmlFile    := ""
	private cQueryAlias := ""
	private cReference  := ""
	private cChaveAcesso := SF1->F1_CHVNFE
	private cFileName   := ""
	private cAutomatic	:= ""
	
	If cTipo=="N"
		
		If vldPedCom()
			If !Perguntas()
				Return
			EndIf
		Else
			Return
		Endif
		
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
* Salva as informações:  NF Venda à Ordem, Serie da NF Venda à Ordem,  Dt. Emissão da NF Venda à Ordem
**/
Static Function SaveDadosNfOrder(cNfFVendaOrdem, cSerieNfVendOrdem, dEmisNfVendOrdem)

	Local nRecno 			:= SF1->(Recno())	
	
	lUpdOk := oSql:update("SF1", "F1_ZZNFVEN = '"+cNfFVendaOrdem+"',F1_ZZSEVEN = '"+cSerieNfVendOrdem+"',F1_ZZDEMVE = '"+dTos(dEmisNfVendOrdem)+"'",;
		"R_E_C_N_O_ =" +AllTrim(Str(nRecno)))

Return


/**
* Retorna o CGC do cliente
**/
Static Function getCGCCliente()
	
	Local aArea		:=GetArea()
	Local aAreaSA7	:= SA7->(GetArea())
	
	//A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
	
	SA7->(RestArea(aAreaSA7))
	RestArea(aArea)

Return


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
	
	//Aviso(FunDesc(),oSql:getLastError(),{"OK"},3)
	//Aviso(FunDesc(),oSql:getLastQuery(),{"OK"},3)
	
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
	
	oLog:start(APP_NULOGY,DHL_EXPORTACAO,cFileName)
	oLog:fail(LOG_MSG_FALHA,aMsgError[nError][1])
	
return


/**
* Monta o arquivo xml da interface ASN
**/
static function MountTags()

	local cFromPartner := OUT_FROMPARTNER
	local cToPartner   := alltrim(GetNewPar("ZZ_ASNPART", "DLX"))//OUT_TOPARTNER
	local cQuantity    := ""
	Local aDados	   := {}
	
	ProcRegua(oSql:count())
	
	cXmlFile := '<?xml version="1.0" encoding="UTF-8"?>'                                   + CRLF
	cXmlFile += '<ASN>'                                                                    + CRLF
	cXmlFile += '	<HEADER>'                                                              + CRLF
	cXmlFile += '		<DATETIME DATETIMEQUALIFIER="on">' + getDateTime() + '</DATETIME>' + CRLF
	cXmlFile += '		<FROM>'                                                            + CRLF
	cXmlFile += '			<PARTNERNAME>' + cFromPartner + '</PARTNERNAME>'               + CRLF
	cXmlFile += '		</FROM>'                                                           + CRLF
	cXmlFile += '		<TO>'                                                              + CRLF
	cXmlFile += '			<PARTNERNAME>' + cToPartner + '</PARTNERNAME>'                 + CRLF
	cXmlFile += '		</TO>'                                                             + CRLF
	cXmlFile += '	</HEADER>'                                                             + CRLF
	cXmlFile += '	<BODY>'                                                                + CRLF
	cXmlFile += '		<FILEHEADER>'                                                      + CRLF
	cXmlFile += '			<VENDOR>' + (cQueryAlias)->VENDOR + '</VENDOR>'                + CRLF
	cXmlFile += '			<PURCHASER>' + Alltrim((cQueryAlias)->PURCHASER) + '</PURCHASER>'       + CRLF
	cXmlFile += '			<CUSTOMER>' + AllTrim(GetAmarracaoSA7()) + '</CUSTOMER>'       + CRLF
	cXmlFile += '			<REFERENCE>' + cReference + '</REFERENCE>'                     + CRLF
	cXmlFile += '			<NFE_ACCESS_KEY>' + cChaveAcesso + '</NFE_ACCESS_KEY>'         + CRLF
	
	aDados:= GetPedidoSD1()
	
	cXmlFile += '			<AUTOMATIC>' + AllTrim(aDados[8]) + '</AUTOMATIC>'             + CRLF
	cXmlFile += '			<INVOICE_TYPE>' + AllTRim(cTipo) + '</INVOICE_TYPE>'           + CRLF
	cXmlFile += '		</FILEHEADER>'                                                     + CRLF
	
	while oSql:notIsEof()
	
		IncProc()
		aDados		:= GetPedidoSD1()
		cQuantity 	:= Alltrim(oUtils:strAnyType((cQueryAlias)->QUANTITY))
		
		cXmlFile += '		<FILEITEM>'                                                    				+ CRLF
		cXmlFile += '			<ITEM>' + AllTrim((cQueryAlias)->ITEM) + '</ITEM>'         				+ CRLF
		cXmlFile += '			<QUANTITY>' + cQuantity + '</QUANTITY>'                    				+ CRLF
		cXmlFile += '			<UOM>' + (cQueryAlias)->UOM + '</UOM>'                     				+ CRLF
		cXmlFile += '			<LOT>' 	   + AllTrim((cQueryAlias)->LOTE) + '</LOT>'                   	+ CRLF
		cXmlFile += '			<SUBLOT>' + AllTrim(aDados[5]) + '</SUBLOT>'                     		+ CRLF
		If Empty((cQueryAlias)->LOTE)
			cXmlFile += '			<EXPIRATION_DATE>' + "" + 				'</EXPIRATION_DATE>'     	+ CRLF
		Else
			cXmlFile += '			<EXPIRATION_DATE>' + AllTrim(aDados[4]) + '</EXPIRATION_DATE>'     	+ CRLF
		EndIf
		cXmlFile += '			<MANUFACTURE_DATE>' + AllTrim(aDados[3])+ '</MANUFACTURE_DATE>'   		+ CRLF
		cXmlFile += '			<PURCHASE_ORDER>' + AllTrim(aDados[7]) + '</PURCHASE_ORDER>'       		+ CRLF
		cXmlFile += '			<PURCHASE_ORDER_ITEM>' + AllTrim(aDados[9]) + '</PURCHASE_ORDER_ITEM>'  + CRLF
		cXmlFile += '			<PO_CUSTOMER>' + AllTrim(aDados[1]) + '</PO_CUSTOMER>'                	+ CRLF
		cXmlFile += '			<UNIT_PRICE>' + AllTRim(aDados[2]) + '</UNIT_PRICE>'                    + CRLF
		cXmlFile += '		</FILEITEM>'                                                   				+ CRLF
		
		oSql:skip()
				
	enddo
	
	cXmlFile += '	</BODY>'                                                               + CRLF
	cXmlFile += '</ASN>'                                                                   + CRLF
		
return




/**
* Retorna o CNPJ do customer
**/
static function getCustomer()

	local cCustomer := ""
	
	if empty((cQueryAlias)->CUSTOMER)
		cCustomer := AllTrim(GetMv("ZZ_CUSTOME"))
	else
		cCustomer := (cQueryAlias)->CUSTOMER
	endif
	
return cCustomer


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
* Retorna a string com a data formatada AAAA-MM-DD
**/
static function getDateHDL(cData)
	
	local aPartes	:= {}
	local cNewDate  := ""
	
	If !Empty(cData)
		cNewDate	:= dToc(sTod(cData))
		aPartes	:= StrToKarr(cNewDate,"/")
		cNewDate:= aPartes[1]+"-"+aPartes[2]+"-"+aPartes[3]
	EndIf
	
return cNewDate

Static Function GetPedidoSD1()
	
	Local cQuery		:= ""
	Local oSqlSD1       := ipSqlObject():newIpSqlObject()
	Local cZZAuto		:= ""
	Local cZZPOEXT		:= ""
	Local cVUnit		:= ""
	Local cDataFabri	:= ""
	Local cDataValid	:= ""
	Local cSubLote		:= ""
	Local cLote			:= ""
	Local cPedido		:= ""
	Local aRetDados		:= {}
	Local cItem			:= ""
	Local cQuerySD1		:= ""
	
	
	cQuery := " SELECT "								 + CRLF
	cQuery += " D1_DOC DOCUMENTO, "						 + CRLF
	cQuery += " D1_PEDIDO PEDIDO, "						 + CRLF
	cQuery += " D1_ITEMPC ITEM, "						 + CRLF
	cQuery += " D1_LOTECTL LOTE, "						 + CRLF
	cQuery += " D1_NUMLOTE SUBLOTE, "				 	 + CRLF
	cQuery += " D1_DTVALID DATAVALID, "				 	 + CRLF
	cQuery += " D1_ZZDFABR DATAFABRI, "				 	 + CRLF
	cQuery += " D1_VUNIT VALORUNIT, "				 	 + CRLF
	
	
	cQuery += " C7_ZZAUTO AUTOMATIC, "					 + CRLF
	cQuery += " C7_ZZPOEXT POEXT "					 	 + CRLF
	cQuery += " FROM %SD1.SQLNAME%"  					 + CRLF
	cQuery += " LEFT JOIN %SC7.SQLNAME% ON "             + CRLF
	cQuery += " C7_FILIAL 	= '%SC7.FILIAL%' AND " 		 + CRLF
	cQuery += " C7_NUM 		= D1_PEDIDO AND "  			 + CRLF
	cQuery += " C7_ITEM 	= D1_ITEMPC AND "            + CRLF
	cQuery += " %SC7.NOTDEL%"  						 	 + CRLF
	
	cQuery += " WHERE D1_FILIAL	= '%SD1.FILIAL%' AND"   			+ CRLF
	cQuery += " D1_SERIE  		= '"+cSerie+"' AND"   		 		+ CRLF
	cQuery += " D1_FORNECE		= '"+cClieFor+"' AND"           	+ CRLF
	cQuery += " D1_LOJA			= '"+cLoja+"' AND"   				+ CRLF
	cQuery += " D1_PEDIDO		= '"+(cQueryAlias)->PEDIDO+"' AND" 	+ CRLF
	cQuery += " D1_DOC			= '"+cNota+"' AND"    				+ CRLF
	cQuery += " D1_COD			= '"+(cQueryAlias)->ITEM+"' AND"   	+ CRLF
	cQuery += " D1_LOTECTL		= '"+(cQueryAlias)->LOTE+"' AND" 	+ CRLF
	cQuery += " %SD1.NOTDEL%"                            			+ CRLF

	oSqlSD1:newAlias(cQuery)
	cQuerySD1 	:= oSqlSD1:getAlias()
	
	
	//while oSqlSD1:notIsEof()
	cZZAuto		:= (cQuerySD1)->AUTOMATIC
	cItemPedido	:= (cQuerySD1)->ITEM
	
	
	cZZPOEXT	:= (cQuerySD1)->POEXT
	cVUnit		:= cValToChar((cQuerySD1)->VALORUNIT)
	cDataFabri	:= getDateHDL((cQuerySD1)->DATAFABRI)
	cDataValid	:= getDateHDL((cQuerySD1)->DATAVALID)
	cSubLote	:= (cQuerySD1)->SUBLOTE
	cLote		:= (cQuerySD1)->LOTE
	cPedido		:= (cQuerySD1)->PEDIDO
	cZZAuto		:= (cQuerySD1)->AUTOMATIC
	If Empty(cZZAuto)
		cZZAuto:="N"
	EndIf
	
		//aAdd(aRetDados, {cZZPOEXT, cVUnit, cDataFabri, cDataValid, cSubLote, cLote, cPedido, cZZAuto, cItemPedido})//Gustavo
	aRetDados:= {cZZPOEXT, cVUnit, cDataFabri, cDataValid, cSubLote, cLote, cPedido, cZZAuto, cItemPedido}//Gustavo
		//oSqlSD1:skip()
	//EndDo
	oSqlSD1:close()
	
	
Return aRetDados


/**
 * Retorna o CGC do cliente de acordo com o produto amarrado na tabela SC7
 **/
Static Function GetAmarracaoSA7()
	
	Local aArea			:= GetArea()
	Local aAreaSA1		:= SA1->(GetArea())
	Local cQuery		:= ""
	Local oSqlSA7       := ipSqlObject():newIpSqlObject()
	Local cCGC			:= ""
	Local cClienteSA7	:= ""
	Local cLojaSA7		:= ""
	Local cAliasSA7		:= ""
	
	
	cQuery := " SELECT "								 		+CRLF
	cQuery += " A7_CLIENTE CLIENTE, "							+CRLF
	cQuery += " A7_LOJA LOJA"						 	 		+CRLF
	cQuery += " FROM %SA7.SQLNAME%"  					 		+CRLF
	cQuery += " WHERE A7_FILIAL  = '%SA7.FILIAL%' AND"   		+CRLF
	cQuery += " A7_PRODUTO = '"+((cQueryAlias)->ITEM)+"' AND"  +CRLF
	cQuery += " %SA7.NOTDEL%"                            		+CRLF

	oSqlSA7:newAlias(cQuery)
	cAliasSA7 	:= oSqlSA7:getAlias()
	
	cClienteSA7	:=(cAliasSA7)->CLIENTE
	cLojaSA7	:=(cAliasSA7)->LOJA
	
	cCGC:= Posicione("SA1",1, XFILIAL('SA1')+cClienteSA7+cLojaSA7,"A1_CGC")
	
	oSqlSA7:close()
	
	SA1->(RestArea(aAreaSA1))
	RestArea(aArea)
	
Return cCGC


/**
 * Monta a Query que retornar os dados para a criação do arquivo
 **/
static function getQuery()

	local cQuery := ""
	local cCnpj  := SM0->M0_CGC
	
	cQuery := "SELECT"                                                    +CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "      A1_CGC           VENDOR,"                        +CRLF
	else
		cQuery += "      A2_CGC           VENDOR,"                        +CRLF
	endif
	cQuery += "  	D1_LOTECTL			  LOTE,	"					  	  +CRLF
	cQuery += "      '"+cCnpj+"'      PURCHASER,"                         +CRLF
	cQuery += "      RTRIM(F1_DOC)   ||'_'||"                             +CRLF
	cQuery += "      RTRIM(F1_SERIE) ||'_'||"                             +CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "      A1_CGC           REFERENCE,"                     +CRLF
	else
		cQuery += "      A2_CGC           REFERENCE,"                     +CRLF
	endif
	cQuery += "      F1_CHVNFE        CHAVEACESSO,"                       +CRLF
	cQuery += "      B1_COD           ITEM,"                              +CRLF
	cQuery += "      SUM(D1_QUANT)    QUANTITY,"                          +CRLF
	cQuery += "		 D1_UM         	UOM,"                                 +CRLF
	cQuery += "		 D1_PEDIDO        PEDIDO "                            +CRLF
	cQuery += "FROM %SF1.SQLNAME% "                                       +CRLF
	cQuery += "INNER JOIN %SD1.SQLNAME% "                                 +CRLF
	cQuery += "ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND "         +CRLF
	cQuery += "   D1_SERIE = F1_SERIE AND F1_FORNECE = D1_FORNECE AND "   +CRLF
	cQuery += "   %SD1.NOTDEL%"                                           +CRLF
	
	if AllTrim(cTipo) $ "D/B"
		cQuery += "INNER JOIN %SA1.SQLNAME%"                                  +CRLF
		cQuery += "ON A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = F1_FORNECE AND" +CRLF
		cQuery += "   A1_LOJA = F1_LOJA AND %SA1.NOTDEL%"                     +CRLF
	else
		cQuery += "INNER JOIN %SA2.SQLNAME%"                                  +CRLF
		cQuery += "ON A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = F1_FORNECE AND" +CRLF
		cQuery += "   A2_LOJA = F1_LOJA AND %SA2.NOTDEL%"                     +CRLF
	endif
	
	cQuery += "INNER JOIN %SB1.SQLNAME%"                                  +CRLF
	cQuery += "ON B1_FILIAL = '%SB1.FILIAL%' AND"                         +CRLF
	cQuery += "   B1_COD = D1_COD AND %SB1.NOTDEL%"                       +CRLF
	cQuery += "WHERE F1_FILIAL  = '%SF1.FILIAL%' AND"                     +CRLF
	cQuery += "      F1_DOC     = '"+cNota+"'    AND"                     +CRLF
	cQuery += "      F1_SERIE   = '"+cSerie+"'   AND"                     +CRLF
	cQuery += "      F1_FORNECE = '"+cClieFor+"' AND"                     +CRLF
	cQuery += "      F1_LOJA    = '"+cLoja+"'    AND"                     +CRLF
	cQuery += "      %SF1.NOTDEL%"                                        +CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "GROUP BY A1_CGC,D1_LOTECTL,A1_CGC,F1_CHVNFE,D1_UM,F1_DOC,F1_SERIE,B1_COD,D1_PEDIDO	"  	+CRLF
	else
		cQuery += "GROUP BY A2_CGC,D1_LOTECTL,A2_CGC,F1_CHVNFE,D1_UM,F1_DOC,F1_SERIE,B1_COD,D1_PEDIDO	"   +CRLF
	endif

return cQuery

/**
 * Tela de parametros para informar os dados da nota fiscal de venda à ordem
 **/
Static Function Perguntas()
	
	//Local lStatus			:= RpcSetEnv("10", "006DIS001663")
	Local oDlg				:= Nil
	Local cNumeroNF			:= ""
	Local cSerieNf			:= ""
	Local cData    			:= ""
	Local oNfFVendaOrdem 	:= Nil
	Local oSerieNfVendOrdem := Nil
	Local oEmisNfVendOrdem	:= Nil
	Local lStatus			:= .T.
	
	cNfFVendaOrdem 		:= Space(TamSx3("F1_ZZNFVEN")[1])
	cSerieNfVendOrdem	:= Space(TamSx3("F1_ZZSEVEN")[1])
	dEmisNfVendOrdem	:= cTod("")
	
	LoadDadosSF1(@cNfFVendaOrdem,@cSerieNfVendOrdem,@dEmisNfVendOrdem)
	
	Define MsDialog oDlg from 0,0 to 200,400 pixel Title "Nota fiscal de venda" //Style 128
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
 * Carrega as informações da Nf de venda de acordo com a chave
 **/
Static Function LoadDadosSF1(cNfFVendaOrdem,cSerieNfVendOrdem,dEmisNfVendOrdem)
	
	Local cWhere:= " R_E_C_N_O_ = " + cValToChar(SF1->(Recno())) +""
	
	cNfFVendaOrdem 		:= oSql:getFieldValue("SF1","F1_ZZNFVEN",cWhere)
	cSerieNfVendOrdem	:= oSql:getFieldValue("SF1","F1_ZZSEVEN",cWhere)
	dEmisNfVendOrdem	:= sTod(AllTrim(oSql:getFieldValue("SF1","F1_ZZDEMVE",cWhere)))

Return


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


/*
** Valida se todos os itens da pré-nota possuem pedidos de compra vinculados
*/  
Static Function vldPedCom()
	local oSql := IpSqlObject():newIpSqlObject()
	local lRet := .t.
	
	oSql:newAlias(retQryVld())
	
	while oSql:notIsEof()
		if empty(oSql:getValue("D1_PEDIDO"))
			lRet := .f.
			MsgStop("Documento possuí itens sem vínculo de Pedido de Compra!", "Erro ao enviar ASN Generate!")
			exit
		endif
		oSql:skip()
	end
	
	oSql:close()
	
Return (lRet)

/*
**
*/
Static Function retQryVld()
	Local cWhere := ""
	
	cWhere += "SELECT D1_PEDIDO "
	cWhere += "FROM %SF1.SQLNAME% "
	cWhere += "INNER JOIN %SD1.SQLNAME% ON "
	cWhere += "			D1_FILIAL 	= F1_FILIAL "
	cWhere += "		AND %SD1.NOTDEL% "
	cWhere += "		AND D1_DOC		= F1_DOC "
	cWhere += "		AND D1_SERIE	= F1_SERIE "  
	cWhere += "		AND D1_FORNECE	= F1_FORNECE "
	cWhere += "		AND D1_LOJA		= F1_LOJA "
	cWhere += "WHERE "
	cWhere += "		F1_FILIAL  		= '%SF1.FILIAL%'  "
	cWhere += "		AND %SF1.NOTDEL%  				  "
	cWhere += "		AND	F1_DOC     	= '"+cNota+"'     "
	cWhere += "		AND F1_SERIE   	= '"+cSerie+"'    "
	cWhere += "		AND F1_FORNECE 	= '"+cClieFor+"'  "
	cWhere += "		AND F1_LOJA    	= '"+cLoja+"'     "
	cWhere += "		AND F1_ZZSTATU 	= '"+DHL_DOC_PENDENTE_ACAO+"' "
	
Return (cWhere)