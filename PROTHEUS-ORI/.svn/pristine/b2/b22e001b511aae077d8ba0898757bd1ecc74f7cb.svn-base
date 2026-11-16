#include "totvs.ch"


/*/{Protheus.doc} DHLIdFinder

Objeto para Busca de IDs de Produtos
	
@author Victor Hugo
@since 30/10/2014
/*/
class DHLIdFinder	
	
	data aIds
	data oSelectedId
	
	method newDHLIdFinder() constructor
	
	method getIds()
	method setIds()
	method getSelectedId()
	
	method show()
		
endClass


/*/{Protheus.doc} newDHLIdFinder

Construtor
	
@author Victor Hugo
@since 05/11/2014
/*/
method newDHLIdFinder(aIds, lLoaIds) class DHLIdFinder
	default := .t.
	
	if (ValType(aIds) == "A")
		::setIds(aIds)
	else
		if lLoaIds
			::setIds(getAllIds())
		endif
	endIf
	
return self

/**
 * Coleta todos os IDs da filial corrente
 */
static function getAllIds()
	
	local oId  := nil
	local aIds := {}
	local oSql := IpSqlObject():newIpSqlObject()
	
	oSql:newTable("SZ3", "*", "Z3_FILIAL = '%SZ3.FILIAL%'", nil, "Z3_FILIAL, Z3_ID, Z3_SEQUEN")
	
	while oSql:notIsEof()
		
		oId := DHLProductId():newDHLProductId(oSql:getValue("R_E_C_N_O_"))
		aAdd(aIds, oId)
		
		oSql:skip()
	endDo
	
	oSql:close()
	
return aIds


/*/{Protheus.doc} getIds

Coleta os IDs para Exibição
	
@author Victor Hugo
@since 05/11/2014

@return Array IDs para Exibição (lista de objetos DHLProductId)
/*/
method getIds() class DHLIdFinder
return ::aIds


/*/{Protheus.doc} setIds

Define os IDs para Exibição
	
@author Victor Hugo
@since 05/11/2014

@param aIds, Array, IDs para Exibição (lista de objetos DHLProductId)
/*/
method setIds(aIds) class DHLIdFinder
	::aIds := aClone(aIds)
return


/*/{Protheus.doc} getSelectedId

Coleta o ID selecionado
	
@author Victor Hugo
@since 05/11/2014

@return DHLProductId ID selecionado
/*/
method getSelectedId() class DHLIdFinder
return ::oSelectedId


/*/{Protheus.doc} show

Exibe a Tela de Busca de IDs
	
@author Victor Hugo
@since 05/11/2014

@return Logico Indica se o usuário selecionou algum ID
/*/
method show() class DHLIdFinder
	
	local lOk 		:= .F.
	local oDlg 		:= nil
	local oGrid		:= nil
	local oGetFilter:= nil
	local cFilter	:= Space(500)
	
	DEFINE MSDIALOG oDlg TITLE "Pesquisa de IDs de Produtos" FROM 001,001 TO 360,800 PIXEL OF oMainWnd								
		
		@ 005,006 MSGET oGetFilter VAR cFilter HASBUTTON SIZE 200,010 PIXEL OF oDlg
		@ 005,210 BUTTON "Filtrar" SIZE 35,12 ACTION {|| oGrid:filter(cFilter) } PIXEL OF oDlg
		@ 005,250 BUTTON "Limpar" SIZE 35,12 ACTION {|| oGrid:clearFilter() } PIXEL OF oDlg
		
		createGrid(self, @oGrid, oDlg)	
		
		@ 160,320 BUTTON "Ok" SIZE 35,12 ACTION {|| lOk := setSelectedId(@self, @oGrid, @oDlg) } PIXEL OF oDlg
		@ 160,360 BUTTON "Cancelar" SIZE 35,12 ACTION {|| oDlg:end() } PIXEL OF oDlg		
							
	ACTIVATE MSDIALOG oDlg CENTERED	
	
return lOk

/**
 * Criação do grid
 */
static function createGrid(oSelf, oGrid, oDlg)
	
	local nI		:= 0
	local nCol		:= 5
	local nRow		:= 25
	local nWidth	:= 400
	local nHeight	:= 150
	local oCol 		:= nil
	local oGrid		:= IpGridObject():newIpGridObject(nCol, nRow, nWidth, nHeight, oDlg)
	local aFields	:= {"Z3_ID","Z3_PRODUTO","Z3_DESC","Z3_DOC","Z3_SERIE","Z3_ITEM","Z3_SEQUEN","Z3_TPMOV","Z3_STATUS","Z3_CLIFOR","Z3_LOJA", "Z3_VUNIT", "Z3_VALICM", "Z3_VALIPI"} 		
	
	oGrid:setReadOnly(.T.)  
	oGrid:setMarkOne(.T.)
	oGrid:addMarkColumn()	
	
	for nI := 1 to Len(aFields)
		oGrid:addColumn(aFields[nI])
	next nI
	
	oGrid:addColumn(IpColumnObject():newIpColumnObject("RECNO", "Recno", "N", 6))
	
	fillGrid(oSelf, @oGrid)
	
	oGrid:create()
	
return

/**
 * Popula o grid
 */
static function fillGrid(oSelf, oGrid)
	
	local nI   := 0
	local oId  := nil
	local aIds := oSelf:getIds()
	
	for nI := 1 to Len(aIds)
		
		oId := aIds[nI]
		
		oGrid:newLine()
		oGrid:setMarkedLine(.F.)
		oGrid:setValue("Z3_ID", oId:getId())
		oGrid:setValue("Z3_PRODUTO", oId:getProduct())
		oGrid:setValue("Z3_DESC", oId:getDescription())
		oGrid:setValue("Z3_DOC", oId:getDocument())
		oGrid:setValue("Z3_SERIE", oId:getSeries())
		oGrid:setValue("Z3_ITEM", oId:getItem())
		oGrid:setValue("Z3_SEQUEN", oId:getSequence())
		oGrid:setValue("Z3_TPMOV", oId:getType())
		oGrid:setValue("Z3_STATUS", oId:getStatus())
		oGrid:setValue("Z3_CLIFOR", oId:getEntity())
		oGrid:setValue("Z3_LOJA", oId:getUnit())
		oGrid:setValue("Z3_VUNIT", oId:getUnitValue())
		oGrid:setValue("Z3_VALICM", oId:getIcmsValue())
		oGrid:setValue("Z3_VALIPI", oId:getIpiValue())
		oGrid:setValue("RECNO", oId:getRecno())
		
	next nI
	
return

/**
 * Coleta o ID selecionado
 */
static function setSelectedId(oSelf, oGrid, oDlg)
	
	local lOk    := .F.
	local nLine  := 0
	local nRecno := 0
	
	for nLine := 1 to oGrid:length()
		if oGrid:isMarkedLine(nLine)
			nRecno := oGrid:getValue("RECNO", nLine)
			exit
		endIf
	next nLine
	
	if (nRecno == 0)
		return .F.
	endIf	
	
	oSelf:oSelectedId := DHLProductId():newDHLProductId(nRecno)		
		
	SZ3->(dbGoTo(nRecno))		
		
	oDlg:end()
			
return .T.

