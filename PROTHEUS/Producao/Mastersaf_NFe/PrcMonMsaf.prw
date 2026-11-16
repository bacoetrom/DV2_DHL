#include "protheus.ch"
#include "fwmvcdef.ch"
#include "dhl.ch"
#include "rwmake.ch"

#define MVC_TITLE               "Monitor NFe SEFAZ"
#define DHL_NFE_MONITOR_INFLOW 	"1"
#define DHL_NFE_MONITOR_OUTFLOW "2"


/*/{Protheus.doc} PrcMonMsaf

Monitor para acompanhamento das notas de entrada e saída

@author Diego
@since 12/11/2014

/*/
user function PrcMonMsaf()

	local cPrxTable    := ""
	local cFilterTable := ""
	local oBrowse      := nil

	private oParamBox     	 := nil
	private cTypeInv      	 := ""
	private bResend       	 := {|| resend()}
	private bInvConf      	 := {|| InvConf()}
	private bAsnDlx       	 := {|| AsnDlx()}
	private bResCTe	   	   	 := {|| Cteresend()}
	private bRSymbCancResend := {|| RSymbCancResend()}
	private bRegimeEspResend := {|| RegimeEspResend()}
	private	bSimular		 := {|| SimularAprov()}
	private cAliasBrw    	 := ""
	private cCadastro     	 := ""

	oBrowse := FwMBrowse():new()

	Set(_SET_DELETED,.F.)

	if !(showParam())
		return
	endIf

	cTypeInv := oParamBox:getValue("tipoNota")

	if cTypeInv	== DHL_NFE_MONITOR_INFLOW
		cPrxTable    := "F1_"
		cAliasBrw    := "SF1"
		cFilterTable := "AllTrim(F1_ESPECIE) <> '" + DHL_ESPECIE_INVENTARIO + "'"
	else
		cPrxTable    := "F2_"
		cAliasBrw    := "SF2"
		cFilterTable := "F2_SERIE <> '" + DHL_SERIE_INVENTARIO + "'"
	endIf

	oBrowse:setAlias(cAliasBrw)

	oBrowse:setFilterDefault(cFilterTable)

	oBrowse:setDescription(MVC_TITLE)

	//	if cTypeInv == DHL_NFE_MONITOR_OUTFLOW
	oBrowse:addLegend("u_ExistInut()", "BR_BRANCO"	, "NF Inutilizada")
	//	endIf
	oBrowse:addLegend("Deleted()"														, "BR_CANCEL"	, "NF Cancelada"				)

	//oBrowse:addLegend(cPrxTable+"FIMP==' ' .AND. AllTrim("+cPrxTable+"ESPECIE)=='SPED'"	, "DISABLE"		, "NF Não Transmitida"			)
	oBrowse:addLegend(cPrxTable+"FIMP==' ' .AND. !u_ExistInut() "											, "DISABLE"		, "NF Não Transmitida"			)
	oBrowse:addLegend(cPrxTable+"FIMP=='"+DHL_NFE_MONITOR_AUTORIZADA+"' .AND. !u_ExistInut() "				, "ENABLE"		, "NF Autorizada"				)
	oBrowse:addLegend(cPrxTable+"FIMP=='"+DHL_NFE_MONITOR_TRANSMITIDA+"'.AND. !u_ExistInut()  "				, "BR_AZUL"		, "NF Transmitida"				)
	oBrowse:addLegend(cPrxTable+"FIMP=='"+DHL_NFE_MONITOR_USO_DENEGADO+"'.AND. !u_ExistInut()  "				, "BR_CINZA"	, "NF Uso Denegado"				)
	oBrowse:addLegend(cPrxTable+"FIMP=='"+DHL_NFE_MONITOR_NAO_AUTORIZADA+"'.AND. !u_ExistInut()  "			, "BR_PRETO"	, "NF Não Autorizada"			)
	oBrowse:addLegend(cPrxTable+"FIMP=='"+DHL_NFE_MONITOR_EM_CANCELAMENTO+"' .AND. !u_ExistInut()  "			, "BR_AMARELO"	, "NF Em Cancelamento"			)
	oBrowse:addLegend(cPrxTable+"FIMP=='"+DHL_NFE_MONITOR_CANCEL_NAO_AUTORIZADO+"' .AND. !u_ExistInut()  " 	, "BR_PINK"		, "Cancelamento Não Autorizado"	)

	oBrowse:refresh()
	oBrowse:activate()

	Set(_SET_DELETED,.T.)

