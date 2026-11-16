#include "totvs.ch"
#include "dhl.ch"


/*/{Protheus.doc} DHLIdTest

Teste do Controle de IDs de Produtos
	
@author Victor Hugo
@since 05/11/2014
/*/
user function DHLIdTest()
	
	private cTabBrw 	:= "SF2"
	private bExecTest	:= { || execTest() }
	private aRotina 	:= MenuDef()
    
    dbSelectArea(cTabBrw)
	dbSetOrder(1)
	mBrowse(nil, nil, nil, nil, cTabBrw)
	
	(cTabBrw)->(dbCloseArea())
	
return

/**
 * Opções do browse
 */
static function menuDef()
    
    local aOpcoes 	:= {{"Pesquisar","AxPesqui",0,1},;
             			{"Visualizar","AxVisual",0,2},;             		
             			{"Gerar IDs","Eval(bExecTest)",0,2}}
       
return aOpcoes

/**
 * Executa o teste
 */
static function execTest()
	
	local bGeraIds   := {||}
	local oIdManager := DHLIdManager():newDHLIdManager()
	
	if (cTabBrw == "SF1")
		bGeraIds := {|| oIdManager:inflowInvoice(DHL_INCLUSAO) }
	elseIf (cTabBrw == "SF2")
		bGeraIds := {|| oIdManager:outflowInvoice(DHL_INCLUSAO) }
	endIf
	
	if ApMsgYesNo("Confirma geração de IDs para o Doc. posicionado ?")
		MsAguarde(bGeraIds, "Aguarde", "Gerando IDs ...")
		ApMsgInfo("IDs gerados com sucesso!") 
	endIf
	
return