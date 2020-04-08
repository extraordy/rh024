Il networking è gestito da servizio NetworkManager. Per inferfacciarci con questo servizio abbiamo due opzioni: la la Graphical User Interface (GUI) o la Command Line Interface (CLI). Noi andremo a introdurre l'utility 'nmcli' che ci permette di configurare device di rete e connessioni dalla linea di comando.

NetworkManager effettua il management delle connessioni utilizzando i profili. I profili creano un identificativo unifico chiamato UUID e lo associano al nome della connessione. Se per esempio creiamo due connessioni con lo stesso nome esse avranno gli UUID diversi e quindi saranno univocalmente identificabili.

Le connessioni racchiudono tutti i parametri di rete come per esempio: indirizzo ip4 e ip6, servers dns, netmask etc.. e devono essere obbligatoriamente collegate ad un device (interfaccia) di rete.

L'utility nmcli è molto semplice da utilizzare in quanto grazie all'autocomplete ci verranno esposti i comandi e opzioni che possiamo utilizzare.

Apriamo una shell e dicitiamo 'nmcli'

```
# nmcli


eth0: connected to System eth0
        "Red Hat Virtio"
        ethernet (virtio_net), 56:6F:3D:48:00:01, hw, mtu 1500
        ip4 default
        inet4 172.19.0.100/24
        route4 172.19.0.0/24
        route4 0.0.0.0/0
        inet6 fe80::546f:3dff:fe48:1/64
        route6 ff00::/8
        route6 fe80::/64

eth1: connected to System eth1
        "Red Hat Virtio"
        ethernet (virtio_net), 56:6F:3D:48:00:00, hw, mtu 1500
        inet4 172.22.0.101/24
        route4 172.22.0.0/24
        inet6 fe80::546f:3dff:fe48:0/64
        route6 ff00::/8
        route6 fe80::/64

lo: unmanaged
        "lo"
        loopback (unknown), 00:00:00:00:00:00, sw, mtu 65536

DNS configuration:
        servers: 172.22.0.101
        domains: example.com
        interface: eth0

Use "nmcli device show" to get complete information about known devices and
"nmcli connection show" to get an overview on active connection profiles.
```

Questo è l'output piuttosto corpose della nostra macchina virtuale di esempio dove possiamo trovare i dettagli di configurazione delle connessioni.

Per avere solo i nomi delle connessioni e relative device possiamo dicitare 'nmcli connection show' o nella sua forma abbrievata 'nmcli con show'

```
# nmcli con show

NAME         UUID                                  TYPE      DEVICE 
System eth0  5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0   
System eth1  9c92fad9-6ecb-3e6c-eb4d-8a47c6f50c04  ethernet  eth1 
```


Nel nostro caso abbiamo due connessioni.

La prima connessione si chiama 'System eth0' di tipo ethernet ed è collegata al device eth0
La prima connessione si chiama 'System eth1' di tipo ethernet ed è collegata al device eth1

Come si vede ad ogni connessione viene associato un identificativo univoco chiamato UUID per appunto permetterne l'identificazione in modo univoco.
 


Non dobbiamo cercare di ricordarci i comandi e opzioni perchè premendo due volte il pulsante <TAB>  nmcli elencherà i comandi o opzioni utilizzabili.

esempio

```
# nmcli '<TAB><TAB>'

agent       connection  device      general     help        monitor     networking  radio

```

Dobbiamo quindi usare uno di quei comandi proposti. Per vedere le operazioni possibili con le connessioni:

```
# nmcli connection '<TAB><TAB>'

add      clone    delete   down     edit     export   help     import   load     modify   monitor  reload   show     up  

```

Ed ecco che possiamo ricavare completamente il comando precedente 'nmcli connection show'


Per vedere i dettagli completi della connessione chiamata "System eth0" possiamo dicitare:

```
# nmcli connection show 'System eth0'
```

L'output è piuttosto corposo perchè avremo tutti i dettagli di configurazione della connessione e anche del device. 
Qui di seguito un estratto:

