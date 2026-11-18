#include 'protheus.ch'
#include 'safx07.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} DHLSafx07Age

Respons‡vel pelas regras e montagem das informacoes para a exportacao
	
@author Thiago Meschiatti
@since 05/09/2016

/*/
user function _Safx07Age;return

class DHLSafx07Age from DHLSafx
	
	data lDocRef

	method newDHLSafx07Age(nTamPos) constructor 
	method getSql(nType,dDtFrom , dDtUntil)
	method addLine() 
	method notFieldRequired()
	method setDocRef()
	method hasDocRef()
	

endclass



method newDHLSafx07Age(nTamPos,oHeaderSql) class DHLSafx07Age
	lDocRef := .f.
	
return


/*/{Protheus.doc} setDocRef
Seta se documento possuí documento referenciado de Locação ou Comodato
@author Thiago Meschiatti
@since 05/09/2016

@type method
/*/
method setDocRef(lDocRef) class DHLSafx07Age
	::lDocRef := lDocRef
return


/*/{Protheus.doc} hasDocRef
Retorna se documento possui documento referenciado de Locação ou Comodato
@author Thiago Meschiatti
@since 05/09/2016

@type method
/*/
method hasDocRef() class DHLSafx07Age
return (::lDocRef)



/*/{Protheus.doc} getSql

Instrucao SQL para exportacao
	
@author Daniel Braga
@since 30/10/2014

@return string instrucao sql
/*/
method getSql(nType,dDtFrom , dDtUntil)  class DHLSafx07Age

	local cQuery 		:= ""
	
	default nType		:= 0
	default dDtFrom	:= stod("") 
	default dDtUntil	:= stod("")
	
	cQuery := " Select "
	cQuery += " case when f3_tipo in ( '5','6') then '"+GetNewPar("ZZ_SFXMOVR", SAFX_MOVIMENTO_NORMAL)+"' when f3_tipo in ( 'D' ,'B') then '"+SAFX_MOVIMENTO_DEVOLUCAO+"' else '"+SAFX_MOVIMENTO_NORMAL+"' end tipo, "   // INICIO Wellington 18/11/2026 - ramo de credito/debito; valor por ZZ_SFXMOVR, default = comportamento atual
	cQuery += " f3_cliefor, f3_loja, f3_nfiscal, f3_serie, f3_entrada,f3_dtcanc,	                                                  "
	cQuery += " sum(f3_valicm) f3_valicm, sum(f3_icmsret) f3_icmsret, sum(f3_isenicm) f3_isenicm, sum(f3_outricm) f3_outricm,      "
	cQuery += " sum(f3_isenipi) f3_isenipi, sum(f3_baseicm) f3_baseicm, sum(f3_outripi) f3_outripi, sum(f3_basimp6) f3_basimp6,    "
	cQuery += " sum(f3_valimp6) f3_valimp6, sum(f3_basimp5) f3_basimp5, sum(f3_valimp5) f3_valimp5, f3_credst,	                  "
	cQuery += " sum(f3_outricm) f3_outricm, sum(f3_baseps3) f3_baseps3, sum(f3_valps3) f3_valps3, sum(f3_despesa) f3_despesa, sum(f3_icmscom) f3_icmscom, "
	cQuery += " sum(f3_basecf3) f3_basecf3, sum(f3_valcf3) f3_valcf3, sum(f3_ipiobs) f3_ipiobs, "
	cQuery += " f3_codret, f3_especie, f3_emissao, f3_chvnfe, f3_estado, f3_tipo, f3_eminfe   "   
	cQuery += " from "+retSqlName("SF3")+" SF3 "	
	cQuery += " where  f3_filial ='"+xFilial("SF3")+"' and "
	if !Empty(dDtFrom) .and. !Empty(dDtUntil)
		cQuery += " f3_entrada between '"+dtos(dDtFrom)+"' and '"+dtos(dDtUntil)+"' and "
	else 
		cQuery += " f3_entrada ='"+dtos(date())+"' and "	
	endIf	 
	if nType == 1
		cQuery += " f3_cfo <= 4999 and "
	elseIf nType == 2
		cQuery += " f3_cfo >= 5000 and"
	endIf
	cQuery += " f3_serie <> 'INV' and "
	cQuery += " d_e_l_e_t_ =' ' and f3_observ != '"+ getMv("ZZ_TXTINUT")+"'"
	cQuery += " group by   f3_tipo, f3_cliefor, f3_loja, f3_nfiscal, f3_serie, f3_entrada, f3_dtcanc, f3_credst, f3_codret, f3_especie, f3_emissao, f3_chvnfe, "
	cQuery += " f3_estado, f3_tipo, f3_eminfe"
	cQuery += " order by f3_nfiscal, f3_serie"
	
return Upper(cQuery)


/*/{Protheus.doc} addLine

