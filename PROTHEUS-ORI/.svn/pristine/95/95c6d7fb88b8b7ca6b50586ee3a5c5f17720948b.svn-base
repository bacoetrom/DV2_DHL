#include 'totvs.ch'
#Include 'dhl.ch'

#Define OP 			 1
#Define COD			 2
#Define D3LOCAL		 3
#Define NUMSEQ		 4
#Define QUANTIDADE 	 5
#Define NUMDOC		 6
#Define CHAVE		 7
#Define D3RECNO 	 8

#Define INCLUSAO 	 3
#Define ESTORNO  	 5
#Define ENCERRAMENTO 7

#Define EXCLUSAO	 5

#Define PRODUTO		 2
#Define UM			 5
#Define LOTE		 3
#Define POSITIVO    "P"

/*/{Protheus.doc} DHLBackFlush
Classe para processar a interface BackFlush
@type class
@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
@see (links_or_references)
/*/
CLASS DHLBackFlush FROM ClassShipment
	
	Data cCNPJ
	Data cProjectID
	Data nQtyPlanned
	Data dStartDate
	Data dEndDate
	Data cType
	Data cSubLote
	Data cWorkOrder
	Data cBom
	Data cLotBom
	Data dExpDateBom
	Data nQtyBom
	Data cUmBOM
	Data cUmItem
	Data aItens
	Data cFilePath
	Data cOrdemProducao
	Data lErroOperacao
	Data isLoteVencido
	Data nNewQtdOP
	Data cError
	Data aInsumos
	Data lExistMOD
	Data nFator
	Data cDocumento
	Data nQuantPaNegativ
	
	Method GetCNPJ()
	Method SetCNPJ()
	
	Method GetProjectID	()
	Method SetProjectID	()
	
	Method GetQtyPlanned()
	Method SetQtyPlanned()
	
	Method GetStartDate()
	Method SetStartDate()
	
	Method GetEndDate()
	Method SetEndDate()
	
	Method GetType()
	Method SetType()
	
	Method GetSubLote()
	Method SetSubLote()
	
	Method GetWorkOrder()
	Method SetWorkOrder()
	
	Method GetBom()
	Method SetBom()
	
	Method GetLotBom()
	Method SetLotBom()
	
	Method GetExpDateBom()
	Method SetExpDateBom()
	
	Method GetQtyBom()
	Method SetQtyBom()
	
	Method SetUMBom()
	Method GetUMBom()
	
	Method GetItens()
	Method SetItens()
	
	Method GetFilePath()
	Method SetFilePath()
	
	Method GetOrdemProducao()
	Method SetOrdemProducao()
	
	Method HasErroOperacao()
	Method SetErroOperacao()
	
	Method IsLoteVencido()
	Method SetLoteVencido()
	
	Method GetNewQtdOP()
	Method SetNewQtdOP()
	
	Method GetErrorMsg()
	Method SetErrorMsg()
	
	Method GetInsumos()
	Method SetInsumos()
	
	Method GetExistMOD()
	Method SetExistMOD()
	
	Method GetFator()
	Method SetFator()
	
	Method GetDocumento()
	Method SetDocumento()
	
	Method GetQuantPaNegativ()
	Method SetQuantPaNegativ()
	
	
	Method ApontaOrdemProducao()
	Method EstornaApontamento()
	Method EstornaConsumo()
	Method EncerraApontamento()
	Method CreateOP()
	Method GeraNumOP()
	Method AjustEmpenho()
	Method GeraConsumo()
	Method ApontProducao()
	Method SetFileLog()
	Method GetApontProducao()
	Method ExcluiOP()
	Method VerificaLote()
	method hasItens()
	method retInsumosPositivo()
	
	METHOD NewDHLBackFlush() CONSTRUCTOR
	
ENDCLASS



/*/{Protheus.doc} NewDHLBackFlush
Método Construtor

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
METHOD NewDHLBackFlush() CLASS DHLBackFlush
	
	::cCNPJ 			:= ''
	::cProjectID	 	:= ''
	::nQtyPlanned 		:= 0
	::dStartDate 		:= Nil
	::dEndDate 			:= Nil
	::cType 			:= ''
	::cSubLote 			:= ''
	::cWorkOrder 		:= ''
	::cBom 				:= ''
	::cLotBom 			:= ''
	::dExpDateBom 		:= Nil
	::nQtyBom			:= 0
	::aItens			:= {}
	::cFilePath			:= ''
	::lErroOperacao		:= .F.
	::isLoteVencido		:= .F.
	::nNewQtdOP			:= 0
	::cUmBOM			:= ""
	::cUmItem			:= ""
	::aInsumos			:= {}
	::lExistMOD			:= .F.
	::nFator			:= 0
	::cDocumento		:= ""
	::nQuantPaNegativ	:= 0
	
	::newClassShipment()
	
Return

/*/{Protheus.doc} GetQuantPaNegativ
Método Construtor

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetQuantPaNegativ() CLASS DHLBackFlush
	
Return ::nQuantPaNegativ

/*/{Protheus.doc} nQuantPaNegativ

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetQuantPaNegativ(nQuantPaNegativ) CLASS DHLBackFlush
	
	::nQuantPaNegativ := nQuantPaNegativ
	
Return

/*/{Protheus.doc} GetCNPJ
Obtém o CNPJ

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetCNPJ() Class DHLBackFlush
	
Return ::cCNPJ

/*/{Protheus.doc} SetCNPJ
Define o CNPJ

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetCNPJ(cCNPJ) Class DHLBackFlush
	
	::cCNPJ := cCNPJ
	
Return

/*/{Protheus.doc} GetDocumento
Obtém o documento gerado na requisição manual

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetDocumento() Class DHLBackFlush
	
Return ::cDocumento

/*/{Protheus.doc} SetDocumento
Define o documento gerado na requisição manual

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetDocumento(cDocumento) Class DHLBackFlush
	
	::cDocumento := cDocumento
	
Return

/*/{Protheus.doc} GetProjectID
Obtém o ProjectID

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetProjectID	() Class DHLBackFlush
	
Return ::cProjectID

/*/{Protheus.doc} SetProjectID
Define o ProjectID

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetProjectID	(cProjectID	) Class DHLBackFlush
	
	If Empty(cProjectID)
		::SetErroOperacao(.T.)
		::setFileLog(self:cFilePath,"fail","TAG <PROJECT_ID> vazia"+CRLF+CRLF+"")
	EndIf
	
	::cProjectID	 := cProjectID
	
Return

/*/{Protheus.doc} GetQtyPlanned
Obtém a quantidade planejada

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetQtyPlanned() Class DHLBackFlush
	
Return ::nQtyPlanned

/*/{Protheus.doc} SetQtyPlanned
Define a quantidade planejada

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetQtyPlanned(cQtyPlanned) Class DHLBackFlush
	
	If !Empty(cQtyPlanned)
		::nQtyPlanned := Val(cQtyPlanned)
	EndIf
	
Return

/*/{Protheus.doc} GetStartDate
Obtém a data de início

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetStartDate() Class DHLBackFlush
	
