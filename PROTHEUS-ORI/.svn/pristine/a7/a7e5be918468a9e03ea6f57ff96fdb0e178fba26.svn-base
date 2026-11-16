#include "protheus.ch"
#include "rwmake.ch"
#include "msobject.ch"
#include "safx04.ch"
#include "safx.ch"
#include "dhl.ch"


#DEFINE FIELD_NULL "@"
#DEFINE TAB_SPACE CHR(09)
#DEFINE POS_FIELD 		1
#DEFINE POS_SIZE  		2
#DEFINE POS_DECIMAL 	3

/*/{Protheus.doc} MsafDwFile

Classe responsavel por criar o arquivo de exportacao
	
@author Daniel Braga
@since 31/10/2014

/*/
user function _MsafDWFile;return

class MsafDWFile from IpFileObject
	
	data aFields  as Array  
	data nTotalFields as Integer
	data cFile as String
	
	method newMsafDWFile(cFile,nTotalFields) constructor
	method renameArq(cExpFile,nTotalFields)
	
	method setFields(aFields)
	method getFields()
	
	method setTotalFields(nTotalFields)
	method getTotalFields()
	
	method setFile(cFile)
	method getFile()
	
	method write()
	method addField()
	method formatValue(xValue)
	method fieldNull()
	method fieldSeparator()
	method lineFeed()
	method getFileName()
	
	
endClass

method newMsafDWFile(cExpFile,nTotalFields) class MsafDWFile
	
	local cCnpj	  := Iif( empty(SM0->M0_CGC),padR("1",4,"1"),substr(SM0->M0_CGC,9,4))
	local cFileName := ""
	local oSql 	  := IpSqlObject():newIpSqlObject()
	local oUtils  := IpUtilsObject():newIpUtilsObject()
	local cPath	  := ""
	
	default cExpFile := ""
	default nTotalFields := 0
	
	if !Empty(cExpFile) .and. !Empty(nTotalFields)
	
		//Emerson Holanda 27/02/20 - Pasta exclusiva das SAFXs SCJ
		If (FWUnitBusiness() == DHL_BUSINESSUNIT_AG2)
			cPath := "\MasterSaf_DW\SAFX"
		Else
			cPath := oSql:getFieldValue("SZ1", "Z1_DIREXP", "%SZ1.XFILIAL% AND Z1_CODIGO = '"+APP_MASTERSAF_DW+"'")
		EndIf
		cFileName :=  ::getFileName(oUtils:concatDirectory(cPath, cCnpj+cExpFile), DTOS(DATE()), .f.)
		
		::newIpFileObject(cFileName)
		
		::nTotalFields := nTotalFields
		::cFile := cFileName 
		::aFields :=  Array( nTotalFields ) 
	
	endIf
	

	 
return 

method renameArq(cExpFile,nTotalFields) class MsafDWFile
	
	local cCnpj	  := Iif( empty(SM0->M0_CGC),padR("1",4,"1"),substr(SM0->M0_CGC,9,4))
	local cFileName := ""
	local cFileNew 	:= ""
	local oSql 	  := IpSqlObject():newIpSqlObject()
	local oUtils  := IpUtilsObject():newIpUtilsObject()
	local cPath	  := ""
	
	default cExpFile := ""
	default nTotalFields := 0
	
	if !Empty(cExpFile) .and. !Empty(nTotalFields)
	
		//Emerson Holanda 27/02/20 - Pasta exclusiva das SAFXs SCJ
		If (FWUnitBusiness() == DHL_BUSINESSUNIT_AG2)
			cPath := "\MasterSaf_DW\SAFX"
		Else
			cPath := oSql:getFieldValue("SZ1", "Z1_DIREXP", "%SZ1.XFILIAL% AND Z1_CODIGO = '"+APP_MASTERSAF_DW+"'")
		EndIf
		cFileName 	:=  ::getFileName(oUtils:concatDirectory(cPath, cCnpj+cExpFile), DTOS(DATE()), .f.)
		if File(cFileName) 
			cFileNew	:=  ::getFileName(oUtils:concatDirectory(cPath, cCnpj+cExpFile), DTOS(DATE()))
		endif
		
		fRename(cFileName, cFileNew)
		
	endIf
	

	 
return 

method setFields(aFields) class MsafDWFile
	::aFields := aFields
return

method getFields() class MsafDWFile
return ::aFields

method setTotalFields(nTotalFields) class MsafDWFile
	::nTotalFields :=  nTotalFields
