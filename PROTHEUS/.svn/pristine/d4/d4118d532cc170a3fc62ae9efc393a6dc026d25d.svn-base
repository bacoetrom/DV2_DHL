#Include 'Protheus.ch'

/*/{Protheus.doc} ProcPod3

Objetivo: Este programa irá refazer os lançamentos referentes ao poder de terceiros, analisando 
as notas fiscais de compra e venda.
Importante: As notas fiscais geradas para poder de terceiros são classificadas com relação ao campo "Poder de Terceiros", do TES utilizado.
@author Gustavo Luiz
@since 11/08/2016

/*/
User Function ProcPod3()	
	
	local aArea 		:= Lj7GetArea({"SC5","SC6","SF1","SF2","SD1","SD2","SA1","SA2","SB1","SB5","SF4","SA3","SBZ"})
	Local PARAMIXB 		:= .T.
	Private lMsErroAuto := .F.
	
	MSExecAuto({|x| mata216(x)},PARAMIXB)
	
	IF lMsErroAuto			
		MostraErro()			
	ENDIF
	
	Lj7RestArea(aArea)	 
	
Return
