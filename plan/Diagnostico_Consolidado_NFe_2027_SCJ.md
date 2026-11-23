# Diagnóstico Consolidado — NF-e 2027 (fluxo SC Johnson / AG2)

- **Data:** 19/11/2026
- **Tipo:** varredura somente leitura (nenhum fonte alterado)
- **Base normativa:** NT 2025.002-RTC v1.53, NT 2026.008, Ajuste SINIEF 49/2025, Ajuste SINIEF 27/2026, LC 214/2025, Guia Prático EFD ICMS/IPI
- **Insumos:** lista de fontes "SC Johnson_meus fontes", documento "Questões Fiscais NFe 2027 comentado", FDD IM04
- **Raiz dos fontes:** `PROTHEUS/Producao/`

---

## 1. Conclusão estrutural (mais importante)

**Nenhum fonte da lista monta o XML enviado à SEFAZ.** Esse XML é gerado por `Mastersaf_NFe/nfesefaz.prw` e pelos PEs (`PE01NFESEFAZ.prw`, `ImpMsaNfe.prw`), junto com a TES. Os fontes da lista fazem três coisas:

| Bloco | Fontes | O que fazem |
|---|---|---|
| **Entrada SAP → Protheus** | SAPIP040, DHLIp040Sap, DHLIp150, SAPIP150/160/190, PrcNfRco, PrcGrvRco, PrcNfRet, PrcGrvRet, updImpCD2, CadRegFis, CadDePara | Geram só a remessa por conta e ordem (RCO), o retorno simbólico (RET) e o acerto de FCP na devolução. **Não criam nota de crédito, débito nem ajuste.** |
| **Arquivos Protheus → SAP** | ProcRCOMsa (IP140), ProcRSymbMsa (IP050), PrcRCOXml, PrcXmlRSymb, MsafRCOFile, MsafRSymbFile | Leem o XML do nfesefaz e geram um TXT posicional (`--tag_ini--;valor;--tag_fim--;`). O risco é o arquivo **não bater com a nota autorizada**, e não rejeição da SEFAZ. |
| **Arquivos Protheus → Mastersaf DW** | ProcMsaDW, DHLSafx07/08/112/116/2013, SAFX07MSDW, variantes por unidade | Geram SAFX07 (capa), 08 (itens), 112 (observações) e 116 (documento referenciado). |

**Consequências:**
- As regras de rejeição (B25-40, B25-80, VC02-10, E02-10, 1039/1048/1034/1001) precisam ser tratadas **também no nfesefaz, nos PEs e na TES**.
- O fluxo de onde nasce o ajuste fiscal (**DHLIP210 / SAPIP210**, que grava `F2_ZZTPNF = AJUSTE_FISCAL`) **não está na lista** e precisa entrar no escopo.
- **A unidade da SC Johnson é a AG2.** Evidências: `MsafDWFile.prw:67` e `08AG2SAFX.prw:85,177`. No Mastersaf DW, a rota é `ProcMsaDW.prw:204-205` → `U_07AG2SAFX`.

---

## 2. Situação por regra

Legenda: ✅ atende · ⚠️ parcial · ❌ não atende · ➖ não se aplica

### 2.1 Arquivo para o SAP: ProcRCOMsa.prw (IP140)

Recebeu ajustes em 18/11/2026 (Wellington): finNFe 5/6, tpNFDebito/tpNFCredito, DFeReferenciado, gAjusteCompet, gEstornoCred, IS, ZZ_FINAJUS.

