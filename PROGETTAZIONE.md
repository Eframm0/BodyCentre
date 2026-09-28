# BodyCentre — Documento di Progettazione

App fitness/salute per Android (Flutter) con integrazione Google Health Connect e rete neurale leggera on-device per previsioni personalizzate.

---

## 1. Obiettivi e vincoli

**Obiettivi**
- Unica app che unisce: diario calorico, tracciamento peso/composizione corporea, allenamenti e progressi.
- Previsioni AI personalizzate (trend peso, massimali) eseguite **interamente sul dispositivo**.
- Dashboard riassuntiva con "età biologica" come indicatore di salute generale.

**Vincoli tecnici** (da descrizione progetto)
| Vincolo | Scelta |
|---|---|
| Piattaforma | Android (fase iniziale; codice Flutter mantenuto portabile) |
| Framework | Flutter (Dart) |
| Salute | Google Health Connect |
| ML | Modello leggero, inferenza + training 100% on-device |

**Decisioni confermate**
- Nessun backend/account: tutti i dati restano sul dispositivo (SQLite + file). Il sync cloud è un'estensione futura.
- Profilo singolo (nessuna multi-utenza in v1).
- Lingua UI: italiano in v1, ma **architettura predisposta al multilingua**: tutte le stringhe via `flutter gen-l10n` (file `.arb`, locale default `it`), date/numeri via `intl`. Nessuna stringa hardcoded nel codice.
- Unità: metriche (kg, cm, kcal).
- minSdk 26; Health Connect dove disponibile, con degradazione graduale dove assente.

---

## 2. Stack tecnologico

| Ambito | Pacchetto | Motivazione |
|---|---|---|
| State management | `flutter_riverpod` | Testabile, poco boilerplate, dependency injection naturale |
| Database | `drift` (SQLite) | Tipizzato, migrazioni, query reactive per i grafici |
| Grafici | `fl_chart` | Line/bar/pie/radar, altamente personalizzabile |
| Health Connect | `health` | Wrapper ufficiale Health Connect + HealthKit (futuro iOS) |
| SVG / mappa corpo | `flutter_svg` + `path_drawing` + `CustomPainter` | Ricolorazione dinamica delle regioni muscolari |
| Foto | `image_picker`, `flutter_image_compress` | Foto peso-forma con thumbnail |
| ML | implementazione **pura Dart** (MLP con backprop) | Nessun binary nativo, training on-device semplice, dimensione modello ~KB |
| Localizzazione | `flutter_localizations` + `gen-l10n` (file `.arb`) | Italiano default; aggiungere lingue = aggiungere file `.arb` |
| Utili | `intl` (date/numeri), `uuid`, `flutter_animate` (micro-animazioni), `go_router` (navigazione) | — |

**Perché ML in Dart puro invece di TensorFlow Lite:** il requisito è la *personalizzazione*: il modello deve addestrarsi sui dati dell'utente mentre li accumula. Un MLP piccolo (300–500 parametri) con Adam scritto in Dart gira in millisecondi in un isolate, non richiede asset binari né toolchain di training offline. TFLite verrebbe usato solo per modelli pre-addestrati statici, cosa che non copre il caso d'uso.

---

## 3. Architettura

Architettura a layer, organizzazione **feature-first**:

```
lib/
├── main.dart
├── app.dart                      # MaterialApp, tema, router
├── core/
│   ├── db/                       # drift: database, tables, DAO, migrazioni
│   ├── ml/                       # rete neurale, feature pipeline, training, persistenza pesi
│   ├── health/                   # servizio Health Connect (permessi, lettura/scrittura)
│   ├── formulas/                 # BMR, TDEE, MET, Epley, età biologica
│   └── design/                   # tema, colori, widget condivisi (Card, Header, EmptyState)
├── features/
│   ├── profile/                  # dati utente, onboarding
│   ├── home/                     # dashboard
│   ├── calories/                 # diario, catalogo alimenti
│   ├── weight/                   # peso forma: rilevazioni, foto, grafici
│   ├── workout/                  # routine, catalogo esercizi, sessione, mappa corpo
│   └── settings/                 # preferenze, Health Connect, esportazione dati
├── models/                       # entità di dominio (pure Dart)
└── widgets/                      # componenti riutilizzabili (grafici, selettori)
assets/
├── images/exercises/             # illustrazioni esercizi predefiniti
├── svg/body_map.svg              # silhouette corpo con regioni muscolari
└── data/foods_it.json            # seed catalogo alimenti (fonte CREA)
```

