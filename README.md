

![Descrição do GIF](https://github.com/eduardo-teijy-de-lima-augusto/Projetos/blob/master/Arquivos/Notebook.gif)



<h1 align="center">Projeto - Automações de Convênios</h1> 


### Descrição do Projeto.

- Automação das rotinas mensais de convênios da empresa utilizando ferramentas de auxílio: 
    - Minio (Delta Lake)
    - Linux 
    - Phyton
    - SQL
    - VSCODE
    - Git e GitHub

---

### Pré-requisitos

- Criação de um Delta Lake utilizando Linux Ubuntu 20.04 e Minio
- Instância de SQLServer 2019 ou posterior para ingestão e tratamento de dados
- VSCODE ou similar com ambiente em Phyton para a construção dos pipelines de automação
- Criação de procedures em SQL no servidor de ETL para o tratamento dos dados inseridos
- Ambiente em Git para subir os codigos e processos em Branches

---


### Fluxo do processo:
    


<div align="center">
    <img src="/Arquivos/AutomacaoConvenios.png" alt="DashGo Sistema" height="320">
</div>

- Ingestão dos arquivos no Delta Lake através de uploads ou APIs
- Dados são separados em Bucktes apropriados no Minio (Delta Lake)
- Códigos em Phyton são acionados para automatizar a separação, verificação e ingestão de dados no Servidor de ETL
- Procedures em SQL são executadas desde a camada RAW passando por TRUSTED e chegando na REFINED preparando os dados.
- As tabelas prontas são transferidas para o servidor de produção e devidamente susbstituidas
- Procedures e triggers são disparadas para a sustentação das tabelas fato e dimensões utlizadas no BI
- Usuários internos e externos consomem os dados através do CRM.

<h4 align="center"> 
    :construction:  Projeto em construção  :construction:
</h4>