#include "totvs.ch"
#include "rwmake.ch"
#include "dhl.ch"

#define PRODUCT_BOM  1
#define QUANTITY_BOM 2
#define WORK_ORDER   3
#define FILEITEM     4

#define PRODUCT      1
#define QUANTITY     2

#define SALDO_B2	0
#define SALDO_B6	0
#define SALDO_B8	0


/*/{Protheus.doc} DisInvReq

Rotina responsável por ler e processar a interface Invoice Request e atualizar os dados referentes ao documento.
Processo para Unidade de Negócio DIS(Pfizer).

@author Winston Dellano de Castro
@since 13/11/2014

@param cFilePath, String, Arquivo a ser processado
/*/
user function DisInvReq(cFilePath)

	local lValid        := .T.
	local nBom          := 0
	local lOk			:= .T.

	private oLogImp     := DHLLogManager():newDHLLogManager()
	private cShipping   := getShipping()
	private cCnpjCli    := getCnpjCustomer()
	private cSalesOrd   := getSalesOrder()

	// === ANTES ===
	//      cDepositor  := atencao: No final do campo <SALES_ORDER>: podera ser '-PU', '-WU', '-P' ou '-W'
	//private cDepositor  := UPPER(right(cSalesOrd,2))
	//cDepositor  := iif( cDepositor $ "PUxWU", subs( cDepositor,1,1), subs( cDepositor,2,1) )
	//private aDepositor  := { { 'P', '000044', '01' }, { 'W', '000046', '01'} }

	// === DEPOIS ===
	//      cDepositor  := atencao: No final do campo <SALES_ORDER>: podera ser '-PU', '-WU', '-P' ou '-W'
	private cDepositor  := SubStr(cSalesOrd,RAt("-",cSalesOrd)+1,1)
	private aDepositor	:= getDepositors()

	private nDepositor  := Ascan( aDepositor, { |x| x[1] == cDepositor })
	private cForneced   := iif( nDepositor > 0, aDepositor[ nDepositor][2], '' )
	private cLojaFor    := iif( nDepositor > 0, aDepositor[ nDepositor][3], '' )
	private cDepSubst   := iif( nDepositor > 0, aDepositor[ nDepositor][4], '' )
	private cLojDepSubst:= iif( nDepositor > 0, aDepositor[ nDepositor][5], '' )
	private cFile       := cFilePath
	private cProds		:= ""
	private nNetWeight	:= getNetWeight()
	private nGrossWeight:= getGrossWeight()
	private nVolume		:= getVolume()
	private aProducts   := retProducts()
	private lMsErroAuto := .F.
	private lTemPoder3	:= .T.

	private aDetails2        := {}
	private aDetails         := {}
	private cCliFor			 := ""
	private cLoja			 := ""
	private	cEmail			 := ""
	private cProductionOrder := ""
	private cIdOp			 := ""
	private cItem            := ""
	private cDeliveryCust	 := ""
	private cBranchCust		 := ""
	private cInscri			 := ""
	private cContrib		 := ""

	createOraclTable()

	BEGIN TRANSACTION
		BEGIN SEQUENCE
			if validOrder()
				if incCustomer()
					lOk := incOutflowOrder()
				else
					lOk := .f.
				endif
				if !(lOK)
					BREAK
				endif
			else
				lOk := .f.
			endif
			RECOVER
			DisarmTransaction()
		END SEQUENCE
	END TRANSACTION

return lOk


/**
* Coleta os Items da interface Invoice Request
**/
static function retProducts()

	local aItems       := {}
	local nItem        := 1
	local nLenItem     := 0

	if ValType(oXml:_INV_REQ:_BODY) <> nil
		if ValType(oXml:_INV_REQ:_BODY:_FILEITEM) == "A"

			nLenItem := Len(oXml:_INV_REQ:_BODY:_FILEITEM)
			aItems   := {}

			for nItem := 1 to nLenItem
				aAdd(aItems,{getProduct(@nItem),getQuantity(@nItem), getLote(@nItem)})
			next

		elseif ValType(oXml:_INV_REQ:_BODY:_FILEITEM) == "O"

			nItem	:= 0
			aItems  := {}
			aAdd(aItems,{getProduct(@nItem),getQuantity(@nItem), getLote(@nItem)})

		endif

	else
		aAdd(aItems,{})
	endif

return aItems


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
* Coleta o Produto
**/
static function getProduct(nItem)
	local xRet := ""

	if nItem > 0
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEITEM[nItem]:_ITEM:TEXT)
	else
		xRet := AllTrim(oXml:_INV_REQ:_BODY:_FILEITEM:_ITEM:TEXT)
	endif
return (xRet)


/**
* Coleta a Quantidade
**/
static function getQuantity(nItem)
	local xRet := ""

	if nItem > 0
		xRet := Val(oXml:_INV_REQ:_BODY:_FILEITEM[nItem]:_QUANTITY:TEXT)
	else
		xRet := Val(oXml:_INV_REQ:_BODY:_FILEITEM:_QUANTITY:TEXT)
	endif
return (xRet)


/**
* Coleta a Quantidade
**/
static function getLote(nItem)
	local xRet := ""

	if nItem > 0
		xRet := oXml:_INV_REQ:_BODY:_FILEITEM[nItem]:_LOT:TEXT
	else
		xRet := oXml:_INV_REQ:_BODY:_FILEITEM:_LOT:TEXT
	endif
return (xRet)



/**
* Coleta a unidade de medida do Produto
**/
static function UnitMeasure(cProduct)
return AllTrim(oSql:getFieldValue("SB1","B1_UM","B1_FILIAL = '%SB1.FILIAL%' AND B1_COD = '" + cProduct + "'"))


