# Leiaute ONESOURCE DFe 4.19 — Posições e Tags do TXT de Envio NF-e/NFC-e

> **Documentação de referência completa** do arquivo posicional de integração do Mastersaf NF-e / ONESOURCE DFe, extraída integralmente da planilha oficial do fornecedor e cruzada com o documento de análise interno.

| Item | Valor |
|---|---|
| **Fonte primária** | [ONESOURCEDFE_Layout_NFe_NFCe_4_00v4_19.xlsx](ONESOURCEDFE_Layout_NFe_NFCe_4_00v4_19.xlsx) — aba `Envio NFe_NFCe - 4.00 -DFe 4.19` |
| **Publicação da planilha** | 03/11/2026 (aba `Capa`: "ONESOURCE DFE — Manual de Layout NF-e/NFC-e 4_00 v4_19") |
| **Documento cruzado** | [Leiaute_Mastersaf_4_19.md](Leiaute_Mastersaf_4_19.md) |
| **Código validado** | [ProcMsaNFe.prw](../PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw), [dhl.ch](../PROTHEUS/Includes/dhl.ch) |
| **Versão DF-e do fornecedor** | 3.161.1 (requisito para a 4.19 completa) |
| **Data desta extração** | 27/11/2026 |
| **Linhas do leiaute** | 1.399 (480 marcadores de bloco + 918 campos + `--arquivo_fim--;`) |

---

## 1. Como ler este documento

### 1.1 Convenção de numeração (atenção — há duas numerações diferentes)

A planilha tem **duas colunas de "posição"** e o TXT tem uma terceira numeração implícita. Confundi-las é a principal fonte de erro de integração:

| Numeração | Significado | Onde aparece |
|---|---|---|
| **`Nº`** (coluna 1 das tabelas abaixo) | **Sequência física da linha no arquivo TXT**, 1-based, onde a linha 1 é `--nota_ini--;` e a linha 1.399 é `--arquivo_fim--;`. É esta que determina a ordem de gravação. | Calculada nesta documentação |
| **`Pos.`** (coluna `4.00` da planilha) | **Identificador do campo no leiaute da SEFAZ** (ex.: `110.02`, `355.30`, `326a`). Não é sequencial e não define ordem — campos novos recebem sufixos alfanuméricos (`326a`, `355.29e`, `324116`) e podem ser gravados longe da sua numeração. | Planilha, coluna `4.00` |
| Linha do Excel | Linha física da planilha. Equivale a **`Nº` + 12** (o cabeçalho ocupa as linhas 1–12 e o leiaute começa na linha 13). | Planilha |

> ⚠️ **Divergência de referência com o [Leiaute_Mastersaf_4_19.md](Leiaute_Mastersaf_4_19.md):** os números citados naquele documento (ex.: "358 110.01", "1232 355.30") correspondem a **linha do Excel − 13**, ou seja, **`Nº` − 1** nesta documentação. Todos os números daquele documento estão internamente consistentes, mas deslocados em uma linha em relação à sequência real do TXT. Ao comparar os dois documentos, use a tabela de equivalência da seção 4.

### 1.2 Estrutura das tabelas

| Coluna | Conteúdo |
|---|---|
| `Nº` | Sequência da linha no TXT (ver 1.1) |
| `Pos.` | Identificador do campo no leiaute 4.00 / NT |
| `Nív.` | Profundidade de aninhamento do bloco (0 = `nota`) |
| `Tag / Campo` | Nome exato da tag no TXT. Marcadores de bloco aparecem como `--nome_ini--;` / `--nome_fim--;` (abertura em **negrito**) |
| `Tipo` | Numérico, Caractere, Data, Grupo, `G` (grupo) ou `CG` (*Choice Group* — escolha exclusiva entre grupos irmãos) |
| `Ocor.` | Ocorrência mínima-máxima (`0-1` opcional, `1-1` obrigatório, `1-900` repetição) |
| `Tam,Dec` | Tamanho total em posições e casas decimais |
| `Grupo pai` | Bloco imediatamente superior |
| `Descrição` | Descrição da planilha (truncada em 80 caracteres; o texto integral dos blocos da Reforma Tributária está na seção 6) |

### 1.3 Regras gerais do Integrador TXT

Transcrição literal da planilha (linha 6 da aba):

> **Regras Gerais:**
> - Bloco não obrigatório: não é gerado quando os campos de integração estão vazios (ex.: `--avulsa_ini--`).
> - Bloco obrigatório (principal): é gerado com tag fechada `<tag/>` quando os campos estão vazios.
> - Blocos principais obrigatórios com subcampos vazios: apenas o bloco principal é gerado; os subblocos (mesmo obrigatórios) são ignorados (ex.: `--emit_ini--;` > `--ender_Emit_ini--;` > `xLgr`).
> - Campos zerados (0.00): são incluídos no XML.

E o princípio de compatibilidade declarado na entrada de 03/11/2026 do histórico:

> *"Campos novos posicionados ao final de cada bloco, para evitar impacto em integrações já existentes."*

### 1.4 Característica estrutural observada

O arquivo encerra com `--arquivo_fim--;` (linha 1.399), **que não possui marcador `--arquivo_ini--;` correspondente** em nenhum ponto da planilha. É o encerramento do arquivo (não de um bloco) e deve ser gravado após `--nota_fim--;`. Fora esse caso, os 240 blocos da aba estão perfeitamente balanceados (todo `_ini--` tem seu `_fim--`), com profundidade máxima de 10 níveis.

---

## 2. Números do leiaute 4.19

| Métrica | Valor |
|---|---|
| Linhas totais do TXT | **1.399** |
| Campos (não marcadores) | **918** |
| Blocos (pares `_ini`/`_fim`) | **240** |
| Blocos de 1º nível (filhos diretos de `nota`) | **23** |
| Profundidade máxima de aninhamento | **10** |
| Linhas novas em relação à 4.16 (versão em uso na DHL) | **169** |
| Linhas removidas/renomeadas em relação à 4.16 | **54** |
| Delta líquido de linhas (4.16 → 4.19) | 1.274 → 1.399 (**+125**) |

Blocos de 1º nível, na ordem de gravação:

| # | Bloco | Pos. | Linhas | Ocor. |
|---:|---|---|---|---|
| 1 | `versao_Layout_DFe` | — | 2–4 | 0-1 |
| 2 | `inf_NFe` | 1 | 5–8 | 1-1 |
| 3 | `param_gerais` | — | 9–24 | 0-1 |
| 4 | `ide` | 5 | 25–95 | 1-1 |
| 5 | `emit` | 30 | 96–122 | 1-1 |
| 6 | `avulsa` | 50 | 123–135 | 0-1 |
| 7 | `dest` | 62 | 136–159 | 0-1 |
| 8 | `retirada` | 80 | 160–177 | 0-1 |
| 9 | `entrega` | 89 | 178–195 | 0-1 |
| 10 | `aut_XML` | 97a.1 | 196–199 | 0-10 |
| 11 | `item_nota` | — | 200–1137 | 1-900 |
| 12 | `total` | 326 | 1138–1235 | 1-1 |
| 13 | `inf_transporte` | — | 1236–1282 | — |
| 14 | `cobr` | 389 | 1283–1295 | 0-1 |
| 15 | `pag` | 398a | 1296–1317 | 1-1 |
| 16 | `infIntermed` | 398j | 1318–1321 | 0-1 |
| 17 | `gPgtoVinc` | 398.50 | 1322–1330 | 0-1 |
| 18 | `inf_Adic` | 399 | 1331–1347 | 0-1 |
| 19 | `exporta` | 402 | 1348–1352 | 0-1 |
| 20 | `compra` | 405 | 1353–1357 | 0-1 |
| 21 | `cana` | 409 | 1358–1375 | 0-1 |
| 22 | `infRespTec` | 423a | 1376–1385 | 0-1 |
| 23 | `agropecuario` | 424 | 1386–1397 | 0-1 |

---

## 3. Histórico de versões — o que cada `versaoLayoutDFe` entrega

Extraído da aba `Alterações` (entradas 55 a 66). O campo `versaoLayoutDFe` (linha 3, grupo `versao_Layout_DFe`) é **Numérico, 5 posições, 2 decimais, ocorrência 1-1**, e a observação Mastersaf exige: *"Informar o valor '4.19'"*.

| versaoLayoutDFe | Data da planilha | Versão DF-e | Base normativa | Produção SEFAZ |
|---|---|---|---|---|
| **4.16** ← *em uso na DHL* | 01/08/2025 | 3.146.0 | NT 2025.002-RTC **v1.20** | 06/10/2025 |
| 4.17 | 04/11/2025 | 3.148.1 | NT 2025.002-RTC **v1.30** | 10/11/2025 |
| 4.18 | 14/07/2026 | 3.157.1 | NT 2025.002-RTC **v1.36 e v1.40** | 03/08/2026 |
| **4.19** | 22/09/2026 | 3.160.1 | NT 2025.002-RTC **v1.50 e v1.51** | 03/11/2026 |
| **4.19** (2ª entrada) | 03/11/2026 | 3.161.1 | **NT 2026.008 v1.00** (valor líquido) + **NT 2026.006 v1.00** (vinculação de pagamento) | 16/11/2026 — *adiada pela SEFAZ em 05/10/2026*; regra NB01-30: homologação 01/02/2027, produção 01/03/2027 |

### 3.1 Conteúdo da 4.19 — entrada de 22/09/2026 (NT 2025.002-RTC v1.50/v1.51)

- Adicionada versão `4.19` no campo `versaoLayoutDFe`.
- **Reformulação completa** da tributação monofásica de combustíveis (`gIBSCBSMono`), separada em `gIBSMonoAdRem`, `gIBSMonoAdValorem`, `gCBSMonoAdRem` e `gCBSMonoAdValorem`, cada um com `gMonoPadrao`, `gMonoReten`, `gMonoRet` e `gpBioDiferenca`.
- **Removido** o grupo `gMonoDif` (diferimento), substituído por `gpBioDiferenca`.
- Novos campos *Ad Valorem*: `vBCMono`, `pAliqMonoUF`, `vIBSMonoUF`, `pAliqMonoMun`, `vIBSMonoMun`, `pAliqMonoCBS`, `pAliqMonoReten`, `vBCMonoReten`.

### 3.2 Conteúdo da 4.19 — entrada de 03/11/2026 (NT 2026.008 + NT 2026.006)

- Grupo `sequencia_XML_liq` (110.01) com `vUnComLiq` (110.02) e `vProdLiq` (110.03), **ao final do grupo `prod`**, antes de `--prod_fim--`. No XML a sequência é gerada entre `vProd` e `cEANTrib`.
- Campo `vProdLiqTot` (326a), opcional, **diretamente no grupo `total`, após `vNFTot` e fora do `icms_Tot`**. No XML é gerado como primeira tag de `total`, antes de `ICMSTot`.
- Grupo `ICMS_Previsto` (245b.01) com `vICMSPrevisto` (245b.02), **ao final do grupo `ICMS`** — somente NF-e modelo 55, pagamento antecipado, **alternativo** aos demais grupos de ICMS do item.
- Observação incluída em `vProd` (110): a partir de 2027 os valores de IBS, CBS e IS **compõem** o Valor Total Bruto, exceto nas notas de importação.
- Observação incluída em `vNFTot` (355.30): a partir de 2027 IBS, CBS e IS **já compõem o `vProd`** e não devem ser somados novamente no total.
- Grupo `gPgtoVinc` (398.50 a 398.56), opcional, **entre `infIntermed` e `inf_Adic`**, com o subgrupo `gPgto` (1-99) e os campos `nPag`, `idTransacao`, `tpMeioPgto`, `CNPJReceb`, `CNPJBasePSP` — caráter preparatório (*split payment* previsto a partir de 2027), sem exigência de preenchimento em produção em 2026.

> ⚠️ **Alerta formal do fornecedor na própria planilha:** *"alteração em relação à prévia publicada em 15/10/2026: o campo `vProdLiqTot` (326a) passou a ser posicionado diretamente no grupo `total`, após o campo `vNFTot` (355.30) e fora do grupo `icms_Tot`. Na prévia anterior, o campo estava ao final do grupo `icms_Tot` (após `vTotTrib`). **Ação necessária:** clientes que já adaptaram a integração à prévia anterior devem reposicionar o campo `vProdLiqTot` no arquivo TXT."*

---

## 4. Validação cruzada com o `Leiaute_Mastersaf_4_19.md`

Legenda: ✅ confirmado pela planilha · 🔶 confirmado com ressalva/complemento · ❌ divergente · ⚠️ não coberto pelo documento.

### 4.1 Afirmações posicionais

| # | Afirmação no `Leiaute_Mastersaf_4_19.md` | Nº real (TXT) | Resultado |
|---|---|---|---|
| 1 | `sequencia_XML_liq` é bloco nomeado, **último elemento** do `prod`, imediatamente antes de `--prod_fim--` | 359–362, `prod_fim` em 363 | ✅ |
| 2 | `vUnComLiq` = 110.02, numérico 21 posições, 0-10 decimais | linha 360 — Numérico, 21, 0-10 ("11 inteiros e 0 a 10 decimais") | ✅ |
| 3 | `vProdLiq` = 110.03, numérico 15 posições, 2 decimais | linha 361 — Numérico, 15,2 | ✅ |
| 4 | No XML a sequência sai entre `vProd` e `cEANTrib`, mas no TXT vai no fim | observação literal da planilha na linha 359 | ✅ |
| 5 | `vProdLiqTot` (326a) vem **depois** do `vNFTot` (355.30) e **fora** do `icms_Tot` | `IBSCBSTot_fim` 1232 → `vNFTot` 1233 → `vProdLiqTot` 1234 → `total_fim` 1235 | ✅ |
| 6 | A posição do `vProdLiqTot` mudou em relação à prévia de 15/10/2026 (antes no fim do `icms_Tot`, após `vTotTrib`) | alerta literal na entrada de 03/11/2026 do histórico | ✅ |
| 7 | O marcador chama-se `ICMS_Previsto` (e **não** `ICMSPrevistoPagtoAntecip`) | linha 759: `--ICMS_Previsto_ini--;` pos. 245b.01 | ✅ |
| 8 | `vICMSPrevisto` numérico 15,2, no fim do grupo ICMS | linha 760; grupo é o **último** filho de `ICMS` (759–761), `ICMS_fim` em 762 | ✅ |
| 9 | Só NF-e modelo 55, pagamento antecipado; grupo **alternativo** aos demais grupos de ICMS do item | observação da planilha confirma e **detalha**: `tpNFDebito` = 06 (pagamento antecipado) e `tpOperGov` = 4 (recebimento com fornecimento posterior); quando informado, **nenhum outro grupo de ICMS** pode ser enviado no mesmo item | 🔶 confirmado + complemento |
| 10 | `IS` do item: `--ISSQN_fim--` → `--IS_ini--` (324.01) → `CSTIS` (324.02) → … → `vIS` (324.11) → `--IS_fim--` | `ISSQN_fim` 900, `IS_ini` 901, `CSTIS` 902, `vIS` 908, `IS_fim` 914 | 🔶 ver 4.2-A |
| 11 | Total: `--ret_Trib_fim--` → `ISTot_ini` (355.1) → `vIS` (355.3) → `ISTot_fim` → `IBSCBSTot_ini` (355.4) | 1192 → 1193 → 1194 → 1195 → 1196 | ✅ |
| 12 | `gAjusteCompet` no item = 324.112, ocorrência 1-1 | linha 1087, tipo `CG`, ocor. 1-1 | 🔶 ver 4.2-B |
| 13 | `gEstornoCred` no item = 324116, ocorrência 0-1 | linha 1093, tipo `G`, ocor. 0-1 | 🔶 ver 4.2-B |
| 14 | `gEstornoCred` existe em **dois níveis** (item e total), o de total em 355.29e, dentro do `IBSCBSTot`, após `gMono_Tot` | item 1093–1096; total 1228–1231, logo após `gMono_Tot_fim` (1227) | ✅ |
| 15 | Ordem do `total`: `icms_Tot` → `issqn_Tot` (342) → `ret_Trib` (348) → `ISTot` (355.1) → `IBSCBSTot` (355.4) → `vNFTot` → `vProdLiqTot` | `icms_Tot` 1139–1169, `issqn_Tot` 1170–1183, `ret_Trib` 1184–1192, `ISTot` 1193–1195, `IBSCBSTot` 1196–1232 | ✅ |
| 16 | Dentro do `IBSCBSTot`: `gIBS_Tot` (355.6) → `gIBSUF_Tot` (355.7) → `gIBSMun_Tot` (355.12) → `gCBS_Tot` (355.20) → `gMono_Tot` (355.27) → `gEstornoCred` (355.29e) | ver 4.2-C | 🔶 aninhamento diferente do sugerido |

### 4.2 Ressalvas e precisões

**A. `vIS` do item não é filho direto de `IS`.** O bloco `IS` (324.01) tem a estrutura:

```
901  324.01  --IS_ini--;              0-1
902  324.02    CSTIS                  Numérico 3
903  324.03    cClassTribIS           Caractere 6
904  324.04    --seqSeletivo_ini--;   0-1          <-- subgrupo intermediário
905  324.05      vBCIS                Numérico 15,2
906  324.06      pIS                  Caractere 7, 2-4 dec
907  324.07      pISEspec | adRemIS   Numérico 7, 2-4 dec   (0-1)
908  324.11      vIS                  Numérico 15,2
909  324.08      --sequencia_XML_ini--;  0-1
910  324.09        uTrib              Caractere 1-6
911  324.10        qTrib              Numérico 15, "0 ou 4" dec
912          --sequencia_XML_fim--;
913          --seqSeletivo_fim--;
914          --IS_fim--;
```

Pontos não registrados no documento anterior: (i) existe o subgrupo **`seqSeletivo` (324.04)** entre `IS` e os valores — `vBCIS`, `pIS`, `pISEspec`/`adRemIS` e `vIS` ficam dentro dele; (ii) a posição **324.07 passou a se chamar `pISEspec | adRemIS`** na 4.19 (na 4.16 era apenas `pISEspec`); (iii) `pIS` (324.06) é declarado como **Caractere**, não numérico; (iv) `qTrib` (324.10) tem decimais "**0 ou 4**" (ajuste documentado em 18/11/2025, conforme schema da SEFAZ).

**B. `gAjusteCompet` e `gEstornoCred` do item estão em níveis diferentes.**

```
919  324.14k  --sequencia_XML_IBSCBS_ini--;       (nível 5)
920  324.15     --gIBSCBS_ini--;        1-1
...
1087 324.112    --gAjusteCompet_ini--;  CG 1-1    (nível 6, dentro do sequencia_XML_IBSCBS)
1091            --gAjusteCompet_fim--;
1092          --sequencia_XML_IBSCBS_fim--;
1093 324116   --gEstornoCred_ini--;     G  0-1    (nível 5, filho DIRETO de IBSCBS)
1094 324.17     vIBSEstCred            Numérico 15,2
1095 324.18     vCBSEstCred            Numérico 15,2
1096          --gEstornoCred_fim--;
1097 324119   --sequencia_XML_cred_pres_ini--;    G 0-1
```

Ou seja: `gAjusteCompet` é irmão de `gIBSCBS` **dentro** de `sequencia_XML_IBSCBS`; `gEstornoCred` do item vem **depois** do fechamento desse bloco, como filho direto de `IBSCBS`. Observe também que os campos do `gEstornoCred` do item usam as posições **324.17 / 324.18** (e não 324116.x).

**C. `gIBSUF_Tot` e `gIBSMun_Tot` são filhos de `gIBS_Tot`, não irmãos.** A estrutura real do `IBSCBSTot`:

```
1196 355.4   --IBSCBSTot_ini--;        0-1
1197 355.5     vBCIBSCBS               Numérico 15,2   1-1   <-- ausente no resumo anterior
1198 355.6     --gIBS_Tot_ini--;       0-1
1199 355.7       --gIBSUF_Tot_ini--;   1-1   (nível 4)
1203              --gIBSUF_Tot_fim--;
1204 355.12      --gIBSMun_Tot_ini--;  1-1   (nível 4)
1208              --gIBSMun_Tot_fim--;
1209-1211         vIBS / vCredPres / vCredPresCondSus   (do próprio gIBS_Tot)
1212            --gIBS_Tot_fim--;
1213 355.20    --gCBS_Tot_ini--;       0-1
1219            --gCBS_Tot_fim--;
1220 355.27    --gMono_Tot_ini--;      0-1
1227            --gMono_Tot_fim--;
1228 355.29e   --gEstornoCred_ini--;   0-1
1231            --gEstornoCred_fim--;
1232          --IBSCBSTot_fim--;
```

**D. Tabela de versões confirmada, com uma ressalva importante de escopo.** As quatro linhas da tabela do documento anterior (4.16/v1.20/06-10-2025, 4.17/v1.30/10-11-2025, 4.18/v1.36 e v1.40/03-08-2026, 4.19/v1.50 e v1.51/03-11-2026) conferem com o histórico da planilha. Porém:

> ❗ O documento anterior afirma que **"o projeto mira a NT 2025.002 v1.53"**. A planilha 4.19 implementa **v1.50 e v1.51** (+ NT 2026.008 v1.00 e NT 2026.006 v1.00). **Não existe, nesta planilha, cobertura declarada para a v1.53.** Se o escopo do projeto é realmente a v1.53, o leiaute 4.19 é condição necessária mas **não suficiente** — será preciso confirmar com a TOTVS/Thomson qual `versaoLayoutDFe` entrega a v1.53 (provável 4.20+) antes de fechar o escopo.

**E. Regra de cálculo (seção 5 do documento anterior) — confirmada literalmente.** As observações de `vProd` (110) e `vNFTot` (355.30) e as datas da NB01-30 (homologação 01/02/2027, produção 01/03/2027; produção da NT 2026.008 adiada em 05/10/2026) estão transcritas corretamente.

### 4.3 Situação do código DHL frente ao leiaute

