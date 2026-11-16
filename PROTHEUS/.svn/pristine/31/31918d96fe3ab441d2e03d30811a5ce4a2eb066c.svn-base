#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"

#define PRODUCT_BOM  		 1
#define QUANTITY_BOM 		 2
#define WORK_ORDER   		 3
#define LOT_BOM		   		 4
#define EXPIRATION_DT_BOM  	 5
#define PALLET			 	 6
#define FILEITEM     		 7

#define PRODUCT  	 	1
#define QUANTITY	 	2
#define LOT	  	    	3
#define EXPIRATION_DATE 4

#define ARRAY_PRODUCT  	 		1
#define ARRAY_QUANTITY	 		2
#define ARRAY_LOT	  	    	3
#define ARRAY_OP	  	    	4
#define ARRAY_EXPIRATION_DATE 	5
#define ARRAY_PALLET		 	6

//RONI SILVA INICIO

//Para modelo 2 de faturamento
#define OPS     	3
#define UNIT_PRICE  4
#define TOT_PRICE	5
//RONI SILVA FIM

//Para modelo 2 de faturamento
//#define OPS     		 4
//#define UNIT_PRICE  	 5
//#define TOT_PRICE		 6

#define PROPRIO			 2
#define TERCEIRO		 1


/*/{Protheus.doc} MulInvReq

Rotina responsável por ler e processar a interface Invoice Request e atualizar os dados referentes ao documento.

@author Winston Dellano de Castro
@since 13/11/2014

@param cFilePath, String, Arquivo a ser processado
/*/
user function MulInvReq(cFilePath)

	local lValid        := .T.
	local nBom          := 0
	local cPallet       := ""
	local nItem			:= 1
	local oSqlCliFor	:= IpSqlObject():newIpSqlObject()

	private cShipping   := getShipping()
	private aBoms       := getBoms()
	private lMsErroAuto := .F.
	private cFile       := cFilePath

	private aProducts		 	:= {}
	private aDetail          	:= {}
	private aDetails         	:= {}
	private cProductionOrder 	:= ""
	private cIdOp			 	:= ""
	private cItem            	:= ""
	private cProds			:= ""
	private lMsErroAuto 		:= .F.
	private lTemPoder3		:= .T.
	private lOk				:= .T.
	private lTemPA	   		:= .F.
	private cmodelo3        := ""
	private oDHLModelo3		:= DHLModelo3():NewDHLModelo3()

	BEGIN TRANSACTION
		BEGIN SEQUENCE
			for nBom := 1 to Len(aBoms)

				for nItem := 1 to Len(aBoms[nBom][FILEITEM])
					aAdd(aProducts, {aBoms[nBom][FILEITEM][nItem][PRODUCT], aBoms[nBom][FILEITEM][nItem][QUANTITY], "", aBoms[nBom][FILEITEM][nItem][LOT], aBoms[nBom][FILEITEM][nItem][EXPIRATION_DATE], ""})
				next nItem

				if !(empty(aBoms[nBom][PRODUCT_BOM]))
					aAdd(aProducts, {aBoms[nBom][PRODUCT_BOM], aBoms[nBom][QUANTITY], cProductionOrder, aBoms[nBom][LOT_BOM], aBoms[nBom][EXPIRATION_DT_BOM], aBoms[nBom][PALLET]})
				endif
			next nBom

			oSqlCliFor:newAlias(getCliFor(aProducts[1][1]))

			if oSqlCliFor:hasRecords()
				cCliFor  := oSqlCliFor:getValue("CODIGO")
				cLoja    := oSqlCliFor:getValue("LOJA")
				cmodelo3 := oSqlCliFor:getValue("MODELO3")   //SE FOR "1"
			else
				setFileLog(cFile,"fail","Cliente/Fornecedor do produto (" + alltrim(aProducts[1][1]) + ") é diferente dos demais do pedido. " + CRLF )
				lOk := .f.
			endif

			lMsErroAuto := .F.
			if alltrim(cmodelo3) $ "1" .and. getDocType() == "N"   //RONI SILVA alterar para pegar o campo da SA1 RONISILVA
				incModelo3OutFlow(@nBom)

				if oDhlmodelo3:HasErro()
					lError := .T.
				endIf
			else

				lOk := incOutflowOrder(@nBom)  //PARA INCLUIR UM UNICO PEDIDO
			ENDIF
			RECOVER
			DisarmTransaction()
		END SEQUENCE
	END TRANSACTION

return (lOk)

/**
* Coleta o Shipping Number
**/
static function getShipping()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_SHIPPING_NUMBER:TEXT

/**
* Coleta o Document Type
**/
static function getDocType()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_DOCUMENT_TYPE:TEXT

/**
* Coleta os Items da interface Invoice Request
**/
static function getBoms()
	
	local aItems       := {}
	local aBoms        := {}
	local nItem        := 1
	local nPallet      := 1
	local nLenPallet   := 0
	local nLenItem     := 0
	local nBomQuantity := 0
	local cBomProduct  := ""
	local cWorkOrder   := ""
	local cLot		 := ""
	local cPallet		 := ""
	local dExpirLot
	
	if ValType(oXml:_INV_REQ:_BODY:_FILEPALLET) <> nil
		
		if ValType(oXml:_INV_REQ:_BODY:_FILEPALLET) == "A"
			
			nLenPallet := Len(oXml:_INV_REQ:_BODY:_FILEPALLET)
			
			for nPallet := 1 to nLenPallet
				
				cBomProduct  := getBomProduct(@nPallet)
				nBomQuantity := getBomQuantity(@nPallet)
				cWorkOrder   := getWorkOrder(@nPallet)
				cLot		 := getBomLot(@nPallet)
				dExpirLot    := getBomExpDt(@nPallet)
				cPallet	     := getPallet(@nPallet)
				
				if ValType(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_FILEITEM) == "A"
					
					nLenItem := Len(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_FILEITEM)
					aItems   := {}
					
					for nItem := 1 to nLenItem
						aAdd(aItems,{getProduct(@nPallet,@nItem),getQuantity(@nPallet,@nItem),getLot(@nPallet, @nItem), getExpirDate(@nPallet, @nItem)})
					next
					
				elseif ValType(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_FILEITEM) == "O"
					
					nItem	:= 0
					aItems  := {}
					aAdd(aItems,{getProduct(@nPallet,@nItem),getQuantity(@nPallet,@nItem),getLot(@nPallet, @nItem), getExpirDate(@nPallet, @nItem)})
					
				endif
				
				aAdd(aBoms,{cBomProduct,nBomQuantity,cWorkOrder, cLot, dExpirLot, cPallet, aItems})
			next nPallet
		else
			
			cBomProduct  := getBomProduct(0)
			nBomQuantity := getBomQuantity(0)
			cWorkOrder   := getWorkOrder(0)
			cLot		 := getBomLot(0)
			dExpirLot    := getBomExpDt(0)
			cPallet	     := getPallet(0)
			
			if ValType(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_FILEITEM) == "A"
				
				nLenItem := Len(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_FILEITEM)
				aItems   := {}
				
				for nItem := 1 to nLenItem
					aAdd(aItems,{getProduct(0,@nItem),getQuantity(0,@nItem),getLot(0, @nItem), getExpirDate(0, @nItem)})
				next nItem
				
			elseif ValType(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_FILEITEM) == "O"
				
				nItem	:= 0
				aItems  := {}
				aAdd(aItems,{getProduct(0,@nItem),getQuantity(0,@nItem),getLot(0, @nItem), getExpirDate(0, @nItem)})
				
			endif
			
			aAdd(aBoms,{cBomProduct,nBomQuantity,cWorkOrder, cLot, dExpirLot, cPallet, aItems})
		endif
		
	else
		aAdd(aBoms,{})
	endif
	
return aBoms


/**
* Coleta o produto acabado (BOM)
**/
static function getBomProduct(nPallet)
	local xRet	:= ""
	
	if nPallet > 0
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_BOM:TEXT)
	else
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_BOM:TEXT)
	endif
	
return (xRet)


/**
* Coleta a quantidade do BOM
**/
static function getBomQuantity(nPallet)
	local xRet := ""
	
	if nPallet > 0
		xRet := Val(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_QUANTITY:TEXT)
	else
		xRet := Val(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_QUANTITY:TEXT)
	endif
	
return (xRet)


/**
* Coleta o Work Order
**/
static function getWorkOrder(nPallet)
	local xRet := ""
	
	if nPallet > 0
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_WORK_ORDER:TEXT)
	else
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET:_WORK_ORDER:TEXT)
	endif
return (xRet)


/**
* Coleta o Work Order
**/
static function getPallet(nPallet)
	local xRet := ""
	
	if nPallet > 0
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_SUBLOT:TEXT)
	else
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET:_SUBLOT:TEXT)
	endif
return (xRet)


/**
* Coleta o Work Order
**/
static function getBomLot(nPallet)
	local xRet	:= ""
	
	if nPallet > 0
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_LOT:TEXT)
	else
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_LOT:TEXT)
	endif
	
return (xRet)


/**
* Coleta o Work Order
**/
static function getBomExpDt(nPallet)
	local xRet	:= ""
	local cDate := ""
	
	if nPallet > 0
		cDate := oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_EXPIRATION_DATE:TEXT
		xRet  := sTod("20" + right(cDate, 2) + substr(cDate, 3, 2) + left(cDate, 2) )
		
		If !Empty(cDate) .And. Empty(xRet)
			xRet := sTod(strTran(cDate, "-"))
		EndIf
	else
		cDate := oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_EXPIRATION_DATE:TEXT
		xRet  := sTod("20" + right(cDate, 2) + substr(cDate, 3, 2) + left(cDate, 2) )
		
		If !Empty(cDate) .And. Empty(xRet)
			xRet := sTod(strTran(cDate, "-"))
		EndIf
	endif
	
