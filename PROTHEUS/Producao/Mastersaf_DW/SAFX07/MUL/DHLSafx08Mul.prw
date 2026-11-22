#include 'protheus.ch'
#include 'dhl.ch'
#include 'safx08.ch'
#include 'safx.ch'

#DEFINE POS_FIELD 1


/*/{Protheus.doc} DHLSafx08Mul

Respons‡vel pelas regras e montagem das informacoes para a exportacao
	
@author Daniel Braga / Thiago Meschiatti
@since 30/10/2014 - 13/02/2017

/*/

user function _Safx08Mul;return

class DHLSafx08Mul from DHLSafx
	
	data  cPrefix  as String
	data  cItem  as String 
	
	method newDHLSafx08Mul() constructor 
	
	method getSql()
	method getSqlFt()
	method addLine() 
	method getTribIcms(aTypeFlow)
	method getTribIpi(aTax)
	method getAuxTribIcms(aTax)
	method getValorOpIcms(aTax) 
	method getIpiValorOp(aTax) 
	method notFieldRequired()
	
	method setPrefix()
	method getPrefix()
	
	method setItem()
	method getItem()
	
	method getCofins(cField)
	method getPis(cField)

endclass

method setPrefix(cPrefix) class DHLSafx08Mul
	::cPrefix := cPrefix
return 

method getPrefix() class DHLSafx08Mul
return ::cPrefix

method setItem(cItem) class DHLSafx08Mul
	::cItem := cItem
return 

method getItem() class DHLSafx08Mul
return ::cItem

method newDHLSafx08Mul() class DHLSafx08Mul	
	
return

/*/{Protheus.doc} getSql

Instrucao SQL para exportacao
	
@author Daniel Braga
@since 30/10/2014

@return string instrucao sql
/*/
method getSql() class DHLSafx08Mul


	local cAlias	:= ""
	local cQuery	:= ""
	local cCusSup	:= ::getFieldValue("F3_CLIEFOR")
	local cBranch	:= ::getFieldValue("F3_LOJA")                          
	local cDoc		:= ::getFieldValue("F3_NFISCAL")                            
	local cSer		:= ::getFieldValue("F3_SERIE")                       
	local cType		:= ::getTypeDoc(cDoc, cSer,cCusSup,cBranch)                                                       
	                                            
	cAlias := Iif(cType == "1" ,"SD1" ,"SD2" )
	::cPrefix:= PrefixoCpo(cAlias)
	
	cQuery :=  "select * from "+retSqlName(cAlias)+" where "
	cQuery	+=  ::cPrefix+"_filial= '"+xFilial(cAlias)+"' and "
	cQuery +=  ::cPrefix+"_doc		='"+cDoc+"' and "
	cQuery +=  ::cPrefix+"_serie 	='"+cSer+"' and "
	cQuery +=  ::cPrefix+"_"+Iif(cType == "1" ,"fornece" ,"cliente" )+" = '"+cCusSup+"' and  "
	cQuery +=  ::cPrefix+"_loja = '"+cBranch+"' and "
	cQuery +=  "d_e_l_e_t_= ' ' "
	 
return Upper(cQuery)

/*/{Protheus.doc} getSqlFt

Instrucao SQL para exportacao
	
@author Daniel Braga
@since 30/10/2014

@return string instrucao sql
/*/
method getSqlFt() class DHLSafx08Mul


	local cAlias	:= ""
	local cQuery	:= ""
	local cCusSup	:= ::getFieldValue("F3_CLIEFOR")
	local cBranch	:= ::getFieldValue("F3_LOJA")                          
	local cDoc		:= ::getFieldValue("F3_NFISCAL")                            
	local cSer		:= ::getFieldValue("F3_SERIE")                       
	local cType		:= ::getTypeDoc(cDoc, cSer,cCusSup,cBranch)                                                       
	                                            
	cAlias := "SFT"
	::cPrefix:= PrefixoCpo(cAlias)
	
	cQuery :=  "select * from "+retSqlName(cAlias)+" where "
	cQuery	+=  ::cPrefix+"_filial= '"+xFilial(cAlias)+"' and "
	cQuery +=  ::cPrefix+"_nfiscal	= '"+cDoc+"' and "
	cQuery +=  ::cPrefix+"_serie 	= '"+cSer+"' and "
	cQuery +=  ::cPrefix+"_cliefor  = '"+cCusSup+"' and  "
	cQuery +=  ::cPrefix+"_loja 	= '"+cBranch+"' and "
	cQuery +=  "d_e_l_e_t_= ' ' "
	 
return Upper(cQuery)

