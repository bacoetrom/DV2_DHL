#include "protheus.ch"	
#include "tbiconn.ch"	
#include "rwmake.ch"	

#define SAVE_COMPANY	1
#define SAVE_BRANCH		2
#define SAVE_APP		3
 
 
/*/{Protheus.doc} IpEnvironmentObject
 
Objeto para manipulação do Ambiente Protheus

@type class	
@author Victor Hugo
@since 18/01/2014
/*/
class IpEnvironmentObject from IpAdvplObject	
	
	data cCompany
	data cBranch
	data cNameCompany
	data cNameBranch
	data cUserName
	data cUserPassword
	data cTables
	data cModule
	data lCreateMainWindow
	data lPreparedEnvironment
	data aSave
	
	method newIpEnvironmentObject() constructor	
	
	method getCompany()
	method setCompany()
	method getBranch()
	method setBranch()
	method getNameCompany()
	method getNameBranch()
	method getUserName()
	method setUserName()
	method getUserPassword()
	method setUserPassword()
	method getTables()
	method setTables()
	method getModule()
	method setModule()
	method isCreateMainWindow()
	method setCreateMainWindow()
	
	method load()
	method close()
	method getCompanies()
	method hasMainWindow()
	method save()
	method restore()
	
endClass


/*/{Protheus.doc} newIpEnvironmentObject

Construtor

@type method
@author Victor Hugo
@since 18/01/2014

@param cCompany, String, Código da Empresa
@param cBranch, String, Código da Filial
@param cUsrName, String, Login do Usuário (Opcional)
@param cUserPassword, String, Senha do Usuário (Opcional)
@param cTabelas, String, Tabelas a serem abertas quando o ambiente
/*/
method newIpEnvironmentObject(cCompany, cBranch, cUsrName, cUserPassword, cTables, cModule, lCreateMainWindow) class IpEnvironmentObject	
	
	default cCompany 			:= if(Type("cEmpAnt") == "C", cEmpAnt, "")
	default cBranch 			:= if(Type("cFilAnt") == "C", cFilAnt, "")
	default cUsrName 			:= if(Type("cUserName") == "C", cUserName, "Administrador") 
	default cUserPassword 		:= ""
	default cTables				:= ""
	default cModule				:= "SIGAFAT"
	default lCreateMainWindow	:= .F.
	
	::newIpAdvplObject()
	
	::setCompany(cCompany)
	::setBranch(cBranch)
	::setUserName(cUsrName)
	::setUserPassword(cUserPassword)
	::setTables(cTables)
	::setModule(cModule)
	::setCreateMainWindow(lCreateMainWindow)
	::lPreparedEnvironment := .F.
	::aSave := {}
	
	::save()
							
return


/*/{Protheus.doc} getCompany

Coleta o Código da Empresa
	
@type method	
@author Victor Hugo
@since 18/01/2014

@return String Código da Empresa
/*/
method getCompany() class IpEnvironmentObject
return ::cCompany


/*/{Protheus.doc} setCompany

Define o Código da Empresa

@type method	
@author Victor Hugo
@since 18/01/2014

@param cCompany, String, Código da Empresa
/*/
method setCompany(cCompany) class IpEnvironmentObject
	::cCompany := cCompany
	setNames(@self)
return	


/*/{Protheus.doc} getBranch

Coleta o Código da Filial

@type method	
@author Victor Hugo
@since 18/01/2014

@return String Código da Filial
/*/
method getBranch() class IpEnvironmentObject
return ::cBranch


/*/{Protheus.doc} setBranch

Define o Código da Filial

@type method	
@author Victor Hugo
@since 18/01/2014

@param cBranch, String, Código da Filial
/*/
method setBranch(cBranch) class IpEnvironmentObject
	::cBranch := cBranch
	setNames(@self)
return

/**
 * Atualiza os Nomes da Empresa/Filial
 */
