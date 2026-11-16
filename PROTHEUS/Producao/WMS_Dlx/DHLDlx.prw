#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"

#define ASN_CONFIRMATION "ASN_CONF"
#define INVOICE_REQUEST  "INV_REQ_"
#define ITEM_MAINTENANCE "ITEM_MAI"
#define STOCK_ADJUSTMENT "STK_ADJ_"
#define CUSTOMER_IP030 	 "CUSTOMER"

#define COMPANY 1
#define BRANCH  2
#define CNPJ    3 

#define CNPJ_BRANCO 		1
#define CNPJ_INEXISTENTE 	2
#define FALHA_LOGAR_EMP     3
#define ERROR_PARSE			4

/*/{Protheus.doc} DHLDlx
Rotina responsável pelo gerenciamento das interfaces de envio de informações ao WMS DLX.

@author Thiago Meschiatti
@since 30/03/2016
@version 1.0
/*/
User Function DHLDlx()
	
	local cDirectory 	:= ""
	local oConnection 	:= Connection():newConnection(CCONN, CSERVERADDR, NPORT)
	local cLockByMsaf	:= "IMPMSANFE"
	local lRet			:= .t.
	
	private aCompanies  := loadCompanies()
	private cEmpDefault := aCompanies[1][COMPANY]
	private cFilDefault := aCompanies[1][BRANCH]
	private oSql     	:= ipSqlObject():newIpSqlObject()
	private oFolder  	:= DHLDirectoryManager():newDHLDirectoryManager("")
	private oLog	  	:= DHLLogManager():newDHLLogManager()
	private oEnv 	  	:= IpEnvironmentObject():newIpEnvironmentObject()
	private oUtils   	:= IpUtilsObject():newIpUtilsObject()	
	private cLayout		:= ""
	private oXml       	:= nil	
	private aFiles     	:= {}
	private lError     	:= .F.

	cDirectory := oConnection:getDirectory(APP_DLX)

	if oEnv:hasMainWindow()
		if MsgBox("Confirma importação das interfaces do Dlx ?", "Atenção", "YESNO")
			aFiles := readFolder(cDirectory)
			
			if len(aFiles) > 0
				setCnpjToFiles(aFiles)				
				orderFilesByCNPJ(aFiles)				
				FWMsgRun(, {|| processFiles()},,"Importando interfaces do Dlx ...")	
				MsgBox("Processamento concluído!", "Aviso", "INFO")
			else
				MsgInfo("Não existem arquivos para serem importados.","DHLDlx")
			endIf
		endIf
	else
		aFiles  := readFolder(cDirectory)

		if len(aFiles) > 0
		
			if !LockByName( cLockByMsaf, .F., .F. )
				return
			endIf
			
			setCnpjToFiles(aFiles)	
			orderFilesByCNPJ(aFiles)				
			processFiles()	
			oEnv:close()
			
			UnLockByName( cLockByMsaf, .F., .F. )
			
		endIf

	endIf

	DelClassIntf()

return lRet

/**
* Ler o diretório de arquivos do WMS Dlx
**/
static function readFolder(cDirectory)

	local cFolder := cDirectory

	oFolder:setDirectory(cFolder)
	aFiles := oFolder:getFiles()

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "DHLDlx - Achou " + Str(Len(aFiles)) + " arquivos." + CRLF, 0, 0, {})

return aFiles


/**
* Processa os arquivo coletados
**/
static function processFiles()

	local nFileNumber := 1
	local cFilePath   := ""		
	local cEmp		  := ""
	local cFil		  := ""
	
	for nFileNumber := 1 to Len(aFiles)
		if aFiles[nFileNumber][2] == ARQUIVO_INVALIDO
			loop
		endif			
		
		cFilePath := aFiles[nFileNumber][1]	
		cCNPJFile := aFiles[nFileNumber][2]			
		lError	  := .F.		

		if empty(cCNPJFile)				
			logError(cEmpDefault, cFilDefault, cFilePath, CNPJ_BRANCO)
			loop
		elseIf !isCNPJInSysCompany(aCompanies, cCNPJFile)			
			logError(cEmpDefault, cFilDefault, cFilePath, CNPJ_INEXISTENTE)
			loop
		endIf			

		getEmpFil(cCNPJFile, aCompanies, @cEmp, @cFil)

		if !setCompany(cEmp, cFil)
			logError(cEmp, cFil, cFilePath, FALHA_LOGAR_EMP)
			loop
		endIf

		if !parserFile(@cFilePath)			
			logError(cEmp, cFil, cFilePath, ERROR_PARSE)	
			loop
		endIf

		cLayout   := defineKind(@cFilePath)

		oFolder:startProcess(cFilePath)			

		if !(lError)
			begin transaction
				if cLayout == ASN_CONFIRMATION
					processConfirmation(@cFilePath)
				elseif cLayout == INVOICE_REQUEST
					processRequest(@cFilePath)
				elseif cLayout == ITEM_MAINTENANCE
					processItem(@cFilePath)
				elseif cLayout == STOCK_ADJUSTMENT
					processStock(@cFilePath)
				elseif cLayout == CUSTOMER_IP030
					processCustomer(@cFilePath)
				endif
			end transaction
		endif

		if lError
			FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "DHLDLX - Arquivo: " +  cFilePath + " Layout: " + cLayout + " com erro." + CRLF, 0, 0, {})
			oFolder:setError(cFilePath)
		else
			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "DHLDLX - Arquivo: " +  cFilePath + " Layout: " + cLayout + " processado." + CRLF, 0, 0, {})
			oFolder:setProcessed(cFilePath)
		endif			
	next nFileNumber
	