return


/**
* Função responsável pela exibição da tela de parâmetros.
**/
static function showParam()
	
	local cNome   := "PrcMonMsaf"
	local cTitulo := "Tipo de Nota Fiscal"
	
	oParamBox := IpParamBoxObject():newIpParamBoxObject(cNome)
	
	oParamBox:setTitle(cTitulo)
	
	oParam := IpParamObject():newIpParamObject("tipoNota", "combo", "Tipo da Nota Fiscal", "C", 60)
	
	oParam:setValues({"1=Entrada", "2=Saída"})
	oParamBox:addParam(oParam)
	
return oParamBox:show()


/**
* Função responsável pela definição das opções de menu.
**/
static function menuDef()
	
	local aRotina := {}
	
	//ADD OPTION aRotina Title "Inutilização"	Action 'u_PrcInutMsa()' 	OPERATION 4	ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"		    ACTION "AxVisual" 		OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Retransmitir"	    	ACTION "Eval(bResend)"	OPERATION 2	ACCESS 0
	
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_MUL) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_SPL)
		ADD OPTION aRotina TITLE "Reenviar Invoice Confirmation"	ACTION "Eval(bInvConf)"	OPERATION 4	ACCESS 0
		ADD OPTION aRotina TITLE "ASN DLX"	            	ACTION "Eval(bAsnDlx)"	OPERATION 4	ACCESS 0
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_REP .or. FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		ADD OPTION aRotina TITLE "Reenviar Invoice Confirmation"	ACTION "Eval(bInvConf)"	OPERATION 4	ACCESS 0
		ADD OPTION aRotina TITLE "Reenviar CTe"	ACTION "Eval(bResCTe)"	OPERATION 4	ACCESS 0
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AGE .or. FWUnitBusiness() == DHL_BUSINESSUNIT_DI2
		ADD OPTION aRotina TITLE "Reenviar Invoice Confirmation"	ACTION "Eval(bInvConf)"	OPERATION 4	ACCESS 0
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AGL
		ADD OPTION aRotina TITLE "Reenviar Invoice Confirmation"	ACTION "Eval(bInvConf)"	OPERATION 4	ACCESS 0
		ADD OPTION aRotina TITLE "Simular Aprovacao SEFAZ"			ACTION "Eval(bSimular)"	OPERATION 4	ACCESS 0
		ADD OPTION aRotina TITLE "Reenviar CTe"	ACTION "Eval(bResCTe)"	OPERATION 4	ACCESS 0 // Adicionado opção devido filial AGL com operação REP
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
		ADD OPTION aRotina TITLE "Reenviar Interface - Cancelamento Retorno Simbólico - IP160"	ACTION "Eval(bRSymbCancResend)" 	OPERATION 4	ACCESS 0
		ADD OPTION aRotina TITLE "Reenviar Interface - Regime Especial - IP200"	ACTION "Eval(bRegimeEspResend)" 	OPERATION 4	ACCESS 0
	endif
	
return aRotina


