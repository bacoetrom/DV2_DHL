# Ajustes RTC 2026/2027 (IBS, CBS e IS) nos fontes da NF RCO e do retorno simbólico — SC Johnson / AG2

| Item | Valor |
|---|---|
| Projeto | SC Johnson / DHL — NF-e 2027 (IBS, CBS, IS) |
| Unidade de negócio | AG2 (SC Johnson) |
| Data | 27/11/2026 |
| Responsável | Wellington Santana |
| Fontes | `SAP/SCJ/PrcGrvRco.prw`, `SAP/SCJ/PrcNfRco.prw`, `SAP/SCJ/PrcNfRet.prw` |
| Base | Campos de IBS/CBS da SZA e SZB (SX3 enviado em 27/11/2026) |
| Documentos relacionados | `Ajustes_Finais_RTC_SCJ_AG2.md`, `Analise_IBS_CBS_IP040_PrcGrvRco.md`, `upgrade-sap-scj-ip040-ibs-cbs-1.md`, `Dicionario_RTC_Lotes1a4.md` |
| Backup dos originais | `backup_rtc_ibscbsis_20261127/` |

> **Situação:** fontes ajustados e **não compilados**. Todas as conferências só registram aviso no log (`FWLogMsg`). Nenhuma delas bloqueia, altera a nota ou sobrescreve a F2D.

---

## 1. Decisão mantida

Os valores de IBS/CBS enviados pelo SAP **não sobrescrevem a F2D** (tabela onde o motor de tributos grava os tributos calculados). O XML transmitido usa base, alíquota e totais do motor de tributos; trocar só o valor geraria nota inconsistente. Os fontes **conferem** o SAP com o Protheus e registram as diferenças no log.

---

## 2. O que foi ajustado

### 2.1 PrcGrvRco.prw — conferência da NF RCO com o SAP

A função `confIbsCbs` já existia (23/11/2026) e conferia só o valor por item. Passou a conferir:

| Conferência | Campos do SAP | Comparado com |
|---|---|---|
| Valor por item | `ZB_IBSUFVL`, `ZB_IBSMUVL`, `ZB_CBSTXVL` | `F2D_VALOR`. Na divergência, o log traz também base e alíquota dos dois lados |
| Base por item (quando o valor bate) | `ZB_IBSUFBS`, `ZB_IBSMUBS`, `ZB_CBSTXBS` | `F2D_BASE`. Aponta o caso do ICMS desonerado, que regrava o item depois do cálculo |
| Alíquota | `ZB_IBSUFTX`, `ZB_IBSMUTX`, `ZB_CBSTXRT` | `F2D_ALIQ`, só no log da divergência de valor (o SAP manda alíquota efetiva; a F2D pode ter a cheia) |
| Item sem cálculo | Valor de IBS/CBS > 0 no SAP | Item sem nenhum registro de IBS/CBS na F2D |
| IS | Sem campo no IP_040 (SAP = 0) | IS calculado pelo Protheus (`ZZ_TRIBSIS`) |
| Totais da nota | `ZA_IBSUFTO`, `ZA_IBSMUTO`, `ZA_CBSTOTA`, `ZA_IBSTOTA` | Soma da F2D (IBS total = UF + Mun) |

Nova função **`U_RtcF2DNf`** (no mesmo fonte): lê na F2D, por item da nota de saída, o IBS UF, o IBS Mun, a CBS e o IS, com base e alíquota. Também é usada pelo PrcNfRet.
- Consulta com `FWExecStatement` (valores passados como parâmetros, sem concatenação).
- Ignora tributo excluído (`F2D_DTEXCL` preenchido), como o padrão (FISA175 / tciclass).
- Base e alíquota só são lidas se `F2D_BASE` e `F2D_ALIQ` existirem no dicionário (confirmados nos fontes padrão r2510).

Tolerância: 0,01 por item; nos totais, 0,01 × quantidade de itens.

### 2.2 PrcNfRco.prw — checagem antes de gerar a NF RCO

Nova função `vldRtcSzb`, chamada em `prepRCO` depois das validações e antes do `MATA920`:
- compara os totais da SZA (`ZA_IBSUFTO`, `ZA_IBSMUTO`, `ZA_CBSTOTA`, `ZA_IBSTOTA`) com a soma dos itens da SZB;
- avisa sobre item com valor de IBS/CBS e base zerada;
- registra no log (INFO) quando o SAP não mandou IBS/CBS em nenhum item.

### 2.3 PrcNfRet.prw — auditoria do retorno simbólico

Nova função `audRtcRet`, chamada depois do `U_GRAVAFCP` do retorno simbólico:
- registra no log (INFO) o IBS UF, IBS Mun, CBS e IS da nota, conforme a F2D;
- avisa (WARN) quando algum item ou a nota toda não tem IBS/CBS calculado. Nesse caso a nota pode sair sem o grupo IBSCBS no XML;
- **não compara com o SAP**: o IP_040 traz os valores da venda, não do retorno.

Executa só se a `U_RtcF2DNf` estiver compilada (`FindFunction`); sem ela, pula a auditoria sem erro.

### 2.4 Correções de padrão (SonarQube) nos mesmos fontes