static function setNames(oSelf)
	
	local cCompany := oSelf:getCompany()
	local cBranch  := oSelf:getBranch()
	local aAreaSM0 := {}
	
	if (Empty(cCompany) .or. Empty(cBranch) .or. Select("SM0") <= 0)
		return
	endIf
	
	aAreaSM0 := SM0->(GetArea())
	
	if SM0->(dbSeek(cCompany+cBranch))
		oSelf:cNameCompany := SM0->M0_NOME
		oSelf:cNameBranch  := SM0->M0_FILIAL
	endIf
	
	RestArea(aAreaSM0)
	
return


/*/{Protheus.doc} getNameCompany

Coleta o Nome da Empresa

@type method	
@author Victor Hugo
@since 08/07/2014

@return String Nome da Empresa
/*/
method getNameCompany() class IpEnvironmentObject
return ::cNameCompany


/*/{Protheus.doc} getNameBranch

Coleta o Nome da Filial

@type method	
@author Victor Hugo
@since 08/07/2014

@return String Nome da Filial
/*/
method getNameBranch() class IpEnvironmentObject
return ::cNameBranch


/*/{Protheus.doc} getUserName

Coleta o Código do Usuário

@type method	
@author Victor Hugo
@since 18/01/2014

@return String Código do Usuário
/*/
method getUserName() class IpEnvironmentObject
return ::cUserName


/*/{Protheus.doc} setUserName

Define o Código do Usuário

@type method	
@author Victor Hugo
@since 18/01/2014

@param cUserName, String, Código do Usuário
/*/
method setUserName(cUserName) class IpEnvironmentObject
	::cUserName := cUserName
return


/*/{Protheus.doc} getUserPassword

Coleta a Senha do Usuário

@type method	
@author Victor Hugo
@since 18/01/2014

@return String Senha do Usuário
/*/
method getUserPassword() class IpEnvironmentObject
return ::cUserPassword


/*/{Protheus.doc} setUserPassword

Define a Senha do Usuário

@type method	
@author Victor Hugo
@since 18/01/2014

@param cUserPassword, String, Senha do Usuário
/*/
method setUserPassword(cUserPassword) class IpEnvironmentObject
	::cUserPassword := cUserPassword
return


/*/{Protheus.doc} getTables

Coleta as Tabelas para abrir quando o ambiente for inicializado. Ex.: "SA1,SB1,SC5,SC6"

@type method	
@author Victor Hugo
@since 18/01/2014

@return String Tabelas para abrir quando o ambiente for inicializado
/*/
method getTables() class IpEnvironmentObject
return ::cTables


/*/{Protheus.doc} setTables

Define as Tabelas para abrir quando o ambiente for inicializado. Ex.: "SA1,SB1,SC5,SC6"

@type method	
@author Victor Hugo
@since 18/01/2014

@param cTables, String, Tabelas para abrir quando o ambiente for inicializado
/*/
method setTables(cTables) class IpEnvironmentObject
	::cTables := cTables
return


/*/{Protheus.doc} getModule

Coleta o Módulo para inicialização do ambiente. Ex.: "FAT

@type method	
@author Victor Hugo
@since 18/01/2014

@return String Módulo para inicialização do ambiente
/*/
method getModule() class IpEnvironmentObject
return ::cModule


/*/{Protheus.doc} setModule

Define o Módulo para inicialização do ambiente. Ex.: "FAT

@type method	
@author Victor Hugo
@since 18/01/2014

@param cModule, String, Módulo para inicialização do ambiente
/*/
method setModule(cModule) class IpEnvironmentObject
	::cModule := cModule
return


/*/{Protheus.doc} isCreateMainWindow

Indica se deve criar a Janela Principal (oMainWnd) do Protheus

@type method	
@author Victor Hugo
@since 18/01/2014

@return Logico Indica se deve criar a Janela Principal (oMainWnd) do Protheus
/*/
method isCreateMainWindow() class IpEnvironmentObject
return ::lCreateMainWindow


