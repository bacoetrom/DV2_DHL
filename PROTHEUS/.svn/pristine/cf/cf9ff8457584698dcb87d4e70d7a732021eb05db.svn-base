#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx07.ch'
#include 'safx08.ch'
#include 'safx112.ch'
#include 'safx116.ch'
#include 'safx.ch'
#include "dhl.ch"

/*/{Protheus.doc} Di2SAFX07MSDW

Respons‡vel por gerar o arquivo SAFX07
	
@author Daniel Braga
@since 30/10/2014
/*/
user function Di2SAFX07MSDW(aCompany, nType, dDtFrom, dDtUntil)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()
	private lGerouArqs	:= .F.		
	default nType 		:= 3
	default dDtFrom 	:= date()
	default dDtUntil	:= date() 

	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf 
			
	SAFX07(nType,dDtFrom , dDtUntil)
		
return lGerouArqs

/**
 * Processa a Geracao dos Arquivos
 */
static function SAFX07(nType,dDtFrom , dDtUntil)

	local oFileSfx07 	:= MsafDWFile():newMsafDWFile("07"  ,SAFX07_POSICOES)
	local oFlSfx08 		:= MsafDWFile():newMsafDWFile("08"  ,SAFX08_POSICOES)
	local oFlSfx112 	:= MsafDWFile():newMsafDWFile("112" ,SAFX112_POSICOES)
	local oFlSfx116 	:= MsafDWFile():newMsafDWFile("116" ,SAFX116_POSICOES)
	local oIpSqlSfx07 	:= IpSqlObject():newIpSqlObject()
	local oDHLSafx07	:= nil
	local cError		:= ""
	local cAlias		:= ""
	local aFields		:= {}
	local aDocsRef		:= {}
	local nCount        := 0
	local nteste		:= 0
	Local nFormaNova	:= 0
	
	private ltst_		:= .f.
	private _inoutflows	:= {}
	private _itflow		:= {}
	private _supcus		:= {}
	private _tax		:= {}
	private _UfTaxes	:= {}
	Private cSF3_		:= GetNextAlias()
	Private cSft_		:= getNextAlias()
	
	default nType		:= 0
	default dDtFrom		:= stod("")
	default dDtUntil 	:= stod("")


	sf3abre(nType, dDtFrom, dDtUntil)
	
	oDHLSafx07 := Di2DHLSafx07():newDi2DHLSafx07()	
	
	//oIpSqlSfx07:newAlias( oDHLSafx07:getSql(nType,dDtFrom , dDtUntil) )
	
	//cAlias := oIpSqlSfx07:getAlias()
	//nCount := oIpSqlSfx07:count()
	//(cAlias)->( DbGoTop() )
	
	//while oIpSqlSfx07:notIsEof()
	while (cSF3_)->(!eof())

		_inoutflows	:= {}
		_itflow		:= {}
		_supcus		:= {}
		_tax		:= {}
		_UfTaxes	:= {}
		
		if isInventario( cSF3_ /* cAlias */ , oDHLSafx07)  .or. isCutover( cSF3_ /*cAlias*/ , oDHLSafx07)
			//oIpSqlSfx07:skip()	
			(cSF3_)->(dbskip())
			loop
		endIf
		
		(cSF3_)->( u_SFTabre( ent_sai , f3_nfiscal , f3_serie ,  f3_cliefor , f3_loja  ))

		oDHLSafx07:initialize(SAFX07_POSICOES,oIpSqlSfx07)
		
		oDHLSafx07:addLine()
		
		aFields := oDHLSafx07:getFields()
		cError	:= oDHLSafx07:validRequired(VLD_07_FIELD)
		
		if !Empty(cError)
			cError += getIdDoc(cAlias, oDHLSafx07)
			oDHLSafx07:addLog(SAFX07_ERROR_TITLE,SAFX07_ERROR_OBRIGAT+cError,oFileSfx07:getFile())
			//oIpSqlSfx07:skip()
			(cSF3_)->(dbskip())
			loop
		endIf
		
		oFileSfx07:setFields( aFields )
		
		if oFileSfx07:write()
			lGerouArqs	:= .T.
		else
			oDHLSafx07:addLog(SAFX07_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx07:getFile())
			//oIpSqlSfx07:skip()
			(cSF3_)->(dbskip())
			loop
		endif

		U_SAFX08MSDW(oIpSqlSfx07 ,@oFlSfx08,@oFlSfx116,@aDocsRef)
		(cSFT_)->(dbgotop())
		U_SAFX112MSDW(oIpSqlSfx07,@oFlSfx112)
		
		
		(cSFT_)->(DbCloseArea())
		//oIpSqlSfx07:skip()	
		(cSF3_)->(dbskip())
	endDo
	
	oIpSqlSfx07:close()	
	oFileSfx07:renameArq("07"  ,SAFX07_POSICOES)
	oFileSfx07:close()
	oFlSfx08:renameArq("08"  ,SAFX08_POSICOES)
	oFlSfx08:close()
	oFlSfx112:renameArq("112" ,SAFX112_POSICOES)
	oFlSfx112:close()
	oFlSfx116:renameArq("116" ,SAFX116_POSICOES)
	oFlSfx116:close()
	
	(cSF3_)->(dbclosearea())