/*/{Protheus.doc} addLine

Cria a lina ‡ ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine(cItenOri, cId, lIdRef) class DHLSafx08Mul
	
	
	local aTax		   	:= {}
	local aInOutFlows  	:= {}
	local aItFlow	   	:= {}
	local aDocImp	   	:= {}
	local aTypeFlow	   	:= {}
	local aElectrPower	:= {}
	local aProduct		:= {}
	local aSupCus		:= {}
	local aUFTaxes		:= {}
	local cType			:= ""
	local cCod		   	:= "" 
	local cBranch	   	:= ""
	local cDoc			:= ""
	local cSer			:= ""	
	local cItem			:= ""
	local lFormatZero	:= .f.
	local cConta		:= ""
	local cCBENEF		:= ""
	local nICMDeson		:= 0
	
	if !empty(::aFields)
	
		cCod 		:= ::getFieldValue("F3_CLIEFOR")
		cBranch 	:= ::getFieldValue("F3_LOJA")
		cDoc		:= ::getFieldValue("F3_NFISCAL")
		cSer    	:= ::getFieldValue("F3_SERIE")
		cItem 		:= ::getFieldValue(::cPrefix+"_ITEM")
		cType		:= ::getTypeDoc(cDoc, cSer, cCod, cBranch) 
		
		cIndFisJur := ::indFisJurPorTipo(cType, ::getFieldValue("F3_TIPO"))   // INICIO Pablo Regis 18/11/2026 - centralizado na classe base
		
		aSupCus 		:=  ::getSupCusRecords(cIndFisJur,cCod,cBranch)
		aTax    		:= 	::getTaxRecord(cType  ,cDoc, cSer,cCod,cBranch,cItem)
		aInOutFlows 	:= 	::getFlowsRecord(cType,cDoc, cSer,cCod,cBranch)
		aItFlow			:=	::getItemFlowsRecord(cType,cDoc,cSer,cCod,cBranch,cItem)
		aDocImp			:= 	::getImportAdd(cDoc,cSer,cCod,cBranch,cItem)	
		aTypeFlow		:= 	::gettypeInOutFlow(iif(cType =="1", ::getFieldValue("D1_TES",aItFlow), ::getFieldValue("D2_TES",aItFlow))) 
		aElectrPower	:= 	::getEletricPower(cType,cDoc,cSer,cCod,cBranch)
		aProduct 		:=	::getProduct(::getFieldValue(::cPrefix+"_PRODUTO"))
		aUFTaxes		:= ::getUfTaxes(cType, ::getFieldValue("F3_TIPO"), cSer, cDoc, cCod, cBranch, cItem)
	
	   	if cType == "1"
	   		cConta := ::getFieldValue(::cPrefix+"_CONTA")
	   	else
	   		cConta := ::getFieldValue(::cPrefix+"_CONTA")
	   		cConta := sfconta( cConta , ::getFieldValue("F3_NFISCAL") , ::getFieldValue("F3_SERIE") , ::getFieldValue(::cPrefix+"_TOTAL") , ::getFieldValue(::cPrefix+"_CFOP") , ::getFieldValue("F3_EMISSAO") )
	   		// conta , nfiscal , serie , total , cfop , emissao 
	   	endif
	
		
		::addField(COD_EMPRESA			, alltrim(GetNewPar("ZZ_IDEMPDW", "SOL")) )
	    ::addField(COD_ESTAB			, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())))
	    ::addField(DATA_FISCAL			, IIf(cType == "1",::getFieldValue("F3_ENTRADA"), ::getFieldValue("F3_EMISSAO")))
	    // ::addField(MOVTO_E_S			, iif(cType =="1", SAFX_DOCUMENTO_ENTRADA, SAFX_DOCUMENTO_SAIDA))
	    ::addField(MOVTO_E_S			, iif(cType == "1" .AND. alltrim(::getFieldValue("F3_CFO")) $ alltrim(GetNewPar("ZZ_CFOSFX7")),SAFX_DOC_EMIT_ESTABELEC,iif(cType == "1" , SAFX_DOCUMENTO_ENTRADA, SAFX_DOCUMENTO_SAIDA)))
	    ::addField(NORM_DEV				, ::getFieldValue("TIPO") )
	    ::addField(COD_DOCTO			, "NFE")
	    ::addField(IND_FIS_JUR			, Iif(cIndFisJur == "1",::getFieldValue("A2_ZZINDDW",aSupCus), ::getFieldValue("A1_ZZINDDW",aSupCus)))
	    ::addField(COD_FIS_JUR			, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp()))+cCod+cBranch)
	    ::addField(NUM_DOCFIS			, ::getFieldValue("F3_NFISCAL") )
	    ::addField(SERIE_DOCFIS			, ::getFieldValue("F3_SERIE") )
	    ::addField(IND_BEM_PATR			, "N")
	    ::addField(IND_PRODUTO			, ::getProdType(::getFieldValue("B1_TIPO",aProduct)) )
	    ::addField(COD_PRODUTO			, ::getFieldValue(::cPrefix+"_PRODUTO"))
		::addField(COD_UND_PADRAO		, iif((cType == "1" .and. ::getFieldValue("F1_FORMUL", aInOutFlows) == "S") .or. (cType == "2"),;
										  unidadeMedida(COD_UND_PADRAO[POS_FIELD], cType, aItFlow, self),;
										  ::getFieldValue("B1_UM", aProduct) ))
	    ::addField(NUM_ITEM				, iif(cType == "1",alltrim(padl(::getItem(),tamsx3("D1_ITEM")[1],'0')),alltrim(cItem)))
	    ::addField(COD_ALMOX			, ::getFieldValue("B1_LOCPAD", aProduct))
	    ::addField(COD_CUSTO			, Iif(cType == "1", ::getFieldValue("D1_CC", aItFlow) ,::getFieldValue("D2_CCUSTO", aItFlow) ) )
	    ::addField(COD_CFO				, ::getFieldValue(::cPrefix+"_CFOP"))
	    ::addField(COD_NATUREZA_OP		, ::getFieldValue(::cPrefix+"_NATOPER"))
	    ::addField(QUANTIDADE			, iif((cType == "1" .and. ::getFieldValue("F1_FORMUL", aInOutFlows) == "S") .or. (cType == "2"),;
	    								  unidadeMedida(QUANTIDADE[POS_FIELD], cType, aItFlow, self),;
	    								  ::getFieldValue(::cPrefix+"_QUANT")))
		::addField(COD_MEDIDA			, iif((cType == "1" .and. ::getFieldValue("F1_FORMUL", aInOutFlows) == "S") .or. (cType == "2"),;
										  unidadeMedida(COD_MEDIDA[POS_FIELD], cType, aItFlow, self),;
										  ::getFieldValue("B1_UM", aProduct)))
	    ::addField(COD_NBM				, ::getFieldValue("B1_POSIPI",aProduct) )
		::addField(VLR_UNIT				, iif((cType == "1" .and. ::getFieldValue("F1_FORMUL", aInOutFlows) == "S") .or. (cType == "2"),;
										  unidadeMedida(VLR_UNIT[POS_FIELD], cType, aItFlow, self),;
										  ::getFieldValue(::cPrefix+"_PRCUNIT")))
	    ::addField(VLR_ITEM				, ::getFieldValue(::cPrefix+"_TOTAL"))
	    ::addField(VLR_DESCONTO			, ::getFieldValue(::cPrefix+"_DESCONT"))
	    ::addField(COD_SITUACAO_A		, left(::getFieldValue(::cPrefix+"_CLASFIS"),1))
	    ::addField(COD_SITUACAO_B		, substr(::getFieldValue(::cPrefix+"_CLASFIS"),2,2))
	    ::addField(IND_IPI_INCLUSO		, Iif(::getFieldValue("F4_INCIDE",aTypeFlow) == 'S' , 'S', 'N'))
	    ::addField(NUM_ROMANEIO			, Iif(cType =="2" ,::getFieldValue("D2_CODROM", aItFlow),"" )) 
	    ::addField(DATA_ROMANEIO		, Iif(cType =="2" ,posicione("NPR",1,xFilial("NPR")+::getFieldValue("D2_CODROM", aItFlow),"NPR_DATA"),"" ))
	    ::addField(PESO_LIQUIDO			, ::getFieldValue(::cPrefix+"_PESO"))
	    ::addField(VLR_FRETE			, ::getFieldValue(::cPrefix+"_FRETE"))
	    ::addField(VLR_SEGURO			, ::getFieldValue(::cPrefix+"_SEGURO"))
	    ::addField(VLR_OUTRAS			, ::getFieldValue(::cPrefix+"_DESPESA"))
	    ::addField(VLR_ALIQ_ICMS		, ::getFieldValue(::cPrefix+"_ALIQICM"))
	    ::addField(VLR_ICMS				, ::getFieldValue(::cPrefix+"_VALICM "), lFormatZero)
	    ::addField(DIF_ALIQ_ICMS		, Iif(cType == "1",(::getFieldValue(::cPrefix+"_ICMSCOM")/::getFieldValue(::cPrefix+"_BASEICM"))/100, 0  ))
	    ::addField(VLR_ALIQ_IPI			, ::getFieldValue(::cPrefix+"_ALIPIPI") )
	    ::addField(VLR_IPI				, ::getFieldValue("F3_VALIPI") )
	    ::addField(VLR_ALIQ_SUB_ICMS	, ' ')
	    ::addField(VLR_SUBST_ICMS		, ' ')
	    ::addField(TRIB_ICMS			, ::getTribIcms(aTypeFlow)) 
	    ::addField(BASE_ICMS			, iif(::getTribIcms(aTypeFlow)== '1', ::getFieldValue(::cPrefix+"_BASEICM"), iif(::getTribIcms(aTypeFlow)== '2', ::getFieldValue(::cPrefix+"_ISENICM"), ::getFieldValue(::cPrefix+"_OUTRICM"))))
	    ::addField(BASE_REDU_ICMS		, Iif(::getFieldValue("F4_BASEICM",aTypeFlow) <> 0,::getFieldValue("F3_BASEICM"), 0 ))
	    ::addField(TRIB_IPI			, ::getTribIpi(aTax))
	    ::addField(BASE_IPI			, iif(::getTribIpi(aTax)== '1', ::getFieldValue(::cPrefix+"_BASEIPI"), iif(::getTribIpi(aTax)== '2', ::getFieldValue(::cPrefix+"_ISENIPI"), ::getFieldValue(::cPrefix+"_OUTRIPI"))))
	    ::addField(BASE_REDU_IPI		, Iif(::getFieldValue("F4_BASEIPI",aTypeFlow) <> 0,::getFieldValue("F3_BASEIPI"), 0 ))
	    ::addField(BASE_SUB_TRIB_ICMS 	, ::getFieldValue(::cPrefix+"_BRICMS"))
	    ::addField(VLR_CONTAB_ITEM		, ::getFieldValue(::cPrefix+"_VALCONT"))	    
	    ::addField(VLR_OUTROS_IPI		, ::getFieldValue(::cPrefix+"_IPIOBS"))	    
	    ::addField(VLR_OUTROS1			, Iif(cType == "1" , ::getFieldValue(::cPrefix+"_ICMSCOM"),"")) 
	    ::addField(VLR_TOM_SERVICO		, ::getFieldValue(::cPrefix+"_FRETE"))   
	    ::addField(VLR_IPI_NDESTAC		, ::getFieldValue(::cPrefix+"_ALIQIPI")) 
	    ::addField(TRIB_ICMS_AUX		, ' ') 
	    ::addField(BASE_ICMS_AUX		, ' ') 
 	    ::addField(TRIB_IPI_AUX		, ' ') 
	    ::addField(BASE_IPI_AUX		, ' ')  
 	    ::addField(VLR_BASE_PIS		, ::getPis(VLR_BASE_PIS[POS_FIELD]) ) 
	    ::addField(VLR_PIS				, ::getPis(VLR_PIS[POS_FIELD]) )	
	    ::addField(VLR_BASE_COFINS		, ::getCofins(VLR_BASE_COFINS[POS_FIELD]) )
	    ::addField(VLR_COFINS			, ::getCofins(VLR_COFINS[POS_FIELD]))	    
	    ::addField(VLR_CUSTO_TRANSF		, ' ') 
	    ::addField(DAT_DI				, ::getFieldValue("CD5_DTDI", aDocImp))
	    ::addField(NUM_DEC_IMP_REF		, ::getFieldValue("CD5_DOCIMP", aDocImp))
	    ::addField(COD_CONTA			, cconta ) //::getFieldValue(::cPrefix+"_CONTA")) 	    
	    ::addField(IND_MOV_FIS			, ::getFieldValue(::cPrefix+"_ESTOQUE"))
	    ::addField(NUM_DOCFIS_REF		, ::getFieldValue(::cPrefix+"_NFORI"))
	    ::addField(SERIE_DOCFIS_REF		, ::getFieldValue(::cPrefix+"_SERORI"))
	    ::addField(VLR_BASE_PIS_ST		, ::getFieldValue("F3_BASEPS3") )
	    ::addField(VLR_ALIQ_PIS_ST		, ::getFieldValue("F3_ALIQPS3") )
	    ::addField(VLR_PIS_ST			, ::getFieldValue("F3_VALPS3" )  )
	    ::addField(VLR_BASE_COFINS_ST	, ::getFieldValue("F3_BASECF3") )
	    ::addField(VLR_ALIQ_COFINS_ST	, ::getFieldValue("F3_ALIQCF3") ) 
	    ::addField(VLR_COFINS_ST		, ::getFieldValue("F3_VALCF3" ) )
	    ::addField(VLR_BASE_CSLL		, iif(cType =="1", ::getFieldValue("F1_BASCSLL", aInOutFlows) , ::getFieldValue("F2_BASCSLL", aInOutFlows)))
	    ::addField(VLR_ALIQ_CSLL		, ::getFieldValue(::cPrefix+"_ALIQCSL"))
	    ::addField(VLR_CSLL			, iif(cType =="1", ::getFieldValue("F1_VALCSLL", aInOutFlows) , ::getFieldValue("F2_VALCSLL", aInOutFlows)))
	    ::addField(VLR_ALIQ_PIS		, ::getPis(VLR_ALIQ_PIS[POS_FIELD])) 
	    ::addField(VLR_ALIQ_COFINS		, ::getCofins(VLR_ALIQ_COFINS[POS_FIELD]))        
	    ::addField(VLR_FECP_ICMS		, ::getFieldValue(::cPrefix+"_VALFECP"))
	    ::addField(VLR_FECP_ICMS_ST		, ::getFieldValue(::cPrefix+"_VFESTRN") + ::getFieldValue(::cPrefix+"_VFESTMG") + ::getFieldValue(::cPrefix+"_VFESTMT") )
	    ::addField(COD_TRIB_IPI		, ::getFieldValue(::cPrefix+"_CTIPI"))
	    ::addField(COD_EX_NCM			, substr(::getFieldValue("B1_EX_NCM", aProduct),1,2))
	    ::addField(COD_EX_IMP			, substr(::getFieldValue("B1_EXNBM", aProduct),1,2))    
	    ::addField(IND_ESPECIF_RECEITA	, ::getFieldValue("FU_TIPOREC",aElectrPower))
	    ::addField(COD_SITUACAO_PIS		, ::getFieldValue(::cPrefix+"_CSTPIS"))
		::addField(QTD_BASE_PIS		, ' ')
		::addField(VLR_ALIQ_PIS_R		, ' ')   
		::addField(COD_SITUACAO_COFINS	, ::getFieldValue(::cPrefix+"_CSTCOF"))
		::addField(QTD_BASE_COFINS		, ' ')
		::addField(VLR_ALIQ_COFINS_R	, ' ')   
	    ::addField(ITEM_PORT_TARE		, ::getFieldValue("MV_ITTARE"))
	    ::addField(VLR_FUNRURAL		, Iif(cType =="1", ::getFieldValue("D1_VALFUN", aItFlow), ::getFieldValue("D2_VALFUN", aItFlow)))	   
		::addField(VLR_PIS_TRIB		, Iif(::getFieldValue(::cPrefix+"_CSTPIS") $ "50" ,::getFieldValue(::cPrefix+"_VALPIS"),0)  ) 
	    ::addField(VLR_PIS_EXP			, Iif(::getFieldValue(::cPrefix+"_CSTPIS") $ "52" ,::getFieldValue(::cPrefix+"_VALPIS"),0)  ) 
		::addField(VLR_PIS_N_TRIB		, Iif(::getFieldValue(::cPrefix+"_CSTPIS") $ "51" ,::getFieldValue(::cPrefix+"_VALPIS"),0)  )     
		::addField(VLR_COFINS_EXP		, Iif(::getFieldValue(::cPrefix+"_CSTPIS") $ "52" ,::getFieldValue(::cPrefix+"_VALPIS"),0)  )     
		::addField(VLR_COFINS_TRIB		, Iif(::getFieldValue(::cPrefix+"_CSTPIS") $ "50" ,::getFieldValue(::cPrefix+"_VALPIS"),0)  ) 
		::addField(VLR_COFINS_N_TRIB	, Iif(::getFieldValue(::cPrefix+"_CSTPIS") $ "51" ,::getFieldValue(::cPrefix+"_VALPIS"),0)  )     
	    ::addField(DAT_LANC_PIS_COFINS	, ::getFieldValue("F3_ENTRADA"))
	    ::addField(IND_NATUREZA_FRETE	, ::getFieldValue(::cPrefix+"_INDNTFR"))
	    ::addField(COD_NAT_REC			, ::getFieldValue(::cPrefix+"_TNATREC"))
	    ::addField(IND_NAT_BASE_CRED	, ::getFieldValue(::cPrefix+"_CODBCC"))
	    ::addField(VLR_ACRESCIMO 		, Iif(cType =="1", ::getFieldValue("D1_VALACRS", aItFlow), ::getFieldValue("D2_VALACRS", aItFlow)))
	    ::addField(IND_IPI_NDESTAC_DF	, ::getFieldValue("F4_DESTACA", aTypeFlow))
	    ::addField(VLR_FCP_UF_DEST		, aUFTaxes[VLR_FCP])
		::addField(VLR_ICMS_UF_DEST		, aUFTaxes[VLR_ICMS_DEST])
		::addField(VLR_ICMS_UF_ORIG		, aUFTaxes[VLR_ICMS_ORIG])
		
		if cType == "2"
			cCBENEF 	:= getCodCBENEF(cType,self)
			nICMDeson	:= getICMDeson (cType,self)
		endIf

		::addField(COD_BENEFICIO			,  cCBENEF)
		::addField(VLR_ABAT_NTRIBUTADO		,  nICMDeson)
	   	
	   	::setItem(soma1(cItem))
	   	
	   	::notFieldRequired()
	endIf

return 

/*/{Protheus.doc} getTribIcms

