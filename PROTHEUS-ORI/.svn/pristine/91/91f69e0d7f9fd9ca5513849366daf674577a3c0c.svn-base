#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} IPNFELOTE

PE executado para cada item do XML, permitindo que seja alimentado o campo Lote

@author Diego de Angelo
@since 06/06/2016
@type function
@param PARAMIXB[1], objeto, Informações do emitente
@param PARAMIXB[2], objeto, Informações completa do item da NF.
@param PARAMIXB[3], variável, Corresponde a iteração do rastro.
@param PARAMIXB[4], variável, Indica se possui rastro

@return string número do lote que será gravado
/*/
User Function IPNFELOTE()

	local cLote			:= ""
	local nQtdRastro	:= 0
	local nI			:= 0
	local nJ			:= 1 
	private oDetItem 	:= PARAMIXB[2]
	
	if PARAMIXB[3] != nil
		nJ := PARAMIXB[3]
	endIf
	
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_DIS) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_MUL) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_AGE) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_AGL)
		if type("oDetItem:_PROD:_MED:_NLOTE") != "U"
			cLote	:= oDetItem:_PROD:_MED:_NLOTE:text
		endif
		
		//Tratativa para 4.0
		if Empty(cLote)
		
			//if type("oDetItem:_PROD:_RASTRO:_NLOTE") != "U"
				//cLote	:= oDetItem:_PROD:_RASTRO:_NLOTE:text
			//endif	
			
			//Flexibiliza caso tenha vários rastros dentro de um único SKU - **Gustavo Luiz** 11/09/2018
			if type("oDetItem:_PROD:_RASTRO") == "O"
				cLote	:= oDetItem:_PROD:_RASTRO:_NLOTE:text
			elseIf type("oDetItem:_PROD:_RASTRO") == "A"
				cLote := oDetItem:_PROD:_RASTRO[nJ]:_NLOTE:text
			endif
					
		endif
		
	endIf
 
Return cLote

