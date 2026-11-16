#include 'totvs.ch' 
#include 'dhl.ch'
#define AUTORIZADA					"S"
#define DEVOLUCAO					"D"

/*/{Protheus.doc} DhlMulMod3
Classe auxiliar para o modelo 3
@type class
@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
CLASS DhlMulMod3
	
	Data nVlrKIT
	Data nVlrTotInsumoDHL
	Data nVlrTot
	Data cPV1
	Data cPV2
	Data nRecnoPV1
	Data nRecnoPV2
	Data lErro
	Data cMsgErro
	Data cDocPV1
	Data cDocPV2
	Data cSerPV1
	Data cSerPV2
	Data cLojPV1
	Data cLojPV2
	Data cCliPV1
	Data cCliPV2
	Data cDtePV1
	Data cDtePV2
	Data cTpPV1
	Data cTpPV2
	Data lTesRede
	Data aArea
	Data aAreaSF2
	Data aAreaSD2
	Data lCanInvConf
	Data cZZTpNf
	Data nRecnoNF1
	Data nRecnoNF2
	Data cRefNf
	Data cRefSerie
	Data cRefData
	Data cFImp
	Data lExistNFRef
	Data cFimpRef
	Data lTESTransferencia
	
	Method GetVlrKIT()
	Method SetVlrKIT()
	
	Method GetVlrTotInsumoDHL()
	Method SetVlrTotInsumoDHL()
	
	Method GetVlrTot()
	Method SetVlrTot()
	
	Method GetPV1()
	Method SetPV1()
	
	Method GetPV2()
	Method SetPV2()
	
	Method GetDocPV1()
	Method SetDocPV1()
	
	Method GetDocPV2()
	Method SetDocPV2()
	
	Method GetSerPV1()
	Method SetSerPV1()
	
	Method GetSerPV2()
	Method SetSerPV2()
	
	Method GetCliPV1()
	Method SetCliPV1()
	
	Method GetLojPV1()
	Method SetLojPV1()
	
	Method GetCliPV2()
	Method SetCliPV2()
	
	Method GetLojPV2()
	Method SetLojPV2()
	
	Method GetDtePV1()
	Method SetDtePV1()
	
	Method GetDtePV2()
	Method SetDtePV2()
	
	Method GetTpPV1()
	Method SetTpPV1()
	
	Method GetTpPV2()
	Method SetTpPV2()
	
	Method GetRecnPV1()
	Method SetRecnPV1()
	
	Method GetRecnPV2()
	Method SetRecnPV2()
	
	Method GetRecnNF1()
	Method SetRecnNF1()
	
	Method GetRecnNF2()
	Method SetRecnNF2()
	
	Method GetZZTpNf()
	Method SetZZTpNf()
	
	Method SetErro()
	Method HasErro()
	
	Method getMsgErro()
	Method setMsgErro()
	
	Method IsTesRede()
	Method SetTesRede()
	
	Method GetRefNf()
	Method SetRefNf()
	
	Method GetRefSerie()
	Method SetRefSerie()
	
	Method GetRefData()
	Method SetRefData()
	
	Method GetFimpRef()
	Method SetFimpRef()
	
	Method GetFImp()
	Method SetFImp()
	
	Method IsTesTransferencia()
	Method SetTesTransferencia()
	
	Method ExistNFRef()
	
	Method GravaSC5Amarracao()
	Method GravaSF2Amarracao()
	Method ValidFaturamento()
	Method GetZZMsgIN()
	Method GetInfAdicional()
	Method PosicNF1()
	Method RetornaAreas()
	Method ArmazenArea()
	Method CanCreateInvConf()
	Method GetDadoNF()
	Method GetDadoNFReferenc()
	Method GerNF2Issue()
	Method VerifItNF1()
	Method SendEmail()
	Method GetRecnosNF()
	Method IsNF1Ativo()
	Method ExcluirNF2()
	Method GerNF2Cancelation()
	Method Posiciona()
	Method PosicNotaAtual()
	Method IsNfRefAutorizada()
	Method GravaAmarRetornToKit()
	Method IsAmarrSC5(cNota, cSerie, cCliFor, cLoja)
	
	
	METHOD NewDhlMulMod3() CONSTRUCTOR
	
ENDCLASS

/*/{Protheus.doc} NewDhlMulMod3
Método Construtor

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
METHOD NewDhlMulMod3() CLASS DhlMulMod3
	
	::nVlrKIT 			:= 0
	::nVlrTotInsumoDHL	:= 0
	::nVlrTot			:= 0
	::cPV1				:= ""
	::cPV2				:= ""
	::nRecnoPV1			:= 0
	::nRecnoPV2			:= 0
	::lErro				:= .F.
	::cMsgErro			:= ""
	::cDocPV1			:= ""
	::cDocPV2			:= ""
	::cSerPV1			:= ""
	::cSerPV2			:= ""
	::cLojPV1 			:= ""
	::cLojPV2 			:= ""
	::cCliPV1 			:= ""
	::cCliPV2 			:= ""
	::cDtePV1			:= ""
	::cDtePV2			:= ""
	::cTpPV1			:= ""
	::cTpPV2			:= ""
	::lTesRede			:= .F.
	::aArea				:= {}
	::aAreaSF2			:= {}
	::aAreaSD2			:= {}
	::lCanInvConf		:= .F.
	::cZZTpNf			:= ""
	::nRecnoNF1			:= 0
	::nRecnoNF2			:= 0
	::cRefNf			:= ""
	::cRefSerie			:= ""
	::cRefData			:= ""
	::cFImp				:= ""
	::lExistNFRef		:= .F.
	::cFimpRef			:= ""
	::lTESTransferencia := .F.
	
	
Return

/*/{Protheus.doc} GetVlrKIT
Obtém o valor total do KIT

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetVlrKIT() Class DhlMulMod3
	
return ::nVlrKIT

/*/{Protheus.doc} SetVlrKIT
Define o valor total do KIT

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetVlrKIT(nVlrKIT) Class DhlMulMod3
	::nVlrKIT := nVlrKIT
return

/*/{Protheus.doc} GetVlrTotInsumoDHL
Obtém o valor total do insumo DHL

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetVlrTotInsumoDHL() Class DhlMulMod3
	
return ::nVlrTotInsumoDHL

/*/{Protheus.doc} SetVlrTotInsumoDHL
Define o valor total do insumo DHL

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetVlrTotInsumoDHL(nVlrTotInsumoDHL) Class DhlMulMod3
	::nVlrTotInsumoDHL := nVlrTotInsumoDHL
return

/*/{Protheus.doc} GetVlrTot
Obtém o valor total

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetVlrTot() Class DhlMulMod3
	
return ::nVlrTot

/*/{Protheus.doc} SetVlrTot
Define o valor total

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetVlrTot(nVlrTot) Class DhlMulMod3
	::nVlrTot := nVlrTot
return


/*/{Protheus.doc} GetPV1
Obtém o número do pedido de vendas PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetPV1() Class DhlMulMod3
	
return ::cPV1

/*/{Protheus.doc} SetPV1
Define o número do pedido de vendas PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetPV1(cPV1) Class DhlMulMod3
	::cPV1 := cPV1