| # | Regra | Status | Arquivo:linha | Evidência / risco | Correção sugerida |
|---|---|---|---|---|---|
| 1 | finNFe 2/3/4/5/6 | ⚠️ | ProcRCOMsa.prw:262-307 | 5/6 vêm de `F?_TIPO`. Ajuste (3) só sai se `FWUnitBusiness() $ ZZ_FINAJUS` (padrão AG2) **e** `SF2->F2_ZZTPNF == AJUSTE_FISCAL`. Lê SF2/SD2 mesmo na entrada (:293, :300). Unidade vazia faz `"" $ ...` dar verdadeiro. Devolução na entrada (tipo D) não vira 4. | Ler `F1_ZZTPNF`/`F2_ZZTPNF` conforme `cTypeInv`. Rejeitar unidade vazia. |
| 2 | Subtipo tpNFCredito/tpNFDebito | ❌ **confirmado** | ProcRCOMsa.prw:236-247, 318-328 | `getTpCompl()` devolve `AllTrim(F?_TPCOMPL)`, e o campo guarda 1 caractere (nfesefaz.prw:1203 compara com `"7"`, :4526 com `"3"`). Sai "3" em vez de "03". Não há whitelist (crédito 01/03/04/06, débito 02/03/04/06/07). | `PadL(AllTrim(cTpCompl),2,"0")` + whitelist por finNFe. **Antes:** confirmar se o código TOTVS em `F1_TPCOMPL` é igual ao da NT. O nfesefaz:4526 comenta "5-Crédito com 3 - Transferência de Crédito na sucessão", e na NT sucessão é 05. |
| 3 | Ajuste para DHL/DOX | ❌ | ProcRCOMsa.prw:290; `Includes/dhl.ch:70-79` | DHL e DOX **não existem** como unidade de negócio. As unidades são SPL, PKG, REV, DIS, REP, AGE, MUL, AG2, AGL e DI2, então o `ZZ_FINAJUS` não consegue liberá-las. A trava AG2 continua **fixa** em `PE01NFESEFAZ.prw:197-198, 608-609` e `ImpMsaNfe.prw:1032`. | Definir o critério (unidade ou empresa `cEmpAnt`) e alinhar PE01NFESEFAZ e ImpMsaNfe. |
| 4 | indPres | ❌ **confirmado** | ProcRCOMsa.prw:250 | Fixo `"0"`. | Ler `infnfe:_ide:_indPres` do XML, com "0" só como fallback. |
| 5 | NFref (exatamente 1, proibida em alguns tipos) | ❌ | ProcRCOMsa.prw:5578-5682 | O laço emite **todas** as referências. Sem referência, sai `nfReferenciada` vazia (:5641). Limita a 1 só em homologação (`ZZ_RFNFHOM`, :5595). | Em `DoAllRef`: no máximo 1 em finNFe 2 e crédito 01/03/04; nenhuma em crédito 02/05/06 e débito 03-07; nunca junto com DFeReferenciado. |
| 6 | DFeReferenciado e nItem | ⚠️ | ProcRCOMsa.prw:3916, 5086-5095 | Sempre emitido, com `EMPTY_VALUE` quando não há dado. Nenhuma regra por tipo. | Emitir só em crédito 06 e débito 03/04. nItem obrigatório em crédito 06 e débito 04, limpo nos demais tipos. |
| 7 | Omissão de tributos antigos em 5/6 (B25-80, Rej. 1001) | ❌ | ProcRCOMsa.prw:3954-4090 (`DoAllTaxes`), 629-819 (`DoIcmsTot`), 724-728 | A cadeia ICMS/IPI/II/PIS/COFINS/ISSQN/ICMSUFDest/impostoDevol é montada sem olhar finNFe. `vIPIDevol` só é zerado em finNFe 1; nos demais recebe `F2_VALIPI`. | Pular os grupos quando finNFe $ "56", salvo as exceções (crédito 03 e débito 09 com ICMS; débito 06/07 com CST 41/90). Em :724, zerar quando `cFinNfe <> "4"`. |
| 8 | ICMSPrevistoPagtoAntecip (Débito 06) | ❌ **confirmado** | ProcRCOMsa.prw:5067 | `GetNewPar("ZZ_TRIBICM","ICM")`, mas `retValTax` compara com igualdade exata e o código no restante do fonte é "ICMS". O grupo nunca é preenchido. | Padrão "ICMS" ou criar o parâmetro. |
| 9 | gAjusteCompet (Débito 03, CST 811) | ⚠️ | ProcRCOMsa.prw:4538-4550, 5025-5038 | `gIBSCBS` é sempre emitido junto (Rej. 1021/1170). Não valida vIBS/vCBS maior que zero (Rej. 1171). vItem (:3866) e vNFTot (:5308) são copiados da origem. | Não preencher `gIBSCBS` quando CST = 811. Validar vIBS/vCBS maior que zero. |
| 10 | Base vBCIBSCBS sem CST 410/811 | ✅ | ProcRCOMsa.prw:5141-5189 | Usa `MV_CSTGXML`, padrão `"000/200/210/220/510/550/830/222"`. | O teste usa `$` (substring); manter o parâmetro correto. |
| 11 | CST 410 / cClassTrib 410999 | ✅ (no fonte) | ProcRCOMsa.prw:4517-4518 | Vem do XML, sem hardcode. | Conferir a origem (TES, nfesefaz). |
| 12 | PIS/COFINS CST 08 | ✅ | ProcRCOMsa.prw:3426, 3637 | `pis_nt`/`cofins_nt` com `"04,06,07,08,09"`. | — |
| 13 | Participante `<dest>` | ➖ / ⚠️ | ProcRCOMsa.prw:485-543 | Copiado do XML. Depende do nfesefaz (Rej. 1034 no débito 07/02). | Validar na origem. |
| 14 | tpNF / CFOP | ⚠️ | ProcRCOMsa.prw:226, 1621 | Vêm do XML. Nenhum hardcode de 5949/1949. Não força tpNF 0 no crédito nem 1 no débito 07. | Validar na origem. |
| 15 | Parâmetro `lFormatZero` na posição errada | ❌ | ProcRCOMsa.prw:5215-5308 | `setAttributeValue(..., retValueAttribute(...), lFormatZero)`: o 3º parâmetro é `lAddNode`, então o zero não é formatado. | Corrigir a chamada. |
| 16 | Grupos novos sempre vazios no TXT | ⚠️ | ProcRCOMsa.prw:4988-4992 | DFeReferenciado, gAjusteCompet, gEstornoCred, IS, ISTot e vProdLiqTot entram no layout posicional como "hipótese de trabalho". | Validar o layout com o SAP/Mastersaf. |

