#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'FWMVCDEF.CH'
#include 'topconn.ch'

#Define TITULO_MODEL 	"Monitor Faturamento AGL"
#Define cCRLF			"%CRLF%"

/*/{Protheus.doc} User Function AglMonitorFaturamento
	Monitor Faturamento AGL
	@type  Function
	@author TOTVS IP
	@since 21/11/2023
	@version 1.0
	/*/
user function AglMonitorFaturamento()

	local cTitle	 := TITULO_MODEL
	Local oBrowse 	 := FWMBrowse():New()
	local aIndex     := {}

	private cAliasForm := GetNextAlias()

	aAdd(aIndex, "Z8_DOC, Z8_SERIE, Z8_EMISSAO")

	oBrowse:SetDescription(cTitle)
	oBrowse:SetDataQuery(.T.)
	oBrowse:SetAlias(cAliasForm)
	oBrowse:addLegend("!Empty(Z8_NFRCO) .and. !Empty(Z8_NFRET)", "BR_VERDE", "Processo Concluído")
	oBrowse:addLegend("Empty(Z8_NFRCO) .and. !Empty(Z8_NFRET)", "BR_AMARELO", "Pendente Retorno Simbólico")
	oBrowse:addLegend("Empty(Z8_NFRCO) .and. Empty(Z8_NFRET)", "BR_VERMELHO", "Não iniciado")
	oBrowse:SetQueryIndex(aIndex)
	oBrowse:SetQuery(GetQuery("1=1"))
	// oBrowse:setMenuDef(cModelo)
	oBrowse:SetColumns(GetCampos(GetQuery("1=2")))
	oBrowse:SetTimer({|| oBrowse:refresh() }, GetNewPar("ZZ_TIMEAGL", 600000))
	oBrowse:SetSeek(.t., {{"Nf de Venda", {{"", "C", 9, 0, "Nf de Venda",,}}}})
	oBrowse:disableDetails()
	oBrowse:Activate()

return

Static Function MenuDef()

	local aRotina := {}

	// ADD OPTION aRotina Title 'Visualizar' Action 'StaticCall(RBAFAT13, chama450)' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title "Legenda" Action "u_LegMonitor" OPERATION 6 Access 0

Return aRotina

static function chama450()

	If POSICIONE("AB6", 1, xFilial("AB6")+(cAliasForm)->(AB6_NUMOS), "!eof()")
		// FWExecView("Ordem de Serviço", "TECA450", 2)
		TECA450("AT450Visua")
	endif
return

