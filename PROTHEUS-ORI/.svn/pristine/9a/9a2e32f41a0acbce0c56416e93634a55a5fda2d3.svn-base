#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} MT216FIL
Utilização de Filtro em tabelas diversas - Refaz Poder de Terceiros
@type function
@author Thiago Meschiatti
@since 12/01/2018
@version 1.0
/*/
User Function MT216FIL()
	Local aFiltro := {}
	Local cDoc	  := ""
	Local cSerie  := ""
	
	If FunName()=="MATA461"
	
		aFiltro := {}
		cDoc	:= SF2->F2_DOC
		cSerie  := SF2->F2_SERIE
	
		aAdd(aFiltro,"") //-- Filtro adicional na tabela SB2
		aAdd(aFiltro,"") //-- Filtro adicional na tabela SB6
		aAdd(aFiltro,"") //-- Filtro adicional na tabela SD1
		aAdd(aFiltro,"D2_DOC = '"+cDoc+"' AND D2_SERIE = '" + cSerie + "'") //-- Filtro adicional na tabela SD2
		aAdd(aFiltro,"") //-- Filtro adicional na tabela SC6
		
	ElseIf FunName()=="MATA216"
	
		If FwUnitBusiness() == DHL_BUSINESSUNIT_AG2
			aAdd(aFiltro, "") //-- Filtro adicional na tabela SB2
			aAdd(aFiltro, "") //-- Filtro adicional na tabela SB6
			aAdd(aFiltro, "") //-- Filtro adicional na tabela SD1
			aAdd(aFiltro, "D2_ZZMODIF <> 'X' AND D2_ZZMODIF <> 'V'") //-- Filtro adicional na tabela SD2
			aAdd(aFiltro, "") //-- Filtro adicional na tabela SC6
		EndIf
	
	EndIf
	
Return (aFiltro)