/**
* Reenvio da interface Invoice Confirmation
**/
static function InvConf()
	
	local cTipoNota := oParamBox:getValue("tipoNota")
	local lModelo3	:= alltrim(GetNewPar("ZZ_MODEFAT", "1")) $ "3"
	local oModelo3	:= DHLModelo3():NewDHLModelo3()
	local cTipoNF	:= SF2->F2_ZZTPNF
	oModelo3:VerifItNF1(SF2->(recno()))
	DbGoto(SF2->(recno()))
	CMODFAT3 := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_ZZMODFA")
	IF alltrim(CMODFAT3) $ "1" .AND. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
		lModelo3 := .T.
	endif

	//INICIO PERSONALIZAÇÃO MODELO 3 GUSTAVO LUIZ (11/05/2017)
	if FWUnitBusiness() == DHL_BUSINESSUNIT_PKG .AND. lModelo3
		oModelo3:VerifItNF1(SF2->(recno()))
		if !oModelo3:IsTesTransferencia()
			if SF2->F2_FIMP == DHL_NFE_MONITOR_AUTORIZADA
				oModelo3:GetDadoNFReferenc()
				if oModelo3:ExistNFRef()
					if oModelo3:IsNfRefAutorizada()
					
						oModelo3:GetRecnosNF(SF2->(recno()), cTipoNF)
						oModelo3:VerifItNF1(oModelo3:GetRecnNF1())
					
						if oModelo3:IsTesRede()
							MsAguarde({|| u_InvConfirmation(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo da nota/série "+AllTrim(SF2->F2_DOC)+ "/" + AllTrim(SF2->F2_DOC) + AllTrim(SF2->F2_SERIE) + " ...") //REGRA REFERENTE AO ITEM A DO CASO DE USO 1.8
							return
						else
							MsAguarde({|| u_InvConfirmation(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo da nota/série "+AllTrim(SF2->F2_DOC)+ "/" + AllTrim(SF2->F2_DOC) + AllTrim(SF2->F2_SERIE) + " ...")
						
						//CASO FOR COBRANÇA DE KIT, TENHO QUE POSICIONAR NO REFERENCIA (NF2). CASO FOR RETORNO DE IND. POSICIONO NA REFERENCIA (NF1)
							if cTipoNF == COBRANCA_KIT
								oModelo3:Posiciona(oModelo3:GetRecnNF2())
							else
								oModelo3:Posiciona(oModelo3:GetRecnNF1())
							endIf
						
							MsAguarde({|| u_InvConfirmation(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo da nota/série "+AllTrim(SF2->F2_DOC)+ "/" + AllTrim(SF2->F2_DOC) + AllTrim(SF2->F2_SERIE) + " ...")
							oModelo3:RetornaAreas()
						
							return
						endIf
					else
						MsgBox("A interface Invoice Confirmation somente pode ser reenviada para Notas Fiscais de saída autorizadas. Verifique a nota/série " + AllTrim(oModelo3:GetRefNf()) + "/" + AllTrim(oModelo3:GetRefSerie()),"Atenção","INFO")
						return
					endIf
				endIf
			else
				MsgBox("A interface Invoice Confirmation somente pode ser reenviada para Notas Fiscais de saída autorizadas.","Atenção","INFO")
				return
			endIf
		endIf
	endIf
	//FIM PERSONALIZAÇÃO MODELO 3 GUSTAVO LUIZ (11/05/2017)

	//RONI SILVA INICIO

	//INICIO PERSONALIZAÇÃO MODELO 3 GUSTAVO LUIZ (11/05/2017)
	if FWUnitBusiness() == DHL_BUSINESSUNIT_MUL .AND. lModelo3
		oModelo3:VerifItNF1(SF2->(recno()))
		DbGoto(SF2->(recno()))
		CMODFAT3 := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_ZZMODFA")
		IF alltrim(CMODFAT3) $ "1" .AND. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
			lModelo3 := .T.
		endif
		if !oModelo3:IsTesTransferencia()
			if SF2->F2_FIMP == DHL_NFE_MONITOR_AUTORIZADA
				oModelo3:GetDadoNFReferenc()
				if oModelo3:ExistNFRef()
					if oModelo3:IsNfRefAutorizada()
					
						oModelo3:GetRecnosNF(SF2->(recno()), cTipoNF)
						oModelo3:VerifItNF1(oModelo3:GetRecnNF1())
					
						if oModelo3:IsTesRede()
							MsAguarde({|| u_InvConfirmation(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo da nota/série "+AllTrim(SF2->F2_DOC)+ "/" + AllTrim(SF2->F2_DOC) + AllTrim(SF2->F2_SERIE) + " ...") //REGRA REFERENTE AO ITEM A DO CASO DE USO 1.8
							return
						else
							MsAguarde({|| u_InvConfirmation(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo da nota/série "+AllTrim(SF2->F2_DOC)+ "/" + AllTrim(SF2->F2_DOC) + AllTrim(SF2->F2_SERIE) + " ...")
						
						//CASO FOR COBRANÇA DE KIT, TENHO QUE POSICIONAR NO REFERENCIA (NF2). CASO FOR RETORNO DE IND. POSICIONO NA REFERENCIA (NF1)
							if cTipoNF == COBRANCA_KIT
								oModelo3:Posiciona(oModelo3:GetRecnNF2())
							else
								oModelo3:Posiciona(oModelo3:GetRecnNF1())
							endIf
						
							MsAguarde({|| u_InvConfirmation(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo da nota/série "+AllTrim(SF2->F2_DOC)+ "/" + AllTrim(SF2->F2_DOC) + AllTrim(SF2->F2_SERIE) + " ...")
							oModelo3:RetornaAreas()
						
							return
						endIf
					else
						MsgBox("A interface Invoice Confirmation somente pode ser reenviada para Notas Fiscais de saída autorizadas. Verifique a nota/série " + AllTrim(oModelo3:GetRefNf()) + "/" + AllTrim(oModelo3:GetRefSerie()),"Atenção","INFO")
						return
					endIf
				endIf
			else
				MsgBox("A interface Invoice Confirmation somente pode ser reenviada para Notas Fiscais de saída autorizadas.","Atenção","INFO")
				return
			endIf
		endIf
	endIf
	//FIM PERSONALIZAÇÃO MODELO 3 GUSTAVO LUIZ (11/05/2017)


	//RONI SILVA FIM


	if cTipoNota == DHL_NFE_MONITOR_OUTFLOW
		if SF2->F2_FIMP == DHL_NFE_MONITOR_AUTORIZADA
			if FWUnitBusiness() == DHL_BUSINESSUNIT_REP .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_AGL .and. isRepair(SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO))
				MsAguarde({|| u_DlxInvConf(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo ...")
			elseif FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
				//Não gerar Invoice Confirmation  //Elmo, em 26/09/22
				If UnidNegCliFor(SF2->F2_CLIENTE,SF2->F2_LOJA,"C")=="REV" //Elmo, em 26/09/22
					MsgBox("Unidade de Negócio atendida pelo cliente (REV) não permite a geração de Invoice Confirmatiion!","Atenção","INFO") //Elmo, em 26/09/22
				Else  //Elmo, em 26/09/22
					MsAguarde({|| u_DisInvConf(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo ...")
				Endif  //Elmo, em 26/09/22
			elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AGE
				MsAguarde({|| u_AgeInvConf(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo ...")
			elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AGL
				MsAguarde({|| u_AglInvConf(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo ...")	
			elseif FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
				MsAguarde({|| u_splinvconf(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo ...")
			elseif FWUnitBusiness() == DHL_BUSINESSUNIT_DI2
				MsAguarde({|| u_Di2InvConf(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo ...")
			else
				MsAguarde({|| u_InvConfirmation(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo ...")
			endif
		else
			MsgBox("A interface Invoice Confirmation somente pode ser reenviada para Notas Fiscais de saída autorizadas.","Atenção","INFO")
		endif
	else
		MsgBox("A interface Invoice Confirmation somente pode ser reenviada para Notas Fiscais de saída autorizadas.","Atenção","INFO")
	endif
	
return


/**
* Reenvio da interface ASN DLX
**/
static function AsnDlx()
	
	local cTipoNota    := oParamBox:getValue("tipoNota")
	local cTransaction := "03"
	
	if cTipoNota == DHL_NFE_MONITOR_OUTFLOW
		if SF2->F2_FIMP == DHL_NFE_MONITOR_AUTORIZADA .OR. SF2->(Deleted())
			
			if SF2->(Deleted())
				cTransaction := "04"
			endif
			
			MsAguarde({|| u_ASNDLXGenerate(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,cTransaction,SF2->F2_TIPO)}, "Aguarde", "Gerando arquivo ...")
		else
			MsgBox("A interface ASN DLX somente pode ser reenviada para Notas Fiscais de saída autorizadas ou canceladas.","Atenção","INFO")
		endif
	else
		MsgBox("A interface ASN DLX somente pode ser reenviada para Notas Fiscais de saída autorizadas ou canceladas.","Atenção","INFO")
	endif
	
return


/**
* Função responsável pelo retransmissão da nota selecionada.
**/
static function resend()
	
	local lRet		:= .F.
	local cNota		:= ""
	local cSerie	:= ""
	local cClieFor	:= ""
	local cLoja		:= ""
	local cNotaOri	:= ""
	local cSerieOri	:= ""
	local cTipo		:= ""
	local cStatus	:= ""
	local cEspecie	:= ""
	local lModelo3	:= alltrim(GetNewPar("ZZ_MODEFAT", "1")) $ "3"
	local oModelo3	:= DHLModelo3():NewDHLModelo3()
	local cTipoNota := oParamBox:getValue("tipoNota")

	if cTipoNota == "2"
		//RONI SILVA INICIO
		oModelo3:VerifItNF1(SF2->(recno()))
		DbGoto(SF2->(recno()))
		CMODFAT3 := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_ZZMODFA")
		IF alltrim(CMODFAT3) $ "1" .AND. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
			lModelo3 := .T.
		endif
		//RONI SILVA FIM
	endif
	Set(_SET_DELETED,.T.)
	
	//INICIO PERSONALIZAÇÃO MODELO 3 GUSTAVO LUIZ (11/05/2017)
	if FWUnitBusiness() == DHL_BUSINESSUNIT_PKG .AND. lModelo3
		oModelo3:VerifItNF1(SF2->(Recno()))
		if !oModelo3:IsTesTransferencia()
			if cTipoNota == DHL_NFE_MONITOR_OUTFLOW
				if SF2->F2_ZZTPNF == RETORNO_INDUSTRIALIZACAO
					oModelo3:GetDadoNFReferenc()
					if oModelo3:ExistNFRef()
						if !oModelo3:IsNfRefAutorizada()
							MsgBox("A nota fiscal referenciada " + oModelo3:GetRefNf() + " série " + allTrim(oModelo3:GetRefSerie()) + " não esta autorizado pelo SEFAZ. Retransmissão não efetuada." , "Atenção", "INFO")
							Set(_SET_DELETED,.f.)
							return
						endIf
					endIf
				else
					if empty(SF2->F2_ZZNFREF)
						MsgInfo("A nota fiscal referenciada ainda não foi faturada. A retransmissão não pode ser efetuada. ")
						Set(_SET_DELETED,.f.)
						return
					endIf
				endIf
			endIf
		endIf
	endIf
	//FIM PERSONALIZAÇÃO MODELO 3 GUSTAVO LUIZ (11/05/2017)

//RONI SILVA INICIO
	if FWUnitBusiness() == DHL_BUSINESSUNIT_MUL .AND. lModelo3 .and. !empty(SF2->F2_ZZNFREF)
		oModelo3:VerifItNF1(SF2->(Recno()))
		if !oModelo3:IsTesTransferencia()
			if cTipoNota == DHL_NFE_MONITOR_OUTFLOW
				if SF2->F2_ZZTPNF == RETORNO_INDUSTRIALIZACAO
					oModelo3:GetDadoNFReferenc()
					if oModelo3:ExistNFRef()
						if !oModelo3:IsNfRefAutorizada()
							MsgBox("A nota fiscal referenciada " + oModelo3:GetRefNf() + " série " + allTrim(oModelo3:GetRefSerie()) + " não esta autorizado pelo SEFAZ. Retransmissão não efetuada." , "Atenção", "INFO")
							Set(_SET_DELETED,.f.)
							return
						endIf
					endIf
				else
					if empty(SF2->F2_ZZNFREF)
						MsgInfo("A nota fiscal referenciada ainda não foi faturada. A retransmissão não pode ser efetuada. ")
						Set(_SET_DELETED,.f.)
						return
					endIf
				endIf
			endIf
		endIf
	endIf

//RONI SILVA FIM

	if cTypeInv == DHL_NFE_MONITOR_INFLOW
		cNota		:= SF1->F1_DOC
		cSerie		:= SF1->F1_SERIE
		cClieFor	:= SF1->F1_FORNECE
		cLoja		:= SF1->F1_LOJA
		cNotaOri	:= SF1->F1_NFORIG
		cSerieOri	:= SF1->F1_SERORIG
		cTipo		:= DHL_NFE_INVOICE_INFLOW
		cStatus		:= SF1->F1_FIMP
		cEspecie	:= SF1->F1_ESPECIE
	else
		cNota		:= SF2->F2_DOC
		cSerie		:= SF2->F2_SERIE
		cClieFor	:= SF2->F2_CLIENTE
		cLoja		:= SF2->F2_LOJA
		cNotaOri	:= SF2->F2_NFORI
		cSerieOri	:= SF2->F2_SERIORI
		cTipo		:= DHL_NFE_INVOICE_OUTFLOW
		cStatus		:= SF2->F2_FIMP
		cEspecie	:= SF2->F2_ESPECIE
	endif
	
	if !(canResend(cEspecie, cStatus))
		Set(_SET_DELETED,.f.)
		return
	endIf
	
	if !(MsgBox("Deseja retransmitir a nota?", "Aviso", "YESNO"))
		Set(_SET_DELETED,.f.)
		return
	endIf
	
	MsAguarde({|| lRet := U_PrcXmlNfe(cTipo, cSerie, cNota, cClieFor, cLoja, cNotaOri, cSerieOri)}, "Aguarde", "Gerando arquivo ...")
	
	if lRet
		MsgBox("Nota retransmitida com sucesso.", "Atenção", "INFO")
	else
		MsgBox("Erro ao retransmitir nota, verifique a tabela de log.", "Atenção", "ALERT")
	endIf
	
	Set(_SET_DELETED,.f.)
return


/**
* Função responsável pela validação da transmissao.
**/
static function canResend(cEspecie,cStatus)
	
	local lRet := .T.
	
	if Alltrim(cEspecie) != "SPED"
		lRet := .F.
		MsgBox("Somente Notas Fiscais com espécie SPED podem ser retransmitidas", "Atenção", "ALERT")
	elseif Deleted()
		lRet := .F.
		MsgBox("Notas canceladas não podem ser retrasmitidas!", "Atenção", "ALERT")
	endif
	
return lRet


/**
* Função responsável pela validação da transmissao.
**/
static function canCteResend(cEspecie,cStatus)
	
	local lRet := .T.
	
	if Alltrim(cEspecie) != "SPED"
		lRet := .F.
		MsgBox("Somente Notas Fiscais com espécie SPED podem ser retransmitidas", "Atenção", "ALERT")
	elseif cStatus != 'S'
		lRet := .F.
		MsgBox("Somente Notas Fiscais aprovadas podem ser retransmitidas", "Atenção", "ALERT")
	elseif Deleted()
		lRet := .F.
		MsgBox("Notas canceladas não podem ser retrasmitidas!", "Atenção", "ALERT")
	endif
	
return lRet


/**
*	Exibe legenda inutilizadas
**/
user function ExistInut()
	local aArea	:= getArea()
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local lExists
	
	if cTypeInv	== DHL_NFE_MONITOR_INFLOW
		lExists	:= oSqlUtil:exists("SZ5", "Z5_FILIAL = '%SZ5.FILIAL%' AND Z5_DOC = '"+SF1->F1_DOC+"' AND Z5_SERIE = '"+SF1->F1_SERIE+"' AND Z5_STATUS = '2' ")
	else
		lExists	:= oSqlUtil:exists("SZ5", "Z5_FILIAL = '%SZ5.FILIAL%' AND Z5_DOC = '"+SF2->F2_DOC+"' AND Z5_SERIE = '"+SF2->F2_SERIE+"' AND Z5_STATUS = '2' ")
	endif
	
	restArea(aArea)
	
return lExists


/**
* Função responsável pelo retransmissão da nota selecionada.
**/
static function Cteresend()
	
	local lRet		:= .F.
	local cNota		:= ""
	local cSerie	:= ""
	local cClieFor	:= ""
	local cLoja		:= ""
	local cNotaOri	:= ""
	local cSerieOri	:= ""
	local cTipo		:= ""
	local cStatus	:= ""
	local cEspecie	:= ""
	local cTipoNF	:= ""
	
	Set(_SET_DELETED,.T.)
	
	if cTypeInv == DHL_NFE_MONITOR_INFLOW
		cNota		:= SF1->F1_DOC
		cSerie		:= SF1->F1_SERIE
		cClieFor	:= SF1->F1_FORNECE
		cLoja		:= SF1->F1_LOJA
		cNotaOri	:= SF1->F1_NFORIG
		cSerieOri	:= SF1->F1_SERORIG
		cTipo		:= DHL_NFE_INVOICE_INFLOW
		cStatus		:= SF1->F1_FIMP
		cEspecie	:= SF1->F1_ESPECIE
		cTipoNF		:= SF1->F1_TIPO
	else
		cNota		:= SF2->F2_DOC
		cSerie		:= SF2->F2_SERIE
		cClieFor	:= SF2->F2_CLIENTE
		cLoja		:= SF2->F2_LOJA
		cNotaOri	:= SF2->F2_NFORI
		cSerieOri	:= SF2->F2_SERIORI
		cTipo		:= DHL_NFE_INVOICE_OUTFLOW
		cStatus		:= SF2->F2_FIMP
		cEspecie	:= SF2->F2_ESPECIE
		cTipoNF		:= SF2->F2_TIPO
	endif
	
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_AGL .and. !isRepair(cClieFor,cLoja,cTipoNF))
		MsgBox("Somente CTes de depositantes do tipo reparador podem ser retransmitidos.", "Atenção", "ALERT")
		Set(_SET_DELETED,.f.)
		return
	endIf

	if !(canCteResend(cEspecie, cStatus))
		Set(_SET_DELETED,.f.)
		return
	endIf
	
	if !(MsgBox("Deseja retransmitir CTe?", "Aviso", "YESNO"))
		Set(_SET_DELETED,.f.)
		return
	endIf
	
	MsAguarde({|| lRet := U_PrcXmlCte(cTipo, cSerie, cNota, cClieFor, cLoja, cNotaOri, cSerieOri)}, "Aguarde", "Gerando arquivo ...")
	
	if lRet
		MsgBox("CTe retransmitido com sucesso.", "Atenção", "INFO")
	else
		MsgBox("Erro ao retransmitir CTe, verifique a tabela de log.", "Atenção", "ALERT")
	endIf
	
	Set(_SET_DELETED,.f.)
return

/**
* Função responsável pelo geração da interface IP160 (Reenviar Cancellation Symbolic Return)
**/
static function RSymbCancResend()
	
	local oDHLIp160 := DHLIp160():NewDHLIp160()
	local lStatus	:= .F.
	
//	if !Deleted()
	
		Set(_SET_DELETED,.T.)
		
		if !(MsgBox("Deseja gerar a interface IP160?", "Aviso", "YESNO"))
			Set(_SET_DELETED,.f.)
			return
		endIf
	
		oDHLIp160:SetTipoNf(SF2->(Recno()))
	
		if 	oDHLIp160:GetTipoNf() == RETORNO_SIMBOLICO
			
			if SF2->F2_FIMP == "C"
			
				oDHLIp160:SetNfRetSimb(SF2->F2_DOC)
				oDHLIp160:SetSerRetSimb(SF2->F2_SERIE)
				oDHLIp160:SetKeyRet(SF2->F2_CHVNFE)
				oDHLIp160:DefineDocSerSCJ(oDHLIp160:GetTipoNf(), oDHLIp160:GetNfRetSimb(), oDHLIp160:GetSerRetSimb())
				if !oDHLIp160:HasError()
					if oDHLIp160:IsRCOVinculado(oDHLIp160:GetNfRetSimb(), oDHLIp160:GetSerRetSimb())
						if !oDHLIp160:ValidStatusCanc(oDHLIp160:GetNfRCO(), oDHLIp160:GetSerRCO())
							oDHLIp160:SetError(.T.)
							oDHLIp160:SetMsgError("Cancelamento da nota (REMESSA POR CONTA E ORDEM)" + allTrim(oDHLIp160:GetNfRCO()) + " série " + allTrim(oDHLIp160:GetSerRCO()) + " não autorizado pelo SAFAZ" )
						endIf
					endIf
				endIf
				if !oDHLIp160:HasError()
					cXmlFile := oDHLIp160:MountTags()
					cReference  := "_" + oDHLIp160:GetDocSCJ()+ "_" + oDHLIp160:GetSerieSCJ()
					cFileName   := oDHLIp160:getFileName(cReference)
					lStatus := oDHLIp160:WriteFile(cXmlFIle)
			
					if lStatus
						MsgBox("Arquivo " + cReference + " gerado com sucesso", "Atenção", "ALERT")
					endIf
			
				else
					MsgBox(oDHLIp160:GetMsgError(), "Atenção", "ALERT")
				endIf
			else
				MsgBox("Somente Notas Fiscais canceladas podem ser retransmitidas", "Atenção", "ALERT")
			endIf
	
		else
			MsgBox("Somente Notas Fiscais de Retorno Simbólico podem ser retransmitidas", "Atenção", "ALERT")
		endIf
	
		Set(_SET_DELETED,.f.)
	
//	else
//		MsgBox("Notas canceladas não podem ser retrasmitidas!", "Atenção", "ALERT")
//	endIf
	
return

/**
* Reenvio da inteface IP_200 (Regime especial)
**/
static function RegimeEspResend()
	
	local cProtocolo := SF2->F2_CODNFE
	local nRecno	 := SF2->(recno())
	local lStatus	 := .F.
	
	if SF2->F2_ZZTPNF == AJUSTE_FISCAL
		if SF2->F2_FIMP == DHL_NFE_MONITOR_AUTORIZADA	
			
			FWMsgRun(, {|| lOk := lStatus := u_SAPIP200(nRecno, cProtocolo) },,"Aguarde...Gerando Interface IP_200")
			
			if lStatus
				MsgBox("Interface IP_200 gerado com sucesso.", "Atenção", "INFO")
			endIf			
		else
			MsgBox("Nota fiscal não autorizada. O reenvio não pode ser efetuado", "Atenção", "ALERT")
		endIf
	else
		MsgBox("Reenvio só poder ser efetuado para as notas fiscais do tipo Ajuste de Imposto(Regime especial)", "Atenção", "ALERT")
	endIf 
	
return

static function SimularAprov()
	Local cDir    := "E:\totvs\protheus\teste\protheus12_data\MasterSaf_NFe\msafnfe_to_protheus\"
	Local cArq    := "RET_NFE_" +SF2->F2_CHVNFE+ ".txt"
	Local aFilEmp := FWArrFilAtu(cEmpAnt, cFilAnt)
	Local cCnpj	  := aFilEmp[SM0_CGC]	
	Local nHandle := FCreate(cDir+cArq)
	
	If SF2->F2_FIMP == "T"
		If nHandle < 0
			MsgAlert("Erro durante criação do arquivo.")
		Else
			//100;Autorizado o uso da NF-e;33200302836056016029551020000000171005565550;0;00556555;102;02836056016029;33;55;20;03;1;333200000087907;2020-03-10 15:35:52;1;;;;;;;2;17;;							
			
			FWrite(nHandle, "100;Autorizado o uso da NF-e;" + SF2->F2_CHVNFE + ";0;" + SF2->F2_DOC + ";" + SF2->F2_SERIE + ";" + cCnpj + ";33;55;20;03;1;333200000087907;2020-03-10 15:35:52;1;;;;;;;2;17;;")
			
			FClose(nHandle)
			
			MsgAlert("Arquivo de simulação enviado: " + cArq)
		EndIf
	Else
		MsgAlert("Apenas notas com status de TRANSMITIDA geram simulação de aprovação. Atual -> F2_FIMP = " + SF2->F2_FIMP)
	EndIf
return

/**
* Verifica se o depositante é do tipo Reparador
**/
static function isRepair(cClieFor,cLoja,cTipo)
	
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local lRet	 	:= .f.
	
	if (cTypeInv == DHL_NFE_MONITOR_INFLOW .and. AllTrim(cTipo) $ "D/B") .or. (cTypeInv == DHL_NFE_MONITOR_OUTFLOW .and. !(AllTrim(cTipo) $ "D/B"))
		oSqlUtil:newTable("SA1", "A1_COD, A1_LOJA, A1_ZZREPAR", "A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '" + cClieFor + "' AND A1_LOJA = '" + cLoja + "' ")
		if oSqlUtil:hasRecords()
			if oSqlUtil:getValue("A1_ZZREPAR") == "S"
				lRet := .t.
			endIf
		endIf
	else
		oSqlUtil:newTable("SA2", "A2_COD, A2_LOJA, A2_ZZREPAR", "A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = '" + cClieFor + "' AND A2_LOJA = '" + cLoja + "' ")
		if oSqlUtil:hasRecords()
			if oSqlUtil:getValue("A2_ZZREPAR") == "S"
				lRet := .t.
			endIf
		endIf
	endIf
	oSqlUtil:close()
	
return lRet


/*
Função para identificação da Unidade de Negócio atendida pelo Cliente/Fornecedor

A2_ZZUNNEG - c - 3
A1_ZZUNNEG - c - 3

SPL,PKG,REP,DIS,AGE,MUL,AGL,AG2,REV

Autor: Elmo
*/

Static Function UnidNegCliFor(cCodigo,cLoja,cTipo) //cTipo="C" (Cliente) ou "F" (=Fornecedor)

Local _aArea  := GetArea()

If cTipo == "C"
	sa1->(dbSetOrder(1))
	sa1->(dbSeek(xFilial("SA1") + cCodigo + cLoja))
	cRet := sa1->A1_ZZUNNEG
Else
	sa2->(dbSetOrder(1))
	sa2->(dbSeek(xFilial("SA2") + cCodigo + cLoja))
	cRet := sa2->A2_ZZUNNEG
Endif

RestArea(_aArea)

Return( cRet )
