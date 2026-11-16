#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "totvs.ch"
#include "fwmvcdef.ch"
#include "dhl.ch"

#define MVC_MAIN_ID       "MonIp040"
#define MVC_MODEL_ID      "mMonIp"
#define MVC_VIEW_ID       "vMonIp"
#define MVC_TITLE         "Monitor Interface SAP IP 040"

#define AUTORIZADA		"S"

/*/{Protheus.doc} MonIp040

Processamento Monitor interface SAP IP 040.
Processo para a Unidade de Negócio AG2(SCJ - PUZZLE)

@author Gustavo Luiz
@since 25/05/2017
@version undefined

@type function
/*/
User Function MonIp040()

	local cFilSZA	   := ""

	private oBrowse 	:= FwMbrowse():new()
	private bRefresh 	:= {|| IP040Refres(SZA->(Recno()),2) }
	private bLegenda 	:= {|| IP040Legend() }
	private bProcessar	:= {|| FWMsgRun(, {|| ProcessarNF()},,"Aguarde iniciando...")}
	//	private bProcRet	:= {|| u_PrcNfRet()} //TODO - retirar a chamada dessa função
	private bRSymbResend:= {|| RSymbResend(SZA->(Recno()),7)}
	private bRCOResend	:= {|| RCOResend(SZA->(Recno()),8)}
	private bParametros	:= {|| ChangeParam()}
	private oParambox	:= nil

	if !showParam()
		return
	endIf

	oBrowse:setAlias("SZA")
	oBrowse:setDescription(MVC_TITLE)

	oBrowse:addLegend("!Empty(SZA->ZA_NFRET) .And. !Empty(SZA->ZA_SERIRET) .And. !Empty(SZA->ZA_NFRCO) .And. !Empty(SZA->ZA_SERIRCO)", "ENABLE"		, "NF SCJ Processada (Rco/Ret) "				)
	oBrowse:addLegend("!Empty(SZA->ZA_NFRET) .And. !Empty(SZA->ZA_SERIRET) .And. Empty(SZA->ZA_NFRCO) .And. Empty(SZA->ZA_SERIRCO)", "ENABLE"		, "NF SCJ Processada (Ret) "				)
	oBrowse:addLegend(" Empty(SZA->ZA_NFRET) .And.  Empty(SZA->ZA_SERIRET) .And.  Empty(SZA->ZA_NFRCO) .And.  Empty(SZA->ZA_SERIRCO)", "DISABLE"	, "NF SCJ Não Processada "			)
	oBrowse:addLegend(" (Empty(SZA->ZA_NFRET) .And. Empty(SZA->ZA_SERIRET)) .And. (!Empty(SZA->ZA_NFRCO) .And. !Empty(SZA->ZA_SERIRCO))", "YELLOW"		, "NF SCJ Processada Parcialmente "	)

	cFilSZA := getFilter()

	oBrowse:SetFilterDefault( cFilSZA )

	oBrowse:activate()

Return

/**
* Função responsável pela definição das opções de menu.
**/
static function menuDef()

	local aRotina := {}
	local cViewId := "viewDef."+MVC_MAIN_ID

	ADD OPTION aRotina TITLE "Pesquisar"		    		ACTION "PesqBrw" 				OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"	    			ACTION cViewId					OPERATION 2	ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"	    				ACTION cViewId					OPERATION 5	ACCESS 0
	ADD OPTION aRotina TITLE "Refresh"	    				ACTION "Eval(bRefresh)"			OPERATION 2	ACCESS 0
	ADD OPTION aRotina TITLE "Processar"	    			ACTION "Eval(bProcessar)"		OPERATION 4	ACCESS 0
	//	ADD OPTION aRotina TITLE "Processar RET"    			ACTION "Eval(bProcRet)"			OPERATION 4	ACCESS 0 //TODO - retirar a chamada dessa função
	ADD OPTION aRotina TITLE "Legenda"	    				ACTION "Eval(bLegenda)"			OPERATION 6	ACCESS 0
	ADD OPTION aRotina TITLE "Reenviar Ret. Simb. IP050"	ACTION "Eval(bRSymbResend)"		OPERATION 7	ACCESS 0
	ADD OPTION aRotina TITLE "Reenviar RCO IP140"			ACTION "Eval(bRCOResend)"		OPERATION 8	ACCESS 0
	ADD OPTION aRotina TITLE "Parâmetros"					ACTION "Eval(bParametros)"		OPERATION 9	ACCESS 0

return aRotina

