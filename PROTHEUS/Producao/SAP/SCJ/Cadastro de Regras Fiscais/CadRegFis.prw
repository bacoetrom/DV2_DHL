#include "totvs.ch"
#include "dhl.ch"
#include "fwmvcdef.ch"

#Define MVC_MAIN_ID       "CadRegFis"
#Define MVC_MODEL_ID      "MIDREGFI"
#Define TITLE_MODEL       "Cadastro de Regras Fiscais"
#Define TITLE_VIEW        TITLE_MODEL
#Define ALIAS_FORM		  "SZC"
#Define ID_MODEL_FORM	  ALIAS_FORM + "FORM"
#Define ID_VIEW_FORM	  "VIEW_FORM"

// [RTC-2026/2027 - LC 214/2025 / Ajuste SINIEF 49/2025] Campos opcionais de discriminação da regra.
// Só são considerados se existirem no dicionário (SX3) - ver pendências de dicionário do Lote 1.
#Define FLD_FINNFE		  "ZC_FINNFE"	// Finalidade da NF-e (1,2,3,4,5,6)
#Define FLD_TPCOMPL		  "ZC_TPCOMPL"	// Subtipo crédito/débito (mesma convenção de F2_TPCOMPL/F1_TPCOMPL)


/*/{Protheus.doc} CadRegFis
Cadastro de Regras Fiscais
Fonte utlizado para determinar TES aproximada para o faturamento da NF RCO

@author Thiago Meschiatti
@since 18/05/2017
@version 1.1

@history 21/11/2026, Wellington Santana, [RTC-2026/2027] Validação TudoOk: regra duplicada,
         TES inexistente e coerência TES x finalidade/subtipo (ZC_FINNFE/ZC_TPCOMPL)
         conforme Ajuste SINIEF 49/2025. Include Protheus.ch substituído por totvs.ch.

@type function
/*/
User Function CadRegFis()

	local oBrowse := FwMbrowse():new()

    oBrowse:setAlias(ALIAS_FORM)
    oBrowse:setDescription(TITLE_MODEL)

    oBrowse:activate()

return

/**
 * Opções do browse
 */
static function menuDef()

    local aOpcoes := {}
    local cViewId := "viewDef."+MVC_MAIN_ID

    ADD OPTION aOpcoes TITLE "Pesquisar"   ACTION "PesqBrw"    OPERATION 1 ACCESS 0
    ADD OPTION aOpcoes TITLE "Visualizar"  ACTION cViewId      OPERATION 2 ACCESS 0
    ADD OPTION aOpcoes TITLE "Incluir"     ACTION cViewId      OPERATION 3 ACCESS 0
    ADD OPTION aOpcoes TITLE "Alterar"     ACTION cViewId      OPERATION 4 ACCESS 0
    ADD OPTION aOpcoes TITLE "Excluir"     ACTION cViewId      OPERATION 5 ACCESS 0

return aOpcoes

/**
 * Modelagem
 */
static function modelDef()

    // [RTC-2026/2027] Antes: {|oModel| .T. } - nenhuma validação. A query fQryTes (DHLIp040Sap)
    // retorna o PRIMEIRO registro que casar com os flags; regras duplicadas tornavam a TES aleatória.
    local bValidModel 	:= {|oModel| vldRegra(oModel) }
    local oModel 		:= MpFormModel():new(MVC_MODEL_ID, nil, bValidModel)
    local oSZC   		:= FwFormStruct(MVC_MODEL_STRUCT, ALIAS_FORM)

    oModel:setDescription(TITLE_MODEL)
    oModel:addFields(ID_MODEL_FORM, nil, oSZC)
    oModel:getModel(ID_MODEL_FORM):setDescription(TITLE_MODEL)
    oModel:setPrimaryKey({"ZC_FILIAL","ZC_CODIGO"})

return oModel

/**
 * Interface Visual
 */
