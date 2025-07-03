import os
import shutil

# Diretório base onde os arquivos podem estar localizados (incluindo subpastas)
base_dir = r"D:\siape\extracted_files"
# Diretório de destino onde os arquivos serão copiados
dest_dir = r"D:\siape\insertsql"

# Lista dos arquivos que devem ser copiados
arquivos_gerados = [
    'PENS.TXT',
    'SERV.TXT',
    'ConsolidadoServidor.txt',
    'ConsolidadoPensionista.txt',
    'CCSiapePens.txt',
    'CCSiapeServ.txt'
]

# Verificar se a pasta de destino existe, se não, criar
if not os.path.exists(dest_dir):
    os.makedirs(dest_dir)

# Função para encontrar, copiar para insertsql e mover para 'Copiado'
def copiar_e_mover_arquivos(base_dir, dest_dir, arquivos_gerados):
    arquivos_encontrados = {arquivo: None for arquivo in arquivos_gerados}

    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file in arquivos_encontrados:
                caminho_completo_arquivo = os.path.join(root, file)
                destino_copia = os.path.join(dest_dir, file)

                # Copiar para a pasta central
                print(f"Copiando {file} para {destino_copia}")
                shutil.copy2(caminho_completo_arquivo, destino_copia)

                # Criar pasta 'Copiado' se não existir
                pasta_copiado = os.path.join(root, 'Copiado')
                if not os.path.exists(pasta_copiado):
                    os.makedirs(pasta_copiado)

                # Mover o arquivo original para a subpasta 'Copiado'
                destino_mover = os.path.join(pasta_copiado, file)
                print(f"Movendo {file} para {destino_mover}")
                shutil.move(caminho_completo_arquivo, destino_mover)

                # Marcar como encontrado
                arquivos_encontrados[file] = caminho_completo_arquivo

    # Informar arquivos não encontrados
    for arquivo, caminho in arquivos_encontrados.items():
        if caminho is None:
            print(f"Arquivo {arquivo} não encontrado nas subpastas.")

    print("Processo de cópia e movimentação concluído.")

# Executar a função
copiar_e_mover_arquivos(base_dir, dest_dir, arquivos_gerados)

