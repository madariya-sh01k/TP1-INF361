# Partie 2 : Playbook Ansible


	## Playbook : `create_users.yml`

	### Description
	Playbook Ansible reproduisant exactement les fonctionnalités du script Bash avec envoi d'emails.

	### Architecture

	Partie2/
	├── create_users.yml # Playbook principal
	├── users.yml # Données des utilisateurs
	├── configure_postfix.sh # Configuration email
	└── ansible/
	└── inventory/
	└── hosts.ini # Inventaire Ansible


	### Fonctionnalités implémentées
		1. Création du groupe `students-inf-361`
		2. Création des utilisateurs avec toutes leurs informations
		3. Vérification/installation des shells
		4. Ajout aux groupes `students-inf-361` et `sudo`
		5. Blocage de `su` via PAM
		6. Mot de passe haché SHA-512
		7. Changement forcé à première connexion
		8. Fichier de bienvenue personnalisé
		9. Configuration .bashrc/.zshrc
		10. Quotas disque (15 Go)
		11. Limites mémoire (20% RAM)
		12. Envoi d'email personnalisé à chaque utilisateur
		13. Génération de rapport

	### Email envoyé contenant :
		- Adresse IP du serveur
		- Port SSH
		- Nom d'utilisateur
		- Mot de passe initial
		- Commande SSH de connexion
		- Commande pour transmettre clé SSH (tous OS)

	### Utilisation
		# Tester d'abord
		ansible-playbook create_users.yml -i ansible/inventory/hosts.ini --check

		# Exécuter
		ansible-playbook create_users.yml -i ansible/inventory/hosts.ini

		# Avec verbosité
		ansible-playbook create_users.yml -i ansible/inventory/hosts.ini -v
		
	
		
	###Configuration requise
    		* Ansible installé
    		* Postfix pour les emails (configuré automatiquement)
    		* Accès sudo sur la machine cible
