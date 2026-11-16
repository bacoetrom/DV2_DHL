#include "oracle_ar.ch"
#include "rwmake.ch"
#include "totvs.ch"
#include "dhl.ch"

#define DHL_POS_EMPRESA 1
#define DHL_POS_FILIAL  2

#define DHL_DEBITO "1"

/*/{Protheus.doc} ExpOraAR

Rotina responsável pela integração com Oracle AR
	
@author Diego de Angelo
@since 23/10/2014

@param aParamJob, Array, Parâmetro contendo empresa e filial quando executadovia JOB.

/*/
user function ExpOraAR(aParamJob)

	local oSqlUtil    := IpSqlObject():newIpSqlObject()
	
	private lJob      := .T.
	private oParamBox := nil
	private oLog      := DHLLogManager():newDHLLogManager()
	private lErro     := .F.
	private aErros    := {}
	private cCnpj     := ""
	private cOrgId    := ""
	private cNota     := ""
	private cSerie    := ""
	private cCliente  := ""
	private cLoja     := ""
	private cItemNota := ""
	Private cPvtName_ := ""
	Private cPvtDir_  := ""
	Private cDirExp   := ""
		
	lJob := preparaAmbiente(aParamJob)
	
	cDirExp  := AllTrim(oSqlUtil:getFieldValue("SZ1", "Z1_DIREXP", "Z1_FILIAL = '%SZ1.FILIAL%' AND %SZ1.NOTDEL% AND SZ1.Z1_CODIGO ='"+APP_ORACLE_AR+"'"))
	
	if !(filialOk())
		return
	endif
	
	if !(lJob)	
		if !(exibeParametros())
			MsgBox("Processamento abortado", "Atenção", "ALERT") 
			return .F.
		endif
	endif

	Processa( {|| processaNotas() }, "Aguarde...", "Processando...",.F.)
	
return


/**
* Função utilizada para preparação do ambiente.
**/
static function preparaAmbiente(aParamJob)
	
	local oEnv    := IpEnvironmentObject():newIpEnvironmentObject()
	local cCodEmp := ""
	local cCodFil := ""
	local lJob    := !(oEnv:hasMainWindow())
	
	if lJob
		cCodEmp := aParamJob[DHL_POS_EMPRESA]
		cCodFil := aParamJob[DHL_POS_FILIAL]
		 
		oEnv:setCompany(cCodEmp)  
		oEnv:setBranch(cCodFil)
		 
		oEnv:load() 	   
	endif
		
return lJob


/**
* Função responsável pela validação da filial.
**	Alterado por Cassiano em 04/01/2016 - mudança da logica para considerar consulta em cadastro pesonalizado de filiais autorizadas
**/
static function filialOk()

	//local lOk  := aScan(DHL_FILIAIS_AUTORIZADAS,cFilAnt) > 0
	local lOk	:= .F.
	local cMsg	:= "Filial não autorizada."
	local cAlias	:= getNextAlias()

	beginSql Alias cAlias
		SELECT Z7_FILORAC
		  FROM %TABLE:SZ7% Z7
		 WHERE Z7_FILIAL = ' '
		   AND Z7_TIPO = 'AR'
		   AND Z7_FILORAC = %EXP:cFilAnt%
		   AND Z7.%NOTDEL%
	endSql
	(cAlias)->(dbGoTop())
		
	lOk :=  !(cAlias)->(eof())
	
	if !(lOk)
		oLog:start(APP_ORACLE_AR, DHL_EXPORTACAO)
		oLog:warn(cMsg, cMsg)
		
		if !(lJob)
			MsgBox(cMsg,"Atenção","ALERT")
		endif
	endif	

	(cAlias)->(dbCloseArea())
	
return lOk