**Flusso dati:** UI → Riverpod providers (notifier) → Repository (DAO drift / servizi) → DB. I grafici si ricostruiscono via `watch` su query drift reattive.

---

## 4. Modello dati (SQLite / drift)

| Tabella | Campi principali |
|---|---|
| `UserProfile` | nome, cognome, dataNascita, sesso, altezzaCm, fattoreAttività, obiettivo (perdita/mantenimento/massa), creatoIl |
| `FoodItem` | nome, marca?, kcal, proteine, carboidrati, grassi per 100g, porzione default, custom(bool), barcode? |
| `MealEntry` | dataOra, pasto (colazione/pranzo/cena/snack), foodItemId o cibo libero, grammi, kcal+macros calcolate (snapshot) |
| `WeightEntry` | dataOra, pesoKg, massaGrassa%, massaMuscolareKg?, acqua%?, circonferenza vita?, note, foto → lista `EntryPhoto` |
| `EntryPhoto` | weightEntryId, path file locale, thumbnail path |
| `Exercise` (catalogo) | nome, descrizione breve, gruppo muscolare primario, secondari[], tipo (pesi/cardio), immagine, custom(bool), MET |
| `Routine` | nome, note, predefinita(bool), giorniConsigliati[] |
| `RoutineExercise` | routineId, exerciseId, serieTarget, repTarget, recuperoSec, ordine |
| `WorkoutSession` | dataOra inizio/fine, routineId?, note, kcalStimate, durataEffettiva |
| `SessionExercise` | sessionId, exerciseId, serie[], dove `Serie = {caricoKg, reps, rpe?, completata}` |
| `DailyStats` (derivata/cache) | giorno, passi, kcalAttiveHC, kcalConsumateTot, syncHealthConnect |
| `ModelState` | modelloId ('weight_trend' / 'strength'), pesi serializzati JSON, media/std delle feature, metriche validazione, addestratoIl |

- Le macro/calorie in `MealEntry` e i carichi in `SessionExercise` sono **snapshot immutabili**: la cancellazione/modifica di un alimento del catalogo non riscrive la storia.
- `DailyStats` si popola da Health Connect (passi, kcal attive) con fallback a pedometro locale/inserimento manuale.

---

## 5. Sezioni e schermate

### 5.1 Onboarding + Profilo (prima esecuzione)
1. Dati anagrafici (nome, cognome, nascita, sesso, altezza).
2. Obiettivo (perdita peso / mantenimento / massa) e livello attività → calcolo obiettivo calorico.
3. Collegamento Health Connect (rinviabile) con schermata di spiegazione permessi.

### 5.2 Home — Dashboard
- **Header utente**: avatar, nome e cognome, età anagrafica, **età biologica** (badge con delta es. "−2,3 anni"), altezza, peso attuale.
- **Card Calorie**: bilancia di oggi (kcal introdotte vs bruciate) con anello di avanzamento verso l'obiettivo; mini grafico a barre degli ultimi 7 giorni (in vs out).
- **Card Peso**: sparkline 30 giorni + variazione totale e settimanale.
- **Card Allenamento**: ultima sessione, volume settimanale (mini barre), anteprima mappa corporea.
- **Card AI**: previsione peso a 14/30 giorni con freccia trend; prossimo massimale previsto sull'esercizio chiave.
- **Quick actions**: ➕ pasto, ➕ peso, ▶️ allenamento.

### 5.3 Calorie
- **Diario giornaliero** con pasti (colazione/pranzo/cena/snack), kcal totali e macro (barre proteine/carboidrati/grassi vs obiettivo).
- **Aggiunta cibo**: ricerca nel catalogo (seed ~200 alimenti comuni dalla tabelle CREA + custom utente), selezione grammi o porzioni predefinite.
- **Cibi custom**: creazione con macros per 100 g, riutilizzabili.
- **Calorie bruciate**: passi (Health Connect / pedometro → kcal), sessioni di allenamento (formula MET × peso × durata), mostrate come "bonus" sul budget giornaliero.
- Obiettivo calorico: Mifflin-St Jeor (BMR) × fattore attività, aggiustato dall'obiettivo (deficit/surplus).

