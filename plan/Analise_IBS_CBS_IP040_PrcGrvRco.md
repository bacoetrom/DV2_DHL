# Análise IBS/CBS: interface IP040 e NF RCO (desoneração ZFM)

- **Data:** 16/11/2026
- **Escopo:** somente análise, sem nenhuma alteração nos fontes.
- **Fontes analisados:**
  - `Workspace_Protheus_Prd_20260707/PROTHEUS/Producao/SAP/SCJ/Classes/DHLIp040Sap.prw`
  - `Workspace_Protheus_Prd_20260707/PROTHEUS/Producao/SAP/SCJ/PrcGrvRco.prw`

> Observação: os dois fontes estão gravados em Windows-1252, e não em UTF-8. Qualquer ajuste futuro precisa manter essa codificação.

---

## 1. Pendência: "A interface IP040 já tem campos de IBS/CBS na SZB. Confirmar que vêm preenchidos e batem com a F2D."

### O que a pendência pede

1. **Os campos vêm preenchidos?** Confirmar se o SAP manda os valores de IBS/CBS no arquivo da IP040 e se eles chegam gravados na SZB, ou se chegam zerados.
2. **Os valores batem com a F2D?** A F2D é a tabela onde o Protheus grava, por item, os tributos calculados pelo Configurador de Tributos (é ali que fica o IBS/CBS). É preciso conferir se o que o SAP mandou na SZB é igual ao que o Protheus calculou para a mesma nota e item.

### Campos (DHLIp040Sap.prw, linhas 15-18)

| Grupo | Campos | Conteúdo |
|---|---|---|
| IBS estadual | `ZB_IBSUFTX`, `ZB_IBSUFBS`, `ZB_IBSUFVL` | alíquota, base, valor |
| IBS municipal | `ZB_IBSMUTX`, `ZB_IBSMUBS`, `ZB_IBSMUVL` | alíquota, base, valor |
| CBS | `ZB_CBSTXRT`, `ZB_CBSTXBS`, `ZB_CBSTXVL` | alíquota, base, valor |

### Situação do código

- As constantes `FIELDS_IBS_UF`, `FIELDS_IBS_MUN` e `FIELDS_CBS` são declaradas, mas **nenhum trecho do fonte as usa**.
- O método `validValues` (linhas 321-446) percorre o de-para da SZD (`::aFieldsSZB`) e só sincroniza o valor do SAP com o Protheus nestes destinos:
  - **SD2 / SFT / SB1** (linha 351): copia o campo quando o valor é diferente.
  - **CD2** (linha 363): só para ICMS (`ICM`), ICMS-ST (`SOL`), DIFAL (`CMP`) e Suframa (`ZFM`). **Não existe tratamento para IBS ou CBS.**
  - **SF3** (linha 422): valores agrupados por CFOP e alíquota.
- **Não existe tratamento para F2D.** Um de-para `ZB_IBS*` → `F2D_*` cadastrado na SZD cai fora de todos os `If/ElseIf` e é ignorado sem nenhum aviso.

**Conclusão:** hoje o IBS/CBS da nota é só o que o Protheus calcula. O valor do SAP fica guardado na SZB sem ser usado nem comparado.

### Como validar

1. Selecionar notas processadas pela IP040 e consultar a SZB pela chave `ZB_KENFSCJ` para ver se os 9 campos estão preenchidos.
2. Para os mesmos documentos e itens, comparar base, alíquota e valor de cada tributo (IBS estadual, IBS municipal e CBS) entre a SZB e a F2D.
3. Interpretar o resultado:
   - **Valores iguais:** não é preciso fazer nada por enquanto.
   - **Valores diferentes:** decidir se o Protheus deve aceitar o valor do SAP (como já faz com o ICMS na CD2) ou só registrar a divergência. Nos dois casos seria preciso evoluir o `validValues` com um tratamento para a F2D.
   - **Campos vazios na SZB:** a pendência é do lado do SAP ou da carga da interface, não deste fonte.

---

## 2. Pendência: "Reescreve FT_TOTAL, FT_VALCONT, CD2 e SF3 depois do cálculo (desoneração ZFM) e não ajusta a F2D: conferir se a base de IBS/CBS continua certa."

**Conclusão:** a pendência procede. No caminho de desoneração ZFM, o `PrcGrvRco.prw` muda os valores da nota depois que o cálculo fiscal já foi feito e não recalcula nem ajusta a F2D. Por isso a base de IBS/CBS pode ficar diferente do valor final do item.

### Ordem de execução

O fonte roda no final da geração da nota de saída (ponto de entrada M460FIM). Nesse momento o Protheus já calculou os impostos, inclusive IBS/CBS, e gravou o resultado na F2D.

1. **Linha 54:** `oIp040:validValues(...)` aplica o de-para da SZD nas tabelas SD2, SFT, CD2 e SF3. Não existe tratamento para a F2D (ver item 1).
2. **Linhas 60 a 158:** só entram aqui as notas com ICMS desonerado (`ZA_ICMSDES == 'S'`). O fonte grava valores fixos direto nas tabelas, com `RecLock`:

