#Include 'Protheus.ch'
#include "totvs.ch"
#include "rwmake.ch"
#include "DHL.ch"

/*/{Protheus.doc} EstM001
Processo para divisão de itens de nf por Lote
- Exclusivo DHL
@type 		User function
@author 	FitGestão - Edson Deluca
@since 		12/04/2018
@version 	1.0
@param		${_aItensNF}, ${Array}	, Array contendo os itens a serem inclusos.
@return 	${_aRet} 	, ${Array}	, Conteúdo para inclusão de item de NF
@example	u_EstM001(_aItensNF)
 /*/  
User Function ESTM001(_aItensNF,cInfAdicCpl)

	Local cProduto	:= ""
	Local _nIt  := 0
	Local _nLt 	:= 0
	Local _nQt  := 0
	Local _aRet := {}
	Local _nContador := 0
	Local _lCobertura := .F.
	Local _cSemInfAdicCpl := .F.
	Default _aItensNF   := {}
	Default cInfAdicCpl := ""

	private lNewAge       := SuperGetMV("ZZ_NEWAGE",,.F.) //adicionado por Edson Deluca - FIT Gestão
	private lAutomatic    := SuperGetMV("ZZ_AUTOMAT",,.F.) //adicionado por Edson Deluca - FIT Gestão
	private _cTES         := SuperGetMV("ZZ_TESREM",,"0I1")
	private _cTESCob      := SuperGetMV("ZZ_TESCOB",,"0I2")
	Private _aRet         := _aItensNF
