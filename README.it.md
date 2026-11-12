# Objet

Plugin di audio spaziale per REAPER, di Luca Bagetto: **Objet Pa** (panner multicanale e Ambisonics), **Objet a Scene** (tutto il mix in una stanza, loudness), **Objet a Monitor** (monitor binaurale, vista 360, visore) e **Objet a Master** (uno script per gestire tutti i panner di un progetto). VST3, Windows e macOS (universale: Apple silicon e Intel, macOS 11 o successivo), REAPER 7.

Questo repository contiene solo i download: [Release](https://github.com/animALavoro/Objet/releases). English: [README.md](README.md).

## Installare su macOS
Chiudi REAPER, apri il Terminale (Applicazioni > Utility > Terminale), incolla questa riga e premi Invio:

```
curl -fsSL https://github.com/animALavoro/Objet/releases/latest/download/install-mac.sh | bash
```

Installa i tre plugin nella tua cartella VST3 (`~/Library/Audio/Plug-Ins/VST3`) e lo script Objet a Master nella cartella Scripts di REAPER. Nessuna password di amministratore; le copie vecchie vengono sostituite, quindi la stessa riga serve anche ad aggiornare. Poi apri REAPER: *REAPER > Settings > Plug-ins > VST > Clear cache/re-scan*.

- Un plugin solo: chiudi la riga con `bash -s -- pa` (oppure `scene`, `monitor`, `master`) invece di `bash`.
- Una versione precisa: `bash -s -- all 2026.11.10`, oppure `bash -s -- pa v0.2.0` per la release di un plugin solo.
- Objet a Master, una volta sola: *Actions > Show action list > New action > Load ReaScript*, scegli `LB_Objet_Master.lua` (serve ReaImGui, da ReaPack).

**Perché il Terminale**: i plugin non hanno una firma di sviluppatore Apple (ne hanno una ad-hoc), quindi macOS li blocca se sono stati scaricati con un browser. I file scaricati dal Terminale non vengono bloccati. Se hai scaricato uno zip con il browser, copia il `.vst3` in `~/Library/Audio/Plug-Ins/VST3/` e sbloccalo prima del re-scan, per esempio:

```
xattr -dr com.apple.quarantine ~/Library/Audio/Plug-Ins/VST3/"LB Spanner.vst3"
```

(`Objet a Scene.vst3`, `Objet a Monitor.vst3` per gli altri).

Se REAPER è già fermo all'avvio sul messaggio *"LB Spanner.vst3" Not Opened. Apple could not verify "LB Spanner.vst3" is free of malware…*, il messaggio torna a ogni **Done** e REAPER non si apre. Lascialo lì, lancia la riga qui sopra nel Terminale, poi premi **Done** una volta: REAPER si apre e carica il plugin.

## Installare su Windows
Dall'ultima release, decomprimi ogni `*-Windows.zip` e copia la cartella `.vst3` in `C:\Program Files\Common Files\VST3\`. Per Objet a Master carica `LB_Objet_Master.lua` da `Objet-a-Master.zip` come sopra. Poi *Clear cache/re-scan* in REAPER.

Il file di Objet Pa è `LB Spanner.vst3` (REAPER lo mostra come *Objet Pa*): il vecchio nome resta perché i progetti salvati lo ritrovino.

## Pubblicare una release (manutenzione)
*Actions > Release > Run workflow*: scegli `all` (la suite) o un plugin, una versione e, se serve, il branch o il tag di ogni repository dei sorgenti. Il workflow compila Windows e macOS dai repository privati, firma ad-hoc i bundle macOS e pubblica la release. Lascia *latest* spento per provarla prima:

```
curl -fsSL https://github.com/animALavoro/Objet/releases/download/suite-VERSIONE/install-mac.sh | bash -s -- all VERSIONE
```

poi *Edit release > Set as latest release*: da quel momento la riga d'installazione qui sopra la dà a tutti. I sorgenti si leggono con il segreto `SOURCE_TOKEN` (token fine-grained, contenuti in sola lettura sui quattro repository dei sorgenti, da rinnovare prima della scadenza).
