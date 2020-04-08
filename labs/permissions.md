# Permessi sui file
   
Partendo dall'assunzione di base che 'In linux tutto è un file', possiamo iniziare il nostro viaggio alla scoperta di particolari caratteristiche dei file all'interno del nostro filesystem, i **permessi**.   
   
I permessi sono un attributo fondamentale dei file, che permettono di identificare chiaramente chi potrà accedervi e quali saranno le azioni che potranno essere eseguite su di esso.   
   
E' possibile gestire 3 tipologie di accesso, ognuna di esse ha un rispettivo significato a seconda che lo si stia applicando ad un file semplice o ad una directory, per questo andiamo ad esplorarli!    
   
**r  - read**    
File - Permette di gestire la visualizzazione e l'accesso, in sola lettura, ad un file.    
Directory - Permette di listare il contenuto di una directory, senza permettere di 'entrarci'   
   
**w - write**   
File - Permette di gestire la possibilità o meno di accedere ad un file e poterlo modificare, nel suo contenuto o ad esempio solo il nome.    
Directory - permette di modificarne il nome e permettere di creare file al suo interno.   
   
**x - execute**   
File - indica il permesso fondamentale per permettere l'esecuzione di codice, comandi o script presenti all'interno di un file.   
Directory - E' il permesso che permette l'attraversamento della directory, in sostanza la possibilità o meno di poter eseguire il comando "**cd**"  per spostarci all'interno di una determinata directory.   
   
Questi sono i permessi di base che possiamo andare ad impostare su una singola risorsa, sia esso un file o un file 'speciale', ovvero una directory.   
   
Sicuramente a questo punto vi starete chiedendo: Ma tutti gli utenti possono fare le stesse cose?    
Assolutamente no!    
Per questo Linux ci mette a disposizione altri 3 differenti livelli di accesso, ognuno dei quali sarà configurabile con i permessi che abbiamo appena visto.   
Questi livelli di accesso sono:   
   
**u** - Utente proprietario del file   
**g** - Gruppo proprietario del file   
**o** - Others, ossia tutti gli altri utenti   
   
Ogni singolo livello può avere associato uno o più permessi d'accesso.   
   
Andiamo a vedere cosa vuol dire all'atto pratico.   
   
Partiamo dal principio e creiamo una directory con il comando **mkdir**   
   
    [student@server rh024]$ mkdir permissions   
   
Una volta creata, andiamo ad utilizzare un comando che già conosciamo, **ls**, per andare a vedere qualche informazione in più, utilizzeremo l'opzione (modificatore) "**-l**" per andare a listare tutte le informazioni ad essa relative e l'opzione "**-d**" per specificare che vogliamo le informazioni relative ad una directory.   
   
    [student@server rh024]$ ls -ld permissions/   
    drwxrwxr-x. 2 student student 4096  5 apr 16.29 permissions/   
   
Andiamo ad analizzare nel dettaglio cosa ci viene riportato, partendo dai primi nove caratteri:   
   
       u   g   o -> Questi sono i tre livelli di accesso   
       |   |   |   
    d rwx rwx r-x -> Questi sono i permessi, a tre a tre, per i singoli livelli d'accesso   
    |   
    - > Questo indica che il file è una directory   
   
Vediamo poi, che è presente la parola 'student' due volte:   
       
     -> Utente proprietario della directory   
    |   
    student student   
              |   
               -> Gruppo proprietario della directory   
   
Ricordando la definizione che abbiamo dato prima delle singole permission, e ricordando che stiamo parlando di una **directory**, possiamo dire che:   
   
L'**utente student** e **gli utenti che appartengono al gruppo student** possono:   
   
 - Visualizzare il contenuto della directory.   
 - Attraversare la directory.   
 - Effettuare modifiche, creare file, rinominare la directory.   
   
**Tutti gli altri utenti** possono solamente:   
 - Visualizzare il contenuto della directory.   
 - Attraversare la directory.   
   
Per verificare, proviamo a creare un file all'interno della cartella appena creata con l'utente **newuser**, che non è il proprietario della directory né appartiene al gruppo proprietario della directory, utilizzando l'utility **touch**, che crea un file vuoto prendendo come argomento un nome da assegnargli:   
   
    [newuser@server rh024]$ touch permissions/testcreazione   
    touch: impossibile fare touch di 'permissions/testcreazione': Permesso negato   
   
