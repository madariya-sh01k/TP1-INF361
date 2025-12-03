# Partie 1 : SCript Bash D'automatisation

	
	## Script : create_users.sh


	### Description
	Script Bash pour automatiser la creation d'utilisateur a partir d'un fichier texte.


	### Fonctionnalites implementees
	1. Creation du groupe 'students-inf-361'
	2. Creation automatique de chaque utilisateur avec :
		-> Nom d'utilisateur
		-> Nom complet, telephone, email
		-> Shell prefere (Verification + installation si besoin)
		-> Repertoire personnel
	3. Ajout au groupe students-inf-361
	4. Mot de passe hache (SHA-512)
	5. Changement force du mot de passe a la premiere connexion
	6. Ajout au groupe sudo + blocage de 'su'
	7. Message de bienvenue personnalise ('~/WELCOME.txt')
	8. Limite d'espace disque (15 Go) via quotas
	9. Limite memoire (20% RAM) via systemd slices
	10. Journalisation complete des operations


	### Fichiers necessaires
	-> 'create_users.sh' : Script principal
	-> 'users.txt' : Liste des utilisateur suivant le format 'username;password;full_name;phone;email;shell'


	### Utilisation
	1. Rendre le script executable
		chmod +x create_users.sh

	2.Executer avec le nom du groupe
		sudo ./create_users.sh students-inf-361
