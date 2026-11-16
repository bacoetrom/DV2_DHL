#Include 'Protheus.ch'
#Include 'DHL.ch'


/*/{Protheus.doc} IPNFEALTITEM

Ponto de Entrada para manipulação do array de itens da NF.
	
@author Thiago Meschiatti
@since 31/10/2014

@param PARAMIXB[1], array, Itens do pedido de venda

@return array, Array com os itens alterados.
/*/
User Function IPNFEALTITEM()
	local aItens	  	:= PARAMIXB[1]  
	Local oInfAd	 	:= PARAMIXB[2] //Acrescentado por Edson Deluca - FIT Gestão - Projeto Automação Braskem - 12/07/2018				
	local aRet			:= {}

	private lNewAge       := SuperGetMV("ZZ_NEWAGE",,.F.) //adicionado por Edson Deluca - FIT Gestão	
	private lAutomatic    := SuperGetMV("ZZ_AUTOMAT",,.F.) //adicionado por Edson Deluca - FIT Gestão	
	
	if FWUnitBusiness() == 'SPL'
		aRet	:= u_ProcDesNF(aItens)
	elseIf FWUnitBusiness() == DHL_BUSINESSUNIT_DIS
		aRet	:= u_ProcPcProt(aItens)	
	else
	    If (FWUnitBusiness() == DHL_BUSINESSUNIT_AGE)//adicionado por Edson Deluca - FIT Gestão 
	       If lNewAge .And. lAutomatic	//adicionado por Edson Deluca - FIT Gestão 
		      If SB1->B1_RASTRO = "L"
		      	aRet	:= u_ESTM001(aItens,oInfAd:_INFCPL:Text) //adicionado por Edson Deluca - FIT Gestão		      	 
		      Else
		      	aRet	:= aItens
		      EndIf	
		   Else //adicionado por Edson Deluca - FIT Gestão
		      aRet	:= aItens
		   EndIf //adicionado por Edson Deluca - FIT Gestão 
		Else //adicionado por Edson Deluca - FIT Gestão 
	      aRet	:= aItens //adicionado por Edson Deluca - FIT Gestão 
		EndIf //adicionado por Edson Deluca - FIT Gestão
		
		if oImpNfeAux:getModeSimula()
			oImpNfeAux:lAuto := .t.
		endif
	endif

Return (aRet)
