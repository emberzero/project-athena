#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 01: Legal],
    subtitle: [Überblick über die Rechtslage in Österreich und Deutschland],
    authors: [*Marcel Schnideritsch*],
    extra: [],
    footer: [Module 01 - Legal],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "Warum?")[

  #split(
    columns: (1.2fr, 1fr),
    image("./figures/why_1.jpg", width: 100%),
    [
      #image("./figures/why_2.jpg", width: 100%)
      #image("./figures/why_3.png", width: 100%)
    ],
  )

  #text(size: 11pt, "Quellen: Wiener Zeitung; heise.de;")

]

#standout-slide(title: "UNWISSENHEIT schützt vor Strafe nicht")

#section-slide(title: "Grundbegriffe aus dem Strafrecht")

#slide(title: "Begriffe aus dem Strafrecht")[
  #color-block(
    title: [Tatort (§ 62 StGB): ],
    [
      - Im Inland-begangene Taten
      - Ort der Handlung ODER-Ort des Erfolges
      - Achtung bei Servern & Infrastruktur im Ausland (anderes Recht anwendbar)!
    ],
  )
]

#slide(title: "Begriffe aus dem Strafrecht")[
  #color-block(
    title: [Vorsatz (§ 5 Abs 1 StGB): ],
    [
      - Subjektive Tatseite
      - Vorstellungen/Gedanken des Täters bei der Tat
      - Die im § beschriebenen Handlungen/Erfolge für möglich halten und mit ihnen abfinden
    ],
  )

  #color-block(
    title: [Absicht (§ 5 Abs 2 StGB): ],
    [
      Darauf anlegen Handlungen/Erfolge der Norm zu verwirklichen.
    ],
  )
]

#slide(title: "Legal Definitionen")[
  #color-block(
    title: [Computersystem: ],
    [
      sowohl einzelne als auch verbundene Vorrichtungen, die der automationsunterstützten Datenverarbeitung dienen.
    ],
  )
  #color-block(
    title: [Daten: ],
    [
      sowohl personenbezogene und nicht personenbezogene Daten als auch Programme.
    ],
  )

]

#slide(title: "Legal Definition")[
  #color-block(
    title: [Kritische Infrastruktur],
    [
      - Einrichtungen, Anlagen, Systeme oder Teile mit wesentlicher Bedeutung für die Aufrechterhaltung:
        - öffentlichen Sicherheit
        - Landesverteidigung
        - Schutz der Zivilbevölkerung gegen Kriegsgefahren
        - Funktionsfähigkeit öffentlicher Informations- und Kommunikationstechnologie
    ],
  )
]

#slide(title: "Legal Definition")[
  #color-block(
    title: [Kritische Infrastruktur],
    [
      - Einrichtungen, Anlagen, Systeme oder Teile mit wesentlicher Bedeutung für die Aufrechterhaltung
        - Verhütung oder Bekämpfung von Katastrophen
        - öffentlicher Gesundheitsdienst
        - öffentliche Versorgung mit Wasser, Energie sowie lebenswichtigen Gütern
        - öffentliche Abfallentsorgungs- und Kanalwesen
        - öffentlichen Verkehr
    ],
  )
]

#slide(title: "Oldsmar Waterplant Hack")[
  #image("./figures/oldsmar.jpg")
]

#slide(title: "Oldsmar Waterplant Hack")[
  - Wasserwerk in Oldsmar, Florida gehackt

  - Hacker wollten über Steuerung große Mengen Ätznatron ins Trinkwasser leiten

  - Zugriff mittels TeamViewer und vermutlich gestohlenen Passwörtern

  - Schaden konnte durch aufmerksamen Mitarbeiter verhindert werden
]

#slide(title: "Oldsmar Waterplant Hack")[
  - Windows 7 auf den Geräten

  - Gleiche Passwörter auf allen Geräten

  - keine Firewall

  - Zugriff über TeamViewer
]

#section-slide(title: "Österreichische Gesetzgebung (StGB)")

#slide(title: "§118a StGB")[
  Widerrechtlicher Zugriff auf ein Computersystem

  === Objektive Tatseite („TUN" des Täters):
  Verschaffung des Zugriffs zu (Teilen) eines fremden Computersystems durch Überwindung einer spezifischen Sicherheitsvorkehrung im Computersystem.
]

