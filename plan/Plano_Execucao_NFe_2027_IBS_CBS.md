# Plano de execução: NF-e 2027 (IBS/CBS/IS) nos fontes DHL

- **Data:** 18/11/2026
- **Escopo:** somente análise. Nenhum fonte foi alterado.
- **Entradas da análise:**
  - Planilha `Fontes DHL para Analise.csv`, com fontes, frentes, entregas e consultores.
  - `HTMLConsolidado.xml`, com 11 exemplos de NF-e 2027 baseados na NT 2025.002 v1.53 e na NT 2026.008 v1.01.
  - `Analise_IBS_CBS_IP040_PrcGrvRco.md` — pendências de IBS/CBS na interface IP040 e na desoneração ZFM.
  - `Analise_PrcGrvRco.md` — fluxo, restrições e comportamentos silenciosos do `PrcGrvRco.prw`.
  - `ERBFIS01.prw` — **apenas referência** do padrão de leitura de tributos (F2D × F2B × CJ3). Não é fonte do projeto e não é entregável.
- **Artefatos produzidos por este plano:**
  - `Inventario_Tags_NFe_2027.md` — tags exigidas pelos 11 cenários × tags já tratadas nos fontes (Fase 0, item 1).
  - `Dimensionamento_Forks_NFe_2027.md` — custo real de replicação do fork `ProcRCOMsa` e do remerge do `nfesefaz`.
  - `Triagem_cIndFisJur_SAFX.md` — triagem dos 28 fontes com `cIndFisJur` (Fase 6, item 3).
- **Raiz dos caminhos:** `Workspace_Protheus_Prd_20260707/PROTHEUS/Producao/`

> Os fontes estão gravados em Windows-1252 com CRLF. Qualquer ajuste futuro precisa manter essa codificação — a perda de acentos já ocorreu uma vez neste projeto. Ver as regras obrigatórias na **Fase 0.5**.

---

## 0. Premissas do plano

**PREMISSA-01 — O XML padrão da TOTVS estará pronto.** O plano parte do pressuposto de que o pacote TOTVS instalado na DHL gerará, via `XmlNfeSef`/NFESEFAZ, **todas** as tags da NT 2025.002 v1.53 e da NT 2026.008 v1.01: `vUnComLiq`, `vProdLiq`, `vProdLiqTot`, `IS`, `ISTot`, `DFeReferenciado`, `finNFe` 5 e 6, `tpNFDebito`, `tpNFCredito`, `cMunFGIBS`, `gAjusteCompet`, `gEstornoCred`, `gPagAntecipado` e `ICMSPrevistoPagtoAntecip`.

Consequências diretas:

1. **A disponibilidade das tags deixa de ser bloqueante.** As Fases 1 e 2 podem começar imediatamente, em paralelo com os demais itens da Fase 0. O trabalho da DHL é o **mapeamento** — caminho no XML TOTVS → posição no TXT do Mastersaf —, não a geração do dado.
2. **O código pode ser escrito antes da confirmação do pacote.** A leitura do XML passa por `retValueAttribute()` → `IpXmlObject:getNodeValue()`, que testa `Type(cNode) != "U"` antes de avaliar o nó (`PROTHEUS/Producao/LibAdvpl/IpXmlObject.prw:176-187`). Tag inexistente devolve `""` **sem erro**, e o TXT posicional mantém a estrutura. Grupos novos (`IS`, `gAjusteCompet`, `gEstornoCred`, `DFeReferenciado`) devem ser codificados com a guarda `fTypeVar(...) == "O"` já usada no fonte — ficam inertes enquanto a tag não existir e entram em operação no momento em que o pacote a entregar, sem nova alteração de código.
3. **O risco muda de natureza, não desaparece.** Antes era "não há de onde ler". Agora é **falha silenciosa**: a tag que não se materializar produz campo vazio no TXT, sem log e sem erro, até a rejeição na SEFAZ. Por isso a premissa é acompanhada do controle compensatório da Fase 0, item 1.

**PRECONDIÇÃO DA PREMISSA-01 — o `nfesefaz.prw` da DHL é um fork e precisa ser remergeado.** O `XmlNfeSef` **não é o fonte padrão da TOTVS**: é `PROTHEUS/Producao/Mastersaf_NFe/nfesefaz.prw`, 14.762 linhas, cópia customizada do fonte padrão, com ~39 marcadores `DHL_BUSINESSUNIT_*`/`FWUnitBusiness` e ~100 linhas datadas de customização. Hoje ele **não gera nenhum grupo de IBS/CBS** (zero ocorrências de `IBSCBS`, `gIBSUF`, `gCBS`), embora já conheça a reforma — é nele que vivem `MV_RTC55` e `lRefTribCo` (linhas 570 e 612).

Como o fonte customizado tem precedência sobre o padrão no RPO, **atualizar o pacote da TOTVS não faz as tags aparecerem**. A PREMISSA-01 só se concretiza após o remerge do fork contra a versão TOTVS que implementa as duas NTs, preservando os pontos de customização — com atenção especial aos dois `IsInCallStack("U_PrcGrvRco")`/`("U_PrcNfRco")` das linhas 3026 e 3488, que alteram o XML da unidade AG2 (ver `Analise_PrcGrvRco.md`, restrição 1).

Esse remerge é um **pacote de trabalho próprio**, não listado nas 54 fontes da planilha. Precisa de dono, estimativa e decisão sobre a estratégia (remerge do fork × redução da customização a pontos de entrada × adoção do padrão com overrides).

**PREMISSA-02 — Os leiautes de terceiros continuam bloqueantes.** A premissa acima **não** se estende ao Mastersaf. O leiaute posicional do TXT NF-e e o leiaute do Mastersaf DW (SAFX3007/SAFX3008) dependem do fornecedor, são independentes do pacote TOTVS e permanecem pré-requisitos bloqueantes (Fase 0, itens 2 e 3).

---

## 0.1 Parâmetros e ordem de compilação

### Parâmetros a cadastrar antes de testar

Todos foram criados com **default igual ao comportamento atual**, de modo que o cadastro não altera o que o sistema faz hoje. Existem para que as decisões pendentes sejam aplicadas **sem recompilar**.

| Parâmetro | Tipo | Default | Decide | Fonte |
|---|---|---|---|---|
| `ZZ_RTCAUDI` | lógico | `.T.` | liga/desliga a auditoria de tags | `DHLRtcTagAudit.tlpp` |
| `ZZ_TRIBIS` | caractere | `"IS"` | `codigo` do Imposto Seletivo na coleção `imposto[n]` | `ProcMsaNFe`, `ProcRCOMsa` |
| `ZZ_TRIBICM` | caractere | `"ICM"` | `codigo` do ICMS na coleção `imposto[n]` | `ProcMsaNFe`, `ProcRCOMsa` |
| `ZZ_IFJCRE` | caractere | `"2"` | participante da nota de **crédito** (`"1"` fornecedor, `"2"` cliente) | `DHLSafx` |
| `ZZ_IFJDEB` | caractere | `"2"` | participante da nota de **débito** | `DHLSafx` |
| `ZZ_SFXMOVR` | caractere | `"1"` | valor de `NORM_DEV` para crédito/débito no DW | 7 fontes `DHLSafx07*` |
| `ZZ_FINAJUS` | caractere | `DHL_BUSINESSUNIT_AG2` | unidades que podem emitir nota de ajuste (`finNFe = 3`) | `ProcMsaNFe`, `ProcRCOMsa` |

Os três últimos são os que a área fiscal precisa definir. Os dois do meio dependem da inspeção do XML em homologação.

### ⚠️ Ordem de compilação — obrigatória

**`Mastersaf_DW/DHLSafx.prw` precisa ser compilado ANTES dos 25 fontes que o herdam.** O método `getIndFisJur()` é novo na classe base; se ele não estiver no RPO, as 25 subclasses que passaram a chamá-lo falham em **runtime**, não em compilação — e o erro aparece só na geração do arquivo, por unidade de negócio.

Ordem recomendada:

1. `Mastersaf_DW/DHLSafx.prw` (classe base)
2. Os 25 fontes `DHLSafx*` alterados
3. `Mastersaf_NFe/DHLRtcTagAudit.tlpp` (fonte novo)
4. `Mastersaf_NFe/ProcMsaNFe.prw` e `SAP/ProcRCOMsa.prw` (chamam `U_DHLRtcTagAudit`)
5. `Validacao_dos_Impostos/DHLTaxes.prw` (independente)

O item 3 antes do 4 pelo mesmo motivo: `ProcMsaNFe` e `ProcRCOMsa` chamam `U_DHLRtcTagAudit()`, que só existe depois que o `.tlpp` entrar no RPO.

---

## 1. Inventário dos fontes da planilha

### 1.1 Entrega 1: OUTBOUND / NF-e (MasterSaf) e SAP SC Johnson (9 fontes)

| # | Fonte | Pasta | Linhas | Consultor |
|---|---|---|---|---|
| 1 | ProcMsaNFe.prw | Mastersaf_NFe | 5341 (a planilha diz 5375) | Pablo Regis |
| 2 | ImpMsaNfe.prw | Mastersaf_NFe | 2047 | Pablo |
| 3 | PrcXmlNfe.prw | Mastersaf_NFe | 183 | Pablo Regis |
| 4 | TagProcRef.tlpp | Mastersaf_NFe | 58 | Pablo |
| 5 | MsafNFeFile.prw | Mastersaf_NFe | 192 | Pablo |
| 6 | MsafNFeTag.prw | Mastersaf_NFe | 170 | Pablo |
| 7 | PrcGrvRco.prw | SAP/SCJ | 420 | Pablo Regis |
| 8 | PrcNfRco.prw | SAP/SCJ | 615 | Pablo |
| 9 | PrcNfRet.prw | SAP/SCJ | 675 | Pablo |

### 1.2 Entrega 7: Desenvolvimento SAFX (Pablo Regis), 6 fontes existentes

| # | Fonte | Pasta | Linhas |
|---|---|---|---|
| 10 | ProcMsaDW.prw | Mastersaf_DW | 378 |
| 11 | DHLSafx07.prw | Mastersaf_DW/SAFX07 | 523 |
| 12 | DHLSafx08.prw | Mastersaf_DW/SAFX07 | 952 |
| 13 | DHLSafx112.prw | Mastersaf_DW/SAFX07 | 267 |
| 14 | DHLSafx116.prw | Mastersaf_DW/SAFX07 | 349 |
| 15 | DHLSafx2013.prw | Mastersaf_DW/SAFX2013 | 196 |

Itens da planilha que **ainda não existem**: os includes SAFX3007 e SAFX3008, e os fontes DHLSafx3007 e DHLSafx3008. Não há nenhum arquivo nem referência a "3007" ou "3008" no workspace. Os includes `safx*.ch` usados pelo Mastersaf_DW também não estão no workspace.

### 1.3 Entrega 8: SAFX / MasterSaf_DW (39 fontes)

| # | Fonte | Pasta | Linhas |
|---|---|---|---|
| 16 | SAFX07MSDW.prw | SAFX07 (Default/PKG) | 949 |
| 17 | SAFX08MSDW.prw | SAFX07 (Default/PKG) | 184 |
| 18 | SAFX112MSDW.prw | SAFX07 (Default/PKG) | 47 |
| 19 | SAFX116MSDW.prw | SAFX07 (Default/PKG) | 66 |
| 20 | 07AG2SAFX.prw | SAFX07/AG2 | 979 |
| 21 | 08AG2SAFX.prw | SAFX07/AG2 | 224 |
| 22 | 112AG2SAFX.prw | SAFX07/AG2 | 48 |
| 23 | 116AG2SAFX.prw | SAFX07/AG2 | 67 |
| 24 | DHLSafx07Ag2.prw | SAFX07/AG2 | 689 |
| 25 | DHLSafx08Ag2.prw | SAFX07/AG2 | 985 |
| 26 | DHLSafx112Ag2.prw | SAFX07/AG2 | 260 |
| 27 | DHLSafx116Ag2.prw | SAFX07/AG2 | 349 |
| 28 | SAFX07AGL.prw | SAFX07/AGL | 886 |
| 29 | SAFX08AGL.prw | SAFX07/AGL | 251 |
| 30 | SAFX116AGL.prw | SAFX07/AGL | 70 |
| 31 | AGL112.prw | SAFX07/AGL | 39 |
| 32 | _AGL112.prw | SAFX07/AGL | 256 |
| 33 | DHLSafx07Agl.prw | SAFX07/AGL | 582 |
| 34 | DHLSafx08Agl.prw | SAFX07/AGL | 918 |
| 35 | DHLSafx116Agl.prw | SAFX07/AGL | 359 |
| 36 | Di2SAFX07MSDW.prw | SAFX07/DI2 | 736 |
| 37 | Di2DHLSafx07.prw | SAFX07/DI2 | 523 |
| 38 | 07SAFXMUL.prw | SAFX07/MUL | 167 |
| 39 | 08SAFXMUL.prw | SAFX07/MUL | 149 |
| 40 | 112SAFXMUL.prw | SAFX07/MUL | 48 |
| 41 | 116SAFXMUL.prw | SAFX07/MUL | 66 |
| 42 | DHLSafx07Mul.prw | SAFX07/MUL | 489 |
| 43 | DHLSafx08Mul.prw | SAFX07/MUL | 924 |
| 44 | DHLSafx112Mul.prw | SAFX07/MUL | 236 |
| 45 | DHLSafx116Mul.prw | SAFX07/MUL | 301 |
| 46 | DHLSafx52Mul.prw | SAFX07/MUL | 525 |
| 47 | SAFX07AGE.prw | SAFX07/AGE (usada pela REP) | 888 |
| 48 | SAFX08AGE.prw | SAFX07/AGE (usada pela REP) | 251 |
| 49 | SAFX112MSDW.prw | SAFX07/AGE (usada pela REP) | 47 |
| 50 | SAFX116AGE.prw | SAFX07/AGE (usada pela REP) | 69 |
| 51 | DHLSafx07Age.prw | SAFX07/AGE (usada pela REP) | 552 |
| 52 | DHLSafx08Age.prw | SAFX07/AGE (usada pela REP) | 917 |
| 53 | DHLSafx112Age.prw | SAFX07/AGE (usada pela REP) | 263 |
| 54 | DHLSafx116Age.prw | SAFX07/AGE (usada pela REP) | 352 |

