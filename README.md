

![Descrição do GIF](https://github.com/eduardo-teijy-de-lima-augusto/Projetos/blob/master/Arquivos/Notebook.gif)


- Este repositório representa uma pequena parte dos projetos que desenvolvi para automatizar processos de carga e transformação de dados utlizando diversas ferramentas. 

- Este projeto de exemplo demonstra minha capacidade de estruturar soluções completas, do backend à entrega visual dos dados, com foco em escalabilidade, governança e segurança da informação (LGPD).

- Os softwares utlizados foram disponibilizados pelo cliente, e algumas aplicações foram sugeridas como docker e docker compose para orquestração de containers para microserviços.

- ***Algumas referências foram alteradas para manter em sigilo informações dos clientes respeitando assim a LGPD***


- Acesse os links disponíveis para consultar cada procedimento.

---

# Projeto: Automação/Rotina ETL

### Descrição do Projeto.

#### 🕹️ Automação para uma rotina mensal de atualização de tabelas no SQLServer:
- Uso de bibliotecas em python para extração e manipulação de pastas e arquivos para o ETL ser disparado no SQLServer
- Tabelas geradas e trocadas conforme regras do negócio
- Tabelas fato e dimensão para análise de BI
- Aplicação para a leitura em tela dos contra cheques utilizando Streamlit - Python
- Documentação baseada na localidade e particularidades da infraestrutura
- Serve como base para outros serviços em outros locais
    
## Requisitos do ambiente, instalações e configurações

- ➡️Hardware do cliente
    - ➡️ Proxmox
        - ➡️ Container em Linux Debian
        - ➡️ CPU 30 Cores 
        - ➡️ 150 GB Ram
        - ➡️ 1 Tb Armazenamento

- ➡️ Software
    - ➡️ **Kernel:** Debian ou superior
    - ➡️ **Containers:** Docker e Docker Compose
    - ➡️ **Gmail:** Chave de APP para envio de alertas 
    - ➡️ **Armazenamento de Dados:** MinIO (Delta Lake)
    - ➡️ **Linguagem de Programação:** Python
    - ➡️ **IDE:** VSCode
    - ➡️ **Controle de Versão:** Git e GitHub


## Fluxo do processo

- ➡️Envio de alertas por email em todo fluxo do processo
- ➡️Blocos de Try Cast sinaliza sucesso ou erro via e-mail

    - ➡️ sinaliza sucesso e envio de dados para confirmação
    - ➡️ sinaliza exatamente onde o fluxo foi interrompido em caso de erro

- ➡️Tabela monitoramento SQLServer do processo de ETL gerado, com querys executadas, usuario, tempos de execução para métricas
- ➡️Logs dos processos de Python para acompanhamento e métricas de tempo de execução

<p align="center">
  <img src="https://github.com/eduardo-teijy-de-lima-augusto/Projetos/blob/master/Arquivos/FluxoSiape.png?raw=true" alt="Imagem Centralizada">
</p>




## Codigos em Python

- ➡️Códigos utlizados para extração de arquivos e manipulação de pastas
    - ➡️ [Main](/Python/0_main.py)
        - ➡️ [Extração dos arquivos](/Python/1_Extrai_Arquivos.py)
        - ➡️ [Arquivos para tabela Contratos](/Python/2_D8.PY) 
        - ➡️ [Arquivos para tabela Consolidados](/Python/3_RenomeiaConsolidados.py)
        - ➡️ [Arquivos de contra cheques](/Python/4_AVTXT.py)
        - ➡️ [Separa arquivos finais para Bulk Insert no SQLServer](/Python/5_Copia_Arquivos_Gerados.py)
        - ➡️ [Transfere arquivos finais para o SQLServer Produção](/Python/6_Copia_Arquivos_Linux.py)
        - ➡️ [Executa as procedures no SQLServer](/Python/7_Executa_Proc_Siape.py)
        

## Procedures SQLServer - ETL

- ➡️Procedures utlizadas para manipulação dos dados e troca de tabelas.
    - ➡️ [Siape](/Procedures/0_Siape.sql)
        - ➡️ [Bulk Insert arquivos](/Procedures/1_SiapeTabelasApoio.sql)
        - ➡️ [ETL tabela Contrato](/Procedures/2_SiapeArquivosD8.sql) 
        - ➡️ [ETL tabela Consolidados](/Procedures/3_SiapeArquivosTXT.sql)
        - ➡️ [ETL arquivos contracheques](/Procedures/4_SiapeArquivosAV.sql)
        - ➡️ [Criação de indices e sp_rename em tabelas](/Procedures/5_SiapeCriacaoIndices.sql)
        - ➡️ [Analise para BI](/Procedures/6_SiapeAnalise.sql)


## Transferência de tabelas utilizando Integration Services

- ➡️Processamento efetuado no servidor de ETL
- ➡️Através de um pacote, as tabelas são enviadas para outro servidor fora da rede do cliente, conforme regra do negócio

<br>

<p align="center">
  <img src="https://github.com/eduardo-teijy-de-lima-augusto/Projetos/blob/master/Arquivos/Transferencia_SSIS.png?raw=true" alt="Imagem Centralizada">
</p>






## Aplicação em Streamlit e python - Consulta de Contracheques

#### ***Referências foram alteradas para manter em sigilo informações dos clientes respeitando assim a LGPD***

- ➡️Cliente solicitou uma aplicação simples para consulta de contracheques
    - ➡️ Algumas áreas da empresa, alem da equipe de suporte precisa dessas informações de forma clara e rápida
    - ➡️ Aplicação consulta diretamente as tabelas envolvidas retornando os dados solicitados
    - ➡️ Aplicação disponibilizada em rede interna com acesso por login

<br>

<p align="center">
  <img src="https://github.com/eduardo-teijy-de-lima-augusto/Projetos/blob/master/Arquivos/ConsultaContraCheque.png?raw=true" alt="Imagem Centralizada">
</p>

---