/**
* Modelagem
*/
static function modelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSZA := FWFormStruct( 1, 'SZA', /*bAvalCampo*/, /*lViewUsado*/ )
	Local oStruSZB := FWFormStruct( 1, 'SZB', /*bAvalCampo*/, /*lViewUsado*/ )
	Local oModel

	// Cria o objeto do Modelo de Dados	com pos validação do modelo
	oModel := MPFormModel():New( 'SZAMODEL', /*bPreValidacao*/,  , /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'SZAMASTER', /*cOwner*/, oStruSZA )

	// Adiciona ao modelo uma estrutura de formulário de edição por grid com validação de linha
	oModel:AddGrid( 'SZBDETAIL', 'SZAMASTER', oStruSZB, /*bLinePre*/, /**/, /*bPreVal*/, /*bPosVal*/ )

	// Faz relaciomaneto entre os compomentes do model
	oModel:SetRelation( 'SZBDETAIL', { { 'ZB_FILIAL',  'xFilial( "SZB" )' }, { 'ZB_KENFSCJ', 'ZA_KENFSCJ' } }, SZB->( IndexKey( 1 ) ) )
	oModel:SetPrimaryKey({})
	// Liga o controle de nao repeticao de linha
	//oModel:GetModel( 'ZA2DETAIL' ):SetUniqueLine( { 'ZA2_AUTOR' } )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'ITENS DE NOTAS FISCAIS SCJ' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:SetDescription("Notas Fiscais SCJ")
	oModel:GetModel( 'SZAMASTER' ):SetDescription( 'Dados Da Nota Fiscal' )
	oModel:GetModel( 'SZBDETAIL' ):SetDescription( 'Dados Dos Itens Da Nota Fiscal'  )

return oModel

/**
* Interface Visual
**/
Static Function ViewDef()
	Local oView			:= Nil
	Local oModel		:= FWLoadModel(MVC_MAIN_ID)
	Local oStructCab	:= FWFormStruct(2, 'SZA')
	Local oStructGri	:= FWFormStruct(2, 'SZB')

	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)

	//Adicionando os campos do cabeçalho e o grid dos filhos
	oView:AddField('VIEW_SZA',oStructCab,'SZAMASTER')
	oView:AddGrid('VIEW_SZB',oStructGri,'SZBDETAIL')

	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',45)
	oView:CreateHorizontalBox('GRID',55)

	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_SZA','CABEC')
	oView:SetOwnerView('VIEW_SZB','GRID')

	//Habilitando título
	oView:EnableTitleView('VIEW_SZA','Cabeçalho')
	oView:EnableTitleView('VIEW_SZB','Itens')

Return oView

/**
* Atualiza os registros do browse
*/
static function IP040Refres(nReg,nOpcx)

	SZA->(dbGoTop())
	SZA->(dbGoTo(nReg))

	oMainWnd:refresh()

return

/**
* Legenda
**/
static function IP040Legend()

	local aCores := {}
	aCores := {	{"ENABLE" ,"NF SCJ Processada"},;
	{"DISABLE","NF SCJ Não Processada"},;
	{"BR_AMARELO","NF SCJ Processada Parcialmente"}}

	BrwLegenda("Monitor Interface SAP IP 040","Legenda",aCores)

return( .T. )

/**
* Função responsável pelo geração da interface IP050
**/
static function RSymbResend(nReg,nOpcx)

	local aArea		:= GetArea()
	local aAreaSZA	:= SZA->(GetArea())
	local aAreaSF2	:= SF2->(GetArea())

	processIP050()

	RestArea(aAreaSF2)
	RestArea(aAreaSZA)
	RestArea(aArea)

return

/**
* Função de processamento (Geração) IP050
**/
static function processIP050()

	local cFilNF	:= ""
	local cNota		:= ""
	local cSerie	:= ""
	local cClieFor	:= ""
	local cLoja		:= ""
	local cNotaOri	:= ""
	local cSerieOri	:= ""
	local cTipo		:= DHL_NFE_INVOICE_OUTFLOW
	local cStatus	:= ""
	local cEspecie	:= ""
	local cTipoNF	:= ""
	local cNfRET	:= ""
	local cSeriRET	:= ""
	local lRet		:= .F.

	cNfRET 		:= SZA->ZA_NFRET
	cSeriRET	:= SZA->ZA_SERIRET

	SF2->(DbSetOrder(1))
	if SF2->(DbSeek(FwXFilial("SF2") + cNfRET + cSeriRET))
		cFilNF		:= SF2->F2_FILIAL
		cNota		:= SF2->F2_DOC
		cSerie		:= SF2->F2_SERIE
		cClieFor	:= SF2->F2_CLIENTE
		cLoja		:= SF2->F2_LOJA
		cNotaOri	:= SF2->F2_NFORI
		cSerieOri	:= SF2->F2_SERIORI
		cTipo		:= DHL_NFE_INVOICE_OUTFLOW
		cStatus		:= SF2->F2_FIMP
		cEspecie	:= SF2->F2_ESPECIE
		cTipoNF		:= SF2->F2_ZZTPNF

		if !canRSymbResend(cEspecie, cStatus,cFilNF,cNota,cSerie,cTipoNF)
			return
		endIf

		if !(MsgYesNo("Deseja gerar a interface IP050?", "Aviso"))
			return
		endIf

		FWMsgRun(, {|| lRet := U_PrcXmlRSymb(cTipo, cSerie, cNota, cClieFor, cLoja, cNotaOri, cSerieOri)},,"Aguarde, gerando interface")

		if lRet
			MsgInfo("Interface IP050 gerada com sucesso.", "Atenção")
		else
			MsgInfo("Erro ao gerar a interface IP050, verifique a tabela de log.", "Atenção")
		endIf

	endIf

