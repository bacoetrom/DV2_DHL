#include 'protheus.ch'
#include 'dhl.ch'

/*/{Protheus.doc} ValidIncPO
Função para validar PO do Pedido de Compra inserido via tela. 
Exlcuindo o existente caso exista
@author Thiago Meschiatti
@since 12/09/2016
@version undefined

@type function
/*/
user function ValidIncPO()
	local lRotAuto 	:= l120Auto
	local lOk		:= .t.
	local nSavNF	:= 0
	
	private cPONumber  	:= retPONum()
	private aDetails    := {}
	private lExistPO	:= existPO()
	private lMsErroAuto := .F.

	if !lRotAuto
		BEGIN TRANSACTION
			if lExistPO
				nSavNF := MaFisSave()
				MaFisEnd()
					
				lOk := delPurchaseOrd()
				
				MaFisRestore(nSavNF)
			endif
		END TRANSACTION
	endif
 
return (lOk)

/*
** Verifica se existe Pedido de Compra no Protheus para PO do Cliente
*/
static function existPO()
	local oSql	:= IpSqlObject():newIpSqlObject()
	local lRet	:= .f.

	oSql:newTable("SC7", "C7_NUM",	"%SC7.XFILIAL% AND C7_ZZPOEXT = '" + cPONumber + "' ")

	if oSql:hasRecords()
		lRet := .t.
	endif

	oSql:close()
return (lRet)

/**
* Inclui o Pedido de Compras
**/
static function delPurchaseOrd()

	local oSqlDel	:= IpSqlObject():newIpSqlObject()
	local aArea		:= GetArea()
	local aAreaSC7	:= SC7->(GetArea())
	local aHeader	:= {}
	local lOk		:= .t.
	local cQuery	:= "%SC7.XFILIAL% AND C7_ZZPOEXT = '" + cPONumber + "' "

	lOk := validPO()

	if lOk
		oSqlDel:newTable("SC7", "*", cQuery)

		aadd(aHeader,{"C7_FILIAL"  , oSqlDel:getValue("C7_FILIAL")})
		aadd(aHeader,{"C7_NUM"     , oSqlDel:getValue("C7_NUM")})
		aadd(aHeader,{"C7_EMISSAO" , oSqlDel:getValue("C7_EMISSAO")})
		aadd(aHeader,{"C7_FORNECE" , oSqlDel:getValue("C7_FORNECE")})
		aadd(aHeader,{"C7_LOJA"    , oSqlDel:getValue("C7_LOJA")})
		aadd(aHeader,{"C7_COND"    , oSqlDel:getValue("C7_COND")})
		aadd(aHeader,{"C7_CONTATO" , oSqlDel:getValue("C7_CONTATO")})
		aadd(aHeader,{"C7_FILENT"  , oSqlDel:getValue("C7_FILENT")})

		lOk := mountDetail(.t., oSqlDel)

		if lOk
			oSqlDel:goTop()
			dbSelectArea("SC7")
			SC7->(dbSetOrder(1))
			if SC7->(dbSeek(oSqlDel:getValue("C7_FILIAL") + oSqlDel:getValue("C7_NUM")))
				if Aviso( "Atualização de Pedido de Compra", retMsg(oSqlDel) , { "Sim", "Não" }, 3, "Pedido de Compra" ) == 1
					nModulo := 2
					MSExecAuto({|x,y,w,z| MATA120(x,y,w,z)},1,aHeader,aDetails,5)
		
					if lMsErroAuto
						lOk := .f.
						DisarmTransaction()
						Aviso( 	"Não foi possível Incluir Pedido de Compra",;
								"Falha ao excluir o pedido de compras relacionado com a PO: " + cPONumber + ". "+CRLF+CRLF+oUtils:getErroAuto(),;
								{ "Ok" }, 3, "Pedido de Compra" )
					endIf
				else
					lOk := .f.
				endif
			else
				lOk := .f.
				Aviso( 	"Não foi possível Incluir Pedido de Compra",;
						"Falha ao localizar o pedido de compras relacionado com a PO: " + cPONumber, { "Ok" }, 3, "Pedido de Compra" )
			endif
		endif
	endif
	
	RestArea(aAreaSC7)
	RestArea(aArea)
	
