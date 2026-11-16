#Include 'Protheus.ch'

/*/{Protheus.doc} RelNfCob

Relatório de notas fiscais sem cobertura.
	
@author Diego de Angelo
@since 17/11/2014

/*/
user function RelNfCob()

	local bParams			:= {|| oParamBox:show() }
	local bProcRel		:= {|| procRel() }
	
	private cCliTipo	:= ""
	private cNomeRemet	:= ""
	private cCnpjRemet	:= ""
	
	private cCliForDe	:= ""
	private cCliForAte	:= ""
	
	private cCliCobDe	:= ""
	private cCliCobAte	:= ""
	
	private cLojaDe		:= ""
	private cLojaAte	:= ""
	
	private cLojaCobDe	:= ""
	private cLojaCobAte	:= ""
	
	private cNotaDe		:= ""
	private cNotaAte	:= ""
	
	private cSerieDe	:= ""
	private cSerieAte	:= ""
		
	private cCobNfDe	:= ""
	private cCobNfAte	:= ""
	
	private cCobSerDe	:= ""
	private cCobSerAte	:= ""
	
	private cAnoNfDe		:= ""
	private cAnoNfAte		:= ""
	
	private cCobAnoDe		:= ""
	private cCobAnoAte	:= ""
	
	private cCfopDe		:= ""
	private cCfopAte		:= ""
	
	private cCobCfopDe	:= ""
	private cCobCfopAte	:= ""
	
	private cProdDe		:= ""
	private cProdAte		:= ""
	
	private cCobProdDe	:= ""
	private cCobProdAte	:= ""
	
	private dDtEntDe	:= CTOD("")
	private dDtEntAte	:= CTOD("")

	private dDtCobEnDe	:= CTOD("")
	private dDtCobEnAte	:= CTOD("")	
	
	private dDtEmisDe	:= CTOD("")
	private dDtEmisAte	:= CTOD("")
	
	private dDtCobEmDe	:= CTOD("")
	private dDtCobEmAte	:= CTOD("")     

 //asm	
private dDtDgtDe	:= CTOD("")  
private DDTDGTATE 	:= CTOD("")
private cAnoDe    	:= ""
private CAnoAte     := ""   
private cDocDe 	    := ""
private cDocAte  	:= ""
private cSerieDe	:= ""
private cSerieAte	:= ""
private cCliForDe	:= ""
private cCliForAte	:= ""
private cLojaDe	    := ""
private cLojaAte	:= ""
// asm
	
	private cNotas		:= ""		
	
	private cNome  		:= "RelNfCob"
	private cTitulo		:= "Notas Fiscais sem Cobertura"
	private cDescricao	:= "Relatório de "+cTitulo
	
	private oReport		:= nil
	private oSecNotas		:= nil
	
	private oParamBox 	:= IpParamBoxObject():newIpParamBoxObject(cNome)
	
	private oSqlNotas	:= nil
	
	criaParams()
	
	oReport := TReport():new(cNome, cTitulo, bParams, bProcRel, cDescricao)
	
	criaSecao()
	
	oReport:setLandscape()
	oReport:printDialog()
	
return

