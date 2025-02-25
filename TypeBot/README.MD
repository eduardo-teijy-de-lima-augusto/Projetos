<h1 align="center">🚀 Instalação e configuração do TypeBot 🚀</h1> 


## Fluxo

- ➡️ Acesse o container no VSCODE abra um terminal e siga o processo
- ➡️ Configuração do Typebot
- ➡️ O diretório /opt é utilizado para software e aplicações adicionais que não fazem parte do sistema padrão. 
- ➡️ Crie um Diretório para o Typebot: 

``` bash
sudo mkdir -p /opt/docker/typebot
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
- ➡️ A configuração padrão é muito simples, então foi alterada use o exemplo abaixo e faça as alterações necessárias:

```bash
# Chave de Criptografia (32 caracteres aleatórios)
ENCRYPTION_SECRET=cole aqui a chave copiada no passo anterior

# Configuração do Banco de Dados (PostgreSQL)
DATABASE_URL=postgresql://postgres:typebot@typebot-db:5432/typebot

# Opções do Node.js
NODE_OPTIONS=--no-node-snapshot

# URLs do Typebot (corretamente mapeadas para as portas 8080 e 8081)
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





- ➡️ Copie o codigo completo que esta no repositorio (arquivo .env) e cole substituindo tudo nesse arquivo.


Copie o valor gerado e cole no arquivo .env na variável ENCRYPTION_SECRET.

As demais configurações do arquivo .env estão corretas para o email com senha da api do google.

- OBSERVAÇÃO: A senha do gmail tem que ser gerada na sua conta do google, ou seja, tem que ser gerada uma senha de APP, pois o google nao aceita conexões com a senha padrão.

- Para mais detalhes sobre outras opções de autenticação, consulte a documentação oficial.
- https://docs.typebot.io/self-hosting/configuration

Dentro da pasta do typebot existe um arquivo chamado docker-compose.yml

Abra o arquivo no vscode va ate o repositorio e copie o conteúdo desse arquivo e cole substituindo tudo

- Dessa forma estamos direcionando as portas do TypeBot para 3000:3000 e 3001:3000

4. Se tudo estiver correto agora vamos subir o docker compose:

```bash
sudo docker compose up -d
```

Se precisar baixar o docker:

```bash
sudo docker compose down
```


5. Acesse o typebot através da url:

http://192.168.15.180:3000/

Sera solicitado o email para entrar: use o email que esta configurado no arquivo .env

Uma chave de acesso sera enviada para o email padrão.

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