return

/**
 * Coleta o ID do Documento para o Log de Erros
 */
static function getIdDoc(cAlias, oDHLSafx07)
	
	local cIdDoc	:= CRLF+CRLF
	local cDoc		:= (cAlias)->(AllTrim(F3_NFISCAL))
	local cSer		:= (cAlias)->(AllTrim(F3_SERIE))
	local cCod		:= (cAlias)->(AllTrim(F3_CLIEFOR))
	local cBranch	:= (cAlias)->(AllTrim(F3_LOJA))		
	local lSaida	:= iif(oDHLSafx07:getTypeDoc(cDoc, cSer,cCod,cBranch) == '1', .T., .F.)
	
	cIdDoc += "Tipo Documento: "+if(lSaida, "Saída", "Entrada")+CRLF
	cIdDoc += "Nota Fiscal: "+(cAlias)->(AllTrim(F3_NFISCAL)+"/"+F3_SERIE)+CRLF
	cIdDoc += "Cliente/Fornecedor: "+(cAlias)->(AllTrim(F3_CLIEFOR)+"-"+F3_LOJA)
	
return cIdDoc

/**
 * Verifica se eh uma NF de Inventario
 */
static function isInventario(cAlias, oDHLSafx07)

	local lInventario	:= .F.
	local cSerie	  	:= (cAlias)->(AllTrim(F3_SERIE))
	local cEspecie	  	:= (cAlias)->(AllTrim(F3_ESPECIE))
	local cDoc		 	:= (cAlias)->(AllTrim(F3_NFISCAL))
	local cSer			:= (cAlias)->(AllTrim(F3_SERIE))
	local cCod			:= (cAlias)->(AllTrim(F3_CLIEFOR))
	local cBranch		:= (cAlias)->(AllTrim(F3_LOJA))		
	local lSaida	  	:= iif( (cAlias)->ENT_SAI == '1', .T., .F.)  //iif(oDHLSafx07:getTypeDoc(cDoc, cSer,cCod,cBranch) == '1', .T., .F.)
	
	if lSaida
		lInventario := (cSerie == DHL_SERIE_INVENTARIO)
	else
		lInventario := (cEspecie == DHL_ESPECIE_INVENTARIO) 
	endIf
	
return lInventario


/**
 * Verifica se eh uma NF de Cutover
 */
static function isCutover(cAlias, oDHLSafx07)

	local lCutover		:= .F.
	local cDoc		 	:= (cAlias)->(AllTrim(F3_NFISCAL))
	local cSer			:= (cAlias)->(AllTrim(F3_SERIE))
	local cCod			:= (cAlias)->(AllTrim(F3_CLIEFOR))
	local cBranch		:= (cAlias)->(AllTrim(F3_LOJA))		
	local cType		  	:= (cAlias)->ENT_SAI //oDHLSafx07:getTypeDoc(cDoc, cSer,cCod,cBranch)
	
///////// veio do objeto

	local oIpSqlObject	:=  IpSqlObject():newIpSqlObject()
	local cWhere 		:= ""
	local cTable  		:= ""
	local cField		:= ""
	local cPrefix 		:= ""
	local cSQL 			:= ""
	//local lCutover		:= .f.
	local aFields := {}

	if cType  == "2"
		cTable := "SF2"
		cField := "F2_SERIE"
	else 
		cTable := "SF1"
		cField := "F1_ZZCUTOV"
	endIf 
	
	cPrefix := PrefixoCpo(Upper(cTable))
	
	cWhere := cPrefix+"_filial= '%"+cTable+".filial%' and "+cPrefix+"_doc = '" +cDoc+ "' and "+cPrefix+"_serie ='"+cSer+"' and "
	if cType == "2"
		cWhere += cPrefix+"_cliente = '"+cCod+"' and "
	else 
		cWhere += cPrefix+"_fornece = '"+cCod+"' and "
	endIf
	cWhere +=  cPrefix+"_loja='"+cBranch+"' and d_e_l_e_t_ = ' ' "
		
	if cType == "2"
		lCutover := oIpSqlObject:getFieldValue(cTable, cField, cWhere) == DHL_SERIE_CUTOVER
	else
		lCutover := oIpSqlObject:getFieldValue(cTable, cField, cWhere) == 'S'
	endif
	
	oIpSqlObject:close()
	
