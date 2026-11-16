#include 'totvs.ch'
#include 'safx.ch'
#include 'safx116.ch'
#include 'dhl.ch'

#DEFINE POS_FIELD 1
#DEFINE POS_SIZE  2

/*/{Protheus.doc} DHLSafx116Age

Respons‡vel pelas regras e montagem das informacoes para a exportacao
	
@author Thiago Meschiatti
@since 05/09/2016

/*/

user function _AGL116;return

class DHLAGL116 from DHLSafx

	data cPrefix as String

	method newDHLAGL116(nTamPos,oHeaderSql) constructor
	
	method getSql()
	method addLine() 
	method getMsgF3()
	method validDocRef()
	method getChvRef()

endclass

//-----------------------------------------------------------------
method newDHLAGL116(nTamPos,oHeaderSql) class DHLAGL116
	::initialize(nTamPos,oHeaderSql)
return

/*/{Protheus.doc} getSql

Instrucao SQL para exportacao
	
@author Daniel Braga
@since 30/10/2014

@return string instrucao sql
/*/
method getSql(cCusSupDv,cBranch,cDocOri,cSerOri,cItenOri,lCobert,oDHLSafx07,cOrigem) class DHLAGL116


	local cAlias	:= ""
	local cQuery	:= ""
	local cType		:= ""      
	
	default lCobert := .f.
	default cOrigem := ""
	
	cType := ::getTypeDoc(cDocOri, cSerOri, cCusSupDv, cBranch, lCobert,cOrigem)  
	
	if oDHLSafx07:hasDocRef()
		::cPrefix := PrefixoCpo("SZ8")
		cQuery 	:=  "select * from "+retSqlName("SZ8")+" where "
		cQuery	+=  "z8_filial	= '"+xFilial("SZ8")+"' and "
		cQuery 	+=  "z8_doc		='"+cDocOri+"' and "
		cQuery 	+=  "z8_serie 	='"+cSerOri+"' and "
		cQuery 	+=  "z8_cliente	='"+cCusSupDv+"' and "
		cQuery 	+=  "z8_loja 	='"+cBranch+"' and "
		cQuery 	+=  "d_e_l_e_t_= ' ' "
	else     
		
		cAlias := Iif(cType == "1","SD1" ,"SD2" )
		::cPrefix:= PrefixoCpo(cAlias)
		cQuery :=  "select * from "+retSqlName(cAlias)+" where "
		cQuery	+=  ::cPrefix+"_filial= '"+xFilial(cAlias)+"' and "
		cQuery +=  ::cPrefix+"_doc		='"+cDocOri+"' and "
		cQuery +=  ::cPrefix+"_serie 	='"+cSerOri+"' and "
		cQuery +=  ::cPrefix+"_item 	='"+cItenOri+"' and "
		if cAlias == "SD1" .and. !empty(cCusSupDv)
			cQuery +=  ::cPrefix+"_fornece 	='"+cCusSupDv+"' and "
			cQuery +=  ::cPrefix+"_loja 	='"+cBranch+"' and "
		else
			if  !empty(cCusSupDv)
				cQuery +=  ::cPrefix+"_cliente 	='"+cCusSupDv+"' and "
				cQuery +=  ::cPrefix+"_loja 	='"+cBranch+"' and "
			endif
		endif
		cQuery +=  "d_e_l_e_t_= ' ' "
	endif
	 
return Upper(cQuery)


