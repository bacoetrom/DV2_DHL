#include 'protheus.ch'
#include 'topconn.ch'
#include 'safx3007.ch'
#include 'safx3008.ch'
#include 'safxrtc.ch'
#include 'safx.ch'
#include 'dhl.ch'

#define SFX3007_FILE   "3007"
#define SFX3008_FILE   "3008"

/*/{Protheus.doc} SAFX3007MSDW

Gera a interface SAFX3007 (cabecalho dos documentos fiscais baseados nas
tabelas da Reforma Tributaria) e, no mesmo passe, a SAFX3008 (itens), no
mesmo conceito das demais interfaces da pasta Mastersaf_DW:

  SAFX3007MSDW.prw  - driver: prepara o ambiente, abre o cursor, grava e
                      fecha os arquivos (equivale a GetNotas/QryNotas/GerArq
                      da especificacao)
  DHLSafx3007.prw   - classe com a regra e a montagem da linha (MontLinha)
  safx3007.ch       - leiaute: ordem, tamanho e decimais de cada campo

A validacao de obrigatorios (ValReg) fica em DHLSafx:validRequired() e a
gravacao em MsafDWFile, que ja escreve em arquivo .processing e publica o
.txt somente no final - ver o item 9 da especificacao.

ATENCAO - o leiaute oficial da SAFX3007/SAFX3008 ainda nao foi recebido da
Thomson Reuters (Plano_Execucao_NFe_2027_IBS_CBS.md, Fase 0 item 4). Por
isso a geracao e controlada pelo parametro ZZ_SFX3007, default .F.: enquanto
estiver desligado a rotina registra o motivo em log e nao gera arquivo, para
que um TXT preliminar nao chegue ao importador oficial.

Execucao interativa ou via JOB/Schedule:
  U_SAFX3007MSDW()                                       // ambiente corrente
  U_SAFX3007MSDW({"01","0101"}, 3, dIni, dFim)           // em JOB

@type  function
@author Pablo Regis
@since 23/11/2026
@param aCompany,  array,     {empresa, filial} - obrigatorio em JOB
@param nType,     numeric,   1 entrada, 2 saida, 3 ambas (default 3)
@param dDtFrom,   date,      data inicial do periodo
@param dDtUntil,  date,      data final do periodo
@return logical, indica se algum arquivo foi gerado
/*/
user function SAFX3007MSDW(aCompany, nType, dDtFrom, dDtUntil)

	local oDhlSafx     := DhlSafx():newDhlSafx()
	private lGerouArqs := .F.

	default nType    := 3
	default dDtFrom  := Date()
	default dDtUntil := Date()

	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf

	if !layoutLib()
		return .F.
	endIf

	gera3007(nType, dDtFrom, dDtUntil)

return lGerouArqs

/*/{Protheus.doc} layoutLib
Trava de seguranca do leiaute preliminar. Enquanto ZZ_SFX3007 nao for ligado
pela area fiscal - o que pressupoe o manual oficial em maos e o include
safx3007.ch conferido - a rotina nao gera arquivo.

@type   function
@author Pablo Regis
@since  23/11/2026
@return logical, .T. quando a geracao esta liberada
/*/
static function layoutLib()

	local lLib := GetNewPar("ZZ_SFX3007", .F.)

	if !lLib
		FWLogMsg("WARN", , "BusinessObject", FunName(), "", "01",;
			"[SAFX3007] Geracao desligada: o leiaute oficial da SAFX3007/SAFX3008 nao "+;
			"foi homologado. Conferir o manual da Thomson Reuters, ajustar os includes "+;
			"safx3007.ch e safx3008.ch e ligar o parametro ZZ_SFX3007.", 0, 0, {})
	endIf

return lLib

