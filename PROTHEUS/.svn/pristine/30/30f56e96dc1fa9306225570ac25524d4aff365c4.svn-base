#include "totvs.ch"
#include "dhl.ch"

#define ALTER_INVOICE 4

#define SZ4_FILIAL    1
#define SZ4_DOC       2
#define SZ4_SERIE     3
#define SZ4_CLIFOR    4
#define SZ4_LOJA      5


/*/{Protheus.doc} _AgeNfSelScr

Seleção das Nf´s de 1ª perna para cobertura.

@author Edson Deluca
@since 25/05/2018
@version 1.0
@type JOB
/*/      

user Function _AgeVincCo(cParam1,cParam2)

	local oGetFilter    := nil
	local cCodFor		:= ""
	local cForn		    := ""
	local cLoja		    := ""
	local cCF		    := ""
    local cQuery        := ""

    RpcSetEnv(cParam1,cParam2)

	Private oSql		:= IpSqlObject():newIpSqlObject()
	Private aCF		    := Separa(getMV("ZZ_CFCOB"),";",.F.)
	private oUtils      := IpUtilsObject():newIpUtilsObject()
	private oLogImp     := DHLLogManager():newDHLLogManager()
	private cIdents     := ""
	private oGrid       := nil
	private oDlg        := nil
	private lMsErroAuto := .F.
	Private lMsHelpAuto := .F.                                                                                                 
	private aDetail     := {}
	private aHeader     := {}
	private lBKM	    := SuperGetMV("ZZ_COBAGE",,.T.)
	private lNewAge     := SuperGetMV("ZZ_NEWAGE",,.F.) //adicionado por Edson Deluca - FIT Gestão	
	private lAutomatic  := SuperGetMV("ZZ_AUTOMAT",,.F.) //adicionado por Edson Deluca - FIT Gestão	

    FWLogMsg("INFO", , "BusinessObject", funName(), "", "01", "Iniciando...", 0, 0, {})
    
    If lNewAge .And. lAutomatic

      If !LockbyName("_AgeVincCo",.T.,.T.)
         RpcClearEnv()
         Return
      EndIf

      FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Entrando Braskem...", 0, 0, {})

      cQuery := " SELECT SD1.D1_DOC,SD1.D1_SERIE,SF1.F1_FORNECE,SF1.F1_LOJA,SF1.F1_XNFTRF,SF1.F1_XSERTRF "
      cQuery += " FROM SD1100 SD1 "
      cQuery += " INNER JOIN SF1100 SF1 ON SF1.F1_FILIAL = SD1.D1_FILIAL AND SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE = SD1.D1_SERIE AND SF1.D_E_L_E_T_<>'*' "
      cQuery += " INNER JOIN SF1100 SF1B ON SF1B.F1_FILIAL = SD1.D1_FILIAL AND SF1B.F1_DOC = SF1.F1_XNFTRF AND SF1B.F1_SERIE = SF1.F1_XSERTRF AND SF1B.D_E_L_E_T_<>'*' "
      cQuery += " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
      cQuery += " SF1.F1_XNFTRF  <> '         ' AND " 
      cQuery += " SF1.F1_XPROCES <> '*' AND "
      cQuery += " SD1.D_E_L_E_T_<>'*' AND "
      cQuery += " SF1B.F1_ZZSTATU = ' ' AND "
      cQuery += " SD1.D1_DOC NOT IN (SELECT Z42.Z4_DOC FROM SZ4100 Z42 WHERE Z42.Z4_FILIAL = '"+xFilial("SZ4")+"' AND Z42.Z4_DOC = SD1.D1_DOC AND Z42.Z4_SERIE = SD1.D1_SERIE AND "
      cQuery += " SD1.D1_COD = Z42.Z4_PRODUTO AND Z42.Z4_TIPMOV  = '2' AND Z42.D_E_L_E_T_<>'*') AND "
      cQuery += " SF1.F1_XNFTRF IN (SELECT Z41.Z4_DOC FROM SZ4100 Z41 WHERE Z41.Z4_FILIAL = '"+xFilial("SZ4")+"' AND Z41.Z4_DOC = SF1.F1_XNFTRF AND Z41.Z4_SERIE = SF1.F1_XSERTRF AND "
      cQuery += " SD1.D1_COD = Z41.Z4_PRODUTO AND Z41.Z4_TIPMOV  = '1' AND Z41.Z4_SALDO<>0 AND Z41.D_E_L_E_T_<>'*') "

	  DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBZ4",.F.,.T.)
	
	  dbSelectArea("TRBZ4")
	  dbGoTop()
		
	  while !Eof()
		
          FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Query com resultado...", 0, 0, {})

		  dbSelectArea("SA1")   
		  dbSetOrder(1)
		  If dbSeek(xFilial("SA1") + TRBZ4->F1_FORNECE + TRBZ4->F1_LOJA + TRBZ4->F1_LOJA ,.F.)
		     nRegSA2 := RECNO()
		  Else
             _cFunName := "_AgeVincCo"
             _cMsg     := "Fornecedor não localizado no Protheus - CNPJ: "+TRBZ4->F1_FORNECE + TRBZ4->F1_LOJA +"." 
             _cDoc1    := TRBZ4->F1_FORNECE
             _cDoc2    := TRBZ4->F1_LOJA
             _cDoc3    := ""
             _cCodMsg  := "01"
             If lNewAge .And. lAutomatic
                If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
                   setFileLog(" ","fail",_cMsg)
		        EndIf
	         Else
	            setFileLog(" ","fail",_cMsg)
		     EndIf

		     FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "Não encontrou Fornecedor... Abortando...", 0, 0, {})
		     
		     dbSelectArea("TRBZ4")
		     dbSkip()
		     Loop
		     
		  EndIf
		
		  dbSelectArea("SF1")
		  dbSetOrder(1)
		  If dbSeek(xFilial("SF1") + TRBZ4->D1_DOC + TRBZ4->D1_SERIE + TRBZ4->F1_FORNECE + TRBZ4->F1_LOJA ,.F.)
		     If SF1->F1_XPROCES<>'*'
		        nRegSF1 := RECNO()
		     Else  
		        dbSelectArea("TRBZ4")
		        dbSkip()
		        Loop
		     EndIf
		  Else
             _cFunName := "_AgeVincCo"
             _cMsg     := "Não encontrou a NF do Fornecedor: "+TRBZ4->D1_DOC + TRBZ4->D1_SERIE + TRBZ4->F1_FORNECE + TRBZ4->F1_LOJA+"." 
             _cDoc1    := TRBZ4->D1_DOC
             _cDoc2    := TRBZ4->D1_SERIE
             _cDoc3    := TRBZ4->F1_FORNECE
             _cCodMsg  := "02"
             If lNewAge .And. lAutomatic
                If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
                   setFileLog(" ","fail",_cMsg)
		        EndIf
	         Else
	            setFileLog(" ","fail",_cMsg)
		     EndIf

		     FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "Não encontrou a NF do Fornecedor... Abortando...", 0, 0, {})
		     dbSelectArea("TRBZ4")
		     dbSkip()
		     Loop
		  EndIf
        
		  dbSelectArea("SD1")
		  dbSetOrder(1)
		  If dbSeek(xFilial("SD1") + TRBZ4->D1_DOC + TRBZ4->D1_SERIE + TRBZ4->F1_FORNECE + TRBZ4->F1_LOJA ,.F.)
		     nRegSD1 := RECNO()
		  Else
             _cFunName := "_AgeVincCo"
             _cMsg     := "Não encontrou Itens da NF do Fornecedor: "+TRBZ4->D1_DOC + TRBZ4->D1_SERIE + TRBZ4->F1_FORNECE + TRBZ4->F1_LOJA+"." 
             _cDoc1    := TRBZ4->D1_DOC
             _cDoc2    := TRBZ4->D1_SERIE
             _cDoc3    := TRBZ4->F1_FORNECE
             _cCodMsg  := "03"
             If lNewAge .And. lAutomatic
                If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
                   setFileLog(" ","fail",_cMsg)
		        EndIf
	         Else
	            setFileLog(" ","fail",_cMsg)
		     EndIf

		     FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "Não encontrou Itens da NF do Fornecedor... Abortando...", 0, 0, {})
		     
		     dbSelectArea("TRBZ4")
		     dbSkip()
		     Loop
		  EndIf

		  dbSelectArea("SZ4")
		  dbSetOrder(1)
		  If dbSeek(xFilial("SZ4") + TRBZ4->F1_XNFTRF + TRBZ4->F1_XSERTRF,.F.)
		     nRegSZ4 := RECNO()
		  Else
             _cFunName := "_AgeVincCo"
             _cMsg     := "Não encontrou SZ4 da NF em questão: "+TRBZ4->F1_XNFTRF + TRBZ4->F1_XSERTRF+"." 
             _cDoc1    := TRBZ4->F1_XNFTRF
             _cDoc2    := TRBZ4->F1_XSERTRF
             _cDoc3    := ""
             _cCodMsg  := "04"
             If lNewAge .And. lAutomatic
                If U_FITLogControl(_cFunName,_cCodMsg,_cDoc1,_cDoc2,_cDoc3,_cMsg)
                   setFileLog(" ","fail",_cMsg)
		        EndIf
	         Else
	            setFileLog(" ","fail",_cMsg)
		     EndIf

		     FWLogMsg("WARN", "LAST", "BusinessObject", funName(), "", "01", "Não encontrou SZ4 da NF em questão... Abortando...", 0, 0, {})
		     
		     dbSelectArea("TRBZ4")
		     dbSkip()
		     Loop
		  EndIf

          _aArea := GetArea()                      
	      
	      FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Entrando rotina _AgeNfSelS", 0, 0, {})
		  
          U__AgeNfSelS(nRegSA2,nRegSF1,nRegSD1,nRegSZ4)
                           
          RestArea(_aArea)
                 
	     dbSelectArea("TRBZ4")
	     dbSkip()
	     Loop
		
	   enddo

	   oSql:close()

       UnLockbyName("_AgeVincCo",.T.,.T.)
	
	EndIf

    FWLogMsg("INFO", "LAST", "BusinessObject", funName(), "", "01", "Finalizando...", 0, 0, {})
    
	RpcClearEnv()
	
return


static function setFileLog(cFile,cLogType,cLogText,cTag,cValue)
	
	local cInterface := "IMPORTADOR XML"
	
	oLog:start(APP_DLX,DHL_IMPORTACAO,cFile)
	
	if !(Empty(cTag))
		cLogText += CRLF+CRLF+"Tag: "+cTag
	endIf
	
	if !(Empty(cValue))
		cLogText += CRLF+CRLF+"Valor: "+cValue
	endIf
	
	if (cLogType == "fail")
		oLog:fail(cInterface, cLogText)
	elseIf (cLogType == "warn")
		oLog:warn(cInterface, cLogText)
	endIf
	
return
