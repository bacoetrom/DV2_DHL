#include 'totvs.ch'
#include 'dhl.ch'

#define INTERFACE  					"SAP IP 150"
#define AUTORIZADA 					"S"
#define TRANSMITIDA					"T"
#Define EXCLUSAO					5

#Define POS_SALESORDER	       1
#Define POS_ITENS_SALESORDER 2

#define OPC_ALTERACAO 4

/*/{Protheus.doc} DHLIp150
Classe auxiliar para a interface IP150
@type class
@author Gustavo Luiz
@since 18/05/2017
@version 1.0
@example
(examples)
@see (links_or_references)
/*/             
user function _dhlip150;return

Class DHLIp150
	
	data cFromPartner
	data cToPartner
	data cSiteCNPJ
	data cKeySAP
	data cKeyProtheus
	data cKeyRCO
	data cKeyRET
	data cDate
	data aSalesOrder
	data aArea
	data aAreaSF2
	data aAreaSD2
	data aAreaSZA
	data aAreaSC5
	data aAreaSC6
	data lError
	data cFilePath
	data cNfRetSimb
	data cSerRetSimb
	data cNfRCO
	data cSerRCO
	data nRecnoRCO
	data nRecnoRET
	data cTipoNf
	data lExistRCO
	data cMsgError
	
	Method GetFromPartner()
	Method SetFromPartner()
	
	Method GetToPartner()
	Method SetToPartner()
	
	Method GetSiteCNPJ()
	Method SetSiteCNPJ()
	
	Method GetKeySAP()
	Method SetKeySAP()
	
	Method GetKeyProtheus()
	Method SetKeyProtheus()
	
	Method GetKeyRCO()
	Method SetKeyRCO()
	
	Method GetKeyRET()
	Method SetKeyRET()
	
	Method GetDate()
	Method SetDate()
	
	Method HasError()
	Method SetError()
	
	Method GetFilePath()
	Method SetFilePath()
	
	Method GetNfRetSimb()
	Method SetNfRetSimb()
	
	Method GetSerRetSimb()
	Method SetSerRetSimb()
	
	Method GetNfRCO()
	Method SetNfRCO()
	
	Method GetSerRCO()
	Method SetSerRCO()
	
	Method GetRecnoRCO()
	Method SetRecnoRCO()
	
	Method GetRecnoRET()
	Method SetRecnoRET()
	
	Method GetTipoNf()
	Method SetTipoNf(nRecno)
	
	Method GetMsgError()
	Method SetMsgError()
	
	Method getSalesOrder()
	Method setSalesOrder()
	Method addSalesOrder()
	
	Method ExistRCO()
	
	Method FormatDate(cDate)
	Method ExistKey(cKey)
	Method GetAreas()
	Method RestAreas()
	Method DefinRecRCO()
	Method DefinRecRET()
	Method ChecStatusFIMP(nRecno, cTipo)
	Method SendCancellation(nRecno)
	Method ExcluiRCO(nRecno)
	Method ExcluiRET(nRecno)
	Method GetRecnos(cChave, cTipo)
	Method ValidExclusao()
	Method updateSalesOrder()
	
	Method NewDHLIp150() CONSTRUCTOR
	
ENDCLASS

/*/{Protheus.doc} NewDHLIp150
Método Construtor

@author Gustavo Luiz
@since 18/05/2017
@version 1.0
@example
(examples)
/*/
Method NewDHLIp150() CLASS DHLIp150
	
	::cFromPartner 	:= ''
	::cToPartner 	:= ''
	::cSiteCNPJ 	:= ''
	::cKeySAP 		:= ''
	::cKeyProtheus	:= ''
	::cKeyRCO		:= ''
	::cKeyRET		:= ''
	::cDate			:= ''
	::aArea			:= ''
	::aAreaSF2		:= ''
	::aAreaSD2		:= ''
	::aAreaSZA		:= ''
	::aAreaSC5		:= {}
	::aAreaSC6		:= {}
	::lError		:= .F.
	::cFilePath		:= ''
	::cNfRetSimb    := ""
	::cSerRetSimb   := ""
	::cNfRCO        := ""
	::cSerRCO       := ""
	::nRecnoRCO		:= 0
	::nRecnoRET		:= 0
	::cTipoNf		:= ""
	::lExistRCO		:= .F.
	::cMsgError		:= ""
	
Return

/*/{Protheus.doc} GetFromParner
Obtém o PARTNERNAME (FROM) do XML

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetFromPartner() Class DHLIp150
	
Return ::cFromPartner

/*/{Protheus.doc} SetFromParner
Define o PARTNERNAME (FROM) do XML

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetFromPartner(cFromPartner) Class DHLIp150
	
	::cFromPartner := cFromPartner
	
Return

/*/{Protheus.doc} GetToPartner
Obtém o PARTNERNAME (TO) do XML

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetToPartner() Class DHLIp150
	
Return ::cToPartner

/*/{Protheus.doc} SetToPartner
Define o PARTNERNAME (TO) do XML

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetToPartner(cToPartner) Class DHLIp150
	
	::cToPartner := cToPartner
	
