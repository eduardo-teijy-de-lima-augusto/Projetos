<h1 align="center">🚀 Instalação e configuraçãdo do Evolution API 🚀</h1> 

## Utilizado em conjunto com o TypeBot para que o Robo seja acionado e envie o fluxo

## Fluxo

- ➡️ Acesse o container no VSCODE abra um terminal e siga o processo
- ➡️ Instale Dependências:
- ➡️ Provavelmente o git ja estara instalado:

```bash
git --version
```

- ➡️ Se não estiver instale:

```bash
sudo apt install git -y
```

- ➡️ Para instalar o Evolution API acesse o repositorio:
    - ➡️ https://github.com/evolutionapi/evolution-api
    - ➡️ Vá ate <> CODE e copie o endereço para ser clonado no git do servidor.
    - ➡️ https://github.com/EvolutionAPI/evolution-api.git
- Abra o terminal no servidor, saia da pasta do typebot e clone o repositorio:

```bash
sudo git clone https://github.com/EvolutionAPI/evolution-api.git
```

Ao gerar o clone uma pasta chamada evolution-api sera criada com todos os arquivos necessarios para funcionamento.

OBSERVAÇÕES:

- Dentro da pasta do evolution-api existe um arquivo chamado .env.example, mude o nome para .env
- Caso de erro de permissão, garanta que o usuario sysadmin tem acesso completo na pasta:

```bash
sudo chown -R sysadmin:sysadmin /home/sysadmin/evolution-api
sudo chmod -R 770 /home/sysadmin/evolution-api
```

Agora vamos editar o arquivo .env e mudar algumas configurações:

- Logo no inicio do arquivo altere a opção:
    - SERVER_URL=http://localhost:8080 para o endereço de IP do servidor:
        - SERVER_URL=http://192.168.15.180:8080
- Procure essa linha no arquivo e altere:
    - CACHE_REDIS_URI=redis://localhost:6379/6
        - CACHE_REDIS_URI=redis://192.168.15.180:6379/6
- Procure também essa linha para habilitar o typebot pois vem desligado:
    - TYPEBOT_ENABLED=false
        - TYPEBOT_ENABLED=true

Se tudo estiver correto inicie o docker do Evolution API: (entre na pasta do evolution api)

```bash
sudo docker compose up -d
```

Acesse o endereço url do Evolution API:

- http://192.168.15.180:8080/
- Deverá aparecer essa informação:

```json
{
  "status": 200,
  "message": "Welcome to the Evolution API, it is working!",
  "version": "2.2.3",
  "clientName": "evolution_exchange",
  "manager": "http://192.168.15.180:8080/manager",
  "documentation": "https://doc.evolution-api.com"
}
```
- Isso demonstra que esta tudo certo com o aplicativo
- Agora acesse o manager para poder utilizar o aplicativo.
    - http://192.168.15.180:8080/manager
    - Ele ira pedir uma chave de api para acessar o aplicativo
        - Essa chave esta no arquivo .env la no final
        - AUTHENTICATION_API_KEY
        - 429683C4C977415CAAFCCE10F7D57E11

Dentro do evolution api voce cria uma instancia para se conectar ao whatsapp.

Depois vai em integracao e cria a integração com o typebot