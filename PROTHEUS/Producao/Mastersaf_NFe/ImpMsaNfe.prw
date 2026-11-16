#include "totvs.ch"
#include "dhl.ch"
#include "rwmake.ch"

#define NAO_DEFINIDO				0
#define AUTORIZACAO					1
#define CANCELAMENTO				2
#define INUTILIZACAO				3

#define NF_REJEITADA				'N'

#define NF_ALIAS					1
#define NF_RECNO					2
#define NF_FLAG_IMP					3
#define NF_DESC_STATUS				4
#define NF_NFE						5
#define NF_EMISSSAO					6
#define NF_HORA						7
#define NF_PROTOCOLO				8
#define NF_DADOS					9
#define NF_AUTO						10

#define TM_CHAVE_NFE				44
#define CHAVE_NF					3

#define INUTILIZACAO_TRANSMITIDA	"1"
#define INUTILIZACAO_HOMOLOGADA		"2"
#define INUTILIZACAO_NAO_HOMOLOGADA	"3"

#define LOG_MSG_FALHA				"Falha ao Importar Arquivo de Retorno"

#define ENTRADA						"SF1"
#define SAIDA						"SF2"

/*/{Protheus.doc} ImpMsaNfe

Importação dos Arquivos de Retorno do Mastersaf NFe

@author Victor Hugo
@since 10/11/2014
/*/
user function ImpMsaNfe()

	local oConnection 	:= Connection():newConnection(CCONN,CSERVERADDR,NPORT)
	local cArqProcessing:= ""

	private lErros		:= .F.
	private nLidos		:= 0
	private nImportados	:= 0
	private oEnv 		:= IpEnvironmentObject():newIpEnvironmentObject()
	private aCompanies  := loadCompanies()
	private oSql		:= IpSqlObject():newIpSqlObject()
	private cDirectory	:= oConnection:getDirectory(APP_MASTERSAF_NFE)
	private oLog		:= DHLLogManager():newDHLLogManager()
	private oDir		:= DHLDirectoryManager():newDHLDirectoryManager(cDirectory)
	private aArquivos	:= oDir:getFiles()
	private cArqIP050	:= ""

	renArqProcessing()

	aArquivos := ordenaArquivos(cDirectory)

	if oEnv:hasMainWindow()
		if MsgBox("Confirma Importação dos Arquivos de Retorno do Mastersaf NFe ?", "Atenção", "YESNO")
			if Len(aArquivos) > 0
				MsAguarde({|| importaArquivos(aArquivos)}, "Aguarde", "Importando Retornos do Mastersaf NFe ...")
				lErros := (nImportados != nLidos)
				MsgBox("Lidos: "+AllTrim(Str(nLidos))+CRLF+"Importados: "+AllTrim(Str(nImportados))+CRLF+CRLF+;
					if(lErros, "Consulte o LOG de Integrações para maiores detalhes", ""), "Concluído", if(lErros, "ALERT", "INFO"))
				else
					MsgInfo("Não existem arquivos para serem importados.","ImpMsaNfe")
				endIf
			endIf
		else
			if Len(aArquivos) > 0
				importaArquivos(aArquivos)
				oEnv:close()
			endIf
		endIf

		return

/**
* Carrega as Empresas da DHL
*/
static function loadCompanies()

	local aRet  	:= {}

	OpenSm0()

	SM0->(dbGoTop())
	while SM0->(!eof())
		if SM0->M0_CODIGO != "99"
			if SM0->(!deleted())
				aAdd(aRet, {SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CGC})
			endif
		endif
		SM0->(dbSkip())
	endDo

return aRet

/**
* Importação dos Arquivos
*/
static function importaArquivos(aArquivos)

	local lOk   		:= .F.
	local nI 			:= 0
	local nTipo 		:= 0
	local oFile			:= nil
	local cArquivo		:= ""
	local cProcArq  	:= ""
	local cRealNameArq 	:= ""
	local cLockByMsaf	:= "IMPMSANFE"
	local lRet			:= .f.

	nLidos := Len(aArquivos)

	for nI := 1 to nLidos

		lRet := StartJob("U_DHLDLX", GetEnvServer(), .t.) //Prioriza processamento das interfaces do DLX

		if !LockByName( cLockByMsaf, .F., .F. ) .or. !(lRet)
			return
		endIf

		lOk   	 		:= .F.
		cArquivo 		:= aArquivos[nI][1]
		cArqIP050		:= aArquivos[nI][1]
		cRealNameArq	:= aArquivos[nI][2]

		nTipo 	 		:= getTipoArquivo(cArquivo)

		if (nTipo == NAO_DEFINIDO)
			loop
		endIf

		if !oDir:startProcess(cArquivo)
			loop
		endIf

		cProcArq := oDir:getProcessingFile(cArquivo)
		oFile    := IpFileObject():newIpFileObject(cProcArq)

		if !setEmpresa(oFile,nTipo)
			oFile:close()
			oDir:setError(cArquivo)
			loop
		endIf

		oLog:start(APP_MASTERSAF_NFE, DHL_IMPORTACAO, cArquivo)

		if lockByname(upper(cRealNameArq + ".PROCESSING"), .F., .F.)

			/** PARA TESTES IMPLEMENTAÇÃO RENOMEAR ARQUIVOS .PROCESSING
			if lockByname(upper(cRealNameArq + ".PROCESSING"), .F., .F.)
			lExecError := .F.
			for nJ := 1 to 100000000000
			if !lExecError
			conout("Lockado - " + time())
			if time() == "16:22:00"
			nSoma := 1 + "5"
			endIf
			else
			nSoma := 1 + "5"
			endIf
			next nJ
			endif
			**/

			lOk := impArquivo(nTipo, oFile)

			oFile:close()

			if lOk
				oLog:success()
				oDir:setProcessed(cArquivo)
			else
				oDir:setError(cArquivo)
			endIf

		else

			unLockByName(upper(cRealNameArq + ".PROCESSING"), .F., .F.)	

		endIf

		UnLockByName( cLockByMsaf, .F., .F. )
		
	next nI

return

/**
* Define a Empresa/Filial do Arquivo
*/
static function setEmpresa(oFile,nTipo)

	local lOk		:= .F.
	local cCodEmp  	:= ""
	local cCodFil  	:= ""
	local cLinha   	:= ""//oFile:readLine()
	local aDados   	:= {}//StrTokArr(cLinha, ";")
	local cCnpj	   	:= ""//aDados[7]
	local nScan	   	:= 0//aScan(aEmps, {|x| x[3] == cCnpj})
	local cMsg		:= ""

	while oFile:notIsEof()
		cLinha += oFile:readLine()
		oFile:skipLine()
	end

	oFile:goTop()
	aDados   := separa(cLinha, ";")

	if (nTipo == AUTORIZACAO)
		If Len(aDados) >= 7
			cCnpj	 := aDados[7]

			//TRATAMENTO QUANDO SEFAZ ESTA EM CONTINGÊNCIA
			if len(cCnpj) == 3
				cCnpj := aDados[8]
				nScan	   := aScan(aCompanies, {|x| x[3] == cCnpj})
				if nScan > 0
					cCodEmp := aCompanies[nScan,1]
					cCodFil := aCompanies[nScan,2]

					oEnv:setCompany(cCodEmp)
					oEnv:setBranch(cCodFil)
					oEnv:load()
				endIf
				cMsg := aDados[2] + ", " + aDados[21]
				oLog:start(APP_MASTERSAF_NFE, DHL_IMPORTACAO, oFile:getFile() )
				oLog:fail(LOG_MSG_FALHA, cMsg)
				return .F.
			endIf
		EndIf
	elseIf (nTipo == CANCELAMENTO)
		If Len(aDados) >= 4
			cCnpj	 := aDados[4]
		EndIf
	elseIf (nTipo == INUTILIZACAO)
		If Len(aDados) >= 3
			cCnpj	 := aDados[3]
		EndIf
	endIf

	If Empty(cCnpj)
		setCompany(aCompanies)
		oLog:fail(LOG_MSG_FALHA, "Falha ao ler arquivo.")
		return .F.
	EndIf

	nScan	   := aScan(aCompanies, {|x| x[3] == cCnpj})

	if (nScan == 0)
		setCompany(aCompanies)
		oLog:start(APP_MASTERSAF_NFE, DHL_IMPORTACAO, oFile:getFile() )
		oLog:fail(LOG_MSG_FALHA, "CNPJ não encontrado: "+cCnpj)
		return .F.
	endIf

	cCodEmp := aCompanies[nScan,1]
	cCodFil := aCompanies[nScan,2]

	oEnv:setCompany(cCodEmp)
	oEnv:setBranch(cCodFil)
	oEnv:load()

	lOk := (Type("cEmpAnt") == "C" .and. cEmpAnt+cFilAnt == cCodEmp+cCodFil)

	if !lOk
		oLog:fail(LOG_MSG_FALHA, "Falha ao carregar Empresa/Filial: "+cCodEmp+"/"+cCodFil)
	endIf

return lOk

/**
* Verifica o Tipo de um Arquivo
*/
static function getTipoArquivo(cArquivo)

	local oFile		:= IpFileObject():newIpFileObject(cArquivo)
	local nTipo 	:= NAO_DEFINIDO
	local cNomeArq	:= oFile:getFileName()
	local cPrefixo  := Left(Upper(AllTrim(cNomeArq)), 7)

	if (cPrefixo == "RET_NFE")
		nTipo := AUTORIZACAO
	elseIf (cPrefixo == "RET_CAN")
		nTipo := CANCELAMENTO
	elseIf (cPrefixo == "RET_INU")
		nTipo := INUTILIZACAO
	endIf

	oFile:close()

return nTipo

/**
* Importa um Arquivo de Retorno
*/
static function impArquivo(nTipo, oFile)

	local lOk	   := .F.
	local aDadosNf := getDadosNf(nTipo, oFile)

	if (nTipo != INUTILIZACAO .and. Len(aDadosNf) == 0)
		return .F.
	endIf

	if (nTipo == AUTORIZACAO)
		lOk := impAutorizacao(aDadosNf, oFile)
	elseIf (nTipo == CANCELAMENTO)
		lOk := impCancelamento(aDadosNf)
	elseIf (nTipo == INUTILIZACAO)
		lOk := impInutilizacao(oFile)
	endIf

	if lOk
		nImportados++
	endIf

return lOk