#slide(title: "Widerrechtlicher Zugriff – Fall 1")[
  === Subjektive Tatseite (VORSATZ):
  in der Absicht sich oder einem anderen Unbefugten Kenntnis von personenbezogenen Daten zu verschaffen deren Kenntnis schutzwürdige Geheimhaltungsinteressen des Betroffenen verletzt.
]

#slide(title: "Widerrechtlicher Zugriff – Fall 1")[
  #color-block(
    title: [Beispiel Fall 1 (§ 118a StGB): ],
    [
      - T hackt sich ins Krankenhaus-System ein
      - Ziel: Einsicht in die Patientendaten seines Nachbarn N
      - T weiß, dass er unbefugt handelt
      - Ihm ist bewusst, dass es sich um besonders sensible Gesundheitsdaten handelt
      - Er nimmt die Verletzung der Geheimhaltungsinteressen billigend in Kauf → Vorsatz (+)
    ],
  )
]

#slide(title: "Widerrechtlicher Zugriff – Fall 2")[
  === Subjektive Tatseite (VORSATZ):
  in der Absicht, einem anderen einen Nachteil zuzufügen durch die Verwendung von im System gespeicherten und nicht für Täter bestimmten Daten oder durch die Verwendung des Computersystems.
]

#slide(title: "Widerrechtlicher Zugriff – Fall 2")[
  #color-block(
    title: [Beispiel Fall 2 (§ 118a StGB): ],
    [
      - T verschafft sich unbefugt Zugriff auf das Uni-Prüfungssystem
      - Er manipuliert die gespeicherten Noten, um einem Kommilitonen N einen schlechteren Abschluss zu verschaffen
      - T weiß, dass die Daten im System nicht für ihn bestimmt sind
      - Er handelt in der Absicht, N einen Nachteil zuzufügen, indem er gespeicherte Daten verwendet und das Computersystem missbraucht
      - Vorsatz (+): T erkennt die Tatbestandsmerkmale und nimmt die Nachteile bewusst in Kauf
    ],
  )
]

#slide(title: "Besonderheiten")[
  - Schutzgüter: Privatsphäre, Vermögen, Freiheit, …
  - Ermächtigungsdelikt

]

#slide(title: "Qualifikation")[
  - „Normaler" Strafrahmen: Freiheitsstrafe bis zu 6 Monaten / Geldstrafe bis zu 360 Tagessätzen

  - das Computersystem ist ein wesentlicher Bestandteil der kritischen Infrastruktur: bis zu 2 Jahren Freiheitsstrafe

  - im Rahmen einer kriminellen Vereinigung: bis zu 2 Jahren Freiheitsstrafe

  - Kritische Infrastruktur + kriminelle Vereinigung: bis zu 3 Jahren Freiheitsstrafe

]

#slide(title: "Verletzung des Telekommunikationsgeheimnisses (§ 119 StGB)")[
  - Anbringen/empfangsbereit machen einer Vorrichtung
  - Benützung/Auffangen einer elektromagnetischen Abstrahlung

  ==== Und Absicht (Vorsatz):
  sich oder unbefugtem Dritten Kenntnis vom Inhalt einer Nachricht zu verschaffen.

  #color-block(
    title: [Nachricht: ],
    [
      - mittels Telekommunikation/Computersystem übermittelt
      - Nicht für den Täter bestimmt ist
    ],
  )
]

#slide(title: "§ 119 StGB")[
  #color-block(
    title: [Beispiel – Verletzung des Telekommunikationsgeheimnisses (§ 119 StGB): ],
    [
      - T kennt das Passwort seines Mitbewohners M
      - T loggt sich ohne Erlaubnis in dessen E-Mail-Account ein
      - Er liest private Nachrichten, die eindeutig nicht für ihn bestimmt sind
      - Ziel: Herausfinden, ob M eine Beziehung mit einer gemeinsamen Bekannten hat
      - Vorsatz (+): T erkennt die Vertraulichkeit der Kommunikation und verletzt diese bewusst
    ],
  )
]

