#Include 'Protheus.ch'
#include "dhl.ch"

#define	ITEM_NF		1
#define	NUM_PV		2
#define	ITEM_PV		3

#define	DOC_SERIE	1
#define	DATA_DOC	2
#define	ITEM_REF	3

/*/{Protheus.doc} MsgIdNf

Grava informações da NF do primeiro passo na tabela SZZ

@author Victor Hugo
@since 30/10/2014
/*/
User Function MsgIdNf(cNota, cSerie, cClieFor, cLoja, aIdItens)
	local oId 		:= DHLIdManager():newDHLIdManager()	
	local nI		:= 0
	local cMsg		:= ""
	local dDtMov	
	local aNfs		:= {}
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local oSqlUtil  := IpSqlObject():newIpSqlObject()

	if !(SF2->F2_TIPO $ 'B|D|')
		if oSqlUtil:getFieldValue("SA1", "A1_ZZDEPOS", " %SA1.XFILIAL% AND A1_COD = '"+cClieFor+"' AND A1_LOJA = '"+cLoja+"' ") = 'S'
		
			aIdItens := aSort(aIdItens, , , { | x,y | x[ITEM_NF] < y[ITEM_NF] } )
			
			for nI := 1 to len(aIdItens)
			
				oSql:newTable("SC6", "C6_ZZID", " %SC6.XFILIAL% AND C6_NUM = '"+aIdItens[nI, NUM_PV]+"' AND C6_ITEM = '"+aIdItens[nI, ITEM_PV]+"'")
				cId := oSql:getValue("C6_ZZID")
				oSql:close()
			
				oSql:newAlias(oId:getRefNfId(, cId, cClieFor, cLoja)) 
				
				if oSql:hasRecords()
					nPos := ascan(aNfs, { |x| alltrim(x[1]) == oSql:getValue("Z3_DOC")+ "-"+ alltrim(oSql:getValue("Z3_SERIE"))})
					if nPos == 0
						dDtMov := stod(oSqlUtil:getFieldValue("SF1", "F1_EMISSAO", " %SF1.XFILIAL% AND F1_DOC = '"+oSql:getValue("Z3_DOC")+"'AND "+;
									" F1_SERIE = '"+oSql:getValue("Z3_SERIE")+"' AND F1_FORNECE = '"+cClieFor+"' AND F1_LOJA = '"+cLoja+"' "))
						if empty(dDtMov)
							dDtMov := stod(oSqlUtil:getFieldValue("SZ3", "Z3_DTMOV", " %SZ3.XFILIAL% AND Z3_DOC = '"+oSql:getValue("Z3_DOC")+"'AND "+;
									" Z3_SERIE = '"+oSql:getValue("Z3_SERIE")+"' AND Z3_CLIFOR = '"+cClieFor+"' AND Z3_LOJA = '"+cLoja+"' AND "+;
									" Z3_ID = '"+cId+"' AND Z3_SEQUEN = '"+oSql:getValue("SEQ")+"' "))
						endif 						
						aadd(aNfs, {oSql:getValue("Z3_DOC")+ "-"+ alltrim(oSql:getValue("Z3_SERIE")),;
									dtoc(dDtMov),;
									alltrim(aIdItens[nI, ITEM_NF])})
					else
						aNfs[nPos, ITEM_REF] += ";"+aIdItens[nI, ITEM_NF]
					endif
				endif			
				oSql:close()	
			next nI
			procMsg(aNfs, cNota, cSerie, cClieFor, cLoja)
		endif
	endif

Return()


/*
** Processamento Gravação
*/
static function procMsg(aNfs, cNota, cSerie, cClieFor, cLoja)
	local oSqlUtil	:= IpSqlObject():newIpSqlObject()
	local nI 		:= 0
	local cNome		:= ""
	local cMsg 		:= ""
	
	for nI:=1 to len(aNfs)
		cNome := oSqlUtil:getFieldValue("SA1", "A1_NREDUZ", " %SA1.XFILIAL% AND A1_COD = '"+cClieFor+"' AND A1_LOJA = '"+cLoja+"' ")
		cMsg  := " * Retorno de peca BAD, conforme NF(s) de Origem " + cNome + " " +aNfs[nI, DOC_SERIE] + " - emitida em " + aNfs[nI, DATA_DOC] + " ; " + aNfs[nI, ITEM_REF] + " * "
		fGravaMsg(cNota, cSerie, cClieFor, cLoja, cMsg) 
	next nI
return


/*
** Grava informação na tabela de template Mensagens NF (SZZ)
*/
static function fGravaMsg(cNota, cSerie, cClieFor, cLoja, cMsg)
	Local oTMsg  := FswTemplMsg():newTemplMsg("S", cNota, cSerie, cClieFor, cLoja,"SZZ")
	
	aadd(oTMsg:aMsg, {"",cMsg})
	
	oTMsg:grvMsg()
return()