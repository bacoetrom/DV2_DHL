# Ajustes Finais — RTC 2026/2027 (IBS, CBS, IS) — SC Johnson / AG2

| Item | Valor |
|---|---|
| Projeto | SC Johnson / DHL — NF-e 2027 (IBS, CBS, IS) |
| Unidade de negócio | AG2 (SC Johnson) |
| Data | 24/11/2026 |
| Responsável | Wellington Santana |
| Base normativa | LC 214/2025; NT 2025.002-RTC v1.53; NT 2026.008; Ajuste SINIEF 49/2025 |
| Documentos relacionados | `Detalhe_Fontes_SCJ_AG2.md`, `Diagnostico_RTC_Lotes2a4_Integracao.md`, `Dicionario_RTC_Lotes1a4.md`, `Inventario_Tags_NFe_2027.md` |

> **Situação:** nenhum fonte ajustado nos Lotes 1 a 4 nem em 23/11 foi compilado ainda. Os pontos abaixo são o que falta para colocar a reforma em produção com segurança.

---

## 1. 🔴 Pode rejeitar nota na SEFAZ

Os três fontes abaixo **não estão na lista dos 21 fontes**, mas estão no caminho da nota enviada à SEFAZ. É por eles que passam o `PrcXmlNfe`, o `M460FIM_pe` e o `PrcGrvRco`.

### 1.1 ProcMsaNFe.prw — monta o arquivo da NF-e para o Mastersaf

Ele tem os mesmos erros que já foram corrigidos no `ProcRCOMsa.prw` (IP140), mas aqui afetam a **nota transmitida**.

| # | Problema | O que a NT exige | Risco |
|---|---|---|---|
| 1 | `tpNFDebito`/`tpNFCredito` com 1 dígito (`getTpCompl`, linha 315): sai "7" | 2 dígitos ("07") | Erro de schema em toda nota de crédito ou débito |
| 2 | 21 totais de IBS/CBS (`IBSCBSTot`) com `lFormatZero` fora dos parênteses: total zerado sai **vazio** | Campos obrigatórios no total, mesmo zerados | Erro de schema quando algum total for zero. O IBS municipal é zero em 2026 |
| 3 | `ZZ_TRIBICM` com padrão `"ICM"` (linha 5063): o grupo `ICMSPrevistoPagtoAntecip` nunca é preenchido | Obrigatório no débito 06 | Rejeição no débito 06 |
| 4 | `indPres` sempre "0" (linha 247) | Indicador real da operação | Informação errada |
| 5 | `cMunFGIBS` sempre vazio (linha 226) | Obrigatório com `indPres=5` sem endereço do destinatário | Rejeição só nesse cenário |

**Ação:** aplicar as correções 1 a 4, iguais às do `ProcRCOMsa`.

**Antes, confirmar:**
- o fonte é **compartilhado por todas as unidades de negócio**, e qualquer correção vale para todas;
- quem é o responsável por ele;
- se ele faz parte desta entrega (item A4 do `Diagnostico_RTC_Lotes2a4_Integracao.md`).

### 1.2 nfesefaz.prw — gera o XML da nota (padrão TOTVS customizado)

Não gera várias tags novas. O `ProcMsaNFe` e o `ProcRCOMsa` leem essas tags do XML e elas saem **vazias**.

| Tag | Exigida em |
|---|---|
| `vUnComLiq`, `vProdLiq`, `vProdLiqTot` | **Todas** as notas, inclusive a venda normal |
| `IS`, `ISTot` | Venda, crédito 03 e crédito 06 |
| `ICMSPrevistoPagtoAntecip` | Débito 06 |
| `gAjusteCompet` | Débito 03 |
| `gEstornoCred` | Débito 07 |

Só o `DFeReferenciado` já existe no fonte.

**Ação:** atualizar o nfesefaz com o pacote da TOTVS para a NT 2025.002 v1.53 e conferir se ele passa a gerar essas tags.

### 1.3 PE01NFESEFAZ.prw e ImpMsaNfe.prw

| Problema | Ação |
|---|---|
| Trava fixa da AG2 na nota de ajuste (`PE01NFESEFAZ.prw` linhas 197-198 e 608-609; `ImpMsaNfe.prw` linha 1032) | Definir o critério (unidade de negócio ou empresa) e alinhar com o `ZZ_FINAJUS` |
| Regras de nota referenciada (`NFref`/`DFeReferenciado`) por tipo de nota, para evitar as rejeições VC02-10 e 1039 | Implementar na origem do XML |
| Omissão de ICMS, IPI, PIS, COFINS e ISSQN no débito 03 e no débito 07 (rejeições 1021, 1170 e 1171) | Implementar na origem do XML |

**Ação:** incluir esses fontes no escopo do projeto.

---

