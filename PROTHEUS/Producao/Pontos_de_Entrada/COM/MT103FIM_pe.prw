#include "totvs.ch"
#include "dhl.ch"


/*/{Protheus.doc} MT103FIM

Ponto de Entrada localizado após o destravamento de todas as tabelas envolvidas na gravação da nota fiscal de entrada.

@author Winston Dellano de Castro / Diego de Angelo
@since 23/10/2014
/*/
user function MT103FIM()

	local oDHLProcValid	:= nil
	local nOpt			:= PARAMIXB[1]
	local lConfirm		:= (PARAMIXB[2] == 1)
	local lFormProp		:= (SF1->F1_FORMUL == "S")
	local cNota			:= SF1->F1_DOC
	local cSerie		:= SF1->F1_SERIE
	local cClieFor		:= SF1->F1_FORNECE
	local cLoja			:= SF1->F1_LOJA
	local cNotaOri		:= SF1->F1_NFORIG
	local cSerieOri		:= SF1->F1_SERORIG
	local cTipoNf		:= DHL_NFE_INVOICE_INFLOW
	local oIdManager	:= DHLIdManager():newDHLIdManager()
	local lInclusao		:= INCLUI
	local lAlteracao	:= ALTERA
	local lSerCont		:= aScan(separa(GetNewPar("ZZ_SERCONT", ""), ";"), {|x| x == upper(alltrim(cSerie))}) > 0
	// [RTC-2026/2027] Unidades e subtipos de Nota de Crédito (F1_TIPO 5) que propagam FCP/UTRIB da NF original.
	// Defaults preservam o comportamento anterior (apenas AG2 / apenas devolução F1_TIPO D).
	local cUnUpdCD2		:= GetNewPar("ZZ_UPDCD2U", DHL_BUSINESSUNIT_AG2)
	local cTpCrdDev		:= GetNewPar("ZZ_UPDCD2C", "")
	
	private oSql        := ipSqlObject():newIpSqlObject()
	
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "ENTROU NO P.E. MT103FIM", 0, 0, {})
	
	// [RTC-2026/2027] Antes restrito a AG2 + devolução. Agora parametrizável por unidade (ZZ_UPDCD2U)
	// e estendido à Nota de Crédito finNFe 5 de retorno/recusa (ex.: ZZ_UPDCD2C = "3|6").
	if  !Empty(FWUnitBusiness()) .and. FWUnitBusiness() $ cUnUpdCD2
		if 	(lInclusao .or. lAlteracao) .and. ;
			(SF1->F1_TIPO == DEVOLUCAO .or. ;
			 (SF1->F1_TIPO == "5" .and. !Empty(cTpCrdDev) .and. !Empty(SF1->F1_TPCOMPL) .and. AllTrim(SF1->F1_TPCOMPL) $ cTpCrdDev))
			u_updImpCD2()
		endIf
	endif
	
	if lConfirm
		if lInclusao .or. (lAlteracao .and. nOpt == 4)
			if lFormProp
				if ExistBlock("PrcXmlNfe")
					oDHLProcValid	:= DHLProcessValidator():newDHLProcessValidator()
					if oDHLProcValid:validDocumentType(cTipoNf,cEspecie)
						U_PrcXmlNfe(cTipoNf,cSerie,cNota,cClieFor,cLoja,cNotaOri,cSerieOri)
						if lSerCont
							u_PrcConti(DHL_NF_ENTRADA, DHL_OPC_INCLUSAO, SF1->(Recno()))
						endif
					endif
				endif
			endif
		endif
		
		if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
			if lInclusao .OR. lAlteracao
				if ExistBlock("ProcContrID")
					u_ProcContrID(nOpt,lConfirm)
				endif
			endif
		elseif FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
			if lInclusao
				u_GrvInfNfEnt()
			endif
		endif
	endif
	
return