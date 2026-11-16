#Include 'Protheus.ch'
#include 'FWMVCDEF.CH'
#include "rwmake.ch"
#include "dhl.ch"

#define MVC_TITLE         				"Notas Fiscais Inutilizadas"
#define DHL_NFE_TYPE_DISABLE    		"DISABLE"
#define DHL_NFE_TYPE_RESEND    			"RESEND"
#define DHL_NFE_STATUS_TRANSMITTED    	"1"
#define DHL_NFE_STATUS_HOMOLOGATED  	"2"

#define NF_TABELA 					"01"

/*/{Protheus.doc} PrcInutMsa

Rotina responsável pela visualização das notas fiscais inutilizadas.
	
@author Diego de Angelo
@since 10/11/20142

/*/
user function PrcInutMsa()
	local 	oBrowse		:= nil
	private bDisable		:= {|| execProcess(DHL_NFE_TYPE_DISABLE)}
	private bResend   	:= {|| execProcess(DHL_NFE_TYPE_RESEND)}
	private oParamBox		:= nil
	private cCadastro		:= ""
	
	aRotina	:= {}
	
	oBrowse 	:= FwMBrowse():new()
	
	oBrowse:setAlias("SZ5") 
	
	oBrowse:AddLegend( "Z5_STATUS == '1'", "BLUE"		, "NF Transmitida"	)		
	oBrowse:AddLegend( "Z5_STATUS == '2'", "GREEN"	, "NF Homologada"	)		
	oBrowse:AddLegend( "Z5_STATUS == '3'", "RED"		, "NF Não Homologada")
	
	oBrowse:setDescription(MVC_TITLE)
	oBrowse:activate()
	
return


/*
*	Função responsável pela execução do processamento.
**/	
static function execProcess(cType)
	Processa( {|| processInvoice(cType) }, "Aguarde...", "Processando...",.F.)
return


/*
*	Função responsável pela definição das opções de menu.
**/
static function menuDef() 

	local aRotina := {} 
 
 	ADD OPTION aRotina Title "Visualizar"	ACTION "ViewDef.PrcInutMsa"		OPERATION 2 	ACCESS 0
	ADD OPTION aRotina Title "Inutilizar"	Action 'Eval(bDisable)' 	OPERATION 3	ACCESS 0
	ADD OPTION aRotina Title "Retransmitir"	Action 'Eval(bResend)'	OPERATION 4	ACCESS 0

return aRotina


/**
 * Modelagem
 */
static function modelDef()
      
    local oModel 		:= MpFormModel():new("MODELINUT")
    local oSZ5   		:= FwFormStruct(MVC_MODEL_STRUCT, "SZ5")   
    
    oModel:setDescription(MVC_TITLE)
    oModel:addFields("SZ5", nil, oSZ5)
    oModel:getModel("SZ5"):setDescription(MVC_TITLE)     
    oModel:setPrimaryKey({})

return oModel


/**
 * Interface Visual
 */
static function viewDef()

    local oView  := FwFormView():new()
    local oModel := FwLoadModel("PrcInutMsa")
    local oSZ5   := FwFormStruct(MVC_VIEW_STRUCT, "SZ5")
    
    oView:setModel(oModel)
    oView:addField("SZ5", oSZ5, "SZ5")

return oView

/*
*	Função responsável pela exibição da tela de parâmetros.
**/
static function showParam()
	local cNome		:= "PrcInutMsa" 
	local cTitulo		:= "Informe documento e série"
	
	oParamBox 	:= IpParamBoxObject():newIpParamBoxObject(cNome)
	
	oParamBox:setTitle(cTitulo)
	
	oParam := IpParamObject():newIpParamObject("notaDe", "get", "Da Nota", "N", 9, 9)
	oParam:setPicture("@E 999999999")
	oParam:setRequired(.F.)
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("notaAte", "get", "Até a Nota", "N", 9, 9)
	oParam:setPicture("@E 999999999")
	oParam:setRequired(.T.)
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serie", "get", "Série", "C", 9, TamSx3("F3_SERIE")[1])
	oParam:setPicture("@!")
	oParam:setRequired(.T.)
	oParamBox:addParam(oParam)

