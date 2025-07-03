import subprocess
import os
import glob

# Caminho completo do 7-Zip executável (ajuste se necessário)
seven_zip_path = r"C:\Program Files\7-Zip\7z.exe"

# Diretório onde os arquivos .rar estão localizados
rar_dir = r"D:\siape"
extract_dir = r"D:\siape\extracted_files"

# Verificar se o diretório de extração existe, se não, criar
if not os.path.exists(extract_dir):
    os.makedirs(extract_dir)

# Encontrar qualquer arquivo .rar no diretório
rar_files = glob.glob(os.path.join(rar_dir, "*.rar"))

# Verificar se algum arquivo .rar foi encontrado
if rar_files:
    for rar_file_path in rar_files:
        try:
            print(f"Verificando acesso ao arquivo {rar_file_path}...")
            # Verificar se o arquivo é legível
            if not os.path.isfile(rar_file_path):
                print(f"Arquivo {rar_file_path} não é legível ou não existe.")
                continue

            print(f"Descompactando {rar_file_path} usando 7-Zip...")
            # Usar o 7-Zip para descompactar o arquivo
            subprocess.run([seven_zip_path, 'x', rar_file_path, f'-o{extract_dir}'], check=True)
            print(f"Arquivo {rar_file_path} descompactado para {extract_dir}")
        except subprocess.CalledProcessError as e:
            print(f"Erro ao descompactar {rar_file_path}: {e}")
else:
    print("Nenhum arquivo .rar encontrado no diretório.")

# Descompactando o arquivo D8
d8_dir = r"D:\SIAPE\extracted_files\D8"
extract_d8 = r"D:\SIAPE\extracted_files\D8"

# Verificar se o diretório de extração do D8 existe, se não, criar
if not os.path.exists(extract_d8):
    os.makedirs(extract_d8)

d8_files = glob.glob(os.path.join(d8_dir, "*.rar"))

# Verificar se algum arquivo .rar foi encontrado no diretório D8
if d8_files:
    for d8_files_path in d8_files:
        try:
            print(f"Verificando acesso ao arquivo {d8_files_path}...")
            # Verificar se o arquivo é legível
            if not os.path.isfile(d8_files_path):
                print(f"Arquivo {d8_files_path} não é legível ou não existe.")
                continue

            print(f"Descompactando {d8_files_path} usando 7-Zip...")
            # Usar o 7-Zip para descompactar o arquivo
            subprocess.run([seven_zip_path, 'x', d8_files_path, f'-o{extract_d8}'], check=True)
            print(f"Arquivo {d8_files_path} descompactado para {extract_d8}")
        except subprocess.CalledProcessError as e:
            print(f"Erro ao descompactar {d8_files_path}: {e}")
else:
    print("Nenhum arquivo .rar encontrado no diretório D8.")


# Descompactando o arquivo Consolidado
consolidado_dir = r"D:\SIAPE\extracted_files"
extract_consolidado = r"D:\SIAPE\extracted_files"

# Verificar se o diretório de extração do D8 existe, se não, criar
if not os.path.exists(extract_consolidado):
    os.makedirs(extract_consolidado)

consolidado_files = glob.glob(os.path.join(consolidado_dir, "*.rar"))

# Verificar se algum arquivo .rar foi encontrado no diretório D8
if consolidado_files:
    for consolidado_files_path in consolidado_files:
        try:
            print(f"Verificando acesso ao arquivo {consolidado_files_path}...")
            # Verificar se o arquivo é legível
            if not os.path.isfile(consolidado_files_path):
                print(f"Arquivo {consolidado_files_path} não é legível ou não existe.")
                continue

            print(f"Descompactando {consolidado_files_path} usando 7-Zip...")
            # Usar o 7-Zip para descompactar o arquivo
            subprocess.run([seven_zip_path, 'x', consolidado_files_path, f'-o{extract_consolidado}'], check=True)
            print(f"Arquivo {consolidado_files_path} descompactado para {extract_consolidado}")
        except subprocess.CalledProcessError as e:
            print(f"Erro ao descompactar {consolidado_files_path}: {e}")
else:
    print("Nenhum arquivo .rar encontrado no diretório D8.")