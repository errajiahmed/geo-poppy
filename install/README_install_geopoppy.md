""Géopoppy""


* télécharge l'os (hypriot Barbossa 0.8.0) : https://downloads.hypriot.com/hypriotos-rpi-v0.8.0.img.zip
* dézip sur ton bureau
* insère ta sd dans le pc
* repère tes partitions et démonte:

```
df-h
umount /dev/mmcblk0p1
umount /dev/mmcblk0p2
sudo dd bs=1M if=/home/jancelin/Bureau/hypriotos-rpi-v0.8.0.img of=/dev/mmcblk0
```

* agrandir la partition avec gparted

----------------------

* insère la sd dans le raspberry
* connecte l'ethernet
* allume.
* connecte toi en ssh (attention l'utilisateur à changé):

```
ssh pirate@"ton ip"
```

mot de passe: hypriot

------------------------
* maintenant passe en root

```
sudo -s
```

* et lance la commande:

```
wget -P /home/pirate wget https://raw.githubusercontent.com/jancelin/geo-poppy/master/install/auto_install_geopoppy.sh; chmod +x /home/pirate/auto_install_geopoppy.sh; bash -x /home/pirate/auto_install_geopoppy.sh
```

c'est fini, un message à la fin (env 30 min) te dira:

"Geopoppy redémare pour l'activation du wifi..."

"Connecter vous ensuite au réseau wifi GéoPoppy_Pi3"

"mot de passe: geopoppy"

" et tapper l'adresse 172.24.1.1 dans votre navigateur web"

puis le raspberry redémarera.

________________________________________________________________________________

si pas de service ... 

* connecte toi en ssh
* lance un:

```
docker-compose up -d
```

et tes conteneur se refabriquerons automatiquement.

_________________________________________________________________________________

Liste des améliorations de GéoPoppy

* utilisation de la dernière version d'Hypriot OS: "Barbossa"
* utilisation du wifi interne au raspberry pi 3
* si il est connecté en ethernet il fait borne wifi ouverte sur le web.
* il contiens l'arborescence de fichier necessaire au fonctionnement de postgresql/postgis et qgis-serveur/lizmap
* il contiens une base de donnée et un projet démo carto pour tester les fonctionalités
* il utilise Docker-compose qui permet d'orchestrer ses conteneur grâce à un fichier .yml situé dans /home/pirate
* ...

Amuszez vous bien. et faites remonter les bug...