return (xRet)


/**
* Coleta o Produto
**/
static function getProduct(nPallet,nItem)
	local xRet := ""
	
	if nPallet > 0
		if nItem > 0
			xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_FILEITEM[nItem]:_ITEM:TEXT)
		else
			xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_FILEITEM:_ITEM:TEXT)
		endif
	else
		if nItem > 0
			xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_FILEITEM[nItem]:_ITEM:TEXT)
		else
			xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_FILEITEM:_ITEM:TEXT)
		endif
	endif
return (xRet)


/**
* Coleta a Quantidade
**/
static function getQuantity(nPallet,nItem)
	local xRet := ""
	
	if nPallet > 0
		if nItem > 0
			xRet := Val(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_FILEITEM[nItem]:_QUANTITY:TEXT)
		else
			xRet := Val(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_FILEITEM:_QUANTITY:TEXT)
		endif
	else
		if nItem > 0
			xRet := Val(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_FILEITEM[nItem]:_QUANTITY:TEXT)
		else
			xRet := Val(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_FILEITEM:_QUANTITY:TEXT)
		endif
	endif
return (xRet)


/**
* Coleta a Quantidade
**/
static function getLot(nPallet,nItem)
	local xRet := ""
	
	if nPallet > 0
		if nItem > 0
			xRet := Alltrim(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_FILEITEM[nItem]:_LOT:TEXT)
		else
			xRet := Alltrim(oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_FILEITEM:_LOT:TEXT)
		endif
	else
		if nItem > 0
			xRet := Alltrim(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_FILEITEM[nItem]:_LOT:TEXT)
		else
			xRet := Alltrim(oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_FILEITEM:_LOT:TEXT)
		endif
	endif
return (xRet)


/**
* Coleta a Quantidade
**/
static function getExpirDate(nPallet,nItem)
	local xRet := ""
	local cDate := ""
	
	if nPallet > 0
		if nItem > 0
			cDate := oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_FILEITEM[nItem]:_EXPIRATION_DATE:TEXT
		else
			cDate := oXml:_INV_REQ:_BODY:_FILEPALLET[nPallet]:_FILEBOM:_FILEITEM:_EXPIRATION_DATE:TEXT
		endif
		//xRet  := sTod("20" + right(cDate, 2) + substr(cDate, 3, 2) + left(cDate, 2) )
		xRet := StoD(left(cDate, 4) + substr(cDate, 6, 2) + right(cDate, 2))
	else
		if nItem > 0
			cDate := oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_FILEITEM[nItem]:_EXPIRATION_DATE:TEXT
		else
			cDate := oXml:_INV_REQ:_BODY:_FILEPALLET:_FILEBOM:_FILEITEM:_EXPIRATION_DATE:TEXT
		endif
		//xRet  := sTod("20" + right(cDate, 2) + substr(cDate, 3, 2) + left(cDate, 2) )
		xRet := StoD(left(cDate, 4) + substr(cDate, 6, 2) + right(cDate, 2))
	endif
return (xRet)


/**
* Coleta a unidade de medida do Produto
**/
static function UnitMeasure(cProduct)
return AllTrim(oSql:getFieldValue("SB1","B1_UM","B1_FILIAL = '%SB1.FILIAL%' AND B1_COD = '" + cProduct + "'"))


/**
* Verifica se é produto acabado (BOM)
**/
static function isBom(nBom)
return if(Empty(aBoms[nBom][PRODUCT_BOM]),.F.,.T.)


/**
* Inclui o Pedido de Venda
**/
static function incOutflowOrder(nBom)
	
	local aHeader 	  := {}
	local cPriceMO	  := ""
	local cPriceIns	  := ""
	local cPriceTot	  := ""

	private cCliFor	  := ""
	private cLoja	  := ""
	
	mountDetail(@cPriceMO, @cPriceIns, @cPriceTot)
	
	if lOk
		
		aAdd(aHeader,{"C5_TIPO"   , "N"                           		,nil})
		if getDocType() == "D"
			aAdd(aHeader,{"C5_CLIENTE", Left(GetMV("ZZ_CLINTEG"),6) 	,nil})
			aAdd(aHeader,{"C5_LOJACLI", Right(GetMV("ZZ_CLINTEG"),2)	,nil})
//			aAdd(aHeader,{"C5_ZZSTATU", DHL_PV_PENDENTE_INFORMACAO   	,nil})
		else
			aAdd(aHeader,{"C5_CLIENTE", cCliFor  						,nil})
			aAdd(aHeader,{"C5_LOJACLI", cLoja 							,nil})
		endIf
		
		aAdd(aHeader,{"C5_CONDPAG", GetMV("ZZ_CONDINT")           		,nil})
		aAdd(aHeader,{"C5_ZZSHIP" , cShipping                     		,nil})
		aAdd(aHeader,{"C5_ZZTIPO" , getDocType()   				 		,nil})
		
		if !empty(cPriceMO) .and. !empty(cPriceIns) .and. !empty(cPriceTot)
			aAdd(aHeader,{"C5_ZZMSGIN" , "Valor total cobrado: R$ "+cPriceTot+" (insumos empregados: R$ "+cPriceIns+" e mão-de-obra aplicada: R$"+cPriceMO+").", nil})
		endif
		
		aHeader := FwVetByDic(aHeader, "SC5")
		
		if !(lTemPoder3)
			DisarmTransaction()
			setFileLog(cFile,"fail","Não há saldo em poder de terceiros para os itens do pedido " + CRLF + CRLF + cProds + CRLF + CRLF + oUtils:getErroAuto())
			lOk := .f.
			return (lOk)
		endif
		
		MSExecAuto({|x, y, z| Mata410(x, y, z)}, aHeader, aDetails, 3)
		
		if lMsErroAuto
			if !IsBlind()
				mostraerro()
			endif
			DisarmTransaction()
			setFileLog(cFile,"fail","Falha ao incluir o pedido de vendas"+CRLF+CRLF+oUtils:getErroAuto())
			lOk := .f.
		endIf
	endif
return (lOk)


/**
* Monta os Itens do Pedido de Venda
**/
static function mountDetail(cPriceMO, cPriceIns, cPriceTot)
	
	local oSql			:= IpSqlObject():newIpSqlObject()
	local oSqlCliFor	:= IpSqlObject():newIpSqlObject()
	local nI		 	:= 0
	local nUnitPrice 	:= 0
	local nQuantity  	:= 0
	local nTotPrice		:= 0
	local nBlc   		:= 0
	local nBalance 		:= 0
	local nPricePartial, nPriceUnit, nBlcTotal := 0
	local cProduct   	:= ""
	local cOP			:= ""
	local cLot			:= ""
	local cTypeProd		:= ""

	local dExpirDate	:= ""
	local lModelo2		:= alltrim(GetNewPar("ZZ_MODEFAT", "1")) $ "2"
	local lProprio		:= .F.
	local cPackingInd  := SuperGetMV("ZZ_PACKIND",,.F.)
	Private  cTesSaida		:= GetMV("ZZ_TESSAI")	
	aDetails := {}
	cItem    := Replicate("0",Len(SC6->C6_ITEM))
	
	groupProducts()
	
	if lModelo2 .and. getDocType() == "N"
		
		agglutProds(@cPriceMO, @cPriceIns, @cPriceTot)
		
		for nI := 1 to Len(aProducts)
			
			aDetail   := {}
			cItem     := Soma1(cItem)
			cProduct  := aProducts[nI,PRODUCT]
			nQuantity := aProducts[nI,QUANTITY]
			cLot 	  := aProducts[nI,LOT]
			dExpirDate:= aProducts[nI,EXPIRATION_DATE]
			nUnitPrice:= aProducts[nI,UNIT_PRICE]
			nTotPrice := aProducts[nI,TOT_PRICE]
			
			aAdd(aDetail, {"C6_ITEM"   , cItem                  ,nil})
			aAdd(aDetail, {"C6_PRODUTO", cProduct               ,nil})
			aAdd(aDetail, {"C6_UM"     , UnitMeasure(cProduct)  ,nil})
			aAdd(aDetail, {"C6_QTDVEN" , nQuantity              ,nil})
			aAdd(aDetail, {"C6_PRCVEN" , if(nI == 1, nTotPrice/nQuantity, nUnitPrice) ,nil})
			aAdd(aDetail, {"C6_VALOR"  , nTotPrice				,nil})
			aAdd(aDetail, {"C6_TES"    , cTesSaida			    ,nil})
			aAdd(aDetail, {"C6_ZZOP"   , cOP, nil})
			if nI == 1
				aAdd(aDetail, {"C6_PRUNIT"   , nTotPrice/nQuantity, nil})
			endif
			
			aAdd(aDetails,aDetail)
			
		next nI
	
	//DEVOLUÇÃO	
	ElseIf getDocType() == "D"
		GetDetailsDevoluc()
	else
		
		for nI := 1 to Len(aProducts)
			
			aDetail   := {}
			cOP		  := ""
			cItem     := Soma1(cItem)
			cProduct  := aProducts[nI,ARRAY_PRODUCT]
			nQuantity := aProducts[nI,ARRAY_QUANTITY]
			cLot 	  := aProducts[nI,ARRAY_LOT]
			dExpirDate:= aProducts[nI,ARRAY_EXPIRATION_DATE]
			cTypeProd := retInfoProd(cProduct, "B1_TIPO")
			lProprio  := .F.
			
			if (cTypeProd == "PA") .or. (retInfoProd(cProduct, "B1_AGREGCU") == "2")
				
				if (cTypeProd == "PA")
					lOk := vldBalancePA(cProduct, cLot, dExpirDate, cTypeProd, nQuantity)
					
					If cPackingInd
						cOP := retOP(aBoms[1,WORK_ORDER])
					Else
						cOP := retOP(aProducts[nI,ARRAY_PALLET])//aProducts[nI,OPS]
					EndIf					
					
					oSqlCliFor:newAlias(getCliFor(cProduct))
					
					if oSqlCliFor:hasRecords()
						cCliFor  := oSqlCliFor:getValue("CODIGO")
						cLoja    := oSqlCliFor:getValue("LOJA")
						cmodelo3 := oSqlCliFor:getValue("MODELO3")   //SE FOR "1"
					else
						DisarmTransaction()
						setFileLog(cFile,"fail","Cliente/Fornecedor do produto (" + alltrim(cProduct) + ") é diferente dos demais do pedido. " + CRLF )
						lOk := .f.
						exit
					endif
				else
					lOk := .t.
					lProprio := .T.
				endif
				
				if lOk
					
					if oSqlCliFor:hasRecords() .OR. lProprio
						getUnitPrice(cProduct,@nUnitPrice)
						
						nTotPrice := A410Arred(nQuantity * nUnitPrice ,"C6_VALOR")
						
						aAdd(aDetail, {"C6_ITEM"   , cItem                  			 ,nil})
						aAdd(aDetail, {"C6_PRODUTO", cProduct               			 ,nil})
						aAdd(aDetail, {"C6_UM"     , UnitMeasure(cProduct)  			 ,nil})
						aAdd(aDetail, {"C6_QTDVEN" , nQuantity              			 ,nil})
						aAdd(aDetail, {"C6_PRCVEN" , nUnitPrice             			 ,nil})
						aAdd(aDetail, {"C6_VALOR"  , nTotPrice						 ,nil})
						aAdd(aDetail, {"C6_TES"    , retInfoProd(cProduct, "B1_TS")    ,nil})
