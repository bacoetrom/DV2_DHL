# Dicionário de Dados — RTC 2026/2027 (Lotes 1 a 4)

| Item | Valor |
|---|---|
| Projeto | SC Johnson / DHL — NF-e 2027 (IBS, CBS, IS) |
| Data | 22/11/2026 |
| Responsável | Wellington Santana |
| Documentos relacionados | `Diagnostico_RTC_Lote1_Cadastros.md`, `Diagnostico_RTC_Lotes2a4_Integracao.md` |

---

## 1. Conclusão

**Nenhuma tabela nova é necessária.** Os ajustes dos Lotes 1 a 4 usam apenas tabelas que já existem e estão em uso na produção.

---

## 2. Tabelas utilizadas

| Tabela | Uso | Situação |
|---|---|---|
| SZA / SZB | Cabeçalho e itens do IP_040 | Já existem. A SZB já tem os campos de IBS/CBS (`ZB_IBSUFTX/BS/VL`, `ZB_IBSMUTX/BS/VL`, `ZB_CBSTXRT/BS/VL`) |
| SZC | Regras fiscais (CadRegFis) | Já existe |
| SZD | De/para de campos fiscais (CadDePara) | Já existe |
| SF1, SF2, SD1, SD2, SFT, SF3, CD2, SF4 | Tabelas padrão TOTVS | `F1_TPCOMPL`/`F2_TPCOMPL` são campos padrão. `D1_ZZUTRIB`/`D1_ZZQTRIB` já eram usados antes dos ajustes |

---

## 3. Campos opcionais na SZC

Só são necessários se forem cadastradas regras de TES para **nota de crédito (finNFe 5) ou débito (finNFe 6)**. O código verifica se os campos existem (`FieldPos` no CadRegFis, `GetSx3Cache` no DHLIp040Sap). Sem eles, o CadRegFis e a busca de TES do IP_040 funcionam como antes.

| Campo | Tipo | Tamanho | Conteúdo |
|---|---|---|---|
| `ZC_FINNFE` | C | 1 | Combo `1=Normal;2=Complementar;3=Ajuste;4=Devolução;5=Crédito;6=Débito` |
| `ZC_TPCOMPL` | C | Igual ao `F2_TPCOMPL` | Subtipo de crédito/débito (mesma convenção do `F2_TPCOMPL`/`F1_TPCOMPL`) |

> ⚠️ **Ordem obrigatória:** criar esses campos **somente depois** de compilar o `DHLIp040Sap.prw` do Lote 2. É ele que filtra `ZC_FINNFE IN (' ','1')` no `fQryTes` e impede a NF RCO de receber a TES de uma regra de crédito ou débito com os mesmos indicadores de ICMS.

---

## 4. Parâmetros (SX6)

Todos têm valor padrão no código, então **nenhum é obrigatório**.

| Parâmetro | Tipo | Padrão no código | Fonte | Finalidade |
|---|---|---|---|---|
| `ZZ_TRIBICM` | C | `ICMS` | ProcRCOMsa | Código do tributo do grupo `ICMSPrevistoPagtoAntecip` (débito 06) |
| `ZZ_TRIBIS` | C | `IS` | ProcRCOMsa | Código do tributo do Imposto Seletivo |
| `ZZ_FINAJUS` | C | `AG2` | ProcRCOMsa | Unidades que podem emitir nota de ajuste (finNFe 3) |
| `ZZ_RTCAUDI` | L | `.T.` | DHLRtcTagAudit | Liga a auditoria de tags da reforma no log |
| `ZZ_RTCVLCF` | L | `.T.` | CadRegFis | Liga a validação CFOP × subtipo |
| `ZZ_UPDCD2U` | C | `AG2` | MT103FIM | Unidades que executam o updImpCD2 |
| `ZZ_UPDCD2C` | C | vazio | MT103FIM | Subtipos de nota de crédito que executam o updImpCD2 (ex.: `3\|6`) |
| `ZZ_RTCCONF` | L | `.T.` | PrcGrvRco | Liga a conferência IBS/CBS SAP × Protheus na NF RCO (23/11/2026) |
| `ZZ_TRIBSUF` / `ZZ_TRIBSMU` / `ZZ_TRIBCBS` | C | `TR0002` / `TR0003` / `TR0001` | PrcGrvRco, DHLIdManager | Códigos de IBS UF, IBS municipal e CBS na F2D. Já usados pelo DHLIdManager. Conferir se batem com o cadastro de tributos do ambiente |

> ⚠️ **Atenção ao `ZZ_TRIBICM`:** o padrão antigo no código era `ICM`, e com ele o grupo `ICMSPrevistoPagtoAntecip` nunca era preenchido. Se o parâmetro **já existir** no SX6 com `ICM`, trocar para `ICMS`.

---

## 5. Checklist

- [ ] Compilar o pacote (ver `Diagnostico_RTC_Lotes2a4_Integracao.md`, seção 5.1)
- [ ] Conferir se `ZZ_TRIBICM` existe no SX6; se estiver como `ICM`, trocar para `ICMS`
- [ ] (Opcional, após compilar o DHLIp040Sap) Criar `ZC_FINNFE` e `ZC_TPCOMPL` na SZC
- [ ] (Opcional) Criar os demais parâmetros só se o valor padrão precisar ser alterado
