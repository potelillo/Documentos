mkdir # CREAR UNA CARPETA
nano # CREAR UN ARCHIVO
df -h # COMPROBAR ESPACIO DISPONIBLE EN LOS DISCOS
top -i # VER RECURSOS UTILIZADOS EN EL SISTEMA

# ---------------- COMPARTIR CARPETA EN UBUNTU CON SAMBA ---------------- # 

sudo nano /etc/samba/smb.conf ## aqui indicamos la carpeta que vamos a aÃ±adir
[raspberry]
   path=/home
   avaible = yes
   valid users = ubuntu
   write list = ubuntu
   writable = yes
   read only = no
   browsable = yes
chmod 0777 [CARPETA]
