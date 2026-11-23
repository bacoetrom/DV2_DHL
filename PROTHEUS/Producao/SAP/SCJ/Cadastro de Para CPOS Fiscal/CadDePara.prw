/*Importar as bibliotecas*/
#INCLUDE "TOTVS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

#Define MVC_MAIN_ID       "CadDePara"
// [RTC-2026/2027] Antes "MIDREGFI" - mesmo ID de modelo do CadRegFis (SZC). IDs de modelo MVC
// devem ser únicos (cache do FwLoadModel / pontos de entrada MVC). Nenhum fonte referencia o ID.
#Define MVC_MODEL_ID      "MIDDEPAR"
#Define TITLE_MODEL       "Cadastro de De/Para Campos Fiscais"
#Define TITLE_VIEW        TITLE_MODEL
#Define ALIAS_FORM		  "SZD"
#Define ALIAS_GRID		  "SZD"
#Define ID_MODEL_FORM	  ALIAS_FORM + "FORM"
#Define ID_MODEL_GRID	  ALIAS_GRID + "GRID"
#Define ID_VIEW_FORM	  "VIEW_FORM"
#Define ID_VIEW_GRID	  "VIEW_GRID"
#Define BOX_FORM		  "BOX_TOP"
#Define BOX_GRID		  "BOX_BOTTOM"


#DEFINE FIELD_HEADER 'ZD_TABDE|'

// [RTC-2026/2027] Tabelas de destino efetivamente tratadas por DHLIp040Sap:validValues()
#DEFINE TAB_PARA_OK  'SF2|SD2|SFT|SB1|CD2|SF3|'
// [RTC-2026/2027 - Lote 2 | Wellington Santana 22/11/2026] Destinos por origem, conforme validValues():
// SZA (cabecalho) so atualiza SF2; SZB (itens) atualiza SD2/SFT/SB1/CD2/SF3.
#DEFINE TAB_PARA_SZA 'SF2|'
#DEFINE TAB_PARA_SZB 'SD2|SFT|SB1|CD2|SF3|'
// [RTC-2026/2027 - Lote 2 | Wellington Santana 22/11/2026] IBS/CBS nao possuem registro na CD2 (motor de tributos TOTVS)
#DEFINE FIELDS_IBSCBS 'ZB_IBSUFTX|ZB_IBSUFBS|ZB_IBSUFVL|ZB_IBSMUTX|ZB_IBSMUBS|ZB_IBSMUVL|ZB_CBSTXRT|ZB_CBSTXBS|ZB_CBSTXVL|'