/*/{Protheus.doc} addLine

Cria a lina ‡ ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine(lCobert, oDHLSafx07, xobj )   class DHLAGL116

	local cType			:= ""
	local cCod		   		:= "" 
	local cBranch	   		:= ""
	local cCodRef			:= ""
	local cBranRef			:= ""
	local cDoc				:= ""
	local cSer				:= ""	
	local cIndFisJur		:= ""
	local cIndRef			:= ""
	local cMsg				:= ""
	local aSupCus			:= {}
	local aSupRef			:= {}
	local cChvRefer			:= ""
	local cxprefix			:= ""
	
	default lCobert := .f.

	cCod 		:= (cSF3_)->(F3_CLIEFOR)
	cBranch 	:= (cSF3_)->(F3_LOJA)
	cDoc		:= (cSF3_)->(F3_NFISCAL)
	cSer    	:= (cSF3_)->(F3_SERIE)
	cType		:= (cSF3_)->ENT_SAI //::getTypeDoc(cDoc, cSer, cCod, cBranch)
	cIndFisJur	:= Iif( cType =="1",Iif((cSF3_)->(F3_TIPO) $ "DB" ,"2","1" ) , Iif(!(cSF3_)->(F3_TIPO) $ "DB" ,"2","1" )      ) //Iif( cType =="1",Iif(::getFieldValue("F3_TIPO") $ "DB" ,"2","1" ) , Iif(!::getFieldValue("F3_TIPO") $ "DB" ,"2","1" )      )
	
	//aSupCus		:= ::getSupCusRecords(cIndFisJur,cCod,cBranch)
	cMsg		:= ::getMsgF3()
	
	If oDHLSafx07:hasDocRef()
		cChvRefer	:= xObj:getValue(::cPrefix+"_CHVNFE") //::getFieldValue(::cPrefix+"_CHVNFE")
	Else
		cChvRefer	:= ::getChvRef(	cType,;
					xObj:getValue(::cPrefix+"_DOC"),;
					xObj:getValue(::cPrefix+"_SERIE"),;
					Iif(cType =="1", xObj:getValue(::cPrefix+"_CLIENTE") , xObj:getValue(::cPrefix+"_FORNECE")),;
					xObj:getValue(::cPrefix+"_LOJA"))
	Endif
	
	if lCobert
		aSupRef := ::getSupCusRecords(iif(cIndFisJur == '1','2','1'),xObj:getValue(::cPrefix+"_FORNECE"),xObj:getValue(::cPrefix+"_LOJA"))
		cIndRef	:= (cSF3_)->ZZINDDW // ::getFieldValue("A1_ZZINDDW",aSupRef)
	else
		if oDHLSafx07:hasDocRef()
			cCodRef 	:= xObj:getValue(::cPrefix+"_CLIENTE")
			cBranRef 	:= xObj:getValue(::cPrefix+"_LOJA")
			aSupRef		:= ::getSupCusRecords(cIndFisJur,cCodRef,cBranRef)
			cIndRef		:= (cSF3_)->ZZINDDW  //::getFieldValue("A1_ZZINDDW",aSupRef)
		else
			cCodRef 	:= Iif(cType =="1", xObj:getValue(::cPrefix+"_CLIENTE") , xObj:getValue(::cPrefix+"_FORNECE"))
			cBranRef 	:= xObj:getValue(::cPrefix+"_LOJA")
			aSupRef		:= ::getSupCusRecords(cIndFisJur,cCodRef,cBranRef)
			cIndRef		:= (cSF3_)->ZZINDDW  // Iif(cIndFisJur == "1",::getFieldValue("A2_ZZINDDW",aSupRef), ::getFieldValue("A1_ZZINDDW",aSupRef))
		endif
	endif
		
	::addField(COD_EMPRESA			, alltrim(GetNewPar("ZZ_IDEMPDW", "SOL")))
	::addField(COD_ESTAB			, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())))
	::addField(DATA_FISCAL			, Iif(cType == "1" ,(cSF3_)->(F3_ENTRADA),(cSF3_)->(F3_EMISSAO) ))
	// ::addField(MOVTO_E_S			, Iif(cType =="1", SAFX_DOCUMENTO_ENTRADA, SAFX_DOCUMENTO_SAIDA))
	::addField(MOVTO_E_S			, iif(cType == "1" .AND. alltrim((csf3_)->F3_CFO) $ alltrim(GetNewPar("ZZ_CFOSFX7")),SAFX_DOC_EMIT_ESTABELEC,iif(cType == "1" , SAFX_DOCUMENTO_ENTRADA, SAFX_DOCUMENTO_SAIDA)))
	::addField(NORM_DEV				, (cSF3_)->TIPO)
	::addField(COD_DOCTO			, "NFE")
	::addField(IND_FIS_JUR			, (cSF3_)->ZZINDDW ) //Iif(cIndFisJur == "1",::getFieldValue("A2_ZZINDDW",aSupCus), ::getFieldValue("A1_ZZINDDW",aSupCus)))
	::addField(COD_FIS_JUR			, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp()))+cCod+cBranch)
	::addField(NUM_DOCFIS			, (cSF3_)->(F3_NFISCAL))
	::addField(SERIE_DOCFIS			, (cSF3_)->(F3_SERIE))
	::addField(SUB_SERIE_DOCFIS		, "")	
	::addField(COD_OBS_LANCTO_FISCAL, ::getCodTypeMsg("1")  ) 
	::addField(NUM_DOCFIS_REF		, xObj:getValue(::cPrefix+"_DOC") )
	::addField(SERIE_DOCFIS_REF		, xObj:getValue(::cPrefix+"_SERIE") )
	::addField(SUB_SERIE_DOCFIS_REF	, "")
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_AGE .and. lCobert)
		::addField(MOVTO_E_S_REF		, Iif(cType =="1", SAFX_DOCUMENTO_ENTRADA,  SAFX_DOCUMENTO_SAIDA))
	elseif (FWUnitBusiness() == DHL_BUSINESSUNIT_AGL .and. lCobert)
		::addField(MOVTO_E_S_REF		, Iif(cType =="1", SAFX_DOCUMENTO_ENTRADA,  SAFX_DOCUMENTO_SAIDA))
	elseif (FWUnitBusiness() == DHL_BUSINESSUNIT_REP .and. lCobert)
		::addField(MOVTO_E_S_REF		, Iif(cType =="1", SAFX_DOCUMENTO_ENTRADA,  SAFX_DOCUMENTO_SAIDA))
	else
		::addField(MOVTO_E_S_REF		, Iif(cType =="1", SAFX_DOCUMENTO_SAIDA, SAFX_DOCUMENTO_ENTRADA ))
	endif
	::addField(IND_FIS_JUR_REF		, cIndRef)
	
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_AGE .and. lCobert)

		::addField(COD_FIS_JUR_REF		, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())) + Iif(cType =="1", xObj:getValue(::cPrefix+"_FORNECE") + xObj:getValue(::cPrefix+"_LOJA"), xObj:getValue(::cPrefix+"_CLIENTE")))
		::addField(DATA_FISCAL_REF		, Iif(cType =="1", xObj:getValue("D1_EMISSAO"), xObj:getValue("D2_EMISSAO") ))
	
	elseif (FWUnitBusiness() == DHL_BUSINESSUNIT_REP .and. lCobert)

		::addField(COD_FIS_JUR_REF		, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())) + Iif(cType =="1", xObj:getValue(::cPrefix+"_FORNECE") + xObj:getValue(::cPrefix+"_LOJA"), xObj:getValue(::cPrefix+"_CLIENTE")))
		::addField(DATA_FISCAL_REF		, Iif(cType =="1", xObj:getValue("D1_EMISSAO"), xObj:getValue("D2_EMISSAO") ))
	
	elseif (FWUnitBusiness() == DHL_BUSINESSUNIT_AGL .and. lCobert)

		::addField(COD_FIS_JUR_REF		, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())) + Iif(cType =="1", xObj:getValue(::cPrefix+"_FORNECE") + xObj:getValue(::cPrefix+"_LOJA"), xObj:getValue(::cPrefix+"_CLIENTE")))
		::addField(DATA_FISCAL_REF		, Iif(cType =="1", xObj:getValue("D1_EMISSAO"), xObj:getValue("D2_EMISSAO") ))
	
	else
		if oDHLSafx07:hasDocRef()
		
			cxprefix	:= ::cPrefix
			IF cxprefix = "Z8"
				::addField(COD_FIS_JUR_REF		, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())) + xObj:getValue(::cPrefix+"_CLIEMIT") + xObj:getValue(::cPrefix+"_LOJA"))
			ELSE
				::addField(COD_FIS_JUR_REF		, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())) + xObj:getValue(::cPrefix+"_CLIENTE") + xObj:getValue(::cPrefix+"_LOJA"))
			ENDIF
			::addField(DATA_FISCAL_REF		, xObj:getValue(::cPrefix+"_EMISSAO"))
		else
			::addField(COD_FIS_JUR_REF		, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())) + Iif(cType =="1", xObj:getValue(::cPrefix+"_CLIENTE"), xObj:getValue(::cPrefix+"_FORNECE")) + xObj:getValue(::cPrefix+"_LOJA"))
			::addField(DATA_FISCAL_REF		, Iif(cType =="1" ,xObj:getValue("D2_EMISSAO"),xObj:getValue("D1_EMISSAO") ))
		endif
		
	endif
	::addField(COD_MODELO_REF		, '55') 
    ::addField(NUM_AUTENTIC_NFE		, cChvRefer)

return 


/*/{Protheus.doc} getMsgF3