### 1.4 Resumo da contagem

| Grupo | Quantidade |
|---|---|
| Entrega 1 | 9 |
| Entrega 7 (existentes) | 6 |
| Entrega 8 | 39 |
| **Total de fontes da planilha no workspace** | **54** |
| Ainda não existem (Entrega 7) | 4 |
| **Total com os que ainda não existem** | **58** |
| Fora da planilha: pasta SAFX07/DIS (8) e SAFX2013MSDW.prw (1) | 9 |
| **Total se a pasta DIS e o SAFX2013MSDW entrarem** | **63 existentes** |

### 1.5 Divergências entre a planilha e o workspace

1. **A pasta `SAFX07/DIS/` não está na planilha.** Ela tem 8 fontes: SAFX07DIS, SAFX08DIS, SAFX112DIS, SAFX116DIS, DHLSafx07Dis, DHLSafx08Dis, DHLSafx112Dis e DHLSafx116Dis.
2. **Consultor diferente para "SAFX07MSDW (PKG)".** A primeira tabela da planilha diz Pablo e a segunda diz Pablo Regis.
3. **O `SAFX2013MSDW.prw` não está na planilha.** Ele fica em `Mastersaf_DW/SAFX2013/`, ao lado do DHLSafx2013.
4. **Linhas do ProcMsaNFe.prw.** A planilha diz 5375 e o arquivo tem 5341.
5. **REP não tem pasta própria.** A REP reusa a geração da AGE.
6. **AGL não tem `DHLSafx112Agl`.** O SAFX112 dessa pasta fica em `AGL112.prw` e `_AGL112.prw`.
7. **DI2 só tem o SAFX07.** Não há 08, 112 nem 116 nessa pasta.
8. **O `nfesefaz.prw` não está na planilha** e é o fonte mais crítico do fluxo: 14.762 linhas em `Mastersaf_NFe/`, fork customizado do gerador padrão do XML (`User Function XmlNfeSef`, linha 41), com ~39 marcadores `DHL_BUSINESSUNIT_*` e zero geração de IBS/CBS. Ver a precondição da PREMISSA-01.

---

## 2. Como o fluxo funciona hoje

```
SAP (IP040/SZB) → PrcNfRco (MATA920) / PrcNfRet (MATA461)
               → PrcGrvRco (M460FIM: regrava valores ZFM)
               → PrcXmlNfe → ExecBlock XmlNfeSef (nfesefaz.prw: FORK DHL do padrão, 14.762 linhas)
               → ProcMsaNFe → TXT posicional para o Mastersaf (MsafNFeFile/MsafNFeTag)
               ← ImpMsaNfe (retorno: autorização, rejeição, cancelamento, inutilização)
Livros fiscais → SAFX07/08/112/116 (Mastersaf DW, uma variante por filial)
```

Isso tem duas consequências para o plano:

- **Os dados vêm do XML padrão da TOTVS (`XmlNfeSef`).** O ProcMsaNFe só lê caminhos como `infNfe:_det:_imposto…` desse XML. Por **PREMISSA-01**, essas tags existirão: o escopo da DHL é o **mapeamento** caminho-no-XML → posição-no-TXT, e não a apuração nem a geração do valor. Tag ausente devolve `""` sem erro (`IpXmlObject:getNodeValue`), o que permite codificar antes da confirmação do pacote — e exige o log de auditoria da Fase 0, item 1.
- **O TXT enviado ao Mastersaf é posicional.** O `MsafNFeFile.prw` (função `writeTag`) grava um valor por linha, entre marcadores `--tag_ini--` e `--tag_fim--`. O nome do atributo não importa, só a ordem. Toda tag nova precisa entrar na **posição exata do leiaute do Mastersaf**.
- **A reforma já tem uma data de corte no código.** A variável `lRefTribCo` vale `dDataBase >= MV_RTC55`, e o padrão do parâmetro é 05/01/2026. Ela é declarada no `nfesefaz.prw` (linhas 570 e 612, 9 ocorrências) e apenas consumida no `ProcMsaNFe` e no `ProcRCOMsa` (2 ocorrências cada) — o controle da data de corte é do fork, não dos fontes de saída.

---

## 3. O que o XML exige e o que já existe

A tabela compara as tags e regras comentadas no `HTMLConsolidado.xml` com o `Mastersaf_NFe/ProcMsaNFe.prw`.

> Leitura da coluna "Situação hoje" sob **PREMISSA-01**: ❌ e ⚠️ significam **trabalho de customização na DHL** — ler a tag do XML TOTVS e gravá-la na posição correta do TXT. Não significam indisponibilidade do dado.

| Requisito do XML | Situação hoje | Onde (ProcMsaNFe.prw) |
|---|---|---|
| `IBSCBS` com CST e cClassTrib, `gIBSCBS`, `gIBSUF`, `gIBSMun`, `gCBS`, gDif, gDevTrib, gRed, gTribRegular, crédito presumido, gTribCompraGov, mono, gTransfCred, ZFM | ✅ Gerado | `DoIBSCBS` (linha 4421) em diante |
| `IBSCBSTot` com gIBS, gCBS, vCredPres e vCredPresCondSus | ✅ Gerado | `DoIBSCBSTot` (4895) em diante |
| `vItem` | ✅ Copiado do XML TOTVS | `DovItem` (3789) |
| `vNFTot` | ✅ Copiado do XML TOTVS | `DovNFTot` (5055) |
| PIS/COFINS NT com CST 08 | ✅ Existe (`pis_nt` aceita CST 04/06/07/08/09); depende da TES | `DoPisNT` (3349), `DoCofinsNT` (3560) |
| `finNFe` 5 (crédito) e 6 (débito) | ❌ `getFinNfe` só devolve 1, 2, 3 ou 4 | `getFinNfe` (234) |
| `tpNFDebito`, `tpNFCredito`, `cMunFGIBS` | ❌ Sempre enviados vazios (`EMPTY_VALUE`) | `DoIde` (213-220) |
| `vUnComLiq`, `vProdLiq` e `vProdLiqTot` (NT 2026.008) | ❌ Não existem | `DoProd` (1497) / `DoTotal` (552) |
| `IS` e `ISTot` (Imposto Seletivo) | ❌ Não existem | — |
| `DFeReferenciado` (chaveAcesso e nItem) no item | ❌ Não existe; só há `NFref` no cabeçalho | `DoAllRef` (5133) |
| `gPagAntecipado/refNFe` | ❌ Não existe | — |
| `ICMSPrevistoPagtoAntecip/vICMSPrevisto` (débito 06) | ❌ Não existe | — |
| `gAjusteCompet` (CST 811, débito 03) | ❌ Não existe | — |
| `gEstornoCred` no item e no total (débito 07) | ❌ Não existe | — |
| `indPres` | ⚠️ Fixo em "0"; o XML usa 1, 9 ou 0 conforme o caso | `DoIde` (222) |
| `tPag` | ⚠️ Só gera 15 ou 90 | `DoDetPag` (1104) |

### 3.1 Defeitos encontrados no código atual

1. **`DogIBSMuRed` lê o caminho errado (perto da linha 4584).** Ele usa `tributo:_gIBSCBS:_gIBSUF:_gRed`, quando deveria usar `tributo:_gIBSCBS:_gIBSMun:_gRed`. Com isso, a redução do IBS municipal sai com o valor da redução estadual.
2. **`DoIBSCBSTot` tem `::` duplo no caminho.** O trecho `oDetNfe:_imposto:_Tributo::_gIBSCBS:_vBC` fica no ramo de item com um imposto só. Nesse caso a base fica fora da soma do `vBCIBSCBS`.
3. **`vBCIBSCBS` só soma os CSTs listados no `MV_CSTGXML`** (padrão `000/200/210/220/510/550/830/222`). É preciso conferir se essa regra continua válida com os CSTs 410 e 811.
4. **`DogIBSTotAttrib` grava o atributo como `vCresPres`, com erro de digitação.** Não afeta o TXT, que é posicional, mas é bom corrigir junto.

### 3.2 Situação dos outros fontes da Entrega 1

| Fonte | Papel | Impacto da reforma |
|---|---|---|
| PrcXmlNfe.prw | Chama o `XmlNfeSef` e depois o `U_ProcMsaNFe` | Só regressão — por PREMISSA-01 as tags novas vêm prontas do `XmlNfeSef` |
| ImpMsaNfe.prw | Importa o retorno do Mastersaf (autorização, rejeição, cancelamento, inutilização) | Não tem nada de IBS/CBS; o fluxo é centrado na SF2 e no `F2_ZZTPNF` |
| TagProcRef.tlpp | Preenche o processo referenciado (nProc, indProc, tpAto via SF4). Não é o DFe referenciado | Só regressão |
| MsafNFeFile.prw / MsafNFeTag.prw | Classes genéricas do TXT e das tags | Só regressão |
| PrcGrvRco.prw | M460FIM: regrava SD2, SFT, CD2, SF3 e SF2 na desoneração ZFM | Não ajusta a F2D (ver `Analise_IBS_CBS_IP040_PrcGrvRco.md`) |
| PrcNfRco.prw | Gera a NF RCO via MATA920, com `D2_NFORI` | Precisa de CST e cClassTrib nas TES |
| PrcNfRet.prw | Gera a NF de retorno simbólico via MATA461 | O CFOP 5921/6921 vira finNFe=4 e passa a exigir referência e IBSCBS |

---

## 4. Fases do plano

### Convenção de marcação e autoria

Toda alteração feita neste projeto é marcada no fonte com um bloco delimitado, no padrão já usado nos fontes da DHL:

```advpl
// INICIO Pablo Regis 18/11/2026
If cFinNfe $ "5|6"
    ...
EndIf
// FIM Pablo Regis 18/11/2026
```

Alteração de uma única linha usa a forma curta, sem o `FIM`:

```advpl
oProd:setAttributeValue("vProdLiq", ...)  // Pablo Regis 18/11/2026
```

> **Alteração de 22/11/2026:** os marcadores foram renomeados de `Wellington` para `Pablo Regis` em 154 pontos, 30 fontes, a pedido do responsável — o nome é a chave de busca que torna as alterações localizáveis. Não há mais nenhum marcador com a grafia anterior.

Regras de uso:

1. **O nome é o do autor da alteração**, sempre na mesma grafia: `Pablo Regis` ou `Pablo`. O marcador é chave de busca — grafias diferentes para a mesma pessoa inutilizam a auditoria.
2. **A data entra nas duas linhas do bloco**, no `INICIO` e no `FIM`, no formato `DD/MM/AAAA`. É a data da alteração, e as duas linhas repetem a mesma data.
3. **Função ou método novo não usa marcador inline.** A autoria vai no bloco `/*/{Protheus.doc}` exigido pelo padrão do projeto, com `@author` e `@since`.
4. **Sem acentos no marcador.** Os fontes são CP-1252 e serão editados por duas pessoas em dezenas de arquivos; acento em comentário é onde um save acidental em UTF-8 aparece primeiro. Escreva `alteracao`, `credito`, `calculo`.
5. **Alteração replicada em fonte espelhado leva o mesmo marcador com a mesma data.** Vale para o par `ProcMsaNFe.prw` / `ProcRCOMsa.prw` e para as variantes por filial das Entregas 7 e 8.

Auditoria da pegada do projeto:

```bash
grep -rn "INICIO Pablo Regis\|INICIO Pablo" --include=*.prw --include=*.tlpp .
```

### Fase 0: Pré-requisitos

> Por **PREMISSA-01**, o item 1 **não é bloqueante**: é um controle de verificação que corre em paralelo às Fases 1 e 2. Os itens 2 (remerge do `nfesefaz.prw`), 3 e 4 (leiautes de terceiros) são **bloqueantes**.

1. **Verificar o pacote TOTVS e instrumentar a ausência de tag (não bloqueante).**
   - ✅ **Parte estática concluída em 18/11/2026:** a lista de tags exigidas pelos 11 cenários, cruzada com o que os fontes já tratam, está em `Inventario_Tags_NFe_2027.md`. Resultado: **11 tags ausentes**, sendo `vUnComLiq`, `vProdLiq` e `vProdLiqTot` exigidas em **todos** os cenários.
   - ✅ **Rotina de auditoria de tags concluída em 18/11/2026:** `PROTHEUS/Producao/Mastersaf_NFe/DHLRtcTagAudit.tlpp` (238 linhas), chamada do `ProcMsaNFe` e do `ProcRCOMsa` logo antes do `if !lSerCont`. Inerte antes de `MV_RTC55` e desligável por `ZZ_RTCAUDI`. Registra via `FWLogMsg` cada tag esperada ausente, por cenário. Não altera o XML nem o TXT.
   - ⏸ **Parte dinâmica pendente (precisa de ambiente):** gerar o XML de uma nota em homologação e inspecionar, para confirmar a presença das tags e o valor de `codigo` do Imposto Seletivo (parâmetro `ZZ_TRIBIS`, default `"IS"`).

   > **Os caminhos de leitura são deriváveis do `HTMLConsolidado.xml`.** A conversão entre o XML oficial e o XML intermediário da TOTVS é mecânica: trocar `det/imposto/<TRIBUTO>` por `tributo` e juntar os níveis com `:_`. Abaixo do nó `Tributo` a estrutura é idêntica à oficial. Regra, validação e os caminhos das 11 tags em `Dimensionamento_Forks_NFe_2027.md` §3. Isso libera toda a lógica de **leitura** das Fases 1 e 2 sem esperar o pacote da TOTVS.
   - Implementar o **controle compensatório**: rotina de auditoria de tags que, para documentos com `dDataBase >= MV_RTC55`, registra via `FWLogMsg()` cada tag esperada que voltou vazia de `retValueAttribute()`. Sem esse log, a premissa converte um item bloqueante em defeito silencioso (ver Riscos, item 1).
   - Toda tag que permanecer ausente após a data de corte vira **pendência formal junto à TOTVS**, não trabalho de customização na DHL.