//						aAdd(aDetail, {"C6_TES"    , cTesSaida    ,nil})
						aAdd(aDetail, {"C6_ZZOP"   , cOP							 ,nil})
						if !empty(cLot) .and. ProdutControlLote(cProduct)
							aAdd(aDetail, {"C6_LOTECTL"   , cLot					 ,nil})
							aAdd(aDetail, {"C6_DTVALID"   , dExpirDate				 ,nil})
						endif
						
						aAdd(aDetails,aDetail)
					else
						setFileLog(cFile,"fail","Não foi encontrado a amarração produto("+ alltrim(cProduct)+") x cliente/fornecedor "  + CRLF )
						lOk := .f.
						exit
					endif
					oSqlCliFor:close()
				else
					setFileLog(cFile,"fail","Não há saldo item da interface " + alltrim(cProduct) + " - " + alltrim(cLot) + CRLF )
					lOk := .f.
					exit
				endif
			else
						
				oSql:newAlias(getQueryItens(cProduct, cLot))
				
				nBlc := nQuantity
				
				if oSql:hasRecords()
					
					while oSql:notIsEof()
						
						aDetail	:= {}
						nPricePartial:= 0
						nPriceUnit := 0
						nBlcTotal := 0
						
						if nBlc <= oSql:getValue("B6_SALDO")
							nBalance 		:= nBlc
						else
							nBalance 		:= oSql:getValue("B6_SALDO")
						endif
						
						if nBalance < oSql:getValue("B6_QUANT")
							nBlcTotal 	:= oSql:getValue("B6_QUANT")
							
							nPriceUnit    := oSql:getValue("D1_VUNIT")
							nPricePartial := nPriceUnit * nBalance
						else
							nPricePartial	:= oSql:getValue("D1_TOTAL")
							nPriceUnit 	:= nPricePartial / nBalance
						endif
						
						if nBalance * A410Arred(nPriceUnit ,"C6_PRCVEN") < 0.01
							oLogImp:start("PV","PV","")
							oLogImp:warn("REGISTRO IGNORADO PEDIDO "+SC5->C5_NUM, "Valor total item "+oSql:getValue("B6_PRODUTO")+" para NF "+oSql:getValue("D1_DOC")+;
								"/"+oSql:getValue("D1_SERIE")+" não atingiu valor minimo 0,01.")
							oSql:skip()
							loop
						endif
						
						if len(aDetails) == 0
							cItem := "01"
						else
							cItem := Soma1(aDetails[len(aDetails),1,2])
						endif
						
						aAdd(aDetail,{"C6_ITEM"   ,cItem                      ,nil})
						aAdd(aDetail,{"C6_PRODUTO",oSql:getValue("B6_PRODUTO"),nil})
						aAdd(aDetail,{"C6_QTDVEN" ,nBalance                     ,nil})
						aAdd(aDetail,{"C6_PRCVEN" ,A410Arred(nPriceUnit ,"C6_PRCVEN")  ,nil}) 
						aAdd(aDetail,{"C6_VALOR"  ,A410Arred(nPricePartial,"C6_VALOR"),nil})
						aAdd(aDetail,{"C6_QTDLIB" ,nBalance                     ,nil})
						aAdd(aDetail,{"C6_TES"    ,getTes(@oSql)              ,nil})
						aAdd(aDetail,{"C6_LOCAL"  ,oSql:getValue("D1_LOCAL")  ,nil})
						aAdd(aDetail,{"C6_NFORI"  ,oSql:getValue("D1_DOC")    ,nil})
						aAdd(aDetail,{"C6_SERIORI",oSql:getValue("D1_SERIE")  ,nil})
						aAdd(aDetail,{"C6_ITEMORI",oSql:getValue("D1_ITEM")   ,nil})
						aAdd(aDetail,{"C6_IDENTB6",oSql:getValue("B6_IDENT")  ,nil})
//						aAdd(aDetail,{"C6_LOTECTL",oSql:getValue("D1_LOTECTL"),nil})
//						aAdd(aDetail,{"C6_DTVALID",oSql:getValue("D1_DTVALID"),nil})
						
						aAdd(aDetails,aDetail)
						
						nBlc -= iif(nBlc <= oSql:getValue("B6_SALDO"),nBlc,oSql:getValue("B6_SALDO"))
						
						if nBlc == 0
							exit
						endif
						
						oSql:skip()
					enddo
					if nBlc > 0
						cProds += cProduct +"/"
						lTemPoder3 := .F.
						exit
					endif
				else
					cProds += cProduct +"/"
					lTemPoder3 := .F.
					exit
				endif
			endif
		next nI
	endif
return

/**
* Obtém o detalhes quando for devolução
*/
Static Function GetDetailsDevoluc()

	Local nI 		:= 0
	Local nUnitPrice:= 0
	Local nQuantity	:= 0
	Local aDetail	:= {}
	Local cProduct	:= ""
	Local cOP		:= ""
	Local cTesSaida := GetMV("ZZ_TESSAI")
	Local cPackingInd  := SuperGetMV("ZZ_PACKIND",,.F.)

	For nI := 1 To Len(aProducts)

		aDetail   := {}
//		cItem     := Soma1(cItem)
		cProduct  := aProducts[nI,1]
		nQuantity := aProducts[nI,2]

		If cPackingInd
			cOP := retOP(aBoms[1,WORK_ORDER])
		Else
			cOP := retOP(aProducts[nI,ARRAY_PALLET])
		EndIf

		cLot 	  := aProducts[nI,ARRAY_LOT]
		dExpirDate:= aProducts[nI,ARRAY_EXPIRATION_DATE]
		cTypeProd := retInfoProd(cProduct, "B1_TIPO")

		getUnitPrice(cProduct,@nUnitPrice)

