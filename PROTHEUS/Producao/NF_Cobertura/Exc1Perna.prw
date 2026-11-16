#Include 'Protheus.ch'

/*/{Protheus.doc} Exc1Perna

Exclui vínculos de 1.a perna
	
@author Renato Castro
@since 18/11/2014

/*/
User Function Exc1Perna()

	local oSql	:= IpSqlObject():newIpSqlObject()

	oSql:update("SZ4","D_E_L_E_T_ = '*'","Z4_FILIAL='"+SD1->D1_FILIAL+"' AND Z4_DOC='"+SD1->D1_DOC+;
		"' AND Z4_SERIE='"+SD1->D1_SERIE+"' AND Z4_CLIFOR='"+SD1->D1_FORNECE+;
		"' AND Z4_LOJA='"+SD1->D1_LOJA+"' AND Z4_PRODUTO='"+SD1->D1_COD+;
		"' AND Z4_ITEM='"+SD1->D1_ITEM+"' AND Z4_TIPMOV = '1' AND Z4_SALDO <> 0")

Return

