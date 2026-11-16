#Include 'Totvs.ch'
#Include 'Font.ch'
#Include 'Colors.ch'
#Include 'DHL.ch'
#include 'ap5mail.ch'

#define CONSUMIDO 		"CONSUMIDO"
#define NAO_CONSUMIDO 	"NAO_CONSUMIDO"

/*/{Protheus.doc} _AgeVNFTer - Rotina automática de vínculo das Nf´s de Comodato.

Processo para a Unidade de Negócio HP AGE.

@author 	Edson Deluca
@since 		06/08/2018
@version 	1.0
@type 		Function
/*/

// campo do pedido para fazer amarração: C5_ZZORDEX = Z8_DOC + Z8_SERIE

*********************************************************************************************************************************************************************
User Function _AgeVNFTer(cParam1,cParam2)
	*********************************************************************************************************************************************************************
	
	local cTipoEspecie := DHL_ESPECIE_INVENTARIO
	
	RpcSetEnv(cParam1,cParam2)
	//RpcSetEnv("10","L95AGE95LOTE")	
	
	private oLog          := DHLLogManager():newDHLLogManager()
	Private cUnidade	  := Alltrim(GetMv("ZZ_CNPJAG"))
	Private cTipoNFTer    := Alltrim(GetMv("ZZ_TPNFTER"))
	private lNewAge       := SuperGetMV("ZZ_NEWAGE",,.F.)
	private lAutomatic    := SuperGetMV("ZZ_AUTOMAT",,.F.)
	private _cTesDev      := SuperGetMV("ZZ_TESDEV",,"5I1")
	Private _cFunName     := ""
	Private _cMsg         := ""
	Private _cDoc1        := ""
	Private _cDoc2        := ""
	Private _cDoc3        := ""
	Private _cCodMsg      := ""
	
	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Iniciando Rotina de Vinculo de Terceiros", 0, 0, {})
    
    CONOUT("[ALERT: ] INICIANDO A ROTINA DE VINCULACAO DE TERCEIRO")
    
	If lNewAge .And. lAutomatic
		
		If !LockbyName("_AgeVNFTer",.T.,.T.) 
			 CONOUT("[ALERT: ] LOCKADO")
			RpcClearEnv()
			Return
		EndIf
		
		If Select("_C5") <> 0
			_C5->(dbCloseArea())
		Endif
		
		BeginSql Alias "_C5"
			SELECT SC5.C5_FILIAL, SC5.C5_NOTA, SC5.C5_NUM, SC5.C5_LIBEROK, SC5.C5_BLQ, SC5.R_E_C_N_O_ AS RECSC5
			FROM %Table:SC5% SC5
			INNER JOIN %Table:SC6% SC6 ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC6.%NotDel%
			WHERE
			SC5.C5_FILIAL = %xFilial:SC5% AND
			SC5.C5_ZZESPEC != %Exp:cTipoEspecie% AND
			SC6.C6_NFORI = " " AND
			//SC5.C5_NUM = "010504" AND
			SC5.%NotDel%
		EndSql	
		
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Fazendo Query da Rotina de Vinculo de Terceiros", 0, 0, {})
		
		dbSelectArea("_C5")
		_C5->(dbGoTop())
		
		While !Eof()
			
			CONOUT("[ALERT: ] POSSUI PEDIDO")
			
			//--- Pedido Encerrado: Vermelho
			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Existe Pedidos a vincular da Rotina de Vinculo de Terceiros", 0, 0, {})
		
			
			If !Empty(_C5->C5_NOTA) .or. _C5->C5_LIBEROK == 'E' .and. Empty(_C5->C5_BLQ)
				
				_cFunName := "_AgeVNFTer"
				_cMsg     := "Interface não pode ser processada. Pedido Encerrado, Não é possível fazer vinculo com pedido já encerrado."
				_cDoc1    := _C5->C5_NUM
				_cDoc2    := ""
				_cDoc3    := ""
				_cCodMsg  := "01"
				
				If lNewAge .And. lAutomatic
					If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
						setFileLog(" ","fail",_cMsg)
					EndIf
				Else
					setFileLog(" ","fail",_cMsg)
				EndIf
				
				FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "Pedido Encerrado, Não é possível fazer vinculo com pedido já encerrado. Verifique!", 0, 0, {})
		
				dbSelectArea("_C5")
				dbSkip()
				Loop
			Endif
			
			//--- Pedido Bloqueado: Azul
			If !Empty(_C5->C5_BLQ)
				
				_cFunName := "_AgeVNFTer"
				_cMsg     := "Interface não pode ser processada. Pedido Bloqueado, Não é possível fazer vinculo com pedido bloqueado."
				_cDoc1    := _C5->C5_NUM
				_cDoc2    := ""
				_cDoc3    := ""
				_cCodMsg  := "02"
				If lNewAge .And. lAutomatic
					If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
						setFileLog(" ","fail",_cMsg)
					EndIf
				Else
					setFileLog(" ","fail",_cMsg)
				EndIf
				
				FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "Pedido Bloqueado, Não é possível fazer vinculo com pedido bloqueado. Verifique!", 0, 0, {})
		
				dbSelectArea("_C5")
				dbSkip()
				Loop
			Endif
			
			If Select("QRY") <> 0
				QRY->(dbCloseArea())
			Endif
			
			BeginSql Alias "QRY"
				SELECT SZ8.Z8_DOC, SZ8.Z8_SERIE, SZ8.Z8_CLIENTE, SZ8.Z8_LOJA, SZ8.Z8_PEDIDO
				FROM %Table:SZ8% SZ8
				WHERE
				SZ8.Z8_FILIAL = %xFilial:SZ8% AND
				SZ8.Z8_PEDIDO = %Exp:_C5->C5_NUM% AND
				SZ8.%NotDel%
			EndSql
			
			QRY->(dbGoTop())
			If QRY->(!Eof())
				
				_cFunName := "_AgeVNFTer"
				_cMsg     := "Interface não pode ser processada. Pedido com vínculo, Este pedido está vinculado com a nota fiscal no. "+QRY->Z8_DOC+"/"+QRY->Z8_SERIE
				_cDoc1    := _C5->C5_NUM
				_cDoc2    := QRY->Z8_SERIE
				_cDoc3    := QRY->Z8_DOC
				_cCodMsg  := "03"
				
				If lNewAge .And. lAutomatic
					If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
						setFileLog(" ","fail",_cMsg)
					EndIf
				Else
					setFileLog(" ","fail",_cMsg)
				EndIf
				
				FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "Pedido com vínculo, Este pedido está vinculado com a nota fiscal no. "+QRY->Z8_DOC+"/"+QRY->Z8_SERIE+". Verifique!", 0, 0, {})
				
				QRY->(dbCloseArea())
				dbSelectArea("_C5")
				dbSkip()
				Loop
			Endif
			
			If Select("QRY") <> 0
				QRY->(dbCloseArea())
			Endif
			
			dbSelectArea("SC5")
			dbGoTo(_C5->RECSC5)
			
			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Entrando na Rotina de Vinculo do pedido: "+_C5->C5_NUM, 0, 0, {})
			
			BEGIN TRANSACTION
				
				CONOUT("[ALERT: ] INICIANDO O VINCULO")
				
				fVincula()
				
				CONOUT("[ALERT: ] FIM DO VINCULO")
				
			END TRANSACTION
			
			dbSelectArea("_C5")
			dbSkip()
			
		End
		
		UnLockbyName("_AgeVNFTer",.T.,.T.)
		
	EndIf
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Finalizando Rotina de Vinculo de Terceiros", 0, 0, {})
	
	RpcClearEnv()
	
	 CONOUT("[ALERT: ] FIM ROTINA DE VINCULACAO DE TERCEIRO")
	
