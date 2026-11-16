#include "totvs.ch"
#include "dhl.ch"

#define OPC_INCLUSAO   3
#define INTERFACE_NAME "Stock Adjustment"			


/*/{Protheus.doc} Ag2ImpInv
Importação da interface de ajuste de estoque.

@author Thiago Meschiatti
@since 19/08/2016
@version undefined

@param cFilePath, characters, Caminho do arquivo
@param cApp, characters, Aplicação

@type function
/*/
user function Ag2ImpInv(cFilePath,cApp)

	local lOk 	 	       := .F.
	local cError 	       := ""
	local cWarning 	       := ""

	private cXmlArq        := cFilePath	
	private oLogImp        := DHLLogManager():newDHLLogManager()
	private oXmlIp 	       := IpXmlObject():newIpXmlObject(cXmlArq)
	private oSql	       := IpSqlObject():newIpSqlObject()
	private cApplication   := cApp
	
	private lMsErroAuto    := .F.
	private lMsHelpAuto    := .T.
	private lAutoErrNoFile := .T.		
	private lTemPoder3 	   := .T.
	
	if !(oXmlIp:doParse())
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"Falha ao ler XML"+CRLF+CRLF+"Error: "+oXmlIp:getError()+CRLF+CRLF+"Aviso: "+oXmlIp:getWarning())
		
		return .F.
	endif
	
	lOk := procXml(APP_DLX)
	
return lOk


/**
 * Verifica se o Layout refere-se a determinada Aplicação
 */
static function isLayout(cApp)
	
	local lIsLayout := .F.
	local cXml		:= Upper(AllTrim(cXmlArq))	
	
	if (cApp == APP_DLX)
		lIsLayout := !(DHL_SELECT_STOCK_ADJUSTMENT $ cXml)
	endif		 
	
return lIsLayout


/**
 * Processa os Arquivos
 */
static function procXml(cApp)
	
	local lOk  := .F.
	
	//if isMovimentoTerc(cApp)
		If isPreNota(cApp)		
			lOk := geraPreNota(cApp)
		elseIf isPedidoVenda(cApp)
			lOk := geraPedidoVenda(cApp)	
		else
			oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
			oLogImp:fail(INTERFACE_NAME,"Não foi possível definir o movimento de Ajuste a ser gerado")
		endif
	//endif
								
return lOk


/**
 * Verifica se deve gerar uma Pre-Nota
 */
static function isPreNota(cApp)
	
	local lIsPreNota := .F.
	
	if (cApp == APP_DLX) .AND. !IsDhl()
		lIsPreNota := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_TYPE:text")))=="P"
	endif	
	
return lIsPreNota


/**
 * Verifica se deve gerar um pedido de venda
 */
static function isPedidoVenda(cApp)
	
	local lIsPedVenda := .F.
	
	if (cApp == APP_DLX) .AND. !IsDhl() 
		lIsPedVenda := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_TYPE:text"))) == "N"
	endif	
	
return lIsPedVenda

/**
 * Obtém o valor da TAG CUSTOMER verificando se é igual a DHL
 */
Static Function IsDhl()
	
	lIsDHL := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_CUSTOMER:text"))) == "DHL"
	
Return lIsDHL


/**
 * Verifica se deve gerar um movimento interno
 */
static function isMovimentoTerc(cApp)
	
	local lIsMovimentoTerc := .F.
	
	if (cApp == APP_DLX)
		lIsMovimentoTerc := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_CUSTOMER:text"))) == "DHL"
	endif	
	
return lIsMovimentoTerc


/**
 * Gera a Pre-Nota de Entrada
 */
static function geraPreNota(cApp)
	
	local lOk    := .F.
	local aCab   := {}
	local aItens := {}
	local cErro  := ""
	local cModuloBkp	:= cModulo
	
	cModulo := "EIC"
	
	lOk := getDadosPreNota(cApp,@aCab,@aItens)
	
	if lOk
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| MATA140(x,y,z)},aCab,aItens,OPC_INCLUSAO)
		
		cModulo := cModuloBkp
		
		if lMsErroAuto
			RollBackSX8()
			
			cErro := mostraErroRotAuto()
			
			oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
			oLogImp:fail(INTERFACE_NAME,"Erro de rotina automática"+CRLF+CRLF+cErro)
		else
			ConfirmSX8()

			lOk := .T.
		endif
	endif
	
return lOk


/**
 * Gera o pedido de venda
 */
