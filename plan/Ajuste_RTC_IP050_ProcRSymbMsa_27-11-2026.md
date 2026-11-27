# Ajuste RTC 2026/2027 — IP050 (ProcRSymbMsa.prw)

| Item | Valor |
|---|---|
| Projeto | SC Johnson / DHL — NF-e 2027 (IBS, CBS, IS) |
| Fonte | `PROTHEUS\Producao\SAP\ProcRSymbMsa.prw` (IP050 — retorno simbólico) |
| Data | 27/11/2026 |
| Responsável | Wellington Santana |
| Base normativa | LC 214/2025; Ajuste SINIEF 49/2025; NT 2025.002-RTC v1.53 |
| Origem das regras | `Mastersaf_NFe/ProcMsaNFe.prw` (ajustes de 18/11/2026), na versão corrigida do Lote 4 (`SAP/ProcRCOMsa.prw`, 22/11/2026) |
| Status | Código ajustado, **não compilado** (pendente compilação no AppServer) |
| Backup do original | `DV2_DHL\backup_rtc_ip050_20261127\ProcRSymbMsa.prw` |
| Documentos anteriores | `Diagnostico_Consolidado_NFe_2027_SCJ.md` (seção 2.2), `Diagnostico_RTC_Lotes2a4_Integracao.md` (seção 2.5), `Ajustes_Finais_RTC_SCJ_AG2.md` (item 1) |

---

## 1. Objetivo

Replicar no arquivo IP050 (Protheus → SAP, retorno simbólico) as regras da Reforma Tributária que já estão no `ProcMsaNFe` (Mastersaf) e no `ProcRCOMsa` (IP140). Antes deste ajuste, o IP050 só tinha o `indPres` lido do XML (Lote 4). Não tinha os grupos de IBS, CBS e IS, os totais, `cMunFGIBS`, `tpNFDebito`/`tpNFCredito` nem as regras de finalidade 3, 5 e 6.

## 2. Decisão: grupos novos desligados por parâmetro

O IP050 é um TXT posicional (`--tag_ini--;valor;--tag_fim--;`) gravado pelo `MsafRSymbFile` na ordem em que o `ProcRSymbMsa` monta as tags. **Qualquer campo novo desloca as posições lidas pelo SAP.**

Conforme o item 1 do `Ajustes_Finais_RTC_SCJ_AG2.md`, os grupos que mudam o layout ficam prontos, mas **desligados** até o SAP SCJ confirmar o layout (decisão 4 do diagnóstico consolidado).

| Parâmetro | Tipo | Default | Efeito |
|---|---|---|---|
| `ZZ_RTCIP50` | Lógico | `.F.` | `.T.` inclui no IP050 os grupos da reforma. Com `.F.`, o TXT sai **idêntico** ao de antes |

As regras que só trocam valor (finalidade) e a auditoria em log **valem sempre**, porque não mudam o layout.

## 3. O que foi ajustado

### 3.1 Sempre ativo (não muda o layout)

| Ponto | Ajuste |
|---|---|
| `ProcRSymbMsa()` | `MV_RTC55` → `lRefTribCo`; `ZZ_TRIBICM`/`ZZ_TRIBIS` lidos uma única vez (SonarQube G2); `ZZ_RTCIP50` → `lRtcIP050` |
| `ProcRSymbMsa()` | Chamada a `U_DHLRtcTagAudit` (só grava log da tag esperada que não veio no XML; inerte antes de `MV_RTC55`) |
| `getFinNfe()` | finNFe 5 (crédito) e 6 (débito) a partir de `F1_TIPO`/`F2_TIPO` |
| `getFinNfe()` | finNFe 3 (ajuste): unidades em `ZZ_FINAJUS` (default AG2), **só na saída**, unidade vazia rejeitada |
| `getFinNfe()` | Retorno de sacarias (CFOP 5921/6921) → finNFe 4, **só na saída** |

### 3.2 Só com `ZZ_RTCIP50 = .T.` (muda o layout)

| Grupo / campo | Posição no TXT |
|---|---|
| `cMunFGIBS` | `ide`, depois do `cMunFG` |
| `tpNFDebito` / `tpNFCredito` | `ide`, depois do `finNfe`. Valor do XML autorizado; fallback `F2_TPCOMPL`/`F1_TPCOMPL`; sempre 2 dígitos (nova `getTpCompl()`) |
| `vUnComLiq` / `vProdLiq` | Produto, entre `vProd` e `cEANTrib` |
| `ICMSPrevistoPagtoAntecip` | `ICMS` do item, primeiro filho (débito 06) |
| `IS` | Impostos do item, depois do `ISSQN` |
| Cadeia `IBSCBS` | Depois do `IS`: `gIBSCBS`, `gIBSUF`, `gIBSMun`, `gCBS` (com `gDif`, `gDevTrib`, `gRed`), `gTribRegular`, `gIBSCredPres`, `gCBSCredPres`, `gTribCompraGov`, `gIBSCBSMono` (padrão, retenção, retido, diferido), `gTransfCred`, `gCredPresIBSZFM` |
| `gAjusteCompet` / `gEstornoCred` | Fim da cadeia `IBSCBS` (débito 03 / débito 07) |
| `vItem` e `DFeReferenciado` | Item, depois de `inf_adicionais` e antes de `NUMERONF_SERIE` |
| `vProdLiqTot` | `total`, antes do `icms_Tot` |
| `ISTot`, `IBSCBSTot` (gIBS/gIBSUF/gIBSMun/gCBS/gMono) e `vNFTot` | `total`, depois do `ret_Trib` |

