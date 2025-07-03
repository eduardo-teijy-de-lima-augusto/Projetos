import subprocess
import os

# Diretório onde os arquivos .py estão localizados
script_dir = r"D:\AgetechSolutions\Projetos\Automacoes_Projetos\RotinaSiape"  # Altere para o caminho correto

# Lista dos arquivos .py a serem executados
scripts_para_executar = [
    '1_Extrai_Arquivos.py',  # Substitua pelos nomes reais dos seus scripts
    '2_D8.py',
    '3_RenomeiaConsolidados.py',
    '4_AVTXT.py',
    '5_Copia_Arquivos_Gerados.py',
    '6_Copia_Arquivos_Linux.py'
]

# Função para executar cada script usando subprocess
def executar_scripts(script_dir, scripts_para_executar):
    for script in scripts_para_executar:
        script_path = os.path.join(script_dir, script)
        try:
            print(f"Executando {script_path}...")
            subprocess.run(['python', script_path], check=True)
            print(f"{script} executado com sucesso!")
        except subprocess.CalledProcessError as e:
            print(f"Erro ao executar {script}: {e}")

# Chamar a função para executar os scripts
executar_scripts(script_dir, scripts_para_executar)
