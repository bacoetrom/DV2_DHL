#include "protheus.ch" 
#include "msobject.ch" 
#include "fileio.ch" 
#include "rwmake.ch"
#include "font.ch"
#include "colors.ch"
#include "dhl.ch"

#define USADO chr(0) + chr(0) + chr(1)

/*
** "dummy" function - Internal use only
*/
User Function _FswTemplMsg; Return

/*/{Protheus.doc} MsafNfeFile

Template de Mensagens de Notas Fiscais
	
@author Deivid A. C. de Lima
@since 07/01/2015
/*/
class FswTemplMsg

	data cAlias		as string		// alias da tabela de mensagens de NF
	data cPrfAlias	as string		// prefixo do alias da tabela de mensagens de NF
	data cTpNF		as string		// Tipo da Nota Fiscal(E/S)
	data cDoc		as string		// Numero da NF
	data cSerie		as string		// Serie da NF
	data cCliFor	as string		// Codigo do Cliente/Fornecedor
	data cLoja		as string		// Loja do Cliente/Fornecedor
	data aCampos	as array		// Array com os campos de dados adicionas da NF
	data aMsg		as array		// Array com as mensagens da NF
	data aMsgDel	as array		// Array com as mensagens da NF deletadas

	method newTemplMsg() Constructor
	
	method getAlias()
	method setAlias()
	method getPrfAlias()
	method setPrfAlias()
	method getTpNF()
	method setTpNF()
	method getDoc()
	method setDoc()
	method getSerie()
	method setSerie()
	method getCliFor()
	method setCliFor()
	method getLoja()
	method setLoja()
	method getCampos()
	method setCampos()
	method addField()
	method getMsg()
	method setMsg()
	method processa()
	method excMsg()
	method grvMsg()
	method delMsg()
	method carMsg()
	method intDadosNF()
	method grvDadosNF()
	method getName()
	method getCpo()
	method tudoOK()
	
endclass


/*/{Protheus.doc} newTemplMsg

Metodo Construtor da Classe
	
@author Winston Dellano de Castro
@since 07/01/2015

@param cTpNF,   String, Tipo da Nota Fiscal(E/S)
@param cDoc,    String, Numero da NF
@param cSerie,  String, Serie da NF
@param cCliFor, String, Codigo do Cliente/Fornecedor
@param cLoja,   String, Loja do Cliente/Fornecedor
@param cAlias,  String, Alias da tabela de mensagens da nota
/*/
method newTemplMsg(cTpNF,cDoc,cSerie,cCliFor,cLoja,cAlias) class FswTemplMsg

	local aDummy   := {}
	
	default cAlias := SuperGetMV("ZZ_ALIASTM",,"SZZ",)

	::setAlias(cAlias)
	::setPrfAlias()	 
	::setTpNF(cTpNF)
	::setDoc(cDoc)
	::setSerie(cSerie)
	::setCliFor(cCliFor)
	::setLoja(cLoja)  
	::setMsg(aDummy)
	::setCampos(aDummy)

return


/*/{Protheus.doc} getAlias

Coleta o alias da tabela de mensagens da nota
	
@author Winston Dellano de Castro
@since 07/01/2015

@return String alias da tabela de mensagens da nota
/*/
method getAlias() class FswTemplMsg
return ::cAlias


/*/{Protheus.doc} setAlias

Define o alias da tabela de mensagens da nota
	
@author Winston Dellano de Castro
@since 07/01/2015

@param cAlias, String, Alias da tabela de mensagens da nota
/*/
method setAlias(cAlias) class FswTemplMsg
	::cAlias := cAlias
return


/*/{Protheus.doc} getPrfAlias

Coleta o prefixo da tabela de mensagens da nota
	
@author Winston Dellano de Castro
@since 07/01/2015

@return String prefixo da tabela de mensagens da nota
/*/
method getPrfAlias() class FswTemplMsg
return ::cPrfAlias


