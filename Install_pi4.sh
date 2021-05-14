#!/bin/bash

###############################################################################################
# ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗                       #
# ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗                      #
# ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝                      #
# ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗		      #	
# ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║		      #
# ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝	by lolo ~#    #
#											      #
# Ce script permet d'installer et de configurer automatiquement un RaspberryPi4 sous Raspbian #
# après usage de ce script, xFreeRDP sera installé et configuré.                              #
# Le Raspberry sera lui configuré sans les GL drivers (Legacy),				      #							
# ce qui aura pour effet de ne plus avoir de "lags" durant la connexion au serveur RDP.       #
#											      #			
# Note : Le code de ce script est détaillé si besoin.					      #	
###############################################################################################

######### Variables #########

# Clear du terminal
CL="clear"

# Jaune début
J="\e[1;33m"

# Rouge début
R="\e[1;31m"

# Vert début
V="\e[1;32m"

# Cyan début
C="\e[36m"

# Fin de la couleur
FC="\e[0m"

# N'importe quelle touche
ASIQT="Appuyez sur "$J"quelle touche$FC pour continuer.."

# Selection Oui / Non
ON="("$V"Oui"$FC"/"$R"Non"$FC")\n"

# Pas besoin de réponse
PDR="read -n 1"

# Chemins pour les configurations
CONFIG=/boot/config.txt

######### Fonctions #########

# Fait !
function fait
{
	$CL
	echo -e $V"Fait !"$FC
	sleep 1
	$CL
}

######### Début du script #########

$CL

echo -e $ASIQT
$PDR

$CL

echo -e "Configuration du "$R"Raspberry"$FC"..."
sleep 1
echo -e "Modification des "$J"paramètres graphiques.."$FC
sleep 1
echo -e "Passage sur le mode "$J"Legacy"$FC"..."
sleep 1

# Modification du fichier boot.txt "/usr/share/X11/xorg-conf.d/boot.txt
# Commente les lignes suivantes :
# dtoverlay=vc4-kms-v3d
# dtoverlay=vc4-fkms-v3d
sudo sed $CONFIG -i -e "s/^dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/g"
sudo sed $CONFIG -i -e "s/^dtoverlay=vc4-fkms-v3d/#dtoverlay=vc4-fkms-v3d/g"
sudo sed $CONFIG -i -e "s/^gpu_mem=64/gpu_mem=256/g"

echo -e "Les "$Y"'GL DRIVERS'"$FC" sont maintenant "$R"desactivé"$FC
sleep 2

fait

echo -e "Voulez-vous configurer le "$R"Raspberry "$FC"pour avoir 2 écrans ?"
echo -e ""
echo -e $R"⚠ ATTENTION ⚠\nUne fois configuré, ne fonctionnera uniquement avec les deux écrans branchés.\nVoulez-vous donc avoir la configuration pour 2 écrans ?"$FC
echo -e $ON

read rep

# Si l'utilisateur entre oui -> le script va configurer un fichier .conf qui permettra au Raspberry de prendre en compte les deux sorties HDMI
# Sinon -> poursuite du script
# Le fichier "60-dualscreen.conf" se trouvera dans : /usr/share/X11/xorg.conf.d/ et sera sous permissions ROOT.
if [ $rep = "oui" ] || [ $rep = "Oui" ] || [ $rep = "o" ] || [ $rep = "O" ]; then
	$CL
	echo -e "Copie du fichier "$C"'60-dualscreen.conf'"$FC" dans "$J"'/usr/share/X11/xorg.cong.d"$FC"..."
	sleep 2
# Si dessous, le contenu du fichier "60-dualscreen.conf"
	sudo cp /media/pi/SCRIPT-PI4/60-dualscreen.conf /usr/share/X11/xorg.conf.d/60-dualscreen.conf
fi

$CL
fait

echo -e $C"Installation de"$FC $J"xFreeRDP"$FC"..."
sudo apt install freerdp2-x11 -y

fait

echo -e "Ajout du script "$C"'Serveur.sh'"$FC $J"\n/home/$USER/Desktop"$FC
sleep 2

# Permet au script d'initialiser les options suivantes :
# /d: [Nom de domaine]
# /u: [Nom utilisateur]
# /p: [Mot de passe]
# /v: [Adresse IP]
echo -n -e "Veuillez entrer un "$R"nom de domaine : "$FC
read domain

echo -n -e "Veuillez entrer un "$R"login : "$FC
read user

echo -n -e "Veuillez entrer le "$R" mot de passe : "$FC
read mdp

echo -n -e "Veuillez entrer "$R"l'adresse IP : "$FC
read IP

# Contenu du fichier "Serveur.sh"
echo "xfreerdp /f /sec:rdp /d:$domain /u:$user /p:$mdp /drive:USB,/media/pi/ /sound:sys:alsa,format:1,quality:high /rfx /gfx /gfx-h264 /multitransport /network:auto -bitmap-cache -glyph-cache /gdi:hw -fonts /v:$IP /multimon:force" >> /home/pi/Desktop/Serveur.sh

fait

echo -e "Modification des "$J"droits d'accès"$FC".."
sleep 2

# Chemin d'entrée pour le srcipt "Serveur.sh"
# Modification des droits d'accès : 
# a+x = Modification par le créateur du fichier et lecture et execution par tout le monde
cd /home/pi/Desktop/
chmod a+x Serveur.sh

fait

echo -e $V"Tout est installé !"$FC
sleep 2

$CL
echo -e "Afin d'appliquer tout les changements, il est "$V"conseillé"$FC" de "$J"redémarrer"$FC" le "$R"Raspberry"$FC
echo -e "Voulez-vous "$J"reboot"$FC" ?\n"
echo -e $ON
read reb

# Si l'utilisateur entre "oui" alors le Raspberry reboot
# Sinon fermeture du script
if [ $reb = "oui" ] || [ $reb = "Oui" ] || [ $reb = "O" ] || [ $reb = "o" ]; then
	$CL
	echo -e $V"Au revoir !"$FC
	sleep 1
	sudo reboot -f
else
	$CL
	echo -e "Pensez quand même à "$J"reboot !"$FC
	sleep 2
	$CL
	exit
fi

######### FIN DU SCRIPT ########
