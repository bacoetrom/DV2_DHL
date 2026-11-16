#include 'protheus.ch'
#include 'parmtype.ch'
#include 'safx.ch'
#include 'safx10.ch' 
#include 'dhl.ch' 

/*/{Protheus.doc} SAFX10MSDW

Respons‡vel por gerar o arquivo SAFX10
	
@author Daniel Braga
@since 30/10/2014

/*/
user function SAFX10MSDW(aCompany,dDtFrom,dDtUntil)
	
	local oDhlSafx		:= DhlSafx():newDhlSafx()
	private lGerouArqs	:= .F. 
	PRIVATE lX10_SA1	:= .T.
	default aCompany	:=  {}	
	default dDtFrom 	:= ctod("01/"+ cValToChar(Month(Date()-1)) + "/" + cValToChar(Year(Date()-1)))
	default dDtUntil	:= Date()-1
	
	if !oDhlSafx:prepareEnvironment(aCompany)
		return .F.
	endIf
	 				
	SAFX10(dDtFrom, dDtUntil)	
	
return lGerouArqs

static function x10OPsc6(dDtFrom,dDtUntil,aOPSC6, oDHLSafx10)
	local oIpSqlx10 	:= IpSqlObject():newIpSqlObject()
	local cAlias		:= ""
	local nPos		:= 0
	

	oIpSqlx10:newAlias( oDHLSafx10:getSqlOP(dDtFrom,dDtUntil) ) // distinct da d3_op  6 primeiras posicoes
	
	cAlias := oIpSqlx10:getAlias()
	//nCount := oIpSqlx10:count()
	(cAlias)->( DbGoTop() )
	
	while oIpSqlx10:notIsEof()
		nPos	:= ascan( aOPSC6 , {|Z| Z[1] == alltrim( oIpSqlx10:getvalue("XOP")) })
		
		if nPos == 0
			sfc6( @aOPSC6 , alltrim(oIpSqlx10:getvalue("XOP")) )
		else
			npos := npos //
		endif
	
		oIpSqlx10:skip()	
	endDo
	oIpSqlx10:close()

return

static function sfc6( aOPSC6 , cOP_)
Local cQuery	:= ""
Local cAlias	:= NIL //getnextalias()
Local aOPS	:= {}
Local nI	:= nPos	:= 0

	if empty( cOP_ )
		return
	endif
	cAlias	:= getnextalias()

	cQuery := ""
	cquery += " SELECT C6_SERIE , C6_NOTA , C6_ZZOP FROM "
	cQuery += retSqlName("SC6")+" sc6 where                                                                                      "   +CRLF
	cQuery += " 	sc6.c6_zzop like '%" + alltrim(cOP_) + "%' "                 +CRLF
	cQuery += " 	and sc6.c6_filial =  '"+xFilial("SB1")+"'                                                                       "           +CRLF
	cQuery += " 	and sc6.d_e_l_e_t_= ' '                                                                                   "     

	dbUseArea( .t. , "TOPCONN",TcGenQry(,,cQuery),cAlias,.f.,.t.)
	
	if (cAlias)->(!EOF())
		aOPS := separa( alltrim((cAlias)->C6_ZZOP),";")
		for ni := 1 to len( aOPS )
			npos := ascan( aOPSC6 , {|Z| Z[1] == alltrim( aOPS[ni] ) })
			if npos == 0
				aadd( aOPSC6 , { alltrim( aOPS[ni] ) , (cAlias)->c6_serie , (cAlias)->c6_nota } )
			else
				ni := ni
			endif
		next
	endif
	(cAlias)->(dbclosearea())
return


static function SAFX10(dDtFrom,dDtUntil)

	local oFileSfx10 	:= MsafDWFile():newMsafDWFile("10", SAFX10_POSICOES)
	local oIpSqlSfx10 	:= IpSqlObject():newIpSqlObject()
	local oDHLSafx10	:= DHLSafx10():newDHLSafx10()
	local aFields		:= {}
	local cError		:= ""
	local cAlias		:= ""
	local nCount		:= 0 	
	Local aOPSC6		:= {}
	default dDtFrom 	:= ctod("/ /")
	default dDtUntil	:= ctod("/ /")

	x10OPsc6(dDtFrom,dDtUntil,@aOPSC6, oDHLSafx10)
	
	oIpSqlSfx10:newAlias( oDHLSafx10:getSql(dDtFrom,dDtUntil) )
	
	cAlias := oIpSqlSfx10:getAlias()
	nCount := oIpSqlSfx10:count()
	(cAlias)->( DbGoTop() )
	
	while oIpSqlSfx10:notIsEof()
		
		oDHLSafx10:initialize(SAFX10_POSICOES,oIpSqlSfx10)
			
		oDHLSafx10:addLine(aOPSC6)
		
		aFields := oDHLSafx10:getFields()
		cError	:= oDHLSafx10:validRequired(VLD_FIELD_10)
		
		if !Empty(cError)
			cError += getIdMovimento(oDHLSafx10)
			oDHLSafx10:addLog(SAFX10_ERROR_TITLE,SAFX10_ERROR_OBRIGAT+cError,oFileSfx10:getFile())
			oIpSqlSfx10:skip()
			loop
		endIf
		
		oFileSfx10:setFields( aFields )
		
		if oFileSfx10:write()
			lGerouArqs := .T.
		else
			oDHLSafx10:addLog(SAFX10_ERROR_TITLE,ERROR_QTD_CAMPOS,oFileSfx10:getFile())
			oIpSqlSfx10:skip()
			loop		
		endif

		oIpSqlSfx10:skip()	
	endDo
	oIpSqlSfx10:close()
	oFileSfx10:renameArq("10", SAFX10_POSICOES)
	oFileSfx10:close()
return 

	
/**
 * Coleta o ID do Movimento para o Log de Erros
 */
static function getIdMovimento(oDHLSafx10)
	
	local cIdMov  := CRLF+CRLF
	local cTpMov  := ""
	local cTabela := Upper(oDHLSafx10:getFieldValue("ARQ")) 
	local cDoc	  := AllTrim(oDHLSafx10:getFieldValue("NUM_DOCTO"))
	local cSerie  := oDHLSafx10:getFieldValue("SERIE_DOCFIS")
	local dData	  := StoD(oDHLSafx10:getFieldValue("DATA_MOVTO"))
	
	if (cTabela == "SD1")
		cTpMov := "NF Entrada"
	elseIf (cTabela == "SD2")
		cTpMov := "NF Saida"
	elseIf (cTabela == "SD3")
		cTpMov := "Movimento Interno"	
	endIf	
	
	if !Empty(cSerie)
		cDoc += "/"+cSerie
	endIf
	
	cIdMov += "Tipo Movimento: "+cTpMov+CRLF
	cIdMov += "Documento: "+cDoc+CRLF
	cIdMov += "Data: "+DtoC(dData)
	
return cIdMov