Return Nil

*********************************************************************************************************************************************************************
Static Function fQuery()
	*********************************************************************************************************************************************************************
	Local cTipoNFTer := ""
	
	cTipoNFTer := Alltrim(GetMv("ZZ_TPNFTER"))
	
	If Select("QRY") <> 0
		QRY->(dbCloseArea())
	Endif
	
	BeginSql Alias "QRY"
		COLUMN Z8_EMISSAO AS DATE
		SELECT SZ8.Z8_DOC, SZ8.Z8_SERIE, SZ8.Z8_CLIENTE, SZ8.Z8_LOJA, SZ8.Z8_EMISSAO, SZ8.Z8_VALMERC, SA1.A1_NOME
		FROM %Table:SZ8% SZ8
		INNER JOIN %Table:SA1% SA1 ON
		SA1.A1_FILIAL = %xFilial:SA1% AND
		SA1.A1_COD = SZ8.Z8_CLIENTE AND
		SA1.A1_LOJA = SZ8.Z8_LOJA AND
		SA1.%NotDel%
		WHERE
		SZ8.Z8_FILIAL = %xFilial:SZ8% AND
		SZ8.Z8_CLIEMIT = %Exp:SC5->C5_CLIENTE% AND
		SZ8.Z8_LOJEMIT = %Exp:SC5->C5_LOJACLI% AND
		SZ8.Z8_TPNF = %Exp:cTipoNFTer% AND
		SZ8.Z8_PEDIDO = %Exp:" "% AND
		SZ8.Z8_NFRET = %Exp:" "% AND
		SZ8.Z8_SERRET = %Exp:" "% AND
		SZ8.%NotDel%
		ORDER BY SZ8.Z8_EMISSAO, SZ8.Z8_DOC, SZ8.Z8_SERIE
	EndSql
	
Return Nil


*********************************************************************************************************************************************************************
Static Function fVincula()
	*********************************************************************************************************************************************************************
	Local cNota		:= ""
	Local cSerie	:= ""
	Local cCliente	:= ""
	Local cLoja		:= ""
	Local oLibFat 	:= Nil
	local nTentat	:= 0
	Local lAvisa	:= .f.
	
	///----------->dados anteriores para retornar
	local __Z8_PEDIDO	:= ""
	local __C5_ZZNFTER	:= ""
	local __C5_ZZSETER	:= ""
	local __C5_ZZCLTER	:= ""
	local __C5_ZZLJTER	:= ""
	local lOK           := .F.
	LOCAL NREC_C5		:= 0
	LOCAL NREC_Z8		:= 0
	
	cNota	:= getNotaOrdex(SC5->C5_ZZORDEX) 
	cSerie	:= Substr(SC5->C5_ZZORDEX,RAT("-", allTrim(SC5->C5_ZZORDEX)) + 1,2)+Space(1)
	cCliente:= SC5->C5_CLIENTE
	cLoja	:= SC5->C5_LOJACLI
	
	dbSelectArea("SZ8")
	dbSetOrder(1)
	If !(dbSeek(xFilial("SZ8")+cNota+cSerie,.F.))
		FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "Não Existe NF de Terceiro para este pedido: "+cNota+" / "+cSerie, 0, 0, {})
		Return
	Endif
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Fazendo Vinculo de Terceiros da NF: "+cNota+" / "+cSerie+" / "+cCliente+" / "+cLoja, 0, 0, {})
	
	If Empty(cNota)
		FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "Sem Seleção de Nota","Nenhuma nota fiscal foi selecionada. Verifique!", 0, 0, {})
		Return .F.
	Endif
	
	
		
		lOK := BuscaLote(SC5->C5_NUM)
		
		CONOUT("[ALERT: ] BUSCA LOTE " + cValToChar(lOK))
		
 
	if lOK
		
		//--- 1o. Valida Itens da NF Comodato vs Pedido de Venda:
		If fNFxPed(cNota, cSerie, cCliente, cLoja)
			
			CONOUT("[ALERT: ] PASSOU NO VINCULO PEDIDO X TERCEIRO")
			
			FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Passou na Comparação do Vinculo de Terceiros da NF: "+cNota+" / "+cSerie+" / "+cCliente+" / "+cLoja, 0, 0, {})
			
			SZ8->(dbSetOrder(1))
			If SZ8->(dbSeek( xFilial("SZ8") + cNota + cSerie ))
				
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Entrando na amarração da Tabela SZ8 do Vinculo de Terceiros da NF: "+cNota+" / "+cSerie+" / "+cCliente+" / "+cLoja, 0, 0, {})
			
				//--- 2o. Amarra Pedido com a Nota:
				NREC_Z8 := SZ8->(RECNO()) 
				RecLock("SZ8",.F.)
				__Z8_PEDIDO    := SZ8->Z8_PEDIDO
				SZ8->Z8_PEDIDO := SC5->C5_NUM
				SZ8->(MsUnLock())
				
				NREC_C5 := SC5->(RECNO())
				RecLock("SC5",.F.)
				__C5_ZZNFTER	:= SC5->C5_ZZNFTER
				__C5_ZZSETER	:= SC5->C5_ZZSETER
				__C5_ZZCLTER	:= SC5->C5_ZZCLTER
				__C5_ZZLJTER	:= SC5->C5_ZZLJTER
				
				
				SC5->C5_ZZNFTER := SZ8->Z8_DOC
				SC5->C5_ZZSETER := SZ8->Z8_SERIE
				SC5->C5_ZZCLTER := SZ8->Z8_CLIENTE
				SC5->C5_ZZLJTER := SZ8->Z8_LOJA
				SC5->C5_MENNOTA := BuscaSZZ(SC5->C5_NUM)
				SC5->(MsUnLock())
				
				//--- 3o. Liberacao do Pedido de Venda:
				oLibFat:= DhlDisControl():newDhlDisControl()
				oLibFat:libSalesOrder()
				If !oLibFat:lError
					FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Pedido liberado para Faturar do Vinculo de Terceiros da NF: "+cNota+" / "+cSerie+" / "+cCliente+" / "+cLoja, 0, 0, {})
			
					//--- 4o. Gera Nota Fiscal Saida - Fatura o Pedido:
					oLibFat:incOutFlowInv(SC5->C5_NUM)
					If !oLibFat:lError
						RecLock("SZ8",.F.)
						SZ8->Z8_NFRET  := SF2->F2_DOC
						SZ8->Z8_SERRET := SF2->F2_SERIE
						SZ8->Z8_CLIRET := SF2->F2_CLIENTE
						SZ8->Z8_LOJRET := SF2->F2_LOJA
						SZ8->(MsUnLock())
						FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Pedido Faturado do Vinculo de Terceiros da NF: "+cNota+" / "+cSerie+" / "+cCliente+" / "+cLoja, 0, 0, {})
						lavisa := .t.
					Else
						_cFunName := "_AgeVNFTer"
						_cMsg     := "Interface não pode ser processada. Faturamento do Liberação de Pedido com Erro. Pedido: "+SC5->C5_NUM
						_cDoc1    := SC5->C5_NUM
						_cDoc2    := ""
						_cDoc3    := ""
						_cCodMsg  := "04"
						
						If lNewAge .And. lAutomatic
							If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
								setFileLog(" ","fail",_cMsg)
							EndIf
						Else
							setFileLog(" ","fail",_cMsg)
						EndIf
						
						FWLogMsg("ERROR", "LAST", "BusinessObject", funName(), "", "01", "Faturamento do Liberação de Pedido com Erro.", 0, 0, {})
					Endif
				ELSE
					
					_cFunName := "_AgeVNFTer"
					_cMsg     := "Interface não pode ser processada. Liberação de Pedido com Erro. Pedido: "+SC5->C5_NUM
					_cDoc1    := SC5->C5_NUM
					_cDoc2    := ""
					_cDoc3    := ""
					_cCodMsg  := "05"
					
					If lNewAge .And. lAutomatic
						If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
							setFileLog(" ","fail",_cMsg)
						EndIf
					Else
						setFileLog(" ","fail",_cMsg)
					EndIf
					
					FWLogMsg("ERROR", "LAST", "BusinessObject", funName(), "", "01", "Liberação de Pedido com Erro.", 0, 0, {})
					
					SZ8->(DBGOTO( NREC_Z8 ))
					RecLock("SZ8",.F.)
					SZ8->Z8_PEDIDO := __Z8_PEDIDO
					SZ8->(MsUnLock())
					
					SC5->(DBGOTO( NREC_C5 ))
					RecLock("SC5",.F.)
					SC5->C5_ZZNFTER := __C5_ZZNFTER
					SC5->C5_ZZSETER := __C5_ZZSETER
					SC5->C5_ZZCLTER := __C5_ZZCLTER
					SC5->C5_ZZLJTER := __C5_ZZLJTER
					SC5->(MsUnLock())
					
				Endif
				//				oTela:End()
			Else
				//UnLockByName("AGEVINCNFTER", .T. , .T. )
				_cFunName := "_AgeVNFTer"
				_cMsg     := "Interface não pode ser processada. Nota '"+cNota +"/"+ cSerie+"' não encontrada depois do faturamento."
				_cDoc1    := cNota
				_cDoc2    := cSerie
				_cDoc3    := ""
				_cCodMsg  := "06"
				
				If lNewAge .And. lAutomatic
					If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
						setFileLog(" ","fail",_cMsg)
					EndIf
				Else
					setFileLog(" ","fail",_cMsg)
				EndIf
				
				FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "Nota '"+cNota +"/"+ cSerie+"' não encontrada.", 0, 0, {})
				
				Return .F.
			Endif
			
			if lAvisa
				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "N O T A   F I S C A L   G E R A D A, Foi gerada a nota fiscal no. "+Alltrim(SF2->F2_DOC)+"/"+Alltrim(SF2->F2_SERIE)+".", 0, 0, {})
			endif
			
		Endif
		
	endIf
	
