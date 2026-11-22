#include 'totvs.ch'
#include 'safx.ch'
#include 'safx116.ch'
#include 'dhl.ch'

#DEFINE POS_FIELD 1
#DEFINE POS_SIZE  2

/*/{Protheus.doc} DHLSafx116Dis

Respons‡vel pelas regras e montagem das informacoes para a exportacao
	
@author Daniel Braga
@since 30/10/2014

/*/

user function _Saf116Dis;return

class DHLSafx116Dis from DHLSafx

	data cPrefix as String

	method newDHLSafx116Dis(nTamPos,oHeaderSql) constructor
	
	method getSql()
	method addLine() 
	method getMsgF3()
	method validDocRef()
	method getChvRef()

endclass

//-----------------------------------------------------------------
method newDHLSafx116Dis(nTamPos,oHeaderSql) class DHLSafx116Dis
	::initialize(nTamPos,oHeaderSql)
return

/*/{Protheus.doc} getSql

Instrucao SQL para exportacao
	
@author Daniel Braga
@since 30/10/2014

@return string instrucao sql
/*/
method getSql(cCusSupDv,cBranch,cDocOri,cSerOri,cItenOri,lCobert) class DHLSafx116Dis


	local cAlias	:= ""
	local cQuery	:= ""
	local cType		:= ::getTypeDoc(cDocOri, cSerOri, cCusSupDv, cBranch, lCobert)       
	
	default lCobert := .f.     
	
	cAlias := Iif(cType == "1","SD1" ,"SD2" )
	::cPrefix:= PrefixoCpo(cAlias)
	
	cQuery :=  "select * from "+retSqlName(cAlias)+" where "
	cQuery	+=  ::cPrefix+"_filial= '"+xFilial(cAlias)+"' and "
	cQuery +=  ::cPrefix+"_doc		='"+cDocOri+"' and "
	cQuery +=  ::cPrefix+"_serie 	='"+cSerOri+"' and "
	cQuery +=  ::cPrefix+"_item 	='"+cItenOri+"' and "
	cQuery +=  "d_e_l_e_t_= ' ' "
	 
return Upper(cQuery)