2. **Definir a estratégia de remerge do `nfesefaz.prw` (bloqueante para a PREMISSA-01).** Escolher entre: remerge do fork, redução da customização a pontos de entrada, ou adoção do fonte padrão da release-alvo com reaplicação dos pontos. Até essa definição, a PREMISSA-01 permanece **assumida, não verificada**. Restrição obrigatória: preservar os `IsInCallStack("U_PrcGrvRco")`/`("U_PrcNfRco")` (linhas 3026 e 3488) que alteram o XML da AG2.
   - ✅ **Dimensionamento concluído em 18/11/2026:** `Dimensionamento_Forks_NFe_2027.md` §2. A customização são **25 pontos concentrados em 4 funções** (`XmlNfeSef`, `NfeItem`, `NfeInfAd`, `DadNfVinc`), não um bloco opaco de 14.762 linhas. Isso **favorece a terceira alternativa**: adotar o padrão e reaplicar os 25 pontos.
   - ⏸ **Pendente:** o fonte `nfesefaz.prw` padrão da release-alvo, que não está no workspace. É o insumo que falta para o diff definitivo.
3. **Obter o leiaute TXT atualizado do Mastersaf NF-e**, com a posição de cada campo novo. **(bloqueante)**
4. **Obter o leiaute do Mastersaf DW para o SAFX3007 e o SAFX3008.** **(bloqueante)**
5. **Levar ao fiscal as decisões que o próprio XML deixa em aberto:**
   - CFOPs provisórios (5949, 1949, 5927), a confirmar no Ajuste SINIEF 49/2025;
   - uso do CST 08 de PIS/COFINS em 2027;
   - cClassTrib da nota de ajuste só de ICMS;
   - se o `gAjusteCompet` entra no `vItem`;
   - alíquotas reais de CBS e IS (no XML elas são hipotéticas: 8,80% e 2%).
   - **se os CSTs 410 e 811 entram no `MV_CSTGXML`** (ver Fase 0.5, item 4).
6. **Definir quais tipos de nota a DHL vai emitir de fato.** Isso diz quais dos 11 cenários entram no escopo.

### Fase 0.5: Primeiro ciclo — defeitos existentes (Pablo Regis) ✅ CONCLUÍDA em 18/11/2026

Escolhida como primeiro ciclo de desenvolvimento por não depender de nenhum bloqueante: não precisa do leiaute do Mastersaf, do remerge do `nfesefaz.prw` nem de tag nova. Incide sobre código que **já roda em produção gerando IBSCBS**, então o ganho é imediato e a regressão pode ser medida contra a saída de hoje. Serviu também para calibrar o custo real do fork `ProcMsaNFe` × `ProcRCOMsa`, que a planilha original não previa.

Os defeitos vêm da seção 3.1. Cada correção foi aplicada **nos dois fontes**, com marcador e data idênticos, e o comentário registra que se trata de erro pré-existente.

| # | Defeito (§3.1) | Correção | ProcMsaNFe.prw | ProcRCOMsa.prw | Situação |
|---|---|---|---|---|---|
| 1 | `DogIBSMuRed` lia `tributo:_gIBSCBS:_gIBSUF:_gRed` — a redução municipal recebia o valor da estadual | caminho corrigido para `_gIBSMun:_gRed` nas duas linhas (`pRedAliq` e `pAliqEfet`) | 4591-4595 | 4596-4600 | ✅ aplicado |
| 2 | `::` duplo em `fTypeVar("...:_Tributo::_gIBSCBS:_vBC")` no `DoIBSCBSTot` — o teste nunca retornava `"O"` e o item com um único imposto ficava fora da soma do `vBCIBSCBS` | `::` → `:` | 4931-4937 | 4936-4942 | ✅ aplicado |
| 3 | Atributo gravado como `vCresPres` no `DogIBSTotAttrib`, divergindo do equivalente no `gCBS` | `vCresPres` → `vCredPres` | 5013-5016 | 5017-5021 | ✅ aplicado |
| 4 | `vBCIBSCBS` soma apenas os CSTs do `MV_CSTGXML` (`000/200/210/220/510/550/830/222`) | **não alterado** | — | — | ⏸ pendência fiscal |

**Item 4 não é correção técnica.** Incluir os CSTs 410 e 811 muda a base do `vBCIBSCBS` declarada ao Mastersaf, o que é decisão da área fiscal. Foi levado para a Fase 0, item 5.

Verificação aplicada: diffs comparados entre si (alterações idênticas nos dois fontes, 4 linhas removidas e 14 adicionadas em cada), encoding e terminadores conferidos byte a byte, e balanceamento de `if`/`endif` no bloco aninhado do defeito 2.

**Pendente desta fase:** compilação via TOTVS Language Server e teste de regressão de venda normal com `MV_RTC55` antes e depois da data de corte. O que foi verificado é a integridade do arquivo, não a compilação.

**Não aplicado em `merge/`:** as cópias `merge/ProcMsaNFe.prw` e `merge/ProcRCOMsa.prw` mantêm os três defeitos. Alterar os dois lados antes de decidir a direção do merge geraria conflito — ver Fase 0, item 2.

#### ⚠️ Restrição de encoding confirmada em campo

Os fontes estão em **CP-1252 com CRLF**. Durante esta fase, uma ferramenta que reescreve o arquivo inteiro leu o fonte como UTF-8 e **destruiu todos os acentos**: os bytes `E7 E3` de "implementação" viraram `EF BF BD EF BF BD` (U+FFFD, caractere de substituição). Não foi reconversão — foi perda irreversível, recuperada apenas porque havia backup.

Regras para o restante do projeto:

1. **Editar somente com editor configurado em Windows-1252**, ou com script que declare o encoding explicitamente (`encoding='cp1252'` e `newline=''` para preservar CRLF).
2. **Nenhuma ferramenta de reescrita integral do arquivo** (formatadores, conversores, edição automatizada que não declare encoding) deve tocar nestes fontes.
3. **Backup antes de qualquer lote de alteração**, com conferência de md5 na volta.
4. **Validar após cada lote:** `file` deve continuar reportando ISO-8859/CRLF; a contagem de bytes acentuados (`ç` = 0xE7, `ã` = 0xE3) deve permanecer igual à do backup; e não deve haver nenhum byte `0xC3` (UTF-8) nem sequência `EF BF BD`.

### Solicitação fiscal — avaliação item a item (18/11/2026)

Triagem da relação enviada pela área fiscal, confrontada com o código.

#### Já atendido pela Fase 0.5 e pelas Fases 1-2 deste plano

| Item da solicitação | Situação |
|---|---|
| `IS`, `gAjusteCompet`, `gEstornoCred`, `NB01` (`vICMSPrevisto`) não mapeados | ✅ implementados em 18/11/2026, nos **dois** fontes |
| `vUnComLiq`, `vProdLiq`, `vProdLiqTot` não mapeados | ✅ implementados, com `vUnComLiq`/`vProdLiq` no `DoEXTIPI` entre `vProd` e `cEANTrib` |
| Erro `_Tributo::_gIBSCBS`, nota de um item com `vBCIBSCBS` zerado | ✅ corrigido |
| `gRed` do IBS Município com caminho do `gIBSUF` | ✅ corrigido |
| `PrcXmlNfe` só despacha, precisa de regressão | ✅ confirmado: `ExecBlock("XmlNfeSef")` na linha 40 e `U_ProcMsaNFe` na 64, sem filtro de tag. Regressão apenas. |

O fiscal confirma, de forma independente, o mesmo diagnóstico dos defeitos da seção 3.1 e a mesma lista de tags do `Inventario_Tags_NFe_2027.md`.

#### Itens adicionais sobre o `ProcRCOMsa.prw` (recebidos em 18/11/2026)

**1. *"NÃO TEM DFe referenciado (o ProcMsaNFe tem): a referência por item não vai para o arquivo"*** — ✅ **já resolvido no mesmo dia**, antes do recebimento desta observação. O `DoDFeReferenciado()` foi criado nos **dois** fontes, com diffs idênticos: no `ProcRCOMsa` está definido na linha 5081 e chamado na 3911, dentro do laço de itens do `DoDetProd`, entre `DovItem()` e `DoPedidoCliente()`, gravando em `oDet`. A posição respeita a ordem da NT (`det`: prod → imposto → vItem → DFeReferenciado). A observação refletia o estado anterior à alteração.

**2. *"getFinNfe: ajuste só na AG2"*** — ✅ **confirmado e corrigido**. O `finNFe = "3"` (ajuste) estava condicionado a `FWUnitBusiness() == DHL_BUSINESSUNIT_AG2`, nos dois fontes. A verificação mostrou que **a limitação é mais grave do que a observação sugere**: o fluxo do `ProcRCOMsa` não é exclusivo da AG2 — ele trata explicitamente **SPL, REV, REP, AG2, AGL, PKG e MUL** (linhas 3305, 3476 e 3687). Logo, nenhuma unidade além da AG2 conseguia emitir nota de ajuste, nem no fluxo RCO nem no de NF-e.

Correção aplicada no padrão de parametrização já adotado no projeto:

```advpl
if FWUnitBusiness() $ GetNewPar("ZZ_FINAJUS", DHL_BUSINESSUNIT_AG2)
```

O default é a própria constante da AG2, portanto **o comportamento atual não muda**. Para liberar outras unidades, basta preencher `ZZ_FINAJUS` com a lista (ex.: `"AG2/REV/MUL"`) — sem recompilar. Ressalva: o operador `$` é "contido em", então a lista deve usar códigos de unidade de tamanho uniforme, sob pena de falso positivo entre códigos com prefixo comum.

`GetNewPar` aqui é seguro: o `getFinNfe()` é chamado duas vezes por documento (`DoIde` e `DoIcmsTot`), ambas **fora de laço** — verificado nos dois fontes.

**Pendência fiscal:** quais unidades, além da AG2, devem emitir nota de ajuste. Aplicável por parâmetro.

#### O que a solicitação DESBLOQUEIA — origem da finalidade

A indicação *"preencher com o ide do XML ou `F2_TPCOMPL`/`F1_TPCOMPL`"* resolve a pendência que a Fase 1, itens 1 e 2, registrava como indefinida. **A convenção já existe no código**, no `nfesefaz.prw`:

```advpl
// linha 1203
If !SF2->F2_TIPO $ "DB" .and. !(SF2->F2_TIPO == "6" .and. SF2->F2_TPCOMPL == "7")  //6-Nota de Debito e 7-Perda em estoque
// linhas 4526 e 4897
If SF1->F1_TIPO $ "DB" .or. (SF1->F1_TIPO == "5" .and. SF1->F1_TPCOMPL == "3")  //5-Credito com 3-Transferencia de Credito na sucessao
```

Ou seja: **`F*_TIPO` carrega a finalidade** (`"5"` crédito, `"6"` débito) e **`F*_TPCOMPL` carrega o subtipo** (`03`, `04`, `06`, `07`…). Com isso:

- `getFinNfe` pode ser estendido para finNFe 5 e 6 a partir de `F2_TIPO`/`F1_TIPO` — **sai da lista de pendências fiscais**;
- `tpNFDebito` e `tpNFCredito` saem de `F2_TPCOMPL`/`F1_TPCOMPL`, no lugar do `EMPTY_VALUE` fixo;
- a nota de crédito é de **entrada**, logo a leitura é da SF1 e não da SF2 — coerente com o que o `ImpMsaNfe` já faz.

Permanece fiscal apenas a derivação do `indPres` e a regra de `refNFe` única no `DoAllRef`.

#### Defeito novo, em fonte fora da relação das 54: DHLTaxes.prw

A solicitação aponta *"caminhos de IBS/CBS sem o nível `_IBSCBS:_gIBSCBS` (ex.: `_IMPOSTO:_gIBS:_gIBSUF:_VIBSUF`) retornam vazio"*. **O achado é real, mas não está no `ProcMsaNFe`** — e sim em `PROTHEUS/Producao/Validacao_dos_Impostos/DHLTaxes.prw`, linhas 325 e 328:

```advpl
"_IMPOSTO:_gIBS:_gIBSUF:_VIBSUF:TEXT"
"_IMPOSTO:_gIBS:_gIBSMUN:_VIBSMUN:TEXT"
```

Faltam dois níveis. O correto, no XML oficial que essa classe navega (XML de NF-e de terceiro, na validação de entrada), é `_IMPOSTO:_IBSCBS:_gIBSCBS:_gIBSUF:_vIBSUF`.

O `ProcMsaNFe` **não** tem esse defeito: seus caminhos de item passam por `retValTax`, que monta `oTagImp:_tributo:…` sobre a coleção `imposto[n]` do XML intermediário (ver `Dimensionamento_Forks_NFe_2027.md` §3). E os caminhos `_total:_IBSCBSTot:_gIBS:…` estão corretos, porque no total o nível `gIBS` realmente existe. Confirmado também que `vBCIBSCBS` é campo de total e `vBC` é o do item — como o código já faz.

O defeito do `DHLTaxes` é **duplo**, e o segundo é mais grave: além dos caminhos errados, `validTaxes()` nunca chama `getIBSUF()`, `getIBSMUN()` nem `getCBS()` — só `validTotal()`, `validIcms()` e `validIpi()`. Os métodos e paths foram acrescentados em 05/11/2025 e a validação nunca foi ligada. Divergência de IBS/CBS na entrada passa em silêncio.

✅ **Corrigido em 18/11/2026:** os **três** caminhos de item passaram a incluir os níveis que faltavam — `pathIBSUF`, `pathIBSMUN` e `pathCBS` agora leem `_IMPOSTO:_IBSCBS:_gIBSCBS:…`, validados contra a estrutura oficial `det/imposto/IBSCBS/gIBSCBS/{gIBSUF/vIBSUF, gIBSMun/vIBSMun, gCBS/vCBS}`. Eram quatro caminhos errados, não dois: o `pathCBS` também estava sem os níveis.

⏸ **`pathCBSIBSTOT` não foi corrigido, por decisão.** O `IBSCBSTot` é grupo de **total** (`total/IBSCBSTot/vBCIBSCBS`), não fica sob `det/imposto`. A classe recebe um nó `det` (`ProcTaxes.prw:14`), portanto esse método **não funciona só arrumando a string** — exige receber o nó `infNFe/total`. É mudança de desenho. Deixado como está, com o motivo registrado no fonte, para não criar falsa impressão de correção.

