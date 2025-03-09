<h1 align="center">🚀 Configuração básica do kernel Linux Ubuntu 🚀</h1> 


## Fluxo

- ➡️ Acesse o container no proxmox, vá ate console e faça login como root
- ➡️ Atualize os pacotes do sistema

```bash
sudo apt update && sudo apt upgrade -y
```

- ➡️ Instale o pacote de net-tools:

```bash
sudo apt install net-tools
```

- ➡️ Crie um usuário para acessar via ssh ou vscode:

```bash
adduser sysadmin
```

- ➡️ Inclua o usuario no grupo de sudo:

```bash
usermod -aG sudo sysadmin
```

- ➡️ Configure no roteador utilizado o acesso a porta 22 do ssh para o servidor específico
  - No caso do proxmox utilize a porta 22 externa e 22 interna
  - No caso de outros serviços use a porta com inicio 22xx e a interna para o Ip correspondente porta 22


- ➡️ A partir desse momento podemos acessar o servidor atraves do vs-code:
- ➡️ Abra o vscode e adicione o servidor ao arquivo ssh padrão

```bash
  Host typebotevolution
  HostName agetechsolutions.duckdns.org
  Port 2204
  User sysadmin
```
- ➡️ Faça a conexão pelo vscode, abra um terminal e continue o tutorial
- [Home](/README.md)
