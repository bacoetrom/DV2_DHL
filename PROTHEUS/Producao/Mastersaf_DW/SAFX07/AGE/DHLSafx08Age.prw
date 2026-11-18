#include 'protheus.ch'
#include 'dhl.ch'
#include 'safx08.ch'
#include 'safx.ch'

#DEFINE POS_FIELD 1


/*/{Protheus.doc} DHLSafx08Age

Respons‡vel pelas regras e montagem das informacoes para a exportacao

@author Thiago Meschiatti
@since 05/09/2016

/*/

user function _Safx18Age;return

class DHLSafx08Age from DHLSafx

data  cPrefix  as String
data  cItem  as String 


method newDHLSafx08Age() constructor 

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

method setPrefix(cPrefix) class DHLSafx08Age
	::cPrefix := cPrefix
return 

method getPrefix() class DHLSafx08Age
return ::cPrefix

method setItem(cItem) class DHLSafx08Age
	::cItem := cItem
return 

method getItem() class DHLSafx08Age
return ::cItem

method newDHLSafx08Age() class DHLSafx08Age	

return

/*/{Protheus.doc} getSql

Instrucao SQL para exportacao

@author Daniel Braga
@since 30/10/2014

@return string instrucao sql
/*/
method getSql() class DHLSafx08Age


	local cAlias	:= ""
	local cQuery	:= ""
	local cCusSup	:= (cSF3_)->(F3_CLIEFOR)         //::getFieldValue("F3_CLIEFOR")
	local cBranch	:= (cSF3_)->(F3_LOJA)           //::getFieldValue("F3_LOJA")                          
	local cDoc		:= (cSF3_)->(F3_NFISCAL)       //::getFieldValue("F3_NFISCAL")                            
	local cSer		:= (cSF3_)->(F3_SERIE)        //::getFieldValue("F3_SERIE")                       
	local cType		:= (cSF3_)->ENT_SAI          //::getTypeDoc(cDoc, cSer,cCusSup,cBranch)                                                       

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
method getSqlFt() class DHLSafx08Age


	local cAlias	:= ""
	local cQuery	:= ""
	local cCusSup	:= (cSF3_)->(F3_CLIEFOR)         //::getFieldValue("F3_CLIEFOR")
	local cBranch	:= (cSF3_)->(F3_LOJA)           //::getFieldValue("F3_LOJA")                          
	local cDoc		:= (cSF3_)->(F3_NFISCAL)       //::getFieldValue("F3_NFISCAL")                            
	local cSer		:= (cSF3_)->(F3_SERIE)        //::getFieldValue("F3_SERIE")                       
	local cType		:= (cSF3_)->ENT_SAI          //::getTypeDoc(cDoc, cSer,cCusSup,cBranch)                                                       


	cAlias := "SFT"
	::cPrefix:= PrefixoCpo(cAlias)

	cQuery :=  "select * from "+retSqlName(cAlias)+" where "
	cQuery	+=  ::cPrefix+"_filial= '"+xFilial(cAlias)+"' and "
	cQuery +=  ::cPrefix+"_nfiscal	= '"+cDoc+"' and "
	cQuery +=  ::cPrefix+"_serie 	= '"+cSer+"' and "
	cQuery +=  ::cPrefix+"_cliefor  = '"+cCusSup+"' and  "
	cQuery +=  ::cPrefix+"_loja 	= '"+cBranch+"' and "
	cQuery +=  "d_e_l_e_t_= ' ' "
	cQuery +=  "order by " + ::cPrefix + "_nfiscal, " + ::cPrefix + "_serie, " + ::cPrefix + "_item"

return Upper(cQuery)