Return

/*/{Protheus.doc} GetSiteCNPJ
Obtém o SITE do XML

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetSiteCNPJ() Class DHLIp150
	
Return ::cSiteCNPJ

/*/{Protheus.doc} SetSiteCNPJ
Define o SITE do XML

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetSiteCNPJ(cSiteCNPJ) Class DHLIp150
	
	::cSiteCNPJ := cSiteCNPJ
	
Return


/*/{Protheus.doc} GetKeySAP
Obtém a chave originado do SAP

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetKeySAP() Class DHLIp150
	
Return ::cKeySAP

/*/{Protheus.doc} SetKeySAP
Define a chave originado do SAP

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetKeySAP(cKeySAP) Class DHLIp150
	
	::cKeySAP := cKeySAP
	
Return

/*/{Protheus.doc} GetKeyProtheus
Obtém a chave Protheus

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetKeyProtheus() Class DHLIp150
	
	
return ::cKeyProtheus


/*/{Protheus.doc} SetKeyProtheus
Define a chave Protheus

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetKeyProtheus(cKeyProtheus) Class DHLIp150
	::cKeyProtheus := cKeyProtheus
return


/*/{Protheus.doc} GetKeyRCO
Obtém a chave da nota RCO

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetKeyRCO() Class DHLIp150
	
	
	
return ::cKeyRCO


/*/{Protheus.doc} SetKeyRCO
Obtém a chave da nota RCO

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetKeyRCO(cKeyRCO) Class DHLIp150
	
	::cKeyRCO := cKeyRCO
	
return

/*/{Protheus.doc} GetKeyRET
Obtém a chave da nota RET

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetKeyRET() Class DHLIp150
	
	
	
return ::cKeyRET


/*/{Protheus.doc} SetKeyRET
Obtém a chave da nota RET

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetKeyRET(cKeyRET) Class DHLIp150
	
	::cKeyRET := cKeyRET
	
return


/*/{Protheus.doc} GetDate
Obtém a data do XML

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method GetDate() Class DHLIp150
	
Return ::cDate

/*/{Protheus.doc} SetDate
Define a data do XML

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method SetDate(cDate) Class DHLIp150
	
	::cDate := cDate
	
Return

/*/{Protheus.doc} FormatDate
Formata a data que veio do XML (YYYY-MM-DD) para a data do Protheus: DD/MM/YYYY

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method  FormatDate(cDate) Class DHLIp150
	
	dDate := sTod(cDate)
	
Return dDate

/*/{Protheus.doc} ExistKey
Verifica se existe a chave (SAP) na tabela SZA

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method ExistKey(cKey) Class DHLIp150
	
	local lExist	:= .T.
	
	::GetAreas()
	
	SZA->(DbSetOrder(1))
	
	if SZA->(DbSeek(FWxFilial("SZA") + cKey))
		::cNfRCO		:= SZA->ZA_NFRCO
		::cSerRCO		:= SZA->ZA_SERIRCO
		
		//VERIFICA SE EXISTE NF RCO E SERIE RCO NA TABELA SZA
		if !empty(::cNfRCO) .AND. !empty(::cSerRCO)
			::lExistRCO := .T.
		endIf
		
		::cNfRetSimb	:= SZA->ZA_NFRET
		::cSerRetSimb	:= SZA->ZA_SERIRET
		
		if empty(::cNfRetSimb) .and. empty(::cSerRetSimb)
			
			lExist 			:= .F.
			::SetError(.T.)
			oLog:start(APP_SAP,DHL_IMPORTACAO,::cFilePath)
			oLog:fail(INTERFACE,"Não existe Documento/Série referente ao Retorno Simbólico")
			
		endIf
		
		
	else
		lExist 			:= .F.
		::SetError(.T.)
		oLog:start(APP_SAP,DHL_IMPORTACAO,::cFilePath)
		oLog:fail(INTERFACE,"Chave " + cKey + " não localizada na tabela SZA")
	endIf
	
	::RestAreas()
	
return lExist

/*/{Protheus.doc} DefinRecRCO
Define o Recno do documento RCO

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method DefinRecRCO() Class DHLIp150
	
	::GetAreas()
	
	SF2->(DbSetOrder(1))
	
	if SF2->(DbSeek((FwXFilial("SF2") + ::cNfRCO + ::cSerRCO)))
		::nRecnoRCO := SF2->(Recno())
	endIf
	
	::RestAreas()
	
return

/*/{Protheus.doc} DefinRecRET
Define o Recno do documento RET

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method DefinRecRET() Class DHLIp150
	
	::GetAreas()
	
	SF2->(DbSetOrder(1))
	
	if SF2->(DbSeek((FwXFilial("SF2") + ::cNfRetSimb + ::cSerRetSimb)))
		::nRecnoRET := SF2->(Recno())
	endIf
	
	::RestAreas()
	
return

