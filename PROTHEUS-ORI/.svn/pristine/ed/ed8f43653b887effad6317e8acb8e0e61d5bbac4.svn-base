#include 'protheus.ch'
#include "safx04.ch"
#include "safx.ch"
#include "dhl.ch"
   
   
/*/{Protheus.doc} SAFX04MSDW

Responsa‡vel por gerar o arquivo SAFX04
	
@author Daniel Braga
@since 30/10/2014
/*/
user function SAFX04MSDW(aCompany)
	
	local oFile 		:= nil
	local oDhlSafx		:= DhlSafx():newDhlSafx()	
	private lGerouArqs	:= .F.
	
	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf
	
	oFile := MsafDWFile():newMsafDWFile("04", SAFX04_POSICOES)
		
	SAFX04(SAFX04_CLIENTES, @oFile)   
	
	SAFX04(SAFX04_FORNECEDORES, @oFile)
	
	oFile:renameArq("04", SAFX04_POSICOES)
	oFile:close()
	
return lGerouArqs

/**
 * Processa a Geracao dos Arquivos
 */
static function SAFX04(nLayout,oFile)

	local oDhlSafx04 := DhlSafx04():newDhlSafx04(nLayout) 
	local cAlias 	 := oDhlSafx04:getAlias()
	local oLog 		 := DHLLogManager():newDHLLogManager()
	local cError	 := ""
	local aArea		 := {}
	local nCount	 := 0	
	default  oFile 	:= nil
	
	DbSelectArea(cAlias)
	(cAlias)->(DbSetOrder(1))
	nCount := (cAlias)->(RecCount())
	(cAlias)->( DbGoTop() )
	
	while (cAlias)->(!eof()) 		
	
		if !(oDhlSafx04:isBlocked())
		
			oDhlSafx04:initialize()
			
			if !oDhlSafx04:validateExport()
				(cAlias)->(dbSkip())	
				loop
			endIf
			
			cError := oDhlSafx04:validateRequired() 
			if !Empty( cError )	
				oLog:start(APP_MASTERSAF_DW, DHL_EXPORTACAO, oFile:getFile())
				oLog:fail(SAFX04_ERROR_TITLE, cError)
				DbSelectArea(cAlias)			
				(cAlias)->(dbSkip())	
				loop
			endIf	
		
			oFile:addField(IND_FIS_JUR				, oDhlSafx04:getIND_FIS_JUR() )
			oFile:addField(COD_FIS_JUR				, oDhlSafx04:getCOD_FIS_JUR())
			oFile:addField(DATA_X04					, oDhlSafx04:getDATA_X04())
			oFile:addField(IND_CONTEM_COD			, oDhlSafx04:getIND_CONTEM_COD())
			oFile:addField(RAZAO_SOCIAL				, oDhlSafx04:getRAZAO_SOCIAL())
			oFile:addField(CPF_CGC					, oDhlSafx04:getCPF_CGC())
			oFile:addField(COD_ATIVIDADE			, oDhlSafx04:getCOD_ATIVIDADE())
			oFile:addField(INSC_ESTADUAL			, oDhlSafx04:getINSC_ESTADUAL())
			oFile:addField(INSC_MUNICIPAL			, oDhlSafx04:getINSC_MUNICIPAL())
			oFile:addField(INSC_SUFRAMA				, oDhlSafx04:getINSC_SUFRAMA())
			oFile:addField(NOME_FANTASIA			, oDhlSafx04:getNOME_FANTASIA())
			oFile:addField(ENDERECO					, oDhlSafx04:getENDERECO())
			oFile:addField(NUM_ENDERECO				, oDhlSafx04:getNUM_ENDERECO())
			oFile:addField(COMPL_ENDERECO			, oDhlSafx04:getCOMPL_ENDERECO())
			oFile:addField(BAIRRO					, oDhlSafx04:getBAIRRO())
			oFile:addField(CIDADE					, oDhlSafx04:getCIDADE())
			oFile:addField(UF						, oDhlSafx04:getUF())
			oFile:addField(CEP						, oDhlSafx04:getCEP())
			oFile:addField(COD_PAIS					, oDhlSafx04:getCOD_PAIS())
			oFile:addField(DDD						, oDhlSafx04:getDDD())
			oFile:addField(TELEFONE					, oDhlSafx04:getTELEFONE())
			oFile:addField(FAX						, oDhlSafx04:getFAX())
			oFile:addField(COD_MUNICIPIO			, oDhlSafx04:getCOD_MUNICIPIO())
			oFile:addField(IND_CLASSE_PFJ			, oDhlSafx04:getIND_CLASSE_PFJ())
			oFile:addField(IND_CLASSE_EMP			, oDhlSafx04:getIND_EMP_CLASSE())
			oFile:addField(IND_PFJ_CONTRIB			, oDhlSafx04:getIND_PFJ_CONTRIB())
			oFile:addField(CODIGO_CONTABIL			, oDhlSafx04:getCODIGO_CONTABIL())
			oFile:addField(IND_CLIENTE_SID			, oDhlSafx04:getIND_CLIENTE_SID())
			oFile:addField(CX_POSTAL				, oDhlSafx04:getCX_POSTAL())
			oFile:addField(E_MAIL					, oDhlSafx04:getE_MAIL())
			oFile:addField(IND_FOME_ZERO			, oDhlSafx04:getIND_FOME_ZERO())
			oFile:addField(IND_SIMPLES_NAC			, oDhlSafx04:getIND_SIMPLES_NAC())
			
			oDhlSafx04:notRequiredField(oFile) 
			
			if oFile:write()
				lGerouArqs := .T.
			else
				oLog:start(APP_MASTERSAF_DW, DHL_EXPORTACAO,oFile:getFile())
				oLog:fail(SAFX04_ERROR_TITLE, ERROR_QTD_CAMPOS)
				(cAlias)->( DbSkip() )
				loop
			endIf
			
			oDhlSafx04:salveDateExp()	
		endif	
		
		(cAlias)->( DbSkip() )
	endDo
	
return	