/*/{Protheus.doc} addLine

Cria a lina ‡ ser impressa no arquivo txt

@author Daniel Braga
@since 30/10/2014

/*/
method addLine(cItenOri, cId,  lIdRef , xObj ) class DHLSafx08Age


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
	local xdummy
	local xarray := {}
	local npos		:= 0
	local cCBENEF	:= ""
	local nICMDeson	:= 0

	if !empty(::aFields)

		cCod 		:= (cSF3_)->(F3_CLIEFOR)                         //::getFieldValue("F3_CLIEFOR")
		cBranch 	:= (cSF3_)->(F3_LOJA)                           //::getFieldValue("F3_LOJA")
		cDoc		:= (cSF3_)->(F3_NFISCAL)                       //::getFieldValue("F3_NFISCAL")
		cSer    	:= (cSF3_)->(F3_SERIE)                        //::getFieldValue("F3_SERIE")
		cItem 		:= (CSFT_)->FT_ITEM                          //::getFieldValue(::cPrefix+"_ITEM")
		cType		:= (cSF3_)->ENT_sai                         //::getTypeDoc(cDoc, cSer, cCod, cBranch) 

		//cIndFisJur	:= Iif( cType =="1",Iif(::getFieldValue("F3_TIPO") $ "DB" ,"2","1" ) , Iif(!::getFieldValue("F3_TIPO") $ "DB" ,"2","1" )      )
		cIndFisJur := ::getIndFisJur(cType, (cSF3_)->(F3_TIPO))   // INICIO Wellington 18/11/2026 - centralizado na classe base


		//aSupCus 		:=  ::getSupCusRecords(cIndFisJur,cCod,cBranch)
		//aTax    		:= 	::getTaxRecord(cType  ,cDoc, cSer,cCod,cBranch,cItem)
		//aInOutFlows 	:= 	::getFlowsRecord(cType,cDoc, cSer,cCod,cBranch)
		//aItFlow			:=	::getItemFlowsRecord(cType,cDoc,cSer,cCod,cBranch,cItem)
		//aDocImp			:= 	::getImportAdd(cDoc,cSer,cCod,cBranch,cItem)	
		//aTypeFlow		:= 	::gettypeInOutFlow(iif(cType =="1", ::getFieldValue("D1_TES",aItFlow), ::getFieldValue("D2_TES",aItFlow))) 
		//aElectrPower	:= 	::getEletricPower(cType,cDoc,cSer,cCod,cBranch)
		//aProduct 		:=	::getProduct(::getFieldValue(::cPrefix+"_PRODUTO"))
		//aUFTaxes		:= ::getUfTaxes(cType, ::getFieldValue("F3_TIPO"), cSer, cDoc, cCod, cBranch, cItem)


		IF len( _uftaxes ) = 1
			aUFTAXES := ACLONE( _uftaxes[1] )
		else
			npos := ascan( _UfTaxes , {|Z| Z[4] = cItem } )
			if npos > 0
				aUFTAXES := ACLONE( _uftaxes[npos] )
			else
				aUFTAXES := ACLONE( _uftaxes[ len(_aUfTaxes) ] )
			endif
		ENDIF

		::addField(COD_EMPRESA			, alltrim(GetNewPar("ZZ_IDEMPDW", "SOL")))
		::addField(COD_ESTAB			, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())))
		::addField(DATA_FISCAL			, IIf(cType == "1", (cSF3_)->(F3_ENTRADA), (cSF3_)->(F3_EMISSAO)))    //::getFieldValue("F3_ENTRADA"), ::getFieldValue("F3_EMISSAO")))
		::addField(MOVTO_E_S			, iif(cType =="1",  SAFX_DOCUMENTO_ENTRADA, SAFX_DOCUMENTO_SAIDA))
		::addField(NORM_DEV				, (cSF3_)->TIPO )      //::getFieldValue("TIPO") )
		::addField(COD_DOCTO			, "NFE")
		::addField(IND_FIS_JUR			, (cSF3_)->ZZINDDW )  //Iif(cIndFisJur == "1",::getFieldValue("A2_ZZINDDW",aSupCus), ::getFieldValue("A1_ZZINDDW",aSupCus)))
		::addField(COD_FIS_JUR			, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp()))+cCod+cBranch)
		::addField(NUM_DOCFIS			, (cSF3_)->(F3_NFISCAL) )   //::getFieldValue("F3_NFISCAL") )
		::addField(SERIE_DOCFIS			, (cSF3_)->(F3_SERIE) )    //::getFieldValue("F3_SERIE") )
		::addField(IND_BEM_PATR			, "N")
		::addField(IND_PRODUTO			,  ::getProdType((csft_)->b1_tipo ) )      //::getProdType(::getFieldValue("B1_TIPO",aProduct)) )
		::addField(COD_PRODUTO			, (cSFT_)->FT_PRODUTO)   //::getFieldValue(::cPrefix+"_PRODUTO"))
		//::addField(COD_UND_PADRAO		, iif((cType == "1" .and. ::getFieldValue("F1_FORMUL", aInOutFlows) == "S") .or. (cType == "2"),;
		//								  unidadeMedida(COD_UND_PADRAO[POS_FIELD], cType, aItFlow, self),;
		//							      ::getFieldValue("B1_UM", aProduct) ))
		::addField(COD_UND_PADRAO		, iif((cType == "1" .and. (csft_)->F1_FORMUL == "S") .or. (cType == "2"),;
		unidadeMedida(COD_UND_PADRAO[POS_FIELD], cType, aItFlow, self , xObj ),;
		(csft_)->b1_um /*::getFieldValue("B1_UM", aProduct)*/ ))
		::addField(NUM_ITEM				, iif(cType == "1",alltrim(padl(::getItem(),tamsx3("D1_ITEM")[1],'0')),alltrim(cItem)))
		::addField(COD_ALMOX			, (csft_)->b1_locpad )       //::getFieldValue("B1_LOCPAD", aProduct))
		::addField(COD_CUSTO			, Iif(cType == "1", (cSFT_)->D1_CC , (csft_)->D2_CCUSTO ))     //Iif(cType == "1", ::getFieldValue("D1_CC", aItFlow) ,::getFieldValue("D2_CCUSTO", aItFlow) ) )
		::addField(COD_CFO				, (cSFT_)->FT_CFOP)        //::getFieldValue(::cPrefix+"_CFOP"))
		::addField(COD_NATUREZA_OP		, (cSFT_)->FT_NATOPER)    //::getFieldValue(::cPrefix+"_NATOPER"))
		//::addField(QUANTIDADE			, iif((cType == "1" .and. ::getFieldValue("F1_FORMUL", aInOutFlows) == "S") .or. (cType == "2"),;
		//  								  unidadeMedida(QUANTIDADE[POS_FIELD], cType, aItFlow, self),;
		//  								  ::getFieldValue(::cPrefix+"_QUANT")))
		::addField(QUANTIDADE			, iif((cType == "1" .and. (cSFT_)->F1_FORMUL == "S") .or. (cType == "2"),;
		unidadeMedida(QUANTIDADE[POS_FIELD], cType, aItFlow, self, xObj ),;
		(cSFT_)->FT_QUANT /*::getFieldValue(::cPrefix+"_QUANT")*/ ))
		//::addField(COD_MEDIDA			, iif((cType == "1" .and. ::getFieldValue("F1_FORMUL", aInOutFlows) == "S") .or. (cType == "2"),;
		// 								  unidadeMedida(COD_MEDIDA[POS_FIELD], cType, aItFlow, self),;
		//								  ::getFieldValue("B1_UM", aProduct)))
		::addField(COD_MEDIDA			, iif((cType == "1" .and. (cSFT_)->F1_FORMUL == "S") .or. (cType == "2"),;
		unidadeMedida(COD_MEDIDA[POS_FIELD], cType, aItFlow, self,  xObj ),;
		(csft_)->b1_um /* ::getFieldValue("B1_UM", aProduct)*/ ))
		::addField(COD_NBM				, (csft_)->b1_posipi)   //::getFieldValue("B1_POSIPI",aProduct) )
		//::addField(VLR_UNIT				, iif((cType == "1" .and. ::getFieldValue("F1_FORMUL", aInOutFlows) == "S") .or. (cType == "2"),;
		//								  unidadeMedida(VLR_UNIT[POS_FIELD], cType, aItFlow, self),;
		//								  ::getFieldValue(::cPrefix+"_PRCUNIT")))
		::addField(VLR_UNIT				, iif((cType == "1" .and. (csft_)->F1_FORMUL == "S") .or. (cType == "2"),;
		unidadeMedida(VLR_UNIT[POS_FIELD], cType, aItFlow, self , xObj),;
		(cSFT_)->FT_PRCUNIT /*::getFieldValue(::cPrefix+"_PRCUNIT") */))
		::addField(VLR_ITEM				, (cSFT_)->FT_TOTAL)      //::getFieldValue(::cPrefix+"_TOTAL"))
		::addField(VLR_DESCONTO			, (cSFT_)->FT_DESCONT)   //::getFieldValue(::cPrefix+"_DESCONT"))
		::addField(COD_SITUACAO_A		, left((cSFT_)->FT_CLASFIS,1))                    //left(::getFieldValue(::cPrefix+"_CLASFIS"),1))
		::addField(COD_SITUACAO_B		, substr((cSFT_)->FT_CLASFIS,2,2))               //substr(::getFieldValue(::cPrefix+"_CLASFIS"),2,2))
		::addField(IND_IPI_INCLUSO		, Iif( (csft_)->F4_INCIDE == 'S' , 'S', 'N'))   //Iif(::getFieldValue("F4_INCIDE",aTypeFlow) == 'S' , 'S', 'N'))
		::addField(NUM_ROMANEIO			, Iif(cType =="2" ,(cSFT_)->D2_CODROM,"" ))    //Iif(cType =="2" ,::getFieldValue("D2_CODROM", aItFlow),"" )) 
		::addField(DATA_ROMANEIO		, Iif(cType =="2" ,posicione("NPR",1,xFilial("NPR")+ (csft_)->D2_CODROM ,"NPR_DATA"),"" ))    //Iif(cType =="2" ,posicione("NPR",1,xFilial("NPR")+::getFieldValue("D2_CODROM", aItFlow),"NPR_DATA"),"" ))
		::addField(PESO_LIQUIDO			, (cSFT_)->FT_PESO)                           //::getFieldValue(::cPrefix+"_PESO"))
		::addField(VLR_FRETE			, (cSFT_)->FT_FRETE)                         //::getFieldValue(::cPrefix+"_FRETE"))
		::addField(VLR_SEGURO			, (cSFT_)->FT_SEGURO)                       //::getFieldValue(::cPrefix+"_SEGURO"))
		::addField(VLR_OUTRAS			, (cSFT_)->FT_DESPESA)                     //::getFieldValue(::cPrefix+"_DESPESA"))
		::addField(VLR_ALIQ_ICMS		, (cSFT_)->FT_ALIQICM)                    //::getFieldValue(::cPrefix+"_ALIQICM"))
		::addField(VLR_ICMS				, (cSFT_)->FT_VALICM , lFormatZero)      //::getFieldValue(::cPrefix+"_VALICM "), lFormatZero)
		::addField(DIF_ALIQ_ICMS		, Iif(cType == "1",((cSFT_)->FT_ICMSCOM/(cSFT_)->FT_BASEICM)/100, 0  ))          //Iif(cType == "1",(::getFieldValue(::cPrefix+"_ICMSCOM")/::getFieldValue(::cPrefix+"_BASEICM"))/100, 0  ))
		::addField(VLR_ALIQ_IPI			, (cSFT_)->FT_ALIQIPI )                                                         //::getFieldValue(::cPrefix+"_ALIPIPI") )
		::addField(VLR_IPI				, (cSF3_)->(F3_VALIPI) )                                                       //::getFieldValue("F3_VALIPI") )
		//::addField(VLR_ALIQ_SUB_ICMS	, iif(((FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_SPL)) , ' ',::getFieldValue(::cPrefix+"_ALIQSOL")))
		::addField(VLR_ALIQ_SUB_ICMS	, iif(((FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_SPL)) , ' ',(cSFT_)->FT_ALIQSOL))
		//::addField(VLR_SUBST_ICMS		, iif(((FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_SPL)) , ' ',::getFieldValue("F3_ICMSRET")))
		::addField(VLR_SUBST_ICMS		, iif(((FWUnitBusiness() == DHL_BUSINESSUNIT_PKG) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_SPL)) , ' ',(cSF3_)->(F3_ICMSRET)))
		::addField(TRIB_ICMS			, ::getTribIcms(aTypeFlow)) 
		//::addField(BASE_ICMS			, iif(::getTribIcms(aTypeFlow)== '1', ::getFieldValue(::cPrefix+"_BASEICM"), iif(::getTribIcms(aTypeFlow)== '2', ::getFieldValue(::cPrefix+"_ISENICM"), ::getFieldValue(::cPrefix+"_OUTRICM"))))
		::addField(BASE_ICMS			, iif(::getTribIcms(aTypeFlow)== '1', (cSFT_)->FT_BASEICM, iif(::getTribIcms(aTypeFlow)== '2', (cSFT_)->FT_ISENICM, (cSFT_)->FT_OUTRICM)))
		//::addField(BASE_REDU_ICMS		, iif((FWUnitBusiness() == DHL_BUSINESSUNIT_SPL), ' ',;
		//   								  Iif(::getFieldValue("F4_BASEICM",aTypeFlow) <> 0,::getFieldValue("F3_BASEICM"), 0 )))
		::addField(BASE_REDU_ICMS		, iif((FWUnitBusiness() == DHL_BUSINESSUNIT_SPL), ' ',;
		Iif( (csft_)->F4_BASEICM <> 0,(cSF3_)->(F3_BASEICM), 0 ))) //::getFieldValue("F4_BASEICM",aTypeFlow)
		::addField(TRIB_IPI				, ::getTribIpi(aTax))
		//::addField(BASE_IPI				, iif(::getTribIpi(aTax)== '1', ::getFieldValue(::cPrefix+"_BASEIPI"), iif(::getTribIpi(aTax)== '2', ::getFieldValue(::cPrefix+"_ISENIPI"), ::getFieldValue(::cPrefix+"_OUTRIPI"))))
		::addField(BASE_IPI				, iif(::getTribIpi(aTax)== '1', (cSFT_)->FT_BASEIPI, iif(::getTribIpi(aTax)== '2', (cSFT_)->FT_ISENIPI, (cSFT_)->FT_OUTRIPI)))
		::addField(BASE_REDU_IPI		, Iif( (csft_)->F4_BASEIPI <> 0,(cSF3_)->(F3_BASEIPI), 0 ))    //Iif(::getFieldValue("F4_BASEIPI",aTypeFlow) <> 0,::getFieldValue("F3_BASEIPI"), 0 ))
		::addField(BASE_SUB_TRIB_ICMS 	, (cSFT_)->FT_BASERET)                                        //::getFieldValue(::cPrefix+"_BRICMS"))
		::addField(VLR_CONTAB_ITEM		, (cSFT_)->FT_VALCONT)	                                     //::getFieldValue(::cPrefix+"_VALCONT"))	    
		::addField(VLR_OUTROS_IPI		, ' ' )                                                     //::getFieldValue(::cPrefix+"_IPIOBS"))	    
		::addField(VLR_OUTROS1			, Iif(cType == "1" , (cSFT_)->FT_ICMSCOM,""))              //Iif(cType == "1" , ::getFieldValue(::cPrefix+"_ICMSCOM"),"")) 
		::addField(VLR_TOM_SERVICO		, (cSFT_)->FT_FRETE)                                      //::getFieldValue(::cPrefix+"_FRETE"))   
		::addField(VLR_IPI_NDESTAC		, (cSFT_)->FT_ALIQIPI)                                   //::getFieldValue(::cPrefix+"_ALIQIPI")) 
		::addField(TRIB_ICMS_AUX		, ' ') 
		::addField(BASE_ICMS_AUX		, ' ') 
		::addField(TRIB_IPI_AUX			, ' ') 
		::addField(BASE_IPI_AUX			, ' ')  
		::addField(VLR_BASE_PIS			, ::getPis(VLR_BASE_PIS[POS_FIELD]) ) 
		::addField(VLR_PIS				, ::getPis(VLR_PIS[POS_FIELD]) )	
		::addField(VLR_BASE_COFINS		, ::getCofins(VLR_BASE_COFINS[POS_FIELD]) )
		::addField(VLR_COFINS			, ::getCofins(VLR_COFINS[POS_FIELD]))	    
		::addField(VLR_CUSTO_TRANSF		, ' ') 
		::addField(DAT_DI				, ' ')                           //::getFieldValue("CD5_DTDI", aDocImp))
		::addField(NUM_DEC_IMP_REF		, ' ')                          //::getFieldValue("CD5_DOCIMP", aDocImp))
		::addField(COD_CONTA			, (cSFT_)->FT_CONTA)           //::getFieldValue(::cPrefix+"_CONTA")) 	    
		::addField(IND_MOV_FIS			, (cSFT_)->FT_ESTOQUE)        //::getFieldValue(::cPrefix+"_ESTOQUE"))
		::addField(NUM_DOCFIS_REF		, (cSFT_)->FT_NFORI)         //::getFieldValue(::cPrefix+"_NFORI"))
		::addField(SERIE_DOCFIS_REF		, (cSFT_)->FT_SERORI)       //::getFieldValue(::cPrefix+"_SERORI"))
		::addField(VLR_BASE_PIS_ST		, (cSF3_)->(F3_BASEPS3) )  //::getFieldValue("F3_BASEPS3") )
		::addField(VLR_ALIQ_PIS_ST		,  ' ' )                  //::getFieldValue("F3_ALIQPS3") )
		::addField(VLR_PIS_ST			, (cSF3_)->(F3_VALPS3 )  )                 //::getFieldValue("F3_VALPS3" )  )
		::addField(VLR_BASE_COFINS_ST	, (cSF3_)->(F3_BASECF3) )                 //::getFieldValue("F3_BASECF3") )
		::addField(VLR_ALIQ_COFINS_ST	, '' )                                   //::getFieldValue("F3_ALIQCF3") ) 
		::addField(VLR_COFINS_ST		, (cSF3_)->(F3_VALCF3 ) )               //::getFieldValue("F3_VALCF3" ) )
		::addField(VLR_BASE_CSLL		, iif(cType =="1", (csft_)->F1_BASCSLL , (csft_)->F2_BASCSLL))         //iif(cType =="1", ::getFieldValue("F1_BASCSLL", aInOutFlows) , ::getFieldValue("F2_BASCSLL", aInOutFlows)))
		::addField(VLR_ALIQ_CSLL		, (cSFT_)->FT_ALIQCSL)                                                //::getFieldValue(::cPrefix+"_ALIQCSL"))
		::addField(VLR_CSLL				, iif(cType =="1", (csft_)->F1_VALCSLL , (cSFT_)->F2_VALCSLL))       //iif(cType =="1", ::getFieldValue("F1_VALCSLL", aInOutFlows) , ::getFieldValue("F2_VALCSLL", aInOutFlows)))
		::addField(VLR_ALIQ_PIS			, ::getPis(VLR_ALIQ_PIS[POS_FIELD])) 
		::addField(VLR_ALIQ_COFINS		, ::getCofins(VLR_ALIQ_COFINS[POS_FIELD]))        
		::addField(VLR_FECP_ICMS		, (cSFT_)->FT_VALFECP)                                             //::getFieldValue(::cPrefix+"_VALFECP"))
		//::addField(VLR_FECP_ICMS_ST		, ::getFieldValue(::cPrefix+"_VFESTRN") + ::getFieldValue(::cPrefix+"_VFESTMG") + ::getFieldValue(::cPrefix+"_VFESTMT") )
		::addField(VLR_FECP_ICMS_ST		, (cSFT_)->FT_VFESTRN + (cSFT_)->FT_VFESTMG + (cSFT_)->FT_VFESTMT )
		::addField(COD_TRIB_IPI			, (cSFT_)->FT_CTIPI)                                            //::getFieldValue(::cPrefix+"_CTIPI"))
		::addField(COD_EX_NCM			, substr((csft_)->b1_ex_ncm ,1,2))                             //substr(::getFieldValue("B1_EX_NCM", aProduct),1,2))
		::addField(COD_EX_IMP			, substr((csft_)->b1_ex_nbm ,1,2))                            //substr(::getFieldValue("B1_EXNBM", aProduct),1,2))   /* campo estava errado ::getFieldValue("B1_EXNBM", aProduct)*/ 
		::addField(IND_ESPECIF_RECEITA	, ' ' )                                                      //::getFieldValue("FU_TIPOREC",aElectrPower))
		::addField(COD_SITUACAO_PIS		, (cSFT_)->FT_CSTPIS)                                       //::getFieldValue(::cPrefix+"_CSTPIS"))
		::addField(QTD_BASE_PIS			, ' ')
		::addField(VLR_ALIQ_PIS_R		, ' ')   
		::addField(COD_SITUACAO_COFINS	, (cSFT_)->FT_CSTCOF)                                    //::getFieldValue(::cPrefix+"_CSTCOF"))
		::addField(QTD_BASE_COFINS		, ' ')
		::addField(VLR_ALIQ_COFINS_R	, ' ')   
		::addField(ITEM_PORT_TARE		, supergetmv("MV_ITTARE"))                                            //::getFieldValue("MV_ITTARE"))
		::addField(VLR_FUNRURAL			, Iif(cType =="1", (csft_)->D1_VALFUN , (csft_)->D2_VALFUN ))        //Iif(cType =="1", ::getFieldValue("D1_VALFUN", aItFlow), ::getFieldValue("D2_VALFUN", aItFlow)))	   
		::addField(VLR_PIS_TRIB			, Iif((cSFT_)->FT_CSTPIS $ "50" ,(cSFT_)->FT_VALPIS,0)  )           //Iif(::getFieldValue(::cPrefix+"_CSTPIS") $ "50" ,::getFieldValue(::cPrefix+"_VALPIS"),0)  ) 
		::addField(VLR_PIS_EXP			, Iif((cSFT_)->FT_CSTPIS $ "52" ,(cSFT_)->FT_VALPIS,0)  )          //Iif(::getFieldValue(::cPrefix+"_CSTPIS") $ "52" ,::getFieldValue(::cPrefix+"_VALPIS"),0)  ) 
		::addField(VLR_PIS_N_TRIB		, Iif((cSFT_)->FT_CSTPIS $ "51" ,(cSFT_)->FT_VALPIS,0)  )         //Iif(::getFieldValue(::cPrefix+"_CSTPIS") $ "51" ,::getFieldValue(::cPrefix+"_VALPIS"),0)  )     
		::addField(VLR_COFINS_EXP		, Iif((cSFT_)->FT_CSTPIS $ "52" ,(cSFT_)->FT_VALPIS,0)  )        //Iif(::getFieldValue(::cPrefix+"_CSTPIS") $ "52" ,::getFieldValue(::cPrefix+"_VALPIS"),0)  )     
		::addField(VLR_COFINS_TRIB		, Iif((cSFT_)->FT_CSTPIS $ "50" ,(cSFT_)->FT_VALPIS,0)  )       //Iif(::getFieldValue(::cPrefix+"_CSTPIS") $ "50" ,::getFieldValue(::cPrefix+"_VALPIS"),0)  ) 
		::addField(VLR_COFINS_N_TRIB	, Iif((cSFT_)->FT_CSTPIS $ "51" ,(cSFT_)->FT_VALPIS,0)  )      //Iif(::getFieldValue(::cPrefix+"_CSTPIS") $ "51" ,::getFieldValue(::cPrefix+"_VALPIS"),0)  )     
		::addField(DAT_LANC_PIS_COFINS	, (cSF3_)->(F3_ENTRADA))                                      //::getFieldValue("F3_ENTRADA"))
		::addField(IND_NATUREZA_FRETE	, (cSFT_)->FT_INDNTFR)                                       //::getFieldValue(::cPrefix+"_INDNTFR"))
		::addField(COD_NAT_REC			, (cSFT_)->FT_TNATREC)                                      //::getFieldValue(::cPrefix+"_TNATREC"))
		::addField(IND_NAT_BASE_CRED	, (cSFT_)->FT_CODBCC)                                      //::getFieldValue(::cPrefix+"_CODBCC"))
		::addField(VLR_ACRESCIMO 		, Iif(cType =="1", (csft_)->D1_VALACRS , (csft_)->D2_VALACRS ))         //::getFieldValue("D1_VALACRS", aItFlow), ::getFieldValue("D2_VALACRS", aItFlow)))
		::addField(IND_IPI_NDESTAC_DF	, (csft_)->F4_DESTACA )                                                //::getFieldValue("F4_DESTACA", aTypeFlow))
		::addField(VLR_FCP_UF_DEST		, aUFTaxes[VLR_FCP])
		::addField(VLR_ICMS_UF_DEST		, aUFTaxes[VLR_ICMS_DEST])
		::addField(VLR_ICMS_UF_ORIG		, aUFTaxes[VLR_ICMS_ORIG])


		if cType == "2"
			cCBENEF 	:= getCodCBENEF(cType,cSF3_, cSFT_)
			nICMDeson	:= getICMDeson (cType,cSF3_, cSFT_)
		endIf

		::addField(COD_BENEFICIO			,  cCBENEF)
		::addField(VLR_ABAT_NTRIBUTADO		,  nICMDeson)

		//::setItem(soma1(::getItem()))
		::setItem(soma1(cItem))

		::notFieldRequired()
	endIf

