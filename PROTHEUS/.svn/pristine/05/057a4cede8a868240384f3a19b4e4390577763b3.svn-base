#include 'protheus.ch'
#include 'parmtype.ch'

STATIC __aDePara := NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCifra    ºAutor  ³Julio Wittwer       º Data ³  10/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera um numero identificador unico de 9 digitos             º±±
±±º          |  a partir de um numero de 8 digitos, sem repeticao         º±±
±±º          ³Observacao : Criptografa apenas os 6 digitos apos os 2      º±±
±±º          | primeiros.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function GCifra(nNum, nDig)
	Local cNumNF := strzero(nNum,9)
	Local nDV := val(right(cNumNF,1)) // Tabela de-para de acordo com o ultimo digito
	Local cNumCheck := ''
	Local nI
	local cRet 		:= ""
		
	private aValid	:= {}

	DEFAULT	nDig	:=	9  

	nIniFor	:=	Iif(nDig==8,4,3)

	If __aDePara == NIL

		/*
		************************************************************
		***      Carrega tabela de-para de troca de numeros     ****
		*** ATENCAO : JAMAIS ALTERAR NENHUM DIGITO DESTE CODIGO ****
		************************************************************
		*/

		__aDePara := {}
		aadd(__aDePara,"3247015698")
		aadd(__aDePara,"8762341509")
		aadd(__aDePara,"1350924687")
		aadd(__aDePara,"6420875931")
		aadd(__aDePara,"2345678901")
		aadd(__aDePara,"5398712460")
		aadd(__aDePara,"1470258369")
		aadd(__aDePara,"5647382901")
		aadd(__aDePara,"9123765408")
		aadd(__aDePara,"1973820564")

	Endif

	// Fase 1 : Pega do terceiro ao oitavo digito 
	// E realiza a troca pela tabela de-para
	For nI := nIniFor to 8
		nOrig := asc(substr(cNumNF,nI,1))-47
		cNumCheck += substr( __aDePara[nDV+1], nOrig , 1)
	Next

	// Fase 2: Desloca o numero gerado um pouco ...
	For nI := 0 to nDV+1
		cNumCheck := substr(cNumCheck,2)+left(cNumCheck,1)
	Next

	// Fase 3 : Copia os 2 primeiros digitos, mais o numero criptografado, 
	// mais o ultimo numero, que foi o indice usado para fazer as trocas ! 
	cRet := left(cNumNF,2)+cNumCheck+right(cNumNF,1) 

return ( cRet )

//-----------------------------------------------------------------------
/*/{Protheus.doc} getRandom
Funcao responsavel por retornar numeros randomicos a cada chamada.

Chamada das funcoes Pai
NFEIDE / U_XMLNFESEF		-> NfeSefaz.prw
U_XMLMDFESEF / MDFEREMES	-> SpedMdfe.prw
MDFEIDE						-> MDeSefaz.prw

@return 	lRet	Fonte que chamou podera obter o retorno desta funcao.
cRet	Conteudo do numero randomico.

@author Douglas Parreja
@since 03/02/2019
@version 12.1.23
/*/
//-----------------------------------------------------------------------
static function getRandom()

	local lRet	:= .T.
	local cRet	:= ""
	/*
	if ( alltrim(upper(procName(1))) == "GCIFRA" )
	if ( alltrim(upper(procName(2))) == "INVERTE" )
	if ( (alltrim(upper(procName(3))) == "NFEIDE") .or. (alltrim(upper(procName(3))) == "MDFEIDE") )
	if ( (alltrim(upper(procName(4))) == "U_XMLNFESEF") .or. (alltrim(upper(procName(4))) == "U_XMLMDFESEF") )
	lRet := .T.
	endif
	elseif (alltrim(upper(procName(3))) == "MDFEREMES") 
	lRet := .T.				
	endif
	endif
	endif
	*/

	if ( lRet )
		cRet := alltrim(str(Randomize( 10000000, 99999999 ))) 
	endif

return { lRet, cRet }

//-----------------------------------------------------------------------
/*/{Protheus.doc} validRandom
Funcao responsavel por validar o array no retorno da funcao getRandom.

@return 	lRet	Esta Ok ou nao para continuar o processo.

@author Douglas Parreja
@since 03/02/2019
@version 12.1.23
/*/
//-----------------------------------------------------------------------
static function validRandom()
	local lRet := .F.
	if ( type("aValid") <> "U" )
		if ( type("aValid") == "A" )
			if ( len(aValid) > 0 )
				if ( type("aValid[1]") == "L" )
					if ( len(aValid) > 1 )
						if ( type("aValid[2]") == "C" )
							if ( aValid[1] )
								lRet := .T.
							endif
						endif
					endif
				endif
			endif
		endif
	endif
return ( lRet )