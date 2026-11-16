#include "protheus.ch"
#include "dhl.ch"

#define OPC_ALTERACAO 4
#define POS_CLIENTE 1
#define POS_LOJA 2
#define POS_TIPO 3

#define TRANSP	1
#define REDESP	2
#define VOLUME1	3
#define ESPECI1	4

//Objeto para a classe FwTemporaryTable (Cria tabela temporária no banco de dados)
Static oTable

/*/{Protheus.doc} Ag2AltCli

Altera o cliente / loja do pedido de venda

@author Renato Castro
@since 04/11/2014

/*/
User Function Ag2AltCli(aCliente,aProdutos,lImpMsaNfe,aTransp)

local lRet				:= .t.
local oDHLLibrary  	:= DHLLibrary():newDHLLibrary()

private aCodLoja		:= {}
private lTemPoder3	:= .T.
private lTemID		:= .T.
private lTemPA		:= .F.
private aItensRef		:= {}
private oLog			:= DHLLogManager():newDHLLogManager()

default aCliente		:= {}
default aProdutos		:= {}
default aTransp		:= {}
default lImpMsaNfe 	:= .f.

FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW " + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})

if validaDoc(lImpMsaNfe)
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- SHOWCHANGECLIFOR " + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})
	
	if isRetEfetivo()
		u_Ag2AltRet(aProdutos,lImpMsaNfe,aTransp)
	else
		if !Empty(aCliente)
			aCodLoja := aClone(aCliente)
		else
			aCodLoja := oDHLLibrary:showChangeCliFor()
		endif
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- ANTES ALTPED" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})
		
		if !(Empty(aCodLoja))
			if !lImpMsaNfe
				FWMsgRun(, {|| lRet := AltPed(aProdutos,lImpMsaNfe,aTransp)},"Aguarde","Aguarde, processando")
			else
				if !AltPed(aProdutos,lImpMsaNfe,aTransp)
					lRet := .f.
				endif
			endif
		endif
	endif
Else
	lRet := .f.
endif

FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** FIM FONTE Ag2AltCli.PRW " + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})

return ({lRet,aItensRef})


/**
* Valida se o pedido pode ser alterado
*/
static function validaDoc(lImpMsaNfe)

local lRetorno := .T.

lRetorno := IsPedidoOk()

if !(lRetorno)
	if !lImpMsaNfe
		MsgAlert("Este pedido de venda não pode ser alterado ! Verifique se ele não foi faturado.")
	else
		DisarmTransaction()
		setFileLog("fail","O pedido de venda " + AllTrim(SC5->C5_NUM) + " não pode ser alterado ! Verifique se ele não foi faturado.")
	endif
	return lRetorno
endif

if upper(alltrim(SC5->C5_ZZESPEC)) != DHL_ESPECIE_INVENTARIO
	if upper(alltrim(SC5->C5_ZZSTATU)) != DHL_PV_PENDENTE_INFORMACAO .and. (!IsInCallStack("u_ImpMsaNfe") .and. !(FunName() == "MONIP040"))
		lRetorno := .F.
		if !lImpMsaNfe
			MsgAlert("Este pedido de venda não pode ser alterado ! Alteração permitida somente para espécie " + DHL_ESPECIE_INVENTARIO + " ou para Pedido Pendente de Ação!")
		else
			DisarmTransaction()
			setFileLog("fail","O pedido de venda " + AllTrim(SC5->C5_NUM) + " não pode ser alterado ! Alteração permitida somente para espécie " + DHL_ESPECIE_INVENTARIO + " ou para Pedido Pendente de Ação!")
		endif
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
static function AltPed(aProdutos,lImpMsaNfe,aTransp)

local lRet		:= .t.
local aCab   	:= {}
local aItens 	:= {}
local oSqlUpd	:= IpSqlObject():newIpSqlObject()
local oUtils	:= IpUtilsObject():newIpUtilsObject()

FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- ANTES GETDADOSPEDVENDA" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})

if !getDadosPedVenda(@aCab,@aItens,aProdutos,lImpMsaNfe,aTransp)
	lRet := .f.
	return (lRet)
endIf

FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- ANTES MSG PODER DE TERCEIRO" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})

