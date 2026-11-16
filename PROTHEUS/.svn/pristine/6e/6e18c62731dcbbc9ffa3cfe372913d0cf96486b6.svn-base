#include "totvs.ch"
#include "dhl.ch"

#define ALTER_INVOICE 4

#define SZ4_FILIAL    1
#define SZ4_DOC       2
#define SZ4_SERIE     3
#define SZ4_CLIFOR    4
#define SZ4_LOJA      5


/*/{Protheus.doc} Ag2NfSelScr

Tela de seleção das Nf´s de 1ª perna para cobertura.
Processo para a Unidade de Negócio DIS(Pfizer).

@author Thiago Meschiatti
@since 18/07/2017
@version undefined

@type function
/*/
user Function Ag2NfSelScr()

	local oGetFilter    := nil
	local cDoc		    := SF1->F1_DOC
	local cSerie	    := SF1->F1_SERIE
	local cCodFor		:= ""
	local cForn		    := ""
	local cLoja		    := ""
	local oSql		    := IpSqlObject():newIpSqlObject()
	local aCF		    := Separa(getMV("ZZ_CFCOB"),";",.F.)
	local cCF		    := ""
	local aParamBox     := {}
	Local aRet          := {}

	private oUtils      := IpUtilsObject():newIpUtilsObject()
	private cIdents     := ""
	private oGrid       := nil
	private oDlg        := nil
	private lMsErroAuto := .F.
	Private lMsHelpAuto := .F.
	private aDetail     := {}
	private aHeader     := {}
	private cNfde      	:= SPACE(9)
    private cNfate      := SPACE(9)
    private cSerde    	:= SPACE(3)
    private cSerate   	:= SPACE(3)
    private cForde     	:= SPACE(6)
    private cForate    	:= SPACE(6)

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
	
		//Emerson Holanda Incluir filtros na tela 23/10/25
	    aAdd(aParamBox,{1,"NF de :"   		,cNfde   ,"@!","","",".T.",100,.F.})
        aAdd(aParamBox,{1,"Nf Ate:"   		,cNfate  ,"@!","","",".T.",100,.F.})
        aAdd(aParamBox,{1,"Serie de :"		,cSerde  ,"@!","","",".T.",100,.F.})
        aAdd(aParamBox,{1,"Serie ate:"		,cSerate ,"@!","","",".T.",100,.F.})
        aAdd(aParamBox,{1,"Fornecedor de :" ,cForde  ,"@!","","",".T.",100,.F.})
        aAdd(aParamBox,{1,"Fornecedor ate:" ,cForate ,"@!","","",".T.",100,.F.})
 
        If ParamBox(aParamBox,"Informar os Filtros",@aRet)
            cNfde       := aRet[1]
            cNfate      := aRet[2]
            cSerde    	:= aRet[3]
            cSerate   	:= aRet[4]
            cForde     := aRet[5]
            cForate    := aRet[6]
        EndIf

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
	cQuery += "    AND F1_TIPO  <> 'D' "                  + CRLF //Emerson Holanda Incluir filtros na tela 23/10/25
	//Emerson Holanda Incluir filtros na tela 23/10/25
	If !Empty(cNfde)
		cQuery += " AND Z4_DOC >= '"+ cNfde + "' "        + CRLF
		cQuery += " AND Z4_DOC <= '"+ cNfate + "' "        + CRLF
	EndIf
	If !Empty(cSerde)
		cQuery += " AND Z4_SERIE >= '"+ cSerde + "' "        + CRLF
		cQuery += " AND Z4_SERIE <= '"+ cSerate + "' "        + CRLF
	EndIf
	If !Empty(cForde)
		cQuery += " AND Z4_CLIFOR >= '"+ cForde + "' "        + CRLF
		cQuery += " AND Z4_CLIFOR <= '"+ cForate + "' "        + CRLF
	EndIf

	cQuery += "UNION ALL"								  + CRLF										
	cQuery += "SELECT DISTINCT Z4_DOC,Z4_SERIE,Z4_CLIFOR,"+ CRLF
	cQuery += "                Z4_LOJA,A1_NOME"           + CRLF
	cQuery += "FROM %SZ4.SQLNAME%"                        + CRLF
	cQuery += "INNER JOIN %SA1.SQLNAME%"                  + CRLF
	cQuery += "ON A1_FILIAL = '%SA1.FILIAL%' AND"         + CRLF
	cQuery += "   A1_COD    = Z4_CLIFOR AND"              + CRLF
	cQuery += "   A1_LOJA   = Z4_LOJA AND"                + CRLF
	cQuery += " %SA1.NOTDEL%"                             + CRLF
	cQuery += "INNER JOIN %SF1.SQLNAME%"                  + CRLF
	cQuery += "ON F1_FILIAL  = Z4_FILIAL AND"             + CRLF
	cQuery += "   F1_DOC     = Z4_DOC AND"                + CRLF
	cQuery += "   F1_SERIE   = Z4_SERIE AND"              + CRLF
	cQuery += "   F1_FORNECE = Z4_CLIFOR AND"             + CRLF
	cQuery += "   F1_LOJA    = Z4_LOJA AND"               + CRLF
	cQuery += "   F1_ZZSTATU = ' ' AND"                   + CRLF
	cQuery += "   %SF1.NOTDEL%"                           + CRLF
	cQuery += "   AND F1_TIPO  = 'D' "                    + CRLF //Emerson Holanda Incluir filtros na tela 23/10/25
	cQuery += "WHERE Z4_FILIAL = '%SZ4.FILIAL%' AND"      + CRLF
	cQuery += "      Z4_TIPMOV  = '1' AND"                + CRLF
	cQuery += "      Z4_SALDO <> 0 AND"                   + CRLF
	cQuery += "    %SZ4.NOTDEL%"                          + CRLF
	//Emerson Holanda Incluir filtros na tela 23/10/25
	If !Empty(cNfde)
		cQuery += " AND Z4_DOC >= '"+ cNfde + "' "        + CRLF
		cQuery += " AND Z4_DOC <= '"+ cNfate + "' "        + CRLF
	EndIf
	If !Empty(cSerde)
		cQuery += " AND Z4_SERIE >= '"+ cSerde + "' "        + CRLF
		cQuery += " AND Z4_SERIE <= '"+ cSerate + "' "        + CRLF
	EndIf
	If !Empty(cForde)
		cQuery += " AND Z4_CLIFOR >= '"+ cForde + "' "        + CRLF
		cQuery += " AND Z4_CLIFOR <= '"+ cForate + "' "        + CRLF
	EndIf

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
	local cMsgSF3Aux  := ""
	local cMsg2		  := ""
	local cDoc        := ""
	local cSerie      := ""
	local cFornece    := ""
	local cLoja       := ""
	local dEmissao	

	begin transaction

		if hasItems()
			if validaLinhas()


				aNfCobertas := grava2Perna()

				lError  	:= classifyInvoice(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA, lCobert)
				cDoc		:= SF1->F1_DOC
				cSerie		:= SF1->F1_SERIE
				cFornece	:= SF1->F1_FORNECE
				cLoja		:= SF1->F1_LOJA
				dEmissao	:= SF1->F1_EMISSAO

				if !(lError)
					if len(aNFCobertas) > 0
						for nNota := 1 to Len(aNFCobertas)

							if canClassifyInvoice(aNFCobertas)
								lError := classifyInvoice(aNFCobertas[nNota][SZ4_DOC],aNFCobertas[nNota][SZ4_SERIE],aNFCobertas[nNota][SZ4_CLIFOR],aNFCobertas[nNota][SZ4_LOJA])
							else
								lError := .F.
							endIf						

							if lError
								DisarmTransaction()
								exit
							else

								cMsgSF3 	:= "Remessa Simbólica: " + AllTrim(cDoc) + "-" + AllTrim(cSerie) + ", " + Dtoc(dEmissao)
								cMsgSF3Aux	:= "Rem. Simb.:" + AllTrim(cValToChar(Val(cDoc))) + "-" + AllTrim(cSerie) + "," + Dtoc(dEmissao)

								lError := updZZStatus(aNFCobertas[nNota][SZ4_DOC],aNFCobertas[nNota][SZ4_SERIE],aNFCobertas[nNota][SZ4_CLIFOR],aNFCobertas[nNota][SZ4_LOJA],cMsgSF3,cMsgSF3Aux)

								if lError
									DisarmTransaction()
									exit
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
				//				if !empty(cMsg2)
				//					cMsg2 := "Remessa Conta e Ordem: " + cMsg2
				//					lError := updZZStatus(cDoc,cSerie,cFornece,cLoja,cMsg2)
				//					if lError
				//						DisarmTransaction()
				//					endif
				//				endif			

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
static function updZZStatus(cNFiscal,cNFSerie,cNFCliet,cNFLoja,cStatus,cStatusAux)

	local cWhere  := ""
	local cMsg	  := "" 
	local lUpdate := nil
	local lError  := .F.
	local oSql	  := IpSqlObject():newIpSqlObject()

	default cStatusAux := ""

	cWhere := "F3_FILIAL  = '%SF3.FILIAL%'     AND "
	cWhere += "F3_NFISCAL = '" + cNFiscal + "' AND "
	cWhere += "F3_SERIE   = '" + cNFSerie + "' AND "
	cWhere += "F3_CLIEFOR = '" + cNFCliet + "' AND "
	cWhere += "F3_LOJA    = '" + cNFLoja  + "'     "

	cMsg := oSql:getFieldValue("SF3","F3_OBSERV",cWhere)

	If "DEVOLUCAO" $ Upper(cMsg) .and. !Empty(cStatusAux)
		lUpdate := oSql:update("SF3","F3_OBSERV = '" + AllTrim(cMsg) + "-" + left(AllTrim(cStatusAux ),59) + "'",cWhere)
	Else
		lUpdate := oSql:update("SF3","F3_OBSERV = '" + AllTrim(cMsg) + " - " + left(AllTrim(cStatus),57) + "'",cWhere)
	EndIf

	if !(lUpdate)
		lError := .T.
		MsgAlert("Falha ao atualizar a Mensagem no Livro Fiscal para a Nota " + cNFiscal + " Serie " + cNFSerie + "." + CRLF+CRLF+oSql:getLastError())
	endif

