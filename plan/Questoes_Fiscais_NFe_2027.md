# NF-e 2027 — Reforma Tributária: questões para a área fiscal

- **Projeto:** adequação dos sistemas Protheus da DHL à NF-e 2027 (IBS, CBS e Imposto Seletivo)
- **Base normativa:** NT 2025.002 v1.53 e NT 2026.008 v1.01
- **Data:** 18/11/2026
- **Solicitado por:** equipe de desenvolvimento (Wellington e Pablo)
- **Como responder:** preencher a coluna **Resposta** de cada item, ou responder por e-mail citando o número da questão

---

## Por que estas perguntas existem

O desenvolvimento das mudanças de NF-e 2027 está em andamento. A estrutura dos novos grupos de imposto — IBS, CBS, Imposto Seletivo, ajuste de competência, estorno de crédito e referência de documento — já foi implementada nos programas de geração da nota fiscal.

O que falta não é programação: são **definições de negócio** que somente a área fiscal pode dar. Enquanto elas não vierem, parte do desenvolvimento fica parada e parte fica pronta mas com um valor provisório.

As 18 questões abaixo estão agrupadas por tema. A coluna **O que trava** indica a consequência de cada pendência:

| Marcador | Significado |
|---|---|
| 🔴 **Desenvolvimento** | sem a resposta, não é possível programar — é o que atrasa o cronograma |
| 🟡 **Produção** | o programa já está pronto; a resposta é um cadastro de parâmetro, feito a qualquer momento |
| 🟢 **Teste** | a resposta é necessária para validar valores, não para programar |

---

## 1. Escopo — define o tamanho do projeto

| # | Questão | O que trava | Resposta |
|---|---|---|---|
| 1 | **Quais tipos de nota a DHL vai efetivamente emitir em 2027?** Os cenários previstos são: venda, complementar, ajuste, devolução, nota de crédito (tipos 03, 04 e 06) e nota de débito (tipos 03, 04, 06 e 07). Hoje estamos desenvolvendo todos. Se algum não for emitido pela DHL, sai do escopo. | 🔴 Desenvolvimento | |
| 2 | **Quais unidades de negócio, além da AG2, devem emitir nota de ajuste?** Hoje o sistema só permite a AG2. As demais unidades atendidas são SPL, REV, REP, AGL, PKG e MUL. | 🟡 Produção | |
| 3 | **As operações da unidade DIS entram no escopo?** Elas não constavam da relação original de programas. | 🔴 Desenvolvimento | |

## 2. Tributação e alíquotas

| # | Questão | O que trava | Resposta |
|---|---|---|---|
| 4 | **Quais as alíquotas de CBS e de Imposto Seletivo a aplicar em 2027?** Os exemplos que recebemos usam valores hipotéticos: CBS 8,80% e IS 2%. | 🟢 Teste | |
| 5 | **O CST 08 de PIS/COFINS será utilizado em 2027?** Ele muda o tratamento dessas contribuições na nota. | 🔴 Desenvolvimento | |
| 6 | **Qual o código de classificação tributária (`cClassTrib`) da nota de ajuste que contém apenas ICMS?** Os exemplos deixam esse caso em aberto. | 🟢 Teste | |
| 7 | **Os CSTs 410 e 811 devem compor a base de IBS/CBS informada ao Mastersaf?** Hoje a base soma apenas os CSTs 000, 200, 210, 220, 510, 550, 830 e 222. O CST 410 é usado no estorno de crédito e o 811 no ajuste de competência. | 🟡 Produção | |
| 8 | **Os CFOPs 5949, 1949 e 5927 se confirmam** como os aplicáveis às notas de crédito e débito? Precisam de conferência no Ajuste SINIEF 49/2025. | 🟢 Teste | |

## 3. Finalidade da nota, referências e impostos aplicáveis

| # | Questão | O que trava | Resposta |
|---|---|---|---|
| 9 | **Como determinar o indicador de presença do comprador em cada tipo de nota?** Hoje o sistema envia sempre "não se aplica". Os exemplos usam valores diferentes conforme a operação. | 🔴 Desenvolvimento | |
| 10 | **Quantas notas fiscais referenciadas deve ter cada tipo de operação?** Na nota complementar e na nota de crédito dos tipos 03 e 04, a norma exige **exatamente uma**. Hoje o sistema pode gerar várias, o que causa rejeição. | 🔴 Desenvolvimento | |
| 11 | **Em quais tipos de nota a referência de documento por item é obrigatória, e em quais o número do item é proibido?** Pelo que levantamos: obrigatória na nota de crédito 06 e nas notas de débito 03 e 04; o número do item é proibido no débito 03; a nota de crédito 03 e 04 não aceita a referência por item; e a referência vai no cabeçalho **ou** no item, nunca nos dois. Confirmar e completar. | 🔴 Desenvolvimento | |
| 12 | **Quais impostos devem ser omitidos em cada tipo de nota?** Pelo que levantamos: as notas de débito 03 e 04 não levam ICMS, IPI, PIS, COFINS nem ISS; a nota de débito 06 leva apenas o ICMS previsto de pagamento antecipado; a nota de crédito é dispensada de PIS e COFINS. Confirmar e completar. | 🔴 Desenvolvimento | |
| 13 | **O valor do ajuste de competência entra na composição do valor total do item?** Aplica-se à nota de débito tipo 03. | 🔴 Desenvolvimento | |

## 4. Identificação do participante e escrituração nos livros fiscais

