<h1 align="center">🚀 Instalação e configuração do TypeBot 🚀</h1> 

# 💡 Overview

- 🔥 O processo de configuração do serviço em si é complexo, então deixei alguns links para consulta que não devem ser ignorados
- 🛠️ Utilize as consultas caso algo falhe ou deseje implementar mais recursos

## Links

- ➡️ Typebot Não Faz Login - Corrigindo o Erro de Login no Typebot
    - ➡️ Este video esclarece algumas situações de login, e algumas configuraçoes visuais do docker-compose.yml
    - ➡️ Pude ver no vídeo algumas coisas interessantes como logins e confiruação do minio em docker compose
    - ➡️ https://www.youtube.com/watch?v=l1ZLESl6rnk





## Fluxo

- ➡️ Acesse o container no VSCODE abra um terminal e siga o processo
- ➡️ Configuração do Typebot
- ➡️ O diretório /opt é utilizado para software e aplicações adicionais que não fazem parte do sistema padrão. 
- ➡️ Crie um Diretório para o Typebot: 

``` bash
sudo mkdir -p /opt/docker/typebot
```

- ➡️ Permissões do usuario sysadmin na pasta para alterações:

```bash
sudo chown -R sysadmin:sysadmin /opt/docker
```

```bash
sudo chmod -R 755 /opt/docker
```


- ➡️ Vá até a pasta criada:

``` bash
cd /opt/docker/typebot
```

- ➡️ Baixe os Arquivos Necessários:

```bash
sudo wget https://raw.githubusercontent.com/baptisteArno/typebot.io/latest/docker-compose.yml
```
```bash
sudo wget https://raw.githubusercontent.com/baptisteArno/typebot.io/latest/.env.example -O .env
```
- ➡️ OBSERVAÇÃO**** 
    - ➡️ Instalei uma nova versão em teoria 3.8 do link acima, o arquivo docker compose.yml é simples
    - ➡️ Com a ajuda do chatgpt configuramos o arquivo novamente, use esse codigo para passar do login que estava dando erro.
    - ➡️ Nesse arquivo consta variáveis que funcionam corretamente para o acesso aos postgres e redis
    - ➡️ Em teoria o arquivo que vem é so de exemplo e se espera que façamos alterações necessarias
```bash
version: '3.8'

x-typebot-common: &typebot-common
  restart: always
  depends_on:
    typebot-redis:
      condition: service_healthy
    typebot-db:
      condition: service_healthy
  networks:
    - typebot-network
  env_file: .env
  environment:
    REDIS_URL: redis://typebot-redis:6379
    DATABASE_URL: postgresql://typebot:typebot@typebot-db:5432/typebot

services:
  typebot-db:
    image: postgres:16
    restart: always
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=typebot
      - POSTGRES_USER=typebot
      - POSTGRES_PASSWORD=typebot
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U typebot"]
      interval: 5s
      timeout: 5s
      retries: 5
    networks:
      - typebot-network

  typebot-redis:
    image: redis:alpine
    restart: always
    command: --save 60 1 --loglevel warning
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      start_period: 20s
      interval: 30s
      retries: 5
      timeout: 3s
    volumes:
      - redis-data:/data
    networks:
      - typebot-network

  typebot-builder:
    <<: *typebot-common
    image: baptistearno/typebot-builder:latest
    ports:
      - '3000:3000'

  typebot-viewer:
    <<: *typebot-common
    image: baptistearno/typebot-viewer:latest
    ports:
      - '3001:3000'

networks:
  typebot-network:
    driver: bridge

volumes:
  db-data:
  redis-data:
```

- ➡️ OBSERVAÇÃO****
  - ➡️ Arquivo .env que esta funcionando, usar esse mas mudar a ENCRYPTION_SECRET caso refaça a instalação
  
