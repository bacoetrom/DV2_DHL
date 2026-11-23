# Diagnóstico RTC 2026/2027 — Lote 1 (Cadastros, Regras e Tabelas Fiscais Base)

| Item | Valor |
|---|---|
| Projeto | SC Johnson / DHL — NF-e 2027 (IBS, CBS, IS) |
| Lote | 1 — CadRegFis.prw, CadDePara.prw, updImpCD2.prw (+ chamador MT103FIM_pe.prw) |
| Data | 21/11/2026 |
| Base normativa | LC 214/2025; Ajuste SINIEF 49/2025; NT 2025.002-RTC v1.53; FDD IM04 |
| Status | Código ajustado, **não compilado** (pendente compilação no AppServer) |
| Backup dos originais | `DV2_DHL\backup_rtc_lote1_20261121\` |

---

## 1. Avaliação de tabelas, dados e comunicação

### 1.1 Mapa de tabelas e estruturas

| Tabela / estrutura | Gravada por | Lida por | Papel |
|---|---|---|---|
| **SZC** — Regras Fiscais | CadRegFis | `DHLIp040Sap:getTesOperation` ← `SAPIP040:getTES` / `getCFOP` | Define TES (e CFOP via `F4_CF`) da NF RCO a partir de flags de ICMS (`ZC_ICMPROP`, `ZC_ICMREDB`, `ZC_ICMST`, `ZC_ICMDIFA`, `ZC_ICMZFM`) |
| **SZD** — De/Para Campos Fiscais | CadDePara | `DHLIp040Sap:setFieldsSzd` → `validValues` | Mapeia campos SZA/SZB (IP_040) para SF2, SD2, SFT, SB1, CD2 e SF3, sobrescrevendo os valores calculados pelo Protheus com os do SAP |
| **SZA / SZB** — Cabeçalho/Itens IP_040 | SAPIP040 / DHLIp040Sap (Lote 2) | updImpCD2 (`ZA_KENFSCJ`, `ZB_UTRIB`, `ZB_QTRIB`) | SZB já possui IBS/CBS: `ZB_IBSUFTX/BS/VL`, `ZB_IBSMUTX/BS/VL`, `ZB_CBSTXRT/BS/VL` |
| **CD2** | updImpCD2 (entrada) | updImpCD2 (saída original) | FCP: `CD2_PFCP`, `CD2_VFCP`, `CD2_BFCP` (ICM / SOL) |
| **SFT** | updImpCD2 | — | `FT_VALFECP`, `FT_VFECPST` |
| **SD1 / SF1 / SF2** | updImpCD2 (`D1_ZZUTRIB`, `D1_ZZQTRIB`) | updImpCD2 | Vínculo NF de devolução/crédito → NF original (`D1_NFORI`, `D1_SERIORI`, `D1_ITEMORI`) |
| `dhl.ch` | — | todos | `REMESSA_CONTA_ORDEM`, `DEVOLUCAO`, `DHL_BUSINESSUNIT_*` |

### 1.2 Fluxo entre rotinas

```
SAP (IP_040) ──► SAPIP040 ──► SZA/SZB
                     │
                     ├─ getTES/getCFOP ──► DHLIp040Sap:getTesOperation ──► SZC (CadRegFis)
                     │
                     └─ DHLIp040Sap:validValues ──► SZD (CadDePara) ──► SF2/SD2/SFT/SB1/CD2/SF3
                                                                             │
MATA103 (devolução / crédito) ──► MT103FIM ──► updImpCD2 ──► CD2/SFT/SD1 ◄───┘ (NF original)
                                                                             │
                                                        ProcRCOMsa / MsafRCOFile (Lote 4)
