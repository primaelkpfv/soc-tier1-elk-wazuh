# 🛡️ SOC Tier 1 Simulé — ELK Stack + Wazuh + TheHive

![Status](https://img.shields.io/badge/Status-Complété-success)
![Tools](https://img.shields.io/badge/Tools-ELK%20%7C%20Wazuh%20%7C%20TheHive-blue)
![MITRE](https://img.shields.io/badge/Framework-MITRE%20ATT%26CK-red)
![ESAIP](https://img.shields.io/badge/Projet-ESAIP%202025-orange)

> Projet académique ESAIP — Architecture SOC complète déployée sur machines virtuelles avec simulation d'attaques réelles.

---

## 📌 Objectif

Déployer une infrastructure SOC Tier 1 fonctionnelle permettant :
- La **collecte et centralisation des logs** Windows/Linux
- La **détection d'intrusions** via règles HIDS (Wazuh)
- La **gestion des incidents** avec workflow TheHive/Cortex
- La **simulation d'attaques** pour valider la détection
- La **corrélation d'alertes** SIEM et visualisation Kibana

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     SOC Tier 1 Lab                      │
│                                                         │
│  ┌──────────────┐    ┌──────────────┐                   │
│  │ Wazuh Agent  │    │ Wazuh Agent  │                   │
│  │ Windows 10   │    │  Ubuntu 22   │                   │
│  └──────┬───────┘    └──────┬───────┘                   │
│         │                   │                           │
│         └─────────┬─────────┘                           │
│                   ▼                                     │
│         ┌─────────────────┐                             │
│         │  Wazuh Manager  │ ◄── HIDS / FIM / SCA       │
│         └────────┬────────┘                             │
│                  │                                      │
│         ┌────────▼────────┐                             │
│         │   ELK Stack     │                             │
│         │ Elasticsearch   │                             │
│         │    Logstash     │                             │
│         │     Kibana      │                             │
│         └────────┬────────┘                             │
│                  │  Alertes                             │
│         ┌────────▼────────┐                             │
│         │    TheHive 5    │ ◄── Case Management         │
│         │     Cortex      │ ◄── Analyseurs automatiques │
│         └─────────────────┘                             │
└─────────────────────────────────────────────────────────┘
```

---

## 🛠️ Stack Technique

| Composant | Version | Rôle |
|-----------|---------|------|
| **Elasticsearch** | 8.x | Stockage & indexation des logs |
| **Logstash** | 8.x | Pipeline d'ingestion et parsing |
| **Kibana** | 8.x | Visualisation & dashboards |
| **Wazuh Manager** | 4.7 | HIDS, FIM, SCA, vulnerability detection |
| **Wazuh Agent** | 4.7 | Collecte logs endpoints |
| **TheHive 5** | 5.x | Gestion des cas d'incidents |
| **Cortex** | 3.x | Analyseurs & répondeurs automatisés |
| **Metasploit** | Latest | Simulation d'attaques |

---

## 🎯 Scénarios d'Attaque Simulés

### 1. Brute Force SSH
```bash
# Simulation côté attaquant
msfconsole -q -x "use auxiliary/scanner/ssh/ssh_login;   set RHOSTS 192.168.1.50; set USER_FILE users.txt;   set PASS_FILE rockyou_mini.txt; run"
```
**Détection Wazuh** : Règle 5763 (SSH brute force > 10 tentatives/min)

### 2. Scan de ports Nmap
```bash
nmap -sV -O --script vuln 192.168.1.0/24
```
**Détection Wazuh** : Règle 40111 (scan réseau détecté)

### 3. Élévation de privilèges Linux
```bash
# Exploitation SUID
find / -perm -4000 -type f 2>/dev/null
```
**Détection Wazuh** : Règle 550 (FIM — modification fichiers système)

### 4. Mimikatz (dump credentials Windows)
```powershell
# Wazuh détecte via Sysmon EventID 10
Invoke-Mimikatz -Command '"sekurlsa::logonpasswords"'
```
**Détection Wazuh** : Règle 92200 (Credential access — MITRE T1003)

---

## 📊 Règles de Détection Créées

```xml
<!-- Règle personnalisée : Détection scan Nmap -->
<rule id="100001" level="10">
  <if_group>syslog</if_group>
  <match>nmap</match>
  <description>Scan réseau détecté - Possible reconnaissance</description>
  <mitre>
    <id>T1046</id>
  </mitre>
</rule>

<!-- Règle : Brute force multiple services -->
<rule id="100002" level="12" frequency="10" timeframe="60">
  <if_matched_sid>5760</if_matched_sid>
  <description>Brute force SSH - 10+ tentatives en 60s</description>
  <mitre>
    <id>T1110</id>
  </mitre>
</rule>
```

---

## 📈 Dashboards Kibana

- **Overview SOC** : Alertes temps réel, top 10 règles déclenchées
- **Authentification** : Succès/Echecs SSH/RDP par heure
- **FIM** : Modifications fichiers critiques (`/etc/passwd`, registre)
- **Vulnérabilités** : CVEs détectées par endpoint
- **MITRE ATT&CK** : Heatmap des techniques observées

---

## 📁 Structure du Projet

```
soc-tier1-elk-wazuh/
├── docs/
│   ├── architecture.md          # Schéma détaillé infrastructure
│   ├── installation-guide.md    # Guide déploiement pas à pas
│   └── rapport-soutenance.md    # Rapport jury ESAIP
├── config/
│   ├── wazuh/
│   │   ├── ossec.conf           # Config Wazuh Manager
│   │   └── local_rules.xml      # Règles de détection custom
│   ├── logstash/
│   │   └── wazuh-pipeline.conf  # Pipeline ingestion logs
│   └── thehive/
│       └── application.conf     # Config TheHive
├── dashboards/
│   └── kibana-soc-dashboard.json # Export dashboard Kibana
├── scripts/
│   ├── deploy.sh                # Script déploiement automatisé
│   └── simulate-attacks.sh      # Scénarios d'attaque Metasploit
└── README.md
```

---

## 🔗 Références

- [Wazuh Documentation](https://documentation.wazuh.com)
- [MITRE ATT&CK Framework](https://attack.mitre.org)
- [TheHive Project](https://thehive-project.org)
- [Portfolio](https://primaelkpfv.github.io)

---

*Projet réalisé dans le cadre du Bachelor Cybersécurité — ESAIP 2025*  
*Soutenu devant jury professionnel*
