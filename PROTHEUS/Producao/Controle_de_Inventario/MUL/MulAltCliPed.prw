#include "protheus.ch"
#include "dhl.ch"

#define OPC_ALTERACAO 4
#define POS_CLIENTE 1
#define POS_LOJA 2
#define POS_TIPO 3
#define TERCEIRO 1
#define PROPRIO 2

#define CAMPOS_SC6 	"C6_ITEM|C6_PRODUTO|C6_QTDVEN|C6_VALOR|C6_PRCVEN|C6_TES|C6_LOCAL|C6_NFORI|C6_SERIORI|C6_ITEMORI|C6_IDENTB6|C6_IPIDEV|C6_BLQ|"+;
	"C6_LOCALIZ|C6_CODFAB|C6_LOJAFA|C6_TPCONTR|C6_REGWMS|C6_VDMOST|"

/*/{Protheus.doc} AltCliPed

Altera o cliente / loja do pedido de venda
	
@author Renato Castro
@since 04/11/2014

/*/
User Function MulAltCliPed()

	local oDHLLibrary  := DHLLibrary():newDHLLibrary()
	
	private aCodLoja   := {}
	private lTemPoder3 := .T.
	private lTemID     := .T.
	private lTemPA	   := .F.
	private lProprio   := .F.
 
	if validaDoc()
		aCodLoja := oDHLLibrary:showChangeCliFor()
		if !(Empty(aCodLoja))
			altPed()
		endif
	endif

return


/**
 * Valida se o pedido pode ser alterado
 */
static function validaDoc()
	
	local lRetorno := .T.
	local oSql     := IpSqlObject():newIpSqlObject()
 
	if oSql:exists("SC6","C6_FILIAL = '" + SC5->C5_FILIAL + "' AND C6_NUM = '" + SC5->C5_NUM + "' AND C6_QTDVEN <= C6_QTDENT AND C6_BLQ = 'R' ")
		lRetorno := .F.
	endif

	if !(lRetorno)
		MsgAlert("Este pedido não pode ser alterado ! Verifique se ele não foi faturado.")
		return lRetorno
	endif
	
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		if upper(alltrim(SC5->C5_ZZESPEC)) != DHL_ESPECIE_INVENTARIO
			lRetorno := .F.
			MsgAlert("Este pedido não pode ser alterado ! Alteração permitida somente para espécie " + DHL_ESPECIE_INVENTARIO + "!")
		endif
	else
		if upper(alltrim(SC5->C5_ZZESPEC)) != DHL_ESPECIE_INVENTARIO
			if upper(alltrim(SC5->C5_ZZSTATU)) != DHL_PV_PENDENTE_INFORMACAO
				lRetorno := .F.
				MsgAlert("Este pedido não pode ser alterado ! Alteração permitida somente para espécie " + DHL_ESPECIE_INVENTARIO + " ou para Pedido Pendente de Ação!")
			endif
		endif
	endif
	
return lRetorno


/**
 * Altera o pedido via rotina automática
 */
static function altPed()

	local aCab   	:= {}
	local aItens 	:= {}
	local cTipoNf	:= ""
	local oSqlUpd	:= IpSqlObject():newIpSqlObject()

	getDadosPedVenda(@aCab,@aItens,@cTipoNf)
	
	If lProprio 
		MsgAlert("Permitida alteração apenas de Pedidos de Inventário para insumo de terceiro.", "Pedido não pode ser alterado")
		return
	EndIf
	
	if FWUnitBusiness() != DHL_BUSINESSUNIT_SPL
		if !(lTemPoder3)
			MsgAlert("Não há saldo em poder de terceiros para os itens do pedido ! Verifique.")
			return
		endif
	else
		if !(lTemID)
			MsgAlert("Não há ID´s disponíveis para todos os itens do pedido ! Verifique.")
			return
		endif
	endif
	
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| MATA410(x,y,z)},aCab,aItens,OPC_ALTERACAO)	
	
	if lMsErroAuto
		mostraErro()
	else
		if FWUnitBusiness() == DHL_BUSINESSUNIT_PKG .OR. FWUnitBusiness() == DHL_BUSINESSUNIT_MUL
			oSqlUpd:update("SC5", "C5_TIPO = '"+cTipoNf+"' ", " C5_FILIAL = '"+SC5->C5_FILIAL+"' AND C5_NUM = '"+SC5->C5_NUM+"'")
		endif
		MsgAlert("Pedido alterado com sucesso !")
	endif
	
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
* Coleta a Tes a ser utilizada
**/
static function getTes(oSql)

	local cTes := ""
	
	if upper(alltrim(SC5->C5_ZZESPEC)) ==  DHL_ESPECIE_INVENTARIO
		cTes := AllTrim(GetMv("ZZ_TESINV"))
	else
		cTes := iif(lTemPA, oSql:getValue("F4_TESDV"), oSql:getValue("F4_ZZTESFE"))
	endif
	
return cTes

/**
* Coleta a Tes do produto a ser utilizada
**/
static function getTesProd(cProd)

	local cTes 		:= ""
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	
	cTes := oSqlUtil:getFieldValue("SB1", "B1_TS", " %SB1.XFILIAL% AND B1_COD = '"+cProd+"' ")
		
return cTes


/**
 * Obtem a query dos itens do pedido de venda
 */