static function getQuery(cParam)

	local cQuery   := ""
	default cParam := ""

	cQuery += " SELECT " + CRLF
	cQuery += " 	Z8_DOC " + CRLF
	cQuery += " 	, Z8_SERIE " + CRLF
	cQuery += " 	, Z8_EMISSAO " + CRLF
	cQuery += " 	, Z8_CLIENTE " + CRLF
	cQuery += " 	, Z8_LOJA " + CRLF
	cQuery += " 	, SA1VENDA.A1_NOME	A1_NOME " + CRLF
	cQuery += " 	, SF2RCO.F2_DOC AS Z8_NFRCO " + CRLF
	cQuery += " 	, SF2RCO.F2_SERIE AS Z8_SERRCO " + CRLF
	cQuery += " 	, SF2RCO.F2_CLIENTE AS Z8_CLIRCO " + CRLF
	cQuery += " 	, SF2RCO.F2_LOJA AS Z8_LOJRCO	 " + CRLF
	cQuery += " 	, SA1RCO.A1_NOME AS A1_NOME_RC " + CRLF
	cQuery += " 	, CASE  " + CRLF
	cQuery += " 		WHEN SF2RCO.F2_FIMP = 'S' THEN 'APROVADA' " + CRLF
	cQuery += " 		WHEN SF2RCO.F2_FIMP = 'T' THEN 'TRANSMITIDA'  " + CRLF
	cQuery += " 		WHEN SF2RCO.F2_FIMP = 'C' THEN 'CANCELADA'  " + CRLF
	cQuery += " 	END AS STATUS " + CRLF
	cQuery += " 	, SD2RCO.D2_PEDIDO AS D2_PEDIDO	 " + CRLF
	cQuery += " 	, SF2RET.F2_DOC AS Z8_NFRET " + CRLF
	cQuery += " 	, SF2RET.F2_SERIE AS Z8_SERRET " + CRLF
	cQuery += " 	, SF2RET.F2_CLIENTE AS Z8_CLIRET " + CRLF
	cQuery += " 	, SF2RET.F2_LOJA AS Z8_LOJRET " + CRLF
	cQuery += " 	, SA1RET.A1_NOME AS A1_NOME_RE " + CRLF
	cQuery += " 	, SD2RET.D2_PEDIDO AS D2_PEDIDO2 " + CRLF
	cQuery += " 	, CASE  " + CRLF
	cQuery += " 		WHEN SF2RET.F2_FIMP = 'S' THEN 'APROVADA' " + CRLF
	cQuery += " 		WHEN SF2RET.F2_FIMP = 'T' THEN 'TRANSMITIDA'  " + CRLF
	cQuery += " 		WHEN SF2RET.F2_FIMP = 'C' THEN 'CANCELADA'  " + CRLF
	cQuery += " 	END AS STATUS_RET " + CRLF
	cQuery += " FROM " + RetSqlName("SZ8") + " SZ8 " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1VENDA ON 1=1 " + CRLF
	cQuery += " 	AND SA1VENDA.A1_COD = Z8_CLIEMIT " + CRLF
	cQuery += " 	AND SA1VENDA.A1_LOJA = Z8_LOJEMIT " + CRLF
	cQuery += " 	AND SA1VENDA.A1_ZZDEPOS = 'S' " + CRLF
	cQuery += " 	AND SA1VENDA.A1_ZZTPFAT = '1' " + CRLF
	cQuery += " 	AND SA1VENDA.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SF2") + " SF2RCO ON 1=1 " + CRLF
	cQuery += " 	AND SF2RCO.F2_FILIAL 	= Z8_FILIAL " + CRLF
	cQuery += " 	AND SF2RCO.F2_DOC 		= Z8_NFRCO " + CRLF
	cQuery += " 	AND SF2RCO.F2_SERIE 	= Z8_SERRCO " + CRLF
	cQuery += " 	AND SF2RCO.F2_CLIENTE 	= Z8_CLIRCO " + CRLF
	cQuery += " 	AND SF2RCO.F2_LOJA 		= Z8_LOJRCO " + CRLF
	cQuery += " 	AND SF2RCO.D_E_L_E_T_ 	= ' '	 " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1RCO 	ON 1=1 " + CRLF
	cQuery += " 	AND SA1RCO.A1_FILIAL 	= SF2RCO.F2_FILIAL " + CRLF
	cQuery += " 	AND SA1RCO.A1_COD 		= SF2RCO.F2_CLIENTE " + CRLF
	cQuery += " 	AND SA1RCO.A1_LOJA 		= SF2RCO.F2_LOJA " + CRLF
	cQuery += " 	AND SA1RCO.D_E_L_E_T_ 		= ' '  " + CRLF
	cQuery += " OUTER APPLY ( " + CRLF
	cQuery += " 	SELECT D2_PEDIDO " + CRLF
	cQuery += " 	FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery += " 	WHERE " + CRLF
	cQuery += " 		SD2.D2_FILIAL = SF2RCO.F2_FILIAL " + CRLF
	cQuery += " 		AND SD2.D2_DOC = SF2RCO.F2_DOC " + CRLF
	cQuery += " 		AND SD2.D2_SERIE = SF2RCO.F2_SERIE " + CRLF
	cQuery += " 		AND SD2.D_E_L_E_T_ = ' '	 " + CRLF
	cQuery += " 	 " + CRLF
	cQuery += " ) SD2RET " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SF2") + " SF2RET ON 1=1 " + CRLF
	cQuery += " 	AND SF2RET.F2_FILIAL 	= Z8_FILIAL " + CRLF
	cQuery += " 	AND SF2RET.F2_DOC 		= Z8_NFRET " + CRLF
	cQuery += " 	AND SF2RET.F2_SERIE 	= Z8_SERRET " + CRLF
	cQuery += " 	AND SF2RET.F2_CLIENTE 	= Z8_CLIRET " + CRLF
	cQuery += " 	AND SF2RET.F2_LOJA 		= Z8_LOJRET " + CRLF
	cQuery += " 	AND SF2RET.D_E_L_E_T_ 	= ' '	 " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1RET 	ON 1=1 " + CRLF
	cQuery += " 	AND SA1RET.A1_FILIAL 	= SF2RET.F2_FILIAL " + CRLF
	cQuery += " 	AND SA1RET.A1_COD 		= SF2RET.F2_CLIENTE " + CRLF
	cQuery += " 	AND SA1RET.A1_LOJA 		= SF2RET.F2_LOJA " + CRLF
	cQuery += " 	AND SA1RET.D_E_L_E_T_ 		= ' '  " + CRLF
	cQuery += " OUTER APPLY ( " + CRLF
	cQuery += " 	SELECT D2_PEDIDO " + CRLF
	cQuery += " 	FROM " + RetSqlName("SD2") + " SD2 " + CRLF
	cQuery += " 	WHERE " + CRLF
	cQuery += " 		SD2.D2_FILIAL 		= SF2RET.F2_FILIAL " + CRLF
	cQuery += " 		AND SD2.D2_DOC 		= SF2RET.F2_DOC " + CRLF
	cQuery += " 		AND SD2.D2_SERIE 	= SF2RET.F2_SERIE " + CRLF
	cQuery += " 		AND SD2.D_E_L_E_T_ 	= ' '	 " + CRLF
	cQuery += " 	 " + CRLF
	cQuery += " ) SD2RCO " + CRLF
	cQuery += " WHERE 1=1 " + CRLF
	cQuery += " 	AND Z8_FILIAL = '" + FWxFilial("SZ8") + "'  " + CRLF
	cQuery += " 	AND SZ8.D_E_L_E_T_ = ' ' " + CRLF

	If cParam != "1=2"
		MemoWrite("cQuery_AglMonitorFaturamento.sql",STRTRAN(cQuery,cCRLF,CRLF))
	EndIf

