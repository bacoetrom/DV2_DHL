#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#include "TOTVS.CH"
#Include 'DHL.ch'
   
#Define CAMPOSITENS 'Z9_ITEM|Z9_COD|Z9_DESCRIC|Z9_QUANT|Z9_PRCVEN|Z9_TOTAL|Z9_CF|Z9_LOTE|Z9_DTVALID|Z9_DTFABR|Z9_ZZDEDOT|'

/*/{Protheus.doc} CADSZ8
		@author 	Cassandra J. Silva 
		@version 	1.0
		@since 		22/08/2016	
/*/
******************************************************************************************************************
User Function CADSZ8()
******************************************************************************************************************
	Local oBrowse := Nil
	Local cUnidade:= Alltrim(GetMv("ZZ_CNPJAG"))
	
	If Alltrim(SM0->M0_CGC) == cUnidade
		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias('SZ8')
		oBrowse:AddLegend( "Z8_TPNF == 'L'", "YELLOW", "Locação" )
		oBrowse:AddLegend( "Z8_TPNF == 'C'", "BLUE"  , "Comodato" )
		oBrowse:SetFilterDefault( "Z8_TPNF <> ' '")
		oBrowse:SetDescription('Histórico de Notas Fiscais Locação/Comodato')
		oBrowse:Activate() 
	Else
	   Aviso("CNPJ "+cUnidade,"Rotina específica da unidade HP AGE.",{"OK"})		
	Endif                                   
	
Return Nil

******************************************************************************************************************
Static Function MenuDef()
******************************************************************************************************************
	Local aRotina := {}
	Local aSubMnu := {}

	// Inicio Desenvolvimentop Mahle TOTVS IP Campinas 10/06/2021 - iVan de Oliveira
	If  FWUnitBusiness() == DHL_BUSINESSUNIT_AGL  

		ADD OPTION aRotina Title 'Visualizar' 	Action 'VIEWDEF.CADSZ8' OPERATION 2 ACCESS 0
		ADD OPTION aRotina Title 'Incluir' 		Action 'VIEWDEF.CADSZ8' OPERATION 3 ACCESS 0
		ADD OPTION aRotina Title 'Excluir' 		Action 'VIEWDEF.CADSZ8' OPERATION 5 ACCESS 0
		ADD OPTION aRotina Title 'Imprimir' 	Action 'VIEWDEF.CADSZ8' OPERATION 8 ACCESS 0

		//Adiciona o arrya do submenu a opção do menu
		ADD OPTION aRotina TITLE 'Alteração'    			ACTION aSubMnu         		OPERATION 9 ACCESS 0

		// adiciona opções no submenu
		ADD OPTION aSubMnu TITLE 'Número do Fornecimento'   ACTION 'u_TGetNumbFor()'  OPERATION 4 ACCESS 0 


	else

		ADD OPTION aRotina Title 'Visualizar' 	Action 'VIEWDEF.CADSZ8' OPERATION 2 ACCESS 0
		ADD OPTION aRotina Title 'Incluir' 		Action 'VIEWDEF.CADSZ8' OPERATION 3 ACCESS 0
		ADD OPTION aRotina Title 'Excluir' 		Action 'VIEWDEF.CADSZ8' OPERATION 5 ACCESS 0
		ADD OPTION aRotina Title 'Imprimir' 	Action 'VIEWDEF.CADSZ8' OPERATION 8 ACCESS 0

	Endif

	// Final Desenvolvimentop Mahle TOTVS IP Campinas 10/06/2021 - iVan de Oliveira
		

Return aRotina

