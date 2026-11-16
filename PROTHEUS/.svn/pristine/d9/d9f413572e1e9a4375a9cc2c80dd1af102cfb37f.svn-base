#include "protheus.ch"
#include "safx04.ch"
#include "safx.ch"
#include "dhl.ch"


/*/{Protheus.doc} DHLSafx04

Respons‡vel pelas regras e montagem das informacoes para a exportacao
	
@author Daniel Braga
@since 30/10/2014

/*/
user function _Safx04;return

class DHLSafx04 
	
	 data  cAlias  as String
	 data  cPrefAlias as string
	 data  oDHLLib as Object
	 data  nLayout as Integer
	 data  dZzMsDw as date
	 
	 data  cIND_FIS_JUR as String
	 data  cCOD_FIS_JUR as String
	 data  cDATA_X04 as String
	 data  cIND_CONTEM_COD as String
	 data  cRAZAO_SOCIAL as String
	 data  cCPF_CGC as String
	 data  cCOD_ATIVIDADE as String
	 data  cINSC_ESTADUAL as String
	 data  cINSC_MUNICIPAL as String
	 data  cINSC_SUFRAMA as String
	 data  cNOME_FANTASIA as String
	 data  cENDERECO as String
	 data  cNUM_ENDERECO as String
	 data  cCOMPL_ENDERECO as String
	 data  cBAIRRO as String
	 data  cCIDADE as String
	 data  cDISTRITO as String
	 data  cSUB_DISTRITO as String
	 data  cUF as String
	 data  cCEP as String
	 data  cCOD_PAIS as String
	 data  cDDD as String
	 data  cTELEFONE as String
	 data  cFAX as String
	 data  cCOD_MUNICIPIO as String
	 data  cIND_CLASSE_PFJ as String
	 data  cIND_EMP_CLASSE as String
	 data  cIND_PFJ_CONTRIB as String
	 data  cCODIGO_CONTABIL as String
	 data  cCEI as String
	 data  cIND_CLIENTE_SID as String
	 data  cCPF_CNPJ_INV as String
	 data  cIND_SCP as String
	 data  cCOD_CBO as String
	 data  cPIS_PASEP as String
	 data  cCATEGORIA_TRAB as String
	 data  cOCORRENCIA_TRAB as String
	 data  cCX_POSTAL as String
	 data  cNUM_CEP_CX_POSTAL as String
	 data  cE_MAIL as String
	 data  cIND_FOME_ZERO as String
	 data  cTP_LOGRADOURO as String
	 data  cIND_SIMPLES_NAC as String
	 data  cTP_BAIRRO as String
	 data  cDATA_NASC_AUTONOMO as String
	 data  cIMP_RENDA_DEPEND as String
	 data  cSAL_FAMILIA_DEPEND as String
	 data  cCOD_FUNCAO_AUTONOMO as String
	 data  cIND_INCENTIVO_CULTURAL as String
	 data  cIND_CLIENTE_LIVRE as String
	 data  cPASSAPORTE as String
	 data  cDATA_MOLESTIA as String
	 data  cNUM_ID_FISCAL as String
	 data  cTP_FONTE_PAGADORA as String
	 data  cDSC_PROVINCIA_EX as String
	 data  cNUM_ALVARA as String
	 data  cCOD_INSTAL_ANP as String
	 data  cNUM_CR as String

	 method newDHLSafx04(nLayout) constructor 
	
	 method setIND_FIS_JUR(cIND_FIS_JUR)
	 method setCOD_FIS_JUR(cCOD_FIS_JUR)
	 method setDATA_X04(cDATA_X04)
	 method setIND_CONTEM_COD(cIND_CONTEM_COD)
	 method setRAZAO_SOCIAL(cRAZAO_SOCIAL)
	 method setCPF_CGC(cCPF_CGC)
	 method setCOD_ATIVIDADE(cCOD_ATIVIDADE)
	 method setINSC_ESTADUAL(cINSC_ESTADUAL)
	 method setINSC_MUNICIPAL(cINSC_MUNICIPAL)
	 method setINSC_SUFRAMA(cINSC_SUFRAMA)
	 method setNOME_FANTASIA(cNOME_FANTASIA)
	 method setENDERECO(cENDERECO)
	 method setNUM_ENDERECO(cNUM_ENDERECO)
	 method setCOMPL_ENDERECO(cCOMPL_ENDERECO)
	 method setBAIRRO(cBAIRRO)
	 method setCIDADE(cCIDADE)
	 method setDISTRITO(cDISTRITO)
	 method setSUB_DISTRITO(cSUB_DISTRITO)
	 method setUF(cUF)
	 method setCEP(cCEP)
	 method setCOD_PAIS(cCOD_PAIS)
	 method setDDD(cDDD)
	 method setTELEFONE(cTELEFONE)
	 method setFAX(cFAX)
	 method setCOD_MUNICIPIO(cCOD_MUNICIPIO)
	 method setIND_CLASSE_PFJ(cIND_CLASSE_PFJ)
	 method setIND_EMP_CLASSE(cIND_EMP_CLASSE)
	 method setIND_PFJ_CONTRIB(cIND_PFJ_CONTRIB)
	 method setCODIGO_CONTABIL(cCODIGO_CONTABIL)
	 method setCEI(cCEI)
	 method setIND_CLIENTE_SID(cIND_CLIENTE_SID)
	 method setCPF_CNPJ_INV(cCPF_CNPJ_INV)
	 method setIND_SCP(cIND_SCP)
	 method setCOD_CBO(cCOD_CBO)
	 method setPIS_PASEP(cPIS_PASEP)
	 method setCATEGORIA_TRAB(cCATEGORIA_TRAB)
	 method setOCORRENCIA_TRAB(cOCORRENCIA_TRAB)
	 method setCX_POSTAL(cCX_POSTAL)
	 method setNUM_CEP_CX_POSTAL(cNUM_CEP_CX_POSTAL)
	 method setE_MAIL(cE_MAIL)
	 method setIND_FOME_ZERO(cIND_FOME_ZERO)
	 method setTP_LOGRADOURO(cTP_LOGRADOURO)
	 method setIND_SIMPLES_NAC(cIND_SIMPLES_NAC)
	 method setTP_BAIRRO(cTP_BAIRRO)
	 method setDATA_NASC_AUTONOMO(cDATA_NASC_AUTONOMO)
	 method setIMP_RENDA_DEPEND(cIMP_RENDA_DEPEND)
	 method setSAL_FAMILIA_DEPEND(cSAL_FAMILIA_DEPEND)
	 method setCOD_FUNCAO_AUTONOMO(cCOD_FUNCAO_AUTONOMO)
	 method setIND_INCENTIVO_CULTURAL(cIND_INCENTIVO_CULTURAL)
	 method setIND_LIVRE_CLIENTE(cIND_CLIENTE_LIVRE)
	 method setPASSAPORTE(cPASSAPORTE)
	 method setDATA_MOLESTIA(cDATA_MOLESTIA)
	 method setNUM_ID_FISCAL(cNUM_ID_FISCAL)
	 method setTP_FONTE_PAGADORA(cTP_FONTE_PAGADORA)
	 method setDSC_PROVINCIA_EX(cDSC_PROVINCIA_EX)
	 method setNUM_ALVARA(cNUM_ALVARA)
	 method setCOD_INSTAL_ANP(cCOD_INSTAL_ANP)
	 method setNUM_CR(cNUM_CR)
	 method setAlias(cAlias)
	 method setZzMsDw(dZzMsDw)
	 
	 method getIND_FIS_JUR()
	 method getCOD_FIS_JUR()
	 method getDATA_X04()
	 method getIND_CONTEM_COD()
	 method getRAZAO_SOCIAL()
	 method getCPF_CGC()
	 method getCOD_ATIVIDADE()
	 method getINSC_ESTADUAL()
	 method getINSC_MUNICIPAL()
	 method getINSC_SUFRAMA()
	 method getNOME_FANTASIA()
	 method getENDERECO()
	 method getNUM_ENDERECO()
	 method getCOMPL_ENDERECO()
	 method getBAIRRO()
	 method getCIDADE()
	 method getDISTRITO()
	 method getSUB_DISTRITO()
	 method getUF()
	 method getCEP()
	 method getCOD_PAIS()
	 method getDDD()
	 method getTELEFONE()
	 method getFAX()
	 method getCOD_MUNICIPIO()
	 method getIND_CLASSE_PFJ()
	 method getIND_EMP_CLASSE()
	 method getIND_PFJ_CONTRIB()
	 method getCODIGO_CONTABIL()
	 method getCEI()
	 method getIND_CLIENTE_SID()
	 method getCPF_CNPJ_INV()
	 method getIND_SCP()
	 method getCOD_CBO()
	 method getPIS_PASEP()
	 method getCATEGORIA_TRAB()
	 method getOCORRENCIA_TRAB()
	 method getCX_POSTAL()
	 method getNUM_CEP_CX_POSTAL()
	 method getE_MAIL()
	 method getIND_FOME_ZERO()
	 method getTP_LOGRADOURO()
	 method getIND_SIMPLES_NAC()
	 method getTP_BAIRRO()
	 method getDATA_NASC_AUTONOMO()
	 method getIMP_RENDA_DEPEND()
	 method getSAL_FAMILIA_DEPEND()
	 method getCOD_FUNCAO_AUTONOMO()
	 method getIND_INCENTIVO_CULTURAL()
	 method getIND_LIVRE_CLIENTE()
	 method getPASSAPORTE()
	 method getDATA_MOLESTIA()
	 method getNUM_ID_FISCAL()
	 method getTP_FONTE_PAGADORA()
	 method getDSC_PROVINCIA_EX()
	 method getNUM_ALVARA()
	 method getCOD_INSTAL_ANP()
	 method getNUM_CR()
	 method getAlias()
	 method getZzMsDw()
	
	 method initialize()
	 method getFieldValue(cField)
	 method validateRequired()
	 method salveDateExp()
	 method validateExport()
	 method notRequiredField()
	 method getTableName()
	 method isBlocked()
	 