Return Nil

*********************************************************************************************************************************************************************
Static Function fNFxPed(cNota, cSerie, cCliente, cLoja)
	*********************************************************************************************************************************************************************
	Local oDiverge, oBrowse, oBotao
	Local nOpc 		:= GD_UPDATE
	Local cMensagem	:= ""
	Local nI			:= 0
	Local nJ			:= 0
	Local aConfere 	:= {}
	Local aHoBrowse	:= {}
	Local aCoBrowse	:= {}
	Local lErroSaldo := .f.
	Local lErroLote	:= .f.
	local _nZ       := 0
	//Local aLote		:= {}
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Fazendo Comparação do Vinculo de Terceiros da NF: "+cNota+" / "+cSerie+" / "+cCliente+" / "+cLoja, 0, 0, {})
			
	SZ9->(dbSetOrder(1))
	SZ9->(dbSeek( xFilial("SZ9") + cNota + cSerie ))
	
	While SZ9->(!Eof()) .and. SZ9->Z9_FILIAL == xFilial("SZ9") .and. SZ9->Z9_DOC == cNota .and. SZ9->Z9_SERIE == cSerie
		
		If lNewAge .And. lAutomatic
			
			_cProduto := AllTrim(SZ9->Z9_COD)
			For _nZ := Len(_cProduto) to 1 Step -1
				If Substr(_cProduto,_nZ,1)==" "
					Exit
				EndIF
			Next _nZ
			
			_cProduto := Substr(_cProduto,1,_nZ-1)
			
			If lAutomatic .And. fRastro(SZ9->Z9_COD)
				nJ := Ascan(aConfere,{|x| Alltrim(x[1]) + Alltrim(x[8]) == Alltrim(_cProduto) + Alltrim(SZ9->Z9_LOTE)})
			Else
				nJ := Ascan(aConfere,{|x| Alltrim(x[1]) == Alltrim(_cProduto)})
			EndIf
			If nJ > 0
				aConfere[nJ,02] += SZ9->Z9_QUANT
				aConfere[nJ,06] += SZ9->Z9_QUANT
			Else
				aAdd(aConfere, { _cProduto, SZ9->Z9_QUANT, " ", 0, .F., SZ9->Z9_QUANT, 0, SZ9->Z9_LOTE})
			EndIf
		Else
			aAdd(aConfere, { SZ9->Z9_COD, SZ9->Z9_QUANT, " ", 0, .F.})
		EndIf
		
		//aAdd(aLote, {SZ9->Z9_COD, SZ9->Z9_LOTE})
		
		SZ9->(dbSkip())
		
	Enddo
	
	SC6->(dbSetOrder(1))
	SC6->(dbSeek( xFilial("SC6") + SC5->C5_NUM ))
	While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == SC5->C5_NUM
		
		If lNewAge
			_cProduto := AllTrim(SC6->C6_PRODUTO)
			For _nZ := Len(_cProduto) to 1 Step -1
				If Substr(_cProduto,_nZ,1)==" "
					Exit
				EndIF
			Next _nZ
			
			_cProduto := Substr(_cProduto,1,_nZ-1)
			
			If lAutomatic .And. fRastro(SC6->C6_PRODUTO)
				nI := Ascan(aConfere,{|x| Alltrim(x[1]) + Alltrim(x[8]) == Alltrim(_cProduto) + Alltrim(SC6->C6_LOTECTL)})
			Else
				nI := Ascan(aConfere,{|x| Alltrim(x[1]) == Alltrim(_cProduto)})
			EndIf
			
			If nI > 0
				If aConfere[nI,06] >= SC6->C6_QTDVEN
					aConfere[nI,03] := _cProduto
					aConfere[nI,04] := SC6->C6_QTDVEN
					aConfere[nI,05] := .T.
					aConfere[nI,06] := aConfere[nI,06] -  SC6->C6_QTDVEN
					aConfere[nI,07] += SC6->C6_QTDVEN
					aConfere[nI,08] := SC6->C6_LOTECTL
				Else
					aAdd(aConfere, { " ", 0, _cProduto, SC6->C6_QTDVEN, .F. , SC6->C6_QTDVEN, " ", SC6->C6_LOTECTL})
				Endif
			Else
				aAdd(aConfere, { " ", 0, SC6->C6_PRODUTO, SC6->C6_QTDVEN, .F. , SC6->C6_QTDVEN, " ", SC6->C6_LOTECTL})
			Endif
		Else
			nI := Ascan(aConfere,{|x| Alltrim(x[1]) == Alltrim(SC6->C6_PRODUTO) .and. x[2] == SC6->C6_QTDVEN })
			If nI > 0
				aConfere[nI,03] := SC6->C6_PRODUTO
				aConfere[nI,04] := SC6->C6_QTDVEN
				aConfere[nI,05] := .T.
			Else
				aAdd(aConfere, { " ", 0, SC6->C6_PRODUTO, SC6->C6_QTDVEN, .F. })
			Endif
		EndIf
		
		//aAdd(aLote, {SC6->C6_PRODUTO, SC6->C6_LOTECTL})
		
		//		lErroLote := ValidLote(cNota, cSerie, cCliente, cLoja, SC6->C6_NUM)
		
		//		If !lErroLote
		//
		// 			_cFunName := "_AgeVNFTer"
		//        	_cMsg     := "Os lotes estão divergentes para a Nota '"+cNota +"/"+ cSerie+"' vinculada ao pedido '"+SC5->C5_NUM+"'"
		//        	_cDoc1    := cNota
		//        	_cDoc2    := cSerie
		//        	_cDoc3    := ""
		//        	_cCodMsg  := "10"
		//
		//        	If lNewAge .And. lAutomatic
		//           		If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
		//		      		setFileLog(" ","fail",_cMsg)
		//		   		EndIf
		//			Else
		//	       		setFileLog(" ","fail",_cMsg)
		//	    	EndIf
		//
		//	    	Return .F.
		//
		//		EndIf
		
		SC6->(dbSkip())
	Enddo
	
	cCab := "Produto Nota       Qtde.Nota Produto Pedido  Qtde.Pedido "
	
	If lNewAge
		For nI:=1 to Len(aConfere)
			If aConfere[nI,06] > 0
				lErroSaldo := .t.
				exit
			EndIf
		Next nI
		
		//Valida LotecNota, cSerie, cCliente, cLoja
		/*If lAutomatic
		For nI:=1 to Len(aLote)
			If AllTrim(aLote[nI,1]) = AllTrim(aLote[nI+1,1]) // Compara o SKU
				If AllTrim(aLote[1,nI+1]) != AllTrim(aLote[2,nI])
					lErroLote = .T.
					Exit
				EndIf
			EndIf
		Next
	EndIf		*/