/**
* Função responsável pelo processamento das notas fiscais.
**/
static function processaNotas()
	
	local oSqlCabNota	 := IpSqlObject():newIpSqlObject()
	local oSqlItensNota	 := IpSqlObject():newIpSqlObject()
	local oSqlClassCont	 := IpSqlObject():newIpSqlObject()
	local oSqlUtil		 := IpSqlObject():newIpSqlObject()
	local cQryCabNota	 := getCabNota()
	local cQryItensNota	 := ""
	local cQryClassNota	 := ""
	local cLinhaHeader	 := ""
	local cLinhaItens	 := ""
	local cLinhaClass	 := ""
	local cLinhaTrailler := ""
	local cErroNota		 := ""
	local oArquivo		 := nil
	local nTotReg		 := 0
	local nTotDeb		 := 0 
	local nTotCred 		 := 0
	local nTotItens		 := 0
	local nTotClass		 := 0
	local nTotHeader	 := 1
	local nTotTrailler	 := 1 
	local nRegs			 := 1
	local nCount		 := 0
	local nValor		 := 0

	cCnpj := AllTrim(retCnpj(cFilAnt))
	
	cOrgId := oSqlUtil:getFieldValue("SX5","X5_CHAVE","X5_FILIAL = '%SX5.FILIAL%' AND X5_TABELA = 'ZX' AND RTRIM(X5_DESCRI) = '" + cCnpj + "' AND %SX5.NOTDEL% ")
	cOrgId := AllTrim(Str(Val(cOrgId) * 100))
	
	oSqlCabNota:newAlias(cQryCabNota)
	
	nRegs := oSqlCabNota:count()

	if !(lJob)
		ProcRegua(nRegs)
	endif	
	
	if oSqlCabNota:isEof()
		MsgBox("Nota fiscal não encontrada.","Aviso","INFO")
		return .F.
	endif
	
	while oSqlCabNota:notIsEof()
		lErro		:= .F.
		nCount	 := 0
		cNota    := AllTrim(oSqlCabNota:getValue("F2_DOC"))
		cSerie   := AllTrim(oSqlCabNota:getValue("F2_SERIE"))
		cCliente := AllTrim(oSqlCabNota:getValue("F2_CLIENTE"))
		cLoja    := AllTrim(oSqlCabNota:getValue("F2_LOJA"))
		
		if !(lJob)
			IncProc("Processando [Nota: "+ AllTrim(cNota) + " Série: " + AllTrim(cSerie) + "] ...")
		endif
		
		if !(isAccounting(cNota,cSerie,cCliente,cLoja))
			oSqlCabNota:skip()
			loop
		endif
		
		if !(criaArquivo(@oArquivo))
			exit
		endif
			
		cLinhaHeader := criaHeader()
		
		oArquivo:writeLine(cLinhaHeader)
		
		cQryItensNota := getItensNota(cNota,cSerie,cCliente,cLoja)
		
		oSqlItensNota:newAlias(cQryItensNota) 	
				
		while oSqlItensNota:notIsEof()
			nCount++
			cItemNota := oSqlItensNota:getValue("D2_ITEM")
			
			//validaTes(oSqlItensNota:getValue("D2_TES"))
			
			cLinhaItens := criaItens(oSqlCabNota,oSqlItensNota,nCount)
			
			oArquivo:writeLine(cLinhaItens)
			
			nTotItens++
			
			cQryClassNota := getClassNota(oSqlItensNota)
			oSqlClassCont:newAlias(cQryClassNota)
			
			while oSqlClassCont:notIsEof()

				nTotClass++
						
				cLinhaClass := criaClassContabil(oSqlItensNota, oSqlClassCont, @nTotCred, @nTotDeb, nCount, nTotClass)
				if !empty(cLinhaClass)
					oArquivo:writeLine(cLinhaClass)
				endIf
				oSqlClassCont:skip()
			enddo
			
			oSqlClassCont:close()
			oSqlItensNota:skip()
		enddo
		
		nTotReg := nTotHeader + nTotTrailler + nTotClass + nTotItens
		
		cLinhaTrailler := criaTrailler(nTotReg,nTotDeb,nTotCred)
		
		oArquivo:writeLine(cLinhaTrailler)
		
		cPvtDir_ := cDirExp		
		if lErro .OR. !(alteraStatusNota()) .OR. !(copiaArquivo(@oArquivo))
			oLog:start(APP_ORACLE_AR, DHL_EXPORTACAO)
			cErroNota += "Registro LOG: " + oLog:getId() + " Nota: " + cNota +" | " + " Série: " + cSerie + CRLF
			oLog:fail("Validação dos Campos",retornaErro())
		endif
		oArquivo:close()
		
		//fRename( cPvtName_ +".processing" , cPvtName_ +".txt" )
		ferase( cPvtDir_ + cPvtName_ + ".PROCESSING" )
		
		oSqlCabNota:skip()
		
		nTotReg      := 0
		nTotCred     := 0
		nTotDeb      := 0
		nTotClass    := 0
		nTotItens    := 0
		nTotTrailler := 0
		nTotClass    := 0
		
	enddo
	
	oSqlCabNota:close()
	
	if !empty(cErroNota)
		if !(lJob)
			Aviso("Atenção","As notas abaixo não foram processadas, verifique a tabela de log. "  + CRLF + cErroNota,{"OK"},3)	
		endif
	else
		if !(lJob)
			MsgBox("Notas processadas com sucesso.","Aviso","INFO")
		endif
	endif
return


/**
*	Criação da string da seção Header
**/
static function criaHeader()

	local aLinha := Array(HEADER_TOTAL_CAMPOS_HEADER)
	local cLinha := ""
	
	setValorLinha(@aLinha,HEADER_TIPO_DE_LINHA	,"1")
 	setValorLinha(@aLinha,HEADER_IDENTIFICACAO	,"INTERFACEAR")
 	setValorLinha(@aLinha,HEADER_DATA			,dDataBase)
 	
	cLinha := criaLinha(aLinha)
	
return cLinha


