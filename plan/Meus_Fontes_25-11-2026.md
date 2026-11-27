# Meus Fontes — Situação frente às exigências de IBS/CBS 2026/2027 (25/11/2026)

| Item | Valor |
|---|---|
| Projeto | SC Johnson / DHL — NF-e 2027 (IBS, CBS, IS) |
| Unidade de negócio | AG2 (SC Johnson) |
| Data | 25/11/2026 |
| Responsável | Wellington Santana |
| Base do projeto | NT 2025.002-RTC v1.53; NT 2026.008 v1.01; LC 214/2025; Ajuste SINIEF 49/2025 |
| Documentos relacionados | `Ajustes_Finais_RTC_SCJ_AG2.md`, `Detalhe_Fontes_SCJ_AG2.md`, `Inventario_Tags_NFe_2027.md` |

> **Observação:** a NT 2026.010 (DANFE), a NT 2026.004 (NFCom), a NT 011/2026 (EFD-Contribuições) e o Decreto 13.075/2026 foram considerados conforme as informações recebidas, mas não foram conferidos na fonte oficial.

> **Situação:** nenhum fonte ajustado foi compilado ainda.

---

## 1. O que as regras novas exigem dos fontes

| Regra | Impacto nos fontes |
|---|---|
| **2026:** campos de IBS/CBS obrigatórios para o regime regular (0,9% CBS e 0,1% IBS, alíquota de teste) | A nota precisa ter os grupos `IBSCBS` e os totais |
| **2027:** CBS cobrada de verdade, no lugar do PIS/COFINS | Um erro no valor da CBS passa a ter **custo real**. A conferência SAP × Protheus ganha importância |
| **2027:** IBS de 0,1% dividido entre estado e município | O **IBS municipal deixa de ser zero**. O erro do SAP no rodapé (`IBS_MUN_TOTAL_VALUE`) passa a ter efeito |
| **NT 2026.008:** IBS, CBS e IS **fora do `vProd`**, somados à parte no `vItem` e no `vNFTot` | O `vProd`/`vNF` não pode incluir IBS/CBS, e o `vItem`/`vNFTot` precisa vir com a nova composição |
| **NT 2026.010:** novo DANFE (teste a partir de 01/12/2026) | Não é dos meus fontes. Quem gera o DANFE é o Mastersaf/TSS |
| **NT 2026.004 (NFCom) e NT 011/2026 (EFD-Contribuições)** | Não se aplicam: os meus fontes tratam NF-e modelo 55 e não geram SPED |

---

## 2. ✅ Prontos

| Fonte | Por que está pronto |
|---|---|
| `SAP/SCJ/SAPIP040.prw` | Lê IBS UF, IBS municipal e CBS por item. Os totais da SZA vêm da soma dos itens, então o erro do rodapé do SAP não afeta, inclusive em 2027 com IBS municipal maior que zero. A alíquota é calculada quando o SAP manda `TAX_RATE` vazio, e o tamanho do campo (5,2) comporta 0,05%, 0,10%, 0,90% e a CBS cheia |
| `SAP/SCJ/Classes/DHLIp040Sap.prw` | Não mexe no IBS/CBS da nota. A NF RCO não pega TES de regra de crédito ou débito |
| `SAP/SCJ/PrcGrvRco.prw` | A conferência SAP × Protheus (`confIbsCbs`) avisa no log quando o IBS/CBS calculado pela TOTVS diverge do SAP. É **essencial em 2027**, com a CBS cobrada |
| `SAP/ProcRCOMsa.prw` (IP140) | Os grupos de IBS/CBS, IS e totais estão montados. Atende à NT 2026.008: o `vProd` é a soma do `vProd` dos itens do XML (sem IBS/CBS), e o `vItem` e o `vNFTot` são lidos do XML. **Depende do nfesefaz** gerar essas tags corretamente |
| `SAP/SCJ/updImpCD2.prw` | Trata FCP e unidade tributável. O IBS/CBS da devolução vem do motor da TOTVS, pela nota original |

Fora da lista, mas pronto: `Pontos_de_Entrada/COM/MT103FIM_pe.prw` (chama o `updImpCD2` também na nota de crédito, conforme `ZZ_UPDCD2C`).

---

## 3. ⚠️ Prontos com ressalva

