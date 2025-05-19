# Host Scan

Este é um projeto simples em Rust que escaneia hosts ativos em uma rede local a partir de um IP base informado pelo usuário. Ele utiliza o comando `ping` para verificar a disponibilidade dos dispositivos na rede.

<div align="center">
    <img src=https://github.com/user-attachments/assets/bfd3d04b-81e3-41b7-a6e9-85f5292dc973>
</div>

## Funcionalidades

- Solicita ao usuário um endereço IP no formato `xxx.xxx.xxx.xxx`.
- Verifica os endereços da mesma sub-rede, variando o último octeto de 1 a 254.
- Mostra os hosts que estão ativos (respondem ao ping).

## Como rodar

1. Compile o projeto:
   ```bash
   cargo build --release
    ```

2. Execute o programa:
   ```bash
   cargo run
   ```

3. Insira o IP base:
   ```bash
   Enter the IP address: 192.168.0.1
   ``` 

4. O programa irá escanear os IPs de 192.168.0.1 até 192.168.0.254, mostrando quais estão ativos.

## Exemplo de execução

```bash
Enter the IP address: 192.168.1.1
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃		   ACTIVE HOSTS			   ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃ ➤ 192.168.1.5     ✔			   ┃
┃ ➤ 192.168.1.12    ✔			   ┃
┃ ➤ 192.168.1.101   ✔			   ┃
▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 100%
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
``` 