// Somente com itens 

	if len(_aRet) > 0

	// Localizando os campos a serem modificados.
		_nPosCtl:= Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_LOTECTL"})
		_nPosPr := Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_COD"})
		_nPosLT := Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_ZZINFAP"})
		_nPosUM := Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_UM"})
		_nPosVu := Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_VUNIT"})
		_nPosVlr:= Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_TOTAL"})
		_nPosIt := Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_ITEM"})
		_nPosSu := Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_SEGUM"})
		_nPosQtS:= Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_QTSEGUM"})
		_nPosVlU:= Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_VUNIT"})
		_nPosQt := Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_QUANT"})
		_nPosZZT:= Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_ZZTOTAL"})
		_nPosTES:= Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_ZZTES"})
		_nPosICM:= Ascan(_aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_ZZVLICM"})


	// Se encontrou todos campos
		if _nPosLT>0.and._nPosQt>0.and. _nPosVlr>0.and. _nPosIt>0
       //Verifica se é Nota de Cobertura
			If !Empty(cInfAdicCpl)
				For _nIX:=1 to Len(cInfAdicCpl)
					If Substr(cInfAdicCpl,_nIX,09)=="NF Transf"
						_lCobertura := .T.
						Exit
					EndIf
				Next _nIX
			EndIf

			For _nIt := 1 to Len(_aRet)
				FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Unidade: "+_aRet[_nIt][_nPosUm][02]+" | Valor Unitario: "+str(_aRet[_nIt][_nPosVlu][02])+" | Quantidade: "+str(_aRet[_nIt][_nPosQt][02])+" | Total: "+str(_aRet[_nIt][_nPosVlr][02]), 0, 0, {})
  
  				_aInfoPro 	:= GetAdvFVal("SB1",{"B1_UM","B1_CONV","B1_TIPCONV","B1_SEGUM"},FwxFilial("SB1") + Alltrim(_aRet[_nIt][_nPosPr][02]),1, )
				_cUniBas	:= _aInfoPro[01]
				_nConversor := _aInfoPro[02]
				_cTipConv   := _aInfoPro[03]
				_cSegUm     := _aInfoPro[04]

				FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Segunda unidade de Medida: "+_cSegUm, 0, 0, {})
  
				If _lCobertura
					_aRet[_nIt][_nPosTES][02]:=_cTESCob
				EndIf
				
				// Somente lotes preenchidos.
				if !empty(_aRet[_nIt][_nPosLT][02])

					If AllTrim(_aRet[_nIt][_nPosUm][02]) == AllTrim(_cSegUm)
						FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Entrada = Segunda Unidade", 0, 0, {})
						_nVOrig := IIF(_cTipoConv="M",_aRet[_nIt][_nPosVlU][02] * _nConversor,_aRet[_nIt][_nPosVlU][02] / _nConversor)
						_nQtdOrig   := IIF(_cTipoConv="M",_aRet[_nIt][_nPosQT][02] / _nConversor,_aRet[_nIt][_nPosQT][02] * _nConversor)
						_nTotal     := _aRet[_nIt][_nPosVlr][02]
						_nVlIcm     := _aRet[_nIt][_nPosICM][02] / _aRet[_nIt][_nPosVlr][02]
					Else
						FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Entrada = Primeira Unidade", 0, 0, {})
						_nVOrig     := _aRet[_nIt][_nPosVlU][02]
						_nQtdOrig   := _aRet[_nIt][_nPosQT][02]
						_nTotal     := _aRet[_nIt][_nPosVlr][02]
						_nVlIcm     := _aRet[_nIt][_nPosICM][02] / _aRet[_nIt][_nPosVlr][02]
					EndIf

				// Verificando quantos lotes serão processados.
					_lPrimeira:=.T.
					for _nLt := 1 to Len(_aRet[_nIt][_nPosLT][02])
						_cLote   := ''
						_nQtdVen := 0
					
						If Substr(_aRet[_nIt][_nPosLT][02],_nLt,5) == "Lote:"
	
							_nContador++
               
							_cLote   := Substr(_aRet[_nIt][_nPosLT][02],_nLt+5,11)
							If Substr(_cLote,11,1)="-"
								_cLote :=Substr(_cLote,1,10)
							Else
								_cLote :=Substr(_cLote,2,10)
							EndIf
	           
							For _K:= _nLt to Len(_aRet[_nIt][_nPosLT][02])
								If Substr(_aRet[_nIt][_nPosLT][02],_K,1)="-"
									_nLt := _K + 1
									Exit
								EndIf
							Next _K
	                    
							
							_nQtdVen  := Substr(_aRet[_nIt][_nPosLT][02],_nLt,11)
							
							if "." $ _nQtdVen
								_nQtdVen  := StrTran(_nQtdVen,".","")
								_nQtdVen  := StrTran(_nQtdVen,",",".")
								_nQtdVen  := Val(_nQtdVen)
								_nQtdVen  := IIF(_nPosUM<>0,IIF(AllTrim(_aRet[_nIt][_nPosUM][02])=="TO" .And. _nQtdVen > 100,_nQtdVen/_nConversor,_nQtdVen),_nQtdVen)
							else								
								if AllTrim(_aRet[_nIt][_nPosUm][02]) != AllTrim(_cSegUm)									
									//_nQtdVen  := Val(_nQtdVen) / _nConversor		
									_nQtdVen  := Round((Val(_nQtdVen) / _nConversor),1)	//Emerson Holanda 28/10/2020 --Ajuste no Arredondamento das casas decimais no calculo.						
								endIf	                   
							endIf

							FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Vunit antes: " + str(_nVOrig), 0, 0, {})
							FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "nQtdVen antes: " + str(_nQtdVen), 0, 0, {})
							
							_nVUnit   := IIF(_nPosUM<>0,IIF(AllTrim(_aRet[_nIt][_nPosUM][02])=="TO" .And. _nQtdOrig > 100,_nVOrig * _nConversor, _nVOrig),_nVOrig)

							FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Vunit: " + str(_nVunit), 0, 0, {})
							FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "nQtdVen: " + str(_nQtdVen), 0, 0, {})
							
							cProduto := _aRet[_nIt][_nPosPr][02]
						
							if isRastroPrenchido(_aRet, _cLote, cProduto, _lPrimeira)
								loop
							endIf
						
							if !empty(_cLote) .and. _nQtdVen#0
								_aTmp := Aclone(_aRet[_nIt])
	                        
	           			 	// Adiciona no array de retorno com as quantidades e Lote retirados da linha
								If !_lPrimeira
									aadd( _aRet, _aTmp)
								EndIf
	           				// altera os Lote/Valor
								If _lPrimeira
									_aRet[_nIt][_nPosIt][02] 	:= StrZero(_nContador,4,0)
