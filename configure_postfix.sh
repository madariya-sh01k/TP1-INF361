#!/bin/bash
# Configuration minimale de Postfix pour envoi local

# Configurer Postfix pour le mode local seulement
sudo postconf -e "myhostname = tp-inf361.local"
sudo postconf -e "mydestination = localhost.localdomain, localhost"
sudo postconf -e "inet_interfaces = loopback-only"
sudo postconf -e "mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128"

# Redémarrer Postfix
sudo systemctl restart postfix

echo "Postfix configuré pour envoi local"
