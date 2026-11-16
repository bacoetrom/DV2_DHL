#Include 'Protheus.ch'

/*/{Protheus.doc} User Function CallDi2ASNGen
	Função responsável em verificar se executa a chamada da função Di2AsnGen.
	@type  Function
	@author Diogo Mesquita Gamba
	@since 20/02/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function CallDi2ASNGen()
	
	If SF1->F1_ZZSTATU=="3" .AND. SF1->F1_TIPO=="D" .AND. SF1->F1_FORMUL=="S"
		u_Di2AsnGen()
	Else
		AVISO("","Para enviar ASN é preciso estar com o status 'Pendente de Ação', tipo de devolução = 'D' e formulário próprio = 'S'",{"fechar"},1)
	EndIf
	
Return