```bash
# Chave de Criptografia (32 caracteres aleatórios)
ENCRYPTION_SECRET=MZ9oVh4R/ioLMVmnN11wKs9pox4445cx

# Configuração do Banco de Dados (PostgreSQL)
DATABASE_URL=postgresql://postgres:typebot@typebot-db:5432/typebot

# Opções do Node.js
NODE_OPTIONS=--no-node-snapshot

# URLs do Typebot (corretamente mapeadas para as portas 8080 e 8081)
NEXTAUTH_URL=http://agetechsolutions.duckdns.org:3000
NEXT_PUBLIC_VIEWER_URL=http://agetechsolutions.duckdns.org:3001

# E-mail de Administrador (para receber notificações ou autenticar-se)
ADMIN_EMAIL=solutionsagetech@gmail.com

# Configuração do Servidor SMTP (Gmail)
EMAIL_SERVER=smtp://solutionsagetech%40gmail.com:eizs aonn tqni xezh@smtp.gmail.com:587
EMAIL_FROM="Typebot <solutionsagetech@gmail.com>"

# Desativar cadastro de novos usuários
# Ou seja, no primeiro cadastro devemos mentar como false para que o admin consiga entrar
# Depois desabilitamos as dockers alteramos pra true e subimos as dockers novamente
DISABLE_SIGNUP=false

# Configuração de Segurança do SMTP
SMTP_USERNAME=solutionsagetech@gmail.com
SMTP_PASSWORD=eizs aonn tqni xezh
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
NEXT_PUBLIC_SMTP_FROM="Typebot <solutionsagetech@gmail.com>"
SMTP_SECURE=false


S3_ENDPOINT=http://agetechsolutions.duckdns.org:9000
S3_ACCESS_KEY=admin
S3_SECRET_KEY=Sysadmin##
S3_BUCKET=images-bot
S3_REGION=us-east-1
S3_FORCE_PATH_STYLE=true





# Outras Configurações Relevantes (se aplicável)
NEXT_PUBLIC_DISABLE_SIGNUP=true  # Se quiser desativar o cadastro de novos usuários
```

- ➡️ Gere uma Chave Secreta de 32 Caracteres:
- ➡️ Copie a chave pois vamos usar a mesma no arquivo .env
- ➡️ A chave encriptada esta no diretorio do drive pasta da empresa AgetechSolutions

```bash
openssl rand -base64 24 | tr -d '\n' ; echo
```

- ➡️ No vscode abra a pasta typebot, e clique no arquivo .env
- ➡️ A configuração padrão é muito simples, então foi alterada; copie cole o exemplo abaixo e faça as alterações necessárias:
- ➡️ **Observação:** Vamos usar as portas 3000 e 3001
    - ➡️ Lembrando que temos que também configurar o firewall para acesso as portas
    - ➡️ Configurar também o arquivo docker-compose.yml para não gerar erros
- ➡️ No arquivo que segue abaixo mude essa linha para o primeiro login do admin
    - ➡️ DISABLE_SIGNUP=true - coloque como false, salve e suba as dockers
    - ➡️ Depois do primeiro login do admin mude novamente para true, salve derrube as dockers e suba novamente.




```bash
# Chave de Criptografia (32 caracteres aleatórios)
ENCRYPTION_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Configuração do Banco de Dados (PostgreSQL)
DATABASE_URL=postgresql://postgres:typebot@typebot-db:5432/typebot

# Opções do Node.js
NODE_OPTIONS=--no-node-snapshot

# URLs do Typebot (corretamente mapeadas para as portas 8080 e 8081)
NEXTAUTH_URL=http://agetech.duckdns.org:3000
NEXT_PUBLIC_VIEWER_URL=http://agetech.duckdns.org:3001

# E-mail de Administrador (para receber notificações ou autenticar-se)
ADMIN_EMAIL=solutionsagetech@gmail.com

# Configuração do Servidor SMTP (Gmail)
EMAIL_SERVER=smtp://solutionsagetech%40gmail.com:xxxx xxxx xxxx xxxx@smtp.gmail.com:587
EMAIL_FROM="Typebot <solutionsagetech@gmail.com>"

# Desativar cadastro de novos usuários
# Ou seja, no primeiro cadastro devemos mentar como false para que o admin consiga entrar
# Depois desabilitamos as dockers alteramos pra true e subimos as dockers novamente
DISABLE_SIGNUP=true

# Configuração de Segurança do SMTP
SMTP_USERNAME=solutionsagetech@gmail.com
SMTP_PASSWORD=xxxx xxxx xxxx xxxx
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
NEXT_PUBLIC_SMTP_FROM="Typebot <solutionsagetech@gmail.com>"
SMTP_SECURE=false

# Outras Configurações Relevantes (se aplicável)
NEXT_PUBLIC_DISABLE_SIGNUP=true  # Se quiser desativar o cadastro de novos usuários
```