/**
* Função responsável pela criação dos parâmetros
*/
static function criaParams()
	
	local oParam 	:= nil
	
	oParamBox:setTitle(cTitulo)
	
	oParam := IpParamObject():newIpParamObject("fornecDe", "get", "Fornecedor de", "C", 60, TamSX3("A2_COD")[1])
	oParam:setF3("SA2A")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("lojaDe", "get", "Loja de", "C", 30, TamSX3("F1_LOJA")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("fornecAte", "get", "Fornecedor até", "C", 60, TamSX3("A2_COD")[1])
	oParam:setF3("SA2A")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("lojaAte", "get", "Loja até", "C", 30, TamSX3("F1_LOJA")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("fornecCobDe", "get", "Fornecedor Cobertura de", "C", 60, TamSX3("A2_COD")[1])
	oParam:setF3("SA2A")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("lojaCobDe", "get", "Loja Cobertura de", "C", 30, TamSX3("F1_LOJA")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("fornecCobAte", "get", "Fornecedor Cobertura até", "C", 60, TamSX3("A2_COD")[1])
	oParam:setF3("SA2A")
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("lojaCobAte", "get", "Loja Cobertura até", "C", 30, TamSX3("F1_LOJA")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("notaDe", "get", "Nota de", "C", 60, TamSX3("F1_DOC")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("notaAte", "get", "Nota até", "C", 60, TamSX3("F1_DOC")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serieDe", "get", "Série de", "C", 60, TamSX3("F1_SERIE")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serieAte", "get", "Série até", "C", 60, TamSX3("F1_SERIE")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("notaCobDe", "get", "Nota Cobertura de", "C", 60, TamSX3("F1_DOC")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("notaCobAte", "get", "Nota Cobertura até", "C", 60, TamSX3("F1_DOC")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serieCobDe", "get", "Série Cobertura de", "C", 60, TamSX3("F1_SERIE")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("serieCobAte", "get", "Série Cobertura até", "C", 60, TamSX3("F1_SERIE")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("anoNfDe", "get", "Ano Nota Fiscal de", "C", 9, 4)
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("anoNfAte", "get", "Ano Nota Fiscal Até", "C", 9, 4)
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("anoCobDe", "get", "Ano NF. Cobertura de", "C", 9, 4)
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("anoCobAte", "get", "Ano NF. Cobertura Até", "C", 9, 4)
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("cfopDe", "get", "CFOP de", "C", 60, TamSX3("F1_SERIE")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("cfopAte", "get", "CFOP até", "C", 60, TamSX3("D1_CF")[1])
	oParamBox:addParam(oParam)

	oParam := IpParamObject():newIpParamObject("cfopCobDe", "get", "CFOP Cobertura de", "C", 60, TamSX3("D1_CF")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("cfopCobAte", "get", "CFOP Cobertura até", "C", 60, TamSX3("D1_CF")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("prodDe", "get", "Produto de", "C", 60, TamSX3("B1_COD")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("prodAte", "get", "Produto até", "C", 60, TamSX3("B1_COD")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("prodCobDe", "get", "Produto Cobertura de", "C", 60, TamSX3("B1_COD")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("prodCobAte", "get", "Produto Cobertura até", "C", 60, TamSX3("B1_COD")[1])
	oParamBox:addParam(oParam)

	oParam := IpParamObject():newIpParamObject("dataEntDe", "get", "Data Entrada de", "D", 60, TamSX3("F1_DTDIGIT")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataEntAte", "get", "Data Entrada até", "D", 60, TamSX3("F1_DTDIGIT")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataEntCobDe", "get", "Dt. Entrada Cobertura de", "D", 60, TamSX3("F1_DTDIGIT")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataEntCobAte", "get", "Dt. Entrada Cobertura Até", "D", 60, TamSX3("F1_DTDIGIT")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataEmisDe", "get", "Data Emissão de", "D", 60, TamSX3("F1_EMISSAO")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataEmisAte", "get", "Data Emissão Até", "D", 60, TamSX3("F1_EMISSAO")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataCobEmisDe", "get", "Dt. Emissão Cobertura de", "D", 60, TamSX3("F1_EMISSAO")[1])
	oParamBox:addParam(oParam)
	
	oParam := IpParamObject():newIpParamObject("dataCobEmisAte", "get", "Dt. Emissão Cobertura Até", "D", 60, TamSX3("F1_EMISSAO")[1])
	oParamBox:addParam(oParam)	
		
	oParam := IpParamObject():newIpParamObject("notas", "combo", "Notas Fiscais", "C", 60)
    oParam:setValues({"C=Cobertas", "S=Sem Cobertura", "A=Ambas","T=Todas NF´s"})
	oParamBox:addParam(oParam)
		
return


/**
* Função responsável pelo processamento do relatório.
*/
static function procRel()
	
	cCliForDe		:= 	oParamBox:getValue("fornecDe")      
	cLojaDe		    := 	oParamBox:getValue("lojaDe")        
	cCliForAte		:= 	oParamBox:getValue("fornecAte")     
	cLojaAte		:= 	oParamBox:getValue("lojaAte")  

	cCliCobDe		:= 	oParamBox:getValue("fornecCobDe")      
	cLjCobDe		:= 	oParamBox:getValue("lojaCobDe")        
	cCliCobAte		:= 	oParamBox:getValue("fornecCobAte")     
	cLjCobAte		:= 	oParamBox:getValue("lojaCobAte")       
	
	cNotaDe		    := 	oParamBox:getValue("notaDe")        
	cNotaAte		:= 	oParamBox:getValue("notaAte")       
	cSerieDe		:= 	oParamBox:getValue("serieDe")    
	cSerieAte		:= 	oParamBox:getValue("serieAte")   
	cCobNfDe		:= 	oParamBox:getValue("notaCobDe")        
	cCobNfAte		:= 	oParamBox:getValue("notaCobAte")       
	cCobSerDe		:= 	oParamBox:getValue("serieCobDe")    
	cCobSerAte		:= 	oParamBox:getValue("serieCobAte")   
	cAnoNfDe		:= 	oParamBox:getValue("anoNfDe")   
	cAnoNfAte		:= 	oParamBox:getValue("anoNfAte")   
	cCobAnoDe		:= 	oParamBox:getValue("anoCobDe")   
	cCobAnoAte		:= 	oParamBox:getValue("anoCobAte")   
	cCfopDe		    := 	oParamBox:getValue("cfopDe")           
	cCfopAte		:= 	oParamBox:getValue("cfopAte")          
	cCobCfopDe		:= 	oParamBox:getValue("cfopCobDe")        
	cCobCfopAte	    := 	oParamBox:getValue("cfopCobAte")       
	cProdDe		    := 	oParamBox:getValue("prodDe")           
	cProdAte		:= 	oParamBox:getValue("prodAte")          
	cCobProdDe		:= 	oParamBox:getValue("prodCobDe")        
	cCobProdAte	    := 	oParamBox:getValue("prodCobAte")       
	dDtEntDe		:= 	oParamBox:getValue("dataEntDe")        
	dDtEntAte		:= 	oParamBox:getValue("dataEntAte")       
	dDtCobEnDe		:= 	oParamBox:getValue("dataEntCobDe")     
	dDtCobEnAte	    := 	oParamBox:getValue("dataEntCobAte")    
	dDtEmisDe		:= 	oParamBox:getValue("dataEmisDe")       
	dDtEmisAte		:= 	oParamBox:getValue("dataEmisAte") 
	dDtCobEmDe		:= 	oParamBox:getValue("dataCobEmisDe")    
	dDtCobEmAte	    :=	oParamBox:getValue("dataCobEmisAte")   
	cNotas			:= 	oParamBox:getValue("notas") 
	
    getNotas()
	
	procImpressao()
	
return


/**
* Função responsável pela criação da seção.
*/
static function criaSecao()
	
	local aOrdem	:= criaIndice()
	
	oSecNotas := TRSection():new(oReport,,,aOrdem)
	
	TRCell():new(oSecNotas, "FILIAL_CLIENTE"	, 		  					, "Cliente(Filial)"		, 	nil									, 20						,,,,,"RIGHT")
	TRCell():new(oSecNotas, "SITE"				,	      					, "Site(Empresa)"			, 	nil									, 20						,,,,,"RIGHT")
	TRCell():new(oSecNotas, "RAZAO_DESTINAT"	, 							, "Razão Social Dest."	, 	nil									, TamSX3("A1_NOME")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "CNPJ_DESTINAT"	    ,							, "CPF/CNPJ Dest."		,	nil									, TamSX3("A1_CGC")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "RAZAO_REMETENT"	, 							, "Razão Social Remet."	,	nil									, TamSX3("A1_NOME")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "CNPJ_REMETENT"	    , 							, "CPF/CNPJ Remet."		,	nil									, TamSX3("A1_CGC")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "ANO_NF"			, 							, "Ano Nota Fiscal"		, 	nil									, 4							,,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_DOC"			, 							, "Nota Fiscal"			, 	nil									, TamSX3("F1_DOC")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_TES"			, 							, "TES"					, 	nil									, TamSX3("D1_TES")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_SERIE"			,							, "Série"					, 	nil									, TamSX3("F1_SERIE")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_CF"				,							, "CFOP"					, 	nil									, TamSX3("D1_CF")[1]		,,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_DTDIGIT"		,							, "Data Entrada"			, 	nil									, TamSX3("F1_DTDIGIT")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_EMISSAO"		,							, "Data Emissão"			, 	nil									, TamSX3("F1_EMISSAO")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "F1_VALBRUT"		,							, "Valor Total NF."		, 	PesqPict("SF1", "F1_VALBRUT")	, TamSX3("F1_VALBRUT")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_COD"			,							, "Cod. Produto"			, 	PesqPict("SD1", "D1_COD")		, TamSX3("D1_COD")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "B1_POSIPI"		    ,							, "NCM"					, 	PesqPict("SB1", "B1_POSIPI")	, TamSX3("B1_POSIPI")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "B1_DESC"			,							, "Ref. Produto"			, 	PesqPict("SB1", "B1_DESC")		, TamSX3("B1_DESC")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_UM"				,							, "Unidade"				, 	PesqPict("SD1", "D1_UM")			, TamSX3("D1_UM")[1]		,,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_QUANT"			,							, "Quantidade"			, 	PesqPict("SD1", "D1_QUANT")		, TamSX3("D1_QUANT")[1]	,,,,,"RIGHT")
//ACRESCENTADO POR EDSON DELUCA - FIT GESTAO
	TRCell():new(oSecNotas, "D1_BASEIPI"	    ,							, "Base IPI"	   	    , 	PesqPict("SD1", "D1_BASEIPI")	, TamSX3("D1_BASEIPI")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_BASEICM"		,							, "Base ICMS"		    , 	PesqPict("SD1", "D1_BASEICM")	, TamSX3("D1_BASEICM")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_BRICMS"			,							, "Base ST"		        , 	PesqPict("SD1", "D1_BRICMS")	, TamSX3("D1_BRICMS")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_VALIPI"			,							, "Valor IPI"		    , 	PesqPict("SD1", "D1_VALIPI")	, TamSX3("D1_VALIPI")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_VALICM"			,							, "Valor Icms"		    , 	PesqPict("SD1", "D1_VALICM")	, TamSX3("D1_VALICM")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_ICMSRET"		,							, "Valor ST"		    , 	PesqPict("SD1", "D1_ICMSRET")	, TamSX3("D1_ICMSRET")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_VALANTI"		,							, "Valor ICMS Ant."		, 	PesqPict("SD1", "D1_VALANTI")	, TamSX3("D1_VALANTI")[1],,,,,"RIGHT")
//FIM DE ALTERAÇÃO - EDSON DELUCA - FIT GESTAO
	TRCell():new(oSecNotas, "D1_VUNIT"			,							, "Valor Unitário"		, 	PesqPict("SD1", "D1_VUNIT")		, TamSX3("D1_VUNIT")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "D1_TOTAL"			,							, "Valor Total"			, 	PesqPict("SD1", "D1_TOTAL")		, TamSX3("D1_TOTAL")[1]	,,,,,"RIGHT")

	TRCell():new(oSecNotas, "RAZAO_REMETENT_COB", 						    , "Razão Social Remet. Cobertura"	,	nil									, TamSX3("A1_NOME")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "CNPJ_REMETENT_COB"	, 						    , "CPF/CNPJ Remet. Cobertura"		,	nil									, TamSX3("A1_CGC")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "ANO_NF_COB"		, 							, "Ano Nota Fiscal Cobertura"		, 	nil									, 4							,,,,,"RIGHT")		
	TRCell():new(oSecNotas, "COB_DOC"			, 							, "Nota Fiscal Cobertura"			, 	nil									, TamSX3("F1_DOC")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_TES"			, 							, "TES Cobertura"						, 	nil									, TamSX3("D1_TES")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_SERIE"		    ,						    , "Série Cobertura"					, 	nil									, TamSX3("F1_SERIE")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_CF"			,							, "CFOP Cobertura"					, 	nil									, TamSX3("D1_CF")[1]		,,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_DTDIGIT"		,							, "Data Entrada Cobertura"			, 	nil									, TamSX3("F1_DTDIGIT")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_EMISSAO"		,							, "Data Emissão Cobertura"			, 	nil									, TamSX3("F1_EMISSAO")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_VALBRUT"		,							, "Valor Total NF. Cobertura"		, 	PesqPict("SF1", "F1_VALBRUT")	, TamSX3("F1_VALBRUT")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_COD"			,							, "Cod. Produto Cobertura"			, 	PesqPict("SD1", "D1_COD")		, TamSX3("D1_COD")[1]	,,,,,"RIGHT")	
	TRCell():new(oSecNotas, "COB_QUANT"		,							, "Quantidade Cobertura"				, 	PesqPict("SD1", "D1_QUANT")		, TamSX3("D1_QUANT")[1]	,,,,,"RIGHT")
//ACRESCENTADO POR EDSON DELUCA - FIT GESTAO
	TRCell():new(oSecNotas, "COB_BASEIPI"	    ,							, "Base IPI Cobertura"       , 	PesqPict("SD1", "D1_BASEIPI")	, TamSX3("D1_BASEIPI")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_BASEICM"		,							, "Base ICMS Cobertura"		 , 	PesqPict("SD1", "D1_BASEICM")	, TamSX3("D1_BASEICM")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_BRICMS"		,							, "Base ST Cobertura"		 , 	PesqPict("SD1", "D1_BRICMS")	, TamSX3("D1_BRICMS")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_VALIPI"		,							, "Valor IPI Cobertura"		 , 	PesqPict("SD1", "D1_VALIPI")	, TamSX3("D1_VALIPI")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_VALICM"		,							, "Valor Icms Cobertura"	 , 	PesqPict("SD1", "D1_VALICM")	, TamSX3("D1_VALICM")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_ICMSRET"		,							, "Valor ST Cobertura"		 , 	PesqPict("SD1", "D1_ICMSRET")	, TamSX3("D1_ICMSRET")[1],,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_VALANTI"		,							, "Valor ICMS Ant. Cobertura", 	PesqPict("SD1", "D1_VALANTI")	, TamSX3("D1_VALANTI")[1],,,,,"RIGHT")
//FIM DE ALTERAÇÃO - EDSON DELUCA - FIT GESTAO
	TRCell():new(oSecNotas, "COB_VUNIT"		,							, "Valor Unitário Cobertura"		, 	PesqPict("SD1", "D1_VUNIT")		, TamSX3("D1_VUNIT")[1]	,,,,,"RIGHT")
	TRCell():new(oSecNotas, "COB_TOTAL"		,							, "Valor Total Cobertura"			, 	PesqPict("SD1", "D1_TOTAL")		, TamSX3("D1_TOTAL")[1]	,,,,,"RIGHT")		
return


/**
* Processamento da Impressão
*/
static function procImpressao()
	local aFilEmp	:= FWArrFilAtu(cEmpAnt, cFilAnt)
	local cNomeFil	:= aFilEmp[SM0_NOME]
	local cDescEmp	:= aFilEmp[SM0_NOMECOM]
	local cUnidNeg	:= aFilEmp[SM0_DESCUN]
	local cCnpj		:= Transform(aFilEmp[SM0_CGC], "@R 99.999.999/9999-99")
	
	oSecNotas:cAlias	:= oSqlNotas:getAlias()
	oReport:startPage()
	
	oSecNotas:init()
	
	oSqlNotas:setField("F1_DTDIGIT", "D")
	oSqlNotas:setField("F1_EMISSAO", "D")
	
	oSqlNotas:setField("COB_DTDIGIT", "D")
	oSqlNotas:setField("COB_EMISSAO", "D")

	while oSqlNotas:notIsEof()
		
		if cNotas == "S"
			if !empty(oSqlNotas:getValue("COB_DOC"))
				oSqlNotas:skip()
				loop
			endIf
		else
			retInfCliForn(oSqlNotas:getValue("COB_FORNECE"), oSqlNotas:getValue("COB_LOJA"),oSqlNotas:getValue("COB_TIPO") )
			oSecNotas:Cell("RAZAO_REMETENT_COB"):setValue(cNomeRemet)
			oSecNotas:Cell("CNPJ_REMETENT_COB"):setValue(cCnpjRemet)
			oSecNotas:Cell("ANO_NF_COB"):setValue(cValToChar(Year(oSqlNotas:getValue("COB_EMISSAO"))))
		endIf
		
		oSecNotas:Cell("ANO_NF"):setValue(cValToChar(Year(oSqlNotas:getValue("F1_EMISSAO"))))
					
		oSecNotas:Cell("FILIAL_CLIENTE"):setValue(cNomeFil)
		oSecNotas:Cell("SITE"):setValue(cUnidNeg)
		
		oSecNotas:Cell("RAZAO_DESTINAT"):setValue(cDescEmp)
		oSecNotas:Cell("CNPJ_DESTINAT"):setValue(cCnpj)
		
		retInfCliForn(oSqlNotas:getValue("F1_FORNECE"), oSqlNotas:getValue("F1_LOJA"), oSqlNotas:getValue("F1_TIPO"))
		
		oSecNotas:Cell("RAZAO_REMETENT"):setValue(cNomeRemet)
		oSecNotas:Cell("CNPJ_REMETENT"):setValue(cCnpjRemet)
						
		oSecNotas:printLine()
		
		oSqlNotas:skip()
		
	endDo
	
	oSecNotas:finish()
	oSqlNotas:close()
return


/*
*	Função responsável pelo retorno do nome e cnpj do remetende
*/
static function retInfCliForn(cCod, cLoja, cTipoNota)
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	
	if cTipoNota $ "DB"
		oSqlUtil:newTable("SA1", "A1_NOME, A1_CGC, A1_PESSOA", "A1_FILIAL = '%SA1.FILIAL%' AND A1_COD = '"+cCod+"' AND A1_LOJA = '"+cLoja+"'")
		cNomeRemet	:= oSqlUtil:getValue("A1_NOME")
		cCnpjRemet	:= oSqlUtil:getValue("A1_CGC")
		cCliTipo	:= oSqlUtil:getValue("A1_PESSOA")
	else
		oSqlUtil:newTable("SA2", "A2_NOME, A2_CGC, A2_TIPO", "A2_FILIAL = '%SA2.FILIAL%' AND A2_COD = '"+cCod+"' AND A2_LOJA = '"+cLoja+"'")
		cNomeRemet	:= oSqlUtil:getValue("A2_NOME")
		cCnpjRemet	:= oSqlUtil:getValue("A2_CGC")
		cCliTipo	:= oSqlUtil:getValue("A2_TIPO")
	endIf
	oSqlUtil:close()
	cCnpjRemet	:= Transform(cCnpjRemet,Substr(PicPes(cCliTipo),1,at("%",PicPes(cCliTipo))-1))
return


/*
*	Função responsável pela criação do indice.
*/
static function criaIndice()
	local aOrdem	:= {}
	
	aADD(aOrdem, "Numero + Serie + Fornecedor + Loja + Tipo da Nota")
	aADD(aOrdem, "Fornecedor + Loja + Numero Documento")
return aOrdem


/*
*	Função responsável pelo retorno da consulta SQL completa
**/
static function getNotas()
	local nIndice	:= oSecNotas:getOrder()
	local cQuery	:= ""
	local cQryNota  := IIF(cNotas<>"T",retQryCob(cCliForDe, cCliForAte, cLojaDe, cLojaAte, cNotaDe	, cNotaAte		, cSerieDe		, cSerieAte	, cProdDe		, cProdAte		, "1", dDtEntDe	, dDtEntAte, dDtEmisDe, dDtEmisAte, cAnoNfDe, cAnoNfAte, cCfopDe, cCfopAte),getSD1())
	local cQryCob	:= retQryCob(cCliCobDe, cCliCobAte, cLjCobDe, cLjCobAte, cCobNfDe, cCobNfAte	, cCobSerDe	, cCobSerAte	, cCobProdDe	, cCobProdAte	, "2", dDtCobEnDe	, dDtCobEnAte, dDtCobEmDe, dDtCobEmAte, cCobAnoDe, cCobAnoAte, cCobCfopDe, cCobCfopAte)
	 
	cQuery	:= "SELECT 
	cQuery	+= "	NOTAS.F1_FILIAL," + CRLF
	cQuery	+= "	NOTAS.F1_TIPO," + CRLF
	cQuery	+= "	NOTAS.F1_DTDIGIT," + CRLF
	cQuery	+= "	COB.F1_DTDIGIT COB_DTDIGIT," + CRLF
	cQuery	+= "	COB.F1_TIPO COB_TIPO," + CRLF	
	cQuery	+= "	NOTAS.F1_FORNECE," + CRLF
	cQuery	+= "	COB.F1_FORNECE COB_FORNECE," + CRLF
	cQuery	+= "	NOTAS.F1_LOJA," + CRLF
	cQuery	+= "	COB.F1_LOJA COB_LOJA," + CRLF	
	cQuery	+= "	NOTAS.D1_TES," + CRLF
	cQuery	+= "	NOTAS.D1_UM," + CRLF
	cQuery	+= "	COB.D1_TES COB_TES," + CRLF	
	cQuery	+= "	NOTAS.F1_EMISSAO ," + CRLF
	cQuery	+= "	COB.F1_EMISSAO COB_EMISSAO," + CRLF
	cQuery	+= "	NOTAS.D1_DOC," + CRLF  //MUDADO DE Z4_DOC PARA D1_DOC
	cQuery	+= "	COB.D1_DOC COB_DOC," + CRLF
	cQuery	+= "	NOTAS.D1_SERIE," + CRLF //MUDADO DE Z4_SERIE PARA D1_SERIE
	cQuery	+= "	COB.D1_SERIE COB_SERIE," + CRLF
	cQuery	+= "	NOTAS.D1_CF," + CRLF
	cQuery	+= "	COB.D1_CF COB_CF," + CRLF	
	cQuery	+= "	NOTAS.F1_VALBRUT," + CRLF
	cQuery	+= "	COB.F1_VALBRUT COB_VALBRUT," + CRLF
	cQuery	+= "	NOTAS.D1_COD," + CRLF
	cQuery	+= "	COB.D1_COD COB_COD," + CRLF
	cQuery	+= "	NOTAS.B1_POSIPI," + CRLF
	cQuery	+= "	COB.B1_POSIPI COB_POSIPI," + CRLF
	cQuery	+= "	NOTAS.B1_DESC," + CRLF
	cQuery	+= "	COB.B1_DESC COB_DESC," + CRLF
	cQuery	+= "	NOTAS.B1_UM," + CRLF
	cQuery	+= "	COB.B1_UM COB_UM," + CRLF		
	cQuery	+= "	NOTAS.D1_QUANT," + CRLF
	cQuery	+= "	COB.D1_QUANT COB_QUANT," + CRLF		
	cQuery	+= "	NOTAS.D1_BASEIPI," + CRLF
	cQuery	+= "	COB.D1_BASEIPI COB_BASEIPI," + CRLF		
	cQuery	+= "	NOTAS.D1_BASEICM," + CRLF
	cQuery	+= "	COB.D1_BASEICM COB_BASEICM," + CRLF		
	cQuery	+= "	NOTAS.D1_BRICMS," + CRLF
	cQuery	+= "	COB.D1_BRICMS COB_BRICMS," + CRLF		
	cQuery	+= "	NOTAS.D1_VALIPI," + CRLF
	cQuery	+= "	COB.D1_VALIPI COB_VALIPI," + CRLF		
	cQuery	+= "	NOTAS.D1_VALICM," + CRLF
	cQuery	+= "	COB.D1_VALICM COB_VALICM," + CRLF		
	cQuery	+= "	NOTAS.D1_ICMSRET," + CRLF
	cQuery	+= "	COB.D1_ICMSRET COB_ICMSRET," + CRLF		
	cQuery	+= "	NOTAS.D1_VALANTI," + CRLF
	cQuery	+= "	COB.D1_VALANTI COB_VALANTI," + CRLF		
	cQuery	+= "	NOTAS.D1_VUNIT," + CRLF
	cQuery	+= "	COB.D1_VUNIT COB_VUNIT," + CRLF		
	cQuery	+= "	NOTAS.D1_TOTAL," + CRLF
	cQuery	+= "	COB.D1_TOTAL COB_TOTAL " + CRLF		
	cQuery	+= " FROM ("+cQryNota+") NOTAS " + CRLF
    
    If cNotas=="T"
	   cQuery  += "INNER JOIN "+RetSqlName("SF4")+" F4 ON F4.F4_FILIAL = NOTAS.F1_FILIAL AND F4.F4_CODIGO = NOTAS.D1_TES AND F4.D_E_L_E_T_<>'*' "  
    endIf
	
	if cNotas == "C"
	   cQuery	+= " INNER JOIN ("+cQryCob+") COB ON " + CRLF
	   cQuery	+= "	COB.Z4_IDCOB = NOTAS.Z4_IDCOB " + CRLF
	else 
	   cQuery	+= " LEFT JOIN ("+cQryCob+") COB ON " + CRLF
	   cQuery	+= "	COB.Z4_IDCOB = NOTAS.Z4_IDCOB " + CRLF
	EndIf
	
	//cQuery += "    WHERE NOTAS.D1_TES <> '   ' " + CRLF
    //Emerson Holanda 26/07/21
	cQuery += "    WHERE (NOTAS.D1_TES <> '   ' OR NOTAS.D1_TES = '   ') " + CRLF
    If cNotas=="T"
       cQuery += "    AND (F4.F4_LFICM<>'N' OR F4.F4_LFIPI<>'N') "
    EndIf
	
	cQuery	+= " ORDER BY" +CRLF
	if nIndice == 1	
		cQuery	+= " NOTAS.F1_FILIAL, NOTAS.D1_DOC, NOTAS.D1_SERIE, NOTAS.F1_FORNECE, NOTAS.F1_LOJA, NOTAS.F1_TIPO" +CRLF
	else
		cQuery	+= " NOTAS.F1_FILIAL, NOTAS.F1_FORNECE, NOTAS.F1_LOJA, NOTAS.D1_DOC" +CRLF
	endIf
	//Conout("query RelNfcob getNotas: "+cQuery)	
	oSqlNotas	:= IpSqlObject():newIpSqlObject()
	oSqlNotas:newAlias(cQuery)
return


/*
*	Função responsável pela montagem da consulta SQL para notas de cobertura
**/
static function retQryCob(cCliForDe, cCliForAte,cLojaDe, cLojaAte, cDocDe, cDocAte, cSerieDe, cSerieAte, cProdDe, cProdAte, cTipo, dDtDgtDe, dDtDgtAte, dDtEmisDe, dDtEmisAte, cAnoDe, cAnoAte, cCfopDe, cCfopAte)

	local cQuery	:= ""
	
	cQuery	:= "SELECT * " + CRLF 
	cQuery	+= "FROM " + CRLF
	cQuery	+= "	%SZ4.SQLNAME%  " + CRLF
	cQuery	+= "INNER JOIN %SD1.SQLNAME% ON " + CRLF
	cQuery	+= "	SD1.D1_FILIAL = SZ4.Z4_FILIAL " + CRLF
	cQuery	+= "	AND %SD1.NOTDEL% " + CRLF
	cQuery	+= "	AND SD1.D1_DOC = SZ4.Z4_DOC" + CRLF
	cQuery	+= "	AND SD1.D1_SERIE = SZ4.Z4_SERIE" + CRLF
	cQuery	+= "	AND SD1.D1_FORNECE= SZ4.Z4_CLIFOR" + CRLF
	cQuery	+= "	AND SD1.D1_LOJA = SZ4.Z4_LOJA " + CRLF
	cQuery	+= "	AND SD1.D1_COD = SZ4.Z4_PRODUTO" + CRLF
	cQuery	+= "	AND SD1.D1_CF  >= '"+cCfopDe+"'" + CRLF
	cQuery	+= "	AND SD1.D1_CF  <= '"+cCfopAte+"'" + CRLF
	cQuery	+= "INNER JOIN %SF1.SQLNAME% ON " + CRLF
	cQuery	+= "	SF1.F1_FILIAL = SZ4.Z4_FILIAL " + CRLF
	cQuery	+= "	AND %SF1.NOTDEL% " + CRLF
	cQuery	+= "	AND SF1.F1_DOC = SZ4.Z4_DOC" + CRLF
	cQuery	+= "	AND SF1.F1_SERIE = SZ4.Z4_SERIE" + CRLF
	cQuery	+= "	AND SF1.F1_FORNECE = SZ4.Z4_CLIFOR" + CRLF
	cQuery	+= "	AND SF1.F1_LOJA = SZ4.Z4_LOJA " + CRLF
	cQuery	+= "	AND SF1.F1_EMISSAO >= '"+DtoS(dDtEmisDe)+"' " + CRLF
	cQuery	+= "	AND SF1.F1_EMISSAO <= '"+DtoS(dDtEmisAte)+"' " + CRLF
	cQuery	+= "	AND SF1.F1_DTDIGIT >= '"+DtoS(dDtDgtDe)+"' " + CRLF
	cQuery	+= "	AND SF1.F1_DTDIGIT <= '"+DtoS(dDtDgtAte)+"' " + CRLF
	cQuery	+= "	AND SUBSTR(SF1.F1_EMISSAO, 1, 4) >= '"+cAnoDe+"' " + CRLF
	cQuery	+= "	AND SUBSTR(SF1.F1_EMISSAO, 1, 4) <= '"+cAnoAte+"' " + CRLF
	cQuery	+= "INNER JOIN %SB1.SQLNAME% ON " + CRLF
	cQuery	+= "	SB1.B1_FILIAL = SZ4.Z4_FILIAL" + CRLF
	cQuery	+= "	AND SB1.B1_COD = SZ4.Z4_PRODUTO" + CRLF
	cQuery	+= "	AND %SB1.NOTDEL% " + CRLF
	cQuery	+= "WHERE " + CRLF
	cQuery	+= "	%SZ4.XFILIAL%" + CRLF
	cQuery	+= "	AND %SZ4.NOTDEL% " + CRLF
	cQuery	+= "	AND SZ4.Z4_DOC	>= '"+cDocDe+"'" +CRLF
	cQuery	+= "	AND SZ4.Z4_DOC	<= '"+cDocAte+"'" +CRLF
	cQuery	+= "	AND SZ4.Z4_SERIE >= '"+cSerieDe+"'" +CRLF
	cQuery	+= "	AND SZ4.Z4_SERIE <= '"+cSerieAte+"'" +CRLF
	cQuery	+= "	AND SZ4.Z4_CLIFOR >= '"+cCliForDe+"'" +CRLF
	cQuery	+= "	AND SZ4.Z4_CLIFOR <= '"+cCliForAte+"'" +CRLF
	cQuery	+= "	AND SZ4.Z4_LOJA >= '"+cLojaDe+"'" +CRLF
	cQuery	+= "	AND SZ4.Z4_LOJA <= '"+cLojaAte+"'" +CRLF
	cQuery	+= "	AND SZ4.Z4_PRODUTO >= '"+cProdDe+"'" +CRLF
	cQuery	+= "	AND SZ4.Z4_PRODUTO <= '"+cProdAte+"'" +CRLF
	cQuery	+= "	AND SZ4.Z4_TIPMOV = '"+cTipo+"'" +CRLF 
	//Conout("query RelNfcob retQryCob: "+cQuery)
return cQuery

static function getSD1()

	local nIndice	:= oSecNotas:getOrder()
	local cQuery	:= ""
//	local cQryNota:= retQryCob(cCliForDe, cCliForAte, cLojaDe, cLojaAte, cNotaDe	, cNotaAte		, cSerieDe		, cSerieAte	, cProdDe		, cProdAte		, "1", dDtEntDe	, dDtEntAte, dDtEmisDe, dDtEmisAte, cAnoNfDe, cAnoNfAte, cCfopDe, cCfopAte)
//	local cQryCob	:= retQryCob(cCliCobDe, cCliCobAte, cLjCobDe, cLjCobAte, cCobNfDe, cCobNfAte	, cCobSerDe	, cCobSerAte	, cCobProdDe	, cCobProdAte	, "2", dDtCobEnDe	, dDtCobEnAte, dDtCobEmDe, dDtCobEmAte, cCobAnoDe, cCobAnoAte, cCobCfopDe, cCobCfopAte)
	 
	cQuery	:= "SELECT "
	cQuery	+= "	F1.F1_FILIAL," + CRLF
	cQuery	+= "	F1.F1_TIPO," + CRLF
	cQuery	+= "	F1.F1_DTDIGIT," + CRLF
	cQuery	+= "	' ' CB_DTDIGIT," + CRLF
	cQuery	+= "	' ' CB_TIPO," + CRLF	
	cQuery	+= "	F1.F1_FORNECE," + CRLF
	cQuery	+= "	' ' CB_FORNECE," + CRLF
	cQuery	+= "	F1.F1_LOJA," + CRLF
	cQuery	+= "	' ' CB_LOJA," + CRLF	
	cQuery	+= "	D1.D1_TES," + CRLF
	cQuery	+= "	D1.D1_UM," + CRLF
	cQuery	+= "	' ' CB_TES," + CRLF	
	cQuery	+= "	F1.F1_EMISSAO ," + CRLF
	cQuery	+= "	' ' CB_EMISSAO," + CRLF
	cQuery	+= "	D1.D1_DOC," + CRLF  //MUDADO DE Z4_DOC PARA D1_DOC
	cQuery	+= "	' ' CB_DOC," + CRLF
	cQuery	+= "	D1.D1_SERIE," + CRLF //MUDADO DE Z4_SERIE PARA D1_SERIE
	cQuery	+= "	' ' CB_SERIE," + CRLF
	cQuery	+= "	D1.D1_CF," + CRLF
	cQuery	+= "	' ' CB_CF," + CRLF	
	cQuery	+= "	F1.F1_VALBRUT," + CRLF
	cQuery	+= "	0 CB_VALBRUT," + CRLF
	cQuery	+= "	D1.D1_COD," + CRLF
	cQuery	+= "	' ' CB_COD," + CRLF
	cQuery	+= "	B1.B1_POSIPI," + CRLF
	cQuery	+= "	' ' CB_POSIPI," + CRLF
	cQuery	+= "	B1.B1_DESC," + CRLF
	cQuery	+= "	' ' CB_DESC," + CRLF
	cQuery	+= "	B1.B1_UM," + CRLF
	cQuery	+= "	' ' COB_UM," + CRLF		
	cQuery	+= "	D1.D1_QUANT," + CRLF
	cQuery	+= "	0 CB_QUANT," + CRLF		
	cQuery	+= "	D1.D1_BASEIPI," + CRLF
	cQuery	+= "	0 CB_BASEIPI," + CRLF		
	cQuery	+= "	D1.D1_BASEICM," + CRLF
	cQuery	+= "	0 CB_BASEICM," + CRLF		
	cQuery	+= "	D1.D1_BRICMS," + CRLF
	cQuery	+= "	0 CB_BRICMS," + CRLF		
	cQuery	+= "	D1.D1_VALIPI," + CRLF
	cQuery	+= "	0 CB_VALIPI," + CRLF		
	cQuery	+= "	D1.D1_VALICM," + CRLF
	cQuery	+= "	0 CB_VALICM," + CRLF		
	cQuery	+= "	D1.D1_ICMSRET," + CRLF
	cQuery	+= "	0 CB_ICMSRET," + CRLF		
	cQuery	+= "	D1.D1_VALANTI," + CRLF
	cQuery	+= "	0 CB_VALANTI," + CRLF		
	cQuery	+= "	D1.D1_VUNIT," + CRLF
	cQuery	+= "	0 CB_VUNIT," + CRLF		
	cQuery	+= "	D1.D1_TOTAL," + CRLF
	cQuery	+= "	0 CB_TOTAL, " + CRLF		
	cQuery	+= "	0 CB_TOTAL, " + CRLF	
	cQuery	+= "	Z4.Z4_IDCOB " + CRLF	
	cQuery	+= "FROM "+RetSqlName("SD1")+" D1 " + CRLF
	cQuery  += "INNER JOIN "+RetSqlName("SF1")+" F1 ON F1.F1_FILIAL = D1.D1_FILIAL AND D1.D1_DOC = F1.F1_DOC AND F1.F1_SERIE = D1.D1_SERIE AND F1.D_E_L_E_T_<>'*' "
	cQuery  += "INNER JOIN "+RetSqlName("SB1")+" B1 ON B1.B1_FILIAL = D1.D1_FILIAL AND B1.B1_COD = D1.D1_COD AND B1.D_E_L_E_T_<>'*' "  
	cQuery  += "LEFT  JOIN "+RetSqlName("SZ4")+" Z4 ON Z4.Z4_FILIAL = D1.D1_FILIAL AND Z4.Z4_PRODUTO = D1.D1_COD AND Z4.Z4_DOC = D1.D1_DOC AND Z4.Z4_SERIE = D1.D1_SERIE AND Z4.Z4_CLIFOR = D1.D1_FORNECE AND Z4.D_E_L_E_T_<>'*' AND Z4.Z4_TIPMOV='1' "  
	cQuery += "    WHERE D1.D1_TES <> '   ' " + CRLF
	cQuery += "    AND D1.D_E_L_E_T_ <> '*' " + CRLF   
   	cQuery	+= "	AND D1.D1_FILIAL = F1.F1_FILIAL " +CRLF   
	cQuery	+= "	AND D1.D1_CF  >= '"+cCfopDe+"'" + CRLF                                              
	cQuery	+= "	AND D1.D1_CF  <= '"+cCfopAte+"'" + CRLF
	cQuery	+= "	AND F1.F1_EMISSAO >= '"+DtoS(dDtEmisDe)+"' " + CRLF
	cQuery	+= "	AND F1.F1_EMISSAO <= '"+DtoS(dDtEmisAte)+"' " + CRLF
	cQuery	+= "	AND F1.F1_DTDIGIT >= '"+DtoS(dDtEntDe)+"' " + CRLF    
	cQuery	+= "	AND F1.F1_DTDIGIT <= '"+DtoS(dDtEntAte)+"' " + CRLF
	cQuery	+= "	AND SUBSTR(F1.F1_EMISSAO, 1, 4) >= '"+cAnoNfDe+"' " + CRLF
	cQuery	+= "	AND SUBSTR(F1.F1_EMISSAO, 1, 4) <= '"+cAnoNfAte+"' " + CRLF
	cQuery	+= "	AND D1.D1_DOC	>= '"+cNotaDe+"' " +CRLF
	cQuery	+= "	AND D1.D1_DOC	<= '"+cNotaAte+"' " +CRLF
	cQuery	+= "	AND D1.D1_SERIE >= '"+cSerieDe+"' " +CRLF
	cQuery	+= "	AND D1.D1_SERIE <= '"+cSerieAte+"' " +CRLF
	cQuery	+= "	AND F1.F1_FORNECE >= '"+cCliForDe+"'" +CRLF
	cQuery	+= "	AND F1.F1_FORNECE <= '"+cCliForAte+"' " +CRLF
	cQuery	+= "	AND F1.F1_LOJA >= '"+cLojaDe+"' " +CRLF
	cQuery	+= "	AND F1.F1_LOJA <= '"+cLojaAte+"' " +CRLF
	cQuery	+= "	AND D1.D1_COD >= '"+cProdDe+"' " +CRLF
	cQuery	+= "	AND D1.D1_COD <= '"+cProdAte+"' " +CRLF    
	cQuery	+= "	AND D1.D1_FILIAL = '"+xFilial("SD1")+"' " +CRLF   
	
	MemoWrite( "c:\temp\QryEdson.txt", cQuery )
	Conout("query RelNfcob getsd1: "+cQuery)
	oSqlNotas	:= IpSqlObject():newIpSqlObject()
	oSqlNotas:newAlias(cQuery)  
	
return(cQuery)     

*/
