#include "Protheus.ch"
#include "TopConn.ch"
#include "MsObject.ch"
#include "FileIO.ch"

#Define ADVPLFUN_CODE		"0000009EA1"

/**
* Classe		:	AdvplFun
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	12/10/10
* Descricao	:	Classe contendo Funcionalidades Genericas 
*/ 
User Function _AdvplFun; Return
Class AdvplFun                                                	

Method New()				// Construtor
Method ProcQuery()			// Processamento de Querys
Method ExistCpoBd()			// Verifica se determinado campo existe em dada Tabela no Banco de Dados
Method SaveAreas()			// Salva varias Areas
Method RestAreas()			// Restaura varias Areas
Method StrType()			// Converte qualquer tipo de dado para String
Method SetEmpFil()			// Seleciona Empresas e Filiais
Method RemoveAcentos()		// Remove acentos de Strings 
Method GetPosicoesObj() 	// Cria Arrays de Coordenadas de Objetos do Protheus
Method CriaArraysGd()		// Criacao dos Arrays para Objetos GetDados
Method NomeEmpresa()    	// Retorna o Nome de dada Empresa 
Method NomeFilial()     	// Retorna o Nome de dada Filial	
Method GetNomeSx2()			// Retorna o Nome das Tabelas no SX2  
Method VldEnchObrig() 		// Validacao de Campos Obrigatorios da Enchoice
Method StrData()        	// Converta Datas para String no formato DD/MM/AAAA 
Method ShowHelp()			// Exibe Dialogo de Help
Method StrToArray()			// Converte uma string para um array
Method ChkFormula()			// Validacao de Formulas Advpl
Method WriteTextFile()		// Gravacao de Arquivos Texto         
Method ReadCsvFile()		// Leitura de Arquivos CSV 
Method GetComboParambox()   // Coleta os Valores dos campo tipo ComboBox da funcao Parambox
Method GetEmpresas()		// Coleta Empresas e Filiais
Method IncTabRegs()			// Inclusao de Registros em tabelas com estruturas iguais
Method IncLinGd() 			// Inclusao de Novas Linhas em Objetos GetDados
Method GetErroAuto()    	// Coleta os Erros de Rotinas Automaticas
Method countRegs()			// Conta os registros em um Alias
Method getSqlDelete()		// Retorna Expressão SQL para deletar registros 
Method padRSx3()			// Coloca espaços a direita em uma String conforme o SX3
Method onlyNumbers()		// Verifica se uma String possui apenas Numeros
Method showArrayAuto()		// Exibe o conteudo de arrays de rotinas automaticas
Method isInJob()			// Verifica se a execução esta em Job ( sem interface de usuario )

End Class

/**
* Metodo		:	New
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Construtor
*/
Method New() Class AdvplFun

	If !( checkIPLicense() )
		Break
	Endif

Return

/**
* Metodo		:	ProcQuery
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Processamento de Instrucoes SQL
*
* Parametros	:	cQuery 	- 	String contendo a Instrucao SQL
*					nTipo 	- 	Tipo de Instrucao 
*									1 = Processa uma Consulta e retorna o Alias de Trabalho
*									2 = Processa uma Instrucao SQL e retorna o Resultado do Processamento (Logico)
*					cTabAtu	- 	Tabela a ser Atualizada no TOP ( Opcional )
*					lAviso	-	Indica se deve exibir Avisos em caso de erro no Processamento das Instrucoes ( Opcional )
*					cAlias 	- 	Alias a ser Atribuido em Consultas ( Opcional )
*					cErro 	- 	Variavel para atribuição de Erros ( Opcional )
*
* Retorno		:	xRet 	- 	String com o alias para Consultas ( nTipo == 1 )
*						   		Logico indicando o sucesso do Processamento ( nTipo == 2 )
*/
Method ProcQuery(cQuery, nTipo, cTabAtu, lAviso, cAlias, cErro) Class AdvplFun

	Local 	xRet	:= Nil	
	Default nTipo	:= 1	
	Default cTabAtu	:= ""            
	Default lAviso	:= .T.
	Default cAlias 	:= GetNextAlias()
	Default cErro	:= ""

	// Consultas	
	If nTipo == 1

		If !Empty(Select(cAlias))
			(cAlias)->(dbCloseArea())		
		EndIf                       		
		TCQUERY cQuery NEW ALIAS &cAlias				

		xRet := cAlias			

		// Manutencao		
	Else

		xRet := (TcSqlExec(cQuery) == 0)

		If xRet          
			If !Empty(cTabAtu)
				TcRefresh(RetSqlName(cTabAtu))		
			EndIf	
		Else                          
			cErro := TcSqlError()
			If lAviso                 
				Aviso(FunName(), cErro, {"Ok"}, 3, "Erro ao processar Instrução SQL") 		
			EndIf	
		EndIf			

	EndIf

