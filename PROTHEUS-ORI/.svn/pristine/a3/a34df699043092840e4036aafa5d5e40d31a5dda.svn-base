#include 'totvs.ch'
#include 'dhl.ch'

#define INTERFACE  					"SAP IP 210"
#define CNPJ_CLIENTE 1
#define COD_CLIENTE	 2
#define PRODUTO		"SB1"

#define EMISSAO 	1
#define SERIE 		2
#define DOC	 		3
#define CNPJ 		4
#define ESTCOB 		5
#define ESPECIE 	6
#define CHAVENFE 	7
#define VALOR_BRUTO 8

//RESPEITAR ORDEM QUANDO POPULADO NA FUNÇÃO LoadDadosXML(cFilePath) DO FONTE SAPIP210
#define ITEM			 1
#define QUANTITY		 2
#define NF_REF_RCO	 	 3
#define SERIE_REF_RCO	 4
#define ITEM_REF_RCO	 5

#define PENDENTE_ASN	"3"

#define INCLUSAO		 3

#define NOTA			1
#define SERIE			2
#define DATA_NF			3

#define SAIDA			"1"

#define POS_PRODUTO			1
#define POS_QUANTIDADE		2

#define PROPRIO				"S"
#define ALTER_INVOICE		4

#define NOTA_ORIGEM 	1
#define SERIE_ORIGEM 	2

/*/{Protheus.doc} DHLIp210
Classe auxiliar para a interface DHLIp210
@type class 
@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 

user function _dlhip210;return


Class DHLIp210

	data cFromPartner
	data cToPartner
	data cSiteCNPJ
	data cNfDev
	data cSerDev
	data cKeyDev
	data cCustCodDev
	data cCustCNPJDev
	data cDtDev
	data cNfRetRCO
	data cSerieRetRCO
	data cKeyRetRCO
	data cCusCdRetRCO
	data cCusCNPJRetRCO
	data cDateRetRCO
	data aFileItem
	data aItensDoc
	data lError
	data cMsgError
	data cCGCCustomer
	data cCodCliFor
	data cLojCliFor
	data cFilePath
	data oLog
	data cCodCliente
	data cLojaCliente
	data lInfSD2
	data aInfSD2
	data aCHVNFE
	data lRecusa
	data lSendASN
	data cApp
	data cMensagemLog
	data cNfTempRetRCO
	data cSerieTempRetRCO
	data cTempCodCliFor
	data cTempLojCliFor
	data cFormul
	data lIsCheckedOk

	Method GetFromPartner()
	Method SetFromPartner(cFromPartner)

	Method GetToPartner()
	Method SetToPartner(cToPartner)

	Method GetSiteCNPJ()
	Method SetSiteCNPJ(cSiteCNPJ)

	Method GetNfDev()
	Method SetNfDev(cNfDev)
	
	Method GetSerDev()
	Method SetSerDev(cSerDev)

	Method GetKeyDev()
	Method SetKeyDev(cKeyDev)

	Method GetCustCodDev()
	Method SetCustCodDev(cCustCodDev)

	Method GetCustCNPJDev()
	Method SetCustCNPJDev(cCustCNPJDev)

	Method GetDtDev()
	Method SetDtDev(cDtDev)

	Method GetNfRetRCO()
	Method SetNfRetRCO(cNfRetRCO)

	Method GetSerieRetRCO()
	Method SetSerieRetRCO(cSerieRetRCO)

	Method GetKeyRetRCO()
	Method SetKeyRetRCO(cKeyRetRCO)

	Method GetCusCdRetRCO()
	Method SetCusCdRetRCO(cCusCdRetRCO)

	Method GetCusCNPJRetRCO()
	Method SetCusCNPJRetRCO(cCusCNPJRetRCO)

	Method GetDateRetRCO()
	Method SetDateRetRCO(cDateRetRCO)

	Method GetFileItem()
	Method SetFileItem(aFileItem)
	
	Method GetItensDoc()
	Method SetItensDoc(aItensDoc)
	
	Method GetMsgError()
	Method SetMsgError()
	
	Method HasError()
	Method SetError()
	
	Method PosicDocEntrad(cNf, cSerie, cCNPJCustomer)
	
	Method SetCNPJCustomer(cCustCodeRCO)
	Method GetCNPJCustumer()
	
	Method SetCodCliFor(cCodFornce)
	Method GetCodCliFor()
	
	Method GetLojCliFor()
	Method SetLojCliFor(cLojCliFor)
	
	Method GetFilePath()
	Method SetFilePath(cFilePath)
	
	Method GetCodCliente()
	Method SetCodCliente()
	
	Method GetLojaCliente()
	Method SetLojaCliente()
	
	Method SetRecusa()
	Method isRecusa(nRecno)
	
	Method SetASNSend()
	Method IsASNSend()
	
	Method GetFormul()
	Method SetFormul()
	
	Method SetApp(cApp)
	
	Method SetMensagemlog()
	
	Method CheckItens()
	Method AtualizInfDoc()
	Method SaveLog(cErro)
	Method SetLog(oLog)
	Method CheckGroupTrib(cTipo)
	Method CheckClientes()
	Method GerPedidoVend()
	Method FaturarPedido()
	Method checkInfSD2(cNfori, cSerieOri, cItemOri)
	Method hasInfSD2()
	Method GravMensagem()
	Method GravMsgSaida()
	Method AtualizNfVinc(aNota, aProd, aNfVinc)
	Method addChave(cChave)
	Method GetChaves()
	Method ExcluiNf(cAlias, nRecno, lInterface)
	Method ExcluiPedido(nRecnoSC5)
	Method getSF1_SC5_recnos(nRecno, nRecnoSF1, nRecnoSC5)
	Method EraseFields(nRecnoSF1)
	Method CheckGrpTribCliente(cCod, cLoja)
	Method classificaNf(aHeader, aDetails)
	Method loadDadosRecusa(nRecno)
	Method SaveInf()
	Method RestInf()
	Method IsCheckedOk()
	Method SetChecked()
	Method getInfNotaRCO()
	
	Method NewDHLIp210()

EndClass

/*/{Protheus.doc} NewDHLIp210
Método Construtor

@author Gustavo Luiz
@since 18/05/2017
@version 1.0
@example
(examples)
/*/
Method NewDHLIp210() CLASS DHLIp210
	
	::cFromPartner     	:= ''
	::cToPartner       	:= ''
	::cSiteCNPJ       	:= ''
	::cNfDev          	:= ''
	::cSerDev			:= ''
	::cKeyDev        	:= ''
	::cCustCodDev     	:= ''
	::cCustCNPJDev    	:= ''
	::cDtDev          	:= ''
	::cNfRetRCO       	:= ''
	::cSerieRetRCO    	:= ''
	::cKeyRetRCO      	:= ''
	::cCusCdRetRCO    	:= ''
	::cCusCNPJRetRCO  	:= ''
	::cDateRetRCO     	:= ''
	::aFileItem         := {}
	::aItensDoc			:= {}
	::lError			:= .F.
	::cMsgError			:= ''
	::cCGCCustomer		:= ''
	::cCodCliFor		:= ''
	::cLojCliFor		:= ''
	::cFilePath			:= ''
	::oLog				:= nil
	::cCodCliente		:= ''
	::cLojaCliente		:= ''
	::lInfSD2			:= .F.
	::aInfSD2			:= {}
	::aCHVNFE			:= {}
	::lRecusa			:= .F.
	::lSendASN			:= .F.
	::cApp				:= ""
	::cMensagemLog		:= ""
	::cNfTempRetRCO		:= ""
	::cSerieTempRetRCO	:= ""
	::cTempCodCliFor	:= ""
	::cTempLojCliFor	:= ""
	::cFormul			:= ""
	::lIsCheckedOk		:= .T.
	
return

/*/{Protheus.doc} GetFromPartner()
Obtém o PARTNERNAME (FROM) do XML

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetFromPartner() Class DHLIp210
Return	::cFromPartner

/*/{Protheus.doc} SetFromPartner()
Define o PARTNERNAME (FROM) do XML

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetFromPartner(cFromPartner) Class DHLIp210
	::cFromPartner:=cFromPartner
Return

/*/{Protheus.doc} GetToPartner()
Obtém o PARTNERNAME (TO) do XML

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetToPartner() Class DHLIp210
Return	::cToPartner

/*/{Protheus.doc} SetToPartner()
Define o PARTNERNAME (TO) do XML

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetToPartner(cToPartner) Class DHLIp210
	::cToPartner:=cToPartner
Return

/*/{Protheus.doc} GetSiteCNPJ()
Obtém o CNPJ do site

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetSiteCNPJ() Class DHLIp210
Return	::cSiteCNPJ

/*/{Protheus.doc} SetSiteCNPJ()
Define o CNPJ do site

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetSiteCNPJ(cSiteCNPJ) Class DHLIp210
	::cSiteCNPJ:=cSiteCNPJ
Return

/*/{Protheus.doc} GetNfDev()
Obtém a tag NF_DEV

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetNfDev() Class DHLIp210
Return	::cNfDev

/*/{Protheus.doc} SetNfDev()
Define a tag NF_DEV

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetNfDev(cNfDev) Class DHLIp210
	::cNfDev:=cNfDev
Return

/*/{Protheus.doc} GetSerDev()
Obtém a tag SERIE_DEV

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetSerDev() Class DHLIp210
Return	::cSerDev

/*/{Protheus.doc} SetSerDev()
Define a tag SERIE_DEV

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetSerDev(cSerDev) Class DHLIp210
	::cSerDev:=cSerDev
Return

/*/{Protheus.doc} GetKeyDev()
Obtém a tag KEY_DEV

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetKeyDev() Class DHLIp210
Return	::cKeyDev

/*/{Protheus.doc} SetKeyDev()
Define a tag KEY_DEV

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetKeyDev(cKeyDev) Class DHLIp210
	::cKeyDev:=cKeyDev
Return

/*/{Protheus.doc} GetCustCodDev()
Obtém a tag CUSTOMER_CODE_DEV

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetCustCodDev() Class DHLIp210
Return	::cCustCodDev

/*/{Protheus.doc} SetCustCodDev()
Define a tag CUSTOMER_CODE_DEV

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetCustCodDev(cCustCodDev) Class DHLIp210
	::cCustCodDev:=cCustCodDev
Return

/*/{Protheus.doc} GetCustCNPJDev()
Obtém a tag CUSTOMER_CNPJ_DEV

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetCustCNPJDev() Class DHLIp210
Return	::cCustCNPJDev

/*/{Protheus.doc} SetCustCNPJDev()
Define a tag CUSTOMER_CNPJ_DEV

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetCustCNPJDev(cCustCNPJDev) Class DHLIp210
	::cCustCNPJDev:=cCustCNPJDev
Return

/*/{Protheus.doc} GetDtDev()
Obtém a tag DATE_DEV

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetDtDev() Class DHLIp210
Return	::cDtDev

/*/{Protheus.doc} SetDtDev()
Define a tag DATE_DEV

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetDtDev(cDtDev) Class DHLIp210
	::cDtDev:=cDtDev
Return

/*/{Protheus.doc} GetNfRetRCO()
Obtém a tag NF_RET_RCO

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetNfRetRCO() Class DHLIp210
Return	::cNfRetRCO

/*/{Protheus.doc} SetNfRetRCO()
Define a tag NF_RET_RCO

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetNfRetRCO(cNfRetRCO) Class DHLIp210
	
	if empty(cNfRetRCO)
		
		::lError	:= .T.
		::cMsgError := "TAG <NF_RET_RCO> vazia"
		::saveLog(::cMsgError)
		
	else
		::cNfRetRCO:=cNfRetRCO
	endIf
	
Return

/*/{Protheus.doc} SetLog()
Define o log

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetLog(oLog) Class DHLIp210
	
	default oLog	  := DHLLogManager():newDHLLogManager()
	
	::oLog := oLog
return

/*/{Protheus.doc} CheckGroupTrib
Verifica se o tipo passado possui amarração a excessão fiscal

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method CheckGroupTrib(cTipo) Class DHLIp210
	
	local aItens	:= ::aFileItem
	local nI		:= 0
	local cProduto	:= ""
	local cGroupTrib:=""
	
	if cTipo == PRODUTO
		SB1->(dbSetOrder(1))
		for nI := 1 to len(aItens)
			cProduto := padr(aItens[nI][1], tamSx3("B1_COD")[1], "")
			if SB1->(dbSeek(fwxFilial("SB1") + cProduto))
				cGroupTrib := SB1->B1_GRTRIB
				if empty(cGroupTrib)
					
					::lError	:= .T.
					::cMsgError := "Produto "+allTrim(cProduto)+" não amarrado ao grupo de excessao tributária"
					::saveLog(::cMsgError)
					exit
					
				endIf
			endIf
		next nI
		
	else
	
	endIf
	
return

/*/{Protheus.doc} CheckClientes
Verifica se os clientes das notas RCO e DEV são iguais

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/
Method CheckClientes() Class DHLIp210
	
	//TODO para implementar 
	
