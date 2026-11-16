---
goal: Adequar os fontes da interface Mastersaf DW (SAFX07/08/112/116 e variantes por unidade de negócio) ao Configurador de Tributos (CFGTRIB/FISA170) e à Reforma Tributária do Consumo (IBS/CBS)
version: 1.0
date_created: 2026-11-13
last_updated: 2026-11-13
owner: DHL - Equipe Protheus / Fiscal (DV2)
status: 'Planned'
tags: [upgrade, migration, fiscal, reforma-tributaria, ibs-cbs, cfgtrib, mastersaf-dw, architecture]
---

# Introduction

![Status: Planned](https://img.shields.io/badge/status-Planned-blue)

Este plano define a adequação dos fontes da interface **Mastersaf DW** (geração dos arquivos SAFX07, SAFX08, SAFX112 e SAFX116) ao **Configurador de Tributos do Protheus (CFGTRIB / rotina FISA170)** e à **Reforma Tributária do Consumo (IBS/CBS)**, cuja obrigatoriedade de cálculo e destaque entra em vigor em **03/08/2026**.

O escopo abrange os diretórios e fontes listados pelo solicitante: `SAFX07/AG2`, `SAFX07/AGE`, `SAFX07/AGL`, `SAFX07/DIS`, `SAFX07/DI2`, `SAFX07/MUL`, `SAFX07/REP` (que reutiliza AGE), `SAFX07MSDW` (atende PKG e Default) e `SAFX08MSDW` (Default).

O problema central identificado na análise do código: **toda a captação de tributos é feita a partir de campos legados calculados pela matriz de TES/MATXFIS** (`F3_VALICM`, `F3_VALIPI`, `F3_BASIMP5/6`, `FT_VALICM`, `FT_CSTPIS`, `FT_CSTCOF`, `F4_*`) e, para ICMS Partilha/FCP, da tabela `CD2` via `DHLSafx:getUfTaxes()`. **Nenhum fonte lê a tabela `F2D` (Tributos Genéricos Calculados)**, que é onde o Configurador de Tributos grava IBS e CBS. Consequentemente, a partir da virada todos os arquivos SAFX07/SAFX08 serão gerados **sem IBS/CBS**, com risco de perda de crédito e de rejeição da escrituração.

## 1. Requirements & Constraints

### Requisitos funcionais

- **REQ-001**: Os valores de **IBS Estadual, IBS Municipal e CBS** devem ser captados da tabela `F2D` (Tributos Genéricos Calculados), relacionando-se ao item do documento fiscal pelos campos `SFT.FT_IDTRIB`, `SD1.D1_IDTRIB` ou `SD2.D2_IDTRIB` com `F2D.F2D_IDREL`, filtrando por `F2D_TABELA` ('SFT', 'SD1' ou 'SD2') e `F2D_TRIB` (sigla do tributo, 6 posições).
- **REQ-002**: Os campos a captar por tributo em `F2D` são: `F2D_BASE` (base de cálculo), `F2D_ALIQ` (alíquota aplicada), `F2D_VALOR` (valor do tributo), `F2D_BASQTD` (base por quantidade), `F2D_MAJORA` (percentual de majoração) e `F2D_ORIGEM` (origem do cálculo).
- **REQ-003**: Registros de `F2D` com `F2D_DTEXCL` preenchida (data de exclusão/estorno) devem ser desprezados, além do filtro padrão `D_E_L_E_T_ = ' '`.
- **REQ-004**: O item de SAFX08 deve ser enriquecido com **CST-IBS/CBS** (3 posições) e **cClassTrib** (6 posições, cujos 3 primeiros dígitos são o próprio CST), obtidos da Regra de Escrituração do Configurador de Tributos / tabela `CKB` (Classificação Tributária IBS/CBS, campo `CKB_CSTCCT`).
- **REQ-005**: O cabeçalho de SAFX07 deve receber os **totais de IBS (UF + Municipal) e CBS** do documento, calculados por somatório dos itens (`F2D` agregado por documento), seguindo o padrão já existente em `DHLSafx:getSumItems()`.
- **REQ-006**: A captação de IBS/CBS deve ser **condicionada por data de corte**, reutilizando o parâmetro já existente no workspace `MV_RTC55` (`SuperGetMv('MV_RTC55',.f.,stod('20260105'))`, usado em `ProcMsaNFe.prw:30` e `ProcRCOMsa.prw:31`), de modo que documentos anteriores à virada mantenham o comportamento atual sem regressão.
- **REQ-007**: As siglas dos tributos devem ser lidas de parâmetros, **nunca hardcoded**, reutilizando os parâmetros já criados no workspace: `ZZ_TRIBCBS` (default `TR0001`), `ZZ_TRIBSUF` (default `TR0002`), `ZZ_TRIBSMU` (default `TR0003`) — conforme `DHLIdManager.prw:261-263`.
- **REQ-008**: O comportamento deve ser idêntico para as 8 unidades de negócio atendidas (`SPL`, `PKG`, `DIS`, `REP`, `AGE`, `MUL`, `AG2`, `AGL`, `DI2`), respeitando as customizações específicas já existentes em cada variante.
- **REQ-009**: Toda a lógica de captação de IBS/CBS deve ser implementada **uma única vez** na classe base `DHLSafx` (`PROTHEUS/Producao/Mastersaf_DW/DHLSafx.prw`) e consumida por herança pelas 7 variantes, para evitar a multiplicação do clone-and-own já existente.

### Requisitos de negócio / fiscais

- **FIS-001**: A obrigatoriedade de destaque e cálculo de IBS/CBS para operações de mercadoria e serviço vigora a partir de **03/08/2026**.
- **FIS-002**: A apuração de IBS/CBS no Protheus **só é suportada via Configurador de Tributos** (FISA170); não existe caminho por matriz de TES.
- **FIS-003**: Os documentos referenciados (SAFX116) ganham relevância para apropriação de crédito de IBS/CBS em devoluções e ajustes, devendo ser validada a cobertura atual.

### Restrições

- **CON-001**: **BLOQUEADOR DE NEGÓCIO** — o **Mastersaf DW foi descontinuado** pela Thomson Reuters e, conforme o roadmap público da Reforma Tributária 2026, as adequações de IBS/CBS foram entregues apenas na linha **ONESOURCE Tax One**, em **novos dicionários SAFX3007, SAFX3008, SAFX3009, SAFX3042 e SAFX3043** ("documentos fiscais baseados nas tabelas da reforma tributária") — e **não** nos layouts SAFX07/SAFX08. A definição do destino (DW legado com campos reservados × migração para Tax One) é pré-requisito para as Fases 3 a 6.
- **CON-002**: Os layouts atuais estão congelados em `SAFX07_POSICOES 285` (`PROTHEUS/Includes/safx07.ch:298`) e `SAFX08_POSICOES 259` (`PROTHEUS/Includes/safx08.ch:269`). **Não há campos nativos de IBS/CBS**. As únicas posições livres são `DSC_RESERVADO1..8` (SAFX07 posições 259-261 e 264-268; SAFX08 posições 203-205 e 207-211) — insuficientes para o conjunto completo (base, alíquota, valor, CST e cClassTrib de 3 tributos ≈ 17 campos).
- **CON-003**: Há **duplicação massiva de código** (clone-and-own) entre as variantes. Medição por `Compare-Object`: `DHLSafx07.prw` (523 linhas) × `DHLSafx07Dis.prw` divergem em 176/433 linhas; × `DHLSafx07Ag2.prw` em 362/528 linhas; `DHLSafx08.prw` (952 linhas) × `DHLSafx08Age.prw` divergem em 434/399 linhas. Alterações não centralizadas precisam ser replicadas em até 7 cópias por arquivo SAFX.
- **CON-004**: Existem **dois padrões distintos de acesso a dados**, exigindo implementação dupla:
  - *Geração A (objeto/array)*: `DIS` e `MUL` — usam `oDHLSafx07:getSql()`, `getTaxRecord()`, `getItemFlowsRecord()` e `getSqlFt()`.
  - *Geração B (alias direto)*: `Default/PKG`, `AGE`, `AGL`, `AG2`, `DI2` — usam `sf3abre()` + `SFTabre()` com os alias privados `cSF3_`/`cSFT_`.
- **CON-005**: A função `SFTabre()` está **replicada em 4 cópias**: `SAFX07MSDW.prw:720` (pública, `U_SFTabre`, consumida também por `Di2SAFX07MSDW.prw:91`), `AGE/SAFX07AGE.prw:658`, `AGL/SAFX07AGL.prw:656` e `AG2/07AG2SAFX.prw:740` (as três últimas como `static function`). A função `sf3abre()` está replicada em 5 cópias.
- **CON-006**: Todos os fontes `.prw` devem permanecer em **CP-1252 (Windows-1252)**; nenhum arquivo pode ser gravado em UTF-8.
- **CON-007**: Não há repositório Git neste workspace (controle por `.svn` em `PROTHEUS/`). O versionamento das alterações deve seguir o processo SVN vigente.
- **CON-008**: As queries atuais usam concatenação direta de strings com `dbUseArea`/`TcGenQry` e `getMv()` dentro da montagem (ex.: `SAFX07MSDW.prw:344`), o que viola as regras SonarQube CA2050 (SQL Injection) e a proibição de `GetMV()` em laço. Correções pontuais são permitidas nas linhas alteradas, mas a refatoração global está fora de escopo.

### Diretrizes e padrões

- **GUD-001**: Novos fontes e classes devem ser gerados em **TLPP** (`.tlpp`) com `#include "tlpp-core.th"` seguido de `#include "totvs.ch"`, tipagem estática e `Try/Catch`, conforme as convenções do projeto.
- **GUD-002**: Alterações em fontes `.prw` existentes mantêm a linguagem AdvPL do arquivo, para não misturar paradigmas em arquivos de 500-1000 linhas em produção.
- **GUD-003**: Proibido `IIF()`/`IF()` inline, `ConOut()`, `MSCREATE()`/`DBCREATE()`/`CRIATRAB()` e uso direto da variável `cFilial` em todo código novo.
- **GUD-004**: Toda função/método novo deve conter bloco `/*/{Protheus.doc}/*/` com `@type`, `@author`, `@since`, `@param` e `@return`.
- **GUD-005**: Logs de erro/divergência devem usar `FWLogMsg()` e o mecanismo de log já existente (`oDHLSafx07:addLog()` / tabela `SZ2`).
- **PAT-001**: O padrão de referência para a captação de tributos por item é `DHLSafx:getUfTaxes()` (`DHLSafx.prw:1249-1345`), que lê `CD2` por tributo (`CD2_IMP` = 'ICM'/'SOL'/'CMP') e retorna array por item + totalizador. O novo método de IBS/CBS deve replicar essa assinatura e estrutura de retorno.
- **PAT-002**: O padrão de referência para leitura de `F2D` já existe no workspace em `PROTHEUS/Producao/Controle_de_ID_Good-Bad/DHLIdManager.prw:261-341` (subqueries por tributo com `F2D_IDREL = D1_IDTRIB`/`D2_IDTRIB`, `F2D_TABELA`, `F2D_TRIB` e `%F2D.NOTDEL%`). Deve ser reutilizado como base.
- **PAT-003**: O padrão de referência para o mapeamento semântico de IBS/CBS (CST, cClassTrib, gIBSCBS, gIBSUF, gIBSMun, gCBS, gDif, gDevTrib) já existe em `PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw:4421-4500+` (interface Mastersaf NFe, baseada no XML da NF-e). Deve ser usado como dicionário de equivalência de nomes e totalizadores.
- **PAT-004**: O padrão de totalização por somatório de itens é `DHLSafx:getSumItems()` (`DHLSafx.prw:1101-1127`).

## 2. Implementation Steps

### Implementation Phase 1 — Decisão de destino e congelamento de requisito de layout

- GOAL-001: Eliminar o bloqueador **CON-001** definindo formalmente o destino dos dados de IBS/CBS, sem o qual nenhuma linha de código de layout pode ser escrita. Fase **obrigatoriamente sequencial** e anterior às Fases 3-6.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-001 | Abrir chamado formal à Thomson Reuters / área fiscal DHL questionando: (a) o Mastersaf DW instalado na DHL receberá os campos de IBS/CBS? (b) em caso negativo, qual a data de desativação do DW e de entrada do ONESOURCE Tax One? (c) os novos dicionários SAFX3007/3008/3009 substituem SAFX07/SAFX08 ou coexistem? Registrar a resposta como anexo deste plano. | | |
| TASK-002 | Obter da Thomson Reuters o **layout oficial atualizado** dos arquivos de destino (SAFX07/SAFX08 com campos reservados, ou SAFX3007/SAFX3008/SAFX3009), com número de posições, tamanho, decimais e ordem exata de cada campo de IBS/CBS. | | |
| TASK-003 | Decidir e registrar a estratégia de destino entre: (ALT-001) uso dos campos `DSC_RESERVADO1..8` nos layouts atuais; (ALT-002) extensão dos layouts SAFX07/SAFX08 com novas posições acordadas; (ALT-003) implementação dos novos dicionários SAFX3007/3008/3009; (ALT-004) descontinuação da interface DW e migração para ONESOURCE Tax One. | | |
| TASK-004 | Inventariar no ambiente DHL as **siglas reais de tributo** cadastradas na tabela `F2E` (Cadastro de Tributo) para IBS Estadual, IBS Municipal e CBS, e confrontar com os defaults dos parâmetros `ZZ_TRIBSUF`/`ZZ_TRIBSMU`/`ZZ_TRIBCBS` (`TR0002`/`TR0003`/`TR0001`) e com os códigos padrão TOTVS (`000060`/`000061`/`000062`). Corrigir os parâmetros no SX6 se divergirem. | | |
| TASK-005 | Validar no ambiente DHL se o Configurador de Tributos (FISA170) está efetivamente ativo e gravando em `F2D` para as unidades de negócio em escopo, executando uma nota de teste por unidade e conferindo `F2D_TRIB`, `F2D_BASE`, `F2D_ALIQ`, `F2D_VALOR` e o vínculo `FT_IDTRIB`. | | |
| TASK-006 | Confirmar a origem exata de **CST-IBS/CBS** e **cClassTrib** no ambiente DHL (Regra de Escrituração do CFGTRIB / tabela `CKB`, campo `CKB_CSTCCT`), documentando a query de leitura por item validada em homologação. | | |

### Implementation Phase 2 — Mapa de impacto e baseline de regressão

- GOAL-002: Produzir o inventário completo de pontos de alteração e uma base de comparação "antes/depois" que permita provar ausência de regressão nos tributos legados. Executável em paralelo à Fase 1.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-007 | Gerar e versionar a matriz de impacto por fonte (unidade de negócio × arquivo × função × padrão de acesso A/B), consolidando: 7 variantes de SAFX07, 6 de SAFX08, 5 de SAFX112, 5 de SAFX116, 5 cópias de `sf3abre()` e 4 cópias de `SFTabre()`. | | |
| TASK-008 | Gerar arquivos SAFX07/SAFX08/SAFX112/SAFX116 de baseline para um período fechado, por unidade de negócio (`SPL`, `PKG`, `DIS`, `REP`, `AGE`, `MUL`, `AG2`, `AGL`, `DI2`), e armazená-los como massa de regressão imutável. | | |
| TASK-009 | Mapear, para cada campo de tributo hoje preenchido em `DHLSafx07:addLine()` e `DHLSafx08:addLine()`, se a origem permanece válida sob CFGTRIB ou passa a vir de `F2D` — classificando cada campo como `MANTÉM`, `MIGRA-F2D` ou `OBSOLETO`. Entregar como tabela de-para. | | |
| TASK-010 | Validar se os campos legados consumidos nas queries continuam populados com o CFGTRIB ativo, em especial `F3_VALICM`, `F3_VALIPI`, `F3_BASIMP5`, `F3_BASIMP6`, `FT_CSTPIS`, `FT_CSTCOF`, `FT_CLASFIS` e os campos de `SF4` (`F4_BASEICM`, `F4_LFIPI`, `F4_INCIDE`, `F4_DESTACA`). Documentar os que passam a retornar zero/vazio. | | |
| TASK-011 | Avaliar o impacto do **split payment** e da **extinção progressiva de PIS/COFINS/ICMS/IPI** sobre os campos atuais do SAFX07 (`VLR_BASE_PIS`, `VLR_PIS`, `VLR_BASE_COFINS`, `VLR_COFINS`, `VLR_ICMS`, `VLR_IPI`) e registrar a regra de preenchimento acordada com a área fiscal para o período de transição. | | |
| TASK-012 | Revisar a cobertura de `SAFX116` (documentos referenciados) frente à necessidade de rastreio de crédito de IBS/CBS em devoluções, e de `SAFX112` (observações do lançamento) frente a novos códigos de observação exigidos. | | |

### Implementation Phase 3 — Componente central de captação IBS/CBS (classe base)

- GOAL-003: Implementar, **uma única vez**, na classe base `DHLSafx`, a captação de IBS/CBS a partir de `F2D`, sem alterar comportamento existente. Depende de TASK-004, TASK-005 e TASK-006.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-013 | Criar o include `PROTHEUS/Includes/safxrtc.ch` com as constantes de IBS/CBS: siglas de tributo, posições do array de retorno (`RTC_IBSUF_BASE`, `RTC_IBSUF_ALIQ`, `RTC_IBSUF_VALOR`, `RTC_IBSMUN_*`, `RTC_CBS_*`, `RTC_CST`, `RTC_CCLASSTRIB`, `RTC_ITEM`) e os nomes dos parâmetros. Gravar em CP-1252. | | |
| TASK-014 | Criar a classe `DHLSafxRtc` em `PROTHEUS/Producao/Mastersaf_DW/DHLSafxRtc.tlpp` (TLPP, com `tlpp-core.th` + `totvs.ch`), encapsulando a leitura de `F2D` por documento e por item, com os métodos `getRtcTaxesByDoc()`, `getRtcTaxesByItem()` e `getRtcTotals()`. Usar `FWExecStatement` e `%F2D.NOTDEL%`. | | |
| TASK-015 | Implementar em `DHLSafxRtc` a query de captação por item, com `LEFT JOIN` de `F2D` sobre `SFT.FT_IDTRIB = F2D.F2D_IDREL AND F2D_TABELA = 'SFT'`, pivotando os três tributos em colunas (base/alíquota/valor por tributo), filtrando `F2D_DTEXCL` vazia e `D_E_L_E_T_ = ' '`, com `%nolock%`. Fallback para `D1_IDTRIB`/`D2_IDTRIB` quando `FT_IDTRIB` estiver vazio. | | |
| TASK-016 | Implementar em `DHLSafxRtc` o método de captação de `CST-IBS/CBS` e `cClassTrib` por item, conforme a origem confirmada em TASK-006. | | |
| TASK-017 | Adicionar à classe `DHLSafx` (`DHLSafx.prw`) o método `getRtcTaxes(cType, cTypeDoc, cSerie, cDoc, cCliFor, cLoja, cItem, lTodos)` como fachada para `DHLSafxRtc`, replicando exatamente a assinatura e a estrutura de retorno de `getUfTaxes()` (array por item + totalizador na última posição), de modo que as 7 variantes herdem o comportamento sem alteração de classe. | | |
| TASK-018 | Adicionar à classe `DHLSafx` o método `isRtcActive(dDoc)` que avalia a data do documento contra `SuperGetMv('MV_RTC55',.F.,stod('20260105'))`, chamado **uma única vez por execução** (fora de laço) e armazenado em variável de controle. | | |
| TASK-019 | Estender `DHLSafx:getSumItems()` para totalizar IBS UF, IBS Municipal e CBS por documento, somando a partir de `F2D`, mantendo todos os somatórios atuais intactos. | | |
| TASK-020 | Criar função de validação `rtcValidDoc()` que registra em log (`FWLogMsg` + `addLog`) os documentos com data ≥ `MV_RTC55` e **sem** registro correspondente em `F2D`, sinalizando falha de cálculo no Configurador de Tributos antes da geração do arquivo. | | |

### Implementation Phase 4 — Enriquecimento das queries de captação (dois padrões)

- GOAL-004: Tornar `FT_IDTRIB`/`D1_IDTRIB`/`D2_IDTRIB` e os valores de IBS/CBS disponíveis nos cursores consumidos por `addLine()`, nos dois padrões de acesso a dados. Depende de GOAL-003.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-021 | **Padrão B — protótipo**: alterar `SAFX07MSDW.prw`, função `U_SFTabre()` (linha 720), incluindo `FT_IDTRIB` no array `aCampo` e `D1_IDTRIB`/`D2_IDTRIB` nos arrays `aCampoD1`/`aCampoD2`, e adicionando o `LEFT JOIN` pivotado de `F2D` na query montada em `cQuery`/`cWhere` (linhas 891-940). | | |
| TASK-022 | **Padrão B — protótipo**: alterar `SAFX07MSDW.prw`, função `sf3abre()` (linha 248), para expor na query de cabeçalho os totais de IBS UF, IBS Municipal e CBS por documento (subquery agregada sobre `F2D`), nos três blocos `UNION ALL` (entrada, saída e devolução). | | |
| TASK-023 | **Padrão A — protótipo**: alterar `DIS/DHLSafx07Dis.prw`, método `getSql()` (linha 52), e `DIS/DHLSafx08Dis.prw`, métodos `getSql()` (linha 76) e `getSqlFt()`, aplicando a mesma captação de IBS/CBS via `F2D`. | | |
| TASK-024 | Replicar TASK-021/TASK-022 nas cópias remanescentes de `SFTabre()`: `AGE/SAFX07AGE.prw:658`, `AGL/SAFX07AGL.prw:656`, `AG2/07AG2SAFX.prw:740`; e de `sf3abre()`: `AGE/SAFX07AGE.prw:200`, `AGL/SAFX07AGL.prw:202`, `AG2/07AG2SAFX.prw:191`, `DI2/Di2SAFX07MSDW.prw:248`. | | |
| TASK-025 | Replicar TASK-023 na variante MUL: `MUL/DHLSafx07Mul.prw` (`getSql()`) e `MUL/DHLSafx08Mul.prw` (`getSql()`/`getSqlFt()`). | | |
| TASK-026 | Validar que `DI2/Di2SAFX07MSDW.prw` continua consumindo `U_SFTabre()` de `SAFX07MSDW.prw` (linha 91) e que não requer cópia própria; registrar a dependência de compilação entre os dois fontes. | | |
| TASK-027 | Confirmar que a variante `REP` não possui fontes próprios de SAFX07 e é atendida por `U_SAFX07AGE()` via `ProcMsaDW.prw:200-203`, e que `PKG`/`SPL` são atendidos pelo ramo `else` em `ProcMsaDW.prw:216-219` (`U_SAFX07MSDW`). Documentar no mapa de impacto. | | |

### Implementation Phase 5 — Mapeamento nos layouts SAFX07 e SAFX08

- GOAL-005: Gravar os campos de IBS/CBS nas posições definidas do arquivo de destino. Depende de TASK-002, TASK-003 e GOAL-004.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-028 | Atualizar `PROTHEUS/Includes/safx07.ch` com os `#define` das novas posições de IBS/CBS (base, alíquota e valor de IBS UF, IBS Municipal e CBS no cabeçalho) e ajustar `SAFX07_POSICOES` conforme o layout obtido em TASK-002. | | |
| TASK-029 | Atualizar `PROTHEUS/Includes/safx08.ch` com os `#define` das novas posições de IBS/CBS por item (base, alíquota, valor, CST-IBS/CBS e cClassTrib) e ajustar `SAFX08_POSICOES`. | | |
| TASK-030 | Alterar `DHLSafx07.prw`, método `addLine()` (linha 89), adicionando os `::addField()` dos totais de IBS/CBS após `VLR_ICMS_UF_ORIG` (linha 288), condicionados por `isRtcActive()`. | | |
| TASK-031 | Alterar `DHLSafx08.prw`, método `addLine()` (linha ~220), adicionando os `::addField()` de IBS/CBS por item após `VLR_ICMS_UF_ORIG` (linha 336), condicionados por `isRtcActive()`. | | |
| TASK-032 | Replicar TASK-030 nas 6 variantes de classe de cabeçalho: `AGE/DHLSafx07Age.prw`, `AGL/DHLSafx07Agl.prw` (classe `DHLAGL07`), `DIS/DHLSafx07Dis.prw`, `AG2/DHLSafx07Ag2.prw`, `MUL/DHLSafx07Mul.prw`, `DI2/Di2DHLSafx07.prw`. | | |
| TASK-033 | Replicar TASK-031 nas 5 variantes de classe de item: `AGE/DHLSafx08Age.prw`, `AGL/DHLSafx08Agl.prw` (classe `DHLAGL08`), `DIS/DHLSafx08Dis.prw`, `AG2/DHLSafx08Ag2.prw`, `MUL/DHLSafx08Mul.prw`. | | |
| TASK-034 | Atualizar as listas de campos obrigatórios `VLD_07_FIELD` (`safx07.ch:305`) e `VLD_08_FIELD` (`safx08.ch:276`) incluindo CST-IBS/CBS e cClassTrib como obrigatórios **apenas** para documentos com data ≥ `MV_RTC55`, sem quebrar a validação dos documentos anteriores. | | |
| TASK-035 | Avaliar e, se aplicável, atualizar os includes e fontes de `SAFX112` e `SAFX116` conforme o resultado de TASK-012 (novos códigos de observação e rastreio de documento referenciado para crédito de IBS/CBS). | | |
| TASK-036 | Converter todos os fontes alterados para **CP-1252** antes da compilação, utilizando a skill `utf8-to-cp1252-conversion`. | | |

### Implementation Phase 6 — Testes, homologação e implantação

- GOAL-006: Comprovar ausência de regressão nos tributos legados e correção dos novos campos de IBS/CBS em todas as unidades de negócio. Depende de GOAL-005.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-037 | Compilar todos os fontes alterados via TOTVS Developer Studio (skill `advpl-tlpp-compile`), na ordem: `safxrtc.ch` → `safx07.ch`/`safx08.ch` → `DHLSafxRtc.tlpp` → `DHLSafx.prw` → classes `DHLSafx07*`/`DHLSafx08*` → fontes `SAFX07*`/`SAFX08*` → `ProcMsaDW.prw`. | | |
| TASK-038 | Executar o teste de **não regressão**: gerar os arquivos para o mesmo período da baseline (TASK-008) com `dDataBase` anterior a `MV_RTC55` e comparar byte a byte com a massa de baseline. Resultado esperado: diferença zero. | | |
| TASK-039 | Executar o teste de **IBS/CBS** por unidade de negócio, com documentos de entrada, saída e devolução posteriores a `MV_RTC55`, conferindo base, alíquota, valor, CST e cClassTrib contra a consulta direta em `F2D` e contra o XML da NF-e. | | |
| TASK-040 | Executar o teste de **conciliação de totais**: somatório dos itens do SAFX08 por documento × totais do cabeçalho do SAFX07 × somatório de `F2D` por documento. Tolerância: zero. | | |
| TASK-041 | Executar o teste de **documento sem cálculo em F2D** (data ≥ `MV_RTC55` e sem registro), validando que o log de TASK-020 é gerado e que o documento é tratado conforme a regra acordada com a área fiscal (bloquear × exportar com zeros). | | |
| TASK-042 | Submeter os arquivos gerados à importação em ambiente de homologação do destino definido em TASK-003 e obter o aceite formal da área fiscal DHL e do fornecedor do destino. | | |
| TASK-043 | Executar revisão de código com a skill `code-review` sobre todos os fontes alterados, garantindo ausência de violações SonarQube CRITICAL/MAJOR introduzidas e conformidade com as regras CA1002, CA1004, CA2050 e CA4000. | | |
| TASK-044 | Versionar no SVN, gerar o pacote de patch e executar a implantação em produção com janela de validação paralela (geração simultânea pelo fluxo antigo e novo) por no mínimo um período de apuração. | | |

## 3. Alternatives

- **ALT-001**: **Uso dos campos `DSC_RESERVADO1..8` dos layouts atuais.** Não escolhida como solução única: os layouts SAFX07 e SAFX08 oferecem apenas 8 posições reservadas cada, insuficientes para os ~17 campos necessários (base, alíquota e valor de 3 tributos, mais CST e cClassTrib). Viável somente como paliativo para um subconjunto de campos, mediante acordo de interpretação com o destino.
- **ALT-002**: **Extensão dos layouts SAFX07/SAFX08 com novas posições.** Depende de aceite do fornecedor do destino; como o Mastersaf DW está descontinuado, há risco alto de a extensão nunca ser suportada oficialmente.
- **ALT-003**: **Implementação dos novos dicionários SAFX3007/SAFX3008/SAFX3009.** Tecnicamente a alternativa mais alinhada ao roadmap do fornecedor, pois são os dicionários "baseados nas tabelas da reforma tributária". Implica criar novos includes, novas classes e novos fontes de geração, aproveitando os componentes das Fases 3 e 4 — porém exige o ONESOURCE Tax One como destino.
- **ALT-004**: **Descontinuar a interface Mastersaf DW e migrar para ONESOURCE Tax One.** Maior esforço e maior escopo (fora do perímetro deste plano), mas é a única alternativa que remove o risco estrutural de **CON-001**. Deve ser avaliada pela área fiscal e pela governança de TI.
- **ALT-005**: **Refatoração prévia para eliminar o clone-and-own das 7 variantes**, consolidando-as em uma única implementação parametrizada por unidade de negócio. Não escolhida para este ciclo: aumentaria significativamente o risco e o prazo frente à data legal de 03/08/2026. Recomendada como iniciativa subsequente, pois a duplicação multiplica por 7 o custo de toda manutenção fiscal futura.
- **ALT-006**: **Captar IBS/CBS do XML da NF-e** em vez de `F2D`, reaproveitando integralmente o mapeamento já existente em `ProcMsaNFe.prw`. Não escolhida como fonte primária: não cobre documentos de entrada sem XML processado nem operações sem NF-e, e desacopla a interface da apuração oficial do ERP. Mantida como fonte de **conferência** em TASK-039.

## 4. Dependencies

- **DEP-001**: **Configurador de Tributos (CFGTRIB / FISA170)** configurado, ativo e calculando IBS/CBS no ambiente DHL, com regras de cálculo, regras de escrituração e perfis de produto cadastrados.
- **DEP-002**: Release do Protheus com as tabelas `F2A`–`F2M` do Configurador de Tributos e o campo `FT_IDTRIB` presentes no dicionário (`SX2`/`SX3`), além dos campos `D1_IDTRIB` e `D2_IDTRIB`.
- **DEP-003**: Tabela `CKB` (Classificação Tributária IBS/CBS) populada com a tabela cClassTrib oficial importada (Informe Técnico 2025.002).
- **DEP-004**: Tabela `F2E` (Cadastro de Tributo) com IBS Estadual, IBS Municipal e CBS cadastrados, e parâmetros `ZZ_TRIBSUF`, `ZZ_TRIBSMU` e `ZZ_TRIBCBS` (SX6) apontando para as siglas corretas.
- **DEP-005**: Parâmetro `MV_RTC55` criado e com a data de virada definida pela área fiscal (hoje com default `20260105` no código).
- **DEP-006**: Parâmetro `ZZ_CDEMPDW` (código do estabelecimento no DW) e `ZZ_TXTINUT`, já utilizados pelos fontes e inalterados.
- **DEP-007**: Layout oficial do arquivo de destino para IBS/CBS, fornecido pela Thomson Reuters (TASK-002).
- **DEP-008**: Classe `IpSqlObject` e classes utilitárias `MsafDWFile`, `DHLSafx` e `DHLMsafDWParameters`, que permanecem como infraestrutura da interface.
- **DEP-009**: Extensão TOTVS Developer Studio (`TOTVS.tds-vscode`) e `servers.json` configurados para compilação.

## 5. Files

### Componentes novos

- **FILE-001**: `PROTHEUS/Includes/safxrtc.ch` — *(novo)* constantes de tributos IBS/CBS, posições do array de retorno e nomes de parâmetros.
- **FILE-002**: `PROTHEUS/Producao/Mastersaf_DW/DHLSafxRtc.tlpp` — *(novo)* classe de captação de IBS/CBS a partir de `F2D`/`CKB`.

### Infraestrutura compartilhada (alteração única, herdada pelas 7 variantes)

- **FILE-003**: `PROTHEUS/Producao/Mastersaf_DW/DHLSafx.prw` (1159 linhas) — classe base; novos métodos `getRtcTaxes()` e `isRtcActive()`, extensão de `getSumItems()` (linha 1101) usando `getUfTaxes()` (linha 1249) como padrão.
- **FILE-004**: `PROTHEUS/Includes/safx07.ch` — layout do cabeçalho; novos `#define`, ajuste de `SAFX07_POSICOES` (linha 298) e de `VLD_07_FIELD` (linha 305).
- **FILE-005**: `PROTHEUS/Includes/safx08.ch` — layout do item; novos `#define`, ajuste de `SAFX08_POSICOES` (linha 269) e de `VLD_08_FIELD` (linha 276).
- **FILE-006**: `PROTHEUS/Producao/Mastersaf_DW/ProcMsaDW.prw` (304 linhas) — dispatcher por unidade de negócio (linhas 183-221); alteração apenas se houver nova opção de geração.

### SAFX07 — cabeçalho (7 variantes)

- **FILE-007**: `SAFX07/SAFX07MSDW.prw` (882 linhas) — **Default + PKG + SPL**; `sf3abre()` (linha 248) e `U_SFTabre()` (linha 720, pública, também consumida por DI2).
- **FILE-008**: `SAFX07/DHLSafx07.prw` (492 linhas) — classe base do cabeçalho; `addLine()` (linha 89).
- **FILE-009**: `SAFX07/AGE/SAFX07AGE.prw` (837 linhas) + `SAFX07/AGE/DHLSafx07Age.prw` (513 linhas) — **AGE + REP**; `sf3abre()` (linha 200) e `SFTabre()` static (linha 658).
- **FILE-010**: `SAFX07/AGL/SAFX07AGL.prw` (835 linhas) + `SAFX07/AGL/DHLSafx07Agl.prw` (538 linhas, classe `DHLAGL07`) — **AGL**; `sf3abre()` (linha 202) e `SFTabre()` static (linha 656).
- **FILE-011**: `SAFX07/AG2/07AG2SAFX.prw` (893 linhas) + `SAFX07/AG2/DHLSafx07Ag2.prw` (639 linhas) — **AG2**; `sf3abre()` (linha 191) e `SFTabre()` static (linha 740).
- **FILE-012**: `SAFX07/DIS/SAFX07DIS.prw` (157 linhas) + `SAFX07/DIS/DHLSafx07Dis.prw` (720 linhas) — **DIS**; padrão A (`getSql()` na linha 52, `getTaxRecord()`, `getItemFlowsRecord()`).
- **FILE-013**: `SAFX07/MUL/07SAFXMUL.prw` (155 linhas) + `SAFX07/MUL/DHLSafx07Mul.prw` (445 linhas) — **MUL**; padrão A.
- **FILE-014**: `SAFX07/DI2/Di2SAFX07MSDW.prw` (694 linhas) + `SAFX07/DI2/Di2DHLSafx07.prw` (492 linhas) — **DI2**; `sf3abre()` (linha 248), reutiliza `U_SFTabre()` de FILE-007.

### SAFX08 — itens (6 variantes)

- **FILE-015**: `SAFX07/SAFX08MSDW.prw` (173 linhas) + `SAFX07/DHLSafx08.prw` (848 linhas) — **Default + PKG + SPL**; `addLine()` (linha ~220), `getSqlFt()` (linha 109).
- **FILE-016**: `SAFX07/AGE/SAFX08AGE.prw` (238 linhas) + `SAFX07/AGE/DHLSafx08Age.prw` (756 linhas) — **AGE + REP**.
- **FILE-017**: `SAFX07/AGL/SAFX08AGL.prw` (238 linhas) + `SAFX07/AGL/DHLSafx08Agl.prw` (757 linhas, classe `DHLAGL08`) — **AGL**.
- **FILE-018**: `SAFX07/AG2/08AG2SAFX.prw` (214 linhas) + `SAFX07/AG2/DHLSafx08Ag2.prw` (875 linhas) — **AG2**.
- **FILE-019**: `SAFX07/DIS/SAFX08DIS.prw` (163 linhas) + `SAFX07/DIS/DHLSafx08Dis.prw` (858 linhas) — **DIS**.
- **FILE-020**: `SAFX07/MUL/08SAFXMUL.prw` (140 linhas) + `SAFX07/MUL/DHLSafx08Mul.prw` (823 linhas) — **MUL**.

### SAFX112 / SAFX116 — observações e documentos referenciados (impacto indireto)

- **FILE-021**: `PROTHEUS/Includes/safx112.ch` (15 posições) e `safx116.ch` (21 posições) — avaliar novos códigos de observação e rastreio de referência.
- **FILE-022**: `SAFX07/SAFX112MSDW.prw`, `SAFX07/DHLSafx112.prw`, `SAFX07/AG2/112AG2SAFX.prw`, `SAFX07/AG2/DHLSafx112Ag2.prw`, `SAFX07/AGE/DHLSafx112Age.prw`, `SAFX07/AGE/SAFX112MSDW.prw`, `SAFX07/AGL/AGL112.prw`, `SAFX07/AGL/_AGL112.prw`, `SAFX07/DIS/SAFX112DIS.prw`, `SAFX07/DIS/DHLSafx112Dis.prw`, `SAFX07/MUL/112SAFXMUL.prw`, `SAFX07/MUL/DHLSafx112Mul.prw`.
- **FILE-023**: `SAFX07/SAFX116MSDW.prw`, `SAFX07/DHLSafx116.prw`, `SAFX07/AG2/116AG2SAFX.prw`, `SAFX07/AG2/DHLSafx116Ag2.prw`, `SAFX07/AGE/SAFX116AGE.prw`, `SAFX07/AGE/DHLSafx116Age.prw`, `SAFX07/AGL/SAFX116AGL.prw`, `SAFX07/AGL/DHLSafx116Agl.prw`, `SAFX07/DIS/SAFX116DIS.prw`, `SAFX07/DIS/DHLSafx116Dis.prw`, `SAFX07/MUL/116SAFXMUL.prw`, `SAFX07/MUL/DHLSafx116Mul.prw`.

### Fontes de referência (não alterados — usados como padrão)

- **FILE-024**: `PROTHEUS/Producao/Controle_de_ID_Good-Bad/DHLIdManager.prw:261-341` — padrão validado de leitura de `F2D` por `D1_IDTRIB`/`D2_IDTRIB` e dos parâmetros `ZZ_TRIBCBS`/`ZZ_TRIBSUF`/`ZZ_TRIBSMU`.
- **FILE-025**: `PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw:4421+` — mapeamento semântico completo de IBS/CBS (CST, cClassTrib, gIBSCBS, gIBSUF, gDif) e uso do parâmetro `MV_RTC55`.
- **FILE-026**: `PROTHEUS/Producao/SAP/SCJ/SAPIP040.prw:447-1099` e `PROTHEUS/Producao/SAP/SCJ/Classes/DHLIp040Sap.prw:15-18` — campos `ZB_IBSUFTX/BS/VL`, `ZB_IBSMUTX/BS/VL`, `ZB_CBSTXRT/BS/VL` recebidos da integração SAP; fonte alternativa de conferência.
- **FILE-027**: `PROTHEUS/Producao/Validacao_dos_Impostos/DHLTaxes.prw:250-265` — totalizadores de IBS/CBS por item de XML já existentes na validação de impostos.

### Arquivos não localizados no workspace (confirmação necessária)

- **FILE-028**: Não existe diretório `SAFX07/REP` nem `SAFX07/PKG` — confirmado em `ProcMsaDW.prw` que `REP` é atendido por `U_SAFX07AGE()` e `PKG`/`SPL` pelo ramo `else` (`U_SAFX07MSDW()`). Nenhum fonte adicional a criar.
- **FILE-029**: `SAFX07/DHLSafx116.~pr` (318 linhas) é arquivo de backup do editor; deve ser excluído do escopo e, preferencialmente, removido do repositório.
- **FILE-030**: `SAFX07/AGL/_AGL112.prw` e `SAFX07/MUL/DHLSafx52Mul.prw` (duplicata de `SAFX52/MUL/DHLSafx52Mul.prw`) — confirmar se são fontes mortos antes de incluí-los no escopo de alteração.

## 6. Testing

- **TEST-001**: **Não regressão byte a byte** — para `dDataBase` anterior a `MV_RTC55`, os arquivos SAFX07/08/112/116 gerados após a alteração devem ser idênticos à baseline de TASK-008, nas 9 unidades de negócio.
- **TEST-002**: **Captação de IBS/CBS por item** — para cada unidade de negócio, validar base, alíquota e valor de IBS UF, IBS Municipal e CBS no SAFX08 contra `SELECT F2D_TRIB, F2D_BASE, F2D_ALIQ, F2D_VALOR FROM F2D WHERE F2D_IDREL = <FT_IDTRIB>`.
- **TEST-003**: **CST-IBS/CBS e cClassTrib** — validar que o cClassTrib gravado tem 6 posições e que seus 3 primeiros dígitos coincidem com o CST gravado, para todos os itens exportados.
- **TEST-004**: **Conciliação cabeçalho × itens** — somatório dos valores de IBS/CBS dos itens do SAFX08 deve igualar os totais do cabeçalho do SAFX07, com tolerância zero.
- **TEST-005**: **Conciliação com a NF-e** — totais de IBS/CBS do SAFX07 devem conferir com as tags `vIBS`, `vIBSUF`, `vIBSMun` e `vCBS` do XML da NF-e correspondente.
- **TEST-006**: **Documento sem cálculo em F2D** — documento com data ≥ `MV_RTC55` sem registro em `F2D` deve gerar log de alerta (TASK-020) e seguir a regra de tratamento acordada.
- **TEST-007**: **Registro estornado** — registro de `F2D` com `F2D_DTEXCL` preenchida não deve ser somado em nenhum campo do arquivo.
- **TEST-008**: **Operações de devolução e entrada** — validar entradas (`F3_CFO < 5000`) e devoluções (`F3_TIPO IN ('D','B')`) separadamente, dado que `sf3abre()` trata esses casos em blocos `UNION ALL` distintos.
- **TEST-009**: **Fronteira de data** — gerar documentos em D-1, D e D+1 em relação a `MV_RTC55` e validar a ativação/desativação correta da captação de IBS/CBS.
- **TEST-010**: **Documentos cancelados, de inventário e de cutover** — validar que as exclusões existentes (`F3_DTCANC`, `isInventario()`, `isCutover()` em `SAFX07MSDW.prw:164-233`) continuam funcionando com os novos JOINs.
- **TEST-011**: **Validação de campos obrigatórios** — exercitar `validRequired()` com `VLD_07_FIELD`/`VLD_08_FIELD` atualizados, antes e depois da data de corte.
- **TEST-012**: **Importação no destino** — importar os arquivos gerados no ambiente de homologação do destino (DW ou Tax One) sem erro de layout, posição ou quantidade de colunas.
- **TEST-013**: **Desempenho** — medir o tempo de geração antes e depois da inclusão dos JOINs com `F2D`, para um volume representativo. Os novos JOINs ocorrem dentro do laço por documento (`SAFX07MSDW.prw:77-127`), com risco de degradação; critério de aceite a definir com a operação.
- **TEST-014**: **Encoding** — validar que todos os fontes alterados permanecem em CP-1252 e que caracteres acentuados nos logs e mensagens não foram corrompidos.
- **TEST-015**: **Teste e2e TIR** — automatizar a execução da rotina `ProcMsaDW` pela interface (skill `tir-test-generator`), cobrindo a seleção do SAFX07 com intervalo de datas e tipo de documento, por unidade de negócio.

## 7. Risks & Assumptions

### Riscos

- **RISK-001**: **(Crítico)** O Mastersaf DW está descontinuado e, conforme o roadmap do fornecedor, não recebeu as adequações de IBS/CBS. Todo o esforço das Fases 3-6 pode não ter destino válido. **Mitigação**: Fase 1 é bloqueante; nenhuma linha de layout deve ser escrita antes de TASK-002/TASK-003.
- **RISK-002**: **(Crítico)** Ausência de campos nativos de IBS/CBS nos layouts SAFX07/SAFX08 (CON-002), com apenas 8 posições reservadas em cada. O conjunto completo de campos não cabe. **Mitigação**: priorizar campos com a área fiscal ou adotar ALT-003/ALT-004.
- **RISK-003**: **(Alto)** A duplicação em 7 variantes (CON-003) faz com que uma alteração esquecida em uma cópia produza arquivo fiscal incorreto para uma unidade de negócio inteira, silenciosamente. **Mitigação**: centralizar na classe base (GOAL-003), usar checklist por variante e exigir TEST-001/TEST-002 em todas as 9 unidades.
- **RISK-004**: **(Alto)** Se o Configurador de Tributos não estiver cadastrado corretamente (regras de cálculo, escrituração, cClassTrib), `F2D` virá vazia e os arquivos sairão com IBS/CBS zerados sem erro aparente. **Mitigação**: TASK-005, TASK-020 e TEST-006.
- **RISK-005**: **(Médio)** Degradação de desempenho: os novos JOINs com `F2D` são executados dentro do laço por documento, somando-se às chamadas de `posicione()` já existentes em `addLine()` (`CDT`, `SFS`, `NPR`). **Mitigação**: TEST-013 e, se necessário, pré-carga de `F2D` por período em tabela temporária (`FWTemporaryTable`).
- **RISK-006**: **(Médio)** Campos legados podem ser zerados pelo CFGTRIB (TASK-010), causando regressão em tributos hoje corretos (ICMS, IPI, PIS, COFINS) ao migrar o motor de cálculo. **Mitigação**: TASK-010 antes de qualquer alteração e TEST-001 como gate.
- **RISK-007**: **(Médio)** As siglas de tributo em `F2E` podem divergir entre as unidades de negócio/empresas, invalidando um parâmetro único. **Mitigação**: TASK-004 por unidade de negócio; se divergirem, parametrizar por empresa/filial.
- **RISK-008**: **(Médio)** `FT_IDTRIB` pode não estar populado para todos os documentos (notas importadas, documentos legados, integrações SAP/TOTVS IP). **Mitigação**: fallback por `D1_IDTRIB`/`D2_IDTRIB` (TASK-015) e log de exceção.
- **RISK-009**: **(Baixo)** Alterações em `U_SFTabre()` (pública em `SAFX07MSDW.prw`) impactam `Di2SAFX07MSDW.prw`, que a consome. Compilação parcial pode gerar inconsistência em produção. **Mitigação**: TASK-026 e ordem de compilação definida em TASK-037.
- **RISK-010**: **(Baixo)** Fontes possivelmente mortos (`DHLSafx116.~pr`, `_AGL112.prw`, `MUL/DHLSafx52Mul.prw`) podem ser alterados por engano ou, pior, estar ativos no RPO. **Mitigação**: FILE-030 e conferência no RPO antes da entrega.
- **RISK-011**: **(Baixo)** Prazo legal fixo em 03/08/2026 combinado com a dependência de terceiro (fornecedor do destino) na Fase 1. **Mitigação**: iniciar TASK-001 imediatamente e executar a Fase 2 em paralelo.

### Premissas

- **ASSUMPTION-001**: O Configurador de Tributos (FISA170) será o motor oficial de cálculo de IBS/CBS na DHL, conforme a arquitetura do Protheus, sem cálculo paralelo customizado.
- **ASSUMPTION-002**: O relacionamento `SFT.FT_IDTRIB = F2D.F2D_IDREL` com `F2D_TABELA = 'SFT'` é válido na release instalada na DHL. Deve ser confirmado em TASK-005 — a documentação pública descreve o vínculo também por `SD1`/`SD2`.
- **ASSUMPTION-003**: As siglas `TR0001` (CBS), `TR0002` (IBS UF) e `TR0003` (IBS Municipal), já usadas como default em `DHLIdManager.prw`, refletem o cadastro real de `F2E` na DHL. Sujeito a confirmação em TASK-004.
- **ASSUMPTION-004**: O parâmetro `MV_RTC55` (default `20260105` no código) é a data de corte oficial adotada pela DHL para a Reforma Tributária e será mantido como chave única de ativação em todas as interfaces.
- **ASSUMPTION-005**: A estrutura de arquivo posicional (`MsafDWFile`) e o mecanismo de log (`SZ2`) permanecem válidos e não requerem alteração.
- **ASSUMPTION-006**: As unidades de negócio ativas são exatamente as 9 definidas em `PROTHEUS/Includes/dhl.ch:70-79` (`SPL`, `PKG`, `REV`, `DIS`, `REP`, `AGE`, `MUL`, `AG2`, `AGL`, `DI2`), sendo `REV` sem tratamento específico em `ProcMsaDW.prw` (cai no ramo `else`).
- **ASSUMPTION-007**: A decisão sobre split payment e sobre o preenchimento dos campos de PIS/COFINS/ICMS/IPI durante o período de transição (2026-2032) será fornecida pela área fiscal (TASK-011) e não é inferida pela equipe técnica.

## 8. Related Specifications / Further Reading

- [CFGTRIB - Configurador de Tributos - Linha Microsiga Protheus - TDN](https://tdn.totvs.com/display/public/PROT/CFGTRIB+-+Configurador+de+Tributos)
- [CFGTRIB - Perguntas e Respostas - Configurador de Tributos - TDN](https://tdn.totvs.com/display/public/PROT/CFGTRIB+-+Perguntas+e+Respostas+-+Configurador+de+Tributos)
- [CFGTRIB - Adequação do Configurador de Tributos aos Códigos de Classificação Tributária do IBS, CBS e IS - TDN](https://tdn.totvs.com/pages/releaseview.action?pageId=962623217)
- [FISA170 - Quais tabelas fazem parte do Configurador de Tributos? - Central de Atendimento TOTVS](https://centraldeatendimento.totvs.com/hc/pt-br/articles/35314721022103-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-FIS-FISA170-Quais-tabelas-fazem-parte-do-Configurador-de-Tributos)
- [Relacionamento entre tabelas SD1/SD2, SFT, CJ3 e F2D no Configurador de Tributos - Central de Atendimento TOTVS](https://centraldeatendimento.totvs.com/hc/pt-br/articles/38741160434199-CROSS-Segmentos-TOTVS-Backoffice-Linha-Protheus-FIS-Relacionamento-entre-tabelas-SD1-SD2-SFT-CJ3-e-F2D-no-Configurador-de-Tributos)
- [FIS - Adequação à obrigatoriedade do IBS e CBS a partir de 03 de agosto de 2026 - Central de Atendimento TOTVS](https://centraldeatendimento.totvs.com/hc/pt-br/articles/42351363577623-CROSS-Segmentos-TOTVS-Backoffice-Linha-Protheus-FIS-Adequa%C3%A7%C3%A3o-%C3%A0-obrigatoriedade-do-IBS-e-CBS-a-partir-de-03-de-agosto-de-2026)
- [Como importar a tabela cClassTrib-IBS/CBS no Configurador de Tributos - Central de Atendimento TOTVS](https://centraldeatendimento.totvs.com/hc/pt-br/articles/34662420522391-CROSS-Segmentos-TOTVS-Backoffice-Linha-Protheus-FIS-Como-importar-a-tabela-cClassTrib-IBS-CBS-no-Configurador-de-Tributos)
- [Reforma Tributária - RoadMap 2026 - Thomson Reuters ONESOURCE](https://roadmap.thomsonreuters.com/reforma_2026.html)
- [Compliance - ONESOURCE TAX ONE - RoadMap 2026](https://www.roadmap.thomsonreuters.com/tax_taxone_2026.html)
- [Tabela F2D - Tributos Genéricos Calculados](https://tabelas-protheus.projetive.com.br/F2D)
- [Tabela SFT - Livro Fiscal por Item de NF (campo FT_IDTRIB)](https://tabelas-protheus.projetive.com.br/SFT)
- [Tabela CKB - Classificação Tributária IBS/CBS](https://tabelas-protheus.projetive.com.br/CKB)
- [Informe Técnico 2025.002 - Tabelas de Classificação do IBS e da CBS](https://www.nfe.fazenda.gov.br/portal/exibirArquivo.aspx?conteudo=JDJJBVuJyoA%3D)
- Fontes internos de referência: `PROTHEUS/Producao/Controle_de_ID_Good-Bad/DHLIdManager.prw`, `PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw`, `PROTHEUS/Producao/SAP/SCJ/SAPIP040.prw`, `PROTHEUS/Producao/Validacao_dos_Impostos/DHLTaxes.prw`