if !(lTemPoder3)
	if !lImpMsaNfe
		MsgAlert("Não há saldo em poder de terceiros para os itens do pedido de venda ! Verifique.")
		DisarmTransaction() //Gustavo 20/08/19 - Necessário colocar o DisarmTransaction() para voltar a informação dos campos ZB_PEDIDO e ZB_ITEMPV para vazio, para permitir um novo processamento.
	else
		//DisarmTransaction() //Emerson Holanda 27/03/18 - Faturamento simultaneo
		setFileLog("fail","Não há saldo em poder de terceiro para os itens do pedido de venda " + AllTrim(SC5->C5_NUM) + " ! Verifique.")
	endif
	lRet := .f.
	return (lRet)
endif

FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- ANTES MATA410" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})

lMsErroAuto := .F.
//Emerson Holanda - 25/04/18 - Inclusão apenas do controle de transação na alteração do pedido de venda
BEGIN TRANSACTION
MSExecAuto({|x,y,z| MATA410(x,y,z)},aCab,aItens,OPC_ALTERACAO)
END TRANSACTION

FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- DEPOIS MATA410" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})

if lMsErroAuto
	if !lImpMsaNfe
		mostraErro()
	else
		//DisarmTransaction()
		setFileLog("fail","Falha ao alterar o pedido de venda " + AllTrim(SC5->C5_NUM) + " ! Verifique." + oUtils:getErroAuto())
	endif
	lRet := .f.
else
	if !lImpMsaNfe
		//MsgAlert("Pedido de venda alterado com sucesso !")
	endif
endif

return (lRet)


/**
* Obtem as arrays da rotina automática de pedido de venda
*/
static function getDadosPedVenda(aCab,aItens,aProdutos,lImpMsaNfe,aTransp)

local cItem     := StrZero(0,TamSx3("C6_ITEM")[1])
local aAux      := {}
local aSC6      := SC6->(GetArea())
local cQuery    := ""
local cItemMax  := ""
local cItemAtu  := ""
local oSql      := IpSqlObject():newIpSqlObject()
local oLogImp   := DHLLogManager():newDHLLogManager()
local nSld      := 0
local cTipo     := ""
local nSaldo    := 0
local nVlrParcial, nVlrUnit, nSldTotal := 0
local lRet		:= .t.
local lRef		:= .t.
local nPos		:= 0

default aProdutos := {}

if aCodLoja[POS_TIPO] == "cliente"
	cTipo := "N"
else
	cTipo := "B"
endif

FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- DEPOIS CABECALHO PEDIDO" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})

aAdd(aCab,{"C5_FILIAL" ,SC5->C5_FILIAL			,nil})
aAdd(aCab,{"C5_NUM"    ,SC5->C5_NUM			,nil})
aAdd(aCab,{"C5_TIPO"   ,cTipo					,nil})
aAdd(aCab,{"C5_CLIENTE",aCodLoja[POS_CLIENTE]	,nil})
aAdd(aCab,{"C5_LOJACLI",aCodLoja[POS_LOJA]	,nil})
aAdd(aCab,{"C5_CONDPAG",SC5->C5_CONDPAG		,nil})
aAdd(aCab,{"C5_ZZSTATU",""						,nil})

If Len(aTransp) > 0
	aAdd(aCab,{"C5_TRANSP", aTransp[TRANSP]						,nil})
	aAdd(aCab,{"C5_REDESP", aTransp[REDESP]						,nil})
	aAdd(aCab,{"C5_VOLUME1",aTransp[VOLUME1]					,nil})
	aAdd(aCab,{"C5_ESPECI1",aTransp[ESPECI1]					,nil})
Endif

dbSelectArea("SC6")
dbSetOrder(1)
SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))

FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- LACO SC6" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})

while SC6->C6_NUM == SC5->C5_NUM
	aAux := {}
	
	if !Empty(aProdutos)
		nPos := aScan(aProdutos,SC6->C6_PRODUTO)
		if nPos == 0
			cItemMax := SC6->C6_ITEM
			SC6->(dbSkip())
			loop
		endif
	endif
	
	aAdd(aAux,{"LINPOS"   ,"C6_ITEM",SC6->C6_ITEM})
	aAdd(aAux,{"AUTDELETA","S" 		,nil})
	
	aAdd(aItens,aAux)
	
	cItemMax := SC6->C6_ITEM
	SC6->(dbSkip())
enddo

aAux := {}
SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))

FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- LACO REFERENCIAS" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})