Cria a lina ‡ ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method  addLine() class DHLSafx07Age
	
	
	local aSupCus 	   	:= {}
	local aTax		   		:= {}
	local aInOutFlows  	:= {}
	local aItFlow	   		:= {}
	local aDocImp	   		:= {}
	local aTypeFlow	   	:= {}
	local aElectrPower	:= {}
	local aTelecom		:= {}
	local aSumItems		:= {}
	local aUFTaxes		:= {}
	local cType			:= ""
	local cCod		   		:= "" 
	local cBranch	   		:= ""
	local cDoc				:= ""
	local cSer				:= ""	
	local cHora			:= ""
	local cIndFisJur	:= ""
	local lDeleted		:= .f.
	
	if !empty(::aFields)
			
		cCod 		:= (cSF3_)->(F3_CLIEFOR)       //::getFieldValue("F3_CLIEFOR")
		cBranch 	:= (cSF3_)->(F3_LOJA)         //::getFieldValue("F3_LOJA")
		cDoc		:= (cSF3_)->(F3_NFISCAL)     //::getFieldValue("F3_NFISCAL")
		cSer    	:= (cSF3_)->(F3_SERIE)      //::getFieldValue("F3_SERIE")
		
		if !Empty((cSF3_)->(F3_DTCANC))        //!Empty(::getFieldValue("F3_DTCANC"))
			lDeleted := .t.
		endif
		
		cType 		:= (cSF3_)->ENT_SAI      //::getTypeDoc(cDoc, cSer,cCod,cBranch)
		cIndFisJur := ::getIndFisJur(cType, (cSF3_)->(F3_TIPO))   // INICIO Wellington 18/11/2026 - centralizado na classe base



		_UfTaxes		:= ::getUfTaxes(cType, (cSF3_)->(F3_TIPO), cSer, cDoc, cCod, cBranch , nil , .t.)


		aUfTaxes		:= aclone( _UfTaxes[ len(_UfTaxes) ] )
		
		//aSupCus 		:= ::getSupCusRecords(cIndFisJur,cCod,cBranch)
		//aTax    		:= ::getTaxRecord(cType,cDoc, cSer,cCod,cBranch)
		//aInOutFlows 	:= ::getFlowsRecord(cType,cDoc, cSer,cCod,cBranch, lDeleted)
		//aItFlow			:= ::getItemFlowsRecord(cType,cDoc,cSer,cCod,cBranch)
		//aDocImp			:= ::getImportAdd(cDoc,cSer,cCod,cBranch)	
		//aTypeFlow		:= ::getTypeInOutFlow(::getFieldValue("F4_COD",aItFlow))
		//aElectrPower	:= ::getEletricPower(cType,cDoc,cSer,cCod,cBranch)
		//aTelecom    	:= ::getTelecomAdd(cType,cDoc,cSer,cCod,cBranch) 
		aSumItems		:= ::getSumItems(cType,cDoc,cSer,cCod,cBranch)
		//aUFTaxes		:= ::getUfTaxes(cType, ::getFieldValue("F3_TIPO"), cSer, cDoc, cCod, cBranch)
		
	   //cHora	:= Iif(cType == "1" ,::getFieldValue("F1_HORNFE",aInOutFlow),::getFieldValue("F2_ZZHRSAI",aInOutFlow))
		
		vldDocRef(self, aInOutFlow, cType)

		
		
		
		cHora	:= Iif(cType == "1" , (csft_)->f1_HORNFE , (cSFT_)->f2_zzhrsai )
		
		::addField(COD_EMPRESA				, alltrim(GetNewPar("ZZ_IDEMPDW", "SOL")))
	    ::addField(COD_ESTAB				, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())))
	    ::addField(MOVTO_E_S				, iif(cType == "1", SAFX_DOCUMENTO_ENTRADA, SAFX_DOCUMENTO_SAIDA) )
	    ::addField(NORM_DEV					, (csf3_)->tipo )                //::getFieldValue("TIPO"))
	    ::addField(COD_DOCTO				, "NFE")
	    ::addField(IDENT_FIS_JUR			, (cSF3_)->ZZINDDW )           //Iif(cIndFisJur == "1",::getFieldValue("A2_ZZINDDW",aSupCus), ::getFieldValue("A1_ZZINDDW",aSupCus)))
	    ::addField(COD_FIS_JUR  			, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp()))+cCod+cBranch)
	    ::addField(NUM_DOCFIS   			, cDoc)
	    ::addField(SERIE_DOCFIS				, cSer)
	    ::addField(DATA_EMISSAO				, (cSF3_)->(F3_EMISSAO))    //::getFieldValue("F3_EMISSAO"))
	    ::addField(COD_CLASS_DOC_FIS		, '1')
	    ::addField(COD_MODELO				, "55")
	    ::addField(COD_CFO					, ' ')
	    ::addField(COD_NATUREZA_OP			, (csft_)->ft_NATOPER)   //::getFieldValue("FT_NATOPER",aTax))
	    ::addField(NUM_DOCFIS_REF			, (csft_)->ft_NFORI)    //::getFieldValue("FT_NFORI",aTax ))
	    ::addField(SERIE_DOCFIS_REF			, (csft_)->ft_SERORI)  //::getFieldValue("FT_SERORI",aTax))
	    ::addField(NUM_DEC_IMP_REF			, ' ' )               //::getFieldValue("CD5_DOCIMP",aDocImp))
	    ::addField(DATA_SAIDA_REC			, IIf(cType == "1",  (cSF3_)->(F3_ENTRADA), (cSF3_)->(F3_EMINFE)))  //::getFieldValue("F3_ENTRADA"), ::getFieldValue("F3_EMINFE")))
	    ::addField(INSC_ESTAD_SUBSTIT		, (cSF3_)->a1a2_INSCR )       //Iif(cIndFisJur == "1",::getFieldValue("A2_INSCR",aSupCus) , ::getFieldValue("A1_INSCR",aSupCus)) )
	    ::addField(VLR_PRODUTO				, ::getFieldValue("TOTAL",aSumItems))
	    ::addField(VLR_TOT_NOTA				, ::getFieldValue("VALCONT",aSumItems))
	    ::addField(VLR_FRETE				, ::getFieldValue("FRETE",aSumItems))
	    ::addField(VLR_SEGURO				, ::getFieldValue("SEGURO",aSumItems))
	    ::addField(VLR_OUTRAS				, (cSF3_)->(F3_DESPESA))            //::getFieldValue("F3_DESPESA"))
	    ::addField(VLR_DESCONTO				, ::getFieldValue("DESCONT",aSumItems))
	    ::addField(CONTRIB_FINAL			, Iif(cType == "1", "", iif((csf3_)->A1a2_TIPO=="F","S","N") ) ) //Iif(cType == "1", "", iif(::getFieldValue("A1a2_TIPO",aSupCus)=="F","S","N") ) )
	    ::addField(SITUACAO					, Iif(!Empty((cSF3_)->(F3_DTCANC)),"S","N") )                 //Iif(!Empty(::getFieldValue("F3_DTCANC")),"S","N") )
	    ::addField(COD_CONTA				, ' ')
	    ::addField(VLR_ALIQ_ICMS			, ' ')
	    ::addField(VLR_ICMS					, (cSF3_)->(F3_VALICM))                                      //::getFieldValue("F3_VALICM"))
	    ::addField(DIF_ALIQ_ICMS			, Iif( cType == "1" , ((cSF3_)->(F3_ICMSCOM) /(cSF3_)->(F3_BASEICM)) * 100 , 0)  )     //Iif( cType == "1" , (::getFieldValue("F3_ICMSCOM") / ::getFieldValue("F3_BASEICM")) * 100     , 0)  )
	    ::addField(COD_APUR_ICMS			, ' ') //TODO VER COM DIOGO
	    ::addField(VLR_ALIQ_IPI				, ' ' )
	    ::addField(VLR_IPI					, (cSF3_)->(F3_VALIPI ))        //::getFieldValue("F3_VALIPI"))
	    ::addField(COD_APUR_IPI				, ' ') //TODO VER COM DIOGO
	    ::addField(VLR_ALIQ_IR				, ' ')
	    ::addField(VLR_IR					, ::getFieldValue("VALIRR", aSumItems))
	    ::addField(VLR_ALIQ_SUB_ICMS		, ' ')
	    ::addField(VLR_SUBST_ICMS			, (cSF3_)->(F3_ICMSRET))        //::getFieldValue("F3_ICMSRET"))
	    ::addField(COD_APUR_SUB_ICMS		, ' ') //TODO VER COM DIOGO
	    ::addField(BASE_TRIB_ICMS			, Iif( (csft_)->f4_baseicm  == 0,(cSF3_)->(F3_BASEICM) , 0 ))   //Iif(::getFieldValue("F4_BASEICM",aTypeFlow) == 0,::getFieldValue("F3_BASEICM") , 0 ))
	    ::addField(BASE_ISEN_ICMS			, (cSF3_)->(F3_ISENICM))       //::getFieldValue("F3_ISENICM"))
	    ::addField(BASE_OUTR_ICMS			, (cSF3_)->(F3_OUTRICM))      //::getFieldValue("F3_OUTRICM"))
	    ::addField(BASE_REDU_ICMS			, (cSF3_)->(F3_BASEICM))     //::getFieldValue("F3_BASEICM"))
	    ::addField(BASE_TRIB_IPI			, ' ' )                     //Iif(::getFieldValue("F4_BASEIPI",aTypeFlow) == 0,::getFieldValue("F3_BASEIPI") , 0 ))
	    ::addField(BASE_ISEN_IPI			, (cSF3_)->(F3_ISENIPI))   //::getFieldValue("F3_ISENIPI"))
	    ::addField(BASE_OUTR_IPI			, (cSF3_)->(F3_OUTRIPI))  //::getFieldValue("F3_OUTRIPI"))
	    ::addField(BASE_REDU_IPI			, '' )                   //::getFieldValue("F3_BASEIPI"))
	    ::addField(BASE_TRIB_IR				, ::getFieldValue("BASEIRR", aSumItems))
	    ::addField(BASE_SUB_TRIB_ICMS		, ::getFieldValue("BRIMCS", aSumItems) )
	    ::addField(IND_TP_FRETE				, validFrete(cType, aInOutFlows, self))
	    ::addField(DAT_DI					,  ' ' )                   //::getFieldValue("CD5_DTDI",aDocImp))
	    ::addField(DAT_ESCR_EXTEMP			, posicione("CDT",1,xFilial("CDT")+cType+cDoc+cSer+cCod+cBranch,"CDT_DTAREC") )
	    ::addField(DAT_AUTENTIC				, Iif( !Empty((cSF3_)->(F3_DTCANC) ) ,(cSF3_)->(F3_DTCANC), (cSF3_)->(F3_ENTRADA) )  )//Iif( !Empty(::getFieldValue("F3_DTCANC") ) ,::getFieldValue("F3_DTCANC"), ::getFieldValue("F3_ENTDADA") )  )
	    ::addField(VLR_IPI_NDESTAC			, ' ')
	    ::addField(VLR_BASE_INSS			, ::getFieldValue("BASEINS", aSumItems))
	    ::addField(VLR_ALIQ_INSS			, ' ')
	    ::addField(VLR_INSS_RETIDO			, Iif(cType == "1", (cSFT_)->f1_inss      , 0 ))  //nao tem f2_inss //Iif(cType == "1",::getFieldValue("F1_INSS",aInOutFlows)		,::getFieldValue("F2_INSS",aInOutFlows)))
	    ::addField(VLR_OUTROS1				, Iif(cType == "1", (cSF3_)->(F3_ICMSCOM) ,0  ))                   //Iif(cType == "1",::getFieldValue("F3_ICMSCOM")		,0))
	    ::addField(DAT_FATO_GERADOR			, ' ')
	    ::addField(DAT_CANCELAMENTO			, Iif( !Empty((cSF3_)->(F3_DTCANC)),(cSF3_)->(F3_DTCANC), " "))   //Iif( !Empty(::getFieldValue("F3_DTCANC")),::getFieldValue("F3_DTCANC"), " "))
	    ::addField(NRO_AIDF_NF				, posicione("SFS",2,xFilial("SFS")+cSer+cDoc,"FS_AIDF") )
	    ::addField(COD_QUITACAO				, ' ')
	    ::addField(VLR_BASE_PIS				, (cSF3_)->(F3_BASIMP6) )      //::getFieldValue("F3_BASIMP6") )
	    ::addField(VLR_PIS					, (cSF3_)->(F3_VALIMP6) )     //::getFieldValue("F3_VALIMP6") )
	    ::addField(VLR_BASE_COFINS			, (cSF3_)->(F3_BASIMP5) )    //::getFieldValue("F3_BASIMP5") )
	    ::addField(VLR_COFINS				, (cSF3_)->(F3_VALIMP5) )   //::getFieldValue("F3_VALIMP5") )
	    ::addField(VLR_BASE_ISE_ICMSS   	, Iif( (cSF3_)->(F3_CREDST)== "1" ,(cSF3_)->(F3_ISENICM),"") )     //Iif( ::getFieldValue("F3_CREDST")== "1" ,::getFieldValue("F3_ISENICM"),"") )
	    ::addField(VLR_BASE_OUT_ICMSS		, Iif( (cSF3_)->(F3_CREDST)== "1" ,(cSF3_)->(F3_OUTRICM),"") )    //Iif( ::getFieldValue("F3_CREDST")== "1" ,::getFieldValue("F3_OUTRICM"),"") )
	    ::addField(IND_FISJUR_CPDIR			, " ")
	    ::addField(COD_FISJUR_CPDIR			, " ")
	    ::addField(IND_COMPRA_VENDA			, Iif( (csf3_)->TIPO =="N","VD",Iif( (csf3_)->TIPO $ "CPI","CP","") ))   //Iif( ::getFieldValue("TIPO") =="N","VD",Iif( ::getFieldValue("TIPO") $ "CPI","CP","") ))
	    ::addField(COD_TP_DISP_SEG			, " ")
	    //::addField(UF_DESTINO				, Iif(cType == "1",::getFieldValue("F1_EST",aInOutFlows),::getFieldValue("F2_EST",aInOutFlows) ))
	    ::addField(UF_DESTINO				, Iif(cType == "1",SM0->M0_ESTENT, (cSFT_)->f2_est ))
	    //::addField(INSC_ESTADUAL			, Iif(cType == "1",::getFieldValue("A2_INSCR",aSupCus)	,::getFieldValue("A1_INSCR",aSupCus)))   
	    ::addField(INSC_ESTADUAL			, ' ')	        
	    ::addField(OBS_INF_ADIC_NF			,  FwCutOff(::getMsgFlow(iif(cType=="1","E","S"),cDoc,cSer,cCod,cBranch)))
	    ::addField(VLR_BASE_PIS_ST			, (cSF3_)->(F3_BASEPS3) )   //::getFieldValue("F3_BASEPS3"))
	    ::addField(VLR_ALIQ_PIS_ST			, ' ')
	    ::addField(VLR_PIS_ST				, (cSF3_)->(F3_VALPS3) )      //::getFieldValue("F3_VALPS3"))
	    ::addField(VLR_BASE_COFINS_ST		, (cSF3_)->(F3_BASECF3) )    //::getFieldValue("F3_BASECF3"))
	    ::addField(VLR_ALIQ_COFINS_ST		, ' ')
	    ::addField(VLR_COFINS_ST			, (cSF3_)->(F3_VALCF3) )    //::getFieldValue("F3_VALCF3"))
	    ::addField(VLR_BASE_CSLL			, ::getFieldValue("BRETCSL",aSumItems))
	    ::addField(VLR_ALIQ_CSLL			, ' ')
	    ::addField(VLR_CSLL					, ::getFieldValue("VRETCSL",aSumItems))
	    ::addField(VLR_ALIQ_PIS				, ' ')
	    ::addField(VLR_ALIQ_COFINS			, ' ')
	    ::addField(BASE_ICMSS_SUBSTITUIDO	, iif(((FWUnitBusiness() == DHL_BUSINESSUNIT_SPL) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG)), ' ',;
	    									  Iif(cType == "1", (cSFT_)->F1_BRICMS , (cSFT_)->F2_BRICMS ) ))    //::getFieldValue("F1_BRICMS",aInOutFlows)		, ::getFieldValue("F2_BRICMS",aInOutFlows))))
	    ::addField(VLR_ICMSS_SUBSTITUIDO 	, iif(((FWUnitBusiness() == DHL_BUSINESSUNIT_SPL) .or. (FWUnitBusiness() == DHL_BUSINESSUNIT_PKG)), ' ',;
	    									  Iif(cType == "1", (cSFT_)->f1_icmsret , 0 )))   //::getFieldValue("F1_ICMSRET",aInOutFlows)	, 0)))   
	    ::addField(HORA_SAIDA				, '' )    //(cSF3_)->(F3_HORNFE))  ::getFieldValue("F3_HORNFE"))
	    ::addField(COD_SIT_DOCFIS			, Iif(!Empty((cSF3_)->(F3_DTCANC)),"02","00" ))
	    ::addField(COD_OBSERVACAO			, '')
	    ::addField(COD_SITUACAO_A			, ' ')  
	    ::addField(COD_SITUACAO_B			, ' ')
	    ::addField(COD_MUNICIPIO_ORIG		, ' ') // 2018/04/06 - no original nao estava vindo nada (cSF3_)->a1a2_est )      //Iif(cIndFisJur == "1",::getFieldValue("A1_EST",aSupCus),::getFieldValue("A2_EST",aSupCus)))
	    ::addField(COD_MUNICIPIO_DEST		, ' ') // 2018/04/06 - no original nao estava vindo nada (cSF3_)->a1a2_est )     //Iif(cIndFisJur == "1",::getFieldValue("A1_EST",aSupCus),::getFieldValue("A2_EST",aSupCus)))
	    ::addField(COD_CLASSE_CONSUMO		, ' ' )                  //::getFieldValue("FU_CLASCON",aElectrPower))
	    ::addField(IND_ESPECIF_RECEITA		, ' ' )                 //::getFieldValue("FU_TIPOREC",aElectrPower))
	    ::addField(NUM_CONTRATO				, ' ' )                //::getFieldValue("FX_TERMINA",aTelecom))
	    ::addField(COD_AREA_TERMINAL		, ' ' )               //::getFieldValue("FX_AREATER",aTelecom))
	    ::addField(COD_TP_UTIL				, ' ' )              //::getFieldValue("FX_TIPSERV",aTelecom))
	    ::addField(GRUPO_TENSAO				, ' ' )             //::getFieldValue("FU_GRUPT",aElectrPower))
	    ::addField(DATA_CONSUMO_INI			, ' ' )            //::getFieldValue("FX_DTINI",aTelecom))
	    ::addField(DATA_CONSUMO_FIM			, ' ' )           //::getFieldValue("FX_DTFIM",aTelecom))
	    ::addField(QTD_CONSUMO_TOTAL		, ' ' )          //::getFieldValue("FU_CONSTOT",aElectrPower))
	    ::addField(UF_CONSUMO				, ' ') // 2018/04/06 - no original nao estava vindo nada supergetmv("MV_ESTADO"))    //::getFieldValue("MV_ESTADO"))
	    ::addField(COD_MUNIC_CONSUMO		, ' ' )  
	    ::addField(COD_TP_RPS_NFE			, iif((cSF3_)->(F3_ESPECIE) $ 'RPS', (cSF3_)->(F3_ESPECIE), ' ' ))       //iif(::getFieldValue("F3_ESPECIE") $ 'RPS', ::getFieldValue("F3_ESPECIE"), ' ' ))
	    ::addField(NUM_RPS_NFE				, Iif( (cSF3_)->(F3_ESPECIE,) == "RPS",cDoc,"" ) )                      //Iif( ::getFieldValue("F3_ESPECIE") == "RPS",cDoc,"") )
	    ::addField(SERIE_RPS_NFE			, Iif( (cSF3_)->(F3_ESPECIE)  == "RPS",cSer,"" ) )                     //Iif( ::getFieldValue("F3_ESPECIE") == "RPS",cSer,""))
	    ::addField(DAT_EMISSAO_RPS_NFE		, ' ')
	    ::addField(NUM_AUTENTIC_NFE			, iif(!empty((cSF3_)->(F3_CHVNFE)),(cSF3_)->(F3_CHVNFE), Iif(cType == "1" , (cSFT_)->f1_chvnfe , (cSFT_)->f2_chvnfe )))    //iif(!empty(::getFieldValue("F3_CHVNFE")),::getFieldValue("F3_CHVNFE"), Iif(cType == "1" ,::getFieldValue("F1_CHVNFE", aInOutFlow), ::getFieldValue("F2_CHVNFE", aInOutFlow))))
	    ::addField(COD_MODELO_COTEPE		, "55")
	    ::addField(IND_NFE_DENEG_INUT		, Iif( (cSF3_)->(F3_CODRET) == "102" ,"2",Iif( (cSF3_)->(F3_CODRET) == "102","1","")  ) )    //Iif( ::getFieldValue("F3_CODRET") == "102" ,"2",Iif( ::getFieldValue("F3_CODRET") == "102","1","")  ) )
	    ::addField(HORA_EMISSAO				, iif( empty(cHora), ' ', strtran(cHora, ':', '')))
	    ::addField(IND_FIS_CONCES			, " ")
	    ::addField(COD_FIS_CONCES			, " ")
	    ::addField(COD_AUTENTIC				, ' ')
	    ::addField(VLR_PIS_RETIDO			, (csft_)->ft_VRETPIS)             //",aTax) )    //::getFieldValue("FT_VRETPIS",aTax) )
	    ::addField(VLR_COFINS_RETIDO		, (csft_)->ft_VRETCOF)            //",aTax) )   //::getFieldValue("FT_VRETCOF",aTax) )
	    ::addField(DAT_LANC_PIS_COFINS		, (cSF3_)->(F3_ENTRADA))         //::getFieldValue("F3_ENTRADA"))
	    ::addField(COD_SIT_PIS				, (csft_)->ft_CSTPIS)           //::getFieldValue("FT_CSTPIS",aTax))
	    ::addField(COD_SIT_COFINS			, (csft_)->ft_CSTCOF)          //::getFieldValue("FT_CSTCOF",aTax))
	    ::addField(IND_NAT_FRETE			, (csft_)->F4_INDNTFR )       //::getFieldValue("F4_INDNTFR",aTypeFlow))
	    ::addField(COD_NAT_REC				, (csft_)->F4_TNATREC )      //::getFieldValue("F4_TNATREC",aTypeFlow))
	    ::addField(IND_NAT_BASE_CRED		, (csft_)->F4_CODBCC )      //::getFieldValue("F4_CODBCC",aTypeFlow))
	    ::addField(VLR_ACRESCIMO			, Iif(cType == "1" ,0, (cSFT_)->f2_valacrs))      //Iif(cType == "1" ,0,::getFieldValue("F2_VALACRS",aInOutFlow)))
	    ::addField(IND_IPI_NDESTAC_DF 		, Iif( (csft_)->F4_LFIPI  == "T" ,"S","N") )     //Iif( ::getFieldValue("F4_LIPI",aTypeFlow) == "T" ,"S","N") )
	    ::addField(VLR_FCP_UF_DEST			, aUFTaxes[VLR_FCP])             //1
		::addField(VLR_ICMS_UF_DEST			, aUFTaxes[VLR_ICMS_DEST])      //2
		::addField(VLR_ICMS_UF_ORIG			, aUFTaxes[VLR_ICMS_ORIG])     //3
	   
	    ::notFieldRequired(cType,cCod,cBranch,cDoc,cSer,aSupCus,aTax,aInOutFlows,aItFlow,aDocImp,aTypeFlow,aElectrPoweraTelecom)	
	endIf