#slide(title: "Missbräuchliches Abfangen von Daten (§ 119a StGB)")[
  - Benützung einer angebrachten/empfangsbereit machen einer Vorrichtung
  - Auffangen von elektromagnetischer Abstrahlung eines Computersystems

  === Absicht:
  - Verschaffung von Kenntnis von nicht für den Täter/nicht für andere bestimmte Daten & Benützung/Zugänglichmachen an andere/Veröffentlichung von Daten.
  - Zuwendung eines Vermögensvorteils (Täter oder anderer) oder Zufügung eines Nachteils.

]

#slide(title: "Missbräuchliches Abfangen von Daten (§ 119a StGB)")[
  #color-block(
    title: [Beispiel – Missbräuchliches Abfangen von Daten (§ 119a StGB): ],
    [
      - T installiert ohne Wissen des Opfers M ein Sniffer-Programm im WLAN-Netzwerk
      - Dadurch fängt er die Online-Banking-Daten des M (Zugangsdaten, TANs) ab
      - Die Datenübertragung war nicht für T bestimmt
      - Ziel: Sich selbst unbefugten Zugriff zu verschaffen und M finanziell zu schädigen
      - Vorsatz (+): T weiß um die Vertraulichkeit der Daten und handelt bewusst missbräuchlich
    ],
  )
]

#slide(title: "Missbrauch von Tonaufnahmen- oder Abhörgeräte (§ 120 Abs 1 – 2 StGB)")[
  Abs 1:
  - Benützung eines Tonaufnahme- oder Abhörgerätes
  - Aufzeichnen/Zugänglichmachen an Unbefugte/Veröffentlichung
  - einer nicht für den Täter bestimmten Nachricht


  Abs 2:
  - Veröffentlichung /Zugänglichmachen an Dritten (nicht für diesen bestimmt) ohne Einverständnis des Sprechenden
  - Einer Tonaufnahme von einer nicht öffentlichen Äußerung
]

#slide(title: "§ 120 Abs 1 StGB")[
  #color-block(
    title: [Beispiel – Missbrauch von Tonaufnahmen- oder Abhörgeräten (§ 120 StGB): ],
    [
      - T versteckt heimlich ein Aufnahmegerät im Büro seines Chefs
      - Er nimmt ein vertrauliches Gespräch zwischen dem Chef und Geschäftspartnern auf
      - Die Nachricht war nicht für ihn bestimmt
      - Ohne Zustimmung der Gesprächspartner fertigt er die Tonaufnahme an
      - Anschließend spielt er die Aufnahme Freunden vor → Vorsatz (+)
    ],
  )
]

#slide(title: "§ 120 Abs 2 StGB")[
  #color-block(
    title: [Beispiel – § 120 Abs 2 StGB (Ibiza-Affäre): ],
    [
      - Politische Akteure (u.a. Strache, Gudenus) führten ein privates Gespräch in einer Villa auf Ibiza
      - Ohne ihre Zustimmung wurden Ton- und Videoaufnahmen des Gesprächs angefertigt
      - Die Aufnahmen wurden später veröffentlicht und einem großen Personenkreis zugänglich gemacht
      - Die Gespräche waren vertraulich und nicht für die Öffentlichkeit bestimmt
      - → Herstellung & Veröffentlichung ohne Einwilligung = Missbrauch nach § 120 Abs 2 StGB
    ],
  )
]

#slide(title: "Missbrauch von Tonaufnahmen- oder Abhörgeräte (§ 120 Abs 2a StGB)")[
  Aufzeichnung/Zugänglichmachen an einen Unbefugten/Veröffentlichung einer im Telekommunikationsweg übertragenen & nicht für den Täter bestimmten Nachricht.

  === Absicht:
  - Kenntnisverschaffung vom Inhalt der Nachricht (sich oder anderem Unbefugten)

]

