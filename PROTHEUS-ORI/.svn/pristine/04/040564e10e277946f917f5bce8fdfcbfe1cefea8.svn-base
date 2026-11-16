#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"

#define SAP_IP040 	 "SAPIP040"
#define SAP_IP150	 "SAPIP150"
#define SAP_IP210	 "SAPIP210"

#define COMPANY 1
#define BRANCH  2
#define CNPJ    3

#define CNPJ_BRANCO 		1
#define CNPJ_INEXISTENTE 	2
#define FALHA_LOGAR_EMP     3
#define ERROR_PARSE			4


/*/{Protheus.doc} DHLSAP
Rotina responsável pelo gerenciamento e processamento das interfaces de integração com o sistema SAP.

@author Diogo Mesquita
@since 12/05/2017
@version 1.0
/*/
User Function DHLSAP()

	local cDirectory 	:= ""
	local oConnection 	:= Connection():newConnection(CCONN, CSERVERADDR, NPORT)

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

	cDirectory := oConnection:getDirectory(APP_SAP)

	if oEnv:hasMainWindow()
		if MsgBox("Confirma importação das interfaces do SAP ?", "Atenção", "YESNO")
			aFiles := readFolder(cDirectory)
			if len(aFiles) > 0
				setCnpjToFiles(aFiles)				
				orderFilesByCNPJ(aFiles)				
				FWMsgRun(, {|| processFiles()},,"Importando interfaces do SAP ...")	
				MsgBox("Processamento concluído!", "Aviso", "INFO")
			else
				MsgInfo("Não existem arquivos para serem importados.",funName())
			endIf
		endIf
	else
		aFiles  := readFolder(cDirectory)

		if len(aFiles) > 0			
			setCnpjToFiles(aFiles)	
			orderFilesByCNPJ(aFiles)				
			processFiles()	
			oEnv:close()
		endIf
		
	endIf

	DelClassIntf()

return

/**
* Ler o diretório de arquivos do SAP
**/
static function readFolder(cDirectory)

	local cFolder := cDirectory

	oFolder:setDirectory(cFolder)
	aFiles := oFolder:getFiles()

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "DHLSAP - Achou " + Str(Len(aFiles)) + " arquivos." + CRLF, 0, 0, {})

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
				if cLayout == SAP_IP040
					SAPIP040(@cFilePath)
				elseIf cLayout == SAP_IP150
					SAPIP150(@cFilePath)
				elseIf cLayout == SAP_IP210
					SAPIP210(@cFilePath)		
				endif
			end transaction
		endif

		if lError
			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "DHLSAP - Arquivo: " +  cFilePath + " Layout: " + cLayout + " com erro." + CRLF, 0, 0, {})
			oFolder:setError(cFilePath)
		else
			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "DHLSAP - Arquivo: " +  cFilePath + " Layout: " + cLayout + " processado." + CRLF, 0, 0, {})
			oFolder:setProcessed(cFilePath)
		endif

		lError := .F.
		DelClassIntf()
	next

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
* Processa os arquivos do tipo SAP_IP210
**/
static function SAPIP210(cFilePath)	

	if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
		lError := u_SAPIP210(cFilePath)
	endif

return

/**
* Processa os arquivos do tipo SAP_IP150
**/
static function SAPIP150(cFilePath)

	if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
		lError := u_SAPIP150(cFilePath)
	endif	

return

/**
* Processa os arquivos do tipo SAP_IP040
**/
static function SAPIP040(cFilePath)	

	if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
		lError := u_SAPIP040(cFilePath)
	endif	

return

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
* Coleta o CNPJ informado na interface
*/
static function getCnpj()

	local cCnpj := ""

	if cLayout == SAP_IP040
		cCNPJ := AllTrim(oXml:_IP_040:_BODY:_FILEHEADER:_SITE_CNPJ:TEXT)
	elseIf cLayout == SAP_IP150
		cCNPJ := AllTrim(oXml:_SAPIP150:_BODY:_FILEHEADER:_SITE_CNPJ:TEXT)
	elseIf cLayout == SAP_IP210
		cCNPJ := AllTrim(oXml:_IP_210:_BODY:_FILEHEADER:_SITE_CNPJ:TEXT)
	endif

return cCnpj


/**
* Coleta a interface
*/
static function getInterface()

	local cInterface := ""

	if cLayout == SAP_IP040
		cInterface := "SAP IP 040"
	elseIf cLayout == SAP_IP150
		cInterface := "SAP IP 150"
	endif

return cInterface


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
		DelClassIntf()
	next nI

return

/**
* Loga erro 
**/
static function logError(cEmpPar, cFilPar, cFilePath, nTipoLog)	

	local cMsgLog := ""

	setCompany(cEmpPar, cFilPar)	
	oFolder:startProcess(cFilePath)
	oLog:start(APP_SAP,DHL_IMPORTACAO,cFilePath)

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

	FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "DHLSAP - LOG de ERRO", 0, 0, {})

	oFolder:setError(cFilePath)
	lError := .T.

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