Proviamo invece con l'utente **student**:   
   
    [student@server rh024]$ touch permissions/testcreazione   
    [student@server rh024]$ cd permissions/   
    [student@server permissions]$ ls -l   
    -rw-rw-r--. 1 student student 0  5 apr 16.52 testcreazione   
   
Vediamo che non solo ha correttamente creato il file, ma abbiamo verificato che in effetti possiamo sia attraversare la directory ed entrare al suo interno con cd, ma possiamo anche vederne il contenuto.   
   
Le nostre permission hanno funzionato!    
   
   
   
## Modifica delle permission di un file   
Ora che abbiamo visto come effettivamente vengono gestiti i permessi in Linux, andiamo a vedere come possiamo cambiare le permission di un file o una directory esistenti.   
   
Innanzitutto, i 3 permessi di base, ossia lettura (r), scrittura (w) ed esecuzione (x), assegnati ad un utente proprietario (u), gruppo proprietario (g) o tutti gli altri utenti (o), presi a tre a tre vanno a formare i cosiddetti ottetti delle permission.   
   
Vediamo perché.   
   
Se associamo alla presenza o meno di un particolare permesso ad uno 0 (zero) o ad un 1 (uno), possiamo facilmente dire che ad esempio associare permessi di lettura, scrittura ed esecuzione, equivarrebbe a:   
   
rwx --> 111    
   
Nella numerazione ottale, quel 111 rappresenta proprio il 7, il che vuol dire che tutti i permessi attivati.   
   
Estendendo questo ragionamento a tutte le permutazioni possibili avremo che:   
   
    111 (7) --> rwx | Lettura, scrittura ed esecuzione   
    110 (6) --> rw- | Solo lettura e scrittura   
    101 (5) --> r-x | Solo lettura ed esecuzione   
    100 (4) --> r-- | Solo lettura   
    011 (3) --> -wx | Solo scrittura ed esecuzione / attraversamento   
    010 (2) --> -w- | Solo scrittura   
    001 (1) --> --x | Solo attraversamento / Esecuzione   
    000 (0) --> --- | Nessun permesso!   
   
Andiamo ad applicare questo ragionamento all'output precedente:   
   
     u   g   o   
     |   |   |   
    rwx rwx r-x    
     7   7   5   
   
Introduciamo ora il comando **chmod**, che permette di andare a modificare proprio le permission, chiamate anche a basso livello i '**mode**' del file, da qui il nome del programma (ch -> change, mod -> mode)   
   
