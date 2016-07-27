#!/bin/sh 
### Commande sauvegarde du dossier
## tar zcvf /home/pi/geopoppy.tar /home/GeoPoppy

### Commande de restauration du dossier
## tar xvfz /home/pi/geopoppy.tar --preserve --same-owner -C /
#___________________________________________________________________
# Commande d'installation
### wget -P /home/pirate wget https://raw.githubusercontent.com/jancelin/geo-poppy/master/install/auto_install_geopoppy.sh; chmod +x /home/pirate/auto_install_geopoppy.sh; bash -x /home/pirate/auto_install_geopoppy.sh

wget -P /home/pirate https://raw.githubusercontent.com/jancelin/rpi_wifi_direct/master/raspberry_pi3/install_wifi_direct_rpi3.sh; chmod +x /home/pirate/install_wifi_direct_rpi3.sh; bash -x /home/pirate/install_wifi_direct_rpi3.sh &&
mkdir /home/pi &&
wget -P /home/pi https://github.com/jancelin/geo-poppy/raw/master/install/geopoppy_sig.tar &&
wget -P /home/pi https://github.com/jancelin/geo-poppy/raw/master/install/geopoppy_base.tar &&
tar xvfz /home/pi/geopoppy_sig.tar --preserve --same-owner -C /  &&
tar xvfz /home/pi/geopoppy_base.tar --preserve --same-owner -C /  &&
cp /home/GeoPoppy/docker-compose.yml /home/pirate/ &&
docker-compose up -d &&
sleep 5
echo "Geopoppy redémare pour l'activation du wifi..."
echo "Connecter vous ensuite au réseau wifi GéoPoppy_Pi3"
echo "mot de passe: geopoppy"
echo " et tapper l'adresse 172.24.1.1 dans votre navigateur web"
sleep 2
reboot