# Ferramentas de segurança podem estar detectando menos vulnerabilidades em contratos inteligentes de blockchains

## 📂 Estrutura do `README.md`

Esta seção descreve como o `README.md` está organizado, facilitando a navegação e compreensão do conteúdo.

1. **[📌 Resumo do Projeto](#-resumo-do-projeto)**  
   Apresenta o contexto, objetivo e escopo do trabalho, incluindo uma visão geral dos experimentos conduzidos e um resumo do artigo submetido ao SBSEG 2025.

2. **[📁 Estrutura do Repositório](#-estrutura-do-repositório)**  
   Lista a organização de pastas e arquivos do projeto, explicando a função de cada item, como scripts, datasets e resultados de análise.

3. **[🌟 Selos Considerados](#-selos-considerados)**  
   Indica os selos de avaliação do SBSEG visados pelo artefato, com explicações sobre os critérios atendidos.

4. **[ℹ️ Informações Básicas](#ℹ️-informações-básicas)**  
   Especifica os requisitos de hardware, software e ambiente para execução e reprodução dos experimentos.

5. **[📦 Dependências](#-dependências)**  
   Lista as bibliotecas Python e ferramentas necessárias, com instruções de instalação.

6. **[⚠️ Preocupações com Segurança](#️-preocupações-com-segurança)**  
   Informa sobre potenciais riscos, medidas de segurança adotadas e boas práticas para execução segura.

7. **[🛠️ Instalação](#️-instalação)**  
   Passo a passo para configurar o ambiente, incluindo criação de ambiente virtual e instalação de dependências.

8. **[✅ Teste Mínimo](#-teste-mínimo)**  
   Procedimento rápido para verificar se o ambiente está configurado corretamente e se o script principal funciona como esperado.

9. **[🔬 Experimentos](#-experimentos)**  
   Explica detalhadamente como reproduzir cada experimento, com arquivos de entrada/saída esperados e descrição das principais reivindicações do artigo.

10. **[📄 LICENSE](#-license)**  
    Informa a licença do projeto, neste caso **Creative Commons CC0 1.0 Universal**, com o texto legal completo.



## 📌 Resumo do Projeto

Este repositório contém o dataset, scripts e resultados utilizados no estudo submetido ao SBSEG 2025, intitulado "**Ferramentas de segurança podem estar detectando menos vulnerabilidades em contratos inteligentes de blockchains**". O objetivo principal do artigo e deste artefato é avaliar a evolução e a eficácia de ferramentas automatizadas de análise de vulnerabilidades para contratos inteligentes Ethereum, utilizando a estrutura SmartBugs.

O projeto reproduz e expande o estudo original SmartBugs de 2020 através de dois experimentos distintos:

* **Experimento 1 – Contratos Recentes**: Avalia a distribuição de vulnerabilidades em 215 contratos recentemente implantados e verificados no Etherscan. Este experimento foca em entender a paisagem de segurança de contratos do "mundo real" e as capacidades das ferramentas em identificar problemas em um conjunto de dados não curado.

* **Experimento 2 – Contratos Curados**: Avalia a precisão da detecção das ferramentas ao reaplicá-las aos mesmos contratos vulneráveis intencionalmente criados e usados no estudo de 2020 (conjunto `smartbugs-curated`). Este experimento serve para comparar diretamente com os resultados originais e analisar a melhoria ou regressão das ferramentas ao longo do tempo.

### Resumo do artigo

A segurança de contratos inteligentes continua sendo um desafio na blockchain Ethereum. Este artigo investiga a evolução de ferramentas de análise de segurança por meio de dois experimentos com a estrutura SmartBugs. 
O primeiro analisou 215 contratos do Etherscan verificados recentemente, focando nas vulnerabilidades detectadas. 
O segundo replicou um estudo de 2020, usando o mesmo conjunto de contratos com vulnerabilidades, mas com  ferramentas atualizadas. 
Resultados indicam defasagem da taxonomia DASP Top 10 e uma queda na precisão de detecção (de 41,74% para 24,4%), tal regressão levanta dúvidas sobre o real progresso das ferramentas.

## 📁 Estrutura do Repositório

Este repositório está organizado da seguinte forma para facilitar a navegação e a compreensão do artefato:

```

.
├── analysis.py                       # Script principal para análise e agregação de dados de vulnerabilidades.
│
├── vulnerabilities_mapping.csv       # Arquivo CSV que mapeia as descobertas (findings) das ferramentas.
│
├── experiment1_recent_contracts/     # Diretório dedicado ao Experimento 1 (Contratos Recentes)
│   │
│   ├── getContracts.py               # Script Python utilizado para coletar automaticamente os contratos recentes do Etherscan.
│   │
│   ├── contracts/                    # Contém os 215 contratos Solidity coletados automaticamente para o Experimento 1.
│   │
│   └── results_exp1.csv              # Resultados da análise do SmartBugs para os contratos do Experimento 1.
│
├── experiment2_curated_contracts/    # Diretório dedicado ao Experimento 2 (Contratos Curados)
│   │
│   ├── contracts/                    # Contém o conjunto de contratos `smartbugs-curated`, com bugs intencionais.
│   │
│   └── results_exp2.csv              # Resultados da análise do SmartBugs para os contratos do Experimento 2.
│
└── README.md                         # Este arquivo de documentação.

```

## 🌟 Selos Considerados

Os selos considerados para este artefato no processo de avaliação do SBSEG são:

* **Artefatos Disponíveis (Selo D)**: O código e os dados estão disponíveis neste repositório estável no GitHub.

* **Artefatos Funcionais (Selo F)**: O artefato pode ser executado e permite que o revisor observe suas funcionalidades básicas, conforme demonstrado no teste mínimo.

* **Artefatos Sustentáveis (Selo S)**: O código é modularizado, organizado, inteligível e possui documentação interna (docstrings para funções e comentários inline para lógicas complexas), facilitando a compreensão.

* **Experimentos Reprodutíveis (Selo R)**: As instruções detalhadas são fornecidas para reproduzir as principais reivindicações apresentadas no artigo, utilizando o script `analysis.py` que processa os dados pré-gerados, garantindo a reprodutibilidade dos resultados.

## ℹ️ Informações Básicas

Esta seção detalha o ambiente necessário para a execução e replicação dos experimentos.

### Requisitos de Hardware

* **Processador (CPU):** Mínimo de 2 Cores. Recomenda-se 4 Cores ou mais para agilizar a execução dos experimentos completos (se optar por rodar o SmartBugs do zero).

* **Memória RAM:** Mínimo de 8 GB. Recomenda-se 16 GB ou mais para um desempenho ideal, especialmente durante a execução do SmartBugs (se optar por rodá-lo localmente).

* **Espaço em Disco:** Mínimo de 5 GB de espaço livre em disco. Este espaço é necessário para o repositório, dependências, imagens Docker do SmartBugs (se aplicável) e os arquivos de resultados gerados.

### Requisitos de Software

* **Sistema Operacional:** Linux (Ubuntu 20.04+ ou equivalente). Compatível com macOS. Windows Subsystem for Linux (WSL2) no Windows também é uma opção viável.
  * **Sistema Usado:**  Ubuntu 22.04.5 LTS.

* **Python:** Versão 3.8 ou superior.

  * **Versão Testada:** Python 3.10.12

* **Docker:** Versão 20.10.x ou superior. O Docker é essencial para a execução do SmartBugs, que utiliza contêineres para as ferramentas de análise. (Necessário apenas se você for gerar os arquivos `results_expX.csv` do zero).

  * **Versão Testada:** Docker Engine 27.5.1

### Ambiente de Execução Sugerido

Recomenda-se a utilização de uma máquina virtual (VM) para garantir a consistência do ambiente de execução e a reprodutibilidade. As instruções abaixo assumem um ambiente Linux.

## 📦 Dependências

As dependências principais para a execução da análise (pós-SmartBugs) são gerenciadas via `pip` no Python.

### Dependências do Python:

As seguintes bibliotecas Python são necessárias para o script `analysis.py`:

* `pandas`: Para manipulação e análise de dados tabulares.

* `matplotlib`: Para a criação de gráficos estáticos.

* `seaborn`: Para aprimorar a estética dos gráficos do matplotlib.

Você pode instalar essas dependências usando `pip`:

```

pip install pandas matplotlib seaborn

```

* **Versões Testadas:**

  * `pandas`: 2.2.1

  * `matplotlib`: 3.8.2

  * `seaborn`: 0.13.2

### Ferramentas de Terceiros (SmartBugs Framework):

O SmartBugs é a ferramenta principal utilizada para a análise estática dos contratos. Os arquivos `results_exp1.csv` e `results_exp2.csv` com os resultados brutos da análise já estão **incluídos no repositório**, o que significa que **você não precisa executar o SmartBugs** para reproduzir as reivindicações do artigo.

No entanto, se você deseja **executar o SmartBugs do zero** para gerar esses arquivos (o que é uma reprodução mais completa, mas mais demorada, cerca 120 horas), você precisará:

1. **Clonar o repositório SmartBugs:**

```

git clone https://github.com/smartbugs/smartbugs.git

```

2. **Instalar dependências do SmartBugs:** Siga as instruções de instalação detalhadas no README do SmartBugs (geralmente envolve a instalação de dependências do sistema e configuração do Docker). O SmartBugs gerencia automaticamente as imagens Docker das ferramentas de análise.


## ⚠️ Preocupações com Segurança

A execução deste artefato **não oferece riscos significativos** para os avaliadores, desde que as instruções sejam seguidas.

* O script `analysis.py` apenas lê arquivos CSV e gera novos arquivos CSV e imagens PNG. Ele não interage com a rede, não requer privilégios de root (além da instalação inicial de dependências do sistema, se aplicável) e não modifica arquivos do sistema fora do diretório do projeto.

* As análises de contrato com o SmartBugs (se você optar por reproduzi-las) são executadas em contêineres Docker isolados, minimizando qualquer risco de impacto no sistema host.

* O script `getContracts.py` (dentro de `experiment1_recent_contracts/`) se conecta à API do Etherscan para coletar dados, mas não executa código perigoso. Se for usá-lo, certifique-se de usar uma chave de API válida, que deve ser tratada como informação privada e não deve ser exposta no código ou no repositório público.

**Medidas de Segurança para Revisores:**
Recomenda-se que a instalação e execução do artefato sejam feitas em um **ambiente isolado**, como uma máquina virtual (VM). Isso garante que quaisquer dependências ou arquivos gerados fiquem contidos nesse ambiente.

## 🛠️ Instalação

Siga os passos abaixo para instalar e preparar o ambiente para a execução do artefato.

1. **Clone o Repositório:**
Abra um terminal e clone este repositório para o seu sistema:

```

git clone git@github.com:regras/smart_contract_sec.git
cd smart_contract_sec

```

2. **Crie e Ative um Ambiente Virtual (Recomendado):**
É uma boa prática criar um ambiente virtual Python para gerenciar as dependências do projeto isoladamente:

```

python3 -m venv venv
source venv/bin/activate

```

*Para desativar o ambiente virtual, use `deactivate`.*

3. **Instale as Dependências Python:**
Com o ambiente virtual ativado, instale as bibliotecas Python necessárias:

```

pip install pandas matplotlib seaborn

```

4. **Configure os Parâmetros no `config.json`:**

O arquivo `config.json` contém os caminhos de entrada (resultados brutos e tabelas de mapeamento).
Por padrão, o repositório já vem configurado para rodar diretamente, mas você pode ajustar os caminhos no `config.json` caso queira alterar diretórios ou nomes de arquivos.

```json
{
  "experiments": {
      "exp1": "experiment1_recent_contracts/results_exp1.csv",
      "exp2": "experiment2_curated_contracts/results_exp2.csv"
  },
  "vulnerabilities_mapping": {
      "access_control": 19,
      "arithmetic": 22,
      "denial_service": 7,
      "reentrancy": 8,
      "unchecked_low_calls": 12,
      "front_running": 7,
      "time_manipulation": 5,
      "Other": 3
   }
}
```

Ao final desses passos, o ambiente estará configurado para rodar o script de análise. Os arquivos de resultados do SmartBugs já estão incluídos no repositório, então você não precisa rodar o SmartBugs para os testes mínimos e reprodução dos experimentos, a menos que queira gerar os dados brutos novamente.

## ✅ Teste Mínimo

Para verificar se a instalação foi bem-sucedida e o script de análise funciona corretamente, execute o seguinte teste mínimo. Ele processará os dados existentes e gerará os arquivos de saída.

1. **Navegue até o diretório raiz do projeto** (onde o `analysis.py` está localizado) se ainda não estiver lá:


2. **Execute o script de análise:**

```

python3 analysis.py

```

**Resultados Esperados:**
Após a execução, você deverá ver a seguinte saída no terminal para cada experimento (Experiment 1 e Experiment 2):

* Mensagens de progresso indicando o processamento de cada experimento, como:

```

## \--- Processing experiment experiment1\_recent\_contracts/results\_exp1.csv --- TOTAL CONTRACTS: [Número de contratos] ... (tabela de resultados) ...

## \--- Processing experiment experiment2\_curated\_contracts/results\_exp2.csv --- TOTAL CONTRACTS: [Número de contratos] ... (tabela de resultados) ...

```

* Seis arquivos CSV no diretório raiz do projeto:

* `findings_counts_exp1.csv`

* `fails_counts_exp1.csv`

* `contracts_by_vulnerability_exp1.csv`

* `findings_counts_exp2.csv`

* `fails_counts_exp2.csv`

* `contracts_by_vulnerability_exp2.csv`

* Duas imagens PNG no diretório raiz do projeto:

* `Duration - results_exp1.png`

* `Duration - results_exp2.png`

A presença desses arquivos e imagens confirma que o script `analysis.py` está funcionando conforme o esperado.

## 🔬 Experimentos

Esta seção descreve os passos para a execução completa dos experimentos e a obtenção dos resultados apresentados no artigo.

O artefato foi projetado para reproduzir as principais reivindicações do artigo através da execução do script `analysis.py`, que lê os caminhos configurados em `config.json` e processa os resultados pré-gerados do SmartBugs (já incluídos no repositório). As principais reivindicações do artigo podem ser reproduzidas sem necessidade de executar o SmartBugs, pois os resultados brutos já estão incluídos no repositório.

**Tempo Esperado de Execução:** A execução do script `analysis.py` é **rápida**, levando aproximadamente **2 segundos** para ser concluída em um ambiente com os requisitos de hardware recomendados. O tempo é dominado pela leitura dos arquivos CSV e operações de DataFrame do pandas.

**Recursos Esperados:** Durante a execução, o script `analysis.py` deve consumir aproximadamente **~128 MB de RAM** e gerar **~116 KB de arquivos** (CSV e PNGs) em disco.

### Reivindicação 1: Análise da Distribuição de Vulnerabilidades em Contratos Recentes (Experimento 1)

**Objetivo:** Reproduzir a análise da distribuição e categorização de vulnerabilidades encontradas em 215 contratos recentes do Etherscan, conforme apresentado na tabela relacionada ao Experimento 1 no artigo. Esta reivindicação demonstra a distribuição de vulnerabilidades em contratos "do mundo real".

**Processo de Execução:**

1. Certifique-se de ter seguido as etapas de `Instalação` e que todas as dependências estão configuradas.

2. Navegue até o diretório raiz do projeto:

3. Execute o script principal de análise. O script processará os dados do `experiment1_recent_contracts/results_exp1.csv` automaticamente como parte da execução completa:

```

python3 analysis.py

```

**Arquivos de Configuração/Entrada:**

* `experiment1_recent_contracts/results_exp1.csv`: Contém os resultados brutos da execução das ferramentas do SmartBugs sobre os contratos recentes.

* `vulnerabilities_mapping.csv`: Usado para categorizar as `findings` (descobertas das ferramentas) em categorias padronizadas (DASP Top 10).

**Saída Esperada:**
Ao final da execução, você terá os seguintes arquivos gerados para o Experimento 1 no diretório raiz do projeto:

* **`findings_counts_exp1.csv`**: Uma tabela CSV com a contagem total de cada tipo de "finding" (vulnerabilidade específica reportada pelas ferramentas) no Experimento 1.

* **`fails_counts_exp1.csv`**: Uma tabela CSV com a contagem de falhas por ferramenta (ex: erros de execução, timeouts) no Experimento 1.

* **`contracts_by_vulnerability_exp1.csv`**: Uma tabela CSV crucial que mostra a contagem de **contratos únicos afetados** por cada categoria de vulnerabilidade (ex: `access_control`, `reentrancy`) no Experimento 1, juntamente com a porcentagem de contratos afetados em relação ao total (`%`). **Esta tabela corresponde diretamente às informações de distribuição de vulnerabilidades e é uma das principais reivindicações do artigo.**

* **`Duration - results_exp1.png`**: Um gráfico de barras horizontal mostrando a duração total da execução por ferramenta no SmartBugs para o Experimento 1. Este gráfico ilustra o desempenho de tempo das ferramentas.

### Reivindicação 2: Análise de Precisão de Detecção em Contratos Curados (Experimento 2)

**Objetivo:** Reproduzir a análise da precisão das ferramentas na detecção de vulnerabilidades conhecidas em um conjunto de contratos com bugs intencionais (`smartbugs-curated`), conforme apresentado nas Figuras/Tabelas relacionadas ao Experimento 2 no artigo. Esta reivindicação foca na capacidade das ferramentas em identificar vulnerabilidades **previamente conhecidas** e serve para avaliar a acurácia.

**Processo de Execução:**

1. Certifique-se de que o ambiente está configurado (ver `Instalação`).

2. Navegue até o diretório raiz do projeto:

3. Execute o script principal de análise. O script processará os dados do `experiment2_curated_contracts/results_exp2.csv` automaticamente, aplicando a lógica específica de cálculo de precisão para este experimento:

```

python3 analysis.py

```

**Arquivos de Configuração/Entrada:**

* `experiment2_curated_contracts/results_exp2.csv`: Contém os resultados brutos da execução das ferramentas do SmartBugs sobre os contratos curados.

* `vulnerabilities_mapping.csv`: Usado para categorizar as `findings` em categorias padronizadas.

* O dicionário `exp2_reference_counts` dentro da função `analyze_categories` no `analysis.py` é a "fonte da verdade" para o número esperado de cada tipo de vulnerabilidade no conjunto curado. Ele é usado para calcular a porcentagem de detecção (precisão).

**Saída Esperada:**
Ao final da execução, você terá os seguintes arquivos gerados para o Experimento 2 no diretório raiz do projeto:

* **`findings_counts_exp2.csv`**: Uma tabela CSV com a contagem total de cada tipo de "finding" no Experimento 2.

* **`fails_counts_exp2.csv`**: Uma tabela CSV com a contagem de falhas por ferramenta no Experimento 2.

* **`contracts_by_vulnerability_exp2.csv`**: Uma tabela CSV que mostra a contagem de `findings` por categoria e, mais importante, a **porcentagem de detecção** (`%`) para cada categoria. **Esta tabela corresponde diretamente às informações de precisão/detecção de vulnerabilidades e é outra principal reivindicação do artigo.**

* **`Duration - results_exp2.png`**: Um gráfico de barras horizontal mostrando a duração total da execução por ferramenta no SmartBugs para o Experimento 2.

## 📄 LICENSE

Este projeto está licenciado sob a licença **Creative Commons CC0 1.0 Universal**.

```

Creative Commons Legal Code

CC0 1.0 Universal

    CREATIVE COMMONS CORPORATION IS NOT A LAW FIRM AND DOES NOT PROVIDE
    LEGAL SERVICES. DISTRIBUTION OF THIS DOCUMENT DOES NOT CREATE AN
    ATTORNEY-CLIENT RELATIONSHIP. CREATIVE COMMONS PROVIDES THIS
    INFORMATION ON AN "AS-IS" BASIS. CREATIVE COMMONS MAKES NO WARRANTIES
    REGARDING THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS
    PROVIDED HEREUNDER, AND DISCLAIMS LIABILITY FOR DAMAGES RESULTING FROM
    THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS PROVIDED
    HEREUNDER.

Statement of Purpose

The laws of most jurisdictions throughout the world automatically confer
exclusive Copyright and Related Rights (defined below) upon the creator
and subsequent owner(s) (each and all, an "owner") of an original work of
authorship and/or a database (each, a "Work").

Certain owners wish to permanently relinquish those rights to a Work for
the purpose of contributing to a commons of creative, cultural and
scientific works ("Commons") that the public can reliably and without fear
of later claims of infringement build upon, modify, incorporate in other
works, reuse and redistribute as freely as possible in any form whatsoever
and for any purposes, including without limitation commercial purposes.
These owners may contribute to the Commons to promote the ideal of a free
culture and the further production of creative, cultural and scientific
works, or to gain reputation or greater distribution for their Work in
part through the use and efforts of others.

For these and/or other purposes and motivations, and without any
expectation of additional consideration or compensation, the person
associating CC0 with a Work (the "Affirmer"), to the extent that he or she
is an owner of Copyright and Related Rights in the Work, voluntarily
elects to apply CC0 to the Work and publicly distribute the Work under its
terms, with knowledge of his or her Copyright and Related Rights in the
Work and the meaning and intended legal effect of CC0 on those rights.

1. Copyright and Related Rights. A Work made available under CC0 may be
protected by copyright and related or neighboring rights ("Copyright and
Related Rights"). Copyright and Related Rights include, but are not
limited to, the following:

  i. the right to reproduce, adapt, distribute, perform, display,
     communicate, and translate a Work;
 ii. moral rights retained by the original author(s) and/or performer(s);
iii. publicity and privacy rights pertaining to a person's image or
     likeness depicted in a Work;
 iv. rights protecting against unfair competition in regards to a Work,
     subject to the limitations in paragraph 4(a), below;
  v. rights protecting the extraction, dissemination, use and reuse of data
     in a Work;
 vi. database rights (such as those arising under Directive 96/9/EC of the
     European Parliament and of the Council of 11 March 1996 on the legal
     protection of databases, and under any national implementation
     thereof, including any amended or successor version of such
     directive); and
vii. other similar, equivalent or corresponding rights throughout the
     world based on applicable law or treaty, and any national
     implementations thereof.

2. Waiver. To the greatest extent permitted by, but not in contravention
of, applicable law, Affirmer hereby overtly, fully, permanently,
irrevocably and unconditionally waives, abandons, and surrenders all of
Affirmer's Copyright and Related Rights and associated claims and causes
of action, whether now known or unknown (including existing as well as
future claims and causes of action), in the Work (i) in all territories
worldwide, (ii) for the maximum duration provided by applicable law or
treaty (including future time extensions), (iii) in any current or future
medium and for any number of copies, and (iv) for any purpose whatsoever,
including without limitation commercial, advertising or promotional
purposes (the "Waiver"). Affirmer makes the Waiver for the benefit of each
member of the public at large and to the detriment of Affirmer's heirs and
successors, fully intending that such Waiver shall not be subject to
revocation, rescission, cancellation, termination, or any other legal or
equitable action to disrupt the quiet enjoyment of the Work by the public
as contemplated by Affirmer's express Statement of Purpose.

3. Public License Fallback. Should any part of the Waiver for any reason
be judged legally invalid or ineffective under applicable law, then the
Waiver shall be preserved to the maximum extent permitted taking into
account Affirmer's express Statement of Purpose. In addition, to the
extent the Waiver is so judged Affirmer hereby grants to each affected
person a royalty-free, non transferable, non sublicensable, non exclusive,
irrevocable and unconditional license to exercise Affirmer's Copyright and
Related Rights in the Work (i) in all territories worldwide, (ii) for the
maximum duration provided by applicable law or treaty (including future
time extensions), (iii) in any current or future medium and for any number
of copies, and (iv) for any purpose whatsoever, including without
limitation commercial, advertising or promotional purposes (the
"License"). The License shall be deemed effective as of the date CC0 was
applied by Affirmer to the Work. Should any part of the License for any
reason be judged legally invalid or ineffective under applicable law, such
partial invalidity or ineffectiveness shall not invalidate the remainder
of the License, and in such case Affirmer hereby affirms that he or she
will not (i) exercise any of his or her remaining Copyright and Related
Rights in the Work or (ii) assert any associated claims and causes of
action with respect to the Work, in either case contrary to Affirmer's
express Statement of Purpose.

4. Limitations and Disclaimers.

 a. No trademark or patent rights held by Affirmer are waived, abandoned,
    surrendered, licensed or otherwise affected by this document.
 b. Affirmer offers the Work as-is and makes no representations or
    warranties of any kind concerning the Work, express, implied,
    statutory or otherwise, including without limitation warranties of
    title, merchantability, fitness for a particular purpose, non
    infringement, or the absence of latent or other defects, accuracy, or
    the present or absence of errors, whether or not discoverable, all to
    the greatest extent permissible under applicable law.
 c. Affirmer disclaims responsibility for clearing rights of other persons
    that may apply to the Work or any use thereof, including without
    limitation any person's Copyright and Related Rights in the Work.
    Further, Affirmer disclaims responsibility for obtaining any necessary
    consents, permissions or other rights required for any use of the
    Work.
 d. Affirmer understands and acknowledges that Creative Commons is not a
    party to this document and has no duty or obligation with respect to
    this CC0 or use of the Work.


```