/**
* Função responsável pela criação da string da seção Itens
**/
static function criaItens(oSqlCabNota,oSqlItensNota,nCount)
	
	local aLinha      := Array(ITEM_TOTAL_CAMPOS_ITEM)
	local cLinha      := ""
	local oSqlUtil    := IpSqlObject():newIpSqlObject()
	local oSqlCliente := IpSqlObject():newIpSqlObject()
	local cDescProd   := AllTrim(oSqlUtil:getFieldValue("SB1","B1_DESC", "B1_COD = '"+oSqlItensNota:getValue("D2_COD") +"' AND %SB1.NOTDEL% AND B1_FILIAL = '%SB1.FILIAL%'"))
	local cNCM   	  := AllTrim(oSqlUtil:getFieldValue("SB1","B1_POSIPI", "B1_COD = '"+oSqlItensNota:getValue("D2_COD") +"' AND %SB1.NOTDEL% AND B1_FILIAL = '%SB1.FILIAL%'"))
	local cCondPag    := AllTrim(oSqlUtil:getFieldValue("SE4","E4_ZZORACL", "E4_CODIGO = '"+oSqlCabNota:getValue("F2_COND") +"' AND %SE4.NOTDEL% AND E4_FILIAL = '%SE4.FILIAL%'"))
	local cCfop		  := AllTrim(oSqlUtil:getFieldValue("SF4","F4_CF", "F4_CODIGO = '"+oSqlItensNota:getValue("D2_TES") +"' AND %SF4.NOTDEL% AND F4_FILIAL = '%SF4.FILIAL%'")) 
	local cTransTes	  := AllTrim(oSqlUtil:getFieldValue("SF4","F4_ZZTRAOR", "F4_CODIGO = '"+oSqlItensNota:getValue("D2_TES") +"' AND %SF4.NOTDEL% AND F4_FILIAL = '%SF4.FILIAL%'")) 
	local cNomeCli    := ""
	local cEndCli     := ""
	local cNomeCliEnt := ""
	local cEndCliEnt  := ""
	
	oSqlCliente:newTable("SA1","A1_ZZNORAC,A1_ZZEORAC,A1_ZZETORA,A1_ZZEDORA","A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '"+oSqlCabNota:getValue("F2_CLIENTE")+"' AND A1_LOJA = '"+oSqlCabNota:getValue("F2_LOJA")+"'")
	
	cNomeCli    := oSqlCliente:getValue("A1_ZZNORAC")
	cEndCli     := oSqlCliente:getValue("A1_ZZEORAC")
	cNomeCliEnt := oSqlCliente:getValue("A1_ZZETORA")
	cEndCliEnt  := oSqlCliente:getValue("A1_ZZEDORA")
	
	oSqlCliente:close()
	
	setValorLinha(@aLinha,ITEM_TIPO_DE_LINHA					, "2")
	setValorLinha(@aLinha,ITEM_INTERFACE_LINE_CONTEXT			, superGetMV("ZZ_ORLICON",.T.,"") + alltrim(cSerie))
	setValorLinha(@aLinha,ITEM_INTERFACE_LINE_ATTRIBUTE1		, cNota)
	setValorLinha(@aLinha,ITEM_INTERFACE_LINE_ATTRIBUTE2		, cValtoChar(nCount)) 
	setValorLinha(@aLinha,ITEM_BATCH_SOURCE_NAME				, superGetMV("ZZ_BATORAC",.T.,"") + alltrim(cSerie))
	setValorLinha(@aLinha,ITEM_SET_OF_BOOKS_ID					, superGetMV("ZZ_OFBOOKS",.T.,""))
	setValorLinha(@aLinha,ITEM_LINE_TYPE						, "LINE")
	setValorLinha(@aLinha,ITEM_DESCRIPTION						, cDescProd)
	setValorLinha(@aLinha,ITEM_CURRENCY_CODE					, "BRL")
	setValorLinha(@aLinha,ITEM_AMOUNT							, oSqlItensNota:getValue("D2_TOTAL"))
	setValorLinha(@aLinha,ITEM_CUST_TRX_TYPE_NAME 				, cTransTes/*superGetMV("ZZ_CTNORAC",.T.,"")*/)
	setValorLinha(@aLinha,ITEM_TERM_NAME 						, cCondPag)
	setValorLinha(@aLinha,ITEM_ORIG_SYSTEM_BILL_CUSTOMER_REF 	, cNomeCli)
	setValorLinha(@aLinha,ITEM_ORIG_SYSTEM_BILL_ADDRESS_REF 	, cEndCli)
	setValorLinha(@aLinha,ITEM_ORIG_SYSTEM_SHIP_CUSTOMER_REF 	, cNomeCliEnt)
	setValorLinha(@aLinha,ITEM_ORIG_SYSTEM_SHIP_ADDRESS_REF 	, cEndCliEnt)
	setValorLinha(@aLinha,ITEM_CONVERSION_TYPE 					, "User")
	setValorLinha(@aLinha,ITEM_CONVERSION_RATE 					, "1")
	setValorLinha(@aLinha,ITEM_TRX_DATE 						, oSqlItensNota:getValue("D2_EMISSAO"))
	setValorLinha(@aLinha,ITEM_GL_DATE 							, oSqlItensNota:getValue("D2_EMISSAO"))
	setValorLinha(@aLinha,ITEM_TRX_NUMBER 						, cNota) 
	setValorLinha(@aLinha,ITEM_LINE_NUMBER 						, nCount/*oSqlItensNota:getValue("D2_ITEM")*/)
	setValorLinha(@aLinha,ITEM_QUANTITY 						, 1)
	setValorLinha(@aLinha,ITEM_UNIT_SELLING_PRICE 				, round(oSqlItensNota:getValue("D2_TOTAL"),2))  
	setValorLinha(@aLinha,ITEM_UOM_CODE 						, oSqlItensNota:getValue("D2_UM"))
	setValorLinha(@aLinha,ITEM_CREATED_BY 						, nil)
	setValorLinha(@aLinha,ITEM_CREATION_DATE	   				, nil)
	setValorLinha(@aLinha,ITEM_LAST_UPDATED_BY	   				, nil)
	setValorLinha(@aLinha,ITEM_LAST_UPDATE_DATE	   				, nil)
	setValorLinha(@aLinha,ITEM_ORG_ID		   					, cOrgId)
	setValorLinha(@aLinha,ITEM_AMOUNT_INCLUDES_TAX_FLAG			, "N")
	setValorLinha(@aLinha,ITEM_HEADER_GDF_ATTR_CATEGORY			, "JL.BR.ARXTWMAI.AdditionalInfo")
	setValorLinha(@aLinha,ITEM_LINE_GDF_ATTR_CATEGORY 			, "JL.BR.ARXTWMAI.AdditionalInfo")
	setValorLinha(@aLinha,ITEM_LINE_GDF_ATTRIBUTE1	 			, cCfop)
	setValorLinha(@aLinha,ITEM_LINE_GDF_ATTRIBUTE2 				, cNCM)
	setValorLinha(@aLinha,ITEM_LINE_GDF_ATTRIBUTE3 				, superGetMV("ZZ_LNGDAT3",.T.,"COMERCIALIZACAO"))
	setValorLinha(@aLinha,ITEM_WAREHOUSE_ID 					, superGetMV("ZZ_WAREHOUS",.T.,""))
 	
	cLinha := criaLinha(aLinha)
	
