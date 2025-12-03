variable "vm_count" {
  description = "Nombre de VMs à créer pour le TP"
  type        = number
  default     = 1
}

variable "vm_name" {
  description = "Nom de base pour les VMs"
  type        = string
  default     = "tp-inf361"
}

variable "vm_user" {
  description = "Utilisateur par défaut sur les VMs"
  type        = string
  default     = "admin"
}

variable "ssh_public_key" {
  description = "Clé publique SSH pour l'accès aux VMs"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "group_name" {
  description = "Nom du groupe pour les étudiants"
  type        = string
  default     = "students-inf-361"
}

variable "region" {
  description = "Région pour les ressources cloud"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type d'instance pour les VMs"
  type        = string
  default     = "t2.micro"
}

variable "create_users_script_url" {
  description = "URL du script de création d'utilisateurs"
  type        = string
  default     = "https://raw.githubusercontent.com/votre-repo/INF361-TP/main/Partie1/create_users.sh"
}

variable "users_file_url" {
  description = "URL du fichier users.txt"
  type        = string
  default     = "https://raw.githubusercontent.com/votre-repo/INF361-TP/main/Partie1/users.txt"
}
