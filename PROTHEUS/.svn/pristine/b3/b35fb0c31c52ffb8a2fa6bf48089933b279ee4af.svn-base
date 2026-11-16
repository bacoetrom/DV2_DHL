#Include 'Protheus.ch'
#Include 'rwmake.ch'
#Include 'Totvs.ch'
#Include 'DHL.ch'
#Include "TopConn.ch"

#Define GETF_ONLYSERVER 1

/*/{Protheus.doc} _XMLTerceiro
		@author 	Edson Deluca
		@version 	1.0
		@since 		25/05/2018
/*/
******************************************************************************************************************
User Function _TelaNF()
******************************************************************************************************************

	Local oFont, oData, oGrp1, oTela
	Local lConfirma    := .F.
	Local oDIALOG
	
	
	Local oDlg := Nil
	Local oExpl := Nil
	Local oPanel := Nil
	Local aPanels := {}

	Local aArea := GetArea()
    Local oGrpSearch, oGrpResult, oGroup1
    Local oBtnConf, oBtnClose
    Private lRetorno := .F.
    Private oDlgPvt
    //Says e Gets
    Private oSayNf, oSayNfRet
    Private oGetNf, cGetNf := Space(9)
    Private oSaySerie, oSayNfRet
    Private oGetSerie, cGetSerie := Space(3)
    Private oGetErr, cGetErr := ""
    //Dimensões da janela
    Private nJanLarg := 800
    Private nJanAltu := 400

	
	Private _cNFCob      := Space(9)
	Private _cSerCob     := Space(3)
    Private _cSerTransf  := Space(3)
    Private _cNFTransf   := Space(9)
    Private _dEmisTransf := cTod("  /  /  ")

     
    //Criando a janela
    DEFINE MSDIALOG oDlgPvt TITLE "Consulta NF de Retorno" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        	
        	oGrpSearch:= TGroup():New(003,003,60,(nJanLarg/2)-3,"Dados BRASKEM",oDlgPvt,,,.T.)
       
            @ 013, 006   SAY   oSayNf PROMPT "NF Venda:"        SIZE 030, 007 OF oDlgPvt                    PIXEL
            @ 020, 006   MSGET oGetNf VAR    cGetNF           	SIZE 030, 007 OF oDlgPvt COLORS 0, 16777215 PIXEL
                     
            @ 033, 006   SAY   oSaySerie PROMPT "Série:"          SIZE 030, 007 OF oDlgPvt                    PIXEL
            @ 040, 006   MSGET oGetSerie VAR    cGetSerie         SIZE 010, 007 OF oDlgPvt COLORS 0, 16777215  PIXEL 

            @ 065, 002 BUTTON oBtnConf PROMPT "Buscar"             SIZE (nJanLarg/2)-4, 015 OF oDlgPvt ACTION (getDadosNF()) PIXEL
            oBtnConf:SetCss("QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }")

 			@ 170, 377 BUTTON oBtnClose PROMPT "Fechar"             SIZE 020, 015 OF oDlgPvt ACTION oDlgPvt:End() PIXEL
            oBtnClose:SetCss("QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }")

            //Get de Log, pois se for Say, não da para definir a cor
            @ 90, 150   MSGET oGetErr VAR    cGetErr        SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 NO BORDER PIXEL
            oGetErr:lActive := .F.
            oGetErr:setCSS("QLineEdit{color:#FF0000; background-color:#FEFEFE;}")
                 	
         	oGrpResult := TGroup():Create(oDlgPvt,100,003,155,(nJanLarg/2)-3,'Dados NF DHL',,,.T.)             
            @ 110, 006   SAY   oSayNfRet PROMPT "NF Retorno:"        SIZE 030, 007 OF oDlgPvt                    PIXEL
            @ 117,006  MSGET oData VAR _cNFTransf  PICTURE "@!" 	 SIZE 030, 007 OF oDlgPvt PIXEL HASBUTTON
	    	
	    	@ 110, 060   SAY   oSaySerieRet PROMPT "Série:"          SIZE 030, 007 OF oDlgPvt                    PIXEL
	    	@ 117, 060 MSGET oData VAR _cSerTransf PICTURE "@!" 	 SIZE 010, 007 OF oDlgPvt PIXEL HASBUTTON
	    	
	    	@ 130, 006   SAY   oSaySerieRet PROMPT "Data de Emissão:" SIZE 050, 007 OF oDlgPvt          PIXEL
	    	@ 137,006 MSGET oData VAR _dEmisTransf PICTURE "@!" SIZE 050 , 007 OF oDlgPvt PIXEL HASBUTTON
	    		      
         ACTIVATE MSDIALOG oDlgPvt CENTERED 
     
    RestArea(aArea)
Return lRetorno

static function getDadosNF()
	
	local oSql	  	  	:= IpSqlObject():newIpSqlObject()	
	local cQuery 		:= ""
	
	cGetErr := ""
	oGetErr:Refresh() 
	   
    cQuery := " SELECT SZ8.Z8_NFRET, SZ8.Z8_SERRET, SF2.F2_EMISSAO,SF2.F2_DOC,SF2.F2_SERIE "
    cQuery += " FROM  "+RetSqlName("SZ8")+" SZ8 "
    cQuery += " INNER JOIN "+RetSqlName("SF2")+" SF2 ON SF2.F2_FILIAL = SZ8.Z8_FILIAL AND SF2.F2_DOC=SZ8.Z8_NFRET AND SF2.F2_SERIE=SZ8.Z8_SERRET AND SF2.D_E_L_E_T_<>'*' "
    cQuery += " WHERE SZ8.D_E_L_E_T_ <> '*' AND SZ8.Z8_FILIAL = '"+xFilial("SZ8")+"' "
    cQuery += " AND SZ8.Z8_DOC = '"+cGetNF+"' AND SZ8.Z8_SERIE='"+cGetSerie+"' "

	oSql:newAlias(changeQuery(cQuery)) 
	
	if oSql:hasRecords() 
       _cSerTransf  := oSql:getValue("F2_SERIE")           	
       _cNFTransf   := oSql:getValue("F2_DOC")
       _dEmisTransf := oSql:getValue("F2_EMISSAO")
       lRetorno := .T.
	else
	   _cSerTransf  := ""
	   _cNFTransf   := ""
	   _dEmisTransf := ""
	   cGetErr := "N O T A   N A O   E N C O N T R A D A!"
	   oGetErr:Refresh() 
	   Return .T.
    EndIf
	
	oSql:Close()
	
	If Empty(_cNFTransf)
	   lRetorno := .T.
	Endif

return lRetorno