return 

/*/{Protheus.doc} getTribIcms

Regra do campo TRIB_ICMS

@author Daniel Braga
@since 31/10/2014

/*/
method getTribIcms(aTypeFlow) class DHLSafx08Age

	if (csft_)->f4_lficm  == 'T'                                 //::getFieldValue("F4_LFICM",aTypeFlow) == 'T'
		return "1"
	elseIf (csft_)->f4_lficm  == 'I'                            //::getFieldValue("F4_LFICM",aTypeFlow) == 'I'	
		return "2"
	elseIf (csft_)->f4_lficm  $ 'ONZB'                         //::getFieldValue("F4_LFICM",aTypeFlow) $ 'ONZB'	
		return "3"
	endIf
return ""

/*/{Protheus.doc} getTribIpi

Regra do campo TRIB_IPI

@author Daniel Braga
@since 31/10/2014

@param aTax, array, array com as informacoes 

/*/
method getTribIpi(aTax) class DHLSafx08Age

	if  (csft_)->ft_valipi > 0                               //::getFieldValue("FT_VALIPI",aTax) > 0
		return "1"
	elseIf  (csft_)->FT_ISENIPI > 0                         //::getFieldValue("FT_ISENIPI",aTax) > 0	
		return "2"
	elseIf  (csft_)->FT_OUTRIPI > 0                        //::getFieldValue("FT_OUTRIPI",aTax) > 0	
		return "3"
	endIf