static function viewDef()

    local oView  := FwFormView():new()
    local oModel := FwLoadModel(MVC_MAIN_ID)
    local oSZC   := FwFormStruct(MVC_VIEW_STRUCT, ALIAS_FORM)

    oView:setModel(oModel)
    oView:addField(ID_VIEW_FORM, oSZC, ID_MODEL_FORM)

return oView


/*/{Protheus.doc} vldRegra
Validação TudoOk da regra fiscal (SZC).

[RTC-2026/2027 - LC 214/2025 / Ajuste SINIEF 49/2025]
1) TES informada deve existir na SF4;
2) Não pode existir outra regra ativa com a mesma combinação de flags
   (ICMS próprio, redução de base, ST, DIFAL, ZFM e, se existirem, finalidade/subtipo);
3) Se ZC_FINNFE/ZC_TPCOMPL existirem no dicionário:
   - finalidade 5 (crédito) exige TES de entrada; 6 (débito) exige TES de saída;
   - finalidades 5/6 exigem subtipo;
   - o CFOP da TES deve ser coerente com o subtipo (Ajuste SINIEF 49/2025),
     validação desligável pelo parâmetro ZZ_RTCVLCF (default .T.).

@type function
@author Wellington Santana
@since 21/11/2026
@param oModel, object, Modelo MVC ativo
@return logical, .T. se a regra é válida
/*/
static function vldRegra(oModel)

	local lRet		:= .T.
	local nOper		:= oModel:getOperation()
	local oSql		:= nil
	local oFrm		:= oModel:getModel(ID_MODEL_FORM)
	local cTes		:= ""
	local cCfop		:= ""
	local cFinNfe	:= ""
	local cTpCompl	:= ""
	local cWhere	:= ""
	local cCfopOk	:= ""
	local lHasFin	:= SZC->(FieldPos(FLD_FINNFE))  > 0
	local lHasTpC	:= SZC->(FieldPos(FLD_TPCOMPL)) > 0
	local lVldCfop	:= SuperGetMV("ZZ_RTCVLCF", .F., .T.)

	if nOper <> MODEL_OPERATION_INSERT .and. nOper <> MODEL_OPERATION_UPDATE
		return .T.
	endIf

	oSql	:= IpSqlObject():newIpSqlObject()
	cTes	:= AllTrim(oFrm:getValue("ZC_TES"))

	if lHasFin
		cFinNfe := AllTrim(oFrm:getValue(FLD_FINNFE))
	endIf
	if lHasTpC
		cTpCompl := cValToChar(Val(oFrm:getValue(FLD_TPCOMPL)))	// "07" ou "7" -> "7" (convenção F2_TPCOMPL)
		if cTpCompl == "0"
			cTpCompl := ""
		endIf
	endIf

	// 1) TES existente
	if Empty(cTes) .or. !oSql:exists("SF4", "%SF4.XFILIAL% AND F4_CODIGO = '" + cTes + "'")
		Help(" ", 1, "CADREGFIS",, "TES '" + cTes + "' não encontrada no cadastro (SF4).", 1, 0)
		lRet := .F.
	endIf

	// 2) Regra duplicada (fQryTes seleciona o primeiro registro que casar)
	if lRet
		cWhere := "%SZC.XFILIAL%"
		cWhere += " AND ZC_ICMPROP = '" + oFrm:getValue("ZC_ICMPROP") + "'"
		cWhere += " AND ZC_ICMREDB = '" + oFrm:getValue("ZC_ICMREDB") + "'"
		cWhere += " AND ZC_ICMST   = '" + oFrm:getValue("ZC_ICMST")   + "'"
		cWhere += " AND ZC_ICMDIFA = '" + oFrm:getValue("ZC_ICMDIFA") + "'"
		cWhere += " AND ZC_ICMZFM  = '" + oFrm:getValue("ZC_ICMZFM")  + "'"
		if lHasFin
			cWhere += " AND " + FLD_FINNFE  + " = '" + oFrm:getValue(FLD_FINNFE)  + "'"
		endIf
		if lHasTpC
			cWhere += " AND " + FLD_TPCOMPL + " = '" + oFrm:getValue(FLD_TPCOMPL) + "'"
		endIf
		if nOper == MODEL_OPERATION_UPDATE
			cWhere += " AND SZC.R_E_C_N_O_ <> " + cValToChar(SZC->(RecNo()))
		endIf

		if oSql:exists("SZC", cWhere)
			Help(" ", 1, "CADREGFIS",, "Já existe regra fiscal com a mesma combinação de indicadores. " + ;
				"A busca da TES (IP_040) usaria apenas a primeira regra encontrada.", 1, 0)
			lRet := .F.
		endIf
	endIf

	// 3) [RTC-2026/2027 - Ajuste SINIEF 49/2025] Coerência finalidade x subtipo x TES/CFOP
	if lRet .and. lHasFin .and. cFinNfe $ "5|6"

		if lHasTpC .and. Empty(cTpCompl)
			Help(" ", 1, "CADREGFIS",, "Para finalidade 5 (crédito) ou 6 (débito) o subtipo (" + FLD_TPCOMPL + ") é obrigatório.", 1, 0)
			lRet := .F.
		endIf

		if lRet .and. cFinNfe == "5" .and. cTes >= "500"
			Help(" ", 1, "CADREGFIS",, "Nota de Crédito (finNFe 5) é documento de entrada: informe TES de entrada (< 500).", 1, 0)
			lRet := .F.
		elseIf lRet .and. cFinNfe == "6" .and. cTes < "500"
			Help(" ", 1, "CADREGFIS",, "Nota de Débito (finNFe 6) é documento de saída: informe TES de saída (>= 500).", 1, 0)
			lRet := .F.
		endIf

		if lRet .and. lVldCfop .and. !Empty(cTpCompl)
			cCfop	:= AllTrim(oSql:getFieldValue("SF4", "F4_CF", "%SF4.XFILIAL% AND F4_CODIGO = '" + cTes + "'"))
			cCfopOk	:= cfopEsperado(cFinNfe, cTpCompl)
			if !Empty(cCfopOk) .and. !(cCfop + "|" $ cCfopOk)
				Help(" ", 1, "CADREGFIS",, "CFOP " + cCfop + " da TES " + cTes + " incompatível com finNFe " + cFinNfe + ;
					" / subtipo " + cTpCompl + " (Ajuste SINIEF 49/2025). Esperado: " + cCfopOk, 1, 0)
				lRet := .F.
			endIf
		endIf

	endIf

