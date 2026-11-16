#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} VldIdSales

Validações finais das operações. Saída / entrada

@author Thiago Meschiatti
@since 11/11/2014

@param xParam, TipoParam, DescricaoDoParam

@return TipoRet DescricaoRet
/*/
User Function VldIdEnd(cEvent)
	local oSql    	 := IpSqlObject():newIpSqlObject()
	local oIdManager := DHLIdManager():newDHLIdManager()
	local nI 		 := 0
	local nAux		 := n
	local cType 	 := ""
	local cId		 := ""
	local cFilDoc	 := ""
	local cCliForDoc := ""
	local cLojDoc	 := ""
	local cFiedlId	 := ""
	local cFieldFil	 := ""
	local cStatus	 := ""
	local lOk
	local lDevBen	:= .f.
	local lDepos	:= .f.
	
	if cEvent == DHL_NF_SAIDA
		cFieldId	:= "C6_ZZID"
		cFieldFil	:= "C6_FILIAL"
		cFilDoc 	:= xFilial("SC6")
	else
		cFieldId	:= "D1_ZZID"
		cFieldFil	:= "D1_FILIAL"
		cFilDoc 	:= xFilial("SD1")
		if INCLUI
			lDevBen		:= cTipo $ 'B|D|'
			cCliForDoc	:= ca100for
			cLojDoc		:= cloja
		else
			lDevBen		:= SF1->F1_TIPO $ 'B|D|'		
			cCliForDoc	:= SF1->F1_FORNECE
			cLojDoc		:= SF1->F1_LOJA
		endif
		if lDevBen
			lDepos  := oSql:getFieldValue("SA1", "A1_ZZDEPOS", " %SA1.XFILIAL% AND A1_COD = '"+cCliForDoc+"' AND A1_LOJA = '"+cLojDoc+"' ") $ 'S'
		else 
			lDepos	:= oSql:getFieldValue("SA2", "A2_ZZDEPOS", " %SA2.XFILIAL% AND A2_COD = '" + cCliForDoc + "' "+; 
												"AND A2_LOJA = '" + cLojDoc + "' ") $ 'S'
		endif
	endif
	
	for nI := 1 to len(aCols)
		if !gdDeleted(nI,,aCols)
			cId 	:= GdFieldGet(cFieldId, nI)
			If( Empty(cStatus) )
				cStatus := upper(alltrim(oIdManager:retStatusId(cFilDoc, cId, cEvent)))
			EndIf
			if !(lDepos)
				lOk := empty(alltrim(GdFieldGet(cFieldId, nI)))
				if lOk
					lOk := .f.
					Help("" ,"", 'ZZID4')
					exit
				endif
			endif
			n := nI
			lOk	:= u_DHLValidID("DHL_EXIST_ID", cFieldId)
			if lOk
				cId		:= upper(alltrim(GdFieldGet(cFieldId, nI)))
				if cStatus != oIdManager:retStatusId(cFilDoc, cId, cEvent)
					lOk := .f.
					Help("" ,"", 'ZZID3')
					exit
				endif
			else
				exit
			endif
		endif
	next nI
	
	n := nAux
	
Return(lOk)
