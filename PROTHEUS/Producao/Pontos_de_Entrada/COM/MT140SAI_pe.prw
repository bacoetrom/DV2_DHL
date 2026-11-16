#include "totvs.ch"
#include "dhl.ch"


/*/{Protheus.doc} MT140SAI

Ponto de Entrada localizado ap�s a grava��o da pr� nota.

@author Elmo F Teixeira
@since 21/07/2023
/*/

USER FUNCTION MT140SAI()

	Local nOrdem := SF1->( IndexOrd() )
	Local cQry := ""
	Local cID	:= ""
	Local aRet := {}
    Local lContinua := .t.


//PARAMIXB[1] = Numero da operação - ( 2-Visualização, 3-Inclusão, 4-Alteração, 5-Exclusão )
//PARAMIXB[2] = Número da nota
//PARAMIXB[3] = Série da nota
//PARAMIXB[4] = Fornecedor
//PARAMIXB[5] = Loja
//PARAMIXB[6] = Tipo
//PARAMIXB[7] = Opção de Confirmação (1 = Confirma pré-nota; 0 = Não Confirma pré-nota)

If (ParamIxb[1] == 3 .OR. ParamIxb[1] == 4 ) .and. ParamIxb[7] <> 0
    lContinua := .t.
Else
    lContinua := .f.
Endif    

If lContinua
	SF1->( dbSetOrder( 1 ) )
	SF1->( MsSeek( xFilial( 'SF1' ) + ParamIxb[2] + ParamIxb[3] + ParamIxb[4] + ParamIxb[5] ) )

	if sf1->F1_FORMUL=='S' .and. SF1->F1_SERIE # DHL_SERIE_INVENTARIO .and. FWUnitBusiness() == DHL_BUSINESSUNIT_AGL 
		//Mensagens Complementares
		u_PNInfCompl()
	Endif
Endif

if lContinua .and. FWUnitBusiness() == DHL_BUSINESSUNIT_AGL //.and. alltrim(cFilAnt) == "024AGL002400"
	SF1->( dbSetOrder( 1 ) )
	SF1->( MsSeek( xFilial( 'SF1' ) + ParamIxb[2] + ParamIxb[3] + ParamIxb[4] + ParamIxb[5] ) )

	if SF1->F1_TIPO $ "B|D|"
		cASN := AllTrim(Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE,"A1_ZZEVASN"))
	else
		cASN := AllTrim(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE,"A2_ZZEVASN"))
	endif
	If cASN $ "1N"
		lContinua := .t.
	Else
		lContinua := .f.
	Endif
Else
    lContinua := .f.
Endif

If !lContinua 
    Return( NIL )
Endif


RecLock("SF1", .F.)
if SF1->(FieldPos("F1_ZZSTATU")) > 0
	SF1->F1_ZZSTATU := DHL_DOC_LIMPAR_STATUS
Endif
SF1->F1_STATUS := " "
SF1->(MsUnLock())

SF1->( dbSetOrder( nOrdem ) )

Return( NIL )




/*/{Protheus.doc} PNInfCompl()

Rotina para, no final da geracao da Pre-nota de Entrada, para gravacao de dados adicionais.

@author Thiago Meschiatti
@since 30/10/2014

/*/
User Function PNInfCompl()
	
	local oTMsg  := FswTemplMsg():newTemplMsg("E",SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,"SZZ")
	local oDevRev:= nil
	
	// inicio template mensagens da NF
	//If SF1->F1_FORMUL == "S"
		aAdd(oTMsg:aCampos,{"F1_VOLUME1",CriaVar("F1_VOLUME1")})
		aAdd(oTMsg:aCampos,{"F1_ESPECI1",CriaVar("F1_ESPECI1")})
		aAdd(oTMsg:aCampos,{"F1_PESOL"  ,CriaVar("F1_PESOL"  )})
		aAdd(oTMsg:aCampos,{"F1_PBRUTO",CriaVar("F1_PBRUTO")})
		aAdd(oTMsg:aCampos,{"F1_TRANSP",CriaVar("F1_TRANSP")})
		aAdd(oTMsg:aCampos,{"F1_PLACA",CriaVar("F1_PLACA")})
		aAdd(oTMsg:aCampos,{"F1_ZZMARCA",CriaVar("F1_ZZMARCA")})
		
		//if !isBlind()
			oTMsg:Processa()
		//endIf


	//Endif
	// fim template mensagens da NF
	
Return



