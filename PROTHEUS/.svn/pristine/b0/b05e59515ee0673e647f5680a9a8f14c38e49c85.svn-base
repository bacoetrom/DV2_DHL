#include 'protheus.ch'
#include 'dhl.ch'

/*/{Protheus.doc} User Function Di2VlExNFE
	Valida a exclusão do documento de entrada, caso ele esteja associado a um documento de saída automático.
	@type  Function
	@author Diogo Mesquita Gamba
	@since 21/02/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
user function Di2VlExNFE()
	
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cCliente 	:= ""
	local cLoja		:= ""
	local lRet		:= .t.
	
	GetCliLoja(@cCliente,@cLoja)
	
	oSql:newTable("SD1", "D1_DOC, D1_SERIE, D1_ITEM", retQrySD1())
	
	while oSql:notIsEof()
		
		if !LiberaExclusao(oSql:getValue("D1_DOC"), oSql:getValue("D1_SERIE"), cCliente, cLoja, oSql:getValue("D1_ITEM"))
			lRet := .f.
			exit
		endif
		
		oSql:skip()
	end
	oSql:close()

return (lRet)

/*
** Where para a tabela SD1 do documento de entrada que está sendo excluído
*/
static function retQrySD1()
	
	local cQuery := ""
	
	cQuery += "%SD1.XFILIAL% AND D1_DOC = '" + SF1->F1_DOC + "' AND D1_SERIE = '" + SF1->F1_SERIE + "' "
	cQuery += "AND D1_FORNECE = '" + SF1->F1_FORNECE + "' AND D1_LOJA = '" + SF1->F1_LOJA + "'

return (cQuery)

/*
** Obtém o cliente DHL do documento de saída automático
*/
static function GetCliLoja(cCliente,cLoja)
	
	local oSql	 := IpSqlObject():newIpSqlObject()
	local cQuery := ""

	cQuery += "%SA1.XFILIAL% AND A1_CGC = '"+SM0->M0_CGC+"' "

	oSql:newTable("SA1", "A1_COD COD, A1_LOJA LOJA" , cQuery)

	cCliente 	:= oSql:getValue("COD")
	cLoja 		:= oSql:getValue("LOJA")
	
	oSql:close()

return

/*
** Valida a exclusão do documento de entrada, caso ele esteja associado a um documento de saída automático
*/
static function LiberaExclusao(cDoc, cSerie, cCliente, cLoja, cItem)
	
	local oSql := IpSqlObject():newIpSqlObject()
	local cMsg := ""
	local lRet := .t.

	oSql:newTable("SD2", "D2_DOC, D2_SERIE, D2_EMISSAO", retQrySD2(cDoc, cSerie, cCliente, cLoja, cItem))
	if oSql:hasRecords()
		lRet := .f.
		cMsg := "Nota Fiscal não pode ser excluída/estornada. " + CRLF +;
				"Para realizar a exclusão/estorno, necessário excluir a NF de Saída Automática previamente!" + CRLF +;
				" Doc.: " + alltrim(oSql:getValue("D2_DOC"))+; 
				" Série:" + alltrim(oSql:getValue("D2_SERIE")) +; 
				" Data:"  + dtoc(stod(oSql:getValue("D2_EMISSAO"))) + ". "
		Aviso("Atenção",cMsg,{"OK"},3)
	endif
	
	oSql:close()
	
return lRet

/*
** Where para a tabela SD2 do documento de saída automático, associado ao documento de entrada que está sendo excluído
*/
static function retQrySD2(cDoc, cSerie, cCliente, cLoja, cItem)
	local cQuery := ""
	
	cQuery += "%SD2.XFILIAL% AND D2_ZZNFAUT = '" + cDoc + "' AND D2_ZZSEAUT = '" + cSerie + "' AND D2_ZZITAUT = '" + cItem + "'"
	cQuery += "AND D2_CLIENTE = '" + cCliente + "' AND D2_LOJA = '" + cLoja + "' "
	
return (cQuery)
