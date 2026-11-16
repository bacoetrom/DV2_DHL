#include 'totvs.ch'
#include 'safx52.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} DHLSafx52Age

Respons‡vel pelas regras e montagem das informacoees para a exportacao
	
@author Daniel Braga
@since 30/10/2014

/*/
user function _Safx52Age;return

class DHLSafx52Age from DHLSafx

	method newDHLSafx52Age () constructor
	method addLine()
	method getSql()
	method getSqlSB9()
	method notFieldRequired()
	method getDateDefault()
	method getSqlSb6()
	method getAglutB6()
	method getSldTerc()

endclass

/*/{Protheus.doc} newDHLSafx52Age

Construtor
	
@author Daniel Braga
@since 30/10/2014

/*/
method newDHLSafx52Age () class DHLSafx52Age

return

/*/{Protheus.doc} addLine

Cria a lina ‡ ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine(dDtInvent, lTerceiro, lContSB6) class DHLSafx52Age
	
	local lSPL			:= (FWUnitBusiness() == DHL_BUSINESSUNIT_SPL) 
	local lFormatZero 	:= .f.	
	local lPATerceiro	:= .f.	
	local cProduto 		:= ::getFieldValue("B2_COD")
	local cLocal   		:= if (empty(::getFieldValue("B2_LOCAL")), ::getFieldValue("B1_LOCPAD"),::getFieldValue("B2_LOCAL")) 
	local aSaldo   		:= {}
	local aProduct		:= {}
	local aSupCus		:= {}
	local nTerceiro		:= iif(lTerceiro, 0, ::getSldTerc(cProduto, dDtInvent))
	local nQuant   		:= iif(valtype(::getFieldValue("SALDO")) == "C", 0,::getFieldValue("SALDO")) - nTerceiro
	local nValorTot		:= iif(valtype(::getFieldValue("CUSTO")) == "C", 0,::getFieldValue("CUSTO"))
	local nCustoUnit 	:= nValorTot / nQuant
	local cCod 			:= ""
	local cBranch		:= ""
	
	if !lTerceiro
		lPATerceiro := isProdTerc(self)
		if lPATerceiro
			aSupCus := ::getSupCusRecords('2', ::getFieldValue("B1_ZZCDPRO"), ::getFieldValue("B1_ZZLJPRO"))
		endif
	endif
	
	default nSaldo := 0
	
	if lTerceiro
		nQuant 		:= ::getFieldValue("SALDO")
		nCustoUnit	:= (nValorTot / nQuant)
		aProduct 	:=	::getProduct(::getFieldValue("B2_COD"))
	else
		nValorTot	:=  nQuant * nCustoUnit 
	endif
	
	nSaldo := iif(nQuant < 0 , 0 , nQuant)
	if nSaldo == 0 .and. nTerceiro > 0
		lContSB6 := .t.
	endif

	::addField(COD_EMPRESA				, "SOL")
	::addField(COD_ESTAB				, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())))
	::addField(DATA_INVENTARIO			, dDtInvent)
	if !lTerceiro .and. lPATerceiro
		::addField(GRUPO_CONTAGEM			, '3')
	else
		::addField(GRUPO_CONTAGEM			, iif(lTerceiro,'3', '1'))
	endif
	::addField(COD_NBM					, iif(lTerceiro,::getFieldValue("B1_POSIPI",aProduct),::getFieldValue("B1_POSIPI")))
	::addField(IND_PRODUTO				, iif(lTerceiro,::getProdType(::getFieldValue("B1_TIPO",aProduct)),::getProdType(::getFieldValue("B1_TIPO"))))
	::addField(COD_PRODUTO				, ::getFieldValue("B2_COD"))
	::addField(COD_UND_PADRAO			, iif(lTerceiro,::getFieldValue("B1_UM",aProduct),::getFieldValue("B1_UM")))
	::addField(COD_ALMOX				, iif(lTerceiro,::getFieldValue("B1_LOCPAD",aProduct),::getFieldValue("B1_LOCPAD")))
	if !lTerceiro .and. lPATerceiro
		::addField(COD_NAT_ESTOQUE			, '03')
	else 
		::addField(COD_NAT_ESTOQUE			, iif(lTerceiro, '03', '02'))
	endif
	::addField(COD_MEDIDA				, iif(lTerceiro,::getFieldValue("B1_UM",aProduct),::getFieldValue("B1_UM")))
	::addField(QUANTIDADE				, nQuant, lFormatZero)
	::addField(VLR_TOT					, Round(nValorTot,2), lFormatZero)
	::addField(VLR_UNIT					, nCustoUnit, lFormatZero)
	::addField(COD_CONTA				, iif(lTerceiro,iif(alltrim(::getFieldValue("B1_ZZCONTA",aProduct)) == '.....', ' ', ::getFieldValue("B1_ZZCONTA",aProduct)),;
										  iif(alltrim(::getFieldValue("B1_ZZCONTA")) == '.....', ' ', ::getFieldValue("B1_ZZCONTA"))))
	if !lTerceiro .and. lPATerceiro
		::addField(IND_FIS_JUR				, ::getFieldValue("A1_ZZINDDW", aSupCus))
		::addField(COD_FIS_JUR				, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())) + ::getFieldValue("B1_ZZCDPRO") + ::getFieldValue("B1_ZZLJPRO"))
	else
		::addField(IND_FIS_JUR				, iif(lTerceiro, ::getFieldValue("ZZINDDW"),  '3'))
		::addField(COD_FIS_JUR				, iif(lTerceiro, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())) + ::getFieldValue("CLIFOR") + ::getFieldValue("LOJA"), SM0->M0_CGC))
	endif
	::addField(IND_PRODUTO_RASTRO		, ::getProdType(::getFieldValue("B1_TIPO")))
	::addField(COD_PRODUTO_RASTRO		, ::getFieldValue("B2_COD"))
	::addField(COD_SITUACAO_A			, iif(lTerceiro, ::getFieldValue("B1_ORIGEM",aProduct), ::getFieldValue("B1_ORIGEM")))
	::addField(COD_SITUACAO_B			, iif(lTerceiro, ::getFieldValue("B1_CLASFIS",aProduct), ::getFieldValue("B1_CLASFIS")))
	::addField(IND_MOT_INV				, "01")

	::notFieldRequired()

