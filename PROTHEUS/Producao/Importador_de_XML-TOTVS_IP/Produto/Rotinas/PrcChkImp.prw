#Include 'Protheus.ch'
#include 'topconn.ch'
#include 'TBICONN.ch'
#include "FileIO.ch"
#include "rwmake.ch"
#include 'Protheus.ch'
#include 'ApWebSrv.ch'

#define DATA_RPO 4
#define HORA_RPO 5
#define PRODUTO_IMPORTADOR 3
#define LFORCES3 .T. 

#define WS_FAULT_CODE 2
#define WS_FAULT_DESCRIPTION 3

#define IMPORTADOR_DE_XML_CODE		"0000009D65"
 
#define CSSBOTAO	"QPushButton { color: #024670; "+;
					"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
					"    border-top-width: 3px; "+;
					"    border-left-width: 3px; "+;
					"    border-right-width: 3px; "+;
					"    border-bottom-width: 3px }"+;
					"QPushButton:pressed {	color: #FFFFFF; "+;
					"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
					"    border-top-width: 3px; "+;
					"    border-left-width: 3px; "+;
					"    border-right-width: 3px; "+;
					"    border-bottom-width: 3px }"
					
/*/{Protheus.doc} PrcChkImp

Rotina utilizada para validação do importador de xml.
	
@author Diego de Angelo
@since 28/01/2016

/*/
User Function PrcChkImP()
	local oFont16B 	:= TFont():New("Verdana",,16,,.T.,,,,,.F.)
	local oLogo		:= LoadBitmap( GetResources(), "APLOGO" )
	local oFont		:= nil
	local bNo		:=	{ || oDlg:End() }
	local bOk		:=	{ || oDlg:End() }
	local aEmps		:= 	{}
	local lEmp		:= .F.    
   	local aTFolders := { "Rotinas", "Parametros","Pontos de Entrada"}
    local aButtons	:= {}
   	local oProcess	:= nil
   	private cRoot	:= ""
   	private oDlg	:= nil
   	private oGrdParam	:= nil
   	private oGrdPe	:= nil
   	private oGrdRotina	:= nil

   	if Type("cEmpAnt") == "U" .AND. Type("cFilAnt") == "U"
	   	lEmp	:= getEmpresas()
	 
	  	if !lEmp
	   		return
	   	endIf	
   	endIf
	
	
	Define MsDialog oDlg Title "Importador de XML" From 3,0 To 600,875 Pixel

	oDlg:lMaximized := .t.

	oFolder := TFolder():New( 75, 3, aTFolders,, oDlg,,,,.T., .T., 433, 190 )
	
	oProcess := MsNewProcess():New( { | lEnd | carregaTelas(oProcess) }, "Carregando", "Aguarde, carregando ...", .F. )
	oProcess:Activate()
	
	@ 700,145 BITMAP oBmpLogo RESNAME "APLOGO" OF oDlg SIZE 100,100 NOBORDER WHEN .F. PIXEL
    @ 45,100 SAY lblObservacao PROMPT "ASSISTENTE PARA VALIDAÇÃO DO IMPORTADOR DE XML / GESTOR DE XML - TOTVS IP" SIZE 250, 200 OF oDlg  FONT oFont16B COLORS 0, 16777215 PIXEL 

	oBmpLogo:lAutoSize := .T. 
	oBmpLogo:lStretch := .T. 
	oBmpLogo:Align := CONTROL_ALIGN_ALLCLIENT 
	
	aADD(aButtons,{ "CLIPS", {|| geraLog() }					,"Gerar Log" 					, "Gerar Log" } )
	aADD(aButtons,{ "CLIPS", {|| MsgBox(validaLicenca(),"Validação da licença","INFO") }		,"Validar Licenca" 				, "Validar Licenca" } )
	aADD(aButtons,{ "CLIPS", {|| MsgBox(validaWsGestor(),"Validação do WS Gestor XML","INFO") }	,"Validar WS Gestor" 			, "Validar WS Gestor" } )
	
	Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bNo,nil,aButtons,,,,,.F.,.F.,.F.,,,) Centered
	
return