return (lOk)


/**
* Monta os Itens do Pedido de Compras
**/
static function mountDetail(lDel, oSql)

	local nI		 := 0
	local nUnitPrice := 0
	local nQuantity  := 0
	local cProduct   := ""
	local cQuery	 := ""
	local cUm		 := ""
	local cPrice	 := ""
	local cOperation := ""
	local lErro		 := .f.
	local aAux		 := {}

	default lDel := .f.

	aDetails := {}

	if lDel
		while oSql:notIsEof()
			aAux := {}

			aAdd(aAux,{"C7_PRODUTO"	, oSql:getValue("C7_PRODUTO")	,nil})
			aAdd(aAux,{"C7_QUANT"	, oSql:getValue("C7_QUANT")		,nil})
			aAdd(aAux,{"C7_UM" 		, oSql:getValue("C7_UM") 		,nil})
			aAdd(aAux,{"C7_PRECO" 	, oSql:getValue("C7_PRECO") 	,nil})
			aAdd(aAux,{"C7_TOTAL"   , oSql:getValue("C7_TOTAL")  	,nil})
			aAdd(aAux,{"C7_ZZPOEXT" , oSql:getValue("C7_ZZPOEXT")	,nil})
			aAdd(aAux,{"C7_ZZAUTO"  , oSql:getValue("C7_ZZAUTO") 	,nil})
			aadd(aAux,{"C7_REC_WT"  , oSql:getValue("R_E_C_N_O_")   ,Nil})

			aAdd(aDetails,aAux)
			oSql:skip()
		end
		if empty(aDetails)
			lErro := .t.
		endif
	endif

return !(lErro)


/*
** Valida se PC possuí movimentação
*/
static function validPO()
	local oSql		:= IpSqlObject():newIpSqlObject()
	local lOk	 	:= .t.
	local cQuery	:= ""
	
	cQuery += " SELECT D1_DOC " 
	cQuery += " FROM %SC7.SQLNAME% "
	cQuery += " INNER JOIN %SD1.SQLNAME% ON "
	cQuery += "		D1_FILIAL 		= C7_FILIAL " 
	cQuery += "		AND D1_PEDIDO 	= C7_NUM "
	cQuery += "		AND %SD1.XFILIAL% "
	cQuery += "		AND %SD1.NOTDEL% "
	cQuery += " WHERE "
	cQuery += " 	C7_ZZPOEXT = '"+cPONumber+"' "
	cQuery += "		AND %SC7.XFILIAL% "
	cQuery += "		AND %SC7.NOTDEL% "

	oSql:newAlias(cQuery)
	
	if oSql:hasRecords()
		Aviso( "Falha ao Incluir Pedido de Compra",;
		 	   "Pedido de Compra com Purchase Order: " + cPONumber + " já possuí movimentações no Protheus." ,;
		 	    { "Ok" }, 3, "Pedido de Compra" )
		 	    
		lOk := .f.
	endif
	
	oSql:close()
	
return (lOk)


/*
** Retorna numero da PO da primeira linha valida
*/ 
static function retPONum()
	local nI 		:= 0
	local cPONum	:= ""
	
	for nI := 1 to len(aCols)
		if !gdDeleted()
			cPONum := alltrim(GdFieldGet("C7_ZZPOEXT",nI))
			if !empty(cPONum)
				exit
			endif
		endif
	next nI
	
return (cPONum)


/*
** Retorna Mensagem de pergunta
*/
static function retMsg(oSqlDel)
	local cRet := ""
	
	cRet := "Já existe um pedido de compra ("+oSqlDel:getValue("C7_NUM")+") utilizando a PO informada. Deseja excluí-lo e continuar a geração da atual?"
	
return (cRet)