return ""

/*/{Protheus.doc} getAuxTribIcms

Regra do campo TRIB_ICM_AUX

@author Daniel Braga
@since 31/10/2014

@param aTax, array, array com as informacoes 

/*/
method getAuxTribIcms(aTax)  class DHLSafx08Age

	if  (csft_)->FT_VALICM > 0                               //::getFieldValue("FT_VALICM",aTax) > 0
		return "1"
	elseIf  (csft_)->FT_ISENIPI > 0                         //::getFieldValue("FT_ISENIPI",aTax) > 0	
		return "2"
	elseIf  (csft_)->FT_OUTRIPI > 0                        //::getFieldValue("FT_OUTRIPI",aTax) > 0	
		return "3"
	endIf


return 

/*/{Protheus.doc} getValorOpIcms

Regra do campo VALOR_OP_ICMS

@author Daniel Braga
@since 31/10/2014

@param aTax, array, array com as informacoes 

/*/
method getValorOpIcms(aTax)  class DHLSafx08Age

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
method getIpiValorOp(aTax)  class DHLSafx08Age

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
method notFieldRequired() class DHLSafx08Age

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
method getPis(nField , xObj ) class DHLSafx08Age
	local cTypeCST	:= ""
	local nRet		:= 0

	cTypeCST := (cSFT_)->FT_CSTPIS         //::getFieldValue(::cPrefix+"_CSTPIS")

	if upper(alltrim(cTypeCST)) $ "01|06|56|"
		nRet := getValuesPis(nField, cTypeCST, self , xObj )
	endif

