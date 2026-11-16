#include 'protheus.ch'

/*/{Protheus.doc} DHLMsafDwParameters

Classe responsavel por montar a tela de parametro
	
@author Daniel Braga
@since 31/10/2014

/*/

user function _DHLMsafDWParameters;return

class DHLMsafDWParameters from TLongName 
	data oDlg as Object
	data aRet as Array

	method newDHLMsafDWParameters(nTop, nLeft,nBottom,nRight,cCaption) constructor 
	
	method addSay(cTitle, nRow,nCol,nWidth,nHeight,cName) 
	method addCombo(aItens,nRow,nCol,nWidth,nHeight,cVar,xValue)
	method addCheckBox(nRow,nCol,cTitle,lCheck,nWidth,nHeight,cName) 
	method addGet(nRow,nCol,cVar,nWidth,nHeight,cPicture,xValueIni)
	method addButton(nRow,nCol,cTitle,bAction,nWidth,nHeight,cName)
	method addLine(nRow,nCol,nWidth,nHeight,cName)
	
	method show()
endclass


method newDHLMsafDWParameters(nTop, nLeft,nBottom,nRight,cCaption) class DHLMsafDWParameters
	::oDlg  :=  TDialog():New(nTop, nLeft,nBottom,nRight,cCaption,,,,,nil,nil,,,.T.) 
	::aRet  := {}
return

method addSay(cTitle, nRow,nCol,nWidth,nHeight,cName) class DHLMsafDWParameters

	&(cName) := TSay():Create(::oDlg,{||cTitle},nRow,nCol,,nil,,,,.T.,nil,nil,nWidth,nHeight)
	
return

method addCombo(aItens,nRow,nCol,nWidth,nHeight,cVar,xValue) class DHLMsafDWParameters
	
	&("o"+cVar) := TComboBox():New(nRow,nCol,{|u|if(PCount()>0,xValue:=u,xValue)},; 
    aItens,nWidth,nHeight,::oDlg,,; 
    ,,,,.T.,,,,,,,,,"'"+cVar+"'")
    
    
return

method addCheckBox(nRow,nCol,cTitle,lCheck,nWidth,nHeight,cName) class DHLMsafDWParameters
    
     
    &(cName) := TCheckBox():New(nRow,nCol,cTitle,{|l| IIF(PCount()>0,lCheck:=l,lCheck)},::oDlg,nWidth,nHeight,,,,,,,,.T.,,,)
   
return

method addGet(nRow,nCol,cVar,nWidth,nHeight,cPicture,xValue) class DHLMsafDWParameters
	
	&("o"+cVar) := TGet():New( nRow,nCol,{|u|if(PCount()>0,xValue:=u,xValue)},::oDlg,nWidth,nHeight,cPicture,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cVar,,,, )
	
return

method addButton(nRow,nCol,cTitle,bAction,nWidth,nHeight,cName) class DHLMsafDWParameters

	
	&(cName) := TButton():New(nRow,nCol,cTitle,::oDlg,bAction, nWidth,nHeight,,,.F.,.T.,.F.,,.F.,,,.F. )
   
return 

method addLine(nRow,nCol,nWidth,nHeight,cName) class DHLMsafDWParameters

	&(cName):= tPanel():New(nRow,nCol,"",::oDlg,,,,CLR_BLACK,CLR_BLACK,nWidth,nHeight)

return

method show() class DHLMsafDWParameters

	::oDlg:Activate(,,,.T.,{||.T.},,{||} )
return