Return xRet

/**
* Metodo		:	ExistCpoBd
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Verifica se determinado campo existe em dada Tabela no Banco de Dados
*
* Parametros	:	cCampo 	- 	Campo a ser analisado
*					cAlias 	- 	Alias da Tabela
*
* Retorno		:	lExist 	- 	Logico indicando a existencia do Campo
*/
Method ExistCpoBd(cCampo, cAlias) Class AdvplFun

	Local cQuery := ""	
	Local lExist := .F.	
	Local lDb2   := ("DB2" $ Upper(TcGetDb()))

	cQuery += " SELECT "
	If !lDb2
		cQuery += " TOP 1 "	
	EndIf                
	cQuery += cCampo+" FROM "+RetSqlName(cAlias)
	If lDb2
		cQuery += " FETCH FIRST 1 ROW ONLY "	
	EndIf

	lExist := ::ProcQuery(cQuery, 2, , .F.)

Return lExist

/**
* Metodo		:	SaveAreas
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Salva Areas de Trabalho
*
* Parametros	:	aAreas 	- 	Vetor contendo Strings dos Alias a serem Salvos
*
* Retorno		:	aRet 	- 	Vetor contendo Arrays com as Areas Salvas
*/
Method SaveAreas(aAreas) Class AdvplFun

	Local 	nI		:= 0
	Local 	aRet 	:= {}      
	Local 	cAlias	:= ""   
	Default aAreas	:= {}

	For nI := 1 To Len(aAreas)	
		cAlias := aAreas[nI]
		aAdd(aRet, (cAlias)->(GetArea()))	
	Next nI         

	aAdd(aRet, GetArea())

Return aRet                  

/**
* Metodo		:	RestAreas
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Restaura Areas de Trabalho
*
* Parametros	:	aAreas - Vetor contendo Arrays com as Areas Salvas
*/
Method RestAreas(aAreas) Class AdvplFun

	Local 	nI 		:= 0        
	Default aAreas  := {}

	For nI := 1 To Len(aAreas)	
		RestArea(aAreas[nI])
	Next nI

Return             

/**
* Metodo		:	StrType
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Converte qualquer tipo de dado para String
*
* Parametros	:	xValor - Valor a ser convertido
*
* Retorno		:	cRet - Valro convertido para String
*/
Method StrType(xValor) Class AdvplFun

	If ValType(xValor) == "C"
		cRet := xValor
	ElseIf ValType(xValor) == "N"
		cRet := Str(xValor)
	ElseIf ValType(xValor) == "D"
		cRet := DtoS(xValor)
	ElseIf ValType(xValor) == "L"
		cRet := If(xValor, ".T.", ".F.")
	Else
		cRet := ""	
	EndIf	

Return AllTrim(cRet)

/**
* Metodo		:	SetEmpFil
* Autor		:	Victor Hugo
* Data			: 	05/01/10
* Descricao	:	Seleciona Empresas e Filiais
*
* Parametros	:	cCodEmp 	- Codigo da Empresa
*					cCodFil 	- Codigo da Filial
*					lRpcSetEnv 	- Indica se utiliza o comando RpcSetEnv ( por padrao assume .T. )
*
* Retorno		:	Logico - Indica se a troca foi realizada
*/
Method SetEmpFil(cCodEmp, cCodFil, lRpcSetEnv) Class AdvplFun

	Local	lTroca		:= .T.
	Local 	nI			:= 0
	Local 	nMaxArea	:= 0
	Default cCodEmp		:= cEmpAnt
	Default cCodFil 	:= cFilAnt
	Default lRpcSetEnv  := .T.   		

	// Realiza a troca somente se a Empresa e Filial forem diferentes das atuais								
	If (lTroca := cCodEmp+cCodFil != cEmpAnt+cFilAnt)

		cEmpAnt := cCodEmp
		cFilAnt	:= cCodFil														

		If lRpcSetEnv					                    

			RpcClearEnv()
			RpcSetType(3)
			RpcSetEnv(cEmpAnt, cFilAnt)									

		Else

			dbCloseAll()			
			OpenSM0(cEmpAnt + cFilAnt)
			OpenFile(cEmpAnt + cFilAnt)			 

		EndIf	

	EndIf	

Return lTroca 