return oParamBox:show()


/*
*	Função responsável pela criação do arquivo.
**/
static function createFile(cInvoice, cSeries)
	
	local cCnpj		:= SM0->M0_CGC
	local cInsc		:= SM0->M0_INSC
	local cTbAmb	:= SuperGetMv("ZZ_TPAMB",,'2')
	local cJustific	:= SuperGetMv("ZZ_JUSINUT",,'Cancelamento de nota fiscal eletronica por emissao indevida, sem trasmissao a SEFAZ')
	local oTxtFile	:= nil
	local cAno		:= SubString(cValToChar(Year(dDataBase)),3,2)
	local lRet		:= .T.
	
	oFile	 	:= MsafNFeTag():newMsafNFeTag("arquivo")
	oNota 		:= MsafNFeTag():newMsafNFeTag("nota_inutilizada")
	
	oNota:setAttributeValue("versao"			, DHL_NFE_VERSION					)
	oNota:setAttributeValue("CNPJ"				, cCnpj								)
	oNota:setAttributeValue("Docstat"			, DHL_NFE_STATUS_HOMOLOGATED		)
	oNota:setAttributeValue("tpAmb"				, cTbAmb							)
	oNota:setAttributeValue("nNFIni"			, cInvoice							)	
	oNota:setAttributeValue("nNFFin"			, cInvoice							)
	oNota:setAttributeValue("serie"				, cSeries							)
	oNota:setAttributeValue("xJustificativa"	, cJustific							)
	oNota:setAttributeValue("ano"				, cAno								)
	oNota:setAttributeValue("IE"				, cInsc								)
	oNota:setAttributeValue("mod"				, "55"								)

	oFile:addElementNode(oNota)
	
	oTxtFile := MsafNfeFile():newMsafNfeFile(oFile)
	
	lRet	:= oTxtFile:createTxt(DHL_NFE_GENERATE_INUTILIZATION, cInvoice, cSeries)
	
return lRet


/*
*	Função responsável pelo retorno das notas a serem executadas.
**/
static function processInvoice(cType)
	
	local nLen		:= 0
	local nI		:= 0
	local cInvoice	:= ""
	local cSeries	:= ""
	local cFromInv	:= ""
	local cLogOk	:= ""
	local nInvIni	:= 0
	
	if cType == DHL_NFE_TYPE_DISABLE
		if !showParam()
			return
		endIf
		
		nInvIni	:= oParamBox:getValue("notaDe")
		nLen		:= oParamBox:getValue("notaAte")
		cSeries	:= oParamBox:getValue("serie") 
		cFromInv	:= StrZero(nInvIni, getTamDoc(cSeries))
		
		ProcRegua(nLen)
		
		for nI:= nInvIni to nLen
			
			IncProc("Processando [Nota: "+ alltrim(cFromInv) + " Série: " + alltrim(cSeries) + "] ...")
			
			if existsInvoice(cFromInv, cSeries)
				cLogOk	+= CRLF + "Nota: " + cFromInv + " Série: " + cSeries + " --> NF já processada! "
			else
				if checkExclusion(cFromInv, cSeries, @cLogOK)
					if createFile(cFromInv, cSeries)
						incInutilization(cFromInv, cSeries)
						contrSx5(cFromInv, cSeries)
						cLogOk	+= CRLF + "Nota: " + cFromInv + " Série: " + cSeries + " --> NF processada com sucesso! "
					endIf
				endif
			endIf
			cFromInv	:= 	Soma1(cFromInv)
		next nI
			
	elseif cType == DHL_NFE_TYPE_RESEND
		if alltrim(SZ5->Z5_STATUS) != DHL_NFE_STATUS_HOMOLOGATED
			cInvoice	:= SZ5->Z5_DOC
			cSeries		:= SZ5->Z5_SERIE
			createFile(cInvoice, cSeries)
			cLogOk	+= CRLF + "Nota: " + cInvoice + " Série: " + cSeries + " --> NF processada com sucesso! "
		else
			cLogOk	+= CRLF + "Nota: " + SZ5->Z5_DOC + " Série: " + SZ5->Z5_SERIE + " --> NF já processada! "
		endif
	endIf
	
	Aviso("Atenção","Nota(s) processada(s): " + CRLF + cLogOk,{"OK"},3)
	