return 

method getTotalFields() class MsafDWFile
return ::nTotalFields

method setFile(cFile) class MsafDWFile
	::cFile  := cFile
return

method getFile() class MsafDWFile
return ::cFile

method write() class MsafDWFile
	
	local nI 	:= 0
	local cLine := ""
	
	if !Empty( ::getFields() )
		
		if len( ::getFields() ) != ::getTotalFields()
			return .f.
		endIf
		
		for nI := 1 to  ::getTotalFields()
		
			cLine += ::getFields()[nI]  + ::fieldSeparator()
		
		next nI
				 
		::writeLine(cLine)
		
		::setFields( Array( ::getTotalFields() ) )

	endIf
return .t.

method addField(aField, xValue) class MsafDWFile

	local nPos  := 0
	local nSize := 0
	
	default aField := {}
	default xValue := ""

	nPos := aField[POS_FIELD]
	nSize:= aField[POS_SIZE]
	
	::getFields()[nPos] :=  padr( ::formatValue(xValue, aField),nSize," ") 

return 

method formatValue(xValue, aField, lFormatZero) class MsafDWFile

	local xNewValue		:= ""
	local oDhlLibrary 	:= DHLLibrary():newDHLLibrary()
	default xValue 		:= ""    
	default aField      := {}
	default lFormatZero := .T.
	
	if valType(xValue) == "D"
		
		xNewValue := dtos(xValue)
	
	elseIf  valType(xValue) == "N"
	
	 	xNewValue := formatNumber(xValue, aField)
	 	
	else 
		xNewValue :=  EncodeUTF8(xValue)
	endif 
    
    if empty(xValue) .and. lFormatZero
    	xNewValue := ::fieldNull()
    elseif empty(xValue) .and. !lFormatZero
    	if valType(xValue) == "N"
    		xNewValue := '0'
    	endif
    endIf

return xNewValue


method fieldNull() class MsafDWFile
return FIELD_NULL

method fieldSeparator() class MsafDWFile
return TAB_SPACE

method lineFeed() class MsafDWFile
return CRLF

method getFileName(cPrefix,cSuffix,lEnd) class MsafDWFile
	
	local cFileName := ""
	
	default cPrefix := "" 
	default cSuffix := ""
	default lEnd 	:= .t.
	
	if lEnd
		cFileName := cPrefix+"_"+cSuffix+".txt"
	else 
		cFileName := cPrefix+"_"+cSuffix+".processing"
	endif

return cFileName                                 

/**
 * Formata os Valores Numericos
 */                            
static function formatNumber(xValue, aField)
                          
    local cStrDec   := ""
	local cNumber   := ""
	local nNumber	:= 0
	local nQtdDecim := 0
	local nInteger  := Int(xValue)
	local nDecimal  := abs(xValue - Int(xValue))
	
	if (Len(aField) >= POS_DECIMAL)
		nQtdDecim := aField[POS_DECIMAL]
		nNumber   := round(xValue, nQtdDecim)
	endIf    
	
	if (nQtdDecim == 0)
		cNumber := strNumber(xValue)
	else
		cNumber := alltrim(str(nNumber))
		if at('.', cNumber) > 0
			if len(substr(cNumber, at('.', cNumber)+1, len(cNumber))) == nQtdDecim
				cNumber := strNumber(nNumber)
			else
				if len(substr(cNumber, at('.', cNumber)+1, len(cNumber))) > nQtdDecim
					cNumber := strNumber(round(nNumber, nQtdDecim))
				else
					cNumber := strNumber(nNumber) + Replicate("0", (nQtdDecim - len(substr(cNumber, at('.', cNumber)+1, len(cNumber)))))
				endif
			endif
		else
			cNumber := strNumber(nNumber) + Replicate("0", (nQtdDecim))
		endif
//		cStrDec := strNumber(nDecimal)
//		cStrDec := strNumber(Val(cStrDec))
//		cStrDec := cStrDec + Replicate("0", (nQtdDecim - Len(cStrDec)))
//		cNumber := strNumber(nInteger) + cStrDec  			
	endIf	
		
return cNumber

/**
 * Retorna a String de um Numero sem Pontos ou Virgulas
 */                                                    
static function strNumber(nNumber)
	
	local cNumber := AllTrim(Str(nNumber))
	
	cNumber := StrTran(cNumber, ".", "")	
	cNumber := StrTran(cNumber, ",", "")
	
return cNumber