- ➡️ Para mais detalhes sobre outras opções de autenticação, consulte a documentação oficial.
- ➡️ https://docs.typebot.io/self-hosting/configuration
- ➡️ Dentro da pasta do typebot existe um arquivo chamado docker-compose.yml
- ➡️ Abra o arquivo no vscode e altere as portas mencionadas acima que serão 3000 e 3001

```bash
version: '3.3'

volumes:
  db-data:

services:
  typebot-db:
    image: postgres:16
    restart: always
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=typebot
      - POSTGRES_PASSWORD=typebot
    healthcheck:
        test: ["CMD-SHELL", "pg_isready -U postgres"]
        interval: 5s
        timeout: 5s
        retries: 5
  typebot-builder:
    image: baptistearno/typebot-builder:latest
    restart: always
    depends_on:
      typebot-db:
        condition: service_healthy
    ports:
      - '3000:3000'
    extra_hosts:
      - 'host.docker.internal:host-gateway'
    env_file: .env

  typebot-viewer:
    image: baptistearno/typebot-viewer:latest
    depends_on:
      typebot-db:
        condition: service_healthy
    restart: always
    ports:
      - '3001:3000'
    env_file: .env
```

- ➡️ Abra as portas no firewall do servidor e do modem utilizado (vivo, tim ou claro)
- ➡️ Crie as regras no modem das portas 3000 e 3001
- ➡️ Se tudo estiver correto agora vamos subir o docker compose:
- ➡️ Dentro da pasta /opt/docker/typebot execute o comando:

```bash
sudo docker compose up -d
```

- ➡️ Se precisar baixar o docker:
- ➡️ A documentação aconselha sempre baixar o docker e atualizar, ou seja, ele deleta as imagens e faz o pull novamente
- ➡️ Em teoria nunca se perde os fluxos, mas melhor testar antes

```bash
sudo docker compose down --remove-orphans
sudo docker compose pull typebot-builder
sudo docker compose pull typebot-viewer
sudo docker compose up -d
```

- ➡️ Verificando o serviço em execução

```bash
sudo docker ps -a
```

- ➡️ Acesse o typebot através da url:
- ➡️ http://agetech.duckdns.org:3000/
- ➡️ Sera solicitado o email para entrar: use o email que esta configurado no arquivo .env
- ➡️ Uma chave de acesso sera enviada para o email padrão.

---

## Considerações Adicionais 
- ➡️ *** Verificar essa opção para SSL (https) quando for migrar ele para acesso externo.
Proxy Reverso e SSL: Para produção, é recomendável configurar um proxy reverso (como Nginx ou Traefik) e habilitar SSL/TLS para segurança. Isso permitirá que você acesse o Typebot via HTTPS e em portas padrão (80/443).

- ➡️ Armazenamento de Dados: Os dados do Typebot são armazenados no diretório .typebot dentro do diretório de instalação. Certifique-se de configurar backups regulares para evitar perda de dados.


### Crie um snapshot ate aqui com a instalação do typebot para segurança.

- ➡️ Configuração bem sucedida, volte a home e continue o tutorial
- [Home](/README.md)