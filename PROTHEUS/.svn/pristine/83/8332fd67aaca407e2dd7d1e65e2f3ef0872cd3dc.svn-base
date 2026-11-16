#include "protheus.ch"
#include "dhl.ch"

#define OPC_ALTERACAO	4
#define OPC_INCLUSAO 	3
#define POS_CLIENTE 1
#define POS_LOJA 2
#define POS_TIPO 3

#define TRANSP	1
#define REDESP	2
#define VOLUME1	3
#define ESPECI1	4

#define POS_NF_REF		10
#define POS_SERIE_REF	11

#define RESIDUO		"R"	

/*/{Protheus.doc} Ag2AltRet

Altera o pedido de venda para processo de Retorno Efetivo

@author Thiago Meschiatti
@since 10/10/2017

/*/
User Function Ag2AltRet(aTransp)
	
	local lRet			:= .t.
	local lEnd			:= .f.
	local oDHLLibrary  	:= DHLLibrary():newDHLLibrary()
	
	private cMsg			:= ""
	private cArq			:= ""
	private cPvPai		:= SC5->C5_NUM
	private aCodLoja		:= {}
	private lTemPoder3	:= .T.
	private oLog			:= DHLLogManager():newDHLLogManager()
	
	private oTempTable	:= nil
	
	default aTransp		:= {}
	
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "********** INICIO FONTE Ag2AltCli.PRW " + time() + " USUARIO " + PswRet()[1][2]  + " **********", 0, 0, {})
	
	aCodLoja := oDHLLibrary:showChangeCliFor()
	
	Begin Transaction
	
	if !(Empty(aCodLoja))
			Processa( {|lEnd| lRet := AltPed(aTransp, @lEnd)} , "Aguarde...", "Processando...",.T.)
			If lRet
				Aviso("Atenção","Os pedidos de venda abaixo foram gerados: "  + CRLF + cMsg,{"OK"},3)
			Else
				Aviso("Atenção", cMsg,{"OK"},3)
				DisarmTransaction()
			EndIf
	endif
	
	If !empty(cArq)
		eraseFileTemp()
	EndIf
	
	End Transaction
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** FIM FONTE Ag2AltCli.PRW " + time() + " USUARIO " + PswRet()[1][2]  + " **********", 0, 0, {})
		
return (lRet)


/**
* Altera o pedido via rotina automática
*/
static function AltPed(aTransp, lEnd)
	
	local lRet		:= .t.
	local cNfAtu		:= ""
	local cSeriAtu	:= ""
	local nI			:= 0
	local aCab   		:= {}
	local aItens 		:= {}
	local aItensAux 	:= {}
	local aCabOrig 	:= {}
	local aItensOrig 	:= {}
	
	ProcRegua(4)
	
	IncProc("Localizando referências para o(s) Pedido(s) de Venda ... ")
	
	if !getDadosPedVenda(@aCab,@aItens,aTransp,aCabOrig,aItensOrig,lEnd)
		lRet := .f.
		return (lRet)
	endIf
	
	if !(lTemPoder3)
		cMsg += "Não há saldo em poder de terceiros para os itens do pedido de venda ! Verifique."
		lRet := .f.
		return (lRet)
	endif
	
	aItens := ordenaRefs(aItens)
	
	cNfAtu	:=	aItens[1,POS_NF_REF,2]
	cSeriAtu	:=	aItens[1,POS_SERIE_REF,2]
	aadd(aItensAux, aItens[1])
	
	IncProc("Processando geração do(s) Pedido(s) de Venda... ")
	
	For nI := 2 to len(aItens)
		If (AllTrim(cNfAtu + cSeriAtu) == AllTrim(aItens[nI,POS_NF_REF,2] + aItens[nI,POS_SERIE_REF,2]))
			aadd(aItensAux, aItens[nI])
		Else
		
			If execAuto(@aCab, @aItensAux, OPC_INCLUSAO)
				exit
			EndIf

			cNfAtu		:= 	aItens[nI,POS_NF_REF,2]
			cSeriAtu		:=	aItens[nI,POS_SERIE_REF,2]
			aItensAux	:= {}
			aadd(aItensAux, aItens[nI])
		EndIf
		
		If lEnd
			cMsg := "Processamento abortado!"
			lRet := .f.
			return (lRet)
		EndIf
	Next nI
	
	IncProc("Processando geração do(s) Pedido(s) de Venda... ")
	
	If Len(aItensAux) > 0 
		If execAuto(@aCab, @aItensAux, OPC_INCLUSAO)
			lRet := .f.
		Else
			lRet := fZeraSaldo(aCabOrig, aItensOrig)
		EndIf
	EndIf
	