return


/*/{Protheus.doc} GerPedidoVend
Gera o pedido de vendas

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/
Method GerPedidoVend() Class DHLIp210
	
	local aHeader		:= {}
	local aDetails		:= {}
	
	private lMsErroAuto	:= .F.
	
	aHeader := getHeaderSC5(self)
	
	if !::HasError()
		aDetails := getDetails(self)
	endIf
		
	if !::HasError()
		MSExecAuto({|x, y, z| Mata410(x, y, z)}, aHeader, aDetails, INCLUSAO)
	
		if lMsErroAuto
			DisarmTransaction()
			::lError	:= .T.
			::cMsgError := "Não foi possível criar o pedido de vendas, motivo: " + CRLF + mostraErro()
			::saveLog(::cMsgError)
		endIf
	endIf
	
return

/*/{Protheus.doc} FaturarPedido
Fatura o pedido gerado
@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method FaturarPedido() Class DHLIp210
	
	local aItens			:= ::GetItensDoc()
	local nI				:= 0
	local aPvlNfs			:= {}
	local cSerieImportacao	:= GetNewPar("ZZ_SERIRCO")
	local cNota				:= ""
	
	for nI := 1 to len(aItens)
		
		SC9->(DbSetOrder(1))
		SC9->(DbSeek(xFilial("SC9")+SC5->C5_NUM+aItens[nI][1]) )	//FILIAL+NUMERO+ITEM
		SC5->(DbSetOrder(1))
		SC5->(DbSeek(xFilial("SC5")+SC5->C5_NUM ) )					//FILIAL+NUMERO
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM+aItens[nI][1]) )	//FILIAL+NUMERO+ITEM
		SE4->(DbSetOrder(1))
		SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG) )				//FILIAL+CONDPAG
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+aItens[nI][2]) )				//FILIAL+PRODUTO
		SB2->(DbSetOrder(1))
		SB2->(DbSeek(xFilial("SB2")+aItens[nI][2]+aItens[nI][8]) )	//FILIAL+PRODUTO+LOCAL
		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES ))					//FILIAL+CODIGO
		
		aAdd( aPvlNfs , {       SC5->C5_NUM			,+;		//NUMERO PEDIDO
		SC9->C9_ITEM			,+;      					//ITEM PEDIDO
		SC9->C9_SEQUEN			,+;      					//SEQUENCIA
		SC9->C9_QTDLIB			,+;      					//QUANTIDADE
		SC6->C6_PRCVEN			,+;     					//PRECO VENDA
		SC6->C6_PRODUTO			,+;							//PRODUTO
		SF4->F4_ISS=="S"		,+;
			SC9->(RecNo())		,+;
			SC5->(RecNo())		,+;
			SC6->(RecNo())		,+;
			SE4->(RecNo())		,+;
			SB1->(RecNo())		,+;
			SB2->(RecNo())		,+;
			SF4->(RecNo())		})
		
	next nI
	
	abreTabelas()
	
	cNota     := MaPvlNfs(aPvlNfs,cSerieImportacao,.F.,.F.,.F.,.F.,.F.,0,0,.F.,.F.)
	
	if empty(cNota)
		disarmTransaction()
		::lError	:= .T.
		::cMsgError := "Não foi possível gerar a nota automática"
		::saveLog(::cMsgError)
	else
		//GravaSF2(oPegFiles, oPegFileSaida:GetChaveNf())
		//GravaSF3(oPegFiles, oPegFileSaida:GetChaveNf())
		//GravaSFT(oPegFiles, oPegFileSaida:GetChaveNf())
	endIf
	
return

/*/{Protheus.doc} checkInfSD2
Método que verifica se existe informações nos campos D2_NFORI, D2_SERIORI, D2_ITEMORI.
Chamado no PE M460FIM.prw -> Ag2MsgRegime

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method checkInfSD2() Class DHLIp210
	
	local aArea 	:= getArea()
	local aAreaSD2 	:= SD2->(getArea())
	local nPos		:= 0
	
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
	Do While !SD2->(EOF()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
	
		if !empty(SD2->D2_NFORI) .and. !empty(SD2->D2_SERIORI) .and. !empty(SD2->D2_ITEMORI)
			
			//ADICIONO AS NOTAS PARA SEREM UTILIZADAS NA GRAVAÇÃO DAS INFORMAÇÕES
			if len(::aInfSD2) == 0
				aAdd(::aInfSD2, {SD2->D2_NFORI, SD2->D2_SERIORI, SD2->D2_EMISSAO})
			else
				nPos := aScan(::aInfSD2, {|x| x[1] == SD2->D2_NFORI .and. x[2] == SD2->D2_SERIORI .and. x[3] == SD2->D2_EMISSAO})
				if nPos == 0
					aAdd(::aInfSD2, {SD2->D2_NFORI, SD2->D2_SERIORI, SD2->D2_EMISSAO})
				endIf
			endIf
			::lInfSD2 := .T.
		endIf
		
		SD2->(dbSkip())
		
	endDo
	restArea(aAreaSD2)
	restArea(aArea)
	
return

/*/{Protheus.doc} hasInfSD2
Método que que retorna se existe informações nos campos D2_NFORI, D2_SERIORI, D2_ITEMORI.
Chamado no PE M460FIM.prw -> Ag2MsgRegime

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method hasInfSD2() Class DHLIp210

return ::lInfSD2



/*/{Protheus.doc} GravMsgSaida
Método que grava mensagem. Chamado no PE M460FIM.prw -> Ag2MsgRegime

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GravMsgSaida() Class DHLIp210
	
	Local oTMsg  	:= FswTemplMsg():newTemplMsg("S",SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,"SZZ")
	Local cTes	 	:= getTesSaida()
	local cCodForm	:= ""
	 
	oTMsg:carMsg(.F.) 
	oTMsg:grvMsg()
	 
return


/*/{Protheus.doc} GravMensagem
Método que grava mensagem. Chamado no PE M460FIM.prw -> Ag2MsgRegime

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GravMensagem() Class DHLIp210
	
	Local oTMsg  		:= FswTemplMsg():newTemplMsg("E",SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,"SZZ")
	Local cQuery 		:= getQueryRecusa(SF1->(recno()))
	local oSQL	 	:= IpSqlObject():NewIpSqlObject()
	Local cTes	 	:= ""
	Local cCodForm	:= ""
	Local cMsgNFRef	:= ""
	Local aTesProces	:= {}
	Local nPos		:= 0
	
	oSQL:newAlias(cQuery)
	
	oTMsg:carMsg(.F.)
	
	while oSql:notIsEof()
	
		If Empty(cMsgNFRef)
			cMsgNFRef := getInfRCO(SD1->D1_NFORI, SD1->D1_SERIORI)
			aadd(oTMsg:aMsg, {"", cMsgNFRef})
		EndIf
		
		oSql:skip()
		
	endDo
	
	oTMsg:grvMsg()
	
return

/*/{Protheus.doc} AtualizNfVinc
Atualiza as informações do array aNfVinc

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method AtualizNfVinc(aNota, aProd, aNfVinc, aDest) Class DHLIp210
	
	local cNota 		:= aNota[2]
	local cSerie		:= aNota[1]
	local cTipoEntrSaid	:= aNota[4]
	local cCNPJCliente	:= aDest[1]
	local cCliente		:= ""
	local cLoja			:= ""
	local aArea			:= getArea()
	local aAreaSF2		:= SF2->(getArea())
	local aAreaSD2		:= SD2->(getArea())
	local cChaveSF2		:= ""
	local cCHVNFE		:= ""
	
	if cTipoEntrSaid == SAIDA
		
		ajustArray(aNfVinc)
		
		getCodCliLoja(@cCliente, @cLoja, cCNPJCliente)
	
		cChaveSF2 := fwXFilial("SF2") + cNota + cSerie + cCliente + cLoja
	
		SF2->(dbSetOrder(1))
		SD2->(dbSetOrder(3))
		if SF2->(dbSeek(cChaveSF2))
			if SD2->(dbSeek(cChaveSF2))
				while SD2->(!eof()) .and. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == cChaveSF2
					processNFVinv(Self, aNfVinc, cCNPJCliente)
					SD2->(dbSkip())
				endDo
			endIf
		endIf
	endIf
	
	restArea(aAreaSD2)
	restArea(aAreaSF2)
	restArea(aArea)

return

/*/{Protheus.doc} addChave
Adiciona a chave F2_CHVNFE no array caso não exista a chave retornando se foi inserido uma nova chave no array

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method addChave(cChave) Class DHLIp210
	
	local nPos 			:= 0
	local lAdicionado	:= .F.
	
	if len(::aCHVNFE) == 0
		aAdd(::aCHVNFE, cChave)
		lAdicionado := .T.
	else
	
		nPos := aScan(::aCHVNFE, {|x| allTrim(x) == cChave })
				
		if nPos == 0
			aAdd(::aCHVNFE, cChave)
			lAdicionado := .T.
		endIf
	endIf
	
return lAdicionado

/*/{Protheus.doc} GetChaves
Obtém a chaves (F2_CHVNFE)

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetChaves() Class DHLIp210
	
return ::aCHVNFE

/*/{Protheus.doc} ExcluiNf
Exclui a Nf

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method ExcluiNf(cAlias, nRecno, lInterface) Class DHLIp210

	local cIdDoc		:= ""
	local aCab   		:= {}
	local aItens 		:= {}
	local aRegSD2		:= {}
	local aRegSE1		:= {}
	local aRegSE2		:= {}
	local oUtils		:= IpUtilsObject():newIpUtilsObject()
	local cTeste		:= ""
	Local cMarca		:= ""
	local lCarteira		:= .F.
	local lSF2520E  	:= Existblock("SF2520E")
	private lMsErroAuto	:= .F.
	private lMsHelpAuto := .T.
	
	default	lInterface  := .F.
	
	getDadosAuto(cAlias, nRecno, @aCab, @aItens, @cIdDoc)
	
	if (cAlias == "SF2")
		lMsErroAuto := !MaCanDelF2("SF2",SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2)
		if !lMsErroAuto
			If lSF2520E
				ExecBlock("SF2520E",.F.,.F.)
			EndIf
			
			//NECESSÁRIO PARA EXCLUSÃO DO PEDIDO DE VENDAS
			if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2 .and. SF2->F2_ZZTPNF == AJUSTE_FISCAL
				lCarteira := .T.
			endIf
			lMsErroAuto := !SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,.F.,.F.,.T.,lCarteira))
		endIf
	else
		MsExecAuto({|x,y,z| MATA103(x,y,z)}, aCab, aItens, 5)
	endIf
	
	if lMsErroAuto
		
		if lInterface
			msgAlert(Alltrim("Falha ao Excluir Documento"))
		else
			oLog:fail("Falha ao Excluir Documento", cIdDoc+CRLF+oUtils:getErroAuto())
		endIf
		
	else
		if (cAlias == "SF2")
			SF2->(dbGoTo(nRecno))
			cMarca	:= GetMark(,"SF2","F2_OK")
			RecLock('SF2',.f.)
			SF2->F2_OK := cMarca
			SF2->(MsUnLock())
		endif
	endIf
	
	lMsHelpAuto := .F.
	
return !lMsErroAuto

/*/{Protheus.doc} ExcluiPedido
Exclui o pedido de vendas

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method ExcluiPedido(nRecnoSC5) Class DHLIp210

	local aArea			:= getArea()
	local aAreaSC5		:= SC5->(getArea())
	local aHeader		:= {}
	local aItens		:= {}
	private lMsErroAuto	:= .F.
	
	SC5->(dbGoTo(nRecnoSC5))
	
	aHeader := getHeaderExclSC5()
	
	MSExecAuto({ |x,y,z| Mata410(x,y,z) },aHeader,aItens,5)
	
	if lMsErroAuto
		
		::lError	:= .T.
		::cMsgError := "Não foi possível exluir o pedido de vendas. "
		
		msgAlert(Alltrim(::cMsgError) + mostraErro())
		
	endIf
	
	restArea(aAreaSC5)
	restArea(aArea)

return

/*/{Protheus.doc} getSF1_SC5_recnos
Obtém os Recnos da SF1 e SC5

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method getSF1_SC5_recnos(nRecno, nRecnoSF1, nRecnoSC5) Class DHLIp210

	local aArea 		:= getArea()
	local aAreaSF2 		:= SF2->(getArea())
	local oSQL			:= IpSqlObject():NewIpSqlObject()
	local cQuery		:= ""
	
	SF2->(DbGoTo(nRecno))
	
	cQuery := getQueryAJustImpos(nRecno)
	
	oSQL:newAlias(cQuery)
	
	nRecnoSF1 := oSQL:getValue("SF1_RECNO")
	nRecnoSC5 := oSQL:getValue("SC5_RECNO")
	
	oSQL:close()
	
	restArea(aAreaSF2)
	restArea(aArea)