/*/{Protheus.doc} CadDePara
Cadastro de De/Para de campos fiscais (SZD) usado por DHLIp040Sap:setFieldsSzd()
para sobrescrever SF2/SD2/SFT/SB1/CD2/SF3 com os valores recebidos do SAP (IP_040).

@type function
@author DHL
@history 21/11/2026, Wellington Santana, [RTC-2026/2027] ID de modelo único, validação de linha
         (campos de origem/destino existentes no dicionário e tabela destino suportada).
@history 22/11/2026, Wellington Santana, [RTC-2026/2027 - Lote 2] Tabela destino amarrada à origem
         (SZA->SF2; SZB->SD2/SFT/SB1/CD2/SF3) e bloqueio de de/para IBS/CBS para a CD2.
/*/
User Function CadDePara()

	Local cTabela := ""
	Local lRet := .T.
	Local aRet := {}
	Local aParamBox 	:= {}

	Private oBrowse
	Private cChaveAux := ""

	aAdd( aParamBox ,{2,"Tabela",1, {"", "SZA-Cabeçalho IP_040", "SZB-Itens IP_040", "ZZZ-Todas"}, 70,'.T.',.T.})

	If ParamBox(aParamBox,"Parâmetros...",@aRet)
		if valType(aRet[1]) == "N"
			alert("Parâmetro não foi informado!")
		else
			if empty(aRet[1])
				alert("Parâmetro não foi informado!")
			else
				cTabela := left(aRet[1],3)
			endif
		endif
	Else
		lRet := .f.
	EndIf

	If lRet
		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias(ALIAS_FORM)
		oBrowse:SetDescription(TITLE_MODEL)
		if !(empty(cTabela)) .and. (cTabela # "ZZZ")
			oBrowse:SetFilterDefault( "ZD_TABDE == '"+cTabela+"'" )
		endif
		oBrowse:Activate()
	EndIf

Return


Static Function MenuDef()

	Local aRotina := {}
	local cViewId := "viewDef."+MVC_MAIN_ID

	ADD OPTION aRotina TITLE "Pesquisar"  	ACTION 'PesqBrw' 	OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION cViewId 		OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	ACTION cViewId 		OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	ACTION cViewId 		OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Imprimir" 	ACTION cViewId 		OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE "Copiar" 		ACTION cViewId 		OPERATION 9 ACCESS 0

Return aRotina


Static Function ModelDef()

	Local oModel
	Local oStr1Form := FWFormStruct( 1, ALIAS_FORM, { | cField |  AllTrim( cField ) + '|' $ FIELD_HEADER })
	Local oStr2Grid := FWFormStruct( 1, ALIAS_FORM, { | cField |  !AllTrim( cField ) + '|' $ FIELD_HEADER })
	// [RTC-2026/2027] Validação de linha: evita de/para "morto" (campo inexistente gera erro de macro
	// em DHLIp040Sap:validValues e interrompe a sobrescrita dos tributos IBS/CBS/ICMS).
	Local bLinePost := { | oGrid | vldLinha( oGrid ) }

	oModel := MPFormModel():New(MVC_MODEL_ID, /*bPreValidacao*/, , /*{ | oMdl | CadTabSx5C( oMdl ) }*/ ,, /*bCancel*/ )

	oModel:SetDescription(TITLE_MODEL)
	oModel:addFields(ID_MODEL_FORM,,oStr1Form,,,)
	oModel:AddGrid( ID_MODEL_GRID, ID_MODEL_FORM /*cOwner*/, oStr2Grid, /*bLinePre*/, bLinePost, , )
	oModel:getModel(ID_MODEL_FORM):SetDescription(TITLE_MODEL)
	oModel:SetPrimaryKey({'ZD_FILIAL', 'ZD_TABDE' })

	oModel:SetRelation( ID_MODEL_GRID, { { 'ZD_FILIAL', "xFilial( 'SZD' )" } , { 'ZD_TABDE', 'ZD_TABDE' } } , SZD->( IndexKey( 1 ) ) )

Return oModel


Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr1Form := FWFormStruct( 2, ALIAS_FORM, { | cField |  AllTrim( cField ) + '|' $ FIELD_HEADER })
	Local oStr2Grid := FWFormStruct( 2, ALIAS_FORM, { | cField |  !AllTrim( cField ) + '|' $ FIELD_HEADER })

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField(ID_VIEW_FORM, oStr1Form, ID_MODEL_FORM)
	oView:AddGrid(ID_VIEW_GRID, oStr2Grid, ID_MODEL_GRID)

	oView:CreateHorizontalBox( BOX_FORM, 10)
	oView:CreateHorizontalBox( BOX_GRID, 90)

	oView:SetOwnerView(ID_VIEW_FORM,BOX_FORM)
	oView:SetOwnerView(ID_VIEW_GRID,BOX_GRID)

Return oView


/*/{Protheus.doc} vldLinha
Pós-validação da linha do grid de De/Para (SZD).

[RTC-2026/2027] Garante a comunicação SZA/SZB (IP_040) -> tabelas fiscais:
- campo de origem (ZD_CPODE) e de destino (ZD_CPOPARA) devem existir no SX3;
- tabela destino deve ser uma das tratadas por DHLIp040Sap:validValues().

@type function
@author Wellington Santana
@since 21/11/2026
@param oGrid, object, Submodelo do grid (FWFormGridModel)
@return logical, .T. se a linha é válida
/*/
Static Function vldLinha(oGrid)

	Local lRet		:= .T.
	Local cCpoDe	:= ""
	Local cTabPara	:= ""
	Local cCpoPara	:= ""
	Local cTabDe	:= ""
	Local cTabOk	:= TAB_PARA_OK
	Local oModel	:= FWModelActive()

	If oGrid:IsDeleted()
		Return .T.
	EndIf

	cCpoDe		:= AllTrim(oGrid:GetValue("ZD_CPODE"))
	cTabPara	:= AllTrim(oGrid:GetValue("ZD_TABPARA"))
	cCpoPara	:= AllTrim(oGrid:GetValue("ZD_CPOPARA"))

	// [RTC-2026/2027 - Lote 2 | Wellington Santana 22/11/2026] Tabelas destino permitidas conforme a origem (cabecalho)
	If ValType(oModel) == "O"
		cTabDe := AllTrim(oModel:GetModel(ID_MODEL_FORM):GetValue("ZD_TABDE"))
	EndIf
	If cTabDe == "SZA"
		cTabOk := TAB_PARA_SZA
	ElseIf cTabDe == "SZB"
		cTabOk := TAB_PARA_SZB
	EndIf

	If Empty(GetSx3Cache(cCpoDe, "X3_CAMPO"))
		Help(" ", 1, "CADDEPARA",, "Campo de origem '" + cCpoDe + "' não existe no dicionário (SX3).", 1, 0)
		lRet := .F.
	ElseIf Empty(cTabPara) .or. !(cTabPara + "|" $ cTabOk)
		Help(" ", 1, "CADDEPARA",, "Tabela destino '" + cTabPara + "' não é tratada pela integração IP_040 para a origem " + ;
			cTabDe + ". Permitidas: " + cTabOk, 1, 0)
		lRet := .F.
	ElseIf cTabPara == "CD2" .and. (cCpoDe + "|" $ FIELDS_IBSCBS)
		// [RTC-2026/2027 - Lote 2 | Wellington Santana 22/11/2026] Evita de/para "morto" (ignorado pelo validValues)
		Help(" ", 1, "CADDEPARA",, "IBS/CBS não são gravados na CD2 pelo padrão TOTVS (motor de tributos). " + ;
			"De/para '" + cCpoDe + "' -> CD2 não teria efeito.", 1, 0)
		lRet := .F.
	ElseIf Empty(GetSx3Cache(cCpoPara, "X3_CAMPO"))
		Help(" ", 1, "CADDEPARA",, "Campo de destino '" + cCpoPara + "' não existe no dicionário (SX3).", 1, 0)
		lRet := .F.
	ElseIf PrefixoCpo(cTabPara) + "_" != Left(cCpoPara, Len(PrefixoCpo(cTabPara)) + 1)
		Help(" ", 1, "CADDEPARA",, "Campo de destino '" + cCpoPara + "' não pertence à tabela " + cTabPara + ".", 1, 0)
		lRet := .F.
	EndIf

Return lRet
