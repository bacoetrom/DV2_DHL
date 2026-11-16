#include 'totvs.ch'
#include 'safx52.ch'
#include 'safx.ch'
#include 'dhl.ch'

/*/{Protheus.doc} DHLSafx52Ag2

Respons‡vel pelas regras e montagem das informacoees para a exportacao
	
@author Thiago Meschiatti
@since 24/07/2017

/*/
user function _52Ag2Safx;return

class DHLSafx52Ag2 from DHLSafx

	method newDHLSafx52Ag2 () constructor
	method addLine()
	method getSql()
	method getSqlSB9()
	method notFieldRequired()
	method getDateDefault()
	method getSqlSb6()
	method getAglutB6()
	method getSldTerc()

endclass


//-----------------------------------------------------------------
method newDHLSafx52Ag2 () class DHLSafx52Ag2

return

/*/{Protheus.doc} addLine

Cria a lina ‡ ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/
method addLine(dDtInvent, lTerceiro, lContSB6, nSldTerc) class DHLSafx52Ag2
	
	local lSPL			:= (FWUnitBusiness() == DHL_BUSINESSUNIT_SPL) 
	local lFormatZero 	:= .f.	
	local lPATerceiro	:= .f.	
	local cProduto 		:= ::getFieldValue("B9_COD")
	local cLocal   		:= if (empty(::getFieldValue("B9_LOCAL")), ::getFieldValue("B1_LOCPAD"),::getFieldValue("B9_LOCAL")) 
	local aSaldo   		:= {}
	local aProduct		:= {}
	local aSupCus		:= {}
	local nTerceiro		:= iif(lTerceiro, 0, nSldTerc)
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
		::addField(GRUPO_CONTAGEM			, iif(.T.,'3', '1'))
	endif
	::addField(COD_NBM					, iif(lTerceiro,::getFieldValue("B1_POSIPI",aProduct),::getFieldValue("B1_POSIPI")))
	::addField(IND_PRODUTO				, iif(lTerceiro,::getProdType(::getFieldValue("B1_TIPO",aProduct)),::getProdType(::getFieldValue("B1_TIPO"))))
	::addField(COD_PRODUTO				, ::getFieldValue("B9_COD"))
	::addField(COD_UND_PADRAO			, iif(lTerceiro,::getFieldValue("B1_UM",aProduct),::getFieldValue("B1_UM")))
	::addField(COD_ALMOX				, iif(lTerceiro,::getFieldValue("B1_LOCPAD",aProduct),::getFieldValue("B1_LOCPAD")))
	if !lTerceiro .and. lPATerceiro
		::addField(COD_NAT_ESTOQUE			, '03')
	else 
		::addField(COD_NAT_ESTOQUE			, iif(.T., '03', '02'))
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
		::addField(IND_FIS_JUR				, iif(.T., '2',  '3'))
		lTerceiro := .T.		
		::addField(COD_FIS_JUR				, iif(lTerceiro, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())) + getDepositante(cProduto), SM0->M0_CGC))
		lTerceiro := .F.
	endif
	::addField(IND_PRODUTO_RASTRO		, ::getProdType(::getFieldValue("B1_TIPO")))
	::addField(COD_PRODUTO_RASTRO		, cProduto)
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
method getSql() class DHLSafx52Ag2
	
	local cQuery 		:= ""

	//cQuery:= "select sb2.*, sb1.*, (b2_qatu - b2_qtnp) saldo"
	cQuery:= "select sb2.*, sb1.*, (b2_qfim) saldo, b2_vfim1 custo"
	cQuery+= " from "+retSqlName("SB2")+" sb2 "
	cQuery+= "inner join "+retSqlName("SB1")+" sb1 on sb1.B1_COD = sb2.b2_cod and "
	cQuery+= "					 sb1.b1_filial = '"+xFilial("SB1")+"' and "
	cQuery+= "					 sb1.D_E_L_E_T_ = ' ' "	
	cQuery+= "where sb2.D_E_L_E_T_ = ' '  and sb2.b2_filial= '"+xFilial("SB2")+"' and sb2.b2_qfim > 0 "
//	cQuery+= " and sb2.b2_cod = '88701' "

return Upper(cQuery)


/*/{Protheus.doc} getSqlSb6

Instrucao SQL para exportacao
	
@author Thiago Meschiatti
@since 04/02/2015