Busca informações do SF3
	
@author Thiago Meschiatti
@since 03/11/2015

/*/
method getMsgF3()  class DHLAGL116
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cMsg 		:= ""
	local cQuery 	:= ""
	
	cQuery += " SELECT F3_OBSERV "
	cQuery += " FROM %SF3.SQLNAME% "	
	cQuery += " WHERE  "
	cQuery += " 	%SF3.XFILIAL% "
	cQuery += " 	AND %SF3.NOTDEL% "
	cQuery += " 	AND F3_NFISCAL	= '" + (cSF3_)->(F3_NFISCAL) + "' "
	cQuery += " 	AND F3_SERIE	= '" + (cSF3_)->(F3_SERIE) 	 + "' "
	cQuery += " 	AND F3_CLIEFOR	= '" + (cSF3_)->(F3_CLIEFOR) 	 + "' "
	cQuery += " 	AND F3_LOJA		= '" + (cSF3_)->(F3_LOJA) 	 + "' "
	
	oSql:newAlias(cQuery)
	
	while oSql:notIsEof()
		if !alltrim(oSql:getValue("F3_OBSERV")) $ cMSg .and. !empty(oSql:getValue("F3_OBSERV"))
			cMsg += alltrim(oSql:getValue("F3_OBSERV")) + " / "
		endif
		oSql:skip()
	enddo
	
	if !empty(cMsg)
		cMsg :=  substr(cMsg, 1, len(cMsg)-3)
	endif
	
	oSql:close()
return (cMsg)


method validDocRef(aDocsRef, aFields)  class DHLAGL116
	local lRet	:= .f.
	local nPos	:= 0
	
	nPos := aScan(	aDocsRef, { |x| AllTrim( x[NUM_DOCFIS[POS_FIELD]] + x[SERIE_DOCFIS[POS_FIELD]] + x[COD_OBS_LANCTO_FISCAL[POS_FIELD]] + x[NUM_DOCFIS_REF[POS_FIELD]] + ;
		 		x[NUM_DOCFIS_REF[POS_FIELD]] + x[COD_FIS_JUR[POS_FIELD]] + x[COD_FIS_JUR_REF[POS_FIELD]]) == ;		 		
				AllTrim( aFields[NUM_DOCFIS[POS_FIELD]] + aFields[SERIE_DOCFIS[POS_FIELD]] + aFields[COD_OBS_LANCTO_FISCAL[POS_FIELD]] + aFields[NUM_DOCFIS_REF[POS_FIELD]] + ;
		 		aFields[NUM_DOCFIS_REF[POS_FIELD]] + aFields[COD_FIS_JUR[POS_FIELD]] + aFields[COD_FIS_JUR_REF[POS_FIELD]]) } )
	lRet := nPos > 0 
return(lRet)

/*/{Protheus.doc} getMsgF3

