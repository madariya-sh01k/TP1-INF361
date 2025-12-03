# Partie 3 : Terraform

	## Infrastructure as Code pour le déploiement

	### Description
	Utilisation de Terraform pour exécuter le script de création d'utilisateurs, avec possibilité de déploiement cloud.

	### Architecture
		Partie3/
		├── main.tf # Configuration principale
		├── variables.tf # Variables Terraform
		├── outputs.tf # Sorties Terraform
		├── terraform.tfvars.example # Exemple de variables
		├── scripts/
		│ └── create_users.sh # Script pour Terraform
		└── data/
		└── users.txt # Données des utilisateurs
		
	### Fonctionnalités
		1. Génération du script de création d'utilisateurs
		2. Gestion du fichier users.txt
		3. Exécution automatique du script via provisioners
		4. Configuration pour déploiement cloud (AWS/GCP/Azure)
		5. Sorties et rapports automatisés

	### Utilisation

		#### Test local :

		# Initialiser
		terraform init

		# Vérifier
		terraform validate

		# Planifier
		terraform plan

		# Appliquer
		terraform apply -auto-approve

		# Vérifier les sorties
		terraform output

		# Nettoyer
		terraform destroy -auto-approve
		
		
	### Pour déploiement cloud :
		* Décommentez le provider cloud dans main.tf
    		* Configurez les credentials :
    			# AWS
			aws configure

			# Google Cloud
			gcloud auth application-default login

			# Azure
			az login