@return string instrucao sql
/*/
method getSqlSb6(cProduct, dDtInvent) class DHLSafx52Ag2
	
	local cQuery 		:= ""

//	cQuery += "	SELECT " + CRLF
//	cQuery += " 		FILIAL, " + CRLF
//	cQuery += " 		PRODUTO, " + CRLF
//	cQuery += "		CLIFOR, " + CRLF
//	cQuery += " 		LOJA, " + CRLF
//	cQuery += " 		TIPO, " + CRLF
//	cQuery += " 		SUM(CUSTO) CUSTO, " + CRLF
//	cQuery += " 		SUM(SALDO) SALDO " + CRLF
//	cQuery += " 	FROM " + CRLF
// 	cQuery += " 	( " + CRLF
// 	cQuery += " 		SELECT " + CRLF	
//	cQuery += " 			B6_FILIAL FILIAL, " + CRLF
//	cQuery += " 			B6_PRODUTO PRODUTO, " + CRLF
//	cQuery += " 			B6_CLIFOR CLIFOR, " + CRLF				
// 	cQuery += " 			B6_LOJA LOJA, " + CRLF 
//	cQuery += " 			B6_TPCF TIPO, " + CRLF 
//	cQuery += " 			SUM(B6_CUSTO1) CUSTO, " + CRLF                              
// 	cQuery += " 			SUM(B6_QUANT) SALDO " + CRLF
// 
// 	cQuery += "  		FROM %SB2.SQLNAME% " + CRLF       
//	
//	cQuery += "  		INNER JOIN %SB1.SQLNAME% ON " + CRLF       	
// 	cQuery += "  					1 = 1 " + CRLF 
//	cQuery += "			AND		SB1.B1_FILIAL = SB2.B2_FILIAL " + CRLF		
// 	cQuery += "			AND		SB1.B1_COD = SB2.B2_COD " + CRLF		
// 	cQuery += "  			AND 	%SB1.NOTDEL% " + CRLF 		                       	
// 
// 	cQuery += "  		INNER JOIN %SB6.SQLNAME% ON " + CRLF       	
// 	cQuery += "  					1 = 1 " + CRLF 
//	cQuery += "			AND		SB6.B6_FILIAL = SB1.B1_FILIAL " + CRLF		
// 	cQuery += "			AND		SB6.B6_PRODUTO = SB1.B1_COD " + CRLF		
// 	cQuery += "  			AND 	%SB6.NOTDEL% " + CRLF 		                       	
// 
// 	cQuery += "  		INNER JOIN %SF1.SQLNAME% ON " + CRLF       	            	
//	cQuery += "  					1 = 1 " + CRLF 
//	cQuery += "  			AND 	SF1.F1_FILIAL	= SB6.B6_FILIAL " + CRLF 				
//	cQuery += "  			AND 	SF1.F1_DOC 	= SB6.B6_DOC " + CRLF 					
//	cQuery += "  			AND 	SF1.F1_SERIE	= SB6.B6_SERIE " + CRLF 				
//	cQuery += " 			AND 	SF1.F1_DTDIGIT >= '20000101' 	           	"+CRLF
//	cQuery += " 			AND 	SF1.F1_DTDIGIT <= '" + dtos(dDtInvent) + "' 	"+CRLF
//	cQuery += "  			AND 	%SF1.NOTDEL% " + CRLF 		                       	
//	 
//	cQuery += "  		WHERE " + CRLF                        	                 	
//	cQuery += "   				%SB2.XFILIAL% " + CRLF                                 	
//	cQuery += " 			AND 	SB2.B2_COD = '"+cProduct+"'             	"+CRLF
//	cQuery += "  			AND 	%SB2.NOTDEL% " + CRLF    
//	
// 	cQuery += "		GROUP BY " + CRLF	
// 	cQuery += "			B6_FILIAL, " + CRLF
// 	cQuery += "			B6_PRODUTO, " + CRLF
// 	cQuery += "			B6_CLIFOR, " + CRLF
// 	cQuery += "			B6_LOJA, " + CRLF
// 	cQuery += "			B6_TPCF " + CRLF
//
//	cQuery += "		UNION ALL " + CRLF
//
//	cQuery += " 		SELECT " + CRLF	
//	cQuery += " 			B6_FILIAL FILIAL, " + CRLF
//	cQuery += " 			B6_PRODUTO PRODUTO, " + CRLF
//	cQuery += " 			B6_CLIFOR CLIFOR, " + CRLF				
// 	cQuery += " 			B6_LOJA LOJA, " + CRLF 
//	cQuery += " 			B6_TPCF TIPO, " + CRLF 
//	cQuery += " 			SUM(-B6_CUSTO1) CUSTO, " + CRLF                              
// 	cQuery += " 			SUM(-B6_QUANT) SALDO " + CRLF
// 
// 	cQuery += "  		FROM %SB2.SQLNAME% " + CRLF       
//	
//	cQuery += "  		INNER JOIN %SB1.SQLNAME% ON " + CRLF       	
// 	cQuery += "  					1 = 1 " + CRLF 
//	cQuery += "			AND		SB1.B1_FILIAL = SB2.B2_FILIAL " + CRLF		
// 	cQuery += "			AND		SB1.B1_COD = SB2.B2_COD " + CRLF		
// 	cQuery += "  			AND 	%SB1.NOTDEL% " + CRLF 		                       	
// 
// 	cQuery += "  		INNER JOIN %SB6.SQLNAME% ON " + CRLF       	
// 	cQuery += "  					1 = 1 " + CRLF 
//	cQuery += "			AND		SB6.B6_FILIAL = SB1.B1_FILIAL " + CRLF		
// 	cQuery += "			AND		SB6.B6_PRODUTO = SB1.B1_COD " + CRLF		
// 	cQuery += "  			AND 	%SB6.NOTDEL% " + CRLF 		                       	
// 
//	cQuery += "  		INNER JOIN %SF2.SQLNAME% ON " + CRLF       	            	
//	cQuery += "  					1 = 1 " + CRLF 
//	cQuery += "			AND 	SF2.F2_FILIAL	= SB6.B6_FILIAL " + CRLF 				
//	cQuery += "  			AND 	SF2.F2_DOC 	= SB6.B6_DOC " + CRLF 					
//	cQuery += "  			AND 	SF2.F2_SERIE	= SB6.B6_SERIE " + CRLF 				
//	cQuery += " 			AND 	SF2.F2_EMISSAO >= '20000101' 	           	"+CRLF //EMINFE //JJ
//	cQuery += " 			AND 	SF2.F2_EMISSAO <= '" + dtos(dDtInvent) + "' 	"+CRLF //EMINFE
//	cQuery += "  			AND 	%SF2.NOTDEL% " + CRLF 		                       	
// 
//	cQuery += "  		WHERE " + CRLF                        	                 	
//	cQuery += "      				%SB2.XFILIAL% " + CRLF                                 	
//	cQuery += " 			AND 	SB2.B2_COD = '"+cProduct+"'             	"+CRLF
//	cQuery += " 			AND 	%SB2.NOTDEL% "+CRLF
//	
//	cQuery += "		GROUP BY " + CRLF	
// 	cQuery += "			B6_FILIAL, " + CRLF
// 	cQuery += "			B6_PRODUTO, " + CRLF
// 	cQuery += "			B6_CLIFOR, " + CRLF
// 	cQuery += "			B6_LOJA, " + CRLF
// 	cQuery += "			B6_TPCF " + CRLF
//	cQuery += " 	) " + CRLF
//
//	cQuery += " 	GROUP BY " + CRLF                                                                   	
// 	cQuery += " 		FILIAL, " + CRLF
//	cQuery += " 		PRODUTO, " + CRLF
//	cQuery += " 		CLIFOR, " + CRLF
//	cQuery += " 		LOJA, " + CRLF
//	cQuery += " 		TIPO" + CRLF     

	cQuery := ""
	cQuery += " SELECT 	B6_FILIAL FILIAL, B6_PRODUTO PRODUTO, B6_CLIFOR CLIFOR, 				"+CRLF
	cQuery += " 		B6_LOJA LOJA, B6_TPCF TIPO, " + CRLF //B2_VFIM1 CUSTO,                              "+CRLF
	cQuery += " 		SUM(CASE WHEN B6_PODER3 = 'R' THEN (B6_QUANT) ELSE  (-B6_QUANT) END) SALDO ,"+CRLF
	cQuery += " 		SUM(CASE WHEN B6_PODER3 = 'R' THEN (B6_CUSTO1) ELSE  (-B6_CUSTO1) END) CUSTO "+CRLF
	cQuery += " FROM %SB2.SQLNAME% 		                                                        "+CRLF
	cQuery += " INNER JOIN  %SB1.SQLNAME% ON SB1.B1_COD = SB2.B2_COD AND                        "+CRLF
	cQuery += " 	SB1.B1_FILIAL = SB2.B2_FILIAL AND                                     		"+CRLF
	cQuery += " 	SB1.D_E_L_E_T_ = ' '                                                        "+CRLF
	cQuery += " INNER JOIN 	%SB6.SQLNAME% ON SB1.B1_COD = SB6.B6_PRODUTO               		    "+CRLF
	cQuery += " 	AND SB6.B6_FILIAL = SB1.B1_FILIAL                                			"+CRLF
	cQuery += "		AND SB6.B6_DTDIGIT >= '20000101' 											"+CRLF
	cQuery += "		AND SB6.B6_DTDIGIT <= '"+Dtos(dDtInvent)+"' 								"+CRLF
	cQuery += "     AND SB6.B6_LOCAL = SB2.B2_LOCAL "+CRLF //JJ 2018/08/18
	cQuery += " 	AND SB6.D_E_L_E_T_ = ' '                                                    "+CRLF
	cQuery += " INNER JOIN %SF4.SQLNAME% ON  SF4.F4_FILIAL = SB2.B2_FILIAL AND "+CRLF //JJ
	cQuery += "        SF4.F4_CODIGO = SB6.B6_TES AND "+CRLF //JJ
	cQuery += "        SF4.F4_ESTOQUE = 'S' AND "+CRLF //JJ
	cQuery += "        SF4.D_E_L_E_T_ = ' ' "+CRLF //JJ
	cQuery += " WHERE                                                                           "+CRLF
	cQuery += " 	SB2.D_E_L_E_T_ = ' '                                                        "+CRLF
	cQuery += " 	AND %SB2.XFILIAL%	 				                                   		"+CRLF
	cQuery += " 	AND SB2.B2_COD = '"+cProduct+"'                                         	"+CRLF
	cQuery += " GROUP BY                                                                        "+CRLF
	//VALIDAR SALDO
	cQuery += " 	B6_FILIAL, B6_PRODUTO, B6_CLIFOR,	B6_LOJA, B6_TPCF " //, B2_VFIM1              "+CRLF
	
return cQuery


/*/{Protheus.doc} getAglutB6