| Fonte | Correção |
|---|---|
| Os três | `#include "protheus.ch"` trocado por `#include "totvs.ch"` |
| PrcGrvRco | Variável `lReturn` (retorno do `U_PrcXmlNfe`) declarada como `Local` |
| PrcNfRco | `setNewNumSX5`: `conout` trocado por `FWLogMsg` (CA1004); `Alert` trocado por `MsgAlert` + log |
| PrcNfRet | `GravaItens`: `Iif` do FCP trocado por `If/Else` (CA4000) |

Essas correções não mudam o comportamento.

### 2.5 Quando as conferências rodam

Todas as três exigem:
- `ZZ_RTCCONF = .T.` (padrão);
- `dDataBase >= MV_RTC55` (início da reforma);
- tabela F2D e campo `D2_IDTRIB` no dicionário.

---

## 3. Conferência do que foi atendido

| Campo / tributo | Situação |
|---|---|
| `ZB_IBSUF*`, `ZB_IBSMU*`, `ZB_CBS*` (valor, base, alíquota) | ✅ Conferidos com a F2D (PrcGrvRco); valor e base também checados antes da nota (PrcNfRco) |
| `ZA_IBSUFTO`, `ZA_IBSMUTO`, `ZA_IBSTOTA`, `ZA_CBSTOTA` | ✅ Comparados com a soma dos itens (PrcNfRco) e com a F2D (PrcGrvRco) |
| IS | ⚠️ Não vem do SAP: não há campo de IS na SZA/SZB. Só o IS calculado pelo Protheus é conferido, via `ZZ_TRIBSIS` |
| Retorno simbólico | ✅ Auditado na F2D. Os valores da SZB não se aplicam a ele |

---

## 4. Parâmetros (SX6)

| Parâmetro | Tipo | Padrão no código | Situação |
|---|---|---|---|
| `ZZ_TRIBSIS` | C | vazio | **Novo.** Código do tributo IS na F2D. Vazio = conferência de IS desligada |
| `ZZ_TRIBSUF` / `ZZ_TRIBSMU` / `ZZ_TRIBCBS` | C | `TR0002` / `TR0003` / `TR0001` | Já existiam. Agora usados também pelo PrcNfRet |
| `ZZ_RTCCONF` | L | `.T.` | Já existia. Agora liga também o PrcNfRco e o PrcNfRet |
| `MV_RTC55` | D | 05/01/2026 | Já existia |

Nenhum campo novo de dicionário foi criado.

---

## 5. O que falta

| # | Pendência | Responsável | Observação |
|---|---|---|---|
| 1 | **Compilar** os três fontes | Desenvolvimento | Compilar o `PrcGrvRco.prw` antes do `PrcNfRet.prw` (contém a `U_RtcF2DNf`) |
| 2 | **Conferir no SX6** `ZZ_TRIBSUF`, `ZZ_TRIBSMU` e `ZZ_TRIBCBS` contra o cadastro de tributos do ambiente | Fiscal / Desenvolvimento | Se não baterem, todos os itens aparecem como divergentes no log |
| 3 | **Cadastrar `ZZ_TRIBSIS`** quando o IS for configurado no motor de tributos | Fiscal | Enquanto estiver vazio, o IS não é conferido |
| 4 | **Definir com o SAP o envio do IS no IP_040** e criar os campos de IS na SZA/SZB | SAP / Fiscal | Mesma pendência da decisão 3 do `Ajustes_Finais_RTC_SCJ_AG2.md`. Sem isso, o IS do SAP não pode ser usado |
| 5 | **Testar em homologação**: NF RCO com e sem ICMS desonerado e retorno simbólico, depois de `MV_RTC55` | Desenvolvimento / Fiscal | Conferir no log as mensagens da seção 6 |
| 6 | **Confirmar a TES e o cClassTrib do retorno simbólico** | Fiscal | Se o `audRtcRet` avisar falta de IBS/CBS na F2D, a nota pode sair sem o grupo IBSCBS |

---

## 6. Mensagens no log

| Fonte | Mensagem (início) | Significado |
|---|---|---|
| PrcGrvRco | `[RTC-2026/2027] NF RCO ...: item ...: IBS UF/IBS Mun/CBS SAP = ... / Protheus = ...` | Valor do SAP diferente do calculado pelo Protheus |
| PrcGrvRco | `... base de ... SAP = ... / Protheus = ...` | Valor confere, base não (ex.: ICMS desonerado) |
| PrcGrvRco | `... sem registro de IBS/CBS na F2D` | O motor de tributos não calculou IBS/CBS no item |
| PrcGrvRco | `IS calculado pelo Protheus = ...` | Protheus calculou IS e o IP_040 não tem IS |
| PrcGrvRco | `total IBS UF (ZA_IBSUFTO) SAP = ...` | Total da SZA diferente da soma da F2D |
| PrcNfRco | `[RTC-2026/2027] IP_040 NF SCJ ...: total ... diferente da soma dos itens da SZB` | SZA/SZB alterada depois da importação |
| PrcNfRco | `... com ZB_..VL = ... e ZB_..BS zerada` | Dado incompleto vindo do SAP |
| PrcNfRet | `[RTC-2026/2027] NF retorno simbolico ...: nenhum item com IBS/CBS na F2D` | Revisar TES do pedido e cClassTrib do retorno |
| PrcNfRet | `... IBS UF = ..., IBS Mun = ..., CBS = ..., IS = ...` | Registro informativo dos valores do retorno |
