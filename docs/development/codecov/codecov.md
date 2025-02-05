# Codecov Einrichtung und Nutzung

Diese Anleitung beschreibt, wie Codecov in einem neuen Repository eingerichtet und genutzt wird.

## Voraussetzungen

- Ein GitHub-Konto
- Ein Repository mit Testabdeckungsberichten

## Schritte zur Einrichtung

1. Melden Sie sich bei Codecov an:
   - Besuchen Sie https://codecov.io/
   - Klicken Sie auf "Sign Up" und wählen Sie die Anmeldung mit GitHub[6]

2. Repository hinzufügen:
   - Wählen Sie das gewünschte Repository aus der Liste Ihrer GitHub-Repositories aus[6]

3. Codecov-Token kopieren:
   - Kopieren Sie den angezeigten Codecov-Upload-Token[6]

4. GitHub-Secrets einrichten:
   - Gehen Sie zu Ihrem GitHub-Repository
   - Navigieren Sie zu "Settings" > "Secrets" > "New repository secret"
   - Erstellen Sie ein neues Secret mit dem Namen `CODECOV_TOKEN` und fügen Sie den kopierten Token als Wert ein[4]

5. Workflow-Datei erstellen:
   - Erstellen Sie eine `.github/workflows/codecov.yml` Datei in Ihrem Repository
   - Fügen Sie folgenden Inhalt hinzu:

name: Codecov
on: [push, pull_request]
jobs:
run:
runs-on: ubuntu-latest
steps:
- name: Checkout
uses: actions/checkout@v2
- name: Set up Python
uses: actions/setup-python@v2
with:
python-version: '3.x'
- name: Install dependencies
run: |
python -m pip install --upgrade pip
pip install -r requirements.txt
- name: Run tests and collect coverage
run: pytest --cov=./ --cov-report=xml
- name: Upload coverage to Codecov
uses: codecov/codecov-action@v2
with:
token: ${{ secrets.CODECOV_TOKEN }}
files: ./coverage.xml
flags: unittests
name: codecov-umbrella
fail_ci_if_error: true

text

6. Commit und Push:
- Committen Sie die Änderungen und pushen Sie sie in Ihr Repository

## Nutzung

1. Codecov-Berichte ansehen:
- Nach jedem Push oder Pull Request wird der Workflow ausgeführt
- Besuchen Sie die Codecov-Website, um detaillierte Berichte einzusehen[7]

2. Badge hinzufügen:
- Gehen Sie zu `https://app.codecov.io/gh/{YOUR_ORG}/{YOUR_REPO}/settings/badge`
- Kopieren Sie den Markdown-Code für das Badge
- Fügen Sie das Badge zu Ihrer README.md hinzu[7]

3. Pull Request-Integration:
- Codecov kommentiert automatisch Pull Requests mit Abdeckungsinformationen
- Überprüfen Sie die Kommentare, um Änderungen in der Testabdeckung zu sehen[3]

4. Codecov-Konfiguration anpassen:
- Erstellen Sie bei Bedarf eine `codecov.yml` Datei im Root-Verzeichnis Ihres Repositories
- Passen Sie die Einstellungen nach Ihren Anforderungen an

## Tipps

- Stellen Sie sicher, dass Ihre Tests Abdeckungsberichte generieren
- Überprüfen Sie regelmäßig Ihre Codecov-Berichte, um Bereiche mit geringer Abdeckung zu identifizieren
- Nutzen Sie die Codecov-Funktionen wie Pull Request-Kommentare und GitHub-Checks, um die Codequalität zu verbessern

Diese Anleitung bietet eine umfassende Übersicht zur Einrichtung und Nutzung von Codecov in einem neuen Repository. Sie enthält Schritte zur Anmeldung, Konfiguration, Integration mit GitHub Actions und Tipps zur effektiven Nutzung von Codecov.

## Links
https://about.codecov.io/
https://github.com/codecov/codecov-action
https://github.com/codecov/codecov-cli
https://github.com/codecov/self-hosted

