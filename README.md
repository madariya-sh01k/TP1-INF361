# Partie 0: Procedure de modification du serveur SSH

## 1. Procedure Correcte pour modifier la configuration SSH

### Etapes a suivre :
1. **Sauvegarde** de la configuration actuelle :
```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup_$(date +%Y%m%d_%H%M%S)

2. Modification du fichier de configuration :
```bash
sudo nano /etc/ssh/sshd_config
# ou sudo vim /etc/ssh/sshd_config

3. Validation de la syntaxe avant redemarrage :
```bash
sudo sshd -t
# Si des erreurs s'affiche alors la syntaxe employer est incorrect

4. Redemarrage du service SSH :
```bash
sudo systemctl restart sshd

5. Test de la noouvelle configuration :
# Garder une session SSH ouverte
# Ouvrir une nouvelle session pour tester
ssh [username]@[adresse ip]


6. Verification du statut du service :
```bash
sudo systemctl status sshd


## 2. Risque principal si la procedure n'est pas respectee
-> Perte d'acces complet au serveur
-> Impossibilite de se connecter a distance
-> Temps d'indisponibilite prolonge
-> Risque de corruption de la configuration
Si on redemarre le service SSH sans valider la syntaxe(sshd -t), une erreur de configuration peut empecher le service de demarrer, comme SSH est le seul moyen d'acces distant, le serveur devient inacessible.


## 3. Parametre de securite SSH a modifier

a. Port :
Modifier le port permet d'eviter les scans automatiques sur le port 22 (port standard du protocol ssh), on peut par exemple le modifier pour le port 2222.

b. PermitRootLogin :
Modifier le PermitRootLogin pour empecher la connexion directe en root, elle oblige l'utilisation de sudo, assurant ainsi l'authentification.

c. PasswordAuthentication :
Modifier le PasswordAuthentication pour forcer l'utilisation des cles SSH qui sont plus securise.

d. MaxAuthTries :
Modifier le MaxAuthTries pour limiter le nombres de tentatives de connexion echouees.

e. ClientAliveInterval :
Modifier ce parametre afin de fermer les sessions inactives apres un certains temps.