```

### 1.3 Quebras de comunicação identificadas

| # | Severidade | Ponto | Descrição | Lote de correção |
|---|---|---|---|---|
| Q1 | 🔴 Alta | `DHLIp040Sap.prw` linhas 363–389 | O ramo CD2 do `validValues` só trata `FIELDS_ICMS`, `FIELDS_ICMS_ST`, `FIELDS_ICMS_DIFAL` e `FIELDS_ICMS_SUFRAMA`. As constantes `FIELDS_IBS_UF`, `FIELDS_IBS_MUN` e `FIELDS_CBS` estão definidas mas **nunca usadas**: qualquer de/para SZD de IBS/CBS para CD2 é descartado silenciosamente (`lOk` permanece `.F.`). | Lote 2 |
| Q2 | 🔴 Alta | SZC + `fQryTes` | A regra fiscal não tem discriminador de finalidade (finNFe) nem de subtipo (tpNFCredito/tpNFDebito). Impossível selecionar TES de CFOP 5.927, 5.922/6.922 etc. | Lote 1 (cadastro) + Lote 2 (query) |
| Q3 | 🟡 Média | CadDePara × CadRegFis | Ambos usavam o mesmo ID de modelo MVC `MIDREGFI`. | Lote 1 ✅ |
| Q4 | 🟡 Média | `dhl.ch` | Unidades **DHL** e **DOX** do FDD IM04 não existem como `DHL_BUSINESSUNIT_*` (existem SPL, PKG, REV, DIS, REP, AGE, MUL, AG2, AGL, DI2). Falta mapeamento para `FWUnitBusiness()`. | Definição funcional |
| Q5 | 🟡 Média | `MT103FIM` → updImpCD2 | Propagação de FCP/UTRIB restrita a AG2 e `F1_TIPO = "D"`; Nota de Crédito (`F1_TIPO = "5"`) de retorno/recusa não era tratada. | Lote 1 ✅ (parametrizado) |
| Q6 | 🟡 Média | `ProcRCOMsa:getTpCompl()` | Retorna `AllTrim(F2_TPCOMPL)` (ex.: `"7"`), enquanto o `nfesefaz.prw` usa `padl(...,2,'0')`. A NT exige 2 dígitos em `tpNFDebito`/`tpNFCredito`. | Lote 4 |
| Q7 | ⚪ Confirmar | `nfesefaz.prw` linha 4526 | Comentário padrão descreve `F1_TIPO 5 + F1_TPCOMPL 3` como "Transferência de Crédito na sucessão"; o FDD IM04 trata Crédito 03 como retorno/recusa. Confirmar a semântica com a área fiscal. | Definição funcional |

---

## 2. Diagnóstico e ajustes por fonte

### 2.1 CadRegFis.prw (SZC)

**Situação anterior:** MVC simples, validação do modelo `{|oModel| .T. }` — nenhuma consistência. Como `fQryTes` retorna o primeiro registro que casa com os flags, regras duplicadas tornavam a TES imprevisível.

**Ajustes aplicados:**
- `#include "Protheus.ch"` → `#include "totvs.ch"`.
- Nova função `vldRegra` (validação final do modelo, inclusão/alteração):
  1. TES deve existir na SF4;
  2. bloqueia regra duplicada (mesma combinação de flags + finalidade/subtipo, excluindo o próprio registro na alteração);
  3. se `ZC_FINNFE` / `ZC_TPCOMPL` existirem no dicionário (`FieldPos`):
     - finalidade 5/6 exige subtipo;
     - finalidade 5 (crédito) exige TES de entrada (< 500); finalidade 6 (débito) exige TES de saída (≥ 500);
     - coerência CFOP × subtipo (Ajuste SINIEF 49/2025), desligável por `ZZ_RTCVLCF`.
- Nova função `cfopEsperado`:

| Finalidade / subtipo | CFOPs aceitos |
|---|---|
| Débito 07 (perda em estoque) | 5927 |
| Débito 06 | 5922, 6922 |
| Débito 09 (devolução/retorno) | 5201, 6201, 5202, 6202, 5949, 6949 |
| Crédito 03 | 1201, 2201, 1202, 2202, 1949, 2949 |
| Crédito 04 (inverso da original) | 1202, 2202, 1949, 2949 |
| Demais | sem restrição |

### 2.2 CadDePara.prw (SZD)