return (lCutover)



////////





	//lCutover := oDHLSafx07:isCutover(cType,cDoc,cSer,cCod,cBranch)
	
return lCutover


static function sf3abre(nType, dDtFrom, dDtUntil)
local cquery	:= ""
local cCfopExDw	:= formatin(supergetmv("ZZ_CFOEXDW", , ""),";")

if nType == 2 .or. nType == 3 // saida ou ambos

	cQuery := ""
	cQuery += "SELECT '2' ENT_SAI, a1_zzinddw ZZINDDW, "
	cQuery += "       a1_inscr   a1a2_INSCR, "
	cQuery += "       a1_tipo    a1a2_tipo, "
	cQuery += "       a1_est     A1A2_EST, "
	cQuery += "       tipo, "
	cQuery += "       f3_cliefor, "
	cQuery += "       f3_loja, "
	cQuery += "       f3_nfiscal, "
	cQuery += "       f3_serie, "
	cQuery += "       f3_entrada, "
	cQuery += "       f3_dtcanc, "
	cQuery += "       f3_valicm, "
	cQuery += "       f3_icmsret, "
	cQuery += "       f3_isenicm, "
	cQuery += "       f3_isenipi, "
	cQuery += "       f3_baseicm, "
	cQuery += "       f3_valipi, "
	cQuery += "       f3_outripi, "
	cQuery += "       f3_basimp6, "
	cQuery += "       f3_valimp6, "
	cQuery += "       f3_basimp5, "
	cQuery += "       f3_valimp5, "
	cQuery += "       f3_credst, "
	cQuery += "       f3_outricm, "
	cQuery += "       f3_baseps3, "
	cQuery += "       f3_valps3, "
	cQuery += "       f3_despesa, "
	cQuery += "       f3_icmscom, "
	cQuery += "       f3_basecf3, "
	cQuery += "       f3_valcf3, "
	cQuery += "       f3_ipiobs, "
	cQuery += "       f3_codret, "
	cQuery += "       f3_especie, "
	cQuery += "       f3_emissao, "
	cQuery += "       f3_chvnfe, "
	cQuery += "       f3_estado, "
	cQuery += "       f3_tipo, "
	cQuery += "       f3_eminfe "
	cQuery += "FROM   (SELECT CASE "
	cQuery += "                 WHEN f3_tipo IN ( 'D', 'B' ) THEN '"+SAFX_MOVIMENTO_DEVOLUCAO+"' "
	cQuery += "                 ELSE '"+SAFX_MOVIMENTO_NORMAL+"' "
	cQuery += "               END             tipo, "
	cQuery += "               f3_cliefor, "
	cQuery += "               f3_loja, "
	cQuery += "               f3_nfiscal, "
	cQuery += "               f3_serie, "
	cQuery += "               f3_entrada, "
	cQuery += "               f3_dtcanc, "
	cQuery += "               Sum(f3_valicm)  f3_valicm, "
	cQuery += "               Sum(f3_icmsret) f3_icmsret, "
	cQuery += "               Sum(f3_isenicm) f3_isenicm, "
	cQuery += "               Sum(f3_outricm) f3_outricm, "
	cQuery += "               Sum(f3_isenipi) f3_isenipi, "
	cQuery += "               Sum(f3_baseicm) f3_baseicm, "
	cQuery += "               Sum(f3_valipi)  f3_valipi, "
	cQuery += "               Sum(f3_outripi) f3_outripi, "
	cQuery += "               Sum(f3_basimp6) f3_basimp6, "
	cQuery += "               Sum(f3_valimp6) f3_valimp6, "
	cQuery += "               Sum(f3_basimp5) f3_basimp5, "
	cQuery += "               Sum(f3_valimp5) f3_valimp5, "
	cQuery += "               f3_credst, "
	cQuery += "               Sum(f3_baseps3) f3_baseps3, "
	cQuery += "               Sum(f3_valps3)  f3_valps3, "
	cQuery += "               Sum(f3_despesa) f3_despesa, "
	cQuery += "               Sum(f3_icmscom) f3_icmscom, "
	cQuery += "               Sum(f3_basecf3) f3_basecf3, "
	cQuery += "               Sum(f3_valcf3)  f3_valcf3, "
	cQuery += "               Sum(f3_ipiobs)  f3_ipiobs, "
	cQuery += "               f3_codret, "
	cQuery += "               f3_especie, "
	cQuery += "               f3_emissao, "
	cQuery += "               f3_chvnfe, "
	cQuery += "               f3_estado, "
	cQuery += "               f3_tipo, "
	cQuery += "               f3_eminfe "
	cQuery += "        FROM   " + retsqlname("SF3") + " SF3  "
	cQuery += "        WHERE  f3_filial = '" + xfilial("SF3") + "' "
	//--cQuery += "               AND f3_entrada BETWEEN '20170916' AND '20170917' "
		if !Empty(dDtFrom) .and. !Empty(dDtUntil)
			cQuery += " and f3_entrada between '"+dtos(dDtFrom)+"' and '"+dtos(dDtUntil)+"' "
		else 
			cQuery += " and f3_entrada ='"+dtos(date())+"' "	
		endIf	   
	cQuery += "               AND f3_cfo >= 5000 "
	cQuery += "               AND f3_tipo NOT IN ( 'D', 'B' ) "
	
	//TODO - TESTE DIOGO
	//cQuery += "               AND f3_nfiscal = '000022880' "
	//
	
	cQuery += "               AND SF3.d_e_l_e_t_ = ' ' and f3_observ != '"+ getMv("ZZ_TXTINUT")+"'"
	
	if !empty(cCfopExDw)
		cQuery += " AND f3_cfo NOT IN " + cCfopExDw + " "
	endIf
	
	cQuery += "        GROUP  BY f3_tipo, "
	cQuery += "                  f3_cliefor, "
	cQuery += "                  f3_loja, "
	cQuery += "                  f3_nfiscal, "
	cQuery += "                  f3_serie, "
	cQuery += "                  f3_entrada, "
	cQuery += "                  f3_dtcanc, "
	cQuery += "                  f3_credst, "
	cQuery += "                  f3_codret, "
	cQuery += "                  f3_especie, "
	cQuery += "                  f3_emissao, "
	cQuery += "                  f3_chvnfe, "
	cQuery += "                  f3_estado, "
	cQuery += "                  f3_tipo, "
	cQuery += "                  f3_eminfe) XX1 "
	cQuery += "       LEFT JOIN " + retsqlname("SA1") + " SA1  "
	cQuery += "              ON a1_filial = '" + xfilial("SA1") + "' "
	cQuery += "                 AND a1_cod = f3_cliefor "
	cQuery += "                 AND a1_loja = f3_loja "
	cQuery += "                 AND sa1.d_e_l_e_t_ = ' ' "
	cQuery += "UNION ALL "
	cQuery += "SELECT '2' ENT_SAI, a2_zzinddw ZZINDDW, "
	cQuery += "       a2_inscr   a1a2_INSCR, "
	cQuery += "       a2_tipo    a1a2_tipo, "
	cQuery += "       a2_est     A1A2_EST, "
	cQuery += "       tipo, "
	cQuery += "       f3_cliefor, "
	cQuery += "       f3_loja, "
	cQuery += "       f3_nfiscal, "
	cQuery += "       f3_serie, "
	cQuery += "       f3_entrada, "
	cQuery += "       f3_dtcanc, "
	cQuery += "       f3_valicm, "
	cQuery += "       f3_icmsret, "
	cQuery += "       f3_isenicm, "
	cQuery += "       f3_isenipi, "
	cQuery += "       f3_baseicm, "
	cQuery += "       f3_valipi, "
	cQuery += "       f3_outripi, "
	cQuery += "       f3_basimp6, "
	cQuery += "       f3_valimp6, "
	cQuery += "       f3_basimp5, "
	cQuery += "       f3_valimp5, "
	cQuery += "       f3_credst, "
	cQuery += "       f3_outricm, "
	cQuery += "       f3_baseps3, "
	cQuery += "       f3_valps3, "
	cQuery += "       f3_despesa, "
	cQuery += "       f3_icmscom, "
	cQuery += "       f3_basecf3, "
	cQuery += "       f3_valcf3, "
	cQuery += "       f3_ipiobs, "
	cQuery += "       f3_codret, "
	cQuery += "       f3_especie, "
	cQuery += "       f3_emissao, "
	cQuery += "       f3_chvnfe, "
	cQuery += "       f3_estado, "
	cQuery += "       f3_tipo, "
	cQuery += "       f3_eminfe "
	cQuery += "FROM   (SELECT CASE "
	cQuery += "                 WHEN f3_tipo IN ( 'D', 'B' ) THEN '"+SAFX_MOVIMENTO_DEVOLUCAO+"' "
	cQuery += "                 ELSE '"+SAFX_MOVIMENTO_NORMAL+"' "
	cQuery += "               END             tipo, "
	cQuery += "               f3_cliefor, "
	cQuery += "               f3_loja, "
	cQuery += "               f3_nfiscal, "
	cQuery += "               f3_serie, "
	cQuery += "               f3_entrada, "
	cQuery += "               f3_dtcanc, "
	cQuery += "               Sum(f3_valicm)  f3_valicm, "
	cQuery += "               Sum(f3_icmsret) f3_icmsret, "
	cQuery += "               Sum(f3_isenicm) f3_isenicm, "
	cQuery += "               Sum(f3_outricm) f3_outricm, "
	cQuery += "               Sum(f3_isenipi) f3_isenipi, "
	cQuery += "               Sum(f3_baseicm) f3_baseicm, "
	cQuery += "               Sum(f3_valipi)  f3_valipi, "
	cQuery += "               Sum(f3_outripi) f3_outripi, "
	cQuery += "               Sum(f3_basimp6) f3_basimp6, "
	cQuery += "               Sum(f3_valimp6) f3_valimp6, "
	cQuery += "               Sum(f3_basimp5) f3_basimp5, "
	cQuery += "               Sum(f3_valimp5) f3_valimp5, "
	cQuery += "               f3_credst, "
	cQuery += "               Sum(f3_baseps3) f3_baseps3, "
	cQuery += "               Sum(f3_valps3)  f3_valps3, "
	cQuery += "               Sum(f3_despesa) f3_despesa, "
	cQuery += "               Sum(f3_icmscom) f3_icmscom, "
	cQuery += "               Sum(f3_basecf3) f3_basecf3, "
	cQuery += "               Sum(f3_valcf3)  f3_valcf3, "
	cQuery += "               Sum(f3_ipiobs)  f3_ipiobs, "
	cQuery += "               f3_codret, "
	cQuery += "               f3_especie, "
	cQuery += "               f3_emissao, "
	cQuery += "               f3_chvnfe, "
	cQuery += "               f3_estado, "
	cQuery += "               f3_tipo, "
	cQuery += "               f3_eminfe "
	cQuery += "        FROM   " + retsqlname("SF3") + " SF3  "
	cQuery += "        WHERE  f3_filial = '" + xfilial("SF3") + "' "
	//--cQuery += "               AND f3_entrada BETWEEN '20170916' AND '20170917' "
		if !Empty(dDtFrom) .and. !Empty(dDtUntil)
			cQuery += " and f3_entrada between '"+dtos(dDtFrom)+"' and '"+dtos(dDtUntil)+"'  "
		else 
			cQuery += " and f3_entrada ='"+dtos(date())+"'  "	
		endIf	                
	cQuery += "               AND f3_cfo >= 5000 "
	cQuery += "               AND f3_tipo IN ( 'D', 'B' ) "
	
	//TODO - TESTE DIOGO
	//cQuery += "               AND f3_nfiscal = '000022880' "
	//
	
	cQuery += "               AND SF3.d_e_l_e_t_ = ' ' and f3_observ != '"+ getMv("ZZ_TXTINUT")+"'"

	if !empty(cCfopExDw)
		cQuery += " AND f3_cfo NOT IN " + cCfopExDw + " "
	endIf

	cQuery += "        GROUP  BY f3_tipo, "
	cQuery += "                  f3_cliefor, "
	cQuery += "                  f3_loja, "
	cQuery += "                  f3_nfiscal, "
	cQuery += "                  f3_serie, "
	cQuery += "                  f3_entrada, "
	cQuery += "                  f3_dtcanc, "
	cQuery += "                  f3_credst, "
	cQuery += "                  f3_codret, "
	cQuery += "                  f3_especie, "
	cQuery += "                  f3_emissao, "
	cQuery += "                  f3_chvnfe, "
	cQuery += "                  f3_estado, "
	cQuery += "                  f3_tipo, "
	cQuery += "                  f3_eminfe) XX2 "
	cQuery += "       LEFT JOIN " + retsqlname("SA2") + " SA2  "
	cQuery += "              ON a2_filial = '" + xfilial("SA2") + "' "
	cQuery += "                 AND a2_cod = f3_cliefor "
	cQuery += "                 AND a2_loja = f3_loja "
	cQuery += "                 AND sa2.d_e_l_e_t_ = ' ' "
