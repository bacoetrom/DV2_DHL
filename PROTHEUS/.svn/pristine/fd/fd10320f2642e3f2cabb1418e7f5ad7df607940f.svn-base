#include 'protheus.ch'
#include 'dhl.ch'

/*/{Protheus.doc} GrvPedToNf
Gravação de campos do Pedido de Venda para Nota Fiscal
@author Thiago Meschiatti
@since 02/09/2016
@version undefined

@type function
/*/
user function GrvPedToNf()
	local nI		:= 0
	local aCpsPed	:= {"C5_ZZNFTER", "C5_ZZSETER", "C5_ZZCLTER", "C5_ZZLJTER", "C5_ZZTPPV"}
	local aCpsNf	:= {"F2_ZZNFTER", "F2_ZZSETER", "F2_ZZCLTER", "F2_ZZLJTER", "F2_ZZTPNF"}

	SF2->(RecLock("SF2", .f.))

	for nI := 1 to len(aCpsNf)
		if SF2->(FieldPos(aCpsNf[nI])) > 0
			If (aCpsNf[nI]) == "F2_ZZTPNF" .and. FWUnitBusiness() # DHL_BUSINESSUNIT_AG2
				if ((aCpsNf[nI]) == "F2_ZZTPNF" .and. FWUnitBusiness() == DHL_BUSINESSUNIT_AGL .and. (FwIsInCallStack("u_AglFatTringular") .or. FwIsInCallStack("U_AglNfRetSimbolico")))
					&("SF2->"+aCpsNf[nI]) := &("SC5->"+aCpsPed[nI])
				else
					loop
				endif
			Else
				&("SF2->"+aCpsNf[nI]) := &("SC5->"+aCpsPed[nI])
			EndIf
		endif
	next nI

	SF2->(MsUnlock())

return
