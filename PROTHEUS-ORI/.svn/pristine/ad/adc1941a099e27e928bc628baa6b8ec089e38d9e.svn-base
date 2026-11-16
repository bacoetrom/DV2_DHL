#include 'totvs.ch'
#include 'safx10.ch'
#include 'safx.ch'
#include 'dhl.ch'


/*/{Protheus.doc} DHLSafx10Dis

Respons‡avel pelas regras e montagem das informacoees para a exportacao
	
@author Thiago Meschiatti
@since 22/07/2016
/*/
user function _Safx10Dis;return

class DHLSafx10Dis from DHLSafx

	method newDHLSafx10Dis() constructor
	
	method addLine()
	method getSql(dDtFrom,dDtUtil)
	method getSqlSD1(dDtFrom,dDtUtil)
	method getSqlSD2(dDtFrom,dDtUtil)
	method getSqlSD3(dDtFrom,dDtUtil)
	method getSqlSB1(dDtFrom,dDtUtil)
	method getIndFisJur()
	method getInscEst()
	method getGrupoCont()
	method notFieldRequired()
	method getCodDocto()

endclass

//-----------------------------------------------------------------
method newDHLSafx10Dis() class DHLSafx10Dis

return


/*/{Protheus.doc} getSql

Instrucao Sql usado na geracao do arquivo texto
	
@author Daniel Braga
@since 30/10/2014

@param dDtFrom, data, data de
@param dDtUtil, data, data ate

@return TipoRet DescricaoRet
/*/
method getSql(dDtFrom,dDtUtil) class  DHLSafx10Dis 

	local cQuery := ""
	
	cQuery := ::getSqlSD1(dDtFrom, dDtUtil)
	cQuery += " union "
	cQuery += ::getSqlSD2(dDtFrom, dDtUtil)
	cQuery += " union "
	cQuery += ::getSqlSD3(dDtFrom, dDtUtil)

return Upper(cQuery) 

