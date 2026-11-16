#include "totvs.ch"
#include "dhl.ch"

#define LOG_MSG_FALHA "Falha ao gerar interface ASN"
#define ERRO_QUERY    1
#define ERRO_UPDATE   2


/*/{Protheus.doc} AgeAsnGen
Geração da ASN Generate

@author Thiago Meschiatti
@since 18/08/2016
@version undefined

@type function
/*/
user function _AgeAsnGen()

	local lWhite        := nil

	private oSql        := ipSqlObject():newIpSqlObject()
	private oFile       := IpFileObject():newIpFileObject()
	private oUtils      := IpUtilsObject():newIpUtilsObject()
	private oLog			:= DHLLogManager():newDHLLogManager()
	private oParambox	  := nil
	private cSerie      := SF1->F1_SERIE
	private cNota       := SF1->F1_DOC
	private cClieFor    := SF1->F1_FORNECE
	private cLoja       := SF1->F1_LOJA
	private cTipo       := SF1->F1_TIPO
	private cXmlFile    := ""
	private cQueryAlias := ""
	private cReference  := ""
	private cFileName   := ""
	
	//Julio Lisboa - 25/08/2016
	If ExistBlock("verCFRemSim")
		If U_verCFRemSim()

            _cFunName := "_AgeASNGen"
            _cMsg     := "A nota [" + SF1->F1_DOC + "/" + SF1->F1_SERIE + "] tem CFOP de Remessa Simbólica [" + GetNewPar( "ZZ_CFREMSI" , "5934" ) + "]."
            _cDoc1    := SF1->F1_DOC
            _cDoc2    := SF1->F1_SERIE
            _cDoc3    := ""
            _cCodMsg  := "01"
            If lNewAge .And. lAutomatic
               If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
			      setFileLog(" ","fail",_cMsg)
			   EndIf
			Else
	           setFileLog(" ","fail",_cMsg)
		    EndIf

			FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "A nota [" + SF1->F1_DOC + "/" + SF1->F1_SERIE + "] tem CFOP de Remessa Simbólica [" + GetNewPar( "ZZ_CFREMSI" , "5934" ) + "].", 0, 0, {})
			Return
		EndIf
	EndIf
	
	runQueryData()
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Resultado SQL - !EOF: " + oSql:cLastQuery, 0, 0, {})
	
	if oSql:notIsEof()
	
		cQueryAlias := oSql:getAlias()
		if (cQueryAlias)->TYPE == 'N'
			cReference := retRefArq()
			
			if empty(cReference)
               _cFunName := "_AgeASNGen"
               _cMsg     := "ASN não enviada! Não foi informado o Cliente da cobertura para nota [" + SF1->F1_DOC + "/" + SF1->F1_SERIE + "]"
               _cDoc1    := SF1->F1_DOC
               _cDoc2    := SF1->F1_SERIE
               _cDoc3    := ""
               _cCodMsg  := "02"
               If lNewAge .And. lAutomatic
                  If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
			         setFileLog(" ","fail",_cMsg)
			      EndIf
			   Else
	              setFileLog(" ","fail",_cMsg)
		       EndIf

			   FWLogMsg("ERROR", , "BusinessObject", funName(), "", "01", "ASN não enviada! "+CRLF+"Não foi informado o Cliente da cobertura para nota [" + SF1->F1_DOC + "/" + SF1->F1_SERIE + "] .", 0, 0, {})
			   Return
			endif
		else	
			cReference  := AllTrim((cQueryAlias)->REFERENCE)
		endif
		cFileName   := getFileName(cReference)
		
		oFile:setFile(cFileName)
		
		if oFile:exists()
			oFile:delete()
		endif
		
		Processa({|| MountTags()})
		
		lWhite := oFile:writeLine(cXmlFile)
		
		if lWhite
			FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Arquivo "+oFile:getFileName(.T.)+" gravado com sucesso!", 0, 0, {})
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
	
	FWLogMsg("ERROR", , "BusinessObject", funName(), "", "01", aMsgError[nError][1], 0, 0, {})
			   
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
	cXmlFile += '			<CUSTOMER>' + cCustomer + '</CUSTOMER>'          + CRLF
	cXmlFile += '			<REFERENCE>' + cReference + '</REFERENCE>'                     + CRLF
	cXmlFile += '			<ASN_TYPE>' + (cQueryAlias)->TYPE + '</ASN_TYPE>'              + CRLF
	cXmlFile += '		</FILEHEADER>'                                                     + CRLF
	
	while oSql:notIsEof()
	
		IncProc()
	
		cQuantity := Alltrim(oUtils:strAnyType((cQueryAlias)->QUANTITY))
		
		cXmlFile += '		<FILEITEM>'                                                    + CRLF
		cXmlFile += '			<ITEM>' + getPrdDepara(AllTrim((cQueryAlias)->ITEM)) + '</ITEM>' + CRLF
		cXmlFile += '			<QUANTITY>' + cQuantity + '</QUANTITY>'                    + CRLF
		cXmlFile += '			<UOM>' + (cQueryAlias)->UOM + '</UOM>'                     + CRLF
		cXmlFile += '			<LOT>' + AllTrim((cQueryAlias)->LOT) + '</LOT>'            + CRLF
		cXmlFile += '		</FILEITEM>'                                                   + CRLF
		
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
	local cFileName := oUtils:concatDirectory(cFolder,"ASN_"+AllTrim(cReference)+".XML")
	
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
		cQuery += "      A1_CGC           VENDOR,"                        +CRLF
	else
		cQuery += "      A2_CGC           VENDOR,"                        +CRLF
	endif
	cQuery += "      '"+cCnpj+"'      PURCHASER,"                         +CRLF
	cQuery += "      RTRIM(F1_DOC)   ||'_'||"                             +CRLF
	cQuery += "      RTRIM(F1_SERIE) ||'_'||"                             +CRLF
	if AllTrim(cTipo) $ "D/B"
		cQuery += "      A1_CGC           REFERENCE,"                     +CRLF
	else
		cQuery += "      A2_CGC           REFERENCE,"                     +CRLF
	endif
	cQuery += "      F1_ZZCNPJ        CUSTOMER,"                  		  +CRLF
	cQuery += "      B1_COD           ITEM,"                              +CRLF      
	cQuery += "      D1_UM UOM,"										  +CRLF
	cQuery += "      SUM(D1_QUANT)    QUANTITY,"                          +CRLF
	cQuery += "      F1_TIPO    	  TYPE,"	                          +CRLF
	cQuery += "      D1_LOTECTL    	  LOT"	                          	  +CRLF
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
		cQuery += "GROUP BY A1_CGC,F1_DOC,F1_SERIE,B1_COD,F1_ZZCNPJ,D1_UM,D1_ZZCFOP,F1_TIPO,D1_LOTECTL"       +CRLF
	else
		cQuery += "GROUP BY A2_CGC,F1_DOC,F1_SERIE,B1_COD,F1_ZZCNPJ,D1_UM,D1_ZZCFOP,F1_TIPO,D1_LOTECTL"       +CRLF
	endif

