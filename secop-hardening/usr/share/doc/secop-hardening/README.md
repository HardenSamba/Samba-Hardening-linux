# secop-hardening

Paquet de durcissement ANSSI BP-028 pour Debian et Ubuntu.

## Installation

    sudo apt install ./secop-hardening_0.1.0_all.deb

## Commandes

    secop-harden status    # configuration et fichiers en place
    secop-harden apply     # (re)genere et applique le durcissement
    secop-harden diff      # ecarts entre la cible et l'etat du noyau
    secop-harden revert    # retire les fichiers deposes

## Configuration

Tout se pilote depuis `/etc/secop/hardening.conf`, puis `secop-harden apply`.
Ce fichier est declare comme conffile : les modifications locales sont
conservees lors des mises a jour du paquet.

## Principe de conception

Le paquet ne modifie aucun fichier appartenant a un autre paquet. Il depose
uniquement des fichiers prefixes `99-secop-` dans les repertoires drop-in :

    /etc/sysctl.d/99-secop-anssi.conf
    /etc/modprobe.d/99-secop-anssi.conf
    /etc/ssh/sshd_config.d/99-secop-anssi.conf

Consequence : `apt remove` rend la machine a son etat anterieur, aux
parametres noyau deja appliques pres, qui necessitent un redemarrage.

## Perimetre de la version 0.1.0

Couvert : R6, R9, R11, R12, R14, R29, R32, R36, R38, R39, R40, R50, R58,
R63 (optionnel), R79 (SSH, optionnel).

Non couvert : R5 (GRUB), R28 (partitionnement), R31/R67/R68 (PAM),
R73 (auditd), R76 (AIDE), R37/R46 (MAC), R79 (nftables).

Le partitionnement et les options de montage ne peuvent pas relever d'un
paquet : ils se decident a l'installation du systeme et doivent etre portes
par le preseed de l'ISO.

## Role samba-ad-dc

Le profil `samba-ad-dc` corrige deux reglages incompatibles avec un
controleur de domaine : la plage de ports ephemeres, qui recouvrait la plage
RPC dynamique de Samba, et le durcissement ARP, qui perturbe la resolution
d'adresse.

Le referentiel de flux nftables pour un DC est fourni a titre de reference
dans `/usr/share/secop-hardening/profiles/nftables-samba-ad-dc.nft`. Il n'est
pas applique par le paquet.
