#include 'Protheus.ch'
#include 'dhl.ch'
#include 'tabstipoprod.ch'


/*/{Protheus.doc} UpdTipoPrd

Update nos tipos de produtos

@author Thiago Meschiatti
@since 20/02/2015

/*/
User Function UpdTipoPrd()
	private oParamBox := nil

	if !(showParam())
		return
	endIf

	if vldParamFile(oParamBox)
		Processa( {|| processArq() }, "Aguarde...", "Processando...",.F.)
	endif

Return


/*
**
*/
static function processArq()
	local nI,nJ, nK	:= 0
	local aProds	:= {}
	local lErro		:= .f.
	local cFile		:= oParamBox:getValue("file")

	private dDatade		:= oParamBox:getValue("dataDe")
	private dDataAte	:= oParamBox:getValue("dataAte")

	aProds := importaArq(cFile)
	ProcRegua(len(aProds))

	BEGIN TRANSACTION
		BEGIN SEQUENCE

			for nI:=1 to len(aProds)
				IncProc("Processando...")		
				for nJ := 1 to len(TABS_PRODS)
					for nK := 1 to len(TABS_PRODS[nJ])				
						lErro := updTable(aProds[nI, PROD], aProds[nI, TP_PROD],  TABS_PRODS[nK, TABLE], TABS_PRODS[nK, FIELD_UPD], TABS_PRODS[nK, FIELD_PRD], if(len(TABS_PRODS[nK]) > 3, TABS_PRODS[nK, DT_VALID], ""))
						if lErro
							Alert("ERRO! Rollback será efetuado!")
							BREAK
						endif
					next nK
				next nJ
			next nI
			
		RECOVER
			DisarmTransaction()
		END SEQUENCE
	END TRANSACTION 
return


/*
*	Função responsável pela exibição da tela de parâmetros.
*/
static function showParam()
	local cNome		:= "UpdateProd"
	local cTitulo	:= "Informe o período"

	oParamBox 	:= IpParamBoxObject():newIpParamBoxObject(cNome)

	oParamBox:setTitle(cTitulo)

	oParam := IpParamObject():newIpParamObject("dataDe", "get", "Data de:", "D", 9, 10)
	oParam:setRequired(.F.)
	oParamBox:addParam(oParam)

	oParam := IpParamObject():newIpParamObject("dataAte", "get", "Data até:", "D", 9, 10)
	oParam:setRequired(.F.)
	oParamBox:addParam(oParam)

	oParam := IpParamObject():newIpParamObject("file", "file", "Arquivo", "C", 80)
	oParam:setFileStartDirectory("C:\")
	oParam:setFileTypes("Arquivos TXT |*.txt")
	oParam:setFileParams(GETF_LOCALHARD+GETF_NETWORKDRIVE)
	oParamBox:addParam(oParam)

return oParamBox:show()


/**
* Valida o arquivo selecionado
*/
static function vldParamFile(oParamBox)

	local cFile := oParamBox:getValue("file")

	cFile := AllTrim(Lower(cFile))

	if Empty(cFile)
		MsgBox("Informe um arquivo para importação", "Atenção", "ALERT")
		return .F.
	endIf

return .t.


/*
** Importação do arquivo de cutover.
*/
static function importaArq(cFile)
	local oFile 	:= nil 
	local cDir 		:= cFile
	local aProds	:= {}

	oFile := IpFileObject():newIpFileObject(upper(cDir))

	oFile:open()
	while oFile:notIsEof()
		aadd(aProds, separa(oFile:readLine(), ';') )		
		oFile:skipLine()
	end
	oFile:close()

return aclone(aProds)


/*
** Executa atualização
*/
static function updTable(cProd, cTpProd, cTable, cFieldUpd, cField, cFieldDt)
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	local cUpd		:= ""
	local lOk		:= .f.

	default cFieldDt := ""

	cQuery := " %"+cTable+".XFILIAL% AND "+cField+" = '"+cProd+"' "
	if !empty(cFieldDt)
		cQuery += " AND "+cFieldDt+" BETWEEN '"+dtos(dDatade)+"' AND '"+dtos(dDataAte)+"'
	endif

	cUpd := cFieldUpd+" = '"+cTpProd+"'

	lOk := oSql:update(cTable, cUpd, cQuery)

return !(lOK)