return

/*/{Protheus.doc} GetPV2
Obtém o número do pedido de vendas PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetPV2() Class DhlMulMod3
	
return ::cPV2

/*/{Protheus.doc} SetPV2
Define o número do pedido de vendas PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetPV2(cPV2) Class DhlMulMod3
	::cPV2 := cPV2
return


/*/{Protheus.doc} GetDocPV1
Obtém o documento de saída gravado no pedido 1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetDocPV1() Class DhlMulMod3
	
return ::cDocPV1

/*/{Protheus.doc} SetDocPV1
Define o documento de saída gravado no pedido 1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetDocPV1(cDocPV1) Class DhlMulMod3
	::cDocPV1 := cDocPV1
return


/*/{Protheus.doc} GetDocPV2
Obtém o documento de saída gravado no pedido 2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetDocPV2() Class DhlMulMod3
	
return ::cDocPV2

/*/{Protheus.doc} SetDocPV2
Define o documento de saída gravado no pedido 2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetDocPV2(cDocPV2) Class DhlMulMod3
	::cDocPV2 := cDocPV2
return

/*/{Protheus.doc} GetSerPV1
Obtém a séria gravado no pedido de vendas PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetSerPV1() Class DhlMulMod3
	
return ::cSerPV1

/*/{Protheus.doc} SetSerPV1
Define a séria gravado no pedido de vendas PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetSerPV1(cSerPV1) Class DhlMulMod3
	::cSerPV1 := cSerPV1
return

/*/{Protheus.doc} GetSerPV2
Obtém a séria gravado no pedido de vendas PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetSerPV2() Class DhlMulMod3
	
return ::cSerPV2

/*/{Protheus.doc} SetSerPV2
Define a séria gravado no pedido de vendas PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetSerPV2(cSerPV2) Class DhlMulMod3
	::cSerPV2 := cSerPV2
return

/*/{Protheus.doc} GetCliPV1
Obtém o cliente gravado no pedido de vendas PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetCliPV1() Class DhlMulMod3
	
return ::cCliPV1

/*/{Protheus.doc} SetCliPV1
Define o cliente gravado no pedido de vendas PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetCliPV1(cCliPV1) Class DhlMulMod3
	::cCliPV1 := cCliPV1
return

/*/{Protheus.doc} GetCliPV2
Obtém o cliente gravado no pedido de vendas PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetCliPV2() Class DhlMulMod3
	
return ::cCliPV2

/*/{Protheus.doc} SetCliPV2
Define o cliente gravado no pedido de vendas PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetCliPV2(cCliPV2) Class DhlMulMod3
	::cCliPV2 := cCliPV2
return

/*/{Protheus.doc} GetLojPV1
Obtém a loja gravado no pedido de vendas PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetLojPV1() Class DhlMulMod3
	
return ::cLojPV1

/*/{Protheus.doc} SetLojPV1
Define a loja gravado no pedido de vendas PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetLojPV1(cLojPV1) Class DhlMulMod3
	::cLojPV1 := cLojPV1
return

/*/{Protheus.doc} GetLojPV1
Obtém a loja gravado no pedido de vendas PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetLojPV2() Class DhlMulMod3
	
return ::cLojPV2

/*/{Protheus.doc} SetLojPV2
Define a loja gravado no pedido de vendas PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetLojPV2(cLojPV2) Class DhlMulMod3
	::cLojPV2 := cLojPV2
return


/*/{Protheus.doc} GetDtePV1
Obtém a data de emissão gravado na SF2 referente ao PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetDtePV1() Class DhlMulMod3
	
return ::cDtePV1

/*/{Protheus.doc} SetDtePV1
Define a data de emissão gravado na SF2 referente ao PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetDtePV1(cDtePV1) Class DhlMulMod3
	::cDtePV1 := cDtePV1
return

/*/{Protheus.doc} GetDtePV2
Obtém a data de emissão gravado na SF2 referente ao PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetDtePV2() Class DhlMulMod3
	
return ::cDtePV2

/*/{Protheus.doc} SetDtePV2
Define a data de emissão gravado na SF2 referente ao PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetDtePV2(cDtePV2) Class DhlMulMod3
	::cDtePV2 := cDtePV2
return

/*/{Protheus.doc} GetTpPV1
Obtém o tipo de venda PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetTpPV1() Class  DhlMulMod3
	
return ::cTpPV1

/*/{Protheus.doc} SetTpPV1
Define o tipo de venda PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetTpPV1(cTpPV1) Class  DhlMulMod3
	::cTpPV1 := cTpPV1
return

/*/{Protheus.doc} GetTpPV
Obtém o tipo de venda PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetTpPV2() Class  DhlMulMod3
	
return ::cTpPV2

/*/{Protheus.doc} SetTpPV2
Define o tipo de venda PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetTpPV2(cTpPV2) Class  DhlMulMod3
	::cTpPV2 := cTpPV2
return


/*/{Protheus.doc} GetRecnPV1
Obtém o recno do pedido de vendas PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetRecnPV1() Class DhlMulMod3
	
return ::nRecnoPV1

/*/{Protheus.doc} SetRecnPV1
Define o recno do pedido de vendas PV1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetRecnPV1(nRecnoPV1) Class DhlMulMod3
	::nRecnoPV1 := nRecnoPV1
return

/*/{Protheus.doc} GetRecnPV2
Obtém o recno do pedido de vendas PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetRecnPV2() Class DhlMulMod3
	
return ::nRecnoPV2

/*/{Protheus.doc} SetRecnPV2
Define o recno do pedido de vendas PV2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetRecnPV2(nRecnoPV2) Class DhlMulMod3
	::nRecnoPV2 := nRecnoPV2
return

/*/{Protheus.doc} GetRecnNF1
Obtém o recno da nota NF1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetRecnNF1() Class DhlMulMod3
	
return ::nRecnoNF1

/*/{Protheus.doc} SetRecnNF1
Define o recno da nota NF1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetRecnNF1(nRecnoNF1) Class DhlMulMod3
	::nRecnoNF1 := nRecnoNF1
return

/*/{Protheus.doc} GetRecnNF2
Obtém o recno da nota NF2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetRecnNF2() Class DhlMulMod3
	
return ::nRecnoNF2

/*/{Protheus.doc} SetRecnNF2
Define o recno da nota NF2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetRecnNF2(nRecnoNF2) Class DhlMulMod3
	::nRecnoNF2 := nRecnoNF2
return


/*/{Protheus.doc} SetZZTpNf
Obtém o tipo da Nf (F2_ZZTPNF)

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetZZTpNf() Class DhlMulMod3
	
return ::cZZTpNf

/*/{Protheus.doc} SetZZTpNf
Define o tipo da Nf (F2_ZZTPNF)

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetZZTpNf(cZZTpNf) Class DhlMulMod3
	::cZZTpNf := cZZTpNf
return


