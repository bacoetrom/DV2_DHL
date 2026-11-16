#include "protheus.ch"
#include "dhl.ch"

#define OPC_ALTERACAO 4
#define POS_CLIENTE 1
#define POS_LOJA 2
#define POS_TIPO 3

#define CAMPOS_SC6 	"C6_ITEM|C6_PRODUTO|C6_QTDVEN|C6_VALOR|C6_PRCVEN|C6_TES|C6_LOCAL|C6_NFORI|C6_SERIORI|C6_ITEMORI|C6_IDENTB6|C6_IPIDEV|C6_BLQ|"+;
					"C6_LOCALIZ|C6_CODFAB|C6_LOJAFA|C6_TPCONTR|C6_REGWMS|C6_VDMOST|"

/*/{Protheus.doc} AgeAltCli

Altera o cliente / loja do pedido de venda
	
@author Renato Castro
@since 04/11/2014

/*/
User Function AgeAltCli()

	local oDHLLibrary  := DHLLibrary():newDHLLibrary()
	
	private aCodLoja   := {}
	private lTemPoder3 := .T.
	private lTemID     := .T.
 
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
	
	lRetorno := IsPedidoOk()	

	if !(lRetorno)
		MsgAlert("Este pedido não pode ser alterado ! Verifique se ele não foi faturado.")
		return lRetorno
	endif
	
	if upper(alltrim(SC5->C5_ZZESPEC)) != DHL_ESPECIE_INVENTARIO
		if upper(alltrim(SC5->C5_ZZSTATU)) != DHL_PV_PENDENTE_INFORMACAO
			lRetorno := .F.
			MsgAlert("Este pedido não pode ser alterado ! Alteração permitida somente para espécie " + DHL_ESPECIE_INVENTARIO + " ou para Pedido Pendente de Ação!")
		endif 			
	endif
	
return lRetorno

/**
 * Verifica se existe registro com os filtros informados
 */
Static Function IsPedidoOk()

	local oSql	  	  := IpSqlObject():newIpSqlObject()	
	local lIsRegistro := .F.
	local cQuery := " SELECT "
          cQuery += " 	C5_NUM, "
          cQuery += " 	C6_QTDVEN, "
          cQuery += " 	C6_QTDENT, "
          cQuery += " 	C6_BLQ 	"
          cQuery += " FROM  "
          cQuery += " 	%SC5.SQLNAME% "
          cQuery += " INNER JOIN %SC6.SQLNAME% ON "
          cQuery += " 	C6_NUM=C5_NUM "
          cQuery += " WHERE	"
          cQuery += " 	C5_FILIAL = '%SC5.FILIAL%' AND "
          cQuery += " 	C6_FILIAL = '%SC6.FILIAL%' AND "
          cQuery += " 	C5_NUM='"+SC5->C5_NUM+"' AND "
          cQuery += " 	C5_TIPO='N' AND	"
          cQuery += " 	C6_QTDVEN > C6_QTDENT AND "      
          cQuery += " 	%SC5.NOTDEL% AND "
          cQuery += " 	%SC6.NOTDEL% "	
	
	oSql:newAlias(changeQuery(cQuery)) 
	lIsRegistro := oSql:hasRecords()
	oSql:Close()	
	
Return lIsRegistro


/**
 * Altera o pedido via rotina automática
 */
static function altPed()

	local aCab   	:= {}
	local aItens 	:= {}
	local cTipoNf	:= ""
	local oSqlUpd	:= IpSqlObject():newIpSqlObject()

	getDadosPedVenda(@aCab,@aItens,@cTipoNf)
	
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| MATA410(x,y,z)},aCab,aItens,OPC_ALTERACAO)
	
	if lMsErroAuto
		mostraErro()
	else
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
	
	aAdd(aCab,{"C5_FILIAL" ,SC5->C5_FILIAL       ,nil})
	aAdd(aCab,{"C5_NUM"    ,SC5->C5_NUM          ,nil})
	aAdd(aCab,{"C5_TIPO"   ,cTipo                ,nil})
	aAdd(aCab,{"C5_CLIENTE",aCodLoja[POS_CLIENTE],nil})
	aAdd(aCab,{"C5_LOJACLI",aCodLoja[POS_LOJA]   ,nil})
	aAdd(aCab,{"C5_CONDPAG",SC5->C5_CONDPAG      ,nil})
	aAdd(aCab,{"C5_ZZSTATU",""               ,nil})
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
	
	while SC6->C6_NUM == SC5->C5_NUM
		aAux := {}
		
		aAdd(aAux,{"C6_ITEM"   ,SC6->C6_ITEM        ,nil})
		aAdd(aAux,{"C6_PRODUTO",SC6->C6_PRODUTO     ,nil})
		aAdd(aAux,{"C6_QTDVEN" ,SC6->C6_QTDVEN      ,nil})
		aAdd(aAux,{"C6_PRCVEN" ,SC6->C6_PRCVEN 		,nil})
		aAdd(aAux,{"C6_TES"    ,SC6->C6_TES    		,nil})
		aAdd(aAux,{"C6_LOCAL"  ,SC6->C6_LOCAL  		,nil})
		aAdd(aAux,{"C6_LOTECTL"  ,SC6->C6_LOTECTL	,nil})
		aAdd(aAux,{"C6_DTVALID"  ,SC6->C6_DTVALID   ,nil})
		
		montaItens(@aAux)
		
		aAdd(aItens,aAux)
		
		SC6->(dbSkip())
	enddo
	
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