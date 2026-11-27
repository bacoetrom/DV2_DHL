---
goal: Concluir e colocar em operação a interface Mastersaf DW da Reforma Tributária (SAFX3007/SAFX3008) e decidir, fonte por fonte, o que muda nas interfaces legadas SAFX07/08/112/116/2013
version: 1.0
date_created: 2026-11-27
last_updated: 2026-11-27
owner: DHL - Equipe Protheus / Fiscal (DV2) — Pablo Regis
status: 'Planned'
tags: [plano, fiscal, reforma-tributaria, ibs-cbs, is, mastersaf-dw, safx3007, safx3008, cfgtrib]
escopo_fontes: [SAFX3007MSDW, SAFX3008MSDW, DHLSafx3007, DHLSafx3008, ProcMsaDW, DHLSafx07, DHLSafx08, DHLSafx112, DHLSafx116, DHLSafx2013]
planos_relacionados:
  - plan/Plano_Execucao_NFe_2027_IBS_CBS.md
  - plan/upgrade-mastersaf-dw-safx07-ibs-cbs-1.md
  - plan/impacto-fontes-mastersaf-dw-safx07-1.md
  - plan/Triagem_cIndFisJur_SAFX.md
  - plan/Leiaute_Mastersaf_4_19.md
---

# Plano — SAFX3007/SAFX3008 e as interfaces legadas do Mastersaf DW

