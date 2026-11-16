#Include 'Protheus.ch'

/*/{Protheus.doc} A140EXC

Ponto de entrada de validação da exclusão da pré nota
	
@author Renato Castro
@since 18/11/2014

@return logico indica se pode ou não excluir
/*/
User Function MTFILLP3()

local lRet := .T.         
Local cAliasTRB := ParamixB[2]
Local cES       := ParamixB[6]
Local _nPos     := 0

private lNewAge    := SuperGetMV("ZZ_NEWAGE",,.F.)
private lAutomatic := SuperGetMV("ZZ_AUTOMAT",,.F.)

If lNewAge .And. lAutomatic

   _cLoteCtl := GDFieldGet("C6_LOTECTL", n, , aHeader, aCols)


   If cES == "S"
      
//      _nPos := aScan(aHeader, {|x| allTrim(x[1]) == allTrim("D1_LOTECTL")})
//      _cLoteCtl := aCols[n][_nPOs]
      
      dbSelectArea(cAliasTRB)    
      If ALLTRIM(_cLoteCtl) <> ALLTRIM((cAliasTRB)->D1_LOTECTL)
         dbDelete()                        
      EndIf
   Else

//      _nPos := aScan(aHeader, {|x| allTrim(x[1]) == allTrim("D2_LOTECTL")})
//      _cLoteCtl := aCols[n][_nPOs]

      dbSelectArea(cAliasTRB)    
      If ALLTRIM(_cLoteCtl) <> ALLTRIM((cAliasTRB)->D2_LOTECTL)
         dbDelete()                   
      EndIf
   EndIf   

EndIf

Return
