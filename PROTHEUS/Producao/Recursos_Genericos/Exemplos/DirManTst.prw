#include "totvs.ch"
#include "rwmake.ch"

/*/{Protheus.doc} DirManTst

Função para testes da classe DHLDirectoryManager
	
@author Victor Hugo
@since 25/10/2014
/*/
user function DirManTst()
	
	local nI		 := 0
	local cFile		 := ""
	local cDirectory := "Z:\Users\victorhugo\Totvs\Clientes\DHL\Arquivos"
	local oDir 		 := DHLDirectoryManager():newDHLDirectoryManager(cDirectory)							
	local aFiles	 := oDir:getFiles()
	
	for nI := 1 to Len(aFiles)
		cFile := aFiles[nI]
		oDir:startProcess(cFile)
		if (nI % 2 == 0)
			oDir:setProcessed(cFile)
		else	
			oDir:setError(cFile)
		endIf
	next nI
							
return