**Travas `FWUnitBusiness() == DHL_BUSINESSUNIT_AG2` no ProcRCOMsa:**

| Linha | O que controla | Afeta crédito/débito/ajuste? |
|---|---|---|
| 290 | finNFe 3 (ajuste) via ZZ_FINAJUS | **Sim** |
| 1096 | Fatura, em bloco comentado | Não (código morto) |
| 1244 | inf_Adic: concatena e quebra em 1999 caracteres | Não |
| 1308 | uso_livre_c / obsCont | Não |
| 1574 | xProd sem remover acento | Não |
| 3249 | IPI: os dois ramos são idênticos | Não |
| 3310 | x_ipi_unid | Indireto (IPI) |
| 4161 | `recordKeyNfe`: grava a chave em SF3/SFT | DHL/DOX ficariam sem chave |
| 4490 | DoxTexto | Não |

### 2.2 Arquivo para o SAP: ProcRSymbMsa.prw (IP050, retorno simbólico)

Só roda para SF2 com `F2_ZZTPNF == RETORNO_SIMBOLICO ("4")` (`ImpMsaNfe.prw:1745-1748`, `MonIp040.prw:234`). É paralelo ao ProcRCOMsa e **não recebeu nenhum** dos ajustes de 18/11.

| # | Regra | Status | Arquivo:linha | Evidência | Correção |
|---|---|---|---|---|---|
| 1 | finNFe 5/6 e 3 | ❌ | ProcRSymbMsa.prw:210-227 | Só retorna 1/2/4. Não tem o ramo de ajuste nem a regra 5921/6921. | Ler `<tpNFe>` do XML TSS (nfesefaz:7782) ou replicar o RCO. |
| 2 | tpNFDebito/tpNFCredito | ❌ | ProcRSymbMsa.prw:179-203 | Ausentes. | Copiar do XML, depois de alinhar o layout com o SAP. |
| 3 | indPres | ❌ | ProcRSymbMsa.prw:199 | Fixo "0". | Ler do XML. |
| 4 | NFref | ➖ | ProcRSymbMsa.prw:277-310 | Copia todas. Em homologação grava uma **chave fixa** (:304). | Opcional: remover a chave fixa. |
| 5 | DFeReferenciado | ❌ (na prática ➖) | ProcRSymbMsa.prw:2921-2956 | Não montado. | Só se o SAP precisar. |
| 6 | Tributos antigos | ➖ / ⚠️ | ProcRSymbMsa.prw:714-766 | `icms_Tot` pega vIPI/vPIS/vCOFINS do **SF2**, não do XML. | Opcional: tirar do XML. |
| 7 | IBSCBS / IS / totais | ❌ | ProcRSymbMsa.prw:50-119, 2993-3056 | Inexistentes. | Decidir com o SAP/fiscal; se precisar, portar do RCO. |
| 8 | Participante | ✅ (reflexo) | ProcRSymbMsa.prw:532-584 | Copiado do XML. | — |

