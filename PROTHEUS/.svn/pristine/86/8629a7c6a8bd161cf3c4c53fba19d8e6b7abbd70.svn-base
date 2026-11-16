#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} A100DEL

Ponto de entrada responsável pela validação da exclusão do documento de entrada
O P.E. é chamado antes de qualquer atualizacao na exclusao e deve ser utilizado 
para validar se a exclusao deve ser efetuada ou nao.
	
@author Diego
@since 10/11/2014

@return lRet Indica se será realizada ou não a exclusão.
/*/
user function A100DEL()
	local oDHLProcValid	:= nil
	local cTipoNf		:= DHL_NFE_INVOICE_INFLOW
	local lRet			:= .F.
	local cNota			:= SF1->F1_DOC
	local cEspecie		:= SF1->F1_ESPECIE
	local cSerie		:= SF1->F1_SERIE
	local cChvNfe		:= SF1->F1_CHVNFE
	local cFornec		:= SF1->F1_FORNECE
	local cLoja			:= SF1->F1_LOJA
	local lFormProp		:= (SF1->F1_FORMUL == "S")
	local lImpRet		:= IsInCallStack("u_ImpMsaNfe")
	local lCancel       := SuperGetMV("ZZ_CANCNFE",,.T.)
	local lSerCont		:= aScan(separa(GetNewPar("ZZ_SERCONT", ""), ";"), {|x| x == upper(alltrim(cSerie))}) > 0
	
	if lCancel
		if lImpRet
			lRet	:= .T.
		else
			if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
				U_DHLValidID("DHL_INFORM_ID")
			endif
			if lFormProp				
				if ExistBlock("PrcCancMsa")
					oDHLProcValid	:= DHLProcessValidator():newDHLProcessValidator()
					if oDHLProcValid:validSendInterface(cTipoNf)
						if oDHLProcValid:validDocumentType(cTipoNf, cEspecie)
							U_PrcCancMsa(cTipoNf, cChvNfe, cNota, cSerie, cFornec, cLoja)
							if lSerCont
								lRet := .T.
								u_PrcConti(DHL_NF_SAIDA, DHL_OPC_EXCLUSAO,  SF2->(Recno()))
							endif
						endIf
					else
						lRet := .T.
					endIf
				endIf
			else
				lRet := .T.
			endIf
		endIf
	else
		lRet := .T.
	endif
return lRet