while SC6->C6_NUM == SC5->C5_NUM
	
	lRef := .t.
	
	if !Empty(aProdutos)
		nPos := aScan(aProdutos,SC6->C6_PRODUTO)
		if nPos > 0
			lRef := .t.
		else
			lRef := .f.
		endif
	endif
	
	if lRef
		nSld := SC6->C6_QTDVEN
		
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- GETQUERYITENS - L:293" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})
		
		cQuery	:= getQueryItens()
		
		oSql:newAlias(cQuery)
		
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- MONTAGEM PEDIDO" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})
		
		if oSql:hasRecords()
			
			criaAreaTrab(cQuery)
			
			while oSql:notIsEof()
				
				lTemPoder3 := .T.
				
				aAux := {}
				
				nVlrParcial:= 0
				nVlrUnit   := 0
				nSldTotal  := 0
				
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- VALIDACAO SALDO" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})
				
				if nSld <= getSldMov(oSql) //getSaldo(oSql)    //Emerson Holanda 23/03/18 -Faturamento Simultaneo
					nSaldo 		:= nSld
					atualizSaldoTemp(oSql, getSldMov(oSql) - nSaldo, nSaldo) //atualizSaldoTemp(oSql, getSaldo(oSql) - nSaldo, nSaldo)   //Emerson Holanda 23/03/18 -Faturamento Simultaneo
				else
					nSaldo		:= getSldMov(oSql) //getSaldo(oSql)  //Emerson Holanda 23/03/18 -Faturamento Simultaneo
					atualizSaldoTemp(oSql, 0 ,nSaldo)
				endif
				
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- VALIDACAO DE SALDO L:325" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})
				
				/* # Diogo Mesquita #
				Linhas abaixo comentadas devido não fazer sentido recalcular o valor unitario do produto no pedido de venda, pois acaba ficando diferente 
				do valor unitario da nota fiscal de entrada ocasionando a mensagem: Valor unitario deste produto não pode ser alterado, pois este produto 
				pertence a poder de terceiros, onde o valor unitário deve ser o mesmo da nota fiscal de remessa.
				*/
				//if nSaldo < getValueTRB("B6_QUANT")
					nSldTotal 	:= getValueTRB("B6_QUANT")
					
					nVlrUnit    := getValueTRB("D1_VUNIT")
					nVlrParcial := nVlrUnit * nSaldo
				/*else
					nVlrParcial	:= getValueTRB("D1_TOTAL")
					nVlrUnit 	:= nVlrParcial / nSaldo
				endif*/
				
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- REGISTRO IGNORADA L:337" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})
				
				if nSaldo * A410Arred(nVlrUnit , "C6_PRCVEN") < 0.01
					oLogImp:start("PV","PV","")
					oLogImp:warn("REGISTRO IGNORADO PEDIDO "+SC5->C5_NUM, "Valor total item "+getValueTRB("B6_PRODUTO")+" para NF "+getValueTRB("D1_DOC")+;
					"/"+getValueTRB("D1_SERIE")+" não atingiu valor minimo 0,01.")
					oSql:skip()
					loop
				endif
				
				If AllTrim(cItemAtu) == Alltrim(SC6->C6_ITEM)
					cItemMax := Soma1(cItemMax)
					cItem    := cItemMax
					cItemAtu := SC6->C6_ITEM
				Else
					cItem    := SC6->C6_ITEM
					cItemAtu := SC6->C6_ITEM
				EndIf
				
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- MONTAGEM SC6 REFERENCIAS L:356" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})
				
				aAdd(aAux,{"C6_ITEM"   ,cItem                      			,nil})
				aAdd(aAux,{"C6_PRODUTO",getValueTRB("B6_PRODUTO")			,nil})
				aAdd(aAux,{"C6_QTDVEN" ,nSaldo                     			,nil})
				aAdd(aAux,{"C6_PRCVEN" ,A410Arred(nVlrUnit ,"C6_PRCVEN")  	,nil})
				aAdd(aAux,{"C6_VALOR"  ,A410Arred(nVlrParcial,"C6_VALOR")	,nil})
				aAdd(aAux,{"C6_QTDLIB" ,nSaldo                     			,nil})
				aAdd(aAux,{"C6_PRUNIT" ,A410Arred(nVlrUnit ,"C6_PRCVEN")  	,nil})
				aAdd(aAux,{"C6_TES"    ,getTes(@oSql)              			,nil})
				aAdd(aAux,{"C6_LOCAL"  ,getValueTRB("D1_LOCAL")  			,nil})
				aAdd(aAux,{"C6_NFORI"  ,getValueTRB("D1_DOC")    			,nil})
				aAdd(aAux,{"C6_SERIORI",getValueTRB("D1_SERIE")  			,nil})
				aAdd(aAux,{"C6_ITEMORI",getValueTRB("D1_ITEM")   			,nil})
				aAdd(aAux,{"C6_IDENTB6",getValueTRB("B6_IDENT")  			,nil})
				
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- MONTAITENS L:372" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})
				
				montaItens(@aAux)
				
				aAdd(aItens,aAux)
				
				nSld -=  iif(nSld <= getValueTRB("B6_SALDO"),nSld  , nSaldo)
				
				aAdd(aItensRef,{SC5->C5_NUM, cItem, getValueTRB("B6_PRODUTO")})
				
				if nSld == 0
					exit
				endif
				
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- SKIP REFERENCIAS L:386" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})
				
				oSql:skip()
				
			enddo
			if nSld > 0
				lTemPoder3 := .F.
				exit
			endif
		else
			lRet := .F.
			if !lImpMsaNfe
				MsgAlert("Não foi encontrado o documento de origem para referenciar no pedido de venda. Verifique se o cliente / fornecedor selecionado está correto.")
			else
				//DisarmTransaction() //Emerson Holanda 27/03/18 Faturamento simultaneo
				setFileLog("fail","Não foi encontrado o documento de origem para referenciar no pedido de venda " + AllTrim(SC5->C5_NUM) + " ! Verifique se o cliente / fornecedor selecionado está correto.")
			endif
			exit
		endIf
		
		oSql:close()
	endif
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW -- SKIP ITENS L:409" + time() + " USUARIO " + __cUserID  + " **********", 0, 0, {})
	
	SC6->(dbSkip())
	
