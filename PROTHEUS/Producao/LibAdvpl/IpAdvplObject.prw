#include "protheus.ch"
#include "rwmake.ch"

#Define LIBADVPL_CODE 	"000000A2FA"	

/*/{Protheus.doc} IpLibAdvpl
 
Função para verificar se a LibADVPL está no RPO e sua versão
	
@type function
@author Carlos Eduardo Niemeyer Rodrigues
@since 15/09/2016
@version 1.05
/*/
User Function IpLibAdvpl()
	Local oIpAdvplObject := IpAdvplObject():newIpAdvplObject()
	
Return oIpAdvplObject:getVersion()
 
/*/{Protheus.doc} IpAdvplObject
 
Objeto pai de todos os objetos da LibAdvpl Totvs IP
	
@type class
@author Victor Hugo
@since 11/11/2013
/*/
class IpAdvplObject

	data cVersion
	
	method newIpAdvplObject() constructor
	
	method getVersion()
	method isInJob()
	
endClass


/*/{Protheus.doc} newIpAdvplObject

Construtor

@type method
@author Victor Hugo
@since 11/11/2013
/*/
method newIpAdvplObject() class IpAdvplObject
	
	::cVersion := "1.05"
	
	checkIpLicense(@Self)
	
return	


/*/{Protheus.doc} getVersion

Coleta a versão da lib de componentes. Para maiores detalhes sobre cada versão consulte a planilha libadvpl-versions.xlsx

@type method
@author Victor Hugo
@since 11/11/2013

@return String Versão da LibAdvpl
/*/
method getVersion() class IpAdvplObject
return ::cVersion

/*/{Protheus.doc} isInJob

Indica se O Protheus está sendo executado em Job (sem interface visual)

@type method	
@author Victor Hugo
@since 19/08/2014

@return Logico Execução em Job
/*/
method isInJob() class IpAdvplObject
return (Type("oMainWnd") != "O")

/*
	Verifica a Licença de Uso para a LIB
*/
Static Function checkIpLicense(oIpAdvplObject)
	Local oIPLicense 					:= Nil
	Local nSequenceArtifact				:= 0
	Local cCodeArtifact					:= LIBADVPL_CODE
	Local cNameArtifact					:= ""
	Local lOnlyTestCompany				:= .F.
	Local lNoCheckLicenseInTestCompany	:= AlwaysTrue() //Possibilitará usar em Empresa Teste sem Licenciamento - Nunca poderá ser Falso no Campo da LIB - IPLicense depende disso	
	Local cMsg							:= ""
	Local cMsgError						:= ""
	Local lForceLicenseFile				:= .F.	
	Local lRet							:= .F.
	
	/*
	If IsInCallStack("u_IpLibADVPL")
		lRet := .T.
		Return
	Endif	

	If ExistBlock("IPLicense")
		oIPLicense 	:= IPLicense():newIPLicense()
		oIPLicense:setLimitCheck(100)
		If oIPLicense:setInternalLicense( nSequenceArtifact , cCodeArtifact , cNameArtifact, lOnlyTestCompany, lNoCheckLicenseInTestCompany)
			If oIPLicense:checkLicense(@cMsgError,lForceLicenseFile)
				lRet := .T.
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
		
	If !lRet
		cMsg += " A conexão será encerrada."
		If IsBlind() .Or. oIpAdvplObject:IsInJob()
			showLogInConsole(cMsg)
		Else		
			MsgStop(cMsg,"TOTVS IP")		
			u_IPLicenseView(oIPLicense)
		Endif
		Break
	Else
		If !Empty(cMsg)
			showLogInConsole(cMsg)
		Endif
	Endif
	*/
Return

/*
	Apresenta a Mensagem no Console do Protheus
*/
Static Function showLogInConsole(cMessage,lActive,cPrefixe)
	Local lIsInJob		:= (Type("oMainWnd") != "O")
	
	Default lActive		:= .T.
	Default cMessage 	:= ""
	Default cPrefixe	:= "[LIBADVPL][" + DtoC(DDATABASE) + "][" + Time() + "] "
	
	If !( lIsInJob ) .And. lActive == Nil
		lActive	:= GetNewPar("ZZ_LOGS",.T.)
	Endif
	
	If lActive
		FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", cPrefixe + OEMToAnsi(cMessage), 0, 0, {})
	Endif

Return
