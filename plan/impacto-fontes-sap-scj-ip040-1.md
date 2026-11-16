---
goal: Classificação de impacto por fonte — interface SAP/SCJ (IP_040 / IP_150 / IP_190, unidade AG2) frente ao Configurador de Tributos e à Reforma Tributária (IBS/CBS)
version: 1.0
date_created: 2026-11-13
last_updated: 2026-11-13
owner: DHL - Equipe Protheus / Fiscal (DV2) - Unidade de Negócio AG2 (SCJ - PUZZLE)
status: 'Planned'
tags: [impacto, analise, fiscal, reforma-tributaria, ibs-cbs, cfgtrib, sap, integration]
plano_relacionado: plan/upgrade-sap-scj-ip040-ibs-cbs-1.md
---

# Classificação de Impacto — Interface SAP/SCJ (IP_040 / IP_150 / IP_190)

![Status: Planned](https://img.shields.io/badge/status-Planned-blue)

Documento de apoio ao plano [upgrade-sap-scj-ip040-ibs-cbs-1.md](upgrade-sap-scj-ip040-ibs-cbs-1.md). Classifica **fonte por fonte** o impacto da adequação ao Configurador de Tributos (CFGTRIB/FISA170) e à Reforma Tributária do Consumo (IBS/CBS), com a evidência que sustenta cada classificação.

## 1. Critérios de Classificação

A classificação não é subjetiva. Cada fonte recebeu o nível correspondente ao **primeiro critério satisfeito**, na ordem abaixo:

| Nível | Critério objetivo | Consequência se não tratado |
|-------|-------------------|------------------------------|
| **ALTO** | O fonte (a) compara, grava ou sobrescreve valor/base/alíquota de tributo; **ou** (b) seleciona a TES / dirige o cálculo fiscal; **ou** (c) aciona a rotina que gera o documento fiscal | NF emitida com IBS/CBS sem conferência contra o SAP — divergência silenciosa entre os dois ERPs |
| **MÉDIO** | Controla o ciclo de vida do documento (cancelamento, estorno, validação de exclusão) **sem** mapear campo de tributo diretamente | Registros de `F2D` órfãos após cancelamento; apuração inconsistente |
| **BAIXO** | Não trata valor de tributo. Alteração limitada a texto legal, mensagem ou validação de referência | Risco residual: texto legal desatualizado frente à LC 214/2025 |
| **SEM IMPACTO DIRETO** | Nenhum campo fiscal no fonte. Apenas validação de regressão | Nenhuma |
| **N/A** | Fonte morto ou fora do escopo | Nenhuma |

**Critério de evidência.** Toda classificação ALTO ou MÉDIO cita a função e a linha que a sustenta. Classificações BAIXO e SEM IMPACTO DIRETO citam a **ausência verificada** de campos de tributo no fonte.

## 2. Resumo Executivo

### Os 7 fontes indicados

| Fonte | Linhas | Impacto | Por quê |
|---|---|---|---|
| `DHLIp040Sap.prw` | 1063 | **ALTO** | Motor de conciliação; constantes IBS/CBS mortas; sem F2D |
| `PrcGrvRco.prw` | 369 | **ALTO** | Chama `validValues()`; grava direto em SD2/SFT/CD2/SF3; força `F3_REPROC='N'` |
| `PrcNfRco.prw` | 470 | **ALTO** | MATA920; muta SF4 e SB1 em runtime; TES por `F4_SITTRIB` |
| `PrcNfRet.prw` | 638 | **ALTO** | MaPvlNFS; contém o molde `U_GravaFCP` |
| `DHLIp150.prw` | 1458 | **MÉDIO** | Cancelamento — precisa garantir estorno de F2D |
| `PrcGrvRet.prw` | 180 | **BAIXO** | Só mensagens SZZ + e-mail; revisar texto legal |
| `SAPIP190.prw` | 249 | **SEM IMPACTO DIRETO** | ASN Confirmation: só ITEM/QUANTITY/UOM/LOT, zero campo fiscal |

### Totais incluindo os fontes acoplados

| Nível | Qtd. fontes | Linhas de código |
|-------|-------------|------------------|
| ALTO | 5 | ~3.962 |
| MÉDIO | 5 | ~2.214 |
| BAIXO | 4 | ~450 |
| SEM IMPACTO DIRETO | 1 | 249 |
| **Total em avaliação** | **15** | **~6.875** |

**Diagnóstico em uma frase:** os valores de IBS/CBS **já chegam do SAP e já são gravados em `SZA`/`SZB`** por um mecanismo dinâmico de dicionário — e **param ali**, porque o motor de conciliação só conhece `CD2` (ICM/SOL/CMP/ZFM) e o IBS/CBS vive em `F2D`.

## 3. Detalhamento — Os 7 Fontes Indicados

### 3.1 `Classes/DHLIp040Sap.prw` — 1063 linhas — **ALTO**

Classe central da interface. É o motor que compara os valores do SAP (`SZA`/`SZB`) com os calculados pelo Protheus e sobrescreve o Protheus quando divergem, usando o De/Para da tabela `SZD`.

| Evidência | Linha | Constatação |
|---|---|---|
| `FIELDS_IBS_UF`, `FIELDS_IBS_MUN`, `FIELDS_CBS` | L15-18 | Constantes **declaradas e nunca usadas** em nenhum ponto do código |
| `validValues()` | L321-449 | Motor de comparação/sobrescrita. Whitelist de destino: `"SD2\|SFT\|SB1\|"`, `"CD2\|"` e `"SF3"` — **`F2D` não existe no fluxo** |
| Bloco de impostos em `CD2` | L363-383 | Cobre apenas `ICM` (L368), `SOL` (L372), `CMP` (L376) e `ZFM` (L380). **Nenhum desvio para IBS/CBS** |
| `DbSeek` de `CD2` | L368 | Chave de documento: `FILIAL+"S"+SERIE+DOC+CLIENTE+LOJA+ITEM+PRODUTO+IMPOSTO`. A `F2D` é chaveada por GUID (`F2D_ID`/`F2D_IDREL`, 36 pos.) e **não tem colunas de documento** — inacessível por este mecanismo |
| `getTesOperation()` | L292-310 | Seleciona TES na tabela `SZC` por ICMS, ICMS-ST, Redução de Base, DIFAL e ZFM. **Sem critério de IBS/CBS** — e sob CFGTRIB a TES não dirige os tributos novos |
| `isEqualSf3()` | L556-569 | Valida a **quantidade de linhas** de `SF3` esperada × gerada. Quebra se a escrituração dos tributos novos mudar o desmembramento |
| `DbSeek` de `SF3` | L419 | Chave inclui **CFOP + alíquota de ICMS**, com `cAliq := "0.00"` forçado quando há redução de base (L413-417) |
| `setFieldsSzd()` | L264-278 | Carrega o De/Para de `SZD` do banco. **Sem linha de IBS/CBS, não há o que comparar** — é parametrização, não código |
| `updateFields()` | L638-644 | `RecLock` + atribuição por macro. Funciona para tabela posicionável; não serve para `F2D` |
| `retCposSZB()` / `retCposSf3()` | L1110-1151 | Montam os `SUM()` varrendo **todos** os campos numéricos do `SX3`. **Campos de IBS/CBS já entram na aglutinação sem alterar código** |

**Ação:** novo método `validRtcValues()`; desvio explícito no bloco `CD2` para as constantes de IBS/CBS; revisão de `getTesOperation()`.

### 3.2 `PrcGrvRco.prw` — 369 linhas — **ALTO**

Processamento final da NF RCO (referência: Ponto de Entrada `M460FIM`).

| Evidência | Linha | Constatação |
|---|---|---|
| `oIp040:validValues(oSqlSZB, oSqlGroup)` | L54 | Dispara o motor de conciliação — é o **ponto natural de inserção** da conciliação de IBS/CBS |
| Gravação direta em tabelas fiscais | L77-99 | `RecLock` direto em `SD2` (L77), `SFT` (L85) e `CD2` (L96) para ICMS desonerado / SUFRAMA |
| Gravação direta em `SF3` | L133-141 | Zera `F3_VALICM` e `F3_BASEICM` e sobrescreve `F3_VALCONT`, `F3_ISENICM`, `F3_BSICMOR` |
| Gravação direta em `SF2` | L153-158 | Zera `F2_VALICM` e `F2_BASEICM` |
| `DbSeek` de `SF3` | L130 | Mesma chave frágil por CFOP + alíquota |
| `fAtuSf3()` | L385-401 | `UPDATE` forçando `F3_REPROC = 'N'` — **bloqueia o reprocessamento fiscal**, que pode ser necessário para recalcular IBS/CBS |
| `U_PrcXmlNfe()` | L306-316 | Dispara a geração do XML Mastersaf NFe — que **já tem IBS/CBS implementado** (`ProcMsaNFe.prw:4421+`) |
| Texto legal na `SZZ` | L347-352 | Mensagem de RCO referenciando o regime atual |

**Ação:** chamar `validRtcValues()` após `validValues()`; condicionar `F3_REPROC='N'` à ausência de divergência; espelhar em `F2D` qualquer gravação direta de base/valor.

### 3.3 `PrcNfRco.prw` — 470 linhas — **ALTO**

Geração da NF de Remessa por Conta e Ordem.

| Evidência | Linha | Constatação |
|---|---|---|
| `MsExecAuto({\|x,y,z\| mata920(x,y,z)}, aHeader, aItems, 3)` | L214 | Caminho de geração: **documento de saída manual (MATA920)** |
| `mountDetails()` | L313-336 | Array de item carrega apenas `D2_ITEM`, `D2_COD`, `D2_QUANT`, `D2_PRCVEN`, `D2_TOTAL`, `D2_TES`, `D2_NFORI`, `D2_SERIORI`, `D2_ITEMORI`. **Nenhum tributo é informado** — o Protheus calcula e depois é sobrescrito |
| `UPDATE` em `SF4.F4_BASEICM` | L300-311 | Altera o **percentual de redução de base da TES** (cadastro global) por nota processada, com `ZB_PREDBAS` do SAP |
| `getCstTes()` | L343-350 | CST de ICMS obtido de `F4_SITTRIB` (TES) — eixo que perde sentido para IBS/CBS sob CFGTRIB |
| `updPrd()` — `UPDATE` em `B1_PICMRET` | L355-376 | Altera o **MVA no cadastro de produto** (global) por item processado |
| `U_GRAVAFCP()` | L113 | Chama o gravador de FCP — padrão a replicar para IBS/CBS |
| `BEGIN TRANSACTION` **comentado** | L54-55, L125-132 | Toda a estrutura transacional está desativada desde 2018 ("Teste faturamento simultaneo"), com controle manual por `lBreak` + `DisarmTransaction()` |
| UI em fluxo transacional | L115-117, L304-305 | `MsgInfo`/`MsgAlert` — viola SonarQube CA1002 |
| `ConOut()` | L418-420 | Viola SonarQube CA1004 |

**Ação:** isolar as mutações de `SF4`/`SB1` atrás de `isRtcActive()` e logar toda alteração de cadastro em runtime; mapear o escopo transacional real antes de inserir gravações novas.

### 3.4 `PrcNfRet.prw` — 638 linhas — **ALTO**

Geração da NF de Retorno Simbólico. **Contém o molde exato do que precisa ser construído.**

| Evidência | Linha | Constatação |
|---|---|---|
| `MaPvlNFS(aPvlNfs, cSerie, ...)` | L358 | Caminho de geração **distinto** do RCO: faturamento de Pedido de Venda liberado (`SC5`/`SC6`/`SC9`) |
| `U_GravaFCP()` | L495-533 | **Molde direto:** grava um tributo recebido do SAP (`SZA`/`SZB`) dentro das tabelas fiscais |
| `GravaCab()` | L539-556 | Grava `F3_VFECPST`/`F3_VALFECP`/`F3_BSFCPST` em `SF3` a partir de `ZA_FCPTOTA` |
| `GravaItens()` | L559-631 | Grava em `SD2` (L582-583), `SFT` (L598-601) e `CD2` (L623-625) a partir de `ZB_FCPRATE`/`ZB_FCPBASE`/`ZB_FCPAMOU` |
| `prepRET()` | L125-235 | Valida amarração produto × cliente (`SA7`) e monta deliveries; chama `u_Ag2AltCli()` |
| `updMvaPrd()` | L410 | Atualização de MVA — atualmente **comentada** no chamador (L155-158) |

**Ação:** inserir a conciliação de IBS/CBS após o `U_GravaFCP`; se a decisão fiscal for "sobrescrever", criar `U_GravaIBSCBS()` espelhando `GravaCab()`/`GravaItens()` com destino `F2D`.

### 3.5 `Classes/DHLIp150.prw` — 1458 linhas — **MÉDIO**

Interface de cancelamento das NFs RCO e RET. Não mapeia tributo, mas controla o ciclo de vida do documento.

| Evidência | Linha | Constatação |
|---|---|---|
| `ExcluiRCO()` | L606-637 | `MSExecAuto(mata920, EXCLUSAO)` dentro de `begin transaction`. **Não verifica estorno de `F2D`** |
| `ExcluiRET()` | L648-681 | Chama `EstornaDocumento()` e depois `updateSalesOrder()` |
| `EstornaDocumento()` | L1372-1399 | `MaCanDelF2()` + `MaDelNFS()` com `PcoIniLan`/`PcoFinLan`. **Não verifica estorno de `F2D`** |
| `ValidExclusao()` | L766-826 | Validação de exclusão acionada pelos PEs — ponto para impedir cancelamento parcial que deixe `F2D` órfã |
| `updateSalesOrder()` | L827-879 | `MSExecAuto(MATA410, OPC_ALTERACAO)` — reverte o Pedido de Venda |
| `ChecStatusFIMP()` | L525-554 | Verifica status da NF-e antes de cancelar |
| `limpaCpsRCO()` | L1404-1455 | Limpa `ZA_NFRCO`/`ZA_SERIRCO` e `ZB_PEDIDO`/`ZB_ITEMPV` |

**Ação:** validar e, se necessário, complementar o estorno de `F2D` (`F2D_DTEXCL`) nos dois caminhos; incluir consistência de IBS/CBS em `ValidExclusao()`.

### 3.6 `PrcGrvRet.prw` — 180 linhas — **BAIXO**

Processamento final da NF RET. **Verificação de ausência:** nenhum campo de base, alíquota ou valor de tributo em todo o fonte.

| Evidência | Linha | Constatação |
|---|---|---|
| Validação de referência NF SCJ → NF RET | L41-63 | Query em `SZA` por `ZA_NFRET`/`ZA_SERIRET`; dispara e-mail se a chave divergir |
| Montagem da mensagem legal | L79-120 | Texto de Retorno Simbólico citando NF do depositante, RCO e dados do destinatário (`SA1`, `SYA`) |
| Gravação na `SZZ` | L125-127 | `oTMsg:grvMsg()` |
| `fEnvEmail()` | L154-187 | Notificação de referência incorreta via `DHLSndMail` |

**Ação:** aplicar o texto legal revisado pela área fiscal frente à LC 214/2025. Nenhuma alteração de tributo.

### 3.7 `SAPIP190.prw` — 249 linhas — **SEM IMPACTO DIRETO**

Geração do XML `IP_190` (ASN Confirmation) no retorno da confirmação de recebimento.

| Evidência | Linha | Constatação |
|---|---|---|
| Tags do XML gerado | L114-120 | `<ITEM>`, `<QUANTITY>`, `<UOM>`, `<LINE_ITEM>`, `<LOT>`. **Nenhuma tag fiscal** |
| Tags do cabeçalho | L101-104 | `<REFERENCE>`, `<PURCHASER>`, `<PLANT_ID>`, `<SALES_ORDER>`. **Nenhuma tag fiscal** |
| Query de dados | L181-245 | `SF1` + `SD1` + `SA1`/`SA2` + `SB1`. Campos: `F1_ZZNFVEN`, `F1_ZZSEVEN`, `B1_COD`, `D1_UM`, `D1_ITEM`, `SUM(D1_QUANT)`, `D1_ZZPOEXT`, `D1_ZZLOTE`. **Nenhum campo de imposto** |
| Acionamento | — | `WMS_Dlx_SCJ/Ag2ASNConf.prw:58` |

**Ação:** apenas validação de regressão — confirmar que o XML gerado permanece idêntico após as alterações no fluxo de NF.

## 4. Fontes Acoplados — Não Indicados, mas em Escopo Técnico

O fluxo não funciona sem eles. Dois são **críticos**.

| Fonte | Linhas | Impacto | Por quê |
|---|---|---|---|
| `SAPIP040.prw` | 1422 | **ALTO** | **Crítico.** Captação dinâmica por dicionário: L66-72 (SZA) e L136-144 (SZB) chamam `&("get" + SubStr(campo,4,7) + "()")` para **todos** os campos do `SX3`. Os getters de IBS/CBS **já estão implementados**: `getIBSUFTX/BS/VL` (L940-990), `getIBSMUTX/BS/VL` (L995-1045), `getCBSTXRT/BS/VL` (L1050-1099) e os totais `getIBSUFTO`/`getIBSMUTO`/`getIBSTOTA`/`getCBSTOTA` (L447-466). Listas de exclusão `CAMPOS_SZA`/`CAMPOS_SZB` (L4-5) **não bloqueiam** IBS/CBS. Também atualiza `ZA_F3QTLIN` (L102-112) |
| `SAPIP150.prw` | 49 | **MÉDIO** | Orquestra o cancelamento: `ChecStatusFIMP` → `SendCancellation` (L26-36). Documenta explicitamente "Processo para a Unidade de Negócio AG2(SCJ - PUZZLE)" (L8) |
| `MonIp040.prw` | 455 | **MÉDIO** | Monitor que dispara `u_PrcNfRco()` (L511-515) via `FWMsgRun`. Avaliar exibição do status de divergência de IBS/CBS |
| `updImpCD2.prw` | 252 | **MÉDIO** | Rotina de atualização de impostos em `CD2`. Avaliar se precisa equivalente para `F2D` |
| `Pontos_de_Entrada/FAT/M460FIM_pe.prw` | — | **MÉDIO** | L134 aciona `u_PrcGrvRet()` |
| `Pontos_de_Entrada/FIS/MT920TOK_PE.prw` | — | **BAIXO** | L17 instancia `DHLIp150` para validar exclusão em MATA920 |
| `Pontos_de_Entrada/FAT/MS520VLD_pe.prw` | — | **BAIXO** | L136 instancia `DHLIp150` para validar estorno em MATA520 |
| `SAP/DHLSAP.prw` | — | **BAIXO** | Roteador das interfaces: `U_SAPIP150` (L206) e `U_SAPIP040` (L217) |
| `WMS_Dlx_SCJ/Ag2ASNConf.prw` | — | **BAIXO** | L58 aciona `u_SAPIP190()` |

## 5. Fluxo de Ponta a Ponta e Pontos de Inserção

```
SAP ──XML IP_040──> DHLSAP.prw:217 ──> U_SAFX... não: U_SAPIP040
                                          │
                                          ├─ grava SZA (cabeçalho)  ← IBS/CBS JÁ CHEGA AQUI
                                          └─ grava SZB (itens)      ← IBS/CBS JÁ CHEGA AQUI
                                                 │
MonIp040.prw:511 ──> U_PrcNfRco()  ─────────────┤
                        │                        │
                        ├─ UPDATE SF4.F4_BASEICM (L300)   ⚠ muta cadastro global
                        ├─ UPDATE SB1.B1_PICMRET (L370)   ⚠ muta cadastro global
                        ├─ MsExecAuto(MATA920) (L214)     → CFGTRIB grava F2D
                        ├─ U_GRAVAFCP() (L113)            → molde p/ IBS/CBS
                        └─ U_PrcGrvRco()
                              ├─ validValues() (L54)      ✗ NÃO conhece F2D  ◄── INSERIR AQUI
                              ├─ RecLock SD2/SFT/CD2/SF3/SF2 (L77-158)
                              ├─ fAtuSf3() → F3_REPROC='N' (L389)  ⚠ bloqueia reprocesso
                              └─ U_PrcXmlNfe() (L310)     → Mastersaf NFe (já tem IBS/CBS)

                     U_PrcNfRet()
                        ├─ MaPvlNFS() (L358)              → CFGTRIB grava F2D
                        └─ PE M460FIM:134 ──> U_PrcGrvRet()  (só mensagem SZZ)

SAP ──XML IP_150──> DHLSAP.prw:206 ──> U_SAPIP150
                                          └─ DHLIp150:ExcluiRCO()/ExcluiRET()
                                                 ✗ não valida estorno de F2D  ◄── INSERIR AQUI

WMS ──> Ag2ASNConf.prw:58 ──> U_SAPIP190()   (sem campo fiscal)
```

**Dois pontos de inserção**, não mais:
1. `PrcGrvRco.prw:54` (e equivalente no caminho RET) — conciliação de IBS/CBS após `validValues()`.
2. `DHLIp150.prw:606` e `:648` — garantia de estorno de `F2D` no cancelamento.

## 6. O Que Já Funciona — e Não Deve Ser Mexido

Mapeado para evitar retrabalho e alteração desnecessária em código de produção.

| Mecanismo | Localização | Por que já funciona |
|---|---|---|
| Captação SAP → `SZA`/`SZB` | `SAPIP040.prw:66-72` e `:136-144` | Percorre o `SX3` e resolve a função `get` por convenção de nome. Campos de IBS/CBS são populados **sem alterar código** |
| Getters de IBS/CBS | `SAPIP040.prw:447-466` e `:940-1099` | Já implementados, com guarda `Type(...) <> "U"` — toleram ausência da tag no XML |
| Aglutinação por documento | `DHLIp040Sap.prw:1110-1151` | `retCposSZB()`/`retCposSf3()` montam os `SUM()` varrendo campos numéricos do `SX3`. IBS/CBS entra automaticamente |
| Mapeamento semântico IBS/CBS | `Mastersaf_NFe/ProcMsaNFe.prw:4421+` | `DoIBSCBS`, `DogIBSCBS`, `DogIBSUF`, `DogIBSUFDif` — CST, cClassTrib, `vBC`, `vIBS`, `pIBSUF`, `vIBSUF`, `pDif`, `vDif` |
| Leitura de `F2D` | `Controle_de_ID_Good-Bad/DHLIdManager.prw:261-341` | Subqueries por tributo com `F2D_IDREL = D1_IDTRIB`/`D2_IDTRIB`, `F2D_TABELA`, `F2D_TRIB`, `%F2D.NOTDEL%` |
| Parâmetro de corte RTC | `ProcMsaNFe.prw:30`, `ProcRCOMsa.prw:31` | `SuperGetMv('MV_RTC55',.f.,stod('20260105'))` já em uso em duas interfaces |
| Parâmetros de sigla de tributo | `DHLIdManager.prw:261-263` | `ZZ_TRIBCBS` (TR0001), `ZZ_TRIBSUF` (TR0002), `ZZ_TRIBSMU` (TR0003) |

## 7. Riscos Pré-Existentes que a Reforma Agrava

Problemas que **já existem** no código, independentes da Reforma, e que a adequação tende a expor.

| Risco | Evidência | Por que a Reforma agrava |
|---|---|---|
| Mutação de cadastro global em runtime | `PrcNfRco.prw:300-311` (`SF4.F4_BASEICM`) e `:355-376` (`B1_PICMRET`) | Mais regras por documento → maior janela de concorrência em faturamento simultâneo |
| Transação desativada | `PrcNfRco.prw:54-55` e `L125-132` — `BEGIN TRANSACTION` comentado desde 2018 | Novas gravações em `F2D` sem transação podem gerar estado parcial |
| Chave de `SF3` por CFOP + alíquota | `DHLIp040Sap.prw:419`, `PrcGrvRco.prw:130` | Escrituração dos tributos novos pode alterar o desmembramento de `SF3` e quebrar a conciliação de ICMS que hoje funciona |
| Validação por quantidade de linhas de `SF3` | `DHLIp040Sap.prw:556-569` + `ZA_F3QTLIN` (`SAPIP040.prw:102-112`) | Mesmo motivo acima — a contagem esperada deixa de bater |
| Acoplamento por nome de função | `nfesefaz.prw:3026` e `:3488` usam `IsInCallStack("U_PrcGrvRco")`/`("U_PrcNfRco")` | **Nenhuma função do fluxo pode ser renomeada** durante a refatoração |
| Acoplamento por nome de campo | `SAPIP040.prw:66-72` e `:136-144` (macro dinâmica) | **Campo novo em `SZA`/`SZB` sem a função `get` correspondente derruba a importação em produção**, sem erro de compilação |
| UI dentro de fluxo transacional | `PrcNfRco.prw:115-117` e `:304-305`; `DHLIp040Sap.prw:655` (`Aviso()`) | Mais divergências a reportar → mais chance de travar o processamento multiusuário |

## 8. Ordem de Ataque Recomendada

1. **Confirmar o dicionário** — campos de IBS/CBS em `SZA`/`SZB` existem e estão em uso, com os getters correspondentes. É pré-requisito absoluto (ver risco de acoplamento por nome de campo).
2. **Decisão fiscal** — bloquear × sobrescrever `F2D` × aceitar-e-logar. Define a arquitetura de toda a implementação.
3. **Componente de acesso a `F2D`** (`DHLSapRtc`) — resolve o problema de que `F2D` não é posicionável pelo mecanismo atual.
4. **Caminho RCO** (`PrcGrvRco.prw:54`) — valida o desenho no fluxo de maior volume.
5. **Caminho RET** (`PrcNfRet.prw` / `U_GravaFCP`) — segundo motor fiscal (`MaPvlNFS`), exige validação própria.
6. **Cancelamento** (`DHLIp150.prw`) — estorno de `F2D`.
7. **Parametrização** (`SZD` e `SZC`) — como script de carga versionado, não cadastro manual.
8. **Texto legal** (`PrcGrvRet.prw`, mensagem RCO em `PrcGrvRco.prw:347-352`) — depende da área fiscal, pode correr em paralelo.

> **Compartilhamento com o outro plano:** a unidade AG2 aparece nos dois planos (aqui e em `impacto-fontes-mastersaf-dw-safx07-1.md`). O componente de leitura de `F2D` deve ser **um só**, compartilhado entre a interface SAP e a Mastersaf DW — projetar `DHLSapRtc` e `DHLSafxRtc` sobre a mesma base de acesso evita duas implementações divergentes do mesmo join.
