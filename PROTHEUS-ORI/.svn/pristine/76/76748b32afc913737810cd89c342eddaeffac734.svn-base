#Include 'Protheus.ch'

/*/{Protheus.doc} MATUCOMP

Utilizado para alterações automáticas nos complementos dos documentos fiscais após a emissão das Notas Fiscais.

@author Thiago Meschiatti
@since 19/07/2018

@param PARAMIXB, array, Chave da Nota Fiscal (Entrada ou Saida,Serie,Doc,Cliente ou Fornecedor,Loja)

/*/
User Function MATUCOMP()
	Local aArea	 	:= GetArea()
	Local aChave 	:= {PARAMIXB}
	
	If ExistBlock("PrcCodAnv")
		u_PrcCodAnv(aChave)
	EndIf
	
	RestArea(aArea)

Return