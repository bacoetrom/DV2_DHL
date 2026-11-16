#include 'protheus.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc} Connection
(long_description)
@author    gusluiz_supplier
@since     10/07/2019
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
class Connection 
	
	data cConn
	data cServerAddr
	data nPort 
	data cDirectory
	data nHandle
	
	method newConnection(cConn, cServerAddr, nPort) constructor 
	method getHandle()
	method getDirectory(cApplication)
	method closeConnection(nHandle)

endclass

/*/{Protheus.doc} new
Metodo construtor
@author    gusluiz_supplier
@since     10/07/2019
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method newConnection(cConn, cServerAddr, nPort) class Connection
	
	::nHandle :=  TCLink( cConn , cServerAddr , nPort )
	
return 

/**
* Obtém o handle da conexão
***/
method getHandle() class Connection

return ::nHandle

/**
* Fecha a conexão
***/
method closeConnection(nHandle) class Connection
	
	local lResult := .F.
	
	lResult := TCUnlink(nHandle)
	
return lResult

/**
* obtém o caminho da integração
***/
method getDirectory(cApplication) class Connection
	
	local nTotRegis 		:= 0
	local cQuery			:= ""
	local cAlias		 	:= getNextAlias()
	
	::cDirectory := ""

	if ::nHandle >=0
		
		cQuery := " SELECT SZ1.Z1_DIRIMP FROM SZ1100 SZ1 " 		+ CRLF
		cQuery += " WHERE 1 = 1 " 								+ CRLF
		cQuery += "    AND SZ1.Z1_FILIAL = ' '"  				+ CRLF
		cQuery += "    AND SZ1.Z1_CODIGO = '" + cApplication + "'"+ CRLF
		cQuery += "    AND SZ1.D_E_L_E_T_ = ' '"  				+ CRLF		

		TcQuery cQuery New Alias (cAlias)

		Count to nTotRegis

		if nTotRegis > 0
			(cAlias)->(dbGoTop())
			::cDirectory := allTrim((cAlias)->Z1_DIRIMP)
		endIf
		
		(cAlias)->(dbCloseArea())		
		
	endIf
	
	self:closeConnection(::nHandle)
	
return ::cDirectory