| # | Questão | O que trava | Resposta |
|---|---|---|---|
| 14 | **Na nota de crédito, o participante é o cliente?** A indicação anterior da área fiscal foi que sim; precisamos da confirmação formal. Essa definição determina de qual cadastro o sistema busca nome, CNPJ, inscrição estadual e endereço para os livros fiscais. | 🟡 Produção | |
| 15 | **Na nota de débito tipo 07 (perda em estoque), qual participante deve constar?** Nessa operação o destinatário é a própria DHL, portanto pode não haver terceiro envolvido. | 🟡 Produção | |
| 16 | **A nota de crédito e a nota de débito devem ser escrituradas como qual tipo de movimento?** O arquivo enviado ao Mastersaf hoje só admite duas classificações: operação normal e devolução. Crédito e débito estão sendo enviados como operação normal. Observação: esta resposta depende também do novo leiaute do Mastersaf DW para 2027, que precisamos receber do fornecedor. | 🟡 Produção | |

## 5. Zona Franca de Manaus e interface com o SAP

| # | Questão | O que trava | Resposta |
|---|---|---|---|
| 17 | **Qual é a base correta de IBS e CBS nas notas com desoneração de Zona Franca de Manaus?** Nessas notas, o sistema recalcula o valor do item depois de o imposto já ter sido apurado, e a base de IBS/CBS fica divergente do valor final do item. A ZFM tem regras próprias na reforma (redução de alíquota, crédito presumido). | 🔴 Desenvolvimento | |
| 18 | **Quando o valor de IBS/CBS recebido do SAP divergir do calculado pelo Protheus, qual o procedimento?** Três opções, mutuamente exclusivas: **(a)** bloquear o faturamento e registrar o erro; **(b)** aceitar o valor do SAP, sobrescrevendo o cálculo do Protheus; **(c)** manter o cálculo do Protheus e apenas registrar a divergência para auditoria. **Atenção:** a opção (b) faz o valor escriturado deixar de corresponder à regra de cálculo que o gerou, o que afeta a rastreabilidade na apuração e em eventual fiscalização — se for a escolhida, precisamos do aceite formal desse risco. | 🔴 Desenvolvimento | |

---

## Resumo para priorização

| O que trava | Questões | Quantidade |
|---|---|---|
| 🔴 Desenvolvimento | 1, 3, 5, 9, 10, 11, 12, 13, 17, 18 | 10 |
| 🟡 Produção | 2, 7, 14, 15, 16 | 5 |
| 🟢 Teste | 4, 6, 8 | 3 |

As **10 questões vermelhas** são as que determinam o cronograma. Se for necessário priorizar, sugerimos começar pela **1** (define o escopo de todas as demais) e pelas **17 e 18** (afetam a interface com o SAP, que tem desenvolvimento próprio).

## O que acontece depois das respostas

- As questões 🟡 são aplicadas por cadastro de parâmetro, sem nova versão de programa.
- As questões 🔴 entram como desenvolvimento, nas etapas já previstas no plano de execução.
- As questões 🟢 entram na massa de testes em ambiente de homologação.

Os testes usarão como base os 11 cenários de nota fiscal da documentação da NT, cada um validado de ponta a ponta: geração no Protheus, conferência do arquivo, transmissão pelo Mastersaf, retorno e geração dos livros fiscais.

---

*Documento extraído da seção 7 do `Plano_Execucao_NFe_2027_IBS_CBS.md`, onde cada questão está vinculada à etapa de desenvolvimento correspondente.*


---

## Atualização de 22/11/2026 — o que as planilhas já responderam

Chegaram dois documentos que respondem parte das questões acima, sem precisar voltar à área fiscal:

| Questão | Situação |
|---|---|
| **1** (quais notas a DHL emite) | ✅ **Respondida.** A planilha `TAGS reforma tribitaria + demais.xlsx` descreve o cenário DHL de cada tipo: crédito **01, 03, 04**; débito **02, 03, 04, 06** |
| **8** (CFOPs) | ✅ Respondida pelo anexo 1 do questionário |
| **9** (indPres) | ✅ Resolvida tecnicamente: o `nfesefaz` já emite o campo; o mapper passou a lê-lo |
| **16** (tipo de movimento no DW) | ⏸ Parcial — a regra veio no anexo 8, mas o **leiaute Mastersaf DW 2027** ainda falta |

**Correção importante ao que foi respondido antes:** o **débito 02** não é "bens e serviços para uso e consumo próprio" (resposta 15) — é **"Anulação de Crédito por Saídas Imunes/Isentas"**. O valor vem da apuração assistida do IBS, a partir dos `cClassTrib` das notas de fornecimento. Isso muda a modelagem do cenário.

### Questões que permanecem abertas

1. **Unidades (questão 2)** — segue não aplicável: "DHL, DOX e SOL" são códigos de empresa do Mastersaf, não unidades de negócio.
2. **Débito 07** — a resposta 1 e a planilha de TAGS o excluem do escopo DHL, mas quatro anexos o detalham.
3. **CST do `gAjusteCompet`** — 810 ou 811.
4. **Crédito 01 e débito 02** — faltam os **exemplos de XML**, no formato dos 11 existentes. É o insumo pendente de melhor relação custo/valor.
5. **Questões 17 e 18** — continuam sem resposta.
6. **Unidade DIS** — continua sem dono.
7. **Nota de crédito vem do SIGACOM** (Compras), não do Faturamento — confirmar se o fluxo Mastersaf cobre esses documentos de entrada.