return cLinha


/**
* Função responsável pela criação da string da seção Classificação Contabil
**/	
static function criaClassContabil(oSqlItensNota,oSqlClassCont,nTotCred,nTotDeb,nCount, nTotClass)

	local aLinha    := Array(CONT_TOTAL_CAMPOS_CONT)
	local cNota     := Alltrim(oSqlItensNota:getValue("D2_DOC"))// +  Alltrim(oSqlItensNota:getValue("D2_SERIE"))
	local cItem     := ""
	local cCCusto   := ""
	local cClassVlr := ""
	local cConta    := ""
	local cEntCont5 := ""
	local cEntCont6 := ""
	local cLinha    := ""
	local cAccClass	:= ""
	local nPercent	:= 100
	local nValor	:= oSqlClassCont:getValue("CT2_VALOR")
	
	if oSqlClassCont:getValue("CT2_DC") == DHL_DEBITO
		cItem     := oSqlClassCont:getValue("CT2_ITEMD")
		cCCusto   := oSqlClassCont:getValue("CT2_CCD")
		cClassVlr := oSqlClassCont:getValue("CT2_CLVLDB")
		cConta    := oSqlClassCont:getValue("CT2_DEBITO")
		cEntCont5 := oSqlClassCont:getValue("CT2_EC05DB")
		cEntCont6 := oSqlClassCont:getValue("CT2_EC06DB")
		nTotDeb   += oSqlClassCont:getValue("CT2_VALOR")
		cAccClass := oSqlClassCont:getValue("CT2_AT01DB")
		
		if !empty(oSqlClassCont:getValue("CT2_AT02DB"))
			nValor	:= nil
			nPercent := Val(oSqlClassCont:getValue("CT2_AT02DB")) * -1
		endIf
	else
		cItem     := oSqlClassCont:getValue("CT2_ITEMC")
		cCCusto   := oSqlClassCont:getValue("CT2_CCC")
		cClassVlr := oSqlClassCont:getValue("CT2_CLVLCR")
		cConta    := oSqlClassCont:getValue("CT2_CREDIT")
		cEntCont5 := oSqlClassCont:getValue("CT2_EC05CR")
		cEntCont6 := oSqlClassCont:getValue("CT2_EC06CR")
		nTotCred  += oSqlClassCont:getValue("CT2_VALOR")
		cAccClass := oSqlClassCont:getValue("CT2_AT01CR")
		
		if !empty(oSqlClassCont:getValue("CT2_AT02CR"))
			nValor	:= nil
			nPercent := Val(oSqlClassCont:getValue("CT2_AT02CR"))
		endIf
	endif
	
					
	if nTotClass == 1 .OR. Alltrim(oSqlClassCont:getValue("CT2_AT01DB")) <> "REC" 	
			
		setValorLinha(@aLinha,CONT_TIPO_DE_LINHA 				, "3")
		setValorLinha(@aLinha,CONT_INTERFACE_LINE_CONTEXT 		, superGetMV("ZZ_ORLICON",.T.,"") + alltrim(cSerie))
		setValorLinha(@aLinha,CONT_INTERFACE_LINE_ATTRIBUTE1 	, cNota)
		setValorLinha(@aLinha,CONT_INTERFACE_LINE_ATTRIBUTE2 	, cValToChar(nCount))
		setValorLinha(@aLinha,CONT_ACCOUNT_CLASS 				, Alltrim(cAccClass))
		setValorLinha(@aLinha,CONT_AMOUNT 						, nValor)
		setValorLinha(@aLinha,CONT_PERCENT 						, nPercent)
		setValorLinha(@aLinha,CONT_SEGMENT1 					, cItem)
		setValorLinha(@aLinha,CONT_SEGMENT2 					, cCCusto)
		setValorLinha(@aLinha,CONT_SEGMENT3 					, cClassVlr)
		setValorLinha(@aLinha,CONT_SEGMENT4 					, cConta)
		setValorLinha(@aLinha,CONT_SEGMENT5 					, cEntCont5)			
		setValorLinha(@aLinha,CONT_SEGMENT6 					, cEntCont6)			
		setValorLinha(@aLinha,CONT_CREATED_BY 					, nil)			
		setValorLinha(@aLinha,CONT_CREATION_DATE 				, nil)	
		setValorLinha(@aLinha,CONT_LAST_UPDATED_BY 				, nil)	
		setValorLinha(@aLinha,CONT_LAST_UPDATE_DATE 			, nil)	
		setValorLinha(@aLinha,CONT_ORG_ID 						, cOrgId)	
					
		
		cLinha := criaLinha(aLinha)
	endIf
	