static function geraPedidoVenda(cApp)
	
	local lOk    := .F.
	local aCab   := {}
	local aItens := {}
	local cErro  := ""
	
	lOk := getDadosPedVenda(cApp,@aCab,@aItens)
	
	if lOk
		lOk := .F.
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| MATA410(x,y,z)},aCab,aItens,OPC_INCLUSAO)
		
		if lMsErroAuto
			cErro := mostraErroRotAuto()
			
			oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
			oLogImp:fail(INTERFACE_NAME,"Erro de rotina automática"+CRLF+CRLF+cErro)
		else
			lOk := .T.
		endif
	endif
		
return lOk


/**
 * Obtem as arrays da rotina automática de pré nota
 */
static function getDadosPreNota(cApp,aCab,aItens)

	local aArea			:= GetArea()
	local aAreaSX3		:= SX3->(GetArea())
	local cControle  	:= ""
	local cCodProd 		:= ""
	local cCnpj 	 	:= ""
	local cFilialNum 	:= ""
	local cSerie 	 	:= DHL_SERIE_INVENTARIO
	local cTipoNf  		:= SuperGetMv("MV_TPNRNFS")
	local cFornece		:= ""
	local cLoja			:= ""
	local cNumero	 	:= ""
	local cLote			:= ""
	local cItem 	 	:= StrZero(0,TamSx3("D1_ITEM")[1])
	local cTes			:= GetMv("ZZ_TESENT")
	local nQuant 	 	:= 0	
	local nVUnit 	 	:= 0
	local nTotPrice		:= 0
	local aAux 			:= {}
	local aItensXML  	:= {}	
	
	if (cApp == APP_DLX)
	
		cControle := oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ADJUSTMENT_ID:text")		
		cCnpj     := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SITE_CNPJ:text"))
		cCodProd  := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ITEM:text"))
		