/*
*	Função responsável pelo retorno das informações do RPO.
*/
static function verRotina()
	local nI		:= 0
	local aImp		:= retRotinas() 
   	local aRotinas	:= {}
   	local cRotina	:= ""
   	local aData		:= {}
   	local cData		:= ""
   	local cProduto	:= ""
   	
   	for nI := 1 to len(aImp)
   		cRotina	:= aImp[nI][1]
   		cProduto:= aImp[nI][2]
 		aData := GetAPOInfo(cRotina)
 		
 		if empty(aData)
 			cData	:= "Não compilado"	
 		else
 			cData	:= trataValor(aData[DATA_RPO]) + " - " + trataValor(aData[HORA_RPO]) 
 		endIf
 		
 		aData	:= {cRotina, cData, cProduto}
 		
 		aADD(aRotinas,aData)
 		
  	next nI

return aRotinas


/*
*	Função responsável pelo retorno das informações do RPO.
*/
static function verPEs()
	local nI		:= 0
	local aPE		:= retPEs() 
   	local aInfPE	:= {}
   	local aData		:= {}
   	local lExist	:= .T.
   	local cPe		:= ""
   	local cStatus	:= ""
   	local cTipo		:= ""
   	local cFrente	:= ""
   	
   	for nI := 1 to len(aPE)
   
   		cPe		:= aPE[nI][1]
   		cTipo	:= aPE[nI][2] 
   		cFrente	:= aPE[nI][3] 
   		aData := GetAPOInfo(cPe)
  		
  		if empty(aData)
  			cStatus	:= "Não compilado"
   		else
   			cStatus	:= trataValor(aData[DATA_RPO]) + " - " + trataValor(aData[HORA_RPO]) 
   		endIf
   		
   		aADD(aInfPE,{cPe, cTipo, cFrente, cStatus })
   			 		
  	next nI

return aInfPE


/*
*	Funcao responsavel pela exibicao da tela de rotinas.
*/
static function telaRotinas()
	
	local aRotinas	:= verRotina()
	
	oGrdRotina 	:= TcBrowse():New(000,000,432 , 178 ,,,,oFolder:aDialogs[1],,,,,,,,,,,,.f.,,.t.,,.f.,,,,)
	 
	oGrdRotina:AddColumn( TcColumn():New( "Rotina"         		,{ || aRotinas[oGrdRotina:nAt,01]}	, "@!"     	,,, "LEFT"   ,060,.f.,.f.,,,,.f.,) )
	oGrdRotina:AddColumn( TcColumn():New( "Data RPO"			,{ || aRotinas[oGrdRotina:nAt,02]}	, "@!"     	,,, "LEFT"	 ,080,.f.,.f.,,,,.f.,) )
	oGrdRotina:AddColumn( TcColumn():New( "Produto"				,{ || aRotinas[oGrdRotina:nAt,03]}	, "@!"     	,,, "LEFT"	 ,080,.f.,.f.,,,,.f.,) )
	oGrdRotina:SetArray(aRotinas)               
	
return


/*
*	Funcao responsavel pela exibicao da tela de pontos de entrada.
*/
static function telaPE()
	local aPE		:= verPEs()
	
	oGrdPe 	:= TcBrowse():New(000,000,432 , 178 ,,,,oFolder:aDialogs[3],,,,,,,,,,,,.f.,,.t.,,.f.,,,,)
	 
	oGrdPe:AddColumn( TcColumn():New( "Rotina"     				,{ || aPE[oGrdPe:nAt,01]}	, "@!"     	,,, "LEFT"   ,040,.f.,.f.,,,,.f.,) )
	oGrdPe:AddColumn( TcColumn():New( "Tipo"				    ,{ || aPE[oGrdPe:nAt,02]}	, "@!"     	,,, "LEFT"   ,040,.f.,.f.,,,,.f.,) )
	oGrdPe:AddColumn( TcColumn():New( "Produto"				    ,{ || aPE[oGrdPe:nAt,03]}	, "@!"     	,,, "LEFT"   ,040,.f.,.f.,,,,.f.,) )
	oGrdPe:AddColumn( TcColumn():New( "Data RPO"				,{ || aPE[oGrdPe:nAt,04]}	, "@!"     	,,, "LEFT"	 ,080,.f.,.f.,,,,.f.,) )
	
	oGrdPe:SetArray(aPE)               
	