endclass


method newDHLSafx04(nLayout) class DHLSafx04	
	
	::oDHLLib := DHLLibrary():newDHLLibrary()
	::nLayout := nLayout
	
	if ::nLayout == SAFX04_FORNECEDORES
		::cAlias :="SA2"
	elseIf ::nLayout == SAFX04_CLIENTES
		::cAlias := "SA1"
	else
		::cAlias := "SA4" 
	endIf	
	
	if !Empty(::cAlias)
		::cPrefAlias := PrefixoCpo( ::cAlias )
	endIf
return

method initialize() class DHLSafx04
		
	local oDHLLib := DHLLibrary():newDHLLibrary()	
		
	::setIND_FIS_JUR(::getFieldValue("ZZINDDW"))
	::setCOD_FIS_JUR( alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())) + ::getFieldValue("COD") + ::getFieldValue("LOJA"))	
    ::setDATA_X04(::oDHLLib:getLGDate(::getFieldValue("USERLGI"), .T.))
    ::setIND_CONTEM_COD("1")
    ::setRAZAO_SOCIAL(::getFieldValue("NOME"))
    ::setCPF_CGC( ::getFieldValue("CGC") )
    ::setINSC_ESTADUAL( ::getFieldValue("INSCR") )
    ::setINSC_MUNICIPAL( ::getFieldValue("INSCRM") )
    ::setINSC_SUFRAMA( ::getFieldValue("SUFRAMA") )
    ::setNOME_FANTASIA( ::getFieldValue("NREDUZ") )
    ::setENDERECO( oDHLLib:getAddress("street", ::getFieldValue("END")) )
    ::setNUM_ENDERECO( oDHLLib:getAddress("number", ::getFieldValue("END")) )
    ::setCOMPL_ENDERECO( ::getFieldValue("COMPLEM") )
    ::setBAIRRO( ::getFieldValue("BAIRRO") )
    ::setCIDADE( ::getFieldValue("MUN"))
    ::setUF( ::getFieldValue("EST") )
    ::setCEP(::getFieldValue("CEP") )
    ::setCOD_PAIS( ::getFieldValue("PAIS") )
    ::setDDD( ::getFieldValue("DDD") )
    ::setTELEFONE( ::getFieldValue("TEL") )
    ::setFAX( ::getFieldValue("FAX") )
    ::setCOD_MUNICIPIO( ::getFieldValue("COD_MUN") )
    ::setIND_CLASSE_PFJ( ::getFieldValue("ZZCLPFJ") )
    ::setIND_CLASSE_EMP( ::getFieldValue("TPJ") )
    ::setIND_PFJ_CONTRIB( getPfjContrib(::getFieldValue("CONTRIB"), Self) )
    ::setCODIGO_CONTABIL( ::getFieldValue("CONTA") )
    ::setIND_CLIENTE_SID( Iif( len(::getFieldValue("CGC")) == 11 ,"S","N") )
    ::setCX_POSTAL( Iif(::cAlias == "SA1", ::getFieldValue("CXPOSTA"),::getFieldValue("POST") )  )
    ::setE_MAIL( ::getFieldValue("EMAIL") )
    ::setIND_FOME_ZERO( ::getFieldValue("FOMEZER") )
    ::setIND_SIMPLES_NAC( ::getFieldValue("SIMPNAC") )
    ::setZzMsDw( ::getFieldValue("ZZMSDW") )
        