### 5.4 Peso Forma
- Lista cronologica delle rilevazioni + grafico peso (con media mobile 7 gg) e, se presenti, massa grassa/muscolare.
- **Nuova rilevazione**: peso, composizione corporea opzionale, foto (fronte/lato/retro da galleria o fotocamera), note.
- Galleria foto per data (confronto "prima/dopo" affiancato).
- BMI calcolato, indicatore range.

### 5.5 Allenamento
- **Routine**: creazione da zero o da template predefiniti (Full Body, Push/Pull/Legs, Upper/Lower…). Esercizi con serie/ripetizioni/recupero target.
- **Catalogo esercizi**: ~40 predefiniti con immagine, descrizione breve, gruppi muscolari; esercizi custom dell'utente.
- **Esecuzione sessione**: schermata "player" — serie corrente, carico, reps, timer recupero, completamento serie; riepilogo finale con volume e kcal stimate.
- **Storico**: dettaglio sessioni passate, progressione per esercizio (grafico carico × reps, 1RM stimato Epley).
- **Mappa coropletica del corpo**: vedi §6.

### 5.6 Impostazioni
- Modifica dati profilo e obiettivi; gestione permessi Health Connect e risincronizzazione; unità; esportazione dati in JSON; cancellazione dati; informativa privacy (elaborazione solo locale).

---

## 6. Mappa coropletica del corpo

**Visualizzazione**: silhouette anatomica (fronte + retro) con regioni muscolari colorate in base al volume di allenamento. Selettore periodo: 7 / 30 / 90 giorni.

**Regioni** (14): pettorali, deltoidi (sx/dx), bicipiti, tricipiti, avambracci, addome, obliqui, quadricipiti, polpacci, trapezio, dorsali, lombari, glutei, femorali.

**Metrica**: serie settimanali equivalente per gruppo muscolare — ogni serie di un esercizio pesa 1.0 sul gruppo primario e 0.5 sui secondari, normalizzate sul periodo. Riferimento ipertrofia: 10–20 serie/settimana per gruppo.

**Scala colore**: 0% del target → rosso (sotto-allenato), ~50% → ambra, 100%+ → verde; regione cliccabile con dettaglio (serie fatte, esercizi che la coinvolgono).

**Implementazione**: asset SVG con `id` per regione → parsing dei path (`path_drawing`) → `CustomPainter` che disegna ogni regione con `Paint(color: lerpColor(score))` → hit-test per il tap. (flutter_svg da solo non permette ricolorazione per-path a runtime.)

**Asset**: illustrazione vettoriale realizzata ad hoc (o adattata da silhouette CC) con regioni chiuse e id `muscle_pectoral`, `muscle_biceps_l`, ecc.

---

## 7. Integrazione Health Connect

**Pacchetto**: `health` (client Health Connect).

**Dati letti**
- `Steps` (giornalieri) → cardio/kcal e metriche età biologica.
- `ActiveCaloriesBurned` / `TotalCaloriesBurned` → budget calorico.
- `Weight` → import rilevazioni (deduplica con inserimenti manuali).
- `HeartRate` (FC a riposo, se disponibile) → età biologica.
- `SleepSession` (opzionale) → età biologica.
- `ExerciseSession` → import allenamenti esterni (cardio).

**Dati scritti** (opt-in nelle impostazioni)
- `Weight` quando l'utente registra una rilevazione; `ExerciseSession` al termine di un allenamento.

**Strategia permessi**: schermata esplicativa → richiesta permessi Health Connect → stato visibile nelle impostazioni con possibilità di rinnovare.

**Fallback** (dispositivi senza Health Connect o permessi negati): contapassi da pedometro/accelerometro locale, inserimento manuale di passi e kcal. L'app resta pienamente funzionante: Health Connect è un potenziamento, non una dipendenza.