Innanzitutto, per eseguire l'operazione è necessario che sia **l'utente proprietario** a lanciarla o che venga lanciata da un utente con privilegi di root (con sudo, o direttamente con l'utente root).   
   
chmod ci permette di andare a modificare i permessi di un file, utilizzando sia la rappresentazione numerica sia la rappresentazione basata sui singoli livelli d'accesso.   
   
La sua sintassi è:   
   
    chmod [opzioni] mode nomefile   
   
Dove **mode** è ad esempio il set di permessi che vogliamo andare a dare.   
   
Prendiamo in esempio il file che abbiamo creato prima:   
   
    [student@server permissions]$ ls -l   
    -rw-rw-r--. 1 student student 0  5 apr 16.52 testcreazione   
   
Se volessimo cambiare le permission del file creato prima, in modo tale che:   
   
 - L'utente proprietario possa leggere,scrivere ed eseguire il file | rwx  (7)   
 - Il gruppo proprietario possa solo leggere il file |  r--  (4)   
 - Tutti gli altri utenti non possano eseguire azioni sul file | --- (0)   
   
Potremmo, utilizzando la notazione ottale eseguire il seguente comando:   
   
    [student@server permissions]$ chmod 740 testcreazione    
    [student@server permissions]$ ls -l   
    -rwxr-----. 1 student student 0  5 apr 16.52 testcreazione   
   
Possiamo anche utilizzare un'altra notazione, quella di assegnazione, che ci permette, per ogni livello di accesso quali sono i permessi che si vogliono, sia per singolo livello di accesso, sia per tutti i livelli:   
   
    Assegnare permessi, utilizzando il simbolo "="   
    Aggiungere singoli permessi, utilizzando il simbolo "+"   
    Rimuovere singoli permessi, utilizzando il simbolo "-"   
   
Per ottenere lo stesso risultato, avremmo potuto fare in più modi:   
   
Assegnando direttamente tutti e tre i livelli di permesso:   
   
    [student@server permissions]$ chmod u=rwx,g=r,o=- testcreazione    
    [student@server permissions]$ ls -tlr   
    totale 0   
    -rwxr-----. 1 student student 0  5 apr 16.52 testcreazione   
   
A partire dalla situazione iniziale avremmo potuto:   
   
 - Aggiungere permessi di esecuzione all'utente proprietario (u+x)   
 - Rimuovere i permessi di scrittura al gruppo proprietario (g-w)   
 - Rimuovere i permessi di lettura a tutti gli altri utenti (o-x)   
   
Il nostro comando sarebbe diventato:   
   
    [student@server permissions]$ chmod u+x,g-w,o-r testcreazione    
    [student@server permissions]$ ls -l   
    -rwxr-----. 1 student student 0  5 apr 16.52 testcreazione   
   
Come vedete, in tutti e tre i casi il risultato è esattamente lo stesso!    
   
**Attenzione!**   
Qualora stessimo modificando i permessi di una directory, di default la modifica non si rifletterebbe sul suo contenuto, ma solamente su di essa.   
Per fare in modo di applicare **ricorsivamente** la modifica, è sufficiente utilizzare l'opzione "-R" (Maiuscola!) del comando **chmod**:   
   
    [student@server rh024]$ ls -l permissions/   
    -rw-rw-r--. 1 student student 0  5 apr 17.34 test1   
    -rw-rw-r--. 1 student student 0  5 apr 17.34 test2   
    -rw-rw-r--. 1 student student 0  5 apr 17.34 test3   
    [student@server rh024]$ ls -ld permissions/   
    drwxrwxr-x. 2 student student 4096  5 apr 17.34 permissions/   
   
Andiamo a modificarle:   
   
    [student@server rh024]$ chmod -R 777 permissions/   
    [student@server rh024]$ ls -l permissions/   
    -rwxrwxrwx. 1 student student 0  5 apr 17.34 test1   
    -rwxrwxrwx. 1 student student 0  5 apr 17.34 test2   
    -rwxrwxrwx. 1 student student 0  5 apr 17.34 test3   
    [student@server rh024]$ ls -ld permissions/   
    drwxrwxrwx. 2 student student 4096  5 apr 17.34 permissions/   
   
   
   
## Modifica dell'ownership di un file   
Allo stesso modo, è possibile andare a modificare **l'utente ed il gruppo proprietari** di un file, utilizzando il comando **chown** (ch -> change, own -> owner)   
   
Partendo sempre dal nostro file di esempio:   
   
    [student@server permissions]$ ls -l   
    -rw-rw-r--. 1 student student 0  5 apr 16.52 testcreazione   
   
Andiamo a vedere come possiamo assegnare il file **all'utente newuser ed al gruppo newuser**.   
   
Innanzitutto, per eseguire l'operazione è necessario, a differenza della modifica dei permessi che venga lanciata da un utente con privilegi di root (con sudo, o direttamente con l'utente root)!   
   
La sintassi del comando **chown** è la seguente:   
   
    chown utente[:gruppo] nomefile   
   
:gruppo viene tenuto tra parentesi perché non è obbligatorio modificare anche il gruppo, ma è possibile comunque farlo.   
   
Proviamo quindi ad assegnare il file all'utente newuser:   
   
    [student@server permissions]$ sudo chown newuser testcreazione    
    [student@server permissions]$ ls -l   
    -rwxrwxrwx. 1 newuser student 0  5 apr 17.42 testcreazione   
   
Proviamo ad assegnare il file, oltre all'utente newuser, anche al gruppo newuser:   
   
    [student@server permissions]$ sudo chown newuser:newuser testcreazione    
    [student@server permissions]$ ls -l   
    -rwxrwxrwx. 1 newuser newuser 0  5 apr 17.42 testcreazione   
   
In questo modo, l'utente newuser ed i membri del gruppo newuser sono i proprietari del file, e per loro valgono quindi i primi due ottetti dei permessi, mentre fino a quel momento, avrebbero avuto solamente i permessi relativi all'utente '**other**', quindi a tutto il resto degli utenti!   
   