EndIf

_cTexto:= ""

For nI:=1 to Len(aConfere)
	
	_cTexto := aConfere[nI,1]+Space(05)
	_cTexto += Str(aConfere[nI,2],12,3)+Space(05)
	_cTexto += aConfere[nI,3]+Space(05)
	_cTexto += Str(aConfere[nI,4],12,3)+Space(05)
	_cTexto += Str(aConfere[nI,6],12,3) + CRLF
	//       _cTexto += Str(aConfere[nI,7],12,3) + CRLF
	
Next nI

_lErrado := .F.

For nI:=1 to Len(aConfere)
	If lNewAge
		If lErroSaldo
			_lErrado := .T.
		Else
			If !aConfere[nI,05]
				_lErrado := .T.
			EndIf
		Endif
	Else
		If !aConfere[nI,05]
			_lErrado := .T.
		Endif
	EndIf
Next

If _lErrado
	
	dbSelectArea("SC5")
	If RecLock("SC5",.F.)
		SC5->C5_LIBEROK := " "
		MsUnLock("SC5")
	EndIf
	
	SC6->(dbSetOrder(1))
	SC6->(dbSeek( xFilial("SC6") + SC5->C5_NUM ))
	While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == SC5->C5_NUM
		If RecLock("SC6",.F.)
			SC6->C6_NFORI   := " "
			SC6->C6_SERIORI := " "
			SC6->C6_ITEMORI := " "
			SC6->C6_IDENTB6 := " "
			SC6->C6_TES     := "9I9"
			SC6->C6_QTDLIB  := 0
			MsUnLock("SC6")
		EndIf
		dbSkip()
	End
	
	_cFunName := "_AgeVNFTer"
	_cMsg     := "Comparação não passou do Vinculo de Terceiros da NF: "+cNota+" / "+cSerie+" . Verifique produto, quantidade e/ou lote."
	_cDoc1    := cNota
	_cDoc2    := cSerie
	_cDoc3    := ""
	_cCodMsg  := "10"
	
	disarmTransaction()
	
	If lNewAge .And. lAutomatic
		If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
			setFileLog(" ","fail",_cMsg)
		EndIf
	Else
		setFileLog(" ","fail",_cMsg)
	EndIf
	FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "Comparação não passou do Vinculo de Terceiros da NF: "+cNota+" / "+cSerie+" / "+cCliente+" / "+cLoja, 0, 0, {})
	//MailDHL(.T.,_cTexto)
Return .F.
Else
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Comparação Passou do Vinculo de Terceiros da NF: "+cNota+" / "+cSerie+" / "+cCliente+" / "+cLoja, 0, 0, {})
Return .T.
Endif


Return .T.

**************************************
Static Function MailDHL(_lJob,_cTexto)
	**************************************
	
	local nEmails
	
	Local _cServer   := SuperGetMv("MV_RELSERV")
	Local _cMail     := SuperGetMv("MV_RELACNT")
	Local _cUser     := SuperGetMv("MV_RELACNT")
	Local _cSenha    := SuperGetMv("MV_RELPSW")
	Local _lAuth     := SuperGetMv("MV_RELAUTH")
	Local _cFrom     := SuperGetMv("MV_RELFROM")
	Local _cTo        := SuperGetMv("ZZ_MAILTER",,"daniela.barbosa@dhl.com")
	Local _cAssunto   := "Erros de Vinculos" + " - " + Time()
	Local _cBody      := "Segue Lista de erros - Vínculos NF de Terceiro"+CRLF+_cTexto
	Local _lOk        := .T.
	Local _cArqAnexo    := ""
	
	CONNECT SMTP SERVER _cServer ACCOUNT _cUser PASSWORD _cSenha Result _lOk
	
	lEnviado := MailSend(_cFrom, {_cTo},{},{}, _cAssunto, _cBody, _cArqAnexo,.F.)
	
	If !lEnviado
		cError := MailGetErr()
		_cMensagem :="***[_AgeVincNFT]*** Falha na conexao: " + cError + " - " + _cArqlog
		
		If (_lJob)
			FWLogMsg("ERROR", "LAST", "BusinessObject", funName(), "", "01", _cMensagem, 0, 0, {})
		Else
			MsgInfo(_cMensagem,"Informação")
		EndIf
	Endif
	
	DISCONNECT SMTP SERVER result _lOk
	
return()

**********************************
Static Function BuscaSZZ(_cNumSC5)
	**********************************
	
	Local _cMsg   :=""
	Local _aArea  := GetArea()
	Local _cTexto := ""
	local _nI     := 0
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6")+_cNumSC5,.F.)
	
	While !Eof() .And. SC6->C6_NUM == _cNumSC5
		
		dbSelectArea("SZZ")
		dbSetOrder(1)
		If dbSeek(xFilial("SZZ") + "E" + SC6->C6_NFORI + SC6->C6_SERIORI + SC5->C5_CLIENTE + SC5->C5_LOJACLI ,.F.)
			While !Eof() .And. xFilial("SZZ")==SZZ->ZZ_FILIAL .And. SZZ->ZZ_DOC==SC6->C6_NFORI .AND. SZZ->ZZ_SERIE==SC6->C6_SERIORI .AND. SZZ->ZZ_CLIFOR==SC5->C5_CLIENTE .AND. SZZ->ZZ_LOJA==SC5->C5_LOJACLI
				
				_cTexto += AllTrim(SZZ->ZZ_TXTMENS)+" "
				
				dbSkip()
				
			End
			
		EndIf
		
		dbSelectArea("SC6")
		dbSkip()
		
	End
	
	For _nI:=1 to Len(_cTexto)
		
		If Substr(_cTexto,_nI,08)=="Fatura: "
			
			_cFatura  := Substr(_cTexto,_nI+08,10)
			_cMsg += "Fatura: "+_cFatura+" | "
			
		EndIf
		
		If Substr(_cTexto,_nI,09)=="Remessa: "
			
			_cRemessa  := Substr(_cTexto,_nI+09,10)
			_cMsg += "Remessa: "+_cRemessa+" | "
			
		EndIf
		
	Next _nI
	
	RestArea(_aArea)