return 

/**
 * Coleta o Valor do Campo PFJ Contrib.
 */
static function getPfjContrib(cContrib, oSelf)
	
	local cRet := ""
	
	if (oSelf:cAlias == "SA1")
		if (oSelf:getFieldValue("PESSOA") == 'F') .AND. (cContrib == "1")
			cRet := "S"
		endif	
	endIf
	
return cRet

/*/{Protheus.doc} getFieldValue

(Descricao da Funcao, Classe ou Metodo)
	
@author Daniel Braga
@since 31/10/2014

@param cField, String, Campo ‡ ser retornado

@return todos valor do campos
/*/
method getFieldValue(cField)  class DHLSafx04
	local xValue := nil
	local nPosField := 0
	
	if FieldPos(::cPrefAlias+"_"+cField) == 0
		xValue := ""
	endIf
	
	nPosField := (::cAlias)->(FieldPos(::cPrefAlias+"_"+cField))
	if nPosField > 0
		xValue := (::cAlias)->(FieldGet(nPosField))
	endIf
		
return xValue

/*/{Protheus.doc} validateRequired

Validacao dos campos obrigatorios para o layout SAFX04
	
@author Daniel Braga
@since 31/10/2014

@return Boolean resultado da validacao
/*/
method validateRequired() class DHLSafx04

	local cError := ""
	
	if Empty( ::getIND_FIS_JUR() )
		 cError += SAFX04_ERROR_IND_FIS_JUR + CRLF
	endIf 
	
	if Empty( ::getCOD_FIS_JUR() )	
		cError += SAFX04_ERROR_COD_FIS_JUR + CRLF
	endIf
	
	if Empty( ::getIND_CONTEM_COD() )	
		cError += SAFX04_ERROR_IND_CONTEM_COD + CRLF
	endIf
	
	if Empty( ::getRAZAO_SOCIAL() )	
		cError += SAFX04_ERROR_RAZAO_SOCIAL + CRLF
	endIf
	
	if Empty( ::getCPF_CGC() )	
		cError += SAFX04_ERROR_CPF_CGC + CRLF
	endIf
    
    if !Empty(cError)
    	cError += CRLF
    	if (::cAlias $ "SA1,SA2")
    		cError += "Codigo/Loja: "+AllTrim(::getFieldValue("COD"))+"/"+::getFieldValue("LOJA") 
    	else
    		cError += "Codigo: "+::getFieldValue("COD")	
    	endIf	
    endIf
    