return (lRet)


/*
** Executa rotina automática
*/
Static Function execAuto(aCab, aItensAux, nOpc)
	Local oUtils	:= IpUtilsObject():newIpUtilsObject()
	
	If nOpc == OPC_INCLUSAO
		refazItens(@aCab, @aItensAux)
	EndIf
			
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| MATA410(x,y,z)},aCab,aItensAux,nOpc)
		
	if lMsErroAuto
		cMsg += oUtils:getErroAuto()
	else
		If nOpc == OPC_INCLUSAO
			cMsg += SC5->C5_NUM + CRLF
		EndIf
	endif
Return (lMsErroAuto)


/**
* Obtem as arrays da rotina automática de pedido de venda
*/
static function getDadosPedVenda(aCab,aItens,aTransp,aCabOrig,aItensOrig,lEnd)
	
	local cItem     := StrZero(0,TamSx3("C6_ITEM")[1])
	local aAux      := {}
	local aSC6      := SC6->(GetArea())
	local cQuery    := ""
	local oSql      := IpSqlObject():newIpSqlObject()
	local oLogImp   := DHLLogManager():newDHLLogManager()
	local nSld      := 0
	local cTipo     := ""
	local nSaldo    := 0
	local nVlrParcial, nVlrUnit, nSldTotal := 0
	local lRet		:= .t.
	local lRef		:= .t.
	local nPos		:= 0
	
	if aCodLoja[POS_TIPO] == "cliente"
		cTipo := "N"
	else
		cTipo := "B"
	endif
	
	aAdd(aCab,{"C5_FILIAL" , SC5->C5_FILIAL			,nil})
	aAdd(aCab,{"C5_TIPO"   , cTipo					,nil})
	aAdd(aCab,{"C5_CLIENTE", aCodLoja[POS_CLIENTE]	,nil})
	aAdd(aCab,{"C5_LOJACLI", aCodLoja[POS_LOJA]		,nil})
	aAdd(aCab,{"C5_CONDPAG", SC5->C5_CONDPAG		,nil})
	aAdd(aCab,{"C5_ZZSTATU", ""					,nil})
	aAdd(aCab,{"C5_ZZTPPV" , RETORNO_EFETIVO		,nil})
	aAdd(aCab,{"C5_ZZSHIP" , SC5->C5_ZZSHIP          ,nil})
	aAdd(aCab,{"C5_ZZTIPO" , SC5->C5_ZZTIPO   		,nil})
	aAdd(aCab,{"C5_ZZORDEX", SC5->C5_ZZORDEX		,nil})	
	If Len(aTransp) > 0
		aAdd(aCab,{"C5_TRANSP", aTransp[TRANSP]						,nil})
		aAdd(aCab,{"C5_REDESP", aTransp[REDESP]						,nil})
		aAdd(aCab,{"C5_VOLUME1",aTransp[VOLUME1]					,nil})
		aAdd(aCab,{"C5_ESPECI1",aTransp[ESPECI1]					,nil})
	Endif
	
	aCabOrig := aClone(aCab)
	aAdd(aCabOrig,{"C5_NUM" , SC5->C5_NUM			,nil})
	
	aAdd(aCab,{"C5_ZZPVPAI", cPvPai					,nil})
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
	
	while SC6->C6_NUM == SC5->C5_NUM
		
		aAux := {}
		
		aAdd(aAux,{"C6_ITEM"   ,SC6->C6_ITEM				,nil})
		aAdd(aAux,{"C6_PRODUTO",SC6->C6_PRODUTO				,nil})
		aAdd(aAux,{"C6_QTDVEN" ,SC6->C6_QTDVEN    			,nil})
		aAdd(aAux,{"C6_PRCVEN" ,SC6->C6_PRCVEN  			,nil})
		aAdd(aAux,{"C6_VALOR"  ,SC6->C6_VALOR				,nil})
		aAdd(aAux,{"C6_QTDLIB" ,SC6->C6_QTDLIB				,nil})
		aAdd(aAux,{"C6_PRUNIT" ,SC6->C6_PRUNIT  			,nil})
		aAdd(aAux,{"C6_TES"    ,SC6->C6_TES					,nil})
		aAdd(aAux,{"C6_BLQ"    ,RESIDUO						,nil})
		
		aAdd(aItensOrig, aAux)
		
		nSld := SC6->C6_QTDVEN
		
		cQuery	:= getQueryItens()
		
		oSql:newAlias(cQuery)
		if oSql:hasRecords()
			
			criaAreaTrab(cQuery)
			
			while oSql:notIsEof()			
				
				lTemPoder3 := .T.
				
				aAux := {}
				
				nVlrParcial:= 0
				nVlrUnit   := 0
				nSldTotal  := 0
				
				if nSld <= getSaldo(oSql)
					nSaldo 		:= nSld
					atualizSaldoTemp(oSql, getSaldo(oSql) - nSaldo, nSaldo)
				else
					nSaldo		:= getSaldo(oSql)
					atualizSaldoTemp(oSql, 0 ,nSaldo)
				endif
				
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
				
				if nSaldo * A410Arred(nVlrUnit , "C6_PRCVEN") < 0.01
					oLogImp:start("PV","PV","")
					oLogImp:warn("REGISTRO IGNORADO PEDIDO "+SC5->C5_NUM, "Valor total item "+getValueTRB("B6_PRODUTO")+" para NF "+getValueTRB("D1_DOC")+;
						"/"+getValueTRB("D1_SERIE")+" não atingiu valor minimo 0,01.")
					oSql:skip()
					loop
				endif
				
				cItem := Soma1(cItem)
				
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
				
				montaItens(@aAux)
				
				aAdd(aItens,aAux)
				
				nSld -=  iif(nSld <= getValueTRB("B6_SALDO"),nSld  , nSaldo)					
				
				if nSld == 0
					exit
				endif
				
				If lEnd
					cMsg := "Processamento abortado!"
					lRet := .f.
					exit
				EndIf
				
				oSql:skip()
				
			enddo
			if nSld > 0
				lTemPoder3 := .F.
				exit
			endif
		else
			lRet := .F.
			cMsg += "Não foi encontrado o documento de origem para referenciar no pedido de venda. Verifique se o cliente / fornecedor selecionado está correto ou se possui saldo suficiente para o produto " + alltrim(SC6->C6_PRODUTO) + " para completar a ação"
			exit
		endIf
		
		oSql:close()

		If lEnd
			cMsg := "Processamento abortado!"
			lRet := .f.
			exit
		EndIf

		SC6->(dbSkip())
		
	enddo
	
	RestArea(aSC6)
	