/*/{Protheus.doc} GravaSC5Amarracao
Realiza a amarração dos dois pedidos de vendas

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GravaSC5Amarracao() Class DhlMulMod3
	
	GravAmaPV1(self)
	GravAmaPV2(self)
	
return

/*/{Protheus.doc} IsTesRede
Verifica se a TES dos itens da NF1 veio do parâmetro ZZ_TESREDE

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method IsTesRede() Class DhlMulMod3
	
	
return ::lTESRede

/*/{Protheus.doc} SetTesRede
Define se a TES dos itens da NF1 veio do parâmetro ZZ_TESREDE

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetTesRede(lTESRede) Class DhlMulMod3
	
	::lTESRede := lTESRede
	
return


/*/{Protheus.doc} GetRefNf
Obtém a NF referenciada

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetRefNf() Class DhlMulMod3
	
return ::cRefNf

/*/{Protheus.doc} SetRefNf
Define a NF referenciada

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetRefNf(cRefNf) Class DhlMulMod3
	
	::cRefNf := cRefNf
	
return

/*/{Protheus.doc} GetRefSerie
Obtém a série referenciada

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetRefSerie() Class DhlMulMod3
	
return ::cRefSerie

/*/{Protheus.doc} SetRefSerie
Define a série referenciada

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetRefSerie(cRefSerie)Class DhlMulMod3
	
	::cRefSerie := cRefSerie
	
return

/*/{Protheus.doc} GetRefData
Obtém a data do documento referenciado

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetRefData() Class DhlMulMod3
	
return ::cRefData

/*/{Protheus.doc} SetRefData
Define a data do documento referenciado

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetRefData(cRefData)	 Class DhlMulMod3
	
	::cRefData := cRefData
	
return

/*/{Protheus.doc} GetFimpRef
Obtém o valor F2_FIMP da nota referenciada

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetFimpRef()	 Class DhlMulMod3
	
return ::cFImpRef

/*/{Protheus.doc} SetFimpRef
Define o valor F2_FIMP da nota referenciada

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetFimpRef(cFImpRef)	 Class DhlMulMod3
	
	::cFImpRef := cFImpRef
	
return



/*/{Protheus.doc} GetFImp
Obtém o campo F2_FIMP

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetFImp() Class DhlMulMod3
return ::cFImp

/*/{Protheus.doc} SetFImp
Define o campo F2_FIMP

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetFImp(cFImp) Class DhlMulMod3
	::cFImp := cFImp
return

/*/{Protheus.doc} IsTesTransferencia
Verifica se nos itens contém a TES de tranferencia

@author Gustavo Luiz
@since 22/06/2017
@version 1.0
@example
(examples)
/*/
Method IsTesTransferencia() Class DhlMulMod3

return ::lTESTransferencia

/*/{Protheus.doc} SetTesTransferencia
Define se nos itens contém a TES de tranferencia

@author Gustavo Luiz
@since 22/06/2017
@version 1.0
@example
(examples)
/*/
Method SetTesTransferencia(lTESTransferencia) Class DhlMulMod3
	::lTESTransferencia := lTESTransferencia
return 


/*/{Protheus.doc} ExistNFRef
Obtém se existe a nota fiscal referenciada

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method ExistNFRef() Class DhlMulMod3
	
return ::lExistNFRef


/*/{Protheus.doc} GravaSF2Amarracao
Realiza a amarração dos das notas fiscais

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GravaSF2Amarracao(cChave) Class DhlMulMod3
	
	Local aArea 	:= GetArea()
	Local aAreaSF2	:= SF2->(GetArea())
	Local aAreaSD2	:= SD2->(GetArea())
	local cPedRefer := ""
	
	//OBTÉM O PEDIDO DE VENDAS PV2 (RETORNO DE INDUSTRIALIZAÇÃO)
	::cPV2 		:= GetPedVend(cChave)
	
	//COM O PEDIDO DE VENDAS PV2 (RETORNO DE INDUSTRIALIZAÇÃO) OBTENHO O PEDIDO REFERENCIADO (PV1 - (COBRANÇA DE KIT)) COM O NÚMERO DO DOCUMENTO DE SAÍDA E SÉRIE, CLIENTE E LOJA
	GetDadoPV1(self)
	
	//OBTENHO A DATA DA EMISSAO QUE ESTA NA SF2
	GetDtSF2P1(self)
	
	//OBTÉM O PEDIDO DE VENDAS PV1 (COBRANÇA DE KIT)
	::cPV1		:= GetPedVend(FwXFilial("SF2") + ::cDocPV1 + ::cSerPV1 + ::cCliPV1 + ::cLojPV1)
	
	//COM O PEDIDO DE VENDAS PV1 (COBRANÇA DE KIT) OBTENHO O PEDIDO REFERENCIADO (PV2 - (RETORNO DE INDUSTRIALIZAÇÃO)) COM O NÚMERO DO DOCUMENTO DE SAÍDA E SÉRIE, CLIENTE E LOJA
	GetDadoPV2(self)
	
	//OBTENHO A DATA DA EMISSAO QUE ESTA NA SF2
	GetDtSF2P2(self)
	
	
	//VERIFICO SE OS ITENS DA NF1 (COBRANÇA DE KIT) POSSUI A TES DEFINIDA NO PARÂMETRO ZZ_TESREDE
	VerifItNF1(self)
	
	//SALVA AS INFORMAÇÕES NA NF2 SE NÃO CONTER NOS ITENS DA NF1 A TES DEFINIDO EM PARÂMETRO ZZ_TESREDE
	if !::IsTesRede()
		
		//GRAVO AS INFORMAÇÕES (REFERENTE AO PV1) NA NF2 (JÁ ESTA POSICIONADA)
		SaveDadoP1(self)
	
	endIf
		
	//GRAVO AS INFORMAÇÕES (REFERENTE AO PV2) NA NF1
	SaveDadoP2(self)	
	
	RestArea(aAreaSD2)
	RestArea(aAreaSF2)
	RestArea(aArea)
	
return

/*/{Protheus.doc} SetErro
Define erro

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetErro(lErro) Class DhlMulMod3
	::lErro := lErro
return

/*/{Protheus.doc} HasErro
Obtém se possui erro

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method HasErro() Class DhlMulMod3
	
return ::lErro

/*/{Protheus.doc} getMsgErro
Obtém a msg erro

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method getMsgErro() Class DhlMulMod3
	
return ::cMsgErro

/*/{Protheus.doc} setMsgErro
Define a msg erro

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method setMsgErro(cMsgErro) Class DhlMulMod3
	::cMsgErro := cMsgErro
return

/*/{Protheus.doc} ValidFaturamento
Valida se pode ou não ser faturado o pedido

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method ValidFaturamento(cPedido) Class DhlMulMod3
	
	lPodeFaturar := .F.
	
	if PosPediReferenciado(cPedido)
		
		if !empty(SC5->C5_NOTA) .or. SC5->C5_LIBEROK=='E' .And. Empty(SC5->C5_BLQ)
			lPodeFaturar := .T.
		else
			MsgAlert("Este pedido não pode ser faturado ! É necessário realizar o faturamento do pedido " + SC5->C5_NUM)
		endIf
		
	endIf
	
return lPodeFaturar