/*/{Protheus.doc} setPrfAlias

Define o prefixo da tabela de mensagens da nota
	
@author Winston Dellano de Castro
@since 07/01/2015

@param cPrfAlias, String, prefixo da tabela de mensagens da nota
/*/
method setPrfAlias(cPrfAlias) class FswTemplMsg

	local cAlias := ::getAlias()
	
	::cPrfAlias := iif(Left(cAlias,1) == "S",Substr(cAlias,2,2),cAlias)
	
return


/*/{Protheus.doc} getTpNF

Coleta o tipo da nota fiscal (E=Entrada,S=Saida)
	
@author Winston Dellano de Castro
@since 07/01/2015

@return String TpNF da tabela de mensagens da nota
/*/
method getTpNF() class FswTemplMsg
return ::cTpNF


/*/{Protheus.doc} setTpNF

Define o o tipo da nota fiscal (E=Entrada,S=Saida)
	
@author Winston Dellano de Castro
@since 07/01/2015

@param cTpNF, String, TpNF da tabela de mensagens da nota
/*/
method setTpNF(cTpNF) class FswTemplMsg
	::cTpNF := cTpNF
return


/*/{Protheus.doc} getDoc

Coleta o numero da nota fiscal
	
@author Winston Dellano de Castro
@since 07/01/2015

@return String Doc da tabela de mensagens da nota
/*/
method getDoc() class FswTemplMsg
return ::cDoc


/*/{Protheus.doc} setDoc

Define o numero da nota fiscal
	
@author Winston Dellano de Castro
@since 07/01/2015

@param cDoc, String, Doc da tabela de mensagens da nota
/*/
method setDoc(cDoc) class FswTemplMsg
	::cDoc := cDoc
return


/*/{Protheus.doc} getSerie

Coleta a Serie da nota fiscal
	
@author Winston Dellano de Castro
@since 07/01/2015

@return String Serie da tabela de mensagens da nota
/*/
method getSerie() class FswTemplMsg
return ::cSerie


/*/{Protheus.doc} setSerie

Define a Serie da nota fiscal
	
@author Winston Dellano de Castro
@since 07/01/2015

@param cSerie, String, Serie da tabela de mensagens da nota
/*/
method setSerie(cSerie) class FswTemplMsg
	::cSerie := cSerie
return


/*/{Protheus.doc} getCliFor

Coleta o Cliente/Fornecedor da nota fiscal
	
@author Winston Dellano de Castro
@since 07/01/2015

@return String CliFor da tabela de mensagens da nota
/*/
method getCliFor() class FswTemplMsg
return ::cCliFor


/*/{Protheus.doc} setCliFor

Define o Cliente/Fornecedor da nota fiscal
	
@author Winston Dellano de Castro
@since 07/01/2015

@param cCliFor, String, CliFor da tabela de mensagens da nota
/*/
method setCliFor(cCliFor) class FswTemplMsg
	::cCliFor := cCliFor
return


/*/{Protheus.doc} getLoja

Coleta a Loja do Cliente/Fornecedor da nota fiscal
	
@author Winston Dellano de Castro
@since 07/01/2015

@return String Loja da tabela de mensagens da nota
/*/
method getLoja() class FswTemplMsg
return ::cLoja


/*/{Protheus.doc} setLoja

Define a Loja do Cliente/Fornecedor da nota fiscal
	
@author Winston Dellano de Castro
@since 07/01/2015

@param cLoja, String, Loja da tabela de mensagens da nota
/*/
method setLoja(cLoja) class FswTemplMsg
	::cLoja := cLoja
return


/*/{Protheus.doc} getCampos

Coleta o array com os campos a serem mostrados
	
@author Winston Dellano de Castro
@since 07/01/2015

@return String Campos da tabela de mensagens da nota
/*/
method getCampos() class FswTemplMsg
return ::aCampos


