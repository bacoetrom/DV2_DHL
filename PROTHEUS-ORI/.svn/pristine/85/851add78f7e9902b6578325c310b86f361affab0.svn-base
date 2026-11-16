#include "protheus.ch"
#include "fileio.ch"
#include "rwmake.ch"

#define CHECK_FILE_MSG	"Verifique se o arquivo existe ou se está sendo usado."		
 
/*/{Protheus.doc} IpFileObject
 
Objeto para manipulação de Arquivos

@type class	
@author Victor Hugo
@since 11/11/2013
/*/
class IpFileObject from IpAdvplObject
	
	data cFile as string	
	data lOpen as boolean
	data aLines as array
	
	method newIpFileObject() constructor
	
	method getFile()
	method setFile()
	method isOpen()
	method getLines()
	
	method createFile()		
	method writeLine()
	method readLine()
	method saveLines()	
	method isEof()
	method notIsEof()
	method skipLine()
	method goTop()
	method open()
	method close()
	method delete()
	method copy()
	method countLines()
	method getFileName()
	method exists()
	
endClass


/*/{Protheus.doc} newIpFileObject

Construtor

@type method
@author Victor Hugo
@since 11/11/2013

@param cFile, String, Arquivo texto a ser manipulado
/*/
method newIpFileObject(cFile) class IpFileObject
	
	default cFile := ""
	
	::newIpAdvplObject()
	
	::setFile(cFile)
	::lOpen := .F.	
	::aLines:= {}
	
return	


/*/{Protheus.doc} getFile

Coleta o arquivo definido

@type method
@author Victor Hugo
@since 11/11/2013

@return String Arquivo definido
/*/
method getFile() class IpFileObject
return ::cFile


/*/{Protheus.doc} setFile

Define o arquivo do objeto

@type method
@author Victor Hugo
@since 11/11/2013

@param cFile, String, Arquivo definido para o objeto
/*/
method setFile(cFile) class IpFileObject
	::cFile := AllTrim(cFile)
return


/*/{Protheus.doc} isOpen

Indica se o arquivo está aberto

@type method
@author Victor Hugo
@since 11/11/2013

@return Logico Arquivo aberto
/*/
method isOpen() class IpFileObject
return ::lOpen


/*/{Protheus.doc} getLines

Coleta todas as linhas do arquivo

@type method
@author Victor Hugo
@since 11/11/2013

@return Array Linhas do arquivo
/*/
method getLines() class IpFileObject
return ::aLines


/*/{Protheus.doc} createFile

Cria o Arquivo

@type method	
@author Victor Hugo
@since 31/10/2014

@return Logico Indica se o arquivo foi criado
/*/
method createFile() class IpFileObject
	
	local lOk 			:= .F.
	local cFile			:= ::getFile()
	local nHandle		:= -1
	
	if !File(cFile)
		nHandle := createFile(cFile)
	endIf	
	
return (nHandle != -1)

/**
 * Cria o arquivo sem alterar o nome
 */
static function createFile(cFile)
	
	local lChangeCase := .F.
	
return FCreate(cFile, nil, nil, lChangeCase)


/*/{Protheus.doc} writeLine

Gravação de linhas no arquivo

@type method
@author Victor Hugo
@since 11/11/2013

@param cText, String, Texto a ser gravado

@return Logico Indica se o texto foi gravado com sucesso
/*/
method writeLine(cText) class IpFileObject
	
	local nHandle 	:= 0                        
	local lWrite	:= .T.
	local cFile		:= ::getFile()	                    
	
	if !File(cFile)
		nHandle := createFile(cFile)
	else
		nHandle := FOpen(cFile, FO_READWRITE)
		FSeek(nHandle, 0, 2)
	Endif
	
	if (nHandle == -1)
		lWrite := .F.
	else
		cText += CRLF
		if FWrite(nHandle, cText, Len(cText)) != Len(cText)
			lWrite := .F.
		endIf
	endIf
			
	FClose(nHandle)
	
	if !lWrite
		MsgBox("Falha na gravação do arquivo "+cFile, "Erro", "STOP")
	endIf
	
return lWrite


/*/{Protheus.doc} readLine

Leitura de linhas do arquivo. 
Esse método trabalha como a função SubString(), possibilitando a leitura da linha toda ou de apenas uma parte.

@type method
@author Victor Hugo
@since 11/11/2013

@param nCol, Numerico, Coluna inicial a ser considerada (opcional)
@param nChrs, Numerico, Quantidade de caracteres a serem considerados (opcional)

@return String Conteúdo da linha posicionada
/*/
method readLine(nCol, nChrs) class IpFileObject
	
	local cLine  := ""	
	default nCol := 0
	default nChrs:= 0
	
	if !::open()
		return ""
	endIf
	
	cLine := FT_FreadLn()
	
	if (nCol > 0)
		if (nChrs == 0)
			nChrs := Len(cLine)
		endIf
		cLine := SubStr(cLine, nCol, nChrs)		
	endIf	
	
return cLine