/*/{Protheus.doc} getSqlSD1

Instrcao sql do arquivo sd1
	
@author Daniel Braga
@since 30/10/2014

@param dDtFrom, date, data de 
@param dDtUtil, data, data ate

@return string instrucao sql 
/*/
method getSqlSD1(dDtFrom,dDtUtil) class  DHLSafx10Dis 

	local cQuery := "" 
	
	cQuery := "select 'sd1' arq, 	"
	cQuery += "d1_filial 	cod_empresa,"                                                                                                 +CRLF
	cQuery += "d1_filial 	cod_estab, "                                                                                                  +CRLF
	cQuery += "'"+SAFX_DOCUMENTO_ENTRADA+"'	movto_e_s, "                                                                                  +CRLF
	cQuery += "case when d1_tipo in ( 'D' ,'B') then '"+SAFX_MOVIMENTO_DEVOLUCAO+"' else '"+SAFX_MOVIMENTO_NORMAL+"' end	norm_dev, "   +CRLF
	cQuery += "d1_dtdigit 	data_movto, "                                                                                                 +CRLF
	cQuery += "d1_doc 		num_docto, "                                                                                                  +CRLF
	cQuery += "d1_serie		serie_docfis,  "                                                                                              +CRLF
	cQuery += "d1_tp			tp_ind_produto, "                                                                                            +CRLF
	cQuery += "d1_cod 		cod_produto,"                                                                                                 +CRLF
	cQuery += "d1_um 			cod_und_padrao,"                                                                                          +CRLF
	cQuery += "d1_local 		cod_almox,"                                                                                               +CRLF
	cQuery += "d1_cc 			cod_custo,"                                                                                               +CRLF
	cQuery += "d1_item		num_item, "                                                                                                   +CRLF
	cQuery += "d1_quant 		qtd_movto,"                                                                                               +CRLF
	cQuery += "d1_vunit		preco_unit, "                                                                                                 +CRLF
	cQuery += "d1_total 		preco_item,"                                                                                              +CRLF
	cQuery += "d1_custo 		custo_unit,"                                                                                              +CRLF
	cQuery += "d1_custo 		custo_item, "                                                                                             +CRLF
	cQuery += "d1_conta 		cod_conta_cred,"                                                                                          +CRLF
	cQuery += "d1_conta 		cod_conta_debito,"                                                                                        +CRLF
	cQuery += "d1_cf			cod_cfo,"                                                                                                 +CRLF
	cQuery += "d1_valipi 	vlr_ipi,"                                                                                                     +CRLF
	cQuery += "d1_dtdigit	data_escrita_fis,"                                                                                            +CRLF
	cQuery += "d1_um 			cod_medida,"                                                                                              +CRLF
	cQuery += "sb1.b1_posipi cod_nbm,"	                                                                                                  +CRLF
	cQuery += "d1_tp			ind_produto_rastro,"                                                                                      +CRLF
	cQuery += "d1_cod			cod_produto_rastro,"                                                                                      +CRLF
	cQuery += "d1_valicm		vlr_icms,"                                                                                                +CRLF
	cQuery += "'F' 			ind_doc_oper,"                                                                                                +CRLF
	cQuery += "d1_custo		vlr_custo_dca,"                                                                                               +CRLF
	cQuery += "d1_op 			cod_dif_producao,"                                                                                        +CRLF
	cQuery += "sf4.f4_finalid dsc_finalidade,"                                                                                            +CRLF
	cQuery += "d1_tes 		tes ,"                                                                                                        +CRLF
	cQuery += "d1_fornece 	cliefor ,"                                                                                                    +CRLF
	cQuery += "d1_loja 	    loja   ,"                                                                                                     +CRLF
	cQuery += "sf4.f4_poder3 poder3,   "                                                                                                  +CRLF
	cQuery += "d1_doc			num_docfis_ofic,"                                                                                         +CRLF
	cQuery += "d1_serie		serie_docfis_ofic,"                                                                                           +CRLF
	cQuery += "d1_op			num_ordem "                                                                                               +CRLF
	cQuery += "from "+retSqlName("SB1")+" sb1, "+retSqlName("SD1")+" sd1, "+retSqlName("SF4")+" sf4, "+retSqlName("SF1")+" sf1 "          +CRLF
	cQuery += "where sb1.b1_cod = sd1.d1_cod and "                                                                                        +CRLF
	cQuery += "sd1.d1_filial =  '"+xFilial("SD1")+"'  and "                                                                               +CRLF
	cQuery += "sf4.f4_filial =  '"+xFilial("SF4")+"'  and "                                                                               +CRLF
	cQuery += "sd1.d1_tes = sf4.f4_codigo and "                                                                                           +CRLF
	cQuery += "sf4.f4_estoque = 'S' and "                                                                                                 +CRLF
	cQuery += "sd1.d1_dtdigit >=  '"+dtos(dDtFrom)+"' and sd1.d1_dtdigit <=  '"+dtos(dDtUtil)+"' and "                                    +CRLF
	cQuery += "sd1.d1_origlan <> 'LF'   and sd1.d1_serie <> ' ' and "                                                                     +CRLF
	cQuery += "d1_local = '01' and "                                                                                                      +CRLF
	cQuery += "d1_filial = f1_filial and d1_doc = f1_doc and d1_serie = f1_serie and d1_fornece = f1_fornece and "                        +CRLF
	//cQuery += "d1_loja = f1_loja and d1_tipo = f1_tipo and f1_especie <> '"+DHL_ESPECIE_INVENTARIO+"' and sf1.d_e_l_e_t_ = ' ' and "      +CRLF
	cQuery += "f1_especie <> '" + DHL_ESPECIE_ESPELHO + "' and "																		  +CRLF
	cQuery += "d1_loja = f1_loja and d1_tipo = f1_tipo and  sf1.d_e_l_e_t_ = ' ' and "      +CRLF
	cQuery += "sd1.d_e_l_e_t_ = ' ' and "                                                                                                 +CRLF
	cQuery += "sf4.d_e_l_e_t_ = ' ' and "                                                                                                 +CRLF
	cQuery += "sb1.b1_filial = '"+xFilial("SB1")+"' and "                                                                                 +CRLF
	cQuery += "sb1.d_e_l_e_t_=' ' "                                                                                                       +CRLF

return cQuery

