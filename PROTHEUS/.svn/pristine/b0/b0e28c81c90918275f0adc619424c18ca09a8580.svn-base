#include 'totvs.ch'
#include 'safx.ch'
#include 'safx112.ch'
#include 'dhl.ch'


/*/{Protheus.doc} DHLSafx112Ag2

Respons‡vel pelas regras e montagem das informacoes para a exportacao
	
@author Thiago Meschiatti
@since 05/09/2016

/*/

user function _112Ag2Saf;return

class DHLSafx112Ag2 from DHLSafx

	method newDHLSafx112Ag2() constructor
	method addLine() 
	method getMsgF3()

endclass

//-----------------------------------------------------------------
method newDHLSafx112Ag2() class DHLSafx112Ag2
	
return

/*/{Protheus.doc} addLine

Cria a lina ‡ ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine(cTypeMsg)  class DHLSafx112Ag2

	local aInOutFlows  	:= {}
	local aSupCus 	   	:= {}
	local cType			:= ""
	local cCod		   	:= "" 
	local cBranch	   	:= ""
	local cDoc			:= ""
	local cSer			:= ""	
	local cIndFisJur	:= ""
	local cMenNota		:= ""
	local lContinue	
	local lSPL			:= (FWUnitBusiness() == DHL_BUSINESSUNIT_SPL)
	local lMsgDev		:= .f.
	local cmsg_envio	:= ""
	Local cDataEnt      := ""
	
	cCod 		:= (cSF3_)->(F3_CLIEFOR)
	cBranch 	:= (cSF3_)->(F3_LOJA)
	cDoc		:= (cSF3_)->(F3_NFISCAL)
	cSer    	:= (cSF3_)->(F3_SERIE)
	cDataEnt   	:= (cSF3_)->(F3_ENTRADA) //Emerson Holanda 14/08/25 - Armazenar a data de entrada da nota para ser enviado para a query do getTypeDoc
	cType		:= ::getTypeDoc(cDoc, cSer, cCod, cBranch,,,cDataEnt)
	
	cIndFisJur	:= Iif( cType =="1",Iif((cSF3_)->(F3_TIPO) $ "DB" ,"2","1" ) , Iif(!(cSF3_)->(F3_TIPO) $ "DB" ,"2","1" )      )
	
	//aSupCus 		:= 	::getSupCusRecords(cIndFisJur,cCod,cBranch)
	//aInOutFlows 	:= 	::getFlowsRecord(cType,cDoc, cSer,cCod,cBranch)	
	aInOutFlows	:= aclone( _InOutFlows )

	cMenNota		:=	retMenNota(Self, cType, aInOutFlows)
	cMsg			:=  ::getMsgF3()
	
	if cTypeMsg == "02"
		if empty(cMsg) .and. (cSF3_)->(F3_IPIOBS) > 0
			cMsg := "Valor do IPI nao creditado: R$ " + alltrim(transform((cSF3_)->(F3_IPIOBS), "@ze 9,999,999,999,999.99"))
		elseif !empty(cMsg) .and. (cSF3_)->(F3_IPIOBS) > 0
			if lSPL 
				cMsg := "Valor do IPI nao creditado: R$ " + alltrim(transform((cSF3_)->(F3_IPIOBS), "@ze 9,999,999,999,999.99"))
			else
				cMsg += " / " + "Valor do IPI nao creditado: R$ " + alltrim(transform((cSF3_)->(F3_IPIOBS), "@ze 9,999,999,999,999.99"))
			endif
		else
			if lSPL
				cMsg := if(empty(getTaxes(self, aInOutFlows, cType)[1]), '', getTaxes(self, aInOutFlows, cType)[1] + ' - ') + cMsg
			endif
		endif 
	else
		if lSPL .and. !empty(cMsg)
			if ("DEVOLUCAO" $ cMsg)
				lMsgDev := .t.
			endif 
		endif
	endif
	
	cmsg_envio := iif(cTypeMsg == "01", cMenNota + strtran(::getMsgFlow(iif(cType=="1","E","S"),cDoc,cSer,cCod,cBranch), "|", "") + iif(lMsgDev, cMsg, ''), cMsg)
	cmsg_envio := strtran( cmsg_envio, '"','')
	
	::addField(COD_EMPRESA				, alltrim(GetNewPar("ZZ_IDEMPDW", "SOL")))
	::addField(COD_ESTAB				, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())))
	//::addField(DATA_FISCAL			, iif(cType == "1" ,::getFieldValue("F1_DTDIGIT",aInOutFlow),::getFieldValue("F2_EMISSAO",aInOutFlow)))
	::addField(DATA_FISCAL				, (cSF3_)->(F3_ENTRADA) )
	::addField(MOVTO_E_S				, iif(cType =="1", SAFX_DOCUMENTO_ENTRADA, SAFX_DOCUMENTO_SAIDA))
	::addField(NORM_DEV				, (cSF3_)->TIPO ) //	::getFieldValue("TIPO"))
	::addField(COD_DOCTO				, "NFE") 
	::addField(IND_FIS_JUR				, (cSF3_)->ZZINDDW ) //Iif(cIndFisJur == "1",::getFieldValue("A2_ZZINDDW",aSupCus), ::getFieldValue("A1_ZZINDDW",aSupCus)))
	::addField(COD_FIS_JUR				, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp()))+cCod+cBranch)
	::addField(NUM_DOCFIS				, (cSF3_)->(F3_NFISCAL) )
	::addField(SUB_SERIE_DOCFIS			, ' ')
	::addField(SERIE_DOCFIS				, (cSF3_)->(F3_SERIE) )
	::addField(COD_OBS_LANCTO_FISCAL	, iif(cTypeMsg == "01",::getCodTypeMsg("1"),::getCodTypeMsg("2")) ) 
	::addField(IND_ICOMPL_LANCTO		, iif(cTypeMsg == "01", "I", "L"))
	//::addField(DSC_COMPLEMENTAR			, iif(cTypeMsg == "01", cMenNota + strtran(::getMsgFlow(iif(cType=="1","E","S"),cDoc,cSer,cCod,cBranch), "|", "") + iif(lMsgDev, cMsg, ''), cMsg)) 
	::addField(DSC_COMPLEMENTAR			, cmsg_envio) 
	::addField(VINCULACAO				, iif(cTypeMsg == "01", '1', ' ')) 

	if(empty(cMsg)) .or. (!empty(cMsg) .and. cTypeMsg == "02") 
		if ((cSF3_)->(F3_IPIOBS) == 0)
			lContinue := .f.
		elseif cTypeMsg == "01"
			lContinue := .t.
			cTypeMsg  := "02"
		else
			lContinue := .f.
		endif
	else 
		lContinue := .t.
		cTypeMsg  := "02"
	endif
		
return (lContinue)

/*/{Protheus.doc} getMsgF3

