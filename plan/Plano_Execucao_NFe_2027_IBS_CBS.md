# Plano de execução: NF-e 2027 (IBS/CBS/IS) nos fontes DHL

- **Data:** 18/11/2026
- **Escopo:** somente análise. Nenhum fonte foi alterado.
- **Entradas da análise:**
  - Planilha `Fontes DHL para Analise.csv`, com fontes, frentes, entregas e consultores.
  - `HTMLConsolidado.xml`, com 11 exemplos de NF-e 2027 baseados na NT 2025.002 v1.53 e na NT 2026.008 v1.01.
  - `Analise_IBS_CBS_IP040_PrcGrvRco.md` — pendências de IBS/CBS na interface IP040 e na desoneração ZFM.
  - `Analise_PrcGrvRco.md` — fluxo, restrições e comportamentos silenciosos do `PrcGrvRco.prw`.
  - `ERBFIS01.prw` — **apenas referência** do padrão de leitura de tributos (F2D × F2B × CJ3). Não é fonte do projeto e não é entregável.
- **Raiz dos caminhos:** `Workspace_Protheus_Prd_20260707/PROTHEUS/Producao/`

> Os fontes estão gravados em Windows-1252. Qualquer ajuste futuro precisa manter essa codificação.

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

## 1. Inventário dos fontes da planilha

### 1.1 Entrega 1: OUTBOUND / NF-e (MasterSaf) e SAP SC Johnson (9 fontes)

| # | Fonte | Pasta | Linhas | Consultor |
|---|---|---|---|---|
| 1 | ProcMsaNFe.prw | Mastersaf_NFe | 5341 (a planilha diz 5375) | Wellington |
| 2 | ImpMsaNfe.prw | Mastersaf_NFe | 2047 | Pablo |
| 3 | PrcXmlNfe.prw | Mastersaf_NFe | 183 | Wellington |
| 4 | TagProcRef.tlpp | Mastersaf_NFe | 58 | Pablo |
| 5 | MsafNFeFile.prw | Mastersaf_NFe | 192 | Pablo |
| 6 | MsafNFeTag.prw | Mastersaf_NFe | 170 | Pablo |
| 7 | PrcGrvRco.prw | SAP/SCJ | 420 | Wellington |
| 8 | PrcNfRco.prw | SAP/SCJ | 615 | Pablo |
| 9 | PrcNfRet.prw | SAP/SCJ | 675 | Pablo |

### 1.2 Entrega 7: Desenvolvimento SAFX (Wellington), 6 fontes existentes

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
2. **Consultor diferente para "SAFX07MSDW (PKG)".** A primeira tabela da planilha diz Pablo e a segunda diz Wellington.
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
// INICIO Wellington 18/11/2026
If cFinNfe $ "5|6"
    ...