endif

if nType == 3 // ambos
	cQuery += "UNION ALL "
endif


if nType == 1 .or. nType == 3
	cQuery += "SELECT '1' ENT_SAI ,  a1_zzinddw ZZINDDW, "
	cQuery += "       a1_inscr   a1a2_INSCR, "
	cQuery += "       a1_tipo    a1a2_tipo, "
	cQuery += "       a1_est     A1A2_EST, "
	cQuery += "       tipo, "
	cQuery += "       f3_cliefor, "
	cQuery += "       f3_loja, "
	cQuery += "       f3_nfiscal, "
	cQuery += "       f3_serie, "
	cQuery += "       f3_entrada, "
	cQuery += "       f3_dtcanc, "
	cQuery += "       f3_valicm, "
	cQuery += "       f3_icmsret, "
	cQuery += "       f3_isenicm, "
	cQuery += "       f3_isenipi, "
	cQuery += "       f3_baseicm, "
	cQuery += "       f3_valipi, "
	cQuery += "       f3_outripi, "
	cQuery += "       f3_basimp6, "
	cQuery += "       f3_valimp6, "
	cQuery += "       f3_basimp5, "
	cQuery += "       f3_valimp5, "
	cQuery += "       f3_credst, "
	cQuery += "       f3_outricm, "
	cQuery += "       f3_baseps3, "
	cQuery += "       f3_valps3, "
	cQuery += "       f3_despesa, "
	cQuery += "       f3_icmscom, "
	cQuery += "       f3_basecf3, "
	cQuery += "       f3_valcf3, "
	cQuery += "       f3_ipiobs, "
	cQuery += "       f3_codret, "
	cQuery += "       f3_especie, "
	cQuery += "       f3_emissao, "
	cQuery += "       f3_chvnfe, "
	cQuery += "       f3_estado, "
	cQuery += "       f3_tipo, "
	cQuery += "       f3_eminfe "
	cQuery += "FROM   (SELECT CASE "
	cQuery += "                 WHEN f3_tipo IN ( 'D', 'B' ) THEN '"+SAFX_MOVIMENTO_DEVOLUCAO+"' "
	cQuery += "                 ELSE '"+SAFX_MOVIMENTO_NORMAL+"' "
	cQuery += "               END             tipo, "
	cQuery += "               f3_cliefor, "
	cQuery += "               f3_loja, "
	cQuery += "               f3_nfiscal, "
	cQuery += "               f3_serie, "
	cQuery += "               f3_entrada, "
	cQuery += "               f3_dtcanc, "
	cQuery += "               Sum(f3_valicm)  f3_valicm, "
	cQuery += "               Sum(f3_icmsret) f3_icmsret, "
	cQuery += "               Sum(f3_isenicm) f3_isenicm, "
	cQuery += "               Sum(f3_outricm) f3_outricm, "
	cQuery += "               Sum(f3_isenipi) f3_isenipi, "
	cQuery += "               Sum(f3_baseicm) f3_baseicm, "
	cQuery += "               Sum(f3_valipi)  f3_valipi, "
	cQuery += "               Sum(f3_outripi) f3_outripi, "
	cQuery += "               Sum(f3_basimp6) f3_basimp6, "
	cQuery += "               Sum(f3_valimp6) f3_valimp6, "
	cQuery += "               Sum(f3_basimp5) f3_basimp5, "
	cQuery += "               Sum(f3_valimp5) f3_valimp5, "
	cQuery += "               f3_credst, "
	cQuery += "               Sum(f3_baseps3) f3_baseps3, "
	cQuery += "               Sum(f3_valps3)  f3_valps3, "
	cQuery += "               Sum(f3_despesa) f3_despesa, "
	cQuery += "               Sum(f3_icmscom) f3_icmscom, "
	cQuery += "               Sum(f3_basecf3) f3_basecf3, "
	cQuery += "               Sum(f3_valcf3)  f3_valcf3, "
	cQuery += "               Sum(f3_ipiobs)  f3_ipiobs, "
	cQuery += "               f3_codret, "
	cQuery += "               f3_especie, "
	cQuery += "               f3_emissao, "
	cQuery += "               f3_chvnfe, "
	cQuery += "               f3_estado, "
	cQuery += "               f3_tipo, "
	cQuery += "               f3_eminfe "
	cQuery += "        FROM   " + retsqlname("SF3") + " SF3  "
	cQuery += "        WHERE  f3_filial = '" + xfilial("SF3") + "' "
	//--cQuery += "               AND f3_entrada BETWEEN '20170916' AND '20170917' "
		if !Empty(dDtFrom) .and. !Empty(dDtUntil)
			cQuery += " and f3_entrada between '"+dtos(dDtFrom)+"' and '"+dtos(dDtUntil)+"' "
		else 
			cQuery += " and f3_entrada ='"+dtos(date())+"'  "	
		endIf	                
	cQuery += "               AND f3_cfo < 5000 "
	cQuery += "               AND f3_tipo IN ( 'D', 'B' ) "
	
	//TODO - TESTE DIOGO
	//cQuery += "               AND f3_nfiscal = '000022880' "
	//
	
	cQuery += "               AND SF3.d_e_l_e_t_ = ' ' and f3_observ != '"+ getMv("ZZ_TXTINUT")+"'"

	if !empty(cCfopExDw)
		cQuery += " AND f3_cfo NOT IN " + cCfopExDw + " "
	endIf

	cQuery += "        GROUP  BY f3_tipo, "
	cQuery += "                  f3_cliefor, "
	cQuery += "                  f3_loja, "
	cQuery += "                  f3_nfiscal, "
	cQuery += "                  f3_serie, "
	cQuery += "                  f3_entrada, "
	cQuery += "                  f3_dtcanc, "
	cQuery += "                  f3_credst, "
	cQuery += "                  f3_codret, "
	cQuery += "                  f3_especie, "
	cQuery += "                  f3_emissao, "
	cQuery += "                  f3_chvnfe, "
	cQuery += "                  f3_estado, "
	cQuery += "                  f3_tipo, "
	cQuery += "                  f3_eminfe) XX1 "
	cQuery += "       LEFT JOIN " + retsqlname("SA1") + " SA1  "
	cQuery += "              ON a1_filial = '" + xfilial("SA1") + "' "
	cQuery += "                 AND a1_cod = f3_cliefor "
	cQuery += "                 AND a1_loja = f3_loja "
	cQuery += "                 AND sa1.d_e_l_e_t_ = ' ' "
	cQuery += "UNION ALL "
	cQuery += "SELECT '1' ENT_SAI, a2_zzinddw ZZINDDW, "
	cQuery += "       a2_inscr   a1a2_INSCR, "
	cQuery += "       a2_tipo    a1a2_tipo, "
	cQuery += "       a2_est     A1A2_EST, "
	cQuery += "       tipo, "
	cQuery += "       f3_cliefor, "
	cQuery += "       f3_loja, "
	cQuery += "       f3_nfiscal, "
	cQuery += "       f3_serie, "
	cQuery += "       f3_entrada, "
	cQuery += "       f3_dtcanc, "
	cQuery += "       f3_valicm, "
	cQuery += "       f3_icmsret, "
	cQuery += "       f3_isenicm, "
	cQuery += "       f3_isenipi, "
	cQuery += "       f3_baseicm, "
	cQuery += "       f3_valipi, "
	cQuery += "       f3_outripi, "
	cQuery += "       f3_basimp6, "
	cQuery += "       f3_valimp6, "
	cQuery += "       f3_basimp5, "
	cQuery += "       f3_valimp5, "
	cQuery += "       f3_credst, "
	cQuery += "       f3_outricm, "
	cQuery += "       f3_baseps3, "
	cQuery += "       f3_valps3, "
	cQuery += "       f3_despesa, "
	cQuery += "       f3_icmscom, "
	cQuery += "       f3_basecf3, "
	cQuery += "       f3_valcf3, "
	cQuery += "       f3_ipiobs, "
	cQuery += "       f3_codret, "
	cQuery += "       f3_especie, "
	cQuery += "       f3_emissao, "
	cQuery += "       f3_chvnfe, "
	cQuery += "       f3_estado, "
	cQuery += "       f3_tipo, "
	cQuery += "       f3_eminfe "
	cQuery += "FROM   (SELECT CASE "
	cQuery += "                 WHEN f3_tipo IN ( 'D', 'B' ) THEN '"+SAFX_MOVIMENTO_DEVOLUCAO+"' "
	cQuery += "                 ELSE '"+SAFX_MOVIMENTO_NORMAL+"' "
	cQuery += "               END             tipo, "
	cQuery += "               f3_cliefor, "
	cQuery += "               f3_loja, "
	cQuery += "               f3_nfiscal, "
	cQuery += "               f3_serie, "
	cQuery += "               f3_entrada, "
	cQuery += "               f3_dtcanc, "
	cQuery += "               Sum(f3_valicm)  f3_valicm, "
	cQuery += "               Sum(f3_icmsret) f3_icmsret, "
	cQuery += "               Sum(f3_isenicm) f3_isenicm, "
	cQuery += "               Sum(f3_outricm) f3_outricm, "
	cQuery += "               Sum(f3_isenipi) f3_isenipi, "
	cQuery += "               Sum(f3_baseicm) f3_baseicm, "
	cQuery += "               Sum(f3_valipi)  f3_valipi, "
	cQuery += "               Sum(f3_outripi) f3_outripi, "
	cQuery += "               Sum(f3_basimp6) f3_basimp6, "
	cQuery += "               Sum(f3_valimp6) f3_valimp6, "
	cQuery += "               Sum(f3_basimp5) f3_basimp5, "
	cQuery += "               Sum(f3_valimp5) f3_valimp5, "
	cQuery += "               f3_credst, "
	cQuery += "               Sum(f3_baseps3) f3_baseps3, "
	cQuery += "               Sum(f3_valps3)  f3_valps3, "
	cQuery += "               Sum(f3_despesa) f3_despesa, "
	cQuery += "               Sum(f3_icmscom) f3_icmscom, "
	cQuery += "               Sum(f3_basecf3) f3_basecf3, "
	cQuery += "               Sum(f3_valcf3)  f3_valcf3, "
	cQuery += "               Sum(f3_ipiobs)  f3_ipiobs, "
	cQuery += "               f3_codret, "
	cQuery += "               f3_especie, "
	cQuery += "               f3_emissao, "
	cQuery += "               f3_chvnfe, "
	cQuery += "               f3_estado, "
	cQuery += "               f3_tipo, "
	cQuery += "               f3_eminfe "
	cQuery += "        FROM   " + retsqlname("SF3") + " SF3  "
	cQuery += "        WHERE  f3_filial = '" + xfilial("SF3") + "' "
	//--cQuery += "               AND f3_entrada BETWEEN '20170916' AND '20170917' "
		if !Empty(dDtFrom) .and. !Empty(dDtUntil)
			cQuery += " and f3_entrada between '"+dtos(dDtFrom)+"' and '"+dtos(dDtUntil)+"'  "
		else 
			cQuery += " and f3_entrada ='"+dtos(date())+"'  "	
		endIf	 
	cQuery += "               AND f3_cfo < 5000 "
	cQuery += "               AND f3_tipo NOT IN ( 'D', 'B' ) "
	
	//TODO - TESTE DIOGO
	//cQuery += "               AND f3_nfiscal = '000022880' "
	//
	
	cQuery += "               AND SF3.d_e_l_e_t_ = ' ' and f3_observ != '"+ getMv("ZZ_TXTINUT")+"'"

	if !empty(cCfopExDw)
		cQuery += " AND f3_cfo NOT IN " + cCfopExDw + " "
	endIf
	
	cQuery += "        GROUP  BY f3_tipo, "
	cQuery += "                  f3_cliefor, "
	cQuery += "                  f3_loja, "
	cQuery += "                  f3_nfiscal, "
	cQuery += "                  f3_serie, "
	cQuery += "                  f3_entrada, "
	cQuery += "                  f3_dtcanc, "
	cQuery += "                  f3_credst, "
	cQuery += "                  f3_codret, "
	cQuery += "                  f3_especie, "
	cQuery += "                  f3_emissao, "
	cQuery += "                  f3_chvnfe, "
	cQuery += "                  f3_estado, "
	cQuery += "                  f3_tipo, "
	cQuery += "                  f3_eminfe) XX2 "
	cQuery += "       LEFT JOIN " + retsqlname("SA2") + " SA2  "
	cQuery += "              ON a2_filial = '" + xfilial("SA2") + "' "
	cQuery += "                 AND a2_cod = f3_cliefor "
	cQuery += "                 AND a2_loja = f3_loja "
	cQuery += "                 AND sa2.d_e_l_e_t_ = ' ' "
endif

	//	TCQUERY cQuery NEW ALIAS &cSF3_
	
dbUseArea( .t. , "TOPCONN",TcGenQry(,,cQuery),csf3_,.f.,.t.)


return()
