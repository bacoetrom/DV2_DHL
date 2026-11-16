#include "totvs.ch"
#include "dhl.ch"
#include "fwmvcdef.ch"

#define MVC_MAIN_ID       "CadAplic"
#define MVC_MODEL_ID      "mAplic"
#define MVC_VIEW_ID       "vAplic"
#define MVC_TITLE         "Cadastro de Aplicações para Integrações"


/*/{Protheus.doc} CfgAplic

Cadastro de Aplicações para Integrações
	
@author Victor Hugo
@since 20/10/2014
/*/
user function CfgAplic()
	
	local oBrowse := FwMbrowse():new()
    
    oBrowse:setAlias("SZ1") 
    oBrowse:setDescription(MVC_TITLE)
    
    oBrowse:activate()
	
return

/**
 * Opções do browse
 */
static function menuDef()
    
    local aOpcoes := {}
    local cViewId := "viewDef."+MVC_MAIN_ID
    
    ADD OPTION aOpcoes TITLE "Pesquisar"   ACTION "PesqBrw" OPERATION 1 ACCESS 0
    ADD OPTION aOpcoes TITLE "Visualizar"  ACTION cViewId   OPERATION 2 ACCESS 0
    ADD OPTION aOpcoes TITLE "Incluir"     ACTION cViewId   OPERATION 3 ACCESS 0
    ADD OPTION aOpcoes TITLE "Alterar"     ACTION cViewId   OPERATION 4 ACCESS 0
    ADD OPTION aOpcoes TITLE "Excluir"     ACTION cViewId   OPERATION 5 ACCESS 0
    ADD OPTION aOpcoes TITLE "Imprimir"    ACTION cViewId   OPERATION 8 ACCESS 0
    
return aOpcoes

/**
 * Modelagem
 */
static function modelDef()
    
    local bValidModel 	:= {|oModel| .T. }    
    local oModel 		:= MpFormModel():new(MVC_MODEL_ID, nil, bValidModel)
    local oSZ1   		:= FwFormStruct(MVC_MODEL_STRUCT, "SZ1")   
    
    oModel:setDescription(MVC_TITLE)
    oModel:addFields("SZ1", nil, oSZ1)
    oModel:getModel("SZ1"):setDescription(MVC_TITLE)     
    oModel:setPrimaryKey({"Z1_FILIAL","Z1_CODIGO"})

return oModel

/**
 * Interface Visual
 */
static function viewDef()

    local oView  := FwFormView():new()
    local oModel := FwLoadModel(MVC_MAIN_ID)
    local oSZ1   := FwFormStruct(MVC_VIEW_STRUCT, "SZ1")
    
    oView:setModel(oModel)
    oView:addField("SZ1", oSZ1, "SZ1")

return oView