Instrucao SQL para exportacao
	
@author Thiago Meschiatti
@since 04/02/2015

@return string instrucao sql
/*/
method getAglutB6(cProduct, cType, dDtInvent, cEntity, cUnit) class DHLSafx52Ag2
	local cQuery 	:= ""
	local cField	:= ""
	local cGroup	:= ""
	
//	if cType $ SAFX52_CLIENTE
//		cField := " A1_ZZINDDW,"
//		cGroup := " A1_ZZINDDW," 
//	else
//		cField := " A2_ZZINDDW," 
//		cGroup := " A2_ZZINDDW,"
//	endif
//	
//	cQuery += "	SELECT FILIAL, PRODUTO, CLIFOR, LOJA, B6_TPCF, " + cField  + " B1_EX_NBM, B2_COD, B1_UM, B1_LOCPAD, B1_TIPO, B1_ZZCONTA, B1_ORIGEM, B1_CLASFIS, "			+ CRLF
//	cQuery += " 	   		SUM(SALDO) SALDO,																			"														+ CRLF
//	cQuery += " 	   		SUM(CUSTO) CUSTO,																			"														+ CRLF
//	cQuery += "			B1_EX_NBM,B2_COD,B1_UM,B1_LOCPAD,B1_TIPO,B1_ZZCONTA,B1_ORIGEM,B1_CLASFIS  	         	"														+ CRLF
//	cQuery += " FROM 																								"															+ CRLF 
//	cQuery += " ( 																								"																+ CRLF
//	
//	cQuery += " 	SELECT B6_FILIAL FILIAL, B6_PRODUTO PRODUTO, B6_CLIFOR CLIFOR, B6_LOJA LOJA, B6_TPCF, " + cField  + " B1_EX_NBM, B2_COD, B1_UM, B1_LOCPAD, B1_TIPO, B1_ZZCONTA, B1_ORIGEM, B1_CLASFIS, "	+ CRLF
//	cQuery += " 		SUM(B6_QUANT) SALDO, 																			"														+ CRLF
//	cQuery += " 		SUM(D1_TOTAL) CUSTO 																			"														+ CRLF
//	cQuery += " 	FROM %SB2.SQLNAME%                                                                                            	"										+ CRLF
//	cQuery += " 	INNER JOIN  %SB1.SQLNAME% ON 						                                                  	"													+ CRLF
//	cQuery += "  		1 = 1 																				"																	+ CRLF 
//	cQuery += " 		AND SB1.B1_FILIAL 	= SB2.B2_FILIAL                                                                	"													+ CRLF
//	cQuery += " 		AND SB1.B1_COD 		= SB2.B2_COD 	                                                                  	"												+ CRLF
//	cQuery += " 		AND SB1.D_E_L_E_T_ 	= ' '                                                                         	"													+ CRLF
//	cQuery += " 	INNER JOIN 	%SB6.SQLNAME% ON 							                                                	"												+ CRLF
//	cQuery += " 		1 = 1 							                                                	"																	+ CRLF
//	cQuery += " 		AND SB6.B6_FILIAL 	= SB1.B1_FILIAL	                                                         		"													+ CRLF
//	cQuery += " 		AND SB1.B1_COD 		= SB6.B6_PRODUTO															"														+ CRLF
//	cQuery += " 		AND SB6.B6_CLIFOR		= '" + cEntity + "'                                                  			"												+ CRLF
//	cQuery += " 		AND SB6.B6_LOJA 		= '" + cUnit + "'                                                               "												+ CRLF	
//	cQuery += " 		AND SB6.D_E_L_E_T_ 	= ' '                                                                           "													+ CRLF
//	
//	//Thiago Meschiatti - FSW TOTVS IP Campinas - 10/10/2017
//	cQuery += "  	INNER JOIN %SF1.SQLNAME% ON 																		"														+ CRLF       	            	
//	cQuery += "  		1 = 1 																				"																	+ CRLF 
//	cQuery += "  		AND 	SF1.F1_FILIAL		= SB6.B6_FILIAL 															"												+ CRLF 				
//	cQuery += "  		AND 	SF1.F1_DOC 		= SB6.B6_DOC 																"													+ CRLF 					
//	cQuery += "  		AND 	SF1.F1_SERIE		= SB6.B6_SERIE 															"													+ CRLF
//	cQuery += "  		AND 	SF1.F1_FORNECE	= SB6.B6_CLIFOR 															"													+ CRLF
//	cQuery += "  		AND 	SF1.F1_LOJA		= SB6.B6_LOJA 															"														+ CRLF 				
//	cQuery += " 		AND 	SF1.F1_DTDIGIT 	>= '20000101' 	          												"														+ CRLF
//	cQuery += " 		AND 	SF1.F1_DTDIGIT 	<= '" + dtos(dDtInvent) + "'												"													+ CRLF
//	cQuery += "  		AND 	%SF1.NOTDEL% 																				"													+ CRLF 
//	
//	cQuery += " 	INNER JOIN  %SD1.SQLNAME% ON       	            														"													+ CRLF
//	cQuery += " 		1 = 1 																						"															+ CRLF
//	cQuery += " 		AND SD1.D1_FILIAL	= SB6.B6_FILIAL 																"													+ CRLF
//	cQuery += " 		AND SD1.D1_DOC 	= SB6.B6_DOC 																	"														+ CRLF
//	cQuery += " 		AND SD1.D1_SERIE	= SB6.B6_SERIE 																"														+ CRLF
//	cQuery += " 		AND SD1.D1_COD	= SB6.B6_PRODUTO																"														+ CRLF
//	cQuery += " 		AND SD1.D1_IDENTB6= SB6.B6_IDENT																"														+ CRLF
//	cQuery += " 		AND %SD1.NOTDEL%		                       													"														+ CRLF
//	
//	if cType $ SAFX52_CLIENTE
//		cQuery += " INNER JOIN %SA1.SQLNAME% ON 					                                                 	"														+ CRLF
//		cQuery += " 	1 = 1 																						"															+ CRLF
//		cQuery += " 	AND 	SA1.A1_FILIAL 	= SB6.B6_FILIAL 															"													+ CRLF
//		cQuery += " 	AND 	SA1.A1_COD 		= SB6.B6_CLIFOR                                                               	"												+ CRLF
//		cQuery += " 	AND 	SA1.A1_LOJA 	= SB6.B6_LOJA                                                                  	"												+ CRLF
//		cQuery += " 	AND 	SA1.D_E_L_E_T_	= ' '                                                                         	"												+ CRLF
//	else
//		cQuery += " INNER JOIN %SA2.SQLNAME% ON 					                                                 	"														+ CRLF
//		cQuery += " 	1 = 1 																						"															+ CRLF
//		cQuery += " 	AND SA2.A2_FILIAL 	= SB6.B6_FILIAL 	                                                         		"												+ CRLF
//		cQuery += " 	AND SA2.A2_COD 			= SB6.B6_CLIFOR                                                                	"													+ CRLF
//		cQuery += " 	AND SA2.A2_LOJA 	= SB6.B6_LOJA                                                                  	"													+ CRLF
//		cQuery += " 	AND SA2.D_E_L_E_T_ 	= ' '                                                                         	"													+ CRLF
//	endif
//	cQuery += " 	WHERE  1  =  1                                                                                             	"												+ CRLF
//	cQuery += " 		AND SB2.D_E_L_E_T_ = ' '                                                                                 	"												+ CRLF
//	cQuery += " 		AND %SB2.XFILIAL%	 				                                   								"													+ CRLF
//	cQuery += " 		AND SB2.B2_COD = '"+cProduct+"'                                                                       	"												+ CRLF
//	cQuery += " 	GROUP BY                                                                                                 	"												+ CRLF
//	cQuery += " 		B6_FILIAL, B6_PRODUTO, B6_CLIFOR, B6_LOJA, B6_TPCF, 		                                            	"											+ CRLF
//	cQuery += 			cGroup
//	cQuery += " 		B1_EX_NBM,B2_COD,B1_UM,B1_LOCPAD,B1_TIPO,B1_ZZCONTA,B1_ORIGEM,B1_CLASFIS           		       		"													+ CRLF
//	
//	cQuery += "	UNION ALL " 																																					+ CRLF
//	
//	cQuery += " 	SELECT 	B6_FILIAL FILIAL, B6_PRODUTO PRODUTO, B6_CLIFOR CLIFOR, B6_LOJA LOJA, B6_TPCF, 					"													+ CRLF
//	cQuery += " " + cField+ " B1_EX_NBM, B2_COD, B1_UM, B1_LOCPAD, B1_TIPO, B1_ZZCONTA, B1_ORIGEM, B1_CLASFIS, 					"											+ CRLF
//	cQuery += " 		SUM(-B6_QUANT) SALDO, 																			"														+ CRLF
//	cQuery += " 		SUM(-D2_TOTAL) CUSTO 																			"														+ CRLF
//	cQuery += " 	FROM %SB2.SQLNAME%                                                                                           	"										+ CRLF
//	
//	cQuery += " 	INNER JOIN  %SB1.SQLNAME% ON 1 = 1						                                                  	"												+ CRLF
//	cQuery += " 		AND SB1.B1_FILIAL 		= SB2.B2_FILIAL                                                            	"													+ CRLF
//	cQuery += " 		AND SB1.B1_COD		= SB2.B2_COD 	                                                                  	"												+ CRLF
//	cQuery += " 		AND SB1.D_E_L_E_T_ 	= ' '                                                                           "													+ CRLF
//	cQuery += "	INNER JOIN 	%SB6.SQLNAME% ON 1 = 1							                                           		"													+ CRLF
//	cQuery += " 		AND SB6.B6_FILIAL 	= SB1.B1_FILIAL	                                                             	"													+ CRLF
//	cQuery += " 		AND SB1.B1_COD 		= SB6.B6_PRODUTO		                                                         	"												+ CRLF
//	cQuery += " 		AND SB6.B6_CLIFOR		= '" + cEntity + "'                                                           	"												+ CRLF
//	cQuery += " 		AND SB6.B6_LOJA 		= '" + cUnit + "'                                                             	"												+ CRLF	
//	cQuery += " 		AND SB6.D_E_L_E_T_ 	= ' '                                                                          	"													+ CRLF
//	
//	//Thiago Meschiatti - FSW TOTVS IP Campinas - 10/10/2017
//	cQuery += " 	INNER JOIN  %SF2.SQLNAME% ON       	            														"													+ CRLF
//	cQuery += " 		1 = 1 																						"															+ CRLF
//	cQuery += " 		AND SF2.F2_FILIAL		= SB6.B6_FILIAL 															"													+ CRLF
//	cQuery += " 		AND SF2.F2_DOC 		= SB6.B6_DOC 																"														+ CRLF
//	cQuery += " 		AND SF2.F2_SERIE		= SB6.B6_SERIE 															"														+ CRLF
//	cQuery += "  		AND SF2.F2_CLIENTE	= SB6.B6_CLIFOR 															"														+ CRLF
//	cQuery += "  		AND SF2.F2_LOJA		= SB6.B6_LOJA 															"															+ CRLF
//	cQuery += " 		AND SF2.F2_EMISSAO 	>= '20000101' 	           												"															+ CRLF //EMINFE
//	cQuery += " 		AND SF2.F2_EMISSAO 	<= '" + dtos(dDtInvent) + "' 												"														+ CRLF //EMINFE
//	cQuery += " 		AND %SF2.NOTDEL%		                       													"														+ CRLF		                 
//	
//	cQuery += " 	INNER JOIN  (SELECT DISTINCT D2_FILIAL, D2_DOC, D2_SERIE, D2_COD, D2_IDENTB6, D2_QUANT, D2_TOTAL, D_E_L_E_T_ FROM SD2100) SD2 ON "   						+ CRLF    	            														
//	cQuery += " 		1 = 1 																						"															+ CRLF
//	cQuery += " 		AND SD2.D2_FILIAL	= SB6.B6_FILIAL 																"													+ CRLF
//	cQuery += " 		AND SD2.D2_DOC 	= SB6.B6_DOC 																	"														+ CRLF
//	cQuery += " 		AND SD2.D2_SERIE	= SB6.B6_SERIE 																"														+ CRLF
//	cQuery += " 		AND SD2.D2_COD	= SB6.B6_PRODUTO																"														+ CRLF
//	cQuery += " 		AND SD2.D2_IDENTB6= SB6.B6_IDENT																"														+ CRLF
//	cQuery += " 		AND SD2.D2_QUANT 	= SB6.B6_QUANT																"														+ CRLF
//	cQuery += " 		AND %SD2.NOTDEL%		                       													"														+ CRLF
//	
//	if cType $ SAFX52_CLIENTE
//		cQuery += " INNER JOIN %SA1.SQLNAME% ON 1 = 1					                                                 	"														+ CRLF
//		cQuery += " 	AND SA1.A1_FILIAL 	= SB6.B6_FILIAL 	                                                             	"												+ CRLF
//		cQuery += " 	AND SA1.A1_COD 		= SB6.B6_CLIFOR	 	                                                         	"													+ CRLF
//		cQuery += " 	AND SA1.A1_LOJA 		= SB6.B6_LOJA                                                                  	"												+ CRLF
//		cQuery += " 	AND SA1.D_E_L_E_T_ 	= ' '                                                                          	"													+ CRLF
//	else
//		cQuery += " INNER JOIN %SA2.SQLNAME% ON 1 = 1					                                                	"													+ CRLF
//		cQuery += " 	AND SA2.A2_FILIAL 	= SB6.B6_FILIAL 	                                                             	"												+ CRLF
//		cQuery += " 	AND SA2.A2_COD 		= SB6.B6_CLIFOR	 	                                                        	"													+ CRLF			
//		cQuery += " 	AND SA2.A2_LOJA 		= SB6.B6_LOJA                                                                 	"												+ CRLF
//		cQuery += " 	AND SA2.D_E_L_E_T_ 	= ' '                                                                          	"													+ CRLF
//	endif
//	cQuery += " 	WHERE                                                                                                    	"												+ CRLF
//	cQuery += " 		SB2.D_E_L_E_T_ = ' '                                                                                 	"												+ CRLF
//	cQuery += " 		AND %SB2.XFILIAL%	 				                                   								"													+ CRLF
//	cQuery += " 		AND SB2.B2_COD = '"+cProduct+"'                                                                       	"												+ CRLF
//	cQuery += " 	GROUP BY                                                                                                  	"												+ CRLF
//	cQuery += " 		B6_FILIAL, B6_PRODUTO, B6_CLIFOR, B6_LOJA, B6_TPCF, "																									+ CRLF
//	cQuery += 			cGroup   																																				+ CRLF
//	cQuery += " 		B1_EX_NBM,B2_COD,B1_UM,B1_LOCPAD,B1_TIPO,B1_ZZCONTA,B1_ORIGEM,B1_CLASFIS              		    		"												+ CRLF
//	cQuery += " ) " 																																							+ CRLF
//	cQuery += " GROUP BY " 																																						+ CRLF                                                                   	
//	cQuery += " FILIAL,  PRODUTO,  CLIFOR,  LOJA, B6_TPCF, 															"															+ CRLF
//	cQuery += cGroup + " B1_EX_NBM,B2_COD,B1_UM,B1_LOCPAD,B1_TIPO,B1_ZZCONTA,B1_ORIGEM,B1_CLASFIS            				"													+ CRLF

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
	cQuery += "             AND SB6.B6_LOCAL = SB2.B2_LOCAL " + CRLF //JJ 2018/08/14
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
	cQuery += " INNER JOIN %SF4.SQLNAME% ON  SF4.F4_FILIAL = SB2.B2_FILIAL AND "+CRLF //JJ 2018/08/14
	cQuery += "        SF4.F4_CODIGO = SB6.B6_TES AND "+CRLF //JJ
	cQuery += "        SF4.F4_ESTOQUE = 'S' AND "+CRLF //JJ
	cQuery += "        SF4.D_E_L_E_T_ = ' ' "+CRLF //JJ
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
/ */
method getSldTerc(cProduct, dDtInvent) class DHLSafx52Ag2
	local cQuery 	:= ""
	local oSql	 	:= IpSqlObject():newIpSqlObject()
	local nSldTerc	:= 0
	
