#!/bin/bash
# Script de création d'utilisateurs pour Terraform
# Généré automatiquement

set -e

GROUP_NAME="${1:-students-inf-361}"
USERS_FILE="${USERS_FILE:-users.txt}"
LOG_FILE="/tmp/terraform_create_users_$(date +%Y%m%d_%H%M%S).log"

echo "=== Exécution via Terraform ===" > "$LOG_FILE"
echo "Date: $(date)" >> "$LOG_FILE"
echo "Groupe: $GROUP_NAME" >> "$LOG_FILE"
echo "===============================" >> "$LOG_FILE"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Début de l'exécution du script Terraform"

# Vérifier le fichier users.txt
if [ ! -f "$USERS_FILE" ]; then
    log "ERREUR: Fichier $USERS_FILE non trouvé"
    exit 1
fi

# Créer le groupe s'il n'existe pas
if ! getent group "$GROUP_NAME" > /dev/null; then
    groupadd "$GROUP_NAME"
    log "Groupe $GROUP_NAME créé"
fi

# Lire et créer les utilisateurs
while IFS=';' read -r username password full_name phone email shell || [ -n "$username" ]; do
    [ -z "$username" ] && continue
    
    log "Traitement de $username"
    
    if ! id "$username" &>/dev/null; then
        useradd -m -c "$full_name" -s "$shell" "$username"
        log "Utilisateur $username créé"
    fi
    
    # Ajouter au groupe
    usermod -aG "$GROUP_NAME" "$username"
    
    # Configurer mot de passe haché
    hashed_pw=$(openssl passwd -6 "$password")
    echo "$username:$hashed_pw" | chpasswd -e
    
    # Forcer changement mot de passe
    chage -d 0 "$username"
    
    # Créer fichier de bienvenue
    cat > "/home/$username/WELCOME.txt" << WELCOME_EOF
Bienvenue $full_name !

Votre compte a été créé via Terraform.
Utilisateur: $username
Email: $email

Date: $(date)
WELCOME_EOF
    
    chown "$username:$username" "/home/$username/WELCOME.txt"
    
done < "$USERS_FILE"

log "Script Terraform exécuté avec succès"
echo "Consultez le log: $LOG_FILE"
EOF

# Créer le fichier users.txt pour Terraform
cat > data/users.txt <<'EOF'
Moussa25;Nguebitigue2000;TIGUE MOUSSA MADARIYA;693606003;madariya.tigue@facsciences-uy1.cm;/bin/bash
DupontJ;Azerty123;DUPONT Jean;612345678;jean.dupont@mail.fr;/bin/bash
ChenL;Passw0rd!;CHEN Li;698765432;li.chen@mail.cn;/bin/zsh