return

/*/{Protheus.doc} EraseFields
Apaga os a informação das referências

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method EraseFields(nRecnoSF1) Class DHLIp210

	local cChaveSF2		:= ""
	local lposicionado 	:= .F.
	local aArea			:= getArea()
	local aAreaSF1		:= SF1->(getArea())
	local aAreaSD1		:= SD1->(getArea())
	
	SF1->(dbGoTo(nRecnoSF1))
	
	cChaveSF1:= SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
	
	begin transaction
	
		SF1->(dbSetOrder(1))
		SD1->(dbSetOrder(1))
		if SF1->(dbSeek(cChaveSF1))
			if SD1->(dbSeek(cChaveSF1))
				while SD1->(!eof()) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == cChaveSF1
					if SD1->(recLock("SD1", .F.))
						SD1->D1_ZZFLAG	:= ""
						/*SD1->D1_NFORI	:= ""
						SD1->D1_SERIORI	:= ""
						SD1->D1_ITEMORI	:= ""*/
						SD1->(msUnlock())
					endIf
					SD1->(dbSkip())
				endDo
			endIf
			/*
			if SF1->(recLock("SF1", .F.))
				SF1->F1_ZZNFDEV	:= ""
				SF1->F1_ZZSEDEV	:= ""
				SF1->F1_ZZDTDEV	:= sTod('')
				SF1->(msUnlock())
			endIf*/
		
		endIf
	
	end transaction
	
	restArea(aAreaSD1)
	restArea(aAreaSF1)
	restArea(aArea)

return

/*/{Protheus.doc} CheckGrpTribCliente()
Verifica se o cliente esta amarrado ao grupo tributário

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method CheckGrpTribCliente(cCod, cLoja) Class DHLIp210
	
	local aArea 	:= getArea()
	local aAreaSA1 	:= SA1->(getArea())
	local cGrupoTrib:= ""
	
	SA1->(dbSetOrder(1))
	if SA1->(dbSeek(FWXFilial("SA1") + cCod + cLoja))
		cGrupoTrib := SA1->A1_GRPTRIB
		
		if empty(cGrupoTrib)
		
			::lError	:= .T.
			::cMsgError := "Grupo tributário do cliente " + SA1->A1_COD + " loja " + SA1->A1_LOJA + " em branco"
			::saveLog(::cMsgError)
		
		endIf
		
	endIf
	
	restArea(aAreaSA1)
	restArea(aArea)
	
return

/*/{Protheus.doc} classificaNf
Classifica a Nf

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method classificaNf(aHeader, aDetails) class DHLIp210
	
	private lMsErroAuto := .F.
	
	if Len(aDetails) > 0
		
		MSExecAuto({ |x,y,z| MATA103(x,y,z) },aHeader,aDetails,ALTER_INVOICE)
		
		if lMsErroAuto
			::lError	:= .T.
			::cMsgError := "Falha ao classificar a Nota Fiscal de Entrada." + CRLF
			::cMsgError += mostraErro() 									+ CRLF
			disarmTransaction()
			::saveLog(::cMsgError)			
		else
			::SetRecusa(.T.)
		endif
	endif
	
return

/*/{Protheus.doc} loadDadosRecusa
Realiza o carregamento os itens e outras informações necessárias para o faturamento

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method loadDadosRecusa(nRecno) class DHLIp210
	
	local cQuery 	:= getQueryRecusa(nRecno)
	local oSQL		:= IpSqlObject():NewIpSqlObject()
	local aItensDOC	:= {}
	local aItensPed	:= {}
	local cCFNFIMP	:= GetNewPar("ZZ_CFNFIMP")
	
	oSql:newAlias(cQuery)
		
	if oSql:hasRecords()
			
		while oSql:NotIsEof()
				
				//NECESSÁRIO CAREGAR OS DADOS PARA SEREM UTILIZADOS NO PEDIDO DE VENDAS
			aAdd(aItensPed, {oSql:GetValue("D1_COD"), 	oSql:GetValue("D1_QUANT"), "", "",	"",	""})
				
			if allTrim(oSql:GetValue("D1_ZZCFOP")) $ cCFNFIMP
				aAdd(aItensDoc, {"",oSql:GetValue("D1_COD"), oSql:GetValue("D1_DOC"), oSql:GetValue("D1_SERIE"), oSql:GetValue("D1_QUANT"), oSql:GetValue("D1_VUNIT"), oSql:GetValue("D1_UM"), oSql:GetValue("D1_LOCAL") , oSql:GetValue("D1_DOC"), oSql:GetValue("D1_SERIE"), oSql:GetValue("D1_ITEM"), oSql:GetValue("D1_FORNECE"), oSql:GetValue("D1_LOJA")})
			else
				::lError	:= .T.
				::cMsgError := "CFOP não contido no parâmetro ZZ_CFNFIMP. " + "Item: " + allTrim(oSql:GetValue("D1_COD")) + "CFOP: " + oSql:GetValue("D1_ZZCFOP")
				::saveLog(::cMsgError)
			endIf
			oSql:skip()
		endDo
			
	endIf
		
	::SetItensDoc(aItensDoc)
	::SetFileItem(aItensPed)
	oSql:Close()
	
return

/*/{Protheus.doc} SaveInf
Salva informacoes temporariamente

@author Gustavo Luiz
@since 19/10/2017
@version 1.0
@example
(examples)
/*/
Method SaveInf() Class DHLIp210

	::cNfTempRetRCO		:= ::cNfRetRCO
	::cSerieTempRetRCO	:= ::cSerieRetRCO
	::cTempCodCliFor	:= ::cCodCliFor
	::cTempLojCliFor	:= ::cLojCliFor
	
return

/*/{Protheus.doc} RestInf
Restaura informacoes temporariamente

@author Gustavo Luiz
@since 19/10/2017
@version 1.0
@example
(examples)
/*/
Method RestInf() Class DHLIp210

	cNfRetRCO     := ::cNfTempRetRCO
	cSerieRetRCO  := ::cSerieTempRetRCO
	cCodCliFor    := ::cTempCodCliFor
	cLojCliFor    := ::cTempLojCliFor
	
return

/*/{Protheus.doc} IsCheckedOk()
Verifica se o check esta ok

@author Gustavo Luiz
@since 19/10/2017
@version 1.0
@example
(examples)
/*/ 
method IsCheckedOk() class DHLIp210
 
return ::lIsCheckedOk

/*/{Protheus.doc} SetChecked()
Verifica se foi checado 

@author Gustavo Luiz
@since 19/10/2017
@version 1.0
@example
(examples)
/*/ 
method SetChecked(lIsCheckedOk) class DHLIp210
	::lIsCheckedOk := lIsCheckedOk
return

/*/{Protheus.doc} GetSerieRetRCO()
Obtém a tag SERIE_RET_RCO

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetSerieRetRCO() Class DHLIp210
Return	::cSerieRetRCO

/*/{Protheus.doc} SetSerieRetRCO()
Define a tag SERIE_RET_RCO

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetSerieRetRCO(cSerieRetRCO) Class DHLIp210
	
	if empty(cSerieRetRCO)
		
		::lError	:= .T.
		::cMsgError := "TAG <SERIE_RET_RCO> vazia"
		::saveLog(::cMsgError)
		
	else
		::cSerieRetRCO:= Padr(cSerieRetRCO, TamSx3("F1_SERIE")[1], "")
	endIf
	
Return

/*/{Protheus.doc} GetKeyRetRCO()
Obtém a tag KEY_RET_RCO

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetKeyRetRCO() Class DHLIp210
Return	::cKeyRetRCO

/*/{Protheus.doc} SetKeyRetRCO()
Define a tag KEY_RET_RCO

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetKeyRetRCO(cKeyRetRCO) Class DHLIp210
	::cKeyRetRCO:=cKeyRetRCO
Return

/*/{Protheus.doc} GetCusCdRetRCO()
Obtém a tag CUSTOMER_CODE_RET_RCO

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetCusCdRetRCO() Class DHLIp210
Return	::cCusCdRetRCO

/*/{Protheus.doc} SetCusCdRetRCO()
Define a tag CUSTOMER_CODE_RET_RCO

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetCusCdRetRCO(cCusCdRetRCO) Class DHLIp210
	::cCusCdRetRCO:=cCusCdRetRCO
Return

/*/{Protheus.doc} GetCusCNPJRetRCO()
Obtém a tag CUSTOMER_CNPJ_RET_RCO

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetCusCNPJRetRCO() Class DHLIp210
Return	::cCusCNPJRetRCO

/*/{Protheus.doc} SetCusCNPJRetRCO()
Define a tag CUSTOMER_CNPJ_RET_RCO

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetCusCNPJRetRCO(cCusCNPJRetRCO) Class DHLIp210
	::cCusCNPJRetRCO:=cCusCNPJRetRCO
Return

/*/{Protheus.doc} GetDateRetRCO()
Obtém a tag DATE_RET_RCO

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetDateRetRCO() Class DHLIp210
Return	::cDateRetRCO

/*/{Protheus.doc} SetDateRetRCO()
Define a tag DATE_RET_RCO

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetDateRetRCO(cDateRetRCO) Class DHLIp210
	::cDateRetRCO:=cDateRetRCO
Return

/*/{Protheus.doc} GetFileItem()
Obtém os itens

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetFileItem() Class DHLIp210
Return	::aFileItem

/*/{Protheus.doc} SetFileItem()
Define os itens

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetFileItem(aFileItem) Class DHLIp210
	::aFileItem:=aFileItem
Return

/*/{Protheus.doc} GetItensDoc()
Obtém os itens da pré nota

@author Gustavo Luiz
@since 07/08/17
@version 1.0
@example
(examples)
/*/ 
Method GetItensDoc() Class DHLIp210
Return	::aItensDoc

/*/{Protheus.doc} SetFileItem()
Define os itens

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/ 
Method SetItensDoc(aItensDoc) Class DHLIp210
	::aItensDoc:=aItensDoc
Return


/*/{Protheus.doc} GetMsgError
Obtém a mensagem de erro.

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/
Method GetMsgError() Class DHLIp210

return ::cMsgError

/*/{Protheus.doc} SetMsgError
Define a mensagem de erro.

@author Gustavo Luiz
@since 04/08/17
@version 1.0
@example
(examples)
/*/
Method SetMsgError(cMsgError) Class DHLIp210
	::cMsgError := cMsgError
return

/*/{Protheus.doc} HasError
Restaura as áreas

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method HasError() Class DHLIp210
	
return ::lError

/*/{Protheus.doc} SetError
Define se tem erro

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SetError(lError) Class DHLIp210
	::lError := lError
return

/*/{Protheus.doc} PosicDocEntrad
Posiciona na pré nota

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method PosicDocEntrad(cNf, cSerie, cCNPJCustomer) Class DHLIP210
	
	local cCodClienteXML	:=  ""
	local cLojClienteXML	:=  ""
	local cTipoDoc			:=  ""
	
	if isFormProprio(self)
		cCNPJCustomer := alterCNPJToDHL(self)
	endIf
	
	if !::hasError()
		getCodCliente(cCNPJCustomer, self, @cCodClienteXML, @cLojClienteXML)
	endIf
	
	if !::hasError()
	
		::SetCodCliFor(cCodClienteXML)
		::SetLojCliFor(cLojClienteXML)
		
	endIf
	
return

/*/{Protheus.doc} SetCNPJCustomer
Define o CNPJ do cliente através do código SAP (A1_ZZCLSAP)

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SetCNPJCustomer(cCodigo, cTipo) Class DHLIP210
	
	local oSQL 			:= IpSqlObject():NewIPSqlObject()
	local cCustCodeRCO	:= ""
	
	if cTipo == COD_CLIENTE
		
		cCustCodeRCO := cCodigo
		oSql:newTable("SA1", "A1_CGC", "%SA1.XFILIAL% AND A1_ZZCLSAP = '" + cCustCodeRCO + " '")
	
		if oSql:HasRecords()
			::cCGCCustomer := oSql:GetValue("A1_CGC")
		else
			::lError	:= .T.
			::cMsgError := "Não foi encontrado o cliente com o código (A1_ZZALSAP): " + cCustCodeRCO
			::saveLog(::cMsgError)
		endIf
	
		oSql:Close()
	
	else
		::cCGCCustomer := cCodigo
	endIf

return

/*/{Protheus.doc} GetCNPJCustumer
Obtém o CNPJ do cliente através do código SAP (A1_ZZCLSAP)

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method GetCNPJCustumer() Class DHLIP210
	
