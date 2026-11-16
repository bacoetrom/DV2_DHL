#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'MSOBJECT.CH'
#INCLUDE 'FILEIO.CH'

#Define ENTER Chr(13) + Chr(10)

***************************************************************************************************************************************************
&& Criação da Classe ARQTXT pra manipulação de dados para arquivos texto
***************************************************************************************************************************************************
User Function _ArqTxt; Return

	***************************************************************************************************************************************************
	&& Definicao da classe
	&& Classe para abertura de um arquivo TXT.
	&& Retorna por linhas e faz a leitura de arquivo TXT com linhas de tamanhos variaveis.
	***************************************************************************************************************************************************
Class ArqTxt

	Data cFile		as Character
	Data nFOpened	as Numeric
	Data nTamLin	as Numeric
	Data nTamFile	as Numeric
	Data nLidos		as Numeric
	Data nModoAbr	as Numeric
	Data cLinLog	as Character
	Data aCabec		as Array		&& Array com os dados do cabecalho
	Data aDataMaxC	as Array		&& Array com a largura maxima de cada coluna
	Data aData		as Array		&& Array com os dados do arquivo
	Data aCritic	as Array		&& Array com os dados dos itens com problemas de validacao
	Data aValRules	as Array		&& Array com as informacoes de validacao dos campos
	Data lError		as Logical		&& Variavel de Erro, caso tenha acontecido
	Data cError		as Character	&& Mensagem de Erro, caso tenha acontecido
	Data nColunas	as Numeric		&& Numero de Colunas do arquivo
	Data nRecords	as Numeric		&& Numero de linhas do arquivo
	Data lStatus	as Logical		&& Variavel informando se o arquivo esta OK, sem falhas de validacao.
	Data lUpperConv	as Logical		&& Variavel informando se os dados importados devem ser transformados em UPPERCASE
	Data lRemocAcen	as Logical		&& Variavel informando se os dados importados devem ter os acentos removidos
	Data lHasCabec	as Logical		&& Variavel informando se existe cabecalho no arquivo
	Data lShowValid	as Logical		&& Variavel informando se as validacoes devem ser exibidas no arquivo
	Data lShwFieldS	as Logical		&& Variavel informando se as validacoes devem ser exibidas por campo ou por linha


	Method New( cFile , nFOpened , nTamLin , nTamFile , nLidos , nModoAbr, cLinLog )
	Method AbrirTxt()
	Method QtdLinha()
	Method mImport()	&& Importa o arquivo CSV e gravas as informacoes na propriedade aData e aCabec
	Method mStrTreat()	&& Faz o tratamento da String, removendo acentos e colocando em caixa alta.
	Method LinhaTxt()
	Method FechaTxt()
	Method CriarTxt()
	Method CriaLog()
	Method LeLinha()
	Method GravaLog( cTexto )
	Method VisuLog( cTexto )

EndClass

***************************************************************************************************************************************************
&& Metodo construtor.
***************************************************************************************************************************************************
Method New( cFile , nFOpened , nTamLin , nTamFile , nLidos , nModoAbr, cLinLog) Class ArqTxt

	Default cFile := ""
	Default nFOpened := 0
	Default nTamLin  := 10000
	Default nTamFile := 0
	Default nLidos   := 0
	Default nModoAbr := 64
	Default cLinLog	:= ""

	::cFile := cFile
	::nFOpened := nFOpened
	::nTamLin  := nTamLin
	::nTamFile := nTamFile
	::nLidos   := nLidos
	::nModoAbr := nModoAbr
	::cLinLog  := cLinLog
	::aCabec		:= {}
	::aDataMaxC		:= {}
	::aData			:= {}
	::aCritic		:= {}
	::aValRules		:= {}
	::lError		:= .F.
	::cError		:= ""
	::lStatus		:= .T.
	::nColunas		:= 0
	::nRecords		:= 0
	::lUpperConv	:= .T.
	::lRemocAcen	:= .T.
	::lHasCabec		:= .F.
	::lShowValid	:= .F.
	::lShwFieldS	:= .F.


	Return


	***************************************************************************************************************************************************
	&& Metodo para abertura do arquivo TXT..
	***************************************************************************************************************************************************