Return ::dStartDate

/*/{Protheus.doc} SetStartDate
Define a data de início

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetStartDate(dStartDate) Class DHLBackFlush
	
	::dStartDate := dStartDate
	
Return

/*/{Protheus.doc} GetEndDate
Obtém a data fim

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetEndDate() Class DHLBackFlush
	
Return ::dEndDate

/*/{Protheus.doc} GetEndDate
Define a data fim

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetEndDate(dEndDate) Class DHLBackFlush
	
	::dEndDate := dEndDate
	
Return

/*/{Protheus.doc} GetType
Obtém o tipo

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetType() Class DHLBackFlush
	
Return ::cType

/*/{Protheus.doc} SetType
Define o tipo

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetType(cType) Class DHLBackFlush
	
	::cType := cType
	
Return

/*/{Protheus.doc} GetSubLote
Obtem o subLote

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetSubLote() Class DHLBackFlush
	
Return ::cSubLote

/*/{Protheus.doc} SetSubLote
Define o subLote

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetSubLote(cSubLote) Class DHLBackFlush
	
	If Empty(cSubLote)
		::SetErroOperacao(.T.)
		::setFileLog(self:cFilePath,"fail","TAG <SUBLOTE> vazia"+CRLF+CRLF+"")
	EndIf
	
	::cSubLote := cSubLote
	
Return

/*/{Protheus.doc} GetWorkOrder
Obtém o WorkOerder

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetWorkOrder() Class DHLBackFlush
	
Return ::cWorkOrder

/*/{Protheus.doc} SetWorkOrder
Define o WorkOerder

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetWorkOrder(cWorkOrder) Class DHLBackFlush
	
	::cWorkOrder := cWorkOrder
	
Return

/*/{Protheus.doc} GetBom
Obtém o BOM

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetBom() Class DHLBackFlush
	
Return ::cBom

/*/{Protheus.doc} SetBom
Define o BOM

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetBom(cBom) Class DHLBackFlush
	
	If Empty(cBom)
		::SetErroOperacao(.T.)
		::setFileLog(self:cFilePath,"fail","TAG <BOM> vazia"+CRLF+CRLF+"")
	EndIf
	
	::cBom := cBom
	
Return

/*/{Protheus.doc} GetLotBom
Obtém o subLote BOM

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetLotBom() Class DHLBackFlush
	
Return ::cLotBom

/*/{Protheus.doc} SetLotBom
Define o subLote BOM

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetLotBom(cLotBom) Class DHLBackFlush
	
	::cLotBom := cLotBom
	
Return

/*/{Protheus.doc} GetExpDateBom
Obtém Expiration Date BOM

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetExpDateBom() Class DHLBackFlush
	
Return ::dExpDateBom

/*/{Protheus.doc} SetExpDateBom
Define Expiration Date BOM

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetExpDateBom(dExpDateBom) Class DHLBackFlush
	
	::dExpDateBom := dExpDateBom
	
	IF ProdutControlLote(::cBom)
		If !Empty(dExpDateBom)
			If dExpDateBom < dDataBase
				::SetLoteVencido(.T.)
				::SetErroOperacao(.T.)
				::setFileLog(self:cFilePath,"fail","Lote Vencido do produto "+::cBom+""+CRLF+CRLF+cValToChar(dExpDateBom))
			EndIf
		EndIf
	EndIf
	
Return

/*/{Protheus.doc} GetQtyBom
Obtém a quantidade BOM

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetQtyBom() Class DHLBackFlush
	
Return ::nQtyBom

/*/{Protheus.doc} SetQtyBom
Define a quantidade BOM

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetQtyBom(xQtyBom) Class DHLBackFlush
	
	Local cTipo	:= ValType(xQtyBom)
	
	If cTipo == "N"
		::nQtyBom := xQtyBom
	ElseIf cTipo == "C" .AND. !Empty(xQtyBom)
		::nQtyBom := Val(xQtyBom)
	EndIf
	
Return

/*/{Protheus.doc} GetUMBom
Obtém a unidade de medida do BOM

@author Gustavo Luiz
@since 28/02/2017
@version 1.0
@example
(examples)
/*/
Method GetUMBom() Class DHLBackFlush
	
Return ::cUmBOM

/*/{Protheus.doc} SetUMBom
Define a unidade de medida BOM

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetUMBom(cUmBOM) Class DHLBackFlush
	
	::cUmBOM := cUmBOM
	
Return

/*/{Protheus.doc} GetFator
Obtém o fator que será utilizado quando houver rateio de apontamento, consequentemente de requisição

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetFator() Class DHLBackFlush
	
Return ::nFator

/*/{Protheus.doc} SetFator
Obtém o fator que será utilizado quando houver rateio de apontamento, consequentemente de requisição

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetFator(nFator) Class DHLBackFlush
	
	::nFator := nFator
	
Return

/*/{Protheus.doc} GetItens
Obtém os itens FILEITEM

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetItens() Class DHLBackFlush
	
Return ::aItens


/*/{Protheus.doc} SetItens
Define os itens FILEITEM

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetItens(aItens) Class DHLBackFlush
	
	::aItens := aItens
	
Return

/*/{Protheus.doc} GetFilePath
Obtém o FilePath

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetFilePath() Class DHLBackFlush
	
Return ::cFilePath

/*/{Protheus.doc} GetFilePath
Define o FilePath

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetFilePath(cFilePath) Class DHLBackFlush
	
	::cFilePath := cFilePath
	
Return


/*/{Protheus.doc} GetOrdemProducao
Obtém a ordem de produção gerado

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method GetOrdemProducao() Class DHLBackFlush
	
Return ::cOrdemProducao

/*/{Protheus.doc} SetOrdemProducao
Define a ordem de produção gerado

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetOrdemProducao(cOrdemProducao) Class DHLBackFlush
	
	::cOrdemProducao := Substr(cOrdemProducao,1 , TamSx3("C2_NUM")[1])
	
Return

/*/{Protheus.doc} HasErroOperacao
Retorna se houve erro na operação (Rotina automática)

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method HasErroOperacao() Class DHLBackFlush
	
	
	
Return ::lErroOperacao

/*/{Protheus.doc} SetErroOperacao
Define se houve erro na operação (Rotina automática)

@author Gustavo Luiz
@since 10/02/2017
@version 1.0
@example
(examples)
/*/
Method SetErroOperacao(lErroOperacao) Class DHLBackFlush
	
	::lErroOperacao := lErroOperacao
	
Return

/*/{Protheus.doc} IsLoteVencido
Define se o lote esta vencido

@author Gustavo Luiz
@since 14/02/2017
@version 1.0
@example
(examples)
/*/
Method IsLoteVencido() Class DHLBackFlush
	
	If ::isLoteVencido
		::setFileLog(self:cFilePath,"fail","Falha ao processar interface BackFlush"+CRLF+CRLF+"Lote Vencido")
	EndIf
	
Return ::isLoteVencido

/*/{Protheus.doc} SetLoteVencido
Define se o lote esta vencico

