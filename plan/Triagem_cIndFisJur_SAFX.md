# Triagem do `cIndFisJur` nas SAFX (Fase 6, item 3)

- **Data:** 18/11/2026
- **Origem:** solicitação da área fiscal — *"indicador de pessoa decidido só por `F3_TIPO $ "DB"`; crédito (`F1_TIPO` 5) e débito 07 saem com o tipo de participante errado"*
- **Gerado por:** `scratchpad/triagem_indfisjur.py` (reprodutível)
- **Status:** análise concluída. **Nenhuma alteração de código feita** — a correção depende de dois itens em aberto (ver §4).

---

## 1. A causa, confirmada

`DHLSafx07.prw:123` e equivalentes:

```advpl
cIndFisJur := Iif( cType =="1",Iif((cSF3_)->(F3_TIPO) $ "DB" ,"2","1" ) , Iif(!(cSF3_)->(F3_TIPO) $ "DB" ,"2","1" ) )
```

A expressão considera **apenas** entrada/saída (`cType`) e `F3_TIPO` pertencer a `"DB"` (Devolução/Beneficiamento). **Não considera** os valores novos de `F*_TIPO` (`5` crédito, `6` débito) nem o `F*_TPCOMPL` (subtipo). Logo:

- **crédito** (`F1_TIPO` = `5`) é documento de **entrada** cujo participante é um **cliente**, não um fornecedor;
- **débito 07** (`F2_TIPO` = `6` com `F2_TPCOMPL` = `07`, perda em estoque) tem a própria DHL como destinatário.

Nos dois casos a expressão atual classifica o participante pelo caminho errado.

## 1.1 A raiz é maior: `F3_TIPO $ "DB"` como único discriminador

Varredura dos 102 fontes de `Mastersaf_DW` em 18/11/2026, motivada pela pergunta *"por que não está havendo alteração nos fontes do inventário?"*. O teste binário `f3_tipo` pertencer a `"DB"` (Devolução/Beneficiamento) aparece em **três lugares distintos**, e nenhum tem noção de `F*_TIPO` `5` (crédito) ou `6` (débito):

| # | Manifestação | O que decide | Fontes |
|---|---|---|---|
| 1 | `cIndFisJur := Iif(… F3_TIPO $ "DB" …)` | tabela de participante (SA1 × SA2) lida por `getSupCusRecords` | **28** |
| 2 | Roteamento dos ramos do `UNION` na query | o `JOIN` de participante e o `a1_zzinddw` × `a2_zzinddw` | **5** |
| 3 | `case when f3_tipo in ('D','B') then … end tipo` | **o tipo de movimento gravado no arquivo** | **7** |

### Manifestação 2 — roteamento da query (Padrão B)

Em `07AG2SAFX.prw`, `SAFX07AGE.prw`, `SAFX07AGL.prw`, `SAFX07MSDW.prw` e `Di2SAFX07MSDW.prw`, a query tem quatro ramos `UNION ALL`, com o participante escolhido assim:

```sql
-- ramo de entrada com cliente (SA1)
AND f3_cfo < 5000  AND f3_tipo IN ( 'D', 'B' )
-- ramo de entrada com fornecedor (SA2)
AND f3_cfo < 5000  AND f3_tipo NOT IN ( 'D', 'B' )
```

A **nota de crédito** é entrada com `F3_TIPO = '5'`. Como `'5'` não está em `('D','B')`, ela cai no ramo do **fornecedor** e o join fica `a2_cod = f3_cliefor` — mas `F3_CLIEFOR` guarda código de **cliente**. O `LEFT JOIN` então não casa (participante nulo: nome, CNPJ e IE vazios) ou casa com outra entidade que tenha o mesmo código. Nos dois casos o arquivo sai errado.

A estrutura de quatro ramos **já contempla** entrada-com-cliente; o que falha é a condição que roteia para ele.

### Manifestação 3 — tipo de movimento (Padrão A), a mais grave

Em `DHLSafx07.prw`, `DHLSafx07Ag2`, `DHLSafx07Age`, `DHLSafx07Agl`, `DHLSafx07Dis`, `DHLSafx07Mul` e `Di2DHLSafx07`:

```advpl
cQuery += " case when f3_tipo in ( 'D' ,'B') then '"+SAFX_MOVIMENTO_DEVOLUCAO+"' else '"+SAFX_MOVIMENTO_NORMAL+"' end tipo, "
```

Só existem dois valores: `SAFX_MOVIMENTO_DEVOLUCAO` e `SAFX_MOVIMENTO_NORMAL`. Logo, **nota de crédito e nota de débito são exportadas para o livro fiscal como operação normal**. Não é só o participante que sai errado — é a própria natureza da operação.

### Por que isso importa para a resposta "a Fase 6 está bloqueada no leiaute"

As três manifestações **não dependem do leiaute Mastersaf DW 2027**. São lógica de classificação sobre dados que já existem. A afirmação de que a Entrega 8 está integralmente bloqueada no leiaute era grosseira: o que depende do leiaute é a **exportação dos valores novos** (IBS/CBS/IS, CST, cClassTrib). A **classificação correta do documento** pode e deve ser corrigida antes.

