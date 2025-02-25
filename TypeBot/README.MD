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


- ➡️ No vscode abra a pasta typebot, e clique no arquivo .env

- ➡️ Copie o codigo completo que esta no repositorio (arquivo .env) e cole substituindo tudo nesse arquivo.


- ➡️ Gere uma Chave Secreta de 32 Caracteres:

```bash
openssl rand -base64 24 | tr -d '\n' ; echo
```

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