@author Gustavo Luiz
@since 14/02/2017
@version 1.0
@example
(examples)
/*/
Method SetLoteVencido(lLoteVencido)	Class DHLBackFlush
	
	::isLoteVencido := lLoteVencido
	
Return

/*/{Protheus.doc} GetNewQtdOP
Obtém a diferença da OP com a complementar

@author Gustavo Luiz
@since 14/02/2017
@version 1.0
@example
(examples)
/*/
Method GetNewQtdOP() Class DHLBackFlush
	
Return ::nNewQtdOP

/*/{Protheus.doc} SetNewQtdOP
Define a diferença da OP com a complementar

@author Gustavo Luiz
@since 14/02/2017
@version 1.0
@example
(examples)
/*/
Method SetNewQtdOP(nNewQtdOP) Class DHLBackFlush
	
	::nQtyPlanned := nNewQtdOP
	
Return

/*/{Protheus.doc} GetInsumos
Obtém os insumos

@author Gustavo Luiz
@since 28/02/2017
@version 1.0
@example
(examples)
/*/
Method GetInsumos() Class DHLBackFlush
	
	
Return ::aInsumos

/*/{Protheus.doc} SetInsumos
Define os insumos

@author Gustavo Luiz
@since 28/02/2017
@version 1.0
@example
(examples)
/*/
Method SetInsumos(aInsumos) Class DHLBackFlush
	
	::aInsumos := aInsumos
	
Return

/*/{Protheus.doc} ApontaOrdemProducao
Aponta a ordem de produção

@author Gustavo Luiz
@since 15/02/2017
@version 1.0
@example
(examples)
/*/
Method ApontaOrdemProducao() Class DHLBackFlush
	
	ApontaOP(self)
	
Return

/**
* Aponta ordem de produção
**/
Static Function ApontaOP(oDHLBackFlush)
	
	Local aStructApont 		:= {}
	Local oOrdemProducao 	:= DHLOrdemProducao():newDHLOrdemProducao()
	
	aStructApont := EstrutApont(oDHLBackFlush)
	
	If !oDHLBackFlush:HasErroOperacao()
		
		oOrdemProducao:execAuto250(aStructApont, INCLUSAO)
		
		If oOrdemProducao:HasError()
			
			oDHLBackFlush:SetErroOperacao(.T.)
			setFileLog(oDHLBackFlush:GetFilePath(),"fail","Falha ao apontar a Ordem de Produção"+CRLF+CRLF+oDHLBackFlush:GetMsgErro())
			
		EndIf
		
	EndIf
	
Return

/*/{Protheus.doc} GetExistMOD
Obtém se já foi definido um MOD

@author Gustavo Luiz
@since 03/01/2017
@version 1.0
@example
(examples)
/*/
Method GetExistMOD() Class DHLBackFlush
	
Return ::lExistMOD

/*/{Protheus.doc} SetExistMOD
Define a existencia de um MOD

@author Gustavo Luiz
@since 03/01/2017
@version 1.0
@example
(examples)
/*/
Method SetExistMOD(lExistMOD) Class DHLBackFlush
	
	::lExistMOD := lExistMOD
	
Return


/*/{Protheus.doc} EstornaApontamento
Estorna apontamento

@author Gustavo Luiz
@since 15/02/2017
@version 1.0
@example
(examples)
/*/
Method EstornaApontamento(aApontProducao) Class DHLBackFlush
	
	Local aStructEstorno 		:= {}
	Local aArea				:= GetArea()
	Local aAreaSD3			:= SD3->(GetArea())
	
	SD3->(dbSelectArea("SD3"))
	SD3->(dbSetOrder(0))
	SD3->(DbGoTo(aApontProducao[D3RECNO]))
	
	aStructEstorno := GetEstrut(aApontProducao, ESTORNO)
	
	::execAuto250(aStructEstorno, ESTORNO)
	
	If ::HasError()
		
		::SetErroOperacao(.T.)
		
	EndIf
	
	RestArea(aAreaSD3)
	RestArea(aArea)
	
Return

/*/{Protheus.doc} EncerraApontamento
Encerra o apontamento

@author Gustavo Luiz
@since 17/02/2017
@version 1.0
@example
(examples)
/*/
Method EncerraApontamento(aApontProducao) Class DHLBackFlush
	
	Local aEstrutEncerra 	:= {}
	Local aArea				:= GetArea()
	Local aAreaSD3			:= SD3->(GetArea())
	
	SD3->(dbSelectArea("SD3"))
	SD3->(dbSetOrder(3))
	
	If SD3->(Dbseek(xFilial("SD3") + aApontProducao[2] + aApontProducao[3] + aApontProducao[4] + aApontProducao[9]))
		
		aStructEncerra := GetEstrut(aApontProducao, ENCERRAMENTO)
		
		::execAuto250(aStructEncerra, ENCERRAMENTO)
		
		If ::HasError()
			
			::SetErroOperacao(.T.)
			
		EndIf
		
	EndIf
	
	RestArea(aAreaSD3)
	RestArea(aArea)
	
Return

/**
* Estorna apontamento
**/
static function GetEstrut(aApontProducao, nTipo)
	
	local aArray := {}
	
	aAdd(aArray, {"D3_DOC",aApontProducao[NUMDOC]		,Nil})
	aAdd(aArray, {"D3_OP",aApontProducao[OP]			,Nil})
	aAdd(aArray, {"D3_COD",aApontProducao[COD]			,Nil})
	
	If nTipo == ENCERRAMENTO
		
		aAdd(aArray, {"D3_FILIAL",xFilial("SD3")			,Nil})
		aAdd(aArray, {"D3_EMISSAO",sTod(aApontProducao[10])	,Nil})
		aAdd(aArray, {"D3_CC",aApontProducao[11]			,Nil})
		aAdd(aArray, {"D3_UM",aApontProducao[12]			,Nil})
		aAdd(aArray, {"D3_TM",aApontProducao[14]			,Nil})
		aAdd(aArray, {"D3_LOCAL",aApontProducao[D3LOCAL]	,Nil})
		aAdd(aArray, {"D3_NUMSEQ",aApontProducao[NUMSEQ]	,Nil})
		aAdd(aArray, {"D3_QUANT",aApontProducao[QUANTIDADE]	,Nil})
		aAdd(aArray, {"D3_CF"	,"PR0"						,Nil})
		aAdd(aArray, {"D3_TM"	,aApontProducao[14]			,Nil})
		aAdd(aArray, {"D3_CHAVE",aApontProducao[CHAVE]		,Nil})
		aAdd(aArray, {"INDEX",	4							,Nil})
		
	EndIf
	
	
	If nTipo == ESTORNO
		aAdd(aArray, {"D3_LOCAL",aApontProducao[D3LOCAL]	,Nil})
		aAdd(aArray, {"D3_NUMSEQ",aApontProducao[NUMSEQ]	,Nil})
		aAdd(aArray, {"D3_QUANT",aApontProducao[QUANTIDADE]	,Nil})
		aAdd(aArray, {"D3_CF"	,"PR0"						,Nil})
		aAdd(aArray, {"D3_CHAVE",aApontProducao[CHAVE]		,Nil})
		aAdd(aArray, {"INDEX",	4							,Nil})
	EndIf
	
	aArray := FwVetByDic(aArray, "SD3")
	