return lRet


/*/{Protheus.doc} cfopEsperado
Lista de CFOPs aceitos por finalidade/subtipo, conforme Ajuste SINIEF 49/2025
e definição do levantamento fiscal (FDD IM04). Retorno vazio = sem restrição.

@type function
@author Wellington Santana
@since 21/11/2026
@param cFinNfe, character, Finalidade ("5" crédito / "6" débito)
@param cTpCompl, character, Subtipo sem zero à esquerda (convenção F2_TPCOMPL)
@return character, CFOPs aceitos separados por "|" (terminando em "|")
/*/
static function cfopEsperado(cFinNfe, cTpCompl)

	local cRet := ""

	if cFinNfe == "6"
		if cTpCompl == "7"			// [RTC] Débito 07 - perda em estoque
			cRet := "5927|"
		elseIf cTpCompl == "6"		// [RTC] Débito 06 - simples faturamento/pagamento antecipado
			cRet := "5922|6922|"
		elseIf cTpCompl == "9"		// [RTC] Débito 09 - saída de devolução/retorno
			cRet := "5201|6201|5202|6202|5949|6949|"
		endIf
	elseIf cFinNfe == "5"
		if cTpCompl == "3"			// [RTC] Crédito 03 - entrada correspondente
			cRet := "1201|2201|1202|2202|1949|2949|"
		elseIf cTpCompl == "4"		// [RTC] Crédito 04 - CFOP inverso da operação original
			cRet := "1202|2202|1949|2949|"
		endIf
	endIf

return cRet
