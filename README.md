# Ferramentas de segurança podem estar detectando menos vulnerabilidades em contratos inteligentes de blockchains

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

* **Artefatos Disponíveis (Selo D)**: O código e os dados estão disponíveis neste repositório estável no GitHub (ou GitLab/similar).

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

git clone git@github.com:RafaelAllves/SBSeg2025.git
cd SBSeg2025

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

O artefato foi projetado para reproduzir as principais reivindicações do artigo através da execução do script `analysis.py`, que processa os resultados pré-gerados do SmartBugs.

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

Este projeto está licenciado sob a licença **MIT License**.

```

MIT License

Copyright (c) 2025 Rafael Santa Rosa Alves

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```
