# Detalhe dos Fontes — Integração SAP SC Johnson (AG2)

| Item | Valor |
|---|---|
| Projeto | SC Johnson / DHL — NF-e 2027 (IBS, CBS, IS) |
| Unidade de negócio | AG2 (SC Johnson) |
| Data | 23/11/2026 |
| Responsável | Wellington Santana |
| Documentos relacionados | `Resumo_Fontes_SCJ_AG2.md`, `Diagnostico_RTC_Lote1_Cadastros.md`, `Diagnostico_RTC_Lotes2a4_Integracao.md`, `Dicionario_RTC_Lotes1a4.md` |

---

## 1. Visão geral

Dos **21 fontes** da lista, **6 foram ajustados** nos Lotes 1 a 4 e **15 ficaram sem alteração**. Eles não foram esquecidos. Cada um se encaixa em um destes três motivos:

1. **Não têm regra fiscal.** Só orquestram ou gravam arquivo, então a reforma não os afeta (10 fontes).
2. **Dependem do SAP mandar informações novas** no IP_040 (4 fontes).
3. **Não tinham pendência** no diagnóstico (1 fonte).

Além dos 21 fontes, também foram ajustados `ProcMsaNFe.prw` e `MT103FIM_pe.prw`, que ficam fora da lista, mas fazem parte do fluxo.

---

## 2. Fontes ajustados (6)

| Fonte | Lote | O que foi ajustado |
|---|---|---|
| `SAP/SCJ/Cadastro de Regras Fiscais/CadRegFis.prw` | 1 | Validação da regra (`vldRegra`) e do CFOP esperado por subtipo (`cfopEsperado`), controlada pelo `ZZ_RTCVLCF` |
| `SAP/SCJ/Cadastro de Para CPOS Fiscal/CadDePara.prw` | 1 e 2 | ID de modelo único (`MIDDEPAR`). Validação de linha: campos existentes no SX3, tabela destino amarrada à origem (SZA→SF2; SZB→SD2/SFT/SB1/CD2/SF3) e bloqueio do de/para IBS/CBS para a CD2 |
| `SAP/SCJ/updImpCD2.prw` | 1 | Condição do `While` corrigida, `MsUnlock` incluído, loja de saída correta, `%SZA.SQLNAME%` e `D1_SERIORI` no join |
| `SAP/SCJ/Classes/DHLIp040Sap.prw` | 2 | Troca de `protheus.ch` por `totvs.ch`. `fQryTes` reescrito sem `IIF` e filtrando `ZC_FINNFE`/`ZC_TPCOMPL` quando os campos existem. Aviso único no log para de/para IBS/CBS na CD2 |
| `SAP/ProcRCOMsa.prw` (IP140) | 2 a 4 | Erro de compilação no `SetPrvt` corrigido. Parâmetros `ZZ_TRIBICM`/`ZZ_TRIBIS`. `tpNFCredito`/`tpNFDebito` e `indPres` lidos do XML. finNFe 3 só na saída. `vIPIDevol` só na devolução. 22 chamadas do `retValueAttribute` com o parêntese corrigido |
| `SAP/ProcRSymbMsa.prw` (IP050) | 3 | `indPres` lido do XML (nova `getIndPres()`). **Atenção:** o IP050 **não leva IBS, CBS nem IS** (não tem `IBSCBS`, `IS` nem os totais). Incluir esses campos muda o layout posicional lido pelo SAP e depende da decisão 4 do diagnóstico |
| `SAP/SCJ/SAPIP040.prw` | 23/11 | Totais de IBS/CBS da SZA (`ZA_IBSUFTO`, `ZA_IBSMUTO`, `ZA_IBSTOTA`, `ZA_CBSTOTA`) passam a ser a **soma dos itens** (`getTotRtc`), porque o rodapé do SAP veio errado no arquivo de 27/10/2026 (`IBS_MUN_TOTAL_VALUE` = 666,79 com itens zerados; `IBS_TOTAL_VALUE` = 0). Se o rodapé divergir, avisa no log. Sem a tag, não interrompe mais a importação. Alíquota de IBS/CBS (`ZB_IBSUFTX`, `ZB_IBSMUTX`, `ZB_CBSTXRT`) calculada por valor ÷ base quando `TAX_RATE` vem vazio (`getItRate`). Backup em `backup_rtc_ip040_20261123/` |
| `SAP/SCJ/PrcGrvRco.prw` | 23/11 | Nova `confIbsCbs`: confere item a item o IBS UF, IBS municipal e CBS da NF RCO calculados pelo Protheus (F2D) com os do SAP (SZB). Só avisa no log, não altera a nota. Controlada por `ZZ_RTCCONF` e `MV_RTC55` |

**Fora da lista:**

| Fonte | O que foi ajustado |
|---|---|
| `Mastersaf_NFe/ProcMsaNFe.prw` | Mesmo erro de compilação no `SetPrvt` |
| `Pontos_de_Entrada/COM/MT103FIM_pe.prw` | Execução do `updImpCD2` controlada por `ZZ_UPDCD2U` (unidades) e `ZZ_UPDCD2C` (subtipos de crédito) |

---

## 3. Fontes sem alteração (15)

