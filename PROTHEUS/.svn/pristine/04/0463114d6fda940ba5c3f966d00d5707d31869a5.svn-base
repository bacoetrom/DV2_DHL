#include "totvs.ch"
#include "dhl.ch"

#define ALTER_INVOICE 4
#define SZ4_FILIAL    1
#define SZ4_DOC       2
#define SZ4_SERIE     3
#define SZ4_CLIFOR    4
#define SZ4_LOJA      5


/*/{Protheus.doc} AgeNfSelScr

Tela de seleção das Nf´s de 1ª perna para cobertura.
Processo para a Unidade de Negócio DIS(Pfizer).

@author Thiago Meschiatti
@since 18/08/2016
@version undefined

@type function
/*/
user Function AgeNfSelScr()

	local oGetFilter    := nil
	local cDoc		    := SF1->F1_DOC
	local cSerie	    := SF1->F1_SERIE
	local cCodFor		:= ""
	local cForn		    := ""
	local cLoja		    := ""
	local oSql		    := IpSqlObject():newIpSqlObject()
	local aCF		    := Separa(getMV("ZZ_CFCOB"),";",.F.)
	local cCF		    := ""

	private oUtils      := IpUtilsObject():newIpUtilsObject()
	private cIdents     := ""
	private oGrid       := nil
	private oDlg        := nil
	private lMsErroAuto := .F.
	Private lMsHelpAuto := .F.
	private aDetail     := {}
	private aHeader     := {}
	private lBKM	:= SuperGetMV("ZZ_COBAGE",,.T.)
	private lNewAge       := SuperGetMV("ZZ_NEWAGE",,.F.) //adicionado por Edson Deluca - FIT Gestão	

	cCodFor := SF1->F1_FORNECE
	cLoja 	:= SF1->F1_LOJA

	if SF1->F1_TIPO $ "B|D|"
		cForn := AllTrim(Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE,"A1_NOME"))
	else
		cForn := AllTrim(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE,"A2_NOME"))
	endif

	for nI := 1 to Len(aCF)
		cCF += "'"+aCF[nI]+"',"
	next

	cCF := Substr(cCF,1,Len(cCF)-1)

	if oSql:exists("SD1","D1_FILIAL = '" + SF1->F1_FILIAL + "' AND D1_DOC     = '" + SF1->F1_DOC     + "' AND "+;
	"D1_SERIE  = '" + SF1->F1_SERIE  + "' AND D1_FORNECE = '" + SF1->F1_FORNECE + "' AND "+;
	"D1_LOJA   = '" + SF1->F1_LOJA   + "' AND D1_ZZCFOP IN (" + cCF + ") ")

		MsgAlert("NF´s de primeira perna não podem ser selecionadas para cobertura ! Verifique.")
		return
	endif

	DEFINE MSDIALOG oDlg TITLE "Seleção de notas para cobertura" FROM 001,001 TO 500,900 PIXEL OF oMainWnd

	createFromSql(@oGrid,oDlg)

	@ 010,007 SAY LabelDoc   PROMPT "NF de cobertura" SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010,100 SAY LabelSerie PROMPT "Série"           SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010,170 SAY LabelLoja  PROMPT "Código"          SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010,210 SAY LabelLoja  PROMPT "Loja"            SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010,270 SAY LabelForn  PROMPT "Fornecedor"      SIZE 150, 010 OF oDlg COLORS 0, 16777215 PIXEL


	@ 020,007 MSGET oGetNF   VAR cDoc    SIZE 060,010 PIXEL OF oDlg WHEN .F.
	@ 020,100 MSGET oGetNF   VAR cSerie  SIZE 030,010 PIXEL OF oDlg WHEN .F.
	@ 020,170 MSGET oGetNF   VAR cCodFor SIZE 030,010 PIXEL OF oDlg WHEN .F.
	@ 020,210 MSGET oGetNF   VAR cLoja   SIZE 030,010 PIXEL OF oDlg WHEN .F.
	@ 020,270 MSGET oGetForn VAR cForn   SIZE 150,010 PIXEL OF oDlg WHEN .F.

	@ 225,304 BUTTON "Visualizar" SIZE 35,12 ACTION {|| visualiza() } PIXEL OF oDlg
	@ 225,351 BUTTON "OK"         SIZE 35,12 ACTION {|| FWMsgRun(, {|| cobertura()},,"Aguarde realizando a cobertura...") } PIXEL OF oDlg
	@ 225,398 BUTTON "Cancelar"   SIZE 35,12 ACTION {|| oDlg:end()  } PIXEL OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

return


/**
* Criação do grid
*/
static function createFromSql(oGrid,oDlg)

	local nCol    := 5
	local nRow    := 40
	local nWidth  := 440
	local nHeight := 220
	local oGrid   := IpGridObject():newIpGridObject(nCol,nRow,nWidth,nHeight,oDlg)
	local cQuery  := getSql()

	oGrid:addMarkColumn({|| vldMark(oGrid),oDlg:refresh() })

	oGrid:addSqlColumns(cQuery)

	for nI := 1 to oGrid:length()
		oGrid:setMarkedLine(.F.,nI)
	next

	oGrid:setReadOnly(.T.)
	oGrid:create()

return


/**
* Query dos dados da Grid
*/
static function getSql()

	local cQuery := ""

	cQuery := "SELECT DISTINCT Z4_DOC,Z4_SERIE,Z4_CLIFOR,"+ CRLF
	cQuery += "                Z4_LOJA,A2_NOME"           + CRLF
	cQuery += "FROM %SZ4.SQLNAME%"                        + CRLF
	cQuery += "INNER JOIN %SA2.SQLNAME%"                  + CRLF
	cQuery += "ON A2_FILIAL = '%SA2.FILIAL%' AND"         + CRLF
	cQuery += "   A2_COD    = Z4_CLIFOR AND"              + CRLF
	cQuery += "   A2_LOJA   = Z4_LOJA AND"                + CRLF
	cQuery += " %SA2.NOTDEL%"                             + CRLF
	cQuery += "INNER JOIN %SF1.SQLNAME%"                  + CRLF
	cQuery += "ON F1_FILIAL  = Z4_FILIAL AND"             + CRLF
	cQuery += "   F1_DOC     = Z4_DOC AND"                + CRLF
	cQuery += "   F1_SERIE   = Z4_SERIE AND"              + CRLF
	cQuery += "   F1_FORNECE = Z4_CLIFOR AND"             + CRLF
	cQuery += "   F1_LOJA    = Z4_LOJA AND"               + CRLF
	cQuery += "   F1_ZZSTATU = ' ' AND"                   + CRLF
	cQuery += " %SF1.NOTDEL%"                             + CRLF
	cQuery += "WHERE Z4_FILIAL = '%SZ4.FILIAL%' AND"      + CRLF
	cQuery += "      Z4_TIPMOV  = '1' AND"                + CRLF
	cQuery += "      Z4_SALDO <> 0 AND"                   + CRLF
	cQuery += "    %SZ4.NOTDEL%"                          + CRLF

return cQuery