return

/**
* Função responsável pela validação da geração da interface.
**/
static function canRSymbResend(cEspecie,cStatus,cFilNF,cNota,cSerie,cTipoNF)

	Local lRet := .T.
	Local lRetSZARCO:= .F.

	if Alltrim(cEspecie) != "SPED"
		lRet := .F.
		MsgInfo("Somente Notas Fiscais com espécie SPED podem ser retransmitidas", "Atenção")
	elseif cStatus != 'S'
		lRet := .F.
		MsgInfo("Somente Notas Fiscais aprovadas podem ser retransmitidas", "Atenção")
	elseif Deleted()
		lRet := .F.
		MsgInfo("Notas canceladas não podem ser retrasmitidas!", "Atenção")
	endif

	if cTipoNF == RETORNO_SIMBOLICO
		lRetSZARCO := getSZARCO(cFilNF,cNota,cSerie)
		if !lRetSZARCO .or. !lRet
			lRet := .F.
		endif
	else
		lRet := .F.
		MsgInfo("Nota posicionada não pertence a uma Nota Fiscal de Retorno Simbólico.", "Atenção")
	endif
return lRet

/**
* Verifica se o registro na SZA possui preenchimento nos campos de RCO
*/
static function getSZARCO(cFilialNF,cNota,cSerie)
	Local lRet			:= .F.
	Local oSql  		:= IpSqlObject():newIpSqlObject()
	Local cNFRCO		:= ""
	Local cSeriRCO		:= ""
	Local cStatusRCO	:= ""

	oSql:newTable("SZA", "ZA_NFRCO, ZA_SERIRCO",;
	"ZA_FILIAL = '"	+cFilialNF+	"' AND " + ;
	"ZA_NFRET = '"	+cNota+		"' AND "+;
	"ZA_SERIRET = '"+cSerie+	"' ")

	if oSql:notIsEof()
		cNFRCO := oSql:getValue("ZA_NFRCO")
		cSeriRCO := oSql:getValue("ZA_SERIRCO")
		oSql:close()
		if !Empty(cNFRCO)
			oSql	:= IpSqlObject():newIpSqlObject()
			oSql:newTable("SF2","F2_FIMP",;
			"F2_FILIAL = '"	+cFilialNF+	"' AND "+;
			"F2_DOC = '" 	+cNFRCO+	"' AND "+;
			"F2_SERIE = '" 	+cSeriRCO+	"' ")
			if oSql:getValue("F2_FIMP") == 'S' //NF APROVADA PELO SEFAZ VIA MASTERSAF
				lRet := .T.
			else
				MsgInfo("NF de Remessa por Conta e Ordem NF: "+ cNFRCO +;
				" Série: " + cSeriRCO + " referente a NF de Retorno Simbólico NF: "+ cNota +;
				" Série: "+ cSerie + ", não autorizada pelo Sefaz. Interface IP050 não foi gerada.","Atenção")
			endif
		else
			lRet := .T.
		endif
	else
		MsgInfo("NF de Retorno Simbólico NF: "+ cNota +;
		" Série: "+ cSerie + ", não possui registro na SZA. Interface IP050 não foi gerada.","Atenção")
	endif
return lRet

/**
* Função responsável pelo geração da interface IP140
**/
static function RCOResend(nReg,nOpcx)

	local aArea		:= GetArea()
	local aAreaSZA	:= SZA->(GetArea())
	local aAreaSF2	:= SF2->(GetArea())

	processIP140()

	RestArea(aAreaSF2)
	RestArea(aAreaSZA)
	RestArea(aArea)