//RONI SILVA INICIO
		cQuery	:= getQueryItens(cProduct, cLot) //RONI silva

		oSql:newAlias(cQuery)

		nSld := nQuantity

		if oSql:hasRecords()
			while oSql:notIsEof()

				lTemPoder3 := .T.

				aAux := {}

				nVlrParcial:= 0
				nVlrUnit := 0
				nSldTotal := 0

				if nSld <= oSql:getValue("B6_SALDO")
					nSaldo 		:= nSld
				else
					nSaldo 		:= oSql:getValue("B6_SALDO")
				endif

				if nSaldo < oSql:getValue("B6_QUANT")
					nSldTotal 	:= oSql:getValue("B6_QUANT")

					nVlrUnit    := oSql:getValue("D1_VUNIT")
					nVlrParcial := nVlrUnit * nSaldo
				else
					nVlrParcial	:= oSql:getValue("D1_TOTAL")
					nVlrUnit 	:= nVlrParcial / nSaldo
				endif

				if nSaldo * A410Arred(nVlrUnit ,"C6_PRCVEN") < 0.01
					oLogImp:start("PV","PV","")
					oLogImp:warn("REGISTRO IGNORADO PEDIDO "+SC5->C5_NUM, "Valor total item "+oSql:getValue("B6_PRODUTO")+" para NF "+oSql:getValue("D1_DOC")+;
						"/"+oSql:getValue("D1_SERIE")+" não atingiu valor minimo 0,01.")
					oSql:skip()
					loop
				endif

				cItem := Soma1(cItem)

				aAdd(aAux,{"C6_ITEM"   ,cItem                      ,nil})
				aAdd(aAux,{"C6_PRODUTO",oSql:getValue("B6_PRODUTO"),nil})
				aAdd(aAux,{"C6_QTDVEN" ,nSaldo                     ,nil})
				aAdd(aAux,{"C6_PRCVEN" ,A410Arred(nVlrUnit ,"C6_PRCVEN")  ,nil})
				aAdd(aAux,{"C6_VALOR"  ,A410Arred(nVlrParcial,"C6_VALOR"),nil})
				aAdd(aAux,{"C6_QTDLIB" ,nSaldo                     ,nil})
				//RONI SILVA INICIO
				cTesSaida := iif(lTemPA, oSql:getValue("F4_TESDV"), oSql:getValue("F4_ZZTESFE"))
				cTesSaida := iif(empty(cTesSaida),retInfoProd(cProduct, "B1_TS"),cTesSaida)
				cTesSaida := iif(empty(cTesSaida),GetMV("ZZ_TESSAI"),cTesSaida)
				aAdd(aAux,{"C6_IDENTB6",oSql:getValue("B6_IDENT")  ,nil})
				aAdd(aAux,{"C6_NFORI"  ,oSql:getValue("D1_DOC")    ,nil})
				aAdd(aAux,{"C6_SERIORI",oSql:getValue("D1_SERIE")  ,nil})
				aAdd(aAux,{"C6_ITEMORI",oSql:getValue("D1_ITEM")   ,nil})

				//RONI SILVA FIM

				aAdd(aAux, {"C6_TES"    , cTesSaida     			,nil})
				if ProdutControlLote(cProduct)
					aAdd(aAux, {"C6_LOTECTL", cLot					,nil})
					aAdd(aAux, {"C6_DTVALID", dExpirDate				,nil})
				endif
				aAdd(aAux, {"C6_ZZOP"   , cOP					,nil})
				aAdd(aAux,{"C6_LOCAL"  ,oSql:getValue("D1_LOCAL")  ,nil})
				aAdd(aAux,{"C6_LOTECTL",oSql:getValue("D1_LOTECTL"),nil})
				aAdd(aAux,{"C6_DTVALID",oSql:getValue("D1_DTVALID"),nil})

				montaItens(@aAux)

				aAdd(aDetails,aAux)

				nSld -= iif(nSld <= oSql:getValue("B6_SALDO"),nSld,oSql:getValue("B6_SALDO"))

				if nSld == 0
					exit
				endif

				oSql:skip()

			enddo
			if nSld > 0
				lTemPoder3 := .F.
				exit
			endif
		endif


//RONI SILVA FIM
/*/RONI SILVA ANTES INICIO

		nTotPrice := A410Arred(nQuantity * nUnitPrice ,"C6_VALOR")

		aAdd(aDetail, {"C6_ITEM"   , cItem                  ,nil})
		aAdd(aDetail, {"C6_PRODUTO", cProduct               ,nil})
		aAdd(aDetail, {"C6_UM"     , UnitMeasure(cProduct)  ,nil})
		aAdd(aDetail, {"C6_QTDVEN" , nQuantity              ,nil})
		aAdd(aDetail, {"C6_PRCVEN" , nUnitPrice             ,nil})
		aAdd(aDetail, {"C6_VALOR"  , nTotPrice				,nil})
		aAdd(aDetail, {"C6_QTDLIB" , 0		                ,nil})

		//RONI SILVA INICIO
		cTesSaida := iif(lTemPA, oSql:getValue("F4_TESDV"), oSql:getValue("F4_ZZTESFE"))
		cTesSaida := iif(empty(cTesSaida),retInfoProd(cProduct, "B1_TS"),cTesSaida)
		cTesSaida := iif(empty(cTesSaida),GetMV("ZZ_TESSAI"),cTesSaida)
		aAdd(aDetail,{"C6_IDENTB6",oSql:getValue("B6_IDENT")  ,nil})
		aAdd(aDetail,{"C6_NFORI"  ,oSql:getValue("D1_DOC")    ,nil})
		aAdd(aDetail,{"C6_SERIORI",oSql:getValue("D1_SERIE")  ,nil})
		aAdd(aDetail,{"C6_ITEMORI",oSql:getValue("D1_ITEM")   ,nil})

		//RONI SILVA FIM

		aAdd(aDetail, {"C6_TES"    , cTesSaida     			,nil})
		if ProdutControlLote(cProduct)
			aAdd(aDetail, {"C6_LOTECTL", cLot					,nil})
			aAdd(aDetail, {"C6_DTVALID", dExpirDate				,nil})
		endif
		aAdd(aDetail, {"C6_ZZOP"   , cOP					,nil})

		aAdd(aDetails,aDetail)
//		ENDIF

//RONI SILVA ANTES FIM
*/

	Next nI

Return

/**
* Agrupa os Produtos do Pedido de Vendas
*/
static function groupProducts()

	local nI	   	 	 := 0
	local nScan		 := 0
	local nQuantity  	 := 0
	local cProduct   	 := ""
	local cOP		 := ""
	local cLot		 := ""
	local cPallet    := ""
	local dExpDate   := cTod("")
	local aGroupProd 	 := {}

	for nI := 1 to Len(aProducts)

		cProduct  := aProducts[nI,1]
		nQuantity := aProducts[nI,2]
		cOP       := ""
		if ProdutControlLote(cProduct)
			cLot	  := aProducts[nI,4]
			dExpDate  := aProducts[nI,5]
		endif
		cPallet	  := aProducts[nI,6]

		if ProdutControlLote(cProduct)
			nScan     := aScan(aGroupProd, {|x| alltrim(x[1]) + alltrim(x[3]) +  dtos(x[5]) == alltrim(cProduct) + alltrim(cLot) + dtos(dExpDate)})
		else
			nScan     := aScan(aGroupProd, {|x| alltrim(x[1]) == alltrim(cProduct)})
		endif

		if (nScan > 0)
			aGroupProd[nScan,2] += nQuantity
		else
			aAdd(aGroupProd, {cProduct, nQuantity, cLot, cOP, dExpDate, cPallet})
		endIf

		validPA(cProduct)

	next nI

	ordenaPA(@aGroupProd)

	aProducts := aClone(aGroupProd)

return

/**
* Coleta o preço de Venda
**/
static function getUnitPrice(cProduct,nUnitPrice)
	
	local cQuery := ""
	
	cQuery += "SELECT B1_PRV1,B2_CM1"                +CRLF
	cQuery += "FROM %SB1.SQLNAME%"                   +CRLF
	cQuery += "LEFT JOIN %SB2.SQLNAME%"              +CRLF
	cQuery += "ON B2_FILIAL = B1_FILIAL AND"         +CRLF
	cQuery += "   B2_COD = B1_COD AND"               +CRLF
	cQuery += "   B2_LOCAL = B1_LOCPAD AND"          +CRLF
	cQuery += "   %SB2.NOTDEL%"                      +CRLF
	cQuery += "WHERE B1_FILIAL = '%SB1.FILIAL%' AND" +CRLF
	cQuery += "      B1_COD = '"+cProduct+"' AND"    +CRLF
	cQuery += "      %SB1.NOTDEL%"                   +CRLF
	
	oSql:newAlias(cQuery)
	
	nUnitPrice := oSql:getValue("B1_PRV1")
	
	if nUnitPrice == 0
		nUnitPrice := oSql:getValue("B2_CM1")
	endif
	
	oSql:close()
	
return


/**
* Define os Logs de acordo com os tipos de arquivos
*/
static function setFileLog(cFile,cLogType,cLogText,cTag,cValue)

	local cInterface := "Invoice Request"

	oLog:start(APP_NULOGY,DHL_IMPORTACAO,cFile)

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


/*
** Aglutina conforme faturamento Modelo 2
*/
static function agglutProds(cPriceMO, cPriceIns, cPriceTot)
	local aKit		:= {}
	local aProdCust	:= {}
	local aProdDHL	:= {}
	local nJ		:= 0
	local nTotDHL	:= 0
	local cOPs		:= ""

	dividProds(@aKit, @aProdCust, @aProdDHL)

	for nJ:=1 to len(aProdDHL)
		cOPs	+= aProdDHL[nJ, OPS]
		nTotDHL += aProdDHL[nJ, TOT_PRICE]
	next nJ

	cPriceMO 	:= alltrim(Transform( aKit[1, TOT_PRICE], "@E 9,999,999,999,999.99"))
	cPriceIns 	:= alltrim(Transform( nTotDHL, "@E 9,999,999,999,999.99"))
	cPriceTot	:= alltrim(Transform( aKit[1, TOT_PRICE] + nTotDHL, "@E 9,999,999,999,999.99"))

	aKit[1,OPS] := aKit[1,OPS] + cOPs
	aKit[1,TOT_PRICE] += nTotDHL
	aKit[1,UNIT_PRICE]  := aKit[1,TOT_PRICE] / aKit[1,QUANTITY]

	for nJ:=1 to len(aProdCust)
		aadd(aKit, {aProdCust[nJ,PRODUCT], aProdCust[nJ,QUANTITY], aProdCust[nJ,OPS], aProdCust[nJ,UNIT_PRICE], aProdCust[nJ,TOT_PRICE]})
	next nJ

	aProducts := aClone(aKit)
return