/*/{Protheus.doc} setCampos

Define o array com os campos a serem mostrados
	
@author Winston Dellano de Castro
@since 07/01/2015

@param aCampos, String, Campos da tabela de mensagens da nota
/*/
method setCampos(aCampos) class FswTemplMsg
	::aCampos := aCampos
return


/*/{Protheus.doc} addField

Adciona campos ao array aCampos
	
@author Winston Dellano de Castro
@since 07/01/2015

@param cCampo, String  , Nome do campo
@param uValor, Conteúdo, Conteúdo do campo
/*/
method addField(cCampo,uValor) class FswTemplMsg
	aAdd(::aCampos,{cCampo,uValor})
return


/*/{Protheus.doc} getMsg

Coleta o array com as mensagens da nota fiscal
	
@author Winston Dellano de Castro
@since 07/01/2015

@return String Msg da tabela de mensagens da nota
/*/
method getMsg() class FswTemplMsg
return ::aMsg


/*/{Protheus.doc} setMsg

Define o array com as mensagens da nota fiscal
	
@author Winston Dellano de Castro
@since 07/01/2015

@param aMsg, String, Msg da tabela de mensagens da nota
/*/
method setMsg(aMsg) class FswTemplMsg
	::aMsg := aMsg
return


/*/{Protheus.doc} processa

Metodo de processamento dos dados adicionais e mensagens da NF

@author Winston Dellano de Castro
@since 07/01/2015
/*/
method processa() class FswTemplMsg

	::carMsg(.F.)
	
	::intDadosNF()
	
	::grvMsg()

return


/*/{Protheus.doc} excMsg

Metodo de exclusao das mensagens da NF
	
@author Winston Dellano de Castro
@since 07/01/2015
/*/
method excMsg() class FswTemplMsg

	local cAlias := ::getAlias()
	local aArea  := Lj7GetArea({cAlias})
	local cSeek  := xFilial(cAlias) + ::getTpNF() + ::getDoc() + ::getSerie() + ::getCliFor() + ::getLoja()
	local bWhile := {|| ::getCpo("FILIAL") + ::getCpo("TIPODOC") + ::getCpo("DOC") + ::getCpo("SERIE") + ::getCpo("CLIFOR") + ::getCpo("LOJA") == cSeek}
	
	dbSelectArea(cAlias)
	(cAlias)->(dbSetOrder(1))
	(cAlias)->(dbSeek(cSeek))
	
	while !((cAlias)->(Eof())) .and. Eval(bWhile)
	
		RecLock(cAlias,.F.)
			(cAlias)->(dbDelete())
		MsUnlock()
		
		(cAlias)->(dbSkip())
	enddo
	
	Lj7RestArea(aArea)

return


/*/{Protheus.doc} grvMsg

Metodo de gravacao das mensagens da NF
	
@author Winston Dellano de Castro
@since 07/01/2015
/*/
method grvMsg() class FswTemplMsg

	local nI      := 0
	local nJ      := 0
	local nCnt    := 0
	local nSeq    := 0
	local cAlias  := ::getAlias()
	local nTamTxt := Len(::getCpo("TXTMENS"))
	local nTamSeq := Len(::getCpo("SEQMENS"))
	local cField  := cAlias + "->" + ::getPrfAlias() + "_"
	
	dbSelectArea(cAlias)
	
	for nI := 1 to Len(::aMsg)
				
		nCnt := MlCount(::aMsg[nI][2],nTamTxt)
		
		for nJ := 1 to nCnt
		
			nSeq++
			
			dbSelectArea(cAlias)
			(cAlias)->(dbSetOrder(1))
			
			if !((cAlias)->(dbSeek(xFilial("SZZ") + ::getTpNF() + ::getDoc() + ::getSerie() + ::getCliFor() + ::getLoja() + ::aMsg[nI][1] + StrZero(nSeq,nTamSeq))))
				
				RecLock(cAlias,.T.)
					&(cField + "FILIAL" ) := xFilial(cAlias)
					&(cField + "TIPODOC") := ::getTpNF()
					&(cField + "DOC"    ) := ::getDoc()
					&(cField + "SERIE"  ) := ::getSerie()
					&(cField + "CLIFOR" ) := ::getCliFor()
					&(cField + "LOJA"   ) := ::getLoja()
					&(cField + "SEQMENS") := StrZero(nSeq,nTamSeq)
					&(cField + "CODMENS") := ::aMsg[nI][1]
					&(cField + "TXTMENS") := MemoLine(::aMsg[nI][2],nTamTxt,nJ)
				MsUnlock()			
			
			else
				if AllTrim(Upper(&(cField + "TXTMENS"))) != AllTrim(Upper(MemoLine(::aMsg[nI][2],nTamTxt,nJ)))
					RecLock(cAlias,.F.)
						&(cField + "TXTMENS") := MemoLine(::aMsg[nI][2],nTamTxt,nJ)
					MsUnlock()
				endif
			endif	
		next		
		nSeq := 0
	next