/**
* Inclui o Pedido de Venda
**/
static function incOutflowOrder()

	local aHeader		:= {} 
	local lOk			:= .t.	
	local aErrorSaldo 	:= {}	
	local aErrorBalanc  := {}
	local aErrorSC6Qtd  := {}
	local cErrorSaldo	:= ""
	local cErrorBalanc  := ""
	local cErrorSC6Qtd  := ""

	mountDetail()

	if getNewPar("ZZ_ISPRPFI", .T.)  
		if (lTemPoder3)
			if len(aDetails) > 0
				if isSaldoSuf(aDetails, aErrorSaldo)
					if verifyBalancTables(aDetails, aErrorBalanc)
						if !isCanCreateInv(aDetails, aErrorSC6Qtd)
							cErrorSC6Qtd := arrayToStr(aErrorSC6Qtd)
							DisarmTransaction()
							setFileLog(cFile,"fail", cErrorSC6Qtd)
							lOk := .f.					
						endIf
					else
						cErrorBalanc := arrayToStr(aErrorBalanc)
						DisarmTransaction()
						setFileLog(cFile,"fail", cErrorBalanc)
						lOk := .f.				
					endIf
				else
					cErrorSaldo := arrayToStr(aErrorSaldo)
					DisarmTransaction()
					setFileLog(cFile,"fail", cErrorSaldo)
					lOk := .f.			
				endIf	

				saveLog(fwxFilial("SC5"), allTrim(upper(cShipping)), dTos(dDataBase), time(), "INV.REQUEST" , lOk, )
						
				if !(lOk) 
					return (lOk) 
				endIf
			endIf
		else
			DisarmTransaction()
			saveLog(fwxFilial("SC5"), allTrim(upper(cShipping)), dTos(dDataBase), time(), "INV.REQUEST" , .F.)
		endIf		
	endIf

	aAdd(aHeader,{"C5_TIPO"   , getDocType()                 ,nil})
	aAdd(aHeader,{"C5_CLIENTE", cCliFor  					 ,nil})
	aAdd(aHeader,{"C5_LOJACLI", cLoja 						 ,nil})
	if !empty(cDeliveryCust)
		aAdd(aHeader,{"C5_CLIENT"	, cDeliveryCust					 ,nil})
		aAdd(aHeader,{"C5_LOJAENT"	, cBranchCust 					 ,nil})
	endif
	aAdd(aHeader,{"C5_CONDPAG" , GetMV("ZZ_CONDINT")          ,nil})
	aAdd(aHeader,{"C5_PESOL"   , nNetWeight         		  ,nil})
	aAdd(aHeader,{"C5_PBRUTO"  , nGrossWeight          		  ,nil})
	aAdd(aHeader,{"C5_VOLUME1" , nVolume          			  ,nil})
	aAdd(aHeader,{"C5_ZZSHIP"  , cShipping                    ,nil})
	aAdd(aHeader,{"C5_ZZTIPO"  , getDocType()   			  ,nil})
	aAdd(aHeader,{"C5_ZZORDEX" , getSalesOrder()			  ,nil})
	aAdd(aHeader,{"C5_TRANSP"  , GetNewPar("ZZ_TRANPAD","")   ,nil})
	aAdd(aHeader,{"C5_TPFRETE" , "T"			              ,nil})
	aAdd(aHeader,{"C5_ZZCEGED" , getCEGEDIM()				  ,nil})
	
	if !(lTemPoder3)
		DisarmTransaction()
		setFileLog(cFile,"fail","Não há saldo em poder de terceiros para os itens do pedido " + CRLF + CRLF + cProds + CRLF + CRLF + oUtils:getErroAuto())
		lOk := .f.
		return (lOk) 
	endif

	MSExecAuto({|x, y, z| Mata410(x, y, z)}, aHeader, aDetails, 3)

	if lMsErroAuto
		lOk := .f.
		DisarmTransaction()
		setFileLog(cFile,"fail","Falha ao incluir o pedido de vendas"+CRLF+CRLF+oUtils:getErroAuto())
	else
		if len(aDetails2) > 0
			MSExecAuto({|x, y, z| Mata410(x, y, z)}, aHeader, aDetails2, 3)
			if lMsErroAuto
				lOk := .f.
				DisarmTransaction()
				setFileLog(cFile,"fail","Falha ao incluir o pedido de vendas"+CRLF+CRLF+oUtils:getErroAuto())
			endif
		endif	
	endIf



return (lOk) 


/**
* Monta os Itens do Pedido de Venda
**/
static function mountDetail()

	local nI		:= 0
	local nUnitPrice:= 0
	local nQuantity := 0
	local nTotPrice	:= 0
	local nSld   	:= 0
	local nSaldo 	:= 0
	local nVlrParcial, nVlrUnit, nSldTotal := 0
	local cProduct  := ""
	local cOP		:= ""
	local cQuery	:= ""
	local cCliAux	:= ""
	local cLojAux	:= ""
	local lArray2	:= ""
	local lSubst	:= !Empty(cDepSubst) .and. !Empty(cLojDepSubst)

	aDetails  := {}
	aDetails2 := {}

	groupProducts()

	for nI := 1 to Len(aProducts)
		lArray2 := .f.

		cProduct  := aProducts[nI,1]
		nQuantity := aProducts[nI,2]
		cLote	  := aProducts[nI,3]

		cQuery := getQueryItens(cProduct, cLote, cForneced, cLojaFor, cDepSubst, cLojDepSubst)
		oSql:newAlias(cQuery)

		nSld := nQuantity

		if oSql:hasRecords()
			if nI == 1
				cCliAux := oSql:getvalue("B6_CLIFOR")
				cLojAux := oSql:getvalue("B6_LOJA")
			else
				if !lSubst
					if alltrim(cCliAux + cLojAux) != alltrim(oSql:getValue("B6_CLIFOR") + oSql:getValue("B6_LOJA"))
						lArray2 := .t.
					endif
				endif
			endif
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
					//nVlrParcial	:= oSql:getValue("D1_TOTAL")
					//nVlrUnit 	:= nVlrParcial / nSaldo
					//Emerson Holanda - 14/09/22
					nVlrUnit    := oSql:getValue("D1_VUNIT")
					nVlrParcial := nVlrUnit * nSaldo					
				endif

				if nSaldo * A410Arred(nVlrUnit ,"C6_PRCVEN") < 0.01
					oLogImp:start("PV","PV","")
					oLogImp:warn("REGISTRO IGNORADO PEDIDO "+SC5->C5_NUM, "Valor total item "+oSql:getValue("B6_PRODUTO")+" para NF "+oSql:getValue("D1_DOC")+;
					"/"+oSql:getValue("D1_SERIE")+" não atingiu valor minimo 0,01.")
					oSql:skip()
					loop
				endif

				if lArray2
					if len(aDetails2) == 0
						cItem := "01"
					else
						cItem := Soma1(aDetails2[len(aDetails2),1,2])
					endif
				else
					if len(aDetails) == 0
						cItem := "01"
					else
						cItem := Soma1(aDetails[len(aDetails),1,2])
					endif
				endif

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

				//				montaItens(@aAux)
				if lArray2
					aAdd(aDetails2,aAux)
				else
					aAdd(aDetails,aAux)
				endif

				nSld -= iif(nSld <= oSql:getValue("B6_SALDO"),nSld,oSql:getValue("B6_SALDO"))

				if nSld == 0
					exit
				endif

				oSql:skip()

			enddo
			if nSld > 0
				cProds += cProduct +"/"
				lTemPoder3 := .F.
				exit
			endif
		else
			cProds += cProduct +"/"
			lTemPoder3 := .F.
			exit
		endif

	next nI

