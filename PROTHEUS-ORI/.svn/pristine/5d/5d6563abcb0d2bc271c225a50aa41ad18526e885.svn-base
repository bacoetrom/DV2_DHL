#Include 'Protheus.ch'
#include "dhl.ch"

/*/{Protheus.doc} PrcRCOXml 

Rotina utilizada para a geração do arquivo de exportação para SAP
	
@author Augusto Krejci Bem-Haja
@since 22/05/2017

@param cType		, String	, Informa o tipo (2=Entrada e 1=Saída)
@param cSeries		, String	, Série da Nota 
@param cInvoice		, String	, Documento 
@param cCustSupl	, String	, Cliente / Fornecedor
@param cBranch		, String	, Loja
@param cInvOri		, String	, Nota de Origem
@param cSeriesOri	, String	, Série do Documento de Origem

@return TipoRet DescricaoRet
/*/
user function PrcRCOXml(cType, cSeries, cInvoice, cCustSupl, cBranch, cInvOri, cSeriesOri)										      			
	
	local oXmlUtil	:= nil
	local cString	:= ""
	local cXml		:= ""
	locaL cError	:= ""
	local cWarning	:= ""
	local cKeyNfe	:= ""
	local cVersion	:= DHL_NFE_VERSION
	local aDanfe	:= {}
	local lRet		:= .T.
	local oLog 		:= DHLLogManager():newDHLLogManager()
	local cMsgLog	:= "Erro ao obter a estrutura de dados para montagem do arquivo."
	local aAreaSF1  := SF1->(GetArea())
	local aAreaSF2  := SF2->(GetArea())
	private cMsgCli	:= ""
	private cMsgFis	:= ""
	private cMsgFci	:= ""
    
    aDanfe	:= ExecBlock("XmlNfeSef",.F.,.F.,{{cType,cVersao, cSeries, cInvoice, cCustSupl, cBranch,{}},cVersion, GetNewPar("ZZ_TPAMB", "2"),{cInvOri,cSeriesOri}})
	cKeyInv	:= 	getKeyNfe(cType)
	cXml  	:= aDanfe[2]
    
    RestArea(aAreaSF2)
	
	if empty(cXml)
		lRet	:= .F.
		oLog:start(APP_SAP, DHL_EXPORTACAO)
		oLog:fail("Erro na estrutura dos dados",cMsgLog)
		return
	endIf
	
//	MemoWrite("C:\totvs\nfetest_"+AllTrim(cInvoice)+"_"+AllTrim(cSeries)+".xml", cXml)
	
	If (FWUnitBusiness() == DHL_BUSINESSUNIT_AG2)
		cXml := StrTran(cXml, "&", "&amp;")
	EndIf
	
	oXmlUtil := IpXmlObject():newIpXmlObject(cXml)
	
	oXmlUtil:doParse()
	
	lRet := U_ProcRCOMsa(oXmlUtil, cKeyInv, cType, cSeries, cInvoice, cCustSupl, cBranch)
	
	RestArea(aAreaSF1)
	
return lRet


/**
 * Retorna a Chave de Acesso da NFe
 */
static function getKeyNfe(cTipo)
	
	local dEmissao := CtoD("")
	local cDoc	   := ""
	local cSerie   := ""
	local cChave   := ""
	
	if (cTipo == DHL_NFE_INVOICE_INFLOW)
		dEmissao := SF1->F1_EMISSAO
		cDoc     := AllTrim(SF1->F1_DOC)
		cSerie   := AllTrim(SF1->F1_SERIE)
	elseIf (cTipo == DHL_NFE_INVOICE_OUTFLOW)
		dEmissao := SF2->F2_EMISSAO
		cDoc     := AllTrim(SF2->F2_DOC)
		cSerie   := AllTrim(SF2->F2_SERIE)
	endIf
	
	cChave := getCodUf(SM0->M0_ESTCOB)
	cChave += FsDateConv(dEmissao, "YYMM")
	cChave += SM0->M0_CGC
	cChave += "55"
	cChave += StrZero(Val(cSerie), 3)
	cChave += StrZero(Val(cDoc), 9)
	cChave += GetNewPar("ZZ_TPEMIS", "1")
	cChave += subStr(U_GCifra(Val(cDoc), 9), 1, 8)
		
return cChave

/**
 * Retorna o Codigo da UF
 */
static function getCodUf(cUf)
	
	local aUF    := {}
	local cCodUf := ""
	local nScan	 := 0
	
	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})
	
	nScan := aScan(aUF, {|x| x[1] == cUf})
	
	if (nScan > 0)
		cCodUf := aUF[nScan,2]
	endIf
	
return cCodUf
