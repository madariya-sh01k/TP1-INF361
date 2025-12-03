terraform {
  required_version = ">= 1.0"
  
  required_providers {
    # Pour tester localement, on utilise le provider "local"
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    
    # Pour un déploiement réel avec AWS/Google Cloud/Azure
    # Décommentez le provider correspondant
    
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 5.0"
    # }
    
    # google = {
    #   source  = "hashicorp/google"
    #   version = "~> 4.0"
    # }
    
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 3.0"
    # }
  }
}

# Provider local pour tester sans cloud
provider "local" {
  # Configuration par défaut
}

# Provider null pour exécuter des commandes
provider "null" {}

# Variables locales
locals {
  script_content = templatefile("${path.module}/scripts/create_users.sh", {
    group_name = var.group_name
  })
}

# Ressource pour créer le script localement
resource "local_file" "create_users_script" {
  filename = "${path.module}/create_users.sh"
  content  = local.script_content
  
  provisioner "local-exec" {
    command = "chmod +x ${self.filename}"
  }
}

# Ressource pour copier le fichier users.txt
resource "local_file" "users_file" {
  filename = "${path.module}/users.txt"
  content  = file("${path.module}/data/users.txt")
}

# Exécution du script de création d'utilisateurs
resource "null_resource" "execute_user_creation" {
  depends_on = [local_file.create_users_script, local_file.users_file]
  
  # Déclencheur : toujours exécuter
  triggers = {
    always_run = timestamp()
  }
  
  # Exécution locale du script
  provisioner "local-exec" {
    command = "sudo ${path.module}/create_users.sh ${var.group_name}"
    
    environment = {
      USERS_FILE = "${path.module}/users.txt"
    }
  }
  
  # Provisioner pour nettoyer après destruction
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Nettoyage des ressources Terraform...'"
  }
}

# Sorties
output "script_location" {
  value       = local_file.create_users_script.filename
  description = "Emplacement du script généré"
}

output "users_file_location" {
  value       = local_file.users_file.filename
  description = "Emplacement du fichier users.txt"
}

output "execution_command" {
  value       = "sudo ${path.module}/create_users.sh ${var.group_name}"
  description = "Commande pour exécuter manuellement le script"
}

output "verification_command" {
  value       = "getent group ${var.group_name} | cut -d: -f4 | tr ',' '\\n' | wc -l"
  description = "Commande pour vérifier le nombre d'utilisateurs créés"
}