return

/**
* Agrupa os Produtos do Pedido de Vendas
*/
static function groupProducts()

	local nI	   	 := 0
	local nScan		 := 0
	local nQuantity  := 0
	local cProduct   := ""
	local cLote		 := ""
	local aGroupProd := {}

	for nI := 1 to Len(aProducts)

		cProduct  := aProducts[nI,1]
		nQuantity := aProducts[nI,2]
		cLote	  := aProducts[nI,3]
		nScan	  := aScan(aGroupProd, {|x| alltrim(x[1]) + alltrim(x[3]) == alltrim(cProduct) + alltrim(cLote)})

		if (nScan > 0)
			aGroupProd[nScan,2] += nQuantity
		else
			aAdd(aGroupProd, {cProduct, nQuantity, cLote})
		endIf

	next nI

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


/*
**
*/
static function getCliFor()
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local lOk	 	:= .t.

	if getDocType() == 'N'
		oSqlUtil:newTable("SA1", "A1_COD, A1_LOJA, A1_EMAIL, A1_INSCR, A1_CONTRIB", "A1_FILIAL = '%SA1.FILIAL%' AND A1_CGC = '" + cCnpjCli + "' ")
		if oSqlUtil:hasRecords()
			cClifor	:= oSqlUtil:getValue("A1_COD")
			cLoja	:= oSqlUtil:getValue("A1_LOJA")
			cEmail	:= oSqlUtil:getValue("A1_EMAIL")
			//Emerson Holanda 09/09/2020-- Gravação do IE e do Contrib
			cInscri	:= oSqlUtil:getValue("A1_INSCR")
			cContrib:= oSqlUtil:getValue("A1_CONTRIB")
		else
			lOk := .f.
		endif
	else
		oSqlUtil:newTable("SA2", "A2_COD, A2_LOJA, A2_EMAIL, A2_INSCR, A2_CONTRIB", "A2_FILIAL = '%SA2.FILIAL%' AND A2_CGC = '" + cCnpjCli + "' ")
		if oSqlUtil:hasRecords()
			cClifor	:= oSqlUtil:getValue("A2_COD")
			cLoja	:= oSqlUtil:getValue("A2_LOJA")
			cEmail	:= oSqlUtil:getValue("A2_EMAIL")
			//Emerson Holanda 09/09/2020-- Gravação do IE e do Contrib
			cInscri	:= oSqlUtil:getValue("A2_INSCR")
			cContrib:= oSqlUtil:getValue("A2_CONTRIB")
		else
			lOk := .f.
		endif
	endif

	oSqlUtil:close()

return (lOk)


/**
*  Obtem a query dos itens do pedido de venda
*/
static function getQueryItens(cProduct, cLote, cForneced, cLojaFor, cDepSubst, cLojDepSubst)
	local cQuery      := ""
	Default cForneced := ''
	Default cLojaFor  := ''
	Default cDepSubst := ''
	Default cLojDepSubst  := ''

	cQuery := "SELECT D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_ITEM,D1_VUNIT,D1_LOCAL,D1_TOTAL,D1_EMISSAO,B6_FILIAL,B6_PRODUTO,B6_QUANT," 										+CRLF
	cQuery += "       B6_CLIFOR,B6_LOJA,B6_PODER3,B6_TPCF,B6_TIPO,B6_IDENT,B6_PRUNIT,(B6_SALDO - B6_QULIB) B6_SALDO,F4_TESDV,F4_ZZTESFE, D1_LOTECTL, D1_DTVALID "			+CRLF
	cQuery += "FROM " + RetSqlName("SB6") + " SB6,"																															+CRLF
	cQuery +=           RetSqlName("SD1") + " SD1,"	+CRLF
	cQuery +=           RetSqlName("SF4") + " SF4 " +CRLF
	cQuery += "WHERE B6_FILIAL = '" + xFilial("SB6") + "' AND " +CRLF
	cQuery += "      B6_PODER3 = 'R' AND " +CRLF
	cQuery += "      B6_TPCF   = 'C' AND " +CRLF
	cQuery += "      B6_TIPO   = 'D' AND " +CRLF
	cQuery += "      (B6_SALDO - B6_QULIB)  > 0 AND " +CRLF
	if !empty(cForneced)
		cQuery += "      ((B6_CLIFOR   = '" + cForneced + "' AND "  +CRLF
		cQuery += "      B6_LOJA     = '" + cLojaFor  + "' ) "  +CRLF
		if !empty(cDepSubst) .and. !empty(cLojDepSubst)
			cQuery += "      OR (B6_CLIFOR   = '" + cDepSubst + "' AND "  +CRLF
			cQuery += "      B6_LOJA     = '" + cLojDepSubst  + "' ) "  +CRLF
		endif
		cQuery += "      ) AND "  +CRLF
	endif
	cQuery += " 	 SB6.D_E_L_E_T_ = ' ' AND " +CRLF
	cQuery += "      D1_NUMSEQ = B6_IDENT AND " +CRLF
	cQuery += "      D1_FILIAL = '" + xFilial("SD1") + "' AND " +CRLF
	cQuery += "      D1_COD    = '" + cProduct + "' AND " +CRLF
	cQuery += "      D1_TRANSIT <> 'S' AND " +CRLF
	if empty(cLote)
		cQuery += "      D1_LOTECTL    = '" + CriaVar("D1_LOTECTL", .f.) + "' AND " +CRLF
	else
		cQuery += "      D1_LOTECTL    = '" + cLote + "' AND " +CRLF
	endif
	cQuery += " SD1.D_E_L_E_T_ = ' ' AND " +CRLF
	cQuery += "      F4_FILIAL = '" + xFilial("SF4") + "' AND " +CRLF
	cQuery += "      F4_CODIGO = B6_TES AND " +CRLF
	cQuery += " SF4.D_E_L_E_T_ = ' ' " +CRLF
	//Emerson Holanda 01/09/22 -- Incluida amarracao doc. sd1 com doc. sb6
	cQuery += " AND D1_DOC = B6_DOC AND D1_SERIE = B6_SERIE " +CRLF
	if empty(cLote)
		cQuery += " ORDER BY D1_EMISSAO " +CRLF
	else
		cQuery += " ORDER BY D1_DTVALID,D1_DTDIGIT " +CRLF
	endif

return cQuery