/*/{Protheus.doc} getSqlSD2

Instrucao sql do arquivo sd2
	
@author Daniel Braga
@since 30/10/2014

@param dDtFrom, date, data de
@param dDtUtil, data, data ate 

@return string instrucao sql 
/*/
method getSqlSD2(dDtFrom,dDtUtil) class  DHLSafx10Dis 

	local cQuery := "" 
	
	cQuery :="select 'sd2',	"                                                                                                          +CRLF
	cQuery += "d2_filial 	cod_empresa,"                                                                                              +CRLF
	cQuery += "d2_filial 	cod_estab, "                                                                                               +CRLF
	cQuery += "'"+SAFX_DOCUMENTO_SAIDA+"' movto_e_s, "                                                                                 +CRLF
	cQuery += "case when d2_tipo in ( 'D' ,'B') then '"+SAFX_MOVIMENTO_DEVOLUCAO+"' else '"+SAFX_MOVIMENTO_NORMAL+"' end	norm_dev, "+CRLF
	cQuery += "d2_emissao 	data_movto, "                                                                                              +CRLF
	cQuery += "d2_doc 		num_docto, "                                                                                               +CRLF
	cQuery += "d2_serie		serie_docfis,  "                                                                                           +CRLF
	cQuery += "d2_tp		tp_ind_produto, "                                                                                             +CRLF
	cQuery += "d2_cod 		cod_produto,"                                                                                              +CRLF
	cQuery += "d2_um 			cod_und_padrao,"                                                                                       +CRLF
	cQuery += "d2_local 		cod_almox,"                                                                                            +CRLF
	cQuery += "d2_ccusto 	cod_custo,"                                                                                                +CRLF
	cQuery += "d2_item		num_item, "                                                                                                +CRLF
	cQuery += "d2_quant 		qtd_movto,"                                                                                            +CRLF
	cQuery += "d2_prcven		preco_unit, "                                                                                          +CRLF
	cQuery += "d2_total 		preco_item,"                                                                                           +CRLF
	cQuery += "d2_custo1 	custo_unit,"                                                                                               +CRLF
	cQuery += "d2_custo1 	custo_item, "                                                                                              +CRLF
	cQuery += "d2_conta 		cod_conta_cred,"                                                                                       +CRLF
	cQuery += "d2_conta 		cod_conta_debito,"                                                                                     +CRLF
	cQuery += "d2_cf			cod_cfo,"                                                                                              +CRLF
	cQuery += "d2_valipi 	vlr_ipi,"                                                                                                  +CRLF
	cQuery += "d2_dtdigit	data_escrita_fis,"                                                                                         +CRLF
	cQuery += "d2_um 			cod_medida,"                                                                                           +CRLF
	cQuery += "sb1.b1_posipi cod_nbm,"                                                                                                 +CRLF
	//cQuery += "d2_op			num_ordem,"	                                                                                           +CRLF
	cQuery += "d2_tp		ind_produto_rastro,"                                                                                       +CRLF
	cQuery += "d2_cod			cod_produto_rastro,"                                                                                   +CRLF
	cQuery += "d2_valicm		vlr_icms,"                                                                                             +CRLF
	cQuery += "'F' 			ind_doc_oper,"                                                                                             +CRLF
	cQuery += "d2_custo1		vlr_custo_dca,"                                                                                        +CRLF
	cQuery += "d2_op 			cod_dif_producao,"                                                                                     +CRLF
	cQuery += "sf4.f4_finalid dsc_finalidade,"                                                                                         +CRLF
	cQuery += "d2_tes 		tes, "                                                                                                     +CRLF
	cQuery += "d2_cliente 	cliefor ,"                                                                                                 +CRLF
	cQuery += "d2_loja 	    loja   ,"                                                                                                  +CRLF
	cQuery += "sf4.f4_poder3 poder3,   "                                                                                               +CRLF
	cQuery += "d2_doc			num_docfis_ofic,"                                                                                      +CRLF
	cQuery += "d2_serie		serie_docfis_ofic,"                                                                                        +CRLF
	cQuery += "sc6.c6_zzop num_ordem   "	                                                                                           +CRLF
	cQuery +="from  "+retSqlName("SB1")+" sb1, "+retSqlName("SF4")+" sf4,  "+retSqlName("SD2")+" sd2 "                                 +CRLF
	cQuery += " left join "+retSqlName("SC6")+" sc6 on 	          "                                                                    +CRLF
	cQuery += " 	sc6.c6_filial = sd2.d2_filial     "                                                                                +CRLF
	cQuery += " 	and sc6.c6_num = sd2.d2_pedido    "                                                                                +CRLF
	cQuery += " 	and sc6.c6_produto = sd2.d2_cod   "                                                                                +CRLF
	cQuery += " 	and sc6.c6_zzop <> ' '            "                                                                                +CRLF
	cQuery += " 	and sc6.d_e_l_e_t_= ' '           "                                                                                +CRLF
	cQuery +="where sb1.b1_cod = sd2.d2_cod and "                                                                                      +CRLF
	cQuery +="sd2.d2_filial =  '"+xFilial("SD2")+"'  and "                                                                             +CRLF
	cQuery +="sf4.f4_filial =  '"+xFilial("SF4")+"'  and "                                                                             +CRLF
	cQuery +="sd2.d2_tes = sf4.f4_codigo and "                                                                                         +CRLF
	cQuery +="sf4.f4_estoque = 'S' and "                                                                                               +CRLF
	cQuery +="sd2.d2_emissao >=  '"+dtos(dDtFrom)+"' and "                                                                             +CRLF
	cQuery +="sd2.d2_emissao <=  '"+dtos(dDtUtil)+"' and "                                                                             +CRLF
	cQuery +="sd2.d2_origlan <> 'LF'   and "                                                                                           +CRLF
	cQuery +="d2_local = '01' and  "                                                                                                   +CRLF
	cQuery +="sd2.d_e_l_e_t_= ' ' and "                                                                                                +CRLF
	cQuery +="sf4.d_e_l_e_t_= ' ' and "                                                                                                +CRLF
	cQuery +="sb1.b1_filial = '"+xFilial("SB1")+"' and "                                                                               +CRLF
	cQuery +="sb1.d_e_l_e_t_=' ' "                                                                                                     +CRLF
	
return cQuery