//		cNumero := NxtSX5Nota(cSerie, NIL, cTipoNf)
		
		
		SX3->(DbSetOrder(1))
		If (SX3->(dbSeek("SD9"))) .And. cTipoNf == "3"
			cNumero := MA461NumNf(.T., cSerie)			
		Else
			Alert("Não foi possível atribuir número de NF! Verifique o conteúdo do parâmetro MV_TPNRNFS.")
			Return .f.
		EndIf
		
		aAdd(aCab,{"F1_FILIAL"  , xFilial("SF1")  			  	,nil})
		aAdd(aCab,{"F1_DOC"     , cNumero				 	  	,nil})
		aAdd(aCab,{"F1_SERIE"   , cSerie       				  	,nil})
		aAdd(aCab,{"F1_FORNECE" , Left(GetMv("ZZ_CLINTEG"),6) 	,nil})
		aAdd(aCab,{"F1_LOJA"    , Right(GetMv("ZZ_CLINTEG"),2)	,nil})
		aAdd(aCab,{"F1_EMISSAO" , dDataBase 		            ,nil})
		aAdd(aCab,{"F1_TIPO"    , "B"       		            ,nil})
		aAdd(aCab,{"F1_FORMUL"  , "S"       		            ,nil})
		aAdd(aCab,{"F1_ESPECIE" , "INV"      		          	,nil})			
		aAdd(aCab,{"F1_ZZADJID"	, cControle 		            ,nil})
		aAdd(aCab,{"F1_ZZSTATU"	, DHL_DOC_PENDENTE_ACAO         ,nil})
		
		aItensXML := oXmlIp:getNodeArray("STK_ADJ:_BODY:_FILEHEADER")
		
		for nI := 1 to Len(aItensXML)
			
			cCodProd := AllTrim(aItensXML[nI]:_ITEM:text)
			nQuant   := Val(aItensXML[nI]:_QUANTITY:text)
			
			
			oSql:newTable("SB1","B1_COD,B1_LOCPAD,B1_PRV1","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+cCodProd+"'")
			
			nVUnit 	 := oSql:getValue("B1_PRV1")
			
			oSql:close()
			
			aAux  := {}			
			cItem := Soma1(cItem)
			
			nTotPrice := A410Arred(nQuant * nVUnit ,"D1_TOTAL")
			if nTotPrice < 0.01
				nTotPrice   := 0.01
				nVUnit 		:= A410Arred(nTotPrice / nQuant ,"D1_VUNIT")
			endif
			
			aAdd(aAux,{"D1_ITEM"  ,cItem		 	 ,nil})
			aAdd(aAux,{"D1_COD"   ,cCodProd	 	 	 ,nil})
			aAdd(aAux,{"D1_QUANT" ,nQuant		 	 ,nil})
			aAdd(aAux,{"D1_VUNIT" ,nVUnit		 	 ,nil})
			aAdd(aAux,{"D1_TOTAL" ,nTotPrice	 	 ,nil})
			aAdd(aAux,{"D1_ZZTES" ,cTes				 ,nil})
	
			aAdd(aItens,aAux)
			
		next
	
	endif
	
	RestArea(aAreaSX3)
	RestArea(aArea)
	
return .t.


/**
 * Obtem as arrays da rotina automática de pedido de venda
 */
static function getDadosPedVenda(cApp,aCab,aItens)

	local cControle  := ""
	local cCodProd 	 := ""
	local cLote		 := ""
	local cSubLote	 := ""
	local cCliFor	 := ""
	local cLoja		 := ""
	local nQuant 	 := 0
	local cItem 	 := StrZero(0,TamSx3("C6_ITEM")[1])
	local cCnpj 	 := ""
	local cFilialNum := ""
	local cTesSaida	 := GetMv("ZZ_TESSAI")
	local nVUnit 	 := 0
	local nTotPrice	 := 0
	local nSld   	 := 0
	local nSaldo 	 := 0
	local nVlrParcial, nVlrUnit, nSldTotal := 0
	local oSql		 := IpSqlObject():newIpSqlObject()
	local oSqlCli	 := IpSqlObject():newIpSqlObject()
	local aAux 		 := {}
	local aItensXML  := {}
	
	if (cApp == APP_DLX)
	
		cControle	:= oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ADJUSTMENT_ID:text")
		cCnpj     	:= AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SITE_CNPJ:text"))
		cLote		:= oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_LOT:text")
		cSubLote	:= oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SUBLOT:text")
		cCodProd	:= oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ITEM:text")
		nQuant 		:= val(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_QUANTITY:text"))
		
		nSld := nQuant
		
		aAdd(aCab,{"C5_FILIAL"  , xFilial("SC5") 			  	,nil})
		aAdd(aCab,{"C5_TIPO" 	, "N"       					,nil})
		aAdd(aCab,{"C5_CLIENTE" , Left(GetMV("ZZ_CLINTEG"),6)  	,nil})
		aAdd(aCab,{"C5_LOJACLI" , Right(GetMV("ZZ_CLINTEG"),2) 	,nil})
		aAdd(aCab,{"C5_CONDPAG"	, AllTrim(getMv("ZZ_CONDINT")) 	,nil})
		aAdd(aCab,{"C5_ZZADJID"	, cControle 		            ,nil})
		aAdd(aCab,{"C5_ZZESPEC" , "INV"       		          	,nil})
		aAdd(aCab,{"C5_ZZSTATU" , DHL_PV_PENDENTE_INFORMACAO   	,nil})
		
		aItensXML := oXmlIp:getNodeArray("STK_ADJ:_BODY:_FILEHEADER")
		
		for nI := 1 to Len(aItensXML)
		
			cCodProd := AllTrim(aItensXML[nI]:_ITEM:text)
			nQuant   := Val(aItensXML[nI]:_QUANTITY:text)
			
			oSql:newTable("SB1","B1_COD,B1_LOCPAD,B1_PRV1","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+cCodProd+"'")
			
			nVUnit 	 := oSql:getValue("B1_PRV1")
			
			oSql:close()
		
			aAux  := {}			
			cItem := Soma1(cItem)
			
			nTotPrice := A410Arred(nQuant * nVUnit ,"C6_VALOR")
			
			aAdd(aAux,{"C6_ITEM"    ,cItem		 	 						,nil})
			aAdd(aAux,{"C6_PRODUTO" ,padr(cCodProd, tamSx3("B1_COD")[1])	,nil})
			aAdd(aAux,{"C6_QTDVEN"  ,nQuant		 	   						,nil})
			aAdd(aAux,{"C6_PRCVEN"  ,nVUnit		 	    					,nil})
			aAdd(aAux,{"C6_VALOR"   ,nTotPrice	 	    					,nil})
			aAdd(aAux,{"C6_TES"     ,cTesSaida			 					,nil})
	
			aAdd(aItens,aAux)
			
		next
	
	endif
	
return .t.


/**
 *	Retorna o erro da rotina automática
 */
static function mostraErroRotAuto()

	local aErro  := {}
	local nI 	 := 0
	local cError := ""
	
	aErro := GetAutoGRLog()
	
    for nI := 1 to Len(aErro)
    	cError += aErro[nI] +CRLF
    next nI

return cError