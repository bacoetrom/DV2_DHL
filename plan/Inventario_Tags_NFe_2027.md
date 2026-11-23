# Inventário de tags: NF-e 2027 (Fase 0, item 1)

> ⚠️ **Correções de 22/11/2026.**
> 1. **`DFeReferenciado` e `chaveAcesso` NÃO estão ausentes.** O `nfesefaz.prw:10230` chama `GetTagRef(aNota)`, que emite o grupo lendo a tabela DKN (linhas 14662-14684). A limitação é outra: o `while` que varre múltiplas referências está comentado, então sai no máximo 1 chave, igual para todos os itens.
> 2. **O escopo real são 7 tipos, não 11 cenários.** Pelo FDD IM04, confirmado pela planilha `TAGS reforma tribitaria + demais.xlsx`: crédito **01, 03, 04** e débito **02, 03, 04, 06**. Crédito 06 e débito 07 saem; crédito 01 e débito 02 entram e **não têm exemplo** no `HTMLConsolidado.xml`.
> 3. **`vUnComLiq`, `vProdLiq` e `vProdLiqTot` têm posição confirmada** no leiaute 4.19 — ver `Leiaute_Mastersaf_4_19.md`.


- **Data:** 18/11/2026
- **Origem:** `plan/HTMLConsolidado.xml` (11 cenários, NT 2025.002 v1.53 e NT 2026.008 v1.01)
- **Cruzado com:** `PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw` e `PROTHEUS/Producao/SAP/ProcRCOMsa.prw`
- **Gerado por:** `scratchpad/inventario_tags.py` (reprodutível)

Este documento entrega a **lista de tags confirmadas × ausentes** exigida pela Fase 0, item 1, e serve de entrada para a rotina de auditoria e para a matriz de testes da Fase 7.

---

## 1. Cenários identificados

| # | Cenário | finNFe | tpNF | Tags distintas |
|---|---|---|---|---|
| 1 | VENDA | 1 | 1 | 127 |
| 2 | NOTA DÉBITO 06 (pagamento antecipado) | 6 | 1 | 115 |
| 3 | NOTA CRÉDITO 04 (redução de valor) | 5 | 0 | 119 |
| 4 | DEVOLUÇÃO | 4 | 1 | 123 |
| 5 | COMPLEMENTAR | 2 | 1 | 122 |
| 6 | AJUSTE | 3 | 1 | 122 |
| 7 | NOTA CRÉDITO 03 (retorno por recusa total) | 5 | 0 | 126 |
| 8 | NOTA CRÉDITO 06 (recusa parcial) | 5 | 0 | 127 |
| 9 | NOTA DÉBITO 04 (multa e juros) | 6 | 1 | 115 |
| 10 | NOTA DÉBITO 03 (nota não processada) | 6 | 1 | 102 |
| 11 | NOTA DÉBITO 07 (perda em estoque) | 6 | 1 | 105 |

---

## 2. Tags da reforma ausentes nos fontes — escopo de customização

| Tag | Cenários que exigem | É grupo? | Fase |
|---|---|---|---|
| `vUnComLiq` | **todos os 11** | não | 2 |
| `vProdLiq` | **todos os 11** | não | 2 |
| `vProdLiqTot` | **todos os 11** | não | 2 |
| `DFeReferenciado` | 4, 8, 9, 10, 11 | sim | 1 |
| `chaveAcesso` | 4, 8, 9, 10, 11 | não | 1 |
| `IS` | 1, 7, 8 | sim | 2 |
| `ISTot` | 1, 7, 8 | sim | 2 |
| `ICMSPrevistoPagtoAntecip` | 2 | sim | 2 |
| `vICMSPrevisto` | 2 | não | 2 |
| `gAjusteCompet` | 10 | sim | 2 |
| `gEstornoCred` | 11 | sim | 2 |

**Total: 11 tags ausentes.**

Prioridade decorrente: `vUnComLiq`, `vProdLiq` e `vProdLiqTot` são exigidas em **todos** os cenários, inclusive na venda normal. São o primeiro item de desenvolvimento das Fases 1-2 assim que o leiaute do TXT estiver disponível.

---

## 3. Tags da reforma já tratadas nos fontes

| Tag | Cenários |
|---|---|
| `IBSCBS` | todos |
| `IBSCBSTot` | todos |
| `cClassTrib` | todos |
| `vItem` | todos |
| `vNFTot` | todos |
| `gIBSCBS`, `gIBSUF`, `gIBSMun`, `gCBS` | 1 a 9 |
| `vCredPres`, `vCredPresCondSus` | 1 a 9 |
| `tpNFCredito` | 3, 7, 8 |
| `tpNFDebito` | 2, 9, 10, 11 |

---

## 4. Ressalvas do método — leia antes de usar as tabelas acima

O cruzamento é **estático**: procura o nome da tag como literal em `newMsafNFeTag("...")` e `setAttributeValue("...")`. Isso gera dois tipos de distorção, ambos verificados manualmente:

1. **"Já tratada" não significa "preenchida".** `tpNFDebito`, `tpNFCredito` e `cMunFGIBS` aparecem como tratadas porque o atributo existe no TXT, mas são gravados com `EMPTY_VALUE` fixo (`ProcMsaNFe.prw`, linhas 213, 219 e 220). Continuam sendo escopo da Fase 1, item 2, como o plano já registra.
2. **O nome da tag no TXT difere do nome no XML nos grupos de total.** O XML usa `gIBS`, `gIBSUF` e `gIBSMun` dentro do `IBSCBSTot`; o fonte grava `gIBS_Tot`, `gIBSUF_Tot` e `gIBSMun_Tot` (linhas 4963, 4976 e 4993). Não é defeito — é o nome esperado pelo Mastersaf. Por isso `gIBS` apareceu como ausente na geração automática e foi removido da tabela da seção 2.