/*/{Protheus.doc} GetZZMsgIN
Obtém a mensagem do campo C5_ZZMSGIN

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetZZMsgIN(cPedido) Class DhlMulMod3
	
	local aArea 	:= GetArea()
	local aAreaSC5	:= SC5->(GetArea())
	local cMensInsum:= ""
	
	SC5->(DbSetOrder(1))
	if SC5->(DbSeek(FWXFilial("SC5") + cPedido))
		cMensInsum := Alltrim(SC5->C5_ZZMSGIN)
	endIf
	
	RestArea(aAreaSC5)
	RestArea(aArea)
	
return cMensInsum

/*/{Protheus.doc} GetInfAdicional
Obtém a mensagem para a nota. Utilizado no ponto de entrada PE01NFESEFAZ

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetInfAdicional(cPedido) Class DhlMulMod3
	
	local aArea 	:= GetArea()
	local aAreaSC5	:= SC5->(GetArea())
	local aAreaSF2	:= SF2->(GetArea())
	local cInfAdic  := ""
	
	SF2->(DbSetOrder(1))
	SC5->(DbSetOrder(1))
	if SC5->(DbSeek(FWXFilial("SC5") + cPedido))
			
		if SC5->C5_ZZTPPV == COBRANCA_KIT .AND. !EMPTY(SC5->C5_ZZTPPV)//RONI SILVA
		
			::cPV1 		:= cPedido
				
			self:ArmazenArea()
				
			GetDadoPV2(self)
			GetDtSF2P2(self)
			
			SF2->(DbgoTo(self:GetRecnNF2()))
			
			cInfAdic := "Número NFE " + allTrim(SF2->F2_DOC) + ", Série " + allTrim(SF2->F2_SERIE) + ", e Data de Emissão " + cValToChar(SF2->F2_EMISSAO ) + "(NFE Ret Indl CFOP 5.902)."
			
			self:RetornaAreas()
			
		elseIF !EMPTY(SC5->C5_ZZTPPV)
			
			::cPV2 		:= cPedido
			
			self:ArmazenArea()
				
			GetDadoPV1(self)
			GetDtSF2P1(self)
			
			SF2->(DbgoTo(self:GetRecnNF1()))
			
			cInfAdic := "Número NFE " + allTrim(SF2->F2_DOC) + ", Série " + allTrim(SF2->F2_SERIE) + ", e Data de Emissão " + cValToChar(SF2->F2_EMISSAO ) + "(NFE DHL Kit CFOP 5.124)."
			
			self:RetornaAreas()
			         
		endIf
	endIf
	
	RestArea(aAreaSF2)
	RestArea(aAreaSC5)
	RestArea(aArea)
	
return cInfAdic

/*/{Protheus.doc} PosicNF1
Posiciona na NF1 para a geração da interface para o Mastersaf nfe.
A chave recebida é referente a nota NF2. A partir desta chave localizo a chave NF1

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method PosicNF1(cChave) Class DhlMulMod3
	
	local cPedRefer := ""
	
	::aArea 	:= GetArea()
	::aAreaSF2	:= SF2->(GetArea())
	::aAreaSD2	:= SD2->(GetArea())
	
	//OBTÉM O PEDIDO DE VENDAS PV2 (RETORNO DE INDUSTRIALIZAÇÃO)
	::cPV2 		:= GetPedVend(cChave)
	
	//COM O PEDIDO DE VENDAS PV2 (RETORNO DE INDUSTRIALIZAÇÃO) OBTENHO O PEDIDO REFERENCIADO (PV1 - (COBRANÇA DE KIT)) COM O NÚMERO DO DOCUMENTO DE SAÍDA E SÉRIE, CLIENTE E LOJA
	GetDadoPV1(self)
	
	//OBTENHO A DATA DA EMISSAO QUE ESTA NA SF2
	GetDtSF2P2(self)
	
	//REALIZA O POSICIONAMENTO
	PosNF1(self)
	
return

/*/{Protheus.doc} RetornaAreas
Retorna as áreas salvas no ponto de entrada M460FIM

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method RetornaAreas() Class DhlMulMod3
	
	if Len(::aAreaSF2) > 0
		RestArea(::aAreaSF2)
		::aAreaSF2:= {}
	endIf
	
	if Len(::aAreaSD2) > 0
		RestArea(::aAreaSD2)
		::aAreaSD2:= {}
	endIf
	
	if Len(::aArea) > 0
		RestArea(::aArea)
		::aArea:= {}
	endIf
	
return

/*/{Protheus.doc} ArmazenArea
Armazena as áreas

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method ArmazenArea() Class DhlMulMod3
	
	::aArea 	:= GetArea()
	::aAreaSF2	:= SF2->(GetArea())
	::aAreaSD2	:= SD2->(GetArea())
	
return

/*/{Protheus.doc} GetDadoNF
Obtém os dados da NF

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/

Method GetDadoNF(nRecno) Class DhlMulMod3
	
	local aArea	   := GetArea()
	local aAreaSF2 := SF2->(GetArea())
	local cChave   := {}
	
	SF2->(DbSetOrder(1))
	SF2->(DbGoto(nRecno))
	
	cChave := SF2->(F2_DOC + F2_SERIE)
	
	restArea(aAreaSF2)
	restArea(aArea)
	
return cChave

/*/{Protheus.doc} GetDadoNFReferenc
Obtém os dados da NF Referenciada

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/

Method GetDadoNFReferenc() Class DhlMulMod3
	
	local aArea	   := GetArea()
	local aAreaSF2 := SF2->(GetArea())
	local cChaveRef:= FwXFilial("SF2") + SF2->F2_ZZSEREF + dTos(SF2->F2_ZZDTERE) + SF2->F2_ZZNFREF
	
	
	//ARMAZENO O FIMP DA NOTA POSICIONADA ATUALMENTE, ATES DE DESPOSICIONAR
	::SetFImp( SF2->F2_FIMP)
	
	SF2->(DbSetOrder(4))
	
	if SF2->(DbSeek(cChaveRef))
		
		::lExistNFRef := .T.
		::SetRefNf(SF2->F2_DOC)
		::SetRefSerie(SF2->F2_SERIE)
		::SetRefData(SF2->F2_EMISSAO)
		::SetFimpRef(SF2->F2_FIMP)
		
	endIf
	
	restArea(aAreaSF2)
	restArea(aArea)
	
return


/*/{Protheus.doc} CanCreateInvConf
Verifica se vai pode ser criado a invoice confirmation da nf (recno) passado por parâmetro

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method CanCreateInvConf(nRecno) Class DhlMulMod3
	
	local oSql    	 := IpSqlObject():newIpSqlObject()
	local aArea	   	 := GetArea()
	local aAreaSF2 	 := SF2->(GetArea())
	local aAreaSC5 	 := SC5->(GetArea())
	local cChave   	 := ::GetDadoNF(nRecno)
	local cFilialSF2 := ""
	local cDoc		 := ""
	local cSerie	 := ""
	local cTipoPV	 := ""
	
	if !Empty(cChave)
		
		oSql:newTable("SC5", "C5_ZZTPPV TIPOPV, C5_SERIE SERIE", "%SC5.XFILIAL% AND C5_NOTA || C5_SERIE = '"+cChave+"'")
		
		if oSql:hasRecords()
			cTipoPV := Alltrim(oSql:getValue("TIPOPV"))
			
			if cTipoPV == COBRANCA_KIT
				::VerifItNF1(nRecno)
				::lCanInvConf := .F.
			else
				::lCanInvConf := .T.
			endIf
			
			::cZZTpNf := cTipoPV
			
		endIf
		
		oSql:close()
		
	endIf
	
	restArea(aAreaSC5)
	restArea(aAreaSF2)
	restArea(aArea)
	
