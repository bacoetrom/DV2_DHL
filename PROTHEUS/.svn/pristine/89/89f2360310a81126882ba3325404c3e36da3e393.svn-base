#include "totvs.ch"
#include "dhl.ch"
#include "fwmvcdef.ch"

#define MVC_MAIN_ID       "CadLogInt"
#define MVC_MODEL_ID      "mLogInt"
#define MVC_VIEW_ID       "vLogInt"
#define MVC_TITLE         "Cadastro de Log de Integrações"


/*/{Protheus.doc} CadLogInt

Cadastro de Log de Integrações
	
@author Victor Hugo
@since 20/10/2014
/*/
user function CadLogInt()
	
	local oBrowse 	 := FwMbrowse():new()
    private bRefresh := {|| refresh() }
    
    oBrowse:setAlias("SZ2") 
    oBrowse:setDescription(MVC_TITLE)
    
  	oBrowse:addLegend("Z2_CODAPLI == '"+APP_IMPORTADOR_XML+"'", "YELLOW", "Importador XML")
  	oBrowse:addLegend("Z2_CODAPLI == '"+APP_MASTERSAF_DW+"'", "BLUE", "Mastersaf DW")
  	oBrowse:addLegend("Z2_CODAPLI == '"+APP_MASTERSAF_NFE+"'", "GREEN", "Mastersaf NFe")
  	oBrowse:addLegend("Z2_CODAPLI == '"+APP_SELECT+"'", "BLACK", "Select")
  	oBrowse:addLegend("Z2_CODAPLI == '"+APP_NULOGY+"'", "PINK", "Nulogy")
  	oBrowse:addLegend("Z2_CODAPLI == '"+APP_ORACLE_GL+"'", "RED", "Oracle GL")
  	oBrowse:addLegend("Z2_CODAPLI == '"+APP_ORACLE_AR+"'", "BROWN", "Oracle AR")
  	oBrowse:addLegend("Z2_CODAPLI == '"+APP_DLX+"'", "BR_CINZA", "DLX")  
    oBrowse:addLegend("Z2_CODAPLI == '"+APP_SAP+"'", "BR_LARANJA", "SAP")  
    
    oBrowse:activate()
	
return

/**
 * Opções do browse
 */
static function menuDef()
    
    local aOpcoes := {}
    local cViewId := "viewDef."+MVC_MAIN_ID
    
    ADD OPTION aOpcoes TITLE "Pesquisar"   ACTION "PesqBrw" 		OPERATION 1 ACCESS 0
    ADD OPTION aOpcoes TITLE "Refresh"     ACTION "Eval(bRefresh)" 	OPERATION 2 ACCESS 0
    ADD OPTION aOpcoes TITLE "Visualizar"  ACTION cViewId   		OPERATION 2 ACCESS 0
    ADD OPTION aOpcoes TITLE "Imprimir"    ACTION cViewId   		OPERATION 8 ACCESS 0
    
return aOpcoes

/**
 * Modelagem
 */
static function modelDef()
    
    local bValidModel 	:= {|oModel| .T. }    
    local oModel 		:= MpFormModel():new(MVC_MODEL_ID, nil, bValidModel)
    local oSZ2   		:= FwFormStruct(MVC_MODEL_STRUCT, "SZ2")   
    
    oModel:setDescription(MVC_TITLE)
    oModel:addFields("SZ2", nil, oSZ2)
    oModel:getModel("SZ2"):setDescription(MVC_TITLE)     
    oModel:setPrimaryKey({"Z2_FILIAL","Z2_ID"})

return oModel

/**
 * Interface Visual
 */
static function viewDef()

    local oView  := FwFormView():new()
    local oModel := FwLoadModel(MVC_MAIN_ID)
    local oSZ2   := FwFormStruct(MVC_VIEW_STRUCT, "SZ2")
    
    oView:setModel(oModel)
    oView:addField("SZ2", oSZ2, "SZ2")

return oView

/**
 * Atualiza os registros do browse
 */
static function refresh()
	
	local nSvRecno := SZ2->(Recno())
	
	SZ2->(dbGoTop())
	SZ2->(dbGoTo(nSvRecno))
	
	oMainWnd:refresh()	
	
return