return cLinha


/**
* Função responsável pela criação da string da seção Trailler
**/
static function criaTrailler(nTotReg, nTotDeb, nTotCred)
	
	local aLinha := Array(TRAILLER_TOTAL_CAMPOS_TRAILLER)
	local cLinha := ""
	
	setValorLinha(@aLinha,TRAILLER_TIPO_DE_LINHA      ,"9")	
	setValorLinha(@aLinha,TRAILLER_TOTAL_DE_REGISTROS ,nTotReg)	
	setValorLinha(@aLinha,TRAILLER_TOTAL_A_DEBITO     ,nTotDeb)	
	setValorLinha(@aLinha,TRAILLER_TOTAL_A_CREDITO    ,nTotCred)	
	
	cLinha := criaLinha(aLinha)
	
return cLinha


/**
* Função responsável pelo tratamento dos valores de acordo com o tipo.
**/
static function trataValor(xValor)

	local oTrataValor := DHLLibrary():newDHLLibrary()
	
	if ValType(xValor) == "N"
		xValor := oTrataValor:fatorNumber(xValor)
	elseif ValType(xValor) == "D"
		xValor := DtoS(xValor)
	elseif ValType(xValor) == "C"
		xValor := AllTrim(xValor)
	endif
	
return xValor


/**
* Função responsável pelo retorno do cabeçalho da nota.
**/
static function getCabNota()

	local cQuery    := ""
	local cNotaDe   := ""
	local cNotaAte  := ""
	local cSerieDe  := ""
	local cSerieAte := ""
	
	cQuery := "SELECT * "                         + CRLF
	cQuery += "FROM %SF2.SQLNAME% "               + CRLF
	cQuery += "WHERE F2_FILIAL = '%SF2.FILIAL%' " + CRLF
	
	if !(lJob)
		cNotaDe   := oParamBox:getValue("notaDe")
		cNotaAte  := oParamBox:getValue("notaAte")
		cSerieDe  := oParamBox:getValue("serieDe")
		cSerieAte := oParamBox:getValue("serieAte")
		
		cQuery += "   AND F2_DOC   >= '" + cNotaDe   + "' " + CRLF
		cQuery += "   AND F2_DOC   <= '" + cNotaAte  + "' " + CRLF
		cQuery += "   AND F2_SERIE >= '" + cSerieDe  + "' " + CRLF
		cQuery += "   AND F2_SERIE <= '" + cSerieAte + "' " + CRLF
	else
		cQuery += "   AND F2_ZZSTORA <> 'S' " + CRLF
	endif
	
	cQuery += "   AND %SF2.NOTDEL%  " + CRLF
	cQuery += "   AND F2_TIPO IN ('N','C') " + CRLF
	cQuery += "   AND F2_FIMP = 'S' " + CRLF	
	
return cQuery


