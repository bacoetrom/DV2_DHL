#Include 'Protheus.ch'

User Function readProducts()
	local oEnv			:= IpEnvironmentObject():newIpEnvironmentObject()
	local oDir			:= nil
	local cDirectory 	:= "C:\totvs\protheus\producao\protheus11_data\Sdi\sdi_to_protheus\errors\"
	local nJ			:= 0
	local aEmpFil		:= {}
	local aItems		:= {}
	local aProducts		:= {}
	
	private oXMLUtil 	:= nil
	
	//aadd(aEmpFil,{"01", "061SPL000101"})
	
	//prepAmb(@oEnv, aEmpFil[1, 1], aEmpFil[1, 2])
	
	oDir 	:= DHLDirectoryManager():newDHLDirectoryManager(cDirectory)
	aFiles	:= oDir:getFiles()
	for nJ:= 1 to len(aFiles)
		cXML		:= aFiles[nJ]
		oXMLUtil	:= ipXmlObject():newIpXmlObject(cXML)
		oXMLUtil:doParse()
		
		aItems := collectProds(cXML)
		
		if len(aItems) > 0
			dataCollect(aItems, @aProducts) 
		endif
		
	next nJ
	
	cadProducts(aProducts)

Return


static function collectProds(cXML)
	local aItems := {}
	
	if oXMLUtil:existNode("NFePROC:_Nfe:_InfNfe:_Emit")
		aItems := oXMLUtil:getNodeArray("NFePROC:_Nfe:_InfNfe:_Det")
	elseif oXMLUtil:existNode("InfNfe:_Emit")
		aItems := oXMLUtil:getNodeArray("oXMLUtil:_InfNfe:_Det")
	elseif oXMLUtil:existNode("ENVINFE:_Nfe:_InfNfe:_Emit")
		aItems := oXMLUtil:getNodeArray("oXMLUtil:_NFePROC:_Nfe:_InfNfe:_Det")
	elseif oXMLUtil:existNode("Nfe:_InfNfe:_Emit")
		aItems := oXMLUtil:getNodeArray("Nfe:_InfNfe:_Det")
	else 
		alert("Não foi possível ler o xml ---> "+ cXML)
	endif
	
return aClone(aItems)


static function dataCollect(aItems, aProducts)
	local nI 		:= 0
	local cCst		:= ""
	local cCodPrd	:= ""
	local cDescPrd	:= ""
	local cNCM		:= ""
	local cUN		:= ""
	local cOrig		:= ""
	local nIPI		:= ""
	
	private _oObj	:= nil
	
	for  nI:=1 to len(aItems)
		_oObj := aItems[nI]
		if fTypeVar("_oObj:_IMPOSTO")
			if fTypeVar("_oObj:_IMPOSTO:_IPI")
				if fTypeVar("_oObj:_IMPOSTO:_IPI:_IPITRIB:_CST:TEXT")
					//cCst := _oObj:_IMPOSTO:_IPI:_IPITRIB:_CST:TEXT // IPI CST
				endif
				if fTypeVar("_oObj:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT")			
					nIPI := val(_oObj:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT) // ALIQUOTA IPI
				endif
			endif
			if fTypeVar("_oObj:_IMPOSTO:_ICMS")
				if fTypeVar("_oObj:_IMPOSTO:_ICMS:_ICMS00")
					cOrig := _oObj:_IMPOSTO:_ICMS:_ICMS00:_ORIG:TEXT
					cCst  := _oObj:_IMPOSTO:_ICMS:_ICMS00:_CST:TEXT
				elseif fTypeVar("_oObj:_IMPOSTO:_ICMS:_ICMS10")
					cOrig := _oObj:_IMPOSTO:_ICMS:_ICMS10:_ORIG:TEXT
					cCst  := _oObj:_IMPOSTO:_ICMS:_ICMS10:_CST:TEXT
				elseif fTypeVar("_oObj:_IMPOSTO:_ICMS:_ICMS20")
					cOrig := _oObj:_IMPOSTO:_ICMS:_ICMS20:_ORIG:TEXT
					cCst  := _oObj:_IMPOSTO:_ICMS:_ICMS20:_CST:TEXT
				elseif fTypeVar("_oObj:_IMPOSTO:_ICMS:_ICMS30")
					cOrig := _oObj:_IMPOSTO:_ICMS:_ICMS30:_ORIG:TEXT
					cCst  := _oObj:_IMPOSTO:_ICMS:_ICMS30:_CST:TEXT
				elseif fTypeVar("_oObj:_IMPOSTO:_ICMS:_ICMS40")
					cOrig := _oObj:_IMPOSTO:_ICMS:_ICMS40:_ORIG:TEXT
					cCst  := _oObj:_IMPOSTO:_ICMS:_ICMS40:_CST:TEXT
				elseif fTypeVar("_oObj:_IMPOSTO:_ICMS:_ICMS51")
					cOrig := _oObj:_IMPOSTO:_ICMS:_ICMS51:_ORIG:TEXT
					cCst  := _oObj:_IMPOSTO:_ICMS:_ICMS51:_CST:TEXT
				elseif fTypeVar("_oObj:_IMPOSTO:_ICMS:_ICMS60")
					cOrig := _oObj:_IMPOSTO:_ICMS:_ICMS60:_ORIG:TEXT
					cCst  := _oObj:_IMPOSTO:_ICMS:_ICMS60:_CST:TEXT
				elseif fTypeVar("_oObj:_IMPOSTO:_ICMS:_ICMS90")
					cOrig := _oObj:_IMPOSTO:_ICMS:_ICMS90:_ORIG:TEXT
					cCst  := _oObj:_IMPOSTO:_ICMS:_ICMS90:_CST:TEXT
				else
					Aviso("AVISO","Cadastrar produto via menu: "+ alltrim(_oObj:_PROD:_CPROD:TEXT),{"OK"})
					loop
				endif
			endif
		endif
		if fTypeVar("_oObj:_PROD")
			cCodPrd 	:= _oObj:_PROD:_CPROD:TEXT //CODIGO
			cDescPrd 	:= _oObj:_PROD:_XPROD:TEXT //DESCRICAO
			cNCM		:= _oObj:_PROD:_NCM:TEXT 
			cUN			:= _oObj:_PROD:_UCOM:TEXT //DESCRICAO
		endif
		
		if aScan(aProducts, {|x| upper(alltrim(x[1])) == upper(alltrim(cCodPrd))}) == 0
			aadd(aProducts, {cCodPrd, cDescPrd, cUN, cNCM, cCst, nIPI, cOrig})
		endif
	next nI
