<h1 align="center">🚀 Configuração básica do kernel Linux Ubuntu 🚀</h1> 


- ➡️ Acesse o container no proxmox, vá ate console e faça login como root
- ➡️ Atualize os pacotes do sistema

```bash
sudo apt update && sudo apt upgrade -y
```


    - ➡️ Template Linux Ubuntu 22.04
    - ➡️ Storage nvme2tb - 100 GB Armazenamento    
    - ➡️ CPU - 2 Cores 
    - ➡️ Memoria e Swap - 4096 Ram
    - ➡️ Network Static - IP 192.168.15.170/24 - Gateway IP 192.168.15.1