enddo

//Deleta tabela temporaria criada no banco de dados
If oTable <> Nil
	oTable:Delete()
	oTable := Nil
Endif

RestArea(aSC6)

return lRet


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

/**
* Obtem a query dos itens do pedido de venda
*/
static function getQueryItens()

local cQuery := ""

cQuery := "SELECT SB6.R_E_C_N_O_ B6_RECNO, D1_DOC,D1_SERIE,D1_ITEM,D1_VUNIT,D1_LOCAL,D1_TOTAL,B6_FILIAL,B6_PRODUTO,B6_QUANT,"					+ CRLF
cQuery += "       B6_CLIFOR,B6_LOJA,B6_PODER3,B6_TPCF,B6_TIPO,B6_IDENT,B6_PRUNIT,B6_SALDO ,F4_TESDV, F4_ZZTESFE, F4_ZZTESDE, D1_DTDIGIT "       + CRLF
cQuery += "FROM " + RetSqlName("SB6") + " SB6,"                                                                                                 + CRLF
cQuery +=           RetSqlName("SD1") + " SD1,"                                                                                                 + CRLF
cQuery +=           RetSqlName("SF4") + " SF4 "                                                                                                 + CRLF
cQuery += "WHERE B6_FILIAL = '" + xFilial("SB6") + "' AND "                                                                                     + CRLF
cQuery += "      B6_CLIFOR = '" + aCodLoja[POS_CLIENTE] + "' AND "                                                                              + CRLF
cQuery += "      B6_LOJA   = '" + aCodLoja[POS_LOJA] + "' AND "                                                                                 + CRLF
cQuery += "      B6_PODER3 = 'R' AND "                                                                                                          + CRLF
cQuery += "      B6_TPCF   = '" + iif(aCodLoja[POS_TIPO] == "cliente","C","F") + "' AND "                                                       + CRLF
cQuery += "      B6_TIPO   = 'D' AND "                                                                                                          + CRLF
//Emerson HOlanda 23/03/18 - faturamento simultaneo
//cQuery += "      (B6_SALDO - (B6_QULIB + B6_XQTDMOV) ) > 0 AND "                                                                              + CRLF                  + CRLF
cQuery += "      (B6_SALDO - B6_QULIB) > 0 AND "                                                                                     			+ CRLF
cQuery += " SB6.D_E_L_E_T_ = ' ' AND "                                                                                                          + CRLF
cQuery += "      D1_NUMSEQ = B6_IDENT AND "                                                                                                     + CRLF
cQuery += "      D1_FILIAL = '" + xFilial("SD1") + "' AND "                                                                                     + CRLF
cQuery += "      D1_COD    = '" + SC6->C6_PRODUTO + "' AND "                                                                                    + CRLF
cQuery += " SD1.D_E_L_E_T_ = ' ' AND "                                                                                                          + CRLF
cQuery += "      F4_FILIAL = '" + xFilial("SF4") + "' AND "                                                                                     + CRLF
cQuery += "      F4_CODIGO = B6_TES AND "                                                                                                       + CRLF
cQuery += " SF4.D_E_L_E_T_ = ' ' "                                                                                                              + CRLF
cQuery += " ORDER BY D1_DTDIGIT, D1_EMISSAO, D1_DOC "                                                                                                   + CRLF