/**
* Importa Arquivos de Autorização
*/
static function impAutorizacao(aDadosNf, oFile)

	local cCodStatus := ""
	local cFlagImp	 := ""
	local cDescStatus:= ""
	local cProtocolo := ""
	local cObsLivro	 := ""
	local cNumNf	 := ""
	local cDatComple := ""
	local cMsgType	 := ""
	local cDocAux	 := ""
	local cSeriAux	 := ""
	local nRecno     := aDadosNf[NF_RECNO]
	local cAlias     := aDadosNf[NF_ALIAS]
	local cCpoFlag   := aDadosNf[NF_FLAG_IMP]
	local cCpoStatus := aDadosNf[NF_DESC_STATUS]
	local cCpoNfe	 := aDadosNf[NF_NFE]
	local cCpoEmiss  := aDadosNf[NF_EMISSSAO]
	local cCpoHora	 := aDadosNf[NF_HORA]
	local cCpoProt	 := aDadosNf[NF_PROTOCOLO]
	local cCpoAuto	 := aDadosNf[NF_AUTO]
	local aLinhaArq	 := aDadosNf[NF_DADOS]
	local oSql		 := IpSqlObject():newIpSqlObject()
	local aArea		 := (cAlias)->(GetArea())
	local aCodDen	 := {"110","301","302","303","304","305","306"}
	local aCodAut	 := {"100","101","102","103","104","105","106","107","108","109","111","112"}
	local lModelo3	 := alltrim(GetNewPar("ZZ_MODEFAT", "1")) $ "3"
	local oModelo3	 := DHLModelo3():NewDHLModelo3()
	local oDHLIP210	 := nil
	local lStatusRET := .T.

	cCodStatus  := aLinhaArq[1]
	cDescStatus := aLinhaArq[2]
	cMsgType	:= aLinhaArq[12]
	cProtocolo  := aLinhaArq[13]
	cDatComple	:= aLinhaArq[14]
	//RONI SILVA INICIO
	oModelo3:VerifItNF1(nRecno)
	SF2->(DbGoto(nRecno))
	CMODFAT3 := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_ZZMODFA")
	IF alltrim(CMODFAT3) $ "1" .AND. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
		lModelo3 := .T.
	endif

	//RONI SILVA FIM

	if (aScan(aCodAut,Alltrim(cCodStatus)) > 0)
		cFlagImp := "S"
		if FWUnitBusiness() == DHL_BUSINESSUNIT_PKG
			oModelo3:VerifItNF1(nRecno)
			if lModelo3 .and. !oModelo3:IsTesTransferencia()
				if oModelo3:CanCreateInvConf(nRecno)

					oModelo3:GetRecnosNF(nRecno)
					sendInterfaces(cAlias,oModelo3:GetRecnNF1(),"03",.T.)
					sendInterfaces(cAlias,oModelo3:GetRecnNF2(),"03",.T.)

				elseIf oModelo3:GetZZTpNf() == COBRANCA_KIT .AND. !oModelo3:IsTesRede()
					oModelo3:GerNF2Issue(nRecno)
				elseIf oModelo3:IsTesRede() //ITEM B UC 1.5
					sendInterfaces(cAlias,nRecno,"03",.T.)
				endIf
			else
				sendInterfaces(cAlias,nRecno,"03",.T.)
			endIf
			//RONI SILVA INICIO
		Elseif FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
			oModelo3:VerifItNF1(nRecno)
			SF2->(DbGoto(nRecno))
			CMODFAT3 := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_ZZMODFA")
			IF alltrim(CMODFAT3) $ "1" .AND. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
				lModelo3 := .T.
			endif
			if lModelo3 .and. !oModelo3:IsTesTransferencia()
				if oModelo3:CanCreateInvConf(nRecno)

					oModelo3:GetRecnosNF(nRecno)
					sendInterfaces(cAlias,oModelo3:GetRecnNF1(),"03",.T.)
					sendInterfaces(cAlias,oModelo3:GetRecnNF2(),"03",.T.)

				elseIf oModelo3:GetZZTpNf() == COBRANCA_KIT .AND. !oModelo3:IsTesRede()
					oModelo3:GerNF2Issue(nRecno)
				elseIf oModelo3:IsTesRede() //ITEM B UC 1.5
					sendInterfaces(cAlias,nRecno,"03",.T.)
				endIf
			else
				sendInterfaces(cAlias,nRecno,"03",.T.)
			endIf
			//RONI SILVA FIM
		elseIf FWUnitBusiness() == DHL_BUSINESSUNIT_AG2

			if cAlias == ENTRADA
				oDHLIP210 := DHLIP210():newDHLIP210()
				oDHLIP210:SetApp(APP_MASTERSAF_NFE)
				oDHLIP210:SetMensagemLog("Faturamento não realizado")
				oDHLIP210:SetLog(nil)
				oDHLIP210:SetFilePath(oFile:getFile())
				begin transaction
					if oDHLIP210:IsRecusa(nRecno) .and. oDHLIP210:IsASNSend(nRecno)
						oDHLIP210:loadDadosRecusa(nRecno)
						oDHLIp210:GerPedidoVend()
						if !oDHLIp210:hasError()
							oDHLIp210:FaturarPedido()
						endIf
					endIf
				end transaction
			endIf
			if cAlias == SAIDA
				u_SAPIP200(nRecno, cProtocolo, cDatComple)
				sendInterfaces(cAlias,nRecno,"03",.T.)
			endIf
		else
			sendInterfaces(cAlias,nRecno,"03",.T.)
		endIf
	elseIf (aScan(aCodDen,Alltrim(cCodStatus)) > 0)
		cFlagImp  := "D"
		cObsLivro := "NF DENEGADA"
	else
		cFlagImp := "N"
	endIf

	dbselectarea(cAlias)
	(cAlias)->(dbsetOrder(0))
	(cAlias)->(dbgoto(nRecno))

	if FWUnitBusiness() == DHL_BUSINESSUNIT_PKG .and. lModelo3

		if cFlagImp == NF_REJEITADA .and. SF2->F2_ZZTPNF == RETORNO_INDUSTRIALIZACAO
			oModelo3:SendEmail(cAlias)
		endif

	endIf
	//RONI SILVA INICIO
	if FWUnitBusiness() == DHL_BUSINESSUNIT_MUL .and. lModelo3

		if cFlagImp == NF_REJEITADA  //RONI SILVA TESTE.and. SF2->F2_ZZTPNF == RETORNO_INDUSTRIALIZACAO
			oModelo3:SendEmail(cAlias)
		endif

	endIf
	//RONI SILVA FIM

	if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		if cMsgType == NF_REJEITADA  .and. (cAlias)->&(cCpoAuto) == 'S'
			fEnvEmail(cAlias)
		endif
	endif

	(cAlias)->(RecLock(cAlias, .f.))
	(cAlias)->&(cCpoFlag) 	:= cFlagImp
	(cAlias)->&(cCpoStatus)	:= cDescStatus
	(cAlias)->&(cCpoNfe)	:= ''
	(cAlias)->&(cCpoEmiss)	:= StoD(SubStr(cDatComple,1,4)+SubStr(cDatComple,6,2)+SubStr(cDatComple,9,2))
	(cAlias)->&(cCpoHora)	:= Substr(cDatComple,at(" ",cDatComple)+1,8)
	(cAlias)->&(cCpoProt)	:= cProtocolo
	(cAlias)->(MsUnlock())

	if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		sendIntCTE(cAlias)
		if cAlias $ "SF2" .and. cFlagImp $ "S"
			if SM0->M0_ESTCOB <> (cAlias)->F2_EST
				u_ProcNfAut(DHL_NFE_INVOICE_INFLOW, (cAlias)->F2_DOC, (cAlias)->F2_SERIE, (cAlias)->F2_CLIENTE, (cAlias)->F2_LOJA)
			endif
		endif
	endif

	if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
		if cAlias $ "SF2" .and. cFlagImp $ "S"
			if (cAlias)->F2_ZZTPNF == REMESSA_CONTA_ORDEM
				//				oFile:close()
				//				oDir:setProcessed(oFile:getFile())
				sendRCO(cAlias)
				cDocAux 	:= (cAlias)->F2_DOC
				cSeriAux 	:= (cAlias)->F2_SERIE
				lStatusRET  := u_PrcNfRet(cDocAux, cSeriAux, @oLog)

				if !lStatusRET
					oLog:nRecno := 0
				endIf

			elseIf (cAlias)->F2_ZZTPNF == RETORNO_SIMBOLICO
				sendRSymb(cAlias)
			endif
		endif
	endif

	if FWUnitBusiness() == DHL_BUSINESSUNIT_AGL
		if cAlias $ "SF2" .and. cFlagImp $ "S"
			if (cAlias)->F2_ZZTPNF == REMESSA_CONTA_ORDEM
				cDocAux 	:= (cAlias)->F2_DOC
				cSeriAux 	:= (cAlias)->F2_SERIE
				
				lStatusRET  := u_AglNfRetSimbolico(,, cDocAux, cSeriAux)

			endif
		endif
	endif

	RestArea(aArea)

	//oSql:update(cAlias, cCpoFlag+" = '"+cFlagImp+"', "+cCpoStatus+" = '"+cDescStatus+"'", "R_E_C_N_O_ = "+AllTrim(Str(nRecno)))

	atualizaLivrosFiscais(cAlias, nRecno, cCodStatus, cProtocolo, cObsLivro, , cDatComple)

return lStatusRET

