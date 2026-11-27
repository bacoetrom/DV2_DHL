# Layout TXT — Envio NF-e / NFC-e 4.00 (DF-e 4.19)

> Documentação gerada a partir da aba **`Envio NFe_NFCe - 4.00 -DFe 4.19`** da planilha `ONESOURCEDFE_Layout_NFe_NFCe_4_00v4_19.xlsx`.
> ONESOURCE DFE · Manual de Layout NF-e/NFC-e 4_00 v4_19 · Publicação: 03/11/2026

## Sumário

1. [Visão geral](#visao-geral)
2. [Regras gerais](#regras-gerais)
3. [Legenda das colunas](#legenda-das-colunas)
4. [Novidades da versão 4.19](#novidades-da-versao-419)
5. [Estrutura hierárquica do arquivo TXT](#estrutura-hierarquica-do-arquivo-txt)
6. [Índice de blocos](#indice-de-blocos)
7. [Detalhamento dos blocos e campos](#detalhamento-dos-blocos-e-campos)
8. [Campos novos na 4.19 (lista rápida)](#campos-novos-na-419-lista-rapida)

## Visão geral

O arquivo TXT de envio de NF-e/NFC-e é composto por **blocos** delimitados por marcadores de abertura `--<bloco>_ini--;` e fechamento `--<bloco>_fim--;`. Dentro de cada bloco, os campos devem ser informados **na ordem descrita neste documento**. Os blocos podem ser aninhados e alguns se repetem (ver coluna *Ocor*). O arquivo termina com o marcador `--arquivo_fim--;`.

| Indicador | Quantidade |
|---|---:|
| Blocos (grupos) | 240 |
| Campos | 918 |
| Campos do tipo Numérico | 694 |
| Campos do tipo Caractere | 207 |
| Campos do tipo Data | 14 |
| Campos do tipo — | 3 |
| Blocos com novidade na 4.19 | 4 |
| Campos novos na 4.19 | 9 |

## Regras gerais

- Bloco não obrigatório: não é gerado quando os campos de integração estão vazios (ex.: --avulsa_ini--).
- Bloco obrigatório (principal): é gerado com tag fechada <tag/> quando os campos estão vazios.
- Blocos principais obrigatórios com subcampos vazios: apenas o bloco principal é gerado; os subblocos (mesmo obrigatórios) são ignorados (ex.: --emit_ini--; > --ender_Emit_ini--; > xLgr).
- Campos zerados (0.00): são incluídos no XML.

## Legenda das colunas

| Coluna | Significado |
|---|---|
| **ID** | Identificador do campo no leiaute (numeração do Manual de Orientação do Contribuinte / NT; prefixo `M` = campos específicos Mastersaf/ONESOURCE). |
| **Campo** | Nome do campo/marcador no TXT. Marcadores `--x_ini--;` / `--x_fim--;` delimitam blocos. |
| **Descrição** | Descrição do campo. |
| **Tipo** | `Numérico`, `Caractere`, `Data`; para blocos: `G` (grupo), `Grupo`, `CG` (*Choice Group* — escolha exclusiva entre grupos). |
| **Ocor** | Ocorrência mínima–máxima. `1-1` obrigatório e único; `0-1` opcional; `0-n`/`1-n` repetível até *n* vezes. |
| **Tam.** | Tamanho: valor fixo (`44`) ou faixa (`1-60`). |
| **Dec.** | Quantidade de casas decimais (campos numéricos). |
| **Observação** | Regras de preenchimento, domínios de valores e validações. |
| **Obs. integração** | Observações específicas do integrador ONESOURCE DF-e / Mastersaf. |
| 🆕 | Item destacado na planilha como novidade da versão 4.19. |

## Novidades da versão 4.19

Extraído da aba **Alterações** (entradas da versão 4.19 para esta aba):

### 22/09/2026

Demanda Interna 1223991  
Alterações referente às versões 1.50 e 1.51 da NT 2025.002-RTC, Reforma Tributária (vigência sefaz: Homologação: Até 01/09/2026 (a critério de cada UF); Ambiente de Produção:  03/11/2026):  
- Adicionada versão 4.19 no campo versaoLayoutDFe.
- Reformulação completa do layout da tributação monofásica de combustíveis (gIBSCBSMono), com separação em:
  - IBS Monofásico Ad Rem (gIBSMonoAdRem)
  - IBS Monofásico Ad Valorem (gIBSMonoAdValorem)
  - CBS Monofásica Ad Rem (gCBSMonoAdRem)
  - CBS Monofásica Ad Valorem (gCBSMonoAdValorem)
- Cada subgrupo contém: gMonoPadrao, gMonoReten, gMonoRet e gpBioDiferenca.
- Removido grupo gMonoDif (diferimento), substituído por gpBioDiferenca.
- Adicionados campos Ad Valorem: vBCMono, pAliqMonoUF, vIBSMonoUF, pAliqMonoMun, vIBSMonoMun, pAliqMonoCBS, pAliqMonoReten, vBCMonoReten.

### 03/11/2026

Demanda Interna: 1287961  
A partir da versão 3.161.1 do DF-e:  
Alterações referente à NT 2026.008 v1.00 - Reforma Tributária do Consumo, Valor Líquido do Produto (vigência SEFAZ: Homologação: 26/10/2026; Ambiente de Produção: 16/11/2026 (adiadas pela SEFAZ em 05/10/2026); regra NB01-30: Homologação 01/02/2027 e Produção 01/03/2027):  
- Adicionado grupo sequencia_XML_liq (110.01) com os campos vUnComLiq (110.02) e vProdLiq (110.03), ao final do grupo prod (antes de --prod_fim--). No XML, a sequência é gerada entre vProd e cEANTrib.
- Adicionado campo vProdLiqTot (326a), opcional (0-1), diretamente no grupo total, após vNFTot e fora do grupo icms_Tot. No XML, a tag é gerada como primeira tag de total, antes de ICMSTot.
- Adicionado grupo ICMS_Previsto (245b.01) com o campo vICMSPrevisto (245b.02), ao final do grupo ICMS (somente NF-e modelo 55, pagamento antecipado). O grupo é alternativo aos demais grupos de ICMS do item.
- Incluída observação no campo vProd (110): a partir de 2027, os valores de IBS, CBS e IS compõem o Valor Total Bruto, exceto nas notas de importação.
- Incluída observação no campo vNFTot (355.30): a partir de 2027, os valores de IBS, CBS e IS já compõem o vProd e não devem ser somados novamente no total.
Campos novos posicionados ao final de cada bloco, para evitar impacto em integrações já existentes.  

Atenção - alteração em relação à prévia publicada em 15/10/2026: o campo vProdLiqTot (326a) passou a ser posicionado diretamente no grupo total, após o campo vNFTot (355.30) e fora do grupo icms_Tot. Na prévia anterior, o campo estava ao final do grupo icms_Tot (após vTotTrib). Ação necessária: clientes que já adaptaram a integração à prévia anterior devem reposicionar o campo vProdLiqTot no arquivo TXT.  

Alterações referente à NT 2026.006 v1.00 - Reforma Tributária do Consumo, Vinculação com a Transação de Pagamento do DF-e (vigência SEFAZ: Homologação: 05/10/2026; Ambiente de Produção: 03/11/2026):  
- Adicionado grupo gPgtoVinc (398.50 a 398.56), opcional (0-1), entre infIntermed e inf_Adic, com o subgrupo gPgto (1-99) e os campos nPag, idTransacao, tpMeioPgto, CNPJReceb e CNPJBasePSP.
- O evento de Vinculação da Transação de Pagamento (110300) ainda está em análise e construção da prévia de layout e será liberado em versão posterior.
- Campos de caráter preparatório: não há exigência de preenchimento em produção em 2026; split payment previsto a partir de 2027.

## Estrutura hierárquica do arquivo TXT

Esqueleto do arquivo com todos os blocos na ordem em que devem aparecer (entre colchetes: ocorrência do bloco; `CG` = escolha entre grupos alternativos).

```text
--nota_ini--;  [1-1]  (0 campos)
  --versao_Layout_DFe_ini--;  [0-1]  (1 campos)
  --versao_Layout_DFe_fim--;
  --inf_NFe_ini--;  [1-1]  (2 campos)
  --inf_NFe_fim--;
  --param_gerais_ini--;  [0-1]  (7 campos)
    --contingencia_externa_ini--;  [0-1]  (5 campos)
    --contingencia_externa_fim--;
  --param_gerais_fim--;
  --ide_ini--;  [1-1]  (26 campos)
    --x_contingencia_ini--;  [0-1]  (2 campos)
    --x_contingencia_fim--;
    --gCompraGov_ini--;  [0-1]  (3 campos)
      --ref_NFe_ini--;  [0-99]  (1 campos)
      --ref_NFe_fim--;
    --gCompraGov_fim--;
    --gPagAntecipado_ini--;  [0-99]  (1 campos)
    --gPagAntecipado_fim--;
    --nfReferenciada_ini--;  [0-999]  (3 campos)
      --ref_NFe_ini--;  [1-1]  (6 campos)
      --ref_NFe_fim--;
      --ref_NFP_ini--;  [1-1]  (8 campos)
      --ref_NFP_fim--;
      --ref_ECF_ini--;  [1-1]  (3 campos)
      --ref_ECF_fim--;
    --nfReferenciada_fim--;
  --ide_fim--;
  --emit_ini--;  [1-1]  (8 campos)
    --ender_Emit_ini--;  [1-1]  (11 campos)
    --ender_Emit_fim--;
    --x_emitente_ini--;  [0-1]  (2 campos)
    --x_emitente_fim--;
  --emit_fim--;
  --avulsa_ini--;  [0-1]  (11 campos)
  --avulsa_fim--;
  --dest_ini--;  [0-1]  (9 campos)
    --ender_Dest_ini--;  [0-1]  (11 campos)
    --ender_Dest_fim--;
  --dest_fim--;
  --retirada_ini--;  [0-1]  (16 campos)
  --retirada_fim--;
  --entrega_ini--;  [0-1]  (16 campos)
  --entrega_fim--;
  --aut_XML_ini--;  [0-10]  (2 campos)
  --aut_XML_fim--;
  --item_nota_ini--;  [1-900]  (0 campos)
    --det_ini--;  [1-1]  (1 campos)
      --prod_ini--;  [1-1]  (27 campos)
        --nve_ini--;  [0-8]  (1 campos)
        --nve_fim--;
        --sequencia_XML_ini--;  [0-1]  (3 campos)
        --sequencia_XML_fim--;
        --gCred_ini--;  [0-4]  (3 campos)
        --gCred_fim--;
        --di_ini--;  [0-100]  (12 campos)
          --adi_ini--;  [1-999]  (5 campos)
          --adi_fim--;
        --di_fim--;
        --det_Export_ini--;  [0-500]  (1 campos)
          --export_Ind_ini--;  [0-1]  (3 campos)
          --export_Ind_fim--;
        --det_Export_fim--;
        --rastro_ini--;  [0-500]  (5 campos)
        --rastro_fim--;
        --prod_especifico_ini--;  [0-1]  (1 campos)
          --veic_Prod_ini--;  [1-1]  (24 campos)
          --veic_Prod_fim--;
          --medicamento_ini--;  [1-1]  (3 campos)
          --medicamento_fim--;
          --armamento_ini--;  [1-500]  (4 campos)
          --armamento_fim--;
          --comb_ini--;  [1-1]  (10 campos)
            --cide_ini--;  [0-1]  (3 campos)
            --cide_fim--;
            --encerrante_ini--;  [0-1]  (5 campos)
            --encerrante_fim--;
            --origComb_ini--;  [0-30]  (3 campos)
            --origComb_fim--;
          --comb_fim--;
        --prod_especifico_fim--;
        --obsItem_ini--;  [0-1]  (0 campos)
          --obsCont_ini--;  [0-1]  (2 campos)
          --obsCont_fim--;
          --obsFisco_ini--;  [0-1]  (2 campos)
          --obsFisco_fim--;
        --obsItem_fim--;
        --sequencia_XML_liq_ini--;  [0-1]  (2 campos) 🆕
        --sequencia_XML_liq_fim--;
      --prod_fim--;
      --impostos_ini--;  [1-1]  (1 campos)
        --ICMS_ini--;  [0-1]  (0 campos)
          --icms_00_ini--;  [1-1]  (6 campos)
            --sequencia_XML_ini--;  [0-1]  (2 campos)
            --sequencia_XML_fim--;
          --icms_00_fim--;
          --icms_02_ini--;  [1-1]  (5 campos)
          --icms_02_fim--;
          --icms_10_ini--;  [1-1]  (12 campos)
            --sequencia_XML_FCP_ini--;  [0-1]  (3 campos)
            --sequencia_XML_FCP_fim--;
            --sequencia_XML_FCPST_ini--;  [0-1]  (3 campos)
            --sequencia_XML_FCPST_fim--;
            --x_icmsst10_deson_ini--;  [0-1]  (2 campos)
            --x_icmsst10_deson_fim--;
          --icms_10_fim--;
          --icms_15_ini--;  [1-1]  (8 campos)
            --sequencia_XML_ini--;  [0-1]  (2 campos)
            --sequencia_XML_fim--;
          --icms_15_fim--;
          --icms_20_ini--;  [1-1]  (7 campos)
            --sequencia_XML_ini--;  [0-1]  (3 campos)
            --sequencia_XML_fim--;
            --x_icms20_deson_ini--;  [0-1]  (3 campos)
            --x_icms20_deson_fim--;
          --icms_20_fim--;
          --icms_30_ini--;  [1-1]  (8 campos)
            --sequencia_XML_ini--;  [0-1]  (3 campos)
            --sequencia_XML_fim--;
            --x_icms30_deson_ini--;  [0-1]  (3 campos)
            --x_icms30_deson_fim--;
          --icms_30_fim--;
          --icms_40_ini--;  [1-1]  (2 campos)
            --x_icms40_deson_ini--;  [0-1]  (3 campos)
            --x_icms40_deson_fim--;
          --icms_40_fim--;
          --icms_51_ini--;  [1-1]  (11 campos)
            --sequencia_XML_ini--;  [0-1]  (3 campos)
            --sequencia_XML_fim--;
            --sequencia_XML_FCP_diferido_ini--;  [0-1]  (3 campos)
            --sequencia_XML_FCP_diferido_fim--;
          --icms_51_fim--;
          --icms_53_ini--;  [1-1]  (8 campos)
          --icms_53_fim--;
          --icms_60_ini--;  [1-1]  (2 campos)
            --x_icms60_retido_ini--;  [0-1]  (4 campos)
            --x_icms60_retido_fim--;
            --sequencia_XML_ini--;  [0-1]  (3 campos)
            --sequencia_XML_fim--;
            --x_icms_efetivo_ini--;  [0-1]  (4 campos)
            --x_icms_efetivo_fim--;
          --icms_60_fim--;
          --icms_61_ini--;  [1-1]  (5 campos)
          --icms_61_fim--;
          --icms_70_ini--;  [1-1]  (13 campos)
            --sequencia_XML_FCP_ini--;  [0-1]  (3 campos)
            --sequencia_XML_FCP_fim--;
            --sequencia_XML_FCPST_ini--;  [0-1]  (3 campos)
            --sequencia_XML_FCPST_fim--;
            --x_icms70_deson_ini--;  [0-1]  (3 campos)
            --x_icms70_deson_fim--;
            --x_icmsst70_deson_ini--;  [0-1]  (2 campos)
            --x_icmsst70_deson_fim--;
          --icms_70_fim--;
          --icms_90_ini--;  [1-1]  (2 campos)
            --x_icms90_icms_ini--;  [0-1]  (6 campos)
              --sequencia_XML_op_ini--;  [0-1]  (3 campos)
              --sequencia_XML_op_fim--;
              --sequencia_XML_ini--;  [0-1]  (3 campos)
              --sequencia_XML_fim--;
              --sequencia_XML_fcpdif_ini--;  [0-1]  (3 campos)
              --sequencia_XML_fcpdif_fim--;
            --x_icms90_icms_fim--;
            --x_icms90_icmsst_ini--;  [0-1]  (6 campos)
              --sequencia_XML_ini--;  [0-1]  (3 campos)
              --sequencia_XML_fim--;
            --x_icms90_icmsst_fim--;
            --x_icms90_deson_ini--;  [0-1]  (3 campos)
            --x_icms90_deson_fim--;
            --x_icmsst90_deson_ini--;  [0-1]  (2 campos)
            --x_icmsst90_deson_fim--;
          --icms_90_fim--;
          --icms_part_ini--;  [1-1]  (15 campos)
            --sequencia_XML_ini--;  [0-1]  (3 campos)
            --sequencia_XML_fim--;
            --sequencia_XML_deson_ini--;  [0-1]  (3 campos)
            --sequencia_XML_deson_fim--;
          --icms_part_fim--;
          --icms_st_ini--;  [1-1]  (8 campos)
            --sequencia_XML_ini--;  [0-1]  (3 campos)
            --sequencia_XML_fim--;
            --x_icms_efetivo_ini--;  [0-1]  (4 campos)
            --x_icms_efetivo_fim--;
          --icms_st_fim--;
          --icms_sn101_ini--;  [1-1]  (4 campos)
          --icms_sn101_fim--;
          --icms_sn102_ini--;  [1-1]  (2 campos)
          --icms_sn102_fim--;
          --icms_sn201_ini--;  [1-1]  (10 campos)
            --sequencia_XML_ini--;  [0-1]  (3 campos)
            --sequencia_XML_fim--;
          --icms_sn201_fim--;
          --icms_sn202_ini--;  [1-1]  (8 campos)
            --sequencia_XML_ini--;  [0-1]  (3 campos)
            --sequencia_XML_fim--;
          --icms_sn202_fim--;
          --icms_sn500_ini--;  [1-1]  (2 campos)
            --x_sn500_retido_ini--;  [0-1]  (4 campos)
            --x_sn500_retido_fim--;
            --sequencia_XML_ini--;  [0-1]  (3 campos)
            --sequencia_XML_fim--;
            --x_icms_efetivo_ini--;  [0-1]  (4 campos)
            --x_icms_efetivo_fim--;
          --icms_sn500_fim--;
          --icms_sn900_ini--;  [1-1]  (2 campos)
            --x_sn900_icms_ini--;  [0-1]  (5 campos)
            --x_sn900_icms_fim--;
            --x_sn900_icmsst_ini--;  [0-1]  (6 campos)
            --x_sn900_icmsst_fim--;
            --sequencia_XML_ini--;  [0-1]  (3 campos)
            --sequencia_XML_fim--;
            --x_sn900_credito_ini--;  [0-1]  (2 campos)
            --x_sn900_credito_fim--;
          --icms_sn900_fim--;
          --ICMS_Previsto_ini--;  [0-1]  (1 campos) 🆕
          --ICMS_Previsto_fim--;
        --ICMS_fim--;
        --ICMS_UF_Dest_ini--;  [0-1]  (9 campos)
        --ICMS_UF_Dest_fim--;
        --IPI_ini--;  [0-1]  (4 campos)
          --ipi_trib_ini--;  [1-1]  (2 campos)
            --x_ipi_aliq_ini--;  [1-1]  (2 campos)
            --x_ipi_aliq_fim--;
            --x_ipi_unid_ini--;  [1-1]  (2 campos)
            --x_ipi_unid_fim--;
          --ipi_trib_fim--;
          --ipi_nt_ini--;  [1-1]  (1 campos)
          --ipi_nt_fim--;
        --IPI_fim--;
        --II_ini--;  [0-1]  (4 campos)
        --II_fim--;
        --PIS_ini--;  [0-1]  (0 campos)
          --pis_aliq_ini--;  [1-1]  (4 campos)
          --pis_aliq_fim--;
          --pis_qtde_ini--;  [1-1]  (4 campos)
          --pis_qtde_fim--;
          --pis_nt_ini--;  [1-1]  (1 campos)
          --pis_nt_fim--;
          --pis_outr_ini--;  [1-1]  (2 campos)
            --x_pis_percent_ini--;  [1-1]  (2 campos)
            --x_pis_percent_fim--;
            --x_pis_valor_ini--;  [1-1]  (2 campos)
            --x_pis_valor_fim--;
          --pis_outr_fim--;
        --PIS_fim--;
        --PISST_ini--;  [0-1]  (2 campos)
          --x_pisst_percent_ini--;  [1-1]  (2 campos)
          --x_pisst_percent_fim--;
          --x_pisst_valor_ini--;  [1-1]  (2 campos)
          --x_pisst_valor_fim--;
        --PISST_fim--;
        --COFINS_ini--;  [0-1]  (0 campos)
          --cofins_aliq_ini--;  [1-1]  (4 campos)
          --cofins_aliq_fim--;
          --cofins_qtde_ini--;  [1-1]  (4 campos)
          --cofins_qtde_fim--;
          --cofins_nt_ini--;  [1-1]  (1 campos)
          --cofins_nt_fim--;
          --cofins_outr_ini--;  [1-1]  (2 campos)
            --x_cofinsoutr_percent_ini--;  [1-1]  (2 campos)
            --x_cofinsoutr_percent_fim--;
            --x_cofinsoutr_valor_ini--;  [1-1]  (2 campos)
            --x_cofinsoutr_valor_fim--;
          --cofins_outr_fim--;
        --COFINS_fim--;
        --COFINSST_ini--;  [0-1]  (2 campos)
          --x_cofinsst_percent_ini--;  [1-1]  (2 campos)
          --x_cofinsst_percent_fim--;
          --x_cofinsst_valor_ini--;  [1-1]  (2 campos)
          --x_cofinsst_valor_fim--;
        --COFINSST_fim--;
        --ISSQN_ini--;  [0-1]  (16 campos)
        --ISSQN_fim--;
        --IS_ini--;  [0-1]  (2 campos)
          --seqSeletivo_ini--;  [0-1]  (4 campos)
            --sequencia_XML_ini--;  [0-1]  (2 campos)
            --sequencia_XML_fim--;
          --seqSeletivo_fim--;
        --IS_fim--;
        --IBSCBS_ini--;  [0-1]  (3 campos)
          --sequencia_XML_IBSCBS_ini--;  (0 campos)
            --gIBSCBS_ini--;  [1-1 | CG]  (2 campos)
              --gIBSUF_ini--;  [1-1]  (2 campos)
                --gDif_ini--;  [0-1]  (2 campos)
                --gDif_fim--;
                --gDevTrib_ini--;  [0-1]  (2 campos)
                --gDevTrib_fim--;
                --gRed_ini--;  [0-1]  (2 campos)
                --gRed_fim--;
              --gIBSUF_fim--;
              --gIBSMun_ini--;  [1-1]  (2 campos)
                --gDif_ini--;  [0-1]  (2 campos)
                --gDif_fim--;
                --gDevTrib_ini--;  [0-1]  (2 campos)
                --gDevTrib_fim--;
                --gRed_ini--;  [0-1]  (2 campos)
                --gRed_fim--;
              --gIBSMun_fim--;
              --gCBS_ini--;  [1-1]  (2 campos)
                --gDif_ini--;  [0-1]  (2 campos)
                --gDif_fim--;
                --gDevTrib_ini--;  [0-1]  (2 campos)
                --gDevTrib_fim--;
                --gRed_ini--;  [0-1]  (2 campos)
                --gRed_fim--;
                --gALCZFMCBS_ini--;  [0-1]  (4 campos)
                --gALCZFMCBS_fim--;
              --gCBS_fim--;
              --gTribRegular_ini--;  [0-1]  (8 campos)
              --gTribRegular_fim--;
              --gTribCompraGov_ini--;  [0-1]  (6 campos)
              --gTribCompraGov_fim--;
            --gIBSCBS_fim--;
            --gIBSCBSMono_ini--;  [1-1 | CG]  (2 campos)
              --sequencia_XML_IBSMono_ini--;  [0-1]  (0 campos)
                --gIBSMonoAdRem_ini--;  [0-1 | CG]  (0 campos)
                  --gMonoPadrao_ini--;  [0-1]  (3 campos)
                  --gMonoPadrao_fim--;
                  --gMonoReten_ini--;  [0-1]  (3 campos)
                  --gMonoReten_fim--;
                  --gMonoRet_ini--;  [0-1]  (1 campos)
                  --gMonoRet_fim--;
                  --gpBioDiferenca_ini--;  [0-1]  (2 campos)
                  --gpBioDiferenca_fim--;
                --gIBSMonoAdRem_fim--;
                --gIBSMonoAdValorem_ini--;  [0-1 | CG]  (0 campos)
                  --gMonoPadrao_ini--;  [0-1]  (6 campos)
                  --gMonoPadrao_fim--;
                  --gMonoReten_ini--;  [0-1]  (3 campos)
                  --gMonoReten_fim--;
                  --gMonoRet_ini--;  [0-1]  (1 campos)
                  --gMonoRet_fim--;
                  --gpBioDiferenca_ini--;  [0-1]  (2 campos)
                  --gpBioDiferenca_fim--;
                --gIBSMonoAdValorem_fim--;
              --sequencia_XML_IBSMono_fim--;
              --sequencia_XML_CBSMono_ini--;  [0-1]  (0 campos)
                --gCBSMonoAdRem_ini--;  [0-1 | CG]  (0 campos)
                  --gMonoPadrao_ini--;  [0-1]  (3 campos)
                  --gMonoPadrao_fim--;
                  --gMonoReten_ini--;  [0-1]  (3 campos)
                  --gMonoReten_fim--;
                  --gMonoRet_ini--;  [0-1]  (1 campos)
                  --gMonoRet_fim--;
                  --gpBioDiferenca_ini--;  [0-1]  (2 campos)
                  --gpBioDiferenca_fim--;
                --gCBSMonoAdRem_fim--;
                --gCBSMonoAdValorem_ini--;  [0-1 | CG]  (0 campos)
                  --gMonoPadrao_ini--;  [0-1]  (3 campos)
                  --gMonoPadrao_fim--;
                  --gMonoReten_ini--;  [0-1]  (3 campos)
                  --gMonoReten_fim--;
                  --gMonoRet_ini--;  [0-1]  (1 campos)
                  --gMonoRet_fim--;
                  --gpBioDiferenca_ini--;  [0-1]  (2 campos)
                  --gpBioDiferenca_fim--;
                --gCBSMonoAdValorem_fim--;
              --sequencia_XML_CBSMono_fim--;
            --gIBSCBSMono_fim--;
            --gTransfCred_ini--;  [1-1 | CG]  (2 campos)
            --gTransfCred_fim--;
            --gAjusteCompet_ini--;  [1-1 | CG]  (3 campos)
            --gAjusteCompet_fim--;
          --sequencia_XML_IBSCBS_fim--;
          --gEstornoCred_ini--;  [0-1]  (2 campos)
          --gEstornoCred_fim--;
          --sequencia_XML_cred_pres_ini--;  [0-1]  (0 campos)
            --gCredPresOper_ini--;  [1-1 | CG]  (2 campos)
              --gIBSCredPres_ini--;  [0-1]  (3 campos)
              --gIBSCredPres_fim--;
              --gCBSCredPres_ini--;  [0-1]  (3 campos)
              --gCBSCredPres_fim--;
            --gCredPresOper_fim--;
            --gCredPresIBSZFM_ini--;  [1-1 | CG]  (3 campos)
            --gCredPresIBSZFM_fim--;
          --sequencia_XML_cred_pres_fim--;
        --IBSCBS_fim--;
      --impostos_fim--;
      --imposto_devol_ini--;  [0-1]  (1 campos)
        --ipi_devol_ini--;  [1-1]  (1 campos)
        --ipi_devol_fim--;
      --imposto_devol_fim--;
      --inf_adicionais_ini--;  [0-1]  (1 campos)
      --inf_adicionais_fim--;
      --vItem_ini--;  [0-1]  (1 campos)
      --vItem_fim--;
      --DFeReferenciado_ini--;  [0-1]  (2 campos)
      --DFeReferenciado_fim--;
    --det_fim--;
  --item_nota_fim--;
  --total_ini--;  [1-1]  (2 campos)
    --icms_Tot_ini--;  [1-1]  (29 campos)
    --icms_Tot_fim--;
    --issqn_Tot_ini--;  [0-1]  (12 campos)
    --issqn_Tot_fim--;
    --ret_Trib_ini--;  [0-1]  (7 campos)
    --ret_Trib_fim--;
    --ISTot_ini--;  [0-1]  (1 campos)
    --ISTot_fim--;
    --IBSCBSTot_ini--;  [0-1]  (1 campos)
      --gIBS_Tot_ini--;  [0-1]  (3 campos)
        --gIBSUF_Tot_ini--;  [1-1]  (3 campos)
        --gIBSUF_Tot_fim--;
        --gIBSMun_Tot_ini--;  [1-1]  (3 campos)
        --gIBSMun_Tot_fim--;
      --gIBS_Tot_fim--;
      --gCBS_Tot_ini--;  [0-1]  (5 campos)
      --gCBS_Tot_fim--;
      --gMono_Tot_ini--;  [0-1]  (6 campos)
      --gMono_Tot_fim--;
      --gEstornoCred_ini--;  [0-1]  (2 campos)
      --gEstornoCred_fim--;
    --IBSCBSTot_fim--;
  --total_fim--;
  --inf_transporte_ini--;  (2 campos)
    --transp_ini--;  [1-1]  (1 campos)
    --transp_fim--;
    --transporta_ini--;  [0-1]  (7 campos)
    --transporta_fim--;
    --ret_Transp_ini--;  [0-1]  (6 campos)
    --ret_Transp_fim--;
    --x_transp_diversos_ini--;  [0-1]  (0 campos)
      --veic_Transp_ini--;  [0-1]  (3 campos)
      --veic_Transp_fim--;
      --reboque_ini--;  [0-5]  (3 campos)
      --reboque_fim--;
    --x_transp_diversos_fim--;
    --volume_ini--;  [0-5000]  (6 campos)
      --lacre_ini--;  [0-5000]  (1 campos)
      --lacre_fim--;
    --volume_fim--;
  --inf_transporte_fim--;
  --cobr_ini--;  [0-1]  (0 campos)
    --fat_ini--;  [0-1]  (4 campos)
    --fat_fim--;
    --duplicata_ini--;  [0-120]  (3 campos)
    --duplicata_fim--;
  --cobr_fim--;
  --pag_ini--;  [1-1]  (1 campos)
    --detPag_ini--;  [1-100]  (5 campos)
      --sequencia_XML_detPag_ini--;  [0-1]  (2 campos)
      --sequencia_XML_detPag_fim--;
      --card_ini--;  [0-1]  (6 campos)
      --card_fim--;
    --detPag_fim--;
  --pag_fim--;
  --infIntermed_ini--;  [0-1]  (2 campos)
  --infIntermed_fim--;
  --gPgtoVinc_ini--;  [0-1]  (0 campos) 🆕
    --gPgto_ini--;  [1-99]  (5 campos) 🆕
    --gPgto_fim--;
  --gPgtoVinc_fim--;
  --inf_Adic_ini--;  [0-1]  (2 campos)
    --uso_livre_c_ini--;  [0-10]  (2 campos)
    --uso_livre_c_fim--;
    --uso_livre_f_ini--;  [0-10]  (2 campos)
    --uso_livre_f_fim--;
    --proc_referenciado_ini--;  [0-100]  (3 campos)
    --proc_referenciado_fim--;
  --inf_Adic_fim--;
  --exporta_ini--;  [0-1]  (3 campos)
  --exporta_fim--;
  --compra_ini--;  [0-1]  (3 campos)
  --compra_fim--;
  --cana_ini--;  [0-1]  (8 campos)
    --cana_forn_diario_ini--;  [1-31]  (2 campos)
    --cana_forn_diario_fim--;
    --cana_deducao_ini--;  [0-10]  (2 campos)
    --cana_deducao_fim--;
  --cana_fim--;
  --infRespTec_ini--;  [0-1]  (4 campos)
    --seq_XML_ini--;  [0-1]  (2 campos)
    --seq_XML_fim--;
  --infRespTec_fim--;
  --agropecuario_ini--;  [0-1]  (0 campos)
    --defensivo_ini--;  [1-20 | CG]  (2 campos)
    --defensivo_fim--;
    --guiaTransito_ini--;  [1-1 | CG]  (4 campos)
    --guiaTransito_fim--;
  --agropecuario_fim--;
--nota_fim--;
--arquivo_fim--;
```

## Índice de blocos

| # | Bloco | Descrição | Pai | Tipo | Ocor | Linha planilha |
|---:|---|---|---|---|---|---:|
| 1 | [`nota`](#nota) | TAG raiz da NF-e | `—` | — | 1-1 | 13 |
| 2 | [`versao_Layout_DFe`](#versao_layout_dfe) | Informações de Layout DFE | `nota` | — | 0-1 | 14 |
| 3 | [`inf_NFe`](#inf_nfe) | Informações da NF-e | `nota` | — | 1-1 | 17 |
| 4 | [`param_gerais`](#param_gerais) | Informações do Produto Mastersaf | `nota` | — | 0-1 | 21 |
| 5 | [`contingencia_externa`](#contingencia_externa) | Contingência Externa | `param_gerais` | — | 0-1 | 25 |
| 6 | [`ide`](#ide) | Informações de identificação da NF-e | `nota` | — | 1-1 | 37 |
| 7 | [`x_contingencia`](#x_contingencia) | Sequência XML | `ide` | — | 0-1 | 64 |
| 8 | [`gCompraGov`](#gcompragov) | Grupo de Compra Governamental | `ide` | — | 0-1 | 68 |
| 9 | [`ref_NFe`](#ref_nfe) | Chave de acesso do documento fiscal anterior | `gCompraGov` | — | 0-99 | 72 |
| 10 | [`gPagAntecipado`](#gpagantecipado) | Grupo de notas de antecipação de pagamento | `ide` | — | 0-99 | 76 |
| 11 | [`nfReferenciada`](#nfreferenciada) | Informação de Documentos Fiscais referenciados | `ide` | — | 0-999 | 79 |
| 12 | [`ref_NFe`](#ref_nfe-1) | Informação da NF modelo 1/1A  ou NF modelo 2 referenciada | `nfReferenciada` | — | 1-1 | 82 |
| 13 | [`ref_NFP`](#ref_nfp) | Informações da NF de Produtor rural referenciada | `nfReferenciada` | — | 1-1 | 90 |
| 14 | [`ref_ECF`](#ref_ecf) | Informações do Cupom Fiscal referenciado | `nfReferenciada` | — | 1-1 | 101 |
| 15 | [`emit`](#emit) | Identificação do emitente da NF-e | `nota` | — | 1-1 | 108 |
| 16 | [`ender_Emit`](#ender_emit) | Endereço do emitente | `emit` | — | 1-1 | 113 |
| 17 | [`x_emitente`](#x_emitente) | Sequência XML | `emit` | — | 0-1 | 128 |
| 18 | [`avulsa`](#avulsa) | Fisco Emitente da NF-e (Avulsa) | `nota` | — | 0-1 | 135 |
| 19 | [`dest`](#dest) | Identificação do Destinatário da NF-e | `nota` | — | 0-1 | 148 |
| 20 | [`ender_Dest`](#ender_dest) | Endereço do Destinatário da NF-e | `dest` | — | 0-1 | 153 |
| 21 | [`retirada`](#retirada) | Identificação do Local de retirada | `nota` | — | 0-1 | 172 |
| 22 | [`entrega`](#entrega) | Identificação do Local de entrega | `nota` | — | 0-1 | 190 |
| 23 | [`aut_XML`](#aut_xml) | Pessoas autorizadas para o download do XML da NF-e | `nota` | — | 0-10 | 208 |
| 24 | [`item_nota`](#item_nota) | Itens da nota | `nota` | — | 1-900 | 212 |
| 25 | [`det`](#det) | Detalhamento de Produtos e Serviços | `item_nota` | — | 1-1 | 213 |
| 26 | [`prod`](#prod) | Detalhamento de Produtos e Serviços | `det` | — | 1-1 | 215 |
| 27 | [`nve`](#nve) | NVE | `prod` | — | 0-8 | 221 |
| 28 | [`sequencia_XML`](#sequencia_xml) | Sequencia XML | `prod` | — | 0-1 | 224 |
| 29 | [`gCred`](#gcred) | Grupo de informações sobre o Crédito Presumido | `prod` | — | 0-4 | 248 |
| 30 | [`di`](#di) | Declaração de Importação | `prod` | — | 0-100 | 253 |
| 31 | [`adi`](#adi) | Adições e/ou itens | `di` | — | 1-999 | 266 |
| 32 | [`det_Export`](#det_export) | Informações de Exportação para o item | `prod` | — | 0-500 | 274 |
| 33 | [`export_Ind`](#export_ind) | Informações sobre exportação indireta | `det_Export` | — | 0-1 | 276 |
| 34 | [`rastro`](#rastro) | Detalhamento de produto sujeito a rastreabilidade | `prod` | — | 0-500 | 285 |
| 35 | [`prod_especifico`](#prod_especifico) | Sequência XML | `prod` | — | 0-1 | 292 |
| 36 | [`veic_Prod`](#veic_prod) | Detalhamento de Veículos novos | `prod_especifico` | — | 1-1 | 293 |
| 37 | [`medicamento`](#medicamento) | Detalhamento de Medicamentos e de matérias-primas farmacêuticas | `prod_especifico` | — | 1-1 | 319 |
| 38 | [`armamento`](#armamento) | Detalhamento de Armamento | `prod_especifico` | — | 1-500 | 324 |
| 39 | [`comb`](#comb) | Informações específicas para combustíveis líquidos e lubrificantes | `prod_especifico` | — | 1-1 | 330 |
| 40 | [`cide`](#cide) | Informações da CIDE | `comb` | — | 0-1 | 340 |
| 41 | [`encerrante`](#encerrante) | Informações de "Encerrante" | `comb` | — | 0-1 | 345 |
| 42 | [`origComb`](#origcomb) | Grupo indicador da origem do combustível | `comb` | — | 0-30 | 353 |
| 43 | [`obsItem`](#obsitem) | Grupo de observações de uso livre (para o item da NF-e) | `prod` | — | 0-1 | 361 |
| 44 | [`obsCont`](#obscont) | Grupo de observações de uso livre do Contribuinte | `obsItem` | — | 0-1 | 362 |
| 45 | [`obsFisco`](#obsfisco) | Grupo de observações de uso livre do Fisco | `obsItem` | — | 0-1 | 366 |
| 46 | [`sequencia_XML_liq`](#sequencia_xml_liq) 🆕 | Sequência XML | `prod` | — | 0-1 | 371 |
| 47 | [`impostos`](#impostos) | Tributo incidentes no Produto ou Serviço | `det` | — | 1-1 | 376 |
| 48 | [`ICMS`](#icms) | Informações do ICMS da Operação | `impostos` | — | 0-1 | 378 |
| 49 | [`icms_00`](#icms_00) | Grupo Tributação do ICMS= 00 | `ICMS` | — | 1-1 | 379 |
| 50 | [`sequencia_XML`](#sequencia_xml-1) | Sequência XML | `icms_00` | — | 0-1 | 386 |
| 51 | [`icms_02`](#icms_02) | Grupo Tributação do ICMS monofásico = 02 | `ICMS` | — | 1-1 | 391 |
| 52 | [`icms_10`](#icms_10) | Grupo Tributação do ICMS= 10 | `ICMS` | — | 1-1 | 398 |
| 53 | [`sequencia_XML_FCP`](#sequencia_xml_fcp) | Sequência XML para FCP | `icms_10` | — | 0-1 | 405 |
| 54 | [`sequencia_XML_FCPST`](#sequencia_xml_fcpst) | Sequência XML para FCP retido por ST | `icms_10` | — | 0-1 | 416 |
| 55 | [`x_icmsst10_deson`](#x_icmsst10_deson) | Sequência XML para ICMS ST Desonerado | `icms_10` | — | 0-1 | 421 |
| 56 | [`icms_15`](#icms_15) | Grupo Tributação do ICMS monofásico = 15 | `ICMS` | — | 1-1 | 426 |
| 57 | [`sequencia_XML`](#sequencia_xml-2) | Sequência XML | `icms_15` | — | 0-1 | 435 |
| 58 | [`icms_20`](#icms_20) | Grupo Tributação do ICMS= 20 | `ICMS` | — | 1-1 | 440 |
| 59 | [`sequencia_XML`](#sequencia_xml-3) | Sequência XML | `icms_20` | — | 0-1 | 448 |
| 60 | [`x_icms20_deson`](#x_icms20_deson) | Sequência XML | `icms_20` | — | 0-1 | 453 |
| 61 | [`icms_30`](#icms_30) | Grupo Tributação do ICMS= 30 | `ICMS` | — | 1-1 | 459 |
| 62 | [`sequencia_XML`](#sequencia_xml-4) | Sequência XML | `icms_30` | — | 0-1 | 468 |
| 63 | [`x_icms30_deson`](#x_icms30_deson) | Sequência XML | `icms_30` | — | 0-1 | 473 |
| 64 | [`icms_40`](#icms_40) | Grupo Tributação do ICMS= 40, 41, 50 | `ICMS` | — | 1-1 | 479 |
| 65 | [`x_icms40_deson`](#x_icms40_deson) | Sequência XML | `icms_40` | — | 0-1 | 482 |
| 66 | [`icms_51`](#icms_51) | Grupo Tributação do ICMS= 51 | `ICMS` | — | 1-1 | 488 |
| 67 | [`sequencia_XML`](#sequencia_xml-5) | Sequência XML | `icms_51` | — | 0-1 | 500 |
| 68 | [`sequencia_XML_FCP_diferido`](#sequencia_xml_fcp_diferido) | Sequência XML | `icms_51` | — | 0-1 | 505 |
| 69 | [`icms_53`](#icms_53) | Grupo Tributação do ICMS monofásico = 53 | `ICMS` | — | 1-1 | 511 |
| 70 | [`icms_60`](#icms_60) | Grupo Tributação do ICMS= 60 | `ICMS` | — | 1-1 | 521 |
| 71 | [`x_icms60_retido`](#x_icms60_retido) | Sequência XML | `icms_60` | — | 0-1 | 524 |
| 72 | [`sequencia_XML`](#sequencia_xml-6) | Sequência XML | `icms_60` | — | 0-1 | 530 |
| 73 | [`x_icms_efetivo`](#x_icms_efetivo) | Informações do ICMS Efetivo | `icms_60` | — | 0-1 | 535 |
| 74 | [`icms_61`](#icms_61) | Grupo Tributação do ICMS monofásico = 61 | `ICMS` | — | 1-1 | 542 |
| 75 | [`icms_70`](#icms_70) | Grupo Tributação do ICMS= 70 | `ICMS` | — | 1-1 | 549 |
| 76 | [`sequencia_XML_FCP`](#sequencia_xml_fcp-1) | Sequência XML para FCP | `icms_70` | — | 0-1 | 557 |
| 77 | [`sequencia_XML_FCPST`](#sequencia_xml_fcpst-1) | Sequência XML para FCP retido por ST | `icms_70` | — | 0-1 | 568 |
| 78 | [`x_icms70_deson`](#x_icms70_deson) | Sequência XML | `icms_70` | — | 0-1 | 573 |
| 79 | [`x_icmsst70_deson`](#x_icmsst70_deson) | Sequência XML para ICMS ST Desonerado | `icms_70` | — | 0-1 | 578 |
| 80 | [`icms_90`](#icms_90) | Grupo Tributação do ICMS= 90 | `ICMS` | — | 1-1 | 583 |
| 81 | [`x_icms90_icms`](#x_icms90_icms) | Sequência XML | `icms_90` | — | 0-1 | 586 |
| 82 | [`sequencia_XML_op`](#sequencia_xml_op) | Sequência XML | `x_icms90_icms` | — | 0-1 | 593 |
| 83 | [`sequencia_XML`](#sequencia_xml-7) | Sequência XML | `x_icms90_icms` | — | 0-1 | 598 |
| 84 | [`sequencia_XML_fcpdif`](#sequencia_xml_fcpdif) | Sequência XML | `x_icms90_icms` | — | 0-1 | 603 |
| 85 | [`x_icms90_icmsst`](#x_icms90_icmsst) | Sequência XML | `icms_90` | — | 0-1 | 609 |
| 86 | [`sequencia_XML`](#sequencia_xml-8) | Sequência XML | `x_icms90_icmsst` | — | 0-1 | 616 |
| 87 | [`x_icms90_deson`](#x_icms90_deson) | Sequência XML | `icms_90` | — | 0-1 | 622 |
| 88 | [`x_icmsst90_deson`](#x_icmsst90_deson) | Sequência XML para ICMS ST Desonerado | `icms_90` | — | 0-1 | 627 |
| 89 | [`icms_part`](#icms_part) | Grupo de Partilha do ICMS entre a UF de origem e UF de destino ou a UF definida na legislação. | `ICMS` | — | 1-1 | 632 |
| 90 | [`sequencia_XML`](#sequencia_xml-9) | Sequencia XML | `icms_part` | — | 0-1 | 646 |
| 91 | [`sequencia_XML_deson`](#sequencia_xml_deson) | Sequencia XML | `icms_part` | — | 0-1 | 653 |
| 92 | [`icms_st`](#icms_st) | Grupo de Repasse de ICMS ST retido anteriormente em operações interestaduais com repasses através do Substituto Tributário | `ICMS` | — | 1-1 | 659 |
| 93 | [`sequencia_XML`](#sequencia_xml-10) | Sequencia XML | `icms_st` | — | 0-1 | 666 |
| 94 | [`x_icms_efetivo`](#x_icms_efetivo-1) | Informações do ICMS Efetivo | `icms_st` | — | 0-1 | 673 |
| 95 | [`icms_sn101`](#icms_sn101) | Grupo CRT= 1 - Simples Nacional e CSOSN= 101 | `ICMS` | — | 1-1 | 680 |
| 96 | [`icms_sn102`](#icms_sn102) | Grupo CRT=1 – Simples Nacional, CRT=4 – MEI e CSOSN=102, 103, 300 ou 400 | `ICMS` | — | 1-1 | 686 |
| 97 | [`icms_sn201`](#icms_sn201) | Grupo CRT= 1 - Simples Nacional e CSOSN= 201 | `ICMS` | — | 1-1 | 690 |
| 98 | [`sequencia_XML`](#sequencia_xml-11) | Sequência XML | `icms_sn201` | — | 0-1 | 699 |
| 99 | [`icms_sn202`](#icms_sn202) | Grupo CRT= 1 - Simples Nacional e CSOSN= 202 ou 203 | `ICMS` | — | 1-1 | 707 |
| 100 | [`sequencia_XML`](#sequencia_xml-12) | Sequência XML | `icms_sn202` | — | 0-1 | 716 |
| 101 | [`icms_sn500`](#icms_sn500) | Grupo CRT= 1 - Simples Nacional e CSOSN= 500 | `ICMS` | — | 1-1 | 722 |
| 102 | [`x_sn500_retido`](#x_sn500_retido) | Sequência XML | `icms_sn500` | — | 0-1 | 725 |
| 103 | [`sequencia_XML`](#sequencia_xml-13) | Sequência XML | `icms_sn500` | — | 0-1 | 731 |
| 104 | [`x_icms_efetivo`](#x_icms_efetivo-2) | Informações do ICMS Efetivo | `icms_sn500` | — | 0-1 | 736 |
| 105 | [`icms_sn900`](#icms_sn900) | Grupo CRT=1 – Simples Nacional, CRT=4 – MEI e CSOSN=900 | `ICMS` | — | 1-1 | 743 |
| 106 | [`x_sn900_icms`](#x_sn900_icms) | Sequência XML | `icms_sn900` | — | 0-1 | 746 |
| 107 | [`x_sn900_icmsst`](#x_sn900_icmsst) | Sequência XML | `icms_sn900` | — | 0-1 | 753 |
| 108 | [`sequencia_XML`](#sequencia_xml-14) | Sequência XML | `icms_sn900` | — | 0-1 | 761 |
| 109 | [`x_sn900_credito`](#x_sn900_credito) | Sequência XML | `icms_sn900` | — | 0-1 | 766 |
| 110 | [`ICMS_Previsto`](#icms_previsto) 🆕 | Grupo do ICMS Previsto no Pagamento Antecipado | `ICMS` | — | 0-1 | 771 |
| 111 | [`ICMS_UF_Dest`](#icms_uf_dest) | Informação do ICMS Interestadual | `impostos` | — | 0-1 | 775 |
| 112 | [`IPI`](#ipi) | Grupo IPI | `impostos` | — | 0-1 | 786 |
| 113 | [`ipi_trib`](#ipi_trib) | Grupo do CST 00, 49, 50 e 99 | `IPI` | — | 1-1 | 791 |
| 114 | [`x_ipi_aliq`](#x_ipi_aliq) | Sequência XML | `ipi_trib` | — | 1-1 | 793 |
| 115 | [`x_ipi_unid`](#x_ipi_unid) | Sequência XML | `ipi_trib` | — | 1-1 | 797 |
| 116 | [`ipi_nt`](#ipi_nt) | Grupo CST 01, 02, 03, 04, 51, 52, 53, 54 e 55 | `IPI` | — | 1-1 | 803 |
| 117 | [`II`](#ii) | Grupo de Imposto de Importação | `impostos` | — | 0-1 | 807 |
| 118 | [`PIS`](#pis) | Grupo PIS | `impostos` | — | 0-1 | 813 |
| 119 | [`pis_aliq`](#pis_aliq) | Grupo PIS tributado pela alíquota | `PIS` | — | 1-1 | 814 |
| 120 | [`pis_qtde`](#pis_qtde) | Grupo PIS tributado por Quantidade | `PIS` | — | 1-1 | 820 |
| 121 | [`pis_nt`](#pis_nt) | Grupo PIS não tributado | `PIS` | — | 1-1 | 826 |
| 122 | [`pis_outr`](#pis_outr) | Grupo PIS Outras Operações | `PIS` | — | 1-1 | 829 |
| 123 | [`x_pis_percent`](#x_pis_percent) | Sequência XML | `pis_outr` | — | 1-1 | 831 |
| 124 | [`x_pis_valor`](#x_pis_valor) | Sequência XML | `pis_outr` | — | 1-1 | 835 |
| 125 | [`PISST`](#pisst) | Grupo PIS Substituição Tributária | `impostos` | — | 0-1 | 842 |
| 126 | [`x_pisst_percent`](#x_pisst_percent) | Sequência XML | `PISST` | — | 1-1 | 843 |
| 127 | [`x_pisst_valor`](#x_pisst_valor) | Sequência XML | `PISST` | — | 1-1 | 847 |
| 128 | [`COFINS`](#cofins) | Grupo COFINS | `impostos` | — | 0-1 | 854 |
| 129 | [`cofins_aliq`](#cofins_aliq) | Grupo COFINS tributado pela alíquota | `COFINS` | — | 1-1 | 855 |
| 130 | [`cofins_qtde`](#cofins_qtde) | Grupo de COFINS tributado por Quantidade | `COFINS` | — | 1-1 | 861 |
| 131 | [`cofins_nt`](#cofins_nt) | Grupo COFINS não tributado | `COFINS` | — | 1-1 | 867 |
| 132 | [`cofins_outr`](#cofins_outr) | Grupo COFINS Outras Operações | `COFINS` | — | 1-1 | 870 |
| 133 | [`x_cofinsoutr_percent`](#x_cofinsoutr_percent) | Sequência XML | `cofins_outr` | — | 1-1 | 872 |
| 134 | [`x_cofinsoutr_valor`](#x_cofinsoutr_valor) | Sequência XML | `cofins_outr` | — | 1-1 | 876 |
| 135 | [`COFINSST`](#cofinsst) | Grupo COFINS Substituição Tributária | `impostos` | — | 0-1 | 883 |
| 136 | [`x_cofinsst_percent`](#x_cofinsst_percent) | Sequência XML | `COFINSST` | — | 1-1 | 884 |
| 137 | [`x_cofinsst_valor`](#x_cofinsst_valor) | Sequência XML | `COFINSST` | — | 1-1 | 888 |
| 138 | [`ISSQN`](#issqn) | Grupo ISSQN | `impostos` | — | 0-1 | 895 |
| 139 | [`IS`](#is) | Informações do Imposto Seletivo | `impostos` | — | 0-1 | 913 |
| 140 | [`seqSeletivo`](#seqseletivo) | Sequência XML | `IS` | — | 0-1 | 916 |
| 141 | [`sequencia_XML`](#sequencia_xml-15) | Sequência XML | `seqSeletivo` | — | 0-1 | 921 |
| 142 | [`IBSCBS`](#ibscbs) | Informações do Imposto de Bens e Serviços -<br>IBS e da Contribuição de Bens e Serviços - CBS | `impostos` | — | 0-1 | 927 |
| 143 | [`sequencia_XML_IBSCBS`](#sequencia_xml_ibscbs) | Grupo de Informações do IBS, CBS e Imposto Seletivo | `IBSCBS` | Grupo | — | 931 |
| 144 | [`gIBSCBS`](#gibscbs) | Grupo de Informações do IBS, CBS e Imposto Seletivo | `sequencia_XML_IBSCBS` | CG | 1-1 | 932 |
| 145 | [`gIBSUF`](#gibsuf) | Grupo de Informações do IBS para a UF | `gIBSCBS` | — | 1-1 | 935 |
| 146 | [`gDif`](#gdif) | Grupo de Informações do Diferimento | `gIBSUF` | — | 0-1 | 938 |
| 147 | [`gDevTrib`](#gdevtrib) | Grupo de Informações da devolução de tributos | `gIBSUF` | — | 0-1 | 942 |
| 148 | [`gRed`](#gred) | Grupo de informações da redução da alíquota | `gIBSUF` | — | 0-1 | 946 |
| 149 | [`gIBSMun`](#gibsmun) | Grupo de Informações do IBS para o município | `gIBSCBS` | — | 1-1 | 951 |
| 150 | [`gDif`](#gdif-1) | Grupo de Informações do Diferimento | `gIBSMun` | — | 0-1 | 954 |
| 151 | [`gDevTrib`](#gdevtrib-1) | Grupo de Informações da devolução de tributos | `gIBSMun` | — | 0-1 | 958 |
| 152 | [`gRed`](#gred-1) | Grupo de informações da redução da alíquota | `gIBSMun` | — | 0-1 | 962 |
| 153 | [`gCBS`](#gcbs) | Grupo de Informações da CBS | `gIBSCBS` | — | 1-1 | 967 |
| 154 | [`gDif`](#gdif-2) | Grupo de Informações do Diferimento | `gCBS` | — | 0-1 | 970 |
| 155 | [`gDevTrib`](#gdevtrib-2) | Grupo de Informações da devolução de tributos | `gCBS` | — | 0-1 | 974 |
| 156 | [`gRed`](#gred-2) | Grupo de informações da redução da alíquota | `gCBS` | — | 0-1 | 978 |
| 157 | [`gALCZFMCBS`](#galczfmcbs) | Grupo de operações em áreas incentivadas (ALC/ZFM) - CBS (alíquota zero) | `gCBS` | — | 0-1 | 982 |
| 158 | [`gTribRegular`](#gtribregular) | Grupo de informações da Tributação Regular | `gIBSCBS` | — | 0-1 | 989 |
| 159 | [`gTribCompraGov`](#gtribcompragov) | Grupo de informações da composição do valor do IBS e da CBS em compras governamental | `gIBSCBS` | — | 0-1 | 999 |
| 160 | [`gIBSCBSMono`](#gibscbsmono) | Grupo de Informações do IBS e CBS em operações com imposto monofásico | `sequencia_XML_IBSCBS` | CG | 1-1 | 1008 |
| 161 | [`sequencia_XML_IBSMono`](#sequencia_xml_ibsmono) | Sequência XML | `gIBSCBSMono` | G | 0-1 | 1009 |
| 162 | [`gIBSMonoAdRem`](#gibsmonoadrem) | Grupo de informações da Tributação Monofásica Ad Rem do IBS | `sequencia_XML_IBSMono` | CG | 0-1 | 1010 |
| 163 | [`gMonoPadrao`](#gmonopadrao) | Grupo de informações da Tributação Monofásica Padrão | `gIBSMonoAdRem` | G | 0-1 | 1011 |
| 164 | [`gMonoReten`](#gmonoreten) | Grupo de informações da Tributação Monofásica Sujeita à Retenção | `gIBSMonoAdRem` | G | 0-1 | 1016 |
| 165 | [`gMonoRet`](#gmonoret) | Grupo de informações da Tributação Monofásica Retida Anteriormente | `gIBSMonoAdRem` | G | 0-1 | 1021 |
| 166 | [`gpBioDiferenca`](#gpbiodiferenca) | Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior ou superior ao obrigatório | `gIBSMonoAdRem` | G | 0-1 | 1024 |
| 167 | [`gIBSMonoAdValorem`](#gibsmonoadvalorem) | Grupo de informações da Tributação Monofásica Ad Valorem do IBS | `sequencia_XML_IBSMono` | CG | 0-1 | 1029 |
| 168 | [`gMonoPadrao`](#gmonopadrao-1) | Grupo de informações da Tributação Monofásica Padrão | `gIBSMonoAdValorem` | G | 0-1 | 1030 |
| 169 | [`gMonoReten`](#gmonoreten-1) | Grupo de informações da Tributação Monofásica Sujeita à Retenção | `gIBSMonoAdValorem` | G | 0-1 | 1038 |
| 170 | [`gMonoRet`](#gmonoret-1) | Grupo de informações da Tributação Monofásica Retida Anteriormente | `gIBSMonoAdValorem` | G | 0-1 | 1043 |
| 171 | [`gpBioDiferenca`](#gpbiodiferenca-1) | Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior ou superior ao obrigatório | `gIBSMonoAdValorem` | G | 0-1 | 1046 |
| 172 | [`sequencia_XML_CBSMono`](#sequencia_xml_cbsmono) | Sequência XML | `gIBSCBSMono` | G | 0-1 | 1052 |
| 173 | [`gCBSMonoAdRem`](#gcbsmonoadrem) | Grupo de informações da Tributação Monofásica Ad Rem da CBS | `sequencia_XML_CBSMono` | CG | 0-1 | 1053 |
| 174 | [`gMonoPadrao`](#gmonopadrao-2) | Grupo de informações da Tributação Monofásica Padrão | `gCBSMonoAdRem` | G | 0-1 | 1054 |
| 175 | [`gMonoReten`](#gmonoreten-2) | Grupo de informações da Tributação Monofásica Sujeita à Retenção | `gCBSMonoAdRem` | G | 0-1 | 1059 |
| 176 | [`gMonoRet`](#gmonoret-2) | Grupo de informações da Tributação Monofásica Retida Anteriormente | `gCBSMonoAdRem` | G | 0-1 | 1064 |
| 177 | [`gpBioDiferenca`](#gpbiodiferenca-2) | Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior ou superior ao obrigatório | `gCBSMonoAdRem` | G | 0-1 | 1067 |
| 178 | [`gCBSMonoAdValorem`](#gcbsmonoadvalorem) | Grupo de informações da Tributação Monofásica Ad Valorem da CBS | `sequencia_XML_CBSMono` | CG | 0-1 | 1072 |
| 179 | [`gMonoPadrao`](#gmonopadrao-3) | Grupo de informações da Tributação Monofásica Padrão | `gCBSMonoAdValorem` | G | 0-1 | 1073 |
| 180 | [`gMonoReten`](#gmonoreten-3) | Grupo de informações da Tributação Monofásica Sujeita à Retenção | `gCBSMonoAdValorem` | G | 0-1 | 1078 |
| 181 | [`gMonoRet`](#gmonoret-3) | Grupo de informações da Tributação Monofásica Retida Anteriormente | `gCBSMonoAdValorem` | G | 0-1 | 1083 |
| 182 | [`gpBioDiferenca`](#gpbiodiferenca-3) | Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior ou superior ao obrigatório | `gCBSMonoAdValorem` | G | 0-1 | 1086 |
| 183 | [`gTransfCred`](#gtransfcred) | Transferências de Crédito | `sequencia_XML_IBSCBS` | CG | 1-1 | 1095 |
| 184 | [`gAjusteCompet`](#gajustecompet) | Ajuste de Competência | `sequencia_XML_IBSCBS` | CG | 1-1 | 1099 |
| 185 | [`gEstornoCred`](#gestornocred) | gEstornoCred | `IBSCBS` | G | 0-1 | 1105 |
| 186 | [`sequencia_XML_cred_pres`](#sequencia_xml_cred_pres) | Grupo de Crédito Presumido da Operação | `IBSCBS` | G | 0-1 | 1109 |
| 187 | [`gCredPresOper`](#gcredpresoper) | Grupo de Crédito Presumido da Operação | `sequencia_XML_cred_pres` | CG | 1-1 | 1110 |
| 188 | [`gIBSCredPres`](#gibscredpres) | Grupo de Informações do Crédito Presumido referente ao IBS | `gCredPresOper` | — | 0-1 | 1113 |
| 189 | [`gCBSCredPres`](#gcbscredpres) | Grupo de Informações do Crédito Presumido referente a CBS | `gCredPresOper` | — | 0-1 | 1118 |
| 190 | [`gCredPresIBSZFM`](#gcredpresibszfm) | Grupo para apropriação de crédito presumido de IBS sobre o saldo devedor na ZFM (art. 450, § 1º, LC 214/25) | `sequencia_XML_cred_pres` | CG | 1-1 | 1124 |
| 191 | [`imposto_devol`](#imposto_devol) | Informação do Imposto devolvido | `det` | — | 0-1 | 1132 |
| 192 | [`ipi_devol`](#ipi_devol) | Informação do IPI devolvido | `imposto_devol` | — | 1-1 | 1134 |
| 193 | [`inf_adicionais`](#inf_adicionais) | Informações Adicionais (para o item da NF-e) | `det` | — | 0-1 | 1138 |
| 194 | [`vItem`](#vitem) | Valor Total do Item da NF-e | `det` | — | 0-1 | 1141 |
| 195 | [`DFeReferenciado`](#dfereferenciado) | Documento Fiscal Eletrônico Referenciado | `det` | — | 0-1 | 1144 |
| 196 | [`total`](#total) | Grupo Totais da NF-e | `nota` | — | 1-1 | 1150 |
| 197 | [`icms_Tot`](#icms_tot) | Grupo Totais referentes ao ICMS | `total` | — | 1-1 | 1151 |
| 198 | [`issqn_Tot`](#issqn_tot) | Grupo Totais referentes ao ISSQN | `total` | — | 0-1 | 1182 |
| 199 | [`ret_Trib`](#ret_trib) | Grupo Retenções de Tributos | `total` | — | 0-1 | 1196 |
| 200 | [`ISTot`](#istot) | Grupo total do imposto seletivo | `total` | Grupo | 0-1 | 1205 |
| 201 | [`IBSCBSTot`](#ibscbstot) | Totais da NF-e com IBS e CBS | `total` | Grupo | 0-1 | 1208 |
| 202 | [`gIBS_Tot`](#gibs_tot) | Grupo total do IBS | `IBSCBSTot` | Grupo | 0-1 | 1210 |
| 203 | [`gIBSUF_Tot`](#gibsuf_tot) | Grupo total do IBS da UF | `gIBS_Tot` | Grupo | 1-1 | 1211 |
| 204 | [`gIBSMun_Tot`](#gibsmun_tot) | Grupo total do IBS do Município | `gIBS_Tot` | Grupo | 1-1 | 1216 |
| 205 | [`gCBS_Tot`](#gcbs_tot) | Grupo total da CBS | `IBSCBSTot` | Grupo | 0-1 | 1225 |
| 206 | [`gMono_Tot`](#gmono_tot) | Grupo total da Monofasia | `IBSCBSTot` | Grupo | 0-1 | 1232 |
| 207 | [`gEstornoCred`](#gestornocred-1) | Grupo total do Estorno de Crédito | `IBSCBSTot` | Grupo | 0-1 | 1240 |
| 208 | [`inf_transporte`](#inf_transporte) | Informações do Transporte da NF-e | `nota` | — | — | 1248 |
| 209 | [`transp`](#transp) | Grupo Informações do Transporte | `inf_transporte` | — | 1-1 | 1249 |
| 210 | [`transporta`](#transporta) | Grupo Transportador | `inf_transporte` | — | 0-1 | 1252 |
| 211 | [`ret_Transp`](#ret_transp) | Grupo Retenção ICMS transporte | `inf_transporte` | — | 0-1 | 1261 |
| 212 | [`x_transp_diversos`](#x_transp_diversos) | Sequencia XML | `inf_transporte` | — | 0-1 | 1269 |
| 213 | [`veic_Transp`](#veic_transp) | Grupo Veículo Transporte | `x_transp_diversos` | — | 0-1 | 1270 |
| 214 | [`reboque`](#reboque) | Grupo Reboque | `x_transp_diversos` | — | 0-5 | 1275 |
| 215 | [`volume`](#volume) | Grupo Volumes | `inf_transporte` | — | 0-5000 | 1283 |
| 216 | [`lacre`](#lacre) | Grupo Lacre | `volume` | — | 0-5000 | 1290 |
| 217 | [`cobr`](#cobr) | Grupo Cobrança | `nota` | — | 0-1 | 1295 |
| 218 | [`fat`](#fat) | Grupo Fatura | `cobr` | — | 0-1 | 1296 |
| 219 | [`duplicata`](#duplicata) | Grupo Parcelas | `cobr` | — | 0-120 | 1302 |
| 220 | [`pag`](#pag) | Grupo de Formas de Pagamento | `nota` | — | 1-1 | 1308 |
| 221 | [`detPag`](#detpag) | Grupo Detalhamento do Pagamento | `pag` | — | 1-100 | 1309 |
| 222 | [`sequencia_XML_detPag`](#sequencia_xml_detpag) | Sequência XML | `detPag` | — | 0-1 | 1315 |
| 223 | [`card`](#card) | Grupo de Cartões, PIX, Boletos e outros Pagamentos Eletrônicos | `detPag` | — | 0-1 | 1319 |
| 224 | [`infIntermed`](#infintermed) | Grupo de Informações do Intermediador da Transação | `nota` | — | 0-1 | 1330 |
| 225 | [`gPgtoVinc`](#gpgtovinc) 🆕 | Grupo de informações da Vinculação com a Transação de Pagamento (YC01) | `nota` | — | 0-1 | 1334 |
| 226 | [`gPgto`](#gpgto) 🆕 | Dados de cada pagamento previsto para o DF-e (YC02) | `gPgtoVinc` | — | 1-99 | 1335 |
| 227 | [`inf_Adic`](#inf_adic) | Grupo de Informações Adicionais | `nota` | — | 0-1 | 1343 |
| 228 | [`uso_livre_c`](#uso_livre_c) | Grupo Campo de uso livre do Contribuinte | `inf_Adic` | — | 0-10 | 1346 |
| 229 | [`uso_livre_f`](#uso_livre_f) | Grupo Campo de uso livre do Fisco | `inf_Adic` | — | 0-10 | 1350 |
| 230 | [`proc_referenciado`](#proc_referenciado) | Grupo Processo referenciado | `inf_Adic` | — | 0-100 | 1354 |
| 231 | [`exporta`](#exporta) | Grupo Exportação | `nota` | — | 0-1 | 1360 |
| 232 | [`compra`](#compra) | Grupo Compra | `nota` | — | 0-1 | 1365 |
| 233 | [`cana`](#cana) | Grupo Cana | `nota` | — | 0-1 | 1370 |
| 234 | [`cana_forn_diario`](#cana_forn_diario) | Grupo Fornecimento diário de cana | `cana` | — | 1-31 | 1373 |
| 235 | [`cana_deducao`](#cana_deducao) | Grupo Deduções - Taxas e Contribuições | `cana` | — | 0-10 | 1380 |
| 236 | [`infRespTec`](#infresptec) | Informações do Responsável Técnico pelo sistema de emissão do Documento Fiscal eletrônico. | `nota` | Grupo | 0-1 | 1388 |
| 237 | [`seq_XML`](#seq_xml) | Grupo de informações do Código de Segurança do Responsável Técnico - CSRT | `infRespTec` | Grupo | 0-1 | 1393 |
| 238 | [`agropecuario`](#agropecuario) | Informações de produtos da agricultura, pecuária e produção Florestal | `nota` | Grupo | 0-1 | 1398 |
| 239 | [`defensivo`](#defensivo) | Defensivos Agrícolas | `agropecuario` | CG | 1-20 | 1399 |
| 240 | [`guiaTransito`](#guiatransito) | Guia de Trânsito | `agropecuario` | CG | 1-1 | 1403 |

## Detalhamento dos blocos e campos

<a id="nota"></a>

### `nota` — TAG raiz da NF-e

**Caminho:** `nota`  
**Ocorrência:** 1-1 · **Linha na planilha:** 13  
**Rótulo na planilha:** TAG RAIZ NF-e  

Abertura: `--nota_ini--;` · Fechamento: `--nota_fim--;`

➡️ Sub-bloco: [`versao_Layout_DFe`](#versao_layout_dfe) — Informações de Layout DFE (0-1)

➡️ Sub-bloco: [`inf_NFe`](#inf_nfe) — Informações da NF-e (1-1)

➡️ Sub-bloco: [`param_gerais`](#param_gerais) — Informações do Produto Mastersaf (0-1)

➡️ Sub-bloco: [`ide`](#ide) — Informações de identificação da NF-e (1-1)

➡️ Sub-bloco: [`emit`](#emit) — Identificação do emitente da NF-e (1-1)

➡️ Sub-bloco: [`avulsa`](#avulsa) — Fisco Emitente da NF-e (Avulsa) (0-1)

➡️ Sub-bloco: [`dest`](#dest) — Identificação do Destinatário da NF-e (0-1)

➡️ Sub-bloco: [`retirada`](#retirada) — Identificação do Local de retirada (0-1)

➡️ Sub-bloco: [`entrega`](#entrega) — Identificação do Local de entrega (0-1)

➡️ Sub-bloco: [`aut_XML`](#aut_xml) — Pessoas autorizadas para o download do XML da NF-e (0-10)

➡️ Sub-bloco: [`item_nota`](#item_nota) — Itens da nota (1-900)

➡️ Sub-bloco: [`total`](#total) — Grupo Totais da NF-e (1-1)

➡️ Sub-bloco: [`inf_transporte`](#inf_transporte) — Informações do Transporte da NF-e (—)

➡️ Sub-bloco: [`cobr`](#cobr) — Grupo Cobrança (0-1)

➡️ Sub-bloco: [`pag`](#pag) — Grupo de Formas de Pagamento (1-1)

➡️ Sub-bloco: [`infIntermed`](#infintermed) — Grupo de Informações do Intermediador da Transação (0-1)

➡️ Sub-bloco: [`gPgtoVinc`](#gpgtovinc) — Grupo de informações da Vinculação com a Transação de Pagamento (YC01) (0-1)

➡️ Sub-bloco: [`inf_Adic`](#inf_adic) — Grupo de Informações Adicionais (0-1)

➡️ Sub-bloco: [`exporta`](#exporta) — Grupo Exportação (0-1)

➡️ Sub-bloco: [`compra`](#compra) — Grupo Compra (0-1)

➡️ Sub-bloco: [`cana`](#cana) — Grupo Cana (0-1)

➡️ Sub-bloco: [`infRespTec`](#infresptec) — Informações do Responsável Técnico pelo sistema de emissão do Documento Fiscal eletrônico. (0-1)

➡️ Sub-bloco: [`agropecuario`](#agropecuario) — Informações de produtos da agricultura, pecuária e produção Florestal (0-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="versao_layout_dfe"></a>

#### `versao_Layout_DFe` — Informações de Layout DFE

**Caminho:** `nota` › `versao_Layout_DFe`  
**Ocorrência:** 0-1 · **Linha na planilha:** 14  
**Rótulo na planilha:** Versão Layout DFE  

Abertura: `--versao_Layout_DFe_ini--;` · Fechamento: `--versao_Layout_DFe_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| — | `versaoLayoutDFe` | Versão do layout DFE | Numérico | 1-1 | 5 | 2 | Campo utilizado pelo Integrador TXT para identificar a versão de Layout DFE em que o arquivo foi gerado. <br>Caso não seja informado, será considerada a versão "4.00", ficando sujeito a rejeição pela SEFAZ. | Informar  o valor "4.19"<br>-Este valor será alterado a cada nova versão do layout de Envio NF-e. |

<a id="inf_nfe"></a>

#### `inf_NFe` — Informações da NF-e

**Caminho:** `nota` › `inf_NFe`  
**ID:** 1 · **Ocorrência:** 1-1 · **Linha na planilha:** 17  

> Grupo que contém as informações da NF-e

Abertura: `--inf_NFe_ini--;` · Fechamento: `--inf_NFe_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 2 | `versao` | Versão do leiaute NF-e (Fisco) | Numérico | 1-1 | 1-4 | 2 | Versão do leiaute NF-e (Fisco) | — |
| 3 | `id` | Identificador da TAG a ser assinado | Caractere | 1-1 | 47 | — | Informar a chave de acesso precedida do literal 'NFe'. | — |

<a id="param_gerais"></a>

#### `param_gerais` — Informações do Produto Mastersaf

**Caminho:** `nota` › `param_gerais`  
**Ocorrência:** 0-1 · **Linha na planilha:** 21  

Abertura: `--param_gerais_ini--;` · Fechamento: `--param_gerais_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| M2 | `dsImpressora` | Nome da impressora que será utilizada para imprimir está NF-e. | Caractere | 0-1 | 1-100 | — | Quando informada o nome da impressora, todos os critérios de filtro configurados no módulo Printer Console  serão ignorados O documento será enviado a impressora informada neste campo ignorando filtros configurados. | Campo opcional específico da integração Mastersaf NF-e. |
| M3 | `numeroEmbarque` | Número da ordem de embarque | Caractere | 0-1 | 1-20 | — | — | Campo opcional específico da integração Mastersaf NF-e. |
| M4 | `nrItens` | Total de itens | Numérico | 0-1 | 1-3 | — | — | Campo opcional específico da integração Mastersaf NF-e. |

➡️ Sub-bloco: [`contingencia_externa`](#contingencia_externa) — Contingência Externa (0-1)

*Continuação dos campos de `param_gerais` (após o fechamento de `contingencia_externa`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| M11 | `usuarioEmitente` | Nome do usuário que emitiu a nota no ERP. | Caractere | 0-1 | 0-20 | — | Este campo será utilizado para filtrar e definir o critério de impressão das notas no PrinterNfe | Campo opcional específico da integração Mastersaf NF-e. |
| M12 | `campoUsoInterno` | Campo livre para uso interno | Caractere | 0-1 | 255 | — | Os dados informados neste campo não serão enviados à SEFAZ e não serão exibidos no DANFE.<br>Permitirá refinar os dados via busca Avançada no Portal. | Campo opcional específico da integração Mastersaf NF-e. |
| M13 | `enviaPrinter` | Define se o documento será enviado para o Printer | Numérico | 0-1 | 1 | — | 1 - Imprime automaticamente e grava os arquivos XML e PDF nas pastas do Printer;<br>2 - Não imprime automaticamente e grava os arquivos PDF e XML nas pastas do Printer. Ao utilizar esta opção, os campos "dsImpressora" e "numeroEmbarque" serão ignorados;<br>3 - Não imprime automaticamente e não grava arquivos XML e PDF nas pastas do Printer.  Ao utilizar esta opção, os campos "dsImpressora", "numeroEmbarque" e "nomenclaturaArquivos"  serão ignorados. | Campo opcional específico da integração Mastersaf<br>Ao informar este campo, será ignorada toda a configuração de impressão  realizada no Portal e  de gravação de arquivos realizadas no Printer. |
| M14 | `nomenclaturaArquivos` | Nomenclatura específica para os arquivos PDF e XML gravados pelo Printer | Caractere | 0-1 | 0-100 | — | O valor neste campo será utilizado para compor a nomenclatura dos arquivos PDF e XML. <br>Caso não seja preenchido, os arquivos serão gravados no formato padrão. | Campo opcional específico da integração Mastersaf |

<a id="contingencia_externa"></a>

##### `contingencia_externa` — Contingência Externa

**Caminho:** `nota` › `param_gerais` › `contingencia_externa`  
**Ocorrência:** 0-1 · **Linha na planilha:** 25  

Abertura: `--contingencia_externa_ini--;` · Fechamento: `--contingencia_externa_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| M6 | `flag_conting_ext` | Flag de contingência | Caractere | 0-1 | 1-256 | — | Campo que indica a entrada em contingência externa, informar "CONTINGENCIA" caso emissão em contingência externa, caso contrario não informar. | — |
| M7 | `Dt_Ent_Cont` | Inicio da entrada em contingência | Data | 0-1 | 19 | — | AAAA-MM-DDTHH:MM:SS | Caso o campo acima, flag_conting_ext for informado este campo se torna obrigatório. |
| M8 | `Dt_Sai_Cont` | Termino da saída de contingência | Data | 0-1 | 19 | — | AAAA-MM-DDTHH:MM:SS | — |
| M9 | `Mot_Cont_ext` | Motivo de contingência | Caractere | 0-1 | 1-256 | — | — | Caso o campo acima, flag_conting_ext for informado este campo se torna obrigatório. |
| M10 | `cEvento` | Código do evento de emissão EPEC (110140) | Caractere | 0-1 | 6 | — | Informar o código 110140 somente para emissão EPEC. Para outras contingências, deixar este campo vazio. | Informação controlada pelo Mastersaf NF-e. <br>Nos casos nos quais o Sistema de Origem decidir por contingência EPEC na origem esse campo deverá ser informado e obrigatoriamente deverão ser preenchidos os campos 29c e 29d. |

<a id="ide"></a>

#### `ide` — Informações de identificação da NF-e

**Caminho:** `nota` › `ide`  
**ID:** 5 · **Ocorrência:** 1-1 · **Linha na planilha:** 37  
**Rótulo na planilha:** Identificação NF-e  

Abertura: `--ide_ini--;` · Fechamento: `--ide_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 6 | `cUF` | Código da UF do emitente do Documento Fiscal | Numérico | 1-1 | 2 | — | Código da UF do emitente do Documento Fiscal. <br>Utilizar a Tabela do IBGE de código de unidades da federação (Anexo IX - Tabela de UF, Município e País). | Se o modelo for igual a 65 -NFC- e a cUF de emissão informada não existe no layout de integração, será  interrompido o processamento e colocado no status de Erro, apresentando a mensagem: 999-Erro Geral (Layout de Integração NFC-e 4.00 não existe para UF de destino:<cód da UF>) |
| 7 | `cNF` | Código Numérico que compõe a Chave de Acesso | Numérico | 1-1 | 8 | — | Código numérico que compõe a Chave de Acesso. <br>Número aleatório gerado pelo emitente para cada NF-e para evitar acessos indevidos da NF-e . | — |
| 8 | `natOp` | Descrição da Natureza da Operação | Caractere | 1-1 | 1-60 | — | Informar a natureza da operação de que decorrer a saída ou a entrada, tais como: venda, compra, transferência, devolução, importação, consignação, remessa (para fins de demonstração, de industrialização ou outra), conforme previsto na alínea 'i', inciso I, art. 19 do CONVÊNIO S/Nº, de 15 de dezembro de 1970. | — |
| 10 | `mod` | Código do Modelo do Documento Fiscal | Numérico | 1-1 | 2 | — | 55 - NF-e emitida em substituição ao modelo 1 ou 1A;<br>65 - NFC-e, utilizada nas operações de venda no varejo (a critério da UF aceitar este modelo de documento). | — |
| 11 | `serie` | Série do Documento Fiscal | Numérico | 1-1 | 1-3 | — | Série do Documento Fiscal, preencher com zeros na hipótese de a NF-e não possuir série .<br>Série 890-899: uso exclusivo para emissão de NF-e avulsa, pelo contribuinte com seu certificado digital, através do site do Fisco (procEmi=2).<br>Série 900-999: uso exclusivo de NF-e emitidas no SCAN . | — |
| 12 | `nNF` | Número do Documento Fiscal | Numérico | 1-1 | 1-9 | — | Número do Documento Fiscal | — |
| 13 | `dhEmi` | Data e hora de emissão do Documento Fiscal | Data | 0-1 | — | — | Data e hora no formato UTC (Universal Coordinated Time): AAAA-MM-DDThh:mm:ssTZD | Quando informada somente a data e hora, o sistema  o complementará com o Time zone de Origem. Quando não informada a data e hora, o sistema irá assumir a data de hora do momento da integração e complementará com o Time zone de Origem. |
| 14 | `dhSaiEnt` | Data e hora de Saída ou da Entrada da Mercadoria/Produto | Data | 0-1 | — | — | Data e hora no formato UTC (Universal Coordinated Time): AAAA-MM-DDThh:mm:ssTZD.<br>Nota: Não informar este campo para a NFC-e. | Quando informada somente a data e hora, o sistema  o complementará com o Time zone de Origem. |
| 14a | `dPrevEntrega` | Data da previsão de entrega ou disponibilização do bem. | Data | 0-1 | 10 | — | Formato: “AAAA-MM-DD”<br>Observação: Não informar este campo para a NFC-e. | — |
| 15 | `tpNF` | Tipo de Operação | Numérico | 1-1 | 1 | — | 0 - Entrada;<br>1  - Saída. | — |
| 15a | `idDest` | Identificador de local de destino da operação | Numérico | 1-1 | 1 | — | 1  - Operação interna;<br>2 - Operação interestadual;<br>3 - Operação com exterior. | — |
| 16 | `cMunFG` | Código do Município de Ocorrência do Fato Gerador do ICMS | Numérico | 1-1 | 7 | — | Informar o município de ocorrência do fato gerador do ICMS. Utilizar tabela do IBGE (Anexo IX - Tabela de UF, Município e País) | — |
| 16a | `cMunFGIBS` | Código do Município de consumo, fato gerador do IBS / CBS | Numérico | 0-1 | 7 | — | Informar o município de ocorrência do fato gerador do fato gerador do IBS / CBS.<br>Campo preenchido somente quando “indPres = 5 (Operação presencial, fora do estabelecimento) ”, e não tiver endereço do destinatário (Grupo: E05) ou local de entrega (Grupo: G01) | — |
| 25 | `tpImp` | Formato de impressão do DANFE | Numérico | 1-1 | 1 | — | 0 - Sem geração de DANFE;<br>1  - DANFE normal, Retrato;<br>2 - DANFE normal, Paisagem;<br>3 - DANFE Simplificado;<br>4 - DANFE NFC-e;<br>5 - DANFE NFC-e em mensagem eletrônica (o envio de mensagem eletrônica pode ser feita de forma simultânea com a impressão do DANFE; usar o tpImp= 5 quando esta for a única forma de disponibilização do DANFE).<br>6 - DANFE Simplificado Tipo 2 (nas condições do Ajuste SINIEF 13/26)<br>ATENÇÃO: Para NF-e nós iremos considerar o que estiver no cadastro da empresa, no parâmetro "Formato de Impressão".<br>Já para NFC-e iremos considerar o que for informado neste campo, no arquivo de integração. | — |
| 26 | `tpEmis` | Forma de Emissão da NF-e | Numérico | 1-1 | 1 | — | 1 - Emissão normal (não em contingência);<br>2 - Contingência FS com impressão do DANFE em Formulário de Segurança - Impressor Autônomo; <br>4 - Contingência EPEC (Evento Prévio da Emissão em Contingência);<br>5 - Contingência FS-DA, com impressão do DANFE em Formulário de Segurança - Documento Auxiliar;<br>6 - Contingência SVC-AN (SEFAZ Virtual de Contingência do AN);<br>7 - Contingência SVC-RS (SEFAZ Virtual de Contingência do RS);<br>9 - Contingência off-line da NFC-e e da NF-e com DANFE Simplificado Tipo 2;<br>Nota: Para NFC-e somente é válida a opção de contingência  9-Contingência Off-line e, a critério da UF, a opção 4-Contingência EPEC. (NT2015/002) | — |
| 27 | `cDV` | Dígito Verificador da Chave de Acesso da NF-e | Numérico | 1-1 | 1 | — | Informar o DV da Chave de Acesso da NF-e, o DV será calculado com a aplicação do algoritmo módulo 11, base 2,9, da Chave de Acesso. (vide item 5 do Manual de Orientação) | — |
| 28 | `tpAmb` | Identificação do Ambiente | Numérico | 1-1 | 1 | — | 1  - Produção; <br>2 - Homologação. | — |
| 29 | `finNFe` | Finalidade de emissão da NF-e | Numérico | 1-1 | 1 | — | 1 - NF-e normal;<br>2 - NF-e complementar;<br>3 - NF-e de ajuste;<br>4 - Devolução de mercadoria;<br>5 - Nota de crédito;<br>6 - Nota de débito; | — |
| 29.1 | `tpNFDebito` | Tipo de Nota de Débito | Numérico | 0-1 | 2 | — | 01  - Transferência de créditos para Cooperativas; <br>02 - Anulação de Crédito por Saídas Imunes/Isentas; <br>03 - Débitos de notas fiscais não processadas na apuração; <br>04 - Multa e juros; <br>05 - Transferência de crédito de sucessão.<br>06 - Pagamento antecipado; <br>07 - Perda em estoque (Perecimento, Perda, Furto, Roubo);<br>08 - Desenquadramento do SN; | — |
| 29.2 | `tpNFCredito` | Tipo de Nota de Crédito | Numérico | 0-1 | 2 | — | 01 - Multa e juros<br>02 - Apropriação de crédito presumido de IBS sobre o saldo devedor na ZFM (art. 450, § 1º, LC 214/25)<br>03 - Retorno por recusa total na entrega ou por não localização do <br>destinatário na tentativa de entrega;<br>04 - Redução de valores;<br>05 - Transferência de crédito na sucessão;<br>06 - Retorno por recusa parcial na entrega; | — |
| 29.3 | `indFinal` | Indica operação com Consumidor final | Numérico | 1-1 | 1 | — | 0 - Normal;<br>1  - Consumidor final. | — |
| 29.4 | `indPres` | Indicador de presença do comprador no estabelecimento comercial no momento da operação | Numérico | 1-1 | 1 | — | 0 - Não se aplica (por exemplo, Nota Fiscal complementar ou de ajuste);<br>1  - Operação presencial;<br>2 - Operação não presencial, pela Internet;<br>3 - Operação não presencial, Tele atendimento;<br>4 - Operação não presencial com NFC-e e NFe com DANFE Simplificado Tipo 2 (com entrega)<br>5 - Operação presencial, fora do estabelecimento;<br>9 - Operação não presencial, outros. | Observar regras da NT 2020.006. |
| 29.5 | `indIntermed` | Indicador de intermediador/marketplace | Numérico | 0-1 | 1 | — | 0 - Operação sem intermediador (em site ou plataforma<br>própria)<br>1 - Operação em site ou plataforma de terceiros<br>(intermediadores/marketplace) | Observar regras da NT 2020.006. |
| 29a | `procEmi` | Processo de emissão a NF-e | — | 1-1 | 1 | — | 0 - Emissão de NF-e com aplicativo do contribuinte;<br>1  - Emissão de NF-e avulsa pelo Fisco;<br>2 - Emissão de NF-e avulsa, pelo contribuinte com seu certificado digital, através do site do Fisco;<br>3 - Emissão NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.<br>4 - Emissão de NF-e por Provedor de Assinatura e Autorização - PAA | — |
| 29b | `verProc` | Versão do Processo de emissão da NF-e | Caractere | 1-1 | 1-20 | — | Informar a versão do aplicativo emissor de NF-e | — |
| 29.6 | `cIndOp` | Código indicador do local da operação de <br>fornecimento | Numérico | 0-1 | 6 | — | Preenchimento obrigatório no caso de: <br> - Leilão judicial ou Licitação promovida pelo poder público <br>(cIndOp=010104) <br> - Constatação de irregularidade pela falta de documentação fiscal ou pelo acobertamento por documentação inidônea (cIndOp=010105) <br>Observação: Consultar tabela “Código Indicador do Local de <br>Operação”. | — |

➡️ Sub-bloco: [`x_contingencia`](#x_contingencia) — Sequência XML (0-1)

➡️ Sub-bloco: [`gCompraGov`](#gcompragov) — Grupo de Compra Governamental (0-1)

➡️ Sub-bloco: [`gPagAntecipado`](#gpagantecipado) — Grupo de notas de antecipação de pagamento (0-99)

➡️ Sub-bloco: [`nfReferenciada`](#nfreferenciada) — Informação de Documentos Fiscais referenciados (0-999)

<a id="x_contingencia"></a>

##### `x_contingencia` — Sequência XML

**Caminho:** `nota` › `ide` › `x_contingencia`  
**ID:** 29b.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 64  
**Rótulo na planilha:** Contingência  

> Grupo opcional.

Abertura: `--x_contingencia_ini--;` · Fechamento: `--x_contingencia_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 29c | `dhCont` | data e hora da entrada em contingência | Data | 1-1 | — | — | Data e hora no formato UTC (Universal Coordinated Time): AAAA-MM-DDThh:mm:ssTZD | Nos casos nos quais o Sistema de Origem decidir por contingência esse campo deverá ser informado. |
| 29d | `xJust` | Justificativa da entrada em contingencia | Caractere | 1-1 | 15-256 | — | — | Nos casos nos quais o Sistema de Origem decidir por contingência esse campo deverá ser informado. |

<a id="gcompragov"></a>

##### `gCompraGov` — Grupo de Compra Governamental

**Caminho:** `nota` › `ide` › `gCompraGov`  
**ID:** 29.z1 · **Ocorrência:** 0-1 · **Linha na planilha:** 68  
**Rótulo na planilha:** Compra Governamental  

> Grupo opcional.

Abertura: `--gCompraGov_ini--;` · Fechamento: `--gCompraGov_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 29.z2 | `tpEnteGov` | Tipo de ente governamental | Numérico | 1-1 | 1 | — | Para administração pública direta e suas autarquias e fundações: <br>1 - União <br>2 - Estado <br>3 - Distrito Federal <br>4 - Município <br>5 - Consórcio Público <br>6 - Comitê Gestor do IBS | — |
| 29.z3 | `pRedutor` | Percentual de redução de aliquota em compra governamental | Numérico | 1-1 | 7 | 2-4 | Conforme o art. 473 da LC 214/2025. | 7 posições, sendo 3 inteiros e 2 a 4 decimais. |
| 29.z4 | `tpOperGov` | Tipo de operação com o ente governamental | Numérico | 1-1 | 1 | — | 1 - Fornecimento com pagamento posterior; <br>2 - Recebimento do pagamento com fornecimento já realizado; <br>3 - Fornecimento com pagamento já realizado; <br>4 - Recebimento do pagamento com fornecimento posterior; | — |

➡️ Sub-bloco: [`ref_NFe`](#ref_nfe) — Chave de acesso do documento fiscal anterior (0-99)

<a id="ref_nfe"></a>

###### `ref_NFe` — Chave de acesso do documento fiscal anterior

**Caminho:** `nota` › `ide` › `gCompraGov` › `ref_NFe`  
**ID:** 29.z5a · **Ocorrência:** 0-99 · **Linha na planilha:** 72  

Abertura: `--ref_NFe_ini--;` · Fechamento: `--ref_NFe_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 29.z5 | `refDFeAnt` | Chave de acesso do documento fiscal <br>anterior | Caractere | 1-1 | 44 | — | — | — |

<a id="gpagantecipado"></a>

##### `gPagAntecipado` — Grupo de notas de antecipação de pagamento

**Caminho:** `nota` › `ide` › `gPagAntecipado`  
**ID:** 29.y1 · **Ocorrência:** 0-99 · **Linha na planilha:** 76  
**Rótulo na planilha:** Notas de antecipação de pagamento  

> Grupo opcional.<br>No xml será formatado como esta no schema, apenas um grupo gPagAntecipado será adicionado, com todas as refNFe informadas em todos os grupos gPagAntecipado informados no layout.

Abertura: `--gPagAntecipado_ini--;` · Fechamento: `--gPagAntecipado_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 29.y2 | `refNFe` | Chave de acesso da NF-e de antecipação de pagamento | Caractere | 1-1 | 44 | — | Referência uma NF-e (modelo 55) emitida anteriormente, referente a pagamento antecipado | — |

<a id="nfreferenciada"></a>

##### `nfReferenciada` — Informação de Documentos Fiscais referenciados

**Caminho:** `nota` › `ide` › `nfReferenciada`  
**ID:** 29x.1 · **Ocorrência:** 0-999 · **Linha na planilha:** 79  
**Rótulo na planilha:** Documentos Fiscais Referenciados  

> Grupo com informações de Documentos Fiscais referenciados. <br>Informação utilizada nas hipóteses previstas na legislação. (Ex.: Devolução de Mercadorias, Substituição de NF cancelada, Complementação de NF, etc.).

Abertura: `--nfReferenciada_ini--;` · Fechamento: `--nfReferenciada_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 29x.2 | `refNFe` | Chave de acesso das NF-e referenciadas | Caractere | 1-1 | 44 | — | Referencia uma NF-e (modelo 55) emitida anteriormente, vinculada a NF-e atual, ou uma NFC-e (modelo 65). | CE – Choice Element (escolha entre elementos), |
| 29x.2a | `refNFeSig` | Chave da NF-e com o código numérico zerado | Caractere | 1-1 | 44 | — | Referencia uma NF-e (modelo 55) emitida anteriormente pela sua Chave de Acesso com código numérico zerado, permitindo manter o sigilo da NF-e referenciada. | CE – Choice Element (escolha entre elementos), |

➡️ Sub-bloco: [`ref_NFe`](#ref_nfe-1) — Informação da NF modelo 1/1A  ou NF modelo 2 referenciada (1-1)

➡️ Sub-bloco: [`ref_NFP`](#ref_nfp) — Informações da NF de Produtor rural referenciada (1-1)

*Continuação dos campos de `nfReferenciada` (após o fechamento de `ref_NFP`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 29x.19 | `refCTe` | Chave de acesso do CT-e referenciado | Caractere | 0-1 | 44 | — | Utilizar este campo para referenciar um CT-e emitido anteriormente, vinculado a NF-e atual | — |

➡️ Sub-bloco: [`ref_ECF`](#ref_ecf) — Informações do Cupom Fiscal referenciado (1-1)

<a id="ref_nfe-1"></a>

###### `ref_NFe` — Informação da NF modelo 1/1A  ou NF modelo 2 referenciada

**Caminho:** `nota` › `ide` › `nfReferenciada` › `ref_NFe`  
**ID:** 29x.3 · **Ocorrência:** 1-1 · **Linha na planilha:** 82  
**Rótulo na planilha:** NF Modelo 1/1A  

Abertura: `--ref_NFe_ini--;` · Fechamento: `--ref_NFe_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 29x.4 | `cUF` | Código da UF do emitente do Documento Fiscal | Numérico | 1-1 | 2 | — | Utilizar tabela do IBGE (Anexo IX - Tabela de UF, Município e País) | — |
| 29x.5 | `AAMM` | Ano e Mês de emissão da NF | Numérico | 1-1 | 4 | — | AAMM da emissão da NF | — |
| 29x.6 | `CNPJ` | CNPJ do emitente da NF | Caractere | 1-1 | 14 | — | — | — |
| 29x.7 | `Mod` | Modelo do Documento Fiscal | Numérico | 1-1 | 2 | — | 01 - Modelo 01<br>02 -Modelo 02 | — |
| 29x.8 | `serie` | Série do Documento Fiscal(0para inexistente) | Numérico | 1-1 | 1-3 | — | Informar zero se não utilizada Série do documento fiscal. | — |
| 29x.9 | `nNF` | Número do Documento Fiscal | Numérico | 1-1 | 1-9 | — | Faixa: 1-999999999 | — |

<a id="ref_nfp"></a>

###### `ref_NFP` — Informações da NF de Produtor rural referenciada

**Caminho:** `nota` › `ide` › `nfReferenciada` › `ref_NFP`  
**ID:** 29x.10 · **Ocorrência:** 1-1 · **Linha na planilha:** 90  
**Rótulo na planilha:** NF de Produtor Rural  

Abertura: `--ref_NFP_ini--;` · Fechamento: `--ref_NFP_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 29x.11 | `cUF` | Código da UF do emitente do Documento Fiscal | Numérico | 1-1 | 2 | — | Utilizar tabela do IBGE (Anexo IX - Tabela de UF, Município e País) | — |
| 29x.12 | `AAMM` | Ano e Mês de emissão da NF de Produtor | Numérico | 1-1 | 4 | — | AAMM da emissão da NF de produtor | — |
| 29x.13 | `CNPJ` | CNPJ do emitente da NF de Produtor | Caractere | 1-1 | 14 | — | — | — |
| 29x.14 | `CPF` | CPF do emitente da NF de Produtor | Caractere | 1-1 | 11 | — | — | — |
| 29x.15 | `IE` | IE do emitente da NF de Produtor | Caractere | 1-1 | 1-14 | — | Informar a IE do emitente da NF de Produtor ou o literal "ISENTO" | — |
| 29x.16 | `mod` | Modelo do Documento Fiscal | Numérico | 1-1 | 2 | — | 01  - NF;<br>04 - NF de Produtor. | — |
| 29x.17 | `serie` | Série do Documento Fiscal | Numérico | 1-1 | 1-3 | — | Informar zero se não utilizada Série do documento fiscal. | — |
| 29x.18 | `nNF` | Número do documento Fiscal | Numérico | 1-1 | 1-9 | — | Faixa: 1-999999999 | — |

<a id="ref_ecf"></a>

###### `ref_ECF` — Informações do Cupom Fiscal referenciado

**Caminho:** `nota` › `ide` › `nfReferenciada` › `ref_ECF`  
**ID:** 29x.20 · **Ocorrência:** 1-1 · **Linha na planilha:** 101  
**Rótulo na planilha:** Cupom Fiscal  

> Grupo do Cupom Fiscal vinculado à NF-e

Abertura: `--ref_ECF_ini--;` · Fechamento: `--ref_ECF_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 29x.21 | `mod` | Modelo do Documento Fiscal | Caractere | 1-1 | 2 | — | 2B - Quando se tratar de Cupom Fiscal emitido por máquina registradora (não ECF);<br>2C -  Quando se tratar de Cupom Fiscal PDV;<br>2D - Quando se tratar de Cupom Fiscal (emitido por ECF). | — |
| 29x.22 | `nECF` | Número de ordem sequencial do ECF | Numérico | 1-1 | 3 | — | Informar o número de ordem sequencial do ECF que emitiu o Cupom Fiscal vinculado à NF-e | — |
| 29x.23 | `nCOO` | Numero do contador de ordem de operação – COO | Numérico | 1-1 | 6 | — | Informar o Número do Contador de Ordem de Operação - COO vinculado à NF-e | — |

<a id="emit"></a>

#### `emit` — Identificação do emitente da NF-e

**Caminho:** `nota` › `emit`  
**ID:** 30 · **Ocorrência:** 1-1 · **Linha na planilha:** 108  
**Rótulo na planilha:** Emitente da NF-e  

Abertura: `--emit_ini--;` · Fechamento: `--emit_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 31 | `CNPJ` | CNPJ do emitente | Caractere | 1-1 | 14 | — | Informar o CNPJ do emitente. <br>Na emissão de NF-e avulsa pelo Fisco, as informações do remetente serão informadas neste grupo. <br>O CNPJ ou CPF deverão ser informados com os zeros não significativos. | — |
| 31a | `CPF` | CPF do emitente | Numérico | 1-1 | 11 | — | — | — |
| 32 | `xNome` | Razão Social ou Nome do emitente | Caractere | 1-1 | 2-60 | — | — | — |
| 33 | `xFant` | Nome Fantasia | Caractere | 0-1 | 1-60 | — | — | — |

➡️ Sub-bloco: [`ender_Emit`](#ender_emit) — Endereço do emitente (1-1)

*Continuação dos campos de `emit` (após o fechamento de `ender_Emit`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 46 | `IE` | IE | Caractere | 1-1 | 2-14 | — | Informar somente os algarismos, sem os caracteres de formatação (ponto, barra, hífen, etc.).<br>Nota: Na emissão de NF-e Avulsa pode ser informado o literal "ISENTO" para os contribuintes do ICMS isentos de inscrição no Cadastro de Contribuintes de ICMS. | — |
| 47 | `IEST` | IE do Substituto do Tributário | Caractere | 0-1 | 2-14 | — | IE do Substituto Tributário da UF de destino da mercadoria, quando houver a retenção do ICMS ST para a UF de destino. | — |

➡️ Sub-bloco: [`x_emitente`](#x_emitente) — Sequência XML (0-1)

*Continuação dos campos de `emit` (após o fechamento de `x_emitente`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 49a | `CRT` | Código de regime tributário | Numérico | 1-1 | 1 | — | 1  - Simples Nacional;<br>2 - Simples nacional - excesso de sublimite de receita bruta;<br>3 - Regime normal. <br>4 - Simples Nacional - Microempreendedor individual - MEI. | — |
| 49d | `ISUFEmit` | Inscrição do emitente da Suframa | Caractere | 0-1 | 8-9 | — | Informar o número do Cadastro do emitente na Suframa. Campo <br>obrigatório nas operações que se beneficiam de incentivos fiscais <br>existentes nas áreas sob controle da SUFRAMA com alíquota zero <br>da CBS referente aos arts. 451 e 466 da LC 214/25 | — |

<a id="ender_emit"></a>

##### `ender_Emit` — Endereço do emitente

**Caminho:** `nota` › `emit` › `ender_Emit`  
**ID:** 34 · **Ocorrência:** 1-1 · **Linha na planilha:** 113  
**Rótulo na planilha:** Endereço do Emitente  

Abertura: `--ender_Emit_ini--;` · Fechamento: `--ender_Emit_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 35 | `xLgr` | Logradouro | Caractere | 1-1 | 2-60 | — | — | — |
| 36 | `nro` | Número | Caractere | 1-1 | 1-60 | — | — | — |
| 37 | `xCpl` | Complemento | Caractere | 0-1 | 1-60 | — | — | — |
| 38 | `xBairro` | Bairro | Caractere | 1-1 | 2-60 | — | — | — |
| 39 | `cMun` | Código do Município | Numérico | 1-1 | 7 | — | Utilizar tabela do IBGE (Anexo IX - Tabela de UF, Município e País). | — |
| 40 | `xMun` | Nome do município | Caractere | 1-1 | 2-60 | — | — | — |
| 41 | `UF` | Sigla da UF | Caractere | 1-1 | 2 | — | — | — |
| 42 | `CEP` | CEP | Numérico | 1-1 | 8 | — | Informar os zeros não significativos. (NT 2011/004) | — |
| 43 | `cPais` | Código do País | Numérico | 0-1 | 4 | — | Utilizar tabela BACEN<br>1058 - Brasil | — |
| 44 | `xPais` | Nome do País | Caractere | 0-1 | 1-60 | — | Brasil ou BRASIL | — |
| 45 | `fone` | Telefone | Numérico | 0-1 | 6-14 | — | Preencher com o Código DDD + número do telefone. <br>Nas operações com o exterior é permitido informar o código do país + código da localidade + número do telefone | — |

<a id="x_emitente"></a>

##### `x_emitente` — Sequência XML

**Caminho:** `nota` › `emit` › `x_emitente`  
**ID:** 47.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 128  
**Rótulo na planilha:** XML - Emitente  

> Grupo opcional.

Abertura: `--x_emitente_ini--;` · Fechamento: `--x_emitente_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 48 | `IM` | Código de Inscrição Municipal | Caractere | 1-1 | 1-15 | — | Informado na emissão de NF-e conjugada, com itens de produtos sujeitos ao ICMS e itens de serviços sujeitos ao ISSQN. | — |
| 49 | `CNAE` | CNAE fiscal | Caractere | 0-1 | 7 | — | Campo Opcional. Pode ser informado quando a Inscrição Municipal for informada. | — |

<a id="avulsa"></a>

#### `avulsa` — Fisco Emitente da NF-e (Avulsa)

**Caminho:** `nota` › `avulsa`  
**ID:** 50 · **Ocorrência:** 0-1 · **Linha na planilha:** 135  

> Informações do fisco emitente (uso exclusivo do fisco)

Abertura: `--avulsa_ini--;` · Fechamento: `--avulsa_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 51 | `CNPJ` | CNPJ do emitente | Caractere | 1-1 | 14 | — | Informar os zeros não significativos. | — |
| 52 | `xOrgao` | Órgão Emitente | Caractere | 1-1 | 1-60 | — | — | — |
| 53 | `matr` | Matrícula do agente | Caractere | 1-1 | 1-60 | — | — | — |
| 54 | `xAgente` | Nome do agente | Caractere | 1-1 | 1-60 | — | — | — |
| 55 | `fone` | Telefone | Numérico | 0-1 | 6-14 | — | Preencher com o Código DDD + número do telefone | — |
| 56 | `UF` | Sigla da UF | Caractere | 1-1 | 2 | — | — | — |
| 57 | `nDAR` | Número do Documento de Arrecadação de Receita | Caractere | 0-1 | 1-60 | — | (NT 2011/004) | — |
| 58 | `dEmi` | Data de emissão do Documento de Arrecadação | Data | 0-1 | — | — | Formato "AAAA-MM-DD" (NT 2011/004) | — |
| 59 | `vDAR` | Valor Total constante no Documento de arrecadação de Receita | Numérico | 0-1 | 1-15 | 2 | — | — |
| 60 | `repEmi` | Repartição Fiscal emitente | Caractere | 1-1 | 1-60 | — | — | — |
| 61 | `dPag` | Data de pagamento do Documento de Arrecadação | Data | 0-1 | — | — | Formato "AAAA-MM-DD" | — |

<a id="dest"></a>

#### `dest` — Identificação do Destinatário da NF-e

**Caminho:** `nota` › `dest`  
**ID:** 62 · **Ocorrência:** 0-1 · **Linha na planilha:** 148  
**Rótulo na planilha:** Destinatário da NF-e  

> Grupo obrigatório para a NF-e (modelo 55)

Abertura: `--dest_ini--;` · Fechamento: `--dest_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 63 | `CNPJ` | CNPJ do destinatário | Caractere | 1-1 | 14 | — | Informar o CNPJ ou CPF do destinatário, preenchendo os zeros não significativos. <br>No caso de operação com o exterior, ou para comprador estrangeiro informar a tag "idEstrangeiro", com o número do passaporte ou outro documento legal para identificar pessoa estrangeira (este campo aceita valor Nulo). <br>Obs.: A tag "idEstrangeiro" aceita algarismos, letras (maiúsculas e minúsculas) e os caracteres do conjunto que segue: [:.+-()] - (NT2015/002) | — |
| 64 | `CPF` | CNPJ do destinatário | Numérico | 1-1 | 11 | — | — | — |
| 64a | `idEstrangeiro` | Identificação do destinatário no caso de comprador estrangeiro | Caractere | 1-1 | 0, 5-20 | — | — | — |
| 65 | `xNome` | Razão Social ou nome do destinatário | Caractere | 0-1 | 2-60 | — | Tag obrigatória para a NF-e (modelo 55) | — |

➡️ Sub-bloco: [`ender_Dest`](#ender_dest) — Endereço do Destinatário da NF-e (0-1)

*Continuação dos campos de `dest` (após o fechamento de `ender_Dest`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 77a | `indIEDest` | Indicador da IE do Destinatário | Numérico | 1-1 | 1 | — | 1 - Contribuinte ICMS (informar a IE do destinatário);<br>2 - Contribuinte isento de Inscrição no cadastro de Contribuintes do ICMS;<br>9 - Não Contribuinte, que pode ou não possuir Inscrição Estadual no Cadastro de Contribuintes do ICMS.<br>Nota 1: No caso de NFC-e informar indIEDest=9 e não informar a tag IE do destinatário;<br>Nota 2: No caso de operação com o Exterior informar indIEDest=9 e não informar a tag IE do destinatário;<br>Nota 3: No caso de Contribuinte Isento de Inscrição (indIEDest=2), não informar a tag IE do destinatário. | — |
| 78 | `IE` | IE do Destinatário | Numérico | 0-1 | 2-14 | — | Campo opcional. Informar somente os algarismos, sem os caracteres de formatação (ponto, barra hífen, etc.) | — |
| 79 | `ISUF` | Inscrição na SUFRAMA(Obrigatório nas operações sob controle da SUFRAMA) | Caractere | 0-1 | 8-9 | — | Obrigatório, nas operações que se beneficiam de incentivos fiscais existentes nas áreas sob controle da SUFRAMA. <br>A omissão da Inscrição SUFRAMA impede o processamento da operação pelo Sistema de Mercadoria Nacional da SUFRAMA e a liberação da Declaração de Ingresso, prejudicando a comprovação do ingresso/internamento da mercadoria nas áreas sob controle da SUFRAMA. | — |
| 79.1 | `IM` | Inscrição Municipal do Tomador do Serviço | Caractere | 0-1 | 1-15 | — | Campo opcional. Pode ser informado na NF-e conjugada, com itens de produtos sujeitos ao ICMS e itens de serviços sujeitos ao ISSQN. | — |
| 79a | `email` | e-mail | Caractere | 0-1 | 1-60 | — | Campo pode ser utilizado para informar o e-mail de recepção da NF-e indicada pelo destinatário. | Para informar mais de um e-mail, os mesmos deverão ser separados SOMENTE por , (vírgula).<br>Quando usado vírgula como separador, o DFE registra apenas o primeiro e-mail no XML e envia e-mail para todos os e-mails informados neste campo. <br>Se o primeiro e-mail informado contiver mais de 60 caracteres, o XML poderá ser rejeitado pela SEFAZ. |

<a id="ender_dest"></a>

##### `ender_Dest` — Endereço do Destinatário da NF-e

**Caminho:** `nota` › `dest` › `ender_Dest`  
**ID:** 66 · **Ocorrência:** 0-1 · **Linha na planilha:** 153  
**Rótulo na planilha:** Endereço do Destinatário  

> Grupo obrigatório para a NF-e (modelo 55)

Abertura: `--ender_Dest_ini--;` · Fechamento: `--ender_Dest_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 67 | `xLgr` | Logradouro | Caractere | 1-1 | 2-60 | — | — | — |
| 68 | `nro` | Número | Caractere | 1-1 | 1-60 | — | — | — |
| 69 | `xCpl` | Complemento | Caractere | 0-1 | 1-60 | — | — | — |
| 70 | `xBairro` | Bairro | Caractere | 1-1 | 2-60 | — | — | — |
| 71 | `cMun` | Código do município | Numérico | 1-1 | 7 | — | Utilizar tabela do IBGE (Anexo IX - Tabela de UF, Município e País). <br>Informar "9999999" para operações com o  exterior. | — |
| 72 | `xMun` | Nome do município | Caractere | 1-1 | 2-60 | — | Informar "EXTERIOR" para operações com Exterior | — |
| 73 | `UF` | Sigla da UF | Caractere | 1-1 | 2 | — | Informar "EX" para operações com Exterior | — |
| 74 | `CEP` | CEP | Numérico | 0-1 | 8 | — | Informar os zeros não significativos | — |
| 75 | `cPais` | Código do País | Numérico | 0-1 | 2-4 | — | Utilizar tabela BACEN<br>1058 - Brasil | — |
| 76 | `xPais` | Nome do País | Caractere | 0-1 | 2-60 | — | — | — |
| 77 | `fone` | Telefone | Numérico | 0-1 | 6-14 | — | Preencher com o Código DDD + número do telefone. <br>Nas operações com o exterior é permitido informar o código do país + código da localidade + número do telefone. | — |

<a id="retirada"></a>

#### `retirada` — Identificação do Local de retirada

**Caminho:** `nota` › `retirada`  
**ID:** 80 · **Ocorrência:** 0-1 · **Linha na planilha:** 172  
**Rótulo na planilha:** Local de Retirada  

> Informar somente se diferente do endereço do remetente

Abertura: `--retirada_ini--;` · Fechamento: `--retirada_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 81 | `CNPJ` | informar o CNPJ | Caractere | 1-1 | 0 ou 14 | — | Informar CNPJ ou o CPF. <br>Preencher os zeros não significativos. | — |
| 81a | `CPF` | Informar o CPF | Numérico | 1-1 | 11 | — | — | — |
| 81b | `xNome` | Razão Social ou Nome do Expedidor | Caractere | 0-1 | 2-60 | — | — | — |
| 82 | `xLgr` | Logradouro | Caractere | 1-1 | 2-60 | — | — | — |
| 83 | `nro` | Número | Caractere | 1-1 | 1-60 | — | — | — |
| 84 | `xCpl` | Complemento | Caractere | 0-1 | 1-60 | — | — | — |
| 85 | `xBairro` | Bairro | Caractere | 1-1 | 2-60 | — | — | — |
| 86 | `cMun` | Código do Município | Numérico | 1-1 | 7 | — | Utilizar tabela do IBGE (Anexo IX - Tabela de UF, Município e País). | — |
| 87 | `xMun` | Nome do município | Caractere | 1-1 | 2-60 | — | Informar "EXTERIOR" para operações com Exterior | — |
| 88 | `UF` | Sigla da UF | Caractere | 1-1 | 2 | — | Informar "EX" para operações com Exterior | — |
| 88a | `CEP` | Código do CEP | Numérico | 0-1 | 8 | — | Preencher os zeros não significativos. | — |
| 88b | `cPais` | Código do País | Numérico | 0-1 | 4 | — | Utilizar tabela BACEN<br>1058 - Brasil | — |
| 88c | `xPaís` | Nome do País | Caractere | 0-1 | 2-60 | — | — | — |
| 88d | `fone` | Telefone | Numérico | 0-1 | 6-14 | — | Preencher com o Código DDD + número do telefone. <br>Nas operações com o exterior é permitido informar o código do país + código da localidade + número do telefone. | — |
| 88e | `email` | E-mail do expedidor | Caractere | 0-1 | 1-60 | — | — | — |
| 88f | `IE` | Inscrição Estadual do Estabelecimento Expedidor | Numérico | 0-1 | 2-14 | — | Informar somente os algarismos, sem os caracteres de formatação (ponto, barra, hífen, etc.). | — |

<a id="entrega"></a>

#### `entrega` — Identificação do Local de entrega

**Caminho:** `nota` › `entrega`  
**ID:** 89 · **Ocorrência:** 0-1 · **Linha na planilha:** 190  
**Rótulo na planilha:** Local de Entrega  

> Informar somente se diferente do endereço do destinatário

Abertura: `--entrega_ini--;` · Fechamento: `--entrega_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 90 | `CNPJ` | CNPJ | Caractere | 1-1 | 0 ou 14 | — | Informar CNPJ ou o CPF. Preencher os zeros não significativos. | — |
| 90a | `CPF` | CPF | Numérico | 1-1 | 11 | — | — | — |
| 90b | `xNome` | Razão Social ou Nome do Recebedor | Caractere | 0-1 | 2-60 | — | — | — |
| 91 | `xLgr` | Logradouro | Caractere | 1-1 | 2-60 | — | — | — |
| 92 | `nro` | Número | Caractere | 1-1 | 1-60 | — | — | — |
| 93 | `xCpl` | Complemento | Caractere | 0-1 | 1-60 | — | — | — |
| 94 | `xBairro` | Bairro | Caractere | 1-1 | 1-60 | — | — | — |
| 95 | `cMun` | Código do Município | Numérico | 1-1 | 7 | — | Utilizar tabela do IBGE (Anexo IX - Tabela de UF, Município e País). | — |
| 96 | `xMun` | Nome do município | Caractere | 1-1 | 2-60 | — | Informar "EXTERIOR" para operações com Exterior | — |
| 97 | `UF` | Sigla da UF | Caractere | 1-1 | 2 | — | Informar "EX" para operações com Exterior | — |
| 97a | `CEP` | Código do CEP | Numérico | 0-1 | 8 | — | Preencher os zeros não significativos. | — |
| 97b | `cPais` | Código do País | Numérico | 0-1 | 4 | — | Utilizar tabela BACEN<br>1058 - Brasil | — |
| 97c | `xPais` | Nome do Pais | Caractere | 0-1 | 2-60 | — | — | — |
| 97d | `fone` | Telefone | Numérico | 0-1 | 6-14 | — | Preencher com o Código DDD + número do telefone. <br>Nas operações com o exterior é permitido informar o código do país + código da localidade + número do telefone. | — |
| 97e | `email` | E-mail do Recebedor | Caractere | 0-1 | 1-60 | — | — | — |
| 97f | `IE` | Inscriçaõ Estadual do Estabelecimento Recebedor | Numérico | 0-1 | 2-14 | — | Informar somente os algarismos, sem os caracteres de formatação (ponto, barra, hífen, etc.). | — |

<a id="aut_xml"></a>

#### `aut_XML` — Pessoas autorizadas para o download do XML da NF-e

**Caminho:** `nota` › `aut_XML`  
**ID:** 97a.1 · **Ocorrência:** 0-10 · **Linha na planilha:** 208  
**Rótulo na planilha:** Autorizados a obter XML  

Abertura: `--aut_XML_ini--;` · Fechamento: `--aut_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 97a.2 | `CNPJ` | CNPJ Autorizado | Caractere | 1-1 | 14 | — | Informar CNPJ ou o CPF. Preencher os zeros não significativos. | — |
| 97a.3 | `CPF` | CPF Autorizado | Numérico | 1-1 | 11 | — | — | — |

<a id="item_nota"></a>

#### `item_nota` — Itens da nota

**Caminho:** `nota` › `item_nota`  
**Ocorrência:** 1-900 · **Linha na planilha:** 212  

Abertura: `--item_nota_ini--;` · Fechamento: `--item_nota_fim--;`

➡️ Sub-bloco: [`det`](#det) — Detalhamento de Produtos e Serviços (1-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="det"></a>

##### `det` — Detalhamento de Produtos e Serviços

**Caminho:** `nota` › `item_nota` › `det`  
**ID:** 98 · **Ocorrência:** 1-1 · **Linha na planilha:** 213  

Abertura: `--det_ini--;` · Fechamento: `--det_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 99 | `nItem` | Número do item | Numérico | 1-1 | 1-3 | — | Número do item (1-900) | — |

➡️ Sub-bloco: [`prod`](#prod) — Detalhamento de Produtos e Serviços (1-1)

➡️ Sub-bloco: [`impostos`](#impostos) — Tributo incidentes no Produto ou Serviço (1-1)

➡️ Sub-bloco: [`imposto_devol`](#imposto_devol) — Informação do Imposto devolvido (0-1)

➡️ Sub-bloco: [`inf_adicionais`](#inf_adicionais) — Informações Adicionais (para o item da NF-e) (0-1)

➡️ Sub-bloco: [`vItem`](#vitem) — Valor Total do Item da NF-e (0-1)

➡️ Sub-bloco: [`DFeReferenciado`](#dfereferenciado) — Documento Fiscal Eletrônico Referenciado (0-1)

<a id="prod"></a>

###### `prod` — Detalhamento de Produtos e Serviços

**Caminho:** `nota` › `item_nota` › `det` › `prod`  
**ID:** 100 · **Ocorrência:** 1-1 · **Linha na planilha:** 215  
**Rótulo na planilha:** Produtos e Serviços  

Abertura: `--prod_ini--;` · Fechamento: `--prod_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 101 | `cProd` | Código do produto ou serviço | Caractere | 1-1 | 1-60 | — | Preencher com CFOP, caso se trate de item não relacionado com mercadorias/produtos e que o contribuinte não possua codificação própria. Formato “CFOP9999” | — |
| 102 | `cEAN` | GTIN (Global Trade Item Number) do produto, antigo código EAN ou código de barras | Caractere | 1-1 | 0,8,12,13,14 | — | Informar o código GTIN-8, GTIN-12, GTIN-13 ou GTIN-14 (antigos códigos EAN, UPC e DUN-14).<br>Para produtos que não possuem código de barras com GTIN, deve ser informado o literal “SEM GTIN”. | — |
| 102.01 | `cBarra` | Código de barras diferente do padrão GTIN | Caractere | 0-1 | 3-30 | — | Preencher com o Código de Barras próprio ou de terceiros<br>que seja diferente do padrão GTIN | — |
| 103 | `xProd` | Descrição do produto ou serviço | Caractere | 1-1 | 1-120 | — | — | — |
| 104 | `NCM` | Código NCM com 8 dígitos ou 2 dígitos (gênero) | Numérico | 1-1 | 2, 8 | — | Código NCM (8 posições), informar o gênero (posição do capítulo do NCM) quando a operação não for de comércio exterior (importação/exportação) ou o produto não seja tributado pelo IPI. <br>Em caso de item de serviço ou item que não tenha produto (Ex. transferência de crédito, crédito do ativo imobilizado, etc.), informar o código 00 (zeros) | Passou a ser obrigatório. Ou NCM completa, ou Gênero, ou 00 para Item de serviço ou que não tenha produto. |

➡️ Sub-bloco: [`nve`](#nve) — NVE (0-8)

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml) — Sequencia XML (0-1)

*Continuação dos campos de `prod` (após o fechamento de `sequencia_XML`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 104g | `cBenef` | Código de Benefício Fiscal na UF aplicado ao item | Caractere | 0-1 | 8.1 | — | Deve ser utilizado o mesmo código adotado na EFD e outras declarações, nas UF que o exigem.<br>(Incluído na NT2016.002) | Este campo pode ser preenchido com 8 ou 10 caracteres |
| 104h | `tpCredPresIBSZFM` | Classificação para subapuração do IBS na <br>ZFM | Numérico | 0-1 | 1 | — | Classificação conforme percentuais definidos no art. 450, § 1º, da <br>LC 214/25 para o cálculo do crédito presumido:<br>0 - Sem Crédito Presumido<br>1 - Bens de consumo final (55%)<br>2 - Bens de capital (75%)<br>3 - Bens intermediários (90,25%)<br>4 - Bens de informática e outros definidos em legislação (100%) | — |
| 105 | `EXTIPI` | Código EX da TIPI | Numérico | 0-1 | 2-3 | — | Preencher de acordo com o código EX da TIPI. <br>Serviço não incluir. | — |
| 107 | `CFOP` | Código Fiscal de Operações e Prestações(tabela CFOP) | Numérico | 1-1 | 4 | — | Utilizar tabela de CFOP | — |
| 108 | `uCom` | Unidade Comercial | Caractere | 1-1 | 1-6 | — | Informar a unidade de comercialização do produto. | — |
| 109 | `qCom` | Quantidade Comercial | Numérico | 1-1 | 15 | 0-4 | Informar a quantidade de comercialização do produto. | 15 posições, sendo 11 inteiros e 0 a 4 decimais. |
| 109a | `vUnCom` | Valor Unitário de comercialização | Numérico | 1-1 | 21 | 0-10 | Informar o valor unitário de comercialização do produto, campo meramente informativo, o Contribuinte pode utilizar a precisão desejada (0-10 decimais). <br>Para efeitos de cálculo, o valor unitário será obtido pela divisão do valor do produto pela quantidade comercial. | 21 posições, sendo 11 inteiros e 0 a 10 decimais. |
| 110 | `vProd` | Valor Total Bruto dos Produtos ou Serviços | Numérico | 1-1 | 15 | 2 | O valor do ICMS faz parte do Valor Total Bruto, exceto nas<br>notas de importação<br>A partir de 2027, os valores de IBS, CBS e IS compõem o Valor Total Bruto (vProd), exceto nas notas de importação. (Incluído na NT 2026.008) | 15 posições, sendo 13 inteiros e 2 decimais. |
| 111 | `cEANTrib` | GTIN( Global Trade Item Number) da unidade tributável, antigo código EAN ou código de barras | Caractere | 1-1 | 0,8,12,13,14 | — | Informar código GTIN-8, GTIN-12, GTIN-13 ou GTIN-14 (antigos códigos EAN, UPC e DUN-14) da unidade tributável do produto.<br>O GTIN da unidade tributável deve corresponder àquele da menor unidade comercializável identificada por código GTIN.<br>Para produtos que não possuem código de barras com GTIN, deve ser informado o literal "SEM GTIN”.<br>(Atualizado NT 2017.001) | — |
| 111.01 | `cBarraTrib` | Código de Barras da unidade tributável que seja diferente do padrão GTIN | Caractere | 0-1 | 3-30 | — | Preencher com o Código de Barras próprio ou de terceiros,<br>que seja diferente do padrão GTIN, correspondente àquele da menor unidade comercializável identificado por Código de Barras | — |
| 112 | `uTrib` | Unidade tributável | Caractere | 1-1 | 1-6 | — | — | — |
| 113 | `qTrib` | Quantidade Tributável | Numérico | 1-1 | 15 | 0-4 | Informar a quantidade de tributação do produto. | 15 posições, sendo 11 inteiros e 0 a 4 decimais. |
| 113a | `vUnTrib` | Valor Unitário de tributação | Numérico | 1-1 | 21 | 0-10 | Informar o valor unitário de tributação do produto, campo meramente informativo, o contribuinte pode utilizar a precisão desejada (0-10 decimais). <br>Para efeitos de cálculo, o valor unitário será obtido pela divisão do valor do produto pela quantidade tributável. | 21 posições, sendo 11 inteiros e 0 a 10 decimais. |
| 114 | `vFrete` | Valor total do frete | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais. |
| 115 | `vSeg` | Valor total do Seguro | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais. |
| 116 | `vDesc` | Valor do desconto | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais. |
| 116a | `vOutro` | outras Despesas acessórias | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais. |
| 116b | `indTot` | Indica se valor do item entra no valor total da NF-e | Numérico | 1-1 | 1 | — | 0 - Valor do item (vProd) não compõe o valor total da NF-e; <br>1  - Valor do item (vProd) compõe o valor total da NF-e. | — |
| 116c | `indBemMovelUsado` | Indicador de fornecimento de bem móvel usado: <br>1 - Bem Móvel Usado | Numérico | 0-1 | 1 | — | Somente para fornecimentos de bem móvel usado adquirido de pessoa física que não seja contribuinte ou que seja inscrita como MEI. | — |

➡️ Sub-bloco: [`gCred`](#gcred) — Grupo de informações sobre o Crédito Presumido (0-4)

➡️ Sub-bloco: [`di`](#di) — Declaração de Importação (0-100)

➡️ Sub-bloco: [`det_Export`](#det_export) — Informações de Exportação para o item (0-500)

*Continuação dos campos de `prod` (após o fechamento de `det_Export`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 128m | `xPed` | Numero do pedido de compra | Caractere | 0-1 | 1-15 | — | Informação de interesse do emissor para controle do B2B. | — |
| 128n | `nItemPed` | Item do pedido de compra | Numérico | 0-1 | 6 | — | — | — |
| 128p | `nFCI` | Número de controle da FCI - Ficha de Conteúdo de Importação | Caractere | 0-1 | 36 | — | Informação relacionada com a Resolução 13/2012 do Senado Federal. <br>Formato: Algarismo, letras maiúsculas de "A" a "F" e o caractere hífen.<br>Exemplo: B01F70AF-10BF-4B1F-848C-65FF57F616FE (NT 2013.006). | — |

➡️ Sub-bloco: [`rastro`](#rastro) — Detalhamento de produto sujeito a rastreabilidade (0-500)

➡️ Sub-bloco: [`prod_especifico`](#prod_especifico) — Sequência XML (0-1)

➡️ Sub-bloco: [`obsItem`](#obsitem) — Grupo de observações de uso livre (para o item da NF-e) (0-1)

➡️ Sub-bloco: [`sequencia_XML_liq`](#sequencia_xml_liq) — Sequência XML (0-1)

<a id="nve"></a>

###### `nve` — NVE

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `nve`  
**Ocorrência:** 0-8 · **Linha na planilha:** 221  

Abertura: `--nve_ini--;` · Fechamento: `--nve_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 104a | `NVE` | Codificação NVE - Nomenclatura de Valor Aduaneiro e Estatística. | Caractere | 0-1 | 6 | — | Codificação que detalha alguns NCM.<br>Formato: duas letras maiúsculas e 4 algarismos. Se a mercadoria se enquadrar em mais de uma codificação, informar até 8 codificações principais.<br>Vide: Anexo X - Identificador NVE. | — |

<a id="sequencia_xml"></a>

###### `sequencia_XML` — Sequencia XML

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `sequencia_XML`  
**ID:** 104b · **Ocorrência:** 0-1 · **Linha na planilha:** 224  
**Rótulo na planilha:** Informações para Controle da ST  

> (Incluído na NT2016.002)

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 104d | `CEST` | Código CEST | Numérico | 1-1 | 7 | — | Código Especificador da Substituição Tributária - CEST, que estabelece a sistemática de uniformização e identificação das mercadorias e bens passíveis  de sujeição aos regimes de substituição tributária e de antecipação de recolhimento do ICMS. (NT2015/003).<br>(Incluído na NT 2015/003. Atualizado NT2016.002) | — |
| 104e | `indEscala` | Indicador de Escala Relevante | Caractere | 0-1 | 1 | — | Indicador de Produção em escala relevante, conforme cláusula 23 do Convênio ICMS 52/2017:<br>S - Produzido em Escala Relevante;<br>N - Produzido em Escala NÃO Relevante.<br>Nota: preenchimento obrigatório para produtos com NCM relacionado no Anexo XXVII do Convênio 52/2017.<br>(Incluído na NT2016.002) | — |
| 104f | `CNPJFab` | CNPJ do Fabricante da Mercadoria | Caractere | 0-1 | 14 | — | Obrigatório para produto em escala NÃO relevante<br>(Incluído na NT2016.002) | — |

<a id="gcred"></a>

###### `gCred` — Grupo de informações sobre o Crédito Presumido

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `gCred`  
**Ocorrência:** 0-4 · **Linha na planilha:** 248  
**Rótulo na planilha:** Informações sobre o Crédito Presumido  

> Grupo opcional para informações do Crédito Presumido. Obs.: A exigência do preenchimento das informações do crédito presumido fica a critério de cada UF. (Incluído na NT 2019.001)

Abertura: `--gCred_ini--;` · Fechamento: `--gCred_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 105h | `cCredPresumido` | Código de Benefício Fiscal de Crédito Presumido na UF aplicado ao item | Caractere | 1-1 | 8-10 | — | Código de Benefício Fiscal de Crédito Presumido utilizado pela UF, aplicado ao item. Obs.: Deve ser utilizado o mesmo código adotado na EFD e outras declarações, nas UF que o exigem. | — |
| 105i | `pCredPresumido` | Percentual do Crédito Presumido | Numérico | 1-1 | 7 | 2-4 | Informar o percentual do crédito presumido relativo ao código do crédito presumido informado. | 7 posições, sendo 3 inteiros e 2 a 4 decimais. |
| 105j | `vCredPresumido` | Valor do Crédito Presumido | Numérico | 1-1 | 15 | 2 | Informar o valor do crédito presumido relativo ao código do crédito presumido informado. | — |

<a id="di"></a>

###### `di` — Declaração de Importação

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `di`  
**ID:** 117 · **Ocorrência:** 0-100 · **Linha na planilha:** 253  

> Informar dados da importação

Abertura: `--di_ini--;` · Fechamento: `--di_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 118 | `nDi` | Número do Documento de Importação (DI, DSI, DIRE,<br>DUImp) | Caractere | 1-1 | 1-15 | — | (NT 2011/004) | — |
| 119 | `dDi` | Data de Registro da DI/DSI/DA/DREI/etc. | Data | 1-1 | — | — | Formato "AAAA-MM-DD" | — |
| 120 | `xLocDesemb` | Local de desembaraço | Caractere | 1-1 | 1-60 | — | — | — |
| 121 | `UFDesemb` | — | Caractere | 1-1 | 2 | — | — | — |
| 122 | `dDesemb` | Data do Desembaraço Aduaneiro | Data | 1-1 | — | — | Formato "AAAA-MM-DD" | — |
| 122a | `tpViaTransp` | Via de transporte internacional informada na Declaração de Importação (DI) ou na Declaração Única de Importação (DUImp) | Numérico | 1-1 | 2 | — | 1 - Marítima<br>2 - Fluvial<br>3 - Lacustre<br>4 - Aérea<br>5 - Postal<br>6 - Ferroviária;<br>7 - Rodoviária<br>8 - Conduto/Rede Transmissão<br>9 - Meios Próprios<br>10 - Entrada/Saída Ficta<br>11 - Courier<br>12 - Em mãos<br>13 - Por reboque | — |
| 122b | `vAFRMM` | Valor da AFRMM - Adicional ao Frete para Renovação da Marinha Mercante | Numérico | 0-1 | 15 | 2 | Deve ser informado no caso da via de transporte marítimo | 15 posições, sendo 13 inteiros e 2 decimais. |
| 122c | `tpIntermedio` | Forma de importação quanto a intermediação | Numérico | 1-1 | 1 | — | 1  - Importação por conta própria;<br>2 - Importação por conta e ordem;<br>3 - Importação por encomenda. | — |
| 122d | `CNPJ` | CNPJ do adquirente ou do encomendante | Caractere | 0-1 | 14 | — | Obrigatória a informação no caso de importação por conta e ordem ou por encomenda. <br>Informar os zeros não significativos. | — |
| I23d1 | `CPF` | CPF do adquirente ou do encomendante | Caractere | 0-1 | 11 | — | — | — |
| 122e | `UFTerceiro` | Sigla da UF do adquirente ou do encomendante | Caractere | 0-1 | 2 | — | Obrigatória a informação no caso de importação por conta e ordem ou por encomenda. <br>Não aceita o valor "EX". | — |
| 123 | `cExportador` | Código do exportador | Caractere | 1-1 | 1-60 | — | Código do exportador, usado nos sistemas internos de informação do emitente da NF-e. | — |

➡️ Sub-bloco: [`adi`](#adi) — Adições e/ou itens (1-999)

<a id="adi"></a>

###### `adi` — Adições e/ou itens

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `di` › `adi`  
**ID:** 124 · **Ocorrência:** 1-999 · **Linha na planilha:** 266  
**Rótulo na planilha:** Adições  

> (NT 2011/004)

Abertura: `--adi_ini--;` · Fechamento: `--adi_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 125 | `nAdicao` | Número da adição | Numérico | 0-1 | 1-3 | — | No caso de DUImp esse campo não deverá ser preenchido | — |
| 126 | `nSeqAdic` | Número sequencial do item | Numérico | 1-1 | 1-5 | — | — | — |
| 127 | `cFabricante` | Código do fabricante estrangeiro | Caractere | 1-1 | 1-60 | — | Código do fabricante estrangeiro, usado nos sistemas internos de informação do emitente da NF-e | — |
| 128 | `vDescDi` | Valor do desconto do item | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais. |
| 128.1 | `nDraw` | Número do ato concessório de Drawback | Caractere | 0-1 | 1-20 | — | O número do Ato Concessório de Suspensão deve ser<br>preenchido com 11 dígitos (AAAANNNNNND) e o número do Ato Concessório de Drawback Isenção deve ser preenchido com 9 dígitos (AANNNNNND). <br>(Observação incluída na NT 2013/005 v. 1.10) | — |

<a id="det_export"></a>

###### `det_Export` — Informações de Exportação para o item

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `det_Export`  
**ID:** 128f · **Ocorrência:** 0-500 · **Linha na planilha:** 274  
**Rótulo na planilha:** Informações de Exportação  

> Informar apenas no Drawback e nas exportações

Abertura: `--det_Export_ini--;` · Fechamento: `--det_Export_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 128g | `nDraw` | Número do ato concessório de Drawback | Caractere | 0-1 | 1-20 | — | O número do Ato Concessório de Suspensão deve ser<br>preenchido com 11 dígitos (AAAANNNNNND) e o número do Ato Concessório de Drawback Isenção deve ser preenchido com 9 dígitos (AANNNNNND).<br>(Observação incluída na NT 2013/005 v. 1.10) | — |

➡️ Sub-bloco: [`export_Ind`](#export_ind) — Informações sobre exportação indireta (0-1)

<a id="export_ind"></a>

###### `export_Ind` — Informações sobre exportação indireta

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `det_Export` › `export_Ind`  
**ID:** 128h · **Ocorrência:** 0-1 · **Linha na planilha:** 276  
**Rótulo na planilha:** Exportação Indireta  

Abertura: `--export_Ind_ini--;` · Fechamento: `--export_Ind_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 128i | `nRE` | Número de Registro de Exportação | Numérico | 1-1 | 12 | — | — | — |
| 128j | `chNFe` | Chave de Acesso da NF-e recebida para exportação | Caractere | 1-1 | 44 | — | NF-e recebida com fim específico de exportação | — |
| 128k | `qExport` | Quantidade do item realmente exportado<br>Observação: No caso de operação com CFOP 3.503, informar a quantidade de mercadoria devolvida | Numérico | 1-1 | 15 | 4 | A unidade de medida desta quantidade é a unidade de comercialização deste item | 15 posições, sendo 11 inteiros e  4 decimais. |

<a id="rastro"></a>

###### `rastro` — Detalhamento de produto sujeito a rastreabilidade

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `rastro`  
**ID:** 128q · **Ocorrência:** 0-500 · **Linha na planilha:** 285  
**Rótulo na planilha:** Rastreabilidade do Produto  

> Informar apenas quando se tratar de produto a ser rastreado posteriormente. Preenchimento obrigatório no caso de medicamentos e produtos farmacêuticos.

Abertura: `--rastro_ini--;` · Fechamento: `--rastro_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 128r | `nLote` | Número do Lote do produto | Caractere | 1-1 | 1-20 | — | — | — |
| 128s | `qLote` | Quantidade de produto no lote | Numérico | 1-1 | 11 | 3 | — | 11 posições, sendo 8 inteiros e 3 decimais |
| 128t | `dFab` | Data de fabricação/produção | Data | 1-1 | — | — | — | Formato: AAAA-MM-DD |
| 128u | `dVal` | Data de Validade | Data | 1-1 | — | — | Informar o último dia do mês caso a validade não especifique o dia. | Formato: AAAA-MM-DD |
| 128v | `cAgreg` | Código de Agregação | Caractere | 0-1 | 1-20 | — | — | — |

<a id="prod_especifico"></a>

###### `prod_especifico` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `prod_especifico`  
**ID:** 128x · **Ocorrência:** 0-1 · **Linha na planilha:** 292  
**Rótulo na planilha:** Produtos Específicos: Veículo, Medicamentos, Armas, Combustível  

> Grupo opcional, somente um deles poderá ser informado: Veículo, Medicamentos, Armas, Combustível.

Abertura: `--prod_especifico_ini--;` · Fechamento: `--prod_especifico_fim--;`

➡️ Sub-bloco: [`veic_Prod`](#veic_prod) — Detalhamento de Veículos novos (1-1)

➡️ Sub-bloco: [`medicamento`](#medicamento) — Detalhamento de Medicamentos e de matérias-primas farmacêuticas (1-1)

➡️ Sub-bloco: [`armamento`](#armamento) — Detalhamento de Armamento (1-500)

➡️ Sub-bloco: [`comb`](#comb) — Informações específicas para combustíveis líquidos e lubrificantes (1-1)

*Continuação dos campos de `prod_especifico` (após o fechamento de `comb`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 162p | `nRECOPI` | Número do RECOPI | Numérico | 1-1 | 20 | — | Vide: Anexo X Identificador RECOPI | — |

<a id="veic_prod"></a>

###### `veic_Prod` — Detalhamento de Veículos novos

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `prod_especifico` › `veic_Prod`  
**ID:** 129 · **Ocorrência:** 1-1 · **Linha na planilha:** 293  
**Rótulo na planilha:** Veículos Novos  

> Informar apenas quando se tratar de veículos novos

Abertura: `--veic_Prod_ini--;` · Fechamento: `--veic_Prod_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 130 | `tpOp` | Tipo da operação | Numérico | 1-1 | 1 | — | 1 - Venda concessionária;<br>2 - Faturamento direto para consumidor final; <br>3 - Venda direta para grandes consumidores (frotista, governo,...);<br>0 - Outros | — |
| 131 | `chassi` | Chassi do veículo | Caractere | 1-1 | 17 | — | VIN (código-identificação-veículo) | — |
| 132 | `cCor` | Cor | Caractere | 1-1 | 1-4 | — | Código de cada montadora | — |
| 133 | `xCor` | Descrição da Cor | Caractere | 1-1 | 1-40 | — | — | — |
| 134 | `pot` | Potência do Motor | Caractere | 1-1 | 1-4 | — | Potência máxima do motor do veículo em cavalo vapor (CV). (potência-veículo) | — |
| 135 | `cilin` | Cilindradas | Caractere | 1-1 | 1-4 | — | Capacidade voluntária do motor expressa em centímetros cúbicos (CC). (cilindradas) | — |
| 136 | `pesoL` | Peso Líquido | Caractere | 1-1 | 1-9 | — | Em toneladas - 4 casas decimais | — |
| 137 | `pesoB` | Peso Bruto | Caractere | 1-1 | 1-9 | — | Peso Bruto Total - em tonelada - 4 casas decimais | — |
| 138 | `nSerie` | Serial(série) | Caractere | 1-1 | 1-9 | — | — | — |
| 139 | `tpComb` | Tipo de combustível | Caractere | 1-1 | 1-2 | — | Utilizar Tabela RENAVAM <br>01  - Álcool; <br>02 - Gasolina ;<br>03 - Diesel (...) ;<br>16  - Álcool/Gasolina; <br>17  - Gasolina/Álcool/GNV; <br>18  - Gasolina/Elétrico. | — |
| 140 | `nMotor` | Número do motor | Caractere | 1-1 | 1-21 | — | — | — |
| 141 | `CMT` | Capacidade máxima de tração | Caractere | 1-1 | 1-9 | — | CMT-Capacidade Máxima de Tração - em Toneladas 4 casas decimais | — |
| 142 | `dist` | Distância entre eixos | Caractere | 1-1 | 1-4 | — | — | — |
| 144 | `anoMod` | Ano Modelo de Fabricação | Numérico | 1-1 | 4 | — | — | — |
| 145 | `anoFab` | Ano de Fabricação | Numérico | 1-1 | 4 | — | — | — |
| 146 | `tpPint` | Tipo de Pintura | Caractere | 1-1 | 1 | — | — | — |
| 147 | `tpVeic` | Tipo de Veículo | Numérico | 1-1 | 1-2 | — | Utilizar Tabela RENAVAM<br>02 - Ciclomoto;<br>03 - Motoneta;  <br>04 - Motociclo;<br>05 - Triciclo;<br>06 - Automóvel;<br>07 - Micro-ônibus;<br>08 - Ônibus;<br>10 - Reboque; <br>11   - Semirreboque;<br>13  - Caminhoneta; <br>14  - Caminhão; <br>17  - C. Trator;<br>22 - ESP/Ônibus;<br>23 - Misto/CAM; <br>24 - Carga/CAM.  <br>*Lista exemplificativa. | — |
| 148 | `espveic` | Espécie de Veículo | Numérico | 1-1 | 1 | — | Utilizar Tabela RENAVAM <br>1  - Passageiro; <br>2 - Carga; <br>3 - Misto; <br>4 - Corrida; <br>5 - Tração; <br>6 - Especial. | — |
| 149 | `VIN` | Condição do VIN | Caractere | 1-1 | 1 | — | Informa-se o veículo tem VIN (chassi) remarcado. <br>R - Remarcado;<br>N - Normal. | — |
| 150 | `condVeic` | Condição do Veículo | Numérico | 1-1 | 1 | — | 1  - Acabado;<br>2 - Inacabado; <br>3 - Semiacabado. | — |
| 151 | `cMod` | Código Marca Modelo | Numérico | 1-1 | 1-6 | — | Utilizar tabela RENAVAM | — |
| 151a | `cCorDENATRAN` | Código da cor | Numérico | 1-1 | 1-2 | — | Segundo as regras de pré-cadastro do DENATRAN<br>01 - Amarelo; <br>02 - Azul; <br>03 - Bege; <br>04 - Branca; <br>05 - Cinza; <br>06 - Dourada; <br>07 - Grená; <br>08 - Laranja; <br>09 - Marrom; <br>10 - Prata; <br>11 - Preta; <br>12 - Rosa; <br>13 - Roxa; <br>14 - Verde; <br>15 - Vermelha; <br>16 - Fantasia. | — |
| 151b | `lota` | capacidade máxima de lotação | Numérico | 1-1 | 1-3 | — | Quantidade máxima permitida de passageiros sentados, inclusive motorista. | — |
| 151c | `tpRest` | Restrição | Numérico | 1-1 | 1 | — | 0 - Não há; <br>1 - Alienação Fiduciária; <br>2 - Arrendamento Mercantil; <br>3 - Reserva de Domínio; <br>4 - Penhor de Veículos; <br>9 - outras. | — |

<a id="medicamento"></a>

###### `medicamento` — Detalhamento de Medicamentos e de matérias-primas farmacêuticas

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `prod_especifico` › `medicamento`  
**ID:** 152 · **Ocorrência:** 1-1 · **Linha na planilha:** 319  
**Rótulo na planilha:** Medicamentos  

> Informar apenas quando se tratar de medicamentos ou de matérias-primas farmacêuticas.

Abertura: `--medicamento_ini--;` · Fechamento: `--medicamento_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 152a | `cProdANVISA` | Código de Produto da ANVISA | Caractere | 1-1 | 6-13 | — | Utilizar o número do registro ANVISA<br>ou preencher com o literal "ISENTO", no caso de medicamento isento de registro na ANVISA. | 6 posições para "ISENTO", até 13 posições para código ANVISA. |
| 152b | `xMotivoIsencao` | Motivo da isenção da ANVISA | Caractere | 0-1 | 1-255 | — | Para medicamento isento de registro na ANVISA, informar o número da decisão que o isenta, como por exemplo o número da Resolução da Diretoria Colegiada da ANVISA (RDC). | — |
| 157 | `vPMC` | Preço máximo consumidor | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiras e 2 decimais |

<a id="armamento"></a>

###### `armamento` — Detalhamento de Armamento

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `prod_especifico` › `armamento`  
**ID:** 158 · **Ocorrência:** 1-500 · **Linha na planilha:** 324  
**Rótulo na planilha:** Armamento  

> Informar apenas quando se tratar de armamento, permite ocorrências.

Abertura: `--armamento_ini--;` · Fechamento: `--armamento_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 159 | `tpArma` | Indicador do tipo de arma de fogo | Numérico | 1-1 | 1 | — | 0 - Uso permitido;<br>1  - Uso restrito. | — |
| 160 | `nSerie` | Número de série da arma | Caractere | 1-1 | 1-15 | — | — | — |
| 161 | `nCano` | Número de série do cano | Caractere | 1-1 | 1-15 | — | — | — |
| 162 | `descr` | Descrição completa da arma, compreendendo: calibre, marca, capacidade, tipo de funcionamento, comprimento e demais elementos que permitam a sua perfeita identificação | Caractere | 1-1 | 1-256 | — | — | — |

<a id="comb"></a>

###### `comb` — Informações específicas para combustíveis líquidos e lubrificantes

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `prod_especifico` › `comb`  
**ID:** 162a · **Ocorrência:** 1-1 · **Linha na planilha:** 330  
**Rótulo na planilha:** Combustíveis Líquidos e Lubrificantes  

> Informar apenas para operações com combustíveis líquidos e lubrificantes.

Abertura: `--comb_ini--;` · Fechamento: `--comb_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 162b | `cProdANP` | Código de produto da ANP | Numérico | 1-1 | 9 | — | Utilizar a Tabela de Código de Produtos da ANP, publicada no Portal Nacional da NF-e, no grupo “Documentos”, opção “Diversos” | — |
| 162b1 | `descANP` | descrição do produto conforme ANP | Caractere | 1-1 | 2-95 | — | Utilizar a Tabela de Código de Produtos da ANP, publicada no Portal Nacional da NF-e, no grupo “Documentos”, opção “Diversos” | Nota: Tipo alterado na versão 1.10 da NT2016.002 |
| 162b2 | `pGLP` | Percentual do GLP derivado do petróleo no produto GLP | Numérico | 0-1 | 7 | 4 | Informar em número decimal o percentual do GLP derivado de petróleo no produto GLP. <br>Valores de 0 a 1. | 7 posições, sendo 3 inteiros e 4 decimais |
| 162b3 | `pGNn` | Percentual de Gás Natural Nacional - GLGNn para o produto GLP (cProdANP=210203001) | Numérico | 0-1 | 7 | 4 | Informar em número decimal o percentual de Gás Natural Nacional - GLGNn para o produto GLP. <br>Valores de 0 a 1. | 7 posições, sendo 3 inteiros e 4 decimais |
| 162b4 | `pGNi` | Percentual de Gás Natural Importado - GLGNi para o produto GLP (cProdANP=210203001) | Numérico | 0-1 | 7 | 4 | Informar em número decimal o percentual do Gás Natural Importado - GLGNi para o produto GLP.<br>Valores de 0 a 1. | 7 posições, sendo 3 inteiros e 4 decimais |
| 162b5 | `vPart` | Valor de partida (cProdANP=210203001) | Numérico | 0-1 | 15 | 2 | Deve ser informado neste campo o valor por quilograma sem ICMS. | 15 posições, sendo 13 inteiros e 2 decimais. |
| 162c | `CODIF` | Código de autorização/ registro do CODIF | Numérico | 0-1 | 1-21 | — | Informar apenas quando a UF utilizar o CODIF (Sistema de Controle do Diferimento do Imposto nas Operações com AEAC - Álcool Etílico Anidro Combustível). | — |
| 162d | `qTemp` | Quantidade de combustível faturada à temperatura ambiente | Numérico | 0-1 | 16 | 4 | Informar quando a quantidade faturada informada no campo qCom (I10) tiver sido ajustada para uma temperatura diferente da ambiente. | 16 posições, sendo 12 inteiros e 4 decimais |
| 162e | `UFCons` | Sigla da UF de consumo | Numérico | 1-1 | 2 | — | Informar a UF de consumo | — |

➡️ Sub-bloco: [`cide`](#cide) — Informações da CIDE (0-1)

➡️ Sub-bloco: [`encerrante`](#encerrante) — Informações de "Encerrante" (0-1)

*Continuação dos campos de `comb` (após o fechamento de `encerrante`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 162q | `pBio` | Percentual do índice de mistura do Biodiesel (B100) no Óleo Diesel B instituído pelo órgão regulamentador | Numérico | 0-1 | 7 | 4 | Informar em número decimal o percentual do índice de mistura do Biodiesel para o produto Óleo Diesel B. Valores maiores que 0 e menores ou iguais a 100. | 7 posições, sendo 3 inteiros e 4 decimais |

➡️ Sub-bloco: [`origComb`](#origcomb) — Grupo indicador da origem do combustível (0-30)

<a id="cide"></a>

###### `cide` — Informações da CIDE

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `prod_especifico` › `comb` › `cide`  
**ID:** 162f · **Ocorrência:** 0-1 · **Linha na planilha:** 340  
**Rótulo na planilha:** CIDE  

> Grupo de informações da CIDE

Abertura: `--cide_ini--;` · Fechamento: `--cide_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 162g | `qBCProd` | BC da CIDE | Numérico | 1-1 | 16 | 0-4 | Informar a BC da CIDE em quantidade | 16 posições, sendo 12 inteiros e 0 a 4 decimais |
| 162h | `vAliqProd` | Valor da alíquota da CIDE | Numérico | 1-1 | 15 | 4 | Informar o valor da alíquota em reais da CIDE | 15 posições, sendo 11 inteiros e 4 decimais. |
| 162i | `vCIDE` | Valor da CIDE | Numérico | 1-1 | 15 | 2 | Informar o valor da CIDE | 15 posições, sendo 13 inteiros e 2 decimais. |

<a id="encerrante"></a>

###### `encerrante` — Informações de "Encerrante"

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `prod_especifico` › `comb` › `encerrante`  
**ID:** 162j · **Ocorrência:** 0-1 · **Linha na planilha:** 345  
**Rótulo na planilha:** Encerrante  

> Informações de “Encerrante” disponibilizado<br>por hardware específico acoplado à bomba de<br>combustível, definido no controle da venda do Posto<br>Revendedor de Combustível. (NT2015/002)

Abertura: `--encerrante_ini--;` · Fechamento: `--encerrante_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 162k | `nBico` | Número de Identificação do bico utilizado no abastecimento | Numérico | 1-1 | 1-3 | — | Informar o número do bico utilizado no abastecimento | — |
| 162l | `nBomba` | Número de Identificação da bomba ao qual o bico está interligado | Numérico | 0-1 | 1-3 | — | Caso exista, informar o número da bomba utilizada | — |
| 162m | `nTanque` | Número de identificação do tanque ao qual o bico está interligado | Numérico | 1-1 | 1-3 | — | Informar o número do tanque utilizado | — |
| 162n | `vEncIni` | Valor do Encerrante no início do abastecimento | Numérico | 1-1 | 15 | 3 | Informar o valor da leitura do contador (Encerrante) no início do abastecimento | 15 posições, sendo 12 inteiros e 3 decimais |
| 162o | `vEncFim` | Valor do Encerrante no final do abastecimento | Numérico | 1-1 | 15 | 3 | Informar o valor da leitura do contador (Encerrante) no término do abastecimento | 15 posições, sendo 12 inteiros e 3 decimais |

<a id="origcomb"></a>

###### `origComb` — Grupo indicador da origem do combustível

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `prod_especifico` › `comb` › `origComb`  
**ID:** 162r · **Ocorrência:** 0-30 · **Linha na planilha:** 353  
**Rótulo na planilha:** Origem Combustível  

> Obrigatoriedade de preenchimento do grupo conforme Tabela de Combustíveis Sujeitos à Tributação Monofásica (publicada no Portal Nacional da NF-e, no grupo “Documentos”, opção “Diversos”

Abertura: `--origComb_ini--;` · Fechamento: `--origComb_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 162s | `indImport` | Indicador de importação | Numérico | 1-1 | 1 | 0-4 | 0=Nacional;<br>1=Importado; | — |
| 162t | `cUFOrig` | Código da UF | Numérico | 1-1 | 2 | 4 | UF de origem do produtor ou do importador. Utilizar a tabela do IBGE | — |
| 162u | `pOrig` | Percentual originário para a UF | Numérico | 1-1 | 7 | 4 | Informar em número decimal o percentual originário da UF. Esse valor será obtido através dos Anexos de Combustíveis previstos em Ato Cotepe. Valores maiores que 0 e menores ou iguais a 100. | 7 posições, sendo 3 inteiros e 4 decimais |

<a id="obsitem"></a>

###### `obsItem` — Grupo de observações de uso livre (para o item da NF-e)

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `obsItem`  
**ID:** 325a · **Ocorrência:** 0-1 · **Linha na planilha:** 361  
**Rótulo na planilha:** Observações de uso livre  

Abertura: `--obsItem_ini--;` · Fechamento: `--obsItem_fim--;`

➡️ Sub-bloco: [`obsCont`](#obscont) — Grupo de observações de uso livre do Contribuinte (0-1)

➡️ Sub-bloco: [`obsFisco`](#obsfisco) — Grupo de observações de uso livre do Fisco (0-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="obscont"></a>

###### `obsCont` — Grupo de observações de uso livre do Contribuinte

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `obsItem` › `obsCont`  
**ID:** 325b · **Ocorrência:** 0-1 · **Linha na planilha:** 362  
**Rótulo na planilha:** Obs. de uso livre do Contribuinte  

Abertura: `--obsCont_ini--;` · Fechamento: `--obsCont_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 325c | `xCampo` | Identificação do campo | Caractere | 1-1 | 20 | — | — | — |
| 325d | `xTexto` | Conteúdo do campo | Caractere | 1-1 | 60 | — | — | — |

<a id="obsfisco"></a>

###### `obsFisco` — Grupo de observações de uso livre do Fisco

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `obsItem` › `obsFisco`  
**ID:** 325e · **Ocorrência:** 0-1 · **Linha na planilha:** 366  
**Rótulo na planilha:** Obs. de uso livre do Fisco  

Abertura: `--obsFisco_ini--;` · Fechamento: `--obsFisco_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 325f | `xCampo` | Identificação do campo | Caractere | 1-1 | 20 | — | — | — |
| 325g | `xTexto` | Conteúdo do campo | Caractere | 1-1 | 60 | — | — | — |

<a id="sequencia_xml_liq"></a>

###### `sequencia_XML_liq` — Sequência XML 🆕

**Caminho:** `nota` › `item_nota` › `det` › `prod` › `sequencia_XML_liq`  
**ID:** 110.01 · **Ocorrência:** 0-1 · **Linha na planilha:** 371  
**Rótulo na planilha:** Sequência XML valor líquido  

> Futuramente essa sequência será obrigatória. No XML, a sequência é gerada entre as tags vProd e cEANTrib (a posição no TXT não altera a ordem no XML). (Incluído na NT 2026.008)

Abertura: `--sequencia_XML_liq_ini--;` · Fechamento: `--sequencia_XML_liq_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 110.02 | `vUnComLiq` 🆕 | Valor Líquido Unitário do Produto ou Serviço (sem tributos) | Numérico | 1-1 | 21 | 0-10 | Valor unitário de comercialização do produto ou serviço, sem a inclusão de tributos. (Incluído na NT 2026.008) | 21 posições, sendo 11 inteiros e 0 a 10 decimais |
| 110.03 | `vProdLiq` 🆕 | Valor Líquido do Produto ou Serviço (sem tributos) | Numérico | 1-1 | 15 | 2 | Valor líquido do produto ou serviço, sem a inclusão de tributos. (Incluído na NT 2026.008) | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="impostos"></a>

###### `impostos` — Tributo incidentes no Produto ou Serviço

**Caminho:** `nota` › `item_nota` › `det` › `impostos`  
**ID:** 163 · **Ocorrência:** 1-1 · **Linha na planilha:** 376  
**Rótulo na planilha:** Tributos incidentes no Produto ou Serviço  

> Grupo ISSQN mutuamente exclusivo com os grupos ICMS e II, isto e, se o grupo ISSQN for informado os grupos ICMS e II não serão informados e vice-versa.

Abertura: `--impostos_ini--;` · Fechamento: `--impostos_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 163a | `vTotTrib` | Valor aproximado total de tributos federais, estaduais e municipais | Numérico | 0-1 | 15 | 2 | Grupo ISSQN mutuamente exclusivo com os grupos ICMS e II, isto e, se o grupo ISSQN for informado os grupos ICMS e II não serão informados e vice-versa. | 15 posições, sendo 13 inteiros e 2 decimais. |

➡️ Sub-bloco: [`ICMS`](#icms) — Informações do ICMS da Operação (0-1)

➡️ Sub-bloco: [`ICMS_UF_Dest`](#icms_uf_dest) — Informação do ICMS Interestadual (0-1)

➡️ Sub-bloco: [`IPI`](#ipi) — Grupo IPI (0-1)

➡️ Sub-bloco: [`II`](#ii) — Grupo de Imposto de Importação (0-1)

➡️ Sub-bloco: [`PIS`](#pis) — Grupo PIS (0-1)

➡️ Sub-bloco: [`PISST`](#pisst) — Grupo PIS Substituição Tributária (0-1)

➡️ Sub-bloco: [`COFINS`](#cofins) — Grupo COFINS (0-1)

➡️ Sub-bloco: [`COFINSST`](#cofinsst) — Grupo COFINS Substituição Tributária (0-1)

➡️ Sub-bloco: [`ISSQN`](#issqn) — Grupo ISSQN (0-1)

➡️ Sub-bloco: [`IS`](#is) — Informações do Imposto Seletivo (0-1)

➡️ Sub-bloco: [`IBSCBS`](#ibscbs) — Informações do Imposto de Bens e Serviços -<br>IBS e da Contribuição de Bens e Serviços - CBS (0-1)

<a id="icms"></a>

###### `ICMS` — Informações do ICMS da Operação

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS`  
**ID:** 164 · **Ocorrência:** 0-1 · **Linha na planilha:** 378  
**Rótulo na planilha:** ICMS Normal e ST  

> Informar apenas um dos grupos de tributação do ICMS (ICMS00, ICMS10, ....)

Abertura: `--ICMS_ini--;` · Fechamento: `--ICMS_fim--;`

➡️ Sub-bloco: [`icms_00`](#icms_00) — Grupo Tributação do ICMS= 00 (1-1)

➡️ Sub-bloco: [`icms_02`](#icms_02) — Grupo Tributação do ICMS monofásico = 02 (1-1)

➡️ Sub-bloco: [`icms_10`](#icms_10) — Grupo Tributação do ICMS= 10 (1-1)

➡️ Sub-bloco: [`icms_15`](#icms_15) — Grupo Tributação do ICMS monofásico = 15 (1-1)

➡️ Sub-bloco: [`icms_20`](#icms_20) — Grupo Tributação do ICMS= 20 (1-1)

➡️ Sub-bloco: [`icms_30`](#icms_30) — Grupo Tributação do ICMS= 30 (1-1)

➡️ Sub-bloco: [`icms_40`](#icms_40) — Grupo Tributação do ICMS= 40, 41, 50 (1-1)

➡️ Sub-bloco: [`icms_51`](#icms_51) — Grupo Tributação do ICMS= 51 (1-1)

➡️ Sub-bloco: [`icms_53`](#icms_53) — Grupo Tributação do ICMS monofásico = 53 (1-1)

➡️ Sub-bloco: [`icms_60`](#icms_60) — Grupo Tributação do ICMS= 60 (1-1)

➡️ Sub-bloco: [`icms_61`](#icms_61) — Grupo Tributação do ICMS monofásico = 61 (1-1)

➡️ Sub-bloco: [`icms_70`](#icms_70) — Grupo Tributação do ICMS= 70 (1-1)

➡️ Sub-bloco: [`icms_90`](#icms_90) — Grupo Tributação do ICMS= 90 (1-1)

➡️ Sub-bloco: [`icms_part`](#icms_part) — Grupo de Partilha do ICMS entre a UF de origem e UF de destino ou a UF definida na legislação. (1-1)

➡️ Sub-bloco: [`icms_st`](#icms_st) — Grupo de Repasse de ICMS ST retido anteriormente em operações interestaduais com repasses através do Substituto Tributário (1-1)

➡️ Sub-bloco: [`icms_sn101`](#icms_sn101) — Grupo CRT= 1 - Simples Nacional e CSOSN= 101 (1-1)

➡️ Sub-bloco: [`icms_sn102`](#icms_sn102) — Grupo CRT=1 – Simples Nacional, CRT=4 – MEI e CSOSN=102, 103, 300 ou 400 (1-1)

➡️ Sub-bloco: [`icms_sn201`](#icms_sn201) — Grupo CRT= 1 - Simples Nacional e CSOSN= 201 (1-1)

➡️ Sub-bloco: [`icms_sn202`](#icms_sn202) — Grupo CRT= 1 - Simples Nacional e CSOSN= 202 ou 203 (1-1)

➡️ Sub-bloco: [`icms_sn500`](#icms_sn500) — Grupo CRT= 1 - Simples Nacional e CSOSN= 500 (1-1)

➡️ Sub-bloco: [`icms_sn900`](#icms_sn900) — Grupo CRT=1 – Simples Nacional, CRT=4 – MEI e CSOSN=900 (1-1)

➡️ Sub-bloco: [`ICMS_Previsto`](#icms_previsto) — Grupo do ICMS Previsto no Pagamento Antecipado (0-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="icms_00"></a>

###### `icms_00` — Grupo Tributação do ICMS= 00

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_00`  
**ID:** 165 · **Ocorrência:** 1-1 · **Linha na planilha:** 379  
**Rótulo na planilha:** Tributação de ICMS CST - 00  

> Tributada integralmente

Abertura: `--icms_00_ini--;` · Fechamento: `--icms_00_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 166 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%; | — |
| 167 | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 00 - Tributada integralmente | — |
| 168 | `modBC` | Modalidade de determinação da Base de Cálculo do ICMS | Numérico | 1-1 | 1 | — | 0 - Margem Valor Agregado(%);<br>1  - Pauta (Valor);<br>2 - Preço tabelado Máx. (Valor);<br>3 - Valor da operação. | — |
| 169 | `vBC` | Valor da Base de Cálculo do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 170 | `pICMS` | Alíquota do imposto | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS sem o FCP. Quando for o caso, informar a alíquota do FCP no campo pFCP. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 171 | `vICMS` | Valor do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-1) — Sequência XML (0-1)

<a id="sequencia_xml-1"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_00` › `sequencia_XML`  
**ID:** 171.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 386  

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 171.1 | `pFCP` | Percentual do ICMS relativo ao Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais<br>Nota: Ocorrência alterada na versão 1.10 da NT2016.002 |
| 172.2 | `vFCP` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais<br>Nota: Ocorrência alterada na versão 1.10 da NT2016.002 |

<a id="icms_02"></a>

###### `icms_02` — Grupo Tributação do ICMS monofásico = 02

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_02`  
**ID:** 172.3 · **Ocorrência:** 1-1 · **Linha na planilha:** 391  
**Rótulo na planilha:** Tributação de ICMS CST - 02  

> Tributação monofásica própria sobre combustíveis

Abertura: `--icms_02_ini--;` · Fechamento: `--icms_02_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 172.4 | `orig` | Origem da mercadoria | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8; 1 -Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante lista CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%; | — |
| 172.5 | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 02= Tributação monofásica própria sobre combustíveis; | — |
| 172.8 | `qBCMono` | Quantidade tributada | Numérico | 0-1 | 15 | 0-4 | Informar a BC do ICMS próprio em quantidade conforme unidade de medida estabelecida na legislação para o produto. | 15 posições, sendo 11 inteiros e 0 a 4 decimais |
| 172.6 | `adRemICMS` | Alíquota ad rem do imposto | Numérico | 1-1 | 7 | 2-4 | Alíquota ad rem do ICMS, estabelecida na legislação para o produto | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 172.7 | `vICMSMono` | Valor do ICMS próprio | Numérico | 1-1 | 15 | 2 | O valor do ICMS é obtido pela multiplicação da alíquota ad rem pela quantidade do produto conforme unidade de medida estabelecida na legislação. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_10"></a>

###### `icms_10` — Grupo Tributação do ICMS= 10

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_10`  
**ID:** 172 · **Ocorrência:** 1-1 · **Linha na planilha:** 398  
**Rótulo na planilha:** Tributação de ICMS CST - 10  

> Tributada e com cobrança do ICMS por substituição tributária

Abertura: `--icms_10_ini--;` · Fechamento: `--icms_10_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 173 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 174 | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 10 - Tributada e com cobrança do ICMS por substituição tributária | — |
| 175 | `modBC` | Modalidade de determinação da Base de Cálculo do ICMS | Numérico | 1-1 | 1 | — | 0 - Margem Valor Agregado(%);<br>1  - Pauta (Valor);<br>2 - Preço tabelado Máx. (Valor);<br>3 - Valor da operação. | — |
| 176 | `vBC` | Valor da Base de Cálculo do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 177 | `pICMS` | Alíquota do imposto | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS sem o FCP. <br>Quando for o caso, informar a aliquota do FCP no campo pFCP. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 178 | `vICMS` | Valor do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML_FCP`](#sequencia_xml_fcp) — Sequência XML para FCP (0-1)

*Continuação dos campos de `icms_10` (após o fechamento de `sequencia_XML_FCP`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 179 | `modBCST` | Modalidade de determinação da Base de Cálculo do ICMS ST | Numérico | 1-1 | 1 | — | 0 - Preço tabelado ou máximo sugerido;<br>1  - Lista Negativa (Valor);<br>2 - Lista Positiva (Valor);<br>3 - Lista Neutra (Valor);<br>4 - Margem Valor Agregado (%);<br>5 - Pauta (Valor);                                                                                               6 - Valor da Operação. | — |
| 180 | `pMVAST` | Percentual da margem de valor Adicionado do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 181 | `pRedBCST` | Percentual da Redução de Base de Cálculo do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 182 | `vBCST` | Valor da Base de Cálculo do ICMS ST | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 183 | `pICMSST` | Alíquota do imposto do ICMS ST | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS ST sem o FCP. <br>Quando for o caso, informar a alíquota do FCP no campo pFCPST. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 184 | `vICMSST` | Valor do ICMS ST retido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML_FCPST`](#sequencia_xml_fcpst) — Sequência XML para FCP retido por ST (0-1)

➡️ Sub-bloco: [`x_icmsst10_deson`](#x_icmsst10_deson) — Sequência XML para ICMS ST Desonerado (0-1)

<a id="sequencia_xml_fcp"></a>

###### `sequencia_XML_FCP` — Sequência XML para FCP

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_10` › `sequencia_XML_FCP`  
**ID:** 178.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 405  
**Rótulo na planilha:** Sequência XML  

Abertura: `--sequencia_XML_FCP_ini--;` · Fechamento: `--sequencia_XML_FCP_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 178.1 | `vBCFCP` | Valor da Base de Cálculo do FCP | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 178.2 | `pFCP` | Percentual relativo ao Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 178.3 | `vFCP` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml_fcpst"></a>

###### `sequencia_XML_FCPST` — Sequência XML para FCP retido por ST

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_10` › `sequencia_XML_FCPST`  
**ID:** 184.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 416  
**Rótulo na planilha:** Sequência XML  

Abertura: `--sequencia_XML_FCPST_ini--;` · Fechamento: `--sequencia_XML_FCPST_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 184.1 | `vBCFCPST` | Valor da Base de Cálculo do FCP retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 184.2 | `pFCPST` | Percentual relativo ao Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 184.4 | `vFCPST` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_icmsst10_deson"></a>

###### `x_icmsst10_deson` — Sequência XML para ICMS ST Desonerado

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_10` › `x_icmsst10_deson`  
**ID:** 184.5 · **Ocorrência:** 0-1 · **Linha na planilha:** 421  
**Rótulo na planilha:** Sequência XML  

> Grupo Opcional.

Abertura: `--x_icmsst10_deson_ini--;` · Fechamento: `--x_icmsst10_deson_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 184.6 | `vICMSSTDeson` | Valor do ICMS- ST desonerado | Numérico | 1-1 | 15 | 2 | Informar apenas nos motivos de desoneração documentados abaixo. | 15 posições, sendo 13 inteiros e 2 decimais |
| 184.7 | `motDesICMSST` | Motivo da desoneração do ICMS- ST | Numérico | 1-1 | 2 | — | Campo será preenchido quando o campo anterior estiver<br>preenchido. Informar o motivo da desoneração:<br>3 - Uso na agropecuária;<br>9 - Outros;<br>12 - Órgão de fomento e desenvolvimento agropecuário; | — |

<a id="icms_15"></a>

###### `icms_15` — Grupo Tributação do ICMS monofásico = 15

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_15`  
**ID:** 184.8 · **Ocorrência:** 1-1 · **Linha na planilha:** 426  
**Rótulo na planilha:** Tributação de ICMS CST - 15  

> Tributação monofásica própria e com responsabilidade <br>pela retenção sobre combustíveis;

Abertura: `--icms_15_ini--;` · Fechamento: `--icms_15_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 184.8a | `orig` | Origem da mercadoria | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8; 1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante lista CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%; | — |
| 184.8b | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 15= Tributação monofásica própria e com responsabilidade pela retenção sobre combustíveis; | — |
| 184.8j | `qBCMono` | Quantidade tributada | Numérico | 0-1 | 15 | 0-4 | Informar a BC do ICMS próprio em quantidade conforme unidade de medida estabelecida na legislação para o produto. | 15 posições, sendo 11 inteiros e 0 a 4 decimais |
| 184.8c | `adRemICMS` | Alíquota ad rem do imposto | Numérico | 1-1 | 7 | 2-4 | Alíquota ad rem do ICMS, estabelecida na legislação para o produto | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 184.8d | `vICMSMono` | Valor do ICMS próprio | Numérico | 1-1 | 15 | 2 | O valor do ICMS é obtido pela multiplicação da alíquota ad rem pela quantidade do produto conforme unidade de medida estabelecida na legislação. | 15 posições, sendo 13 inteiros e 2 decimais |
| 184.8k | `qBCMonoReten` | Quantidade tributada sujeita a retenção | Numérico | 0-1 | 15 | 0-4 | Informar a BC do ICMS sujeito a retenção em quantidade conforme unidade de medida estabelecida na legislação para o produto. | 15 posições, sendo 11 inteiros e 0 a 4 decimais |
| 184.8e | `adRemICMSReten` | Alíquota ad rem do imposto com retenção | Numérico | 1-1 | 7 | 2 | Alíquota ad rem do ICMS sobre o biocombustível a ser adicionado para a composição da mistura vendida a consumidor final estabelecida na legislação para o produto. | 15 posições, sendo 13 inteiros e 2 decimais |
| 184.8f | `vICMSMonoReten` | Valor do ICMS com retenção | Numérico | 1-1 | 15 | 2 | O valor do ICMS é obtido pela multiplicação da alíquota ad rem pela quantidade do produto conforme unidade de medida estabelecida em legislação. | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-2) — Sequência XML (0-1)

<a id="sequencia_xml-2"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_15` › `sequencia_XML`  
**ID:** 184.8g · **Ocorrência:** 0-1 · **Linha na planilha:** 435  

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 184.8h | `pRedAdRem` | Percentual de redução do valor da alíquota adrem do ICMS | Numérico | 1-1 | 5 | 2 | Informar o percentual de redução do valor da alíquota ad rem do ICMS | 5 posições, sendo 3 inteiros e 2 decimais |
| 184.8i | `motRedAdRem` | Motivo da redução do adrem | Numérico | 1-1 | 1 | — | Campo deverá será preenchido quando o campo anterior estiver preenchido. Informar o motivo da redução:<br>1= Transporte coletivo de passageiros;<br>9=Outros; | — |

<a id="icms_20"></a>

###### `icms_20` — Grupo Tributação do ICMS= 20

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_20`  
**ID:** 185 · **Ocorrência:** 1-1 · **Linha na planilha:** 440  
**Rótulo na planilha:** Tributação de ICMS CST - 20  

> Tributação com redução de base de cálculo

Abertura: `--icms_20_ini--;` · Fechamento: `--icms_20_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 186 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 187 | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 20 - Com redução de base de cálculo | — |
| 188 | `modBC` | Modalidade de determinação da Base de Cálculo do ICMS | Numérico | 1-1 | 1 | — | 0 - Margem Valor Agregado(%);<br>1  - Pauta (Valor);<br>2 - Preço tabelado Máx. (Valor);<br>3 - Valor da operação. | — |
| 189 | `pRedBC` | Percentual da Redução de Base de Cálculo | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 190 | `vBC` | Valor da Base de Cálculo do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 191 | `pICMS` | Alíquota do imposto | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS sem o FCP. <br>Quando for o caso, informar a alíquota do FCP no campo pFCP. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 192 | `vICMS` | Valor do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-3) — Sequência XML (0-1)

➡️ Sub-bloco: [`x_icms20_deson`](#x_icms20_deson) — Sequência XML (0-1)

<a id="sequencia_xml-3"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_20` › `sequencia_XML`  
**ID:** 192.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 448  

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 192.w | `vBCFCP` | Valor da Base de Cálculo do FCP | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 192.x | `pFCP` | Percentual do Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 192.y | `vFCP` | Valor do Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_icms20_deson"></a>

###### `x_icms20_deson` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_20` › `x_icms20_deson`  
**ID:** 192.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 453  
**Rótulo na planilha:** XML - ICMS 20 Desonerado  

> Grupo Opcional.

Abertura: `--x_icms20_deson_ini--;` · Fechamento: `--x_icms20_deson_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 192.2 | `vICMSDeson` | Valor do ICMS desonerado | Numérico | 1-1 | 15 | 2 | Informar apenas nos motivos de desoneração documentados abaixo. | 15 posições, sendo 13 inteiros e 2 decimais |
| 192.3 | `motDesICMS` | Motivo da desoneração do ICMS | Numérico | 1-1 | 2 | — | Campo será preenchido quando o campo anterior estiver preenchido. Informar o motivo da desoneração:<br>3 - Uso na agropecuária;<br>9 - Outros;<br>10 - Deficiente Condutor (Convênio ICMS 38/12); <br>11 - Deficiente Não Condutor (Convênio ICMS 38/12); <br>12 - Órgão de fomento e desenvolvimento agropecuário. | — |
| 192.4 | `indDeduzDeson` | Indica se o valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd). | Numérico | 0-1 | 1 | — | O campo só pode ser preenchido com: 0=Valor do ICMS desonerado (vICMSDeson) não deduz do valor do item (vProd) / total da NF-e. 1=Valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd) / total da NF-e. | — |

<a id="icms_30"></a>

###### `icms_30` — Grupo Tributação do ICMS= 30

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_30`  
**ID:** 193 · **Ocorrência:** 1-1 · **Linha na planilha:** 459  
**Rótulo na planilha:** Tributação de ICMS CST - 30  

> Tributação Isenta ou não tributada e com cobrança do ICMS por substituição tributária

Abertura: `--icms_30_ini--;` · Fechamento: `--icms_30_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 194 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 195 | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 30 - Isenta ou não tributada e com cobrança do ICMS por substituição tributária. | — |
| 196 | `modBCST` | Modalidade de determinação da Base de Cálculo do ICMS ST | Numérico | 1-1 | 1 | — | 0 - Preço tabelado ou máximo sugerido;<br>1  - Lista Negativa (Valor);<br>2 - Lista Positiva (Valor);<br>3 - Lista Neutra (Valor);<br>4 - Margem Valor Agregado (%);<br>5 - Pauta (Valor).                                                                                                 6 - Valor da Operação. | — |
| 197 | `pMVAST` | Percentual da margem de valor Adicionado do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 198 | `pRedBCST` | Percentual da Redução de Base de Cálculo do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 199 | `vBCST` | Valor da Base de Cálculo do ICMS ST | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 200 | `pICMSST` | Alíquota do imposto do ICMS ST | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS ST sem o FCP. <br>Quando for o caso, informar a alíquota do FCP no campo pFCPST. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 201 | `vICMSST` | Valor do ICMS ST retido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-4) — Sequência XML (0-1)

➡️ Sub-bloco: [`x_icms30_deson`](#x_icms30_deson) — Sequência XML (0-1)

<a id="sequencia_xml-4"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_30` › `sequencia_XML`  
**ID:** 201.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 468  

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 201.w | `vBCFCPST` | Valor da Base de Cálculo do FCP retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 201.x | `pFCPST` | Percentualdo FCP retido por substituição tributária | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 201.y | `vFCPST` | Valor do FCP retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_icms30_deson"></a>

###### `x_icms30_deson` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_30` › `x_icms30_deson`  
**ID:** 201.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 473  
**Rótulo na planilha:** XML - ICMS 30 Desonerado  

> Grupo Opcional.

Abertura: `--x_icms30_deson_ini--;` · Fechamento: `--x_icms30_deson_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 201.2 | `vICMSDeson` | Valor do ICMS desonerado | Numérico | 1-1 | 15 | 2 | Informar apenas nos motivos de desoneração documentados abaixo. | 15 posições, sendo 13 inteiros e 2 decimais |
| 201.3 | `motDesICMS` | Motivo da desoneração do ICMS | Numérico | 1-1 | 2 | — | Campo será preenchido quando o campo anterior estiver preenchido. Informar o motivo da desoneração:<br>6 - Utilitários e Motocicletas da Amazônia Ocidental e Áreas de Livre Comércio (Resolução 714/88 e 790/94 - CONTRAN e suas alterações);<br>7 - SUFRAMA;<br>9 - Outros. | — |
| 201.4 | `indDeduzDeson` | Indica se o valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd). | Numérico | 0-1 | 1 | — | O campo só pode ser preenchido com: 0=Valor do ICMS desonerado (vICMSDeson) não deduz do valor do item (vProd) / total da NF-e. 1=Valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd) / total da NF-e. | — |

<a id="icms_40"></a>

###### `icms_40` — Grupo Tributação do ICMS= 40, 41, 50

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_40`  
**ID:** 202 · **Ocorrência:** 1-1 · **Linha na planilha:** 479  
**Rótulo na planilha:** Tributação do ICMS CST - 40 41 50  

> Tributação Isenta, Não tributada ou Suspensão

Abertura: `--icms_40_ini--;` · Fechamento: `--icms_40_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 203 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 204 | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 40 - Isenta;<br>41  - Não tributada;<br>50 - Suspensão. | — |

➡️ Sub-bloco: [`x_icms40_deson`](#x_icms40_deson) — Sequência XML (0-1)

<a id="x_icms40_deson"></a>

###### `x_icms40_deson` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_40` › `x_icms40_deson`  
**ID:** 204.00 · **Ocorrência:** 0-1 · **Linha na planilha:** 482  
**Rótulo na planilha:** XML - ICMS 40 Desonerado  

> Grupo Opcional.

Abertura: `--x_icms40_deson_ini--;` · Fechamento: `--x_icms40_deson_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 204.01 | `vICMSDeson` | Valor do ICMS desonerado | Numérico | 1-1 | 15 | 2 | Informar apenas nas operações:<br>a) com produtos beneficiados com a desoneração condicional do ICMS.<br>b) destinadas à SUFRAMA, informando-se o valor que seria devido se não houvesse isenção.<br>c) de venda a órgão da administração pública direta e suas fundações e autarquias com isenção do ICMS. (NT 2011/004).<br>d) demais casos solicitados pelo fisco (NT2016.002 v1.50) | 15 posições, sendo 13 inteiros e 2 decimais |
| 204.02 | `motDesICMS` | Motivo da desoneração do ICMS | Numérico | 1-1 | 2 | — | Campo será preenchido quando o campo anterior estiver preenchido. Informar o motivo da desoneração:<br>1- Taxi;<br>3- Produtor Agropecuário;<br>4- Frotista/Locadora<br>5- Diplomático/Consular<br>6- Utilitários e Motocicletas da Amazônia Ocidental e Áreas de Livre Comércio (Resolução 714/88 e 790/94 - CONTRAN e suas alterações);<br>7- SUFRAMA<br>8- Venda a Órgão Público<br>9- Outros;<br>10-Deficiente Condutor (Convênio ICMS 38/12);<br>11- Deficiente Não Condutor (Convênio ICMS 38/12); <br>16 - Olimpíadas Rio 2016 (NT2015.002)<br>90 - Solicitado pelo Fisco (NT2016.002 v1.50) | — |
| 204.03 | `indDeduzDeson` | Indica se o valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd). | Numérico | 0-1 | 1 | — | O campo só pode ser preenchido com: 0=Valor do ICMS desonerado (vICMSDeson) não deduz do valor do item (vProd) / total da NF-e. 1=Valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd) / total da NF-e. | — |

<a id="icms_51"></a>

###### `icms_51` — Grupo Tributação do ICMS= 51

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_51`  
**ID:** 205 · **Ocorrência:** 1-1 · **Linha na planilha:** 488  
**Rótulo na planilha:** Tributação do ICMS CST - 51  

> Tributação com Diferimento (a exigência do preenchimento das informações do ICMS diferido fica a critério de cada UF)

Abertura: `--icms_51_ini--;` · Fechamento: `--icms_51_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 206 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 207 | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | Tributação pelo ICMS 51 - Diferimento | — |
| 208 | `modBC` | Modalidade de determinação da Base de Cálculo do ICMS | Numérico | 0-1 | 1 | — | 0 - Margem Valor Agregado (%);<br>1  - Pauta (Valor);<br>2 - Preço tabelado Máx. (Valor);<br>3 - Valor da operação. | — |
| 209 | `pRedBC` | Percentual de Redução de Base de Cálculo | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 209.01 | `cBenefRBC` | Código de Benefício Fiscal na UF aplicado ao item quando houver RBC. | Caractere | 0-1 | 10 | — | Código de Benefício Fiscal utilizado pela UF, aplicado ao item quando houver RBC. Obs.: Deve ser utilizado o mesmo código adotado na EFD e outras declarações, nas UF que o exigem. (Incluído na NT 2019.001) | — |
| 210 | `vBC` | Valor da Base de Cálculo do ICMS | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 211 | `pICMS` | Alíquota do imposto | Numérico | 0-1 | 7 | 2-4 | Alíquota do ICMS sem o FCP. <br>Quando for o caso, informar a alíquota do FCP no campo pFCP. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 211.01 | `vICMSOp` | Valor do ICMS da Operação | Numérico | 0-1 | 15 | 2 | Valor como se não tivesse o diferimento | 15 posições, sendo 13 inteiros e 2 decimais |
| 211.02 | `pDif` | Percentual do diferimento | Numérico | 0-1 | 7 | 2-4 | No caso de diferimento total, informar o percentual de diferimento "100". | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 211.03 | `vICMSDif` | Valor do ICMS diferido | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 212 | `vICMS` | Valor do ICMS | Numérico | 0-1 | 15 | 2 | Informar o valor realmente devido. | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-5) — Sequência XML (0-1)

➡️ Sub-bloco: [`sequencia_XML_FCP_diferido`](#sequencia_xml_fcp_diferido) — Sequência XML (0-1)

<a id="sequencia_xml-5"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_51` › `sequencia_XML`  
**ID:** 212.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 500  

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 212.w | `vBCFCP` | Valor da Base de Cálculo do FCP | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 212.x | `pFCP` | Percentual do Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 212.y | `vFCP` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 15 | 2 | Valor do ICMS relativo ao Fundo de Combate à Pobreza<br>(FCP). Valor como se não houvesse diferimento | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml_fcp_diferido"></a>

###### `sequencia_XML_FCP_diferido` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_51` › `sequencia_XML_FCP_diferido`  
**ID:** 212.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 505  

> Grupo Opcional.

Abertura: `--sequencia_XML_FCP_diferido_ini--;` · Fechamento: `--sequencia_XML_FCP_diferido_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 212.a | `pFCPDif` | Percentual do diferimento do ICMS relativo ao Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 7 | 2-4 | Percentual do diferimento do ICMS relativo ao Fundo de <br>Combate à Pobreza (FCP). No caso de diferimento total, <br>informar o percentual de diferimento "100" | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 212.b | `vFCPDif` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) diferido | Numérico | 1-1 | 15 | 2 | Valor do ICMS relativo ao Fundo de Combate à Pobreza <br>(FCP) diferido | 15 posições, sendo 13 inteiros e 2 decimais |
| 212.c | `vFCPEfet` | Valor efetivo do ICMS relativo ao Fundo de Combate à Pobreza (FCP) | Numérico | 0-1 | 15 | 2 | Valor do ICMS relativo ao Fundo de Combate à Pobreza <br>(FCP) realmente devido. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_53"></a>

###### `icms_53` — Grupo Tributação do ICMS monofásico = 53

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_53`  
**ID:** 212.d · **Ocorrência:** 1-1 · **Linha na planilha:** 511  
**Rótulo na planilha:** Tributação de ICMS CST - 53  

> Tributação monofásica sobre combustíveis com recolhimento diferido;

Abertura: `--icms_53_ini--;` · Fechamento: `--icms_53_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 212.e | `orig` | Origem da mercadoria | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8; 1 -Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante lista CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%; | — |
| 212.f | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 53= Tributação monofásica sobre combustíveis com recolhimento diferido; | — |
| 212.01j | `qBCMono` | Quantidade Tributada | Numérico | 0-1 | 15 | 0-4 | Informar a BC do ICMS em quantidade conforme unidade de medida estabelecida na legislação para o produto. | 15 posições, sendo 11 inteiros e 0 a 4 decimais. |
| 212.02j | `adRemICMS` | Alíquota adRem do imposto | Numérico | 0-1 | 7 | 2-4 | Alíquota ad rem do ICMS estabelecida na legislação para o produto. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 212.03j | `vICMSMonoOp` | Valor do ICMS da operação | Numérico | 0-1 | 15 | 2 | O valor do ICMS é obtido pela multiplicação da alíquota ad rem pela quantidade do produto conforme unidade de medida estabelecida em legislação, como se não houvesse o diferimento | 15 posições, sendo 13 inteiros e 2 decimais |
| 212.04j | `pDif` | Percentual do diferimento | Numérico | 0-1 | 7 | 2-4 | No caso de diferimento total, informar o percentual de diferimento "100". | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 212.h | `vICMSMonoDif` | Valor do ICMS diferido | Numérico | 0-1 | 15 | 2 | O valor do ICMS é obtido pela multiplicação da alíquota ad rem pela quantidade do produto conforme unidade de medida estabelecida, multiplicado pelo percentual de diferimento. | 15 posições, sendo 13 inteiros e 2 decimais |
| 212.05j | `vICMSMono` | Valor do ICMS próprio devido | Numérico | 0-1 | 15 | 2 | O valor do ICMS próprio devido é o resultado do valor do ICMS da operação menos valor do ICMS diferido. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_60"></a>

###### `icms_60` — Grupo Tributação do ICMS= 60

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_60`  
**ID:** 213 · **Ocorrência:** 1-1 · **Linha na planilha:** 521  
**Rótulo na planilha:** Tributação de ICMS CST - 60  

> Tributação ICMS cobrado anteriormente por substituição tributária

Abertura: `--icms_60_ini--;` · Fechamento: `--icms_60_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 214 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 215 | `CST` | Tributação do ICMS | Numérico | — | 2 | — | 60 - ICMS cobrado anteriormente por substituição tributária | — |

➡️ Sub-bloco: [`x_icms60_retido`](#x_icms60_retido) — Sequência XML (0-1)

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-6) — Sequência XML (0-1)

➡️ Sub-bloco: [`x_icms_efetivo`](#x_icms_efetivo) — Informações do ICMS Efetivo (0-1)

<a id="x_icms60_retido"></a>

###### `x_icms60_retido` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_60` › `x_icms60_retido`  
**ID:** 215.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 524  
**Rótulo na planilha:** XML - ICMS 60 Retido  

> Grupo Opcional.

Abertura: `--x_icms60_retido_ini--;` · Fechamento: `--x_icms60_retido_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 216 | `vBCSTRet` | Valor da Base de Cálculo do ICMS ST retido | Numérico | 1-1 | 15 | 2 | Valor da BC do ICMS ST cobrado anteriormente por ST.<br>O valor pode ser omitido quando a legislação não exigir a sua informação. (NT 2011/004). | 15 posições, sendo 13 inteiros e 2 decimais |
| 216.1 | `pST` | Alíquota suportada pelo Consumidor Final | Numérico | 1-1 | 7 | 2-4 | Deve ser informada a alíquota do cálculo do ICMS-ST, já incluso o FCP caso incida sobre a mercadoria. <br>Exemplo: Alíquota da mercadoria na venda ao consumidor final = 18% e 2% de FCP. A alíquota a ser informada no campo pST deve ser 20%. | 7 posições, sendo 3 inteiros e 2 a 4 decimais<br>Nota: Campo inserido na versão 1.10 da NT2016.002 |
| 216.2 | `vICMSSubstituto` | Valor do ICMS próprio do Substituto | Numérico | 0-1 | 15 | 2 | Valor do ICMS Próprio do Substituto cobrado em operação anterior | 15 posições, sendo 13 inteiros e 2 decimais |
| 217 | `vICMSSTRet` | Valor do ICMS ST retido | Numérico | 1-1 | 15 | 2 | Valor do ICMS ST cobrado anteriormente por ST.<br>O valor pode ser omitido quando a legislação não exigir a sua informação. (NT 2011/004). | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml-6"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_60` › `sequencia_XML`  
**ID:** 217.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 530  

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 217.w | `vBCFCPSTRet` | Valor da Base de Cálculo do FCP retido anteriormente por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 217.x | `pFCPSTRet` | Percentual do Fundo de Combate à Pobreza (FCP) retido anteriormente por Substituição Tributária | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 217.y | `vFCPSTRet` | Valor do Fundo de Combate à Pobreza (FCP) retido anteriormente  por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_icms_efetivo"></a>

###### `x_icms_efetivo` — Informações do ICMS Efetivo

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_60` › `x_icms_efetivo`  
**ID:** 217.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 535  
**Rótulo na planilha:** Sequência XML - ICMS Efetivo  

> Grupo Opcional

Abertura: `--x_icms_efetivo_ini--;` · Fechamento: `--x_icms_efetivo_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 217.2 | `pRedBCEfet` | Percentual de redução da base de cáclulo efetiva | Numérico | 1-1 | 7 | 2-4 | Percentual de redução, caso estivesse submetida ao regime comum de tributação, para obtenção da base de cálculo efetiva (vBCEfet).<br>Obs. Opcional a critério da UF. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 217.3 | `vBCEfet` | Valor da base de cálculo efetiva | Numérico | 1-1 | 15 | 2 | Valor da base de cálculo que seria atribuída à operação própria do contribuinte substituído, caso estivesse submetida ao regime comum de tributação, obtida pelo produto do vProd por (1 - pRedBCEfet).<br>Obs.: opcional a critério da UF. | 15 posições, sendo 13 inteiros e 2 decimais |
| 217.4 | `pICMSEfet` | Alíquota do ICMS efetiva | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS na operação a consumidor final, caso estivesse submetida ao regime comum de tributação;<br>Obs.: opcional a critério da UF. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 217.5 | `vICMSEfet` | Valor do ICMS Efetivo | Numérico | 1-1 | 15 | 2 | Obtido pelo produto do valor do campo pICMSEfet pelo valor do campo vBCEfet, caso estivesse submetida ao regime comum de tributação.<br>Obs.: opcional a critério da UF. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_61"></a>

###### `icms_61` — Grupo Tributação do ICMS monofásico = 61

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_61`  
**ID:** 217.6 · **Ocorrência:** 1-1 · **Linha na planilha:** 542  
**Rótulo na planilha:** Tributação de ICMS CST - 61  

> Tributação monofásica sobre combustíveis cobrada anteriormente;

Abertura: `--icms_61_ini--;` · Fechamento: `--icms_61_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 217.6a | `orig` | Origem da mercadoria | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8; 1 -Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante lista CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%; | — |
| 217.6b | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 61= Tributação monofásica sobre combustíveis cobrada anteriormente; | — |
| 217.6e | `qBCMonoRet` | Quantidade tributada retida anteriormente | Numérico | 0-1 | 15 | 0-4 | Informar a BC do ICMS em quantidade conforme unidade de medida estabelecida na legislação. | 15 posições, sendo 11 inteiros e 0 a 4 decimais. |
| 217.6c | `adRemICMSRet` | Alíquota ad rem do imposto retido anteriormente | Numérico | 1-1 | 7 | 2-4 | Alíquota ad rem do ICMS estabelecida em legislação para o produto. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 217.6d | `vICMSMonoRet` | Valor do ICMS retido anteriormente | Numérico | 1-1 | 15 | 2 | O valor do ICMS é obtido pela multiplicação da alíquota ad rem pela quantidade do produto conforme unidade de medida estabelecida em legislação. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_70"></a>

###### `icms_70` — Grupo Tributação do ICMS= 70

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_70`  
**ID:** 218 · **Ocorrência:** 1-1 · **Linha na planilha:** 549  
**Rótulo na planilha:** Tributação do ICMS CST - 70  

> Tributação ICMS com redução de base de cálculo e cobrado do ICMS por substituição tributária

Abertura: `--icms_70_ini--;` · Fechamento: `--icms_70_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 219 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 220 | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 70 - Com redução de base de cálculo e cobrança do ICMS por substituição tributária ICMS | — |
| 221 | `modBC` | Modalidade de determinação da Base de Cálculo do ICMS | Numérico | 1-1 | 1 | — | 0 - Margem Valor Agregado (%);<br>1  - Pauta (Valor);<br>2 - Preço tabelado Máx. (Valor);<br>3 - Valor da operação. | — |
| 222 | `pRedBC` | Percentual da Redução de Base de Cálculo | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 223 | `vBC` | Valor da Base de Cálculo do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 224 | `pICMS` | Alíquota do imposto | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS sem o FCP. <br>Quando for o caso, informar a alíquota do FCP no campo pFCP. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 225 | `vICMS` | Valor do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML_FCP`](#sequencia_xml_fcp-1) — Sequência XML para FCP (0-1)

*Continuação dos campos de `icms_70` (após o fechamento de `sequencia_XML_FCP`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 226 | `modBCST` | Modalidade de determinação da Base de Cálculo do ICMS ST | Numérico | 1-1 | 1 | — | 0 - Preço tabelado ou máximo sugerido;<br>1  - Lista Negativa (Valor);<br>2 - Lista Positiva (Valor);<br>3 - Lista Neutra (Valor);<br>4 - Margem Valor Agregado (%);<br>5 - Pauta (Valor).<br>6 - Valor da operação. | — |
| 227 | `pMVAST` | Percentual da margem de valor Adicionado do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 228 | `pRedBCST` | Percentual da Redução de Base de Cálculo do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 229 | `vBCST` | Valor da Base de Calculo do ICMS ST | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 230 | `pICMSST` | Alíquota do imposto do ICMS ST | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS ST sem o FCP. <br>Quando for o caso, informar a alíquota do FCP no campo pFCPST. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 231 | `vICMSST` | Valor do ICMS ST retido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML_FCPST`](#sequencia_xml_fcpst-1) — Sequência XML para FCP retido por ST (0-1)

➡️ Sub-bloco: [`x_icms70_deson`](#x_icms70_deson) — Sequência XML (0-1)

➡️ Sub-bloco: [`x_icmsst70_deson`](#x_icmsst70_deson) — Sequência XML para ICMS ST Desonerado (0-1)

<a id="sequencia_xml_fcp-1"></a>

###### `sequencia_XML_FCP` — Sequência XML para FCP

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_70` › `sequencia_XML_FCP`  
**ID:** 225.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 557  
**Rótulo na planilha:** Sequência XML  

Abertura: `--sequencia_XML_FCP_ini--;` · Fechamento: `--sequencia_XML_FCP_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 225.1 | `vBCFCP` | Valor da Base de Cálculo do FCP | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 225.2 | `pFCP` | Percentual do Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 225.3 | `vFCP` | Valor do Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml_fcpst-1"></a>

###### `sequencia_XML_FCPST` — Sequência XML para FCP retido por ST

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_70` › `sequencia_XML_FCPST`  
**ID:** 231.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 568  
**Rótulo na planilha:** Sequência XML  

Abertura: `--sequencia_XML_FCPST_ini--;` · Fechamento: `--sequencia_XML_FCPST_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 231.w | `vBCFCPST` | Valor da Base de Cálculo do FCP retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 231.x | `pFCPST` | Percentual do Fundo de Combate à Pobreza (FCP) retido por substituição tributária | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 231.y | `vFCPST` | Valor do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_icms70_deson"></a>

###### `x_icms70_deson` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_70` › `x_icms70_deson`  
**ID:** 231.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 573  
**Rótulo na planilha:** XML - ICMS 70 Desonerado  

> Grupo Opcional.

Abertura: `--x_icms70_deson_ini--;` · Fechamento: `--x_icms70_deson_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 231.2 | `vICMSDeson` | Valor do ICMS desonerado | Numérico | 1-1 | 15 | 2 | Informar apenas nos motivos de desoneração documentados abaixo. | 15 posições, sendo 13 inteiros e 2 decimais |
| 231.3 | `motDesICMS` | Motivo da desoneração do ICMS | Numérico | 1-1 | 2 | — | Campo será preenchido quando o campo anterior estiver preenchido. Informar o motivo da desoneração:<br>3  - Uso na agropecuária;<br>9  - Outros;<br>12 - Órgão de fomento e desenvolvimento agropecuário. | — |
| 231.1a | `indDeduzDeson` | Indica se o valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd). | Numérico | 0-1 | 1 | — | O campo só pode ser preenchido com: 0=Valor do ICMS desonerado (vICMSDeson) não deduz do valor do item (vProd) / total da NF-e. 1=Valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd) / total da NF-e. | — |

<a id="x_icmsst70_deson"></a>

###### `x_icmsst70_deson` — Sequência XML para ICMS ST Desonerado

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_70` › `x_icmsst70_deson`  
**ID:** 231.4 · **Ocorrência:** 0-1 · **Linha na planilha:** 578  
**Rótulo na planilha:** Sequência XML  

> Grupo Opcional.

Abertura: `--x_icmsst70_deson_ini--;` · Fechamento: `--x_icmsst70_deson_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 231.5 | `vICMSSTDeson` | Valor do ICMS- ST desonerado | Numérico | 1-1 | 15 | 2 | Informar apenas nos motivos de desoneração documentados abaixo. | 15 posições, sendo 13 inteiros e 2 decimais |
| 231.6 | `motDesICMSST` | Motivo da desoneração do ICMS- ST | Numérico | 1-1 | 2 | — | Campo será preenchido quando o campo anterior estiver<br>preenchido. Informar o motivo da desoneração:<br>3 - Uso na agropecuária;<br>9 - Outros;<br>12 - Órgão de fomento e desenvolvimento agropecuário; | — |

<a id="icms_90"></a>

###### `icms_90` — Grupo Tributação do ICMS= 90

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_90`  
**ID:** 232 · **Ocorrência:** 1-1 · **Linha na planilha:** 583  
**Rótulo na planilha:** Tributação de ICMS CST - 90  

> Tributação ICMS: Outros

Abertura: `--icms_90_ini--;` · Fechamento: `--icms_90_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 233 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 234 | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 90 - Outros | — |

➡️ Sub-bloco: [`x_icms90_icms`](#x_icms90_icms) — Sequência XML (0-1)

➡️ Sub-bloco: [`x_icms90_icmsst`](#x_icms90_icmsst) — Sequência XML (0-1)

➡️ Sub-bloco: [`x_icms90_deson`](#x_icms90_deson) — Sequência XML (0-1)

➡️ Sub-bloco: [`x_icmsst90_deson`](#x_icmsst90_deson) — Sequência XML para ICMS ST Desonerado (0-1)

<a id="x_icms90_icms"></a>

###### `x_icms90_icms` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_90` › `x_icms90_icms`  
**ID:** 234.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 586  
**Rótulo na planilha:** XML - ICMS 90 / ICMS  

> Grupo Opcional.

Abertura: `--x_icms90_icms_ini--;` · Fechamento: `--x_icms90_icms_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 235 | `modBC` | Modalidade de determinação da Base de Cálculo do ICMS | Numérico | 1-1 | 1 | — | 0 - Margem Valor Agregado (%);<br>1  - Pauta (Valor);<br>2 - Preço tabelado Máx. (valor);<br>3 - Valor da operação. | — |
| 236 | `vBC` | Valor da Base de Cálculo do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 237 | `pRedBC` | Percentual da Redução de Base de Cálculo | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 238 | `pICMS` | Alíquota do imposto | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS sem o FCP. <br>Quando for o caso, informar a alíquota do FCP no campo pFCP. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 239 | `vICMS` | Valor do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 237.1a | `cBenefRBC` | Código de Benefício Fiscal na UF aplicado ao item quando houver RBC. | Caractere | 0-1 | 10 | — | Código de Benefício Fiscal utilizado pela UF, aplicado ao <br>item quando houver RBC. <br>Obs.: Deve ser utilizado o mesmo código adotado na EFD e <br>outras declarações, nas UF que o exigem. | — |

➡️ Sub-bloco: [`sequencia_XML_op`](#sequencia_xml_op) — Sequência XML (0-1)

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-7) — Sequência XML (0-1)

➡️ Sub-bloco: [`sequencia_XML_fcpdif`](#sequencia_xml_fcpdif) — Sequência XML (0-1)

<a id="sequencia_xml_op"></a>

###### `sequencia_XML_op` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_90` › `x_icms90_icms` › `sequencia_XML_op`  
**ID:** 238.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 593  

Abertura: `--sequencia_XML_op_ini--;` · Fechamento: `--sequencia_XML_op_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 238.01 | `vICMSOp` | Valor do ICMS da Operação | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 238.02 | `pDif` | Percentual do diferimento | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 238.03 | `vICMSDif` | Valor do ICMS diferido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml-7"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_90` › `x_icms90_icms` › `sequencia_XML`  
**ID:** 239.01 · **Ocorrência:** 0-1 · **Linha na planilha:** 598  

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 239.02 | `vBCFCP` | Valor da Base de Cálculo do FCP | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 239.03 | `pFCP` | Percentual do Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 239.04 | `vFCP` | Valor do Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml_fcpdif"></a>

###### `sequencia_XML_fcpdif` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_90` › `x_icms90_icms` › `sequencia_XML_fcpdif`  
**ID:** 239.05 · **Ocorrência:** 0-1 · **Linha na planilha:** 603  

Abertura: `--sequencia_XML_fcpdif_ini--;` · Fechamento: `--sequencia_XML_fcpdif_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 239.06 | `pFCPDif` | Percentual do diferimento do ICMS relativo ao Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 239.07 | `vFCPDif` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) diferido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 239.08 | `vFCPEfet` | Valor efetivo do ICMS relativo ao Fundo de Combate à Pobreza (FCP) | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_icms90_icmsst"></a>

###### `x_icms90_icmsst` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_90` › `x_icms90_icmsst`  
**ID:** 239.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 609  
**Rótulo na planilha:** XML - ICMS 90 / ICMSST  

> Grupo Opcional.

Abertura: `--x_icms90_icmsst_ini--;` · Fechamento: `--x_icms90_icmsst_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 240 | `modBCST` | Modalidade de determinação da Base de Cálculo do ICMS ST | Numérico | 1-1 | 1 | — | 0 - Preço tabelado ou máximo sugerido;<br>1  - Lista Negativa (Valor);<br>2 - Lista Positiva (Valor);<br>3 - Lista Neutra (Valor);<br>4 - Margem Valor Agregado (%);<br>5 - Pauta (Valor).<br>6 -Valor da Operação. | — |
| 241 | `pMVAST` | Percentual da margem de valor Adicionado do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 242 | `pRedBCST` | Percentual da Redução de Base de Cálculo do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 243 | `vBCST` | Valor da Base de Cálculo do ICMS ST | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 244 | `pICMSST` | Alíquota do imposto do ICMS ST | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS ST sem o FCP. <br>Quando for o caso, informar a alíquota do FCP no campo pFCPST. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245 | `vICMSST` | Valor do ICMS ST retido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-8) — Sequência XML (0-1)

<a id="sequencia_xml-8"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_90` › `x_icms90_icmsst` › `sequencia_XML`  
**ID:** 245.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 616  

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.w | `vBCFCPST` | Valor da Base de Cálculo do FCP retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.x | `pFCPST` | Percentualdo Fundo de Combate à Pobreza (FCP) retido por substituição tributária | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.y | `vFCPST` | Valor do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_icms90_deson"></a>

###### `x_icms90_deson` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_90` › `x_icms90_deson`  
**ID:** 245.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 622  
**Rótulo na planilha:** XML - ICMS 90 Desonerado  

> Grupo Opcional.

Abertura: `--x_icms90_deson_ini--;` · Fechamento: `--x_icms90_deson_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.2 | `vICMSDeson` | Valor do ICMS desonerado | — | 1-1 | 15 | 2 | Informar apenas nos motivos de desoneração documentados abaixo. | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.3 | `motDesICMS` | Motivo da desoneração do ICMS | — | 1-1 | 2 | — | Campo será preenchido quando o campo anterior estiver preenchido. Informar o motivo da desoneração:<br>3 - Uso na agropecuária;<br>9 - Outros;<br>12 - Órgão de fomento e desenvolvimento agropecuário. | — |
| 245.4 | `indDeduzDeson` | Indica se o valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd). | Numérico | 0-1 | 1 | — | O campo só pode ser preenchido com: 0=Valor do ICMS desonerado (vICMSDeson) não deduz do valor do item (vProd) / total da NF-e. 1=Valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd) / total da NF-e. | — |

<a id="x_icmsst90_deson"></a>

###### `x_icmsst90_deson` — Sequência XML para ICMS ST Desonerado

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_90` › `x_icmsst90_deson`  
**ID:** 245.4 · **Ocorrência:** 0-1 · **Linha na planilha:** 627  
**Rótulo na planilha:** Sequência XML  

> Grupo Opcional.

Abertura: `--x_icmsst90_deson_ini--;` · Fechamento: `--x_icmsst90_deson_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.5 | `vICMSSTDeson` | Valor do ICMS- ST desonerado | Numérico | 1-1 | 15 | 2 | Informar apenas nos motivos de desoneração documentados abaixo. | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.6 | `motDesICMSST` | Motivo da desoneração do ICMS- ST | Numérico | 1-1 | 2 | — | Campo será preenchido quando o campo anterior estiver<br>preenchido. Informar o motivo da desoneração:<br>3 - Uso na agropecuária;<br>9 - Outros;<br>12 - Órgão de fomento e desenvolvimento agropecuário; | — |

<a id="icms_part"></a>

###### `icms_part` — Grupo de Partilha do ICMS entre a UF de origem e UF de destino ou a UF definida na legislação.

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_part`  
**ID:** 245.01 · **Ocorrência:** 1-1 · **Linha na planilha:** 632  
**Rótulo na planilha:** Partilha de ICMS entre origem e destino  

> Operação interestadual para consumidor final com partilha do ICMS devido na operação entre a UF de origem e a do destinatário, ou a UF definida na legislação. (EX. UF da concessionária de entrega do veículo)

Abertura: `--icms_part_ini--;` · Fechamento: `--icms_part_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.02 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 245.03 | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 10 - Tributada e com cobrança do ICMS por substituição tributária; <br>20 - Com redução de base de cálculo<br>90 - Outros. | — |
| 245.04 | `modBC` | Modalidade de determinação da Base de Cálculo do ICMS | Numérico | 1-1 | 1 | — | 0 - Margem Valor Agregado (%); <br>1 - Pauta (Valor); <br>2 - Preço Tabelado Máx. (Valor);<br>3 - Valor da operação. | — |
| 245.05 | `vBC` | Valor de Base de Cálculo do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.06 | `pRedBC` | Percentual da Redução de Base de Cálculo | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.07 | `pICMS` | Alíquota do imposto | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.08 | `vICMS` | Valor do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.09 | `modBCST` | Modalidade de determinação da Base de Cálculo do ICMS ST | Numérico | 1-1 | 1 | — | 0 – Preço tabelado ou máximo sugerido; <br>1 - Lista Negativa (valor); <br>2 - Lista Positiva (valor);<br>3 - Lista Neutra (valor);<br>4 - Margem Valor Agregado (%); <br>5 - Pauta (valor); | — |
| 245.10 | `pMVAST` | Percentual da margem de valor Adicionado do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.11 | `pRedBCST` | Percentual da redução de Base de Cálculo do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.12 | `vBCST` | Valor da Base de Cálculo do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.13 | `pICMSST` | Alíquota do imposto ICMS ST | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.14 | `vICMSST` | Valor do ICMS ST | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-9) — Sequencia XML (0-1)

*Continuação dos campos de `icms_part` (após o fechamento de `sequencia_XML`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.15 | `pBCOp` | Percentual para determinação do valor da Base de Cálculo da operação própria. | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.16 | `UFST` | UF para qual é devido o ICMS  ST | Caractere | 1-1 | 2 | — | Sigla da UF para qual é devido o ICMS ST da operação.<br>Informar "EX" para Exterior. | — |

➡️ Sub-bloco: [`sequencia_XML_deson`](#sequencia_xml_deson) — Sequencia XML (0-1)

<a id="sequencia_xml-9"></a>

###### `sequencia_XML` — Sequencia XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_part` › `sequencia_XML`  
**ID:** 245.14a · **Ocorrência:** 0-1 · **Linha na planilha:** 646  
**Rótulo na planilha:** Sequência XML  

> Grupo opcional para informações do FCP retido por ST

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.14b | `vBCFCPST` | Valor da Base de Cálculo do FCP ST | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.14c | `pFCPST` | Percentual do FCP ST | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.14d | `vFCPST` | Valor do FCP ST | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml_deson"></a>

###### `sequencia_XML_deson` — Sequencia XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_part` › `sequencia_XML_deson`  
**ID:** 245.17 · **Ocorrência:** 0-1 · **Linha na planilha:** 653  
**Rótulo na planilha:** Sequência XML ICMS Desonerado  

> Grupo opcional para informações do ICMS Desonerado

Abertura: `--sequencia_XML_deson_ini--;` · Fechamento: `--sequencia_XML_deson_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.18 | `vICMSDeson` | Valor do ICMS desonerado | Numérico | 1-1 | 15 | 2 | Informar apenas nos motivos de desoneração documentados abaixo. | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.19 | `motDesICMS` | Motivo da desoneração do ICMS | Numérico | 1-1 | 2 | — | Campo será preenchido quando o campo anterior estiver <br>preenchido. Informar o motivo da desoneração: <br>9 - Outros; <br>10 - Deficiente Condutor (Convênio ICMS 38/12); <br>11 - Deficiente Não Condutor (Convênio ICMS 38/12); | — |
| 245.20 | `indDeduzDeson` | Indica se o valor do ICMS desonerado (vICMSDeson) deduz do valor do item (vProd). | Numérico | 0-1 | 1 | — | O campo só pode ser preenchido com: <br>0 - Valor do ICMS desonerado (vICMSDeson) não deduz do <br>valor do item (vProd) / total da NF-e. <br>1 - Valor do ICMS desonerado (vICMSDeson) deduz do valor <br>do item (vProd) / total da NF-e. | — |

<a id="icms_st"></a>

###### `icms_st` — Grupo de Repasse de ICMS ST retido anteriormente em operações interestaduais com repasses através do Substituto Tributário

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_st`  
**ID:** 245.17 · **Ocorrência:** 1-1 · **Linha na planilha:** 659  
**Rótulo na planilha:** ICMS ST Repasse de ICMS  

> Grupo de informação do ICMS ST devido para a UF de destino, nas operações interestaduais de produtos que tiveram retenção antecipada de ICMS por ST na UF do remetente. <br>Repasse via Substituto Tributário.

Abertura: `--icms_st_ini--;` · Fechamento: `--icms_st_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.18 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 245.19 | `CST` | Tributação do ICMS | Numérico | 1-1 | 2 | — | 41  - Não Tributado;<br>60 - Cobrado anteriormente por substituição tributária. | — |
| 245.20 | `vBCSTRet` | Valor da Base de Cálculo do ICMS ST retido na UF remetente | Numérico | 1-1 | 15 | 2 | Informar o valor da BC do ICMS ST retido na UF remetente | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.20a | `pST` | Alíquota suportada pelo Consumidor Final | Numérico | 0-1 | 7 | 2-4 | Deve ser informada a alíquota do cálculo do ICMS-ST, já incluso o FCP caso incida sobre a mercadoria. <br>Exemplo: Alíquota da mercadoria na venda ao consumidor final = 18% e 2% de FCP. A alíquota a ser informada no campo pST deve ser 20%. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.20b | `vICMSSubstituto` | Valor do ICMS próprio do Substituto | Numérico | 0-1 | 15 | 2 | Valor do ICMS Próprio do Substituto cobrado em operação anterior | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.21 | `vICMSSTRet` | Valor do ICMS ST retido na UF remetente | Numérico | 1-1 | 15 | 2 | Informar o valor do ICMS ST retido na UF remetente | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-10) — Sequencia XML (0-1)

*Continuação dos campos de `icms_st` (após o fechamento de `sequencia_XML`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.22 | `vBCSTDest` | Valor da Base de Cálculo do ICMS ST da UF destino | Numérico | 1-1 | 15 | 2 | Informar o valor da BC do ICMS ST da UF destino | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.23 | `vICMSSTDest` | Valor do ICMS ST da UF destino | Numérico | 1-1 | 15 | 2 | Informar o valor da BC do ICMS ST da UF destino | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`x_icms_efetivo`](#x_icms_efetivo-1) — Informações do ICMS Efetivo (0-1)

<a id="sequencia_xml-10"></a>

###### `sequencia_XML` — Sequencia XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_st` › `sequencia_XML`  
**ID:** 245.21a · **Ocorrência:** 0-1 · **Linha na planilha:** 666  
**Rótulo na planilha:** Sequência XML  

> Grupo opcional para informações do FCP retido anteriormente por ST

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.21b | `vBCFCPSTRet` | Valor da Base de Cálculo do FCP retido anteriormente por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.21c | `pFCPSTRet` | Percentual do FCP retido anteriormente por Substituição Tributária | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.21d | `vFCPSTRet` | Valor do FCP retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_icms_efetivo-1"></a>

###### `x_icms_efetivo` — Informações do ICMS Efetivo

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_st` › `x_icms_efetivo`  
**ID:** 245.23a · **Ocorrência:** 0-1 · **Linha na planilha:** 673  
**Rótulo na planilha:** ICMS Efetivo  

> Grupo Opcional

Abertura: `--x_icms_efetivo_ini--;` · Fechamento: `--x_icms_efetivo_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.23b | `pRedBCEfet` | Percentual de redução da base de cáclulo efetiva | Numérico | 1-1 | 7 | 2-4 | Percentual de redução, caso estivesse submetida ao regime comum de tributação, para obtenção da base de cálculo efetiva (vBCEfet).<br>Obs. Opcional a critério da UF. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.23c | `vBCEfet` | Valor da base de cálculo efetiva | Numérico | 1-1 | 15 | 2 | Valor da base de cálculo que seria atribuída à operação própria do contribuinte substituído, caso estivesse submetida ao regime comum de tributação, obtida pelo produto do vProd por (1 - pRedBCEfet).<br>Obs.: opcional a critério da UF. | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.23d | `pICMSEfet` | Alíquota do ICMS efetiva | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS na operação a consumidor final, caso estivesse submetida ao regime comum de tributação;<br>Obs.: opcional a critério da UF. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.23e | `vICMSEfet` | Valor do ICMS Efetivo | Numérico | 1-1 | 15 | 2 | Obtido pelo produto do valor do campo pICMSEfet pelo valor do campo vBCEfet, caso estivesse submetida ao regime comum de tributação.<br>Obs.: opcional a critério da UF. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_sn101"></a>

###### `icms_sn101` — Grupo CRT= 1 - Simples Nacional e CSOSN= 101

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn101`  
**ID:** 245.24 · **Ocorrência:** 1-1 · **Linha na planilha:** 680  
**Rótulo na planilha:** Simples Nacional CSOSN - 101  

> Tributação ICMS pelo Simples Nacional, CSOSN=101

Abertura: `--icms_sn101_ini--;` · Fechamento: `--icms_sn101_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.25 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | Tributação ICMS pelo Simples Nacional, CSOSN=101 | — |
| 245.26 | `CSOSN` | Código de Situação da Operação –Simples Nacional | Numérico | 1-1 | 3 | — | 101 - Tributada pelo Simples Nacional com permissão de crédito. | — |
| 245.27 | `pCredSN` | Alíquota aplicável de cálculo do crédito (Simples Nacional) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.28 | `vCredICMSSN` | Valor crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional) | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_sn102"></a>

###### `icms_sn102` — Grupo CRT=1 – Simples Nacional, CRT=4 – MEI e CSOSN=102, 103, 300 ou 400

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn102`  
**ID:** 245.24 · **Ocorrência:** 1-1 · **Linha na planilha:** 686  
**Rótulo na planilha:** Simples Nacional CSOSN - 102, 103, 300 ou 400  

> Tributação ICMS pelo Simples Nacional, CSOSN=102, 103, 300 ou 400

Abertura: `--icms_sn102_ini--;` · Fechamento: `--icms_sn102_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.25 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 0-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 245.26 | `CSOSN` | Código de Situação da Operação – Simples Nacional | Numérico | 1-1 | 3 | — | 102 - Tributada pelo Simples Nacional sem permissão de crédito. <br>103 - Isenção do ICMS no Simples Nacional para faixa de receita bruta. <br>300 - Imune.<br>400 - Não tributada pelo Simples Nacional | — |

<a id="icms_sn201"></a>

###### `icms_sn201` — Grupo CRT= 1 - Simples Nacional e CSOSN= 201

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn201`  
**ID:** 245.27 · **Ocorrência:** 1-1 · **Linha na planilha:** 690  
**Rótulo na planilha:** Simples Nacional CSOSN - 201  

> Tributação ICMS pelo Simples Nacional, CSOSN=201

Abertura: `--icms_sn201_ini--;` · Fechamento: `--icms_sn201_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.28 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 245.29 | `CSOSN` | Código de Situação da Operação – Simples Nacional | Numérico | 1-1 | 3 | — | 201 - Tributada pelo Simples Nacional com permissão de crédito e com cobrança do ICMS por Substituição Tributária | — |
| 245.30 | `modBCST` | Modalidade de determinação da Base de Cálculo do ICMS ST | Numérico | 1-1 | 1 | — | 0 - Preço tabelado ou máximo sugerido;<br>1  - Lista Negativa (Valor);<br>2 - Lista Positiva (Valor);<br>3 - Lista Neutra (Valor);<br>4 - Margem Valor Agregado (%);<br>5 - Pauta (Valor). | — |
| 245.31 | `pMVAST` | Percentual da margem de valor Adicionado do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 224.32 | `pRedBCST` | Percentual da redução de Base de Cálculo do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.33 | `vBCST` | Valor da Base de Cálculo do ICMS ST | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.34 | `pICMSST` | Alíquota do imposto do ICMS ST | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS ST sem o FCP. <br>Quando for o caso, informar a alíquota do FCP no campo pFCPST. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.35 | `vICMSST` | Valor do ICMS ST | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-11) — Sequência XML (0-1)

*Continuação dos campos de `icms_sn201` (após o fechamento de `sequencia_XML`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.36 | `pCredSN` | Alíquota aplicável de cálculo do crédito (Simples Nacional) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.37 | `vCredICMSSN` | Valor credito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional) | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml-11"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn201` › `sequencia_XML`  
**ID:** 245.35.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 699  

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.35w | `vBCFCPST` | Valor da Base de Cálculo do FCP retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.35x | `pFCPST` | Percentual do Fundo de Combate à Pobreza (FCP) retido por substituição tributária | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.35y | `vFCPST` | Valor do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_sn202"></a>

###### `icms_sn202` — Grupo CRT= 1 - Simples Nacional e CSOSN= 202 ou 203

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn202`  
**ID:** 245.38 · **Ocorrência:** 1-1 · **Linha na planilha:** 707  
**Rótulo na planilha:** Simples Nacional CSOSN - 202 ou 203  

> Tributação ICMS pelo Simples Nacional, CSOSN=202 ou 203

Abertura: `--icms_sn202_ini--;` · Fechamento: `--icms_sn202_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.39 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 245.40 | `CSOSN` | Código de Situação da Operação – Simples Nacional | Numérico | 1-1 | 3 | — | 202 - Tributada pelo Simples Nacional sem permissão de crédito e com cobrança do ICMS por Substituição Tributária;<br>203 - Isenção do ICMS nos  Simples Nacional para faixa de receita bruta e com cobrança do ICMS por Substituição Tributária. | — |
| 245.41 | `modBCST` | Modalidade de determinação da Base de Cálculo do ICMS ST | Numérico | 1-1 | 1 | — | 0 - Preço tabelado ou máximo sugerido;<br>1  - Lista Negativa (Valor);<br>2 - Lista Positiva (Valor);<br>3 - Lista Neutra (Valor);<br>4 - Margem Valor Agregado (%);<br>5 - Pauta (Valor). | — |
| 245.42 | `pMVAST` | Percentual da margem de valor Adicionado do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 224.43 | `pRedBCST` | Percentual da redução de Base de Cálculo do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.44 | `vBCST` | Valor da Base de Cálculo do ICMS ST | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.45 | `pICMSST` | Alíquota do imposto do ICMS ST | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS ST sem o FCP. <br>Quando for o caso, informar a alíquota do FCP no campo pFCPST. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.46 | `vICMSST` | Valor do ICMS ST retido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-12) — Sequência XML (0-1)

<a id="sequencia_xml-12"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn202` › `sequencia_XML`  
**ID:** 245.46.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 716  

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.46w | `vBCFCPST` | Valor da Base de Cálculo do FCP retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.46x | `pFCPST` | Percentual do Fundo de Combate à Pobreza (FCP) retido por substituição tributária | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.46y | `vFCPST` | Valor do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_sn500"></a>

###### `icms_sn500` — Grupo CRT= 1 - Simples Nacional e CSOSN= 500

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn500`  
**ID:** 245.47 · **Ocorrência:** 1-1 · **Linha na planilha:** 722  
**Rótulo na planilha:** Simples Nacional CSOSN - 500  

> Tributação ICMS pelo Simples Nacional, CSOSN=500

Abertura: `--icms_sn500_ini--;` · Fechamento: `--icms_sn500_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.48 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 1-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 245.49 | `CSOSN` | Código de Situação da Operação – Simples Nacional | Numérico | 1-1 | 3 | — | 500 - ICMS cobrado anteriormente por substituição tributária (substituído) ou por antecipação. | — |

➡️ Sub-bloco: [`x_sn500_retido`](#x_sn500_retido) — Sequência XML (0-1)

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-13) — Sequência XML (0-1)

➡️ Sub-bloco: [`x_icms_efetivo`](#x_icms_efetivo-2) — Informações do ICMS Efetivo (0-1)

<a id="x_sn500_retido"></a>

###### `x_sn500_retido` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn500` › `x_sn500_retido`  
**ID:** 245.50 · **Ocorrência:** 0-1 · **Linha na planilha:** 725  
**Rótulo na planilha:** XML - SN500 Retido  

> Grupo Opcional.

Abertura: `--x_sn500_retido_ini--;` · Fechamento: `--x_sn500_retido_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.50 | `vBCSTRet` | Valor da Base de Cálculo do ICMS ST retido | Numérico | 1-1 | 15 | 2 | Valor da BC do ICMS ST cobrado anteriormente por ST. <br>O valor pode ser omitido quando a legislação não exigir a sua informação. (NT 2011/004) | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.50.0 | `pST` | Alíquota suportada pelo Consumidor Final | Numérico | 1-1 | 7 | 2-4 | Deve ser informada a alíquota do cálculo de ICMS-ST, já incluso o FCP caso incida sobre a mercadoria. <br>Exemplo: Alíquota da mercadoria na venda ao consumidor final = 18% e 2% de FCP. A alíquota a ser informada no campo pST deve ser 20%. | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.50.1 | `vICMSSubstituto` | Valor do ICMS próprio do Substituto | Numérico | 0-1 | 15 | 2 | Valor do ICMS Próprio do Substituto cobrado em operação anterior | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.51 | `vICMSSTRet` | Valor do ICMS ST retido | Numérico | 1-1 | 15 | 2 | Valor do ICMS ST cobrado anteriormente por ST. <br>O valor pode ser omitido quando a legislação não exigir a sua informação. (NT 2011/004). | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml-13"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn500` › `sequencia_XML`  
**ID:** 245.51.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 731  

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 425.51w | `vBCFCPSTRet` | Valor da Base de Cálculo do FCP retido anteriormente por Substituição Tributária | Numérico | 1-1 | 15 | 2 | Informar o valor da base de Cálculo do FCP retido anteriormente por ST. | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.51x | `pFCPSTRet` | Percentual do Fundo de Combate à Pobreza (FCP) retido anteriormente por ST | Numérico | 1-1 | 7 | 2-4 | Percentual relatívo ao Fundo de Combate à Pobreza. | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.51y | `vFCPSTRet` | Valor do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_icms_efetivo-2"></a>

###### `x_icms_efetivo` — Informações do ICMS Efetivo

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn500` › `x_icms_efetivo`  
**ID:** 245.51.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 736  
**Rótulo na planilha:** Sequência XML - ICMS Efetivo  

> Grupo Opcional

Abertura: `--x_icms_efetivo_ini--;` · Fechamento: `--x_icms_efetivo_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.51.2 | `pRedBCEfet` | Percentual de redução da base de cáclulo efetiva | Numérico | 1-1 | 7 | 2-4 | Percentual de redução, caso estivesse submetida ao regime comum de tributação, para obtenção da base de cálculo efetiva (vBCEfet).<br>Obs. Opcional a critério da UF. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.51.3 | `vBCEfet` | Valor da base de cálculo efetiva | Numérico | 1-1 | 15 | 2 | Valor da base de cálculo que seria atribuída à operação própria do contribuinte substituído, caso estivesse submetida ao regime comum de tributação, obtida pelo produto do vProd por (1 - pRedBCEfet).<br>Obs.: opcional a critério da UF. | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.51.4 | `pICMSEfet` | Alíquota do ICMS efetiva | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS na operação a consumidor final, caso estivesse submetida ao regime comum de tributação;<br>Obs.: opcional a critério da UF. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.51.5 | `vICMSEfet` | Valor do ICMS Efetivo | Numérico | 1-1 | 15 | 2 | Obtido pelo produto do valor do campo pICMSEfet pelo valor do campo vBCEfet, caso estivesse submetida ao regime comum de tributação.<br>Obs.: opcional a critério da UF. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_sn900"></a>

###### `icms_sn900` — Grupo CRT=1 – Simples Nacional, CRT=4 – MEI e CSOSN=900

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn900`  
**ID:** 245.52 · **Ocorrência:** 1-1 · **Linha na planilha:** 743  
**Rótulo na planilha:** Simples Nacional CSOSN - 900  

> Tributação ICMS pelo Simples Nacional, CSOSN=900

Abertura: `--icms_sn900_ini--;` · Fechamento: `--icms_sn900_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.53 | `orig` | Origem da mercadoria <br>(NT 2013.006) | Numérico | 0-1 | 1 | — | 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;<br>1 - Estrangeira - Importação direta, exceto a indicada no código 6;<br>2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;<br>3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%;<br>4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes;<br>5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%;<br>6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural;<br>7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.<br>8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%. | — |
| 245.54 | `CSOSN` | Código de Situação da Operação – Simples Nacional | Numérico | 1-1 | 2 | — | Tributação pelo ICMS 90 - Outros | — |

➡️ Sub-bloco: [`x_sn900_icms`](#x_sn900_icms) — Sequência XML (0-1)

➡️ Sub-bloco: [`x_sn900_icmsst`](#x_sn900_icmsst) — Sequência XML (0-1)

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-14) — Sequência XML (0-1)

➡️ Sub-bloco: [`x_sn900_credito`](#x_sn900_credito) — Sequência XML (0-1)

<a id="x_sn900_icms"></a>

###### `x_sn900_icms` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn900` › `x_sn900_icms`  
**ID:** 245.55 · **Ocorrência:** 0-1 · **Linha na planilha:** 746  
**Rótulo na planilha:** XML - SN900 / ICMS  

> Grupo Opcional.

Abertura: `--x_sn900_icms_ini--;` · Fechamento: `--x_sn900_icms_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.55 | `modBC` | Modalidade de determinação da Base de Cálculo do ICMS ST | Numérico | 1-1 | 1 | — | 0 - Margem Valor Agregado (%); <br>1  - Pauta (Valor); <br>2 - Preço Tabelado Máx. (Valor); <br>3 - Valor da operação. | — |
| 245.56 | `vBC` | Valor do Base de Cálculo do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.57 | `pRedBC` | Percentual da Redução de Base de Cálculo | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.58 | `pICMS` | Alíquota do imposto | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.59 | `vICMS` | Valor do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_sn900_icmsst"></a>

###### `x_sn900_icmsst` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn900` › `x_sn900_icmsst`  
**ID:** 245.60 · **Ocorrência:** 0-1 · **Linha na planilha:** 753  
**Rótulo na planilha:** XML - SN900 / ICMSST  

> Grupo Opcional.

Abertura: `--x_sn900_icmsst_ini--;` · Fechamento: `--x_sn900_icmsst_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.60 | `modBCST` | Modalidade de determinação da Base de Cálculo do ICMS ST | Numérico | 1-1 | 1 | — | 0 - Preço tabelado ou máximo sugerido;<br>1  - Lista Negativa (Valor);<br>2 - Lista Positiva (Valor);<br>3 - Lista Neutra (Valor);<br>4 - Margem Valor Agregado (%);<br>5 - Pauta (Valor). | — |
| 245.61 | `pMVAST` | Percentual da margem de valor Adicionado do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.62 | `pRedBCST` | Percentual da redução de Base de Cálculo do ICMS ST | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.63 | `vBCST` | Valor da Base de Cálculo do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.64 | `pICMSST` | Alíquota do imposto do ICMS ST | Numérico | 1-1 | 7 | 2-4 | Alíquota do ICMS ST sem o FCP. <br>Quando for o caso, informar a alíquota do FCP no campo pFCPST. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.65 | `vICMSST` | Valor do ICMS ST retido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml-14"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn900` › `sequencia_XML`  
**ID:** 245.65.0 · **Ocorrência:** 0-1 · **Linha na planilha:** 761  

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.65w | `vBCFCPST` | Valor da Base de Cálculo do FCP retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245.65x | `pFCPST` | Percentual do Fundo de Combate à Pobreza (FCP) retido por substituição tributária | Numérico | 1-1 | 7 | 2-4 | — | 5 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245.65y | `vFCPST` | Valor do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_sn900_credito"></a>

###### `x_sn900_credito` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `icms_sn900` › `x_sn900_credito`  
**ID:** 245.52 · **Ocorrência:** 0-1 · **Linha na planilha:** 766  
**Rótulo na planilha:** XML - SN900 Crédito  

> Grupo Opcional.

Abertura: `--x_sn900_credito_ini--;` · Fechamento: `--x_sn900_credito_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245.52 | `pCredSN` | Alíquota aplicável de calculo do credito (Simples Nacional) | Numérico | 1-1 | 7 | 2-4 | — | — |
| 245.53 | `vCredICMSSN` | Valor crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional) | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_previsto"></a>

###### `ICMS_Previsto` — Grupo do ICMS Previsto no Pagamento Antecipado 🆕

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS` › `ICMS_Previsto`  
**ID:** 245b.01 · **Ocorrência:** 0-1 · **Linha na planilha:** 771  

> Grupo utilizado exclusivamente em cenários específicos de pagamento antecipado para auxiliar na correta tributação do IBS e da CBS: - tpNFDebito = 06-Pagamento antecipado; - tpOperGov = 4-Recebimento do pagamento com fornecimento posterior. Somente NF-e (modelo 55). Este grupo é uma alternativa aos demais grupos de ICMS do item (ICMS00, ICMS10, ... ICMSSN900): quando informado, nenhum outro grupo de ICMS pode ser enviado no mesmo item. Ocorrência na NT: 1-1 (dentro do grupo, obrigatório apenas nesses cenários). (Incluído na NT 2026.008)

Abertura: `--ICMS_Previsto_ini--;` · Fechamento: `--ICMS_Previsto_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245b.02 | `vICMSPrevisto` 🆕 | Valor do ICMS Previsto | Numérico | 1-1 | 15 | 2 | Valor do ICMS que incidirá no momento do fornecimento futuro. Em cenários onde não haverá valor de ICMS devido no fornecimento, informar 0. (Incluído na NT 2026.008) | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_uf_dest"></a>

###### `ICMS_UF_Dest` — Informação do ICMS Interestadual

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ICMS_UF_Dest`  
**ID:** 245a.01 · **Ocorrência:** 0-1 · **Linha na planilha:** 775  
**Rótulo na planilha:** ICMS Interestadual  

> (NT2015/003)

Abertura: `--ICMS_UF_Dest_ini--;` · Fechamento: `--ICMS_UF_Dest_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 245a.03 | `vBCUFDest` | Valor da Base de Cálculo do ICMS na UF de destino | Numérico | 1-1 | 15 | 2 | Valor da Base de Cálculo do ICMS na UF de destino. | 15 posições, sendo 13 inteiros e 2 decimais |
| 245a.04 | `vBCFCPUFDest` | Valor da Base de Cálculo do FCP na UF de Destino | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 245a.05 | `pFCPUFDest` | Percentual do ICMS relativo ao Fundo de Combate à Pobreza (FCP) na UF de destino | Numérico | 0-1 | 7 | 2-4 | Percentual adicional inserido na alíquota interna da UF de destino, relativo ao Fundo de Combate à Pobreza (FCP) naquela UF.<br>Nota: Percentual máximo de 2%, conforme legislação. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245a.07 | `pICMSUFDest` | Alíquota Interna da UF de destino | Numérico | 1-1 | 7 | 2-4 | Alíquota adotada nas operações internas na UF de destino para o produto ou mercadoria. Alíquota do Fundo de Combate a Pobreza, se existente para o produto/mercadoria, deve ser informada no campo próprio (pFCPUFDest) não devendo ser somada à essa alíquota interna. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245a.09 | `pICMSInter` | Alíquota interestadual das UF envolvidas | Caractere | 1-1 | 5 | — | Alíquota interestadual das UF Envolvidas:<br>- 4% alíquota interestadual para produtos importados;<br>-7% para os Estados de origem do Sul ou Sudeste (exceto ES), destinado para os Estados do Norte, Nordeste, Centro-Oeste e Espírito Santo;<br>- 12% para os demais casos. | Neste campo poderão ser informados apenas os valores abaixo, sem espaços em branco:<br>-Para alíquota de 4%, informar o valor "4.00"<br>-Para alíquota de 7%, informar o valor  "7.00"<br>-Para alíquota de 12%, informar o valor "12.00" |
| 245a.11 | `pICMSInterPart` | Percentual provisório de partilha do ICMS Interestadual | Numérico | 1-1 | 7 | 2-4 | Percentual de ICMS Interestadual para a UF de destino:<br>- 40% em 2016;<br>- 60% em 2017;<br>- 80% em 2018;<br>- 100% a partir de 2019. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 245a.13 | `vFCPUFDest` | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) da UF de destino. | Numérico | 0-1 | 15 | 2 | Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) da UF de destino. | 15 posições, sendo 13 inteiros e 2 decimais |
| 245a.15 | `vICMSUFDest` | Valor do ICMS Interestadual para a UF de destino | Numérico | 1-1 | 15 | 2 | Valor do ICMS Interestadual para a UF de destino (sem o valor do<br>ICMS relativo ao FCP). | 15 posições, sendo 13 inteiros e 2 decimais |
| 245a.17 | `vICMSUFRemet` | Valor do ICMS interestadual para a UF do remetente | Numérico | 1-1 | 15 | 2 | Valor do ICMS Interestadual para a UF do Remetente<br>Nota: A partir de 2019, este valor será zero. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="ipi"></a>

###### `IPI` — Grupo IPI

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IPI`  
**ID:** 246 · **Ocorrência:** 0-1 · **Linha na planilha:** 786  
**Rótulo na planilha:** IPI - Imposto sobre Produtos Industrializados  

> Informar apenas quando o item for sujeito ao IPI

Abertura: `--IPI_ini--;` · Fechamento: `--IPI_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 248 | `CNPJProd` | CNPJ do produtor da mercadoria, quando diferente do emitente. Somente para os casos de exportação direta ou indireta | Caractere | 0-1 | 14 | — | Informar os zeros não significativos | — |
| 249 | `cSelo` | Código do selo de controle IPI | Caractere | 0-1 | 1-60 | — | Preenchimento conforme Atos Normativos editados pela Receita Federal (Observação 3) | Preenchimento conforme Anexo II-A da Instrução Normativa RFB No 770/2007 |
| 250 | `qSelo` | Quantidade de selo de controle | Numérico | 0-1 | 1-12 | — | — | — |
| 251 | `cEnc` | Código de Enquadramento Legal do IPI | Numérico | 1-1 | 1-3 | — | Preenchimento conforme Anexo XIV da Nota Técnica 2015.002 | — |

➡️ Sub-bloco: [`ipi_trib`](#ipi_trib) — Grupo do CST 00, 49, 50 e 99 (1-1)

➡️ Sub-bloco: [`ipi_nt`](#ipi_nt) — Grupo CST 01, 02, 03, 04, 51, 52, 53, 54 e 55 (1-1)

<a id="ipi_trib"></a>

###### `ipi_trib` — Grupo do CST 00, 49, 50 e 99

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IPI` › `ipi_trib`  
**ID:** 252 · **Ocorrência:** 1-1 · **Linha na planilha:** 791  
**Rótulo na planilha:** IPI - Grupo do CST 00, 49, 50 e 99  

> Informar apenas um dos grupo O07 ou O08 com base valor atribuído ao campo O09 - CST do IPI

Abertura: `--ipi_trib_ini--;` · Fechamento: `--ipi_trib_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 253 | `CST` | Código da Situação Tributária do IPI | Caractere | 1-1 | 2 | — | 00-Entrada com recuperações de crédito;<br>49-Outras Entradas;<br>50-Saída tributada;<br>99-Outras saídas; | — |

➡️ Sub-bloco: [`x_ipi_aliq`](#x_ipi_aliq) — Sequência XML (1-1)

➡️ Sub-bloco: [`x_ipi_unid`](#x_ipi_unid) — Sequência XML (1-1)

*Continuação dos campos de `ipi_trib` (após o fechamento de `x_ipi_unid`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 259 | `vIPI` | Valor do IPI | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_ipi_aliq"></a>

###### `x_ipi_aliq` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IPI` › `ipi_trib` › `x_ipi_aliq`  
**ID:** 253.1 · **Ocorrência:** 1-1 · **Linha na planilha:** 793  
**Rótulo na planilha:** XML - IPI Alíquota  

> Grupo Opcional.

Abertura: `--x_ipi_aliq_ini--;` · Fechamento: `--x_ipi_aliq_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 254 | `vBC` | Valor da Base de Cálculo  do IPI | Numérico | 1-1 | 15 | 2 | Preencher quando o cálculo do IPI for por alíquota. | 15 posições, sendo 13 inteiros e 2 decimais |
| 257 | `pIPI` | Alíquota do IPI | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |

<a id="x_ipi_unid"></a>

###### `x_ipi_unid` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IPI` › `ipi_trib` › `x_ipi_unid`  
**ID:** 257.1 · **Ocorrência:** 1-1 · **Linha na planilha:** 797  
**Rótulo na planilha:** XML - IPI Unidade  

> Grupo Opcional.

Abertura: `--x_ipi_unid_ini--;` · Fechamento: `--x_ipi_unid_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 255 | `qUnid` | Quantidade total na unidade padrão para tributação( somente para os produtos tributados por unidade) | Numérico | 1-1 | 16 | 0-4 | Preencher quando o cálculo do IPI for valor por unidade. | 16 posições, sendo 12 inteiros e 0 a 4 decimais |
| 256 | `vUnid` | Valor por unidade Tributável | Numérico | 1-1 | 15 | 0-4 | — | 15 posições, sendo 11 inteiros e 0 a 4 decimais |

<a id="ipi_nt"></a>

###### `ipi_nt` — Grupo CST 01, 02, 03, 04, 51, 52, 53, 54 e 55

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IPI` › `ipi_nt`  
**ID:** 260 · **Ocorrência:** 1-1 · **Linha na planilha:** 803  
**Rótulo na planilha:** IPI - Grupo do CST 01, 02, 03, 04, 51, 52, 53, 54 e 55  

Abertura: `--ipi_nt_ini--;` · Fechamento: `--ipi_nt_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 261 | `CST` | Código da Situação Tributária do IPI | Caractere | 1-1 | 2 | — | 01 - Entrada tributada com alíquota zero;<br>02 - Entrada isenta;<br>03 - Entrada não-tributada;<br>04 - Entrada imune;<br>05 - Entrada com suspensão;<br>51 - Saída tributada com alíquota zero;<br>52 - Saída Isenta;<br>53 - Saída não-tributada;<br>54 - Saída Imune;<br>55 - Saída com suspensão. | — |

<a id="ii"></a>

###### `II` — Grupo de Imposto de Importação

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `II`  
**ID:** 262 · **Ocorrência:** 0-1 · **Linha na planilha:** 807  
**Rótulo na planilha:** II - Imposto de Importação  

> Informar apenas se o item for sujeito ao II

Abertura: `--II_ini--;` · Fechamento: `--II_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 263 | `vBC` | Valor da Base de Cálculo do Imposto de Importação | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 264 | `vDespAdu` | Valor das Despesas Aduaneiras | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 265 | `vII` | Valor do Imposto de Importação | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 266 | `vIOF` | Valor do Imposto sobre Operações Financeiras | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="pis"></a>

###### `PIS` — Grupo PIS

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `PIS`  
**ID:** 267 · **Ocorrência:** 0-1 · **Linha na planilha:** 813  
**Rótulo na planilha:** PIS  

> Informar apenas um dos grupos Q02, Q03, Q04 ou Q05 com base valor atribuído ao campo Q06 - CST do PIS

Abertura: `--PIS_ini--;` · Fechamento: `--PIS_fim--;`

➡️ Sub-bloco: [`pis_aliq`](#pis_aliq) — Grupo PIS tributado pela alíquota (1-1)

➡️ Sub-bloco: [`pis_qtde`](#pis_qtde) — Grupo PIS tributado por Quantidade (1-1)

➡️ Sub-bloco: [`pis_nt`](#pis_nt) — Grupo PIS não tributado (1-1)

➡️ Sub-bloco: [`pis_outr`](#pis_outr) — Grupo PIS Outras Operações (1-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="pis_aliq"></a>

###### `pis_aliq` — Grupo PIS tributado pela alíquota

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `PIS` › `pis_aliq`  
**ID:** 268 · **Ocorrência:** 1-1 · **Linha na planilha:** 814  
**Rótulo na planilha:** PIS tributado pelo CST - 01 e 02  

Abertura: `--pis_aliq_ini--;` · Fechamento: `--pis_aliq_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 269 | `CST` | Código de Situação Tributária do PIS | Numérico | 1-1 | 2 | — | 01 - Operação Tributável, base de cálculo = valor da operação alíquota normal,(cumulativo/não cumulativo); <br>02 - Operação Tributável (base de cálculo = valor da operação, alíquota diferenciada. | — |
| 270 | `vBC` | Valor da Base de Cálculo do PIS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 271 | `pPIS` | Alíquota do PIS(em percentual) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 272 | `vPIS` | Valor do PIS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="pis_qtde"></a>

###### `pis_qtde` — Grupo PIS tributado por Quantidade

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `PIS` › `pis_qtde`  
**ID:** 273 · **Ocorrência:** 1-1 · **Linha na planilha:** 820  
**Rótulo na planilha:** PIS tributado por Qtde - CST 03  

Abertura: `--pis_qtde_ini--;` · Fechamento: `--pis_qtde_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 274 | `CST` | Código de Situação Tributária do PIS | Numérico | 1-1 | 2 | — | 03 - Operação Tributável, base de cálculo = quantidade vendida x alíquota por unidade de produto | — |
| 275 | `qBCProd` | Quantidade Vendida | Numérico | 1-1 | 16 | 0-4 | — | 16 posições, sendo 12 inteiros e 0 a 4 decimais |
| 276 | `vAliqProd` | Alíquota do PIS (em reais) | Numérico | 1-1 | 15 | 0-4 | — | 15 posições, sendo 11 inteiros e 0 a 4 decimais |
| 277 | `vPIS` | Valor do PIS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="pis_nt"></a>

###### `pis_nt` — Grupo PIS não tributado

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `PIS` › `pis_nt`  
**ID:** 278 · **Ocorrência:** 1-1 · **Linha na planilha:** 826  
**Rótulo na planilha:** PIS não Tributado CST = 04, 06, 07, 08 ou 09  

Abertura: `--pis_nt_ini--;` · Fechamento: `--pis_nt_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 279 | `CST` | Código de Situação Tributária do PIS | Numérico | 1-1 | 2 | — | 04 - Operação Tributável, tributação monofásica (alíquota zero);<br>05 - Operação Tributável (Substituição Tributária);<br>06 - Operação Tributável, alíquota zero;<br>07 - Operação Isenta da Contribuição;<br>08 - Operação sem incidência da contribuição;<br>09 - Operação com Suspensão da Contribuição. | — |

<a id="pis_outr"></a>

###### `pis_outr` — Grupo PIS Outras Operações

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `PIS` › `pis_outr`  
**ID:** 280 · **Ocorrência:** 1-1 · **Linha na planilha:** 829  
**Rótulo na planilha:** PIS Outras operações CST 99  

Abertura: `--pis_outr_ini--;` · Fechamento: `--pis_outr_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 281 | `CST` | Código de Situação Tributária do PIS | Numérico | 1-1 | 2 | — | 49 - Outras Operações de Saída;<br>50 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno;<br>51 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno;<br>52 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação;<br>53 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno;<br>54 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação;<br>55 - Operação com Direito a Crédito - Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação;<br>56 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação;<br>60 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno;<br>61 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno;<br>62 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação;<br>63 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno;<br>64 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação;<br>65 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação;<br>66 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não- Tributadas no Mercado Interno, e de Exportação<br>67 - Crédito Presumido - Outras Operações<br>70 - Operação de Aquisição sem Direito a Crédito<br>71 - Operação de Aquisição com Isenção<br>72 - Operação de Aquisição com Suspensão<br>73 - Operação de Aquisição a Alíquota Zero<br>74 - Operação de Aquisição sem Incidência da Contribuição<br>75 - Operação de Aquisição por Substituição Tributária<br>98 - Outras Operações de Entrada<br>99-Outras Operações | — |

➡️ Sub-bloco: [`x_pis_percent`](#x_pis_percent) — Sequência XML (1-1)

➡️ Sub-bloco: [`x_pis_valor`](#x_pis_valor) — Sequência XML (1-1)

*Continuação dos campos de `pis_outr` (após o fechamento de `x_pis_valor`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 286 | `vPIS` | Valor do PIS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_pis_percent"></a>

###### `x_pis_percent` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `PIS` › `pis_outr` › `x_pis_percent`  
**ID:** 281.1 · **Ocorrência:** 1-1 · **Linha na planilha:** 831  
**Rótulo na planilha:** XML - PIS Percentual  

> Grupo Opcional.

Abertura: `--x_pis_percent_ini--;` · Fechamento: `--x_pis_percent_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 282 | `vBC` | Valor da Base de Cálculo do PIS | Numérico | 1-1 | 15 | 2 | Informar quando o cálculo do PIS em percentual. | 15 posições, sendo 13 inteiros e 2 decimais |
| 283 | `pPIS` | Alíquota do PIS (em percentual) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |

<a id="x_pis_valor"></a>

###### `x_pis_valor` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `PIS` › `pis_outr` › `x_pis_valor`  
**ID:** 283.1 · **Ocorrência:** 1-1 · **Linha na planilha:** 835  
**Rótulo na planilha:** XML - PIS Valor  

> Grupo Opcional.

Abertura: `--x_pis_valor_ini--;` · Fechamento: `--x_pis_valor_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 284 | `qBCProd` | Quantidade Vendida | Numérico | 1-1 | 16 | 0-4 | Preencher quando o cálculo do PIS for em valor. | 16 posições, sendo 12 inteiros e 0 a 4 decimais |
| 285 | `vAliqProd` | Alíquota do PIS (em reais) | Numérico | 1-1 | 15 | 0-4 | — | 15 posições, sendo 11 inteiros e 0 a 4 decimais |

<a id="pisst"></a>

###### `PISST` — Grupo PIS Substituição Tributária

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `PISST`  
**ID:** 287 · **Ocorrência:** 0-1 · **Linha na planilha:** 842  
**Rótulo na planilha:** PIS ST  

Abertura: `--PISST_ini--;` · Fechamento: `--PISST_fim--;`

➡️ Sub-bloco: [`x_pisst_percent`](#x_pisst_percent) — Sequência XML (1-1)

➡️ Sub-bloco: [`x_pisst_valor`](#x_pisst_valor) — Sequência XML (1-1)

*Continuação dos campos de `PISST` (após o fechamento de `x_pisst_valor`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 292 | `vPIS` | Valor do PIS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 292.01 | `indSomaPISST` | Indica se o valor do PISST compõe o valor total da NF-e | Numérico | 0-1 | 1 | — | 0 - Valor do PISST não compõe o valor total da NF-e<br>1 - Valor do PISST compõe o valor total da NF-e | — |

<a id="x_pisst_percent"></a>

###### `x_pisst_percent` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `PISST` › `x_pisst_percent`  
**ID:** 287.1 · **Ocorrência:** 1-1 · **Linha na planilha:** 843  
**Rótulo na planilha:** XML - PISST Percentual  

> Grupo Opcional.

Abertura: `--x_pisst_percent_ini--;` · Fechamento: `--x_pisst_percent_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 288 | `vBC` | Valor da Base de Cálculo do PIS | Numérico | 1-1 | 15 | 2 | Preencher quando o cálculo do PIS em percentual. | 15 posições, sendo 13 inteiros e 2 decimais |
| 289 | `pPIS` | Alíquota do PIS(em percentual) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |

<a id="x_pisst_valor"></a>

###### `x_pisst_valor` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `PISST` › `x_pisst_valor`  
**ID:** 289.1 · **Ocorrência:** 1-1 · **Linha na planilha:** 847  
**Rótulo na planilha:** XML - PISST Valor  

> Grupo Opcional.

Abertura: `--x_pisst_valor_ini--;` · Fechamento: `--x_pisst_valor_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 290 | `qBCProd` | Quantidade Vendida | Numérico | 1-1 | 16 | 0-4 | Preencher quando o cálculo do PIS for em valor. | 16 posições, sendo 12 inteiros e 0 a 4 decimais |
| 291 | `vAliqProd` | Alíquota do PIS(em reais) | Numérico | 1-1 | 15 | 0-4 | — | 15 posições, sendo 11 inteiros e 0 a 4 decimais |

<a id="cofins"></a>

###### `COFINS` — Grupo COFINS

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `COFINS`  
**ID:** 293 · **Ocorrência:** 0-1 · **Linha na planilha:** 854  
**Rótulo na planilha:** COFINS  

> Informar apenas um dos grupos S02, S03, S04 ou S05 com base valor atribuído ao campo de CST da COFINS

Abertura: `--COFINS_ini--;` · Fechamento: `--COFINS_fim--;`

➡️ Sub-bloco: [`cofins_aliq`](#cofins_aliq) — Grupo COFINS tributado pela alíquota (1-1)

➡️ Sub-bloco: [`cofins_qtde`](#cofins_qtde) — Grupo de COFINS tributado por Quantidade (1-1)

➡️ Sub-bloco: [`cofins_nt`](#cofins_nt) — Grupo COFINS não tributado (1-1)

➡️ Sub-bloco: [`cofins_outr`](#cofins_outr) — Grupo COFINS Outras Operações (1-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="cofins_aliq"></a>

###### `cofins_aliq` — Grupo COFINS tributado pela alíquota

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `COFINS` › `cofins_aliq`  
**ID:** 294 · **Ocorrência:** 1-1 · **Linha na planilha:** 855  
**Rótulo na planilha:** COFINS Tributado pela Alíquota CST - 01 ou 02  

Abertura: `--cofins_aliq_ini--;` · Fechamento: `--cofins_aliq_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 295 | `CST` | Código de Situação Tributária da COFINS | Numérico | 1-1 | 2 | — | 01 - Operação Tributável (base de cálculo = valor da operação alíquota normal (cumulativo/não cumulativo));<br>02 - Operação Tributável (base de cálculo = valor da operação (alíquota diferenciada)). | — |
| 296 | `vBC` | Valor da Base de Cálculo da COFINS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 297 | `pCOFINS` | Alíquota da COFINS (em percentual) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 298 | `vCOFINS` | Valor da COFINS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="cofins_qtde"></a>

###### `cofins_qtde` — Grupo de COFINS tributado por Quantidade

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `COFINS` › `cofins_qtde`  
**ID:** 299 · **Ocorrência:** 1-1 · **Linha na planilha:** 861  
**Rótulo na planilha:** COFINS tributado por Quantidade CST - 03  

Abertura: `--cofins_qtde_ini--;` · Fechamento: `--cofins_qtde_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 300 | `CST` | Código de Situação Tributária da COFINS | Numérico | 1-1 | 2 | — | 03 - Operação Tributável (base de cálculo = quantidade vendida x alíquota por unidade de produto). | — |
| 301 | `qBCProd` | Quantidade Vendida | Numérico | 1-1 | 16 | 0-4 | — | 16 posições, sendo 12 inteiros e 0 a 4 decimais |
| 302 | `vAliqProd` | Alíquota da COFINS (em reais) | Numérico | 1-1 | 15 | 0-4 | — | 15 posições, sendo 11 inteiros e 0 a 4 decimais |
| 303 | `vCOFINS` | Valor da COFINS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="cofins_nt"></a>

###### `cofins_nt` — Grupo COFINS não tributado

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `COFINS` › `cofins_nt`  
**ID:** 304 · **Ocorrência:** 1-1 · **Linha na planilha:** 867  
**Rótulo na planilha:** COFINS não tributado CST 04, 06, 07, 08 ou 09  

Abertura: `--cofins_nt_ini--;` · Fechamento: `--cofins_nt_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 305 | `CST` | Código de Situação Tributária da COFINS | Numérico | 1-1 | 2 | — | 04 - Operação Tributável, tributação monofásica(alíquota zero);<br>05 - Operação Tributável (Substituição Tributária);<br>06 - Operação tributável (alíquota zero);<br>07 - Operação Isenta da Contribuição;<br>08 - Operação sem Incidência da Contribuição;<br>09 - Operação com Suspensão da Contribuição. | — |

<a id="cofins_outr"></a>

###### `cofins_outr` — Grupo COFINS Outras Operações

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `COFINS` › `cofins_outr`  
**ID:** 306 · **Ocorrência:** 1-1 · **Linha na planilha:** 870  
**Rótulo na planilha:** COFINS outras operações CST 99  

Abertura: `--cofins_outr_ini--;` · Fechamento: `--cofins_outr_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 307 | `CST` | Código de Situação Tributária da COFINS | Numérico | 1-1 | 2 | — | 49 - Outras Operações de Saída;<br>50 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno;<br>51 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno;<br>52 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação;<br>53 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno;<br>54 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação;<br>55 - Operação com Direito a Crédito - Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação;<br>56 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação;<br>60 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno;<br>61 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno;<br>62 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação;<br>63 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno;<br>64 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação;<br>65 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação;<br>66 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não- Tributadas no Mercado Interno, e de Exportação;<br>67 - Crédito Presumido - Outras Operações;<br>70 - Operação de Aquisição sem Direito a Crédito;<br>71 - Operação de Aquisição com Isenção;<br>72 - Operação de Aquisição com Suspensão;<br>73 - Operação de Aquisição a Alíquota Zero;<br>74 - Operação de Aquisição sem Incidência da Contribuição;<br>75 - Operação de Aquisição por Substituição Tributária;<br>98 - Outras Operações de Entrada;<br>99- Outras Operações. | — |

➡️ Sub-bloco: [`x_cofinsoutr_percent`](#x_cofinsoutr_percent) — Sequência XML (1-1)

➡️ Sub-bloco: [`x_cofinsoutr_valor`](#x_cofinsoutr_valor) — Sequência XML (1-1)

*Continuação dos campos de `cofins_outr` (após o fechamento de `x_cofinsoutr_valor`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 312 | `vCOFINS` | Valor da COFINS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="x_cofinsoutr_percent"></a>

###### `x_cofinsoutr_percent` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `COFINS` › `cofins_outr` › `x_cofinsoutr_percent`  
**ID:** 307.1 · **Ocorrência:** 1-1 · **Linha na planilha:** 872  
**Rótulo na planilha:** XML - COFINSOUTR Percentual  

> Grupo Opcional.

Abertura: `--x_cofinsoutr_percent_ini--;` · Fechamento: `--x_cofinsoutr_percent_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 308 | `vBC` | Valor da Base de Cálculo da COFINS | Numérico | 1-1 | 15 | 2 | Preencher para cálculo da COFINS em percentual. | 15 posições, sendo 13 inteiros e 2 decimais |
| 309 | `pCOFINS` | Alíquota da COFINS (em percentual) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |

<a id="x_cofinsoutr_valor"></a>

###### `x_cofinsoutr_valor` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `COFINS` › `cofins_outr` › `x_cofinsoutr_valor`  
**ID:** 309.1 · **Ocorrência:** 1-1 · **Linha na planilha:** 876  
**Rótulo na planilha:** XML - COFINSOUTR Valor  

> Grupo Opcional.

Abertura: `--x_cofinsoutr_valor_ini--;` · Fechamento: `--x_cofinsoutr_valor_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 310 | `qBCProd` | Quantidade Vendida | Numérico | 1-1 | 16 | 0-4 | Preencher para cálculo da COFINS em valor. | 16 posições, sendo 12 inteiros e 0 a 4 decimais |
| 311 | `vAliqProd` | Alíquota da COFINS (em reais) | Numérico | 1-1 | 15 | 0-4 | — | 15 posições, sendo 11 inteiros e 0 a 4 decimais |

<a id="cofinsst"></a>

###### `COFINSST` — Grupo COFINS Substituição Tributária

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `COFINSST`  
**ID:** 313 · **Ocorrência:** 0-1 · **Linha na planilha:** 883  
**Rótulo na planilha:** COFINS Substituição Tributária  

Abertura: `--COFINSST_ini--;` · Fechamento: `--COFINSST_fim--;`

➡️ Sub-bloco: [`x_cofinsst_percent`](#x_cofinsst_percent) — Sequência XML (1-1)

➡️ Sub-bloco: [`x_cofinsst_valor`](#x_cofinsst_valor) — Sequência XML (1-1)

*Continuação dos campos de `COFINSST` (após o fechamento de `x_cofinsst_valor`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 318 | `vCOFINS` | Valor da COFINS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 318.01 | `indSomaCOFINSST` | Indica se o valor da COFINS ST compõe o valor total da Nfe | Numérico | 0-1 | 1 | — | 0 - Valor da COFINSST não compõe o valor total da NF-e<br>1 - Valor da COFINSST compõe o valor total da NF-e | — |

<a id="x_cofinsst_percent"></a>

###### `x_cofinsst_percent` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `COFINSST` › `x_cofinsst_percent`  
**ID:** 313.1 · **Ocorrência:** 1-1 · **Linha na planilha:** 884  
**Rótulo na planilha:** XML - COFINSST Percentual  

> Grupo Opcional.

Abertura: `--x_cofinsst_percent_ini--;` · Fechamento: `--x_cofinsst_percent_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 314 | `vBC` | Valor da Base de Cálculo da COFINS | Numérico | 1-1 | 15 | 2 | Preencher para cálculo da COFINS Substituição Tributária em percentual. | 15 posições, sendo 13 inteiros e 2 decimais |
| 315 | `pCOFINS` | Alíquota da COFINS (em percentual) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |

<a id="x_cofinsst_valor"></a>

###### `x_cofinsst_valor` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `COFINSST` › `x_cofinsst_valor`  
**ID:** 315.1 · **Ocorrência:** 1-1 · **Linha na planilha:** 888  
**Rótulo na planilha:** XML - COFINSST Valor  

> Grupo Opcional.

Abertura: `--x_cofinsst_valor_ini--;` · Fechamento: `--x_cofinsst_valor_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 316 | `qBCProd` | Quantidade Vendida | Numérico | 1-1 | 16 | 0-4 | Preencher para cálculo da COFINS Substituição Tributária em valor. | 16 posições, sendo 12 inteiros e 0 a 4 decimais |
| 317 | `vAliqProd` | Alíquota da COFINS (Em reais) | Numérico | 1-1 | 15 | 0-4 | — | 15 posições, sendo 11 inteiros e 0 a 4 decimais |

<a id="issqn"></a>

###### `ISSQN` — Grupo ISSQN

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `ISSQN`  
**ID:** 319 · **Ocorrência:** 0-1 · **Linha na planilha:** 895  
**Rótulo na planilha:** ISSQN  

> Campos para cálculo do ISSQN na NF-e conjugada, onde há a prestação de serviços sujeitos ao ISSQN e fornecimento de peças sujeitas ao ICMS. <br>Grupo ISSQN é mutuamente exclusivo com os grupos ICMS, IPI e II, isto é se ISSQN for informado os grupos ICMS, IPI e II não serão informados e vice-versa.

Abertura: `--ISSQN_ini--;` · Fechamento: `--ISSQN_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 320 | `vBC` | Valor da Base de Cálculo do ISSQN | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 321 | `vAliq` | Alíquota do ISSQN | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 322 | `vISSQN` | Valor do ISSQN | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 323 | `cMunFG` | Código do município de ocorrência do fato gerador do ISSQN | Numérico | 1-1 | 7 | — | Informar o município de ocorrência do fato gerador do ISSQN. Utilizar a Tabela do IBGE (Anexo VII - Tabela de UF, Município e País).<br>Nota 1: Não vincular com o município do fato gerador de ICMS (id:B12), ou com o município do emitente (id:C10) ou do destinatário (id:E10).<br>Nota 2: Informar 9999999 se prestação de serviço no Exterior. | — |
| 324 | `cListServ` | Item da Lista de Serviços | Caractere | 1-1 | 5 | — | Informar o Item da lista de serviços em que se classifica o serviço no padrão ABRASF <br>(Formato: NN.NN) | — |
| 324a | `vDeducao` | Valor dedução para redução da Base de Cálculo | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324b | `vOutro` | Valor outras retenções | Numérico | 0-1 | 15 | 2 | Valor declaratório | 15 posições, sendo 13 inteiros e 2 decimais |
| 324c | `vDescIncond` | Valor desconto incondicionado | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324d | `vDescCond` | Valor desconto condicionado | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324f | `vISSRet` | Valor retenção ISS | Numérico | 0-1 | 15 | 2 | Valor declaratório | 15 posições, sendo 13 inteiros e 2 decimais |
| 324g | `indISS` | Indicador da exigibilidade do ISS | Numérico | 1-1 | 2 | — | 1  - Exigível;<br>2 - Não incidência;<br>3 - Isenção;<br>4 - Exportação;<br>5 - Imunidade;<br>6 - Exigibilidade Suspensa por Decisão Judicial;<br>7 - Exigibilidade Suspensa por Processo Administrativo. | — |
| 324h | `cServico` | Código do serviço prestado dentro do município | Caractere | 0-1 | 1-20 | — | — | — |
| 324i | `cMun` | Código do Município de incidência do imposto | Numérico | 0-1 | 7 | — | Tabela do IBGE. Informar "9999999" para serviço fora do País. | — |
| 324j | `cPais` | Código do País onde o serviço foi prestado | Numérico | 0-1 | 4 | — | Tabela do BACEN. Informar somente se o município da prestação do serviço for "9999999" | — |
| 324k | `nProcesso` | Número do processo judicial ou administrativo de suspensão da exigibilidade | Caractere | 0-1 | 1-30 | — | Informar somente quando declarada a suspensão da exigibilidade do ISSQN. | — |
| 324l | `indIncentivo` | Indicador de incentivo Fiscal | Numérico | 1-1 | 1 | — | 1  - Sim;<br>2 - Não. | — |

<a id="is"></a>

###### `IS` — Informações do Imposto Seletivo

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IS`  
**ID:** 324.01 · **Ocorrência:** 0-1 · **Linha na planilha:** 913  

> Grupo Opcional

Abertura: `--IS_ini--;` · Fechamento: `--IS_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.02 | `CSTIS` | Código de Situação Tributária do Imposto Seletivo | Numérico | 1-1 | 3 | — | Utilizar tabela CST do Imposto Seletivo | — |
| 324.03 | `cClassTribIS` | Código de Classificação Tributária do Imposto <br>Seletivo | Caractere | 1-1 | 6 | — | Utilizar tabela cClassTribIS | — |

➡️ Sub-bloco: [`seqSeletivo`](#seqseletivo) — Sequência XML (0-1)

<a id="seqseletivo"></a>

###### `seqSeletivo` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IS` › `seqSeletivo`  
**ID:** 324.04 · **Ocorrência:** 0-1 · **Linha na planilha:** 916  

> Grupo Opcional.

Abertura: `--seqSeletivo_ini--;` · Fechamento: `--seqSeletivo_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.05 | `vBCIS` | Valor da Base de Cálculo do Imposto Seletivo | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.06 | `pIS` | Alíquota do Imposto Seletivo (em percentual) | Caractere | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.07 | `adRemIS`<br>*(antigo `pISEspec`)* | Alíquota específica por unidade de medida <br>apropriada | Numérico | 0-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.11 | `vIS` | Valor do Imposto Seletivo | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`sequencia_XML`](#sequencia_xml-15) — Sequência XML (0-1)

<a id="sequencia_xml-15"></a>

###### `sequencia_XML` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IS` › `seqSeletivo` › `sequencia_XML`  
**ID:** 324.08 · **Ocorrência:** 0-1 · **Linha na planilha:** 921  

> Grupo Opcional.

Abertura: `--sequencia_XML_ini--;` · Fechamento: `--sequencia_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.09 | `uTrib` | Unidade de Medida Tributável | Caractere | 1-1 | 1-6 | — | — | — |
| 324.10 | `qTrib` | Quantidade Tributável | Numérico | 1-1 | 15 | 0 ou 4 | — | 15 posições, sendo 11 inteiros e 0 ou 4 decimais |

<a id="ibscbs"></a>

###### `IBSCBS` — Informações do Imposto de Bens e Serviços -<br>IBS e da Contribuição de Bens e Serviços - CBS

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS`  
**ID:** 324.12 · **Ocorrência:** 0-1 · **Linha na planilha:** 927  
**Rótulo na planilha:** Informações do Imposto de Bens e Serviços - IBS e da Contribuição de Bens e Serviços - CBS  

Abertura: `--IBSCBS_ini--;` · Fechamento: `--IBSCBS_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.13 | `CST` | Código de Situação Tributária do IBS e CBS | Numérico | 0-1 | 3 | — | Utilizar tabela CST do IBS/CBS | — |
| 324.14 | `cClassTrib` | Código de Classificação Tributária do IBS e CBS | Caractere | 0-1 | 6 | — | Utilizar tabela cClassTrib | — |
| 324.14a | `indDoacao` | Indica a natureza da operação de doação, <br>orientando a apuração e a geração de débitos ou estornos conforme o cenário | Caractere | 0-1 | 1 | — | Informar quando doação | — |

➡️ Sub-bloco: [`sequencia_XML_IBSCBS`](#sequencia_xml_ibscbs) — Grupo de Informações do IBS, CBS e Imposto Seletivo (—)

➡️ Sub-bloco: [`gEstornoCred`](#gestornocred) — gEstornoCred (0-1)

➡️ Sub-bloco: [`sequencia_XML_cred_pres`](#sequencia_xml_cred_pres) — Grupo de Crédito Presumido da Operação (0-1)

<a id="sequencia_xml_ibscbs"></a>

###### `sequencia_XML_IBSCBS` — Grupo de Informações do IBS, CBS e Imposto Seletivo

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS`  
**ID:** 324.14k · **Tipo:** Grupo · **Linha na planilha:** 931  

> Grupo Opcional

Abertura: `--sequencia_XML_IBSCBS_ini--;` · Fechamento: `--sequencia_XML_IBSCBS_fim--;`

➡️ Sub-bloco: [`gIBSCBS`](#gibscbs) — Grupo de Informações do IBS, CBS e Imposto Seletivo (1-1)

➡️ Sub-bloco: [`gIBSCBSMono`](#gibscbsmono) — Grupo de Informações do IBS e CBS em operações com imposto monofásico (1-1)

➡️ Sub-bloco: [`gTransfCred`](#gtransfcred) — Transferências de Crédito (1-1)

➡️ Sub-bloco: [`gAjusteCompet`](#gajustecompet) — Ajuste de Competência (1-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="gibscbs"></a>

###### `gIBSCBS` — Grupo de Informações do IBS, CBS e Imposto Seletivo

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS`  
**ID:** 324.15 · **Tipo:** CG · **Ocorrência:** 1-1 · **Linha na planilha:** 932  

> Se trata de um CG (indica que o campo é um Elemento que deriva de uma Escolha (Choice), ou é necessário enviar gTransfCred ou  gAjusteCompet ou gIBSCBSMono ou gIBSCBS).

Abertura: `--gIBSCBS_ini--;` · Fechamento: `--gIBSCBS_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.16 | `vBC` | Base de cálculo do IBS e CBS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.54a | `vIBS` | Valor do IBS | Numérico | 1-1 | 15 | 2 | Valor do IBS (soma de vIBSUF e vIBSMun).<br>Quando houver crédito presumido com indicador “IndDeduzCredPres=1”, o vCredPres deve ser abatido desse valor. | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`gIBSUF`](#gibsuf) — Grupo de Informações do IBS para a UF (1-1)

➡️ Sub-bloco: [`gIBSMun`](#gibsmun) — Grupo de Informações do IBS para o município (1-1)

➡️ Sub-bloco: [`gCBS`](#gcbs) — Grupo de Informações da CBS (1-1)

➡️ Sub-bloco: [`gTribRegular`](#gtribregular) — Grupo de informações da Tributação Regular (0-1)

➡️ Sub-bloco: [`gTribCompraGov`](#gtribcompragov) — Grupo de informações da composição do valor do IBS e da CBS em compras governamental (0-1)

<a id="gibsuf"></a>

###### `gIBSUF` — Grupo de Informações do IBS para a UF

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gIBSUF`  
**ID:** 324.17 · **Ocorrência:** 1-1 · **Linha na planilha:** 935  

Abertura: `--gIBSUF_ini--;` · Fechamento: `--gIBSUF_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.18 | `pIBSUF` | Alíquota do IBS de competência das UF  (em percentual) | Numérico | 1-1 | 7 | 2-4 | Alíquota vigente do IBS da UF.<br>Preencher de acordo com a tabela de alíquotas do IBS e CBS. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.35 | `vIBSUF` | Valor do IBS de competência da UF | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`gDif`](#gdif) — Grupo de Informações do Diferimento (0-1)

➡️ Sub-bloco: [`gDevTrib`](#gdevtrib) — Grupo de Informações da devolução de tributos (0-1)

➡️ Sub-bloco: [`gRed`](#gred) — Grupo de informações da redução da alíquota (0-1)

<a id="gdif"></a>

###### `gDif` — Grupo de Informações do Diferimento

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gIBSUF` › `gDif`  
**ID:** 324.21 · **Ocorrência:** 0-1 · **Linha na planilha:** 938  
**Rótulo na planilha:** Informações do Diferimento  

> Grupo Opcional.<br>Observação: a obrigatoriedade ou vedação do <br>preenchimento deste grupo está condicionada <br>ao indicador “ind_gDif” da tabela de CST do <br>IBS e da CBS.

Abertura: `--gDif_ini--;` · Fechamento: `--gDif_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324..22 | `pDif` | Percentual do diferimento | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.23 | `vDif` | Valor do Diferimento | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gdevtrib"></a>

###### `gDevTrib` — Grupo de Informações da devolução de tributos

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gIBSUF` › `gDevTrib`  
**ID:** 324..24 · **Ocorrência:** 0-1 · **Linha na planilha:** 942  
**Rótulo na planilha:** Informações da devolução de tributos  

> Grupo Opcional.

Abertura: `--gDevTrib_ini--;` · Fechamento: `--gDevTrib_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.24a | `pDevTrib` | Percentual de devolução do IBS da UF | Numérico | 0-1 | 7 | 2-4 | Percentual de devolução do IBS da UF, conforme LC 214/25 art. 118. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.25 | `vDevTrib` | Valor do tributo devolvido | Numérico | 1-1 | 15 | 2 | Valor do tributo devolvido (“cashback” de desconto na própria Nota Fiscal / Fatura) | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gred"></a>

###### `gRed` — Grupo de informações da redução da alíquota

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gIBSUF` › `gRed`  
**ID:** 324.26 · **Ocorrência:** 0-1 · **Linha na planilha:** 946  

> Grupo Opcional.<br>Observação: a obrigatoriedade ou vedação do <br>preenchimento deste grupo está condicionada <br>ao indicador “ind_gRed” da tabela de CST do <br>IBS e da CBS.

Abertura: `--gRed_ini--;` · Fechamento: `--gRed_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.27 | `pRedAliq` | Percentual da redução de alíquota do cClassTrib | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.28 | `pAliqEfet` | Aliquota Efetiva do IBS de competência das UF que será aplicada a Base de Cálculo (em percentual) | Numérico | 1-1 | 7 | 2-4 | Alíquota efetiva, após aplicação da redução de alíquota, incluindo o gCompraGov/pRedutor, se houver. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |

<a id="gibsmun"></a>

###### `gIBSMun` — Grupo de Informações do IBS para o município

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gIBSMun`  
**ID:** 324.36 · **Ocorrência:** 1-1 · **Linha na planilha:** 951  

Abertura: `--gIBSMun_ini--;` · Fechamento: `--gIBSMun_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.37 | `pIBSMun` | Alíquota do IBS de competência dos Municípios (em percentual) | Numérico | 1-1 | 7 | 2-4 | Alíquota vigente do IBS do Município.<br>Preencher de acordo com a tabela de alíquotas do IBS e CBS. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.54 | `vIBSMun` | Valor do IBS de competência do Município | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`gDif`](#gdif-1) — Grupo de Informações do Diferimento (0-1)

➡️ Sub-bloco: [`gDevTrib`](#gdevtrib-1) — Grupo de Informações da devolução de tributos (0-1)

➡️ Sub-bloco: [`gRed`](#gred-1) — Grupo de informações da redução da alíquota (0-1)

<a id="gdif-1"></a>

###### `gDif` — Grupo de Informações do Diferimento

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gIBSMun` › `gDif`  
**ID:** 324.40 · **Ocorrência:** 0-1 · **Linha na planilha:** 954  
**Rótulo na planilha:** Informações do Diferimento  

> Grupo Opcional.<br>Observação: a obrigatoriedade ou vedação do <br>preenchimento deste grupo está condicionada <br>ao indicador “ind_gDif” da tabela de CST do <br>IBS e da CBS.

Abertura: `--gDif_ini--;` · Fechamento: `--gDif_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.41 | `pDif` | Percentual do diferimento | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.42 | `vDif` | Valor do Diferimento | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gdevtrib-1"></a>

###### `gDevTrib` — Grupo de Informações da devolução de tributos

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gIBSMun` › `gDevTrib`  
**ID:** 324.43 · **Ocorrência:** 0-1 · **Linha na planilha:** 958  
**Rótulo na planilha:** Informações da devolução de tributos  

> Grupo Opcional.

Abertura: `--gDevTrib_ini--;` · Fechamento: `--gDevTrib_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.43a | `pDevTrib` | Percentual de devolução do IBS do Município | Numérico | 0-1 | 7 | 2-4 | Percentual de devolução do IBS do Município, conforme LC 214/25 art. 118. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.44 | `vDevTrib` | Valor do tributo devolvido | Numérico | 1-1 | 15 | 2 | Valor do tributo devolvido (“cashback” de desconto na própria Nota Fiscal / Fatura) | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gred-1"></a>

###### `gRed` — Grupo de informações da redução da alíquota

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gIBSMun` › `gRed`  
**ID:** 324.45 · **Ocorrência:** 0-1 · **Linha na planilha:** 962  
**Rótulo na planilha:** informações da redução da alíquota  

> Grupo Opcional.<br>Observação: a obrigatoriedade ou vedação do <br>preenchimento deste grupo está condicionada <br>ao indicador “ind_gRed” da tabela de CST do <br>IBS e da CBS.

Abertura: `--gRed_ini--;` · Fechamento: `--gRed_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.46 | `pRedAliq` | Percentual da redução de alíquota do cClassTrib | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.47 | `pAliqEfet` | Aliquota Efetiva do IBS de competência do<br>Município que será aplicada a Base de Cálculo  (em percentual) | Numérico | 1-1 | 7 | 2-4 | Alíquota efetiva, após aplicação da redução de alíquota, incluindo o gCompraGov/pRedutor, se houver | 7 posições, sendo 3 inteiros e 2 a 4 decimais |

<a id="gcbs"></a>

###### `gCBS` — Grupo de Informações da CBS

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gCBS`  
**ID:** 324.55 · **Ocorrência:** 1-1 · **Linha na planilha:** 967  

Abertura: `--gCBS_ini--;` · Fechamento: `--gCBS_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.56 | `pCBS` | Alíquota da CBS (em percentual) | Numérico | 1-1 | 7 | 2-4 | Alíquota vigente da CBS.<br>Preencher de acordo com a tabela de alíquotas do IBS e CBS. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.67 | `vCBS` | Valor da CBS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`gDif`](#gdif-2) — Grupo de Informações do Diferimento (0-1)

➡️ Sub-bloco: [`gDevTrib`](#gdevtrib-2) — Grupo de Informações da devolução de tributos (0-1)

➡️ Sub-bloco: [`gRed`](#gred-2) — Grupo de informações da redução da alíquota (0-1)

➡️ Sub-bloco: [`gALCZFMCBS`](#galczfmcbs) — Grupo de operações em áreas incentivadas (ALC/ZFM) - CBS (alíquota zero) (0-1)

<a id="gdif-2"></a>

###### `gDif` — Grupo de Informações do Diferimento

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gCBS` › `gDif`  
**ID:** 324.59 · **Ocorrência:** 0-1 · **Linha na planilha:** 970  
**Rótulo na planilha:** Informações do Diferimento  

> Grupo Opcional.<br>Observação: a obrigatoriedade ou vedação do <br>preenchimento deste grupo está condicionada <br>ao indicador “ind_gDif” da tabela de CST do <br>IBS e da CBS.

Abertura: `--gDif_ini--;` · Fechamento: `--gDif_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.60 | `pDif` | Percentual do diferimento | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.61 | `vDif` | Valor do Diferimento | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gdevtrib-2"></a>

###### `gDevTrib` — Grupo de Informações da devolução de tributos

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gCBS` › `gDevTrib`  
**ID:** 324.62 · **Ocorrência:** 0-1 · **Linha na planilha:** 974  
**Rótulo na planilha:** Informações da devolução de tributos  

> Grupo Opcional.

Abertura: `--gDevTrib_ini--;` · Fechamento: `--gDevTrib_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.62a | `pDevTrib` | Percentual de devolução da CBS | Numérico | 0-1 | 7 | 2-4 | Percentual de devolução da CBS, conforme LC 214/25 art. 118. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.63 | `vDevTrib` | Valor do tributo devolvido | Numérico | 1-1 | 15 | 2 | Valor do tributo devolvido (“cashback” de desconto na própria Nota Fiscal / Fatura) | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gred-2"></a>

###### `gRed` — Grupo de informações da redução da alíquota

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gCBS` › `gRed`  
**ID:** 324.64 · **Ocorrência:** 0-1 · **Linha na planilha:** 978  
**Rótulo na planilha:** informações da redução da alíquota  

> Grupo Opcional.<br>Observação: a obrigatoriedade ou vedação do <br>preenchimento deste grupo está condicionada <br>ao indicador “ind_gRed” da tabela de CST do <br>IBS e da CBS.

Abertura: `--gRed_ini--;` · Fechamento: `--gRed_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.65 | `pRedAliq` | Percentual da redução de alíquota do<br>cClassTrib | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.66 | `pAliqEfet` | Alíquota Efetiva da CBS que será aplicada a Base de Cálculo (em percentual) | Numérico | 1-1 | 7 | 2-4 | Alíquota efetiva, após aplicação da redução de alíquota,  incluindo o gCompraGov/pRedutor, se houver | 7 posições, sendo 3 inteiros e 2 a 4 decimais |

<a id="galczfmcbs"></a>

###### `gALCZFMCBS` — Grupo de operações em áreas incentivadas (ALC/ZFM) - CBS (alíquota zero)

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gCBS` › `gALCZFMCBS`  
**ID:** 324.66a · **Ocorrência:** 0-1 · **Linha na planilha:** 982  
**Rótulo na planilha:** Operações em áreas incentivadas (ALC/ZFM) - CBS  

> Grupo Opcional.<br>Grupo de informações para identificação de operações em áreas incentivadas (ALC/ZFM) com alíquota zero da CBS, conforme arts. 451 e 466 da LC 214/2025, quando <br>fornecedor e destinatário estiverem nessas áreas, distinguindo a existência de processo aprovado na Suframa.

Abertura: `--gALCZFMCBS_ini--;` · Fechamento: `--gALCZFMCBS_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.66b | `tpALCZFMCBS` | Tipo de aplicação da alíquota zero da CBS | Numérico | 1-1 | 1 | — | Deve ser informado: <br>1 - quando o fornecedor e o destinatário estiverem localizados em área incentivada, a operação estiver amparada por alíquota zero da CBS e não se tratar de operação industrial com processo aprovado na Suframa para o item; <br>2 - quando o fornecedor e o destinatário estiverem localizados em área incentivada, a operação estiver amparada por alíquota zero da CBS e se tratar de operação industrial com processo aprovado na <br>Suframa para o item. | — |
| 324.66c | `nProcSuframa` | Número do processo na Suframa para o item comercializado | Caractere | 0-1 | 8-12 | — | Inscrição específica e aprovação de projeto técnico econômico pelo Conselho de Administração da Suframa, nos termos  do Art. 442. II (ZFM) e Art. 459. II (ALC) da LC 214/2025. | — |
| 324.66d | `pAliqEfetRegCBS` | Percentual efetivo sem a redução | Numérico | 1-1 | 7 | 2-4 | Alíquota efetiva de referência da CBS aplicável à operação fora de áreas ou regimes incentivados. | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.66e | `vTribRegCBS` | Valor efetivo sem a redução | Numérico | 1-1 | 15 | 2 | Valor da CBS calculado para a operação fora de áreas ou regimes incentivado | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gtribregular"></a>

###### `gTribRegular` — Grupo de informações da Tributação Regular

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gTribRegular`  
**ID:** 324.68 · **Ocorrência:** 0-1 · **Linha na planilha:** 989  

> Grupo Opcional.

> Grupo de informações da Tributação Regular.<br>Informar como seria a tributação caso não <br>cumprida a condição resolutória/suspensiva.<br>Exemplo 1: Art. 445, §4 da LC 214/2025. <br>Operações com ZFM e ALC.<br>Exemplo 2: Operações com suspensão do tributo.<br>Observação: a obrigatoriedade ou vedação do <br>preenchimento deste grupo está condicionada <br>ao indicador “ind_gTribRegular” da tabela de <br>cClassTrib do IBS e da CBS.

Abertura: `--gTribRegular_ini--;` · Fechamento: `--gTribRegular_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.69 | `CSTReg` | Código de Situação Tributária do IBS e CBS | Numérico | 1-1 | 3 | — | Informado como seria caso não cumprida a condição resolutória/suspensiva. Utilizar tabela CÓDIGO DE CLASSIFICAÇÃO <br>TRIBUTÁRIA DO IBS E DA CBS | — |
| 324670 | `cClassTribReg` | Código de Classificação Tributária do IBS e CBS | Caractere | 1-1 | 6 | — | Informado como seria caso não cumprida a condição resolutória/suspensiva. Utilizar tabela CÓDIGO DE CLASSIFICAÇÃO <br>TRIBUTÁRIA DO IBS E DA CBS | — |
| 324.71 | `pAliqEfetRegIBSUF` | Valor da alíquota do IBS da UF (em percentual) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.72 | `vTribRegIBSUF` | Valor do Tributo do IBS da UF | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.72a | `pAliqEfetRegIBSMun` | Valor da alíquota do IBS do Município (em <br>percentual) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.72b | `vTribRegIBSMun` | Valor do Tributo do IBS do Município | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.72c | `pAliqEfetRegCBS` | Valor da alíquota da CBS (em percentual) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.72d | `vTribRegCBS` | Valor do Tributo da CBS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gtribcompragov"></a>

###### `gTribCompraGov` — Grupo de informações da composição do valor do IBS e da CBS em compras governamental

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBS` › `gTribCompraGov`  
**ID:** 324.82a · **Ocorrência:** 0-1 · **Linha na planilha:** 999  

> Grupo Opcional.<br>Informar somente para compras governamentais

Abertura: `--gTribCompraGov_ini--;` · Fechamento: `--gTribCompraGov_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.82b | `pAliqIBSUF` | Alíquota do IBS de competência do<br>Estado (em percentual) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.82c | `vTribIBSUF` | Valor que seria devido a UF | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.82d | `pAliqIBSMun` | Alíquota do IBS de competência do Município (em percentual) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.82e | `vTribIBSMun` | Valor que seria devido ao município | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.82f | `pAliqCBS` | Alíquota da CBS (em percentual) | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.82g | `vTribCBS` | Valor que seria devido a CBS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gibscbsmono"></a>

###### `gIBSCBSMono` — Grupo de Informações do IBS e CBS em operações com imposto monofásico

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono`  
**ID:** 324.84 · **Tipo:** CG · **Ocorrência:** 1-1 · **Linha na planilha:** 1008  

> Se trata de um CG (indica que o campo é um Elemento que deriva de uma Escolha (Choice), ou é necessário enviar gTransfCred ou gAjusteCompet ou gIBSCBSMono ou gIBSCBS).<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gIBSCBSMono" da tabela de CST do IBS e da CBS.

Abertura: `--gIBSCBSMono_ini--;` · Fechamento: `--gIBSCBSMono_fim--;`

➡️ Sub-bloco: [`sequencia_XML_IBSMono`](#sequencia_xml_ibsmono) — Sequência XML (0-1)

➡️ Sub-bloco: [`sequencia_XML_CBSMono`](#sequencia_xml_cbsmono) — Sequência XML (0-1)

*Continuação dos campos de `gIBSCBSMono` (após o fechamento de `sequencia_XML_CBSMono`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.105a | `vTotIBSMonoItem` | Total de IBS Monofásico. | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.105b | `vTotCBSMonoItem` | Total da CBS Monofásica. | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml_ibsmono"></a>

###### `sequencia_XML_IBSMono` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_IBSMono`  
**ID:** 324.85 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1009  
**Rótulo na planilha:** Sequência XML IBS Mono  

Abertura: `--sequencia_XML_IBSMono_ini--;` · Fechamento: `--sequencia_XML_IBSMono_fim--;`

➡️ Sub-bloco: [`gIBSMonoAdRem`](#gibsmonoadrem) — Grupo de informações da Tributação Monofásica Ad Rem do IBS (0-1)

➡️ Sub-bloco: [`gIBSMonoAdValorem`](#gibsmonoadvalorem) — Grupo de informações da Tributação Monofásica Ad Valorem do IBS (0-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="gibsmonoadrem"></a>

###### `gIBSMonoAdRem` — Grupo de informações da Tributação Monofásica Ad Rem do IBS

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_IBSMono` › `gIBSMonoAdRem`  
**ID:** 324.85a · **Tipo:** CG · **Ocorrência:** 0-1 · **Linha na planilha:** 1010  

> Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao ano corrente, conforme estabelecido na legislação.

Abertura: `--gIBSMonoAdRem_ini--;` · Fechamento: `--gIBSMonoAdRem_fim--;`

➡️ Sub-bloco: [`gMonoPadrao`](#gmonopadrao) — Grupo de informações da Tributação Monofásica Padrão (0-1)

➡️ Sub-bloco: [`gMonoReten`](#gmonoreten) — Grupo de informações da Tributação Monofásica Sujeita à Retenção (0-1)

➡️ Sub-bloco: [`gMonoRet`](#gmonoret) — Grupo de informações da Tributação Monofásica Retida Anteriormente (0-1)

➡️ Sub-bloco: [`gpBioDiferenca`](#gpbiodiferenca) — Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior ou superior ao obrigatório (0-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="gmonopadrao"></a>

###### `gMonoPadrao` — Grupo de informações da Tributação Monofásica Padrão

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_IBSMono` › `gIBSMonoAdRem` › `gMonoPadrao`  
**ID:** 324.86 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1011  

> Grupo Opcional.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gMonoPadrao" da tabela de cClassTrib do IBS e da CBS.

Abertura: `--gMonoPadrao_ini--;` · Fechamento: `--gMonoPadrao_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.86a | `qBCMono` | Quantidade tributada na monofasia | Numérico | 1-1 | 15 | 0 ou 4 | Informar a BC em quantidade conforme unidade de medida estabelecida na legislação para o produto. | 15 posições, sendo 11 inteiros e 0 ou 4 decimais |
| 324.86b | `adRemIBS` | Alíquota ad rem do IBS | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.86c | `vIBSMono` | Valor do IBS monofásico | Numérico | 1-1 | 15 | 2 | O valor do imposto é obtido pela multiplicação da alíquota ad rem pela quantidade do produto conforme unidade de medida estabelecida na legislação. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gmonoreten"></a>

###### `gMonoReten` — Grupo de informações da Tributação Monofásica Sujeita à Retenção

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_IBSMono` › `gIBSMonoAdRem` › `gMonoReten`  
**ID:** 324.87 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1016  

> Uso em operações com combustíveis derivados de petróleo (Gasolina A) [ou *Óleo Diesel A*] para retenção do imposto sobre o biocombustível a ser misturado. Art. 178 da LC 214/2025.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gMonoReten" da tabela de cClassTrib do IBS e da CBS.

Abertura: `--gMonoReten_ini--;` · Fechamento: `--gMonoReten_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.87a | `qBCMonoReten` | Quantidade tributada sujeita à retenção na monofasia | Numérico | 1-1 | 15 | 0 ou 4 | Informar a BC sujeita a retenção em quantidade conforme unidade de medida estabelecida na legislação para o produto. | 15 posições, sendo 11 inteiros e 0 ou 4 decimais |
| 324.87b | `adRemIBSReten` | Alíquota ad rem do IBS sujeito à retenção | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.87c | `vIBSMonoReten` | Valor do IBS monofásico sujeito à retenção | Numérico | 1-1 | 15 | 2 | Valor do IBS com retenção, a ser somado ao valor de IBS a ser recolhido. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gmonoret"></a>

###### `gMonoRet` — Grupo de informações da Tributação Monofásica Retida Anteriormente

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_IBSMono` › `gIBSMonoAdRem` › `gMonoRet`  
**ID:** 324.88 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1021  

> Tributação monofásica própria sobre combustíveis cobrada anteriormente.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gMonoRet" da tabela cClassTrib do IBS e da CBS.

Abertura: `--gMonoRet_ini--;` · Fechamento: `--gMonoRet_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.88a | `vIBSMonoRet` | Valor do IBS retido anteriormente | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gpbiodiferenca"></a>

###### `gpBioDiferenca` — Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior ou superior ao obrigatório

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_IBSMono` › `gIBSMonoAdRem` › `gpBioDiferenca`  
**ID:** 324.89 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1024  
**Rótulo na planilha:** Grupo de informações sobre mistura de EAC com gasolina A (Biocombustível)  

> Referência (LC 214/2025): Art. 179, II, a e b (cClassTrib 620004 e 620005).<br>Informar caso pBio seja diferente do pBioObrigatório.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gpBioDiferenca" da tabela cClassTrib do IBS e da CBS.

Abertura: `--gpBioDiferenca_ini--;` · Fechamento: `--gpBioDiferenca_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.89a | `qBCBioComb` | Quantidade de Biocombustível (EAC) a recolher ou a ressarcir | Numérico | 1-1 | 15 | 0 ou 4 | — | 15 posições, sendo 11 inteiros e 0 ou 4 decimais |
| 324.89b | `vIBSDiferenca` | Valor do IBS correspondente a diferença em relação ao pBioObrigatorio | Numérico | 1-1 | 15 | 2 | Se classTrib = 620004: valor a ser recolhido.<br>Se classTrib = 620005: valor a ser ressarcido. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gibsmonoadvalorem"></a>

###### `gIBSMonoAdValorem` — Grupo de informações da Tributação Monofásica Ad Valorem do IBS

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_IBSMono` › `gIBSMonoAdValorem`  
**ID:** 324.90 · **Tipo:** CG · **Ocorrência:** 0-1 · **Linha na planilha:** 1029  

> Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao ano corrente, conforme estabelecido na legislação.

Abertura: `--gIBSMonoAdValorem_ini--;` · Fechamento: `--gIBSMonoAdValorem_fim--;`

➡️ Sub-bloco: [`gMonoPadrao`](#gmonopadrao-1) — Grupo de informações da Tributação Monofásica Padrão (0-1)

➡️ Sub-bloco: [`gMonoReten`](#gmonoreten-1) — Grupo de informações da Tributação Monofásica Sujeita à Retenção (0-1)

➡️ Sub-bloco: [`gMonoRet`](#gmonoret-1) — Grupo de informações da Tributação Monofásica Retida Anteriormente (0-1)

➡️ Sub-bloco: [`gpBioDiferenca`](#gpbiodiferenca-1) — Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior ou superior ao obrigatório (0-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="gmonopadrao-1"></a>

###### `gMonoPadrao` — Grupo de informações da Tributação Monofásica Padrão

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_IBSMono` › `gIBSMonoAdValorem` › `gMonoPadrao`  
**ID:** 324.91 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1030  

> Grupo Opcional.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gMonoPadrao" da tabela de cClassTrib do IBS e da CBS.

Abertura: `--gMonoPadrao_ini--;` · Fechamento: `--gMonoPadrao_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.91a | `vBCMono` | Valor tributado na monofasia | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.91b | `pAliqMonoUF` | Alíquota ad valorem do IBS Estadual | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.91c | `vIBSMonoUF` | Valor do IBS monofásico Estadual | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.91d | `pAliqMonoMun` | Alíquota ad valorem do IBS Municipal | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.91e | `vIBSMonoMun` | Valor do IBS monofásico Municipal | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.91f | `vIBSMono` | Valor do IBS monofásico | Numérico | 1-1 | 15 | 2 | Observação: vIBSMonoUF + vIBSMonoMun | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gmonoreten-1"></a>

###### `gMonoReten` — Grupo de informações da Tributação Monofásica Sujeita à Retenção

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_IBSMono` › `gIBSMonoAdValorem` › `gMonoReten`  
**ID:** 324.92 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1038  

> Uso em operações com combustíveis derivados de petróleo (Gasolina A) [ou *Óleo Diesel A*] para retenção do imposto sobre o biocombustível a ser misturado. Art. 178 da LC 214/2025.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gMonoReten" da tabela de cClassTrib do IBS e da CBS.

Abertura: `--gMonoReten_ini--;` · Fechamento: `--gMonoReten_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.92a | `vBCMonoReten` | Valor tributado sujeito à retenção na monofasia | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.92b | `pAliqMonoReten` | Alíquota ad valorem do IBS sujeito à retenção | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.92c | `vIBSMonoReten` | Valor do IBS monofásico sujeito à retenção | Numérico | 1-1 | 15 | 2 | Valor do IBS com retenção, a ser somado ao valor de IBS a ser recolhido. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gmonoret-1"></a>

###### `gMonoRet` — Grupo de informações da Tributação Monofásica Retida Anteriormente

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_IBSMono` › `gIBSMonoAdValorem` › `gMonoRet`  
**ID:** 324.93 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1043  

> Tributação monofásica própria sobre combustíveis cobrada anteriormente.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gMonoRet" da tabela cClassTrib do IBS e da CBS.

Abertura: `--gMonoRet_ini--;` · Fechamento: `--gMonoRet_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.93a | `vIBSMonoRet` | Valor do IBS retido anteriormente | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gpbiodiferenca-1"></a>

###### `gpBioDiferenca` — Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior ou superior ao obrigatório

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_IBSMono` › `gIBSMonoAdValorem` › `gpBioDiferenca`  
**ID:** 324.94 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1046  
**Rótulo na planilha:** Grupo de informações sobre mistura de EAC com gasolina A (Biocombustível)  

> Referência (LC 214/2025): Art. 179, II, a e b (cClassTrib 620004 e 620005).<br>Informar caso pBio seja diferente do pBioObrigatório.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gpBioDiferenca" da tabela cClassTrib do IBS e da CBS.

Abertura: `--gpBioDiferenca_ini--;` · Fechamento: `--gpBioDiferenca_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.94a | `qBCBioComb` | Quantidade de Biocombustível (EAC) a recolher ou a ressarcir | Numérico | 1-1 | 15 | 0 ou 4 | — | 15 posições, sendo 11 inteiros e 0 ou 4 decimais |
| 324.94b | `vIBSDiferenca` | Valor do IBS correspondente a diferença em relação ao pBioObrigatorio | Numérico | 1-1 | 15 | 2 | Se classTrib = 620004: valor a ser recolhido.<br>Se classTrib = 620005: valor a ser ressarcido. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml_cbsmono"></a>

###### `sequencia_XML_CBSMono` — Sequência XML

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_CBSMono`  
**ID:** 324.95 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1052  
**Rótulo na planilha:** Sequência XML CBS Mono  

Abertura: `--sequencia_XML_CBSMono_ini--;` · Fechamento: `--sequencia_XML_CBSMono_fim--;`

➡️ Sub-bloco: [`gCBSMonoAdRem`](#gcbsmonoadrem) — Grupo de informações da Tributação Monofásica Ad Rem da CBS (0-1)

➡️ Sub-bloco: [`gCBSMonoAdValorem`](#gcbsmonoadvalorem) — Grupo de informações da Tributação Monofásica Ad Valorem da CBS (0-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="gcbsmonoadrem"></a>

###### `gCBSMonoAdRem` — Grupo de informações da Tributação Monofásica Ad Rem da CBS

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_CBSMono` › `gCBSMonoAdRem`  
**ID:** 324.95a · **Tipo:** CG · **Ocorrência:** 0-1 · **Linha na planilha:** 1053  

> Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao ano corrente, conforme estabelecido na legislação.

Abertura: `--gCBSMonoAdRem_ini--;` · Fechamento: `--gCBSMonoAdRem_fim--;`

➡️ Sub-bloco: [`gMonoPadrao`](#gmonopadrao-2) — Grupo de informações da Tributação Monofásica Padrão (0-1)

➡️ Sub-bloco: [`gMonoReten`](#gmonoreten-2) — Grupo de informações da Tributação Monofásica Sujeita à Retenção (0-1)

➡️ Sub-bloco: [`gMonoRet`](#gmonoret-2) — Grupo de informações da Tributação Monofásica Retida Anteriormente (0-1)

➡️ Sub-bloco: [`gpBioDiferenca`](#gpbiodiferenca-2) — Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior ou superior ao obrigatório (0-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="gmonopadrao-2"></a>

###### `gMonoPadrao` — Grupo de informações da Tributação Monofásica Padrão

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_CBSMono` › `gCBSMonoAdRem` › `gMonoPadrao`  
**ID:** 324.96 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1054  

> Grupo Opcional.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gMonoPadrao" da tabela de cClassTrib do IBS e da CBS.

Abertura: `--gMonoPadrao_ini--;` · Fechamento: `--gMonoPadrao_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.96a | `qBCMono` | Quantidade tributada na monofasia | Numérico | 1-1 | 15 | 0 ou 4 | Informar a BC em quantidade conforme unidade de medida estabelecida na legislação para o produto. | 15 posições, sendo 11 inteiros e 0 ou 4 decimais |
| 324.96b | `adRemCBS` | Alíquota ad rem da CBS | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.96c | `vCBSMono` | Valor da CBS monofásica | Numérico | 1-1 | 15 | 2 | O valor do imposto é obtido pela multiplicação da alíquota ad rem pela quantidade do produto conforme unidade de medida estabelecida na legislação. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gmonoreten-2"></a>

###### `gMonoReten` — Grupo de informações da Tributação Monofásica Sujeita à Retenção

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_CBSMono` › `gCBSMonoAdRem` › `gMonoReten`  
**ID:** 324.97 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1059  

> Uso em operações com combustíveis derivados de petróleo (Gasolina A) [ou *Óleo Diesel A*] para retenção do imposto sobre o biocombustível a ser misturado. Art. 178 da LC 214/2025.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gMonoReten" da tabela de cClassTrib do IBS e da CBS.

Abertura: `--gMonoReten_ini--;` · Fechamento: `--gMonoReten_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.97a | `qBCMonoReten` | Quantidade tributada sujeita à retenção na monofasia | Numérico | 1-1 | 15 | 0 ou 4 | Informar a BC sujeita a retenção em quantidade conforme unidade de medida estabelecida na legislação para o produto. | 15 posições, sendo 11 inteiros e 0 ou 4 decimais |
| 324.97b | `adRemCBSReten` | Alíquota ad rem da CBS sujeita à retenção | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.97c | `vCBSMonoReten` | Valor da CBS monofásica sujeita à retenção | Numérico | 1-1 | 15 | 2 | Valor do CBS com retenção, a ser somado ao valor de CBS a ser recolhida. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gmonoret-2"></a>

###### `gMonoRet` — Grupo de informações da Tributação Monofásica Retida Anteriormente

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_CBSMono` › `gCBSMonoAdRem` › `gMonoRet`  
**ID:** 324.98 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1064  

> Tributação monofásica própria sobre combustíveis cobrada anteriormente.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gMonoRet" da tabela cClassTrib do IBS e da CBS.

Abertura: `--gMonoRet_ini--;` · Fechamento: `--gMonoRet_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.98a | `vCBSMonoRet` | Valor da CBS retida anteriormente | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gpbiodiferenca-2"></a>

###### `gpBioDiferenca` — Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior ou superior ao obrigatório

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_CBSMono` › `gCBSMonoAdRem` › `gpBioDiferenca`  
**ID:** 324.99 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1067  
**Rótulo na planilha:** Grupo de informações sobre mistura de EAC com gasolina A (Biocombustível)  

> Referência (LC 214/2025): Art. 179, II, a e b (cClassTrib 620004 e 620005).<br>Informar caso pBio seja diferente do pBioObrigatório.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gpBioDiferenca" da tabela cClassTrib do IBS e da CBS.

Abertura: `--gpBioDiferenca_ini--;` · Fechamento: `--gpBioDiferenca_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.99a | `qBCBioComb` | Quantidade de Biocombustível (EAC) a recolher ou a ressarcir | Numérico | 1-1 | 15 | 0 ou 4 | — | 15 posições, sendo 11 inteiros e 0 ou 4 decimais |
| 324.99b | `vCBSDiferenca` | Valor da CBS correspondente a diferença em relação ao pBioObrigatorio | Numérico | 1-1 | 15 | 2 | Se classTrib = 620004: valor a ser recolhido.<br>Se classTrib = 620005: valor a ser ressarcido. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gcbsmonoadvalorem"></a>

###### `gCBSMonoAdValorem` — Grupo de informações da Tributação Monofásica Ad Valorem da CBS

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_CBSMono` › `gCBSMonoAdValorem`  
**ID:** 324.100 · **Tipo:** CG · **Ocorrência:** 0-1 · **Linha na planilha:** 1072  

> Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao ano corrente, conforme estabelecido na legislação.

Abertura: `--gCBSMonoAdValorem_ini--;` · Fechamento: `--gCBSMonoAdValorem_fim--;`

➡️ Sub-bloco: [`gMonoPadrao`](#gmonopadrao-3) — Grupo de informações da Tributação Monofásica Padrão (0-1)

➡️ Sub-bloco: [`gMonoReten`](#gmonoreten-3) — Grupo de informações da Tributação Monofásica Sujeita à Retenção (0-1)

➡️ Sub-bloco: [`gMonoRet`](#gmonoret-3) — Grupo de informações da Tributação Monofásica Retida Anteriormente (0-1)

➡️ Sub-bloco: [`gpBioDiferenca`](#gpbiodiferenca-3) — Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior ou superior ao obrigatório (0-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="gmonopadrao-3"></a>

###### `gMonoPadrao` — Grupo de informações da Tributação Monofásica Padrão

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_CBSMono` › `gCBSMonoAdValorem` › `gMonoPadrao`  
**ID:** 324.101 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1073  

> Grupo Opcional.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gMonoPadrao" da tabela de cClassTrib do IBS e da CBS.

Abertura: `--gMonoPadrao_ini--;` · Fechamento: `--gMonoPadrao_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.101a | `vBCMono` | Valor tributado na monofasia | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.101b | `pAliqMonoCBS` | Alíquota ad valorem da CBS | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.101c | `vCBSMono` | Valor da CBS monofásica | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gmonoreten-3"></a>

###### `gMonoReten` — Grupo de informações da Tributação Monofásica Sujeita à Retenção

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_CBSMono` › `gCBSMonoAdValorem` › `gMonoReten`  
**ID:** 324.102 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1078  

> Uso em operações com combustíveis derivados de petróleo (Gasolina A) [ou *Óleo Diesel A*] para retenção do imposto sobre o biocombustível a ser misturado. Art. 178 da LC 214/2025.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gMonoReten" da tabela de cClassTrib do IBS e da CBS.

Abertura: `--gMonoReten_ini--;` · Fechamento: `--gMonoReten_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.102a | `vBCMonoReten` | Valor tributado sujeito à retenção na monofasia | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.102b | `pAliqMonoReten` | Alíquota ad valorem da CBS sujeito à retenção | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324.102c | `vCBSMonoReten` | Valor da CBS monofásica sujeita à retenção | Numérico | 1-1 | 15 | 2 | Valor da CBS com retenção, a ser somado ao valor de CBS a ser recolhida. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gmonoret-3"></a>

###### `gMonoRet` — Grupo de informações da Tributação Monofásica Retida Anteriormente

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_CBSMono` › `gCBSMonoAdValorem` › `gMonoRet`  
**ID:** 324.103 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1083  

> Tributação monofásica própria sobre combustíveis cobrada anteriormente.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gMonoRet" da tabela cClassTrib do IBS e da CBS.

Abertura: `--gMonoRet_ini--;` · Fechamento: `--gMonoRet_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.103a | `vCBSMonoRet` | Valor da CBS retida anteriormente | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gpbiodiferenca-3"></a>

###### `gpBioDiferenca` — Grupo de informações sobre mistura de EAC com gasolina A em percentual inferior ou superior ao obrigatório

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gIBSCBSMono` › `sequencia_XML_CBSMono` › `gCBSMonoAdValorem` › `gpBioDiferenca`  
**ID:** 324.104 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1086  
**Rótulo na planilha:** Grupo de informações sobre mistura de EAC com gasolina A (Biocombustível)  

> Referência (LC 214/2025): Art. 179, II, a e b (cClassTrib 620004 e 620005).<br>Informar caso pBio seja diferente do pBioObrigatório.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador "ind_gpBioDiferenca" da tabela cClassTrib do IBS e da CBS.

Abertura: `--gpBioDiferenca_ini--;` · Fechamento: `--gpBioDiferenca_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.104a | `qBCBioComb` | Quantidade de Biocombustível (EAC) a recolher ou a ressarcir | Numérico | 1-1 | 15 | 0 ou 4 | — | 15 posições, sendo 11 inteiros e 0 ou 4 decimais |
| 324.104b | `vCBSDiferenca` | Valor da CBS correspondente a diferença em relação ao pBioObrigatorio | Numérico | 1-1 | 15 | 2 | Se classTrib = 620004: valor a ser recolhido.<br>Se classTrib = 620005: valor a ser ressarcido. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gtransfcred"></a>

###### `gTransfCred` — Transferências de Crédito

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gTransfCred`  
**ID:** 324.106 · **Tipo:** CG · **Ocorrência:** 1-1 · **Linha na planilha:** 1095  

> Se trata de um CG (indica que o campo é um Elemento que deriva de uma Escolha (Choice), ou é necessário enviar gTransfCred ou  gAjusteCompet ou gIBSCBSMono ou gIBSCBS).

Abertura: `--gTransfCred_ini--;` · Fechamento: `--gTransfCred_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324107 | `vIBS` | Valor do IBS a ser transferido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.108 | `vCBS` | Valor da CBS a ser transferida | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gajustecompet"></a>

###### `gAjusteCompet` — Ajuste de Competência

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_IBSCBS` › `gAjusteCompet`  
**ID:** 324.112 · **Tipo:** CG · **Ocorrência:** 1-1 · **Linha na planilha:** 1099  

> Se trata de um CG (indica que o campo é um Elemento que deriva de uma Escolha (Choice), ou é necessário enviar gTransfCred ou  gAjusteCompet ou gIBSCBSMono ou gIBSCBS).<br>Observação: a obrigatoriedade ou vedação do <br>preenchimento deste grupo está condicionada <br>ao indicador “ind_gAjusteCompet” da tabela de <br>CST do IBS e da CBS.

Abertura: `--gAjusteCompet_ini--;` · Fechamento: `--gAjusteCompet_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324113 | `competApur` | Ano e mês referência do período de apuração (AAAA-MM) | Caractere | 1-1 | 7 | — | Informar período atual ou retroativo. | — |
| 324114 | `vIBS` | Valor do IBS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324115 | `vCBS` | Valor da CBS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gestornocred"></a>

###### `gEstornoCred` — gEstornoCred

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `gEstornoCred`  
**ID:** 324116 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1105  

Abertura: `--gEstornoCred_ini--;` · Fechamento: `--gEstornoCred_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324.17 | `vIBSEstCred` | Valor do IBS a ser estornado | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324.18 | `vCBSEstCred` | Valor da CBS a ser estornada | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="sequencia_xml_cred_pres"></a>

###### `sequencia_XML_cred_pres` — Grupo de Crédito Presumido da Operação

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_cred_pres`  
**ID:** 324119 · **Tipo:** G · **Ocorrência:** 0-1 · **Linha na planilha:** 1109  

Abertura: `--sequencia_XML_cred_pres_ini--;` · Fechamento: `--sequencia_XML_cred_pres_fim--;`

➡️ Sub-bloco: [`gCredPresOper`](#gcredpresoper) — Grupo de Crédito Presumido da Operação (1-1)

➡️ Sub-bloco: [`gCredPresIBSZFM`](#gcredpresibszfm) — Grupo para apropriação de crédito presumido de IBS sobre o saldo devedor na ZFM (art. 450, § 1º, LC 214/25) (1-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="gcredpresoper"></a>

###### `gCredPresOper` — Grupo de Crédito Presumido da Operação

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_cred_pres` › `gCredPresOper`  
**ID:** 324.120 · **Tipo:** CG · **Ocorrência:** 1-1 · **Linha na planilha:** 1110  

> Se trata de um CG (indica que o campo é um Elemento que deriva de uma Escolha (Choice), é necessário enviar esse ou o gCredPresIBSZFM);<br>Observação 1: a permissão ou vedação do preenchimento deste grupo está condicionada ao indicador “ind_gCredPresOper” da tabela de cClassTrib do IBS e da CBS.<br>Observação 2: O valor "1" do indicador “ind_gCredPresOper” significa que o contribuinte pode utilizar o crédito presumido, sem obrigatoriedade (permite, mas não exige).

Abertura: `--gCredPresOper_ini--;` · Fechamento: `--gCredPresOper_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324121 | `vBCCredPres` | Valor da Base de Cálculo do Crédito Presumido da Operação | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 324122 | `cCredPres` | Código de Classificação do Crédito Presumido | Numérico | 1-1 | 2 | — | Utilizar tabela cCredPres. | — |

➡️ Sub-bloco: [`gIBSCredPres`](#gibscredpres) — Grupo de Informações do Crédito Presumido referente ao IBS (0-1)

➡️ Sub-bloco: [`gCBSCredPres`](#gcbscredpres) — Grupo de Informações do Crédito Presumido referente a CBS (0-1)

<a id="gibscredpres"></a>

###### `gIBSCredPres` — Grupo de Informações do Crédito Presumido referente ao IBS

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_cred_pres` › `gCredPresOper` › `gIBSCredPres`  
**ID:** 324.123 · **Ocorrência:** 0-1 · **Linha na planilha:** 1113  

> Grupo Opcional.<br>Grupo de Informações do Crédito Presumido do IBS, quando aproveitado pelo emitente do documento.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador “ind_gIBSCredPres” da tabela de cCredPres do IBS e da CBS.

Abertura: `--gIBSCredPres_ini--;` · Fechamento: `--gIBSCredPres_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324124 | `pCredPres` | Percentual do Crédito Presumido | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324125 | `vCredPres` | Valor do Crédito Presumido | Numérico | 1-1 | 15 | 2 | Se trata de um CE (indica que o campo é um Elemento que deriva de uma Escolha (Choice), é necessário enviar esse ou o vCredPresCondSus); | 15 posições, sendo 13 inteiros e 2 decimais |
| 324126 | `vCredPresCondSus` | Valor do Crédito Presumido em condição <br>suspensiva. | Numérico | 1-1 | 15 | 2 | Se trata de um CE (indica que o campo é um Elemento que deriva de uma Escolha (Choice), é necessário enviar esse ou o vCredPres);<br>Valor do Crédito Presumido Condição Suspensiva. <br>Preencher apenas para cCredPres com indicação de Condição Suspensiva | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gcbscredpres"></a>

###### `gCBSCredPres` — Grupo de Informações do Crédito Presumido referente a CBS

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_cred_pres` › `gCredPresOper` › `gCBSCredPres`  
**ID:** 324.127 · **Ocorrência:** 0-1 · **Linha na planilha:** 1118  

> Grupo Opcional.<br>Grupo de Informações do Crédito Presumido da CBS, quando aproveitado pelo emitente do documento.<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador “ind_gCBSCredPres” da tabela de cCredPres do IBS e da CBS.

Abertura: `--gCBSCredPres_ini--;` · Fechamento: `--gCBSCredPres_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324128 | `pCredPres` | Percentual do Crédito Presumido | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 324129 | `vCredPres` | Valor do Crédito Presumido | Numérico | 1-1 | 15 | 2 | Se trata de um CE (indica que o campo é um Elemento que deriva de uma Escolha (Choice), é necessário enviar esse ou o vCredPresCondSus); | 15 posições, sendo 13 inteiros e 2 decimais |
| 324130 | `vCredPresCondSus` | Valor do Crédito Presumido em condição <br>suspensiva. | Numérico | 1-1 | 15 | 2 | Se trata de um CE (indica que o campo é um Elemento que deriva de uma Escolha (Choice), é necessário enviar esse ou o vCredPres);<br>Valor do Crédito Presumido Condição Suspensiva. <br>Preencher apenas para cCredPres com indicação de Condição Suspensiva | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gcredpresibszfm"></a>

###### `gCredPresIBSZFM` — Grupo para apropriação de crédito presumido de IBS sobre o saldo devedor na ZFM (art. 450, § 1º, LC 214/25)

**Caminho:** `nota` › `item_nota` › `det` › `impostos` › `IBSCBS` › `sequencia_XML_cred_pres` › `gCredPresIBSZFM`  
**ID:** 324.131 · **Tipo:** CG · **Ocorrência:** 1-1 · **Linha na planilha:** 1124  
**Rótulo na planilha:** Grupo para apropriação de crédito presumido de IBS sobre o saldo devedor na ZFM  

> Se trata de um CG (indica que o campo é um Elemento que deriva de uma Escolha (Choice), é necessário enviar esse ou o gCredPresOper);<br>Observação: a obrigatoriedade ou vedação do preenchimento deste grupo está condicionada ao indicador “ind_gCredPresIBSZFM” da tabela de CST do IBS e da CBS.

Abertura: `--gCredPresIBSZFM_ini--;` · Fechamento: `--gCredPresIBSZFM_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324132 | `competApur` | Ano e mês referência do período de apuração (AAAA-MM) | Caractere | 1-1 | 7 | — | Informar período atual ou retroativo. | — |
| 324133 | `tpCredPresIBSZFM` | Tipo de classificação de acordo com o art. 450, § 1º, da LC 214/25 para o cálculo do crédito presumido na ZFM | Numérico | 1-1 | 1 | — | Classificação conforme percentuais definidos no art. 450, § 1º, da LC 214/25 para o cálculo do crédito presumido:<br>0 - Sem Crédito Presumido<br>1 - Bens de consumo final (55%)<br>2 - Bens de capital (75%)<br>3 - Bens intermediários (90,25%)<br>4 - Bens de informática e outros definidos em <br>legislação (100%) | — |
| 324134 | `vCredPresIBSZFM` | Valor do crédito presumido calculado sobre o saldo devedor apurado | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="imposto_devol"></a>

###### `imposto_devol` — Informação do Imposto devolvido

**Caminho:** `nota` › `item_nota` › `det` › `imposto_devol`  
**ID:** 324p · **Ocorrência:** 0-1 · **Linha na planilha:** 1132  
**Rótulo na planilha:** Tributos Devolvidos  

> Nota: O motivo da devolução deverá ser informado pela empresa no campo de Informações Adicionais do Produto (tag:infAdProd).

Abertura: `--imposto_devol_ini--;` · Fechamento: `--imposto_devol_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324q | `pDevol` | Percentual da mercadoria devolvida | Numérico | 1-1 | 5 | 2 | Nota: O valor máximo deste percentual é 100%, no caso de devolução total da mercadoria. | 5 posições, sendo 3 inteiros e 2 decimais |

➡️ Sub-bloco: [`ipi_devol`](#ipi_devol) — Informação do IPI devolvido (1-1)

<a id="ipi_devol"></a>

###### `ipi_devol` — Informação do IPI devolvido

**Caminho:** `nota` › `item_nota` › `det` › `imposto_devol` › `ipi_devol`  
**ID:** 324r · **Ocorrência:** 1-1 · **Linha na planilha:** 1134  
**Rótulo na planilha:** IPI Devolvido  

Abertura: `--ipi_devol_ini--;` · Fechamento: `--ipi_devol_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 324s | `vIPIDevol` | Valor do IPI devolvido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="inf_adicionais"></a>

###### `inf_adicionais` — Informações Adicionais (para o item da NF-e)

**Caminho:** `nota` › `item_nota` › `det` › `inf_adicionais`  
**Ocorrência:** 0-1 · **Linha na planilha:** 1138  
**Rótulo na planilha:** Informações Adicionais  

Abertura: `--inf_adicionais_ini--;` · Fechamento: `--inf_adicionais_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 325 | `infAdProd` | Informações Adicionais do Produto(Norma referenciada, informações complementares, etc.) | Caractere | 0-1 | 1-500 | — | Norma referenciada, informações complementares, etc. | — |

<a id="vitem"></a>

###### `vItem` — Valor Total do Item da NF-e

**Caminho:** `nota` › `item_nota` › `det` › `vItem`  
**ID:** 325h.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 1141  

Abertura: `--vItem_ini--;` · Fechamento: `--vItem_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 325h | `vItem` | Valor Total do Item da NF-e | Numérico | 0-1 | 15 | 2 | Valor total do Item, correspondente à sua participação no total da nota.<br>A soma dos itens deverá corresponder ao total da nota. | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="dfereferenciado"></a>

###### `DFeReferenciado` — Documento Fiscal Eletrônico Referenciado

**Caminho:** `nota` › `item_nota` › `det` › `DFeReferenciado`  
**ID:** 325i · **Ocorrência:** 0-1 · **Linha na planilha:** 1144  
**Rótulo na planilha:** Dfe Referenciado  

> Grupo para referenciamento de itens de outro DF-e.

Abertura: `--DFeReferenciado_ini--;` · Fechamento: `--DFeReferenciado_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 325j | `chaveAcesso` | Chave de acesso do DF-e referenciado | Caractere | 1-1 | 44 | — | Chave de acesso do DF-e referenciado. | — |
| 325k | `nItem` | Número do item do documento referenciado. | Numérico | 0-1 | 3 | — | Corresponde ao atributo “nItem” do elemento “det” do documento original.<br>Se o documento referenciado não tiver item, indicar “1”<br>Observação: tag opcional apenas para Nota de Débito (tpNFDebito) = 03-Débitos de notas fiscais não processadas na apuração (RV VC03-20). | — |

<a id="total"></a>

#### `total` — Grupo Totais da NF-e

**Caminho:** `nota` › `total`  
**ID:** 326 · **Ocorrência:** 1-1 · **Linha na planilha:** 1150  
**Rótulo na planilha:** Valores totais da NF-e  

> O grupo de valores totais da NF-e deve ser informado com o somatório do campo correspondente dos itens.

Abertura: `--total_ini--;` · Fechamento: `--total_fim--;`

➡️ Sub-bloco: [`icms_Tot`](#icms_tot) — Grupo Totais referentes ao ICMS (1-1)

➡️ Sub-bloco: [`issqn_Tot`](#issqn_tot) — Grupo Totais referentes ao ISSQN (0-1)

➡️ Sub-bloco: [`ret_Trib`](#ret_trib) — Grupo Retenções de Tributos (0-1)

➡️ Sub-bloco: [`ISTot`](#istot) — Grupo total do imposto seletivo (0-1)

➡️ Sub-bloco: [`IBSCBSTot`](#ibscbstot) — Totais da NF-e com IBS e CBS (0-1)

*Continuação dos campos de `total` (após o fechamento de `IBSCBSTot`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 355.30 | `vNFTot` | Valor total da NF-e com IBS / CBS / IS | Numérico | 0-1 | 15 | 2 | A partir de 2027, os valores de IBS, CBS e IS já compõem o vProd e não devem ser somados novamente neste total. (Incluído na NT 2026.008) | 15 posições, sendo 13 inteiros e 2 decimais |
| 326a | `vProdLiqTot` 🆕 | Valor Total Líquido dos Produtos ou Serviços (sem tributos) | Numérico | 0-1 | 15 | 2 | Soma dos valores líquidos dos produtos ou serviços, sem a inclusão de tributos. Campo do grupo total (fora do grupo icms_Tot). No XML, é gerado como primeira tag de total, antes de ICMSTot (a posição no TXT não altera a ordem no XML). Deve ser informado quando algum item informar vProdLiq. (Incluído na NT 2026.008) Atenção: posição alterada em relação à prévia publicada em 15/10/2026 (antes ao final do grupo icms_Tot). | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="icms_tot"></a>

##### `icms_Tot` — Grupo Totais referentes ao ICMS

**Caminho:** `nota` › `total` › `icms_Tot`  
**ID:** 327 · **Ocorrência:** 1-1 · **Linha na planilha:** 1151  
**Rótulo na planilha:** Totais referentes ao ICMS  

Abertura: `--icms_Tot_ini--;` · Fechamento: `--icms_Tot_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 328 | `vBC` | Base de Cálculo do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 329 | `vICMS` | Valor Total do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 329.01 | `vICMSDeson` | Valor Total do ICMS desonerado | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 329.08 | `vFCP` | Valor Total do Fundo de Combate à Pobreza (FCP) | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 329.03 | `vFCPUFDest` | Valor total do ICMS relativo Fundo de Combate à Pobreza (FCP) da UF de destino. | Numérico | 0-1 | 15 | 2 | Valor Total do ICMS relativo ao Fundo de Combate à Pobreza (FCP) para a UF de destino (NT2015/003) | 15 posições, sendo 13 inteiros e 2 decimais |
| 329.05 | `vICMSUFDest` | Valor Total do ICMS Interestadual para a UF destino | Numérico | 0-1 | 15 | 2 | Valor do ICMS Interestadual para a UF de destino (sem o valor do<br>ICMS relativo ao FCP). (NT2015/003) | 15 posições, sendo 13 inteiros e 2 decimais |
| 329.07 | `vICMSUFRemet` | Valor Total do ICMS Interestadual para a UF do remetente | Numérico | 0-1 | 15 | 2 | Valor total do ICMS Interestadual para a UF do remetente. <br>Nota: A partir de 2019, este valor será zero. (NT2015/003) | 15 posições, sendo 13 inteiros e 2 decimais |
| 330 | `vBCST` | Base de Cálculo do ICMS ST | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 331 | `vST` | Valor Total do ICMS ST | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 331.01 | `vFCPST` | Valor Total do Fundo de Combate à Pobreza (FCP) retido por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 331.02 | `vFCPSTRet` | Valor Total do Fundo de Combate à Pobreza (FCP) retido anteriormente por Substituição Tributária | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 331.02a | `qBCMono` | Valor total da quantidade tributada do ICMS monofásico próprio | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 331.03 | `vICMSMono` | Valor total do ICMS monofásico próprio | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 331.03a | `qBCMonoReten` | Valor total da quantidade tributada do ICMS monofásico  sujeito a retenção | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 331.04 | `vICMSMonoReten` | Valor total do ICMS monofásico sujeito a retenção | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 331.04a | `qBCMonoRet` | Valor total da quantidade tributada do ICMS monofásico  retido anteriormente | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 331.05 | `vICMSMonoRet` | Valor total do ICMS monofásico retido anteriormente | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 332 | `vProd` | Valor Total dos Produtos e Serviços | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 333 | `vFrete` | Valor Total do Frete | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 334 | `vSeg` | Valor Total do Seguro | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 335 | `vDesc` | Valor Total do Desconto | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 336 | `vII` | Valor Total do II | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 337 | `vIPI` | Valor Total do IPI | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 337.01 | `vIPIDevol` | Valor Total do IPI devolvido | Numérico | 1-1 | 15 | 2 | Deve ser informado quando preenchido o Grupo Tributos Devolvidos na emissão de nota finNFe=4 (devolução) nas operações com não contribuintes do IPI. | 15 posições, sendo 13 inteiros e 2 decimais |
| 338 | `vPIS` | Valor Total do PIS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 339 | `vCOFINS` | Valor Total do COFINS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 340 | `vOutro` | Outras Despesas acessórias | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 341 | `vNF` | Valor Total da NF-e | Numérico | 1-1 | 15 | 2 | Vide validação para este campo na regra de validação "W16-xx". | 15 posições, sendo 13 inteiros e 2 decimais |
| 341a | `vTotTrib` | Valor aproximado total de tributos federais, estaduais e municipais | Numérico | 0-1 | 15 | 2 | (NT 2013.003) | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="issqn_tot"></a>

##### `issqn_Tot` — Grupo Totais referentes ao ISSQN

**Caminho:** `nota` › `total` › `issqn_Tot`  
**ID:** 342 · **Ocorrência:** 0-1 · **Linha na planilha:** 1182  
**Rótulo na planilha:** Totais referentes ao ISSQN  

Abertura: `--issqn_Tot_ini--;` · Fechamento: `--issqn_Tot_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 343 | `vServ` | Valor total dos Serviços sob não-incidência ou não tributados pelo ICMS | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 344 | `vBC` | Valor total Base de Cálculo do ISS | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 345 | `vISS` | Valor Total do ISS | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 346 | `vPIS` | Valor do PIS sobre Serviços | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 347 | `vCOFINS` | Valor da COFINS sobre serviços | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 347a | `dCompet` | Data da prestação do serviço | Numérico | 1-1 | 8 | — | Formato: AAAA-MM-DD | — |
| 347b | `vDeducao` | Valor total dedução para redução da Base de Cálculo | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 347c | `vOutro` | Valor total outras retenções | Numérico | 0-1 | 15 | 2 | Valor declaratório | 15 posições, sendo 13 inteiros e 2 decimais |
| 347d | `vDescIncond` | Valor total desconto incondicionado | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 347e | `vDescCond` | Valor total desconto condicionado | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 347f | `vISSRet` | Valor total retenção ISS | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 347g | `cRegTrib` | Código do Regime Especial de Tributação | Numérico | 0-1 | 2 | — | 1 - Microempresa Municipal;<br>2 - Estimativa;<br>3 - Sociedade de Profissionais;<br>4 - Cooperativa;<br>5 - Microempresário Individual (MEI);<br>6 - Microempresário e Empresa de Pequeno Porte (ME/EPP). | — |

<a id="ret_trib"></a>

##### `ret_Trib` — Grupo Retenções de Tributos

**Caminho:** `nota` › `total` › `ret_Trib`  
**ID:** 348 · **Ocorrência:** 0-1 · **Linha na planilha:** 1196  
**Rótulo na planilha:** Retenções de Tributos  

Abertura: `--ret_Trib_ini--;` · Fechamento: `--ret_Trib_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 349 | `vRetPIS` | Valor Retido de PIS | Numérico | 0-1 | 15 | 2 | Exemplos de atos normativos que definem obrigatoriedade da retenção de contribuições:<br>a) IRPJ/CSLL/PIS/COFINS - Fonte - Recebimentos de Órgãos Públicos Federais Lei nº 9.430, de 27 de dezembro de 1996, art. 64 Lei nº 10.833/2003, art. 34 como normas infra legais, temos como exemplo: Instrução Normativa SRF nº 480/2004 e Instrução Normativa nº 539, de 25/04/2005. <br>b) Retenção do Imposto de Renda pelas Fontes Pagadoras REMUNERAÇÃO DE SERVIÇOS PROFISSIONAIS PRESTADOS POR PESSOA JURÍDICA LEI Nº 7.450/85, ART. 52 <br>c) IRPJ, CSLL, COFINS e PIS - Serviços Prestados por Pessoas Jurídicas - Retenção na Fonte Lei nº 10.833 de 29.12.2003, arts. 30, 31, 32, 35 e 36 | 15 posições, sendo 13 inteiros e 2 decimais |
| 350 | `vRetCOFINS` | Valor Retido de COFINS | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 351 | `vRetCSLL` | Valor Retido de CSLL | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 352 | `vBCIRRF` | Base de Cálculo do IRRF | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 353 | `vIRRF` | Valor Retido do IRRF | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 354 | `vBCRetPrev` | Base de Cálculo da Retenção da Previdência Social | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355 | `vRetPrev` | Valor da Retenção da Previdência Social | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="istot"></a>

##### `ISTot` — Grupo total do imposto seletivo

**Caminho:** `nota` › `total` › `ISTot`  
**ID:** 355.1 · **Tipo:** Grupo · **Ocorrência:** 0-1 · **Linha na planilha:** 1205  

> O grupo de valores totais da NF-e deve ser informado com o somatório do campo correspondente dos itens.<br>O IS é “por fora”, portanto seu valor deve ser adicionado ao valor total da NF.

Abertura: `--ISTot_ini--;` · Fechamento: `--ISTot_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 355.3 | `vIS` | Total do imposto seletivo | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="ibscbstot"></a>

##### `IBSCBSTot` — Totais da NF-e com IBS e CBS

**Caminho:** `nota` › `total` › `IBSCBSTot`  
**ID:** 355.4 · **Tipo:** Grupo · **Ocorrência:** 0-1 · **Linha na planilha:** 1208  

> O grupo de valores totais da NF-e deve ser informado com o somatório do campo correspondente dos itens.<br>O IBS e a CBS são “por fora”, por isso seus valores devem ser adicionados ao valor total da NF

Abertura: `--IBSCBSTot_ini--;` · Fechamento: `--IBSCBSTot_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 355.5 | `vBCIBSCBS` | Valor total da BC do IBS e da CBS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

➡️ Sub-bloco: [`gIBS_Tot`](#gibs_tot) — Grupo total do IBS (0-1)

➡️ Sub-bloco: [`gCBS_Tot`](#gcbs_tot) — Grupo total da CBS (0-1)

➡️ Sub-bloco: [`gMono_Tot`](#gmono_tot) — Grupo total da Monofasia (0-1)

➡️ Sub-bloco: [`gEstornoCred`](#gestornocred-1) — Grupo total do Estorno de Crédito (0-1)

<a id="gibs_tot"></a>

###### `gIBS_Tot` — Grupo total do IBS

**Caminho:** `nota` › `total` › `IBSCBSTot` › `gIBS_Tot`  
**ID:** 355.6 · **Tipo:** Grupo · **Ocorrência:** 0-1 · **Linha na planilha:** 1210  
**Rótulo na planilha:** Total do IBS  

> Grupo Opcional.

Abertura: `--gIBS_Tot_ini--;` · Fechamento: `--gIBS_Tot_fim--;`

➡️ Sub-bloco: [`gIBSUF_Tot`](#gibsuf_tot) — Grupo total do IBS da UF (1-1)

➡️ Sub-bloco: [`gIBSMun_Tot`](#gibsmun_tot) — Grupo total do IBS do Município (1-1)

*Continuação dos campos de `gIBS_Tot` (após o fechamento de `gIBSMun_Tot`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 355.17 | `vIBS` | Valor total do IBS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.18 | `vCredPres` | Valor total do crédito presumido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.19 | `vCredPresCondSus` | Valor total do crédito presumido em condição suspensiva | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gibsuf_tot"></a>

###### `gIBSUF_Tot` — Grupo total do IBS da UF

**Caminho:** `nota` › `total` › `IBSCBSTot` › `gIBS_Tot` › `gIBSUF_Tot`  
**ID:** 355.7 · **Tipo:** Grupo · **Ocorrência:** 1-1 · **Linha na planilha:** 1211  
**Rótulo na planilha:** Total do IBS da UF  

Abertura: `--gIBSUF_Tot_ini--;` · Fechamento: `--gIBSUF_Tot_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 355.8 | `vDif` | Valor total do diferimento | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.9 | `vDevTrib` | Valor total de devolução de tributos | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.11 | `vIBSUF` | Valor total do IBS da UF | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gibsmun_tot"></a>

###### `gIBSMun_Tot` — Grupo total do IBS do Município

**Caminho:** `nota` › `total` › `IBSCBSTot` › `gIBS_Tot` › `gIBSMun_Tot`  
**ID:** 355.12 · **Tipo:** Grupo · **Ocorrência:** 1-1 · **Linha na planilha:** 1216  
**Rótulo na planilha:** Total do IBS do Município  

Abertura: `--gIBSMun_Tot_ini--;` · Fechamento: `--gIBSMun_Tot_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 355.13 | `vDif` | Valor total do diferimento | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.14 | `vDevTrib` | Valor total de devolução de tributos | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.16 | `vIBSMun` | Valor total do IBS do Município | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gcbs_tot"></a>

###### `gCBS_Tot` — Grupo total da CBS

**Caminho:** `nota` › `total` › `IBSCBSTot` › `gCBS_Tot`  
**ID:** 355.20 · **Tipo:** Grupo · **Ocorrência:** 0-1 · **Linha na planilha:** 1225  
**Rótulo na planilha:** Total da CBS  

> Grupo Opcional.

Abertura: `--gCBS_Tot_ini--;` · Fechamento: `--gCBS_Tot_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 355.23 | `vDif` | Valor total do diferimento | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.24 | `vDevTrib` | Valor total de devolução de tributos | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.26 | `vCBS` | Valor total da CBS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.26a | `vCredPres` | Valor total do crédito presumido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.26b | `vCredPresCondSus` | Valor total do crédito presumido em condição suspensiva | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gmono_tot"></a>

###### `gMono_Tot` — Grupo total da Monofasia

**Caminho:** `nota` › `total` › `IBSCBSTot` › `gMono_Tot`  
**ID:** 355.27 · **Tipo:** Grupo · **Ocorrência:** 0-1 · **Linha na planilha:** 1232  
**Rótulo na planilha:** Total da Monofasia  

> Grupo Opcional.

Abertura: `--gMono_Tot_ini--;` · Fechamento: `--gMono_Tot_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 355.28 | `vIBSMono` | Total do IBS monofásico | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.29 | `vCBSMono` | Total da CBS monofásica | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.29a | `vIBSMonoReten` | Total do IBS monofásico sujeito a retenção | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.29b | `vCBSMonoReten` | Total da CBS monofásica sujeita a retenção | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.29c | `vIBSMonoRet` | Total do IBS monofásico retido anteriormente | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.29d | `vCBSMonoRet` | Total da CBS monofásica | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="gestornocred-1"></a>

###### `gEstornoCred` — Grupo total do Estorno de Crédito

**Caminho:** `nota` › `total` › `IBSCBSTot` › `gEstornoCred`  
**ID:** 355.29e · **Tipo:** Grupo · **Ocorrência:** 0-1 · **Linha na planilha:** 1240  

> Grupo Opcional.

Abertura: `--gEstornoCred_ini--;` · Fechamento: `--gEstornoCred_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 355.29f | `vIBSEstCred` | Valor total do IBS estornado | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 355.29g | `vCBSEstCred` | Valor total da CBS estornada | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="inf_transporte"></a>

#### `inf_transporte` — Informações do Transporte da NF-e

**Caminho:** `nota` › `inf_transporte`  
**Linha na planilha:** 1248  

Abertura: `--inf_transporte_ini--;` · Fechamento: `--inf_transporte_fim--;`

➡️ Sub-bloco: [`transp`](#transp) — Grupo Informações do Transporte (1-1)

➡️ Sub-bloco: [`transporta`](#transporta) — Grupo Transportador (0-1)

➡️ Sub-bloco: [`ret_Transp`](#ret_transp) — Grupo Retenção ICMS transporte (0-1)

➡️ Sub-bloco: [`x_transp_diversos`](#x_transp_diversos) — Sequencia XML (0-1)

*Continuação dos campos de `inf_transporte` (após o fechamento de `x_transp_diversos`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 380a | `vagao` | Identificação do vagão | Caractere | 0-1 | 1-20 | — | — | — |
| 380b | `balsa` | Identificação da balsa | Caractere | 0-1 | 1-20 | — | — | — |

➡️ Sub-bloco: [`volume`](#volume) — Grupo Volumes (0-5000)

<a id="transp"></a>

##### `transp` — Grupo Informações do Transporte

**Caminho:** `nota` › `inf_transporte` › `transp`  
**ID:** 356 · **Ocorrência:** 1-1 · **Linha na planilha:** 1249  
**Rótulo na planilha:** Transporte  

Abertura: `--transp_ini--;` · Fechamento: `--transp_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 357 | `modFrete` | Modalidade do frete | Numérico | 1-1 | 1 | — | 0 - Contratação do Frete por conta do Remetente (CIF); <br>1  - Contratação do Frete por conta do Destinatário (FOB); <br>2 - Contratação do Frete por conta de Terceiros;<br>3 - Transporte Próprio por conta do Remetente;<br>4 - Transporte Próprio por conta do Destinatário;<br>9 - Sem Ocorrência de Transporte. | — |

<a id="transporta"></a>

##### `transporta` — Grupo Transportador

**Caminho:** `nota` › `inf_transporte` › `transporta`  
**ID:** 358 · **Ocorrência:** 0-1 · **Linha na planilha:** 1252  
**Rótulo na planilha:** Transportador  

Abertura: `--transporta_ini--;` · Fechamento: `--transporta_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 359 | `CNPJ` | CNPJ | Caractere | 0-1 | 14 | — | Informar o CNPJ ou o CPF do Transportador, preenchendo os zeros não significativos. | — |
| 360 | `CPF` | CPF | Numérico | 0-1 | 11 | — | — | — |
| 361 | `xNome` | Razão Social ou nome | Caractere | 0-1 | 2-60 | — | — | — |
| 362 | `IE` | Inscrição Estadual | Caractere | 0-1 | 0-14 | — | Informar:<br>- Inscrição Estadual do transportador contribuinte do ICMS, sem caracteres de formatação (ponto, barra, hífen, etc.);<br>- Literal "ISENTO" para transportador isento de inscrição no cadastro de contribuintes ICMS;<br>- Não informar a tag para não contribuinte do ICMS. A UF deve ser informada se informado uma IE. | — |
| 363 | `xEnder` | Endereço Completo | Caractere | 0-1 | 1-60 | — | — | — |
| 364 | `xMun` | Nome do Município | Caractere | 0-1 | 1-60 | — | — | — |
| 365 | `UF` | Sigla da UF | Caractere | 0-1 | 2 | — | A UF deve ser informada se informado uma IE. <br>Informar "EX" para Exterior. | — |

<a id="ret_transp"></a>

##### `ret_Transp` — Grupo Retenção ICMS transporte

**Caminho:** `nota` › `inf_transporte` › `ret_Transp`  
**ID:** 366 · **Ocorrência:** 0-1 · **Linha na planilha:** 1261  
**Rótulo na planilha:** Retenção do ICMS do Transporte  

Abertura: `--ret_Transp_ini--;` · Fechamento: `--ret_Transp_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 367 | `vServ` | Valor do Serviço | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 368 | `vBCRet` | Base de Cálculo da Retenção do ICMS | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 369 | `pICMSRet` | Alíquota da Retenção | Numérico | 1-1 | 7 | 2-4 | — | 7 posições, sendo 3 inteiros e 2 a 4 decimais |
| 370 | `vICMSRet` | Valor do ICMS Retido | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 371 | `CFOP` | CFOP | Numérico | 1-1 | 4 | — | Utilizar Tabela de CFOP. | — |
| 372 | `cMunFG` | Código do município de ocorrência do fato gerador do ICMS do transporte(IBGE) | Numérico | 1-1 | 7 | — | Informar o município de ocorrência do fato gerador do ICMS do transporte. <br>Utilizar a Tabela do IBGE (Anexo VII - Tabela de UF, Município e País) | — |

<a id="x_transp_diversos"></a>

##### `x_transp_diversos` — Sequencia XML

**Caminho:** `nota` › `inf_transporte` › `x_transp_diversos`  
**ID:** 372.1 · **Ocorrência:** 0-1 · **Linha na planilha:** 1269  
**Rótulo na planilha:** XML - Transporte por Veículo, Vagão ou Balsa  

> Transporte por Veículo, Vagão ou Balsa

Abertura: `--x_transp_diversos_ini--;` · Fechamento: `--x_transp_diversos_fim--;`

➡️ Sub-bloco: [`veic_Transp`](#veic_transp) — Grupo Veículo Transporte (0-1)

➡️ Sub-bloco: [`reboque`](#reboque) — Grupo Reboque (0-5)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="veic_transp"></a>

###### `veic_Transp` — Grupo Veículo Transporte

**Caminho:** `nota` › `inf_transporte` › `x_transp_diversos` › `veic_Transp`  
**ID:** 373 · **Ocorrência:** 0-1 · **Linha na planilha:** 1270  
**Rótulo na planilha:** Veículo  

Abertura: `--veic_Transp_ini--;` · Fechamento: `--veic_Transp_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 374 | `placa` | Placa do Veículo | Caractere | 1-1 | 7 | — | — | — |
| 375 | `UF` | Sigla da UF | Caractere | 0-1 | 2 | — | Informar "EX" se Exterior. | — |
| 376 | `RNTC` | Registro Nacional de Transportador de Carga (ANTT) | Caractere | 0-1 | 1-20 | — | — | — |

<a id="reboque"></a>

###### `reboque` — Grupo Reboque

**Caminho:** `nota` › `inf_transporte` › `x_transp_diversos` › `reboque`  
**ID:** 377 · **Ocorrência:** 0-5 · **Linha na planilha:** 1275  
**Rótulo na planilha:** Reboque  

> Informar os reboques/Dolly

Abertura: `--reboque_ini--;` · Fechamento: `--reboque_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 378 | `placa` | Placa do Veículo | Caractere | 1-1 | 7 | — | — | — |
| 379 | `UF` | Sigla da UF | Caractere | 0-1 | 2 | — | Informar "EX" se Exterior. | — |
| 380 | `RNTC` | Registro Nacional de Transportador de Carga (ANTT) | Caractere | 0-1 | 1-20 | — | — | — |

<a id="volume"></a>

##### `volume` — Grupo Volumes

**Caminho:** `nota` › `inf_transporte` › `volume`  
**ID:** 381 · **Ocorrência:** 0-5000 · **Linha na planilha:** 1283  
**Rótulo na planilha:** Volumes  

> (NT 2012/003)

Abertura: `--volume_ini--;` · Fechamento: `--volume_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 382 | `qVol` | Quantidade de Volume | Numérico | 0-1 | 1-15 | — | — | — |
| 383 | `esp` | Espécie dos volumes transportados | Caractere | 0-1 | 1-60 | — | — | — |
| 384 | `marca` | Marca dos volumes transportados | Caractere | 0-1 | 1-60 | — | — | — |
| 385 | `nVol` | Numeração dos volumes transportados | Caractere | 0-1 | 1-60 | — | — | — |
| 386 | `pesoL` | Peso Líquido(em Kg) | Numérico | 0-1 | 15 | 3 | — | 15 posições, sendo 12 inteiros e 3 decimais |
| 387 | `pesoB` | Peso Bruto(em Kg) | Numérico | 0-1 | 15 | 3 | — | 15 posições, sendo 12 inteiros e 3 decimais |

➡️ Sub-bloco: [`lacre`](#lacre) — Grupo Lacre (0-5000)

<a id="lacre"></a>

###### `lacre` — Grupo Lacre

**Caminho:** `nota` › `inf_transporte` › `volume` › `lacre`  
**ID:** 387a · **Ocorrência:** 0-5000 · **Linha na planilha:** 1290  
**Rótulo na planilha:** Lacres  

> (NT 2012/003)

Abertura: `--lacre_ini--;` · Fechamento: `--lacre_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 388 | `nLacre` | Número de Lacres | Caractere | 1-1 | 1-60 | — | — | — |

<a id="cobr"></a>

#### `cobr` — Grupo Cobrança

**Caminho:** `nota` › `cobr`  
**ID:** 389 · **Ocorrência:** 0-1 · **Linha na planilha:** 1295  
**Rótulo na planilha:** Dados de Cobrança  

> (NT 2012/003)

Abertura: `--cobr_ini--;` · Fechamento: `--cobr_fim--;`

➡️ Sub-bloco: [`fat`](#fat) — Grupo Fatura (0-1)

➡️ Sub-bloco: [`duplicata`](#duplicata) — Grupo Parcelas (0-120)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="fat"></a>

##### `fat` — Grupo Fatura

**Caminho:** `nota` › `cobr` › `fat`  
**ID:** 390 · **Ocorrência:** 0-1 · **Linha na planilha:** 1296  
**Rótulo na planilha:** Fatura  

Abertura: `--fat_ini--;` · Fechamento: `--fat_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 391 | `nFat` | Número da Fatura | Caractere | 0-1 | 1-60 | — | — | — |
| 392 | `vOrig` | Valor Original da Fatura | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 393 | `vDesc` | Valor do desconto | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 394 | `vLiq` | Valor Líquido da Fatura | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="duplicata"></a>

##### `duplicata` — Grupo Parcelas

**Caminho:** `nota` › `cobr` › `duplicata`  
**ID:** 395 · **Ocorrência:** 0-120 · **Linha na planilha:** 1302  
**Rótulo na planilha:** Duplicatas  

> (NT 2011/004)

Abertura: `--duplicata_ini--;` · Fechamento: `--duplicata_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 396 | `nDup` | Número da Parcela | Caractere | 0-1 | 1-60 | — | Obrigatória informação do número de parcelas com 3 algarismos, sequenciais e consecutivos. Ex.: "001", "002", "003",...<br>Obs.: este padrão de preenchimento será obrigatório somente a partir de 03/09/2018. | — |
| 397 | `dVenc` | Data de vencimento | Data | 0-1 | — | — | Formato: “AAAA-MM-DD”. <br>Obrigatória a informação da data de vencimento na ordem crescente das datas. Ex.: “2018-06-01”,”2018-07-01”, “2018-08-01”,... | — |
| 398 | `vDup` | Valor da Parcela | Numérico | 1-1 | 15 | 2 | (NT 2012/003) | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="pag"></a>

#### `pag` — Grupo de Formas de Pagamento

**Caminho:** `nota` › `pag`  
**ID:** 398a · **Ocorrência:** 1-1 · **Linha na planilha:** 1308  
**Rótulo na planilha:** Formas de Pagamento  

> A critério de cada UF poderá ser exigido o preenchimento do Grupo de Informações de Pagamento para NF-e e/ou NFC-e.

Abertura: `--pag_ini--;` · Fechamento: `--pag_fim--;`

➡️ Sub-bloco: [`detPag`](#detpag) — Grupo Detalhamento do Pagamento (1-100)

*Continuação dos campos de `pag` (após o fechamento de `detPag`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 398i | `vTroco` | Valor do troco | Numérico | 0-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="detpag"></a>

##### `detPag` — Grupo Detalhamento do Pagamento

**Caminho:** `nota` › `pag` › `detPag`  
**ID:** 398a1 · **Ocorrência:** 1-100 · **Linha na planilha:** 1309  

Abertura: `--detPag_ini--;` · Fechamento: `--detPag_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 398a2 | `indPag` | Indicador da forma de Pagamento | Numérico | 0-1 | 1 | — | 0 - Pagamento à vista<br>1  - Pagamento à Prazo | — |
| 398b | `tPag` | Meio de pagamento | Numérico | 1-1 | 2 | — | Utilizar a Tabela de códigos dos meios de pagamentos publicada no Portal Nacional da Nota Fiscal Eletrônica. | Na versão 1.50 da NT 2016.002 foi divulgada a retirada da opção "14-Duplicata Mercantil", entretanto ainda está disponível no schema da SEFAZ. |
| 398c | `vPag` | Valor do Pagamento | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |
| 398b1 | `xPag` | Descrição do Meio de Pagamento | Caractere | 0-1 | 2-60 | — | Preencher informando o meio de pagamento utilizado quando o código do meio de pagamento for informado como 99-outros.<br>Observar regras do campo e vigência na NT 2020.006. | — |
| 398b2 | `dPag` | Data do Pagamento | Data | 0-1 | 19 | — | — | — |

➡️ Sub-bloco: [`sequencia_XML_detPag`](#sequencia_xml_detpag) — Sequência XML (0-1)

➡️ Sub-bloco: [`card`](#card) — Grupo de Cartões, PIX, Boletos e outros Pagamentos Eletrônicos (0-1)

<a id="sequencia_xml_detpag"></a>

###### `sequencia_XML_detPag` — Sequência XML

**Caminho:** `nota` › `pag` › `detPag` › `sequencia_XML_detPag`  
**ID:** 398.13b · **Ocorrência:** 0-1 · **Linha na planilha:** 1315  
**Rótulo na planilha:** Cartões  

> Grupo Opcional.

Abertura: `--sequencia_XML_detPag_ini--;` · Fechamento: `--sequencia_XML_detPag_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 398.13c | `CNPJPag` | CNPJ transacional do pagamento | Caractere | 1-1 | 14 | — | Preencher informando o CNPJ do estabelecimento onde o pagamento foi processado/transacionado/recebido quando a emissão do documento fiscal ocorrer em estabelecimento distinto. | — |
| 398.13d | `UFPag` | UF do CNPJ do estabelecimento onde o pagamento foi processado/transacionado/recebido | Caractere | 1-1 | 2 | — | UF do CNPJ do estabelecimento onde o pagamento foi processado/transacionado/recebido. | — |

<a id="card"></a>

###### `card` — Grupo de Cartões, PIX, Boletos e outros Pagamentos Eletrônicos

**Caminho:** `nota` › `pag` › `detPag` › `card`  
**ID:** 398d · **Ocorrência:** 0-1 · **Linha na planilha:** 1319  
**Rótulo na planilha:** Cartões  

Abertura: `--card_ini--;` · Fechamento: `--card_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 398d.1 | `tpIntegra` | Tipo de Integração para pagamento | Numérico | 1-1 | 1 | — | Tipo de Integração do processo de pagamento com o sistema de automação da empresa:<br>1- Pagamento integrado com o sistema de automação da empresa (Ex.: equipamento TEF, Comércio Eletrônico);<br>2- Pagamento não integrado com sistema de automação da empresa (Ex.: equipamento POS). | — |
| 398e | `CNPJ` | CNPJ da instituição de pagamento | Caractere | 0-1 | 14 | — | Informar o CNPJ da instituição de pagamento, adquirente<br>ou subadquirente. Caso o pagamento seja<br>processado pelo intermediador da transação,<br>informar o CNPJ deste | — |
| 398f | `tBand` | Bandeira da operadora de cartão de crédito e/ou débito | Numérico | 0-1 | 2 | — | Utilizar a Tabela de Códigos das Operadoras de cartão de crédito e/ou débito publicada no Portal Nacional da Nota Fiscal Eletrônica. | — |
| 398g | `cAut` | Número de autorização da operação cartão de crédito e/ou débito | Caractere | 0-1 | 1-128 | — | Identifica o número da autorização da transação da operação com cartão de crédito e/ou débito | — |
| 398d.2 | `CNPJReceb` | CNPJ do beneficiário do pagamento | Caractere | 0-1 | 14 | — | Informar o CNPJ do estabelecimento beneficiário do pagamento | — |
| 398d.3 | `idTermpag` | Identificador do terminal de pagamento | Caractere | 0-1 | 40 | — | Identificar o terminal em que foi realizado o pagamento | — |

<a id="infintermed"></a>

#### `infIntermed` — Grupo de Informações do Intermediador da Transação

**Caminho:** `nota` › `infIntermed`  
**ID:** 398j · **Ocorrência:** 0-1 · **Linha na planilha:** 1330  
**Rótulo na planilha:** Informações do Intermediador da Transação  

> Observar regras da NT 2020.006.

Abertura: `--infIntermed_ini--;` · Fechamento: `--infIntermed_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 398k | `CNPJ` | CNPJ do Intermediador da Transação (agenciador, plataforma de delivery, marketplace e similar) de serviços e de negócios. | Caractere | 1-1 | 14 | — | Informar o CNPJ do Intermediador da Transação (agenciador, plataforma de delivery, marketplace e similar) de serviços e de negócios. | — |
| 398l | `idCadIntTran` | Identificador cadastrado no intermediador | Caractere | 1-1 | 2-60 | — | Nome do usuário ou identificação do perfil do vendedor no site do intermediador (agenciador, plataforma de delivery, marketplace e similar) de serviços e de negócios. | — |

<a id="gpgtovinc"></a>

#### `gPgtoVinc` — Grupo de informações da Vinculação com a Transação de Pagamento (YC01) 🆕

**Caminho:** `nota` › `gPgtoVinc`  
**ID:** 398.50 · **Ocorrência:** 0-1 · **Linha na planilha:** 1334  
**Rótulo na planilha:** Vinculação Pagamento  

> Informar sempre que a transação de pagamento for iniciada antes da emissão do DF-e (ex.: boleto gerado antes da emissão; QR Code dinâmico Pix gerado antes da emissão), ainda que a transação esteja pendente de pagamento e liquidação. Campos de caráter preparatório: não há exigência de preenchimento em produção em 2026; a ativação ocorrerá com a entrada em vigência do split payment, prevista para 2027. O preenchimento deste grupo não exclui a obrigação dos grupos Formas de Pagamento (YA) e Informações do Intermediador da Transação (YB). (Incluído na NT 2026.006)

Abertura: `--gPgtoVinc_ini--;` · Fechamento: `--gPgtoVinc_fim--;`

➡️ Sub-bloco: [`gPgto`](#gpgto) — Dados de cada pagamento previsto para o DF-e (YC02) (1-99)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="gpgto"></a>

##### `gPgto` — Dados de cada pagamento previsto para o DF-e (YC02) 🆕

**Caminho:** `nota` › `gPgtoVinc` › `gPgto`  
**ID:** 398.51 · **Ocorrência:** 1-99 · **Linha na planilha:** 1335  
**Rótulo na planilha:** Pagamentos vinculados  

> Cada ocorrência representa uma transação financeira vinculada ao documento. (Incluído na NT 2026.006)

Abertura: `--gPgto_ini--;` · Fechamento: `--gPgto_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 398.52 | `nPag` 🆕 | Número sequencial do pagamento (YC03) | Numérico | 1-1 | 3 | — | Atributo numerador único de cada ocorrência de pagamento. O schema impede valores duplicados (rejeição 215 - falha no esquema XML). (Incluído na NT 2026.006) | 3 posições |
| 398.53 | `idTransacao` 🆕 | Identificador da transação financeira (YC04) | Caractere | 1-1 | 2-35 | — | Identificador da transação financeira, de acordo com a transação de pagamento. O schema impede valores duplicados (rejeição 215 - falha no esquema XML). (Incluído na NT 2026.006) | — |
| 398.54 | `tpMeioPgto` 🆕 | Código do meio de pagamento (YC05) | Numérico | 1-1 | 2 | — | Informar o código conforme a Tabela Nacional de Códigos de Meios de Pagamento (Informe Técnico 2026.001 dos DF-e), com 2 posições (ex.: 01). Código inválido gera a rejeição 1273. (Incluído na NT 2026.006) | 2 posições |
| 398.55 | `CNPJReceb` 🆕 | CNPJ do recebedor do pagamento (YC06) | Caractere | 1-1 | 14 | — | CNPJ completo do recebedor do pagamento (fornecedor, plataforma ou outra entidade que receba o pagamento do adquirente). Pode ser diferente do CNPJ do fornecedor do documento fiscal. Informar zeros não significativos. CNPJ inválido gera a rejeição 1274. (Incluído na NT 2026.006) | — |
| 398.56 | `CNPJBasePSP` 🆕 | CNPJ base da instituição financeira ou de pagamento (YC07) | Caractere | 1-1 | 8 | — | CNPJ base (8 posições) da instituição financeira ou de pagamento utilizada pelo recebedor do pagamento. Informar zeros não significativos. (Incluído na NT 2026.006) | — |

<a id="inf_adic"></a>

#### `inf_Adic` — Grupo de Informações Adicionais

**Caminho:** `nota` › `inf_Adic`  
**ID:** 399 · **Ocorrência:** 0-1 · **Linha na planilha:** 1343  
**Rótulo na planilha:** Informações Adicionais  

Abertura: `--inf_Adic_ini--;` · Fechamento: `--inf_Adic_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 400 | `infAdFisco` | Informações Adicionais de Interesse do Fisco | Caractere | 0-1 | 1-2000 | — | — | Alteração no tamanho do campo de 256 para variável de 1-2000. |
| 401 | `infCpl` | Informações Complementares de Interesse do Contribuinte | Caractere | 0-1 | 1-5000 | — | — | — |

➡️ Sub-bloco: [`uso_livre_c`](#uso_livre_c) — Grupo Campo de uso livre do Contribuinte (0-10)

➡️ Sub-bloco: [`uso_livre_f`](#uso_livre_f) — Grupo Campo de uso livre do Fisco (0-10)

➡️ Sub-bloco: [`proc_referenciado`](#proc_referenciado) — Grupo Processo referenciado (0-100)

<a id="uso_livre_c"></a>

##### `uso_livre_c` — Grupo Campo de uso livre do Contribuinte

**Caminho:** `nota` › `inf_Adic` › `uso_livre_c`  
**ID:** 401a · **Ocorrência:** 0-10 · **Linha na planilha:** 1346  
**Rótulo na planilha:** Inf. de Uso Livre do Contribuinte  

Abertura: `--uso_livre_c_ini--;` · Fechamento: `--uso_livre_c_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 401b | `xCampo` | Identificação do campo | Caractere | 1-1 | 1-20 | — | — | — |
| 401c | `xTexto` | Conteúdo do Campo | Caractere | 1-1 | 1-60 | — | — | — |

<a id="uso_livre_f"></a>

##### `uso_livre_f` — Grupo Campo de uso livre do Fisco

**Caminho:** `nota` › `inf_Adic` › `uso_livre_f`  
**ID:** 401d · **Ocorrência:** 0-10 · **Linha na planilha:** 1350  
**Rótulo na planilha:** Inf. de Uso Livre do Fisco  

Abertura: `--uso_livre_f_ini--;` · Fechamento: `--uso_livre_f_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 401e | `xCampo` | Identificação do campo | Caractere | 1-1 | 1-20 | — | — | — |
| 401f | `xTexto` | Conteúdo do Campo | Caractere | 1-1 | 1-60 | — | — | — |

<a id="proc_referenciado"></a>

##### `proc_referenciado` — Grupo Processo referenciado

**Caminho:** `nota` › `inf_Adic` › `proc_referenciado`  
**ID:** 401g · **Ocorrência:** 0-100 · **Linha na planilha:** 1354  
**Rótulo na planilha:** Processo Referenciado  

> (NT 2012/003)

Abertura: `--proc_referenciado_ini--;` · Fechamento: `--proc_referenciado_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 401h | `nProc` | Identificador do processo ou ato concessório | Caractere | 1-1 | 1-60 | — | — | — |
| 401i | `indProc` | Indicador da origem do processo | Numérico | 1-1 | 1 | — | Origem do processo, informar com: <br>0 - SEFAZ;<br>1 - Justiça Federal;<br>2 - Justiça Estadual;<br>3 - Secex/RFB;<br>4 - CONFAZ<br>9 - Outros. | — |
| 401j | `tpAto` | Tipo do ato concessório | Numérico | 0-1 | 2 | — | Para origem do Processo na SEFAZ (indProc=0), informar o<br>tipo de ato concessório:<br>08 - Termo de Acordo;<br>10 - Regime Especial;<br>12 - Autorização específica;<br>14=Ajuste SINIEF; <br>15=Convênio ICMS | — |

<a id="exporta"></a>

#### `exporta` — Grupo Exportação

**Caminho:** `nota` › `exporta`  
**ID:** 402 · **Ocorrência:** 0-1 · **Linha na planilha:** 1360  
**Rótulo na planilha:** Informações de Comércio Exterior  

> Informar apenas a exportação

Abertura: `--exporta_ini--;` · Fechamento: `--exporta_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 403 | `UFSaidaPais` | Sigla da UF de Embarque ou transposição de fronteira | Caractere | 1-1 | 2 | — | Não aceita o valor "EX". | — |
| 404 | `xLocExporta` | Descrição do Local de Embarque ou de transposição de fronteira | Caractere | 1-1 | 1-60 | — | — | — |
| 404a | `xLocDespacho` | Descrição do local de despacho | Caractere | 0-1 | 1-60 | — | Informação do Recinto Alfandegado | — |

<a id="compra"></a>

#### `compra` — Grupo Compra

**Caminho:** `nota` › `compra`  
**ID:** 405 · **Ocorrência:** 0-1 · **Linha na planilha:** 1365  
**Rótulo na planilha:** Informações de Compras  

> Informação adicional de compra

Abertura: `--compra_ini--;` · Fechamento: `--compra_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 406 | `xNEmp` | Nota de Empenho | Caractere | 0-1 | 1-22 | — | Identificação da Nota de Empenho, quando se tratar de compras públicas | — |
| 407 | `xPed` | Pedido | Caractere | 0-1 | 1-60 | — | — | — |
| 408 | `xCont` | Contrato de compra | Caractere | 0-1 | 1-60 | — | — | — |

<a id="cana"></a>

#### `cana` — Grupo Cana

**Caminho:** `nota` › `cana`  
**ID:** 409 · **Ocorrência:** 0-1 · **Linha na planilha:** 1370  
**Rótulo na planilha:** Registro Aquisição de Cana  

> Informações de Registro de Aquisição de Cana

Abertura: `--cana_ini--;` · Fechamento: `--cana_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 410 | `safra` | Identificação da safra | Caractere | 1-1 | 4-9 | — | Informar a safra, no formato "AAAA" ou "AAAA/AAAA" | — |
| 411 | `ref` | Mês e ano  de referencia | Caractere | 1-1 | 7 | — | Informar o mês e ano de referência, no formato "MM/AAAA". | — |

➡️ Sub-bloco: [`cana_forn_diario`](#cana_forn_diario) — Grupo Fornecimento diário de cana (1-31)

*Continuação dos campos de `cana` (após o fechamento de `cana_forn_diario`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 415 | `qTotMes` | Quantidade total do mês | Numérico | 1-1 | 21 | 10 | — | 21 posições, sendo 11 inteiros e 10 decimais |
| 416 | `qTotAnt` | Quantidade total anterior | Numérico | 1-1 | 21 | 10 | — | 21 posições, sendo 11 inteiros e 10 decimais |
| 417 | `qTotGer` | Quantidade total geral | Numérico | 1-1 | 21 | 10 | — | 21 posições, sendo 11 inteiros e 10 decimais |

➡️ Sub-bloco: [`cana_deducao`](#cana_deducao) — Grupo Deduções - Taxas e Contribuições (0-10)

*Continuação dos campos de `cana` (após o fechamento de `cana_deducao`):*

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 421 | `vFor` | Valor dos fornecimentos | Numérico | 1-1 | 15 | 2 | Valor dos Fornecimentos | 15 posições, sendo 13 inteiros e 2 decimais |
| 422 | `vTotDed` | valor total da dedução | Numérico | 1-1 | 15 | 2 | Valor das deduções | 15 posições, sendo 13 inteiros e 2 decimais |
| 423 | `vLiqFor` | Valor liquido dos fornecimentos | Numérico | 1-1 | 15 | 2 | Valor Líquido dos Fornecimentos | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="cana_forn_diario"></a>

##### `cana_forn_diario` — Grupo Fornecimento diário de cana

**Caminho:** `nota` › `cana` › `cana_forn_diario`  
**ID:** 412 · **Ocorrência:** 1-31 · **Linha na planilha:** 1373  
**Rótulo na planilha:** Fornec. diário de cana  

> Informar os fornecimentos diários de cana

Abertura: `--cana_forn_diario_ini--;` · Fechamento: `--cana_forn_diario_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 427 | `dia` | Dia | Numérico | 1-1 | 1-2 | — | — | — |
| 414 | `qtde` | Quantidade | Numérico | 1-1 | 21 | 10 | Quantidade em KG | 21 posições, sendo 11 inteiros e 10 decimais |

<a id="cana_deducao"></a>

##### `cana_deducao` — Grupo Deduções - Taxas e Contribuições

**Caminho:** `nota` › `cana` › `cana_deducao`  
**ID:** 418 · **Ocorrência:** 0-10 · **Linha na planilha:** 1380  
**Rótulo na planilha:** Deduções - Taxas e Contribuições  

> Informar as Deduções - Taxas e Contribuições

Abertura: `--cana_deducao_ini--;` · Fechamento: `--cana_deducao_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 419 | `xDed` | Descrição da dedução | Caractere | 1-1 | 1-60 | — | Informar a Descrição da Dedução | — |
| 420 | `vDed` | valor da dedução | Numérico | 1-1 | 15 | 2 | — | 15 posições, sendo 13 inteiros e 2 decimais |

<a id="infresptec"></a>

#### `infRespTec` — Informações do Responsável Técnico pelo sistema de emissão do Documento Fiscal eletrônico.

**Caminho:** `nota` › `infRespTec`  
**ID:** 423a · **Tipo:** Grupo · **Ocorrência:** 0-1 · **Linha na planilha:** 1388  
**Rótulo na planilha:** Responsável Técnico  

> Preencher caso desejar informar um Responsável Técnico que não seja da Thomson Reuters. Somente são considerados esses dados em integração TXT via integrador. Para informar via POST, é necessário mandar o grupo resptec dentro do grupo mastersaf no JSON.

Abertura: `--infRespTec_ini--;` · Fechamento: `--infRespTec_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 423b | `CNPJ` | CNPJ da pessoa jurídica responsável pelo sistema utilizado na emissão do documento fiscal eletrônico. | Caractere | 1-1 | 14 | — | Informar o CNPJ da pessoa jurídica responsável pelo sistema utilizado na emissão do documento fiscal eletrônico. | — |
| 423c | `xContato` | Nome da pessoa a ser contatada | Caractere | 1-1 | 2-60 | — | Informar o nome da pessoa a ser contatada na empresa desenvolvedora do sistema utilizado na emissão do documento fiscal eletrônico. | — |
| 423d | `email` | E-mail da pessoa jurídica/física a ser contatada | Caractere | 1-1 | 6-60 | — | Informar o e-mail da pessoa a ser contatada na empresa desenvolvedora do sistema. | — |
| 423e | `fone` | Telefone da pessoa jurídica/física a ser contatada | Numérico | 1-1 | 6-14 | — | Informar o telefone da pessoa a ser contatada na empresa desenvolvedora do sistema. Preencher com o Código DDD + número do telefone. | — |

➡️ Sub-bloco: [`seq_XML`](#seq_xml) — Grupo de informações do Código de Segurança do Responsável Técnico - CSRT (0-1)

<a id="seq_xml"></a>

##### `seq_XML` — Grupo de informações do Código de Segurança do Responsável Técnico - CSRT

**Caminho:** `nota` › `infRespTec` › `seq_XML`  
**ID:** 423f · **Tipo:** Grupo · **Ocorrência:** 0-1 · **Linha na planilha:** 1393  
**Rótulo na planilha:** Dados CSRT  

> Informar os dados obtidos no Cadastro de Responável Técnico na SEFAZ. A exigência deste campo fica a critério de cada UF.

Abertura: `--seq_XML_ini--;` · Fechamento: `--seq_XML_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 423g | `idCSRT` | Identificador do código de segurança do responsável técnico | Numérico | 1-1 | 2 | — | Identificador do CSRT utilizado para geração do hash | — |
| 423h | `CSRT` | Código de Segurança do Responsável Técnico | Caractere | 1-1 | 28 | — | CSRT utilizado para geração do hash | — |

<a id="agropecuario"></a>

#### `agropecuario` — Informações de produtos da agricultura, pecuária e produção Florestal

**Caminho:** `nota` › `agropecuario`  
**ID:** 424 · **Tipo:** Grupo · **Ocorrência:** 0-1 · **Linha na planilha:** 1398  
**Rótulo na planilha:** Produtos da agricultura, pecuária e produção Florestal  

Abertura: `--agropecuario_ini--;` · Fechamento: `--agropecuario_fim--;`

➡️ Sub-bloco: [`defensivo`](#defensivo) — Defensivos Agrícolas (1-20)

➡️ Sub-bloco: [`guiaTransito`](#guiatransito) — Guia de Trânsito (1-1)

*Bloco sem campos diretos (apenas sub-blocos).*

<a id="defensivo"></a>

##### `defensivo` — Defensivos Agrícolas

**Caminho:** `nota` › `agropecuario` › `defensivo`  
**ID:** 424a · **Tipo:** CG · **Ocorrência:** 1-20 · **Linha na planilha:** 1399  
**Rótulo na planilha:** Dados CSRT  

> CG – Choice Group (escolha entre grupos), ou esse ou guiaTransito.

Abertura: `--defensivo_ini--;` · Fechamento: `--defensivo_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 424b | `nReceituario` | Número da receita ou receituário do agrotóxico / defensivo agrícola. | Caractere | 1-1 | 1-30 | — | Informar o número da receita ou receituário de aplicação do defensivo. | — |
| 424c | `CPFRespTec` | CPF do Responsável Técnico, emitente do receituário | Numérico | 1-1 | 11 | — | Informar o CPF do Responsável Técnico legalmente habilitado, como engenheiro agrônomo, engenheiro florestal e técnico agrícola. | — |

<a id="guiatransito"></a>

##### `guiaTransito` — Guia de Trânsito

**Caminho:** `nota` › `agropecuario` › `guiaTransito`  
**ID:** 424d · **Tipo:** CG · **Ocorrência:** 1-1 · **Linha na planilha:** 1403  
**Rótulo na planilha:** Dados CSRT  

> CG – Choice Group (escolha entre grupos), ou esse ou defensivo.

Abertura: `--guiaTransito_ini--;` · Fechamento: `--guiaTransito_fim--;`

| ID | Campo | Descrição | Tipo | Ocor | Tam. | Dec. | Observação | Obs. integração |
|---|---|---|---|---|---|---|---|---|
| 424e | `tpGuia` | Tipo da Guia | Numérico | 1-1 | 1 | — | 1 - GTA - Guia de Trânsito Animal; 2 - TTA - Termo de<br>Trânsito Animal; 3 - DTA - Documento de Transferência<br>Animal; 4 - ATV - Autorização de Trânsito Vegetal; 5 -<br>PTV - Permissão de Trânsito Vegetal; 6 - GTV - Guia de<br>Trânsito Vegetal; 7 - Guia Florestal (DOF, SisFlora - PA e<br>MT ou SIAM - MG). | — |
| 424f | `UFGuia` | UF de emissão | Caractere | 1-1 | 2 | — | UF de emissão da guia | — |
| 424g | `serieGuia` | Série da Guia | Caractere | 0-1 | 1-9 | — | Informar sempre que houver a série da guia | — |
| 424h | `nGuia` | Número da Guia | Numérico | 1-1 | 1-9 | — | Número da Guia | — |

## Campos novos na 4.19 (lista rápida)

Itens destacados em amarelo na planilha (alterações de 03/11/2026 — NT 2026.008 e NT 2026.006). A reformulação da tributação monofásica (gIBSMonoAdRem, gIBSMonoAdValorem, gCBSMonoAdRem, gCBSMonoAdValorem) de 22/09/2026 não está destacada na planilha; consulte a seção [Novidades da versão 4.19](#novidades-da-versao-419).

| Bloco | ID | Campo | Descrição | Tipo | Ocor |
|---|---|---|---|---|---|
| [`sequencia_XML_liq`](#sequencia_xml_liq) | 110.01 | *(bloco)* | Sequência XML | — | 0-1 |
| [`sequencia_XML_liq`](#sequencia_xml_liq) | 110.02 | `vUnComLiq` | Valor Líquido Unitário do Produto ou Serviço (sem tributos) | Numérico | 1-1 |
| [`sequencia_XML_liq`](#sequencia_xml_liq) | 110.03 | `vProdLiq` | Valor Líquido do Produto ou Serviço (sem tributos) | Numérico | 1-1 |
| [`ICMS_Previsto`](#icms_previsto) | 245b.01 | *(bloco)* | Grupo do ICMS Previsto no Pagamento Antecipado | — | 0-1 |
| [`ICMS_Previsto`](#icms_previsto) | 245b.02 | `vICMSPrevisto` | Valor do ICMS Previsto | Numérico | 1-1 |
| [`total`](#total) | 326a | `vProdLiqTot` | Valor Total Líquido dos Produtos ou Serviços (sem tributos) | Numérico | 0-1 |
| [`gPgtoVinc`](#gpgtovinc) | 398.50 | *(bloco)* | Grupo de informações da Vinculação com a Transação de Pagamento (YC01) | — | 0-1 |
| [`gPgto`](#gpgto) | 398.51 | *(bloco)* | Dados de cada pagamento previsto para o DF-e (YC02) | — | 1-99 |
| [`gPgto`](#gpgto) | 398.52 | `nPag` | Número sequencial do pagamento (YC03) | Numérico | 1-1 |
| [`gPgto`](#gpgto) | 398.53 | `idTransacao` | Identificador da transação financeira (YC04) | Caractere | 1-1 |
| [`gPgto`](#gpgto) | 398.54 | `tpMeioPgto` | Código do meio de pagamento (YC05) | Numérico | 1-1 |
| [`gPgto`](#gpgto) | 398.55 | `CNPJReceb` | CNPJ do recebedor do pagamento (YC06) | Caractere | 1-1 |
| [`gPgto`](#gpgto) | 398.56 | `CNPJBasePSP` | CNPJ base da instituição financeira ou de pagamento (YC07) | Caractere | 1-1 |

---
*Documento gerado automaticamente a partir da planilha de layout; em caso de divergência, prevalece a planilha oficial e as Notas Técnicas da SEFAZ.*