/**
* Função responsável pelo retorno dos itens da nota.
**/
static function getItensNota(cNota,cSerie,cCliente,cLoja)

	local cQuery 	:= ""
	local lAjusInv	:= GetNewPar("ZZ_PROCINP", .f.)//Thiago Meschiatti - FSW TOTVS IP Campinas - 22/12/2016
	
	cQuery := "SELECT SD2.*                          " + CRLF
	cQuery += "FROM %SD2.SQLNAME%                    " + CRLF
	cQuery += "INNER JOIN %SF4.SQLNAME% ON           " + CRLF
	cQuery += "      F4_FILIAL = '%SF4.FILIAL%'      " + CRLF 
	cQuery += "  AND F4_CODIGO = D2_TES              " + CRLF
	cQuery += "  AND F4_ZZCTB = 'S'                  " + CRLF
	// INICIO - Thiago Meschiatti - FSW TOTVS IP Campinas - 22/12/2016
	if !(lAjusInv)
		cQuery += "  AND F4_ZZAJESP <> 'S'           " + CRLF
	endif
	// FIM - Thiago Meschiatti - FSW TOTVS IP Campinas - 22/12/2016
	cQuery += "  AND %SF4.NOTDEL%                    " + CRLF
	cQuery += "WHERE D2_FILIAL  = '%SF2.FILIAL%'     " + CRLF
	cQuery += "  AND D2_DOC     = '" + cNota    + "' " + CRLF
	cQuery += "  AND D2_SERIE   = '" + cSerie   + "' " + CRLF
	cQuery += "  AND D2_CLIENTE = '" + cCliente + "' " + CRLF
	cQuery += "  AND D2_LOJA    = '" + cLoja    + "' " + CRLF
	cQuery += "  AND D2_TIPO    IN ('N','C') " + CRLF
	cQuery += "  AND %SD2.NOTDEL%                    " + CRLF

return cQuery


/**
* Função responsavel pela verificação da regra da TES
**/
static function validaTes(cTes)

	local oSqlObject := IpSqlObject():newIpSqlObject()	
	local cCont      := ""
	local lRet       := .F.
	
	cCont := oSqlObject:getFieldValue("SF4","F4_ZZCTB","F4_CODIGO = '"+AllTrim(cTes)+"' AND F4_FILIAL = '%SF4.FILIAL%' AND %SF4.NOTDEL% ")
	
	if cCont == "S"
		lRet := .T.
	else
		lErro := .T.
		cLog  := "TES informada ("+cTes+")" + " não gera contabilização. " +;
                 "Item: " + cItemNota + " Nota: " + cNota + " Série: " + cSerie	
		salvaErro(cLog)
	endif
	
return 


/**
* Função responsável pelo retorno do CNPJ de acordo com a filial logada / executada via job.
**/
static function retCnpj(cFilAtu)

	local cCnpj    := ""
	local aArea    := GetArea()
	local aAreaSM0 := SM0->(GetArea())
	 
	DbSelectArea("SM0")
	SM0->(DBGoTop())
	
	while SM0->(!eof())
		if AllTrim(SM0->M0_CODFIL) == AllTrim(cFilAtu)
			cCnpj := AllTrim(SM0->M0_CGC)
			exit
		endif
		SM0->(dbSkip())
	enddo
	
	restArea(aAreaSM0)
	restArea(aArea)
	
return cCnpj


/**
* Função responsável pela criação do arquivo no diretório temp.
**/
static function criaArquivo(oArquivo)
	
	local cHora		 := StrTran(Time(),":","")
	local cData		 := DtoS(dDataBase)
	local lRet		 := .T.
	local cLog		 := ""
	local cArqOrigem := ""	
	local cNomeArq	 := ""
	
	//cNomeArq   := "ORA_AR_"+cCnpj+"_"+cData+"_"+cHora+"_"+cNota+"_"+cSerie+".TXT"
	cPvtName_	:= "ORA_AR_"+cCnpj+"_"+cData+"_"+cHora+"_"+cNota+"_"+cSerie
	cNomeArq   := cPvtName_ + ".PROCESSING"
	
	cArqOrigem := getFilePath(cNomeArq)
	oArquivo   := IpFileObject():newIpFileObject(cArqOrigem)
	
	lRet := oArquivo:writeLine("")
	
	if !(lRet)
		lErro := .T.
		cLog := "Não foi possível criar o arquivo ("+cNomeArq+")"
		salvaErro(cLog)
	else
		oArquivo:goTop()
	endif
		
return lRet


/**
* Função responsável pela realização da cópia do arquivo.
**/
static function copiaArquivo(oArquivo)

	local cLog     := "Diretório não encontrado."
	local lRet     := .T.
	local cNomeArq := oArquivo:getFileName()
	local nRen     := 0
	
	//lRet := oArquivo:copy(cDirExp+cNomeArq)
	lRet := oArquivo:copy(cDirExp+cPvtName_+".TXT")
	
	if !(lRet)	
		lErro := .T.
		salvaErro(cLog) 
	else
		// 2017/10/11  11/10/2017 --- para tentar colocar maiusculo. mesmo estando em maiusculo antes de chamar oArquivo:copy( )
		nren := fRename(cDirExp+cPvtName_+".TXT" , upper( cDirExp+cPvtName_+".TXT" ) , nil , .f.  ) 	
	endif
	
return lRet