/**
* Coleta a Tes a ser utilizada
**/
static function getTes(oSql)

	local cTes 		:= ""
	local cTesAux	:= ""
	local cEstCli
	local oSqlCli	:= IpSqlObject():newIpSqlObject()
	local oSqlAux	:= IpSqlObject():newIpSqlObject()

	if upper(alltrim(SC5->C5_ZZESPEC)) ==  DHL_ESPECIE_INVENTARIO
		cTes := AllTrim(GetMv("ZZ_TESINV"))
	else
		if getDocType() $ 'B'
			cTes := GetNewPar("ZZ_TESREP", "")
		Else
			if empty(cDeliveryCust)
				cEstCli := oSqlAux:getFieldValue("SA1", "A1_EST", "%SA1.XFILIAL% AND A1_COD = '" + cCliFor + "' AND A1_LOJA = '" + cLoja + "' ")
			else
				cEstCli := oSqlAux:getFieldValue("SA1", "A1_EST", "%SA1.XFILIAL% AND A1_COD = '" + cDeliveryCust + "' AND A1_LOJA = '" + cBranchCust + "' ")				
			endif

			if cEstCli == SM0->M0_ESTCOB
				cTes 	:= oSql:getValue("F4_TESDV")
			else
				cTes 	:= oSql:getValue("F4_ZZTESFE")
			endif

		endif
	endif

return cTes


/*
** Cria cliente de entrega para o processo
*/
static function incCustomer()
	local oSql			:= IpSqlObject():newIpSqlObject()
	local oUtils		:= IpUtilsObject():newIpUtilsObject()
	local cDeliCust		:= upper(getDeliveryCustomer())
	local cAdress		:= upper(getAdress())
	local cComplement 	:= upper(getComplement())
	local cComp2			:= upper(getComp2())
	local cDistrict		:= upper(getDistrict())
	local cState		:= upper(getStateAdress())
	local cCity			:= upper(getCityAdress())
	local cZipCode		:= getZipcodeAdress()
	local cCodMun		:= ""
	local cNumber		:= ""
	Local aCustomer 	:= {}
	Local nDig			:= Len(Alltrim(cCnpjCli))
	Local cPessoa		:= ""
	Local cAdress2		:= ""

	If nDig = 14
		cPessoa := "J"
	Else
		cPessoa := "F"
	Endif

	If EMPTY(alltrim(cComp2))
		cAdress2 := alltrim(cAdress) + ", " + alltrim(cComplement)
	Else
		cAdress2 := alltrim(cAdress) + ", " + alltrim(cComplement)+ " " + alltrim(cComp2)
	Endif

	lOk := getCliFor()

	if lOk
		if empty(cDeliCust)
			oSql:NewTable("SA1", "A1_COD,A1_LOJA",;
				"%SA1.XFILIAL% AND "+;
				"A1_CGC 	= '"+cCnpjCli+"' AND "+;
				"A1_ZZCLPR 	= '" + CriaVar("A1_ZZCLPR", .f.) + "' AND "+;
				"A1_ZZLJPR  = '" + CriaVar("A1_ZZLJPR", .f.) + "'")
			cDeliveryCust	:= oSql:getValue("A1_COD")
			cBranchCust		:= oSql:getValue("A1_LOJA")
		else
			//cCodMun := getCodMun(cCity) cState
			cCodMun := getCodMun(cState,cCity)  //Emerson Holanda 16/03/2022 - Incluido o Estado na busca da cidade

			if empty(cCodMun)
				lOk := .f.
				DisarmTransaction()
				setFileLog(cFile, "fail", "Falha ao localizar código do Município para o Município: "+ cCity)
			endif

			if lOk
				lMsErroAuto := .F.

				//cNumber := Substr(cAdress,Rat(",",cAdress)+1, len(cAdress))
//					{"A1_END"       , substr(Upper(AllTrim(cAdress2)), 1, TamSx3("A1_END")[1])		 	, Nil},;

				aCustomer := 	{{"A1_NOME"      , cDeliCust  			, Nil},;
					{"A1_NREDUZ"    , substr(Upper(AllTrim(cDeliCust)), 1, TamSx3("A1_NREDUZ")[1])	 	, Nil},;
					{"A1_PESSOA"    , cPessoa			 	, Nil},;
					{"A1_TIPO"      , "F"				 	, Nil},;
					{"A1_ZZRUA"     , cAdress	 			, Nil},;
					{"A1_ZZNRO"     , cComplement			, Nil},;
					{"A1_EST"       , cState				, Nil},;
					{"A1_COD_MUN"   , cCodMun				, Nil},;
					{"A1_MUN"   	 , cCity				, Nil},;
					{"A1_BAIRRO"    , cDistrict			, Nil},;
					{"A1_CEP"       , cZipCode				, Nil},;
					{"A1_PAIS"      , "105"				, Nil},;
					{"A1_PAISDES"   , "BRASIL"				, Nil},;
					{"A1_CGC"   	 , cCnpjCli	 	, Nil},;
					{"A1_EMAIL"   	 , cEmail		 	 	, Nil},;
					{"A1_CONTRIB"   , cContrib	 			, Nil},; //{"A1_CONTRIB"   , "2"	 	 			, Nil},; //Emerson Holanda 09/09/2020 Gravação do campo Contrib do cliente original
				{"A1_INSCR"     , cInscri	 			, Nil},; //Emerson Holanda 09/09/2020 Gravação do campo IE do cliente original
				{"A1_CODPAIS"   , "01058"	 			, Nil},;
					{"A1_ZZCLPR"    , cCliFor	 			, Nil},;
					{"A1_ZZLJPR"    , cLoja	 			, Nil},;
					{"A1_ZZINDDW"   , "2"	 	 			, Nil},;
					{"A1_ZZCEGED"   , cCnpjCli	 			, Nil},;
					{"A1_ZZREPRE"   , "S"	 	 			, Nil}}

				/* Inibido por Emerson Holanda 17/01/2024 - Estava desposicionando o cliente incluido gravando o cliente de entrega errado no pedido.
				DbSelectArea("SA1")
				SA1->(DbSetOrder(0))
				DBGOBOTTOM(  )
				sa1nrecno := recno()
				SA1->(DbSetOrder(1))
				*/
				//MSExecAuto({|x,y| Mata030(x,y)},aCustomer,3)
				MSExecAuto({|x,y| CRMA980(x,y)},aCustomer,3)

				if lMsErroAuto
					lOk := .f.
					DisarmTransaction()
					setFileLog(cFile, "fail", "Falha ao incluir cliente de entrega"+CRLF+CRLF+oUtils:getErroAuto())
				else
					/* Thiago Meschiatti - 31/05/23 -Removido trecho por atualização Protheus
					DbSelectArea("SA1")
					DBGOTO(sa1nrecno+1)
					if !eof()
						cDeliveryCust	:= SA1->A1_COD //cCliFor //RONI SILVA 
						cBranchCust		:= SA1->A1_LOJA //cLoja  //RONI SILVA 
					endif*/
					cDeliveryCust	:= SA1->A1_COD 
					cBranchCust		:= SA1->A1_LOJA
				endif
			endif
		endif
	else
		DisarmTransaction()
		setFileLog(cFile,"fail","Falha ao incluir o pedido de vendas. Cliente/Fornecedor não localizado."+CRLF+CRLF+ "CNPJ/CPF: " + cCnpjCli + CRLF+CRLF+oUtils:getErroAuto())
	endif