⏸ **A validação continua desligada.** Ligar `validIbs()`/`validCbs()` no `validTaxes()` exige definir a **origem do valor Protheus** para comparar com o XML — que é a F2D, e depende da decisão `F2B_TRIB` × `ZZ_TRIB*` ainda em aberto. Não implementado para não fixar uma origem antes da decisão.

> ⚠️ **`DHLTaxes.prw` usa LF puro, não CRLF**, ao contrário do `ProcMsaNFe`/`ProcRCOMsa`. O workspace tem terminadores mistos. Qualquer script de alteração em lote precisa detectar o terminador por arquivo — ver a restrição de encoding da Fase 0.5.

#### Defeito novo nas SAFX: cIndFisJur

A solicitação aponta que o indicador de pessoa é decidido só por `F3_TIPO $ "DB"`. **Confirmado** — `DHLSafx07.prw:123`:

```advpl
cIndFisJur := Iif( cType =="1",Iif((cSF3_)->(F3_TIPO) $ "DB" ,"2","1" ) , Iif(!(cSF3_)->(F3_TIPO) $ "DB" ,"2","1" ) )
```

A expressão considera apenas entrada/saída e `F3_TIPO` em `"DB"` (Devolução/Beneficiamento). **Não considera** os valores novos de `F*_TIPO` (`5` crédito, `6` débito) nem o `F*_TPCOMPL`. Logo, crédito (entrada cujo participante é **cliente**) e débito 07 (destinatário é a própria DHL) saem com participante errado.

✅ **Triagem concluída em 18/11/2026:** `Triagem_cIndFisJur_SAFX.md`, com os 28 fontes, linha por linha. A verificação mostrou que **o defeito é maior do que a solicitação descreve**, em duas camadas:

- **camada 1 — seleção do participante:** o `cIndFisJur` é passado a `DHLSafx:getSupCusRecords()`, que escolhe SA1 (cliente) × SA2 (fornecedor). Indicador errado ⇒ **lê o cadastro errado**, afetando nome, CNPJ, IE e endereço, não só o indicador. Ativo em 26 fontes;
- **camada 2 — o campo exportado:** vem de `(cSF3_)->ZZINDDW`, resolvido **na query** por ramo do `UNION` (`a1_zzinddw` × `a2_zzinddw`). Correto apenas se o ramo for escolhido corretamente, o que também exige tratar `F*_TIPO` 5 e 6. Fica nos fontes de query (`07AG2SAFX`, `SAFX07AGE`, `SAFX07MSDW`), **não** nas classes `DHLSafx*`.

Não há código morto: nos 28 fontes o `cIndFisJur` tem efeito. Quatro deles estão **fora** da relação de 25 da solicitação: `_AGL112`, `DHLDisSafx235`, `DHLMulSafx235` e `DHLPkgSafx235`.

⏸ **Nenhuma linha alterada, por dois bloqueios que não são técnicos:** (1) a convenção de `"1"` e `"2"` não está documentada e há inversão deliberada em `DHLSafx116.prw:138` — inverter errado troca o participante de **todas** as notas; (2) a área fiscal precisa definir qual participante deve constar no arquivo DW para crédito e para débito 07, onde o destinatário é a própria DHL. Plano de correção em `Triagem_cIndFisJur_SAFX.md` §5.

**Esse item não depende do leiaute Mastersaf DW 2027** e pode ser trabalhado antes dele. É a única frente da Entrega 8 liberada hoje.

Nota de conformidade: as linhas de `cIndFisJur` usam `Iif` encadeado, proibido pelo padrão do projeto (CA4000). Ao corrigir, converter para `If/Else/EndIf`.

#### Confirmação sobre as SAFX e o leiaute

*"Não exportam IBS/CBS/IS, CST nem cClassTrib"* — coerente com a Fase 6, que permanece bloqueada no leiaute Mastersaf DW 2027 (Fase 0, item 4).

### Fase 1: ProcMsaNFe, cabeçalho e referências (Pablo Regis)

> **Replicação no `ProcRCOMsa.prw`:** o dimensionamento de 18/11/2026 mostrou que **as 10 funções alteradas pelas Fases 1 e 2 são idênticas nos dois fontes** — 233 das 247 funções do fork são iguais. A replicação é **mecânica**, não exige reanálise. Atenção apenas a `MountTags` (orquestrador, divergente, afetado por qualquer grupo novo) e a `DoDetProd` (divergente por uma linha, dentro do escopo da Fase 2). Ver `Dimensionamento_Forks_NFe_2027.md` §1.

1. **Ampliar o `getFinNfe` para finNFe 5 (crédito) e 6 (débito).** ✅ **Origem definida pela solicitação fiscal:** vem de `F2_TIPO`/`F1_TIPO` (`"5"` crédito, `"6"` débito), convenção já usada no `nfesefaz.prw` (linhas 1203, 4526 e 4897). Deixou de ser pendência fiscal — ver a seção da solicitação fiscal.
2. **Preencher `tpNFDebito`, `tpNFCredito` e `cMunFGIBS`.** Hoje estão fixos em `EMPTY_VALUE`. ✅ **Origem definida:** `tpNFDebito` e `tpNFCredito` vêm de `F2_TPCOMPL`/`F1_TPCOMPL` (subtipo: `03`, `04`, `06`, `07`…). O `cMunFGIBS` continua condicionado a indPres=5 sem endereço do destinatário, e segue dependente da derivação do `indPres` (item 3).
3. **Derivar `indPres` da finalidade**, no lugar do valor fixo "0".
4. **Criar `DoDFeReferenciado` no item**, respeitando as regras de cada tipo:
   - a referência vai no cabeçalho **ou** no item, nunca nos dois (VC02-05, rejeição 1010);
   - é obrigatória no crédito 06 e nos débitos 03 e 04 (VC02-10, rejeição 1038);
   - `nItem` é proibido no débito 03 (VC03-10, rejeição 1039);
   - a nota de crédito 03/04 não aceita DFeReferenciado (VC02-07, rejeição 1042);
   - a chave deve ser a mesma em todos os itens (VC02-30, rejeição 1130), exceto nos débitos 03 e 07.
5. **Criar o `gPagAntecipado`**, para a nota que abate um débito 06.
6. **Ajustar o `DoAllRef`.** Em finNFe 2 e em crédito 03/04 deve ir exatamente uma `refNFe` (B25-30/B25-40, rejeições 254/255). Também é preciso rever o laço que hoje gera várias referências.

### Fase 2: ProcMsaNFe, item e totais (Pablo Regis)

> **Geração dos grupos novos concluída em 18/11/2026**, nos dois fontes, com diffs idênticos. 7 funções novas e 8 pontos de chamada. A **ordem dos campos e dos grupos** segue a sequência da NT, extraída dos 11 exemplos do `HTMLConsolidado.xml`, e é **hipótese de trabalho** até o leiaute do Mastersaf chegar.
>
> | Grupo | Função nova | Campos, na ordem da NT | Pai | Posição |
> |---|---|---|---|---|
> | `IS` | `DoIS()` | `CSTIS`, `cClassTribIS`, `vBCIS`, `pIS`, `vIS` | `oImpostos` | entre COFINS e IBSCBS |
> | `ISTot` | `DoISTot()` | `vIS` | `oTotal` | entre ICMSTot e IBSCBSTot |
> | `vProdLiqTot` | `DovProdLiqTot()` | `vProdLiqTot` | `oTotal` | **antes** do ICMSTot |
> | `gAjusteCompet` | `DogAjusteCompet()` | `competApur`, `vIBS`, `vCBS` | `oSeqXML` | irmão do `gIBSCBS` |
> | `gEstornoCred` | `DogEstornoCred()` | `vIBSEstCred`, `vCBSEstCred` | `oSeqXML` | irmão do `gIBSCBS` |
> | `ICMSPrevistoPagtoAntecip` | `DoICMSPrevAntecip()` | `vICMSPrevisto` | `oICMS` | após `DoICMS` |
> | `DFeReferenciado` | `DoDFeReferenciado()` | `chaveAcesso`, `nItem` | `oDet` | **depois** do `vItem` |
>
> `vUnComLiq` e `vProdLiq` entraram no `DoEXTIPI()`, entre `vProd` e `cEANTrib` — é onde o TXT monta os campos de `prod`. **Posição crítica:** são campos dentro de grupo existente; offset errado desloca todo o resto do grupo.
>
> **Pontos a confirmar quando o leiaute chegar:** o nome de cada marcador novo, a ordem dos campos dentro de cada grupo, e a posição de `IS` e `ISTot` em relação a `ISSQNtot`/`retTrib` — os exemplos do XML não trazem esses dois, então a posição relativa a eles foi inferida.
>
> **Parâmetros novos:** `ZZ_TRIBIS` (default `"IS"`) e `ZZ_TRIBICM` (default `"ICM"`), que identificam o tributo na coleção `imposto[n]` do XML intermediário.
>
> **Não implementado — depende de decisão fiscal ou de negócio (Fase 0, itens 5 e 6):** a origem da finalidade no `getFinNfe` para finNFe 5 e 6; o preenchimento de `tpNFDebito`/`tpNFCredito`/`cMunFGIBS`, hoje `EMPTY_VALUE`; a derivação do `indPres`; a regra de `refNFe` única no `DoAllRef`; a supressão de grupos por finalidade; e as regras de obrigatoriedade do `DFeReferenciado` por tipo de nota. As funções existem e são chamadas; o que falta é **quando** acioná-las e **de onde** vem a finalidade.

1. **Incluir `vUnComLiq` e `vProdLiq` no `DoProd`, e `vProdLiqTot` no total.** A regra é `vProdLiq = vUnComLiq × qCom` (rejeição 1279). O `vProdLiqTot` vem antes do `ICMSTot` (rejeições 1282/1283).
2. **Criar o grupo `IS` e o `ISTot`.** O `ISTot` é obrigatório quando algum item tem IS (rejeição 1117).
3. **Criar o grupo `ICMSPrevistoPagtoAntecip/vICMSPrevisto`**, usado no débito 06. A partir de 01/03/2027 a ausência dá rejeição 1281.
4. **Criar o `gAjusteCompet`** (CST 811, cClassTrib 811002). Nesse caso o `gIBSCBS` não pode ir (rejeições 1021, 1170 e 1171).
5. **Criar o `gEstornoCred` no item e no total** (débito 07, CST 410, cClassTrib 410030). Rejeições 1173, 1176 e 1177.
6. **Suprimir grupos conforme a finalidade:**
   - débito 03 e 04: sem ICMS, IPI, PIS, COFINS e ISSQN (B25-80, rejeição 1001);
   - débito 06: o ICMS só traz o `ICMSPrevistoPagtoAntecip`;
   - crédito: dispensado de PIS e COFINS;
   - demais finalidades: PIS e COFINS continuam obrigatórios no modelo 55 (rejeições 745/748).
7. **Corrigir os defeitos da seção 3.1**: `DogIBSMuRed`, o `::` duplo, a regra do `MV_CSTGXML` e o `vCresPres`.

### Fase 3: Origem dos dados, SAP SC Johnson (Pablo e Pablo Regis)

1. **PrcGrvRco (Pablo Regis).** Ajustar ou recalcular a F2D depois que os valores são regravados na desoneração ZFM. Sem isso, a base do IBS/CBS (`vProd - vICMS + vIS`) e o `vItem` ficam diferentes do item final. O risco está documentado em `Analise_IBS_CBS_IP040_PrcGrvRco.md` §2, com o exemplo numérico (item de 1.000 com `ZB_VLDIICM` de 120 passa a 880, enquanto a F2D guarda a base antiga).

   Restrições de implementação que vêm de `Analise_PrcGrvRco.md` e **não podem ser violadas**:
   - **O ajuste da F2D tem de ocorrer antes da linha 306.** O `U_PrcXmlNfe` é obrigatoriamente o último passo (restrição 4): tudo gravado depois dele não entra no XML enviado ao Mastersaf.
   - **Não renomear `U_PrcGrvRco` nem chamar a geração do XML por fora dela** (restrição 1): o `nfesefaz.prw` testa `IsInCallStack("U_PrcGrvRco")` nas linhas 3026 e 3488 para alterar o XML da AG2. Quebra silenciosa.
   - **`F3_REPROC = 'N'`** (restrição 7) impede o reprocessamento fiscal padrão de recalcular a SF3. Se a estratégia escolhida para a F2D for "deixar o Protheus recalcular", essa flag a neutraliza — conferir antes de decidir.
   - **Falha de seek não aborta nada** (`lOkPos = .F.` não altera `lRet`, linhas 108 e 152). Uma nota parcialmente ajustada passa sem alerta — se a F2D entrar nesse bloco, o mesmo padrão silencioso se aplica a ela.
   - **Código morto**: o bloco "LÓGICA DO IVAN" (linhas 162-278) é versão anterior da mesma regra. Não usar como referência.
   - **ZFM tem regime próprio de IBS/CBS** na reforma (redução/crédito presumido). A base "correta" dessas notas é **definição do fiscal**, não decisão técnica — entra na Fase 0, item 5.
2. **PrcNfRet (Pablo).** O CFOP 5921/6921 força finNFe=4 no `getFinNfe` do ProcMsaNFe. Em 2027 isso traz duas exigências:
   - o IBSCBS passa a ser obrigatório quando a nota original é de 2027 (UB12-10);
   - passa a ser exigida a referência à nota original, no `NFref` ou no `DFeReferenciado`.
   É preciso garantir que o `D2_NFORI` chegue ao XML.
3. **PrcNfRco (Pablo).** Validar se as TES usadas (`getCstTes`) têm CST e cClassTrib de IBS/CBS configurados.
4. **IP040/SZB.** Decidir se os campos `ZB_IBS*` e `ZB_CBS*` vindos do SAP serão comparados com a F2D ou se vão sobrepor o valor dela. Ver `Analise_IBS_CBS_IP040_PrcGrvRco.md` §1. Dois pontos já confirmados por aquela análise:
   - as constantes `FIELDS_IBS_UF`, `FIELDS_IBS_MUN` e `FIELDS_CBS` **estão declaradas no `DHLIp040Sap.prw` mas nenhum trecho do fonte as usa**: o valor do SAP fica na SZB sem ser comparado nem aplicado;
   - o `validValues` (linhas 321-446) só trata SD2/SFT/SB1, CD2 (apenas `ICM`, `SOL`, `CMP`, `ZFM`) e SF3. **Não existe ramo para a F2D** — um de-para `ZB_IBS*` → `F2D_*` cadastrado na SZD cai fora de todos os `If/ElseIf` e é **ignorado sem aviso**. Criar o ramo é pré-requisito de qualquer das três opções de tratamento de divergência.