Busca informações do SF3
	
@author Thiago Meschiatti
@since 18/07/2017

/*/
method getMsgF3()  class DHLSafx112Ag2
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

/*
** Busca impostos para NFs
*/
static function getTaxes(oSelf, aInOutFlow, cType)
	local oSql   	:= IpSqlObject():newIpSqlObject()
	local nIpi		:= 0
	local nIcms		:= 0
	local cMsgIpi	:= ""
	local cMsgIcms	:= ""
	local cQuery	:= ""
	local cTypeMov	:= Alltrim(iif(cType == "1" ,'E','S'))
	local cTypeDoc	:= Alltrim(iif(cType == "1" , (cSFT_)->F1_TIPO , (cSFT_)->F2_TIPO )) //oSelf:getFieldValue("F1_TIPO",aInOutFlow),oSelf:getFieldValue("F2_TIPO",aInOutFlow)))
	local cFil		:= Alltrim(iif(cType == "1" ,(cSFT_)->F1_FILIAL , (cSFT_)->F2_FILIAL )) //oSelf:getFieldValue("F1_FILIAL",aInOutFlow),oSelf:getFieldValue("F2_FILIAL",aInOutFlow)))
	local cSerie	:= Alltrim(iif(cType == "1" ,(cSFT_)->F1_SERIE , (cSFT_)->F2_SERIE )) //oSelf:getFieldValue("F1_SERIE",aInOutFlow),oSelf:getFieldValue("F2_SERIE",aInOutFlow)))
	local cDoc		:= Alltrim(iif(cType == "1" , (cSFT_)->F1_DOC , (cSFT_)->F2_DOC )) //oSelf:getFieldValue("F1_DOC",aInOutFlow),oSelf:getFieldValue("F2_DOC",aInOutFlow)))
	local cCliFor	:= Alltrim(iif(cType == "1" ,(cSFT_)->F1_FORNECE , (cSFT_)->F2_CLIENTE )) //oSelf:getFieldValue("F1_FORNECE",aInOutFlow),oSelf:getFieldValue("F2_CLIENTE",aInOutFlow)))
	local cLoja		:= Alltrim(iif(cType == "1" , (cSFT_)->F1_LOJA , (cSFT_)->F2_LOJA )) //oSelf:getFieldValue("F1_LOJA",aInOutFlow),oSelf:getFieldValue("F2_LOJA",aInOutFlow)))
	
	cQuery := " CD2_FILIAL = '"+cFil+"' AND CD2_TPMOV = '"+cTypeMov+"' AND CD2_SERIE = '"+cSerie+"' AND CD2_DOC = '"+cDoc+"' "

	if cTypeMov == 'E'
		if cTypeDoc $ "B|D|"
			cQuery += " AND CD2_CODCLI = '"+cCliFor+"' AND CD2_LOJCLI = '"+cLoja+"' "
		else
			cQuery += " AND CD2_CODFOR = '"+cCliFor+"' AND CD2_LOJFOR = '"+cLoja+"' "			
		endif
	else
		if cTypeDoc $ "B|D|"
			cQuery += " AND CD2_CODFOR = '"+cCliFor+"' AND CD2_LOJFOR = '"+cLoja+"' "
		else
			cQuery += " AND CD2_CODCLI = '"+cCliFor+"' AND CD2_LOJCLI = '"+cLoja+"' "
		endif
	endif
	
	oSql:newTable("CD2", "CD2_IMP, CD2_VLTRIB", cQuery)
	
	while oSql:notIsEof()
		if Upper(alltrim(oSql:getValue("CD2_IMP"))) == "SOL"
			nIcms += oSql:getValue("CD2_VLTRIB")
		elseif Upper(alltrim(oSql:getValue("CD2_IMP"))) == "IPI"
			nIpi += oSql:getValue("CD2_VLTRIB")
		endif
		
		oSql:skip()
	enddo
	
	if nIpi > 0
		cMsgIpi  := "Valor Total do IPI: " + alltrim(str(nIpi)) 
	endif
	if nIcms > 0
		cMsgIcms := "Valor de ICMS Retido: " + alltrim(str(nIcms))
	endif
	
	oSql:close()
	