Confirmado também, pela mesma varredura: **nenhum** dos 102 fontes de `Mastersaf_DW` menciona IBS, CBS, IS, `cClassTrib`, `MV_RTC55` ou `lRefTribCo`. E os filtros `F2_TIPO = 'N'` / `F1_TIPO = 'B'`, que excluiriam crédito e débito do arquivo, existem **só** nos fontes `SAFX235` (DIS/MUL/PKG), que estão fora da relação de 54.

## 2. O defeito tem duas camadas, não uma

A solicitação fiscal trata do campo exportado. A verificação mostrou que o impacto é maior:

**Camada 1 — seleção do registro de participante.** O `cIndFisJur` é passado a `DHLSafx:getSupCusRecords(cType, cCod, cBranch)`, que escolhe a tabela e o prefixo (SA1 cliente × SA2 fornecedor). Indicador errado ⇒ **lê o cadastro errado**, afetando todos os campos derivados dele (nome, CNPJ, IE, endereço), não só o indicador. Exemplo em `DHLSafx116.prw:143`:

```advpl
aSupRef := ::getSupCusRecords(cIndFisJur,cCodRef,cBranRef)
```

E em `DHLSafx116.prw:138` o indicador é **invertido** para o participante referenciado:

```advpl
aSupRef := ::getSupCusRecords(iif(cIndFisJur == '1','2','1'), ...)
```

**Camada 2 — o campo exportado.** O indicador gravado no arquivo vem, na maioria dos fontes, de `(cSF3_)->ZZINDDW`, que **é resolvido na própria query**, por ramo do `UNION`:

```advpl
cQuery += "SELECT '2' ENT_SAI, a1_zzinddw ZZINDDW, "   // ramo de cliente  (SA1)
cQuery += "SELECT '2' ENT_SAI, a2_zzinddw ZZINDDW, "   // ramo de fornecedor (SA2)
```

Portanto o campo exportado está correto **se e somente se** o ramo do `UNION` for escolhido corretamente — o que também depende de tratar `F*_TIPO` 5 e 6. Essa camada fica nos fontes de query (`07AG2SAFX`, `SAFX07AGE`, `SAFX07MSDW` e equivalentes), **não** nas classes `DHLSafx*`.

## 3. Triagem por fonte

Classificação quanto ao **campo exportado**:

| Grupo | Critério | Fontes |
|---|---|---|
| **A** | O campo vem de `Iif(cIndFisJur …)` — o indicador afeta diretamente o valor exportado | **2** |
| **B/C** | O campo vem de `(cSF3_)->ZZINDDW`, com o `Iif(cIndFisJur …)` comentado — mas o `cIndFisJur` **continua ativo** na camada 1 | **26** |

> **Correção de uma leitura anterior:** classifiquei 21 fontes como "possível código morto" porque procurei a constante `IDENT_FIS_JUR`. Esses fontes usam **`IND_FIS_JUR`** (nome diferente) e **alimentam** o campo. Não há código morto: nos 28 fontes o `cIndFisJur` tem efeito, seja na camada 1, na 2, ou nas duas.

### Grupo A — o indicador define o valor exportado

| Fonte | Decide em | Alimenta `IDENT_FIS_JUR` em |
|---|---|---|
| `DHLSafx07Dis.prw` | 593 | 185 |
| `DHLSafx07Mul.prw` | 122 | 143 |

### Grupo B/C — campo via `ZZINDDW`, `cIndFisJur` ativo na camada 1

| Fonte | Decide em | Campo em | Usos ativos (camada 1) |
|---|---|---|---|
| `DHLSafx07.prw` | 123 | 159 | 172, 252, 253 |
| `DHLSafx07Ag2.prw` | 199 | 213 | 226, 330, 331 |
| `DHLSafx07Age.prw` | 151 | 185 | 198, 278, 279 |
| `DHLSafx07Agl.prw` | 151 | 182 | 195, 275, 276 |
| `Di2DHLSafx07.prw` | 123 | 159 | 172, 252, 253 |
| `DHLSafx08.prw` | 181 | 226 | — |
| `DHLSafx08Ag2.prw` | 179 | 209 | — |
| `DHLSafx08Age.prw` | 178 | 209 | — |
| `DHLSafx08Agl.prw` | 178 | 210 | — |
| `DHLSafx08Dis.prw` | 188 | 206 | 190 |
| `DHLSafx08Mul.prw` | 172 | 200 | 174 |
| `DHLSafx112.prw` | 60 | 110 | — |
| `DHLSafx112Ag2.prw` | 63 | 104 | — |
| `DHLSafx112Age.prw` | 60 | 105 | — |
| `DHLSafx112Dis.prw` | 72 | 108 | 74 |
| `DHLSafx112Mul.prw` | 58 | 81 | 60 |
| `DHLSafx116.prw` | 276 | 156 | 138, 143, 144 |
| `DHLSafx116Ag2.prw` | 292 | — | 155, 161, 166, 167… |
| `DHLSafx116Age.prw` | 295 | — | 142, 148, 153, 154… |
| `DHLSafx116Agl.prw` | 302 | — | 141, 147, 152, 153… |
| `DHLSafx116Dis.prw` | 250 | — | 117, 126, 131, 132… |
| `DHLSafx116Mul.prw` | 244 | — | 109, 118, 123, 124… |
| `_AGL112.prw` | 52 | — | 98 |
| `DHLDisSafx235.prw` | 350 | — | 344, 353 |
| `DHLMulSafx235.prw` | 349 | — | 343, 352 |
| `DHLPkgSafx235.prw` | 349 | — | 343, 352 |