/**
* Executa a cobertura na tabela de vínculos
*/
static function cobertura()

	local aNfCobertas := {}
	local nNota       := 0
	local lError      := .F.
	local lCobert	  := .T.
	local aAreaSF1    := SF1->(getArea())
	local aAreaSD1    := SD1->(getArea())
	local cMsgSF3     := ""
	local cMsg2		  := ""
	local cDoc        := ""
	local cSerie      := ""
	local cFornece    := ""
	local cLoja       := ""
	local dEmissao	:= CTOD("  /  /  ")
	local lValcBenef := SuperGetMV("ZZ_VALCBEN",,.F.)

	begin transaction

		if hasItems()
			if validaLinhas()			

				aNfCobertas := grava2Perna()

				lError  := classifyInvoice(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA, lCobert)
				cDoc	:= SF1->F1_DOC
				cSerie	:= SF1->F1_SERIE
				cFornece:= SF1->F1_FORNECE
				cLoja	:= SF1->F1_LOJA
				dEmissao:= SF1->F1_EMISSAO

				if !(lError)
					if len(aNFCobertas) > 0
						for nNota := 1 to Len(aNFCobertas)

							lError := classifyInvoice(aNFCobertas[nNota][SZ4_DOC],aNFCobertas[nNota][SZ4_SERIE],aNFCobertas[nNota][SZ4_CLIFOR],aNFCobertas[nNota][SZ4_LOJA])							

							if lValcBenef
								if !lError
									lError := checkCBnefXMLIsCDV(cDoc, cSerie, cFornece, cLoja, aNFCobertas[nNota][SZ4_DOC],aNFCobertas[nNota][SZ4_SERIE],aNFCobertas[nNota][SZ4_CLIFOR],aNFCobertas[nNota][SZ4_LOJA])
								endIf
							endIf

							if lError
								DisarmTransaction()
								exit
							else
								cMsg2	+= retMsg2(aNFCobertas[nNota][SZ4_DOC], aNFCobertas[nNota][SZ4_SERIE], aNFCobertas[nNota][SZ4_CLIFOR], aNFCobertas[nNota][SZ4_LOJA])
								cMsgSF3 := "Remessa Simbólica: " + AllTrim(cDoc) + "-" + AllTrim(cSerie) + ", " + Dtoc(dEmissao)

								lError := updZZStatus(aNFCobertas[nNota][SZ4_DOC],aNFCobertas[nNota][SZ4_SERIE],aNFCobertas[nNota][SZ4_CLIFOR],aNFCobertas[nNota][SZ4_LOJA],cMsgSF3)

								if lError
									DisarmTransaction()
									exit
								else
									lError := u_ProcNfAut(DHL_NFE_INVOICE_OUTFLOW, cDoc, cSerie, cFornece, cLoja)
									if lError
										DisarmTransaction()
										exit
									endif
								endif
							endif
						next nNota
					else
						ApMsgInfo( "Não foi encontrado notas a serem cobertas. <br>RollBack realizado referente a nota/série: <b>"+ allTrim(cDoc) + "/" + allTrim(cSerie) +"</b> <br><br>"+;
						"<b>Solução:</b> Verique a nota de 1º perna.","Atenção")
						DisarmTransaction()
						lError := .T.
					endif
				else
					DisarmTransaction()
				endif
				if !empty(cMsg2)
					cMsg2 := "Remessa Conta e Ordem: " + cMsg2
					lError := updZZStatus(cDoc,cSerie,cFornece,cLoja,cMsg2)
					if lError
						DisarmTransaction()
					endif
				endif

				restArea(aAreaSD1)
				restArea(aAreaSF1)

				if !(lError)
					U_AgeFiscalCoverage(aNfCobertas)

					MsgAlert("Processo de cobertura concluído !")
				endif
				oDlg:end()
			endif
		else
			MsgAlert("Itens não foram selecionados! Processo de cobertura não realizado!")
			oDlg:end()
		endif

	end transaction

return


/**
* Atualiza o campo Mensagem no Livro Fiscal
**/
static function updZZStatus(cNFiscal,cNFSerie,cNFCliet,cNFLoja,cStatus)

	local cWhere  := ""
	local cMsg	  := ""
	local lUpdate := nil
	local lError  := .F.
	local oSql	  := IpSqlObject():newIpSqlObject()

	cWhere := "F3_FILIAL  = '%SF3.FILIAL%'     AND "
	cWhere += "F3_NFISCAL = '" + cNFiscal + "' AND "
	cWhere += "F3_SERIE   = '" + cNFSerie + "' AND "
	cWhere += "F3_CLIEFOR = '" + cNFCliet + "' AND "
	cWhere += "F3_LOJA    = '" + cNFLoja  + "'     "

	cMsg := oSql:getFieldValue("SF3","F3_OBSERV",cWhere)

	lUpdate := oSql:update("SF3","F3_OBSERV = '" + AllTrim(cMsg) + " - " + left(AllTrim(cStatus),57) + "'",cWhere)

	if !(lUpdate)
		lError := .T.
		MsgAlert("Falha ao atualizar a Mensagem no Livro Fiscal para a Nota " + cNFiscal + " Serie " + cNFSerie + "." + CRLF+CRLF+oSql:getLastError())
	endif

return lError


/**
* Valida se a cobertura pode ser realizada
*/
static function validaLinhas()

	local nLine       	:= 0
	local aSD1 	      	:= SD1->(GetArea())
	local lOK	      	:= .T.
	local aSoma       	:= {}
	local nSoma       	:= 0
	local cErro	      	:= ""
	local aProdQuants 	:= {}
	local aSomaProds  	:= {}
	local aVlrUnit    	:= {}
	local nPos        	:= 0
	local nI          	:= 0
	local oSql		  	:= IpSqlObject():newIpSqlObject()
	local cQuery	  	:= ""
	local aDocument1	:= {}
	local aDocument2	:= {}
	local nQtdProdAglut	:= 0

	dbSelectArea("SD1")
	SD1->(dbsetOrder(1))
	SD1->(dbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))

	oSql:newAlias("	SELECT D1_DOC, D1_SERIE, D1_COD, SUM(D1_QUANT) D1_QUANT, D1_VUNIT, D1_FORNECE, D1_LOJA, D1_ITEM, D1_TOTAL  FROM ( "+;
	"				SELECT D1_DOC, D1_SERIE, D1_COD, D1_QUANT, TRUNC(D1_VUNIT,2) D1_VUNIT, D1_FORNECE, D1_LOJA, D1_ITEM, D1_TOTAL "+;
	"					FROM %SD1.SQLNAME% "+;
	"  				WHERE %SD1.XFILIAL% "+;
	" 					AND %SD1.NOTDEL% AND D1_DOC = '"+SF1->F1_DOC+"' AND D1_SERIE = '"+SF1->F1_SERIE+"' "+;
	" 					AND D1_FORNECE = '"+SF1->F1_FORNECE+"' AND D1_LOJA = '"+SF1->F1_LOJA+"' "+;
	" 		) GROUP BY D1_DOC, D1_SERIE, D1_COD, D1_VUNIT, D1_FORNECE, D1_LOJA, D1_ITEM, D1_TOTAL ")

	while oSql:notIsEof()

		nSoma	:= getSoma1Perna(oSql:getValue("D1_COD"))
		aVlrUnit:= getVlrUnit(oSql:getValue("D1_COD"))

		nQtdProdAglut := GetQuantProdAglutin(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA, oSql:getValue("D1_COD"))

		if nQtdProdAglut <> nSoma
			cErro := "Foram encontradas divergências de quantidade entre produtos !"+CRLF+CRLF
			cErro += "2ª Perna"+CRLF+"NF "+AllTrim(oSql:getValue("D1_DOC"))+" - Produto: "+AllTrim(oSql:getValue("D1_COD"))+" - Quantidade: "+cValtoChar(oSql:getValue("D1_QUANT"))/*+" - Valor: "+AllTrim(Transform(SD1->D1_TOTAL,PesqPict("SD1","D1_TOTAL")))*/+CRLF+CRLF
			cErro += "Totais de 1ª Perna marcadas"+CRLF+"Produto: "+AllTrim(oSql:getValue("D1_COD"))+" - Quantidade: "+cValtoChar(nSoma)/*" - Valor: "+AllTrim(Transform(aSoma[2],PesqPict("SD1","D1_TOTAL")))*/+CRLF+CRLF
			cErro += "Processo Cancelado ! Verifique as quantidades."
			MsgAlert(cErro)
			lOK := .F.
			exit
		endif

		aAdd(aDocument2, {oSql:getValue("D1_DOC"), oSql:getValue("D1_SERIE"), oSql:getValue("D1_FORNECE"), oSql:getValue("D1_LOJA"), oSql:getValue("D1_ITEM"), oSql:getValue("D1_VUNIT"), oSql:getValue("D1_QUANT")} )

		nPos := aScan(aProdQuants, {|x| allTrim(x[1]) == allTrim(oSql:getValue("D1_COD"))})

		if nPos == 0
			aadd(aProdQuants,{oSql:getValue("D1_COD"),nQtdProdAglut})
		endIf

		oSql:skip()

	enddo
	oSql:close()

	cQuery := ExecQry1Perna()

	oSql:newAlias(cQuery)

	while oSql:notIsEof()

		aAdd(aDocument1, {oSql:getValue("Z4_DOC"), oSql:getValue("Z4_SERIE"), oSql:getValue("Z4_CLIFOR"), oSql:getValue("Z4_LOJA"), oSql:getValue("Z4_ITEM") })
		oSql:skip()

	EndDo

	oSql:close()

	If lOk
		FWMsgRun(, {|| lOk := calcularPesoBruto(aDocument1, aDocument2, SF1->F1_TIPO) },,"Aguarde...realizando o calculo dos valores brutos")
	EndIf

	if lOK

		aSomaProds := getSoma1Perna()

		for nI := 1 to Len(aProdQuants)
			nPos := aScan(aSomaProds,{|x| x[1] == aProdQuants[nI][1]})
			if nPos > 0
				if aSomaProds[nPos][2] <> aProdQuants[nI][2]
					MsgAlert("Todas as notas selecionadas deverão ser cobertas totalmente ! Verifique.")
					lOK := .F.
					exit
				endif
			else
				MsgAlert("Todas as notas selecionadas deverão ser cobertas totalmente ! Verifique.")
				lOK := .F.
				exit
			endif
		next

	endif

	RestArea(aSD1)

