#include "protheus.ch"
#include "dhl.ch"

/*/{Protheus.doc} MT100AGR

O ponto de entrada é chamado após a confirmação da NF,
porém fora da transação. Isto foi feito pois clientes que utilizavam
TTS e tinham interface com o usuario no ponto MATA100 "travavam"
os registros utilizados, causando parada para outros usuarios
que estavam acessando a base.

@author Renato Castro
@since 21/11/2014

/*/
User Function MT100AGR()
	
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_MUL) 
		if !(Inclui) .and. !(Altera)
			FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "1-entrou no p.e. MT100AGR", 0, 0, {})
			if existBlock("EstorClass")
				if !(isincallstack("u_EstorClass"))
					begin transaction
						processa({|| u_EstorClass()},"Aguarde...", "Verificando / estornando NF´s de cobertura...")
					end transaction
				endif
			endif
		endif
	endif
	
	if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS 
		if !(Inclui) .and. !(Altera)
			FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "2-entrou no p.e. MT100AGR", 0, 0, {})
			if existBlock("DisEstorClass")
				if !(isincallstack("u_DisEstorClass"))
					begin transaction
						If _lAvanca
							processa({|| u_DisEstorClass()},"Aguarde...", "Verificando / estornando NF´s de cobertura...")
						EndIf
					end transaction
				endif
			endif
		endif
	endif
	
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_AGE) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_AG2)
		if !(Inclui) .and. !(Altera)
			FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "3-entrou no p.e. MT100AGR", 0, 0, {})
			if existBlock("AgeEstorClass")
				if !(isincallstack("u_AgeEstorClass"))
					begin transaction
						processa({|| u_AgeEstorClass()},"Aguarde...", "Verificando / estornando NF´s de cobertura...")
					end transaction
				endif
			endif
		endif
	endif
	
	if(FWUnitBusiness() == DHL_BUSINESSUNIT_AGL .and. !isRepair(SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_TIPO))
		if !(Inclui) .and. !(Altera)
			FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "3-entrou no p.e. MT100AGR", 0, 0, {})
			if existBlock("AglEstorClass")
				if !(isincallstack("u_AglEstorClass"))
					begin transaction
						processa({|| u_AglEstorClass()},"Aguarde...", "Verificando / estornando NF´s de cobertura...")
					end transaction
				endif
			endif
		endif
	endif
	
return

/**
* Verifica se o depositante é do tipo Reparador
**/
static function isRepair(cClieFor,cLoja,cTipo)
	
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local lRet	 	:= .f.
	
	if AllTrim(cTipo) $ "D/B"
		oSqlUtil:newTable("SA1", "A1_COD, A1_LOJA, A1_ZZREPAR", "A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '" + cClieFor + "' AND A1_LOJA = '" + cLoja + "' ")
		if oSqlUtil:hasRecords()
			if oSqlUtil:getValue("A1_ZZREPAR") == "S"
				lRet := .t.
			endIf
		endIf
	else
		oSqlUtil:newTable("SA2", "A2_COD, A2_LOJA, A2_ZZREPAR", "A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = '" + cClieFor + "' AND A2_LOJA = '" + cLoja + "' ")
		if oSqlUtil:hasRecords()
			if oSqlUtil:getValue("A2_ZZREPAR") == "S"
				lRet := .t.
			endIf
		endIf
	endIf
	oSqlUtil:close()
	
return lRet
