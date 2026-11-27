# Objet, corso di post produzione: guida per gli studenti

*English: [guide.md](guide.md)*

Il kit del corso di post produzione del cortometraggio: gli strumenti per portare in REAPER il montaggio fatto in Resolve, sistemare i file del registratore e misurare la loudness del mix, con la configurazione di REAPER del corso.

**Indice**
1. [Cosa c'è nel kit](#1-cosa-cè-nel-kit)
2. [Cosa ti serve](#2-cosa-ti-serve)
3. [Installare REAPER](#3-installare-reaper)
4. [Installare il kit](#4-installare-il-kit)
5. [La configurazione di REAPER del corso e le estensioni](#5-la-configurazione-di-reaper-del-corso-e-le-estensioni)
6. [Dalla timeline di Resolve a REAPER (OTIO to RPP)](#6-dalla-timeline-di-resolve-a-reaper-otio-to-rpp)
7. [Spacchettare i polywav del registratore (Polywav Manager)](#7-spacchettare-i-polywav-del-registratore-polywav-manager)
8. [Misurare la loudness (Objet a Loudness)](#8-misurare-la-loudness-objet-a-loudness)
9. [Aggiornare e disinstallare](#9-aggiornare-e-disinstallare)
10. [Problemi frequenti](#10-problemi-frequenti)

---

## 1. Cosa c'è nel kit

| Strumento | Cos'è | Dove si mette |
|---|---|---|
| **OTIO to RPP** | App che converte una timeline esportata da Resolve (`.otio`) in un progetto REAPER (`.rpp`). | App a sé |
| **Polywav Manager** | Script per REAPER: mette i file mono di ogni canale dei polywav del registratore ognuno sulla sua traccia. | Lista delle azioni di REAPER |
| **Objet a Loudness** | Misuratore di loudness (VST3). | Sul master |
| **ZL Equalizer 2, ZL Compressor, ZL Limiter** | Equalizzatore, compressore e limiter (VST3, gratuiti, di ZL Audio). | Sulle tracce e sul master |
| **Dragonfly Reverb** | Riverberi Hall, Room, Plate ed Early Reflections (VST3, gratuiti). | Sulle tracce o sui bus |
| **Template di progetto** | Tracce, bus e routing del mix del corto, pronti. | *File > Project templates* |
| **Configurazione del corso** | Scorciatoie, Pie menu, impostazioni di progetto, archivi di ReaPack. | Si importa in REAPER una volta |

## 2. Cosa ti serve

- Un computer con **Windows 10 / 11 (64 bit)** o **macOS 11 o successivo** (Apple silicon o Intel; l'app OTIO to RPP per Mac richiede Apple silicon).
- **REAPER 7** (capitolo 3).
- Una **cuffia** o dei diffusori per l'ascolto.

## 3. Installare REAPER

1. Scarica REAPER da **reaper.fm** → *Download* (Windows 64 bit, oppure macOS universale).
2. Installalo come qualsiasi programma (su Mac: apri il `.dmg` e trascina REAPER in Applicazioni).
3. REAPER si può usare in valutazione per 60 giorni con tutte le funzioni. Dopo serve una licenza; per l'uso personale e per gli studenti c'è una licenza a prezzo ridotto (vedi reaper.fm).
4. Aprilo una volta e chiudilo (*File > Quit* su Windows, *REAPER > Quit REAPER* su Mac): così REAPER crea le sue cartelle.

## 4. Installare il kit

Si installa con una riga, sempre con **REAPER chiuso**. La stessa riga serve anche ad aggiornare.

### macOS
1. Apri il **Terminale** (Applicazioni > Utility > Terminale).
2. Incolla questa riga e premi Invio:
   ```
   curl -fsSL https://github.com/animALavoro/Objet/releases/download/post/install-mac.sh | bash
   ```
3. Installa l'app *OTIO to RPP* nella cartella Applicazioni della tua utenza (Finder > Vai > Inizio > Applicazioni), lo script *Polywav Manager* nella cartella Scripts di REAPER, *Objet a Loudness*, ZL Equalizer 2, ZL Compressor, ZL Limiter e Dragonfly Reverb in `~/Library/Audio/Plug-Ins/VST3` e le estensioni e gli script di REAPER del corso (**ReaPack**, **SWS**, **js_ReaScriptAPI**, **ReaImGui**, Pie menu, nvk_SEARCH, capitolo 5). Non chiede password.

**Perché dal Terminale?** Le app e i plugin del kit non hanno la firma di uno sviluppatore Apple: se li scarichi con il browser, macOS li blocca. Quelli scaricati dal Terminale invece si aprono normalmente.

### Windows
1. Apri **PowerShell** (tasto Windows, scrivi *PowerShell*, Invio).
2. Incolla questa riga e premi Invio:
   ```
   irm https://github.com/animALavoro/Objet/releases/download/post/install-windows.ps1 | iex
   ```
3. *OTIO to RPP* va nel menu Start, lo script *Polywav Manager*, le estensioni e gli script del corso (**ReaPack**, **SWS**, **js_ReaScriptAPI**, **ReaImGui**, Pie menu, nvk_SEARCH, capitolo 5) nella cartella di REAPER. *Objet a Loudness*, ZL Equalizer 2, ZL Compressor, ZL Limiter e Dragonfly Reverb vanno in `C:\Program Files\Common Files\VST3`: per questo Windows chiede una volta il permesso di modificare il computer, rispondi **Sì**. Se rispondi No, il plugin va nella tua cartella utente e lo script ti dice quale percorso aggiungere in REAPER.

**Attenzione:** è la riga di *questo* corso. La riga della pagina principale del repository installa la suite del corso di cinema immersivo, che qui non serve.

## 5. La configurazione di REAPER del corso e le estensioni

Il corso usa una configurazione di REAPER già preparata: gli archivi di ReaPack (anche quelli del Pie menu e di NVK), le scorciatoie da tastiera, il Pie menu e alcune impostazioni di progetto (i media importati vengono copiati nella cartella *Media* del progetto, salvataggi automatici). Si importa una volta, dopo l'installazione:

1. Scarica il file di configurazione dalla [release del corso](https://github.com/animALavoro/Objet/releases/tag/post): *Post_Produzione.ReaperConfigZip*.
2. In REAPER: *Options > Preferences* (Windows) o *REAPER > Settings* (Mac) → **General** → **Import configuration…** → scegli il file.
3. REAPER chiede di riavviarsi: conferma.

L'importazione sostituisce le impostazioni di REAPER che hai adesso: se usi già REAPER per altro, prima salva le tue con **Export configuration…** nella stessa pagina.

### Il template di progetto del corso
L'installazione del capitolo 4 mette anche il template di progetto del corso, con le tracce, i bus e il routing già pronti: in REAPER, *File > Project templates* → **Template_ProduzioneCinematografica**. Si apre come un progetto nuovo senza titolo: salvalo con il tuo nome nella cartella del tuo progetto. Ogni aggiornamento (capitolo 9) rimette la versione del corso: se vuoi modificarlo, salvalo come template con un altro nome.

### Le estensioni (ReaPack, SWS, Pie menu, nvk_SEARCH)
L'installazione del capitolo 4 mette già in REAPER tutto quello che serve, senza passi a mano: **ReaPack** (il gestore dei pacchetti), **SWS/S&M** (azioni e funzioni in più usate nel corso), **js_ReaScriptAPI** e **ReaImGui** (librerie che servono agli script), **Pie3000** (il menu circolare, "pie menu") e **nvk_SEARCH** (la ricerca veloce di azioni, FX, tracce e media).

Scorciatoie del corso: **C** apre il Pie menu, **\*** del tastierino numerico apre nvk_SEARCH, **T** e **Tab** usano azioni di SWS.

**nvk_SEARCH chiede una licenza** la prima volta: è gratuito, ma ognuno deve prendere la sua chiave (gratis) su [store.nvk.tools/l/nvk_SEARCH](https://store.nvk.tools/l/nvk_SEARCH) (prezzo 0, arriva per email) e incollarla nella finestra che si apre.

## 6. Dalla timeline di Resolve a REAPER (OTIO to RPP)

1. In Resolve: *File > Export > Timeline…* → formato **OpenTimelineIO** (`.otio`), oppure un bundle `.otioz` con i media dentro.
2. Apri **OTIO to RPP** (Mac: Applicazioni della tua utenza; Windows: menu Start).
3. **File OTIO**: il file esportato. **Progetto Reaper**: dove salvare il `.rpp` (proposto con lo stesso nome).
4. **Cerca media in** (facoltativo): se i file audio non sono più dove erano durante il montaggio, l'app li cerca per nome in questa cartella.
5. Con **Copia i media nella cartella "Media"** (acceso di default) i file usati vengono copiati accanto al progetto: la cartella del progetto si può spostare o portare su un altro computer. Dei file video si copia solo l'audio, mai il video.
6. **Converti**, poi **Apri in Reaper**.

Vengono convertite tracce audio, clip (posizione, durata, offset), clip disattivate, cambi di velocità lineari, dissolvenze e il timecode di inizio. Non vengono convertiti: video, marker, clip composite, volume / pan delle clip, mappatura dei canali; li trovi elencati nel riquadro dei messaggi.

## 7. Spacchettare i polywav del registratore (Polywav Manager)

Uno script per REAPER: per gli item che suonano i **polywav** del registratore (un file con tutti i microfoni del ciak), cerca in una cartella i **file mono** dei singoli canali (per iXML, nome del file e metadati) e mette ogni microfono sulla sua traccia, con gli stessi tempi, offset e fade. La traccia con il polywav resta.

Usa **SWS**, **ReaImGui** e **js_ReaScriptAPI**, già installati dal capitolo 4.

1. Con la configurazione del corso importata (capitolo 5) è già nella lista delle azioni: *Actions > Show action list…* → cerca *Polywav Manager*. Senza la configurazione: *New action > Load ReaScript…* → `Scripts/Polywav Manager/Polywav Manager.lua` (nella cartella delle risorse di REAPER: *Options > Show REAPER resource path*), una volta.
2. Seleziona gli item dei polywav (o le tracce), scegli la cartella dei mono, **Analyze selection**.
3. Controlla l'anteprima (file trovato per ogni canale, dove va, cosa manca), poi **Apply**: tutto in un solo passo di undo.

Dettagli nel README dello script, nella stessa cartella (`README.it.md`).

## 8. Misurare la loudness (Objet a Loudness)

Objet a Loudness è il misuratore di loudness del kit, installato dalla riga del capitolo 4. In REAPER: *Plug-ins > VST* → **Clear cache/re-scan**, e sul master: **FX** → cerca *Objet a Loudness*.

## 9. Aggiornare e disinstallare

- **Aggiornare**: rilancia la stessa riga del capitolo 4, con REAPER chiuso.
- **Disinstallare su Mac**: cancella *OTIO to RPP* dalle Applicazioni della tua utenza, la cartella `~/Library/Application Support/REAPER/Scripts/Polywav Manager`, il file `~/Library/Application Support/REAPER/ProjectTemplates/Template_ProduzioneCinematografica.rpp` e da `~/Library/Audio/Plug-Ins/VST3` `Objet a Loudness.vst3`, i tre `ZL ….vst3` e i quattro `Dragonfly….vst3`.
- **Disinstallare su Windows**: cancella la cartella `%LOCALAPPDATA%\Programs\OTIO to RPP` e il collegamento nel menu Start, la cartella `%APPDATA%\REAPER\Scripts\Polywav Manager`, il file `%APPDATA%\REAPER\ProjectTemplates\Template_ProduzioneCinematografica.rpp` e `Objet a Loudness.vst3` e i quattro `Dragonfly….vst3` da `C:\Program Files\Common Files\VST3`; i plugin ZL si tolgono da *Impostazioni > App* (ZL Equalizer 2, ZL Compressor, ZL Limiter).

## 10. Problemi frequenti

| Problema | Soluzione |
|---|---|
| "REAPER is open" | Chiudi REAPER dal menu (*Quit*), non solo la finestra, e rilancia la riga. |
| Polywav Manager non è nella lista delle azioni | Importa la configurazione del corso (capitolo 5), oppure caricalo a mano (capitolo 7). |
| OTIO to RPP non trova i file audio | Indica in **Cerca media in** la cartella dove sono adesso (capitolo 6). |
| Alcune estensioni non si scaricano | La rete (per esempio quella della scuola) blocca qualche sito: rilancia la riga a casa o su un'altra rete. |
| REAPER non trova Objet a Loudness | REAPER era chiuso durante l'installazione? Poi *Plug-ins > VST* → **Clear cache/re-scan**. Su Windows, se avevi risposto No alla richiesta di permesso, aggiungi il percorso indicato dallo script. |
| La riga per Windows dà un errore sui criteri di esecuzione | Apri PowerShell e lancia prima `Set-ExecutionPolicy -Scope Process Bypass`, poi la riga. |

Per tutto il resto: chiedi al docente, indicando sistema operativo, versione di REAPER e il messaggio d'errore esatto.
