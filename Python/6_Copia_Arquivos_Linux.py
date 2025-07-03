import os
import paramiko
from scp import SCPClient

# Diretório base onde os arquivos podem estar localizados (incluindo subpastas)
base_dir = r"D:\\siape\\extracted_files"  # Altere para o caminho correto

# Detalhes do servidor Linux
linux_host = "192.168.201.11"
linux_user = "automacao"
linux_password = "B@uT0m@ç@0!2025$"
dest_dir_linux = "/mnt/sharewindows"

# Lista dos arquivos que devem ser copiados (nomes exatos, independente da pasta)
arquivos_gerados = [
    'PENS.TXT',
    'SERV.TXT',
    'ConsolidadoServidor.txt',
    'ConsolidadoPensionista.txt',
    'CCSiapePens.txt',
    'CCSiapeServ.txt'
]

# Função para excluir arquivos do diretório remoto
def limpar_diretorio_remoto(ssh_client, dest_dir):
    stdin, stdout, stderr = ssh_client.exec_command(f"rm -rf {dest_dir}/*")
    stdout.channel.recv_exit_status()  # Esperar o comando concluir
    print(f"Todos os arquivos em {dest_dir} foram excluídos no servidor Linux.")

# Função para encontrar e copiar os arquivos gerados nas subpastas para o servidor Linux
def copiar_arquivos_via_scp(base_dir, dest_dir_linux, arquivos_gerados):
    # Criar cliente SSH e conectar ao servidor
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(linux_host, username=linux_user, password=linux_password)

    try:
        # Limpar o diretório remoto antes de copiar os arquivos
        limpar_diretorio_remoto(ssh, dest_dir_linux)
        print("*********************************************************************************************************************************************************")
        print("****************************                                                                   **********************************************************")
        print("**************************** Se necessário acesse via SSH no servidor para validar o delete    **********************************************************")
        print("****************************                  Caso esteja OK, PRESSIONE ENTER                  **********************************************************")
        print("****************************                                                                   **********************************************************")
        input("*********************************************************************************************************************************************************")

        # Criar cliente SCP
        with SCPClient(ssh.get_transport()) as scp:
            arquivos_encontrados = {arquivo: None for arquivo in arquivos_gerados}

            # Percorrer todas as subpastas do diretório base
            for root, dirs, files in os.walk(base_dir):
                for file in files:
                    if file in arquivos_encontrados:
                        caminho_completo_arquivo = os.path.join(root, file)

                        # Ajustar separadores de caminho para compatibilidade com Linux
                        destino_remoto = os.path.join(dest_dir_linux, file).replace("\\", "/")

                        # Copiar o arquivo para o diretório remoto
                        print(f"Copiando {caminho_completo_arquivo} para {destino_remoto}...")
                        scp.put(caminho_completo_arquivo, destino_remoto)

                        # Marcar o arquivo como encontrado
                        arquivos_encontrados[file] = caminho_completo_arquivo

            # Verificar se algum arquivo não foi encontrado
            for arquivo, caminho in arquivos_encontrados.items():
                if caminho is None:
                    print(f"Arquivo {arquivo} não encontrado nas subpastas.")

        print("Cópia concluída!")

    finally:
        # Fechar conexão SSH
        ssh.close()

# Chamar a função para procurar e copiar os arquivos nas subpastas
copiar_arquivos_via_scp(base_dir, dest_dir_linux, arquivos_gerados)