#Include 'Protheus.ch'


/*/{Protheus.doc} MT340D3

 O ponto se encontra logo após a geração de movimento no SD3 para acerto do inventário. A tabela SD3 ainda está com lock de registro.
	
@author Gustavo Luiz
@since 26/12/2018

/*/
User Function MT340D3()
	
	local aArea := getArea()
	local aAreaSB7 := SB7->(getArea())
	local aAreaSD3 := SD3->(getArea())
		
		gravDadosD3()
		
	restArea(aAreaSD3)
	restArea(aAreaSB7)
	restArea(aAreaSD3)
	
Return

/** 
* Grava os dados B7_ZZCDPRO e B7_ZZLJPRO para a tabela SD3 campos D3_ZZCDPRO e D3_ZZLJPRO
**/
static function gravDadosD3()
	
	local aArea 		:= getArea()
	local aAreaSB7 		:= SB7->(getArea())
	local aAreaSD3 		:= SD3->(getArea())
	local cCodD3   		:= SD3->D3_COD
	local cLoteD3  		:= SD3->D3_LOTECTL
	local dDataEmisD3  	:= SD3->D3_EMISSAO	
	local nQtdRegB7		:= 0
	local cAliasB7		:= getAliasB7(@nQtdRegB7)	
	
	if cAliasB7 != nil
		if !empty((cAliasB7)->B7_ZZCDPRO) .and. !empty((cAliasB7)->B7_ZZLJPRO)
			SD3->D3_ZZCDPRO := (cAliasB7)->B7_ZZCDPRO
			SD3->D3_ZZLJPRO := (cAliasB7)->B7_ZZLJPRO
		endIf	
		
		(cAliasB7)->(dbCloseArea())
			
	endIf
		
	restArea(aAreaSD3)
	restArea(aAreaSB7)
	restArea(aArea)
	
return

/** 
* Executa a query na SB7
**/
static function getAliasB7(nQtdRegs)
	
	local cQuery 		:= ""
	local cCodD3   		:= SD3->D3_COD
	local cLoteD3  		:= SD3->D3_LOTECTL
	local dDataEmisD3  	:= SD3->D3_EMISSAO	
	local cAlias		:= getNextAlias()
	local nQtdRegs		:= 0
	
	cQuery := " SELECT " 													+ CRLF
	cQuery += "  * " 														+ CRLF
	cQuery += "  FROM " + retSqlName("SB7") + " SB7" 						+ CRLF
	cQuery += "  WHERE 1 = 1" 												+ CRLF
	cQuery += "     AND SB7.B7_FILIAL = '"+ fwxFilial("SB7") +"'" 			+ CRLF
	cQuery += "     AND SB7.B7_COD = '"+ cCodD3 +"'" 						+ CRLF
	cQuery += "     AND SB7.B7_LOTECTL = '"+ cLoteD3 +"'" 					+ CRLF
	cQuery += "     AND SB7.B7_DATA = '"+ dTos(dDataEmisD3) +"'" 		+ CRLF
	cQuery += "     AND SB7.D_E_L_E_T_ = ' '" 								+ CRLF
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)	
	
	count To nQtdRegs
	
	if nQtdRegs > 0
		(cAlias)->(dbGoTop())
	else
		cAlias := nil
	endIf
	
return cAlias

