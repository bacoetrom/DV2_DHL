#include "protheus.ch"
#include "dhl.ch"


/*/{Protheus.doc} GQREENTR

Ponto de entrada no final da geracao da NF Entrada, utilizado para gravacao de dados adicionais.

@author Thiago Meschiatti
@since 30/10/2014

/*/
User Function GQREENTR()
	
	local oTMsg  := FswTemplMsg():newTemplMsg("E",SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,"SZZ")
	local oDevRev:= nil
	
	// inicio template mensagens da NF
	If SF1->F1_FORMUL == "S"
		aAdd(oTMsg:aCampos,{"F1_VOLUME1",CriaVar("F1_VOLUME1")})
		aAdd(oTMsg:aCampos,{"F1_ESPECI1",CriaVar("F1_ESPECI1")})
		aAdd(oTMsg:aCampos,{"F1_PESOL"  ,CriaVar("F1_PESOL"  )})
		aAdd(oTMsg:aCampos,{"F1_PBRUTO",CriaVar("F1_PBRUTO")})
		aAdd(oTMsg:aCampos,{"F1_TRANSP",CriaVar("F1_TRANSP")})
		aAdd(oTMsg:aCampos,{"F1_PLACA",CriaVar("F1_PLACA")})
		aAdd(oTMsg:aCampos,{"F1_ZZMARCA",CriaVar("F1_ZZMARCA")})
		
		if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
			if SF1->F1_ZZAUTO <> 'S' .and. SF1->F1_SERIE <> 'DEV'
				oTMsg:Processa()
				if SF1->F1_TIPO == 'D'
					oDevRev := DHLDisDevRec():newDHLDisDevRec()
					oDevRev:updStatus(DHL_DOC_PENDENTE_ACAO)
				endif
			endif
		else
			if !isBlind()
				oTMsg:Processa()
			else
				if FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
					fGravaMsg()
				endIf
			endIf
		endif
		///////////////////////////////////////////////////////////
		//| Autor | Denis Dias | Data 08/06/2018
		//| Efetua a coompatibilização da NFe 4.0
		///////////////////////////////////////////////////////////
		//u_pPrNFe40()
	Endif
	// fim template mensagens da NF
	
Return

/*
** Grava informaÃ§Ã£o na tabela de template Mensagens NF (SZZ)
*/
static function fGravaMsg()	
	local oIPDHL210 := DHLIp210():newDHLIp210()	
	oIPDHL210:GravMensagem()	
return