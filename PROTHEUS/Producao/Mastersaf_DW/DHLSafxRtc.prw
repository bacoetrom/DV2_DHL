#include 'totvs.ch'
#include 'safx.ch'
#include 'safxrtc.ch'
#include 'dhl.ch'

/*/{Protheus.doc} DHLSafxRtc

Leitura consolidada dos tributos da Reforma Tributaria (IBS estadual, IBS
municipal, CBS e Imposto Seletivo) a partir do Configurador de Tributos -
tabelas F2D (valores por tributo) e CJ3 (CST / classificacao tributaria).

Componente compartilhado pelas interfaces SAFX3007 (cabecalho) e SAFX3008
(itens). Substitui as funcoes estaticas GetTrib(), GetIBS(), GetCBS() e
GetIS() sugeridas na especificacao: no conceito da pasta Mastersaf_DW a
regra de negocio mora em classe, e nao em funcao estatica por fonte, para
que as variantes por unidade de negocio (AG2, AGE, AGL, DIS, MUL, DI2)
herdem a mesma leitura.

A classe NAO recalcula tributo: devolve o que o Configurador de Tributos
registrou. E tambem NAO abre cursor por item - monta uma tabela derivada
pre-agregada na granularidade do item (F2D_IDREL), para ser consumida por
um unico LEFT JOIN no cursor de itens do documento. Isso evita o N+1 e a
multiplicacao de bases entre tributos.

Ligacoes confirmadas no codigo do projeto:
  F2D_IDREL  = FT_IDTRIB (SFT) / D1_IDTRIB (SD1) / D2_IDTRIB (SD2)
  F2D_TABELA = 'SD1' na entrada, 'SD2' na saida
  CJ3_IDF2D  = F2D_ID
Fontes de referencia: plan/ERBFIS01.prw (Conciliacao Livro Fiscal) e
PROTHEUS/Producao/Controle_de_ID_Good-Bad/DHLIdManager.prw.

@type  class
@author Pablo Regis
@since 23/11/2026
/*/
user function _SafxRtc;return

class DHLSafxRtc

	data cTribUF   as String
	data cTribMun  as String
	data cTribCBS  as String
	data cTribIS   as String
	data cFldCls   as String

	method newDHLSafxRtc() constructor

	method qryTribItens(cTipoMov,cDoc,cSer,cCod,cLoja)
	method colTribSelect(cAlias)
	method hasTribIS()
	method hasClassTrib()
	method logConfig(cOrigem)

endClass

/*/{Protheus.doc} newDHLSafxRtc
Construtor. Resolve por parametro os codigos de tributo do Configurador e o
campo da CJ3 que guarda o cClassTrib, de modo que a definicao da area fiscal
seja aplicada sem recompilar.

@type   method
@author Pablo Regis
@since  23/11/2026
@return object, instancia da classe
/*/
method newDHLSafxRtc() class DHLSafxRtc

	local cFldCls := ""

	::cTribUF  := AllTrim(GetNewPar(RTC_PAR_TRIB_UF, RTC_DEF_TRIB_UF))
	::cTribMun := AllTrim(GetNewPar(RTC_PAR_TRIB_MU, RTC_DEF_TRIB_MU))
	::cTribCBS := AllTrim(GetNewPar(RTC_PAR_TRIB_CB, RTC_DEF_TRIB_CB))

	// Imposto Seletivo: nao ha codigo de tributo confirmado na F2D. Sem o
	// parametro preenchido os campos de IS saem zerados, nunca estimados.
	::cTribIS  := AllTrim(GetNewPar(RTC_PAR_TRIB_IS, ""))

	// cClassTrib: o campo da CJ3 que o guarda nao esta confirmado no
	// dicionario. Aceita somente nome de campo que exista no SX3 e pertenca
	// a CJ3 - whitelist pelo dicionario, nao concatenacao livre (CA2050).
	cFldCls := Upper(AllTrim(GetNewPar(RTC_PAR_CCLASTR, "")))

	if !Empty(cFldCls) .and. Left(cFldCls,4) == "CJ3_" .and. !Empty(TamSX3(cFldCls))
		::cFldCls := cFldCls
	else
		::cFldCls := ""
	endIf