return(nRet)


/*
** Coleta valores PIS
*/
static function getValuesPis(nField, cTypeCST, oSelf, xObj) 
	local nRet := 0

	if nField == VLR_BASE_PIS[POS_FIELD]
		nRet := (csft_)->ft_basepis             //:= oSelf:getFieldValue(oSelf:cPrefix+"_BASEPIS")
	elseif nField == VLR_PIS[POS_FIELD] .and. !upper(alltrim(cTypeCST)) == "06"
		nRet := (csft_)->ft_valpis             //:= oSelf:getFieldValue(oSelf:cPrefix+"_VALPIS")
	elseif nField == VLR_ALIQ_PIS[POS_FIELD] .and. !upper(alltrim(cTypeCST)) == "06"
		nRet := (csft_)->ft_aliqpis          //:= oSelf:getFieldValue(oSelf:cPrefix+"_ALIQPIS")
	endif

return(nRet)


/*/{Protheus.doc} getCofins

Identifica campo e preenchimento de valores de acordo com regra de COFINS

@author Thiago Meschiatti
@since 23/03/15

/*/
method getCofins(nField , xObj ) class DHLSafx08Age
	local cTypeCST	:= ""
	local nRet		:= 0

	cTypeCST := (cSFT_)->FT_CSTCOF    //:= ::getFieldValue(::cPrefix+"_CSTCOF")

	if upper(alltrim(cTypeCST)) $ "01|06|56|"
		//nRet := getValuesCofins(nField, cTypeCST, self)
		nRet := getValuesCofins(nField, cTypeCST, self, xObj , ::cPrefix )		
	endif