Regra do campo TRIB_ICMS
	
@author Daniel Braga
@since 31/10/2014

/*/
method getTribIcms(aTypeFlow) class DHLSafx08Mul

	if ::getFieldValue("F4_LFICM",aTypeFlow) == 'T'
		return "1"
	elseIf ::getFieldValue("F4_LFICM",aTypeFlow) == 'I'	
		return "2"
	elseIf ::getFieldValue("F4_LFICM",aTypeFlow) $ 'ONZB'	
		return "3"
	endIf
return ""

/*/{Protheus.doc} getTribIpi

Regra do campo TRIB_IPI
	
@author Daniel Braga
@since 31/10/2014

@param aTax, array, array com as informacoes 

/*/
method getTribIpi(aTax) class DHLSafx08Mul

	if ::getFieldValue("FT_VALIPI",aTax) > 0
		return "1"
	elseIf ::getFieldValue("FT_ISENIPI",aTax) > 0	
		return "2"
	elseIf ::getFieldValue("FT_OUTRIPI",aTax) > 0	
		return "3"
	endIf
return ""

/*/{Protheus.doc} getAuxTribIcms

Regra do campo TRIB_ICM_AUX
	
@author Daniel Braga
@since 31/10/2014

@param aTax, array, array com as informacoes 

/*/
method getAuxTribIcms(aTax)  class DHLSafx08Mul

	if ::getFieldValue("FT_VALICM",aTax) > 0
		return "1"
	elseIf ::getFieldValue("FT_ISENIPI",aTax) > 0	
		return "2"
	elseIf ::getFieldValue("FT_OUTRIPI",aTax) > 0	
		return "3"
	endIf


return 

/*/{Protheus.doc} getValorOpIcms

