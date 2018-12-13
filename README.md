# Ansible Bind 9 Server for Debian

[![N|Solid](http://basilicata.ninux.org/images/Logo_Ninux_Basilicata_600-192.png)](http://basilicata.ninux.org)

Ninux Bind Server:  è uno playbook ansible per la configurazione di un server DNS interno, incoropora 2 roles: 
  - Common (installazione di base)
  - Bind9 (installazione base con zona ninux.nnxx per la LAN)

# Installazione
Clonare con:
```sh
git clone https://github.com/NinuxBasilicata/nnxx-bind-server.git
```
Aggiornare con:
```sh
git pull
git submodule update --init --recursive
```
# Inventory
```sh
# file: hosts
[<type>]
```
Esempio:
```sh
# file: hosts
[DNS]
ninux.nnxx ansible_user=michele ansible_port=2400 ansible_host=10.27.0.120
```

# Defining playbooks
```sh
# file: server.yml
- hosts: dns-server
  become: "{{ sudo | default('yes') }}"
  roles:
    - common
    - bind
  vars:
    # common
    common_ipv4_forward: 1
    common_ssh_port: 2400
    # variabili per ruolo common
    users:
      - name: michele
        authorized:
          - ./keys/michele.pub
      - name: nino
        authorized:
          - ./keys/nino.pub
      - name: marco
        authorized:
          - ./keys/hispanico.pub
      - name: federico
        authorized:
          - ./keys/federico-1.pub
          - ./keys/federico-2.pub
```
Ogni ruolo ha una directory in cui sono definiti i task, i template, handlers e variabili. Per maggiori informazioni vedere  https://docs.ansible.com/index.html

# Gotta deploy 'em all!

Install ansible on Debian Stretch:
```sh
sudo apt-get install software-properties-common
sudo echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
sudo apt-get update
sudo apt-get install ansible
```
Deploy su un nuovo server:

```sh
ansible-playbook -i hosts server.yml --vault-password-file pass.txt -ku <user> -e "sudo=no" -l dns-server
```

La directory dnssec contiene uno script per generare le chiavi KSK e ZSK di un dominio.
Entrare nella directory ed eseguire il ./gen con sudo
Per la generazione delle chiavi è necessario l'installazione del pacchetto
```sh
sudo apt-get install bind9utils
```
All'interno delle 2 directory viene eseguito un backup con nome NOMEDOMINO.priv, il file .private viene criptato.
La parte criptata va inserita in nel file "group_vars/dns-server/dnssec"

per inserire le chiavi si consigli il comando
```sh
cat file.criptato | tr "\n" "#" | tr -d "#" > file-unica-riga.txt
```
