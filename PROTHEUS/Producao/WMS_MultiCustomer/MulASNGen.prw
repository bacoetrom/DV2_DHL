#include "totvs.ch"
#include "dhl.ch"

#define LOG_MSG_FALHA "Falha ao gerar interface ASN"
#define ERRO_QUERY    1
#define ERRO_UPDATE   2

/*/{Protheus.doc} MulASNGen

Função responsável por gerar a interface ASN
	
@author Winston Dellano de Castro - Thiago Meschiatti
@since 07/11/2014 - 10/02/17

@param cSerie, String, Série da Nota Fiscal de Entrada  
@param cNota, String, Número da Nota Fiscal de Entrada
@param cClieFor, String, Fornecedor da Nota Fiscal de Entrada
@param cLoja, String, Loja do Fornecedor
/*/
user function MulASNGen()

	local lWhite        := nil

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
	local cToPartner   := alltrim(GetNewPar("ZZ_ASNPART", "DHL_MULT01_P"))//OUT_TOPARTNER
	local cQuantity    := ""
	local cPackingInd  := SuperGetMV("ZZ_PACKIND",,.F.)
	
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
	cXmlFile += '			<CUSTOMER>' + getCustomer() + '</CUSTOMER>'                    + CRLF
	cXmlFile += '			<REFERENCE>' + cReference + '</REFERENCE>'                     + CRLF
	cXmlFile += '		</FILEHEADER>'                                                     + CRLF
	
	while oSql:notIsEof()
	
		IncProc()
	
		cQuantity := Alltrim(oUtils:strAnyType((cQueryAlias)->QUANTITY))
		
		cXmlFile += '		<FILEITEM>'                                                    				+ CRLF
		cXmlFile += '			<ITEM>' + AllTrim((cQueryAlias)->ITEM) + '</ITEM>'         				+ CRLF
		cXmlFile += '			<QUANTITY>' + cQuantity + '</QUANTITY>'                    				+ CRLF
		cXmlFile += '			<UOM>' + (cQueryAlias)->UOM + '</UOM>'                					+ CRLF
		If	cPackingInd //Para Packaging com DLX é necessário enviar os dados do lote
			cXmlFile += '			<LOT>' + AllTrim((cQueryAlias)->LOTE) + '</LOT>'                							+ CRLF
			cXmlFile += '			<SUBLOT>' + AllTrim((cQueryAlias)->SUBLOTE) + '</SUBLOT>'                				+ CRLF
			cXmlFile += '			<EXPIRATION_DATE>' + AllTrim((cQueryAlias)->EXPIRATION_DATE) + '</EXPIRATION_DATE>'		+ CRLF
			cXmlFile += '			<MANUFACTURE_DATE>' + AllTrim((cQueryAlias)->MANUFACTURE_DATE) + '</MANUFACTURE_DATE>'	+ CRLF
			cXmlFile += '			<PLANT_ID>' + AllTrim((cQueryAlias)->PLANT_ID) + '</PLANT_ID>'							+ CRLF
		EndIf
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
		cCustomer := Alltrim((cQueryAlias)->CUSTOMER) //Emerson Holanda 25/08/25 - Retirado os possiveis espaços retornados pelo banco
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
return AllTrim(oSql:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '" + APP_NULOGY + "'"))


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
	local cPackingInd  := SuperGetMV("ZZ_PACKIND",,.F.) 
	
	cQuery := "SELECT"                                                    +CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "      A1_CGC           VENDOR,"                        +CRLF
	else
		cQuery += "      A2_CGC           VENDOR,"                        +CRLF
	endif
	If	cPackingInd //Para Packaging com DLX é necessário enviar os dados do lote
		cQuery += "  	D1_LOTECTL			  LOTE,	"					  +CRLF
		cQuery += "  	D1_NUMLOTE			  SUBLOTE,	"				  +CRLF
		cQuery += "  	D1_DTVALID			  EXPIRATION_DATE,	"		  +CRLF
		cQuery += " 	D1_ZZDFABR 			  MANUFACTURE_DATE, "  		  +CRLF
		cQuery += " 	B1_ZZPLANT 			  PLANT_ID, "  				  +CRLF
	EndIf
	cQuery += "      '"+cCnpj+"'      PURCHASER,"                         +CRLF
	cQuery += "      RTRIM(F1_DOC)   ||'_'||"                             +CRLF
	cQuery += "      RTRIM(F1_SERIE) ||'_'||"                             +CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "      A1_CGC           REFERENCE,"                     +CRLF
	else
		cQuery += "      A2_CGC           REFERENCE,"                     +CRLF
	endif
	if AllTrim(cTipo) $ "D/B"
		cQuery += "      SUBSTR(A1_ZZCLCGC,1,8)           CUSTOMER,"                  +CRLF
	else
		cQuery += "      SUBSTR(A2_ZZCLCGC,1,8)           CUSTOMER,"                  +CRLF
	endif
	cQuery += "      B1_COD           ITEM,"                              +CRLF      
	cQuery += "      D1_UM         	  UOM,"                               +CRLF
	cQuery += "      SUM(D1_QUANT)    QUANTITY"                           +CRLF
	cQuery += "FROM %SF1.SQLNAME%"                                        +CRLF
	cQuery += "INNER JOIN %SD1.SQLNAME%"                                  +CRLF
	cQuery += "ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND"          +CRLF
	cQuery += "   D1_SERIE = F1_SERIE AND F1_FORNECE = D1_FORNECE AND"    +CRLF
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
		If cPackingInd
			cQuery += "GROUP BY A1_CGC, D1_LOTECTL, D1_NUMLOTE, D1_DTVALID, D1_ZZDFABR, B1_ZZPLANT, F1_DOC, F1_SERIE, A1_ZZCLCGC, B1_COD, D1_UM	"  	+CRLF
		Else
			cQuery += "GROUP BY A1_CGC,   F1_DOC,F1_SERIE, A1_ZZCLCGC,  B1_COD,  D1_UM	"  	+CRLF
		EndIF	
	else
		If cPackingInd
			cQuery += "GROUP BY A2_CGC, D1_LOTECTL, D1_NUMLOTE, D1_DTVALID, D1_ZZDFABR, B1_ZZPLANT, F1_DOC, F1_SERIE, A2_ZZCLCGC, B1_COD, D1_UM	"  	+CRLF
		Else
			cQuery += "GROUP BY A2_CGC,   F1_DOC,F1_SERIE, A2_ZZCLCGC,  B1_COD,  D1_UM	"   +CRLF
		EndIf	
	endif

return cQuery


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