/*/{Protheus.doc} ChecStatusFIMP
Checa o status do campo (F2_FIMP)

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method ChecStatusFIMP(nRecno, cTipo) Class DHLIp150
	
	local lStatus 	:= .F.
	local cMensagem := ""
	
	::GetAreas()
	SF2->(DbGoTo(nRecno))
	
	if SF2->F2_FIMP == AUTORIZADA
		
		lStatus := .T.
		
	else
		
		if cTipo == RETORNO_SIMBOLICO
			cMensagem := "(retorno simbólico)"
		else
			cMensagem := "(remessa por conta e ordem)"
		endIf
		
		::SetError(.T.)
		oLog:start(APP_SAP,DHL_IMPORTACAO,::cFilePath)
		oLog:fail(INTERFACE,"Documento/Série " + AllTrim(SF2->F2_DOC) + "/" + AllTrim(SF2->F2_SERIE) + " " + cMensagem  + " não autorizado pelo SEFAZ")
		
	endIf
	
	::RestAreas()
	
return lStatus

/*/{Protheus.doc} SendCancellation
Envia a interface de cancelamento referente a nota que será posicionada

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SendCancellation(nRecno) Class DHLIp150
	
	local oDHLProcValid := DHLProcessValidator():newDHLProcessValidator()
	local cTipoNf		:= DHL_NFE_INVOICE_OUTFLOW
	local cSerie		:= ""
	local cChvNfe		:= ""
	local cNota			:= ""
	local cCliente		:= ""
	local cLoja			:= ""
	
	::GetAreas()
	
	SF2->(DbGoTo(nRecno))
	
	cNota         		:= SF2->F2_DOC
	cSerie        		:= SF2->F2_SERIE
	cCliente      		:= SF2->F2_CLIENTE
	cLoja         		:= SF2->F2_LOJA
	cChvNfe       		:= SF2->F2_CHVNFE
	
	if ExistBlock("PrcCancMsa")
		if oDHLProcValid:validDocumentType(cTipoNf,nil,cSerie)
			if oDHLProcValid:validSendInterface(cTipoNf)
				U_PrcCancMsa(cTipoNf, cChvNfe, cNota, cSerie, cCliente, cLoja)
			endif
		endIf
	endIf
	
	::RestAreas()
	
return


/*/{Protheus.doc} ExcluiRCO (Remessa por conta e ordem)
Exclui o documento remessa por conta e ordem

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method ExcluiRCO(nRecno) Class DHLIp150
	
	local aCab 			:= {}
	local aItens		:= {}
	local oUtils		:= IpUtilsObject():newIpUtilsObject()
	
	private lMsErroAuto	:= .F.
	private lMsHelpAuto := .F.
	
	nModulo	:= 34
	cModulo := "34"
	
	::GetAreas()
	
	SF2->(DbGoTo(nRecno))
	
	aCab := GetCab()
	
	begin transaction
		
		MSExecAuto({|x,y,z| mata920(x,y,z)},aCab,aItens,EXCLUSAO)
		
		if lMsErroAuto
			oLog:fail(INTERFACE, "Não foi possível excluir a NF "+SF2->F2_DOC+": "+CRLF+CRLF + oUtils:getErroAuto())
			::SetError(.T.)
		endIf
		
	end transaction
	
	::RestAreas()
	
return

/*/{Protheus.doc} ExcluiRET (Retorno Simbólico)
Excluir o documento RET

