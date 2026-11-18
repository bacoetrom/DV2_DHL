# Dimensionamento dos forks: ProcRCOMsa e nfesefaz

- **Data:** 18/11/2026
- **Objetivo:** medir o custo real de replicação das Fases 1 e 2 (fork `ProcRCOMsa`) e do remerge da Fase 0, item 2 (fork `nfesefaz`)
- **Gerado por:** `scratchpad/depara_fork.py` (reprodutível) e inspeção direta
- **Resultado:** **os dois forks são bem menores do que a contagem bruta de linhas sugeria.** Este documento corrige para baixo as duas estimativas.

---

## 1. Fork ProcMsaNFe.prw × ProcRCOMsa.prw

Comparação função por função, com o corpo normalizado (linhas vazias e comentários de linha inteira removidos).

| Classificação | Funções | % |
|---|---|---|
| **IGUAL** — alteração replica 1:1 | 233 | 94% |
| **DIVERGENTE** — exige análise dos dois lados | 4 | 2% |
| Só no `ProcMsaNFe` | 1 | 0% |
| Só no `ProcRCOMsa` | 9 | 4% |
| **Total** | **247** | 100% |

### 1.1 As 4 funções divergentes

| Função | Linha NFe | Linha RCO | Natureza da divergência |
|---|---|---|---|
| `MountTags` | 63 | 63 | orquestrador; o RCO acrescenta as tags próprias do fluxo SAP |
| `DoDetProd` | 3802 | 3807 | **uma linha**: o RCO chama `DoPedidoCliente()` depois de `DovItem()` |
| `DoInfNFe` | 175 | 179 | 9 linhas em cada, diferença pontual |
| `DoSICM15` | 5125 | 5130 | 12 linhas em cada, diferença pontual |

### 1.2 As funções exclusivas

- **Só no `ProcMsaNFe`:** apenas o ponto de entrada `ProcMsaNFe`.
- **Só no `ProcRCOMsa`:** o ponto de entrada `ProcRCOMsa` e 8 funções específicas do fluxo SAP/RCO, todas no fim do arquivo (linhas 5148-5312): `DoShipment`, `DoKeySCJ`, `DoDeliveryNumber`, `getShipment`, `getChvNFOrig`, `getDelivery`, `DoPedidoCliente`, `getPOCustomer`.

### 1.3 Situação das funções-alvo das Fases 1 e 2

| Função | Situação no fork |
|---|---|
| `getFinNfe` | IGUAL — replica 1:1 |
| `DoIde` | IGUAL — replica 1:1 |
| `DoProd` | IGUAL — replica 1:1 |
| `DoTotal` | IGUAL — replica 1:1 |
| `DoAllRef` | IGUAL — replica 1:1 |
| `DoIBSCBS` | IGUAL — replica 1:1 |
| `DoIBSCBSTot` | IGUAL — replica 1:1 |
| `DoDetPag` | IGUAL — replica 1:1 |
| `DovItem` | IGUAL — replica 1:1 |
| `DovNFTot` | IGUAL — replica 1:1 |

**Todas as 10 funções que as Fases 1 e 2 alteram são idênticas nos dois fontes.**

### 1.4 Conclusão — correção da estimativa

A leitura inicial de que "as Fases 1 e 2 dobram de tamanho, somando ~5.500 linhas" estava **errada, pessimista**. O correto:

- a replicação das Fases 1 e 2 é **mecânica**, não exige reanálise — exatamente o caso previsto na regra 5 da convenção de marcação (mesmo marcador, mesma data);
- o custo adicional real está em **`DoDetProd`** (divergente e dentro do escopo da Fase 2 por tratar do item) e em `MountTags` (divergente e orquestrador, portanto afetado por qualquer grupo novo);
- `DoInfNFe` e `DoSICM15` divergem mas estão fora do escopo das Fases 1 e 2.

Prática recomendada: aplicar no `ProcMsaNFe`, validar, e replicar com `diff` dirigido nas 233 funções idênticas, tratando `MountTags` e `DoDetProd` manualmente.

---

## 2. Fork nfesefaz.prw

14.762 linhas. A contagem bruta de ~100 linhas datadas/assinadas incluía comentários de histórico comuns a qualquer fonte. A **superfície real de customização** é bem menor.

### 2.1 Onde a customização está concentrada

| Função | Pontos de customização |
|---|---|
| `User Function XmlNfeSef` | 13 |
| `Static Function NfeItem` | 7 |
| `Static Function NfeInfAd` | 4 |
| `Static Function DadNfVinc` | 1 |
| **Total** | **25, em 4 funções** |

### 2.2 Gatilhos usados

| Gatilho | Ocorrências |
|---|---|
| `FWUnitBusiness` | 13 |
| `GetNewPar("ZZ_...")` | 8 |
| `IsInCallStack` | 4 |
| `SuperGetMv("ZZ_...")` | 4 |

### 2.3 Desvios por unidade de negócio

| Unidade | Desvios |
|---|---|
| AG2 | 8 |
| PKG | 4 |
| DIS | 3 |
| SPL | 2 |
| AGL | 2 |
| MUL | 1 |