Duas tags do escopo do plano **não aparecem em nenhum dos 11 exemplos** e portanto não podem ser validadas por este inventário:

- **`cMunFGIBS`** — no cenário 1 está explicitamente comentado no XML ("só com indPres=5 e sem endereço do destinatário/entrega");
- **`gPagAntecipado`** — nenhum dos exemplos o traz, embora a Fase 1, item 5, o exija para a nota que abate um débito 06.

Ambas permanecem no escopo, com a observação de que exigem massa de teste própria, fora dos 11 cenários.

---

## 5. Observações sobre supressão de grupos

O inventário confirma a regra de supressão que a Fase 2, item 6, descreve:

- **Cenários 10 (débito 03) e 11 (débito 07) não trazem `gIBSCBS`, `gIBSUF`, `gIBSMun` nem `gCBS`.** No lugar vêm `gAjusteCompet` (10) e `gEstornoCred` (11). Coerente com as rejeições 1021, 1170 e 1171.
- São também os dois cenários com menos tags (102 e 105, contra 127 da venda), o que reflete a dispensa de ICMS, IPI, PIS, COFINS e ISSQN.

---

## 6. Tags esperadas por cenário — insumo da rotina de auditoria

```
 1 finNFe=1 tpNF=1  VENDA
    IBSCBS IBSCBSTot IS ISTot cClassTrib gCBS gIBSCBS gIBSMun gIBSUF
    vCredPres vCredPresCondSus vItem vNFTot vProdLiq vProdLiqTot vUnComLiq

 2 finNFe=6 tpNF=1  DEBITO 06 - pagamento antecipado
    IBSCBS IBSCBSTot ICMSPrevistoPagtoAntecip cClassTrib gCBS gIBSCBS gIBSMun gIBSUF
    tpNFDebito vCredPres vCredPresCondSus vICMSPrevisto vItem vNFTot vProdLiq vProdLiqTot vUnComLiq

 3 finNFe=5 tpNF=0  CREDITO 04 - reducao de valor
    IBSCBS IBSCBSTot cClassTrib gCBS gIBSCBS gIBSMun gIBSUF tpNFCredito
    vCredPres vCredPresCondSus vItem vNFTot vProdLiq vProdLiqTot vUnComLiq

 4 finNFe=4 tpNF=1  DEVOLUCAO
    DFeReferenciado IBSCBS IBSCBSTot cClassTrib chaveAcesso gCBS gIBSCBS gIBSMun gIBSUF
    vCredPres vCredPresCondSus vItem vNFTot vProdLiq vProdLiqTot vUnComLiq

 5 finNFe=2 tpNF=1  COMPLEMENTAR
    IBSCBS IBSCBSTot cClassTrib gCBS gIBSCBS gIBSMun gIBSUF
    vCredPres vCredPresCondSus vItem vNFTot vProdLiq vProdLiqTot vUnComLiq

 6 finNFe=3 tpNF=1  AJUSTE
    IBSCBS IBSCBSTot cClassTrib gCBS gIBSCBS gIBSMun gIBSUF
    vCredPres vCredPresCondSus vItem vNFTot vProdLiq vProdLiqTot vUnComLiq

 7 finNFe=5 tpNF=0  CREDITO 03 - retorno por recusa total
    IBSCBS IBSCBSTot IS ISTot cClassTrib gCBS gIBSCBS gIBSMun gIBSUF tpNFCredito
    vCredPres vCredPresCondSus vItem vNFTot vProdLiq vProdLiqTot vUnComLiq

 8 finNFe=5 tpNF=0  CREDITO 06 - recusa parcial
    DFeReferenciado IBSCBS IBSCBSTot IS ISTot cClassTrib chaveAcesso gCBS gIBSCBS gIBSMun gIBSUF
    tpNFCredito vCredPres vCredPresCondSus vItem vNFTot vProdLiq vProdLiqTot vUnComLiq

 9 finNFe=6 tpNF=1  DEBITO 04 - multa e juros
    DFeReferenciado IBSCBS IBSCBSTot cClassTrib chaveAcesso gCBS gIBSCBS gIBSMun gIBSUF
    tpNFDebito vCredPres vCredPresCondSus vItem vNFTot vProdLiq vProdLiqTot vUnComLiq

10 finNFe=6 tpNF=1  DEBITO 03 - nota nao processada
    DFeReferenciado IBSCBS IBSCBSTot cClassTrib chaveAcesso gAjusteCompet
    tpNFDebito vItem vNFTot vProdLiq vProdLiqTot vUnComLiq

11 finNFe=6 tpNF=1  DEBITO 07 - perda em estoque
    DFeReferenciado IBSCBS IBSCBSTot cClassTrib chaveAcesso gEstornoCred
    tpNFDebito vItem vNFTot vProdLiq vProdLiqTot vUnComLiq
```

---

## 7. O que este inventário não responde

Ele diz o que o **XML da NT exige** e o que os **fontes DHL já tratam**. Não diz se o `XmlNfeSef` do ambiente **gera** as tags — essa é a outra metade da Fase 0, item 1, e depende de executar uma nota em homologação e inspecionar o XML produzido. Dado o fork do `nfesefaz.prw` (ver precondição da PREMISSA-01), a expectativa é que as 11 tags ausentes também não venham do XML hoje.