//	cQuery += "	SELECT SUM(SALDO) SALDO " + CRLF
//	cQuery += " 	FROM " + CRLF 
//	cQuery += " 	( " + CRLF
//	cQuery += "  		SELECT " + CRLF
//	cQuery += " 			SUM(B6_QUANT) SALDO " + CRLF                       	
//	
//	cQuery += "  		FROM %SB6.SQLNAME% " + CRLF       
//	
//	cQuery += "  		INNER JOIN %SF1.SQLNAME% ON " + CRLF       	            	
//	cQuery += "  					1 = 1 " + CRLF 
//	cQuery += "  			AND 	SF1.F1_FILIAL	= SB6.B6_FILIAL " + CRLF 				
//	cQuery += "  			AND 	SF1.F1_DOC 	= SB6.B6_DOC " + CRLF 					
//	cQuery += "  			AND 	SF1.F1_SERIE	= SB6.B6_SERIE " + CRLF 				
//	cQuery += " 			AND 	SF1.F1_DTDIGIT >= '20000101' 	           	"+CRLF
//	cQuery += " 			AND 	SF1.F1_DTDIGIT <= '" + dtos(dDtInvent) + "' 	"+CRLF
//	cQuery += "  			AND 	%SF1.NOTDEL% " + CRLF 		                       	
//	 
//	cQuery += "  		WHERE " + CRLF                        	                 	
//	cQuery += "   				%SB6.XFILIAL% " + CRLF                                 	
//	cQuery += " 			AND 	SB6.B6_PRODUTO = '"+cProduct+"'             	"+CRLF
//	cQuery += "  			AND 	%SB6.NOTDEL% " + CRLF    
//	 
//	cQuery += "		UNION ALL " + CRLF
//	 
//	cQuery += "  		SELECT " + CRLF
//	cQuery += " 			SUM(-B6_QUANT) SALDO " + CRLF                       	
//	
//	cQuery += "  		FROM %SB6.SQLNAME% " + CRLF
//		
//	cQuery += "  		INNER JOIN %SF2.SQLNAME% ON " + CRLF       	            	
//	cQuery += "  					1 = 1 " + CRLF 
//	cQuery += "			AND 	SF2.F2_FILIAL	= SB6.B6_FILIAL " + CRLF 				
//	cQuery += "  			AND 	SF2.F2_DOC 	= SB6.B6_DOC " + CRLF 					
//	cQuery += "  			AND 	SF2.F2_SERIE	= SB6.B6_SERIE " + CRLF 				
//	cQuery += " 			AND 	SF2.F2_EMISSAO >= '20000101' 	           	"+CRLF //EMINFE
//	cQuery += " 			AND 	SF2.F2_EMISSAO <= '" + dtos(dDtInvent) + "' 	"+CRLF //EMINFE
//	cQuery += "  			AND 	%SF2.NOTDEL% " + CRLF 		                       	
//	   
//	cQuery += "  		WHERE " + CRLF                        	                 	
//	cQuery += "      				%SB6.XFILIAL% " + CRLF                                 	
//	cQuery += " 			AND 	SB6.B6_PRODUTO = '"+cProduct+"'             	"+CRLF
//	cQuery += " 			AND 	%SB6.NOTDEL% "+CRLF
//	cQuery += " 	) " + CRLF
//	
// ALTRADO EM 2018/08/14
//	cQuery += " SELECT 	SUM(CASE WHEN B6_PODER3 = 'R' THEN (B6_QUANT) ELSE  (-B6_QUANT) END) SALDO                       	"+CRLF             
//	cQuery += " FROM %SB6.SQLNAME%                                  "+CRLF
//	cQuery += " WHERE                                              	"+CRLF
//	cQuery += 
//	cQuery += "     %SB6.XFILIAL%                                 	"+CRLF
//	cQuery += " 	AND SB6.B6_PRODUTO = '"+cProduct+"'             "+CRLF
//	cQuery += " 	AND SB6.B6_DTDIGIT >= '20000101' 	           	"+CRLF
//	cQuery += " 	AND SB6.B6_DTDIGIT <= '" + dtos(dDtInvent) + "' "+CRLF
//	cQuery += " 	AND SB6.D_E_L_E_T_ = ' '                       	"+CRLF 

	CqUERY := ""
	cQuery += " SELECT 	SUM(CASE WHEN B6_PODER3 = 'R' THEN (B6_QUANT) ELSE  (-B6_QUANT) END) SALDO                       	"+CRLF             
	cQuery += " FROM %SB6.SQLNAME%                                  "+CRLF
	cQuery += " , %SF4.SQLNAME%                                  "+CRLF
	cQuery += " WHERE                                              	"+CRLF
	cQuery += "     %SB6.XFILIAL%                                 	"+CRLF
	cQuery += " 	AND SB6.B6_PRODUTO = '"+cProduct+"'             "+CRLF
	cQuery += " 	AND SB6.B6_DTDIGIT >= '20000101' 	           	"+CRLF
	cQuery += " 	AND SB6.B6_DTDIGIT <= '" + dtos(dDtInvent) + "' "+CRLF
	cQuery += " 	AND SB6.D_E_L_E_T_ = ' '                       	"+CRLF
	cQuery += "     AND SF4.F4_FILIAL = SB6.B6_FILIAL          	"+CRLF
	cQuery += "	AND SF4.F4_CODIGO = SB6.B6_TES         	"+CRLF
	cQuery += "	AND SF4.F4_ESTOQUE = 'S'          	"+CRLF
	cQuery += "	AND SF4.D_E_L_E_T_= ' '                                	"+CRLF


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
method notFieldRequired()  class DHLSafx52Ag2

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
method getDateDefault() class DHLSafx52Ag2

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
@since 24 de janeiro de 2018

