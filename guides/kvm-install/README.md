# Installazione KVM GNU/Linux

La seguente procedura è stata testata Fedora 31, ma dovrebbe essere valida per qualunque distribuzione GNU/Linux con i dovuti accorgimenti.

#### Credenziali di accesso per la macchina virtuale

| nome utente | password | ruolo |
|-|-|-|
| student | student | utente normale |
| root | redhat | amministratore |

## 1. Download

- Aprire un terminale ed effettuare il login con un utente che abbia i premessi di amministratore;

- Scaricare il gruppo di pacchetti software per la virtualizzazione, tramite il seguente comando, a seconda della distribuzione GNU/Linux in uso:

    - #### Fedora:
    ```bash
    sudo yum install @virtualization
    ```

**NOTA**: Il comando seguente scaricherà l'archivio dentro la cartella nella quale sarà eseguito.

- Scaricare l'archivio contenente i file della macchina virtuale da questo [link](https://drive.google.com/open?id=19id0zA-XKeTF_3_jm0taFeFhxNmcDo_N); è possibile utilizzare il seguente comando (se `wget` è installato sul vostro sistema):

```bash
wget "https://drive.google.com/open?id=19id0zA-XKeTF_3_jm0taFeFhxNmcDo_N" -O rh024.tar.gz
```

**NOTA**: Il comando riportato sopra non permette di scaricare il file: al momento stiamo lavorando per inserire nella guida una soluzione, nel frattempo potete seguire il [link](https://drive.google.com/open?id=19id0zA-XKeTF_3_jm0taFeFhxNmcDo_N) proposto sopra, oppure provare quanto consigliato [qui](https://github.com/extraordy/rh024/issues/6)

## 2. Installazione

- Estrarre l'archivio scaricato (il pacchetto `tar` è un requisito):

```bash
tar -xzf rh024.tar.gz RH024
```

- Copiare i file dei dischi virtuali nel pool di default:

```bash
cd RH024 && sudo mv *.qcow2 /var/lib/libvirt/images/
```

- Abilitare e avviare il servizio di virtualizzazione:

```bash
sudo systemctl enable libvirtd
sudo systemctl start --now libvirtd
```

## 3. Importare la macchina virtuale

- Importare la definizione della macchina virtuale dal file XML fornito:

```bash
sudo virsh define --file rh024.xml
```

- Avviare il dominio definito:
```bash
sudo virsh start RH024
```