return


/*/{Protheus.doc} delMsg

Metodo de exclusão das mensagens da NF
	
@author Winston Dellano de Castro
@since 07/01/2015
/*/
method delMsg() class FswTemplMsg

	local nI      := 0
	local nJ      := 0
	local nCnt    := 0
	local nSeq    := 0
	local cAlias  := ::getAlias()
	local nTamTxt := Len(::getCpo("TXTMENS"))
	local nTamSeq := Len(::getCpo("SEQMENS"))
	local cField  := cAlias + "->" + ::getPrfAlias() + "_"
	
	dbSelectArea(cAlias)
	
	for nI := 1 to Len(::aMsgDel)
				
		nCnt := MlCount(::aMsgDel[nI][2],nTamTxt)
		
		for nJ := 1 to nCnt
		
			nSeq++
			
			dbSelectArea(cAlias)
			(cAlias)->(dbSetOrder(1))
			
			if (cAlias)->(dbSeek(xFilial("SZZ") + ::getTpNF() + ::getDoc() + ::getSerie() + ::getCliFor() + ::getLoja() + ::aMsgDel[nI][1] + StrZero(nSeq,nTamSeq)))				
				RecLock(cAlias,.F.)
					(cAlias)->(dbDelete())
				MsUnlock()
			endif	
		next		
		nSeq := 0
	next

return


/*/{Protheus.doc} grvDadosNF

Metodo de gravacao dos dados adicionais da NF
	
@author Winston Dellano de Castro
@since 07/01/2015

@param nOpc, Numerico, Conteúdo a ser gravado:(1) Memoria,(2) array aCampos
/*/
method grvDadosNF(nOpc) class FswTemplMsg

	local cAliasG := iif(::getTpNF() == "E","SF1","SF2")
	local nI      := 0
	
	default nOpc := 1
	
	RecLock(cAliasG,.F.)
	
		for nI := 1 to Len(::aCampos)
			if nOpc == 1
				&(cAliasG+"->"+::aCampos[nI][1]) := &("M->"+::aCampos[nI][1])
			else
				&(cAliasG+"->"+::aCampos[nI][1]) := ::aCampos[nI][2]
			endif		
		next nI
	
	MsUnlock()

return


