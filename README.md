# 🛡️ SOC Tier 1 Simulé — ELK Stack + Wazuh + TheHive

![Status](https://img.shields.io/badge/Status-Terminé-brightgreen)
![Stack](https://img.shields.io/badge/Stack-ELK%20%7C%20Wazuh%20%7C%20TheHive-blue)
![Category](https://img.shields.io/badge/Catégorie-SSI%20·%20Blue%20Team-blueviolet)

> Projet académique ESAIP — Architecture SOC complète déployée sur machines virtuelles, avec simulation dattaques réelles et corrélation SIEM.

## 🎯 Objectif

Déployer une architecture SOC Tier 1 opérationnelle dans un environnement virtualisé, capable de :
- Ingérer et normaliser des logs Windows/Linux
- Détecter des comportements malveillants via des règles custom
- Corréler les alertes et créer des cases dincident
- Simuler des attaques réelles avec Metasploit

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│                   RÉSEAU SOC LAB                     │
│                                                     │
│  ┌──────────┐    ┌──────────┐    ┌───────────────┐  │
│  │ Attaquant│    │ Victime  │    │  SOC Server   │  │
│  │ Kali     │───▶│ Windows  │    │  ELK + Wazuh  │  │
│  │ Linux    │    │ 10       │    │  + TheHive    │  │
│  └──────────┘    └──────────┘    └───────────────┘  │
│                       │                  ▲          │
│                       └──── Logs ────────┘          │
└─────────────────────────────────────────────────────┘
```

## 🛠️ Stack technique

| Composant | Rôle | Version |
|-----------|------|---------|
| **Elasticsearch** | Stockage et indexation des logs | 8.x |
| **Logstash** | Ingestion et normalisation (pipelines) | 8.x |
| **Kibana** | Visualisation, dashboards SIEM | 8.x |
| **Wazuh HIDS** | Détection dintrusion host-based | 4.x |
| **TheHive** | Gestion des incidents (case management) | 5.x |
| **Metasploit** | Simulation dattaques | latest |

## 📋 Étapes du projet

### 1. Déploiement infrastructure
- Installation ELK Stack sur VM Ubuntu Server 22.04
- Configuration Elasticsearch cluster single-node
- Déploiement agents Wazuh sur VMs Windows 10 et Ubuntu

### 2. Ingestion des logs
- Pipelines Logstash pour logs Windows (Sysmon, Security, System)
- Pipelines pour logs Linux (/var/log/auth.log, syslog)
- Index patterns Kibana et dashboards custom

### 3. Règles de détection
- Règles Wazuh custom (brute force, privilege escalation, lateral movement)
- Alertes Kibana SIEM basées sur MITRE ATT&CK
- Corrélation multi-sources

### 4. Simulation dattaques (Metasploit)
- Port scanning (Nmap)
- Exploitation EternalBlue (MS17-010)
- Pass-the-Hash
- Reverse shell Meterpreter
- Persistence (autorun registry)

### 5. Réponse à incident
- Triage des alertes dans TheHive
- Création de cases et assignation
- Rapport dincident avec IOCs

## 📊 Résultats

- ✅ **12 règles de détection** créées et validées
- ✅ **100% des attaques simulées** détectées
- ✅ **Temps moyen de détection** : < 2 minutes
- ✅ **Dashboard Kibana** avec 8 visualisations SIEM
- ✅ **Documentation complète** présentée devant jury professionnel

## 🗂️ Structure du repo

```
soc-tier1-elk-wazuh/
├── architecture/
│   ├── network-diagram.md
│   └── vm-config.md
├── configs/
│   ├── logstash/
│   │   ├── windows-pipeline.conf
│   │   └── linux-pipeline.conf
│   ├── wazuh/
│   │   └── custom-rules.xml
│   └── elasticsearch/
│       └── index-template.json
├── detection-rules/
│   ├── brute-force.md
│   ├── lateral-movement.md
│   └── persistence.md
├── attack-scenarios/
│   ├── eternalblue.md
│   ├── pass-the-hash.md
│   └── reverse-shell.md
├── reports/
│   └── incident-report-template.md
└── README.md
```

## 🔗 Références

- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [Wazuh Documentation](https://documentation.wazuh.com/)
- [Elastic SIEM](https://www.elastic.co/siem)
- [TheHive Project](https://thehive-project.org/)

## 👤 Auteur

**Fèmi KPONOU** — Étudiant Bachelor Cybersécurité ESAIP  
🌐 [Portfolio](https://primaelkpfv.github.io) · 💼 [LinkedIn](https://linkedin.com/in/primaelkponou)
