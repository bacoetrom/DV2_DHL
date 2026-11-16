#Include 'Protheus.ch'
#Include 'DHL.CH'

/*/{Protheus.doc} MA270TOK

O ponto de entrada 'MA270TOK' é executado no final da função TUDOOK(), permitido validar os dados informados pelo usuário, quando executado o botão de confirmação.
Eventos
	
@author Gustavo Luiz
@since 26/12/2018

/*/
User Function MA270TOK()
	
	local lRet 			:= .T.
	local cContasPar 	:= GetNewPar("ZZ_CONTBLK", "") //CONTAS DE ITENS PROPRIOS
	local cProdutoB7	:= M->B7_COD
	local cContaB1		:= ""
	
	if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS .or. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL .or. FWUnitBusiness() == DHL_BUSINESSUNIT_PKG
		
		cContaB1 := getContaB1(cProdutoB7)
		
		//SE A CONTA FOR RELACIONADO A PRODUTO PROPRIO, NÃO ENTRA NA VALIDAÇÃO
		if !cContaB1 $ cContasPar
		
			if empty(M->B7_ZZCDPRO) .and. empty(M->B7_ZZLJPRO)
				MsgInfo("Preenchimento obrigatório dos campos Cliente e Loja","")
				lRet := .F.
			elseIf empty(M->B7_ZZCDPRO)
				MsgInfo("Preenchimento obrigatório do campo Cliente","")
				lRet := .F.
			elseIf empty(M->B7_ZZLJPRO)
				MsgInfo("Preenchimento obrigatório do campo Loja","")
				lRet := .F.
			endIf
				
		endIf
	
	endIf
	
Return lRet

/** 
* Obtém a conta do produto SB1
**/
static function getContaB1(cProdutoB7)
	
	local cContaB1 := ""
	local aArea    := getArea()
	local aAreaSB1 := SB1->(getArea())
	local cChaveB1 := fwxFilial("SB1") + cProdutoB7
	
	SB1->(dbSetOrder(1))
	
	if SB1->(dbSeek(cChaveB1))
		
		cContaB1 := allTrim(SB1->B1_CONTA)
		
	endIf
	
	restArea(aAreaSB1)
	restArea(aArea)
	
return cContaB1