### Fase 4: Retorno do Mastersaf, ImpMsaNfe (Pablo)

1. **Garantir que o retorno localiza notas de crédito.** A nota de crédito é de **entrada** com formulário próprio (SF1, tpNF=0), mas hoje o fluxo trata principalmente a SF2 e o `F2_ZZTPNF`.
2. **Tratar as rejeições novas no log**: 1001, 1009, 1010, 1021, 1038, 1039, 1042, 1115, 1117, 1119, 1130, 1161, 1162, 1164, 1170, 1171, 1173, 1176, 1177 e 1279 a 1283.
3. **Revisar o caminho de exclusão em caso de rejeição** (`excluiNf` com MATA103) para as notas de entrada de crédito.

### Fase 5: Regressão (Pablo)

1. **TagProcRef, MsafNFeFile e MsafNFeTag.** Não precisam de mudança de regra. Só precisam de teste de regressão: tags novas sem `_ini`/`_fim` indevidos e a ordem do TXT.

### Fase 6: SAFX / Mastersaf DW

**Entrega 7 (Pablo Regis)**

1. Criar os includes `safx3007.ch` e `safx3008.ch` com as posições.
2. Criar `DHLSafx3007` e `DHLSafx3008` no padrão de `DHLSafx07` e `DHLSafx08`, lendo IBS/CBS/IS da F2D e da SFT.
3. Incluir a geração em `ProcMsaDW`, `SAFX07MSDW` e `SAFX08MSDW`.
4. Avaliar se `DHLSafx112`, `DHLSafx116` e `DHLSafx2013` precisam dos campos novos, como finalidade crédito/débito e chave referenciada.

**Entrega 8 (Pablo e Pablo Regis, conforme a planilha)**

1. Replicar nas variantes por filial:
   - AG2 (8 fontes);
   - AGL (8);
   - DI2 (2);
   - MUL (9);
   - AGE/REP (8).
2. **Decidir se a pasta DIS (8 fontes) entra no escopo.** Ela não está na planilha.
3. **Corrigir a classificação do documento por `F3_TIPO $ "DB"` (liberado — não depende do leiaute DW).**

   > **Revisão de 18/11/2026.** A afirmação de que a Entrega 8 está integralmente bloqueada no leiaute **era grosseira**. A varredura dos 102 fontes de `Mastersaf_DW` encontrou o teste binário `f3_tipo` pertencer a `"DB"` em **três lugares**, nenhum com noção de `F*_TIPO` `5`/`6`, e **nenhum deles depende do leiaute**:
   >
   > | # | Manifestação | O que decide errado | Fontes |
   > |---|---|---|---|
   > | 1 | `cIndFisJur := Iif(… F3_TIPO $ "DB" …)` | tabela de participante (SA1 × SA2) | 28 |
   > | 2 | Roteamento dos ramos do `UNION` | o `JOIN` de participante e o `a1_zzinddw` × `a2_zzinddw` | 5 |
   > | 3 | `case when f3_tipo in ('D','B') … end tipo` | **o tipo de movimento gravado no arquivo** | 7 |
   >
   > A manifestação 3 é a mais grave: só existem `SAFX_MOVIMENTO_DEVOLUCAO` e `SAFX_MOVIMENTO_NORMAL`, logo **crédito e débito são exportados ao livro fiscal como operação normal**. Não é só o participante — é a natureza da operação.
   >
   > Na manifestação 2, a nota de crédito (entrada, `F3_TIPO = '5'`) cai no ramo do fornecedor porque `'5' NOT IN ('D','B')`, e o join vira `a2_cod = f3_cliefor` sobre um código de **cliente** — participante nulo ou trocado. A estrutura de 4 ramos já contempla entrada-com-cliente; falha a condição que roteia.
   >
   > Confirmado também: **nenhum** dos 102 fontes menciona IBS, CBS, IS, `cClassTrib` ou `MV_RTC55`. Os filtros `F2_TIPO = 'N'`/`F1_TIPO = 'B'`, que excluiriam crédito e débito do arquivo, existem só nos `SAFX235` (DIS/MUL/PKG), fora da relação de 54.
   >
   > Detalhamento e plano de correção em `Triagem_cIndFisJur_SAFX.md` §1.1 e §5.

   ✅ **Executado em 18/11/2026, com a decisão fiscal parametrizada.** Em vez de aguardar a definição do fiscal, o código foi escrito de forma que a decisão seja aplicada **por parâmetro, sem recompilar**:

   - **Novo método `DHLSafx:getIndFisJur(cType, cTipoDoc)`** na classe base (`DHLSafx.prw`, declaração na linha 40, implementação na 289). Centraliza a decisão que estava duplicada em 25 fontes. **Comportamento preservado** para os tipos clássicos: entrada+`D`/`B` → `"2"` cliente; entrada+outros → `"1"` fornecedor; saída+`D`/`B` → `"1"` fornecedor; saída+outros → `"2"` cliente.
   - **Tipos novos por parâmetro:** `F*_TIPO` `"5"` (crédito) → `ZZ_IFJCRE`, default `"2"` cliente; `"6"` (débito) → `ZZ_IFJDEB`, default `"2"`. O default do crédito é `"2"` porque a área fiscal já indicou que o participante é um cliente; o do débito mantém o resultado atual na saída, portanto sem mudança de comportamento.
   - **26 expressões `Iif` substituídas** por chamada ao método, em **25 fontes**, preservando o acessor de `F3_TIPO` que cada um usa (`::getFieldValue` × `(cSF3_)->`). Duas ocorrências restantes já estavam comentadas — código morto, mantidas como estão. Resolve também o `Iif` encadeado proibido pelo CA4000.
   - **Tipo de movimento:** o `case when` ganhou o ramo `f3_tipo in ('5','6')` em **7 fontes**, com o valor vindo de `ZZ_SFXMOVR`, default `SAFX_MOVIMENTO_NORMAL` — **o comportamento atual não muda** até que o leiaute DW 2027 defina o valor correto. O campo destino é `NORM_DEV`, binário no leiaute atual (`"1"` normal, `"2"` devolução), então o valor de crédito/débito **depende do leiaute** e não de nós.

   **Não alterado, de propósito:** as derivações próprias da família `DHLSafx116` (linhas ~270-295 em cada variante). Elas resolvem o participante do documento **referenciado**, com semântica diferente — em `DHLSafx116.prw:138` o indicador é deliberadamente invertido, porque o participante do referenciado é do tipo oposto. Mexer ali exige validar os dois consumidores.

   **Pendências de definição fiscal, agora aplicáveis por parâmetro:** o participante do crédito (`ZZ_IFJCRE`), o do débito 07 — onde o destinatário é a própria DHL (`ZZ_IFJDEB`) — e o valor de movimento de crédito/débito no DW (`ZZ_SFXMOVR`, dependente do leiaute).

   > **Observação registrada, a verificar (não alterada):** em `DHLSafx07.prw:225` e equivalentes, `::addField(IND_COMPRA_VENDA, Iif((csf3_)->TIPO =="N","VD", Iif((csf3_)->TIPO $ "CPI","CP","")))` lê a coluna `TIPO`, que é a **calculada** pelo `case when` e vale `"1"` ou `"2"` — nunca `"N"` nem `"C"`/`"P"`/`"I"`. O campo `IND_COMPRA_VENDA` sairia sempre vazio. A query também expõe `f3_tipo` (valor cru), que seria o acessor correto. Parece defeito pré-existente, mas **não confirmado** — exige rodar a query para descartar a existência de outra coluna `TIPO`.

   **Item original — `cIndFisJur`:** Apontado pela solicitação fiscal: o indicador de pessoa é decidido só por `F3_TIPO $ "DB"` e entrada/saída, ignorando `F*_TIPO` 5/6 e `F*_TPCOMPL`. Crédito e débito 07 saem com participante errado. Antes de alterar, fazer a **triagem por fonte** descrita na seção da solicitação fiscal: `cIndFisJur` está em 28 fontes, mas em 3 o campo `IDENT_FIS_JUR` já vem de `ZZINDDW` com o `Iif` comentado, em 2 ainda vem do `cIndFisJur`, e em 14 a variável tem uso ativo para outras finalidades. Rastrear também a origem do `ZZINDDW` — se for cadastro, a correção é de dado. Converter os `Iif` encadeados para `If/Else/EndIf` (CA4000).

### Fase 7: Testes

Usar os **11 cenários do XML** como casos de teste em homologação (`tpAmb=2`). Para cada cenário:

1. gerar a nota no Protheus;
2. conferir o TXT contra o leiaute do Mastersaf;
3. transmitir pelo Mastersaf;
4. validar o retorno no ImpMsaNfe e a geração dos SAFX.

| # | Cenário do XML | finNFe / tipo | Pontos a validar |
|---|---|---|---|
| 1 | Venda | 1 | vProdLiq, IS/ISTot, IBSCBSTot, vItem e vNFTot |
| 2 | Débito 06: pagamento antecipado | 6 / 06 | ICMSPrevistoPagtoAntecip, sem NFref, tpNF=1 |
| 3 | Crédito 04: redução de valor | 5 / 04 | tpNF=0, uma única refNFe, sem DFeReferenciado |
| 4 | Devolução | 4 | DFeReferenciado no item **ou** NFref, IBSCBS obrigatório |
| 5 | Complementar | 2 | uma única refNFe, alíquota validada |
| 6 | Ajuste | 3 | NFref opcional, IBSCBS com base zero |
| 7 | Crédito 03: retorno por recusa total | 5 / 03 | CFOP 1201, sem PIS/COFINS, sem DFeReferenciado |
| 8 | Crédito 06: recusa parcial | 5 / 06 | DFeReferenciado obrigatório com nItem |
| 9 | Débito 04: multa e juros | 6 / 04 | sem ICMS/PIS/COFINS, DFeReferenciado com nItem |
| 10 | Débito 03: nota não processada | 6 / 03 | CST 811, gAjusteCompet, DFeReferenciado sem nItem |
| 11 | Débito 07: perda em estoque | 6 / 07 | CST 410, gEstornoCred no item e no total |

Conferir também os cálculos que o XML aponta:

- `vBC (IBS/CBS) = vProd - vICMS + vIS`;
- `vItem = vProd + vIBS + vCBS + vIS`;
- `vNFTot = soma dos vItem`;
- `vProdLiq = vUnComLiq × qCom`.

Por fim, testar a regressão da venda normal com o `MV_RTC55` antes e depois da data de corte.

---

## 5. Ordem e dependências

Sob **PREMISSA-01**, as Fases 1 e 2 **não esperam** a confirmação do pacote TOTVS. O que as liga à Fase 0 é apenas o leiaute do TXT (item 2), necessário para posicionar os campos — a lógica de leitura do XML pode ser escrita antes.

```
Fase 0.5 (defeitos existentes) ── sem dependencia, CONCLUIDA em 18/11/2026
                                  pendente: compilacao + regressao

Fase 0 item 1 (verificação do pacote + log de tag ausente) ─── corre em paralelo ───┐
                                                                                   │
Fase 0 itens 2-5 (bloqueantes) ──► Fase 1 ──► Fase 2 ──────────────────────► Fase 7
                     │               └──► Fase 4 ─────────────────────────────┘
                     ├──► Fase 3 (em paralelo; o PrcGrvRco/F2D é crítico para os valores)
                     └──► Fase 6 (depende só do leiaute DW)
```

O resultado da Fase 0, item 1 é **insumo da Fase 7**: a lista de tags confirmadas define quais dos 11 cenários podem ser validados de ponta a ponta e quais ficam em espera da TOTVS.

---

## 6. Riscos principais

0. **(Novo, Médio — reavaliado) O fork do `nfesefaz.prw` não ser remergeado em tempo.** É a precondição da PREMISSA-01. Classificado inicialmente como Alto por causa das 14.762 linhas; o dimensionamento de 18/11/2026 reduziu para Médio: são **25 pontos de customização em 4 funções**, trabalho delimitado. Permanece risco porque está fora do inventário das 54 fontes e ainda sem dono, prazo nem o fonte padrão da release-alvo para o diff. *Mitigação:* Fase 0, item 2, e `Dimensionamento_Forks_NFe_2027.md` §2.

0c. **(Novo, Médio — mitigado em 18/11/2026) Crédito e débito saem do livro fiscal classificados como operação normal.** Nas SAFX, o teste `f3_tipo IN ('D','B')` decidia o participante (SA1 × SA2) em 25 fontes, o tipo de movimento em 7 e o roteamento do `UNION` em 5, sem conhecer `F*_TIPO` `5`/`6`.

   *Mitigação aplicada:* a decisão do participante foi centralizada em `DHLSafx:getIndFisJur()` e os tipos `5`/`6` passaram a ser tratados por parâmetro (`ZZ_IFJCRE`, `ZZ_IFJDEB`); o tipo de movimento ganhou ramo próprio com valor em `ZZ_SFXMOVR`. O risco cai de Alto para Médio porque o ponto de decisão agora é **um só** e ajustável sem recompilar.

   *Resíduo:* (a) o valor de movimento de crédito/débito depende do leiaute DW 2027 — o campo `NORM_DEV` é binário hoje; (b) o **roteamento dos ramos do `UNION`** nos 5 fontes de query **não foi alterado** — continua com `f3_tipo IN ('D','B')` escolhendo o `JOIN` de SA1/SA2, de modo que a nota de crédito ainda casa `a2_cod = f3_cliefor` sobre código de cliente; (c) as derivações próprias da família `DHLSafx116`. Ver Fase 6, item 3.