return self

/*/{Protheus.doc} qryTribItens
Monta a tabela derivada com os tributos da Reforma pre-agregados por item do
documento. O retorno e um fragmento SQL entre parenteses, SEM alias: quem
chama escreve  LEFT JOIN <fragmento> RTC ON RTC.IDREL = FT_IDTRIB.

A agregacao e feita em dois niveis de proposito. O nivel interno devolve uma
linha por registro da F2D (com o CST vindo da CJ3 por subconsulta escalar) e
o externo soma por item. Se a CJ3 fosse unida diretamente no mesmo nivel, um
F2D com mais de uma linha na CJ3 multiplicaria base e valor do tributo.

@type   method
@author Pablo Regis
@since  23/11/2026
@param  cTipoMov, character, tipo de movimento da SFT: "E" entrada, "S" saida
@param  cDoc,     character, numero do documento fiscal
@param  cSer,     character, serie do documento fiscal
@param  cCod,     character, codigo do cliente ou fornecedor
@param  cLoja,    character, loja do cliente ou fornecedor
@return character, fragmento SQL da tabela derivada
/*/
method qryTribItens(cTipoMov,cDoc,cSer,cCod,cLoja) class DHLSafxRtc

	local cQry    := ""
	local cTabF2D := ""
	local cColCls := ""
	local cFilF2D := xFilial("F2D")
	local cFilSFT := xFilial("SFT")

	default cTipoMov := "S"
	default cDoc     := ""
	default cSer     := ""
	default cCod     := ""
	default cLoja    := ""

	if cTipoMov == "E"
		cTabF2D := "SD1"
	else
		cTabF2D := "SD2"
	endIf

	if ::hasClassTrib()
		cColCls := " (SELECT MAX(CJ3CLS."+::cFldCls+") FROM "+RetSqlName("CJ3")+" CJ3CLS "+;
		           "  WHERE CJ3CLS.CJ3_IDF2D = F2D.F2D_ID AND CJ3CLS.D_E_L_E_T_ = ' ') "
	else
		cColCls := " ' ' "
	endIf

	cQry := " ( SELECT RTCX.IDREL "+RTC_COL_IDREL+", "
	cQry += "          SUM(CASE WHEN RTCX.TRIB = '"+::cTribUF+"'  THEN RTCX.BASE  ELSE 0   END) "+RTC_COL_BAS_UF+", "
	cQry += "          MAX(CASE WHEN RTCX.TRIB = '"+::cTribUF+"'  THEN RTCX.ALIQ  ELSE 0   END) "+RTC_COL_ALQ_UF+", "
	cQry += "          SUM(CASE WHEN RTCX.TRIB = '"+::cTribUF+"'  THEN RTCX.VALOR ELSE 0   END) "+RTC_COL_VLR_UF+", "
	cQry += "          MAX(CASE WHEN RTCX.TRIB = '"+::cTribUF+"'  THEN RTCX.CST   ELSE ' ' END) "+RTC_COL_CST_UF+", "
	cQry += "          SUM(CASE WHEN RTCX.TRIB = '"+::cTribMun+"' THEN RTCX.BASE  ELSE 0   END) "+RTC_COL_BAS_MU+", "
	cQry += "          MAX(CASE WHEN RTCX.TRIB = '"+::cTribMun+"' THEN RTCX.ALIQ  ELSE 0   END) "+RTC_COL_ALQ_MU+", "
	cQry += "          SUM(CASE WHEN RTCX.TRIB = '"+::cTribMun+"' THEN RTCX.VALOR ELSE 0   END) "+RTC_COL_VLR_MU+", "
	cQry += "          MAX(CASE WHEN RTCX.TRIB = '"+::cTribMun+"' THEN RTCX.CST   ELSE ' ' END) "+RTC_COL_CST_MU+", "
	cQry += "          SUM(CASE WHEN RTCX.TRIB = '"+::cTribCBS+"' THEN RTCX.BASE  ELSE 0   END) "+RTC_COL_BAS_CB+", "
	cQry += "          MAX(CASE WHEN RTCX.TRIB = '"+::cTribCBS+"' THEN RTCX.ALIQ  ELSE 0   END) "+RTC_COL_ALQ_CB+", "
	cQry += "          SUM(CASE WHEN RTCX.TRIB = '"+::cTribCBS+"' THEN RTCX.VALOR ELSE 0   END) "+RTC_COL_VLR_CB+", "
	cQry += "          MAX(CASE WHEN RTCX.TRIB = '"+::cTribCBS+"' THEN RTCX.CST   ELSE ' ' END) "+RTC_COL_CST_CB+", "
	cQry += "          SUM(CASE WHEN RTCX.TRIB = '"+::cTribIS+"'  THEN RTCX.BASE  ELSE 0   END) "+RTC_COL_BAS_IS+", "
	cQry += "          MAX(CASE WHEN RTCX.TRIB = '"+::cTribIS+"'  THEN RTCX.ALIQ  ELSE 0   END) "+RTC_COL_ALQ_IS+", "
	cQry += "          SUM(CASE WHEN RTCX.TRIB = '"+::cTribIS+"'  THEN RTCX.VALOR ELSE 0   END) "+RTC_COL_VLR_IS+", "
	cQry += "          MAX(CASE WHEN RTCX.TRIB = '"+::cTribIS+"'  THEN RTCX.CST   ELSE ' ' END) "+RTC_COL_CST_IS+", "
	cQry += "          MAX(RTCX.CLSTRIB) "+RTC_COL_CLSTRIB+" "
	cQry += "   FROM ( SELECT F2D.F2D_IDREL IDREL, "
	cQry += "                 F2D.F2D_TRIB  TRIB,  "
	cQry += "                 F2D.F2D_BASE  BASE,  "
	cQry += "                 F2D.F2D_ALIQ  ALIQ,  "
	cQry += "                 F2D.F2D_VALOR VALOR, "
	cQry += "                 (SELECT MAX(CJ3CST.CJ3_CST) FROM "+RetSqlName("CJ3")+" CJ3CST "
	cQry += "                   WHERE CJ3CST.CJ3_IDF2D = F2D.F2D_ID AND CJ3CST.D_E_L_E_T_ = ' ') CST, "
	cQry += "                 "+cColCls+" CLSTRIB "
	cQry += "          FROM "+RetSqlName("F2D")+" F2D "
	cQry += "          WHERE F2D.F2D_FILIAL = '"+cFilF2D+"' "
	cQry += "            AND F2D.F2D_TABELA = '"+cTabF2D+"' "
	cQry += "            AND F2D.F2D_DTEXCL = ' ' "
	cQry += "            AND F2D.F2D_IDREL  <> ' ' "
	cQry += "            AND F2D.D_E_L_E_T_ = ' ' "
	cQry += "            AND F2D.F2D_IDREL IN ( SELECT SFTRTC.FT_IDTRIB "
	cQry += "                                     FROM "+RetSqlName("SFT")+" SFTRTC "
	cQry += "                                    WHERE SFTRTC.FT_FILIAL  = '"+cFilSFT+"' "
	cQry += "                                      AND SFTRTC.FT_TIPOMOV = '"+cTipoMov+"' "
	cQry += "                                      AND SFTRTC.FT_NFISCAL = '"+cDoc+"' "
	cQry += "                                      AND SFTRTC.FT_SERIE   = '"+cSer+"' "
	cQry += "                                      AND SFTRTC.FT_CLIEFOR = '"+cCod+"' "
	cQry += "                                      AND SFTRTC.FT_LOJA    = '"+cLoja+"' "
	cQry += "                                      AND SFTRTC.FT_IDTRIB <> ' ' ) "
	cQry += "        ) RTCX "
	cQry += "   GROUP BY RTCX.IDREL ) "