return


/*/{Protheus.doc} getSql

Instrucao SQL para exportacao
	
@author Daniel Braga
@since 30/10/2014

@return string instrucao sql
/*/
method getSql() class DHLSafx52Age
	
	local cQuery 		:= ""
local cprod		:= ""


	//cQuery:= "select sb2.*, sb1.*, (b2_qatu - b2_qtnp) saldo"
	cQuery:= "select sb2.*, sb1.*, (b2_qfim) saldo, b2_vfim1 custo"
	cQuery+= " from "+retSqlName("SB2")+" sb2 "
	cQuery+= "inner join "+retSqlName("SB1")+" sb1 on sb1.B1_COD = sb2.b2_cod and "
	cQuery+= "					 sb1.b1_filial = '"+xFilial("SB1")+"' and "
	cQuery+= "					 sb1.D_E_L_E_T_ = ' ' "	
	cQuery+= "where sb2.D_E_L_E_T_ = ' '  and sb2.b2_filial= '"+xFilial("SB2")+"' and sb2.b2_qfim > 0 "
//	cQuery+= " and sb2.b2_cod = '84147780' "

return Upper(cQuery)


/*/{Protheus.doc} getSqlSb6

Instrucao SQL para exportacao
	
@author Thiago Meschiatti
@since 04/02/2015

@return string instrucao sql
/*/
method getSqlSb6(cProduct, dDtInvent) class DHLSafx52Age
	
	local cQuery 		:= ""

	cQuery += " SELECT 	B6_FILIAL FILIAL, B6_PRODUTO PRODUTO, B6_CLIFOR CLIFOR, 				"+CRLF
	cQuery += " 		B6_LOJA LOJA, B6_TPCF TIPO, B2_VFIM1 CUSTO,                              "+CRLF
	cQuery += " 		SUM(CASE WHEN B6_PODER3 = 'R' THEN (B6_QUANT) ELSE  (-B6_QUANT) END) SALDO "+CRLF
	cQuery += " FROM %SB2.SQLNAME% 		                                                        "+CRLF
	cQuery += " INNER JOIN  %SB1.SQLNAME% ON SB1.B1_COD = SB2.B2_COD AND                        "+CRLF
	cQuery += " 	SB1.B1_FILIAL = SB2.B2_FILIAL AND                                     		"+CRLF
	cQuery += " 	SB1.D_E_L_E_T_ = ' '                                                        "+CRLF
	cQuery += " INNER JOIN 	%SB6.SQLNAME% ON SB1.B1_COD = SB6.B6_PRODUTO               		    "+CRLF
	cQuery += " 	AND SB6.B6_FILIAL = SB1.B1_FILIAL                                			"+CRLF
	cQuery += "		AND SB6.B6_DTDIGIT >= '20000101' 											"+CRLF
	cQuery += "		AND SB6.B6_DTDIGIT <= '"+Dtos(dDtInvent)+"' 								"+CRLF
	cQuery += " 	AND SB6.D_E_L_E_T_ = ' '                                                    "+CRLF
	cQuery += " WHERE                                                                           "+CRLF
	cQuery += " 	SB2.D_E_L_E_T_ = ' '                                                        "+CRLF
	cQuery += " 	AND %SB2.XFILIAL%	 				                                   		"+CRLF
	cQuery += " 	AND SB2.B2_COD = '"+cProduct+"'                                         	"+CRLF
	cQuery += " GROUP BY                                                                        "+CRLF
	//VALIDAR SALDO
	cQuery += " 	B6_FILIAL, B6_PRODUTO, B6_CLIFOR,	B6_LOJA, B6_TPCF, B2_VFIM1              "+CRLF

