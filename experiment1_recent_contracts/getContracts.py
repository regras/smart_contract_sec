"""
getContracts.py

Este script automatiza a coleta e o download de códigos-fonte de contratos inteligentes
verificados no Etherscan. Ele utiliza Selenium para raspar endereços de contratos
de páginas do Etherscan e, em seguida, a API do Etherscan para baixar o código-fonte
desses contratos.

É uma ferramenta auxiliar para a coleta de dados para análise de contratos.
"""

import requests
import os
import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup

# IMPORTANTE: Substitua pela sua chave da API Etherscan.
ETHERSCAN_API_KEY = "<YOUR_API_KEY>"


def get_verified_contracts_from_etherscan(pages=1):
    """
    Coleta endereços de contratos inteligentes verificados do Etherscan usando web scraping.

    Utiliza Selenium para navegar pelas páginas de contratos verificados do Etherscan
    e BeautifulSoup para extrair os endereços dos contratos.

    Args:
        pages (int, optional): O número de páginas do Etherscan a serem raspadas. Padrão para 1.

    Returns:
        list: Uma lista de strings, onde cada string é o endereço de um contrato.
    """
    options = Options()
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    # Define o local binário do Chromium. Pode precisar ser ajustado dependendo do seu SO.
    # Em alguns sistemas Linux, pode ser 'google-chrome' ou apenas 'chromium'.
    options.binary_location = "/usr/bin/chromium-browser"

    # Inicializa o WebDriver do Chrome
    driver = webdriver.Chrome(options=options)

    addresses = []

    for page in range(1, pages + 1):
        url = f"https://etherscan.io/contractsVerified/{page}"
        print(f"Acessando página de contratos: {url}")
        driver.get(url)
        # Pausa para permitir que a página carregue completamente e para contornar proteções como Cloudflare.
        time.sleep(10)

        soup = BeautifulSoup(driver.page_source, "html.parser")
        table = soup.find("table", class_="table")
        if not table:
            print(f"Tabela de contratos não encontrada na página {page}. Pulando.")
            continue

        # Encontra todas as linhas da tabela de contratos
        rows = table.find("tbody").find_all("tr")
        for row in rows:
            try:
                link = row.find("a", href=True)
                # Verifica se o link é um endereço de contrato e extrai o endereço
                if "/address/" in link["href"]:
                    address = link["href"].split("/address/")[1].split("#")[0]
                    addresses.append(address)
            except Exception as e:
                print(f"Erro ao extrair endereço de uma linha: {e}")

    print(f"\nTotal de endereços coletados: {len(addresses)}")
    driver.quit()  # Fecha o navegador após a coleta

    return addresses


def download_contracts_via_api(addresses):
    """
    Baixa o código-fonte de contratos inteligentes usando a API do Etherscan.

    Salva cada contrato em um arquivo separado dentro de um diretório 'contratos'.
    Lida com diferentes formatos de código-fonte (Solidity ou JSON para múltiplos arquivos).

    Args:
        addresses (list): Uma lista de endereços de contratos para baixar.
    """
    # Cria o diretório 'contratos' se ele não existir
    if not os.path.exists("contratos"):
        os.makedirs("contratos")

    for address in addresses:
        print(f"Buscando contrato via API: {address}")
        # Constrói a URL da API do Etherscan para obter o código-fonte
        url = f"https://api.etherscan.io/api?module=contract&action=getsourcecode&address={address}&apikey={ETHERSCAN_API_KEY}"

        try:
            resp = requests.get(url)
            data = resp.json()
            file_extension = "sol"  # Extensão padrão para arquivos Solidity

            if data["status"] == "1":
                source_code = data["result"][0]["SourceCode"]
                if not source_code.strip():  # Verifica se o código-fonte não está vazio
                    print(f"Sem código fonte para {address} na API.")
                    continue

                # Se o código-fonte começar e terminar com chaves, assume-se que é um JSON
                # contendo múltiplos arquivos Solidity (formato de verificação de contrato multi-arquivo).
                if source_code.startswith("{") and source_code.endswith("}"):
                    file_extension = "json"

                # Salva o código-fonte no diretório 'contratos'
                with open(
                    f"contratos/{address}.{file_extension}", "w", encoding="utf-8"
                ) as f:
                    f.write(source_code)
                print(f"Contrato salvo: contratos/{address}.{file_extension}")
            else:
                # Exibe mensagens de erro da API do Etherscan
                print(
                    f"Erro na API para {address}: {data.get('message', 'Desconhecido')}"
                )

        except requests.exceptions.RequestException as e:
            # Captura erros relacionados à requisição HTTP
            print(f"Falha na requisição HTTP para {address}: {e}")
        except Exception as e:
            # Captura outros erros inesperados durante o processamento
            print(f"Falha geral ao baixar contrato {address}: {e}")

        # Pausa breve para respeitar os limites de taxa da API do Etherscan
        time.sleep(0.25)


if __name__ == "__main__":
    # Define o número de páginas do Etherscan a serem raspadas.
    # Cada página contém 25 contratos.
    # Um valor de '20' significa a coleta de ~500 endereços.
    num_pages_to_scrape = 20

    # Coleta os endereços dos contratos verificados
    addresses = get_verified_contracts_from_etherscan(pages=num_pages_to_scrape)

    # Baixa o código-fonte para os endereços coletados
    if addresses:  # Garante que há endereços para baixar
        download_contracts_via_api(addresses)
    else:
        print("Nenhum endereço de contrato foi coletado para download.")