return lOK

/**
* Obtém a quantidade de produtos iguais aglutinados
*/
static function GetQuantProdAglutin(cDoc, cSerie, cFornece, cLoja, cProduto)

	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	local nQuant	:= 0

	cQuery			:= GetQuery(cDoc, cSerie, cFornece, cLoja, cProduto)

	oSql:newAlias(cQuery)

	if oSql:hasRecords()

		nQuant := oSql:GetValue("D1_QUANT")

	endIf

	oSql:close()

return nQuant

/**
* Obtém a query
*/
static function GetQuery(cDoc, cSerie, cFornece, cLoja, cProduto)

	local cQuery := ""

	cQuery := " SELECT D1_DOC, D1_SERIE, D1_COD, SUM(D1_QUANT) D1_QUANT,  D1_FORNECE, D1_LOJA  FROM " 								+ CRLF
	cQuery += " ( " 																												+ CRLF
	cQuery += " 	SELECT D1_DOC, D1_SERIE, D1_COD, D1_QUANT, TRUNC(D1_VUNIT,2) D1_VUNIT, D1_FORNECE, D1_LOJA, D1_ITEM, D1_TOTAL " + CRLF
	cQuery += " 	FROM %SD1.SQLNAME% " 																							+ CRLF
	cQuery += " 	WHERE %SD1.XFILIAL% " 																							+ CRLF
	cQuery += " 	AND %SD1.NOTDEL% AND D1_DOC = '"+cDoc+"' AND D1_SERIE = '"+cSerie+"' "											+ CRLF																						+ CRLF
	cQuery += " 	AND D1_FORNECE = '"+cFornece+"' AND D1_LOJA = '"+cLoja+"' " 									    			+ CRLF
	cQuery += " 	AND D1_COD = '"+cProduto+"'" 									    											+ CRLF
	cQuery += " ) " 																												+ CRLF
	cQuery += "GROUP BY D1_DOC, D1_SERIE, D1_COD, D1_FORNECE, D1_LOJA "																+ CRLF

return cQuery


/**
* Valida se a cobertura pode ser realizada
*/
static function getSoma1Perna(cProduto)

	local aSoma 		:= {}
	local cDocs 		:= ""
	local cSeries 		:= ""
	local cFornecedores	:= ""
	local cLojas 		:= ""
	local cQuery		:= ""
	local oSql 			:= IpSqlObject():newIpSqlObject()
	local nLine			:= 0
	local nQuant		:= 0
	local nVlr			:= 0
	local aSomaProds	:= {}

	default cProduto := ""

	for nLine := 1 to oGrid:length()
		if oGrid:isMarkedLine(nLine)
			cDocs         += "'" + oGrid:getValue("Z4_DOC", nLine)    + "',"
			cSeries       += "'" + oGrid:getValue("Z4_SERIE", nLine)  + "',"
			cFornecedores += "'" + oGrid:getValue("Z4_CLIFOR", nLine) + "',"
			cLojas        += "'" + oGrid:getValue("Z4_LOJA", nLine)   + "',"
		endIf
	next nLine

	cDocs         := Substr(cDocs,1,Len(cDocs)-1)
	cSeries       := Substr(cSeries,1,Len(cSeries)-1)
	cFornecedores := Substr(cFornecedores,1,Len(cFornecedores)-1)
	cLojas        := Substr(cLojas,1,Len(cLojas)-1)
	cIdents       := getIdents(cDocs, cSeries, cFornecedores, cLojas)

	cQuery := "SELECT Z4_PRODUTO,SUM(Z4_QUANT) QUANT"          + CRLF
	cQuery += "FROM %SZ4.SQLNAME%"                             + CRLF
	cQuery += "WHERE Z4_FILIAL = '%SZ4.FILIAL%' AND"           + CRLF
	cQuery += "      Z4_DOC    IN (" + cDocs + ") AND"         + CRLF
	cQuery += "      Z4_SERIE  IN (" + cSeries + ") AND"       + CRLF
	cQuery += "      Z4_CLIFOR IN (" + cFornecedores + ") AND" + CRLF
	cQuery += "      Z4_LOJA   IN (" + cLojas + ") AND"        + CRLF

	if !(Empty(cProduto))
		cQuery += "  Z4_PRODUTO = '" + cProduto + "' AND " + CRLF
	endif

	cQuery += "      Z4_TIPMOV = '1' AND" + CRLF
	cQuery += "      Z4_SALDO > 0 AND"    + CRLF
	cQuery += "      %SZ4.NOTDEL%"        + CRLF
	cQuery += "GROUP BY Z4_PRODUTO"       + CRLF

	oSql:newAlias(cQuery)

	if Empty(cProduto)
		while oSql:notIsEof()
			aadd(aSomaProds, {oSql:getValue("Z4_PRODUTO"),oSql:getValue("QUANT")})
			oSql:skip()
		enddo
	else
		nQuant := oSql:getValue("QUANT")
	endif

	oSql:close()

return(iif(Empty(cProduto),aSomaProds,nQuant))