return (lOk)


/*
** Coleta o Código do Município
*/
static function getCodMun(cState,cCity)
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cCodMun	:= ""

	//cCodMun := oSql:getFieldValue("CC2", "CC2_CODMUN", " %CC2.XFILIAL% AND CC2_MUN = '"+NoAcento(upper(cCity))+"' ")
	cCodMun := oSql:getFieldValue("CC2", "CC2_CODMUN", " %CC2.XFILIAL% AND CC2_EST = '"+Alltrim(cState)+"' AND CC2_MUN = '"+Alltrim(NoAcento(upper(cCity)))+"'") //Emerson Holanda 16/03/2022 inclusao do estado na busca
	osql:close()
return (cCodMun)


/*
** Valida se Inv. Req. pode ser importada.
*/
static function validOrder()
	local oSql 	:= IpSqlObject():newIpSqlObject()
	local lOk	:= .t.

	oSql:newTable("SC5", "C5_NUM", " %SC5.XFILIAL% AND C5_ZZSHIP = '" + upper(cShipping) + "' AND C5_ZZORDEX = '" + upper(cSalesOrd) + "' ")

	if oSql:hasRecords()
		setFileLog(cFile,"fail","Interface não pode ser processada. Shippment: "+alltrim(cShipping)+" e Sales Order: "+alltrim(cSalesOrd)+" já utilizados no Protheus.")
		lOk := .f.
	endif

	oSql:close()

return (lOk)
/**
* Coleta o Shipping Number
**/
static function getShipping()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_SHIPPING_NUMBER:TEXT


/**
* Coleta o Customer CNPJ
**/
static function getCnpjCustomer()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_CUSTOMER_CNPJ:TEXT


/**
* Coleta o Sales Order
**/
static function getSalesOrder()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_SALES_ORDER:TEXT

/**
* Coleta o Document Type
**/
static function getDocType()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_DOCUMENT_TYPE:TEXT

/**
* Coleta o Net Weight
**/
static function getNetWeight()
return val(oXml:_INV_REQ:_BODY:_FILEHEADER:_NET_WEIGHT:TEXT)

/**
* Coleta o Gross Weight
**/
static function getGrossWeight()
return val(oXml:_INV_REQ:_BODY:_FILEHEADER:_GROSS_WEIGHT:TEXT)

/**
* Coleta o Volume
**/
static function getVolume()
return val(oXml:_INV_REQ:_BODY:_FILEHEADER:_VOLUME:TEXT)

/**
* Coleta o Delivery Customer
**/
static function getDeliveryCustomer()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_DELIVERY_CUSTOMER:TEXT

/**
* Coleta o Adress
**/
static function getAdress()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_ADDRESS:TEXT

/**
* Coleta o Complement Adress
**/
static function getComplement()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_COMPLEMENT_ADDRESS:TEXT

/**
* Coleta o Complement Adress2
**/
static function getComp2()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_COMPLEMENT_ADDRESS2:TEXT

/**
* Coleta o District Adress
**/
static function getDistrict()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_DISTRICT_ADDRESS:TEXT

/**
* Coleta o State Adress
**/
static function getStateAdress()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_STATE_ADDRESS:TEXT

/**
* Coleta o City Adress
**/
static function getCityAdress()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_CITY_ADDRESS:TEXT

/**
* Coleta o Zipcode Adress
**/
static function getZipcodeAdress()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_ZIPCODE_ADRRESS:TEXT

/**
* Coleta o codigo CEGEDIM
**/
static function getCEGEDIM()
return oXml:_INV_REQ:_BODY:_FILEHEADER:_CEGEDIM:TEXT

/**
* Verifica o balanceamento das tabelas 
**/
static function verifyBalancTables(aDetails, aErrorBalanc)

	local lBalancTables := .T.
	local aProdutos		:= {}
	local nI			:= 0
	local cProduto		:= ""	
	local cLote			:= ""	
	local cArmazem		:= ""	
	local nQtd			:= 0	
	local aDetail		:= {}
	local aArea			:= getArea()	
	local cIdentB6		:= ""

	for nI := 1 to len(aDetails)

		aDetail := aDetails[nI]	

		cProduto:= aDetail[getPosField(aDetail,"C6_PRODUTO")][2]
		cLote	:= aDetail[getPosField(aDetail,"C6_LOTECTL")][2]
		cArmazem:= aDetail[getPosField(aDetail,"C6_LOCAL")][2]
		nQtdVen	:= aDetail[getPosField(aDetail,"C6_QTDVEN")][2]			
		cTES 	:= aDetail[getPosField(aDetail,"C6_TES")][2]			  //F4_PODER3="N, "

		aAdd(aProdutos, {cProduto, cLote, cArmazem, nQtdVen, SALDO_B2, SALDO_B6, SALDO_B8})	

		nSaldoB2 	:= getSaldoB2(cProduto, cArmazem)		
		nSaldoB6    := getSaldoB6(cProduto, cArmazem)
		
		//Elmo, em 14/set/22: Não verificar SB6 quando TES não controlar poder.3o. - INICIO (Ajustado Thiago Meschiatti)
		SF4->(dbSeek(xFilial("SF4") + cTES))
		
		if !empty(cLote)
			If sf4->f4_poder3 $ "S"
				nSaldoB8 := getSaldoB8(cProduto, cArmazem)

				if (nSaldoB8 != nSaldoB6) .OR.  (nSaldoB8 != nSaldoB2) .OR. (nSaldoB6 != nSaldoB2)
					lBalancTables := .F.
					aAdd(aErrorBalanc, {"Produto/Lote " + allTrim(cProduto) + "/" +allTrim(cLote)+ " com desbalanceamento entre as tabelas SB2/SB6/SB8. Qtd. SB2: " + cValToChar(nSaldoB2) + " Qtd. SB6: " + cValToChar(nSaldoB6)+ " Qtd. SB8: " + cValToChar(nSaldoB8)})
				endIf
			EndIf
		else
			If sf4->f4_poder3 $"N, "
			Else
			//Elmo, em 14/set/22: Não verificar SB6 quando TES não controlar poder.3o. - FINAL
				if (nSaldoB6 != nSaldoB2)
					lBalancTables := .F.
					aAdd(aErrorBalanc, {"Produto " + allTrim(cProduto) + " com desbalanceamento entre as tabelas SB2/SB6. Qtd. SB2: " + cValToChar(nSaldoB2) + " Qtd. SB6: " + cValToChar(nSaldoB6)})
				endIf
			//Elmo, em 14/set/22: Não verificar SB6 quando TES não controlar poder.3o. - INICIO
			Endif
			//Elmo, em 14/set/22: Não verificar SB6 quando TES não controlar poder.3o. - FINAL

		endIf

	next nI 	

	restArea(aArea)

