#include "totvs.ch"
#include "dhl.ch"

#define EMPTY_VALUE 			Space(1)
 
/*/{Protheus.doc} ProcRSymbMsa

Geração de interface Symbolic Return - IP050
	
@author Augusto Krejci Bem-Haja
@since 18/05/2017

@param oXml		, Object	, Objeto XML com o conteúdo da nota fiscal.
@param cKey		, String	, Chave da NFE
@param cType	, String	, Informa o tipo (1=Saída e 2=Entrada)
@param cSeries	, String	, Série da Nota 
@param cInvoice	, String	, Documento 
@param cCustSupl, String	, Cliente / Fornecedor
@param cBranch	, String	, Loja
/*/
user function ProcRSymbMsa(oXml, cKey, cType, cSeries, cInvoice, cCustSupl, cBranch)
	
	local lRet			:= .T.
	local lSerCont		:= aScan(separa(GetNewPar("ZZ_SERCONT", ""), ";"), {|x| x == upper(alltrim(cSeries))}) > 0
	local cTxtFile   		:= ""
	// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050] Regras da Reforma Tributaria
	// replicadas do ProcMsaNFe/ProcRCOMsa. MV_RTC55 = data de implantacao da reforma em producao
	local dDataRTC		:= SuperGetMv('MV_RTC55',.f.,stod('20260105'))
	// FIM Wellington Santana 27/11/2026
	private cTypeInv		:= cType
	private oTxtFile 		:= nil
	private oArquivo 		:= MsafNFeTag():newMsafNFeTag("arquivo")
	private oXmlUtil		:= oXml
	private cKeyInv		:= cKey
	private cNrInvoice	:= cInvoice
	private cNrSeries		:= cSeries
	private cCodSupCust	:= cCustSupl
	private cCodBranch	:= cBranch
	private	nVOutros		:= 0
	// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050]
	// lRefTribCo  : reforma vigente na data base (MV_RTC55), mesma regra do ProcMsaNFe
	// lRtcIP050   : liga os grupos IBS/CBS/IS no TXT do IP050. Os grupos novos MUDAM O LAYOUT
	//               POSICIONAL lido pelo SAP (decisao 4 do Diagnostico_Consolidado_NFe_2027_SCJ),
	//               por isso o default e .F. (layout atual preservado) ate o SAP SCJ confirmar.
	// cRtcTaxIcm / cRtcTaxIS : codigos do tributo no XML, lidos uma unica vez (SonarQube G2)
	private lRefTribCo	:= dDataBase >= dDataRTC
	private lRtcIP050		:= GetNewPar("ZZ_RTCIP50", .F.)
	private cRtcTaxIcm	:= GetNewPar("ZZ_TRIBICM", "ICMS")
	private cRtcTaxIS		:= GetNewPar("ZZ_TRIBIS", "IS")

	// Auditoria de tags da Reforma Tributaria: so registra em log a tag esperada que nao veio
	// do XmlNfeSef. Nao altera o XML nem o TXT. Inerte antes da data de MV_RTC55
	U_DHLRtcTagAudit(oXmlUtil, cNrInvoice, cNrSeries)
	// FIM Wellington Santana 27/11/2026

	if !lSerCont
		mountTags()

		oTxtFile := MsafRSymbFile():newMsafRSymbFile(oArquivo)
		
		lRet := oTxtFile:createTxt(DHL_NFE_GENERATE_INVOICE, cNrInvoice, cNrSeries)
	endif
	
return lRet

/**
* Cria as Instancias do MsafNFeTag que representam o xml da nota fiscal
**/
Static Function MountTags()

	SetPrvt("oNota,oVersao,oInf_NFe,oIde,oX_Contingencia,oNfReferenciada,oRef_NFe,oRef_NFP,oRefCTe,oRef_ECF,oEmit,OX_Emitente,oCRT,oAvulsa,oDeST,oEnder_Dest,oIndIEDest,oRetirada")
	SetPrvt("oEntrega,oAut_XML,oTotal,oIcms_Tot,oIssqn_Tot,oRet_Trib,oInf_Transporte,oTransp,oTransporta,oRet_Transp,oX_Transp_Diversos,oVeic_Transp,oReboque,oVagao")
	SetPrvt("oVolume,oLacre,oCobr,oFat,oDuplicata,oPag,oCard,oInf_Adic,oUso_livre_c,oUso_livre_f,oProc_referenciado,oExporta,oCompra,oCana,oCana_forn_diario,oCana_deducao")
	SetPrvt("oTotDed,oParam_gerais,oContingencia_externa,oUsuarioEmitente,oItem_nota,oDet,oProd,oNve,oEXTIPI,oDi,oAdi,oDet_Export,oExport_Ind,oXPed,oProd_especifico,oVeic_Prod,oMedicamento")
	SetPrvt("oArmamento,oComb,oCide,oEncerrante,oNRecopi,oImpostos,oICMS,oIcms_00,oIcms_10,oIcms_20,oX_icms20_deson,oIcms_30,oX_icms30_deson,oIcms_40,oX_icms40_deson,oIcms_51,oIcms_60")
	SetPrvt("oX_icms60_retido,oIcms_70,oX_icms70_deson,oIcms_90,oX_icms90_icms,oX_icms90_icmsst,oX_icms90_deson,oIcms_part,oIcms_st,oIcms_sn101,oIcms_sn102,oIcms_sn201")
	SetPrvt("oIcms_sn202,oIcms_sn500,oX_sn500_retido,oIcms_sn900,oX_sn900_icms,oX_sn900_icmsst,oX_sn900_credito,oIcmsUf,oIPI,oIpi_trib,oX_ipi_aliq,oX_ipi_unid,oIpi_nt,oII,oPIS")
	SetPrvt("oPis_aliq,oPis_qtde,oPis_nt,oPis_outr,oX_pis_percent,oX_pis_valor,oPISST,oPis_st,oX_pisst_percent,oX_pisst_valor,oCOFINS,oCofins_aliq,oCofins_qtde")
	SetPrvt("oCofins_nt,oCofins_outr,oX_cofinsoutr_percent,oX_cofinsoutr_valor,oCOFINSST,oCofins_st,oX_cofinsst_percent,oX_cofinsst_valor,oISSQN,oImposto_devol,oIpi_devol,oInf_adicionais,oDocSerieOrig,oShipment,oKeySCJ")
	SetPrvt("oDelivery, oNfProtocol")
	// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050] objetos dos grupos da Reforma Tributaria
	SetPrvt("oSeqXML,oIBSCBS,ogIBSCBS,ogIBSUF,ogIBSUFDif,ogIBSUFDevTrib,ogIBSUFRed,ogIBSMu,ogIBSMuDif,ogIBSMuDevTrib,ogIBSMuRed,ogCBS,ogCBSDif,ogCBSDevTrib,ogCBSRed,ogTribRegular,ogIBSCredPres,ogCBSCredPres,ogTribCompraGov")
	SetPrvt("ogIBSCBSMon,ogMonPadrao,ogMonReten,ogMonRet,ogMonDif,ogIBCBMonAttrib,ogTransfCred,ogCredPresIBSZFM,oIBSCBSTot,ogIBSTot,ogIBSUFTot,ogIBSMuTot,ogIBSTotAttrib,ogCBSTot,ogMonTot,ovNFTot")
	SetPrvt("ovItem,oIS,ogAjusteCompet,ogEstornoCred,oICMSPrevAnt,oDFeRef,ovProdLiqTot,oISTot")
	// FIM Wellington Santana 27/11/2026

	DoNota()
	DoVersaoLayout()
	DoInfNFe()
	DoIde()
	DoXContingencia()
	DoNfReferenciada()
	DoRefNFe()
	DoRefNFP()
	DoRefCTeAttrib()
	DoRefECF()
	DoEmit()
	DoXEmitente()
	DoCRT()
	DoAvulsa()
	DoDeST()
	DoEnderDest()
	DoIndIEDest()
	DoRetirada()
	DoEntrega()
	DoAutXML()
	DoTotal()
	// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050] vProdLiqTot vem antes do ICMSTot
	// (NT 2025.002, rejeicoes 1282/1283). So entra com ZZ_RTCIP50 ligado (muda o layout)
	If lRtcIP050
		DovProdLiqTot()
	EndIf
	// FIM Wellington Santana 27/11/2026
	DoIcmsTot()
	DoIssqnTot()
	DoRetTrib()
	// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050] ISTot depois do ICMSTot e antes do
	// IBSCBSTot; totais de IBS/CBS e vNFTot. Mesma ordem do ProcMsaNFe
	If lRtcIP050
		DoISTot()
		DoIBSCBSTot()
		DogIBSTot()
		DogIBSUFTot()
		DogIBSMuTot()
		DogIBSTotAttrib()
		DogCBSTot()
		DogMonTot()
		DovNFTot()
	EndIf
	// FIM Wellington Santana 27/11/2026
	DoInfTransporte()
	DoTransp()
	DoTransporta()
	DoRetTransp()
	DoTranspDiversos()
	DoVeicTransp()
	DoReboque()
	DoVagao()
	DoVolume()
	DoCobr()
	DoFat()
	DoDuplicata()
	DoPag()
	DoCard()
	DoInfAdic()
	DoUsoCLivre()
	DoUsoFLivre()
	DoProcReferenciado()
	DoExporta()
	DoCompra()
	DoCana()
	DoCanaFornDiario()
	DoTotMesAttrib()
	DoCanaDeducao()
	DoTotDedAttrib()
	DoParamGerais()
	DoContingenciaExterna()
	DoUsuarioEmitente()
	DoDetProd()
	DoShipment()
	DoKeySCJ()
	DoDeliveryNumber()
	DoNfProtocol()
		
return


/**
* Instancia o objeto que representa a tag "nota"
**/ 
static function DoNota()
	
	oNota := MsafNFeTag():newMsafNFeTag("nota")
	
	oArquivo:addElementNode(oNota)

return


/**
* Instancia o objeto que representa a tag "versao_Layout_DFe"
*/ 
static function DoVersaoLayout()	
	
	oVersao := MsafNFeTag():newMsafNFeTag("versao_Layout_DFe")
	
	oVersao:setAttributeValue("versaoLayoutDFe", DHL_NFE_LAYOUT)
	
	oNota:addElementNode(oVersao)

return


/**
* Instancia o objeto que representa a tag "inf_NFe"
*/ 
static function DoInfNFe()	
	
	oInf_NFe := MsafNFeTag():newMsafNFeTag("inf_NFe")
	
	oInf_NFe:setAttributeValue("versao", DHL_NFE_VERSION)
	oInf_NFe:setAttributeValue("id", AllTrim(cKeyInv)+CalcDigit(cKeyInv))	
	
	oNota:addElementNode(oInf_NFe)

return


/**
* Instancia o objeto que representa a tag "ide"
*/ 
static function DoIde()	
	
	local cMunFG     := AllTrim(SM0->M0_CODMUN)
	local cTpImp     := "1"
	local cTpEmis    := GetNewPar("ZZ_TPEMIS", "1")
	local cTpAmb     := GetNewPar("ZZ_TPAMB", "2")
	local cFinNfe    := getFinNfe()
	local cProcEmi	 := "0"
	local cMod		 := "55"
	local cDv        := CalcDigit(cKeyInv)
		
 	oIde := MsafNFeTag():newMsafNFeTag("ide")
		
	oIde:setAttributeValue("cUF"		,	retValueAttribute("infnfe:_ide:_cUF:text")		)
	oIde:setAttributeValue("cNF"		,	retValueAttribute("infnfe:_ide:_cNF:text")		)
	oIde:setAttributeValue("natOp"		,	retValueAttribute("infnfe:_ide:_natOp:text")		)
	oIde:setAttributeValue("indPag"		,	retValueAttribute("infnfe:_ide:_indPag:text")		)
	oIde:setAttributeValue("mod"		,	cMod )
	oIde:setAttributeValue("serie"		,	retValueAttribute("infnfe:_ide:_serie:text")		)
	oIde:setAttributeValue("nNF"		,	retValueAttribute("infnfe:_ide:_nNF:text")		)
	oIde:setAttributeValue("dhEmi"		,	retValueAttribute("infnfe:_ide:_dhEmi:text")		)
	oIde:setAttributeValue("dhSaiEnt"	,	retValueAttribute("infnfe:_ide:_dhSaiEnt:text")	)
	oIde:setAttributeValue("tpNF"		,	iif(retValueAttribute("infnfe:_ide:_tpNF:text") $ '2', '0', retValueAttribute("infnfe:_ide:_tpNF:text")))
	oIde:setAttributeValue("idDest"		,	retValueAttribute("infnfe:_ide:_idDest:text")		)
	oIde:setAttributeValue("cMunFG"		,	cMunFG )
	// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050] cMunFGIBS, mesma regra do ProcMsaNFe
	If lRtcIP050
		oIde:setAttributeValue("cMunFGIBS"	,	EMPTY_VALUE )
	EndIf
	// FIM Wellington Santana 27/11/2026
	oIde:setAttributeValue("tpImp"		,	cTpImp )
	oIde:setAttributeValue("tpEmis"		,	cTpEmis	)
	oIde:setAttributeValue("cDV"		,	cDv )
	oIde:setAttributeValue("tpAmb"		,	cTpAmb )
	oIde:setAttributeValue("finNfe"		,	cFinNfe )
	// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050] tpNFDebito (finNFe 6) e
	// tpNFCredito (finNFe 5): valor da nota autorizada, fallback F2_TPCOMPL/F1_TPCOMPL com 2 digitos
	If lRtcIP050
		If cFinNfe == "6"
			oIde:setAttributeValue("tpNFDebito"	,	getTpCompl("tpNFDebito") )
		Else
			oIde:setAttributeValue("tpNFDebito"	,	EMPTY_VALUE )
		EndIf
		If cFinNfe == "5"
			oIde:setAttributeValue("tpNFCredito",	getTpCompl("tpNFCredito") )
		Else
			oIde:setAttributeValue("tpNFCredito",	EMPTY_VALUE )
		EndIf
	EndIf
	// FIM Wellington Santana 27/11/2026
	oIde:setAttributeValue("indFinal"	,	retValueAttribute("infnfe:_ide:_indFinal:text")	)
	// INICIO Wellington Santana 22/11/2026 - [RTC-2026/2027 - Lote 4] indPres reflete a nota autorizada (XML);
	// "0" mantido como fallback (regra Emerson Holanda 26/02/2021 - NT 2020.006)
	oIde:setAttributeValue("indPres"	,	getIndPres()	)
	// FIM Wellington Santana 22/11/2026
	oIde:setAttributeValue("procEmi"	,	cProcEmi	)
	oIde:setAttributeValue("verProc"	,	retValueAttribute("infnfe:_ide:_verProc:text")	)

	oNota:addElementNode(oIde)

return

/**
 * Coleta o Código referente a Finalidade da NF
 */
static function getFinNfe()
	
	local cFinNfe := "1"	
	local cTipoNf := if ((cTypeInv == DHL_NFE_INVOICE_INFLOW), SF1->F1_TIPO, SF2->F2_TIPO)
	
	if (cTipoNf == "D") 
		if (cTypeInv == DHL_NFE_INVOICE_OUTFLOW)
			if alltrim(SD2->D2_CF) $ getnewpar("MV_DEVCFOP", "")
				cFinNfe := "1"
			else
				cFinNfe := "4"
			endif
		endif
	elseIf (cTipoNf $ "CIP")
		cFinNfe := "2"
	// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050] Regras de finalidade replicadas do
	// ProcMsaNFe (Wellington 18/11/2026), na versao corrigida do Lote 4 (ProcRCOMsa 22/11/2026).
	// So troca valor do finNfe; o layout do IP050 nao muda.
	// finNFe 5 (credito) e 6 (debito): definicao da area fiscal; subtipo em F2_TPCOMPL/F1_TPCOMPL.
	elseIf (cTipoNf == "5")   // nota de credito
		cFinNfe := "5"
	elseIf (cTipoNf == "6")   // nota de debito
		cFinNfe := "6"
	else
		// finNFe 3 (ajuste): unidades habilitadas em ZZ_FINAJUS (default so AG2). SF2/SD2 so sao
		// validos na saida (F1_ZZTPNF nao existe) e unidade vazia e rejeitada
		if !Empty(FWUnitBusiness()) .and. (cTypeInv == DHL_NFE_INVOICE_OUTFLOW) .and. ;
			(FWUnitBusiness() $ GetNewPar("ZZ_FINAJUS", DHL_BUSINESSUNIT_AG2))

			if SF2->F2_ZZTPNF == AJUSTE_FISCAL
				cFinNfe := "3"
			endIf

		endIf

		// Retorno de sacarias (regra Emerson Holanda 03/05/2019): so existe CFOP de devolucao e o
		// retorno e feito com tipo normal. Apenas na saida, onde o SD2 e o da propria nota
		if (cTypeInv == DHL_NFE_INVOICE_OUTFLOW) .and. AllTrim(SD2->D2_CF) $ "5921/6921"
			cFinNfe := "4" //devolucao
		endIf
	// FIM Wellington Santana 27/11/2026
	endIf

return cFinNfe

/*/{Protheus.doc} getTpCompl
Subtipo da nota de credito (tpNFCredito) ou de debito (tpNFDebito) para o IP050.

[RTC-2026/2027 - IP050] Replicado do ProcMsaNFe/ProcRCOMsa:
- prioriza o valor da nota autorizada (tag do XML), para o TXT nao divergir do XML transmitido;
- fallback F2_TPCOMPL (saida) / F1_TPCOMPL (entrada);
- formatado com 2 digitos (NT 2025.002 exige "07"; o campo TOTVS guarda "7").

@type function
@author Wellington Santana
@since 27/11/2026
@param cTagXml, character, nome da tag no ide do XML (tpNFDebito ou tpNFCredito)
@return character, subtipo com 2 digitos ou vazio
/*/
static function getTpCompl(cTagXml)

	local cTpCompl := ""

	default cTagXml := ""

	if !Empty(cTagXml)
		cTpCompl := AllTrim(retValueAttribute("infnfe:_ide:_" + cTagXml + ":text"))
	endIf

	if Empty(cTpCompl)
		if cTypeInv == DHL_NFE_INVOICE_INFLOW
			cTpCompl := AllTrim(SF1->F1_TPCOMPL)
		else
			cTpCompl := AllTrim(SF2->F2_TPCOMPL)
		endIf
	endIf

	if !Empty(cTpCompl)
		cTpCompl := PadL(cTpCompl, 2, "0")
	endIf

return cTpCompl

/**
 * Calculo do DV da NFe
 */
static function CalcDigit(cChave)
	
	local nResto	:= 0
	local nSoma		:= 0
	local nDv 		:= 0
	local nMult		:= 2
	local cString	:= AllTrim(cChave)	
	local nI		:= 0	
	
	for nI := Len(cString) to 1 step -1		
		nSoma += (Val(SubStr(cString, nI, 1)) * nMult)
		if (nMult == 9)
			nMult := 2
		else
			nMult++				
		endIf													
	next nI	
	
	nResto := Mod(nSoma, 11)
	nDv	   := (11 - nResto)
	
	if (nDv >= 10)
		nDv := 0
	endIf	
	
return AllTrim(Str(nDv))

/**
* Instancia o objeto que representa a tag "x_contingencia"
*/ 
static function DoXContingencia()
	
	oX_Contingencia := MsafNFeTag():newMsafNFeTag("x_contingencia")

	oX_Contingencia:setAttributeValue("dhCont",EMPTY_VALUE)
	oX_Contingencia:setAttributeValue("xJust",EMPTY_VALUE)
	
	oIde:addElementNode(oX_Contingencia)

return


/**
* Instancia o objeto que representa a tag "nfReferenciada"
*/ 
static function DoNfReferenciada()

	local nI			:= 1
	local nJ			:= 1
	local cTpAmb		:= GetNewPar("ZZ_TPAMB", '2')
	
	local aAttribute	:=  retArrayAttribute("infnfe:_ide:_NFref:_refNFe")
	
	oNfReferenciada := MsafNFeTag():newMsafNFeTag("nfReferenciada")	
	
	if cTpAmb $ '1'
		if isEmpty(aAttribute)
			oNfReferenciada:setAttributeValue("RefNFe","")
		endIf
			
		for nI := 1 to len(aAttribute)
			oNfReferenciada:setAttributeValue("RefNFe",aAttribute[nI]:text, .T.)
			if len(aAttribute) > 1
				for nJ := 1 to 18
					oNfReferenciada:setAttributeValue("RefNFe",'', .T.)
				next nJ
			endif
		next nI
	else 	
		if isEmpty(aAttribute)
			oNfReferenciada:setAttributeValue("RefNFe","")
		else
			oNfReferenciada:setAttributeValue("RefNFe","35150102836056006813550010000001151005553350")
		endIf
	endif
	
	oIde:addElementNode(oNfReferenciada)

return


/**
* Instancia o objeto que representa a tag "ref_NFe"
*/ 
static function DoRefNFe()
	
	local aAttribute	:= retArrayAttribute("infnfe:_ide:_NFref:_refNF")
	local cTpAmb		:= GetNewPar("ZZ_TPAMB", '2')
	local nI			:= 1
	
	if cTpAmb $ '1'
		if isEmpty(aAttribute)
			oRef_NFe := MsafNFeTag():newMsafNFeTag("ref_NFe")
			oRef_NFe:setAttributeValue("cUF"	,EMPTY_VALUE	)
			oRef_NFe:setAttributeValue("AAMM"	,EMPTY_VALUE	)
			oRef_NFe:setAttributeValue("CNPJ"	,EMPTY_VALUE	)
			oRef_NFe:setAttributeValue("Mod"	,EMPTY_VALUE	)
			oRef_NFe:setAttributeValue("serie"	,EMPTY_VALUE	)
			oRef_NFe:setAttributeValue("nNF"	,EMPTY_VALUE	)
		endIf
		
		for nI	:= 1 to len(aAttribute)
			
			oRef_NFe := MsafNFeTag():newMsafNFeTag("ref_NFe")
			
			oRef_NFe:setAttributeValue("cUF"	,aAttribute[nI]:_cUF:text	)
			oRef_NFe:setAttributeValue("AAMM"	,aAttribute[nI]:_AAMM:text	)
			oRef_NFe:setAttributeValue("CNPJ"	,aAttribute[nI]:_CNPJ:text	)
			oRef_NFe:setAttributeValue("Mod"	,aAttribute[nI]:_Mod:text	)
			oRef_NFe:setAttributeValue("serie"	,aAttribute[nI]:_serie:text	)
			oRef_NFe:setAttributeValue("nNF"	,aAttribute[nI]:_nNF:text	)
		next nI
	else
		oRef_NFe := MsafNFeTag():newMsafNFeTag("ref_NFe")
		oRef_NFe:setAttributeValue("cUF"	,EMPTY_VALUE	)
		oRef_NFe:setAttributeValue("AAMM"	,EMPTY_VALUE	)
		oRef_NFe:setAttributeValue("CNPJ"	,EMPTY_VALUE	)
		oRef_NFe:setAttributeValue("Mod"	,EMPTY_VALUE	)
		oRef_NFe:setAttributeValue("serie"	,EMPTY_VALUE	)
		oRef_NFe:setAttributeValue("nNF"	,EMPTY_VALUE	)
	endif
	
	oNfReferenciada:addElementNode(oRef_NFe)

return