| # | Item | Situação no código | Conferência com a planilha |
|---|---|---|---|
| 1 | `sequencia_XML_liq` | `#define MSA_TAG_SEQLIQ "sequencia_XML_liq"` e `DoSeqXmlLiq()` gravando `vUnComLiq`/`vProdLiq`; comentário em [ProcMsaNFe.prw:1636](../PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw#L1636) registra a remoção do bloco `EXTIPI` | ✅ confere com 359–362 |
| 2 | `vProdLiqTot` | `DovProdLiqTot()` chamado **após** `DovNFTot()` ([ProcMsaNFe.prw:146-150](../PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw#L146)) | ✅ confere com 1233 → 1234 |
| 3 | `ICMS_Previsto` | `#define MSA_TAG_ICMSPREV "ICMS_Previsto"` ([ProcMsaNFe.prw:19](../PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw#L19)) | ✅ confere com 759 |
| 4 | `gEstornoCred` de total | `DogEstCredTot()` dentro do `IBSCBSTot` ([ProcMsaNFe.prw:142](../PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw#L142)) | ✅ confere com 1228 |
| 5 | `DoISTot()` antes de `DoIBSCBSTot()` | ordem mantida em [ProcMsaNFe.prw:130-133](../PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw#L130) | ✅ confere com 1193 antes de 1196 |
| 6 | `DoIS()` depois de `DoISSQN()` | ordem mantida | ✅ confere com 901 depois de 900 |
| 7 | `DHL_NFE_LAYOUT` | `"4.16"` em [dhl.ch:98](../PROTHEUS/Includes/dhl.ch#L98) | ⏸ pendente — ver seção 5 |
| 8 | `gEstornoCred` do item | `DogEstornoCred()` adiciona o nó em `oSeqXML`, o mesmo pai do `gIBSCBS` ([ProcMsaNFe.prw:5074](../PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw#L5074)) | ⚠️ **a validar** — na planilha o `gEstornoCred` do item (324116) é filho **direto** do `IBSCBS`, gravado **após** `--sequencia_XML_IBSCBS_fim--` (linha 1092). Já o `gAjusteCompet` (324.112) é, de fato, filho do `sequencia_XML_IBSCBS`. Confirmar se o objeto `oSeqXML` do `MsafNFeTag` materializa o marcador `sequencia_XML_IBSCBS` no TXT — se sim, o `gEstornoCred` do item está sendo gravado um nível abaixo do leiaute |
| 9 | Monofásico de combustíveis | código ainda gera `gMonoPadrao` com `adRemIBS`/`adRemCBS` e o grupo `gMonoDif` ([ProcMsaNFe.prw:4938](../PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw#L4938)) | ❌ **incompatível com a 4.19** — ver seção 5 |
| 10 | `gPgtoVinc` | ausente do código | ⚠️ ver seção 5 |

---

## 5. Lacunas da 4.19 não cobertas pelo documento anterior

O `Leiaute_Mastersaf_4_19.md` cobre integralmente o pacote da **NT 2026.008** (valor líquido, ICMS previsto, totais). Os itens abaixo **também fazem parte da 4.19** e não estão registrados lá — são trabalho adicional ao bumpar `DHL_NFE_LAYOUT` para `"4.19"`:

1. **Reformulação do monofásico de combustíveis (NT 2025.002-RTC v1.50/v1.51) — o maior item.** O antigo `gIBSCBSMono` com um único `gMonoPadrao`/`gMonoReten`/`gMonoRet`/`gMonoDif` foi substituído por dois blocos de sequência (`sequencia_XML_IBSMono` 324.85 e `sequencia_XML_CBSMono` 324.95), cada um com variantes **Ad Rem** e **Ad Valorem** (`gIBSMonoAdRem`, `gIBSMonoAdValorem`, `gCBSMonoAdRem`, `gCBSMonoAdValorem`), e o `gMonoDif` deu lugar a `gpBioDiferenca`. O bloco `gIBSCBSMono` passou de **31 linhas na 4.16** (linhas 967–997) para **87 linhas na 4.19** (linhas 996–1082). O código atual grava a estrutura antiga.
2. **`gPgtoVinc` (398.50–398.56) — NT 2026.006.** Novo bloco de 1º nível entre `infIntermed` e `inf_Adic`, com subgrupo `gPgto` (1-99). Preparatório para *split payment*; sem exigência em 2026, mas o bloco existe no leiaute e o TXT precisa prever a posição.
3. **`gCompraGov` foi renumerado.** Na 4.16 as posições eram `29f`, `29f.1`, `29f.2`, `29f.3`; na 4.19 são `29.z1`, `29.z2`, `29.z3`, `29.z4`, e foi acrescentado o subgrupo `ref_NFe` (29.z5a) com `refDFeAnt` (29.z5), ocorrência 0-99.
4. **`sequencia_XML_cred_pres` (324119)** substitui os antigos `gIBSCredPres` (324.73) e `gCBSCredPres` (324.78) soltos, agora dentro de `gCredPresOper` (324.120), e o `gCredPresIBSZFM` passou de 324.109 para 324.131, ganhando o campo `competApur` (324132).
5. **`gALCZFMCBS` (324.66a)** — novo grupo da CBS na ALC/ZFM com `tpALCZFMCBS`, `nProcSuframa`, `pAliqEfetRegCBS`, `vTribRegCBS`.
6. **Novos campos de item e cabeçalho:** `dPrevEntrega` (14a), `cIndOp` (29.6 — **gravado na linha 51, após `verProc`/29b**, conforme correção de documentação de 30/07/2026; quem seguiu a planilha anterior gravava após `indIntermed` e produzia XML com valores trocados em `cIndOp`, `procEmi` e `verProc`), `ISUFEmit` (49d), `tpCredPresIBSZFM` (104h), `indDoacao` (324.14a — a posição 324.14a era do `sequencia_XML_IBSCBS`, que foi renumerado para 324.14k), `pDevTrib` (324.24a / 324.43a / 324.62a), `vTotIBSMonoItem` / `vTotCBSMonoItem` (324.105a / 324.105b), `cBenefRBC` (237.1a).
7. **Novos blocos de ICMS:** `sequencia_XML_op` (238.0), `sequencia_XML_fcpdif` (239.05), `sequencia_XML_deson` (245.17 no `icms_part`), `indDeduzDeson` (245.4 / 245.20).
8. **Correções de identificador sem mudança de campo** (não exigem trabalho, mas aparecem no Anexo A como "removido + novo"): `gDif`, `vDif`, `vDevTrib`, `pRedAliq` e `pAliqEfet` tinham na 4.16 os identificadores grafados com ponto duplo (`324..21`, `324..23`, `324..25`, `324..27`, `324..28`) e na 4.19 estão corrigidos (`324.21`, `324.23`, `324.25`, `324.27`, `324.28`). O campo e a posição no TXT são os mesmos.

> **Consequência prática:** bumpar `DHL_NFE_LAYOUT` de `"4.16"` para `"4.19"` **não é uma alteração de um token**. O `versaoLayoutDFe` informado passa a obrigar o TXT inteiro a seguir a 4.19 — inclusive a estrutura monofásica reformulada e as posições renumeradas do `gCompraGov` e do crédito presumido. O inventário completo das 169 linhas novas e 54 removidas está no Anexo A.

---

## 6. Detalhe integral dos blocos da Reforma Tributária

Texto completo de descrição e observações (SEFAZ/NT e Mastersaf) para os blocos críticos. Para os demais, ver a tabela completa na seção 8.

#### `sequencia_XML_liq` (110.01) — valor líquido do item (NT 2026.008)

**Linha 359 — `--sequencia_XML_liq_ini--;`** (pos. 110.01, nível 4)

- Ocor.: 0-1
- Descrição: Sequência XML
- Observação SEFAZ/NT: Futuramente essa sequência será obrigatória. No XML, a sequência é gerada entre as tags vProd e cEANTrib (a posição no TXT não altera a ordem no XML). (Incluído na NT 2026.008)

**Linha 360 — `vUnComLiq`** (pos. 110.02, nível 5)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 21 · Dec.: 0-10
- Descrição: Valor Líquido Unitário do Produto ou Serviço (sem tributos)
- Observação SEFAZ/NT: Valor unitário de comercialização do produto ou serviço, sem a inclusão de tributos. (Incluído na NT 2026.008)
- Observação Mastersaf: 21 posições, sendo 11 inteiros e 0 a 10 decimais

**Linha 361 — `vProdLiq`** (pos. 110.03, nível 5)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 15 · Dec.: 2
- Descrição: Valor Líquido do Produto ou Serviço (sem tributos)
- Observação SEFAZ/NT: Valor líquido do produto ou serviço, sem a inclusão de tributos. (Incluído na NT 2026.008)
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 362 — `--sequencia_XML_liq_fim--;`** (pos. sem pos., nível 4)


#### `ICMS_Previsto` (245b.01) — ICMS previsto no pagamento antecipado (NT 2026.008)

**Linha 759 — `--ICMS_Previsto_ini--;`** (pos. 245b.01, nível 5)

- Ocor.: 0-1
- Descrição: Grupo do ICMS Previsto no Pagamento Antecipado
- Observação SEFAZ/NT: Grupo utilizado exclusivamente em cenários específicos de pagamento antecipado para auxiliar na correta tributação do IBS e da CBS: - tpNFDebito = 06-Pagamento antecipado; - tpOperGov = 4-Recebimento do pagamento com fornecimento posterior. Somente NF-e (modelo 55). Este grupo é uma alternativa aos demais grupos de ICMS do item (ICMS00, ICMS10, ... ICMSSN900): quando informado, nenhum outro grupo de ICMS pode ser enviado no mesmo item. Ocorrência na NT: 1-1 (dentro do grupo, obrigatório apenas nesses cenários). (Incluído na NT 2026.008)

**Linha 760 — `vICMSPrevisto`** (pos. 245b.02, nível 6)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 15 · Dec.: 2
- Descrição: Valor do ICMS Previsto
- Observação SEFAZ/NT: Valor do ICMS que incidirá no momento do fornecimento futuro. Em cenários onde não haverá valor de ICMS devido no fornecimento, informar 0. (Incluído na NT 2026.008)
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 761 — `--ICMS_Previsto_fim--;`** (pos. sem pos., nível 5)


#### `IS` (324.01) — Imposto Seletivo no item

**Linha 901 — `--IS_ini--;`** (pos. 324.01, nível 4)

- Ocor.: 0-1
- Descrição: Informações do Imposto Seletivo
- Observação SEFAZ/NT: Grupo Opcional

**Linha 902 — `CSTIS`** (pos. 324.02, nível 5)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 3
- Descrição: Código de Situação Tributária do Imposto Seletivo
- Observação SEFAZ/NT: Utilizar tabela CST do Imposto Seletivo

**Linha 903 — `cClassTribIS`** (pos. 324.03, nível 5)

- Tipo: Caractere · Ocor.: 1-1 · Tam.: 6
- Descrição: Código de Classificação Tributária do Imposto | Seletivo
- Observação SEFAZ/NT: Utilizar tabela cClassTribIS

**Linha 904 — `--seqSeletivo_ini--;`** (pos. 324.04, nível 5)

- Ocor.: 0-1
- Descrição: Sequência XML
- Observação SEFAZ/NT: Grupo Opcional.

**Linha 905 — `vBCIS`** (pos. 324.05, nível 6)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 15 · Dec.: 2
- Descrição: Valor da Base de Cálculo do Imposto Seletivo
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 906 — `pIS`** (pos. 324.06, nível 6)

- Tipo: Caractere · Ocor.: 1-1 · Tam.: 7 · Dec.: 2-4
- Descrição: Alíquota do Imposto Seletivo (em percentual)
- Observação Mastersaf: 7 posições, sendo 3 inteiros e 2 a 4 decimais

**Linha 907 — `pISEspec | adRemIS`** (pos. 324.07, nível 6)

- Tipo: Numérico · Ocor.: 0-1 · Tam.: 7 · Dec.: 2-4
- Descrição: Alíquota específica por unidade de medida | apropriada
- Observação Mastersaf: 7 posições, sendo 3 inteiros e 2 a 4 decimais

**Linha 908 — `vIS`** (pos. 324.11, nível 6)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 15 · Dec.: 2
- Descrição: Valor do Imposto Seletivo
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 909 — `--sequencia_XML_ini--;`** (pos. 324.08, nível 6)

- Ocor.: 0-1
- Descrição: Sequência XML
- Observação SEFAZ/NT: Grupo Opcional.

**Linha 910 — `uTrib`** (pos. 324.09, nível 7)

- Tipo: Caractere · Ocor.: 1-1 · Tam.: 1-6
- Descrição: Unidade de Medida Tributável

**Linha 911 — `qTrib`** (pos. 324.10, nível 7)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 15 · Dec.: 0 ou 4
- Descrição: Quantidade Tributável
- Observação Mastersaf: 15 posições, sendo 11 inteiros e 0 ou 4 decimais

**Linha 912 — `--sequencia_XML_fim--;`** (pos. sem pos., nível 6)


**Linha 913 — `--seqSeletivo_fim--;`** (pos. sem pos., nível 5)


**Linha 914 — `--IS_fim--;`** (pos. sem pos., nível 4)


#### `gAjusteCompet` (324.112) — ajuste de competência no item

**Linha 1087 — `--gAjusteCompet_ini--;`** (pos. 324.112, nível 6)

- Tipo: CG · Ocor.: 1-1
- Descrição: Ajuste de Competência
- Observação SEFAZ/NT: Se trata de um CG (indica que o campo é um Elemento que deriva de uma Escolha (Choice), ou é necessário enviar gTransfCred ou gAjusteCompet ou gIBSCBSMono ou gIBSCBS). | Observação: a obrigatoriedade ou vedação do | preenchimento deste grupo está condicionada | ao indicador “ind_gAjusteCompet” da tabela de | CST do IBS e da CBS.

**Linha 1088 — `competApur`** (pos. 324113, nível 7)

- Tipo: Caractere · Ocor.: 1-1 · Tam.: 7
- Descrição: Ano e mês referência do período de apuração (AAAA-MM)
- Observação SEFAZ/NT: Informar período atual ou retroativo.

**Linha 1089 — `vIBS`** (pos. 324114, nível 7)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 15 · Dec.: 2
- Descrição: Valor do IBS
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 1090 — `vCBS`** (pos. 324115, nível 7)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 15 · Dec.: 2
- Descrição: Valor da CBS
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 1091 — `--gAjusteCompet_fim--;`** (pos. sem pos., nível 6)


#### `gEstornoCred` (324116) — estorno de crédito no item

**Linha 1093 — `--gEstornoCred_ini--;`** (pos. 324116, nível 5)

- Tipo: G · Ocor.: 0-1

**Linha 1094 — `vIBSEstCred`** (pos. 324.17, nível 6)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 15 · Dec.: 2
- Descrição: Valor do IBS a ser estornado
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 1095 — `vCBSEstCred`** (pos. 324.18, nível 6)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 15 · Dec.: 2
- Descrição: Valor da CBS a ser estornada
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 1096 — `--gEstornoCred_fim--;`** (pos. sem pos., nível 5)


#### `ISTot` (355.1) — total do Imposto Seletivo

**Linha 1193 — `--ISTot_ini--;`** (pos. 355.1, nível 2)

- Tipo: Grupo · Ocor.: 0-1
- Descrição: Grupo total do imposto seletivo
- Observação SEFAZ/NT: O grupo de valores totais da NF-e deve ser informado com o somatório do campo correspondente dos itens. | O IS é “por fora”, portanto seu valor deve ser adicionado ao valor total da NF.

**Linha 1194 — `vIS`** (pos. 355.3, nível 3)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 15 · Dec.: 2
- Descrição: Total do imposto seletivo
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 1195 — `--ISTot_fim--;`** (pos. sem pos., nível 2)


#### `gEstornoCred` (355.29e) — estorno de crédito no total

**Linha 1228 — `--gEstornoCred_ini--;`** (pos. 355.29e, nível 3)

- Tipo: Grupo · Ocor.: 0-1
- Descrição: Grupo total do Estorno de Crédito
- Observação SEFAZ/NT: Grupo Opcional.

**Linha 1229 — `vIBSEstCred`** (pos. 355.29f, nível 4)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 15 · Dec.: 2
- Descrição: Valor total do IBS estornado
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 1230 — `vCBSEstCred`** (pos. 355.29g, nível 4)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 15 · Dec.: 2
- Descrição: Valor total da CBS estornada
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 1231 — `--gEstornoCred_fim--;`** (pos. sem pos., nível 3)


#### Fechamento do grupo `total` — `vNFTot` e `vProdLiqTot`

**Linha 1232 — `--IBSCBSTot_fim--;`** (pos. sem pos., nível 2)


**Linha 1233 — `vNFTot`** (pos. 355.30, nível 2)

- Tipo: Numérico · Ocor.: 0-1 · Tam.: 15 · Dec.: 2
- Descrição: Valor total da NF-e com IBS / CBS / IS
- Observação SEFAZ/NT: A partir de 2027, os valores de IBS, CBS e IS já compõem o vProd e não devem ser somados novamente neste total. (Incluído na NT 2026.008)
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 1234 — `vProdLiqTot`** (pos. 326a, nível 2)

- Tipo: Numérico · Ocor.: 0-1 · Tam.: 15 · Dec.: 2
- Descrição: Valor Total Líquido dos Produtos ou Serviços (sem tributos)
- Observação SEFAZ/NT: Soma dos valores líquidos dos produtos ou serviços, sem a inclusão de tributos. Campo do grupo total (fora do grupo icms_Tot). No XML, é gerado como primeira tag de total, antes de ICMSTot (a posição no TXT não altera a ordem no XML). Deve ser informado quando algum item informar vProdLiq. (Incluído na NT 2026.008) Atenção: posição alterada em relação à prévia publicada em 15/10/2026 (antes ao final do grupo icms_Tot).
- Observação Mastersaf: 15 posições, sendo 13 inteiros e 2 decimais

**Linha 1235 — `--total_fim--;`** (pos. sem pos., nível 1)


#### `gPgtoVinc` (398.50) — vinculação da transação de pagamento (NT 2026.006)

**Linha 1322 — `--gPgtoVinc_ini--;`** (pos. 398.50, nível 1)

- Ocor.: 0-1
- Descrição: Grupo de informações da Vinculação com a Transação de Pagamento (YC01)
- Observação SEFAZ/NT: Informar sempre que a transação de pagamento for iniciada antes da emissão do DF-e (ex.: boleto gerado antes da emissão; QR Code dinâmico Pix gerado antes da emissão), ainda que a transação esteja pendente de pagamento e liquidação. Campos de caráter preparatório: não há exigência de preenchimento em produção em 2026; a ativação ocorrerá com a entrada em vigência do split payment, prevista para 2027. O preenchimento deste grupo não exclui a obrigação dos grupos Formas de Pagamento (YA) e Informações do Intermediador da Transação (YB). (Incluído na NT 2026.006)

**Linha 1323 — `--gPgto_ini--;`** (pos. 398.51, nível 2)

- Ocor.: 1-99
- Descrição: Dados de cada pagamento previsto para o DF-e (YC02)
- Observação SEFAZ/NT: Cada ocorrência representa uma transação financeira vinculada ao documento. (Incluído na NT 2026.006)

**Linha 1324 — `nPag`** (pos. 398.52, nível 3)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 3
- Descrição: Número sequencial do pagamento (YC03)
- Observação SEFAZ/NT: Atributo numerador único de cada ocorrência de pagamento. O schema impede valores duplicados (rejeição 215 - falha no esquema XML). (Incluído na NT 2026.006)
- Observação Mastersaf: 3 posições

**Linha 1325 — `idTransacao`** (pos. 398.53, nível 3)

- Tipo: Caractere · Ocor.: 1-1 · Tam.: 2-35
- Descrição: Identificador da transação financeira (YC04)
- Observação SEFAZ/NT: Identificador da transação financeira, de acordo com a transação de pagamento. O schema impede valores duplicados (rejeição 215 - falha no esquema XML). (Incluído na NT 2026.006)

**Linha 1326 — `tpMeioPgto`** (pos. 398.54, nível 3)

- Tipo: Numérico · Ocor.: 1-1 · Tam.: 2
- Descrição: Código do meio de pagamento (YC05)
- Observação SEFAZ/NT: Informar o código conforme a Tabela Nacional de Códigos de Meios de Pagamento (Informe Técnico 2026.001 dos DF-e), com 2 posições (ex.: 01). Código inválido gera a rejeição 1273. (Incluído na NT 2026.006)
- Observação Mastersaf: 2 posições

**Linha 1327 — `CNPJReceb`** (pos. 398.55, nível 3)

- Tipo: Caractere · Ocor.: 1-1 · Tam.: 14
- Descrição: CNPJ do recebedor do pagamento (YC06)
- Observação SEFAZ/NT: CNPJ completo do recebedor do pagamento (fornecedor, plataforma ou outra entidade que receba o pagamento do adquirente). Pode ser diferente do CNPJ do fornecedor do documento fiscal. Informar zeros não significativos. CNPJ inválido gera a rejeição 1274. (Incluído na NT 2026.006)

**Linha 1328 — `CNPJBasePSP`** (pos. 398.56, nível 3)

- Tipo: Caractere · Ocor.: 1-1 · Tam.: 8
- Descrição: CNPJ base da instituição financeira ou de pagamento (YC07)
- Observação SEFAZ/NT: CNPJ base (8 posições) da instituição financeira ou de pagamento utilizada pelo recebedor do pagamento. Informar zeros não significativos. (Incluído na NT 2026.006)

**Linha 1329 — `--gPgto_fim--;`** (pos. sem pos., nível 2)


**Linha 1330 — `--gPgtoVinc_fim--;`** (pos. sem pos., nível 1)

---

## 7. Mapa de blocos (árvore completa)

Os 240 blocos da aba, na ordem de gravação, com posição, faixa de linhas do TXT e ocorrência. A indentação reflete o aninhamento real.

- `nota` (s/pos) — linhas 1-1398, ocor. 1-1
  - `versao_Layout_DFe` (s/pos) — linhas 2-4, ocor. 0-1
  - `inf_NFe` (1) — linhas 5-8, ocor. 1-1
  - `param_gerais` (s/pos) — linhas 9-24, ocor. 0-1
    - `contingencia_externa` (s/pos) — linhas 13-19, ocor. 0-1
  - `ide` (5) — linhas 25-95, ocor. 1-1
    - `x_contingencia` (29b.1) — linhas 52-55, ocor. 0-1
    - `gCompraGov` (29.z1) — linhas 56-63, ocor. 0-1
      - `ref_NFe` (29.z5a) — linhas 60-62, ocor. 0-99
    - `gPagAntecipado` (29.y1) — linhas 64-66, ocor. 0-99
    - `nfReferenciada` (29x.1) — linhas 67-94, ocor. 0-999
      - `ref_NFe` (29x.3) — linhas 70-77, ocor. 1-1
      - `ref_NFP` (29x.10) — linhas 78-87, ocor. 1-1
      - `ref_ECF` (29x.20) — linhas 89-93, ocor. 1-1
  - `emit` (30) — linhas 96-122, ocor. 1-1
    - `ender_Emit` (34) — linhas 101-113, ocor. 1-1
    - `x_emitente` (47.1) — linhas 116-119, ocor. 0-1
  - `avulsa` (50) — linhas 123-135, ocor. 0-1
  - `dest` (62) — linhas 136-159, ocor. 0-1
    - `ender_Dest` (66) — linhas 141-153, ocor. 0-1
  - `retirada` (80) — linhas 160-177, ocor. 0-1
  - `entrega` (89) — linhas 178-195, ocor. 0-1
  - `aut_XML` (97a.1) — linhas 196-199, ocor. 0-10
  - `item_nota` (s/pos) — linhas 200-1137, ocor. 1-900
    - `det` (98) — linhas 201-1136, ocor. 1-1
      - `prod` (100) — linhas 203-363, ocor. 1-1
        - `nve` (s/pos) — linhas 209-211, ocor. 0-8
        - `sequencia_XML` (104b) — linhas 212-216, ocor. 0-1
        - `gCred` (s/pos) — linhas 236-240, ocor. 0-4
        - `di` (117) — linhas 241-261, ocor. 0-100
          - `adi` (124) — linhas 254-260, ocor. 1-999
        - `det_Export` (128f) — linhas 262-269, ocor. 0-500
          - `export_Ind` (128h) — linhas 264-268, ocor. 0-1
        - `rastro` (128q) — linhas 273-279, ocor. 0-500
        - `prod_especifico` (128x) — linhas 280-348, ocor. 0-1
          - `veic_Prod` (129) — linhas 281-306, ocor. 1-1
          - `medicamento` (152) — linhas 307-311, ocor. 1-1
          - `armamento` (158) — linhas 312-317, ocor. 1-500
          - `comb` (162a) — linhas 318-346, ocor. 1-1
            - `cide` (162f) — linhas 328-332, ocor. 0-1
            - `encerrante` (162j) — linhas 333-339, ocor. 0-1
            - `origComb` (162r) — linhas 341-345, ocor. 0-30
        - `obsItem` (325a) — linhas 349-358, ocor. 0-1
          - `obsCont` (325b) — linhas 350-353, ocor. 0-1
          - `obsFisco` (325e) — linhas 354-357, ocor. 0-1
        - `sequencia_XML_liq` (110.01) — linhas 359-362, ocor. 0-1
      - `impostos` (163) — linhas 364-1119, ocor. 1-1
        - `ICMS` (164) — linhas 366-762, ocor. 0-1
          - `icms_00` (165) — linhas 367-378, ocor. 1-1
            - `sequencia_XML` (171.0) — linhas 374-377, ocor. 0-1
          - `icms_02` (172.3) — linhas 379-385, ocor. 1-1
          - `icms_10` (172) — linhas 386-413, ocor. 1-1
            - `sequencia_XML_FCP` (178.0) — linhas 393-397, ocor. 0-1
            - `sequencia_XML_FCPST` (184.0) — linhas 404-408, ocor. 0-1
            - `x_icmsst10_deson` (184.5) — linhas 409-412, ocor. 0-1
          - `icms_15` (184.8) — linhas 414-427, ocor. 1-1
            - `sequencia_XML` (184.8g) — linhas 423-426, ocor. 0-1
          - `icms_20` (185) — linhas 428-446, ocor. 1-1
            - `sequencia_XML` (192.0) — linhas 436-440, ocor. 0-1
            - `x_icms20_deson` (192.1) — linhas 441-445, ocor. 0-1
          - `icms_30` (193) — linhas 447-466, ocor. 1-1
            - `sequencia_XML` (201.0) — linhas 456-460, ocor. 0-1
            - `x_icms30_deson` (201.1) — linhas 461-465, ocor. 0-1
          - `icms_40` (202) — linhas 467-475, ocor. 1-1
            - `x_icms40_deson` (204.00) — linhas 470-474, ocor. 0-1
          - `icms_51` (205) — linhas 476-498, ocor. 1-1
            - `sequencia_XML` (212.0) — linhas 488-492, ocor. 0-1
            - `sequencia_XML_FCP_diferido` (212.1) — linhas 493-497, ocor. 0-1
          - `icms_53` (212.d) — linhas 499-508, ocor. 1-1
          - `icms_60` (213) — linhas 509-529, ocor. 1-1
            - `x_icms60_retido` (215.1) — linhas 512-517, ocor. 0-1
            - `sequencia_XML` (217.0) — linhas 518-522, ocor. 0-1
            - `x_icms_efetivo` (217.1) — linhas 523-528, ocor. 0-1
          - `icms_61` (217.6) — linhas 530-536, ocor. 1-1
          - `icms_70` (218) — linhas 537-570, ocor. 1-1
            - `sequencia_XML_FCP` (225.0) — linhas 545-549, ocor. 0-1
            - `sequencia_XML_FCPST` (231.0) — linhas 556-560, ocor. 0-1
            - `x_icms70_deson` (231.1) — linhas 561-565, ocor. 0-1
            - `x_icmsst70_deson` (231.4) — linhas 566-569, ocor. 0-1
          - `icms_90` (232) — linhas 571-619, ocor. 1-1
            - `x_icms90_icms` (234.1) — linhas 574-596, ocor. 0-1
              - `sequencia_XML_op` (238.0) — linhas 581-585, ocor. 0-1
              - `sequencia_XML` (239.01) — linhas 586-590, ocor. 0-1
              - `sequencia_XML_fcpdif` (239.05) — linhas 591-595, ocor. 0-1
            - `x_icms90_icmsst` (239.1) — linhas 597-609, ocor. 0-1
              - `sequencia_XML` (245.0) — linhas 604-608, ocor. 0-1
            - `x_icms90_deson` (245.1) — linhas 610-614, ocor. 0-1
            - `x_icmsst90_deson` (245.4) — linhas 615-618, ocor. 0-1
          - `icms_part` (245.01) — linhas 620-646, ocor. 1-1
            - `sequencia_XML` (245.14a) — linhas 634-638, ocor. 0-1
            - `sequencia_XML_deson` (245.17) — linhas 641-645, ocor. 0-1
          - `icms_st` (245.17) — linhas 647-667, ocor. 1-1
            - `sequencia_XML` (245.21a) — linhas 654-658, ocor. 0-1
            - `x_icms_efetivo` (245.23a) — linhas 661-666, ocor. 0-1
          - `icms_sn101` (245.24) — linhas 668-673, ocor. 1-1
          - `icms_sn102` (245.24) — linhas 674-677, ocor. 1-1
          - `icms_sn201` (245.27) — linhas 678-694, ocor. 1-1
            - `sequencia_XML` (245.35.0) — linhas 687-691, ocor. 0-1
          - `icms_sn202` (245.38) — linhas 695-709, ocor. 1-1
            - `sequencia_XML` (245.46.0) — linhas 704-708, ocor. 0-1
          - `icms_sn500` (245.47) — linhas 710-730, ocor. 1-1
            - `x_sn500_retido` (245.50) — linhas 713-718, ocor. 0-1
            - `sequencia_XML` (245.51.0) — linhas 719-723, ocor. 0-1
            - `x_icms_efetivo` (245.51.1) — linhas 724-729, ocor. 0-1
          - `icms_sn900` (245.52) — linhas 731-758, ocor. 1-1
            - `x_sn900_icms` (245.55) — linhas 734-740, ocor. 0-1
            - `x_sn900_icmsst` (245.60) — linhas 741-748, ocor. 0-1
            - `sequencia_XML` (245.65.0) — linhas 749-753, ocor. 0-1
            - `x_sn900_credito` (245.52) — linhas 754-757, ocor. 0-1
          - `ICMS_Previsto` (245b.01) — linhas 759-761, ocor. 0-1
        - `ICMS_UF_Dest` (245a.01) — linhas 763-773, ocor. 0-1
        - `IPI` (246) — linhas 774-794, ocor. 0-1
          - `ipi_trib` (252) — linhas 779-790, ocor. 1-1
            - `x_ipi_aliq` (253.1) — linhas 781-784, ocor. 1-1
            - `x_ipi_unid` (257.1) — linhas 785-788, ocor. 1-1
          - `ipi_nt` (260) — linhas 791-793, ocor. 1-1
        - `II` (262) — linhas 795-800, ocor. 0-1
        - `PIS` (267) — linhas 801-829, ocor. 0-1
          - `pis_aliq` (268) — linhas 802-807, ocor. 1-1
          - `pis_qtde` (273) — linhas 808-813, ocor. 1-1
          - `pis_nt` (278) — linhas 814-816, ocor. 1-1
          - `pis_outr` (280) — linhas 817-828, ocor. 1-1
            - `x_pis_percent` (281.1) — linhas 819-822, ocor. 1-1
            - `x_pis_valor` (283.1) — linhas 823-826, ocor. 1-1
        - `PISST` (287) — linhas 830-841, ocor. 0-1
          - `x_pisst_percent` (287.1) — linhas 831-834, ocor. 1-1
          - `x_pisst_valor` (289.1) — linhas 835-838, ocor. 1-1
        - `COFINS` (293) — linhas 842-870, ocor. 0-1
          - `cofins_aliq` (294) — linhas 843-848, ocor. 1-1
          - `cofins_qtde` (299) — linhas 849-854, ocor. 1-1
          - `cofins_nt` (304) — linhas 855-857, ocor. 1-1
          - `cofins_outr` (306) — linhas 858-869, ocor. 1-1
            - `x_cofinsoutr_percent` (307.1) — linhas 860-863, ocor. 1-1
            - `x_cofinsoutr_valor` (309.1) — linhas 864-867, ocor. 1-1
        - `COFINSST` (313) — linhas 871-882, ocor. 0-1
          - `x_cofinsst_percent` (313.1) — linhas 872-875, ocor. 1-1
          - `x_cofinsst_valor` (315.1) — linhas 876-879, ocor. 1-1
        - `ISSQN` (319) — linhas 883-900, ocor. 0-1
        - `IS` (324.01) — linhas 901-914, ocor. 0-1
          - `seqSeletivo` (324.04) — linhas 904-913, ocor. 0-1
            - `sequencia_XML` (324.08) — linhas 909-912, ocor. 0-1
        - `IBSCBS` (324.12) — linhas 915-1118, ocor. 0-1
          - `sequencia_XML_IBSCBS` (324.14k) — linhas 919-1092, ocor. —
            - `gIBSCBS` (324.15) — linhas 920-995, ocor. 1-1
              - `gIBSUF` (324.17) — linhas 923-938, ocor. 1-1
                - `gDif` (324.21) — linhas 926-929, ocor. 0-1
                - `gDevTrib` (324..24) — linhas 930-933, ocor. 0-1
                - `gRed` (324.26) — linhas 934-937, ocor. 0-1
              - `gIBSMun` (324.36) — linhas 939-954, ocor. 1-1
                - `gDif` (324.40) — linhas 942-945, ocor. 0-1
                - `gDevTrib` (324.43) — linhas 946-949, ocor. 0-1
                - `gRed` (324.45) — linhas 950-953, ocor. 0-1
              - `gCBS` (324.55) — linhas 955-976, ocor. 1-1
                - `gDif` (324.59) — linhas 958-961, ocor. 0-1
                - `gDevTrib` (324.62) — linhas 962-965, ocor. 0-1
                - `gRed` (324.64) — linhas 966-969, ocor. 0-1
                - `gALCZFMCBS` (324.66a) — linhas 970-975, ocor. 0-1
              - `gTribRegular` (324.68) — linhas 977-986, ocor. 0-1
              - `gTribCompraGov` (324.82a) — linhas 987-994, ocor. 0-1
            - `gIBSCBSMono` (324.84) — linhas 996-1082, ocor. 1-1
              - `sequencia_XML_IBSMono` (324.85) — linhas 997-1039, ocor. 0-1
                - `gIBSMonoAdRem` (324.85a) — linhas 998-1016, ocor. 0-1
                  - `gMonoPadrao` (324.86) — linhas 999-1003, ocor. 0-1
                  - `gMonoReten` (324.87) — linhas 1004-1008, ocor. 0-1
                  - `gMonoRet` (324.88) — linhas 1009-1011, ocor. 0-1
                  - `gpBioDiferenca` (324.89) — linhas 1012-1015, ocor. 0-1
                - `gIBSMonoAdValorem` (324.90) — linhas 1017-1038, ocor. 0-1
                  - `gMonoPadrao` (324.91) — linhas 1018-1025, ocor. 0-1
                  - `gMonoReten` (324.92) — linhas 1026-1030, ocor. 0-1
                  - `gMonoRet` (324.93) — linhas 1031-1033, ocor. 0-1
                  - `gpBioDiferenca` (324.94) — linhas 1034-1037, ocor. 0-1
              - `sequencia_XML_CBSMono` (324.95) — linhas 1040-1079, ocor. 0-1
                - `gCBSMonoAdRem` (324.95a) — linhas 1041-1059, ocor. 0-1
                  - `gMonoPadrao` (324.96) — linhas 1042-1046, ocor. 0-1
                  - `gMonoReten` (324.97) — linhas 1047-1051, ocor. 0-1
                  - `gMonoRet` (324.98) — linhas 1052-1054, ocor. 0-1
                  - `gpBioDiferenca` (324.99) — linhas 1055-1058, ocor. 0-1
                - `gCBSMonoAdValorem` (324.100) — linhas 1060-1078, ocor. 0-1
                  - `gMonoPadrao` (324.101) — linhas 1061-1065, ocor. 0-1
                  - `gMonoReten` (324.102) — linhas 1066-1070, ocor. 0-1
                  - `gMonoRet` (324.103) — linhas 1071-1073, ocor. 0-1
                  - `gpBioDiferenca` (324.104) — linhas 1074-1077, ocor. 0-1
            - `gTransfCred` (324.106) — linhas 1083-1086, ocor. 1-1
            - `gAjusteCompet` (324.112) — linhas 1087-1091, ocor. 1-1
          - `gEstornoCred` (324116) — linhas 1093-1096, ocor. 0-1
          - `sequencia_XML_cred_pres` (324119) — linhas 1097-1117, ocor. 0-1
            - `gCredPresOper` (324.120) — linhas 1098-1111, ocor. 1-1
              - `gIBSCredPres` (324.123) — linhas 1101-1105, ocor. 0-1
              - `gCBSCredPres` (324.127) — linhas 1106-1110, ocor. 0-1
            - `gCredPresIBSZFM` (324.131) — linhas 1112-1116, ocor. 1-1
      - `imposto_devol` (324p) — linhas 1120-1125, ocor. 0-1
        - `ipi_devol` (324r) — linhas 1122-1124, ocor. 1-1
      - `inf_adicionais` (s/pos) — linhas 1126-1128, ocor. 0-1
      - `vItem` (325h.1) — linhas 1129-1131, ocor. 0-1
      - `DFeReferenciado` (325i) — linhas 1132-1135, ocor. 0-1
  - `total` (326) — linhas 1138-1235, ocor. 1-1
    - `icms_Tot` (327) — linhas 1139-1169, ocor. 1-1
    - `issqn_Tot` (342) — linhas 1170-1183, ocor. 0-1
    - `ret_Trib` (348) — linhas 1184-1192, ocor. 0-1
    - `ISTot` (355.1) — linhas 1193-1195, ocor. 0-1
    - `IBSCBSTot` (355.4) — linhas 1196-1232, ocor. 0-1
      - `gIBS_Tot` (355.6) — linhas 1198-1212, ocor. 0-1
        - `gIBSUF_Tot` (355.7) — linhas 1199-1203, ocor. 1-1
        - `gIBSMun_Tot` (355.12) — linhas 1204-1208, ocor. 1-1
      - `gCBS_Tot` (355.20) — linhas 1213-1219, ocor. 0-1
      - `gMono_Tot` (355.27) — linhas 1220-1227, ocor. 0-1
      - `gEstornoCred` (355.29e) — linhas 1228-1231, ocor. 0-1
  - `inf_transporte` (s/pos) — linhas 1236-1282, ocor. —
    - `transp` (356) — linhas 1237-1239, ocor. 1-1
    - `transporta` (358) — linhas 1240-1248, ocor. 0-1
    - `ret_Transp` (366) — linhas 1249-1256, ocor. 0-1
    - `x_transp_diversos` (372.1) — linhas 1257-1268, ocor. 0-1
      - `veic_Transp` (373) — linhas 1258-1262, ocor. 0-1
      - `reboque` (377) — linhas 1263-1267, ocor. 0-5
    - `volume` (381) — linhas 1271-1281, ocor. 0-5000
      - `lacre` (387a) — linhas 1278-1280, ocor. 0-5000
  - `cobr` (389) — linhas 1283-1295, ocor. 0-1
    - `fat` (390) — linhas 1284-1289, ocor. 0-1
    - `duplicata` (395) — linhas 1290-1294, ocor. 0-120
  - `pag` (398a) — linhas 1296-1317, ocor. 1-1
    - `detPag` (398a1) — linhas 1297-1315, ocor. 1-100
      - `sequencia_XML_detPag` (398.13b) — linhas 1303-1306, ocor. 0-1
      - `card` (398d) — linhas 1307-1314, ocor. 0-1
  - `infIntermed` (398j) — linhas 1318-1321, ocor. 0-1
  - `gPgtoVinc` (398.50) — linhas 1322-1330, ocor. 0-1
    - `gPgto` (398.51) — linhas 1323-1329, ocor. 1-99
  - `inf_Adic` (399) — linhas 1331-1347, ocor. 0-1
    - `uso_livre_c` (401a) — linhas 1334-1337, ocor. 0-10
    - `uso_livre_f` (401d) — linhas 1338-1341, ocor. 0-10
    - `proc_referenciado` (401g) — linhas 1342-1346, ocor. 0-100
  - `exporta` (402) — linhas 1348-1352, ocor. 0-1
  - `compra` (405) — linhas 1353-1357, ocor. 0-1
  - `cana` (409) — linhas 1358-1375, ocor. 0-1
    - `cana_forn_diario` (412) — linhas 1361-1364, ocor. 1-31
    - `cana_deducao` (418) — linhas 1368-1371, ocor. 0-10
  - `infRespTec` (423a) — linhas 1376-1385, ocor. 0-1
    - `seq_XML` (423f) — linhas 1381-1384, ocor. 0-1
  - `agropecuario` (424) — linhas 1386-1397, ocor. 0-1
    - `defensivo` (424a) — linhas 1387-1390, ocor. 1-20
    - `guiaTransito` (424d) — linhas 1391-1396, ocor. 1-1

---

## 8. Tabela completa — posição × tag (1.399 linhas)

Todas as linhas da aba `Envio NFe_NFCe - 4.00 -DFe 4.19`, na ordem exata de gravação do TXT. As seções seguem o aninhamento dos blocos; blocos com mais de 170 linhas são subdivididos pelos seus filhos diretos, e a sequência `Nº` é contínua e nunca se repete — basta ordená-la para reconstituir o arquivo inteiro.

### `nota` — pos. sem pos. · linhas 1–1398 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1 | — | 0 | **`--nota_ini--;`** | — | 1-1 | — | — | TAG raiz da NF-e |

#### `versao_Layout_DFe` — pos. sem pos. · linhas 2–4 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 2 | — | 1 | **`--versao_Layout_DFe_ini--;`** | — | 0-1 | — | `nota` | Informações de Layout DFE |
| 3 | — | 2 | `versaoLayoutDFe` | Numérico | 1-1 | 5,2 | `versao_Layout_DFe` | Versão do layout DFE |
| 4 | — | 1 | `--versao_Layout_DFe_fim--;` | — | — | — | `nota` |  |

#### `inf_NFe` — pos. 1 · linhas 5–8 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 5 | 1 | 1 | **`--inf_NFe_ini--;`** | — | 1-1 | — | `nota` | Informações da NF-e |
| 6 | 2 | 2 | `versao` | Numérico | 1-1 | 1-4,2 | `inf_NFe` | Versão do leiaute NF-e (Fisco) |
| 7 | 3 | 2 | `id` | Caractere | 1-1 | 47 | `inf_NFe` | Identificador da TAG a ser assinado |
| 8 | — | 1 | `--inf_NFe_fim--;` | — | — | — | `nota` |  |

#### `param_gerais` — pos. sem pos. · linhas 9–24 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 9 | — | 1 | **`--param_gerais_ini--;`** | — | 0-1 | — | `nota` |  |
| 10 | M2 | 2 | `dsImpressora` | Caractere | 0-1 | 1-100 | `param_gerais` | Nome da impressora que será utilizada para imprimir está NF-e. |
| 11 | M3 | 2 | `numeroEmbarque` | Caractere | 0-1 | 1-20 | `param_gerais` | Número da ordem de embarque |
| 12 | M4 | 2 | `nrItens` | Numérico | 0-1 | 1-3 | `param_gerais` | Total de itens |
| 13 | — | 2 | **`--contingencia_externa_ini--;`** | — | 0-1 | — | `param_gerais` |  |
| 14 | M6 | 3 | `flag_conting_ext` | Caractere | 0-1 | 1-256 | `contingencia_externa` | Flag de contingência |
| 15 | M7 | 3 | `Dt_Ent_Cont` | Data | 0-1 | 19 | `contingencia_externa` | Inicio da entrada em contingência |
| 16 | M8 | 3 | `Dt_Sai_Cont` | Data | 0-1 | 19 | `contingencia_externa` | Termino da saída de contingência |
| 17 | M9 | 3 | `Mot_Cont_ext` | Caractere | 0-1 | 1-256 | `contingencia_externa` | Motivo de contingência |
| 18 | M10 | 3 | `cEvento` | Caractere | 0-1 | 6 | `contingencia_externa` | Código do evento de emissão EPEC (110140) |
| 19 | — | 2 | `--contingencia_externa_fim--;` | — | — | — | `param_gerais` |  |
| 20 | M11 | 2 | `usuarioEmitente` | Caractere | 0-1 | 0-20 | `param_gerais` | Nome do usuário que emitiu a nota no ERP. |
| 21 | M12 | 2 | `campoUsoInterno` | Caractere | 0-1 | 255 | `param_gerais` | Campo livre para uso interno |
| 22 | M13 | 2 | `enviaPrinter` | Numérico | 0-1 | 1 | `param_gerais` | Define se o documento será enviado para o Printer |
| 23 | M14 | 2 | `nomenclaturaArquivos` | Caractere | 0-1 | 0-100 | `param_gerais` | Nomenclatura específica para os arquivos PDF e XML gravados pelo Printer |
| 24 | — | 1 | `--param_gerais_fim--;` | — | — | — | `nota` |  |

#### `ide` — pos. 5 · linhas 25–95 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 25 | 5 | 1 | **`--ide_ini--;`** | — | 1-1 | — | `nota` | Informações de identificação da NF-e |
| 26 | 6 | 2 | `cUF` | Numérico | 1-1 | 2 | `ide` | Código da UF do emitente do Documento Fiscal |
| 27 | 7 | 2 | `cNF` | Numérico | 1-1 | 8 | `ide` | Código Numérico que compõe a Chave de Acesso |
| 28 | 8 | 2 | `natOp` | Caractere | 1-1 | 1-60 | `ide` | Descrição da Natureza da Operação |
| 29 | 10 | 2 | `mod` | Numérico | 1-1 | 2 | `ide` | Código do Modelo do Documento Fiscal |
| 30 | 11 | 2 | `serie` | Numérico | 1-1 | 1-3 | `ide` | Série do Documento Fiscal |
| 31 | 12 | 2 | `nNF` | Numérico | 1-1 | 1-9 | `ide` | Número do Documento Fiscal |
| 32 | 13 | 2 | `dhEmi` | Data | 0-1 | — | `ide` | Data e hora de emissão do Documento Fiscal |
| 33 | 14 | 2 | `dhSaiEnt` | Data | 0-1 | — | `ide` | Data e hora de Saída ou da Entrada da Mercadoria/Produto |
| 34 | 14a | 2 | `dPrevEntrega` | Data | 0-1 | 10 | `ide` | Data da previsão de entrega ou disponibilização do bem. |
| 35 | 15 | 2 | `tpNF` | Numérico | 1-1 | 1 | `ide` | Tipo de Operação |
| 36 | 15a | 2 | `idDest` | Numérico | 1-1 | 1 | `ide` | Identificador de local de destino da operação |
| 37 | 16 | 2 | `cMunFG` | Numérico | 1-1 | 7 | `ide` | Código do Município de Ocorrência do Fato Gerador do ICMS |
| 38 | 16a | 2 | `cMunFGIBS` | Numérico | 0-1 | 7 | `ide` | Código do Município de consumo, fato gerador do IBS / CBS |
| 39 | 25 | 2 | `tpImp` | Numérico | 1-1 | 1 | `ide` | Formato de impressão do DANFE |
| 40 | 26 | 2 | `tpEmis` | Numérico | 1-1 | 1 | `ide` | Forma de Emissão da NF-e |
| 41 | 27 | 2 | `cDV` | Numérico | 1-1 | 1 | `ide` | Dígito Verificador da Chave de Acesso da NF-e |
| 42 | 28 | 2 | `tpAmb` | Numérico | 1-1 | 1 | `ide` | Identificação do Ambiente |
| 43 | 29 | 2 | `finNFe` | Numérico | 1-1 | 1 | `ide` | Finalidade de emissão da NF-e |
| 44 | 29.1 | 2 | `tpNFDebito` | Numérico | 0-1 | 2 | `ide` | Tipo de Nota de Débito |
| 45 | 29.2 | 2 | `tpNFCredito` | Númerico | 0-1 | 2 | `ide` | Tipo de Nota de Crédito |
| 46 | 29.3 | 2 | `indFinal` | Numérico | 1-1 | 1 | `ide` | Indica operação com Consumidor final |
| 47 | 29.4 | 2 | `indPres` | Numérico | 1-1 | 1 | `ide` | Indicador de presença do comprador no estabelecimento comercial no momento da o… |
| 48 | 29.5 | 2 | `indIntermed` | Numérico | 0-1 | 1 | `ide` | Indicador de intermediador/marketplace |
| 49 | 29a | 2 | `procEmi` | — | 1-1 | 1 | `ide` | Processo de emissão a NF-e |
| 50 | 29b | 2 | `verProc` | Caractere | 1-1 | 1-20 | `ide` | Versão do Processo de emissão da NF-e |
| 51 | 29.6 | 2 | `cIndOp` | Numérico | 0-1 | 6 | `ide` | Código indicador do local da operação de / fornecimento |
| 52 | 29b.1 | 2 | **`--x_contingencia_ini--;`** | — | 0-1 | — | `ide` | Sequência XML |
| 53 | 29c | 3 | `dhCont` | Data | 1-1 | — | `x_contingencia` | data e hora da entrada em contingência |
| 54 | 29d | 3 | `xJust` | Caractere | 1-1 | 15-256 | `x_contingencia` | Justificativa da entrada em contingencia |
| 55 | — | 2 | `--x_contingencia_fim--;` | — | — | — | `ide` |  |
| 56 | 29.z1 | 2 | **`--gCompraGov_ini--;`** | — | 0-1 | — | `ide` | Grupo de Compra Governamental |
| 57 | 29.z2 | 3 | `tpEnteGov` | Númerico | 1-1 | 1 | `gCompraGov` | Tipo de ente governamental |
| 58 | 29.z3 | 3 | `pRedutor` | Númerico | 1-1 | 7,2-4 | `gCompraGov` | Percentual de redução de aliquota em compra governamental |
| 59 | 29.z4 | 3 | `tpOperGov` | Númerico | 1-1 | 1 | `gCompraGov` | Tipo de operação com o ente governamental |
| 60 | 29.z5a | 3 | **`--ref_NFe_ini--;`** | — | 0-99 | — | `gCompraGov` | Chave de acesso do documento fiscal anterior |
| 61 | 29.z5 | 4 | `refDFeAnt` | Caractere | 1-1 | 44 | `ref_NFe` | Chave de acesso do documento fiscal / anterior |
| 62 | — | 3 | `--ref_NFe_fim--;` | — | — | — | `gCompraGov` |  |
| 63 | — | 2 | `--gCompraGov_fim--;` | — | — | — | `ide` |  |
| 64 | 29.y1 | 2 | **`--gPagAntecipado_ini--;`** | — | 0-99 | — | `ide` | Grupo de notas de antecipação de pagamento |
| 65 | 29.y2 | 3 | `refNFe` | Caractere | 1-1 | 44 | `gPagAntecipado` | Chave de acesso da NF-e de antecipação de pagamento |
| 66 | — | 2 | `--gPagAntecipado_fim--;` | — | — | — | `ide` |  |
| 67 | 29x.1 | 2 | **`--nfReferenciada_ini--;`** | — | 0-999 | — | `ide` | Informação de Documentos Fiscais referenciados |
| 68 | 29x.2 | 3 | `refNFe` | Caractere | 1-1 | 44 | `nfReferenciada` | Chave de acesso das NF-e referenciadas |
| 69 | 29x.2a | 3 | `refNFeSig` | Caractere | 1-1 | 44 | `nfReferenciada` | Chave da NF-e com o código numérico zerado |
| 70 | 29x.3 | 3 | **`--ref_NFe_ini--;`** | — | 1-1 | — | `nfReferenciada` | Informação da NF modelo 1/1A ou NF modelo 2 referenciada |
| 71 | 29x.4 | 4 | `cUF` | Numérico | 1-1 | 2 | `ref_NFe` | Código da UF do emitente do Documento Fiscal |
| 72 | 29x.5 | 4 | `AAMM` | Numérico | 1-1 | 4 | `ref_NFe` | Ano e Mês de emissão da NF |
| 73 | 29x.6 | 4 | `CNPJ` | Caractere | 1-1 | 14 | `ref_NFe` | CNPJ do emitente da NF |
| 74 | 29x.7 | 4 | `Mod` | Numérico | 1-1 | 2 | `ref_NFe` | Modelo do Documento Fiscal |
| 75 | 29x.8 | 4 | `serie` | Numérico | 1-1 | 1-3 | `ref_NFe` | Série do Documento Fiscal(0para inexistente) |
| 76 | 29x.9 | 4 | `nNF` | Numérico | 1-1 | 1-9 | `ref_NFe` | Número do Documento Fiscal |
| 77 | — | 3 | `--ref_NFe_fim--;` | — | — | — | `nfReferenciada` |  |
| 78 | 29x.10 | 3 | **`--ref_NFP_ini--;`** | — | 1-1 | — | `nfReferenciada` | Informações da NF de Produtor rural referenciada |
| 79 | 29x.11 | 4 | `cUF` | Numérico | 1-1 | 2 | `ref_NFP` | Código da UF do emitente do Documento Fiscal |
| 80 | 29x.12 | 4 | `AAMM` | Numérico | 1-1 | 4 | `ref_NFP` | Ano e Mês de emissão da NF de Produtor |
| 81 | 29x.13 | 4 | `CNPJ` | Caractere | 1-1 | 14 | `ref_NFP` | CNPJ do emitente da NF de Produtor |
| 82 | 29x.14 | 4 | `CPF` | Caractere | 1-1 | 11 | `ref_NFP` | CPF do emitente da NF de Produtor |
| 83 | 29x.15 | 4 | `IE` | Caractere | 1-1 | 1-14 | `ref_NFP` | IE do emitente da NF de Produtor |
| 84 | 29x.16 | 4 | `mod` | Numérico | 1-1 | 2 | `ref_NFP` | Modelo do Documento Fiscal |
| 85 | 29x.17 | 4 | `serie` | Numérico | 1-1 | 1-3 | `ref_NFP` | Série do Documento Fiscal |
| 86 | 29x.18 | 4 | `nNF` | Numérico | 1-1 | 1-9 | `ref_NFP` | Número do documento Fiscal |
| 87 | — | 3 | `--ref_NFP_fim--;` | — | — | — | `nfReferenciada` |  |
| 88 | 29x.19 | 3 | `refCTe` | Caractere | 0-1 | 44 | `nfReferenciada` | Chave de acesso do CT-e referenciado |
| 89 | 29x.20 | 3 | **`--ref_ECF_ini--;`** | — | 1-1 | — | `nfReferenciada` | Informações do Cupom Fiscal referenciado |
| 90 | 29x.21 | 4 | `mod` | Caractere | 1-1 | 2 | `ref_ECF` | Modelo do Documento Fiscal |
| 91 | 29x.22 | 4 | `nECF` | Numérico | 1-1 | 3 | `ref_ECF` | Número de ordem sequencial do ECF |
| 92 | 29x.23 | 4 | `nCOO` | Numérico | 1-1 | 6 | `ref_ECF` | Numero do contador de ordem de operação – COO |
| 93 | — | 3 | `--ref_ECF_fim--;` | — | — | — | `nfReferenciada` |  |
| 94 | — | 2 | `--nfReferenciada_fim--;` | — | — | — | `ide` |  |
| 95 | — | 1 | `--ide_fim--;` | — | — | — | `nota` |  |

#### `emit` — pos. 30 · linhas 96–122 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 96 | 30 | 1 | **`--emit_ini--;`** | — | 1-1 | — | `nota` | Identificação do emitente da NF-e |
| 97 | 31 | 2 | `CNPJ` | Caractere | 1-1 | 14 | `emit` | CNPJ do emitente |
| 98 | 31a | 2 | `CPF` | Numérico | 1-1 | 11 | `emit` | CPF do emitente |
| 99 | 32 | 2 | `xNome` | Caractere | 1-1 | 2-60 | `emit` | Razão Social ou Nome do emitente |
| 100 | 33 | 2 | `xFant` | Caractere | 0-1 | 1-60 | `emit` | Nome Fantasia |
| 101 | 34 | 2 | **`--ender_Emit_ini--;`** | — | 1-1 | — | `emit` | Endereço do emitente |
| 102 | 35 | 3 | `xLgr` | Caractere | 1-1 | 2-60 | `ender_Emit` | Logradouro |
| 103 | 36 | 3 | `nro` | Caractere | 1-1 | 1-60 | `ender_Emit` | Número |
| 104 | 37 | 3 | `xCpl` | Caractere | 0-1 | 1-60 | `ender_Emit` | Complemento |
| 105 | 38 | 3 | `xBairro` | Caractere | 1-1 | 2-60 | `ender_Emit` | Bairro |
| 106 | 39 | 3 | `cMun` | Numérico | 1-1 | 7 | `ender_Emit` | Código do Município |
| 107 | 40 | 3 | `xMun` | Caractere | 1-1 | 2-60 | `ender_Emit` | Nome do município |
| 108 | 41 | 3 | `UF` | Caractere | 1-1 | 2 | `ender_Emit` | Sigla da UF |
| 109 | 42 | 3 | `CEP` | Numérico | 1-1 | 8 | `ender_Emit` | CEP |
| 110 | 43 | 3 | `cPais` | Numérico | 0-1 | 4 | `ender_Emit` | Código do País |
| 111 | 44 | 3 | `xPais` | Caractere | 0-1 | 1-60 | `ender_Emit` | Nome do País |
| 112 | 45 | 3 | `fone` | Numérico | 0-1 | 6-14 | `ender_Emit` | Telefone |
| 113 | — | 2 | `--ender_Emit_fim--;` | — | — | — | `emit` |  |
| 114 | 46 | 2 | `IE` | Caractere | 1-1 | 2-14 | `emit` | IE |
| 115 | 47 | 2 | `IEST` | Caractere | 0-1 | 2-14 | `emit` | IE do Substituto do Tributário |
| 116 | 47.1 | 2 | **`--x_emitente_ini--;`** | — | 0-1 | — | `emit` | Sequência XML |
| 117 | 48 | 3 | `IM` | Caractere | 1-1 | 1-15 | `x_emitente` | Código de Inscrição Municipal |
| 118 | 49 | 3 | `CNAE` | Caractere | 0-1 | 7 | `x_emitente` | CNAE fiscal |
| 119 | — | 2 | `--x_emitente_fim--;` | — | — | — | `emit` |  |
| 120 | 49a | 2 | `CRT` | Numérico | 1-1 | 1 | `emit` | Código de regime tributário |
| 121 | 49d | 2 | `ISUFEmit` | Caractere | 0-1 | 8-9 | `emit` | Inscrição do emitente da Suframa |
| 122 | — | 1 | `--emit_fim--;` | — | — | — | `nota` |  |

#### `avulsa` — pos. 50 · linhas 123–135 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 123 | 50 | 1 | **`--avulsa_ini--;`** | — | 0-1 | — | `nota` |  |
| 124 | 51 | 2 | `CNPJ` | Caractere | 1-1 | 14 | `avulsa` | CNPJ do emitente |
| 125 | 52 | 2 | `xOrgao` | Caractere | 1-1 | 1-60 | `avulsa` | Órgão Emitente |
| 126 | 53 | 2 | `matr` | Caractere | 1-1 | 1-60 | `avulsa` | Matrícula do agente |
| 127 | 54 | 2 | `xAgente` | Caractere | 1-1 | 1-60 | `avulsa` | Nome do agente |
| 128 | 55 | 2 | `fone` | Numérico | 0-1 | 6-14 | `avulsa` | Telefone |
| 129 | 56 | 2 | `UF` | Caractere | 1-1 | 2 | `avulsa` | Sigla da UF |
| 130 | 57 | 2 | `nDAR` | Caractere | 0-1 | 1-60 | `avulsa` | Número do Documento de Arrecadação de Receita |
| 131 | 58 | 2 | `dEmi` | Data | 0-1 | — | `avulsa` | Data de emissão do Documento de Arrecadação |
| 132 | 59 | 2 | `vDAR` | Numérico | 0-1 | 1-15,2 | `avulsa` | Valor Total constante no Documento de arrecadação de Receita |
| 133 | 60 | 2 | `repEmi` | Caractere | 1-1 | 1-60 | `avulsa` | Repartição Fiscal emitente |
| 134 | 61 | 2 | `dPag` | Data | 0-1 | — | `avulsa` | Data de pagamento do Documento de Arrecadação |
| 135 | — | 1 | `--avulsa_fim--;` | — | — | — | `nota` |  |

#### `dest` — pos. 62 · linhas 136–159 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 136 | 62 | 1 | **`--dest_ini--;`** | — | 0-1 | — | `nota` | Identificação do Destinatário da NF-e |
| 137 | 63 | 2 | `CNPJ` | Caractere | 1-1 | 14 | `dest` | CNPJ do destinatário |
| 138 | 64 | 2 | `CPF` | Numérico | 1-1 | 11 | `dest` | CNPJ do destinatário |
| 139 | 64a | 2 | `idEstrangeiro` | Caractere | 1-1 | 0, 5-20 | `dest` | Identificação do destinatário no caso de comprador estrangeiro |
| 140 | 65 | 2 | `xNome` | Caractere | 0-1 | 2-60 | `dest` | Razão Social ou nome do destinatário |
| 141 | 66 | 2 | **`--ender_Dest_ini--;`** | — | 0-1 | — | `dest` | Endereço do Destinatário da NF-e |
| 142 | 67 | 3 | `xLgr` | Caractere | 1-1 | 2-60 | `ender_Dest` | Logradouro |
| 143 | 68 | 3 | `nro` | Caractere | 1-1 | 1-60 | `ender_Dest` | Número |
| 144 | 69 | 3 | `xCpl` | Caractere | 0-1 | 1-60 | `ender_Dest` | Complemento |
| 145 | 70 | 3 | `xBairro` | Caractere | 1-1 | 2-60 | `ender_Dest` | Bairro |
| 146 | 71 | 3 | `cMun` | Numérico | 1-1 | 7 | `ender_Dest` | Código do município |
| 147 | 72 | 3 | `xMun` | Caractere | 1-1 | 2-60 | `ender_Dest` | Nome do município |
| 148 | 73 | 3 | `UF` | Caractere | 1-1 | 2 | `ender_Dest` | Sigla da UF |
| 149 | 74 | 3 | `CEP` | Numérico | 0-1 | 8 | `ender_Dest` | CEP |
| 150 | 75 | 3 | `cPais` | Numérico | 0-1 | 2-4 | `ender_Dest` | Código do País |
| 151 | 76 | 3 | `xPais` | Caractere | 0-1 | 2-60 | `ender_Dest` | Nome do País |
| 152 | 77 | 3 | `fone` | Numérico | 0-1 | 6-14 | `ender_Dest` | Telefone |
| 153 | — | 2 | `--ender_Dest_fim--;` | — | — | — | `dest` |  |
| 154 | 77a | 2 | `indIEDest` | Numérico | 1-1 | 1 | `dest` | Indicador da IE do Destinatário |
| 155 | 78 | 2 | `IE` | Numérico | 0-1 | 2-14 | `dest` | IE do Destinatário |
| 156 | 79 | 2 | `ISUF` | Caractere | 0-1 | 8-9 | `dest` | Inscrição na SUFRAMA(Obrigatório nas operações sob controle da SUFRAMA) |
| 157 | 79.1 | 2 | `IM` | Caractere | 0-1 | 1-15 | `dest` | Inscrição Municipal do Tomador do Serviço |
| 158 | 79a | 2 | `email` | Caractere | 0-1 | 1-60 | `dest` | e-mail |
| 159 | — | 1 | `--dest_fim--;` | — | — | — | `nota` |  |

#### `retirada` — pos. 80 · linhas 160–177 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 160 | 80 | 1 | **`--retirada_ini--;`** | — | 0-1 | — | `nota` | Identificação do Local de retirada |
| 161 | 81 | 2 | `CNPJ` | Caractere | 1-1 | 0 ou 14 | `retirada` | informar o CNPJ |
| 162 | 81a | 2 | `CPF` | Numérico | 1-1 | 11 | `retirada` | Informar o CPF |
| 163 | 81b | 2 | `xNome` | Caractere | 0-1 | 2-60 | `retirada` | Razão Social ou Nome do Expedidor |
| 164 | 82 | 2 | `xLgr` | Caractere | 1-1 | 2-60 | `retirada` | Logradouro |
| 165 | 83 | 2 | `nro` | Caractere | 1-1 | 1-60 | `retirada` | Número |
| 166 | 84 | 2 | `xCpl` | Caractere | 0-1 | 1-60 | `retirada` | Complemento |
| 167 | 85 | 2 | `xBairro` | Caractere | 1-1 | 2-60 | `retirada` | Bairro |
| 168 | 86 | 2 | `cMun` | Numérico | 1-1 | 7 | `retirada` | Código do Município |
| 169 | 87 | 2 | `xMun` | Caractere | 1-1 | 2-60 | `retirada` | Nome do município |
| 170 | 88 | 2 | `UF` | Caractere | 1-1 | 2 | `retirada` | Sigla da UF |
| 171 | 88a | 2 | `CEP` | Numérico | 0-1 | 8 | `retirada` | Código do CEP |
| 172 | 88b | 2 | `cPais` | Numérico | 0-1 | 4 | `retirada` | Código do País |
| 173 | 88c | 2 | `xPaís` | Caractere | 0-1 | 2-60 | `retirada` | Nome do País |
| 174 | 88d | 2 | `fone` | Numérico | 0-1 | 6-14 | `retirada` | Telefone |
| 175 | 88e | 2 | `email` | Caractere | 0-1 | 1-60 | `retirada` | E-mail do expedidor |
| 176 | 88f | 2 | `IE` | Numérico | 0-1 | 2-14 | `retirada` | Inscrição Estadual do Estabelecimento Expedidor |
| 177 | — | 1 | `--retirada_fim--;` | — | — | — | `nota` |  |

#### `entrega` — pos. 89 · linhas 178–195 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 178 | 89 | 1 | **`--entrega_ini--;`** | — | 0-1 | — | `nota` | Identificação do Local de entrega |
| 179 | 90 | 2 | `CNPJ` | Caractere | 1-1 | 0 ou 14 | `entrega` | CNPJ |
| 180 | 90a | 2 | `CPF` | Numérico | 1-1 | 11 | `entrega` | CPF |
| 181 | 90b | 2 | `xNome` | Caractere | 0-1 | 2-60 | `entrega` | Razão Social ou Nome do Recebedor |
| 182 | 91 | 2 | `xLgr` | Caractere | 1-1 | 2-60 | `entrega` | Logradouro |
| 183 | 92 | 2 | `nro` | Caractere | 1-1 | 1-60 | `entrega` | Número |
| 184 | 93 | 2 | `xCpl` | Caractere | 0-1 | 1-60 | `entrega` | Complemento |
| 185 | 94 | 2 | `xBairro` | Caractere | 1-1 | 1-60 | `entrega` | Bairro |
| 186 | 95 | 2 | `cMun` | Numérico | 1-1 | 7 | `entrega` | Código do Município |
| 187 | 96 | 2 | `xMun` | Caractere | 1-1 | 2-60 | `entrega` | Nome do município |
| 188 | 97 | 2 | `UF` | Caractere | 1-1 | 2 | `entrega` | Sigla da UF |
| 189 | 97a | 2 | `CEP` | Numérico | 0-1 | 8 | `entrega` | Código do CEP |
| 190 | 97b | 2 | `cPais` | Numérico | 0-1 | 4 | `entrega` | Código do País |
| 191 | 97c | 2 | `xPais` | Caractere | 0-1 | 2-60 | `entrega` | Nome do Pais |
| 192 | 97d | 2 | `fone` | Numérico | 0-1 | 6-14 | `entrega` | Telefone |
| 193 | 97e | 2 | `email` | Caractere | 0-1 | 1-60 | `entrega` | E-mail do Recebedor |
| 194 | 97f | 2 | `IE` | Numérico | 0-1 | 2-14 | `entrega` | Inscriçaõ Estadual do Estabelecimento Recebedor |
| 195 | — | 1 | `--entrega_fim--;` | — | — | — | `nota` |  |

#### `aut_XML` — pos. 97a.1 · linhas 196–199 · ocorrência 0-10

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 196 | 97a.1 | 1 | **`--aut_XML_ini--;`** | — | 0-10 | — | `nota` | Pessoas autorizadas para o download do XML da NF-e |
| 197 | 97a.2 | 2 | `CNPJ` | Caractere | 1-1 | 14 | `aut_XML` | CNPJ Autorizado |
| 198 | 97a.3 | 2 | `CPF` | Numérico | 1-1 | 11 | `aut_XML` | CPF Autorizado |
| 199 | — | 1 | `--aut_XML_fim--;` | — | — | — | `nota` |  |

#### `item_nota` — pos. sem pos. · linhas 200–1137 · ocorrência 1-900

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 200 | — | 1 | **`--item_nota_ini--;`** | — | 1-900 | — | `nota` |  |

##### `det` — pos. 98 · linhas 201–1136 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 201 | 98 | 2 | **`--det_ini--;`** | — | 1-1 | — | `item_nota` | Detalhamento de Produtos e Serviços |
| 202 | 99 | 3 | `nItem` | Numérico | 1-1 | 1-3 | `det` | Número do item |

###### `prod` — pos. 100 · linhas 203–363 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 203 | 100 | 3 | **`--prod_ini--;`** | — | 1-1 | — | `det` | Detalhamento de Produtos e Serviços |
| 204 | 101 | 4 | `cProd` | Caractere | 1-1 | 1-60 | `prod` | Código do produto ou serviço |
| 205 | 102 | 4 | `cEAN` | Caractere | 1-1 | 0,8,12,13,14 | `prod` | GTIN (Global Trade Item Number) do produto, antigo código EAN ou código de barr… |
| 206 | 102.01 | 4 | `cBarra` | Caractere | 0-1 | 3-30 | `prod` | Código de barras diferente do padrão GTIN |
| 207 | 103 | 4 | `xProd` | Caractere | 1-1 | 1-120 | `prod` | Descrição do produto ou serviço |
| 208 | 104 | 4 | `NCM` | Numérico | 1-1 | 2, 8 | `prod` | Código NCM com 8 dígitos ou 2 dígitos (gênero) |
| 209 | — | 4 | **`--nve_ini--;`** | — | 0-8 | — | `prod` |  |
| 210 | 104a | 5 | `NVE` | Caractere | 0-1 | 6 | `nve` | Codificação NVE - Nomenclatura de Valor Aduaneiro e Estatística. |
| 211 | — | 4 | `--nve_fim--;` | — | — | — | `prod` |  |
| 212 | 104b | 4 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `prod` | Sequencia XML |
| 213 | 104d | 5 | `CEST` | Numérico | 1-1 | 7 | `sequencia_XML` | Código CEST |
| 214 | 104e | 5 | `indEscala` | Caractere | 0-1 | 1 | `sequencia_XML` | Indicador de Escala Relevante |
| 215 | 104f | 5 | `CNPJFab` | Caractere | 0-1 | 14 | `sequencia_XML` | CNPJ do Fabricante da Mercadoria |
| 216 | — | 4 | `--sequencia_XML_fim--;` | — | — | — | `prod` |  |
| 217 | 104g | 4 | `cBenef` | Caractere | 0-1 | 8.1 | `prod` | Código de Benefício Fiscal na UF aplicado ao item |
| 218 | 104h | 4 | `tpCredPresIBSZFM` | Numérico | 0-1 | 1 | `prod` | Classificação para subapuração do IBS na / ZFM |
| 219 | 105 | 4 | `EXTIPI` | Numérico | 0-1 | 2-3 | `prod` | Código EX da TIPI |
| 220 | 107 | 4 | `CFOP` | Numérico | 1-1 | 4 | `prod` | Código Fiscal de Operações e Prestações(tabela CFOP) |
| 221 | 108 | 4 | `uCom` | Caractere | 1-1 | 1-6 | `prod` | Unidade Comercial |
| 222 | 109 | 4 | `qCom` | Numérico | 1-1 | 15,0-4 | `prod` | Quantidade Comercial |
| 223 | 109a | 4 | `vUnCom` | Numérico | 1-1 | 21,0-10 | `prod` | Valor Unitário de comercialização |
| 224 | 110 | 4 | `vProd` | Numérico | 1-1 | 15,2 | `prod` | Valor Total Bruto dos Produtos ou Serviços |
| 225 | 111 | 4 | `cEANTrib` | Caractere | 1-1 | 0,8,12,13,14 | `prod` | GTIN( Global Trade Item Number) da unidade tributável, antigo código EAN ou cód… |
| 226 | 111.01 | 4 | `cBarraTrib` | Caractere | 0-1 | 3-30 | `prod` | Código de Barras da unidade tributável que seja diferente do padrão GTIN |
| 227 | 112 | 4 | `uTrib` | Caractere | 1-1 | 1-6 | `prod` | Unidade tributável |
| 228 | 113 | 4 | `qTrib` | Numérico | 1-1 | 15,0-4 | `prod` | Quantidade Tributável |
| 229 | 113a | 4 | `vUnTrib` | Numérico | 1-1 | 21,0-10 | `prod` | Valor Unitário de tributação |
| 230 | 114 | 4 | `vFrete` | Numérico | 0-1 | 15,2 | `prod` | Valor total do frete |
| 231 | 115 | 4 | `vSeg` | Numérico | 0-1 | 15,2 | `prod` | Valor total do Seguro |
| 232 | 116 | 4 | `vDesc` | Numérico | 0-1 | 15,2 | `prod` | Valor do desconto |
| 233 | 116a | 4 | `vOutro` | Numérico | 0-1 | 15,2 | `prod` | outras Despesas acessórias |
| 234 | 116b | 4 | `indTot` | Numérico | 1-1 | 1 | `prod` | Indica se valor do item entra no valor total da NF-e |
| 235 | 116c | 4 | `indBemMovelUsado` | Numérico | 0-1 | 1 | `prod` | Indicador de fornecimento de bem móvel usado: / 1 - Bem Móvel Usado |
| 236 | — | 4 | **`--gCred_ini--`** | — | 0-4 | — | `prod` | Grupo de informações sobre o Crédito Presumido |
| 237 | 105h | 5 | `cCredPresumido` | Caractere | 1-1 | 8-10 | `gCred` | Código de Benefício Fiscal de Crédito Presumido na UF aplicado ao item |
| 238 | 105i | 5 | `pCredPresumido` | Numérico | 1-1 | 7,2-4 | `gCred` | Percentual do Crédito Presumido |
| 239 | 105j | 5 | `vCredPresumido` | Numérico | 1-1 | 15,2 | `gCred` | Valor do Crédito Presumido |
| 240 | — | 4 | `--gCred_fim--` | — | — | — | `prod` |  |
| 241 | 117 | 4 | **`--di_ini--;`** | — | 0-100 | — | `prod` | Declaração de Importação |
| 242 | 118 | 5 | `nDi` | Caractere | 1-1 | 1-15 | `di` | Número do Documento de Importação (DI, DSI, DIRE, / DUImp) |
| 243 | 119 | 5 | `dDi` | Data | 1-1 | — | `di` | Data de Registro da DI/DSI/DA/DREI/etc. |
| 244 | 120 | 5 | `xLocDesemb` | Caractere | 1-1 | 1-60 | `di` | Local de desembaraço |
| 245 | 121 | 5 | `UFDesemb` | Caractere | 1-1 | 2 | `di` |  |
| 246 | 122 | 5 | `dDesemb` | Data | 1-1 | — | `di` | Data do Desembaraço Aduaneiro |
| 247 | 122a | 5 | `tpViaTransp` | Numérico | 1-1 | 2 | `di` | Via de transporte internacional informada na Declaração de Importação (DI) ou n… |
| 248 | 122b | 5 | `vAFRMM` | Numérico | 0-1 | 15,2 | `di` | Valor da AFRMM - Adicional ao Frete para Renovação da Marinha Mercante |
| 249 | 122c | 5 | `tpIntermedio` | Numérico | 1-1 | 1 | `di` | Forma de importação quanto a intermediação |
| 250 | 122d | 5 | `CNPJ` | Caractere | 0-1 | 14 | `di` | CNPJ do adquirente ou do encomendante |
| 251 | I23d1 | 5 | `CPF` | Caractere | 0-1 | 11 | `di` | CPF do adquirente ou do encomendante |
| 252 | 122e | 5 | `UFTerceiro` | Caractere | 0-1 | 2 | `di` | Sigla da UF do adquirente ou do encomendante |
| 253 | 123 | 5 | `cExportador` | Caractere | 1-1 | 1-60 | `di` | Código do exportador |
| 254 | 124 | 5 | **`--adi_ini--;`** | — | 1-999 | — | `di` | Adições e/ou itens |
| 255 | 125 | 6 | `nAdicao` | Numérico | 0-1 | 1-3 | `adi` | Número da adição |
| 256 | 126 | 6 | `nSeqAdic` | Numérico | 1-1 | 1-5 | `adi` | Número sequencial do item |
| 257 | 127 | 6 | `cFabricante` | Caractere | 1-1 | 1-60 | `adi` | Código do fabricante estrangeiro |
| 258 | 128 | 6 | `vDescDi` | Numérico | 0-1 | 15,2 | `adi` | Valor do desconto do item |
| 259 | 128.1 | 6 | `nDraw` | Caractere | 0-1 | 1-20 | `adi` | Número do ato concessório de Drawback |
| 260 | — | 5 | `--adi_fim--;` | — | — | — | `di` |  |
| 261 | — | 4 | `--di_fim--;` | — | — | — | `prod` |  |
| 262 | 128f | 4 | **`--det_Export_ini--;`** | — | 0-500 | — | `prod` | Informações de Exportação para o item |
| 263 | 128g | 5 | `nDraw` | Caractere | 0-1 | 1-20 | `det_Export` | Número do ato concessório de Drawback |
| 264 | 128h | 5 | **`--export_Ind_ini--;`** | — | 0-1 | — | `det_Export` | Informações sobre exportação indireta |
| 265 | 128i | 6 | `nRE` | Numérico | 1-1 | 12 | `export_Ind` | Número de Registro de Exportação |
| 266 | 128j | 6 | `chNFe` | Caractere | 1-1 | 44 | `export_Ind` | Chave de Acesso da NF-e recebida para exportação |
| 267 | 128k | 6 | `qExport` | Numérico | 1-1 | 15,4 | `export_Ind` | Quantidade do item realmente exportado / Observação: No caso de operação com CF… |
| 268 | — | 5 | `--export_Ind_fim--;` | — | — | — | `det_Export` |  |
| 269 | — | 4 | `--det_Export_fim--;` | — | — | — | `prod` |  |
| 270 | 128m | 4 | `xPed` | Caractere | 0-1 | 1-15 | `prod` | Numero do pedido de compra |
| 271 | 128n | 4 | `nItemPed` | Numérico | 0-1 | 6 | `prod` | Item do pedido de compra |
| 272 | 128p | 4 | `nFCI` | Caractere | 0-1 | 36 | `prod` | Número de controle da FCI - Ficha de Conteúdo de Importação |
| 273 | 128q | 4 | **`--rastro_ini--;`** | — | 0-500 | — | `prod` | Detalhamento de produto sujeito a rastreabilidade |
| 274 | 128r | 5 | `nLote` | Caractere | 1-1 | 1-20 | `rastro` | Número do Lote do produto |
| 275 | 128s | 5 | `qLote` | Numérico | 1-1 | 11,3 | `rastro` | Quantidade de produto no lote |
| 276 | 128t | 5 | `dFab` | Data | 1-1 | — | `rastro` | Data de fabricação/produção |
| 277 | 128u | 5 | `dVal` | Data | 1-1 | — | `rastro` | Data de Validade |
| 278 | 128v | 5 | `cAgreg` | Caractere | 0-1 | 1-20 | `rastro` | Código de Agregação |
| 279 | — | 4 | `--rastro_fim--;` | — | — | — | `prod` |  |
| 280 | 128x | 4 | **`--prod_especifico_ini--;`** | — | 0-1 | — | `prod` | Sequência XML |
| 281 | 129 | 5 | **`--veic_Prod_ini--;`** | — | 1-1 | — | `prod_especifico` | Detalhamento de Veículos novos |
| 282 | 130 | 6 | `tpOp` | Numérico | 1-1 | 1 | `veic_Prod` | Tipo da operação |
| 283 | 131 | 6 | `chassi` | Caractere | 1-1 | 17 | `veic_Prod` | Chassi do veículo |
| 284 | 132 | 6 | `cCor` | Caractere | 1-1 | 1-4 | `veic_Prod` | Cor |
| 285 | 133 | 6 | `xCor` | Caractere | 1-1 | 1-40 | `veic_Prod` | Descrição da Cor |
| 286 | 134 | 6 | `pot` | Caractere | 1-1 | 1-4 | `veic_Prod` | Potência do Motor |
| 287 | 135 | 6 | `cilin` | Caractere | 1-1 | 1-4 | `veic_Prod` | Cilindradas |
| 288 | 136 | 6 | `pesoL` | Caractere | 1-1 | 1-9 | `veic_Prod` | Peso Líquido |
| 289 | 137 | 6 | `pesoB` | Caractere | 1-1 | 1-9 | `veic_Prod` | Peso Bruto |
| 290 | 138 | 6 | `nSerie` | Caractere | 1-1 | 1-9 | `veic_Prod` | Serial(série) |
| 291 | 139 | 6 | `tpComb` | Caractere | 1-1 | 1-2 | `veic_Prod` | Tipo de combustível |
| 292 | 140 | 6 | `nMotor` | Caractere | 1-1 | 1-21 | `veic_Prod` | Número do motor |
| 293 | 141 | 6 | `CMT` | Caractere | 1-1 | 1-9 | `veic_Prod` | Capacidade máxima de tração |
| 294 | 142 | 6 | `dist` | Caractere | 1-1 | 1-4 | `veic_Prod` | Distância entre eixos |
| 295 | 144 | 6 | `anoMod` | Numérico | 1-1 | 4 | `veic_Prod` | Ano Modelo de Fabricação |
| 296 | 145 | 6 | `anoFab` | Numérico | 1-1 | 4 | `veic_Prod` | Ano de Fabricação |
| 297 | 146 | 6 | `tpPint` | Caractere | 1-1 | 1 | `veic_Prod` | Tipo de Pintura |
| 298 | 147 | 6 | `tpVeic` | Numérico | 1-1 | 1-2 | `veic_Prod` | Tipo de Veículo |
| 299 | 148 | 6 | `espveic` | Numérico | 1-1 | 1 | `veic_Prod` | Espécie de Veículo |
| 300 | 149 | 6 | `VIN` | Caractere | 1-1 | 1 | `veic_Prod` | Condição do VIN |
| 301 | 150 | 6 | `condVeic` | Numérico | 1-1 | 1 | `veic_Prod` | Condição do Veículo |
| 302 | 151 | 6 | `cMod` | Numérico | 1-1 | 1-6 | `veic_Prod` | Código Marca Modelo |
| 303 | 151a | 6 | `cCorDENATRAN` | Numérico | 1-1 | 1-2 | `veic_Prod` | Código da cor |
| 304 | 151b | 6 | `lota` | Numérico | 1-1 | 1-3 | `veic_Prod` | capacidade máxima de lotação |
| 305 | 151c | 6 | `tpRest` | Numérico | 1-1 | 1 | `veic_Prod` | Restrição |
| 306 | — | 5 | `--veic_Prod_fim--;` | — | — | — | `prod_especifico` |  |
| 307 | 152 | 5 | **`--medicamento_ini--;`** | — | 1-1 | — | `prod_especifico` | Detalhamento de Medicamentos e de matérias-primas farmacêuticas |
| 308 | 152a | 6 | `cProdANVISA` | Caractere | 1-1 | 6-13 | `medicamento` | Código de Produto da ANVISA |
| 309 | 152b | 6 | `xMotivoIsencao` | Caractere | 0-1 | 1-255 | `medicamento` | Motivo da isenção da ANVISA |
| 310 | 157 | 6 | `vPMC` | Numérico | 1-1 | 15,2 | `medicamento` | Preço máximo consumidor |
| 311 | — | 5 | `--medicamento_fim--;` | — | — | — | `prod_especifico` |  |
| 312 | 158 | 5 | **`--armamento_ini--;`** | — | 1-500 | — | `prod_especifico` | Detalhamento de Armamento |
| 313 | 159 | 6 | `tpArma` | Numérico | 1-1 | 1 | `armamento` | Indicador do tipo de arma de fogo |
| 314 | 160 | 6 | `nSerie` | Caractere | 1-1 | 1-15 | `armamento` | Número de série da arma |
| 315 | 161 | 6 | `nCano` | Caractere | 1-1 | 1-15 | `armamento` | Número de série do cano |
| 316 | 162 | 6 | `descr` | Caractere | 1-1 | 1-256 | `armamento` | Descrição completa da arma, compreendendo: calibre, marca, capacidade, tipo de… |
| 317 | — | 5 | `--armamento_fim--;` | — | — | — | `prod_especifico` |  |
| 318 | 162a | 5 | **`--comb_ini--;`** | — | 1-1 | — | `prod_especifico` | Informações específicas para combustíveis líquidos e lubrificantes |
| 319 | 162b | 6 | `cProdANP` | Numérico | 1-1 | 9 | `comb` | Código de produto da ANP |
| 320 | 162b1 | 6 | `descANP` | Caractere | 1-1 | 2-95 | `comb` | descrição do produto conforme ANP |
| 321 | 162b2 | 6 | `pGLP` | Numérico | 0-1 | 7,4 | `comb` | Percentual do GLP derivado do petróleo no produto GLP |
| 322 | 162b3 | 6 | `pGNn` | Numérico | 0-1 | 7,4 | `comb` | Percentual de Gás Natural Nacional - GLGNn para o produto GLP (cProdANP=2102030… |
| 323 | 162b4 | 6 | `pGNi` | Numérico | 0-1 | 7,4 | `comb` | Percentual de Gás Natural Importado - GLGNi para o produto GLP (cProdANP=210203… |
| 324 | 162b5 | 6 | `vPart` | Numérico | 0-1 | 15,2 | `comb` | Valor de partida (cProdANP=210203001) |
| 325 | 162c | 6 | `CODIF` | Numérico | 0-1 | 1-21 | `comb` | Código de autorização/ registro do CODIF |
| 326 | 162d | 6 | `qTemp` | Numérico | 0-1 | 16,4 | `comb` | Quantidade de combustível faturada à temperatura ambiente |
| 327 | 162e | 6 | `UFCons` | Numérico | 1-1 | 2 | `comb` | Sigla da UF de consumo |
| 328 | 162f | 6 | **`--cide_ini--;`** | — | 0-1 | — | `comb` | Informações da CIDE |
| 329 | 162g | 7 | `qBCProd` | Numérico | 1-1 | 16,0-4 | `cide` | BC da CIDE |
| 330 | 162h | 7 | `vAliqProd` | Numérico | 1-1 | 15,4 | `cide` | Valor da alíquota da CIDE |
| 331 | 162i | 7 | `vCIDE` | Numérico | 1-1 | 15,2 | `cide` | Valor da CIDE |
| 332 | — | 6 | `--cide_fim--;` | — | — | — | `comb` |  |
| 333 | 162j | 6 | **`--encerrante_ini--;`** | — | 0-1 | — | `comb` | Informações de "Encerrante" |
| 334 | 162k | 7 | `nBico` | Numérico | 1-1 | 1-3 | `encerrante` | Número de Identificação do bico utilizado no abastecimento |
| 335 | 162l | 7 | `nBomba` | Numérico | 0-1 | 1-3 | `encerrante` | Número de Identificação da bomba ao qual o bico está interligado |
| 336 | 162m | 7 | `nTanque` | Numérico | 1-1 | 1-3 | `encerrante` | Número de identificação do tanque ao qual o bico está interligado |
| 337 | 162n | 7 | `vEncIni` | Numérico | 1-1 | 15,3 | `encerrante` | Valor do Encerrante no início do abastecimento |
| 338 | 162o | 7 | `vEncFim` | Numérico | 1-1 | 15,3 | `encerrante` | Valor do Encerrante no final do abastecimento |
| 339 | — | 6 | `--encerrante_fim--;` | — | — | — | `comb` |  |
| 340 | 162q | 6 | `pBio` | Numérico | 0-1 | 7,4 | `comb` | Percentual do índice de mistura do Biodiesel (B100) no Óleo Diesel B instituído… |
| 341 | 162r | 6 | **`--origComb_ini--;`** | — | 0-30 | — | `comb` | Grupo indicador da origem do combustível |
| 342 | 162s | 7 | `indImport` | Numérico | 1-1 | 1,0-4 | `origComb` | Indicador de importação |
| 343 | 162t | 7 | `cUFOrig` | Numérico | 1-1 | 2,4 | `origComb` | Código da UF |
| 344 | 162u | 7 | `pOrig` | Numérico | 1-1 | 7,4 | `origComb` | Percentual originário para a UF |
| 345 | — | 6 | `--origComb_fim--;` | — | — | — | `comb` |  |
| 346 | — | 5 | `--comb_fim--;` | — | — | — | `prod_especifico` |  |
| 347 | 162p | 5 | `nRECOPI` | Numérico | 1-1 | 20 | `prod_especifico` | Número do RECOPI |
| 348 | — | 4 | `--prod_especifico_fim--;` | — | — | — | `prod` |  |
| 349 | 325a | 4 | **`--obsItem_ini--;`** | — | 0-1 | — | `prod` | Grupo de observações de uso livre (para o item da NF-e) |
| 350 | 325b | 5 | **`--obsCont_ini--;`** | — | 0-1 | — | `obsItem` | Grupo de observações de uso livre do Contribuinte |
| 351 | 325c | 6 | `xCampo` | Caractere | 1-1 | 20 | `obsCont` | Identificação do campo |
| 352 | 325d | 6 | `xTexto` | Caractere | 1-1 | 60 | `obsCont` | Conteúdo do campo |
| 353 | — | 5 | `--obsCont_fim--;` | — | — | — | `obsItem` |  |
| 354 | 325e | 5 | **`--obsFisco_ini--;`** | — | 0-1 | — | `obsItem` | Grupo de observações de uso livre do Fisco |
| 355 | 325f | 6 | `xCampo` | Caractere | 1-1 | 20 | `obsFisco` | Identificação do campo |
| 356 | 325g | 6 | `xTexto` | Caractere | 1-1 | 60 | `obsFisco` | Conteúdo do campo |
| 357 | — | 5 | `--obsFisco_fim--;` | — | — | — | `obsItem` |  |
| 358 | — | 4 | `--obsItem_fim--;` | — | — | — | `prod` |  |
| 359 | 110.01 | 4 | **`--sequencia_XML_liq_ini--;`** | — | 0-1 | — | `prod` | Sequência XML |
| 360 | 110.02 | 5 | `vUnComLiq` | Numérico | 1-1 | 21,0-10 | `sequencia_XML_liq` | Valor Líquido Unitário do Produto ou Serviço (sem tributos) |
| 361 | 110.03 | 5 | `vProdLiq` | Numérico | 1-1 | 15,2 | `sequencia_XML_liq` | Valor Líquido do Produto ou Serviço (sem tributos) |
| 362 | — | 4 | `--sequencia_XML_liq_fim--;` | — | — | — | `prod` |  |
| 363 | — | 3 | `--prod_fim--;` | — | — | — | `det` |  |

###### `impostos` — pos. 163 · linhas 364–1119 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 364 | 163 | 3 | **`--impostos_ini--;`** | — | 1-1 | — | `det` | Tributo incidentes no Produto ou Serviço |
| 365 | 163a | 4 | `vTotTrib` | Numérico | 0-1 | 15,2 | `impostos` | Valor aproximado total de tributos federais, estaduais e municipais |

###### `ICMS` — pos. 164 · linhas 366–762 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 366 | 164 | 4 | **`--ICMS_ini--;`** | — | 0-1 | — | `impostos` | Informações do ICMS da Operação |

###### `icms_00` — pos. 165 · linhas 367–378 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 367 | 165 | 5 | **`--icms_00_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS= 00 |
| 368 | 166 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_00` | Origem da mercadoria / (NT 2013.006) |
| 369 | 167 | 6 | `CST` | Numérico | 1-1 | 2 | `icms_00` | Tributação do ICMS |
| 370 | 168 | 6 | `modBC` | Numérico | 1-1 | 1 | `icms_00` | Modalidade de determinação da Base de Cálculo do ICMS |
| 371 | 169 | 6 | `vBC` | Numérico | 1-1 | 15,2 | `icms_00` | Valor da Base de Cálculo do ICMS |
| 372 | 170 | 6 | `pICMS` | Numérico | 1-1 | 7,2-4 | `icms_00` | Alíquota do imposto |
| 373 | 171 | 6 | `vICMS` | Numérico | 1-1 | 15,2 | `icms_00` | Valor do ICMS |
| 374 | 171.0 | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `icms_00` |  |
| 375 | 171.1 | 7 | `pFCP` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentual do ICMS relativo ao Fundo de Combate à Pobreza (FCP) |
| 376 | 172.2 | 7 | `vFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) |
| 377 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `icms_00` |  |
| 378 | — | 5 | `--icms_00_fim--;` | — | — | — | `ICMS` |  |

###### `icms_02` — pos. 172.3 · linhas 379–385 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 379 | 172.3 | 5 | **`--icms_02_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS monofásico = 02 |
| 380 | 172.4 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_02` | Origem da mercadoria |
| 381 | 172.5 | 6 | `CST` | Numérico | 1-1 | 2 | `icms_02` | Tributação do ICMS |
| 382 | 172.8 | 6 | `qBCMono` | Numérico | 0-1 | 15,0-4 | `icms_02` | Quantidade tributada |
| 383 | 172.6 | 6 | `adRemICMS` | Numérico | 1-1 | 7,2-4 | `icms_02` | Alíquota ad rem do imposto |
| 384 | 172.7 | 6 | `vICMSMono` | Numérico | 1-1 | 15,2 | `icms_02` | Valor do ICMS próprio |
| 385 | — | 5 | `--icms_02_fim--;` | — | — | — | `ICMS` |  |

###### `icms_10` — pos. 172 · linhas 386–413 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 386 | 172 | 5 | **`--icms_10_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS= 10 |
| 387 | 173 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_10` | Origem da mercadoria / (NT 2013.006) |
| 388 | 174 | 6 | `CST` | Numérico | 1-1 | 2 | `icms_10` | Tributação do ICMS |
| 389 | 175 | 6 | `modBC` | Numérico | 1-1 | 1 | `icms_10` | Modalidade de determinação da Base de Cálculo do ICMS |
| 390 | 176 | 6 | `vBC` | Numérico | 1-1 | 15,2 | `icms_10` | Valor da Base de Cálculo do ICMS |
| 391 | 177 | 6 | `pICMS` | Numérico | 1-1 | 7,2-4 | `icms_10` | Alíquota do imposto |
| 392 | 178 | 6 | `vICMS` | Numérico | 1-1 | 15,2 | `icms_10` | Valor do ICMS |
| 393 | 178.0 | 6 | **`--sequencia_XML_FCP_ini--;`** | — | 0-1 | — | `icms_10` | Sequência XML para FCP |
| 394 | 178.1 | 7 | `vBCFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML_FCP` | Valor da Base de Cálculo do FCP |
| 395 | 178.2 | 7 | `pFCP` | Numérico | 1-1 | 7,2-4 | `sequencia_XML_FCP` | Percentual relativo ao Fundo de Combate à Pobreza (FCP) |
| 396 | 178.3 | 7 | `vFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML_FCP` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) |
| 397 | — | 6 | `--sequencia_XML_FCP_fim--;` | — | — | — | `icms_10` |  |
| 398 | 179 | 6 | `modBCST` | Numérico | 1-1 | 1 | `icms_10` | Modalidade de determinação da Base de Cálculo do ICMS ST |
| 399 | 180 | 6 | `pMVAST` | Numérico | 0-1 | 7,2-4 | `icms_10` | Percentual da margem de valor Adicionado do ICMS ST |
| 400 | 181 | 6 | `pRedBCST` | Numérico | 0-1 | 7,2-4 | `icms_10` | Percentual da Redução de Base de Cálculo do ICMS ST |
| 401 | 182 | 6 | `vBCST` | Numérico | 1-1 | 15,2 | `icms_10` | Valor da Base de Cálculo do ICMS ST |
| 402 | 183 | 6 | `pICMSST` | Numérico | 1-1 | 7,2-4 | `icms_10` | Alíquota do imposto do ICMS ST |
| 403 | 184 | 6 | `vICMSST` | Numérico | 1-1 | 15,2 | `icms_10` | Valor do ICMS ST retido |
| 404 | 184.0 | 6 | **`--sequencia_XML_FCPST_ini--;`** | — | 0-1 | — | `icms_10` | Sequência XML para FCP retido por ST |
| 405 | 184.1 | 7 | `vBCFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML_FCPST` | Valor da Base de Cálculo do FCP retido por Substituição Tributária |
| 406 | 184.2 | 7 | `pFCPST` | Numérico | 1-1 | 7,2-4 | `sequencia_XML_FCPST` | Percentual relativo ao Fundo de Combate à Pobreza (FCP) retido por Substituição… |
| 407 | 184.4 | 7 | `vFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML_FCPST` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) retido por Substitui… |
| 408 | — | 6 | `--sequencia_XML_FCPST_fim--;` | — | — | — | `icms_10` |  |
| 409 | 184.5 | 6 | **`--x_icmsst10_deson_ini--;`** | — | 0-1 | — | `icms_10` | Sequência XML para ICMS ST Desonerado |
| 410 | 184.6 | 7 | `vICMSSTDeson` | Numérico | 1-1 | 15,2 | `x_icmsst10_deson` | Valor do ICMS- ST desonerado |
| 411 | 184.7 | 7 | `motDesICMSST` | Numérico | 1-1 | 2 | `x_icmsst10_deson` | Motivo da desoneração do ICMS- ST |
| 412 | — | 6 | `--x_icmsst10_deson_fim--;` | — | — | — | `icms_10` |  |
| 413 | — | 5 | `--icms_10_fim--;` | — | — | — | `ICMS` |  |

###### `icms_15` — pos. 184.8 · linhas 414–427 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 414 | 184.8 | 5 | **`--icms_15_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS monofásico = 15 |
| 415 | 184.8a | 6 | `orig` | Numérico | 1-1 | 1 | `icms_15` | Origem da mercadoria |
| 416 | 184.8b | 6 | `CST` | Numérico | 1-1 | 2 | `icms_15` | Tributação do ICMS |
| 417 | 184.8j | 6 | `qBCMono` | Numérico | 0-1 | 15,0-4 | `icms_15` | Quantidade tributada |
| 418 | 184.8c | 6 | `adRemICMS` | Numérico | 1-1 | 7,2-4 | `icms_15` | Alíquota ad rem do imposto |
| 419 | 184.8d | 6 | `vICMSMono` | Numérico | 1-1 | 15,2 | `icms_15` | Valor do ICMS próprio |
| 420 | 184.8k | 6 | `qBCMonoReten` | Numérico | 0-1 | 15,0-4 | `icms_15` | Quantidade tributada sujeita a retenção |
| 421 | 184.8e | 6 | `adRemICMSReten` | Numérico | 1-1 | 7,2 | `icms_15` | Alíquota ad rem do imposto com retenção |
| 422 | 184.8f | 6 | `vICMSMonoReten` | Numérico | 1-1 | 15,2 | `icms_15` | Valor do ICMS com retenção |
| 423 | 184.8g | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `icms_15` |  |
| 424 | 184.8h | 7 | `pRedAdRem` | Numérico | 1-1 | 5,2 | `sequencia_XML` | Percentual de redução do valor da alíquota adrem do ICMS |
| 425 | 184.8i | 7 | `motRedAdRem` | Numérico | 1-1 | 1 | `sequencia_XML` | Motivo da redução do adrem |
| 426 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `icms_15` |  |
| 427 | — | 5 | `--icms_15_fim--;` | — | — | — | `ICMS` |  |

###### `icms_20` — pos. 185 · linhas 428–446 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 428 | 185 | 5 | **`--icms_20_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS= 20 |
| 429 | 186 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_20` | Origem da mercadoria / (NT 2013.006) |
| 430 | 187 | 6 | `CST` | Numérico | 1-1 | 2 | `icms_20` | Tributação do ICMS |
| 431 | 188 | 6 | `modBC` | Numérico | 1-1 | 1 | `icms_20` | Modalidade de determinação da Base de Cálculo do ICMS |
| 432 | 189 | 6 | `pRedBC` | Numérico | 1-1 | 7,2-4 | `icms_20` | Percentual da Redução de Base de Cálculo |
| 433 | 190 | 6 | `vBC` | Numérico | 1-1 | 15,2 | `icms_20` | Valor da Base de Cálculo do ICMS |
| 434 | 191 | 6 | `pICMS` | Numérico | 1-1 | 7,2-4 | `icms_20` | Alíquota do imposto |
| 435 | 192 | 6 | `vICMS` | Numérico | 1-1 | 15,2 | `icms_20` | Valor do ICMS |
| 436 | 192.0 | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `icms_20` |  |
| 437 | 192.w | 7 | `vBCFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor da Base de Cálculo do FCP |
| 438 | 192.x | 7 | `pFCP` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentual do Fundo de Combate à Pobreza (FCP) |
| 439 | 192.y | 7 | `vFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do Fundo de Combate à Pobreza (FCP) |
| 440 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `icms_20` |  |
| 441 | 192.1 | 6 | **`--x_icms20_deson_ini--;`** | — | 0-1 | — | `icms_20` | Sequência XML |
| 442 | 192.2 | 7 | `vICMSDeson` | Numérico | 1-1 | 15,2 | `x_icms20_deson` | Valor do ICMS desonerado |
| 443 | 192.3 | 7 | `motDesICMS` | Numérico | 1-1 | 2 | `x_icms20_deson` | Motivo da desoneração do ICMS |
| 444 | 192.4 | 7 | `indDeduzDeson` | Numérico | 0-1 | 1 | `x_icms20_deson` | Indica se o valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd… |
| 445 | — | 6 | `--x_icms20_deson_fim--;` | — | — | — | `icms_20` |  |
| 446 | — | 5 | `--icms_20_fim--;` | — | — | — | `ICMS` |  |

###### `icms_30` — pos. 193 · linhas 447–466 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 447 | 193 | 5 | **`--icms_30_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS= 30 |
| 448 | 194 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_30` | Origem da mercadoria / (NT 2013.006) |
| 449 | 195 | 6 | `CST` | Numérico | 1-1 | 2 | `icms_30` | Tributação do ICMS |
| 450 | 196 | 6 | `modBCST` | Numérico | 1-1 | 1 | `icms_30` | Modalidade de determinação da Base de Cálculo do ICMS ST |
| 451 | 197 | 6 | `pMVAST` | Numérico | 0-1 | 7,2-4 | `icms_30` | Percentual da margem de valor Adicionado do ICMS ST |
| 452 | 198 | 6 | `pRedBCST` | Numérico | 0-1 | 7,2-4 | `icms_30` | Percentual da Redução de Base de Cálculo do ICMS ST |
| 453 | 199 | 6 | `vBCST` | Numérico | 1-1 | 15,2 | `icms_30` | Valor da Base de Cálculo do ICMS ST |
| 454 | 200 | 6 | `pICMSST` | Numérico | 1-1 | 7,2-4 | `icms_30` | Alíquota do imposto do ICMS ST |
| 455 | 201 | 6 | `vICMSST` | Numérico | 1-1 | 15,2 | `icms_30` | Valor do ICMS ST retido |
| 456 | 201.0 | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `icms_30` |  |
| 457 | 201.w | 7 | `vBCFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor da Base de Cálculo do FCP retido por Substituição Tributária |
| 458 | 201.x | 7 | `pFCPST` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentualdo FCP retido por substituição tributária |
| 459 | 201.y | 7 | `vFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do FCP retido por Substituição Tributária |
| 460 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `icms_30` |  |
| 461 | 201.1 | 6 | **`--x_icms30_deson_ini--;`** | — | 0-1 | — | `icms_30` | Sequência XML |
| 462 | 201.2 | 7 | `vICMSDeson` | Numérico | 1-1 | 15,2 | `x_icms30_deson` | Valor do ICMS desonerado |
| 463 | 201.3 | 7 | `motDesICMS` | Numérico | 1-1 | 2 | `x_icms30_deson` | Motivo da desoneração do ICMS |
| 464 | 201.4 | 7 | `indDeduzDeson` | Numérico | 0-1 | 1 | `x_icms30_deson` | Indica se o valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd… |
| 465 | — | 6 | `--x_icms30_deson_fim--;` | — | — | — | `icms_30` |  |
| 466 | — | 5 | `--icms_30_fim--;` | — | — | — | `ICMS` |  |

###### `icms_40` — pos. 202 · linhas 467–475 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 467 | 202 | 5 | **`--icms_40_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS= 40, 41, 50 |
| 468 | 203 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_40` | Origem da mercadoria / (NT 2013.006) |
| 469 | 204 | 6 | `CST` | Numérico | 1-1 | 2 | `icms_40` | Tributação do ICMS |
| 470 | 204.00 | 6 | **`--x_icms40_deson_ini--;`** | — | 0-1 | — | `icms_40` | Sequência XML |
| 471 | 204.01 | 7 | `vICMSDeson` | Numérico | 1-1 | 15,2 | `x_icms40_deson` | Valor do ICMS desonerado |
| 472 | 204.02 | 7 | `motDesICMS` | Numérico | 1-1 | 2 | `x_icms40_deson` | Motivo da desoneração do ICMS |
| 473 | 204.03 | 7 | `indDeduzDeson` | Numérico | 0-1 | 1 | `x_icms40_deson` | Indica se o valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd… |
| 474 | — | 6 | `--x_icms40_deson_fim--;` | — | — | — | `icms_40` |  |
| 475 | — | 5 | `--icms_40_fim--;` | — | — | — | `ICMS` |  |

###### `icms_51` — pos. 205 · linhas 476–498 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 476 | 205 | 5 | **`--icms_51_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS= 51 |
| 477 | 206 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_51` | Origem da mercadoria / (NT 2013.006) |
| 478 | 207 | 6 | `CST` | Numérico | 1-1 | 2 | `icms_51` | Tributação do ICMS |
| 479 | 208 | 6 | `modBC` | Numérico | 0-1 | 1 | `icms_51` | Modalidade de determinação da Base de Cálculo do ICMS |
| 480 | 209 | 6 | `pRedBC` | Numérico | 0-1 | 7,2-4 | `icms_51` | Percentual de Redução de Base de Cálculo |
| 481 | 209.01 | 6 | `cBenefRBC` | Caractere | 0-1 | 10 | `icms_51` | Código de Benefício Fiscal na UF aplicado ao item quando houver RBC. |
| 482 | 210 | 6 | `vBC` | Numérico | 0-1 | 15,2 | `icms_51` | Valor da Base de Cálculo do ICMS |
| 483 | 211 | 6 | `pICMS` | Numérico | 0-1 | 7,2-4 | `icms_51` | Alíquota do imposto |
| 484 | 211.01 | 6 | `vICMSOp` | Numérico | 0-1 | 15,2 | `icms_51` | Valor do ICMS da Operação |
| 485 | 211.02 | 6 | `pDif` | Numérico | 0-1 | 7,2-4 | `icms_51` | Percentual do diferimento |
| 486 | 211.03 | 6 | `vICMSDif` | Numérico | 0-1 | 15,2 | `icms_51` | Valor do ICMS diferido |
| 487 | 212 | 6 | `vICMS` | Numérico | 0-1 | 15,2 | `icms_51` | Valor do ICMS |
| 488 | 212.0 | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `icms_51` |  |
| 489 | 212.w | 7 | `vBCFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor da Base de Cálculo do FCP |
| 490 | 212.x | 7 | `pFCP` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentual do Fundo de Combate à Pobreza (FCP) |
| 491 | 212.y | 7 | `vFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) |
| 492 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `icms_51` |  |
| 493 | 212.1 | 6 | **`--sequencia_XML_FCP_diferido_ini--;`** | — | 0-1 | — | `icms_51` | Sequência XML |
| 494 | 212.a | 7 | `pFCPDif` | Numérico | 1-1 | 7,2-4 | `sequencia_XML_FCP_diferido` | Percentual do diferimento do ICMS relativo ao Fundo de Combate à Pobreza (FCP) |
| 495 | 212.b | 7 | `vFCPDif` | Numérico | 1-1 | 15,2 | `sequencia_XML_FCP_diferido` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) diferido |
| 496 | 212.c | 7 | `vFCPEfet` | Numérico | 0-1 | 15,2 | `sequencia_XML_FCP_diferido` | Valor efetivo do ICMS relativo ao Fundo de Combate à Pobreza (FCP) |
| 497 | — | 6 | `--sequencia_XML_FCP_diferido_fim--;` | — | — | — | `icms_51` |  |
| 498 | — | 5 | `--icms_51_fim--;` | — | — | — | `ICMS` |  |

###### `icms_53` — pos. 212.d · linhas 499–508 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 499 | 212.d | 5 | **`--icms_53_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS monofásico = 53 |
| 500 | 212.e | 6 | `orig` | Numérico | 1-1 | 1 | `icms_53` | Origem da mercadoria |
| 501 | 212.f | 6 | `CST` | Numérico | 1-1 | 2 | `icms_53` | Tributação do ICMS |
| 502 | 212.01j | 6 | `qBCMono` | Numérico | 0-1 | 15,0-4 | `icms_53` | Quantidade Tributada |
| 503 | 212.02j | 6 | `adRemICMS` | Numérico | 0-1 | 7,2-4 | `icms_53` | Alíquota adRem do imposto |
| 504 | 212.03j | 6 | `vICMSMonoOp` | Numérico | 0-1 | 15,2 | `icms_53` | Valor do ICMS da operação |
| 505 | 212.04j | 6 | `pDif` | Numérico | 0-1 | 7,2-4 | `icms_53` | Percentual do diferimento |
| 506 | 212.h | 6 | `vICMSMonoDif` | Numérico | 0-1 | 15,2 | `icms_53` | Valor do ICMS diferido |
| 507 | 212.05j | 6 | `vICMSMono` | Numérico | 0-1 | 15,2 | `icms_53` | Valor do ICMS próprio devido |
| 508 | — | 5 | `--icms_53_fim--;` | — | — | — | `ICMS` |  |

###### `icms_60` — pos. 213 · linhas 509–529 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 509 | 213 | 5 | **`--icms_60_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS= 60 |
| 510 | 214 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_60` | Origem da mercadoria / (NT 2013.006) |
| 511 | 215 | 6 | `CST` | Numérico | — | 2 | `icms_60` | Tributação do ICMS |
| 512 | 215.1 | 6 | **`--x_icms60_retido_ini--;`** | — | 0-1 | — | `icms_60` | Sequência XML |
| 513 | 216 | 7 | `vBCSTRet` | Numérico | 1-1 | 15,2 | `x_icms60_retido` | Valor da Base de Cálculo do ICMS ST retido |
| 514 | 216.1 | 7 | `pST` | Numérico | 1-1 | 7,2-4 | `x_icms60_retido` | Alíquota suportada pelo Consumidor Final |
| 515 | 216.2 | 7 | `vICMSSubstituto` | Numérico | 0-1 | 15,2 | `x_icms60_retido` | Valor do ICMS próprio do Substituto |
| 516 | 217 | 7 | `vICMSSTRet` | Numérico | 1-1 | 15,2 | `x_icms60_retido` | Valor do ICMS ST retido |
| 517 | — | 6 | `--x_icms60_retido_fim--;` | — | — | — | `icms_60` |  |
| 518 | 217.0 | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `icms_60` |  |
| 519 | 217.w | 7 | `vBCFCPSTRet` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor da Base de Cálculo do FCP retido anteriormente por Substituição Tributária |
| 520 | 217.x | 7 | `pFCPSTRet` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentual do Fundo de Combate à Pobreza (FCP) retido anteriormente por Substit… |
| 521 | 217.y | 7 | `vFCPSTRet` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do Fundo de Combate à Pobreza (FCP) retido anteriormente por Substituição… |
| 522 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `icms_60` |  |
| 523 | 217.1 | 6 | **`--x_icms_efetivo_ini--;`** | — | 0-1 | — | `icms_60` | Informações do ICMS Efetivo |
| 524 | 217.2 | 7 | `pRedBCEfet` | Numérico | 1-1 | 7,2-4 | `x_icms_efetivo` | Percentual de redução da base de cáclulo efetiva |
| 525 | 217.3 | 7 | `vBCEfet` | Numérico | 1-1 | 15,2 | `x_icms_efetivo` | Valor da base de cálculo efetiva |
| 526 | 217.4 | 7 | `pICMSEfet` | Numérico | 1-1 | 7,2-4 | `x_icms_efetivo` | Alíquota do ICMS efetiva |
| 527 | 217.5 | 7 | `vICMSEfet` | Numérico | 1-1 | 15,2 | `x_icms_efetivo` | Valor do ICMS Efetivo |
| 528 | — | 6 | `--x_icms_efetivo_fim--;` | — | — | — | `icms_60` |  |
| 529 | — | 5 | `--icms_60_fim--;` | — | — | — | `ICMS` |  |

###### `icms_61` — pos. 217.6 · linhas 530–536 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 530 | 217.6 | 5 | **`--icms_61_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS monofásico = 61 |
| 531 | 217.6a | 6 | `orig` | Numérico | 1-1 | 1 | `icms_61` | Origem da mercadoria |
| 532 | 217.6b | 6 | `CST` | Numérico | 1-1 | 2 | `icms_61` | Tributação do ICMS |
| 533 | 217.6e | 6 | `qBCMonoRet` | Numérico | 0-1 | 15,0-4 | `icms_61` | Quantidade tributada retida anteriormente |
| 534 | 217.6c | 6 | `adRemICMSRet` | Numérico | 1-1 | 7,2-4 | `icms_61` | Alíquota ad rem do imposto retido anteriormente |
| 535 | 217.6d | 6 | `vICMSMonoRet` | Numérico | 1-1 | 15,2 | `icms_61` | Valor do ICMS retido anteriormente |
| 536 | — | 5 | `--icms_61_fim--;` | — | — | — | `ICMS` |  |

###### `icms_70` — pos. 218 · linhas 537–570 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 537 | 218 | 5 | **`--icms_70_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS= 70 |
| 538 | 219 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_70` | Origem da mercadoria / (NT 2013.006) |
| 539 | 220 | 6 | `CST` | Numérico | 1-1 | 2 | `icms_70` | Tributação do ICMS |
| 540 | 221 | 6 | `modBC` | Numérico | 1-1 | 1 | `icms_70` | Modalidade de determinação da Base de Cálculo do ICMS |
| 541 | 222 | 6 | `pRedBC` | Numérico | 1-1 | 7,2-4 | `icms_70` | Percentual da Redução de Base de Cálculo |
| 542 | 223 | 6 | `vBC` | Numérico | 1-1 | 15,2 | `icms_70` | Valor da Base de Cálculo do ICMS |
| 543 | 224 | 6 | `pICMS` | Numérico | 1-1 | 7,2-4 | `icms_70` | Alíquota do imposto |
| 544 | 225 | 6 | `vICMS` | Numérico | 1-1 | 15,2 | `icms_70` | Valor do ICMS |
| 545 | 225.0 | 6 | **`--sequencia_XML_FCP_ini--;`** | — | 0-1 | — | `icms_70` | Sequência XML para FCP |
| 546 | 225.1 | 7 | `vBCFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML_FCP` | Valor da Base de Cálculo do FCP |
| 547 | 225.2 | 7 | `pFCP` | Numérico | 1-1 | 7,2-4 | `sequencia_XML_FCP` | Percentual do Fundo de Combate à Pobreza (FCP) |
| 548 | 225.3 | 7 | `vFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML_FCP` | Valor do Fundo de Combate à Pobreza (FCP) |
| 549 | — | 6 | `--sequencia_XML_FCP_fim--;` | — | — | — | `icms_70` |  |
| 550 | 226 | 6 | `modBCST` | Numérico | 1-1 | 1 | `icms_70` | Modalidade de determinação da Base de Cálculo do ICMS ST |
| 551 | 227 | 6 | `pMVAST` | Numérico | 0-1 | 7,2-4 | `icms_70` | Percentual da margem de valor Adicionado do ICMS ST |
| 552 | 228 | 6 | `pRedBCST` | Numérico | 0-1 | 7,2-4 | `icms_70` | Percentual da Redução de Base de Cálculo do ICMS ST |
| 553 | 229 | 6 | `vBCST` | Numérico | 1-1 | 15,2 | `icms_70` | Valor da Base de Calculo do ICMS ST |
| 554 | 230 | 6 | `pICMSST` | Numérico | 1-1 | 7,2-4 | `icms_70` | Alíquota do imposto do ICMS ST |
| 555 | 231 | 6 | `vICMSST` | Numérico | 1-1 | 15,2 | `icms_70` | Valor do ICMS ST retido |
| 556 | 231.0 | 6 | **`--sequencia_XML_FCPST_ini--;`** | — | 0-1 | — | `icms_70` | Sequência XML para FCP retido por ST |
| 557 | 231.w | 7 | `vBCFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML_FCPST` | Valor da Base de Cálculo do FCP retido por Substituição Tributária |
| 558 | 231.x | 7 | `pFCPST` | Numérico | 1-1 | 7,2-4 | `sequencia_XML_FCPST` | Percentual do Fundo de Combate à Pobreza (FCP) retido por substituição tributár… |
| 559 | 231.y | 7 | `vFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML_FCPST` | Valor do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária |
| 560 | — | 6 | `--sequencia_XML_FCPST_fim--;` | — | — | — | `icms_70` |  |
| 561 | 231.1 | 6 | **`--x_icms70_deson_ini--;`** | — | 0-1 | — | `icms_70` | Sequência XML |
| 562 | 231.2 | 7 | `vICMSDeson` | Numérico | 1-1 | 15,2 | `x_icms70_deson` | Valor do ICMS desonerado |
| 563 | 231.3 | 7 | `motDesICMS` | Numérico | 1-1 | 2 | `x_icms70_deson` | Motivo da desoneração do ICMS |
| 564 | 231.1a | 7 | `indDeduzDeson` | Numérico | 0-1 | 1 | `x_icms70_deson` | Indica se o valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd… |
| 565 | — | 6 | `--x_icms70_deson_fim--;` | — | — | — | `icms_70` |  |
| 566 | 231.4 | 6 | **`--x_icmsst70_deson_ini--;`** | — | 0-1 | — | `icms_70` | Sequência XML para ICMS ST Desonerado |
| 567 | 231.5 | 7 | `vICMSSTDeson` | Numérico | 1-1 | 15,2 | `x_icmsst70_deson` | Valor do ICMS- ST desonerado |
| 568 | 231.6 | 7 | `motDesICMSST` | Numérico | 1-1 | 2 | `x_icmsst70_deson` | Motivo da desoneração do ICMS- ST |
| 569 | — | 6 | `--x_icmsst70_deson_fim--;` | — | — | — | `icms_70` |  |
| 570 | — | 5 | `--icms_70_fim--;` | — | — | — | `ICMS` |  |

###### `icms_90` — pos. 232 · linhas 571–619 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 571 | 232 | 5 | **`--icms_90_ini--;`** | — | 1-1 | — | `ICMS` | Grupo Tributação do ICMS= 90 |
| 572 | 233 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_90` | Origem da mercadoria / (NT 2013.006) |
| 573 | 234 | 6 | `CST` | Numérico | 1-1 | 2 | `icms_90` | Tributação do ICMS |
| 574 | 234.1 | 6 | **`--x_icms90_icms_ini--;`** | — | 0-1 | — | `icms_90` | Sequência XML |
| 575 | 235 | 7 | `modBC` | Numérico | 1-1 | 1 | `x_icms90_icms` | Modalidade de determinação da Base de Cálculo do ICMS |
| 576 | 236 | 7 | `vBC` | Numérico | 1-1 | 15,2 | `x_icms90_icms` | Valor da Base de Cálculo do ICMS |
| 577 | 237 | 7 | `pRedBC` | Numérico | 0-1 | 7,2-4 | `x_icms90_icms` | Percentual da Redução de Base de Cálculo |
| 578 | 238 | 7 | `pICMS` | Numérico | 1-1 | 7,2-4 | `x_icms90_icms` | Alíquota do imposto |
| 579 | 239 | 7 | `vICMS` | Numérico | 1-1 | 15,2 | `x_icms90_icms` | Valor do ICMS |
| 580 | 237.1a | 7 | `cBenefRBC` | Caractere | 0-1 | 10 | `x_icms90_icms` | Código de Benefício Fiscal na UF aplicado ao item quando houver RBC. |
| 581 | 238.0 | 7 | **`--sequencia_XML_op_ini--;`** | — | 0-1 | — | `x_icms90_icms` |  |
| 582 | 238.01 | 8 | `vICMSOp` | Numérico | 1-1 | 15,2 | `sequencia_XML_op` | Valor do ICMS da Operação |
| 583 | 238.02 | 8 | `pDif` | Numérico | 1-1 | 7,2-4 | `sequencia_XML_op` | Percentual do diferimento |
| 584 | 238.03 | 8 | `vICMSDif` | Numérico | 1-1 | 15,2 | `sequencia_XML_op` | Valor do ICMS diferido |
| 585 | — | 7 | `--sequencia_XML_op_fim--;` | — | — | — | `x_icms90_icms` |  |
| 586 | 239.01 | 7 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `x_icms90_icms` |  |
| 587 | 239.02 | 8 | `vBCFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor da Base de Cálculo do FCP |
| 588 | 239.03 | 8 | `pFCP` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentual do Fundo de Combate à Pobreza (FCP) |
| 589 | 239.04 | 8 | `vFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do Fundo de Combate à Pobreza (FCP) |
| 590 | — | 7 | `--sequencia_XML_fim--;` | — | — | — | `x_icms90_icms` |  |
| 591 | 239.05 | 7 | **`--sequencia_XML_fcpdif_ini--;`** | — | 0-1 | — | `x_icms90_icms` |  |
| 592 | 239.06 | 8 | `pFCPDif` | Numérico | 1-1 | 7,2-4 | `sequencia_XML_fcpdif` | Percentual do diferimento do ICMS relativo ao Fundo de Combate à Pobreza (FCP) |
| 593 | 239.07 | 8 | `vFCPDif` | Numérico | 1-1 | 15,2 | `sequencia_XML_fcpdif` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) diferido |
| 594 | 239.08 | 8 | `vFCPEfet` | Numérico | 0-1 | 15,2 | `sequencia_XML_fcpdif` | Valor efetivo do ICMS relativo ao Fundo de Combate à Pobreza (FCP) |
| 595 | — | 7 | `--sequencia_XML_fcpdif_fim--;` | — | — | — | `x_icms90_icms` |  |
| 596 | — | 6 | `--x_icms90_icms_fim--;` | — | — | — | `icms_90` |  |
| 597 | 239.1 | 6 | **`--x_icms90_icmsst_ini--;`** | — | 0-1 | — | `icms_90` | Sequência XML |
| 598 | 240 | 7 | `modBCST` | Numérico | 1-1 | 1 | `x_icms90_icmsst` | Modalidade de determinação da Base de Cálculo do ICMS ST |
| 599 | 241 | 7 | `pMVAST` | Numérico | 0-1 | 7,2-4 | `x_icms90_icmsst` | Percentual da margem de valor Adicionado do ICMS ST |
| 600 | 242 | 7 | `pRedBCST` | Numérico | 0-1 | 7,2-4 | `x_icms90_icmsst` | Percentual da Redução de Base de Cálculo do ICMS ST |
| 601 | 243 | 7 | `vBCST` | Numérico | 1-1 | 15,2 | `x_icms90_icmsst` | Valor da Base de Cálculo do ICMS ST |
| 602 | 244 | 7 | `pICMSST` | Numérico | 1-1 | 7,2-4 | `x_icms90_icmsst` | Alíquota do imposto do ICMS ST |
| 603 | 245 | 7 | `vICMSST` | Numérico | 1-1 | 15,2 | `x_icms90_icmsst` | Valor do ICMS ST retido |
| 604 | 245.0 | 7 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `x_icms90_icmsst` |  |
| 605 | 245.w | 8 | `vBCFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor da Base de Cálculo do FCP retido por Substituição Tributária |
| 606 | 245.x | 8 | `pFCPST` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentualdo Fundo de Combate à Pobreza (FCP) retido por substituição tributária |
| 607 | 245.y | 8 | `vFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária |
| 608 | — | 7 | `--sequencia_XML_fim--;` | — | — | — | `x_icms90_icmsst` |  |
| 609 | — | 6 | `--x_icms90_icmsst_fim--;` | — | — | — | `icms_90` |  |
| 610 | 245.1 | 6 | **`--x_icms90_deson_ini--;`** | — | 0-1 | — | `icms_90` | Sequência XML |
| 611 | 245.2 | 7 | `vICMSDeson` | — | 1-1 | 15,2 | `x_icms90_deson` | Valor do ICMS desonerado |
| 612 | 245.3 | 7 | `motDesICMS` | — | 1-1 | 2 | `x_icms90_deson` | Motivo da desoneração do ICMS |
| 613 | 245.4 | 7 | `indDeduzDeson` | Numérico | 0-1 | 1 | `x_icms90_deson` | Indica se o valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd… |
| 614 | — | 6 | `--x_icms90_deson_fim--;` | — | — | — | `icms_90` |  |
| 615 | 245.4 | 6 | **`--x_icmsst90_deson_ini--;`** | — | 0-1 | — | `icms_90` | Sequência XML para ICMS ST Desonerado |
| 616 | 245.5 | 7 | `vICMSSTDeson` | Numérico | 1-1 | 15,2 | `x_icmsst90_deson` | Valor do ICMS- ST desonerado |
| 617 | 245.6 | 7 | `motDesICMSST` | Numérico | 1-1 | 2 | `x_icmsst90_deson` | Motivo da desoneração do ICMS- ST |
| 618 | — | 6 | `--x_icmsst90_deson_fim--;` | — | — | — | `icms_90` |  |
| 619 | — | 5 | `--icms_90_fim--;` | — | — | — | `ICMS` |  |

###### `icms_part` — pos. 245.01 · linhas 620–646 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 620 | 245.01 | 5 | **`--icms_part_ini--;`** | — | 1-1 | — | `ICMS` | Grupo de Partilha do ICMS entre a UF de origem e UF de destino ou a UF definida… |
| 621 | 245.02 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_part` | Origem da mercadoria / (NT 2013.006) |
| 622 | 245.03 | 6 | `CST` | Numérico | 1-1 | 2 | `icms_part` | Tributação do ICMS |
| 623 | 245.04 | 6 | `modBC` | Numérico | 1-1 | 1 | `icms_part` | Modalidade de determinação da Base de Cálculo do ICMS |
| 624 | 245.05 | 6 | `vBC` | Numérico | 1-1 | 15,2 | `icms_part` | Valor de Base de Cálculo do ICMS |
| 625 | 245.06 | 6 | `pRedBC` | Numérico | 0-1 | 7,2-4 | `icms_part` | Percentual da Redução de Base de Cálculo |
| 626 | 245.07 | 6 | `pICMS` | Numérico | 1-1 | 7,2-4 | `icms_part` | Alíquota do imposto |
| 627 | 245.08 | 6 | `vICMS` | Numérico | 1-1 | 15,2 | `icms_part` | Valor do ICMS |
| 628 | 245.09 | 6 | `modBCST` | Numérico | 1-1 | 1 | `icms_part` | Modalidade de determinação da Base de Cálculo do ICMS ST |
| 629 | 245.10 | 6 | `pMVAST` | Numérico | 0-1 | 7,2-4 | `icms_part` | Percentual da margem de valor Adicionado do ICMS ST |
| 630 | 245.11 | 6 | `pRedBCST` | Numérico | 0-1 | 7,2-4 | `icms_part` | Percentual da redução de Base de Cálculo do ICMS ST |
| 631 | 245.12 | 6 | `vBCST` | Numérico | 1-1 | 15,2 | `icms_part` | Valor da Base de Cálculo do ICMS |
| 632 | 245.13 | 6 | `pICMSST` | Numérico | 1-1 | 7,2-4 | `icms_part` | Alíquota do imposto ICMS ST |
| 633 | 245.14 | 6 | `vICMSST` | Numérico | 1-1 | 15,2 | `icms_part` | Valor do ICMS ST |
| 634 | 245.14a | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `icms_part` | Sequencia XML |
| 635 | 245.14b | 7 | `vBCFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor da Base de Cálculo do FCP ST |
| 636 | 245.14c | 7 | `pFCPST` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentual do FCP ST |
| 637 | 245.14d | 7 | `vFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do FCP ST |
| 638 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `icms_part` |  |
| 639 | 245.15 | 6 | `pBCOp` | Numérico | 1-1 | 7,2-4 | `icms_part` | Percentual para determinação do valor da Base de Cálculo da operação própria. |
| 640 | 245.16 | 6 | `UFST` | Caractere | 1-1 | 2 | `icms_part` | UF para qual é devido o ICMS ST |
| 641 | 245.17 | 6 | **`--sequencia_XML_deson_ini--;`** | — | 0-1 | — | `icms_part` | Sequencia XML |
| 642 | 245.18 | 7 | `vICMSDeson` | Numérico | 1-1 | 15,2 | `sequencia_XML_deson` | Valor do ICMS desonerado |
| 643 | 245.19 | 7 | `motDesICMS` | Numérico | 1-1 | 2 | `sequencia_XML_deson` | Motivo da desoneração do ICMS |
| 644 | 245.20 | 7 | `indDeduzDeson` | Numérico | 0-1 | 1 | `sequencia_XML_deson` | Indica se o valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd… |
| 645 | — | 6 | `--sequencia_XML_deson_fim--;` | — | — | — | `icms_part` |  |
| 646 | — | 5 | `--icms_part_fim--;` | — | — | — | `ICMS` |  |

###### `icms_st` — pos. 245.17 · linhas 647–667 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 647 | 245.17 | 5 | **`--icms_st_ini--;`** | — | 1-1 | — | `ICMS` | Grupo de Repasse de ICMS ST retido anteriormente em operações interestaduais co… |
| 648 | 245.18 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_st` | Origem da mercadoria / (NT 2013.006) |
| 649 | 245.19 | 6 | `CST` | Numérico | 1-1 | 2 | `icms_st` | Tributação do ICMS |
| 650 | 245.20 | 6 | `vBCSTRet` | Numérico | 1-1 | 15,2 | `icms_st` | Valor da Base de Cálculo do ICMS ST retido na UF remetente |
| 651 | 245.20a | 6 | `pST` | Numérico | 0-1 | 7,2-4 | `icms_st` | Alíquota suportada pelo Consumidor Final |
| 652 | 245.20b | 6 | `vICMSSubstituto` | Numérico | 0-1 | 15,2 | `icms_st` | Valor do ICMS próprio do Substituto |
| 653 | 245.21 | 6 | `vICMSSTRet` | Numérico | 1-1 | 15,2 | `icms_st` | Valor do ICMS ST retido na UF remetente |
| 654 | 245.21a | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `icms_st` | Sequencia XML |
| 655 | 245.21b | 7 | `vBCFCPSTRet` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor da Base de Cálculo do FCP retido anteriormente por Substituição Tributária |
| 656 | 245.21c | 7 | `pFCPSTRet` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentual do FCP retido anteriormente por Substituição Tributária |
| 657 | 245.21d | 7 | `vFCPSTRet` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do FCP retido por Substituição Tributária |
| 658 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `icms_st` |  |
| 659 | 245.22 | 6 | `vBCSTDest` | Numérico | 1-1 | 15,2 | `icms_st` | Valor da Base de Cálculo do ICMS ST da UF destino |
| 660 | 245.23 | 6 | `vICMSSTDest` | Numérico | 1-1 | 15,2 | `icms_st` | Valor do ICMS ST da UF destino |
| 661 | 245.23a | 6 | **`--x_icms_efetivo_ini--;`** | — | 0-1 | — | `icms_st` | Informações do ICMS Efetivo |
| 662 | 245.23b | 7 | `pRedBCEfet` | Numérico | 1-1 | 7,2-4 | `x_icms_efetivo` | Percentual de redução da base de cáclulo efetiva |
| 663 | 245.23c | 7 | `vBCEfet` | Numérico | 1-1 | 15,2 | `x_icms_efetivo` | Valor da base de cálculo efetiva |
| 664 | 245.23d | 7 | `pICMSEfet` | Numérico | 1-1 | 7,2-4 | `x_icms_efetivo` | Alíquota do ICMS efetiva |
| 665 | 245.23e | 7 | `vICMSEfet` | Numérico | 1-1 | 15,2 | `x_icms_efetivo` | Valor do ICMS Efetivo |
| 666 | — | 6 | `--x_icms_efetivo_fim--;` | — | — | — | `icms_st` |  |
| 667 | — | 5 | `--icms_st_fim--;` | — | — | — | `ICMS` |  |

###### `icms_sn101` — pos. 245.24 · linhas 668–673 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 668 | 245.24 | 5 | **`--icms_sn101_ini--;`** | — | 1-1 | — | `ICMS` | Grupo CRT= 1 - Simples Nacional e CSOSN= 101 |
| 669 | 245.25 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_sn101` | Origem da mercadoria / (NT 2013.006) |
| 670 | 245.26 | 6 | `CSOSN` | Numérico | 1-1 | 3 | `icms_sn101` | Código de Situação da Operação –Simples Nacional |
| 671 | 245.27 | 6 | `pCredSN` | Numérico | 1-1 | 7,2-4 | `icms_sn101` | Alíquota aplicável de cálculo do crédito (Simples Nacional) |
| 672 | 245.28 | 6 | `vCredICMSSN` | Numérico | 1-1 | 15,2 | `icms_sn101` | Valor crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123… |
| 673 | — | 5 | `--icms_sn101_fim--;` | — | — | — | `ICMS` |  |

###### `icms_sn102` — pos. 245.24 · linhas 674–677 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 674 | 245.24 | 5 | **`--icms_sn102_ini--;`** | — | 1-1 | — | `ICMS` | Grupo CRT=1 – Simples Nacional, CRT=4 – MEI e CSOSN=102, 103, 300 ou 400 |
| 675 | 245.25 | 6 | `orig` | Numérico | 0-1 | 1 | `icms_sn102` | Origem da mercadoria / (NT 2013.006) |
| 676 | 245.26 | 6 | `CSOSN` | Numérico | 1-1 | 3 | `icms_sn102` | Código de Situação da Operação – Simples Nacional |
| 677 | — | 5 | `--icms_sn102_fim--;` | — | — | — | `ICMS` |  |

###### `icms_sn201` — pos. 245.27 · linhas 678–694 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 678 | 245.27 | 5 | **`--icms_sn201_ini--;`** | — | 1-1 | — | `ICMS` | Grupo CRT= 1 - Simples Nacional e CSOSN= 201 |
| 679 | 245.28 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_sn201` | Origem da mercadoria / (NT 2013.006) |
| 680 | 245.29 | 6 | `CSOSN` | Numérico | 1-1 | 3 | `icms_sn201` | Código de Situação da Operação – Simples Nacional |
| 681 | 245.30 | 6 | `modBCST` | Numérico | 1-1 | 1 | `icms_sn201` | Modalidade de determinação da Base de Cálculo do ICMS ST |
| 682 | 245.31 | 6 | `pMVAST` | Numérico | 0-1 | 7,2-4 | `icms_sn201` | Percentual da margem de valor Adicionado do ICMS ST |
| 683 | 224.32 | 6 | `pRedBCST` | Numérico | 0-1 | 7,2-4 | `icms_sn201` | Percentual da redução de Base de Cálculo do ICMS ST |
| 684 | 245.33 | 6 | `vBCST` | Numérico | 1-1 | 15,2 | `icms_sn201` | Valor da Base de Cálculo do ICMS ST |
| 685 | 245.34 | 6 | `pICMSST` | Numérico | 1-1 | 7,2-4 | `icms_sn201` | Alíquota do imposto do ICMS ST |
| 686 | 245.35 | 6 | `vICMSST` | Numérico | 1-1 | 15,2 | `icms_sn201` | Valor do ICMS ST |
| 687 | 245.35.0 | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `icms_sn201` |  |
| 688 | 245.35w | 7 | `vBCFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor da Base de Cálculo do FCP retido por Substituição Tributária |
| 689 | 245.35x | 7 | `pFCPST` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentual do Fundo de Combate à Pobreza (FCP) retido por substituição tributár… |
| 690 | 245.35y | 7 | `vFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária |
| 691 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `icms_sn201` |  |
| 692 | 245.36 | 6 | `pCredSN` | Numérico | 1-1 | 7,2-4 | `icms_sn201` | Alíquota aplicável de cálculo do crédito (Simples Nacional) |
| 693 | 245.37 | 6 | `vCredICMSSN` | Numérico | 1-1 | 15,2 | `icms_sn201` | Valor credito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123… |
| 694 | — | 5 | `--icms_sn201_fim--;` | — | — | — | `ICMS` |  |

###### `icms_sn202` — pos. 245.38 · linhas 695–709 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 695 | 245.38 | 5 | **`--icms_sn202_ini--;`** | — | 1-1 | — | `ICMS` | Grupo CRT= 1 - Simples Nacional e CSOSN= 202 ou 203 |
| 696 | 245.39 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_sn202` | Origem da mercadoria / (NT 2013.006) |
| 697 | 245.40 | 6 | `CSOSN` | Numérico | 1-1 | 3 | `icms_sn202` | Código de Situação da Operação – Simples Nacional |
| 698 | 245.41 | 6 | `modBCST` | Numérico | 1-1 | 1 | `icms_sn202` | Modalidade de determinação da Base de Cálculo do ICMS ST |
| 699 | 245.42 | 6 | `pMVAST` | Numérico | 0-1 | 7,2-4 | `icms_sn202` | Percentual da margem de valor Adicionado do ICMS ST |
| 700 | 224.43 | 6 | `pRedBCST` | Numérico | 0-1 | 7,2-4 | `icms_sn202` | Percentual da redução de Base de Cálculo do ICMS ST |
| 701 | 245.44 | 6 | `vBCST` | Numérico | 1-1 | 15,2 | `icms_sn202` | Valor da Base de Cálculo do ICMS ST |
| 702 | 245.45 | 6 | `pICMSST` | Numérico | 1-1 | 7,2-4 | `icms_sn202` | Alíquota do imposto do ICMS ST |
| 703 | 245.46 | 6 | `vICMSST` | Numérico | 1-1 | 15,2 | `icms_sn202` | Valor do ICMS ST retido |
| 704 | 245.46.0 | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `icms_sn202` |  |
| 705 | 245.46w | 7 | `vBCFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor da Base de Cálculo do FCP retido por Substituição Tributária |
| 706 | 245.46x | 7 | `pFCPST` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentual do Fundo de Combate à Pobreza (FCP) retido por substituição tributár… |
| 707 | 245.46y | 7 | `vFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária |
| 708 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `icms_sn202` |  |
| 709 | — | 5 | `--icms_sn202_fim--;` | — | — | — | `ICMS` |  |

###### `icms_sn500` — pos. 245.47 · linhas 710–730 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 710 | 245.47 | 5 | **`--icms_sn500_ini--;`** | — | 1-1 | — | `ICMS` | Grupo CRT= 1 - Simples Nacional e CSOSN= 500 |
| 711 | 245.48 | 6 | `orig` | Numérico | 1-1 | 1 | `icms_sn500` | Origem da mercadoria / (NT 2013.006) |
| 712 | 245.49 | 6 | `CSOSN` | Numérico | 1-1 | 3 | `icms_sn500` | Código de Situação da Operação – Simples Nacional |
| 713 | 245.50 | 6 | **`--x_sn500_retido_ini--;`** | — | 0-1 | — | `icms_sn500` | Sequência XML |
| 714 | 245.50 | 7 | `vBCSTRet` | Numérico | 1-1 | 15,2 | `x_sn500_retido` | Valor da Base de Cálculo do ICMS ST retido |
| 715 | 245.50.0 | 7 | `pST` | Numérico | 1-1 | 7,2-4 | `x_sn500_retido` | Alíquota suportada pelo Consumidor Final |
| 716 | 245.50.1 | 7 | `vICMSSubstituto` | Numérico | 0-1 | 15,2 | `x_sn500_retido` | Valor do ICMS próprio do Substituto |
| 717 | 245.51 | 7 | `vICMSSTRet` | Numérico | 1-1 | 15,2 | `x_sn500_retido` | Valor do ICMS ST retido |
| 718 | — | 6 | `--x_sn500_retido_fim--;` | — | — | — | `icms_sn500` |  |
| 719 | 245.51.0 | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `icms_sn500` |  |
| 720 | 425.51w | 7 | `vBCFCPSTRet` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor da Base de Cálculo do FCP retido anteriormente por Substituição Tributária |
| 721 | 245.51x | 7 | `pFCPSTRet` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentual do Fundo de Combate à Pobreza (FCP) retido anteriormente por ST |
| 722 | 245.51y | 7 | `vFCPSTRet` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária |
| 723 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `icms_sn500` |  |
| 724 | 245.51.1 | 6 | **`--x_icms_efetivo_ini--;`** | — | 0-1 | — | `icms_sn500` | Informações do ICMS Efetivo |
| 725 | 245.51.2 | 7 | `pRedBCEfet` | Numérico | 1-1 | 7,2-4 | `x_icms_efetivo` | Percentual de redução da base de cáclulo efetiva |
| 726 | 245.51.3 | 7 | `vBCEfet` | Numérico | 1-1 | 15,2 | `x_icms_efetivo` | Valor da base de cálculo efetiva |
| 727 | 245.51.4 | 7 | `pICMSEfet` | Numérico | 1-1 | 7,2-4 | `x_icms_efetivo` | Alíquota do ICMS efetiva |
| 728 | 245.51.5 | 7 | `vICMSEfet` | Numérico | 1-1 | 15,2 | `x_icms_efetivo` | Valor do ICMS Efetivo |
| 729 | — | 6 | `--x_icms_efetivo_fim--;` | — | — | — | `icms_sn500` |  |
| 730 | — | 5 | `--icms_sn500_fim--;` | — | — | — | `ICMS` |  |

###### `icms_sn900` — pos. 245.52 · linhas 731–758 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 731 | 245.52 | 5 | **`--icms_sn900_ini--;`** | — | 1-1 | — | `ICMS` | Grupo CRT=1 – Simples Nacional, CRT=4 – MEI e CSOSN=900 |
| 732 | 245.53 | 6 | `orig` | Numérico | 0-1 | 1 | `icms_sn900` | Origem da mercadoria / (NT 2013.006) |
| 733 | 245.54 | 6 | `CSOSN` | Numérico | 1-1 | 2 | `icms_sn900` | Código de Situação da Operação – Simples Nacional |
| 734 | 245.55 | 6 | **`--x_sn900_icms_ini--;`** | — | 0-1 | — | `icms_sn900` | Sequência XML |
| 735 | 245.55 | 7 | `modBC` | Numérico | 1-1 | 1 | `x_sn900_icms` | Modalidade de determinação da Base de Cálculo do ICMS ST |
| 736 | 245.56 | 7 | `vBC` | Numérico | 1-1 | 15,2 | `x_sn900_icms` | Valor do Base de Cálculo do ICMS |
| 737 | 245.57 | 7 | `pRedBC` | Numérico | 0-1 | 7,2-4 | `x_sn900_icms` | Percentual da Redução de Base de Cálculo |
| 738 | 245.58 | 7 | `pICMS` | Numérico | 1-1 | 7,2-4 | `x_sn900_icms` | Alíquota do imposto |
| 739 | 245.59 | 7 | `vICMS` | Numérico | 1-1 | 15,2 | `x_sn900_icms` | Valor do ICMS |
| 740 | — | 6 | `--x_sn900_icms_fim--;` | — | — | — | `icms_sn900` |  |
| 741 | 245.60 | 6 | **`--x_sn900_icmsst_ini--;`** | — | 0-1 | — | `icms_sn900` | Sequência XML |
| 742 | 245.60 | 7 | `modBCST` | Numérico | 1-1 | 1 | `x_sn900_icmsst` | Modalidade de determinação da Base de Cálculo do ICMS ST |
| 743 | 245.61 | 7 | `pMVAST` | Numérico | 0-1 | 7,2-4 | `x_sn900_icmsst` | Percentual da margem de valor Adicionado do ICMS ST |
| 744 | 245.62 | 7 | `pRedBCST` | Numérico | 0-1 | 7,2-4 | `x_sn900_icmsst` | Percentual da redução de Base de Cálculo do ICMS ST |
| 745 | 245.63 | 7 | `vBCST` | Numérico | 1-1 | 15,2 | `x_sn900_icmsst` | Valor da Base de Cálculo do ICMS |
| 746 | 245.64 | 7 | `pICMSST` | Numérico | 1-1 | 7,2-4 | `x_sn900_icmsst` | Alíquota do imposto do ICMS ST |
| 747 | 245.65 | 7 | `vICMSST` | Numérico | 1-1 | 15,2 | `x_sn900_icmsst` | Valor do ICMS ST retido |
| 748 | — | 6 | `--x_sn900_icmsst_fim--;` | — | — | — | `icms_sn900` |  |
| 749 | 245.65.0 | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `icms_sn900` |  |
| 750 | 245.65w | 7 | `vBCFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor da Base de Cálculo do FCP retido por Substituição Tributária |
| 751 | 245.65x | 7 | `pFCPST` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` | Percentual do Fundo de Combate à Pobreza (FCP) retido por substituição tributár… |
| 752 | 245.65y | 7 | `vFCPST` | Numérico | 1-1 | 15,2 | `sequencia_XML` | Valor do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária |
| 753 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `icms_sn900` |  |
| 754 | 245.52 | 6 | **`--x_sn900_credito_ini--;`** | — | 0-1 | — | `icms_sn900` | Sequência XML |
| 755 | 245.52 | 7 | `pCredSN` | Numérico | 1-1 | 7,2-4 | `x_sn900_credito` | Alíquota aplicável de calculo do credito (Simples Nacional) |
| 756 | 245.53 | 7 | `vCredICMSSN` | Numérico | 1-1 | 15,2 | `x_sn900_credito` | Valor crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123… |
| 757 | — | 6 | `--x_sn900_credito_fim--;` | — | — | — | `icms_sn900` |  |
| 758 | — | 5 | `--icms_sn900_fim--;` | — | — | — | `ICMS` |  |

###### `ICMS_Previsto` — pos. 245b.01 · linhas 759–761 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 759 | 245b.01 | 5 | **`--ICMS_Previsto_ini--;`** | — | 0-1 | — | `ICMS` | Grupo do ICMS Previsto no Pagamento Antecipado |
| 760 | 245b.02 | 6 | `vICMSPrevisto` | Numérico | 1-1 | 15,2 | `ICMS_Previsto` | Valor do ICMS Previsto |
| 761 | — | 5 | `--ICMS_Previsto_fim--;` | — | — | — | `ICMS` |  |

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 762 | — | 4 | `--ICMS_fim--;` | — | — | — | `impostos` |  |

###### `ICMS_UF_Dest` — pos. 245a.01 · linhas 763–773 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 763 | 245a.01 | 4 | **`--ICMS_UF_Dest_ini--;`** | — | 0-1 | — | `impostos` | Informação do ICMS Interestadual |
| 764 | 245a.03 | 5 | `vBCUFDest` | Numérico | 1-1 | 15,2 | `ICMS_UF_Dest` | Valor da Base de Cálculo do ICMS na UF de destino |
| 765 | 245a.04 | 5 | `vBCFCPUFDest` | Numérico | 0-1 | 15,2 | `ICMS_UF_Dest` | Valor da Base de Cálculo do FCP na UF de Destino |
| 766 | 245a.05 | 5 | `pFCPUFDest` | Numérico | 0-1 | 7,2-4 | `ICMS_UF_Dest` | Percentual do ICMS relativo ao Fundo de Combate à Pobreza (FCP) na UF de destino |
| 767 | 245a.07 | 5 | `pICMSUFDest` | Numérico | 1-1 | 7,2-4 | `ICMS_UF_Dest` | Alíquota Interna da UF de destino |
| 768 | 245a.09 | 5 | `pICMSInter` | Caractere | 1-1 | 5 | `ICMS_UF_Dest` | Alíquota interestadual das UF envolvidas |
| 769 | 245a.11 | 5 | `pICMSInterPart` | Numérico | 1-1 | 7,2-4 | `ICMS_UF_Dest` | Percentual provisório de partilha do ICMS Interestadual |
| 770 | 245a.13 | 5 | `vFCPUFDest` | Numérico | 0-1 | 15,2 | `ICMS_UF_Dest` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) da UF de destino. |
| 771 | 245a.15 | 5 | `vICMSUFDest` | Numérico | 1-1 | 15,2 | `ICMS_UF_Dest` | Valor do ICMS Interestadual para a UF de destino |
| 772 | 245a.17 | 5 | `vICMSUFRemet` | Numérico | 1-1 | 15,2 | `ICMS_UF_Dest` | Valor do ICMS interestadual para a UF do remetente |
| 773 | — | 4 | `--ICMS_UF_Dest_fim--;` | — | — | — | `impostos` |  |

###### `IPI` — pos. 246 · linhas 774–794 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 774 | 246 | 4 | **`--IPI_ini--;`** | — | 0-1 | — | `impostos` | Grupo IPI |
| 775 | 248 | 5 | `CNPJProd` | Caractere | 0-1 | 14 | `IPI` | CNPJ do produtor da mercadoria, quando diferente do emitente. Somente para os c… |
| 776 | 249 | 5 | `cSelo` | Caractere | 0-1 | 1-60 | `IPI` | Código do selo de controle IPI |
| 777 | 250 | 5 | `qSelo` | Numérico | 0-1 | 1-12 | `IPI` | Quantidade de selo de controle |
| 778 | 251 | 5 | `cEnc` | Numérico | 1-1 | 1-3 | `IPI` | Código de Enquadramento Legal do IPI |
| 779 | 252 | 5 | **`--ipi_trib_ini--;`** | — | 1-1 | — | `IPI` | Grupo do CST 00, 49, 50 e 99 |
| 780 | 253 | 6 | `CST` | Caractere | 1-1 | 2 | `ipi_trib` | Código da Situação Tributária do IPI |
| 781 | 253.1 | 6 | **`--x_ipi_aliq_ini--;`** | — | 1-1 | — | `ipi_trib` | Sequência XML |
| 782 | 254 | 7 | `vBC` | Numérico | 1-1 | 15,2 | `x_ipi_aliq` | Valor da Base de Cálculo do IPI |
| 783 | 257 | 7 | `pIPI` | Numérico | 1-1 | 7,2-4 | `x_ipi_aliq` | Alíquota do IPI |
| 784 | — | 6 | `--x_ipi_aliq_fim--;` | — | — | — | `ipi_trib` |  |
| 785 | 257.1 | 6 | **`--x_ipi_unid_ini--;`** | — | 1-1 | — | `ipi_trib` | Sequência XML |
| 786 | 255 | 7 | `qUnid` | Numérico | 1-1 | 16,0-4 | `x_ipi_unid` | Quantidade total na unidade padrão para tributação( somente para os produtos tr… |
| 787 | 256 | 7 | `vUnid` | Numérico | 1-1 | 15,0-4 | `x_ipi_unid` | Valor por unidade Tributável |
| 788 | — | 6 | `--x_ipi_unid_fim--;` | — | — | — | `ipi_trib` |  |
| 789 | 259 | 6 | `vIPI` | Numérico | 1-1 | 15,2 | `ipi_trib` | Valor do IPI |
| 790 | — | 5 | `--ipi_trib_fim--;` | — | — | — | `IPI` |  |
| 791 | 260 | 5 | **`--ipi_nt_ini--;`** | — | 1-1 | — | `IPI` | Grupo CST 01, 02, 03, 04, 51, 52, 53, 54 e 55 |
| 792 | 261 | 6 | `CST` | Caractere | 1-1 | 2 | `ipi_nt` | Código da Situação Tributária do IPI |
| 793 | — | 5 | `--ipi_nt_fim--;` | — | — | — | `IPI` |  |
| 794 | — | 4 | `--IPI_fim--;` | — | — | — | `impostos` |  |

###### `II` — pos. 262 · linhas 795–800 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 795 | 262 | 4 | **`--II_ini--;`** | — | 0-1 | — | `impostos` | Grupo de Imposto de Importação |
| 796 | 263 | 5 | `vBC` | Numérico | 0-1 | 15,2 | `II` | Valor da Base de Cálculo do Imposto de Importação |
| 797 | 264 | 5 | `vDespAdu` | Numérico | 0-1 | 15,2 | `II` | Valor das Despesas Aduaneiras |
| 798 | 265 | 5 | `vII` | Numérico | 0-1 | 15,2 | `II` | Valor do Imposto de Importação |
| 799 | 266 | 5 | `vIOF` | Numérico | 0-1 | 15,2 | `II` | Valor do Imposto sobre Operações Financeiras |
| 800 | — | 4 | `--II_fim--;` | — | — | — | `impostos` |  |

###### `PIS` — pos. 267 · linhas 801–829 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 801 | 267 | 4 | **`--PIS_ini--;`** | — | 0-1 | — | `impostos` | Grupo PIS |
| 802 | 268 | 5 | **`--pis_aliq_ini--;`** | — | 1-1 | — | `PIS` | Grupo PIS tributado pela alíquota |
| 803 | 269 | 6 | `CST` | Numérico | 1-1 | 2 | `pis_aliq` | Código de Situação Tributária do PIS |
| 804 | 270 | 6 | `vBC` | Numérico | 1-1 | 15,2 | `pis_aliq` | Valor da Base de Cálculo do PIS |
| 805 | 271 | 6 | `pPIS` | Numérico | 1-1 | 7,2-4 | `pis_aliq` | Alíquota do PIS(em percentual) |
| 806 | 272 | 6 | `vPIS` | Numérico | 1-1 | 15,2 | `pis_aliq` | Valor do PIS |
| 807 | — | 5 | `--pis_aliq_fim--;` | — | — | — | `PIS` |  |
| 808 | 273 | 5 | **`--pis_qtde_ini--;`** | — | 1-1 | — | `PIS` | Grupo PIS tributado por Quantidade |
| 809 | 274 | 6 | `CST` | Numérico | 1-1 | 2 | `pis_qtde` | Código de Situação Tributária do PIS |
| 810 | 275 | 6 | `qBCProd` | Numérico | 1-1 | 16,0-4 | `pis_qtde` | Quantidade Vendida |
| 811 | 276 | 6 | `vAliqProd` | Numérico | 1-1 | 15,0-4 | `pis_qtde` | Alíquota do PIS (em reais) |
| 812 | 277 | 6 | `vPIS` | Numérico | 1-1 | 15,2 | `pis_qtde` | Valor do PIS |
| 813 | — | 5 | `--pis_qtde_fim--;` | — | — | — | `PIS` |  |
| 814 | 278 | 5 | **`--pis_nt_ini--;`** | — | 1-1 | — | `PIS` | Grupo PIS não tributado |
| 815 | 279 | 6 | `CST` | Numérico | 1-1 | 2 | `pis_nt` | Código de Situação Tributária do PIS |
| 816 | — | 5 | `--pis_nt_fim--;` | — | — | — | `PIS` |  |
| 817 | 280 | 5 | **`--pis_outr_ini--;`** | — | 1-1 | — | `PIS` | Grupo PIS Outras Operações |
| 818 | 281 | 6 | `CST` | Numérico | 1-1 | 2 | `pis_outr` | Código de Situação Tributária do PIS |
| 819 | 281.1 | 6 | **`--x_pis_percent_ini--;`** | — | 1-1 | — | `pis_outr` | Sequência XML |
| 820 | 282 | 7 | `vBC` | Numérico | 1-1 | 15,2 | `x_pis_percent` | Valor da Base de Cálculo do PIS |
| 821 | 283 | 7 | `pPIS` | Numérico | 1-1 | 7,2-4 | `x_pis_percent` | Alíquota do PIS (em percentual) |
| 822 | — | 6 | `--x_pis_percent_fim--;` | — | — | — | `pis_outr` |  |
| 823 | 283.1 | 6 | **`--x_pis_valor_ini--;`** | — | 1-1 | — | `pis_outr` | Sequência XML |
| 824 | 284 | 7 | `qBCProd` | Numérico | 1-1 | 16,0-4 | `x_pis_valor` | Quantidade Vendida |
| 825 | 285 | 7 | `vAliqProd` | Numérico | 1-1 | 15,0-4 | `x_pis_valor` | Alíquota do PIS (em reais) |
| 826 | — | 6 | `--x_pis_valor_fim--;` | — | — | — | `pis_outr` |  |
| 827 | 286 | 6 | `vPIS` | Numérico | 1-1 | 15,2 | `pis_outr` | Valor do PIS |
| 828 | — | 5 | `--pis_outr_fim--;` | — | — | — | `PIS` |  |
| 829 | — | 4 | `--PIS_fim--;` | — | — | — | `impostos` |  |

###### `PISST` — pos. 287 · linhas 830–841 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 830 | 287 | 4 | **`--PISST_ini--;`** | — | 0-1 | — | `impostos` | Grupo PIS Substituição Tributária |
| 831 | 287.1 | 5 | **`--x_pisst_percent_ini--;`** | — | 1-1 | — | `PISST` | Sequência XML |
| 832 | 288 | 6 | `vBC` | Numérico | 1-1 | 15,2 | `x_pisst_percent` | Valor da Base de Cálculo do PIS |
| 833 | 289 | 6 | `pPIS` | Numérico | 1-1 | 7,2-4 | `x_pisst_percent` | Alíquota do PIS(em percentual) |
| 834 | — | 5 | `--x_pisst_percent_fim--;` | — | — | — | `PISST` |  |
| 835 | 289.1 | 5 | **`--x_pisst_valor_ini--;`** | — | 1-1 | — | `PISST` | Sequência XML |
| 836 | 290 | 6 | `qBCProd` | Numérico | 1-1 | 16,0-4 | `x_pisst_valor` | Quantidade Vendida |
| 837 | 291 | 6 | `vAliqProd` | Numérico | 1-1 | 15,0-4 | `x_pisst_valor` | Alíquota do PIS(em reais) |
| 838 | — | 5 | `--x_pisst_valor_fim--;` | — | — | — | `PISST` |  |
| 839 | 292 | 5 | `vPIS` | Numérico | 1-1 | 15,2 | `PISST` | Valor do PIS |
| 840 | 292.01 | 5 | `indSomaPISST` | Numérico | 0-1 | 1 | `PISST` | Indica se o valor do PISST compõe o valor total da NF-e |
| 841 | — | 4 | `--PISST_fim--;` | — | — | — | `impostos` |  |

###### `COFINS` — pos. 293 · linhas 842–870 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 842 | 293 | 4 | **`--COFINS_ini--;`** | — | 0-1 | — | `impostos` | Grupo COFINS |
| 843 | 294 | 5 | **`--cofins_aliq_ini--;`** | — | 1-1 | — | `COFINS` | Grupo COFINS tributado pela alíquota |
| 844 | 295 | 6 | `CST` | Numérico | 1-1 | 2 | `cofins_aliq` | Código de Situação Tributária da COFINS |
| 845 | 296 | 6 | `vBC` | Numérico | 1-1 | 15,2 | `cofins_aliq` | Valor da Base de Cálculo da COFINS |
| 846 | 297 | 6 | `pCOFINS` | Numérico | 1-1 | 7,2-4 | `cofins_aliq` | Alíquota da COFINS (em percentual) |
| 847 | 298 | 6 | `vCOFINS` | Numérico | 1-1 | 15,2 | `cofins_aliq` | Valor da COFINS |
| 848 | — | 5 | `--cofins_aliq_fim--;` | — | — | — | `COFINS` |  |
| 849 | 299 | 5 | **`--cofins_qtde_ini--;`** | — | 1-1 | — | `COFINS` | Grupo de COFINS tributado por Quantidade |
| 850 | 300 | 6 | `CST` | Numérico | 1-1 | 2 | `cofins_qtde` | Código de Situação Tributária da COFINS |
| 851 | 301 | 6 | `qBCProd` | Numérico | 1-1 | 16,0-4 | `cofins_qtde` | Quantidade Vendida |
| 852 | 302 | 6 | `vAliqProd` | Numérico | 1-1 | 15,0-4 | `cofins_qtde` | Alíquota da COFINS (em reais) |
| 853 | 303 | 6 | `vCOFINS` | Numérico | 1-1 | 15,2 | `cofins_qtde` | Valor da COFINS |
| 854 | — | 5 | `--cofins_qtde_fim--;` | — | — | — | `COFINS` |  |
| 855 | 304 | 5 | **`--cofins_nt_ini--;`** | — | 1-1 | — | `COFINS` | Grupo COFINS não tributado |
| 856 | 305 | 6 | `CST` | Numérico | 1-1 | 2 | `cofins_nt` | Código de Situação Tributária da COFINS |
| 857 | — | 5 | `--cofins_nt_fim--;` | — | — | — | `COFINS` |  |
| 858 | 306 | 5 | **`--cofins_outr_ini--;`** | — | 1-1 | — | `COFINS` | Grupo COFINS Outras Operações |
| 859 | 307 | 6 | `CST` | Numérico | 1-1 | 2 | `cofins_outr` | Código de Situação Tributária da COFINS |
| 860 | 307.1 | 6 | **`--x_cofinsoutr_percent_ini--;`** | — | 1-1 | — | `cofins_outr` | Sequência XML |
| 861 | 308 | 7 | `vBC` | Numérico | 1-1 | 15,2 | `x_cofinsoutr_percent` | Valor da Base de Cálculo da COFINS |
| 862 | 309 | 7 | `pCOFINS` | Numérico | 1-1 | 7,2-4 | `x_cofinsoutr_percent` | Alíquota da COFINS (em percentual) |
| 863 | — | 6 | `--x_cofinsoutr_percent_fim--;` | — | — | — | `cofins_outr` |  |
| 864 | 309.1 | 6 | **`--x_cofinsoutr_valor_ini--;`** | — | 1-1 | — | `cofins_outr` | Sequência XML |
| 865 | 310 | 7 | `qBCProd` | Numérico | 1-1 | 16,0-4 | `x_cofinsoutr_valor` | Quantidade Vendida |
| 866 | 311 | 7 | `vAliqProd` | Numérico | 1-1 | 15,0-4 | `x_cofinsoutr_valor` | Alíquota da COFINS (em reais) |
| 867 | — | 6 | `--x_cofinsoutr_valor_fim--;` | — | — | — | `cofins_outr` |  |
| 868 | 312 | 6 | `vCOFINS` | Numérico | 1-1 | 15,2 | `cofins_outr` | Valor da COFINS |
| 869 | — | 5 | `--cofins_outr_fim--;` | — | — | — | `COFINS` |  |
| 870 | — | 4 | `--COFINS_fim--;` | — | — | — | `impostos` |  |

###### `COFINSST` — pos. 313 · linhas 871–882 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 871 | 313 | 4 | **`--COFINSST_ini--;`** | — | 0-1 | — | `impostos` | Grupo COFINS Substituição Tributária |
| 872 | 313.1 | 5 | **`--x_cofinsst_percent_ini--;`** | — | 1-1 | — | `COFINSST` | Sequência XML |
| 873 | 314 | 6 | `vBC` | Numérico | 1-1 | 15,2 | `x_cofinsst_percent` | Valor da Base de Cálculo da COFINS |
| 874 | 315 | 6 | `pCOFINS` | Numérico | 1-1 | 7,2-4 | `x_cofinsst_percent` | Alíquota da COFINS (em percentual) |
| 875 | — | 5 | `--x_cofinsst_percent_fim--;` | — | — | — | `COFINSST` |  |
| 876 | 315.1 | 5 | **`--x_cofinsst_valor_ini--;`** | — | 1-1 | — | `COFINSST` | Sequência XML |
| 877 | 316 | 6 | `qBCProd` | Numérico | 1-1 | 16,0-4 | `x_cofinsst_valor` | Quantidade Vendida |
| 878 | 317 | 6 | `vAliqProd` | Numérico | 1-1 | 15,0-4 | `x_cofinsst_valor` | Alíquota da COFINS (Em reais) |
| 879 | — | 5 | `--x_cofinsst_valor_fim--;` | — | — | — | `COFINSST` |  |
| 880 | 318 | 5 | `vCOFINS` | Numérico | 1-1 | 15,2 | `COFINSST` | Valor da COFINS |
| 881 | 318.01 | 5 | `indSomaCOFINSST` | Numérico | 0-1 | 1 | `COFINSST` | Indica se o valor da COFINS ST compõe o valor total da Nfe |
| 882 | — | 4 | `--COFINSST_fim--;` | — | — | — | `impostos` |  |

###### `ISSQN` — pos. 319 · linhas 883–900 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 883 | 319 | 4 | **`--ISSQN_ini--;`** | — | 0-1 | — | `impostos` | Grupo ISSQN |
| 884 | 320 | 5 | `vBC` | Numérico | 1-1 | 15,2 | `ISSQN` | Valor da Base de Cálculo do ISSQN |
| 885 | 321 | 5 | `vAliq` | Numérico | 1-1 | 7,2-4 | `ISSQN` | Alíquota do ISSQN |
| 886 | 322 | 5 | `vISSQN` | Numérico | 1-1 | 15,2 | `ISSQN` | Valor do ISSQN |
| 887 | 323 | 5 | `cMunFG` | Numérico | 1-1 | 7 | `ISSQN` | Código do município de ocorrência do fato gerador do ISSQN |
| 888 | 324 | 5 | `cListServ` | Caractere | 1-1 | 5 | `ISSQN` | Item da Lista de Serviços |
| 889 | 324a | 5 | `vDeducao` | Numérico | 0-1 | 15,2 | `ISSQN` | Valor dedução para redução da Base de Cálculo |
| 890 | 324b | 5 | `vOutro` | Numérico | 0-1 | 15,2 | `ISSQN` | Valor outras retenções |
| 891 | 324c | 5 | `vDescIncond` | Numérico | 0-1 | 15,2 | `ISSQN` | Valor desconto incondicionado |
| 892 | 324d | 5 | `vDescCond` | Numérico | 0-1 | 15,2 | `ISSQN` | Valor desconto condicionado |
| 893 | 324f | 5 | `vISSRet` | Numérico | 0-1 | 15,2 | `ISSQN` | Valor retenção ISS |
| 894 | 324g | 5 | `indISS` | Numérico | 1-1 | 2 | `ISSQN` | Indicador da exigibilidade do ISS |
| 895 | 324h | 5 | `cServico` | Caractere | 0-1 | 1-20 | `ISSQN` | Código do serviço prestado dentro do município |
| 896 | 324i | 5 | `cMun` | Numérico | 0-1 | 7 | `ISSQN` | Código do Município de incidência do imposto |
| 897 | 324j | 5 | `cPais` | Numérico | 0-1 | 4 | `ISSQN` | Código do País onde o serviço foi prestado |
| 898 | 324k | 5 | `nProcesso` | Caractere | 0-1 | 1-30 | `ISSQN` | Número do processo judicial ou administrativo de suspensão da exigibilidade |
| 899 | 324l | 5 | `indIncentivo` | Numérico | 1-1 | 1 | `ISSQN` | Indicador de incentivo Fiscal |
| 900 | — | 4 | `--ISSQN_fim--;` | — | — | — | `impostos` |  |

###### `IS` — pos. 324.01 · linhas 901–914 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 901 | 324.01 | 4 | **`--IS_ini--;`** | — | 0-1 | — | `impostos` | Informações do Imposto Seletivo |
| 902 | 324.02 | 5 | `CSTIS` | Numérico | 1-1 | 3 | `IS` | Código de Situação Tributária do Imposto Seletivo |
| 903 | 324.03 | 5 | `cClassTribIS` | Caractere | 1-1 | 6 | `IS` | Código de Classificação Tributária do Imposto / Seletivo |
| 904 | 324.04 | 5 | **`--seqSeletivo_ini--;`** | — | 0-1 | — | `IS` | Sequência XML |
| 905 | 324.05 | 6 | `vBCIS` | Numérico | 1-1 | 15,2 | `seqSeletivo` | Valor da Base de Cálculo do Imposto Seletivo |
| 906 | 324.06 | 6 | `pIS` | Caractere | 1-1 | 7,2-4 | `seqSeletivo` | Alíquota do Imposto Seletivo (em percentual) |
| 907 | 324.07 | 6 | `pISEspec / adRemIS` | Numérico | 0-1 | 7,2-4 | `seqSeletivo` | Alíquota específica por unidade de medida / apropriada |
| 908 | 324.11 | 6 | `vIS` | Numérico | 1-1 | 15,2 | `seqSeletivo` | Valor do Imposto Seletivo |
| 909 | 324.08 | 6 | **`--sequencia_XML_ini--;`** | — | 0-1 | — | `seqSeletivo` | Sequência XML |
| 910 | 324.09 | 7 | `uTrib` | Caractere | 1-1 | 1-6 | `sequencia_XML` | Unidade de Medida Tributável |
| 911 | 324.10 | 7 | `qTrib` | Numérico | 1-1 | 15,0 ou 4 | `sequencia_XML` | Quantidade Tributável |
| 912 | — | 6 | `--sequencia_XML_fim--;` | — | — | — | `seqSeletivo` |  |
| 913 | — | 5 | `--seqSeletivo_fim--;` | — | — | — | `IS` |  |
| 914 | — | 4 | `--IS_fim--;` | — | — | — | `impostos` |  |

###### `IBSCBS` — pos. 324.12 · linhas 915–1118 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 915 | 324.12 | 4 | **`--IBSCBS_ini--;`** | — | 0-1 | — | `impostos` | Informações do Imposto de Bens e Serviços - / IBS e da Contribuição de Bens e S… |
| 916 | 324.13 | 5 | `CST` | Numérico | 0-1 | 3 | `IBSCBS` | Código de Situação Tributária do IBS e CBS |
| 917 | 324.14 | 5 | `cClassTrib` | Caractere | 0-1 | 6 | `IBSCBS` | Código de Classificação Tributária do IBS e CBS |
| 918 | 324.14a | 5 | `indDoacao` | Caractere | 0-1 | 1 | `IBSCBS` | Indica a natureza da operação de doação, / orientando a apuração e a geração de… |

###### `sequencia_XML_IBSCBS` — pos. 324.14k · linhas 919–1092 · ocorrência —

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 919 | 324.14k | 5 | **`--sequencia_XML_IBSCBS_ini--;`** | Grupo | — | — | `IBSCBS` |  |

###### `gIBSCBS` — pos. 324.15 · linhas 920–995 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 920 | 324.15 | 6 | **`--gIBSCBS_ini--;`** | CG | 1-1 | — | `sequencia_XML_IBSCBS` | Grupo de Informações do IBS, CBS e Imposto Seletivo |
| 921 | 324.16 | 7 | `vBC` | Numérico | 1-1 | 15,2 | `gIBSCBS` | Base de cálculo do IBS e CBS |
| 922 | 324.54a | 7 | `vIBS` | Numérico | 1-1 | 15,2 | `gIBSCBS` | Valor do IBS |
| 923 | 324.17 | 7 | **`--gIBSUF_ini--;`** | — | 1-1 | — | `gIBSCBS` | Grupo de Informações do IBS para a UF |
| 924 | 324.18 | 8 | `pIBSUF` | Numérico | 1-1 | 7,2-4 | `gIBSUF` | Alíquota do IBS de competência das UF (em percentual) |
| 925 | 324.35 | 8 | `vIBSUF` | Numérico | 1-1 | 15,2 | `gIBSUF` | Valor do IBS de competência da UF |
| 926 | 324.21 | 8 | **`--gDif_ini--;`** | — | 0-1 | — | `gIBSUF` | Grupo de Informações do Diferimento |
| 927 | 324..22 | 9 | `pDif` | Numérico | 1-1 | 7,2-4 | `gDif` | Percentual do diferimento |
| 928 | 324.23 | 9 | `vDif` | Numérico | 1-1 | 15,2 | `gDif` | Valor do Diferimento |
| 929 | — | 8 | `--gDif_fim--;` | — | — | — | `gIBSUF` |  |
| 930 | 324..24 | 8 | **`--gDevTrib_ini--;`** | — | 0-1 | — | `gIBSUF` | Grupo de Informações da devolução de tributos |
| 931 | 324.24a | 9 | `pDevTrib` | Numérico | 0-1 | 7,2-4 | `gDevTrib` | Percentual de devolução do IBS da UF |
| 932 | 324.25 | 9 | `vDevTrib` | Numérico | 1-1 | 15,2 | `gDevTrib` | Valor do tributo devolvido |
| 933 | — | 8 | `--gDevTrib_fim--;` | — | — | — | `gIBSUF` |  |
| 934 | 324.26 | 8 | **`--gRed_ini--;`** | — | 0-1 | — | `gIBSUF` | Grupo de informações da redução da alíquota |
| 935 | 324.27 | 9 | `pRedAliq` | Numérico | 1-1 | 7,2-4 | `gRed` | Percentual da redução de alíquota do cClassTrib |
| 936 | 324.28 | 9 | `pAliqEfet` | Numérico | 1-1 | 7,2-4 | `gRed` | Aliquota Efetiva do IBS de competência das UF que será aplicada a Base de Cálcu… |
| 937 | — | 8 | `--gRed_fim--;` | — | — | — | `gIBSUF` |  |
| 938 | — | 7 | `--gIBSUF_fim--;` | — | — | — | `gIBSCBS` |  |
| 939 | 324.36 | 7 | **`--gIBSMun_ini--;`** | — | 1-1 | — | `gIBSCBS` | Grupo de Informações do IBS para o município |
| 940 | 324.37 | 8 | `pIBSMun` | Numérico | 1-1 | 7,2-4 | `gIBSMun` | Alíquota do IBS de competência dos Municípios (em percentual) |
| 941 | 324.54 | 8 | `vIBSMun` | Numérico | 1-1 | 15,2 | `gIBSMun` | Valor do IBS de competência do Município |
| 942 | 324.40 | 8 | **`--gDif_ini--;`** | — | 0-1 | — | `gIBSMun` | Grupo de Informações do Diferimento |
| 943 | 324.41 | 9 | `pDif` | Numérico | 1-1 | 7,2-4 | `gDif` | Percentual do diferimento |
| 944 | 324.42 | 9 | `vDif` | Numérico | 1-1 | 15,2 | `gDif` | Valor do Diferimento |
| 945 | — | 8 | `--gDif_fim--;` | — | — | — | `gIBSMun` |  |
| 946 | 324.43 | 8 | **`--gDevTrib_ini--;`** | — | 0-1 | — | `gIBSMun` | Grupo de Informações da devolução de tributos |
| 947 | 324.43a | 9 | `pDevTrib` | Numérico | 0-1 | 7,2-4 | `gDevTrib` | Percentual de devolução do IBS do Município |
| 948 | 324.44 | 9 | `vDevTrib` | Numérico | 1-1 | 15,2 | `gDevTrib` | Valor do tributo devolvido |
| 949 | — | 8 | `--gDevTrib_fim--;` | — | — | — | `gIBSMun` |  |
| 950 | 324.45 | 8 | **`--gRed_ini--;`** | — | 0-1 | — | `gIBSMun` | Grupo de informações da redução da alíquota |
| 951 | 324.46 | 9 | `pRedAliq` | Numérico | 1-1 | 7,2-4 | `gRed` | Percentual da redução de alíquota do cClassTrib |
| 952 | 324.47 | 9 | `pAliqEfet` | Numérico | 1-1 | 7,2-4 | `gRed` | Aliquota Efetiva do IBS de competência do / Município que será aplicada a Base… |
| 953 | — | 8 | `--gRed_fim--;` | — | — | — | `gIBSMun` |  |
| 954 | — | 7 | `--gIBSMun_fim--;` | — | — | — | `gIBSCBS` |  |
| 955 | 324.55 | 7 | **`--gCBS_ini--;`** | — | 1-1 | — | `gIBSCBS` | Grupo de Informações da CBS |
| 956 | 324.56 | 8 | `pCBS` | Numérico | 1-1 | 7,2-4 | `gCBS` | Alíquota da CBS (em percentual) |
| 957 | 324.67 | 8 | `vCBS` | Numérico | 1-1 | 15,2 | `gCBS` | Valor da CBS |
| 958 | 324.59 | 8 | **`--gDif_ini--;`** | — | 0-1 | — | `gCBS` | Grupo de Informações do Diferimento |
| 959 | 324.60 | 9 | `pDif` | Numérico | 1-1 | 7,2-4 | `gDif` | Percentual do diferimento |
| 960 | 324.61 | 9 | `vDif` | Numérico | 1-1 | 15,2 | `gDif` | Valor do Diferimento |
| 961 | — | 8 | `--gDif_fim--;` | — | — | — | `gCBS` |  |
| 962 | 324.62 | 8 | **`--gDevTrib_ini--;`** | — | 0-1 | — | `gCBS` | Grupo de Informações da devolução de tributos |
| 963 | 324.62a | 9 | `pDevTrib` | Numérico | 0-1 | 7,2-4 | `gDevTrib` | Percentual de devolução da CBS |
| 964 | 324.63 | 9 | `vDevTrib` | Numérico | 1-1 | 15,2 | `gDevTrib` | Valor do tributo devolvido |
| 965 | — | 8 | `--gDevTrib_fim--;` | — | — | — | `gCBS` |  |
| 966 | 324.64 | 8 | **`--gRed_ini--;`** | — | 0-1 | — | `gCBS` | Grupo de informações da redução da alíquota |
| 967 | 324.65 | 9 | `pRedAliq` | Numérico | 1-1 | 7,2-4 | `gRed` | Percentual da redução de alíquota do / cClassTrib |
| 968 | 324.66 | 9 | `pAliqEfet` | Numérico | 1-1 | 7,2-4 | `gRed` | Alíquota Efetiva da CBS que será aplicada a Base de Cálculo (em percentual) |
| 969 | — | 8 | `--gRed_fim--;` | — | — | — | `gCBS` |  |
| 970 | 324.66a | 8 | **`--gALCZFMCBS_ini--;`** | — | 0-1 | — | `gCBS` | Grupo de operações em áreas incentivadas (ALC/ZFM) - CBS (alíquota zero) |
| 971 | 324.66b | 9 | `tpALCZFMCBS` | Numérico | 1-1 | 1 | `gALCZFMCBS` | Tipo de aplicação da alíquota zero da CBS |
| 972 | 324.66c | 9 | `nProcSuframa` | Caractere | 0-1 | 8-12 | `gALCZFMCBS` | Número do processo na Suframa para o item comercializado |
| 973 | 324.66d | 9 | `pAliqEfetRegCBS` | Numérico | 1-1 | 7,2-4 | `gALCZFMCBS` | Percentual efetivo sem a redução |
| 974 | 324.66e | 9 | `vTribRegCBS` | Numérico | 1-1 | 15,2 | `gALCZFMCBS` | Valor efetivo sem a redução |
| 975 | — | 8 | `--gALCZFMCBS_fim--;` | — | — | — | `gCBS` |  |
| 976 | — | 7 | `--gCBS_fim--;` | — | — | — | `gIBSCBS` |  |
| 977 | 324.68 | 7 | **`--gTribRegular_ini--;`** | — | 0-1 | — | `gIBSCBS` | Grupo de informações da Tributação Regular |
| 978 | 324.69 | 8 | `CSTReg` | Numérico | 1-1 | 3 | `gTribRegular` | Código de Situação Tributária do IBS e CBS |
| 979 | 324670 | 8 | `cClassTribReg` | Caractere | 1-1 | 6 | `gTribRegular` | Código de Classificação Tributária do IBS e CBS |
| 980 | 324.71 | 8 | `pAliqEfetRegIBSUF` | Numérico | 1-1 | 7,2-4 | `gTribRegular` | Valor da alíquota do IBS da UF (em percentual) |
| 981 | 324.72 | 8 | `vTribRegIBSUF` | Numérico | 1-1 | 15,2 | `gTribRegular` | Valor do Tributo do IBS da UF |
| 982 | 324.72a | 8 | `pAliqEfetRegIBSMun` | Numérico | 1-1 | 7,2-4 | `gTribRegular` | Valor da alíquota do IBS do Município (em / percentual) |
| 983 | 324.72b | 8 | `vTribRegIBSMun` | Numérico | 1-1 | 15,2 | `gTribRegular` | Valor do Tributo do IBS do Município |
| 984 | 324.72c | 8 | `pAliqEfetRegCBS` | Numérico | 1-1 | 7,2-4 | `gTribRegular` | Valor da alíquota da CBS (em percentual) |
| 985 | 324.72d | 8 | `vTribRegCBS` | Numérico | 1-1 | 15,2 | `gTribRegular` | Valor do Tributo da CBS |
| 986 | — | 7 | `--gTribRegular_fim--;` | — | — | — | `gIBSCBS` |  |
| 987 | 324.82a | 7 | **`--gTribCompraGov_ini--;`** | — | 0-1 | — | `gIBSCBS` | Grupo de informações da composição do valor do IBS e da CBS em compras governam… |
| 988 | 324.82b | 8 | `pAliqIBSUF` | Numérico | 1-1 | 7,2-4 | `gTribCompraGov` | Alíquota do IBS de competência do / Estado (em percentual) |
| 989 | 324.82c | 8 | `vTribIBSUF` | Numérico | 1-1 | 15,2 | `gTribCompraGov` | Valor que seria devido a UF |
| 990 | 324.82d | 8 | `pAliqIBSMun` | Numérico | 1-1 | 7,2-4 | `gTribCompraGov` | Alíquota do IBS de competência do Município (em percentual) |
| 991 | 324.82e | 8 | `vTribIBSMun` | Numérico | 1-1 | 15,2 | `gTribCompraGov` | Valor que seria devido ao município |
| 992 | 324.82f | 8 | `pAliqCBS` | Numérico | 1-1 | 7,2-4 | `gTribCompraGov` | Alíquota da CBS (em percentual) |
| 993 | 324.82g | 8 | `vTribCBS` | Numérico | 1-1 | 15,2 | `gTribCompraGov` | Valor que seria devido a CBS |
| 994 | — | 7 | `--gTribCompraGov_fim--;` | — | — | — | `gIBSCBS` |  |
| 995 | — | 6 | `--gIBSCBS_fim--;` | — | — | — | `sequencia_XML_IBSCBS` |  |

###### `gIBSCBSMono` — pos. 324.84 · linhas 996–1082 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 996 | 324.84 | 6 | **`--gIBSCBSMono_ini--;`** | CG | 1-1 | — | `sequencia_XML_IBSCBS` | Grupo de Informações do IBS e CBS em operações com imposto monofásico |
| 997 | 324.85 | 7 | **`--sequencia_XML_IBSMono_ini--;`** | G | 0-1 | — | `gIBSCBSMono` | Sequência XML |
| 998 | 324.85a | 8 | **`--gIBSMonoAdRem_ini--;`** | CG | 0-1 | — | `sequencia_XML_IBSMono` | Grupo de informações da Tributação Monofásica Ad Rem do IBS |
| 999 | 324.86 | 9 | **`--gMonoPadrao_ini--;`** | G | 0-1 | — | `gIBSMonoAdRem` | Grupo de informações da Tributação Monofásica Padrão |
| 1000 | 324.86a | 10 | `qBCMono` | Numérico | 1-1 | 15,0 ou 4 | `gMonoPadrao` | Quantidade tributada na monofasia |
| 1001 | 324.86b | 10 | `adRemIBS` | Numérico | 1-1 | 7,2-4 | `gMonoPadrao` | Alíquota ad rem do IBS |
| 1002 | 324.86c | 10 | `vIBSMono` | Numérico | 1-1 | 15,2 | `gMonoPadrao` | Valor do IBS monofásico |
| 1003 | — | 9 | `--gMonoPadrao_fim--;` | — | — | — | `gIBSMonoAdRem` |  |
| 1004 | 324.87 | 9 | **`--gMonoReten_ini--;`** | G | 0-1 | — | `gIBSMonoAdRem` | Grupo de informações da Tributação Monofásica Sujeita à Retenção |
| 1005 | 324.87a | 10 | `qBCMonoReten` | Numérico | 1-1 | 15,0 ou 4 | `gMonoReten` | Quantidade tributada sujeita à retenção na monofasia |
| 1006 | 324.87b | 10 | `adRemIBSReten` | Numérico | 1-1 | 7,2-4 | `gMonoReten` | Alíquota ad rem do IBS sujeito à retenção |
| 1007 | 324.87c | 10 | `vIBSMonoReten` | Numérico | 1-1 | 15,2 | `gMonoReten` | Valor do IBS monofásico sujeito à retenção |
| 1008 | — | 9 | `--gMonoReten_fim--;` | — | — | — | `gIBSMonoAdRem` |  |
| 1009 | 324.88 | 9 | **`--gMonoRet_ini--;`** | G | 0-1 | — | `gIBSMonoAdRem` | Grupo de informações da Tributação Monofásica Retida Anteriormente |
| 1010 | 324.88a | 10 | `vIBSMonoRet` | Numérico | 1-1 | 15,2 | `gMonoRet` | Valor do IBS retido anteriormente |
| 1011 | — | 9 | `--gMonoRet_fim--;` | — | — | — | `gIBSMonoAdRem` |  |
| 1012 | 324.89 | 9 | **`--gpBioDiferenca_ini--;`** | G | 0-1 | — | `gIBSMonoAdRem` | Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior… |
| 1013 | 324.89a | 10 | `qBCBioComb` | Numérico | 1-1 | 15,0 ou 4 | `gpBioDiferenca` | Quantidade de Biocombustível (EAC) a recolher ou a ressarcir |
| 1014 | 324.89b | 10 | `vIBSDiferenca` | Numérico | 1-1 | 15,2 | `gpBioDiferenca` | Valor do IBS correspondente a diferença em relação ao pBioObrigatorio |
| 1015 | — | 9 | `--gpBioDiferenca_fim--;` | — | — | — | `gIBSMonoAdRem` |  |
| 1016 | — | 8 | `--gIBSMonoAdRem_fim--;` | — | — | — | `sequencia_XML_IBSMono` |  |
| 1017 | 324.90 | 8 | **`--gIBSMonoAdValorem_ini--;`** | CG | 0-1 | — | `sequencia_XML_IBSMono` | Grupo de informações da Tributação Monofásica Ad Valorem do IBS |
| 1018 | 324.91 | 9 | **`--gMonoPadrao_ini--;`** | G | 0-1 | — | `gIBSMonoAdValorem` | Grupo de informações da Tributação Monofásica Padrão |
| 1019 | 324.91a | 10 | `vBCMono` | Numérico | 1-1 | 15,2 | `gMonoPadrao` | Valor tributado na monofasia |
| 1020 | 324.91b | 10 | `pAliqMonoUF` | Numérico | 1-1 | 7,2-4 | `gMonoPadrao` | Alíquota ad valorem do IBS Estadual |
| 1021 | 324.91c | 10 | `vIBSMonoUF` | Numérico | 1-1 | 15,2 | `gMonoPadrao` | Valor do IBS monofásico Estadual |
| 1022 | 324.91d | 10 | `pAliqMonoMun` | Numérico | 1-1 | 7,2-4 | `gMonoPadrao` | Alíquota ad valorem do IBS Municipal |
| 1023 | 324.91e | 10 | `vIBSMonoMun` | Numérico | 1-1 | 15,2 | `gMonoPadrao` | Valor do IBS monofásico Municipal |
| 1024 | 324.91f | 10 | `vIBSMono` | Numérico | 1-1 | 15,2 | `gMonoPadrao` | Valor do IBS monofásico |
| 1025 | — | 9 | `--gMonoPadrao_fim--;` | — | — | — | `gIBSMonoAdValorem` |  |
| 1026 | 324.92 | 9 | **`--gMonoReten_ini--;`** | G | 0-1 | — | `gIBSMonoAdValorem` | Grupo de informações da Tributação Monofásica Sujeita à Retenção |
| 1027 | 324.92a | 10 | `vBCMonoReten` | Numérico | 1-1 | 15,2 | `gMonoReten` | Valor tributado sujeito à retenção na monofasia |
| 1028 | 324.92b | 10 | `pAliqMonoReten` | Numérico | 1-1 | 7,2-4 | `gMonoReten` | Alíquota ad valorem do IBS sujeito à retenção |
| 1029 | 324.92c | 10 | `vIBSMonoReten` | Numérico | 1-1 | 15,2 | `gMonoReten` | Valor do IBS monofásico sujeito à retenção |
| 1030 | — | 9 | `--gMonoReten_fim--;` | — | — | — | `gIBSMonoAdValorem` |  |
| 1031 | 324.93 | 9 | **`--gMonoRet_ini--;`** | G | 0-1 | — | `gIBSMonoAdValorem` | Grupo de informações da Tributação Monofásica Retida Anteriormente |
| 1032 | 324.93a | 10 | `vIBSMonoRet` | Numérico | 1-1 | 15,2 | `gMonoRet` | Valor do IBS retido anteriormente |
| 1033 | — | 9 | `--gMonoRet_fim--;` | — | — | — | `gIBSMonoAdValorem` |  |
| 1034 | 324.94 | 9 | **`--gpBioDiferenca_ini--;`** | G | 0-1 | — | `gIBSMonoAdValorem` | Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior… |
| 1035 | 324.94a | 10 | `qBCBioComb` | Numérico | 1-1 | 15,0 ou 4 | `gpBioDiferenca` | Quantidade de Biocombustível (EAC) a recolher ou a ressarcir |
| 1036 | 324.94b | 10 | `vIBSDiferenca` | Numérico | 1-1 | 15,2 | `gpBioDiferenca` | Valor do IBS correspondente a diferença em relação ao pBioObrigatorio |
| 1037 | — | 9 | `--gpBioDiferenca_fim--;` | — | — | — | `gIBSMonoAdValorem` |  |
| 1038 | — | 8 | `--gIBSMonoAdValorem_fim--;` | — | — | — | `sequencia_XML_IBSMono` |  |
| 1039 | — | 7 | `--sequencia_XML_IBSMono_fim--;` | — | — | — | `gIBSCBSMono` |  |
| 1040 | 324.95 | 7 | **`--sequencia_XML_CBSMono_ini--;`** | G | 0-1 | — | `gIBSCBSMono` | Sequência XML |
| 1041 | 324.95a | 8 | **`--gCBSMonoAdRem_ini--;`** | CG | 0-1 | — | `sequencia_XML_CBSMono` | Grupo de informações da Tributação Monofásica Ad Rem da CBS |
| 1042 | 324.96 | 9 | **`--gMonoPadrao_ini--;`** | G | 0-1 | — | `gCBSMonoAdRem` | Grupo de informações da Tributação Monofásica Padrão |
| 1043 | 324.96a | 10 | `qBCMono` | Numérico | 1-1 | 15,0 ou 4 | `gMonoPadrao` | Quantidade tributada na monofasia |
| 1044 | 324.96b | 10 | `adRemCBS` | Numérico | 1-1 | 7,2-4 | `gMonoPadrao` | Alíquota ad rem da CBS |
| 1045 | 324.96c | 10 | `vCBSMono` | Numérico | 1-1 | 15,2 | `gMonoPadrao` | Valor da CBS monofásica |
| 1046 | — | 9 | `--gMonoPadrao_fim--;` | — | — | — | `gCBSMonoAdRem` |  |
| 1047 | 324.97 | 9 | **`--gMonoReten_ini--;`** | G | 0-1 | — | `gCBSMonoAdRem` | Grupo de informações da Tributação Monofásica Sujeita à Retenção |
| 1048 | 324.97a | 10 | `qBCMonoReten` | Numérico | 1-1 | 15,0 ou 4 | `gMonoReten` | Quantidade tributada sujeita à retenção na monofasia |
| 1049 | 324.97b | 10 | `adRemCBSReten` | Numérico | 1-1 | 7,2-4 | `gMonoReten` | Alíquota ad rem da CBS sujeita à retenção |
| 1050 | 324.97c | 10 | `vCBSMonoReten` | Numérico | 1-1 | 15,2 | `gMonoReten` | Valor da CBS monofásica sujeita à retenção |
| 1051 | — | 9 | `--gMonoReten_fim--;` | — | — | — | `gCBSMonoAdRem` |  |
| 1052 | 324.98 | 9 | **`--gMonoRet_ini--;`** | G | 0-1 | — | `gCBSMonoAdRem` | Grupo de informações da Tributação Monofásica Retida Anteriormente |
| 1053 | 324.98a | 10 | `vCBSMonoRet` | Numérico | 1-1 | 15,2 | `gMonoRet` | Valor da CBS retida anteriormente |
| 1054 | — | 9 | `--gMonoRet_fim--;` | — | — | — | `gCBSMonoAdRem` |  |
| 1055 | 324.99 | 9 | **`--gpBioDiferenca_ini--;`** | G | 0-1 | — | `gCBSMonoAdRem` | Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior… |
| 1056 | 324.99a | 10 | `qBCBioComb` | Numérico | 1-1 | 15,0 ou 4 | `gpBioDiferenca` | Quantidade de Biocombustível (EAC) a recolher ou a ressarcir |
| 1057 | 324.99b | 10 | `vCBSDiferenca` | Numérico | 1-1 | 15,2 | `gpBioDiferenca` | Valor da CBS correspondente a diferença em relação ao pBioObrigatorio |
| 1058 | — | 9 | `--gpBioDiferenca_fim--;` | — | — | — | `gCBSMonoAdRem` |  |
| 1059 | — | 8 | `--gCBSMonoAdRem_fim--;` | — | — | — | `sequencia_XML_CBSMono` |  |
| 1060 | 324.100 | 8 | **`--gCBSMonoAdValorem_ini--;`** | CG | 0-1 | — | `sequencia_XML_CBSMono` | Grupo de informações da Tributação Monofásica Ad Valorem da CBS |
| 1061 | 324.101 | 9 | **`--gMonoPadrao_ini--;`** | G | 0-1 | — | `gCBSMonoAdValorem` | Grupo de informações da Tributação Monofásica Padrão |
| 1062 | 324.101a | 10 | `vBCMono` | Numérico | 1-1 | 15,2 | `gMonoPadrao` | Valor tributado na monofasia |
| 1063 | 324.101b | 10 | `pAliqMonoCBS` | Numérico | 1-1 | 7,2-4 | `gMonoPadrao` | Alíquota ad valorem da CBS |
| 1064 | 324.101c | 10 | `vCBSMono` | Numérico | 1-1 | 15,2 | `gMonoPadrao` | Valor da CBS monofásica |
| 1065 | — | 9 | `--gMonoPadrao_fim--;` | — | — | — | `gCBSMonoAdValorem` |  |
| 1066 | 324.102 | 9 | **`--gMonoReten_ini--;`** | G | 0-1 | — | `gCBSMonoAdValorem` | Grupo de informações da Tributação Monofásica Sujeita à Retenção |
| 1067 | 324.102a | 10 | `vBCMonoReten` | Numérico | 1-1 | 15,2 | `gMonoReten` | Valor tributado sujeito à retenção na monofasia |
| 1068 | 324.102b | 10 | `pAliqMonoReten` | Numérico | 1-1 | 7,2-4 | `gMonoReten` | Alíquota ad valorem da CBS sujeito à retenção |
| 1069 | 324.102c | 10 | `vCBSMonoReten` | Numérico | 1-1 | 15,2 | `gMonoReten` | Valor da CBS monofásica sujeita à retenção |
| 1070 | — | 9 | `--gMonoReten_fim--;` | — | — | — | `gCBSMonoAdValorem` |  |
| 1071 | 324.103 | 9 | **`--gMonoRet_ini--;`** | G | 0-1 | — | `gCBSMonoAdValorem` | Grupo de informações da Tributação Monofásica Retida Anteriormente |
| 1072 | 324.103a | 10 | `vCBSMonoRet` | Numérico | 1-1 | 15,2 | `gMonoRet` | Valor da CBS retida anteriormente |
| 1073 | — | 9 | `--gMonoRet_fim--;` | — | — | — | `gCBSMonoAdValorem` |  |
| 1074 | 324.104 | 9 | **`--gpBioDiferenca_ini--;`** | G | 0-1 | — | `gCBSMonoAdValorem` | Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior… |
| 1075 | 324.104a | 10 | `qBCBioComb` | Numérico | 1-1 | 15,0 ou 4 | `gpBioDiferenca` | Quantidade de Biocombustível (EAC) a recolher ou a ressarcir |
| 1076 | 324.104b | 10 | `vCBSDiferenca` | Numérico | 1-1 | 15,2 | `gpBioDiferenca` | Valor da CBS correspondente a diferença em relação ao pBioObrigatorio |
| 1077 | — | 9 | `--gpBioDiferenca_fim--;` | — | — | — | `gCBSMonoAdValorem` |  |
| 1078 | — | 8 | `--gCBSMonoAdValorem_fim--;` | — | — | — | `sequencia_XML_CBSMono` |  |
| 1079 | — | 7 | `--sequencia_XML_CBSMono_fim--;` | — | — | — | `gIBSCBSMono` |  |
| 1080 | 324.105a | 7 | `vTotIBSMonoItem` | Numérico | 1-1 | 15,2 | `gIBSCBSMono` | Total de IBS Monofásico. |
| 1081 | 324.105b | 7 | `vTotCBSMonoItem` | Numérico | 1-1 | 15,2 | `gIBSCBSMono` | Total da CBS Monofásica. |
| 1082 | — | 6 | `--gIBSCBSMono_fim--;` | — | — | — | `sequencia_XML_IBSCBS` |  |

###### `gTransfCred` — pos. 324.106 · linhas 1083–1086 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1083 | 324.106 | 6 | **`--gTransfCred_ini--;`** | CG | 1-1 | — | `sequencia_XML_IBSCBS` | Transferências de Crédito |
| 1084 | 324107 | 7 | `vIBS` | Numérico | 1-1 | 15,2 | `gTransfCred` | Valor do IBS a ser transferido |
| 1085 | 324.108 | 7 | `vCBS` | Numérico | 1-1 | 15,2 | `gTransfCred` | Valor da CBS a ser transferida |
| 1086 | — | 6 | `--gTransfCred_fim--;` | — | — | — | `sequencia_XML_IBSCBS` |  |

###### `gAjusteCompet` — pos. 324.112 · linhas 1087–1091 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1087 | 324.112 | 6 | **`--gAjusteCompet_ini--;`** | CG | 1-1 | — | `sequencia_XML_IBSCBS` | Ajuste de Competência |
| 1088 | 324113 | 7 | `competApur` | Caractere | 1-1 | 7 | `gAjusteCompet` | Ano e mês referência do período de apuração (AAAA-MM) |
| 1089 | 324114 | 7 | `vIBS` | Numérico | 1-1 | 15,2 | `gAjusteCompet` | Valor do IBS |
| 1090 | 324115 | 7 | `vCBS` | Numérico | 1-1 | 15,2 | `gAjusteCompet` | Valor da CBS |
| 1091 | — | 6 | `--gAjusteCompet_fim--;` | — | — | — | `sequencia_XML_IBSCBS` |  |

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1092 | — | 5 | `--sequencia_XML_IBSCBS_fim--;` | — | — | — | `IBSCBS` |  |

###### `gEstornoCred` — pos. 324116 · linhas 1093–1096 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1093 | 324116 | 5 | **`--gEstornoCred_ini--;`** | G | 0-1 | — | `IBSCBS` |  |
| 1094 | 324.17 | 6 | `vIBSEstCred` | Numérico | 1-1 | 15,2 | `gEstornoCred` | Valor do IBS a ser estornado |
| 1095 | 324.18 | 6 | `vCBSEstCred` | Numérico | 1-1 | 15,2 | `gEstornoCred` | Valor da CBS a ser estornada |
| 1096 | — | 5 | `--gEstornoCred_fim--;` | — | — | — | `IBSCBS` |  |

###### `sequencia_XML_cred_pres` — pos. 324119 · linhas 1097–1117 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1097 | 324119 | 5 | **`--sequencia_XML_cred_pres_ini--;`** | G | 0-1 | — | `IBSCBS` |  |
| 1098 | 324.120 | 6 | **`--gCredPresOper_ini--;`** | CG | 1-1 | — | `sequencia_XML_cred_pres` | Grupo de Crédito Presumido da Operação |
| 1099 | 324121 | 7 | `vBCCredPres` | Numérico | 1-1 | 15,2 | `gCredPresOper` | Valor da Base de Cálculo do Crédito Presumido da Operação |
| 1100 | 324122 | 7 | `cCredPres` | Numérico | 1-1 | 2 | `gCredPresOper` | Código de Classificação do Crédito Presumido |
| 1101 | 324.123 | 7 | **`--gIBSCredPres_ini--;`** | — | 0-1 | — | `gCredPresOper` | Grupo de Informações do Crédito Presumido referente ao IBS |
| 1102 | 324124 | 8 | `pCredPres` | Numérico | 1-1 | 7,2-4 | `gIBSCredPres` | Percentual do Crédito Presumido |
| 1103 | 324125 | 8 | `vCredPres` | Numérico | 1-1 | 15,2 | `gIBSCredPres` | Valor do Crédito Presumido |
| 1104 | 324126 | 8 | `vCredPresCondSus` | Numérico | 1-1 | 15,2 | `gIBSCredPres` | Valor do Crédito Presumido em condição / suspensiva. |
| 1105 | — | 7 | `--gIBSCredPres_fim--;` | — | — | — | `gCredPresOper` |  |
| 1106 | 324.127 | 7 | **`--gCBSCredPres_ini--;`** | — | 0-1 | — | `gCredPresOper` | Grupo de Informações do Crédito Presumido referente a CBS |
| 1107 | 324128 | 8 | `pCredPres` | Numérico | 1-1 | 7,2-4 | `gCBSCredPres` | Percentual do Crédito Presumido |
| 1108 | 324129 | 8 | `vCredPres` | Numérico | 1-1 | 15,2 | `gCBSCredPres` | Valor do Crédito Presumido |
| 1109 | 324130 | 8 | `vCredPresCondSus` | Numérico | 1-1 | 15,2 | `gCBSCredPres` | Valor do Crédito Presumido em condição / suspensiva. |
| 1110 | — | 7 | `--gCBSCredPres_fim--;` | — | — | — | `gCredPresOper` |  |
| 1111 | — | 6 | `--gCredPresOper_fim--;` | — | — | — | `sequencia_XML_cred_pres` |  |
| 1112 | 324.131 | 6 | **`--gCredPresIBSZFM_ini--;`** | CG | 1-1 | — | `sequencia_XML_cred_pres` | Grupo para apropriação de crédito presumido de IBS sobre o saldo devedor na ZFM… |
| 1113 | 324132 | 7 | `competApur` | Caractere | 1-1 | 7 | `gCredPresIBSZFM` | Ano e mês referência do período de apuração (AAAA-MM) |
| 1114 | 324133 | 7 | `tpCredPresIBSZFM` | Numérico | 1-1 | 1 | `gCredPresIBSZFM` | Tipo de classificação de acordo com o art. 450, § 1º, da LC 214/25 para o cálcu… |
| 1115 | 324134 | 7 | `vCredPresIBSZFM` | Numérico | 1-1 | 15,2 | `gCredPresIBSZFM` | Valor do crédito presumido calculado sobre o saldo devedor apurado |
| 1116 | — | 6 | `--gCredPresIBSZFM_fim--;` | — | — | — | `sequencia_XML_cred_pres` |  |
| 1117 | — | 5 | `--sequencia_XML_cred_pres_fim--;` | — | — | — | `IBSCBS` |  |

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1118 | — | 4 | `--IBSCBS_fim--;` | — | — | — | `impostos` |  |

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1119 | — | 3 | `--impostos_fim--;` | — | — | — | `det` |  |

###### `imposto_devol` — pos. 324p · linhas 1120–1125 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1120 | 324p | 3 | **`--imposto_devol_ini--;`** | — | 0-1 | — | `det` | Informação do Imposto devolvido |
| 1121 | 324q | 4 | `pDevol` | Numérico | 1-1 | 5,2 | `imposto_devol` | Percentual da mercadoria devolvida |
| 1122 | 324r | 4 | **`--ipi_devol_ini--;`** | — | 1-1 | — | `imposto_devol` | Informação do IPI devolvido |
| 1123 | 324s | 5 | `vIPIDevol` | Numérico | 1-1 | 15,2 | `ipi_devol` | Valor do IPI devolvido |
| 1124 | — | 4 | `--ipi_devol_fim--;` | — | — | — | `imposto_devol` |  |
| 1125 | — | 3 | `--imposto_devol_fim--;` | — | — | — | `det` |  |

###### `inf_adicionais` — pos. sem pos. · linhas 1126–1128 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1126 | — | 3 | **`--inf_adicionais_ini--;`** | — | 0-1 | — | `det` | Informações Adicionais (para o item da NF-e) |
| 1127 | 325 | 4 | `infAdProd` | Caractere | 0-1 | 1-500 | `inf_adicionais` | Informações Adicionais do Produto(Norma referenciada, informações complementare… |
| 1128 | — | 3 | `--inf_adicionais_fim--;` | — | — | — | `det` |  |

###### `vItem` — pos. 325h.1 · linhas 1129–1131 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1129 | 325h.1 | 3 | **`--vItem_ini--;`** | — | 0-1 | — | `det` | Valor Total do Item da NF-e |
| 1130 | 325h | 4 | `vItem` | Numérico | 0-1 | 15,2 | `vItem` | Valor Total do Item da NF-e |
| 1131 | — | 3 | `--vItem_fim--;` | — | — | — | `det` |  |

###### `DFeReferenciado` — pos. 325i · linhas 1132–1135 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1132 | 325i | 3 | **`--DFeReferenciado_ini--;`** | — | 0-1 | — | `det` | Documento Fiscal Eletrônico Referenciado |
| 1133 | 325j | 4 | `chaveAcesso` | Caractere | 1-1 | 44 | `DFeReferenciado` | Chave de acesso do DF-e referenciado |
| 1134 | 325k | 4 | `nItem` | Numérico | 0-1 | 3 | `DFeReferenciado` | Número do item do documento referenciado. |
| 1135 | — | 3 | `--DFeReferenciado_fim--;` | — | — | — | `det` |  |

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1136 | — | 2 | `--det_fim--;` | — | — | — | `item_nota` |  |

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1137 | — | 1 | `--item_nota_fim--;` | — | — | — | `nota` |  |

#### `total` — pos. 326 · linhas 1138–1235 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1138 | 326 | 1 | **`--total_ini--;`** | — | 1-1 | — | `nota` | Grupo Totais da NF-e |
| 1139 | 327 | 2 | **`--icms_Tot_ini--;`** | — | 1-1 | — | `total` | Grupo Totais referentes ao ICMS |
| 1140 | 328 | 3 | `vBC` | Numérico | 1-1 | 15,2 | `icms_Tot` | Base de Cálculo do ICMS |
| 1141 | 329 | 3 | `vICMS` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do ICMS |
| 1142 | 329.01 | 3 | `vICMSDeson` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do ICMS desonerado |
| 1143 | 329.08 | 3 | `vFCP` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do Fundo de Combate à Pobreza (FCP) |
| 1144 | 329.03 | 3 | `vFCPUFDest` | Numérico | 0-1 | 15,2 | `icms_Tot` | Valor total do ICMS relativo Fundo de Combate à Pobreza (FCP) da UF de destino. |
| 1145 | 329.05 | 3 | `vICMSUFDest` | Numérico | 0-1 | 15,2 | `icms_Tot` | Valor Total do ICMS Interestadual para a UF destino |
| 1146 | 329.07 | 3 | `vICMSUFRemet` | Numérico | 0-1 | 15,2 | `icms_Tot` | Valor Total do ICMS Interestadual para a UF do remetente |
| 1147 | 330 | 3 | `vBCST` | Numérico | 1-1 | 15,2 | `icms_Tot` | Base de Cálculo do ICMS ST |
| 1148 | 331 | 3 | `vST` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do ICMS ST |
| 1149 | 331.01 | 3 | `vFCPST` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributá… |
| 1150 | 331.02 | 3 | `vFCPSTRet` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do Fundo de Combate à Pobreza (FCP) retido anteriormente por Substi… |
| 1151 | 331.02a | 3 | `qBCMono` | Numérico | 0-1 | 15,2 | `icms_Tot` | Valor total da quantidade tributada do ICMS monofásico próprio |
| 1152 | 331.03 | 3 | `vICMSMono` | Numérico | 0-1 | 15,2 | `icms_Tot` | Valor total do ICMS monofásico próprio |
| 1153 | 331.03a | 3 | `qBCMonoReten` | Numérico | 0-1 | 15,2 | `icms_Tot` | Valor total da quantidade tributada do ICMS monofásico sujeito a retenção |
| 1154 | 331.04 | 3 | `vICMSMonoReten` | Numérico | 0-1 | 15,2 | `icms_Tot` | Valor total do ICMS monofásico sujeito a retenção |
| 1155 | 331.04a | 3 | `qBCMonoRet` | Numérico | 0-1 | 15,2 | `icms_Tot` | Valor total da quantidade tributada do ICMS monofásico retido anteriormente |
| 1156 | 331.05 | 3 | `vICMSMonoRet` | Numérico | 0-1 | 15,2 | `icms_Tot` | Valor total do ICMS monofásico retido anteriormente |
| 1157 | 332 | 3 | `vProd` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total dos Produtos e Serviços |
| 1158 | 333 | 3 | `vFrete` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do Frete |
| 1159 | 334 | 3 | `vSeg` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do Seguro |
| 1160 | 335 | 3 | `vDesc` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do Desconto |
| 1161 | 336 | 3 | `vII` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do II |
| 1162 | 337 | 3 | `vIPI` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do IPI |
| 1163 | 337.01 | 3 | `vIPIDevol` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do IPI devolvido |
| 1164 | 338 | 3 | `vPIS` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do PIS |
| 1165 | 339 | 3 | `vCOFINS` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total do COFINS |
| 1166 | 340 | 3 | `vOutro` | Numérico | 1-1 | 15,2 | `icms_Tot` | Outras Despesas acessórias |
| 1167 | 341 | 3 | `vNF` | Numérico | 1-1 | 15,2 | `icms_Tot` | Valor Total da NF-e |
| 1168 | 341a | 3 | `vTotTrib` | Numérico | 0-1 | 15,2 | `icms_Tot` | Valor aproximado total de tributos federais, estaduais e municipais |
| 1169 | — | 2 | `--icms_Tot_fim--;` | — | — | — | `total` |  |
| 1170 | 342 | 2 | **`--issqn_Tot_ini--;`** | — | 0-1 | — | `total` | Grupo Totais referentes ao ISSQN |
| 1171 | 343 | 3 | `vServ` | Numérico | 0-1 | 15,2 | `issqn_Tot` | Valor total dos Serviços sob não-incidência ou não tributados pelo ICMS |
| 1172 | 344 | 3 | `vBC` | Numérico | 0-1 | 15,2 | `issqn_Tot` | Valor total Base de Cálculo do ISS |
| 1173 | 345 | 3 | `vISS` | Numérico | 0-1 | 15,2 | `issqn_Tot` | Valor Total do ISS |
| 1174 | 346 | 3 | `vPIS` | Numérico | 0-1 | 15,2 | `issqn_Tot` | Valor do PIS sobre Serviços |
| 1175 | 347 | 3 | `vCOFINS` | Numérico | 0-1 | 15,2 | `issqn_Tot` | Valor da COFINS sobre serviços |
| 1176 | 347a | 3 | `dCompet` | Numérico | 1-1 | 8 | `issqn_Tot` | Data da prestação do serviço |
| 1177 | 347b | 3 | `vDeducao` | Numérico | 0-1 | 15,2 | `issqn_Tot` | Valor total dedução para redução da Base de Cálculo |
| 1178 | 347c | 3 | `vOutro` | Numérico | 0-1 | 15,2 | `issqn_Tot` | Valor total outras retenções |
| 1179 | 347d | 3 | `vDescIncond` | Numérico | 0-1 | 15,2 | `issqn_Tot` | Valor total desconto incondicionado |
| 1180 | 347e | 3 | `vDescCond` | Numérico | 0-1 | 15,2 | `issqn_Tot` | Valor total desconto condicionado |
| 1181 | 347f | 3 | `vISSRet` | Numérico | 0-1 | 15,2 | `issqn_Tot` | Valor total retenção ISS |
| 1182 | 347g | 3 | `cRegTrib` | Numérico | 0-1 | 2 | `issqn_Tot` | Código do Regime Especial de Tributação |
| 1183 | — | 2 | `--issqn_Tot_fim--;` | — | — | — | `total` |  |
| 1184 | 348 | 2 | **`--ret_Trib_ini--;`** | — | 0-1 | — | `total` | Grupo Retenções de Tributos |
| 1185 | 349 | 3 | `vRetPIS` | Numérico | 0-1 | 15,2 | `ret_Trib` | Valor Retido de PIS |
| 1186 | 350 | 3 | `vRetCOFINS` | Numérico | 0-1 | 15,2 | `ret_Trib` | Valor Retido de COFINS |
| 1187 | 351 | 3 | `vRetCSLL` | Numérico | 0-1 | 15,2 | `ret_Trib` | Valor Retido de CSLL |
| 1188 | 352 | 3 | `vBCIRRF` | Numérico | 0-1 | 15,2 | `ret_Trib` | Base de Cálculo do IRRF |
| 1189 | 353 | 3 | `vIRRF` | Numérico | 0-1 | 15,2 | `ret_Trib` | Valor Retido do IRRF |
| 1190 | 354 | 3 | `vBCRetPrev` | Numérico | 0-1 | 15,2 | `ret_Trib` | Base de Cálculo da Retenção da Previdência Social |
| 1191 | 355 | 3 | `vRetPrev` | Numérico | 0-1 | 15,2 | `ret_Trib` | Valor da Retenção da Previdência Social |
| 1192 | — | 2 | `--ret_Trib_fim--;` | — | — | — | `total` |  |
| 1193 | 355.1 | 2 | **`--ISTot_ini--;`** | Grupo | 0-1 | — | `total` | Grupo total do imposto seletivo |
| 1194 | 355.3 | 3 | `vIS` | Numérico | 1-1 | 15,2 | `ISTot` | Total do imposto seletivo |
| 1195 | — | 2 | `--ISTot_fim--;` | — | — | — | `total` |  |
| 1196 | 355.4 | 2 | **`--IBSCBSTot_ini--;`** | Grupo | 0-1 | — | `total` | Totais da NF-e com IBS e CBS |
| 1197 | 355.5 | 3 | `vBCIBSCBS` | Numérico | 1-1 | 15,2 | `IBSCBSTot` | Valor total da BC do IBS e da CBS |
| 1198 | 355.6 | 3 | **`--gIBS_Tot_ini--;`** | Grupo | 0-1 | — | `IBSCBSTot` | Grupo total do IBS |
| 1199 | 355.7 | 4 | **`--gIBSUF_Tot_ini--;`** | Grupo | 1-1 | — | `gIBS_Tot` | Grupo total do IBS da UF |
| 1200 | 355.8 | 5 | `vDif` | Numérico | 1-1 | 15,2 | `gIBSUF_Tot` | Valor total do diferimento |
| 1201 | 355.9 | 5 | `vDevTrib` | Numérico | 1-1 | 15,2 | `gIBSUF_Tot` | Valor total de devolução de tributos |
| 1202 | 355.11 | 5 | `vIBSUF` | Numérico | 1-1 | 15,2 | `gIBSUF_Tot` | Valor total do IBS da UF |
| 1203 | — | 4 | `--gIBSUF_Tot_fim--;` | — | — | — | `gIBS_Tot` |  |
| 1204 | 355.12 | 4 | **`--gIBSMun_Tot_ini--;`** | Grupo | 1-1 | — | `gIBS_Tot` | Grupo total do IBS do Município |
| 1205 | 355.13 | 5 | `vDif` | Numérico | 1-1 | 15,2 | `gIBSMun_Tot` | Valor total do diferimento |
| 1206 | 355.14 | 5 | `vDevTrib` | Numérico | 1-1 | 15,2 | `gIBSMun_Tot` | Valor total de devolução de tributos |
| 1207 | 355.16 | 5 | `vIBSMun` | Numérico | 1-1 | 15,2 | `gIBSMun_Tot` | Valor total do IBS do Município |
| 1208 | — | 4 | `--gIBSMun_Tot_fim--;` | — | — | — | `gIBS_Tot` |  |
| 1209 | 355.17 | 4 | `vIBS` | Numérico | 1-1 | 15,2 | `gIBS_Tot` | Valor total do IBS |
| 1210 | 355.18 | 4 | `vCredPres` | Numérico | 1-1 | 15,2 | `gIBS_Tot` | Valor total do crédito presumido |
| 1211 | 355.19 | 4 | `vCredPresCondSus` | Numérico | 1-1 | 15,2 | `gIBS_Tot` | Valor total do crédito presumido em condição suspensiva |
| 1212 | — | 3 | `--gIBS_Tot_fim--;` | — | — | — | `IBSCBSTot` |  |
| 1213 | 355.20 | 3 | **`--gCBS_Tot_ini--;`** | Grupo | 0-1 | — | `IBSCBSTot` | Grupo total da CBS |
| 1214 | 355.23 | 4 | `vDif` | Numérico | 1-1 | 15,2 | `gCBS_Tot` | Valor total do diferimento |
| 1215 | 355.24 | 4 | `vDevTrib` | Numérico | 1-1 | 15,2 | `gCBS_Tot` | Valor total de devolução de tributos |
| 1216 | 355.26 | 4 | `vCBS` | Numérico | 1-1 | 15,2 | `gCBS_Tot` | Valor total da CBS |
| 1217 | 355.26a | 4 | `vCredPres` | Numérico | 1-1 | 15,2 | `gCBS_Tot` | Valor total do crédito presumido |
| 1218 | 355.26b | 4 | `vCredPresCondSus` | Numérico | 1-1 | 15,2 | `gCBS_Tot` | Valor total do crédito presumido em condição suspensiva |
| 1219 | — | 3 | `--gCBS_Tot_fim--;` | — | — | — | `IBSCBSTot` |  |
| 1220 | 355.27 | 3 | **`--gMono_Tot_ini--;`** | Grupo | 0-1 | — | `IBSCBSTot` | Grupo total da Monofasia |
| 1221 | 355.28 | 4 | `vIBSMono` | Numérico | 1-1 | 15,2 | `gMono_Tot` | Total do IBS monofásico |
| 1222 | 355.29 | 4 | `vCBSMono` | Numérico | 1-1 | 15,2 | `gMono_Tot` | Total da CBS monofásica |
| 1223 | 355.29a | 4 | `vIBSMonoReten` | Numérico | 1-1 | 15,2 | `gMono_Tot` | Total do IBS monofásico sujeito a retenção |
| 1224 | 355.29b | 4 | `vCBSMonoReten` | Numérico | 1-1 | 15,2 | `gMono_Tot` | Total da CBS monofásica sujeita a retenção |
| 1225 | 355.29c | 4 | `vIBSMonoRet` | Numérico | 1-1 | 15,2 | `gMono_Tot` | Total do IBS monofásico retido anteriormente |
| 1226 | 355.29d | 4 | `vCBSMonoRet` | Numérico | 1-1 | 15,2 | `gMono_Tot` | Total da CBS monofásica |
| 1227 | — | 3 | `--gMono_Tot_fim--;` | — | — | — | `IBSCBSTot` |  |
| 1228 | 355.29e | 3 | **`--gEstornoCred_ini--;`** | Grupo | 0-1 | — | `IBSCBSTot` | Grupo total do Estorno de Crédito |
| 1229 | 355.29f | 4 | `vIBSEstCred` | Numérico | 1-1 | 15,2 | `gEstornoCred` | Valor total do IBS estornado |
| 1230 | 355.29g | 4 | `vCBSEstCred` | Numérico | 1-1 | 15,2 | `gEstornoCred` | Valor total da CBS estornada |
| 1231 | — | 3 | `--gEstornoCred_fim--;` | — | — | — | `IBSCBSTot` |  |
| 1232 | — | 2 | `--IBSCBSTot_fim--;` | — | — | — | `total` |  |
| 1233 | 355.30 | 2 | `vNFTot` | Numérico | 0-1 | 15,2 | `total` | Valor total da NF-e com IBS / CBS / IS |
| 1234 | 326a | 2 | `vProdLiqTot` | Numérico | 0-1 | 15,2 | `total` | Valor Total Líquido dos Produtos ou Serviços (sem tributos) |
| 1235 | — | 1 | `--total_fim--;` | — | — | — | `nota` |  |

#### `inf_transporte` — pos. sem pos. · linhas 1236–1282 · ocorrência —

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1236 | — | 1 | **`--inf_transporte_ini--;`** | — | — | — | `nota` |  |
| 1237 | 356 | 2 | **`--transp_ini--;`** | — | 1-1 | — | `inf_transporte` | Grupo Informações do Transporte |
| 1238 | 357 | 3 | `modFrete` | Numérico | 1-1 | 1 | `transp` | Modalidade do frete |
| 1239 | — | 2 | `--transp_fim--;` | — | — | — | `inf_transporte` |  |
| 1240 | 358 | 2 | **`--transporta_ini--;`** | — | 0-1 | — | `inf_transporte` | Grupo Transportador |
| 1241 | 359 | 3 | `CNPJ` | Caractere | 0-1 | 14 | `transporta` | CNPJ |
| 1242 | 360 | 3 | `CPF` | Numérico | 0-1 | 11 | `transporta` | CPF |
| 1243 | 361 | 3 | `xNome` | Caractere | 0-1 | 2-60 | `transporta` | Razão Social ou nome |
| 1244 | 362 | 3 | `IE` | Caractere | 0-1 | 0-14 | `transporta` | Inscrição Estadual |
| 1245 | 363 | 3 | `xEnder` | Caractere | 0-1 | 1-60 | `transporta` | Endereço Completo |
| 1246 | 364 | 3 | `xMun` | Caractere | 0-1 | 1-60 | `transporta` | Nome do Município |
| 1247 | 365 | 3 | `UF` | Caractere | 0-1 | 2 | `transporta` | Sigla da UF |
| 1248 | — | 2 | `--transporta_fim--;` | — | — | — | `inf_transporte` |  |
| 1249 | 366 | 2 | **`--ret_Transp_ini--;`** | — | 0-1 | — | `inf_transporte` | Grupo Retenção ICMS transporte |
| 1250 | 367 | 3 | `vServ` | Numérico | 1-1 | 15,2 | `ret_Transp` | Valor do Serviço |
| 1251 | 368 | 3 | `vBCRet` | Numérico | 1-1 | 15,2 | `ret_Transp` | Base de Cálculo da Retenção do ICMS |
| 1252 | 369 | 3 | `pICMSRet` | Numérico | 1-1 | 7,2-4 | `ret_Transp` | Alíquota da Retenção |
| 1253 | 370 | 3 | `vICMSRet` | Numérico | 1-1 | 15,2 | `ret_Transp` | Valor do ICMS Retido |
| 1254 | 371 | 3 | `CFOP` | Numérico | 1-1 | 4 | `ret_Transp` | CFOP |
| 1255 | 372 | 3 | `cMunFG` | Numérico | 1-1 | 7 | `ret_Transp` | Código do município de ocorrência do fato gerador do ICMS do transporte(IBGE) |
| 1256 | — | 2 | `--ret_Transp_fim--;` | — | — | — | `inf_transporte` |  |
| 1257 | 372.1 | 2 | **`--x_transp_diversos_ini--;`** | — | 0-1 | — | `inf_transporte` | Sequencia XML |
| 1258 | 373 | 3 | **`--veic_Transp_ini--;`** | — | 0-1 | — | `x_transp_diversos` | Grupo Veículo Transporte |
| 1259 | 374 | 4 | `placa` | Caractere | 1-1 | 7 | `veic_Transp` | Placa do Veículo |
| 1260 | 375 | 4 | `UF` | Caractere | 0-1 | 2 | `veic_Transp` | Sigla da UF |
| 1261 | 376 | 4 | `RNTC` | Caractere | 0-1 | 1-20 | `veic_Transp` | Registro Nacional de Transportador de Carga (ANTT) |
| 1262 | — | 3 | `--veic_Transp_fim--;` | — | — | — | `x_transp_diversos` |  |
| 1263 | 377 | 3 | **`--reboque_ini--;`** | — | 0-5 | — | `x_transp_diversos` | Grupo Reboque |
| 1264 | 378 | 4 | `placa` | Caractere | 1-1 | 7 | `reboque` | Placa do Veículo |
| 1265 | 379 | 4 | `UF` | Caractere | 0-1 | 2 | `reboque` | Sigla da UF |
| 1266 | 380 | 4 | `RNTC` | Caractere | 0-1 | 1-20 | `reboque` | Registro Nacional de Transportador de Carga (ANTT) |
| 1267 | — | 3 | `--reboque_fim--;` | — | — | — | `x_transp_diversos` |  |
| 1268 | — | 2 | `--x_transp_diversos_fim--;` | — | — | — | `inf_transporte` |  |
| 1269 | 380a | 2 | `vagao` | Caractere | 0-1 | 1-20 | `inf_transporte` | Identificação do vagão |
| 1270 | 380b | 2 | `balsa` | Caractere | 0-1 | 1-20 | `inf_transporte` | Identificação da balsa |
| 1271 | 381 | 2 | **`--volume_ini--;`** | — | 0-5000 | — | `inf_transporte` | Grupo Volumes |
| 1272 | 382 | 3 | `qVol` | Numérico | 0-1 | 1-15 | `volume` | Quantidade de Volume |
| 1273 | 383 | 3 | `esp` | Caractere | 0-1 | 1-60 | `volume` | Espécie dos volumes transportados |
| 1274 | 384 | 3 | `marca` | Caractere | 0-1 | 1-60 | `volume` | Marca dos volumes transportados |
| 1275 | 385 | 3 | `nVol` | Caractere | 0-1 | 1-60 | `volume` | Numeração dos volumes transportados |
| 1276 | 386 | 3 | `pesoL` | Numérico | 0-1 | 15,3 | `volume` | Peso Líquido(em Kg) |
| 1277 | 387 | 3 | `pesoB` | Numérico | 0-1 | 15,3 | `volume` | Peso Bruto(em Kg) |
| 1278 | 387a | 3 | **`--lacre_ini--;`** | — | 0-5000 | — | `volume` | Grupo Lacre |
| 1279 | 388 | 4 | `nLacre` | Caractere | 1-1 | 1-60 | `lacre` | Número de Lacres |
| 1280 | — | 3 | `--lacre_fim--;` | — | — | — | `volume` |  |
| 1281 | — | 2 | `--volume_fim--;` | — | — | — | `inf_transporte` |  |
| 1282 | — | 1 | `--inf_transporte_fim--;` | — | — | — | `nota` |  |

#### `cobr` — pos. 389 · linhas 1283–1295 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1283 | 389 | 1 | **`--cobr_ini--;`** | — | 0-1 | — | `nota` | Grupo Cobrança |
| 1284 | 390 | 2 | **`--fat_ini--;`** | — | 0-1 | — | `cobr` | Grupo Fatura |
| 1285 | 391 | 3 | `nFat` | Caractere | 0-1 | 1-60 | `fat` | Número da Fatura |
| 1286 | 392 | 3 | `vOrig` | Numérico | 0-1 | 15,2 | `fat` | Valor Original da Fatura |
| 1287 | 393 | 3 | `vDesc` | Numérico | 0-1 | 15,2 | `fat` | Valor do desconto |
| 1288 | 394 | 3 | `vLiq` | Numérico | 0-1 | 15,2 | `fat` | Valor Líquido da Fatura |
| 1289 | — | 2 | `--fat_fim--;` | — | — | — | `cobr` |  |
| 1290 | 395 | 2 | **`--duplicata_ini--;`** | — | 0-120 | — | `cobr` | Grupo Parcelas |
| 1291 | 396 | 3 | `nDup` | Caractere | 0-1 | 1-60 | `duplicata` | Número da Parcela |
| 1292 | 397 | 3 | `dVenc` | Data | 0-1 | — | `duplicata` | Data de vencimento |
| 1293 | 398 | 3 | `vDup` | Numérico | 1-1 | 15,2 | `duplicata` | Valor da Parcela |
| 1294 | — | 2 | `--duplicata_fim--;` | — | — | — | `cobr` |  |
| 1295 | — | 1 | `--cobr_fim--;` | — | — | — | `nota` |  |

#### `pag` — pos. 398a · linhas 1296–1317 · ocorrência 1-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1296 | 398a | 1 | **`--pag_ini--;`** | — | 1-1 | — | `nota` | Grupo de Formas de Pagamento |
| 1297 | 398a1 | 2 | **`--detPag_ini--;`** | — | 1-100 | — | `pag` | Grupo Detalhamento do Pagamento |
| 1298 | 398a2 | 3 | `indPag` | Numérico | 0-1 | 1 | `detPag` | Indicador da forma de Pagamento |
| 1299 | 398b | 3 | `tPag` | Numérico | 1-1 | 2 | `detPag` | Meio de pagamento |
| 1300 | 398c | 3 | `vPag` | Numérico | 1-1 | 15,2 | `detPag` | Valor do Pagamento |
| 1301 | 398b1 | 3 | `xPag` | Caractere | 0-1 | 2-60 | `detPag` | Descrição do Meio de Pagamento |
| 1302 | 398b2 | 3 | `dPag` | Data | 0-1 | 19 | `detPag` | Data do Pagamento |
| 1303 | 398.13b | 3 | **`--sequencia_XML_detPag_ini--;`** | — | 0-1 | — | `detPag` | Sequência XML |
| 1304 | 398.13c | 4 | `CNPJPag` | Caractere | 1-1 | 14 | `sequencia_XML_detPag` | CNPJ transacional do pagamento |
| 1305 | 398.13d | 4 | `UFPag` | Caractere | 1-1 | 2 | `sequencia_XML_detPag` | UF do CNPJ do estabelecimento onde o pagamento foi processado/transacionado/rec… |
| 1306 | — | 3 | `--sequencia_XML_detPag_fim--;` | — | — | — | `detPag` |  |
| 1307 | 398d | 3 | **`--card_ini--;`** | — | 0-1 | — | `detPag` | Grupo de Cartões, PIX, Boletos e outros Pagamentos Eletrônicos |
| 1308 | 398d.1 | 4 | `tpIntegra` | Numérico | 1-1 | 1 | `card` | Tipo de Integração para pagamento |
| 1309 | 398e | 4 | `CNPJ` | Caractere | 0-1 | 14 | `card` | CNPJ da instituição de pagamento |
| 1310 | 398f | 4 | `tBand` | Numérico | 0-1 | 2 | `card` | Bandeira da operadora de cartão de crédito e/ou débito |
| 1311 | 398g | 4 | `cAut` | Caractere | 0-1 | 1-128 | `card` | Número de autorização da operação cartão de crédito e/ou débito |
| 1312 | 398d.2 | 4 | `CNPJReceb` | Caractere | 0-1 | 14 | `card` | CNPJ do beneficiário do pagamento |
| 1313 | 398d.3 | 4 | `idTermpag` | Caractere | 0-1 | 40 | `card` | Identificador do terminal de pagamento |
| 1314 | — | 3 | `--card_fim--;` | — | — | — | `detPag` |  |
| 1315 | — | 2 | `--detPag_fim--;` | — | — | — | `pag` |  |
| 1316 | 398i | 2 | `vTroco` | Numérico | 0-1 | 15,2 | `pag` | Valor do troco |
| 1317 | — | 1 | `--pag_fim--;` | — | — | — | `nota` |  |

#### `infIntermed` — pos. 398j · linhas 1318–1321 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1318 | 398j | 1 | **`--infIntermed_ini--;`** | — | 0-1 | — | `nota` | Grupo de Informações do Intermediador da Transação |
| 1319 | 398k | 2 | `CNPJ` | Caractere | 1-1 | 14 | `infIntermed` | CNPJ do Intermediador da Transação (agenciador, plataforma de delivery, marketp… |
| 1320 | 398l | 2 | `idCadIntTran` | Caractere | 1-1 | 2-60 | `infIntermed` | Identificador cadastrado no intermediador |
| 1321 | — | 1 | `--infIntermed_fim--;` | — | — | — | `nota` |  |

#### `gPgtoVinc` — pos. 398.50 · linhas 1322–1330 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1322 | 398.50 | 1 | **`--gPgtoVinc_ini--;`** | — | 0-1 | — | `nota` | Grupo de informações da Vinculação com a Transação de Pagamento (YC01) |
| 1323 | 398.51 | 2 | **`--gPgto_ini--;`** | — | 1-99 | — | `gPgtoVinc` | Dados de cada pagamento previsto para o DF-e (YC02) |
| 1324 | 398.52 | 3 | `nPag` | Numérico | 1-1 | 3 | `gPgto` | Número sequencial do pagamento (YC03) |
| 1325 | 398.53 | 3 | `idTransacao` | Caractere | 1-1 | 2-35 | `gPgto` | Identificador da transação financeira (YC04) |
| 1326 | 398.54 | 3 | `tpMeioPgto` | Numérico | 1-1 | 2 | `gPgto` | Código do meio de pagamento (YC05) |
| 1327 | 398.55 | 3 | `CNPJReceb` | Caractere | 1-1 | 14 | `gPgto` | CNPJ do recebedor do pagamento (YC06) |
| 1328 | 398.56 | 3 | `CNPJBasePSP` | Caractere | 1-1 | 8 | `gPgto` | CNPJ base da instituição financeira ou de pagamento (YC07) |
| 1329 | — | 2 | `--gPgto_fim--;` | — | — | — | `gPgtoVinc` |  |
| 1330 | — | 1 | `--gPgtoVinc_fim--;` | — | — | — | `nota` |  |

#### `inf_Adic` — pos. 399 · linhas 1331–1347 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1331 | 399 | 1 | **`--inf_Adic_ini--;`** | — | 0-1 | — | `nota` | Grupo de Informações Adicionais |
| 1332 | 400 | 2 | `infAdFisco` | Caractere | 0-1 | 1-2000 | `inf_Adic` | Informações Adicionais de Interesse do Fisco |
| 1333 | 401 | 2 | `infCpl` | Caractere | 0-1 | 1-5000 | `inf_Adic` | Informações Complementares de Interesse do Contribuinte |
| 1334 | 401a | 2 | **`--uso_livre_c_ini--;`** | — | 0-10 | — | `inf_Adic` | Grupo Campo de uso livre do Contribuinte |
| 1335 | 401b | 3 | `xCampo` | Caractere | 1-1 | 1-20 | `uso_livre_c` | Identificação do campo |
| 1336 | 401c | 3 | `xTexto` | Caractere | 1-1 | 1-60 | `uso_livre_c` | Conteúdo do Campo |
| 1337 | — | 2 | `--uso_livre_c_fim--;` | — | — | — | `inf_Adic` |  |
| 1338 | 401d | 2 | **`--uso_livre_f_ini--;`** | — | 0-10 | — | `inf_Adic` | Grupo Campo de uso livre do Fisco |
| 1339 | 401e | 3 | `xCampo` | Caractere | 1-1 | 1-20 | `uso_livre_f` | Identificação do campo |
| 1340 | 401f | 3 | `xTexto` | Caractere | 1-1 | 1-60 | `uso_livre_f` | Conteúdo do Campo |
| 1341 | — | 2 | `--uso_livre_f_fim--;` | — | — | — | `inf_Adic` |  |
| 1342 | 401g | 2 | **`--proc_referenciado_ini--;`** | — | 0-100 | — | `inf_Adic` | Grupo Processo referenciado |
| 1343 | 401h | 3 | `nProc` | Caractere | 1-1 | 1-60 | `proc_referenciado` | Identificador do processo ou ato concessório |
| 1344 | 401i | 3 | `indProc` | Numérico | 1-1 | 1 | `proc_referenciado` | Indicador da origem do processo |
| 1345 | 401j | 3 | `tpAto` | Numérico | 0-1 | 2 | `proc_referenciado` | Tipo do ato concessório |
| 1346 | — | 2 | `--proc_referenciado_fim--;` | — | — | — | `inf_Adic` |  |
| 1347 | — | 1 | `--inf_Adic_fim--;` | — | — | — | `nota` |  |

#### `exporta` — pos. 402 · linhas 1348–1352 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1348 | 402 | 1 | **`--exporta_ini--;`** | — | 0-1 | — | `nota` | Grupo Exportação |
| 1349 | 403 | 2 | `UFSaidaPais` | Caractere | 1-1 | 2 | `exporta` | Sigla da UF de Embarque ou transposição de fronteira |
| 1350 | 404 | 2 | `xLocExporta` | Caractere | 1-1 | 1-60 | `exporta` | Descrição do Local de Embarque ou de transposição de fronteira |
| 1351 | 404a | 2 | `xLocDespacho` | Caractere | 0-1 | 1-60 | `exporta` | Descrição do local de despacho |
| 1352 | — | 1 | `--exporta_fim--;` | — | — | — | `nota` |  |

#### `compra` — pos. 405 · linhas 1353–1357 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1353 | 405 | 1 | **`--compra_ini--;`** | — | 0-1 | — | `nota` | Grupo Compra |
| 1354 | 406 | 2 | `xNEmp` | Caractere | 0-1 | 1-22 | `compra` | Nota de Empenho |
| 1355 | 407 | 2 | `xPed` | Caractere | 0-1 | 1-60 | `compra` | Pedido |
| 1356 | 408 | 2 | `xCont` | Caractere | 0-1 | 1-60 | `compra` | Contrato de compra |
| 1357 | — | 1 | `--compra_fim--;` | — | — | — | `nota` |  |

#### `cana` — pos. 409 · linhas 1358–1375 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1358 | 409 | 1 | **`--cana_ini--;`** | — | 0-1 | — | `nota` | Grupo Cana |
| 1359 | 410 | 2 | `safra` | Caractere | 1-1 | 4-9 | `cana` | Identificação da safra |
| 1360 | 411 | 2 | `ref` | Caractere | 1-1 | 7 | `cana` | Mês e ano de referencia |
| 1361 | 412 | 2 | **`--cana_forn_diario_ini--;`** | — | 1-31 | — | `cana` | Grupo Fornecimento diário de cana |
| 1362 | 427 | 3 | `dia` | Numérico | 1-1 | 1-2 | `cana_forn_diario` | Dia |
| 1363 | 414 | 3 | `qtde` | Numérico | 1-1 | 21,10 | `cana_forn_diario` | Quantidade |
| 1364 | — | 2 | `--cana_forn_diario_fim--;` | — | — | — | `cana` |  |
| 1365 | 415 | 2 | `qTotMes` | Numérico | 1-1 | 21,10 | `cana` | Quantidade total do mês |
| 1366 | 416 | 2 | `qTotAnt` | Numérico | 1-1 | 21,10 | `cana` | Quantidade total anterior |
| 1367 | 417 | 2 | `qTotGer` | Numérico | 1-1 | 21,10 | `cana` | Quantidade total geral |
| 1368 | 418 | 2 | **`--cana_deducao_ini--;`** | — | 0-10 | — | `cana` | Grupo Deduções - Taxas e Contribuições |
| 1369 | 419 | 3 | `xDed` | Caractere | 1-1 | 1-60 | `cana_deducao` | Descrição da dedução |
| 1370 | 420 | 3 | `vDed` | Numérico | 1-1 | 15,2 | `cana_deducao` | valor da dedução |
| 1371 | — | 2 | `--cana_deducao_fim--;` | — | — | — | `cana` |  |
| 1372 | 421 | 2 | `vFor` | Numérico | 1-1 | 15,2 | `cana` | Valor dos fornecimentos |
| 1373 | 422 | 2 | `vTotDed` | Numérico | 1-1 | 15,2 | `cana` | valor total da dedução |
| 1374 | 423 | 2 | `vLiqFor` | Numérico | 1-1 | 15,2 | `cana` | Valor liquido dos fornecimentos |
| 1375 | — | 1 | `--cana_fim--;` | — | — | — | `nota` |  |

#### `infRespTec` — pos. 423a · linhas 1376–1385 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1376 | 423a | 1 | **`--infRespTec_ini--;`** | Grupo | 0-1 | — | `nota` | Informações do Responsável Técnico pelo sistema de emissão do Documento Fiscal… |
| 1377 | 423b | 2 | `CNPJ` | Caractere | 1-1 | 14 | `infRespTec` | CNPJ da pessoa jurídica responsável pelo sistema utilizado na emissão do docume… |
| 1378 | 423c | 2 | `xContato` | Caractere | 1-1 | 2-60 | `infRespTec` | Nome da pessoa a ser contatada |
| 1379 | 423d | 2 | `email` | Caractere | 1-1 | 6-60 | `infRespTec` | E-mail da pessoa jurídica/física a ser contatada |
| 1380 | 423e | 2 | `fone` | Numérico | 1-1 | 6-14 | `infRespTec` | Telefone da pessoa jurídica/física a ser contatada |
| 1381 | 423f | 2 | **`--seq_XML_ini--;`** | Grupo | 0-1 | — | `infRespTec` | Grupo de informações do Código de Segurança do Responsável Técnico - CSRT |
| 1382 | 423g | 3 | `idCSRT` | Numérico | 1-1 | 2 | `seq_XML` | Identificador do código de segurança do responsável técnico |
| 1383 | 423h | 3 | `CSRT` | Caractere | 1-1 | 28 | `seq_XML` | Código de Segurança do Responsável Técnico |
| 1384 | — | 2 | `--seq_XML_fim--;` | — | — | — | `infRespTec` |  |
| 1385 | — | 1 | `--infRespTec_fim--;` | — | — | — | `nota` |  |

#### `agropecuario` — pos. 424 · linhas 1386–1397 · ocorrência 0-1

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1386 | 424 | 1 | **`--agropecuario_ini--;`** | Grupo | 0-1 | — | `nota` | Informações de produtos da agricultura, pecuária e produção Florestal |
| 1387 | 424a | 2 | **`--defensivo_ini--;`** | CG | 1-20 | — | `agropecuario` | Defensivos Agrícolas |
| 1388 | 424b | 3 | `nReceituario` | Caractere | 1-1 | 1-30 | `defensivo` | Número da receita ou receituário do agrotóxico / defensivo agrícola. |
| 1389 | 424c | 3 | `CPFRespTec` | Numérico | 1-1 | 11 | `defensivo` | CPF do Responsável Técnico, emitente do receituário |
| 1390 | — | 2 | `--defensivo_fim--;` | — | — | — | `agropecuario` |  |
| 1391 | 424d | 2 | **`--guiaTransito_ini--;`** | CG | 1-1 | — | `agropecuario` | Guia de Trânsito |
| 1392 | 424e | 3 | `tpGuia` | Numérico | 1-1 | 1 | `guiaTransito` | Tipo da Guia |
| 1393 | 424f | 3 | `UFGuia` | Caractere | 1-1 | 2 | `guiaTransito` | UF de emissão |
| 1394 | 424g | 3 | `serieGuia` | Caractere | 0-1 | 1-9 | `guiaTransito` | Série da Guia |
| 1395 | 424h | 3 | `nGuia` | Numérico | 1-1 | 1-9 | `guiaTransito` | Número da Guia |
| 1396 | — | 2 | `--guiaTransito_fim--;` | — | — | — | `agropecuario` |  |
| 1397 | — | 1 | `--agropecuario_fim--;` | — | — | — | `nota` |  |

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1398 | — | 0 | `--nota_fim--;` | — | — | — | — |  |

#### Encerramento do arquivo — fora do bloco `nota`

| Nº | Pos. | Nív. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai | Descrição |
|---:|---|---:|---|---|---|---|---|---|
| 1399 | — | 0 | `--arquivo_fim--;` | — | — | — | — | Encerramento do arquivo (sem `--arquivo_ini--;` correspondente — ver 1.4) |

---

## 9. Anexo A — Diferenças 4.16 → 4.19 (versão em uso na DHL × versão alvo)

Comparação entre as abas `Envio NFe_NFCe - 4.00 -DFe 4.16` (1.274 linhas) e `Envio NFe_NFCe - 4.00 -DFe 4.19` (1.399 linhas).

**Metodologia e limites desta comparação:** a chave de comparação é o par **(posição, tag)**. Consequências a considerar ao ler as tabelas:

- Um campo que apenas **mudou de identificador** aparece duas vezes: como removido (ID antigo) e como novo (ID novo). É o caso do `gCompraGov` (`29f*` → `29.z*`) e das correções de ponto duplo descritas no item 8 da seção 5.
- Marcadores `--xxx_fim--;` **não têm posição** na planilha; portanto um `_fim` cujo nome já existia na 4.16 não é listado como novo, mesmo quando pertence a um grupo inteiramente novo da 4.19 (ex.: os `--gMonoPadrao_fim--;` dos novos blocos Ad Rem/Ad Valorem). O total real de linhas acrescentadas é o delta de 1.274 → 1.399 = **+125 linhas**.
- Mudanças de **tipo, tamanho, decimais, ocorrência ou observação** em campos que mantiveram posição e nome **não** aparecem aqui (ex.: `vNFTot`, cuja ocorrência passou de 1-1 para 0-1 na 4.16 e cuja observação da NT 2026.008 foi incluída na 4.19).
- A primeira linha da tabela A.1, `--nota_ini--;`, é **artefato de documentação, não alteração de leiaute**: a aba 4.16 não lista essa linha (começa direto em `--versao_Layout_DFe_ini--;`), embora liste `--nota_fim--;` no fim — ou seja, a aba 4.16 está desbalanceada. A linha passou a ser documentada a partir da 4.17. O código já a emite: a raiz `nota` é instanciada em [ProcMsaNFe.prw:194](../PROTHEUS/Producao/Mastersaf_NFe/ProcMsaNFe.prw#L194) e o marcador é serializado em [MsafNFeFile.prw:99](../PROTHEUS/Producao/Mastersaf_NFe/MsafNFeFile.prw#L99). **Nenhuma ação necessária.**

### A.1 Linhas novas na 4.19 (169)

| Nº 4.19 | Pos. | Tag / Campo | Tipo | Ocor. | Tam,Dec | Grupo pai |
|---:|---|---|---|---|---|---|
| 1 | — | `--nota_ini--;` | — | 1-1 | — | *artefato de documentação — ver nota abaixo* |
| 34 | 14a | `dPrevEntrega` | Data | 0-1 | 10 | `ide` |
| 51 | 29.6 | `cIndOp` | Numérico | 0-1 | 6 | `ide` |
| 56 | 29.z1 | `--gCompraGov_ini--;` | — | 0-1 | — | `ide` |
| 57 | 29.z2 | `tpEnteGov` | Númerico | 1-1 | 1 | `gCompraGov` |
| 58 | 29.z3 | `pRedutor` | Númerico | 1-1 | 7,2-4 | `gCompraGov` |
| 59 | 29.z4 | `tpOperGov` | Númerico | 1-1 | 1 | `gCompraGov` |
| 60 | 29.z5a | `--ref_NFe_ini--;` | — | 0-99 | — | `gCompraGov` |
| 61 | 29.z5 | `refDFeAnt` | Caractere | 1-1 | 44 | `ref_NFe` |
| 121 | 49d | `ISUFEmit` | Caractere | 0-1 | 8-9 | `emit` |
| 218 | 104h | `tpCredPresIBSZFM` | Numérico | 0-1 | 1 | `prod` |
| 359 | 110.01 | `--sequencia_XML_liq_ini--;` | — | 0-1 | — | `prod` |
| 360 | 110.02 | `vUnComLiq` | Numérico | 1-1 | 21,0-10 | `sequencia_XML_liq` |
| 361 | 110.03 | `vProdLiq` | Numérico | 1-1 | 15,2 | `sequencia_XML_liq` |
| 362 | — | `--sequencia_XML_liq_fim--;` | — | — | — | `prod` |
| 580 | 237.1a | `cBenefRBC` | Caractere | 0-1 | 10 | `x_icms90_icms` |
| 581 | 238.0 | `--sequencia_XML_op_ini--;` | — | 0-1 | — | `x_icms90_icms` |
| 582 | 238.01 | `vICMSOp` | Numérico | 1-1 | 15,2 | `sequencia_XML_op` |
| 583 | 238.02 | `pDif` | Numérico | 1-1 | 7,2-4 | `sequencia_XML_op` |
| 584 | 238.03 | `vICMSDif` | Numérico | 1-1 | 15,2 | `sequencia_XML_op` |
| 585 | — | `--sequencia_XML_op_fim--;` | — | — | — | `x_icms90_icms` |
| 586 | 239.01 | `--sequencia_XML_ini--;` | — | 0-1 | — | `x_icms90_icms` |
| 587 | 239.02 | `vBCFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML` |
| 588 | 239.03 | `pFCP` | Numérico | 1-1 | 7,2-4 | `sequencia_XML` |
| 589 | 239.04 | `vFCP` | Numérico | 1-1 | 15,2 | `sequencia_XML` |
| 591 | 239.05 | `--sequencia_XML_fcpdif_ini--;` | — | 0-1 | — | `x_icms90_icms` |
| 592 | 239.06 | `pFCPDif` | Numérico | 1-1 | 7,2-4 | `sequencia_XML_fcpdif` |
| 593 | 239.07 | `vFCPDif` | Numérico | 1-1 | 15,2 | `sequencia_XML_fcpdif` |
| 594 | 239.08 | `vFCPEfet` | Numérico | 0-1 | 15,2 | `sequencia_XML_fcpdif` |
| 595 | — | `--sequencia_XML_fcpdif_fim--;` | — | — | — | `x_icms90_icms` |
| 613 | 245.4 | `indDeduzDeson` | Numérico | 0-1 | 1 | `x_icms90_deson` |
| 641 | 245.17 | `--sequencia_XML_deson_ini--;` | — | 0-1 | — | `icms_part` |
| 642 | 245.18 | `vICMSDeson` | Numérico | 1-1 | 15,2 | `sequencia_XML_deson` |
| 643 | 245.19 | `motDesICMS` | Numérico | 1-1 | 2 | `sequencia_XML_deson` |
| 644 | 245.20 | `indDeduzDeson` | Numérico | 0-1 | 1 | `sequencia_XML_deson` |
| 645 | — | `--sequencia_XML_deson_fim--;` | — | — | — | `icms_part` |
| 759 | 245b.01 | `--ICMS_Previsto_ini--;` | — | 0-1 | — | `ICMS` |
| 760 | 245b.02 | `vICMSPrevisto` | Numérico | 1-1 | 15,2 | `ICMS_Previsto` |
| 761 | — | `--ICMS_Previsto_fim--;` | — | — | — | `ICMS` |
| 907 | 324.07 | `pISEspec / adRemIS` | Numérico | 0-1 | 7,2-4 | `seqSeletivo` |
| 918 | 324.14a | `indDoacao` | Caractere | 0-1 | 1 | `IBSCBS` |
| 919 | 324.14k | `--sequencia_XML_IBSCBS_ini--;` | Grupo | — | — | `IBSCBS` |
| 926 | 324.21 | `--gDif_ini--;` | — | 0-1 | — | `gIBSUF` |
| 928 | 324.23 | `vDif` | Numérico | 1-1 | 15,2 | `gDif` |
| 931 | 324.24a | `pDevTrib` | Numérico | 0-1 | 7,2-4 | `gDevTrib` |
| 932 | 324.25 | `vDevTrib` | Numérico | 1-1 | 15,2 | `gDevTrib` |
| 935 | 324.27 | `pRedAliq` | Numérico | 1-1 | 7,2-4 | `gRed` |
| 936 | 324.28 | `pAliqEfet` | Numérico | 1-1 | 7,2-4 | `gRed` |
| 947 | 324.43a | `pDevTrib` | Numérico | 0-1 | 7,2-4 | `gDevTrib` |
| 963 | 324.62a | `pDevTrib` | Numérico | 0-1 | 7,2-4 | `gDevTrib` |
| 970 | 324.66a | `--gALCZFMCBS_ini--;` | — | 0-1 | — | `gCBS` |
| 971 | 324.66b | `tpALCZFMCBS` | Numérico | 1-1 | 1 | `gALCZFMCBS` |
| 972 | 324.66c | `nProcSuframa` | Caractere | 0-1 | 8-12 | `gALCZFMCBS` |
| 973 | 324.66d | `pAliqEfetRegCBS` | Numérico | 1-1 | 7,2-4 | `gALCZFMCBS` |
| 974 | 324.66e | `vTribRegCBS` | Numérico | 1-1 | 15,2 | `gALCZFMCBS` |
| 975 | — | `--gALCZFMCBS_fim--;` | — | — | — | `gCBS` |
| 997 | 324.85 | `--sequencia_XML_IBSMono_ini--;` | G | 0-1 | — | `gIBSCBSMono` |
| 998 | 324.85a | `--gIBSMonoAdRem_ini--;` | CG | 0-1 | — | `sequencia_XML_IBSMono` |
| 999 | 324.86 | `--gMonoPadrao_ini--;` | G | 0-1 | — | `gIBSMonoAdRem` |
| 1000 | 324.86a | `qBCMono` | Numérico | 1-1 | 15,0 ou 4 | `gMonoPadrao` |
| 1001 | 324.86b | `adRemIBS` | Numérico | 1-1 | 7,2-4 | `gMonoPadrao` |
| 1002 | 324.86c | `vIBSMono` | Numérico | 1-1 | 15,2 | `gMonoPadrao` |
| 1004 | 324.87 | `--gMonoReten_ini--;` | G | 0-1 | — | `gIBSMonoAdRem` |
| 1005 | 324.87a | `qBCMonoReten` | Numérico | 1-1 | 15,0 ou 4 | `gMonoReten` |
| 1006 | 324.87b | `adRemIBSReten` | Numérico | 1-1 | 7,2-4 | `gMonoReten` |
| 1007 | 324.87c | `vIBSMonoReten` | Numérico | 1-1 | 15,2 | `gMonoReten` |
| 1009 | 324.88 | `--gMonoRet_ini--;` | G | 0-1 | — | `gIBSMonoAdRem` |
| 1010 | 324.88a | `vIBSMonoRet` | Numérico | 1-1 | 15,2 | `gMonoRet` |
| 1012 | 324.89 | `--gpBioDiferenca_ini--;` | G | 0-1 | — | `gIBSMonoAdRem` |
| 1013 | 324.89a | `qBCBioComb` | Numérico | 1-1 | 15,0 ou 4 | `gpBioDiferenca` |
| 1014 | 324.89b | `vIBSDiferenca` | Numérico | 1-1 | 15,2 | `gpBioDiferenca` |
| 1015 | — | `--gpBioDiferenca_fim--;` | — | — | — | `gIBSMonoAdRem` |
| 1016 | — | `--gIBSMonoAdRem_fim--;` | — | — | — | `sequencia_XML_IBSMono` |
| 1017 | 324.90 | `--gIBSMonoAdValorem_ini--;` | CG | 0-1 | — | `sequencia_XML_IBSMono` |
| 1018 | 324.91 | `--gMonoPadrao_ini--;` | G | 0-1 | — | `gIBSMonoAdValorem` |
| 1019 | 324.91a | `vBCMono` | Numérico | 1-1 | 15,2 | `gMonoPadrao` |
| 1020 | 324.91b | `pAliqMonoUF` | Numérico | 1-1 | 7,2-4 | `gMonoPadrao` |
| 1021 | 324.91c | `vIBSMonoUF` | Numérico | 1-1 | 15,2 | `gMonoPadrao` |
| 1022 | 324.91d | `pAliqMonoMun` | Numérico | 1-1 | 7,2-4 | `gMonoPadrao` |
| 1023 | 324.91e | `vIBSMonoMun` | Numérico | 1-1 | 15,2 | `gMonoPadrao` |
| 1024 | 324.91f | `vIBSMono` | Numérico | 1-1 | 15,2 | `gMonoPadrao` |
| 1026 | 324.92 | `--gMonoReten_ini--;` | G | 0-1 | — | `gIBSMonoAdValorem` |
| 1027 | 324.92a | `vBCMonoReten` | Numérico | 1-1 | 15,2 | `gMonoReten` |
| 1028 | 324.92b | `pAliqMonoReten` | Numérico | 1-1 | 7,2-4 | `gMonoReten` |
| 1029 | 324.92c | `vIBSMonoReten` | Numérico | 1-1 | 15,2 | `gMonoReten` |
| 1031 | 324.93 | `--gMonoRet_ini--;` | G | 0-1 | — | `gIBSMonoAdValorem` |
| 1032 | 324.93a | `vIBSMonoRet` | Numérico | 1-1 | 15,2 | `gMonoRet` |
| 1034 | 324.94 | `--gpBioDiferenca_ini--;` | G | 0-1 | — | `gIBSMonoAdValorem` |
| 1035 | 324.94a | `qBCBioComb` | Numérico | 1-1 | 15,0 ou 4 | `gpBioDiferenca` |
| 1036 | 324.94b | `vIBSDiferenca` | Numérico | 1-1 | 15,2 | `gpBioDiferenca` |
| 1037 | — | `--gpBioDiferenca_fim--;` | — | — | — | `gIBSMonoAdValorem` |
| 1038 | — | `--gIBSMonoAdValorem_fim--;` | — | — | — | `sequencia_XML_IBSMono` |
| 1039 | — | `--sequencia_XML_IBSMono_fim--;` | — | — | — | `gIBSCBSMono` |
| 1040 | 324.95 | `--sequencia_XML_CBSMono_ini--;` | G | 0-1 | — | `gIBSCBSMono` |
| 1041 | 324.95a | `--gCBSMonoAdRem_ini--;` | CG | 0-1 | — | `sequencia_XML_CBSMono` |
| 1042 | 324.96 | `--gMonoPadrao_ini--;` | G | 0-1 | — | `gCBSMonoAdRem` |
| 1043 | 324.96a | `qBCMono` | Numérico | 1-1 | 15,0 ou 4 | `gMonoPadrao` |
| 1044 | 324.96b | `adRemCBS` | Numérico | 1-1 | 7,2-4 | `gMonoPadrao` |
| 1045 | 324.96c | `vCBSMono` | Numérico | 1-1 | 15,2 | `gMonoPadrao` |
| 1047 | 324.97 | `--gMonoReten_ini--;` | G | 0-1 | — | `gCBSMonoAdRem` |
| 1048 | 324.97a | `qBCMonoReten` | Numérico | 1-1 | 15,0 ou 4 | `gMonoReten` |
| 1049 | 324.97b | `adRemCBSReten` | Numérico | 1-1 | 7,2-4 | `gMonoReten` |
| 1050 | 324.97c | `vCBSMonoReten` | Numérico | 1-1 | 15,2 | `gMonoReten` |
| 1052 | 324.98 | `--gMonoRet_ini--;` | G | 0-1 | — | `gCBSMonoAdRem` |
| 1055 | 324.99 | `--gpBioDiferenca_ini--;` | G | 0-1 | — | `gCBSMonoAdRem` |
| 1056 | 324.99a | `qBCBioComb` | Numérico | 1-1 | 15,0 ou 4 | `gpBioDiferenca` |
| 1057 | 324.99b | `vCBSDiferenca` | Numérico | 1-1 | 15,2 | `gpBioDiferenca` |
| 1058 | — | `--gpBioDiferenca_fim--;` | — | — | — | `gCBSMonoAdRem` |
| 1059 | — | `--gCBSMonoAdRem_fim--;` | — | — | — | `sequencia_XML_CBSMono` |
| 1060 | 324.100 | `--gCBSMonoAdValorem_ini--;` | CG | 0-1 | — | `sequencia_XML_CBSMono` |
| 1061 | 324.101 | `--gMonoPadrao_ini--;` | G | 0-1 | — | `gCBSMonoAdValorem` |
| 1062 | 324.101a | `vBCMono` | Numérico | 1-1 | 15,2 | `gMonoPadrao` |
| 1063 | 324.101b | `pAliqMonoCBS` | Numérico | 1-1 | 7,2-4 | `gMonoPadrao` |
| 1064 | 324.101c | `vCBSMono` | Numérico | 1-1 | 15,2 | `gMonoPadrao` |
| 1066 | 324.102 | `--gMonoReten_ini--;` | G | 0-1 | — | `gCBSMonoAdValorem` |
| 1067 | 324.102a | `vBCMonoReten` | Numérico | 1-1 | 15,2 | `gMonoReten` |
| 1068 | 324.102b | `pAliqMonoReten` | Numérico | 1-1 | 7,2-4 | `gMonoReten` |
| 1069 | 324.102c | `vCBSMonoReten` | Numérico | 1-1 | 15,2 | `gMonoReten` |
| 1071 | 324.103 | `--gMonoRet_ini--;` | G | 0-1 | — | `gCBSMonoAdValorem` |
| 1072 | 324.103a | `vCBSMonoRet` | Numérico | 1-1 | 15,2 | `gMonoRet` |
| 1074 | 324.104 | `--gpBioDiferenca_ini--;` | G | 0-1 | — | `gCBSMonoAdValorem` |
| 1075 | 324.104a | `qBCBioComb` | Numérico | 1-1 | 15,0 ou 4 | `gpBioDiferenca` |
| 1076 | 324.104b | `vCBSDiferenca` | Numérico | 1-1 | 15,2 | `gpBioDiferenca` |
| 1077 | — | `--gpBioDiferenca_fim--;` | — | — | — | `gCBSMonoAdValorem` |
| 1078 | — | `--gCBSMonoAdValorem_fim--;` | — | — | — | `sequencia_XML_CBSMono` |
| 1079 | — | `--sequencia_XML_CBSMono_fim--;` | — | — | — | `gIBSCBSMono` |
| 1080 | 324.105a | `vTotIBSMonoItem` | Numérico | 1-1 | 15,2 | `gIBSCBSMono` |
| 1081 | 324.105b | `vTotCBSMonoItem` | Numérico | 1-1 | 15,2 | `gIBSCBSMono` |
| 1087 | 324.112 | `--gAjusteCompet_ini--;` | CG | 1-1 | — | `sequencia_XML_IBSCBS` |
| 1088 | 324113 | `competApur` | Caractere | 1-1 | 7 | `gAjusteCompet` |
| 1089 | 324114 | `vIBS` | Numérico | 1-1 | 15,2 | `gAjusteCompet` |
| 1090 | 324115 | `vCBS` | Numérico | 1-1 | 15,2 | `gAjusteCompet` |
| 1091 | — | `--gAjusteCompet_fim--;` | — | — | — | `sequencia_XML_IBSCBS` |
| 1093 | 324116 | `--gEstornoCred_ini--;` | G | 0-1 | — | `IBSCBS` |
| 1094 | 324.17 | `vIBSEstCred` | Numérico | 1-1 | 15,2 | `gEstornoCred` |
| 1095 | 324.18 | `vCBSEstCred` | Numérico | 1-1 | 15,2 | `gEstornoCred` |
| 1096 | — | `--gEstornoCred_fim--;` | — | — | — | `IBSCBS` |
| 1097 | 324119 | `--sequencia_XML_cred_pres_ini--;` | G | 0-1 | — | `IBSCBS` |
| 1098 | 324.120 | `--gCredPresOper_ini--;` | CG | 1-1 | — | `sequencia_XML_cred_pres` |
| 1099 | 324121 | `vBCCredPres` | Numérico | 1-1 | 15,2 | `gCredPresOper` |
| 1100 | 324122 | `cCredPres` | Numérico | 1-1 | 2 | `gCredPresOper` |
| 1101 | 324.123 | `--gIBSCredPres_ini--;` | — | 0-1 | — | `gCredPresOper` |
| 1102 | 324124 | `pCredPres` | Numérico | 1-1 | 7,2-4 | `gIBSCredPres` |
| 1103 | 324125 | `vCredPres` | Numérico | 1-1 | 15,2 | `gIBSCredPres` |
| 1104 | 324126 | `vCredPresCondSus` | Numérico | 1-1 | 15,2 | `gIBSCredPres` |
| 1106 | 324.127 | `--gCBSCredPres_ini--;` | — | 0-1 | — | `gCredPresOper` |
| 1107 | 324128 | `pCredPres` | Numérico | 1-1 | 7,2-4 | `gCBSCredPres` |
| 1108 | 324129 | `vCredPres` | Numérico | 1-1 | 15,2 | `gCBSCredPres` |
| 1109 | 324130 | `vCredPresCondSus` | Numérico | 1-1 | 15,2 | `gCBSCredPres` |
| 1111 | — | `--gCredPresOper_fim--;` | — | — | — | `sequencia_XML_cred_pres` |
| 1112 | 324.131 | `--gCredPresIBSZFM_ini--;` | CG | 1-1 | — | `sequencia_XML_cred_pres` |
| 1113 | 324132 | `competApur` | Caractere | 1-1 | 7 | `gCredPresIBSZFM` |
| 1114 | 324133 | `tpCredPresIBSZFM` | Numérico | 1-1 | 1 | `gCredPresIBSZFM` |
| 1115 | 324134 | `vCredPresIBSZFM` | Numérico | 1-1 | 15,2 | `gCredPresIBSZFM` |
| 1117 | — | `--sequencia_XML_cred_pres_fim--;` | — | — | — | `IBSCBS` |
| 1228 | 355.29e | `--gEstornoCred_ini--;` | Grupo | 0-1 | — | `IBSCBSTot` |
| 1229 | 355.29f | `vIBSEstCred` | Numérico | 1-1 | 15,2 | `gEstornoCred` |
| 1230 | 355.29g | `vCBSEstCred` | Numérico | 1-1 | 15,2 | `gEstornoCred` |
| 1231 | — | `--gEstornoCred_fim--;` | — | — | — | `IBSCBSTot` |
| 1234 | 326a | `vProdLiqTot` | Numérico | 0-1 | 15,2 | `total` |
| 1322 | 398.50 | `--gPgtoVinc_ini--;` | — | 0-1 | — | `nota` |
| 1323 | 398.51 | `--gPgto_ini--;` | — | 1-99 | — | `gPgtoVinc` |
| 1324 | 398.52 | `nPag` | Numérico | 1-1 | 3 | `gPgto` |
| 1325 | 398.53 | `idTransacao` | Caractere | 1-1 | 2-35 | `gPgto` |
| 1326 | 398.54 | `tpMeioPgto` | Numérico | 1-1 | 2 | `gPgto` |
| 1327 | 398.55 | `CNPJReceb` | Caractere | 1-1 | 14 | `gPgto` |
| 1328 | 398.56 | `CNPJBasePSP` | Caractere | 1-1 | 8 | `gPgto` |
| 1329 | — | `--gPgto_fim--;` | — | — | — | `gPgtoVinc` |
| 1330 | — | `--gPgtoVinc_fim--;` | — | — | — | `nota` |

### A.2 Linhas removidas ou renomeadas (54)

Existem na 4.16 e não na 4.19, pelo par (posição, tag). A numeração `Nº 4.16` refere-se à sequência do TXT **na aba 4.16**.

| Nº 4.16 | Pos. 4.16 | Tag / Campo |
|---:|---|---|
| 53 | 29f | `--gCompraGov_ini--;` |
| 54 | 29f.1 | `tpEnteGov` |
| 55 | 29f.2 | `pRedutor` |
| 56 | 29f.3 | `tpOperGov` |
| 568 | 239.0 | `--sequencia_XML_ini--;` |
| 569 | 239.w | `vBCFCP` |
| 570 | 239.x | `pFCP` |
| 571 | 239.y | `vFCP` |
| 590 | 245.1a | `indDeduzDeson` |
| 876 | 324.07 | `pISEspec` |
| 887 | 324.14a | `--sequencia_XML_IBSCBS_ini--;` |
| 894 | 324..21 | `--gDif_ini--;` |
| 896 | 324..23 | `vDif` |
| 899 | 324..25 | `vDevTrib` |
| 902 | 324..27 | `pRedAliq` |
| 903 | 324..28 | `pAliqEfet` |
| 946 | 324.73 | `--gIBSCredPres_ini--;` |
| 947 | 324.74 | `cCredPres` |
| 948 | 324.75 | `pCredPres` |
| 949 | 324.76 | `vCredPres` |
| 950 | 324.77 | `vCredPresCondSus` |
| 952 | 324.78 | `--gCBSCredPres_ini--;` |
| 953 | 324.79 | `cCredPres` |
| 954 | 324.80 | `pCredPres` |
| 955 | 324.81 | `vCredPres` |
| 956 | 324.82 | `vCredPresCondSus` |
| 968 | 324.84a | `--gMonoPadrao_ini--;` |
| 969 | 324.85 | `qBCMono` |
| 970 | 324.86 | `adRemIBS` |
| 971 | 324.87 | `adRemCBS` |
| 972 | 324.88 | `vIBSMono` |
| 973 | 324.89 | `vCBSMono` |
| 975 | 324.90 | `--gMonoReten_ini--;` |
| 976 | 324.91 | `qBCMonoReten` |
| 977 | 324.92 | `adRemIBSReten` |
| 978 | 324.93 | `vIBSMonoReten` |
| 979 | 324.93a | `adRemCBSReten` |
| 980 | 324.93b | `vCBSMonoReten` |
| 982 | 324.94 | `--gMonoRet_ini--;` |
| 983 | 324.95 | `qBCMonoRet` |
| 984 | 324.96 | `adRemIBSRet` |
| 985 | 324.97 | `vIBSMonoRet` |
| 986 | 324.98 | `adRemCBSRet` |
| 989 | 324.99 | `--gMonoDif_ini--;` |
| 990 | 324100 | `pDifIBS` |
| 991 | 324101 | `vIBSMonoDif` |
| 992 | 324102 | `pDifCBS` |
| 993 | 324103 | `vCBSMonoDif` |
| 994 | — | `--gMonoDif_fim--;` |
| 995 | 324104 | `vTotIBSMonoItem` |
| 996 | 324105 | `vTotCBSMonoItem` |
| 1002 | 324.109 | `--gCredPresIBSZFM_ini--;` |
| 1003 | 324110 | `tpCredPresIBSZFM` |
| 1004 | 324.111 | `vCredPresIBSZFM` |

---

## 10. Síntese da validação

| Resultado | Quantidade | Detalhe |
|---|---|---|
| Afirmações do `Leiaute_Mastersaf_4_19.md` **confirmadas** pela planilha | 11 de 16 | itens 1–8, 11, 14, 15 da tabela 4.1 |
| Confirmadas **com ressalva ou complemento** | 5 de 16 | itens 9, 10, 12, 13, 16 — ver 4.2-A, 4.2-B e 4.2-C |
| Afirmações **incorretas** | 0 | nenhuma divergência factual encontrada |
| Deslocamento de referência | 1 | todos os números de linha do documento anterior equivalem a `Nº` − 1 (ver 1.1) |
| Lacunas de escopo (itens da 4.19 ausentes do documento anterior) | 8 | seção 5 |
| Pontos do código a validar / ajustar | 4 | `DHL_NFE_LAYOUT` (4.16 → 4.19), nível do `gEstornoCred` do item, monofásico reformulado, `gPgtoVinc` |

**Conclusão.** O `Leiaute_Mastersaf_4_19.md` está **factualmente correto** em tudo o que afirma sobre o pacote da NT 2026.008 — as seis correções que ele declara aplicadas conferem com a planilha e com o código. O que ele não cobre é o **restante** da 4.19: a reformulação do monofásico de combustíveis (NT 2025.002-RTC v1.50/v1.51), o `gPgtoVinc` (NT 2026.006) e as renumerações de `gCompraGov` e do crédito presumido. Como o campo `versaoLayoutDFe` é uma declaração de conformidade com o leiaute **inteiro**, esses itens entram no escopo no momento em que `DHL_NFE_LAYOUT` for alterado para `"4.19"` — e não antes. Há ainda a questão de escopo normativo levantada em 4.2-D: se o alvo do projeto é a NT 2025.002-RTC **v1.53**, a 4.19 não a declara.

---

### Procedência dos dados

Toda a seção 2 e as seções 6 a 9 foram extraídas programaticamente da aba `Envio NFe_NFCe - 4.00 -DFe 4.19` (1.883 linhas no Excel, das quais 1.399 contêm leiaute, nas linhas 13 a 1.411). As seções 1.3, 3 e os textos citados entre aspas são transcrições literais da planilha (linha 6 da aba de envio e entradas 55 a 66 da aba `Alterações`). As referências a código foram conferidas diretamente nos fontes em 27/11/2026.
