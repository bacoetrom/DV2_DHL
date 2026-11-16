#Include 'Protheus.ch'
#Include 'dhl.ch'

User Function INCHVNFE()

Local cCHVNF := alltrim(SF1->F1_CHVNFE)
Local cNFcad	:= alltrim(SF1->F1_DOC)	
Local cNFdig  := ""
Local lOk := .T.

	If Len(cCHVNF) > 0
		lOk := .F.
		ALERT("Ação não permitida: Nota fiscal já possui chave cadastrada")
	Else
		lOk := .T.
	Endif
	
	
	If lOK
	
		cCHVNF  := alltrim(FWInputBox("Informe a chave da NF-e", ""))
		cNFdig	 := SubStr(cCHVNF, 26, 9)
		cNFcad	 := STRZERO(val(cNFcad), 9)
		
		If Len(cCHVNF) > 44 .or. Len(cCHVNF) < 44
			lOK := .F.
			ALERT("Ação não permitida: Chave digitada inválida")
		Elseif cNFcad = cNFdig
			lOK := .T.
		Else
			ALERT("Ação não permitida: Chave digitada inválida")
			lOK := .F.
		Endif
		
	Endif 

	IF lOK   
          RECLOCK("SF1", .F.)
          SF1->F1_CHVNFE := cCHVNF
          MSUNLOCK()  
          AVISO("","Chave da NF-e cadastrada com sucesso",{"Fechar"},1) 
	ENDIF

Return