/*/{Protheus.doc} getSqlSD3

Instrcao sql do arquivo sd3
	
@author Daniel Braga
@since 30/10/2014

@param dDtFrom, date, data de
@param dDtUtil, data, data ate 

@return string instrucao sql 
/*/
method getSqlSD3(dDtFrom,dDtUtil) class  DHLSafx10Dis
	
	local cQuery := "" 
	
	cQuery := "select 'sd3',	 "                                                                                                              +CRLF
	cQuery += "d3_filial 	cod_empresa,"                                                                                                       +CRLF
	cQuery += "d3_filial 	cod_estab, "                                                                                                        +CRLF
	cQuery += "case when d3_tm >= '500' then '"+SAFX_DOCUMENTO_SAIDA+"' else '"+SAFX_DOCUMENTO_ENTRADA+"' end movto_e_s, "                      +CRLF
	cQuery += "'"+SAFX_MOVIMENTO_NORMAL+"' norm_dev, "                                                                                          +CRLF
	cQuery += "d3_emissao 	data_movto, "                                                                                                       +CRLF
	cQuery += "d3_doc 		num_docto, "                                                                                                        +CRLF
	cQuery += "' '			serie_docfis,  "                                                                                                    +CRLF
	cQuery += "d3_tipo		tp_ind_produto, "                                                                                                      +CRLF
	cQuery += "d3_cod 		cod_produto,"                                                                                                       +CRLF
	cQuery += "d3_um 		cod_und_padrao,"                                                                                                    +CRLF
	cQuery += "d3_local 	cod_almox,"                                                                                                         +CRLF
	cQuery += "d3_cc	 	cod_custo,"                                                                                                         +CRLF
	cQuery += "'01'			num_item, "                                                                                                         +CRLF
	cQuery += "d3_quant 	qtd_movto,"                                                                                                         +CRLF
	cQuery += "0			preco_unit, "                                                                                                       +CRLF
	cQuery += "0 			preco_item,"                                                                                                        +CRLF
	cQuery += "d3_custo1 	custo_unit,"                                                                                                        +CRLF
	cQuery += "d3_custo1 	custo_item, "                                                                                                       +CRLF
	cQuery += "d3_conta 	cod_conta_cred,"                                                                                                    +CRLF
	cQuery += "d3_conta 	cod_conta_debito,"                                                                                                  +CRLF
	cQuery += "d3_cf		cod_cfo,"                                                                                                           +CRLF
	cQuery += "0 			vlr_ipi,"                                                                                                           +CRLF
	cQuery += "d3_dtlanc	data_escrita_fis,"                                                                                                  +CRLF
	cQuery += "d3_um 		cod_medida,"                                                                                                        +CRLF
	cQuery += "sb1.b1_posipi cod_nbm,"	                                                                                                        +CRLF	
	cQuery += "d3_tipo		 ind_produto_rastro,"                                                                                               +CRLF
	cQuery += "d3_cod		 cod_produto_rastro,"                                                                                               +CRLF
	cQuery += "0       	 vlr_icms,"                                                                                                             +CRLF
	cQuery += "'F' 			 ind_doc_oper,"                                                                                                     +CRLF
	cQuery += "d3_custo1	 vlr_custo_dca,"                                                                                                    +CRLF
	cQuery += "d3_op 			cod_dif_producao,"                                                                                              +CRLF
	cQuery += "' '  dsc_finalidade,"                                                                                                            +CRLF
	cQuery += "d3_tm 		  tes, "                                                                                                            +CRLF
	cQuery += "' ' 	cliefor ,"                                                                                                                  +CRLF
	cQuery += "' ' 	    loja   ,"                                                                                                               +CRLF
	cQuery += "' ' poder3,   "                                                                                                                  +CRLF
	cQuery += " case when sd3.d3_op = ' ' then "                                                                                                 +CRLF
	cQuery += "    ' '  else                   "                                                                                                 +CRLF
	cQuery += "    sc6.c6_nota                 "                                                                                                 +CRLF
	cQuery += " end num_docfis_ofic,           "                                                                                                 +CRLF
	cQuery += " case when sd3.d3_op = ' ' then "                                                                                                 +CRLF
	cQuery += "   ' ' else                     "                                                                                                 +CRLF
	cQuery += "   sc6.c6_serie                 "                                                                                                 +CRLF
	cQuery += " end serie_docfis_ofic,          "                                                                                                +CRLF
	cQuery += " d3_op		 num_ordem "                                                                                                        +CRLF
	cQuery += "from  "+retSqlName("SB1")+" sb1, "+retSqlName("SD3")+" sd3 "                                                                     +CRLF
	cQuery += " left join "+retSqlName("SC6")+" sc6 on                                                                                      "   +CRLF
	cQuery += " 	sc6.c6_zzop like case when sd3.d3_op <> '             ' then  '%'||substr(d3_op, 1,6)||'%' else '% %' end "                 +CRLF
	cQuery += " 	and sc6.c6_filial =  '"+xFilial("SB1")+"'                                                                       "           +CRLF
	cQuery += " 	and sc6.d_e_l_e_t_= ' '                                                                                   "                 +CRLF
	cQuery += "where sb1.b1_cod = sd3.d3_cod and "                                                                                              +CRLF
	cQuery += "sd3.d3_filial =  '"+xFilial("SD3")+"'  and "                                                                                     +CRLF
	cQuery += "sd3.d3_emissao >=  '"+dtos(dDtFrom)+"' and sd3.d3_emissao <=  '"+dtos(dDtUtil)+"' and "                                          +CRLF
	cQuery += "d3_estorno <> 'S' and "                                                                                                          +CRLF
	cQuery += "d3_local = '01' and  "                                                                                                           +CRLF
	cQuery += "sb1.b1_filial = '"+xFilial("SB1")+"' and "                                                                                       +CRLF
	cQuery += "sb1.d_e_l_e_t_=' ' and  "                                                                                                        +CRLF
	cQuery += "sd3.d_e_l_e_t_= ' ' "	                                                                                                        +CRLF