return ::lCanInvConf

/*/{Protheus.doc} GerNF2Issue
Gera a Issue da NF2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GerNF2Issue(nRecno) Class DhlMulMod3
	
	local aArea	   	 := GetArea()
	local aAreaSF2 	 := SF2->(GetArea())
	local aAreaSC5 	 := SC5->(GetArea())
	local cZZNfRel 	 := ""
	local cZZSerRef  := ""
	local dDtRef	 := nil
	local cTipo		 := DHL_NFE_INVOICE_OUTFLOW
	local cSerie	 := ""
	local cNota      := ""
	local cClieFor   := ""
	local cLoja		 := ""
	local cNotaOri	 := ""
	local cSerieOri	 := ""
	
	SF2->(DbGoto(nRecno))
	
	cTipoNF2 := SF2->F2_ZZTPNF
	cZZNfRel := SF2->F2_ZZNFREF
	cZZSerRef:=	SF2->F2_ZZSEREF
	dDtRef	 := SF2->F2_ZZDTERE
	
	SF2->(DbSetOrder(4))
	if SF2->(DbSeek(FwXFilial("SF2") + cZZSerRef + dTos(dDtRef) + cZZNfRel))
		//TODO TESTAR O MÉTODO / LER UC 1.5 ITEM B
		cNota		:= SF2->F2_DOC
		cSerie      := SF2->F2_SERIE
		cClieFor    := SF2->F2_CLIENTE
		cLoja		:= SF2->F2_LOJA
		cNotaOri	:= SF2->F2_NFORI
		cSerieOri	:= SF2->F2_SERIORI
		
		// Bloco de código refere-se a Geração do Arquivo de NFe para o Mastersaf
		if IsInCallStack("u_ImpMsaNfe")
			if ExistBlock("PrcXmlNfe")
				oDHLProcValid	:= DHLProcessValidator():newDHLProcessValidator()
				if oDHLProcValid:validDocumentType(cTipo, nil, cSerie)
					lReturn := U_PrcXmlNfe(cTipo, cSerie, cNota, cClieFor, cLoja, cNotaOri, cSerieOri)
				endIf
			endif
		endIf
	endIf
	
	restArea(aAreaSC5)
	restArea(aAreaSF2)
	restArea(aArea)
	
return

/*/{Protheus.doc} VerifItNF1
Verifica se os itens da nota possui a TES ZZ_TESREDE ou TES ZZ_TESTRAN

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method VerifItNF1(nRecno) Class DhlMulMod3
	
	local aArea	   	 := GetArea()
	local aAreaSF2 	 := SF2->(GetArea())
	local aAreaSD2	 := SD2->(GetArea())
	local cChave	 := ""
	local cTesParam  := GetNewPar("ZZ_TESREDE", "")
	local cTesTransf := GetNewPar("ZZ_TESTRAN", "")
	
	SF2->(DbGoto(nRecno))
	
	cChave := FwXFilial("SF2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA
	
	SD2->(DbSetOrder(3))
	
	if SD2->(DbSeek(cChave))
		while SD2->(!eof()) .and. cChave == SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
			
			if Alltrim(SD2->D2_TES) == AllTrim(cTesParam)
				::SetTesRede(.T.)
				exit
			endIf
			
			if alltrim(SD2->D2_TES) == AllTrim(cTesTransf)
				::SetTesTransferencia(.T.)
				exit
			endIf
			
			SD2->(DbSkip())
			
		endDo
	endIf
	
	restArea(aAreaSD2)
	restArea(aAreaSF2)
	restArea(aArea)
	
return

/*/{Protheus.doc} SendEmail
Envia e-mail quando a nota for rejeitada

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SendEmail(cALias) Class DhlMulMod3
	
	local oMail			:= DHLSndMail():Create()
	local cEmailFrom	:= alltrim(GetMv("MV_RELFROM"))
	local aEmailTo		:= StrToKarr(GETMV("ZZ_MAILNFR"), ";")
	local cEmailTo		:= ""
	local cField		:= right(cAlias, 2)
	local cDescrResu 	:= ""
	local cDescrCompl 	:= ""
	local cMsg			:= ""
	local nI 			:= 0
	
	for nI := 1 To Len(aEmailTo)
		
		cEmailTo := aEmailTo[nI]
		
		cMsg := ""
		cMsg += "<html><head>Rejeição Nota Fiscal Automática</head><body>"
		cMsg += "<br/>A Nota Fiscal de Emissão Automática: <br/>"
		cMsg += "Número: " + alltrim((cAlias)->&(cField+"_DOC")) + "<br/>"
		cMsg += "Série: " + alltrim((cAlias)->&(cField+"_SERIE")) + "<br/>"
		cMsg += "Data: " + dtoc((cAlias)->&(cField+"_EMISSAO")) + "<br/>"
		cMsg += "foi rejeitada pelo sefaz, favor verificar! "
		cMsg += "</body></html>"
		
		oMail:cFrom	 	:= cEmailFrom
		oMail:cTo		:= cEmailTo
		oMail:cSubject	:= "Rejeição Nota Fiscal Automática - Filial: "+FwxFilial("SF2")
		oMail:cBody		:= cMsg
		oMail:lSilence	:= .T.
		
		
		FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "[" + DToC(dDataBase) + " - " + Time() + "] - Envio de e-mail de  "+cEmailFrom, 0, 0, {})
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "[" + DToC(dDataBase) + " - " + Time() + "] - Para: " + cEmailTo, 0, 0, {})
		
		If oMail:Send()
			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "================= [" + DToC(dDataBase) + " - " + Time() + "] - Enviado com sucesso.", 0, 0, {})
		Else
			cDescrResu	:= "E-mail"
			cDescrCompl	:= "Não foi possível enviar o e-mail para processo da Nota Fiscal: " +  alltrim((cAlias)->&(cField+"_DOC")) + "/" +;
				alltrim((cAlias)->&(cField+"_SERIE")) + " Data: " + dtoc((cAlias)->&(cField+"_EMISSAO"))
			oLog:start(APP_MASTERSAF_NFE, DHL_IMPORTACAO)
			oLog:fail(cDescrResumid,cDescrCompleta)
		EndIf
		
	next nI
	
return


/*/{Protheus.doc} GetRecnosNF
Obtém os recnos das notas NF1 e NF2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetRecnosNF(nRecno, cTipoNota) Class DhlMulMod3
	
	local aArea	   	 := GetArea()
	local aAreaSF2 	 := SF2->(GetArea())
	local cChave	 := ""
	local cNfRef	 := ""
	local cSeriRef	 := nil
	
	SF2->(DbGoto(nRecno))
	
	if cTipoNota == COBRANCA_KIT
		::SetRecnNF1(nRecno)
	else
		::SetRecnNF2(nRecno)
	endIf
	
	cNfRef 		:= SF2->F2_ZZNFREF
	cSeriRef	:= SF2->F2_ZZSEREF
	dDateRef	:= SF2->F2_ZZDTERE
	
	cChave 		:= FwXFilial("SF2") + cSeriRef + dTos(dDateRef) + cNfRef
	
	SF2->(DbSetOrder(4))
	if SF2->(DbSeek(cChave))
		
		if SF2->F2_ZZTPNF == COBRANCA_KIT
			::SetRecnNF1(SF2->(Recno()))
		else
			::SetRecnNF2(SF2->(Recno()))
		endIf
		
	endIf
	
	restArea(aAreaSF2)
	restArea(aArea)
	
return

/*/{Protheus.doc} IsNF1Ativo
Verifica se a nota NF1 esta ativo no sistema

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method IsNF1Ativo() Class DhlMulMod3
	
	local lAtivo := .F.
	
	if !empty(::cFImpRef)
		msgAlert(Alltrim("Esta NF esta referenciada a nota " + AllTrim(::cRefNf)+ " série " + AllTrim(::cRefSerie) + " (" + cValToChar(::cRefData)+ ")." +" Caso realmente deseja excluir esta nota, a NF referenciada deve ser excluída anteriormente."))
		lAtivo := .T.
	endIf
	
return lAtivo

/*/{Protheus.doc} ExcluirNF2
Excluir a nota fiscal

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method ExcluirNF2(cNota, cSerie, dDataEmissao) Class DhlMulMod3
	
	local aAreaSF2		:= SF2->(GetArea())
	local aAreaSD2		:= SD2->(GetArea())
	local aArea			:= GetArea()
	local cChave		:= cSerie + dTos(dDataEmissao) + cNota
	local aMata520Cab 	:= GetHeaderDocSaida(cChave, Self)
	local lSucesso		:= .F.
	
	PosicSD2(self)
	
	//MSExecAuto({|x| MATA520(x)},aMata520Cab,5)
	lSucesso := EstornaDocumento(aMata520Cab)
	
	If !lSucesso
		
		::SetErro(.T.)
		::SetMsgErro("Não foi possível realizar a exclusão na nota " + SF2->F2_DOC)
		
	Endif
	
	restArea(aAreaSF2)
	RestArea(aAreaSD2)
	restArea(aArea)
	
return lSucesso

/*/{Protheus.doc} GerNF2Cancelation
Gera a interface de cancelamento da NF2

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GerNF2Cancelation(nRecnoNF1) Class DhlMulMod3
	
	local cNota         := ""
	local cSerie        := ""
	local cCliente      := ""
	local cLoja         := ""
	local cChvNfe       := ""
	local cNfRef		:= ""
	local cSerieRef		:= ""
	local cDataRef		:= ""
	local cTipoNf       := ""
	local aArea			:= GetArea()
	local aAreaSF2		:= SF2->(GetArea())
	local oDHLProcValid := DHLProcessValidator():newDHLProcessValidator()
	
	//POSICIONA NA NF1
	SF2->(DbGoTo(nRecnoNF1))
	
	//OBTENHO AS INFORMAÇÕES REFERENTE A NOTA REFERENCIADA (NF2)
	cNfRef		:= SF2->F2_ZZNFREF
	cSerieRef	:= SF2->F2_ZZSEREF
	cDataRef	:= SF2->F2_ZZDTERE
	cTipoNf		:= DHL_NFE_INVOICE_OUTFLOW
	
	DbSelectArea("SF2")
	SF2->(DbSetOrder(4))
	
	//POSICIONO NA NOTA SF2
	if SF2->(DbSeek(FwXFilial("SF2") + SF2->(cSerieRef + dTos(cDataRef) + cNfRef)))
		
		cNota         := SF2->F2_DOC
		cSerie        := SF2->F2_SERIE
		cCliente      := SF2->F2_CLIENTE
		cLoja         := SF2->F2_LOJA
		cChvNfe       := SF2->F2_CHVNFE
		
		if ExistBlock("PrcCancMsa")
			if oDHLProcValid:validDocumentType(cTipoNf,nil,cSerie)
				if oDHLProcValid:validSendInterface(cTipoNf)
					U_PrcCancMsa(cTipoNf, cChvNfe, cNota, cSerie, cCliente, cLoja)
				endif
			endIf
		endIf
		
	endIf
	
	RestArea(aAreaSF2)
	RestArea(aArea)
	
return

/*/{Protheus.doc} Posiciona
Posiciona na nota referenciada de acordo com o Recno da nota base.

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method Posiciona(nRecno) Class DhlMulMod3
	
	local cChaveRef:= ""
	
	::aArea 	:= GetArea()
	::aAreaSF2	:= SF2->(GetArea())
	::aAreaSD2	:= SD2->(GetArea())
	
	SF2->(DbSetOrder(4))
	SF2->(DbgoTo(nRecno))
	
	cChaveRef := FwXFilial("SF2") + SF2->F2_ZZSEREF + dTos(SF2->F2_ZZDTERE) + SF2->F2_ZZNFREF
	
	if SF2->(DbSeek(cChaveRef))
		FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Posiciona - Posicionado SF2", 0, 0, {})
	endIf
	
return

/*/{Protheus.doc} PosicNotaAtual
Posiciona na nota atual baseado no recno. Necessário pois tem situações em que tenho o recno,
mas não estou posicionado nela

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method PosicNotaAtual(nRecno) Class DhlMulMod3
	
	::aArea 	:= GetArea()
	::aAreaSF2	:= SF2->(GetArea())
	::aAreaSD2	:= SD2->(GetArea())
	
	SF2->(DbgoTo(nRecno))
	
return

/*/{Protheus.doc} IsNfRefAutorizada
Verifica se a nota referenciada esta autorizada: F2_FIMP = 'S'

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method IsNfRefAutorizada() Class DhlMulMod3
	
	local lAutorizada := .F.
	
	if ::cFImpRef == AUTORIZADA
		lAutorizada := .T.
	endIf
	
return lAutorizada

/*/{Protheus.doc} GravaAmarRetornToKit
Grava as informações que estão na NF2 para a NF1. (Específico quando possui nos itens a ZZ_TESREDE)

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GravaAmarRetornToKit(cChave) Class DhlMulMod3

	Local aArea 	:= GetArea()
	Local aAreaSF2	:= SF2->(GetArea())
	Local aAreaSD2	:= SD2->(GetArea())
	local aAreaSC5	:= SC5->(GetArea())
	local cPedRefer := ""
	local cNota		:= ""
	local cSerie	:= ""
	local cCliente	:= ""
	local cLoja		:= ""
	local cDataEmiss:= ""
	local oSql    	 := IpSqlObject():newIpSqlObject()
	
	//OBTÉM O PEDIDO DE VENDAS PV1 (COBRANÇA DE KIT)
	::cPV1 		:= GetPedVend(cChave)	
	
	cPedRefer	:= SC5->C5_ZZPVREF
	
	if SC5->(DbSeek(FWXFilial("SC5") + cPedRefer))
		
		cNota 		:= SC5->C5_NOTA
		cSerie		:= SC5->C5_SERIE
		cCliente 	:= SC5->C5_CLIENTE
		cLoja		:= SC5->C5_LOJACLI
		
	endIf
	
	oSql:newTable("SF2", "F2_DOC , F2_SERIE , F2_EMISSAO", "%SF2.XFILIAL% AND F2_DOC || F2_SERIE = '"+ cNota + cSerie +"' AND F2_CLIENTE || F2_LOJA = '"+cCliente + cLoja+"'")
	
	if oSql:hasRecords()
		
		cDataEmiss := oSql:GetValue("F2_EMISSAO")
		
		if SF2->(reclock("SF2", .F.))
			
			SF2->F2_ZZTPNF 	:= COBRANCA_KIT //TIPO DO PV1
			SF2->F2_ZZNFREF := cNota
			SF2->F2_ZZSEREF := cSerie
			SF2->F2_ZZDTERE := sTod(cDataEmiss)
			
			SF2->(msUnLock())
			
		endIf
		
	endIf
	
	oSql:Close()	
	
	RestArea(aAreaSC5)
	RestArea(aAreaSD2)
	RestArea(aAreaSF2)
	RestArea(aArea)

return

/*/{Protheus.doc} IsAmarrSC5
Verifica se existe amarração na SE5

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method IsAmarrSC5(cNota, cSerie, cCliFor, cLoja) Class DhlMulMod3
	
	local oSql    	 := IpSqlObject():newIpSqlObject()
	local cZZTipo	 := ""
	local cChave	 := cNota + cSerie +  cCliFor +  cLoja
	local cIsAmarrad := .T.
	
	oSql:newTable("SC5", "C5_ZZTPPV TIPOPV, C5_SERIE SERIE, C5_NUM, C5_ZZTIPO", "%SC5.XFILIAL% AND C5_NOTA || C5_SERIE || C5_CLIENTE || C5_LOJACLI = '"+cChave+"'")
		
	if oSql:hasRecords()
		cTipoPV := Alltrim(oSql:getValue("TIPOPV"))
		cZZTipo := AllTrim(oSql:getValue("C5_ZZTIPO"))	
		
		//SE FOR DEVOLUCAO E O CAMPO C5_ZZTIPO ESTIVER VAZIO, QUER DIZER QUE NÃO FOI REALIZADO A AMARRAÇÃO PELA INVOICE REQUEST
		if cZZTipo == DEVOLUCAO .and. empty(cTipoPV)
			cIsAmarrad := .F.
		endIf	
	endIf
		
	oSql:close()	
	
return cIsAmarrad

/**
* Realiza o estorno do documento de saída
**/
static function EstornaDocumento(aMata520Cab)
	
	local	aRegSD2			:= {}
	local 	aRegSE1			:= {}
	local 	aRegSE2			:= {}
	local 	aChave 			:= {}
	local 	aRotAuto 		:= {}
	local 	lCanDel			:= .F.
	
	aChave 		:= {"F2_DOC","F2_SERIE"}
	aRotAuto 	:= SF2->(MSArrayXDB(aMata520Cab,,5,,aChave))
	
	If !( Len(aRotAuto) > 0 )
		Return .T.
	EndIf
	
	lCanDel := MaCanDelF2("SF2",SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2)
	
	If lCanDel
		
		PcoIniLan("000102")
		SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,,,,))
		PcoFinLan("000102")
		
	endIf
	