return 

method notFieldRequired(cType,cCod,cBranch,cDoc,cSer,aSupCus,aTax,aInOutFlows,aItFlow,aDocImp,aTypeFlow,aElectrPoweraTelecom) class DHLSafx07Age

	::addField(SUB_SERIE_DOCFIS, ' ')
    ::addField(S_SER_DOCFIS_REF, ' ')
    ::addField(VLR_BASE_DIF_FRETE, ' ')
    ::addField(COD_INDICE, ' ')
    ::addField(VLR_NOTA_CONV, ' ')
    ::addField(OBS_ICMS, ' ')
    ::addField(OBS_IPI, ' ')
    ::addField(VLR_ALIQ_ISS, ' ')
    ::addField(VLR_ISS, ' ')
    ::addField(OBS_SUBST_ICMS, ' ')
    ::addField(BASE_ISEN_IR, ' ')
    ::addField(BASE_TRIB_ISS, ' ')
    ::addField(BASE_ISEN_ISS, ' ')
    ::addField(BASE_REAL_TERC_ISS, ' ')
    ::addField(VLR_CONTAB_COMPL, ' ')
    ::addField(VLR_ALIQ_DESTINO, ' ')
    ::addField(IND_NF_ESPECIAL, ' ')
    ::addField(COD_MUNICIPIO, ' ')
    ::addField(IND_TRANSF_CRED, ' ')
    ::addField(VLR_TOM_SERVICO, ' ')
    ::addField(COD_TRIB_INT, ' ')
    ::addField(COD_REGIAO, ' ')
    ::addField(COD_CANAL_DISTRIB, ' ')
    ::addField(IND_CRED_ICMSS, ' ')
    ::addField(VLR_ICMS_NDESTAC, ' ')
    ::addField(VLR_MAT_APLIC_ISS, ' ')
    ::addField(VLR_SUBEMPR_ISS, ' ')
    ::addField(IND_MUNIC_ISS, ' ')
    ::addField(IND_CLASSE_OP_ISS, ' ')
    ::addField(NUM_PAGINA, ' ')
    ::addField(NUM_LIVRO, ' ')
    ::addField(DAT_VALID_DOC_AIDF, ' ')
  //::addField(IND_FATURA, validFat(Iif(cType == "1" ,::getFieldValue("F1_COND", aInOutFlow), ::getFieldValue("F2_COND", aInOutFlow)),;
  //  								Iif(cType == "1" ,::getFieldValue("D1_TES",aItFlow)		, ::getFieldValue("D2_TES",aItFlow))))
	::addField(IND_FATURA, validFat(Iif(cType == "1" , (cSFT_)->f1_cond , (cSFT_)->f2_cond ), nil ) )
    ::addField(NUM_SELO_CONT_ICMS, ' ')
    ::addField(BASE_ICMS_ORIGDEST, ' ')
    ::addField(VLR_ICMS_ORIGDEST, ' ')
    ::addField(ALIQ_ICMS_ORIGDEST, ' ')
    ::addField(VLR_DESC_CONDIC, ' ')
    ::addField(VLR_RED_BASE_ICMSS, ' ')
    ::addField(PERC_RED_BASE_ICMS, ' ')
    ::addField(IND_MEDIDAJUDICIAL, ' ')
    ::addField(UF_ORIG_DEST, Iif(cType == "1", (cSF3_)->(F3_ESTADO), SM0->M0_ESTENT))   //::getFieldValue("F3_ESTADO"), SM0->M0_ESTENT))
    ::addField(NUM_CTR_DISP, ' ')
    ::addField(SERIE_CTR_DISP, ' ')
    ::addField(SUB_SERIE_CTR_DISP, ' ')
    ::addField(IND_SITUACAO_ESP, ' ')
    ::addField(COD_PAGTO_INSS, ' ')
    ::addField(DAT_INTERN_AM, ' ')
    ::addField(IND_FISJUR_LSG, ' ')
    ::addField(COD_FISJUR_LSG, ' ')
    ::addField(COMPROV_EXP, ' ')
    ::addField(NUM_FINAL_CRT_DISP, ' ')
    ::addField(NUM_ALVARA, ' ')
    ::addField(NOTIFICA_SEFAZ, ' ')
    ::addField(INTERNA_SUFRAMA, ' ')
    ::addField(COD_AMPARO, ' ')
    ::addField(IND_NOTA_SERVICO, ' ')
    ::addField(COD_MOTIVO, ' ')
    ::addField(UF_AMPARO_LEGAL, ' ')
    ::addField(OBS_COMPL_MOTIVO, ' ')
    ::addField(IND_TP_RET, ' ')
    ::addField(IND_TP_TOMADOR, ' ')
    ::addField(COD_ANTEC_ST, ' ')
    ::addField(CNPJ_ARMAZ_ORIG, ' ')
    ::addField(UF_ARMAZ_ORIG, ' ')
    ::addField(INS_EST_ARMAZ_ORIG, ' ')
    ::addField(CNPJ_ARMAZ_DEST, ' ')
    ::addField(UF_ARMAZ_DEST, ' ')
    ::addField(INS_EST_ARMAZ_DEST, ' ')
    ::addField(VLR_BASE_INSS_2, ' ')
    ::addField(VLR_ALIQ_INSS_2, ' ')
    ::addField(VLR_INSS_RETIDO_2, ' ')
    ::addField(COD_PAGTO_INSS_2, ' ')
    ::addField(IND_SITUACAO_ESP_ST, ' ')
    ::addField(VLR_ICMSS_NDESTAC, ' ')
    ::addField(IND_DOCTO_REC, ' ')
    ::addField(DAT_PGTO_GNRE_DARJ, ' ')
    ::addField(COD_CEI, ' ')
    ::addField(VLR_JUROS_INSS, ' ')
    ::addField(VLR_MULTA_INSS, ' ')
    ::addField(DT_PAGTO_NF, ' ')
    ::addField(NUM_CONT_REDUC, ' ')
    ::addField(COD_CFPS, ' ')
    ::addField(NUM_LANCAMENTO, ' ')
    ::addField(VLR_MAT_PROP, ' ')
    ::addField(VLR_MAT_TERC, ' ')
    ::addField(VLR_BASE_ISS_RETIDO, ' ')
    ::addField(VLR_ISS_RETIDO, ' ')
    ::addField(VLR_DEDUCAO_ISS, ' ')
    ::addField(COD_MUNIC_ARMAZ_ORIG, ' ')
    ::addField(INS_MUNIC_ARMAZ_ORIG, ' ')
    ::addField(COD_MUNIC_ARMAZ_DEST, ' ')
    ::addField(INS_MUNIC_ARMAZ_DEST, ' ')
    ::addField(DATA_CONSUMO_LEIT, ' ')
    ::addField(QTD_CONTRATADA_PONTA, ' ')
    ::addField(QTD_CONTRATADA_FPONTA, ' ')
    ::addField(COD_OPER_ESP_ST, ' ')
    ::addField(ATO_NORMATIVO, ' ')
    ::addField(NUM_ATO_NORMATIVO, ' ')
    ::addField(ANO_ATO_NORMATIVO, ' ')
    ::addField(CAPITULACAO_NORMA, ' ')
    ::addField(VLR_OUTRAS_ENTID, ' ')
    ::addField(VLR_TERCEIROS, ' ')
    ::addField(IND_TP_COMPL_ICMS, ' ')
    ::addField(VLR_BASE_CIDE, ' ')
    ::addField(VLR_ALIQ_CIDE, ' ')
    ::addField(VLR_CIDE, ' ')
    ::addField(COD_VERIFIC_NFE, ' ')
    ::addField(DSC_SERVICO_NFE, ' ')
    ::addField(NUM_DV_NFE, ' ')
    ::addField(MODELO_NF_DMS, ' ')
    ::addField(IND_NF_REG_ESPECIAL, ' ')
    ::addField(VLR_ABAT_NTRIBUTADO, ' ')
    ::addField(VLR_OUTROS_ICMS, ' ')
    ::addField(VLR_BASE_INSS_RURAL, ' ')
    ::addField(VLR_ALIQ_INSS_RURAL, ' ')
    ::addField(VLR_INSS_RURAL, ' ')
    ::addField(COD_CLASSE_CONSUMO_SEF_PE, ' ')
    ::addField(IND_PIS_COFINS_EXTEMP, ' ')
    ::addField(IND_NF_CONTINGENCIA , ' ')
    ::addField(VLR_ANTECIP_TRIB , ' ')
    ::addField(DSC_RESERVADO1, ' ')
    ::addField(DSC_RESERVADO2, ' ')
    ::addField(DSC_RESERVADO3, ' ')
    ::addField(NUM_NFTS, ' ')
    ::addField(IND_NF_VENDA_TERCEIROS, ' ')
    ::addField(DSC_RESERVADO4, ' ')
    ::addField(DSC_RESERVADO5, ' ')
    ::addField(DSC_RESERVADO6, ' ')
    ::addField(DSC_RESERVADO7, ' ')
    ::addField(DSC_RESERVADO8, ' ')
    ::addField(IDENTIF_DOCFIS, ' ')
    ::addField(COD_SISTEMA_ORIG, ' ')
    ::addField(NUM_MAQ_REG, ' ')        
	::addField(NUM_CUPON_FISC, ' ')     
	::addField(IND_MODELO_CUPOM, ' ')   
	::addField(NUM_CONTROLE_DOCTO, ' ') 
	::addField(NUM_FIM_DOCTO,'')
	::addField(IND_VENDA_CANC,'')
	::addField(VLR_ANTECIP_TRIB,'')
	::addField(VLR_COMISSAO,'')
	::addField(OBS_DADOS_FATURA,'')
	::addField(IND_PORT_CAT44,'')
	::addField(COD_SCP,'')
	::addField(IND_PREST_SERV,'')			
	::addField(IND_TIPO_PROC,'')				
	::addField(NUM_PROC_JUR,'')			
	::addField(IND_DEC_PROC,'')				
	::addField(IND_TIPO_AQUIS,'')				
	::addField(VLR_DESC_GILRAT,'')				
	::addField(VLR_DESC_SENAR,'')				
	::addField(CNPJ_SUBEMPREITEIRO,'')			
	::addField(CNPJ_CPF_PROPRIETARIO_CNO,'')	
	::addField(VLR_RET_SUBEMPREITADO,'')		
	::addField(NUM_DOCFIS_SERV,'')				
	