******************************************************************************************************************
Static Function ModelDef()
******************************************************************************************************************
	Local oStruSZ8 	:= FWFormStruct( 1, 'SZ8' )
	Local oStruSZ9 	:= FWFormStruct( 1, 'SZ9' )
	Local oModel	:= Nil
	
	oModel:= MPFormModel():New( 'SZ8FORM', , , /*{|oModel| U_GeraPedido(2,{},oModel)}*/ )
	oModel:AddFields( 'SZ8MASTER', /*cOwner*/, oStruSZ8 )
	oModel:AddGrid( 'SZ9DETAIL', 'SZ8MASTER', oStruSZ9 )
	oModel:SetRelation( 'SZ9DETAIL', { {'Z9_FILIAL', 'xFilial("SZ9")'},{'Z9_DOC', 'Z8_DOC'},{'Z9_SERIE', 'Z8_SERIE'},{'Z9_CLIENTE', 'Z8_CLIENTE'},{'Z9_LOJA', 'Z8_LOJA'} }, SZ9->(IndexKey(1)) )
	oModel:SetDescription( 'XML Terceiro - Locação/Comodato' )
	oModel:GetModel( 'SZ8MASTER' ):SetDescription( 'Cabeçalho XML Terceiro' )
	oModel:GetModel( 'SZ9DETAIL' ):SetDescription( 'Item XML Terceiro' )
	oModel:SetPrimaryKey({})
	
Return oModel

