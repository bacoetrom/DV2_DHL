#Include 'Protheus.ch'
#Include 'dhl.ch'

#define NF_ALIAS					1
#define NF_RECNO					2
#define NF_FLAG_IMP					3
#define NF_DESC_STATUS				4
#define NF_NFE						5	
#define NF_EMISSSAO					6	
#define NF_HORA						7
#define NF_PROTOCOLO				8
#define NF_DADOS					9

/*/{Protheus.doc} PrcConti

Processa contigência
	
@author Thiago Meschiatti
@since /10/2014

/*/
User Function PrcConti(nTipoMov, nOpc, nRecnoSF)
	local oSql		:= IpSqlObject():newIpSqlObject()
	local aNf		:= Array(9)	
	local aLinArq	:= {}
	local cDataAux	:= ""
	local cAlias	:= ""
	local cFlag		:= ""
	local cStatus	:= ""
	local cNfe		:= ""
	local cEmiNfe	:= ""
	local cHoraNfe	:= ""
	local cCodNfe	:= ""
	local cMsg		:= ""
	private oLog	:= DHLLogManager():newDHLLogManager()
	
	if nOpc == DHL_OPC_INCLUSAO
		cDataAux	:= stuff(dtos(dDataBase), 5, 0, '-')
		cDataAux	:= stuff(cDataAux, 8, 0, '-')
		aLinArq 	:= {"100","Autorizado o uso da NF-e",,,,,,,,,,," ",cDataAux + " " + Time()}
	elseif nOpc == DHL_OPC_EXCLUSAO
		cDataAux	:= stuff(dtos(dDataBase), 5, 0, '-')
		cDataAux	:= stuff(cDataAux, 8, 0, '-')
		aLinArq 	:= {"101","Cancelamento de NF-e homologado",,,," ",cDataAux + " " + Time()}
	endif
	
	if nTipoMov == DHL_NF_SAIDA
		cAlias 	:= "SF2"
		cFlag  	:= "F2_FIMP"
		cStatus	:= "F2_ZZDSNFE"
		cNfe	:= "F2_NFELETR"	
		cEmiNfe	:= "F2_EMINFE"	
		cHoraNfe:= "F2_HORNFE"	
		cCodNfe	:= "F2_CODNFE"
	elseif nTipoMov == DHL_NF_ENTRADA
		cAlias 	:= "SF1"
		cFlag  	:= "F1_FIMP"
		cStatus	:= "F1_ZZDSNFE"
		cNfe	:= "F1_NFELETR"	
		cEmiNfe	:= "F1_EMINFE"	
		cHoraNfe:= "F1_HORNFE"	
		cCodNfe	:= "F1_CODNFE"
	endif
		
	aNf[NF_ALIAS]  	 	:= cAlias      
	aNf[NF_RECNO]  	 	:= nRecnoSF
	aNf[NF_FLAG_IMP] 	:= cFlag 
	aNf[NF_DESC_STATUS]	:= cStatus
	aNf[NF_NFE]			:= cNfe
	aNf[NF_EMISSSAO]	:= cEmiNfe
	aNf[NF_HORA]		:= cHoraNfe
	aNf[NF_PROTOCOLO]	:= cCodNfe
	aNf[NF_DADOS]		:= aLinArq
	
	if nOpc == DHL_OPC_INCLUSAO
		&("StaticCall(ImpMsaNfe,impAutorizacao,aNf)")
		oSql:newAlias("SELECT " + right(cAlias,2) + "_DOC, "+ right(cAlias,2) + "_SERIE FROM %" + cAlias + ".SQLNAME% WHERE R_E_C_N_O_ = " + AllTrim(Str(nRecnoSF)))
		cMsg	:= oSql:getValue(right(cAlias,2) + "_DOC") + "/" + oSql:getValue(right(cAlias,2) + "_SERIE")
		oSql:close()
	elseif nOpc == DHL_OPC_EXCLUSAO
		&("StaticCall(ImpMsaNfe,impCancelamento,aNf)")
	endif
	
	if !empty(cMsg)
		Aviso("Atenção!","Documento "+cMsg+" emitido em MODELO DE CONTINGÊNCIA!",{"OK"})
	endif

Return

/*
**
*/
static function prcSaiCont(nOpc, nRecnoSF2)
	
 return