/*/{Protheus.doc} addLine

Cria a lina ‡ ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine(lCobert)   class DHLSafx116Dis

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
	local cCodF2			:= ""
	local lDeleted			:= .f.
	
	default lCobert := .f.

	cCod 		:= ::getFieldValue("F3_CLIEFOR")
	cBranch 	:= ::getFieldValue("F3_LOJA")
	cDoc		:= ::getFieldValue("F3_NFISCAL")
	cSer    	:= ::getFieldValue("F3_SERIE")
	cType		:= ::getTypeDoc(cDoc, cSer, cCod, cBranch)
	cIndFisJur := ::indFisJurPorTipo(cType, ::getFieldValue("F3_TIPO"))   // INICIO Wellington 18/11/2026 - centralizado na classe base

	if !Empty(::getFieldValue("F3_DTCANC"))
		lDeleted := .t.
	endif
	
	if cType <> "1"
		cCodF2  :=  f2field(cDoc, cSer , cCod , "F2_CLIENT" , .T. , lDeleted )
		IF empty(ccodf2)
			ccodf2 := ccod
		endif
	endif

	
	aSupCus		:= ::getSupCusRecords(cIndFisJur,cCod,cBranch)
	cMsg		:= ::getMsgF3()
	cChvRefer	:= ::getChvRef(	cType,;
								::getFieldValue(::cPrefix+"_DOC"),;
								::getFieldValue(::cPrefix+"_SERIE"),;
								Iif(cType =="1", ::getFieldValue(::cPrefix+"_CLIENTE") , ::getFieldValue(::cPrefix+"_FORNECE")),;
								::getFieldValue(::cPrefix+"_LOJA"))
	
	if lCobert
		aSupRef := ::getSupCusRecords(iif(cIndFisJur == '1','2','1'),::getFieldValue(::cPrefix+"_FORNECE"),::getFieldValue(::cPrefix+"_LOJA"))
		cIndRef	:= ::getFieldValue("A1_ZZINDDW",aSupRef)
	else
		cCodRef 	:= Iif(cType =="1", ::getFieldValue(::cPrefix+"_CLIENTE") , ::getFieldValue(::cPrefix+"_FORNECE"))
		cBranRef 	:= ::getFieldValue(::cPrefix+"_LOJA")
		aSupRef		:= ::getSupCusRecords(cIndFisJur,cCodRef,cBranRef)
		cIndRef		:= Iif(cIndFisJur == "1",::getFieldValue("A2_ZZINDDW",aSupRef), ::getFieldValue("A1_ZZINDDW",aSupRef))
	endif
		
	::addField(COD_EMPRESA			, alltrim(GetNewPar("ZZ_IDEMPDW", "SOL")))
	::addField(COD_ESTAB			, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())))
	::addField(DATA_FISCAL			, Iif(cType == "1" ,::getFieldValue("F3_ENTRADA"),::getFieldValue("F3_EMISSAO") ))
	::addField(MOVTO_E_S			, Iif(cType =="1", SAFX_DOCUMENTO_ENTRADA, SAFX_DOCUMENTO_SAIDA))
	::addField(NORM_DEV				, ::getFieldValue("TIPO"))
	::addField(COD_DOCTO			, "NFE")
	::addField(IND_FIS_JUR			, Iif(cIndFisJur == "1",::getFieldValue("A2_ZZINDDW",aSupCus), ::getFieldValue("A1_ZZINDDW",aSupCus)))
	::addField(COD_FIS_JUR			, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp()))+if(cType=="1",cCod,cCodF2)+cBranch)
	::addField(NUM_DOCFIS			, ::getFieldValue("F3_NFISCAL"))
	::addField(SERIE_DOCFIS			, ::getFieldValue("F3_SERIE"))
	::addField(SUB_SERIE_DOCFIS		, "")	
	::addField(COD_OBS_LANCTO_FISCAL, ::getCodTypeMsg("1")) 
	::addField(NUM_DOCFIS_REF		, ::getFieldValue(::cPrefix+"_DOC") )
	::addField(SERIE_DOCFIS_REF		, ::getFieldValue(::cPrefix+"_SERIE") )
	::addField(SUB_SERIE_DOCFIS_REF	, "")
	if (lCobert)
		::addField(MOVTO_E_S_REF		, Iif(cType =="1", SAFX_DOCUMENTO_ENTRADA,  SAFX_DOCUMENTO_SAIDA))
	else
		::addField(MOVTO_E_S_REF		, Iif(cType =="1", SAFX_DOCUMENTO_SAIDA, SAFX_DOCUMENTO_ENTRADA ))
	endif
	::addField(IND_FIS_JUR_REF		, cIndRef)
	if (lCobert)
		::addField(COD_FIS_JUR_REF		, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())) + Iif(cType =="1", ::getFieldValue(::cPrefix+"_FORNECE") + ::getFieldValue(::cPrefix+"_LOJA"), ::getFieldValue(::cPrefix+"_CLIENTE")))
		::addField(DATA_FISCAL_REF		, Iif(cType =="1", ::getFieldValue("D1_EMISSAO"), ::getFieldValue("D2_EMISSAO") ))
	else
		::addField(COD_FIS_JUR_REF		, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())) + Iif(cType =="1", ::getFieldValue(::cPrefix+"_CLIENTE"), ::getFieldValue(::cPrefix+"_FORNECE")) + ::getFieldValue(::cPrefix+"_LOJA"))
		::addField(DATA_FISCAL_REF		, Iif(cType =="1" ,::getFieldValue("D2_EMISSAO"),::getFieldValue("D1_EMISSAO") ))
	endif
	::addField(COD_MODELO_REF		, '55')
	::addField(NUM_AUTENTIC_NFE		, cChvRefer) 

return 


/*/{Protheus.doc} getMsgF3

Busca informações do SF3
	
@author Thiago Meschiatti
@since 03/11/2015