return cQuery


/*/{Protheus.doc} getAglutB6

Instrucao SQL para exportacao
	
@author Thiago Meschiatti
@since 04/02/2015

@return string instrucao sql
/*/
method getAglutB6(cProduct, cType, dDtInvent, cEntity, cUnit) class DHLSafx52Age
	local cQuery 	:= ""
	local cField	:= ""
	local cGroup	:= ""
	
	if cType $ SAFX52_CLIENTE
		cField := " A1_ZZINDDW ZZINDDW,"
		cGroup := " A1_ZZINDDW," 
	else
		cField := " A2_ZZINDDW ZZINDDW," 
		cGroup := " A2_ZZINDDW,"
	endif
	
	cQuery += " SELECT 	B6_FILIAL FILIAL, B6_PRODUTO PRODUTO, B6_CLIFOR CLIFOR, B6_LOJA LOJA, B6_TPCF, "+CRLF
	cQuery += " 	SUM(CASE WHEN B6_PODER3 = 'R' THEN (B6_QUANT) ELSE  (-B6_QUANT) END) SALDO, "+CRLF
	cQuery += " 	SUM(CASE WHEN B6_PODER3 = 'R' THEN (B6_CUSTO1) ELSE  (-B6_CUSTO1) END) CUSTO, "+CRLF
	cQuery += cField	
	cQuery += " 		B1_EX_NBM,B2_COD,B1_UM,B1_LOCPAD,B1_TIPO,B1_UM,B1_ZZCONTA,B1_ORIGEM,B1_CLASFIS		        		"+CRLF
	cQuery += " FROM SB2100 SB2                                                                                             "+CRLF
	cQuery += " INNER JOIN  %SB1.SQLNAME% ON SB1.B1_COD = SB2.B2_COD AND                                                    "+CRLF
	cQuery += " 	SB1.B1_FILIAL = SB2.B2_FILIAL AND                                                                       "+CRLF
	cQuery += " 	SB1.D_E_L_E_T_ = ' '                                                                                    "+CRLF
	cQuery += " INNER JOIN 	%SB6.SQLNAME% ON SB1.B1_COD = SB6.B6_PRODUTO                                                    "+CRLF
	cQuery += " 	AND SB6.B6_FILIAL = SB1.B1_FILIAL	                                                                    "+CRLF
	cQuery += " 	AND SB6.B6_CLIFOR	= '" + cEntity + "'                                                                 "+CRLF
	cQuery += " 	AND SB6.B6_LOJA 	= '" + cUnit + "'                                                                   "+CRLF	
	cQuery += "		AND SB6.B6_DTDIGIT >= '20000101' 																		"+CRLF
	cQuery += "		AND SB6.B6_DTDIGIT <= '"+Dtos(dDtInvent)+"' 															"+CRLF
	cQuery += "             AND SB6.B6_TPCF = '" + cType + "' " + CRLF //JJ
	cQuery += " 	AND SB6.D_E_L_E_T_ = ' '                                                                                "+CRLF
	if cType $ SAFX52_CLIENTE
		cQuery += " INNER JOIN %SA1.SQLNAME% ON SA1.A1_COD = SB6.B6_CLIFOR                                                  "+CRLF
		cQuery += " 	AND SA1.A1_LOJA = SB6.B6_LOJA                                                                       "+CRLF
		cQuery += " 	AND SA1.A1_FILIAL = SB6.B6_FILIAL 	                                                                "+CRLF
		cQuery += " 	AND SA1.D_E_L_E_T_ = ' '                                                                            "+CRLF
	else
		cQuery += " INNER JOIN %SA2.SQLNAME% ON SA2.A2_COD = SB6.B6_CLIFOR                                                  "+CRLF
		cQuery += " 	AND SA2.A2_LOJA = SB6.B6_LOJA                                                                       "+CRLF
		cQuery += " 	AND SA2.A2_FILIAL = SB6.B6_FILIAL 	                                                                "+CRLF
		cQuery += " 	AND SA2.D_E_L_E_T_ = ' '                                                                            "+CRLF
	endif
	cQuery += " WHERE                                                                                                       "+CRLF
	cQuery += " 	SB2.D_E_L_E_T_ = ' '                                                                                    "+CRLF
	cQuery += " 	AND %SB2.XFILIAL%	 				                                   									"+CRLF
	cQuery += " 	AND SB2.B2_COD = '"+cProduct+"'                                                                        	"+CRLF
	cQuery += " GROUP BY                                                                                                    "+CRLF
	cQuery += " 	B6_FILIAL, B6_PRODUTO, B6_CLIFOR, B6_LOJA, B6_TPCF, 		                                            "+CRLF
	cQuery += cGroup
	cQuery += " 	B1_EX_NBM,B2_COD,B1_UM,B1_LOCPAD,B1_TIPO,B1_UM,B1_ZZCONTA,B1_ORIGEM,B1_CLASFIS                  		"+CRLF
	
