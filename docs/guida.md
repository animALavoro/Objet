# Objet: guida per gli studenti

*English: [guide.md](guide.md)*

Objet è una suite di strumenti per il suono immersivo in REAPER: un panner multicanale e Ambisonics che si controlla anche sul video, una vista della scena con la misura della loudness, un monitor binaurale per la cuffia e un'app che porta in REAPER le timeline montate in Resolve.

**Indice**
1. [Cosa c'è nella suite](#1-cosa-cè-nella-suite)
2. [Cosa ti serve](#2-cosa-ti-serve)
3. [Installare REAPER](#3-installare-reaper)
4. [Installare Objet](#4-installare-objet)
5. [La configurazione di REAPER del corso e le estensioni](#5-la-configurazione-di-reaper-del-corso-e-le-estensioni)
6. [Primi passi](#6-primi-passi)
7. [Dalla timeline di Resolve a REAPER (OTIO to RPP)](#7-dalla-timeline-di-resolve-a-reaper-otio-to-rpp)
8. [Aggiornare e disinstallare](#8-aggiornare-e-disinstallare)
9. [Problemi frequenti](#9-problemi-frequenti)

---

## 1. Cosa c'è nella suite

| Strumento | Cos'è | Dove si mette |
|---|---|---|
| **Objet Pa** | Panner: posiziona i canali di una traccia (da mono a 9.1.6) in una stanza di diffusori fino a 9.1.6 o in Ambisonics fino al 5° ordine. Si controlla con il mouse, dall'iPad (web app integrata) e trascinando i puck direttamente sul video. | Su ogni traccia da posizionare |
| **Objet a Scene** | Tutti i panner del progetto in una stanza o in un globo, loudness (EBU R 128), mappa d'energia, gestione di massa dei panner (pagina PROJECT). | Una volta sola, sul master |
| **Objet a Monitor** | Ascolto in cuffia (binaurale) di quello che esce dal master, vista 360 del video, visore. | Una volta sola, sul master (dopo Scene) |
| **OTIO to RPP** | App che converte una timeline esportata da Resolve (`.otio`) in un progetto REAPER (`.rpp`). | App a sé |

I tre plugin sono VST3 e girano in REAPER su Windows e macOS.

## 2. Cosa ti serve

- Un computer con **Windows 10 / 11 (64 bit)** o **macOS 11 o successivo** (Apple silicon o Intel; l'app OTIO to RPP per Mac richiede Apple silicon).
- **REAPER 7** (vedi il capitolo 3).
- Una **cuffia** per l'ascolto binaurale con Objet a Monitor.
- Facoltativi: un **iPad** (o un altro tablet / telefono) sulla stessa rete Wi-Fi per controllare il panner; un **visore** per Objet a Monitor (serve anche `adb`, vedi il README di Monitor).

## 3. Installare REAPER

1. Scarica REAPER da **reaper.fm** → *Download* (Windows 64 bit, oppure macOS universale).
2. Installalo come qualsiasi programma (su Mac: apri il `.dmg` e trascina REAPER in Applicazioni).
3. REAPER si può usare in valutazione per 60 giorni con tutte le funzioni. Dopo serve una licenza; per l'uso personale e per gli studenti c'è una licenza a prezzo ridotto (vedi reaper.fm).
4. Aprilo una volta e chiudilo (*File > Quit* su Windows, *REAPER > Quit REAPER* su Mac): così REAPER crea le sue cartelle.

## 4. Installare Objet

Si installa con una riga, sempre con **REAPER chiuso**. La stessa riga serve anche ad aggiornare.

### macOS
1. Apri il **Terminale** (Applicazioni > Utility > Terminale).
2. Incolla questa riga e premi Invio:
   ```
   curl -fsSL https://github.com/animALavoro/Objet/releases/latest/download/install-mac.sh | bash
   ```
3. Installa i tre plugin in `~/Library/Audio/Plug-Ins/VST3`, l'app *OTIO to RPP* nella cartella Applicazioni della tua utenza (Finder > Vai > Inizio > Applicazioni) e le estensioni di REAPER **ReaPack** e **ReaImGui**. Non chiede password.
4. Apri REAPER: *REAPER > Settings > Plug-ins > VST* → **Clear cache/re-scan**.

**Perché dal Terminale?** I plugin non hanno la firma di uno sviluppatore Apple: se li scarichi con il browser, macOS li blocca. Quelli scaricati dal Terminale invece si aprono normalmente. Se hai già scaricato uno zip con il browser e REAPER all'avvio mostra *"… Not Opened. Apple could not verify …"* (il messaggio torna a ogni **Done**), lascialo lì, apri il Terminale e lancia:
```
xattr -dr com.apple.quarantine ~/Library/Audio/Plug-Ins/VST3/"LB Spanner.vst3"
```
(per gli altri: `Objet a Scene.vst3`, `Objet a Monitor.vst3`), poi premi **Done** una volta.

### Windows
1. Apri **PowerShell** (tasto Windows, scrivi *PowerShell*, Invio).
2. Incolla questa riga e premi Invio:
   ```
   irm https://github.com/animALavoro/Objet/releases/latest/download/install-windows.ps1 | iex
   ```
3. Windows chiede una volta il permesso di modificare il computer: rispondi **Sì**. I plugin vanno in `C:\Program Files\Common Files\VST3`, l'app *OTIO to RPP* nel menu Start, le estensioni **ReaPack** e **ReaImGui** nella cartella di REAPER.
   Se rispondi No, i plugin vanno nella tua cartella utente e lo script ti dice quale percorso aggiungere in REAPER.
4. Apri REAPER: *Options > Preferences > Plug-ins > VST* → **Clear cache/re-scan**.

### Controllo
Su una traccia: **FX** → cerca *Objet*. Devono comparire **Objet Pa**, **Objet a Scene** e **Objet a Monitor**. Il file di Objet Pa si chiama `LB Spanner.vst3` (è il suo vecchio nome, rimasto perché i progetti salvati lo ritrovino).

## 5. La configurazione di REAPER del corso e le estensioni

Il corso usa una configurazione di REAPER già preparata: gli archivi di ReaPack (anche quelli del Pie menu e di NVK), le scorciatoie da tastiera, il Pie menu e alcune impostazioni di progetto (i media importati vengono copiati nella cartella *Media* del progetto, salvataggi automatici). Si importa una volta, dopo l'installazione:

1. Scarica il file di configurazione dalla [pagina delle release](https://github.com/animALavoro/Objet/releases/latest): *Cinema_Immersivo.ReaperConfigZip*.
2. In REAPER: *Options > Preferences* (Windows) o *REAPER > Settings* (Mac) → **General** → **Import configuration…** → scegli il file.
3. REAPER chiede di riavviarsi: conferma.

L'importazione sostituisce le impostazioni di REAPER che hai adesso: se usi già REAPER per altro, prima salva le tue con **Export configuration…** nella stessa pagina.

I template di progetto del corso te li dà il docente a parte.

### Le estensioni (ReaPack, SWS, Pie menu, NVK Search)
L'installazione mette già in REAPER **ReaPack** (il gestore dei pacchetti di REAPER) e **ReaImGui** (serve a molti script). Dopo aver importato la configurazione del corso, il resto si installa da ReaPack, una volta (gli archivi sono già impostati):

1. In REAPER: *Extensions > ReaPack > Browse packages…*
2. Cerca e installa (clic destro sul pacchetto → *Install*, poi **Apply**):
   - **SWS/S&M extension** (azioni e funzioni in più usate nel corso);
   - **Pie3000** (il menu circolare, "pie menu");
   - **nvk_SEARCH** (la ricerca veloce di azioni, FX, tracce e media).
3. Riavvia REAPER.

Scorciatoie del corso che usano questi pacchetti: **C** apre il Pie menu, **\*** del tastierino numerico apre nvk_SEARCH, **T** e **Tab** usano azioni di SWS. Finché il pacchetto non è installato, quella scorciatoia non fa nulla.

Se un pacchetto non compare nella ricerca: *Extensions > ReaPack > Synchronize packages* (aggiorna gli elenchi) e cerca di nuovo.

## 6. Primi passi

### Il numero di canali delle tracce
Una traccia di REAPER ha 2 canali se non lo cambi. Objet Pa ha bisogno di tanti canali quanti ne usa il formato più grande tra ingresso e uscita: **6** per 5.1, **12** per 7.1.4, **16** per 9.1.6 o per Ambisonics di 3° ordine, **36** per il 5° ordine. Si imposta dal pulsante **ROUTE** della traccia (*Track channels*). Anche il master deve avere i canali del formato d'uscita.

### Objet Pa su una traccia
1. Sulla traccia: **FX** → **Objet Pa**.
2. In alto scegli **ingresso** (il formato del suono della traccia: mono, stereo, 5.1…) e **uscita** (il formato del master: 5.1, 7.1.4, HOA…).
3. Trascina i **puck** nel campo per muovere i canali; i comandi del **Bed** (Pan, Front-Back, Height, Width, Rotate…) muovono tutto insieme.
4. Le automazioni dei parametri si scrivono come in qualsiasi plugin di REAPER; la finestra **Paths** disegna percorsi e li scrive come automazione.

### I puck sul video
1. In REAPER apri la finestra video (*View > Video*).
2. In Objet Pa: pagina **Setup** → accendi **Video overlay** (o il pulsante **Video** in alto).
3. I puck della traccia selezionata compaiono sul video e si trascinano lì: nei formati a canali da sinistra a destra, in Ambisonics su tutto il 360 (il video va trattato come equirettangolare).
4. In Ambisonics il Setup può mostrare anche la **mappa d'energia**: dove sta l'energia del suono, sotto i puck.

### Scene e Monitor sul master
1. Sul master: **FX** → **Objet a Scene**, poi **Objet a Monitor** (in quest'ordine).
2. **Scene** mostra tutti i panner del progetto nella stanza (o nel globo, in Ambisonics), misura la loudness e, nella pagina **PROJECT**, cambia formati e impostazioni di molti panner insieme.
3. **Monitor** porta l'uscita in cuffia (*Output > Binaural*). Con un video 360: **Add 360 view** in Monitor, poi trascina sul video per guardarti intorno (rotella = zoom); la scena gira con te.

### Dall'iPad
In Objet Pa: **Setup** → **Web remote** → inquadra il **QR code** con l'iPad (stessa rete Wi-Fi del computer). Si apre un'app nel browser che segue la traccia selezionata in REAPER. La prima volta il computer può chiedere di permettere a REAPER l'accesso alla rete: consentilo per le reti private.

## 7. Dalla timeline di Resolve a REAPER (OTIO to RPP)

1. In Resolve: *File > Export > Timeline…* → formato **OpenTimelineIO** (`.otio`), oppure un bundle `.otioz` con i media dentro.
2. Apri **OTIO to RPP** (Mac: Applicazioni della tua utenza; Windows: menu Start).
3. **File OTIO**: il file esportato. **Progetto Reaper**: dove salvare il `.rpp` (proposto con lo stesso nome).
4. **Cerca media in** (facoltativo): se i file audio non sono più dove erano durante il montaggio, l'app li cerca per nome in questa cartella.
5. Con **Copia i media nella cartella "Media"** (acceso di default) i file usati vengono copiati accanto al progetto: la cartella del progetto si può spostare o portare su un altro computer.
6. **Converti**, poi **Apri in Reaper**.

Vengono convertite tracce audio, clip (posizione, durata, offset), clip disattivate, cambi di velocità lineari, dissolvenze e il timecode di inizio. Non vengono convertiti: video, marker, clip composite, volume / pan delle clip, mappatura dei canali; li trovi elencati nel riquadro dei messaggi.

## 8. Aggiornare e disinstallare

- **Aggiornare**: rilancia la stessa riga del capitolo 4, con REAPER chiuso.
- **Disinstallare su Mac**: cancella `LB Spanner.vst3`, `Objet a Scene.vst3`, `Objet a Monitor.vst3` da `~/Library/Audio/Plug-Ins/VST3` e *OTIO to RPP* dalle Applicazioni della tua utenza.
- **Disinstallare su Windows**: cancella le tre cartelle `.vst3` da `C:\Program Files\Common Files\VST3`, la cartella `%LOCALAPPDATA%\Programs\OTIO to RPP` e il collegamento nel menu Start.

## 9. Problemi frequenti

| Problema | Soluzione |
|---|---|
| REAPER non trova i plugin | REAPER era chiuso durante l'installazione? Poi *Plug-ins > VST* → **Clear cache/re-scan**. Su Windows, se avevi risposto No alla richiesta di permesso, aggiungi il percorso indicato dallo script. |
| "REAPER is open" | Chiudi REAPER dal menu (*Quit*), non solo la finestra, e rilancia la riga. |
| Mac: "… Not Opened. Apple could not verify …" | Vedi il capitolo 4, macOS: comando `xattr`, poi **Done**. |
| Nessun suono o canali che mancano | Controlla i canali della traccia e del master (capitolo 6). |
| I puck non compaiono sul video | Finestra video aperta (*View > Video*), **Video overlay** acceso in Setup, la traccia con Objet Pa selezionata, REAPER in primo piano. La riga di stato nel Setup dice se la finestra video è stata trovata. |
| L'iPad non si collega | Stessa rete Wi-Fi; permesso di rete a REAPER; prova a riaprire il QR code. |
| La riga per Windows dà un errore sui criteri di esecuzione | Apri PowerShell e lancia prima `Set-ExecutionPolicy -Scope Process Bypass`, poi la riga. |

Per tutto il resto: chiedi al docente, indicando sistema operativo, versione di REAPER e il messaggio d'errore esatto.