/*/{Protheus.doc} carMsg

Metodo para carregar as mensagens gravadas da NF
	
@author Winston Dellano de Castro
@since 07/01/2015

@param lGravado, Lógico, Indica se a mensagem já está gravada
/*/
method carMsg(lGravado) class FswTemplMsg

	local cAlias := ::getAlias()
	local aArea  := Lj7GetArea({"SD2","SD1","SC5","SB1","SF4",cAlias})
	local cSeek  := ::getDoc() + ::getSerie() + ::getCliFor() + ::getLoja()
	local bWhile := {|| ::getCpo("FILIAL") + ::getCpo("TIPODOC") + ::getCpo("DOC") + ::getCpo("SERIE") + ::getCpo("CLifor") + ::getCpo("LOJA") == xFilial(cAlias) + ::getTpNF() + cSeek}
	local nP     := 0
	local cCod   := ""
	
	default lGravado := .T.
	
	::aMsg := {}
	
	if lGravado
		dbSelectArea(cAlias)
		(cAlias)->(dbSetOrder(1))
		(cAlias)->(dbSeek(xFilial(cAlias) + ::cTpNF + cSeek))
		
		while !((cAlias)->(Eof())) .and. Eval(bWhile)
			aAdd(::aMsg,{::getCpo("CODMENS"),::getCpo("TXTMENS")})
			
			(cAlias)->(dbSkip())
		enddo
	else
		if ::getTpNF() == "E"
			SB1->(dbSetOrder(1))
			SF4->(dbSetOrder(1))
	
			dbSelectArea("SD1")
			SD1->(dbSetOrder(1))
			SD1->(dbSeek(xFilial("SD1") + cSeek))
	
			while !(SD1->(Eof())) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == xFilial("SD1") + cSeek
			
				// Recupera Mensagem PadRao no Produto.
				SB1->(dbSeek(xFilial("SB1") + SD1->D1_COD))
				
				addMessage(@self,SB1->B1_ZZMEN1)
						
				// Recupera Mensagem PadRao no TES(3 mensagens).
				SF4->(dbSeek(xFilial("SF4") + SD1->D1_TES))
				
				addMessage(@self,SF4->F4_ZZMEN1)		
				addMessage(@self,SF4->F4_ZZMEN2)		
				addMessage(@self,SF4->F4_ZZMEN3)
				
				SD1->(dbSkip())
			enddo
		else
			SC5->(dbSetOrder(1))
			SB1->(dbSetOrder(1))
			SF4->(dbSetOrder(1))
	
			dbSelectArea("SD2")
			SD2->(dbSetOrder(3))
			SD2->(dbSeek(xFilial("SD2") + cSeek))
	
			while !(SD2->(Eof())) .and. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == xFilial("SD2") + cSeek
			
				// Recupera Mensagem PadRao no Pedido de Venda.
				SC5->(dbSeek(xFilial("SC5") + SD2->D2_PEDIDO))
				
				addMessage(@self,SC5->C5_MENPAD)
		
				// Recupera Mensagem Padrao no Produto.
				SB1->(dbSeek(xFilial("SB1") + SD2->D2_COD))
				
				addMessage(@self,SB1->B1_ZZMEN1)
		
				// Recupera Mensagem Padrao no TES(3 mensagens).
				SF4->(dbSeek(xFilial("SF4") + SD2->D2_TES))
				
				addMessage(@self,SF4->F4_ZZMEN1)				
				addMessage(@self,SF4->F4_ZZMEN2)		
				addMessage(@self,SF4->F4_ZZMEN3)
				
				SD2->(dbSkip())
			enddo
		endif
	endif
	
	Lj7RestArea(aArea)

return


/**
* Adiciona mensagens
**/
static function addMessage(oSelf,cCodigo)

	local nPosition := 0
	
	nPosition := aScan(oSelf:aMsg,{|x| x[1] == cCodigo})
	
	if nPosition == 0 .and. !(Empty(cCodigo))
		aAdd(oSelf:aMsg,{cCodigo,formula(cCodigo)})
	endif

return


