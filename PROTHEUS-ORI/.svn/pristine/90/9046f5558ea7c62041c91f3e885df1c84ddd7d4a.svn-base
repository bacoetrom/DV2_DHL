#include 'totvs.ch'
#include 'safx2013.ch'
#include 'safx.ch'


/*/{Protheus.doc} DHLSafx2013

Responsavel pelas regras e montagem das informções para a exportação
	
@author Daniel Braga
@since 30/10/2014

/*/
user function _Saf2013;return

class DHLSafx2013 from DHLSafx

	method newDHLSafx2013() constructor
	method addLine()
	method getClasItem()
	method validateExport()
	method notFieldRequired()

endclass

//-----------------------------------------------------------------
method newDHLSafx2013() class DHLSafx2013

return


/*/{Protheus.doc} addLine

Cria a lina ‡ ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine() class DHLSafx2013
	
	local oDhlLib := DHLLibrary():newDHLLibrary()	
	 
	::addField(IND_PRODUTO			, ::getProdType(::getFieldValue("B1_TIPO")))
    ::addField(COD_PRODUTO			, ::getFieldValue("B1_COD"))
    ::addField(DATA_PRODUTO			, oDhlLib:getLGDate(::getFieldValue("B1_USERLGI"), .T.))  
    ::addField(DESCRICAO			, ::getFieldValue("B1_DESC"))
    ::addField(COD_NBM				, ::getFieldValue("B1_POSIPI"))
    ::addField(COD_NCM				, getNcm(::getFieldValue("B1_POSIPI")))
    ::addField(COD_NALADI			, ::getFieldValue("B1_NASLSH"))
    ::addField(IND_REGIDO_SUBST		, Iif(!Empty(::getFieldValue("B1_PICMRET")) ,"S","" ))
    ::addField(IND_CONTROLE_SELO	, Iif(!Empty(::getFieldValue("B1_BVLRSELO")) , "S",""))
    ::addField(COD_MEDIDA			, ::getFieldValue("B1_UM"))
    ::addField(COD_GRUPO_PROD		, ::getFieldValue("B1_GRUPO"))
    ::addField(COD_CONTA			, ::getFieldValue("B1_ZZCONTA"))
    ::addField(COD_UND_PADRAO		, ::getFieldValue("B1_UM"))
    ::addField(VLR_PESO_UNIT_KG		, ::getFieldValue("B1_PESO"))
    ::addField(DESCR_DETALHADA		, Posicione("SB5", 1, xFilial("SB5")+::getFields()[COD_PRODUTO[1]], "B5_CEME"))
    ::addField(FATOR_CONVERSAO		, "")
    ::addField(ORIGEM				, getOrigem(::getFieldValue("B1_ORIGEM")))
    ::addField(IND_INCID_PIS		, ::getFieldValue("B1_PPIS"))
    ::addField(ALIQ_PIS				, ::getFieldValue("B1_PPIS"))
    ::addField(IND_INCID_COFINS		, ::getFieldValue("B1_PCOFINS"))
    ::addField(ALIQ_COFINS			, ::getFieldValue("B1_PCOFINS"))
    ::addField(IND_FUNRURAL			, ::getFieldValue("B1_CONTSOC"))
    ::addField(IND_PRD_INCENTIV		, ::getFieldValue("B1_CRDEST"))
    ::addField(CAPAC_VOLUM			, "")
    ::addField(ESPECIE_DNF			, "")
    ::addField(CLAS_ITEM			, ::getClasItem(::getFieldValue("B1_TIPO")))  
    ::addField(COD_BARRAS			, ::getFieldValue("B1_CODBAR"))
    ::addField(CEST					, ::getFieldValue("B1_CEST"))
    
    ::notFieldRequired()
    	
return
	
/**
 * Coleta o Codigo NCM	 
 */
static function getNcm(cPosIpi)
	
	local cNcm := ""
	
	cNcm := AllTrim(cPosIpi)
	cNcm := StrTran(cNcm, ".", "")
	cNcm := StrTran(cNcm, " ", "")
	cNcm := StrTran(cNcm, "-", "")
	cNcm := StrTran(cNcm, ",", "")
	
return cNcm

/**
 * Coleta a Origem do Produto
 */	
static function getOrigem(cCodOrigem)
	
	local cRet := ""
	
	cCodOrigem := AllTrim(cCodOrigem)
	
	if (cCodOrigem $ "0,3,4,5,")
		cRet := SAFX2013_ORIGEM_NACIONAL
	elseIf (cCodOrigem $ "1,2,6,7")
		cRet := SAFX2013_ORIGEM_IMPORTADO
	endIf
	
return cRet
	
	
/*/{Protheus.doc} getClasItem

(Descricao da Funcao, Classe ou Metodo)
	
@author Daniel Braga
@since 30/10/2014

@param cValue, string, valor ‡ ser pesquisado

@return string codigo do classific‹o da dhl
/*/

method getClasItem(cValue)  class DHLSafx2013
	
	local aClasItem := REGRA_CLASS_ITEM
	local nPos		  := 0
	
	nPos := aScan(aClasItem,{|x| x[1] == allTrim(cValue)})
	if  nPos > 0
		return aClasItem[nPos,2]
	endIf
return "99"

/*/{Protheus.doc} validateExport

(Descricao da Funcao, Classe ou Metodo)
	
@author Daniel Braga
@since 30/10/2014


@return logico validacao da regra
/*/

method validateExport() class DHLSafx2013 
	
	local lExport  := .T.
	local lInJob   := Type("oMainWnd") != "O"
	local oDhlLib  :=  DHLLibrary():newDHLLibrary()
	local dLogData :=  oDhlLib:getLGDate(::getFieldValue("B1_USERLGA"))
	
	if lInJob
		lExport := Empty(::getFieldValue("B1_ZZMSDW") )  .or. ::getFieldValue("B1_ZZMSDW") < dLogData
	endIf
	
return lExport

/*/{Protheus.doc} notFieldRequired

Campos que não precisa passar valor
	
@author Daniel Braga
@since 13/11/2014

/*/
method notFieldRequired() class DHLSafx2013

    ::addField(GRUPO_SELO, ' ')
    ::addField(SUB_GRUPO_SELO, ' ')
    ::addField(COR_SELO, ' ')
    ::addField(SERIE_SELO, ' ')
    ::addField(COD_GRP_INCENT, ' ')
    ::addField(COD_GRUPO_ST, ' ')
    ::addField(IND_INCID_ICMS_SER, ' ')
    ::addField(IND_FABRIC_ESTAB, ' ')
    ::addField(IND_CLASSIF_ICMSS, ' ')
    ::addField(DSC_MODELO, ' ')
    ::addField(COD_GRP_PROD, ' ')
    ::addField(IND_PETR_ENERG, ' ')
    ::addField(IND_ICMS_DIFERIDO, ' ')
    ::addField(COD_ANP, ' ')
    ::addField(IND_ANT_PROD, ' ')
    ::addField(COD_ANT_ITEM, ' ')
    ::addField(DAT_ALT_CODIGO, ' ')
    ::addField(CLAS_ENQUAD_IPI, ' ')
    ::addField(MATERIAL_RESULT_PERDA, ' ')
    ::addField(DSC_FINALIDADE, ' ')
    ::addField(QTD_CAP_MAX_ARMAZ, ' ')
    ::addField(IND_ATIVO_SAICS, ' ')
    ::addField(IND_TAB_INCIDENCIA, ' ')
    ::addField(COD_GRUPO, ' ')
    ::addField(MARCA_COMERCIAL, ' ')
    ::addField(IND_CARAC_PRODUTO , ' ')


return