**Situação anterior:** ID de modelo duplicado; nenhuma validação — um campo inexistente quebrava a macro `&()` em `DHLIp040Sap:validValues`, interrompendo a sobrescrita dos tributos.

**Ajustes aplicados:**
- `MVC_MODEL_ID` `MIDREGFI` → `MIDDEPAR` (nenhum fonte referencia o ID antigo).
- `#INCLUDE "PROTHEUS.CH"` → `#INCLUDE "TOTVS.CH"`.
- Nova validação de linha `vldLinha` (bLinePost do grid):
  - `ZD_CPODE` e `ZD_CPOPARA` devem existir no SX3 (`GetSx3Cache`);
  - `ZD_TABPARA` deve estar entre SF2, SD2, SFT, SB1, CD2, SF3 (tabelas tratadas pelo `validValues`);
  - o campo destino deve pertencer à tabela destino (`PrefixoCpo`).
- Verificado: as queries agregadas do `DHLIp040Sap` usam o próprio nome SX3 como alias (`SUM(campo) campo`), portanto a validação SX3 não bloqueia registros legítimos.

### 2.3 updImpCD2.prw (CD2 / SFT / SD1)

| Defeito | Correção |
|---|---|
| `While SD1->(!eof()) == SD1->(chave) == cChaveSD1` — compara lógico com caractere (precedência incorreta) | `While !eof() .and. chave == cChaveSD1` |
| `RecLock` em CD2 e SFT sem `MsUnlock` | `MsUnlock` incluído |
| Busca do FCP na CD2 da saída com a loja da **entrada** (`cLoja`) | Usa a loja do cliente da NF original (`cLojaSaid`) |
| `cSerieOri` não declarada (Private implícita) | Declarada como Local |
| `SZA100` / `SD1100` fixos na query | `%SZA.SQLNAME%` / `%SD1.SQLNAME%` |
| SZA sem filtro `D_E_L_E_T_` | `%SZA.NOTDEL%` no JOIN |
| JOIN `ZA_SERIRCO = D1_SERIE` (série da entrada) | `ZA_SERIRCO = D1_SERIORI` ⚠️ **validar em homologação** |
| Query da chave IP_040 executada por item (mesmo resultado) | Executada uma vez por documento (`getKey040`) |
| `D1_ZZUTRIB` / `D1_ZZQTRIB` zerados quando não há vínculo IP_040 | Só grava quando houver valor |
| Itens sem `D1_NFORI` processados | Ignorados |

### 2.4 MT103FIM_pe.prw (chamador)

- Unidades que executam o updImpCD2 passam a vir de `ZZ_UPDCD2U` (default `AG2`).
- Executa também para Nota de Crédito (`F1_TIPO = "5"`) cujo `F1_TPCOMPL` esteja em `ZZ_UPDCD2C` (ex.: `3|6`).
- Guarda contra `FWUnitBusiness()` vazio e `F1_TPCOMPL` vazio.
- **Com os defaults, o comportamento é idêntico ao anterior.**

### 2.5 Diretrizes fora do escopo deste lote

indPres, NFref/DFeReferenciado (B25-40, VC02-10), omissão de impostos antigos (B25-80), gAjusteCompet (UB112), participante `<dest>`/0150 e classificação Mastersaf DW não passam pelos fontes do Lote 1 → Lotes 3 e 4.

---

## 3. Gap analysis (original × ajustado)

| Funcionalidade original | Status |
|---|---|
| Browse / MenuDef / ModelDef / ViewDef CadRegFis | ✅ mantido |
| Browse / MenuDef / ModelDef / ViewDef CadDePara (form + grid) | ✅ mantido |
| ParamBox e filtro por tabela no CadDePara | ✅ mantido |
| Propagação FCP ICM/SOL para CD2 e SFT na devolução | ✅ mantido (chave corrigida) |
| UTRIB/QTRIB para remessa por conta e ordem | ✅ mantido |
| Restrição AG2 + devolução no MT103FIM | ✅ mantido por default, agora parametrizável |
| Propagação de IBS/CBS na devolução | 🔄 deixada ao cálculo padrão TOTVS — campos de IBS/CBS na CD2 não identificados no código; não foram inventados |