/**
* Importa Arquivos de Cancelamento
*/
static function impCancelamento(aDadosNf)
	local aArea	:= GetArea()
	local aSF2		:= SF2->(GetArea())
	local lOk		 := .F.
	local cCodStatus := ""
	local cFlagImp	 := ""
	local cDescStatus:= ""
	local cProtocolo := ""
	local cObsLivro	 := ""
	local nRecno     := aDadosNf[NF_RECNO]
	local cAlias     := aDadosNf[NF_ALIAS]
	local cCpoFlag   := aDadosNf[NF_FLAG_IMP]
	local cCpoStatus := aDadosNf[NF_DESC_STATUS]
	local aLinhaArq	 := aDadosNf[NF_DADOS]
	local dDataCanc	 := CtoD("")
	local oSql		 := IpSqlObject():newIpSqlObject()
	local aArea		 := (cAlias)->(GetArea())
	local lModelo3	 := alltrim(GetNewPar("ZZ_MODEFAT", "1")) $ "3"
	local oModelo3	 := DHLModelo3():NewDHLModelo3()
	local cTipoNF	 := ""
	local oDHLIp150	 := nil
	local oDHLIp160  := nil
	local oDHLIp210	 := nil
	local cXmlFile	 := ""
	local cReference := ""
	local nRecnoSF1	 := 0
	local nRecnoSC5	 := 0

	cCodStatus  := aLinhaArq[1]
	cDescStatus := aLinhaArq[2]
	cProtocolo  := aLinhaArq[6]
	dDataCanc   := getDataCancelamento(aLinhaArq)

	//RONI SILVA INICIO
	SF2->(DbGoto(nRecno))
	CMODFAT3 := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_ZZMODFA")
	IF alltrim(CMODFAT3) $ "1" .AND. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
		lModelo3 := .T.
	endif
	//RONI SILVA FIM

	if (cCodStatus == "101")

		//INICIO PERSONALIZAÇÃO MODELO 3 (GUSTAVO LUIZ) 10/05/2017
		if FWUnitBusiness() == DHL_BUSINESSUNIT_PKG .AND. lModelo3

			oSql:newTable("SF2", "F2_ZZTPNF TIPONF", "F2_FILIAL = '"+xFilial("SF2")+"' AND R_E_C_N_O_ = "+ AllTrim(Str(nRecno)))

			if oSql:hasRecords()
				cTipoNF := oSql:getValue("TIPONF")
			endIf

			if cTipoNF == COBRANCA_KIT

				oModelo3:PosicNotaAtual(nRecno)
				oModelo3:GetDadoNFReferenc()

				if oModelo3:GetFimpRef() == "S"

					oModelo3:VerifItNF1(SF2->(Recno()))

					//SE EXISTIR ALGUM ITEM QUE UTILIZA A TES DO PARÂMETRO ZZ_TESREDE NÃO GERA O CANCELAMENTO DA NF2 ITEM B UC 1.7
					if !oModelo3:IsTesRede()
						oModelo3:GerNF2Cancelation(nRecno)
					endIf

					if excluiNf(cAlias, nRecno)
						lOk := .T.
						atualizaLivrosFiscais(cAlias, nRecno, cCodStatus, cProtocolo, cObsLivro, dDataCanc)

						sendInterfaces(cAlias,nRecno,"04",.F.)

						dbselectarea(cAlias)
						(cAlias)->(dbsetOrder(0))
						(cAlias)->(dbgoto(nRecno))
						(cAlias)->(RecLock(cAlias, .f.))
						(cAlias)->&(cCpoStatus)	:= cDescStatus
						(cAlias)->(MsUnlock())

						RestArea(aArea)
					endIf

					oModelo3:RetornaAreas()
					return .T.

				else

					oModelo3:SetRecnNF1(nRecno)
					oModelo3:Posiciona(nRecno)
					oModelo3:SetRecnNF2(SF2->(Recno()))
					oModelo3:RetornaAreas()
					oModelo3:VerifItNF1(SF2->(Recno()))

					if excluiNf(cAlias, oModelo3:GetRecnNF1())
						lOk := .T.
						atualizaLivrosFiscais(cAlias, oModelo3:GetRecnNF1(), cCodStatus, cProtocolo, cObsLivro, dDataCanc)

						sendInterfaces(cAlias,oModelo3:GetRecnNF1(),"04",.F.)

						dbselectarea(cAlias)
						(cAlias)->(dbsetOrder(0))
						(cAlias)->(dbgoto(oModelo3:GetRecnNF1()))
						(cAlias)->(RecLock(cAlias, .f.))
						(cAlias)->&(cCpoStatus)	:= cDescStatus
						(cAlias)->(MsUnlock())

						RestArea(aArea)
					endIf

					//SE EXISTIR ALGUM ITEM QUE UTILIZA A TES DO PARÂMETRO ZZ_TESREDE NÃO EXCLUI A NF2 ITEM B UC 1.7
					if !oModelo3:IsTesRede()
						if excluiNf(cAlias, oModelo3:GetRecnNF2())
							lOk := .T.
						endIf
					endIf
				endIf
			else

				oModelo3:SetRecnNF2(nRecno)
				oModelo3:Posiciona(nRecno)
				oModelo3:SetRecnNF1(SF2->(Recno()))
				oModelo3:RetornaAreas()

				//EXCLUI A NOTA 2
				if excluiNf(cAlias, nRecno)
					lOk := .T.
					atualizaLivrosFiscais(cAlias, nRecno, cCodStatus, cProtocolo, cObsLivro, dDataCanc)

					sendInterfaces(cAlias,nRecno,"04",.F.)

					dbselectarea(cAlias)
					(cAlias)->(dbsetOrder(0))
					(cAlias)->(dbgoto(nRecno))
					(cAlias)->(RecLock(cAlias, .f.))
					(cAlias)->&(cCpoStatus)	:= cDescStatus
					(cAlias)->(MsUnlock())

					RestArea(aArea)
				else
					lOk := .F.
				endIf
			endIf
			return lOk
		endIf
		//FIM PERSONALIZAÇÃO MODELO 3 (GUSTAVO LUIZ) 10/05/2017
		//RONI SILVA INICIO
		if FWUnitBusiness() == DHL_BUSINESSUNIT_MUL .AND. lModelo3

			oSql:newTable("SF2", "F2_ZZTPNF TIPONF", "F2_FILIAL = '"+xFilial("SF2")+"' AND R_E_C_N_O_ = "+ AllTrim(Str(nRecno)))

			if oSql:hasRecords()
				cTipoNF := oSql:getValue("TIPONF")
			endIf

			if cTipoNF == COBRANCA_KIT

				oModelo3:PosicNotaAtual(nRecno)
				oModelo3:GetDadoNFReferenc()

				if oModelo3:GetFimpRef() == "S"

					oModelo3:VerifItNF1(SF2->(Recno()))

					//SE EXISTIR ALGUM ITEM QUE UTILIZA A TES DO PARÂMETRO ZZ_TESREDE NÃO GERA O CANCELAMENTO DA NF2 ITEM B UC 1.7
					if !oModelo3:IsTesRede()
						oModelo3:GerNF2Cancelation(nRecno)
					endIf

					if excluiNf(cAlias, nRecno)
						lOk := .T.
						atualizaLivrosFiscais(cAlias, nRecno, cCodStatus, cProtocolo, cObsLivro, dDataCanc)

						sendInterfaces(cAlias,nRecno,"04",.F.)

						dbselectarea(cAlias)
						(cAlias)->(dbsetOrder(0))
						(cAlias)->(dbgoto(nRecno))
						(cAlias)->(RecLock(cAlias, .f.))
						(cAlias)->&(cCpoStatus)	:= cDescStatus
						(cAlias)->(MsUnlock())

						RestArea(aArea)
					endIf

					oModelo3:RetornaAreas()
					return .T.

				else

					oModelo3:SetRecnNF1(nRecno)
					oModelo3:Posiciona(nRecno)
					oModelo3:SetRecnNF2(SF2->(Recno()))
					oModelo3:RetornaAreas()
					oModelo3:VerifItNF1(SF2->(Recno()))

					if excluiNf(cAlias, oModelo3:GetRecnNF1())
						lOk := .T.
						atualizaLivrosFiscais(cAlias, oModelo3:GetRecnNF1(), cCodStatus, cProtocolo, cObsLivro, dDataCanc)

						sendInterfaces(cAlias,oModelo3:GetRecnNF1(),"04",.F.)

						dbselectarea(cAlias)
						(cAlias)->(dbsetOrder(0))
						(cAlias)->(dbgoto(oModelo3:GetRecnNF1()))
						(cAlias)->(RecLock(cAlias, .f.))
						(cAlias)->&(cCpoStatus)	:= cDescStatus
						(cAlias)->(MsUnlock())

						RestArea(aArea)
					endIf

					//SE EXISTIR ALGUM ITEM QUE UTILIZA A TES DO PARÂMETRO ZZ_TESREDE NÃO EXCLUI A NF2 ITEM B UC 1.7
					if !oModelo3:IsTesRede()
						if excluiNf(cAlias, oModelo3:GetRecnNF2())
							lOk := .T.
						endIf
					endIf
				endIf
			else

				oModelo3:SetRecnNF2(nRecno)
				oModelo3:Posiciona(nRecno)
				oModelo3:SetRecnNF1(SF2->(Recno()))
				oModelo3:RetornaAreas()

				//EXCLUI A NOTA 2
				if excluiNf(cAlias, nRecno)
					lOk := .T.
					atualizaLivrosFiscais(cAlias, nRecno, cCodStatus, cProtocolo, cObsLivro, dDataCanc)

					sendInterfaces(cAlias,nRecno,"04",.F.)

					dbselectarea(cAlias)
					(cAlias)->(dbsetOrder(0))
					(cAlias)->(dbgoto(nRecno))
					(cAlias)->(RecLock(cAlias, .f.))
					(cAlias)->&(cCpoStatus)	:= cDescStatus
					(cAlias)->(MsUnlock())

					RestArea(aArea)
				else
					lOk := .F.
				endIf
			endIf
			return lOk
		endIf
		//RONI SILVA FIM

		//INICIO PERSONALIZAÇÃO SCJ - IP150 - GUSTAVO LUIZ
		if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2

			oDHLIp150 := DHLIp150():NewDHLIp150()
			oDHLIp150:SetTipoNf(nRecno)
			oDHLIp150:SetKeyProtheus(aLinhaArq[CHAVE_NF])

			if 	oDHLIp150:GetTipoNf() == REMESSA_CONTA_ORDEM
				oDHLIp150:GetRecnos(aLinhaArq[CHAVE_NF], REMESSA_CONTA_ORDEM)
				if !oDHLIp150:HasError()
					oDHLIp150:ExcluiRCO(nRecno)
					if !oDHLIp150:HasError()
						oDHLIp150:SendCancellation(oDHLIp150:GetRecnoRET())

						lOk := .T.

						atualizaLivrosFiscais(cAlias, nRecno, cCodStatus, cProtocolo, cObsLivro, dDataCanc)

						sendInterfaces(cAlias,nRecno,"04",.F.)

						dbselectarea(cAlias)
						(cAlias)->(dbsetOrder(0))
						(cAlias)->(dbgoto(nRecno))
						(cAlias)->(RecLock(cAlias, .f.))
						(cAlias)->&(cCpoStatus)	:= cDescStatus
						(cAlias)->(MsUnlock())

					endIf
				endIf
			elseIf 	oDHLIp150:GetTipoNf() == AJUSTE_FISCAL

				oDHLIp210 := DHLIp210():newDHLIp210()
				begin transaction

					oDHLIp210:getSF1_SC5_recnos(nRecno, @nRecnoSF1, @nRecnoSC5)

					if oDHLIp210:excluiNf(cAlias, nRecno, .F.)
						lOk := .T.

						oDHLIp210:eraseFields(nRecnoSF1)
						oDHLIp210:ExcluiPedido(nRecnoSC5, .F.)

						atualizaLivrosFiscais(cAlias, nRecno, cCodStatus, cProtocolo, cObsLivro, dDataCanc)

						sendInterfaces(cAlias,nRecno,"04",.F.)

						dbselectarea(cAlias)
						(cAlias)->(dbsetOrder(0))
						(cAlias)->(dbgoto(nRecno))
						(cAlias)->(RecLock(cAlias, .f.))
						(cAlias)->&(cCpoStatus)	:= cDescStatus
						(cAlias)->(MsUnlock())

						RestArea(aArea)

					endIf
				end transaction
			elseif oDHLIp150:GetTipoNf() == RETORNO_SIMBOLICO
				oDHLIp150:SetRecnoRET(nRecno)
				oDHLIp150:GetAreas()
				SF2->(DbGoTo(nRecno))
				oDHLIp150:SetNfRetSimb(SF2->F2_DOC)
				oDHLIp150:SetSerRetSimb(SF2->F2_SERIE)
				oDHLIp150:SetKeyRet(SF2->F2_CHVNFE)
				oDHLIp150:RestAreas()
				if oDHLIp150:ExcluiRET(nRecno)

					lOk := .T.

					atualizaLivrosFiscais(cAlias, nRecno, cCodStatus, cProtocolo, cObsLivro, dDataCanc)

					sendInterfaces(cAlias,nRecno,"04",.F.)

					oDHLIp150:GetAreas()
					dbselectarea(cAlias)
					(cAlias)->(dbsetOrder(0))
					(cAlias)->(dbgoto(nRecno))
					(cAlias)->(RecLock(cAlias, .f.))
					(cAlias)->&(cCpoStatus)	:= cDescStatus
					(cAlias)->(MsUnlock())
					oDHLIp150:RestAreas()

					//INICIO PERSONALIZAÇÃO IP160 - GUSTAVO LUIZ
					u_SAPIP160(oDHLIp150)
					//FIM PERSONALIZAÇÃO IP160 - GUSTAVO LUIZ
				endIf
			else
				__cUserId := "RPC"
				if excluiNf(cAlias, nRecno)
					lOk := .T.
					atualizaLivrosFiscais(cAlias, nRecno, cCodStatus, cProtocolo, cObsLivro, dDataCanc)

					sendInterfaces(cAlias,nRecno,"04",.F.)

					dbselectarea(cAlias)
					(cAlias)->(dbsetOrder(0))
					(cAlias)->(dbgoto(nRecno))
					(cAlias)->(RecLock(cAlias, .f.))
					(cAlias)->&(cCpoStatus)	:= cDescStatus
					(cAlias)->(MsUnlock())

					RestArea(aArea)
				endIf
			endIf
			//FIM PERSONALIZAÇÃO SCJ - IP150 - GUSTAVO LUIZ

		else
			if excluiNf(cAlias, nRecno)
				lOk := .T.
				atualizaLivrosFiscais(cAlias, nRecno, cCodStatus, cProtocolo, cObsLivro, dDataCanc)

				sendInterfaces(cAlias,nRecno,"04",.F.)

				dbselectarea(cAlias)
				(cAlias)->(dbsetOrder(0))
				(cAlias)->(dbgoto(nRecno))
				(cAlias)->(RecLock(cAlias, .f.))
				(cAlias)->&(cCpoStatus)	:= cDescStatus
				(cAlias)->(MsUnlock())

				RestArea(aArea)

			endIf

		endIf

	else
		lOk := .T.
		//oSql:update(cAlias, cCpoFlag+" = 'X', "+cCpoStatus+" = '"+cDescStatus+"'", "R_E_C_N_O_ = "+AllTrim(Str(nRecno)))

		//INICIO PERSONALIZAÇÃO MODELO 3 (GUSTAVO LUIZ) 10/05/2017
		if FWUnitBusiness() == DHL_BUSINESSUNIT_PKG .AND. lModelo3

			oSql:newTable("SF2", "F2_ZZTPNF TIPONF", "F2_FILIAL = '"+xFilial("SF2")+"' AND R_E_C_N_O_ = "+ AllTrim(Str(nRecno)))

			if oSql:hasRecords()
				cTipoNF := oSql:getValue("TIPONF")
			endIf

			if cTipoNF == RETORNO_INDUSTRIALIZACAO

				oModelo3:PosicNotaAtual(nRecno)
				oModelo3:SendEmail("SF2")
				oModelo3:RetornaAreas()

			endIf

		endIf
		//FIM PERSONALIZAÇÃO MODELO 3 (GUSTAVO LUIZ) 10/05/2017

		//RONI SILVA INICIO
		if FWUnitBusiness() == DHL_BUSINESSUNIT_MUL .AND. lModelo3

			oSql:newTable("SF2", "F2_ZZTPNF TIPONF", "F2_FILIAL = '"+xFilial("SF2")+"' AND R_E_C_N_O_ = "+ AllTrim(Str(nRecno)))

			if oSql:hasRecords()
				cTipoNF := oSql:getValue("TIPONF")
			endIf