/*/{Protheus.doc} gera3007
Processa a geracao dos arquivos SAFX3007 e SAFX3008.

Um cursor de cabecalho (SF3 agregada por documento) e, para cada documento,
um cursor de itens (SFT com os tributos da Reforma pre-agregados pela
DHLSafxRtc). Os tributos nunca sao recalculados, apenas organizados.

@type   function
@author Pablo Regis
@since  23/11/2026
@param  nType,    numeric, 1 entrada, 2 saida, 3 ambas
@param  dDtFrom,  date,    data inicial
@param  dDtUntil, date,    data final
/*/
static function gera3007(nType, dDtFrom, dDtUntil)

	local oFile3007 := MsafDWFile():newMsafDWFile(SFX3007_FILE, SAFX3007_POSICOES)
	local oFile3008 := MsafDWFile():newMsafDWFile(SFX3008_FILE, SAFX3008_POSICOES)
	local oSqlCab   := IpSqlObject():newIpSqlObject()
	local oSqlIten  := nil
	local oDHL3007  := DHLSafx3007():newDHLSafx3007()
	local oRtc      := DHLSafxRtc():newDHLSafxRtc()
	local aFields   := {}
	local aTotRtc   := {}
	local aCtx      := {}
	local cError    := ""
	local cType     := ""
	local nQtLidos  := 0
	local nQtGerad  := 0
	local nQtRejeit := 0
	local lGer3007  := .F.
	local lGer3008  := .F.

	oRtc:logConfig("SAFX3007")

	FWLogMsg("INFO", , "BusinessObject", FunName(), "", "01",;
		"[SAFX3007] Inicio. Tipo="+cValToChar(nType)+" Periodo="+DtoS(dDtFrom)+" a "+DtoS(dDtUntil), 0, 0, {})

	oSqlCab:newAlias( qryCab(nType, dDtFrom, dDtUntil) )

	while oSqlCab:notIsEof()

		nQtLidos++
		cType := oSqlCab:getValue("ENT_SAI")

		// mesmas exclusoes da SAFX07: inventario e cutover nao vao ao livro
		if isInvent(oSqlCab) .or. oDHL3007:isCutover(cType,;
				AllTrim(oSqlCab:getValue("F3_NFISCAL")), AllTrim(oSqlCab:getValue("F3_SERIE")),;
				AllTrim(oSqlCab:getValue("F3_CLIEFOR")), AllTrim(oSqlCab:getValue("F3_LOJA")))
			oSqlCab:skip()
			loop
		endIf

		oSqlIten := openIten(oSqlCab, oRtc)

		// isEof em vez de hasRecords: o hasRecords chama count(), que faz um
		// fetch completo do cursor a cada documento
		if oSqlIten:isEof()
			oDHL3007:addLog(SAFX3007_ERROR_TITLE,;
				"Documento sem item na SFT: "+idDoc(oSqlCab), oFile3007:getFile())
			oSqlIten:close()
			nQtRejeit++
			oSqlCab:skip()
			loop
		endIf

		// totaliza os tributos da Reforma na granularidade do documento
		// percorrendo o cursor de itens que ja esta aberto - sem query extra
		aTotRtc := totRtc(oSqlIten)
		oSqlIten:goTop()

		oDHL3007:initialize(SAFX3007_POSICOES, oSqlCab, oSqlIten)
		oDHL3007:setTotRtc(aTotRtc)
		oDHL3007:addLine()

		aFields := oDHL3007:getFields()
		cError  := oDHL3007:validRequired(VLD_3007_FIELD)

		if !Empty(cError)
			oDHL3007:addLog(SAFX3007_ERROR_TITLE,;
				SAFX3007_ERROR_OBRIGAT+cError+idDoc(oSqlCab), oFile3007:getFile())
			oSqlIten:close()
			nQtRejeit++
			oSqlCab:skip()
			loop
		endIf

		if temNil(aFields)
			oDHL3007:addLog(SAFX3007_ERROR_TITLE,;
				SAFX3007_ERROR_NIL+idDoc(oSqlCab), oFile3007:getFile())
			oSqlIten:close()
			nQtRejeit++
			oSqlCab:skip()
			loop
		endIf

		oFile3007:setFields( aFields )

		if !oFile3007:write()
			oDHL3007:addLog(SAFX3007_ERROR_TITLE, ERROR_QTD_CAMPOS+idDoc(oSqlCab), oFile3007:getFile())
			oSqlIten:close()
			nQtRejeit++
			oSqlCab:skip()
			loop
		endIf

		lGer3007   := .T.
		lGerouArqs := .T.
		nQtGerad++

		aCtx := ctxCab(oDHL3007, oSqlCab, cType)

		if U_SAFX3008MSDW(oSqlCab, oSqlIten, @oFile3008, aCtx)
			lGer3008 := .T.
		endIf

		oSqlIten:close()
		oSqlCab:skip()
	endDo

	oSqlCab:close()

	// publica o definitivo somente se houve gravacao; o .processing de um
	// arquivo vazio e descartado para nao deixar resto no diretorio
	fechaArq(oFile3007, SFX3007_FILE, SAFX3007_POSICOES, lGer3007)
	fechaArq(oFile3008, SFX3008_FILE, SAFX3008_POSICOES, lGer3008)

	FWLogMsg("INFO", , "BusinessObject", FunName(), "", "01",;
		"[SAFX3007] Fim. Documentos lidos="+cValToChar(nQtLidos)+;
		" gerados="+cValToChar(nQtGerad)+" rejeitados="+cValToChar(nQtRejeit), 0, 0, {})

