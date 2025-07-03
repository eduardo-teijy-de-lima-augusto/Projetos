import os
import glob

# Diretório onde os arquivos estão localizados
d8_dir = r"D:\siape\extracted_files\D8"

# Arquivos finais onde o conteúdo será combinado
pens_output_file = os.path.join(d8_dir, 'PENS.TXT')
serv_output_file = os.path.join(d8_dir, 'SERV.TXT')

# Função para combinar o conteúdo de arquivos em um único arquivo
def combinar_arquivos_sem_extensao(origem_dir, filtro, arquivo_destino):
    files = glob.glob(os.path.join(origem_dir, f"*{filtro}*"))
    
    if files:
        with open(arquivo_destino, 'w', encoding='utf-8') as outfile:
            for file in files:
                print(f"Copiando conteúdo de {file} para {arquivo_destino}...")
                codificacoes = ['utf-8', 'latin-1', 'cp1252', 'utf-16', 'iso-8859-1']
                sucesso = False
                
                for codificacao in codificacoes:
                    try:
                        # 'errors="ignore"' ignora caracteres que causam erros
                        with open(file, 'r', encoding=codificacao, errors='ignore') as infile:
                            outfile.write(infile.read() + "\n")
                        sucesso = True
                        break  # Se funcionar, sai do loop
                    except UnicodeDecodeError:
                        print(f"Erro de codificação com {codificacao} no arquivo {file}. Tentando próxima...")
                
                if not sucesso:
                    print(f"Falha ao ler o arquivo {file} com as codificações testadas.")
                    
        print(f"Conteúdo combinado no arquivo {arquivo_destino}.")
    else:
        print(f"Nenhum arquivo encontrado com o filtro '{filtro}' no diretório {origem_dir}.")


# Combinar arquivos que contenham "PENS D8" em um único arquivo PENS.TXT
combinar_arquivos_sem_extensao(d8_dir, "PENS D8", pens_output_file)

# Combinar arquivos que contenham "SERV D8" em um único arquivo SERV.TXT
combinar_arquivos_sem_extensao(d8_dir, "SERV D8", serv_output_file)