return lCanDel


/**
* Posiciono da NF1
**/
static function PosNF1(oModelo3)
	
	if !empty(oModelo3:GetSerPV1()) 
		if SF2->(DbSeek(FWxFilial("SF2") + oModelo3:GetDocPV1() + oModelo3:GetSerPV1() + oModelo3:GetCliPV1() + oModelo3:GetLojPV1()))
			FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "PosNF1 - Posicionado SF2", 0, 0, {})
		endIf
	endIf
	
return

/**
* Obtenho a data de emissão na SF2
**/
static function GetDtSF2P1(oModelo3)
	
	local aArea 	:= GetArea()
	local aAreaSF2	:= SF2->(GetArea())
	
	if SF2->(DbSeek(FwXFilial("SF2") + oModelo3:GetDocPV1() + oModelo3:GetSerPV1() + oModelo3:GetCliPV1() + oModelo3:GetLojPV1()))
		
		oModelo3:SetDtePV1(dTos(SF2->F2_EMISSAO))
		oModelo3:SetRecnNF1(SF2->(Recno()))
		
	endIf
	
	RestArea(aAreaSF2)
	RestArea(aArea)
	
return

/**
* Obtenho a data de emissão na SF2
**/
static function GetDtSF2P2(oModelo3)
	
	local aArea 	:= GetArea()
	local aAreaSF2	:= SF2->(GetArea())
	
	if SF2->(DbSeek(FwXFilial("SF2") + oModelo3:GetDocPV2() + oModelo3:GetSerPV2() + oModelo3:GetCliPV2() + oModelo3:GetLojPV2()))
		
		oModelo3:SetDtePV2(dTos(SF2->F2_EMISSAO))
		oModelo3:SetRecnNF2(SF2->(Recno()))
		
	endIf
	
	RestArea(aAreaSF2)
	RestArea(aArea)
	