/**
* Metodo		:	RemoveAcentos
* Autor		:	Victor Hugo
* Data			: 	05/01/10
* Descricao	:	Remove Acentos de Strings
*
* Parametros	:	cString - String a ser tratada
*
* Retorno		:	cString - String sem os Acentos
*
* Observacoes	:	Este metodo e uma copia da funcao NoAcento do fonte 'NfeSefaz'
*/
Method RemoveAcentos(cString) Class AdvplFun

	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
	Local cTio   := "ãõ"
	Local cCecid := "çÇ"

	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("ao",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next
	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		If Asc(cChar) < 32 .Or. Asc(cChar) > 123 .Or. cChar $ '&'
			cString:=StrTran(cString,cChar,".")
		Endif
	Next nX
	cString := _NoTags(cString)
Return cString                                                                  

/**
* Metodo		:	GetPosicoesObj
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	22/09/10
* Descricao	:	Cria Arrays de Coordenadas de Objetos do Protheus
*/
Method GetPosicoesObj(aSize, aPosObj) Class AdvplFun

	Local aObjects 	:= {}
	Local aInfo		:= {}
	Default aSize	:= {}
	Default aPosObj	:= {}

	aAdd(aObjects, {100,100,.T.,.T.})
	aAdd(aObjects, {100,080,.T.,.T.})
	//aAdd(aObjects, {100,015,.T.,.F.})   

	aSize 	:= MsAdvSize()

	aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	aPosObj := MsObjSize(aInfo, aObjects, .T.)

Return                                                                 

/**
* Metodo		:	CriaArraysGd
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Criacao dos Arrays para Objetos GetDados
*
* Parametros	:	aHeader - Array contendo Dados dos Campos ( passar por referencia )
*					aCols   - Array que ira armazenar os Itens ( passar por referencia )
*					cAlias  - Alias contendo os Campos a serem exibidos no GetDados ( por padrao assume o Alias em foco )
*					aNaoAlt	- Vetor contendo os campos que nao deverao ser alterados ( por padrao assume vazio )
*					aCampos	- Vetor contendo os campos a serem exibidos ( por padrao exibe todos os campos em uso do Alias informado )
*
* Observacoes	:	O metodo ira criar os Arrays aHeader e aCols baseado nas informacoes do Dicionario de Dados (SX3), 
*					portanto os campos do Alias devem estar iguais ao do Dicionario
*/
Method CriaArraysGd(aHeader, aCols, cAlias, aNaoAlt, aCampos) Class AdvplFun

	Local cCpo			:= ""	
	Local xValor		:= ""
	Local cAltera		:= ""
	Local nUsado 		:= 0  
	Local nI			:= 0	
	Local aEstrut		:= {}
	Local aCposGd		:= {}
	Local aAreaGd		:= {}
	Local aArea			:= GetArea()
	Local aAreaSX3  	:= SX3->(GetArea())
	Private cAliasGd	:= ""
	Default cAlias		:= Alias()
	Default aHeader		:= {}
	Default aCols		:= {}	
	Default aNaoAlt		:= {}	
	Default aCampos		:= {}

	// Define o Alias do GetDados	
	cAliasGd := cAlias  
	aAreaGd  := (cAliasGd)->(GetArea())

	// Define os campos a serem exibidos	
	aEstrut := (cAliasGd)->(dbStruct())
	For nI := 1 To Len(aEstrut)
		cCpo := aEstrut[nI,1]
		If Len(aCampos) == 0
			aAdd(aCposGd, cCpo)		
		Else
			If aScan(aCampos, cCpo) > 0
				aAdd(aCposGd, cCpo)					
			EndIf		
		EndIf			
	Next nI		

	// Carrega o aHeader - Cabecalho
	If Len(aHeader) == 0
		For nI := 1 To Len(aCposGd)

			cCpo := PadR(aCposGd[nI], Len(GetSx3Cache(aCposGd[nI],"X3_CAMPO")))

			cAltera := If(aScan(aNaoAlt, AllTrim(cCpo)) == 0, ".T.", ".F.")		

			aAdd(aHeader, { AllTrim(GetSx3Cache(aCposGd[nI],"X3_TITULO")),;
			GetSx3Cache(aCposGd[nI],"X3_CAMPO"),;
			GetSx3Cache(aCposGd[nI],"X3_PICTURE"),;
			GetSx3Cache(aCposGd[nI],"X3_TAMANHO"),; 
			GetSx3Cache(aCposGd[nI],"X3_DECIMAL"),;
			cAltera,;
			GetSx3Cache(aCposGd[nI],"X3_USADO"),;
			GetSx3Cache(aCposGd[nI],"X3_TIPO"),;
			GetSx3Cache(aCposGd[nI],"X3_F3"),;
			GetSx3Cache(aCposGd[nI],"X3_CONTEXT"),; 
			GetSx3Cache(aCposGd[nI],"X3_CBOX"),; 
			GetSx3Cache(aCposGd[nI],"X3_RELACAO")})


			SX3->(dbSkip())

		Next nI
	EndIf

	// Carrega o aCols - Itens
	nUsado := Len(aHeader)

	(cAliasGd)->(dbGoTop())
	While !(cAliasGd)->(Eof())

		aAdd(aCols, Array(nUsado+1))
		For nI := 1 To nUsado                  
			xValor := "(cAliasGd)->"+aHeader[nI,2]	
			aCols[Len(aCols)][nI] := If(aHeader[nI,8] == "D", StoD(&(xValor)) , &(xValor))
		Next nI
		aCols[Len(aCols),nUsado+1] := .F.	

		(cAliasGd)->(dbSkip())
	EndDo

	RestArea(aAreaSx3)
	RestArea(aAreaGd)
	RestArea(aArea)

Return  

/**
* Metodo		:	NomeEmpresa
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	05/07/10
* Descricao	:	Retorna o Nome das Empresas
*/
Method NomeEmpresa(cCodEmp) Class AdvplFun

	Local cNome		:= ""	
	Local aAreaSm0	:= SM0->(GetArea())	
	Default cCodEmp := SM0->M0_CODIGO

	If SM0->(dbSeek(cCodEmp))
		cNome := Capital(AllTrim(SM0->M0_NOME))	
	EndIf

	RestArea(aAreaSm0)

Return cNome

/**
* Metodo		:	NomeFilial
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	05/07/10
* Descricao	:	Retorna o Nome das Filiais
*/
Method NomeFilial(cCodFil, cCodEmp) Class AdvplFun

	Local cNome		:= ""	
	Local aAreaSm0	:= SM0->(GetArea())
	Default cCodFil := SM0->M0_CODFIL	
	Default cCodEmp := SM0->M0_CODIGO

	If SM0->(dbSeek(cCodEmp+cCodFil))
		cNome := Capital(AllTrim(SM0->M0_FILIAL))	
	EndIf

	RestArea(aAreaSm0)

Return cNome  


/**
* Funcao		:	VldEnchObrig
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	02/12/10
* Descricao	:	Validacao dos Campos Obrigatorios da Enchoice
*
* Parametros	:	cAlias - Alias da Tabela 
*
* Observacoes	:	Funcao implementado devido ao problema com a instalação via ExporDic
*/
Method VldEnchObrig(cAlias) Class AdvplFun 

	Local nI 	 	:= 0
	Local lOk	 	:= .T.
	Local cCampo 	:= "" 
	Local cVar	 	:= ""
	Local cProblema := ""
	Local cSolucao  := ""
	Local aStru	 	:= (cAlias)->(dbStruct())

	For nI := 1 To Len(aStru)

		cCampo := aStru[nI,1]		
		cVar   := "M->"+cCampo

		If fTypeVar(cVar) .AND. X3Obrigat(cCampo) .AND. Empty(&cVar)
			lOk := .F.
			cProblema := "Campo Obrigatório não preenchido: "+AllTrim(RetTitle(cCampo))
			cSolucao  := "Verifique os campos Obrigatórios que não foram preenchidos"
			::ShowHelp("Campos Obrigatórios", cProblema, cSolucao)
			Exit	
		EndIf	

	Next nI

Return lOk   

/**
* Metodo		:	StrData
* Autor		:	Victor Hugo
* Data			:	26/04/2011
* Descricao	:	Converta Datas para String no formato DD/MM/AAAA
*/
Method StrData(dData) Class AdvplFun

	Local cDia  := StrZero(Day(dData), 2)	
	Local cMes  := StrZero(Month(dData), 2)
	Local cAno  := StrZero(Year(dData), 4)

Return cDia+"/"+cMes+"/"+cAno                       

/**
* Metodo		:	ShowHelp
* Autor		:	Victor Hugo
* Data			:	20/05/2011
* Descricao	:	Exibe Dialogo de Help      
*
* Parametros	:	cTitulo 	- Titulo do Dialogo
*					cProblema   - Descricao do Problema
*					cSolucao	- Descricao da Solucao
*/
Method ShowHelp(cTitulo, cProblema, cSolucao) Class AdvplFun

	Local aProblema		:= {}
	Local aSolucao		:= {}
	Local nMaxCol		:= 42

	Default cTitulo 	:= FunDesc()
	Default cProblema   := ""
	Default cSolucao	:= ""  

	aProblema := ::strToArray(cProblema, nMaxCol)
	aSolucao  := ::strToArray(cSolucao, nMaxCol)

	ShowHelpDlg(cTitulo, aProblema, Len(aProblema), aSolucao, Len(aSolucao))		

Return

/**
* Metodo		:	strToArray
* Autor		:	Victor Hugo
* Data			:	20/05/2011
* Descricao	:	Converte string em arrays de uma dimensão (vetor)
*
* Parametros	:	cString - String a ser convertida
*					nMaxCol - Número máximo de chrs por linha
*/                                                               
method strToArray(cString, nMaxCol) class AdvplFun

	local nLin	    := 0			
	local aVetor    := {}
	default nMaxCol := 20

	if Empty(cString)
		return {}
	endIf

	For nLin := 1 To MlCount(cString, nMaxCol)		                            
		aAdd(aVetor, MemoLine(cString, nMaxCol, nLin))			
	Next nI			

return aVetor  

/**
* Metodo		:	ChkFormula
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	27/05/11
* Descricao	:	Validacao de Formulas Advpl
*/
Method ChkFormula(cFormula) Class AdvplFun

	Local lOk			:= .T.			
	Local bErro 		:= ErrorBlock({ |oErro| oFun:ShowHelp("Fórmula Inválida", oErro:Description, "Verifique a sintaxe da Fórmula da digitada"), lOk := .F. })	
	Default cFormula	:= &(ReadVar())

	&(AllTrim(cFormula))	   

	ErrorBlock(bErro)

Return lOk

/**
* Metodo		:	WriteTextFile
* Autor		:	Victor Hugo
* Data			:	31/05/11
* Descricao	:	Gravacao de Arquivos Texto
*
* Parametros	:	cFile - Arquivo a ser Gravado
*					cText - Texto a ser Gravado 
*
* Retorno		:	Logico - Indica se o Log foi Gravado
*/                                                                 
Method WriteTextFile(cFile, cText) Class AdvplFun

	Local nHandle 	:= 0                        
	Local lWrite	:= .T.	                    

	If !File(cFile)
		nHandle := FCreate(cFile)
	Else
		nHandle := FOpen(cFile, FO_READWRITE)
		FSeek(nHandle, 0, 2)
	Endif

	If nHandle == -1
		lWrite := .F.
	Else
		cText += CRLF
		If FWrite(nHandle, cText, Len(cText)) != Len(cText)
			lWrite := .F.
		EndIf
	EndIf

	FClose(nHandle)

	If !lWrite
		Alert("Falha na gravação do Arquivo "+AllTrim(cFile))	
	EndIf

Return lWrite      

/**
* Metodo		:	ReadCsvFile
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	30/07/10
* Descricao	:	Leitura de Arquivos CSV
*
* Parametros	:	cArqCsv	- Arquivo a ser Lido
*
* Retorno		:	aArqCsv - Array com o conteudo do Arquivo
*/
Method ReadCsvFile(cArqCsv) Class AdvplFun

	Local cDelimTxt	:= ";"	
	Local lArqOk	:= .T.	
	Local aArqCsv 	:= {}
	Local nI        := 1   	

	Begin Sequence

		// Consiste o Arquivo Informado
		If !fArqCsvOk(self, cArqCsv)
			lArqOk := .F.
			Break
		EndIf

		// Abre o Arquivo
		If FT_FUse(cArqCsv) == -1
			lArqOk := .F.
			::ShowHelp("Arquivo Inválido", "Falha ao abrir o Arquivo "+AllTrim(cArqCsv), "Verifique o Arquivo informado") 	
			Break		
		EndIf

	End Sequence	

	// Armazena o Conteudo do Arquivo no Array de Retorno	
	If lArqOk	

		FT_FGoTop()
		While !FT_FEof()

			aCampos	:= {}
			cCpo	:= ""	   			
			cLinha 	:= FT_FReadLn()									
			nTamLin	:= Len(cLinha)+1
			For nI := 1 To nTamLin
				cChr := SubStr(cLinha, nI, 1)
				If cChr != cDelimTxt .AND. nI != nTamLin				
					cCpo += cChr
				Else
					aAdd(aCampos, cCpo)
					cCpo := ""	 		
				EndIf
			Next nI

			aAdd(aArqCsv, aCampos)

			FT_FSkip()
		Enddo

		// Fecha o Arquivo
		FT_FUse()

	EndIf	

Return aArqCsv                     

/**
* Funcao		:	fArqCsvOk
* Data			:	30/07/10
* Descricao	:	Validacao do Arquivo CSV Informado
*/	 
Static Function fArqCsvOk(oAdvplFun, cArqCsv)

	Local lOk 		:= .T.
	Local cProblema	:= ""
	Local cSolucao	:= ""
	Local cExtens	:= ""

	// Coleta a Extensao do Arquivo informado
	cExtens := StrTran(cArqCsv, FileNoExt(cArqCsv), "")

	// Sequencia para Validacao do Arquivo
	Begin Sequence	

		If Empty(cArqCsv)
			lOk := .F.
			Break		
		EndIf	

		If !File(cArqCsv)
			lOk 		:= .F.
			cProblema 	:= "Arquivo não encontrado"		
			cSolucao	:= "Informe um arquivo válido" 
		EndIf

		If Lower(cExtens) <> ".csv"
			lOk 		:= .F.
			cProblema	:= "O Arquivo deve possuir a extensão *.csv"							
			cSolucao    := "Informe um arquivo com extensão *.csv"
		EndIf

	End Sequence

	// Alerta o Usuario sobre alguma inconsistencia		
	If !lOk
		oAdvplFun:ShowHelp("Arquivo Inválido", cProblema, cSolucao)
	EndIf	

Return lOk   

/**
* Metodo		:	GetComboParambox
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	28/06/10
* Descricao	:	Trata as Perguntas do Tipo Combo da Funcao Parambox
*
* Parametros	:	xMvPar 		- Valor do Parametro na Parambox
*					aCombo		- Vetor contendo as Opcoes do Combo
*					nTipoRet    - Tipo de Retorno ( 1 = Indice do Combo, 2 = String do Combo )
*
* Retorno		:	xRet - Tipo de Retorno parametrizado
*
* Observacoes	:	Criado para contemplar o Bug dos ComboBox da Parambox
*/   
Method GetComboParambox(xMvPar, aCombo, nTipoRet) Class AdvplFun

	Local xRet			:= Nil	
	Default nTipoRet 	:= 1	

	If ValType(xMvPar) == "N" 
		If nTipoRet == 1
			xRet := xMvPar	
		Else
			xRet := aCombo[xMvPar]		
		EndIf		
	ElseIf ValType(xMvPar) == "C" 
		If nTipoRet == 1
			xRet := aScan(aCombo, xMvPar)
		Else
			xRet := xMvPar
		EndIf		
	EndIf

Return xRet 

/**
* Metodo		:	GetEmpresas
* Autor		:	Victor Hugo
* Data			: 	14/06/10
* Descricao	:	Coleta Empresas
*                  
* Parametros	:	cTitulo  - Titulo do Dialogo ( opcional )
*					lShowFil - Indica se deve exibir as Filiais ( por padrao assume .F. )
*
* Retorno		:	aRet[x,1] - Empresa
*					aRet[x,2] - Filial 
*					aRet[x,3] - Nome da Empresa
*/
Method GetEmpresas(cTitulo, lShowFil) Class AdvplFun

	Local oDlg     
	Local oList   	
	Local oOk  		:= LoadBitmap(GetResources(), "LBOK")
	Local oNo   	:= LoadBitmap(GetResources(), "LBNO")

	Local cEnvServ  := GetEnvServer() 
	Local cIniFile  := GetAdv97()    
	Local cStartPath:= GetPvProfString(cEnvServ, "StartPath", "", cIniFile)	  	  
	Local cSigaMat 	:= cStartPath+"sigamat.emp"		

	Local aEmps		:= {}
	Local aRet		:= {}          
	Local aAreaSM0	:= {}

	Local lOk 		:= .F.
	Local lFechaSm0	:= .F.
	Local nI        := 1                                   

	Default cTitulo := "Selecione as Empresas" 
	Default lShowFil:= .F.

	// Leitura das Empresas do SigaMat
	If Select("SM0") == 0
		lFechaSm0 := .T.
		OpenSM0()				
		dbSelectArea("SM0")
	Else
		aAreaSM0 := SM0->(GetArea())	
	EndIf	

	SM0->(dbGoTop())
	While !SM0->(Eof())
		If lShowFil
			If aScan(aEmps, {|x| x[2] == SM0->M0_CODIGO .AND. x[3] == SM0->M0_CODFIL }) == 0
				aAdd(aEmps, {.F.,SM0->M0_CODIGO,SM0->M0_CODFIL,AllTrim(SM0->M0_NOME)+" / "+AllTrim(SM0->M0_FILIAL)})
			EndIf					
		Else	
			If aScan(aEmps, {|x| x[2] == SM0->M0_CODIGO }) == 0
				aAdd(aEmps, {.F.,SM0->M0_CODIGO,SM0->M0_NOME,SM0->M0_CODFIL})
			EndIf			
		EndIf	
		SM0->(dbSkip())
	EndDo               

	If lFechaSm0
		SM0->(dbCloseArea())
	Else
		RestArea(aAreaSM0)	
	EndIf	

	// Criacao do Dialogo
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 32,113 TO 240,425 PIXEL OF oMainWnd

	If lShowFil		
		@ 5,5 LISTBOX oList FIELDS COLSIZES 20,35,50 HEADER "","Empresa","Filial","Nome" SIZE 148,70 OF oDlg PIXEL
	Else
		@ 5,5 LISTBOX oList FIELDS COLSIZES 20,35,50 HEADER "","Codigo","Empresa","" SIZE 148,70 OF oDlg PIXEL		
	EndIf	
	oList:SetArray(aEmps)
	oList:cToolTip		:= "Duplo Click para Habilitar/Desabilitar"
	oList:bLDblClick	:= { || fSelEmps(@oList, @aEmps) }
	If lShowFil 
		oList:bLine	:= { || { IIf(	aEmps[oList:nAt,1], oOk, oNo), aEmps[oList:nAt,2] , aEmps[oList:nAt,3], aEmps[oList:nAt,4] } }		
	Else
		oList:bLine	:= { || { IIf(	aEmps[oList:nAt,1], oOk, oNo), aEmps[oList:nAt,2] , aEmps[oList:nAt,3] } }
	EndIf	

	@ 85,6   BUTTON "Sel. Todas" 	SIZE 30,12 ACTION {|| fSelEmps(@oList, @aEmps, .T.) } 	PIXEL OF oDlg
	@ 85,79  BUTTON "Ok" 			SIZE 30,12 ACTION {|| lOk := .T., oDlg:End() } 			PIXEL OF oDlg
	@ 85,119 BUTTON "Cancelar" 		SIZE 30,12 ACTION {|| lOk := .F., oDlg:End() }			PIXEL OF oDlg 

	ACTIVATE MSDIALOG oDlg CENTERED

	// Define as Empresas para Instalacao
	If lOk	
		aRet := {}	
		For nI := 1 To Len(aEmps)
			If aEmps[nI,1]       
				If lShowFil
					aAdd(aRet, {aEmps[nI,2],aEmps[nI,3],aEmps[nI,4]})		
				Else
					aAdd(aRet, {aEmps[nI,2],aEmps[nI,4],aEmps[nI,3]})						
				EndIf	
			EndIf	
		Next nI					
		If Len(aRet) == 0	
			::ShowHelp(cTitulo, "Nenhuma Empresa Selecionada", "Selecione ao menos uma Empresa") 
		EndIf
	EndIf	

Return aRet  

/**
* Funcao		:	fSelEmps
* Autor		:	Victor Hugo
* Data			: 	14/06/10
* Descricao	:	Tratativa da Selecao de Empresas
*/
Static Function fSelEmps(oList, aEmps, lMarkAll)

	Local nI 		:= 0
	Local nMarks	:= 0
	Default lMarkAll:= .F.

	If !lMarkAll
		aEmps[oList:nAt,1] := !aEmps[oList:nAt,1]
	Else	
		For nI := 1 to Len(aEmps)
			If aEmps[nI,1]
				nMarks++			
			EndIf
		Next nI
		For nI := 1 to Len(aEmps)
			aEmps[nI,1] := (nMarks < Len(aEmps))
		Next nI
	EndIf	

	oList:Refresh()

Return

/**
* metodo	:	IncTabRegs
* autor	:	Victor Hugo
* data		:	07/11/11
* descricao:	Inclusao de Registros em tabelas com estruturas iguais
*/
Method IncTabRegs(cAliasDe,cAliasPara,lInclui) Class AdvplFun	

	Local xValDe		:= NIL
	Local nI			:= 0
	Local nCpoPara		:= 0
	Local aEstruDe		:= (cAliasDe)->( dbStruct() )
	Local aEstruPara	:= (cAliasPara)->( dbStruct() )

	(cAliasPara)->( RecLock(cAliasPara,lInclui) )		

	For nI := 1 to Len(aEstruDe)
		xValDe		:= NIL
		nCpoPara	:= aScan( aEstruPara, { |x| x[1] == aEstruDe[nI][1] } )							
		If nCpoPara > 0				
			xValDe := (cAliasDe)->( FieldGet(nI) )	
			(cAliasPara)->( FieldPut(nCpoPara,xValDe) )
		EndIf				
	Next nI				

	(cAliasPara)->( MsUnlock() )

Return  

/**
* Metodo		:	IncLinGd
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	30/07/10
* Descricao	:	Inclusao de Novas Linhas em Objetos GetDados
*
* Parametros	:	aCols 	- Variavel que armazena os Itens da GetDados
*					aHeader - Variavel que armazena o Cabecalho da GetDados
*/
Method IncLinGd(aCols, aHeader) Class AdvplFun

	Local nI 		:= 0
	Local cCampo	:= ""
	Local aAreaSx3  := SX3->(GetArea())

	aAdd(aCols, Array(Len(aHeader)+1))

	aCols[Len(aCols),Len(aHeader)+1] := .F.

	SX3->(dbSetOrder(2))

	For nI := 1 To Len(aHeader)

		cCampo := PadR(Upper(aHeader[nI,2]), Len(GetSx3Cache(Upper(aHeader[nI,2]),"X3_CAMPO")))

		If GetSx3Cache(Upper(aHeader[nI,2]),"X3_TIPO") <> "V"
			aCols[Len(aCols),nI] := CriaVar(cCampo)	 				
		EndIf

	Next nI

	RestArea(aAreaSx3)

Return 

/**
* Metodo       :   GetErroAuto
* Autor        :   Victor Hugo - Totvs Campinas
* Data         :   14/12/10
* Descricao    :   Coleta os Erros das Rotinas Automaticas
*/
Method GetErroAuto() Class AdvplFun

	Local cArqErro  := NomeAutoLog()
	Local cErroAuto := MemoRead(cArqErro)

	FErase(cArqErro) 

Return cErroAuto   

/**
* Conta os registros em um Alias
*
* @author Victor Hugo
* @since 16/07/2012
*/              
Method countRegs(cAlias) Class AdvplFun

	local nRegs 		:= 0
	local nRecno		:= (cAlias)->(Recno())
	local aArea 		:= GetArea()
	local aAreaAlias	:= (cAlias)->(GetArea())

	dbSelectArea(cAlias)
	count to nRegs

	RestArea(aAreaAlias)
	RestArea(aArea)

return nRegs   

/**
* Retorna Expressão SQL para apagar registros sem remover definitivamente
*
* @author Victor Hugo
* @since 16/07/2012
*/              
method getSqlDelete(cAlias, cWhere) Class AdvplFun

	local cSql 		 := ""
	local cCpoRecDel := "R_E_C_D_E_L_"
	local cCpoRecno  := "R_E_C_N_O_" 

	cAlias := RetSqlName(cAlias) 

	cSql := " UPDATE "+cAlias+" SET D_E_L_E_T_ = '*' "
	if ::existCpoBd(cCpoRecDel, cAlias)
		cSql += " , "+cCpoRecDel+" = "+cCpoRecno
	endIf
	cSql += " WHERE "+cWhere	

return cSql  

/**
* Coloca espaços a direita em uma String conforme o SX3
*
* @author Victor Hugo
* @since 02/08/2012
*/              
method padRSx3(cStr, cCampo) class AdvplFun				

	local aAreaSX3 	:= SX3->(GetArea())

	cStr := PadR(AllTrim(cStr), GetSx3Cache(cCampo,"X3_TAMANHO"))

	RestArea(aAreaSX3)

return cStr  

/**
* Verifica se uma String possui apenas Numeros
*
* @author Victor Hugo
* @since 02/08/2012
*/              
method onlyNumbers(cString) class AdvplFun	

	local lOnlyNumbers 	:= .T.
	local nI		   	:= 0
	local cChr			:= ""
	local cNumbers	   	:= "0123456789"

	cString := AllTrim(cString)

	for nI := 1 to Len(cString)
		cChr := SubStr(cString, nI, 1)
		if !(cChr $ cNumbers)
			lOnlyNumbers := .F.
			exit		
		endIf
	next nI

return lOnlyNumbers

/**
* Exibe o conteudo de arrays de rotinas automaticas
*
* @author Victor Hugo
* @since 03/12/2012
*/
method showArrayAuto(aArray) class AdvplFun

	local cStr 		:= ""
	local cCampo	:= ""
	local xValor	:= nil
	local nI        := 1

	for nI := 1 to Len(aArray)
		cCampo := AllTrim(aArray[nI,1])
		xValor := aArray[nI,2]
		cStr   += cCampo+" : "
		if (ValType(xValor) == "N")
			cStr += AllTrim(Str(xValor))
		elseIf (ValType(xValor) == "D")
			cStr += DtoC(xValor)
		else
			cStr += AllTrim(xValor)	
		endIf 
		cStr += CRLF		
	next nI

	Aviso("Array Rot. Automatica", cStr, {"Ok"}, 3, "Aviso") 

return	

/**
* Verifica se a execução esta em Job ( sem interface de usuario )
*/
method isInJob() class AdvplFun	                   

	local lInJob := (Type("oMainWnd") <> "O")

return lInJob

/*
Verifica o Licenciamento da TOTVS IP 
*/
Static Function checkIPLicense()
	Local oIPLicense 					:= Nil
	Local cCodeArtifact					:= ADVPLFUN_CODE
	Local cNameArtifact					:= Nil
	Local lOnlyTestCompany				:= Nil
	Local lNoCheckLicenseInTestCompany	:= Nil
	Local nLimitCheck					:= 100
	Local lBreakInFail					:= .F.   
	Local cMotivo						:= ""
	Local lRet							:= .F.

	If ExistBlock("IPLicense")
		oIPLicense 	:= IPLicense():newIPLicense()
		lRet 		:= oIPLicense:useLicense(cCodeArtifact,cNameArtifact,lOnlyTestCompany,lNoCheckLicenseInTestCompany,nLimitCheck,lBreakInFail,@cMotivo)		
	Else
		MsgStop("Objeto (IPLicense) de Licenciamento da TOTVS IP não encontrado.","TOTVS IP")
	Endif

Return lRet

/**
* Verifica o tipo da variável
**/
Static Function fTypeVar(cVar)
Return ( Type(cVar) <> "U")