0b. **(Novo, Baixo — reavaliado) O `codigo` do Imposto Seletivo no XML intermediário.** Classificado inicialmente como Alto, sob a leitura de que a estrutura do XML intermediário da TOTVS era desconhecida. **Essa leitura estava errada:** a conversão entre o XML oficial e o intermediário é mecânica e já implementada no `retValTax()` — trocar `det/imposto/<TRIBUTO>` por `tributo`. Os caminhos das 11 tags foram derivados do `HTMLConsolidado.xml` (ver `Dimensionamento_Forks_NFe_2027.md` §3). Resta **um** desconhecido: o valor de `codigo` que identificará o IS na coleção `imposto[n]`. *Mitigação:* parametrizado em `ZZ_TRIBIS` (default `"IS"`), no mesmo padrão que o `DHLIdManager.prw` usa para os tributos da F2D — ajustável sem recompilar.

1. **PREMISSA-01 não se confirmar — falha silenciosa.** O risco não é mais "não há de onde ler": é a tag que não se materializa e produz **campo vazio no TXT, sem erro e sem log**, porque `IpXmlObject:getNodeValue` devolve `""` para nó inexistente. A nota é montada, transmitida e só é barrada na SEFAZ. *Mitigação:* o log de auditoria de tags da Fase 0, item 1, mais o registro formal do release/patch instalado e a abertura de pendência na TOTVS para cada tag ausente. *Responsabilidade:* tag ausente é entrega da TOTVS, não customização da DHL.
2. **Leiaute posicional do Mastersaf.** Uma posição errada desloca todos os campos seguintes do TXT.
3. **Rejeições estruturais em 2027.** São finNFe 5 e 6, DFeReferenciado e `gAjusteCompet`/`gEstornoCred`. Sem elas, notas de crédito e débito serão rejeitadas.
4. **F2D desatualizada na ZFM.** O IBS/CBS sai com base errada no XML.
5. **Escopo do SAFX indefinido.** A pasta DIS e o SAFX2013MSDW estão fora da planilha, e há divergência de consultor no SAFX07MSDW (PKG).

---

## 7. Questões a tratar com a área fiscal

Consolidação das definições que dependem da área fiscal, reunidas aqui para servir de pauta. **Os itens continuam registrados nas fases de origem** — esta seção não os substitui, apenas agrupa.

> **Versão para envio à área fiscal:** `Questoes_Fiscais_NFe_2027.md`, documento autônomo com as mesmas 18 questões redigidas em termos fiscais, com espaço para resposta e indicação do que cada pendência trava (desenvolvimento, produção ou teste). Manter os dois em sincronia ao atualizar.

Coluna "Como entra": **parâmetro** significa que o código já está pronto e a resposta é aplicada por cadastro, sem recompilar; **código** significa que a resposta define o que ainda será desenvolvido.

### 7.1 Escopo — define o tamanho do projeto

| # | Questão | Por que importa | Como entra |
|---|---|---|---|
| 1 | **Quais tipos de nota a DHL vai efetivamente emitir em 2027?** Dos 11 cenários do `HTMLConsolidado.xml`: venda, complementar, ajuste, devolução, crédito 03/04/06 e débito 03/04/06/07. | Define quais cenários entram no escopo de desenvolvimento e de teste. Hoje o plano trata os 11. | código |
| 2 | **Quais unidades de negócio, além da AG2, devem emitir nota de ajuste** (`finNFe = 3`)? | A restrição à AG2 já existia e foi mantida por default. O fluxo atende também SPL, REV, REP, AGL, PKG e MUL. | parâmetro `ZZ_FINAJUS` |
| 3 | **A pasta `SAFX07/DIS` (8 fontes) e o `SAFX2013MSDW.prw` entram no escopo?** Não constam da planilha. | Altera a contagem de 54 para 63 fontes. | código |

### 7.2 Tributação e alíquotas

| # | Questão | Por que importa | Como entra |
|---|---|---|---|
| 4 | **Alíquotas reais de CBS e IS para 2027.** No XML de referência são hipotéticas: CBS 8,80% e IS 2%. | Sem as reais, os testes validam estrutura, não valor. | cadastro fiscal |
| 5 | **O CST 08 de PIS/COFINS será usado em 2027?** | Define o comportamento de `DoPisNT`/`DoCofinsNT`, que hoje aceita CST 04/06/07/08/09 e depende da TES. | código + TES |
| 6 | **Qual o `cClassTrib` da nota de ajuste que tem só ICMS?** | O XML de referência deixa em aberto. | cadastro fiscal |
| 7 | **Os CSTs 410 e 811 entram no `MV_CSTGXML`?** O parâmetro hoje é `000/200/210/220/510/550/830/222` e define quais CSTs somam o `vBCIBSCBS`. | Muda a base de IBS/CBS declarada ao Mastersaf. Único defeito da §3.1 **não corrigido**, justamente por ser decisão fiscal. | parâmetro `MV_CSTGXML` |
| 8 | **Os CFOPs provisórios se confirmam?** 5949, 1949 e 5927, a conferir no Ajuste SINIEF 49/2025. | Afetam o enquadramento das notas de crédito e débito. | cadastro fiscal |

### 7.3 Finalidade, referências e supressão de grupos

| # | Questão | Por que importa | Como entra |
|---|---|---|---|
| 9 | **Como derivar o `indPres`** (presença do comprador) a partir da finalidade? Hoje está fixo em `"0"`; o XML de referência usa 1, 9 e 0 conforme o caso. | Sem a regra, o campo continua fixo. O `cMunFGIBS` depende dele — só é usado com `indPres = 5` e sem endereço do destinatário. | código |
| 10 | **Quantas `refNFe` em cada finalidade?** Em finNFe 2 (complementar) e no crédito 03/04 deve ir exatamente uma (rejeições 254/255). O `DoAllRef` hoje gera várias num laço. | Rejeição na SEFAZ. | código |
| 11 | **Em quais tipos de nota o `DFeReferenciado` é obrigatório, e quando o `nItem` é proibido?** A função já existe e é chamada; falta a regra de quando acioná-la. Regras conhecidas: obrigatório no crédito 06 e nos débitos 03/04; `nItem` proibido no débito 03; a nota de crédito 03/04 não aceita o grupo; a referência vai no cabeçalho **ou** no item, nunca nos dois. | Rejeições 1010, 1038, 1039, 1042 e 1130. | código |
| 12 | **Quais grupos de imposto suprimir em cada finalidade?** Conhecido: débitos 03 e 04 sem ICMS/IPI/PIS/COFINS/ISSQN; débito 06 só com `ICMSPrevistoPagtoAntecip`; crédito dispensado de PIS/COFINS. Confirmar e completar. | Rejeições 1001 e 745/748. | código |
| 13 | **O `gAjusteCompet` entra na composição do `vItem`?** | Afeta o cálculo do total do item na nota de débito 03. | código |

### 7.4 Participante e livros fiscais (Mastersaf DW)

| # | Questão | Por que importa | Como entra |
|---|---|---|---|
| 14 | **Na nota de crédito, o participante é o cliente?** A área fiscal já indicou que sim; falta a confirmação formal. | Define a leitura de SA1 × SA2 e, com ela, nome, CNPJ, IE e endereço no arquivo DW. | parâmetro `ZZ_IFJCRE` |
| 15 | **Na nota de débito 07 (perda em estoque), qual participante deve constar?** O destinatário é a própria DHL, logo pode não haver terceiro. | Idem. Pode exigir tratamento próprio, não apenas "cliente em vez de fornecedor". | parâmetro `ZZ_IFJDEB` |
| 16 | **Crédito e débito devem ser escriturados como qual tipo de movimento?** O campo `NORM_DEV` do leiaute atual só admite `"1"` normal e `"2"` devolução. Hoje crédito e débito caem em "normal". | Classificação da operação no livro fiscal. **Depende também do leiaute Mastersaf DW 2027**, que precisa dizer se o campo ganha valores novos ou se a identificação passa a ser por outro campo. | parâmetro `ZZ_SFXMOVR` + leiaute |

### 7.5 Zona Franca de Manaus e interface SAP

| # | Questão | Por que importa | Como entra |
|---|---|---|---|
| 17 | **Qual é a base correta de IBS/CBS nas notas com desoneração ZFM?** O `PrcGrvRco` regrava o valor do item depois do cálculo fiscal e não ajusta a F2D, então a base de IBS/CBS fica divergente do item final. A ZFM tem regras próprias na reforma (redução, crédito presumido). | Base errada no XML e divergência entre livros e apuração. Ver `Analise_IBS_CBS_IP040_PrcGrvRco.md` §2. | código |
| 18 | **Quando o IBS/CBS do SAP divergir do calculado pelo Configurador de Tributos, o que fazer?** Três opções mutuamente exclusivas: (a) bloquear o faturamento e registrar log; (b) sobrescrever a F2D com o valor do SAP; (c) aceitar o valor do Configurador e apenas registrar a divergência. | A opção (b) rompe a rastreabilidade do Configurador e exige aceite formal do risco. Ver `upgrade-sap-scj-ip040-ibs-cbs-1.md` REQ-003. | código |

---

### Não são questões fiscais

Para a pauta não se misturar, os pontos abaixo **não** dependem da área fiscal, embora também estejam pendentes:

- **Leiaute posicional do TXT Mastersaf NF-e** e **leiaute Mastersaf DW 2027** — fornecedor.
- **Release/patch da TOTVS** e a estrutura do XML intermediário para as tags novas — TOTVS, mais a inspeção de uma nota em homologação.
- **Estratégia de remerge do `nfesefaz.prw`** — decisão técnica e de contrato.
- **`F2D_TABELA` (`'SFT'` × `'SD1'/'SD2'`) e identificação do tributo (`F2B_TRIB` × `ZZ_TRIB*`)** — confirmação em ambiente.
- **Largura dos campos `F1_ZZDSNFE`/`F2_ZZDSNFE`** para as descrições de rejeição de 2027 — dicionário.
- **`IND_COMPRA_VENDA` sempre vazio** nas SAFX — defeito a confirmar rodando a query.
- **Compilação e teste de regressão** de tudo que foi alterado em 18/11/2026.

---

## 8. Execução de 21/11/2026 — Fase 0 da reconciliação

Branch `wjr_rtc_2027`, commit `de5e98f`. Detalhe em `C:/Users/baco_/.claude/plans/workspace-protheus-prd-20260707-plan-qu-parsed-meerkat.md`.

### 8.1 PREMISSA-01 como regra de escopo

Reafirmada pelo usuário e aplicada a **toda** questão do Mastersaf: o XML vem pronto e correto do `nfesefaz`. Daí a divisão:

| Camada | Responsabilidade | De quem |
|---|---|---|
| `nfesefaz.prw` | decidir o conteúdo do XML segundo a NT | TOTVS / pacote |
| `ProcMsaNFe` / `ProcRCOMsa` | **mapear fielmente XML → TXT** | **DHL** |
| Mastersaf | montar e transmitir o XML final | fornecedor |

Consequência: o mapper **não** implementa a matriz de tributação nem a de referenciamento, e **não** calcula valor líquido. Se o grupo não vier no XML, `retValTax()` devolve `""`, o TXT recebe linha vazia e o Mastersaf omite a tag — mecanismo já validado em produção.

### 8.2 Três defeitos que impediam a compilação

Nada do trabalho de 18/11 compilava. Corrigidos:

1. **`SetPrvt` com literal não terminado** nos dois mappers — a string fechava depois de `ovItem` e os 7 nomes novos ficavam como identificadores nus. Erro no script que aplicou a alteração.
2. **`ZZ_TRIBICM` com default `"ICM"`** — o `<codigo>` do ICMS no XML é `"ICMS"`. Com o valor errado, `vICMSPrevisto` sairia sempre vazio.
3. **`getTpCompl()` devolvia 1 dígito** (`"3"` em vez de `"03"`). **Função removida**: o `nfesefaz:7782-7792` já emite `tpNFDebito`/`tpNFCredito` com `padl(...,2,'0')` e gate `lRefTribCo`.

### 8.3 O mapper parou de descartar dado pronto

Os cinco campos que o mapper fixava e o `nfesefaz` já emite:

| Campo | Antes | Agora |
|---|---|---|
| `indPres` | `"0"` fixo | lê do XML, com fallback `"0"` em `If/Else/EndIf` explícito |
| `tpNFDebito` / `tpNFCredito` | `EMPTY_VALUE` | lê do XML |
| `cMunFGIBS` | `EMPTY_VALUE` | lê do XML |
| `indIntermed` | `EMPTY_VALUE` | lê do XML |

Isso encerra a questão 9 do fiscal (`indPres`) sem depender de decisão.

### 8.4 Risco de regressão eliminado

- **`vUnComLiq`/`vProdLiq` retirados do bloco `EXTIPI`.** O bloco é existente: a inserção deslocava **14 campos de todas as notas**, para gravar valor que hoje não tem origem. As funções permanecem no fonte, prontas para religar quando o leiaute confirmar o offset.
- **Os 7 grupos novos ganharam gate `lRefTribCo`.** Nota anterior a `MV_RTC55` passa a produzir TXT **byte-idêntico** ao atual — o que torna o teste de regressão objetivo.

### 8.5 Alinhamento com o ajuste Agility da pasta `merge/`

A revisão fiscal usou o `merge/`, não a Produção — confirmado: zero ocorrências de DFe referenciado em `merge/ProcRCOMsa.prw`, 8 em `merge/ProcMsaNFe.prw`, exatamente a assimetria relatada.

- `DoDFeReferenciado` → **`DoDfeReferenciado`**, tag **`dfe_referenciado`**, adotando a grafia do Agility. Identificadores AdvPL são case-insensitive: manter as duas geraria função duplicada no merge.
- Leitura resiliente a nó **objeto ou array** — se o `nfesefaz` emitir N referências, o `:text` direto quebraria.
- Os 7 marcadores novos isolados em `#define` no topo do fonte: a confirmação do leiaute vira 1 token em 1 lugar.
- **Propagado para o `ProcRCOMsa`**, que não o tinha.

### 8.6 SAFX