PrcRCOXml, PrcXmlRSymb, MsafRCOFile e MsafRSymbFile são orquestração e serialização, sem regra fiscal. Qualquer campo novo muda o **layout posicional** lido pelo SAP.

### 2.3 Entrada SAP → Protheus (SAP/SCJ)

| # | Regra | Status | Arquivo:linha | Evidência | Correção |
|---|---|---|---|---|---|
| 1 | Finalidade e subtipo | ❌ | PrcNfRco.prw:256; PrcGrvRco.prw:293; SAPIP040.prw:154-225 | `F2_TIPO = "N"` fixo. `F2_ZZTPNF` só recebe RCO. O IP040 não traz finalidade nem subtipo. `F?_TPCOMPL` não é gravado em nenhum ponto. | Definir a origem (tags no IP040 ou fluxo DHLIP210/SAPIP210). |
| 2 | CST IBS/CBS e cClassTrib | ❌ | SAPIP040.prw:940-1096; DHLIp040Sap.prw:825-836 | Só lê alíquota, base e valor. A TES (SZC/CadRegFis) é escolhida apenas por flags de ICMS. | Novas tags e campos ZB_ com getter; incluir cClassTrib na chave da SZC. |
| 3 | Alíquota CBS / IS | ⚠️ / ❌ | SAPIP040.prw:1050-1096; DHLIp040Sap.prw:15-18 | A CBS vem do XML (não é hardcode). IS inexistente. As constantes `FIELDS_IBS_*`/`FIELDS_CBS` **não são usadas**. | Incluir IS; conferir o de/para da SZD para IBS/CBS. |
| 4 | PIS/COFINS CST 08 | ❌ / ➖ | — | Depende só da TES escolhida pela SZC. | Criar uma TES específica ou ampliar a regra da SZC. |
| 5 | CFOP 5927/5922/6922 e inverso | ⚠️ | SAPIP040.prw:1485-1497; DHLIp040Sap.prw:407-411; PrcGrvRco.prw:118-122 | CFOP = F4_CF. A inversão é fixa `"6"+Subs(...)`. Sem hardcode de 5949/1949. | Generalizar a inversão (1↔5, 2↔6) e incluir a finalidade na SZC. |
| 6 | NFref / DFeReferenciado | ⚠️ | SAPIP040.prw:217-225; PrcNfRco.prw:332-334 | Uma chave SCJ por arquivo + ZB_LINITEM. Data de emissão = `dDataBase` (TODO). | Receber a referência por item e a data real. |
| 7 | indPres / canal | ❌ | SAPIP040.prw:231-239 | Nenhum dado permite derivar. | Tag de canal no IP040 ou parâmetro padrão. |
| 8 | gAjusteCompet / gEstornoCred | ❌ | não localizado | — | Definir a origem. |
| 9 | Participante | ➖ / ⚠️ | PrcNfRco.prw:261-265; SAPIP190.prw:190-225 | RCO/RET usam SA1. Não há fluxo de crédito/débito. | Tratar no fluxo de ajuste. |
| 10 | Travas por unidade | ✅ (sem bloqueio) | DHLIp150.prw:776, 793 | As travas só incluem AG2; `AJUSTE_FISCAL` é aceito na exclusão. | Criar o define de DOX, se for unidade. |
| 11 | updImpCD2 | ➖ com bugs | ver seção 3 | Só copia FCP; não copia IBS/CBS na devolução. | Avaliar a cópia de IBS/CBS. |