/**
* Gravação da NF de 2.a perna na tabela de vínculos SZ4
*/
static function grava2Perna()

	local oSql	      := IpSqlObject():newIpSqlObject()
	local oSql2	      := IpSqlObject():newIpSqlObject()
	local oSql3	      := IpSqlObject():newIpSqlObject()
	local cRecnoSFora := ""
	local aNfCobertas := {}
	local nPos        := 0

	oSql2:newTable("SZ4","*","Z4_FILIAL = '%SZ4.FILIAL%' AND R_E_C_N_O_ IN (" + cIdents + ")")

	while oSql2:notIsEof()

		if oSql:exists("SD1","D1_FILIAL = '" + SF1->F1_FILIAL + "' AND D1_DOC     = '" + SF1->F1_DOC     + "' AND "   +;
		"D1_SERIE  = '" + SF1->F1_SERIE  + "' AND D1_FORNECE = '" + SF1->F1_FORNECE + "' AND "   +;
		"D1_LOJA   = '" + SF1->F1_LOJA   + "' AND D1_COD     = '" + oSql2:getValue("Z4_PRODUTO") +"' ")

			RecLock("SZ4",.T.)
			SZ4->Z4_FILIAL 	:= xFilial("SZ4")
			SZ4->Z4_DOC 	:= SF1->F1_DOC
			SZ4->Z4_SERIE 	:= SF1->F1_SERIE
			SZ4->Z4_CLIFOR 	:= SF1->F1_FORNECE
			SZ4->Z4_LOJA 	:= SF1->F1_LOJA
			SZ4->Z4_PRODUTO	:= oSql2:getValue("Z4_PRODUTO")
			SZ4->Z4_QUANT	:= oSql2:getValue("Z4_QUANT")
			SZ4->Z4_TIPMOV	:= "2"
			SZ4->Z4_SALDO	:= 0
			SZ4->Z4_IDCOB	:= oSql2:getValue("Z4_IDCOB")
			SZ4->Z4_ITEM	:= oSql2:getValue("Z4_ITEM")
			SZ4->(MsUnlock())

		else
			if oSql:exists("SZ4","Z4_SALDO > 0 AND R_E_C_N_O_ = '"+cValtoChar(oSql2:getValue("R_E_C_N_O_"))+"'")
				cRecnoSFora += cValtoChar(oSql2:getValue("R_E_C_N_O_"))+","
			endif
		endif

		nPos := aScan(aNfCobertas,{|x| x[1]+x[2]+x[3]+x[4]+x[5] == oSql2:getValue("Z4_FILIAL")+oSql2:getValue("Z4_DOC")+oSql2:getValue("Z4_SERIE")+oSql2:getValue("Z4_CLIFOR")+oSql2:getValue("Z4_LOJA")})

		if nPos == 0
			aadd(aNfCobertas,{oSql2:getValue("Z4_FILIAL"),oSql2:getValue("Z4_DOC"),oSql2:getValue("Z4_SERIE"),oSql2:getValue("Z4_CLIFOR"),oSql2:getValue("Z4_LOJA")})
		endif

		oSql2:skip()

	enddo

	cRecnoSFora := Substr(cRecnoSFora,1,Len(cRecnoSFora)-1)

	oSql:update("SZ4","Z4_SALDO = 0","R_E_C_N_O_ IN (" + cIdents + ") " + iif(!Empty(cRecnoSFora),"AND R_E_C_N_O_ NOT IN ("+cRecnoSFora+")",""))

	if !(Empty(cRecnosFora))
		aNfCobertas := {}
	endif

	oSql2:close()

return(aNfCobertas)


/**
* Obtem o ID de cobertura da segunda perna
*/
static function getID(cProduto)

	local oSql 	:= IpSqlObject():newIpSqlObject()
	local cID	:= ""

	oSql:newTable("SZ4", "Z4_IDCOB", "Z4_FILIAL = '%SZ4.FILIAL%' AND Z4_PRODUTO = '"+cProduto+"' AND R_E_C_N_O_ IN ("+cIdents+")")

	cID := oSql:getValue("Z4_IDCOB")

	oSql:close()

return(cID)


/**
* Obtem os IDs de cobertura dos itens selecionados
*/
static function getIdents(cDocs, cSeries, cFornecedores, cLojas)

	local oSql 	  := IpSqlObject():newIpSqlObject()
	local cIdents := ""

	oSql:newTable("SZ4", "R_E_C_N_O_", "Z4_FILIAL = '%SZ4.FILIAL%' AND Z4_DOC IN ("+cDocs+") AND Z4_SERIE IN ("+cSeries+") AND Z4_CLIFOR IN ("+cFornecedores+") AND Z4_LOJA IN ("+cLojas+") ")

	while oSql:notIsEof()
		cIdents += cValToChar(oSql:getValue("R_E_C_N_O_"))+","
		oSql:skip()
	enddo

	cIdents := Substr(cIdents,1,Len(cIdents)-1)

	oSQl:close()

return(cIdents)


/**
* Visualiza a pré nota posicionada
*/
static function visualiza()

	local oSql 	 := IpSqlObject():newIpSqlObject()
	local nRecno := 0
	local aSF1   := SF1->(getArea())

	oSql:newTable("SF1", "R_E_C_N_O_", "F1_FILIAL = '%SF1.FILIAL%' AND F1_DOC = '"+oGrid:getValue("Z4_DOC")+"' AND F1_SERIE = '"+oGrid:getValue("Z4_SERIE")+;
	"' AND F1_FORNECE = '"+oGrid:getValue("Z4_CLIFOR")+"' AND F1_LOJA = '"+oGrid:getValue("Z4_LOJA")+"' ")

	nRecno := oSql:getValue("R_E_C_N_O_")

	oSql:close()

	dbSelectArea("SF1")
	SF1->(dbGoTo(nRecno))
	A140NFiscal("SF1",SF1->(Recno()),2)

	restArea(aSF1)

return


/**
* Valida se pode ou não marcar o registro
*/
static function vldMark(oGrid)

	local lOk	:= .T.

	if hasMarkedLines(oGrid)
		if hasParcial(oGrid)
			lOk := .F.
		else
			if isParcial(oGrid)
				lOk := .F.
			endif
		endif
	endif

	if !lOk
		msgAlert("Não é possível selecionar mais NF´s quando há NF´s cobertas parcialmente selecionadas ! Verifique.")
		oGrid:setMarkedLine(.F.)
	endif

return


/**
* Verifica se há registros parcialmente cobertos
*/
static function hasParcial(oGrid)

	local oSql 	:= IpSqlObject():newIpSqlObject()
	local lOk 	:= .F.
	local nLine := 0

	for nLine := 1 to oGrid:length()
		if oGrid:isMarkedLine(nLine)
			if oSql:exists("SZ4", "Z4_FILIAL='%SZ4.FILIAL%' AND Z4_DOC='"+oGrid:getValue("Z4_DOC",nLine)+;
			"' AND Z4_SERIE='"+oGrid:getValue("Z4_SERIE",nLine)+"' AND Z4_CLIFOR='"+oGrid:getValue("Z4_CLIFOR",nLine)+;
			"' AND Z4_LOJA='"+oGrid:getValue("Z4_LOJA",nLine)+"' AND Z4_TIPMOV='1' AND Z4_SALDO = 0 ")
				lOk := .T.
			endif
		endif
	next

return(lOk)


/**
* Verifica se o registro que está sendo marcado é parcial
*/
static function isParcial(oGrid)

	local oSql 	:= IpSqlObject():newIpSqlObject()
	local lOk	:= .F.
	local cExpQuery := "Z4_FILIAL='%SZ4.FILIAL%' AND Z4_DOC='"+oGrid:getValue("Z4_DOC")+;
	"' AND Z4_SERIE='"+oGrid:getValue("Z4_SERIE")+"' AND Z4_CLIFOR='"+oGrid:getValue("Z4_CLIFOR")+;
	"' AND Z4_LOJA='"+oGrid:getValue("Z4_LOJA")+"' AND Z4_TIPMOV='1' AND Z4_SALDO = 0 "

	if oSql:exists("SZ4", cExpQuery)
		lOk := .T.
	endif

return(lOk)


/**
* Verifica se há registros marcados
*/
static function hasMarkedLines(oGrid)

	local lOk    := .F.
	local nLinha := oGrid:getCursorLine()

	for nI := 1 to oGrid:length()
		if nI <> nLinha
			if oGrid:isMarkedLine(nI)
				lOk := .T.
			endif
		endif
	next

return lOk