return lError


/**
* Valida se a cobertura pode ser realizada
*/
static function validaLinhas()

	local nLine       := 0
	local aSD1 	      := SD1->(GetArea())
	local lOK	      := .T.
	local aSoma       := {}
	local nSoma       := 0
	local cErro	      := ""
	local aProdQuants := {}
	local aSomaProds  := {}
	local aVlrUnit    := {}
	local nPos        := 0
	local nI          := 0
	local oSql		  := IpSqlObject():newIpSqlObject()
	local cQuery	  := ""

	dbSelectArea("SD1")
	SD1->(dbsetOrder(13))
	SD1->(dbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))

	oSql:newAlias("	SELECT D1_DOC, D1_SERIE, D1_COD, SUM(D1_QUANT) D1_QUANT FROM ( "+;
	"				SELECT D1_DOC, D1_SERIE, D1_COD, D1_QUANT"+;
	"					FROM %SD1.SQLNAME% "+;
	"  				WHERE %SD1.XFILIAL% "+;
	" 					AND %SD1.NOTDEL% AND D1_DOC = '"+SF1->F1_DOC+"' AND D1_SERIE = '"+SF1->F1_SERIE+"' "+;
	" 					AND D1_FORNECE = '"+SF1->F1_FORNECE+"' AND D1_LOJA = '"+SF1->F1_LOJA+"' "+;
	" 		) GROUP BY D1_DOC, D1_SERIE, D1_COD")

	while oSql:notIsEof()

		nSoma	:= getSoma1Perna(oSql:getValue("D1_COD"))
		aVlrUnit:= getVlrUnit(oSql:getValue("D1_COD"))

		if oSql:getValue("D1_QUANT") <> nSoma
			cErro := "Foram encontradas divergências de quantidade entre produtos !"+CRLF+CRLF
			cErro += "2ª Perna"+CRLF+"NF "+AllTrim(oSql:getValue("D1_DOC"))+" - Produto: "+AllTrim(oSql:getValue("D1_COD"))+" - Quantidade: "+cValtoChar(oSql:getValue("D1_QUANT"))/*+" - Valor: "+AllTrim(Transform(SD1->D1_TOTAL,PesqPict("SD1","D1_TOTAL")))*/+CRLF+CRLF
			cErro += "Totais de 1ª Perna marcadas"+CRLF+"Produto: "+AllTrim(oSql:getValue("D1_COD"))+" - Quantidade: "+cValtoChar(nSoma)/*" - Valor: "+AllTrim(Transform(aSoma[2],PesqPict("SD1","D1_TOTAL")))*/+CRLF+CRLF
			cErro += "Processo Cancelado ! Verifique as quantidades."
			MsgAlert(cErro)
			lOK := .F.
			exit
		endif		

		aadd(aProdQuants,{oSql:getValue("D1_COD"),oSql:getValue("D1_QUANT")})
		oSql:skip()
	enddo
	oSql:close()

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

	SD1->(dbSelectArea("SD1"))
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(cKeySF1))

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

	if !Empty(SD1->D1_NFORI)
		aAdd(aDetail,{"D1_NFORI"  ,SD1->D1_NFORI  ,nil})
		aAdd(aDetail,{"D1_SERIORI",SD1->D1_SERIORI,nil})
		aAdd(aDetail,{"D1_ITEMORI",SD1->D1_ITEMORI,nil})
	endIf

	for nCount := 1 to len(aCposSX3)

		if AllTrim(getSX3Cache(aCposSX3[nCount],"X3_PROPRI")) == "U"
			aAdd(aDetail,{AllTrim(aCposSX3[nCount]),&("SD1->" + AllTrim(aCposSX3[nCount])),nil})
		endIf

	next nCount

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
* Verifica se pode classificar a nota. Necessário no cenário Regime Especial, pois a nota de Recusa já esta classificada.
*/
static function canClassifyInvoice(aNFCobertas)

	local nI 		:= 0
	local cFilialSF1:= ""
	local cNf		:= ""
	local cSerie	:= ""
	local cForne	:= ""
	local cLoja		:= ""
	local aArea 	:= getArea()
	local aAreaSF1	:= SF1->(getArea())
	local aAreaSD1	:= SD1->(getArea())
	local cChaveSF1	:= ""
	local lCanClassi:= .F.

	for nI := 1 to len(aNFCobertas)

		cFilialSF1	:= aNFCobertas[nI][1]
		cNf 		:= aNFCobertas[nI][2]
		cSerie 		:= aNFCobertas[nI][3]
		cForne 		:= aNFCobertas[nI][4]
		cLoja 		:= aNFCobertas[nI][5]
		cChaveSF1 	:= cFilialSF1 + cNf + cSerie + cForne + cLoja
		if SF1->(dbSeek(cChaveSF1))
			if SD1->(dbSeek(cChaveSF1))
				//CASO A INFORMAÇÕES ESTEJA VAZIA, PODE CLASSIFICAR
				if empty(SD1->D1_TES)
					lCanClassi := .T.
				endIf
			endIf
		endIf

	next nI	

	restArea(aAreaSF1)
	restArea(aAreaSD1)
	restArea(aArea)

return lCanClassi