return cError

/*/{Protheus.doc} salveDateExp

altualiza o campo de marcacaoo da exportacao do registro
	
@author Daniel Braga
@since 31/10/2014

/*/
method salveDateExp() class DHLSafx04

	local nFieldPos := (::cAlias)->( FieldPos(::cPrefAlias+"_ZZMSDW") )
	
	(::cAlias)->(recLock(::cAlias,.f.))
	(::cAlias)->( FieldPut(nFieldPos, date() ) )
	(::cAlias)->(msUnLock())

return

/*/{Protheus.doc} validateExport

Valida ‡ linha a se exportada
	
@author Daniel Braga
@since 31/10/2014

/*/
method validateExport() class DHLSafx04
	
	local lExport := .T.
	local oAdvpl  := IpAdvplObject():newIpAdvplObject()
	
	if (::getFieldValue("FILIAL") != xFilial(::cAlias))
		return .F.
	endIf
	
	if oAdvpl:isInJob()
		lExport := ( Empty(::getZzMsDw() ) ) .or.( ::getZzMsDw() < ::getDATA_X04() )	
	endIf
	
return lExport


/*/{Protheus.doc} notRequiredField

Campos do layout que não são obrigatorios
	
@author Daniel Braga
@since 03/11/2014

/*/
method notRequiredField(oFile) class DHLSafx04
	
	oFile:addField(COD_ATIVIDADE			, '')
	oFile:addField(DISTRITO 				, '')
	oFile:addField(SUB_DISTRITO 			, '')
	oFile:addField(CEI 						, '')
	oFile:addField(CPF_CNPJ_INV				, '') 		
	oFile:addField(IND_SCP					, '') 			
	oFile:addField(COD_CBO					, '') 			
	oFile:addField(PIS_PASEP					, '') 			
	oFile:addField(CATEGORIA_TRAB			, '') 		
	oFile:addField(OCORRENCIA_TRAB			, '') 	
	oFile:addField(NUM_CEP_CX_POSTAL     	, '')
	oFile:addField(TP_LOGRADOURO         	, '')
	oFile:addField(TP_BAIRRO 				, '')
	oFile:addField(DATA_NASC_AUTONOMO 		, '')
	oFile:addField(IMP_RENDA_DEPEND 		, '')
	oFile:addField(SAL_FAMILIA_DEPEND 		, '')
	oFile:addField(COD_FUNCAO_AUTONOMO 	, '')
	oFile:addField(IND_INCENTIVO_CULTURAL	, '')
	oFile:addField(IND_CLIENTE_LIVRE 		, '')
	oFile:addField(PASSAPORTE 				, '')
	oFile:addField(DATA_MOLESTIA 			, '')
	oFile:addField(NUM_ID_FISCAL 			, '')
	oFile:addField(TP_FONTE_PAGADORA 		, '')
	oFile:addField(DSC_PROVINCIA_EX 		, '')
	oFile:addField(NUM_ALVARA 				, '')
	oFile:addField(COD_INSTAL_ANP 			, '')
	oFile:addField(NUM_CR 					, '')
	
