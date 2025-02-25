

![Descrição do GIF](https://github.com/eduardo-teijy-de-lima-augusto/Projetos/blob/master/Arquivos/Notebook.gif)


<h1 align="center">AGETech Solutions</h1> 
<h1 align="center">🚀 Repositorio de Projetos 🚀</h1> 

Neste Repositorio temos os projetos separados para uma melhor organização.

Acesse os links disponíveis para consultar cada procedimento.

---


# Projeto Automações de chatbot e whatsapp bot

### Descrição do Projeto.

- 🕹️ Automação do serviço de chatbot e whatsapp bot através de um robô: 
    
## Requisitos do Ambiente

- ➡️Hardware
    - ➡️VPS:
        - ➡️ CPU 2 Cores 
        - ➡️ 4 GB Ram
        - ➡️ 100 GB Armazenamento
    - ➡️ Proxmox:
        - ➡️ Container
        - ➡️ CPU 2 Cores 
        - ➡️ 4 GB Ram
        - ➡️ 100 GB Armazenamento

- ➡️ Software
    - ➡️ **Kernel:** Linux 20.04 ou superior
    - ➡️ **Servidor Offline:** TypeBot
    - ➡️ **API:** Evolution API
    - ➡️ **Armazenamento de Dados:** MinIO (Delta Lake)
    - ➡️ **Linguagem de Programação:** Python
    - ➡️ **Containers:** Docker e Docker Compose
    - ➡️ **IDE:** VSCode
    - ➡️ **Controle de Versão:** Git e GitHub


---

### Pré-requisitos



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