/**
* Classifica a Nota Fiscal de Entrada
**/
static function classifyInvoice(cNota,cSerie,cClieFor,cLoja,lCobert)

	local aDetails := {}
	local cKeySF1  := ""
	local cKeySD1  := ""
	local lError   := .F.

	default lCobert := .f.

	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)

	if !(SF1->(Found()))
		lError := .T.
		MsgAlert("Nota Fiscal " + cNota + " Serie " + cSerie + " não encontrada.")
		return lError
	else
		RecLock("SF1",.F.)
		SF1->F1_ZZSTATU := " "
		SF1->(MsUnLock())
	endif

	cKeySF1 := xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

	mountHeader()

	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(cKeySF1)

	if !(SD1->(Found()))
		lError := .T.
		MsgAlert("Problemas com o itens da Nota Fiscal " + cNota + " Serie " + cSerie + ".")
		return lError
	endif

	while !(SD1->(Eof()))

		cKeySD1 := SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

		if cKeySD1 != cKeySF1
			exit
		endif

		if Empty(getTes(lCobert))
			lError := .T.
			MsgAlert("Nota Fiscal " + cNota + " Serie " + cSerie + " contém item(ns) com o campo TES(D1_ZZTES) em branco.")
			return lError
		endif

		mountDetail(lCobert)

		aAdd(aDetails,aDetail)

		SD1->(dbSkip())
	enddo

	if Len(aDetails) > 0

		ordenaDetailsByItem(@aDetails)

		//begin transaction
		MSExecAuto({ |x,y,z| MATA103(x,y,z) },aHeader,aDetails,ALTER_INVOICE)
		//end transaction

		if lMsErroAuto

			Aviso(FunDesc(),"Falha ao classificar a Nota Fiscal de Entrada, verifique se o tipo da nota esta correto e/ou log de inconsistência."+CRLF+CRLF+oUtils:getErroAuto(),{"OK"},3)

			lError := .T.
		endif
	endif

return lError


/**
* Monta o cabelhaço da Nota Fiscal
**/
static function mountHeader()

	local nCount	:= 0
	local aCposSX3	:= FWSX3Util():GetAllFields("SF1",.f.)

	aHeader := {}

	aAdd(aHeader,{"F1_TIPO"   ,SF1->F1_TIPO   ,nil})
	aAdd(aHeader,{"F1_FORMUL" ,SF1->F1_FORMUL ,nil})
	aAdd(aHeader,{"F1_DOC"    ,SF1->F1_DOC    ,nil})
	aAdd(aHeader,{"F1_SERIE"  ,SF1->F1_SERIE  ,nil})
	aAdd(aHeader,{"F1_EMISSAO",SF1->F1_EMISSAO,nil})
	aAdd(aHeader,{"F1_DTDIGIT",SF1->F1_DTDIGIT,nil})
	aAdd(aHeader,{"F1_RECBMTO",SF1->F1_RECBMTO,nil})
	aAdd(aHeader,{"F1_FORNECE",SF1->F1_FORNECE,nil})
	aAdd(aHeader,{"F1_LOJA"   ,SF1->F1_LOJA   ,nil})
	aAdd(aHeader,{"F1_COND"   ,SF1->F1_COND   ,nil})
	aAdd(aHeader,{"F1_EST"    ,SF1->F1_EST    ,nil})
	aAdd(aHeader,{"F1_ESPECIE",SF1->F1_ESPECIE,nil})

	for nCount := 1 to len(aCposSX3)

		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U"
			aAdd(aHeader,{AllTrim(aCposSX3[nCount]),&("SF1->" + AllTrim(aCposSX3[nCount])),nil})
		endIf

	next nCount

return


/**
* Monta os items da Nota Fiscal
**/
static function mountDetail(lCobert)

	local nCount	:= 0
	local aCposSX3	:= FWSX3Util():GetAllFields("SD1",.f.)

	aDetail := {}

	aAdd(aDetail,{"D1_ITEM"   ,SD1->D1_ITEM   ,nil})
	aAdd(aDetail,{"D1_COD"    ,SD1->D1_COD    ,nil})
	aAdd(aDetail,{"D1_UM"     ,SD1->D1_UM     ,nil})
	aAdd(aDetail,{"D1_QUANT"  ,SD1->D1_QUANT  ,nil})
	aAdd(aDetail,{"D1_VUNIT"  ,SD1->D1_VUNIT  ,nil})
	aAdd(aDetail,{"D1_TOTAL"  ,SD1->D1_TOTAL  ,nil})
	aAdd(aDetail,{"D1_LOCAL"  ,SD1->D1_LOCAL  ,nil})
	aAdd(aDetail,{"D1_LOTEFOR",SD1->D1_LOTEFOR,nil})
	aAdd(aDetail,{"D1_LOTECTL",SD1->D1_LOTECTL,nil})
	aAdd(aDetail,{"D1_EMISSAO",SD1->D1_EMISSAO,nil})
	aAdd(aDetail,{"D1_TES"    ,getTes(lCobert),nil})
	aAdd(aDetail,{"D1_ZZTES"  ,getTes(lCobert),nil})	

	for nCount := 1 to len(aCposSX3)

		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U"
			aAdd(aDetail,{AllTrim(aCposSX3[nCount]),&("SD1->" + AllTrim(aCposSX3[nCount])),nil})
		endIf

	next nCount

	aDetail:= FwVetByDic(aDetail, "SD1")

return


/**
* Coleta a TES para classificar a Nota Fiscal
**/
static function getTes(lCobert)
return AllTrim(SD1->D1_ZZTES )


/**
* Valida se a cobertura pode ser realizada
*/
static function getVlrUnit(cProduto)

	local aSoma 		:= {}
	local cDocs 		:= ""
	local cSeries 		:= ""
	local cFornecedores	:= ""
	local cLojas 		:= ""
	local cQuery		:= ""
	local oSql 			:= IpSqlObject():newIpSqlObject()
	local oSqlUtil	 	:= IpSqlObject():newIpSqlObject()
	local nLine			:= 0
	local nQuant		:= 0
	local nVlr			:= 0
	local aVlrProds		:= {}

	default cProduto := ""

	for nLine := 1 to oGrid:length()
		if oGrid:isMarkedLine(nLine)
			cDocs += "'"+oGrid:getValue("Z4_DOC", nLine)+"',"
			cSeries += "'"+oGrid:getValue("Z4_SERIE", nLine)+"',"
			cFornecedores += "'"+oGrid:getValue("Z4_CLIFOR", nLine)+"',"
			cLojas += "'"+oGrid:getValue("Z4_LOJA", nLine)+"',"
		endIf
	next nLine

	cDocs         := Substr(cDocs,1,Len(cDocs)-1)
	cSeries       := Substr(cSeries,1,Len(cSeries)-1)
	cFornecedores := Substr(cFornecedores,1,Len(cFornecedores)-1)
	cLojas        := Substr(cLojas,1,Len(cLojas)-1)
	cIdents       := getIdents(cDocs, cSeries, cFornecedores, cLojas)

	cQuery := " SELECT * " +CRLF
	cQuery += " FROM %SZ4.SQLNAME% WHERE "+CRLF
	cQuery += " Z4_FILIAL = '%SZ4.FILIAL%' AND "+CRLF
	cQuery += " Z4_DOC IN ("+cDocs+") AND "+CRLF
	cQuery += " Z4_SERIE IN ("+cSeries+") AND "+CRLF
	cQuery += " Z4_CLIFOR IN ("+cFornecedores+") AND "+CRLF
	cQuery += " Z4_LOJA IN ("+cLojas+") AND "+CRLF
	cQuery += " Z4_PRODUTO = '"+cProduto+"' AND "+CRLF
	cQuery += " Z4_TIPMOV = '1' AND "+CRLF
	cQuery += " Z4_SALDO > 0 AND "+CRLF
	cQuery += " %SZ4.NOTDEL% "+CRLF

	oSql:newAlias(cQuery)

	while oSql:notIsEof()
		// armazenar valores unitários
		aadd(aVlrProds, oSqlUtil:getFieldValue("SD1", "D1_VUNIT", " %SD1.XFILIAL% AND D1_DOC = '"+oSql:getValue("Z4_DOC")+"' AND D1_SERIE = '"+oSql:getValue("Z4_SERIE")+"' "+;
		" AND D1_FORNECE = '"+oSql:getValue("Z4_CLIFOR")+"' AND D1_LOJA = '"+oSql:getValue("Z4_LOJA")+"' "+;
		" AND D1_COD = '"+oSql:getValue("Z4_PRODUTO")+"' AND D1_ITEM = '"+oSql:getValue("Z4_ITEM")+"'"))
		oSql:skip()
	enddo

	oSql:close()