**Atenção:** a gravação da SZA/SZB é dinâmica (`SAPIP040.prw:70, 141`). Todo campo novo **usado** no SX3 precisa de uma função `get<campo>()` correspondente, senão a IP040 inteira falha.

### 2.4 Mastersaf DW

**Três fatos que mudam o diagnóstico:**
1. **O ajuste `ZZ_SFXMOVR` de 18/11 (`DHLSafx07.prw:53`) não roda no fluxo padrão nem na AG2.** Em `SAFX07MSDW.prw:70` a chamada a `getSql()` está **comentada**. O que vale é a `sf3abre()`, cujo CASE (:293, 405, 524, 636) só conhece D/B. O mesmo acontece em `07AG2SAFX.prw:242, 374, 512, 643`, AGE, AGL e DI2. Só DIS e MUL usam `getSql`.
2. A SC Johnson é a **AG2**: o fluxo dela é `07AG2SAFX` + `DHLSafx07Ag2/08Ag2/116Ag2`.
3. **SAFX3007/3008 e DHLSafx3007/3008 não existem** no projeto (só aparecem em `plan/`). Os includes existentes (`safx07.ch`, `safx08.ch`, `safx116.ch`, `safx2013.ch`) não têm IBS/CBS/IS/cClassTrib.

| # | Regra | Status | Arquivo:linha | Evidência / risco | Correção |
|---|---|---|---|---|---|
| 1 | Normal × Devolução (crédito 03/06 e débito 09 → Devolução) | ❌ | SAFX07MSDW.prw:293…; 07AG2SAFX.prw:242…; DHLSafx07.prw:53 (sem efeito) | O CASE só conhece D/B. TPCOMPL não está na query (SFTabre :813-848). O valor errado se propaga para SAFX07, 08, 112 e 116. | JOIN com SF1/SF2 para ler TPCOMPL na `sf3abre` (base, AG2, AGE, AGL, DI2) e regra por subtipo no `getSql` (DIS, MUL). Ideal: centralizar na classe base. |
| 2 | Base IBS/CBS (somente CST 000/200/210/220/222/510/550/830) | ❌ (inexistente) | — | Nenhum campo IBS/CBS é enviado. A CD2 só é lida para ICM/SOL/CMP (`DHLSafx.prw:1336-1395`). | Implementar com o leiaute 2027, com a lista de CST em parâmetro. |
| 3 | Participante 5/6 | ❌ base/AG2/AGE/AGL/DI2; ⚠️ DIS/MUL | SAFX07MSDW.prw:254-364, 597-707; DHLSafx.prw:289-321 | A entrada tipo 5 usa **SA2**. Não há exceção para crédito 02 nem débito 07 (emitente). LEFT JOIN pode deixar `ZZINDDW` nulo. | Levar 5/6 para o ramo correto pelo TPCOMPL; usar o `getIndFisJur` na base e na AG2. |
| 4 | SAFX116 (documento referenciado) para 5/6 | ❌ | DHLSafx116.prw:113-115, 170-187; DHLSafx116Ag2.prw:187+; 08AG2SAFX.prw:203-225 | Assume direção oposta à nota original (só "C" é ajustado). Débito de saída que referencia uma venda lê `D2_FORNECE` e não acha a chave. | Direção pela nota original (`getTypeDoc` sobre FT_NFORI). |
| 5 | Notas só de IBS/CBS fora da EFD ICMS/IPI | ❌ | DHLSafx07.prw:164, 248 | Sem filtro nem flag. | Validar com o fiscal e com a Thomson Reuters/Mastersaf. |
| 6 | Leiaute IBS/CBS/IS/cClassTrib | ❌ **bloqueante** | safx07.ch:269-278; safx08.ch:206-214 | Só existem DSC_RESERVADO1-8. | Aguardar o leiaute 2027. Avaliar uso temporário dos campos reservados. |
| 7 | Travas por unidade | ⚠️ | ProcMsaDW.prw:183-221; DHLSafx07.prw:154 (`COD_EMPRESA` "SOL" fixo) | Cada unidade tem uma cópia da query. Correção só na base não chega à SCJ. | Centralizar ou replicar em 7 pontos. |