return aClone(aArray)

/*/{Protheus.doc} GeraNumOP
Gera o novo número de OP

@author Gustavo Luiz
@since 15/02/2017
@version 1.0
@example
(examples)
/*/
Method GeraNumOP()  Class DHLBackFlush
	
	local oSql				:= IpSqlObject():newIpSqlObject()
	local cQuery  			:= " SELECT MAX(C2_NUM) MAXNUM FROM %SC2.SQLNAME% WHERE %SC2.XFILIAL% AND %SC2.NOTDEL% "
	local cMaxNum 			:= ""
	local cProductionOrder	:= ""
	
	oSql:newAlias(cQuery)
	cMaxNum := oSql:getValue("MAXNUM")
	oSql:close()
	
	if Empty(cMaxNum)
		cProductionOrder := StrZero(1, Len(SC2->C2_NUM))
	else
		cProductionOrder := Soma1(cMaxNum)
	endIf
	
return cProductionOrder

/*/{Protheus.doc} VerificaLote
Verifica se o BOM e ITENS controla lote. Caso não controla e tenha a TAG <LOT> preenchido, limpa a informação.

@author Gustavo Luiz
@since 15/02/2017
@version 1.0
@example
(examples)
/*/
Method VerificaLote() Class DHLBackFlush
	
	Local nI 	:= 0
	Local cItem	:= ""
	
	For nI := 1 To Len(::aItens)
		cItem := ::aItens[nI][2]
		
		If !ProdutControlLote(cItem)
			::aItens[nI][3] := ""
		EndIf
		
	Next nI
	
Return

/*/{Protheus.doc} CreateOP
Cria um nova OP

@author Gustavo Luiz
@since 15/02/2017
@version 1.0
@example
(examples)
/*/
Method ExcluiOP(aApontProducao)  Class DHLBackFlush
	
	Local aStructOP 		:= {}
	Local cOP				:= aApontProducao[16]
	Local cItem				:= aApontProducao[17]
	Local cSequencia		:= aApontProducao[18]
	
	
	
	aStructOP := EstrutOP(self, EXCLUSAO, aApontProducao)
	
	If SC2->(DbSeek(xFilial("SC2") + cOP + cItem + cSequencia))
		
		::execAuto650(aStructOP, EXCLUSAO)
		
		If ::HasError()
			
			::SetErroOperacao(.T.)
			
		EndIf
		
	EndIf
	
	
	
return

/*/{Protheus.doc} CreateOP
Cria um nova OP

@author Gustavo Luiz
@since 15/02/2017
@version 1.0
@example
(examples)
/*/
Method CreateOP()  Class DHLBackFlush
	
	Local aStructOP 		:= {}
	Local cOP				:= ""
	Local cItem				:= "01"
	Local cSequencia		:= "001"
	
	If !Empty(::GetBom())
		
		aStructOP := EstrutOP(self, INCLUSAO)
		
		::execAuto650(aStructOP, INCLUSAO)
		
		If ::HasError()
			
			::SetErroOperacao(.T.)
			
		Else
			
			cOP	:= (Padr(aStructOP[1][2], TamSx3("C2_NUM")[1], ""))
			SC2->(DbSetOrder(1))
			
			If SC2->(DbSeek(xFilial("SC2") + cOP + cItem + cSequencia))
				
				::SetOrdemProducao(SC2->C2_NUM)
				::SetExistMOD(.T.)
				
			EndIf
			
		EndIf
		
	EndIf
	
return

/*
** Monta array do SC2
*/
Static Function EstrutOP(oDHLBackFlush, nOperacao, aApontamento)
	
	Local aArray 	 		:= {}
	Local cItemOrdem 		:= ""
	Local cSequencia 		:= ""
	Local cProductionOrder	:= ""
	Local cArmazem			:= ""
	
	Default aApontamento	:= {}
	
	If nOperacao == INCLUSAO
		
		cProductionOrder := oDHLBackFlush:GeraNumOP()
		cItemOrdem 		 := "01"
		cSequencia 		 := "001"
		cArmazem		 := "01"
		
		aArray := {{"C2_NUM"		,cProductionOrder              ,nil},;
			{"C2_ITEM"		,cItemOrdem                            ,nil},;
			{"C2_SEQUEN"	,cSequencia                            ,nil},;
			{"C2_PRODUTO"	,oDHLBackFlush:GetBom()                ,nil},;
			{"C2_LOCAL"		,cArmazem                              ,nil},;
			{"C2_QUANT"		,oDHLBackFlush:GetQtyPlanned()         ,nil},;
			{"C2_DATPRI"	,dDataBase                             ,nil},;
			{"C2_DATPRF"	,dDataBase                             ,nil},;
			{"C2_ZZPROJE"	,oDHLBackFlush:GetProjectID()          ,nil}}
		//{"AUTEXPLODE"	,"S"          						   ,nil}} //RETIRADO PARA NÃO EXPLODIR EMPENHOS DE ACORDO COM E-MAIL: "Abertura da OP (MATA650) sem explodir empenhos (SD4 não deverá mais ser gerado);"
		
	ElseIf nOperacao == EXCLUSAO
		
		aArray := {{"C2_NUM",aApontamento[16]       				,nil},;
			{"C2_ITEM"		,aApontamento[17]                       ,nil},;
			{"C2_SEQUEN"	,aApontamento[18]                       ,nil},;
			{"C2_PRODUTO"	,aApontamento[19]                		,nil},;
			{"C2_LOCAL"		,aApontamento[20]                       ,nil}}
		
	EndIf
	
	aArray := FwVetByDic(aArray, "SC2")
	
return aClone(aArray)