Method AbrirTxt() Class ArqTxt

	Local aArea  := GetArea()
	Local lRet   := .T.
	If File(::cFile)
		::nFOpened := FT_FUSE(::cFile)
		If ::nFOpened < 0
			Alert("Falha na abertura do arquivo TXT. Arquivo : "+ ::cFile)
			Conout("Falha na abertura do arquivo TXT. Arquivo : "+ ::cFile)
			lRet := .F.
		Else
			::nTamFile := FT_FLASTREC()
			FT_FGOTOP()
		Endif
	Else
		lRet := .F.
		Alert("Erro ao localizar o arquivo "+ ::cFile +"." )
		Conout("Erro ao localizar o arquivo "+ ::cFile +"." )
	EndIf
	RestArea(aArea)

	Return lRet

	***************************************************************************************************************************************************
	&& Metodo : mImport()
	&& Descric: Importa o arquivo CSV e gravas as informacoes na propriedade aData
	&& Param  : Nenhum
	&& Retorno: Retorna Verdadeiro caso a importacao tenha ocorrido sem problemas
	***************************************************************************************************************************************************
Method mImport() Class ArqTxt

	Local cRootPath		:= GetSrvProfString("StartPath","")
	Local cFileTmp		:= cRootPath + "TMPIMPORCSV.CSV"
	Local nHdl			:= -1
	Local cBuffer		:= ""
	Local nBuffer		:= 0
	Local nTotal		:= 0
	Local nX			:= 0
	Local cTmp			:= ""
	Local aTmp 			:= {}
	Local aTmpL			:= {}

	If File( ::cFile )
		_CopyFile(::cFile,cFileTmp)
		nHdl := FOpen( cFileTmp, 0 )
		If nHdl >= 0
			FSeek(nHdl,0,0)
			nTotal := FSeek(nHdl,0,2)
			nBuffer := Min(50*1024,nTotal)
			FSeek(nHdl,0,0)
		Endif
	Else
		::lError    := .T.
		::cError    := "Falha na abertura do arquivo: " + ::cFile
	Endif


	If !::lError

		nTotal := 0
		::nTamFile := FT_FLASTREC()

		While fReadLn(nHdl,@cBuffer,nBuffer) .and. !::lError

			If !Empty(AllTrim(cBuffer))

				cTmp := cBuffer
				aTmp := {}

				Do While at(";",cTmp) > 0
					nX := at(";",cTmp)
					If ( nX > 0 )
						aadd(aTmp, ::mStrTreat(Substr(cTmp,1,nX-1)) )
					Endif
					cTmp := Substr(cTmp, nX+1,Len(cTmp) )
				Enddo

				If Len(/*AllTrim*/(cTmp)) > 0		//	Fabricio M Vieira 08/09/2010. Funcao AllTrim fazia a leitura do arquivo CSV ser interrompida
					aadd(aTmp, ::mStrTreat(cTmp) )	//	quando a ultima coluna era composta SOMENTE de espacos em branco. Ex.: A1_COMPLEM.
				Endif

				If Len(aTmp) < ::nColunas
					For nX := Len(aTmp) to ::nColunas
						aadd(aTmp, "" )
					Next nX
				Endif

				If ::lHasCabec .and. nTotal == 0

					&& Carrega o nome das colunas
					::aCabec 	:= aTmp

					&& Carrega o numero de colunas do arquivo, para validacao de integridade
					::nColunas	:= Len(aTmp)

					&& Ajusta a propriedade de largura maxima das colunas para os casos em que existem colunas de cabecalho
					For nX := 1 to ::nColunas
						Aadd(::aDataMaxC, Len(aTmp[nX]) )
					Next nX

				Else
					&& Carrega o numero de colunas do arquivo, para validacao de integridade
					If ::nColunas == 0
						::nColunas := Len(aTmp)
					Endif

					&& Ajusta a propriedade de largura maxima das colunas para os casos em que existem colunas de cabecalho
					If Len(::aDataMaxC) == 0
						For nX := 1 to ::nColunas
							Aadd(::aDataMaxC, Len(aTmp[nX]) )
						Next nX
					Endif

					&& Carrega o array de dados
					Aadd(::aData, aClone(aTmp) )

					&& Ajusta a propriedade de largura maxima das colunas
					For nX := 1 to Len(aTmp)
						If nX <= Len(::aDataMaxC)
							::aDataMaxC[nX] := Iif( ::aDataMaxC[nX] < Len(aTmp[nX]), Len(aTmp[nX]) ,::aDataMaxC[nX] )
						Endif
						aTmp[nX] := .T.
					Next nX

					&& Carrega o status padrao de critica dos itens importados
					aTmpL := aClone(aTmp)
					aadd(aTmpL,.T.)
					Aadd(::aCritic, aClone(aTmpL) )

				Endif

				If Len(aTmp) > ::nColunas
					::lError    := .T.
					::cError    := "Inconsistencia na estrutura do arquivo na linha: " + AllTrim(Str(nTotal))
				Endif

				nTotal ++

			Endif

		Enddo

		FClose( nHdl )

		If Len(::aData) == 0 .and. !::lError

			::lError    := .T.
			::cError    := "Não foram encontrados dados no arquivo: " + ::cFile

		Elseif !::lError

			::lStatus	:= .T.
			For nX := 1 to ::nColunas
				aadd(::aValRules, {"CMD",".T.",""} )
			Next nX

		Endif

	Endif

	Return(!::lError)


	***************************************************************************************************************************************************
	&& Metodo : mStrTreat()
	&& Descric: Faz o tratamento da String, removendo acentos e colocando em caixa alta.
	&& Param  : String a ser tratada
	&& Retorno: String ja tratada
	***************************************************************************************************************************************************
