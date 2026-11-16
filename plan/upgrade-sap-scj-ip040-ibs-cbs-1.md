---
goal: Adequar a interface SAP/SCJ (IP_040 / IP_150 / IP_190 — NF RCO e RET da unidade AG2) ao Configurador de Tributos (CFGTRIB/FISA170) e à Reforma Tributária do Consumo (IBS/CBS)
version: 1.0
date_created: 2026-11-13
last_updated: 2026-11-13
owner: DHL - Equipe Protheus / Fiscal (DV2) - Unidade de Negócio AG2 (SCJ - PUZZLE)
status: 'Planned'
tags: [upgrade, integration, fiscal, reforma-tributaria, ibs-cbs, cfgtrib, sap, execauto, architecture]
---

# Introduction

![Status: Planned](https://img.shields.io/badge/status-Planned-blue)

Este plano define a adequação da **interface SAP ↔ Protheus da unidade de negócio AG2 (SCJ - PUZZLE)** ao **Configurador de Tributos (CFGTRIB / FISA170)** e à **Reforma Tributária do Consumo (IBS/CBS)**, obrigatória a partir de **03/08/2026**.

O escopo abrange os 7 fontes indicados: `DHLIp040Sap.prw`, `PrcGrvRco.prw`, `PrcNfRco.prw`, `PrcNfRet.prw`, `DHLIp150.prw`, `PrcGrvRet.prw` e `SAPIP190.prw`, mais os fontes acoplados indispensáveis ao fluxo (`SAPIP040.prw`, `SAPIP150.prw`, `MonIp040.prw` e os Pontos de Entrada `M460FIM`, `MT920TOK` e `MS520VLD`).

**Arquitetura atual (resumo factual).** O SAP é a autoridade fiscal do processo: envia o XML `IP_040`, que `SAPIP040.prw` grava em `SZA` (cabeçalho) e `SZB` (itens). A partir daí, `PrcNfRco.prw` gera a NF de Remessa por Conta e Ordem via `MsExecAuto(MATA920)` e `PrcNfRet.prw` gera a NF de Retorno Simbólico via `MaPvlNFS()`. Depois da geração, `DHLIp040Sap:validValues()` **compara e sobrescreve** os valores calculados pelo Protheus (`SF2`, `SD2`, `SF3`, `SFT`, `CD2`) pelos valores recebidos do SAP, usando a tabela De/Para `SZD`. O cancelamento é tratado pela `IP_150` (`DHLIp150.prw`).

**Problema central.** Os valores de IBS/CBS **já chegam do SAP e já são gravados em `SZA`/`SZB`** (mecanismo dinâmico por dicionário, descrito em `PAT-001`), mas **param ali**: nenhuma etapa posterior os consome. Os tributos novos são calculados pelo Configurador de Tributos e gravados na tabela `F2D` (Tributos Genéricos Calculados), enquanto o motor de conciliação da interface só conhece `CD2` (`ICM`, `SOL`, `CMP`, `ZFM`). Resultado: a NF gerada pelo Protheus para a SCJ terá IBS/CBS calculados pelo CFGTRIB **sem nenhuma conciliação com o SAP**, e as divergências entre SAP e Protheus passarão silenciosamente — exatamente o oposto da premissa de controle que a interface foi construída para garantir.

## 1. Requirements & Constraints

### Requisitos funcionais

- **REQ-001**: Os valores de IBS Estadual, IBS Municipal e CBS recebidos do SAP (`SZB`: `ZB_IBSUFTX`/`ZB_IBSUFBS`/`ZB_IBSUFVL`, `ZB_IBSMUTX`/`ZB_IBSMUBS`/`ZB_IBSMUVL`, `ZB_CBSTXRT`/`ZB_CBSTXBS`/`ZB_CBSTXVL`; `SZA`: totais) devem ser **conciliados** com os valores calculados pelo Configurador de Tributos e gravados em `F2D`, por item do documento.
- **REQ-002**: A conciliação deve ocorrer por item, relacionando `SD2.D2_IDTRIB` (ou `SFT.FT_IDTRIB`) com `F2D.F2D_IDREL`, filtrando `F2D_TABELA`, `F2D_TRIB` (sigla do tributo), `F2D_DTEXCL` vazia e `D_E_L_E_T_ = ' '`, comparando `F2D_BASE`, `F2D_ALIQ` e `F2D_VALOR`.
- **REQ-003**: A regra de tratamento de divergência entre SAP e CFGTRIB deve ser **explicitamente definida pela área fiscal** entre três opções mutuamente exclusivas, e implementada como parâmetro: (a) **bloquear** o faturamento e registrar log; (b) **sobrescrever** `F2D` com os valores do SAP; (c) **aceitar** o valor do CFGTRIB e apenas registrar a divergência para auditoria. Ver `ALT-001` a `ALT-003` e `RISK-001`.
- **REQ-004**: O CST-IBS/CBS e o cClassTrib do item devem ser conciliados entre o que o SAP informa e o que a Regra de Escrituração do CFGTRIB aplica (tabela `CKB`, campo `CKB_CSTCCT`), pois divergência nesses códigos invalida a NF-e (rejeição) mesmo com valores corretos.
- **REQ-005**: A seleção de TES (`DHLIp040Sap:getTesOperation()`, tabela de regras `SZC`) deve ser revista: hoje decide exclusivamente por ICMS, ICMS-ST, Redução de Base, DIFAL e ZFM. Sob o CFGTRIB o IBS/CBS **não é dirigido por TES**, e é preciso definir se a TES continua sendo o eixo de decisão do fluxo ou se passa a ser apenas insumo das regras do Configurador.
- **REQ-006**: Toda a captação e conciliação de IBS/CBS deve ser condicionada por data de corte, reutilizando o parâmetro `MV_RTC55` já existente no workspace (`SuperGetMv('MV_RTC55',.f.,stod('20260105'))`, usado em `ProcMsaNFe.prw:30` e `ProcRCOMsa.prw:31`), preservando integralmente o comportamento atual para documentos anteriores à virada.
- **REQ-007**: As siglas dos tributos devem ser lidas dos parâmetros já existentes `ZZ_TRIBCBS` (default `TR0001`), `ZZ_TRIBSUF` (default `TR0002`) e `ZZ_TRIBSMU` (default `TR0003`), conforme `DHLIdManager.prw:261-263` — nunca hardcoded.
- **REQ-008**: O cancelamento pela `IP_150` deve garantir o estorno/exclusão correta dos registros de `F2D` associados ao documento, tanto no caminho `ExcluiRCO()` (`MATA920` opção 5) quanto no `ExcluiRET()` (`MaDelNFS()`).
- **REQ-009**: A criação de qualquer novo campo em `SZA`/`SZB` **obriga** a criação, no mesmo pacote, da função `get<7 caracteres do nome do campo>()` correspondente em `SAPIP040.prw` — ver `CON-001` e `RISK-002`.

### Requisitos de negócio / fiscais

- **FIS-001**: A obrigatoriedade de destaque e cálculo de IBS/CBS vigora a partir de **03/08/2026**.
- **FIS-002**: A apuração de IBS/CBS no Protheus só é suportada via Configurador de Tributos (FISA170); não há caminho por matriz de TES.
- **FIS-003**: O enquadramento de **Remessa por Conta e Ordem** e de **Retorno Simbólico** (operações de armazém geral / depositante) no IBS/CBS é matéria de legislação e de definição fiscal, não técnica. O CFOP, o CST-IBS/CBS e o cClassTrib aplicáveis a cada uma dessas operações devem ser fornecidos pela área fiscal (ver `TASK-004`).
- **FIS-004**: O texto legal gravado na tabela de mensagens `SZZ` para RCO (`PrcGrvRco.prw:347-352`) e para Retorno Simbólico (`PrcGrvRet.prw:79-120`) referencia o regime atual e deve ser revisado pela área fiscal frente à LC 214/2025.

### Restrições

- **CON-001**: **Acoplamento por convenção de nomes.** `SAPIP040.prw:66-72` e `:136-144` percorrem **todos** os campos de `SZA`/`SZB` no dicionário e chamam dinamicamente, por macro, `&("get" + SubStr(campo,4,7) + "()")`. Isso significa que (a) os campos de IBS/CBS já são populados automaticamente, desde que existam no `SX3` e estejam em uso; e (b) **qualquer campo novo sem função `get` correspondente provoca erro de execução**. As listas de exclusão `CAMPOS_SZA` e `CAMPOS_SZB` (`SAPIP040.prw:4-5`) não contemplam campos de IBS/CBS.
- **CON-002**: **`F2D` não é posicionável pelo padrão atual.** O motor `validValues()` posiciona a tabela destino por `dbSeek` de chave composta (`FILIAL+TIPO+SERIE+DOC+CLIENTE+LOJA+ITEM+PRODUTO+IMPOSTO`, ver `DHLIp040Sap.prw:368-382`). A `F2D` é chaveada por `F2D_ID`/`F2D_IDREL` (36 posições, GUID) e não possui as colunas de documento — portanto **não é acessível pelo mecanismo existente** e exige um caminho de acesso novo.
- **CON-003**: **`F2D` é tabela do motor fiscal.** A documentação TOTVS classifica `F2D` entre as tabelas cujo modo de compartilhamento não pode ser alterado, e seus registros carregam IDs de rastreabilidade (`F2D_ID`, `F2D_IDCAD`, `F2D_IDBASE`, `F2D_IDALIQ`, `F2D_ORIGEM`). Sobrescrevê-la por fora do Configurador rompe a rastreabilidade entre o valor apurado e a regra que o gerou — risco de inconsistência na apuração e na escrituração.
- **CON-004**: **Mutação de cadastros em tempo de execução.** `PrcNfRco.prw:300-311` executa `UPDATE` direto em `SF4.F4_BASEICM` (percentual de redução de base da TES) e `PrcNfRco.prw:355-376` executa `UPDATE` direto em `SB1.B1_PICMRET` (MVA do produto), ambos por nota processada. São cadastros globais alterados por documento — risco de concorrência em faturamento simultâneo (há comentários no próprio código sobre esse problema, de 2018) e padrão incompatível com a governança exigida pelo Configurador de Tributos.
- **CON-005**: **Gravação direta em tabelas fiscais.** `PrcGrvRco.prw:77-158` executa `RecLock`/`MsUnlock` direto em `SD2`, `SFT`, `CD2`, `SF3` e `SF2`, e `PrcNfRet.prw:539-631` (`U_GravaFCP`) faz o mesmo para FCP. Com o CFGTRIB ativo, qualquer gravação direta em bases/valores precisa ser espelhada em `F2D`, sob pena de os livros e a apuração divergirem.
- **CON-006**: **Chave de conciliação com `SF3` baseada em CFOP + alíquota de ICMS.** `DHLIp040Sap.prw:419` e `PrcGrvRco.prw:130` usam `SF3->DbSeek(... + cCfop + cAliq)`, com `cAliq` derivado de `ZB_ICMTXRT` e forçado a `"0.00"` quando há redução de base. Além disso `isEqualSf3()`/`ZA_F3QTLIN` (`DHLIp040Sap.prw:556-569`, `SAPIP040.prw:102-112`) valida a **quantidade de linhas** de `SF3` esperada. Alterações no desmembramento de `SF3` decorrentes da escrituração dos tributos novos quebram ambos os mecanismos.
- **CON-007**: **`F3_REPROC = 'N'`.** `PrcGrvRco.prw:385-401` força o flag de reprocessamento fiscal para "não" ao final do processamento. Se o recálculo de IBS/CBS exigir reprocessamento no módulo fiscal, esse flag impedirá a correção.
- **CON-008**: **Dois caminhos de geração de NF com motores fiscais distintos.** RCO usa `MsExecAuto(MATA920)` (documento de saída manual — `PrcNfRco.prw:214`); RET usa `MaPvlNFS()` a partir de Pedido de Venda liberado (`PrcNfRet.prw:358`). Os dois caminhos acionam o Configurador de Tributos de formas diferentes e precisam ser validados separadamente.
- **CON-009**: **`SZD` é parametrização, não código.** O De/Para `ZD_TABDE`/`ZD_CPODE`/`ZD_TABPARA`/`ZD_CPOPARA` (`DHLIp040Sap:setFieldsSzd()`) é carregado do banco. Nenhuma linha de IBS/CBS existirá sem cadastro — e cadastrar linha apontando para `F2D` não funciona sem o tratamento de `CON-002`.
- **CON-010**: Todos os fontes `.prw` devem permanecer em **CP-1252 (Windows-1252)**.
- **CON-011**: Não há repositório Git neste workspace (controle por `.svn`). O versionamento deve seguir o processo SVN vigente.
- **CON-012**: O fluxo é específico da unidade de negócio **AG2**; `SAPIP150.prw:8` documenta explicitamente "Processo para a Unidade de Negócio AG2(SCJ - PUZZLE)". Alterações não devem afetar as demais unidades.
- **CON-013**: As queries usam concatenação direta de strings e `getValue()` com macro (`&`), violando SonarQube CA2050 (SQL Injection). Correções pontuais nas linhas alteradas são permitidas; refatoração global está fora de escopo.

### Diretrizes e padrões

- **GUD-001**: Novos componentes devem ser gerados em **TLPP** (`.tlpp`), com `#include "tlpp-core.th"` seguido de `#include "totvs.ch"`, tipagem estática e `Try/Catch`.
- **GUD-002**: Alterações em fontes `.prw` existentes mantêm AdvPL, para não misturar paradigmas em arquivos de 200-1500 linhas em produção.
- **GUD-003**: Proibido `IIF()`/`IF()` inline, `ConOut()` (há ocorrência a corrigir em `PrcNfRco.prw:418-420`), `MSCREATE()`/`DBCREATE()`/`CRIATRAB()` e uso direto da variável `cFilial` em código novo.
- **GUD-004**: **Proibido chamar UI dentro de transação** (SonarQube CA1002). `PrcNfRco.prw:115-117` usa `MsgInfo`/`MsgAlert` e `PrcNfRco.prw:304-305` usa `MsgAlert` dentro do fluxo transacional; `DHLIp040Sap:showLogError()` usa `Aviso()`. Código novo deve registrar em log e delegar a exibição ao final do processamento.
- **GUD-005**: Toda função/método novo deve conter bloco `/*/{Protheus.doc}/*/` com `@type`, `@author`, `@since`, `@param` e `@return`.
- **GUD-006**: Logs devem seguir o padrão já adotado no fluxo: `FWLogMsg()` + `DHLLogManager()` (`oLog:start(APP_SAP, DHL_IMPORTACAO)` / `oLog:fail()` / `oLog:warn()`).
- **PAT-001**: **Padrão de captação automática por dicionário** — `SAPIP040.prw:66-72` (SZA) e `:136-144` (SZB). As funções `getIBSUFTX()`, `getIBSUFBS()`, `getIBSUFVL()`, `getIBSMUTX()`, `getIBSMUBS()`, `getIBSMUVL()`, `getCBSTXRT()`, `getCBSTXBS()`, `getCBSTXVL()` (`SAPIP040.prw:940-1099`) e os totais `getIBSUFTO()`, `getIBSMUTO()`, `getIBSTOTA()`, `getCBSTOTA()` (`:447-466`) **já estão implementadas** e leem as tags `_IBS_UF`, `_IBS_MUN` e `_CBS` do XML com guarda `Type(...) <> "U"`.
- **PAT-002**: **Padrão de agregação automática por dicionário** — `retCposSZB()` e `retCposSf3()` (`DHLIp040Sap.prw:1110-1151`) montam a lista de `SUM()` percorrendo todos os campos numéricos do `SX3`. Campos numéricos de IBS/CBS em `SZB` já entram na aglutinação sem alteração de código.
- **PAT-003**: **Padrão de gravação de tributo novo vindo do SAP** — `U_GravaFCP()` / `GravaCab()` / `GravaItens()` (`PrcNfRet.prw:495-631`), entregue no projeto NF 4.0: grava um tributo recebido em `SZA`/`SZB` dentro de `SF3`, `SD2`, `SFT` e `CD2`. É o molde direto para um equivalente de IBS/CBS, trocando o destino `CD2` por `F2D`.
- **PAT-004**: **Padrão de leitura de `F2D`** — `DHLIdManager.prw:261-341` (subqueries por tributo com `F2D_IDREL = D1_IDTRIB`/`D2_IDTRIB`, `F2D_TABELA`, `F2D_TRIB`, `%F2D.NOTDEL%`) e os parâmetros `ZZ_TRIBCBS`/`ZZ_TRIBSUF`/`ZZ_TRIBSMU`.
- **PAT-005**: **Padrão de mapeamento semântico IBS/CBS** — `ProcMsaNFe.prw:4421+` (`DoIBSCBS`, `DogIBSCBS`, `DogIBSUF`, `DogIBSUFDif`, `DogDevTrib`), com CST, cClassTrib, `vBC`, `vIBS`, `pIBSUF`, `vIBSUF`, `pDif`, `vDif`.

## 2. Implementation Steps

### Implementation Phase 1 — Decisões fiscais e levantamento do ambiente

- GOAL-001: Eliminar as três indefinições que bloqueiam o desenho técnico — regra de divergência, enquadramento fiscal das operações RCO/RET e papel da TES. Fase **sequencial e bloqueante** para as Fases 3 a 6.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-001 | Definir com a área fiscal a **regra de tratamento de divergência** entre o IBS/CBS informado pelo SAP e o calculado pelo CFGTRIB, escolhendo entre bloquear, sobrescrever ou aceitar-e-logar (`REQ-003`, `ALT-001` a `ALT-003`). Registrar a decisão e criar o parâmetro de controle correspondente (`ZZ_RTCDIVG`). | | |
| TASK-002 | Confirmar no dicionário (`SX3`) a existência e o uso dos campos `ZB_IBSUFTX`, `ZB_IBSUFBS`, `ZB_IBSUFVL`, `ZB_IBSMUTX`, `ZB_IBSMUBS`, `ZB_IBSMUVL`, `ZB_CBSTXRT`, `ZB_CBSTXBS`, `ZB_CBSTXVL` e dos totais em `SZA` (`ZA_IBSUFTO`, `ZA_IBSMUTO`, `ZA_IBSTOTA`, `ZA_CBSTOTA`), validando `X3_USADO` e `X3_NIVEL`. Confirmar que cada um tem a função `get` correspondente em `SAPIP040.prw` (`CON-001`). | | |
| TASK-003 | Obter do time SAP a **especificação atualizada do XML `IP_040`** com as tags de IBS/CBS efetivamente enviadas, incluindo CST-IBS/CBS, cClassTrib, diferimento, crédito presumido e devolução de tributo. Confrontar com as tags hoje lidas (`_IBS_UF`, `_IBS_MUN`, `_CBS`, cada uma com `_TAX_RATE`, `_BASE_AMOUNT`, `_TAX_VALUE`) e identificar o que falta. | | |
| TASK-004 | Obter da área fiscal o **enquadramento no IBS/CBS das operações de Remessa por Conta e Ordem e de Retorno Simbólico** (CFOP, CST-IBS/CBS e cClassTrib aplicáveis), incluindo o tratamento de armazém geral / depositante (`FIS-003`). | | |
| TASK-005 | Decidir o **papel da TES no fluxo** sob o CFGTRIB: manter `getTesOperation()`/`SZC` como eixo de decisão, estender as regras com critérios de IBS/CBS, ou reduzir a TES a insumo das regras do Configurador (`REQ-005`). | | |
| TASK-006 | Inventariar as **siglas reais de tributo** em `F2E` (Cadastro de Tributo) para IBS Estadual, IBS Municipal e CBS no ambiente AG2, e confrontar com os defaults `TR0002`/`TR0003`/`TR0001` dos parâmetros `ZZ_TRIBSUF`/`ZZ_TRIBSMU`/`ZZ_TRIBCBS` e com os códigos padrão TOTVS (`000060`/`000061`/`000062`). Corrigir o `SX6` se divergirem. | | |
| TASK-007 | Validar no ambiente AG2 que o Configurador de Tributos (FISA170) está ativo e gravando em `F2D` nos **dois** caminhos de geração: `MATA920` (RCO) e `MaPvlNFS` (RET), conferindo `F2D_TRIB`, `F2D_BASE`, `F2D_ALIQ`, `F2D_VALOR`, `F2D_ORIGEM` e o vínculo `D2_IDTRIB`/`FT_IDTRIB`. | | |
| TASK-008 | Revisar com a área fiscal os **textos legais** gravados na `SZZ` para RCO (`PrcGrvRco.prw:347-352`) e para Retorno Simbólico (`PrcGrvRet.prw:79-120`) frente à LC 214/2025 (`FIS-004`). | | |

### Implementation Phase 2 — Mapa de impacto e baseline de regressão

- GOAL-002: Produzir o inventário de pontos de alteração e a base de comparação que permita provar ausência de regressão. Executável em paralelo à Fase 1.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-009 | Mapear o **fluxo completo de ponta a ponta** com os pontos de acionamento, e versionar o diagrama: `DHLSAP.prw:217` → `U_SAPIP040` → `SZA`/`SZB`; `MonIp040.prw:511-515` → `U_PrcNfRco` → `MATA920` → `U_GRAVAFCP` → `U_PrcGrvRco` → `validValues` → `U_PrcXmlNfe`; `U_PrcNfRet` → `MaPvlNFS` → PE `M460FIM_pe.prw:134` → `U_PrcGrvRet`; `DHLSAP.prw:206` → `U_SAPIP150` → `DHLIp150:ExcluiRCO/ExcluiRET`; PEs `MT920TOK_PE.prw:17` e `MS520VLD_pe.prw:136`; `Ag2ASNConf.prw:58` → `U_SAPIP190`. | | |
| TASK-010 | Extrair o conteúdo atual da tabela `SZD` (De/Para) e produzir a tabela de-para proposta, acrescentando as linhas de IBS/CBS e marcando cada linha existente como `MANTÉM`, `REVISAR` ou `OBSOLETO` sob o CFGTRIB. | | |
| TASK-011 | Extrair o conteúdo atual da tabela `SZC` (regras de TES) e avaliar linha por linha a validade sob o CFGTRIB, conforme a decisão de `TASK-005`. | | |
| TASK-012 | Gerar baseline de regressão: processar um conjunto representativo de interfaces `IP_040` (com e sem RCO, com e sem ICMS-ST, com redução de base, com ICMS desonerado/SUFRAMA) em ambiente de homologação e arquivar `SZA`, `SZB`, `SF2`, `SD2`, `SF3`, `SFT`, `CD2`, `F2D` e o XML NF-e resultante como massa imutável. | | |
| TASK-013 | Validar se os campos legados consumidos pelo fluxo continuam populados com o CFGTRIB ativo — em especial `F4_SITTRIB` (lido por `getCstTes()`), `F4_BASEICM`, `B1_PICMRET`, `F3_VALICM`, `F3_BASEICM`, `FT_CLASFIS`, `CD2_IMP`/`CD2_VLTRIB`/`CD2_VFCP` — e documentar os que passam a retornar zero/vazio. | | |
| TASK-014 | Testar o desmembramento de `SF3` com o CFGTRIB ativo e validar se `isEqualSf3()`/`ZA_F3QTLIN` e o `DbSeek` por `CFOP + alíquota` continuam válidos (`CON-006`). Documentar o resultado antes de qualquer alteração. | | |
| TASK-015 | Avaliar o impacto do **split payment** e da extinção progressiva de PIS/COFINS/ICMS/IPI sobre a conciliação SAP × Protheus durante a transição 2026-2032, e registrar a regra acordada com a área fiscal. | | |

### Implementation Phase 3 — Componente de conciliação IBS/CBS (F2D)

- GOAL-003: Criar o acesso a `F2D` que o motor atual não possui e o serviço de conciliação SAP × CFGTRIB, sem alterar comportamento existente. Depende de `TASK-001`, `TASK-006` e `TASK-007`.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-016 | Criar o include `PROTHEUS/Includes/saprtc.ch` com as constantes do fluxo RTC da interface: siglas de tributo, nomes dos parâmetros (`ZZ_TRIBCBS`, `ZZ_TRIBSUF`, `ZZ_TRIBSMU`, `ZZ_RTCDIVG`, `MV_RTC55`), tolerância de arredondamento e códigos de log. Gravar em CP-1252. | | |
| TASK-017 | Criar a classe `DHLSapRtc` em `PROTHEUS/Producao/SAP/SCJ/Classes/DHLSapRtc.tlpp` (TLPP) com os métodos `getF2DByItem()`, `getF2DByDoc()`, `getSapValues()` e `compare()`, encapsulando todo o acesso a `F2D` por `D2_IDTRIB`/`FT_IDTRIB` (resolvendo `CON-002`). Usar `FWExecStatement`, `%F2D.NOTDEL%` e `%nolock%`. | | |
| TASK-018 | Implementar em `DHLSapRtc` o método `isRtcActive(dDoc)`, avaliando a data do documento contra `SuperGetMv('MV_RTC55',.F.,stod('20260105'))`, chamado **uma única vez por execução** e armazenado em atributo. | | |
| TASK-019 | Implementar em `DHLSapRtc` o método `compare()`, que confronta por item os valores de `SZB` (SAP) com os de `F2D` (CFGTRIB) para IBS UF, IBS Municipal e CBS (base, alíquota e valor), aplicando a tolerância de arredondamento definida e retornando a lista estruturada de divergências. | | |
| TASK-020 | Implementar em `DHLSapRtc` o método `compareTotals()`, confrontando os totais de `SZA` (`ZA_IBSUFTO`, `ZA_IBSMUTO`, `ZA_IBSTOTA`, `ZA_CBSTOTA`) com o somatório de `F2D` por documento. | | |
| TASK-021 | Implementar em `DHLSapRtc` o método `compareClass()`, confrontando CST-IBS/CBS e cClassTrib informados pelo SAP com os aplicados pela Regra de Escrituração do CFGTRIB (tabela `CKB`, campo `CKB_CSTCCT`) — conforme `REQ-004` e o resultado de `TASK-003`/`TASK-004`. | | |
| TASK-022 | Implementar o tratamento de divergência conforme a decisão de `TASK-001`, como estratégia selecionada pelo parâmetro `ZZ_RTCDIVG`: `1` = bloquear + log; `2` = sobrescrever `F2D`; `3` = aceitar CFGTRIB + log de auditoria. Os três caminhos devem registrar via `FWLogMsg()` + `DHLLogManager()`. | | |
| TASK-023 | **Somente se `TASK-001` escolher a opção "sobrescrever"**: implementar `DHLSapRtc:overwriteF2D()` usando `U_GravaFCP()` (`PAT-003`) como molde, preservando `F2D_ID`, `F2D_IDCAD`, `F2D_IDBASE`, `F2D_IDALIQ` e marcando `F2D_ORIGEM` de forma a manter a rastreabilidade exigida por `CON-003`. Registrar formalmente o aceite do risco pela área fiscal. | | |

### Implementation Phase 4 — Integração no fluxo existente

- GOAL-004: Acionar a conciliação nos pontos corretos dos 7 fontes em escopo, sem quebrar os caminhos legados. Depende de GOAL-003.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-024 | Alterar `DHLIp040Sap.prw`: declarar e implementar o novo método `validRtcValues(oSqlSZB, oSqlGroup)`, que instancia `DHLSapRtc` e executa a conciliação de IBS/CBS por item e por documento. Não alterar `validValues()` internamente — o novo método é chamado em sequência, preservando o comportamento legado. | | |
| TASK-025 | Alterar `DHLIp040Sap.prw:363-383`: acrescentar, no bloco `TABLE_TO $ "CD2|"`, o desvio explícito para o novo caminho quando o campo origem pertencer a `FIELDS_IBS_UF`, `FIELDS_IBS_MUN` ou `FIELDS_CBS` (constantes já declaradas nas linhas 15-18 e hoje **sem nenhum uso**), evitando que esses campos sejam tratados pelo `dbSeek` de `CD2`. | | |
| TASK-026 | Alterar `PrcGrvRco.prw:50-57`: chamar `oIp040:validRtcValues()` imediatamente após `oIp040:validValues()`, condicionado a `isRtcActive()`, e tratar o retorno conforme a estratégia de `ZZ_RTCDIVG` antes de prosseguir para `fGravaMsg()` e `fAtuSf3()`. | | |
| TASK-027 | Alterar `PrcGrvRco.prw:385-401` (`fAtuSf3`): condicionar o `F3_REPROC = 'N'` à ausência de divergência de IBS/CBS, de modo a não bloquear o reprocessamento fiscal de um documento inconsistente (`CON-007`). | | |
| TASK-028 | Alterar `PrcNfRco.prw:300-311`: isolar a mutação de `SF4.F4_BASEICM` atrás de verificação de `isRtcActive()` e da decisão de `TASK-005`, e registrar em log toda alteração de TES realizada em tempo de execução (`CON-004`). | | |
| TASK-029 | Alterar `PrcNfRco.prw:355-376` (`updPrd`): aplicar o mesmo tratamento à mutação de `B1_PICMRET` (`CON-004`). | | |
| TASK-030 | Alterar `PrcNfRet.prw:495-533` (`U_GravaFCP`): incluir, após a gravação do FCP, a chamada da conciliação de IBS/CBS para o caminho RET, condicionada a `isRtcActive()`. Caso `TASK-001` escolha "sobrescrever", criar `U_GravaIBSCBS()` espelhando `GravaCab()`/`GravaItens()` com destino `F2D`. | | |
| TASK-031 | Alterar `PrcNfRet.prw` (`execRET`, linhas 241-386): validar que o caminho `MaPvlNFS()` aciona o CFGTRIB e que `F2D` é gravada antes do retorno; adicionar log de ausência de `F2D` quando `isRtcActive()` for verdadeiro. | | |
| TASK-032 | Alterar `DHLIp150.prw:606-637` (`ExcluiRCO`): validar e, se necessário, complementar o estorno dos registros de `F2D` após o `MSExecAuto(MATA920, EXCLUSAO)`, conferindo o preenchimento de `F2D_DTEXCL` (`REQ-008`). | | |
| TASK-033 | Alterar `DHLIp150.prw:648-681` (`ExcluiRET`) e `EstornaDocumento()` (linhas 1372-1399): aplicar a mesma validação de estorno de `F2D` ao caminho `MaCanDelF2()`/`MaDelNFS()`. | | |
| TASK-034 | Alterar `DHLIp150.prw:766-826` (`ValidExclusao`): incluir na validação de exclusão a verificação de consistência de IBS/CBS, impedindo o cancelamento parcial que deixe `F2D` órfã. | | |
| TASK-035 | Revisar `PrcGrvRet.prw`: aplicar os textos legais aprovados em `TASK-008` à mensagem gravada na `SZZ` (linhas 79-128). Nenhuma alteração de tributo é necessária neste fonte. | | |
| TASK-036 | Revisar `SAPIP190.prw`: confirmar formalmente a **ausência de impacto tributário** (o XML `IP_190` carrega apenas `ITEM`, `QUANTITY`, `UOM`, `LINE_ITEM` e `LOT`) e validar apenas que os campos de origem usados na query (`F1_ZZNFVEN`, `F1_ZZSEVEN`, `D1_ZZPOEXT`, `D1_ZZLOTE`, `D1_UM`, `D1_ITEM`) seguem populados no novo fluxo. Registrar como "sem impacto direto" no mapa. | | |
| TASK-037 | Criar as linhas de De/Para em `SZD` conforme a tabela aprovada em `TASK-010`, e as regras em `SZC` conforme `TASK-011`. Entregar como script de carga versionado, não como cadastro manual. | | |
| TASK-038 | Converter todos os fontes alterados para **CP-1252** antes da compilação, utilizando a skill `utf8-to-cp1252-conversion`. | | |

### Implementation Phase 5 — Testes e homologação

- GOAL-005: Comprovar ausência de regressão no fluxo atual e correção da conciliação de IBS/CBS nos dois caminhos de geração e no cancelamento. Depende de GOAL-004.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-039 | Compilar na ordem: `saprtc.ch` → `DHLSapRtc.tlpp` → `DHLIp040Sap.prw` → `DHLIp150.prw` → `PrcNfRco.prw` → `PrcNfRet.prw` → `PrcGrvRco.prw` → `PrcGrvRet.prw` → `SAPIP040.prw` → `SAPIP150.prw` → `SAPIP190.prw` → PEs `M460FIM_pe`, `MT920TOK_PE`, `MS520VLD_pe` (skill `advpl-tlpp-compile`). | | |
| TASK-040 | Executar `TEST-001` a `TEST-014` e registrar os resultados. | | |
| TASK-041 | Executar revisão de código com a skill `code-review` sobre todos os fontes alterados, garantindo ausência de violações SonarQube CRITICAL/MAJOR introduzidas e atenção específica a CA1002 (UI em transação), CA1004 (`ConOut`), CA2050 (SQL Injection) e CA4000 (`IIF`). | | |
| TASK-042 | Homologar com a área fiscal e com o time SAP, em conjunto, um ciclo completo: recebimento da `IP_040` → geração RCO + RET → conciliação de IBS/CBS → emissão da NF-e → cancelamento pela `IP_150`. Obter aceite formal. | | |
| TASK-043 | Versionar no SVN, gerar o pacote de patch e implantar com janela de validação assistida (acompanhamento documento a documento) no primeiro ciclo de faturamento. | | |

## 3. Alternatives

- **ALT-001**: **Bloquear o faturamento quando houver divergência de IBS/CBS entre SAP e CFGTRIB.** É a alternativa mais coerente com a premissa de controle da interface e a **recomendada** para o início da operação: nenhuma NF é emitida com tributo inconsistente. Custo: exige disponibilidade do time fiscal/SAP para resolver divergências em tempo de faturamento, sob risco de parar a operação.
- **ALT-002**: **Sobrescrever `F2D` com os valores do SAP**, replicando o padrão hoje aplicado a ICMS/ST/FCP. Preserva a lógica histórica da interface ("SAP é a autoridade fiscal"), mas viola a rastreabilidade do Configurador de Tributos (`CON-003`): o valor gravado deixa de corresponder à regra que o gerou, com impacto potencial na apuração, na escrituração e em eventual fiscalização. Só deve ser adotada com aceite formal do risco pela área fiscal.
- **ALT-003**: **Aceitar o valor do CFGTRIB e apenas registrar a divergência** para auditoria posterior. Menor risco técnico e menor atrito operacional, porém transfere a divergência para a conciliação contábil/fiscal e exige que as regras do Configurador estejam corretamente parametrizadas desde o primeiro dia.
- **ALT-004**: **Parametrizar o Configurador de Tributos para reproduzir exatamente o cálculo do SAP**, eliminando a necessidade de conciliação em código. É a solução arquiteturalmente mais correta no longo prazo, mas depende integralmente de parametrização fiscal (regras de cálculo, base, alíquota, escrituração por CFOP/produto/cliente) e não oferece garantia de convergência em 100% dos cenários.
- **ALT-005**: **Inverter a direção do fluxo**, passando a enviar ao SAP os tributos calculados pelo Protheus em vez de recebê-los. Remove a classe inteira de problemas de conciliação, mas é uma mudança de contrato de integração entre dois ERPs — escopo de projeto, não de adequação.
- **ALT-006**: **Eliminar as mutações de `SF4.F4_BASEICM` e `B1_PICMRET` em tempo de execução**, substituindo-as por TES específicas pré-cadastradas por faixa de redução de base e por MVA por produto. Não escolhida para este ciclo por ampliar o escopo e exigir recadastramento, mas é a correção recomendada para `CON-004` em iniciativa subsequente — a concorrência em faturamento simultâneo já é problema documentado no próprio código desde 2018.

## 4. Dependencies

- **DEP-001**: **Configurador de Tributos (CFGTRIB / FISA170)** configurado e calculando IBS/CBS no ambiente AG2, com regras de cálculo, regras de escrituração e perfis de produto cadastrados.
- **DEP-002**: Release do Protheus com as tabelas `F2A`–`F2M` e os campos `D1_IDTRIB`, `D2_IDTRIB` e `FT_IDTRIB` presentes no dicionário.
- **DEP-003**: Tabela `CKB` (Classificação Tributária IBS/CBS) populada com a tabela cClassTrib oficial importada (Informe Técnico 2025.002).
- **DEP-004**: Tabela `F2E` com IBS Estadual, IBS Municipal e CBS cadastrados, e parâmetros `ZZ_TRIBSUF`, `ZZ_TRIBSMU`, `ZZ_TRIBCBS` apontando para as siglas corretas.
- **DEP-005**: Parâmetro `MV_RTC55` com a data de virada definida pela área fiscal, e novo parâmetro `ZZ_RTCDIVG` criado conforme `TASK-001`.
- **DEP-006**: **Campos de IBS/CBS em `SZA`/`SZB` criados e em uso no dicionário** (`TASK-002`), com as funções `get` correspondentes em `SAPIP040.prw` — pré-requisito absoluto por `CON-001`.
- **DEP-007**: **XML `IP_040` do SAP enviando as tags de IBS/CBS** (`TASK-003`), incluindo CST-IBS/CBS e cClassTrib se a conciliação de `REQ-004` for exigida.
- **DEP-008**: Tabelas de parametrização `SZD` (De/Para) e `SZC` (regras de TES) atualizadas (`TASK-037`).
- **DEP-009**: Classes de infraestrutura mantidas sem alteração: `IpSqlObject`, `IpUtilsObject`, `IpFileObject`, `DHLLogManager`, `FswTemplMsg`, `DHLProcessValidator`, `DHLSndMail`.
- **DEP-010**: Rotinas padrão TOTVS acionadas pelo fluxo: `MATA920` (inclusão e exclusão), `MaPvlNFS`, `MATA410`, `MaCanDelF2`, `MaDelNFS`, `MA461NumNf`.
- **DEP-011**: Interface **Mastersaf NFe** (`U_PrcXmlNfe` / `ProcMsaNFe.prw`), acionada ao final de `PrcGrvRco.prw:306-316` e que já possui o grupo IBS/CBS implementado — ver o plano `upgrade-mastersaf-dw-safx07-ibs-cbs-1.md`.
- **DEP-012**: Extensão TOTVS Developer Studio (`TOTVS.tds-vscode`) e `servers.json` configurados.

## 5. Files

### Componentes novos

- **FILE-001**: `PROTHEUS/Includes/saprtc.ch` — *(novo)* constantes do fluxo RTC da interface SAP/SCJ.
- **FILE-002**: `PROTHEUS/Producao/SAP/SCJ/Classes/DHLSapRtc.tlpp` — *(novo)* acesso a `F2D` e serviço de conciliação SAP × CFGTRIB.

### Fontes em escopo (os 7 indicados)

- **FILE-003**: `PROTHEUS/Producao/SAP/SCJ/Classes/DHLIp040Sap.prw` (1063 linhas) — **impacto ALTO**. Constantes `FIELDS_IBS_UF`/`FIELDS_IBS_MUN`/`FIELDS_CBS` declaradas e não usadas (linhas 15-18); `validValues()` (321-449) sem tratamento de `F2D`; bloco `CD2` (363-383) cobre apenas `ICM`/`SOL`/`CMP`/`ZFM`; `getTesOperation()` (292-310) sem critério de IBS/CBS; `isEqualSf3()` (556-569); `updateFields()` (638-644); `setFieldsSzd()` (264-278); `retCposSZB()`/`retCposSf3()` (1110-1151, agregação automática — sem alteração necessária).
- **FILE-004**: `PROTHEUS/Producao/SAP/SCJ/PrcGrvRco.prw` (369 linhas) — **impacto ALTO**. Chama `validValues()` (linha 54); gravação direta em `SD2`/`SFT`/`CD2`/`SF3`/`SF2` para ICMS desonerado/SUFRAMA (77-158); `DbSeek` de `SF3` por CFOP + alíquota (130); `fAtuSf3()` força `F3_REPROC='N'` (385-401); dispara `U_PrcXmlNfe` (306-316).
- **FILE-005**: `PROTHEUS/Producao/SAP/SCJ/PrcNfRco.prw` (470 linhas) — **impacto ALTO**. `MsExecAuto(MATA920)` (214); `mountDetails()` com `UPDATE` em `SF4.F4_BASEICM` (300-311); `getCstTes()` lê `F4_SITTRIB` (343-350); `updPrd()` com `UPDATE` em `B1_PICMRET` (355-376); `U_GRAVAFCP` (113); `MsgInfo`/`MsgAlert` no fluxo transacional (115-117) e `ConOut` (418-420).
- **FILE-006**: `PROTHEUS/Producao/SAP/SCJ/PrcNfRet.prw` (638 linhas) — **impacto ALTO**. `execRET()` via `MaPvlNFS()` (241-386); `U_GravaFCP`/`GravaCab`/`GravaItens` (495-631) — molde para IBS/CBS (`PAT-003`); `updMvaPrd()` (410, atualmente comentado no chamador).
- **FILE-007**: `PROTHEUS/Producao/SAP/SCJ/Classes/DHLIp150.prw` (1458 linhas) — **impacto MÉDIO**. `ExcluiRCO()` via `MATA920` opção 5 (606-637); `ExcluiRET()` via `EstornaDocumento()`/`MaCanDelF2`/`MaDelNFS` (648-681, 1372-1399); `ValidExclusao()` (766-826); `updateSalesOrder()` via `MATA410` (827-879); `ChecStatusFIMP()` (525); `SendCancellation()` (564).
- **FILE-008**: `PROTHEUS/Producao/SAP/SCJ/PrcGrvRet.prw` (180 linhas) — **impacto BAIXO**. Apenas mensagens `SZZ` (65-128), validação de referência NF SCJ → NF RET (41-63) e e-mail de notificação (154-187). Nenhum campo de tributo. Alteração limitada ao texto legal (`TASK-035`).
- **FILE-009**: `PROTHEUS/Producao/SAP/SCJ/SAPIP190.prw` (249 linhas) — **SEM IMPACTO DIRETO**. XML `IP_190` (ASN Confirmation) carrega apenas `ITEM`, `QUANTITY`, `UOM`, `LINE_ITEM` e `LOT`; a query (181-245) usa `SF1`/`SD1`/`SA1`/`SA2`/`SB1` sem nenhum campo de imposto. Apenas validação de regressão (`TASK-036`).

### Fontes acoplados, indispensáveis ao fluxo (não indicados, mas em escopo técnico)

- **FILE-010**: `PROTHEUS/Producao/SAP/SCJ/SAPIP040.prw` (1422 linhas) — **impacto ALTO e crítico**. Captação dinâmica por dicionário (66-72 e 136-144); listas `CAMPOS_SZA`/`CAMPOS_SZB` (4-5); getters de IBS/CBS por item (940-1099) e de totais (447-466), **já implementados**; atualização de `ZA_F3QTLIN` (102-112).
- **FILE-011**: `PROTHEUS/Producao/SAP/SCJ/SAPIP150.prw` (49 linhas) — orquestra o cancelamento via `DHLIp150`; verificar se o encadeamento `ChecStatusFIMP` → `SendCancellation` permanece válido.
- **FILE-012**: `PROTHEUS/Producao/SAP/SCJ/MonIp040.prw` (455 linhas) — monitor que dispara `u_PrcNfRco()` (511-515); avaliar exibição do status de divergência de IBS/CBS na tela.
- **FILE-013**: `PROTHEUS/Producao/Pontos_de_Entrada/FAT/M460FIM_pe.prw:134` — aciona `u_PrcGrvRet()`.
- **FILE-014**: `PROTHEUS/Producao/Pontos_de_Entrada/FIS/MT920TOK_PE.prw:17` — validação de exclusão via `DHLIp150`.
- **FILE-015**: `PROTHEUS/Producao/Pontos_de_Entrada/FAT/MS520VLD_pe.prw:136` — validação de estorno via `DHLIp150`.
- **FILE-016**: `PROTHEUS/Producao/SAP/DHLSAP.prw:206-217` — roteador das interfaces (`U_SAPIP150`, `U_SAPIP040`).
- **FILE-017**: `PROTHEUS/Producao/SAP/SCJ/updImpCD2.prw` (252 linhas) — rotina de atualização de impostos em `CD2`; avaliar se precisa equivalente para `F2D`.
- **FILE-018**: `PROTHEUS/Producao/WMS_Dlx_SCJ/Ag2ASNConf.prw:58` — aciona `u_SAPIP190()`.

### Fontes de referência (não alterados — usados como padrão)

- **FILE-019**: `PROTHEUS/Producao/Controle_de_ID_Good-Bad/DHLIdManager.prw:261-341` — padrão validado de leitura de `F2D` e dos parâmetros de sigla de tributo (`PAT-004`).
- **FILE-020**: `PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw:4421+` — mapeamento semântico completo de IBS/CBS e uso de `MV_RTC55` (`PAT-005`).
- **FILE-021**: `PROTHEUS/Producao/SAP/ProcRCOMsa.prw:31` — já possui o corte por `MV_RTC55` no fluxo RCO → Mastersaf; referência de consistência.
- **FILE-022**: `PROTHEUS/Producao/Validacao_dos_Impostos/DHLTaxes.prw:250-265` — totalizadores de IBS/CBS por item de XML já existentes na validação de impostos.
- **FILE-023**: `PROTHEUS/Producao/Mastersaf_NFe/nfesefaz.prw:3026 e 3488` — tratamentos condicionais por `IsInCallStack("U_PrcGrvRco")`/`("U_PrcNfRco")` para AG2; **atenção**: dependem do nome das funções em pilha, portanto nenhuma função do fluxo pode ser renomeada.

## 6. Testing

- **TEST-001**: **Não regressão end-to-end** — processar a massa de baseline (`TASK-012`) com data anterior a `MV_RTC55` e comparar `SZA`, `SZB`, `SF2`, `SD2`, `SF3`, `SFT`, `CD2` e o XML NF-e resultante com o baseline. Diferença esperada: zero.
- **TEST-002**: **Captação SAP → SZA/SZB** — processar uma `IP_040` com tags de IBS/CBS e validar que os 9 campos de `SZB` e os 4 totais de `SZA` foram populados pelo mecanismo dinâmico, sem alteração de código.
- **TEST-003**: **Campo sem getter** — criar um campo de teste em `SZB` sem a função `get` correspondente e confirmar que o processamento falha, documentando a mensagem; em seguida criar o getter e confirmar o sucesso. Valida `CON-001`/`RISK-002`.
- **TEST-004**: **Conciliação por item, caminho RCO** — gerar NF RCO via `MATA920` e validar que `DHLSapRtc:compare()` confronta corretamente `ZB_IBSUFVL`/`ZB_IBSMUVL`/`ZB_CBSTXVL` com `F2D_VALOR` por `D2_IDTRIB`, e as respectivas bases e alíquotas.
- **TEST-005**: **Conciliação por item, caminho RET** — repetir `TEST-004` para a NF de Retorno Simbólico gerada por `MaPvlNFS()`.
- **TEST-006**: **Conciliação de totais** — validar `compareTotals()` confrontando `ZA_IBSUFTO`/`ZA_IBSMUTO`/`ZA_IBSTOTA`/`ZA_CBSTOTA` com o somatório de `F2D` por documento. Tolerância: a definida em `saprtc.ch`.
- **TEST-007**: **Divergência proposital** — injetar divergência de valor em `SZB` e validar que o comportamento corresponde exatamente à estratégia do parâmetro `ZZ_RTCDIVG` (bloquear / sobrescrever / aceitar-e-logar), com log gerado nos três casos.
- **TEST-008**: **CST-IBS/CBS e cClassTrib** — validar `compareClass()` e confirmar que o cClassTrib tem 6 posições e que seus 3 primeiros dígitos coincidem com o CST, em todos os itens.
- **TEST-009**: **Documento sem `F2D`** — processar documento com data ≥ `MV_RTC55` cujo CFGTRIB não produziu registro em `F2D` e validar que o log de exceção é gerado e o fluxo segue a regra acordada.
- **TEST-010**: **Fronteira de data** — processar documentos em D-1, D e D+1 em relação a `MV_RTC55` e validar a ativação/desativação correta da conciliação.
- **TEST-011**: **Desmembramento de `SF3`** — validar que `isEqualSf3()`/`ZA_F3QTLIN` e o `DbSeek` por CFOP + alíquota continuam corretos com o CFGTRIB ativo, inclusive nos casos com redução de base (`cAliq := "0.00"`). Valida `CON-006`.
- **TEST-012**: **Cancelamento RCO** — cancelar via `IP_150` → `ExcluiRCO()` e confirmar que os registros de `F2D` do documento ficaram com `F2D_DTEXCL` preenchida ou excluídos, sem registros órfãos.
- **TEST-013**: **Cancelamento RET** — repetir `TEST-012` para `ExcluiRET()`/`MaDelNFS()`, validando também a reversão do Pedido de Venda via `updateSalesOrder()`.
- **TEST-014**: **Cenários legados preservados** — reexecutar os casos de ICMS-ST, redução de base, DIFAL e ICMS desonerado/SUFRAMA e confirmar que o comportamento de `validValues()` sobre `CD2` permanece idêntico ao baseline.
- **TEST-015**: **Faturamento simultâneo** — processar duas interfaces concorrentes que exijam mutação de `SF4.F4_BASEICM` com percentuais diferentes e documentar o resultado. Valida o risco de `CON-004`.
- **TEST-016**: **ASN Confirmation** — executar `U_SAPIP190` após o novo fluxo e confirmar que o XML `IP_190` gerado é idêntico ao baseline.
- **TEST-017**: **Encoding** — validar que todos os fontes alterados permanecem em CP-1252 e que os acentos das mensagens de log e da `SZZ` não foram corrompidos.
- **TEST-018**: **Pilha de chamadas** — confirmar que `nfesefaz.prw:3026` e `:3488` continuam identificando `U_PrcGrvRco`/`U_PrcNfRco` via `IsInCallStack()` após as alterações.

## 7. Risks & Assumptions

### Riscos

- **RISK-001**: **(Crítico)** A decisão entre bloquear, sobrescrever ou aceitar-e-logar a divergência de IBS/CBS (`TASK-001`) é **fiscal, não técnica**, e define a arquitetura de toda a Fase 3. Começar a codificar antes dessa decisão produz retrabalho integral. **Mitigação**: Fase 1 bloqueante.
- **RISK-002**: **(Crítico)** O acoplamento por convenção de nomes (`CON-001`) faz com que **qualquer campo novo em `SZA`/`SZB` sem a função `get` correspondente derrube a importação da `IP_040` em produção** — e o erro ocorre por macro, sem checagem em tempo de compilação. **Mitigação**: `TASK-002`, `TEST-003` e checklist obrigatório de campo-novo + getter no mesmo pacote.
- **RISK-003**: **(Crítico)** Sobrescrever `F2D` (se `ALT-002` for escolhida) rompe a rastreabilidade entre valor apurado e regra geradora (`CON-003`), com impacto potencial na apuração, na escrituração e em fiscalização. **Mitigação**: aceite formal do risco pela área fiscal e preservação dos IDs de rastreabilidade em `TASK-023`.
- **RISK-004**: **(Alto)** Se o Configurador de Tributos não estiver corretamente parametrizado, o volume de divergências SAP × Protheus pode ser massivo no primeiro ciclo — com `ALT-001` isso **para o faturamento da SCJ**. **Mitigação**: `TASK-007`, homologação com volume real em `TASK-042` e janela de validação assistida em `TASK-043`.
- **RISK-005**: **(Alto)** A mutação de `SF4.F4_BASEICM` e `B1_PICMRET` em tempo de execução (`CON-004`) é um problema de concorrência **já existente e documentado no próprio código desde 2018**, que a Reforma Tributária tende a agravar por aumentar o número de regras por documento. **Mitigação**: `TASK-028`, `TASK-029`, `TEST-015` e `ALT-006` como correção estrutural subsequente.
- **RISK-006**: **(Alto)** Mudança no desmembramento de `SF3` pela escrituração dos tributos novos quebra simultaneamente o `DbSeek` por CFOP + alíquota e a validação de quantidade de linhas (`ZA_F3QTLIN`), interrompendo a conciliação legada de ICMS. **Mitigação**: `TASK-014` executado **antes** de qualquer alteração, e `TEST-011`.
- **RISK-007**: **(Médio)** Campos legados podem ser zerados pelo CFGTRIB (`TASK-013`), em especial `F4_SITTRIB` (base do `getCstTes()`) e os campos de `CD2`, causando regressão em tributos hoje corretos. **Mitigação**: `TASK-013` como gate e `TEST-001`/`TEST-014`.
- **RISK-008**: **(Médio)** O XML `IP_040` do SAP pode não enviar CST-IBS/CBS e cClassTrib, inviabilizando a conciliação de `REQ-004` e deixando a classificação tributária sem contraprova. **Mitigação**: `TASK-003`; se confirmado, documentar a lacuna e restringir a conciliação a base/alíquota/valor.
- **RISK-009**: **(Médio)** O enquadramento de Remessa por Conta e Ordem e de Retorno Simbólico no IBS/CBS pode permanecer indefinido na legislação ou em interpretação divergente entre DHL e depositante (SCJ), travando `TASK-004`. **Mitigação**: escalar à área fiscal com antecedência e manter o parâmetro `ZZ_RTCDIVG` em modo "aceitar-e-logar" enquanto a definição não existir.
- **RISK-010**: **(Médio)** `PrcNfRco.prw` tem toda a estrutura de `BEGIN TRANSACTION` **comentada** desde 2018 ("Teste faturamento simultaneo"), com controle manual por `lBreak` + `DisarmTransaction()`. Introduzir novas gravações nesse fluxo sem transação pode gerar estados parciais em `F2D`. **Mitigação**: mapear o escopo transacional real antes de `TASK-026` e `TASK-030`.
- **RISK-011**: **(Baixo)** Renomear qualquer função do fluxo quebra os testes de `IsInCallStack()` em `nfesefaz.prw:3026` e `:3488`. **Mitigação**: proibição explícita de renomeação e `TEST-018`.
- **RISK-012**: **(Baixo)** Chamadas de UI dentro do fluxo transacional (`GUD-004`) podem travar o processamento em cenário multiusuário quando o volume de divergências aumentar. **Mitigação**: código novo registra em log e exibe apenas ao final.
- **RISK-013**: **(Baixo)** Prazo legal fixo em 03/08/2026 combinado com dependência de terceiro (time SAP) em `TASK-003`. **Mitigação**: iniciar `TASK-003` imediatamente e executar a Fase 2 em paralelo.

### Premissas

- **ASSUMPTION-001**: O Configurador de Tributos (FISA170) será o motor oficial de cálculo de IBS/CBS no Protheus da DHL, sem cálculo paralelo customizado.
- **ASSUMPTION-002**: Os campos `ZB_IBSUFTX`/`BS`/`VL`, `ZB_IBSMUTX`/`BS`/`VL`, `ZB_CBSTXRT`/`BS`/`VL` **já existem** no dicionário, dado que as constantes `FIELDS_IBS_UF`, `FIELDS_IBS_MUN` e `FIELDS_CBS` estão declaradas em `DHLIp040Sap.prw:15-18` e que os getters correspondentes estão implementados em `SAPIP040.prw`. **Sujeito a confirmação em `TASK-002`** — não foi possível verificar o `SX3` a partir do workspace.
- **ASSUMPTION-003**: Os nomes dos campos de total em `SZA` são `ZA_IBSUFTO`, `ZA_IBSMUTO`, `ZA_IBSTOTA` e `ZA_CBSTOTA`, inferidos da convenção `get<SubStr(campo,4,7)>` aplicada às funções `getIBSUFTO()`, `getIBSMUTO()`, `getIBSTOTA()` e `getCBSTOTA()`. **Sujeito a confirmação em `TASK-002`**.
- **ASSUMPTION-004**: As siglas `TR0001` (CBS), `TR0002` (IBS UF) e `TR0003` (IBS Municipal), usadas como default em `DHLIdManager.prw`, refletem o cadastro real de `F2E`. **Sujeito a confirmação em `TASK-006`**.
- **ASSUMPTION-005**: O relacionamento `SD2.D2_IDTRIB`/`SFT.FT_IDTRIB` → `F2D.F2D_IDREL` é válido na release instalada. **Sujeito a confirmação em `TASK-007`**.
- **ASSUMPTION-006**: O parâmetro `MV_RTC55` é a data de corte oficial adotada pela DHL para a Reforma Tributária em todas as interfaces.
- **ASSUMPTION-007**: O fluxo SCJ permanece exclusivo da unidade de negócio AG2 e nenhuma outra unidade passará a usá-lo durante o projeto.
- **ASSUMPTION-008**: As rotinas padrão TOTVS acionadas (`MATA920`, `MaPvlNFS`, `MaDelNFS`, `MaCanDelF2`, `MATA410`) acionam o Configurador de Tributos nativamente, sem necessidade de chamada explícita ao motor fiscal. **Sujeito a confirmação em `TASK-007` e `TASK-031`**.
- **ASSUMPTION-009**: A estrutura de mensagens `SZZ` via `FswTemplMsg` e o mecanismo de log via `DHLLogManager` permanecem válidos e não requerem alteração estrutural.

## 8. Related Specifications / Further Reading

- Plano relacionado: `plan/upgrade-mastersaf-dw-safx07-ibs-cbs-1.md` — adequação da interface Mastersaf DW (SAFX07/08/112/116), que compartilha a unidade AG2 e o mesmo componente de leitura de `F2D`.
- [CFGTRIB - Configurador de Tributos - Linha Microsiga Protheus - TDN](https://tdn.totvs.com/display/public/PROT/CFGTRIB+-+Configurador+de+Tributos)
- [CFGTRIB - Perguntas e Respostas - Configurador de Tributos - TDN](https://tdn.totvs.com/display/public/PROT/CFGTRIB+-+Perguntas+e+Respostas+-+Configurador+de+Tributos)
- [CFGTRIB - Adequação do Configurador de Tributos aos Códigos de Classificação Tributária do IBS, CBS e IS - TDN](https://tdn.totvs.com/pages/releaseview.action?pageId=962623217)
- [FISA170 - Quais tabelas fazem parte do Configurador de Tributos? - Central de Atendimento TOTVS](https://centraldeatendimento.totvs.com/hc/pt-br/articles/35314721022103-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-FIS-FISA170-Quais-tabelas-fazem-parte-do-Configurador-de-Tributos)
- [Relacionamento entre tabelas SD1/SD2, SFT, CJ3 e F2D no Configurador de Tributos - Central de Atendimento TOTVS](https://centraldeatendimento.totvs.com/hc/pt-br/articles/38741160434199-CROSS-Segmentos-TOTVS-Backoffice-Linha-Protheus-FIS-Relacionamento-entre-tabelas-SD1-SD2-SFT-CJ3-e-F2D-no-Configurador-de-Tributos)
- [FIS - Adequação à obrigatoriedade do IBS e CBS a partir de 03 de agosto de 2026 - Central de Atendimento TOTVS](https://centraldeatendimento.totvs.com/hc/pt-br/articles/42351363577623-CROSS-Segmentos-TOTVS-Backoffice-Linha-Protheus-FIS-Adequa%C3%A7%C3%A3o-%C3%A0-obrigatoriedade-do-IBS-e-CBS-a-partir-de-03-de-agosto-de-2026)
- [Como importar a tabela cClassTrib-IBS/CBS no Configurador de Tributos - Central de Atendimento TOTVS](https://centraldeatendimento.totvs.com/hc/pt-br/articles/34662420522391-CROSS-Segmentos-TOTVS-Backoffice-Linha-Protheus-FIS-Como-importar-a-tabela-cClassTrib-IBS-CBS-no-Configurador-de-Tributos)
- [Tabela F2D - Tributos Genéricos Calculados](https://tabelas-protheus.projetive.com.br/F2D)
- [Tabela SFT - Livro Fiscal por Item de NF (campo FT_IDTRIB)](https://tabelas-protheus.projetive.com.br/SFT)
- [Tabela CKB - Classificação Tributária IBS/CBS](https://tabelas-protheus.projetive.com.br/CKB)
- [Informe Técnico 2025.002 - Tabelas de Classificação do IBS e da CBS](https://www.nfe.fazenda.gov.br/portal/exibirArquivo.aspx?conteudo=JDJJBVuJyoA%3D)
- Fontes internos de referência: `PROTHEUS/Producao/Controle_de_ID_Good-Bad/DHLIdManager.prw`, `PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw`, `PROTHEUS/Producao/SAP/ProcRCOMsa.prw`, `PROTHEUS/Producao/Validacao_dos_Impostos/DHLTaxes.prw`