return lRet


/**
* Inclui conteúdo no array de alteração da rotina automática. Para contemplar todos os campos.
**/
static function montaItens(aAux)
	
	local nCount	:= 0
	local aCposSX3	:= FWSX3Util():GetAllFields("SC6",.f.)
	
	for nCount := 1 to len(aCposSX3)
	
		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U" .and. AllTrim(getSX3Cache(aCposSX3[nCount],"X3_CONTEXT")) # "V"
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
	cQuery += "       B6_CLIFOR,B6_LOJA,B6_PODER3,B6_TPCF,B6_TIPO,B6_IDENT,B6_PRUNIT,(B6_SALDO - B6_QULIB) B6_SALDO,F4_TESDV, F4_ZZTESFE, F4_ZZTESDE, D1_DTDIGIT "       + CRLF
	cQuery += "FROM " + RetSqlName("SB6") + " SB6,"                                                                                                 + CRLF
	cQuery +=           RetSqlName("SD1") + " SD1,"                                                                                                 + CRLF
	cQuery +=           RetSqlName("SF4") + " SF4 "                                                                                                 + CRLF
	cQuery += "WHERE B6_FILIAL = '" + xFilial("SB6") + "' AND "                                                                                     + CRLF
	cQuery += "      B6_CLIFOR = '" + aCodLoja[POS_CLIENTE] + "' AND "                                                                              + CRLF
	cQuery += "      B6_LOJA   = '" + aCodLoja[POS_LOJA] + "' AND "                                                                                 + CRLF
	cQuery += "      B6_PODER3 = 'R' AND "                                                                                                          + CRLF
	cQuery += "      B6_TPCF   = '" + iif(aCodLoja[POS_TIPO] == "cliente","C","F") + "' AND "                                                       + CRLF
	cQuery += "      B6_TIPO   = 'D' AND "                                                                                                          + CRLF
	cQuery += "      (B6_SALDO - B6_QULIB) > 0 AND "                                                                                                + CRLF
	cQuery += " SB6.D_E_L_E_T_ = ' ' AND "                                                                                                          + CRLF
	cQuery += "      D1_NUMSEQ = B6_IDENT AND "                                                                                                     + CRLF
	cQuery += "      D1_FILIAL = '" + xFilial("SD1") + "' AND "                                                                                     + CRLF
	cQuery += "      D1_COD    = '" + SC6->C6_PRODUTO + "' AND "                                                                                    + CRLF
	cQuery += " SD1.D_E_L_E_T_ = ' ' AND "                                                                                                          + CRLF
	cQuery += "      F4_FILIAL = '" + xFilial("SF4") + "' AND "                                                                                     + CRLF
	cQuery += "      F4_CODIGO = B6_TES AND "                                                                                                       + CRLF
	cQuery += " SF4.D_E_L_E_T_ = ' ' "                                                                                                              + CRLF
	cQuery += " ORDER BY D1_DTDIGIT, D1_EMISSAO "                                                                                                   + CRLF
	