**Attenzione!**   
Qualora stessimo modificando l'ownership di una directory, di default la modifica non si rifletterebbe sul suo contenuto, ma solamente su di essa.   
Per fare in modo di applicare **ricorsivamente** la modifica, è sufficiente utilizzare l'opzione "-R" (Maiuscola!) del comando **chown**:   
   
    [student@server rh024]$ ls -l permissions/   
    -rw-rw-r--. 1 student student 0  5 apr 17.34 test1   
    -rw-rw-r--. 1 student student 0  5 apr 17.34 test2   
    -rw-rw-r--. 1 student student 0  5 apr 17.34 test3   
    [student@server rh024]$ ls -ld permissions/   
    drwxrwxr-x. 2 student student 4096  5 apr 17.34 permissions/   
   
Andiamo a modificarle:   
   
    [student@server rh024]$ chown -R newuser:newuser permissions/   
    [student@server rh024]$ ls -l permissions/   
    -rwxrwxrwx. 1 newuser newuser 0  5 apr 17.34 test1   
    -rwxrwxrwx. 1 newuser newuser 0  5 apr 17.34 test2   
    -rwxrwxrwx. 1 newuser newuser 0  5 apr 17.34 test3   
    [student@server rh024]$ ls -ld permissions/   
    drwxrwxrwx. 2 newuser newuser 4096  5 apr 17.34 permissions/   
   
   
## Esercizio   
   
Creare una directory "rh024-permissions" ed assegnargli i seguenti permessi:   
   
 - Utente proprietario: Lettura, Scrittura, Attraversamento   
 - Gruppo proprietario: Lettura, Attraversamento   
 - Altri: Nessun permesso   
   
Creare all'interno della directory tre file, file1, file2 e file3 e modificare i permessi della directory e del suo contenuto in questo modo:   
   
 - Utente proprietario: Lettura, Scrittura, Attraversamento   
 - Gruppo proprietario: Lettura   
 - Altri: Lettura   
   
Sempre ricorsivamente, modificare l'owner della directory e del suo contenuto, assegnandolo all'utente **root** ed al gruppo **root**.   
Con l'utente student, verificare che è possibile listare il contenuto della diretory, ma non è possibile vedere altre informazioni.   
   
## Soluzione   
   
    mkdir rh024-permissions   
   
    [student@server rh024]$ ls -l   
    drwxrwxr-x. 2 student student 4096  5 apr 17.55 rh024-permissions   
   
    chmod 750 rh024-permissions   
   
    [student@server rh024]$ chmod 750 rh024-permissions   
    [student@server rh024]$ ls -l   
    drwxr-x---. 2 student student 4096  5 apr 17.55 rh024-permissions   
   
    touch rh024-permissions/file1 rh024-permissions/file2 rh024-permissions/file3   
   
    [student@server rh024]$     touch rh024-permissions/file1 rh024-permissions/file2 rh024-permissions/file3   
    [student@server rh024]$ ls -l rh024-permissions/   
    -rw-rw-r--. 1 student student 0  5 apr 17.55 file1   
    -rw-rw-r--. 1 student student 0  5 apr 17.55 file2   
    -rw-rw-r--. 1 student student 0  5 apr 17.55 file3   
   
    chmod -R 744 rh024-permissions   
       
    [student@server rh024]$ chmod -R 744 rh024-permissions   
    [student@server rh024]$ ls -l rh024-permissions/   
    totale 0   
    -rwxr--r--. 1 student student 0  5 apr 17.55 file1   
    -rwxr--r--. 1 student student 0  5 apr 17.55 file2   
    -rwxr--r--. 1 student student 0  5 apr 17.55 file3   
    [student@server rh024]$ ls -ld rh024-permissions/   
    drwxr--r--. 2 student student 4096  5 apr 17.55 rh024-permissions/   
       
    sudo chown -R root:root rh024-permissions   
       
    [student@server rh024]$ sudo chown -R root:root rh024-permissions   
    [student@server rh024]$ ls -ld rh024-permissions/   
    drwxr--r--. 2 root root 4096  5 apr 17.55 rh024-permissions/   
    [student@server rh024]$ ls -l rh024-permissions/   
    ls: impossibile accedere a 'rh024-permissions/file1': Permesso negato   
    ls: impossibile accedere a 'rh024-permissions/file2': Permesso negato   
    ls: impossibile accedere a 'rh024-permissions/file3': Permesso negato   
    -????????? ? ? ? ?            ? file1   
    -????????? ? ? ? ?            ? file2   
    -????????? ? ? ? ?            ? file3   
   