- **`getIndFisJur` da classe base renomeado para `indFisJurPorTipo`** em 26 fontes. `SAFX010/DHLSafx010.prw:27` declara método homônimo com outra assinatura e **sobrescrevia o da base em silêncio**, sem erro de compilação.
- **`ZZ_SFXMOVR` revertido das 7 queries** — elas voltam a ser idênticas a produção. O parâmetro único não comportava a regra: o discriminante é o subtipo (`F*_TPCOMPL`), que **não existe na SF3**. Substituído por `DHLSafx:tpMovtoFiscal()`, que lê o subtipo de SF1/SF2 apenas quando `F3_TIPO $ "5|6"` e consulta `ZZ_SFXDEV` (default `"5-3;5-6;6-9"`, conforme o anexo 8). Fora de 5/6 devolve o valor da query — zero mudança de comportamento.

### 8.7 Validação feita

Integridade byte a byte nos 29 fontes: CP-1252 preservado, zero bytes UTF-8, zero U+FFFD, contagem de acentos idêntica ao backup. Diffs dos dois mappers comparados entre si — **idênticos**. Conjuntos de funções iguais salvo as 8 exclusivas do fluxo RCO. Blocos `If`/`EndIf` e `For`/`Next` balanceados no código novo. Zero `IIF`/`If()` inline e zero `ConOut` introduzidos.

**Não compilado.** É o próximo passo e não é opcional.

### 8.8 Parâmetros

`ZZ_RTCAUDI` (.T.), `ZZ_TRIBIS` ("IS"), `ZZ_TRIBICM` (**"ICMS"**, corrigido), `ZZ_IFJCRE`/`ZZ_IFJDEB` ("2"), `ZZ_FINAJUS` (ver §7 questão 1), **`ZZ_SFXDEV`** ("5-3;5-6;6-9", novo). **`ZZ_SFXMOVR` deixou de existir.**

---

## 9. Execução de 22/11/2026 — leiaute recebido e correções aplicadas

Branch `pgr_mastersaf_scj`, commits `3103ae5`, `5c4b9cd` e `8656ca8`.

### 9.1 Dois documentos novos destravaram o projeto

| Documento | O que resolve |
|---|---|
| `ONESOURCEDFE_Layout_NFe_NFCe_4_00v4_19.xlsx` | **o leiaute posicional do Mastersaf** — era o bloqueio nº 1 |
| `TAGS reforma tribitaria + demais.xlsx` | cenários DHL por tipo de nota e de-para de origem dos campos |

Detalhamento do leiaute em `Leiaute_Mastersaf_4_19.md`.

### 9.2 O que a planilha de TAGS confirma e corrige

**Confirma o escopo** da resposta 1 do fiscal: crédito **01, 03, 04**; débito **02, 03, 04, 06**. Cada um com o cenário DHL descrito.

**Corrige a resposta 15:** o **débito 02 não é "bens e serviços para uso e consumo próprio"** — é **"Anulação de Crédito por Saídas Imunes/Isentas"**. O valor vem da apuração assistida do IBS, calculado a partir dos `cClassTrib` das notas de fornecimento emitidas. Cenário pontual, não automático.

**Outros achados relevantes:**

- O **débito 03** também exige `dest == emit` (mesmo CNPJ base), não só o 07. Cada item corresponde a um documento não processado, com a chave no grupo VC01 `DFeReferenciado` e o valor do débito em `vIBS`.
- O **débito 04** deve referenciar o **item** da nota original, aplicando a mesma `cClassTrib` e a mesma alíquota efetiva do fornecimento original.
- A **nota de crédito é gerada pelo SIGACOM** (Compras), não pelo Faturamento. A nota de débito é do SIGAFAT. Isso muda a premissa de que ambas saem do mesmo fluxo.
- **`DFeReferenciado/chaveAcesso` tem origem confirmada em `DKN_CHVNFE`**; o `nItem` vem do mesmo vínculo DKN, com campo físico ainda não confirmado.
- `vUnComLiq`, `vProdLiq`, `vProdLiqTot`, `vICMSPrevisto`, `vIBS` e `vCBS` estão todos marcados como **"Calculado"** — não há campo físico único. Confirma que o cálculo é do motor fiscal, não do mapper.
- Crédito 03 e 06 decorrem do **Ajuste SINIEF nº 8/2026**, com vigência a partir de 04/05/2026.

### 9.3 A DHL está três versões atrás no leiaute

`Includes/dhl.ch:98` grava `DHL_NFE_LAYOUT "4.16"`, que corresponde à **NT 2025.002-RTC v1.20**. O alvo do projeto é a v1.53, que corresponde à **4.19**.

| versaoLayoutDFe | NT | Produção SEFAZ |
|---|---|---|
| **4.16** (atual) | v1.20 | 06/10/2025 |
| 4.17 | v1.30 | 10/11/2025 |
| 4.18 | v1.36 e v1.40 | 03/08/2026 |
| **4.19** | v1.50, v1.51 + NT 2026.008 v1.00 | 03/11/2026 |

**O bump ainda não foi feito**, porque amarra o `ProcRSymbMsa.prw`, que compartilha o define e não produz nenhum bloco da reforma (Fase 1.5).

### 9.4 Quatro correções aplicadas, duas confirmações

| # | Item | Antes | Agora |
|---|---|---|---|
| 1 | `vUnComLiq` / `vProdLiq` | retirados na Fase 0 | bloco **`sequencia_XML_liq`** (110.01), **último elemento do `prod`** |
| 2 | `vProdLiqTot` (326a) | antes do `DoIcmsTot()` | **depois do `DovNFTot()`**, fora do `icms_Tot` |
| 3 | `ICMSPrevistoPagtoAntecip` | marcador com esse nome | **`ICMS_Previsto`** (245b.01) |
| 4 | `gEstornoCred` | só no item (324116) | **mais o de total** (355.29e), dentro do `IBSCBSTot`, após o `gMono_Tot` |
| 5 | `DoISTot()` antes do `DoIBSCBSTot()` | — | ✅ já estava correto (355.1 < 355.4) |
| 6 | `DoIS()` depois do `DoISSQN()` | — | ✅ já estava correto (324.01 > 319) |

Ordem final no `MountTags`, conferida contra o leiaute:
`DoRetTrib → DoISTot → DoIBSCBSTot → … → DogMonTot → DogEstCredTot → DovNFTot → DovProdLiqTot`

**O princípio do fornecedor valida a Fase 0.** Citação literal da planilha: *"Campos novos posicionados ao final de cada bloco, para evitar impacto em integrações já existentes."* Era exatamente o motivo de ter revertido a inserção no meio do `EXTIPI`.

⚠️ **Alerta do fornecedor:** o `vProdLiqTot` **mudou de posição** entre a prévia de 15/10/2026 e a versão final — antes ficava no fim do `icms_Tot`, após o `vTotTrib`. Quem tiver adaptado alguma integração à prévia precisa reposicionar.

### 9.5 Reconciliação de branch

A Fase 0 havia sido commitada em `wjr_rtc_2027` enquanto o trabalho corrente estava em `pgr_mastersaf_scj` — por isso as alterações não apareciam. Mesclada, com 27 conflitos resolvidos pela versão da Fase 0. Os marcadores foram renomeados para `Pablo Regis` em 154 pontos.

### 9.6 Validação

Integridade conferida: CP-1252 e CRLF preservados, zero bytes UTF-8, zero U+FFFD, 69 acentos em cada mapper. As 73 linhas alteradas são **idênticas** nos dois fontes — a ordem dos hunks difere apenas porque o `ProcRCOMsa` tem 8 funções exclusivas. Nove gates `lRefTribCo`.

**Nada compilado.** Segue sendo o próximo passo obrigatório.

### 9.7 Pendências que estes documentos criam

1. **Bumpar `DHL_NFE_LAYOUT` para `"4.19"`** — tratar antes o `ProcRSymbMsa`.
2. **Débito 02 precisa ser remodelado** como anulação de crédito por saídas imunes/isentas, não como uso e consumo próprio.
3. **A nota de crédito vem do SIGACOM** — confirmar se o fluxo Mastersaf cobre documentos de entrada gerados por Compras.
4. **`nItem` do `DFeReferenciado`** — campo físico no vínculo DKN ainda não confirmado.

---

## 10. Execução de 28/11/2026 — validação do TXT gerado contra o leiaute 4.19

Primeira validação de um arquivo **realmente gerado** pela interface: `plan/Gerado.txt`, uma NF-e 55/102/226180 de remessa por conta e ordem (CFOP 5923), emitida em 26/11/2026 em homologação (`tpAmb=2`).

### 10.1 Troca da fonte de referência da validação

A validação passa a usar **apenas** dois documentos:

| Fonte | Papel |
|---|---|
| [Layout_Envio_NFe_NFCe_4.00_DFe_4.19.md](Layout_Envio_NFe_NFCe_4.00_DFe_4.19.md) | Extração integral da aba `Envio NFe_NFCe - 4.00 -DFe 4.19`: árvore de blocos, ocorrência, tipo, tamanho, decimais, `Observação` e `Obs. integração` de cada um dos 918 campos. É a autoridade. |
| [Leiaute_Mastersaf_4_19.md](Leiaute_Mastersaf_4_19.md) | Confronto posicional dos blocos da Reforma Tributária e regras de cálculo. |

O [Inventario_Tags_NFe_2027.md](Inventario_Tags_NFe_2027.md) **sai da cadeia de validação**. Ele foi derivado do `HTMLConsolidado.xml` (11 cenários) e afirmava que `vUnComLiq`, `vProdLiq` e `vProdLiqTot` eram exigidos em **todos** os cenários. O leiaute diz o contrário:

- `sequencia_XML_liq` (110.01) tem ocorrência **0-1** — bloco opcional;
- `vProdLiqTot` (326a) é **0-1** e sua observação é explícita: *"Deve ser informado quando algum item informar `vProdLiq`"*;
- a vigência da NB01-30 é **homologação 01/02/2027, produção 01/03/2027** ([Leiaute_Mastersaf_4_19.md](Leiaute_Mastersaf_4_19.md) §5).

Ou seja: o valor líquido ainda **não** é exigência de produção, e `vProdLiqTot` vazio é o comportamento **correto** enquanto nenhum item informar `vProdLiq`. O inventário continua válido como mapa de cenários fiscais — não como critério de conformidade de leiaute.

> ⚠️ **Numeração.** O [Leiaute_Mastersaf_4_19.md](Leiaute_Mastersaf_4_19.md) numera as linhas como **linha do TXT − 1**. As 12 afirmações posicionais daquele documento foram conferidas uma a uma contra a reconstrução desta seção e **todas as 12 batem** com esse offset (`sequencia_XML_liq` 358→359, `vUnComLiq` 359→360, `vProdLiq` 360→361, `vNFTot` 1232→1233, `vProdLiqTot` 1233→1234, `ICMS_Previsto` 758→759, `vICMSPrevisto` 759→760, `IS` 900→901, `CSTIS` 901→902, `vIS` item 907→908, `ISTot` 1192→1193, `vIS` total 1193→1194). Daqui para frente, usar sempre a numeração do TXT.

### 10.2 Método — reconstrução verificável das 1.399 linhas

O documento de leiaute lista os campos diretos de cada bloco **separados** dos seus sub-blocos, então a leitura direta não dá a ordem física do arquivo (em blocos como `prod` os campos vêm antes **e depois** dos sub-blocos). A sequência foi reconstruída assim:

1. O **Índice de blocos** dá a linha da planilha de cada um dos 240 blocos; linha do TXT = linha da planilha − 12.
2. A **Estrutura hierárquica** dá a árvore em pré-ordem e o número de campos de cada bloco.
3. `span(bloco) = 2 + campos + Σ span(filhos)` fecha a extensão de cada bloco.
4. Dentro de um bloco, os filhos ocupam faixas já conhecidas; as linhas livres restantes recebem os campos do bloco **na ordem da tabela de detalhamento**.

**Auto-verificação — tudo fechou sem ajuste manual:**

| Verificação | Resultado |
|---|---|
| Blocos na árvore × no índice × no detalhamento | 240 = 240 = 240 |
| Campos somados na árvore × tabelados no detalhamento | 918 = 918 |
| Nome, ordem e pai de cada bloco (árvore × índice) | consistentes |
| Linha calculada × linha declarada, para os 240 blocos | **zero divergência** |
| Total de linhas | `span(nota)` = 1.398 + `--arquivo_fim--;` = **1.399** |
| Linhas sem registro | nenhuma |

### 10.3 Resultado geral

| | Canônico 4.19 | `Gerado.txt` |
|---|---:|---:|
| Linhas | 1.399 | 1.285 |
| Blocos | 240 | 218 |

O delta de **114 linhas** decompõe-se exatamente em:

- **105 linhas** de **22 blocos** inteiros não gerados;
- **9 linhas de campo** ausentes **dentro de blocos que são gerados** — essas são as que desalinham a leitura posicional.

Nenhuma linha excedente: o arquivo não tem nada que o leiaute não preveja, todas as 1.285 linhas terminam em `;`, é ASCII puro com CRLF, e fecha com `--nota_fim--;` + `--arquivo_fim--;`.

### 10.4 Blocos obrigatórios — nenhuma ausência indevida

Aplicando as **Regras gerais** do leiaute:

> R1 — Bloco não obrigatório: não é gerado quando os campos de integração estão vazios.
> R2 — Bloco obrigatório (principal): é gerado com tag fechada quando os campos estão vazios.
> R3 — Bloco principal obrigatório com subcampos vazios: apenas o bloco principal é gerado; os subblocos (mesmo obrigatórios) são ignorados.
> R4 — Campos zerados (0.00) são incluídos no XML.

Dos 22 blocos ausentes, **3 têm ocorrência obrigatória** — e os 3 estão amparados:

| Bloco | Ocor | Linha | Situação |
|---|---|---:|---|
| `gPgto` | 1-99 | 1323 | pai `gPgtoVinc` é gerado vazio → **R3** |
| `defensivo` | 1-20 \| CG | 1387 | pai `agropecuario` também ausente → coerente |
| `guiaTransito` | 1-1 \| CG | 1391 | pai `agropecuario` também ausente → coerente |