return cQuery

/**
* Coleta a Tes a ser utilizada
**/
static function getTes(oSql)

local cTes := ""

If upper(alltrim(SC5->C5_ZZESPEC)) ==  DHL_ESPECIE_INVENTARIO
	cTes := AllTrim(GetMv("ZZ_TESINV"))
Else
	If SC5->C5_ZZTPPV == RETORNO_SIMBOLICO
		cTes := getValueTRB("F4_TESDV")
	Else
		cTes := getValueTRB("F4_ZZTESDE")
	EndIf
EndIf

return cTes


/**
* Define os Logs
*/
static function setFileLog(cLogType,cLogText)

local cInterface := "SAP IP_040"

oLog:start(APP_SAP, DHL_IMPORTACAO)

if (cLogType == "fail")
	oLog:fail(cInterface, cLogText)
elseIf (cLogType == "warn")
	oLog:warn(cInterface, cLogText)
endIf

return

/**
* Cria arquivo de trabalho
*/
static function criaAreaTrab(cQuery)

aStru:={}

if Select ( "TRB" ) == 0
	
	Aadd(aStru,{ "B6_REC"		, "N"	  				  , 14							, 0 						} )
	Aadd(aStru,{ "D1_DOC"		, TamSx3("D1_DOC")[3]	  , TamSx3("D1_DOC")[1]			, TamSx3("D1_DOC")[2] 		} )
	Aadd(aStru,{ "D1_SERIE"		, TamSx3("D1_SERIE")[3]	  , TamSx3("D1_SERIE")[1]		, TamSx3("D1_SERIE")[2] 	} )
	Aadd(aStru,{ "D1_ITEM"  	, TamSx3("D1_ITEM")[3] 	  , TamSx3("D1_ITEM")[1]		, TamSx3("D1_ITEM")[2] 		} )
	Aadd(aStru,{ "D1_VUNIT" 	, TamSx3("D1_VUNIT")[3]	  , TamSx3("D1_VUNIT")[1]		, TamSx3("D1_VUNIT")[2] 	} )
	Aadd(aStru,{ "D1_LOCAL" 	, TamSx3("D1_LOCAL")[3]   , TamSx3("D1_LOCAL")[1]		, TamSx3("D1_LOCAL")[2] 	} )
	Aadd(aStru,{ "B6_FILIAL"	, TamSx3("B6_FILIAL")[3]  , TamSx3("B6_FILIAL")[1]		, TamSx3("B6_FILIAL")[2]	} )
	Aadd(aStru,{ "B6_PRODUTO"	, TamSx3("B6_PRODUTO")[3] , TamSx3("B6_PRODUTO")[1]		, TamSx3("B6_PRODUTO")[2] 	} )
	Aadd(aStru,{ "B6_QUANT"		, TamSx3("B6_QUANT")[3]	  , TamSx3("B6_QUANT")[1]		, TamSx3("B6_QUANT")[2] 	} )
	Aadd(aStru,{ "B6_CLIFOR"	, TamSx3("B6_CLIFOR")[3]  , TamSx3("B6_CLIFOR")[1]		, TamSx3("B6_CLIFOR")[2] 	} )
	Aadd(aStru,{ "B6_LOJA"		, TamSx3("B6_LOJA")[3]	  , TamSx3("B6_LOJA")[1]		, TamSx3("B6_CLIFOR")[2] 	} )
	Aadd(aStru,{ "B6_PODER3"	, TamSx3("B6_PODER3")[3]	, TamSx3("B6_PODER3")[1]	, TamSx3("B6_PODER3")[2] 	} )
	Aadd(aStru,{ "B6_TPCF"		, TamSx3("B6_TPCF")[3]		, TamSx3("B6_TPCF")[1]		, TamSx3("B6_TPCF")[2] 	 	} )
	Aadd(aStru,{ "B6_TIPO"		, TamSx3("B6_TIPO")[3]		, TamSx3("B6_TIPO")[1]		, TamSx3("B6_TIPO")[2] 	 	} )
	Aadd(aStru,{ "B6_IDENT"		, TamSx3("B6_IDENT")[3]		, TamSx3("B6_IDENT")[1]		, TamSx3("B6_IDENT")[2]	 	} )
	Aadd(aStru,{ "B6_PRUNIT"	, TamSx3("B6_PRUNIT")[3]	, TamSx3("B6_PRUNIT")[1]	, TamSx3("B6_PRUNIT")[2] 	} )
	Aadd(aStru,{ "B6_SALDO"		, TamSx3("B6_SALDO")[3]		,  TamSx3("B6_SALDO")[1]	, TamSx3("B6_SALDO")[2]  	} )
	Aadd(aStru,{ "F4_TESDV"		, TamSx3("F4_TESDV")[3]		, TamSx3("F4_TESDV")[1]		, TamSx3("F4_TESDV")[2]  	} )
	Aadd(aStru,{ "F4_ZZTESFE"	, TamSx3("F4_ZZTESFE")[3]	, TamSx3("F4_ZZTESFE")[1]	, TamSx3("F4_ZZTESFE")[2]	} )
	Aadd(aStru,{ "F4_ZZTESDE"	, TamSx3("F4_ZZTESDE")[3]	, TamSx3("F4_ZZTESDE")[1]	, TamSx3("F4_ZZTESDE")[2]	} )
	Aadd(aStru,{ "D1_DTDIGIT"	, TamSx3("D1_DTDIGIT")[3]	, TamSx3("D1_DTDIGIT")[1]	, TamSx3("D1_DTDIGIT")[2]	} )
	Aadd(aStru,{ "D1_TOTAL"		, TamSx3("D1_TOTAL")[3]		, TamSx3("D1_TOTAL")[1]		, TamSx3("D1_TOTAL")[2]		} )
	Aadd(aStru,{ "ZZ_TOTCONS"	, TamSx3("B6_SALDO")[3]		, TamSx3("B6_SALDO")[1]		, TamSx3("B6_SALDO")[2]		} )
	
	If oTable <> Nil
		oTable:Delete()
		oTable := Nil
	Endif
	
	oTable := FWTemporaryTable():New("TRB",aStru)
	oTable:AddIndex("1", {"B6_REC"})
	oTable:Create()
		