return ::cCGCCustomer

/*/{Protheus.doc} GetFilePath
Obtém o filePatch

@author Gustavo Luiz
@since 04/08/2017
@version 1.0
@example
(examples)
/*/
Method GetFilePath() Class DHLIP210
	
return ::cFilePath

/*/{Protheus.doc} SetFilePath
Define o filePatch

@author Gustavo Luiz
@since 04/08/2017
@version 1.0
@example
(examples)
/*/
Method SetFilePath(cFilePath) Class DHLIP210
	::cFilePath :=  cFilePath
return

/*/{Protheus.doc} GetCodCliente
Obtem o código do cliente

@author Gustavo Luiz
@since 07/08/2017
@version 1.0
@example
(examples)
/*/
Method GetCodCliente() Class DHLIP210

return ::cCodCliente


/*/{Protheus.doc} SetCodCliente
Define o código do cliente

@author Gustavo Luiz
@since 07/08/2017
@version 1.0
@example
(examples)
/*/
Method SetCodCliente(cCodCliente) Class DHLIP210
	::cCodCliente := cCodCliente
return

/*/{Protheus.doc} GetLojaCliente
Obtem a loja do cliente

@author Gustavo Luiz
@since 07/08/2017
@version 1.0
@example
(examples)
/*/
Method GetLojaCliente() Class DHLIP210

return ::cLojaCliente


/*/{Protheus.doc} SetLojaCliente
Define a loja do cliente

@author Gustavo Luiz
@since 07/08/2017
@version 1.0
@example
(examples)
/*/
Method SetLojaCliente(cLojaCliente) Class DHLIP210
	::cLojaCliente := cLojaCliente
return

/*/{Protheus.doc} SetRecusa
Define se a Nf é recusa 

@author Gustavo Luiz
@since 07/08/2017
@version 1.0
@example
(examples)
/*/
Method SetRecusa(lRecusa)  Class DHLIP210
	::lRecusa := lRecusa
return

/*/{Protheus.doc} isRecusa
Obtém se é recusa

@author Gustavo Luiz
@since 07/08/2017
@version 1.0
@example
(examples)
/*/
Method isRecusa(nRecno) Class DHLIP210
	
	local aArea 		:= getArea()
	local aAreaSF2 		:= SF2->(getArea())
	local aAreaSD2 		:= SD2->(getArea())
	local aAreaSF1		:= SF1->(getArea())
	local aAreaSD1		:= SD1->(getArea())
	local cChaveSF2		:= ""
	local cNfOri		:= ""
	local cSerOri		:= ""
	local cFormulPro	:= ""
	local cQuery		:= ""
	
	if nRecno > 0
	
		SF1->(DbSetOrder(1))
		SF1->(DbGoTo(nRecno))
		if SF1->F1_FORMUL == PROPRIO
			::SetRecusa(.T.)
		endIf
	
	endIf
	
	restArea(aAreaSD1)
	restArea(aAreaSF1)
	restArea(aAreaSD2)
	restArea(aAreaSF2)
	restArea(aArea)
	
return ::lRecusa

/*/{Protheus.doc} SetASNSend
Define se foi realizado o processo do ASN

@author Gustavo Luiz
@since 07/08/2017
@version 1.0
@example
(examples)
/*/
Method SetASNSend(lSendASN) Class DHLIP210
	::lSendASN := lSendASN
return

/*/{Protheus.doc} isASNSend
Obtém se foi enviado a ASN

@author Gustavo Luiz
@since 07/08/2017
@version 1.0
@example
(examples)
/*/
Method isASNSend(nRecno) Class DHLIP210
	
	local aArea 		:= getArea()
	local aAreaSF2 		:= SF2->(getArea())
	local aAreaSD2 		:= SD2->(getArea())
	local aAreaSF1		:= SF1->(getArea())
	local aAreaSD1		:= SD1->(getArea())
	
	if nRecno > 0
	
		SF1->(DbSetOrder(1))
		SF1->(DbGoTo(nRecno))
		if allTrim(SF1->F1_ZZSTATUS) == ""
			::SetASNSend(.T.)
		else
			::lError	:= .T.
			::cMsgError := "ASN não enviada."
			::saveLog(::cMsgError)
		endIf
	
	endIf
	
	restArea(aAreaSD1)
	restArea(aAreaSF1)
	restArea(aAreaSD2)
	restArea(aAreaSF2)
	restArea(aArea)
	
return ::lSendASN

/*/{Protheus.doc} GetFormul
Obtém se é formulário próprio

@author Gustavo Luiz
@since 19/10/2017
@version 1.0
@example
(examples)
/*/
Method GetFormul() Class DHLIP210
	
return ::cFormul

/*/{Protheus.doc} GetFormul
Define se é formulário próprio

@author Gustavo Luiz
@since 19/10/2017
@version 1.0
@example
(examples)
/*/
Method SetFormul(cFormul) Class DHLIP210
	::cFormul := cFormul
return


/*/{Protheus.doc} SetApp
Define a aplicação

@author Gustavo Luiz
@since 04/08/2017
@version 1.0
@example
(examples)
/*/
Method SetApp(cApp) Class DHLIP210
	::cApp := cApp
return

/*/{Protheus.doc} SetMensagemLog
Define a mensagem que aparecerá no campo Z2_MSG do log

@author Gustavo Luiz
@since 04/08/2017
@version 1.0
@example
(examples)
/*/
Method SetMensagemLog(cMensagemLog) Class DHLIP210
	::cMensagemLog := cMensagemLog
return

/*/{Protheus.doc} CheckItens
Checa os itens da pré nota com os itens do XML

@author Gustavo Luiz
@since 04/08/2017
@version 1.0
@example
(examples)
/*/
Method CheckItens(lCheckFormul) Class DHLIP210
	
	local cQuery 			:= getQueryDoc(self)
	local oSql	 			:= IpSqlObject():NewIpSqlObject()
	local cQtdItens			:= 0
	local cCod				:= ""
	local cItem				:= ""
	local nQuant			:= 0
	local nCountItensDoc	:= ""
	local aItensXML			:= ::aFileItem
	local nPos				:= 0
	local aItensDoc			:= {}
	local lOk				:= .T.
	
	default lCheckFormul	:= .F.
	
	oSql:NewAlias(cQuery)
	
	nCountItensDoc := oSql:count()
	
	if len(aItensXML) == nCountItensDoc
		while oSql:NotIsEof()
			
			cItem	:= oSql:GetValue("D1_ITEM")
			cCod 	:= oSql:GetValue("D1_COD")
			nQuant	:= oSql:GetValue("D1_QUANT")
			
			nPos	:= aScan(aItensXML, {|x| allTrim(x[POS_PRODUTO]) == allTrim(cCod) .and. x[POS_QUANTIDADE] == nQuant })
			
			if nPos == 0
				::SetCheckedOk(.F.)
				if !lCheckFormul
					::lError	:= .T.
					::cMsgError := "";
						+"Não foi encontrado o produto/quantidade "+allTrim(cCod)+"/" + cValToChar(nQuant);
						+" no XML pertencente a nota: " + allTrim(::GetNfRetRCO()) + " série: " + allTrim(::GetSerieRetRCO()) + " fornecedor/cliente: " + allTrim(::GetCodCliFor())
					
					::saveLog(::cMsgError)
				endIf
				exit
			else
				::SetCheckedOk(.T.)
			endIf
			
			oSql:skip()
		
		endDo
		
	else
		::SetCheckedOk(.F.)
		if !lCheckFormul
			::lError	:= .T.
			::cMsgError := "Quantidade dos itens divergentes. XML: " + cValToChar(len(aItensXML)) + ". Pré nota: " + cValToChar(nCountItensDoc)
			::saveLog(::cMsgError)
		endIf
	endIf
	
	oSql:close()
		 
return ::IsCheckedOk()

/*/{Protheus.doc} SetCodCliFor
Define o código do fornecedor/cliente definido no método PosicDocEntrad()

@author Gustavo Luiz
@since 04/08/2017
@version 1.0
@example
(examples)
/*/
Method SetCodCliFor(cCodCliFor) Class DHLIP210
	
	::cCodCliFor := cCodCliFor
	
return

/*/{Protheus.doc} GetCodCliFor
Obtém o código do fornecedor definido no método PosicDocEntrad()

@author Gustavo Luiz
@since 04/08/2017
@version 1.0
@example
(examples)
/*/
Method GetCodCliFor() Class DHLIP210
	
return ::cCodCliFor

/*/{Protheus.doc} GetLojCliFor
Obtém a loja do fornecedor definido no método PosicDocEntrad()

@author Gustavo Luiz
@since 04/08/2017
@version 1.0
@example
(examples)
/*/
Method GetLojCliFor() Class DHLIP210

return ::cLojCliFor


/*/{Protheus.doc} SetLojCliFor
define a loja do fornecedor/cliente definido no método PosicDocEntrad()

@author Gustavo Luiz
@since 04/08/2017
@version 1.0
@example
(examples)
/*/
Method SetLojCliFor(cLojCliFor) Class DHLIP210
	
	::cLojCliFor := cLojCliFor
	
return

/*/{Protheus.doc} AtualizInfDoc
Atualiza os campos F1_ZZNFDEV, F1_ZZSEDEV, F1_ZZDTDEV, D1_NFORI, D1_SERIORI, D1_ITEMORI

@author Gustavo Luiz
@since 04/08/2017
@version 1.0
@example
(examples)
/*/
Method AtualizInfDoc() Class DHLIP210
	
	local oSql 			:= IpSqlObject():newIpSqlObject()
	local aItensXML		:= ::GetFileItem()
	local aItensDOC		:= {}
	local cQuery		:= ""
	local nSF1Recno 	:= 0
	local nSD1Recno		:= 0
	local cCodProduto 	:= ""
	local nQuant		:= 0
	local cNfOri		:= ""
	local cSerieOri		:= ""
	local cItemOri		:= ""
	local aHeader		:= {}
	local aDetails		:= {}
	local lIsSendAsn	:= .F.
	local nI			:= 0
	
	cQuery := getQueryDoc(self)
	
	SF1->(dbSetOrder(1))
	SD1->(dbSetOrder(1))
	
	oSql:newAlias(cQuery)
	
	if !oSql:hasRecords()
		getCodFornecedor(self)
		cQuery := getQueryDoc(self)
		oSql:newAlias(cQuery)
	endIf
	
	begin transaction
	
		if oSql:hasRecords()
		
			nSF1Recno := oSql:getValue("SF1_RECNO")
			SF1->(DbGoto(nSF1Recno))
			
			lIsSendAsn := isSendASN()
			
			if !lIsSendAsn
				
				::lError	:= .T.
				::cMsgError := " Não foi realizado o processo da ASN. Ip210 não processada. "
				::saveLog(oDHLIP210:getMsgError())
				
			endIf
			
			if SF1->(recLock("SF1", .F.)) .and. lIsSendAsn
		
				SF1->F1_ZZNFDEV := ::GetNfDev()
				SF1->F1_ZZSEDEV := ::GetSerDev()
				SF1->F1_ZZDTDEV := sToD(::GetDtDev())
		
				SF1->(msUnLock())
			
			endIf
			
			if SF1->F1_FORMUL == PROPRIO .and. lIsSendAsn
				aHeader := getHeadSF1()
			endIf
	
		endIf
	
		oSql:close()
		
		if lIsSendAsn
			for nI := 1 to len(aItensXML)
				if !oDHLIP210:hasError()
					cCodProduto := aItensXML[nI][ITEM]
					nQuant		:= aItensXML[nI][QUANTITY]
		
					cQuery := getQueryDoc(self, cCodProduto, nQuant)
		
					oSql:newAlias(cQuery)
		
					while oSql:NotIsEof()
			
						nSD1Recno := oSql:getValue("SD1_RECNO")
						SD1->(DbGoto(nSD1Recno))
					
						cNfOri			:= SD1->D1_NFORI
						cSerieOri		:= SD1->D1_SERIORI
						cItemOri		:= SD1->D1_ITEMORI
						
						//if empty(cNfOri) .and. empty(cSerieOri) .and. empty(cItemOri)
						If empty(SD1->D1_ZZFLAG)
			
							if SD1->(recLock("SD1", .F.))
								SD1->D1_NFORI 	:= aItensXML[nI][NF_REF_RCO]
								SD1->D1_SERIORI	:= aItensXML[nI][SERIE_REF_RCO]
								SD1->D1_ITEMORI	:= Right(AllTrim(aItensXML[nI][ITEM_REF_RCO]),2)
								SD1->D1_ZZFLAG	:= "S"
						//01º posição reservado ao nº do item
						//02º posicao reservado ao código do produto
						//03º posicao reservado a NF
						//04º posicão reservada a série
						//05º posicão reservada a quantidade
						//06º posicão reservado ao valor unitário
						//07º posicão reservado a unidade de medida
						//08º posicão reservado ao local
						//09º posicão reservada a NF de orig
						//10º posicão reservada a serie de orig.
						//11º posicão reservado ao item de orig.
						//12º posicão reservado ao fornecedor.
						//13º posicão reservado a loja.
				
								aAdd(aItensDoc, {"",oSql:GetValue("D1_COD"), oSql:GetValue("D1_DOC"), oSql:GetValue("D1_SERIE"), oSql:GetValue("D1_QUANT"), oSql:GetValue("D1_VUNIT"), oSql:GetValue("D1_UM"), oSql:GetValue("D1_LOCAL") , oSql:GetValue("D1_DOC"), oSql:GetValue("D1_SERIE"), oSql:GetValue("D1_ITEM"), oSql:GetValue("D1_FORNECE"), oSql:GetValue("D1_LOJA")})
								::SetItensDoc(aItensDoc)
				
								SD1->(msUnLock())
						
								if SF1->F1_FORMUL == PROPRIO
									getSD1Details(aDetails)
								endIf
						
							endIf
						else
							disarmTransaction()
							oDHLIP210:lError	:= .T.
							oDHLIP210:cMsgError := "Interface para o documento/serie " + SF1->F1_DOC + "/" + SF1->F1_SERIE +  " já processada "
							oDHLIP210:saveLog(oDHLIP210:getMsgError())
						endIf
						oSql:close()
						exit
					endDo
					oSql:close()
				endIf
			next nI
		
		endIf
		
		if SF1->F1_FORMUL == PROPRIO .and. lIsSendAsn
			::classificaNf(aHeader, aDetails)
		endIf
	
	end Transaction
	
