---
goal: Classificação de impacto por fonte — interface Mastersaf DW (SAFX07/08/112/116) frente ao Configurador de Tributos e à Reforma Tributária (IBS/CBS)
version: 1.0
date_created: 2026-11-13
last_updated: 2026-11-13
owner: DHL - Equipe Protheus / Fiscal (DV2)
status: 'Planned'
tags: [impacto, analise, fiscal, reforma-tributaria, ibs-cbs, cfgtrib, mastersaf-dw]
plano_relacionado: plan/upgrade-mastersaf-dw-safx07-ibs-cbs-1.md
---

# Classificação de Impacto — Mastersaf DW (SAFX07/08/112/116)

![Status: Planned](https://img.shields.io/badge/status-Planned-blue)

Documento de apoio ao plano [upgrade-mastersaf-dw-safx07-ibs-cbs-1.md](upgrade-mastersaf-dw-safx07-ibs-cbs-1.md). Classifica **fonte por fonte** o impacto da adequação ao Configurador de Tributos (CFGTRIB/FISA170) e à Reforma Tributária do Consumo (IBS/CBS), com a evidência que sustenta cada classificação.

## 1. Critérios de Classificação

A classificação não é subjetiva. Cada fonte recebeu o nível correspondente ao **primeiro critério satisfeito**, na ordem abaixo:

| Nível | Critério objetivo | Consequência se não tratado |
|-------|-------------------|------------------------------|
| **ALTO** | O fonte (a) mapeia, calcula ou transporta valor/base/alíquota de tributo; **ou** (b) define o layout posicional do arquivo; **ou** (c) é ponto de centralização obrigatório de que outros fontes herdam | Arquivo fiscal gerado sem IBS/CBS, ou com posições incorretas — perda de crédito e/ou rejeição na escrituração |
| **MÉDIO** | Orquestra o fluxo, monta cursor de dados ou controla ciclo de vida, **sem** mapear campo de tributo diretamente | Dados de IBS/CBS não chegam à camada que os grava |
| **BAIXO** | Não trata valor de tributo. Alteração limitada a texto, código de observação, referência de documento ou validação | Risco residual: observação ou referência incompleta para rastreio de crédito |
| **SEM IMPACTO DIRETO** | Nenhum campo fiscal no fonte. Apenas validação de regressão | Nenhuma |
| **N/A** | Fonte morto, duplicado ou inexistente. Fora do escopo de alteração | Nenhuma — mas exige confirmação no RPO |

**Critério de evidência.** Toda classificação ALTO ou MÉDIO cita a função e a linha que a sustenta. Classificações BAIXO e SEM IMPACTO DIRETO citam a ausência verificada de campos de tributo.

## 2. Rastreabilidade com o Escopo Indicado

Amarração 1:1 entre os **10 itens informados** e a classificação deste documento. Nada da lista foi omitido; o que foi acrescentado está identificado como ampliação técnica, com a justificativa.

| # | Item indicado | Onde está classificado | Fontes correspondentes | Impacto |
|---|---|---|---|---|
| 1 | `SAFX07/AG2` | §5, §6, §7, §8 | `07AG2SAFX` (893) · `DHLSafx07Ag2` (639) · `08AG2SAFX` (214) · `DHLSafx08Ag2` (875) · `112AG2SAFX` · `DHLSafx112Ag2` · `116AG2SAFX` · `DHLSafx116Ag2` | **ALTO** |
| 2 | `SAFX07/AGE` | §5, §6, §7, §8 | `SAFX07AGE` (837) · `DHLSafx07Age` (513) · `SAFX08AGE` (238) · `DHLSafx08Age` (756) · `DHLSafx112Age` · `SAFX112MSDW` (cópia) · `SAFX116AGE` · `DHLSafx116Age` | **ALTO** |
| 3 | `SAFX07/AGL` | §5, §6, §7, §8 | `SAFX07AGL` (835) · `DHLSafx07Agl` (538, classe `DHLAGL07`) · `SAFX08AGL` (238) · `DHLSafx08Agl` (757, classe `DHLAGL08`) · `AGL112` · `SAFX116AGL` · `DHLSafx116Agl` | **ALTO** |
| 4 | `SAFX07/DIS` | §5, §6, §7, §8 | `SAFX07DIS` (157) · `DHLSafx07Dis` (720) · `SAFX08DIS` (163) · `DHLSafx08Dis` (858) · `SAFX112DIS` · `DHLSafx112Dis` · `SAFX116DIS` · `DHLSafx116Dis` | **ALTO** — padrão de acesso **A** |
| 5 | `SAFX07/DI2` | §5 | `Di2SAFX07MSDW` (694) · `Di2DHLSafx07` (492) | **ALTO** — não tem SAFX08/112/116 próprios; reutiliza os do Default |
| 6 | `SAFX07/MUL` | §5, §6, §7, §8 | `07SAFXMUL` (155) · `DHLSafx07Mul` (445) · `08SAFXMUL` (140) · `DHLSafx08Mul` (823) · `112SAFXMUL` · `DHLSafx112Mul` · `116SAFXMUL` · `DHLSafx116Mul` | **ALTO** — padrão de acesso **A** |
| 7 | `SAFX07/REP` *(reusa AGE)* | §5 (nota) e §10 | **Nenhum fonte próprio** — confirmado: `ProcMsaDW.prw:200-203` chama `U_SAFX07AGE()` | **0 fontes a alterar** — herda integralmente de AGE (item 2) |
| 8 | `SAFX07MSDW` *(PKG)* | §5 | `SAFX07MSDW` (882) · `DHLSafx07` (492) — mesmo par do item 9 | **ALTO** |
| 9 | `SAFX07MSDW` *(Default)* | §5 | `SAFX07MSDW` (882) · `DHLSafx07` (492) — confirmado: `ProcMsaDW.prw:216-219` atende **PKG, SPL, REV e Default** pelo mesmo ramo `else` | **ALTO** |
| 10 | `SAFX08MSDW` *(Default)* | §6 | `SAFX08MSDW` (173) · `DHLSafx08` (848) — atende Default, PKG e SPL | `SAFX08MSDW` = **MÉDIO** · `DHLSafx08` = **ALTO** |

### Confirmações sobre a lista

- **Item 7 (`SAFX07/REP`) está correto:** não existe a pasta `SAFX07/REP` no workspace. A unidade REP é atendida por `U_SAFX07AGE()`. Sua anotação "(reusa AGE)" confere com o código.
- **Itens 8 e 9 são o mesmo fonte:** não existe `SAFX07/PKG`. PKG cai no ramo `else` do dispatcher, junto com Default. Registrado como uma única linha de alteração que atende as duas unidades — **e também SPL e REV**, que não constavam na lista e são cobertas pelo mesmo fonte.
- **Item 5 (`SAFX07/DI2`) tem só 2 fontes:** a pasta não contém SAFX08, SAFX112 nem SAFX116. `Di2SAFX07MSDW.prw:119-121` chama `U_SAFX08MSDW()` e `U_SAFX112MSDW()` do Default, e `Di2SAFX07MSDW.prw:91` consome `U_SFTabre()` do `SAFX07MSDW.prw` — **dependência de compilação entre pastas**, registrada em §11.

### Ampliações além da lista — e por quê

| Acréscimo | Seção | Justificativa |
|---|---|---|
| `DHLSafx.prw` (classe base, 1159 linhas) | §4 | **Obrigatório.** É a classe-mãe das 7 variantes e contém `getUfTaxes()`/`getSumItems()`. Sem alterá-la, a correção teria de ser replicada 7× em vez de 1× |
| `safx07.ch` e `safx08.ch` | §4 | **Obrigatório.** Sem campo de IBS/CBS no layout, não existe onde gravar o valor — `SAFX07_POSICOES 285` e `SAFX08_POSICOES 259` estão congelados |
| `ProcMsaDW.prw` e `MsafDWFile.prw` | §4 | Dispatcher e escritor do arquivo posicional — determinam qual variante roda e validam a quantidade de colunas |
| SAFX112 e SAFX116 (todas as variantes) | §7, §8 | São gerados **dentro** do mesmo fluxo do SAFX07/08 (`SAFX07MSDW.prw:119-121`). Classificados como BAIXO após verificação: nenhum campo de valor nos layouts de 15 e 21 posições |
| `safx112.ch`, `safx116.ch`, `dhl.ch` | §4 | Includes consumidos pelos fontes em escopo |
| `DHLSafx116.~pr`, `AGL/_AGL112.prw`, `MUL/DHLSafx52Mul.prw` | §9 | Possíveis fontes mortos encontrados nas pastas indicadas. Classificados **N/A** para evitar alteração por engano — exigem confirmação no RPO |

## 3. Resumo Executivo

| Nível | Qtd. fontes | Linhas de código |
|-------|-------------|------------------|
| ALTO | 32 | ~17.900 |
| MÉDIO | 7 | ~1.100 |
| BAIXO | 14 | ~1.700 |
| SEM IMPACTO DIRETO | 0 | — |
| N/A | 3 | ~560 |
| **Total em avaliação** | **56** | **~21.300** |

**Causa raiz única:** nenhum dos 56 fontes lê a tabela **F2D** (Tributos Genéricos Calculados), onde o Configurador de Tributos grava IBS e CBS. Toda a captação vem de campos legados de matriz de TES (`F3_*`, `FT_*`, `F4_*`) e, para ICMS Partilha/FCP, da tabela `CD2` via `DHLSafx:getUfTaxes()`.

**Multiplicador de esforço:** a mesma correção precisa ser replicada em até **7 variantes** por arquivo SAFX (clone-and-own), sob **2 padrões distintos de acesso a dados**.

## 4. Infraestrutura Compartilhada — alteração única, herdada por todas as variantes

| Fonte | Linhas | Impacto | Por quê | Ação |
|---|---|---|---|---|
| `Mastersaf_DW/DHLSafx.prw` | 1159 | **ALTO** | Classe base de todas as variantes. `getUfTaxes()` (L1249) lê `CD2` por tributo (`CD2_IMP` = ICM/SOL/CMP) — é o molde exato do que falta para IBS/CBS; `getSumItems()` (L1101) totaliza o documento; `addField()` (L190); `getTaxRecord()` (L268) | Criar `getRtcTaxes()` e `isRtcActive()`; estender `getSumItems()`. **Único ponto que evita replicar 7×** |
| `Includes/safx07.ch` | 327 | **ALTO** | Layout do cabeçalho. `SAFX07_POSICOES 285` (L298) e **nenhum campo nativo de IBS/CBS**. Só há `DSC_RESERVADO1..8` (posições 259-261 e 264-268) | Novos `#define`; ajustar `SAFX07_POSICOES` e `VLD_07_FIELD` (L305) |
| `Includes/safx08.ch` | 295 | **ALTO** | Layout do item. `SAFX08_POSICOES 259` (L269), sem campo de IBS/CBS. `DSC_RESERVADO1..8` nas posições 203-205 e 207-211 | Novos `#define`; ajustar `SAFX08_POSICOES` e `VLD_08_FIELD` (L276) |
| `Mastersaf_DW/MsafDWFile.prw` | 255 | **MÉDIO** | Escrita do arquivo posicional e `renameArq()`. Não conhece tributo, mas valida quantidade de colunas (`ERROR_QTD_CAMPOS`) | Validar com o novo número de posições |
| `Mastersaf_DW/ProcMsaDW.prw` | 304 | **MÉDIO** | Dispatcher por unidade de negócio (L183-221). Define qual variante roda: DIS→`U_SAFX07DIS`, AGE→`U_SAFX07AGE`, AGL→`U_AGL07`, **REP→`U_SAFX07AGE`** (L200), AG2→`U_07AG2SAFX`, MUL→`U_07SAFXMUL`, DI2→`U_Di2SAFX07MSDW`, **else (PKG/SPL/REV)→`U_SAFX07MSDW`** (L216) | Alterar só se houver nova opção de geração |
| `Includes/safx112.ch` | 42 | **BAIXO** | 15 posições, todas de observação de lançamento fiscal (`COD_OBS_LANCTO_FISCAL`, `DSC_COMPLEMENTAR`). Zero campo de valor | Avaliar novos códigos de observação |
| `Includes/safx116.ch` | 48 | **BAIXO** | 21 posições de documento referenciado. Zero campo de valor — porém ganha relevância para rastreio de crédito de IBS/CBS em devolução | Avaliar `COD_MODELO_REF` e cobertura de referência |
| `Includes/dhl.ch` | — | **BAIXO** | Constantes de unidade de negócio (L70-79) e de série/espécie de inventário e cutover (L51-54) | Nenhuma alteração prevista |

## 5. SAFX07 — Cabeçalho do Documento Fiscal (7 variantes)

Legenda de padrão de acesso: **B** = alias direto (`sf3abre()` + `SFTabre()` com `cSF3_`/`cSFT_`); **A** = objeto/array (`getSql()` + `getTaxRecord()`/`getItemFlowsRecord()`).

| Fonte | Linhas | Unidade(s) | Padrão | Impacto | Por quê |
|---|---|---|---|---|---|
| `SAFX07/SAFX07MSDW.prw` | 882 | **Default + PKG + SPL + REV** | B | **ALTO** | `sf3abre()` (L248) monta a query de `SF3` em 3 blocos `UNION ALL` com todos os campos de tributo; `U_SFTabre()` (L720) é **pública** e monta o join `SFT+SB1+SF1/SF2+SD1/SD2+SF4` — sem `FT_IDTRIB`, `D1_IDTRIB` nem `D2_IDTRIB` |
| `SAFX07/DHLSafx07.prw` | 492 | Default + PKG + SPL | B | **ALTO** | `addLine()` (L89) mapeia os ~90 campos de tributo do cabeçalho: `VLR_ICMS` (L183), `VLR_IPI` (L187), `VLR_BASE_PIS`/`VLR_PIS` (L217-218), `VLR_BASE_COFINS`/`VLR_COFINS` (L219-220), `VLR_FCP_UF_DEST` (L286). Último campo mapeado: `VLR_ICMS_UF_ORIG` (L288) — é onde IBS/CBS entra |
| `SAFX07/AGE/SAFX07AGE.prw` | 837 | **AGE + REP** | B | **ALTO** | Cópia com `sf3abre()` própria (L200) e `SFTabre()` **static** (L658) |
| `SAFX07/AGE/DHLSafx07Age.prw` | 513 | AGE + REP | B | **ALTO** | `addLine()` com mapeamento próprio; diverge 128/157 linhas da base |
| `SAFX07/AGL/SAFX07AGL.prw` | 835 | AGL | B | **ALTO** | `sf3abre()` (L202) e `SFTabre()` static (L656) próprias |
| `SAFX07/AGL/DHLSafx07Agl.prw` | 538 | AGL | B | **ALTO** | Classe `DHLAGL07` (nome divergente do arquivo); diverge 130/189 linhas da base |
| `SAFX07/AG2/07AG2SAFX.prw` | 893 | AG2 | B | **ALTO** | `sf3abre()` (L191) e `SFTabre()` static (L740) próprias; a variante mais divergente (709/738 linhas) |
| `SAFX07/AG2/DHLSafx07Ag2.prw` | 639 | AG2 | B | **ALTO** | `getSql()` (L79) própria; diverge 362/528 linhas da base |
| `SAFX07/DIS/SAFX07DIS.prw` | 157 | DIS | **A** | **ALTO** | Usa `oIpSqlSfx07:newAlias(oDHLSafx07:getSql(...))` (L57) — **não** usa `sf3abre`/`SFTabre`. Caminho de dados distinto, exige implementação própria |
| `SAFX07/DIS/DHLSafx07Dis.prw` | 720 | DIS | A | **ALTO** | `getSql()` (L52); **único grupo que ainda usa** `getTaxRecord()` (L154) e `getItemFlowsRecord()` (L156) ativos |
| `SAFX07/MUL/07SAFXMUL.prw` | 155 | MUL | **A** | **ALTO** | Mesmo padrão do DIS (`getSql()` na L57) |
| `SAFX07/MUL/DHLSafx07Mul.prw` | 445 | MUL | A | **ALTO** | `getSql()` própria; diverge 376/342 linhas da base |
| `SAFX07/DI2/Di2SAFX07MSDW.prw` | 694 | DI2 | B | **ALTO** | `sf3abre()` própria (L248), mas **consome `U_SFTabre()` do `SAFX07MSDW.prw`** (L91) — dependência de compilação entre fontes |
| `SAFX07/DI2/Di2DHLSafx07.prw` | 492 | DI2 | B | **ALTO** | Quase idêntico à base (diverge só 8/8 linhas) — candidato a consolidação |

> **REP e PKG não têm pasta nem fonte próprio.** REP é atendido por `U_SAFX07AGE()` e PKG/SPL/REV pelo ramo `else` (`U_SAFX07MSDW()`), ambos em `ProcMsaDW.prw`. Confirmado no código — nenhum fonte a criar.

## 6. SAFX08 — Itens do Documento Fiscal (6 variantes)

| Fonte | Linhas | Unidade(s) | Impacto | Por quê |
|---|---|---|---|---|
| `SAFX07/DHLSafx08.prw` | 848 | Default + PKG + SPL | **ALTO** | `addLine()` (L~220) mapeia o tributo por item: `VLR_ALIQ_ICMS`/`VLR_ICMS` (L262-263), `TRIB_ICMS`/`BASE_ICMS` (L269-270), `VLR_BASE_PIS`/`VLR_PIS` (L286-287), `VLR_BASE_COFINS`/`VLR_COFINS` (L288-289), `COD_SITUACAO_PIS`/`COFINS` (L314/L317), `VLR_FECP_ICMS` (L308), `VLR_ICMS_UF_ORIG` (L336). **É o ponto onde CST-IBS/CBS e cClassTrib por item precisam entrar** |
| `SAFX07/SAFX08MSDW.prw` | 173 | Default + PKG + SPL | **MÉDIO** | Orquestra o laço de itens e dispara `U_SAFX116MSDW()` (L122). Monta queries auxiliares (L155, L183) |
| `SAFX07/AGE/DHLSafx08Age.prw` | 756 | AGE + REP | **ALTO** | Cópia divergente (434/399 linhas) do mapeamento por item |
| `SAFX07/AGE/SAFX08AGE.prw` | 238 | AGE + REP | **MÉDIO** | Orquestração própria; dispara `U_SAFX116AGE()` (L99 e L150) |
| `SAFX07/AGL/DHLSafx08Agl.prw` | 757 | AGL | **ALTO** | Classe `DHLAGL08`; diverge 434/400 linhas |
| `SAFX07/AGL/SAFX08AGL.prw` | 238 | AGL | **MÉDIO** | Orquestração própria |
| `SAFX07/AG2/DHLSafx08Ag2.prw` | 875 | AG2 | **ALTO** | Diverge 171/204 linhas |
| `SAFX07/AG2/08AG2SAFX.prw` | 214 | AG2 | **MÉDIO** | Dispara `U_116AG2SAFX()` (L88 e L106) |
| `SAFX07/DIS/DHLSafx08Dis.prw` | 858 | DIS | **ALTO** | `getSql()` (L76) e `getSqlFt()` — padrão A, exige implementação própria |
| `SAFX07/DIS/SAFX08DIS.prw` | 163 | DIS | **MÉDIO** | Usa `oDHLSafx08:getSqlFt()` (L39) |
| `SAFX07/MUL/DHLSafx08Mul.prw` | 823 | MUL | **ALTO** | Padrão A; diverge 254/226 linhas |
| `SAFX07/MUL/08SAFXMUL.prw` | 140 | MUL | **MÉDIO** | Usa `getSqlFt()` (L38) |

> **DI2 não tem SAFX08 próprio** — reutiliza `U_SAFX08MSDW()` (`Di2SAFX07MSDW.prw:119`).

## 7. SAFX112 — Observações do Lançamento Fiscal (impacto indireto)

Layout de 15 posições, **todas de identificação e texto de observação**. Nenhum campo de base, alíquota ou valor.

| Fonte | Linhas | Unidade(s) | Impacto | Por quê |
|---|---|---|---|---|
| `SAFX07/DHLSafx112.prw` | 247 | Default + PKG + AGE + DI2 | **BAIXO** | Monta observação; `oSql:newAlias()` (L159). Sem campo de tributo |
| `SAFX07/SAFX112MSDW.prw` | 43 | Default + PKG + AGE + DI2 | **BAIXO** | Orquestração mínima |
| `SAFX07/AGE/DHLSafx112Age.prw` | 244 | AGE + REP | **BAIXO** | Cópia |
| `SAFX07/AGE/SAFX112MSDW.prw` | 43 | AGE | **BAIXO** | Cópia homônima em pasta distinta — atenção a conflito de nome no RPO |
| `SAFX07/AGL/AGL112.prw` | 37 | AGL | **BAIXO** | Orquestração |
| `SAFX07/AG2/DHLSafx112Ag2.prw` | 239 | AG2 | **BAIXO** | Cópia |
| `SAFX07/AG2/112AG2SAFX.prw` | 43 | AG2 | **BAIXO** | Orquestração |
| `SAFX07/DIS/DHLSafx112Dis.prw` | 286 | DIS | **BAIXO** | Cópia |
| `SAFX07/DIS/SAFX112DIS.prw` | 43 | DIS | **BAIXO** | Orquestração |
| `SAFX07/MUL/DHLSafx112Mul.prw` | 217 | MUL | **BAIXO** | Cópia |
| `SAFX07/MUL/112SAFXMUL.prw` | 43 | MUL | **BAIXO** | Orquestração |

**Ação única para o grupo:** avaliar se a Reforma Tributária exige novos códigos de observação (`COD_OBS_LANCTO_FISCAL`) para IBS/CBS. Se não exigir, o grupo inteiro fica sem alteração.

## 8. SAFX116 — Documentos Fiscais Referenciados (impacto indireto)

Layout de 21 posições de referência (`NUM_DOCFIS_REF`, `SERIE_DOCFIS_REF`, `COD_MODELO_REF`, `NUM_AUTENTIC_NFE`). Nenhum campo de valor — **porém** a referência é o que sustenta a apropriação de crédito de IBS/CBS em devoluções e ajustes.

| Fonte | Linhas | Unidade(s) | Impacto | Por quê |
|---|---|---|---|---|
| `SAFX07/DHLSafx116.prw` | 282 | Default + PKG | **BAIXO** | `getSql()` (L48). Sem campo de tributo |
| `SAFX07/SAFX116MSDW.prw` | 62 | Default + PKG + DI2 | **BAIXO** | Orquestração (L29) |
| `SAFX07/AGE/DHLSafx116Age.prw` | 315 | AGE + REP | **BAIXO** | `getSql()` com parâmetro extra `cOrigem` |
| `SAFX07/AGE/SAFX116AGE.prw` | 64 | AGE + REP | **BAIXO** | Orquestração |
| `SAFX07/AGL/DHLSafx116Agl.prw` | 321 | AGL | **BAIXO** | Classe `DHLAGL116` |
| `SAFX07/AGL/SAFX116AGL.prw` | 64 | AGL | **BAIXO** | Orquestração |
| `SAFX07/AG2/DHLSafx116Ag2.prw` | 313 | AG2 | **BAIXO** | 3 queries (L234, L282, L342) |
| `SAFX07/AG2/116AG2SAFX.prw` | 63 | AG2 | **BAIXO** | Orquestração |
| `SAFX07/DIS/DHLSafx116Dis.prw` | 313 | DIS | **BAIXO** | Cópia |
| `SAFX07/DIS/SAFX116DIS.prw` | 62 | DIS | **BAIXO** | Orquestração |
| `SAFX07/MUL/DHLSafx116Mul.prw` | 266 | MUL | **BAIXO** | 3 queries (L186, L234, L294) |
| `SAFX07/MUL/116SAFXMUL.prw` | 62 | MUL | **BAIXO** | Orquestração |

**Ação única para o grupo:** validar se a cobertura atual de documento referenciado atende o rastreio de crédito de IBS/CBS; revisar `COD_MODELO_REF` frente a novos modelos de documento.

## 9. Fontes a Confirmar Antes de Qualquer Alteração

| Fonte | Linhas | Impacto | Por quê |
|---|---|---|---|
| `SAFX07/DHLSafx116.~pr` | 318 | **N/A** | Arquivo de backup do editor (`.~pr`). Deve ser removido do repositório, não alterado |
| `SAFX07/AGL/_AGL112.prw` | 239 | **N/A** | Prefixo `_` sugere fonte desativado. **Confirmar no RPO** antes de descartar |
| `SAFX07/MUL/DHLSafx52Mul.prw` | 468 | **N/A** | Duplicata de `SAFX52/MUL/DHLSafx52Mul.prw` (474 linhas) em pasta errada. **Confirmar no RPO** |

## 10. Matriz Resumida por Unidade de Negócio

| Unidade | SAFX07 | SAFX08 | SAFX112 | SAFX116 | Padrão | Fontes a alterar |
|---|---|---|---|---|---|---|
| **Default / PKG / SPL / REV** | `SAFX07MSDW` + `DHLSafx07` | `SAFX08MSDW` + `DHLSafx08` | próprio | próprio | B | 4 ALTO + 1 MÉDIO |
| **AGE** | `SAFX07AGE` + `DHLSafx07Age` | `SAFX08AGE` + `DHLSafx08Age` | próprio | próprio | B | 4 ALTO + 1 MÉDIO |
| **REP** | *reusa AGE* | *reusa AGE* | *reusa AGE* | *reusa AGE* | B | **0 — herda de AGE** |
| **AGL** | `SAFX07AGL` + `DHLSafx07Agl` | `SAFX08AGL` + `DHLSafx08Agl` | `AGL112` | próprio | B | 4 ALTO + 1 MÉDIO |
| **AG2** | `07AG2SAFX` + `DHLSafx07Ag2` | `08AG2SAFX` + `DHLSafx08Ag2` | próprio | próprio | B | 4 ALTO + 1 MÉDIO |
| **DIS** | `SAFX07DIS` + `DHLSafx07Dis` | `SAFX08DIS` + `DHLSafx08Dis` | próprio | próprio | **A** | 4 ALTO + 1 MÉDIO |
| **MUL** | `07SAFXMUL` + `DHLSafx07Mul` | `08SAFXMUL` + `DHLSafx08Mul` | próprio | próprio | **A** | 4 ALTO + 1 MÉDIO |
| **DI2** | `Di2SAFX07MSDW` + `Di2DHLSafx07` | *reusa Default* | *reusa Default* | *reusa Default* | B | 2 ALTO |

## 11. Pontos de Replicação Obrigatória

Funções duplicadas que exigem a **mesma** alteração em todas as cópias. Esquecer uma cópia produz arquivo fiscal incorreto para uma unidade de negócio inteira, **silenciosamente**.

| Função | Cópias | Localização |
|---|---|---|
| `SFTabre()` | **4** | `SAFX07MSDW.prw:720` (pública `U_SFTabre`, usada também por DI2) · `AGE/SAFX07AGE.prw:658` (static) · `AGL/SAFX07AGL.prw:656` (static) · `AG2/07AG2SAFX.prw:740` (static) |
| `sf3abre()` | **5** | `SAFX07MSDW.prw:248` · `AGE/SAFX07AGE.prw:200` · `AGL/SAFX07AGL.prw:202` · `AG2/07AG2SAFX.prw:191` · `DI2/Di2SAFX07MSDW.prw:248` |
| `getSql()` do cabeçalho | **7** | `DHLSafx07.prw:44` · `AGE:71` · `AGL:72` · `AG2:79` · `DIS:52` · `MUL` · `DI2:44` |
| `getSql()`/`getSqlFt()` do item | **6** | `DHLSafx08.prw:76/109` · `AGE:76/109` · `AGL:76/109` · `AG2:76/109` · `DIS:76` · `MUL` |
| `addLine()` do cabeçalho | **7** | Uma por classe `DHLSafx07*` |
| `addLine()` do item | **6** | Uma por classe `DHLSafx08*` |

## 12. Divergência Medida entre Variantes

Medição por `Compare-Object` (linhas exclusivas de cada lado). Quantifica o custo de replicação.

| Comparação | Linhas base | Linhas variante | Só na base | Só na variante |
|---|---|---|---|---|
| `DHLSafx07` × `DHLSafx07Age` | 523 | 552 | 128 | 157 |
| `DHLSafx07` × `DHLSafx07Agl` | 523 | 582 | 130 | 189 |
| `DHLSafx07` × `DHLSafx07Dis` | 523 | 780 | 176 | 433 |
| `DHLSafx07` × `DHLSafx07Ag2` | 523 | 689 | 362 | 528 |
| `DHLSafx07` × `DHLSafx07Mul` | 523 | 489 | 376 | 342 |
| `DHLSafx07` × `Di2DHLSafx07` | 523 | 523 | **8** | **8** |
| `DHLSafx08` × `DHLSafx08Age` | 952 | 917 | 434 | 399 |
| `DHLSafx08` × `DHLSafx08Agl` | 952 | 918 | 434 | 400 |
| `DHLSafx08` × `DHLSafx08Dis` | 952 | 971 | 261 | 280 |
| `DHLSafx08` × `DHLSafx08Ag2` | 952 | 985 | 171 | 204 |
| `DHLSafx08` × `DHLSafx08Mul` | 952 | 924 | 254 | 226 |
| `SAFX07MSDW` × `SAFX07AGE` | 950 | 888 | 80 | 18 |
| `SAFX07MSDW` × `SAFX07AGL` | 950 | 886 | 94 | 30 |
| `SAFX07MSDW` × `SAFX07DIS` | 950 | 168 | 802 | 20 |
| `SAFX07MSDW` × `07AG2SAFX` | 950 | 979 | 709 | 738 |
| `SAFX07MSDW` × `07SAFXMUL` | 950 | 167 | 805 | 22 |
| `SAFX07MSDW` × `Di2SAFX07MSDW` | 950 | 736 | 231 | 17 |

> `Di2DHLSafx07` divergindo em apenas 8/8 linhas da base é o candidato mais óbvio a consolidação imediata.

## 13. Ordem de Ataque Recomendada

1. **Infraestrutura** (`DHLSafx.prw`) — resolve 100% da lógica de captação de IBS/CBS em um único arquivo.
2. **Protótipo padrão B** (`SAFX07MSDW` + `DHLSafx07` + `DHLSafx08`) — valida o desenho na unidade Default/PKG, que é a de maior cobertura.
3. **Protótipo padrão A** (`DIS`) — valida o segundo caminho de dados.
4. **Replicação** nas 5 variantes restantes (AGE, AGL, AG2, MUL, DI2), com checklist por variante.
5. **SAFX112/116** — somente se as Fases 1-2 do plano confirmarem necessidade.
6. **Layout** (`safx07.ch`/`safx08.ch`) — **última etapa**, pois depende da definição de destino (ver `CON-001` do plano: Mastersaf DW descontinuado).

> **Atenção à ordem:** o layout vem por último de propósito. Enquanto o destino (DW legado com campos reservados × ONESOURCE Tax One com SAFX3007/3008/3009) não estiver definido, qualquer `#define` de posição é retrabalho garantido.