return aClone(aVlrProds)


/*
** Valida se possuí itens marcado no grid e/ou grid vazio.
*/
static function hasItems()

	local nLine := 0
	local lRet	:= .f.

	for nLine := 1 to oGrid:length()
		if oGrid:isMarkedLine(nLine)
			lRet := .t.
			exit
		endIf
	next nLine

return lRet


/*
** Retorna Msg para 2 perna
*/
static function retMsg2(cDoc, cSerie, cCliFor, cLoja)
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	local cRet		:= ""

	cQuery := "%SF1.XFILIAL% AND F1_DOC = '"+cDoc+"' AND F1_SERIE = '"+cSerie+"' AND F1_FORNECE = '"+cCliFor+"' AND F1_LOJA = '"+cLoja+"' "

	oSql:newTable("SF1", "F1_EMISSAO DT_DOC", cQuery)

	if oSql:hasRecords()
		cRet := cDoc + "-" + alltrim(cSerie) + "," + dtoc(stod(oSql:getValue("DT_DOC"))) + "/"
	endif

	oSql:close()

return (cRet)

/*
** Consulta dados 1º perna
*/
Static Function ExecQry1Perna()

	local cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	Local nLinha	:= 0
	Local cDocs		:= ""
	local cSeries	:= ""
	local cFornecedores	:= ""
	local cLojas		:= ""

	for nLine := 1 to oGrid:length()
		if oGrid:isMarkedLine(nLine)
			cDocs         += "'" + oGrid:getValue("Z4_DOC", nLine)    + "',"
			cSeries       += "'" + oGrid:getValue("Z4_SERIE", nLine)  + "',"
			cFornecedores += "'" + oGrid:getValue("Z4_CLIFOR", nLine) + "',"
			cLojas        += "'" + oGrid:getValue("Z4_LOJA", nLine)   + "',"
		endIf
	next nLine

	cDocs         := Substr(cDocs,1,Len(cDocs)-1)
	cSeries       := Substr(cSeries,1,Len(cSeries)-1)
	cFornecedores := Substr(cFornecedores,1,Len(cFornecedores)-1)
	cLojas        := Substr(cLojas,1,Len(cLojas)-1)
	cIdents       := getIdents(cDocs, cSeries, cFornecedores, cLojas)

	cQuery := " SELECT "
	cQuery += " Z4_DOC, Z4_SERIE, Z4_CLIFOR, Z4_LOJA, Z4_ITEM "
	cQuery += " FROM %SZ4.SQLNAME%"
	cQuery += "	WHERE Z4_FILIAL = '%SZ4.FILIAL%' AND"           		+ CRLF
	cQuery += "		  Z4_DOC    IN (" + cDocs + ") AND"         		+ CRLF
	cQuery += "       Z4_SERIE  IN (" + cSeries + ") AND"       		+ CRLF
	cQuery += "       Z4_CLIFOR IN (" + cFornecedores + ") AND" 		+ CRLF
	cQuery += "       Z4_LOJA   IN (" + cLojas + ") AND"        		+ CRLF
	cQuery += "       %SZ4.NOTDEL%"        								+ CRLF
	cQuery += "GROUP BY  Z4_DOC, Z4_SERIE, Z4_CLIFOR, Z4_LOJA, Z4_ITEM"	+ CRLF

Return cQuery


/*
** calcula o peso bruto das notas 1º perna com a nota 2º perna
*/
Static Function calcularPesoBruto(aDocument1, aDocument2, cTipoNota2Per)

	local cDoc1Perna		:= ""
	local cSerie1Perna		:= ""
	local cForCli1Perna 	:= ""
	local cLoja1Perna		:= ""
	local cTpNota1Perna		:= ""
	local cTpCliFor1Perna 	:= ""
	local cCodProd1Pern		:= ""
	local cTES1Perna		:= ""
	local nPrecUni1Perna	:= 0
	local nQuantid1Pern		:= 0
	local cItem				:= ""
	local nValBruto1Pern	:= 0
	local nValBruto2Pern	:= 0
	local nDif				:= 0
	local nTolerancia		:= GetNewPar("ZZ_TOLECOB", 0)
	local lOk				:= .T.

	MaFisSave()
	MaFisEnd()

	For nI := 1 To Len(aDocument1)

		cDoc1Perna		:= aDocument1[nI][1]
		cSerie1Perna 	:= aDocument1[nI][2]
		cForCli1Perna	:= aDocument1[nI][3]
		cLoja1Perna		:= aDocument1[nI][4]
		cItem			:= aDocument1[nI][5]
		cCodProd1Pern	:= getProduto(cDoc1Perna, cSerie1Perna, cForCli1Perna, cLoja1Perna,cItem)
		cTpNota1Perna 	:= getTipoNota(cDoc1Perna, cSerie1Perna, cForCli1Perna, cLoja1Perna )
		cTpCliFor1Perna	:= getTipoCliFor(cForCli1Perna, cTpNota1Perna)
		cTES1Perna		:= getTES1Perna(cDoc1Perna, cSerie1Perna, cForCli1Perna, cLoja1Perna, cItem)
		nQuantid1Pern	:= getQtd1Perna(cDoc1Perna, cSerie1Perna, cForCli1Perna, cLoja1Perna, cItem)
		nPrecUni1Perna	:= getPreco1Perna(cDoc1Perna, cSerie1Perna, cForCli1Perna, cLoja1Perna, cItem)
		nRecnoSB1		:= getRecnoSB1(cCodProd1Pern)

		MaFisIni(cForCli1Perna,		;  			// 1-Código Cliente/Fornecedor
		cLoja1Perna,			;  			// 2-Loja do Cliente/Fornecedor
		"F",					;    		// 3-C:Cliente , F:Fornecedor
		cTpNota1Perna,			;    		// 4-Tipo da NF
		cTpCliFor1Perna,		;   		// 5-Tipo do Cliente/Fornecedor QRY->C5_TIPOCLI
		Nil, Nil, Nil, Nil, "MATA103")

		If !Empty(cTES1Perna)


			MaFisAdd(cCodProd1Pern,			;   	// 1-Codigo do Produto ( Obrigatorio )
			cTES1Perna,						;	   	// 2-Codigo do TES ( Opcional )
			nQuantid1Pern,					;    	// 3-Quantidade ( Obrigatorio )
			nPrecUni1Perna,					;		// 4-Preco Unitario ( Obrigatorio )
			0,								;    	// 5-Valor do Desconto ( Opcional )
			"",								;	   	// 6-Numero da NF Original ( Devolucao/Benef )
			"",								;		// 7-Serie da NF Original ( Devolucao/Benef )
			"",								;		// 8-RecNo da NF Original no arq SD1/SD2
			0,								;		// 9-Valor do Frete do Item ( Opcional )
			0,								;		// 10-Valor da Despesa do item ( Opcional )
			0,								;		// 11-Valor do Seguro do item ( Opcional )
			0,								;		// 12-Valor do Frete Autonomo ( Opcional )
			nQuantid1Pern*nPrecUni1Perna,	;		// 13-Valor da Mercadoria ( Obrigatorio )
			0,								;		// 14-Valor da Embalagem ( Opcional )
			nRecnoSB1)								// 15-RECNO SB1

			nValBruto1Pern 	:= MaFisRet(,"NF_TOTAL")

		Else

			cErro := "TES não encontrado para o produto "+cCodProd1Pern+" "+CRLF+CRLF
			cErro += "referente ao documento  "+cDoc1Perna+" "+CRLF+CRLF
			MsgAlert(cErro)
			lOK := .F.
			exit

		EndIf

	Next nI

	MaFisEnd() 		// Finaliza a MATXFIS
	MaFisRestore()

	For nI := 1 To Len(aDocument2)

		nValBruto2Pern += aDocument2[nI][6] * aDocument2[nI][7]

	Next nI

	nDif := abs(nValBruto1Pern - nValBruto2Pern)

	if nDif > nTolerancia .AND. lOk

		if lBKM
			cErro := "Valores brutos da 1º perna e 2º perna "+CRLF+CRLF
			cErro += "não conferem. Por favor, verificar:  "+CRLF+CRLF
			cErro += "Total valor bruto 1º perna:  "+AllTrim(Transform(nValBruto1Pern,PESQPICT( "SF1", "F1_VALBRUT" )))+CRLF
			cErro += "Total valor bruto 2º perna:  "+AllTrim(Transform(nValBruto2Pern,PESQPICT( "SF1", "F1_VALBRUT" )))+CRLF
			MsgAlert(cErro)
			lOK := .F.
		endif
	EndIf

