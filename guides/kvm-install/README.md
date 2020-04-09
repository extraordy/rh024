# Installazione KVM GNU/Linux

La seguente procedura è stata testata Fedora 31, ma dovrebbe essere valida per qualunque distribuzione GNU/Linux con i dovuti accorgimenti.

#### Credenziali di accesso per la macchina virtuale

| nome utente | password | ruolo |
|-|-|-|
| student | student | utente normale |
| root | redhat | amministratore |

## Installazione automatica da script

Consigliamo di utilizzare la seguente procedura per ottenere automaticamente e importare la macchina virtuale: saranno necessari 10GB di spazio libero sul disco, e un utente con permessi di amministratore.

- Aprire un terminale ed effettuare il login con un utente che abbia i premessi di amministratore;

- Scrivere il comando seguente e premere Invio:

```bash
curl -sSL https://raw.githubusercontent.com/extraordy/rh024/master/guides/kvm-install/install_vm.sh | sudo sh
```

Se non si verificheranno errori, il download e l'importazione della macchina virtuale avranno avuto successo.

---

### Installazione manuale passo-passo

## 1. Download

- Aprire un terminale ed effettuare il login con un utente che abbia i premessi di amministratore;

- Scaricare il gruppo di pacchetti software per la virtualizzazione, tramite il seguente comando, a seconda della distribuzione GNU/Linux in uso:

    - #### CentOS / RHEL:
    ```bash
    sudo yum install @virt virt-install virt-viewer virt-v2v
    ```

    - #### Fedora:
    ```bash
    sudo yum install @virtualization virt-install virt-viewer virt-v2v
    ```

- Scaricare l'archivio contenente i file della macchina virtuale da questo [link](https://docs.google.com/uc?export=download&id=1Vs_yrJzBbsgKzMKXtOPK3thvFptKJhBo);

## 2. Installazione

**NOTA**: I seguenti comandi estrarranno dentro `/tmp` i file necessari all'importazione della macchina virtuale

- Estrarre l'archivio scaricato (il pacchetto `tar` è un requisito):

```bash
tar -xzf rh024.tar.gz -C /tmp
```

- Abilitare e avviare il servizio di virtualizzazione:

```bash
sudo systemctl enable libvirtd
sudo systemctl start --now libvirtd
```

## 3. Importare la macchina virtuale

- Importare la macchina virtuale

```bash
virt-v2v -i libvirtxml -o libvirt -os default -n default /tmp/rh024.xml
```

- Pulire i residui

```bash
rm -f /tmp/RH024*.qcow2 /tmp/rh024.xml /tmp/rh024.tar.gz
```

### Errore sul pool di archiviazione

In caso di errore per impossibilità di trovare lo storage pool "default"

```
virt-v2v: error: internal error: invalid argument: cannot find libvirt pool 
‘default’: Storage pool not found: no storage pool with matching name 
'default'
```

sarà necessario definire lo storage pool "default" tramite i seguenti comandi.

- Definire il pool di archiviazione:
```bash
sudo mkdir -p /var/lib/libvirt/images
sudo virsh pool-define-as --name default --type dir --target /var/lib/libvirt/images
```

- Attivare l'avvio automatico e abilitarlo:

```bash
sudo virsh pool-autostart default && sudo virsh pool-start default
```

- Riprovare l'importazione della macchina virtuale col seguente comando:

```bash
sudo virt-v2v -i libvirtxml -o libvirt -os default -n default /tmp/rh024.xml
```

- Pulire i residui (lo script automatico termina l'esecuzione in caso di errore, quindi non avrà ancora pulito i residui):

```bash
sudo rm -f /tmp/RH024*.qcow2 /tmp/rh024.xml ./rh024.tar.gz
```