![Status: Planned](https://img.shields.io/badge/status-Planned-blue)

Plano de escopo fechado nos **10 fontes indicados**. Não repete o que os planos anteriores já cobrem: a classificação de impacto das 7 variantes por unidade de negócio está em [impacto-fontes-mastersaf-dw-safx07-1.md](impacto-fontes-mastersaf-dw-safx07-1.md), a estratégia geral em [upgrade-mastersaf-dw-safx07-ibs-cbs-1.md](upgrade-mastersaf-dw-safx07-ibs-cbs-1.md) e o cronograma macro na Fase 6 do [Plano_Execucao_NFe_2027_IBS_CBS.md](Plano_Execucao_NFe_2027_IBS_CBS.md).

**O que mudou desde aqueles planos:** a Entrega 7 da Fase 6 foi **parcialmente executada** em 23/11/2026 (commit `584aa0d`, 2.000 linhas novas). Os itens 1 e 2 da Fase 6 estão feitos; os itens 3 e 4 não. Este plano parte desse ponto.

---

## 1. Situação atual — o que existe hoje, por fonte

Leitura direta dos fontes em 27/11/2026, branch `pgr_mastersaf_scj`.

| # | Fonte | Linhas | Estado | Trata IBS/CBS/IS? |
|---|---|---|---|---|
| 1 | [SAFX3007/SAFX3007MSDW.prw](../PROTHEUS/Producao/Mastersaf_DW/SAFX3007/SAFX3007MSDW.prw) | 647 | **Novo, nunca compilado nem executado** | ✅ sim — driver completo |
| 2 | [SAFX3007/DHLSafx3007.prw](../PROTHEUS/Producao/Mastersaf_DW/SAFX3007/DHLSafx3007.prw) | 357 | **Novo, nunca compilado** | ✅ sim — 16 posições de tributo + 2 totalizadores |
| 3 | [SAFX3008/SAFX3008MSDW.prw](../PROTHEUS/Producao/Mastersaf_DW/SAFX3008/SAFX3008MSDW.prw) | 116 | **Novo, nunca compilado** | ✅ sim — laço de itens |
| 4 | [SAFX3008/DHLSafx3008.prw](../PROTHEUS/Producao/Mastersaf_DW/SAFX3008/DHLSafx3008.prw) | 263 | **Novo, nunca compilado** | ✅ sim — 16 posições de tributo + `cClassTrib` |
| 5 | [ProcMsaDW.prw](../PROTHEUS/Producao/Mastersaf_DW/ProcMsaDW.prw) | 378 | **Intocado** — 13 interfaces, nenhuma é a 3007/3008 | ❌ não |
| 6 | [SAFX07/DHLSafx07.prw](../PROTHEUS/Producao/Mastersaf_DW/SAFX07/DHLSafx07.prw) | 524 | Só os ajustes da Fase 0.5 (participante e tipo de movimento) | ❌ não |
| 7 | [SAFX07/DHLSafx08.prw](../PROTHEUS/Producao/Mastersaf_DW/SAFX07/DHLSafx08.prw) | 952 | Idem | ❌ não |
| 8 | [SAFX07/DHLSafx112.prw](../PROTHEUS/Producao/Mastersaf_DW/SAFX07/DHLSafx112.prw) | 267 | Idem | ❌ não (layout sem campo de valor) |
| 9 | [SAFX07/DHLSafx116.prw](../PROTHEUS/Producao/Mastersaf_DW/SAFX07/DHLSafx116.prw) | 349 | Idem | ❌ não (layout sem campo de valor) |
| 10 | [SAFX2013/DHLSafx2013.prw](../PROTHEUS/Producao/Mastersaf_DW/SAFX2013/DHLSafx2013.prw) | 196 | **Intocado** | ❌ não |

### Infraestrutura criada junto (fora da lista dos 10, mas inseparável)

| Fonte | Linhas | Papel |
|---|---|---|
| [DHLSafxRtc.prw](../PROTHEUS/Producao/Mastersaf_DW/DHLSafxRtc.prw) | 276 | Lê F2D + CJ3 e devolve os tributos pré-agregados por item (`F2D_IDREL` = `FT_IDTRIB`) em **uma** tabela derivada, consumida por um único `LEFT JOIN`. Evita o N+1 por item |
| [Includes/safx3007.ch](../PROTHEUS/Includes/safx3007.ch) | 159 | Leiaute do cabeçalho — 64 posições (`SAFX3007_POSICOES`, L122) |
| [Includes/safx3008.ch](../PROTHEUS/Includes/safx3008.ch) | 122 | Leiaute do item — 59 posições (`SAFX3008_POSICOES`, L102) |
| [Includes/safxrtc.ch](../PROTHEUS/Includes/safxrtc.ch) | 53 | Nomes de coluna e parâmetros da camada RTC |

### Resumo em uma frase

> **A interface da Reforma existe e está escrita, mas é código morto.** Nada no workspace chama `U_SAFX3007MSDW()` — `grep -rn "SAFX3007" --include=*.prw` só devolve o próprio fonte e dois comentários no `DHLSafxRtc`. Além disso ela está travada por `ZZ_SFX3007` (default `.F.`, `SAFX3007MSDW.prw:80`) porque o leiaute é preliminar. As cinco interfaces legadas continuam **sem uma única menção** a IBS, CBS, IS, F2D ou `cClassTrib`.

---

## 2. Achados que o plano precisa resolver

Cada achado tem a evidência no fonte. Os quatro primeiros são **defeitos ou riscos de dado errado**; os demais são lacunas de integração.

### ACH-01 — `U_SAFX3007MSDW()` é inalcançável (bloqueia tudo)

[ProcMsaDW.prw](../PROTHEUS/Producao/Mastersaf_DW/ProcMsaDW.prw) tem 13 interfaces, fixadas pelos `#define S04..S235` de [safx.ch:2-14](../PROTHEUS/Includes/safx.ch). O array montado em `ProcMsaDW.prw:137-149` tem 13 posições e `validMarks()` (L362) percorre `Len(aValue)`. Não existe `S3007`, não existe checkbox, não existe ramo em `confirmar()`. É também o **único** ponto de entrada do workspace: `grep -rln "U_SAFX07MSDW"` devolve apenas este fonte.

**Consequência:** a interface não pode ser testada nem agendada. É o item 3 da Fase 6 do plano macro, ainda aberto.

### ACH-02 — Imposto Seletivo com parâmetro vazio pode capturar F2D alheia

`DHLSafxRtc.prw:76` resolve `::cTribIS := AllTrim(GetNewPar("ZZ_TRIBSEL", ""))` — default **vazio**, de propósito, porque o código do tributo do IS não está confirmado. Mas o `CASE` é montado sem guarda (`DHLSafxRtc.prw:151-154`):

```sql
SUM(CASE WHEN RTCX.TRIB = '' THEN RTCX.BASE ELSE 0 END) RTCBASIS
```

Com o parâmetro vazio a comparação deixa de ser "nenhum registro" e passa a ser "todo registro da F2D com `F2D_TRIB` em branco". Se existir qualquer linha nessa condição, ela entra como **Imposto Seletivo**. O comentário do construtor afirma o contrário ("os campos de IS saem zerados, nunca estimados"); o SQL não garante isso.

**Correção:** quando `hasTribIS()` for falso, emitir literal `0` / `' '` nas quatro colunas de IS em vez do `CASE`. O método `hasTribIS()` já existe (L230) e hoje só é usado no log.

### ACH-03 — A alíquota do cabeçalho pode mentir sobre a nota

`totRtc()` (`SAFX3007MSDW.prw:299-386`) soma bases e valores, e para **alíquota** aplica a regra "vale a do primeiro item com valor" (L356-361):

```advpl
if aTot[nPos,1] == 0
    aTot[nPos,1] := oSqlIten:getValue(aAlq[nI])
endIf
```

Para CST e `cClassTrib` o mesmo laço **detecta divergência e zera o campo** (L368-379), com a justificativa correta registrada no cabeçalho do método. Para alíquota essa detecção não existe. Numa nota com itens de alíquotas diferentes — cenário normal com CST distintos, crédito presumido ou redução — o cabeçalho afirma a alíquota do primeiro item como se fosse a do documento.

**Correção:** aplicar a mesma regra do CST (divergência → zera) **ou** exportar a alíquota efetiva (`valor / base`, com guarda de divisão por zero). A escolha é fiscal; o código deve ser parametrizável.

### ACH-04 — 18 posições de valor saem zeradas por falta de dicionário (PEND-01)

`DHLSafx3007:notFieldRequired()` (L343-351) e `DHLSafx3008:notFieldRequired()` (L246-254) gravam `0` em 9 posições cada: redução de base, diferimento e crédito presumido de IBS-UF, IBS-Mun e CBS. A justificativa está no próprio fonte: os campos correspondentes da F2D não estão confirmados no dicionário — só `F2D_BASE`, `F2D_ALIQ`, `F2D_VALOR`, `F2D_TRIB`, `F2D_IDREL`, `F2D_TABELA`, `F2D_DTEXCL` e `F2D_ID` estão em uso no projeto.

Crédito presumido e redução de base **não são acessórios na Reforma** — são o que sustenta o crédito. Zero aqui é perda de crédito silenciosa.

### ACH-05 — `cClassTrib` sai em branco em 100% dos itens (bloqueio de dado)

`DHLSafxRtc.prw:81-87` só aceita o campo da CJ3 se `ZZ_SFXCCLT` apontar um campo que exista no SX3 e comece por `CJ3_` (whitelist pelo dicionário — correto, atende CA2050). O default é vazio, então `hasClassTrib()` é falso e a coluna vira o literal `' '` (L134). O destino é `F3008_COD_CLASS_TRIB` (posição 28 do leiaute) e `F3007_COD_CLASS_TRIB` (posição 62).

`cClassTrib` é o código que determina o regime de IBS/CBS do item. **Sem ele a 3008 não escritura.** Resolver é levantamento de dicionário, não programação.

### ACH-06 — Chave do documento referenciado não é integrada (PEND-02)

A 3007 e a 3008 gravam `' '` em `CHAVE_DOCFIS_REF` (`DHLSafx3007.prw:340`, `DHLSafx3008.prw:257`) porque a SF3 não guarda a chave do referenciado e a SFT só tem número, série e item de origem.

Mas o projeto **já resolve isso**: `DHLSafx116:getChvRef()` é chamado em `DHLSafx116.prw:130-134` e alimenta `NUM_AUTENTIC_NFE` (L190). A integração não é pesquisa, é reuso — e é exatamente o que torna rastreável o crédito de IBS/CBS em devolução, crédito 06 e débito 03/04.

### ACH-07 — As 5 interfaces legadas: decisão pendente, não código pendente

`DHLSafx07` e `DHLSafx08` deixam `DSC_RESERVADO1..8` em branco (`DHLSafx07.prw:420-429`, `DHLSafx08.prw:565-573`) e os leiautes estão congelados em 285 e 259 posições. `DHLSafx112` (15 posições) e `DHLSafx116` (21 posições) não têm campo de valor. `DHLSafx2013` exporta NCM, CEST, PIS e COFINS, e nada da Reforma.

O que falta aqui é a **decisão CON-001** do plano de upgrade: o DW legado continua em 2027 ao lado da 3007/3008, ou é substituído? As duas respostas geram trabalho diferente, e nenhuma linha de código deve ser escrita antes dela.

### ACH-08 — Desempenho não medido

Por documento, a 3007 executa: 1 `isCutover()` (`DHLSafx.prw:1218`, uma query), 1 cursor de itens com a tabela derivada da F2D embutida (`SAFX3007MSDW.prw:583-647`), e a 3008 reaproveita esse mesmo cursor (acerto de desenho). São **~2 queries por documento**, contra as ~2 da SAFX07 — mas a da 3007 carrega um `IN (SELECT ... SFT)` e dois níveis de agregação sobre a F2D. Nunca rodou com volume de produção.

### ACH-09 — Variantes por unidade de negócio: decisão de arquitetura

A 3007/3008 existe **só no Default**. A SAFX07 tem 7 variantes (AG2, AGE, AGL, DIS, MUL, DI2, REP) com até 7 cópias da mesma função — o multiplicador de esforço medido em [impacto-fontes-mastersaf-dw-safx07-1.md §11](impacto-fontes-mastersaf-dw-safx07-1.md). O `ProcMsaDW` roteia por `FWUnitBusiness()` (L188-220).

A 3007 foi escrita sem dependência de unidade: lê SF3/SFT genéricas e o diretório de saída já é tratado em `MsafDWFile:newMsafDWFile()` (L68-72). **Recomendação: interface única, sem clone-and-own**, com o que divergir resolvido por parâmetro. Repetir o padrão das 7 variantes multiplicaria por 7 cada um dos achados acima.

---

## 3. Bloqueios — o que não depende de nós

| ID | Bloqueio | Trava | Dono |
|---|---|---|---|
| **BLQ-01** | **Manual oficial da SAFX3007/SAFX3008** não recebido da Thomson Reuters. Os dois includes são derivados da semântica da SAFX07/08, declarados preliminares no próprio cabeçalho (`safx3007.ch:5-27`). Ordem, tamanho, decimais e obrigatoriedade são suposição | Etapas 4 a 7 | Fornecedor — PREMISSA-02 do plano macro |
| **BLQ-02** | Campo da **CJ3** que guarda o `cClassTrib` (ACH-05) | Etapa 2 | Dicionário / TOTVS |
| **BLQ-03** | Campos da **F2D** para redução, diferimento e crédito presumido (ACH-04) | Etapa 2 | Dicionário / TOTVS |
| **BLQ-04** | Código do tributo do **Imposto Seletivo** na F2D (ACH-02) | Etapa 2 | Área fiscal / Configurador |
| **BLQ-05** | **CON-001** — o Mastersaf DW legado continua em 2027? (ACH-07) | Etapa 6 | Área fiscal + fornecedor |
| **BLQ-06** | Questão fiscal **16** — como escriturar crédito e débito no DW (`ZZ_SFXMOVR`). Depende do leiaute | Etapa 4 | Área fiscal (depende de BLQ-01) |

**O que não está bloqueado:** as Etapas 1, 2 e 3 inteiras. O trabalho mais caro — tornar a interface alcançável, compilável e medida — não depende de nenhum terceiro.

---

## 4. Etapas

Convenção de marcação: a da Fase 4 do plano macro — `// INICIO Pablo Regis DD/MM/AAAA` / `// FIM Pablo Regis DD/MM/AAAA`, sem acento, fonte em CP-1252 com CRLF. Função ou método novo não usa marcador inline: a autoria vai no bloco `/*/{Protheus.doc}`.

### Etapa 1 — Tornar a interface alcançável e compilável (não bloqueada)

Fecha ACH-01 e o item 3 da Fase 6 do plano macro.

1. **`safx.ch`** — acrescentar `#define S3007 14` após `S235`. É o único include compartilhado alterado; não muda posição de nenhum define existente.
2. **`ProcMsaDW.prw`** — replicar o padrão do SAFX07, que é o mais próximo (checkbox + combo de tipo + duas datas):
   - `local lCheck14 := .f.` e `local dDtDe3007 := dDtAte3007 := stod("")` no bloco de `Local` (L42-44) — **todos os `Local` antes de qualquer linha executável**, como exige o padrão do projeto;
   - `local bSAFX3007 := {|| {'SAFX3007',{lCheck14,nCombo3007,dDtDe3007,dDtAte3007}} }` junto aos demais (L46-58);
   - checkbox, combo e gets no diálogo, com a linha separadora, após o bloco do SAFX235 (L129-135);
   - `eval(bSAFX3007)` no array do botão Confirmar (L137-149);
   - ramo em `confirmar()`: `if aValue[S3007,1] == "SAFX3007" .and. aValue[S3007,2,1]` chamando `U_SAFX3007MSDW(nil, nType, dDtFrom, dDtUntil)`.
3. **Roteamento por unidade de negócio** — conforme ACH-09, **não** criar variantes: chamada única. Registrar a decisão em comentário no ramo, para que não seja "corrigida" depois por simetria com o SAFX07.
4. **Rótulo do checkbox** deixando explícito que é a interface da Reforma e que depende de `ZZ_SFX3007`, para que ninguém marque a caixa esperando arquivo.
5. **Cadastrar os parâmetros** (SX6), todos com default igual ao comportamento atual:

| Parâmetro | Tipo | Default | Decide |
|---|---|---|---|
| `ZZ_SFX3007` | lógico | `.F.` | libera a geração (trava do leiaute preliminar) |
| `ZZ_SFX3DAT` | caractere | `"1"` | data de competência: `"1"` `F3_ENTRADA`, `"2"` `F3_EMISSAO` |
| `ZZ_TRIBSEL` | caractere | `""` | código do tributo do IS na F2D |
| `ZZ_SFXCCLT` | caractere | `""` | campo da CJ3 com o `cClassTrib` |

   `ZZ_TRIBSUF`, `ZZ_TRIBSMU` e `ZZ_TRIBCBS` já existem no projeto (usados pelo `DHLIdManager.prw`); apenas conferir o conteúdo.

6. **Compilar na ordem obrigatória** — a classe base vai primeiro, senão o erro aparece só em runtime, na geração:

```
1. Mastersaf_DW/DHLSafx.prw          (classe base)
2. Mastersaf_DW/DHLSafxRtc.prw       (fonte novo, herdado por ninguem mas usado pelos dois drivers)
3. SAFX3007/DHLSafx3007.prw
4. SAFX3008/DHLSafx3008.prw
5. SAFX3008/SAFX3008MSDW.prw         (antes do 3007: o 3007 chama U_SAFX3008MSDW)
6. SAFX3007/SAFX3007MSDW.prw
7. Mastersaf_DW/ProcMsaDW.prw
```

**Critério de saída:** os 4 fontes novos no RPO, a opção visível no menu, e a execução com `ZZ_SFX3007 = .F.` registrando em log o motivo de não gerar — sem erro e sem arquivo. É o primeiro teste real de que o código compila e roda.

### Etapa 2 — Fechar as lacunas de dicionário (não bloqueada; destrava BLQ-02/03/04)

Levantamento, não programação. Entregável: uma tabela de "campo da F2D/CJ3 → posição do leiaute".

1. **F2D** — rodar e anexar ao plano:

```sql
SELECT X3_CAMPO, X3_TIPO, X3_TAMANHO, X3_DECIMAL, X3_TITULO
  FROM SX3010 WHERE D_E_L_E_T_ = ' ' AND X3_ARQUIVO = 'F2D'
 ORDER BY X3_ORDEM;
```

   A consulta já está registrada em `DHLSafx3007:notFieldRequired()` — executá-la e cruzar com as 9 posições zeradas de cada arquivo (ACH-04).
2. **CJ3** — mesma consulta com `X3_ARQUIVO = 'CJ3'`, para identificar o campo do `cClassTrib` (ACH-05) e confirmar que `CJ3_CST` e `CJ3_IDF2D` são os nomes corretos usados em `DHLSafxRtc.prw:132` e `:161-162`.
3. **Código do tributo do IS** — `SELECT DISTINCT F2D_TRIB FROM <F2D> WHERE D_E_L_E_T_ = ' '` em ambiente com apuração da Reforma, cruzado com o cadastro de tributos do Configurador. Confirma ou descarta `ZZ_TRIBSEL` (ACH-02).
4. **Verificar se existe F2D com `F2D_TRIB` em branco** — é o que determina a gravidade real do ACH-02.
5. **Conferir a ligação** `F2D_IDREL = FT_IDTRIB` com uma nota real já apurada, e o `F2D_TABELA` `'SD1'`/`'SD2'` por sentido (`DHLSafxRtc.prw:125-129`). A documentação do fonte cita `plan/ERBFIS01.prw` e `DHLIdManager.prw` como referência — validar contra dado, não contra fonte.

**Critério de saída:** cada uma das 18 posições zeradas do ACH-04 com destino definido ou com justificativa de inexistência; `ZZ_SFXCCLT` e `ZZ_TRIBSEL` preenchidos ou formalmente declarados inexistentes.

### Etapa 3 — Correções de robustez no código novo (não bloqueada)

Independem do leiaute: mexem em **como** o valor é obtido, não em onde ele é gravado.

1. **ACH-02** — guarda do IS: em `DHLSafxRtc:qryTribItens()`, quando `!::hasTribIS()`, emitir `0` e `' '` literais nas 4 colunas de IS em vez do `CASE WHEN TRIB = ''`. Mesmo tratamento já aplicado ao `cClassTrib` em L131-136 — é consistência interna, não invenção.
2. **ACH-03** — alíquota do cabeçalho: aplicar em `totRtc()` a detecção de divergência que o laço de CST já faz, e registrar em log quando ocorrer. Atualizar o comentário do método, que hoje descreve comportamento diferente do implementado.
3. **Limpeza** — `TOT_COL_CONT` é totalizado em `totRtc()` (L324) e nunca consumido: `VLR_TOT_NOTA` vem de `::getCab("F3_VALCONT")` (`DHLSafx3007.prw:268`). Remover a coluna ou usá-la; manter as duas origens para o mesmo conceito é divergência de conciliação esperando para acontecer.
4. **Conferir `ZZ_TXTINUT`** — `ramoCab()` filtra `F3_OBSERV <> '<ZZ_TXTINUT>'` (L555). Com o parâmetro **vazio** o filtro passa a eliminar todo documento sem observação. É comportamento **herdado** da SAFX07 (`SAFX07MSDW.prw:344`, `:456`, `:575`, `:687`), portanto não é regressão nova — mas a 3007 não pode nascer com ele. Validar o conteúdo do parâmetro e, se vazio, condicionar o filtro.
5. **Data de escrituração** — `ctxCab()` repassa `F3_ENTRADA` como `DTESCRIT` nos dois sentidos (`SAFX3007MSDW.prw:275`), enquanto `DHLSafx116:addLine()` usa `Iif(cType == "1", F3_ENTRADA, F3_EMISSAO)` (L152). Uma das duas está errada para a saída. Conciliar antes de gerar arquivo comparável.
6. **ACH-08** — medir: `EXPLAIN PLAN` do cursor de itens e cronometragem de um mês fechado de faturamento da unidade de maior volume. Se a tabela derivada por documento não escalar, a alternativa é materializá-la uma vez por período em `FWTemporaryTable` (`MSCREATE`/`DBCREATE`/`CRIATRAB` são proibidos — CA1000).
7. **Revisão SonarQube dos 4 fontes novos** — eles nunca passaram por revisão. Conferir em especial `IIF` (CA4000), `ConOut` (CA1004 — os fontes usam `FWLogMsg`, confirmar que não há exceção), UI dentro de transação (CA1002 — não há transação, confirmar) e concatenação de SQL (CA2050 — `ChangeQuery()` é usado em `qryCab` L487 e `openIten` L645; a whitelist de `ZZ_SFXCCLT` em `DHLSafxRtc.prw:83` é o padrão a seguir nos demais pontos).

**Critério de saída:** os 4 fontes novos revisados, sem violação CRITICAL/MAJOR, com o tempo de geração medido e registrado.

### Etapa 4 — Aplicar o leiaute oficial (bloqueada em BLQ-01)

Ao receber o manual da Thomson Reuters:

1. **Ajustar somente os includes.** `safx3007.ch` e `safx3008.ch` são a única fonte de verdade de posição, tamanho e decimal; `DHLSafx3007` e `DHLSafx3008` referenciam tudo por nome de `#define`, nunca por literal. Essa foi a decisão de desenho que torna esta etapa curta — preservá-la.
2. Conferir campo a campo contra `VLD_3007_FIELD` (`safx3007.ch:132`) e `VLD_3008_FIELD` (`safx3008.ch:110`). Atenção à regra registrada no include: **campo de valor não entra na lista de obrigatórios**, porque `MsafDWFile:formatValue()` converte zero em `"@"` (L200-206) e `validRequired()` (`DHLSafx.prw:780`) trataria o zero legítimo como ausência.
3. Atualizar `SAFX3007_POSICOES` e `SAFX3008_POSICOES` — `MsafDWFile:write()` (L148) recusa a linha quando a contagem divergir, e o driver registra `ERROR_QTD_CAMPOS`. A trava é boa: um leiaute errado falha alto, não silencioso.
4. Decidir `ZZ_SFXMOVR` (BLQ-06, questão fiscal 16) e aplicar em `tpMovtoFiscal()` — já parametrizado em `DHLSafx.prw:1446`, sem recompilar.
5. **Só então** ligar `ZZ_SFX3007`.

### Etapa 5 — Integrar a chave do documento referenciado (bloqueada em BLQ-01)

Fecha ACH-06/PEND-02.

1. Expor `getChvRef()` de forma reutilizável — hoje é método de `DHLSafx116` com semântica própria de participante (o indicador é **deliberadamente invertido** em `DHLSafx116.prw:138`, porque o participante do referenciado é do tipo oposto). **Não** replicar essa inversão por engano na 3007/3008: lá o participante é o do documento, não o do referenciado.
2. Alimentar `F3007_CHAVE_DOCFIS_REF` e `F3008_CHAVE_DOCFIS_REF` a partir de `FT_NFORI` + `FT_SERORI` + `FT_ITEMORI`, que a 3008 já exporta (L208-210).
3. Validar nos cenários que exigem referência: devolução, crédito 06, débito 03 e débito 04 (ver [Inventario_Tags_NFe_2027.md §6](Inventario_Tags_NFe_2027.md)).
4. **Risco a confirmar:** a questão aberta 7 de [Questoes_Fiscais_NFe_2027.md](Questoes_Fiscais_NFe_2027.md) registra que a nota de crédito vem do **SIGACOM**, não do Faturamento. Se `D1_NFORI`/`FT_NFORI` não vierem preenchidos nesses documentos, não há de onde tirar a referência — e isso é levantamento de dado, não programação.

### Etapa 6 — Decidir e tratar as 5 interfaces legadas (bloqueada em BLQ-05)

Fecha ACH-07 e o item 4 da Fase 6 do plano macro. **Avaliação antes de código.** Recomendação técnica por fonte:

| Fonte | Recomendação | Por quê |
|---|---|---|
| `DHLSafx07` / `DHLSafx08` | **Não estender o leiaute.** A Reforma vai pela 3007/3008 | Os leiautes têm 285 e 259 posições congeladas e só 8 reservados de texto cada. Enfiar valor de tributo em campo reservado de texto é dívida garantida — e replicável por 7 variantes |
| `DHLSafx07` / `DHLSafx08` | **Mas conferir a conciliação.** Item obrigatório, independente de BLQ-05 | [Leiaute_Mastersaf_4_19.md §5](Leiaute_Mastersaf_4_19.md) registra que **a partir de 2027 IBS, CBS e IS compõem o `vProd`**. Se `FT_TOTAL` passar a incluí-los, `VLR_PRODUTO` da SAFX07 muda de significado sem uma linha de código alterada — e a 3007 soma o mesmo `FT_TOTAL` (`SAFX3007MSDW.prw:324`). Validar se o tributo é contado uma vez ou duas |
| `DHLSafx112` | **Provavelmente sem alteração** | Layout de 15 posições, zero campo de valor. A observação vem do cadastro ZZ9 via `getCodTypeMsg()` (`DHLSafx.prw:931`). Se a Reforma exigir código de observação para ajuste de competência ou estorno de crédito, é **cadastro** (SAFX2009/ZZ9), não código |
| `DHLSafx116` | **Alteração provável, baixa** | É quem sustenta a rastreabilidade do crédito em devolução. Revisar `COD_MODELO_REF`, fixo em `'55'` (L189), e confirmar que `getTypeDoc()` (L53) classifica corretamente os tipos `5` e `6` — hoje a família só conhece `'C'` complementar (L113) e `D`/`B` |
| `DHLSafx2013` | **Alteração provável, a dimensionar** | Produto. A Reforma pede `cClassTrib` por produto, NBS para serviço e indicador de sujeição ao IS. Hoje exporta NCM, CEST, PIS e COFINS (L61-71). Depende do leiaute Tax One do cadastro de produtos — **outro** manual, não o da 3007 |

**Critério de saída:** decisão CON-001 registrada e, para cada um dos 5 fontes, "altera" ou "não altera" com justificativa. Nada de "provavelmente" na saída desta etapa.

### Etapa 7 — Testes e homologação (bloqueada em BLQ-01)

1. **Massa:** os 7 tipos confirmados pela planilha de TAGS — crédito **01, 03, 04** e débito **02, 03, 04, 06** ([Inventario_Tags_NFe_2027.md](Inventario_Tags_NFe_2027.md), correção de 22/11/2026) — mais venda, complementar, ajuste e devolução. Crédito 01 e débito 02 **não têm exemplo de XML**; exigem massa própria.
2. **Conciliação obrigatória, por documento:**
   - `VLR_PRODUTO` do SAFX3007 × soma de `VLR_ITEM` da SAFX3008;
   - `VLR_TOT_IBS` = `VLR_IBS_UF` + `VLR_IBS_MUN`, e `VLR_TOT_TRIB_RTC` = IBS + CBS + IS (`DHLSafx3007.prw:202-203`);
   - total de cada tributo no cabeçalho × soma dos itens;
   - SAFX3007/3008 × SAFX07/08 para o **mesmo** documento — mesma quantidade de itens, mesmo valor de mercadoria.
3. **Casos de borda que o código trata explicitamente e precisam de teste dirigido:**
   - **documento cancelado** — permanece no livro com `SITUACAO = "S"` e o filtro `D_E_L_E_T_` é suspenso; a deduplicação por `MIN(R_E_C_N_O_)` (`SAFX3007MSDW.prw:629-641`) é o que impede linha dobrada. É o caminho mais frágil do fonte;
   - **documento sem item na SFT** — rejeita e loga (L148-155);
   - **inventário e cutover** — excluídos (L137-142), mesma regra da SAFX07;
   - **itens com alíquotas divergentes** — valida o ACH-03;
   - **item sem tributo da Reforma** — o `COALESCE` de `colTribSelect()` (L213) deve dar `0`, não `"@"`.
4. **Regressão:** gerar SAFX07/08/112/116/2013 antes e depois, e comparar byte a byte. A Etapa 1 altera `safx.ch`/`ProcMsaDW` e a Etapa 3 altera `DHLSafxRtc` — nenhuma deveria mudar o arquivo legado. Se mudar, é defeito.
5. **Arquivo de trabalho:** confirmar que `fechaArq()` (L235-251) descarta o `.processing` quando não houve registro e só publica o `.txt` no final.

---

## 5. Ordem e dependências

```
Etapa 1 (alcançável + compila)  ──┐
Etapa 2 (dicionário)            ──┼──► Etapa 3 (robustez)  ──► Etapa 7 (testes)
                                  │                              ▲
BLQ-01 manual do fornecedor ──► Etapa 4 (leiaute) ──► Etapa 5 ───┘
BLQ-05 decisão CON-001      ──► Etapa 6
```

As Etapas 1, 2 e 3 correm **em paralelo e já**. As Etapas 4, 5 e 7 não começam sem o manual. A Etapa 6 é independente das outras e depende só da decisão fiscal.

---

## 6. Arquivos

### Alterados nas etapas não bloqueadas

| Arquivo | Etapa | O que muda |
|---|---|---|
| `PROTHEUS/Includes/safx.ch` | 1 | `#define S3007 14` |
| `PROTHEUS/Producao/Mastersaf_DW/ProcMsaDW.prw` | 1 | Checkbox, combo, datas, codeblock e ramo em `confirmar()` |
| `PROTHEUS/Producao/Mastersaf_DW/DHLSafxRtc.prw` | 3 | Guarda do IS (ACH-02) |
| `PROTHEUS/Producao/Mastersaf_DW/SAFX3007/SAFX3007MSDW.prw` | 3 | Divergência de alíquota, `TOT_COL_CONT`, `ZZ_TXTINUT`, data de escrituração |

### Alterados nas etapas bloqueadas

| Arquivo | Etapa | Depende de |
|---|---|---|
| `PROTHEUS/Includes/safx3007.ch` | 4 | BLQ-01 |
| `PROTHEUS/Includes/safx3008.ch` | 4 | BLQ-01 |
| `SAFX3007/DHLSafx3007.prw` | 4, 5 | BLQ-01, BLQ-03 |
| `SAFX3008/DHLSafx3008.prw` | 4, 5 | BLQ-01, BLQ-02, BLQ-03 |
| `SAFX07/DHLSafx116.prw` | 5, 6 | BLQ-01, BLQ-05 |
| `SAFX07/DHLSafx07.prw`, `SAFX07/DHLSafx08.prw` | 6 | BLQ-05 |
| `SAFX07/DHLSafx112.prw` | 6 | BLQ-05 + decisão de cadastro ZZ9 |
| `SAFX2013/DHLSafx2013.prw` | 6 | BLQ-05 + leiaute Tax One do cadastro de produtos |

### Lidos e não alterados

`Mastersaf_DW/DHLSafx.prw` (classe base — `addField` L192, `validRequired` L771, `getFieldValue` L800, `isCutover` L1218, `tpMovtoFiscal` L1446), `Mastersaf_DW/MsafDWFile.prw` (`write` L141, `formatValue` L180), `Includes/safxrtc.ch`, `Includes/safx07.ch`, `Includes/safx08.ch`, `Includes/safx112.ch`, `Includes/safx116.ch`, `Includes/safx2013.ch`, `Includes/dhl.ch`.

> **Fora de escopo, de propósito:** as 7 variantes por unidade de negócio da SAFX07/08/112/116 (AG2, AGE, AGL, DIS, MUL, DI2, REP). Elas são a Entrega 8 e estão classificadas em [impacto-fontes-mastersaf-dw-safx07-1.md](impacto-fontes-mastersaf-dw-safx07-1.md). Pela recomendação do ACH-09, a 3007/3008 **não** deve ganhar variantes.

---

## 7. Verificação de completude — item a item

Rastreabilidade 1:1 com os 10 fontes indicados. Nada foi omitido.

| # | Fonte indicado | Onde é tratado | Situação |
|---|---|---|---|
| 1 | `SAFX3007` (`SAFX3007MSDW.prw`) | §1, ACH-01/03/08, Etapas 1, 3, 4, 7 | 🔄 escrito, inalcançável e travado — Etapa 1 o liga |
| 2 | `SAFX3008` (`SAFX3008MSDW.prw`) | §1, Etapas 1, 4, 7 | 🔄 escrito; é chamado pelo 3007 (L203), não pelo menu — correto |
| 3 | `DHLSafx3007` | §1, ACH-03/04/06, Etapas 3, 4, 5 | 🔄 escrito; 9 posições zeradas por BLQ-03 |
| 4 | `DHLSafx3008` | §1, ACH-04/05/06, Etapas 4, 5 | 🔄 escrito; `cClassTrib` em branco por BLQ-02 |
| 5 | `ProcMsaDW` | ACH-01, Etapa 1 | ⚠️ **intocado** — é o bloqueio nº 1 e não depende de terceiro |
| 6 | `DHLSafx07` | ACH-07, Etapa 6 | ⏸ decisão CON-001; conferência de conciliação do `vProd` é obrigatória de qualquer forma |
| 7 | `DHLSafx08` | ACH-07, Etapa 6 | ⏸ idem |
| 8 | `DHLSafx112` | ACH-07, Etapa 6 | ⏸ provável "sem alteração"; se mudar, é cadastro ZZ9 |
| 9 | `DHLSafx116` | ACH-06/07, Etapas 5, 6 | ⏸ alteração provável; `getChvRef()` é reusado pela Etapa 5 |
| 10 | `DHLSafx2013` | ACH-07, Etapa 6 | ⏸ depende de **outro** manual (cadastro de produtos Tax One) |

### Ampliações além da lista — e por quê

| Acréscimo | Justificativa |
|---|---|
| `safx.ch` | **Obrigatório.** Sem `S3007` o `ProcMsaDW` não tem índice para a nova interface |
| `DHLSafxRtc.prw` | **Obrigatório.** É onde vivem ACH-02 e ACH-05; os dois drivers dependem dele |
| `safx3007.ch` / `safx3008.ch` | **Obrigatório.** São o leiaute; a Etapa 4 altera só eles |
| `safxrtc.ch` | Nomes de coluna e parâmetros consumidos pelos 4 fontes em escopo |
| Parâmetros SX6 (`ZZ_SFX3007`, `ZZ_SFX3DAT`, `ZZ_TRIBSEL`, `ZZ_SFXCCLT`) | Não são fonte, mas sem eles a interface não roda nem com o código correto |

### O que este plano não cobre

- **A Entrega 8** (replicação nas 7 variantes) — e a recomendação é que não exista para a 3007/3008.
- **O remerge do fork `nfesefaz.prw`** — pacote de trabalho próprio, PRECONDIÇÃO da PREMISSA-01 do plano macro. A 3007/3008 lê da **F2D**, não do XML, então não depende dele.
- **A interface NF-e (`ProcMsaNFe`/`ProcRCOMsa`)** — Fases 1 e 2 do plano macro, já em execução.
- **O leiaute Tax One do cadastro de produtos** — insumo da Etapa 6 para o `DHLSafx2013`, ainda não solicitado ao fornecedor. **Ação imediata recomendada:** pedir junto com o manual da SAFX3007/3008, para não bloquear duas vezes.

---

## 8. Riscos

| ID | Risco | Impacto | Mitigação |
|---|---|---|---|
| RSC-01 | O leiaute oficial divergir muito dos includes preliminares | Retrabalho nos dois `.ch` e nas duas classes | O desenho já isola: campos por nome de `#define`, nunca por posição literal. `ZZ_SFX3007` impede que TXT preliminar chegue ao importador |
| RSC-02 | `cClassTrib` não existir na CJ3 | A 3008 não escritura | Etapa 2, item 2. Se não existir na CJ3, procurar no Configurador antes de concluir que não há |
| RSC-03 | Crédito presumido e redução de base sem campo na F2D | Perda de crédito silenciosa | Etapa 2, item 1. Zero explícito e logado é melhor que valor estimado — o código já faz isso |
| RSC-04 | Desempenho inviável no fechamento | Interface não roda em produção | Etapa 3, item 6. Alternativa já desenhada: `FWTemporaryTable` por período |
| RSC-05 | Nota cancelada duplicar item | Dobra o valor do documento no livro | Dedup por `MIN(R_E_C_N_O_)` já implementada; teste dirigido na Etapa 7, item 3 |
| RSC-06 | 3007/3008 e SAFX07/08 contarem o tributo duas vezes se `FT_TOTAL` passar a incluí-lo | Livro fiscal errado nas duas interfaces | Etapa 6, linha de conciliação do `vProd`. **Independe de CON-001** |
| RSC-07 | Alguém criar as 7 variantes "por simetria" | Multiplica por 7 todos os achados | Decisão registrada em comentário no `ProcMsaDW` (Etapa 1, item 3) e neste plano |
| RSC-08 | Perda de acentos por save em UTF-8 | Corrupção de literal em CP-1252 | Regra da Fase 0.5: fontes em Windows-1252 com CRLF, marcadores sem acento |

---

## 9. Pendências para a área fiscal — específicas destes fontes

Complementam as 18 questões de [Questoes_Fiscais_NFe_2027.md](Questoes_Fiscais_NFe_2027.md). As quatro primeiras são novas.

| # | Questão | Trava | Etapa |
|---|---|---|---|
| A | Qual o **código do tributo do Imposto Seletivo** no Configurador (`F2D_TRIB`)? | 🔴 Desenvolvimento | 2 |
| B | A **alíquota do cabeçalho** da SAFX3007, quando os itens divergem: em branco, zero, ou alíquota efetiva (valor/base)? | 🔴 Desenvolvimento | 3 |
| C | A **data de competência** da SAFX3007 é a de entrada ou a de emissão? (`ZZ_SFX3DAT`) | 🟡 Produção | 1 |
| D | A **SAFX3007/3008 substitui** a SAFX07/08 em 2027, ou as duas convivem? (CON-001) | 🔴 Desenvolvimento | 6 |
| 16 | Como escriturar **crédito e débito** no DW (`ZZ_SFXMOVR`) — já aberta, depende do leiaute | 🟡 Produção | 4 |
| 7 (atualiz.) | A **nota de crédito vem do SIGACOM**: o fluxo Mastersaf cobre esses documentos de entrada? | 🔴 Desenvolvimento | 5 |

---

## 10. Leitura relacionada

- [Plano_Execucao_NFe_2027_IBS_CBS.md](Plano_Execucao_NFe_2027_IBS_CBS.md) — plano macro; Fase 6 é o guarda-chuva deste documento
- [upgrade-mastersaf-dw-safx07-ibs-cbs-1.md](upgrade-mastersaf-dw-safx07-ibs-cbs-1.md) — estratégia das 7 variantes e origem do CON-001
- [impacto-fontes-mastersaf-dw-safx07-1.md](impacto-fontes-mastersaf-dw-safx07-1.md) — classificação de impacto dos 56 fontes da família
- [Triagem_cIndFisJur_SAFX.md](Triagem_cIndFisJur_SAFX.md) — por que a 3007 resolve o participante em AdvPL e não no `JOIN`
- [Leiaute_Mastersaf_4_19.md](Leiaute_Mastersaf_4_19.md) — §5, a regra de composição do `vProd` em 2027 (base do RSC-06)
- [Inventario_Tags_NFe_2027.md](Inventario_Tags_NFe_2027.md) — cenários e tags por tipo de nota, massa da Etapa 7
- [Questoes_Fiscais_NFe_2027.md](Questoes_Fiscais_NFe_2027.md) — as 18 questões abertas e a atualização de 22/11/2026