return

/*/{Protheus.doc} getTableName

Coleta a Descrição da Tabela da Interface
	
@author Victor Hugo
@since 10/12/2014

@return String Descrição da Tabela da Interface
/*/
method getTableName() class DHLSafx04
	
	local cName := ""
	
	if (::cAlias == "SA1")
		cName := "Clientes"
	elseIf (::cAlias == "SA2")
		cName := "Fornecedores"
	elseIf (::cAlias == "SA4")
		cName := "Transportadoras"
	endIf
	
return cName

/*/{Protheus.doc} isBlocked

(Descricao da Funcao, Classe ou Metodo)
	
@author Daniel Braga
@since 31/10/2014

@param cField, String, Campo ‡ ser retornado

@return todos valor do campos
/*/
method isBlocked()  class DHLSafx04
	local nPosField := 0
	local xRet		:= .f.
	local nPosField := 0
	
	nPosField := (::cAlias)->(FieldPos(::cPrefAlias+"_MSBLQL"))
	
	if (::cAlias)->(FieldGet(nPosField)) == SAFX04_CLIENTE_BLOQUEADO
		xRet		:= .t.
	else
		xRet		:= .f.
	endif
		
return xRet


method getIND_FIS_JUR() class DHLSafx04
return ::cIND_FIS_JUR

method getCOD_FIS_JUR() class DHLSafx04
return ::cCOD_FIS_JUR

method getDATA_X04() class DHLSafx04
return ::cDATA_X04

method getIND_CONTEM_COD() class DHLSafx04
return ::cIND_CONTEM_COD

method getRAZAO_SOCIAL() class DHLSafx04
return ::cRAZAO_SOCIAL

method getCPF_CGC() class DHLSafx04
return ::cCPF_CGC

method getCOD_ATIVIDADE() class DHLSafx04
return ::cCOD_ATIVIDADE

method getINSC_ESTADUAL() class DHLSafx04
return ::cINSC_ESTADUAL

method getINSC_MUNICIPAL() class DHLSafx04
return ::cINSC_MUNICIPAL

method getINSC_SUFRAMA() class DHLSafx04
return ::cINSC_SUFRAMA

method getNOME_FANTASIA() class DHLSafx04
return ::cNOME_FANTASIA

method getENDERECO() class DHLSafx04
return ::cENDERECO

method getNUM_ENDERECO() class DHLSafx04
return ::cNUM_ENDERECO

method getCOMPL_ENDERECO() class DHLSafx04
return ::cCOMPL_ENDERECO

method getBAIRRO() class DHLSafx04
return ::cBAIRRO

method getCIDADE() class DHLSafx04
return ::cCIDADE

method getDISTRITO() class DHLSafx04
return ::cDISTRITO

method getSUB_DISTRITO() class DHLSafx04
return ::cSUB_DISTRITO

method getUF() class DHLSafx04
return ::cUF

method getCEP() class DHLSafx04
return ::cCEP

method getCOD_PAIS() class DHLSafx04
return ::cCOD_PAIS

method getDDD() class DHLSafx04
return ::cDDD

method getTELEFONE() class DHLSafx04
return ::cTELEFONE