### 2.4 Conclusão — o remerge é tratável

Com 25 pontos concentrados em 4 funções, o remerge deixa de ser um bloco opaco de 14.762 linhas e passa a ser um trabalho delimitado. Isso **favorece a terceira alternativa** registrada na Fase 0, item 2: adotar o fonte padrão da release-alvo e reaplicar os 25 pontos, em vez de remergear o fork inteiro.

Restrição que permanece obrigatória: os 4 `IsInCallStack` — dois deles (`U_PrcGrvRco` e `U_PrcNfRco`, linhas 3026 e 3488) alteram o XML da AG2 e não têm equivalente no padrão.

Ressalva: a contagem mede **pontos marcados**. Alterações feitas no código padrão sem marcador não aparecem aqui e só o diff contra o fonte padrão da release-alvo revela. Este dimensionamento reduz a incerteza, não a elimina.

---

## 3. Regra de conversão entre o XML oficial e o XML intermediário da TOTVS

> **Correção de 18/11/2026.** A primeira versão desta seção classificou a diferença entre os dois XMLs como bloqueio. **Estava errada.** A diferença existe, mas é uma transformação mecânica e já implementada no fonte, o que torna os caminhos de leitura **deriváveis do `HTMLConsolidado.xml`**. O texto abaixo substitui a conclusão anterior.

### 3.1 A regra

O `retValTax()` (`ProcMsaNFe.prw`) monta o caminho assim:

```advpl
cTagValue := "oTagImp:_" + cNode + ":_" + cTag + ":text"
```

onde `oTagImp` é a entrada de `oDetProd:_imposto[n]` cujo `_codigo:text` é igual ao tributo procurado (`cTax`).

**Regra de conversão:** no caminho do XML oficial, substitua `det/imposto/<TRIBUTO>` por `tributo` e junte os níveis com `:_`. Abaixo do nó `Tributo`, a estrutura é **idêntica à do XML oficial**.

Validação da regra contra caminhos já em produção:

| XML oficial | `cNode` | `cTag` |
|---|---|---|
| `det/imposto/IBSCBS/cClassTrib` | `"tributo"` | `cClassTrib` |
| `det/imposto/IBSCBS/gIBSCBS/gIBSUF/gRed/pRedAliq` | `"tributo:_gIBSCBS:_gIBSUF:_gRed"` | `pRedAliq` |
| `det/imposto/IBSCBS/gIBSCBS/gIBSMun/gDevTrib/vDevTrib` | `"tributo:_gIBSCBS:_gIBSMun:_gDevTrib"` | `vDevTrib` |
| `det/imposto/IBSCBS/gIBSCBS/gTribRegular/cClassTribReg` | `"tributo:_gIBSCBS:_gTribRegular"` | `cClassTribReg` |

Níveis **fora** de `imposto` não sofrem transformação alguma — `det/prod/*` é `oDetNfe:_prod:_*` e `total/*` é `infNfe:_total:_*`, como o fonte já faz para `vProd` e `IBSCBSTot`.

### 3.2 Caminhos derivados para as 11 tags ausentes

| Tag | XML oficial | Caminho no XML intermediário | Confiança |
|---|---|---|---|
| `vUnComLiq` | `det/prod/vUnComLiq` | `oDetNfe:_prod:_vUnComLiq` | alta — sem transformação |
| `vProdLiq` | `det/prod/vProdLiq` | `oDetNfe:_prod:_vProdLiq` | alta — sem transformação |
| `vProdLiqTot` | `total/vProdLiqTot` | `infNfe:_total:_vProdLiqTot` | alta — sem transformação |
| `ISTot` | `total/ISTot` | `infNfe:_total:_ISTot` | alta — sem transformação |
| `DFeReferenciado` | `det/DFeReferenciado` | `oDetNfe:_DFeReferenciado` | alta — nível `det`, sem transformação |
| `chaveAcesso` | `det/DFeReferenciado/chaveAcesso` | `oDetNfe:_DFeReferenciado:_chaveAcesso` | alta |
| `gAjusteCompet` | `det/imposto/IBSCBS/gAjusteCompet` | `cTax="IBSCBS"`, `cNode="tributo:_gAjusteCompet"` | alta — regra 3.1 |
| `gEstornoCred` | `det/imposto/IBSCBS/gEstornoCred` | `cTax="IBSCBS"`, `cNode="tributo:_gEstornoCred"` | alta — regra 3.1 |
| `ICMSPrevistoPagtoAntecip` | `det/imposto/ICMS/ICMSPrevistoPagtoAntecip` | `cTax="ICM"`, `cNode="tributo:_ICMSPrevistoPagtoAntecip"` | média — depende do `codigo` do ICMS |
| `vICMSPrevisto` | `.../vICMSPrevisto` | `cTag="vICMSPrevisto"` | média — idem |
| `IS` | `det/imposto/IS` | `cTax=<codigo do IS>`, `cNode="tributo"` | média — **o `codigo` do IS é o único desconhecido real** |

### 3.3 O único desconhecido que resta