EndIf
// FIM Wellington 18/11/2026
```

Alteração de uma única linha usa a forma curta, sem o `FIM`:

```advpl
oProd:setAttributeValue("vProdLiq", ...)  // Wellington 18/11/2026
```

Regras de uso:

1. **O nome é o do autor da alteração**, sempre na mesma grafia: `Wellington` ou `Pablo`. O marcador é chave de busca — grafias diferentes para a mesma pessoa inutilizam a auditoria.
2. **A data entra nas duas linhas do bloco**, no `INICIO` e no `FIM`, no formato `DD/MM/AAAA`. É a data da alteração, e as duas linhas repetem a mesma data.
3. **Função ou método novo não usa marcador inline.** A autoria vai no bloco `/*/{Protheus.doc}` exigido pelo padrão do projeto, com `@author` e `@since`.
4. **Sem acentos no marcador.** Os fontes são CP-1252 e serão editados por duas pessoas em dezenas de arquivos; acento em comentário é onde um save acidental em UTF-8 aparece primeiro. Escreva `alteracao`, `credito`, `calculo`.
5. **Alteração replicada em fonte espelhado leva o mesmo marcador com a mesma data.** Vale para o par `ProcMsaNFe.prw` / `ProcRCOMsa.prw` e para as variantes por filial das Entregas 7 e 8.

Auditoria da pegada do projeto:

```bash
grep -rn "INICIO Wellington\|INICIO Pablo" --include=*.prw --include=*.tlpp .
```

### Fase 0: Pré-requisitos

> Por **PREMISSA-01**, o item 1 **não é bloqueante**: é um controle de verificação que corre em paralelo às Fases 1 e 2. Os itens 2 (remerge do `nfesefaz.prw`), 3 e 4 (leiautes de terceiros) são **bloqueantes**.

1. **Verificar o pacote TOTVS e instrumentar a ausência de tag (não bloqueante).**
   - Registrar release/patch instalado e a versão de NT que ele declara atender, com data. Gerar o XML de uma nota em homologação e inspecionar as tags de PREMISSA-01, produzindo uma **lista de tags confirmadas × ausentes**.
   - Implementar o **controle compensatório**: rotina de auditoria de tags que, para documentos com `dDataBase >= MV_RTC55`, registra via `FWLogMsg()` cada tag esperada que voltou vazia de `retValueAttribute()`. Sem esse log, a premissa converte um item bloqueante em defeito silencioso (ver Riscos, item 1).
   - Toda tag que permanecer ausente após a data de corte vira **pendência formal junto à TOTVS**, não trabalho de customização na DHL.
2. **Definir a estratégia de remerge do `nfesefaz.prw` (bloqueante para a PREMISSA-01).** Levantar o diff do fork contra o fonte padrão da release-alvo, dimensionar o remerge, definir dono e prazo, e escolher a estratégia: remerge do fork, redução da customização a pontos de entrada, ou adoção do padrão com overrides. Até essa definição, a PREMISSA-01 permanece **assumida, não verificada**. Restrição obrigatória: preservar `IsInCallStack("U_PrcGrvRco")`/`("U_PrcNfRco")` (linhas 3026 e 3488) que alteram o XML da AG2.
3. **Obter o leiaute TXT atualizado do Mastersaf NF-e**, com a posição de cada campo novo. **(bloqueante)**
4. **Obter o leiaute do Mastersaf DW para o SAFX3007 e o SAFX3008.** **(bloqueante)**
5. **Levar ao fiscal as decisões que o próprio XML deixa em aberto:**
   - CFOPs provisórios (5949, 1949, 5927), a confirmar no Ajuste SINIEF 49/2025;
   - uso do CST 08 de PIS/COFINS em 2027;
   - cClassTrib da nota de ajuste só de ICMS;
   - se o `gAjusteCompet` entra no `vItem`;
   - alíquotas reais de CBS e IS (no XML elas são hipotéticas: 8,80% e 2%).
6. **Definir quais tipos de nota a DHL vai emitir de fato.** Isso diz quais dos 11 cenários entram no escopo.

### Fase 1: ProcMsaNFe, cabeçalho e referências (Wellington)

1. **Ampliar o `getFinNfe` para finNFe 5 (crédito) e 6 (débito).** É preciso definir de onde vem a finalidade: um campo novo, `F2_ZZTPNF`, a TES ou o XML TOTVS.
2. **Preencher `tpNFDebito`, `tpNFCredito` e `cMunFGIBS`.** Hoje estão fixos em `EMPTY_VALUE`. O `cMunFGIBS` só é usado com indPres=5 e sem endereço do destinatário.
3. **Derivar `indPres` da finalidade**, no lugar do valor fixo "0".
4. **Criar `DoDFeReferenciado` no item**, respeitando as regras de cada tipo:
   - a referência vai no cabeçalho **ou** no item, nunca nos dois (VC02-05, rejeição 1010);
   - é obrigatória no crédito 06 e nos débitos 03 e 04 (VC02-10, rejeição 1038);
   - `nItem` é proibido no débito 03 (VC03-10, rejeição 1039);
   - a nota de crédito 03/04 não aceita DFeReferenciado (VC02-07, rejeição 1042);
   - a chave deve ser a mesma em todos os itens (VC02-30, rejeição 1130), exceto nos débitos 03 e 07.
5. **Criar o `gPagAntecipado`**, para a nota que abate um débito 06.
6. **Ajustar o `DoAllRef`.** Em finNFe 2 e em crédito 03/04 deve ir exatamente uma `refNFe` (B25-30/B25-40, rejeições 254/255). Também é preciso rever o laço que hoje gera várias referências.

### Fase 2: ProcMsaNFe, item e totais (Wellington)

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

### Fase 3: Origem dos dados, SAP SC Johnson (Pablo e Wellington)

1. **PrcGrvRco (Wellington).** Ajustar ou recalcular a F2D depois que os valores são regravados na desoneração ZFM. Sem isso, a base do IBS/CBS (`vProd - vICMS + vIS`) e o `vItem` ficam diferentes do item final. O risco está documentado em `Analise_IBS_CBS_IP040_PrcGrvRco.md` §2, com o exemplo numérico (item de 1.000 com `ZB_VLDIICM` de 120 passa a 880, enquanto a F2D guarda a base antiga).

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

**Entrega 7 (Wellington)**

1. Criar os includes `safx3007.ch` e `safx3008.ch` com as posições.
2. Criar `DHLSafx3007` e `DHLSafx3008` no padrão de `DHLSafx07` e `DHLSafx08`, lendo IBS/CBS/IS da F2D e da SFT.
3. Incluir a geração em `ProcMsaDW`, `SAFX07MSDW` e `SAFX08MSDW`.
4. Avaliar se `DHLSafx112`, `DHLSafx116` e `DHLSafx2013` precisam dos campos novos, como finalidade crédito/débito e chave referenciada.

**Entrega 8 (Pablo e Wellington, conforme a planilha)**

1. Replicar nas variantes por filial:
   - AG2 (8 fontes);
   - AGL (8);
   - DI2 (2);
   - MUL (9);
   - AGE/REP (8).
2. **Decidir se a pasta DIS (8 fontes) entra no escopo.** Ela não está na planilha.

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

0. **(Novo, Alto) O fork do `nfesefaz.prw` não ser remergeado em tempo.** É a precondição da PREMISSA-01 e o maior risco de cronograma: 14.762 linhas com ~100 pontos de customização, fora do inventário das 54 fontes, sem dono nem estimativa. Enquanto não houver estratégia definida, as Fases 1 e 2 estão construindo sobre tags que ninguém se comprometeu a entregar. *Mitigação:* Fase 0, item 2.

1. **PREMISSA-01 não se confirmar — falha silenciosa.** O risco não é mais "não há de onde ler": é a tag que não se materializa e produz **campo vazio no TXT, sem erro e sem log**, porque `IpXmlObject:getNodeValue` devolve `""` para nó inexistente. A nota é montada, transmitida e só é barrada na SEFAZ. *Mitigação:* o log de auditoria de tags da Fase 0, item 1, mais o registro formal do release/patch instalado e a abertura de pendência na TOTVS para cada tag ausente. *Responsabilidade:* tag ausente é entrega da TOTVS, não customização da DHL.
2. **Leiaute posicional do Mastersaf.** Uma posição errada desloca todos os campos seguintes do TXT.
3. **Rejeições estruturais em 2027.** São finNFe 5 e 6, DFeReferenciado e `gAjusteCompet`/`gEstornoCred`. Sem elas, notas de crédito e débito serão rejeitadas.
4. **F2D desatualizada na ZFM.** O IBS/CBS sai com base errada no XML.
5. **Escopo do SAFX indefinido.** A pasta DIS e o SAFX2013MSDW estão fora da planilha, e há divergência de consultor no SAFX07MSDW (PKG).
