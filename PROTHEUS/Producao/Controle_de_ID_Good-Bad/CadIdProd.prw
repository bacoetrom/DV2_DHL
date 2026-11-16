#include "totvs.ch"
#include "dhl.ch"
#include "fwmvcdef.ch"

#define MVC_MAIN_ID       "CadIdProd"
#define MVC_MODEL_ID      "mIdProd"
#define MVC_VIEW_ID       "vIdProd"
#define MVC_TITLE         "Cadastro de IDs de Produtos"


/*/{Protheus.doc} CadIdProd

Cadastro de IDs de Produtos
	
@author Victor Hugo
@since 30/10/2014
/*/
user function CadIdProd()
	
	local oBrowse := FwMbrowse():new()
    
    oBrowse:setAlias("SZ3") 
    oBrowse:setDescription(MVC_TITLE)
    
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
    ADD OPTION aOpcoes TITLE "Relatório"   ACTION "u_RelIds()" OPERATION 8 ACCESS 0
    
return aOpcoes

/**
 * Modelagem
 */
static function modelDef()
    
    local bValidModel 	:= {|oModel| .T. }    
    local oModel 		:= MpFormModel():new(MVC_MODEL_ID, nil, bValidModel)
    local oSZ3   		:= FwFormStruct(MVC_MODEL_STRUCT, "SZ3")
    
    oModel:setDescription(MVC_TITLE)
    oModel:addFields("SZ3", nil, oSZ3)
    oModel:getModel("SZ3"):setDescription(MVC_TITLE)     
    oModel:setPrimaryKey({"Z3_FILIAL","Z3_ID"})

return oModel

/**
 * Interface Visual
 */
static function viewDef()

    local oView  := FwFormView():new()
    local oModel := FwLoadModel(MVC_MAIN_ID)
    local oSZ3   := FwFormStruct(MVC_VIEW_STRUCT, "SZ3")
    
    //oSZ3:SetProperty( '*' , MVC_VIEW_CANCHANGE , .f.)
    oSZ3:SetProperty( 'Z3_STATUS' , MVC_VIEW_CANCHANGE , .t.)
    
    oView:setModel(oModel)
    oView:addField("SZ3", oSZ3, "SZ3")

return oView