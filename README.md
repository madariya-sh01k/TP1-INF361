# TP INF361 : Administration Systèmes et Réseaux

## Automatisation de la création d'utilisateurs sous Linux

### Auteur
TIGUE MOUSSA MADARIYA

### Date
$(date +%d/%m/%Y)

### Description
Ce projet implémente trois méthodes d'automatisation pour la création d'utilisateurs :
1. Script Bash
2. Playbook Ansible  
3. Infrastructure as Code avec Terraform

### Structure du projet
INF361-TP/
├── Partie0/ # Configuration SSH
├── Partie1/ # Script Bash
├── Partie2/ # Playbook Ansible
├── Partie3/ # Terraform
└── README.md # 


### Fonctionnalités implémentées
- Création automatique d'utilisateurs à partir d'un fichier CSV
- Hachage SHA-512 des mots de passe
- Changement forcé à la première connexion
- Ajout au groupe sudo avec restriction `su`
- Messages de bienvenue personnalisés
- Quotas disque (15 Go) et mémoire (20% RAM)
- Envoi d'emails de notification
- Journalisation complète
- Déploiement multi-méthodes (Bash, Ansible, Terraform)

### Prérequis
- Ubuntu Server 22.04+
- Accès root/sudo
- Connexion internet (pour Ansible et Terraform)

### Installation rapide
```bash
# Exécuter le déploiement complet
./deploy_all.sh

Méthodes de déploiement
1. Script Bash (Partie 1)
cd Partie1
sudo ./create_users.sh students-inf-361

2. Ansible (Partie 2)
cd Partie2
ansible-playbook create_users.yml -i ansible/inventory/hosts.ini

3. Terraform (Partie 3)
cd Partie3/terraform
terraform init && terraform apply