Return _cMsg


**********************************
Static Function BuscaLote(_cNumSC5)
	**********************************
	
	local _cMsg   				:=""
	local _aArea  				:= GetArea()
	local _cTexto 				:= ""
	local _cQuery 				:= ""
	local aSaldoB6ByProdLote 	:= {}
	local nI					:= 0
	local nJ					:= 0
	local nPos					:= 0
	local nSaldoRestVend		:= 0
	local _nConv				:= 0
	local _cTipConv             := ""
	local aRecnoSC6             := {}
	local cFunName              := ""
	local cMsg                  := ""
	local cDoc1                 := ""
	local cDoc2                 := ""
	local cDoc3                 := ""
	local cCodMsg               := ""
	local lok					:= .T.
	
	eraseSC9(_cNumSC5)
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+_cNumSC5,.F.)
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6")+_cNumSC5,.F.)
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Entrou na Rotina de Busca Lote.", 0, 0, {})
	
	While SC6->(!Eof()) .And. SC6->C6_NUM == _cNumSC5 .And. SC6->C6_FILIAL = xFilial("SC6")
		aAdd(aRecnoSC6, SC6->(recno()))
		SC6->(dbSkip())
	endDo
	
	for nJ := 1 to len(aRecnoSC6)
		
		SC6->(dbGoTo(aRecnoSC6[nJ]))
		
		getSaldoB6ByProdLote(aSaldoB6ByProdLote)
		gravCFOP(_cTesDev)
		
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Mudou TES e CFOP do Item do Pedido.", 0, 0, {})
	
		//inicio do processo de controle de saldo por lote de poder3		
		_nSaldoVenda  := SC6->C6_QTDVEN
		_cSC6ProxItem := BuscaUltItem(SC5->C5_NUM)
		
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Está no Item: "+SC6->C6_ITEM+" do pedido: "+SC6->C6_NUM, 0, 0, {})
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Saldo de Venda: "+str(_nSaldoVenda)+" - QtdVen: "+str(SC6->C6_QTDVEN), 0, 0, {})

		if len(aSaldoB6ByProdLote) == 0
			
			disarmTransaction()
			getMsgLog(@cFunName, @cMsg, @cDoc1, @cDoc2, @cDoc3, @cCodMsg)
			gravLog(cFunName, cMsg, cDoc1, cDoc2, cDoc3, cCodMsg)
			return .F.
			
		endIf
		
		If Empty(SC6->C6_NFORI)
			
			getConvUnidMedida(@_nConv, @_cTipConv)
			
			for nI := 1 to len(aSaldoB6ByProdLote)
				
				nQtdC6 := SC6->C6_QTDVEN
				
				nPos := aScan(aSaldoB6ByProdLote, {|x| allTrim(x[7]) == allTrim(SC6->C6_PRODUTO) .and. allTrim(x[8]) == allTrim(SC6->C6_LOTECTL) .and. allTrim(x[9]) == NAO_CONSUMIDO})
				
				if nPos > 0
					
					nSaldoB6 := aSaldoB6ByProdLote[nPos][5]
					
					if nSaldoB6 >= nQtdC6
						FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Saldo de Venda maior do que Quantidade vendida.", 0, 0, {})
						dbSelectArea("SC6")
						If SC6->(RecLock("SC6",.F.))
							SC6->C6_NFORI   := aSaldoB6ByProdLote[nPos][1]
							SC6->C6_SERIORI := aSaldoB6ByProdLote[nPos][2]
							SC6->C6_ITEMORI := aSaldoB6ByProdLote[nPos][3]
							SC6->C6_IDENTB6 := aSaldoB6ByProdLote[nPos][4]
							SC6->C6_PRCVEN  := aSaldoB6ByProdLote[nPos][6]
							SC6->C6_UNSVEN  := IIF(_cTipConv=="M",SC6->C6_QTDVEN * _nConv,SC6->C6_QTDVEN / _nConv)
							SC6->C6_VALOR   := (aSaldoB6ByProdLote[nPos][6] * SC6->C6_QTDVEN)
							SC6->C6_QTDEMP  := SC6->C6_QTDVEN
							SC6->C6_QTDEMP2 := SC6->C6_UNSVEN
							SC6->C6_QTDLIB  := SC6->C6_QTDVEN
							SC6->(MsUnLock("SC6"))
							FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Gravado NF Original para este item em Poder de Terceiros - Pedido: "+SC6->C6_NUM, 0, 0, {})
						EndIf
						
						atualizaSaldo(aSaldoB6ByProdLote[nPos], nQtdC6)
						criaRegisSC9()
						exit
						
					else
						FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Saldo B6 menor do que Quantidade vendida.", 0, 0, {})
						dbSelectArea("SC6")
						If SC6->(RecLock("SC6",.F.))
							SC6->C6_NFORI   := aSaldoB6ByProdLote[nPos][1]
							SC6->C6_SERIORI := aSaldoB6ByProdLote[nPos][2]
							SC6->C6_ITEMORI := aSaldoB6ByProdLote[nPos][3]
							SC6->C6_IDENTB6 := aSaldoB6ByProdLote[nPos][4]
							SC6->C6_QTDVEN  := aSaldoB6ByProdLote[nPos][5]
							SC6->C6_PRCVEN  := aSaldoB6ByProdLote[nPos][6]
							SC6->C6_VALOR   := (aSaldoB6ByProdLote[nPos][6] * SC6->C6_QTDVEN)
							SC6->C6_UNSVEN  := IIF(_cTipConv=="M",SC6->C6_QTDVEN * _nConv,SC6->C6_QTDVEN / _nConv)
							SC6->C6_QTDEMP  := SC6->C6_QTDVEN
							SC6->C6_QTDEMP2 := SC6->C6_UNSVEN
							SC6->C6_QTDLIB  := SC6->C6_QTDVEN
							SC6->(MsUnLock("SC6"))
						EndIf
						
						criaRegisSC9()
						
						nSaldoRestVend  := nQtdC6 - nSaldoB6
						
						atualizaSaldo(aSaldoB6ByProdLote[nPos], SC6->C6_QTDVEN, .F. )
						
						if nSaldoRestVend > 0
							
							nPos := aScan(aSaldoB6ByProdLote, {|x| allTrim(x[7]) == allTrim(SC6->C6_PRODUTO) .and. allTrim(x[8]) == allTrim(SC6->C6_LOTECTL) .and. allTrim(x[9]) == NAO_CONSUMIDO .and. x[5] >= nSaldoRestVend})
							
							//CASO FOR 0 É PORQUE O SALDO DA B6 É MENOR QUE A QUANTIDACE A SER PROCESSADA
							if nPos == 0 .and. nSaldoRestVend > 0
								consomeQtdByItemFull(aSaldoB6ByProdLote, @nSaldoRestVend, @lok)
								exit
							endIf
							
							if nPos > 0
								atualizaSaldo(aSaldoB6ByProdLote[nPos], nSaldoRestVend, .F.)
								IncluiSC6(_cSC6ProxItem, nSaldoRestVend,aSaldoB6ByProdLote[nPos])
							else
								disarmTransaction()
								getMsgLog(@cFunName, @cMsg, @cDoc1, @cDoc2, @cDoc3, @cCodMsg)
								gravLog(cFunName, cMsg, cDoc1, cDoc2, cDoc3, cCodMsg)
								return .F.
							endIf
							
						endIf
						
						exit
						
					endIf
					
				else
					disarmTransaction()
					getMsgLog(@cFunName, @cMsg, @cDoc1, @cDoc2, @cDoc3, @cCodMsg)
					gravLog(cFunName, cMsg, cDoc1, cDoc2, cDoc3, cCodMsg)
					return .F.
				endIf
				
			next nI
		endIf
	next nJ
	