Defeito antigo, fora do escopo: `DHLSafx07.prw:225`, `IND_COMPRA_VENDA` compara `TIPO=="N"`, mas TIPO vale "1"/"2", então o campo sempre sai vazio.

---

## 3. Riscos que não são da reforma

| Item | Arquivo:linha | Problema |
|---|---|---|
| Cópia `merge/ProcRCOMsa.prw` | — | **Não tem nenhum** dos ajustes de 18/11. Se for promovida, desfaz o trabalho. |
| Cópia `merge/ProcRSymbMsa.prw` | :121, :204 | Chama `DoInfIntermed()`, que não existe no arquivo. `dPrevEntrega` muda o layout lido pelo SAP. |
| updImpCD2.prw | :39 | `while SD1->(!eof()) == SD1->(...) == cChaveSD1` compara um valor lógico com um texto (erro de tipo ou só o 1º item). **Confirmado.** |
| updImpCD2.prw | :49-50 | Passa `cLoja` (loja da entrada) no lugar de `cLojaSaid`. **Confirmado.** |
| updImpCD2.prw | :180-181 | Tabelas `SZA100`/`SD1100` fixas (viola SonarQube / `RetSqlName`). **Confirmado.** |
| `retArrayAtribute` (um "t") | ProcRCOMsa:646, 3879, 4358; ProcRSymbMsa:675, 2925, 3201 | Não definido no workspace. Deve vir de outra biblioteca do RPO; confirmar. |
| DHLIp040Sap.prw | :15-18 | Constantes `FIELDS_IBS_*`/`FIELDS_CBS` definidas e não usadas. |

---

## 4. Plano sugerido (próximos turnos, só código)

1. **ProcRCOMsa.prw**, em um único pacote:
   - completar o subtipo com zero (após confirmar a tabela TOTVS × NT);
   - ler o indPres do XML;
   - corrigir o padrão do `ZZ_TRIBICM`;
   - não emitir `gIBSCBS` com CST 811 e validar vIBS/vCBS maior que zero;
   - aplicar NFref e DFeReferenciado por tipo;
   - zerar o `vIPIDevol` fora da devolução;
   - corrigir o `lFormatZero` na posição errada.
2. **07AG2SAFX / SAFX07MSDW (`sf3abre`)**: Normal/Devolução e participante pelo subtipo, replicados em AGE, AGL e DI2 (ou centralizados), e `getSql` de DIS/MUL por subtipo.
3. **nfesefaz / PE01NFESEFAZ / ImpMsaNfe**: onde a rejeição da SEFAZ acontece (B25-80, B25-40, E02-10, indPres) e trava AG2 fixa no ajuste.
4. **DHLSafx116 / DHLSafx116Ag2**: direção da referência para 5/6.
5. **updImpCD2**: corrigir os três bugs.
6. **ProcRSymbMsa**: alinhar com o RCO, se o SAP confirmar a necessidade.

## 5. Decisões e dependências externas

| # | Decisão / dependência | Responsável |
|---|---|---|
| 1 | Como identificar DHL e DOX no Protheus (empresa ou unidade de negócio)? SOL não existe; DIS sem informação. | Fiscal / DHL |
| 2 | Tabela de códigos `F1_TPCOMPL`/`F2_TPCOMPL` (TOTVS) × tpNFCredito/tpNFDebito (NT) | TOTVS / Fiscal |
| 3 | O IP040 do SAP passará a enviar finalidade, subtipo, CST/cClassTrib, IS, canal (indPres), dados de gAjusteCompet? | SAP SCJ |
| 4 | IP140/IP050 precisam dos campos da reforma? Qualquer campo novo muda o layout posicional. | SAP SCJ |
| 5 | Leiaute 2027 do Mastersaf DW (SAFX3007/3008) e tratamento das notas só de IBS/CBS fora da EFD ICMS/IPI | Thomson Reuters / Mastersaf |
| 6 | Incluir DHLIP210/SAPIP210 (origem do ajuste fiscal) no escopo | Projeto |
| 7 | Confirmar nos dados se F3_TIPO herda "5"/"6" e se F1_FORNECE/F2_CLIENTE das notas 5/6 apontam para SA1 ou SA2 | Projeto |
| 8 | Promoção ou descarte das cópias em `merge/` | Projeto |