/*/{Protheus.doc} setCreateMainWindow

Indica se deve criar a Janela Principal (oMainWnd) do Protheus

@type method	
@author Victor Hugo
@since 18/01/2014

@param lCreateMainWindow, Logico, Indica se deve criar a Janela Principal (oMainWnd) do Protheus
/*/
method setCreateMainWindow(lCreateMainWindow) class IpEnvironmentObject
	::lCreateMainWindow := lCreateMainWindow
return


/*/{Protheus.doc} load

Carrega o ambiente Protheus

@type method	
@author Victor Hugo
@since 18/01/2014

@param cFunName, String, Função a ser chamada na inicialização da MainWindow (opcional)

@return Logico Indica se foi possivel carregar o ambiente
/*/
method load(cFunName) class IpEnvironmentObject
	
	local lOk	 		:= .F. 
	default cFunName	:= "MsgBox('It works !! =D', 'IpEnvironmentObject', 'INFO')"
	
	if (lOk := loadEnvironment(@self))
		if ::isCreateMainWindow()
			lOk := createMainWindow(@self, cFunName)
		endIf	
	endIf
	
return lOk

/**
 * Carrega o ambiente Protheus
 */
static function loadEnvironment(oEnv)
	
	local lOk				:= .F.
	local cCompany			:= oEnv:getCompany()
	local cBranch			:= oEnv:getBranch()
	local cUserName			:= oEnv:getUserName()
	local cPassword			:= oEnv:getUserPassword()
	local cTables			:= oEnv:getTables()
	local cModule			:= Right(oEnv:getModule(), 3)	
	local lHasPublicVars	:= (Type("cEmpAnt") == "C")
	
	if lHasPublicVars .and. (cCompany+cBranch == cEmpAnt+cFilAnt)
		return .F.
	endIf														
	
	if (lHasPublicVars .or. oEnv:hasMainWindow())
		RpcClearEnv()		               
		RpcSetType(3) //Necessário manter o SetType 3 para manter o conteúdo das variáveis em memória
		RpcSetEnv(cCompany, cBranch, nil, nil ,cModule)
		RpcSetType(1) //Agora é necessário SetType 1 devido validações padrão na execução de ExecAuto's
	else
		if (Empty(cUserName) .or. Empty(cPassword))
			PREPARE ENVIRONMENT EMPRESA cCompany FILIAL cBranch TABLES cTables MODULO cModule
		else
			PREPARE ENVIRONMENT EMPRESA cCompany FILIAL cBranch USER cUserName PASSWORD cPassword TABLES cTables MODULO cModule
		endIf	
		oEnv:lPreparedEnvironment := .T.															 			
	endIf
		
	lOk 	:= .T.
	cEmpAnt := cCompany
	cFilAnt	:= cBranch
		
return lOk

/**
 * Criação da Janela Principal do Protheus
 */
static function createMainWindow(oEnv, cFunName)
	
	local cModName		:= oEnv:getModule()	
	local bWindowInit	:= {|| __cInternet := nil, __Execute(cFunName, "xxxxxxxxxxxxxxxxxxxx", cFunName, cModName, cModName, 1, .T.)}		
	public oMainWnd		:= nil
	public __cInternet	:= nil	
	
	if oEnv:hasMainWindow() 
		return .F.
	endIf
	
	createPublicVars(@cModName)
	
	DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE "Teste"
	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT (Eval(bWindowInit) , oMainWnd:end())
	
return .T.

/**
 * Cria as variáveis públicas
 */
static function createPublicVars(cModName)
	
	InitPublic()
	SetsDefault()			
	setModulo(cModName)
	
	lMsHelpAuto := .F.
	lMsFinalAuto:= .F.
	
return

/**
 * Setar o módulo em execução.
 * Função obtida no blog http://naldodjblogs.blogspot.com/
 */