#slide(title: "§ 120 Abs 2a StGB")[
  #color-block(
    title: [Beispiel – § 120 Abs 2a StGB: ],
    [
      - T installiert ohne Wissen seines Mitbewohners M eine App auf dessen Handy
      - Dadurch kann T WhatsApp-Nachrichten von M mitlesen, die über das Internet übertragen werden
      - Die Nachrichten sind eindeutig nicht für T bestimmt
      - Ziel: T will sich selbst Kenntnis vom Inhalt der privaten Kommunikation verschaffen
      - → Aufzeichnung und Zugänglichmachen im Telekommunikationsweg = Missbrauch nach § 120 Abs 2a StGB
    ],
  )
]

#slide(title: "Datenbeschädigung (§ 126a StGB)")[
  - Schädigung eines anderen durch

  - Veränderung/Löschung/Unbrauchbarmachen/Unterdrückung von Daten die automationsunterstützt verarbeitet/übermittelt/ überlassen über die der Täter nicht/nicht alleine verfügen darf

]

#slide(title: "§ 126a StGB")[
  #color-block(
    title: [Beispiel – Datenbeschädigung (§ 126a StGB): ],
    [
      - T verschafft sich unbefugt Zugang zum Firmenserver
      - Dort löscht er aus Rache die Kundendatenbank seines Arbeitgebers
      - Die Daten werden dadurch unbrauchbar für das Unternehmen
      - T darf über diese Daten nicht verfügen, verändert sie aber vorsätzlich
      - → Schädigung des Arbeitgebers durch Datenbeschädigung nach § 126a StGB
    ],
  )
]

#slide(title: "Besonderheiten")[
  Geschützte Rechtsgüter:
  - Vermögen

  - Interesse am Fortbestand und der Verfügbarkeit der Daten
  <br>
  Im Familienkreis privilegiert

]

#slide(title: "Qualifikation")[
  - Normaler Strafrahmen: bis zu 6 Monate/ 360 Tagessätze

  - Mehr als 5 000 Euro Schaden: bis zu 2 Jahre Freiheitsstrafe

  - Beeinträchtigung vieler Computersysteme unter Verwendung von eigens dafür geschaffenen Mitteln (Computerprogramme, Passwörter, Zugangscodes): bis zu 3 Jahre Freiheitsstrafe

]

#slide(title: "Qualifikation")[
  - mehr als 300 000 Euro Schaden oder

  - Beeinträchtigung wesentlicher Bestandteile der kritischen Infrastruktur oder

  - als Mitglied einer kriminellen Vereinigung

  - \>6 Monate bis zu 5 Jahre Freiheitsstrafe

  <br>

  Terroristische Straftat bei Lebensgefahr/großes Schadensausmaß
  (bei Tateignung und entsprechendem Vorsatz)

]

#slide(title: "Störung der Funktionsfähigkeit eines Computersystems (§ 126b StGB)")[
  - Schwere Störung durch Dateneingabe/Datenübermittlung eines Computersystems, über das der Täter nicht/nicht alleine verfügen darf

  - Nur wenn nicht Datenbeschädigung (§126a StGB) vorliegt Geschütztes Rechtsgut:

  - Ungestörte Verwendbarkeit des Computersystem
]

#slide(title: "§ 126b StGB")[
  #color-block(
    title: [Beispiel – Störung der Funktionsfähigkeit eines Computersystems (§ 126b StGB): ],
    [
      - T startet einen massiven DDoS-Angriff gegen die Website einer Bank
      - Durch die Überflutung mit Anfragen ist das Online-Banking für Stunden nicht erreichbar
      - Kunden können währenddessen keine Überweisungen oder Kontostände abrufen
      - Es erfolgt keine Löschung oder Veränderung von Daten → keine Datenbeschädigung (§ 126a)
      - → Schwere Störung der Funktionsfähigkeit des Systems nach § 126b StGB
    ],
  )
]

#slide(title: "Qualifikation")[
  - Normaler Strafrahmen: bis zu 6 Monate/ 360 Tagessätze

  - längere Zeit andauernde Störung: bis zu 2 Jahre

  - Schwere Störung unter Verwendung von eigens dafür geschaffenen Mitteln (Computerprogramme, Passwörter, Zugangscodes): bis zu 3 Jahre

]

#slide(title: "Qualifikation")[
  - mehr als 300 000 Euro Schaden

  oder

  - gegen ein Computersystem verübt, das ein wesentlicher Bestandteil der kritischen Infrastruktur ist

  oder

  - als Mitglied einer kriminellen Vereinigung
  <br>
  \>6 Monate bis zu 5 Jahre Freiheitsstrafe

]