return cQry

/*/{Protheus.doc} colTribSelect
Lista de colunas de tributo para a clausula SELECT de quem consome a tabela
derivada. O COALESCE garante zero - e nao nulo - para o item que nao tem
tributo da Reforma registrado no Configurador.

@type   method
@author Pablo Regis
@since  23/11/2026
@param  cAlias, character, alias da tabela derivada no FROM (default "RTC")
@return character, fragmento SQL com as colunas, iniciado por virgula
/*/
method colTribSelect(cAlias) class DHLSafxRtc

	local cCol  := ""
	local aNum  := {}
	local aChr  := {}
	local nI    := 0

	default cAlias := RTC_ALIAS_AGREG

	aNum := { RTC_COL_BAS_UF, RTC_COL_ALQ_UF, RTC_COL_VLR_UF,;
	          RTC_COL_BAS_MU, RTC_COL_ALQ_MU, RTC_COL_VLR_MU,;
	          RTC_COL_BAS_CB, RTC_COL_ALQ_CB, RTC_COL_VLR_CB,;
	          RTC_COL_BAS_IS, RTC_COL_ALQ_IS, RTC_COL_VLR_IS }

	aChr := { RTC_COL_CST_UF, RTC_COL_CST_MU, RTC_COL_CST_CB,;
	          RTC_COL_CST_IS, RTC_COL_CLSTRIB }

	for nI := 1 to Len(aNum)
		cCol += ", COALESCE("+cAlias+"."+aNum[nI]+", 0) "+aNum[nI]+" "
	next nI

	for nI := 1 to Len(aChr)
		cCol += ", COALESCE("+cAlias+"."+aChr[nI]+", ' ') "+aChr[nI]+" "
	next nI

