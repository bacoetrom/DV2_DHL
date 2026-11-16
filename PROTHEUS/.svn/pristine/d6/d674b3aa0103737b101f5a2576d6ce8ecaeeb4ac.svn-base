#Include 'Protheus.ch'
#Include 'dhl.ch'


/*/{Protheus.doc} MA080VLD

Validar dados do TES
	
@author Thiago Meschiatti
@since 09/12/2014

@return lógico Indica se permite ou não cadastrar/alterar TES
/*/
User Function MA080VLD()
	local lRet	:= .t.
	local nOpt	:= PARAMIXB[1]
	
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		if ( (nOpt == DHL_OPC_INCLUSAO) .or. (nOpt == DHL_OPC_ALTERACAO))
			//lRet := u_DHLValidID("DHL_FLDMEM_REQUIRED", "F4_ZZSTATU")
			lRet :=  fieldMemRequired("F4_ZZSTATU")
		endif
	endif

Return (lRet)
//Emerson Holanda 20/01/2022
static function fieldMemRequired(cField)
	local lRet	   := .t.
	local aAreaSX3 := SX3->(GetArea())
	
	//TODO THIAGO VALIDAR SPL
	if FWUnitBusiness() == DHL_BUSINESSUNIT_SPL
		lRet := !empty(&("M->"+cField))
		if !lRet
			Help( ,, 'OBRIGA',, 'O preenchimento do campo '+alltrim(Posicione("SX3", 2, cField, "X3Titulo()" ))+' é obrigatório', 1, 0 )
		endif
	endif
	
	RestArea(aAreaSX3)
return(lRet)
