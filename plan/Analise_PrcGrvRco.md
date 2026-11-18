# Análise técnica: PrcGrvRco.prw

- **Fonte:** [Workspace_Protheus_Prd_20260707/PROTHEUS/Producao/SAP/SCJ/PrcGrvRco.prw](../Workspace_Protheus_Prd_20260707/PROTHEUS/Producao/SAP/SCJ/PrcGrvRco.prw)
- **Função:** `U_PrcGrvRco()`, que faz o processamento final da NF RCO (Remessa por Conta e Ordem) da interface SAP/SCJ
- **Chamador:** [PrcNfRco.prw:114](../Workspace_Protheus_Prd_20260707/PROTHEUS/Producao/SAP/SCJ/PrcNfRco.prw#L114)
- **Data da análise:** 16/11/2026
- **Escopo:** somente leitura. Nenhuma alteração foi feita no código.

---

## Fluxo principal em 5 passos

### 1. Entrada: recebe o contexto já pronto, sem parâmetros
Quem chama é o `PrcNfRco`, logo depois que a NF de saída foi gerada pelo `execRCO`. Quando ele chega aqui, três coisas já precisam estar prontas:
- `SF2` posicionada na NF RCO recém-gerada;
- `SZA` posicionada no cabeçalho da interface SAP/SCJ (o campo `ZA_KENFSCJ` é a chave);
- `oIp040`, uma variável **Private** criada em [PrcNfRco.prw:27](../Workspace_Protheus_Prd_20260707/PROTHEUS/Producao/SAP/SCJ/PrcNfRco.prw#L27).

As linhas 17 a 34 só copiam esses dados para variáveis locais.

### 2. Leitura e validação dos itens da interface (SZB)
Nas linhas 50 a 54, o fonte busca os itens (`getItensSZB`) e os itens agrupados por CFOP/alíquota (`getGroupSZB`), e roda `validValues`.
- Se a validação falha, cai no `Else` (linhas 317 a 321). Ali grava só o vínculo mínimo e retorna `.F.`. O chamador então faz `DisarmTransaction()` e a NF inteira é desfeita.

### 3. ICMS desonerado / Suframa (só quando `ZA_ICMSDES == 'S'`)
São as linhas 60 a 160. A ordem é:
- item a item: atualiza `SD2`, `SFT` e `CD2` com os valores da SZB (total, preço, `DESCZFR`, valor bruto/contábil);
- por CFOP/alíquota: atualiza a `SF3`;
- por último, o cabeçalho `SF2`: `F2_DESCZFR`, ICMS zerado e `F2_VALMERC`.

### 4. Complementos da NF
São as linhas 285 a 302:
- grava o vínculo `SZA` ↔ NF (`ZA_NFRCO` e `ZA_SERIRCO`);
- grava os dados de transporte e de tipo na `SF2` (placa, transportadora, volume, `F2_ZZTPNF`, hora);
- `fGravaMsg`: grava as mensagens da NF na `SZZ`, códigos 901 (mensagem adicional), 902 (NF de venda do depositante) e 903 (pedidos do cliente);
- `fAtuSf3`: marca `F3_REPROC = 'N'`.

### 5. Saída: XML da NF-e e retorno
São as linhas 306 a 316. Chama `U_PrcXmlNfe`, que gera o arquivo para o Mastersaf. Se a série estiver no parâmetro `ZZ_SERCONT`, também chama `u_PrcConti` (contingência). Esse passo é pulado quando a execução vem do `u_ImpMsaNfe`. No fim, devolve `lRet` para o `PrcNfRco`.

---

## O que não pode ser alterado sem quebrar

| # | O quê | Por quê |
|---|---|---|
| 1 | **Nome `U_PrcGrvRco`** | O [nfesefaz.prw:3026](../Workspace_Protheus_Prd_20260707/PROTHEUS/Producao/Mastersaf_NFe/nfesefaz.prw#L3026) e a linha 3488 do mesmo arquivo testam `IsInCallStack("U_PrcGrvRco")` para mudar o XML da unidade AG2. Se renomear a função ou chamar a geração do XML por fora dela, o XML sai diferente sem nenhum erro aparecer. |
| 2 | **`oIp040` não declarado** | Ele é Private do chamador. Se alguém declarar `Local oIp040` aqui, ou chamar `U_PrcGrvRco()` isoladamente, a rotina quebra. O mesmo vale para `SF2` e `SZA`: o fonte supõe que já estão posicionadas e não faz seek nelas. |
| 3 | **Valor de retorno (`lRet`)** | Um `.F.` faz o chamador executar `DisarmTransaction`. Qualquer `return .F.` novo desfaz a NF inteira. Um `.T.` indevido mantém uma NF inconsistente. Atenção: o que o bloco `Else` grava também é desfeito por esse rollback. |
| 4 | **`PrcXmlNfe` tem que ser o último passo** | O próprio comentário das linhas 304 e 305 diz isso. Tudo que for gravado depois dele não entra no XML enviado ao Mastersaf/SEFAZ. |
| 5 | **Chaves de `DbSeek` e índices em `openTables`** | A SD2 usa a ordem 3, com `ZB_LINITEM` completado com zeros à esquerda até 2 posições. Isso depende do tamanho de `D2_ITEM`. A SF3 usa a ordem 1, com `cCfop` mais `str(aliq,5,2)`, e a regra de "6" + CFOP para operação fora do estado. Se mudar o índice ou o formato, o seek falha e o ajuste não é aplicado, também sem erro. |
| 6 | **A conta da desoneração (SD2/SFT/CD2/SF3/SF2)** | Os valores precisam fechar entre item, livro fiscal e cabeçalho, porque vão para SPED e apuração. Mexer em uma tabela sem mexer nas outras gera divergência fiscal. |
| 7 | **`F3_REPROC = 'N'`** | É isso que impede o reprocessamento fiscal padrão de recalcular a SF3 e apagar os ajustes manuais da desoneração. Se tirar, o ajuste some no primeiro reprocessamento. |
| 8 | **Valores fixos na SF2** | `F2_ZZTPNF = REMESSA_CONTA_ORDEM` (constante do `dhl.ch`), placa `DHL1234`/`SP` e `F2_TPFRETE = "T"`. Provavelmente são usados por filtros, pelo XML e por relatórios. Antes de mexer, procure quem lê esses campos. |
| 9 | **Encoding do arquivo** | O arquivo está em Windows-1252. Se o editor salvar em UTF-8, os acentos das mensagens da NF quebram. |

---

## Comportamentos atuais estranhos (não corrigir sem alinhar com o fiscal)

- **SF3 com mais de um CFOP/alíquota** (linhas 134 e 135): `nTotDesZfr` é o total da nota inteira. Por isso, cada linha de CFOP/alíquota recebe a desoneração total, e não a sua parte.
- **Falha de seek não aborta nada:**
  - `nTotDesZfr` soma o item mesmo quando o seek dele falhou (linha 108);
  - a `SF2` é atualizada mesmo com `lOkPos = .F.` (linha 152);
  - `lOkPos = .F.` não muda o `lRet`.

  Na prática, uma falha de seek gera uma NF parcialmente ajustada, sem nenhum alerta.
- **`lReturn` não declarado** (linha 310): o retorno do `PrcXmlNfe` é ignorado.
- **Bloco comentado "LÓGICA DO IVAN"** (linhas 162 a 278): é código morto, uma versão anterior da mesma regra. Serve só como histórico.