return

/*/{Protheus.doc} SaveLog
Salva o log

@author Gustavo Luiz
@since 04/08/2017
@version 1.0
@example
(examples)
/*/
Method SaveLog(cErro) Class DHLIP210
	
	::oLog:start(::cApp,DHL_IMPORTACAO,::cFilePath)
	::oLog:fail(::cMensagemLog,cErro)
	
return

/*/{Protheus.doc} getInfNotaRCO
Obtém as informações da nota de vendas RCO

@author Gustavo Luiz
@since 19/10/2017
@version 1.0
@example
(examples)
/*/
Method getInfNotaRCO(cDoc, cSerie, cForne, cLoja, cTipoNota, cPedido) Class DHLIP210
	
	local aArea 	:= getArea()
	local aAreaSF2	:= SF2->(getArea())
	local aAreaSD2	:= SD2->(getArea())
	local cNfOri	:= ""
	local cSerieOri	:= ""
	local aRetorno	:= {}
	local cNfOri	:= ""
	local cSerieOri	:= ""
	local cMsg		:= ""
	
	default cTipoNota := ""
	default cPedido   := ""	
	
	aRetorno := getNfOriF2(cDoc, cSerie, cForne, cLoja)
	
	if len(aRetorno)>1
	
		cNfOri 		:= aRetorno[NOTA_ORIGEM]
		cSerieOri	:= aRetorno[SERIE_ORIGEM]
		
		aRetorno 	:= getNfOriF1(cNfOri, cSerieOri)
		
		if len(aRetorno)>1
			cNfOri 		:= aRetorno[NOTA_ORIGEM]
			cSerieOri	:= aRetorno[SERIE_ORIGEM]
			
			cMsg := getInfRCO(cNfOri, cSerieOri, cTipoNota, cPedido)
			
		endIf
		
	endIf
	
	
	restArea(aAreaSD2)
	restArea(aAreaSF2)
	restArea(aArea)

return cMsg

/**
* Obtém o código/loja do cliente a partir do CNPJ do cliente
**/
static function getCodCliente(cCNPJCustomer, oDHLIP210, cCodClienteXML, cLojClienteXML)
	
	local oSQL 			:= IpSqlObject():NewIPSqlObject()
	
	oSql:newTable("SA1", "A1_COD, A1_LOJA", "%SA1.XFILIAL% AND A1_CGC = '" + cCNPJCustomer + " '")
	
	if oSql:HasRecords()
		cCodClienteXML := oSql:GetValue("A1_COD")
		cLojClienteXML := oSql:GetValue("A1_LOJA")
	else
		oDHLIP210:lError	:= .T.
		oDHLIP210:cMsgError := "Não foi encontrado o cliente com o CGC : " + cCNPJCustomer
		oDHLIP210:saveLog(oDHLIP210:getMsgError())
	endIf
	
	oSql:Close()
	
return

/**
* Obtém a query responsável em obter os itens da pré nota
**/
static function getQueryDoc(oDHLIP210, cCodProduto, nQuant)
	
	local cQuery 		:= ""
	
	default cCodProduto := ""
	default nQuant		:= 0
	
	cQuery := "	SELECT "														+ CRLF
	cQuery += "		SD1.D1_ITEM , SD1.D1_COD, SD1.D1_QUANT, SD1.D1_DOC,"		+ CRLF
	cQuery += "		SD1.D1_SERIE , SD1.D1_VUNIT, SD1.D1_LOCAL, SD1.D1_UM,"		+ CRLF
	cQuery += "		SF1.R_E_C_N_O_ SF1_RECNO,  SD1.R_E_C_N_O_ SD1_RECNO, "		+ CRLF
	cQuery += "		SF1.F1_ZZNFDEV, SF1.F1_ZZSEDEV, SF1.F1_ZZDTDEV, "			+ CRLF
	cQuery += "		SD1.D1_NFORI, SD1.D1_SERIORI, SD1.D1_ITEMORI,"				+ CRLF
	cQuery += "		SD1.D1_FORNECE, SD1.D1_LOJA"								+ CRLF
	cQuery += "	FROM %SF1.SQLNAME% " 											+ CRLF
	cQuery += "	INNER JOIN %SD1.SQLNAME% ON 1 = 1" 								+ CRLF
	cQuery += "		AND SD1.D1_FILIAL = SF1.F1_FILIAL" 							+ CRLF
	cQuery += "		AND D1_DOC = F1_DOC" 										+ CRLF
	cQuery += "		AND D1_SERIE = F1_SERIE" 									+ CRLF
	cQuery += "		AND D1_FORNECE = F1_FORNECE" 								+ CRLF
	cQuery += "		AND %SD1.NOTDEL%"           								+ CRLF
	cQuery += "	WHERE 1 = 1" 													+ CRLF
	cQuery += "		AND SF1.F1_FILIAL = '%SF1.FILIAL%' " 						+ CRLF
	cQuery += "		AND %SF1.NOTDEL%"           								+ CRLF
	cQuery += "		AND F1_DOC = '"+oDHLIP210:GetNfRetRCO()+"'"     			+ CRLF
	cQuery += "		AND F1_SERIE = '"+oDHLIP210:GetSerieRetRCO()+"'"			+ CRLF
	cQuery += "		AND F1_FORNECE ='"+oDHLIP210:GetCodCliFor()+"'"				+ CRLF
	cQuery += "		AND F1_LOJA ='"+oDHLIP210:GetLojCliFor()+"'"				+ CRLF
	if !empty(cCodProduto) .and. nQuant != 0
		cQuery += "	AND D1_COD = '"+cCodProduto+"'" 							+ CRLF
		cQuery += "	AND D1_QUANT = "+cValToChar(nQuant)+"" 						+ CRLF
		//cQuery += "	AND D1_NFORI||D1_SERIORI||D1_ITEMORI = ' ' "				+ CRLF
	endIf
	
	cQuery += "	ORDER BY D1_ITEM"												+ CRLF
	
return cQuery

/**
* Obtém as informações contidas no array aFileItem
**/
static function getInforItens(oDHLIP210,  cProd, nQuant , nPosArray)
	
	local nPos 			:= 0
	local aItens 		:= oDHLIP210:GetFileItem()
	local cInformacao	:= ""
	
	nPos := aScan(aItens, {|x| allTrim(x[1]) == allTrim(cProd) .and. x[2] == nQuant})
	
	if nPos != 0
		cInformacao :=  aItens[nPos][nPosArray]
	endIf
	
return cInformacao


/**
* Obtém os dados do cabeçalho
**/
static function getHeaderSC5(oDHLIP210)
	
	local aHeader 	:= {}
	local cCondPag	:= GetNewPar("ZZ_CONDINT")
	
	getCliLoja(oDHLIP210)
	
	oDHLIP210:CheckGrpTribCliente(oDHLIP210:getCodCliente(), oDHLIP210:getLojaCliente())
	
	if !oDHLIP210:hasError()
	
		aAdd(aHeader,{"C5_FILIAL"  ,xFilial("SC5")   					,nil})
		aAdd(aHeader,{"C5_TIPO" 	,"N"   								,nil})
		aAdd(aHeader,{"C5_CLIENTE"  ,oDHLIP210:getCodCliente()  		,nil})
		aAdd(aHeader,{"C5_LOJACLI"  ,oDHLIP210:getLojaCliente()   		,nil})
		aAdd(aHeader,{"C5_CONDPAG"  ,cCondPag 							,nil})
		aAdd(aHeader,{"C5_TIPOCLI"  ,"S" 								,nil})
		aAdd(aHeader,{"C5_TPFRETE"	,"S"								,nil})
		aAdd(aHeader,{"C5_ZZTPPV"   ,"6"								,nil})
		
		aHeader := FwVetByDic(aHeader, "SC5")
	
	endIf
	
return aHeader

/**
* Obtém os dados dos itens para a geração do pedido de vendas
**/
static function getDetails(oDHLIP210)

	local aDetail  		:= {}
	local aDetails		:= {}
	local aItensDoc		:= oDHLIP210:GetItensDoc()
	local nI			:= 0
	Local cItem			:= StrZero(0,TamSx3("C6_ITEM")[1])
	local nValorTotal 	:= 0
	local cTes			:= GetNewPar("ZZ_TEAJIMP")
	
	for nI := 1 To Len(aItensDoc)
		
		aDetail := {}
		
		cItem 			:= Soma1(cItem)
		aItensDoc[nI][1]:= cItem
		
		aAdd(aDetail, {"C6_FILIAL"		, xFilial("SC6")  , nil})
		aAdd(aDetail, {"C6_ITEM"		, aItensDoc[nI][01], nil})
		aAdd(aDetail, {"C6_PRODUTO"		, aItensDoc[nI][02], nil})
		aAdd(aDetail, {"C6_QTDVEN"		, aItensDoc[nI][05], nil})
		aAdd(aDetail, {"C6_PRCVEN"		, aItensDoc[nI][06], nil})
		
		nValorTotal := round(aItensDoc[nI][5] * aItensDoc[nI][06], 2)
		
		aAdd(aDetail, {"C6_VALOR"		, nValorTotal  		, nil})
		aAdd(aDetail, {"C6_UM"			, aItensDoc[nI][07] , nil})
		aAdd(aDetail, {"C6_LOCAL"		, aItensDoc[nI][08] , nil})
		aAdd(aDetail, {"C6_NFORI"		, aItensDoc[nI][09] , nil})
		aAdd(aDetail, {"C6_SERIORI"		, aItensDoc[nI][10] , nil})
		aAdd(aDetail, {"C6_ITEMORI"		, aItensDoc[nI][11] , nil})
		aAdd(aDetail, {"C6_ZZFOROR"		, aItensDoc[nI][12] , nil})
		aAdd(aDetail, {"C6_ZZLOJOR"		, aItensDoc[nI][13] , nil})
		aAdd(aDetail, {"C6_TES"			, cTes				, nil})
		
		aDetail := FwVetByDic(aDetail, "SC6")
		
		aAdd(aDetails,aDetail)
		
	next nI

return aDetails

/**
* Obtém o cliente/loja através da amarração PRODUTO x CLIENTE para a geração do pedido de vendas
**/
static function getCliLoja(oDHLIP210)
	
	local oSQL 		:= IpSqlObject():newIpSqlObject()
	local cQuery 	:= ""
	local aItens	:= oDHLIP210:GetFileItem()
	local cProduto	:= aItens[1][ITEM]
	
	oSql:newTable("SA7", "*", "%SA7.XFILIAL% AND A7_PRODUTO = '" + cProduto + " '")
	
	if oSql:hasRecords()
		
		oDHLIP210:SetCodCliente(oSql:getValue("A7_CLIENTE"))
		oDHLIP210:SetLojaCliente(oSql:getValue("A7_LOJA"))
		
	else
	
		oDHLIP210:lError	:= .T.
		oDHLIP210:cMsgError := "Não foi encontrado amarração do produto x cliente. Produto: "+allTrim(cProduto)+" "
		oDHLIP210:saveLog(::cMsgError)
		
	endIf
	
	oSql:close()
	