```
connection.id:                          System eth0
connection.uuid:                        5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03
connection.stable-id:                   --
connection.type:                        802-3-ethernet
connection.interface-name:              eth0
connection.autoconnect:                 yes
connection.autoconnect-priority:        0
connection.autoconnect-retries:         -1 (default)
connection.multi-connect:               0 (default)
connection.auth-retries:                -1
connection.timestamp:                   1585921388
connection.read-only:                   no
connection.permissions:                 --
connection.zone:                        --
connection.master:                      --
connection.slave-type:                  --
connection.autoconnect-slaves:          -1 (default)
connection.secondaries:                 --
connection.gateway-ping-timeout:        0
connection.metered:                     unknown
connection.lldp:                        default
connection.mdns:                        -1 (default)
connection.llmnr:                       -1 (default)
connection.wait-device-timeout:         -1
802-3-ethernet.port:                    --
802-3-ethernet.speed:                   0
802-3-ethernet.duplex:                  --
802-3-ethernet.auto-negotiate:          no
802-3-ethernet.mac-address:             --
802-3-ethernet.cloned-mac-address:      --
802-3-ethernet.generate-mac-address-mask:--
802-3-ethernet.mac-address-blacklist:   --
802-3-ethernet.mtu:                     auto
802-3-ethernet.s390-subchannels:        --
802-3-ethernet.s390-nettype:            --
802-3-ethernet.s390-options:            --
802-3-ethernet.wake-on-lan:             default
802-3-ethernet.wake-on-lan-password:    --
ipv4.method:                            manual
ipv4.dns:                               172.22.0.101
ipv4.dns-search:                        example.com
ipv4.dns-options:                       --
ipv4.dns-priority:                      0
ipv4.addresses:                         172.19.0.100/24
ipv4.gateway:                           172.19.0.1
ipv4.routes:                            --
ipv4.route-metric:                      -1
ipv4.route-table:                       0 (unspec)
ipv4.routing-rules:                     --
ipv4.ignore-auto-routes:                no
ipv4.ignore-auto-dns:                   no
ipv4.dhcp-client-id:                    --
ipv4.dhcp-timeout:                      0 (default)
ipv4.dhcp-send-hostname:                yes
ipv4.dhcp-hostname:                     --
ipv4.dhcp-fqdn:                         --
ipv4.never-default:                     no
ipv4.may-fail:                          yes
```

Da notare due parametri importanti:

```
ipv4.method: manual
```
indica che la configurazione dei parametri di connessione è stata inserita manualmente. Se valorizzato a 'auto' indica che i parametri di connessione verranno configurati da un server DHCP.

```
connection.autoconnect:                 yes
```

Questo parametro indica se vogliamo o no l'attivazione della nostra connessione durante la fase di boot.


Ora andiamo a creare una nuova connessione e collegarla ad un device esistente.
Per vedere i device utilizzabili lanciamo

```
# nmcli device show


GENERAL.DEVICE:                         eth0
GENERAL.TYPE:                           ethernet
GENERAL.HWADDR:                         56:6F:3D:48:00:01
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (connected)
GENERAL.CONNECTION:                     System eth0
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/1
WIRED-PROPERTIES.CARRIER:               on
IP4.ADDRESS[1]:                         172.19.0.100/24
IP4.GATEWAY:                            172.19.0.1
IP4.ROUTE[1]:                           dst = 172.19.0.0/24, nh = 0.0.0.0, mt = 100
IP4.ROUTE[2]:                           dst = 0.0.0.0/0, nh = 172.19.0.1, mt = 100
IP4.DNS[1]:                             172.22.0.101
IP6.ADDRESS[1]:                         fe80::546f:3dff:fe48:1/64
IP6.GATEWAY:                            --
IP6.ROUTE[1]:                           dst = ff00::/8, nh = ::, mt = 256, table=255
IP6.ROUTE[2]:                           dst = fe80::/64, nh = ::, mt = 256

GENERAL.DEVICE:                         eth1
GENERAL.TYPE:                           ethernet
GENERAL.HWADDR:                         56:6F:3D:48:00:00
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (connected)
GENERAL.CONNECTION:                     System eth1
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/2
WIRED-PROPERTIES.CARRIER:               on
IP4.ADDRESS[1]:                         172.22.0.101/24
IP4.GATEWAY:                            --
IP4.ROUTE[1]:                           dst = 172.22.0.0/24, nh = 0.0.0.0, mt = 101
IP6.ADDRESS[1]:                         fe80::546f:3dff:fe48:0/64
IP6.GATEWAY:                            --
IP6.ROUTE[1]:                           dst = ff00::/8, nh = ::, mt = 256, table=255
IP6.ROUTE[2]:                           dst = fe80::/64, nh = ::, mt = 256

```

Come si vede in questo caso abbiamo due device: eth0 e eth1.

Per aggiungere una nuova connessione e collegarla al device eth1 procediamo come di seguito. Ricordiamoci l'utilizzo di '<TAB><TAB>' per avere l'elenco dei comandi utilizzabili.

```
# nmcli connection add con-name my-office type ethernet ifname eth1

Connection 'my-office' (1940cfe7-e334-48e7-a11f-ba0fce61a238) successfully added.

```

Abbiamo creata una connessione chiamata my-office di tipo ethernet e collegata al device (interfaccia) eth1 ma senza alcun tipo di dettaglio riguardante i parametri quali indirizzo ip, dns etc...