Regra do campo VALOR_OP_ICMS
	
@author Daniel Braga
@since 31/10/2014

@param aTax, array, array com as informacoes 

/*/
method getValorOpIcms(aTax)  class DHLSafx08Mul
	
	if ::getFieldValue("FT_VALICM", aTax) > 0
		return ::getFieldValue("FT_VALICM", aTax)
	elseIf ::getFieldValue("FT_ISENICM", aTax) > 0
		return  ::getFieldValue("FT_ISENICM", aTax)
	elseIf	::getFieldValue("FT_OUTRICM", aTax) > 0
		return ::getFieldValue("FT_OUTRICM", aTax)
	endIf
	
return 

/*/{Protheus.doc} getIpiValorOp

Regra do campo VALOR_OP_IPI
	
@author Daniel Braga
@since 31/10/2014

@param aTax, array, array com as informacoes 

/*/
method getIpiValorOp(aTax)  class DHLSafx08Mul
	
	if ::getFieldValue("FT_VALIPI", aTax) > 0
		return ::getFieldValue("FT_VALIPI", aTax)
	elseIf ::getFieldValue("FT_ISENIPI", aTax) > 0
		return  ::getFieldValue("FT_ISENIPI", aTax)
	elseIf	::getFieldValue("FT_OUTRIPI", aTax) > 0
		return ::getFieldValue("FT_OUTRIPI", aTax) 
	endIf
	
return 

/*/{Protheus.doc} notFieldRequired