return

/*/{Protheus.doc} fechaArq
Publica ou descarta o arquivo de trabalho.

@type   function
@author Pablo Regis
@since  23/11/2026
@param  oFile,   object,  instancia de MsafDWFile
@param  cExpFile, character, sufixo da interface ("3007" / "3008")
@param  nPosicoes, numeric, quantidade de colunas do leiaute
@param  lGerou,  logical, indica se alguma linha foi gravada
/*/
static function fechaArq(oFile, cExpFile, nPosicoes, lGerou)

	local cArq := oFile:getFile()

	if lGerou
		oFile:renameArq(cExpFile, nPosicoes)
		oFile:close()
	else
		oFile:close()
		if File(cArq)
			fErase(cArq)
		endIf
		FWLogMsg("INFO", , "BusinessObject", FunName(), "", "01",;
			"[SAFX"+cExpFile+"] Nenhum registro gerado no periodo. Arquivo de trabalho descartado.", 0, 0, {})
	endIf

return

/*/{Protheus.doc} ctxCab
Contexto do cabecalho repassado a SAFX3008, no mesmo formato {valor, nome}
que DHLSafx:getFieldValue() consome. Evita que a rotina de itens recalcule
indicador de participante e tipo de movimento do documento.

@type   function
@author Pablo Regis
@since  23/11/2026
@param  oDHL3007, object,    instancia de DHLSafx3007 (regras ja resolvidas)
@param  oSqlCab,  object,    cursor do cabecalho
@param  cType,    character, "1" entrada, "2" saida
@return array, contexto do documento
/*/
static function ctxCab(oDHL3007, oSqlCab, cType)

	local aCtx := {}

	aAdd(aCtx, { cType                        , "CTYPE"     })
	aAdd(aCtx, { oDHL3007:getTpMovto()         , "TPMOVTO"   })
	aAdd(aCtx, { oDHL3007:getIndFisJur()       , "INDFISJUR" })
	aAdd(aCtx, { oDHL3007:getCodFisJur()       , "CODFISJUR" })
	aAdd(aCtx, { oDHL3007:getCodEstab()        , "CODESTAB"  })
	aAdd(aCtx, { oSqlCab:getValue("F3_ENTRADA"), "DTESCRIT"  })
	aAdd(aCtx, { oSqlCab:getValue("F3_CHVNFE") , "CHVNFE"    })

return aCtx