return


/*
** Valida Tipo de de frete
*/
static function validFrete(cType, aInOutFlows, oSelf)
	local cTipoFrete	:= ""
	
	if cType == "1"
		if (cSFT_)->f1_tpfrete $ "C"            //oSelf:getFieldValue("F1_TPFRETE",aInOutFlows) $ 'C'
			cTipoFrete := '1'
		elseif (cSFT_)->f1_tpfrete $ "F"       //oSelf:getFieldValue("F1_TPFRETE",aInOutFlows) $ 'F'
			cTipoFrete := '2'
		else
			cTipoFrete := '0'
		endif
	else
		if (cSFT_)->f2_tpfrete $ "C"        //oSelf:getFieldValue("F2_TPFRETE",aInOutFlows) $ 'C'
			cTipoFrete := '1'
		elseif (cSFT_)->f2_tpfrete $ "F"   //oSelf:getFieldValue("F2_TPFRETE",aInOutFlows) $ 'F'
			cTipoFrete := '2'
		else
			cTipoFrete := '0'
		endif
	endif
return (cTipoFrete)

/*
** Valida Tipo de de frete
*/
static function validFat(cCond, cTes)
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cTipoInd	:= ""
	local cTipoCond	:= ""
	local cPrazo	:= ""		
	
	if empty(cCond)
		cTipoInd := SAFX07_FAT_ASEMPGTO
	else
		if (cSFT_)->f4_duplic  $ 'N'   //oSql:getFieldValue("SF4", "F4_DUPLIC", " %SF4.XFILIAL% AND F4_CODIGO = '"+cTes+"' ") $ 'N'
			cTipoInd := SAFX07_FAT_ASEMPGTO
		else 
			cTipoCond 	:= oSql:getFieldValue("SE4", "E4_TIPO", " %SE4.XFILIAL% AND E4_CODIGO = '"+cCond+"' ") 
			cPrazo		:= oSql:getFieldValue("SE4", "E4_COND", " %SE4.XFILIAL% AND E4_CODIGO = '"+cCond+"' ")
			if cTipoCond $ '1' .and. cPrazo $ '00|0|01|1'
				cTipoInd := SAFX07_FAT_AVISTA
			else
				cTipoInd := SAFX07_FAT_APRAZO
			endif
		endif
	endif

return (cTipoInd)

/*
** Valida se Doc. possui referencia de locação ou comodato
*/
static function vldDocRef(oSelf, aInOutFlow, cType)
	
	if (cType == "1") 
		oSelf:setDocRef(.f.)
	else
		//if empty(oSelf:getFieldValue("F2_ZZNFTER",aInOutFlow)) // JJ 2018/06/15
		IF EMPTY((cSFT_)->F2_ZZNFTER)
			oSelf:setDocRef(.f.)
		else
			oSelf:setDocRef(.t.)
		endif
	endif 
	
return