static function setModulo(cModName)
	
	local cMod			:= ""
	local aRetModName	:= RetModName( .T. )	
	local cSvcModulo	:= nil
	local nSvnModulo	:= nil
	
	IF ( Type("nModulo") == "U" )
		_SetOwnerPrvt( "nModulo" , 0 )
	Else
		nSvnModulo := nModulo
	EndIF
	
	cModName := Upper( AllTrim( cModName ) )
	IF ( nModulo <> aScan( aRetModName , { |x| Upper( AllTrim( x[2] ) ) == cModName } ) )
		nModulo := aScan( aRetModName , { |x| Upper( AllTrim( x[2] ) ) == cModName } )
		IF ( nModulo == 0 )
			cModName	:= "SIGAFAT"
			nModulo		:= aScan( aRetModName , { |x| Upper( AllTrim( x[2] ) ) == cModName } )
		EndIF
	EndIF
	
	IF ( Type("cModulo") == "U" )
		_SetOwnerPrvt( "cModulo" , "" )
	Else
		cSvcModulo := cModulo
	EndIF
	
	cMod := SubStr( cModName , 5 )
	IF ( cModulo <> cMod )
		cModulo := cMod
	EndIF

return


/*/{Protheus.doc} close

Encerra o ambiente Protheus

@type method	
@author Victor Hugo
@since 18/01/2014
/*/
method close() class IpEnvironmentObject
	
	if ::lPreparedEnvironment
		RESET ENVIRONMENT
	endIf	
	
return


/*/{Protheus.doc} getCompanies

Exibe dialogo para seleção de Empresas/Filiais

@type method	
@author Victor Hugo
@since 18/01/2014

@param cTitle, String, Título do Diálogo (opcional)
@param lSelectOne, Logico, Indica se deve permitir a seleção de apenas uma Empresa/Filial (por padrão assume .F.)
@param lJustBranches, Logico, Indica se deve exibir apenas as filiais da empresa atual (por padrão assume .F.)
@param lJustCompanies, Logico, Indica se deve exibir apenas as empresas existentes no arquivo sigamat.emp (por padrão assume .F.)

@return Array Empresas/Filiais selecionadas. Estrutura do array: aCompanies[nI,1] = Empresa, aCompanies[nI,2] = Filial 
/*/
method getCompanies(cTitle, lSelectOne, lJustBranches, lJustCompanies) class IpEnvironmentObject
	
	local aRet				:= {}
	local aCompanies 		:= {}
	local oDlg				:= nil
	local oGrid				:= nil
	default cTitle			:= "Selecione as Empresas/Filiais"
	default lSelectOne		:= .F.
	default lJustBranches	:= .F.
	default lJustCompanies	:= .F.
	
	aCompanies := readCompanies(lJustBranches, lJustCompanies)
	
	DEFINE MSDIALOG oDlg TITLE cTitle FROM 001,001 TO 250,485 PIXEL OF oMainWnd								
		
		createGrid(oDlg, @oGrid, aCompanies, lSelectOne)	
		
		if !lSelectOne
			@ 105,006 BUTTON "Marca todas" SIZE 35,12 ACTION {|| oGrid:markAll() } PIXEL OF oDlg
		endIf	
		
		@ 105,165 BUTTON "Ok" SIZE 35,12 ACTION {|| if(getSelectedCompanies(oGrid, @aRet), oDlg:end(), nil) } PIXEL OF oDlg
		@ 105,205 BUTTON "Cancelar" SIZE 35,12 ACTION {|| oDlg:end() } PIXEL OF oDlg
						
	ACTIVATE MSDIALOG oDlg CENTERED
	
return aRet

/**
 * Leitura das Empresas/Filiais
 */
static function readCompanies(lJustBranches, lJustCompanies)
	
	local aCompanies	:= {}
	local aAreaSM0 		:= SM0->(GetArea())
	
	SM0->(dbGoTop())
	while !SM0->(eof())
		
		if lJustBranches .and. SM0->(M0_CODIGO != cEmpAnt)
			SM0->(dbSkip())
			loop
		endIf
		
		aAdd(aCompanies, {SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->(Capital(AllTrim(M0_NOME))+" / "+Capital(AllTrim(M0_FILIAL))),SM0->M0_NOME})	
			
		SM0->(dbSkip())
	endDo
	
	RestArea(aAreaSM0)
	
	if lJustCompanies
		setJustCompanies(@aCompanies)
	endIf
	
return aCompanies

