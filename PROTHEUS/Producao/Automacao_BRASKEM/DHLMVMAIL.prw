#Include 'Totvs.ch'
#Include 'DHL.ch'

/*/{Protheus.doc} DHLBXMAIL
		@author 	Edson Deluca 
		@version 	1.0
		@since 		12/05/2018	
/*/
******************************************************************************************************************
User Function DHLMVMAIL(cParam1,cParam2)
******************************************************************************************************************

    RpcSetEnv(cParam1,cParam2)

    Private _cCNPJ    := SuperGetMV("ZZ_CNPJDEP",,"")
    Private cCNPJDest := ""

    Private _cDirectory := "\" + alltrim(Posicione("SZ1",1, xFilial("SZ1") + APP_BAIXA_XML, "Z1_DIRIMP"))
    Private _cDirectory := if(substr(_cDirectory, len(_cDirectory),1) == "\", _cDirectory, _cDirectory+"\")
//  \automacao\anexos\

    Private _cDestTrf   := alltrim(Posicione("SZ1",1, xFilial("SZ1") + APP_IMPORTADOR_XML, "Z1_DIRIMP"))
//	Private _cDestTrf   := "\sdi\sdi_to_protheus\"
    Private _cDestTrf   := if(substr(_cDestTrf, len(_cDestTrf),1) == "\", _cDestTrf, _cDestTrf+"\")

    Private _cDestTer   := "\" + alltrim(Posicione("SZ1",1, xFilial("SZ1") + APP_AUT, "Z1_DIRIMP"))
//	Private _cDestTer   := "\automacao\terceiros\"	
    Private _cDestTer   := if(substr(_cDestTer, len(_cDestTer),1) == "\", _cDestTer, _cDestTer+"\")

    FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Iniciando JOB", 0, 0, {})
  
	oDir 	:= DHLDirectoryManager():newDHLDirectoryManager(_cDirectory)
	aFiles	:= oDir:getFiles()
		
	for nJ:= 1 to len(aFiles)

	   cXML		    := aFiles[nJ]
	   oXMLUtil		:= ipXmlObject():newIpXmlObject(cXML)
	   oXMLUtil:doParse()
	   cCnpjDest	:= getCnpj(oXMLUtil)

	   FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "CNPJ Destino: " + cCNPJDest, 0, 0, {})
  
       ClassXML(cXML,cCNPJDest,_cCNPJ)
       
	next nJ
		
    FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Finalizando JOB", 0, 0, {})
    
    RpcClearEnv()

return

***********************************************
Static Function ClassXML(cXML,cCNPJDest,_cCNPJ)
***********************************************

Local _lTerceiro := .F.
Local _lNFTransf := .F.

FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "CNPJ Destino: " + cCNPJDest, 0, 0, {})
FWLogMsg("INFO","LAST", "BusinessObject", funName(), "", "01", "CNPJ Depositante: " + _cCNPJ, 0, 0, {})
 
If cCNPJDest $ _cCNPJ
   _lNFTransf := .T.
Else
   _lTerceiro := .T.
EndIf

_cNomeArq := ""

For _nX := Len(allTrim(cXML)) to 1 Step -1

   If Substr(cXML,_nX,1) == "\"
     
      _cNomeArq := Substr(cXML,_nX+1,Len(Alltrim(cXML))-_nX)
      
      Exit
   
   EndIf

Next _nX

If _lTerceiro
   FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Transferência para Terceiros: " + AllTrim(cXML) + " para " + (_cDestTer+_cNomeArq), 0, 0, {})
   Copy File &(cXML) to &(_cDestTer+_cNomeArq) 
   _lTerceiro := .F.
   fErase(cXML)
EndIf

If _lNFTransf
   FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Transferência para Transferências: " + AllTrim(cXML) + " para " + (_cDestTrf+_cNomeArq), 0, 0, {})
   Copy File &(cXML) to &(_cDestTrf+_cNomeArq) 
   _lNFTransf := .F.
   fErase(cXML)
EndIf

Return

*********************************
static function getCnpj(oXmlUtil)
*********************************
	local cStrXml	:= ""
	
	If !empty(oXmlUtil:getNodeValue("nfeproc:_nfe:_infnfe:_dest:_cnpj:text"))
		cStrXml := "nfeproc:_nfe:_infnfe:_dest:_cnpj:text"
	elseIf !empty(oXmlUtil:getNodeValue("infnfe:_dest:_cnpj:text"))
		cStrXml	:= "infnfe:_dest:_cnpj:text"
	elseif !empty(oXmlUtil:getNodeValue("envinfe:_nfe:_infnfe:_dest:_cnpj:text"))
		cStrXml	:= "envinfe:_nfe:_infnfe:_dest:_cnpj:text"
	ElseIf !empty(oXmlUtil:getNodeValue("nfe:_infnfe:_dest:_cnpj:text"))
		cStrXml	:= "nfe:_infnfe:_dest:_cnpj:text"
	ElseIf !empty(oXmlUtil:getNodeValue("cteproc:_cte:_infcte:_dest:_cnpj:text"))
		cStrXml := "cteproc:_cte:_infcte:_dest:_cnpj:text"
	EndIF
	
return (oXmlUtil:getNodeValue(cStrXml))