/*/{Protheus.doc} AjustEmpenho
Ajusta o empenho

@author Gustavo Luiz
@since 15/02/2017
@version 1.0
@example
(examples)
/*/
Method AjustEmpenho()  Class DHLBackFlush
	
	local aVetor := {}
	local cLocal := "01"
	Local nI	 := 1
	Local aItens := ::GetItens()
	
	For nI := 1 To Len(aItens)
		
		aVetor:= {}
		
		aAdd(aVetor,{"D4_FILIAL" ,xFilial("SD4")										,nil})
		aAdd(aVetor,{"D4_OP"     ,::GetOrdemProducao() + "01001"						,nil})
		aAdd(aVetor,{"D4_COD"    ,Padr(aItens[nI][PRODUTO], TamSx3("D4_COD")[1], " ")	,nil})
		aAdd(aVetor,{"D4_LOCAL"  ,cLocal           										,nil})
		aAdd(aVetor,{"D4_DATA"   ,dDatabase        										,nil})
		aAdd(aVetor,{"D4_QTDEORI",Val(aItens[nI][4])       								,nil})
		aAdd(aVetor,{"D4_QUANT"  ,Val(aItens[nI][4])       								,nil})
		
		If ProdutControlLote(aItens[nI][PRODUTO])
			
			aAdd(aVetor,{"D4_LOTECTL", Padr(aItens[nI][LOTE], TamSx3("D4_LOTECTL")[1], "")       ,nil})
			aAdd(aVetor,{"D4_DTVALID", aItens[nI][1]       										 ,nil})
			//aAdd(aVetor,{"D4_LOTECTL",aItens[nI][LOTE]       							,nil})
			
		EndIf
		
		//MSExecAuto({|x,y,z| Mata380(x,y,z)}, aVetor, INCLUSAO)
		MSExecAuto({|x,y,z| Mata381(x,y,z)}, aVetor, INCLUSAO)
		
		//::cDocumento := SD3->D3_DOC
		
		if lMsErroAuto
			::setError(.t.)
			::setMsgErro(::oUtils:getErroAuto())
			::SetErroOperacao(.T.)
			exit
		endIf
		
	Next nI
	
return

/*/{Protheus.doc} GeraConsumo
Gera os consumos

@author Gustavo Luiz
@since 28/02/2017
@version 1.0
@example
(examples)
/*/
Method GeraConsumo()  Class DHLBackFlush
	
	Local aCabecalho	:= GetCab241(self, "INCLUSAO")
	local aItem 		:= GetItens241(self, "INCLUSAO")
	local cError		:= ""
	local nErro			:= 0
	local nErros		:= 0
	local aErros     	:= Array(0)	
	local cStrErro		:= ""
	
	Private lMsErroAuto		:= .F.
	Private lAutoErrNoFile 	:= .T.
	
	If !Empty(GetNewPar("ZZ_TMBACKF", ""))
		
		If !::HasErroOperacao()
			
			abreTabelas()
			
			MSExecAuto({|x,y,z| MATA241(x,y,z)},aCabecalho,aItem,3)
			
			::SetDocumento(SD3->D3_DOC)
			
			if lMsErroAuto
				::setError(.t.)
				
				aErros 	:= GetAutoGRLog('Erro MSExecAuto')
				nErros	:= Len( aErros )
				
				for nErro := 1 To nErros
					cStrErro += ( aErros[ nErro ] + Chr(13) )
				next nErros
				
				//cError := MostraErro()
				::setMsgErro(cStrErro)
				::SetErroOperacao(.T.)
			endIf
			
		EndIf
		
	Else
		::SetErroOperacao(.T.)
		::setMsgErro("Parâmetro ZZ_TMBACKF vazio ou não existe")
	EndIf
	
return

/*/{Protheus.doc} ApontProducao
Aponta a produção

@author Gustavo Luiz
@since 15/02/2017
@version 1.0
@example
(examples)
/*/
Method ApontProducao()  Class DHLBackFlush
	
	Local aStructApont 		:= {}
	
	aStructApont := EstrutApont(self)
	
	If !::hasErroOperacao()
		
		::execAuto250(aStructApont, INCLUSAO)
		
		If ::HasError()
			
			::SetErroOperacao(.T.)
			::setMsgErro(::GetMsgErro())
			
		EndIf
		
	EndIf
	
return

/*/{Protheus.doc} SetFileLog
Log da integração

@author Gustavo Luiz
@since 15/02/2017
@version 1.0
@example
(examples)
/*/
Method SetFileLog(cFile,cLogType,cLogText,cTag,cValue) Class DHLBackFlush
	
	local cInterface := "BackFlush"
	
	oLog:start(APP_NULOGY,DHL_IMPORTACAO,cFile)
	
	if !(Empty(cTag))
		cLogText += CRLF+CRLF+"Tag: "+cTag
	endIf
	
	if !(Empty(cValue))
		cLogText += CRLF+CRLF+"Valor: "+cValue
	endIf
	
	if (cLogType == "fail")
		oLog:fail(cInterface, cLogText)
	elseIf (cLogType == "warn")
		oLog:warn(cInterface, cLogText)
	endIf
	
Return

/*/{Protheus.doc} GetApontProducao
Retorna os apontamentos de produção de acordo com o SUBLOTE (Pallet Id) e PROJECT_ID. Utilizado para o encerramento da ordem de produção

@author Gustavo Luiz
@since 15/02/2017
@version 1.0
@example
(examples)
/*/
Method GetApontProducao() Class DHLBackFlush
	
	Local cQuery 		:= ""
	Local oSql			:= ipSqlObject():newIpSqlObject()
	Local aApontProduc	:= {}
	
	cQuery := RunQueryApontProd(::cSubLote, ::cProjectID)
	
	oSql:newAlias(cQuery)
	
	If oSql:hasRecords()
		while oSql:notIsEof()
			aAdd(aApontProduc, {oSql:getValue("D3_OP"), oSql:getValue("D3_COD"), oSql:getValue("D3_LOCAL") ,oSql:getValue("D3_NUMSEQ"), oSql:getValue("D3_QUANT"), oSql:getValue("D3_DOC") , oSql:getValue("D3_CHAVE") , oSql:getValue("RECNOSD3"), oSql:getValue("D3_CF"), oSql:getValue("D3_EMISSAO"), oSql:getValue("D3_CC"), oSql:getValue("D3_UM"), oSql:getValue("D3_CONTA"),  oSql:getValue("D3_TM"), oSql:getValue("D3_ZZPALLE"), oSql:getValue("C2_NUM"), oSql:getValue("C2_ITEM"), oSql:getValue("C2_SEQUEN"), oSql:getValue("C2_PRODUTO"), oSql:getValue("C2_LOCAL"), oSql:getValue("RECNOSC2")   })
			oSql:skip()
		EndDo
	Endif
	
	oSql:Close()
	
Return aApontProduc


/*/{Protheus.doc} GetErrorMsg
Ontém o erro

@author Gustavo Luiz
@since 15/02/2017
@version 1.0
@example
(examples)
/*/
Method GetErrorMsg() Class DHLBackFlush
	
Return ::cError

/*/{Protheus.doc} SetErrorMsg
Define o erro

@author Gustavo Luiz
@since 15/02/2017
@version 1.0
@example
(examples)
/*/
Method SetErrorMsg(cError) Class DHLBackFlush
	::cError := cError
Return

