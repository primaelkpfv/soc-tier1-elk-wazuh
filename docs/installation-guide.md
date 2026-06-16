# Guide d'Installation — SOC Tier 1

## Prérequis

- VMware Workstation Pro / VirtualBox
- RAM minimum : 16 Go
- Stockage : 100 Go disponibles

## VMs Requises

| VM | OS | RAM | CPU | Rôle |
|----|-----|-----|-----|------|
| soc-manager | Ubuntu 22.04 | 8 Go | 4 | Wazuh Manager + ELK |
| win-endpoint | Windows 10 | 4 Go | 2 | Endpoint surveillé |
| linux-endpoint | Ubuntu 20.04 | 2 Go | 2 | Endpoint surveillé |
| thehive | Ubuntu 22.04 | 4 Go | 2 | TheHive + Cortex |
| attacker | Kali Linux | 4 Go | 2 | Simulation attaques |

## Étape 1 — Installation Wazuh Manager

```bash
# Sur soc-manager (Ubuntu 22.04)
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh
sudo bash ./wazuh-install.sh -a

# Vérifier le service
sudo systemctl status wazuh-manager
```

## Étape 2 — Déploiement ELK Stack

```bash
# Elasticsearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.11.0-amd64.deb
sudo dpkg -i elasticsearch-8.11.0-amd64.deb
sudo systemctl enable --now elasticsearch

# Kibana
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.11.0-amd64.deb
sudo dpkg -i kibana-8.11.0-amd64.deb
sudo systemctl enable --now kibana
```

## Étape 3 — Installation Agents Wazuh

```bash
# Sur chaque endpoint Windows (PowerShell admin)
Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.7.0-1.msi `
  -OutFile wazuh-agent.msi
msiexec /i wazuh-agent.msi /q WAZUH_MANAGER="192.168.1.10"
NET START WazuhSvc
```

```bash
# Sur chaque endpoint Linux
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --dearmor > /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list
apt update && apt install wazuh-agent
WAZUH_MANAGER="192.168.1.10" systemctl start wazuh-agent
```

## Étape 4 — Configuration TheHive

```bash
# Installation TheHive 5
wget -O- https://raw.githubusercontent.com/StrangeBeeCorp/Security/main/PGP%20keys/packages.key |   gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg
echo 'deb [arch=all signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.strangebee.com thehive-5.x main' |   tee /etc/apt/sources.list.d/strangebee.list
apt update && apt install -y thehive
```

## Résultat Attendu

Après installation complète :
- Kibana accessible sur `http://soc-manager:5601`
- Wazuh Dashboard sur `http://soc-manager:443`
- TheHive sur `http://thehive:9000`
- Agents connectés et remontant des logs