@author Gustavo Luiz
@since 26/04/2017
@version 1.0
@example
(examples)
/*/
Method ExcluiRET(nRecno) Class DHLIp150
	
	local cSerie		:= ""
	local cChave		:= ""
	local aMata520Cab 	:= {}
	local lSucesso		:= .F.
	
	::GetAreas()
	
	SF2->(DbGoTo(nRecno))
	
	aMata520Cab := GetHeaderDocSaida()
	
	retSalesOrder(self)
	
	begin transaction
		
		lSucesso := EstornaDocumento(aMata520Cab)
		
		If lSucesso
			lSucesso := ::updateSalesOrder()
			If !lSucesso
				::SetError(.T.)
			EndIf
		Else
			oLog:fail(INTERFACE, "Não foi possível excluir a NF "+SF2->F2_DOC+": "+CRLF+CRLF)
			::SetError(.T.)
		Endif
		
	end transaction
	
	::RestAreas()
	
return lSucesso

/*/{Protheus.doc} GetRecnos
Obtém os recnos das notas RCO e RET

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method GetRecnos(cChave, cTipo) Class DHLIp150
	
	local cDoc 		:= ""
	local cSerie 	:= ""
	local cQuery	:= ""
	local nRecnoSF2 := 0
	local oSqlSF2	:= ipSqlObject():newIpSqlObject()
	local oSqlSZA	:= ipSqlObject():newIpSqlObject()
	
	::GetAreas()
	
	cQuery  := RunQuerySF2(cTipo, cChave)
	
	oSqlSF2:NewAlias(cQuery)
	
	If oSqlSF2:HasRecords()
		
		if cTipo == REMESSA_CONTA_ORDEM
			
			::SetNfRCO(oSqlSF2:GetValue("F2_DOC"))
			::SetSerRCO(oSqlSF2:GetValue("F2_SERIE"))
			::SetRecnoRCO(oSqlSF2:GetValue("R_E_C_N_O_"))
			
			cQuery  := RunQuerySZA(cTipo, self:GetNfRCO(), self:GetSerRCO())
			
			oSqlSZA:NewAlias(cQuery)
			
			if 	oSqlSZA:HasRecords()
				
				::SetNfRetSimb(oSqlSZA:GetValue("ZA_NFRET"))
				::SetSerRetSimb(oSqlSZA:GetValue("ZA_SERIRET"))
				
				nRecnoSF2 := GetRecnoSF2(self:GetNfRetSimb(), self:GetSerRetSimb())
				
				::SetRecnoRET(nRecnoSF2)
			else
				oLog:start(APP_SAP,DHL_IMPORTACAO,::cFilePath)
				oLog:fail(INTERFACE, "Não localizado o documento/série referente " + self:GetNfRCO() + "/" + self:GetSerRCO())
				::SetError(.T.)
			endIf
			
		else
			
			::SetNfRetSimb(oSqlSF2:GetValue("F2_DOC"))
			::SetSerRetSimb(oSqlSF2:GetValue("F2_SERIE"))
			//nRecnoSF2 := GetRecnoSF2(self:GetNfRCO(), self:GetSerRCO())
			::SetRecnoRET(oSqlSF2:GetValue("R_E_C_N_O_"))
			
		endIf
		
	Else
		
		oLog:start(APP_SAP,DHL_IMPORTACAO,::cFilePath)
		oLog:fail(INTERFACE, "Não localizado o documento referente a chave " + cChave)
		::SetError(.T.)
		
	EndIf
	
	oSqlSF2:Close()
	oSqlSZA:Close()
	
	::RestAreas()
	
return

/*/{Protheus.doc} ValidExclusao
Valida a exlusão. Utilizado nos ponto de entrada (MS520VLD e MT920TOK)

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method ValidExclusao(cPontoEntrada) Class DHLIp150
	
	local lReturn 	:= .T.
	local lLimpaItens	:= .f.
	local lJob		:= GetRemoteType() == -1
	local lExclRet  := SuperGetMV("ZZ_EXCLRET",,.T.)
	local cUserFat	:= GetMV("ZZ_USERFAT")
	
	::GetAreas()
	
	if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
		if !lJob
			if SF2->F2_FIMP == AUTORIZADA
				lReturn := .F.
				if SF2->F2_ZZTPNF == RETORNO_SIMBOLICO
					
					if !lExclRet
						msgAlert("Nota Fiscal (Retorno Simbólico) não pode ser excluída via sistema.")
					else
						if MsgYesNo("Nota Fiscal (Retorno Simbólico) não pode ser excluída via sistema. O parâmetro ZZ_EXCLRET esta habilitado para realizar a operação. Deseja realizar a exclusão da nota?","" )
							limpaCpsRet(lLimpaItens)
							lReturn := .T.
						endIf
					endIf
					
				elseif SF2->F2_ZZTPNF == REMESSA_CONTA_ORDEM
					msgAlert("Nota Fiscal (Remessa por Conta e Ordem) não pode ser excluída via sistema")
				elseif SF2->F2_ZZTPNF == AJUSTE_FISCAL .or. SF2->F2_ZZTPNF == RETORNO_EFETIVO .or. (SF2->F2_TIPO # "N") .or. (AllTrim(__cUserID) $ cUserFat)
					lReturn := .T.
				endIf
			elseIf SF2->F2_FIMP $ "ND" .or. Empty(SF2->F2_FIMP)
				if cPontoEntrada == "MT920TOK" .AND. SF2->F2_ZZTPNF == REMESSA_CONTA_ORDEM
					limpaCpsRCO()
				elseIf cPontoEntrada == "MS520VLD" .AND. SF2->F2_ZZTPNF == RETORNO_SIMBOLICO
					limpaCpsRet(lLimpaItens)
				endIf
			endIf
		else
			if SF2->F2_FIMP == AUTORIZADA
				if SF2->F2_ZZTPNF == RETORNO_SIMBOLICO
					lLimpaItens := .t.
					limpaCpsRet(lLimpaItens)
				endif
			endif
		endIf
	endIf
	
	::RestAreas()
	
return lReturn


/*/{Protheus.doc} updateSalesOrder
Atualiza pedido de venda

