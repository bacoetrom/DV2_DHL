# Leiaute Mastersaf / ONESOURCE DFe — posições da Reforma Tributária

- **Data:** 22/11/2026
- **Fonte:** `plan/ONESOURCEDFE_Layout_NFe_NFCe_4_00v4_19.xlsx`, aba `Envio NFe_NFCe - 4.00 -DFe 4.19`
- **Status:** destrava o bloqueio nº 1 do plano (leiaute posicional do Mastersaf NF-e)

---

## 1. A DHL está três versões atrás

`Includes/dhl.ch:98` grava `DHL_NFE_LAYOUT "4.16"`. Pelo histórico de alterações da planilha:

| versaoLayoutDFe | NT 2025.002-RTC | Produção SEFAZ |
|---|---|---|
| **4.16** (atual da DHL) | v1.20 | 06/10/2025 |
| 4.17 | v1.30 | 10/11/2025 |
| 4.18 | v1.36 e v1.40 | 03/08/2026 |
| **4.19** | v1.50 e v1.51 + NT 2026.008 v1.00 | 03/11/2026 |

O projeto mira a **NT 2025.002 v1.53**. O `DHL_NFE_LAYOUT` precisa ser bumpado — provavelmente para `"4.19"` — e isso amarra o `ProcRSymbMsa.prw`, que compartilha o define e não produz nenhum bloco da reforma.

## 2. Princípio de compatibilidade do fornecedor

Citação literal da planilha:

> *"Campos novos posicionados ao final de cada bloco, para evitar impacto em integrações já existentes."*

Isso **confirma** a decisão da Fase 0 de reverter `vUnComLiq`/`vProdLiq` do meio do bloco `EXTIPI`: o leiaute nunca insere campo no meio de bloco existente.

## 3. Posições exatas

### 3.1 Valor líquido — bloco NOVO no fim do `prod`

```
358   110.01   --sequencia_XML_liq_ini--;      0-1
359   110.02   vUnComLiq    Numerico  21 pos, 0-10 dec
360   110.03   vProdLiq     Numerico  15 pos, 2 dec
361            --sequencia_XML_liq_fim--;
362            --prod_fim--;
```

Bloco **nomeado** `sequencia_XML_liq`, último elemento do grupo `prod`, imediatamente antes de `--prod_fim--`. No XML a sequência sai entre `vProd` e `cEANTrib`, mas **no TXT vai no fim** — não há deslocamento.

### 3.2 `vProdLiqTot` — depois do `vNFTot`, fora do `icms_Tot`

```
1231           --IBSCBSTot_fim--;
1232  355.30   vNFTot         Numerico 15,2  0-1
1233  326a     vProdLiqTot    Numerico 15,2  0-1
1234           --total_fim--;
```

⚠️ **Mudou em relação à prévia de 15/10/2026**, e a planilha alerta explicitamente: antes ficava no fim do `icms_Tot`, depois do `vTotTrib`. Quem adaptou à prévia precisa reposicionar.

### 3.3 `ICMS_Previsto` — fim do grupo ICMS

```
758   245b.01  --ICMS_Previsto_ini--;    0-1
759   245b.02  vICMSPrevisto   Numerico 15,2
760            --ICMS_Previsto_fim--;
```

O marcador chama-se **`ICMS_Previsto`**, não `ICMSPrevistoPagtoAntecip`. Só NF-e modelo 55, pagamento antecipado. O grupo é **alternativo** aos demais grupos de ICMS do item.

### 3.4 Imposto Seletivo — item e total

```
899            --ISSQN_fim--;
900   324.01   --IS_ini--;      0-1
901   324.02   CSTIS            Numerico 3
907   324.11   vIS              Numerico 15,2
913            --IS_fim--;
```

No total:

```
1191           --ret_Trib_fim--;
1192  355.1    --ISTot_ini--;   0-1
1193  355.3    vIS              Numerico 15,2
1194           --ISTot_fim--;
1195  355.4    --IBSCBSTot_ini--;
```

### 3.5 `gAjusteCompet` e `gEstornoCred`

```
item:   324.112  --gAjusteCompet_ini--;   1-1
item:   324116   --gEstornoCred_ini--;    0-1
total:  355.29e  --gEstornoCred_ini--;    dentro do IBSCBSTot, apos gMono_Tot
```

O `gEstornoCred` existe em **dois níveis**: item e total.

### 3.6 Ordem completa do bloco `total` na 4.19

```
icms_Tot -> issqn_Tot (342) -> ret_Trib (348) -> ISTot (355.1)
-> IBSCBSTot (355.4)
     gIBS_Tot (355.6) -> gIBSUF_Tot (355.7) -> gIBSMun_Tot (355.12)
     gCBS_Tot (355.20) -> gMono_Tot (355.27) -> gEstornoCred (355.29e)
   IBSCBSTot_fim
-> vNFTot (355.30) -> vProdLiqTot (326a) -> total_fim
```

---

## 4. Correções — TODAS APLICADAS em 22/11/2026 (commit `8656ca8`)

| # | Item | Como está | Como deve ficar |
|---|---|---|---|
| 1 | `vUnComLiq` / `vProdLiq` | retirados na Fase 0 | ✅ bloco `sequencia_XML_liq` criado como **último** elemento do `prod` |
| 2 | `vProdLiqTot` | chamado antes do `DoIcmsTot()` | ✅ movido para **depois** do `DovNFTot()` |
| 3 | `ICMSPrevistoPagtoAntecip` | marcador com esse nome | ✅ renomeado para **`ICMS_Previsto`** |
| 4 | `gEstornoCred` | só no item | ✅ acrescentado o de **total** (355.29e), via `DogEstCredTot()` |
| 5 | `DoISTot()` | antes do `DoIBSCBSTot()` | ✅ **já correto** — confere com 355.1 antes de 355.4 |
| 6 | `DoIS()` | antes do `DoIBSCBS()`, depois do `DoISSQN()` | ✅ **já correto** — confere com 324.01 depois de 899 |
| 7 | `DHL_NFE_LAYOUT` | `"4.16"` | ⏸ **pendente** — bumpar para `"4.19"` exige tratar antes o `ProcRSymbMsa` |

Os `#define` de marcador criados na Fase 0 tornam os itens 3 e 1 alterações de um token.

---

## 5. Regras de cálculo que a planilha esclarece

- **`vProd` (110):** a partir de 2027 os valores de IBS, CBS e IS **compõem** o Valor Total Bruto, exceto nas notas de importação.
- **`vNFTot` (355.30):** a partir de 2027 IBS, CBS e IS **já estão** no `vProd` e **não devem ser somados de novo** no total.
- **Vigência da NB01-30** (valor líquido): homologação 01/02/2027, produção 01/03/2027. A NT 2026.008 v1.00 tinha produção em 16/11/2026, adiada pela SEFAZ em 05/10/2026.
