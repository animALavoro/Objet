# Objet

Strumenti di audio spaziale per REAPER, di Luca Bagetto: **Objet Pa** (panner multicanale e Ambisonics, con i puck sul video), **Objet a Scene** (tutto il mix in una stanza o in un globo, loudness, cambi su molti panner insieme), **Objet a Monitor** (monitor binaurale, vista 360, visore) e **OTIO to RPP** (un'app che trasforma una timeline di Resolve in un progetto REAPER) e **Polywav Manager** (uno script per REAPER che mette i mono dei polywav del registratore ognuno sulla sua traccia). VST3 per REAPER 7 su Windows e macOS (universale: Apple silicon e Intel, macOS 11 o successivo).

**Guida per gli studenti: [Italiano](docs/guida.md) · [English](docs/guide.md)**

Questo repository contiene solo i download: [Release](https://github.com/animALavoro/Objet/releases). English: [README.md](README.md).

## Installare
Prima chiudi REAPER. La stessa riga serve anche ad aggiornare.

**macOS** (Terminale: Applicazioni > Utility > Terminale):
```
curl -fsSL https://github.com/animALavoro/Objet/releases/latest/download/install-mac.sh | bash
```
**Windows** (PowerShell):
```
irm https://github.com/animALavoro/Objet/releases/latest/download/install-windows.ps1 | iex
```
Tutte e due installano i tre plugin, l'app OTIO to RPP, lo script Polywav Manager e le estensioni e gli script di REAPER del corso (ReaPack, SWS, js_ReaScriptAPI, ReaImGui, Pie3000, nvk_SEARCH, scaricati dalle loro fonti), dall'ultima release. Su Windows, Windows chiede una volta il permesso (i plugin vanno in `C:\Program Files\Common Files\VST3`). Poi in REAPER: *Plug-ins > VST > Clear cache/re-scan*. La guida ha i dettagli e la configurazione di REAPER del corso.

- **Solo i tre plugin** (senza app né estensioni):
  - macOS: `curl -fsSL https://github.com/animALavoro/Objet/releases/latest/download/install-mac.sh | bash -s -- plugins`
  - Windows: `& ([scriptblock]::Create((irm https://github.com/animALavoro/Objet/releases/latest/download/install-windows.ps1))) plugins`
- Una parte sola: `pa`, `scene`, `monitor`, `otio`, `polywav` oppure `ext` (estensioni e script di REAPER) al posto di `plugins`.
- Una versione precisa: aggiungila dopo la parte, per esempio `bash -s -- all 2026.11.12-mac3`.

**macOS, scaricato con il browser**: i plugin hanno una firma ad-hoc (nessun account sviluppatore Apple), quindi macOS blocca una copia scaricata. Copia il `.vst3` in `~/Library/Audio/Plug-Ins/VST3/` e sbloccalo dal Terminale, per esempio `xattr -dr com.apple.quarantine ~/Library/Audio/Plug-Ins/VST3/"LB Spanner.vst3"`. Se REAPER è già fermo all'avvio su *"… Not Opened. Apple could not verify …"* (il messaggio torna a ogni **Done**), lancia quella riga mentre il messaggio è a schermo, poi premi **Done** una volta.

Il file di Objet Pa è `LB Spanner.vst3` (REAPER lo mostra come *Objet Pa*): il vecchio nome resta perché i progetti salvati lo ritrovino.

## Corso di post produzione
Il corso di post produzione del cortometraggio ha un kit suo: OTIO to RPP, Polywav Manager, il misuratore Objet a Loudness, alcuni plugin gratuiti di altri autori (ZL Equalizer 2, ZL Compressor, ZL Limiter, Dragonfly Reverb: scaricati dalle release dei loro autori, nella versione giusta per il processore; su Mac gli ZL chiedono macOS 12 o successivo), le estensioni e gli script di REAPER qui sopra e la sua configurazione di REAPER (*Post_Produzione.ReaperConfigZip*, per ora uguale a quella del corso immersivo), nessuno dei tre plugin spaziali. La sua riga, con REAPER chiuso:

- **macOS**: `curl -fsSL https://github.com/animALavoro/Objet/releases/download/post/install-mac.sh | bash`
- **Windows**: `irm https://github.com/animALavoro/Objet/releases/download/post/install-windows.ps1 | iex`

**Guida: [Italiano](docs/post/guida.md) · [English](docs/post/guide.md)**. Il kit è nella release [post](https://github.com/animALavoro/Objet/releases/tag/post), sempre pre-release, così la suite resta l'ultima release.

## Pubblicare una release (manutenzione)
*Actions > Release > Run workflow*: scegli `all` (la suite) o una parte, una versione e, se serve, il branch o il tag di ogni repository dei sorgenti. Il workflow compila Windows e macOS dai repository privati, firma ad-hoc i bundle macOS e pubblica la release. Lascia *latest* spento per provarla prima (esce come pre-release, che la riga d'installazione non prende):

```
curl -fsSL https://github.com/animALavoro/Objet/releases/download/suite-VERSIONE/install-mac.sh | bash -s -- all VERSIONE
```

poi *Edit release*: togli la spunta da *Set as a pre-release*, metti quella su *Set as the latest release*, *Update release*: da quel momento la riga d'installazione la dà a tutti. *publish* spento compila e prova soltanto. I sorgenti si leggono con il segreto `SOURCE_TOKEN` (token fine-grained, contenuti in sola lettura sui repository dei sorgenti, da rinnovare prima della scadenza). *Actions > Mac overlay test* prova l'overlay video di Objet Pa in REAPER su un Mac della CI (screenshot nel branch `ci-shots`).

**Kit di post produzione**: *Actions > Release* con `post` fa la pre-release `post-VERSIONE` (Objet a Loudness solo con `loudness_ref` impostato, altrimenti il kit è senza; i link alle ultime release dei plugin di altri autori vanno in `third-party-plugins.txt`, fatto da `tools/third_party_plugins.py` e rifatto anche dal Refresh); con *latest* acceso i suoi file vanno anche nella release `post`, quella che usa la riga del corso. Per provarla prima lascia *latest* spento: `curl -fsSL https://github.com/animALavoro/Objet/releases/download/post-VERSIONE/install-mac.sh | bash -s -- post VERSIONE`, poi *Actions > Refresh REAPER packages list* con `tag` = `post-VERSIONE` e *promote_post* acceso. La configurazione di REAPER del kit è in `kit/post/` (per ora una copia di quella del corso immersivo). *Kit test (Mac)* e *Kit test (Windows)* accettano `kit` = `post`.
