#Include 'Protheus.ch'

/*/{Protheus.doc} VldIdSales

Validar Abertura de tele de seleção de ID na geração do PV e Doc. de Entrada

@author Thiago Meschiatti
@since 11/11/2014

@param xParam, TipoParam, DescricaoDoParam

@return TipoRet DescricaoRet
/*/
User Function ValidF3()
	local lRet := .t.

	if type("_F3DhlId") != "U"
		if (!_F3DhlId)
			lRet := .f.
		endif
	else
		lRet	:= .f.
	endif

	_F3DhlId := .f.
	if !lRet
		alert("Favor alterar ID utilzando a consulta F3!")
	endif
Return (lRet)

