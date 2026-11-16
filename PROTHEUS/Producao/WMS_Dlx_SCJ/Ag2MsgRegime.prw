#Include 'Protheus.ch'

/*/{Protheus.doc} Ag2MsgRegime
Grava mensagem referente a nota de regime especial

@author Gustavo Luiz
@since 08/08/2017
@version undefined

@param undefined
@type function 
/*/
User Function Ag2MsgRegime()
	
	local oDHL210 := DHLIp210():NewDHLIp210()
	
	oDHL210:checkInfSD2()
	
	if oDHL210:hasInfSD2()
		
		oDHL210:GravMensagem()
		
	endIf
	
Return

