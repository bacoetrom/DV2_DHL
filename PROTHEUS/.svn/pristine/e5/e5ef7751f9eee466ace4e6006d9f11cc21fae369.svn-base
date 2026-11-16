#include "totvs.ch"
#include "dhl.ch"

/*/{Protheus.doc} IPNFESETSB1
Ponto de entrada executado dentro do método loadInfo(), usado para manipular informações do produto.
@type user function
@author TOTVS IP
@since 29/07/2025
@version version
@param PARAMIXB, array, parâmetros do ponto de entrada onde a função está sendo chamada
@return aRet, array, array de duas posições, com o código do produto e a unidade de medida
@example
(examples)
@see (links_or_references)
/*/
User Function IPNFESETSB1()

    local aArea     := GetArea()
    local aAreaLj7  := Lj7GetArea({"SB1","SB5","SYD","SA5","SA7","SA1","SA2"})
    local cFornece  := PARAMIXB[1] // Código do fornecedor
    local cLoja     := PARAMIXB[2] // Loja do fornecedor
    local cProduto  := PARAMIXB[3] // Código do produto obtido da tag <cProd>
    local oDet      := PARAMIXB[4] // Objeto do item que está sendo carregado
    local cProdSB1  := PARAMIXB[5] // Código do produto Protheus
    local cUm       := PARAMIXB[6] // Unidade de medida do produto Protheus
    local CPROD     := ""
	local XPROD     := ""
	local UTRIB     := ""
	local NCM       := ""
    local CEAN      := ""
    local ORIG      := ""
    local CST       := ""
    local aErro     := ""
    local cMensagem := ""
    local cCodSB1   := ""
    local cTipo     := SuperGetMV("ZZ_TIPPROD",.f.,"OU")
    local aRet      := {cProdSB1,cUm}

    local oMdlMATA010   as object
    local oMdlSB1Master as object
    local oMdlSB5Detail as object
    local oMdlMATA061   as object
    local oMdlMATA370   as object
	
    private lMsHelpAuto 	:= .t.  // Determina se as mensagens de help devem ser direcionadas para o arq. de log
	private lMsErroAuto 	:= .f.  // Determina se houve alguma inconsistencia na execução da rotina
	private lAutoErrNoFile	:= .t.	// Habilita a gravação de erro da rotina automática
	
    if FWUnitBusiness() == DHL_BUSINESSUNIT_DI2
        
        XPROD := upper(subString(oDet:_Prod:_XPROD:Text,1,getSX3Cache("B1_DESC","X3_TAMANHO")))
        cCodSB1 := upper(getCodigoHash(XPROD))
        
        dbSelectArea("SB1")
        SB1->(dbSetOrder(1)) //B1_FILIAL+B1_COD
        if !SB1->(dbSeek(xFilial("SB1")+padr(cCodSB1,tamSX3("B1_COD")[1])))
        
            CPROD := allTrim(subString(oDet:_Prod:_CPROD:Text,1,getSX3Cache("B1_COD","X3_TAMANHO")))
            UTRIB := upper(subString(oDet:_Prod:_UTRIB:Text,1,getSX3Cache("B1_UM","X3_TAMANHO")))
            NCM   := subString(oDet:_Prod:_NCM:Text,1,getSX3Cache("B1_POSIPI","X3_TAMANHO"))
            CEAN  := allTrim(subString(oDet:_Prod:_CEAN:Text,1,getSX3Cache("B1_CODGTIN","X3_TAMANHO")))

            if AttIsMemberOf(oDet:_imposto,"_ICMS")
                if AttIsMemberOf(oDet:_imposto:_ICMS,"_ICMS00") // Tributada integralmente
                    ORIG := oDet:_imposto:_ICMS:_ICMS00:_ORIG:Text
                    CST  := oDet:_imposto:_ICMS:_ICMS00:_CST:Text
                elseIf AttIsMemberOf(oDet:_imposto:_ICMS,"_ICMS10") // Tributada e com cobrança do ICMS por substituição tributária 
                    ORIG := oDet:_imposto:_ICMS:_ICMS10:_ORIG:Text
                    CST  := oDet:_imposto:_ICMS:_ICMS10:_CST:Text
                elseIf AttIsMemberOf(oDet:_imposto:_ICMS,"_ICMS20") // Com redução de base de cálculo
                    ORIG := oDet:_imposto:_ICMS:_ICMS20:_ORIG:Text
                    CST  := oDet:_imposto:_ICMS:_ICMS20:_CST:Text
                elseIf AttIsMemberOf(oDet:_imposto:_ICMS,"_ICMS30") // Isenta ou não tributada com cobrança do ICMS por substituição tributária
                    ORIG := oDet:_imposto:_ICMS:_ICMS30:_ORIG:Text
                    CST  := oDet:_imposto:_ICMS:_ICMS30:_CST:Text
                elseIf AttIsMemberOf(oDet:_imposto:_ICMS,"_ICMS40") // Isenta
                    ORIG := oDet:_imposto:_ICMS:_ICMS40:_ORIG:Text
                    CST  := oDet:_imposto:_ICMS:_ICMS40:_CST:Text
                elseIf AttIsMemberOf(oDet:_imposto:_ICMS,"_ICMS41") // Não tributada
                    ORIG := oDet:_imposto:_ICMS:_ICMS41:_ORIG:Text
                    CST  := oDet:_imposto:_ICMS:_ICMS41:_CST:Text
                elseIf AttIsMemberOf(oDet:_imposto:_ICMS,"_ICMS50") // Suspensão
                    ORIG := oDet:_imposto:_ICMS:_ICMS50:_ORIG:Text
                    CST  := oDet:_imposto:_ICMS:_ICMS50:_CST:Text
                elseIf AttIsMemberOf(oDet:_imposto:_ICMS,"_ICMS51") // Diferimento
                    ORIG := oDet:_imposto:_ICMS:_ICMS51:_ORIG:Text
                    CST  := oDet:_imposto:_ICMS:_ICMS51:_CST:Text
                elseIf AttIsMemberOf(oDet:_imposto:_ICMS,"_ICMS60") // ICMS cobrado anteriormente por substituição tributária 
                    ORIG := oDet:_imposto:_ICMS:_ICMS60:_ORIG:Text
                    CST  := oDet:_imposto:_ICMS:_ICMS60:_CST:Text
                elseIf AttIsMemberOf(oDet:_imposto:_ICMS,"_ICMS70") // Com redução de base de cálculo e cobrança do ICMS por substituição tributária 
                    ORIG := oDet:_imposto:_ICMS:_ICMS70:_ORIG:Text
                    CST  := oDet:_imposto:_ICMS:_ICMS70:_CST:Text
                elseIf AttIsMemberOf(oDet:_imposto:_ICMS,"_ICMS90") // Outros
                    ORIG := oDet:_imposto:_ICMS:_ICMS90:_ORIG:Text
                    CST  := oDet:_imposto:_ICMS:_ICMS90:_CST:Text
                endIf
            endIf                
            
            if !isNumeric(CEAN)
                CEAN := ""
            endIf

            begin transaction

                if posicione("SYD",1,xFilial("SYD")+NCM,"Eof()")
                    if RecLock("SYD",.T.)
                        SYD->YD_FILIAL := xFilial("SYD")
                        SYD->YD_TEC    := NCM
                        SYD->YD_DESC_P := "NCM GRAVADO PELO IMPORTADOR XML"
                        SYD->(msUnlock())
                    else
                        DisarmTransaction()
                        Break
                    endIf
                endIf

                dbSelectArea("SB1")

                oMdlMATA010 := FWLoadModel("MATA010")
                oMdlMATA010:SetOperation(3)
                oMdlMATA010:Activate()
                oMdlSB1Master := oMdlMATA010:GetModel("SB1MASTER")
                oMdlSB1Master:SetValue("B1_COD" 	, cCodSB1 )
                oMdlSB1Master:SetValue("B1_DESC" 	, XPROD )
                oMdlSB1Master:SetValue("B1_TIPO" 	, cTipo )
                oMdlSB1Master:SetValue("B1_POSIPI"  , NCM   )
                if !empty(CEAN)
                    oMdlSB1Master:SetValue("B1_CODGTIN", CEAN)
                endif
                oMdlSB1Master:SetValue("B1_ORIGEM"  , ORIG  )
                oMdlSB1Master:SetValue("B1_CLASFIS" , CST   )
                oMdlSB1Master:SetValue("B1_UM"      , UTRIB )
                                
                oMdlSB5Detail := oMdlMATA010:GetModel("SB5DETAIL")
                if oMdlSB5Detail != Nil
                    oMdlSB5Detail:SetValue("B5_CEME"   , XPROD )
                endIf
        
                if !oMdlMATA010:VldData() .or. !oMdlMATA010:CommitData()
                    aErro := oMdlMATA010:GetErrorMessage()
                    cMensagem := "CODIGO PRODUTO:"  + ' [' + cCodSB1 + '], ' + Chr(13) + Chr(10)
                    cMensagem += "Id do campo de erro: "        + ' [' + cValToChar(aErro[04]) + '], ' + Chr(13) + Chr(10)			     
                    cMensagem += "Mensagem do erro: "           + ' [' + cValToChar(aErro[06]) + '], ' + Chr(13) + Chr(10)
                    cMensagem += "Mensagem da solucao: "        + ' [' + cValToChar(aErro[07]) + '], ' + Chr(13) + Chr(10)
                    AutoGrLog(cMensagem)
                    DisarmTransaction()
                    Break
                else
                    aRet := {SB1->B1_COD,SB1->B1_UM}
                endIf
        
                oMdlMATA010:DeActivate()
                oMdlMATA010:Destroy()
                
                if lFornece // Amarração Produto x Fornecedor
                    dbSelectArea("SA5")
                    SA5->(dbSetOrder(14)) //A5_FILIAL+A5_FORNECE+A5_LOJA+A5_CODPRF
                    if !SA5->(dbSeek(xFilial("SA5")+padr(cFornece,tamSX3("A5_FORNECE")[1])+padr(cLoja,tamSX3("A5_LOJA")[1])+padr(cProduto,tamSX3("A5_CODPRF")[1])))
                        
                        lMsErroAuto	:= .f.
                
                        dbSelectArea("SA2")
                        SA2->(dbSetOrder(1))	
                        SA2->(dbSeek(xFilial("SA2")+padr(cFornece,tamSX3("A2_COD")[1])+padr(cLoja,tamSX3("A2_LOJA")[1])))
                
                        oMdlMATA061 := FWLoadModel('MATA061')
                        oMdlMATA061:SetOperation(3)
                        oMdlMATA061:Activate()
                        //Cabecalho
                        oMdlMATA061:SetValue('MdFieldSA5','A5_PRODUTO', SB1->B1_COD)
                        //Grid
                        oMdlMATA061:SetValue('MdGridSA5','A5_FORNECE',	cFornece)
                        oMdlMATA061:SetValue('MdGridSA5','A5_LOJA' ,	cLoja   )
                        oMdlMATA061:SetValue('MdGridSA5','A5_CODPRF' ,	cProduto)
                        if !oMdlMATA061:VldData() .or. !oMdlMATA061:CommitData()
                            aErro := oMdlMATA061:GetErrorMessage()
                            cMensagem := "CODIGO PRODUTO FORNECEDOR: "  + ' [' + cProduto + '], ' + Chr(13) + Chr(10)
                            cMensagem += "CODIGO PRODUTO PROTHEUS: "    + ' [' + SB1->B1_COD + '], ' + Chr(13) + Chr(10)
                            cMensagem += "Id do campo de erro: "        + ' [' + cValToChar(aErro[04]) + '], ' + Chr(13) + Chr(10)			    
                            cMensagem += "Mensagem do erro: "           + ' [' + cValToChar(aErro[06]) + '], ' + Chr(13) + Chr(10)
                            cMensagem += "Mensagem da solucao: "        + ' [' + cValToChar(aErro[07]) + '], ' + Chr(13) + Chr(10)
                            AutoGrLog(cMensagem)
                            DisarmTransaction()
                            Break
                        endIf
                        oMdlMATA061:DeActivate()
                        oMdlMATA061:Destroy()

                    endIf
                else // Amarração Produto x Cliente
                    dbSelectArea("SA7")
                    SA7->(dbSetOrder(1)) //A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
                    If !SA7->(dbSeek(xFilial("SA7")+padr(cFornece,tamSX3("A7_CLIENTE")[1])+padr(cLoja,tamSX3("A7_LOJA")[1])+SB1->B1_COD))
                        
                        lMsErroAuto	:= .f.
                        
                        dbSelectArea("SA1")
                        SA1->(dbSetOrder(1))	
                        SA1->(dbSeek(xFilial("SA1")+padr(cFornece,tamSX3("A1_COD")[1])+padr(cLoja,tamSX3("A1_LOJA")[1])))
                
                        oMdlMATA370 := FWLoadModel('MATA370')
                        oMdlMATA370:SetOperation(3)
                        oMdlMATA370:Activate()

                        //Cabecalho
                        oMdlMATA370:SetValue('SA7MASTER','A7_PRODUTO',SB1->B1_COD)
                        //Grid
                        oMdlMATA370:SetValue('SA7MASTER','A7_CLIENTE',	cFornece)
                        oMdlMATA370:SetValue('SA7MASTER','A7_LOJA' ,	cLoja)
                        oMdlMATA370:SetValue('SA7MASTER','A7_CODCLI' ,	cProduto)
                        if !oMdlMATA370:VldData() .or. !oMdlMATA370:CommitData()
                            aErro := oMdlMATA370:GetErrorMessage()
                            cMensagem := "CODIGO PRODUTO CLIENTE: "     + ' [' + cProduto + '], ' + Chr(13) + Chr(10)
                            cMensagem += "CODIGO PRODUTO PROTHEUS: "    + ' [' + SB1->B1_COD + '], ' + Chr(13) + Chr(10)
                            cMensagem += "Id do campo de erro: "        + ' [' + cValToChar(aErro[04]) + '], ' + Chr(13) + Chr(10)			    
                            cMensagem += "Mensagem do erro: "           + ' [' + cValToChar(aErro[06]) + '], ' + Chr(13) + Chr(10)
                            cMensagem += "Mensagem da solucao: "        + ' [' + cValToChar(aErro[07]) + '], ' + Chr(13) + Chr(10)
                            AutoGrLog(cMensagem)
                            DisarmTransaction()
                            Break
                        endIf
                        
                        oMdlMATA370:DeActivate()
                        oMdlMATA370:Destroy()
                    endIf
                endIf

            end transaction
        else
            aRet := {SB1->B1_COD,SB1->B1_UM}
        endIf        
    endIf

    Lj7RestArea(aAreaLj7)
    RestArea(aArea)

Return aRet

/**
* getCodigoHash
**/
Static Function getCodigoHash(cTexto)
 
    local nIni := At("#", cTexto)
    local nFim := At("#", cTexto, nIni + 1)
    local cRet := ""
 
    if nIni > 0 .and. nFim > nIni
        cRet := SubStr(cTexto, nIni + 1, nFim - nIni - 1)
    endIf
 
Return cRet
