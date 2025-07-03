import os
import glob

# Diretório onde os arquivos estão localizados
base_dir = r"D:\siape\extracted_files"  # Altere para o caminho correto

# Função para renomear arquivos com base em seu nome
def renomear_arquivos(base_dir):
    # Filtrar os arquivos que contêm "Ativos" ou "Pensionistas" no nome
    arquivos = glob.glob(os.path.join(base_dir, "*.txt"))

    for arquivo in arquivos:
        base_name = os.path.basename(arquivo)
        
        # Renomear se o arquivo contiver "Ativos" no nome
        if "Ativos" in base_name:
            novo_nome = os.path.join(base_dir, "ConsolidadoServidor.txt")
            print(f"Renomeando {arquivo} para {novo_nome}...")
            os.rename(arquivo, novo_nome)
        
        # Renomear se o arquivo contiver "Pensionistas" no nome
        elif "Pensionistas" in base_name:
            novo_nome = os.path.join(base_dir, "ConsolidadoPensionista.txt")
            print(f"Renomeando {arquivo} para {novo_nome}...")
            os.rename(arquivo, novo_nome)

# Chamar a função para renomear os arquivos
renomear_arquivos(base_dir)
