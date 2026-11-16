#Include 'Protheus.ch'
#include 'dhl.ch'

/*/{Protheus.doc} ExcVinculo

Exclui os vínculos de NF de cobertura

@author Renato Castro
@since 18/11/2014

/*/
User Function ExcVinculo()

	local oSql	:= IpSqlObject():newIpSqlObject()
	local cIdent := ""
	local nSaldo := 0
	local nRecnoSZ4 := 0
	local nPos := 0
	local aVinculos := {}

	if type("__aEstornos") == 'U'
		public __aEstornos := {}
	endif

	if funName() == "MATA103"//TODO remover esse comentário - MATA103 = tela do doc. entrada - usam o mesmo PE a MATA140 e MATA103
		if existBlock("EXC1PERNA")
			u_exc1Perna()
		endif
	endif

	oSql:newTable("SZ4", "Z4_IDCOB,Z4_QUANT,R_E_C_N_O_", "Z4_FILIAL='"+SD1->D1_FILIAL+"' AND Z4_DOC='"+SD1->D1_DOC+;
	"' AND Z4_SERIE='"+SD1->D1_SERIE+"' AND Z4_CLIFOR='"+SD1->D1_FORNECE+;
	"' AND Z4_LOJA='"+SD1->D1_LOJA+"' AND Z4_PRODUTO='"+SD1->D1_COD+;
	"' AND Z4_TIPMOV='2' ")

	while oSql:notIsEof()

		cIdent := oSql:getValue("Z4_IDCOB")
		nSaldo := oSql:getValue("Z4_QUANT")
		nRecnoSZ4 := oSql:getValue("R_E_C_N_O_")

		nPos := aScan(__aEstornos,{|x| x[1]+cValtoChar(x[2])+cValtoChar(x[3])==cIdent+cValToChar(nSaldo)+cValToChar(nRecnoSZ4)})
		»		if nPos == 0
		aadd(__aEstornos, {cIdent,nSaldo,nRecnoSZ4})
	endif

	//aVinculos := buscaVinc(cIdent)
	aVinculos := buscaVinc(cIdent,nSaldo)//Emerson Holanda - Ajuste na busca das notas vinculadas com mesmo id
	for nI := 1 to len(aVinculos)
		nPos := aScan(__aEstornos,{|x| x[1]+cValtoChar(x[2])+cValtoChar(x[3])==aVinculos[nI,1]+cValToChar(aVinculos[nI,2])+cValToChar(aVinculos[nI,3])})
		if nPos == 0
			aadd(__aEstornos, {aVinculos[nI,1],aVinculos[nI,2],aVinculos[nI,3]})
		endif
	next

	oSql:Skip()

	end

	oSql:close()

return


/**
* busca vínculos de 1.a perna
*/
static function buscaVinc(cIdent,nSaldo)

	local oSql	:= IpSqlObject():newIpSqlObject()
	local oSql2	:= IpSqlObject():newIpSqlObject()
	local oSql3	:= IpSqlObject():newIpSqlObject()
	local nPos 	:= 0
	local aVinculos := {}

	If FWUnitBusiness() == DHL_BUSINESSUNIT_AG2 //Emerson Holanda 12/06/2020 - Caso seja a SCJ, sera adicionado o filtro de quantidade.
		oSql:newTable("SZ4", "*", "%SZ4.XFILIAL% AND Z4_IDCOB='"+cIdent+"' AND Z4_QUANT='"+cValToChar(nSaldo)+"' AND Z4_TIPMOV='1' AND Z4_SALDO = 0")
	Else
		oSql:newTable("SZ4", "*", "%SZ4.XFILIAL% AND Z4_IDCOB='"+cIdent+"' AND Z4_TIPMOV='1' AND Z4_SALDO = 0")
	EndIf
	oSql3:newTable("SZ4", "*", "Z4_FILIAL='"+oSql:getValue("Z4_FILIAL")+"' AND Z4_DOC='"+oSql:getValue("Z4_DOC")+;
	"' AND Z4_SERIE='"+oSql:getValue("Z4_SERIE")+"' AND Z4_CLIFOR='"+oSql:getValue("Z4_CLIFOR")+;
	"' AND Z4_LOJA='"+oSql:getValue("Z4_LOJA")+"' AND Z4_TIPMOV='1' AND Z4_SALDO = 0")

	while oSql3:notIsEof()
		If FWUnitBusiness() == DHL_BUSINESSUNIT_AG2 //Emerson Holanda 12/06/2020 - Caso seja a SCJ, sera adicionado o filtro de quantidade.
			oSql2:newTable("SZ4", "*", "%SZ4.XFILIAL% AND Z4_IDCOB='"+oSql3:getValue("Z4_IDCOB")+"' AND Z4_QUANT='"+cValToChar(nSaldo)+"' AND Z4_TIPMOV='2' ")
		Else
			oSql2:newTable("SZ4", "*", "%SZ4.XFILIAL% AND Z4_IDCOB='"+oSql3:getValue("Z4_IDCOB")+"' AND Z4_TIPMOV='2' ")
		EndIf
		while oSql2:notIsEof()
			nPos := aScan(aVinculos,{|x| x[1]+cValtoChar(x[2])+cValtoChar(x[3])==oSql2:getValue("Z4_IDCOB")+cValtoChar(oSql2:getValue("Z4_QUANT"))+cValtoChar(oSql2:getValue("R_E_C_N_O_"))})
			if nPos == 0
				aadd(aVinculos, {oSql2:getValue("Z4_IDCOB"),oSql2:getValue("Z4_QUANT"),oSql2:getValue("R_E_C_N_O_")})
			endif
			oSql2:skip()
		end
		oSql3:skip()
	end

	oSql:close()
	oSql2:close()
	oSql3:close()

return(aVinculos)
