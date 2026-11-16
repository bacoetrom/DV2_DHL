#Include 'Protheus.ch'
#include "rwmake.ch"

/*/{Protheus.doc} VldCont

Rotina utilizada para validação dos campos F4_ZZCTB e F4_DUPLIC.
	
@author Diego de Angelo
@since 29/10/2014

/*/
user function VldContab()
	local cGeraDupli	:= M->F4_DUPLIC
	local cContab		:= M->F4_ZZCTB
	local cCampo		:= ReadVar()
	local lRet			:= .T.
	
	if cCampo	== "M->F4_ZZCTB"
		if cGeraDupli == "S"
			if cContab == "N"
				MsgBox("Operação não permitida pois a TES gera duplicata.", "Atenção", "INFO") 
				lRet	:= .F.
			endIf
		endIf
	elseif cCampo	== "M->F4_DUPLIC"
		if cGeraDupli == "N" .AND. cContab == "S"
			lRet	:= .F.
			MsgBox("Operação não permitida pois a TES está marcada como Contabiliza", "Atenção", "INFO")
		endIf
	endIf
return lRet