method getFAX() class DHLSafx04
return ::cFAX

method getCOD_MUNICIPIO() class DHLSafx04
return ::cCOD_MUNICIPIO

method getIND_CLASSE_PFJ() class DHLSafx04
return ::cIND_CLASSE_PFJ

method getIND_EMP_CLASSE() class DHLSafx04
return ::cIND_EMP_CLASSE

method getIND_PFJ_CONTRIB() class DHLSafx04
return ::cIND_PFJ_CONTRIB

method getCODIGO_CONTABIL() class DHLSafx04
return ::cCODIGO_CONTABIL

method getCEI() class DHLSafx04
return ::cCEI

method getIND_CLIENTE_SID() class DHLSafx04
return ::cIND_CLIENTE_SID

method getCPF_CNPJ_INV() class DHLSafx04
return ::cCPF_CNPJ_INV

method getIND_SCP() class DHLSafx04
return ::cIND_SCP

method getCOD_CBO() class DHLSafx04
return ::cCOD_CBO

method getPIS_PASEP() class DHLSafx04
return ::cPIS_PASEP

method getCATEGORIA_TRAB() class DHLSafx04
return ::cCATEGORIA_TRAB

method getOCORRENCIA_TRAB() class DHLSafx04
return ::cOCORRENCIA_TRAB

method getCX_POSTAL() class DHLSafx04
return ::cCX_POSTAL

method getNUM_CEP_CX_POSTAL() class DHLSafx04
return ::cNUM_CEP_CX_POSTAL

method getE_MAIL() class DHLSafx04
return ::cE_MAIL

method getIND_FOME_ZERO() class DHLSafx04
return ::cIND_FOME_ZERO

method getTP_LOGRADOURO() class DHLSafx04
return ::cTP_LOGRADOURO

method getIND_SIMPLES_NAC() class DHLSafx04
return ::cIND_SIMPLES_NAC

method getTP_BAIRRO() class DHLSafx04
return ::cTP_BAIRRO

method getDATA_NASC_AUTONOMO() class DHLSafx04
return ::cDATA_NASC_AUTONOMO

method getIMP_RENDA_DEPEND() class DHLSafx04
return ::cIMP_RENDA_DEPEND

method getSAL_FAMILIA_DEPEND() class DHLSafx04
return ::cSAL_FAMILIA_DEPEND

method getCOD_FUNCAO_AUTONOMO() class DHLSafx04
return ::cCOD_FUNCAO_AUTONOMO

method getIND_INCENTIVO_CULTURAL() class DHLSafx04
return ::cIND_INCENTIVO_CULTURAL

method getIND_CLIENTE_LIVRE() class DHLSafx04
return ::cIND_CLIENTE_LIVRE

method getPASSAPORTE() class DHLSafx04
return ::cPASSAPORTE

method getDATA_MOLESTIA() class DHLSafx04
return ::cDATA_MOLESTIA

method getNUM_ID_FISCAL() class DHLSafx04
return ::cNUM_ID_FISCAL

method getTP_FONTE_PAGADORA() class DHLSafx04
return ::cTP_FONTE_PAGADORA

method getDSC_PROVINCIA_EX() class DHLSafx04
return ::cDSC_PROVINCIA_EX

method getNUM_ALVARA() class DHLSafx04
return ::cNUM_ALVARA

method getCOD_INSTAL_ANP() class DHLSafx04
return ::cCOD_INSTAL_ANP

method getNUM_CR() class DHLSafx04
return ::cNUM_CR

method getAlias() class DHLSafx04
return ::cAlias

method getZzMsDw() class DHLSafx04
return ::dZzMsDw

method setIND_FIS_JUR(cIND_FIS_JUR) class DHLSafx04
    ::cIND_FIS_JUR:=cIND_FIS_JUR
return

method setCOD_FIS_JUR(cCOD_FIS_JUR) class DHLSafx04
    ::cCOD_FIS_JUR:=cCOD_FIS_JUR
return

method setDATA_X04(cDATA_X04) class DHLSafx04
    ::cDATA_X04:=cDATA_X04
return

method setIND_CONTEM_COD(cIND_CONTEM_COD) class DHLSafx04
    ::cIND_CONTEM_COD:=cIND_CONTEM_COD
return

method setRAZAO_SOCIAL(cRAZAO_SOCIAL) class DHLSafx04
    ::cRAZAO_SOCIAL:=cRAZAO_SOCIAL
