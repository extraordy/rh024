Nei comandi base come si conoscono nei sistemi Linux troviamo **mkdir**

```
# mkdir Projects
```
La sua funzione di base è quella di creare una directory, nell'esempio la creazione di una directory
avverrà nella directory dove l'utente è attualmente posizionato.

E' possibile creare più du una directory?
```
# mkdir MyProjects MyDocs MyBooks
```
Così si creeranno 3 directory, e via dicendo, ma per creare una delle sotto directory consecutivamente è possibile?
```
# mkdir -p MyProjects/documentations/examples/
```
Applicanto il -p come opzione al comando si ottiene questo schema: MyProjects -> documentations -> examples.

Come facciamo ad arrivare fino ad *examples*?
```
# cd MyProjects/documentations/examples
```
Il comando base per spostarsi attraverso il filesystem è **cd** che sta per *change directory*
Ora torniamo nella directory precedente
```
# cd -
```
Con il **-** facciamo riferimento ad una variabile di ambiente che ci riporterà alla nostra ultima posizione.
Ora creiamo qualche file, un comando utile per creare un file vuoto è **touch**
```
# touch MyProjects/documentations/examples/file-dinamic.txt
# touch /home/student/MyProjects/documentations/examples/file-static.txt
```
Abbiamo creato due file nella stessa directory, ma come si può notare con diversa metodologia:
1) Il *file-dinamic.txt* è stato creato con un percorso **dinamico**
2) Il *file-static.txt* è stato creato con un percorso **statico**
La differenza è che un *percorso dinamico* parte dalla tua posizione attuale nel filesystem, mentre un *percorso statico*
ha un percorso fisso e non è influenzato dalla tua posizione nel filesystem.
Proviamo ora a cancellare un file e una directory, come si fa?
```
# cd /home/student/MyProjects
# mkdir TempDir
# cd TempDir
# touch file-temp.dat
# ls -l
-rw-rw-r--. 1 student student 0 Apr  4 18:30 file-temp.dat
# rm file-temp.dat
# ls -l
total 0
# cd ..
# ls -l 
drwxrwxr-x. 2 student student 4096 Apr  4 18:31 TempDir
drwxrwxr-x. 2 student student 4096 Apr  4 18:31 documentations
# rm -r TempDir
# ls -l 
drwxrwxr-x. 2 student student 4096 Apr  4 18:31 documentations
```
In questo esempio abbiamo eseguito varie azioni, abbiamo creato una directory *TempDir* e creato 
successivamente un file *file-temp.dat*, poi grazie al comando **rm** siamo riusciti sia a cancellare il file,
sia a cancellare la directory, per il file abbiamo invocato il comando senza parametri al contrario per la 
directory abbiamo posto l'opzione **-r**, quest'opzione sta per *recursive* un parametro necessario quando 
si vuole cancellare una directory.
Un altro metodo che potevamo utilizzare è **rmdir** un altro comando per cancellare una
*directory che sia necessariamente vuota*.

Come si fa a creare un link tra file?
```
# cd /home/student/MyProjects
# touch programma1 programma2
# ls -l
-rw-rw-r--. 2 student student 5 Apr  4 21:01 programma1
-rw-rw-r--. 1 student student 0 Apr  4 21:01 programma2
# ln programma1 programma3
# ls -li 
2764406 -rw-rw-r--. 2 student student 5 Apr  4 21:01 programma1
2766313 -rw-rw-r--. 1 student student 0 Apr  4 21:01 programma2
2764406 -rw-rw-r--. 2 student student 5 Apr  4 21:01 programma3
```
Come possiamo vedere programma1 e programma3 hanno in comune lo stesso inode *2764406* questo tipo di
link si chiama **hard link** fa riferimento alla posizione specifica dei dati fisici.
Come posso eseguire un link **simbolico** tra file?
```
# cd /home/student/MyProjects 
# ls -l
-rw-rw-r--. 2 student student  5 Apr  4 21:01 programma1
-rw-rw-r--. 1 student student  0 Apr  4 21:01 programma2
-rw-rw-r--. 2 student student  5 Apr  4 21:01 programma3
# ln -s programma2 programma4
# ls -l
-rw-rw-r--. 2 student student  5 Apr  4 21:01 programma1
-rw-rw-r--. 1 student student  0 Apr  4 21:01 programma2
-rw-rw-r--. 2 student student  5 Apr  4 21:01 programma3
lrwxrwxrwx. 1 student student 10 Apr  4 21:05 programma4 -> programma2
```
Questo tipo di link si chiama **soft link** crea come in questo caso un percorso simbolico che indica 
la posizione astratta di un altro file, il programma4 fa riferimento in maniera astratta al programma2
si esegue aggiungendo l'opzione -s che sta ad indicare *symbolic*.