**Sincronizzazione**: al primo avvio scarica ultimi 90 giorni; poi sincronizzazione incrementale all'apertura app / giornaliera; dati in `DailyStats` con flag origine per evitare doppi conteggi con le kcal MET dei workout interni.

---

## 8. Modulo AI — previsioni on-device

Due modelli indipendenti, stessa infrastruttura.

### 8.1 Infrastruttura comune
- **MLP in Dart puro**: forward pass matriciale + backprop con Adam (lr adattivo), loss MSE, regolarizzazione L2 leggera.
- Architettura di rete piccola (es. 11 → 16 ReLU → 8 ReLU → 1): centinaia di parametri, training in <1 s in `Isolate` (nessun jank UI).
- **Feature standardizzazione** (z-score) con statistiche salvate in `ModelState`.
- **Persistenza**: pesi serializzati in JSON in tabella `ModelState`; training ri-eseguito incrementalmente di notte / ogni N nuovi record.
- **Validazione**: hold-out sugli ultimi 20% campioni; conservati i pesi con miglior RMSE di validazione (early stopping).

### 8.2 Modello A — Previsione peso (dimagrimento/ingrassamento)

**Approccio ibrido fisica + ML**: la linea base è deterministica (bilancio energetico: Δpeso ≈ (kcal_in − kcal_out − TDEE) / 7700 kg); la rete neurale impara il **residuo** (adattamento metabolico, ritenzione idrica, effetti dei macro, non-linearità individuali).

**Feature** (medie su finestra 7 gg, vettore ~11): kcal_in/giorno, proteine g, carboidrati g, grassi g, kcal attive/giorno, passi/giorno, kcal allenamenti/giorno, peso attuale, massa grassa % (se nota), sesso, deficit/surplus percentuale.

**Output**: variazione peso kg/giorno → proiezione peso a 7/14/30 giorni con banda di incertezza (±residual std).

**Cold start** (< 14 giorni di dati): sola formula fisica, UI dichiara "previsione preliminare".

### 8.3 Modello B — Previsione massimale / ripetizioni prossimo allenamento

**Feature per esercizio** (~10): 1RM Epley delle ultime sessioni (media pesata recente), trend 1RM (pendenza), volume ultimo allenamento, giorni di recupero, RPE medio recente, deficit calorico degli ultimi 7 gg, massa corporea, età, sesso, variazione peso recente.

**Output** (due modalità):
1. **Massimale stimato** (1RM) per il prossimo allenamento.
2. **Reps previste a un carico target** (es. "a 80 kg dovresti fare 6–7 reps").

**Cold start**: progressione euristica "doppia progressione" (+2,5% carico quando tutte le serie raggiungono il target reps) modulata dal deficit calorico (in deficit forte → probabilità di progresso ridotta).

**Presentazione in UI**: card nella scheda esercizio e in Home; sempre con range, mai valore puntuale senza incertezza; disclaimer "stima statistica, non consiglio medico".

### 8.4 Privacy
Nessun dato lascia il dispositivo: training e inferenza locali, nessun telemetry. Comunicato esplicitamente in-app.

---

## 9. Età biologica

Indicatore sintetico "stato di cura" mostrato in Home, calcolato su età anagrafica + delta (clamp ±10):

| Fattore | Bonus | Penalità |
|---|---|---|
| Composizione corporea (BF% o BMI) | in range: −1 anno | sovrappeso +1,5; obesità +3 |
| Attività aerobica (≥150 min/sett o ≥8.000 passi/giorno medi) | −1,5 | sedentarietà (<5.000 passi, <60 min): +2 |
| Allenamento forza (≥2 sessioni/sett) | −1 | nessuna sessione: +1 |
| FC a riposo (se da Health Connect) | <60 bpm: −1 | >80 bpm: +1,5 |
| Sonno (se disponibile) | 7–9 h: −0,5 | <6 h: +1 |
| Aderenza tracciamento (uso costante app ultime 4 sett) | ≥70% giorni: −0,5 | — |

Pesi indicativi, raffinati in fase di tuning. UI: età biologica grande + delta colorato, e schermata "Come viene calcolata" con il contributo di ogni fattore. Etichetta esplicita: stima indicativa.