//RONI SILVA			if cTipoNF == RETORNO_INDUSTRIALIZACAO

			oModelo3:PosicNotaAtual(nRecno)
			oModelo3:SendEmail("SF2")
			oModelo3:RetornaAreas()

//RONI SILVA			endIf

		endIf
		//RONI SILVA FIM

		//INICIO PERSONALIZAÇÃO SCJ - IP150 - CANCELAMENTO NÃO AUTORIZADO - GUSTAVO LUIZ
		if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2

			lOk := .F.
			oDHLIp150 := DHLIp150():NewDHLIp150()
			oDHLIp150:SetTipoNf(nRecno)
			oDHLIp150:GetAreas()
			if 	oDHLIp150:GetTipoNf() == REMESSA_CONTA_ORDEM
				SF2->(DbGoTo(nRecno))
				oLog:fail(LOG_MSG_FALHA, "Cancelamento não autorizado para o documento/série : "+SF2->F2_DOC+"/"+SF2->F2_SERIE+" (RCO)")
			else
				SF2->(DbGoTo(nRecno))
				oLog:fail(LOG_MSG_FALHA, "Cancelamento não autorizado para o documento/série : "+SF2->F2_DOC+"/"+SF2->F2_SERIE+" (RET)")
			endIf
			oDHLIp150:RestAreas()
		endIf
		//FIM PERSONALIZAÇÃO SCJ - IP150 - CANCELAMENTO NÃO AUTORIZADO - GUSTAVO LUIZ

		dbselectarea(cAlias)
		(cAlias)->(dbsetOrder(0))
		(cAlias)->(dbgoto(nRecno))
		(cAlias)->(RecLock(cAlias, .f.))
		(cAlias)->&(cCpoFlag) 	:= 'X'
		(cAlias)->&(cCpoStatus)	:= cDescStatus
		(cAlias)->(MsUnlock())

		RestArea(aArea)
	endIf
	restArea(aSF2)
	restArea(aArea)
return lOk

/**
* Coleta a Data de Cancelamento do Arquivo
*/
static function getDataCancelamento(aLinhaArq)

	local cDataHora := AllTrim(aLinhaArq[7])
	local cAno		:= Left(cDataHora, 4)
	local cMes		:= SubStr(cDataHora, 6, 2)
	local cDia		:= SubStr(cDataHora, 9, 2)
	local dDataCanc := CtoD(cDia+"/"+cMes+"/"+cAno)

return dDataCanc

/**
* Exclusão das Notas Fiscais
*/
static function excluiNf(cAlias, nRecno)

	local cIdDoc		:= ""
	local aCab   		:= {}
	local aItens 		:= {}
	local aRegSD2		:= {}
	local aRegSE1		:= {}
	local aRegSE2		:= {}
	local oUtils		:= IpUtilsObject():newIpUtilsObject()
	local cTeste		:= ""
	Local cMarca		:= ""
	local lCarteira		:= .F.
	local lSF2520E  	:= Existblock("SF2520E")
	private lMsErroAuto	:= .F.
	private lMsHelpAuto := .T.

	getDadosAuto(cAlias, nRecno, @aCab, @aItens, @cIdDoc)

	if (cAlias == "SF2")
		lMsErroAuto := !MaCanDelF2("SF2",SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2)
		if !lMsErroAuto
			If lSF2520E
				ExecBlock("SF2520E",.F.,.F.)
			EndIf

			//NECESSÁRIO PARA EXCLUSÃO DO PEDIDO DE VENDAS
			if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2 .and. SF2->F2_ZZTPNF == AJUSTE_FISCAL
				lCarteira := .T.
			endIf
			lMsErroAuto := !SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,.F.,.F.,.T.,lCarteira))
		endIf
	else
		MsExecAuto({|x,y,z| MATA103(x,y,z)}, aCab, aItens, 5)
	endIf

	if lMsErroAuto
		oLog:fail("Falha ao Excluir Documento", cIdDoc+CRLF+oUtils:getErroAuto())
	else
		if (cAlias == "SF2")
			SF2->(dbGoTo(nRecno))
			cMarca	:= GetMark(,"SF2","F2_OK")
			RecLock('SF2',.f.)
			SF2->F2_OK := cMarca
			SF2->(MsUnLock())
		endif
	endIf

	lMsHelpAuto := .F.

return !lMsErroAuto

/**
* Coleta os dados para as Rotinas Automáticas de Exclusão
*/
static function getDadosAuto(cAlias, nRecno, aCab, aItens, cIdDoc)

	local aItem := {}
	local oSql  := IpSqlObject():newIpSqlObject()

	aCab   := {}
	aItens := {}

	if (cAlias == "SF2")

		SF2->(dbGoTo(nRecno))

		cIdDoc := "Tipo: Saída"+CRLF
		cIdDoc += "Documento: "+SF2->F2_DOC+CRLF
		cIdDoc += "Série: "+SF2->F2_SERIE+CRLF

		aAdd(aCab, {"F2_FILIAL", SF2->F2_FILIAL, nil})
		aAdd(aCab, {"F2_DOC", SF2->F2_DOC, nil})
		aAdd(aCab, {"F2_SERIE", SF2->F2_SERIE, nil})

	elseIf (cAlias == "SF1")

		SF1->(dbGoTo(nRecno))

		cIdDoc := "Tipo: Entrada"+CRLF
		cIdDoc += "Documento: "+SF1->F1_DOC+CRLF
		cIdDoc += "Série: "+SF1->F1_SERIE+CRLF
		cIdDoc += "Cliente/Fornecedor: "+SF1->F1_FORNECE+CRLF
		cIdDoc += "Loja: "+SF1->F1_LOJA+CRLF

		aAdd(aCab, {"F1_FILIAL", SF1->F1_FILIAL, nil})
		aAdd(aCab, {"F1_DOC", SF1->F1_DOC, nil})
		aAdd(aCab, {"F1_SERIE", SF1->F1_SERIE, nil})
		aAdd(aCab, {"F1_FORNECE", SF1->F1_FORNECE, nil})
		aAdd(aCab, {"F1_LOJA", SF1->F1_LOJA, nil})
		aAdd(aCab, {"F1_TIPO", SF1->F1_TIPO, nil})
		aAdd(aCab, {"F1_FORMUL", SF1->F1_FORMUL, nil})
		aAdd(aCab, {"F1_EMISSAO", SF1->F1_EMISSAO, nil})
		aAdd(aCab, {"F1_COND", SF1->F1_COND, nil})

		oSql:newTable("SD1", "D1_ITEM,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_TES",;
			"D1_FILIAL = '"+SF1->F1_FILIAL+"' AND D1_DOC = '"+SF1->F1_DOC+"' AND "+;
			"D1_SERIE = '"+SF1->F1_SERIE+"' AND D1_FORNECE = '"+SF1->F1_FORNECE+"' AND "+;
			"D1_LOJA = '"+SF1->F1_LOJA+"' AND D1_TIPO = '"+SF1->F1_TIPO+"' ")

		while oSql:notIsEof()
			aItem := {}
			aAdd(aItem, {"D1_ITEM", oSql:getValue("D1_ITEM"), nil})
			aAdd(aItem, {"D1_COD", oSql:getValue("D1_COD"), nil})
			aAdd(aItem, {"D1_QUANT", oSql:getValue("D1_QUANT"), nil})
			aAdd(aItem, {"D1_VUNIT", oSql:getValue("D1_VUNIT"), nil})
			aAdd(aItem, {"D1_TOTAL", oSql:getValue("D1_TOTAL"), nil})
			aAdd(aItem, {"D1_TES", oSql:getValue("D1_TES"), nil})
			aAdd(aItens, aItem)
			oSql:skip()
		endDo

		oSql:close()

	endIf