/*/{Protheus.doc} EstornaConsumo
Estorna o consumo

@author Gustavo Luiz
@since 28/02/2017
@version 1.0
@example
(examples)
/*/
Method EstornaConsumo(aApontProducao) Class DHLBackFlush
	
	Local aCabecalho	:= {}
	Local aItens		:= {}
	Local oSql			:= ipSqlObject():newIpSqlObject()
	Local cQuery		:= ""
	Local aInsumos		:= {}
	Local nRecnoSD3		:= 0
	Private l241Auto 	:= .T.
	Private lMsErroAuto	:= .F.
	
	cQuery := RunQueryInsumos(aApontProducao)
	
	oSql:NewAlias(cQuery)
	
	aInsumos := GetInsumos(oSql)
	
	::SetInsumos(aInsumos)
	
	aCabecalho	:= GetCab241(self, 		"ESTORNO")
	aItem		:= GetItens241(self, 	"ESTORNO")
	nRecnoSD3	:= aInsumos[1][14]
	SD3->(DbSelectArea("SD3"))
	SD3->(DbGoTo(nRecnoSD3))
	
	
	If !::HasErroOperacao()
		
		MSExecAuto({|x,y,z| MATA241(x,y,z)},aCabecalho,aItem, 6)
		
		if lMsErroAuto
			::setError(.t.)
			::setMsgErro(MostraErro())
			::SetErroOperacao(.T.)
		endIf
		
	EndIf
	
Return


/*/{Protheus.doc} hasItens
Verifica se objeto possui itens

@author Thiago Meschiatti
@since 04/04/2017
@version 1.0
@example
(examples)
/*/
Method hasItens() Class DHLBackFlush
	
Return Len(::aItens) > 0


/*/{Protheus.doc} retInsumosPositivo


@author Thiago Meschiatti
@since 04/04/2017
@version 1.0
@example
(examples)
/*/
Method retInsumosPositivo(aApontProducao) Class DHLBackFlush
	Local oSql			:= ipSqlObject():newIpSqlObject()
	Local cQuery		:= ""
	Local aInsumos		:= {}
	
	cQuery := RunQueryInsumos(aApontProducao)
	
	oSql:NewAlias(cQuery)
	
	aInsumos := GetInsumos(oSql)
	
	::SetInsumos(aInsumos)
Return


/**
* Obtém os insumos que serão estornados
**/
Static Function GetInsumos(oSql)
	
	Local aInsumos := {}
	
	If oSql:HasRecords()
		While oSql:NotIsEof()
			
			aAdd(aInsumos, { oSql:getValue("D3_TIPO"),oSql:getValue("D3_FILIAL"),oSql:getValue("D3_COD"), oSql:getValue("D3_TM"), oSql:getValue("D3_DOC"), oSql:getValue("D3_QUANT"), oSql:getValue("D3_OP"), oSql:getValue("D3_LOCAL"), oSql:getValue("D3_DOC"), oSql:getValue("D3_EMISSAO"), oSql:getValue("D3_NUMSEQ"), oSql:getValue("D3_CHAVE"), oSql:getValue("D3_LOTECTL"), oSql:getValue("R_E_C_N_O_"), oSql:getValue("D3_UM"), oSql:getValue("D3_DTVALID")  })
			
			oSql:Skip()
			
		EndDo
	EndIf
	
	oSql:Close()
	
Return aInsumos

/**
* Monta array do SD3 (Apontamento)
**/
Static Function EstrutApont(oDHLBackFlush)
	
	Local aArray 	 		:= {}
	Local cDocumento		:= ""
	
	SD3->(DbSetOrder(2))
	
	cDocumento := NextNumero("SD3", 2, "D3_DOC", .T.)
	cDocumento := A261RetINV(cDocumento)
	
	aAdd(aArray ,{"D3_TM"		,GetMv("MV_TMPAD")                 											,nil})
	aAdd(aArray ,{"D3_OP"		,Padr(oDHLBackFlush:GetOrdemProducao() + "01001" , TamSx3("D3_OP")[1], " ") ,nil})
	aAdd(aArray ,{"D3_PARCTOT"	,"P"                             	   										,nil})
	aAdd(aArray ,{"D3_DOC"		,cDocumento                            	   									,nil})
	
	If ProdutControlLote(oDHLBackFlush:GetBom())
		
		If Empty(oDHLBackFlush:GetLotBom())
			oDHLBackFlush:SetErroOperacao(.T.)
			oDHLBackFlush:setMsgErro("Produto " + Alltrim(oDHLBackFlush:GetBom()) + " controla lote, mas a TAG<LOT> esta vazia. Processo não finalizado")
			Return {}
		EndIf
		
		If Empty(oDHLBackFlush:GetExpDateBom())
			oDHLBackFlush:SetErroOperacao(.T.)
			oDHLBackFlush:setMsgErro("Produto " + Alltrim(oDHLBackFlush:GetBom()) + " controla lote, mas a TAG<EXPIRATION_DATE> esta vazia. Processo não finalizado")
			return {}
		EndIf
		
		aAdd(aArray ,{"D3_LOTECTL"	,oDHLBackFlush:GetLotBom()                              	   			,nil})
		aAdd(aArray ,{"D3_DTVALID"	,oDHLBackFlush:GetExpDateBom()                              	   		,nil})
		
	EndIf
	
	aAdd(aArray ,{"D3_QUANT"		,oDHLBackFlush:GetQtyBom()             														,nil}) //valor temporário
	aAdd(aArray ,{"D3_ZZPALLE"		,oDHLBackFlush:GetSubLote()           									,nil})
	aAdd(aArray ,{"D3_ZZJOBPM"		,oDHLBackFlush:GetWorkOrder()              								,nil})
	aAdd(aArray ,{"D3_ZZPROJE"		,oDHLBackFlush:GetProjectID()              								,nil})
	aAdd(aArray ,{"D3_ZZDOCBK"		,oDHLBackFlush:GetDocumento()              								,nil})
	
	aArray := FwVetByDic(aArray, "SD3")
	
return aClone(aArray)

/**
* Obtém os insumos pertinentes ao PA
**/
Static Function RunQueryInsumos(aApontProducao)
	
	Local cOp		:= aApontProducao[1]
	Local cRecnoSD3 := aApontProducao[8]
	Local cPA		:= aApontProducao[2]
	Local cZZPellet	:= aApontProducao[9]
	Local cDocumBK	:= aApontProducao[10]
	Local cTMBackFl	:= GetNewPar("ZZ_TMBACKF", "")
	Local cTMPadrao	:= GetNewPar("MV_TMPAD", "")
	Local cQuery	:= ""
	//aAdd(aApontProduc, {oSql:getValue("D3_OP"), oSql:getValue("D3_COD"), oSql:getValue("D3_LOCAL") ,oSql:getValue("D3_NUMSEQ"), oSql:getValue("D3_QUANT"), oSql:getValue("D3_DOC") , oSql:getValue("D3_CHAVE") , oSql:getValue("R_E_C_N_O_"), oSql:getValue("D3_CF"), oSql:getValue("D3_EMISSAO"), oSql:getValue("D3_CC"), oSql:getValue("D3_UM"), oSql:getValue("D3_CONTA"),  oSql:getValue("D3_TM") })
	
	cQuery += " SELECT SD3.R_E_C_N_O_, SD3.D3_TIPO, SD3.*	"        				+CRLF
	cQuery += " FROM %SD3.SQLNAME%"                   					 			+CRLF
	cQuery += " WHERE D3_FILIAL = '%SD3.FILIAL%' AND" 					 			+CRLF
	cQuery += " SD3.D3_OP = '" + cOP + "' AND "					 		 			+CRLF
	cQuery += " SD3.D3_ZZPALLE = '"+cZZPellet+" ' AND "								+CRLF
	//cQuery += " SD3.D3_TM = '"+cTMBackFl+" ' OR SD3.D3_TM = '"+cTMPadrao+"') AND "	+CRLF
	cQuery += " SD3.D3_TM = '"+cTMBackFl+" ' AND "									+CRLF
	cQuery += " SD3.D3_DOC = '"+cDocumBK+" ' AND "									+CRLF
	cQuery += " %SD3.NOTDEL%"                   		 				 			+CRLF
	cQuery += " ORDER BY SD3.R_E_C_N_O_"                   		 		 			+CRLF
	
	MemoWrite("EstornoConsumo.txt", oSql:Parsequery(cquery))
	