Campos não obrigatorio
	
@author Daniel Braga
@since 04/11/2014


/*/
method notFieldRequired() class DHLSafx08Mul

    ::addField(SUB_SERIE_DOCFIS, ' ')
    ::addField(COD_BEM, ' ')
    ::addField(COD_INC_BEM, ' ')
    ::addField(DESCRICAO_COMPL, ' ')
    ::addField(COD_FEDERAL, ' ')
    ::addField(COD_INDICE, ' ')
    ::addField(VLR_ITEM_CONVER, ' ')
    ::addField(OBS_ICMS, ' ')
    ::addField(OBS_IPI, ' ')
    ::addField(OBS_SUBST_ICMS, ' ')
    ::addField(VLR_CONTAB_COMPL, ' ')
    ::addField(VLR_ALIQ_DESTINO, ' ')
    ::addField(COD_OBS_VCONT_COMP, ' ')
    ::addField(COD_OBS_VCONT_ITEM, ' ')
    ::addField(VLR_OUTROS_ICMS, ' ')
    ::addField(NUM_ATO_CONCES, ' ')
    ::addField(DAT_EMBARQUE, ' ')
    ::addField(NUM_REG_EXP, ' ')
    ::addField(NUM_DESP_EXP, ' ')
    ::addField(VLR_DESP_MOEDA_EXP, ' ')
    ::addField(COD_MOEDA_NEGOC, ' ')
    ::addField(COD_PAIS_DEST_ORIG, ' ')
    ::addField(IND_CRED_ICMSS, ' ')
    ::addField(COD_TRIB_INT, ' ')
    ::addField(VLR_ICMS_NDESTAC, ' ')
    ::addField(BASE_ICMS_ORIGDEST, ' ')
    ::addField(VLR_ICMS_ORIGDEST, ' ')
    ::addField(ALIQ_ICMS_ORIGDEST, ' ')
    ::addField(VLR_DESC_CONDIC, ' ')
    ::addField(TRIB_ICMSS, ' ')
    ::addField(BASE_REDU_ICMSS, ' ')
    ::addField(PERC_RED_BASE_ICMS, ' ')
    ::addField(QTD_EMBARCADA, ' ')
    ::addField(DAT_REGISTRO_EXP, ' ')
    ::addField(DAT_DESPACHO, ' ')
    ::addField(DAT_AVERBACAO, ' ')
    ::addField(DSC_MOT_OCOR, ' ')
    ::addField(VLR_BASE_ICMS_ORIG, ' ')
    ::addField(VLR_TRIB_ICMS_ORIG, ' ')
    ::addField(VLR_BASE_ICMS_DEST, ' ')
    ::addField(VLR_TRIB_ICMS_DEST, ' ')
    ::addField(VLR_PERC_PRES_ICMS, ' ')
    ::addField(VLR_PRECO_BASE_ST, ' ')
    ::addField(COD_OPER_OIL, ' ')
    ::addField(COD_DCR, ' ')
    ::addField(COD_PROJETO, ' ')
    ::addField(CHASSI, ' ')
    ::addField(SSERIE_DOCFIS_REF, ' ')
    ::addField(IND_FORNEC_ICMSS, ' ')
    ::addField(IND_SITUACAO_ESP_ST, ' ')
    ::addField(VLR_ICMSS_NDESTAC, ' ')
    ::addField(IND_DOCTO_REC, ' ')
    ::addField(DAT_PGTO_GNRE_DARJ, ' ')
    ::addField(VLR_CUSTO_UNIT, ' ')
    ::addField(QUANTIDADE_CONV, ' ')
    ::addField(VLR_FECP_DIFALIQ, ' ')
    ::addField(VLR_FECP_FONTE, ' ')
    ::addField(TRIB_ICMSS_AUX2, ' ')
    ::addField(BASE_ICMSS_AUX2, ' ')
    ::addField(VLR_BASE_ICMSS_N_ESCRIT, ' ')
    ::addField(VLR_ICMSS_N_ESCRIT, ' ')
    ::addField(LOTE_MEDICAMENTO, ' ')
    ::addField(VALID_MEDICAMENTO, ' ')
    ::addField(IND_BASE_MEDICAMENTO, ' ')
    ::addField(VLR_PRECO_MEDICAMENTO, ' ')
    ::addField(IND_TIPO_ARMA, ' ')
    ::addField(NUM_SERIE_ARMA, ' ')
    ::addField(NUM_CANO_ARMA, ' ')
    ::addField(DSC_ARMA, ' ')
    ::addField(COD_OBSERVACAO, ' ')
    ::addField(CNPJ_OPERADORA, ' ')
    ::addField(CPF_OPERADORA, ' ')
    ::addField(UF_OPERADORA, ' ')
    ::addField(INS_EST_OPERADORA, ' ')
    ::addField(COD_CLASS_ITEM, ' ')
    ::addField(VLR_TERCEIROS, ' ')
    ::addField(VLR_PRECO_SUGER, ' ')
    ::addField(VLR_BASE_CIDE, ' ')
    ::addField(VLR_ALIQ_CIDE, ' ')
    ::addField(VLR_CIDE, ' ')
    ::addField(COD_OPER_ESP_ST, ' ')
    ::addField(VLR_COMISSAO, ' ')
    ::addField(VLR_ICMS_FRETE, ' ')
    ::addField(VLR_DIFAL_FRETE, ' ')
    ::addField(IND_VLR_PIS_COFINS, ' ')
    ::addField(COD_ENQUAD_IPI, ' ')
    ::addField(IND_TP_PROD_MEDIC, ' ')
    ::addField(VLR_CUSTO_DCA, ' ')
    ::addField(COD_TP_LANCTO, ' ')
    ::addField(VLR_PERC_CRED_OUT, ' ')
    ::addField(VLR_CRED_OUT, ' ')
    ::addField(VLR_ICMS_DCA, ' ')
    ::addField(COD_ENQ_LEGAL, ' ')
    ::addField(IND_PIS_COFINS_EXTEMP, ' ')
    ::addField(DSC_RESERVADO1, ' ')
    ::addField(DSC_RESERVADO2, ' ')
    ::addField(DSC_RESERVADO3, ' ')
    ::addField(COD_TRIB_PROD, ' ')
    ::addField(DSC_RESERVADO4, ' ')
    ::addField(DSC_RESERVADO5, ' ')
    ::addField(DSC_RESERVADO6, ' ')
    ::addField(DSC_RESERVADO7, ' ')
    ::addField(DSC_RESERVADO8, ' ')
    ::addField(INDICE_PROD_ACAB, ' ')
    ::addField(VLR_BASE_DIA_AM, ' ')
    ::addField(VLR_ALIQ_DIA_AM, ' ')
    ::addField(VLR_ICMS_DIA_AM, ' ')
    ::addField(COD_APUR_ICMS,'')
    ::addField(COD_APUR_IPI,'')
    ::addField(COD_APUR_SUB_ICMS,'')
    ::addField(VLR_ADUANEIRO,'')			
	::addField(COD_SITUACAO_PIS_ST,'')		
	::addField(COD_SITUACAO_COFINS_ST,'')	
	::addField(VLR_ALIQ_DCIP,'')			
	::addField(NUM_LI,'')	

	//::addField(VLR_FCP_UF_DEST			,'')	
	//::addField(VLR_ICMS_UF_DEST		    ,'')	
	//::addField(VLR_ICMS_UF_ORIG		    ,'')	
	::addField(VLR_DIF_DUB				,'')	
	::addField(VLR_ICMS_NAO_DEST		,'')	
	::addField(VLR_BASE_ICMS_NAO_DEST	,'') 	
	::addField(VLR_ALIQ_ICMS_NAO_DEST	,'')	
	::addField(IND_MOTIVO_RES			,'')	
	::addField(NUM_DOCFIS_RET			,'')	
	::addField(SERIE_DOCFIS_RET		    ,'')	
	::addField(NUM_AUTENTIC_NFE_RET	    ,'')	
	::addField(NUM_ITEM_RET 			,'')                            
	::addField(IND_FIS_JUR_RET			,'')	
	::addField(COD_FIS_JUR_RET			,'')	
	::addField(IND_TP_DOC_ARREC		    ,'')	
	::addField(NUM_DOC_ARREC			,'')	
	::addField(COD_CFO_DCIP			    ,'')	
	::addField(VLR_BASE_INSS			,'')	
	::addField(VLR_INSS_RETIDO			,'')	
	::addField(VLR_TOT_ADIC			    ,'')	
	::addField(VLR_N_RET_PRINC			,'')	
	::addField(VLR_N_RET_ADIC			,'')	
	::addField(VLR_ALIQ_INSS			,'')	
	::addField(VLR_RET_SERV			    ,'')	
	::addField(VLR_SERV_15				,'')	
	::addField(VLR_SERV_20				,'')	
	::addField(VLR_SERV_25				,'')	
	::addField(IND_TP_PROC_ADJ_PRINC	,'')	
	::addField(NUM_PROC_ADJ_PRINC		,'')	
	::addField(COD_SUSP_PRINC			,'')	
	::addField(IND_TP_PROC_ADJ_ADIC	    ,'')	
	::addField(NUM_PROC_ADJ_ADIC		,'')	
	::addField(COD_SUSP_ADIC			,'')	
	::addField(VLR_IPI_DEV				,'')	
	::addField(VLR_CREDITO_MVA_SN		,'')	
	::addField(VLR_DESONERADO_ICMS		,'')	
	::addField(VLR_DIFERIDO_ICMS		,'')	


return


/*/{Protheus.doc} getPis