return

/**
* Importa Arquivos de Inutilização
*/
static function impInutilizacao(oFile)

	local lOk  			:= .F.
	local cLinha 		:= oFile:readLine()
	local aDados 		:= separa(cLinha, ";")
	local cStInut		:= " "
	local cCodStatus	:= aDados[1]
	local cDescStatus	:= aDados[2]
	local cProtocolo	:= if(empty(aDados[10]), ' ', aDados[10])
	local cSerie    	:= aDados[11]
	local cNumDoc   	:= StrZero(Val(aDados[8]), getTamDoc(cSerie))
	local cWhereSZ5		:= "%SZ5.XFILIAL% AND Z5_DOC = '"+cNumDoc+"' AND Z5_SERIE = '"+cSerie+"' "
	local cObsLivro		:= GetMV("ZZ_TXTINUT")
	local cUpdSF3		:= ""
	local oSql			:= IpSqlObject():newIpSqlObject()
	local oSqlUtil		:= IpSqlObject():newIpSqlObject()

	if !oSql:exists("SZ5", cWhereSZ5)
		oLog:fail(LOG_MSG_FALHA, "Documento/Série não encontrado para Inutilização : "+cNumDoc+"/"+cSerie)
		return .F.
	endif

	if (cCodStatus == "102")
		if validInut(cNumDoc, cSerie)
			if inutilizaDoc(cNumDoc, cSerie, cCodStatus, cProtocolo)
				lOk 	:= .T.
				cStInut := INUTILIZACAO_HOMOLOGADA
			endIf
		else
			cUpdSF3 += "F3_CODRSEF = '"+cCodStatus+"', F3_CODNFE = '"+cProtocolo+"'"

			if !Empty(cObsLivro)
				cUpdSF3 += ", F3_OBSERV = '"+cObsLivro+"'"
			endIf
			oSqlUtil:update("SF3", cUpdSF3, "%SF3.XFILIAL% AND F3_NFISCAL = '"+cNumDoc+"' AND F3_SERIE = '"+cSerie+"'")

			lOk := .T.
			cStInut := INUTILIZACAO_HOMOLOGADA
		endif
	else
		lOk	    := .T.
		cStInut := INUTILIZACAO_NAO_HOMOLOGADA
	endIf

	if lOk
		oSql:update("SZ5", "Z5_NUPRNFE = '"+cProtocolo+"', Z5_DTRENFE = '"+DtoS(dDataBase)+"', "+;
			"Z5_DESTNFE = '"+cDescStatus+"', Z5_STATUS = '"+cStInut+"' ", cWhereSZ5)
	endIf

return lOk

/**
* Coleta o Tamanho do Número do Documento de acordo com a Serie
*/
static function getTamDoc(cSerie)

	local nTamDoc := Len(SF2->F2_DOC)
	local oSql    := IpSqlObject():newIpSqlObject()

	oSql:newTable("SX5", "X5_DESCRI DOCATUAL", "%SX5.XFILIAL% AND X5_TABELA = '01' AND X5_CHAVE = '"+cSerie+"'")

	if oSql:hasRecords()
		nTamDoc := oSql:getValue("Len(AllTrim(DOCATUAL))")
	endIf

	oSql:close()

return nTamDoc