endIf

return


/**
* Atualiza os saldos
*/
static function atualizSaldoTemp(oSql, nSaldo, nTotConsumid)

local aArea 			:= getArea()
local lRepetGetSaldo	:= .T.
local nRecnoB6			:= oSql:getValue("B6_RECNO")
//Emerson HOlanda 23/03/18 - faturamento simultaneo
dbSelectArea("SB6")
SB6->(dbSetOrder(1))

/* Inibido Emerson Holanda - 25/04/18
If dDatabase <> SB6->B6_XDTUMOV
	SB6->( RecLock("SB6",.F.) )
	SB6->B6_XQTDMOV := ( 0 + nTotConsumid )
	SB6->B6_XDTUMOV := dDatabase
	SB6->( MsUnlock() )
Else
	SB6->( RecLock("SB6",.F.) )
	SB6->B6_XQTDMOV := ( SB6->B6_XQTDMOV + nTotConsumid )
	SB6->( MsUnlock() )
EndIf
*/

//Emerson Holanda - 25/04/18 - Grava o saldo no campo customizado.
while lRepetGetSaldo
	
	//AO POSICIONAR, OBTÉM O SALDO ATUALIZADO
	SB6->(dbGoTo(nRecnoB6))
	
	if SB6->(recLock("SB6", .F., .T., .T. , .T.))
		SB6->B6_XDTUMOV := dDatabase
		SB6->B6_XQTDMOV := nSaldo
		SB6->(DBCommit())
		SB6->( MsUnlock() )	
		lRepetGetSaldo := .F.
	else
		conout("TENTANDO LOCKAR NA TABELA SB6 FUNCAO [atualizSaldoTemp] FONTE [Ag2AltCli]")
	endIf
	
endDo
	
TRB->(dbSetOrder(1))