Identifica campo e preenchimento de valores de acordo com regra de PIS 
	
@author Thiago Meschiatti
@since 23/03/15

/*/
method getPis(nField) class DHLSafx08Mul
	local cTypeCST	:= ""
	local nRet		:= 0
	
	cTypeCST := ::getFieldValue(::cPrefix+"_CSTPIS")
	
	if upper(alltrim(cTypeCST)) $ "01|06|56|"
		nRet := getValuesPis(nField, cTypeCST, self)
	endif
	
return(nRet)


/*
** Coleta valores PIS
*/
static function getValuesPis(nField, cTypeCST, oSelf) 
	local nRet := 0
	
	if nField == VLR_BASE_PIS[POS_FIELD]
		nRet := oSelf:getFieldValue(oSelf:cPrefix+"_BASEPIS")
	elseif nField == VLR_PIS[POS_FIELD] .and. !upper(alltrim(cTypeCST)) == "06"
		nRet := oSelf:getFieldValue(oSelf:cPrefix+"_VALPIS")
	elseif nField == VLR_ALIQ_PIS[POS_FIELD] .and. !upper(alltrim(cTypeCST)) == "06"
		nRet := oSelf:getFieldValue(oSelf:cPrefix+"_ALIQPIS")
	endif
	
return(nRet)