/*/{Protheus.doc} totRtc
Totaliza o documento percorrendo o cursor de itens que ja esta aberto: bases
e valores de IBS/CBS/IS do Configurador e os valores de mercadoria, frete,
seguro, desconto e outras despesas da SFT. Nenhuma query adicional.

Regras da totalizacao:
  - base e valor de tributo somam;
  - aliquota NAO soma - vale a do item, enquanto for unica no documento;
  - CST e cClassTrib do cabecalho so recebem valor quando todos os itens com
    conteudo concordam. Havendo divergencia o campo sai em branco, porque a
    informacao correta e a do item (SAFX3008) e o cabecalho nao pode afirmar
    um CST que nao vale para a nota inteira.

@type   function
@author Pablo Regis
@since  23/11/2026
@param  oSqlIten, object, cursor de itens
@return array, totais no formato {valor, nome de coluna}
/*/
static function totRtc(oSqlIten)

	local aTot  := {}
	local aNum  := {}
	local aAlq  := {}
	local aChr  := {}
	local aVlr  := {}
	local nI    := 0
	local nPos  := 0
	local cVal  := ""

	// bases e valores de tributo: somam
	aNum := { RTC_COL_BAS_UF, RTC_COL_VLR_UF,;
	          RTC_COL_BAS_MU, RTC_COL_VLR_MU,;
	          RTC_COL_BAS_CB, RTC_COL_VLR_CB,;
	          RTC_COL_BAS_IS, RTC_COL_VLR_IS }

	// aliquotas: nao somam
	aAlq := { RTC_COL_ALQ_UF, RTC_COL_ALQ_MU, RTC_COL_ALQ_CB, RTC_COL_ALQ_IS }

	// CST e classificacao tributaria
	aChr := { RTC_COL_CST_UF, RTC_COL_CST_MU, RTC_COL_CST_CB,;
	          RTC_COL_CST_IS, RTC_COL_CLSTRIB }

	// valores do documento: coluna de destino x campo da SFT
	aVlr := { { TOT_COL_PROD , "FT_TOTAL"   },;
	          { TOT_COL_CONT , "FT_VALCONT" },;
	          { TOT_COL_DESC , "FT_DESCONT" },;
	          { TOT_COL_FRETE, "FT_FRETE"   },;
	          { TOT_COL_SEG  , "FT_SEGURO"  },;
	          { TOT_COL_OUTRA, "FT_DESPESA" } }

	for nI := 1 to Len(aNum)
		aAdd(aTot, { 0, aNum[nI] })
	next nI

	for nI := 1 to Len(aAlq)
		aAdd(aTot, { 0, aAlq[nI] })
	next nI

	for nI := 1 to Len(aChr)
		aAdd(aTot, { "", aChr[nI] })
	next nI

	for nI := 1 to Len(aVlr)
		aAdd(aTot, { 0, aVlr[nI,1] })
	next nI

	oSqlIten:goTop()

	while oSqlIten:notIsEof()

		for nI := 1 to Len(aNum)
			nPos := aScan(aTot, {|x| x[2] == aNum[nI] })
			aTot[nPos,1] += oSqlIten:getValue(aNum[nI])
		next nI

		for nI := 1 to Len(aAlq)
			nPos := aScan(aTot, {|x| x[2] == aAlq[nI] })
			if aTot[nPos,1] == 0
				aTot[nPos,1] := oSqlIten:getValue(aAlq[nI])
			endIf
		next nI

		for nI := 1 to Len(aVlr)
			nPos := aScan(aTot, {|x| x[2] == aVlr[nI,1] })
			aTot[nPos,1] += oSqlIten:getValue(aVlr[nI,2])
		next nI

		for nI := 1 to Len(aChr)
			nPos := aScan(aTot, {|x| x[2] == aChr[nI] })
			cVal := AllTrim(oSqlIten:getValue(aChr[nI]))
			if !Empty(cVal)
				if Empty(aTot[nPos,1])
					aTot[nPos,1] := cVal
				elseIf aTot[nPos,1] != cVal
					// divergencia entre itens: o cabecalho nao afirma nada
					aTot[nPos,1] := ""
				endIf
			endIf
		next nI

		oSqlIten:skip()
	endDo

	oSqlIten:goTop()

return aTot

/*/{Protheus.doc} temNil
Verifica se alguma posicao do leiaute ficou sem preenchimento. Sem essa
guarda, MsafDWFile:write() concatena um nil e derruba o processamento no
meio do arquivo.

@type   function
@author Pablo Regis
@since  23/11/2026
@param  aFields, array, posicoes do leiaute
@return logical, .T. quando existe posicao nao preenchida
/*/
static function temNil(aFields)
return aScan(aFields, {|x| x == nil }) > 0

/*/{Protheus.doc} idDoc
Identificacao do documento para o log de erros, sem expor valor fiscal.

@type   function
@author Pablo Regis
@since  23/11/2026
@param  oSqlCab, object, cursor do cabecalho
@return character, texto de identificacao
/*/
static function idDoc(oSqlCab)

	local cId := CRLF + CRLF

	cId += "Tipo Documento: " + oSqlCab:getValue("ENT_SAI") + CRLF
	cId += "Nota Fiscal: " + AllTrim(oSqlCab:getValue("F3_NFISCAL")) + "/" + AllTrim(oSqlCab:getValue("F3_SERIE")) + CRLF
	cId += "Cliente/Fornecedor: " + AllTrim(oSqlCab:getValue("F3_CLIEFOR")) + "-" + AllTrim(oSqlCab:getValue("F3_LOJA"))