Return lOK

/**
* Obtém o produto da 1º perna
*/
Static Function getProduto(cDoc1Perna, cSerie1Perna, cForCli1Perna, cLoja1Perna, cItem)

	local oSql	  		:= IpSqlObject():newIpSqlObject()
	local cTabela	  	:= "SZ4"
	local cCampos	  	:= "Z4_PRODUTO"
	local cWhere	  	:= "%SZ4.XFILIAL% AND Z4_DOC || Z4_SERIE || Z4_CLIFOR || Z4_LOJA || Z4_ITEM = '"  + cDoc1Perna + cSerie1Perna + cForCli1Perna + cLoja1Perna + cItem+"'"
	local cCodProd1Pern	:= ""

	oSql:newTable(cTabela,cCampos,cWhere )

	if oSql:hasRecords()
		cCodProd1Pern := oSql:GetValue("Z4_PRODUTO")
	endif

	oSql:Close()

Return cCodProd1Pern

/**
* Obtém o tipo da nota
*/
Static Function getTipoNota(cDoc1Perna, cSerie1Perna, cForCli1Perna, cLoja1Perna)

	local oSql	  := IpSqlObject():newIpSqlObject()
	local cTabela	  := "SF1"
	local cCampos	  := "F1_TIPO"
	local cWhere	  := "%SF1.XFILIAL% AND F1_DOC || F1_SERIE || F1_FORNECE || F1_LOJA = '"  + cDoc1Perna + cSerie1Perna + cForCli1Perna + cLoja1Perna + "'"

	local cTpNota1Perna   := ""

	oSql:newTable(cTabela,cCampos,cWhere )

	if oSql:hasRecords()
		cTpNota1Perna	:= oSql:GetValue("F1_TIPO")
	endif

	oSql:Close()

Return cTpNota1Perna

/**
* Obtém o tipo de fornecedor/cliente
*/
Static Function getTipoCliFor(cCliFor, cTpNota1Perna)

	local oSql	  := IpSqlObject():newIpSqlObject()
	local cTabela	  := ""
	local cCampos	  := ""
	local cWhere	  := ""
	local cTpCliFor1Perna := ""

	If cTpNota1Perna == "N"

		cTabela := "SA2"
		cCampos	:= "A2_TIPO"
		cWhere	:= "%SA2.XFILIAL% AND A2_COD = '" + cCliFor + "'"

	EndIf

	oSql:newTable(cTabela,cCampos,cWhere )

	if oSql:hasRecords()
		cTpCliFor1Perna	:= oSql:GetValue("A2_TIPO")
	endif

	oSql:Close()

Return cTpCliFor1Perna

/**
* Obtém a TES da 1º perna
*/
Static Function getTES1Perna(cDoc1Perna, cSerie1Perna, cForCli1Perna, cLoja1Perna, cItem)

	local oSql	  := IpSqlObject():newIpSqlObject()
	local cTabela	  := "SD1"
	local cCampos	  := "D1_ZZTES"
	local cWhere	  := "%SD1.XFILIAL% AND D1_DOC || D1_SERIE || D1_FORNECE || D1_LOJA || D1_ITEM = '"  + cDoc1Perna + cSerie1Perna + cForCli1Perna + cLoja1Perna + cItem+"'"
	local cTes1Perna  := ""

	oSql:newTable(cTabela,cCampos,cWhere )

	if oSql:hasRecords()
		cTes1Perna := oSql:GetValue("D1_ZZTES")
	endif

	oSql:Close()

Return cTes1Perna

/**
* Obtém a quantidade
*/
Static Function getQtd1Perna(cDoc1Perna, cSerie1Perna, cForCli1Perna, cLoja1Perna, cItem)

	local oSql	  := IpSqlObject():newIpSqlObject()
	local cTabela	  := "SZ4"
	local cCampos	  := "Z4_QUANT"
	local cWhere	  := "%SZ4.XFILIAL% AND Z4_DOC || Z4_SERIE || Z4_CLIFOR || Z4_LOJA || Z4_ITEM = '"  + cDoc1Perna + cSerie1Perna + cForCli1Perna + cLoja1Perna + cItem+"'"
	local nQtd1Perna  := 0

	oSql:newTable(cTabela,cCampos,cWhere )

	if oSql:hasRecords()
		nQtd1Perna := oSql:GetValue("Z4_QUANT")
	endif

	oSql:Close()

Return nQtd1Perna

/**
* Obtém o preço
*/
Static Function getPreco1Perna(cDoc1Perna, cSerie1Perna, cForCli1Perna, cLoja1Perna, cItem)

	local oSql	  := IpSqlObject():newIpSqlObject()
	local cTabela	  := "SD1"
	local cCampos	  := "D1_VUNIT"
	local cWhere	  := "%SD1.XFILIAL% AND D1_DOC || D1_SERIE || D1_FORNECE || D1_LOJA || D1_ITEM = '"  + cDoc1Perna + cSerie1Perna + cForCli1Perna + cLoja1Perna + cItem+"'"
	local nValorUnit  := 0

	oSql:newTable(cTabela,cCampos,cWhere )

	if oSql:hasRecords()
		nValorUnit := oSql:GetValue("D1_VUNIT")
	endif

	oSql:Close()

Return nValorUnit

/**
* Obtém o preço
*/
Static Function getRecnoSB1(cProduto)

	local oSql	  := IpSqlObject():newIpSqlObject()
	local cTabela	  := "SB1"
	local cCampos	  := "R_E_C_N_O_"
	local cWhere	  := "%SB1.XFILIAL% AND B1_COD='" + cProduto + "'"
	local nRecno  	  := 0

	oSql:newTable(cTabela,cCampos,cWhere )

	if oSql:hasRecords()
		nRecno := oSql:GetValue("R_E_C_N_O_")
	endif

	oSql:Close()

Return nRecno

/**
* ordena os array por item
**/
static function ordenaDetailsByItem(aDetails)

	aSort(aDetails, , , {|x, y| x[1][2] < y[1][2]})

return

