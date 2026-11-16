#Include 'Protheus.ch'
#include "dhl.ch"
#include "fwmvcdef.ch"

#Define MVC_MAIN_ID       "CadRegFis"
#Define MVC_MODEL_ID      "MIDREGFI"
#Define TITLE_MODEL       "Cadastro de Regras Fiscais"
#Define TITLE_VIEW        TITLE_MODEL
#Define ALIAS_FORM		  "SZC"
#Define ID_MODEL_FORM	  ALIAS_FORM + "FORM"
#Define ID_VIEW_FORM	  "VIEW_FORM"


/*/{Protheus.doc} CadRegFis
Cadastro de Regras Fiscais
Fonte utlizado para determinar TES aproximada para o faturamento da NF RCO

@author Thiago Meschiatti
@since 18/05/2017
@version undefined

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
    
    local bValidModel 	:= {|oModel| .T. }    
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