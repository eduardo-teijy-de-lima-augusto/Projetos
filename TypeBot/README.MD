<h1 align="center">🚀 Instalação e configuração do TypeBot 🚀</h1> 

# 💡 Overview

- 🔥 O processo de configuração do serviço em si é complexo, então deixei alguns links para consulta que não devem ser ignorados
- 🛠️ Utilize as consultas caso algo falhe ou deseje implementar mais recursos


- ➡️ Typebot Não Faz Login - Corrigindo o Erro de Login no Typebot
    - ➡️ Este video esclarece algumas situações de login, e algumas configuraçoes visuais do docker-compose.yml
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

- ➡️ Gere uma Chave Secreta de 32 Caracteres:
- ➡️ Copie a chave pois vamos usar a mesma no arquivo .env

```bash
openssl rand -base64 24 | tr -d '\n' ; echo
```

- ➡️ No vscode abra a pasta typebot, e clique no arquivo .env
- ➡️ A configuração padrão é muito simples, então foi alterada; copie cole o exemplo abaixo e faça as alterações necessárias:
- ➡️ **Observação:** Vamos usar as portas 4000 e 4001 (padrão 3000 e 3001)
    - ➡️ Lembrando que temos que também configurar o firewall para acesso as portas
    - ➡️ Configurar também o arquivo docker-compose.yml para não gerar erros



```bash
# Chave de Criptografia (32 caracteres aleatórios)
ENCRYPTION_SECRET=cole aqui a chave copiada no passo anterior

# Configuração do Banco de Dados (PostgreSQL)
DATABASE_URL=postgresql://postgres:typebot@typebot-db:5432/typebot

# Opções do Node.js
NODE_OPTIONS=--no-node-snapshot

# URLs do Typebot (vamos usar as portas 4000 e 4001 * Necessario ajustar o firewall)
NEXTAUTH_URL=http://preencha.url.com.br:porta
NEXT_PUBLIC_VIEWER_URL=http://preencha.url.com.br:porta

# E-mail de Administrador (para receber notificações ou autenticar-se)
ADMIN_EMAIL=emaildoadmin@gmail.com

# Configuração do Servidor SMTP (Gmail)
EMAIL_SERVER=smtp://emaildoadmin%40gmail.com:senha do app gerada@smtp.gmail.com:587
EMAIL_FROM="Typebot <emaildoadmin@gmail.com>"

# Ativar a autenticação via e-mail no Typebot
EMAIL_SIGNIN_ENABLED=true

# Configuração de Segurança do SMTP
SMTP_USERNAME=emaildoadmin@gmail.com
SMTP_PASSWORD=senha do app gerada
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
NEXT_PUBLIC_SMTP_FROM="Typebot <emaildoadmin@gmail.com>"
SMTP_SECURE=false

# Outras Configurações Relevantes (se aplicável)
NEXT_PUBLIC_DISABLE_SIGNUP=true  # Se quiser desativar o cadastro de novos usuários
```

- ➡️ Para mais detalhes sobre outras opções de autenticação, consulte a documentação oficial.
- ➡️ https://docs.typebot.io/self-hosting/configuration
- ➡️ Dentro da pasta do typebot existe um arquivo chamado docker-compose.yml
- ➡️ Abra o arquivo no vscode e altere as portas mencionadas acima que serão 4000 e 4001

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
      - '4000:4000'
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
      - '4001:4000'
    env_file: .env
```

- ➡️ Abra as portas no firewall do servidor e do modem utilizado (vivo, tim ou claro)
- ➡️ Crie as regras no modem das portas 4000 e 4001
- ➡️ Se tudo estiver correto agora vamos subir o docker compose:
- ➡️ Dentro da pasta /opt/docker/typebot execute o comando:

```bash
sudo docker compose up -d
```

- ➡️ Se precisar baixar o docker:

```bash
sudo docker compose down
```

- ➡️ Verificando o serviço em execução

```bash
sudo docker ps -a
```

- ➡️ Acesse o typebot através da url:
- ➡️ http://agetech.duckdns.org:4000/
- ➡️ Sera solicitado o email para entrar: use o email que esta configurado no arquivo .env
- ➡️ Uma chave de acesso sera enviada para o email padrão.



---

6. Considerações Adicionais - *** Verificar essa opção para SSL (https) quando for migrar ele para acesso externo.
Proxy Reverso e SSL: Para produção, é recomendável configurar um proxy reverso (como Nginx ou Traefik) e habilitar SSL/TLS para segurança. Isso permitirá que você acesse o Typebot via HTTPS e em portas padrão (80/443).

Atualizações: Para manter o Typebot atualizado:

```bash
docker compose pull
docker compose up -d
```

Armazenamento de Dados: Os dados do Typebot são armazenados no diretório .typebot dentro do diretório de instalação. Certifique-se de configurar backups regulares para evitar perda de dados.


### Crie um snapshot ate aqui com a instalação do typebot para segurança.