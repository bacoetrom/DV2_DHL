#include 'protheus.ch'
#include 'parmtype.ch'
#include 'dhl.ch'

//ARRAY aEntrega
#define CNPJ		1				
#define ENDERECO	2		
#define NUMERO		3		
#define COMPLEMENTO	4		
#define BAIRRO		5		
#define COD_MUN		6		
#define MUNICIPIO	7		
#define ESTADO		8		

//ARRAY aDest
#define DEST_END		3		
#define DEST_NUMERO		4		
#define DEST_COMPLEM	5		
#define DEST_BAIRRO		6		
#define DEST_COD_MUN	7		
#define DEST_MUN		8		
#define DEST_ESTADO		9		
#define DEST_CEP		10

/*/{Protheus.doc} PrcEndEnt
Processamento de Alteração do Endereço de Entrega
@author Thiago Meschiatti
@since 21/07/2016
@version undefined

@type function
/*/
user function PrcEndEnt(aDest, aEntrega)
	local lEntrega	:= len(aEntrega) > 0
	local cEnd		:= ""
	local cNum		:= ""
	local cComplem	:= ""
	local cBairro	:= ""
	local cCodMun	:= ""
	local cMun		:= ""
	local cUf		:= ""
	local cCep		:= "" 
	
	if lEntrega
		cEnd		:= aEntrega[ENDERECO]
		cNum		:= aEntrega[NUMERO]
		cComplem	:= aEntrega[COMPLEMENTO]
		cBairro		:= aEntrega[BAIRRO]
		cCodMun		:= aEntrega[COD_MUN]
		cMun		:= aEntrega[MUNICIPIO]
		cUf			:= aEntrega[ESTADO]
		cCep		:= retCepEnt()
		
		aDest[DEST_END]		:= cEnd	
		aDest[DEST_NUMERO]	:= cNum	
		aDest[DEST_COMPLEM]	:= cComplem
		aDest[DEST_BAIRRO]	:= cBairro	
		aDest[DEST_COD_MUN]	:= cCodMun	
		aDest[DEST_MUN]		:= cMun	
		aDest[DEST_ESTADO]	:= cUf		
		aDest[DEST_CEP]		:= cCep
		
		aEntrega := {}
	endif              	         		
	
return


/*
** Retorna o Cep do cliente de entrega
*/
static function retCepEnt()
	local oSql 		:= IpSqlObject():newIpSqlObject()
	local cQuery	:= ""
	local cRet		:= ""
	
	oSql:newTable("SA1", "A1_CEP", "%SA1.XFILIAL% AND A1_COD = '"+SF2->F2_CLIENT+"' AND A1_LOJA = '"+SF2->F2_LOJENT+"'")
	
	if oSql:hasRecords()
		cRet := oSql:getValue("A1_CEP")
	endif 
	
	oSql:close()
	
return (cRet)