Method mStrTreat(cString) Class ARQTXT

	Local cAcentos	:= "ÁÀÂÃáàâãÉÈÊéèêÍÌÎíìîÓÒÔÕóòôõÚÙÛÜúùûüÇç"
	Local cAcSubst	:= "AAAAaaaaEEEeeeIIIiiiOOOOooooUUUUuuuuCc"
	Local cTmp		:= ""
	Local cTexto	:= ""
	Local nI	   	:= 0
	Local nAt		:= 0

	cString := AllTrim(cString)

	If ::lRemocAcen

		For nI := 1 To Len(cString)
			cTmp := SubStr( cString , nI , 1 )
			If ( nAt := At( cTmp , cAcentos ) ) > 0
				cTmp := SubStr( cAcSubst , nAt , 1 )
			Endif
			cTexto += cTmp
		Next nI

		cString := StrTran(AllTrim(cTexto),"$","")

	Endif

	If ::lUpperConv
		cString := Upper(cString)
	Endif

	Return(cString)


	***************************************************************************************************************************************************
	&& Metodo para retornar uma linha do TXT.
	&& Retorno: cRet = Linha do TXT.
	***************************************************************************************************************************************************
Method LeLinha() Class ArqTxt
	Local aRet		:= {}
	Local cBuffer 	:= ""
	Local cLinhaTmp := ""
	Local cLinhaM100 := ""

	cLinhaTmp := FT_FReadLN()

	If !Empty(cLinhaTmp)
		cIdent:= Substr(cLinhaTmp,1,1)
		If Len(cLinhaTmp) < 1023
			cLinhaM100 := cLinhaTmp
		Else
			cLinAnt := cLinhaTmp
			cLinhaM100 += cLinAnt
			Ft_FSkip()
			cLinProx:= Ft_FReadLN()
			If Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent
				While Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent .and. !Ft_fEof()
					cLinhaM100 += cLinProx
					Ft_FSkip()
					cLinProx := Ft_fReadLn()
					If Len(cLinProx) < 1023 .and. Substr(cLinProx,1,1) <> cIdent
						cLinhaM100 += cLinProx
					Endif
				Enddo
			Else
				cLinhaM100 += cLinProx
			Endif
		Endif
	Endif

	Return cLinhaM100

	***************************************************************************************************************************************************
	&& Metodo para fechar o arquivo TXT.
	&& Retorno: lRet = .T. Se conseguiu abrir , .F. se ocorreram erros.
	***************************************************************************************************************************************************
