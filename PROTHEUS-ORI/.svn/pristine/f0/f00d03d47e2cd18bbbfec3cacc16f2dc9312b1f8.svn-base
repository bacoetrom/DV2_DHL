#Include 'Protheus.ch'

/*/{Protheus.doc} CallDisASNGen

Função responsável em verificar se executa a chamada a função DisAsnGen()
	
@author Gustavo Luiz
@since 06/06/2016

/*/
User Function CallDisASNGen()
	
	If SF1->F1_ZZSTATU=="3" .AND. SF1->F1_TIPO=="D" .AND. SF1->F1_FORMUL=="S"
		u_DisAsnGen()
	Else
		AVISO("","Para enviar ASN é preciso estar com o status 'Pendente de Ação', tipo de devolução = 'D' e formulário próprio = 'S'",{"fechar"},1)
	EndIf
	
Return