/**
* Inutiliza um Documento
*/
static function inutilizaDoc(cNumDoc, cSerie, cCodStatus, cProtocolo)

	local lOk			:= .F.
	local nRecnoSF2		:= 0
	local aCab 			:= {}
	local aItem			:= {}
	local aItens		:= {}
	local oUtils		:= IpUtilsObject():newIpUtilsObject()
	local lInclusaoOk	:= .F.
	local lExclusaoOk	:= .F.
	local cIdDoc		:= AllTrim(cNumDoc)+"/"+AllTrim(cSerie)
	local cCliente		:= GetMV("ZZ_INUTCLI")
	local cLoja			:= GetMV("ZZ_INUTLOJ")
	local cProduto		:= GetMV("ZZ_INUTPRO")
	local cTes			:= GetMV("ZZ_INUTTES")
	local cObsLivro		:= GetMV("ZZ_TXTINUT")
	local oSql			:= IpSqlObject():newIpSqlObject()

	nModulo	:= 34
	private lMsErroAuto	:= .F.
	private lMsHelpAuto := .T.

	begin transaction

		aAdd(aCab, {"F2_TIPO", PadR( "N", TamSx3("F2_TIPO")[1] ), nil})
		aAdd(aCab, {"F2_FORMUL", Space(1), nil})
		aAdd(aCab, {"F2_DOC", PadR( cNumDoc, TamSx3("F2_DOC")[1] ), nil})
		aAdd(aCab, {"F2_SERIE",PadR( cSerie, TamSx3("F2_SERIE")[1] ) , nil})
		aAdd(aCab, {"F2_EMISSAO", dDataBase, nil})
		aAdd(aCab, {"F2_CLIENTE", PadR( cCliente, TamSx3("F2_CLIENTE")[1] ), nil})
		aAdd(aCab, {"F2_LOJA", cLoja, nil})
		aAdd(aCab, {"F2_ESPECIE", PadR( "SPED", TamSx3("F2_ESPECIE")[1] ), nil})
		aAdd(aCab, {"F2_COND", PadR( "001", TamSx3("F2_COND")[1] ), nil})
		aAdd(aCab, {"F2_DESCONT", 0, nil})
		aAdd(aCab, {"F2_FRETE", 0, nil})
		aAdd(aCab, {"F2_SEGURO", 0, nil})
		aAdd(aCab, {"F2_DESPESA", 0, nil})

		aAdd(aItem, {"D2_ITEM",PadR( "01", TamSx3("D2_ITEM")[1] ),nil})
		aAdd(aItem, {"D2_COD",PadR( cProduto, TamSx3("D2_COD")[1] ) , nil})
		aAdd(aItem, {"D2_QUANT", 1, nil})
		aAdd(aItem, {"D2_PRCVEN", 1, nil})
		aAdd(aItem, {"D2_TOTAL", 1, nil})
		aAdd(aItem, {"D2_TES", PadR( cTes, TamSx3("D2_TES")[1] ), nil})
		aAdd(aItens, aItem)

		MATA920(aCab, aItens)

		if lMsErroAuto
			oLog:fail(LOG_MSG_FALHA, "Não foi possível incluir a NF Manual: "+cIdDoc+CRLF+CRLF+oUtils:getErroAuto())
		else
			lInclusaoOk := .T.

			nRecnoSF2	:= oSql:getFieldValue("SF2", "R_E_C_N_O_", "%SF2.XFILIAL% AND F2_DOC = '"+cNumDoc+"' AND F2_SERIE = '"+cSerie+"'")
			SF2->(DbGoTo(nRecnoSF2))
			SD2->(DbSeek(xFilial("SD2") + SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
		endIf

		if lInclusaoOk

			MATA920(aCab, aItens, 5)

			if lMsErroAuto
				DisarmTransaction()
				oLog:fail(LOG_MSG_FALHA, "Não foi possível excluir a NF Manual: "+cIdDoc+CRLF+CRLF+oUtils:getErroAuto())
			else
				lExclusaoOk := .T.
			endIf

		endIf

	end transaction

	lMsHelpAuto := .F.
	lOk			:= (lInclusaoOk .and. lExclusaoOk)

	if lOk
		atualizaLivrosFiscais("SF2", nRecnoSF2, cCodStatus, cProtocolo, cObsLivro)
	endIf

return lOk

/**
* Coleta os Dados das Notas Fiscais de acordo com o tipo de arquivo
*/
static function getDadosNf(nTipo, oFile)

	local nRecno	:= 0
	local cAlias	:= ""
	local cFlag		:= ""
	local cStatus	:= ""
	local cChaveNfe := ""
	local cNfe		:= ""
	local cEmiNfe	:= ""
	local cHoraNfe	:= ""
	local cCodNfe	:= ""
	local cCpoAuto	:= ""
	local cLinha 	:= ""//oFile:readLine()
	local aDados 	:= {}//StrTokArr(cLinha, ";")
	local aNf	 	:= {}//Array(5)

	while oFile:notIsEof()
		cLinha += oFile:readLine()
		oFile:skipLine()
	end

	oFile:goTop()

	aDados 	:= separa(cLinha, ";")
	aNf	 	:= Array(10)

	if (Len(aDados) == 0)
		oLog:fail(LOG_MSG_FALHA, "Não foi possível ler os dados do arquivo")
		return {}
	endIf

	if (nTipo == INUTILIZACAO)
		return {}
	endIf

	cChaveNfe := Left(aDados[3], TM_CHAVE_NFE)
	cChvNfeNmArq := subst(oFile:cFile,at("RET_NFE_",oFile:cFile)+8,TM_CHAVE_NFE)
	//If at("RET_NFE_",oFile:cFile) > 0 .and. cChaveNfe <> cChvNfeNmArq
	//	cChaveNfe := cChvNfeNmArq
	//Endif
	cNovaChvNfe := cChaveNfe
	cFormaEmis := subst(cChaveNfe,35,1) //1=Normal

	nRecno := getRecnoNFe(cChaveNfe, DHL_NF_SAIDA,TM_CHAVE_NFE)

	if (nRecno > 0)
		cAlias 	:= "SF2"
		cFlag  	:= "F2_FIMP"
		cStatus	:= "F2_ZZDSNFE"
		cNfe	:= "F2_NFELETR"
		cEmiNfe	:= "F2_EMINFE"
		cHoraNfe:= "F2_HORNFE"
		cCodNfe	:= "F2_CODNFE"
		cCpoAuto:= "F2_ZZAUTO"

	else
		nRecno := getRecnoNFe(cChaveNfe, DHL_NF_ENTRADA,TM_CHAVE_NFE)
		if (nRecno > 0)
			cAlias 	:= "SF1"
			cFlag  	:= "F1_FIMP"
			cStatus	:= "F1_ZZDSNFE"
			cNfe	:= "F1_NFELETR"
			cEmiNfe	:= "F1_EMINFE"
			cHoraNfe:= "F1_HORNFE"
			cCodNfe	:= "F1_CODNFE"
			cCpoAuto:= "F1_ZZAUTO"

		endIf
	endIf

//Elmo, em 23/fev/23: Verificação de NF em Contigência - INÍCIO

	if cFormaEmis<>"1" .AND.  (nRecno <= 0)
		//Nova chave de busca: trocando o 6 (contingência) por 1 (normal) e ignorando último dígito (que varia)
		cNovaChvNfe := left(cChaveNfe,34) + "1" + left(right(cChaveNfe,9),8)
		nRecno := getRecnoNFe(cNovaChvNfe, DHL_NF_SAIDA,TM_CHAVE_NFE-1)
		cAlias 	:= "SF2"
		cFlag  	:= "F2_FIMP"
		cStatus	:= "F2_ZZDSNFE"
		cNfe	:= "F2_NFELETR"
		cEmiNfe	:= "F2_EMINFE"
		cHoraNfe:= "F2_HORNFE"
		cCodNfe	:= "F2_CODNFE"
		cCpoAuto:= "F2_ZZAUTO"

		if (nRecno <= 0)
			nRecno := getRecnoNFe(cNovaChvNfe, DHL_NF_ENTRADA,TM_CHAVE_NFE-1)
			cAlias 	:= "SF1"
			cFlag  	:= "F1_FIMP"
			cStatus	:= "F1_ZZDSNFE"
			cNfe	:= "F1_NFELETR"
			cEmiNfe	:= "F1_EMINFE"
			cHoraNfe:= "F1_HORNFE"
			cCodNfe	:= "F1_CODNFE"
			cCpoAuto:= "F1_ZZAUTO"

		endIf

		//Trocando _CHVNFE na tabela SF1/SF2
		If nRecno > 0
			atualizaChvNFE(cAlias, nRecno, cChaveNfe)

		Endif
	endIf
//Elmo, em 23/fev/23: Verificação de NF em Contigência - FINAL

	if (nRecno > 0)
		aNf[NF_ALIAS]  	 	:= cAlias
		aNf[NF_RECNO]  	 	:= nRecno
		aNf[NF_FLAG_IMP] 	:= cFlag
		aNf[NF_DESC_STATUS]	:= cStatus
		aNf[NF_NFE]			:= cNfe
		aNf[NF_EMISSSAO]	:= cEmiNfe
		aNf[NF_HORA]		:= cHoraNfe
		aNf[NF_PROTOCOLO]	:= cCodNfe
		aNf[NF_DADOS]		:= aDados
		aNf[NF_AUTO]		:= cCpoAuto
	else
		aNf := {}
		oLog:fail(LOG_MSG_FALHA, "Chave da NFe não encontrada: "+cChaveNfe)
	endIf

return aNf

/**
* Coleta o Recno de uma NF a partir da Chave da NFe
*/
static function getRecnoNFe(cChaveNfe, nTipoNf,nTamChvNfe)

	local nRecno := 0
	//Elmo, em 23/fev/23: Verificação de NF em Contigência - INÍCIO
	//Elmo, em 02/03/2023: acrescentado parâemtro nTamChvNfe para melhorar busca da NF
	//local cTmChv := AllTrim(Str(TM_CHAVE_NFE))
	local cTmChv := AllTrim(Str(nTamChvNfe))

	local oSql   := IpSqlObject():newIpSqlObject()

	if (nTipoNf == DHL_NF_SAIDA)
		oSql:newTable("SF2", "R_E_C_N_O_ RECNO", "F2_FILIAL = '"+xFilial("SF2")+"' AND SubStr(F2_CHVNFE, 1, "+cTmChv+") = '"+cChaveNfe+"'")
	elseIf (nTipoNf == DHL_NF_ENTRADA)
		//oSql:newTable("SF1", "R_E_C_N_O_ RECNO", "F1_FILIAL = '"+xFilial("SF1")+"' AND SubStr(F1_CHVNFE, 1, "+cTmChv+") = '"+cChaveNfe+"'")
		oSql:newTable("SF1", "R_E_C_N_O_ RECNO", "F1_FILIAL = '"+xFilial("SF1")+"' AND F1_ESPECIE = 'SPED' AND SubStr(F1_CHVNFE, 1, "+cTmChv+") = '"+cChaveNfe+"'") //Emerson Holanda 14/10/22 - Inclusao da validação da Especie
	endIf

	if oSql:hasRecords()
		nRecno := oSql:getValue("RECNO")
	endIf

	oSql:close()

return nRecno


/**
* Envia as interfaces de Invoice Confirmation e ASN DLX
*/
static function sendInterfaces(cTable,nRecno,cTransaction,lRunInv)

	local cFields := ""
	local cCodFil := ""
	local cDoc    := ""
	local cSerie  := ""
	local cCliFor := ""
	local cLoja   := ""
	local cTipo   := ""
	local cTpNF	  := ""
	local cFormP  := ""
	local oSql    := IpSqlObject():newIpSqlObject()

	if 	(FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. ;
		(FWUnitBusiness() == DHL_BUSINESSUNIT_REP) .or. ;
		(FWUnitBusiness() == DHL_BUSINESSUNIT_DIS) .or. ;
		(FWUnitBusiness() == DHL_BUSINESSUNIT_AGE) .or. ;
		(FWUnitBusiness() == DHL_BUSINESSUNIT_AGL) .or. ;
		(FWUnitBusiness() == DHL_BUSINESSUNIT_MUL) .or. ;
		(FWUnitBusiness() == DHL_BUSINESSUNIT_AG2) .or. ;
		(FWUnitBusiness() == DHL_BUSINESSUNIT_SPL) .or. ;
		(FWUnitBusiness() == DHL_BUSINESSUNIT_DI2)

		if cTable == "SF1"
			cFields := "F1_FILIAL FILIAL,F1_DOC DOC,F1_SERIE SERIE,F1_FORNECE CLIFOR,F1_LOJA LOJA,F1_ESPECIE ESPECIE,F1_TIPO TIPO,F1_FORMUL FORMP"
		elseif cTable == "SF2"
			if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
				cFields := "F2_FILIAL FILIAL,F2_DOC DOC,F2_SERIE SERIE,F2_CLIENTE CLIFOR,F2_LOJA LOJA,F2_ESPECIE ESPECIE,F2_TIPO TIPO, F2_ZZTPNF TPNF"
			else
				cFields := "F2_FILIAL FILIAL,F2_DOC DOC,F2_SERIE SERIE,F2_CLIENTE CLIFOR,F2_LOJA LOJA,F2_ESPECIE ESPECIE,F2_TIPO TIPO"
			endif
		endif

		oSql:newAlias("SELECT " + cFields + " FROM %" + cTable + ".SQLNAME% WHERE R_E_C_N_O_ = " + AllTrim(Str(nRecno)))

		cCodFil := oSql:getValue("FILIAL")
		cDoc    := oSql:getValue("DOC")
		cSerie  := oSql:getValue("SERIE")
		cCliFor := oSql:getValue("CLIFOR")
		cLoja   := oSql:getValue("LOJA")
		cTipo   := oSql:getValue("TIPO")
		if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2 .And. cTable = "SF2"
			cTpNF	:= oSql:getValue("TPNF")
		endif

		if FWUnitBusiness() == DHL_BUSINESSUNIT_AGL .And. cTable = "SF1"
			cFormP := oSql:getValue("FORMP") //não gerar ASN Gen para cenários de depositantes não contribuintes do ICMS
		endif

		oSql:close()

		if lRunInv
			if FWUnitBusiness() == DHL_BUSINESSUNIT_REP .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_AGL .and. isRepair(cTable,cCliFor,cLoja,cTipo))
				u_DlxInvConf(cDoc,cSerie,cCliFor,cLoja,cTipo)
			elseif FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
				If UnidNegCliFor(cCliFor,cLoja,iif(cTable = "SF2","C","F"))=="REV" //Elmo, em 26/09/22
				Else  //Elmo, em 26/09/22
					u_DisInvConf(cDoc,cSerie,cCliFor,cLoja,cTipo)
				Endif  //Elmo, em 26/09/22
			elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AGE
				u_AgeInvConf(cDoc,cSerie,cCliFor,cLoja,cTipo)
			elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AGL
				if cFormP != "S"
					u_AglInvConf(cDoc,cSerie,cCliFor,cLoja,cTipo)
				endif
			elseif FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
				u_MulInvConf(cDoc,cSerie,cCliFor,cLoja,cTipo)
			elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
				if cTpNF != REMESSA_CONTA_ORDEM
					u_Ag2InvConf(cDoc,cSerie,cCliFor,cLoja,cTipo)
					If cTpNF == RETORNO_EFETIVO
						u_Ag2GeIP180(cDoc,cSerie,cCliFor,cLoja,cTipo)
					EndIf
				endif
			elseif FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
				u_SPLInvConf(cDoc,cSerie,cCliFor,cLoja,cTipo)
			elseif FWUnitBusiness() == DHL_BUSINESSUNIT_DI2
				u_Di2InvConf(cDoc,cSerie,cCliFor,cLoja,cTipo)
			else
				u_InvConfirmation(cDoc,cSerie,cCliFor,cLoja,cTipo)
			endif
		endif

		if (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_MUL)
			u_ASNDLXGenerate(cDoc,cSerie,cCliFor,cLoja,cTransaction,cTipo)
		endif
	endif

return

/**
* Atualização dos Livros Fiscais de uma NF
*/
static function atualizaLivrosFiscais(cAlias, nRecno, cCodStatus, cProtocolo, cObsLivro, dDataCanc, cDatComple)

	local cFields	:= ""
	local cUpdSF3   := ""
	local cWhereSF3 := ""
	local cUpdSFT   := ""
	local cWhereSFT := ""
	local cCodFil   := ""
	local cDoc      := ""
	local cSerie    := ""
	local cCliFor   := ""
	local cLoja     := ""
	local cEspecie  := ""
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local lAtuSFT	:= .f.

	default cDatComple :=  ""

	if (cAlias == "SF1")
		cFields := "F1_FILIAL FILIAL, F1_DOC DOC, F1_SERIE SERIE, F1_FORNECE CLIFOR, F1_LOJA LOJA, F1_ESPECIE ESPECIE"
	elseIf (cAlias == "SF2")
		cFields := "F2_FILIAL FILIAL, F2_DOC DOC, F2_SERIE SERIE, F2_CLIENTE CLIFOR, F2_LOJA LOJA, F2_ESPECIE ESPECIE"
	endIf

	oSql:newAlias("SELECT "+cFields+" FROM %"+cAlias+".SQLNAME% WHERE R_E_C_N_O_ = "+AllTrim(Str(nRecno)))

	cCodFil  := oSql:getValue("FILIAL")
	cDoc     := oSql:getValue("DOC")
	cSerie   := oSql:getValue("SERIE")
	cCliFor  := oSql:getValue("CLIFOR")
	cLoja    := oSql:getValue("LOJA")
	cEspecie := oSql:getValue("ESPECIE")

	oSql:close()

	cUpdSF3 += "F3_CODRSEF = '"+cCodStatus+"', F3_CODNFE = '"+cProtocolo+"'"

	if !empty(cDatComple)
		cUpdSF3 += ", F3_EMINFE = '" + SubStr(cDatComple,1,4)+SubStr(cDatComple,6,2)+SubStr(cDatComple,9,2) + "' "
		cUpdSF3 += ", F3_HORNFE = '" + Substr(cDatComple,at(" ",cDatComple)+1,8) + "' "

		lAtuSFT := .t.
	endif

	if !Empty(cObsLivro)
		cUpdSF3 += ", F3_OBSERV = '"+cObsLivro+"'"
	endIf
	if !Empty(dDataCanc)
		cUpdSF3 += ", F3_DTCANC = '"+DtoS(dDataCanc)+"'"
	endIf

	cWhereSF3 += "F3_FILIAL = '"+cCodFil+"' AND F3_NFISCAL = '"+cDoc+"' AND F3_SERIE = '"+cSerie+"' AND "
	cWhereSF3 += "F3_CLIEFOR = '"+cCliFor+"' AND F3_LOJA = '"+cLoja+"' AND F3_ESPECIE = '"+cEspecie+"' AND "
	if (cAlias == "SF1")
		cWhereSF3 += " F3_CFO < 5000 "
	elseIf (cAlias == "SF2")
		cWhereSF3 += " F3_CFO >= 5000 "
	endIf

	oSql:update("SF3", cUpdSF3, cWhereSF3)

	if lAtuSFT
		cUpdSFT += " FT_CODNFE = '"+cProtocolo+"' "
		cUpdSFT += ", FT_EMINFE = '" + SubStr(cDatComple,1,4)+SubStr(cDatComple,6,2)+SubStr(cDatComple,9,2) + "' "
		cUpdSFT += ", FT_HORNFE = '" + Substr(cDatComple,at(" ",cDatComple)+1,8) + "' "

		cWhereSFT += "FT_FILIAL = '"+cCodFil+"' AND FT_NFISCAL = '"+cDoc+"' AND FT_SERIE = '"+cSerie+"' AND "
		cWhereSFT += "FT_CLIEFOR = '"+cCliFor+"' AND FT_LOJA = '"+cLoja+"' AND FT_ESPECIE = '"+cEspecie+"' AND "
		if (cAlias == "SF1")
			cWhereSFT += " FT_CFOP < 5000 "
		elseIf (cAlias == "SF2")
			cWhereSFT += " FT_CFOP >= 5000 "
		endIf

		oSql:update("SFT", cUpdSFT, cWhereSFT)
	endif

return


/*
** Valida Inutilização
*/
static function validInut(cNumDoc, cSerie)
	local cEspec	:= "SPED"
	local cWhereSF3 := ""
	local lRet		:= .t.
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local cCfo		:= ""
	local cFormula	:= ""

	cWhereSF3 	+= "F3_FILIAL = '"+xFilial("SF3")+"' AND F3_NFISCAL = '"+cNumDoc+"' AND F3_SERIE = '"+padr(cSerie, TamSx3("F3_SERIE")[1],' ')+"' "
	oSqlUtil:newTable("SF3", "*", cWhereSF3)

	cCfo		:= oSqlUtil:getValue("F3_CFO")
	cEspecNF  	:= oSqlUtil:getValue("F3_ESPECIE")
	cFormula  	:= oSqlUtil:getValue("F3_FORMUL")

	If SubStr(cCfo,1,1) $ "1,2,3"
		If AllTrim(cEspecNF) == cEspec .and.  cFormula == 'S'
			lRet := .f.
		EndIf
	ElseIf SubStr(cCfo,1,1) $ "5,6,7"
		If AllTrim(cEspecNF) == cEspec
			lRet := .f.
		EndIf
	EndIf

return(lRet)


/*
** Função para envio de e-mail, notificando a rejeição da NF Automática
*/
static function fEnvEmail(cAlias)

	local oMail			:= DHLSndMail():Create()
	local cEmailFrom	:= alltrim(GetMv("MV_RELFROM"))
	local cEmailTo		:= GETMV("ZZ_MAILNFA")
	local cField		:= right(cAlias, 2)
	local cDescrResu 	:= ""
	local cDescrCompl 	:= ""
	local cMsg			:= ""

	cMsg += "<html><head>Rejeição Nota Fiscal Automática</head><body>"
	cMsg += "<br/>A Nota Fiscal de Emissão Automática: <br/>"
	cMsg += "Número: " + alltrim((cAlias)->&(cField+"_DOC")) + "<br/>"
	cMsg += "Série: " + alltrim((cAlias)->&(cField+"_SERIE")) + "<br/>"
	cMsg += "Data: " + dtoc((cAlias)->&(cField+"_EMISSAO")) + "<br/>"
	cMsg += "foi rejeitada pelo sefaz, favor verificar! "
	cMsg += "</body></html>"

	oMail:cFrom	 	:= cEmailFrom
	oMail:cTo		:= cEmailTo
	oMail:cSubject	:= "Rejeição Nota Fiscal Automática - Filial: "+xFilial("SF2")
	oMail:cBody		:= cMsg
	oMail:lSilence	:= .T.

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "[" + DToC(dDataBase) + " - " + Time() + "] - Envio de e-mail de  "+cEmailFrom, 0, 0, {})
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "[" + DToC(dDataBase) + " - " + Time() + "] - Para: " + cEmailTo, 0, 0, {})

	If oMail:Send()
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "[" + DToC(dDataBase) + " - " + Time() + "] - Enviado com sucesso.", 0, 0, {})
	Else
		cDescrResu	:= "E-mail"
		cDescrCompl	:= "Não foi possível enviar o e-mail para processo da Nota Fiscal: " +  alltrim((cAlias)->&(cField+"_DOC")) + "/" +;
			alltrim((cAlias)->&(cField+"_SERIE")) + " Data: " + dtoc((cAlias)->&(cField+"_EMISSAO"))
		oLog:start(APP_MASTERSAF_NFE, DHL_IMPORTACAO)
		oLog:fail(cDescrResumid,cDescrCompleta)
	EndIf

