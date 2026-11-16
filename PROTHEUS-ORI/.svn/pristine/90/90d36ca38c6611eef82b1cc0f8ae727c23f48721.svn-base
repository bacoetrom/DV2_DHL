/*Importar as bibliotecas*/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

#Define MVC_MAIN_ID       "CadDePara"
#Define MVC_MODEL_ID      "MIDREGFI"
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

/*Iniciando sua função*/
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
	
	oModel := MPFormModel():New(MVC_MODEL_ID, /*bPreValidacao*/, , /*{ | oMdl | CadTabSx5C( oMdl ) }*/ ,, /*bCancel*/ )

	oModel:SetDescription(TITLE_MODEL)
	oModel:addFields(ID_MODEL_FORM,,oStr1Form,,,)
	oModel:AddGrid( ID_MODEL_GRID, ID_MODEL_FORM /*cOwner*/, oStr2Grid, /*bLinePre*/, , )
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