//							   _aRet[len(_aRet)][_nPosSu][02] 	:= POSICIONE("SB1",1,xFilial("SB1")+_aRet[_nIt][_nPosPr][02],"B1_SEGUM")
									_aRet[_nIt][_nPosCtl][02]	:= _cLote
									_aRet[_nIt][_nPosVu][02] 	:= _nVUnit
									_aRet[_nIt][_nPosICM][02]	:= _nVlIcm * (_nVUnit * _nQtdVen)
									_aRet[_nIt][_nPosQt][02] 	:= _nQtdVen
									If _nPosQTS<>0
										_aRet[_nIt][_nPosQtS][02]	:= if(_cTipConv="M",_nQtdVen * _nConversor,_nQtdVen / _nConversor)
									EndIf
							
									_aRet[_nIt][_nPosVlr][02]	:= _nVUnit * _nQtdVen
									_aRet[_nIt][_nPosZZT][02]	:= _nVUnit * _nQtdVen
			                   
									FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Unidade: "+_aRet[_nIt][_nPosUm][02]+" | Valor Unitario: "+str(_nVUnit)+" | Quantidade: "+str(_nQtdOrig)+" | Total: "+str(_nVUnit * _nQtdVen), 0, 0, {})

									_lPrimeira:=.F.
								Else
									_aRet[len(_aRet)][_nPosIt][02] 	:= StrZero(_nContador,4,0)
//							   		_aRet[len(_aRet)][_nPosSu][02] 	:= POSICIONE("SB1",1,xFilial("SB1")+_aRet[_nIt][_nPosPr][02],"B1_SEGUM")
									_aRet[len(_aRet)][_nPosCtl][02]	:= _cLote
									_aRet[len(_aRet)][_nPosVu][02] 	:= _nVUnit
									_aRet[len(_aRet)][_nPosICM][02]	:= _nVlIcm * (_nVUnit * _nQtdVen)
									_aRet[len(_aRet)][_nPosQt][02] 	:= _nQtdVen

									If _nPosQTS<>0
										_aRet[len(_aRet)][_nPosQtS][02]	:= if(_cTipConv="M",_nQtdVen * _nConversor,_nQtdVen / _nConversor)
									EndIf
							
									_aRet[len(_aRet)][_nPosVlr][02]	:= _nVUnit * _nQtdVen
									_aRet[len(_aRet)][_nPosZZT][02]	:= _nVUnit * _nQtdVen
									
									FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Unidade: "+_aRet[_nIt][_nPosUm][02]+" | Valor Unitario: "+str(_nVUnit)+" | Quantidade: "+str(_nQtdOrig)+" | Total: "+str(_nVUnit * _nQtdVen), 0, 0, {})
								EndIf
	           	 
							Endif
	           
						Endif
			
					Next
			
				Endif
		
			Next

		Endif
	
	Endif
	
Return _aRet

/**
* Verifica se possui rastro preenchido pelo Importador_de_XML-TOTVS_IP
**/
static function isRastroPrenchido(aRet, cLote, cProduto, _lPrimeira)

	local lIsRastroPreenc := .F.
	local nPosFieldLote	  := Ascan(aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_LOTECTL"})
	local nPosFieldProd	  := Ascan(aRet[01],{|x| Upper(AllTrim(x[01]))=="D1_COD"})
	local nScan			  := 0
	
	nScan := aScan(aRet, {|x| allTrim(x[nPosFieldLote][2]) == allTrim(cLote) .and. allTrim(x[nPosFieldProd][2]) == allTrim(cProduto) })
	
	if nScan > 0 .and. _lPrimeira
		lIsRastroPreenc := .T.
	endIf
	
return lIsRastroPreenc
 