return cQuery


/*
** Retorna, caso necessário, referefencia para nome do arquivo
*/
static function retRefArq()
	
	local lChangeRef	:= changeRef()
	local aRef		:= strTokarr((cQueryAlias)->REFERENCE, "_")
	local cCodCli		:= ""
	local cLojCli		:= ""
	local cRet		:= ""
	
	if lChangeRef
		if showParam()
			cCodCli  := oParamBox:getValue("cliente")
			cLojCli  := oParamBox:getValue("loja")
			
			cRet := aRef[1] + "_" + aRef[2] + "_" + retCnpjCli(cCodCli, cLojCli)
		endif
	else
		cRet := (cQueryAlias)->REFERENCE
	endif
return (cRet)


/*
** Função responsável por validar se fornecedor precisar informar cliente no envio da ASN
*/
static function changeRef()
	
	local aAreaSA2	:= SA2->(GetArea())
	local oSqlAux		:= IpSqlObject():newIpSqlObject()
	local lChangeRef 	:= .f.
	
	dbSelectArea("SA2")
	
	if SA2->(FieldPos("A2_ZZCLASN")) > 0 
		lChangeRef := oSqlAux:getFieldValue("SA2", "A2_ZZCLASN", " %SA2.XFILIAL% AND A2_CGC = '" + (cQueryAlias)->VENDOR + "' ") == "S"
	endif
	
	oSqlAux:close()
	
	RestArea(aAreaSA2)
return (lChangeRef)


/*
*	Função responsável pela exibição da tela de parâmetros.
*/
static function showParam()
	local cNome		:= "Cliente ASN"
	local cTitulo		:= "Informo Cliente da Cobertura Fiscal"
	
	oParamBox 	:= IpParamBoxObject():newIpParamBoxObject(cNome)
	
	oParamBox:setTitle(cTitulo)
	
	oParam := IpParamObject():newIpParamObject("cliente", "get", "Cliente", "C", 6, TamSx3("A1_COD")[1])
	oParam:setRequired(.T.)
	oParam:setF3("SA1") 
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("loja", "get", "Loja", "C", 9, TamSx3("A1_LOJA")[1])
	oParam:setRequired(.T.)
	oParamBox:addParam(oParam)
	
return oParamBox:show()


/*
** Retorna CNPJ do Cliente
*/
static function retCnpjCli(cCodCli, cLojCli) 
	
	local oSqlAux		:= IpSqlObject():newIpSqlObject() 
	local cRet		:= ""
	
	cRet := oSqlAux:getFieldValue("SA1", "A1_CGC", " %SA1.XFILIAL% AND A1_COD = '" + cCodCli + "' AND A1_LOJA = '" + cLojCli + "'") 
return (cRet)

/**
* Obtém o código do produto do depara (SA7)
**/
static function getPrdDepara(cProduto, cCnpjCli)
	
	local oDhlPrdDepara := DhlPrdDepara():newDhlPrdDepara()
	default cCnpjCli	:= ""
	
	cProduto := oDhlPrdDepara:getPrdCliente(cProduto, cCnpjCli)
	
return allTrim(cProduto)

static function setFileLog(cFile,cLogType,cLogText,cTag,cValue)
	
	local cInterface := "IMPORTADOR XML"
	
	oLog:start(APP_DLX,DHL_IMPORTACAO,cFile)
	
	if !(Empty(cTag))
		cLogText += CRLF+CRLF+"Tag: "+cTag
	endIf
	
	if !(Empty(cValue))
		cLogText += CRLF+CRLF+"Valor: "+cValue
	endIf
	
	if (cLogType == "fail")
		oLog:fail(cInterface, cLogText)
	elseIf (cLogType == "warn")
		oLog:warn(cInterface, cLogText)
	endIf
	
return