return

method setCPF_CGC(cCPF_CGC) class DHLSafx04
    ::cCPF_CGC:=cCPF_CGC
return

method setCOD_ATIVIDADE(cCOD_ATIVIDADE) class DHLSafx04
    ::cCOD_ATIVIDADE:=cCOD_ATIVIDADE
return

method setINSC_ESTADUAL(cINSC_ESTADUAL) class DHLSafx04
    ::cINSC_ESTADUAL:=cINSC_ESTADUAL
return

method setINSC_MUNICIPAL(cINSC_MUNICIPAL) class DHLSafx04
    ::cINSC_MUNICIPAL:=cINSC_MUNICIPAL
return

method setINSC_SUFRAMA(cINSC_SUFRAMA) class DHLSafx04
    ::cINSC_SUFRAMA:=cINSC_SUFRAMA
return

method setNOME_FANTASIA(cNOME_FANTASIA) class DHLSafx04
    ::cNOME_FANTASIA:=cNOME_FANTASIA
return

method setENDERECO(cENDERECO) class DHLSafx04
    ::cENDERECO:=cENDERECO
return

method setNUM_ENDERECO(cNUM_ENDERECO) class DHLSafx04
    ::cNUM_ENDERECO:=cNUM_ENDERECO
return

method setCOMPL_ENDERECO(cCOMPL_ENDERECO) class DHLSafx04
    ::cCOMPL_ENDERECO:=cCOMPL_ENDERECO
return

method setBAIRRO(cBAIRRO) class DHLSafx04
    ::cBAIRRO:=cBAIRRO
return

method setCIDADE(cCIDADE) class DHLSafx04
    ::cCIDADE:=cCIDADE
return

method setDISTRITO(cDISTRITO) class DHLSafx04
    ::cDISTRITO:=cDISTRITO
return

method setSUB_DISTRITO(cSUB_DISTRITO) class DHLSafx04
    ::cSUB_DISTRITO:=cSUB_DISTRITO
return

method setUF(cUF) class DHLSafx04
    ::cUF:=cUF
return

method setCEP(cCEP) class DHLSafx04
    ::cCEP:=cCEP
return

method setCOD_PAIS(cCOD_PAIS) class DHLSafx04
    ::cCOD_PAIS:=cCOD_PAIS
return

method setDDD(cDDD) class DHLSafx04  
	if (Val(cDDD) > 0)
    	::cDDD:=cDDD  
    else
    	::cDDD := "" 
    endIf	
return

method setTELEFONE(cTELEFONE) class DHLSafx04
    ::cTELEFONE:=cTELEFONE
return

method setFAX(cFAX) class DHLSafx04
    ::cFAX:=cFAX
return

method setCOD_MUNICIPIO(cCOD_MUNICIPIO) class DHLSafx04
    ::cCOD_MUNICIPIO:=cCOD_MUNICIPIO
return

method setIND_CLASSE_PFJ(cIND_CLASSE_PFJ) class DHLSafx04
    ::cIND_CLASSE_PFJ:=cIND_CLASSE_PFJ
return

method setIND_CLASSE_EMP(cIND_EMP_CLASSE) class DHLSafx04
    ::cIND_EMP_CLASSE:=cIND_EMP_CLASSE
return

method setIND_PFJ_CONTRIB(cIND_PFJ_CONTRIB) class DHLSafx04
    ::cIND_PFJ_CONTRIB:=cIND_PFJ_CONTRIB
return

method setCODIGO_CONTABIL(cCODIGO_CONTABIL) class DHLSafx04
    ::cCODIGO_CONTABIL:=cCODIGO_CONTABIL
return

method setCEI(cCEI) class DHLSafx04
    ::cCEI:=cCEI
return

method setIND_CLIENTE_SID(cIND_CLIENTE_SID) class DHLSafx04
    ::cIND_CLIENTE_SID:=cIND_CLIENTE_SID
return

method setCPF_CNPJ_INV(cCPF_CNPJ_INV) class DHLSafx04
    ::cCPF_CNPJ_INV:=cCPF_CNPJ_INV
return

method setIND_SCP(cIND_SCP) class DHLSafx04
    ::cIND_SCP:=cIND_SCP
return

method setCOD_CBO(cCOD_CBO) class DHLSafx04
    ::cCOD_CBO:=cCOD_CBO
return

method setPIS_PASEP(cPIS_PASEP) class DHLSafx04
    ::cPIS_PASEP:=cPIS_PASEP