return

/**
* Salva os dados nos campos personalizados
**/
static function SaveDadoP1(oModelo3)
	
	if SF2->(reclock("SF2", .F.))
		
		SF2->F2_ZZTPNF 	:= RETORNO_INDUSTRIALIZACAO //TIPO DO PV2
		SF2->F2_ZZNFREF := oModelo3:GetDocPV1()
		SF2->F2_ZZSEREF := oModelo3:GetSerPV1()
		SF2->F2_ZZDTERE := sTod(oModelo3:GetDtePV1())
		
		SF2->(msUnLock())
		
	endIf
	
return

/**
* Salva os dados nos campos personalizados
**/
static function SaveDadoP2(oModelo3)
	
	local aArea 	:= GetArea()
	local aAreaSF2	:= SF2->(GetArea())
	
	if SF2->(DbSeek(FWxFilial("SF2") + oModelo3:GetDocPV1() + oModelo3:GetSerPV1() + oModelo3:GetCliPV1() + oModelo3:GetLojPV1()))
		
		if SF2->(reclock("SF2", .F.))
			
			SF2->F2_ZZTPNF 	:= COBRANCA_KIT //TIPO DO PV1
			SF2->F2_ZZNFREF := oModelo3:GetDocPV2()
			SF2->F2_ZZSEREF := oModelo3:GetSerPV2()
			SF2->F2_ZZDTERE := sTod(oModelo3:GetDtePV2())
			
			SF2->(msUnLock())
			
		endIf
		
	endIf
	
	RestArea(aAreaSF2)
	RestArea(aArea)
	
return