### 3.1 Não têm regra fiscal (10)

| Fonte | O que faz | Por que não mudou |
|---|---|---|
| `SAP/PrcRCOXml.prw` | Gera o XML da NF RCO e chama o `ProcRCOMsa` | Só repassa o XML. O ajuste foi feito no `ProcRCOMsa` |
| `SAP/PrcXmlRSymb.prw` | Gera o XML do retorno simbólico e chama o `ProcRSymbMsa` | Só repassa o XML. O ajuste foi feito no `ProcRSymbMsa` |
| `SAP/MsafRCOFile.prw` | Grava o arquivo posicional IP140 | Só grava o que o `ProcRCOMsa` monta. Muda apenas se o layout do SAP/Mastersaf mudar (decisão 4 do diagnóstico) |
| `SAP/MsafRSymbFile.prw` | Grava o arquivo posicional IP050 | Igual ao anterior, para o `ProcRSymbMsa` |
| `Mastersaf_NFe/PrcXmlNfe.prw` | Chama o `XmlNfeSef` (nfesefaz) e entrega o XML ao `ProcMsaNFe` | Só orquestra. A regra fiscal fica no nfesefaz e no `ProcMsaNFe` |
| `SAP/SCJ/SAPIP150.prw` | Lê o IP150 do SAP e **cancela** as notas | O cancelamento não depende do imposto. A trava da AG2 não bloqueia e já aceita `AJUSTE_FISCAL` na exclusão (item 10 do diagnóstico) |
| `SAP/SCJ/Classes/DHLIp150.prw` | Classe auxiliar do IP150 | Mesmo motivo do `SAPIP150`. Só precisaria de um novo define se a DOX virar unidade de negócio |
| `SAP/SCJ/SAPIP160.prw` | Gera o IP160 (retorno do cancelamento ao SAP) com a `DHLIp160` | Não leva imposto |
| `SAP/SCJ/SAPIP190.prw` | Gera o IP190 (confirmação de recebimento) | O IP_190 só leva item, quantidade, unidade, linha e lote, sem imposto (confirmado na TASK-036) |
| `Pontos_de_Entrada/FAT/M460FIM_pe.prw` | Fim do faturamento: chama `PrcGrvRet`, grava a mensagem de ajuste (`gravMsgAjustImp`) e chama `PrcXmlNfe` | Só chama outras rotinas. Nenhuma dessas chamadas mudou |

### 3.2 Dependem do SAP mandar informações novas (4)

| Fonte | O que precisaria mudar | O que está faltando |
|---|---|---|
| `SAP/SCJ/SAPIP040.prw` | Ler finalidade, subtipo, CST/cClassTrib, IS e canal de venda (indPres) | O IP_040 do SAP **não envia** esses dados. Ler uma tag que não existe faz a interface falhar |
| `SAP/SCJ/PrcNfRco.prw` | Deixar de gravar `F2_TIPO = "N"` fixo e preencher `F2_TPCOMPL` | Sem os dados do SAP, a rotina só pode gerar a nota normal (RCO), que é o que faz hoje |
| `SAP/SCJ/PrcGrvRco.prw` | Mesmo caso do `PrcNfRco` | Mesmo motivo |
| `SAP/SCJ/PrcNfRet.prw` | Gerar retorno com finalidade de crédito ou débito | O retorno simbólico é sempre nota normal. Só muda se o SAP passar a mandar crédito ou débito por essa interface |

> ⚠️ **Cuidado:** o `SAPIP040` grava a SZA/SZB de forma dinâmica, a partir do SX3. Cada campo novo nessas tabelas precisa de uma função `get<campo>()` correspondente na classe, senão o IP_040 inteiro falha. Por isso não dá para criar esses campos antes de ter o layout do SAP.

### 3.3 Não tinham pendência (1)

| Fonte | Motivo |
|---|---|
| `SAP/SCJ/PrcGrvRet.prw` | Não calcula nem grava imposto. Só monta e grava (SZZ, via `FswTemplMsg`) a **mensagem complementar** da NF RET, citando a NF de venda da SC Johnson, a NF RCO e o destinatário (SA1/SYA). Também avisa por e-mail quando a chave da NF da SC Johnson referenciada na SZA não confere. Não usa nenhum campo de IBS, CBS ou IS, que vêm do motor de tributos padrão TOTVS |

---

## 4. Próximos passos

| Gatilho | Fontes afetados |
|---|---|
| SAP definir o novo layout do IP_040 (decisão 3) | `SAPIP040`, `DHLIp040Sap`, `PrcNfRco`, `PrcGrvRco` e, se houver crédito/débito no retorno, `PrcNfRet` |
| SAP/Mastersaf definirem o layout 2027 do IP140/IP050 (decisão 4) | `MsafRCOFile`, `MsafRSymbFile`, `ProcRCOMsa`, `ProcRSymbMsa` |
| DOX virar unidade de negócio | `DHLIp150` (novo define) |
| Regras de NFref, omissão dos tributos antigos e gAjusteCompet | `nfesefaz`, `PE01NFESEFAZ` e `ImpMsaNfe`, que estão fora da lista e precisam entrar no escopo do projeto |