Não é a estrutura: é o **valor de `codigo`** que a TOTVS usará para identificar o Imposto Seletivo na coleção `imposto[n]` (`"IS"`, `"ISE"`, `"ISEL"`…), e a confirmação do código do ICMS (`"ICM"`, usado hoje).

Isso **não justifica parar o desenvolvimento**. A solução é a mesma que o projeto já usa para os tributos da F2D no `DHLIdManager.prw` (`ZZ_TRIBSUF`, `ZZ_TRIBSMU`, `ZZ_TRIBCBS`): parametrizar. Criar `ZZ_TRIBIS` com default `"IS"` e ajustar o parâmetro quando a inspeção do XML confirmar — sem recompilar.

### 3.4 O que isto libera e o que continua bloqueado

**Liberado:** toda a lógica de **leitura** do XML nas Fases 1 e 2, e a rotina de auditoria de tags da Fase 0, item 1.

**Continua dependente do leiaute do Mastersaf:** apenas a **ordem e a posição** no TXT, porque o `writeTag()` grava um valor por linha na ordem das chamadas de `setAttributeValue`. Em detalhe:

- **Grupo novo** (`IS`, `gAjusteCompet`, `gEstornoCred`, `DFeReferenciado`): é delimitado pelos próprios `--<nome>_ini--`/`--<nome>_fim--`, então o Mastersaf o localiza pelo marcador. Faltam o nome exato do marcador, a ordem dos campos dentro do grupo e a posição do grupo entre os irmãos.
- **Campo dentro de grupo existente** (`vUnComLiq`/`vProdLiq` no `prod`, `vProdLiqTot` no `total`): a posição é tudo — offset errado desloca todos os campos seguintes daquele grupo.

**Consequência prática:** o código pode ser escrito agora, com os campos na **ordem em que a NT os documenta** (hipótese de trabalho, porque leiautes Mastersaf costumam espelhar a sequência da NT). Quando o leiaute chegar, o ajuste é **reordenar linhas adjacentes**, não reescrever.

### 3.5 Anexo — a diferença estrutural, para registro

**XML oficial da NF-e** (`HTMLConsolidado.xml`, o que vai para a SEFAZ):

```
det/imposto/IBSCBS/{CST, cClassTrib, gIBSCBS/{vBC, gIBSUF, gIBSMun, vIBS, gCBS}}
```

**XML intermediário da TOTVS** (o que o `XmlNfeSef` produz e o `ProcMsaNFe` navega):

```
det/imposto[n]/{codigo, Tributo/{CST, gIBSCBS/vBC, ...}}
```

É uma **coleção genérica de impostos**, identificada por `codigo`, coerente com a estrutura do Configurador de Tributos (a mesma lógica da F2D). O envelope difere; o conteúdo abaixo de `Tributo` não.

**XML oficial da NF-e** (`HTMLConsolidado.xml`, o que vai para a SEFAZ):

```
det/imposto/IBSCBS/{CST, cClassTrib, gIBSCBS/{vBC, gIBSUF, gIBSMun, vIBS, gCBS}}
```

**XML intermediário da TOTVS** (o que o `XmlNfeSef` produz e o `ProcMsaNFe` navega):

```
det/imposto[n]/{codigo, Tributo/{CST, gIBSCBS/vBC, ...}}
```

É uma **coleção genérica de impostos**, identificada por `codigo`, coerente com a estrutura do Configurador de Tributos (a mesma lógica da F2D). Evidência: `ProcMsaNFe.prw` lê `oDetNfe:_imposto[nJ]:_codigo:text` e `oDetNfe:_imposto[nJ]:_Tributo:_gIBSCBS:_vBC:text`.

Consequências:

1. **`HTMLConsolidado.xml` não serve como fonte dos caminhos de leitura.** Ele dá o leiaute de saída, não a estrutura de entrada que o `ProcMsaNFe` precisa navegar. Serve para saber **quais** tags são exigidas (ver `Inventario_Tags_NFe_2027.md`), não **onde** lê-las.
2. **O mapeamento das Fases 1 e 2 depende de um insumo que ainda não existe:** a estrutura intermediária da TOTVS para as tags novas. Como o fork do `nfesefaz` não gera nenhuma delas, essa estrutura não pode ser observada hoje.
3. **A inspeção da Fase 0, item 1, tem dois objetivos, não um.** Além de confirmar a presença das tags, ela precisa **capturar a estrutura intermediária** de cada grupo novo. Sem isso, qualquer caminho escrito nas Fases 1 e 2 é suposição.

Por esse motivo, a rotina de auditoria de tags prevista na Fase 0, item 1, **foi iniciada e interrompida**: os caminhos de nível documento (`infnfe:_total:_ISTot`, `infnfe:_total:_vProdLiqTot`) são seguros por analogia direta com o `infNfe:_total:_IBSCBSTot` já validado, mas os de nível item (IS, `gAjusteCompet`, `gEstornoCred`, `DFeReferenciado`, `vProdLiq`, `vUnComLiq`) dependem da estrutura genérica `imposto[n]/Tributo`, cuja forma para as tags novas é desconhecida. Entregar a rotina com caminhos supostos produziria relatórios de "tag ausente" falsos — pior que não ter a rotina.
