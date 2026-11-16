#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"

#define P2P63 "P2P63_"


#define COMPANY 1
#define BRANCH  2
#define CNPJ    3

/*/{Protheus.doc} DHLSupply
Rotina responsável pelo gerenciamento das interfaces do SupplyMe

@author Thiago Meschiatti
@since 12/05/2016
@version 1.0
/*/
User Function DHLSupply()

	local cDirectory 	:= ""
	local oConnection 	:= Connection():newConnection(CCONN, CSERVERADDR, NPORT)

	private oSql       := ipSqlObject():newIpSqlObject()
	private oFolder    := DHLDirectoryManager():newDHLDirectoryManager("")
	private oLog	   := DHLLogManager():newDHLLogManager()
	private oEnv 	   := IpEnvironmentObject():newIpEnvironmentObject()
	private oUtils     := IpUtilsObject():newIpUtilsObject()
	private aCompanies := loadCompanies()
	private cEmpDefault := aCompanies[1][COMPANY]
	private cFilDefault := aCompanies[1][BRANCH]
	private cLayout    := ""
	private oXml       := nil

	private aFiles     := {}
	private lError     := .F.

	cDirectory := oConnection:getDirectory(APP_SUPPLYME)

	if oEnv:hasMainWindow()
		if MsgBox("Confirma importação das interfaces do Supply Me ?", "Atenção", "YESNO")
			readFolder(cDirectory)
			if len(aFiles) > 0	
				FWMsgRun(, {|| processFiles()},,"Importando interfaces do Supply Me ...")
				MsgBox("Processamento concluído!", "Aviso", "INFO")
			else
				MsgInfo("Não existem arquivos para serem importados.",funName())
			endIf			
		endIf
	else		
		readFolder(cDirectory)

		if len(aFiles) > 0	
			setCompFirstTime()					
			processFiles()
			oEnv:close()
		endIf

	endIf

	DelClassIntf()

return

/**
* Ler o diretório de arquivos do WMS Supply Me
**/
static function readFolder(cFolder)

	oFolder:setDirectory(cFolder)
	aFiles := oFolder:getFiles()

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "DHLSupply - Achou " + Str(Len(aFiles)) + " arquivos." + CRLF, 0, 0, {})

return


/**
* Processa os arquivo coletados
**/
static function processFiles()

	local nFileNumber := 1
	local cFilePath   := ""

	for nFileNumber := 1 to Len(aFiles)

		cFilePath := aFiles[nFileNumber]
		cLayout   := defineKind(@cFilePath)

		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "DHLSupply - Inicio processamento do Arquivo: " +  cFilePath + " Layout: " + cLayout + CRLF, 0, 0, {})

		parserFile(@cFilePath)

		oFolder:startProcess(cFilePath)

		if !(lError)
			begin transaction
				if cLayout == P2P63
					processP2P63(@cFilePath)
				endif
			end transaction
		endif

		if lError
			FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "DHLSupply - Arquivo: " +  cFilePath + " Layout: " + cLayout + " com erro." + CRLF, 0, 0, {})
			oFolder:setError(cFilePath)
		else
			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "DHLSupply - Arquivo: " +  cFilePath + " Layout: " + cLayout + " processado." + CRLF, 0, 0, {})
			oFolder:setProcessed(cFilePath)
		endif

		lError := .F.

	next

return


/**
* Faz o parser do xml
**/
static function parserFile(cFilePath)

	local cError    := ""
	local cWarning  := ""

	oXml := XmlParserFile(cFilePath,"_",@cError,@cWarning)

	if !(Empty(cError)) .or. !(Empty(cWarning))
		oLog:start(APP_SUPPLYME,DHL_IMPORTACAO,cFilePath)
		oLog:fail("Arquivo inválido","Falha no parser do arquivo " + cFilePath)

		oFolder:setError(cFilePath)
		lError := .T.

		FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "DHLSupply - Falha no parser do arquivo " + cFilePath + CRLF, 0, 0, {})
	endif

return


/**
* Define o tipo do layout
**/
static function defineKind(cFilePath)

	local cKind := ""

	cKind := Substr(Right(cFilePath,Len(cFilePath) - Rat("\",cFilePath)),1,6)

return Upper(AllTrim(cKind))


/**
* Processa os arquivos do tipo P2P63
**/
static function processP2P63(cFilePath)

	if setCompany(cFilePath)
		lError := !(u_ImpPedCom(cFilePath))
	endif

returN


/**
* Carrega a Empresa/Filial da DHL
*/
static function setCompany(cFilePath)

	local lOk 		:= .T.
	local nScan		:= 0
	local cCompany	:= ""
	local cBranch	:= ""
	local cCnpj		:= getCnpj()

	if Empty(cCnpj)
		oLog:start(APP_SUPPLYME,DHL_IMPORTACAO,cFilePath)
		oLog:fail(getInterface(),"CNPJ em Branco")

		FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "DHLSupply - CNPJ em Branco", 0, 0, {})

		oFolder:setError(cFilePath)
		lError := .T.

		return .F.
	endIf

	nScan := aScan(aCompanies, {|x| x[CNPJ] == cCnpj})

	if (nScan == 0)
		oLog:start(APP_SUPPLYME,DHL_IMPORTACAO,cFilePath)
		oLog:fail(getInterface(),"CNPJ não encontrado: "+cCnpj)

		FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "DHLSuplly - CNPJ não encontrado: "+cCnpj + CRLF, 0, 0, {})

		oFolder:setError(cFilePath)
		lError := .T.

		return .F.
	endIf

	cCompany := aCompanies[nScan][COMPANY]
	cBranch  := aCompanies[nScan][BRANCH]

	if !(oEnv:hasMainWindow())
		oEnv:setCompany(cCompany)
		oEnv:setBranch(cBranch)
		oEnv:load()

		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "DHLSupply - Carregou a empresa " + cEmpAnt + "/" + cFilAnt + CRLF, 0, 0, {})

		lOk := (Type("cEmpAnt") == "C" .and. cEmpAnt+cFilAnt == cCompany+cBranch)
	endif

	if !(lOk)
		oLog:start(APP_SUPPLYME,DHL_IMPORTACAO,cFilePath)
		oLog:fail(getInterface(),"Falha ao carregar Empresa/Filial: "+cCompany+"/"+cBranch)

		FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "DHLSupply - Falha ao carregar Empresa/Filial: "+cCompany+"/"+cBranch + CRLF, 0, 0, {})

		oFolder:setError(cFilePath)
		lError := .T.

		return .F.
	else
		dbSelectArea("SX6")
	endIf

return lOk


/**
* Coleta o CNPJ informado na interface
*/
static function getCnpj()

	local cCnpj := ""

	if cLayout == P2P63
		cCNPJ := AllTrim(oXml:_P2P63:_BODY:_FILEHEADER:_SITE_CNPJ:TEXT)
	endif

return cCnpj


/**
* Coleta a interface
*/
static function getInterface()

	local cInterface := ""

	if cLayout == P2P63
		cInterface := "P2P63 - Pedido de Compra"
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
* Loga na empresa/filial pela primeira vez. Necessário para abrir as tabelas
**/
static function setCompFirstTime()

	if type("cFilAnt") == "U"
		cEmpDefault := aCompanies[1][COMPANY]
		cFilDefault := aCompanies[1][BRANCH]
		oEnv:setCompany(cEmpDefault)
		oEnv:setBranch(cFilDefault)
		oEnv:load()
	endIf

return


