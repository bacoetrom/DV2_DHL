#include 'totvs.ch'
#include 'dhl.ch'

#define SECONDS 1
#define MINUTE 	2
#define HOUR 	3
#define LOG_MSG_FALHA "Falha ao gerar interface Item Maintenance."

User Function DHLAgeItemMaint()
Return

/*/{Protheus.doc} DHLAgeItemMaint

Responsável em pegar as informações da SB1
	
@author Gustavo Luiz
@since 18/08/2016
/*/
CLASS DHLAgeItemMaint
	
	Data cWareHouse		As String
	Data cDateTime		As String
	Data cPartNameFrom 	As String
	Data cPartNameTo	As String
	Data cSiteCnpj		As String
	Data cItem			As String
	Data cDescription	As String
	Data cType			As String
	Data cUom			As String
	Data cLotControl	As String
	
	METHOD GetUom()
	METHOD GetType()
	METHOD GetDescription()
	METHOD GetWareHouse()
	METHOD GetItem()
	METHOD GetCnpjFilial()
	METHOD GetPartNmFrom()
	METHOD GetPartNmTo()
	METHOD GetDataTime()
	METHOD GetLotControl()
	METHOD SaveFile()
	METHOD New() CONSTRUCTOR

ENDCLASS

//-----------------------------------------------------------------
METHOD New() CLASS DHLAgeItemMaint
	
	::cLotControl	:= ""
	::cWareHouse	:= ""
	::cUom			:= ""
	::cDateTime		:= ""
	::cPartNameFrom	:= ""
	::cPartNameTo	:= ""
	::cSiteCnpj		:= ""
	::cItem			:= ""
	::cDescription	:= ""
	::cType			:= ""
	
Return

/**
* Método para salvar o arquivo XML
**/
METHOD SaveFile(cXmlFile) CLASS DHLAgeItemMaint
	
	Local cFolder   := getFolder()
	Local cDataTime := GetDataTime()
	Local cReference:= ::cSiteCnpj+"_"+cDataTime	
	Local oFile     := IpFileObject():newIpFileObject()
	Local lWhite	:= .F.
	Local oLog		:= DHLLogManager():newDHLLogManager()	
	
	cFileName	:=getFileName(cReference)	
	oFile:setFile(cFileName)
	lWhite 		:= oFile:writeLine(cXmlFile)
	
	if lWhite
		Aviso(FunDesc(),"Arquivo "+oFile:getFileName(.T.)+" gravado com sucesso!",{"OK"},3)
	Else
		oLog:start(APP_DLX,DHL_IMPORTACAO,cFileName)
		oLog:fail(LOG_MSG_FALHA,"Item Maintenance")
	endif
		
	oFile:close()
Return

/**
* Retorna o lote de controle
**/
METHOD GetLotControl() CLASS DHLAgeItemMaint
	
	::cLotControl := AllTrim(SB1->B1_RASTRO)
	
Return self:cLotControl

/**
* Retorna warehouse
**/
METHOD GetWareHouse() CLASS DHLAgeItemMaint
	
	::cWareHouse := "01"
	
Return self:cWareHouse

/**
* Retorna unidade de medida
**/
METHOD GetUOM() CLASS DHLAgeItemMaint
	
	::cUom := AllTrim(SB1->B1_UM)
	
Return self:cUom

/**
* Retorna o tipo do produto
**/
METHOD GetType() CLASS DHLAgeItemMaint
	
	::cType := AllTrim(SB1->B1_TIPO)
	
Return self:cType

/**
* Retorna a descrição do produto
**/
METHOD GetDescription() CLASS DHLAgeItemMaint
	
	::cDescription := AllTrim(SB1->B1_DESC)
	
Return self:cDescription

/**
* Retorna cItem do produto
**/
METHOD GetItem() CLASS DHLAgeItemMaint
	
	::cItem:= AllTrim(SB1->B1_COD)

Return self:cItem

/**
* Retorna CNPJ da filial
**/
METHOD GetCnpjFilial() CLASS DHLAgeItemMaint
	
	::cSiteCnpj:=AllTrim(SM0->M0_CGC)

Return self:cSiteCnpj

/**
* Retorna partnerName To
**/
METHOD GetPartNmTo() CLASS DHLAgeItemMaint
	
	
	::cPartNameTo := alltrim(GetNewPar("ZZ_ASNPART", "DLX"))

Return self:cPartNameTo


/**
* Retorna partnerName From
**/
METHOD GetPartNmFrom() CLASS DHLAgeItemMaint
	
	::cPartNameFrom:="PROTHEUS"

Return self:cPartNameFrom

/**
* Retorna o nome do arquivo xml da interface GW 
**/
static function getFileName(cReference)
	
	local oUtils    := IpUtilsObject():newIpUtilsObject()
	local cFolder   := getFolder()
	local cFileName := oUtils:concatDirectory(cFolder,"ITEM_MAINT_"+cReference+".XML")	
	
return cFileName


/**
* Retorna a Data e Hora
**/
METHOD GetDataTime() CLASS DHLAgeItemMaint
	
	Local cDia	:= Day2Str(dDataBase)
	Local cMes	:= Month2Str(dDataBase)
	Local cAno	:= Year2Str(dDataBase)
	Local cTime	:= Time()
	
	::cDateTime := cAno + "-" + cMes + "-" + cDia + "T" + cTime

Return self:cDateTime

/**
* Retorna a Data e Hora para compor o nome do arquivo
**/
Static Function GetDataTime()

	Local cDia		:= Day2Str(dDataBase)
	Local cMes		:= Month2Str(dDataBase)
	Local cAno		:= Year2Str(dDataBase)
	Local aTime		:= StrToKarr(Time(),":")	

Return cAno+cMes+cDia+aTime[SECONDS]+aTime[MINUTE]+aTime[HOUR]

/**
* Retorna o diretório de arquivos do WMS GW
**/
static function getFolder()
	Local oSql  := ipSqlObject():newIpSqlObject()
return AllTrim(oSql:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '" + APP_DLX + "'"))