return


/*
**
*/
static function cadProducts(aProducts)
	local aItem := {}
	local nI 	:= 0 
	
	private lMsErroAuto	:= .F.
	private lMsHelpAuto := .T.
	
	for nI:=1 to len(aProducts)
		aItem := {}
		lMsErroAuto := .f.
		lMsHelpAuto := .T.
		
		if existProd(alltrim(aProducts[nI, 1]))
		
			aAdd(aItem, {"B1_FILIAL"	, xFilial("SB1")            ,nil})
			aAdd(aItem, {"B1_COD"		, padr(alltrim(aProducts[nI, 1]),tamsx3("B1_COD")[1], ' ')	,nil})
			aAdd(aItem, {"B1_DESC"		, alltrim(aProducts[nI, 2])	,nil})
			aAdd(aItem, {"B1_TIPO"		, "PA"    					,nil})
			aAdd(aItem, {"B1_UM"		, alltrim(aProducts[nI, 3]) ,nil})
			aAdd(aItem, {"B1_LOCPAD"	, "01"  					,nil})
			aAdd(aItem, {"B1_POSIPI"	, alltrim(aProducts[nI, 4]) ,nil})
			aAdd(aItem, {"B1_ORIGEM"	, alltrim(aProducts[nI, 7]) ,nil})
			aAdd(aItem, {"B1_CLASFIS"	, alltrim(aProducts[nI, 5]) ,nil})
			aAdd(aItem, {"B1_IPI"		, aProducts[nI, 6]			,nil})
			aAdd(aItem, {"B1_GRUPO"		, "ZZZZ"     				,nil})	
			
			MsExecAuto({|x,y| MATA010(x,y)}, aItem, 3)
			
			if lMsErroAuto
				mostraerro()
			endIf
		endif
	next nI
return


/*
**
*/
static function existProd(cCodProd)
	local aAreaSB1 	:= SB1->(GetArea())
	local cCodProd	:= padr(cCodProd, tamsx3("B1_COD")[1], ' ')
	local lRet		:= .t.
	
	dbselectarea("SB1")
	SB1->(dbsetorder(1))
	if SB1->(dbseek(xFilial("SB1")+cCodProd))
		lRet := .f.
	endif
	
	restArea(aAreaSB1)
return (lRet)

/*
** Preparação do ambiente para execução do job.
*/
static function prepAmb(oEnv, cDHLEmp, cDHLFil)
	oEnv:setCompany(cDHLEmp)
	oEnv:setBranch(cDHLFil)
	oEnv:load()
return


/**
* Verifica o tipo da variável
**/
Static Function fTypeVar(cVar)
Return ( Type(cVar) != "U")