return lok

***************************************************************
static function setFileLog(cFile,cLogType,cLogText,cTag,cValue)
	***************************************************************
	
	local cInterface := "_AgeVNFTer"
	
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

*****************************************
Static Function BuscaUltItem(_cC5NUM)
	*****************************************
	
	Local _aArea := GetArea()
	
	If Select("_C6") <> 0
		_C6->(dbCloseArea())
	Endif
	
	BeginSql Alias "_C6"
		SELECT SC6.C6_ITEM
		FROM %Table:SC6% SC6
		WHERE
		SC6.C6_FILIAL = %xFilial:SC6% AND
		SC6.C6_NUM = %Exp:_cC5NUM% AND
		SC6.%NotDel%
		ORDER BY SC6.C6_ITEM DESC
	EndSql
	
	dbSelectArea("_C6")
	_C6->(dbGoTop())
	
	If !Eof()
		_cItemSC6:= Soma1(_C6->C6_ITEM)
	Else
		_cItemSC6 := "01"
	EndIf
	
Return(_cItemSC6)

*****************************************************
Static Function IncluiSC6(_cSC6ProxItem,_nSaldoVenda, aSaldoB6ByProdLote)
	*****************************************************
	
	Local _C6FILIAL  := SC6->C6_FILIAL
	Local _C6NUM     := SC6->C6_NUM
	Local _C6LOTECTL := SC6->C6_LOTECTL
	Local _C6ITEM    := _cSC6ProxItem
	Local _C6PRODUTO := SC6->C6_PRODUTO
	Local _C6DESCRI  := SC6->C6_DESCRI
	Local _C6UM      := SC6->C6_UM
	Local _C6QTDVEN  := _nSaldoVenda
	Local _C6PRCVEN  := aSaldoB6ByProdLote[6]
	Local _C6VALOR   := SC6->C6_VALOR
	Local _C6SEGUM   := SC6->C6_SEGUM
	Local _C6TES     := SC6->C6_TES
	Local _C6CF      := SC6->C6_CF
	Local _C6LOCAL   := SC6->C6_LOCAL
	Local _C6ENTREG  := SC6->C6_ENTREG
	Local _C6CLI     := SC6->C6_CLI
	Local _C6LOJA    := SC6->C6_LOJA
	Local _C6DTVALID := SC6->C6_DTVALID
	Local _C6TPOP    := SC6->C6_TPOP
	Local _C6SUGENTR := SC6->C6_SUGENTR
	Local _C6DTFIMNT := SC6->C6_DTFIMNT
	Local _C6RATEIO  := SC6->C6_RATEIO
	Local _C6ZZLOTE  := SC6->C6_ZZLOTE
	Local _C6PRUNIT  := SC6->C6_PRUNIT
	Local _C6CLASFIS := SC6->C6_CLASFIS
	Local _C6OP      := SC6->C6_OP
	Local aArea		 := getArea()
	Local aAreaC6	 := SC6->(getArea())
	Local _nConv     := 0
	Local _cTipConv  := ""
	Local lIncluiSC6 := .F.
	
	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Entrou na Inclusão de Itens novosa.", 0, 0, {})
	
	getConvUnidMedida(@_nConv, @_cTipConv)
	
	dbSelectArea("SC6")
	If RecLock("SC6",.T.)
		SC6->C6_FILIAL  := _C6FILIAL
		SC6->C6_NUM     := _C6NUM
		SC6->C6_LOTECTL := _C6LOTECTL
		SC6->C6_ITEM    := _C6ITEM
		SC6->C6_PRODUTO := _C6PRODUTO
		SC6->C6_DESCRI  := _C6DESCRI
		SC6->C6_UM      := _C6UM
		SC6->C6_QTDVEN  := _C6QTDVEN
		SC6->C6_PRCVEN  := _C6PRCVEN
		SC6->C6_VALOR   := _C6QTDVEN * _C6PRCVEN
		SC6->C6_SEGUM   := _C6SEGUM
		SC6->C6_UNSVEN  := IIF(_cTipConv=="M",SC6->C6_QTDVEN * _nConv,SC6->C6_QTDVEN / _nConv)
		SC6->C6_TES     := _C6TES
		SC6->C6_CF      := _C6CF
		SC6->C6_LOCAL   := _C6LOCAL
		SC6->C6_ENTREG  := _C6ENTREG
		SC6->C6_CLI     := _C6CLI
		SC6->C6_LOJA    := _C6LOJA
		SC6->C6_DTVALID := _C6DTVALID
		SC6->C6_TPOP    := _C6TPOP
		SC6->C6_SUGENTR := _C6SUGENTR
		SC6->C6_DTFIMNT := _C6DTFIMNT
		SC6->C6_RATEIO  := _C6RATEIO
		SC6->C6_ZZLOTE  := _C6ZZLOTE
		SC6->C6_PRUNIT  := _C6PRUNIT
		SC6->C6_CLASFIS := _C6CLASFIS
		SC6->C6_QTDEMP  := SC6->C6_QTDVEN
		SC6->C6_QTDEMP2 := SC6->C6_UNSVEN
		SC6->C6_OP      := _C6OP
		SC6->C6_QTDLIB  := SC6->C6_QTDVEN
		
		SC6->C6_NFORI   := aSaldoB6ByProdLote[1]
		SC6->C6_SERIORI := aSaldoB6ByProdLote[2]
		SC6->C6_ITEMORI := aSaldoB6ByProdLote[3]
		SC6->C6_IDENTB6 := aSaldoB6ByProdLote[4]
		
		lIncluiSC6 		:= .T.
		MsUnLock("SC6")
	EndIf
	
	if lIncluiSC6
		criaRegisSC9()
	endIf
	
	_cSC6ProxItem := Soma1(_cSC6ProxItem)
	
	restArea(aAreaC6)
	restArea(aArea)
	
Return(_cSC6ProxItem)



