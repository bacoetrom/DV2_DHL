#Include 'Protheus.ch'

/*/{Protheus.doc} GetPedidoComEspe
Rotina responsável em montar no Browse os pedidos de compras para a realização do vínculo.
Consulta Específica via configurador

@author Gustavo Luiz
@since 27/05/2016
@version 1.0
/*/
User Function GetPedidoComEspe()

	Private oSql		:= ipSqlObject():newIpSqlObject()
	Private aDados		:= {}
	Private cBranch		:= SF1->F1_FILIAL
	Private cSerie		:= SF1->F1_SERIE
	Private cNota   	:= SF1->F1_DOC
	Private cClieFor	:= SF1->F1_FORNECE
	Private cLoja   	:= SF1->F1_LOJA
	Private cTipo   	:= SF1->F1_TIPO
	Private oBrow		:= Nil
	Private cQueryAlias := ""
	Private lRetorno	:= .F.
	Static  cPedido		:= ""
	
	RunQuery()
	GetDadosQRY()
	CreateTela()
	oSql:Close()
	
Return lRetorno

/**
* Função responsável em adicionar no array aDados o resultado da query
**/
Static Function GetDadosQRY()
	
	Local nI := 0
	
	While oSql:notIsEof()
		
		aAdd(aDados,{.F.,(cQueryAlias)->C7_NUM,cValToChar(sTod((cQueryAlias)->C7_EMISSAO))})
		oSql:skip()
		
	Enddo
 
Return

/**
* Função responsável na criação da tela
**/
Static Function CreateTela()

	Local aCabecalho:= {"","Pedido de Compra","Dt. Emissao"}
	Local oOK 		:= LoadBitmap(GetResources(),'LBOK')
	Local oNO 		:= LoadBitmap(GetResources(),'LBNO')
	Local oDlg		:= Nil
	
	Define MsDialog oDlg from 0,0 to 200,500 pixel Title "Consulta Específica" Style 128
	
	oBrow := TcBrowse():New(000,000,250,085,,aCabecalho,{10,55,55},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	oBrow:SetArray(aDados)
	oBrow:AddColumn(TCColumn():New("" 						, {||If(aDados[oBrow:nAt,01],oOK,oNO)}	,,,,,,.T.,.F.,,,,.F., ))
	oBrow:AddColumn(TCColumn():New("Pedido de Compras"	, {||aDados[oBrow:nAt,02]}	,,,,"LEFT",60,.F.,.F.,,,,,))
	oBrow:AddColumn(TCColumn():New("Dt. Emissao" 			, {||aDados[oBrow:nAt,03]}	,,,,"LEFT",20,.F.,.F.,,,,,))
	
	oBrow:bLDblClick:={|| DoubleClickBrowse(oBrow, aDados)}

	@087,170 Button "Ok" 		of oDlg Size 30,10 Pixel Action(GetPedido(), oDlg:End())
	@087,210 Button "Cancelar" 	of oDlg Size 30,10 Pixel Action(oDlg:End())
	
	Activate MsDialog oDlg Centered

Return

/**
* Função que obtém o pedido de compra selecionado do Browse
**/
Static Function  GetPedido()
	
	Local 	nPos 		:= 0
	
	nPos := aScan(aDados,{|x|x[1]==.T.})
	if nPos!=0
		cPedido:=aDados[nPos][2]
		lRetorno:=.T.
	EndIf
	
Return 


/**
* Função responsável em retornar SQL os pedidos de compras
**/
Static Function RunQuery()

	Local cQuery 		:= ""
	
	cQuery:= " SELECT	"  	                                        + CRLF
	cQuery+= " C7_FILIAL, C7_FORNECE,  "           					+ CRLF
	cQuery+= " C7_NUM,C7_EMISSAO "  								+ CRLF
	cQuery+= " FROM %SC7.SQLNAME%	"                               + CRLF
	cQuery+= " 	WHERE "  											+ CRLF
	cQuery+= " C7_FILIAL='%SC7.FILIAL%'  "  						+ CRLF
	cQuery+= " AND C7_FORNECE = '"+cClieFor+"'  "  					+ CRLF
	cQuery+= " AND C7_RESIDUO=' ' "                                 + CRLF
    cQuery+= " AND C7_TPOP!='P' "                                   + CRLF
    cQuery+= " AND C7_QUANT-C7_QUJE-C7_QTDACLA>0 "                  + CRLF
    cQuery+= " AND SC7.D_E_L_E_T_= ' ' "                            + CRLF
    cQuery+= " GROUP BY C7_FILIAL, C7_FORNECE, C7_NUM,C7_EMISSAO"   + CRLF
    cQuery+= " ORDER BY C7_EMISSAO, C7_NUM"   						+ CRLF	
	
	MemoWrite("SQLGETPEDIDO.TXT",(oSql:PARSEQUERY(cQuery)))
	oSql:NewAlias(ChangeQuery(cQuery))
	cQueryAlias := oSql:getAlias()

Return

/**
* Função disparado ao duplo click no browse
**/
Static Function DoubleClickBrowse(oBrow, aDados)

	Local nI := 0
	
	aDados[oBrow:nAt,1]:=.T.
	For nI:=1 To Len(aDados)
		If nI!=oBrow:nAt
			aDados[nI][1]:=.F.
		EndIf
	Next nI
	oBrow:Refresh()
Return

/**
* Função de retorno utilizado na consulta específica
**/
User Function RetPedidoComEspe()	
Return cPedido