Un solo profilo alla volta può essere attivato per la stessa interfaccia di rete.

Andiamo a verificare le connessioni presenti nel nostro sistema:

```
# nmcli con show

NAME         UUID                                  TYPE      DEVICE 
System eth0  5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0   
System eth1  9c92fad9-6ecb-3e6c-eb4d-8a47c6f50c04  ethernet  eth1   
my-office    1940cfe7-e334-48e7-a11f-ba0fce61a238  ethernet  --   

```

La nostra connessione my-office è stata creata ma non è ancora attivata.
Le connessioni attive vengono visualizzate in verde o possiamo ricavarle grazie a questo comando:

```
# nmcli con show --active

NAME         UUID                                  TYPE      DEVICE 
System eth0  5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0   
System eth1  9c92fad9-6ecb-3e6c-eb4d-8a47c6f50c04  ethernet  eth1 

```

Per aggiungere i parametri ip dns etc alla connessione my-office andiamo a modificarla (ricordiamoci sempre del '<TAB><TAB>')

```
# nmcli con mod my-office connection.autoconnect no ipv4.addresses 192.168.4.10/24 ipv4.dns 8.8.8.8 ipv4.method manual ipv4.gateway 192.168.4.1

```

In questo caso abbiamo modificato la connessione my-office inserendo questi parametri:

Indirizzo ip4 192.168.4.10 con maschera di rete 255.255.255.0 (/24)
Indirizzo dns 8.8.8.8
Indirizzo gateway 192.168.4.1
Non vogliamo che sia attivata all'avvio della macchina
Abbiamo specificato che la connessione utilizza parametri inseriti manualmente

L'ultimo step è quello di attivare la connessione appena creata. Ricordiamoci che può essere attivata una connessione alla volta per interfaccia.
Siccome la nostra connessione my-office è collegata all'interfaccia eth1 come la connessione 'System eth1' quando andremo ad attivare la connessione my-office, la connessione 'System eth1' verrà disattivata automaticamente.

```
# nmcli con show --active

NAME         UUID                                  TYPE      DEVICE 
System eth0  5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0   
System eth1  9c92fad9-6ecb-3e6c-eb4d-8a47c6f50c04  ethernet  eth1 

# nmcli con up my-office

Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/3)

# nmcli con show --active

NAME         UUID                                  TYPE      DEVICE 
System eth0  5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0   
my-office    1940cfe7-e334-48e7-a11f-ba0fce61a238  ethernet  eth1 

```

Se riattiviamo la connesione 'System eth1' torneremo alla situzione di partenza

```
# nmcli con up 'System eth1'

Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/6)



# nmcli con show --active

NAME         UUID                                  TYPE      DEVICE 
System eth0  5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0   
System eth1  9c92fad9-6ecb-3e6c-eb4d-8a47c6f50c04  ethernet  eth1 

```

Per cancellare la connessione my-office lanciamo questo comando 

```
# nmcli connection delete my-office

Connection 'my-office' (1940cfe7-e334-48e7-a11f-ba0fce61a238) successfully deleted

```

Al posto del nome della connessione avremmo potuto inserire l'UUID :

```

# nmcli connection delete 1940cfe7-e334-48e7-a11f-ba0fce61a238

Connection 'my-office' (1940cfe7-e334-48e7-a11f-ba0fce61a238) successfully deleted

```


Oltre all'utility nmcli, possiamo utilizzare l'utility ip:

Per vedere per esempio i dettagli delle interfaccie e gli eventuali dati di connessione associati possiamo lanciare 'ip a'

```
# ip a

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 56:6f:3d:48:00:01 brd ff:ff:ff:ff:ff:ff
    inet 172.19.0.100/24 brd 172.19.0.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::546f:3dff:fe48:1/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 56:6f:3d:48:00:00 brd ff:ff:ff:ff:ff:ff
    inet 172.22.0.101/24 brd 172.22.0.255 scope global noprefixroute eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::546f:3dff:fe48:0/64 scope link 
       valid_lft forever preferred_lft forever
```

Come compito creare una connessione collegata alla prima interfaccia di rete (in questo caso eth0) in un solo comando con questi pararametri ipv4:

nome connessione "home"
autoconnessione al boot
ip: 172.20.1.2
netmask: 255.255.255.0
dns: 8.8.8.8
gateway: 172.20.1.1
ethernet


Soluzione:

```
nmcli connection add con-name home ifname eth0 type ethernet ipv4.method manual ipv4.address 172.20.1.2/24 ipv4.dns 8.8.8.8 ipv4.gateway 172.20.1.1
```

Creare una connessione e relativi parametri con solo step è possibile grazie a `nmcli connection add`; 

















