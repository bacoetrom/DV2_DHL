#Include 'Protheus.ch'

/*/{Protheus.doc} gthCGCCegedim
Função responsável em gatilhar o CGC para  campo A1_ZZCEGED caso esteja setado o representante como Sim
@author Gustavo Luiz
@since 23/06/2016
@version 1.0
/*/
User Function gthCGCCegedim()
	
	Local cCpf:= M->A1_CGC
	
	If M->A1_ZZREPRE=="S"
		M->A1_ZZCEGED := cCpf
	Else
		M->A1_ZZCEGED:=""
	EndIf	

Return M->A1_ZZCEGED