return cQuery

/*/{Protheus.doc} getSqlSB1

Instrcao sql do arquivo sb1
	
@author Daniel Braga
@since 30/10/2014

@param dDtFrom, date, data de
@param dDtUtil, data, data ate 

@return string instrucao sql 
/*/
method getSqlSB1(dDtFrom,dDtUtil) class  DHLSafx10Dis

	local cQuery := ""
	
	cQuery:= "select 'sb1', "
	cQuery+= "	  sb1exs.b1_cod," 
	cQuery+= "	  sb1exs.b1_tipo," 
	cQuery+= "	  sb1exs.b1_um, "
	cQuery+= "	  sb1exs.b1_grupo," 
	cQuery+= "	  sb1exs.b1_desc, "
	cQuery+= "	  sb1exs.b1_posipi," 
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	   0, "
	cQuery+= "	   0, "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	   0, "
	cQuery+= "	  '', "
	cQuery+= "	  '', "
	cQuery+= "	   0  "
	cQuery+= "from "+retSqlName("SB1")+" sb1exs " 
	cQuery+= "where sb1exs.b1_filial = '"+xFilial("SB1")+"' and "
	cQuery+= "sb1exs.b1_cod <> 'prod. importado' and "  
	cQuery+= "sb1exs.d_e_l_e_t_=' ' and "
	cQuery+= "not exists (select 1  from "+retSqlName("SB1")+" sb1, "+retSqlName("SD1") +"sd1 ,"+ retSqlName("SF4")+" sf4 "  
	cQuery+= "					  where sb1.b1_cod = d1_cod and "
	cQuery+= "					  d1_filial = '01' and "
	cQuery+= "					  f4_filial = '01' and "
	cQuery+= "					  sd1.d1_tes = f4_codigo and " 
	cQuery+= "					  f4_estoque = 's' and "
	cQuery+= "					  d1_dtdigit >= '"+dtos(dDtFrom)+"' and d1_dtdigit <= '"+dtos(dDtUtil)+"' and " 
	cQuery+= "					  d1_origlan <> 'LF' and "
	cQuery+= "					  d1_local = '01' and "
	cQuery+= "					  sd1.d_e_l_e_t_=' ' and " 
	cQuery+= "					  sf4.d_e_l_e_t_=' ' and "
	cQuery+= "					  sb1.b1_cod = sb1exs.b1_cod and "  
	cQuery+= "					  sb1.b1_filial = '"+xFilial("SB1")+"' and "
	cQuery+= "					  sb1.b1_cod <> 'prod. importado' and  "
	cQuery+= "					  sb1.d_e_l_e_t_=' ') and  "
	cQuery+= "not exists (select 1  from "+retSqlName("SB1")+" sb1 , "+retSqlName("SD2")+" sd2 , "+retSqlName("SF4")+" sf4 "  
	cQuery+= "					  where sb1.b1_cod = d2_cod and "
	cQuery+= "					  d2_filial = '"+xFilial("SD2")+"' and "
	cQuery+= "					  f4_filial = '"+xFilial("SF4")+"' and "
	cQuery+= "					  sd2.d2_tes = f4_codigo and " 
	cQuery+= "					  f4_estoque = 's' and "
	cQuery+= "					  d2_emissao >= '"+dtos(dDtFrom)+"' and " 
	cQuery+= "					  d2_emissao <= '"+dtos(dDtUtil)+"' and "
	cQuery+= "					  d2_origlan <> 'LF' and "
	cQuery+= "					  d2_local = '01' and "
	cQuery+= "					  sd2.d_e_l_e_t_=' ' and " 
	cQuery+= "					  sf4.d_e_l_e_t_=' ' and "
	cQuery+= "					  sb1.b1_cod = sb1exs.b1_cod and "  
	cQuery+= "					  sb1.b1_filial = '"+xFilial("SB1")+"' and "
	cQuery+= "					  sb1.b1_cod <> 'prod. importado' and "  
	cQuery+= "					  sb1.d_e_l_e_t_=' ') and "
	cQuery+= "not exists (select 1  from "+RetSqlName("SB1")+" sb1 , "+RetSqlName("SD3")+" sd3 "  
	cQuery+= "			where sb1.b1_cod = d3_cod and "
	cQuery+= "			d3_filial = '"+xFilial("SD3")+"'  and  "
	cQuery+= "			d3_emissao >= '"+dtos(dDtFrom)+"' and d3_emissao <= '"+dtos(dDtUtil)+"' and " 
	cQuery+= "			d3_estorno <> 's' and "
	cQuery+= "			d3_local = '01' and "
	cQuery+= "			sd3.d_e_l_e_t_=' ' and " 
	cQuery+= "			sb1.b1_cod = sb1exs.b1_cod and "  
	cQuery+= "			sb1.b1_filial = '"+xFilial("SB1")+"' and "
	cQuery+= "			sb1.b1_cod <> 'prod. importado' and "  
	cQuery+= "			sb1.d_e_l_e_t_=' ') "