static function getQueryItens()

	local cQuery := ""
	
	cQuery := "SELECT D1_DOC,D1_SERIE,D1_ITEM,D1_VUNIT,D1_LOCAL,D1_TOTAL,B6_FILIAL,B6_PRODUTO,B6_QUANT, D1_LOTECTL, D1_DTVALID, "
	cQuery += "       B6_CLIFOR,B6_LOJA,B6_PODER3,B6_TPCF,B6_TIPO,B6_IDENT,B6_PRUNIT,B6_SALDO,F4_TESDV, F4_ZZTESFE, D1_DTDIGIT "
	cQuery += "FROM " + RetSqlName("SB6") + " SB6,"
	cQuery +=           RetSqlName("SD1") + " SD1,"
	cQuery +=           RetSqlName("SF4") + " SF4 "
	cQuery += "WHERE B6_FILIAL = '" + xFilial("SB6") + "' AND "
	cQuery += "      B6_CLIFOR = '" + aCodLoja[POS_CLIENTE] + "' AND "
	cQuery += "      B6_LOJA   = '" + aCodLoja[POS_LOJA] + "' AND "
	cQuery += "      B6_PODER3 = 'R' AND "
	cQuery += "      B6_TPCF   = '" + iif(aCodLoja[POS_TIPO] == "cliente","C","F") + "' AND "
	cQuery += "      B6_TIPO   = 'D' AND "
	cQuery += "      B6_SALDO  > 0 AND "
	cQuery += " SB6.D_E_L_E_T_ = ' ' AND "
	cQuery += "      D1_NUMSEQ = B6_IDENT AND "
	cQuery += "      D1_FILIAL = '" + xFilial("SD1") + "' AND "
	cQuery += "      D1_COD    = '" + SC6->C6_PRODUTO + "' AND "
	if !empty(SC6->C6_LOTECTL)
		cQuery += "      D1_LOTECTL    = '" + SC6->C6_LOTECTL + "' AND "
		cQuery += "      D1_DTVALID    = '" + dtos(SC6->C6_DTVALID) + "' AND "
	endif
	cQuery += " SD1.D_E_L_E_T_ = ' ' AND "
	cQuery += "      F4_FILIAL = '" + xFilial("SF4") + "' AND "
	cQuery += "      F4_CODIGO = B6_TES AND "
	cQuery += " SF4.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY D1_DTDIGIT, D1_EMISSAO "
	if !empty(SC6->C6_LOTECTL)
		cQuery += "   ,D1_LOTECTL, D1_DTVALID  "
	endif

return cQuery


/**
 * Obtem a query dos itens do pedido de venda
 */
static function getQueryID()

	local cQuery := ""
	
	cQuery := "SELECT MAX(Z3_SEQUEN),Z3_ID,Z3_VUNIT,F4_TESDV,D1_LOCAL,Z3_DOC,"
	cQuery += "       Z3_SERIE,Z3_ITEM,Z3_IDENTB6,Z3_DTMOV,Z3_PRODUTO "
	cQuery += "FROM " + RetSqlName("SZ3") + " SZ3,"
	cQuery +=           RetSqlName("SD1") + " SD1,"
	cQuery +=           RetSqlName("SF4") + " SF4 "
	cQuery += "WHERE Z3_FILIAL  = '" + xFilial("SZ3") + "' AND "
	cQuery += "      Z3_CLIFOR  = '" + aCodLoja[POS_CLIENTE] + "' AND "
	cQuery += "      Z3_LOJA    = '" + aCodLoja[POS_LOJA] + "' AND "
	cQuery += "      Z3_PRODUTO = '" + SC6->C6_PRODUTO + "' AND "
	cQuery += "      Z3_SITUACA <> 'E' AND "
	cQuery += "      Z3_TPMOV   = 'E' AND "
	cQuery += "  SZ3.D_E_L_E_T_ = ' ' AND "
	cQuery += "      D1_DOC  	= Z3_DOC AND "
	cQuery += "      D1_SERIE  	= Z3_SERIE AND "
	cQuery += "      D1_ITEM  	= Z3_ITEM AND "
	cQuery += "      D1_FORNECE	= Z3_CLIFOR AND "
	cQuery += "      D1_LOJA  	= Z3_LOJA AND "
	cQuery += "      D1_FILIAL  = '" + xFilial("SD1") + "' AND "
	cQuery += "  SD1.D_E_L_E_T_ = ' ' AND "
	cQuery += "      F4_FILIAL  = '" + xFilial("SF4") + "' AND "
	cQuery += "      F4_CODIGO  = D1_TES AND "
	cQuery += "  SF4.D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY Z3_ID,Z3_VUNIT,F4_TESDV,D1_LOCAL,Z3_DOC,Z3_SERIE,Z3_ITEM,Z3_IDENTB6,Z3_DTMOV,Z3_PRODUTO "
	cQuery += "ORDER BY Z3_DTMOV "

return cQuery

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


/*
** Verifica se pedido possuí PA
*/
static function validPA()
	local aAreaSC6 	:= SC6->(GetArea())
	local oSql		:= IpSqlObject():NewIpSqlObject()

	while SC6->C6_NUM == SC5->C5_NUM
		if oSql:getFieldValue("SB1", "B1_TIPO", " %SB1.XFILIAL% AND B1_COD = '"+SC6->C6_PRODUTO+"' ") == "PA"
			lTemPA := .T.
		endif
		SC6->(DbSkip())
	end
	
//	SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
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
				
	cAgregCu := oSqlSB1:getFieldValue("SB1","B1_AGREGCU","B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+oSqlSB1:getValue("B1_COD")+"'")
	
	If !Empty(cAgregCu)
		nAgregCu := Val(cAgregCu)
	EndIf
				
	oSqlSB1:Close()
	
Return nAgregCu