Method FechaTxt() Class ArqTxt

	Local aArea := GetArea()
	Local lRet  := .T.

	If FT_FUSE()
		Alert("Falha no fechamento do arquivo TXT. Arquivo : "+ ::cFile)
		Conout("Falha no fechamento do arquivo TXT. Arquivo : "+ ::cFile)
		lRet := .F.
	Endif

	RestArea(aArea)

	Return lRet

	***************************************************************************************************************************************************
	&& Metodo para criação do arquivo TXT.
	&& Retorno: lRet = .T. Se conseguiu abrir , .F. se ocorreram erros.
	***************************************************************************************************************************************************
Method CriarTxt() Class ArqTxt

	Local aArea := GetArea()
	Local lRet := .T.

	::nFOpened := FCreate(::cFile)
	If ::nFOpened < 0
		Alert("Falha na criação do arquivo TXT. Arquivo : "+ ::cFile)
		Conout("Falha na criação do arquivo TXT. Arquivo : "+ ::cFile)
		lRet := .F.
	Endif

	RestArea(aArea)

	Return lRet

	***************************************************************************************************************************************************
	&& Metodo para criação do arquivo de Log.
	&& Retorno: lRet = .T. Se conseguiu abrir , .F. se ocorreram erros.
	***************************************************************************************************************************************************
Method CriaLog(cTexto) Class ArqTxt

	Local aArea := GetARea()
	Local lRet  := .T.

	::cFile := cTexto

	If File(::cFile)
		If !(::AbrirTxt())
			lRet := .F.
		Endif
	Else
		If !(::CriarTxt())
			lRet := .F.
		Endif
	Endif
	FSeek(::nFOpened , 0 , 2)

	RestArea(aArea)

	Return lRet

	***************************************************************************************************************************************************
	&& Metodo para escrita no arquivo de Log.
	&& Retorno: lRet = .T. Se conseguiu abrir , .F. se ocorreram erros.
	***************************************************************************************************************************************************
Method GravaLog( cTexto ) Class ArqTxt

	Local aArea := GetArea()
	Local lRet  := .T.
	Local nRet  := 0

	FSeek(::nFOpened , 0 , 2)
	nRet:= FWrite(::nFOpened , cTexto, len(cTexto) )

	If nRet < 0
		lRet := .F.
	EndIf

	::cLinLog += cTexto

	RestArea(aArea)

	Return lRet

	***************************************************************************************************************************************************
	&& Metodo para escrita no arquivo de Log.
	&& Retorno: lRet = .T. Se conseguiu abrir , .F. se ocorreram erros.
	***************************************************************************************************************************************************
Method VisuLog() Class ArqTxt

	Local aArea := GetArea()
	Local oEdit

	DEFINE DIALOG oDlg TITLE "Visualização Log" FROM 332,318 TO 700,830 PIXEL

	oEdit := TSimpleEditor():New( 0,0,oDlg,260,184 )

	oEdit:Load( ::cLinLog )

	ACTIVATE DIALOG oDlg CENTERED
	Return .t.

	RestArea(aArea)

	Return lRet