return

/**
* Obtém registros do produto x clientes
**/
static function getQrySA7(cProduto)
	
	local cQuery 		:= ""
	
	oSql:newTable("SA7", "*", "%SA7.XFILIAL% AND A7_PRODUTO = '" + cProduto + " '")
	
	if oSql:hasRecords()
		
		::SetCodCliente(oSql:getValue("A7_CLIENTE"))
		::SetLojaCliente(oSql:getValue("A7_CLIENTE"))
		
	else
	
		::lError	:= .T.
		::cMsgError := "Não foi encontrado amarração do produto x cliente. Produto: "+allTrim(cProduto)+" "
		::saveLog(::cMsgError)
		
	endIf
	
	oSql:close()
	
return cQuery

/**
* Abre as tabelas. Necessário, pois na segunda iteração da nota estava dando ajustar DOC_SEQ.
* É necessário abrir as 3 tabelas
**/
static function abreTabelas()
	
	local lStatus := .F.
	
	If Select('SD1') <= 0
		dbSelectArea('SD1')
	EndIf
	If Select('SD2') <= 0
		dbSelectArea('SD2')
	EndIf
	If Select('SD3') <= 0
		dbSelectArea('SD3')
	EndIf
	
	lStatus := (Select('SD1')>0) .And. (Select('SD2')>0) .And. (Select('SD3')>0)
	
return

/*
** Grava informação na tabela de template Mensagens NF (SZZ)
*/
static function fGravaMsg(cNota, cSerie, cClieFor, cLoja, cMsg)
	Local oTMsg  := FswTemplMsg():newTemplMsg("E", cNota, cSerie, cClieFor, cLoja,"SZZ")
	
	aadd(oTMsg:aMsg, {"",cMsg})
	
	oTMsg:grvMsg()
	
return

/*
** Obtém o código do cliente e loja 
*/
static function getCodCliLoja(cCliente, cLoja, cCNPJCliente)
	
	local oSql := IpSqlObject():newIpSqlObject()
	
	oSql:newTable("SA1", "A1_COD, A1_LOJA", "%SA1.XFILIAL% AND A1_CGC = '" + cCNPJCliente + " '")
	
	if oSql:hasRecords()
		
		cCliente := oSql:getValue("A1_COD")
		cLoja 	 := oSql:getValue("A1_LOJA")
		
	endIf
	
	oSql:close()

return

/*
** Obtém a query do documento de saída
*/
static function getQueryNFSaida(cCliente, cLoja, cNota, cSerie, cDataEmissao, cTipoNota, cHora)
	
	local cQuery := ""
	
	cQuery := "	SELECT "														+ CRLF
	cQuery += "		SD2.D2_ITEM , SD2.D2_COD, SD2.D2_QUANT, SD2.D2_DOC,"		+ CRLF
	cQuery += "		SD2.D2_SERIE , SD2.D2_PRCVEN, SD2.D2_LOCAL, SD2.D2_UM,"		+ CRLF
	cQuery += "		SF2.R_E_C_N_O_ SF2_RECNO,  SD2.R_E_C_N_O_ SD2_RECNO, "		+ CRLF
	cQuery += "		SD2.D2_NFORI, SD2.D2_SERIORI, SD2.D2_ITEMORI  "				+ CRLF
	cQuery += "	FROM %SF2.SQLNAME% " 											+ CRLF
	cQuery += "	INNER JOIN %SD2.SQLNAME% ON 1 = 1" 								+ CRLF
	cQuery += "		AND SD2.D2_FILIAL = SF2.F2_FILIAL" 							+ CRLF
	cQuery += "		AND D2_DOC = F2_DOC" 										+ CRLF
	cQuery += "		AND D2_SERIE = F2_SERIE" 									+ CRLF
	cQuery += "		AND D2_CLIENTE = F2_CLIENTE" 								+ CRLF
	cQuery += "		AND %SD2.NOTDEL%"           								+ CRLF
	cQuery += "	WHERE 1 = 1" 													+ CRLF
	cQuery += "		AND SF2.F2_FILIAL = '%SF2.FILIAL%' " 						+ CRLF
	cQuery += "		AND %SF2.NOTDEL%"           								+ CRLF
	cQuery += "		AND F2_DOC = '"+cNota+"'"     								+ CRLF
	cQuery += "		AND F2_SERIE = '"+cSerie+"'"								+ CRLF
	cQuery += "		AND F2_CLIENTE='"+cCliente+"'"								+ CRLF
	cQuery += "		AND F2_LOJA ='"+cLoja+"'"									+ CRLF
	cQuery += "	ORDER BY D2_ITEM"												+ CRLF

return cQuery


/*
** Posiciona na Nf de origem a partir da D2_NFORI e D2_SERIORI e atualiza o array aNfVinc
*/
static function processNFVinv(oDHLIP210, aNfVinc, cCNPJCliente)
	
	local aArea 		:= getArea()
	local aAreaSF2 		:= SF2->(getArea())
	local aAreaSD2 		:= SD2->(getArea())
	local aAreaSF1		:= SF1->(getArea())
	local aAreaSD1		:= SD1->(getArea())
	local cNotaOri		:= ""
	local cSerieOri		:= ""
	local dDtNfOri		:= sTod('')
	local cCHVNFE		:= ""
	local cFornOrig		:= ""
	local cLojaFornOrig	:= ""
	local cCNPJFornec	:= ""
	
	SF1->(dbSetOrder(1))
	
	getFornLojaOrig(@cFornOrig, @cLojaFornOrig)
	cCNPJFornec := getCNPJ(cFornOrig, cLojaFornOrig)
	if SF1->(dbSeek(fwXFilial("SF1") + SD2->D2_NFORI + SD2->D2_SERIORI + cFornOrig + cLojaFornOrig))
		
		dDtNfOri	:= SF1->F1_EMISSAO
		cCHVNFE 	:= SF1->F1_CHVNFE
		cNotaOri	:= SF1->F1_DOC
		cSerieOri	:= SF1->F1_SERIE
		
		nPos := aScan(aNfVinc, {|x| x[DOC] == cNotaOri .and. x[SERIE] == cSerieOri .and. empty(x[CHAVENFE]) })
		
		if nPos > 0
			
			aNfVinc[nPos][EMISSAO] 	:= SF1->F1_EMISSAO
			aNfVinc[nPos][SERIE] 	:= SF1->F1_SERIE
			aNfVinc[nPos][DOC] 		:= SF1->F1_DOC
			aNfVinc[nPos][CNPJ] 		:= cCNPJFornec
			aNfVinc[nPos][ESTCOB] 	:= SF1->F1_EST
			aNfVinc[nPos][ESPECIE] 	:= SF1->F1_ESPECIE
			aNfVinc[nPos][CHAVENFE]	:= cCHVNFE
			
		else
			nPos := aScan(aNfVinc, {|x| x[CHAVENFE] == cCHVNFE })
			if nPos == 0
				aAdd( aNfVinc, { SF1->F1_EMISSAO, SF1->F1_SERIE, SF1->F1_DOC, cCNPJFornec, SF1->F1_EST, SF1->F1_ESPECIE, cCHVNFE } )
			endIf
		endIf
	endIf
	
	restArea(aAreaSD1)
	restArea(aAreaSF1)
	restArea(aAreaSD2)
	restArea(aAreaSF2)
	restArea(aArea)
	
return

/*
** Posiciona na Nf de origem a partir da D2_NFORI e D2_SERIORI e atualiza o array aNfVinc
*/
static function old_processNFVinv(oDHLIP210, aNfVinc)
	
	local aArea 	:= getArea()
	local aAreaSF2 	:= SF2->(getArea())
	local aAreaSD2 	:= SD2->(getArea())
	local aAreaSF1	:= SF1->(getArea())
	local aAreaSD1	:= SD1->(getArea())
	local cCHVNFE	:= ""
	
	SF1->(dbSetOrder(1))
		
	if SF1->(dbSeek(fwXFilial("SF1") + SD2->D2_NFORI + SD2->D2_SERIORI))
		
		cCHVNFE := SF1->F1_CHVNFE
		
		if oDHLIP210:addChave(cCHVNFE)
			aAdd( aNfVinc, { SF2->F2_EMISSAO, SF2->F2_SERIE, SF2->F2_DOC, SM0->M0_CGC, SM0->M0_ESTCOB, SF2->F2_ESPECIE, cCHVNFE } )
		endIf
		
	endIf
	
	restArea(aAreaSD1)
	restArea(aAreaSF1)
	restArea(aAreaSD2)
	restArea(aAreaSF2)
	restArea(aArea)
	
return

/*
** Obtém o código e loja do fornecedor de origem que esta gravado na SC6
*/
static function getFornLojaOrig(cFornOrig, cLojaFornOrig)
	
	local aArea 	:= getArea()
	local aAreaSC5	:= SC5->(getArea())
	local aAreaSC6	:= SC6->(getArea())
	
	SC5->(dbSetOrder(1))
	SC6->(dbSetOrder(2))
	if SC5->(dbSeek(fwxFilial("SC5") + SD2->D2_PEDIDO))
		
		if SC6->(dbSeek(fwxFilial("SC6") + SD2->D2_COD + SD2->D2_PEDIDO))
			
			cFornOrig 		:= SC6->C6_ZZFOROR
			cLojaFornOrig	:= SC6->C6_ZZLOJOR
			
		endIf
		
	endIf
	
	restArea(aAreaSC6)
	restArea(aAreaSC5)
	restArea(aArea)

return

/**
* Coleta os dados para as Rotinas Automáticas de Exclusão
*/
static function getDadosAuto(cAlias, nRecno, aCab, aItens, cIdDoc)
	
	local aItem := {}
	local oSql  := IpSqlObject():newIpSqlObject()
	
	aCab   := {}
	aItens := {}
	
	if (cAlias == "SF2")
		
		SF2->(dbGoTo(nRecno))
		
		cIdDoc := "Tipo: Saída"+CRLF
		cIdDoc += "Documento: "+SF2->F2_DOC+CRLF
		cIdDoc += "Série: "+SF2->F2_SERIE+CRLF
		
		aAdd(aCab, {"F2_FILIAL", SF2->F2_FILIAL, nil})
		aAdd(aCab, {"F2_DOC", SF2->F2_DOC, nil})
		aAdd(aCab, {"F2_SERIE", SF2->F2_SERIE, nil})
		
	elseIf (cAlias == "SF1")
		
		SF1->(dbGoTo(nRecno))
		
		cIdDoc := "Tipo: Entrada"+CRLF
		cIdDoc += "Documento: "+SF1->F1_DOC+CRLF
		cIdDoc += "Série: "+SF1->F1_SERIE+CRLF
		cIdDoc += "Cliente/Fornecedor: "+SF1->F1_FORNECE+CRLF
		cIdDoc += "Loja: "+SF1->F1_LOJA+CRLF
		
		aAdd(aCab, {"F1_FILIAL", SF1->F1_FILIAL, nil})
		aAdd(aCab, {"F1_DOC", SF1->F1_DOC, nil})
		aAdd(aCab, {"F1_SERIE", SF1->F1_SERIE, nil})
		aAdd(aCab, {"F1_FORNECE", SF1->F1_FORNECE, nil})
		aAdd(aCab, {"F1_LOJA", SF1->F1_LOJA, nil})
		aAdd(aCab, {"F1_TIPO", SF1->F1_TIPO, nil})
		aAdd(aCab, {"F1_FORMUL", SF1->F1_FORMUL, nil})
		aAdd(aCab, {"F1_EMISSAO", SF1->F1_EMISSAO, nil})
		aAdd(aCab, {"F1_COND", SF1->F1_COND, nil})
		
		oSql:newTable("SD1", "D1_ITEM,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_TES",;
			"D1_FILIAL = '"+SF1->F1_FILIAL+"' AND D1_DOC = '"+SF1->F1_DOC+"' AND "+;
			"D1_SERIE = '"+SF1->F1_SERIE+"' AND D1_FORNECE = '"+SF1->F1_FORNECE+"' AND "+;
			"D1_LOJA = '"+SF1->F1_LOJA+"' AND D1_TIPO = '"+SF1->F1_TIPO+"' ")
		
		while oSql:notIsEof()
			aItem := {}
			aAdd(aItem, {"D1_ITEM", oSql:getValue("D1_ITEM"), nil})
			aAdd(aItem, {"D1_COD", oSql:getValue("D1_COD"), nil})
			aAdd(aItem, {"D1_QUANT", oSql:getValue("D1_QUANT"), nil})
			aAdd(aItem, {"D1_VUNIT", oSql:getValue("D1_VUNIT"), nil})
			aAdd(aItem, {"D1_TOTAL", oSql:getValue("D1_TOTAL"), nil})
			aAdd(aItem, {"D1_TES", oSql:getValue("D1_TES"), nil})
			aAdd(aItens, aItem)
			oSql:skip()
		endDo
		
		oSql:close()
		
	endIf
	