@return String instrucao sql
/*/
Method getSqlSB9( dDtInvent ) class DHLSafx52Ag2
Local __cQuery		:= ""
local cprod		:= ""

Default dDtInvent	:= dDataBase

__cQuery := " SELECT DISTINCT B9_COD, B1_ZZCDPRO, B1_ZZLJPRO, B1_POSIPI, B1_TIPO, B1_UM, B1_ZZCONTA, B1_ORIGEM, B1_CLASFIS, B1_GRUPO, B1_LOCPAD, '01' B9_LOCAL, SUM(B9_QINI) SALDO, SUM(B9_VINI1) CUSTO "
__cQuery += "  FROM " + RetSqlName( "SB9" ) + " SB9"
__cQuery += " INNER JOIN " + RetSqlName( "SB1" ) + " SB1 ON B1_FILIAL = B9_FILIAL AND SB1.D_E_L_E_T_ = ' ' AND B1_COD = B9_COD"
__cQuery += " WHERE B9_FILIAL = '" + xFilial( "SB9" ) + "' "
__cQuery += "  AND SB9.D_E_L_E_T_ = ' '"
__cQuery += "   AND B9_DATA = '" + dTOs( dDtInvent ) + "'"
__cQuery += "   AND B9_QINI <> 0 "
//__cQuery += "   AND B9_COD = 'F000142910' "
//__cQuery += "   AND B9_COD = '678582' "
//__cQuery += "   AND B9_COD IN ('F000142910','F000141663','0000496327', '0000495305') "
//__cQuery += "   AND B9_COD BETWEEN '0000496500' AND '0000496550'"
__cQuery += " GROUP BY B9_COD, B1_ZZCDPRO, B1_ZZLJPRO, B1_POSIPI, B1_TIPO, B1_UM, B1_ZZCONTA, B1_ORIGEM, B1_CLASFIS, B1_GRUPO, B1_LOCPAD"

Return( __cQuery )

/**
*	obtem o depositante
**/
static function getDepositante(cProduto)
	
	local aArea 		:= getArea()
	local aAreaSB1 		:= SB1->(getArea())
	local aAreaSA1		:= SA1->(getArea())
	local cIDPlantB1	:= ""
	local cDepositant	:= ""	
	
	SB1->(dbSetOrder(1))
	
	if SB1->(dbSeek((fwxFilial("SB1") + cProduto)))
		
		cIDPlantB1 := allTrim(SB1->B1_ZZPLANT)
		
		if cIDPlantB1 == "4921"	
			
			//ALTERA PARA 4920
			cIDPlantB1 := "4920"			
			
		endIf
		
		cDepositant := getCliente(cIDPlantB1)
		
	endIf
	
	restArea(aAreaSA1)
	restArea(aAreaSB1)
	restArea(aArea)
	
return cDepositant

/**
*	obtem o cliente de acordo com o plantId
**/
static function getCliente(cIDPlantB1)
	
	local cQuery 	:= ""
	local cAlias	:= getNextAlias()
	local cCliente	:= ""
	
	cQuery := " SELECT SA1.A1_COD, SA1.A1_LOJA FROM " + retSqlName("SA1") + " SA1 " + CRLF
	cQuery += " WHERE 1 = 1 " 															+ CRLF
	cQuery += "    AND SA1.A1_FILIAL = '" + fwxFilial("SA1") + "' " 					+ CRLF
	cQuery += "    AND SA1.A1_ZZPLANT = '" + cIDPlantB1 + "' " 							+ CRLF
	cQuery += "    AND SA1.D_E_L_E_T_ = ' ' " 											+ CRLF
	
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias ,.F.,.T.)
	
	if (cAlias)->(!eof())
		
		cCliente := allTrim((cAlias)->A1_COD) + allTrim((cAlias)->A1_LOJA)
		
	endIf
	
	(cAlias)->(dbCloseArea(cAlias))
	
return cCliente