@author Thiago Meschiatti
@since 19/09/2017
@version 1.0
@example
(examples)
/*/
Method updateSalesOrder() Class DHLIp150
	Local oUtils		:= IpUtilsObject():newIpUtilsObject()
	Local aSalesHeader:= {}
	Local aSalesItems := {}
	Local aSalesOrder := ::getSalesOrder(self)
	Local nI          := 0
	Local nJ          := 0
	Local lRet		:= .t.
	
	Private lMsErroAuto := .f.
	
	For nI := 1 To Len(aSalesOrder)
		aSalesHeader := {}
		aSalesItems  := {}
		
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		
		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))

		If SC5->(DbSeek(FwXFilial("SC5") + aSalesOrder[nI, POS_SALESORDER]))
			mountHeader(@aSalesHeader)
			
			For nJ := 1 To Len(aSalesOrder[nI, POS_ITENS_SALESORDER])
				If SC6->(DbSeek(FwXFilial("SC6") + aSalesOrder[nI, POS_SALESORDER]+ aSalesOrder[nI, POS_ITENS_SALESORDER, nJ]))
					mountItems(@aSalesItems)
				EndIf
			Next nJ
		EndIf
		
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| MATA410(x,y,z)},aSalesHeader,aSalesItems,OPC_ALTERACAO)
		
		if lMsErroAuto
			DisarmTransaction()
			setFileLog("fail","Falha ao alterar o pedido de venda no processo de exclusão " + AllTrim(SC5->C5_NUM) + " ! Verifique." + oUtils:getErroAuto())
			lRet := .f.
		endif
	Next nI
	
return (lRet)


/*/{Protheus.doc} GetFilePath
Obtém o filePatch

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method GetFilePath() Class DHLIp150
	
return ::cFilePath

/*/{Protheus.doc} SetFilePath
Define o filePatch

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SetFilePath(cFilePath) Class DHLIp150
	::cFilePath :=  cFilePath
return

/*/{Protheus.doc} GetAreas
Obtém as áreas

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method GetAreas() Class DHLIp150
	
	::aArea 	:= GetArea()
	::aAreaSF2	:= SF2->(GetArea())
	::aAreaSD2	:= SD2->(GetArea())
	::aAreaSZA	:= SZ4->(GetArea())
	::aAreaSC5	:= SC5->(GetArea())
	::aAreaSC6	:= SC6->(GetArea())
	
return

/*/{Protheus.doc} GetNfRCO
Obtém o documento de Remessa por Conta e Ordem

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method GetNfRCO() Class DHLIp150
	
return ::cNfRCO

/*/{Protheus.doc} SetNfRCO
Define o documento de Remessa por Conta e Ordem

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SetNfRCO(cNfRCO) Class DHLIp150
	::cNfRCO := cNfRCO
return

/*/{Protheus.doc} GetSerRCO
Obtém a série de Remessa por Conta e Ordem

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method GetSerRCO() Class DHLIp150
	
return ::cSerRCO

/*/{Protheus.doc} SetSerRCO
Define a série de Remessa por Conta e Ordem

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SetSerRCO(cSerRCO) Class DHLIp150
	::cSerRCO := cSerRCO
return

/*/{Protheus.doc} GetNfRetSimb
Obtém o documento do Retorno Simbólico

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method GetNfRetSimb() Class DHLIp150
	
return ::cNfRetSimb

/*/{Protheus.doc} SetNfRetSimb
Define o documento do Retorno Simbólico

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SetNfRetSimb(cNfRetSimb) Class DHLIp150
	::cNfRetSimb := cNfRetSimb
return

/*/{Protheus.doc} GetSerRetSimb
Obtém a série do Retorno Simbólico

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method GetSerRetSimb() Class DHLIp150
	
return ::cSerRetSimb

/*/{Protheus.doc} SetSerRetSimb
Define a série do Retorno Simbólico

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SetSerRetSimb(cSerRetSimb) Class DHLIp150
	::cSerRetSimb := cSerRetSimb
return

/*/{Protheus.doc} GetRecnoRCO
Obtém o recno do documento Remessa por conta e ordem

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method GetRecnoRCO() Class DHLIp150
	
return ::nRecnoRCO

/*/{Protheus.doc} SetRecnoRCO
Define o recno do documento Remessa por conta e ordem

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SetRecnoRCO(nRecnoRCO) Class DHLIp150
	::nRecnoRCO := nRecnoRCO
return

/*/{Protheus.doc} GetRecnoRET
Obtém o recno do documento Retorno simbólico

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method GetRecnoRET() Class DHLIp150
return ::nRecnoRET

/*/{Protheus.doc} SetRecnoRET
Obtém o recno do documento Retorno simbólico

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SetRecnoRET(nRecnoRET) Class DHLIp150
	::nRecnoRET := nRecnoRET
return

/*/{Protheus.doc} GetTipoNf
Obtém o tipo de nota (RCO) ou (RET)

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method GetTipoNf() Class DHLIp150
	
return ::cTipoNf

/*/{Protheus.doc} SetTipoNf
Define o tipo de nota (RCO) ou (RET)

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SetTipoNf(nRecno) Class DHLIp150
	
	::GetAreas()
	
	SF2->(DbGoTo(nRecno))
	
	if SF2->F2_ZZTPNF == REMESSA_CONTA_ORDEM
		::cTipoNf := REMESSA_CONTA_ORDEM
	elseIf SF2->F2_ZZTPNF == AJUSTE_FISCAL
		::cTipoNf := AJUSTE_FISCAL
	elseIf  SF2->F2_ZZTPNF == RETORNO_SIMBOLICO
		::cTipoNf := RETORNO_SIMBOLICO
	elseIf  SF2->F2_ZZTPNF == RETORNO_EFETIVO
		::cTipoNf := RETORNO_EFETIVO
	else
		::cTipoNf := ""
	endIf
	
	::RestAreas()
	
