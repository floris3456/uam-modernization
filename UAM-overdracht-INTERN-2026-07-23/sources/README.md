# Bronbestanden voor overdracht

## Legacy agent

`legacy/uam.redacted.ps1` is een complete, parseerbare kopie van de legacy
agentbron met één doelgerichte beveiligingsredactie:

- originele bron: `H:\Mijn Documenten\UAM\V0.7\uam.ps1`;
- originele SHA-256: `44F7CBDB53C5A0100D30B531F1AC478E186EDBB744EEC06BA2A5DA4B699A2B94`;
- originele regel 1384 bevatte in `Invoke-SqlQuery` een hardcoded `$Pwd`;
- alleen de waarde van die toewijzing is vervangen door
  `<REDACTED-HARDCODED-CREDENTIAL>`;
- de geredigeerde kopie parseert zonder PowerShell-syntaxfouten;
- SHA-256 geredigeerde kopie:
  `541931436F59F0A18E6637C6F2BFB136D0DA238B2751B716A0500492D44C5935`.

Het originele geheim hoort niet in broncode, documentatie of een
overdrachtsarchief. De C#-implementatie moet een goedgekeurde secret store en
een expliciete database-/API-identiteit gebruiken.

## PSU DEV-app

De actuele DEV-appbron staat op projectniveau als `uam-logging.ps1`. De
productie-appbron is wel geanalyseerd en gehasht, maar wordt niet als blijvend
artifact opgenomen. Zo worden onnodige productieconfiguratie en mogelijke
klantspecifieke details niet verder verspreid.