/*
** Divide os produtos de acordo com as regras
*/
static function dividProds(aKit, aProdCust, aProdDHL)
	local oSql		:= IpSqlObject():newIpSqlObject()
	local nI 		:= 0
	local nUnitPrice:= 0
	local nTotPrice	:= 0

	for nI:=1 to len(aProducts)
		nUnitPrice := 0

		if oSql:getFieldValue("SB1", "B1_TIPO", " %SB1.XFILIAL% AND B1_COD = '"+aProducts[nI,PRODUCT]+"' ") $ 'PA'
			getUnitPrice(aProducts[nI,PRODUCT],@nUnitPrice)
			nTotPrice := A410Arred(aProducts[nI,QUANTITY] * nUnitPrice ,"C6_VALOR")

			aadd(aKit, {aProducts[nI,PRODUCT], aProducts[nI,2], aProducts[nI,OPS], nUnitPrice, nTotPrice})
		elseif oSql:getFieldValue("SB1", "B1_AGREGCU", " %SB1.XFILIAL% AND B1_COD = '"+aProducts[nI,PRODUCT]+"' ") $ '2'
			getUnitPrice(aProducts[nI,PRODUCT],@nUnitPrice)
			nTotPrice := A410Arred(aProducts[nI,QUANTITY] * nUnitPrice ,"C6_VALOR")

			aadd(aProdDHL, {aProducts[nI,PRODUCT], aProducts[nI,QUANTITY], aProducts[nI,OPS], nUnitPrice, nTotPrice})
		else
			getUnitPrice(aProducts[nI,PRODUCT],@nUnitPrice)
			nTotPrice := A410Arred(aProducts[nI,QUANTITY] * nUnitPrice ,"C6_VALOR")

			aadd(aProdCust, {aProducts[nI,PRODUCT], aProducts[nI,QUANTITY], aProducts[nI,OPS], nUnitPrice, nTotPrice})
		endif
	Next nI
return


/**
* Obtem a query dos itens do pedido de venda
*/
static function getQueryItens(cProduct, cLot)

	local cQuery := ""

	If !ProdutControlLote(cProduct)
		cLot := ""
	EndIf

	cQuery := "SELECT D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_ITEM,D1_VUNIT,D1_LOCAL,D1_TOTAL,D1_EMISSAO,B6_FILIAL,B6_PRODUTO,B6_QUANT, B6_DTDIGIT"
	cQuery += "       B6_CLIFOR,B6_LOJA,B6_PODER3,B6_TPCF,B6_TIPO,B6_IDENT,B6_PRUNIT,(B6_SALDO - B6_QULIB) B6_SALDO,F4_TESDV,F4_ZZTESFE, D1_LOTECTL, D1_DTVALID "
	cQuery += "FROM " + RetSqlName("SB6") + " SB6,"
	cQuery +=           RetSqlName("SD1") + " SD1,"
	cQuery +=           RetSqlName("SF4") + " SF4 "
	cQuery += "WHERE B6_FILIAL = '" + xFilial("SB6") + "' AND "
	cQuery += "      B6_PODER3 = 'R' AND "
	cQuery += "      B6_TPCF   = 'C' AND "
	cQuery += "      B6_TIPO   = 'D' AND "
	cQuery += "      (B6_SALDO - B6_QULIB)  > 0 AND "
	cQuery += " 	 SB6.D_E_L_E_T_ = ' ' AND "
	cQuery += "      D1_NUMSEQ = B6_IDENT AND "
	cQuery += "      D1_FILIAL = '" + xFilial("SD1") + "' AND "
	cQuery += "      D1_COD    = '" + cProduct + "' AND "

	if empty(cLot)
		cQuery += "      D1_LOTECTL    = '" + CriaVar("D1_LOTECTL", .f.) + "' AND "
	else
		cQuery += "      D1_LOTECTL    = '" + cLot + "' AND "
	endif

	cQuery += " SD1.D_E_L_E_T_ = ' ' AND "
	cQuery += "      F4_FILIAL = '" + xFilial("SF4") + "' AND "
	cQuery += "      F4_CODIGO = B6_TES AND "
	cQuery += " SF4.D_E_L_E_T_ = ' ' "

	if empty(cLot)
		cQuery += " ORDER BY B6_DTDIGIT "
	else
		cQuery += " ORDER BY D1_DTVALID "
	endif
	Memowrite( "c:\temp\SD1SB6SF4.SQL", cQuery )

return (cQuery)


/*
** Localiza cliente/fornecedor
*/
static function getCliFor(cProduct) //ALTERAR PARA PEGAR CAMPO NOVO RONI SILVA
	local cQuery := ""

	cQuery += " SELECT "

	if getDocType() <> 'B' .OR. getDocType() <> 'D'
		cQuery += " A1_COD CODIGO, A1_LOJA LOJA, A1_ZZMODFA MODELO3"
		cQuery += " FROM %SA7.SQLNAME% "
		cQuery += " INNER JOIN %SA1.SQLNAME% ON "
		cQuery += " 		A1_FILIAL 	= A7_FILIAL "
		cQuery += " 		AND A1_COD 		= A7_CLIENTE "
		cQuery += " 		AND A1_LOJA		= A7_LOJA "
		cQuery += " WHERE "
		cQuery += " 		A7_PRODUTO 	= '"+cProduct+"' "
		cQuery += " 		AND %SA7.XFILIAL% "
		cQuery += " 		AND %SA7.NOTDEL% "
	else
		cQuery += " A2_COD CODIGO, A2_LOJA LOJA"
		cQuery += " FROM %SA5.SQLNAME% "
		cQuery += " INNER JOIN %SA5.SQLNAME% ON "
		cQuery += " 		A1_FILIAL 		= A5_LOJA "
		cQuery += " 		AND A1_COD 		= A5_FORNECE "
		cQuery += " 		AND A1_LOJA		= A5_LOJA "
		cQuery += " WHERE "
		cQuery += " 		A5_PRODUTO 	= '"+cProduct+"' "
		cQuery += " 		AND %SA5.XFILIAL% "
		cQuery += " 		AND %SA5.NOTDEL% "
	endif

return (cQuery)


/*
** Verifica se produto é PA
*/
static function retInfoProd(cProduct, cField)
	local oSqlPA	:= IpSqlObject():newIpSqlObject()
	local cRet	:= ""

	cRet := oSqlPA:getFieldValue("SB1", cField, " %SB1.XFILIAL% AND B1_COD = '"+cProduct+"' ")

	oSqlPA:close()
return (cRet)



/**
* Coleta a Tes a ser utilizada
**/
static function getTes(oSql)
	
	local cTes  := ""
	local cTipo := getDocType()
	
	If cTipo == "D"
		cTes := GetMV("ZZ_TESSAI")
	Else
		cTes := iif(lTemPA, oSql:getValue("F4_TESDV"), oSql:getValue("F4_ZZTESFE"))
	EndIf
	
return cTes


/*
** Validação de saldo PA - SB8
*/
static function vldBalancePA(cProduct, cLot, dExpirDate, cTypeProd, nQuantity)
	local aAreaSB1 := SB1->(GetArea())
	local aAreaSB8 := SB8->(GetArea())
	Local lEmpPrev := If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)
	local nBalSB8  := 0
	local lRet     := .f.

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	if SB1->(dbSeek(xFilial("SB1") + PadR(cProduct, TamSx3("B1_COD")[1], '')))

		if alltrim(SB1->B1_RASTRO) $ "LS"
			dbSelectArea("SB8")
			SB8->(dbSetOrder(5)) //B8_FILIAL+B8_PRODUTO+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)

			if SB8->(dbSeek(xFilial("SB8") + SB1->B1_COD + PadR(cLot, TamSx3("B8_LOTECTL")[1], '') + CriaVar("B8_NUMLOTE", .f.) + dTos(dExpirDate)))
				nBalSB8 := SB8SALDO(,,,,,lEmpPrev,,,.T.)
			endif
			lRet := (nBalSB8 >= nQuantity)
		else
			cLot := space(TamSx3("B8_LOTECTL")[1])
			lRet := .t.
		endif
	endif
	RestArea(aAreaSB1)
	RestArea(aAreaSB8)

return (lRet)


/*
** Retorna OPs para o Pallet
*/
static function retOP(cPalleOrWO,lbusca)  //RONI SILVA PRECISA FAZER A CONSUTA PARA GRAVAR C6_ZZOP

	local oSql   := IpSqlObject():newIpSqlObject()
	local cRet   := ""
	local cQuery := ""
	local cField := ""
	local cPackingInd  := SuperGetMV("ZZ_PACKIND",,.F.)

	If cPackingInd .and. !lbusca
		cField = "D3_ZZPROJE"
	Elseif lbusca     //RONI SILVA D3_LOTECTL
		cField = "D3_LOTECTL"
//	Else
//		cField = "D3_ZZPALLE"
	EndIf

	cQuery += " SELECT DISTINCT D3_OP "
	cQuery += " FROM %SD3.SQLNAME%  "
	cQuery += " WHERE " + cField + " = '" + cPalleOrWO + "'"
	cQuery += "	AND %SD3.XFILIAL% "
	cQuery += "	AND %SD3.NOTDEL% "

	oSql:newAlias(cQuery)
	while oSql:notIsEof()
		cRet +=  alltrim(oSql:getValue("D3_OP")) +";"
		oSql:skip()
	enddo

	oSql:close()

return (cRet)


/*
** Verifica se pedido possuí PA
*/
static function validPA(cCodPrd)
	local aAreaSC6 	:= SC6->(GetArea())
	local oSql		:= IpSqlObject():NewIpSqlObject()

	if oSql:getFieldValue("SB1", "B1_TIPO", " %SB1.XFILIAL% AND B1_COD = '" + cCodPrd + "' ") == "PA"
		lTemPA := .T.
	endif

	RestArea(aAreaSC6)
return

