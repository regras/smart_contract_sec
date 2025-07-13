"""
analysis.py

Este script processa os resultados brutos do framework SmartBugs para análise estática
de contratos inteligentes Ethereum. Ele realiza limpeza de dados, categorização de
descobertas de vulnerabilidades e gera várias saídas estatísticas, incluindo
gráficos de barras para durações de ferramentas e arquivos CSV para contagens de descobertas,
contagens de falhas e distribuições de vulnerabilidades categorizadas para dois experimentos distintos.

O script foi projetado para ser autocontido e executado sem argumentos de linha de comando,
processando configurações de experimento predefinidas.
"""

import pandas as pd
import matplotlib.pyplot as plt


def plot_sorted_bar_chart(
    df, category_column, value_column, title, unit, log_scale=False
):
    """
    Gera um gráfico de barras horizontal ordenado a partir de um DataFrame.

    As barras são ordenadas em ordem decrescente com base na 'value_column'.
    O gráfico é salvo como um arquivo PNG com o título fornecido.
    Também calcula e imprime o tempo total de execução das ferramentas.

    Args:
        df (pd.DataFrame): O DataFrame de entrada contendo os dados.
        category_column (str): O nome da coluna a ser usada para o eixo Y (categorias).
        value_column (str): O nome da coluna a ser usada para o eixo X (valores).
        title (str): O título do gráfico, também usado como nome do arquivo para salvar.
        unit (str): A unidade dos valores (ex: "s" para segundos) a ser exibida no rótulo do eixo X.
        log_scale (bool, optional): Se True, aplica uma escala logarítmica ao eixo X. Padrão para False.
    """
    df_sorted = df.sort_values(by=value_column, ascending=False)

    # Calcular o tempo total de execução
    total_duration_seconds = df[value_column].sum()

    # Formatar o tempo total para leitura humana
    hours, remainder = divmod(total_duration_seconds, 3600)
    minutes, seconds = divmod(remainder, 60)
    time_str = ""
    if hours > 0:
        time_str += f"{int(hours)} horas "
    if minutes > 0:
        time_str += f"{int(minutes)} minutos "
    time_str += f"{int(seconds)} segundos"

    print(
        f"\nTempo total de execução do SmartBugs para {title.split(' - ')[-1].replace('.png', '')}: {time_str}\n"
    )

    plt.style.use("seaborn-v0_8-muted")

    plt.figure(figsize=(10, 6))
    plt.barh(
        df_sorted[category_column],
        df_sorted[value_column],
        color="skyblue",
        edgecolor="black",
    )
    if log_scale:
        plt.xscale("log")
    plt.xlabel(f"{value_column} ({unit})")
    plt.ylabel(category_column)
    plt.title(title, fontsize=16)
    plt.grid(axis="x", linestyle="--", alpha=0.7)
    plt.tight_layout()
    plt.savefig(f"{title}.png")


def categorize_findings(df_counts, csv_mapping_path, exp_num):
    """
    Categoriza as descobertas de segurança com base em um arquivo CSV de mapeamento fornecido.

    Esta função padroniza nomes de colunas, lê um arquivo de mapeamento e atribui
    uma 'categoria' a cada descoberta com base em tipos de vulnerabilidade predefinidos.
    Descobertas que não podem ser mapeadas são rotuladas como 'Other'.

    Args:
        df_counts (pd.DataFrame): DataFrame contendo as descobertas, tipicamente dos resultados do SmartBugs.
        csv_mapping_path (str): Caminho para o arquivo CSV contendo o mapeamento de vulnerabilidades.
        exp_num (int): Número do experimento (1 ou 2). Usado para diferenciar como as descobertas não mapeadas.

    Returns:
        pd.DataFrame: O DataFrame com uma coluna 'category' adicionada.
    """
    df_counts.columns = [col.strip().lower() for col in df_counts.columns]

    df_map = pd.read_csv(csv_mapping_path)
    df_map.columns = [col.strip() for col in df_map.columns]

    categories = [
        "access_control",
        "arithmetic",
        "denial_service",
        "reentrancy",
        "unchecked_low_calls",
        "bad_randomness",
        "front_running",
        "time_manipulation",
        "short_addresses",
        "Other",
    ]

    mapping_dict = {}
    for _, row in df_map.iterrows():
        vuln = row.get("Vulnerability name")
        if pd.notna(vuln):
            vuln = str(vuln).strip().lower()
            for cat in categories:
                if cat in row and pd.notna(row[cat]):
                    mapping_dict[vuln] = cat
                    break  # Mapeamento encontrado, passa para a próxima vulnerabilidade

    def get_category(finding):
        """Função auxiliar para obter a categoria de uma única descoberta."""
        key = str(finding).strip().lower()
        return mapping_dict.get(key, "Other" if exp_num == 1 else "Unmapped")

    df_counts["category"] = df_counts["findings"].apply(get_category)
    # Filtra as linhas que são explicitamente 'Unmapped'
    df_counts = df_counts[df_counts["category"] != "Unmapped"]

    return df_counts


