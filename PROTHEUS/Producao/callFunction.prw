#include 'protheus.ch'
#include 'parmtype.ch'
#include 'dhl.ch'


user function callFunction()


	local cEmp  := "10"
	local cFil  := "149AG2014901"// "02836056014913"
	//local cFil  := "016DIS001663"	
	//local cFil	:= "L95AGE95LOTE"     //02836056009596
	local cFil	:= "001REV000106"     //02836056000106
	//local cFil	:= "044MUL004417"     //00233065004417
	//LOCAL CfIL := "016DIS001663" //00233065001663

	local lRet	:= .F.
	local nSleep:= 3000
	lStatus := rpcSetEnv(cEmp, cFil, , )

	if FWUnitBusiness() == DHL_BUSINESSUNIT_DIS	
		conout("")		
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AGE
		conout("")
	elseif FWUnitBusiness() == DHL_BUSINESSUNIT_AG2
		conout("")
	else
		conout("")
	endif



	//SF2->(dbSetOrder(1))

	//oTMsg  	 	:= FswTemplMsg():newTemplMsg("S",SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,"SZZ")
	//oTMsg:Processa()


	//local cFil	:= "130AGE013003"   //Não aparece
	//local cFil	:= "004AGE000459"   // aparece

	//conout("INICIANDO")
	//lStatus := rpcSetEnv(cEmp, cFil, , )

	//PswOrder(2)

	//SZA->(dbGoTo(87295))
	//SZB->(dbGoTo(1492))
	//StaticCall(MonIp040, ProcessarNF	)
	//u_createCegedim({cEmp, cFil})

	//BEGIN TRANSACTION



























	/*
	conout(">>INICIANDO")
	for nI := 1 to 150
	if nI == 299
	conout("teste")
	endIf
	//lRet :=  u_inijob("tes", nSleep)
	lRet := startjob("u_inijob",getenvserver(),.F.,"JOB "+cValToChar(nI)+": Data Atual " + cvaltochar(date()))
	conout("OK")
	sleep(nSleep)			
	next nI

	conout("teste")
	*/

































	// u_inijob("tes")

	//U__XMLTerceiro()
	//U__agevincco()
	//U_Dhlbxmail()
	//U__AgeVNFTer()
	//tstLib()
	//u_TST()
	//SF1->(dbSetOrder(1))
	//SF1->(dbGoTo(122109))
	//u_AgeNfSelScr()
	//u_ProcMsaDW()
	//u_EXECIMPXML("10", cFil, "02836056009596")
	//U__AgeVNFTer(cEmp,cFil)
	//u_DHLDLX()
	//u_execF0A()
	//u_ImpMsaNfe()
	U_DHLSELECT()
	//_DHLSAP()
	//u_MondVNFTer(cEmp,cFil)
	//U_EXECIMPXML()
	//U__xmlterceiro()
	//U__agevincco("10", cFil)
	//u_DHLNULOGY()
	//END TRANSACTION


return

static function tstLib()

	local cSeekKey		:= ""
	Local lPutAll		:= ( cSeekKey == Nil )
	Local aNoFields := {}
	Local aYesFields := {}
	Local lNoFields		:= ( ValType(aNoFields)=="A" )
	Local lYesFields	:= ( ValType(aYesFields)=="A" )
	Local lPutAll		:= ( cSeekKey == Nil )

	DEFAULT lUserFields := .F.

	cAlias := "SC6"

	// Monta o array aHeader para a MsGetDados() e MsNewGetDados()
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cAlias))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias

		If ( lYesFields .And. Ascan( aYesFields,{|x| x==Rtrim(SX3->X3_CAMPO)} ) == 0 )
			If ( !lUserFields .Or. ( lUserFields .And. SX3->X3_PROPRI <> "U" ) )
				SX3->(dbSkip())
				Loop
			EndIf
		ElseIf ( lOnlyYes )
			If ! ( SX3->X3_PROPRI == "U" .And. ( Ascan( aYesUsado,{|x| x==Rtrim(SX3->X3_CAMPO)}) <> 0 .Or. X3USO(SX3->X3_USADO) ) .And. ;
			cNivel >= SX3->X3_NIVEL )
				SX3->(dbSkip())
				Loop
			EndIf
		Else
			If !( ( Ascan( aYesUsado,{|x| x==Rtrim(SX3->X3_CAMPO)}) <> 0 .Or. X3USO(SX3->X3_USADO) ) .And. cNivel >= SX3->X3_NIVEL .And. ( !lNoFields .Or. Ascan( aNoFields, {|x| x==Rtrim(SX3->X3_CAMPO)} ) == 0 ) )
				SX3->(dbSkip())
				Loop
			EndIf
		EndIf

		If ( __lPymeSX3 .and. SX3->X3_PYME <> "N" )
			SX3->(dbSkip())
			Loop
		EndIf

		nUsado += 1
		Aadd( aHeader, {	Rtrim( SX3->(X3Titulo())), ;
		SX3->X3_CAMPO,; 
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID, 	;
		SX3->X3_USADO,	;
		SX3->X3_TIPO, 	;
		SX3->X3_F3,;
		SX3->X3_CONTEXT ;
		} )

		SX3->(dbSkip())
	End

	conout("teste")
	// Bloco para manipular o aHeader apos a inserção padrão
	If ValType(bAfterHeader) == "B"
		Eval( bAfterHeader, aHeader)
		nUsado := Len(aHeader)
	EndIf

	// Alterar para string fixa
	SX3->(dbSetOrder(2))
	SX3->(PrefixoCpo(cAlias)+"_FILIAL")
	cUsado := SX3->X3_USADO

	nUsado += 2
	AADD( aHeader, { "Alias WT", PrefixoCpo(cAlias)+"_ALI_WT", "", 03, 0, "", cUsado, "C", cAlias, "V"} )
	AADD( aHeader, { "Recno WT", PrefixoCpo(cAlias)+"_REC_WT", "", 10, 0, "", cUsado, "N", cAlias, "V"} )

	If lHeaderInParm // utilizar aHeader private
		aHeaderAux := Aclone(aHeader)
	EndIf

	SX3->(dbSetOrder(nSvSX3Order))

return