return

/**
* Função de processamento (Geração) IP140
**/
static function processIP140()

	local lRet		:= .F.
	local cFilNF	:= ""
	local cNota		:= ""
	local cSerie	:= ""
	local cClieFor	:= ""
	local cLoja		:= ""
	local cNotaOri	:= ""
	local cSerieOri	:= ""
	local cTipo		:= ""
	local cStatus	:= ""
	local cEspecie	:= ""
	local cTipoNF	:= ""
	local cNfRCO	:= ""
	local cSeriRCO	:= ""

	cNfRCO		:= SZA->ZA_NFRCO
	cSeriRCO	:= SZA->ZA_SERIRCO

	SF2->(DbSetOrder(1))
	if SF2->(DbSeek(FwXFilial("SF2") + cNfRCO + cSeriRCO))
		cFilNF		:= SF2->F2_FILIAL
		cNota		:= SF2->F2_DOC
		cSerie		:= SF2->F2_SERIE
		cClieFor	:= SF2->F2_CLIENTE
		cLoja		:= SF2->F2_LOJA
		cNotaOri	:= SF2->F2_NFORI
		cSerieOri	:= SF2->F2_SERIORI
		cTipo		:= DHL_NFE_INVOICE_OUTFLOW
		cStatus		:= SF2->F2_FIMP
		cEspecie	:= SF2->F2_ESPECIE
		cTipoNF		:= SF2->F2_ZZTPNF

		if !(canRCOResend(cEspecie, cStatus,cFilNF,cNota,cSerie,cTipoNF))
			return
		endIf

		if !(MsgYesNo("Deseja gerar a interface IP140?", "Aviso"))
			return
		endIf

		FWMsgRun(, {|| lRet := U_PrcRCOXml(cTipo, cSerie, cNota, cClieFor, cLoja, cNotaOri, cSerieOri)},,"Aguarde, gerando interface")

		if lRet
			MsgInfo("Interface IP140 gerada com sucesso.", "Atenção")
		else
			MsgInfo("Erro ao gerar a interface IP140, verifique a tabela de log.", "Atenção")
		endIf

	endIf

return

/**
* Função responsável pela validação da geração da interface.
**/
static function canRCOResend(cEspecie,cStatus,cFilNF,cNota,cSerie,cTipoNF)
	Local lRet := .T.

	if Alltrim(cEspecie) != "SPED"
		lRet := .F.
		MsgAlert("Somente Notas Fiscais com espécie SPED podem ser retransmitidas", "Atenção")
	elseif cStatus != 'S'
		lRet := .F.
		MsgAlert("Somente Notas Fiscais aprovadas podem ser retransmitidas", "Atenção")
	elseif Deleted()
		lRet := .F.
		MsgAlert("Notas canceladas não podem ser retrasmitidas!", "Atenção")
	endif

	if cTipoNF == REMESSA_CONTA_ORDEM
		if cStatus != "S" .or. !lRet
			lRet := .F.
		endif
	else
		lRet := .F.
		MsgAlert("Nota posicionada não pertence a uma Nota Fiscal de Remessa por Conta e Ordem.", "Atenção")
	endif
return lRet

/*
* Função responsável pela exibição da tela de parâmetros
*/
static function showParam()
	local cNome		:= "Interface SAP IP 040"
	local cTitulo	:= "Informe os parâmetros de filtro"

	oParamBox 	:= IpParamBoxObject():newIpParamBoxObject(cNome)

	oParamBox:setTitle(cTitulo)

	oParam := IpParamObject():newIpParamObject("docSCJde", "get", "NF SCJ De", "C", 9, TamSx3("ZA_DOCSCJ")[1])
	oParamBox:addParam(oParam)

	oParam := IpParamObject():newIpParamObject("serieSCJde", "get", "Serie NF SCJ De", "C", 3, TamSx3("ZA_SERISCJ")[1])
	oParamBox:addParam(oParam)

	oParam := IpParamObject():newIpParamObject("docSCJate", "get", "NF SCJ Até", "C", 9, TamSx3("ZA_DOCSCJ")[1])
	oParamBox:addParam(oParam)

	oParam := IpParamObject():newIpParamObject("serieSCJate", "get", "Serie NF SCJ Até", "C", 3, TamSx3("ZA_SERISCJ")[1])
	oParamBox:addParam(oParam)

return oParamBox:show()