Os outros 19 são todos `0-x` e a omissão é exatamente o que a **R1** manda: `gCompraGov`, `ref_NFe` (do `gCompraGov`), `gPagAntecipado`, `gCred`, `origComb`, `x_icms_efetivo` (×3, em `icms_60`, `icms_st` e `icms_sn500`), `sequencia_XML_op`, `sequencia_XML_fcpdif`, `sequencia_XML_deson`, `sequencia_XML` (do `seqSeletivo`), `gALCZFMCBS`, `DFeReferenciado`, `sequencia_XML_detPag`, `infIntermed`, `infRespTec`, `seq_XML` e `agropecuario`.

> **Correção de uma afirmação anterior.** `infRespTec` tem ocorrência **0-1** neste leiaute — não é bloco obrigatório do TXT, e sua omissão não viola o leiaute. A obrigatoriedade do grupo `infRespTec` no XML perante a SEFAZ é questão à parte, a confirmar com o fornecedor: o integrador pode preenchê-lo por cadastro próprio. Não tratar como defeito de integração sem essa confirmação.

### 10.5 O problema é o inverso: 120 blocos opcionais gerados vazios

A **R1** é violada em larga escala: **120 blocos de ocorrência `0-x` são gerados sem nenhum conteúdo**. Em **97** deles há campos de ocorrência `1-1` emitidos vazios dentro — situação que o leiaute só admite para bloco **obrigatório** (R2).

Exemplos representativos (bloco → campos `1-1` vazios):

| Bloco | Linha no gerado | Campos `1-1` vazios |
|---|---:|---|
| `sequencia_XML_liq` | 337 | `vUnComLiq`, `vProdLiq` |
| `x_contingencia` | 52 | `dhCont`, `xJust` |
| `avulsa` | 111 | `CNPJ`, `xOrgao`, `matr`, `xAgente`, `UF`, `repEmi` |
| `retirada` / `entrega` | 148 / 166 | `CNPJ`, `CPF`, `xLgr`, `nro`, `xBairro`, `cMun`, `xMun`, `UF` |
| `ISSQN` | 827 | `vBC`, `vAliq`, `vISSQN`, `cMunFG`, `cListServ`, `indISS`, `indIncentivo` |
| `IS` / `seqSeletivo` | 845 / 848 | `CSTIS`, `cClassTribIS` / `vBCIS`, `pIS`, `vIS` |
| `gTribRegular` | 907 | 8 campos |
| `gMonoPadrao` (×4) | 929/948/972/991 | 3 a 6 campos cada |
| `ICMS_Previsto` | 703 | `vICMSPrevisto` |
| `ISTot` | 1116 | `vIS` |

O padrão é claro: o gerador emite **toda** a árvore do leiaute e preenche o que tem. O leiaute pede o contrário — omitir o bloco opcional vazio. Não há evidência de que o integrador rejeite o arquivo por isso (ele é posicional e a estrutura completa é inequívoca), mas duas consequências são concretas:

1. **É a razão de o arquivo não ter 1.399 linhas.** Com 120 blocos opcionais emitidos e 22 omitidos, o critério de emissão é **inconsistente** — e cada bloco omitido que o integrador espere encontrar desloca a leitura.
2. **`sequencia_XML_liq` é o caso a decidir já**: ou se preenche `vUnComLiq`/`vProdLiq`, ou o bloco não deve ser gerado. Hoje ele sai com dois campos `1-1` vazios. Enquanto a NB01-30 não entrar em vigor (01/03/2027), **não gerar** é a opção aderente à R1.

**Pendência de fornecedor (PEND-LAY-01):** confirmar com o ONESOURCE DF-e se o integrador aceita a árvore completa com blocos opcionais vazios ou se exige a aplicação estrita da R1. A resposta define se as 120 ocorrências são dívida técnica tolerável ou correção obrigatória.

### 10.6 Choice Groups emitidos simultaneamente

O leiaute marca alguns blocos como `CG` — *Choice Group*, escolha exclusiva entre irmãos. O gerado emite **todos os irmãos**, vazios:

| Pai | CG irmãos emitidos juntos |
|---|---|
| `sequencia_XML_IBSCBS` | `gIBSCBS`, `gIBSCBSMono`, `gTransfCred`, `gAjusteCompet` |
| `sequencia_XML_cred_pres` | `gCredPresOper`, `gCredPresIBSZFM` |
| `sequencia_XML_IBSMono` | `gIBSMonoAdRem`, `gIBSMonoAdValorem` |
| `sequencia_XML_CBSMono` | `gCBSMonoAdRem`, `gCBSMonoAdValorem` |

Nenhum tem conteúdo nesta nota (CST 410), então não há ambiguidade **neste** arquivo. Mas quando um deles passar a ser preenchido, os irmãos vazios precisam deixar de sair — caso contrário o integrador recebe duas alternativas de um grupo exclusivo.

O mesmo vale para o par **CE – Choice Element** do `nfReferenciada`: `refNFe` (29x.2) e `refNFeSig` (29x.2a) são marcados *"CE – Choice Element (escolha entre elementos)"* na coluna `Obs. integração`, e o gerado preenche **os dois** (ver 10.7, item 3).

### 10.7 Oito defeitos de conteúdo

**1. Linha 146 — `email` do `dest` (79a) usa `;` como separador.** O leiaute é explícito na `Obs. integração`: *"Para informar mais de um e-mail, os mesmos deverão ser separados **SOMENTE por , (vírgula)**"*. O gerado traz:

```
ARQUIVO.NFE@SCJ.COM,arquivo.nfe@scj.com;BR.DSC.FISCAL@DHL.COM;
```

O `;` é o terminador de campo do TXT: o integrador lê **dois campos** e desloca o resto do bloco `dest`. Além disso são 61 caracteres contra `Tam. 1-60`. Trocar o `;` por `,`.

**2. Linha 1166 — `xNome` da transportadora (361) com entidade XML `&#39;`.**

```
UNIDOCK&#39;S ASSESSORIA E LOGITICA DE MATER;
```

O `;` que fecha a entidade quebra o bloco `transporta` do mesmo modo. No TXT o valor deve ser literal (`UNIDOCK'S`) — o escape para XML é do integrador.

**3. Linha 58 — `refNFeSig` (29x.2a) com 44 zeros, e preenchido junto com `refNFe`.** Dois problemas:

- `refNFe` e `refNFeSig` são **CE – Choice Element**: informa-se **um ou outro**, nunca ambos. O gerado traz a chave real na linha 57 **e** o `refNFeSig` na 58.
- A descrição do campo é *"Referencia uma NF-e (modelo 55) emitida anteriormente pela sua Chave de Acesso **com código numérico zerado**, permitindo manter o sigilo da NF-e referenciada."* Isso é a chave de 44 posições com os **8 dígitos do `cNF` zerados** e o DV recalculado — **não** 44 zeros.

Origem: [ProcMsaNFe.prw:5992](../PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw#L5992), repetido em 5996 e 5999 — `Replicate("0",44)` incondicional. Correção: não emitir `refNFeSig` quando `refNFe` for informado.

**4. `cNF` divergente da chave de acesso.** A linha 7 (`id`, 47 posições, *"chave de acesso precedida do literal 'NFe'"*) traz a chave `...100452934` + DV `1`, cujo `cNF` embutido é `00452934`. A linha 27 (`ide/cNF`) traz `53831897`.

A chave é **internamente consistente**: o DV calculado por módulo 11 base 2,9 sobre os 43 dígitos dá **1**, igual ao informado. Com `cNF = 53831897` o DV seria **0**. Logo o campo errado é o `ide/cNF`.

São duas fontes independentes: `id` é montado de `cKeyInv` ([ProcMsaNFe.prw:256](../PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw#L256)) e `cNF` vem de `retValueAttribute("infnfe:_ide:_cNF:text")` ([:280](../PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw#L280)). Extrair o `cNF` das posições 36-43 da própria `cKeyInv` elimina a divergência por construção.

**5. Linha 50 — `verProc` (29b) vazio.** `Caractere`, `Tam. 1-20`, ocorrência **1-1**, em bloco `ide` preenchido. *"Informar a versão do aplicativo emissor de NF-e."*

**6. Linha 1099 — `dCompet` (347a) vazio.** `Numérico 8`, ocorrência **1-1**, dentro de `issqn_Tot` que está sendo gerado com todos os totais em `0.00`. Como `issqn_Tot` é `0-1` e não há serviço na nota, o bloco não deveria ser emitido (R1); emitido, o `dCompet` precisa de valor.

**7. Linha 1223 — `vPag` (398c) sem decimais.** Sai `0`; a `Obs. integração` diz *"15 posições, sendo 13 inteiros e 2 decimais"*. Deve ser `0.00`.

**8. Três `1-1` vazios que NÃO são defeito.** `emit/CPF` (31a, linha 87), `dest/CPF` (64, linha 126) e `dest/idEstrangeiro` (64a, linha 127) aparecem como ocorrência `1-1`, mas são alternativas excludentes do `CNPJ` — que está preenchido nos dois blocos. A planilha marca `CNPJ` e `CPF` ambos como `1-1` no mesmo bloco, o que só se explica como escolha de schema. **Não alterar.**

### 10.8 Nove linhas de campo ausentes em blocos que são gerados

Essas são as que desalinham a leitura posicional. Confirmado por varredura no fonte: `indDoacao`, `ISUFEmit`, `pDevTrib`, `vBCCredPres` e `cCredPres` **não existem** em `ProcMsaNFe.prw` — são campos da 4.19 nunca implementados.

| Linha canônica | ID | Campo | Ocor | Bloco (linha no gerado) | Bloco preenchido? |
|---:|---|---|---|---|---|
| 121 | 49d | `ISUFEmit` | 0-1 | `emit` (85) | **SIM** |
| 580 | 237.1a | `cBenefRBC` | 0-1 | `x_icms90_icms` (546) | não |
| 918 | 324.14a | `indDoacao` | 0-1 | `IBSCBS` (855) | **SIM** |
| 931 | 324.24a | `pDevTrib` | 0-1 | `gDevTrib` do `gIBSUF` (869) | não |
| 947 | 324.43a | `pDevTrib` | 0-1 | `gDevTrib` do `gIBSMun` (884) | não |
| 963 | 324.62a | `pDevTrib` | 0-1 | `gDevTrib` do `gCBS` (899) | não |
| 1099 | 324121 | `vBCCredPres` | 1-1 | `gCredPresOper` (1028) | não |
| 1100 | 324122 | `cCredPres` | 1-1 | `gCredPresOper` (1028) | não |
| 1115 | 324134 | `vCredPresIBSZFM` | 1-1 | `gCredPresIBSZFM` (1040) | não |

Os dois primeiros casos de bloco **preenchido** são os de risco imediato: `ISUFEmit` no `emit` e `indDoacao` no `IBSCBS`. Os `gDevTrib` emitem 1 linha onde o leiaute prevê 2 (`pDevTrib` + `vDevTrib`); a ausente é `pDevTrib`, campo novo da 4.19.

### 10.9 O que está correto

As três correções de posicionamento aplicadas em 22/11/2026 (§9.4) estão **confirmadas no arquivo gerado**:

- `sequencia_XML_liq` como último elemento do `prod`, imediatamente antes de `--prod_fim--` → linhas 337-340;
- `vProdLiqTot` **depois** do `vNFTot` e **fora** do `icms_Tot` → linhas 1156-1157, exatamente a mudança que a planilha alerta em relação à prévia de 15/10/2026;
- `cIndOp` (29.6) após `verProc`/29b → linha 51.

Também conferem:

- os **30 campos do `icms_Tot`** alinham 1:1 com as linhas 1140-1168 do leiaute;
- a ordem do `total`: `icms_Tot` → `issqn_Tot` → `ret_Trib` → `ISTot` → `IBSCBSTot` → `vNFTot` → `vProdLiqTot`;
- a chave referenciada da linha 57 tem **DV válido** (5) e bate com o `infCpl` (NF 000006767, série 042, 26/05/2026, CNPJ 33.122.466/0007-04, AM);
- aritmética do item: `qCom × vUnCom = vProd` (189.310,54), `vBC × 18% = vICMS` (34.075,90), `vProd = vNF = vNFTot = vItem`;
- `IPI` CST 55 com `cEnq` 103, coerente com o `infCpl` ("IPI suspenso conf. Art. 43 inciso III do RIPI");
- `IBSCBS` com `CST 410` e `cClassTrib 410029` — os 3 primeiros dígitos do `cClassTrib` batem com o CST, e `gIBSCBS` vazio + `IBSCBSTot` zerado são coerentes com não incidência;
- `vProdLiqTot` vazio é **correto** (nenhum item informa `vProdLiq`);
- `infCpl` com 646 caracteres, dentro do limite;
- `tPag = 90` (sem pagamento), coerente com remessa.

### 10.10 Correções a fazer no `ProcMsaNFe.prw`

Em ordem de severidade:

1. `email` do `dest`: separador `,` em vez de `;`, e truncar/validar em 60 posições.
2. `xNome` da `transporta` (e qualquer campo texto): remover entidades XML (`&#39;`, `&amp;`, …) antes de gravar o TXT.
3. `refNFeSig`: não emitir junto com `refNFe` (CE) e, quando emitir, gerar a chave com o `cNF` zerado e DV recalculado — não `Replicate("0",44)`.
4. `ide/cNF`: extrair das posições 36-43 de `cKeyInv`, em vez de ler de outra fonte.
5. `verProc`: preencher com a versão do emissor.
6. `issqn_Tot`: não emitir quando não houver serviço; se emitir, preencher `dCompet`.
7. `vPag`: formatar com 2 decimais.
8. Implementar as 9 linhas ausentes — prioridade em `ISUFEmit` (`emit`) e `indDoacao` (`IBSCBS`), que estão em blocos preenchidos.
9. Decidir `sequencia_XML_liq`: não gerar até a vigência da NB01-30 (01/03/2027).
10. Após PEND-LAY-01, decidir sobre as 120 violações da R1 e os CG irmãos.

### 10.11 Reprodutibilidade

A reconstrução e a comparação são scripts determinísticos sobre os dois documentos de leiaute e o `Gerado.txt`, sem leitura da planilha binária: `build_ref419.py` (reconstrói e auto-verifica as 1.399 linhas), `compara419.py` (alinhamento e defeitos de conteúdo) e `obrigatoriedade.py` (análise das regras R1-R4). Devem ser reexecutados a cada novo TXT de teste.