return

/*
** Processamento da Interface CTe
*/
static function sendIntCTE(cAlias)

	if cAlias == "SF1"
		cNota		:= SF1->F1_DOC
		cSerie		:= SF1->F1_SERIE
		cClieFor	:= SF1->F1_FORNECE
		cLoja		:= SF1->F1_LOJA
		cNotaOri	:= SF1->F1_NFORIG
		cSerieOri	:= SF1->F1_SERORIG
		cTipo		:= DHL_NFE_INVOICE_INFLOW
		cStatus		:= SF1->F1_FIMP
		cEspecie	:= SF1->F1_ESPECIE
	else
		cNota		:= SF2->F2_DOC
		cSerie		:= SF2->F2_SERIE
		cClieFor	:= SF2->F2_CLIENTE
		cLoja		:= SF2->F2_LOJA
		cNotaOri	:= SF2->F2_NFORI
		cSerieOri	:= SF2->F2_SERIORI
		cTipo		:= DHL_NFE_INVOICE_OUTFLOW
		cStatus		:= SF2->F2_FIMP
		cEspecie	:= SF2->F2_ESPECIE
	endif

	U_PrcXmlCte(cTipo, cSerie, cNota, cClieFor, cLoja, cNotaOri, cSerieOri)
return

/*
** Processamento da Interface Symbolic Return
*/
static function sendRSymb(cAlias)
	Local cFilialNF	:= ""
	Local cNota 	:= ""
	Local cSerie 	:= ""
	Local cClieFor 	:= ""
	Local cLoja 	:= ""
	Local cNotaOri 	:= ""
	Local cSerieOri := ""
	Local cTipo 	:= ""
	Local cStatus 	:= ""
	Local cEspecie 	:= ""
	Local cTipoNF	:= ""
	Local lRetSZARCO:= .F.

	if cAlias == "SF2"
		cFilialNF	:= SF2->F2_FILIAL
		cNota		:= SF2->F2_DOC
		cSerie		:= SF2->F2_SERIE
		cClieFor	:= SF2->F2_CLIENTE
		cLoja		:= SF2->F2_LOJA
		cNotaOri	:= SF2->F2_NFORI
		cSerieOri	:= SF2->F2_SERIORI
		cTipo		:= DHL_NFE_INVOICE_OUTFLOW
		cStatus		:= SF2->F2_FIMP
		cEspecie	:= SF2->F2_ESPECIE
		cTipoNF		:= SF2->F2_ZZTPNF
		if cTipoNF == RETORNO_SIMBOLICO
			lRetSZARCO := getSZARCO(cFilialNF,cNota,cSerie)
			if lRetSZARCO
				U_PrcXmlRSymb(cTipo, cSerie, cNota, cClieFor, cLoja, cNotaOri, cSerieOri)
			endif
		endif
	endif
	//U_PrcXmlCte(cTipo, cSerie, cNota, cClieFor, cLoja, cNotaOri, cSerieOri)
return