#slide(title: "Missbrauch von Computerprogrammen oder Zugangsdaten (§ 126c Abs 1a StGB)")[
  - Herstellung/Einführung/Vertreibung/Veräußerung/ Zugänglichmachung/ das sich Verschaffen von Computerprogrammen zur Straftatbegehung

  - Sich Verschaffen von Zugriffsdaten
  <br>
  in Bezug auf betrügerischen Datenmissbrauch (§148a StGB): Freiheitsstrafe von bis zu zwei Jahren

]

#slide(title: "Missbrauch von Computerprogrammen oder Zugangsdaten (§ 126c Fall 1 StGB)")[
  Herstellung/Einführung/Vertreibung/Veräußerung/Zugänglichmachung/das sich Verschaffen von Computerprogrammen/vergleichbarer Vorrichtungen welche ersichtlich zum Zweck der Begehung von § 118a, 119, 119a, 126a, 126b geschaffen/adaptiert worden ist.

  - Vorsatz: Programm/Vorrichtung zur Begehung der aufgezählten Delikte zu gebrauchen

]

#slide(title: "§ 126c Abs 1a StGB")[
  #color-block(
    title: [Beispiel – Missbrauch von Computerprogrammen oder Zugangsdaten (§ 126c Abs 1a StGB): ],
    [
      - T lädt aus dem Darknet ein Phishing-Toolkit herunter
      - Ziel: damit betrügerisch Kreditkartendaten von Bankkunden zu erlangen
      - Er verschafft sich zusätzlich durch Kauf im Forum mehrere gestohlene Zugangsdaten
      - Diese Programme und Daten sind erkennbar zur Begehung von Straftaten bestimmt
      - → Missbrauch von Computerprogrammen/Zugangsdaten nach § 126c Abs 1a StGB
    ],
  )
]

#slide(title: "Missbrauch von Computerprogrammen oder Zugangsdaten (§ 126c Fall 2 StGB)")[
  Herstellung/Einführung/Vertreibung/Veräußerung/ Zugänglichmachen/ sich Verschaffen vomn Computerpasswörter, Zugangscodes oder vergleichbarer Daten welche den Zugriff auf ein Computersystem oder einen Teil davon ermöglichen.

  - Vorsatz: Zugangsdaten zur Begehung der aufgezählten Delikte von (§§ 118a, 119, 119a, 126a, 126b StGB) zu gebrauchen

  - Strafrahmen: bis zu 6 Monate/ 360 Tagessätze

]
#slide(title: "§ 126c Abs 1a StGB")[
  #color-block(
    title: [Beispiel – Missbrauch von Zugangsdaten (§ 126c Fall 2 StGB): ],
    [
      - T kauft im Darknet ein Paket mit hunderten gestohlenen Passwörtern und Zugangscodes zu E-Mail- und Cloud-Konten
      - Ziel: Mit diesen Daten will er sich in fremde Accounts einloggen und Nachrichten mitlesen (§ 119 StGB)
      - Ihm ist bewusst, dass die Zugangsdaten ausschließlich für die Begehung solcher Straftaten bestimmt sind
      - → Vorsätzliche Beschaffung von Zugangsdaten zur Tatbegehung → § 126c Fall 2 StGB erfüllt
    ],
  )
]

#slide(title: "Betrügerischer Datenverarbeitungsmissbrauch (§ 148a StGB)")[
  - Vermögensschädigung eines anderen

  - Beeinflussung des Ergebnisses einer automationsunterstützten Datenverarbeitung durch Gestaltung des Programms.

  - Eingabe, Veränderung, Löschung oder Unterdrückung von Daten

  - Einwirkung auf den Ablauf des Verarbeitungsvorgangs

  - Vorsatz: unrechtmäßige Bereicherung

]