return

/*/{Protheus.doc} GetMsgError
Obtém a mensagem de erro.

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method GetMsgError() Class DHLIp150

return ::cMsgError

/*/{Protheus.doc} SetMsgError
Define a mensagem de erro.

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SetMsgError(cMsgError) Class DHLIp150
	::cMsgError := cMsgError
return


/*/{Protheus.doc} getSalesOrder
Obtém array de pedidos de venda

@author Thiago Meschiatti
@since 19/09/17
@version 1.0
@example
(examples)
/*/
Method getSalesOrder() Class DHLIp150

return aClone(::aSalesOrder)


/*/{Protheus.doc} setSalesOrder
Define a array de pedidos de venda

@author Thiago Meschiatti
@since 19/07/17
@version 1.0
@example
(examples)
/*/
Method setSalesOrder(aSalesOrder) Class DHLIp150
	::aSalesOrder := aSalesOrder
return


/*/{Protheus.doc} addSalesOrder
Adiona itens no array de pedidos de venda

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method addSalesOrder(aSalesOrder) Class DHLIp150
	aadd(::aSalesOrder, aSalesOrder)
return


/*/{Protheus.doc} ExistRCO
Retorna se existe RCO na tabela SZA

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method ExistRCO() Class DHLIp150
return ::lExistRCO

/*/{Protheus.doc} RestAreas
Restaura as áreas

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method RestAreas() Class DHLIp150
	
	if Len(::aAreaSC6) > 0
		RestArea(::aAreaSC6)
		::aAreaSC6:= {}
	endIf
	
	if Len(::aAreaSC5) > 0
		RestArea(::aAreaSC5)
		::aAreaSC5:= {}
	endIf
	
	if Len(::aAreaSZA) > 0
		RestArea(::aAreaSZA)
		::aAreaSZA:= {}
	endIf
	
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

/*/{Protheus.doc} RestAreas
Restaura as áreas

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method HasError() Class DHLIp150
	
return ::lError

/*/{Protheus.doc} SetError
Define se tem erro

@author Gustavo Luiz
@since 19/05/2017
@version 1.0
@example
(examples)
/*/
Method SetError(lError) Class DHLIp150
	::lError := lError
return

/**
* Obtém o cabeçalho na nota
**/
static function GetCab()
	
	local aCab := {}
	
	aAdd(aCab, {"F2_TIPO"	,SF2->F2_TIPO	,nil})
	aAdd(aCab, {"F2_FORMUL"	,SF2->F2_FORMUL ,nil})
	aAdd(aCab, {"F2_DOC"	,SF2->F2_DOC 	,nil})
	aAdd(aCab, {"F2_SERIE"	,SF2->F2_SERIE  ,nil})
	aAdd(aCab, {"F2_EMISSAO",SF2->F2_EMISSAO,nil})
	aAdd(aCab, {"F2_CLIENTE",SF2->F2_CLIENTE,nil})
	aAdd(aCab, {"F2_LOJA"	,SF2->F2_LOJA 	,nil})
	aAdd(aCab, {"F2_ESPECIE",SF2->F2_ESPECIE,nil})
	
	aCab := FwVetByDic(aCab, "SF2")
	
return aCab

/**
* Obtém a query SF2
**/
Static Function RunQuerySF2(cTipo, cChave)
	
	local cQuery := ""
	
	cQuery := " SELECT "											+CRLF
	cQuery += "		F2_DOC,	"										+CRLF
	cQuery += "		F2_SERIE,	"									+CRLF
	cQuery += "		R_E_C_N_O_	"									+CRLF
	cQuery += "	FROM %SF2.SQLNAME% " 								+CRLF
	cQuery += "	WHERE  " 											+CRLF
	
	if cTipo == REMESSA_CONTA_ORDEM
		cQuery += "	F2_ZZTPNF = '"+REMESSA_CONTA_ORDEM+"' AND" 		+CRLF
		cQuery += "	F2_CHVNFE = '"+cChave+"' AND" 					+CRLF
	else
		cQuery += "	F2_ZZTPNF = '"+RETORNO_SIMBOLICO+"' AND" 		+CRLF
		cQuery += "	F2_CHVNFE = '"+cChave+"' AND" 					+CRLF
	endIf
	
	cQuery += " 	%SF2.NOTDEL%"           						+CRLF
	
return cQuery