return lBalancTables

/**
* obtém a posiçãomdo campo no array
**/
static function getPosField(aDetail, cCampo)

	local nPosField := aScan(aDetail, {|x| allTrim(x[1]) == cCampo})

return nPosField

/**
* Obtém o saldo da SB2
**/
static function getSaldoB2(cProduto, cArmazem)

	local nSaldoB2 := 0
	local cQuery   := ""
	local cAlias   := getNextAlias()
	local oSql 	   := IpSqlObject():newIpSqlObject()


	cQuery := " SELECT SB2.B2_COD, SUM(SB2.B2_QATU) SALDO FROM " + retSqlName("SB2") + " SB2" 	+ CRLF
	cQuery += " WHERE 1 = 1 " 																	+ CRLF
	cQuery += "    AND SB2.B2_FILIAL = '"+fwxFilial("SB2")+"' " 								+ CRLF
	cQuery += "    AND SB2.B2_COD = '"+cProduto+"' " 											+ CRLF
	/* Inibido por Emerson Holanda 09/09/2020 - Analise de saldo geral em todos os armazens
	cQuery += "    AND SB2.B2_LOCAL = '"+cArmazem+"' " 											+ CRLF
	*/
	cQuery += "    AND SB2.D_E_L_E_T_ = ' ' " 													+ CRLF
	cQuery += "  GROUP BY SB2.B2_COD " 															+ CRLF

	oSql:newAlias(cQuery)

	if oSql:hasRecords()
		nSaldoB2 := oSql:getValue("SALDO")
	endif

	oSql:close()

return nSaldoB2

/**
* Obtém o saldo da SB6
**/
static function getSaldoB6(cProduto, cArmazem)

	local nSaldoB6 := 0
	local cQuery   := ""
	local cAlias   := getNextAlias()
	local oSql 	   := IpSqlObject():newIpSqlObject()


	cQuery := " SELECT SB6.B6_PRODUTO, SUM(SB6.B6_SALDO) SALDO FROM " + retSqlName("SB6") + " SB6" 	+ CRLF
	cQuery += " WHERE 1 = 1 " 																	+ CRLF
	cQuery += "    AND SB6.B6_FILIAL = '"+fwxFilial("SB6")+"' " 								+ CRLF
	cQuery += "    AND SB6.B6_PRODUTO = '"+cProduto+"' " 										+ CRLF
	/* Inibido por Emerson Holanda 09/09/2020 - Analise de saldo geral em todos os armazens
	cQuery += "    AND SB6.B6_LOCAL = '"+cArmazem+"' " 											+ CRLF
	*/
	cQuery += "    AND SB6.D_E_L_E_T_ = ' ' " 													+ CRLF
	cQuery += "  GROUP BY SB6.B6_PRODUTO " 														+ CRLF

	oSql:newAlias(cQuery)

	if oSql:hasRecords()
		nSaldoB6 := oSql:getValue("SALDO")
	endif

	oSql:close()

return nSaldoB6

/**
* Obtém o saldo da SB8
**/
static function getSaldoB8(cProduto, cArmazem)

	local nSaldoB8 := 0
	local cQuery   := ""
	local cAlias   := getNextAlias()
	local oSql 	   := IpSqlObject():newIpSqlObject()


	cQuery := " SELECT SB8.B8_PRODUTO, SUM(SB8.B8_SALDO) SALDO FROM " + retSqlName("SB8") + " SB8 " + CRLF
	cQuery += " WHERE 1 = 1 " 																	+ CRLF
	cQuery += "    AND SB8.B8_FILIAL = '"+fwxFilial("SB8")+"' " 								+ CRLF
	cQuery += "    AND SB8.B8_PRODUTO = '"+cProduto+"' " 										+ CRLF
	/* Inibido por Emerson Holanda 09/09/2020 - Analise de saldo geral em todos os armazens
	cQuery += "    AND SB8.B8_LOCAL = '"+cArmazem+"' " 											+ CRLF
	*/
	cQuery += "    AND SB8.D_E_L_E_T_ = ' ' " 													+ CRLF
	cQuery += "  GROUP BY SB8.B8_PRODUTO " 														+ CRLF

	oSql:newAlias(cQuery)

	if oSql:hasRecords()
		nSaldoB8 := oSql:getValue("SALDO")
	endif

	oSql:close()

return nSaldoB8

/**
* obtém o saldo da SB2
**/
static function getSaldoSB2(cProduto, cLocPad)

	local nSaldo := 0

	cProduto := padr(cProduto, tamSx3("B1_COD")[1], "")

	dbSelectArea("SB2")
	if SB2->(dbSeek(xFilial("SB2") + cProduto + cLocPad))		
		nSaldo := SaldoSb2()
	endIf

return nSaldo

/**
* Verifica se o saldo é suficiente para o processamento
**/
static function isSaldoSuf(aDetails, aErrorSaldo)	

	local nI			:= 0
	local cProduto		:= ""	
	local cLote			:= ""	
	local cArmazem		:= ""	
	local nQtd			:= 0	
	local aDetail		:= {}
	local aArea			:= getArea()
	local lSuf        	:= .T.

	for nI := 1 to len(aDetails)

		aDetail := aDetails[nI]	

		cProduto:= aDetail[getPosField(aDetail,"C6_PRODUTO")][2]
		cLote	:= aDetail[getPosField(aDetail,"C6_LOTECTL")][2]
		cArmazem:= aDetail[getPosField(aDetail,"C6_LOCAL")][2]
		nQtdVen	:= aDetail[getPosField(aDetail,"C6_QTDVEN")][2]			

		nSaldoB2 	:= getSaldoSB2(cProduto, cArmazem)	

		if nQtdVen > nSaldoB2			
			aAdd(aErrorSaldo, {"Produto/Lote " + allTrim(cProduto) + "/" +allTrim(cLote)+ " não possui saldo em estoque disponível: " + cValtoChar(nSaldoB2) + ". Quantidade do produto a ser processado: " +cValtoChar(nQtdVen)})
			lSuf := .F.		
		endIf

	next nI 	

	restArea(aArea)