return STRTRAN(cQuery,cCRLF,"")

Static Function GetCampos(cQuery)
	Local   nX         := 0
	Local   cAliasEnt  := GetNextAlias()
	Local   oColumn    := {}
	Local   aColumns   := {}

	DbUseArea(.T.,"TOPCONN",TcGenQRy(,,cQuery),(cAliasEnt),.f.,.f.)

	//PERCORRE O CAMPOS "FILDS" DA QUERY
	For nX := 1 to (cAliasEnt)->(FCount())
		If POSICIONE("SX3",2,FieldName(nX),"!EOF()")
			//------------------------------
			//CAMPOS DO DICIONARIO DE DADOS.
			//------------------------------
			oColumn	:= FWBrwColumn():New()
			If SX3->X3_TIPO == "D"
				oColumn:SetData(&("{|| STOD(" + FieldName(nX) + ") }"))
			Else
				oColumn:SetData(&("{||" + FieldName(nX) + " }"))
			EndIf
			oColumn:SetType(SX3->X3_TIPO)
			oColumn:SetTitle(SX3->X3_TITULO)
			oColumn:SetSize(SX3->X3_TAMANHO)
			oColumn:SetDecimal(SX3->X3_DECIMAL)
			oColumn:SetPicture(SX3->X3_PICTURE)
			oColumn:SetEdit(.F.)
			oColumn:SetAutoSize(.T.)

			AADD(aColumns,oColumn)
		Else
			If "NOME" $ FieldName(nX)
				oColumn	:= FWBrwColumn():New()
				oColumn:SetData(&("{||" + FieldName(nX) + " }"))
				oColumn:SetType("C")
				oColumn:SetTitle("Nome")
				oColumn:SetSize(40)
				oColumn:SetDecimal(0)
				oColumn:SetPicture("@!")
				oColumn:SetEdit(.F.)
				oColumn:SetAutoSize(.T.)

				AADD(aColumns,oColumn)
			elseif "STATUS" $ FieldName(nX)
				oColumn	:= FWBrwColumn():New()
				oColumn:SetData(&("{||" + FieldName(nX) + " }"))
				oColumn:SetType("C")
				if "_RE" $ FieldName(nX)
					oColumn:SetTitle("Status Sefaz Ret")
				else
					oColumn:SetTitle("Status Sefaz RCO")
				endif
				oColumn:SetSize(12)
				oColumn:SetDecimal(0)
				oColumn:SetPicture("@!")
				oColumn:SetEdit(.F.)
				oColumn:SetAutoSize(.T.)

				AADD(aColumns,oColumn)
			EndIf
		EndIf
	Next

	DBCloseArea(cAliasEnt)

Return aColumns

/*
* Legenda
*/
User Function LegMonitor()
	Local aLegenda := {}
	aAdd(aLegenda, { "BR_VERDE", "Processo Concluído"})
	aAdd(aLegenda, { "BR_AMARELO", "Pendente Retorno Simbólico"})
	aAdd(aLegenda, { "BR_VERMELHO", "Não iniciado"})
	BrwLegenda("Status", "Legenda", aLegenda)
Return Nil