### 3.3 Diferenças em relação ao ProcMsaNFe

| Ponto | ProcMsaNFe | IP050 |
|---|---|---|
| finNFe 3 e 5921/6921 | Lê `SF2`/`SD2` também na nota de entrada | Só na saída (correção do Lote 4) |
| `tpNFDebito`/`tpNFCredito` | `F?_TPCOMPL` direto, 1 dígito | XML autorizado, 2 dígitos (correção do Lote 4) |
| `tpCredPresIBSZFM` | `lFormatZero` no parâmetro `lAddNode` do `setAttributeValue`: o código "0" saía como "0.00" | `lFormatZero` passado ao `retValTax` |
| `DoIBSCBSTot` | Usa `retArrayAtribute` (não existe no workspace) e `oDetNfe` sem declaração | Usa `retArrayAttribute` (definida no fonte) e declara `oDetNfe` como Private |
| `vItem` / `DFeReferenciado` | Pendurados no `det` | Pendurados no `item_nota` (no IP050 o `det` só leva o `nItem`) |

## 4. Gap analysis

Legenda: ✅ ajustado · ⚠️ não ajustado, com justificativa · 🔄 mantido como está

| # | Regra (diagnóstico 2.2) | Status | Observação |
|---|---|---|---|
| 1 | finNFe 5/6 e 3 | ✅ | Sempre ativo |
| 2 | `tpNFDebito`/`tpNFCredito` | ✅ | Com `ZZ_RTCIP50` |
| 3 | `indPres` | 🔄 | Já ajustado no Lote 4 |
| 4 | NFref com chave fixa em homologação | 🔄 | Fora da reforma; não alterado |
| 5 | `DFeReferenciado` | ✅ | Com `ZZ_RTCIP50` |
| 6 | Tributos antigos do `icms_Tot` vindos do SF2 | 🔄 | Fora do escopo; não alterado |
| 7 | IBSCBS / IS / totais | ✅ | Com `ZZ_RTCIP50` |
| 8 | Participante | 🔄 | Já é reflexo do XML |
| — | `vIPIDevol` só na devolução | ⚠️ | Não se aplica: o `icms_Tot` do IP050 não tem o campo e o `ipi_devol` já sai vazio |
| — | `icms_02/15/53/61`, `sequencia_XML`, `rastro`, `indIntermed` | ⚠️ | Não portados de propósito: são evoluções de layout do Mastersaf (2018–2023), não regras da reforma |

## 5. Verificações feitas

- Gravado em CP-1252 com CRLF, sem sequências UTF-8. Os 10 caracteres acentuados a mais em relação ao backup são o "nó" dos comentários copiados do RCO.
- Diff contra o backup: nenhuma linha original alterada além de linhas em branco.
- Toda função chamada nos trechos novos existe exatamente uma vez; nenhum `IIF` novo.

## 6. Pendências

### 6.1 Compilação

`ProcRSymbMsa.prw` e `DHLRtcTagAudit.tlpp` (obrigatório: o IP050 passa a chamar essa função). Se o `DHLRtcTagAudit` já estiver no RPO por causa do `ProcRCOMsa`, basta recompilar o `ProcRSymbMsa.prw`.

### 6.2 Dicionário (SX6)

| Parâmetro | Ação |
|---|---|
| `ZZ_RTCIP50` | Opcional. Criar com `.T.` só depois do aceite do SAP SCJ |
| `ZZ_TRIBICM`, `ZZ_TRIBIS`, `ZZ_FINAJUS`, `ZZ_RTCAUDI`, `MV_CSTGXML` | Já usados pelo `ProcRCOMsa`; todos têm default no código |

### 6.3 Testes em homologação

| # | Cenário | Resultado esperado |
|---|---|---|
| T1 | IP050 com `ZZ_RTCIP50` desligado | TXT idêntico ao gerado antes do ajuste (não regressão) |
| T2 | IP050 com `ZZ_RTCIP50 = .T.`, retorno simbólico com IBS/CBS | Grupos `IBSCBS` e totais batem com o XML autorizado |
| T3 | IP050 com `ZZ_RTCIP50 = .T.`, nota sem IBS/CBS | Totais IBS/CBS com `0.00`; `vBCIBSCBS` vazio |
| T4 | IP050 de nota de entrada (SF1) com SD2 posicionado em CFOP 5921 | finNFe não vira 4 |

### 6.4 Decisões externas

| # | Decisão | Responsável |
|---|---|---|
| 1 | Confirmar o layout 2027 do IP050 (decisão 4 do diagnóstico consolidado) antes de ligar `ZZ_RTCIP50` | SAP SCJ |
| 2 | Definir a TES e o cClassTrib do retorno simbólico: decide se o `IBSCBS` vem com valor ou como não incidência | Área fiscal |

## 7. Arquivos alterados

- `PROTHEUS\Producao\SAP\ProcRSymbMsa.prw`
