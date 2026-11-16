#INCLUDE "PROTHEUS.CH"
#Include "TBICONN.CH"
#Include "DHL.CH"

//Array de empresa
#define CODEMP	1
#define CODFIL	2
#define CNPJ	3
#define NOMEEMP	4
#define NOMEFIL	5
#define XMLS	6


/*/{Protheus.doc} ExecImpXML

Automatização do importador XML.

@author Thiago Meschiatti
@since 22/10/2014
/*/
User Function ExecImpXML()

	local lAuto			:= IsBlind()
	local cDirectory	:= ""
	local oConnection	:= Connection():newConnection(CCONN, CSERVERADDR, NPORT)
	
	private oFolder  	:= DHLDirectoryManager():newDHLDirectoryManager("")
	private aFiles		:= {}
	private aLogAuto	:= {}
	
	if lAuto
		cDirectory := oConnection:getDirectory(APP_IMPORTADOR_XML)
		readFolder(cDirectory)
		if len(aFiles) > 0
			execImpJob(@cDirectory)
		endIf
	else
		U_ECIMPNFE()
	endif
	
	//Libera memoria apos o uso
	FreeObj(oConnection)
	FreeObj(oFolder)
	aFiles := Nil
	aLogAuto := Nil
	DelClassIntf()
	
return

