#Include 'Protheus.ch'
#include "dhl.ch"
#include "fwmvcdef.ch"

#define MVC_MAIN_ID       "CadEnqIpi"
#define MVC_MODEL_ID      "mIdProd"
#define MVC_VIEW_ID       "vIdProd"
#define MVC_TITLE         "Cadastro de Enquadramento Legal do IPI"

/*/{Protheus.doc} CadEnqIpi
Cadastro de Enquadramento Legal do IPI
@author Thiago Meschiatti
@since 23/10/2015
@version 1.0
/*/
User Function CadEnqIpi()
	
	local oBrowse := FwMbrowse():new()
    
    oBrowse:setAlias("SZ6") 
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
    ADD OPTION aOpcoes TITLE "Excluir"     ACTION cViewId      OPERATION 5 ACCESS 0        
    
return aOpcoes

/**
 * Modelagem
 */
static function modelDef()
    
    local bValidModel 	:= {|oModel| .T. }    
    local oModel 		:= MpFormModel():new(MVC_MODEL_ID, nil, bValidModel)
    local oSZ6   		:= FwFormStruct(MVC_MODEL_STRUCT, "SZ6")
    
    oModel:setDescription(MVC_TITLE)
    oModel:addFields("SZ6", nil, oSZ6)
    oModel:getModel("SZ6"):setDescription(MVC_TITLE)     
    oModel:setPrimaryKey({"Z6_FILIAL","Z6_COD"})

return oModel

/**
 * Interface Visual
 */
static function viewDef()

    local oView  := FwFormView():new()
    local oModel := FwLoadModel(MVC_MAIN_ID)
    local oSZ6   := FwFormStruct(MVC_VIEW_STRUCT, "SZ6")
    
    oView:setModel(oModel)
    oView:addField("SZ6", oSZ6, "SZ6")

return oView