#slide(title: "§ 148a StGB")[
  #color-block(
    title: [Beispiel – Betrügerischer Datenverarbeitungsmissbrauch (§ 148a StGB): ],
    [
      - T manipuliert den Quellcode eines Online-Shops, bei dem er als Programmierer arbeitet
      - Durch die Veränderung werden Rabatte automatisch abgezogen, auch wenn kein Gutschein eingegeben wurde
      - T nutzt die Manipulation, um Waren weit unter dem eigentlichen Preis zu kaufen
      - Dadurch erleidet der Händler einen Vermögensschaden
      - → T handelt vorsätzlich in Bereicherungsabsicht → § 148a StGB erfüllt
    ],
  )
]

#slide(title: "Ausspähen von Daten eines unbaren Zahlungsmittels (§ 241h StGB)")[
  - Ausspähung von Daten eines unbaren Zahlungsmittels

  - Vorsatz:

    - Unrechtmäßige Bereicherung durch Verwendung
    oder
    - Fälschung unbarer Zahlungsmittel

]

#slide(title: "§ 241h StGB")[
  #color-block(
    title: [Beispiel – Ausspähen von Daten eines unbaren Zahlungsmittels (§ 241h StGB): ],
    [
      - T installiert ein Skimming-Gerät am Bankomaten
      - Dabei werden die Magnetstreifendaten und PINs der Bankkarten von Kunden ausgelesen
      - Ziel: Mit den ausgespähten Daten gefälschte Karten herzustellen und Geld abzuheben
      - Vorsatz: unrechtmäßige Bereicherung durch spätere Verwendung bzw. Fälschung
      - → Tatbestand des § 241h StGB erfüllt
    ],
  )
]

#slide(title: "Verurteilungs Statistik")[
  #image("./figures/verurteilungs_statistik.png", width: 63%)

  #set text(weight: "regular", size: 11pt)
  Quelle: Statistik Austria, www.statistik.at (17.09.2025)

]

#section-slide(title: "Exkurs: deutsche Gesetzgebung (dStGB)")

#slide(title: "Rechtslage Deutschland")[
  - Strengere Ausgestaltung

  - So genannter Hackerparagraf in § 202c dStGB: Vorbereiten des Ausspähens und Abfangens von Daten
]

#slide(title: "Ausspähen von Daten (§ 202a dStGB)")[
  - Verschaffung des Zugangs zu besonders gesicherten Daten unter Überwindung einer Zugangssicherung

  - Daten, nicht für den Täter bestimmt, elektronisch, magnetisch oder sonst nicht unmittelbar wahrnehmbar gespeichert

  - Strafmaß: bis zu 3 Jahre Freiheitsstrafe/Geldstrafe

  - Keine Privatsphäreverletzung/keine Schädigungsabsicht

]

#slide(title: "Abfangen von Daten (§202b dStGB)")[
  - Verschaffung von Daten aus einer nichtöffentlichen Datenübermittlung-oder aus der elektromagnetischen Abstrahlung einer Datenverarbeitungsanlage mit Hilfe von technischen Mitteln

  - bis zu 2 Jahren Haft/Geldstrafe

  - Auffangtatbestand

]

#slide(title: "Vorbereiten des Ausspähens und Abfangens von Daten (§ 202c dStGB)")[
  - Vorbereitung von Ausspähen von Daten/Abfangen von Daten mittels Herstellung, Verschaffen, Verkaufen, Überlassen, Verbreiten-oder sonstiges Zugänglichmachen-von

    - Z 1: Passwörtern oder sonstigen Zugangscodes
    - Z 2: Computerprogrammen, zum Zweck der Begehung von Ausspähen von Daten/Abfangen von Daten

]

#slide(title: "Handlungsempfehlungen")[
  - keine Weitergabe von Hackertools, Schadprogrammen und ähnlichem

  - kein Anstiften zu den oben beschriebenen Vergehen

  - die Programme und Tools sollten sicher verwahrt werden

  - Verwendung und Anschaffungszweck von diversen Tools änderungsfest dokumentieren

  - Bei Sicherheitsüberprüfungen, Penetrationstests etc. die Einwilligung der Verfügungsberechtigten einholen

]

#section-slide(title: "Datenschutz")

#slide(title: "DSGVO")[
  - Schutz personenbezogener Daten

  - 25.5.2018

  - Sicherheit der Verarbeitung

  - Technische und organisatorische Maßnahmen – TOMs

  - Datenschutz durch Technikgestaltung und durch datenschutzfreundliche Voreinstellungen

]

