# EL-PROFFEN Kursliste App

En fokusert og effektiv Flutter-applikasjon designet for Sætren AS sine elektrikere i felt. Appen digitaliserer og effektiviserer utfylling, vedlikehold og arkivering av kursfortegnelser.

## Kjerneworkflow

Appen er designet som et verktøy for feltarbeid med en midlertidig liste over prosjekter. Den langsiktige lagringen skjer i bedriftens eksterne arkiv.

1.  **Import:** Montøren importerer en prosjekt-ZIP-fil fra bedriftens eksterne arkiv til appen.
2.  **Redigering:** Arbeid utføres på prosjektet i appen; kurser legges til, endres og slettes.
3.  **PDF-Eksport:** En oppdatert kursfortegnelse genereres som en PDF og sendes/lagres.
4.  **Prosjekt-Eksport:** Hele prosjektet eksporteres som en ny ZIP-fil.
5.  **Arkivering:** Den nye ZIP-filen lastes opp til bedriftens eksterne arkiv og erstatter den gamle versjonen.
6.  **Sletting:** Prosjektet slettes fra appen for å holde den lokale listen kort og ryddig.

## Funksjonalitet (Spesifisert for Versjon 1.0)

### Prosjekthåndtering

* **Prosjektliste:** Hovedsiden viser en enkel liste over aktive prosjekter (forventet 2-5 om gangen). Listen trenger ikke sortering eller søk.
* **Opprett Prosjekt:** Kan opprettes med kun "Prosjektnavn". All annen informasjon kan legges til senere.
* **Prosjektmeny:** Hvert prosjekt i listen har en "3-prikk"-meny med valgene:
    * **Rediger:** Åpner en egen side for prosjektinnstillinger.
    * **Eksporter:** Starter eksport av prosjektet til en ZIP-fil.
    * **Dupliser:** Lager en identisk kopi av prosjektet.
    * **Slett:** Sletter prosjektet fra appen etter en "Er du sikker?"-bekreftelse.
* **Prosjektinnstillinger (Rediger-siden):**
    * **Prosjektnavn:** Fritekst.
    * **Status:** Nedtrekksliste med "Ikke påbegynt", "Aktiv", "Fullført". Dette er kun en visuell indikator.
    * **Fordelingstype:** Nedtrekksliste (TN-C-S, TN-C, etc.), kan redigeres i globale innstillinger.
    * **Systemspenning:** Nedtrekksliste (230V, 400V, etc.), kan redigeres i globale innstillinger.
    * **Plassering av jordelektrode:** To felter: "Type" (nedtrekksliste, redigerbar globalt) og "Sted" (fritekst).
    * **Kortslutningsverdier:** Fritekst.
* **Dato:** En "Sist endret"-dato oppdateres automatisk hver gang prosjektet eller dets kurser lagres.

### Kurshåndtering

* **Legge til Kurs:** En "+"-knapp på kursoversikten åpner en dialog hvor brukeren velger en **Kurstype-mal**.
* **Kurstype-maler:**
    * **Forbrukerkurs:** Pre-utfyller kurs-skjemaet med definerte standardverdier.
    * **Hovedkurs:** Pre-utfyller med andre standardverdier.
    * **Jordfeilbryter:** Pre-utfyller med relevante verdier for en jordfeilbryter.
    * **Komponent:** Åpner et helt tomt kurs-skjema (fritekst i alle felt).
    * **Tom Linje:** Legger til en tom, visuell separator i listen og PDF-en for å representere et "hull".
* **Kursnummer (`Kurs nr.`):**
    * Dette er et **manuelt tekstfelt** for hver kurs, ikke automatisk.
    * Appen kan foreslå "neste ledige nummer" når et nytt kurs opprettes, men dette kan alltid overskrives.
    * Dette tillater "hull" og uregelmessig nummerering (f.eks. 1, 2, 6, 10...).
* **Datainntasting:** Skjer på en dedikert side for hvert kurs. Mange felter er en kombinasjon av nedtrekksliste og fritekst.
* **Rekkefølge:** Kurslisten støtter **dra-og-slipp** for å endre den visuelle rekkefølgen. Dette endrer **ikke** de manuelle kursnumrene.
* **Redigering & Sletting:**
    * Et trykk på en kursrad åpner redigeringssiden.
    * **Sveip-mot-venstre** på en kursrad avslører en sletteknapp med bekreftelsesdialog.
* **Duplisering:** Det er mulig å duplisere et eksisterende kurs.

### PDF- og Dataeksport

* **PDF-utseende:** Genereres for å se nøyaktig ut som den originale Word-malen , inkludert statisk Sætren AS-info (logo, tlf, url) i toppen.
* **Tomme felt:** Felter uten data vises med en strek (`-`) i PDF-en. "Tom Linje"-kurser vises som helt blanke rader.
* **PDF-filnavn:** Lagres automatisk som `Prosjektnavn - Dato.pdf`.
* **PDF-handling:** Når PDF-en genereres, åpnes telefonens standard "Del"-meny umiddelbart.
* **Prosjekt-eksport:** Eksporterer prosjektet som en `Prosjektnavn.zip`-fil. ZIP-filen inneholder én datafil: `prosjektdata.json`.
* **Prosjekt-import:** En "Importer"-knapp på hovedsiden åpner telefonens filvelger.
* **Import-konflikt:** Hvis et prosjekt med samme ID allerede finnes, får brukeren en dialogboks med valgene "Avbryt" eller "Importer som kopi".

### Brukergrensesnitt og Globale Innstillinger

* **Design:** Lyst tema, minimalistisk, med Sætren AS sin fargeprofil.
* **Innstillinger-side:** En egen side, tilgjengelig via et ikon på hovedsiden, for å:
    * Redigere og legge til nye valg i de globale nedtrekkslistene (f.eks. legge til en ny kabeldimensjon).
* **Installatør-info:** Sætren AS sin info er hardkodet i versjon 1.0.

## Fremtidige Funksjoner (Roadmap)

* **Versjon 2.0:**
    * **OCR-skanning:** Importere en kursliste ved å skanne et bilde/PDF.
    * **Autofullfør:** Forslag til "Lastbeskrivelse" basert på tidligere innføringer.
* **Versjon 3.0:**
    * **Sky-synkronisering:** Potensiell overgang fra manuell import/eksport til automatisk synkronisering mellom enheter.

## Teknisk Spesifikasjon

* **Rammeverk:** Flutter (for Android og iOS).
* **Plattformer:** Android for alfa/beta-testing, med iOS som krav for endelig utrulling.
* **Målgruppe:** Internt bruk for Sætren AS.