return cId

/*/{Protheus.doc} isInvent
Verifica se e nota de inventario, pela mesma regra da SAFX07.

@type   function
@author Pablo Regis
@since  23/11/2026
@param  oSqlCab, object, cursor do cabecalho
@return logical, .T. quando e documento de inventario
/*/
static function isInvent(oSqlCab)

	local lInvent := .F.

	if oSqlCab:getValue("ENT_SAI") == "2"
		lInvent := AllTrim(oSqlCab:getValue("F3_SERIE")) == DHL_SERIE_INVENTARIO
	else
		lInvent := AllTrim(oSqlCab:getValue("F3_ESPECIE")) == DHL_ESPECIE_INVENTARIO
	endIf

return lInvent

/*/{Protheus.doc} qryCab
Cursor de cabecalho: SF3 agregada por documento, com o participante.

Diferencas de proposito em relacao a query da SAFX07, todas sem mudanca de
resultado para o documento classico:

  1. um unico ramo por sentido (entrada/saida) em vez de quatro. A SAFX07
     separa os ramos por F3_TIPO pertencer a ('D','B') para escolher entre
     SA1 e SA2 no JOIN - e por isso a nota de credito (F3_TIPO = '5') cai no
     ramo do fornecedor e une A2_COD com um codigo de cliente (ver
     Triagem_cIndFisJur_SAFX.md, manifestacao 2). Aqui as duas tabelas sao
     unidas por LEFT JOIN e a escolha da coluna acontece em AdvPL, por
     DHLSafx:indFisJurPorTipo(), que ja conhece os tipos 5 e 6;
  2. o periodo fiscal e selecionavel por ZZ_SFX3DAT ("1" F3_ENTRADA, default
     igual a SAFX07; "2" F3_EMISSAO), porque o manual da SAFX3007 ainda nao
     confirmou qual data define a competencia;
  3. mantidas as exclusoes da SAFX07: deletados, documentos inutilizados
     (F3_OBSERV = ZZ_TXTINUT), inventario e cutover.

@type   function
@author Pablo Regis
@since  23/11/2026
@param  nType,    numeric, 1 entrada, 2 saida, 3 ambas
@param  dDtFrom,  date,    data inicial
@param  dDtUntil, date,    data final
@return character, instrucao SQL
/*/
static function qryCab(nType, dDtFrom, dDtUntil)

	local cQry := ""

	if nType == 1 .or. nType == 3
		cQry += ramoCab("1", dDtFrom, dDtUntil)
	endIf

	if nType == 3
		cQry += " UNION ALL "
	endIf

	if nType == 2 .or. nType == 3
		cQry += ramoCab("2", dDtFrom, dDtUntil)
	endIf

	cQry += " ORDER BY 4, 5, 6 "   // F3_NFISCAL, F3_SERIE, F3_CLIEFOR

return ChangeQuery(cQry)

