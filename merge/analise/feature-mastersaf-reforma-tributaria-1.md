---
goal: Corrigir e completar o mapeamento da Reforma Tributária (IS, ISTot, gRed IBS Município, bug de caminho no gIBSCBS e valor líquido) nos mappers Mastersaf ProcMsaNFe.prw e ProcRCOMsa.prw
version: 1.0
date_created: 2026-11-16
last_updated: 2026-11-16
owner: Equipe DHL - Integração Fiscal Mastersaf
status: 'Planned'
tags: [bug, feature, fiscal, reforma-tributaria, mastersaf, nfe, integracao]
---

# Introduction

![Status: Planned](https://img.shields.io/badge/status-Planned-blue)

Este plano corrige 2 defeitos e implementa 4 lacunas de mapeamento da Reforma Tributária (NT 2025.002) nos geradores de arquivo texto do Mastersaf NF-e. Os mappers `ProcMsaNFe.prw` (Mastersaf) e `ProcRCOMsa.prw` (SAP/SCJ) leem o XML intermediário produzido por `U_XmlNfeSef` (`nfesefaz.prw`) e o convertem em arquivo TXT posicional.

Conclusão da análise prévia: para o grupo **IS (Imposto Seletivo)** e para o total **ISTot**, o dado **já existe no XML intermediário** — as classes padrão da Reforma (`oXmlRefTri:GetXmlIs()` em `nfesefaz.prw:10060` e `oXmlRefTri:getXmlTotalIbsCbsIs()` em `nfesefaz.prw:10463`) já emitem esses nós. A lacuna está integralmente nos mappers. Já os campos de **valor líquido** (`vUnComLiq`, `vProdLiq`, `vProdLiqTot`) não existem em nenhum dos três fontes, exigindo definição prévia de origem.

## Fluxo de dados (contexto obrigatório para execução)

```
nfesefaz.prw (U_XmlNfeSef)                    -> gera XML intermediário proprietário
   |- oXmlRefTri:GetXmlIs(...)            L10060  <- IS já é gerado
   |- oXmlRefTri:GetXmlIbsCbs(...)        L10064  <- IBS/CBS já é gerado
   |- oXmlRefTri:getXmlTotalIbsCbsIs()    L10463  <- ISTot + IBSCBSTot já são gerados
        v  PrcXmlNfe.prw / PrcRCOXml.prw (IpXmlObject:doParse)
ProcMsaNFe.prw / ProcRCOMsa.prw               -> mapeiam XML -> objeto MsafNFeTag
        v  MsafNFeFile:createTxt
arquivo TXT Mastersaf (POSICIONAL)
```

## 1. Requirements & Constraints

### Requisitos funcionais

- **REQ-001**: Corrigir o caminho XML com dois-pontos duplo (`_Tributo::_gIBSCBS`) no ramo de `imposto` único da função `DoIBSCBSTot()`, para que `vBCIBSCBS` deixe de ser totalizado como zero.
- **REQ-002**: Corrigir a função `DogIBSMuRed()` para ler o caminho `tributo:_gIBSCBS:_gIBSMun:_gRed` em vez de `tributo:_gIBSCBS:_gIBSUF:_gRed`, de modo que a redução de alíquota do IBS Municipal deixe de replicar a do IBS Estadual.
- **REQ-003**: Mapear o grupo IS no nível do item: `CSTIS`, `cClassTribIS`, `vBCIS`, `pIS`, `vIS` (e demais campos exigidos pelo layout Mastersaf vigente).
- **REQ-004**: Mapear o total `ISTot` no nó `total`.
- **REQ-005**: Mapear os grupos `gAjusteCompet`, `gEstornoCred` e `NB01` conforme layout Mastersaf vigente.
- **REQ-006**: Mapear os campos de valor líquido `vUnComLiq`, `vProdLiq` (nível item) e `vProdLiqTot` (nível total).
- **REQ-007**: Toda alteração aplicada em `ProcMsaNFe.prw` deve ser espelhada de forma idêntica em `ProcRCOMsa.prw`.

### Requisitos fiscais

- **FIS-001**: Os campos novos devem respeitar a NT 2025.002 da NF-e quanto a nome, tipo, tamanho e obrigatoriedade.
- **FIS-002**: A geração de campos da Reforma deve observar a variável `lRefTribCo` (`dDataBase >= SuperGetMv('MV_RTC55',.f.,stod('20260105'))`), já definida em `ProcMsaNFe.prw:43`, para não alterar o comportamento de notas anteriores à vigência.
- **FIS-003**: O filtro de CST por parâmetro `MV_CSTGXML` (default `000/200/210/220/510/550/830/222`), usado em `DoIBSCBSTot()`, deve ser avaliado quanto à aplicabilidade ao IS antes de ser replicado.

### Restrições

- **CON-001**: **O arquivo TXT é posicional.** Em `MsafNFeFile.prw:102-114`, cada chamada a `setAttributeValue` gera uma linha `valor;` sem identificador de campo — apenas marcadores `--tag_ini--` / `--tag_fim--` delimitam blocos. Inserir um campo em posição incorreta desloca todo o restante do arquivo e inviabiliza a importação no Mastersaf.
- **CON-002**: O layout Mastersaf vigente (posição e ordem dos campos) **não está disponível no workspace**. Nenhuma alteração de estrutura pode ser codificada antes de obtê-lo.
- **CON-003**: O fonte das classes `totvs.protheus.backoffice.fiscal.integration.taxinformation` e `totvs.protheus.backoffice.tss.engine.xml.taxinformation` **não está no workspace** (residem no RPO). Os nomes exatos das tags emitidas por `GetXmlIs()` e `getXmlTotalIbsCbsIs()` só podem ser confirmados por inspeção de XML real.
- **CON-004**: O workspace **não é repositório Git** (`Is a git repository: false`). Não há rollback automático — backup manual dos fontes é obrigatório antes de qualquer alteração.
- **CON-005**: Fontes AdvPL devem permanecer em **CP-1252 (Windows-1252)**. Ambos os arquivos possuem acentuação em comentários; gravação em UTF-8 corrompe o fonte e o compilador RDMake.
- **CON-006**: `ProcMsaNFe.prw` e `ProcRCOMsa.prw` são aproximadamente 96% idênticos (233 linhas de diferença em ~5.400, concentradas em um bloco SAP/SCJ exclusivo ao final do `ProcRCOMsa.prw`). Divergências não intencionais entre os dois geram arquivos inconsistentes entre as integrações.
- **CON-007**: A pasta alvo é `d:\99-FONTES\DV2 - DHL\merge\`. Os números de linha deste plano referem-se a essa versão, que corresponde a Produção acrescida dos ajustes Agility (`dfe_referenciado`, `inf_intermed`, `dPrevEntrega`, notas de crédito/débito).

### Diretrizes e padrões

- **GUD-001**: Não refatorar estilo (`IIF`, `ConOut`, notação húngara ausente) junto com a correção fiscal. Misturar os dois escopos em fontes de 5.400 linhas sem versionamento dificulta o rollback.
- **GUD-002**: Não declarar `oDetNfe` como `Local` em `DoIBSCBSTot()`. A ausência de declaração é funcionalmente necessária: `fTypeVar()` encapsula `Type()`, que só enxerga variáveis Private/Public.
- **GUD-003**: Toda função nova deve receber bloco de comentário no mesmo padrão das vizinhas e documentação ProtheusDOC quando aplicável.
- **PAT-001**: Padrão de função de tag de imposto no nível do item — replicar `DoIBSCBS()` (`ProcMsaNFe.prw:4427`):
  ```advpl
  static function DoIBSCBS()
      local cTax        := "IBSCBS"
      local cAliq       := ""
      local lFormatZero := .F.
      oIBSCBS := MsafNFeTag():newMsafNFeTag("IBSCBS")
      oIBSCBS:setAttributeValue("CST"        , retValTax(cTax,cAliq, oDetProd, "CST"       , "tributo", lFormatZero))
      oIBSCBS:setAttributeValue("cClassTrib" , retValTax(cTax,cAliq, oDetProd, "cClassTrib", "tributo", lFormatZero))
      oImpostos:addElementNode(oIBSCBS)
  return
  ```
- **PAT-002**: Padrão de função de tag de total — replicar `DogIBSUFTot()` (`ProcMsaNFe.prw:4971`), que usa `retValueAttribute("infNfe:_total:_<no>:_<campo>:text", lFormatZero)`.
- **PAT-003**: A função `retValTax(cTax, cAliq, oDetProd, cTag, cNode, lFormatZero)` (`ProcMsaNFe.prw:4123`) localiza o bloco `<imposto>` cujo `<codigo>` é igual a `cTax` e lê `oTagImp:_<cNode>:_<cTag>:text`. Para o IS, usar `cTax := "IS"` e `cNode := "tributo"`.
- **PAT-004**: Toda variável de objeto de tag nova deve ser declarada no `SetPrvt` da linha 76 de ambos os arquivos.
- **PAT-005**: Toda função `Do<Tag>()` nova de item deve ser registrada em `DoAllTaxes()`; toda função de total deve ser registrada em `MountTags()`.

## 2. Implementation Steps

### Implementation Phase 1

- GOAL-001: Corrigir os dois defeitos de caminho XML sem alterar a quantidade nem a ordem de campos do arquivo TXT. Esta fase é independente das demais e pode ser executada imediatamente.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-001 | Criar backup datado de `d:\99-FONTES\DV2 - DHL\merge\ProcMsaNFe.prw` e `d:\99-FONTES\DV2 - DHL\merge\ProcRCOMsa.prw` (ver CON-004). | | |
| TASK-002 | Em `merge/ProcMsaNFe.prw`, linha **4934**, dentro de `DoIBSCBSTot()`: alterar `fTypeVar("oDetNfe:_imposto:_Tributo::_gIBSCBS:_vBC")` para `fTypeVar("oDetNfe:_imposto:_Tributo:_gIBSCBS:_vBC")` (remover um `:`). A linha 4935 imediatamente abaixo já usa o caminho correto e não deve ser alterada. | | |
| TASK-003 | Em `merge/ProcRCOMsa.prw`, linha **4936**: aplicar a mesma alteração de TASK-002. | | |
| TASK-004 | Em `merge/ProcMsaNFe.prw`, linhas **4597 e 4598**, dentro de `DogIBSMuRed()`: alterar o 5º argumento de `retValTax` de `"tributo:_gIBSCBS:_gIBSUF:_gRed"` para `"tributo:_gIBSCBS:_gIBSMun:_gRed"` nos atributos `pRedAliq` e `pAliqEfet`. Não alterar `DogIBSUFRed()` (linha 4523), que já está correta. | | |
| TASK-005 | Em `merge/ProcRCOMsa.prw`, linhas **4599 e 4600**: aplicar a mesma alteração de TASK-004. | | |
| TASK-006 | Confirmar que os arquivos permanecem em CP-1252 após a edição (CON-005); se necessário, aplicar a skill `utf8-to-cp1252-conversion`. | | |
| TASK-007 | Executar `diff -w merge/ProcMsaNFe.prw merge/ProcRCOMsa.prw` e confirmar que a contagem de diferenças permanece em 233 linhas (nenhuma divergência nova introduzida — CON-006). | | |

### Implementation Phase 2

- GOAL-002: Coletar os insumos externos que destravam as fases 3 a 6. Nenhuma linha de código é alterada nesta fase. Fase bloqueante para GOAL-003, GOAL-004, GOAL-005 e GOAL-006.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-008 | Emitir, em ambiente de homologação, uma NF-e com incidência de Imposto Seletivo e com redução de alíquota distinta entre IBS UF e IBS Município. | | |
| TASK-009 | Coletar o XML intermediário gerado, já disponível em disco: `PrcXmlNfe.prw:54` executa `MemoWrite("\xmlnfe\nfetest_"+AllTrim(cInvoice)+"_"+AllTrim(cSeries)+".xml", cXml)`. Arquivar o XML na pasta `analise/`. | | |
| TASK-010 | A partir do XML de TASK-009, documentar a estrutura exata emitida por `GetXmlIs()`: valor da tag `<codigo>` do bloco `<imposto>` do IS, nome do nó filho (`<Tributo>` ou outro) e nome de cada campo (`CSTIS`/`CST`, `cClassTribIS`/`cClassTrib`, `vBCIS`/`vBC`, `pIS`, `vIS`, `pISEspec`, `uTrib`, `qTrib`). Registrar em `analise/estrutura-xml-is.md`. | | |
| TASK-011 | A partir do mesmo XML, documentar a estrutura emitida por `getXmlTotalIbsCbsIs()` para o nó `ISTot` dentro de `<total>`, incluindo o caminho completo a ser usado em `retValueAttribute`. | | |
| TASK-012 | Verificar no XML se existem os campos `vUnComLiq`, `vProdLiq`, `vProdLiqTot` e os grupos `gAjusteCompet`, `gEstornoCred`, `NB01`. Registrar presença ou ausência de cada um (ver RISK-003). | | |
| TASK-013 | Obter do Mastersaf o layout vigente do arquivo de NF-e e documentar a **posição ordinal exata** de: grupo `IS` dentro de `imposto`; `ISTot` dentro de `total`; `gAjusteCompet`, `gEstornoCred`, `NB01` (incluindo o nó pai); `vUnComLiq`/`vProdLiq` em `prod`; `vProdLiqTot` em `total`. Registrar em `analise/layout-mastersaf-posicoes.md`. | | |
| TASK-014 | Caso TASK-012 confirme ausência de `vUnComLiq`/`vProdLiq`/`vProdLiqTot` no XML, decidir a origem entre as três hipóteses: (a) campo emitido pelas classes padrão e ainda não lido; (b) campo calculado (`vProd` menos tributos); (c) campo exclusivo do layout Mastersaf sem contrapartida na NT. Registrar a decisão e a fórmula, se aplicável. | | |
| TASK-015 | Consultar a NT 2025.002 para confirmar a definição de `gAjusteCompet`, `gEstornoCred` e `NB01` (nó pai, campos, obrigatoriedade). | | |
| TASK-016 | Decidir e documentar se os campos novos serão condicionados a `lRefTribCo` (padrão de `DoIBSCBSTot()`) ou sempre emitidos com valor vazio para notas anteriores à vigência (FIS-002). | | |

### Implementation Phase 3

- GOAL-003: Implementar o mapeamento do grupo IS no nível do item em ambos os mappers. Depende de GOAL-002 (TASK-010, TASK-013, TASK-016).

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-017 | Em `merge/ProcMsaNFe.prw`, criar `static function DoIS()` seguindo PAT-001, com `cTax := "IS"` e `cNode := "tributo"`, instanciando `MsafNFeTag():newMsafNFeTag("IS")`, preenchendo `CSTIS` e `cClassTribIS` conforme nomes confirmados em TASK-010, e anexando a `oImpostos` via `addElementNode`. | | |
| TASK-018 | Em `merge/ProcMsaNFe.prw`, criar `static function DoSIS()` espelhando `DoSIBSCBS()` (linha 4445), caso TASK-013 confirme a existência de nó de sequência (`sequencia_XML_IS`) no layout. Se o layout não exigir, marcar a task como não aplicável e registrar a justificativa. | | |
| TASK-019 | Em `merge/ProcMsaNFe.prw`, criar `static function DogIS()` com os campos de valor do IS (`vBCIS`, `pIS`, `vIS` e demais confirmados em TASK-010 e TASK-013), anexando ao nó pai definido em TASK-013. | | |
| TASK-020 | Em `merge/ProcMsaNFe.prw`, registrar `DoIS()`, `DoSIS()` e `DogIS()` em `DoAllTaxes()` na posição ordinal definida em TASK-013. Hipótese de trabalho a confirmar: entre `DoISSQN()` (linha 3978) e `DoIBSCBS()` (linha 3979), espelhando a ordem da NT. | | |
| TASK-021 | Em `merge/ProcMsaNFe.prw`, acrescentar `oIS,oSeqIS,ogIS` ao `SetPrvt` da linha **76** (PAT-004). | | |
| TASK-022 | Replicar TASK-017 a TASK-021 em `merge/ProcRCOMsa.prw`. Âncoras correspondentes: `DoAllTaxes()` na linha 3886, `DoISSQN()` na linha 3980, `DoIBSCBS()` na linha 3981, `SetPrvt` na linha 76. | | |

### Implementation Phase 4

- GOAL-004: Implementar o mapeamento do total `ISTot` em ambos os mappers. Depende de GOAL-002 (TASK-011, TASK-013, TASK-016).

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-023 | Em `merge/ProcMsaNFe.prw`, criar `static function DoISTot()` seguindo PAT-002, lendo via `retValueAttribute` o caminho confirmado em TASK-011 e anexando a `oTotal`. | | |
| TASK-024 | Em `merge/ProcMsaNFe.prw`, registrar `DoISTot()` em `MountTags()` na posição ordinal definida em TASK-013. Hipótese de trabalho a confirmar: antes de `DoIBSCBSTot()` (linha 105), espelhando a ordem da NT. | | |
| TASK-025 | Em `merge/ProcMsaNFe.prw`, acrescentar `oISTot` ao `SetPrvt` da linha **76**. | | |
| TASK-026 | Replicar TASK-023 a TASK-025 em `merge/ProcRCOMsa.prw`. Âncoras correspondentes: `DoIBSCBSTot()` chamada na linha 104 de `MountTags()`, `SetPrvt` na linha 76. | | |

### Implementation Phase 5

- GOAL-005: Implementar `gAjusteCompet`, `gEstornoCred` e `NB01`. Depende de GOAL-002 (TASK-012, TASK-013, TASK-015).

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-027 | Confirmar, a partir de TASK-012 e TASK-015, se os três grupos estão presentes no XML intermediário. Caso ausentes, abrir item de escalonamento para o fonte `nfesefaz.prw` ou para a TOTVS, e registrar o bloqueio (esta fase passa a depender dessa resolução). | | |
| TASK-028 | Em `merge/ProcMsaNFe.prw`, criar `static function DogAjusteCompet()` seguindo PAT-001/PAT-003, anexando ao nó pai definido em TASK-015. | | |
| TASK-029 | Em `merge/ProcMsaNFe.prw`, criar `static function DogEstornoCred()` seguindo o mesmo padrão. | | |
| TASK-030 | Em `merge/ProcMsaNFe.prw`, criar `static function DoNB01()` seguindo o mesmo padrão. | | |
| TASK-031 | Em `merge/ProcMsaNFe.prw`, registrar as três funções em `DoAllTaxes()` nas posições definidas em TASK-013 e acrescentar `ogAjusteCompet,ogEstornoCred,oNB01` ao `SetPrvt` da linha 76. | | |
| TASK-032 | Replicar TASK-028 a TASK-031 em `merge/ProcRCOMsa.prw`. | | |

### Implementation Phase 6

- GOAL-006: Implementar os campos de valor líquido `vUnComLiq`, `vProdLiq` e `vProdLiqTot`. Depende de GOAL-002 (TASK-012, TASK-013, TASK-014).

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-033 | Aplicar a decisão de origem registrada em TASK-014. Se a origem for cálculo, implementar em `nfesefaz.prw` e não no mapper — ver ALT-002 e a justificativa correspondente. | | |
| TASK-034 | Em `merge/ProcMsaNFe.prw`, mapear `vUnComLiq` e `vProdLiq` em `DoEXTIPI()` (linha **1553**), que já concentra `vUnCom`, `vProd`, `vUnTrib`, `vFrete`, `vSeg`, `vDesc`, `vOutro` e `indTot`, na posição ordinal definida em TASK-013. Alternativamente em `DoProd()` (linha **1502**), caso o layout assim determine. | | |
| TASK-035 | Em `merge/ProcMsaNFe.prw`, mapear `vProdLiqTot` no nó `total`, na posição definida em TASK-013, seguindo o padrão de `DovNFTot()` (linha **5061**). | | |
| TASK-036 | Replicar TASK-034 e TASK-035 em `merge/ProcRCOMsa.prw`. Âncoras correspondentes: `DoProd()` na linha 1505, `DoEXTIPI()` na linha 1556, `DovNFTot()` na linha 5063. | | |

### Implementation Phase 7

- GOAL-007: Validar, compilar e homologar. Depende da conclusão das fases executadas.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-037 | Executar `diff -w merge/ProcMsaNFe.prw merge/ProcRCOMsa.prw` e confirmar que nenhuma divergência nova foi introduzida além das 233 linhas pré-existentes (CON-006). | | |
| TASK-038 | Confirmar encoding CP-1252 de ambos os fontes (CON-005); aplicar a skill `utf8-to-cp1252-conversion` se necessário. | | |
| TASK-039 | Compilar ambos os fontes via skill `advpl-tlpp-compile` e corrigir eventuais erros de compilação. | | |
| TASK-040 | Executar TEST-001 a TEST-007 (seção 6) e registrar os resultados em `analise/resultado-testes.md`. | | |
| TASK-041 | Importar os arquivos TXT gerados no Mastersaf em ambiente de homologação e confirmar aceitação sem erro de layout. | | |
| TASK-042 | Executar a Completeness Verification exigida pelo CLAUDE.md: comparar item a item os 6 gaps da planilha original com o entregue, classificando cada um como migrado, não migrável (com justificativa) ou preservado, e apresentar ao solicitante. | | |

## 3. Alternatives

- **ALT-001**: Refatorar `DoAllTaxes()` (110 chamadas sequenciais) para um laço orientado a dados sobre uma tabela de configuração de impostos. **Rejeitado**: aumenta drasticamente o risco em fonte sem versionamento, e a ordem das chamadas é o próprio contrato do arquivo posicional (CON-001). Qualquer erro de ordenação quebra a importação.
- **ALT-002**: Calcular os valores líquidos dentro de cada mapper. **Rejeitado em favor de `nfesefaz.prw`**: o cálculo duplicado em dois arquivos de 5.400 linhas tende a divergir ao longo do tempo, gerando valores diferentes entre o TXT Mastersaf e o TXT SAP/SCJ para a mesma nota. Centralizar em `nfesefaz.prw` também disponibiliza o dado para os demais consumidores do XML (`ProcMsaCte.prw`, `ProcRSymbMsa.prw`, DANFE).
- **ALT-003**: Unificar `ProcMsaNFe.prw` e `ProcRCOMsa.prw` em um fonte único parametrizado, eliminando a duplicação de 96%. **Rejeitado para este ciclo**: escopo muito superior ao da correção fiscal e com risco de regressão em duas integrações simultaneamente. Registrar como débito técnico.
- **ALT-004**: Corrigir apenas os 2 bugs (Fase 1) e postergar as lacunas de mapeamento. **Rejeitado como solução final**, mas adotado como **ordem de execução**: a Fase 1 é independente e entrega valor imediato sem depender da coleta de insumos externos.
- **ALT-005**: Deduzir os nomes das tags do IS a partir da NT 2025.002 sem inspecionar XML real. **Rejeitado**: viola a regra de API Symbol Validation do CLAUDE.md. As classes `taxinformation` estão no RPO e podem aplicar nomenclatura própria no XML intermediário — que já difere da NT em outros pontos (p.ex. `<codigo>`/`<Tributo>`/`<aliquota>`/`<valor>` em vez das tags oficiais).

## 4. Dependencies

- **DEP-001**: XML intermediário real de NF-e com Imposto Seletivo, gerado em homologação e coletado de `\xmlnfe\nfetest_*.xml` (bloqueia GOAL-003, GOAL-004, GOAL-005, GOAL-006).
- **DEP-002**: Layout Mastersaf de NF-e vigente, com posição ordinal dos campos (bloqueia GOAL-003 a GOAL-006 — CON-002).
- **DEP-003**: NT 2025.002 da NF-e, para `gAjusteCompet`, `gEstornoCred` e `NB01` (bloqueia GOAL-005).
- **DEP-004**: Classes padrão no RPO: `totvs.protheus.backoffice.fiscal.integration.taxinformation` e `totvs.protheus.backoffice.tss.engine.xml.taxinformation`, instanciadas em `nfesefaz.prw:7374-7376`. Fonte indisponível no workspace (CON-003).
- **DEP-005**: Classe `totvs.protheus.backoffice.tss.engine.tributaveis.TSSTCIntegration`, instanciada em `nfesefaz.prw:14627`, fornecedora do objeto `oNfTciIntg` consumido por `GetXmlIs()`.
- **DEP-006**: Parâmetro `MV_RTC55` (data de vigência da Reforma, default `20260105`), consumido em `ProcMsaNFe.prw:30`.
- **DEP-007**: Parâmetro `MV_CSTGXML`, consumido em `DoIBSCBSTot()` (`ProcMsaNFe.prw:4907`).
- **DEP-008**: Função `retArrayAtribute` (grafia com um "t") — chamada 4 vezes por mapper (linhas 585, 3811, 4276, 4903 de `ProcMsaNFe.prw`) e **não definida em nenhum fonte do workspace**; a definida localmente é `retArrayAttribute` (dois "t", linha 3871). Resolve em runtime por fonte residente no RPO. Funciona em produção e não bloqueia este plano, mas deve ser localizada antes de qualquer alteração estrutural em `DoIBSCBSTot()` ou `DoDetProd()`.
- **DEP-009**: Ambiente de homologação Mastersaf para validação de importação (TASK-041).

## 5. Files

- **FILE-001**: `d:\99-FONTES\DV2 - DHL\merge\ProcMsaNFe.prw` (5.375 linhas) — mapper Mastersaf NF-e. **Alvo principal de alteração.** Pontos de intervenção: `SetPrvt` L76; `MountTags()` L102-112; `DoProd()` L1502; `DoEXTIPI()` L1553; `DoISSQN()` L3723; `DoAllTaxes()` L3884 (chamadas em L3978-3979); `DoIBSCBS()` L4427; `DogIBSUFRed()` L4523; `DogIBSMuRed()` L4590 (bug em L4597-4598); `DoIBSCBSTot()` L4901 (bug em L4934); `DovNFTot()` L5061.
- **FILE-002**: `d:\99-FONTES\DV2 - DHL\merge\ProcRCOMsa.prw` (5.547 linhas) — mapper SAP/SCJ. **Alvo principal de alteração.** Pontos de intervenção: `SetPrvt` L76; `MountTags()` L101-111; `DoProd()` L1505; `DoEXTIPI()` L1556; `DoISSQN()` L3726; `DoAllTaxes()` L3886 (chamadas em L3980-3981); `DoIBSCBS()` L4429; `DogIBSUFRed()` L4525; `DogIBSMuRed()` L4592 (bug em L4599-4600); `DoIBSCBSTot()` L4903 (bug em L4936); `DovNFTot()` L5063.
- **FILE-003**: `d:\99-FONTES\DV2 - DHL\merge\nfesefaz.prw` (15.119 linhas) — gerador do XML intermediário. **Somente leitura**, exceto se TASK-014 definir cálculo de valor líquido nesta camada. Referências: instanciação de `oXmlRefTri` L7374-7376; `GetXmlIs()` L10060; `GetXmlIbsCbs()` L10064; `getXmlTotalIbsCbsIs()` L10463; destruição do objeto L7415-7417.
- **FILE-004**: `PROTHEUS\Producao\Mastersaf_NFe\MsafNFeFile.prw` — gravação do TXT posicional (`writeTag` L87-120). **Somente leitura**; é a origem da restrição CON-001.
- **FILE-005**: `PROTHEUS\Producao\Mastersaf_NFe\MsafNFeTag.prw` — classe de tag. **Somente leitura**; `setAttributeValue` L112-136 acrescenta ao array na ordem de chamada.
- **FILE-006**: `PROTHEUS\Producao\Mastersaf_NFe\PrcXmlNfe.prw` — orquestrador Mastersaf; `MemoWrite` do XML em L54 (fonte do insumo de TASK-009). **Somente leitura**.
- **FILE-007**: `PROTHEUS\Producao\SAP\PrcRCOXml.prw` — orquestrador SAP/SCJ, equivalente ao FILE-006. **Somente leitura**.
- **FILE-008**: `d:\99-FONTES\DV2 - DHL\merge\ProcRSymbMsa.prw` (3.439 linhas) — terceiro mapper. **Fora do escopo**: não possui nenhum mapeamento de Reforma Tributária (zero ocorrências de `IBSCBS`). Ver RISK-005.
- **FILE-009**: `d:\99-FONTES\DV2 - DHL\merge\analise\` — pasta deste plano e dos artefatos de análise (`estrutura-xml-is.md`, `layout-mastersaf-posicoes.md`, `resultado-testes.md`, XML coletado).

## 6. Testing

- **TEST-001** (valida REQ-001): Emitir NF-e cujo item possua um único nó `<imposto>` e CST contido em `MV_CSTGXML`. Verificar que `vBCIBSCBS` no bloco `IBSCBSTot` do TXT deixou de ser zero e é igual à soma dos `vBC` do `gIBSCBS` dos itens. Antes da correção o valor sai zerado.
- **TEST-002** (valida REQ-001, regressão): Emitir NF-e cujos itens possuam múltiplos nós `<imposto>` (ramo array, `ProcMsaNFe.prw:4914`). O valor de `vBCIBSCBS` deve permanecer idêntico ao gerado antes da correção.
- **TEST-003** (valida REQ-002): Emitir NF-e com `pRedAliq`/`pAliqEfet` **diferentes** entre IBS UF e IBS Município. No TXT, o bloco `gRed` do `gIBSMun` deve refletir os valores municipais e divergir do `gRed` do `gIBSUF`. Antes da correção ambos saem idênticos.
- **TEST-004** (valida CON-001 — teste de não deslocamento): Gerar o TXT de uma NF-e **sem** Reforma Tributária (data-base anterior a `MV_RTC55`) antes e depois de todas as alterações. Os dois arquivos devem ser **byte-idênticos** fora dos campos novos. Qualquer divergência de contagem de linhas indica deslocamento de layout.
- **TEST-005** (valida REQ-003, REQ-004): Emitir NF-e com Imposto Seletivo e conferir campo a campo `CSTIS`, `cClassTribIS`, `vBCIS`, `pIS`, `vIS` e `ISTot` do TXT contra os valores do XML intermediário coletado em TASK-009.
- **TEST-006** (valida REQ-005, REQ-006): Conferir `gAjusteCompet`, `gEstornoCred`, `NB01`, `vUnComLiq`, `vProdLiq` e `vProdLiqTot` contra a origem definida em TASK-014 e TASK-015.
- **TEST-007** (valida REQ-007): Gerar o TXT da **mesma** nota pelos dois fluxos (`PrcXmlNfe` e `PrcRCOXml`) e confirmar que os campos da Reforma são idênticos nos dois arquivos.
- **TEST-008** (valida DEP-009): Importar no Mastersaf em homologação os arquivos de TEST-004, TEST-005 e TEST-006, confirmando aceitação sem erro de layout.

## 7. Risks & Assumptions

- **RISK-001** (crítico): Inserir campo em posição incorreta desloca todo o TXT posicional e quebra a importação de **todas** as notas, não apenas as da Reforma. Mitigação: TASK-013 (layout documentado antes de codificar) e TEST-004 (comparação byte a byte de nota sem Reforma).
- **RISK-002** (alto): Ausência de versionamento Git no workspace impede rollback automático (CON-004). Mitigação: TASK-001 (backup datado obrigatório antes de qualquer edição).
- **RISK-003** (alto): Se TASK-012 revelar que `vUnComLiq`, `vProdLiq`, `vProdLiqTot`, `gAjusteCompet`, `gEstornoCred` ou `NB01` não são emitidos pelas classes padrão, a correção deixa de ser apenas de mapeamento e passa a exigir alteração em `nfesefaz.prw` ou escalonamento à TOTVS — com impacto relevante em prazo. GOAL-005 e GOAL-006 ficam bloqueados.
- **RISK-004** (médio): Divergência acidental entre `ProcMsaNFe.prw` e `ProcRCOMsa.prw` produz arquivos inconsistentes entre as integrações Mastersaf e SAP/SCJ. Mitigação: TASK-007, TASK-037 e TEST-007.
- **RISK-005** (médio): `ProcRSymbMsa.prw` não possui nenhum mapeamento de Reforma Tributária. Se a integração RSymb também precisar atender à NT 2025.002, há um gap inteiro fora do escopo desta planilha. **Ação: confirmar com a área fiscal antes do encerramento.**
- **RISK-006** (baixo): O bug de REQ-001 afeta o ramo de `imposto` único. Como itens com Reforma normalmente trazem ICMS, PIS, COFINS e IBSCBS (gerando array), a incidência real pode ser restrita a cenários específicos — por exemplo, itens exclusivamente de serviço. O escopo do impacto em produção deve ser dimensionado antes de comunicar correção retroativa.
- **ASSUMPTION-001**: A pasta `d:\99-FONTES\DV2 - DHL\merge\` é a versão de trabalho corrente. Baseia-se na correspondência exata dos números de linha da planilha de gaps (`ProcRCOMsa` 4936/4599-4600/1502 e `ProcMsaNFe` 3884-4010/4934) com essa versão, e não com a de `PROTHEUS\Producao\`. **Confirmar antes de iniciar TASK-002.**
- **ASSUMPTION-002**: As classes padrão da Reforma no RPO estão atualizadas e já emitem os nós de IS e ISTot. Baseia-se nas chamadas presentes em `nfesefaz.prw:10060` e `10463`. TASK-009 confirma ou refuta empiricamente.
- **ASSUMPTION-003**: O comportamento dos mappers para notas anteriores a `MV_RTC55` não deve mudar. Confirmar em TASK-016.
- **ASSUMPTION-004**: A ordem dos campos no TXT Mastersaf acompanha a ordem da NT 2025.002 (IS antes de IBS/CBS no item; ISTot antes de IBSCBSTot no total). Usada apenas como **hipótese de trabalho** em TASK-020 e TASK-024; TASK-013 é a fonte autoritativa.

## 8. Related Specifications / Further Reading

- Nota Técnica 2025.002 da NF-e — grupos IS, IBS/CBS e totalizadores da Reforma Tributária (Portal Nacional da NF-e).
- Layout do arquivo de integração Mastersaf NF-e — versão vigente (a obter em TASK-013; não disponível no workspace).
- `d:\99-FONTES\.claude\CLAUDE.md` — convenções AdvPL/TLPP, regras SonarQube, API Symbol Validation e Completeness Verification.
- `.agents/skills/references/sonarqube-rules-reference.md` — regras SonarQube AdvPL/TLPP aplicáveis ao código gerado.
- Skill `utf8-to-cp1252-conversion` — conversão de encoding obrigatória antes da compilação (CON-005).
- Skill `advpl-tlpp-compile` — compilação via TOTVS Developer Studio (TASK-039).
- `nfesefaz.prw:7374-7376` — instanciação condicional de `oXmlRefTri` entre as implementações TSS e Fiscal Integration.