return


/*
*	Função responsável pela validação das notas
**/
static function existsInvoice(cInvoice, cSeries)

	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local lExists	:= oSqlUtil:exists("SZ5", "Z5_FILIAL = '%SF3.FILIAL%' AND Z5_DOC = '"+cInvoice+"' AND Z5_SERIE = '"+cSeries+"' ")
	
return lExists 


/*
*	Função responsável pela validação das notas
**/
static function incInutilization(cInvoice, cSeries)
	local aData		:= {}
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	
	aAdd(aData, {"Z5_FILIAL"	,xFilial("SZ5")						})
	aAdd(aData, {"Z5_DOC"		,cInvoice							})
	aAdd(aData, {"Z5_SERIE"		,cSeries							})
	aAdd(aData, {"Z5_DTTRNFE"	,dDataBase							})
	aAdd(aData, {"Z5_STATUS"	, DHL_NFE_STATUS_TRANSMITTED		})
	
	oSqlUtil:insert("SZ5", aData)
return


/**
 * Coleta o Tamanho do Número do Documento de acordo com a Serie
 */
static function getTamDoc(cSerie)
	
	local nTamDoc := Len(SF2->F2_DOC)
	local oSql    := IpSqlObject():newIpSqlObject()
	
	oSql:newTable("SX5", "X5_DESCRI DOCATUAL", "%SX5.XFILIAL% AND X5_TABELA = '01' AND X5_CHAVE = '"+cSerie+"'")
	
	if oSql:hasRecords()
		nTamDoc := oSql:getValue("Len(AllTrim(DOCATUAL))")
	endIf
	
	oSql:close()
	
return nTamDoc


/*
** Controla numeração do SX5
*/
static function contrSx5(cNumDoc, cSerie)
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cNumSx5	:= ""
	local cTipoNf  	:= SuperGetMv("MV_TPNRNFS")
	local nDif 		:= 0
	
	cNumSx5 := oSql:getFieldValue("SX5", "X5_DESCRI", "%SX5.XFILIAL% AND X5_TABELA = '"+NF_TABELA+"' AND X5_CHAVE = '"+cSerie+"'")
	
	if (val(cNumDoc) >= val(cNumSx5))
		nDif := val(cNumDoc) - val(cNumSx5)
		nDif := if (nDif == 0 , 1, nDif)
		for nI := 1 to nDif
			NxtSX5Nota(cSerie, NIL, cTipoNf)
		next nI
	endif
return()


/*
** Verifica se NF esta no sistema
*/
static function checkExclusion(cFromInv, cSeries, cLogOK)
	local aArea		:= GetArea()
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()	
	local cFormProp	:= Alltrim(oSqlUtil:getFieldValue("SF3", "F3_FORMUL", " %SF3.XFILIAL% AND F3_NFISCAL = '"+cFromInv+"' AND F3_SERIE = '"+cSeries+"' "))
	local lExists	:= .T.
	
	if cFormProp == "S"
		lExists	:= oSqlUtil:exists("SF1", "F1_FILIAL = '%SF1.FILIAL%' AND F1_DOC = '"+cFromInv+"' AND F1_SERIE = '"+cSeries+"' ")	
	else
		lExists	:= oSqlUtil:exists("SF2", "F2_FILIAL = '%SF2.FILIAL%' AND F2_DOC = '"+cFromInv+"' AND F2_SERIE = '"+cSeries+"' ")	
	endIf
	
	if lExists
		cLogOK += CRLF + "Nota: " + cFromInv + " Série: " + cSeries + " --> Ação do Usuário: Favor excluir NF no protheus antes inutilizar a numeração!"
	endif 
	
	restArea(aArea)
return(!lExists)