return(cQuery)


/*/{Protheus.doc} getSldTerc

Instrucao SQL para exportacao
	
@author Thiago Meschiatti
@since 04/02/2015

@return string instrucao sql
/*/
method getSldTerc(cProduct, dDtInvent) class DHLSafx52Age
	local cQuery 	:= ""
	local oSql	 	:= IpSqlObject():newIpSqlObject()
	local nSldTerc	:= 0
	
	cQuery += " SELECT 	SUM(CASE WHEN B6_PODER3 = 'R' THEN (B6_QUANT) ELSE  (-B6_QUANT) END) SALDO                       	"+CRLF             
	cQuery += " FROM %SB6.SQLNAME%                                  "+CRLF
	cQuery += " WHERE                                              	"+CRLF
	cQuery += "     %SB6.XFILIAL%                                 	"+CRLF
	cQuery += " 	AND SB6.B6_PRODUTO = '"+cProduct+"'             "+CRLF
	cQuery += " 	AND SB6.B6_DTDIGIT >= '20000101' 	           	"+CRLF
	cQuery += " 	AND SB6.B6_DTDIGIT <= '" + dtos(dDtInvent) + "' "+CRLF
	cQuery += " 	AND SB6.D_E_L_E_T_ = ' '                       	"+CRLF
	
	oSql:newAlias(cQuery)
	
	if oSql:hasRecords()
		nSldTerc := oSql:getValue("SALDO")
	endif
	
	oSql:close()