return({cMsgIpi, cMsgIcms})

/*
**
*/
static function retMenNota(oSelf, cType, aInOutFlows)
	local cMenNota	:= ""
	local cMsgAux	:= ""
	local cMsgRemov	:= ""	
	
	cMenNota := alltrim(iif(cType == "1" , (cSFT_)->f1_mennota , (cSFT_)->f2_mennota )) 
	
	if !empty(cMenNota)
		while Upper("Valor") $ Upper(cMenNota) 
			if "VALOR DE ICMS RETIDO: R$" $ Upper(cMenNota)
				cMsgAux		:= substr(cMenNota, 1, at('VALOR DE ICMS RETIDO: R$', Upper(cMenNota))-1)
				cMsgRemov	:= substr(cMenNota, at('VALOR DE ICMS RETIDO: R$', Upper(cMenNota)), len(cMenNota))
				cMsgRemov	:= substr(cMsgRemov, at('.', upper(cMsgRemov))+3, len(cMsgRemov))
				cMenNota 	:= alltrim(cMsgAux) + alltrim(cMsgRemov)
			elseif "VALOR TOTAL DE IPI: R$" $ Upper(cMenNota)
				cMsgAux		:= substr(cMenNota, 1, at('VALOR TOTAL DE IPI: R$', Upper(cMenNota))-1)
				cMsgRemov	:= substr(cMenNota, at('VALOR TOTAL DE IPI: R$', Upper(cMenNota)), len(cMenNota))
				cMsgRemov	:= substr(cMsgRemov, at('.', Upper(cMsgRemov))+3, len(cMsgRemov))
				cMenNota 	:= alltrim(cMsgAux) + alltrim(cMsgRemov)
			else
				exit
			endif
		end
		cMenNota += ". "
	endif
	
	while left(cMenNota, 1) $ '.'
		cMenNota := substr(cMenNota, 2, len(cMenNota))
	end
	
return (cMenNota)