Static Function ValidLote(cNota, cSerie, cCliente, cLoja, cPedido)
	Local lValidLote := .F.
	Local oSql		 := IpSqlObject():newIpSqlObject()
	Local cQuery	 := ""
	
	cQuery += "SELECT Z9_COD, Z9_LOTE, C6_PRODUTO, C6_LOTECTL "									+ CRLF
	cQuery += "FROM %SZ9.SQLNAME% "           													+ CRLF
	
	cQuery += "INNER JOIN %SC6.SQLNAME% ON "                        							+ CRLF
	cQuery += "		Z9_COD = C6_PRODUTO AND "                  									+ CRLF
	cQuery += "		Z9_LOTE = C6_LOTECTL "                  									+ CRLF
	
	cQuery += "INNER JOIN %SC5.SQLNAME% ON "													+ CRLF
	cQuery += "		C5_NUM = C6_NUM AND "			+ CRLF
	cQuery += "		TRIM(Z9_DOC) = SUBSTR(LPAD(TRIM(C5_ZZORDEX), 11, 0), 1, 9) AND "			+ CRLF
	cQuery += "		TRIM(Z9_SERIE) = TRIM(SUBSTR(C5_ZZORDEX, 8, 1)) "							+ CRLF
	
	cQuery += "INNER JOIN %SB1.SQLNAME% ON "													+ CRLF
	cQuery += "		Z9_COD = B1_COD AND " 														+ CRLF
	cQuery += "		C6_PRODUTO = B1_COD " 														+ CRLF
	
	cQuery += "WHERE Z9_DOC = '" + cNota + "' AND " 											+ CRLF
	cQuery += "		 Z9_SERIE = '" + cSerie + "' AND " 											+ CRLF
	cQuery += "		 Z9_CLIENTE = '" + cCliente + "' AND " 										+ CRLF
	cQuery += "		 Z9_LOJA = '" + cLoja + "'  AND " 											+ CRLF
	cQuery += "		 C5_NUM = '" + cPedido + "'  AND " 											+ CRLF
	cQuery += "		 Z9_FILIAL = '%SZ9.FILIAL%' AND " 											+ CRLF
	cQuery += "		 C6_FILIAL = '%SC6.FILIAL%' AND " 											+ CRLF
	cQuery += "		 C5_FILIAL = '%SC5.FILIAL%' AND " 											+ CRLF
	cQuery += "		 B1_FILIAL = '%SB1.FILIAL%' AND " 											+ CRLF
	cQuery += "		 %SZ9.NOTDEL% AND %SC5.NOTDEL% AND %SC6.NOTDEL% AND %SB1.NOTDEL% "  		+ CRLF
	oSql:newAlias(cQuery)
	
	If oSql:hasRecords()
		lValidLote = .T.
	EndIf
	
	oSql:close()
	
Return lValidLote


/*
** Retorna se produto controla lote
*/
Static Function fRastro(cCodProd)
Return (Posicione("SB1", 1, xFilial("SB1") + cCodProd, "B1_RASTRO") == "L")

/**
*	Retorna o saldo do produto/lote
**/
static function getSaldoB6ByProdLote(aSaldoB6ByProdLote)
	
	local aArea 		:= getArea()
	local aAreaB6 		:= SB6->(getArea())
	local cQuery  		:= ""
	local cAlias    	:= getNextALias()
	local nQtdRegistros := 0
	local nPos			:= 0
	
	nPos := aScan(aSaldoB6ByProdLote, {|x| allTrim(x[7]) == allTrim(SC6->C6_PRODUTO) .and. allTrim(x[8]) == allTrim(SC6->C6_LOTECTL) .and. allTrim(x[9]) == NAO_CONSUMIDO})
	
	if nPos == 0
		nPos := aScan(aSaldoB6ByProdLote, {|x| allTrim(x[7]) == allTrim(SC6->C6_PRODUTO) .and. allTrim(x[8]) == allTrim(SC6->C6_LOTECTL)})
		//CASO NÃO TIVER NO ARRAY, OBTENHO O NOVO SALDO DO PRODUTO LOTE NA SB6
		if nPos == 0
			
			cQuery := " SELECT SB6.B6_DOC, SB6.B6_SERIE, SB6.B6_PRODUTO, SB6.B6_CLIFOR, SB6.B6_LOJA, SB6.B6_IDENT, SD1.D1_DOC, SD1.D1_COD, SD1.D1_LOTECTL, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_IDENTB6, SD1.D1_ITEM, SD1.D1_VUNIT, SB6.B6_SALDO " + CRLF
			cQuery += " FROM " +retSqlName("SB6") + " SB6 " 					+ CRLF
			cQuery += " INNER JOIN " + retSqlName("SD1") + " SD1 ON 1 = 1" 		+ CRLF
			cQuery += "    AND SD1.D1_FILIAL = SB6.B6_FILIAL" 					+ CRLF
			cQuery += "    AND SD1.D1_IDENTB6 = SB6.B6_IDENT" 					+ CRLF
			cQuery += "    AND SD1.D1_COD = SB6.B6_PRODUTO" 					+ CRLF
			cQuery += "    AND SD1.D_E_L_E_T_ = ' '" 							+ CRLF
			cQuery += " WHERE 1 = 1" 											+ CRLF
			cQuery += "    AND SB6.B6_FILIAL = '"+fwxFilial("SB6")+"'" 			+ CRLF
			cQuery += "    AND SB6.B6_SALDO > 0" 								+ CRLF
			cQuery += "    AND SB6.B6_PODER3 = 'R'" 							+ CRLF
			cQuery += "    AND SD1.D1_LOTECTL = '"+SC6->C6_LOTECTL+"'" 			+ CRLF
			cQuery += "    AND SD1.D1_COD = '"+SC6->C6_PRODUTO+"'" 				+ CRLF
			cQuery += "    AND SB6.D_E_L_E_T_ = ' '" 							+ CRLF
			cQuery += " ORDER BY SB6.B6_EMISSAO, SB6.B6_DOC" 					+ CRLF
			
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T. )
			
			count to nQtdRegistros
			
			if nQtdRegistros > 0
				(cAlias)->(dbGoTop())
				while (cAlias)->(!eof())
					
					aAdd(aSaldoB6ByProdLote, {(cAlias)->B6_DOC, (cAlias)->B6_SERIE, (cAlias)->D1_ITEM, (cAlias)->B6_IDENT, (cAlias)->B6_SALDO, (cAlias)->D1_VUNIT, (cAlias)->D1_COD, (cAlias)->D1_LOTECTL, NAO_CONSUMIDO })
					
					(cAlias)->(dbSkip())
				endDo
			endIf
			
			(cAlias)->(dbCloseArea())
			
		endIf
	endIf
	
	restArea(aAreaB6)
	restArea(aArea)
	
return

/**
* Obtém o CFOP a partir da TES de devolução e grava na SC6
**/
static function gravCFOP(_cTesDev)
	
	local aArea 	:= getArea()
	local aAreaSF4 	:= SF4->(getArea())
	local cCFOP     := ""
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial("SF4")+_cTesDev,.F.)
		cCFOP := SF4->F4_CF
	Else
		cCFOP := ""
	EndIf
	
	dbSelectArea("SC6")
	If RecLock("SC6",.F.)
		SC6->C6_TES := _cTesDev
		SC6->C6_CF  := cCFOP
		MsUnLock("SC6")
	EndIf
	
	restArea(aAreaSF4)
	restArea(aArea)
	
return

/**
* atualiza o saldo
**/
static function atualizaSaldo(aSaldoB6ByProdLote, nSaldoConsumido, lItemFull)
 
																 
	
	if lItemFull
		
		nSaldoConsumido			:= nSaldoConsumido - aSaldoB6ByProdLote[5]
		aSaldoB6ByProdLote[5] 	:= 0
		
		if aSaldoB6ByProdLote[5] == 0
			aSaldoB6ByProdLote[9] := CONSUMIDO
		endIf
		
	else
		
		aSaldoB6ByProdLote[5] := aSaldoB6ByProdLote[5] - nSaldoConsumido
		
		if aSaldoB6ByProdLote[5] == 0
			aSaldoB6ByProdLote[9] := CONSUMIDO
		endIf
		
	endIf
	
return

