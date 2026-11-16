#Include 'Protheus.ch'
#Include 'dhl.ch'

/*/{Protheus.doc} RetMsgDis
Retorna Mensagem do Pedido de Venda
@author Thiago Meschiatti
@since 03/01/2017
@version 1.0
@return caracter, Mensagem para Inf. Adic. da Nota
/*/

User Function RetMsgDis()
	local aAreaSD2	:= SD2->(GetArea())
	local oSql		:= IpSqlObject():newIpSqlObject()
	local cPed		:= ""
	local cPedDlx	:= ""
	local cMsgAux	:= "Pedido de Venda DLX: "
	local cChave	:= SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA
	
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial("SD2") + cChave)
	
	While SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == cChave
		cPed := SD2->D2_PEDIDO
		if !empty(cPed)
			exit
		endif
		SD2->(DbSkip())
	end
	cPedDlx := alltrim(oSql:getFieldValue("SC5", "C5_ZZORDEX", "%SC5.XFILIAL% AND C5_NUM = '"+cPed+"'"))
	
	if !empty(cPedDlx)
		cMsgAux := cMsgAux + cPedDlx
	endif
	
	RestArea(aAreaSD2)
return (cMsgAux)