return


/*
*	Funcao responsavel pela exibicao da tela de parametros.
*/
static function telaParametros()
	local aParametros	:= retParametros()
	
	oGrdParam		:= TcBrowse():New(000,000,432 , 178 ,,,,oFolder:aDialogs[2],,,,,,,,,,,,.f.,,.t.,,.f.,,,,)
	 
	oGrdParam:AddColumn( TcColumn():New( "Parametro"        ,{ || aParametros[oGrdParam:nAt,01]	 }	, "@!"     	,,, "LEFT"  ,050,.f.,.f.,,,,.f.,) )
	oGrdParam:AddColumn( TcColumn():New( "Descrição" 		,{ || aParametros[oGrdParam:nAt,02]	 }	, "@!"     	,,, "LEFT"  ,050,.f.,.f.,,,,.f.,) )
	oGrdParam:AddColumn( TcColumn():New( "Produto" 			,{ || aParametros[oGrdParam:nAt,03]	 }	, ""     	,,, "LEFT" 	,150,.f.,.f.,,,,.f.,) )
	oGrdParam:AddColumn( TcColumn():New( "Conteúdo"			,{ || aParametros[oGrdParam:nAt,04]	 }	, ""     	,,, "LEFT" 	,070,.f.,.f.,,,,.f.,) )								
	oGrdParam:SetArray(aParametros)               
	oGrdParam:lHScroll   := .T.
		
return


/*
*	Função responsável pela seleção da empresa.
*/
static function getEmpresas()
	local 	lEmp	:= .F.
	local   aRet      := {}
	local   aSalvAmb  := GetArea()
	local   aSalvSM0  := {}
	local   aVetor    := {}
	local   cVar      := ""
	local   lChk      := .F.
	local   lOk       := .F.
	local   lTeveMarc := .F.
	local   oNo       := LoadBitmap( GetResources(), "LBNO" )
	local   oOk       := LoadBitmap( GetResources(), "LBOK" )
	local   oDlg
	local   oButDMar, oButInv, oButMarc, oButOk, oButCanc
	local   aMarcadas := {}
	local oProcessEmpresa	:= nil
  	
  	__cUserId	:= ""
	
	private aVetor , oChkMar, oLbx, oSay
	
	if !MyOpenSm0(.T.)
		return lEmp
	endIf
	
	
	dbSelectArea( "SM0" )
	aSalvSM0 := SM0->( GetArea() )
	dbSetOrder( 1 )
	dbGoTop()
	
	while !SM0->( EOF() )
	
		if aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
			aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
		endIf
	
		SM0->(dbSkip())
	endDo
	
	restArea( aSalvSM0 )
	
	Define MSDialog  oDlg Title "" From 0, 0 To 280, 395 Pixel
	
	oDlg:cToolTip := "Tela Seleção de Empresa/Filial"
	
	oDlg:cTitle   := "Selecione a Empresa"
	
	@ 10,10 LISTBOX oLbx Var cVar FIELDS COLSIZES 5,10,20,10,20 HEADER "","Empresa","Descricao","Filial","Descricao" SIZE 178,095 OF oDlg PIXEL

	oLbx:SetArray(  aVetor )

	oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
							aVetor[oLbx:nAt, 2]+Space(10), ;
							aVetor[oLbx:nAt, 4]+Space(10), ;
							aVetor[oLbx:nAt, 3]+Space(10), ;
							aVetor[oLbx:nAt, 5]+Space(10)}}
	
	oLbx:BlDblClick := { || limpaSelecao(@aVetor,@oLbx), aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1]}
	oLbx:cToolTip   :=  oDlg:cTitle
	oLbx:lHScroll   := .T. // NoScroll
	
	@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), oDlg:End()  ) ;
	Message "Confirma a seleção e efetua" + CRLF + "o processamento" Of oDlg
	oButOk:SetCss( CSSBOTAO )
	
	@ 128, 157  Button oButCanc Prompt "Cancelar"   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ;
	Message "Cancela o processamento" + CRLF + "e abandona a aplicação" Of oDlg
	oButCanc:SetCss( CSSBOTAO )
	
	Activate MSDialog  oDlg Center
	
	RestArea( aSalvAmb )
	dbSelectArea( "SM0" )
	dbCloseArea()
	
	if len(aRet) > 0
		RpcClearEnv()
		RpcSetType( 3 )
		Processa( {|| rpcSetEnv(aRet[1][1],aRet[1][2]) },"Aguarde. Carregando empresa ..." )
	 	__cUserId	:= "0000000
   		cUserName	:= "administrador"
		lEmp	:= .T.
	else
		MsgBox("Nenhuma empresa selecionada.","Empresa","INFO")
	endIf

