#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} ProcTaxes
Processamento de gravação de valores de impostos na gravação da Pré-Nota Fiscal de Entrada

@type User Function
@author Thiago Meschiatti
@since 06/04/2016
@version 1.0
/*/
User Function ProcTaxes(aItem, oDetItem, aInfProd)
	local oTax		:= DHLTaxes():newDHLTaxes(oDetItem)
	local nTotal	:= 0
	local nIcms		:= 0
	local nIpi		:= 0
	local nIBSUF	:= 0
	local nIBSMUN	:= 0
	local nCBS		:= 0
	local cProduto	:= ""	
	
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		nTotal	:= val(oTax:getTotal()) / val(oTax:getQuant())
		nIcms	:= val(oTax:getIcms()) / val(oTax:getQuant())
		nIpi	:= val(oTax:getIpi()) / val(oTax:getQuant())
		nIBSUF	:= val(oTax:getIBSUF()) / val(oTax:getQuant())
		nIBSMUN	:= val(oTax:getIBSMUN()) / val(oTax:getQuant())
		nCBS	:= val(oTax:getCBS()) / val(oTax:getQuant())
	else
		//Inicio Gustavo Luiz - FSW Totvs IP 13/02/2019
		cProduto := aInfProd[3]
		if isProdutLote(cProduto)	
			nTotal	:= aInfProd[8]
		else
			//if cFilAnt == BAYER //iNIBIDO POR EMERSON HOLANDA 31/07/24 PARA SEMPRE PREENCHER COM ESSE VALOR PARA TODAS AS FILIAIS
				nTotal	:= aInfProd[8]
			//endIf
		endif
		//Fim Gustavo Luiz - FSW Totvs IP 13/02/2019
		nIcms	:= val(oTax:getIcms())
		nIpi	:= val(oTax:getIpi()) 	  
		nIBSUF	:= val(oTax:getIBSUF()) 
		nIBSMUN	:= val(oTax:getIBSMUN()) 
		nCBS	:= val(oTax:getCBS()) 
		//nCBS	:= val(oTax:getCBS())
	endif
	
	
	aadd(aItem,{"D1_ZZTOTAL" 	, nTotal	,Nil})
	aadd(aItem,{"D1_ZZVLICM" 	, nIcms		,Nil})
	aadd(aItem,{"D1_ZZVLIPI" 	, nIpi		,Nil})
	//aadd(aItem,{"D1_ZZIBSUF" 	, nIBSUF		,Nil})
	//aadd(aItem,{"D1_ZZIBSMU" 	, nIBSMUN		,Nil})
	//aadd(aItem,{"D1_ZZVLCBS" 	, nCBS		,Nil})

Return aClone(aItem)

/**
* Retorna se o produto controla lote
**/
static function isProdutLote(cCodProd) 
	
	local lIsProdlote	:= .F.
	local aArea 		:= getArea()
	local aAreaSB1 		:= SB1->(getArea())
	local cChaveSB1		:= ""
	
	cCodProd := padr(cCodProd, tamSx3("B1_COD")[1], "")
	cChaveSB1:= fwxFilial("SB1") + cCodProd
	
	SB1->(dbSetOrder(1))
	
	if SB1->(dbSeek(cChaveSB1))
		if SB1->B1_RASTRO = "L"
			lIsProdlote := .T.
		endif
	endIf
	
	restArea(aAreaSB1)
	restArea(aArea)
	
return lIsProdlote

