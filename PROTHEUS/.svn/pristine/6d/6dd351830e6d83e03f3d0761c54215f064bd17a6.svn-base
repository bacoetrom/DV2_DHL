#Include 'Protheus.ch'

/*/{Protheus.doc} gthRepCegedim
Função responsável em gatilhar para o campo A1_ZZCEGED o CGC, caso esteja setado o representante como Sim
@author Gustavo Luiz
@since 23/06/2016
@version 1.0
/*/
User Function gthRepCegedim()
	
	Local cCpf:= M->A1_CGC
	
	If M->A1_ZZREPRE=="S"
		M->A1_ZZCEGED := cCpf
	Else
		M->A1_ZZCEGED:=""
	EndIf	

Return M->A1_ZZCEGED

