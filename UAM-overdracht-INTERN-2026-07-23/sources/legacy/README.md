# Legacy agent source

`uam.redacted.ps1` is the fixed UAM V0.7 source used for this handover. It is intended as behavior evidence and migration input, not as a deployable production build.

Original source:

```text
H:\Mijn Documenten\UAM\V0.7\uam.ps1
```

Original SHA-256:

```text
44F7CBDB53C5A0100D30B531F1AC478E186EDBB744EEC06BA2A5DA4B699A2B94
```

The transfer copy contains one deliberate security redaction: the literal value assigned to `$Pwd` in `Invoke-SqlQuery` was replaced with `<REDACTED-HARDCODED-CREDENTIAL>`. The original value must not be emailed, documented, committed or reused. The other apparent `Token` hit in the function is a dynamic SQL construction token and is not a credential.

After redaction the script still parses successfully, but it must not be used as a production replacement. The C# implementation must retrieve database or API secrets from an approved secret store and endpoints must not connect directly to the central database.