/**
* Obtém a query SZA
**/
static function RunQuerySZA(cTipo, documento, cSerie)
	
	local cQuery := ""
	
	cQuery := " SELECT "											+CRLF
	cQuery += "		*	"											+CRLF
	cQuery += "	FROM %SZA.SQLNAME% " 								+CRLF
	cQuery += "	WHERE  " 											+CRLF
	
	if cTipo == REMESSA_CONTA_ORDEM
		cQuery += "	ZA_NFRCO = '"+documento+"' AND" 				+CRLF
		cQuery += "	ZA_SERIRCO = '"+cSerie+"' AND" 					+CRLF
	else
		cQuery += "	ZA_NFRET = '"+documento+"' AND" 				+CRLF
		cQuery += "	ZA_SERIRET = '"+cSerie+"' AND" 					+CRLF
	endIf
	
	cQuery += " 	%SZA.NOTDEL%"           						+CRLF
	
return cQuery

/**
* Obtém o recno da SF2 de acordo com a chave NOTA + SÉRIE
**/
static function GetRecnoSF2(cNota, cSerie)
	
	local nRecno := 0
	
	SF2->(DbSetOrder(1))
	
	if SF2->(DbSeek(FwXFilial("SF2") + cNota + cSerie))
		
		nRecno := SF2->(Recno())
		
	endIf
	
return nRecno

/**
* obtém o cabeçalho da nota de saida
**/
static function GetHeaderDocSaida()
	
	local aHeader		:= {}
	
	aAdd(aHeader,{"F2_DOC", 	SF2->F2_DOC			, nil})
	aAdd(aHeader,{"F2_SERIE", 	SF2->F2_SERIE		, nil})
	aAdd(aHeader,{"F2_CLIENTE", SF2->F2_CLIENTE		, nil})
	aAdd(aHeader,{"F2_LOJA", 	SF2->F2_LOJA		, nil})
	aAdd(aHeader,{"F2_FORMUL", 	SF2->F2_FORMUL		, nil})
	aAdd(aHeader,{"F2_TIPO", 	SF2->F2_TIPO		, nil})
	
return aHeader

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
	local lSucess 			:= .F.
	
	aChave 		:= {"F2_DOC","F2_SERIE"}
	aRotAuto 	:= SF2->(MSArrayXDB(aMata520Cab,,5,,aChave))
	
	If !( Len(aRotAuto) > 0 )
		Return .T.
	EndIf
	
	lCanDel := MaCanDelF2("SF2",SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2)
	
	If lCanDel
		
		PcoIniLan("000102")
		lSucess := SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,.F.,.F.,.T.,.F.))
		PcoFinLan("000102")
		
	endIf
	
return lSucess

/**
* Limpa os campos ZA_NFRCO e ZA_SERIRCO
**/
static function limpaCpsRCO()
	
	local cNfRCO 	:= SF2->F2_DOC
	local cSerieRCO := SF2->F2_SERIE
	local cQuery	:= ""
	local oIp040	:= DhlIp040Sap():newDhlIp040Sap()
	local oSqlSZA	:= ipSqlObject():newIpSqlObject()
	local oSqlSZB	:= nil
	local nRecnoSZA	:= 0
	local nRecnoSZB	:= 0
	
	cQuery  := RunQuerySZA(REMESSA_CONTA_ORDEM, cNfRCO, cSerieRCO)
			
	oSqlSZA:NewAlias(cQuery)
	
			
	if 	oSqlSZA:HasRecords()
				
		nRecnoSZA := oSqlSZA:GetValue("R_E_C_N_O_")
		
		SZA->(DbGoTo(nRecnoSZA))
		
		if RecLock("SZA", .F.)
			SZA->ZA_NFRCO 	:= ""
			SZA->ZA_SERIRCO := ""
			SZA->(MsUnLock())
		endIf
		
		oSqlSZB := oIp040:getItensSZB(oSqlSZA:getValue("ZA_KENFSCJ"))
		
		If oSqlSZB:hasRecords()
			While oSqlSZB:notIsEof()
				nRecnoSZB := oSqlSZB:GetValue("R_E_C_N_O_")
			
				SZB->(DbGoTo(nRecnoSZB))
				
				if RecLock("SZB", .F.)
					SZB->ZB_PEDIDO 	:= CriaVar("ZB_PEDIDO")
					SZB->ZB_ITEMPV 	:= CriaVar("ZB_ITEMPV")
					SZB->(MsUnLock())
				endIf
				
				oSqlSZB:skip()
			EndDo
		Endif
		
		oSqlSZB:close()
	endIf
	
	oSqlSZA:close()
	
return