return cQuery


/*/{Protheus.doc} addLine

Cria a lina ‡ ser impressa no arquivo txt
	
@author Daniel Braga
@since 30/10/2014

/*/

method addLine()  class DHLSafx10Dis
	local aTypeFlow		:= {} 
	local aSupCus		:= {}
	local aNfRef		:= {}
	local cCod 			:= ""
	local cBranch		:= ""
	local cDoc			:= ""
	local cSer			:= ""
	local cProduct		:= ""
	local cCodDoc		:= ""
	local lHasDoc		:= .f.
	
	cCod	:= ::getFieldValue("CLIEFOR")
	cBranch	:= ::getFieldValue("LOJA")   
	
	if ::getFieldValue("ARQ") == "SD3"
		if !empty(::getFieldValue("NUM_DOCFIS_OFIC"))
			lHasDoc	:= .t.
			cDoc		:= ::getFieldValue("NUM_DOCFIS_OFIC")
			cSer		:= ::getFieldValue("SERIE_DOCFIS_OFIC")
			cProduct	:= ::getFieldValue("COD_PRODUTO")
			aNfRef 		:= ::getRefItem("2",cDoc,cSer,cProduct)
			cCod 		:= ::getFieldValue("D2_CLIENTE", aNfRef)
			cBranch		:= ::getFieldValue("D2_LOJA", aNfRef)
			aInOutFlows := ::getFlowsRecord("2",cDoc, cSer,cCod,cBranch)
		endif
	else
		cDoc		:= ::getFieldValue("NUM_DOCTO")
		cSer		:= ::getFieldValue("SERIE_DOCFIS")
		cType 		:= ::getTypeDoc(cDoc, cSer,cCod,cBranch)
		aInOutFlows := ::getFlowsRecord(cType,cDoc, cSer,cCod,cBranch)
	endif

	aTypeFlow		:= ::getTypeInOutFlow(iif(::getFieldValue("ARQ") == "SD3" .and. lHasDoc, ::getFieldValue("D2_TES", aNfRef), ::getFieldValue("TES")))
	
	cCodDoc := ::getCodDocto(lHasDoc)		
   
   ::addField(COD_EMPRESA			, alltrim(GetNewPar("ZZ_IDEMPDW", "SOL")))
   ::addField(COD_ESTAB				, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp())))
   ::addField(MOVTO_E_S				, ::getFieldValue("MOVTO_E_S") )
   ::addField(NORM_DEV				, ::getFieldValue("NORM_DEV"))
   ::addField(GRUPO_CONTAGEM		, ::getGrupoCont()) 
   ::addField(COD_DOCTO				, cCodDoc)
   ::addField(DATA_MOVTO			, iif((::getFieldValue("ARQ") == "SD3" .and. lHasDoc) .or. (::getFieldValue("ARQ") == "SD2"), ::getFieldValue("F2_EMINFE", aInOutFlows), ::getFieldValue("DATA_MOVTO")))
   ::addField(NUM_DOCTO				, iif(::getFieldValue("ARQ") == "SD3" .and. !empty(::getFieldValue("NUM_ORDEM")),::getFieldValue("NUM_ORDEM"), ::getFieldValue("NUM_DOCTO")))
   ::addField(SERIE_DOCFIS			, iif(::getFieldValue("ARQ") == "SD3", ' ', ::getFieldValue("SERIE_DOCFIS")))
   ::addField(IND_PRODUTO			, ::getProdType(::getFieldValue("TP_IND_PRODUTO")))
   ::addField(COD_PRODUTO			, ::getFieldValue("COD_PRODUTO"))
   ::addField(COD_UND_PADRAO		, ::getFieldValue("COD_UND_PADRAO"))
   ::addField(COD_ALMOX				, ::getFieldValue("COD_ALMOX"))
   ::addField(COD_CUSTO				, ::getFieldValue("COD_CUSTO"))
   ::addField(NUM_ITEM				, iif(::getFieldValue("ARQ") == "SD3" .and. lHasDoc, iif(empty(::getFieldValue("D2_ITEM", aNfRef)), '01', ::getFieldValue("D2_ITEM", aNfRef)),; 
   									  ::getFieldValue("NUM_ITEM")))
   //::addField(COD_NAT_ESTOQUE		, posicione("SB1",1,xFilial("SB1")+::getFieldValue("COD_PRODUTO"),"B1_TIPO") )
   ::addField(COD_NAT_ESTOQUE		, iif(::getFieldValue("ARQ") == "SD3" .and. alltrim(::getFieldValue("NUM_DOCTO")) $ "INVENT", "02", iif(::getFieldValue("F4_PODER3", aTypeFlow) == "N", "02", "03")))
   ::addField(QTD_MOVTO				, ::getFieldValue("QTD_MOVTO"))
   ::addField(PRECO_UNIT			, ::getFieldValue("PRECO_UNIT"))
   ::addField(PRECO_ITEM			, ::getFieldValue("PRECO_ITEM"))
   ::addField(CUSTO_UNIT			, ::getFieldValue("CUSTO_UNIT"))
   ::addField(CUSTO_ITEM			, ::getFieldValue("CUSTO_ITEM"))
   ::addField(COD_CONTA_CRED		, ::getFieldValue("COD_CONTA_CRED"))
   ::addField(COD_CONTA_DEBITO		, ::getFieldValue("COD_CONTA_DEBITO"))
   ::addField(COD_OPERACAO			, "")
   ::addField(COD_CFO				, iif(::getFieldValue("ARQ") == "SD3" , iif(lHasDoc,::getFieldValue("D2_CF", aNfRef), ' '),::getFieldValue("COD_CFO")))
   ::addField(VLR_IPI				, iif(alltrim(::getFieldValue("F4_LFIPI", aTypeFlow)) == 'T', ::getFieldValue("VLR_IPI"), ' '))
   ::addField(DATA_ESCRITA_FIS		, ::getFieldValue("DATA_ESCRITA_FIS"))
   ::addField(COD_MEDIDA			, ::getFieldValue("COD_MEDIDA"))
   ::addField(COD_NBM				, ::getFieldValue("COD_NBM"))
   ::addField(COD_LEGENDA			, "")
   ::addField(NUM_ORDEM				, ::getFieldValue("NUM_ORDEM"))
   ::addField(NUM_DOCFIS_OFIC		, iif(::getFieldValue("ARQ") == "SD3", ::getFieldValue("NUM_DOCFIS_OFIC"),' '))
   ::addField(SERIE_DOCFIS_OFIC		, iif(::getFieldValue("ARQ") == "SD3", ::getFieldValue("SERIE_DOCFIS_OFIC"),' '))
   ::addField(IND_FIS_JUR			, ::getIndFisJur(aNfRef))  
   ::addField(COD_FIS_JUR			, alltrim(GetNewPar("ZZ_CDEMPDW", FwCodEmp()))+cCod+cBranch)
   ::addField(IND_TP_MOVTO			, ::getFieldValue("IND_TP_MOVTO"))
   ::addField(INSC_ESTADUAL			, ' ') 
   ::addField(IND_PRODUTO_RASTRO	, ::getProdType(::getFieldValue("IND_PRODUTO_RASTRO")))
   ::addField(COD_PRODUTO_RASTRO	, ::getFieldValue("COD_PRODUTO_RASTRO"))
   ::addField(VLR_ICMS				, ::getFieldValue("VLR_ICMS"))
   ::addField(IND_DOC_OPER			, ::getFieldValue("IND_DOC_OPER"))
   ::addField(VLR_CUSTO_DCA			, ::getFieldValue("CUSTO"))
   ::addField(COD_DIF_PRODUCAO		, ::getFieldValue("COD_DIF_PRODUCAO"))
   ::addField(DSC_FINALIDADE		, iif(::getFieldValue("ARQ") == "SD3", iif(lHasDoc, ::getFieldValue("F4_FINALID", aTypeFlow), ' '), ::getFieldValue("DSC_FINALIDADE")))

	::notFieldRequired()