/**
* Função responsável pelo retorno das classes contábeis do item da nota fiscal.
**/
static function getClassNota(oSqlItensNota)
	local cLote		:= SuperGetMv("ZZ_LTORAGL",, "EST001")
	local cQuery := ""
	local cChave := oSqlItensNota:getValue("D2_FILIAL") + oSqlItensNota:getValue("D2_DOC")     +; 
					oSqlItensNota:getValue("D2_SERIE")	+ oSqlItensNota:getValue("D2_CLIENTE") +; 
					oSqlItensNota:getValue("D2_LOJA")	+ oSqlItensNota:getValue("D2_COD")     +;
					oSqlItensNota:getValue("D2_ITEM")
	local cChaveRec := oSqlItensNota:getValue("D2_FILIAL") + oSqlItensNota:getValue("D2_DOC")     +; 
					oSqlItensNota:getValue("D2_SERIE")	+ oSqlItensNota:getValue("D2_CLIENTE") +; 
					oSqlItensNota:getValue("D2_LOJA")				
	
	cQuery := "SELECT "  + CRLF
	cQuery += "	SUM(CT2_VALOR) CT2_VALOR, "    + CRLF
	cQuery += "	CT2_ITEMD, "    + CRLF
	cQuery += "	CT2_ITEMC, "    + CRLF
	cQuery += "	CT2_CCD, "      + CRLF
	cQuery += "	CT2_CCC, "      + CRLF
	cQuery += "	CT2_DC, "       + CRLF
	cQuery += "	CT2_EC06DB, "   + CRLF
	cQuery += "	CT2_EC06CR, "   + CRLF
	cQuery += "	CT2_CLVLCR, "   + CRLF
	cQuery += "	CT2_CLVLDB, "   + CRLF
	cQuery += "	CT2_DEBITO, "   + CRLF
	cQuery += "	CT2_CREDIT, "   + CRLF
	cQuery += "	CT2_EC05DB, "   + CRLF
	cQuery += "	CT2_EC05CR, "    + CRLF
	cQuery += "	CT2_AT01CR, "    + CRLF
	cQuery += "	CT2_AT01DB, "    + CRLF
	cQuery += "	CT2_AT02CR, "    + CRLF
	cQuery += "	CT2_AT02DB "    + CRLF	
	cQuery += "FROM "           + CRLF
	cQuery += "	%CT2.SQLNAME% " + CRLF
	cQuery += " WHERE "         + CRLF
	cQuery += "	CT2_FILIAL = '%CT2.FILIAL%' "     + CRLF	
	cQuery += "	AND %CT2.NOTDEL% "                + CRLF
	cQuery += "	AND CT2_KEY LIKE '%" + cChaveRec + "%' "  + CRLF
	cQuery += "	AND CT2_AT01DB = 'REC' "  + CRLF
	cQuery	+= " AND CT2_LOTE <> '"+cLote+"' " + CRLF
	cQuery += "GROUP BY "  + CRLF
	cQuery += "	CT2_ITEMD, "    + CRLF
	cQuery += "	CT2_ITEMC, "    + CRLF
	cQuery += "	CT2_CCD, "      + CRLF
	cQuery += "	CT2_CCC, "      + CRLF
	cQuery += "	CT2_DC, "       + CRLF
	cQuery += "	CT2_EC06DB, "   + CRLF
	cQuery += "	CT2_EC06CR, "   + CRLF
	cQuery += "	CT2_CLVLCR, "   + CRLF
	cQuery += "	CT2_CLVLDB, "   + CRLF
	cQuery += "	CT2_DEBITO, "   + CRLF
	cQuery += "	CT2_CREDIT, "   + CRLF
	cQuery += "	CT2_EC05DB, "   + CRLF
	cQuery += "	CT2_EC05CR, "    + CRLF
	cQuery += "	CT2_AT01CR, "    + CRLF
	cQuery += "	CT2_AT01DB, "    + CRLF
	cQuery += "	CT2_AT02CR, "    + CRLF
	cQuery += "	CT2_AT02DB "    + CRLF	
	
	cQuery += "UNION ALL "  + CRLF
				
	cQuery += "SELECT 
	cQuery += "	CT2_VALOR, "    + CRLF
	cQuery += "	CT2_ITEMD, "    + CRLF
	cQuery += "	CT2_ITEMC, "    + CRLF
	cQuery += "	CT2_CCD, "      + CRLF
	cQuery += "	CT2_CCC, "      + CRLF
	cQuery += "	CT2_DC, "       + CRLF
	cQuery += "	CT2_EC06DB, "   + CRLF
	cQuery += "	CT2_EC06CR, "   + CRLF
	cQuery += "	CT2_CLVLCR, "   + CRLF
	cQuery += "	CT2_CLVLDB, "   + CRLF
	cQuery += "	CT2_DEBITO, "   + CRLF
	cQuery += "	CT2_CREDIT, "   + CRLF
	cQuery += "	CT2_EC05DB, "   + CRLF
	cQuery += "	CT2_EC05CR, "    + CRLF
	cQuery += "	CT2_AT01CR, "    + CRLF
	cQuery += "	CT2_AT01DB, "    + CRLF
	cQuery += "	CT2_AT02CR, "    + CRLF
	cQuery += "	CT2_AT02DB "    + CRLF	
	cQuery += "FROM "           + CRLF
	cQuery += "	%CT2.SQLNAME% " + CRLF
	cQuery += " WHERE "         + CRLF
	cQuery += "	CT2_FILIAL = '%CT2.FILIAL%' "     + CRLF	
	cQuery += "	AND %CT2.NOTDEL% "                + CRLF
	cQuery += "	AND CT2_KEY = '" + cChave + "' "  + CRLF
	cQuery += "	AND CT2_AT01DB <> 'REC' "  + CRLF
	cQuery	+= "AND CT2_LOTE <> '"+cLote+"' " + CRLF


