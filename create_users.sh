# Partie 1 : Ecrire un Script Bash pour automatiser la creation des utilisateurs


# Creer le script create_users.sh

#!/bin/bash

# create_users.sh - Automatisation de la cration des utilisateurs
# TP INF361 - Administration Systeme et Reseaux
# Usage : ./create_users.sh <nom>


set -euo pipefail  # Mode strict : erreur, variables non definies, pipefail

# =========== CONFIGURATION =============
LOG_FILE="create_users_$(date +%Y%m%d_%H%M%S).log"
USERS_FILE="users.txt"

# =========== FONCTIONS ===============
log_message(){
local message="$1"
local timestamp
timestamp=$(date +'%Y-%m-%d %H:%M:%S')
echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}

check_command(){
if ! command -v "$1" &>/dev/null; then
log_message "ERREUR: Commande '$1' non trouvee. Installation necessaire."
return 1
fi
return 0
}

install_shell_if_needed(){
local shell_path="$1"
local username="$2"

# Si le shell est bash ou sh, ils sont deja installes
[[ "$shell_path" == "/bin/bash" || "$shell_path" == "/bin/sh" ]] && return 0

# Verifie si le shell fournis existe
if [[ -x "$shell_path" ]]; then
log_message "Shell $shell_path existe deja"
return 0
fi

# Essayer d'installer le shell
log_message "Tentative d'installation de $shell_path ..."

# Extraire le nom du package (ex: /bin/zsh -> zsh)
local shell_name
shell_name=$(basename "$shell_path")

if sudo apt-get install -y "$shell_name" 2>/dev/null; then
log_message "Shell $shell_name installee avec succes"
return 0
else
log_message "Echec installation de $shell_name, attribution de /bin/bash"
sudo usermod -s /bin/bash "$username"
return 1
fi
}


#================ VERIFICATION INITIALES ===================
log_message "=== DEBUT DU SCRIPT DE CREATION D'UTILISATEURS ==="
log_message "Script execute par: $(whoami)"
log_message "Date: $(date)"
log_message "Repertoire: $(pwd)"

