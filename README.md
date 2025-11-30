# iCal Server met Wachtwoordbeveiliging

Dit project bevat een eenvoudige, wachtwoordbeveiligde iCal-server die kan worden gehost op GitHub Pages.

## Functies

- 🛡️ **Wachtwoordbeveiliging**: Toegang tot de iCal-link is beveiligd met een wachtwoord
- 🔗 **iCal Link Generatie**: Dynamisch gegenereerde links voor kalenderabonnementen
- 🌐 **GitHub Hosting**: Volledig functionerend via GitHub Pages
- 📱 **Compatibel**: Werkt met alle gangbare kalenderapps (Google Kalender, Apple Kalender, Outlook, etc.)

## Installatie op GitHub

1. Fork dit repository naar uw eigen GitHub-account
2. Schakel GitHub Pages in via de repository-instellingen:
   - Ga naar "Settings" > "Pages"
   - Kies "Deploy from a branch"
   - Selecteer "main" als branch en "/" als folder
3. Pas het wachtwoord aan in `index.html` regel 192 (voor productie gebruik een veiligere methode)
4. De website is nu beschikbaar op `https://uw-gebruikersnaam.github.io/ical-server`

## Beveiliging

- Het huidige wachtwoord is `ical2025` (pas dit aan voor productiegebruik!)
- In een productieomgeving wordt aanbevolen om server-side authenticatie te gebruiken
- De iCal-links bevatten een unieke token voor extra beveiliging

## Gebruik

1. Bezoek de website
2. Voer het correcte wachtwoord in
3. Gebruik de gegenereerde iCal-link in uw kalenderapp
4. Uw kalender wordt automatisch gesynchroniseerd

## Bestanden

- `index.html` - De hoofdpagina met wachtwoordbeveiliging
- `sample-schedule.ics` - Voorbeeld iCal-bestand
- `README.md` - Deze handleiding

## Aanpassingen voor Productie

Voor productiegebruik wordt aanbevolen om:

1. Server-side authenticatie te implementeren in plaats van client-side
2. Een API-endpoint te gebruiken voor wachtwoordverificatie
3. HTTPS te gebruiken (standaard met GitHub Pages)
4. Frequentie van wachtwoordwijzigingen te overwegen