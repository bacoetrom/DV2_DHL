#INCLUDE "PROTHEUS.CH"
#Include 'dhl.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT103DNF  บ Autor ณEmerson Holandaบ Data ณ  04/05/2020      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Nota Fiscal de Entrada.  			                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 															  บฑฑ
ฑฑบ          ณ Sera verificado se a chv da nfe foi preenchida e se esta   บฑฑ
ฑฑบ          ณ com a quantidade de caracteres correta(44).			      บฑฑ
ฑฑบ          ณ 															  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT103DNF()

	Local aAbaDanfe := PARAMIXB[1]
	Local lRet := .T.

	If !IsBlind() //Somente se possuir interface com o usuario
		If FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
			If Alltrim(cEspecie) $ "SPED#CTE" .And. cFormul # "S"
				If Empty(aAbaDanfe[13])
					ApMsgInfo("ษ obrigatorio informar a chave da nota fiscal eletronica. Favor informar a chave da nota na aba 'Informa็๕es Danfe'.")
					lRet := .F.
				Else
					If Len(Alltrim(aAbaDanfe[13])) < 44
						ApMsgInfo("A chave da nota fiscal eletronica deve possuir 44 caracteres. Favor informar a chave da nota corretamente na aba 'Informa็๕es Danfe'.")
						lRet := .F.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

Return lRet