# Verifier les arguments
if [[ $# -ne 1 ]]; then
log_message "ERREUR: USage incorrect"
echo "Usage: $0 <nom_du_groupe>"
echo "Exemple: $0 students-inf-361"
exit 1
fi

GROUP_NAME="$1"
log_message "Groupe specifiee: $GROUP_NAME"


#Verification de l'existence du fichier users.txt
if [[ ! -f "$USERS_FILE" ]]; then
log_message "ERREUR: fichier $USERS_FILE introuvable"
exit 1
fi

# Verifier les commandes necessaires
for cmd in useradd usermod chpasswd chage openssl; do
check_command "$cmd" || exit 1
done


#=========== CREATION DU GROUPE ================
log_message "Verification/Creation du groupe: $GROUP_NAME"
if getent group "$GROUP_NAME" > /dev/null; then
log_message "Le groupe $GROUP_NAME existe deja"
else
if sudo groupadd "$GROUP_NAME"; then
log_message "Groupe $GROUP_NAME cree avec succes"
else
log_message "Erreur lors de la creation du groupe"
exit 1
fi
fi

#========= CONFIGURATION PAM POUR BLOQUER 'su' =============
log_message "Configuration PAM pour bloquer 'su' pour le groupe $GROUP_NAME"
if grep -q "pam_wheel.so" /etc/pam.d/su; then
log_message "PAM est deja configuree pour pam_wheel"
else
echo "auth required pam_wheel.so group=$GROUP_NAME" | sudo tee -a /etc/pam.d/su > /dev/null
log_message "Configuration PAM appliquee"
fi


#========== TRAITEMENT DES UTILISATEURS ==============
log_message "Debut du traitrement des utilisateurs..."
user_count=0

while IFS=';' read -r username password full_name phone email preferred_shell || [[ -n "$username" ]]; do
# Ignorer les lignes vides ou en commentaires
[[ -z "$username" || "$username" =~ ^# ]] && continue

user_count$((user_count + 1))
log_message "--- Traitement utilisateur #$user_count: $username ---"


# ==========CREATION/MAJ UTILISATEUR =============
if id "$username" &>/dev/null; then
log_message "Utilisateur $username exite deja, mise a jour..."
# Mettre a jour les informations
sudo usermod -c "$full_name " "$username"
else
# Creer l'utilisateur avec repertoire personnel
log_message "Creation de l'utilisateur: $username"
if sudo useradd -m -c "$full_name" -s "preferred_shell" "$username"; then
log_message "Utilisateur $username cree"
else
log_message "Erreur creation utilisateur $username"
continue # On passe a l'utilisateur suivant
fi
fi


# =========GESTION DU SHELL =========
install_shell_if_needed "$preferred_shell" "$username"


# ============= AJOUT AU GROUPES ==========
log_message "Ajout aux groupes: $GROUP_NAME et sudo"
sudo usermod -aG "$GROUP_NAME" "$username" 2>/dev/null || log_message "Attention erreur ajout groupe $GROUP_NAME"
sudo usermod -aG sudo "$username" 2>/dev/null || log_message "Attention: erreur ajout groupe sudo"


# ============ MOT DE PASSE HACHE (SHA-512) ===================
log_message "Configuration du mot de passe hache (SHA-512)"
hashed_pw=$(openssl passwd -6 "$password")
echo "$username:$hashed_pw" | sudo chpasswd -e
log_message "Mot de passe configure pour $username"


# ===========FORCER CHANGEMENT DE MOT DE PASSE ====================
log_message "Forcage changement mot de passe a premiere connexion"
sudo chage -d 0 "$username"


# ============ FICHIER DE BIENVENUE =====================
log_message "Creation du fichier de bienvenue"
WELCOME_FILE="/home/$username/WELCOME.txt"
sudo bash -c "cat > '$WELCOME_FILE'" << WELCOME_EOF
===================================================
||                                               ||
           BIENVENU SUR LE SERVEUR                
||                                               ||
               TP INF 361 - ASR                   
||                                               ||
===================================================

Bonjour $full_name,

Votre compte a ete cree avec succes

INFORMATIONS DE COMPTE :
* Nom d'utilisateur : $username
* Email : $email
* Telephone : $phone
* Shell : $(getent passwd "$username" | cut -d: -f7)


CONSIGNES IMPORTANTES :
1. Vous devez changer votre mot de passe a la premiere connexion
2. Votre espace disaue est limite a 15 Go
3. Votre consommation memoire est limitee a 20% de la RAM
4. L'usage de 'su' est interdit pour votre groupe


Date de creation : $(date)


Pour Toute assistance, contactez l'administrateur.
WELCOME_EOF

sudo chown "$username:$username" "$WELCOME_FILE"
sudo chmod 644 "$WELCOME_FILE"


# ======== CONFIGURATION .bashrc ==============
BASHRC_FILE="/home/$username/.bashrc"
if ! grep -q "WELCOME.txt" "$BASHRC_FILE" 2>/dev/null; then
echo -e "\n# Message de bienvenue" | sudo tee -a "$BASHRC_FILE" > /dev/null
echo "if [ -f ~/WELCOME.txt ]; then" | sudo tee -a "$BASHRC_FILE" > /dev/null
echo "    cat ~/WELCOME.txt" | sudo tee -a "$BASHRC_FILE" > /dev/null
echo "fi" | sudo tee -a "$BASHRC_FILE" > /dev/null
fi
sudo chown "$username:$username" "$BASHRC_FILE"


# ======== INFORMATION DE CONTACT =============
log_message "Configuration des information de contact"
sudo chfn -f "$full_name" -w "$phone" -o "$email" "$username" 2>/dev/null || true


# ======== QUOTAS DISQUE (15 Go) ==============
log_message "Configuration des quotas disques (15 Go)"

# Activer les quotas sur le systeme si pas deja fait
if ! mount | grep -q "usrquota"; then
log_message "Activation des quotas sur le systeme..."
sudo quotacheck -cum / 2>/dev/null || true
sudoq quotaon / 2>/dev/null || true
fi

# Definir les quotas pour l'utilisateur
sudo setquota -u "$username" 15G 16G 0 0 / 2>/dev/null || \
log_message "Attention: quotas non configures(Necessite system de fichier avec quotas)"


# =========== LIMITES MEMOIRES (20% RAM) =============
log_message "Configuration limites memoire (20% RAM)"

#Creer un slice systemd pour l'utilisateur
SLICE_FILE="/etc/systemd/system/user-$username.slice"
sudo bash -c "cat > '$SLICE_FILE'" << SLICE_EOF
[Slice]
MemoryMax=20%
CPUQuota=100%
SLICE_EOF

sudo systemctl daemon-reload 2>/dev/null || true

log_message "Utilisateur $username configure avec succes"
echo "--------------------------------------"

done < "$USERS_FILE"

# ========== FIN DU SCRIPT =================
log_message "=== SCRIPT TERMINE ==="
log_message "Nombre d'utilisateurs traites: $user_count"
log_message "Groupe: $GROUP_NAME"
log_message "Fichier de log: $LOG_FILE"
log_message "Date de fin: $(date)"

echo ""
echo "Creation des utilisateurs terminee !"
echo "Consultez le fichier de log: $LOG_FILE"
echo "Utilisateur crees: $user_count"
echo "Groupes: $GROUP_NAME"
echo "Rendre le script executable avant de l'executer(chmod +x <nom_du_script>)"