return cQuery
 
 
/**
* Funçao responsável pela montagem da linha.
**/
 static function criaLinha(aLinha)
 
 	local nI	 := ""
 	local cLinha := ""
 	local xValor := nil
 		
 	for nI := 1 to Len(aLinha)
		xValor := aLinha[nI]		
		if ValType(xValor) != "U"
			cLinha += trataValor(xValor)	
		endif
		
		cLinha += ";"
	next nI	
		
return cLinha		


/**
* Função responsável pela atriguição do valor para a posição do array.
**/
static function setValorLinha(aLinha, aPosicao, xValor)
	
	local nPos    := aPosicao[1]
	local cTitulo := aPosicao[2]
	
	if ValType(xValor) != "U"
		if Empty(xValor)
			lErro := .T.
			geraLog(cTitulo)
		else
			aLinha[nPos] := trataValor(xValor)
		endif
	endif
	
return


/**
*	Atibui o valor para a posição do array.
**/
static function geraLog(cTitulo)
	local cLog :=  "Campo(s) não preenchidos: " + cTitulo + " Item: " + cItemNota + " Nota: " + cNota + " Série: " + cSerie
	salvaErro(cLog)
return


/**
* Função responsável pela exibição da tela de parâmetros.
**/
static function exibeParametros()

	local cNome   := "ExpOraAr" 
	local cTitulo := "Informe documento e série"
	
	oParamBox  := IpParamBoxObject():newIpParamBoxObject(cNome)
	
	oParamBox:setTitle(cTitulo)
	
	oParam := IpParamObject():newIpParamObject("notaDe", "get", "Da Nota", "C", 9, TamSx3("F2_DOC")[1])
	oParam:setPicture("@!")
	oParam:setF3("SF2") 
	oParam:setRequired(.F.)
	
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("notaAte", "get", "Até a Nota", "C", 9, TamSx3("F2_DOC")[1])
	oParam:setPicture("@!")
	oParam:setF3("SF2") 
	oParam:setRequired(.T.)
	
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serieDe", "get", "Da Série", "C", 9, TamSx3("F2_SERIE")[1])
	oParam:setPicture("@!")
	oParam:setRequired(.T.)
	
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serieAte", "get", "Até a Série", "C", 4, TamSx3("F2_SERIE")[1])
	oParam:setPicture("@!")
	oParam:setRequired(.T.)
	
	oParamBox:addParam(oParam)

return oParamBox:show()


/**
* Função responsável pelo preenchimento do array de erros.
**/
static function salvaErro(cLog)
	aADD(aErros,cLog)
return 


/**
* Função responsável pelo retorno da string com todos os erros gerados durante o processo.
**/
static function retornaErro()

	local nI   := 1
	local cLog := ""
	
	for nI := 1 to Len(aErros)
		cLog += aErros[nI] + CRLF
	next nI
	
return cLog


/**
* Função responsável pela alteração da nota para processada.
**/
static function alteraStatusNota()

	local oSqlUtil := IpSqlObject():newIpSqlObject()
	local lRet     := oSqlUtil:update("SF2","F2_ZZSTORA = 'S'","F2_DOC = '"+cNota+"' AND F2_SERIE = '"+cSerie+"' AND F2_FILIAL = '%SF2.FILIAL%'")
	local cLog     := "Falha ao alterar status da nota para processada. Nota: " + cNota + "Série: " + cSerie
	
	if !(lRet)
		lErro := .T.
		salvaErro(cLog)
	endif
	
return lRet


/**
* Retorna o caminho dos arquivos do Oracle AR
**/
static function getFilePath(cNomeArq)

	local oSql   := ipSqlObject():newIpSqlObject()
	local oUtils := IpUtilsObject():newIpUtilsObject()
	local cPath  := ""
	
	cPath := AllTrim(oSql:getFieldValue("SZ1","Z1_DIREXP","Z1_FILIAL = '%SZ1.FILIAL%' AND Z1_CODIGO = '" + APP_ORACLE_AR + "'"))
	
	cPath := oUtils:concatDirectory(cPath,cNomeArq)
	
	oSql:close()
	
return cPath


/**
* Valida se existe TES com contabilização
**/
static function isAccounting(cNota,cSerie,cCliente,cLoja)

	local lValidation := .T.
	local cQuery      := ""
	local oSql        := ipSqlObject():newIpSqlObject()
	
	cQuery := getItensNota(cNota,cSerie,cCliente,cLoja)
		
	oSql:newAlias(cQuery)
	
	if oSql:isEof()
		lValidation := .F.
	endif
	
	oSql:close()
	
return lValidation