return

method setCATEGORIA_TRAB(cCATEGORIA_TRAB) class DHLSafx04
    ::cCATEGORIA_TRAB:=cCATEGORIA_TRAB
return

method setOCORRENCIA_TRAB(cOCORRENCIA_TRAB) class DHLSafx04
    ::cOCORRENCIA_TRAB:=cOCORRENCIA_TRAB
return

method setCX_POSTAL(cCX_POSTAL) class DHLSafx04
    ::cCX_POSTAL:=cCX_POSTAL
return

method setNUM_CEP_CX_POSTAL(cNUM_CEP_CX_POSTAL) class DHLSafx04
    ::cNUM_CEP_CX_POSTAL:=cNUM_CEP_CX_POSTAL
return

method setE_MAIL(cE_MAIL) class DHLSafx04
    ::cE_MAIL:=cE_MAIL
return

method setIND_FOME_ZERO(cIND_FOME_ZERO) class DHLSafx04
    ::cIND_FOME_ZERO:=cIND_FOME_ZERO
return

method setTP_LOGRADOURO(cTP_LOGRADOURO) class DHLSafx04
    ::cTP_LOGRADOURO:=cTP_LOGRADOURO
return

method setIND_SIMPLES_NAC(cIND_SIMPLES_NAC) class DHLSafx04
    ::cIND_SIMPLES_NAC:=cIND_SIMPLES_NAC
return

method setTP_BAIRRO(cTP_BAIRRO) class DHLSafx04
    ::cTP_BAIRRO:=cTP_BAIRRO
return

method setDATA_NASC_AUTONOMO(cDATA_NASC_AUTONOMO) class DHLSafx04
    ::cDATA_NASC_AUTONOMO:=cDATA_NASC_AUTONOMO
return

method setIMP_RENDA_DEPEND(cIMP_RENDA_DEPEND) class DHLSafx04
    ::cIMP_RENDA_DEPEND:=cIMP_RENDA_DEPEND
return

method setSAL_FAMILIA_DEPEND(cSAL_FAMILIA_DEPEND) class DHLSafx04
    ::cSAL_FAMILIA_DEPEND:=cSAL_FAMILIA_DEPEND
return

method setCOD_FUNCAO_AUTONOMO(cCOD_FUNCAO_AUTONOMO) class DHLSafx04
    ::cCOD_FUNCAO_AUTONOMO:=cCOD_FUNCAO_AUTONOMO
return

method setIND_INCENTIVO_CULTURAL(cIND_INCENTIVO_CULTURAL) class DHLSafx04
    ::cIND_INCENTIVO_CULTURAL:=cIND_INCENTIVO_CULTURAL
return

method setIND_CLIENTE_LIVRE(cIND_CLIENTE_LIVRE) class DHLSafx04
    ::cIND_CLIENTE_LIVRE:=cIND_CLIENTE_LIVRE
return

method setPASSAPORTE(cPASSAPORTE) class DHLSafx04
    ::cPASSAPORTE:=cPASSAPORTE
return

method setDATA_MOLESTIA(cDATA_MOLESTIA) class DHLSafx04
    ::cDATA_MOLESTIA:=cDATA_MOLESTIA
return

method setNUM_ID_FISCAL(cNUM_ID_FISCAL) class DHLSafx04
    ::cNUM_ID_FISCAL:=cNUM_ID_FISCAL
return

method setTP_FONTE_PAGADORA(cTP_FONTE_PAGADORA) class DHLSafx04
    ::cTP_FONTE_PAGADORA:=cTP_FONTE_PAGADORA
return

method setDSC_PROVINCIA_EX(cDSC_PROVINCIA_EX) class DHLSafx04
    ::cDSC_PROVINCIA_EX:=cDSC_PROVINCIA_EX
return

method setNUM_ALVARA(cNUM_ALVARA) class DHLSafx04
    ::cNUM_ALVARA:=cNUM_ALVARA
return

method setCOD_INSTAL_ANP(cCOD_INSTAL_ANP) class DHLSafx04
    ::cCOD_INSTAL_ANP:=cCOD_INSTAL_ANP
return

method setNUM_CR(cNUM_CR) class DHLSafx04
    ::cNUM_CR:=cNUM_CR
return

method setAlias(cAlias) class DHLSafx04
	::cAlias := cAlias
return 

method setZzMsDw(dZzMsDw) class DHLSafx04
	::dZzMsDw := dZzMsDw
return	 