return (nSldTerc)



/*/{Protheus.doc} notFieldRequired

Campos que não precisa passar valor
	
@author Daniel Braga
@since 13/11/2014

/*/
method notFieldRequired()  class DHLSafx52Age

	::addField(COD_CUSTO, ' ')
	::addField(OBSERVACAO, ' ')
	::addField(VLR_ICMS, ' ')
	::addField(IND_DEB_CRE, ' ')
	::addField(DESCRICAO_RIPI, ' ')
	::addField(VLR_ICMS_MEDIO, ' ')
	::addField(VLR_ICMSS_MEDIO, ' ')
	::addField(INSC_ESTADUAL, ' ')
	::addField(VLR_BASE_ICMS, ' ')
	::addField(VLR_BASE_ISENTO, ' ')
	::addField(VLR_BASE_OUTRAS, ' ')
	::addField(VLR_BASE_ICMSS, ' ')
	::addField(COD_OBSERVACAO, ' ')
	::addField(VLR_CUSTO_DCA, ' ')
	::addField(VLR_IPI, ' ')
	::addField(VLR_PIS, ' ')
	::addField(VLR_COFINS, ' ')
	::addField(VLR_TRIB_NC, ' ')

return

/*/{Protheus.doc} getDateDefault

Coleta a Data Padrão da Interface
	
@author Victor Hugo
@since 11/12/2014

@return Data Data padrão da interface
/*/
method getDateDefault() class DHLSafx52Age

return (FirstDay(Date()) - 1)


/*
** Verifica Produtos que sao produzido pela DHL que pertecem a Unilever.
*/
static function isProdTerc(oSelf)
	local lRet := .f.
	
	if alltrim(oSelf:getFieldValue("B1_TIPO")) == "PA" .and. right(alltrim(oSelf:getFieldValue("B1_GRUPO")), 1) == "U"
		if !empty(oSelf:getFieldValue("B1_ZZCDPRO")) .and. !empty(oSelf:getFieldValue("B1_ZZLJPRO"))
			lRet := .t.
		endif
	endif
return (lRet)

/*/{Protheus.doc} getSqlSB9
Query que retornará os registros aptos para geração de instrução SQL para exportacao conforme
saldo do momento do encerramento do estoque do referido ano/mes

@author Icaro Queiroz
@since 25 de agosto de 2017

@return String instrucao sql
/*/
Method getSqlSB9( dDtInvent ) class DHLSafx52Age
Local __cQuery		:= ""
local cprod		:= ""



Default dDtInvent	:= dDataBase

__cQuery := " SELECT DISTINCT B9_COD B2_COD, B1_ZZCDPRO, B1_ZZLJPRO, B1_POSIPI, B1_TIPO, B1_UM, B1_ZZCONTA, B1_ORIGEM, B1_CLASFIS, B1_GRUPO, B1_LOCPAD, '01' B2_LOCAL, "
__cQuery += " SUM(B9_QINI) SALDO, SUM(B9_VINI1) CUSTO "
__cQuery += "  FROM " + RetSqlName( "SB9" ) + " SB9"
__cQuery += " INNER JOIN " + RetSqlName( "SB1" ) + " SB1 ON B1_FILIAL = B9_FILIAL AND SB1.D_E_L_E_T_ = ' ' AND B1_COD = B9_COD"
__cQuery += " WHERE B9_FILIAL = '" + xFilial( "SB9" ) + "' "
__cQuery += "  AND SB9.D_E_L_E_T_ = ' '"
__cQuery += "   AND B9_DATA = '" + dTOs( dDtInvent ) + "'"
__cQuery += "   AND B9_QINI <> 0 "
__cQuery += " GROUP BY B9_COD, B1_ZZCDPRO, B1_ZZLJPRO, B1_POSIPI, B1_TIPO, B1_UM, B1_ZZCONTA, B1_ORIGEM, B1_CLASFIS, B1_GRUPO, B1_LOCPAD"
__cQuery += " ORDER BY B9_COD "

Return( __cQuery )