Return cQuery



/**
* Verifica se o produto controla lote
**/
Static Function ProdutControlLote(cProduct)
	
	local oSql				:= IpSqlObject():newIpSqlObject()
	Local cControlLote		:= ""
	Local lControla			:= .T.
	
	cControlLote := oSql:getFieldValue("SB1","B1_RASTRO","B1_FILIAL = '%SB1.FILIAL%' AND B1_COD = '" + cProduct + "'")
	
	If cControlLote == "N"
		lControla := .F.
	EndIf
	
	oSql:close()
	
Return lControla

/**
* Obtém a query apontamento de produção
**/
Static Function RunQueryApontProd(cPalletID, cNumProjeto)
	
	Local cQuery 		:= ""
	
	cQuery += " SELECT SD3.R_E_C_N_O_ RECNOSD3, SC2.R_E_C_N_O_ RECNOSC2, SD3.*, SC2.*	"                  								+CRLF
	cQuery += " FROM %SC2.SQLNAME%"                   					 	+CRLF
	
	cQuery += " LEFT JOIN %SD3.SQLNAME% ON"                   			 	+CRLF
	cQuery += " SD3.D3_FILIAL = '%SD3.FILIAL%' AND "                   		+CRLF
	cQuery += "	SD3.D3_ZZPROJE = SC2.C2_ZZPROJE AND  "                 		+CRLF
	cQuery += " SD3.D3_OP = SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN AND" +CRLF
	cQuery += " SD3.D3_ESTORNO = ' ' AND" 					 				+CRLF
	cQuery += " SD3.D3_ZZPROJE = '"+cNumProjeto+"' AND"                   	+CRLF
	//	cQuery += " SD3.D3_ZZPALLE = '"+cPalletID+"' AND "                 		+CRLF
	cQuery += " %SD3.NOTDEL%"                    				 			+CRLF
	
	cQuery += " WHERE "														+CRLF
	cQuery += " SC2.C2_FILIAL = '%SD2.FILIAL%' AND "						+CRLF
	cQuery += " SC2.C2_ZZPROJE = '"+cNumProjeto+"' AND "					+CRLF
	cQuery += " %SC2.NOTDEL%"                    				 			+CRLF
	cQuery += " ORDER BY SD3.R_E_C_N_O_ DESC "								+CRLF
	
Return cQuery

/**
* Obtém o cabeçalho do consumo
**/
Static Function GetCab241(oBackFlush, cTipoOperacao)
	
	Local aCabecalho := {}
	Local aInsumos	 := {}
	Local nI		 := 1
	Local cDocumento := ""
	Local aArea		 := GetArea()
	Local aAreaSD3	 := SD3->(GetArea())
	
	If cTipoOperacao == "INCLUSAO"
		
		SD3->(DbSetOrder(2))
		
		cDocumento := NextNumero("SD3", 2, "D3_DOC", .T.)
		cDocumento := A261RetINV(cDocumento)
		
		aAdd(aCabecalho ,{"D3_TM"			,GetMv("ZZ_TMBACKF")                 							,nil})
		aAdd(aCabecalho ,{"D3_EMISSAO"		,dDataBAse                 										,nil})
		aAdd(aCabecalho ,{"D3_DOC"			,cDocumento                            	   						,nil})
		
	ElseIf cTipoOperacao == "ESTORNO"
		
		aInsumos := oBackFlush:GetInsumos()
		
		For nI := 1 To Len(aInsumos)
			aAdd(aCabecalho ,{"D3_DOC"			,aInsumos[nI][5]                									,nil})
			aAdd(aCabecalho ,{"D3_EMISSAO"		,sTod(aInsumos[nI][10])          									,nil})
			exit
		Next nI
		
	EndIf
	
	RestArea(aArea)
	RestArea(aAreaSD3)
	
Return aClone(aCabecalho)