/*/
method getMsgF3()  class DHLSafx116Dis
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cMsg 		:= ""
	local cQuery 	:= ""
	
	cQuery += " SELECT F3_OBSERV "
	cQuery += " FROM %SF3.SQLNAME% "	
	cQuery += " WHERE  "
	cQuery += " 	%SF3.XFILIAL% "
	cQuery += " 	AND %SF3.NOTDEL% "
	cQuery += " 	AND F3_NFISCAL	= '" + ::getFieldValue("F3_NFISCAL") + "' "
	cQuery += " 	AND F3_SERIE	= '" + ::getFieldValue("F3_SERIE") 	 + "' "
	cQuery += " 	AND F3_CLIEFOR	= '" + ::getFieldValue("F3_CLIEFOR") 	 + "' "
	cQuery += " 	AND F3_LOJA		= '" + ::getFieldValue("F3_LOJA") 	 + "' "
	
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


method validDocRef(aDocsRef, aFields)  class DHLSafx116Dis
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
method getChvRef(cType,cDoc,cSerie,cCliFor,cLoja)  class DHLSafx116Dis
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

/*
** Localiza cliente padrão 
*/
static function f2field(cDoc, cSer, cCod,  cField , lF2CLIENTE  , lDeleted )
//
Local cRt 			:= ""
//Local cField		:= "F2_CLIENTE"
local oSql 		:= IpSqlObject():newIpSqlObject()
local cCond		:= "" 
LOCAL CCLI		:= ""

Default cField		:= "F2_CLIENTE"
Default lF2Cliente	:= .f.
Default lDeleted		:= .f.

if lF2CLiente  // para retornar o F2_CLIENT // JJ EM 16/10/2017

		cCond	:= " F2_FILIAL = '"+xFilial("SF2")+"' AND F2_DOC = '"+cDoc+"' AND " 
		cCond	+= " F2_SERIE = '"+cSer+"' and F2_CLIENTE = '"+cCod+"' " + if(!lDeleted , "and SF2100.d_e_l_e_t_ = ' ' ","")

		oSql:newAlias("SELECT "+cField+" FROM SF2100 WHERE "+ cCond )				
		cRt  := oSql:getValue(cField) //"F2_CLIENTE")		
		oSql:close()
else

	IF cField == "D2_TES"                                     
		cField := "F2_CLIENTE"

		cCond	:= " F2_FILIAL = '"+xFilial("SF2")+"' AND F2_DOC = '"+cDoc+"' AND " 
		cCond	+= " F2_SERIE = '"+cSer+"' and F2_CLIENT = '"+cCod+"' " + if(!lDeleted , "and SF2100.d_e_l_e_t_ = ' ' ","")

		oSql:newAlias("SELECT "+cField+" FROM SF2100 WHERE "+ cCond )				
		cCLI  := oSql:getValue(cField) //"F2_CLIENTE")		
		oSql:close()

		CFIELD := "D2_TES"

		cCond	:= " D2_FILIAL = '"+xFilial("SD2")+"' AND D2_DOC = '"+cDoc+"' AND " 
		cCond	+= " D2_SERIE = '"+cSer+"' and D2_CLIENTE = '"+CCLI+"' " + if(!lDeleted , "and SD2100.d_e_l_e_t_ = ' ' ","")

		oSql:newAlias("SELECT DISTINCT "+cField+" FROM SD2100 WHERE "+ cCond )				
		cRT  := oSql:getValue(cField) //"F2_CLIENTE")		
		oSql:close()                                                          
		CRT := CRT

	ELSE

		cCond	:= " F2_FILIAL = '"+xFilial("SF2")+"' AND F2_DOC = '"+cDoc+"' AND " 
		cCond	+= " F2_SERIE = '"+cSer+"' and F2_CLIENT = '"+cCod+"' " + if(!lDeleted , "and SF2100.d_e_l_e_t_ = ' ' ","")

		oSql:newAlias("SELECT "+cField+" FROM SF2100 WHERE "+ cCond )				
		cRt  := oSql:getValue(cField) //"F2_CLIENTE")		
		oSql:close()
	ENDIF	
endif
return (cRt)