def count_items(df, column, exp_num):
    """
    Conta as ocorrências de itens dentro de uma coluna específica do DataFrame.

    Esta função foi projetada para lidar com colunas onde os itens são armazenados como
    strings separadas por vírgulas dentro de chaves (ex: "{item1,item2}").
    Ela 'explode' essas strings em linhas individuais e então conta suas
    ocorrências, salvando o resultado em um arquivo CSV.

    Args:
        df (pd.DataFrame): O DataFrame de entrada.
        column (str): O nome da coluna cujos itens devem ser contados (ex: "findings", "fails").
        exp_num (int): Número do experimento, usado para nomear o arquivo CSV de saída.
    """
    # Limpa a coluna: remove chaves e divide em uma lista de strings
    df[column] = df[column].str.replace("{", "").str.replace("}", "").str.split(",")

    # Explode o DataFrame para ter uma linha por item na lista
    counts = (
        df.explode("toolid")
        .assign(tag_keys=df[column])
        .explode(column)
        .dropna(subset=[column])
        .groupby(["toolid", column])
        .size()
        .reset_index(name="count")
    )
    # Soma as contagens em todas as ferramentas para cada item, depois remove a coluna 'toolid'
    counts = counts.groupby(column).sum().reset_index().drop("toolid", axis=1)
    # Filtra strings vazias que podem resultar da divisão
    counts = counts[counts[column] != ""]
    counts = counts.sort_values("count", ascending=False)
    counts.to_csv(f"{column}_counts_exp{exp_num}.csv", index=False)


def analyze_categories(df, exp_num):
    """
    Analisa e categoriza as descobertas de segurança dos resultados do SmartBugs,
    calculando porcentagens com base no tipo de experimento.

    Para o Experimento 1, calcula a porcentagem de contratos afetados por
    cada categoria de vulnerabilidade. Para o Experimento 2, calcula a taxa de
    detecção (precisão) em relação a um conjunto de contagens de referência para vulnerabilidades conhecidas.

    Args:
        df (pd.DataFrame): O DataFrame de entrada contendo os resultados do SmartBugs.
        exp_num (int): O número do experimento (1 para contratos recentes, 2 para contratos curados).
    """

    # Contagens de referência para vulnerabilidades conhecidas no Experimento 2 (contratos curados).
    # Esses valores representam o número esperado de cada vulnerabilidade no conjunto de dados curado, usado para calcular as porcentagens de detecção.
    exp2_reference_counts = {
        "access_control": 19,
        "arithmetic": 22,
        "denial_service": 7,
        "reentrancy": 8,
        "unchecked_low_calls": 12,
        "front_running": 7,
        "time_manipulation": 5,
        "Other": 3,
    }

    # Limpa a coluna 'findings': remove chaves e divide em uma lista de strings
    df["findings"] = (
        df["findings"].str.replace("{", "").str.replace("}", "").str.split(",")
    )
    # Explode o DataFrame: uma linha por basename e finding
    exploded_df = (
        df.explode("basename")
        .assign(tag_keys=df["findings"])
        .explode("findings")
        .dropna(subset=["findings"])
    )
    total_contracts = len(df["basename"].unique())
    print("TOTAL CONTRACTS:", total_contracts)

    # Filtra strings vazias da coluna 'findings'
    exploded_df = exploded_df[exploded_df["findings"] != ""]
    # Categoriza as descobertas usando a função auxiliar
    categorized_df = categorize_findings(
        exploded_df, "vulnerabilities_mapping.csv", exp_num
    )
    # Seleciona as colunas relevantes para agregação
    categorized_df = categorized_df[["basename", "category", "findings"]]
    # Agrupa por categoria e conta basenames (contratos) e descobertas únicas
    df_category_counts = categorized_df.groupby(["category"]).nunique().reset_index()
    df_category_counts = df_category_counts.rename(columns={"basename": "Contracts"})

    if exp_num == 1:
        # Para o Experimento 1, calcula a porcentagem de contratos afetados
        df_category_counts = df_category_counts.drop(columns=["findings"])
        df_category_counts["%"] = (
            df_category_counts["Contracts"] / total_contracts
        ) * 100
    else:  # exp_num == 2
        # Para o Experimento 2, calcula a porcentagem de detecção (precisão)
        df_category_counts = df_category_counts.drop(columns=["Contracts"])
        # Mapeia a categoria para sua contagem de referência; padrão para 1 para evitar divisão por zero
        df_category_counts["%"] = df_category_counts["category"].apply(
            lambda x: exp2_reference_counts[x] if x in exp2_reference_counts else 1
        )
        # Calcula a porcentagem de descobertas detectadas em relação às contagens de referência
        df_category_counts["%"] = (
            df_category_counts["findings"] / df_category_counts["%"]
        ) * 100

    print(df_category_counts)
    df_category_counts.to_csv(
        f"contracts_by_vulnerability_exp{exp_num}.csv", index=False
    )


if __name__ == "__main__":
    # Configuração para os dois experimentos
    experiments_config = [
        {"filename": "experiment1_recent_contracts/results_exp1.csv", "exp_num": 1},
        {"filename": "experiment2_curated_contracts/results_exp2.csv", "exp_num": 2},
    ]

    # Itera sobre cada configuração de experimento
    for exp_data in experiments_config:
        file_path = exp_data["filename"]
        experiment_number = exp_data["exp_num"]

        print(f"\n--- Processando experimento {file_path} ---")

        df_main = pd.read_csv(file_path)
        df_summary = df_main.groupby("toolid").sum().reset_index()

        plot_sorted_bar_chart(
            df_summary,
            "toolid",
            "duration",
            f"Duration - {file_path.split('/')[-1].replace('.csv', '')}",
            "s",
            log_scale=True,
        )

        # Chama as funções de análise para o experimento atual
        count_items(df_main.copy(), "findings", experiment_number)
        count_items(df_main.copy(), "fails", experiment_number)
        analyze_categories(df_main.copy(), experiment_number)
        print("-" * 50)