Busca informações do SF3
	
@author Thiago Meschiatti
@since 03/11/2015

/*/
static function getIndRef(cIndFisJur, cDocRef, cSerRef, oSelf)
	local cRet 		:= ''
	local cQuery 	:= ''
	local cType		:= ''
	local oSql		:= IpSqlObject():newIpSqlObject()
	local aSupRef	:= {}
	
	cQuery += " SELECT F3_CLIEFOR, F3_LOJA, F3_CFO "
	cQuery += " FROM %SF3.SQLNAME% "
	cQuery += " WHERE "
	cQuery += " 	%SF3.XFILIAL% "
	cQuery += " 	AND F3_NFISCAL = '" + cDocRef + "' AND F3_SERIE = '" + cSerRef + "' "
	oSql:newAlias(cQuery)
	
	if oSql:hasRecords()
		cType := iif(val(oSql:getValue("F3_CFO")) < 5000 , "1","2" )
		if cType $ '1'
			cIndFisJur := '2'
		else
			if oself:getFieldValue("F3_TIPO") $ 'DB'
				cIndFisJur := '1'
			else
				cIndFisJur := '2'
			endif
		endif
		aSupRef	:= oSelf:getSupCusRecords(cIndFisJur,oSql:getValue("F3_CLIEFOR"), oSql:getValue("F3_LOJA"))
		
		cRet 	:= Iif(cIndFisJur == "1",oSelf:getFieldValue("A2_ZZINDDW",aSupRef), oSelf:getFieldValue("A1_ZZINDDW",aSupRef))
	endif
	
	oSql:close()
	
	
return(cRet)


/*/{Protheus.doc} getChvRef

Busca informações da Chave da NF Referenciada
	
@author Augusto Krejci Bem-Haja
@since 08/05/2017

/*/
method getChvRef(cType,cDoc,cSerie,cCliFor,cLoja)  class DHLAGL116
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cChave	:= ""
	local cCampo	:= ""
	local cQuery 	:= ""
	
	If cType == "1"
		cCampo = "F2_CHVNFE"
		cQuery += " SELECT F2_CHVNFE "
		cQuery += " FROM %SF2.SQLNAME% "	
		cQuery += " WHERE  "
		cQuery += " 	%SF2.XFILIAL% "
		cQuery += " 	AND %SF2.NOTDEL% "
		cQuery += " 	AND F2_DOC		= '" + cDoc + "' "
		cQuery += " 	AND F2_SERIE	= '" + cSerie + "' "
	ElseIf cType == "2"
		cCampo = "F1_CHVNFE"
		cQuery += " SELECT F1_CHVNFE "
		cQuery += " FROM %SF1.SQLNAME% "	
		cQuery += " WHERE  "
		cQuery += " 	%SF1.XFILIAL% "
		cQuery += " 	AND %SF1.NOTDEL% "
		cQuery += " 	AND F1_DOC		= '" + cDoc + "' "
		cQuery += " 	AND F1_SERIE	= '" + cSerie + "' "
		cQuery += " 	AND F1_FORNECE	= '" + cCliFor + "' "
		cQuery += " 	AND F1_LOJA		= '" + cLoja + "' "
	Endif
	
	oSql:newAlias(cQuery)
	
	If oSql:notIsEof()
		 cChave := alltrim(oSql:getValue(cCampo))
	endif
	
	oSql:close()
return (cChave)