---

## 10. Tema e UX — Claymorphism

Stile visivo **claymorphism** (scelta utente): superfici "plastilina" con angoli molto arrotondati (radius 20–34), gradiente chiaro→colore, doppia ombra morbida (basso-destra + luce alto-sinistra, luce interna simulata). Componenti base in `core/design/clay.dart`: `ClayCard`, `ClayPressable`, `ClayChip`, `ClayButton`, `ClayProgress`.

**Palette "Menta & Azzurro"** (scelta utente, vedi `anteprima_palette.html`):
| Ruolo | Colore |
|---|---|
| Sfondo | `#E9F3F7` |
| Card generiche | `#D6EEF5` |
| Card Calorie | `#FFF3D6` |
| Card Peso forma | `#D9F2E5` |
| Card Allenamento | `#DCE9FA` |
| Accento | `#2FA8A0` (teal) |
| Ambra (calorie assunte) | `#F2A93B` |
| Testo | `#1F3A44` |

- Tema **solo chiaro in v1**; il tema scuro ("dark clay": superfici scure, ombre ridotte) è un'estensione futura.
- Tipografia: **Nunito** (corpo) + **Baloo2** (titoli e numeri), font variabili bundleati in `assets/fonts/` (offline-first, no Google Fonts runtime).
- **Animazioni ovunque** (richiesta utente): entrata staggered (fade+slide) degli elementi delle schermate, micro-interazioni di pressione (scale + compressione ombre), transizioni tra sezioni (fade + micro-scale), pill attiva della nav rail con curva elastica, barre/grafici animati al load.
- **Navigazione**: nav rail **verticale a destra** (come da schema UI fornito dall'utente) con 4 voci: Home, Calorie, Peso forma, Allenamento. Impostazioni accessibili dall'header.
- Grafici coerenti (fl_chart, palette unica, stile minimale senza assi).

---

## 11. Requisiti non funzionali e test

- **Privacy**: elaborazione 100% locale; permessi minimi (Health Connect, fotocamera/galleria solo all'uso).
- **Performance**: avvio <2 s; grafici fluidi (query drift con cache `DailyStats`); training ML fuori dal main isolate.
- **Offline-first**: tutto funziona senza rete.
- **Test**: unit test per formule (BMR/MET/Epley/età biologica), convergenza della rete su dati sintetici, DAO drift (DB in-memory), widget test per schermate chiave; build release firmata con proguard/R8 safe.

## 12. Rischi e mitigazioni

| Rischio | Mitigazione |
|---|---|
| Health Connect assente/negato | Fallback pedometro + inserimento manuale; feature completa comunque |
| Qualità AI con pochi dati | Ibrido formula+ML, bande di incertezza, label "preliminare" |
| Immagini esercizi (licenze) | Illustrazioni SVG prodotte ad hoc / risorse CC con attribuzione |
| Correttezza dati alimentari | Seed da tabelle CREA (open data); cibo custom sempre disponibile |
| Migrazioni DB future | Versioning drift + test di migrazione |

## 13. Piano di sviluppo (milestone demoabili)

| # | Milestone | Contenuto |
|---|---|---|
| M0 | Skeleton | Progetto Flutter, tema, navigazione, onboarding/profilo, DB |
| M1 | Calorie | Catalogo seed CREA (~200 generici), diario, obiettivo kcal, cibi custom |
| M2 | Peso Forma | Rilevazioni, grafici, foto, BMI |
| M3 | Allenamento | Catalogo esercizi, routine, player sessione, storico |
| M4 | Mappa corpo | SVG regioni + colorazione + dettaglio gruppo |
| M5 | Health Connect | Permessi, sync passi/kcal/peso, fallback |
| M6 | AI | Reti, training on-device, card previsioni, cold start |
| M7 | Età biologica + Home finale | Formula, dashboard completa |
| M8 | Rilascio | Polish, test, esportazione dati, build release |
| M9 | Open Food Facts (futuro) | Ricerca prodotti da supermercato online + scanner codice a barre con cache locale (deciso con l'utente: CREA + custom per ora, OFF più avanti) |

Ogni milestone produce un APK verificabile.