/*
** Executa o processamento via job.
*/
static function execImpJob(cDirectory)
	local aEmpFil 	:= {}
	local nI,nJ,nPos:= 0
	local cError  	:= ""
	local cWarning	:= ""
	local cCnpjDest	:= ""
	local cXML		:= ""
	local oEnv 		:= IpEnvironmentObject():newIpEnvironmentObject()
	local oXMLUtil 	:= nil
	
	aEmpFil := EscEmpresa()
	
	for nI := 1 to len(aEmpFil)
		
		prepAmb(@oEnv, aEmpFil[nI, CODEMP], aEmpFil[nI, CODFIL])
        
		SET EPOCH TO 2000

		FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "***[ ExecImpXml ]*** Executando JOB...", 0, 0, {})		
		cDirectory := if(substr(cDirectory, len(cDirectory),1) == "\", cDirectory, cDirectory+"\")
	    
	    for nJ:= 1 to len(aFiles)
			
			cXML		:= aFiles[nJ]
			aLogAuto	:= {}
			
			oXMLUtil		:= ipXmlObject():newIpXmlObject(cXML)
			oXMLUtil:doParse()
			cCnpjDest		:= getCnpj(oXMLUtil)
            
            FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[ ExecImpXml ]*** Executando Arquivo: "+aFiles[nJ], 0, 0, {})
			
			procXml(aEmpFil, nI, cCnpjDest, cDirectory, cXML)

            FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[ ExecImpXml ]*** Finalizando Arquivo: "+aFiles[nJ], 0, 0, {})	
			
			//Libera memoria apos o uso
			FreeObj(oXMLUtil)
			DelClassIntf()
			
		next nJ
		
		oEnv:close()
		
	next nI
	
	//Libera memoria apos o uso
	FreeObj(oEnv)
	
    FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[ ExecImpXml ]*** Finalizando JOB...", 0, 0, {})	
return


/*
**  Funcao de processamento XML
*/
static function procXML(aEmpFil, nPosAtu, cCnpjDest, cDirectory, cXML)
	local cError	:= ""
	local cXMLAux	:= ""
	local oImpNfe	:= nil
	local oLog 		:= DHLLogManager():newDHLLogManager()
	
	cXMLAux	:= substr(cXML,rat("\", cXML)+1,len(cXML))

    FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[ ExecImpXml ]*** Executando ProcXML: "+cXML, 0, 0, {})	
    FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[ ExecImpXml ]*** Empresa:: "+cEmpAnt+" Filial: "+cFilAnt, 0, 0, {})		
    FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[ ExecImpXml ]*** CNPJ Filial: "+alltrim(aEmpFil[nPosAtu, CNPJ]), 0, 0, {})   
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[ ExecImpXml ]*** CNPJ Destino: "+alltrim(cCnpjDest), 0, 0, {})
	
	_cCNPJDep := SuperGetMV("ZZ_CNPJDEP",,"") //Acrescentado por Edson Deluca - Fit GEstão - 08/08/18

    FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[ ExecImpXml ]*** CNPJ Depositante: "+alltrim(_cCNPJDep), 0, 0, {})	
	
	if alltrim(aEmpFil[nPosAtu, CNPJ]) == alltrim(cCnpjDest) .Or. alltrim(cCnpjDest) $ alltrim(_cCNPJDep) //Acrescentado por Edson Deluca - Fit GEstão - 08/08/18 
		if oFolder:startProcess(cXML)
			oLog:start(APP_IMPORTADOR_XML, DHL_IMPORTACAO, cXML)
            FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[ ExecImpXml ]*** Executando TImpNfe: "+cXML, 0, 0, {})	
			oImpNfe	:= TImpNfe():new(cDirectory, cXMLAux+".processing")
			
			if oImpNfe:getSuccess()
				oLog:success(cXML)
                FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[ ExecImpXml ]*** Sucesso na importação do arquivo: "+cXML, 0, 0, {})
				oFolder:setProcessed(cXML)
			else
				cError := retError(aLogAuto)
				oLog:fail("Falha ao importar arquivo", cError)
                FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "***[ ExecImpXml ]*** Falha na importação do arquivo: "+cXML, 0, 0, {})
				oFolder:setError(cXML)
			endif
			
			//Libera memoria apos o uso
			FreeObj(oImpNfe)
		endif
//	else
//		nPos := aScan(aEmpFil,{|x| x[3] == cCnpjDest})
//		
//		If nPos == 0
//		   nPos := IIF(_cCNPJDep == cCnpjDest,1,0)
//	    EndIf
//	    	
//		if nPos == 0
//			if oFolder:startProcess(cXML)
//				oLog:start(APP_IMPORTADOR_XML, DHL_IMPORTACAO, cXML)
//               Conout("***[ ExecImpXml ]*** Falha ao importar arquivo", "CNPJ Destinatário não pertencente as empresas Protheus.") //Acrescentado por Edson Deluca - Fit GEstão - 08/08/18		
//				oLog:fail("Falha ao importar arquivo", "CNPJ Destinatário não pertencente as empresas Protheus.")
//				oFolder:setError(cXML)
//			endif
//		endif
	endif
	
	//Libera memoria apos o uso
	FreeObj(oLog)
return


/*
** Preparação do ambiente para execução do job.
*/
static function prepAmb(oEnv, cDHLEmp, cDHLFil)
	oEnv:setCompany(cDHLEmp)
	oEnv:setBranch(cDHLFil)
	oEnv:load()
return


/*
** Função para retornar erro do array de log.
*/
static function retError(aLogAuto)
	local cError := ""
	local nI	 := 0
	
	for nI:=1 to len(aLogAuto)
		if substr(aLogAuto[nI],1,1) $ "A|E|"
			cError += aLogAuto[nI] +CRLF
		endif
	next nI
	
return (cError)


/*
** Coleta string CNPJ do destinatario de acordo com modelo XML
*/
static function getCnpj(oXmlUtil)
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


/*
**  Funcao de processamento abertura do SM0
*/
static function MyOpenSM0(lShared)
	
	local lOpen := .F.
	local nLoop := 0
	
	for nLoop := 1 to 20
		OpenSM0(, lShared)
		
		if !Empty( Select( "SM0" ) )
			lOpen := .T.
			//dbSetIndex( "SIGAMAT.IND" )
			Exit
		endif
		
		Sleep( 500 )
		
	next nLoop
	
	if !lOpen
		MsgStop( "Não foi possível a abertura da tabela " + ;
			IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
	endif
	
return lOpen


/*
**  Funcao de para coleta de empresas
*/
static function EscEmpresa()
	local   aSalvAmb := GetArea()
	local   aSalvSM0 := {}
	local   aVetor   := {}
	
	local   aMarcadas  := {}
	
	if !MyOpenSm0(.T.)
		Return ({})
	endif
	
	dbSelectArea( "SM0" )
	aSalvSM0 := SM0->( GetArea() )
	SM0->(dbSetOrder( 1 ))
	SM0->(dbGoTop())
	
	while !SM0->( EOF() )
		
		if SM0->M0_CODIGO != "99" 
		 	if !deleted()
				aAdd(  aVetor, { SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CGC, SM0->M0_NOME, SM0->M0_FILIAL } )
			endif
		endif
		
		SM0->(dbSkip())
	end
	
	dbCloseArea()
	
	RestArea( aSalvSM0 )
	RestArea( aSalvAmb )
	
return (aVetor)

/**
* Ler o diretório de arquivos do Importador XML
**/
static function readFolder(cDirectory)

	oFolder:setDirectory(cDirectory)
	aFiles := oFolder:getFiles()

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "ExecImpXML - Achou " + Str(Len(aFiles)) + " arquivos." + CRLF, 0, 0, {})

return