return


/**
* Faz o parser do xml
**/
static function parserFile(cFilePath)

	local cError    := ""
	local cWarning  := ""
	local lParsed	:= .T.

	oXml := XmlParserFile(cFilePath,"_",@cError,@cWarning)

	if !(Empty(cError)) .or. !(Empty(cWarning))	
		lError := .T.
		lParsed:= .F.
	endif

return lParsed


/**
* Define o tipo do layout
**/
static function defineKind(cFilePath)

	local cKind := ""

	cKind := Substr(Right(cFilePath,Len(cFilePath) - Rat("\",cFilePath)),1,8)

return Upper(AllTrim(cKind))


/**
* Processa os arquivos do tipo ASN Confirmation
**/
static function processConfirmation(cFilePath)

	If FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		u_DisASNConf(cFilePath)
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AGE
		u_AgeASNConf(cFilePath)
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
		u_Ag2ASNConf(cFilePath)
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AGL
		u_AglASNConf(cFilePath)
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_DI2
		u_Di2ASNConf(cFilePath)
	else
		u_DlxASNConf(cFilePath)
	endif

return


/**
* Processa os arquivos do tipo Invoice Request
**/
static function processRequest(cFilePath)

	If FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		lError := !(u_DisInvReq(cFilePath))
	ElseIf FWUnitBusiness() == DHL_BUSINESSUNIT_AGE
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[AgeInvReq]*** Entrando na Rotina...", 0, 0, {})
		lError := !(u_AgeInvReq(cFilePath))		
	ElseIf FWUnitBusiness() == DHL_BUSINESSUNIT_AGL
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[AglInvReq]*** Entrando na Rotina...", 0, 0, {})
		lError := !(u_AglInvReq(cFilePath))		
	ElseIf FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
		lError := !(u_Ag2InvReq(cFilePath))	
	ElseIf FWUnitBusiness() == DHL_BUSINESSUNIT_DI2
		lError := !(u_Di2InvReq(cFilePath))
	else
		lError := !(u_DlxInvReq(cFilePath))
	endif	

return


/**
* Processa os arquivos do tipo Item Maintenance
**/
static function processItem(cFilePath)

	If FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		u_DisItemMaint(cFilePath)
	ElseIf FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
		u_Ag2ItemMaint(cFilePath)
	ElseIf FWUnitBusiness() == DHL_BUSINESSUNIT_DI2
		u_Di2ItemMaint(cFilePath)
	endif

return


/**
* Processa os arquivos do tipo Stock Adjustment
**/
static function processStock(cFilePath)

	local cFile := oFolder:getProcessingFile(cFilePath)

	if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		lError := !(u_DisImpInv(cFile,APP_DLX))
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AGE
		lError := !(u_AgeImpInv(cFile,APP_DLX))
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AGL
		lError := !(u_AglImpInv(cFile,APP_DLX))
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
		lError := !(u_Ag2ImpInv(cFile,APP_DLX))
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_DI2
		lError := !(u_Di2ImpInv(cFile,APP_DLX))
	else
		lError := !(u_DlxImpInv(cFile,APP_DLX))
	endif	

return


/**
* Processa os arquivos do tipo Customer/IP_030
**/
static function processCustomer(cFilePath)

	local cFile := oFolder:getProcessingFile(cFilePath)

	if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
		lError := u_Ag2Customer(cFile)
	endif

return

/**
* Coleta o CNPJ informado na interface
*/
static function getCnpj()

	local cCnpj := ""

	if cLayout == ASN_CONFIRMATION
		cCNPJ := AllTrim(oXml:_ASN_CONF:_BODY:_FILEHEADER:_SITE_CNPJ:TEXT)
	elseif cLayout == INVOICE_REQUEST
		cCNPJ := Alltrim(oXml:_INV_REQ:_BODY:_FILEHEADER:_SITE_CNPJ:TEXT)
	elseif cLayout == ITEM_MAINTENANCE
		cCNPJ := AllTrim(oXml:_ITEM_MAINT:_BODY:_FILEHEADER:_SITE_CNPJ:TEXT)
	elseif cLayout == STOCK_ADJUSTMENT
		cCNPJ := AllTrim(oXml:_STK_ADJ:_BODY:_FILEHEADER:_SITE_CNPJ:TEXT)
	elseif cLayout == CUSTOMER_IP030
		cCNPJ := AllTrim(oXml:_CUST_IP030:_BODY:_FILEHEADER:_SITE_CNPJ:TEXT)
	endif

return cCnpj


/**
* Coleta a interface
*/
static function getInterface()

	local cInterface := ""

	if cLayout == ASN_CONFIRMATION
		cInterface := "ASN Confirmation"
	elseif cLayout == INVOICE_REQUEST
		cInterface := "Invoice Request"
	elseif cLayout == ITEM_MAINTENANCE
		cInterface := "Item Maintenance"
	elseif cLayout == STOCK_ADJUSTMENT
		cInterface := "Stock Adjustment"
	elseif cLayout == CUSTOMER_IP030
		cInterface := "Customer IP 030"
	endif

return cInterface

/**
* Loga na empresa/filial
**/
static function setCompany(cEmpPar, cFilPar)

	local lLogado := .T.

	oEnv:setCompany(cEmpPar)
	oEnv:setBranch(cFilPar)
	oEnv:load()	

	if !(Type("cEmpAnt") == "C")
		lLogado := .F.
	endIf

return lLogado


/**
* Loga erro 
**/
static function logError(cEmpPar, cFilPar, cFilePath, nTipoLog)	

	local cMsgLog := ""

	setCompany(cEmpPar, cFilPar)	
	oFolder:startProcess(cFilePath)
	oLog:start(APP_DLX,DHL_IMPORTACAO,cFilePath)

	if nTipoLog == CNPJ_BRANCO	
		cMsgLog := "Arquivo com CNPJ em branco."
		oLog:fail(getInterface(),cMsgLog)	
	elseIf nTipoLog == CNPJ_INEXISTENTE
		cMsgLog := "Arquivo com CNPJ inexistente no cadastro de empresas."
		oLog:fail(getInterface(),cMsgLog)
	elseIf nTipoLog == FALHA_LOGAR_EMP
		cMsgLog := "Falha ao carregar Empresa/Filial: "+cEmpPar+"/"+cFilPar
		oLog:fail(getInterface(), cMsgLog )
	elseIf nTipoLog == ERROR_PARSE
		cMsgLog := "Falha no parser do arquivo " + cFilePath
		oLog:fail(getInterface(),cMsgLog)
	endIf

	FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "DHLDlx - LOG de ERRO", 0, 0, {})

	oFolder:setError(cFilePath)
	lError := .T.

return

/**
* Carrega as Empresas da DHL
*/
static function loadCompanies()

	local aCompanies := {}
		
	OpenSm0()

	SM0->(dbGoTop())
	while SM0->(!eof())
		if SM0->M0_CODIGO != "99" 
			if SM0->(!deleted())
				aAdd(aCompanies, {SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CGC})
			endif
		endif
		SM0->(dbSkip())
	endDo

return aCompanies

/**
* Verifica se o CNPJ pertence ás filiais DHL
**/
static function isCNPJInSysCompany(aCompanies, cCNPJFile)

	local lIsCNPJInSysCompany 	:= .F.
	local nPos					:= 0

	nPos := aScan(aCompanies, {|x| x[3] == cCNPJFile})

	if nPos > 0
		lIsCNPJInSysCompany := .T.
	endIf

return lIsCNPJInSysCompany

/**
* redimensiona o array
**/
static function setCnpjToFiles(aFiles)
	
	local cFilePath := "" 
	local nI		:= 0
	
	for nI := 1 to len(aFiles)
		
		cFilePath  := aFiles[nI]
		if !parserFile(@cFilePath)			
			aFiles[nI] := {aFiles[nI], ARQUIVO_INVALIDO}
			logError(cEmpDefault, cFilDefault, cFilePath, ERROR_PARSE)	
			loop
		endIf
		
		cLayout    := defineKind(@cFilePath)
		aFiles[nI] := {aFiles[nI], getCnpj()}			
		
	next nI
	
return


/**
* Ordena os arquivos de acordo com o CNPJ
**/
static function orderFilesByCNPJ(aFiles)

	aSort(aFiles, , , {|x, y| x[2] < y[2]})
	
return

/**
* Obtém a empresa e filial de acordo com o CNPJ
**/
static function getEmpFil(cCNPJFile, aCompanies, cEmp, cFil)

	local nPos := 0

	nPos := aScan(aCompanies, {|x| x[3] == cCNPJFile})

	if nPos > 0
		cEmp := aCompanies[nPos][COMPANY]
		cFil := aCompanies[nPos][BRANCH]
	endIf

return