/**
* Cria registro na SC9
**/
static function criaRegisSC9()
	
	local aArea 	:= getArea()
	local aAreaSC9 	:= SC9->(getArea())
	
	SC9->(dbSelectArea("SC9"))
	SC9->(dbSetOrder(1))
	If SC9->(RecLock("SC9",.T.))
		SC9->C9_FILIAL  := SC6->C6_FILIAL
		SC9->C9_PEDIDO  := SC6->C6_NUM
		SC9->C9_ITEM    := SC6->C6_ITEM
		SC9->C9_CLIENTE := SC6->C6_CLI
		SC9->C9_LOJA    := SC6->C6_LOJA
		SC9->C9_PRODUTO := SC6->C6_PRODUTO
		SC9->C9_QTDLIB  := SC6->C6_QTDLIB
		SC9->C9_DATALIB := dDataBase
		SC9->C9_SEQUEN  := "01"
		SC9->C9_GRUPO   := SB1->B1_GRUPO
		SC9->C9_PRCVEN  := SC6->C6_PRCVEN
		SC9->C9_IDENTB6 := SC6->C6_IDENTB6
		SC9->C9_LOTECTL := SC6->C6_LOTECTL
		SC9->C9_DTVALID := SC6->C6_DTVALID
		SC9->C9_LOCAL   := SC6->C6_LOCAL
		SC9->C9_TPCARGA := SC5->C5_TPCARGA
		SC9->C9_QTDLIB2 := SC6->C6_UNSVEN
		SC9->C9_RETOPER := "2"
		SC9->C9_TPOP    := "1"
		SC9->C9_DATENT  := dDataBase
		SC9->(MsUnLock("SC9"))
	EndIf
	
	restArea(aAreaSC9)
	restArea(aArea)
	
return

/**
* obtém a conversão da unidade de medida
**/
static function getConvUnidMedida(_nConv, _cTipConv)
	
	local aArea 	:= getArea()
	local aAreaSB1 	:= SB1->(getArea())
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+SC6->C6_PRODUTO,.F.)
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Achou conversao 2 unidade de medida.", 0, 0, {})
		_nConv    := SB1->B1_CONV
		_cTipConv := SB1->B1_TIPCONV
	Else
		FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Não achou conversao 2 unidade de medida.", 0, 0, {})
		_nConv    := 0
		_cTipConv := "M"
	EndIf
	
	restArea(aAreaSB1)
	restArea(aArea)
	
return

/**
* Apaga os pedidos liberados referente ao pedido
**/
static function eraseSC9(_cNumSC5)
	
	local aArea := getArea()
	local aAreaSC6 := SC9->(getArea())
	
	SC9->(dbSelectArea("SC9"))
	SC9->(dbSetOrder(1))
	if SC9->(dbSeek(xFilial("SC9")+_cNumSC5,.F.))
		
		While SC9->(!Eof()) .And. _cNumSC5==SC9->C9_PEDIDO
			
			If SC9->(RecLock("SC9",.F.))
				SC9->(dbDelete())
				SC9->(MsUnLock("SC9"))
			EndIf
			
			SC9->(dbSkip())
			
		EndDo
		
	endIf
	
	restArea(aAreaSC6)
	restArea(aArea)
	
return

/**
* Retorna a Mensagem de erro
**/
static function getMsgLog(_cFunName, _cMsg, _cDoc1, _cDoc2, _cDoc3, _cCodMsg)
	
	_cFunName := "_AgeVNFTer"
	_cMsg     := "Interface não pode ser processada. Pedido Não existe estoque para este item em Poder de Terceiros - Pedido: "+SC6->C6_NUM+" / "+SC6->C6_PRODUTO
	_cDoc1    := SC6->C6_NUM
	_cDoc2    := SC6->C6_PRODUTO
	_cDoc3    := ""
	_cCodMsg  := "07"
	
return

/**
* Grava o log
**/
static function gravLog(cFunName, cMsg, cDoc1, cDoc2, cDoc3, cCodMsg)
	
	If lNewAge .And. lAutomatic
		If U_FITLogControl(cFunName,cCodMsg,cDoc1,cDoc2,cDoc3,cMsg)
			setFileLog(" ","fail",cMsg)
		EndIf
	Else
		setFileLog(" ","fail",cMsg)
	EndIf
	
	FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "Não existe estoque para este item em Poder de Terceiros - Pedido: "+SC6->C6_NUM, 0, 0, {})
return

/**
* Obtém a nota Ordex
**/
static function getNotaOrdex(cOrderx)
	
	local cNotaOrdex := StrZero(Val(Substr(SC5->C5_ZZORDEX,1,RAT("-", allTrim(SC5->C5_ZZORDEX)))),9,0)
	
return cNotaOrdex

/**
* consome toda a quantidade do item. Novo cenário em 17/05/2019
**/
static function consomeQtdByItemFull(aSaldoB6ByProdLote, nSaldoRestVend, lok)
	
	local nPos 				:= 0
	local nSaldoDisponivel 	:= 0
	local nSaldoParcial		:= 0
	
	//BUSCO UM REGISTRO COM SALDO DISPONÍVEL
	nPos := aScan(aSaldoB6ByProdLote, {|x| allTrim(x[7]) == allTrim(SC6->C6_PRODUTO) .and. allTrim(x[8]) == allTrim(SC6->C6_LOTECTL) .and. allTrim(x[9]) == NAO_CONSUMIDO})
	
	if nPos > 0
		
		nSaldoDisponivel := aSaldoB6ByProdLote[nPos][5]
		
		if nSaldoDisponivel <=  nSaldoRestVend
			
			atualizaSaldo(aSaldoB6ByProdLote[nPos], @nSaldoRestVend, .T.)
			_cSC6ProxItem := IncluiSC6(_cSC6ProxItem, nSaldoDisponivel,aSaldoB6ByProdLote[nPos])
			
		else
			
			atuSaldoParcial(aSaldoB6ByProdLote[nPos], @nSaldoRestVend)
			_cSC6ProxItem  := IncluiSC6(_cSC6ProxItem, nSaldoRestVend,aSaldoB6ByProdLote[nPos])
			
			//DEFINO 0 PORQUE FOI UTILIZADO TOTALMENTE PARA CRIAR A NOVA LINHA DA SC6
			nSaldoRestVend := 0
			conout("teste")
			
		endIf
		
	endIf
	
	if nSaldoRestVend > 0
		
		//BUSCO UM REGISTRO COM SALDO DISPONÍVEL
		nPos := aScan(aSaldoB6ByProdLote, {|x| allTrim(x[7]) == allTrim(SC6->C6_PRODUTO) .and. allTrim(x[8]) == allTrim(SC6->C6_LOTECTL) .and. allTrim(x[9]) == NAO_CONSUMIDO})
		if nPos > 0 .and. nSaldoRestVend > 0
			consomeQtdByItemFull(aSaldoB6ByProdLote, @nSaldoRestVend)
		else
			lok := .F.
		endIf
		
	endIf
	
return

/**
* Atualiza o saldo parcial
**/
static function atuSaldoParcial(aSaldoB6ByProdLote, nSaldoRestVend)
	
	local nSaldoParcial := 0
	
	nSaldoParcial         := aSaldoB6ByProdLote[5] - nSaldoRestVend
	aSaldoB6ByProdLote[5] := nSaldoParcial
	
return

/**
* valida o total dos itens
**/
static function validTotalItens()
	
	local aArea 	:= getArea()
	local aAreaSC6 	:= SC6->(getArea())
	local nQtdVen	:= 0
	
	SC6->(dbSetOrder(1))
	SC6->(dbSeek( xFilial("SC6") + SC5->C5_NUM ))
	While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == SC5->C5_NUM
		
		nQtdVen += SC6->C6_QTDVEN
		
		SC6->(dbSkip())
	endDo
	restArea(aArea)
	restArea(aAreaSC6)
	
return