/**
* Limpa os campos ZA_NFRET e ZA_SERIRET
**/
static function limpaCpsRet(lLimpaItens)
	
	local cNfRET 	:= SF2->F2_DOC
	local cSerieRET := SF2->F2_SERIE
	local cQuery	:= ""
	local oIp040	:= DhlIp040Sap():newDhlIp040Sap()
	local oSqlSZA	:= ipSqlObject():newIpSqlObject()
	local oSqlSZB	:= nil
	local nRecnoSZA	:= 0
	local nRecnoSZB	:= 0
	
	cQuery  := RunQuerySZA(RETORNO_SIMBOLICO, cNfRET, cSerieRET)
			
	oSqlSZA:NewAlias(cQuery)
			
	if 	oSqlSZA:HasRecords()
		
		If !lLimpaItens
			nRecnoSZA := oSqlSZA:GetValue("R_E_C_N_O_")
			
			SZA->(DbGoTo(nRecnoSZA))
			
			if RecLock("SZA", .F.)
				SZA->ZA_NFRET 	:= ""
				SZA->ZA_SERIRET := ""
				SZA->(MsUnLock())
			endIf
		endif
		
		if validErasePedido()
			oSqlSZB := oIp040:getItensSZB(oSqlSZA:getValue("ZA_KENFSCJ"))
		
			If oSqlSZB:hasRecords()
				While oSqlSZB:notIsEof()
					nRecnoSZB := oSqlSZB:getValue("R_E_C_N_O_")
			
					SZB->(DbGoTo(nRecnoSZB))
				
					if RecLock("SZB", .F.)
						SZB->ZB_PEDIDO 	:= CriaVar("ZB_PEDIDO")
						SZB->ZB_ITEMPV 	:= CriaVar("ZB_ITEMPV")
						SZB->(MsUnLock())
					endIf
				
					oSqlSZB:skip()
				EndDo
			Endif
		
			oSqlSZB:close()
		endIf
	endIf
	
return


/*
** Coleta pedidos de venda da NF
*/
Static Function retSalesOrder(oSelf)
	Local oSql 		:= IpSqlObject():newIpSqlObject()
	Local nPos		:= 0
	Local cSales		:= ""
	Local aSalesOrder	:= {}
	
	oSql:newTable("SD2", "D2_PEDIDO,D2_ITEMPV", "%SD2.XFILIAL% AND D2_DOC = '" + SF2->F2_DOC + "' AND D2_SERIE = '" + SF2->F2_SERIE + "'",, "D2_PEDIDO,D2_ITEMPV")
	
	While oSql:notIsEof()
		
		nPos := aScan(aSalesOrder,{|x| x[POS_SALESORDER] == oSql:getValue("D2_PEDIDO")})
		if nPos == 0
			aAdd(aSalesOrder, {oSql:getValue("D2_PEDIDO"), {oSql:getValue("D2_ITEMPV")}})
		else
			aAdd(aSalesOrder[nPos,POS_ITENS_SALESORDER], oSql:getValue("D2_ITEMPV"))
		endif
		
		oSql:skip()
	End
	oSql:close()
	
	oSelf:setSalesOrder(aSalesOrder)
Return

/*
** Monta cabecalho do pedido
*/
Static Function mountHeader(aHeader)
	
	aAdd(aHeader,{"C5_FILIAL" ,SC5->C5_FILIAL   ,nil})
	aAdd(aHeader,{"C5_NUM"    ,SC5->C5_NUM      ,nil})
	aAdd(aHeader,{"C5_TIPO"   ,SC5->C5_TIPO     ,nil})
	aAdd(aHeader,{"C5_CLIENTE",SC5->C5_CLIENTE  ,nil})
	aAdd(aHeader,{"C5_LOJACLI",SC5->C5_LOJACLI  ,nil})
	aAdd(aHeader,{"C5_CONDPAG",SC5->C5_CONDPAG  ,nil})
	aAdd(aHeader,{"C5_ZZSTATU",""				,nil})
	aAdd(aHeader,{"C5_TPFRETE",SC5->C5_TPFRETE  ,nil})
	aAdd(aHeader,{"C5_ZZTPPV" ,SC5->C5_ZZTPPV   ,nil})
	
Return


/*
** Monta itens do pedido
*/
Static Function mountItems(aItems)
	Local aAux := {}
	
	aAdd(aAux,{"LINPOS"   ,"C6_ITEM" ,SC6->C6_ITEM})
	aAdd(aAux,{"AUTDELETA","S" 	  ,nil})
		
	aAdd(aItems,aAux)
	
	aAux := {}
	
	aAdd(aAux,{"C6_ITEM"    ,SC6->C6_ITEM     ,nil})
	aAdd(aAux,{"C6_PRODUTO" ,SC6->C6_PRODUTO  ,nil})
	aAdd(aAux,{"C6_QTDVEN"  ,SC6->C6_QTDVEN   ,nil})
	aAdd(aAux,{"C6_PRCVEN"  ,SC6->C6_PRCVEN   ,nil})
	aAdd(aAux,{"C6_VALOR"   ,SC6->C6_VALOR    ,nil})
	aAdd(aAux,{"C6_TES" 	  ,alltrim(GetNewPar("ZZ_TESSAI"))      ,nil})
	aAdd(aAux,{"C6_UM" 	  ,SC6->C6_UM       ,nil})
	
	aAdd(aItems,aAux)
	
Return

/*
** Valida se será limpado os campos do pedido de vendas
*/
static function validErasePedido()
	
	local lExclRet  	:= SuperGetMV("ZZ_EXCLRET",,.T.)
	local lRotinExlu	:= IIF(funname()=="MATA521A", .T., .F.)
	local lErasePedido	:= .T.
	
	if lRotinExlu
		
		if lExclRet
			lErasePedido := .F.
		endIf
		
	endIf

return lErasePedido