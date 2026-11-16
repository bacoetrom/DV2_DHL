#include "totvs.ch"
#include "dhl.ch"

#define OPC_INCLUSAO   3
#define INTERFACE_NAME "Stock Adjustment"


/*/{Protheus.doc} ImpXMLInv

Importa o arquivo XML Stock Adjustment
	
@author Thiago Meschiatti
@since 30/03/2016

@param cFilePath,Caractere,XML a ser importado
@param cApp,Caractere,Se o XML é do Nulogy ou do Select

@return Logico Indica se foi importado com sucesso
/*/
user function DlxImpInv(cFilePath,cApp)

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
	
	if (cApp == APP_SELECT) 
		lIsLayout := DHL_SELECT_STOCK_ADJUSTMENT $ cXml
	elseif (cApp == APP_DLX)
		lIsLayout := !(DHL_SELECT_STOCK_ADJUSTMENT $ cXml)
	endif		 
	
return lIsLayout


/**
 * Processa os Arquivos
 */
static function procXml(cApp)
	
	local lOk  := .F.
	
	If isPreNota(cApp)		
		lOk := geraPreNota(cApp)
	elseIf isPedidoVenda(cApp)
		lOk := geraPedidoVenda(cApp)	
	else
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"Não foi possível definir o movimento de Ajuste a ser gerado")
	endif
								
return lOk


/**
 * Verifica se deve gerar uma Pre-Nota
 */
static function isPreNota(cApp)
	
	local lIsPreNota := .F.
	
	if (cApp == APP_DLX)
		lIsPreNota := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_TYPE:text")))=="P"
	endif	
	
return lIsPreNota


/**
 * Verifica se deve gerar um pedido de venda
 */
static function isPedidoVenda(cApp)
	
	local lIsPedVenda := .F.
	
	if (cApp == APP_DLX)
		lIsPedVenda := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_TYPE:text"))) == "N"
	endif	
	
return lIsPedVenda


/**
 * Verifica se deve gerar um movimento interno
 */
static function isMovimentoInterno(cApp)
	
	local lIsMovimentoInterno := .F.
	
	if (cApp == APP_DLX)
		lIsMovimentoInterno := Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_CUSTOMER:text"))) == "DHL"
	endif	
	
return lIsMovimentoInterno


/**
 * Gera a Pre-Nota de Entrada
 */
static function geraPreNota(cApp)
	
	local lOk    := .F.
	local aCab   := {}
	local aItens := {}
	local cErro  := ""
	
	getDadosPreNota(cApp,@aCab,@aItens)
	
	if FWUnitBusiness() == "SPL"
		aItens	:= u_ProcDesNF(aItens)
	endif
	
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| MATA140(x,y,z)},aCab,aItens,OPC_INCLUSAO)
	
	if lMsErroAuto
		RollBackSX8()
		
		cErro := mostraErroRotAuto()
		
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"Erro de rotina automática"+CRLF+CRLF+cErro)
	else
		ConfirmSX8()

		lOk := .T.
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
		if !(lTemPoder3)
			oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
			oLogImp:fail(INTERFACE_NAME,"Não há saldo em poder de terceiros para os itens do pedido "+CRLF+CRLF+cErro)
	//		MsgAlert("Não há saldo em poder de terceiros para os itens do pedido ! Verifique.")
			return
		endif
	
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
 * Gera o movimento interno
 */
static function geraMovimentoInterno(cApp)
	
	local lOk    := .F.
	local aDados := {}
	local aItens := {}
	local cErro  := ""

	getDadosMovInterno(cApp,@aDados,@aItens)
	
	lMsErroAuto := .F.
	//MSExecAuto({|x,y| MATA240(x,y)},aDados,OPC_INCLUSAO)
	MSExecAuto({|x,y,z| MATA241(x,y,z)},aDados,aItens,OPC_INCLUSAO)
	
	if lMsErroAuto
		cErro := mostraErroRotAuto()
		
		oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
		oLogImp:fail(INTERFACE_NAME,"Erro de rotina automática"+CRLF+CRLF+cErro)
	else
		lOk := .T.
	endif
	