/**
* Retorna se é um produto de terceiro ou próprio
* 1 - Terceiro
* 2 - Próprio
**/
Static Function GetTipoInsumo(cCodProd)
	
	Local oSqlSB1 	:= IpSqlObject():newIpSqlObject()
	Local cAgregCu	:= ""
	Local nAgregCu	:= 0
	
	oSqlSB1:newTable("SB1","B1_COD,B1_LOCPAD, B1_AGREGCU","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+cCodProd+"'")
	
	cAgregCu := oSql:getFieldValue("SB1","B1_AGREGCU","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+oSqlSB1:getValue("B1_COD")+"'")
	
	If !Empty(cAgregCu)
		nAgregCu := Val(cAgregCu)
	EndIf
	
	oSqlSB1:Close()
	
Return nAgregCu


/**
* Verifica se o produto controla lote
**/
Static Function ProdutControlLote(cProduct)
	
	local oSql				:= IpSqlObject():newIpSqlObject()
	Local cControlLote		:= ""
	Local lControla			:= .T.
	
	cControlLote := oSql:getFieldValue("SB1","B1_RASTRO","B1_FILIAL = '%SB1.FILIAL%' AND B1_COD = '" + cProduct + "'")
	
	If cControlLote == "N"
		lControla := .F.
	EndIf
	
	oSql:close()
	
Return lControla


/*
** Mantem o PA como ultima linha do pedido de venda
*/
static function ordenaPA(aGroupProd)
	local aAuxGroup 	:= aClone(aGroupProd)
	local aAuxPA		:= {}
	local nI			:= 0

	aGroupProd := {}

	for nI := 1 to len(aAuxGroup)
		if retInfoProd(aAuxGroup[nI, ARRAY_PRODUCT], "B1_TIPO") == "PA"
			aadd(aAuxPA, aClone(aAuxGroup[nI]))
		else
			aadd(aGroupProd, aClone(aAuxGroup[nI]))
		endif
	next nI

	if len(aAuxPA) > 0
		for nI := 1 to len(aAuxPA)
			aadd(aGroupProd, aClone(aAuxPA[nI]))
		next nI
	endif

return

/**
* Inclui o Pedido de Venda modelo 3
**/
static function incModelo3OutFlow(nBom)
	
	local aHeader := {}
	local cPriceMO	 := ""
	local cPriceIns	 := ""
	local cPriceTot	 := ""

	if FWUnitBusiness() == DHL_BUSINESSUNIT_MUL .and. getDocType() == "N"
		
		groupProducts()
		
		aRetorno := agglutModel3Prods(@cPriceMO, @cPriceIns, @cPriceTot)
		aKit	 := aRetorno[1]
		aProdCust:= aRetorno[2]
		
		if geraPedPV(aKit		, cPriceMO, cPriceIns, cPriceTot, COBRANCA_KIT)	 			 	 // GERA PEDIDO DE VENDAS PV1: COBRANÇA KIT
			oDHLModelo3:SetRecnPV1(SC5->(Recno()))
			oDHLModelo3:SetPV1(SC5->C5_NUM)
			if geraPedPV(aProdCust	, cPriceMO, cPriceIns, cPriceTot, RETORNO_INDUSTRIALIZACAO)	 // GERA PEDIDO DE VENDAS PV2: RETORNO DE INDUSTRIALIZAÇÃO
				oDHLModelo3:SetPV2(SC5->C5_NUM)
				oDHLModelo3:SetRecnPV2(SC5->(Recno()))
				
				oDHLModelo3:GravaSC5Amarracao()
				
			endIf
		endIf
	endIf

return
/**
 * Gera pedido de vendas modelo 3
 */
static function geraPedPV(aProduto, cPriceMO, cPriceIns, cPriceTot, cTipo)

	local aDetails	:= GetDetail(aProduto)
	local aHeader	:= GetHeader(cPriceMO, cPriceIns, cPriceTot, cTipo)
	local lStatus	:= .t.
	local i := 1

	cDetails := ""

	For ni = 1 to Len(aDetails)

		For i = 1 to Len(aDetails[ni])
			cDetails += aDetails[ni][i][1]+chr(13)+chr(10)
			cDetails += iif(valtype(aDetails[ni][i][2]) == "N",str(aDetails[ni][i][2]),aDetails[ni][i][2])+chr(13)+chr(10)
		Next
	next

	MSExecAuto({|x, y, z| Mata410(x, y, z)}, aHeader, aDetails, 3)

	if lMsErroAuto
		if !IsBlind()
			mostraerro()
		endif
		DisarmTransaction()
		setFileLog(cFile,"fail","Falha ao incluir o pedido de vendas"+CRLF+CRLF+oUtils:getErroAuto())
		lStatus := .f.
	endIf

return lStatus

/**
 * Obtém o aHeader do pedido de vendas modelo 3
 */
static function GetHeader(cPriceMO, cPriceIns, cPriceTot, cTipo)

	local aHeader := {}

	aAdd(aHeader,{"C5_TIPO"   , "N"                          ,nil})
	aAdd(aHeader,{"C5_CLIENTE", cCliFor  ,nil})
	aAdd(aHeader,{"C5_LOJACLI", cLoja ,nil})
	aAdd(aHeader,{"C5_CONDPAG", GetMV("ZZ_CONDINT")          ,nil})
	aAdd(aHeader,{"C5_ZZSHIP" , cShipping                    ,nil})
//	aAdd(aHeader,{"C5_ZZSTATU", DHL_PV_PENDENTE_INFORMACAO   ,nil})
	aAdd(aHeader,{"C5_ZZTIPO" , getDocType()   				 ,nil})
	aAdd(aHeader,{"C5_ZZTPPV" , cTipo   				 	,nil})

	//GRAVAÇÃO NO CAMPO C5_ZZMSGIN SOMENTE PARA O PV1
	if cTipo == COBRANCA_KIT

		if !empty(cPriceMO) .and. !empty(cPriceIns) .and. !empty(cPriceTot)
			aAdd(aHeader,{"C5_ZZMSGIN" , "Valor total cobrado: R$ "+cPriceTot+" (insumos empregados: R$ "+cPriceIns+" e mão-de-obra aplicada: R$"+cPriceMO+").", nil})
		endif
	else
		aAdd(aHeader,{"C5_ZZMSGIN" , "", nil})
	endIf

return aHeader

/**
 * Obtém os itens do pedido de vendas para o MODELO 3
**/
static function getDetail(aProduto)
	
	local nI		:= 0
	local cItem     := Replicate("0",Len(SC6->C6_ITEM))
	local cProduct 	:= ""
	local cOP		:= "" 
	local cTesSaida	:= GetMV("ZZ_TESSAI")
	local nQuantity	:= 0
	local nUnitPrice:= 0
	local nTotPrice	:= 0
	local aDetails	:= {}
	local aDetail	:= {}
	Local cPackingInd  := SuperGetMV("ZZ_PACKIND",,.F.)

	for nI := 1 to Len(aProduto)
		
		aDetail   := {}
		cItem     := Soma1(cItem)
		cProduct  := aProduto[nI,PRODUCT]
		nQuantity := aProduto[nI,QUANTITY]
		cTypeProd := retInfoProd(cProduct, "B1_TIPO")
		cOP 	   := ""

		if (cTypeProd == "PA")
			If cPackingInd
				lbusca := .f.
				cOP := retOP(aBoms[1,WORK_ORDER],lbusca)
			Else
				lbusca := .f.
				cOP := retOP(aProduto[nI,ARRAY_PALLET],lbusca)

			EndIf
		else //RONI SILVA 
			lbusca := .t.
		    cOP := retOP(aProduto[nI,OPS],lbusca)	
		ENDIF

//		cOP       := aProduto[nI,OPS]        //RONI SILVA AJUSTE DA OP
		nUnitPrice:= aProduto[nI,UNIT_PRICE]
		nTotPrice := aProduto[nI,TOT_PRICE]
		cLot 	  := aProduto[nI,ARRAY_LOT]
		cTypeProd := retInfoProd(cProduct, "B1_TIPO")

		cQuery	:= getQueryItens(cProduct, cLot) //RONI silva

//			cQuery	:= getQueryItens()
		
			oSql:newAlias(cQuery)

			nSld := nQuantity

			if oSql:hasRecords()
				while oSql:notIsEof()
			
					lTemPoder3 := .T.
					
					aDetail := {}
					
					nVlrParcial:= 0
					nVlrUnit := 0
					nSldTotal := 0
					
					if nSld <= oSql:getValue("B6_SALDO")
						nSaldo 		:= nSld
					else
						nSaldo 		:= oSql:getValue("B6_SALDO")
					endif
					
					if nSaldo < oSql:getValue("B6_QUANT")
						nSldTotal 	:= oSql:getValue("B6_QUANT")
						
					endif
										
					aAdd(aDetail,{"C6_ITEM"   ,@cItem                      ,nil})
					aAdd(aDetail,{"C6_PRODUTO",cProduct,nil})
					aAdd(aDetail,{"C6_UM"     , UnitMeasure(cProduct)  ,nil})
					aAdd(aDetail,{"C6_QTDVEN" ,nSaldo                     ,nil})
					aAdd(aDetail,{"C6_PRCVEN" ,oSql:getValue("D1_VUNIT")  ,nil})
					aAdd(aDetail,{"C6_VALOR"  ,round(nSaldo*oSql:getValue("D1_VUNIT"),2),nil})
//					aAdd(aDetail,{"C6_QTDLIB" ,nSaldo                     ,nil})
					cTesSaida := iif(lTemPA, oSql:getValue("F4_TESDV"), oSql:getValue("F4_ZZTESFE"))
					cTesSaida := iif(empty(cTesSaida),retInfoProd(cProduct, "B1_TS"),cTesSaida)
					cTesSaida := iif(empty(cTesSaida),GetMV("ZZ_TESSAI"),cTesSaida)
					aAdd(aDetail,{"C6_TES"    ,cTesSaida             ,nil})
//					aAdd(aDetail, {"C6_ZZOP"   , cOP, nil})	
					if ProdutControlLote(cProduct) .and. cTypeProd == "PA"
						aAdd(aDetail, {"C6_LOTECTL", cLot					,nil})
			//			aAdd(aDetail, {"C6_DTVALID", dExpirDate				,nil})
					endif			

//					aAdd(aDetail,{"C6_LOCAL"  ,oSql:getValue("D1_LOCAL")  ,nil})
					aAdd(aDetail,{"C6_NFORI"  ,oSql:getValue("D1_DOC")    ,nil})
					aAdd(aDetail,{"C6_SERIORI",oSql:getValue("D1_SERIE")  ,nil})
					aAdd(aDetail,{"C6_ITEMORI",oSql:getValue("D1_ITEM")   ,nil})
					aAdd(aDetail,{"C6_IDENTB6",oSql:getValue("B6_IDENT")  ,nil})

//					montaItens(@aDetail)
					
					aAdd(aDetails,aDetail)
					
					nSld -= iif(nSld <= oSql:getValue("B6_SALDO"),nSld,oSql:getValue("B6_SALDO"))
						
					if nSld == 0
						exit
					else
						cItem := Soma1(cItem)
					endif
				
					oSql:skip()
				
				enddo
			
				if nSld > 0
					lTemPoder3 := .F.
					exit
				endif
			else
			cTesSaida := iif(lTemPA, oSql:getValue("F4_TESDV"), oSql:getValue("F4_ZZTESFE"))
			cTesSaida := iif(empty(cTesSaida),retInfoProd(cProduct, "B1_TS"),cTesSaida)
			cTesSaida := iif(empty(cTesSaida),GetMV("ZZ_TESSAI"),cTesSaida)

			aAdd(aDetail, {"C6_ITEM"   , cItem                  ,nil})
			aAdd(aDetail, {"C6_PRODUTO", cProduct               ,nil})
			aAdd(aDetail, {"C6_UM"     , UnitMeasure(cProduct)  ,nil})
			aAdd(aDetail, {"C6_QTDVEN" , nQuantity              ,nil})
			aAdd(aDetail, {"C6_PRCVEN" , nUnitPrice 			,nil})
			aAdd(aDetail, {"C6_VALOR"  , round(nQuantity*nUnitPrice,2) ,nil})
			aAdd(aDetail, {"C6_TES"    , cTesSaida			    ,nil})
			aAdd(aDetail, {"C6_ZZOP"   , cOP, nil})
//			if nI == 1
				aAdd(aDetail, {"C6_PRUNIT"   , nTotPrice/nQuantity, nil})
//			endif
			if ProdutControlLote(cProduct) .and. cTypeProd == "PA"
				aAdd(aDetail, {"C6_LOTECTL", cLot					,nil})
	//			aAdd(aDetail, {"C6_DTVALID", dExpirDate				,nil})
			ELSE
				aAdd(aDetail,{"C6_LOCAL"  ,oSql:getValue("D1_LOCAL")  ,nil})
				aAdd(aDetail,{"C6_NFORI"  ,oSql:getValue("D1_DOC")    ,nil})
				aAdd(aDetail,{"C6_SERIORI",oSql:getValue("D1_SERIE")  ,nil})
				aAdd(aDetail,{"C6_ITEMORI",oSql:getValue("D1_ITEM")   ,nil})
				aAdd(aDetail,{"C6_IDENTB6",oSql:getValue("B6_IDENT")  ,nil})
			endif
			aAdd(aDetails,aDetail)

		ENDIF
	NEXT


//RONI SILVA ANTES
/*

		cTesSaida := iif(lTemPA, oSql:getValue("F4_TESDV"), oSql:getValue("F4_ZZTESFE"))
		cTesSaida := iif(empty(cTesSaida),retInfoProd(cProduct, "B1_TS"),cTesSaida)
		cTesSaida := iif(empty(cTesSaida),GetMV("ZZ_TESSAI"),cTesSaida)

		aAdd(aDetail, {"C6_ITEM"   , cItem                  ,nil})
		aAdd(aDetail, {"C6_PRODUTO", cProduct               ,nil})
		aAdd(aDetail, {"C6_UM"     , UnitMeasure(cProduct)  ,nil})
		aAdd(aDetail, {"C6_QTDVEN" , nQuantity              ,nil})
		aAdd(aDetail, {"C6_PRCVEN" , nUnitPrice 			,nil})
		aAdd(aDetail, {"C6_VALOR"  , nTotPrice				,nil})
		aAdd(aDetail, {"C6_TES"    , cTesSaida			    ,nil})
		aAdd(aDetail, {"C6_ZZOP"   , cOP, nil})
		//if nI == 1
			aAdd(aDetail, {"C6_PRUNIT"   , nTotPrice/nQuantity, nil})
		//endif
		if ProdutControlLote(cProduct) .and. cTypeProd == "PA"

			aAdd(aDetail, {"C6_LOTECTL", cLot					,nil})
//			aAdd(aDetail, {"C6_DTVALID", dExpirDate				,nil})
		ELSE
			aAdd(aDetail,{"C6_LOCAL"  ,oSql:getValue("D1_LOCAL")  ,nil})
			aAdd(aDetail,{"C6_NFORI"  ,oSql:getValue("D1_DOC")    ,nil})
			aAdd(aDetail,{"C6_SERIORI",oSql:getValue("D1_SERIE")  ,nil})
			aAdd(aDetail,{"C6_ITEMORI",oSql:getValue("D1_ITEM")   ,nil})
			aAdd(aDetail,{"C6_IDENTB6",oSql:getValue("B6_IDENT")  ,nil})
		endif
		aAdd(aDetails,aDetail)
		
	next nI
*/

return aDetails


/*
** Aglutina conforme faturamento Modelo 3
*/
static function agglutModel3Prods(cPriceMO, cPriceIns, cPriceTot)

	local aKit		:= {}
	local aProdCust	:= {}
	local aProdDHL	:= {}
	local nJ		:= 0
	local nTotDHL	:= 0
	local cOPs		:= ""

	dividProds(@aKit, @aProdCust, @aProdDHL)
	aglutInsProprio(aProdDHL, aKit)

	for nJ:=1 to len(aProdDHL)
		cOPs	+= aProdDHL[nJ, OPS]
		nTotDHL += aProdDHL[nJ, TOT_PRICE]
	next nJ

	cPriceMO 	:= alltrim(Transform( oDHLModelo3:GetVlrKIT()			, "@E 9,999,999,999,999.99"))
	cPriceIns 	:= alltrim(Transform( oDHLModelo3:GetVlrTotInsumoDHL()	, "@E 9,999,999,999,999.99"))
	cPriceTot	:= alltrim(Transform( oDHLModelo3:GetVlrTot()			, "@E 9,999,999,999,999.99"))

return {aKit, aProdCust}

/*
** Aglutina os produtos DHL com o KIT
*/
static function aglutInsProprio(aProdDHL, aKit)

	local nI 			:= 0
	local cProduto 		:= ""
	local aNewProdDHL 	:= {}
	local cBom			:= aKit[1][1]
	local nQuantPA		:= aKit[1][2]
	local nPrecoUnit	:= aKit[1][4]
	local nTotalPa		:= aKit[1][5]
	local nTotalItem	:= 0
	local nPrecoUnitItem:= 0

	//SOMA TOTAL INSUMO PROPRIO
	for nI := 1 to len(aProdDHL)

		nTotalItem += aProdDHL[nI][5]

	next nI

	//SALVA O TOTAL DOS INSUMOS
	oDHLModelo3:SetVlrTotInsumoDHL(nTotalItem)

	//SOMA O TOTAL INSUMO PROPRIO COM O PA
	nTotalItem += nTotalPa

	//DIVIDE TOTAL PELA QTD PA
	nPrecoUnitItem := nTotalItem / nQuantPA

	//ATUALIZA O PRECO UNITÁRIO E TOTAL DO KIT
	aKit[1][4] :=  nPrecoUnitItem
	aKit[1][5] :=  nTotalItem

	//SALVA O VALOR DO PA
	oDHLModelo3:SetVlrKIT(nTotalPa)

	//SALVA O VALOR TOTAO COBRADO
	oDHLModelo3:SetVlrTot(nTotalItem)

return


/**
* Abre as tabelas. Necessário, pois na segunda iteração da nota estava dando ajustar DOC_SEQ.
* É necessário abrir as 3 tabelas
**/
static function abreTabelas()
	
	local lStatus := .F.
	
	If Select('SD1') <= 0
		dbSelectArea('SD1')
	EndIf
	If Select('SD2') <= 0
		dbSelectArea('SD2')
	EndIf
	If Select('SD3') <= 0
		dbSelectArea('SD3')
	EndIf
	
	lStatus := (Select('SD1')>0) .And. (Select('SD2')>0) .And. (Select('SD3')>0)
	
return

/**
 * Obtem as arrays da rotina automática de pedido de venda
 */
static function getDadosPedVenda(aCab,aItens,cTipoNf)

	local cItem  	:= StrZero(0,TamSx3("C6_ITEM")[1])
	local cTes	 	:= ""
	local aAux   	:= {}
	local aAuxOrd	:= {}
	local aSC6   	:= SC6->(GetArea())
	local cQuery 	:= ""
	local oSql   	:= IpSqlObject():newIpSqlObject()
	local oLogImp   := DHLLogManager():newDHLLogManager()
	local nSld   	:= 0
	local cTipo  	:= ""
	local nSaldo 	:= 0
	local nVlrParcial, nVlrUnit, nSldTotal := 0

	default cTipoNf := ""

	if aCodLoja[POS_TIPO] == "cliente"
		cTipo := "N"
	else
		cTipo := "B"
	endif

	if FWUnitBusiness() == DHL_BUSINESSUNIT_PKG .OR. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
		if cTipo $ "B"
			if SC5->C5_ZZTIPO $ "D"
				cTipoNf := "D"
			endif
		else
			cTipoNf := cTipo
		endif
	endif

	aAdd(aCab,{"C5_FILIAL" ,SC5->C5_FILIAL       ,nil})
	aAdd(aCab,{"C5_NUM"    ,SC5->C5_NUM          ,nil})
	aAdd(aCab,{"C5_TIPO"   ,cTipo                ,nil})
	aAdd(aCab,{"C5_CLIENTE",aCodLoja[POS_CLIENTE],nil})
	aAdd(aCab,{"C5_LOJACLI",aCodLoja[POS_LOJA]   ,nil})
	aAdd(aCab,{"C5_CONDPAG",SC5->C5_CONDPAG      ,nil})

	if FWUnitBusiness() == DHL_BUSINESSUNIT_PKG .OR. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
		aAdd(aCab,{"C5_ZZSTATU",""               ,nil})
	endif

	dbSelectArea("SC6")
	dbSetOrder(1)
	SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))

	while SC6->C6_NUM == SC5->C5_NUM
		aAux := {}

		aAdd(aAux,{"LINPOS"   ,"C6_ITEM",SC6->C6_ITEM})
		aAdd(aAux,{"AUTDELETA","S" 		,nil})

		aAdd(aItens,aAux)

		SC6->(dbSkip())
	enddo

	SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))

	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL

		while SC6->C6_NUM == SC5->C5_NUM

			if oSql:IsEof()
				lTemID := .F.
				exit
			endif

			cQuery := getQueryID()

			oSql:newAlias(cQuery)

			while oSql:notIsEof() .and. SC6->C6_PRODUTO == oSql:getValue("Z3_PRODUTO")

				aAux := {}

				aAdd(aAux,{"C6_ITEM"   ,SC6->C6_ITEM               ,nil})
				aAdd(aAux,{"C6_PRODUTO",SC6->C6_PRODUTO            ,nil})
				aAdd(aAux,{"C6_QTDVEN" ,SC6->C6_QTDVEN             ,nil})
				aAdd(aAux,{"C6_PRCVEN" ,oSql:getValue("Z3_VUNIT")  ,nil})
				aAdd(aAux,{"C6_TES"    ,getTes(@oSql)              ,nil})
				aAdd(aAux,{"C6_LOCAL"  ,oSql:getValue("D1_LOCAL")  ,nil})
				aAdd(aAux,{"C6_NFORI"  ,oSql:getValue("Z3_DOC")    ,nil})
				aAdd(aAux,{"C6_SERIORI",oSql:getValue("Z3_SERIE")  ,nil})
				aAdd(aAux,{"C6_ITEMORI",oSql:getValue("Z3_ITEM")   ,nil})
				aAdd(aAux,{"C6_IDENTB6",oSql:getValue("Z3_IDENTB6"),nil})
				aAdd(aAux,{"C6_ZZID"   ,oSql:getValue("Z3_ID")     ,nil})

				aAdd(aItens,aAux)

				SC6->(dbSkip())

				oSql:skip()

			enddo
		enddo

		oSql:close()

	else

		validPA()

		while SC6->C6_NUM == SC5->C5_NUM

			nSld := SC6->C6_QTDVEN

			cQuery	:= getQueryItens()

			oSql:newAlias(cQuery)
			if oSql:hasRecords()
				while oSql:notIsEof()

					lTemPoder3 := .T.

					aAux := {}

					nVlrParcial:= 0
					nVlrUnit := 0
					nSldTotal := 0

					if nSld <= oSql:getValue("B6_SALDO")
						nSaldo 		:= nSld
					else
						nSaldo 		:= oSql:getValue("B6_SALDO")
					endif

					if nSaldo < oSql:getValue("B6_QUANT")
						nSldTotal 	:= oSql:getValue("B6_QUANT")

						nVlrUnit    := oSql:getValue("D1_VUNIT")
						nVlrParcial := nVlrUnit * nSaldo
					else
						nVlrParcial	:= oSql:getValue("D1_TOTAL")
						nVlrUnit 	:= nVlrParcial / nSaldo
					endif

					if nSaldo * A410Arred(nVlrUnit ,"C6_PRCVEN") < 0.01
						oLogImp:start("PV","PV","")
						oLogImp:warn("REGISTRO IGNORADO PEDIDO "+SC5->C5_NUM, "Valor total item "+oSql:getValue("B6_PRODUTO")+" para NF "+oSql:getValue("D1_DOC")+;
							"/"+oSql:getValue("D1_SERIE")+" não atingiu valor minimo 0,01.")
						oSql:skip()
						loop
					endif

					cItem := Soma1(cItem)

					aAdd(aAux,{"C6_ITEM"   ,cItem                      ,nil})
					aAdd(aAux,{"C6_PRODUTO",oSql:getValue("B6_PRODUTO"),nil})
					aAdd(aAux,{"C6_QTDVEN" ,nSaldo                     ,nil})
					aAdd(aAux,{"C6_PRCVEN" ,A410Arred(nVlrUnit ,"C6_PRCVEN")  ,nil})
					aAdd(aAux,{"C6_VALOR"  ,A410Arred(nVlrParcial,"C6_VALOR"),nil})
					aAdd(aAux,{"C6_QTDLIB" ,nSaldo                     ,nil})
					aAdd(aAux,{"C6_TES"    ,getTes(@oSql)              ,nil})
					aAdd(aAux,{"C6_LOCAL"  ,oSql:getValue("D1_LOCAL")  ,nil})
					aAdd(aAux,{"C6_NFORI"  ,oSql:getValue("D1_DOC")    ,nil})
					aAdd(aAux,{"C6_SERIORI",oSql:getValue("D1_SERIE")  ,nil})
					aAdd(aAux,{"C6_ITEMORI",oSql:getValue("D1_ITEM")   ,nil})
					aAdd(aAux,{"C6_IDENTB6",oSql:getValue("B6_IDENT")  ,nil})
					aAdd(aAux,{"C6_LOTECTL",oSql:getValue("D1_LOTECTL"),nil})
					aAdd(aAux,{"C6_DTVALID",oSql:getValue("D1_DTVALID"),nil})

					montaItens(@aAux)

					aAdd(aItens,aAux)

					nSld -= iif(nSld <= oSql:getValue("B6_SALDO"),nSld,oSql:getValue("B6_SALDO"))

					if nSld == 0
						exit
					endif

					oSql:skip()

				enddo
				if nSld > 0
					lTemPoder3 := .F.
					exit
				endif
			elseIf GetTipoInsumo(SC6->C6_PRODUTO) == PROPRIO .AND. upper(alltrim(SC5->C5_ZZESPEC)) == DHL_ESPECIE_INVENTARIO

				lProprio := .T.
				oSql:close()
				return

			ElseIf GetTipoInsumo(SC6->C6_PRODUTO) == TERCEIRO
				lTemPoder3 := .F.
				oSql:close()
				return

			Else

				aAux := {}

				cItem := Soma1(cItem)

				cTes := getTesProd(SC6->C6_PRODUTO)

				aAdd(aAux,{"C6_ITEM"   ,cItem                      	,nil})
				aAdd(aAux,{"C6_PRODUTO",SC6->C6_PRODUTO				,nil})
				aAdd(aAux,{"C6_QTDVEN" ,SC6->C6_QTDVEN              ,nil})
				aAdd(aAux,{"C6_PRCVEN" ,SC6->C6_PRCVEN  			,nil})
				aAdd(aAux,{"C6_VALOR"  ,A410Arred(SC6->C6_QTDVEN * SC6->C6_PRCVEN ,"C6_VALOR"),nil})
				aAdd(aAux,{"C6_QTDLIB" ,SC6->C6_QTDVEN                     ,nil})
				aAdd(aAux,{"C6_TES"    ,if (empty(alltrim(cTes)), SC6->C6_TES, cTes) ,nil})
				aAdd(aAux,{"C6_LOCAL"  ,SC6->C6_LOCAL  				,nil})
				aAdd(aAux,{"C6_NFORI"  ,SC6->C6_NFORI    			,nil})
				aAdd(aAux,{"C6_SERIORI",SC6->C6_SERIORI  			,nil})
				aAdd(aAux,{"C6_ITEMORI",SC6->C6_ITEMORI   			,nil})
				aAdd(aAux,{"C6_IDENTB6",SC6->C6_IDENTB6  			,nil})
				aAdd(aAux,{"C6_PRUNIT" ,SC6->C6_PRUNIT  			,nil})

				montaItens(@aAux)

				aAdd(aItens,aAux)

			endif

			oSql:close()

			SC6->(dbSkip())
		enddo

	endif

	RestArea(aSC6)

return

/**
* Inclui conteúdo no array de alteração da rotina automática. Para contemplar todos os campos.
**/
static function montaItens(aAux)

	local nCount	:= 0
	local aCposSX3	:= FWSX3Util():GetAllFields("SC6",.f.)
	
	for nCount := 1 to len(aCposSX3)
	
		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U"
			aAdd(aAux,{AllTrim(aCposSX3[nCount]),&("SC6->" + AllTrim(aCposSX3[nCount])),nil})
		endIf
	
	next nCount
	
return
