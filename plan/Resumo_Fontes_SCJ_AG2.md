# Resumo dos Fontes — Integração SAP SC Johnson (AG2)

| Item | Valor |
|---|---|
| Projeto | SC Johnson / DHL — NF-e 2027 (IBS, CBS, IS) |
| Unidade de negócio | AG2 (SC Johnson) |
| Data | 22/11/2026 |
| Responsável | Wellington Santana |
| Documentos relacionados | `Diagnostico_Consolidado_NFe_2027_SCJ.md`, `Diagnostico_RTC_Lote1_Cadastros.md`, `Diagnostico_RTC_Lotes2a4_Integracao.md`, `Dicionario_RTC_Lotes1a4.md` |

---

## 1. Resumo em 10 pontos

Os fontes integram o SAP da SC Johnson com o Protheus, na unidade AG2, nos dois sentidos, e estão sendo adaptados para a Reforma Tributária (IBS/CBS).

1. **SAPIP040, DHLIp040Sap, PrcNfRco e PrcGrvRco** recebem a interface IP_040 do SAP, gravam SZA/SZB e emitem a NF de remessa por conta e ordem (RCO).
2. **CadRegFis (SZC)** guarda as regras que escolhem a TES (e, com ela, o CFOP) da NF RCO a partir dos indicadores de ICMS enviados pelo SAP.
3. **CadDePara (SZD)** define quais valores de imposto do SAP substituem os calculados pelo Protheus em SF2, SD2, SFT, SB1, CD2 e SF3.
4. **SAPIP150, SAPIP160, SAPIP190, DHLIp150, PrcNfRet e PrcGrvRet** tratam o retorno simbólico (RET), a exclusão de notas e as confirmações de recebimento enviadas ao SAP.
5. **updImpCD2**, chamado pelo MT103FIM, copia o FCP e a unidade/quantidade tributável da nota original para a devolução ou nota de crédito.
6. **PrcXmlNfe** chama o `XmlNfeSef` (nfesefaz), gera o XML da NF-e e o entrega ao `ProcMsaNFe`, que monta o arquivo enviado ao Mastersaf para autorização na SEFAZ.
7. **PrcRCOXml, ProcRCOMsa e MsafRCOFile** transformam o XML da NF RCO no arquivo posicional IP140 enviado ao SAP.
8. **PrcXmlRSymb, ProcRSymbMsa e MsafRSymbFile** fazem o mesmo para o retorno simbólico, gerando o arquivo IP050.
9. **M460FIM_pe** é o ponto de entrada do fim do faturamento. Na AG2, executa o `PrcGrvRet`, grava a mensagem da nota de ajuste fiscal e, por último, chama o `PrcXmlNfe`.
10. **Finalidade:** manter o fiscal do Protheus igual ao do SAP e devolver ao SAP arquivos que batam com a nota autorizada pela SEFAZ, agora incluindo IBS, CBS, crédito, débito e ajuste de 2027.

---

## 2. Fluxo

```
SAP ──IP_040──► SAPIP040 / DHLIp040Sap ──► SZA/SZB
                    │  TES ◄── SZC (CadRegFis)
                    │  impostos ◄── SZD (CadDePara)
                    ▼
            PrcNfRco / PrcGrvRco ──► NF RCO (SF2/SD2)
                    │
                    ▼
            M460FIM ──► PrcXmlNfe ──► XmlNfeSef (nfesefaz) ──► ProcMsaNFe ──► Mastersaf ──► SEFAZ
                                                                                   │
                       ImpMsaNfe / MonIp040 (após autorização) ◄────────────────────┘
                          │
                          ├─ RCO (F2_ZZTPNF = RCO) ──► PrcRCOXml ──► ProcRCOMsa ──► MsafRCOFile ──► IP140 ──► SAP
                          └─ RET (F2_ZZTPNF = 4)   ──► PrcXmlRSymb ──► ProcRSymbMsa ──► MsafRSymbFile ──► IP050 ──► SAP

Devolução / crédito (MATA103) ──► MT103FIM ──► updImpCD2 ──► CD2 / SFT / SD1
```

---

## 3. Fontes por bloco

| Bloco | Fonte | Papel |
|---|---|---|
| Entrada SAP → Protheus | `SAP/SCJ/SAPIP040.prw` | Leitura da interface IP_040 e gravação de SZA/SZB |
| | `SAP/SCJ/Classes/DHLIp040Sap.prw` | Regras do IP_040: TES via SZC (`fQryTes`), de/para via SZD (`validValues`) |
| | `SAP/SCJ/PrcNfRco.prw`, `PrcGrvRco.prw` | Geração e gravação da NF de remessa por conta e ordem |
| | `SAP/SCJ/PrcNfRet.prw`, `PrcGrvRet.prw` | Geração e gravação do retorno simbólico |
| | `SAP/SCJ/SAPIP150.prw`, `SAPIP160.prw`, `SAPIP190.prw`, `Classes/DHLIp150.prw` | Exclusão de notas e confirmações para o SAP |
| Cadastros | `SAP/SCJ/Cadastro de Regras Fiscais/CadRegFis.prw` | MVC da SZC (regras de TES) |
| | `SAP/SCJ/Cadastro de Para CPOS Fiscal/CadDePara.prw` | MVC da SZD (de/para de campos fiscais) |
| Devolução / crédito | `SAP/SCJ/updImpCD2.prw` | Propaga FCP e UTRIB/QTRIB da NF original (chamado pelo `MT103FIM`) |
| NF-e → Mastersaf | `Mastersaf_NFe/PrcXmlNfe.prw` | Gera o XML (`XmlNfeSef`) e chama o `ProcMsaNFe` |
| | `Pontos_de_Entrada/FAT/M460FIM_pe.prw` | Fim do faturamento: `PrcGrvRet`, mensagem de ajuste e `PrcXmlNfe` |
| Protheus → SAP | `SAP/PrcRCOXml.prw`, `ProcRCOMsa.prw`, `MsafRCOFile.prw` | Arquivo IP140 da NF RCO |
| | `SAP/PrcXmlRSymb.prw`, `ProcRSymbMsa.prw`, `MsafRSymbFile.prw` | Arquivo IP050 do retorno simbólico |

**Dependências fora da lista**, necessárias no RPO:
- `Mastersaf_NFe/DHLRtcTagAudit.tlpp`: chamado pelo ProcRCOMsa.
- `Pontos_de_Entrada/COM/MT103FIM_pe.prw`: chama o updImpCD2.
- `Mastersaf_NFe/ProcMsaNFe.prw`: chamado pelo PrcXmlNfe.
- `Mastersaf_NFe/ImpMsaNfe.prw` e `SAP/SCJ/MonIp040.prw`: disparam a geração do IP140 e do IP050.