return lSuf

/**
* Obtém a string do array
**/
static function arrayToStr(aError)

	local cStr 	:= ""
	local nI	:= 0

	for nI := 1 to len(aError)
		cStr += aError[nI][1] + space(100) + CRLF
	next nI

return cStr

/**
* Verifica se pode dar prosseguimento na criação do pedido
**/
static function isCanCreateInv(aDetails, aErrorSC6Qtd)

	local lCanCreateInv := .T.
	local aProdutos		:= {}
	local nI			:= 0
	local cProduto		:= ""	
	local cLote			:= ""	
	local cArmazem		:= ""	
	local nQtd			:= 0	
	local aDetail		:= {}
	local aArea			:= getArea()	
	local cIdentB6		:= ""
	local cNfOri		:= ""
	local cSerOri		:= ""
	local cItemOri		:= ""
	local cSeriOri		:= ""
	local cItemOri		:= ""
	local nQtdRest		:= 0	
	local cPedido		:= ""	

	for nI := 1 to len(aDetails)

		aDetail := aDetails[nI]	

		cItem	:= aDetail[getPosField(aDetail,"C6_ITEM")][2]
		cProduto:= aDetail[getPosField(aDetail,"C6_PRODUTO")][2]
		cLote	:= aDetail[getPosField(aDetail,"C6_LOTECTL")][2]
		cArmazem:= aDetail[getPosField(aDetail,"C6_LOCAL")][2]
		nQtdVen	:= aDetail[getPosField(aDetail,"C6_QTDVEN")][2]	
		cIdentB6:= aDetail[getPosField(aDetail,"C6_IDENTB6")][2]	
		cNfOri	:= aDetail[getPosField(aDetail,"C6_NFORI")][2]	
		cSeriOri:= aDetail[getPosField(aDetail,"C6_SERIORI")][2]
		cItemOri:= aDetail[getPosField(aDetail,"C6_ITEMORI")][2]
		cTES	:= aDetail[getPosField(aDetail,"C6_TES")][2]		

		if getPosField(aDetail,"C6_NUM") > 0
			cPedido:= aDetail[getPosField(aDetail,"C6_NUM")][2]
		endIf		

		if empty(cPedido)
			//PASSAR COM NIL, PARA A FUNÇÃO ASSUMIR O VALOR DEFAULT. UTILIZADO NA INVOICE
			cPedido := nil
		endIf

		nSaldoB6    		:= getDocOrigSaldoB6(cProduto, cArmazem, cIdentB6, cNfOri, cSeriOri, cItemOri  )
		Conout("DisInvReq: "+ allTrim(cItem)+allTrim(cProduto)+"-" + cArmazem +"-" + cIdentB6+"-" +cValToChar(nSaldoB6))
		nQtdC6InPedSemFat	:= getQtdInPedSemFat(cProduto, cArmazem, cIdentB6, cPedido)	
		nQtdRest			:= nSaldoB6 - nQtdC6InPedSemFat 

		//Elmo, em 14/set/22: Não verificar SB6 quando TES não controlar poder.3o. - INICIO
		SF4->(dbSeek(xFilial("SF4") + cTES))
		If sf4->f4_poder3 $"N, "
		Else
		//Elmo, em 14/set/22: Não verificar SB6 quando TES não controlar poder.3o. - FINAL

			if nQtdVen > nQtdRest		
				aAdd(aErrorSC6Qtd, {"Item " + allTrim(cItem) + ", Produto " + allTrim(cProduto) + " com quantidade requisitada superior ao saldo na tabela [SALDO EM PODER DE TERCEIROS] disponíveis. Qtd Saldo Poder de Terceiro: "+cValToChar(nSaldoB6)+" Qtd em Itens Pedidos Sem Faturar: " + cValToChar(nQtdC6InPedSemFat) + ". Saldo disponível: " + cValToChar(nQtdRest) + ". Qtd do produto a ser processado: "+cValToChar(nQtdVen)})
				aAdd(aErrorSC6Qtd, {"-----------------------------------------"})
				lCanCreateInv := .F.
			endIf			
		
		//Elmo, em 14/set/22: Não verificar SB6 quando TES não controlar poder.3o. - INICIO
		Endif
		//Elmo, em 14/set/22: Não verificar SB6 quando TES não controlar poder.3o. - FINAL

	next nI 	

	restArea(aArea)

return lCanCreateInv

/** 
* Obtem a quantidades de itens na SC6 referente ao prduto + identb6 que não foram faturados
**/
static function  getQtdInPedSemFat(cProduto, cArmazem, cIdentB6, cPedido)

	local nQtdVen  := 0
	local cQuery   := ""
	local cAlias   := getNextAlias()
	local oSql 	   := IpSqlObject():newIpSqlObject()

	default cPedido := ""

	cQuery := " SELECT SC6.C6_PRODUTO, SUM(SC6.C6_QTDVEN) QTDVEND FROM " + retSqlName("SC6") + " SC6"	+ CRLF
	cQuery += " WHERE 1 = 1 " 																			+ CRLF
	cQuery += "    AND SC6.C6_FILIAL = '"+fwxFilial("SC6")+"' " 										+ CRLF
	cQuery += "    AND SC6.C6_PRODUTO = '"+cProduto+"' " 												+ CRLF
	cQuery += "    AND SC6.C6_LOCAL = '"+cArmazem+"' " 													+ CRLF	
	cQuery += "    AND SC6.C6_IDENTB6 = '"+cIdentB6+"' " 												+ CRLF

	//UTILIZADO NO PE M410PVNF PARA NÃO CONSIDERAR O PEDIDO NA SOMA
	if !empty(cPedido)
		cQuery += "    AND SC6.C6_NUM NOT IN('"+cPedido+"') " 												+ CRLF
	endIf

	cQuery += "    AND SC6.C6_NOTA = ' ' " 																+ CRLF	
	cQuery += "    AND SC6.D_E_L_E_T_ = ' ' " 															+ CRLF
	cQuery += "  GROUP BY SC6.C6_PRODUTO " 																+ CRLF

	oSql:newAlias(cQuery)	

	if oSql:hasRecords()
		nQtdVen := oSql:getValue("QTDVEND")
	endif

	oSql:close()

return nQtdVen