******************************************************************************************************************
Static Function ViewDef()
******************************************************************************************************************
	Local oModel 	:= FWLoadModel( 'CADSZ8' )
	Local oStruSZ8 	:= FWFormStruct( 2, 'SZ8' )
	Local oStruSZ9 	:= FWFormStruct( 2, 'SZ9',   { | cCampo |  AllTrim( cCampo ) + '|' $ CAMPOSITENS })
	Local oView		:= Nil
	
	oView := FWFormView():New()
	oView:SetModel( oModel )
		
	oView:AddField( 'VIEW_SZ8', oStruSZ8, 'SZ8MASTER' )
	oView:AddGrid( 'VIEW_SZ9', oStruSZ9, 'SZ9DETAIL' )
	
	oView:AddIncrementField( 'VIEW_SZ9', 'Z9_ITEM' ) //--- Campo Incremental	           
	
	oView:CreateHorizontalBox( 'SUPERIOR', 45 )
	oView:CreateHorizontalBox( 'INFERIOR', 55 )
	oView:SetOwnerView( 'VIEW_SZ8', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_SZ9', 'INFERIOR' )
	
Return oView


******************************************************************************************************************
User Function TGetNumbFor()
******************************************************************************************************************

Local _aAreaAnt := { GetArea(), SZ8->(GetArea()) , SZ9->(GetArea()) }  
Local _cNumFor  := Space(TAMSX3("Z8_ZZDEDOT")[1])
Local _nTamFor  := TAMSX3("Z8_ZZDEDOT")[1]
Local _cNumSer  := SZ8->Z8_DOC + ' / ' + SZ8->Z8_SERIE    
lOCAL _cForAtu 	:= SZ8->Z8_ZZDEDOT  
Local _nOpc     := 0
local _cCliSA5  := SuperGetMv( "ZZ_SA5XML" , .F. , " " ,  )


// Verificando se o Emitente  possibilida esta alteração
if Alltrim(SZ8->Z8_CLIEMIT) + Alltrim(SZ8->Z8_LOJEMIT) $_cCliSA5

	oDlg := MSDialog():New( 030, 050, 400, 550, "Alteração Número do Fornecimento ", , , , , , , , oMainWnd, .T., , , , )  

		// Cria fonte para ser usada no TSay
		_oFont  := TFont():New('Courier new',,-16,.T.) 
		_oFont2 := TFont():New('Courier new',,-18,.T.) 

		// 1º Grupo
		oGroup1 := TGroup():New( 005, 005, 050, 250, 'Valores Atuais', oDlg,,,.T., )     
		oGroup2 := TGroup():New( 085, 045, 130, 205, 'Alteração', oDlg,,,.T., )    

		// Objetos SAY
		_oSay01	:= TSay():New( 020, 010, { || "Número/série " }			, oGroup1,,_oFont,,,,.T.,,, 150, 10 )  
		_oSay02 := TSay():New( 020, 130, { || "Número Fornecimento" }	, oGroup1,,_oFont,,,,.T.,,, 150, 10 )  
		_oSay03 := TSay():New( 100, 050, { || "Número Fornecimento" }	, oGroup2,,_oFont,,,,.T.,,, 150, 10 )  

		// Objetos GET
		_oNumSer := TGet():New( 030, 010, { |u| If( PCount() > 0, _cNumSer := u, _cNumSer ) }, /*oGroup1*/, 100, 010,,,,,_oFont2,,,.T.,,,{|| .F.},,,,,,,"_cNumSer" ) 
		_oForAtu := TGet():New( 030, 130, { |u| If( PCount() > 0, _cForAtu := u, _cForAtu ) }, /*oGroup1*/, 100, 010,,,,,_oFont2,,,.T.,,,{|| .F.},,,,,,,"_cForAtu" ) 
		_oBjNumF := TGet():New( 110, 050, { |u| If( PCount() > 0, _cNumFor := u, _cNumFor ) }, /*oGroup1*/, 150, 010,,{|| !Empty(_cNumFor) } ,,,_oFont2,,,.T.,,,{|| .T.},,,,,,,"_cNumFor" ) 

		// Botões
		_oBtnAprov:= tButton():New( 150, 080, 'Confirmar alteração', oDlg, { || if ( MsgYesno('Confirma') , (oDlg:End(), _nOpc := 1), .f.) }, 050,015,,,,.T.,,,, { || !Empty(_cNumFor) },,, )      
		_oBtnCanc := tButton():New( 150, 150, 'Sair', oDlg, { || oDlg:End(), _nOpc := 0 }, 050,015,,,,.T.,,,,,,, )  
		
	oDlg:Activate( ,,,.T.,,,,, )

	// Confirmado alteração
	if _nOpc == 1

		_cNumFor := Padr(Alltrim(_cNumFor), _nTamFor)
	 	if .T. // !SZ8->(dbSeek( FwxFilial("SZ8") + _cNumFor ))

			Begin Transaction
					
				// Alterando Conteúdo Cabeçalho
				_cForAnt := SZ8->Z8_ZZDEDOT	
				RecLock("SZ8",.F.)

					SZ8->Z8_ZZDEDOT	:= _cNumFor

				SZ8->(MsUnLock())

				// Alterando os itens
				// Z8_FILIAL+Z8_DOC+Z8_SERIE+Z8_CLIENTE+Z8_LOJA 
				dbSelectArea("SZ9")
				SZ9->(dbSetOrder(1))
				SZ9->(dbSeek( FwxFilial("SZ9") + SZ8->Z8_DOC + SZ8->Z8_SERIE + SZ8->Z8_CLIENTE +SZ8->Z8_LOJA ))
			 	
				 While SZ9->(!Eof()) .and. SZ9->Z9_FILIAL == xFilial("SZ9") .and.;
									SZ9->Z9_DOC == SZ8->Z8_DOC .and. SZ9->Z9_SERIE == SZ8->Z8_SERIE .AND.;
									SZ9->Z9_CLIENTE == SZ8->Z8_CLIENTE .AND. SZ9->Z9_LOJA  == SZ8->Z8_LOJA   
			 
				 
					
					if RecLock("SZ9",.F.)

						SZ9->Z9_ZZDEDOT	:= _cNumFor

					Else

						DisarmTransaction()
						Exit

					Endif
						
					SZ9->(dbSkip())

				Enddo

			End Transaction

		Else

			MsgStop ( 'Número do Fornecimento digitado: ' +  _cNumFor + ', já existe favor revisar !', 'Atenção' )

		Endif

	Endif

Else

	MsgStop ( 'Alteração só permitida para clientes contido no parâmetro: <ZZ_SA5XML>', 'Atenção' )

Endif

// Retorna aos ambientes
aEval(_aAreaAnt, {|x| RestArea(x) })

Return


