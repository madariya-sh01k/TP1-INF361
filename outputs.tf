output "summary" {
  value = <<EOT
 Déploiement Terraform terminé !

Résumé :
- Script généré : ${local_file.create_users_script.filename}
- Fichier utilisateurs : ${local_file.users_file.filename}
- Groupe cible : ${var.group_name}
- Nombre de VMs : ${var.vm_count}

Commandes utiles :
1. Vérifier les utilisateurs créés :
   ${local.verification_command}

2. Voir le log d'exécution :
   sudo tail -f /tmp/terraform_create_users_*.log

3. Tester un utilisateur :
   sudo su - Moussa25

Prochaines étapes :
- Les utilisateurs doivent changer leur mot de passe à la première connexion
- Vérifier les quotas et limites configurés
- Tester la connexion SSH pour chaque utilisateur
EOT
  description = "Résumé du déploiement"
}

output "created_users" {
  value = [
    for user in [
      "Moussa25",
      "DupontJ", 
      "ChenL"
    ] : user if user != null
  ]
  description = "Liste des utilisateurs créés"
}

output "next_steps" {
  value = <<EOT
Pour un déploiement cloud réel :

1. Décommentez le provider cloud dans main.tf
2. Configurez les credentials (AWS CLI, gcloud, az login)
3. Ajoutez les ressources cloud (instance, réseau, sécurité)
4. Exécutez : terraform init && terraform apply

Cloud providers disponibles :
- AWS (Amazon Web Services)
- Google Cloud Platform
- Microsoft Azure
- Oracle Cloud Infrastructure
EOT
  description = "Instructions pour un déploiement cloud"
}
