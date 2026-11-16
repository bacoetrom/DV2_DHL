#INCLUDE "protheus.ch"
#INCLUDE "msobject.ch"


/*/{Protheus.doc} DHLXsSize
Classe para a manipulacao de coordenadas de acordo com a resolucao de cada terminal.  

@author Matheus Nogueira
@since 25/04/06 
@version undefined

@type class
/*/
Class DHLXsSize

	Data aSSize		as Array
	Data nColunas	as Integer
	Data nBorda		as Integer
	Data nPercent	as Integer
	Data nHDialog	as Integer
	Data nVDialog	as Integer
	Data nHorSize	as Integer
	Data nVerSize	as Integer
	Data nHorMax	as Integer
	Data nVerMax	as Integer

	Method New(nParPercent, nParBorda, nParColunas) Constructor
	Method GetCDialog(nParCol, nParLin)
	Method GetCEnchoice(nParCol, nParLin)
	Method GetCGetDados(nParCol, nParLin)
	Method GetCListBox(nParCol, nParLin)

    && Metodos Especias para controle de tela cheia
	Method GetCWindow(nParLin, nParCol)
	Method GetCWLisBox(nParLin, nParCol)	
	Method GetCWGetDados(nParLin, nParCol)
	
EndClass


/*/{Protheus.doc} New
Metodo Construtor

@author Thiago Meschiatti
@since 17/03/2017
@version undefined
@param nParPercent, numeric, descricao
@param nParBorda, numeric, descricao
@param nParColunas, numeric, descricao
@type method
/*/
Method New(nParPercent,nParBorda,nParColunas) Class DHLXsSize

	::nPercent	:= iif(Valtype(nParPercent) == "U", 	100, nParPercent)
	::nColunas	:= iif(Valtype(nParColunas) == "U", 	1, nParColunas)
	::nBorda	:= iif(Valtype(nParBorda) == "U", 		5, nParBorda)
	::aSSize 	:= {0,12,636,308,1100,736,120} //MSAdvSize() //{0,12,636,308,1272,736,120} //MSAdvSize() //Configuracoes do notebook  
	::nHorSize	:= Round( (((::aSSize[5]/2) / 100) * ::nPercent) ,0)     //3
	::nVerSize	:= Round( (((::aSSize[6]/2) / 100) * ::nPercent) ,0)     //4
	::nHDialog	:= ::nHorSize * 2
	::nVDialog	:= ::nVerSize * 2
	::nHorMax	:= ::aSSize[5] + 8
	::nVerMax	:= ::aSSize[6] + 8 
		
Return .T.


/*/{Protheus.doc} GetCDialog
Metodo para retorno de coodenadas do Dialogo

@author Thiago Meschiatti
@since 17/03/2017
@version undefined
@param nParLin, numeric, descricao
@param nParCol, numeric, descricao
@type method
/*/
Method GetCDialog(nParLin, nParCol) Class DHLXsSize

Local nParCol	:= iif(Valtype(nParCol) == "U", 	0, nParCol)
Local nParLin	:= iif(Valtype(nParLin) == "U", 	0, nParLin)
Local nSizeV	:= ::nVDialog + nParLin
Local nSizeH	:= ::nHDialog + nParCol
Local aRet := {nParLin, nParCol, nSizeV, nSizeH }
	
Return aRet


/*/{Protheus.doc} GetCEnchoice
Metodo para retorno de coodenadas da Enchoice

@author Thiago Meschiatti
@since 17/03/2017
@version undefined
@param nParLin, numeric, descricao
@param nParCol, numeric, descricao
@type method
/*/
Method GetCEnchoice(nParLin, nParCol) Class DHLXsSize

Local nParLin	:= Round(  iif(Valtype(nParLin) == "U", 	::nBorda, nParLin)  ,0)
Local nParCol	:= Round(  iif(Valtype(nParCol) == "U", 	::nBorda, nParCol)  ,0)
Local nSizeV	:= ::nVerSize - ::nBorda
Local nSizeH	:= ::nHorSize - ::nBorda
Local aRet		:= {nParLin, nParCol , nSizeV, nSizeH }

Return aRet
                                     

/*/{Protheus.doc} GetCGetDados
Metodo para retorno de coodenadas da GetDados

@author Thiago Meschiatti
@since 17/03/2017
@version undefined
@param nParLin, numeric, descricao
@param nParCol, numeric, descricao
@type method
/*/
Method GetCGetDados(nParLin, nParCol) Class DHLXsSize

