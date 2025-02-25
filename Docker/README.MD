<h1 align="center">🚀 Instalação do Docker e Docker compose 🚀</h1> 


## Fluxo

- ➡️ Acesse o container no VSCODE abra um terminal e siga o processo
- ➡️ Instale Dependências:

```bash
sudo apt install -y ca-certificates curl gnupg lsb-release
```

- ➡️ Adicione a Chave GPG do Docker:

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

- ➡️ Configure o Repositório do Docker:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

- ➡️ Instale o Docker e o Docker Compose:

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

- ➡️ Verifique as Instalações:

```bash
docker --version
docker compose version
```