---

## 4. Pendências e validação

### 4.1 Dicionário e parâmetros

| Tipo | Nome | Definição sugerida | Obrigatório? |
|---|---|---|---|
| Campo SX3 | `ZC_FINNFE` | C, 1, combo `1=Normal;2=Complementar;3=Ajuste;4=Devolução;5=Crédito;6=Débito` | Sim, para Q2 |
| Campo SX3 | `ZC_TPCOMPL` | C, mesmo tamanho de `F2_TPCOMPL` | Sim, para Q2 |
| Parâmetro SX6 | `ZZ_RTCVLCF` | L, `.T.` — liga validação CFOP × subtipo | Opcional |
| Parâmetro SX6 | `ZZ_UPDCD2U` | C, `AG2` — unidades do updImpCD2 | Opcional |
| Parâmetro SX6 | `ZZ_UPDCD2C` | C, vazio — subtipos de crédito (ex.: `3|6`) | Opcional |

### 4.2 Dependências para os próximos lotes

- **Lote 2:** `fQryTes` deve filtrar `ZC_FINNFE`/`ZC_TPCOMPL` (e remover `IIF` — CA4000); `validValues` deve tratar `FIELDS_IBS_UF`, `FIELDS_IBS_MUN` e `FIELDS_CBS` no ramo CD2 (depende do código de `CD2_IMP` para IBS/CBS no padrão TOTVS).
- **Lote 4:** `getTpCompl()` com `PadL(...,2,"0")`.
- **Funcional:** mapear DHL/DOX para códigos de unidade; confirmar semântica de `F1_TPCOMPL = 3` (Q7); confirmar se Notas de Crédito de entrada preenchem `D1_NFORI`.
- **Externa:** leiaute Mastersaf DW 2027.

### 4.3 Cenários de teste

| # | Cenário | Resultado esperado |
|---|---|---|
| T1 | Incluir regra SZC com flags iguais a uma existente | Bloqueio "regra duplicada" |
| T2 | Regra SZC com TES inexistente | Bloqueio "TES não encontrada" |
| T3 | Regra finNFe 6 / subtipo 7 com TES de CFOP 5949 | Bloqueio "CFOP incompatível" (esperado 5927) |
| T4 | Regra finNFe 5 com TES de saída | Bloqueio "TES de entrada" |
| T5 | Linha SZD com campo origem/destino inexistente | Bloqueio na linha |
| T6 | Linha SZD com tabela destino fora da lista | Bloqueio na linha |
| T7 | Devolução AG2 de cliente com loja ≠ loja da entrada | FCP copiado para CD2/SFT da entrada |
| T8 | Devolução AG2 com série diferente da NF original (RCO) | `D1_ZZUTRIB`/`D1_ZZQTRIB` preenchidos |
| T9 | Nota de Crédito subtipo 3 com `ZZ_UPDCD2C = "3|6"` | updImpCD2 executado |
| T10 | Mesmo cenário com `ZZ_UPDCD2C` vazio | updImpCD2 não executado (comportamento anterior) |
| T11 | Devolução em unidade fora de `ZZ_UPDCD2U` | updImpCD2 não executado |
| T12 | Após gravação, outro usuário altera o mesmo CD2/SFT | Sem lock pendente |

### 4.4 Arquivos alterados

- `PROTHEUS\Producao\SAP\SCJ\Cadastro de Regras Fiscais\CadRegFis.prw`
- `PROTHEUS\Producao\SAP\SCJ\Cadastro de Para CPOS Fiscal\CadDePara.prw`
- `PROTHEUS\Producao\SAP\SCJ\updImpCD2.prw`
- `PROTHEUS\Producao\Pontos_de_Entrada\COM\MT103FIM_pe.prw`

Todos em CP-1252, sem BOM, sem sequências UTF-8.