return

/**
* Obtém o header para excluir o pedido de vendas
**/
static function getHeaderExclSC5()
	
	local aHeader := {}
	
	aAdd(aHeader,{"C5_NUM"  ,SC5->C5_NUM   ,nil})
	
return aHeader

/**
* Obtém a query do faturamento de ajuste de imposto para coletar informações
**/
static function getQueryAJustImpos(nRecno)
	
	local cQuery := ""
	
	cQuery := " SELECT  				"										+ CRLF
	cQuery += " 	SC5.R_E_C_N_O_ SC5_RECNO, SF1.R_E_C_N_O_ SF1_RECNO		"	+ CRLF
	cQuery += "	FROM %SF2.SQLNAME% " 											+ CRLF
	
	cQuery += "	INNER JOIN %SD2.SQLNAME% ON 1 = 1 "								+ CRLF
	cQuery += "		AND SD2.D2_FILIAL = SF2.F2_FILIAL "							+ CRLF
	cQuery += "		AND SD2.D2_DOC = SF2.F2_DOC "								+ CRLF
	cQuery += "		AND SD2.D2_CLIENTE = SF2.F2_CLIENTE "						+ CRLF
	cQuery += "		AND SD2.D2_LOJA = SF2.F2_LOJA "								+ CRLF
	cQuery += "		AND %SD2.NOTDEL% "											+ CRLF
		
	cQuery += "	INNER JOIN %SC6.SQLNAME% ON 1 = 1 "								+ CRLF
	cQuery += "		AND SC6.C6_FILIAL = SD2.D2_FILIAL "							+ CRLF
	cQuery += "		AND SC6.C6_NUM = SD2.D2_PEDIDO "							+ CRLF
	cQuery += "		AND SC6.C6_NOTA = SD2.D2_DOC "                              + CRLF
	cQuery += "		AND SC6.C6_SERIE = SD2.D2_SERIE "                           + CRLF
	cQuery += "		AND SC6.C6_PRODUTO = SD2.D2_COD "                           + CRLF
	cQuery += "		AND %SC6.NOTDEL%  "                                 		+ CRLF
   	
	cQuery += "	INNER JOIN %SC5.SQLNAME% ON 1 = 1 "								+ CRLF
	cQuery += "		AND SC5.C5_FILIAL = SD2.D2_FILIAL "							+ CRLF
	cQuery += "		AND SC5.C5_NUM = SD2.D2_PEDIDO "							+ CRLF
	cQuery += "		AND SC5.C5_NOTA = SD2.D2_DOC "                              + CRLF
	cQuery += "		AND SC5.C5_SERIE = SD2.D2_SERIE "                           + CRLF
	cQuery += "		AND %SC5.NOTDEL%  "                                 		+ CRLF
   	
	cQuery += "	INNER JOIN %SF1.SQLNAME% ON 1 = 1 "								+ CRLF
	cQuery += "		AND SF1.F1_FILIAL = SD2.D2_FILIAL "							+ CRLF
	cQuery += "		AND SF1.F1_DOC = SD2.D2_NFORI "								+ CRLF
	cQuery += "		AND SF1.F1_SERIE = SD2.D2_SERIORI  "                		+ CRLF
	cQuery += "		AND SF1.F1_FORNECE = SC6.C6_ZZFOROR  "              		+ CRLF
	cQuery += "		AND SF1.F1_LOJA = SC6.C6_ZZLOJOR "                  		+ CRLF
	cQuery += "		AND %SF1.NOTDEL%  "											+ CRLF
   	
	cQuery += "	INNER JOIN %SD1.SQLNAME% ON 1 = 1 "								+ CRLF
	cQuery += "		AND SD1.D1_FILIAL = SD2.D2_FILIAL "							+ CRLF
	cQuery += "		AND SD1.D1_DOC = SD2.D2_NFORI "								+ CRLF
	cQuery += "		AND SD1.D1_SERIE = SD2.D2_SERIORI  "                		+ CRLF
	cQuery += "		AND SD1.D1_FORNECE = SC6.C6_ZZFOROR  "              		+ CRLF
	cQuery += "		AND SD1.D1_LOJA = SC6.C6_ZZLOJOR "                  		+ CRLF
	cQuery += "		AND SD1.D1_COD = SC6.C6_PRODUTO "                   		+ CRLF
	cQuery += "		AND %SD1.NOTDEL%  "											+ CRLF
   	
	cQuery += "	WHERE 1 = 1 "                                                   + CRLF
	cQuery += "		AND SF2.F2_FILIAL = '%SF1.FILIAL%' "                    	+ CRLF
	cQuery += "		AND %SF2.NOTDEL% "                                 			+ CRLF
	cQuery += "		AND SF2.R_E_C_N_O_ = "+cValToChar(nRecno)+" "				+ CRLF
   
	
return cQuery

/**
* Ajusta o array aNfVinc limpando a 7º e 8º posição
**/
static function ajustArray(aNfVinc)
	
	local nI := 1
	
	for nI := 1 to len(aNfVinc)
		
		aNfVinc[nI][CHAVENFE] 		:= ""
		aNfVinc[nI][VALOR_BRUTO] 	:= 0
		
	next nI

return

/**
* Obtém o CNPJ do fornecedor
**/
static function getCNPJ(cFornOrig, cLojaFornOrig)

	local aArea 	:= getArea()
	local aAreaSA2	:= SA2->(getArea())
	local cCNPJ		:= ""
	
	SA2->(dbSetOrder(1))
	if SA2->(dbSeek(fwxFilial("SA2") + cFornOrig + cLojaFornOrig))
		
		cCNPJ := SA2->A2_CGC
		
	endIf
	
	restArea(aAreaSA2)
	restArea(aArea)

return cCNPJ

/**
* Monta o cabelhaço da Nota Fiscal
**/
static function getHeadSF1()

	local aCposSX3	:= FWSX3Util():GetAllFields("SF1",.f.)

	aHeader := {}
	
	aAdd(aHeader,{"F1_TIPO"   ,SF1->F1_TIPO   ,nil})
	aAdd(aHeader,{"F1_FORMUL" ,SF1->F1_FORMUL ,nil})
	aAdd(aHeader,{"F1_DOC"    ,SF1->F1_DOC    ,nil})
	aAdd(aHeader,{"F1_SERIE"  ,SF1->F1_SERIE  ,nil})
	aAdd(aHeader,{"F1_EMISSAO",SF1->F1_EMISSAO,nil})
	aAdd(aHeader,{"F1_DTDIGIT",SF1->F1_DTDIGIT,nil})
	aAdd(aHeader,{"F1_RECBMTO",SF1->F1_RECBMTO,nil})
	aAdd(aHeader,{"F1_FORNECE",SF1->F1_FORNECE,nil})
	aAdd(aHeader,{"F1_LOJA"   ,SF1->F1_LOJA   ,nil})
	aAdd(aHeader,{"F1_COND"   ,SF1->F1_COND   ,nil})
	aAdd(aHeader,{"F1_EST"    ,SF1->F1_EST    ,nil})
	aAdd(aHeader,{"F1_ESPECIE",SF1->F1_ESPECIE,nil})
	aAdd(aHeader,{"F1_TPFRETE","S"			  ,nil})
	
	for nCount := 1 to len(aCposSX3)
	
		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U"
			aAdd(aCab,{AllTrim(aCposSX3[nCount]),&("SF1->" + AllTrim(aCposSX3[nCount])),nil})
		endIf
	
	next nCount
	
	aHeader := FwVetByDic(aHeader, "SF1")
	
return aHeader

/**
* Monta os itens da Nota Fiscal
**/
static function getSD1Details(aDetails)
	
	local aCposSX3	:= FWSX3Util():GetAllFields("SD1",.f.)

	aDetail := {}
	
	aAdd(aDetail,{"D1_ITEM"   ,SD1->D1_ITEM   ,nil})
	aAdd(aDetail,{"D1_COD"    ,SD1->D1_COD    ,nil})
	aAdd(aDetail,{"D1_UM"     ,SD1->D1_UM     ,nil})
	aAdd(aDetail,{"D1_QUANT"  ,SD1->D1_QUANT  ,nil})
	aAdd(aDetail,{"D1_VUNIT"  ,SD1->D1_VUNIT  ,nil})
	aAdd(aDetail,{"D1_TOTAL"  ,SD1->D1_TOTAL  ,nil})
	aAdd(aDetail,{"D1_LOCAL"  ,SD1->D1_LOCAL  ,nil})
	aAdd(aDetail,{"D1_LOTEFOR",SD1->D1_LOTEFOR,nil})
	aAdd(aDetail,{"D1_LOTECTL",SD1->D1_LOTECTL,nil})
	aAdd(aDetail,{"D1_EMISSAO",SD1->D1_EMISSAO,nil})
	aAdd(aDetail,{"D1_TES"    ,SD1->D1_ZZTES  ,nil})
	aAdd(aDetail,{"D1_ZZTES"  ,SD1->D1_ZZTES  ,nil})
	aAdd(aDetail,{"D1_NFORI"  ,SD1->D1_NFORI  ,nil})
	aAdd(aDetail,{"D1_SERIORI",SD1->D1_SERIORI,nil})
	aAdd(aDetail,{"D1_ITEMORI",SD1->D1_ITEMORI,nil})
	
	
	for nCount := 1 to len(aCposSX3)
	
		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U"
			aAdd(aCab,{AllTrim(aCposSX3[nCount]),&("SD1->" + AllTrim(aCposSX3[nCount])),nil})
		endIf
	
	next nCount
	
	aDetail := FwVetByDic(aDetail, "SD1")
	
	aAdd(aDetails,aDetail)
	
return

/**
* Obtém a query da nf de recusa
**/
static function getQueryRecusa(nRecno)
	
	local cQuery 		:= ""
	
	cQuery := "	SELECT "																	+ CRLF
	cQuery += "		SD1.D1_ITEM , SD1.D1_COD, SD1.D1_QUANT, SD1.D1_DOC, SD1.D1_TES,"		+ CRLF
	cQuery += "		SD1.D1_SERIE , SD1.D1_VUNIT, SD1.D1_LOCAL, SD1.D1_UM,"					+ CRLF
	cQuery += "		SF1.R_E_C_N_O_ SF1_RECNO,  SD1.R_E_C_N_O_ SD1_RECNO, "		            + CRLF
	cQuery += "		SF1.F1_ZZNFDEV, SF1.F1_ZZSEDEV, SF1.F1_ZZDTDEV, "			            + CRLF
	cQuery += "		SD1.D1_NFORI, SD1.D1_SERIORI, SD1.D1_ITEMORI,"				            + CRLF
	cQuery += "		SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_ZZCFOP"					            + CRLF
	cQuery += "	FROM %SF1.SQLNAME% " 											            + CRLF
	cQuery += "	INNER JOIN %SD1.SQLNAME% ON 1 = 1" 								            + CRLF
	cQuery += "		AND SD1.D1_FILIAL = SF1.F1_FILIAL" 							            + CRLF
	cQuery += "		AND D1_DOC = F1_DOC" 										            + CRLF
	cQuery += "		AND D1_SERIE = F1_SERIE" 									            + CRLF
	cQuery += "		AND D1_FORNECE = F1_FORNECE" 								            + CRLF
	cQuery += "		AND %SD1.NOTDEL%"           								            + CRLF
	cQuery += "	WHERE 1 = 1" 													            + CRLF
	cQuery += "		AND SF1.R_E_C_N_O_=" + cValToChar(nRecno)					            + CRLF
	cQuery += "	ORDER BY D1_ITEM "												            + CRLF
	
return cQuery

/**
* Obtém o código da mensagem F4_ZZMEN1
**/
static function getCodForm(cTes)
	
	local oSQL 		:= IpSqlObject():NewIPSqlObject()
	local cCodForm	:= ""
	
	oSql:newTable("SF4", "F4_ZZMEN1", "%SF4.XFILIAL% AND F4_CODIGO = '" + cTes + " '")
	
	if oSql:hasRecords()
		cCodForm := oSQL:getValue("F4_ZZMEN1")
	endIf
	
	oSQL:close()
	
return cCodForm


/**
* Obtém a mensagem
**/
static function getMsg(cCodForm)
	
	local cDescricao		:= ""
	
	dbSelectArea("SM4")
	cDescricao := formula(cCodForm)
	