/**
* verifica se a nota de 2º perna (Cobertura) contém em seu XML (D1_ZZCBENE) a mesma informação criada na CDV para a nota de Fornecedor (1º perna)
**/
static function checkCBnefXMLIsCDV(cDoc2Per, cSerie2Per, cFornece2Per, cLoja2Per, cDoc1Per, cSerie1Per, cFornece1Per, cLoja1Per)

	local aArea 		:= getArea()
	local aAreaSD1 		:= SD1->(getArea())
	local cAliasCDV		:= getNextAlias()
	local cItem1Per		:= ""
	local cProd1Per 	:= ""
	local cCodBenefCDV 	:= ""
	local cCodAjuD1Cob  := ""
	local cEspeci		:= padr("SPED", tamSx3("CDV_ESPECI")[1], "")
	local cChaveCDV 	:= fwxFilial("CDV") + "E" + cEspeci + " " +  cDoc1Per + cSerie1Per + cFornece1Per + cLoja1Per
	local lError		:= .F.
	local cMsgErro		:= ""

	CDV->(dbSetOrder(4))

	if CDV->(dbSeek(cChaveCDV))		
		while CDV->(!eof()) .and. CDV->(CDV_FILIAL + CDV_TPMOVI + CDV_ESPECI + CDV_FORMUL + CDV_DOC + CDV_SERIE + CDV_CLIFOR + CDV_LOJA) == cChaveCDV
			cItem1Per 		:= CDV->CDV_NUMITE
			cCodBenefCDV 	:= CDV->CDV_CODAJU
			cCFOP1Per       := CDV->CDV_CFOP
			cProduto        := getProd1Perna(cDoc1Per, cSerie1Per, cFornece1Per, cLoja1Per, cItem1Per, cCFOP1Per)
			if !isCodAjuCDVLikeD1Cob(cDoc2Per, cSerie2Per, cFornece2Per, cLoja2Per, cProduto, cCodBenefCDV, @cCodAjuD1Cob)

				cMsgErro += "No produto "+allTrim(cProduto)+", o sistema esta parametrizado com o código de beneficiamento "+allTrim(cCodBenefCDV)+", porém, na NF do FORNECEDOR consta o código de beneficiamento "+allTrim(cCodAjuD1Cob) + CRLF + CRLF

			endIf
			CDV->(dbSkip())
		endDo

		if !empty(cMsgErro)
			u_DHLMsgLog(cMsgErro, "LOG", 1, .F.)

			if ApMsgNoYes( "Foi identificado divergências entre o código CBENEF cadastrado no Protheus (NF FORNECEDOR) com o que foi importado no XML (NF COBERTURA)<br><br>"+;
			"<b>Solução:</b>Verifique a amarração do produto x código CBENEF/NF de cobertura. Deseja abandonar a cobertura?","Atenção")

				lError := .T.

			endif	

		endIf

	else

		if isExistCBEFInCobertura(cDoc2Per, cSerie2Per, cFornece2Per, cLoja2Per,@cCodAjuD1Cob)
			if ApMsgNoYes( "Foi identificado que existe CBENEF na (NF COBERTURA) porém não foi encontrado a devida parametrização para a (NF FORNECEDOR).<br><br>"+;
			"<b>Solução:</b> Verifique a amarração do produto x código CBENEF/NF do fornecedor. Deseja abandonar a cobertura?","Atenção")

				lError := .T.

			endif	
		endIf

	endIf	

	restArea(aAreaSD1)
	restArea(aArea)

return lError

/**
* Verifica se o código de ajuste da CDV é igual ao código da D1_ZZBENEF da Cobertura
**/
static function isCodAjuCDVLikeD1Cob(cDoc2Per, cSerie2Per, cFornece2Per, cLoja2Per, cProduto, cCodBenefCDV,cCodAjuD1Cob)

	local lIsLikeD1 	:= .F.
	local cAliasSD1 	:= getNextAlias()	
	local aArea 		:= getArea()  
	local aAreaSD1  	:= SD1->(getArea())

	BeginSql Alias cAliasSD1
		SELECT * 
		FROM %Table:SD1% SD1
		WHERE
		SD1.D1_FILIAL	= %xFilial:SD1% AND
		SD1.D1_DOC 	= %Exp:cDoc2Per% AND
		SD1.D1_SERIE 	= %Exp:cSerie2Per% AND		
		SD1.D1_FORNECE 	= %Exp:cFornece2Per% AND	
		SD1.D1_LOJA 	= %Exp:cLoja2Per% AND			
		SD1.D1_COD    = %Exp:cProduto% AND		
		SD1.%NotDel%
	EndSql	

	If (cAliasSD1)->(!Eof())		
		cCodAjuD1Cob:=  (cAliasSD1)->D1_ZZCBENE			
	EndIf 	

	(cAliasSD1)->(dbCloseArea())

	if allTrim(cCodAjuD1Cob) == allTrim(cCodBenefCDV)
		lIsLikeD1 := .T.
	endIf

	restArea(aAreaSD1)
	restArea(aArea)

return lIsLikeD1

/**
* Obtém o produto
**/
static function getProd1Perna(cDoc1Per, cSerie1Per, cFornece1Per, cLoja1Per, cItem1Per, cCFOP1Per)	

	local cAliasSD1 := getNextAlias()	
	local aArea 	:= getArea()  
	local aAreaSD1  := SD1->(getArea())
	local cProduto  := ""

	BeginSql Alias cAliasSD1
		SELECT SD1.D1_COD 
		FROM %Table:SD1% SD1
		WHERE
		SD1.D1_FILIAL	= %xFilial:SD1% AND
		SD1.D1_DOC 	= %Exp:cDoc1Per% AND
		SD1.D1_SERIE 	= %Exp:cSerie1Per% AND		
		SD1.D1_FORNECE 	= %Exp:cFornece1Per% AND	
		SD1.D1_LOJA 	= %Exp:cLoja1Per% AND
		SD1.D1_CF      = %Exp:cCFOP1Per% AND		
		SD1.D1_ITEM    = %Exp:cItem1Per% AND		
		SD1.%NotDel%
	EndSql	

	If (cAliasSD1)->(!Eof())		
		cProduto:=  (cAliasSD1)->D1_COD 		
	EndIf 	

	(cAliasSD1)->(dbCloseArea())	

	restArea(aAreaSD1)
	restArea(aArea)

return cProduto

/**
* verifica se na nota de Cobertura (2ºperna) contém o código CBENEF (D1_ZZCBENE)
**/
static function isExistCBEFInCobertura(cDoc2Per, cSerie2Per, cFornece2Per, cLoja2Per,cCodAjuD1Cob)

	local lExistCBENEFCobert := .F.	
	local cAliasSD1 	:= getNextAlias()	
	local aArea 		:= getArea()  
	local aAreaSD1  	:= SD1->(getArea())

	BeginSql Alias cAliasSD1
		SELECT COUNT(*) QTD_REGISTRO
		FROM %Table:SD1% SD1
		WHERE
		SD1.D1_FILIAL	= %xFilial:SD1% AND
		SD1.D1_DOC 	= %Exp:cDoc2Per% AND
		SD1.D1_SERIE 	= %Exp:cSerie2Per% AND		
		SD1.D1_FORNECE 	= %Exp:cFornece2Per% AND	
		SD1.D1_LOJA 	= %Exp:cLoja2Per% AND			
		SD1.D1_ZZCBENE    != ' ' AND		
		SD1.%NotDel%
	EndSql	

	If (cAliasSD1)->(!Eof())		
		nQtdRegistros :=  (cAliasSD1)->QTD_REGISTRO		
		if 	nQtdRegistros > 0
			lExistCBENEFCobert := .T.
		endIf
	EndIf 	

	(cAliasSD1)->(dbCloseArea())	

	restArea(aAreaSD1)
	restArea(aArea)

return lExistCBENEFCobert

