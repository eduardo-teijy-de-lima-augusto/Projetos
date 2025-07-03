import subprocess
import os
import glob
import shutil

# Caminho completo do 7-Zip executável (ajuste se necessário)
seven_zip_path = r"C:\Program Files\7-Zip\7z.exe"

# Diretório onde os arquivos .rar estão localizados
rar_dir = r"D:\siape\extracted_files\AVtxt"
avpens_dir = r"D:\siape\extracted_files\AVPENS"
avserv_dir = r"D:\siape\extracted_files\AVSERV"

# Arquivos finais onde o conteúdo será combinado
ccsiape_pens_file = os.path.join(avpens_dir, 'CCSiapePens.txt')
ccsiape_serv_file = os.path.join(avserv_dir, 'CCSiapeServ.txt')

# Verificar se os diretórios AVPENS e AVSERV existem, se não, criar
if not os.path.exists(avpens_dir):
    os.makedirs(avpens_dir)
if not os.path.exists(avserv_dir):
    os.makedirs(avserv_dir)

# Encontrar todos os arquivos .rar no diretório AVtxt
rar_files = glob.glob(os.path.join(rar_dir, "*.rar"))

# Mover os arquivos para as respectivas pastas
if rar_files:
    for rar_file_path in rar_files:
        try:
            # Verificar se o arquivo contém "pens" no nome e mover para AVPENS
            if "pens" in os.path.basename(rar_file_path).lower():
                print(f"Movendo {rar_file_path} para {avpens_dir}...")
                shutil.move(rar_file_path, avpens_dir)
                print(f"Arquivo {rar_file_path} movido para {avpens_dir}")
            # Verificar se o arquivo contém "serv" no nome e mover para AVSERV
            elif "serv" in os.path.basename(rar_file_path).lower():
                print(f"Movendo {rar_file_path} para {avserv_dir}...")
                shutil.move(rar_file_path, avserv_dir)
                print(f"Arquivo {rar_file_path} movido para {avserv_dir}")
        except Exception as e:
            print(f"Erro ao mover o arquivo {rar_file_path}: {e}")
else:
    print("Nenhum arquivo .rar encontrado no diretório AVtxt.")

# Função para descompactar apenas o primeiro arquivo de cada conjunto de volumes
def descompactar_primeiro_arquivo(rar_files, output_dir):
    # Filtrar os arquivos que são 'part01' para iniciar a extração
    first_parts = [f for f in rar_files if 'part01' in os.path.basename(f).lower()]
    
    if first_parts:
        for rar_file_path in first_parts:
            try:
                print(f"Descompactando {rar_file_path} em {output_dir} usando 7-Zip...")
                subprocess.run([seven_zip_path, 'x', rar_file_path, f'-o{output_dir}'], check=True)
                print(f"Arquivo {rar_file_path} descompactado para {output_dir}")
            except subprocess.CalledProcessError as e:
                print(f"Erro ao descompactar {rar_file_path}: {e}")
    else:
        print("Nenhum arquivo 'part01' encontrado para descompactação.")

# Descompactar os arquivos em AVPENS
avpens_files = glob.glob(os.path.join(avpens_dir, "*.rar"))
descompactar_primeiro_arquivo(avpens_files, avpens_dir)

# Descompactar os arquivos em AVSERV
avserv_files = glob.glob(os.path.join(avserv_dir, "*.rar"))
descompactar_primeiro_arquivo(avserv_files, avserv_dir)

# Função para combinar o conteúdo de arquivos de texto em um único arquivo
def combinar_arquivos_texto(origem_dir, arquivo_destino):
    txt_files = glob.glob(os.path.join(origem_dir, "*.txt"))
    
    if txt_files:
        with open(arquivo_destino, 'w', encoding='utf-8') as outfile:
            for txt_file in txt_files:
                print(f"Copiando conteúdo de {txt_file} para {arquivo_destino}...")
                with open(txt_file, 'r', encoding='utf-8') as infile:
                    outfile.write(infile.read() + "\n")  # Adiciona o conteúdo de cada arquivo e uma nova linha
        print(f"Conteúdo combinado no arquivo {arquivo_destino}.")
    else:
        print(f"Nenhum arquivo .txt encontrado no diretório {origem_dir}.")

# Combinar arquivos de texto em um único arquivo para AVPENS
combinar_arquivos_texto(avpens_dir, ccsiape_pens_file)

# Combinar arquivos de texto em um único arquivo para AVSERV
combinar_arquivos_texto(avserv_dir, ccsiape_serv_file)