return

/*/{Protheus.doc} getIndFisJur

Regra da coluna IND_FIS_JUR
	
@author Daniel Braga
@since 30/10/2014

@return string valor do campo IND_FIS_JUR
/*/
method getIndFisJur(aNfRef) class DHLSafx10Dis
	
	local cFile		:= ::getFieldValue("ARQ")
	local cType		:= ::getFieldValue("NORM_DEV")
	local cCusSup	:= ::getFieldValue("CLIEFOR")
	local cBranch	:= ::getFieldValue("LOJA")
	
	if cFile == "SD1"
		if cType $ SAFX_MOVIMENTO_DEVOLUCAO
			return posicione("SA1",1,xFilial("SA1")+cCusSup+cBranch,"A1_ZZINDDW")
		else
			return posicione("SA2",1,xFilial("SA2")+cCusSup+cBranch,"A2_ZZINDDW")
		endIf
	elseIf cFile == "SD2"
		If !cType $ SAFX_MOVIMENTO_DEVOLUCAO
			return posicione("SA1",1,xFilial("SA1")+cCusSup+cBranch,"A1_ZZINDDW")
		else
			return posicione("SA2",1,xFilial("SA2")+cCusSup+cBranch,"A2_ZZINDDW")
		endIf
	elseif cFile == "SD3"
		if !empty(::getFieldValue("NUM_DOCFIS_OFIC"))
			cCusSup := ::getFieldValue("D2_CLIENTE", aNfRef)
			cBranch	:= ::getFieldValue("D2_LOJA", aNfRef)
			if !cType $ SAFX_MOVIMENTO_DEVOLUCAO
				return posicione("SA1",1,xFilial("SA1")+cCusSup+cBranch,"A1_ZZINDDW")
			else
				return posicione("SA2",1,xFilial("SA2")+cCusSup+cBranch,"A2_ZZINDDW")
			endif
		endif
	endIf