#slide(title: "DSGVO")[
  #color-block(
    title: [Angemessenheit: ],
    [
      Berücksichtigung des Stands der Technik, der Implementierungskosten der Art, des Umfangs, der Umstände und der Zwecke der Verarbeitung unterschiedlichen Eintrittswahrscheinlichkeit und Schwere Risikos für die Rechte und Freiheiten natürlicher Personen.
    ],
  )
]

#slide(title: "DSGVO")[
  - Pseudonymisierung und Verschlüsselung

  - Sicherstellung der dauerhaften Vertraulichkeit, Integrität, Verfügbarkeit und Belastbarkeit der Systeme und Dienste

  - Rasche Wiederherstellung Verfügbarkeit der Daten bei einem physischen oder technischen Zwischenfall

  - Verfahren zur regelmäßigen Überprüfung, Bewertung und Evaluierung der Wirksamkeit TOMs zur Gewährleistung der Sicherheit der Verarbeitung

]

#slide(title: "DSGVO")[
  #color-block(
    title: [Meldung Data Breach:: ],
    [
      unverzügliche und möglichst binnen 72 Stunden nachdem ihm die Verletzung bekannt wurde zuständigen Aufsichtsbehörde Dokumentationspflicht.

      Hohes Risiko: Benachrichtigung betroffener Personen.
    ],
  )
]

#section-slide(title: "Artikel 24 DSGVO")

#slide(title: "Verantwortlichkeit und Datenschutzmanagement")[
  - Zweck:-Gewährleistung und Nachweis der Einhaltung der DSGVO


  - Maßnahmen:-Implementierung geeigneter technischer und organisatorischer Maßnahmen


  - Risikobasiert:-Berücksichtigung der Art, des Umfangs, der Umstände und der Zwecke der Verarbeitung sowie der Risiken für die Rechte und Freiheiten natürlicher Personen

]

#slide(title: "Datenschutz durch Technikgestaltung und durch datenschutzfreundliche Voreinstellungen")[
  - Artikel 24 (2) DSGVO:-Berücksichtigung des Stands der Technik, der Implementierungskosten, der Art, des Umfangs, der Umstände und der Zwecke der Verarbeitung sowie der unterschiedlichen Eintrittswahrscheinlichkeit und Schwere des Risikos

]

#section-slide(title: "Artikel 25 DSGVO")

#slide(title: "Artikel 25 DSGVO")[
  Datenschutz durch Technikgestaltung und durch datenschutzfreundliche Voreinstellungen

]

#slide(title: "Grundsätze des Datenschutzes durch Technikgestaltung")[
  - Ziel:-Einbeziehung des Datenschutzes in die Entwicklung von Geschäftsprozessen für Produkte und Dienstleistungen


  - Umsetzung:-Verwendung von Datenschutz-freundlichen Voreinstellungen

]

#slide(title: "Datenschutzfreundliche Voreinstellungen")[
  - Artikel 25 (2) DSGVO:-Sicherstellung, dass nur personenbezogene Daten verarbeitet werden, die für den jeweiligen spezifischen Zweck notwendig sind


  - Anwendung:-Automatische Einschränkung der Erhebung und Verarbeitung personenbezogener Daten

]

#section-slide(title: "Transparenz und Durchsetzung")


#slide(title: "Transparenz in der Datenverarbeitung")[
  - Wichtigkeit:-Klare, verständliche und leicht zugängliche Informationen über Datenverarbeitung


  - Recht auf Information:-Betroffene Personen müssen über die Erhebung und Verwendung ihrer Daten informiert werden

]

#slide(title: "Durchsetzung der Datenschutzregeln")[
  - Aufsichtsbehörden:-Zuständig für die Überwachung und Durchsetzung der DSGVO


  - Sanktionen:-Bußgelder und Strafen bei Nichteinhaltung


  - Rechte der Betroffenen:-Beschwerderecht und Recht auf Schadensersatz

]

#title-slide(
  title: [Module 01: Legal],
  subtitle: [Überblick über die Rechtslage in Österreich und Deutschland],
)