if TRB->(dbSeek(nRecnoB6))
	
	TRB->(Reclock("TRB", .F.))
	TRB->B6_SALDO 	:= nSaldo
	TRB->ZZ_TOTCONS	+= nTotConsumid
	TRB->(msUnlock())
	
else
	
	TRB->(Reclock("TRB", .T.))
	TRB->B6_REC 	:= oSql:getValue("B6_RECNO")
	TRB->D1_DOC	 	:= oSql:getValue("D1_DOC")
	TRB->D1_SERIE 	:= oSql:getValue("D1_SERIE")
	TRB->D1_ITEM 	:= oSql:getValue("D1_ITEM")
	TRB->D1_VUNIT 	:= oSql:getValue("D1_VUNIT")
	TRB->D1_LOCAL 	:= oSql:getValue("D1_LOCAL")
	TRB->B6_FILIAL 	:= oSql:getValue("B6_FILIAL")
	TRB->B6_PRODUTO := oSql:getValue("B6_PRODUTO")
	TRB->B6_QUANT 	:= oSql:getValue("B6_QUANT")
	TRB->B6_CLIFOR 	:= oSql:getValue("B6_CLIFOR")
	TRB->B6_LOJA 	:= oSql:getValue("B6_LOJA")
	TRB->B6_PODER3 	:= oSql:getValue("B6_PODER3")
	TRB->B6_TPCF	:= oSql:getValue("B6_TPCF")
	TRB->B6_TIPO	:= oSql:getValue("B6_TIPO")
	TRB->B6_IDENT	:= oSql:getValue("B6_IDENT")
	TRB->B6_PRUNIT	:= oSql:getValue("B6_PRUNIT")
	TRB->B6_SALDO	:= nSaldo
	TRB->F4_TESDV	:= oSql:getValue("F4_TESDV")
	TRB->F4_ZZTESFE	:= oSql:getValue("F4_ZZTESFE")
	TRB->F4_ZZTESDE	:= oSql:getValue("F4_ZZTESDE")
	TRB->D1_DTDIGIT	:= sTod(oSql:getValue("D1_DTDIGIT"))
	TRB->D1_TOTAL	:= oSql:getValue("D1_TOTAL")
	TRB->ZZ_TOTCONS	+= nTotConsumid
	TRB->(msUnlock())
	
endIf

restArea(aArea)

if TRB->(dbSeek(nRecnoB6))
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** TRB posicionado - L:632 **********", 0, 0, {})
endIf

return


/**
* Obtém o saldo
*/
static function getSaldo(oSql)

local aArea 	:= getArea()
local aAreaTRB	:= TRB->(getArea())
local nRecnoSB6	:= oSql:getValue("B6_RECNO")
local nSaldo	:= 0

TRB->(dbSetOrder(1))

if TRB->(dbSeek(oSql:getValue("B6_RECNO")))
	
	nSaldo 		:= oSql:getValue("B6_SALDO") - TRB->ZZ_TOTCONS
	
else
	
	nSaldo := oSql:getValue("B6_SALDO")
	
endIf

restArea(aArea)
restArea(aAreaTRB)

return nSaldo


/**
* Obtém o valor de cada campo passado referente a area de trabalho
*/
static function getValueTRB(cField)

local xValue := nil

xValue := TRB->&cField

return xValue


/*
** Verifica se o tipo do pedido é de retorno efetivo
*/
Static Function isRetEfetivo()
Local lRet := .f.

If SC5->C5_ZZTPPV == RETORNO_EFETIVO
	lRet := .t.
EndIf

Return (lRet)

/*
Emerson Holanda - 23/03/18
Retorna Saldo analisando campo customizado para saldos utilizados simultaneamente
*/
static function getSldMov(oSql)

local aArea 	:= getArea()
local nRecnoSB6	:= oSql:getValue("B6_RECNO")
local nSaldo	:= 0

dbSelectArea("SB6")
dbGoTo( nRecnoSB6 )

//nSaldo := SB6->B6_SALDO - (SB6->B6_QULIB + SB6->B6_XQTDMOV)  //Inibido 25/04/18 Emerson Holanda

If dDatabase <> SB6->B6_XDTUMOV
	nSaldo := SB6->B6_SALDO - SB6->B6_QULIB
Else
	nSaldo := SB6->B6_XQTDMOV
EndIf

restArea(aArea)


return nSaldo