return ""

/*/{Protheus.doc} getInstEst

Regra do campo INSC_ESTUADUAL
	
@author Daniel Braga
@since 30/10/2014

@return string inscricao estadual
/*/
method getInscEst() class DHLSafx10Dis

	local cFile			:= ::getFieldValue("ARQ")
	local cCusSup			:= ::getFieldValue("CLIEFOR")
	local cBranch			:= ::getFieldValue("LOJA")
	local cIE				:= ""
	
	if cFile  == "SD1"
		cIE	 := posicione("SA2",1,xFilial("SA2")+cCusSup+cBranch,"A2_INSCR")	
	elseIf cFile == "SD2"
		cIE	 := posicione("SA1",1,xFilial("SA1")+cCusSup+cBranch,"A1_INSCR")
	endIf
	
return cIE 


/*/{Protheus.doc} getGrupoCont

Regra do campo GRUPO_CONTAGEM
	
@author Daniel Braga
@since 30/10/2014

@return string retorno do resultado da regra
/*/
method getGrupoCont() class DHLSafx10Dis

	local cFile			:= ::getFieldValue("ARQ")
	local cTypeFlow		:= ::getFieldValue("TES")
	local c3rdParty		:= ::getFieldValue("PODER3")
	local cGroup			:= ""
	
	if cFile  == "SD1"
		cGroup := Iif( c3rdParty $ "RD" , "2" , "5" )
	elseIf cFile == "SD2"
		cGroup := Iif( c3rdParty $ "RD" , "3" , "5" )
	elseIf cFile == "SD3"
		cGroup := "5"
	endIf 


return cGroup

method notFieldRequired() class DHLSafx10Dis
   

	 ::addField(SUB_SERIE_DOCFIS, ' ')
    ::addField(CONTRATO, ' ')
    ::addField(SERIE_ITEM, ' ')
    ::addField(COD_ENT_SAIDA, ' ')
    ::addField(OBS_ESTOQUE, ' ')
    ::addField(IND_INSUMO, ' ')
    ::addField(S_SERIE_DOCFIS_OFIC, ' ')
    ::addField(IND_TP_MOVTO, ' ')
    ::addField(DATA_DISP, ' ')
    ::addField(IND_TP_DOC_INTERNO, ' ')
    ::addField(IND_REDESIGNACAO, ' ')
    ::addField(IND_PRODUTO_ORI, ' ')
    ::addField(COD_PRODUTO_ORI, ' ')
    ::addField(VLR_OUT_TRIB_NCUMUL, ' ')
    ::addField(COD_TP_LANCTO, ' ')
    ::addField(VLR_ICMS_DCA, ' ')
    ::addField(COD_TIPO_MOV_EST, ' ')
    ::addField(COD_MEDIDA_ORI, ' ')
    ::addField(COD_NIVEL_PRODUTO, ' ')
    ::addField(QTD_INSUMO, ' ')


return


/*/{Protheus.doc} getCodDocto

Regra para campo COD_DOCTO
	
@author Thiago Meschiatti
@since 06/03/2015

@return string retorno do resultado da regra
/*/
method getCodDocto(lHasDoc) class DHLSafx10Dis
	local cRet := ""
	
	if alltrim(::getFieldValue("NUM_DOCTO")) $ "INVENT"
		cRet := "DOC"
	elseif ::getFieldValue("ARQ") == "SD3" .and. !lHasDoc
		cRet := "OP"
	elseif alltrim(::getFieldValue("SERIE_DOCFIS")) $ DHL_ESPECIE_INVENTARIO .or. ;
			alltrim(::getFieldValue("SERIE_DOCFIS_OFIC")) $ DHL_ESPECIE_INVENTARIO
		cRet := "INV"
	else
		cRet := "NFE"
	endif
return (cRet)