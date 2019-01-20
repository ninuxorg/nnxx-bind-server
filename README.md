<BS># Ansible role `bind`

[![N|Solid](http://basilicata.ninux.org/images/Logo_Ninux_Basilicata_600-192.png)](http://basilicata.ninux.org)

E' un playbook per installare configurare un Server DNS con BIND ISC per più domini Debian/Ubuntu (prossimamente anche per RedHat/CentOS). NEllo specifico il playbook è diviso in 2 ruoli, uno di base COMMON ed uno per BIND.
- Common configura principalmente:
  - porta ssh
  - utenti e chiavi ssh
  - banner
  - configura il profile per gli alias, colori nel terminale
- installa BIND
  - configurazione dei file principali
      - master server
      - slave server
  - imposta i file di zona

Abbiamo il supporto per più zone e per IPv6.

## Le Variabili per il ruolo di Bind9

Variables are not required, unless specified.

| Variable                     | Default                          | Comments (type)                                                                                                             |
| :---                         | :---                             | :---                                                                                                                        |
| `bind_acls`                  | `[]`                             | A list of ACL definitions, which are dicts with fields `name` and `match_list`. See below for an example.                   |
| `bind_allow_query`           | `['localhost']`                  | A list of hosts that are allowed to query this DNS server. Set to ['any'] to allow all hosts                                |
| `bind_allow_recursion`       | `['any']`                        | Similar to bind_allow_query, this option applies to recursive queries.                                                      |
| `bind_check_names`           | `[]`                             | Check host names for compliance with RFC 952 and RFC 1123 and take the defined actioni (e.g. `warn`, `ignore`, `fail`). |
| `bind_dnssec_enable`         | `true`                           | Is DNSSEC enabled                                                                                                           |
| `bind_dnssec_validation`     | `true`                           | Is DNSSEC validation enabled                                                                                                |
| `bind_extra_include_files`   | `[]`                             |                                                                                                                             |
| `bind_forward_only`          | `false`                          | If `true`, BIND is set up as a caching name server                                                                          |
| `bind_forwarders`            | `[]`                             | A list of name servers to forward DNS requests to.                                                                          |
| `bind_listen_ipv4`           | `['127.0.0.1']`                  | A list of the IPv4 address of the network interface(s) to listen on. Set to ['any'] to listen on all interfaces.            |
| `bind_listen_ipv6`           | `['::1']`                        | A list of the IPv6 address of the network interface(s) to listen on                                                         |
| `bind_log`                   | `data/named.run`                 | Path to the log file                                                                                                        |
| `bind_query_log`             | -                                | When defined (e.g. `data/query.log`), this will turn on the query log                                                       |
| `bind_recursion`             | `false`                          | Determines whether requests for which the DNS server is not authoritative should be forwarded†.                             |
| `bind_rrset_order`           | `random`                         | Defines order for DNS round robin (either `random` or `cyclic`)                                                             |
| `bind_zone_dir`              | -                                | When defined, sets a custom absolute path to the server directory (for zone files, etc.) instead of the default.            |
| `bind_zone_domains`          | n/a                              | A list of domains to configure, with a seperate dict for each domain, with relevant details                                 |
| `- allow_update`             | `['none']`                       | A list of hosts that are allowed to dynamically update this DNS zone.                                                       |
| `- also_notify`              | -                                | A list of servers that will receive a notification when the master zone file is reloaded.                                   |
| `- delegate`                 | `[]`                             | Zone delegation. See below this table for examples.                                                                         |
| `- hostmaster_email`         | `hostmaster`                     | The e-mail address of the system administrator for the zone                                                                 |
| `- hosts`                    | `[]`                             | Host definitions. See below this table for examples.                                                                        |
| `- ipv6_networks`            | `[]`                             | A list of the IPv6 networks that are part of the domain, in CIDR notation (e.g. 2001:db8::/48)                              |
| `- mail_servers`             | `[{name: mail, preference: 10}]` | A list of dicts (with fields `name` and `preference`) specifying the mail servers for this domain.                          |
| `- name_servers`             | `[ansible_hostname]`             | A list of the DNS servers for this domain.                                                                                  |
| `- name`                     | `example.com`                    | The domain name                                                                                                             |
| `- networks`                 | `['10.0.2']`                     | A list of the networks that are part of the domain                                                                          |
| `- other_name_servers`       | `[]`                             | A list of the DNS servers outside of this domain.                                                                           |
| `- services`                 | `[]`                             | A list of services to be advertized by SRV records                                                                          |
| `- text`                     | `[]`                             | A list of dicts with fields `name` and `text`, specifying TXT records. `text` can be a list or string.                      |
| `bind_zone_file_mode`        | 0640                             | The file permissions for the main config file (named.conf)                                                                  |
| `bind_zone_master_server_ip` | -                                | **(Required)** The IP address of the master DNS server.                                                                     |
| `bind_zone_minimum_ttl`      | `1D`                             | Minimum TTL field in the SOA record.                                                                                        |
| `bind_zone_time_to_expire`   | `1W`                             | Time to expire field in the SOA record.                                                                                     |
| `bind_zone_time_to_refresh`  | `1D`                             | Time to refresh field in the SOA record.                                                                                    |
| `bind_zone_time_to_retry`    | `1H`                             | Time to retry field in the SOA record.                                                                                      |
| `bind_zone_ttl`              | `1W`                             | Time to Live field in the SOA record.                                                                                       |


### Variabili minime da importare per le zone:


| Variable                     | Master | Slave |
| :---                         | :---:  | :---: |
| `bind_zone_domains`          | V      | V     |
| `  - name`                   | V      | V     |
| `  - networks`               | V      | --    |
| `  - name_servers`           | V      | --    |
| `  - hosts`                  | V      | --    |
| `bind_listen_ipv4`           | V      | V     |
| `bind_allow_query`           | V      | V     |

### Esempio definizione di un dominio

```Yaml
bind_zone_domains:
  - name: ninux.nnxx
    hosts:
      - name: dns
        ip: 10.27.250.1
        ipv6: 2001:db8::1
        aliases:
          - ns
      - name: '@'
        ip:
          - 10.27.250.1
          - 10.27.250.2
        ipv6:
          - 2001:db8::1
          - 2001:db8::2
        aliases:
          - ns1
      - name: ns2
        ip: 10.27.22.5
    networks:
      - '10.27.250'
      - '10.27'
      - '10'
    delegate:
      - zone: basilicata.ninux.nnxx
        dns: 10.27.22.5
    services:
      - name: _ldap._tcp
        weight: 100
        port: 88
        target: dc001
```

### Configurazione minima per lo Slave

```Yaml
    bind_listen_ipv4: ['any']
    bind_allow_query: ['any']
    bind_zone_master_server_ip: 10.27.250.1
    bind_zone_domains:
      - name: ninux.nnxx
```

### Hosts

Gli host che questo server dovrà risolvere devono essere impostati sotto `hosts` nei campi `name`, `ip` e `aliases`

Tu puoi specificare IP multipli per un host aggiungendo allo stesso nome gli IP in `bind_zone_hosts`. Questo risulterà in multipli record A/AAAA records per un host e consentire al [DNS round robin](http://www.zytrax.com/books/dns/ch9/rr.html) una semplice tecnica di load balancing. L'ordine degli ip saranno configurati nella variabile `bind_rrset_order`.

### Networks

Non tutti gli host sono nella stessa rete. Per ottere un record PTR dovranno essere specificate in `networks`. Solo le reti vanno specificate qui! Ad esempio per la rete di Ninux Basilicata andrà inserito "10.27" nella variabile.

### Zone delgation

Per delegare una zona DNS è sufficiente creare un record `NS` (sotto delegato) che è l'equivalente di:

```
foo IN NS 192.0.2.1
```

### Service records

I record (SRV) posso essere aggiunti come servizio. Questi sono campi obbligatori, come `name` (service name), `target` (host providing the service), `port` (TCP/UDP porta del servizio) come campi opzionali abbiamo `priority` (default = 0) e `weight` (default = 0).

### ACLs

Le ACLs possono essere definite in questo modo:

```Yaml
bind_acls:
  - name: acl_trasfer
    match_list:
      - 192.0.2.0/24
      - 10.0.0.0/8
```

Il nome della ACLs verra' aggiunta in `allow-transfer` nelle opzioni globali.

### Esempio del playbook
```Yaml
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
    # bind
    bind_listen_ipv4:
      - 127.0.0.1
      - 176.9.204.50
      - 176.9.187.218
    bind_zone_master_server_ip: 176.9.204.50
  pre_tasks:
    - name: Get dict for each zone
      include_vars:
        dir: zones
    - name: Merge zone dicts
      set_fact:
        bind_zone_domains:
          "{{ nnxx_ninux_org }} +
           {{ ninux_nnxx }}"
```
