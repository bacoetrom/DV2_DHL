#include 'protheus.ch'
#include 'dhl.ch'


/*/{Protheus.doc} ValidExEsp
//TODO Descrição auto-gerada.
@author Thiago Meschiatti
@since 17/06/2016
@version undefined

@type function
/*/
user function ValidExEsp()
	local oSql		:= IpSqlObject():newIpSqlObject()
	local oSqlAux	:= IpSqlObject():newIpSqlObject()
	local oDevRec	:= nil
	local cMsg		:= ""
	local nTamDoc	:= tamsx3("D1_DOC")[1]
	local nTamSer	:= tamsx3("D1_SERIE")[1]
	local lEspelho	:= SF1->F1_SERIE == DHL_SERIE_ESPELHO
	local lDevol	:= SF1->F1_TIPO == 'D'
	local aChv		:= {}
	local lOk 		:= .t.
	
	if lEspelho  .or. lDevol 
		oDevRec		:= DHLDisDevRec():newDHLDisDevRec()
		oSql:newTable("SD1", "D1_DOC||D1_SERIE||D1_ITEM||D1_FORNECE||D1_LOJA CHVNF, D1_ZZCHVNF CHVDEV", retQrySD1())
		
		while oSql:notIsEof()
			if lEspelho
				oSqlAux:newTable("SD1", "D1_DOC || '/' || D1_SERIE DOC", " %SD1.XFILIAL% AND D1_ZZCHVNF = '"+oSql:getValue("CHVNF")+"' ") 
				if oSqlAux:hasRecords()
					cMsg += oSqlAux:getValue("DOC") + CRLF
				endif
				oSqlAux:close()
			elseif lDevol
				aadd(aChv, oSql:getValue("CHVDEV"))
			endif
			oSql:skip()
		end
		
		if lEspelho
			if !empty(cMsg)
				oDevRec:setError(.t.)
				oDevRec:setMsgError("Nota Espelho não pode ser excluída. Favor excluir documentos relacionados: "+ cMsg)
				oDevRec:showError()
				lOk := .f.
			endif
		elseif lDevol
			lOk := execDoc(oDevRec, aChv, nTamDoc, nTamSer)
		endif
	endif
	
	oSql:close()
	
return (lOk)


/**
 * Executa a rotina automática de exclusão do docS
 */
static function execDoc(oDevRec, aChv, nTamDoc, nTamSer)
	local oDevExc	:= nil 
	local aItens 	:= {}
	local aItem 	:= {}
	local aCab 		:= {}
	local aSF1 		:= SF1->(getArea())
	local aSD1 		:= SD1->(getArea())
	local aArea		:= getArea()
	local nI		:= 0
	local lOk 		:= .T.
	
	private lMSErroAuto := .F.

//	for nI := 1 to len(aChv)
//		if !empty(aChv[nI])
		if !empty(aChv[1])
			oDevExc := DHLDisDevRec():newDHLDisDevRec()
			
//			SF1->(dbSeek(xFilial("SF1") + substr(aChv[nI], 1, nTamDoc+nTamSer)))
			SF1->(dbSeek(xFilial("SF1") + substr(aChv[1], 1, nTamDoc+nTamSer)))
			
			mountHeader(oDevExc)
			
			SD1->(dbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			while 	SD1->(!(Eof()))                  .AND.;
					SD1->D1_FILIAL == xFilial("SD1") .AND.;
					SD1->D1_DOC    == SF1->F1_DOC    .AND.;
					SD1->D1_SERIE  == SF1->F1_SERIE  .AND.;
					SD1->D1_FORNECE== SF1->F1_FORNECE.AND.;
					SD1->D1_LOJA   == SF1->F1_LOJA
					
				mountDetail(oDevExc)
		        
				SD1->(dbSkip())
		
			enddo
		
			oDevExc:execAuto(DHL_OPC_EXCLUSAO)
			if oDevExc:hasError()
				oDevExc:showError()
				lOk := .f.
			endif 
			freeObj(oDevExc)
		endif
//	next nI		
	
	restArea(aSF1)
	restArea(aSD1)
	restArea(aArea)

return (lOk)


/**
* Monta o cabelhaço da Nota Fiscal
**/
static function mountHeader(oDevExc)

	local nCount	:= 0
	local aCposSX3	:= FWSX3Util():GetAllFields("SF1",.f.)
	
	oDevExc:addHeader("F1_TIPO"    	,SF1->F1_TIPO   	)
	oDevExc:addHeader("F1_FORMUL"  	,SF1->F1_FORMUL		)
	oDevExc:addHeader("F1_DOC"    	,SF1->F1_DOC   		)
	oDevExc:addHeader("F1_SERIE"  	,SF1->F1_SERIE 		)
	oDevExc:addHeader("F1_EMISSAO" 	,SF1->F1_EMISSAO 	)
	oDevExc:addHeader("F1_FORNECE"	,SF1->F1_FORNECE	)
	oDevExc:addHeader("F1_LOJA"   	,SF1->F1_LOJA   	)
	oDevExc:addHeader("F1_ESPECIE"	,SF1->F1_ESPECIE	)
	
	for nCount := 1 to len(aCposSX3)
	
		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U"
			oDevExc:addHeader(AllTrim(aCposSX3[nCount]),&("SF1->" + AllTrim(aCposSX3[nCount])),nil)
		endIf
	
	next nCount
			               
return


/**
* Monta os items da Nota Fiscal
**/
static function mountDetail(oDevExc)

	local nCount	:= 0
	local aCposSX3	:= FWSX3Util():GetAllFields("SD1",.f.)
	
	oDevExc:aAuxItems := {}
	oDevExc:addItems("D1_ITEM"   	,SD1->D1_ITEM, 	nil   )
	oDevExc:addItems("D1_COD"    	,SD1->D1_COD, 	nil   )
	oDevExc:addItems("D1_QUANT"		,SD1->D1_QUANT, nil   )
	oDevExc:addItems("D1_VUNIT"  	,SD1->D1_VUNIT, nil   )
	oDevExc:addItems("D1_TOTAL"  	,SD1->D1_TOTAL, nil   )
	
	for nCount := 1 to len(aCposSX3)
	
		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U"
			oDevExc:addItems(AllTrim(aCposSX3[nCount]),&("SD1->" + AllTrim(aCposSX3[nCount])),nil)
		endIf
	
	next nCount
	
	oDevExc:addEndItems()
	
return

/*
** Where para tabela SD1
*/
static function retQrySD1()
	local cQuery := ""
	
	cQuery += "%SD1.XFILIAL% AND D1_DOC = '"+SF1->F1_DOC+"' AND D1_SERIE = '"+SF1->F1_SERIE+"' AND D1_FORNECE = '"+SF1->F1_FORNECE+"'"
	cQuery += " AND D1_LOJA = '"+SF1->F1_LOJA+"'"
	
return (cQuery)