return cCol

/*/{Protheus.doc} hasTribIS
Indica se o codigo do tributo do Imposto Seletivo esta configurado.

@type   method
@author Pablo Regis
@since  23/11/2026
@return logical, .T. quando ZZ_TRIBSEL esta preenchido
/*/
method hasTribIS() class DHLSafxRtc
return !Empty(::cTribIS)

/*/{Protheus.doc} hasClassTrib
Indica se o campo da CJ3 com o cClassTrib foi informado e existe no SX3.

@type   method
@author Pablo Regis
@since  23/11/2026
@return logical, .T. quando ZZ_SFXCCLT aponta campo valido da CJ3
/*/
method hasClassTrib() class DHLSafxRtc
return !Empty(::cFldCls)

/*/{Protheus.doc} logConfig
Registra em log a configuracao resolvida e as lacunas conhecidas. Chamado uma
vez por execucao, para que a conciliacao saiba de onde cada valor veio.

@type   method
@author Pablo Regis
@since  23/11/2026
@param  cOrigem, character, rotina que esta gerando (ex.: "SAFX3007")
/*/
method logConfig(cOrigem) class DHLSafxRtc

	local cMsg := ""

	default cOrigem := "SAFX"

	cMsg := "[" + cOrigem + "] Tributos F2D: IBS-UF=" + ::cTribUF + ;
	        " IBS-MUN=" + ::cTribMun + " CBS=" + ::cTribCBS

	if ::hasTribIS()
		cMsg += " IS=" + ::cTribIS
	else
		cMsg += " IS=<nao configurado, " + RTC_PAR_TRIB_IS + " vazio - campos de IS saem zerados>"
	endIf

	if ::hasClassTrib()
		cMsg += " cClassTrib=" + ::cFldCls
	else
		cMsg += " cClassTrib=<nao configurado, " + RTC_PAR_CCLASTR + " vazio - campo sai em branco>"
	endIf

	FWLogMsg("INFO", , "BusinessObject", FunName(), "", "01", cMsg, 0, 0, {})

return