## 2. 🟡 Informação errada ou faltando (nos seus fontes)

| # | Fonte | Ponto | Depende de | Ação |
|---|---|---|---|---|
| 1 | `SAP/ProcRSymbMsa.prw` (IP050) | **O IBS/CBS do retorno simbólico não chega ao SAP.** Faltam os grupos `IBSCBS`, `IS`, os totais `IBSCBSTot` e `cMunFGIBS` | SAP confirmar o layout do IP050 (decisão 4) | Copiar as funções do `ProcRCOMsa`. Pode ficar pronto e desligado por parâmetro até a confirmação |
| 2 | `SAP/SCJ/Cadastro de Para CPOS Fiscal/CadDePara.prw` | O de/para de IBS/CBS ainda é **permitido** para SD2, SFT, SB1, SF3 e SF2. Se cadastrado, o valor do SAP sobrescreve o calculado pela TOTVS. Na SF3, a alíquota sai somada (2 itens a 0,90% viram 1,80%) | — | Recomendado: bloquear IBS/CBS para qualquer destino |
| 3 | `SAP/SCJ/Cadastro de Regras Fiscais/CadRegFis.prw` | A lista de CFOP por subtipo (`cfopEsperado`) foi montada com base no Ajuste SINIEF 49/2025 e **não foi validada pelo fiscal** | Área fiscal | Validar. Até lá, pode ser desligada com `ZZ_RTCVLCF = .F.` |
| 4 | `CadRegFis.prw` / `DHLIp040Sap.prw` | A TES da NF RCO é escolhida **só pelos indicadores de ICMS**. Duas operações com o mesmo ICMS e cClassTrib diferentes não podem ser separadas | SAP enviar CST/cClassTrib | Revisar quando o IP_040 trouxer esses dados |
| 5 | `SAP/SCJ/SAPIP040.prw`, `DHLIp040Sap.prw`, `PrcNfRco.prw`, `PrcGrvRco.prw` | O IP_040 **não traz** CST, cClassTrib, IS, indPres nem finalidade/subtipo de crédito ou débito | SAP (decisão 3) | Hoje a RCO é sempre nota normal (`F2_TIPO = "N"`), o que está correto |
| 6 | `SAP/SCJ/PrcNfRet.prw` | O IBS/CBS do retorno simbólico vem da **TES do pedido** (`C6_TES`). O valor enviado pelo SAP é o da venda e não deve ser usado no retorno | Área fiscal | Confirmar a TES e o cClassTrib do retorno simbólico (não incidência) |
| 7 | IP_040 enviado pelo SAP | Rodapé com erro: `IBS_MUN_TOTAL_VALUE` = 666,79 com itens zerados e `IBS_TOTAL_VALUE` = 0. `TAX_RATE` vazio em IBS_UF, IBS_MUN e CBS | SAP | O `SAPIP040` já contorna (soma dos itens e alíquota calculada), mas o SAP deve corrigir |

---

## 3. 🔵 Cuidados para colocar em produção

### 3.1 Compilação

Compilar o pacote **inteiro**:

| Fonte | Lote |
|---|---|
| `SAP/ProcRCOMsa.prw` | 2 a 4 |
| `SAP/ProcRSymbMsa.prw` | 4 |
| `Mastersaf_NFe/ProcMsaNFe.prw` | Correção de compilação |
| `SAP/SCJ/Classes/DHLIp040Sap.prw` | 2 |
| `SAP/SCJ/Cadastro de Para CPOS Fiscal/CadDePara.prw` | 1 e 2 |
| `SAP/SCJ/Cadastro de Regras Fiscais/CadRegFis.prw` | 1 |
| `SAP/SCJ/updImpCD2.prw` | 1 |
| `Pontos_de_Entrada/COM/MT103FIM_pe.prw` | 1 |
| `SAP/SCJ/SAPIP040.prw` | 23/11 |
| `SAP/SCJ/PrcGrvRco.prw` | 23/11 |
| `Mastersaf_NFe/DHLRtcTagAudit.tlpp` | **Obrigatório**: o `ProcRCOMsa` chama esta função |

Backups dos originais: `backup_rtc_lote2a4_20261122/` e `backup_rtc_ip040_20261123/`.

### 3.2 Ordem de implantação

1. Compilar o pacote completo.
2. Conferir e ajustar os parâmetros (3.3).
3. **Só depois de compilar o `DHLIp040Sap.prw`**, criar, se necessários, os campos opcionais `ZC_FINNFE` e `ZC_TPCOMPL` na SZC. É o filtro do `fQryTes` que impede a NF RCO de receber a TES de uma regra de crédito ou débito.

### 3.3 Parâmetros (SX6)