/**
* Coleta os dados para as Rotinas Automáticas de Exclusão
*/
static function getSZARCO(cFilialNF,cNota,cSerie)
	Local lRet			:= .F.
	Local oSql  		:= IpSqlObject():newIpSqlObject()
	Local cNFRCO		:= ""
	Local cSeriRCO		:= ""
	Local oLogIP050		:= DHLLogManager():newDHLLogManager()

	oLogIP050:start(APP_SAP, DHL_IMPORTACAO, cArqIP050)

	oSql:newTable("SZA", "ZA_NFRCO, ZA_SERIRCO",;
		"ZA_FILIAL = '"	+cFilialNF+	"' AND " + ;
		"ZA_NFRET = '"	+cNota+		"' AND "+;
		"ZA_SERIRET = '"+cSerie+	"' ")

	if oSql:notIsEof()
		cNFRCO := oSql:getValue("ZA_NFRCO")
		cSeriRCO := oSql:getValue("ZA_SERIRCO")
		oSql:close()
		if !Empty(cNFRCO)
			oSql	:= IpSqlObject():newIpSqlObject()
			oSql:newTable("SF2","F2_FIMP",;
				"F2_FILIAL = '"	+cFilialNF+	"' AND "+;
				"F2_DOC = '" 	+cNFRCO+	"' AND "+;
				"F2_SERIE = '" 	+cSeriRCO+	"' ")
			if oSql:getValue("F2_FIMP") == 'S' //NF APROVADA PELO SEFAZ VIA MASTERSAF
				lRet := .T.
				oLogIP050:success()
			else
				oLogIP050:fail(LOG_MSG_FALHA, "NF de Remessa por Conta e Ordem NF: "+ cNFRCO +;
					" Série: " + cSeriRCO + " referente a NF de Retorno Simbólico NF: "+ cNota +;
					" Série: "+ cSerie + ", não autorizada pelo Sefaz. Interface IP050 não foi gerada.")
			endif
		else
			lRet := .T.
			oLogIP050:success()
		endif
	else
		oLogIP050:fail(LOG_MSG_FALHA, "NF de Retorno Simbólico NF: "+ cNota +;
			" Série: "+ cSerie + ", não possui registro na SZA. Interface IP050 não foi gerada.")
	endif
return lRet

/*
** Processamento da Interface RCO - IP_140
*/
static function sendRCO(cAlias)
	Local cFilialNF	:= ""
	Local cNota 	:= ""
	Local cSerie 	:= ""
	Local cClieFor 	:= ""
	Local cLoja 	:= ""
	Local cNotaOri 	:= ""
	Local cSerieOri := ""
	Local cTipo 	:= ""
	Local cStatus 	:= ""
	Local cEspecie 	:= ""
	Local cTipoNF	:= ""

	if cAlias == "SF2"
		cFilialNF	:= SF2->F2_FILIAL
		cNota		:= SF2->F2_DOC
		cSerie		:= SF2->F2_SERIE
		cClieFor	:= SF2->F2_CLIENTE
		cLoja		:= SF2->F2_LOJA
		cNotaOri	:= SF2->F2_NFORI
		cSerieOri	:= SF2->F2_SERIORI
		cTipo		:= DHL_NFE_INVOICE_OUTFLOW
		cStatus		:= SF2->F2_FIMP
		cEspecie	:= SF2->F2_ESPECIE
		cTipoNF		:= SF2->F2_ZZTPNF
		if cTipoNF == REMESSA_CONTA_ORDEM
			if cStatus == "S"
				U_PrcRCOXml(cTipo, cSerie, cNota, cClieFor, cLoja, cNotaOri, cSerieOri)
			endif
		endif
	endif
return

/*
** Ordena os arquivos
*/
static function ordenaArquivos(cDirectory)

	local aInfArquivos	:= Directory(allTrim(cDirectory) +"*.txt", , , , 2)
	local nI			:= 0
	local aArquivos		:= {}

	for nI := 1 to len(aInfArquivos)
		aAdd(aArquivos, {allTrim(cDirectory) + allTrim(aInfArquivos[nI][1]), allTrim(aInfArquivos[nI][1])})
	next nI

return aArquivos


/**
* define a empresa/filial
**/
static function setCompany(aCompanies)

	local cCodEmp := "" 
	local cCodFil := "" 

	if !(Type("cEmpAnt") == "C")

		cCodEmp := aCompanies[1,1]
		cCodFil := aCompanies[1,2]

		oEnv:setCompany(cCodEmp)
		oEnv:setBranch(cCodFil)
		oEnv:load()
	endIf	

return

/**
* obtém os arquivos .PROCESSING e renomeia para o nome original. (SOmente os arquivos que não estão locados)
**/
static function renArqProcessing()

	local aInfArquivos	:= Directory(allTrim(cDirectory) +"*.PROCESSING", , , , 2) 
	local nI			:= 0
	local aArquivos		:= {}
	local cArquivo		:= ""
	local cNewNomArq	:= ""
	local nStatusRenom	:= -10

	for nI := 1 to len(aInfArquivos)
		cArquivo := allTrim(aInfArquivos[nI][1])

		if !isLocked(cArquivo)	
			cNewNomArq 		:= strTran(cArquivo, ".PROCESSING", "")
			nStatusRenom 	:= FRename( cDirectory + cArquivo, cDirectory + cNewNomArq, nil  )					
		endIf

	next nI

return

/**
* verifica se o arquivo esta lockado
**/
static function isLocked(cArquivo)

	local lIsLocked := .T.

	//SE CONSEGUIR LOCKAR, É PQ NÃO ESTA LOCKADO EM OUTRO PROCESSO
	if lockByname(upper(cArquivo), .F., .F.)
		lIsLocked := .F.
		unLockByName(upper(cArquivo), .F., .F.)		
	endIf

return lIsLocked

/**
* Verifica se o depositante é do tipo Reparador
**/
static function isRepair(cTable,cCliFor,cLoja,cTipo)
	
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local lRet	 	:= .f.
	
	if (cTable == "SF1" .and. AllTrim(cTipo) $ "D/B") .or. (cTable == "SF2" .and. !(AllTrim(cTipo) $ "D/B"))
		oSqlUtil:newTable("SA1", "A1_COD, A1_LOJA, A1_ZZREPAR", "A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '" + cCliFor + "' AND A1_LOJA = '" + cLoja + "' ")
		if oSqlUtil:hasRecords()
			if oSqlUtil:getValue("A1_ZZREPAR") == "S"
				lRet := .t.
			endIf
		endIf
	else
		oSqlUtil:newTable("SA2", "A2_COD, A2_LOJA, A2_ZZREPAR", "A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = '" + cCliFor + "' AND A2_LOJA = '" + cLoja + "' ")
		if oSqlUtil:hasRecords()
			if oSqlUtil:getValue("A2_ZZREPAR") == "S"
				lRet := .t.
			endIf
		endIf
	endIf
	oSqlUtil:close()
	
return lRet


/*
Função para identificação da Unidade de Negócio atendida pelo Cliente/Fornecedor

A2_ZZUNNEG - c - 3
A1_ZZUNNEG - c - 3

SPL,PKG,REP,DIS,AGE,MUL,AGL,AG2,REV

Autor: Elmo
*/

Static Function UnidNegCliFor(cCodigo,cLoja,cTipo) //cTipo="C" (Cliente) ou "F" (=Fornecedor)

	Local _aArea  := GetArea()

	If cTipo == "C"
		sa1->(dbSetOrder(1))
		sa1->(dbSeek(xFilial("SA1") + cCodigo + cLoja))
		cRet := sa1->A1_ZZUNNEG
	Else
		sa2->(dbSetOrder(1))
		sa2->(dbSeek(xFilial("SA2") + cCodigo + cLoja))
		cRet := sa2->A2_ZZUNNEG
	Endif

	RestArea(_aArea)

Return( cRet )


//Elmo, em 23/fev/23: Ajuste Chave NFe - INÍCIO
/**
* Atualização da Chave da NFE vinda do MasterSaf ( em contingência )

*/
static function atualizaChvNFE(cAlias, nRecno, cNewChaveNfe)

	local cFields	:= ""
	local cUpdSF3   := ""
	local cWhereSF3 := ""
	local cUpdSFT   := ""
	local cWhereSFT := ""
	local cUpdSF1   := ""
	local cWhereSF1 := ""
	local cCodFil   := ""
	local cDoc      := ""
	local cSerie    := ""
	local cCliFor   := ""
	local cLoja     := ""
	local cEspecie  := ""
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local lAtuSFT	:= .t.
	local lAtuSF3	:= .t.

	if (cAlias == "SF1")
		cFields := "F1_FILIAL FILIAL, F1_DOC DOC, F1_SERIE SERIE, F1_FORNECE CLIFOR, F1_LOJA LOJA, F1_ESPECIE ESPECIE"

		cUpdSF1 += "F1_CHVNFE = '"+cNewChaveNfe+"'"
		cWhereSF1+= "R_E_C_N_O_ = "+AllTrim(Str(nRecno))
		oSql:update("SF1", cUpdSF1, cWhereSF1)

	elseIf (cAlias == "SF2")
		cFields := "F2_FILIAL FILIAL, F2_DOC DOC, F2_SERIE SERIE, F2_CLIENTE CLIFOR, F2_LOJA LOJA, F2_ESPECIE ESPECIE"
		cUpdSF1 += "F2_CHVNFE = '"+cNewChaveNfe+"'"
		cWhereSF1+= "R_E_C_N_O_ = "+AllTrim(Str(nRecno))
		oSql:update("SF2", cUpdSF1, cWhereSF1)
	endIf

	oSql:newAlias("SELECT "+cFields+" FROM %"+cAlias+".SQLNAME% WHERE R_E_C_N_O_ = "+AllTrim(Str(nRecno)))

	cCodFil  := oSql:getValue("FILIAL")
	cDoc     := oSql:getValue("DOC")
	cSerie   := oSql:getValue("SERIE")
	cCliFor  := oSql:getValue("CLIFOR")
	cLoja    := oSql:getValue("LOJA")
	cEspecie := oSql:getValue("ESPECIE")

	oSql:close()

	If lAtuSF3
		cUpdSF3 += "F3_CHVNFE = '"+cNewChaveNfe+"'"

		cWhereSF3 += "F3_FILIAL = '"+cCodFil+"' AND F3_NFISCAL = '"+cDoc+"' AND F3_SERIE = '"+cSerie+"' AND "
		cWhereSF3 += "F3_CLIEFOR = '"+cCliFor+"' AND F3_LOJA = '"+cLoja+"' AND F3_ESPECIE = '"+cEspecie+"' AND "
		if (cAlias == "SF1")
			cWhereSF3 += " F3_CFO < 5000 "
		elseIf (cAlias == "SF2")
			cWhereSF3 += " F3_CFO >= 5000 "
		endIf

		oSql:update("SF3", cUpdSF3, cWhereSF3)
	Endif

	if lAtuSFT
		cUpdSFT += " FT_CHVNFE = '"+cNewChaveNfe+"' "

		cWhereSFT += "FT_FILIAL = '"+cCodFil+"' AND FT_NFISCAL = '"+cDoc+"' AND FT_SERIE = '"+cSerie+"' AND "
		cWhereSFT += "FT_CLIEFOR = '"+cCliFor+"' AND FT_LOJA = '"+cLoja+"' AND FT_ESPECIE = '"+cEspecie+"' AND "
		if (cAlias == "SF1")
			cWhereSFT += " FT_CFOP < 5000 "
		elseIf (cAlias == "SF2")
			cWhereSFT += " FT_CFOP >= 5000 "
		endIf

		oSql:update("SFT", cUpdSFT, cWhereSFT)
	endif

return

//Elmo, em 23/fev/23: Ajuste Chave NFe - FINAL
