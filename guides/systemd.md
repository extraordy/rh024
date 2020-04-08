# Fondamenti di systemd

Systemd fornisce un demone di registrazione e altri strumenti e utilità per facilitare le attività di amministrazione del sistema comuni.
Systemd è un sistema di inizializzazione di Linux e un gestore di servizi che include funzionalità come l'avvio su richiesta di daemon, manutenzione dei punti di mount e mount automatico, supporto di snapshot e tracciamento dei processi tramite i gruppi di controllo Linux. 

In systemd, una units si riferisce a una qualsiasi risorsa su cui il sistema sappia operare e gestire.

Systemd classifica le unità in base al tipo di risorsa che descrivono. Il modo più semplice per determinare il tipo di unità è con il suo suffisso tipo, che viene aggiunto alla fine del nome della risorsa. Il seguente elenco descrive i tipi di unità disponibili per systemd:

- .service: un'unità di servizio descrive come gestire un servizio o un'applicazione sul server.
- .socket: un file di unità socket descrive un socket di rete o IPC o un buffer FIFO che systemd utilizza per l'attivazione basata su socket. 
- .device: un'unità che descrive un dispositivo che è stato designato come necessità della gestione di systemd da udev o dal filesystem sysfs.
- .mount: questa unità definisce un mountpoint sul sistema che deve essere gestito da systemd.
- .automount: un'unità .automount configura un mountpoint che verrà montato automaticamente.
- .swap: questa unità descrive lo spazio di swap sul sistema. 
- .target: un'unità target viene utilizzata per fornire punti di sincronizzazione per altre unità quando si avvia o si cambia stato.
- .path: questa unità definisce un percorso che può essere utilizzato per l'attivazione basata sul percorso. 
- .timer: un'unità .timer definisce un timer che sarà gestito da systemd, in modo simile a un cron job per l'attivazione ritardata o programmata.
- .snapshot: un'unità .snapshot viene creata automaticamente dal comando snapshot di systemctl. Ti consente di ricostruire lo stato corrente del sistema dopo aver apportato modifiche.
- .slice: un'unità .slice è associata ai nodi del gruppo di controllo Linux, consentendo alle risorse di essere limitate o assegnate a tutti i processi associati alla sezione. 
- .scope: le unità di ambito vengono create automaticamente da systemd dalle informazioni ricevute dalle sue interfacce bus. 

Come faccio ad ottenere la lista delle units file nel sistema?

```
# systemctl list-unit-files *.service
UNIT FILE                                    STATE          
sshd.service                                 enabled        
switcheroo-control.service                   enabled        
sysstat-collect.service                      static         
sysstat-summary.service                      static         
sysstat.service                              enabled        
system-update-cleanup.service                static         
systemd-ask-password-console.service         static         
systemd-ask-password-plymouth.service        static         
systemd-ask-password-wall.service            static         
systemd-backlight@.service                   static         
systemd-binfmt.service                       static         
systemd-bless-boot.service                   static         
...

# systemctl list-unit-files *.target
UNIT FILE                     STATE   
anaconda.target               static  
basic.target                  static  
bluetooth.target              static  
boot-complete.target          static  
ctrl-alt-del.target           enabled 
default.target                indirect
emergency.target              static  
exit.target                   disabled
graphical.target              indirect
halt.target                   disabled
hibernate.target              static  
hybrid-sleep.target           static  
...

# systemctl list-unit-files *.mount
UNIT FILE                     STATE    
-.mount                       generated
boot.mount                    generated
dev-hugepages.mount           static   
dev-mqueue.mount              static   
proc-fs-nfsd.mount            static   
proc-sys-fs-binfmt_misc.mount disabled 
run-vmblock\x2dfuse.mount     disabled 
srv.mount                     generated
tmp.mount                     static   
var-lib-machines.mount        static   
var-lib-nfs-rpc_pipefs.mount  static   
...

# systemctl list-unit-files sshd.service
UNIT FILE    STATE  
sshd.service enabled
```

Con il comando *systemctl list-unit-files* abbiamo la possibilità di ottenere la lista delle units file completa, una parte da noi scelta o una unit specifica

Come faccio a far partire un servizio?
```
# systemctl start sshd.service
# systemctl status sshd.service
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2020-04-07 19:28:58 CEST; 3h 39min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
  Process: 7650 ExecReload=/bin/kill -HUP $MAINPID (code=exited, status=0/SUCCESS)
 Main PID: 1329 (sshd)
    Tasks: 1 (limit: 9468)
   Memory: 3.1M
      CPU: 43ms
   CGroup: /system.slice/sshd.service
           └─1329 /usr/sbin/sshd -D -oCiphers=aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes256-cbc,aes128-g>

Apr 07 19:28:58 fed systemd[1]: Starting OpenSSH server daemon...
Apr 07 19:28:58 fed sshd[1329]: Server listening on 0.0.0.0 port 22.
Apr 07 19:28:58 fed sshd[1329]: Server listening on :: port 22.
Apr 07 19:28:58 fed systemd[1]: Started OpenSSH server daemon.
Apr 07 23:04:27 fed systemd[1]: Reloading OpenSSH server daemon.
Apr 07 23:04:27 fed systemd[1]: Reloaded OpenSSH server daemon.
Apr 07 23:04:27 fed sshd[1329]: Received SIGHUP; restarting.
Apr 07 23:04:27 fed sshd[1329]: Server listening on 0.0.0.0 port 22.
Apr 07 23:04:27 fed sshd[1329]: Server listening on :: port 22.
```

Per far partire un servizio basterà eseguire il comando *systemctl start <name>.service* dove <name>.service è il riferimento alla unit file.

Per vedere se il servizio è stato correttamento avviato e vedere lo stato attuale bisogna digitare il comando *systemctl status <name>.service*

Posso far rileggere la configurazione al servizio?
```
# systemctl reload sshd.service
```
Usando l'opzione **reload** faccio rileggere la configurazione senza il bisogno di far ripartire completamente il servizio

```
# systemctl restart sshd.service
```

Con l'opzione **restart** eseguirò il restart completo del servizio

Come si fà per far avviare automaticamente un servizio all'avvio del sistema?

```
# systemctl enable sshd.service
Created symlink /etc/systemd/system/multi-user.target.wants/sshd.service → /usr/lib/systemd/system/sshd.service.
```

Usiamo l'opzione enable per creare un link simbolico in */etc/systemd/system/multi-user.target.wants/* la directory dove sono posizionati i servizi che systemd farà partire all'avvio del sistema.