| Fonte | Ressalva | Ação |
|---|---|---|
| `SAP/SCJ/Cadastro de Regras Fiscais/CadRegFis.prw` | A lista de CFOP por subtipo (`cfopEsperado`) precisa ser **validada pelo fiscal** | Validar. Até lá, `ZZ_RTCVLCF = .F.` |
| `SAP/SCJ/Cadastro de Para CPOS Fiscal/CadDePara.prw` | Ainda permite de/para de IBS/CBS para SD2, SFT, SB1, SF3 e SF2. Em 2027, isso poderia **sobrescrever a CBS real** calculada pela TOTVS | Recomendado: bloquear IBS/CBS para qualquer destino |
| `SAP/SCJ/PrcNfRco.prw` | O IBS/CBS da NF RCO vem da TES | Conferir se a TES da RCO tem o cClassTrib correto para 2027 |
| `SAP/SCJ/PrcNfRet.prw` | O IBS/CBS do retorno simbólico vem da TES do pedido (`C6_TES`) | Conferir a TES e o cClassTrib do retorno (não incidência) para 2027 |

---

## 4. ❌ Não prontos

| Fonte | Problema | Gravidade em 2027 |
|---|---|---|
| `SAP/ProcRSymbMsa.prw` (IP050) — **meu fonte** | **Não leva IBS, CBS nem IS ao SAP**. Faltam os grupos `IBSCBS`, `IS`, `IBSCBSTot` e o `cMunFGIBS` | **Alta.** Com a CBS cobrada, o SAP fica sem a CBS do retorno simbólico. Depende de o SAP confirmar o layout do IP050 (decisão 4). O código pode ser copiado do `ProcRCOMsa` |
| `Mastersaf_NFe/ProcMsaNFe.prw` — **fora da lista**, nota enviada à SEFAZ | Subtipo de crédito/débito com 1 dígito; 21 totais de IBS/CBS zerados saindo vazios, **incluindo o `vNFTot`** (linha 5304); débito 06 nunca preenchido (`ZZ_TRIBICM` = "ICM"); `indPres` fixo | **Rejeição na SEFAZ** |
| `Mastersaf_NFe/nfesefaz.prw` — **fora da lista**, padrão TOTVS customizado | Precisa gerar o `vItem` e o `vNFTot` com a **nova composição da NT 2026.008**, além de `vProdLiq`, `vUnComLiq`, `vProdLiqTot`, `IS`, `gAjusteCompet` e `gEstornoCred` | **Rejeição na SEFAZ.** Quem ajustou pela versão anterior da NT precisa revisar |

---

## 5. ➖ Não se aplica (não tratam imposto)

| Fonte | Função |
|---|---|
| `SAP/SCJ/SAPIP150.prw`, `SAP/SCJ/Classes/DHLIp150.prw` | Cancelamento pedido pelo SAP (IP150) |
| `SAP/SCJ/SAPIP160.prw` | Confirmação do cancelamento ao SAP (IP160) |
| `SAP/SCJ/SAPIP190.prw` | Confirmação de recebimento (IP190): só item, quantidade, unidade, linha e lote |
| `SAP/SCJ/PrcGrvRet.prw` | Mensagem complementar do retorno simbólico e alerta por e-mail |
| `Pontos_de_Entrada/FAT/M460FIM_pe.prw` | Fim do faturamento: só chama outras rotinas |
| `Mastersaf_NFe/PrcXmlNfe.prw`, `SAP/PrcRCOXml.prw`, `SAP/PrcXmlRSymb.prw` | Repassam o XML do nfesefaz |
| `SAP/MsafRCOFile.prw`, `SAP/MsafRSymbFile.prw` | Gravam o arquivo com o que foi montado |

Se o XML vier certo do nfesefaz, esses fontes levam certo.

---

## 6. Resumo

| Situação | Quantidade (dos 21 fontes) | Fontes |
|---|---|---|
| ✅ Prontos | 5 | SAPIP040, DHLIp040Sap, PrcGrvRco, ProcRCOMsa, updImpCD2 |
| ⚠️ Com ressalva | 4 | CadRegFis, CadDePara, PrcNfRco, PrcNfRet |
| ❌ Não pronto | 1 | ProcRSymbMsa |
| ➖ Não se aplica | 11 | SAPIP150, DHLIp150, SAPIP160, SAPIP190, PrcGrvRet, M460FIM_pe, PrcXmlNfe, PrcRCOXml, PrcXmlRSymb, MsafRCOFile, MsafRSymbFile |

**Dos meus 21 fontes, o único que não está pronto é o `ProcRSymbMsa`, e ele depende do SAP.** O maior risco está **fora da lista**: o `ProcMsaNFe` e o `nfesefaz`, que geram a nota enviada à SEFAZ.