Local nParLin	:= Round(  iif(Valtype(nParLin) == "U", 	::nBorda, nParLin)  ,0)
Local nParCol	:= Round(  iif(Valtype(nParCol) == "U", 	::nBorda, nParCol)  ,0)
Local nSizeV	:= ::nVerSize - ::nBorda
Local nSizeH	:= ::nHorSize - ::nBorda
Local aRet		:= {nParLin, nParCol , nSizeV, nSizeH }

Return aRet


/*/{Protheus.doc} GetCListBox
Metodo para retorno de coodenadas da GetDados

@author Thiago Meschiatti
@since 17/03/2017
@version undefined
@param nParLin, numeric, descricao
@param nParCol, numeric, descricao
@type method
/*/
Method GetCListBox(nParLin, nParCol) Class DHLXsSize

Local nParLin	:= Round(  iif(Valtype(nParLin) == "U", 	::nBorda, nParLin)  ,0)
Local nParCol	:= Round(  iif(Valtype(nParCol) == "U", 	::nBorda, nParCol)  ,0)
Local nSizeV	:= ::nVerSize - (::nBorda * 2) - iif(nParLin > ::nBorda, nParLin - ::nBorda,0)
Local nSizeH	:= ::nHorSize - (::nBorda * 2) - iif(nParCol > ::nBorda, nParCol - ::nBorda,0)
Local aRet		:= {nParLin, nParCol, nSizeH, nSizeV }

Return aRet


/*/{Protheus.doc} GetCWindow
Metodo para retorno de coodenadas de Janela Total

@author Thiago Meschiatti
@since 17/03/2017
@version undefined
@param nParLin, numeric, descricao
@param nParCol, numeric, descricao
@type method
/*/
Method GetCWindow(nParLin, nParCol) Class DHLXsSize

Local nParCol	:= iif(Valtype(nParCol) == "U", 	0, nParCol)
Local nParLin	:= iif(Valtype(nParLin) == "U", 	0, nParLin)
Local nSizeV	:= ::nVerMax + if( nParLin > 0, 0, nParLin)+ 4
Local nSizeH	:= ::nHorMax + if( nParCol > 0, 0, nParCol)
Local aRet := {nParLin, nParCol, nSizeV, nSizeH }

//Alert(StrZero(nParLin,4) + " - " + StrZero(nParCol,4) + " - " +  StrZero(nSizeV,4) + " - " + StrZero(nSizeH,4) )	
	
Return aRet


/*/{Protheus.doc} GetCWLisBox
Metodo para retorno de coodenadas de Janela Total

@author Thiago Meschiatti
@since 17/03/2017
@version undefined
@param nParLin, numeric, descricao
@param nParCol, numeric, descricao
@type method
/*/
Method GetCWLisBox(nParLin, nParCol) Class DHLXsSize

Local nParCol	:= iif(Valtype(nParCol) == "U", 	0, nParCol)
Local nParLin	:= iif(Valtype(nParLin) == "U", 	0, nParLin)
Local nSizeV	:= Round((((::nVerMax + if( nParLin > 0, 0, nParLin) ) / 2 ) - nParLin) - ::nBorda + 2, 0 )
Local nSizeH	:= Round((((::nHorMax + if( nParCol > 0, 0, nParCol) ) / 2 ) - nParCol) - ::nBorda, 0 )
Local aRet := {nParLin, nParCol, nSizeH, nSizeV }

//Alert(StrZero(nParLin,4) + " - " + StrZero(nParCol,4) + " - " +  StrZero(nSizeH,4) + " - " + StrZero(nSizeV,4) )	
	
Return aRet

//Alert(StrZero(nParLin,3) + " - " + StrZero(nParCol,3) + " - " +  StrZero(nSizeV,3) + " - " + StrZero(nSizeH,3) )	
//Alert(StrZero(0,3) + " - " + StrZero(0,3) + " - " +  StrZero(::aSSize[6],3) + " - " + StrZero(::aSSize[5],3) )


/*/{Protheus.doc} GetCWGetDados
Metodo para retorno de coodenadas de Janela Total

@author Thiago Meschiatti
@since 17/03/2017
@version undefined
@param nParLin, numeric, descricao
@param nParCol, numeric, descricao
@type method
/*/
Method GetCWGetDados(nParLin, nParCol) Class DHLXsSize

Local nParCol	:= iif(Valtype(nParCol) == "U", 	0, nParCol)
Local nParLin	:= iif(Valtype(nParLin) == "U", 	0, nParLin)
Local nSizeV	:= ::nVerSize - ::nBorda
Local nSizeH	:= ::nHorSize - ::nBorda
Local aRet := {nParLin, nParCol, nSizeV, nSizeH }

// Alert(StrZero(nParLin,4) + " - " + StrZero(nParCol,4) + " - " +  StrZero(nSizeH,4) + " - " + StrZero(nSizeV,4) )	
	
Return aRet