| Parâmetro | Padrão no código | Cuidado |
|---|---|---|
| `ZZ_TRIBICM` | `ICMS` | Se já existir com `ICM`, **trocar para `ICMS`** |
| `ZZ_TRIBIS` | `IS` | Conferir com o código do tributo no XML |
| `ZZ_TRIBSUF` / `ZZ_TRIBSMU` / `ZZ_TRIBCBS` | `TR0002` / `TR0003` / `TR0001` | Conferir com o cadastro de tributos do ambiente. Se não baterem, a conferência do `PrcGrvRco` aponta divergência em todos os itens |
| `MV_RTC55` | 05/01/2026 | Data de início da reforma (ProcRCOMsa e PrcGrvRco) |
| `ZZ_FINAJUS` | `AG2` | Unidades que podem emitir nota de ajuste |
| `ZZ_UPDCD2U` / `ZZ_UPDCD2C` | `AG2` / vazio | Unidades e subtipos de crédito que executam o `updImpCD2` |
| `ZZ_RTCCONF` | `.T.` | Liga a conferência IBS/CBS SAP × Protheus (`PrcGrvRco`) |
| `ZZ_RTCAUDI` | `.T.` | Liga a auditoria de tags da reforma (`DHLRtcTagAudit`) |
| `ZZ_RTCVLCF` | `.T.` | Liga a validação CFOP × subtipo (`CadRegFis`). Desligar se a lista não for validada pelo fiscal |

### 3.4 Logs a acompanhar após a implantação

| Fonte | Mensagem | Significado |
|---|---|---|
| `SAPIP040` | `[RTC-2026/2027] IP_040 com FOOTER/... diferente da soma dos itens` | Rodapé do SAP divergente. O Protheus gravou a soma dos itens |
| `PrcGrvRco` | `[RTC-2026/2027] NF RCO ...: IBS UF/IBS Mun/CBS SAP = ... / Protheus = ...` | Cálculo da TOTVS diferente do SAP. Revisar a TES e o cadastro de tributos |
| `DHLIp040Sap` | `De/Para SZD de IBS/CBS para CD2 ignorado` | Há um de/para de IBS/CBS sem efeito cadastrado na SZD |
| `DHLRtcTagAudit` | Tags da reforma ausentes no XML | O nfesefaz não gerou uma tag esperada |

### 3.5 Pendências com o SAP

1. Corrigir `IBS_MUN_TOTAL_VALUE` e `IBS_TOTAL_VALUE` no rodapé do IP_040.
2. Enviar `TAX_RATE` preenchido em IBS_UF, IBS_MUN e CBS.
3. Definir se o IP050 deve receber IBS, CBS e IS (decisão 4).
4. Definir se o IP_040 vai trazer CST, cClassTrib, IS, indPres e finalidade/subtipo (decisão 3).

### 3.6 Pendências com o fiscal

1. Validar a lista de CFOP por subtipo do `CadRegFis` (`cfopEsperado`).
2. Confirmar o significado do `F1_TPCOMPL = 3`: o padrão TOTVS trata como "transferência de crédito na sucessão", e a NT trata o crédito 03 como retorno ou recusa.
3. Definir a TES e o cClassTrib do retorno simbólico.
4. Definir se DHL e DOX passam a emitir nota de ajuste. Hoje não existem como unidade de negócio.

### 3.7 Testes em homologação

Uma nota de cada cenário. Em cada uma, conferir a autorização da SEFAZ e se o IP140/IP050 bate com o XML autorizado.

| Cenário | finNFe | O que conferir |
|---|---|---|
| Venda / RCO | 1 | `IBSCBS`, `vProdLiq`, totais, conferência do `PrcGrvRco` sem divergência |
| Retorno simbólico | 1 | TES e cClassTrib do retorno; IP050 |
| Devolução | 4 | `DFeReferenciado`, `vIPIDevol` só aqui, FCP pelo `updImpCD2` |
| Complementar | 2 | Totais |
| Ajuste | 3 | Só na saída e só na AG2 |
| Crédito 03 / 04 / 06 | 5 | `tpNFCredito` com 2 dígitos; `IS` no 03 e no 06 |
| Débito 03 / 04 / 06 / 07 | 6 | `tpNFDebito` com 2 dígitos; `gAjusteCompet` (03); `ICMSPrevistoPagtoAntecip` (06); `gEstornoCred` (07); sem `gIBSCBS` no 03 e no 07 |
| IP_040 do SAP de 27/10/2026 | — | Totais e alíquotas da SZA/SZB e os dois avisos de rodapé |

### 3.8 Observação fora da reforma

`PrcRCOXml.prw`, `PrcXmlRSymb.prw` e `PrcXmlNfe.prw` passam a variável `cVersao` ao `XmlNfeSef`, mas ela não está declarada nesses fontes. Funciona só se o programa que os chama a criar como Private. Não foi alterado.
