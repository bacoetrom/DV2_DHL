#Include "Protheus.ch"

#DEFINE CPARAM	"MV_DBLQMOV"
#DEFINE CPARAM2	"MV_ULMES"

/*/{Protheus.doc}	altParam
Função de interface para alteração do parâmetro

@author				Julio Lisboa - FSW TOTVS IP Campinas
@since					21/05/2015 
@return				nil
/*/
User Function altParam()
	
	Local oDlg			:= nil
	
	Private oGetData	:= buscaData(CPARAM)
	Private cData		:= buscaData(CPARAM)
	Private cDataAnt	:= buscaData(CPARAM)
	Private oGetData2	:= buscaData(CPARAM2)
	Private cData2		:= buscaData(CPARAM2)
	Private cDataAnt2	:= buscaData(CPARAM2)
	
	Define MsDialog oDlg From 0,0 to 200,450 Pixel Title "Alteração data de Bloqueio de Movimentos"
	
	@ 11,20 Say "Data (" + CPARAM + ") :" Size 190,240 of oDlg Pixel
	@ 10,90 MsGet oGetData Var cData Size 70,9 of oDlg Pixel Valid !Vazio()
	
	@ 31,20 Say "Data (" + CPARAM2 + ") :" Size 190,240 of oDlg Pixel
	@ 30,90 MsGet oGetData2 Var cData2 Size 70,9 of oDlg Pixel Valid !Vazio()
	
	@ 51,20 Say "A alteração do parâmetro (" + CPARAM2 + ") só deverá ser realizada com a devida "+CRLF+"abertura de estoque!" Size 190,240 of oDlg Pixel
	
	@ 80,60 Button "Ok" of oDlg Pixel Action (altData(),oDlg:End())
	@ 80,90 Button "Cancelar" of oDlg Pixel Action oDlg:End()
	Activate MsDialog oDlg Centered
	
Return

/*/{Protheus.doc}	buscaData
Busca a data do parâmetro

@author				Julio Lisboa - FSW TOTVS IP Campinas
@since					21/05/2015
@return				cData
/*/
Static Function buscaData(cParamAux)
	
	Local cData	:= STOD("")
	
	cData := GetNewPar(cParamAux,STOD(""),cFilAnt)
	
Return (cData)

/*/{Protheus.doc}	altData
Realiza a alteração do parâmetro

@author				Julio Lisboa - FSW TOTVS IP Campinas
@since					21/05/2015
@return				nil
/*/
Static Function altData()
	
	Local cDataTmp	:= DTOS(cData)
	Local cDataTmp2	:= DTOS(cData2)
	Local cMsg			:= ""
	
	If cDataTmp == DTOS(cDataAnt)
		cMsg := "Não foi alterada a data do parâmetro "+CPARAM+". [" + DTOC(cDataAnt) + "]"
	Else
		PutMv(CPARAM,cDataTmp)
		cMsg := "Alterada a data de: " + DTOC(cDataAnt) + " para: " + DTOC(STOD(cDataTmp)) + " parâmetro "+CPARAM+"."
	EndIf
	
	If cDataTmp2 == DTOS(cDataAnt2)
		cMsg += +CRLF+"Não foi alterada a data do parâmetro "+CPARAM2+". [" + DTOC(cDataAnt2) + "]"
	Else
		PutMv(CPARAM2,cDataTmp2)
		cMsg += +CRLF+"Alterada a data de: " + DTOC(cDataAnt2) + " para: " + DTOC(STOD(cDataTmp2)) + " parâmetro "+CPARAM2+"."
	EndIf
	
	MsgAlert(cMsg)
		
Return

/*/{Protheus.doc}	Paramcfop
Realiza a alteração do parâmetro 

@author				Bruno Rocha - IT Products
@since				13/06/2018
@return				nil
/*/
User Function Paramcfop()
	
	Local oDlg			:= nil
	
	Private oGetCFOP	:= GetMV(CPARAM3)
	Private cCFOP		:= GetMV(CPARAM3)
	Private cCFOPAnt	:= GetMV(CPARAM3)
		
	Define MsDialog oDlg From 0,0 to 200,450 Pixel Title "Alteração de CFOPs Importador"
	
	@ 11,20 Say "CFOP (" + CPARAM3 + ") :" Size 190,240 of oDlg Pixel
	@ 10,90 MsGet oGetCFOP Var cCFOP Size 70,9 of oDlg Pixel Valid !Vazio()
	
	@ 51,20 Say "A alteração do parâmetro (" + CPARAM3 + ") só deverá ser realizada quando a inclusão de novas CFOPs existir!" Size 190,240 of oDlg Pixel
	
	@ 80,60 Button "Confirmar" of oDlg Pixel Action (altCfop(),oDlg:End())
	@ 80,90 Button "Cancelar" of oDlg Pixel Action oDlg:End()
	Activate MsDialog oDlg Centered
	
Return

Static Function altCfop()
	
	Local cMsg			:= ""
	
	If cDataTmp == DTOS(cDataAnt)
		cMsg := "Não foi alterado o conteudo parâmetro "+CPARAM3+"."
	Else
		PutMv(CPARAM,cDataTmp)
		cMsg := "Alterado conteudo de: " + cCFOPAnt + " para: " + cCFOP + " parâmetro "+CPARAM+"."
	EndIf
	
	
	MsgAlert(cMsg)
		
Return