/**
* Obtém o saldo da SB6 do documento de origem
**/
static function getDocOrigSaldoB6(cProduto, cArmazem, cIdentB6, cNfOri, cSeriOri, cItemOri  )

	local nSaldoB6 := 0
	local cQuery   := ""
	local cAlias   := getNextAlias()
	local oSql 	   := IpSqlObject():newIpSqlObject()


	cQuery := " SELECT SB6.B6_PRODUTO, SUM(SB6.B6_SALDO) SALDO FROM " + retSqlName("SB6") + " SB6" 	+ CRLF
	cQuery += " WHERE 1 = 1 " 																		+ CRLF
	cQuery += "    AND SB6.B6_FILIAL = '"+fwxFilial("SB6")+"' " 									+ CRLF
	cQuery += "    AND SB6.B6_PRODUTO = '"+cProduto+"' " 											+ CRLF
	cQuery += "    AND SB6.B6_LOCAL = '"+cArmazem+"' " 												+ CRLF
	cQuery += "    AND SB6.B6_DOC = '"+cNfOri+"' " 													+ CRLF
	cQuery += "    AND SB6.B6_SERIE = '"+cSeriOri+"' " 												+ CRLF
	cQuery += "    AND SB6.B6_IDENT = '"+cIdentB6+"' " 												+ CRLF	
	cQuery += "    AND SB6.D_E_L_E_T_ = ' ' " 														+ CRLF
	cQuery += "  GROUP BY SB6.B6_PRODUTO " 															+ CRLF

	oSql:newAlias(cQuery)	

	if oSql:hasRecords()
		nSaldoB6 := oSql:getValue("SALDO")
	endif

	oSql:close()

return nSaldoB6

/**
* Salva o Log que passou pela validação
**/
static function saveLog(cFil, cShipping, cDtProces, cHrProces, cTpProces, lStatusProc )

	TBL_TEMP->(recLock("TBL_TEMP", .T.))
	TBL_TEMP->FILIAL 	:= cFil
	TBL_TEMP->TP_PROCES := cShipping
	TBL_TEMP->DT_PROCES := cDtProces
	TBL_TEMP->HR_PROCES := cHrProces
	TBL_TEMP->ID_PROCES := cTpProces
	TBL_TEMP->ST_PROCES := lStatusProc
	TBL_TEMP->(msUnLock())

	TBL_TEMP->((dbCloseArea("TBL_TEMP")))

return

/**
* Cria a tabela temporária
**/
static function createOraclTable()

	local aFields	 		:= getStruct()
	local cTableName 		:= createTempTable(aFields)

return

/**
* Obtém a estrutura da tabella temporaria
**/
static function getStruct()

	local aFields := {}

	aAdd(aFields,{"FILIAL"	  	,TamSx3("F2_FILIAL")[3]		,TamSx3("F2_FILIAL")[1]								,TamSx3("F2_FILIAL")[1]		})
	aAdd(aFields,{"TP_PROCES"	,"C"						,15													,0							})
	aAdd(aFields,{"DT_PROCES"	,"C"						,10													,0							})
	aAdd(aFields,{"HR_PROCES"	,"C"						,10													,0							})
	aAdd(aFields,{"ID_PROCES"	,"C"						,20													,0							})
	aAdd(aFields,{"ST_PROCES"	,"L"						,1													,0							})	

return aFields

/**
*	cria a tabela temporária
**/
static function createTempTable(aFields)

	local cTableName 	:= "LOG_PFIZER"
	local cAliasTable 	:= "TBL_TEMP"
	local cChave		:= "FILIAL"		

	disarmTransaction()

	if !MsFile(cTableName)
		DBCreate (cTableName,aFields, "TOPCONN" )
		dbUseArea(.T., "TOPCONN", cTableName, cAliasTable, .t., .f.)
		DBCreateIndex ( cTableName, cChave)		
		dbSetOrder(1)
	else	
		/*
		If Select(cAliasTable) > 0 //Emerson Holanda 10/11/2020  -- Verifica se a tabela esta aberta e Fecha a tabela temporaria antes de criar novamente
			cAliasTable->(DbCloseArea()) 
		EndIf
		dbUseArea(.T., "TOPCONN", cTableName, cAliasTable, .t., .f.)
		*/
	If Select(cAliasTable) == 0 //Emerson Holanda 10/11/2022
		dbUseArea(.T., "TOPCONN", cTableName, cAliasTable, .t., .f.)
	EndIf
endIf

dbSelectArea(cAliasTable)

return cTableName

/**
* Obtém a lista de depositantes.
**/
static function getDepositors()

	local oSql		:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	local aRet		:= {}

	cQuery += " SELECT A1_ZZIDDEP, A1_COD, A1_LOJA, A1_ZZCDDW, A1_ZZLJDW "	+ CRLF
	cQuery += " FROM %SA1.SQLNAME% "					+ CRLF
	cQuery += " WHERE A1_FILIAL = '%SA1.FILIAL%' "		+ CRLF
	cQuery += " AND A1_ZZIDDEP <> ' ' "					+ CRLF
	cQuery += " AND %SA1.NOTDEL% "						+ CRLF

	oSql:newAlias(cQuery)

	if oSql:hasRecords()
		while oSql:notIsEof()
			aAdd(aRet,{oSql:getValue("A1_ZZIDDEP"),oSql:getValue("A1_COD"),oSql:getValue("A1_LOJA"),;
			oSql:getValue("A1_ZZCDDW"),oSql:getValue("A1_ZZLJDW")})
			oSql:skip()
		endDo
	endIf

	oSql:close()

return aRet

/**
* Valida o ID do Depositante para não permitir informar o mesmo ID em cadastros de clientes (SA1) diferentes.
**/
user function vldIdDep()

	local oSql		:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	local lRet		:= .T.

	cQuery += " SELECT A1_COD, A1_LOJA "			+ CRLF
	cQuery += " FROM %SA1.SQLNAME% "				+ CRLF
	cQuery += " WHERE A1_FILIAL = '%SA1.FILIAL%' "	+ CRLF
	cQuery += " AND A1_ZZIDDEP = '" + M->A1_ZZIDDEP + "' " + CRLF
	cQuery += " AND A1_COD <> '" + M->A1_COD + "' " + CRLF
	cQuery += " AND %SA1.NOTDEL% "					+ CRLF

	oSql:newAlias(cQuery)

	if oSql:hasRecords()
		lRet := .F.
		MSGALERT("Identificador de depositante já utilizado no cadastro do cliente/loja " + oSql:getValue("A1_COD") + "/" + oSql:getValue("A1_LOJA") + ".",ProcName())
	endIf

	oSql:close()

return lRet