/*/{Protheus.doc} getCofins

Identifica campo e preenchimento de valores de acordo com regra de COFINS
	
@author Thiago Meschiatti
@since 23/03/15

/*/
method getCofins(nField) class DHLSafx08Mul
	local cTypeCST	:= ""
	local nRet		:= 0
	
	cTypeCST := ::getFieldValue(::cPrefix+"_CSTCOF")
	
	if upper(alltrim(cTypeCST)) $ "01|06|56|"
		nRet := getValuesCofins(nField, cTypeCST, self)
	endif
	
return(nRet)


/*
** Coleta valores COFINS	
*/
static function getValuesCofins(nField, cTypeCST, oSelf) 
	local nRet := 0
	
	if nField == VLR_BASE_COFINS[POS_FIELD]
		nRet := oSelf:getFieldValue(oSelf:cPrefix+"_BASECOF")
	elseif nField == VLR_COFINS[POS_FIELD] .and. !upper(alltrim(cTypeCST)) == "06"
		nRet := oSelf:getFieldValue(oSelf:cPrefix+"_VALCOF")
	elseif nField == VLR_ALIQ_COFINS[POS_FIELD] .and. !upper(alltrim(cTypeCST)) == "06"
		nRet := oSelf:getFieldValue(oSelf:cPrefix+"_ALIQCOF")
	endif
	
return(nRet)	

/**
 * Ajusta as Unidades de Medida dos Produtos
 */
static function unidadeMedida(cField, cType, aItFlow, oSelf)
	
	local nQtd1UM	 	:= 0
	local nVlrTotal		:= 0
	local nPrcUnit 		:= 0
	local cSegUM	 	:= ""
	local cUM			:= ""			
	local cCliFor		:= ""
	local cLoja			:= ""
	local cProduto		:= ""	
	local cCpoCliFor 	:= ""
	local cCpoLoja   	:= ""
	local cCpoProduto 	:= ""
	local cCpoUmNfe		:= ""
	local cWhere		:= ""
	local cTipoNF		:= oSelf:getFieldValue("F3_TIPO")
	local cAlias		:= ""
	local oSql 			:= IpSqlObject():newIpSqlObject()	
	local xRet			
	
	cCliFor := oSelf:getFieldValue("F3_CLIEFOR")
	cLoja	:= oSelf:getFieldValue("F3_LOJA")
	
	if (cType == "1" ) 		
		cAlias	:= "SA5"
		if (cTipoNF $ "DB")
			cAlias	:= "SA7"
		endIf		
	elseIf (cType == "2" )		
		cAlias	:= "SA7"
		if (cTipoNF $ "DB")
			cAlias	:= "SA5"
		endIf				
	endIf
	
	if (cAlias == "SA5")
		cCpoCliFor 	:= "A5_FORNECE"
		cCpoLoja   	:= "A5_LOJA"
		cCpoProduto := "A5_PRODUTO"
		cCpoUmNfe	:= "A5_UMNFE"
	elseIf (cAlias == "SA7")
		cCpoCliFor 	:= "A7_CLIENTE"
		cCpoLoja   	:= "A7_LOJA"
		cCpoProduto := "A7_PRODUTO"
		cCpoUmNfe	:= "A7_UMNFE"
	endIf	
	
	
	cProduto := oSelf:getFieldValue(oSelf:cPrefix+"_PRODUTO")
	cUM		 := iif(cType =="1", oSelf:getFieldValue("D1_UM",aItFlow), oSelf:getFieldValue("D2_UM",aItFlow))
	nQtd1UM	 := oSelf:getFieldValue(oSelf:cPrefix+"_QUANT")
	nVlrTotal:= oSelf:getFieldValue(oSelf:cPrefix+"_TOTAL")
	nPrcUnit := oSelf:getFieldValue(oSelf:cPrefix+"_PRCUNIT")		
	cSegUM	 := oSql:getFieldValue("SB1", "B1_SEGUM", "%SB1.XFILIAL% AND B1_COD = '"+cProduto+"'")

	cWhere := " %"+cAlias+".XFILIAL% AND "+cCpoCliFor+" = '"+cCliFor+"' AND "+cCpoLoja+" = '"+cLoja+"' AND "
	cWhere += cCpoProduto+" = '"+cProduto+"' "
	
	oSql:newTable(cAlias, cCpoUmNfe+" UMNFE ", cWhere)	
	
	if oSql:hasRecords() .and. oSql:getValue("UMNFE == '2'")
		nQtd2UM 	:= ConvUM(cProduto, nQtd1UM, 0, 2)
		
		if cField == QUANTIDADE[POS_FIELD]
			xRet := nQtd2UM
		elseif cField == VLR_UNIT[POS_FIELD]
			xRet := NoRound(nVlrTotal / nQtd2UM, 8)
		elseif (cField == COD_UND_PADRAO[POS_FIELD]) .or. (cField == COD_MEDIDA[POS_FIELD])
			xRet := cSegUM
		endif
	else
		if cField == QUANTIDADE[POS_FIELD]
			xRet := nQtd1UM
		elseif cField == VLR_UNIT[POS_FIELD]
			xRet := nPrcUnit
		elseif (cField == COD_UND_PADRAO[POS_FIELD]) .or. (cField == COD_MEDIDA[POS_FIELD])
			xRet := cUM
		endif
	endIf
	
	oSql:close()
	
return (xRet)

/*
**
*/
static function retId(cType, cDoc, cSerie, cCliFor, cLoja, aItFlow, oSelf, lIdRef)
	local cId		:= ""
	local cCliDep	:= GetMv("ZZ_FOINTEG")
	
	if ((cType $ '2') .and. (alltrim(cCliFor+cLoja) == alltrim(cCliDep)) .and. (!oSelf:getFieldValue("F3_TIPO") $ "DB"))
		cId 	:= iif(cType =="1", oSelf:getFieldValue("D1_ZZID",aItFlow), oSelf:getFieldValue("D2_ZZID",aItFlow))
		lIdRef	:= .t.
	endif

return (cId)