return(nRet)


/*
** Coleta valores COFINS	
*/
static function getValuesCofins(nField, cTypeCST, oSelf) 
	local nRet := 0
	local cc := ""

	cc := _cPrefix

	if nField == VLR_BASE_COFINS[POS_FIELD]
		nRet := (CSFT_)->FT_BASECOF                   //oSelf:getFieldValue(oSelf:cPrefix+"_BASECOF")
	elseif nField == VLR_COFINS[POS_FIELD] .and. !upper(alltrim(cTypeCST)) == "06"
		nRet := (CSFT_)->FT_VALCOF                  //oSelf:getFieldValue(oSelf:cPrefix+"_VALCOF")
	elseif nField == VLR_ALIQ_COFINS[POS_FIELD] .and. !upper(alltrim(cTypeCST)) == "06"
		nRet := (CSFT_)->FT_ALIQCOF //            //oSelf:getFieldValue(oSelf:cPrefix+"_ALIQCOF")
	endif

return(nRet)	

/**
* Ajusta as Unidades de Medida dos Produtos
*/
static function unidadeMedida(cField, cType, aItFlow, oSelf , xObj)

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
	local cTipoNF		:= (cSF3_)->F3_TIPO   //oSelf:getFieldValue("F3_TIPO")
	local cAlias		:= ""
	local oSql 			:= IpSqlObject():newIpSqlObject()	
	local xRet			

	cCliFor := (cSF3_)->F3_CLIEFOR     //oSelf:getFieldValue("F3_CLIEFOR")
	cLoja	:= (cSF3_)->F3_LOJA       //oSelf:getFieldValue("F3_LOJA")

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


	cProduto := (csft_)->ft_produto                                   //oSelf:getFieldValue(oSelf:cPrefix+"_PRODUTO")
	cUM		 := iif(cType =="1", (csft_)->D1_UM , (csft_)->D2_UM )   //oSelf:getFieldValue("D1_UM",aItFlow), oSelf:getFieldValue("D2_UM",aItFlow))
	nQtd1UM	 := (cSFT_)->FT_QUANT                                   //oSelf:getFieldValue(oSelf:cPrefix+"_QUANT")
	nVlrTotal:= (cSFT_)->FT_TOTAL                                  //oSelf:getFieldValue(oSelf:cPrefix+"_TOTAL")
	nPrcUnit := (cSFT_)->FT_PRCUNIT                               //oSelf:getFieldValue(oSelf:cPrefix+"_PRCUNIT")		
	cSegUM	 := (csft_)->b1_segum                                //oSql:getFieldValue("SB1", "B1_SEGUM", "%SB1.XFILIAL% AND B1_COD = '"+cProduto+"'")

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

	if ((cType $ '2') .and. (alltrim(cCliFor+cLoja) == alltrim(cCliDep)) .and. (!(cSF3_)->F3_TIPO $ "DB"))
		cId 	:= iif(cType =="1", (csft_)->d1_zzid , (csft_)->d2_zzid ) // oSelf:getFieldValue("D1_ZZID",aItFlow), oSelf:getFieldValue("D2_ZZID",aItFlow))
		lIdRef	:= .t.
	endif

return (cId)

/**
* Obtém o código do beneficiário
**/
static function getCodCBENEF(cType,cSF3, cSFT)

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
	cDoc   		:= (cSF3)->F3_NFISCAL
	cSerie 		:= (cSF3)->F3_SERIE
	cCliFor		:= (cSF3)->F3_CLIEFOR
	cLoja		:= (cSF3)->F3_LOJA
	cProduto	:= (cSFT)->FT_PRODUTO
	cItem	  	:= (cSFT)->FT_ITEM
	cCFOP		:= (cSFT)->FT_CFOP

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
static function getICMDeson (cType,cSF3, cSFT)

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

	cFilCD2     := fwxFilial("CD2")	
	cDoc   		:= (cSF3)->F3_NFISCAL
	cSerie 		:= (cSF3)->F3_SERIE
	cCliFor		:= (cSF3)->F3_CLIEFOR
	cLoja		:= (cSF3)->F3_LOJA
	cProduto	:= (cSFT)->FT_PRODUTO
	cItem	  	:= padr((cSFT)->FT_ITEM, tamSx3("CD2_ITEM")[1], "")
	cCFOP		:= (cSFT)->FT_CFOP


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