/*/{Protheus.doc} saveLines

Salva todas as linhas do arquivo em um array. 
Para coletar as linhas utilize o método getLines().

@type method
@author Victor Hugo
@since 11/11/2013
/*/
method saveLines() class IpFileObject
	
	::aLines := {}
	
	if ::open()
		::goTop()
		while !::isEof()
			aAdd(::aLines, ::readLine())	
			::skipLine()
		endDo
		::goTop()
	endIf	
	
return
	

/*/{Protheus.doc} isEof

Indica se está no final do arquivo

@type method
@author Victor Hugo
@since 11/11/2013

@return Logico Final do arquivo 
/*/
method isEof() class IpFileObject
	
	local lEof := .F.
	
	if ::isOpen() 
		lEof := FT_Feof()
	endIf
	
return lEof


/*/{Protheus.doc} notIsEof

Indica se NÃO está no final do arquivo

@type method
@author Victor Hugo
@since 11/11/2013

@return Logico Indica se NÃO está no final do arquivo 
/*/
method notIsEof() class IpFileObject		
return !::isEof()


/*/{Protheus.doc} skipLine

Avança uma linha

@type method
@author Victor Hugo
@since 11/11/2013

@return Logico Indica se foi possível avançar uma linha 
/*/
method skipLine() class IpFileObject
	
	if !::open()
		return .F.
	endIf
	
	FT_Fskip()
	
return .T.


/*/{Protheus.doc} goTop

Posiciona na primeira linha do arquivo

@type method
@author Victor Hugo
@since 11/11/2013

@return Logico Indica se foi possível posicionar na primeira linha do arquivo 
/*/
method goTop() class IpFileObject		
	
	if !::open()
		return .F.
	endIf
	
	FT_FgoTop()
			
return .T.


/*/{Protheus.doc} open

Abre o arquivo

@type method
@author Victor Hugo
@since 11/11/2013

@return Logico Indica se foi possível abrir o arquivo 
/*/
method open() class IpFileObject
	
	local cFile := ::getFile()
	
	if !::isOpen()
		if (FT_Fuse(cFile) == -1)
			MsgBox("Não foi possível abrir o arquivo "+cFile+"."+CRLF+CHECK_FILE_MSG, "Erro", "STOP")			
		else
			::lOpen := .T.
			::goTop()			
		endIf
	endIf
	
return ::isOpen()


/*/{Protheus.doc} close

Fecha o arquivo

@type method
@author Victor Hugo
@since 11/11/2013

@return Logico Indica se foi possível fechar o arquivo 
/*/
method close() class IpFileObject
	
	if ::isOpen()
		FT_Fuse()
		::lOpen := .F.
	endIf
	
return


/*/{Protheus.doc} delete

Apaga o arquivo

@type method
@author Victor Hugo
@since 11/11/2013

@return Logico Indica se o arquivo foi apagado fisicamente 
/*/
method delete() class IpFileObject
	
	local lOk	:= .T.
	local cFile := ::getFile()	
	
	if (FErase(cFile) == -1)
		lOk := .F.		
	endIf
	
return lOk


/*/{Protheus.doc} copy

Realiza a copia o arquivo

@type method
@author Victor Hugo
@since 11/11/2013

@param cNewFile, String, Novo arquivo a ser gerado

@return Logico Indica se a cópia foi bem sucedida 
/*/
method copy(cNewFile) class IpFileObject
	
	local nI  := 0
	local lOk := .F.
	
	if !::exists()
		return .F.
	endIf
	
	__CopyFile(::getFile(), cNewFile)

	for nI := 1 to 5
		if File(cNewFile)		
			lOk := .T.
			exit
		endIf
		Sleep(3000)
	next nI

return lOk


/*/{Protheus.doc} countLines

Retorna a quantidade total de linhas do arquivo

@type method
@author Victor Hugo
@since 11/11/2013

@return Numerico Quantidade de linhas do arquivo 
/*/
method countLines() class IpFileObject
	
	local nLines := 0
	
	if ::open()
		::goTop()
		while !::isEof()
			nLines++
			::skipLine()
		endDo
		::goTop()
	endIf
		
return nLines


/*/{Protheus.doc} getFileName

Retorna o nome do arquivo sem o diretório

@type method
@author Victor Hugo
@since 11/11/2013

@param lExtens, Logico, Indica se considera a extensão do arquivo

@return String Nome do arquivos
/*/
method getFileName(lExtens) class IpFileObject
	
	local nI		:= 0
	local cChr  	:= ""
	local cAux  	:= ""
	local cName 	:= ""
	local cBar  	:= if(IsSrvUnix(), "/", "\")
	local cFile 	:= AllTrim(Lower(::getFile()))
	default lExtens := .T.
	
	for nI := Len(cFile) to 1 step -1
		cChr := SubStr(cFile, nI, 1)
		if (cChr != cBar)
			cAux += cChr
		else
			exit
		endIf
	next nI
	
	for nI := Len(cAux) to 1 step -1
		cName += SubStr(cAux, nI, 1)
	next nI
	
	if !lExtens
		cName := FileNoExt(cName)
	endif
	
return cName


/*/{Protheus.doc} exists

Verifica se o arquivo existe

@type method
@author Victor Hugo
@since 11/11/2013

@return Logico Existência do arquivo
/*/
method exists() class IpFileObject
		
return File(::getFile())