return cDescricao

/**
* Verifica se a TES já foi processada
**/
static function isTesNotProcessed(aTesProces, cTes)
	
	local nPos 				:= 0
	local lIsNotProcessed 	:= .T.
	
	nPos := aScan(aTesProces, cTes)
	
	if nPos > 0
		lIsNotProcessed := .F.
	else
		aAdd(aTesProces, cTes)
	endIf
	
return lIsNotProcessed

/**
* Obtém a Tes referente a nota faturada
**/
static function getTesSaida()
	
	local aArea 	:= GetArea()
	local aAreaSF2  := SF2->(GetArea())
	local aAreaSD2  := SD2->(GetArea())
	local cChaveSF2 := FwxFilial("SF2") + SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
	local cTes		:= ""
	
	SD2->(dbSetOrder(3))
	
	if SD2->(dbSeek(cChaveSF2))
		
		cTes := SD2->D2_TES
		
	endIf
	restArea(aAreaSD2)
	restArea(aAreaSF2)
	restArea(aArea)
	
return cTes

/**
* verifica se é formulário próprio
**/
static function isFormProprio(oDHLIP210)
	
	local oSql			:= IpSqlObject():NewIpSqlObject()
	local lFormul		:= .F.
	local cFormul		:= ""
	
	oSql	:= getNewSF1Alias(oDHLIP210)
	
	if oSql:hasRecords()
		if oSql:count() == 1
			cFormul := oSql:getValue("F1_FORMUL")
			if cFormul == PROPRIO
				lFormul := .T.
			endIf
		else
			oDHLIP210:saveInf()
			while oSql:notIsEOF()
				
				oDHLIP210:SetNfRetRCO(oSql:getValue("F1_DOC"))
				oDHLIP210:SetSerieRetRCO(oSql:getValue("F1_SERIE"))
				oDHLIP210:SetCodCliFor(oSql:getValue("F1_FORNECE"))
				oDHLIP210:SetLojCliFor(oSql:getValue("F1_LOJA"))
				
				if oDHLIP210:CheckItens(.T.)
					cFormul := oSql:getValue("F1_FORMUL")
					if cFormul == PROPRIO
						lFormul := .T.
						oDHLIP210:SetFormul(oSql:getValue("F1_FORMUL"))
					endIf
					exit
				endIf
								
				oSql:skip()
				
			endDo
			
			if !oDHLIP210:IsCheckedOk()
			
				oDHLIP210:SetError(.T.)
				oDHLIP210:SetMsgError("Foi encontrado divergências entre a nota " + oDHLIP210:GetNfRetRCO() + " série " + oDHLIP210:GetSerieRetRCO() + " referente a estrutura do XML.")
				oDHLIP210:saveLog(oDHLIP210:GetMsgError())
				
			endIf
			
		endIf
		
	else
		
		oDHLIP210:setError(.T.)
		oDHLIP210:SetMsgError("Não foi encontrado o documento com a Nf: "+allTrim(oDHLIP210:GetNfRetRCO())+", Série: "+allTrim(oDHLIP210:GetSerieRetRCO()))
		oDHLIP210:saveLog(oDHLIP210:GetMsgError())
		
	endIf
	
	oSql:close()
	
return lFormul
 
/**
* obtém a query referente ao doc/serie
**/
static function getNewSF1Alias(oDHLIP210)
	
	local oSql			:= IpSqlObject():NewIpSqlObject()
	local cQuery		:= ""
	
	cQuery := "	SELECT "														+ CRLF
	cQuery += "		SF1.F1_FORMUL,  SF1.F1_DOC, SF1.F1_FORNECE, SF1.F1_LOJA,"   + CRLF
	cQuery += "		SF1.F1_SERIE"												+ CRLF
	cQuery += "	FROM %SF1.SQLNAME% " 											+ CRLF
	cQuery += "	WHERE 1 = 1" 													+ CRLF
	cQuery += "		AND SF1.F1_FILIAL = '%SF1.FILIAL%' " 						+ CRLF
	cQuery += "		AND %SF1.NOTDEL%"           								+ CRLF
	cQuery += "		AND F1_DOC = '"+oDHLIP210:GetNfRetRCO()+"'"     			+ CRLF
	cQuery += "		AND F1_SERIE = '"+oDHLIP210:GetSerieRetRCO()+"'"			+ CRLF
	
	oSql:newAlias(cQuery)
	
return oSql


/**
* Quando formulário próprio o cliente é a própria DHL
**/
static function alterCNPJToDHL(oDHLIP210)
	
	local cCNPJDHL	:= oDHLIP210:GetSiteCNPJ()
	
return cCNPJDHL

/**
* Obtém a nfOri e serie Ori da nota de ajuste
**/
static function getNfOriF2(cDoc, cSerie, cCliente, cLoja)
	
	local cChave := fwxFilial("SF2") + cDoc + cSerie + cCliente + cLoja
	local cNfOri := ""
	local cSerOri:= ""
	
	SF2->(dbSetOrder(1))
	SD2->(dbSetOrder(3))
	if SF2->(dbSeek(cChave))
		if SD2->(dbSeek(cChave))
			cNfOri 	:= SD2->D2_NFORI
			cSerOri	:= SD2->D2_SERIORI
		endIf
	endIf
	
return {cNfOri,  cSerOri}

/**
* Obtém a nfOri e serie Ori da nota de devolução
**/
static function getNfOriF1(cNfOri, cSerieOri)
	
	local cChave := fwxFilial("SF1") + cNfOri + cSerieOri
	local cNfOri := ""
	local cSerOri:= ""
	
	SF1->(dbSetOrder(1))
	SD1->(dbSetOrder(1))
	if SF1->(dbSeek(cChave))
		if SD1->(dbSeek(cChave))
			while SD1->(!eof()) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE) == cChave
				
				cNfOri 	:= SD1->D1_NFORI
				cSerOri	:= SD1->D1_SERIORI
				
				if !empty(cNfOri) .and. !empty(cSerOri)
					exit
				endIf
						
				SD1->(dbSkip())
			endDo
		endIf
	endIf
	
return {cNfOri,  cSerOri}

/**
* Obtém os dados da nota de vendas RCO
**/
static function getInfRCO(cNfOri, cSerieOri, cTipoNota, cPedido)
	
	local oSql	 		:= IpSqlObject():NewIpSqlObject()
	local cQuery 		:= getQryInfRCO(cNfOri, cSerieOri)
	local cMsg	 		:= ""
	local cNfOriDev		:= ""
	local cSerOriDev	:= ""
	local cDoc			:= ""
	local cSerie		:= ""
	
	default ctipoNota	:= ""
	default cPedido		:= ""
	
	oSql:newAlias(cQuery)
	
	if oSql:hasRecords()
		
		if cTipoNota == DHL_NFE_INVOICE_OUTFLOW			
			
			getInfDevolucao(@cDoc, @cSerie)		
			
			cMsg := " Referente a nota de devolucao: " + cDoc + "/" + cSerie
			
		else
		
			cMsg := " Referente a nota de venda: " + oSql:getValue("F2_DOC") + "/" + oSql:getValue("F2_SERIE")
			cMsg += " chave: " + oSql:getValue("F2_CHVNFE")
			
		endIf		
		
		cMsg += " cliente " + allTrim(oSql:getValue("A1_NOME")) + " endereco " + allTrim(oSql:getValue("A1_END")) + " " + allTrim(oSql:getValue("A1_MUN")) + " - " + allTrim(oSql:getValue("A1_EST"))
		cMsg += " CNPJ " + allTrim(oSql:getValue("A1_CGC")) + " IE "+ allTrim(oSql:getValue("A1_INSCR"))+ "."
		
	endIf
	
	oSql:close()
	
return cMsg

/**
* Obtém os dados da nota de vendas RCO
**/
static function getQryInfRCO(cNfOri, cSerieOri)
	
	local cQuery := ""
	
	cQuery := "	SELECT "														+ CRLF
	cQuery += "		SA1.A1_COD, SA1.A1_CGC, SA1.A1_NOME, SA1.A1_INSCR,"			+ CRLF
	cQuery += "		SA1.A1_END,SA1.A1_BAIRRO, SA1.A1_MUN, SA1.A1_EST,"			+ CRLF
	cQuery += "		SD2.D2_COD, SD2.D2_QUANT, SD2.D2_DOC,"						+ CRLF
	cQuery += "		SF2.R_E_C_N_O_ SF2_RECNO,  SD2.R_E_C_N_O_ SD2_RECNO, "		+ CRLF
	cQuery += "		SD2.D2_CLIENTE, SD2.D2_LOJA, SF2.F2_CHVNFE, SF2.F2_DOC, "	+ CRLF
	cQuery += "		SF2.F2_SERIE, SD2.D2_NFORI, SD2.D2_SERIORI"					+ CRLF
	cQuery += "	FROM %SF2.SQLNAME% " 											+ CRLF
	cQuery += "	INNER JOIN %SD2.SQLNAME% ON 1 = 1" 								+ CRLF
	cQuery += "		AND SD2.D2_FILIAL = SF2.F2_FILIAL" 							+ CRLF
	cQuery += "		AND D2_DOC = F2_DOC" 										+ CRLF
	cQuery += "		AND D2_SERIE = F2_SERIE" 									+ CRLF
	cQuery += "		AND D2_CLIENTE = F2_CLIENTE" 								+ CRLF
	cQuery += "		AND %SD2.NOTDEL%"           								+ CRLF
	cQuery += "	INNER JOIN %SA1.SQLNAME% ON 1 = 1" 								+ CRLF
	cQuery += "		AND SA1.A1_FILIAL = SF2.F2_FILIAL" 							+ CRLF
	cQuery += "		AND SA1.A1_COD = SF2.F2_CLIENTE" 							+ CRLF
	cQuery += "		AND SA1.A1_LOJA = SF2.F2_LOJA" 								+ CRLF
	cQuery += "		AND %SA1.NOTDEL%" 											+ CRLF
	cQuery += "	WHERE 1 = 1" 													+ CRLF
	cQuery += "		AND SF2.F2_FILIAL = '%SF2.FILIAL%' " 						+ CRLF
	cQuery += "		AND %SF2.NOTDEL%"           								+ CRLF
	cQuery += "		AND F2_DOC = '"+cNfOri+"'"     								+ CRLF
	cQuery += "		AND F2_SERIE = '"+cSerieOri+"'"								+ CRLF
	
return cQuery


/**
* Verifica se foi enviado a asn
**/
static function isSendASN()
	
	local lIsSendASN := .T.
	
	if SF1->F1_ZZSTATUS == PENDENTE_ASN
		lIsSendASN := .F.
	endIf
	
return lIsSendASN

/**
* Obtém informações da devolução
**/
static function getInfDevolucao(cDoc, cSerie)
	
	local cQuery 	:= getQueryAJustImpos(SF2->(recno()))
	local oSQL 		:= IpSqlObject():NewIpSqlObject()
	local nRECNOSC5	:= 0
	local nRECNOSF1	:= 0
	local aAreaSF1	:= SF1->(getArea())
	
	oSQL:newAlias(cQuery)
	
	if oSQL:hasRecords()
		
		nRECNOSC5 := oSQL:getValue("SC5_RECNO")
		nRECNOSF1 := oSQL:getValue("SF1_RECNO")
		
		If nRECNOSF1 > 0
			SF1->(dbGoTo(nRECNOSF1))
			cDoc 	:= allTrim(SF1->F1_ZZNFDEV)
			cSerie := allTrim(SF1->F1_ZZSEDEV)
		EndIf
		
	endIf
	
	oSQL:close()
	
	restArea(aAreaSF1)	

return

/**
* Obtém o código/loja do fornecedor a partir do CNPJ do fornecedor
**/
static function getCodFornecedor(oDHLIP210)
	
	local oSQL 			:= IpSqlObject():NewIPSqlObject()
	
	oSql:newTable("SA2", "A2_COD, A2_LOJA", "%SA2.XFILIAL% AND A2_CGC = '" + oDHLIP210:GetCNPJCustumer() + " '")
	
	if oSql:HasRecords()
		cCodClienteXML := oSql:GetValue("A2_COD")
		cLojClienteXML := oSql:GetValue("A2_LOJA")
		
		oDHLIP210:SetCodCliFor(cCodClienteXML)
		oDHLIP210:SetLojCliFor(cLojClienteXML)
		
	else
		oDHLIP210:lError	:= .T.
		oDHLIP210:cMsgError := "Não foi encontrado o fornecedor com o CGC : " + cCNPJCustomer
		oDHLIP210:saveLog(oDHLIP210:getMsgError())
	endIf
	
	oSql:Close()
	
return