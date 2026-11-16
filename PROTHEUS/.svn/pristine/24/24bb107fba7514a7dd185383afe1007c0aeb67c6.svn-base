#include "totvs.ch"
#include "dhl.ch"

#define BLQ_TELA_SIM "1"
#define ADD_PRODUCT  3 


/*/{Protheus.doc} Di2ItemMaint

Rotina responsável por ler e processar a interface Item Maintenance e atualizar os dados referentes ao produto.
Processo para a Unidade de Negócio DIS(Pfizer)
	
@author Winston Dellano de Castro
@since 13/11/2014
/*/
user function Di2ItemMaint(cFilePath)

	private aDatas      := {}
	private lMSErroAuto := .F.
	private cFile       := cFilePath
	
	getDatas()

	MSExecAuto({|x, y| Mata010(x, y)},aDatas,ADD_PRODUCT)
	
	if lMsErroAuto
		DisarmTransaction()
		setFileLog(cFile,"fail","Falha ao incluir o Produto."+CRLF+CRLF+oUtils:getErroAuto())
		
		lError := .T. 
	endif
	
return


/**
* Cria o array com os dados para a rotina automatica
**/
static function getDatas()

	aAdd(aDatas,{"B1_FILIAL",xFilial("SB1")  ,nil})
	aAdd(aDatas,{"B1_COD"   ,getId()         ,nil})
	aAdd(aDatas,{"B1_DESC"  ,getDescription(),nil})
	aAdd(aDatas,{"B1_TIPO"  ,getType()       ,nil})
	aAdd(aDatas,{"B1_UM"    ,getUOM()        ,nil})
	aAdd(aDatas,{"B1_LOCPAD",getWareHouse()  ,nil})
	aAdd(aDatas,{"B1_MSBLQL",BLQ_TELA_SIM    ,nil})
	aAdd(aDatas,{"B1_POSIPI","99999999"      ,nil})
	aAdd(aDatas,{"B1_ORIGEM","0"             ,nil})
	aAdd(aDatas,{"B1_RASTRO",getRastro()     ,nil})
	
	

return


/**
* Coleta o Código do Produto
**/
static function getId()
return Upper(AllTrim(oXml:_ITEM_MAINT:_BODY:_FILEHEADER:_ITEM:TEXT))


/**
* Coleta a Descrição do Produto
**/
static function getDescription()
return Upper(AllTrim(oXml:_ITEM_MAINT:_BODY:_FILEHEADER:_DESCRIPTION:TEXT))

/**
* Coleta o rastro do produto
**/
static function getRastro()
return Upper(AllTrim(oXml:_ITEM_MAINT:_BODY:_FILEHEADER:_LOT_CONTROL:TEXT))


/**
* Coleta o Tipo do Produto
**/
static function getType()
return AllTrim(oXml:_ITEM_MAINT:_BODY:_FILEHEADER:_TYPE:TEXT)


/**
* Coleta a Unidade de Medida
**/
static function getUOM()
return AllTrim(oXml:_ITEM_MAINT:_BODY:_FILEHEADER:_UOM:TEXT)


/**
* Coleta o Armazem
**/
static function getWareHouse()
return AllTrim(oXml:_ITEM_MAINT:_BODY:_FILEHEADER:_WAREHOUSE:TEXT)


/**
 * Define os Logs de acordo com os tipos de arquivos
 */
static function setFileLog(cFile,cLogType,cLogText,cTag,cValue)
	
	local cInterface := "Item Maintenance"
	
	oLog:start(APP_DLX,DHL_IMPORTACAO,cFile)
	
	if !(Empty(cTag))
		cLogText += CRLF+CRLF+"Tag: "+cTag
	endIf
	
	if !(Empty(cValue))
		cLogText += CRLF+CRLF+"Valor: "+cValue
	endIf
	
	if (cLogType == "fail")
		oLog:fail(cInterface, cLogText)
	elseIf (cLogType == "warn")
		oLog:warn(cInterface, cLogText)
	endIf	
	
return