/*
* Obtém o filtro de acordo com os parâmetros do parambox
*/
static function getFilter()

	local cDocSCJDe    := ""
	local cSerieSCJDe  := ""
	local cDocSCJAte   := ""
	local cSerieSCJAte := ""
	local cTrazMarcado := ""
	local cFilSZA	   := ""

	cDocSCJDe    := oParamBox:getValue("docSCJde")
	cSerieSCJDe  := oParamBox:getValue("serieSCJde")
	cDocSCJAte   := oParamBox:getValue("docSCJate")
	cSerieSCJAte := oParamBox:getValue("serieSCJate")
	cTrazMarcado := oParamBox:getValue("trazmarcado")

	cFilSZA := "ZA_FILIAL='"+xFilial("SZA")+"'"
	cFilSZA += ".And.ZA_DOCSCJ>='"+cDocSCJDe+"'"
	cFilSZA += ".And.ZA_DOCSCJ<='"+cDocSCJAte+"'"
	cFilSZA += ".And.ZA_SERISCJ>='"+cSerieSCJDe+"'"
	cFilSZA += ".And.ZA_SERISCJ<='"+cSerieSCJAte+"'"

return cFilSZA

/*
* Altera os parâmetros
*/
static function ChangeParam()

	if !showParam()
		return
	endIf

	cFilSZA := getFilter()

	oBrowse:SetFilterDefault( cFilSZA )

return

/*
* Processa a NF
*/
static function ProcessarNF()

	local lGerarRet 	:= .t.
	local cNfRCO 		:= SZA->ZA_NFRCO
	local cSeriRCO		:= SZA->ZA_SERIRCO
	local cNfRET		:= SZA->ZA_NFRET
	local cSeriRET		:= SZA->ZA_SERIRET
	local nRecnoSF2		:= 0	
	local lLockByNam	:= .F.
	local cNomeLock		:= allTrim(SZA->ZA_KENFSCJ)
	local lProcBySema 	:= SuperGetMv("ZZ_PROCSMF",,.T.)

	FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "*********************INICIO FONTE MONIP040.PRW " + time() + " ********************" + CRLF, 0, 0, {})
	
	if lProcBySema
		lLockByNam := LockByName( cNomeLock , .T., .T. )
	else
		lLockByNam := .T.
	endIf

	if lLockByNam
		BEGIN TRANSACTION	
			
			if empty(cNfRCO) .and. empty(cSeriRCO) .and. empty(cNfRET) .and. empty(cSeriRET)
				FWMsgRun(, {|| u_PrcNfRco()},,"Aguarde, gerando faturamento!")
			elseIf !empty(cNfRCO) .and. !empty(cSeriRCO) .and. empty(cNfRET) .and. empty(cSeriRET)
				nRecnoSF2 := GetRecnoSF2(cNfRCO, cSeriRCO)
				if ChecStatusFIMP(nRecnoSF2, REMESSA_CONTA_ORDEM)
					FWMsgRun(, {|| u_PrcNfRco(lGerarRet)},,"Aguarde, gerando faturamento!")
				endIf
			else
				Aviso("Atenção","Não é possível realizar o processamento com status NF SCJ Processada",{"OK"},3)
			endIf
		END TRANSACTION
		
		if lProcBySema
			UnlockByName( cNomeLock , .T., .T. )	
		endIf
			
	else
		ApMsgInfo( "Já existe um processamento referente a chave  <br><b>"+ allTrim(SZA->(ZA_KENFSCJ)) +"</b> <br><br>"+;
							"<b>Solução:</b> Escolha outra nota","Atenção")
	endIf	

	FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "*********************FIM FONTE MONIP040.PRW " + time() + " ********************" + CRLF, 0, 0, {})

return

/*
* Verifica o status F2_FIMP da nota
*/
static function ChecStatusFIMP(nRecno, cTipo)

	local lStatus 	:= .F.
	local aArea		:= GetArea()
	local aAreaSF2	:= SF2->(GetArea())

	SF2->(DbGoTo(nRecno))

	if SF2->F2_FIMP == AUTORIZADA
		lStatus := .T.
	else
		Aviso("Atenção","Documento/Série " + AllTrim(SF2->F2_DOC) + "/" + AllTrim(SF2->F2_SERIE) + " (remessa por conta e ordem) não autorizado pelo SEFAZ",{"OK"},3)
	endIf

return lStatus

/**
* Obtém o recno da SF2 de acordo com a chave NOTA + SÉRIE
**/
static function GetRecnoSF2(cNota, cSerie)

	local nRecno := 0

	SF2->(DbSetOrder(1))

	if SF2->(DbSeek(FwXFilial("SF2") + cNota + cSerie))

		nRecno := SF2->(Recno())

	endIf

return nRecno

/**
* função somente para executar FWMsgRun
**/
static function PrcMsg()	
return .T.