return  lEmp


/*
*	Função responsável pelo retorno das empresas selecionadas.
*/
static function RetSelecao( aRet, aVetor )
	Local  nI    := 0
	
	aRet := {}
	For nI := 1 To Len( aVetor )
		If aVetor[nI][1]
			aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
		EndIf
	Next nI
	
return NIL


/*
*	Função responsável pela verificação e abertura do sigamat como exclusivo.
*/
static function MyOpenSM0(lShared)

	Local lOpen := .F.
	Local nLoop := 0
	
	For nLoop := 1 To 20
		OpenSM0(, lShared)
	
		If !Empty( Select( "SM0" ) )
			lOpen := .T.
			dbSetIndex( "SIGAMAT.IND" )
			Exit
		EndIf
	
		Sleep( 500 )
	
	Next nLoop
	
	If !lOpen
		MsgStop( "Não foi possível a abertura da tabela " + ;
		IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
	EndIf

return lOpen


/*
*	Função responsável por desmarcar todos os itens.
*/
static function limpaSelecao(aVetor, oLbx)
	local nI	:= 0
	
	For nI := 1 To Len( aVetor )
		aVetor[nI][1]	:= .F.
	Next nI
	oLbx:refresh()
return


/*
*	Função responsável pelo retorno dos parâmetros do importador.
*/
static function retParametros()
	local aParametros 	:= {}
	local aRetParam		:= {}
	local nI			:= 0
	local cParam		:= ""
	local cProduto		:= ""
	
	aADD(aParametros,{"ZZ_CTEPROD","Importador"}) 
	aADD(aParametros,{"MV_RESTNFE","Importador"})
	
	aADD(aParametros,{"ZZ_UMFOR","Gestão XML"})
	aADD(aParametros,{"MV_ZZESPEC","Gestão XML"})
	aADD(aParametros,{"ZZ_CFOPBEN","Gestão XML"})
	aADD(aParametros,{"ZZ_CFOPDEV","Gestão XML"})
	aADD(aParametros,{"ZZ_INFLDIR","Gestão XML"})
	aADD(aParametros,{"ZZ_DTFIMEM","Gestão XML"})
	aADD(aParametros,{"ZZ_DTINIEM","Gestão XML"})	
	aADD(aParametros,{"ZZ_URLIMP","Gestão XML"})	
	aADD(aParametros,{"ZZ_XMLDIR","Gestão XML"})		
	
	for nI := 1 to len(aParametros)
		cParam	:= aParametros[nI][1]
		cProduto:= aParametros[nI][2]
		aADD(aRetParam, {cParam,retDescParam(cParam),cProduto, retContPar(cParam)})
	next nI
return aRetParam


/*
*	Função responsável pelo retorno das rotinas do importador.
*/
static function retRotinas()
	local aRotinas	:= {}
	
	aADD(aRotinas,{"TIMPNFE.prw"	,"Importador"})
	aADD(aRotinas,{"SCLOGGER.prw"	,"Importador"})
	aADD(aRotinas,{"IMPNFE.prw"		,"Importador"})
	aADD(aRotinas,{"PROCIMPXML.prw"	,"Importador"})
	
	aADD(aRotinas,{"GRVTXT.prw"		,"Gestor XML"})
	aADD(aRotinas,{"IPCOM001.prw"	,"Gestor XML"})
	aADD(aRotinas,{"IPCOM002.prw"	,"Gestor XML"})
	aADD(aRotinas,{"telaMVC.prw"	,"Gestor XML"})
	aADD(aRotinas,{"WSWSExportaXML.prw","Gestor XML"})
	aADD(aRotinas,{"zzgestor.prw"	,"Gestor XML"})
	
return aRotinas


/*
*	Função responsável pelo retorno das rotinas do importador.
*/
static function retPEs()
	local aPEs	:= {}
	
	aADD(aPEs,{"IPCTEPRODUTO.prw"	,"Personalizado","Importador"})
	aADD(aPEs,{"IPNFEPRODUTO.prw"	,"Personalizado","Importador"})
	aADD(aPEs,{"IPNFELOTE.prw"		,"Personalizado","Importador"})
	aADD(aPEs,{"IPNFEESP.prw"		,"Personalizado","Importador"})
	aADD(aPEs,{"IPNFECAB.prw"		,"Personalizado","Importador"})
	aADD(aPEs,{"IPNFEGRV.prw"		,"Personalizado","Importador"})
	aADD(aPEs,{"IPNFEVLDITEM.prw"	,"Personalizado","Importador"})
	aADD(aPEs,{"IPNFEITEM.prw"		,"Personalizado","Importador"})
	aADD(aPEs,{"IPNFEALTITEM.prw"	,"Personalizado","Importador"})
	aADD(aPEs,{"IPNFEFIM.prw"		,"Personalizado","Importador"})	
	aADD(aPEs,{"IPExtensao_PE.prw"	,"Personalizado","Importador"})
	aADD(aPEs,{"IPDESTNFE_PE.prw"	,"Personalizado","Importador"})

	// Julio Lisboa - FSW TOTVS IP Campinas - 28/09/2016
	aADD(aPEs,{"IPNFEVLXML_PE.prw"	,"Personalizado","Importador"})
	aADD(aPEs,{"IPCTEVLXML_PE.prw"	,"Personalizado","Importador"})
	aADD(aPEs,{"IPCPOCAB_PE.prw"	,"Personalizado","Importador"})
	aADD(aPEs,{"IPADDITE_PE.prw"	,"Personalizado","Importador"})
	aADD(aPEs,{"IPTudoOK_PE.prw"	,"Personalizado","Importador"})
	
	aADD(aPEs,{"IPNFETAGPROD.prw"	,"Personalizado","Gestor XML"})

	aADD(aPEs,{"MT140MNU.prw"		,"Padrão","Gestor XML"})
	aADD(aPEs,{"MTA140MNU.prw"		,"Padrão","Gestor XML"})
						
return aPEs


/*
*	Função responsável pelo retorno da descrição do parâmetro.
*/
static function retDescParam(cParam)
	local aArea	:= GetArea()
	local aSX1	:= SX1->(GetArea())
	local cDesc	:= ""
	
	cDesc	:= 	Alltrim(Posicione("SX6",1,xFilial("SX6")+cParam,"X6_DESCRIC")) + ;
				Alltrim(Posicione("SX6",1,xFilial("SX6")+cParam,"X6_DESC1"))   + ;
				Alltrim(Posicione("SX6",1,xFilial("SX6")+cParam,"X6_DESC2"))
	
	restArea(aSX1)
	restArea(aArea)
return cDesc


/*
*	Função responsável pela geração do arquivo.
*/
static function geraLog()
	local aRetDir	:= {}
   	local cFileName	:= "LOG_IMPXML_"+StrTran(Time(),":","")+"_"+dTos(dDataBase)+".csv"
   	local cFile		:= ""
   	local cString	:= ""
   	local cAux		:= retInfoEmp() + CRLF
   	local cLic		:= validaLicenca() + CRLF
   	local cWs		:= validaWsGestor()
	local oProcess	:= nil	
   	if selecaoDiretorio(@aRetDir)
   		cFile := alltrim(aRetDir[1]) + cFileName
   		cString	:= retTexto(oGrdPe) + CRLF + retTexto(oGrdParam) + CRLF + retTexto(oGrdRotina)
   		cString := cAux + cString + CRLF + cLic + CRLF + cWs
   		cAux	:= ""
   		
   		oProcess := MsNewProcess():New( { | lEnd | gravaArquivo(cFile, cString,oProcess) }, "Gerando...", "Gerando arquivo de log...", .F. )
		oProcess:Activate()

   	endIf
	
return


/*
*	Função responsável pela leitura e retorno das informações dos grids.
*/
static function retTexto(oGrid)
	local nLinhas	:= oGrid:nRowCount()
	local aLinhas	:= oGrid:aArray
	local aCabec	:= oGrid:aColumns
	local cDescCol	:= ""
	local cValor	:= ""
	local nI		:= 1
	local nJ		:= 1
	local cCabec	:= ""
	local cTab		:= ";"//chr(9)
	
	for nJ := 1 to len(aCabec)
		cDescCol	+= aCabec[nJ]:cHeading + cTab
	next nJ
	
	nJ	:= 1
	
	for nI:=1 to len(aLinhas)
		for nJ := 1 to len(aLinhas[nI])
			cValor		+= trataValor(aLinhas[nI][nJ]) + cTab
		next nJ
		cValor	+= CRLF
	next nI
	
return cDescCol + CRLF + cValor


/*
*	Função responsável pelo retorno das informações da empresa logada.
*/
static function retInfoEmp()
	local cAux	:= ""
	
	cAux := " --------------------"  + CRLF
	cAux += " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt  + CRLF
	cAux += " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
	cAux += " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
	cAux += " DataBase...........: " + DtoC( dDataBase )  + CRLF
	cAux += " Data / Hora Inicio.: " + DtoC( Date() )  + " / " + Time()  + CRLF
	cAux += " Environment........: " + GetEnvServer()  + CRLF
	cAux += " StartPath..........: " + GetSrvProfString( "StartPath", "" )  + CRLF
	cAux += " RootPath...........: " + GetSrvProfString( "RootPath" , "" )  + CRLF
	cAux += " Versao.............: " + GetVersao(.T.)  + CRLF
	cAux += " --------------------"  + CRLF

return cAux


/*
*	Função utilizada para carregar todas as telas
*/
static function carregaTelas(oProcess)

	oProcess:SetRegua1(2)
	oProcess:SetRegua2(3)
	
	oProcess:IncRegua1("Carregando rotinas...")
	telaRotinas()
	
	oProcess:IncRegua1("Carregando parâmetros...")
	telaParametros()
	
	oProcess:IncRegua2("Carregando pontos de entrada...")
	telaPE()
	
return


/*
*	Função responsável pela seleção do diretório para salvar o log.
*/
static function selecaoDiretorio(aRetDir)
	local aParamBox := {}
	
	aAdd(aParamBox,{6,"Diretório"			  ,Space(80),""	  ,"","",80,.T.,"",,GETF_LOCALHARD+GETF_RETDIRECTORY,.f.})	
return ParamBox(aParamBox,"Selecione o diretório...",@aRetDir)


/*
*	Função responsável pela gravação e criação do arquivo.
*/
static function gravaArquivo(cFile, cText, oProcess) 

	local nHandle 	:= 0                        
	local lWrite	:= .T.	                    
	
	oProcess:SetRegua1(2)
	oProcess:SetRegua2(1)
	
	if !File(cFile)
		oProcess:IncRegua1("Criando arquivo...")
		nHandle := FCreate(cFile)
	else
		nHandle := FOpen(cFile, FO_READWRITE)
		FSeek(nHandle, 0, 2)
	endIf
	
	if nHandle == -1
		lWrite := .F.
	else
		cText += CRLF
		if FWrite(nHandle, cText, Len(cText)) != Len(cText)
			lWrite := .F.
		endIf
	endIf
			
	FClose(nHandle)
    
	if !lWrite
		MsgBox("Falha na gravação do Arquivo "+AllTrim(cFile),"Arquivo de log","INFO")	
	else
		oProcess:IncRegua1("Gravando arquivo...")
		oProcess:IncRegua2("Arquivo criado com sucesso...")
		MsgBox("Arquivo gerado com sucesso em "+AllTrim(cFile),"Arquivo de log", "INFO")	
	endIf

return lWrite


/*
*	Função responsável pelo tratamento dos valores.
*/
static function trataValor(xValor)
	local cTipo	:= ValType(xValor)
	
	if cTipo == "L"
		if xValor 
			xValor	:= "T"
		else
			xValor	:= "F"
		endIf	
	elseif cTipo == "D"
		xValor	:= DtoC(xValor)
	elseif cTipo == "N"
		xValor	:= cValToChar(xValor)
	endIf

return xValor


/*
*	Função responsável pela validação da classe de licença.
*/
static function validaLicenca()
	
	Local oIPLicense                         := nil
	Local nSequenceArtifact                  := 0
	Local cCodeArtifact                      := IMPORTADOR_DE_XML_CODE
	Local cNameArtifact                      := ""
	Local lOnlyTestCompany                   := .F.
	Local lNoCheckLicenseInTestCompany       := .T.
	Local cMsg                               := ""
	Local cMsgError                          := ""
	Local lForceLicenseFile                  := .F.
	
	//Define os dados do Licenciamento internamente na classe IpLicense, buscando o licenciamento do cliente internamente ou em arquivo xml fornecido
	If ExistBlock("IPLicense",,LFORCES3)
		oIPLicense 	:= IPLicense():newIPLicense()
		oIPLicense:setLimitCheck(0)
		If oIPLicense:setInternalLicense( nSequenceArtifact , cCodeArtifact , cNameArtifact, lOnlyTestCompany, lNoCheckLicenseInTestCompany)
			If oIPLicense:checkLicense(@cMsgError,lForceLicenseFile)
				If !( oIPLicense:isAlreadyChecked() )
					cMsg := "Uso Autorizado para o Artefato '" + oIPLicense:getCodeArtifact() + " - " + oIPLicense:getNameArtifact() + "' - CNPJ: " + oIPLicense:getCNPJCompany()
				Endif
			Else
				cMsg := "Uso Não Autorizado para o Artefato '" + oIPLicense:getCodeArtifact() + " - " + oIPLicense:getNameArtifact() + "' - CNPJ: " + oIPLicense:getCNPJCompany() + " - Motivo: " + cMsgError
			Endif
		Else
			cMsg := "Não Localizado o Artefato a ser Licenciado."
		Endif
	Else
		cMsg := "Objeto de Licenciamento da TOTVS IP não encontrado."
	Endif
	
	MsgStop(cMsg,"TOTVS IP")
	u_IPLicenseView(oIPLicense)
	
return cMsg


/*
*	Função responsável pela validação do webservice do gestor
*/
static function validaWsGestor()
	
	local cWs			:= "WSWSExportaXML.prw"
	local oWs			:= nil
	local lResult		:= ""
	local cSvcError		:= ""
	local cSoapFCode	:= ""
	local cSoapFDescr	:= ""
	local cMsg			:= ""
	local cParamWs		:= superGetMV("ZZ_URLIMP",.F.,"ERRO")
	local aData			:= {}
	
	if cParamWs == "ERRO"
		aData := GetAPOInfo(cWs)
		if !empty(aData)
			oWs := WSIPServicos():New()
			
			lResult	:= oWs:TesteSoma(10,10)
			
			if lResult
				cMsg	:= "Webservice validado com sucesso"
			else
				cSvcError   := GetWSCError()  
	  			cSoapFCode  := GetWSCError(WS_FAULT_CODE) 
	  			cSoapFDescr := GetWSCError(WS_FAULT_DESCRIPTION)
		
				if !empty(cSoapFCode)
			    	cMsg	:= cSoapFCode + CRLF + cSoapFDescr
			  	else
			  		cMsg	:= cSvcError
			    endIf
			endIf
		else
			cMsg	:= "Falha na validação do webservice "+CRLF+" Client do Webservice não encontrado: " + cWs
		endif
	else
		cMsg	:= "Falha na validação do webservice "+CRLF+" Verifique o conteúdo do parâmetro ZZ_URLIMP."
	endIf

return cMsg


/*
** Retorna o conteúdo do paramentro
*/
Static Function retContPar(cParam)
	Local cRet := superGetMv(cParam,.F.,"Parâmetro não encontrado")

Return (cRet)