/**
* Obtém os itens dos consumos
**/
Static Function GetItens241(oDHLBackFlush, nTipoOperacao)
	
	Local aVetor 			:= {}
	Local aItens 			:= oDHLBackFlush:GetItens()
	Local nI				:= 0
	Local cLocal			:= "01"
	Local cMod				:= ""
	Local nQuantBaseEstr	:= 0
	Local cUniMedMod		:= ""
	Local nHorasMOD			:= 0
	Local aInsumos			:= {}
	
	If nTipoOperacao == "INCLUSAO"
		
		For nI := 1 To Len(aItens)
			
			aItem := {}
			
			aAdd(aItem ,{"D3_COD"			,Padr(aItens[nI][PRODUTO], 	TamSx3("D3_COD")[1], " ")				 														  ,nil})
			aAdd(aItem ,{"D3_UM"			,Padr(aItens[nI][UM], 		TamSx3("D3_UM")[1], " ")    			 														  ,nil})
			aAdd(aItem, {"D3_QUANT"  		,GetQuantFatoreado(aItens[nI][4], oDHLBackFlush) ,nil})
			aAdd(aItem, {"D3_LOCAL"  		,cLocal       														 														  ,nil})
			aAdd(aItem, {"D3_OP"     		,oDHLBackFlush:GetOrdemProducao() + "01001"							 														  ,nil})
			aAdd(aItem, {"D3_ZZPALLE"     	,oDHLBackFlush:GetSubLote() 										 														  ,nil})
			
			If ProdutControlLote(aItens[nI][PRODUTO])
				
				If Empty(aItens[nI][LOTE])
					oDHLBackFlush:SetErroOperacao(.T.)
					oDHLBackFlush:setMsgErro("Produto " + Alltrim(aItens[nI][PRODUTO]) + " controla lote, mas a TAG<LOT> esta vazia. Processo não finalizado")
					Exit
				EndIf
				
				If Empty(aItens[nI][1])
					oDHLBackFlush:SetErroOperacao(.T.)
					oDHLBackFlush:setMsgErro("Produto " + Alltrim(aItens[nI][PRODUTO]) + " controla lote, mas a TAG<EXPIRATION_DATE> esta vazia. Processo não finalizado")
					Exit
				EndIf
				
				aAdd(aItem,{"D3_LOTECTL", Padr(aItens[nI][LOTE], TamSx3("D3_LOTECTL")[1], "")      						,nil})
				aAdd(aItem,{"D3_DTVALID", aItens[nI][1]		 															,nil})
				
			EndIf
			
			aItem := FwVetByDic(aItem, "SD3")
			
			aAdd(aVetor, aItem)
			
		Next nI
		
		//VERIFICA SE EXISTE MOD
		If oDHLBackFlush:GetExistMOD() .AND. !oDHLBackFlush:HasErroOperacao()
			cMod 			 := GetMod(oDHLBackFlush)
			nQuantMOD		 := GetQuantMOD(oDHLBackFlush)
			nQuantBaseEstr	 := GetQuantBaseEstrut(oDHLBackFlush)
			cUniMedMod	 	 := GetUniMedMod(cMod)
			nQuantPA		 := oDHLBackFlush:GetQtyBom()
			nHorasMOD		 := CalculaModHoras(nQuantBaseEstr, nQuantPA, nQuantMOD)
			aItem 			 := {}
			
			aAdd(aItem ,{"D3_COD"			,Padr(cMod, 		TamSx3("D3_COD")[1], " ")		,nil})
			aAdd(aItem ,{"D3_UM"			,Padr(cUniMedMod, 	TamSx3("D3_UM")[1],  " ")		,nil})
			aAdd(aItem, {"D3_QUANT"  		,nHorasMOD       									,nil})
			aAdd(aItem, {"D3_LOCAL"  		,cLocal       										,nil})
			aAdd(aItem, {"D3_OP"     		,oDHLBackFlush:GetOrdemProducao() + "01001"			,nil})
			aAdd(aItem, {"D3_ZZPALLE"     	,oDHLBackFlush:GetSubLote() 						,nil})
			
			aItem 			 := FwVetByDic(aItem, "SD3")
			
			aAdd(aVetor, aItem)
		EndIf
		
	ElseIf nTipoOperacao == "ESTORNO"
		
		aInsumos := oDHLBackFlush:GetInsumos()
		
		For nI := 1 To Len(aInsumos)
			
			aItem := {}
			
			aAdd(aItem ,{"D3_COD"			,aInsumos[nI][3]				,nil})
			aAdd(aItem ,{"D3_UM"			,aInsumos[nI][1]    			,nil})
			aAdd(aItem, {"D3_QUANT"  		,aInsumos[nI][6]				,nil})
			aAdd(aItem, {"D3_LOCAL"  		,aInsumos[nI][8]       			,nil})
			aAdd(aItem, {"D3_OP"     		,aInsumos[nI][7]				,nil})
			
			aItem 			 := FwVetByDic(aItem, "SD3")
			
			aAdd(aVetor, aItem)
			
		Next nI
		
	EndIf
	
Return aClone(aVetor)

/**
* Obtém a quantidade fatoreado pela quantidade total do PA caso o fator seja diferente de 0
**/
Static Function GetQuantFatoreado(xQuantInsumo, oDHLBackFlush)
	
	Local nResultado := 0
	Local nQtdPAFator:= oDHLBackFlush:GetQtyBom()
	
	//CASO O FATOR SEJA DIFERENTE DE ZERO, É PORQUE PASSOU PELA ROTINA ExecApontParcial(). COM ISSO É NECESSÁRIO RATEAR OS INSUMOS DE ACORDO COM A QUANTIDADE DO PA
	If oDHLBackFlush:GetFator() != 0
		If ValType(xQuantInsumo) == "N"
			nResultado := (nQtdPAFator * xQuantInsumo) / oDHLBackFlush:GetFator()
		Else
			nResultado := (nQtdPAFator * Val(xQuantInsumo)) / oDHLBackFlush:GetFator()
		EndIf
	Else
		If ValType(xQuantInsumo) == "N"
			nResultado := xQuantInsumo
		Else
			nResultado := Val(xQuantInsumo)
		EndIf
	EndIf
	
Return nResultado

/**
* Retorna a unidade de medida do MOD
**/
Static Function GetUniMedMod(cMod)
	
	Local cUM			:= ""
	Local oSql	  		:= ipSqlObject():newIpSqlObject()
	
	cUM := oSql:getFieldValue("SB1", "B1_UM", "%SB1.XFILIAL% AND B1_COD = '"  + Padr(cMod, TamSx3("B1_COD")[1], "") + "'")
	
	oSql:Close()
	
Return cUM


/**
* Retorna a quantidade de horas cadastrada na estrutura
**/
Static Function GetQuantMOD(oDHLBackFlush)
	
	Local nQuant		:= 0
	Local oSql	  		:= ipSqlObject():newIpSqlObject()
	
	nQuant := oSql:getFieldValue("SG1", "G1_QUANT", "%SG1.XFILIAL% AND G1_COD = '"  + Padr(oDHLBackFlush:GetBom(), TamSx3("G1_COD")[1], "") + "'")
	
	oSql:Close()
	
Return nQuant

/**
* Calcula a quantidade de horas
**/
Static Function CalculaModHoras(nQuantBaseEstr, nQuantPA, nQuantMOD)
	
	Local nResult := 0
	
	nResult := (nQuantPA*nQuantMOD)/nQuantBaseEstr
	
Return nResult

/**
* Obtém o MOD do PA
**/
Static Function GetMod(oDHLBackFlush)
	
	Local cComponente	:= ""
	Local oSql	  		:= ipSqlObject():newIpSqlObject()
	
	cComponente := oSql:getFieldValue("SG1", "G1_COMP", "%SG1.XFILIAL% AND G1_COD = '"  + Padr(oDHLBackFlush:GetBom(), TamSx3("G1_COD")[1], "") + "'")
	
	oSql:Close()
	
Return cComponente

/**
* Obtém a quantidade base da estrutura
**/
Static Function GetQuantBaseEstrut(oDHLBackFlush)
	
	Local nQtdBase		:= 0
	Local oSql	  		:= ipSqlObject():newIpSqlObject()
	
	nQtdBase := oSql:getFieldValue("SB1", "B1_QB", "%SB1.XFILIAL% AND B1_COD = '"  + Padr(oDHLBackFlush:GetBom(), TamSx3("B1_COD")[1], "") + "'")
	
	oSql:Close()
	
Return nQtdBase


/**
* Abre as tabelas. Necessário, pois na segunda iteração da nota estava dando ajustar DOC_SEQ.
* É necessário abrir as 3 tabelas
**/
static function abreTabelas()
	
	local lStatus := .F.
	
	If Select('SD1') <= 0
		dbSelectArea('SD1')
	EndIf
	If Select('SD2') <= 0
		dbSelectArea('SD2')
	EndIf
	If Select('SD3') <= 0
		dbSelectArea('SD3')
	EndIf
	
	lStatus := (Select('SD1')>0) .And. (Select('SD2')>0) .And. (Select('SD3')>0)
	
return
