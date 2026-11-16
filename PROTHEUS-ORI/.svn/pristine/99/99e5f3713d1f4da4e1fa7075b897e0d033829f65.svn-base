/*Importar as bibliotecas*/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*Iniciando sua função*/
User Function CadTabSx5()
	Local lRet := .T.
	Local aArea := SX5->(GetArea())
	Local aRet := {}
	
	Local aParamBox 	:= {}
	Private cCadastro 	:= "Cadastro"
	
	Private oBrowse
	Private cChaveAux := ""

	aAdd( aParamBox ,{2,"Tabela",1, {"","21-Grupo de Tributação", "DJ-Tipo de Movimentação"}, 50,'.T.',.T.})
	
	while ParamBox(aParamBox,"Teste Parâmetros...",@aRet)
		if valType(aRet[1]) == "N"
			alert("Parâmetro não foi informado!")
		else
			if empty(aRet[1])
				alert("Parâmetro não foi informado!")
			else
				cTabela := left(aRet[1],2)
				exit
			endif
		endif
	EndDo

	if !empty(cTabela)
		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias("SX5")
		oBrowse:SetDescription("Grupo Tributário")
		oBrowse:SetFilterDefault( "X5_TABELA == '"+cTabela+"'" )
		oBrowse:Activate()
	endif
    RestArea(aArea)
Return

//-------------------------------------------------------------------
// Montar o menu Funcional
//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE "Pesquisar"  	ACTION 'PesqBrw' 		OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.CadTabSx5" OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	ACTION "VIEWDEF.CadTabSx5" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    	ACTION "VIEWDEF.CadTabSx5" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	ACTION "VIEWDEF.CadTabSx5" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Imprimir" 	ACTION "VIEWDEF.CadTabSx5" OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE "Copiar" 		ACTION "VIEWDEF.CadTabSx5" OPERATION 9 ACCESS 0
Return aRotina

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'SX5')
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('Formulario' , oStr1,'CamposSX5' )
	oStr1:RemoveField( 'X5_DESCENG' )
	oStr1:RemoveField( 'X5_DESCSPA' )
	oView:CreateHorizontalBox( 'PAI', 100)
	oView:SetOwnerView('Formulario','PAI')
	oView:EnableTitleView('Formulario' , 'Grupo Tributário' )	
	oView:SetViewProperty('Formulario' , 'SETCOLUMNSEPARATOR', {10})
	oView:SetCloseOnOk({||.T.})
	
Return oView

Static Function ModelDef()
	Local oModel
	Local oStr1:= FWFormStruct( 1, 'SX5', /*bAvalCampo*/,/*lViewUsado*/ ) // Construção de uma estrutura de dados
	
	oModel := MPFormModel():New('GrupoTributario', /*bPreValidacao*/, { | oModel | CadTabSx5V( oModel ) } , /*{ | oMdl | CadTabSx5C( oMdl ) }*/ ,, /*bCancel*/ )
	oModel:SetDescription('Grupo Tributário')
    oStr1:SetProperty('X5_TABELA' , MODEL_FIELD_INIT,{||cTabela} )
	oStr1:SetProperty('X5_TABELA' , MODEL_FIELD_WHEN,{|| .F. })
	oStr1:SetProperty("X5_CHAVE"  , MODEL_FIELD_WHEN,{|oModel| oModel:GetOperation()== 3 })
	oStr1:RemoveField( 'X5_DESCENG' )
	oStr1:RemoveField( 'X5_DESCSPA' )
	oStr1:RemoveField( 'X5_FILIAL' )
	
	oModel:addFields('CamposSX5',,oStr1,{|oModel|CadT(oModel)},,)
	oModel:SetPrimaryKey({'X5_FILIAL', 'X5_TABELA', 'X5_CHAVE' })
	oModel:getModel('CamposSX5'):SetDescription('TabelaSX5')
	
Return oModel

Static Function CadT( oModel )
	Local lRet      := .T.
	Local oModelSX5 := oModel:GetModel( 'CamposSX5' )
	
	cChaveAux := oModelSX5:GetValue('X5_CHAVE')

Return(lRet)

//-------------------------------------------------------------------
// Validações ao salvar registro
// Input: Model
// Retorno: Se erros foram gerados ou não
//-------------------------------------------------------------------
Static Function CadTabSx5V( oModel )
	Local lRet      := .T.
	Local oModelSX5 := oModel:GetModel( 'CamposSX5' )
	Local nOpc      := oModel:GetOperation()
	Local aArea     := GetArea()

    Local cChave	:= oModelSX5:GetValue('X5_CHAVE')
	Local cTabela	:= oModelSX5:GetValue('X5_TABELA')
	Local cDescri	:= oModelSX5:GetValue('X5_DESCRI')
	
	Begin Transaction
		
		if nOpc == 3 .or. nOpc == 4
			if Empty(cTabela)
				oModelSX5:SetValue('X5_TABELA',cTabela)
			Endif
			
			dbSelectArea("SX5")
			SX5->(dbSetOrder(1))
			SX5->(dbGoTop())
			If(SX5->(dbSeek(xFilial("SX5")+cTabela+cChave)))
				if cChaveAux != cChave
					SFCMsgErro("A chave "+Alltrim(cChave)+" ja foi informada!","CadTabSx5")
					lRet := .F.
				Endif
			Endif

			if Empty(cChave)
				SFCMsgErro("O campo chave é obrigatório!","CadTabSx5")
				lRet := .F.
			Endif
			
			if Empty(cDescri)
				SFCMsgErro("O campo descrição é obrigatório!","CadTabSx5")
				lRet := .F.
			Endif
			
		Endif
		
		if !lRet
			DisarmTransaction()
		Endif
		
	End Transaction
	
	RestArea(aArea)
	
	FwModelActive( oModel, .T. )
	
Return lRet