/*/{Protheus.doc} ramoCab
Monta um ramo (entrada ou saida) do cursor de cabecalho.

@type   function
@author Pablo Regis
@since  23/11/2026
@param  cEntSai,  character, "1" entrada, "2" saida
@param  dDtFrom,  date,      data inicial
@param  dDtUntil, date,      data final
@return character, instrucao SQL do ramo
/*/
static function ramoCab(cEntSai, dDtFrom, dDtUntil)

	local cQry    := ""
	local cCampo  := ""
	local cTxtInu := GetMv("ZZ_TXTINUT")
	local cDtPer  := AllTrim(GetNewPar("ZZ_SFX3DAT", "1"))

	if cDtPer == "2"
		cCampo := "F3_EMISSAO"
	else
		cCampo := "F3_ENTRADA"
	endIf

	cQry += " SELECT '"+cEntSai+"' ENT_SAI, "
	cQry += "        XCAB.TIPO_MOV, "
	cQry += "        XCAB.F3_TIPO, "
	cQry += "        XCAB.F3_NFISCAL, "
	cQry += "        XCAB.F3_SERIE, "
	cQry += "        XCAB.F3_CLIEFOR, "
	cQry += "        XCAB.F3_LOJA, "
	cQry += "        XCAB.F3_EMISSAO, "
	cQry += "        XCAB.F3_ENTRADA, "
	cQry += "        XCAB.F3_DTCANC, "
	cQry += "        XCAB.F3_CHVNFE, "
	cQry += "        XCAB.F3_ESPECIE, "
	cQry += "        XCAB.F3_ESTADO, "
	cQry += "        XCAB.F3_EMINFE, "
	cQry += "        XCAB.F3_CODRET, "
	cQry += "        XCAB.F3_VALCONT, "
	cQry += "        XCAB.F3_DESPESA, "
	cQry += "        SA1.A1_ZZINDDW, SA1.A1_INSCR, SA1.A1_TIPO, SA1.A1_EST, SA1.A1_COD_MUN, "
	cQry += "        SA2.A2_ZZINDDW, SA2.A2_INSCR, SA2.A2_TIPO, SA2.A2_EST, SA2.A2_COD_MUN "
	cQry += " FROM ( SELECT CASE WHEN F3_TIPO IN ('D','B') THEN '"+SAFX_MOVIMENTO_DEVOLUCAO+"' "
	cQry += "                    ELSE '"+SAFX_MOVIMENTO_NORMAL+"' END TIPO_MOV, "
	cQry += "               F3_TIPO, F3_NFISCAL, F3_SERIE, F3_CLIEFOR, F3_LOJA, "
	cQry += "               F3_EMISSAO, F3_ENTRADA, F3_DTCANC, F3_CHVNFE, F3_ESPECIE, "
	cQry += "               F3_ESTADO, F3_EMINFE, F3_CODRET, "
	cQry += "               SUM(F3_VALCONT) F3_VALCONT, "
	cQry += "               SUM(F3_DESPESA) F3_DESPESA "
	cQry += "        FROM "+RetSqlName("SF3")+" SF3 "
	cQry += "        WHERE F3_FILIAL = '"+xFilial("SF3")+"' "

	if !Empty(dDtFrom) .and. !Empty(dDtUntil)
		cQry += "          AND "+cCampo+" BETWEEN '"+DtoS(dDtFrom)+"' AND '"+DtoS(dDtUntil)+"' "
	else
		cQry += "          AND "+cCampo+" = '"+DtoS(Date())+"' "
	endIf

	if cEntSai == "1"
		cQry += "          AND F3_CFO <= 4999 "
	else
		cQry += "          AND F3_CFO >= 5000 "
	endIf

	cQry += "          AND SF3.D_E_L_E_T_ = ' ' "
	cQry += "          AND F3_OBSERV <> '"+cTxtInu+"' "
	cQry += "        GROUP BY F3_TIPO, F3_NFISCAL, F3_SERIE, F3_CLIEFOR, F3_LOJA, "
	cQry += "                 F3_EMISSAO, F3_ENTRADA, F3_DTCANC, F3_CHVNFE, F3_ESPECIE, "
	cQry += "                 F3_ESTADO, F3_EMINFE, F3_CODRET ) XCAB "
	cQry += " LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
	cQry += "       AND SA1.A1_COD = XCAB.F3_CLIEFOR AND SA1.A1_LOJA = XCAB.F3_LOJA "
	cQry += "       AND SA1.D_E_L_E_T_ = ' ' "
	cQry += " LEFT JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' "
	cQry += "       AND SA2.A2_COD = XCAB.F3_CLIEFOR AND SA2.A2_LOJA = XCAB.F3_LOJA "
	cQry += "       AND SA2.D_E_L_E_T_ = ' ' "

return cQry