/**
 * Deixa apenas as Empresas no array de Empresas/Filiais
 */
static function setJustCompanies(aCompanies)
	
	local nI		:= 0
	local nScan		:= 0
	local cCompany	:= ""
	local cName		:= ""
	local aNewArray := {}
	
	for nI := 1 to Len(aCompanies)		
		cCompany := aCompanies[nI,1]
		cName	 := aCompanies[nI,4]	 
		nScan	 := aScan(aNewArray, {|x| x[1] == cCompany })		
		if (nScan == 0)
			aAdd(aNewArray, {cCompany,"*",cName,""})	
		endIf		
	next nI
	
	aCompanies := aClone(aNewArray)
	
return

/**
 * Criação do grid para seleção de Empresas/Filiais
 */
static function createGrid(oDlg, oGrid, aCompanies, lSelectOne)
	
	local nI		:= 0
	local nCol		:= 5
	local nRow		:= 5
	local nWidth	:= 240
	local nHeight	:= 100	
	local oCol		:= nil
	
	oGrid := IpGridObject():newIpGridObject(nCol, nRow, nWidth, nHeight, oDlg)
	
	oGrid:addMarkColumn()
	
	oCol := IpColumnObject():newIpColumnObject("company", "Empresa", "C", 10) 
	oGrid:addColumn(oCol)
	
	oCol := IpColumnObject():newIpColumnObject("branch", "Filial", "C", 10)
	oGrid:addColumn(oCol)
	
	oCol := IpColumnObject():newIpColumnObject("name", "Nome", "C", 40)
 	oGrid:addColumn(oCol)
	
	for nI := 1 to Len(aCompanies)
		oGrid:newLine()
		oGrid:setMarkedLine(.F.)
		oGrid:setValue("company", aCompanies[nI,1])
		oGrid:setValue("branch", aCompanies[nI,2])
		oGrid:setValue("name", aCompanies[nI,3])		
	next nI
	
	oGrid:setReadOnly(.T.)
	oGrid:setMarkOne(lSelectOne)
	oGrid:create()
	
return

/**
 * Coleta as Empresas/Filiais selecionadas
 */
static function getSelectedCompanies(oGrid, aRet)
	
	local lOk	:= .F. 
	local nI 	:= 0
	
	aRet := {}
	
	for nI := 1 to oGrid:length()
		if oGrid:isMarkedLine(nI)
			aAdd(aRet, {oGrid:getValue("company", nI), oGrid:getValue("branch", nI)})
			lOk := .T.
		endIf
	next nI
	
	if !lOk
		MsgBox("Selecione ao menos uma Empresa/Filial", "Atenção", "ALERT") 
	endIf
	
return lOk


/*/{Protheus.doc} hasMainWindow

Indica se a janela principal existe

@type method	
@author Victor Hugo
@since 18/01/2014

@return Logico Indica se a janela principal existe
/*/
method hasMainWindow() class IpEnvironmentObject
return (Type("oMainWnd") == "O") 


/*/{Protheus.doc} save

Salva o ambiente atual

@type method	
@author Victor Hugo
@since 20/01/2014
/*/
method save() class IpEnvironmentObject
	
	if ::hasMainWindow()
		::aSave := Array(3)
		::aSave[SAVE_COMPANY]	:= cEmpAnt
		::aSave[SAVE_BRANCH]	:= cFilAnt
		::aSave[SAVE_APP]		:= oApp
	endIf
	
return


/*/{Protheus.doc} restore

Restaura o ambiente anterior

@type method	
@author Victor Hugo
@since 20/01/2014
/*/
method restore() class IpEnvironmentObject
	
	local oEnv := nil
			
	if (Len(::aSave) == 0)
		return
	endIf
	
	oEnv := IpEnvironmentObject():newIpEnvironmentObject()
	oEnv:setCompany(::aSave[SAVE_COMPANY])
	oEnv:setBranch(::aSave[SAVE_BRANCH])
	if oEnv:load()
		public oApp := ::aSave[SAVE_APP]
	endIf	
	
return