return lOk


/**
 * Obtem as arrays da rotina automática de mov. interno
 */
static function getDadosMovInterno(cApp,aDados,aItens)

	local cControle  := ""
	local cCodProd 	 := ""
	local cCnpj 	 := ""
	local cFilialNum := ""
	local cTM		 := ""
	local nQuant 	 := 0
	local aItensXML  := {}
	local aItemAux 	 := {}
	
	if (cApp == APP_DLX)
	
		if Upper(AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_TYPE:text"))) == "P"
			cTM := GetMV("ZZ_TMDEV")
		else
			cTM := GetMV("ZZ_TMREQ")
		endif
		
		aItensXML := oXmlIp:getNodeArray("STK_ADJ:_BODY:_FILEHEADER")
		
		for nI := 1 to Len(aItensXML)
		
			cCodProd  := AllTrim(aItensXML[nI]:_ITEM:text)
			cCnpj     := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SITE_CNPJ:text"))

			nQuant    := Val(aItensXML[nI]:_QUANTITY:text)
			cControle := oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ADJUSTMENT_ID:text")

			if nI == 1
				aDados := {{"D3_FILIAL"  ,xFilial("SD3"),nil},;
					{"D3_DOC"     ,"INVENT" 	 ,nil},;
					{"D3_TM"      ,cTM 			 ,nil},;
					{"D3_EMISSAO" ,dDataBase 	 ,nil}}
			endif

			aAdd(aItemAux,{"D3_COD"     ,cCodProd      ,nil})
			aAdd(aItemAux,{"D3_QUANT"   ,nQuant 		 ,nil})
			aAdd(aItemAux,{"D3_ZZADJID" ,cControle     ,nil})

			aadd(aItens, aItemAux)
		next		
			
	endif
	
return


/**
 * Obtem as arrays da rotina automática de pré nota
 */
static function getDadosPreNota(cApp,aCab,aItens)

	local cControle  := ""
	local cCodProd 	 := ""
	local cCnpj 	 := ""
	local cFilialNum := ""
	local cSerie 	 := DHL_SERIE_INVENTARIO
	local cTipoNf  	 := SuperGetMv("MV_TPNRNFS")
	local cFornece	 := ""
	local cLoja		 := ""
	local cNumero	 := ""
	local cLote		 := ""
	local cTes		 := ""
	local nQuant 	 := 0	
	local cItem 	 := StrZero(0,TamSx3("D1_ITEM")[1])
	local aAux 		 := {}
	local aItensXML  := {}
	local nVUnit 	 := 0
	local nTotPrice	 := 0
	
	if (cApp == APP_DLX)
	
		cControle := oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ADJUSTMENT_ID:text")		
		cCnpj     := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SITE_CNPJ:text"))
		cCodProd  := AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ITEM:text"))
		
		retFornece(@cFornece, @cLoja, cCodProd)

		cNumero := NxtSX5Nota(cSerie, NIL, cTipoNf)
		
		aAdd(aCab,{"F1_FILIAL"  ,xFilial("SF1")  			  ,nil})
		aAdd(aCab,{"F1_DOC"     ,cNumero				 	  ,nil})
		aAdd(aCab,{"F1_SERIE"   ,cSerie       				  ,nil})
		aAdd(aCab,{"F1_FORNECE" ,cFornece  					  ,nil})
		aAdd(aCab,{"F1_LOJA"    ,cLoja 						  ,nil})
		aAdd(aCab,{"F1_EMISSAO" ,dDataBase 		              ,nil})
		aAdd(aCab,{"F1_TIPO"    ,"B"       		              ,nil})
		aAdd(aCab,{"F1_FORMUL"  ,"S"       		              ,nil})
		aAdd(aCab,{"F1_ESPECIE" ,"INV"      		          ,nil})			
		aAdd(aCab,{"F1_ZZADJID"	,cControle 		              ,nil})
		
		aItensXML := oXmlIp:getNodeArray("STK_ADJ:_BODY:_FILEHEADER")
		cTes	  := GetMv("ZZ_TESENT")
		
		for nI := 1 to Len(aItensXML)
			
			nQuant   := Val(aItensXML[nI]:_QUANTITY:text)
			cLote  	 := AllTrim(aItensXML[nI]:_LOT:text)
			
			nVUnit := retVUnit(cCodProd, cLote)
			
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
	
return


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
	local aAux 		 := {}
	local aItensXML  := {}
	local cCnpj 	 := ""
	local cFilialNum := ""
	local nVUnit 	 := 0
	local nTotPrice	 := 0
	local nSld   	:= 0
	local nSaldo 	:= 0
	local nVlrParcial, nVlrUnit, nSldTotal := 0
	local oSql		:= IpSqlObject():newIpSqlObject()
	local oSqlCli	:= IpSqlObject():newIpSqlObject()
	
	if (cApp == APP_DLX)
	
		cControle	:= oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ADJUSTMENT_ID:text")
		cCnpj     	:= AllTrim(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SITE_CNPJ:text"))
		cLote		:= oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_LOT:text")
		cSubLote	:= oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_SUBLOT:text")
		cCodProd	:= oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_ITEM:text")
		nQuant 		:= val(oXmlIp:getNodeValue("STK_ADJ:_BODY:_FILEHEADER:_QUANTITY:text"))
		
		nSld := nQuant
		
		if empty(cLote)
			cQryCli	:= getCliSld(nQuant, cCodProd)
			oSqlCli:newAlias(cQryCli)
			cCliFor	:= oSqlCli:getValue("B6_CLIFOR")
			cLoja	:= oSqlCli:getValue("B6_LOJA")
			oSqlCli:close()
			if empty(cCliFor)
				oLogImp:start(cApplication,DHL_IMPORTACAO,cXmlArq)
				oLogImp:fail(INTERFACE_NAME,"Não possuem movimentações com saldo para realizar o ajuste.")
				return .f.
			endif
		endif
		
		cQuery	:= getQueryItens(cCliFor, cLoja, cCodProd, cLote)
		oSql:newAlias(cQuery)
		
		aAdd(aCab,{"C5_FILIAL"  ,xFilial("SC5") 			  ,nil})
		aAdd(aCab,{"C5_TIPO" 	,"N"       					  ,nil})
		aAdd(aCab,{"C5_CLIENTE" ,oSql:getValue("B6_CLIFOR")   ,nil})
		aAdd(aCab,{"C5_LOJACLI" ,oSql:getValue("B6_LOJA") 	  ,nil})
		aAdd(aCab,{"C5_CONDPAG"	,AllTrim(getMv("ZZ_CONDINT")) ,nil})
		aAdd(aCab,{"C5_ZZADJID"	,cControle 		              ,nil})
		aAdd(aCab,{"C5_ZZESPEC" ,"INV"       		          ,nil})
		
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
			endif
		endif
		
//		for nI := 1 to Len(aItensXML)
//		
//			cCodProd := AllTrim(aItensXML[nI]:_ITEM:text)
//			nQuant   := Val(aItensXML[nI]:_QUANTITY:text)
//			
//			oSql:newTable("SB1","B1_COD,B1_LOCPAD","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+cCodProd+"'")
//			
//			nVUnit := oSql:getFieldValue("SB2","B2_CM1","B2_FILIAL = '"+xFilial("SB2")+"' AND B2_COD = '"+oSql:getValue("B1_COD")+"' AND B2_LOCAL = '"+oSql:getValue("B1_LOCPAD")+"'")
//			
//			oSql:close()
//		
//			aAux  := {}			
//			cItem := Soma1(cItem)
//			
//			nTotPrice := A410Arred(nQuant * nVUnit ,"C6_VALOR")
//			
//			aAdd(aAux,{"C6_ITEM"    ,cItem		 	 	,nil})
//			aAdd(aAux,{"C6_PRODUTO" ,cCodProd		  	,nil})
//			aAdd(aAux,{"C6_QTDVEN"  ,nQuant		 	    ,nil})
//			aAdd(aAux,{"C6_PRCVEN"  ,nVUnit		 	    ,nil})
//			aAdd(aAux,{"C6_VALOR"   ,nTotPrice	 	    ,nil})
//			aAdd(aAux,{"C6_TES"     ,GetMv("ZZ_TESSAI") ,nil})
//	
//			aAdd(aItens,aAux)
//			
//		next
	
	endif
	
return .t.


/**
 *	Função responsável pelo retorno da filial de acordo com o CNPJ.
 */
/*static function retFilial(cCNPJ)
	local cFilialNum:= ""
	local aArea		:= GetArea()
	local aAreaSM0	:= SM0->(GetArea())
	 
	DbSelectArea("SM0")
	SM0->(DBGoTop())
	
	while SM0->(!eof())
		if alltrim(SM0->M0_CGC) == alltrim(cCNPJ)
			cFilialNum	:= alltrim(SM0->M0_CODFIL)
			exit
		endif
		SM0->(dbSkip())
	endDo
	
	restArea(aAreaSM0)
	restArea(aArea)
	
return	cFilialNum*/


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


/* 
** Retorna valor unitário através de LIFO
*/
static function retVUnit(cCodProd, cLote)
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local cQuery 	:= ""	
	local nRet		:= 0
	
	cQuery += " Select * from (SELECT MAX(SD1.R_E_C_N_O_) RECNO, D1_VUNIT FROM %SD1.SQLNAME%       "+CRLF
	cQuery += " WHERE                                                                            "+CRLF
	cQuery += " 	%SD1.NOTDEL%                                                                 "+CRLF
	cQuery += " 	AND %SD1.XFILIAL%                                                            "+CRLF
	cQuery += " 	AND D1_COD 			= '"+cCodProd+"'                                         "+CRLF
	if !empty(cLote)
		cQuery += " 	AND D1_LOTECTL 			= '"+cLote+"'                                    "+CRLF
	endif
	cQuery += " GROUP BY D1_VUNIT Order by RECNO DESC) Where rownum = 1   "+CRLF
	
	oSqlUtil:newAlias(cQuery)
	
	nRet := oSqlUtil:getValue("D1_VUNIT")
	
	oSqlUtil:close() 
return(nRet)


/**
 * Obtem a query dos itens do pedido de venda
 */
static function getQueryItens(cCliFor, cLoja, cCodProd, cLote)

	local cQuery := ""
	
	cQuery := "SELECT D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_ITEM,D1_VUNIT,D1_LOCAL,D1_TOTAL,D1_EMISSAO,B6_FILIAL,B6_PRODUTO,B6_QUANT,"
	cQuery += "       B6_CLIFOR,B6_LOJA,B6_PODER3,B6_TPCF,B6_TIPO,B6_IDENT,B6_PRUNIT,B6_SALDO,F4_TESDV "
	cQuery += "FROM " + RetSqlName("SB6") + " SB6,"
	cQuery +=           RetSqlName("SD1") + " SD1,"
	cQuery +=           RetSqlName("SF4") + " SF4 "
	cQuery += "WHERE B6_FILIAL = '" + xFilial("SB6") + "' AND "
	if empty(cLote)
		cQuery += "      B6_CLIFOR = '" + cCliFor + "' AND "
		cQuery += "      B6_LOJA   = '" + cLoja + "' AND "
	endif
	cQuery += "      B6_PODER3 = 'R' AND "
	cQuery += "      B6_TPCF   = 'C' AND "
	cQuery += "      B6_TIPO   = 'D' AND "
	cQuery += "      B6_SALDO  > 0 AND "
	cQuery += " 	 SB6.D_E_L_E_T_ = ' ' AND "
	cQuery += "      D1_NUMSEQ = B6_IDENT AND "
	cQuery += "      D1_FILIAL = '" + xFilial("SD1") + "' AND "
	cQuery += "      D1_COD    = '" + cCodProd + "' AND "
	if !empty(cLote)
		cQuery += "      D1_LOTECTL    = '" + cLote + "' AND "
	endif
	cQuery += " SD1.D_E_L_E_T_ = ' ' AND "
	cQuery += "      F4_FILIAL = '" + xFilial("SF4") + "' AND "
	cQuery += "      F4_CODIGO = B6_TES AND "
	cQuery += " SF4.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY D1_EMISSAO "
	//FIFO
	// COM LOTE: PROD + LOTE + DATA DE VALID.
	// SEM LOTE: PROD + DATA DO DOCUMENTO

return cQuery


/**
 * 
 */
static function getCliSld(nQuant, cCodProd)

	local cQuery := ""
	
	cQuery := "SELECT B6_CLIFOR,B6_LOJA,B6_EMISSAO "
	cQuery += "       "
	cQuery += "FROM " + RetSqlName("SB6") + " SB6 "
	cQuery += "WHERE B6_FILIAL = '" + xFilial("SB6") + "' AND "
	cQuery += "      B6_PODER3 = 'R' AND "
	cQuery += "      B6_TIPO   = 'D' AND "
	cQuery += "      B6_TPCF   = 'C' AND "
	cQuery += "      B6_PRODUTO   = '" + cCodProd + "' AND "
	cQuery += "      B6_SALDO  > " + str(nQuant)+  " AND "
	cQuery += " 	 SB6.D_E_L_E_T_ = ' '  "
	cQuery += "GROUP BY "
	cQuery += " 	B6_PRODUTO, B6_CLIFOR, B6_LOJA, B6_EMISSAO "
	cQuery += "ORDER BY B6_EMISSAO "

return (cQuery)


/**
* Inclui conteúdo no array de alteração da rotina automática. Para contemplar todos os campos.
**/
static function montaItens(aAux)

	local nCount	:= 0
	local aCposSX3	:= FWSX3Util():GetAllFields("SC6", .f.)

	for nCount := 1 to len(aCposSX3)
	
		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U"
			aAdd(aAux,{AllTrim(aCposSX3[nCount]),&("SC6->" + AllTrim(aCposSX3[nCount])),nil})
		endIf
	
	next nCount
						
return


/**
* Coleta a Tes a ser utilizada
**/
static function getTes(oSql)

	local cTes := ""
	
	if upper(alltrim(SC5->C5_ZZESPEC)) ==  DHL_ESPECIE_INVENTARIO
		cTes := AllTrim(GetMv("ZZ_TESINV"))
	else
		cTes := oSql:getValue("F4_TESDV")
	endif
	
return cTes


static function retFornece(cFornece, cLoja, cCodProd)

	local cQuery	:= ""
	local oSql		:= IpSqlObject():newIpSqlObject()
	
	cQuery := "SELECT B6_CLIFOR,B6_LOJA "
	cQuery += "FROM " + RetSqlName("SB6") + " SB6 "
	cQuery += "WHERE B6_FILIAL = '" + xFilial("SB6") + "' AND "
	cQuery += "      B6_PODER3 = 'R' AND "
	cQuery += "      B6_TPCF   = 'C' AND "
	cQuery += "      B6_PRODUTO   = '" + cCodProd + "' AND "
	cQuery += " 	 SB6.D_E_L_E_T_ = ' '  "
	
	oSql:newAlias(cQuery)
	if oSql:hasRecords()
		cFornece := oSql:getValue("B6_CLIFOR")
		cLoja	 := oSql:getValue("B6_LOJA")
	endif
	oSql:close()

return