/*/{Protheus.doc} openIten
Abre o cursor de itens do documento: SFT (item fiscal) com o produto e com os
tributos da Reforma pre-agregados por item pela DHLSafxRtc.

A SFT e usada como granularidade do item porque e ela que carrega o
FT_IDTRIB, chave de ligacao com a F2D, e porque e a mesma origem que a
SAFX08 ja usa hoje - o que mantem a conciliacao entre as duas interfaces.

@type   function
@author Pablo Regis
@since  23/11/2026
@param  oSqlCab, object, cursor do cabecalho posicionado no documento
@param  oRtc,    object, instancia de DHLSafxRtc
@return object, IpSqlObject com o cursor de itens aberto
/*/
static function openIten(oSqlCab, oRtc)

	local oSql    := IpSqlObject():newIpSqlObject()
	local cQry    := ""
	local cTpMov  := ""
	local cDoc    := AllTrim(oSqlCab:getValue("F3_NFISCAL"))
	local cSer    := AllTrim(oSqlCab:getValue("F3_SERIE"))
	local cCod    := AllTrim(oSqlCab:getValue("F3_CLIEFOR"))
	local cLoja   := AllTrim(oSqlCab:getValue("F3_LOJA"))
	local lCanc   := !Empty(oSqlCab:getValue("F3_DTCANC"))

	if oSqlCab:getValue("ENT_SAI") == "1"
		cTpMov := "E"
	else
		cTpMov := "S"
	endIf

	cQry := " SELECT SFT.FT_ITEM, SFT.FT_PRODUTO, SFT.FT_QUANT, SFT.FT_PRCUNIT, "
	cQry += "        SFT.FT_TOTAL, SFT.FT_VALCONT, SFT.FT_DESCONT, SFT.FT_FRETE, "
	cQry += "        SFT.FT_SEGURO, SFT.FT_DESPESA, SFT.FT_CFOP, SFT.FT_NATOPER, "
	cQry += "        SFT.FT_NFORI, SFT.FT_SERORI, SFT.FT_ITEMORI, SFT.FT_CHVNFE, "
	cQry += "        SFT.FT_IDTRIB, "
	cQry += "        SB1.B1_DESC, SB1.B1_POSIPI, SB1.B1_UM, SB1.B1_TIPO "
	cQry += oRtc:colTribSelect(RTC_ALIAS_AGREG)
	cQry += " FROM "+RetSqlName("SFT")+" SFT "
	cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
	cQry += "       AND SB1.B1_COD = SFT.FT_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQry += " LEFT JOIN "+oRtc:qryTribItens(cTpMov, cDoc, cSer, cCod, cLoja)+" "+RTC_ALIAS_AGREG
	cQry += "       ON "+RTC_ALIAS_AGREG+"."+RTC_COL_IDREL+" = SFT.FT_IDTRIB "
	cQry += " WHERE SFT.FT_FILIAL  = '"+xFilial("SFT")+"' "
	cQry += "   AND SFT.FT_TIPOMOV = '"+cTpMov+"' "
	cQry += "   AND SFT.FT_NFISCAL = '"+cDoc+"' "
	cQry += "   AND SFT.FT_SERIE   = '"+cSer+"' "
	cQry += "   AND SFT.FT_CLIEFOR = '"+cCod+"' "
	cQry += "   AND SFT.FT_LOJA    = '"+cLoja+"' "

	// Documento cancelado permanece no livro, com SITUACAO = "S"; nesse caso
	// a SFT ja pode estar marcada como deletada e o filtro de exclusao
	// logica nao pode ser aplicado - mesmo tratamento da SAFX07.
	//
	// Sem o filtro, porem, o mesmo FT_ITEM pode vir duas vezes (a linha viva
	// e a excluida), duplicando linha no arquivo e dobrando o total do
	// documento. O SAFX08MSDW resolve isso em AdvPL, guardando os itens ja
	// vistos em aItDel; aqui a deduplicacao e feita na origem, pelo menor
	// R_E_C_N_O_ de cada item, para que o total do cabecalho e as linhas da
	// SAFX3008 enxerguem exatamente o mesmo conjunto.
	if lCanc
		cQry += "   AND SFT.R_E_C_N_O_ = ( SELECT MIN(SFTDUP.R_E_C_N_O_) "
		cQry += "                            FROM "+RetSqlName("SFT")+" SFTDUP "
		cQry += "                           WHERE SFTDUP.FT_FILIAL  = '"+xFilial("SFT")+"' "
		cQry += "                             AND SFTDUP.FT_TIPOMOV = '"+cTpMov+"' "
		cQry += "                             AND SFTDUP.FT_NFISCAL = '"+cDoc+"' "
		cQry += "                             AND SFTDUP.FT_SERIE   = '"+cSer+"' "
		cQry += "                             AND SFTDUP.FT_CLIEFOR = '"+cCod+"' "
		cQry += "                             AND SFTDUP.FT_LOJA    = '"+cLoja+"' "
		cQry += "                             AND SFTDUP.FT_ITEM    = SFT.FT_ITEM ) "
	else
		cQry += "   AND SFT.D_E_L_E_T_ = ' ' "
	endIf

	cQry += " ORDER BY SFT.FT_ITEM "

	oSql:newAlias( ChangeQuery(cQry) )

return oSql