/**
* Verifica se os itens da NF1 possui a TES definida no parâmetro ZZ_TESREDE
**/
static function VerifItNF1(oModelo3)
	
	local aArea 	:= GetArea()
	local aAreaSD2	:= SD2->(GetArea())
	local cChave	:= FwXFilial("SD2") + oModelo3:GetDocPV1() + oModelo3:GetSerPV1() + oModelo3:GetCliPV1() + oModelo3:GetLojPV1()
	local cTesParam := GetNewPar("ZZ_TESREDE", "")
	
	SD2->(DbSetOrder(3))
	if SD2->(DbSeek(cChave))
		
		while SD2->(!eof()) .and. cChave == SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
			
			if Alltrim(SD2->D2_TES) == AllTrim(cTesParam)
				oModelo3:SetTesRede(.T.)
				exit
			endIf
			
			SD2->(DbSkip())
			
		endDo
		
	endIf
	restArea(aAreaSD2)
	restArea(aArea)
	
return

/**
* Grava o número do pedido de vendas PV1 no PV2 (C5_ZZPVREF)
**/
static function GravAmaPV1(oModelo3)
	
	local aArea 	:= GetArea()
	local aAreaSC5 	:= SC5->(GetArea())
	
	cPedido := oModelo3:GetPV1()
	nRecno	:= oModelo3:GetRecnPV2()
	
	SC5->(DbGoTo(nRecno))
	
	If SE5->(RecLock("SC5", .F.))
		
		SC5->C5_ZZPVREF := cPedido
		SC5->(MsUnLock())
		
	else
		
		oModelo3:SetErro(.T.)
		oModelo3:SetMsgErro("Não foi possível bloquer a tabela SC5 para gravar o pedido de vendas (PV1)")
		
	endIf
	
	RestArea(aAreaSC5)
	RestArea(aArea)
	
return

/**
* Grava o número do pedido de vendas PV2 no PV1 (C5_ZZPVREF)
**/
static function GravAmaPV2(oModelo3)
	
	local aArea 	:= GetArea()
	local aAreaSC5 	:= SC5->(GetArea())
	
	cPedido := oModelo3:GetPV2()
	nRecno	:= oModelo3:GetRecnPV1()
	
	SC5->(DbGoTo(nRecno))
	
	if SE5->(RecLock("SC5", .F.))
		
		SC5->C5_ZZPVREF := cPedido
		
	else
		
		oModelo3:SetErro(.T.)
		oModelo3:SetMsgErro("Não foi possível bloquer a tabela SC5 para gravar o pedido de vendas (PV2)")
		
	endIf
	
	RestArea(aAreaSC5)
	RestArea(aArea)
	
return

/**
* Posiciona no pedido referenciado
**/
static function PosPediReferenciado(cPedidoRefer)
	
	local lPosicionado := .F.
	
	SC5->(DbSetOrder(1))
	
	if SC5->(DbSeek(FwXFilial("SC5") + cPedidoRefer))
		
		lPosicionado := .T.
		
	endIf
	
return lPosicionado

/**
* Obtém o pedido de vendas na SD1
**/
static function GetPedVend(cChave)
	
	local cPedido := ""
	
	SD2->(DbSetOrder(3))
	if SD2->(DbSeek(cChave))
		
		cPedido := SD2->D2_PEDIDO
		
	endIf
	
return cPedido

/**
* Obtém o pedido referenciado do PV1, documento, série, cliente e loja do PV2
**/
static function GetDadoPV2(oModelo3)
	
	local aAreaSC5 			:= SC5->(GetArea())
	local cPedidoRef		:= ""
	
	SC5->(DbSetOrder(1))
	if SC5->(DbSeek(FwXFilial("SC5") + oModelo3:GetPV1()))
		cPedidoRef := SC5->C5_ZZPVREF
		if SC5->(DbSeek(FwXFilial("SC5") + cPedidoRef))
			oModelo3:SetPV2(SC5->C5_ZZPVREF)
			oModelo3:SetCliPV2(SC5->C5_CLIENTE)
			oModelo3:SetLojPV2(SC5->C5_LOJACLI)
			oModelo3:SetDocPV2(SC5->C5_NOTA)
			oModelo3:SetSerPV2(SC5->C5_SERIE)
		endIf
	endIf
	
	RestArea(aAreaSC5)
	
return

/**
* Obtém o pedido referenciado do PV2, documento, série, cliente e loja do PV1
**/
static function GetDadoPV1(oModelo3)
	
	local aAreaSC5 			:= SC5->(GetArea())
	local cPedidoRef		:= ""
	
	SC5->(DbSetOrder(1))
	if SC5->(DbSeek(FwXFilial("SC5") + oModelo3:GetPV2()))
		cPedidoRef := SC5->C5_ZZPVREF
		if SC5->(DbSeek(FwXFilial("SC5") + cPedidoRef))
			oModelo3:SetPV1(SC5->C5_ZZPVREF)
			oModelo3:SetCliPV1(SC5->C5_CLIENTE)
			oModelo3:SetLojPV1(SC5->C5_LOJACLI)
			oModelo3:SetDocPV1(SC5->C5_NOTA)
			oModelo3:SetSerPV1(SC5->C5_SERIE)
		endIf
	endIf
	
	RestArea(aAreaSC5)
	
return

/**
* posiciona na SD2
**/
static function PosicSD2(oModelo3)
	
	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	
	if SD2->(DbSeek(xFilial("SD2") + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA )))
		oModelo3:SetErro(.F.)
	else
		oModelo3:SetErro(.T.)
		oModelo3:SetMsgErro("erro")
	endIf
	
return

/**
* obtém o cabeçalho da nota de saida
**/
static function GetHeaderDocSaida(cChave, oModelo3)
	
	local aHeader		:= {}
	local aAreaSF2		:= SF2->(GetArea())
	local aAreaSD2		:= SD2->(GetArea())
	local aArea			:= GetArea()
	
	DbSelectArea("SF2")
	SF2->(DbSetOrder(4))
	
	if SF2->(DbSeek(FwXFilial("SF2") + cChave))
		
		aAdd(aHeader,{"F2_DOC", 	SF2->F2_DOC			, nil})
		aAdd(aHeader,{"F2_SERIE", 	SF2->F2_SERIE		, nil})
		aAdd(aHeader,{"F2_CLIENTE", SF2->F2_CLIENTE		, nil})
		aAdd(aHeader,{"F2_LOJA", 	SF2->F2_LOJA		, nil})
		aAdd(aHeader,{"F2_FORMUL", 	SF2->F2_FORMUL		, nil})
		aAdd(aHeader,{"F2_TIPO", 	SF2->F2_TIPO		, nil})
		
		oModelo3:SetRecnNF2(SF2->(Recno()))
		
	else
		
		oModelo3:SetErro(.T.)
		oModelo3:SetMsgErro("Nota " + cNota + " não localizada:" + CRLF + CRLF + "Serie:" + cSerie + CRLF + "Data:" + cValToChar(dDataEmissao))
		
	endIf
	
	RestArea(aAreaSF2)
	RestArea(aAreaSD2)
	RestArea(aArea)
	
	//POSICIONA NO INDICE 1
	SF2->(DbSetOrder(1))
	SF2->(DbGoTo(oModelo3:GetRecnNF2()))
	
return aHeader