/**
* Instancia o objeto que representa a tag "ref_NFP"
*/ 
static function DoRefNFP()
	
	local aAttribute	:= retArrayAttribute("infnfe:_ide:_NFref:_refNFP")
	local nI			:= 1
	
	if isEmpty(aAttribute)
		oRef_NFP := MsafNFeTag():newMsafNFeTag("ref_NFP")
		oRef_NFP:setAttributeValue("cUF"	,EMPTY_VALUE	)
		oRef_NFP:setAttributeValue("AAMM"	,EMPTY_VALUE	)
		oRef_NFP:setAttributeValue("CNPJ"	,EMPTY_VALUE	)
		oRef_NFP:setAttributeValue("CPF"	,EMPTY_VALUE	)
		oRef_NFP:setAttributeValue("IE"		,EMPTY_VALUE	)
		oRef_NFP:setAttributeValue("mod"	,EMPTY_VALUE	)
		oRef_NFP:setAttributeValue("serie"	,EMPTY_VALUE	)
		oRef_NFP:setAttributeValue("nNF"	,EMPTY_VALUE	)
	endIf
	
	for nI	:= 1 to len(aAttribute)
		
		oRef_NFP := MsafNFeTag():newMsafNFeTag("ref_NFP")
		
		oRef_NFP:setAttributeValue("cUF"	,aAttribute[nI]:_cUF:text	)
		oRef_NFP:setAttributeValue("AAMM"	,aAttribute[nI]:_AAMM:text	)
		oRef_NFP:setAttributeValue("CNPJ"	,aAttribute[nI]:_CNPJ:text	)
		oRef_NFP:setAttributeValue("CPF"	,aAttribute[nI]:_CPF:text	)
		oRef_NFP:setAttributeValue("IE"		,aAttribute[nI]:_IE:text		)
		oRef_NFP:setAttributeValue("mod"	,aAttribute[nI]:_Mod:text	)
		oRef_NFP:setAttributeValue("serie"	,aAttribute[nI]:_serie:text	)
		oRef_NFP:setAttributeValue("nNF"	,aAttribute[nI]:_nNF:text	)
		//oRef_NFP:setAttributeValue("refCTe","teste dellano")
	next nI
	
	oNfReferenciada:addElementNode(oRef_NFP)

return

/**
* Instancia o objeto que representa o atributo "refCTe"
*/ 
static function DoRefCTeAttrib()
	local aAttribute	:= 	aAttribute	:= retArrayAttribute("infnfe:_ide:_NFref:_refCTe")
	local nI			:= 1
	
	oRefCTe := MsafNFeTag():newMsafNFeTag("")
	
	if isEmpty(aAttribute)
		oRefCTe:setAttributeValue("refCTe",EMPTY_VALUE)
	endIf
	
	for nI	:= 1 to len(aAttribute)
		oRefCTe:setAttributeValue("refCTe",oAtributte[nI]:text)
	next nI
	
	oNfReferenciada:addElementNode(oRefCTe)

return


/**
* Instancia o objeto que representa a tag "ref_ECF"
*/ 
static function DoRefECF()
	local aAttribute	:= 	aAttribute	:= retArrayAttribute("infnfe:_ide:_NFref:_refECF")
	local nI			:= 1
	
	oRef_ECF := MsafNFeTag():newMsafNFeTag("ref_ECF")
	
	if isEmpty(aAttribute)
		oRef_ECF:setAttributeValue("mod"	,EMPTY_VALUE	)
		oRef_ECF:setAttributeValue("nECF"	,EMPTY_VALUE	)
		oRef_ECF:setAttributeValue("nCOO"	,EMPTY_VALUE	)
	endIf
	
	for nI	:= 1 to len(aAttribute)
		oRef_ECF:setAttributeValue("mod"	,aAttribute[nI]:_mod:text	)
		oRef_ECF:setAttributeValue("nECF"	,aAttribute[nI]:_nECF:text	)
		oRef_ECF:setAttributeValue("nCOO"	,aAttribute[nI]:_nCOO:text	)
	next nI
	
	oNfReferenciada:addElementNode(oRef_ECF)

return


/**
* Instancia o objeto que representa a tag "emit"
*/ 
static function DoEmit()
	
	cCnpj	:= retValueAttribute("infNfe:_emit:_CNPJ:text")
	oEmit := MsafNFeTag():newMsafNFeTag("emit")

	oEmit:setAttributeValue("CNPJ"		,cCnpj											)
	oEmit:setAttributeValue("CPF"		,retValueAttribute("infNfe:_emit:_CPF:text"))
	oEmit:setAttributeValue("xNome"		,retValueAttribute("infNfe:_emit:_Nome:text"))
	oEmit:setAttributeValue("xFant"		,retValueAttribute("infNfe:_emit:_Nome:text"))
	
	oEmit:setAttributeValue("xLgr"		,retValueAttribute("infNfe:_emit:_enderEmit:_Lgr:text")	)
	oEmit:setAttributeValue("nro"		,retValueAttribute("infNfe:_emit:_enderEmit:_nro:text")		)
	oEmit:setAttributeValue("xCpl"		,retValueAttribute("infNfe:_emit:_enderEmit:_Cpl:text")	)
	oEmit:setAttributeValue("xBairro"	,retValueAttribute("infNfe:_emit:_enderEmit:_Bairro:text")	)
	oEmit:setAttributeValue("cMun"		,retValueAttribute("infNfe:_emit:_enderEmit:_cMun:text")	)
	oEmit:setAttributeValue("xMun"		,retValueAttribute("infNfe:_emit:_enderEmit:_Mun:text")	)
	oEmit:setAttributeValue("UF"		,retValueAttribute("infNfe:_emit:_enderEmit:_UF:text")		)
	oEmit:setAttributeValue("CEP"		,retValueAttribute("infNfe:_emit:_enderEmit:_CEP:text")		)
	oEmit:setAttributeValue("cPais"		,retValueAttribute("infNfe:_emit:_enderEmit:_cPais:text")	)
	oEmit:setAttributeValue("xPais"		,retValueAttribute("infNfe:_emit:_enderEmit:_Pais:text")	)
	oEmit:setAttributeValue("fone"		,retValueAttribute("infNfe:_emit:_enderEmit:_fone:text")	)
	oEmit:setAttributeValue("IE"		,retValueAttribute("infNfe:_emit:_IE:text")					)
	oEmit:setAttributeValue("IEST"		,retValueAttribute("infNfe:_emit:_IEST:text")					)
	
	oNota:addElementNode(OEmit)

return

/**
* Instancia o objeto que representa a tag "x_emitente" 
**/ 
static function DoXEmitente()
	
	oX_Emitente := MsafNFeTag():newMsafNFeTag("x_emitente")

	oX_Emitente:setAttributeValue("IM"		,retValueAttribute("infNfe:_emit:_IM:text")	)
	oX_Emitente:setAttributeValue("CNAE"	,retValueAttribute("infNfe:_emit:_CNAE:text")	)
	
	oEmit:addElementNode(oX_Emitente)

return

/**
* Instancia o objeto que representa o atributo "CRT"
*/ 
static function DoCRT()
	
	oCRT := MsafNFeTag():newMsafNFeTag("")

	oCRT:setAttributeValue("CRT",retValueAttribute("infNfe:_emit:_CRT:text"))
	
	oEmit:addElementNode(oCRT)

return


/**
* Instancia o objeto que representa a tag "avulsa" 
**/ 
static function DoAvulsa()
	
	oAvulsa := MsafNFeTag():newMsafNFeTag("avulsa")

	oAvulsa:setAttributeValue("CNPJ",EMPTY_VALUE)
	oAvulsa:setAttributeValue("xOrgao",EMPTY_VALUE)
	oAvulsa:setAttributeValue("matr",EMPTY_VALUE)
	oAvulsa:setAttributeValue("xAgente",EMPTY_VALUE)
	oAvulsa:setAttributeValue("fone",EMPTY_VALUE)
	oAvulsa:setAttributeValue("UF",EMPTY_VALUE)
	oAvulsa:setAttributeValue("nDAR",EMPTY_VALUE)
	oAvulsa:setAttributeValue("dEmi",EMPTY_VALUE)
	oAvulsa:setAttributeValue("vDAR",EMPTY_VALUE)
	oAvulsa:setAttributeValue("repEmi",EMPTY_VALUE)
	oAvulsa:setAttributeValue("dPag",EMPTY_VALUE)
	
	oNota:addElementNode(oAvulsa)

return


/**
* Instancia o objeto que representa a tag "dest"
**/ 
static function DoDeST()
	
	oDeST := MsafNFeTag():newMsafNFeTag("dest")

	oDeST:setAttributeValue("CNPJ",retValueAttribute("infNfe:_dest:_CNPJ:text"))
	oDeST:setAttributeValue("CPF",retValueAttribute("infNfe:_dest:_CPF:text"))
	oDeST:setAttributeValue("idEstrangeiro",retValueAttribute("infNfe:_dest:_idEstrangeiro:text"))
	oDeST:setAttributeValue("xNome",retValueAttribute("infNfe:_dest:_Nome:text"))
	
	oNota:addElementNode(oDeST)

return


/**
* Instancia o objeto que representa a tag "ender_Dest"
**/ 
static function DoEnderDest()
	
	oEnder_Dest := MsafNFeTag():newMsafNFeTag("ender_Dest")

	oEnder_Dest:setAttributeValue("xLgr"	,retValueAttribute("infNfe:_dest:_enderDest:_Lgr:text")	)
	oEnder_Dest:setAttributeValue("nro"		,retValueAttribute("infNfe:_dest:_enderDest:_nro:text")		)
	oEnder_Dest:setAttributeValue("xCpl"	,retValueAttribute("infNfe:_dest:_enderDest:_Cpl:text")	)
	oEnder_Dest:setAttributeValue("xBairro"	,retValueAttribute("infNfe:_dest:_enderDest:_Bairro:text")	)
	oEnder_Dest:setAttributeValue("cMun"	,retValueAttribute("infNfe:_dest:_enderDest:_cMun:text")	)
	oEnder_Dest:setAttributeValue("xMun"	,retValueAttribute("infNfe:_dest:_enderDest:_Mun:text")	)
	oEnder_Dest:setAttributeValue("UF"		,retValueAttribute("infNfe:_dest:_enderDest:_UF:text")		)
	oEnder_Dest:setAttributeValue("CEP"		,retValueAttribute("infNfe:_dest:_enderDest:_CEP:text")		)
	oEnder_Dest:setAttributeValue("cPais"	,retValueAttribute("infNfe:_dest:_enderDest:_cPais:text")	)
	oEnder_Dest:setAttributeValue("xPais"	,retValueAttribute("infNfe:_dest:_enderDest:_Pais:text")	)
	oEnder_Dest:setAttributeValue("fone"	,retValueAttribute("infNfe:_dest:_enderDest:_fone:text")	)
	
	oDeST:addElementNode(oEnder_Dest)

return

/**
* Instancia o objeto que representa o atributo "indIEDest"
*/ 
static function DoIndIEDest()
	
	oIndIEDest := MsafNFeTag():newMsafNFeTag("")

	oIndIEDest:setAttributeValue("indIEDest",retValueAttribute("infNfe:_dest:_indIEDest:text"))
	oIndIEDest:setAttributeValue("IE",retValueAttribute("infNfe:_dest:_IE:text"))
	oIndIEDest:setAttributeValue("ISUF",EMPTY_VALUE)
	oIndIEDest:setAttributeValue("IM",retValueAttribute("infNfe:_dest:_IM:text"))
	oIndIEDest:setAttributeValue("email",retValueAttribute("infNfe:_dest:_email:text"))
	
	oDeST:addElementNode(oIndIEDest)

return


/**
* Instancia o objeto que representa a tag "retirada"
**/ 
static function DoRetirada()
	
	oRetirada := MsafNFeTag():newMsafNFeTag("retirada")

	oRetirada:setAttributeValue("CNPJ"		,retValueAttribute("infNfe:_retirada:_CNPJ:text"))
	oRetirada:setAttributeValue("CPF"		,retValueAttribute("infNfe:_retirada:_CPF:text"))
	oRetirada:setAttributeValue("xLgr"		,retValueAttribute("infNfe:_retirada:_Lgr:text"))
	oRetirada:setAttributeValue("nro"		,retValueAttribute("infNfe:_retirada:_nro:text"))
	oRetirada:setAttributeValue("xCpl"		,retValueAttribute("infNfe:_retirada:_Cpl:text"))
	oRetirada:setAttributeValue("xBairro"	,retValueAttribute("infNfe:_retirada:_Bairro:text"))
	oRetirada:setAttributeValue("cMun"		,retValueAttribute("infNfe:_retirada:_cMun:text"))
	oRetirada:setAttributeValue("xMun"		,retValueAttribute("infNfe:_retirada:_Mun:text"))
	oRetirada:setAttributeValue("UF"		,retValueAttribute("infNfe:_retirada:_UF:text"))
	
	oNota:addElementNode(oRetirada)

return


/**
* Instancia o objeto que representa a tag "entrega"
**/ 
static function DoEntrega()
	
	oEntrega := MsafNFeTag():newMsafNFeTag("entrega")

	oEntrega:setAttributeValue("CNPJ"		,retValueAttribute("infNfe:_entrega:_CNPJ:text"))
	oEntrega:setAttributeValue("CPF"		,retValueAttribute("infNfe:_entrega:_CPF:text"))
	oEntrega:setAttributeValue("xLgr"		,retValueAttribute("infNfe:_entrega:_Lgr:text"))
	oEntrega:setAttributeValue("nro"		,retValueAttribute("infNfe:_entrega:_nro:text"))
	oEntrega:setAttributeValue("xCpl"		,retValueAttribute("infNfe:_entrega:_Cpl:text"))
	oEntrega:setAttributeValue("g_xBairro"	,retValueAttribute("infNfe:_entrega:_Bairro:text"))
	oEntrega:setAttributeValue("cMun"		,retValueAttribute("infNfe:_entrega:_cMun:text"))
	oEntrega:setAttributeValue("xMun"		,retValueAttribute("infNfe:_entrega:_Mun:text"))
	oEntrega:setAttributeValue("UF"			,retValueAttribute("infNfe:_entrega:_UF:text"))
	
	oNota:addElementNode(oEntrega)

return