return cQuery


/**
* Coleta a Tes a ser utilizada
**/
static function getTes(oSql)
	
	local cTes := ""
	
	If SC5->C5_ZZTPPV == RETORNO_SIMBOLICO
		cTes := getValueTRB("F4_TESDV")
	Else
		cTes := getValueTRB("F4_ZZTESDE")
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
		
		If oTempTable <> Nil
			oTempTable:Delete()
			oTempTable := Nil
		Endif
		
		oTempTable := FWTemporaryTable():New("TRB", aStru)
		oTempTable:AddIndex("1", {"B6_REC"} )
		oTempTable:Create()
		
	endIf
	
return


/**
* Atualiza os saldos
*/
static function atualizSaldoTemp(oSql, nSaldo, nTotConsumid)
	
	local aArea 	:= getArea()
	
	TRB->(dbSetOrder(1))
	
	if TRB->(dbSeek(oSql:getValue("B6_RECNO")))		
		
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
	
	if TRB->(dbSeek(oSql:getValue("B6_RECNO")))
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "********** TRB posicionado - L:523 **********", 0, 0, {})
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
** Ordena array pelas referencias do documento original
*/
Static Function ordenaRefs(aItens)
	Local aItensAux	:= {}
	
	aItensAux := aSort(aItens,,, {|x,y| x[POS_NF_REF][2] + x[POS_SERIE_REF][2] < Y[POS_NF_REF][2] + Y[POS_SERIE_REF][2]})
	
Return aClone(aItensAux)


/*
** Refaz sequencial dos itens
*/
Static Function refazItens(aCab, aItens)
	Local cItem 	:= StrZero(0,TamSx3("C6_ITEM")[1])
	Local nI 	:= 0
	Local nPosIt	:= 0
	
	For nI := 1 To Len(aItens)
		nPosIt  := aScan(aItens[nI], {|x| x[1] == "C6_ITEM" })
		If nPosIt > 0
			cItem 	:= Soma1(cItem)
			
			aItens[nI, nPosIt, 2] := cItem
		EndIf
	Next nI
Return


/*
** Elimina resíduo do pedido pai
*/
Static Function fZeraSaldo(aCabOrig, aItensOrig)
	Local lRet := .t.
	
	IncProc("Emilimando Saldo do Pedido Original... ")
	
	DbSelectArea("SC5")
	SC6->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5") + cPvPai))
		If execAuto(aCabOrig, aItensOrig, OPC_ALTERACAO)
			lRet := .f.
		EndIf
	EndIf
Return (lRet)


/*
** Apaga o arquivo temporario
*/
static function eraseFileTemp()
	
	TRB->(dbCloseArea())
	FErase(cArq + GetDbExtension())
	FErase( cArq + OrdBagExt())
	
return