Os três `*Safx235` e o `_AGL112` estão **fora** da relação de 25 fontes da solicitação fiscal.

## 4. A convenção `"1"` / `"2"`, decodificada

Decodificada em `DHLSafx.prw`, no `getSupCusRecords`:

```advpl
if cType  == "1"
	cTable := "SA2"      // "1" = FORNECEDOR
else
	cTable := "SA1"      // qualquer outro valor = CLIENTE
endIf
```

Não é `elseif cType == "2"`: **qualquer** valor diferente de `"1"` — inclusive vazio — resolve para cliente, silenciosamente.

Com isso, a expressão original está **correta** para os quatro casos clássicos, e é por isso que o comportamento deles foi preservado:

| Operação | `ENT_SAI` | `F3_TIPO` | Resultado | Participante | Correto? |
|---|---|---|---|---|---|
| Compra | 1 entrada | `N` | `"1"` | fornecedor | ✅ |
| Devolução recebida | 1 entrada | `D` | `"2"` | cliente | ✅ |
| Venda | 2 saída | `N` | `"2"` | cliente | ✅ |
| Devolução enviada | 2 saída | `D` | `"1"` | fornecedor | ✅ |
| **Crédito** | 1 entrada | `5` | `"1"` | fornecedor | ❌ deveria ser cliente |
| **Débito 07** | 2 saída | `6` | `"2"` | cliente | ❌ destinatário é a própria DHL |

### Por que a inversão da linha 138 é o ponto sensível

```advpl
if lCobert
	aSupRef := ::getSupCusRecords(iif(cIndFisJur == '1','2','1'), xobj:getvalue(::cPrefix+"_FORNECE"), ...)
else
	aSupRef := ::getSupCusRecords(cIndFisJur, cCodRef, cBranRef)
endif
```

A inversão **não é defeito**: na nota de cobertura, o participante do documento *referenciado* é do tipo oposto ao do principal. Logo `cIndFisJur` tem dois consumidores com semânticas opostas. Uma mudança na origem chega aos dois — e no invertido produz o resultado contrário. É por isso que a família `DHLSafx116` ficou de fora da alteração.

### E as expressões não eram todas iguais

`DHLSafx116.prw:269` tem derivação própria: para **entrada** devolve cliente sempre, enquanto o `DHLSafx07` devolve fornecedor numa compra normal. Divergem porque o 116 resolve o documento *referenciado*. Isso inviabilizava substituição em bloco.

## 5. O que foi executado em 18/11/2026

A correção foi feita **sem esperar a definição fiscal**, parametrizando a decisão:

1. ✅ **Decisão centralizada** em `DHLSafx:getIndFisJur(cType, cTipoDoc)` (declaração na linha 40, implementação na 289). Comportamento dos tipos clássicos **preservado**; `"5"` e `"6"` tratados por `ZZ_IFJCRE` e `ZZ_IFJDEB`, defaults `"2"`.
2. ✅ **26 expressões `Iif` substituídas** por chamada ao método, em **25 fontes**, preservando o acessor de `F3_TIPO` de cada um. Resolve também o `Iif` encadeado (CA4000). Duas ocorrências restantes já estavam comentadas.
3. ✅ **Tipo de movimento:** ramo `f3_tipo in ('5','6')` acrescentado ao `case when` em **7 fontes**, com valor em `ZZ_SFXMOVR`, default `SAFX_MOVIMENTO_NORMAL` — sem mudança de comportamento até o leiaute definir.
4. ⏸ **Ramos do `UNION` não alterados** nos 5 fontes de query. Mudar um `WHERE` de `UNION` redistribui documentos entre ramos, e cada ramo tem conjunto próprio de colunas: é alteração de query, não de expressão. A nota de crédito continua casando `a2_cod = f3_cliefor` sobre código de cliente.
5. ⏸ **Família `DHLSafx116` não alterada**, pelo motivo da §4.
6. ⏸ **Testar** com os cenários 3, 7 e 8 (crédito) e 11 (débito 07) do `Inventario_Tags_NFe_2027.md`.

### Observação registrada, não confirmada

Em `DHLSafx07.prw:225` e equivalentes, `::addField(IND_COMPRA_VENDA, Iif((csf3_)->TIPO =="N","VD", Iif((csf3_)->TIPO $ "CPI","CP","")))` lê a coluna `TIPO`, que é a **calculada** pelo `case when` e vale `"1"`/`"2"` — nunca `"N"` nem `"C"`/`"P"`/`"I"`. O campo sairia sempre vazio. A query também expõe `f3_tipo` (cru), que seria o acessor correto. Exige rodar a query para descartar outra coluna `TIPO`.