// conta , nfiscal , serie , total , cfop , emissao 
/*
22/04/2018
FIT - Para o caso da safx08 trazer conta dependendo do cfop para notas de saida
*/
static function sfconta(  cconta , cnfiscal , cserie , ntotal , ccfop , cemissao ) 
local cret	:= cconta //(cSFT_)->ft_conta
local ccfop_fil	:= supergetmv("ZZ_CFOPX08", , "")
local cquery	:= ""
Local cAliasCT2	:= NIL
local aArea	:= getarea()

//if !empty( ccfop_fil ) .and. alltrim(ccfop_fil) == substr( ccfop /*(cSFT_)->ft_cfop */ , 2,3)
if !empty( ccfop_fil ) .and. substr( ccfop /*(cSFT_)->ft_cfop */ , 2,3) $ alltrim(ccfop_fil)
	cAliasCT2	:= GetNextAlias()

	cquery := ""
	cquery += "select ct2_credit from " + RETSQLNAME("CT2") + " where ct2_filial = '" +  xfilial("CT2") + "' "
	cquery += " and ct2_hist like '%" + cserie + '/'+ cnfiscal + "%' "  // (cSF3_)->(F3_SERIE + '/'+F3_NFISCAL) + "%' "
	cquery += " and ct2_data = '" + cEMISSAO  + "' " //(cSF3_)->F3_EMISSAO  + "' "
	cquery += " and ct2_credit <>  '" + CRIAVAR("CT2_CREDIT") + "' "
	cquery += " and ct2_valor = " + ALLTRIM(STR( ntotal )) //(cSFT_)->FT_TOTAL))
	cquery += " and d_e_l_e_t_ =' '	"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.T.)
	if (cAliasCT2)->(!EOF())
		cret	:= (cAliasCT2)->ct2_credit
	endif
	(cAliasCT2)->(dbCloseArea())

	restarea(aArea)
else
	caliasct2 := nil
endif

return(cret)

//SELECT distinct ft_cfop FROM SFT100 WHERE FT_FILIAL = '002MUL000297' AND FT_EMISSAO > '20171231' AND D_E_L_E_T_   = ' ' AND substr( FT_CFOP ,2,2)  = '12'

/**
* Obtém o código do beneficiário
**/
static function getCodCBENEF(cType,oObject)

	local cTpMov  	:= ""
	local cDoc	  	:= ""
	local cSerie  	:= ""
	local cCliFor 	:= ""
	local cLoja	  	:= ""
	local cProduto	:= ""
	local cItem	  	:= ""
	local cCFOP		:= ""
	local cAliasCDV := getNextAlias()	
	local aArea 	:= getArea()  	
	local cCodCBENEF	:= ""

	cFilCDV     := fwxFilial("CDV")	
	cDoc   		:= oObject:cPrefix+"F3_NFISCAL"
	cSerie 		:= oObject:cPrefix+"F3_SERIE" 
	cCliFor		:= oObject:cPrefix+"F3_CLIEFOR" 
	cLoja		:= oObject:cPrefix+"F3_LOJA" 
	cProduto	:= oObject:cPrefix+"FT_PRODUTO" 
	cItem	  	:= oObject:cPrefix+"FT_ITEM"
	cCFOP		:= oObject:cPrefix+"FT_CFOP"	

	if cType == "1"
		cTpMov 		:= "E		
	else
		cTpMov 		:= "S"		
	endif 	

	BeginSql Alias cAliasCDV
		SELECT CDV.CDV_CODAJU 
		FROM %Table:CDV% CDV
		WHERE
		CDV.CDV_FILIAL	= %Exp:cFilCDV% AND
		CDV.CDV_DOC 		= %Exp:cDoc% AND
		CDV.CDV_SERIE 	= %Exp:cSerie% AND		
		CDV.CDV_CLIFOR 	= %Exp:cCliFor% AND	
		CDV.CDV_LOJA 	= %Exp:cLoja% AND			
		CDV.CDV_NUMITE    = %Exp:cItem% AND	
		CDV.CDV_CFOP    = %Exp:cCFOP% AND		
		CDV.%NotDel%
	EndSql	

	If (cAliasCDV)->(!Eof())		
		cCodCBENEF:=  (cAliasCDV)->CDV_CODAJU			
	EndIf 	

	(cAliasCDV)->(dbCloseArea())

	restArea(aArea)

return cCodCBENEF

/**
* Obtém o ICMS Deson
**/
static function getICMDeson (cType,oObject)

	local nICMDeson 		:= 0
	local cTpMov  			:= ""
	local cDoc	  			:= ""
	local cSerie  			:= ""
	local cCliFor 			:= ""
	local cLoja	  			:= ""
	local cProduto			:= ""
	local cItem	  			:= ""
	local cCFOP				:= ""
	local cAliasCD2 		:= getNextAlias()	
	local aArea 			:= getArea()  
	local aAreaCD2			:= CD2->(getArea())		
	local cCampoCliFor 		:= ""
	local cCampoLojCliFor 	:= ""
	local cImposto			:= padr("ICM", tamSx3("CD2_IMP")[1], "")
	local cChaveCD2			:= ""

	oObject:cPrefix+"F3_NFISCAL"
	
	cFilCD2     := fwxFilial("CD2")	
	cDoc   		:= oObject:cPrefix+"F3_NFISCAL"
	cSerie 		:= oObject:cPrefix+"F3_SERIE"    
	cCliFor		:= oObject:cPrefix+"F3_CLIEFOR"    
	cLoja		:= oObject:cPrefix+"F3_LOJA"  
	cProduto	:= oObject:cPrefix+"FT_PRODUTO"      
	cItem	  	:= padr(oObject:cPrefix+"FT_ITEM", tamSx3("CD2_ITEM")[1], "")   
	cCFOP		:= oObject:cPrefix+"FT_CFOP"  


	if cType == "1"
		cTpMov 		:= padr("E", tamSx3("CD2_TPMOV")[2], "")
		CD2->(dbSetOrder(2))		
	else
		cTpMov 		:= padr("S", tamSx3("CD2_TPMOV")[1], "")	
		CD2->(dbSetOrder(1))		
	endif 	

	cChaveCD2 := cFilCD2 + cTpMov + cSerie + cDoc + cCliFor + cLoja + cItem + cProduto + cImposto

	if CD2->(dbSeek(cChaveCD2))
		nICMDeson := CD2->CD2_DESONE
	endIf

	restArea(aAreaCD2)
	restArea(aArea)

return nICMDeson
