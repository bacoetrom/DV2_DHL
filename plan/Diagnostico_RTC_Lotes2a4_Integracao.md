# Diagnóstico RTC 2026/2027 — Lotes 2 a 4 (Integração SAP e arquivos IP140/IP050)

| Item | Valor |
|---|---|
| Projeto | SC Johnson / DHL — NF-e 2027 (IBS, CBS, IS) |
| Lotes | 2 — DHLIp040Sap, CadDePara · 4 — ProcRCOMsa, ProcRSymbMsa · correção de compilação — ProcRCOMsa, ProcMsaNFe |
| Data | 22/11/2026 |
| Responsável | Wellington Santana |
| Base normativa | LC 214/2025; Ajuste SINIEF 49/2025; NT 2025.002-RTC v1.53; FDD IM04 |
| Status | Código ajustado, **não compilado** (pendente compilação no AppServer) |
| Backup dos originais | `DV2_DHL\backup_rtc_lote2a4_20261122\` |
| Documentos anteriores | `Diagnostico_Consolidado_NFe_2027_SCJ.md`, `Diagnostico_RTC_Lote1_Cadastros.md` |

---

## 1. Avaliação da lista "fontes atualizados"

A lista tem 21 fontes. Em relação ao commit inicial do repositório, só 4 tinham alteração: **ProcRCOMsa, CadRegFis, CadDePara e updImpCD2**. Os outros 17 estão iguais à base, então incluí-los no pacote não muda o comportamento.

### 1.1 Problemas encontrados na avaliação

| # | Severidade | Ponto | Descrição | Situação |
|---|---|---|---|---|
| A1 | 🔴 Bloqueante | `ProcRCOMsa.prw:82`, `ProcMsaNFe.prw:82` | No `SetPrvt`, a aspa de fechamento ficou antes de `oIS,ogAjusteCompet,...,oISTot`. A linha fica com número ímpar de aspas (string não terminada) e o fonte **não compila**. | ✅ Corrigido |
| A2 | 🔴 Alta | Pacote | `ProcRCOMsa` chama `U_DHLRtcTagAudit`, que está em `Mastersaf_NFe/DHLRtcTagAudit.tlpp` e **não está na lista**. Sem ele no RPO, a geração do arquivo RCO falha em tempo de execução. | Incluir no pacote |
| A3 | 🔴 Alta | Pacote | `MT103FIM_pe.prw` foi alterado no Lote 1 (chama o updImpCD2) e não está na lista. | Incluir no pacote |
| A4 | 🟡 Média | Pacote | `ProcMsaNFe.prw`, `DHLTaxes.prw` e `DHLSafx*.prw` também mudaram desde o commit inicial. | Confirmar se fazem parte desta entrega |
| A5 | 🟡 Média | `CadRegFis` × `fQryTes` | Com `ZC_FINNFE`/`ZC_TPCOMPL` no dicionário, o CadRegFis aceita regras com os mesmos indicadores de ICMS e finalidade diferente. O `fQryTes` não filtrava a finalidade, então a NF RCO podia receber TES de crédito ou débito. | ✅ Corrigido (Lote 2) |

### 1.2 Validações sem problema

- **Lote 1:** símbolos novos confirmados em `LibAdvpl/IpSqlObject.prw`:
  - `exists()` já filtra `D_E_L_E_T_`;
  - `getFieldValue()` existe;
  - `%XXX.SQLNAME%` vira `SZA010 SZA`, então o alias do JOIN do updImpCD2 funciona.
- **Nomes de função:** não há colisão pelo limite de 10 caracteres do AdvPL. `retArrayAtribute` (com um "t") e `retArrayAttribute` são a mesma função para o compilador.

---

## 2. Ajustes aplicados

### 2.1 Correção de compilação — ProcRCOMsa.prw e ProcMsaNFe.prw

- `SetPrvt(...,ovItem",oIS,...,oISTot")` → `SetPrvt(...,ovItem,oIS,...,oISTot")`.

### 2.2 Lote 2 — DHLIp040Sap.prw

| Ajuste | Detalhe |
|---|---|
| `fQryTes` filtra a finalidade | Quando `ZC_FINNFE`/`ZC_TPCOMPL` existem no SX3 (`GetSx3Cache`, sem depender da SZC estar aberta no job), a busca considera só `ZC_FINNFE IN (' ','1')` e `ZC_TPCOMPL = ' '`. O IP_040 gera apenas a remessa por conta e ordem (finNFe 1). |
| `IIF` removido do `fQryTes` (CA4000) | Substituído por `If/EndIf` com variáveis locais. |
| `default nIcmsDifalValue` | Estava duplicado em `nIcmsRedBValue`, e `nIcmsDifalValue` ficava NIL (erro em `nil > 0`). |
| `validValues`, ramo CD2 | De/para de IBS/CBS (`FIELDS_IBS_UF`, `FIELDS_IBS_MUN`, `FIELDS_CBS`) era descartado sem aviso. Agora registra `FWLogMsg` WARN uma vez por execução. |
| Include | `protheus.ch` → `totvs.ch`. |

**IBS/CBS na CD2 — não é possível implementar (⚠️):** no padrão TOTVS, IBS/CBS são calculados pelo motor de tributos (`nfesefaz.prw`: `oXmlRefTri:GetXmlIbsCbs`, `oNfTciIntg`) e não gravam registro na CD2. Não existe código `CD2_IMP` para IBS/CBS, e nenhum código foi inventado.

### 2.3 Lote 2 — CadDePara.prw

| Ajuste | Detalhe |
|---|---|
| Tabela destino amarrada à origem | SZA (cabeçalho) → só SF2. SZB (itens) → SD2, SFT, SB1, CD2 e SF3. É o que o `validValues` realmente trata. |
| Bloqueio de IBS/CBS → CD2 | Evita de/para sem efeito (ver 2.2). |
| Cabeçalho obtido via `FWModelActive()` | Mesmo padrão usado nos fontes padrão TOTVS (ex.: ATFA005). |

### 2.4 Lote 4 — ProcRCOMsa.prw (IP140)

| # Diag. consolidado | Ajuste | Detalhe |
|---|---|---|
| 2 | `tpNFDebito`/`tpNFCredito` | `getTpCompl(cTagXml)` lê primeiro o XML autorizado (`infnfe:_ide:_tpNFDebito/_tpNFCredito`). Se não vier, usa `F1_TPCOMPL`/`F2_TPCOMPL`. Sempre com `PadL(...,2,"0")`. |
| 4 | `indPres` | Nova `getIndPres()`: lê `infnfe:_ide:_indPres` do XML, com `"0"` quando a tag não vier. |
| 8 | `ZZ_TRIBICM` | Padrão corrigido de `"ICM"` para `"ICMS"`. Com `"ICM"`, o grupo `ICMSPrevistoPagtoAntecip` (débito 06) nunca era preenchido. |
| — | `GetNewPar` dentro do laço (G2) | `ZZ_TRIBICM` e `ZZ_TRIBIS` lidos uma única vez em `ProcRCOMsa()` (Private `cRtcTaxIcm`, `cRtcTaxIS`). |
| 7 | `vIPIDevol` | Só preenchido com `F2_VALIPI` em finNFe 4. Antes valia para qualquer finalidade diferente de 1. |
| 15 | `lFormatZero` | As 22 chamadas dos totais IBS/CBS passavam `lFormatZero` na posição de `lAddNode`. Movido para dentro de `retValueAttribute`. |
| 1 | `getFinNfe` | O ajuste (finNFe 3) e a regra 5921/6921 leem SF2/SD2 só na saída (`F1_ZZTPNF` não existe). Unidade de negócio vazia é rejeitada. |

### 2.5 Lote 4 — ProcRSymbMsa.prw (IP050)

- `indPres` lido do XML, com `"0"` quando a tag não vier (`getIndPres()`). É só troca de valor; o layout não muda.

---

## 3. Gap analysis (diagnóstico consolidado × ajustado)

Legenda: ✅ ajustado · ⚠️ não ajustado, com justificativa · 🔄 mantido como está

| Origem | Item | Status | Justificativa |
|---|---|---|---|
| ProcRCOMsa #1 | finNFe na entrada lendo SF2/SD2; unidade vazia | ✅ | — |
| ProcRCOMsa #1 | Devolução na entrada (tipo D) não vira finNFe 4 | 🔄 | Comportamento anterior à reforma e consumido pelo SAP. Mudar altera o arquivo atual; precisa de decisão do SAP. |
| ProcRCOMsa #2 | Subtipo com 2 dígitos | ✅ | Whitelist por finalidade não aplicada: o valor vem do XML autorizado, e a tabela TOTVS × NT ainda está em aberto (decisão 2). |
| ProcRCOMsa #3 | Ajuste para DHL/DOX | ⚠️ | DHL e DOX não existem como `DHL_BUSINESSUNIT_*`. Depende de definição funcional (decisão 1). |
| ProcRCOMsa #4 | indPres | ✅ | — |
| ProcRCOMsa #5/#6 | NFref / DFeReferenciado por tipo | ⚠️ | O TXT copia o XML autorizado. As regras de rejeição (VC02-10, 1039) precisam ser aplicadas no nfesefaz e nos PEs. |
| ProcRCOMsa #7 | Omissão de tributos antigos em 5/6 (B25-80) | ⚠️ / ✅ | Mesmo motivo de #5. O `vIPIDevol`, que vinha da SF2 e não do XML, foi corrigido. |
| ProcRCOMsa #8 | `ZZ_TRIBICM` | ✅ | — |
| ProcRCOMsa #9 | gAjusteCompet / gIBSCBS com CST 811 | ⚠️ | Os valores vêm do XML autorizado. Rejeições 1021/1170/1171 são tratadas na origem (nfesefaz). |
| ProcRCOMsa #15 | `lFormatZero` | ✅ | — |
| ProcRCOMsa #16 | Grupos novos no layout posicional | ⚠️ | Aguarda validação do layout com SAP/Mastersaf (decisão 4). |
| ProcRSymbMsa #1/#2/#7 | finNFe 5/6/3, tpNF, IBSCBS | ⚠️ | O retorno simbólico é sempre finalidade normal. Campos novos mudam o layout IP050 (decisão 4). |
| ProcRSymbMsa #3 | indPres | ✅ | — |
| Entrada SAP #1–#8 | Finalidade, subtipo, cClassTrib, IS e canal no IP040 | ⚠️ | O IP040 não envia esses dados. Depende do SAP SCJ (decisão 3). |
| Lote 1 Q1 | IBS/CBS no `validValues` (CD2) | ⚠️ | Não existe IBS/CBS na CD2 no padrão TOTVS. Substituído por log + bloqueio no cadastro. |
| Lote 1 Q2 | `fQryTes` por finalidade | ✅ | — |
| Lote 1 Q6 | `getTpCompl` com 2 dígitos | ✅ | — |
| Mastersaf DW (seção 2.4) | SAFX07/08/116, Normal × Devolução, leiaute 2027 | ⚠️ | Fora da lista de fontes deste pacote. Leiaute 2027 bloqueante (decisão 5). |

---

## 4. Impacto nos arquivos enviados ao SAP

Avisar o SAP SCJ antes de homologar:

| Arquivo | Campo | Antes | Depois |
|---|---|---|---|
| IP140 | Totais IBS/CBS (`gIBSUF`, `gIBSMun`, `gIBS`, `gCBS`, `gMono`, `vNFTot`) com valor zero ou ausente | vazio | `0.00` |
| IP140 / IP050 | `indPres` | `0` fixo | valor do XML (`0` se ausente) |
| IP140 | `tpNFDebito` / `tpNFCredito` | `7` | `07` |
| IP140 | `vIPIDevol` em finNFe 2/3/5/6 | `F2_VALIPI` | `0.00` |

---

## 5. Pendências e validação

### 5.1 Compilação (pacote completo)

ProcRCOMsa, ProcRSymbMsa, ProcMsaNFe, DHLIp040Sap, CadDePara, CadRegFis, updImpCD2, MT103FIM_pe e **DHLRtcTagAudit.tlpp** (obrigatório: o ProcRCOMsa chama esta função).

### 5.2 Dicionário e parâmetros

| Tipo | Nome | Ação |
|---|---|---|
| Parâmetro SX6 | `ZZ_TRIBICM` | Se já existir com `ICM`, trocar para `ICMS`. |
| Campos SX3 | `ZC_FINNFE`, `ZC_TPCOMPL` | Podem ser criados com segurança após compilar o DHLIp040Sap deste lote. |
| Parâmetros SX6 (opcionais) | `ZZ_TRIBIS`, `ZZ_FINAJUS`, `ZZ_RTCAUDI`, `ZZ_RTCVLCF`, `ZZ_UPDCD2U`, `ZZ_UPDCD2C` | Todos têm padrão no código. |

### 5.3 Cenários de teste (complementam T1–T12 do Lote 1)

| # | Cenário | Resultado esperado |
|---|---|---|
| T13 | IP_040 com regra RCO e regra de débito com os mesmos indicadores de ICMS | TES da regra RCO (finalidade vazia ou 1) |
| T14 | IP_040 antes de criar `ZC_FINNFE`/`ZC_TPCOMPL` | Comportamento idêntico ao anterior |
| T15 | CadDePara: origem SZA com destino SD2 | Bloqueio na linha |
| T16 | CadDePara: `ZB_IBSUFVL` → CD2 | Bloqueio na linha |
| T17 | De/para IBS/CBS → CD2 já existente na SZD | IP_040 processa normalmente e registra um WARN no log |
| T18 | IP140 de nota de débito subtipo 7 | `tpNFDebito = 07` |
| T19 | IP140/IP050 com `indPres` no XML | Valor do XML no TXT |
| T20 | IP140 de NF normal sem IBS/CBS | Totais IBS/CBS com `0.00` |
| T21 | IP140 de NF complementar com IPI | `vIPIDevol = 0.00` |
| T22 | IP140 de nota de entrada (SF1) com SD2 posicionado em CFOP 5921 | finNFe não vira 4 |
| T23 | IP140 de débito 06 com `ICMSPrevistoPagtoAntecip` no XML | `vICMSPrevisto` preenchido |

### 5.4 Decisões externas (sem mudança)

Ver seção 5 do `Diagnostico_Consolidado_NFe_2027_SCJ.md`:
- mapeamento DHL/DOX;
- tabela `F?_TPCOMPL` × NT;
- novos campos no IP040;
- layout IP140/IP050;
- leiaute Mastersaf DW 2027;
- escopo DHLIP210/SAPIP210;
- tratamento de rejeições no nfesefaz e nos PEs.

### 5.5 Arquivos alterados neste lote

- `PROTHEUS\Producao\SAP\ProcRCOMsa.prw`
- `PROTHEUS\Producao\SAP\ProcRSymbMsa.prw`
- `PROTHEUS\Producao\Mastersaf_NFe\ProcMsaNFe.prw` (só a correção de compilação)
- `PROTHEUS\Producao\SAP\SCJ\Classes\DHLIp040Sap.prw`
- `PROTHEUS\Producao\SAP\SCJ\Cadastro de Para CPOS Fiscal\CadDePara.prw`
- `PROTHEUS\Producao\SAP\SCJ\Cadastro de Regras Fiscais\CadRegFis.prw` e `updImpCD2.prw` (só a autoria nos comentários)

Todos em CP-1252 com CRLF, sem sequências UTF-8. A contagem de caracteres acentuados é igual à do backup; no CadDePara há 5 a mais, das mensagens novas.
