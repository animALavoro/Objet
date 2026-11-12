# Objet

Strumenti di audio spaziale per REAPER, di Luca Bagetto: **Objet Pa** (panner multicanale e Ambisonics, con i puck sul video), **Objet a Scene** (tutto il mix in una stanza o in un globo, loudness, cambi su molti panner insieme), **Objet a Monitor** (monitor binaurale, vista 360, visore) e **OTIO to RPP** (un'app che trasforma una timeline di Resolve in un progetto REAPER). VST3 per REAPER 7 su Windows e macOS (universale: Apple silicon e Intel, macOS 11 o successivo).

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
Tutte e due installano i tre plugin, l'app OTIO to RPP e le estensioni di REAPER ReaPack e ReaImGui, dall'ultima release. Su Windows, Windows chiede una volta il permesso (i plugin vanno in `C:\Program Files\Common Files\VST3`). Poi in REAPER: *Plug-ins > VST > Clear cache/re-scan*. La guida ha i dettagli, la configurazione di REAPER del corso e le estensioni da aggiungere da ReaPack.

- Una parte sola: su Mac chiudi la riga con `bash -s -- pa` (oppure `scene`, `monitor`, `otio`, `ext`); su Windows `& ([scriptblock]::Create((irm https://github.com/animALavoro/Objet/releases/latest/download/install-windows.ps1))) pa`.
- Una versione precisa: aggiungila dopo la parte, per esempio `bash -s -- all 2026.11.12-mac3`.

**macOS, scaricato con il browser**: i plugin hanno una firma ad-hoc (nessun account sviluppatore Apple), quindi macOS blocca una copia scaricata. Copia il `.vst3` in `~/Library/Audio/Plug-Ins/VST3/` e sbloccalo dal Terminale, per esempio `xattr -dr com.apple.quarantine ~/Library/Audio/Plug-Ins/VST3/"LB Spanner.vst3"`. Se REAPER è già fermo all'avvio su *"… Not Opened. Apple could not verify …"* (il messaggio torna a ogni **Done**), lancia quella riga mentre il messaggio è a schermo, poi premi **Done** una volta.

Il file di Objet Pa è `LB Spanner.vst3` (REAPER lo mostra come *Objet Pa*): il vecchio nome resta perché i progetti salvati lo ritrovino.

## Pubblicare una release (manutenzione)
*Actions > Release > Run workflow*: scegli `all` (la suite) o una parte, una versione e, se serve, il branch o il tag di ogni repository dei sorgenti. Il workflow compila Windows e macOS dai repository privati, firma ad-hoc i bundle macOS e pubblica la release. Lascia *latest* spento per provarla prima (esce come pre-release, che la riga d'installazione non prende):

```
curl -fsSL https://github.com/animALavoro/Objet/releases/download/suite-VERSIONE/install-mac.sh | bash -s -- all VERSIONE
```

poi *Edit release*: togli la spunta da *Set as a pre-release*, metti quella su *Set as the latest release*, *Update release*: da quel momento la riga d'installazione la dà a tutti. *publish* spento compila e prova soltanto. I sorgenti si leggono con il segreto `SOURCE_TOKEN` (token fine-grained, contenuti in sola lettura sui repository dei sorgenti, da rinnovare prima della scadenza). *Actions > Mac overlay test* prova l'overlay video di Objet Pa in REAPER su un Mac della CI (screenshot nel branch `ci-shots`).
