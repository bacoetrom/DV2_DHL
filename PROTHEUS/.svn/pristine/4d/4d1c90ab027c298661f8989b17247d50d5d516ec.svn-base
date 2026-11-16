#include 'Protheus.ch'
#include "dhl.ch"

/*/{Protheus.doc} PrcCancMsa

Rotina responsável pela geração do arquivo de cancelamento.
	
@author Diego de Angelo
@since 10/11/2014

@param cType		, String	, Informa o tipo (2=Entrada e 1=Saída)
@param cKey		, String, Chave da NFE
@param cSeries		, String	, Série da Nota 
@param cInvoice	, String	, Documento 
@param cCustSupl	, String	, Cliente / Fornecedor
@param cBranch		, String	, Loja
@param cInvOri		, String	, Nota de Origem
@param cSeriesOri	, String	, Série do Documento de Origem

/*/
user function PrcCancMsa(cType, cKey, cInvoice, cSeries, cCustSupl, cBranch)
	local oTxtFile		:= nil
	local lRet			:= .T.
	local lSerCont		:= aScan(separa(GetNewPar("ZZ_SERCONT", ""), ";"), {|x| x == upper(alltrim(cSeries))}) > 0
	private oArquivo 	:= MsafNFeTag():newMsafNFeTag("arquivo")
	private cKeyInv		:= cKey
	private cCnpj		:= SM0->M0_CGC
	private cInsc		:= SM0->M0_INSC
	private cNrInvoice	:= cInvoice
	private cNrSeries	:= cSeries
	private cTypeInv	:= cType
	private cCodSupCust	:= cCustSupl
	private cCodBranch	:= cBranch
	private cCodMsg		:= SuperGetMv("ZZ_CODMSG",, "110111")
	private cReasonCanc	:= SuperGetMv("ZZ_JUSTNFE",, "Nota emitida incorretamente.")
	
	if !lSerCont
		mountTags()
		
		oTxtFile := MsafNfeFile():newMsafNfeFile(oArquivo)
		
		lRet	:= oTxtFile:createTxt(DHL_NFE_GENERATE_CANCELLATION, cNrInvoice, cNrSeries)
	endif
	
	if lRet
		recordKeyNfe()
		if !lSerCont
			Aviso("AVISO","Esta nota sera cancelada quando o retorno do SEFAZ for processado",{"OK"})
		endif		
	endIf

return


/**
* Instancia o objeto que representa a tag "nota_cancelada" 
**/ 
static function DoNotaCancelada()

	oNota := MsafNFeTag():newMsafNFeTag("nota_cancelada")
	
	oNota:setAttributeValue("versao"			, DHL_NFE_VERSION	)
	oNota:setAttributeValue("Chave"				, cKeyInv			)
	oNota:setAttributeValue("CNPJ"				, cCnpj				)
	oNota:setAttributeValue("Docstat"			, cCodMsg			)
	oNota:setAttributeValue("xJustificativa"	, cReasonCanc		)
	oNota:setAttributeValue("IE"				, cInsc				)

	oArquivo:addElementNode(oNota)
return


/**
* Cria as Instancias do MsafNFetag que representam o xml da nota fiscal
**/
static function mountTags()
	private oNota		:= nil
	
	DoNotaCancelada()
return


/*
*	Função responsável pela gravação do campo SF1/SF2_CHVNFE.
*/
static function recordKeyNfe()
	local cTypeDoc	:= ""
	local cMsgLog		:= ""
	local oSqlUtil 	:= IpSqlObject():newIpSqlObject()
	local oLog			:= DHLLogManager():newDHLLogManager()
	local lRet			:= .T.
	
	if cTypeInv == DHL_NFE_INVOICE_INFLOW
		cTypeDoc	:= " entrada"
		lRet	:= oSqlUtil:update("SF1", "F1_FIMP = 'C'", "F1_DOC = '"+cNrInvoice+"' AND " +;
																								"F1_SERIE = '"+cNrSeries+"' AND " +;
																								"F1_FILIAL = '%SF1.FILIAL%' AND " +;
																								"F1_FORNECE ='"+cCodSupCust+"' AND " +;
																								"F1_LOJA ='"+cCodBranch+"' ")
	elseif cTypeInv == DHL_NFE_INVOICE_OUTFLOW
		cTypeDoc	:= " saída"
		lRet	:= oSqlUtil:update("SF2", "F2_FIMP = 'C'", "F2_DOC = '"+cNrInvoice+"' AND " +;
																								"F2_SERIE = '"+cNrSeries+"' AND "+;
																								"F2_FILIAL = '%SF2.FILIAL%' AND "+;
																								"F2_CLIENTE ='"+cCodSupCust+"' AND "+;
																								"F2_LOJA ='"+cCodBranch+"' ")
	endIf
	
	if !lRet
		cMsgLog := "Erro ao gravar a chave para a nota de "+cTypeDoc+ cNrInvoice + " Série " + cNrSeries + " For /Cli " + cCodSupCust + " Loja "+ cCodBranch
		oLog:start(APP_MASTERSAF_NFE, DHL_EXPORTACAO)
		oLog:fail("Gravação Chave NFe", cMsgLog )
	endIf
return