/*/{Protheus.doc} intDadosNF

Metodo de Interface dos dados adicionais e mensagens da NF
	
@author Winston Dellano de Castro
@since 07/01/2015
/*/
method intDadosNF(lGravado) class FswTemplMsg

	local aAlterEnch := {}                                   // Vetor com nome dos campos que poderao ser editados
	local aCpoEnch   := {}                                   // Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
	local aPos       := {068,012,160,328}                    // Vetor com coordenadas para criacao da enchoice no formato <top>, <left>, <bottom>, <right>
	local cAliasE    := iif(::getTpNF() == "E","SF1","SF2")  // Tabela cadastrada no Dicionario de Tabelas(SX2) que sera editada
	local caTela     := ""                                   // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
	local lColumn    := .F.                                  // Indica se a apresentacao dos campos sera em forma de coluna
	local lF3        := .F.                                  // Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
	local lMemoria   := .T.                                  // Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
	local lNoFolder  := .F.                                  // Indica se a enchoice nao ira utilizar as Pastas de Cadastro(SXA)
	local lProperty  := .T.                                  // Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
	local nModelo    := 3                                    // Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
	local nOpc       := GD_INSERT+GD_UPDATE+GD_DELETE
	local nOpcE      := 3                                    // Numero da linha do aRotina que definira o tipo de edicao(Inclusao, Alteracao, Exclucao, Visualizacao)
	local nRegE      := 0                                    // Numero do Registro a ser Editado/Visualizado(Em caso de Alteracao/Visualizacao)
	local aHoBrw1    := {}
	local aCoBrw1    := {}
	local nI         := 0
	local cNF        := ::getDoc() + "/" + ::getSerie()
	local cCli       := ::getClifor() + "/" + ::getLoja() + " - " + ::getName()
	local aTam       := {}
	local bOk        := {|| iif(::tudoOK(),(nOpcA := 1, aCoBrw1 := aClone(oBrw1:aCols), oDlg1:End()) , nil )} // {|| aCoBrw1 := aClone(oBrw1:aCols) ,oDlg1:End()}
	local bCancel    := {|| nOpcA := 0, oDlg1:End() } 
	local bTimer     := {|| nOpcA := 1, oDlg1:End() }
	local nOpcA      := 0
	
	private aTela    := Array(0,0)
	private aGets    := Array(0)
	
	default lGravado := .f.
	
	::carMsg(lGravado)
	
	// aHeader
	aTam := TamSX3(::getCpo("CODMENS",.F.))
	aAdd(aHoBrw1,{"Código"   ,::getCpo("CODMENS",.F.),"@!",aTam[1],aTam[2],"",USADO,"C","",""} )
	
	aTam := TamSX3(::getCpo("TXTMENS",.F.))
	aAdd(aHoBrw1,{"Descrição",::getCpo("TXTMENS",.F.),"@!",aTam[1],aTam[2],"",USADO,"C","",""} )
	
	// aCols
	if Len(::aMsg) == 0
		aAdd(aCoBrw1,{CriaVar(::getCpo("CODMENS",.F.)),CriaVar(::getCpo("TXTMENS",.F.)),.F.})
	else
		aEval(::aMsg,{|x| aAdd(aCoBrw1,{PadR(x[1],Len(::getCpo("CODMENS"))),PadR(x[2],Len(::getCpo("TXTMENS"))),.F.}) })
	endif
	
	SetPrvt("oFont1","oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oGrp2","oBrw1","oGrp3")
	
	oFont1 := TFont():new("MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,,)
	oDlg1  := MSDialog():new(105,276,615,952,"Dados Adicionais da NF",,,.F.,,,,,,.T.,,,.T.)
	
	oDlg1:bInit := {||EnchoiceBar(oDlg1,bOk,bCancel,.F.,{})}
	
	oGrp1 := TGroup():new(016,004,052,336,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1 := TSay():new(032,012,{||"Nota Fiscal"},oGrp1,,      ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay2 := TSay():new(040,012,{||"Cliente"    },oGrp1,,      ,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay3 := TSay():new(032,048,{||cNF          },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE ,CLR_WHITE,060,008)
	oSay4 := TSay():new(040,048,{||cCli         },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE ,CLR_WHITE,280,008)
	
	oGrp2 := TGroup():new(172,004,252,336,"Mensagens da NF",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F.)
	oBrw1 := MsNewGetDados():New(184,012,244,328,nOpc,"AllwaysTrue()","AllwaysTrue()","",,0,99,"AllwaysTrue()","","AllwaysTrue()",oGrp2,aHoBrw1,aCoBrw1)
	
	oGrp3 := TGroup():new(056,004,168,336,"Dados Adicionais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	RegToMemory(cAliasE,.T.)
	
	aEval(::aCampos,{|x| aAdd(aCpoEnch,x[1]), aAdd(aAlterEnch,x[1]), &("M->"+x[1]) := x[2] })
	
	aAdd(aCpoEnch,"NOUSER")
	
	Enchoice(cAliasE,nRegE,nOpcE,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPos,aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,oGrp3,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)
	
	if (FWUnitBusiness() == DHL_BUSINESSUNIT_AG2) .AND. (SF2->F2_ZZTPNF == RETORNO_SIMBOLICO)
		oDlg1:Activate(nil,nil,nil,.T.,nil, nil, bTimer)
	else
		oDlg1:Activate(,,,.T.)
	endif
	
	if nOpcA == 1
		// organiza mensagens
		
		::aMsg    := {}
		::aMsgDel := {}
		
		aEval(aCoBrw1,{|x| iif(!x[3],aAdd(::aMsg,{x[1],x[2]}),aAdd(::aMsgDel,{x[1],x[2]})) })
			
		// Grava as mensagens da nota fiscal
		::grvMsg()
		
		// Exclui as mensagens
		::delMsg()
	
		// grava dados adicionais da NF
		::grvDadosNF(1)
	endif

return


/*/{Protheus.doc} getName

Coleta o nome do cliente e do fornecedor da nota
	
@author Winston Dellano de Castro
@since 08/01/2015

@return String Nome do cliente ou do fornecedor
/*/
method getName() class FswTemplMsg

	local cName       := ""
	local lNFEntrada  := if(::getTpNF() == "E",.T.,.F.)
	local cTipoDoc    := ""
	local cNotaFiscal := ::getDoc()
	local cSerieNota  := ::getSerie()
	local cClientFor  := ::getCliFor()
	local cCliForLoja := ::getLoja()
	
	if lNFEntrada
	
		cTipoDoc := AllTrim(Posicione("SF1",1,xFilial("SF1") + cNotaFiscal + cSerieNota + cClientFor + cCliForLoja,"F1_TIPO"))
	
		if cTipoDoc $ "D/B"
			cName := AllTrim(Posicione("SA1",1,xFilial("SA1") + cClientFor + cCliForLoja,"A1_NOME"))
		else
			cName := AllTrim(Posicione("SA2",1,xFilial("SA2") + cClientFor + cCliForLoja,"A2_NOME"))
		endif
	else
		cName := AllTrim(Posicione("SA1",1,xFilial("SA1") + cClientFor + cCliForLoja,"A1_NOME"))
	endif
	
return cName


/*/{Protheus.doc} getCpo

Metodo de retorno de campo da tabela
	
@author Winston Dellano de Castro
@since 07/01/2015

@param cCampo, String, Campo a ser retornado
@param cCampo, Lógico, Indica se retorna o valor (.T.) ou o nome do campo 

@return TipoRet DescricaoRet
/*/
method getCpo(cCampo,lConteud) class FswTemplMsg

	local uRet     := nil
	local cAlias   := ::getAlias()
	local cPrefixo := ::getPrfAlias()
	
	default lConteud := .T.
	
	if lConteud
		uRet := &(cAlias + "->" + cPrefixo + "_" + cCampo)
	else
		uRet := cPrefixo + "_" + cCampo
	endif

return uRet


/*/{Protheus.doc} tudoOk
 
 Metodo de validacao na gravacao das mensagens da NF
 	
 @author Winston Dellano de Castro
 @since 07/01/2015
 /*/ 
method tudoOK() class FswTemplMsg

	local lRet := .T.
	
	if !(lRet)
		Aviso(FunDesc(),"",{"OK"})
	endif

return lRet