/**
* Instancia o objeto que representa a tag "aut_XML"
**/ 
static function DoAutXML()
	
	oAut_XML := MsafNFeTag():newMsafNFeTag("aut_XML")

	oAut_XML:setAttributeValue("CNPJ",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / MasterSaf
	oAut_XML:setAttributeValue("CPF",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / MasterSaf
	
	oNota:addElementNode(oAut_XML)

return


/**
* Instancia o objeto que representa a tag "total"
**/ 
static function DoTotal()
	
	oTotal := MsafNFeTag():newMsafNFeTag("total")
	
	oNota:addElementNode(oTotal)

return


/**
* Instancia o objeto que representa a tag "icms_Tot"
**/ 
static function DoIcmsTot()
	
	local nI		  := 0
	local nvProd	  := 0
	local nTotTrib	  := 0
	local nFrete	  := 0
	local nSeg		  := 0
	local nDesc		  := 0
	local nII		  := 0
	local nIPI		  := 0
	local nPIS		  := 0
	local nCOFINS	  := 0
	local nOutro	  := 0
	local lFormatZero := .T.
	local aItens	  := retArrayAtribute("infNfe:_det")
	local oUtils	  := IpUtilsObject():newIpUtilsObject()
	private oDetNfe   := nil	
	
	for nI := 1 to Len(aItens)
		oDetNfe := aItens[nI]
		if (fTypeVar("oDetNfe:_prod:_vProd:text") != "U")
			nvProd  += Val(oDetNfe:_prod:_vProd:text)
		endIf	 
	next nI	
	
	if (cTypeInv == DHL_NFE_INVOICE_OUTFLOW)
		nTotTrib := SF2->F2_TOTIMP
		nFrete	 := SF2->F2_FRETE
		nSeg	 := SF2->F2_SEGURO
		nDesc    := SF2->F2_DESCONT
		nII		 := 0
		nIPI	 := if (SF4->F4_DESTACA $ 'N', 0,SF2->F2_VALIPI)
		nPIS	 := SF2->F2_VALIMP6
		nCOFINS	 := SF2->F2_VALIMP5
		nOutro	 := 0
	else
		nFrete	 := 0
		nSeg	 := 0
		nDesc    := 0
		nII		 := 0
		nIPI	 := 0
		nPIS	 := 0
		nCOFINS	 := 0
		nOutro	 := 0
		
		if (FWUnitBusiness() == DHL_BUSINESSUNIT_REV)
			if (SF1->F1_FORMUL == 'S')
				nPIS	 := SF1->F1_VALIMP6
				nCOFINS	 := SF1->F1_VALIMP5
			endif
		endif
	endIf	
	
	oIcms_Tot := MsafNFeTag():newMsafNFeTag("icms_Tot")

	oIcms_Tot:setAttributeValue("vBC"		,retValueAttribute("infNfe:_total:_vBC:text", lFormatZero))
	oIcms_Tot:setAttributeValue("vICMS"		,retValueAttribute("infNfe:_total:_vICMS:text", lFormatZero))
	oIcms_Tot:setAttributeValue("vICMSDeson",retValueAttribute("infNfe:_total:_vICMSDeson:text", lFormatZero))
	
	//NT 2015/003
	oIcms_Tot:setAttributeValue("vFCPUFDest"	,retValueAttribute("infNfe:_total:_vFCPUFDest:text", lFormatZero))
	oIcms_Tot:setAttributeValue("vICMSUFDest"	,retValueAttribute("infNfe:_total:_vICMSUFDest:text", lFormatZero))
	oIcms_Tot:setAttributeValue("vICMSUFRemet"	,retValueAttribute("infNfe:_total:_vICMSUFRemet:text", lFormatZero))
	
	oIcms_Tot:setAttributeValue("vBCST"		,retValueAttribute("infNfe:_total:_vBCST:text", lFormatZero))
	oIcms_Tot:setAttributeValue("vST"		,retValueAttribute("infNfe:_total:_vICMSST:text", lFormatZero))
	oIcms_Tot:setAttributeValue("vProd"		,oUtils:strAnyType(nvProd, "@R 999999999999.99"))
	oIcms_Tot:setAttributeValue("vFrete"	,oUtils:strAnyType(nFrete, "@R 999999999999.99"))
	oIcms_Tot:setAttributeValue("vSeg"		,oUtils:strAnyType(nSeg, "@R 999999999999.99"))
	oIcms_Tot:setAttributeValue("vDesc"		,oUtils:strAnyType(nDesc, "@R 999999999999.99"))
	oIcms_Tot:setAttributeValue("vII"		,oUtils:strAnyType(nII, "@R 999999999999.99"))
	oIcms_Tot:setAttributeValue("vIPI"		,oUtils:strAnyType(nIPI, "@R 999999999999.99"))
	oIcms_Tot:setAttributeValue("vPIS"		,oUtils:strAnyType(nPIS, "@R 999999999999.99"))
	oIcms_Tot:setAttributeValue("vCOFINS"	,oUtils:strAnyType(nCOFINS, "@R 999999999999.99"))
	oIcms_Tot:setAttributeValue("vOutro"	,oUtils:strAnyType(getNVOutros(), "@R 999999999999.99"))
	oIcms_Tot:setAttributeValue("vNF"		,retValueAttribute("infNfe:_total:_vNF:text", lFormatZero))
	oIcms_Tot:setAttributeValue("vTotTrib"	,oUtils:strAnyType(nTotTrib, "@R 999999999999.99"))
	
	oTotal:addElementNode(oIcms_Tot)

return


/**
* Instancia o objeto que representa a tag "issqn_Tot"
**/ 
static function DoIssqnTot()
	
	oIssqn_Tot := MsafNFeTag():newMsafNFeTag("issqn_Tot")

	oIssqn_Tot:setAttributeValue("vServ",0) 
	oIssqn_Tot:setAttributeValue("vBC",0)
	oIssqn_Tot:setAttributeValue("vISS",0)
	oIssqn_Tot:setAttributeValue("vPIS",0)
	oIssqn_Tot:setAttributeValue("vCOFINS",0)
	oIssqn_Tot:setAttributeValue("dCompet",EMPTY_VALUE)
	oIssqn_Tot:setAttributeValue("vDeducao",0)
	oIssqn_Tot:setAttributeValue("vOutro",0)
	oIssqn_Tot:setAttributeValue("vDescIncond",0)
	oIssqn_Tot:setAttributeValue("vDescCond",0)
	oIssqn_Tot:setAttributeValue("vISSRet",0)
	oIssqn_Tot:setAttributeValue("cRegTrib",EMPTY_VALUE)
	
	oTotal:addElementNode(oIssqn_Tot)

return


/**
* Instancia o objeto que representa a tag "ret_Trib"
**/ 
static function DoRetTrib()
	
	oRet_Trib := MsafNFeTag():newMsafNFeTag("ret_Trib")

	oRet_Trib:setAttributeValue("vRetPIS",0)
	oRet_Trib:setAttributeValue("vRetCOFINS",0)
	oRet_Trib:setAttributeValue("vRetCSLL",0)
	oRet_Trib:setAttributeValue("vBCIRRF",0)
	oRet_Trib:setAttributeValue("vIRRF",0)
	oRet_Trib:setAttributeValue("vBCRetPrev",0)
	oRet_Trib:setAttributeValue("vRetPrev",0)
	
	oTotal:addElementNode(oRet_Trib)

return


/**
* Instancia o objeto que representa a tag "inf_Transporte"
**/ 
static function DoInfTransporte()
	
	oInf_Transporte := MsafNFeTag():newMsafNFeTag("inf_transporte")
	
	oNota:addElementNode(oInf_Transporte)

return


/**
* Instancia o objeto que representa a tag "transp"
**/ 
static function DoTransp()
	
	oTransp := MsafNFeTag():newMsafNFeTag("transp")

	oTransp:setAttributeValue("modFrete",retValueAttribute("infNfe:_transp:_modFrete:text"))
	
	oInf_Transporte:addElementNode(oTransp)

return


/**
* Instancia o objeto que representa a tag "transporta"
**/ 
static function DoTransporta()
	
	oTransporta := MsafNFeTag():newMsafNFeTag("transporta")

	oTransporta:setAttributeValue("CNPJ"	,retValueAttribute("infNfe:_transp:_transporta:_CNPJ:text")) 
	oTransporta:setAttributeValue("CPF"	,retValueAttribute("infNfe:_transp:_transporta:_CPF:text"))
	oTransporta:setAttributeValue("xNome"	,retValueAttribute("infNfe:_transp:_transporta:_Nome:text"))
	oTransporta:setAttributeValue("IE"		,retValueAttribute("infNfe:_transp:_transporta:_IE:text"))
	oTransporta:setAttributeValue("xEnder"	,retValueAttribute("infNfe:_transp:_transporta:_Ender:text"))
	oTransporta:setAttributeValue("xMun"	,retValueAttribute("infNfe:_transp:_transporta:_Mun:text"))
	oTransporta:setAttributeValue("UF"		,retValueAttribute("infNfe:_transp:_transporta:_UF:text"))
	
	oInf_Transporte:addElementNode(oTransporta)

return


/**
* Instancia o objeto que representa a tag "ret_Transp"
**/ 
static function DoRetTransp()
	
	oRet_Transp := MsafNFeTag():newMsafNFeTag("ret_Transp")

	oRet_Transp:setAttributeValue("vServ", retValueAttribute("infNfe:_transp:_retTransp:_vServ:text"))
	oRet_Transp:setAttributeValue("vBCRet", retValueAttribute("infNfe:_transp:_retTransp:_vBCRet:text"))
	oRet_Transp:setAttributeValue("pICMSRet", retValueAttribute("infNfe:_transp:_retTransp:_pICMSRet:text"))
	oRet_Transp:setAttributeValue("vICMSRet", retValueAttribute("infNfe:_transp:_retTransp:_vICMSRet:text"))
	oRet_Transp:setAttributeValue("CFOP", retValueAttribute("infNfe:_transp:_retTransp:_CFOP:text"))
	oRet_Transp:setAttributeValue("cMunFG", retValueAttribute("infNfe:_transp:_retTransp:_cMunFG:text"))
	
	oInf_Transporte:addElementNode(oRet_Transp)

return


/**
* Instancia o objeto que representa a tag "x_Transp_Diversos"
**/ 
static function DoTranspDiversos()
	
	oX_Transp_Diversos := MsafNFeTag():newMsafNFeTag("x_transp_diversos")
	
	oInf_Transporte:addElementNode(oX_Transp_Diversos)

return


/**
* Instancia o objeto que representa a tag "veic_Transp"
**/ 
static function DoVeicTransp()
	
	local cPlaca := if (cTypeInv == DHL_NFE_INVOICE_INFLOW, SF1->F1_PLACA, SF2->F2_ZZPLACA)
	
	cPlaca := StrTran(cPlaca, Space(1), "")
	cPlaca := StrTran(cPlaca, "-", "")
	
	oVeic_Transp := MsafNFeTag():newMsafNFeTag("veic_Transp")

	oVeic_Transp:setAttributeValue("placa"	, cPlaca)
	oVeic_Transp:setAttributeValue("UF"	,retValueAttribute("infNfe:_transp:_transporta:_uf:text"))
	oVeic_Transp:setAttributeValue("RNTC"	,retValueAttribute("infNfe:_transp:_transporta:_rntc:text"))
	
	oX_Transp_Diversos:addElementNode(oVeic_Transp)

return


/**
* Instancia o objeto que representa a tag "reboque"
**/ 
static function DoReboque()
	local aAttribute	:= 	aAttribute	:= retArrayAttribute("infNfe:_transp:_reboque")
	local nI			:= 1
	
	if isEmpty(aAttribute)
		oReboque := MsafNFeTag():newMsafNFeTag("reboque")

		oReboque:setAttributeValue("placa"	,EMPTY_VALUE)
		oReboque:setAttributeValue("UF"		,EMPTY_VALUE)	
		oReboque:setAttributeValue("RNTC"	,EMPTY_VALUE)
	endIf
		
	for nI := 1 to len(aAttribute)
		oReboque := MsafNFeTag():newMsafNFeTag("reboque")

		oReboque:setAttributeValue("placa"	,aAttribute[nI]:_placa:text)
		oReboque:setAttributeValue("UF"		,aAttribute[nI]:_UF:text)	
		oReboque:setAttributeValue("RNTC"	,aAttribute[nI]:_RNTC:text)
	next nI
	
	oX_Transp_Diversos:addElementNode(oReboque)

return


/**
* Instancia o objeto que representa o atributo "vagao"
*/ 
static function DoVagao()
	
	oVagao := MsafNFeTag():newMsafNFeTag("")

	oVagao:setAttributeValue("vagao",EMPTY_VALUE)
	oVagao:setAttributeValue("balsa",EMPTY_VALUE)
	
	oInf_Transporte:addElementNode(oVagao)

return


/**
* Instancia o objeto que representa a tag "volume"
**/ 
static function DoVolume()
	
	local aAttribute  := retArrayAttribute("infNfe:_transp:_vol")
	local cMarca	  := if (cTypeInv == DHL_NFE_INVOICE_INFLOW, SF1->F1_ZZMARCA, SF2->F2_ZZMARCA)
	local nI		  := 1
	
	if isEmpty(aAttribute)
		oVolume := MsafNFeTag():newMsafNFeTag("volume")
		oVolume:setAttributeValue("qVol"	,EMPTY_VALUE)	
		oVolume:setAttributeValue("esp"		,EMPTY_VALUE)	
		oVolume:setAttributeValue("marca"	,EMPTY_VALUE)
		oVolume:setAttributeValue("nVol"	,EMPTY_VALUE)	
		oVolume:setAttributeValue("pesoL"	,EMPTY_VALUE)
		oVolume:setAttributeValue("pesoB"	,EMPTY_VALUE)
		DoLacre()
	endIf
		
	for nI := 1 to len(aAttribute)
	
		oVolume := MsafNFeTag():newMsafNFeTag("volume")
	
		oVolume:setAttributeValue("qVol"	, getObjectProperty(aAttribute[nI], "_qVol:text"))	
		oVolume:setAttributeValue("esp"		, getObjectProperty(aAttribute[nI], "_esp:text"))	
		oVolume:setAttributeValue("marca"	, cMarca)
		oVolume:setAttributeValue("nVol"	, getObjectProperty(aAttribute[nI], "_nVol:text"))	
		oVolume:setAttributeValue("pesoL"	, getObjectProperty(aAttribute[nI], "_pesoL:text"))
		oVolume:setAttributeValue("pesoB"	, getObjectProperty(aAttribute[nI], "_pesoB:text"))
		
		DoLacre()
		
	next nI
	
	oInf_Transporte:addElementNode(oVolume)

return


/**
* Instancia o objeto que representa a tag "lacre"
**/ 
static function DoLacre()
	
	oLacre := MsafNFeTag():newMsafNFeTag("lacre")

	oLacre:setAttributeValue("nLacre",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL
	
	oVolume:setAttributeValue(oLacre)

return


/**
* Instancia o objeto que representa a tag "cobr"
**/ 
static function DoCobr()
	
	oCobr := MsafNFeTag():newMsafNFeTag("cobr")
	
	oNota:addElementNode(oCobr)

return


/**
* Instancia o objeto que representa a tag "fat"
**/ 
static function DoFat()
	
	local lFormatZero	:= .T.
	local nTotal		:= retValueAttribute("infNfe:_total:_vNF:text", lFormatZero)
	local nDesc			:= retValueAttribute("infNfe:_total:_vDesc:text", lFormatZero)
	local nLiq			:= Val(nTotal) - Val(nDesc)
	local oUtils	    := IpUtilsObject():newIpUtilsObject()
	
	oFat := MsafNFeTag():newMsafNFeTag("fat")

	oFat:setAttributeValue("nFat",retValueAttribute("infnfe:_ide:_cNF:text"))
	oFat:setAttributeValue("vOrig",oUtils:strAnyType(nTotal, "@R 999999999999.99"))
	oFat:setAttributeValue("vDesc",oUtils:strAnyType(nDesc, "@R 999999999999.99"))
	oFat:setAttributeValue("vLiq", oUtils:strAnyType(nLiq, "@R 999999999999.99"))
	
	oCobr:addElementNode(oFat)

return


/**
* Instancia o objeto que representa a tag "duplicata"
**/ 
static function DoDuplicata()
	
	local cVDup		  := 0
	local aAttribute  := retArrayAttribute("infNfe:_cobr:_dup")
	local nI		  := 1
	
	if isEmpty(aAttribute)
		oDuplicata := MsafNFeTag():newMsafNFeTag("duplicata")
		oDuplicata:setAttributeValue("nDup"	 , EMPTY_VALUE)
		oDuplicata:setAttributeValue("dVenc" , EMPTY_VALUE)
		oDuplicata:setAttributeValue("vDup"	 , DHL_NFE_FORMAT_ZERO)
	endIf
	
	for nI	:= 1 to len(aAttribute)
		
		oDuplicata := MsafNFeTag():newMsafNFeTag("duplicata")
		oDuplicata:setAttributeValue("nDup"	 , aAttribute[nI]:_Dup:text)
		oDuplicata:setAttributeValue("dVenc" , aAttribute[nI]:_dtVenc:text)
		
		cVDup := aAttribute[nI]:_vDup:text
		oDuplicata:setAttributeValue("vDup", if(Val(cVDup) > 0, cVDup, DHL_NFE_FORMAT_ZERO))
	
	next nI
	
	
	oCobr:addElementNode(oDuplicata)

return


/**
* Instancia o objeto que representa a tag "pag"
**/ 
static function DoPag()
	
	oPag := MsafNFeTag():newMsafNFeTag("pag")

	oPag:setAttributeValue("tPag",EMPTY_VALUE)
	oPag:setAttributeValue("vPag",EMPTY_VALUE)
	
	oNota:addElementNode(oPag)

return


/**
* Instancia o objeto que representa a tag "card"
**/ 
static function DoCard()
	
	oCard := MsafNFeTag():newMsafNFeTag("card")
	
	//NT 2015/003
	oCard:setAttributeValue("tpIntegra",EMPTY_VALUE)

	oCard:setAttributeValue("CNPJ",EMPTY_VALUE)
	oCard:setAttributeValue("tBand",EMPTY_VALUE)
	oCard:setAttributeValue("cAut",EMPTY_VALUE)
	
	oPag:addElementNode(oCard)

return


/**
* Instancia o objeto que representa a tag "inf_Adic"
**/ 
static function DoInfAdic()
	
	oInf_Adic := MsafNFeTag():newMsafNFeTag("inf_Adic")

	oInf_Adic:setAttributeValue("infAdFisco",retValueAttribute("infNfe:_infAdic:_fisco:text"))
	oInf_Adic:setAttributeValue("infCpl",retValueAttribute("infNfe:_infAdic:_cpl:text"))
	
	oNota:addElementNode(oInf_Adic)

return


/**
* Instancia o objeto que representa a tag "uso_livre_c"
**/ 
static function DoUsoCLivre()
	
	oUso_livre_c := MsafNFeTag():newMsafNFeTag("uso_livre_c")

	oUso_livre_c:setAttributeValue("xCampo",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oUso_livre_c:setAttributeValue("xTexto",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	
	oInf_Adic:addElementNode(oUso_livre_c)

return


/**
* Instancia o objeto que representa a tag "uso_livre_f"
**/ 
static function DoUsoFLivre()
	
	oUso_livre_f := MsafNFeTag():newMsafNFeTag("uso_livre_f")

	oUso_livre_f:setAttributeValue("xCampo",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oUso_livre_f:setAttributeValue("xTexto",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	
	oInf_Adic:addElementNode(oUso_livre_f)

return


/**
* Instancia o objeto que representa a tag "proc_referenciado"
**/ 
static function DoProcReferenciado()
	
	oProc_referenciado := MsafNFeTag():newMsafNFeTag("proc_referenciado")

	oProc_referenciado:setAttributeValue("nProc"		,EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oProc_referenciado:setAttributeValue("indProc"	,EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	
	oInf_Adic:addElementNode(oProc_referenciado)

return


/**
* Instancia o objeto que representa a tag "exporta"
**/ 
static function DoExporta()
	
	oExporta := MsafNFeTag():newMsafNFeTag("exporta")

	oExporta:setAttributeValue("UFSaidaPais",retValueAttribute("infNfe:_exporta:_UFEmbarq:text"))//TODO Tag Diferente do nfesefaz
	oExporta:setAttributeValue("xLocExporta",retValueAttribute("infNfe:_exporta:_locembarq:text"))//TODO Tag Diferente do nfesefaz
	oExporta:setAttributeValue("xLocDespacho",retValueAttribute("infNfe:_exporta:_locdespacho:text"))//TODO Tag Diferente do nfesefaz
	
	oNota:addElementNode(oExporta)

return


/**
* Instancia o objeto que representa a tag 
**/ 
static function DoCompra()
	
	oCompra := MsafNFeTag():newMsafNFeTag("compra")

	oCompra:setAttributeValue("xNEmp", retValueAttribute("infNfe:_compra:_nEmp:text"))
	oCompra:setAttributeValue("xPed",retValueAttribute("infNfe:_compra:_Pedido:text"))
	oCompra:setAttributeValue("xCont",retValueAttribute("infNfe:_compra:_Contrato:text"))
	
	oNota:addElementNode(oCompra)

return


/**
* Instancia o objeto que representa a tag "cana"
**/ 
static function DoCana()
	
	oCana := MsafNFeTag():newMsafNFeTag("cana")

	oCana:setAttributeValue("safra",EMPTY_VALUE)
	oCana:setAttributeValue("ref",EMPTY_VALUE)
	
	oNota:addElementNode(oCana)

return


/**
* Instancia o objeto que representa a tag "cana_forn_diario"
**/ 
static function DoCanaFornDiario()
	
	oCana_forn_diario := MsafNFeTag():newMsafNFeTag("cana_forn_diario")

	oCana_forn_diario:setAttributeValue("dia",EMPTY_VALUE)
	oCana_forn_diario:setAttributeValue("qtde",EMPTY_VALUE)
	
	oCana:addElementNode(oCana_forn_diario)

return

/**
* Instancia o objeto que representa o atributo "qTotMes"
*/ 
static function DoTotMesAttrib()
	
	oTotMes := MsafNFeTag():newMsafNFeTag("")

	oTotMes:setAttributeValue("qTotMes",EMPTY_VALUE)
	oTotMes:setAttributeValue("qTotAnt",EMPTY_VALUE)
	oTotMes:setAttributeValue("qTotGer",EMPTY_VALUE)
	
	oCana:addElementNode(oTotMes)

return


/**
* Instancia o objeto que representa a tag "cana_deducao"
**/ 
static function DoCanaDeducao()
	
	oCana_deducao := MsafNFeTag():newMsafNFeTag("cana_deducao")

	oCana_deducao:setAttributeValue("xDed",EMPTY_VALUE)
	oCana_deducao:setAttributeValue("vDed",EMPTY_VALUE)
	
	oCana:addElementNode(oCana_deducao)

return


/**
* Instancia o objeto que representa o atributo "vFor"
*/ 
static function DoTotDedAttrib()
	
	oTotDed := MsafNFeTag():newMsafNFeTag("")

	oTotDed:setAttributeValue("vFor",EMPTY_VALUE)
	oTotDed:setAttributeValue("vTotDed",EMPTY_VALUE)
	oTotDed:setAttributeValue("vLiqFor",EMPTY_VALUE)
	
	oCana:addElementNode(oTotDed)

return


/**
* Instancia o objeto que representa a tag "param_gerais"
**/ 
static function DoParamGerais()
	
	oParam_gerais := MsafNFeTag():newMsafNFeTag("param_gerais")

	oParam_gerais:setAttributeValue("dsImpressora",EMPTY_VALUE) //TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oParam_gerais:setAttributeValue("numeroEmbarque",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oParam_gerais:setAttributeValue("nrItens",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	
	oNota:addElementNode(oParam_gerais)

return


/**
* Instancia o objeto que representa a tag "contingencia_externa"
**/ 
static function DoContingenciaExterna()
	
	oContingencia_externa := MsafNFeTag():newMsafNFeTag("contingencia_externa")

	oContingencia_externa:setAttributeValue("flag_conting_ext",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oContingencia_externa:setAttributeValue("Dt_Ent_Cont",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oContingencia_externa:setAttributeValue("Dt_Sai_Cont",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oContingencia_externa:setAttributeValue("Mot_Cont_ext",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oContingencia_externa:setAttributeValue("cEvento",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	
	oParam_gerais:addElementNode(oContingencia_externa)

return


/**
* Instancia o objeto que representa o atributo "usuarioEmitente"
*/ 
static function DoUsuarioEmitente()
	
	oUsuarioEmitente := MsafNFeTag():newMsafNFeTag("")

	oUsuarioEmitente:setAttributeValue("usuarioEmitente",EMPTY_VALUE)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	
	oParam_gerais:addElementNode(oUsuarioEmitente)

return


/**
* Instancia o objeto que representa a tag "item_nota"
**/ 
static function DoItemNota()
	
	oItem_nota := MsafNFeTag():newMsafNFeTag("item_nota")
	
	oArquivo:addElementNode(oItem_nota)

return


/**
* Instancia o objeto que representa a tag "det"
**/ 
static function DoDet(oDetProd)
		
	oDet := MsafNFeTag():newMsafNFeTag("det")
	
	oDet:setAttributeValue("nItem",validTagValue("oDetProd:_nItem:text"))
	
	oItem_nota:addElementNode(oDet)
	
return


/**
* Instancia o objeto que representa a tag "prod"
**/ 
static function DoProd()

	oProd := MsafNFeTag():newMsafNFeTag("prod")

	oProd:setAttributeValue("cProd"	,validTagValue("oDetProd:_prod:_cProd:text"))
	oProd:setAttributeValue("cEAN"	,validTagValue("oDetProd:_prod:_EAN:text"))
	oProd:setAttributeValue("xProd"	,validTagValue("oDetProd:_prod:_Prod:text"))
	oProd:setAttributeValue("NCM"	,validTagValue("oDetProd:_prod:_NCM:text"))
	
	oItem_nota:addElementNode(oProd)

return


/**
* Instancia o objeto que representa a tag "nve"
**/ 
static function DoNve()
	
	oNve := MsafNFeTag():newMsafNFeTag("nve")
	
	oNve:setAttributeValue("NVE",validTagValue("oDetProd:_prod:_NVE:text"))
	
	oProd:addElementNode(oNve)

return


/**
* Instancia o objeto que representa o atributo "EXTIPI"
*/ 
static function DoEXTIPI()
	
	oEXTIPI := MsafNFeTag():newMsafNFeTag("")
	
	//NT 2015/003
	oEXTIPI:setAttributeValue("CEST"		,validTagValue("oDetProd:_prod:_CEST:text"))
	
	oEXTIPI:setAttributeValue("EXTIPI"		,validTagValue("oDetProd:_prod:_EXTIPI:text"))
	oEXTIPI:setAttributeValue("CFOP"		,validTagValue("oDetProd:_prod:_CFOP:text"))
	oEXTIPI:setAttributeValue("uCom"		,validTagValue("oDetProd:_prod:_uCom:text"))
	oEXTIPI:setAttributeValue("qCom"		,validTagValue("oDetProd:_prod:_qCom:text"))
	oEXTIPI:setAttributeValue("vUnCom"		,validTagValue("oDetProd:_prod:_vUnCom:text"))
	oEXTIPI:setAttributeValue("vProd"		,validTagValue("oDetProd:_prod:_vProd:text"))
	// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050] vUnComLiq e vProdLiq entre vProd e
	// cEANTrib (ordem da NT). vProdLiq = vUnComLiq x qCom (rejeicao 1279). Mesma regra do ProcMsaNFe
	If lRtcIP050
		oEXTIPI:setAttributeValue("vUnComLiq"	,validTagValue("oDetProd:_prod:_vUnComLiq:text"))
		oEXTIPI:setAttributeValue("vProdLiq"	,validTagValue("oDetProd:_prod:_vProdLiq:text"))
	EndIf
	// FIM Wellington Santana 27/11/2026
	oEXTIPI:setAttributeValue("cEANTrib"	,validTagValue("oDetProd:_prod:_eantrib:text"))
	oEXTIPI:setAttributeValue("uTrib"		,validTagValue("oDetProd:_prod:_uCom:text"))
	oEXTIPI:setAttributeValue("qTrib"		,validTagValue("oDetProd:_prod:_qCom:text"))
	oEXTIPI:setAttributeValue("vUnTrib"		,validTagValue("oDetProd:_prod:_vUnCom:text"))
	oEXTIPI:setAttributeValue("vFrete"		,validTagValue("oDetProd:_prod:_vFrete:text"))
	oEXTIPI:setAttributeValue("vSeg"		,validTagValue("oDetProd:_prod:_vSeg:text"))
	oEXTIPI:setAttributeValue("vDesc"		,validTagValue("oDetProd:_prod:_vDesc:text"))
	oEXTIPI:setAttributeValue("vOutro"		,validTagValue("oDetProd:_prod:_vOutro:text"))
	oEXTIPI:setAttributeValue("indTot"		,validTagValue("oDetProd:_prod:_indTot:text"))
	
	oProd:addElementNode(oEXTIPI)

return


/**
* Instancia o objeto que representa a tag "di" 
**/ 
static function DoDi()
	
	oDi := MsafNFeTag():newMsafNFeTag("di")
	
	oDi:setAttributeValue("nDi"				,validTagValue("oDetProd:_prod:_DI:_nDi:text"))
	oDi:setAttributeValue("dDi"				,validTagValue("oDetProd:_prod:_DI:_dtDi:text"))
	oDi:setAttributeValue("xLocDesemb"		,validTagValue("oDetProd:_prod:_DI:_LocDesemb:text"))
	oDi:setAttributeValue("UFDesemb"		,validTagValue("oDetProd:_prod:_DI:_UFDesemb:text"))
	oDi:setAttributeValue("dDesemb"			,validTagValue("oDetProd:_prod:_DI:_dtDesemb:text"))
	oDi:setAttributeValue("tpViaTransp"	,validTagValue("oDetProd:_prod:_DI:_viaTransp:text"))
	oDi:setAttributeValue("vAFRMM"			,validTagValue("oDetProd:_prod:_DI:_AFRMM:text"))
	oDi:setAttributeValue("tpIntermedio"	,validTagValue("oDetProd:_prod:_DI:_intermedio:text"))
	oDi:setAttributeValue("CNPJ"			,validTagValue("oDetProd:_prod:_DI:_CNPJ:text"))
	oDi:setAttributeValue("UFTerceiro"		,validTagValue("oDetProd:_prod:_DI:_UfTerceiro:text"))
	oDi:setAttributeValue("cExportador"	,validTagValue("oDetProd:_prod:_DI:_Exportador:text"))

	oProd:addElementNode(oDi)

return


/**
* Instancia o objeto que representa a tag "adi"
**/ 
static function DoAdi()
	
	oAdi := MsafNFeTag():newMsafNFeTag("adi")

	oAdi:setAttributeValue("nAdicao"		,validTagValue("oDetProd:_prod:_di:_adicao:_Adicao:text"))
	oAdi:setAttributeValue("nSeqAdic"		,validTagValue("oDetProd:_prod:_di:_adicao:_SeqAdic:text"))
	oAdi:setAttributeValue("cFabricante"	,validTagValue("oDetProd:_prod:_di:_adicao:_Fabricante:text"))
	oAdi:setAttributeValue("vDescDi"		,validTagValue("oDetProd:_prod:_di:_adicao:_vDescDI:text"))
	oAdi:setAttributeValue("nDraw"			,validTagValue("oDetProd:_prod:_di:_adicao:_draw:text"))
	
	oDi:addElementNode(oAdi)

return


/**
* Instancia o objeto que representa a tag "det_Export"
**/ 
static function DoDetExport(cDraw)
	
	oDet_Export := MsafNFeTag():newMsafNFeTag("det_Export")

	oDet_Export:setAttributeValue("nDraw",validTagValue("oDetProd:_prod:_detExport:_draw:text"))
	
	oProd:addElementNode(oDet_Export)

return


/**
* Instancia o objeto que representa a tag "export_Ind"
**/ 
static function DoExportInd()
	
	oExport_Ind := MsafNFeTag():newMsafNFeTag("export_Ind")
	
	oExport_Ind:setAttributeValue("nRE"		,validTagValue("oDetProd:_prod:_detExport:_exportInd:_nre:text"))
	oExport_Ind:setAttributeValue("chNFe"		,validTagValue("oDetProd:_prod:_detExport:_exportInd:_chnfe:text"))
	oExport_Ind:setAttributeValue("qExport"	,validTagValue("oDetProd:_prod:_detExport:_exportInd:_qExport:text"))
	
	oDet_Export:addElementNode(oExport_Ind)

return


/**
* Instancia o objeto que representa o atributo "xPed"
*/ 
static function DoXPed()
	
	oXPed := MsafNFeTag():newMsafNFeTag("")

	oXPed:setAttributeValue("xPed"		,validTagValue("oDetProd:_prod:_xPed:text"))
	oXPed:setAttributeValue("nItemPed"	,validTagValue("oDetProd:_prod:_nItemPed:text"))
	//oXPed:setAttributeValue("nFCI"		,"1")
	oXPed:setAttributeValue("nFCI"		,validTagValue("oDetProd:_prod:_nFCI:text"))
	
	oProd:addElementNode(oXPed)

return


/**
* Instancia o objeto que representa a tag "prod_especifico"
**/ 
static function DoProdEspecifico()
	
	oProd_especifico := MsafNFeTag():newMsafNFeTag("prod_especifico")
	
	oItem_nota:addElementNode(oProd_especifico)

return


/**
* Instancia o objeto que representa a tag "veic_Prod"
**/ 
static function DoVeicProd()
	
	oVeic_Prod := MsafNFeTag():newMsafNFeTag("veic_Prod")
	
	oVeic_Prod:setAttributeValue("tpOp"	,validTagValue("oDetProd:_prod:_veicProd:_tpOp:text"))
	oVeic_Prod:setAttributeValue("chassi"	,validTagValue("oDetProd:_prod:_veicProd:_chassi:text"))
	oVeic_Prod:setAttributeValue("cCor"	,validTagValue("oDetProd:_prod:_veicProd:_cCor:text"))
	oVeic_Prod:setAttributeValue("xcor"	,validTagValue("oDetProd:_prod:_veicProd:_xCor:text"))
	oVeic_Prod:setAttributeValue("pot"		,validTagValue("oDetProd:_prod:_veicProd:_pot:text"))
	oVeic_Prod:setAttributeValue("cilin"	,validTagValue("oDetProd:_prod:_veicProd:_Cilin:text"))
	oVeic_Prod:setAttributeValue("pesoL"	,validTagValue("oDetProd:_prod:_veicProd:_pesol:text"))
	oVeic_Prod:setAttributeValue("pesoB"	,validTagValue("oDetProd:_prod:_veicProd:_pesob:text"))
	oVeic_Prod:setAttributeValue("nSerie"	,validTagValue("oDetProd:_prod:_veicProd:_nserie:text"))
	oVeic_Prod:setAttributeValue("tpComb"	,validTagValue("oDetProd:_prod:_veicProd:_tpComb:text"))
	oVeic_Prod:setAttributeValue("nMotor"	,validTagValue("oDetProd:_prod:_veicProd:_nmotor:text"))
	oVeic_Prod:setAttributeValue("CMT"		,validTagValue("oDetProd:_prod:_veicProd:_CMT:text"))
	oVeic_Prod:setAttributeValue("dist"	,validTagValue("oDetProd:_prod:_veicProd:_dist:text"))
	oVeic_Prod:setAttributeValue("anoMod"	,validTagValue("oDetProd:_prod:_veicProd:_anomod:text"))
	oVeic_Prod:setAttributeValue("anoFab"	,validTagValue("oDetProd:_prod:_veicProd:_anofab:text"))
	oVeic_Prod:setAttributeValue("tpPint"	,validTagValue("oDetProd:_prod:_veicProd:_tppint:text"))
	oVeic_Prod:setAttributeValue("tpVeic"	,validTagValue("oDetProd:_prod:_veicProd:_tpveic:text"))
	oVeic_Prod:setAttributeValue("espveic"	,validTagValue("oDetProd:_prod:_veicProd:_espvei:text"))
	oVeic_Prod:setAttributeValue("VIN"		,validTagValue("oDetProd:_prod:_veicProd:_vin:text"))
	oVeic_Prod:setAttributeValue("condVeic",validTagValue("oDetProd:_prod:_veicProd:_condvei:text"))
	oVeic_Prod:setAttributeValue("cMod"	,validTagValue("oDetProd:_prod:_veicProd:_cMod:text"))
	oVeic_Prod:setAttributeValue("cCorDENATRAN",validTagValue("oDetProd:_prod:_veicProd:_cCorDENATRAN:text"))
	oVeic_Prod:setAttributeValue("lota"	,validTagValue("oDetProd:_prod:_veicProd:_Lota:text"))
	oVeic_Prod:setAttributeValue("tpRest"	,validTagValue("oDetProd:_prod:_veicProd:_tpRest:text"))
	
	oProd_especifico:addElementNode(oVeic_Prod)

return


/**
* Instancia o objeto que representa a tag "medicamento"
**/ 
static function DoMedicamento()
	
	oMedicamento := MsafNFeTag():newMsafNFeTag("medicamento")
	
	oMedicamento:setAttributeValue("nLote"	,validTagValue("oDetProd:_prod:_med:_Lote:text"))
	oMedicamento:setAttributeValue("qLote"	,validTagValue("oDetProd:_prod:_med:_qLote:text"))
	oMedicamento:setAttributeValue("dFab"	,validTagValue("oDetProd:_prod:_med:_dtFab:text"))
	oMedicamento:setAttributeValue("dVal"	,validTagValue("oDetProd:_prod:_med:_dtVal:text"))
	oMedicamento:setAttributeValue("Vpmc"	,validTagValue("oDetProd:_prod:_med:_vPMC:text"))
	
	oProd_especifico:addElementNode(oMedicamento)

return


/**
* Instancia o objeto que representa a tag "armamento"
**/ 
static function DoArmamento()
	
	oArmamento := MsafNFeTag():newMsafNFeTag("armamento")

	oArmamento:setAttributeValue("tpArma"	,validTagValue("oDetProd:_prod:_arma:_tpArma:text"))
	oArmamento:setAttributeValue("nSerie"	,validTagValue("oDetProd:_prod:_arma:_nSerie:text"))
	oArmamento:setAttributeValue("nCano"	,validTagValue("oDetProd:_prod:_arma:_nCano:text"))
	oArmamento:setAttributeValue("descr"	,validTagValue("oDetProd:_prod:_arma:_descr:text"))
	
	oProd_especifico:addElementNode(oArmamento)

return


/**
* Instancia o objeto que representa a tag "comb"
**/ 
static function DoComb()
	
	oComb := MsafNFeTag():newMsafNFeTag("comb")
	
	oComb:setAttributeValue("cProdANP"	,validTagValue("oDetProd:_prod:_comb:_cprodanp:text"))
	oComb:setAttributeValue("pMixGN"	,validTagValue("oDetProd:_prod:_comb:_mixGN:text"))
	oComb:setAttributeValue("CODIF"		,validTagValue("oDetProd:_prod:_comb:_codif:text"))
	oComb:setAttributeValue("qTemp"		,validTagValue("oDetProd:_prod:_comb:_qTemp:text"))
	oComb:setAttributeValue("UFCons"	,validTagValue("oDetProd:_prod:_comb:_ICMSCONS_:UFCons:text"))
	
	oProd_especifico:addElementNode(oComb)

return


/**
* Instancia o objeto que representa a tag "cide"
**/ 
static function DoCide()	
	
	oCide := MsafNFeTag():newMsafNFeTag("cide")

	oCide:setAttributeValue("qbCprod", nil)
	oCide:setAttributeValue("vAliqProd", nil)
	oCide:setAttributeValue("vCIDE", nil)
	
	oComb:addElementNode(oCide)

return


/**
* Instancia o objeto que representa a tag "encerrante"
**/ 
static function DoEncerrante()	
	
	oEncerrante := MsafNFeTag():newMsafNFeTag("encerrante")

	oEncerrante:setAttributeValue("nBico", nil)
	oEncerrante:setAttributeValue("nBomba", nil)
	oEncerrante:setAttributeValue("nTanque", nil)
	oEncerrante:setAttributeValue("vEncIni", nil)
	oEncerrante:setAttributeValue("vEncFim", nil)
	
	oComb:addElementNode(oEncerrante)

return


/**
* Instancia o objeto que representa o atributo "nRECOPI"
*/ 
static function DoNRecopi()
	
	oNRecopi := MsafNFeTag():newMsafNFeTag("")

	oNRecopi:setAttributeValue("nRECOPI",EMPTY_VALUE)
	
	oProd_especifico:addElementNode(oNRecopi)

return


/**
* Instancia o objeto que representa a tag "impostos"
**/ 
static function DoImpostos()
	
	local lFormatZero := .T.
	local nTotTrib	  := if (cTypeInv == DHL_NFE_INVOICE_OUTFLOW, SF2->F2_TOTIMP, 0)
	local oUtils	  := IpUtilsObject():newIpUtilsObject()
	
	oImpostos := MsafNFeTag():newMsafNFeTag("impostos")

	oImpostos:setAttributeValue("vTotTrib", if (nTotTrib > 0, oUtils:strAnyType(nTotTrib, "@R 999999999999.99"), ""))	
	
	oItem_nota:addElementNode(oImpostos)

return


/**
* Instancia o objeto que representa a tag "ICMS"
**/ 
static function DoICMS()
	
	oICMS := MsafNFeTag():newMsafNFeTag("ICMS")
	
	oImpostos:addElementNode(oICMS)

return


/**
 * Instancia o objeto que representa a tag "icms_00"
 */ 
static function DoIcms00(oDetProd)
	
	local lFormatZero := .F.
	local cTax		  := "ICMS"
	local cAliq		  := "00"

	oIcms_00 := MsafNFeTag():newMsafNFeTag("icms_00")

	oIcms_00:setAttributeValue("orig"	,retValTax(cTax, cAliq, oDetProd, "orig", "cpl", lFormatZero))
	oIcms_00:setAttributeValue("CST"	,retValTax(cTax, cAliq, oDetProd, "CST","tributo", lFormatZero))
	oIcms_00:setAttributeValue("modBC"	,retValTax(cTax, cAliq, oDetProd, "modBC", "tributo", lFormatZero))
	oIcms_00:setAttributeValue("vBC"	,retValTax(cTax, cAliq, oDetProd, "vBC", "tributo"))
	oIcms_00:setAttributeValue("pICMS"	,retValTax(cTax, cAliq, oDetProd, "aliquota", "tributo")) 
	oIcms_00:setAttributeValue("vICMS"	,retValTax(cTax, cAliq, oDetProd, "valor", "tributo")) 
	
	oICMS:addElementNode(oIcms_00)

return


/**
* Instancia o objeto que representa a tag "icms_10"
**/ 
static function DoIcms10()
	
	local lFormatZero := .F.
	local cTax		  := "ICMS"
	local cAliq		  := "10"
	
	oIcms_10 := MsafNFeTag():newMsafNFeTag("icms_10")

	oIcms_10:setAttributeValue("orig"		,retValTax(cTax, cAliq, oDetProd, "orig", "cpl", lFormatZero))
	oIcms_10:setAttributeValue("CST"		,retValTax(cTax, cAliq, oDetProd, "CST", "tributo", lFormatZero))
	oIcms_10:setAttributeValue("modBC"		,retValTax(cTax, cAliq, oDetProd, "modBC", "tributo", lFormatZero))
	oIcms_10:setAttributeValue("vBC"		,retValTax(cTax, cAliq, oDetProd, "vBV", "tributo"))
	oIcms_10:setAttributeValue("pICMS"		,retValTax(cTax, cAliq, oDetProd, "pICMS", "tributo"))
	oIcms_10:setAttributeValue("vICMS"		,retValTax(cTax, cAliq, oDetProd, "vICMS", "tributo"))
	oIcms_10:setAttributeValue("modBCST"	,retValTax(cTax, cAliq, oDetProd, "modBCST", "tributo" , lFormatZero))
	oIcms_10:setAttributeValue("pMVAST"		,retValTax(cTax, cAliq, oDetProd, "pMVAST", "tributo"))
	oIcms_10:setAttributeValue("pRedBCST"	,retValTax(cTax, cAliq, oDetProd, "pRedBCST", "tributo"))
	oIcms_10:setAttributeValue("vBCST"		,retValTax(cTax, cAliq, oDetProd, "vBCST", "tributo"))
	oIcms_10:setAttributeValue("pICMSST"	,retValTax(cTax, cAliq, oDetProd, "aliquota", "tributo"))
	oIcms_10:setAttributeValue("vICMSST"	,retValTax(cTax, cAliq, oDetProd, "valor", "tributo"))
	
	oICMS:addElementNode(oIcms_10)

return


/**
* Instancia o objeto que representa a tag "icms_20"
**/ 
static function DoIcms20()
	
	local lFormatZero := .F.
	local cTax		  := "ICMS"
	local cAliq		  := "20"
	
	oIcms_20 := MsafNFeTag():newMsafNFeTag("icms_20")

	oIcms_20:setAttributeValue("orig"	,retValTax(cTax, cAliq, oDetProd, "orig", "cpl", lFormatZero))
	oIcms_20:setAttributeValue("CST"	,retValTax(cTax, cAliq, oDetProd, "CST", "tributo", lFormatZero))
	oIcms_20:setAttributeValue("modBC"	,retValTax(cTax, cAliq, oDetProd, "modBC", "tributo", lFormatZero))
	oIcms_20:setAttributeValue("pRedBC" ,retValTax(cTax, cAliq, oDetProd, "pRedBC", "tributo"))
	oIcms_20:setAttributeValue("vBC"	,retValTax(cTax, cAliq, oDetProd, "vBC", "tributo"))
	oIcms_20:setAttributeValue("pICMS"	,retValTax(cTax, cAliq, oDetProd, "aliquota", "tributo"))
	oIcms_20:setAttributeValue("vICMS"	,retValTax(cTax, cAliq, oDetProd, "valor", "tributo"))
	
	oICMS:addElementNode(oIcms_20)

return


/**
* Instancia o objeto que representa a tag "x_icms20_deson"
**/ 
static function DoIcms20Deson()
	
	local cTax		:= "ICMS"
	local cAliq		:= "20"
	
	oIcms20_deson := MsafNFeTag():newMsafNFeTag("x_icms20_deson")

	oIcms20_deson:setAttributeValue("vICMSDeson",retValTax(cTax, cAliq, oDetProd, "vICMSDeson","tributo"))
	oIcms20_deson:setAttributeValue("motDesICMS",retValTax(cTax, cAliq, oDetProd, "motDesICMS","tributo"))
	
	oIcms_20:addElementNode(oIcms20_deson)

return


/**
* Instancia o objeto que representa a tag "icms_30"
**/ 
static function DoIcms30()
	
	local lFormatZero := .F.
	local cTax		  := "ICMS"
	local cAliq		  := "30"
	
	oIcms_30 := MsafNFeTag():newMsafNFeTag("icms_30")

	oIcms_30:setAttributeValue("orig"		,retValTax(cTax, cAliq, oDetProd, "orig", "cpl", lFormatZero))
	oIcms_30:setAttributeValue("CST"		,retValTax(cTax, cAliq, oDetProd, "CST","tributo", lFormatZero))
	oIcms_30:setAttributeValue("modBCST"	,retValTax(cTax, cAliq, oDetProd, "modBCST","tributo", lFormatZero))
	oIcms_30:setAttributeValue("pMVAST"		,retValTax(cTax, cAliq, oDetProd, "pMVAST","tributo"))
	oIcms_30:setAttributeValue("pRedBCST"	,retValTax(cTax, cAliq, oDetProd, "pRedBCST","tributo"))
	oIcms_30:setAttributeValue("vBCST"		,retValTax(cTax, cAliq, oDetProd, "vBCST","tributo"))
	oIcms_30:setAttributeValue("pICMSST"	,retValTax(cTax, cAliq, oDetProd, "aliquota","tributo"))
	oIcms_30:setAttributeValue("vICMSST"	,retValTax(cTax, cAliq, oDetProd, "valor","tributo"))
	
	oICMS:addElementNode(oIcms_30)

return


/**
* Instancia o objeto que representa a tag "x_icms30_deson"
**/ 
static function DoIcms30Deson()
	
	local cTax	:= "ICMS"
	local cAliq	:= "30"
	
	oIcms30_deson := MsafNFeTag():newMsafNFeTag("x_icms30_deson")

	oIcms30_deson:setAttributeValue("vICMSDeson",retValTax(cTax, cAliq, oDetProd, "vICMSDeson","tributo"))
	oIcms30_deson:setAttributeValue("motDesICMS",retValTax(cTax, cAliq, oDetProd, "motDesICMS","tributo"))
	
	oIcms_30:addElementNode(oIcms30_deson)

return


/**
* Instancia o objeto que representa a tag "icms_40"
**/ 
static function DoIcms40()
	
	local lFormatZero := .F.
	local cTax		  := "ICMS"
	local cAliq		  := "40,41,50"
	
	oIcms_40 := MsafNFeTag():newMsafNFeTag("icms_40")

	oIcms_40:setAttributeValue("orig"	,retValTax(cTax, cAliq, oDetProd, "orig", "cpl", lFormatZero))
	oIcms_40:setAttributeValue("CST"	,retValTax(cTax, cAliq, oDetProd, "CST", "tributo", lFormatZero))
	
	oICMS:addElementNode(oIcms_40)

return


/**
* Instancia o objeto que representa a tag "x_icms40_deson"
**/ 
static function DoIcms40Deson()
	
	local cTax	:= "ICMS"
	local cAliq	:= "40,41,50" 
	
	oIcms40_deson := MsafNFeTag():newMsafNFeTag("x_icms40_deson")

	oIcms40_deson:setAttributeValue("vICMSDeson",retValTax(cTax, cAliq, oDetProd, "vICMSDeson","tributo"))
	oIcms40_deson:setAttributeValue("motDesICMS",retValTax(cTax, cAliq, oDetProd, "motDesICMS","tributo"))
	
	oIcms_40:addElementNode(oIcms40_deson)

return


/**
* Instancia o objeto que representa a tag "icms_51"
**/ 
static function DoIcms51()
	
	local lFormatZero := .F.
	local cTax		  := "ICMS"
	local cAliq		  := "51" 
	
	oIcms_51 := MsafNFeTag():newMsafNFeTag("icms_51")

	oIcms_51:setAttributeValue("orig"		,retValTax(cTax, cAliq, oDetProd, "orig", "cpl", lFormatZero))
	oIcms_51:setAttributeValue("CST"		,retValTax(cTax, cAliq, oDetProd, "CST", "tributo", lFormatZero))
	oIcms_51:setAttributeValue("modBC"		,retValTax(cTax, cAliq, oDetProd, "modBC", "tributo", lFormatZero))
	oIcms_51:setAttributeValue("pRedBC"		,retValTax(cTax, cAliq, oDetProd, "pRedBC", "tributo"))
	oIcms_51:setAttributeValue("vBC"		,retValTax(cTax, cAliq, oDetProd, "vBC", "tributo"))
	oIcms_51:setAttributeValue("pICMS"		,retValTax(cTax, cAliq, oDetProd, "aliquota", "tributo"))
	oIcms_51:setAttributeValue("vICMSOp"	,retValTax(cTax, cAliq, oDetProd, "vICMSOp", "tributo"))
	oIcms_51:setAttributeValue("pDif"		,retValTax(cTax, cAliq, oDetProd, "pDif", "tributo"))
	oIcms_51:setAttributeValue("vICMSDif"	,retValTax(cTax, cAliq, oDetProd, "vICMSDif", "tributo"))
	oIcms_51:setAttributeValue("vICMS"		,retValTax(cTax, cAliq, oDetProd, "valor", "tributo"))
	
	oICMS:addElementNode(oIcms_51)

return


/**
* Instancia o objeto que representa a tag "icms_60"
**/ 
static function DoIcms60()
	
	local lFormatZero 	:= .F.
	local cTax			:= "ICMS"
	local cAliq			:= "60" 
	
	oIcms_60 := MsafNFeTag():newMsafNFeTag("icms_60")

	oIcms_60:setAttributeValue("orig",retValTax(cTax, cAliq, oDetProd, "orig", "cpl", lFormatZero))
	oIcms_60:setAttributeValue("CST",retValTax(cTax, cAliq, oDetProd, "CST","tributo", lFormatZero))
	
	oICMS:addElementNode(oIcms_60)

return


/**
* Instancia o objeto que representa a tag "x_icms60_retido"
**/ 
static function DoIcms60Retido()
		
	local cTax	:= "ICMS"
	local cAliq	:= "60" 
	
	oIcms60_retido := MsafNFeTag():newMsafNFeTag("x_icms60_retido")

	oIcms60_retido:setAttributeValue("vBCSTRet"	,retValTax(cTax, cAliq, oDetProd, "vBCSTRet","tributo"))
	oIcms60_retido:setAttributeValue("vICMSSTRet"	,retValTax(cTax, cAliq, oDetProd, "vICMSSTRet","tributo"))
	
	oIcms_60:addElementNode(oIcms60_retido)

return


/**
* Instancia o objeto que representa a tag "icms_70"
**/ 
static function DoIcms70()
	
	local lFormatZero  := .F.
	local cTax		   := "ICMS"
	local cAliq		   := "70" 
	
	oIcms_70 := MsafNFeTag():newMsafNFeTag("icms_70")

	oIcms_70:setAttributeValue("orig"		,retValTax(cTax, cAliq, oDetProd, "orig", "cpl", lFormatZero))
	oIcms_70:setAttributeValue("CST"		,retValTax(cTax, cAliq, oDetProd, "CST","tributo", lFormatZero))
	oIcms_70:setAttributeValue("modBC"		,retValTax(cTax, cAliq, oDetProd, "modBC","tributo", lFormatZero))
	oIcms_70:setAttributeValue("pRedBC"		,retValTax(cTax, cAliq, oDetProd, "pRedBC","tributo")) 
	oIcms_70:setAttributeValue("vBC"		,retValTax(cTax, cAliq, oDetProd, "vBC","tributo")) 
	oIcms_70:setAttributeValue("pICMS"		,retValTax(cTax, cAliq, oDetProd, "aliquota","tributo")) 
	oIcms_70:setAttributeValue("vICMS"		,retValTax(cTax, cAliq, oDetProd, "valor","tributo")) 
	oIcms_70:setAttributeValue("modBCST"	,retValTax(cTax, cAliq, oDetProd, "modBCST","tributo"))
	oIcms_70:setAttributeValue("pMVAST"		,retValTax(cTax, cAliq, oDetProd, "pMVAST","tributo"))
	oIcms_70:setAttributeValue("pRedBCST"	,retValTax(cTax, cAliq, oDetProd, "pRedBCST","tributo"))
	oIcms_70:setAttributeValue("vBCST"		,retValTax(cTax, cAliq, oDetProd, "vBCST","tributo"))
	oIcms_70:setAttributeValue("pICMSST"	,retValTax(cTax, cAliq, oDetProd, "pICMSST","tributo"))
	oIcms_70:setAttributeValue("vICMSST"	,retValTax(cTax, cAliq, oDetProd, "vICMSST","tributo"))
	
	oICMS:addElementNode(oIcms_70)

return


/**
* Instancia o objeto que representa a tag "x_icms70_deson"
**/ 
static function DoIcms70Deson()
	
	local cTax	:= "ICMS"
	local cAliq	:= "70" 
	
	oIcms70_deson := MsafNFeTag():newMsafNFeTag("x_icms70_deson")

	oIcms70_deson:setAttributeValue("vICMSDeson",retValTax(cTax, cAliq, oDetProd, "vICMSDeson","tributo"))
	oIcms70_deson:setAttributeValue("motDesICMS",retValTax(cTax, cAliq, oDetProd, "motDesICMS","tributo"))
	
	oIcms_70:addElementNode(oIcms70_deson)

return


/**
* Instancia o objeto que representa a tag "icms_90"
**/ 
static function DoIcms90()
	
	local lFormatZero 	:= .F.
	local cTax			:= "ICMS"
	local cAliq			:= "90" 
	
	oIcms_90 := MsafNFeTag():newMsafNFeTag("icms_90")

	oIcms_90:setAttributeValue("orig"	,retValTax(cTax, cAliq, oDetProd, "orig", "cpl", lFormatZero))
	oIcms_90:setAttributeValue("CST"	,retValTax(cTax, cAliq, oDetProd, "CST","tributo", lFormatZero))
	
	oICMS:addElementNode(oIcms_90)

return


/**
* Instancia o objeto que representa a tag "x_icms90_icms"
**/ 
static function DoIcms90Icms()
	
	local lFormatZero 	:= .F.
	local cTax			:= "ICMS"
	local cAliq			:= "90" 
		
	oIcms90_icms := MsafNFeTag():newMsafNFeTag("x_icms90_icms")

	oIcms90_icms:setAttributeValue("modBC"	,retValTax(cTax, cAliq, oDetProd, "modBC","tributo", lFormatZero))
	oIcms90_icms:setAttributeValue("vBC"	,retValTax(cTax, cAliq, oDetProd, "vBC","tributo"))
	oIcms90_icms:setAttributeValue("pRedBC",retValTax(cTax, cAliq, oDetProd, "pRedBC","tributo")) 
	oIcms90_icms:setAttributeValue("pICMS"	,retValTax(cTax, cAliq, oDetProd, "aliquota","tributo")) 
	oIcms90_icms:setAttributeValue("vICMS"	,retValTax(cTax, cAliq, oDetProd, "valor","tributo"))
	
	oIcms_90:addElementNode(oIcms90_icms)

return


/**
* Instancia o objeto que representa a tag "x_icms90_icmsst"
**/ 
static function DoIcms90STIcms()
	
	local lFormatZero 	:= .F.
	local cTax			:= "ICMSST"
	local cAliq			:= "90" 
	
	oIcms90_icmsst := MsafNFeTag():newMsafNFeTag("x_icms90_icmsst")

	oIcms90_icmsst:setAttributeValue("modBCST"	,retValTax(cTax, cAliq, oDetProd, "modBCST","tributo", lFormatZero))
	oIcms90_icmsst:setAttributeValue("pMVAST"		,retValTax(cTax, cAliq, oDetProd, "pMVAST","tributo"))
	oIcms90_icmsst:setAttributeValue("pRedBCST"	,retValTax(cTax, cAliq, oDetProd, "pRedBCST","tributo"))
	oIcms90_icmsst:setAttributeValue("vBCST"		,retValTax(cTax, cAliq, oDetProd, "vBCST","tributo"))
	oIcms90_icmsst:setAttributeValue("pICMSST"	,retValTax(cTax, cAliq, oDetProd, "aliquota","tributo"))
	oIcms90_icmsst:setAttributeValue("vICMSST"	,retValTax(cTax, cAliq, oDetProd, "valor","tributo"))
	
	oIcms_90:addElementNode(oIcms90_icmsst)

return


/**
* Instancia o objeto que representa a tag "x_icms90_deson"
**/ 
static function DoIcms90Deson()
	
	local cTax	:= "ICMS"
	local cAliq	:= "90" 
	
	oIcms90_deson := MsafNFeTag():newMsafNFeTag("x_icms90_deson")

	oIcms90_deson:setAttributeValue("vICMSDeson",retValTax(cTax, cAliq, oDetProd, "vICMSDeson","tributo"))
	oIcms90_deson:setAttributeValue("motDesICMS",retValTax(cTax, cAliq, oDetProd, "motDesICMS","tributo"))
	
	oIcms_90:addElementNode(oIcms90_deson)

return


/**
* Instancia o objeto que representa a tag "icms_part"
**/ 
static function DoIcmspart()
	
	oIcms_part := MsafNFeTag():newMsafNFeTag("icms_part")

	oIcms_part:setAttributeValue("orig",) //TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("CST",) //TODO DIEGO - Diogo irá verificar com DHL / Mastersaf	
	oIcms_part:setAttributeValue("modBC",) //TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("vBC",)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("pRedBC",)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("pICMS",)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("vICMS",)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("modBCST",)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("pMVAST",)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("pRedBCST",)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("vBCST",)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("pICMSST",)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("vICMSST",)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("pBCOp",)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_part:setAttributeValue("UFST",)//TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	
	oICMS:addElementNode(oIcms_part)

return


/**
* Instancia o objeto que representa a tag "icms_st"
**/ 
static function DoIcmsST()
	
	oIcms_st := MsafNFeTag():newMsafNFeTag("icms_st")

	oIcms_st:setAttributeValue("orig",) //TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_st:setAttributeValue("CST",) //TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_st:setAttributeValue("vBCSTRet",) //TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_st:setAttributeValue("vICMSSTRet",) //TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_st:setAttributeValue("vBCSTDest",) //TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	oIcms_st:setAttributeValue("vICMSSTDest",) //TODO DIEGO - Diogo irá verificar com DHL / Mastersaf
	
	oICMS:addElementNode(oIcms_st)

return


/**
* Instancia o objeto que representa a tag "icms_sn101"
**/ 
static function DoSNIcms101()
	
	local lFormatZero 	:= .F.
	local cTax			:= "ICMSSN"
	local cAliq			:= "101" 
	
	oIcms_sn101 := MsafNFeTag():newMsafNFeTag("icms_sn101")

	oIcms_sn101:setAttributeValue("orig"		,retValTax(cTax, cAliq, oDetProd, "orig", "cpl", lFormatZero))
	oIcms_sn101:setAttributeValue("CSOSN"		,retValTax(cTax, cAliq, oDetProd, "CSOSN","tributo", lFormatZero))
	oIcms_sn101:setAttributeValue("pCredSN"		,retValTax(cTax, cAliq, oDetProd, "pCredSN","tributo"))
	oIcms_sn101:setAttributeValue("vCredICMSSN"	,retValTax(cTax, cAliq, oDetProd, "vCredICMSSN","tributo"))
	
	oICMS:addElementNode(oIcms_sn101)

return


/**
* Instancia o objeto que representa a tag "icms_sn102"
**/ 
static function DoIcmssn102()
	
	local lFormatZero := .F.
	local cTax		  := "ICMSSN"
	local cAliq		  := "102,103,300,400" 
	
	oIcms_sn102 := MsafNFeTag():newMsafNFeTag("icms_sn102")

	oIcms_sn102:setAttributeValue("orig"	,retValTax(cTax, cAliq, oDetProd, "orig", "cpl", lFormatZero))
	oIcms_sn102:setAttributeValue("CSOSN"	,retValTax(cTax, cAliq, oDetProd, "CSOSN","tributo"))
	
	oICMS:addElementNode(oIcms_sn102)

return


/**
* Instancia o objeto que representa a tag "icms_sn201"
**/ 
static function DoSNIcms201()
	
	local lFormatZero := .F.
	local cTax		  := "ICMSSN"
	local cAliq		  := "201" 
	
	oIcms_sn201 := MsafNFeTag():newMsafNFeTag("icms_sn201")

	oIcms_sn201:setAttributeValue("orig"		,retValTax(cTax, cAliq, oDetProd, "orig","cpl", lFormatZero))
	oIcms_sn201:setAttributeValue("CSOSN"		,retValTax(cTax, cAliq, oDetProd, "CSOSN","tributo", lFormatZero))
	oIcms_sn201:setAttributeValue("modBCST"	,retValTax(cTax, cAliq, oDetProd, "modBCST","tributo", lFormatZero))
	oIcms_sn201:setAttributeValue("pMVAST"		,retValTax(cTax, cAliq, oDetProd, "pMVAST","tributo"))
	oIcms_sn201:setAttributeValue("pRedBCST"	,retValTax(cTax, cAliq, oDetProd, "pRedBCST","tributo"))
	oIcms_sn201:setAttributeValue("vBCST"		,retValTax(cTax, cAliq, oDetProd, "vBCST","tributo"))
	oIcms_sn201:setAttributeValue("pICMSST"	,retValTax(cTax, cAliq, oDetProd, "aliquota","tributo"))
	oIcms_sn201:setAttributeValue("vICMSST"	,retValTax(cTax, cAliq, oDetProd, "valor","tributo"))
	oIcms_sn201:setAttributeValue("pCredSN"	,retValTax(cTax, cAliq, oDetProd, "pCredSN","tributo"))
	oIcms_sn201:setAttributeValue("vCredICMSSN",retValTax(cTax,cAliq, oDetProd, "vCredICMSSN","tributo"))
	
	oICMS:addElementNode(oIcms_sn201)

return


/**
* Instancia o objeto que representa a tag "icms_sn202"
**/ 
static function DoIcmssn202()
	
	local lFormatZero 	:= .F.
	local cTax			:= "ICMSSN"
	local cAliq			:= "202,203" 
	
	oIcms_sn202 := MsafNFeTag():newMsafNFeTag("icms_sn202")

	oIcms_sn202:setAttributeValue("orig"		,retValTax(cTax,cAliq, oDetProd, "orig","cpl", lFormatZero))
	oIcms_sn202:setAttributeValue("CSOSN"		,retValTax(cTax,cAliq, oDetProd, "CSOSN","tributo", lFormatZero))
	oIcms_sn202:setAttributeValue("modBCST"		,retValTax(cTax,cAliq, oDetProd, "modBCST","tributo", lFormatZero))
	oIcms_sn202:setAttributeValue("pMVAST"		,retValTax(cTax,cAliq, oDetProd, "pMVAST","tributo"))
	oIcms_sn202:setAttributeValue("pRedBCST"	,retValTax(cTax,cAliq, oDetProd, "pRedBCST","tributo"))
	oIcms_sn202:setAttributeValue("vBCST"		,retValTax(cTax,cAliq, oDetProd, "vBCST","tributo"))
	oIcms_sn202:setAttributeValue("pICMSST"		,retValTax(cTax,cAliq, oDetProd, "aliquota","tributo"))
	oIcms_sn202:setAttributeValue("vICMSST"		,retValTax(cTax,cAliq, oDetProd, "valor","tributo"))
	
	oICMS:addElementNode(oIcms_sn202)

return


/**
* Instancia o objeto que representa a tag "icms_sn500"
**/ 
static function DoIcmssn500()
	
	local lFormatZero 	:= .F.
	local cTax			:= "ICMSSN"
	local cAliq			:= "500" 
	
	oIcms_sn500 := MsafNFeTag():newMsafNFeTag("icms_sn500")

	oIcms_sn500:setAttributeValue("orig"	,retValTax(cTax,cAliq, oDetProd, "orig","cpl", lFormatZero))
	oIcms_sn500:setAttributeValue("CSOSN"	,retValTax(cTax,cAliq, oDetProd, "CSOSN","tributo", lFormatZero))
	
	oICMS:addElementNode(oIcms_sn500)

return


/**
* Instancia o objeto que representa a tag "x_sn500_retido"
**/ 
static function DoSn500Retido()
	
	local cTax	:= "ICMSSN"
	local cAliq	:= "500" 
	
	oSn500_retido := MsafNFeTag():newMsafNFeTag("x_sn500_retido")

	oSn500_retido:setAttributeValue("vBCSTRet"	,retValTax(cTax,cAliq, oDetProd, "vBCSTRet","tributo"))
	oSn500_retido:setAttributeValue("vICMSSTRet"	,retValTax(cTax,cAliq, oDetProd, "vICMSSTRet","tributo"))
	
	oIcms_sn500:addElementNode(oSn500_retido)

return


/**
* Instancia o objeto que representa a tag "icms_sn900"
**/ 
static function DoIcmssn900()
	
	local lFormatZero 	:= .F.
	local cTax			:= "ICMSSN"
	local cAliq			:= "900" 
	
	oIcms_sn900 := MsafNFeTag():newMsafNFeTag("icms_sn900")

	oIcms_sn900:setAttributeValue("orig"	,retValTax(cTax,cAliq, oDetProd, "orig","cpl", lFormatZero))
	oIcms_sn900:setAttributeValue("CSOSN"	,retValTax(cTax,cAliq, oDetProd, "CSOSN", "tributo", lFormatZero))
	
	oICMS:addElementNode(oIcms_sn900)

return


/**
* Instancia o objeto que representa a tag "x_sn900_icms"
**/ 
static function DoSn900Icms()
	
	local lFormatZero 	:= .F.
	local cTax			:= "ICMSSN"
	local cAliq			:= "900" 	
	
	oSn900_icms := MsafNFeTag():newMsafNFeTag("x_sn900_icms")

	oSn900_icms:setAttributeValue("modBC"	,retValTax(cTax,cAliq, oDetProd, "modBC","tributo", lFormatZero))
	oSn900_icms:setAttributeValue("vBC"	,retValTax(cTax,cAliq, oDetProd, "vBC","tributo"))
	oSn900_icms:setAttributeValue("pRedBC"	,retValTax(cTax,cAliq, oDetProd, "pRedBC","tributo"))
	oSn900_icms:setAttributeValue("pICMS"	,retValTax(cTax,cAliq, oDetProd, "aliquota","tributo"))
	oSn900_icms:setAttributeValue("vICMS"	,retValTax(cTax,cAliq, oDetProd, "valor","tributo"))
	
	oIcms_sn900:addElementNode(oSn900_icms)

return


/**
* Instancia o objeto que representa a tag "x_sn900_icmsst"
**/ 
static function DoSTSn900Icms()
	
	local lFormatZero 	:= .F.
	local cTax			:= "ICMSSN"
	local cAliq			:= "900" 
	
	oSn900_icmsst 	:= MsafNFeTag():newMsafNFeTag("x_sn900_icmsst")

	oSn900_icmsst:setAttributeValue("modBCST"	,retValTax(cTax,cAliq, oDetProd, "modBCST","tributo", lFormatZero))
	oSn900_icmsst:setAttributeValue("pMVAST"	,retValTax(cTax,cAliq, oDetProd, "pMVAST","tributo"))
	oSn900_icmsst:setAttributeValue("pRedBCST"	,retValTax(cTax,cAliq, oDetProd, "pRedBCST","tributo"))
	oSn900_icmsst:setAttributeValue("vBCST"		,retValTax(cTax,cAliq, oDetProd, "vBCST","tributo"))
	oSn900_icmsst:setAttributeValue("pICMSST"	,retValTax(cTax,cAliq, oDetProd, "aliquota","tributo"))
	oSn900_icmsst:setAttributeValue("vICMSST"	,retValTax(cTax,cAliq, oDetProd, "valor","tributo"))
	
	oIcms_sn900:addElementNode(oSn900_icmsst)

return


/**
* Instancia o objeto que representa a tag "x_sn900_credito"
**/ 
static function DoSn900Credito()

	local cTax	:= "ICMSSN"
	local cAliq	:= "900" 	

	oSn900_credito := MsafNFeTag():newMsafNFeTag("x_sn900_credito")

	oSn900_credito:setAttributeValue("pCredSN"		,retValTax(cTax,cAliq, oDetProd, "pCredSN","tributo"))
	oSn900_credito:setAttributeValue("vCredICMSSN"	,retValTax(cTax,cAliq, oDetProd, "vCredICMSSN","tributo"))
	
	oIcms_sn900:addElementNode(oSn900_credito)

return


/**
* Instancia o objeto que representa a tag "ICMS_UF_Dest;"
**/ 
static function DoIcmsUfDest()

	local cTax	:= "ICMSUFDest"
	local cAliq	:= "" //A COMPLETAR	
	
	oIcmsUf := MsafNFeTag():newMsafNFeTag("ICMS_UF_Dest")

	oIcmsUf:setAttributeValue("vBCUFDest"		, retValTax(cTax,cAliq, oDetProd, "VBC","tributo")) 
	oIcmsUf:setAttributeValue("pFCPUFDest"		, retValTax(cTax,cAliq, oDetProd, "pFCPUF","tributo"))
	oIcmsUf:setAttributeValue("pICMSUFDest"		, retValTax(cTax,cAliq, oDetProd, "Aliquota","tributo"))
	oIcmsUf:setAttributeValue("pICMSInter"		, retValTax(cTax,cAliq, oDetProd, "AliquotaInter","tributo"))
	oIcmsUf:setAttributeValue("pICMSInterPart"	, retValTax(cTax,cAliq, oDetProd, "pICMSInter","tributo"))
	oIcmsUf:setAttributeValue("vFCPUFDest"		, retValTax(cTax,cAliq, oDetProd, "ValorFCP","tributo"))
	oIcmsUf:setAttributeValue("vICMSUFDest"		, retValTax(cTax,cAliq, oDetProd, "ValorICMSDes","tributo"))
	oIcmsUf:setAttributeValue("vICMSUFRemet"	, retValTax(cTax,cAliq, oDetProd, "ValorICMSRem","tributo"))
	
	oImpostos:addElementNode(oIcmsUf)

return


/**
* Instancia o objeto que representa a tag "IPI"
**/ 
static function DoIPI()

	local cTax	:= "IPI"
	local cAliq	:= "" 	
	local cEnq	:= retValTax(cTax,cAliq, oDetProd, "cenq", "cpl")
	
	if empty(cEnq)
		cEnq := retValTax(cTax,cAliq, oDetProd, "cpl:_cEnq","tributo")
	endif 
	
	oIPI := MsafNFeTag():newMsafNFeTag("IPI")

	oIPI:setAttributeValue("cIEnq"		, "") 
	oIPI:setAttributeValue("CNPJProd"	, "")
	oIPI:setAttributeValue("cSelo"		, "")
	oIPI:setAttributeValue("qSelo"		, "")
	oIPI:setAttributeValue("cEnq"		, iif(empty(cEnq), "999", cEnq))
	
	oImpostos:addElementNode(oIPI)

return


/**
* Instancia o objeto que representa a tag "ipi_trib"
**/ 
static function DoIpiTrib()
	
	local lFormatZero := .F.
	local cTax	:= "IPI"
	local cAliq	:= "00,49,50,99" 	
	
	oIpi_trib := MsafNFeTag():newMsafNFeTag("ipi_trib")

	oIpi_trib:setAttributeValue("CST",retValTax(cTax,cAliq, oDetProd, "CST", "tributo", lFormatZero))
	
	oIPI:addElementNode(oIpi_trib)

return


/**
* Instancia o objeto que representa a tag "x_ipi_aliq"
**/ 
static function DoIpiAliq()
	
	local cTax	:= "IPI"
	local cAliq	:= "00,49,50,99" 
	
	oIpi_aliq := MsafNFeTag():newMsafNFeTag("x_ipi_aliq")

	oIpi_aliq:setAttributeValue("vBC"	, retValTax(cTax, cAliq, oDetProd, "vBC", "tributo"))
	oIpi_aliq:setAttributeValue("pIPI"	, retValTax(cTax, cAliq, oDetProd, "aliquota", "tributo"))
	
	oIpi_trib:addElementNode(oIpi_aliq)

return


/**
* Instancia o objeto que representa a tag "x_ipi_unid"
**/ 
static function DoIpiUnid()
	
	local cTax			:= "IPI"
	local cAliq			:= "00,49,50,99" 
	local lFomatzero	:= .t.
	local cQUnid		:= ""
	local cVUnid		:= ""		
	
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_SPL) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_REV) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_REP)
		lFomatzero := .f.
		// Alteração realizada por Cassiano Ribeiro no dia 05/01/16 - conforme SVN
		cQUnid := iif(retValTax(cTax,cAliq, oDetProd, "aliquota", "tributo", lFomatzero) == '0' .AND. retValTax(cTax,cAliq, oDetProd, "vlTrib", "tributo", lFomatzero) == '0', '', retValTax(cTax,cAliq, oDetProd, "qTrib", "tributo", lFomatzero)) 
		cVUnid := iif(retValTax(cTax,cAliq, oDetProd, "vlTrib", "tributo", lFomatzero)  == '0', '', retValTax(cTax,cAliq, oDetProd, "vlTrib", "tributo", lFomatzero))
	else
		cQUnid := retValTax(cTax,cAliq, oDetProd, "qTrib", "tributo", lFomatzero)
		cVUnid := retValTax(cTax,cAliq, oDetProd, "vlTrib", "tributo", lFomatzero)
	endif
	
	oIpi_unid := MsafNFeTag():newMsafNFeTag("x_ipi_unid")

	oIpi_unid:setAttributeValue("qUnid", cQUnid)
	oIpi_unid:setAttributeValue("vUnid", cVUnid)
	
	oIpi_trib:addElementNode(oIpi_unid)
	oIpi_trib:setAttributeValue("vIPI"	, retValTax(cTax,cAliq, oDetProd, "valor","tributo"))

return


/**
* Instancia o objeto que representa a tag "ipi_nt"
**/ 
static function DoIpiNT()
	
	local lFormatZero := .F.
	local cTax	:= "IPI"
	local cAliq	:= "01,02,03,04,51,52,53,54,55" 
	
	oIpi_nt := MsafNFeTag():newMsafNFeTag("ipi_nt")

	oIpi_nt:setAttributeValue("CST",retValTax(cTax,cAliq, oDetProd, "CST","tributo", lFormatZero))
	
	oIPI:addElementNode(oIpi_nt)

return


/**
* Instancia o objeto que representa a tag "II"
**/ 
static function DoII()

	local cTax	:= "II"
	local cAliq	:= "" 
		
	oII := MsafNFeTag():newMsafNFeTag("II")

	oII:setAttributeValue("vBC"			,retValTax(cTax,cAliq, oDetProd, "vBC","tributo"))
	oII:setAttributeValue("vDespAdu"	,retValTax(cTax,cAliq, oDetProd, "vDespAdu","cpl"))
	oII:setAttributeValue("vII"			,retValTax(cTax,cAliq, oDetProd, "Valor","tributo"))
	oII:setAttributeValue("vIOF"		,retValTax(cTax,cAliq, oDetProd, "vIOF","cpl"))
	
	oImpostos:addElementNode(oII)

return


/**
* Instancia o objeto que representa a tag "PIS"
**/ 
static function DoPIS()
	
	oPIS := MsafNFeTag():newMsafNFeTag("PIS")

	oImpostos:addElementNode(oPIS)
	
return


/**
* Instancia o objeto que representa a tag "pis_aliq"
**/ 
static function DoPisAliq()
	
	local lFormatZero := .F.
	local cTax	:= "PIS"
	local cAliq	:= "01,02" 
	
	oPis_aliq := MsafNFeTag():newMsafNFeTag("pis_aliq")

	oPis_aliq:setAttributeValue("CST",retValTax(cTax,cAliq, oDetProd, "CST","tributo", lFormatZero))
	oPis_aliq:setAttributeValue("vBC",retValTax(cTax,cAliq, oDetProd, "vBC","tributo"))
	oPis_aliq:setAttributeValue("pPIS",retValTax(cTax,cAliq, oDetProd, "aliquota","tributo")) 
	oPis_aliq:setAttributeValue("vPIS",retValTax(cTax,cAliq, oDetProd, "valor","tributo"))
	
	oPIS:addElementNode(oPis_aliq)

return


/**
* Instancia o objeto que representa a tag "pis_qtde"
**/ 
static function DoPisQtde()
	
	local lFormatZero := .F.
	local cTax		  := "PIS"
	local cAliq		  := "03" 
	local cqBCProd	  := retValTax(cTax,cAliq, oDetProd, "qTrib","tributo")
	local cvAliqProd  := retValTax(cTax,cAliq, oDetProd, "aliquota","tributo")
	
	oPis_qtde := MsafNFeTag():newMsafNFeTag("pis_qtde")

	oPis_qtde:setAttributeValue("CST"		, retValTax(cTax,cAliq, oDetProd, "CST","tributo", lFormatZero))
	oPis_qtde:setAttributeValue("qBCProd"	, if(Val(cqBCProd) == 0, "", cqBCProd)) 
	oPis_qtde:setAttributeValue("vAliqProd" , if(Val(cvAliqProd) == 0, "", cvAliqProd)) 
	oPis_qtde:setAttributeValue("vPIS"		, retValTax(cTax,cAliq, oDetProd, "valor","tributo"))
	
	oPIS:addElementNode(oPis_qtde)

return


/**
* Instancia o objeto que representa a tag "pis_nt"
**/ 
static function DoPisNT()
	
	local lFormatZero := .F.
	local cTax	:= "PIS"
	local cAliq	:= "04,06,07,08,09" 
	
	oPis_nt := MsafNFeTag():newMsafNFeTag("pis_nt")

	oPis_nt:setAttributeValue("CST", retValTax(cTax,cAliq, oDetProd, "CST","tributo", lFormatZero))
	
	oPIS:addElementNode(oPis_nt)

return


/**
* Instancia o objeto que representa a tag "pis_outr"
**/ 
static function DoPisOutr()
	
	local lFormatZero := .F.
	local cTax	:= "PIS"
	local cAliq	:= "49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,71,73,74,75,98" 
	
	oPis_outr := MsafNFeTag():newMsafNFeTag("pis_outr")

	oPis_outr:setAttributeValue("CST", retValTax(cTax,cAliq, oDetProd, "CST", "tributo", lFormatZero)) 
	
	oPIS:addElementNode(oPis_outr)

return


/**
* Instancia o objeto que representa a tag "x_pis_percent"
**/ 
static function DoPisPercent()
	
	local cTax	:= "PIS"
	local cAliq	:= "49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,71,73,74,75,98" 
	
	oPis_percent := MsafNFeTag():newMsafNFeTag("x_pis_percent")

	oPis_percent:setAttributeValue("vBC",retValTax(cTax,cAliq, oDetProd, "vBC","tributo"))
	oPis_percent:setAttributeValue("pPIS",retValTax(cTax,cAliq, oDetProd, "aliquota","tributo"))
	
	oPis_outr:addElementNode(oPis_percent)

return


/**
* Instancia o objeto que representa a tag "x_pis_valor"
**/ 
static function DoPisValor()
	
	local lFormatZero := .F.
	local cTax		  := "PIS"
	local cAliq		  := "49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,71,73,74,75,98" 
	local cqBCProd	  := retValTax(cTax,cAliq, oDetProd, "qTrib", "tributo")
	local cvAliqProd  := retValTax(cTax,cAliq, oDetProd, "aliquota", "tributo")
	
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_REV) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG)
		if ((cTypeInv == DHL_NFE_INVOICE_INFLOW) .and. (SF1->F1_FORMUL == 'S'))
			cqBCProd 	:= '0'
			cvAliqProd	:= '0'
		endif
	endif
	
	oPis_valor := MsafNFeTag():newMsafNFeTag("x_pis_valor")

	oPis_valor:setAttributeValue("qBCProd", if(Val(cqBCProd) == 0, "", cqBCProd)) 
	oPis_valor:setAttributeValue("vAliqProd", if(Val(cvAliqProd) == 0, "", cvAliqProd))
	oPis_valor:setAttributeValue("vPIS", retValTax(cTax,cAliq, oDetProd, "valor", "tributo")) 
	
	oPis_outr:addElementNode(oPis_valor)

return


/**
* Instancia o objeto que representa a tag "PISST"
**/ 
static function DoPISST()
	
	oPISST := MsafNFeTag():newMsafNFeTag("PISST")
	
	oImpostos:addElementNode(oPISST)

return


/**
* Instancia o objeto que representa a tag "pis_st"
**/ 
static function DoPis_ST()
	
	oPis_st := MsafNFeTag():newMsafNFeTag("pis_st")
	
	oPISST:addElementNode(oPis_st)

return


/**
* Instancia o objeto que representa a tag "x_pisst_percent"
**/ 
static function DoPisstPercent()
	
	local cTax	:= "PISST"
	local cAliq	:= "" 
	
	oPisst_percent := MsafNFeTag():newMsafNFeTag("x_pisst_percent")

	oPisst_percent:setAttributeValue("vBC",retValTax(cTax,cAliq, oDetProd, "vBC","tributo")) 
	oPisst_percent:setAttributeValue("pPIS",retValTax(cTax,cAliq, oDetProd, "valor","tributo"))
	
	oPis_st:addElementNode(oPisst_percent)

return


/**
* Instancia o objeto que representa a tag "x_pisst_valor"
**/ 
static function DoPisstValor()
	
	local lFormatZero := .F.
	local cTax		  := "PISST"
	local cAliq		  := "" 
	local cqBCProd	  := retValTax(cTax,cAliq, oDetProd, "qTrib","tributo")
	local cvAliqProd  := retValTax(cTax,cAliq, oDetProd, "aliquota","tributo")
	
	oPisst_valor := MsafNFeTag():newMsafNFeTag("x_pisst_valor")

	oPisst_valor:setAttributeValue("qBCProd", if(Val(cqBCProd) == 0, "", cqBCProd))
	oPisst_valor:setAttributeValue("vAliqProd", if(Val(cvAliqProd) == 0, "", cvAliqProd))
	oPisst_valor:setAttributeValue("vPIS",retValTax(cTax,cAliq, oDetProd, "valor","tributo")) 
	
	oPis_st:addElementNode(oPisst_valor)

return


/**
* Instancia o objeto que representa a tag "COFINS"
**/ 
static function DoCOFINS()
	
	oCOFINS := MsafNFeTag():newMsafNFeTag("COFINS")

	oImpostos:addElementNode(oCOFINS)
	
return


/**
* Instancia o objeto que representa a tag "cofins_aliq"
**/ 
static function DoCofinsAliq()
	
	local lFormatZero := .F.
	local cTax	:= "COFINS"
	local cAliq	:= "01,02" 
	
	oCofins_aliq := MsafNFeTag():newMsafNFeTag("cofins_aliq")

	oCofins_aliq:setAttributeValue("CST",retValTax(cTax,cAliq, oDetProd, "CST","tributo", lFormatZero))
	oCofins_aliq:setAttributeValue("vBC",retValTax(cTax,cAliq, oDetProd, "vBC","tributo"))
	oCofins_aliq:setAttributeValue("pCOFINS",retValTax(cTax,cAliq, oDetProd, "aliquota","tributo"))
	oCofins_aliq:setAttributeValue("vCOFINS",retValTax(cTax,cAliq, oDetProd, "valor","tributo"))
	
	oCOFINS:addElementNode(oCofins_aliq)

return


/**
* Instancia o objeto que representa a tag "cofins_qtde"
**/ 
static function DoCofinsQtde()
	
	local lFormatZero := .F.
	local cTax	:= "COFINS"
	local cAliq	:= "03" 
	local cqBCProd	  := retValTax(cTax,cAliq, oDetProd, "qTrib","tributo")
	local cvAliqProd  := retValTax(cTax,cAliq, oDetProd, "aliquota","tributo")
	
	oCofins_qtde := MsafNFeTag():newMsafNFeTag("cofins_qtde")

	oCofins_qtde:setAttributeValue("CST",retValTax(cTax,cAliq, oDetProd, "CST","tributo", lFormatZero))
	oCofins_qtde:setAttributeValue("qBCProd", if(Val(cqBCProd) == 0, "", cqBCProd)) 
	oCofins_qtde:setAttributeValue("vAliqProd", if(Val(cvAliqProd) == 0, "", cvAliqProd))
	oCofins_qtde:setAttributeValue("vCOFINS",retValTax(cTax,cAliq, oDetProd, "valor","tributo"))
	
	oCOFINS:addElementNode(oCofins_qtde)

return


/**
* Instancia o objeto que representa a tag "cofins_nt"
**/ 
static function DoCofinsNT()
	
	local lFormatZero := .F.
	local cTax	:= "COFINS"
	local cAliq	:= "04,06,07,08,09" 
		
	oCofins_nt := MsafNFeTag():newMsafNFeTag("cofins_nt")

	oCofins_nt:setAttributeValue("CST", retValTax(cTax,cAliq, oDetProd, "CST","tributo", lFormatZero))
	
	oCOFINS:addElementNode(oCofins_nt)

return


/**
* Instancia o objeto que representa a tag "cofins_outr"
**/ 
static function DoCofinsOutr()
	
	local lFormatZero := .F.
	local cTax		  := "COFINS"
	local cAliq		  := "49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,71,72,73,74,75,98" 
		
	oCofins_outr := MsafNFeTag():newMsafNFeTag("cofins_outr")

	oCofins_outr:setAttributeValue("CST",retValTax(cTax,cAliq, oDetProd, "CST", "tributo", lFormatZero))
	
	oCOFINS:addElementNode(oCofins_outr)

return


/**
* Instancia o objeto que representa a tag "x_cofinsoutr_percent"
**/ 
static function DoCofinsPercentOutr()
	
	local cTax	:= "COFINS"
	local cAliq	:= "49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,71,72,73,74,75,98" 
		
	oCofinsoutr_percent := MsafNFeTag():newMsafNFeTag("x_cofinsoutr_percent")

	oCofinsoutr_percent:setAttributeValue("vBC",retValTax(cTax,cAliq, oDetProd, "vBC","tributo"))
	oCofinsoutr_percent:setAttributeValue("pCOFINS",retValTax(cTax,cAliq, oDetProd, "aliquota","tributo"))
	
	oCofins_outr:addElementNode(oCofinsoutr_percent)

return


/**
* Instancia o objeto que representa a tag "x_cofinsoutr_valor"
**/ 
static function DoCofinsValorOutr()
	
	local lFormatZero := .F.
	local cTax		  := "COFINS"
	local cAliq		  := "49,50,51,52,53,54,55,56,60,61,62,63,64,65,66,67,71,72,73,74,75,98"
	local cqBCProd	  := retValTax(cTax,cAliq, oDetProd, "qTrib","tributo")
	local cvAliqProd  := retValTax(cTax,cAliq, oDetProd, "aliquota","tributo")
	
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_REV) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG)
		if ((cTypeInv == DHL_NFE_INVOICE_INFLOW) .and. (SF1->F1_FORMUL == 'S'))
			cqBCProd 	:= '0'
			cvAliqProd	:= '0'
		endif
	endif
		
	oCofinsoutr_valor := MsafNFeTag():newMsafNFeTag("x_cofinsoutr_valor")

	oCofinsoutr_valor:setAttributeValue("qBCProd", if(Val(cqBCProd) == 0, "", cqBCProd)) 
	oCofinsoutr_valor:setAttributeValue("vAliqProd", if(Val(cvAliqProd) == 0, "", cvAliqProd))
	oCofinsoutr_valor:setAttributeValue("vCOFINS",retValTax(cTax,cAliq, oDetProd, "valor","tributo"))
	
	oCofins_outr:addElementNode(oCofinsoutr_valor)

return


/**
* Instancia o objeto que representa a tag "COFINSST"
**/ 
static function DoCOFINSST()
	
	oCOFINSST := MsafNFeTag():newMsafNFeTag("COFINSST")

	oImpostos:addElementNode(oCOFINSST)
	
return


/**
* Instancia o objeto que representa a tag "cofins_st"
**/ 
static function DoCofins_ST()
	
	oCofins_st := MsafNFeTag():newMsafNFeTag("cofins_st")
	
	oCOFINSST:addElementNode(oCofins_st)

return


/**
* Instancia o objeto que representa a tag "x_cofinsst_percent"
**/ 
static function DoStCofPercent()

	local cTax	:= "COFINSST"
	local cAliq	:= "" 
		
	oCofinsst_percent := MsafNFeTag():newMsafNFeTag("x_cofinsst_percent")

	oCofinsst_percent:setAttributeValue("vBC",retValTax(cTax,cAliq, oDetProd, "vBC","tributo"))
	oCofinsst_percent:setAttributeValue("pCOFINS",retValTax(cTax,cAliq, oDetProd, "aliquota","tributo"))
	
	oCofins_st:addElementNode(oCofinsst_percent)

return


/**
* Instancia o objeto que representa a tag "x_cofinsst_valor"
**/ 
static function DoStCofValor()
	
	local lFormatZero := .F.
	local cTax		  := "COFINSST"
	local cAliq		  := "" 
	local cqBCProd	  := retValTax(cTax,cAliq, oDetProd, "qTrib","tributo")
	local cvAliqProd  := retValTax(cTax,cAliq, oDetProd, "aliquota","tributo")
	
	oCofinsst_valor := MsafNFeTag():newMsafNFeTag("x_cofinsst_valor")

	oCofinsst_valor:setAttributeValue("qBCProd", if(Val(cqBCProd) == 0, "", cqBCProd))
	oCofinsst_valor:setAttributeValue("vAliqProd", if(Val(cvAliqProd) == 0, "", cvAliqProd))
	oCofinsst_valor:setAttributeValue("vCOFINS",retValTax(cTax,cAliq, oDetProd, "valor","tributo"))
	
	oCofins_st:addElementNode(oCofinsst_valor)

return


/**
* Instancia o objeto que representa a tag "ISSQN"
**/ 
static function DoISSQN()
	
	oISSQN := MsafNFeTag():newMsafNFeTag("ISSQN")

	oISSQN:setAttributeValue("vBC", "")
	oISSQN:setAttributeValue("vAliq", "")
	oISSQN:setAttributeValue("vISSQN", "")
	oISSQN:setAttributeValue("cMunFG", "")
	oISSQN:setAttributeValue("cListServ", "")
	oISSQN:setAttributeValue("vDeducao", "")
	oISSQN:setAttributeValue("vOutro", "")
	oISSQN:setAttributeValue("vDescIncond", "")
	oISSQN:setAttributeValue("vDescCond", "")
	oISSQN:setAttributeValue("vISSRet", "")
	oISSQN:setAttributeValue("indISS", "")
	oISSQN:setAttributeValue("cServico", "")
	oISSQN:setAttributeValue("cMun", "")
	oISSQN:setAttributeValue("cPais", "")
	oISSQN:setAttributeValue("nProcesso", "")
	oISSQN:setAttributeValue("indIncentivo", "")
	
	oImpostos:addElementNode(oISSQN)

return


/**
* Instancia o objeto que representa a tag "imposto_devol"
**/ 
static function DoImpostoDevol()
	
	oImposto_devol := MsafNFeTag():newMsafNFeTag("imposto_devol")

	oImposto_devol:setAttributeValue("pDevol", EMPTY_VALUE)
	
	oItem_nota:addElementNode(oImposto_devol)

return


/**
* Instancia o objeto que representa a tag "ipi_devol"
**/ 
static function DoIpiDevol()
	
	oIpi_devol := MsafNFeTag():newMsafNFeTag("ipi_devol")

	oIpi_devol:setAttributeValue("vIPIDevol",EMPTY_VALUE)
	
	oImposto_devol:addElementNode(oIpi_devol)

return


/**
* Instancia o objeto que representa a tag "inf_adicionais"
**/ 
static function DoInfAdicionais()
	
	oInf_adicionais := MsafNFeTag():newMsafNFeTag("inf_adicionais")
	
	oInf_adicionais:setAttributeValue("infAdProd",strtran(validTagValue("oDetProd:_infAdProd:text"), '"', ''))
	
	oItem_nota:addElementNode(oInf_adicionais)

return


/**
* Função responsável pelo preenchimento dos atributos da tag detalhe.
**/ 
static function DoDetProd()
	local nI		:= 1
	local cNve		:= "" 
	local cItem	:= ""
	local aDet		:= retArrayAtribute("infNfe:_det")
	
	private  oDetProd:= nil	
	
	for nI	:= 1 to len(aDet)
		
		oDetProd := aDet[nI]
		
		DoItemNota()
		DoDet()
		DoProd()
		DoNve()
		DoEXTIPI()
		DoDi()
		DoAdi()
		DoDetExport()
		DoExportInd()
		DoXPed()
		DoProdEspecifico()
		DoVeicProd()
		DoMedicamento()
		DoArmamento()
		DoComb()
		DoCide()
		DoEncerrante()
		DoNRecopi()
		DoImpostos()
		DoAllTaxes(oDetProd)
		DoInfAdicionais()
		// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050] vItem e DFeReferenciado
		// (DFeReferenciado vem depois do vItem no item - NT). Mesma ordem do ProcMsaNFe
		If lRtcIP050
			DovItem()
			DoDFeReferenciado()
		EndIf
		// FIM Wellington Santana 27/11/2026
		DoDocSerie()
	next nI
return


/*/{Protheus.doc} getIndPres
Indicador de presenca do comprador (indPres) para o arquivo IP050.

[RTC-2026/2027 - Lote 4] Antes fixo em "0". Passa a refletir a nota autorizada
(tag infNFe/ide/indPres do XML), mantendo "0" quando a tag nao vier.

@type function
@author Wellington Santana
@since 22/11/2026
@return character, Codigo do indPres
/*/
static function getIndPres()

	local cIndPres := AllTrim(retValueAttribute("infnfe:_ide:_indPres:text"))

	if Empty(cIndPres)
		cIndPres := "0"
	endIf

return cIndPres


/**
* Função responsável pelo retorna do valor do atributo.
**/
static function retValueAttribute(cString, lFormatZero)
	 
	local cValue 		:= oXmlUtil:getNodeValue(cString)
	default lFormatZero	:= .F.
	
	if lFormatZero
		if Val(cValue) == 0
			cValue := DHL_NFE_FORMAT_ZERO
		endIf
	endIf

return cValue


/*
*	Função responsável pelo retorno do array de atributos.
**/
static function retArrayAttribute(cString)
	local aAttribute	:= {}
	local lExistNode		:= oXmlUtil:existNode(cString)
	
	if lExistNode
		aAttribute	:= oXmlUtil:getNodeArray(cString)
	endIf
	
return aAttribute


/*
*	Função responsável pelo preenchimento dos impostos
**/
static function DoAllTaxes()
	DoICMS(oDetProd)
	// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050] ICMSPrevistoPagtoAntecip (debito 06)
	If lRtcIP050
		DoICMSPrevAntecip()
	EndIf
	// FIM Wellington Santana 27/11/2026
	DoIcms00(oDetProd)
	DoIcms10()
	DoIcms20()
	DoIcms20Deson()
	DoIcms30()
	DoIcms30Deson()
	DoIcms40()
	DoIcms40Deson()
	DoIcms51()
	DoIcms60()
	DoIcms60Retido()
	DoIcms70()
	DoIcms70Deson()
	DoIcms90()
	DoIcms90Icms()
	DoIcms90STIcms()
	DoIcms90Deson()
	DoIcmspart()
	DoIcmsST()
	DoSNIcms101()
	DoIcmssn102()
	DoSNIcms201()
	DoIcmssn202()
	DoIcmssn500()
	DoSn500Retido()
	DoIcmssn900()
	DoSn900Icms()
	DoSTSn900Icms()
	DoSn900Credito()
	DoIcmsUfDest()
	DoIPI()
	DoIpiTrib()
	DoIpiAliq()
	DoIpiUnid()
	DoIpiNT()
	DoII()
	DoPIS()
	DoPisAliq()
	DoPisQtde()
	DoPisNT()
	DoPisOutr()
	DoPisPercent()
	DoPisValor()
	DoPISST()
	DoPis_ST()
	DoPisstPercent()
	DoPisstValor()
	DoCOFINS()
	DoCofinsAliq()
	DoCofinsQtde()
	DoCofinsNT()
	DoCofinsOutr()
	DoCofinsPercentOutr()
	DoCofinsValorOutr()
	DoCOFINSST()
	DoCofins_ST()
	DoStCofPercent()
	DoStCofValor()
	DoISSQN()
	// INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050] IS entre COFINS/ISSQN e IBSCBS
	// (ordem da NT) e cadeia IBSCBS completa, na mesma ordem do ProcMsaNFe
	If lRtcIP050
		DoIS()
		DoIBSCBS()
		DoSIBSCBS()
		DogIBSCBS()
		DogIBSUF()
		DogIBSUFDif()
		DogIBSUFDevTrib()
		DogIBSUFRed()
		DogIBSMu()
		DogIBSMuDif()
		DogIBSMuDevTrib()
		DogIBSMuRed()
		DogCBS()
		DogCBSDif()
		DogCBSDevTrib()
		DogCBSRed()
		DogTribRegular()
		DogIBSCredPres()
		DogCBSCredPres()
		DogTribCompraGov()
		DogIBSCBSMon()
		DogMonPadrao()
		DogMonReten()
		DogMonRet()
		DogMonDif()
		DogIBCBMonAttrib()
		DogTransfCred()
		DogCredPresIBSZFM()
		// gAjusteCompet (debito 03) e gEstornoCred (debito 07): dependem de oSeqXML apontar para
		// sequencia_XML_IBSCBS, por isso ficam no fim da cadeia, junto com os irmaos do gIBSCBS
		DogAjusteCompet()
		DogEstornoCred()
	EndIf
	// FIM Wellington Santana 27/11/2026
	DoImpostoDevol()
	DoIpiDevol()
return


/*
*	Função responsável pela validação do tamanho do array
**/
static function isEmpty(aArray)
	local lRet	:= .F.
	
	if len(aArray) == 0
		lRet	:= .T.
	endIf
return lRet


/*
*	Função responsável pela validação do atributo
**/
static function validTagValue(cString)
	
	if Type(cString) == "U"
		cString	:= EMPTY_VALUE
	else
		cString	:= &(cString)
	endIf
return cString


/*
*	Função responsável pela criação do arquivo final	
*/
static function createFile(cString)
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local oFile		:= IpFileObject():newIpFileObject("")
	local cDir		:= alltrim(oSqlUtil:getFieldValue("SZ1", "Z1_DIREXP", "Z1_FILIAL = '%SZ1.FILIAL%' AND %SZ1.NOTDEL% AND SZ1.Z1_CODIGO ='"+APP_MASTERSAF_NFE+"'"))
	local cDate		:= DtoS(dDataBase)
	local cTime		:= STRTRAN(Time(),":","")
	local cFileName	:= "NFE_" + Alltrim(cCnpj) + "_" + cDate + "_" +cTime + "_"+Alltrim(cNrInvoice)+"_"+Alltrim(cNrSeries)+".txt"
	local lRet			:= .T.
	
	oFile:setFile(cDir+cFileName)
	
	lRet	:= oFile:writeLine(cString)
	
	if !lRet
		oLog:start(APP_MASTERSAF_NFE, DHL_EXPORTACAO,cDir + cFileName )
		oLog:fail("Criação do Arquivo", "Erro ao criar arquivo")
	endIf
return lRet


/**
 * Coleta propriedades de um objeto
 */
static function getObjectProperty(oObject, cProperty)
	
	local xValue  := nil
	local cMacro  := ""
	private _oObj := oObject
	
	cMacro := "_oObj:"+cProperty
	
	if (Type(cMacro) != "U")
		xValue := &cMacro
	endIf
	
return xValue

/*
 * Função responsável pelo retorno do imposto de acordo com aliquota e nó.
 **/
static function retValTax(cTax, cAliq, oDetProd, cTag, cNode, lFormatZero)
	
	local nI	    	:= 0
	local cValue		:= ""
	local cTagCodigo	:= ""	
	local cTagValue 	:= ""
	local cTagCST		:= ""
	local cTagCSOSN		:= ""
	local cCodigo   	:= ""
	local cCST      	:= ""
	local cCSOSN		:= ""
	local aImpostos 	:= {}
	private oTagImp    	:= nil
	default lFormatZero	:= .T.
	
	if Type("oDetProd:_imposto") == "U"
		return ""
	endIf	
	
	if (ValType(oDetProd:_imposto) == "O")
		aAdd(aImpostos, oDetProd:_imposto)
	else
		aImpostos := oDetProd:_imposto		
	endIf	
	
	for nI := 1 to Len(aImpostos)		
		
		oTagImp := aImpostos[nI]		
		
		cTagCodigo := "oTagImp:_codigo:text" 
		if (fTypeVar(cTagCodigo) == "U")
			loop
		else
			cCodigo := &cTagCodigo
		endIf				
		
		if (Upper(AllTrim(cCodigo)) != Upper(AllTrim(cTax)))
			loop
		endIf
		
		cTagCST := "oTagImp:_tributo:_cst:text"		
		if (fTypeVar(cTagCST) != "U")
			cCST := &cTagCST
		endIf
		
		cTagCSOSN := "oTagImp:_tributo:_csosn:text"
		if (fTypeVar(cTagCSOSN) != "U")
			cCSOSN := &cTagCSOSN
		endIf
		
		if Empty(cAliq) .or. (cCST $ cAliq) .or. (cCSOSN $ cAliq)
			cTagValue := "oTagImp:_"+cNode+":_"+cTag+":text"
			if (fTypeVar(cTagValue) != "U")
				cValue := &cTagValue
				exit				
			endIf	
		endIf
								
	next nI	
	
	if lFormatZero .and. !Empty(cValue) .and. (Val(cValue) == 0)
		cValue := DHL_NFE_FORMAT_ZERO		
	endIf
	
return cValue


/*
** Coleta valor tag vOutros dos produtos
*/
static function getNVOutros()
	local nI		:= 1
	local cNve		:= "" 
	local cItem	:= ""
	local aDet		:= retArrayAtribute("infNfe:_det")
	
	private  oDetProd:= nil	
	
	nVOutros := 0	

	for nI	:= 1 to len(aDet)
		oDetProd := aDet[nI]
		oProd := MsafNFeTag():newMsafNFeTag("prod")
		nVOutros += if (empty(alltrim(validTagValue("oDetProd:_prod:_vOutro:text"))), 0, val(validTagValue("oDetProd:_prod:_vOutro:text")))
	next
return nVOutros


/*
**
*/
static function retSalesOrd()
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	local cRet		:= ""
	
	if (cTypeInv == DHL_NFE_INVOICE_INFLOW)
		//Aguardando definição DHL
	else
		cQuery += " SELECT DISTINCT C5_ZZORDEX SALES_ORDER     "+CRLF
		cQuery += " FROM %SD2.SQLNAME%                         "+CRLF
		cQuery += " INNER JOIN %SC5.SQLNAME% ON                "+CRLF
		cQuery += " 	C5_FILIAL 		= D2_FILIAL            "+CRLF
		cQuery += " 	AND C5_NUM 		= D2_PEDIDO            "+CRLF
		cQuery += " WHERE                                      "+CRLF
		cQuery += " 	%SD2.XFILIAL%                          "+CRLF
		cQuery += " 	AND D2_DOC		= '"+SF2->F2_DOC+"'    "+CRLF
		cQuery += " 	AND D2_SERIE	= '"+SF2->F2_SERIE+"'  "+CRLF
		cQuery += " 	AND %SD2.NOTDEL%                       "+CRLF
	endif
	
	oSql:newAlias(cQuery)
	if oSql:hasRecords()
		cRet := oSql:getValue("SALES_ORDER")
	endif
	oSql:close()
	
return (cRet)

/**
* Instancia o objeto que representa a tag "NUMERONF_SERIE"
**/ 
static function DoDocSerie()
	Local cNumeroNF := ""
	Local cSerie	:= ""
	
	getNumeroNF(@cNumeroNF,@cSerie)	
	
	oDocSerieOrig := MsafNFeTag():newMsafNFeTag("")
	
	oDocSerieOrig:setAttributeValue("NUMERONF_SERIE",allTrim(cNumeroNF)+"_"+allTrim(cSerie))
	
	oItem_nota:addElementNode(oDocSerieOrig)
return

/**
* Retorna o número da NF e a Série
**/ 
static function getNumeroNF(cNumeroNF,cSerie)	
	Local oSql  		:= IpSqlObject():newIpSqlObject()
	Local cFilNF		:= SF2->F2_FILIAL
	Local cNota			:= SF2->F2_DOC
	Local cSerie		:= SF2->F2_SERIE
	Local cItem			:= PADL(oDetProd:_nItem:text, TamSx3("D2_ITEM")[1],"0")
	
	oSql:newTable("SD2", "D2_NFORI,D2_SERIORI",;
			"D2_FILIAL = '"	+cFilNF+	"' AND " + ;
			"D2_DOC = '"	+cNota+		"' AND "+;
			"D2_SERIE = '"	+cSerie+	"' AND "+;
			"D2_ITEM = '"	+cItem+ 	"'")
	
	if oSql:notIsEof()
		cNumeroNF 	:= oSql:getValue("D2_NFORI")
		cSerie 		:= oSql:getValue("D2_SERIORI")
	endif
	
	oSql:close()
return

/**
* Instancia o objeto que representa a tag "Shipment"
**/ 
static function DoShipment()
	Local cShipment	:= ""
	
	cShipment = getShipment()
	
	oShipment := MsafNFeTag():newMsafNFeTag("")
	
	oShipment:setAttributeValue("Shipment_Number", cShipment)
	
	oArquivo:addElementNode(oShipment)
return

/**
* Instancia o objeto que representa a tag "Sales_Nota_Fiscal_from_SCJ"
**/ 
static function DoKeySCJ()
	Local cChvSZA 	:= ""
		
	cChvSZA	:= getChvNFOrig()	
	
	oKeySCJ := MsafNFeTag():newMsafNFeTag("")
	
	oKeySCJ:setAttributeValue("Sales_Nota_Fiscal_from_SCJ",cChvSZA)
	
	oArquivo:addElementNode(oKeySCJ)
return


/**
* Instancia o objeto que representa a tag "Sales_Nota_Fiscal_from_SCJ"
**/ 
static function DoDeliveryNumber()
	Local cDelivery 	:= ""
		
	cDelivery := getDelivery()	
	
	oDelivery := MsafNFeTag():newMsafNFeTag("")
	
	oDelivery:setAttributeValue("Delivery_Number", cDelivery)
	
	oArquivo:addElementNode(oDelivery)
return


/**
* Instancia o objeto que representa a tag "Sales_Nota_Fiscal_from_SCJ"
**/ 
static function DoNfProtocol()
	oNfProtocol := MsafNFeTag():newMsafNFeTag("")
	
	oNfProtocol:setAttributeValue("Protocol_NF_Number", SF2->F2_CODNFE)
	
	oArquivo:addElementNode(oNfProtocol)
return

/**
* Retorna o número do Shipment
**/ 

static function getShipment()
	Local oSql			:= IpSqlObject():newIpSqlObject()
	Local cFilNF		:= SF2->F2_FILIAL
	Local cNota			:= SF2->F2_DOC
	Local cSerie		:= SF2->F2_SERIE
	Local cShipment		:= ""
	Local cQuery		:= ""

	cQuery += " SELECT ZA_SHIPNUM " +CRLF
	cQuery += " FROM %SZA.SQLNAME% " +CRLF	
	cQuery += " WHERE " +CRLF
	cQuery += "	1=1 " +CRLF
	cQuery += "	AND %SZA.XFILIAL% " +CRLF
	cQuery += "	AND ZA_NFRET 		= '"	+ allTrim(cNota) +		"' " +CRLF
	cQuery += "	AND ZA_SERIRET 	= '"+ allTrim(cSerie) +	"' " +CRLF
	cQuery += " AND %SZA.NOTDEL% " +CRLF

	oSql:newAlias(cQuery)

	if oSql:hasRecords()
		cShipment := oSql:getValue("ZA_SHIPNUM")
	endif
	
	oSql:close()
return (cShipment)	

/**
* Retorna o número da NF e a Série
**/ 
static function getChvNFOrig()	
	Local oSql  		:= IpSqlObject():newIpSqlObject()
	Local cFilNF		:= SF2->F2_FILIAL
	Local cNota			:= SF2->F2_DOC
	Local cSerie		:= SF2->F2_SERIE
	Local cChvSZA		:= ""
	
	oSql:newTable("SZA", "ZA_KENFSCJ",;
			"ZA_FILIAL = '"	+cFilNF+	"' AND " + ;
			"ZA_NFRET = '"	+cNota+		"' AND "+;
			"ZA_SERIRET = '"+cSerie+	"' ")
	
	if oSql:notIsEof()
		cChvSZA := oSql:getValue("ZA_KENFSCJ")
	endif
	
	oSql:close()
return cChvSZA


/**
* Retorna o número da Delivery
**/ 
static function getDelivery()	
	Local oSql  		:= IpSqlObject():newIpSqlObject()
	Local cFilNF		:= SF2->F2_FILIAL
	Local cNota		:= SF2->F2_DOC
	Local cSerie		:= SF2->F2_SERIE
	Local cDelivery	:= ""
	Local cQuery		:= ""
	
	cQuery += " SELECT ZB_DELIVER " +CRLF
	cQuery += " FROM %SZA.SQLNAME% " +CRLF
	cQuery += " INNER JOIN %SZB.SQLNAME% ON " +CRLF
	cQuery += " 	1=1 " +CRLF 
	cQuery += " 	AND ZB_FILIAL 	= ZA_FILIAL " +CRLF
	cQuery += " 	AND ZB_KENFSCJ	= ZA_KENFSCJ " +CRLF
	cQuery += " 	AND %SZB.NOTDEL% " +CRLF
	cQuery += " WHERE " +CRLF
	cQuery += "	1=1 " +CRLF
	cQuery += "	AND %SZA.XFILIAL% " +CRLF
	cQuery += "	AND ZA_NFRET 		= '"	+ allTrim(cNota) +		"' " +CRLF
	cQuery += "	AND ZA_SERIRET 	= '"+ allTrim(cSerie) +	"' " +CRLF
	
	oSql:newAlias(cQuery)

	if oSql:hasRecords()
		cDelivery := oSql:getValue("ZB_DELIVER")
	endif
	
	oSql:close()
return (cDelivery)

/*
Retorna o tipo da variável
*/
Static Function fTypeVar(cVar)
Return Type(cVar)

/**
* ===================================================================
* INICIO Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050]
* Grupos da Reforma Tributaria (IBS, CBS e IS) replicados do ProcMsaNFe,
* na versao corrigida do Lote 4 (ProcRCOMsa 22/11/2026).
* So sao chamados com ZZ_RTCIP50 = .T. (ver ProcRSymbMsa e MountTags):
* incluir estes grupos muda o layout posicional do IP050 lido pelo SAP.
* Adaptacoes ao IP050:
* - vItem e DFeReferenciado ficam sob "item_nota" (no IP050 o "det" so leva o nItem);
* - DoIBSCBSTot usa retArrayAttribute (definida neste fonte) e declara oDetNfe;
* - gCredPresIBSZFM: lFormatZero passado ao retValTax.
* ===================================================================
**/

/**
* Instancia o objeto que representa a tag "vItem"
* XML oficial: det/vItem - valor total do item (NT 2025.002)
**/
static function DovItem()

	ovItem := MsafNFeTag():newMsafNFeTag("vItem")

	ovItem:setAttributeValue("vItem",validTagValue("oDetProd:_vItem:text"))

	oItem_nota:addElementNode(ovItem)

return

/**
* Instancia o objeto que representa a tag "IBSCBS"
**/ 
static function DoIBSCBS()
	
	local cTax			:= "IBSCBS"
	local cAliq			:= "" 
	local lFormatZero 	:= .F.	
	
	oIBSCBS := MsafNFeTag():newMsafNFeTag("IBSCBS")

	oIBSCBS:setAttributeValue("CST"			, retValTax(cTax,cAliq, oDetProd, "CST" 		, "tributo", lFormatZero))	
	oIBSCBS:setAttributeValue("cClassTrib"	, retValTax(cTax,cAliq, oDetProd, "cClassTrib"	, "tributo", lFormatZero))	
 
	oImpostos:addElementNode(oIBSCBS)

return

/**
* Instancia o objeto que representa a tag "sequencia_XML_IBSCBS" do nó "IBSCBS"
**/ 
static function DoSIBSCBS()
   
	oSeqXML := MsafNFeTag():newMsafNFeTag("sequencia_XML_IBSCBS")
																			   
	oIBSCBS:addElementNode(oSeqXML)
	
return
						   
/**
* Instancia o objeto que representa a tag "gIBSCBS"
**/ 
static function DogIBSCBS()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
	
	ogIBSCBS := MsafNFeTag():newMsafNFeTag("gIBSCBS")
	 
	ogIBSCBS:setAttributeValue("vBC",retValTax(cTax,cAliq, oDetProd, "vBC","tributo:_gIBSCBS"))
	ogIBSCBS:setAttributeValue("vIBS",retValTax(cTax,cAliq, oDetProd, "vIBS","tributo:_gIBSCBS"))

	oSeqXML:addElementNode(ogIBSCBS)
	
return

/**
* Instancia o objeto que representa a tag "gIBSUF"
**/ 
static function DogIBSUF()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
	
	ogIBSUF := MsafNFeTag():newMsafNFeTag("gIBSUF")
 
	ogIBSUF:setAttributeValue("pIBSUF",retValTax(cTax,cAliq, oDetProd, "pIBSUF","tributo:_gIBSCBS:_gIBSUF"))
	ogIBSUF:setAttributeValue("vIBSUF",retValTax(cTax,cAliq, oDetProd, "vIBSUF","tributo:_gIBSCBS:_gIBSUF"))

	ogIBSCBS:addElementNode(ogIBSUF)
	
return

/**
* Instancia o objeto que representa a tag "gDif" do nó "gIBSUF"
**/ 
static function DogIBSUFDif()
					   
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
	
	ogIBSUFDif := MsafNFeTag():newMsafNFeTag("gDif")

	ogIBSUFDif:setAttributeValue("pDif",retValTax(cTax,cAliq, oDetProd, "pDif","tributo:_gIBSCBS:_gIBSUF:_gDif"))
	ogIBSUFDif:setAttributeValue("vDif",retValTax(cTax,cAliq, oDetProd, "vDif","tributo:_gIBSCBS:_gIBSUF:_gDif"))
	
	ogIBSUF:addElementNode(ogIBSUFDif)
 
return

/**
* Instancia o objeto que representa a tag "gDevTrib" do nó "gIBSUF"
**/ 
static function DogIBSUFDevTrib()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
	
	ogIBSUFDevTrib := MsafNFeTag():newMsafNFeTag("gDevTrib")

	ogIBSUFDevTrib:setAttributeValue("vDevTrib",retValTax(cTax,cAliq, oDetProd, "vDevTrib","tributo:_gIBSCBS:_gIBSUF:_gDevTrib"))
	
	ogIBSUF:addElementNode(ogIBSUFDevTrib)
	
return
					   
/**
* Instancia o objeto que representa a tag "gRed" do nó "gIBSUF"
**/ 
static function DogIBSUFRed()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
	
	ogIBSUFRed := MsafNFeTag():newMsafNFeTag("gRed")

	ogIBSUFRed:setAttributeValue("pRedAliq",retValTax(cTax,cAliq, oDetProd, "pRedAliq","tributo:_gIBSCBS:_gIBSUF:_gRed"))
	ogIBSUFRed:setAttributeValue("pAliqEfet",retValTax(cTax,cAliq, oDetProd, "pAliqEfet","tributo:_gIBSCBS:_gIBSUF:_gRed"))
	
	ogIBSUF:addElementNode(ogIBSUFRed)
	
return

/**
* Instancia o objeto que representa a tag "gIBSMun"
**/ 
static function DogIBSMu()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
	
	ogIBSMu := MsafNFeTag():newMsafNFeTag("gIBSMun")
				   
	ogIBSMu:setAttributeValue("pIBSMun",retValTax(cTax,cAliq, oDetProd, "pIBSMun","tributo:_gIBSCBS:_gIBSMun"))
	ogIBSMu:setAttributeValue("vIBSMun",retValTax(cTax,cAliq, oDetProd, "vIBSMun","tributo:_gIBSCBS:_gIBSMun"))

	ogIBSCBS:addElementNode(ogIBSMu)
	
return

/**
* Instancia o objeto que representa a tag "gDif" do nó "gIBSMun"
**/ 
static function DogIBSMuDif()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
							   
	ogIBSMuDif := MsafNFeTag():newMsafNFeTag("gDif")

	ogIBSMuDif:setAttributeValue("pDif",retValTax(cTax,cAliq, oDetProd, "pDif","tributo:_gIBSCBS:_gIBSMun:_gDif"))
	ogIBSMuDif:setAttributeValue("vDif",retValTax(cTax,cAliq, oDetProd, "vDif","tributo:_gIBSCBS:_gIBSMun:_gDif"))
	
	ogIBSMu:addElementNode(ogIBSMuDif)
 
return

/**
* Instancia o objeto que representa a tag "gDevTrib" do nó "gIBSMun"
**/ 
static function DogIBSMuDevTrib()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
	
	ogIBSMuDevTrib := MsafNFeTag():newMsafNFeTag("gDevTrib")

	ogIBSMuDevTrib:setAttributeValue("vDevTrib",retValTax(cTax,cAliq, oDetProd, "vDevTrib","tributo:_gIBSCBS:_gIBSMun:_gDevTrib"))
	
	ogIBSMu:addElementNode(ogIBSMuDevTrib)
 
return

/**
* Instancia o objeto que representa a tag "gRed" do nó "gIBSMun"
**/ 
static function DogIBSMuRed()
												
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
	
	ogIBSMuRed := MsafNFeTag():newMsafNFeTag("gRed")

	// INICIO Wellington 18/11/2026 - Correcao de erro existente: o gRed do gIBSMun lia o caminho do
	// gIBSUF, gravando a reducao estadual no lugar da municipal. Correto: _gIBSMun:_gRed
	ogIBSMuRed:setAttributeValue("pRedAliq",retValTax(cTax,cAliq, oDetProd, "pRedAliq","tributo:_gIBSCBS:_gIBSMun:_gRed"))
	ogIBSMuRed:setAttributeValue("pAliqEfet",retValTax(cTax,cAliq, oDetProd, "pAliqEfet","tributo:_gIBSCBS:_gIBSMun:_gRed"))
	// FIM Wellington 18/11/2026
	
	ogIBSMu:addElementNode(ogIBSMuRed)
	
return

/**
* Instancia o objeto que representa a tag "gCBS"
**/ 
static function DogCBS()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
	
	ogCBS := MsafNFeTag():newMsafNFeTag("gCBS")
	 
	ogCBS:setAttributeValue("pCBS",retValTax(cTax,cAliq, oDetProd, "pCBS","tributo:_gIBSCBS:_gCBS"))
	ogCBS:setAttributeValue("vCBS",retValTax(cTax,cAliq, oDetProd, "vCBS","tributo:_gIBSCBS:_gCBS"))

	ogIBSCBS:addElementNode(ogCBS)
	
return

/**
* Instancia o objeto que representa a tag "gDif" do nó "gCBS"
**/ 
static function DogCBSDif()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
	
	ogCBSDif := MsafNFeTag():newMsafNFeTag("gDif")

	ogCBSDif:setAttributeValue("pDif",retValTax(cTax,cAliq, oDetProd, "pDif","tributo:_gIBSCBS:_gCBS:_gDif"))
	ogCBSDif:setAttributeValue("vDif",retValTax(cTax,cAliq, oDetProd, "vDif","tributo:_gIBSCBS:_gCBS:_gDif"))
	
	ogCBS:addElementNode(ogCBSDif)
 
return

/**
* Instancia o objeto que representa a tag "gDevTrib" do nó "gCBS"
**/ 
static function DogCBSDevTrib()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
	
	ogCBSDevTrib := MsafNFeTag():newMsafNFeTag("gDevTrib")

	ogCBSDevTrib:setAttributeValue("vDevTrib",retValTax(cTax,cAliq, oDetProd, "vDevTrib","tributo:_gIBSCBS:_gCBS:_gDevTrib"))
	
	ogCBS:addElementNode(ogCBSDevTrib)
	
return

/**
* Instancia o objeto que representa a tag "gRed" do nó "gCBS"
**/ 
static function DogCBSRed()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= "" 
	  
	ogCBSRed := MsafNFeTag():newMsafNFeTag("gRed")

	ogCBSRed:setAttributeValue("pRedAliq",retValTax(cTax,cAliq, oDetProd, "pRedAliq","tributo:_gIBSCBS:_gCBS:_gRed"))
	ogCBSRed:setAttributeValue("pAliqEfet",retValTax(cTax,cAliq, oDetProd, "pAliqEfet","tributo:_gIBSCBS:_gCBS:_gRed"))
	
	ogCBS:addElementNode(ogCBSRed)
	
return

/**
* Instancia o objeto que representa a tag "gTribRegular"
**/ 
static function DogTribRegular()
	
	local cTax			:= "IBSCBS"
	local cAliq			:= ""
	local lFormatZero 	:= .F. 
	
	ogTribRegular := MsafNFeTag():newMsafNFeTag("gTribRegular")
 
	ogTribRegular:setAttributeValue("CSTReg",retValTax(cTax,cAliq, oDetProd, "CSTReg","tributo:_gIBSCBS:_gTribRegular",lFormatZero))
	ogTribRegular:setAttributeValue("cClassTribReg",retValTax(cTax,cAliq, oDetProd, "cClassTribReg","tributo:_gIBSCBS:_gTribRegular",lFormatZero))
	ogTribRegular:setAttributeValue("pAliqEfetRegIBSUF",retValTax(cTax,cAliq, oDetProd, "pAliqEfetRegIBSUF","tributo:_gIBSCBS:_gTribRegular"))
	ogTribRegular:setAttributeValue("vTribRegIBSUF",retValTax(cTax,cAliq, oDetProd, "vTribRegIBSUF","tributo:_gIBSCBS:_gTribRegular"))
	ogTribRegular:setAttributeValue("pAliqEfetRegIBSMun",retValTax(cTax,cAliq, oDetProd, "pAliqEfetRegIBSMun","tributo:_gIBSCBS:_gTribRegular"))
	ogTribRegular:setAttributeValue("vTribRegIBSMun",retValTax(cTax,cAliq, oDetProd, "vTribRegIBSMun","tributo:_gIBSCBS:_gTribRegular"))
	ogTribRegular:setAttributeValue("pAliqEfetRegCBS",retValTax(cTax,cAliq, oDetProd, "pAliqEfetRegCBS","tributo:_gIBSCBS:_gTribRegular"))
	ogTribRegular:setAttributeValue("vTribRegCBS",retValTax(cTax,cAliq, oDetProd, "vTribRegCBS","tributo:_gIBSCBS:_gTribRegular"))

	ogIBSCBS:addElementNode(ogTribRegular)
			  
return

/**
* Instancia o objeto que representa a tag "gIBSCredPres"
**/ 
static function DogIBSCredPres()
	
	local cTax			:= "IBSCBS"
	local cAliq			:= ""
	local lFormatZero 	:= .F. 
	 
	ogIBSCredPres := MsafNFeTag():newMsafNFeTag("gIBSCredPres")

	ogIBSCredPres:setAttributeValue("cCredPres",retValTax(cTax,cAliq, oDetProd, "cCredPres","tributo:_gIBSCBS:_gIBSCredPres",lFormatZero))
	ogIBSCredPres:setAttributeValue("pCredPres",retValTax(cTax,cAliq, oDetProd, "pCredPres","tributo:_gIBSCBS:_gIBSCredPres"))
	ogIBSCredPres:setAttributeValue("vCredPres",retValTax(cTax,cAliq, oDetProd, "vCredPres","tributo:_gIBSCBS:_gIBSCredPres"))
	ogIBSCredPres:setAttributeValue("vCredPresCondSus",retValTax(cTax,cAliq, oDetProd, "vCredPresCondSus","tributo:_gIBSCBS:_gIBSCredPres"))
	
	ogIBSCBS:addElementNode(ogIBSCredPres)
	
return

/**
* Instancia o objeto que representa a tag "gCBSCredPres"
**/ 
static function DogCBSCredPres()
	
	local cTax			:= "IBSCBS"
	local cAliq			:= ""
	local lFormatZero 	:= .F. 
	
	ogCBSCredPres := MsafNFeTag():newMsafNFeTag("gCBSCredPres")

	ogCBSCredPres:setAttributeValue("cCredPres",retValTax(cTax,cAliq, oDetProd, "cCredPres","tributo:_gIBSCBS:_gCBSCredPres",lFormatZero))
	ogCBSCredPres:setAttributeValue("pCredPres",retValTax(cTax,cAliq, oDetProd, "pCredPres","tributo:_gIBSCBS:_gCBSCredPres"))
	ogCBSCredPres:setAttributeValue("vCredPres",retValTax(cTax,cAliq, oDetProd, "vCredPres","tributo:_gIBSCBS:_gCBSCredPres"))
	ogCBSCredPres:setAttributeValue("vCredPresCondSus",retValTax(cTax,cAliq, oDetProd, "vCredPresCondSus","tributo:_gIBSCBS:_gCBSCredPres"))
	
	ogIBSCBS:addElementNode(ogCBSCredPres)
	
return
 
/**
* Instancia o objeto que representa a tag "gTribCompraGov"
**/ 
static function DogTribCompraGov()
	
	local cTax			:= "IBSCBS"
	local cAliq			:= ""
	
	ogTribCompraGov := MsafNFeTag():newMsafNFeTag("gTribCompraGov")
 
	ogTribCompraGov:setAttributeValue("pAliqIBSUF",retValTax(cTax,cAliq, oDetProd, "pAliqIBSUF","tributo:_gIBSCBS:_gTribCompraGov"))
	ogTribCompraGov:setAttributeValue("vTribIBSUF",retValTax(cTax,cAliq, oDetProd, "vTribIBSUF","tributo:_gIBSCBS:_gTribCompraGov"))
	ogTribCompraGov:setAttributeValue("pAliqIBSMun",retValTax(cTax,cAliq, oDetProd, "pAliqIBSMun","tributo:_gIBSCBS:_gTribCompraGov"))
	ogTribCompraGov:setAttributeValue("vTribIBSMun",retValTax(cTax,cAliq, oDetProd, "vTribIBSMun","tributo:_gIBSCBS:_gTribCompraGov"))
	ogTribCompraGov:setAttributeValue("pAliqCBS",retValTax(cTax,cAliq, oDetProd, "pAliqCBS","tributo:_gIBSCBS:_gTribCompraGov"))
	ogTribCompraGov:setAttributeValue("vTribCBS",retValTax(cTax,cAliq, oDetProd, "vTribCBS","tributo:_gIBSCBS:_gTribCompraGov"))
 
	ogIBSCBS:addElementNode(ogTribCompraGov)
	
return

/**
* Instancia o objeto que representa a tag "gIBSCBSMono"
**/ 
static function DogIBSCBSMon()
								
	ogIBSCBSMon := MsafNFeTag():newMsafNFeTag("gIBSCBSMono")
	
	oSeqXML:addElementNode(ogIBSCBSMon)
 
return

/**
* Instancia o objeto que representa a tag "gMonoPadrao"
**/ 
static function DogMonPadrao()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= ""
	
	ogMonPadrao := MsafNFeTag():newMsafNFeTag("gMonoPadrao")
 
	ogMonPadrao:setAttributeValue("qBCMono",retValTax(cTax,cAliq, oDetProd, "qBCMono","tributo:_gMonoPadrao"))
	ogMonPadrao:setAttributeValue("adRemIBS",retValTax(cTax,cAliq, oDetProd, "adRemIBS","tributo:_gMonoPadrao"))
	ogMonPadrao:setAttributeValue("adRemCBS",retValTax(cTax,cAliq, oDetProd, "adRemCBS","tributo:_gMonoPadrao"))
	ogMonPadrao:setAttributeValue("vIBSMono",retValTax(cTax,cAliq, oDetProd, "vIBSMono","tributo:_gMonoPadrao"))
	ogMonPadrao:setAttributeValue("vCBSMono",retValTax(cTax,cAliq, oDetProd, "vCBSMono","tributo:_gMonoPadrao"))

	ogIBSCBSMon:addElementNode(ogMonPadrao)
	
return

/**
* Instancia o objeto que representa a tag "gMonoReten"
**/ 
static function DogMonReten()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= ""
	
	ogMonReten := MsafNFeTag():newMsafNFeTag("gMonoReten")
 
	ogMonReten:setAttributeValue("qBCMonoReten",retValTax(cTax,cAliq, oDetProd, "qBCMonoReten","tributo:_gMonoReten"))
	ogMonReten:setAttributeValue("adRemIBSReten",retValTax(cTax,cAliq, oDetProd, "adRemIBSReten","tributo:_gMonoReten"))
	ogMonReten:setAttributeValue("vIBSMonoReten",retValTax(cTax,cAliq, oDetProd, "vIBSMonoReten","tributo:_gMonoReten"))
	ogMonReten:setAttributeValue("adRemCBSReten",retValTax(cTax,cAliq, oDetProd, "adRemCBSReten","tributo:_gMonoReten"))
	ogMonReten:setAttributeValue("vCBSMonoReten",retValTax(cTax,cAliq, oDetProd, "vCBSMonoReten","tributo:_gMonoReten"))

	ogIBSCBSMon:addElementNode(ogMonReten)
	
return

/**
* Instancia o objeto que representa a tag "gMonoRet"
**/ 
static function DogMonRet()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= ""
	
	ogMonRet := MsafNFeTag():newMsafNFeTag("gMonoRet")
 
	ogMonRet:setAttributeValue("qBCMonoRet",retValTax(cTax,cAliq, oDetProd, "qBCMonoRet","tributo:_gMonoRet"))
	ogMonRet:setAttributeValue("adRemIBSRet",retValTax(cTax,cAliq, oDetProd, "adRemIBSRet","tributo:_gMonoRet"))
	ogMonRet:setAttributeValue("vIBSMonoRet",retValTax(cTax,cAliq, oDetProd, "vIBSMonoRet","tributo:_gMonoRet"))
	ogMonRet:setAttributeValue("adRemCBSRet",retValTax(cTax,cAliq, oDetProd, "adRemCBSRet","tributo:_gMonoRet"))
	ogMonRet:setAttributeValue("vCBSMonoRet",retValTax(cTax,cAliq, oDetProd, "vCBSMonoRet","tributo:_gMonoRet"))

	ogIBSCBSMon:addElementNode(ogMonRet)
	
return

/**
* Instancia o objeto que representa a tag "gMonoDif"
**/ 
static function DogMonDif()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= ""
	
	ogMonDif := MsafNFeTag():newMsafNFeTag("gMonoDif")
 
	ogMonDif:setAttributeValue("pDifIBS",retValTax(cTax,cAliq, oDetProd, "pDifIBS","tributo:_gMonoDif"))
	ogMonDif:setAttributeValue("vIBSMonoDif",retValTax(cTax,cAliq, oDetProd, "vIBSMonoDif","tributo:_gMonoDif"))
	ogMonDif:setAttributeValue("pDifCBS",retValTax(cTax,cAliq, oDetProd, "pDifCBS","tributo:_gMonoDif"))
	ogMonDif:setAttributeValue("vCBSMonoDif",retValTax(cTax,cAliq, oDetProd, "vCBSMonoDif","tributo:_gMonoDif"))
	
	ogIBSCBSMon:addElementNode(ogMonDif)
	
return

/**
* Instancia o objeto que representa os atributos da tag "gIBSCBSMono"
**/ 
static function DogIBCBMonAttrib()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= ""
	  
	ogIBCBMonAttrib := MsafNFeTag():newMsafNFeTag("")

	ogIBCBMonAttrib:setAttributeValue("vTotIBSMonoItem",retValTax(cTax,cAliq, oDetProd, "vTotIBSMonoItem","tributo:_gIBSCBSMono"))
	ogIBCBMonAttrib:setAttributeValue("vTotCBSMonoItem",retValTax(cTax,cAliq, oDetProd, "vTotCBSMonoItem","tributo:_gIBSCBSMono"))
	
	ogIBSCBSMon:addElementNode(ogIBCBMonAttrib)
	
return

/**
* Instancia o objeto que representa a tag "gTransfCred"
**/ 
static function DogTransfCred()
	
	local cTax		:= "IBSCBS"
	local cAliq		:= ""
	  
	ogTransfCred := MsafNFeTag():newMsafNFeTag("gTransfCred")

	ogTransfCred:setAttributeValue("vIBS",retValTax(cTax,cAliq, oDetProd, "vIBS","tributo:_gTransfCred"))
	ogTransfCred:setAttributeValue("vCBS",retValTax(cTax,cAliq, oDetProd, "vCBS","tributo:_gTransfCred"))
		
	oSeqXML:addElementNode(ogTransfCred)
	
return

/**
* Instancia o objeto que representa a tag "gCredPresIBSZFM"
**/ 
static function DogCredPresIBSZFM()
	
	local cTax			:= "IBSCBS"
	local cAliq			:= ""
	local lFormatZero 	:= .F. 
 
	ogCredPresIBSZFM := MsafNFeTag():newMsafNFeTag("gCredPresIBSZFM")

	// Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050] lFormatZero passado ao retValTax: no ProcMsaNFe
	// estava na posicao de lAddNode do setAttributeValue e o codigo "0" saia formatado como valor (0.00)
	ogCredPresIBSZFM:setAttributeValue("tpCredPresIBSZFM",retValTax(cTax,cAliq, oDetProd, "tpCredPresIBSZFM","tributo:_gCredPresIBSZFM",lFormatZero))
	ogCredPresIBSZFM:setAttributeValue("vCredPresIBSZFM",retValTax(cTax,cAliq, oDetProd, "vCredPresIBSZFM","tributo:_gCredPresIBSZFM"))
		
	oSeqXML:addElementNode(ogCredPresIBSZFM)
	
return

/**
* ===================================================================
* INICIO Wellington 18/11/2026 - Grupos novos da Reforma Tributaria
* NT 2025.002 v1.53 e NT 2026.008 v1.01
*
* ORDEM DOS CAMPOS: segue a sequencia da NT, extraida dos 11 exemplos
* de plan/HTMLConsolidado.xml. E HIPOTESE DE TRABALHO ate o leiaute
* posicional do Mastersaf chegar (Fase 0, item 3, do plano).
* O TXT e posicional: confirmar a ordem antes de homologar.
* Ver plan/Dimensionamento_Forks_NFe_2027.md secao 3.4.
* ===================================================================
**/

/**
* Instancia o objeto que representa a tag "IS" (Imposto Seletivo)
* XML oficial: det/imposto/IS - irmao de IBSCBS, entre COFINS e IBSCBS
* CONFIRMAR NO LEIAUTE: nome do marcador e ordem do grupo entre os irmaos
**/
static function DoIS()

	local cTax			:= cRtcTaxIS	// lido uma vez em ProcRSymbMsa() (ZZ_TRIBIS)
	local cAliq			:= ""
	local lFormatZero 	:= .F.

	oIS := MsafNFeTag():newMsafNFeTag("IS")

	oIS:setAttributeValue("CSTIS"		, retValTax(cTax,cAliq, oDetProd, "CSTIS"		, "tributo", lFormatZero))
	oIS:setAttributeValue("cClassTribIS", retValTax(cTax,cAliq, oDetProd, "cClassTribIS", "tributo", lFormatZero))
	oIS:setAttributeValue("vBCIS"		, retValTax(cTax,cAliq, oDetProd, "vBCIS"		, "tributo"))
	oIS:setAttributeValue("pIS"			, retValTax(cTax,cAliq, oDetProd, "pIS"			, "tributo"))
	oIS:setAttributeValue("vIS"			, retValTax(cTax,cAliq, oDetProd, "vIS"			, "tributo"))

	oImpostos:addElementNode(oIS)

return

/**
* Instancia o objeto que representa a tag "gAjusteCompet" do no "IBSCBS"
* XML oficial: det/imposto/IBSCBS/gAjusteCompet - debito 03, CST 811
* Quando presente, o gIBSCBS nao pode ir (rejeicoes 1021, 1170 e 1171)
* Adiciona em oSeqXML, mesmo pai do gIBSCBS
**/
static function DogAjusteCompet()

	local cTax		:= "IBSCBS"
	local cAliq		:= ""

	ogAjusteCompet := MsafNFeTag():newMsafNFeTag("gAjusteCompet")

	ogAjusteCompet:setAttributeValue("competApur",retValTax(cTax,cAliq, oDetProd, "competApur","tributo:_gAjusteCompet", .F.))
	ogAjusteCompet:setAttributeValue("vIBS",retValTax(cTax,cAliq, oDetProd, "vIBS","tributo:_gAjusteCompet"))
	ogAjusteCompet:setAttributeValue("vCBS",retValTax(cTax,cAliq, oDetProd, "vCBS","tributo:_gAjusteCompet"))

	oSeqXML:addElementNode(ogAjusteCompet)

return

/**
* Instancia o objeto que representa a tag "gEstornoCred" do no "IBSCBS"
* XML oficial: det/imposto/IBSCBS/gEstornoCred - debito 07, CST 410
* Rejeicoes 1173, 1176 e 1177
* Adiciona em oSeqXML, mesmo pai do gIBSCBS
**/
static function DogEstornoCred()

	local cTax		:= "IBSCBS"
	local cAliq		:= ""

	ogEstornoCred := MsafNFeTag():newMsafNFeTag("gEstornoCred")

	ogEstornoCred:setAttributeValue("vIBSEstCred",retValTax(cTax,cAliq, oDetProd, "vIBSEstCred","tributo:_gEstornoCred"))
	ogEstornoCred:setAttributeValue("vCBSEstCred",retValTax(cTax,cAliq, oDetProd, "vCBSEstCred","tributo:_gEstornoCred"))

	oSeqXML:addElementNode(ogEstornoCred)

return

/**
* Instancia o objeto que representa a tag "ICMSPrevistoPagtoAntecip"
* XML oficial: det/imposto/ICMS/ICMSPrevistoPagtoAntecip - debito 06
* A partir de 01/03/2027 a ausencia gera rejeicao 1281
**/
static function DoICMSPrevAntecip()

	local cTax		:= cRtcTaxIcm	// lido uma vez em ProcRSymbMsa() (ZZ_TRIBICM, default "ICMS")
	local cAliq		:= ""

	oICMSPrevAnt := MsafNFeTag():newMsafNFeTag("ICMSPrevistoPagtoAntecip")

	oICMSPrevAnt:setAttributeValue("vICMSPrevisto",retValTax(cTax,cAliq, oDetProd, "vICMSPrevisto","tributo:_ICMSPrevistoPagtoAntecip"))

	oICMS:addElementNode(oICMSPrevAnt)

return

/**
* Instancia o objeto que representa a tag "DFeReferenciado" do item
* XML oficial: det/DFeReferenciado - depois do vItem
* Regras: a referencia vai no cabecalho OU no item, nunca nos dois
* (VC02-05, rejeicao 1010); nItem e proibido no debito 03 (VC03-10,
* rejeicao 1039). As regras de obrigatoriedade por finalidade dependem
* de decisao fiscal - ver Fase 0, item 5, do plano.
**/
static function DoDFeReferenciado()

	oDFeRef := MsafNFeTag():newMsafNFeTag("DFeReferenciado")

	oDFeRef:setAttributeValue("chaveAcesso",validTagValue("oDetProd:_DFeReferenciado:_chaveAcesso:text"))
	oDFeRef:setAttributeValue("nItem",validTagValue("oDetProd:_DFeReferenciado:_nItem:text"))

	// No IP050 os grupos do item ficam sob "item_nota" (o "det" so leva o nItem)
	oItem_nota:addElementNode(oDFeRef)

return

/**
* Instancia o objeto que representa a tag "vProdLiqTot" do no "total"
* XML oficial: total/vProdLiqTot - ANTES do ICMSTot
* Rejeicoes 1282 e 1283
**/
static function DovProdLiqTot()

	ovProdLiqTot := MsafNFeTag():newMsafNFeTag("vProdLiqTot")

	ovProdLiqTot:setAttributeValue("vProdLiqTot",retValueAttribute("infNfe:_total:_vProdLiqTot:text"))

	oTotal:addElementNode(ovProdLiqTot)

return

/**
* Instancia o objeto que representa a tag "ISTot" do no "total"
* XML oficial: total/ISTot - depois do ICMSTot e antes do IBSCBSTot
* Obrigatorio quando algum item tem IS (rejeicao 1117)
**/
static function DoISTot()

	oISTot := MsafNFeTag():newMsafNFeTag("ISTot")

	oISTot:setAttributeValue("vIS",retValueAttribute("infNfe:_total:_ISTot:_vIS:text"))

	oTotal:addElementNode(oISTot)

return

/**
* FIM Wellington 18/11/2026 - Grupos novos da Reforma Tributaria
**/


/**
* Instancia o objeto que representa a tag "IBSCBSTot"
**/ 
static function DoIBSCBSTot()
	
	local aItens		:= retArrayAttribute("infNfe:_det")	// Wellington Santana 27/11/2026 - funcao definida neste fonte
	local nI			:= 0
	local nJ			:= 0
	local nvBCIBSCBS	:= 0
	local cCstgXml 		:= GetNewPar("MV_CSTGXML", "000/200/210/220/510/550/830/222")
	local oUtils		:= IpUtilsObject():newIpUtilsObject()
	local lIBSCBS		:= .f.
	private oDetNfe		:= nil	// Wellington Santana 27/11/2026 - Private: lido via Type()/fTypeVar

	for nI := 1 to Len(aItens)
		oDetNfe := aItens[nI]
		if fTypeVar("oDetNfe:_imposto") == "A"
			for nJ := 1 to len(oDetNfe:_imposto)
				if fTypeVar("oDetNfe:_imposto["+cValToChar(nJ)+"]:_codigo") == "O"
					if allTrim(oDetNfe:_imposto[nJ]:_codigo:text) $ "IBSCBS"
						lIBSCBS := .t.
						if fTypeVar("oDetNfe:_imposto["+cValToChar(nJ)+"]:_Tributo:_CST") == "O"
							if allTrim(oDetNfe:_imposto[nJ]:_Tributo:_CST:text) $ cCstgXml
								if fTypeVar("oDetNfe:_imposto["+cValToChar(nJ)+"]:_Tributo:_gIBSCBS:_vBC") = "O"
									nvBCIBSCBS += val(oDetNfe:_imposto[nJ]:_Tributo:_gIBSCBS:_vBC:text)
								endIf
							endIf
						endIf
					endIf
				endIf
			next nJ
		elseIf fTypeVar("oDetNfe:_imposto") == "O"
			if fTypeVar("oDetNfe:_imposto:_codigo") == "O"
				if allTrim(oDetNfe:_imposto:_codigo:text) $ "IBSCBS"
					lIBSCBS := .t.
					if fTypeVar("oDetNfe:_imposto:_Tributo:_CST") == "O"
						if allTrim(oDetNfe:_imposto:_Tributo:_CST:text) $ cCstgXml
							// INICIO Wellington 18/11/2026 - Correcao de erro existente: havia dois pontos
							// duplicados em "_Tributo::_gIBSCBS". O fTypeVar nunca retornava "O" e a base do
							// item com um unico imposto ficava fora da soma do vBCIBSCBS
							if fTypeVar("oDetNfe:_imposto:_Tributo:_gIBSCBS:_vBC") = "O"
								nvBCIBSCBS += val(oDetNfe:_imposto:_Tributo:_gIBSCBS:_vBC:text)
							endif
							// FIM Wellington 18/11/2026
						endIf
					endIf
				endIf
			endif
		endIf
	next nI

	oIBSCBSTot := MsafNFeTag():newMsafNFeTag("IBSCBSTot")

	if lRefTribCo .and. lIBSCBS
		//oIBSCBSTot:setAttributeValue("vBCIBSCBS", retValueAttribute("infNfe:_total:_IBSCBSTot:_vBCIBSCBS:text"), lFormatZero)
		oIBSCBSTot:setAttributeValue("vBCIBSCBS",oUtils:strAnyType(nvBCIBSCBS, "@R 999999999999.99"))
	else
		oIBSCBSTot:setAttributeValue("vBCIBSCBS",EMPTY_VALUE)
	endIf
	
	oTotal:addElementNode(oIBSCBSTot)

return

/**
* Instancia o objeto que representa a tag "gIBS_Tot"
**/ 
static function DogIBSTot()
	
	ogIBSTot := MsafNFeTag():newMsafNFeTag("gIBS_Tot")

	oIBSCBSTot:addElementNode(ogIBSTot)
	
return

/**
* Instancia o objeto que representa a tag "gIBSUF_Tot"
**/ 
static function DogIBSUFTot()
				 
	local lFormatZero := .T.	// Wellington Santana 22/11/2026 - [RTC Lote 4] lFormatZero movido para retValueAttribute (estava na posicao de lAddNode)

	ogIBSUFTot := MsafNFeTag():newMsafNFeTag("gIBSUF_Tot")

	ogIBSUFTot:setAttributeValue("vDif", retValueAttribute("infNfe:_total:_IBSCBSTot:_gIBS:_gIBSUF:_vDif:text", lFormatZero))
	ogIBSUFTot:setAttributeValue("vDevTrib", retValueAttribute("infNfe:_total:_IBSCBSTot:_gIBS:_gIBSUF:_vDevTrib:text", lFormatZero))
	ogIBSUFTot:setAttributeValue("vIBSUF", retValueAttribute("infNfe:_total:_IBSCBSTot:_gIBS:_gIBSUF:_vIBSUF:text", lFormatZero))

	ogIBSTot:addElementNode(ogIBSUFTot)

return

/**
* Instancia o objeto que representa a tag "gIBSMun_Tot"
**/ 
static function DogIBSMuTot()
	
	local lFormatZero := .T.	// Wellington Santana 22/11/2026 - [RTC Lote 4] lFormatZero movido para retValueAttribute (estava na posicao de lAddNode)
 
	ogIBSMuTot := MsafNFeTag():newMsafNFeTag("gIBSMun_Tot")

	ogIBSMuTot:setAttributeValue("vDif", retValueAttribute("infNfe:_total:_IBSCBSTot:_gIBS:_gIBSMun:_vDif:text", lFormatZero))
	ogIBSMuTot:setAttributeValue("vDevTrib", retValueAttribute("infNfe:_total:_IBSCBSTot:_gIBS:_gIBSMun:_vDevTrib:text", lFormatZero))
	ogIBSMuTot:setAttributeValue("vIBSMun", retValueAttribute("infNfe:_total:_IBSCBSTot:_gIBS:_gIBSMun:_vIBSMun:text", lFormatZero))

	ogIBSTot:addElementNode(ogIBSMuTot)

return

/**
* Instancia o objeto que representa os atributos da tag "gIBS_Tot"
**/ 
static function DogIBSTotAttrib()
	
	local lFormatZero := .T.	// Wellington Santana 22/11/2026 - [RTC Lote 4] lFormatZero movido para retValueAttribute (estava na posicao de lAddNode)
 
	ogIBSTotAttrib := MsafNFeTag():newMsafNFeTag("")

	ogIBSTotAttrib:setAttributeValue("vIBS", retValueAttribute("infNfe:_total:_IBSCBSTot:_gIBS:_vIBS:text", lFormatZero))
	// INICIO Wellington 18/11/2026 - Correcao de erro existente: nome do atributo estava
	// "vCresPres". Nao afeta o TXT, que e posicional, mas divergia do equivalente no gCBS
	ogIBSTotAttrib:setAttributeValue("vCredPres", retValueAttribute("infNfe:_total:_IBSCBSTot:_gIBS:_vCredPres:text", lFormatZero))
	// FIM Wellington 18/11/2026
	ogIBSTotAttrib:setAttributeValue("vCredPresCondSus", retValueAttribute("infNfe:_total:_IBSCBSTot:_gIBS:_vCredPresCondSus:text", lFormatZero))

	ogIBSTot:addElementNode(ogIBSTotAttrib)
	
return
 
/**
* Instancia o objeto que representa a tag "gCBS_Tot"
**/ 
static function DogCBSTot()
	
	local lFormatZero := .T.	// Wellington Santana 22/11/2026 - [RTC Lote 4] lFormatZero movido para retValueAttribute (estava na posicao de lAddNode)
 
	ogCBSTot := MsafNFeTag():newMsafNFeTag("gCBS_Tot")

	ogCBSTot:setAttributeValue("vDif", retValueAttribute("infNfe:_total:_IBSCBSTot:_gCBS:_vDif:text", lFormatZero))
	ogCBSTot:setAttributeValue("vDevTrib", retValueAttribute("infNfe:_total:_IBSCBSTot:_gCBS:_vDevTrib:text", lFormatZero))
	ogCBSTot:setAttributeValue("vCBS", retValueAttribute("infNfe:_total:_IBSCBSTot:_gCBS:_vCBS:text", lFormatZero))
	ogCBSTot:setAttributeValue("vCredPres", retValueAttribute("infNfe:_total:_IBSCBSTot:_gCBS:_vCredPres:text", lFormatZero))
	ogCBSTot:setAttributeValue("vCredPresCondSus", retValueAttribute("infNfe:_total:_IBSCBSTot:_gCBS:_vCredPresCondSus:text", lFormatZero))
			 
	oIBSCBSTot:addElementNode(ogCBSTot)
	
return

/**
* Instancia o objeto que representa a tag "gMono_Tot"
**/ 
static function DogMonTot()
	
	local lFormatZero := .T.	// Wellington Santana 22/11/2026 - [RTC Lote 4] lFormatZero movido para retValueAttribute (estava na posicao de lAddNode)

	ogMonTot := MsafNFeTag():newMsafNFeTag("gMono_Tot")

	ogMonTot:setAttributeValue("vIBSMono", retValueAttribute("infNfe:_total:_IBSCBSTot:_gMono:_vIBSMono:text", lFormatZero))
	ogMonTot:setAttributeValue("vCBSMono", retValueAttribute("infNfe:_total:_IBSCBSTot:_gMono:_vCBSMono:text", lFormatZero))
	ogMonTot:setAttributeValue("vIBSMonoReten", retValueAttribute("infNfe:_total:_IBSCBSTot:_gMono:_vIBSMonoReten:text", lFormatZero))
	ogMonTot:setAttributeValue("vCBSMonoReten", retValueAttribute("infNfe:_total:_IBSCBSTot:_gMono:_vCBSMonoReten:text", lFormatZero))
	ogMonTot:setAttributeValue("vIBSMonoRet", retValueAttribute("infNfe:_total:_IBSCBSTot:_gMono:_vIBSMonoRet:text", lFormatZero))
	ogMonTot:setAttributeValue("vCBSMonoRet", retValueAttribute("infNfe:_total:_IBSCBSTot:_gMono:_vCBSMonoRet:text", lFormatZero))
	
	oIBSCBSTot:addElementNode(ogMonTot)
	
return
 
/**
* Instancia o objeto que representa o atributo "vNFTot" da tag "total"
**/ 
static function DovNFTot()

	local lFormatZero := .T.	// Wellington Santana 22/11/2026 - [RTC Lote 4] lFormatZero movido para retValueAttribute (estava na posicao de lAddNode)
	
	ovNFTot := MsafNFeTag():newMsafNFeTag("")

	ovNFTot:setAttributeValue("vNFTot", retValueAttribute("infNfe:_total:_vNFTot:text", lFormatZero))

	oTotal:addElementNode(ovNFTot)

return

/**
* FIM Wellington Santana 27/11/2026 - [RTC-2026/2027 - IP050]
**/