| Tabela | Campos regravados (linha) | Regra |
|---|---|---|
| SD2 | `D2_TOTAL`, `D2_PRCVEN`, `D2_DESCZFR`, `D2_VALBRUT` (78-81) | `ZB_TOTVLIT - ZB_VLDIICM` |
| SFT | `FT_TOTAL`, `FT_VALCONT`, `FT_ISENICM`, `FT_PRCUNIT`, `FT_BSICMOR` (86-91) | idem, mais o ICMS-ST |
| CD2 | `CD2_DESONE`, só no registro `SOL` (95-98) | `ZB_VLDIICM` |
| SF3 | `F3_VALOBSE`, `F3_DESCZFR`, `F3_VALCONT`, e `F3_VALICM`/`F3_BASEICM`/`F3_ISENICM` zerados (134-140) | totais da nota |
| SF2 | `F2_DESCZFR`, `F2_VALMERC`, e `F2_VALICM`/`F2_BASEICM` zerados (154-157) | totais da nota |
| **F2D** | **nenhum campo** | — |

3. **Linhas 306 a 315:** no final, `U_PrcXmlNfe` gera o arquivo da NF-e para o Mastersaf, já com os valores regravados.

### Onde está o risco

A base de IBS/CBS na F2D foi calculada com o valor do item **antes** da regravação. Depois disso:

- o valor do item passa a ser `ZB_TOTVLIT - ZB_VLDIICM`, ou seja, o desconto ZFM é abatido;
- o ICMS fica zerado na SF2 e na SF3;
- a F2D continua com a base, a alíquota e o valor antigos.

**Exemplo de um item:**

- `ZB_TOTVLIT` = 1.000 e `ZB_VLDIICM` = 120
- `D2_TOTAL` e `FT_TOTAL` passam a ser 880
- se o cálculo padrão tiver usado outro valor (1.000, ou 1.000 menos o ICMS calculado pelo Protheus), a base de IBS/CBS na F2D não corresponde aos 880 que vão no item

**Isso pode causar:**

- **XML inconsistente:** se o `PrcXmlNfe` ou o Mastersaf montar o grupo de IBS/CBS a partir da F2D, a nota sai com `vProd`/`vDesc` coerentes com 880 e a base de IBS/CBS coerente com o valor antigo;
- **apuração e escrituração divergentes:** os livros (SF3/SFT) refletem os valores regravados, enquanto IBS/CBS refletem o cálculo original.

O nome "desoneração ZFM" sugere Zona Franca de Manaus. Pela Reforma, a ZFM tem regras próprias de IBS/CBS (por exemplo, redução ou crédito presumido). Com isso, a base "certa" para essas notas é uma definição do fiscal, não só uma questão de técnica.

### Pontos secundários do mesmo trecho

- **Linha 108:** `nTotDesZfr` soma `ZB_VLDIICM` mesmo quando o item não é encontrado na SD2/SFT (`lOkPos = .f.`).
- **Linhas 153-158:** a SF2 é regravada mesmo que `lOkPos` seja falso, ou seja, mesmo que a SF3 não tenha sido encontrada.
- **Linha 157:** `F2_VALMERC` é ajustado, mas `F2_VALBRUT` não, embora `D2_VALBRUT` tenha sido alterado.
- **Linhas 95-99:** a CD2 só é ajustada no registro `SOL` (ICMS-ST). Se a versão do Protheus também gravar IBS/CBS na CD2, esses registros ficam como estavam.

### Como validar

1. Selecionar notas RCO com `ZA_ICMSDES = 'S'` geradas a partir de 2026.
2. Para cada item, comparar:
   - `D2_TOTAL` e `FT_TOTAL` (valor final do item)
   - `D2_DESCZFR` e `ZB_VLDIICM`
   - base, alíquota e valor de IBS estadual, IBS municipal e CBS na F2D. A ligação esperada é `F2D_IDREL = D2_IDTRIB`, com os valores em `F2D_BASE`/`F2D_ALIQ`/`F2D_VALOR`. **Esses nomes não foram confirmados no dicionário: confira no SX3.**
   - os valores da SZB (`ZB_IBSUFBS`, `ZB_IBSMUBS`, `ZB_CBSTXBS` e os respectivos valores)
3. Abrir o XML gerado para o Mastersaf e ver de onde vem o grupo de IBS/CBS.
4. Interpretar o resultado:
   - **Base da F2D igual a `D2_TOTAL`, ou à regra que o fiscal definir:** não é preciso fazer nada.
   - **Base diferente:** será preciso incluir a F2D no bloco ZFM (linhas 60-158), ou no `validValues`, usando o cálculo do SAP (campos `ZB_IBS*`/`ZB_CBS*`) ou recalculando a partir da nova base. Valide a regra com o fiscal antes de implementar.
