#include "totvs.ch"
#include "dhl.ch"


/*/{Protheus.doc} TestMsaNfe

Teste de Geração dos Arquivos do Mastersaf NFe
	
@author Victor Hugo
@since 05/11/2014
/*/
user function TestMsaNfe()
	
	private cTabBrw 	:= "SF1"
	private bExecTest	:= { || u_MS520VLD() }
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
	
	local bGeraArqs := {||}
	
	if (cTabBrw == "SF1")
		bGeraArqs := {|| u_A100DEL() }
	elseIf (cTabBrw == "SF2")
		bGerArqs := {|| U_MS520VLD() }
	endIf
	
	if ApMsgYesNo("Confirma geração de Arquivos para o Mastersaf NFe referente ao Doc. posicionado ?")
		MsAguarde(bGeraArqs, "Aguarde", "Gerando Arquivos ...")
		ApMsgInfo("Arquivos gerados com sucesso!") 
	endIf
	
return