top -i      # VER RECURSOS UTILIZADOS EN EL SISTEMA
mdir        # CREAR UNA CARPETA
nano        # CREAR UN ARCHIVO
clear       # LIMPIAR LA PANTALLA
history     # 500 ULTIMOS COMANDOS INTRODUCIDOS
cd          # MOVERSE ENTRE DIRECTORIOS
ls          # LISTAR UN DIRECTORIO
pwd         # MUESTRA EL DIRECTORIO ACTUAL
rm          # BORRAR ARCHIVO
rmdir       # BORRAR UN DIRECTORIO
rmdir -r    # BORRAR UN DIRECTORIO CON ARCHIVOS O DIRECTORIOS DENTRO
tree        # MUESTRA EL ARBOL DE DIRECTORIOS
cat         # VISUALIZAR UN ARCHIVO
nano        # VISUALIZAR Y EDITAR UN ARCHIVO
cp or-des   # COPIAR UN ARCHIVO O DIRECTORIO
mv or-des   # MOVER UN ARCHIVO, O CAMBIARLE EL NOMBRE
chmod       # CAMBIAR PERMISOS
chmod -R    # PERMISOS RECURSIVOS (A TODOS LOS DIRECTORIOS)
grep        # BUSCAR OCURRENCIAS
whoami      # VER CON QUE USUARIO ESTAMOS TRABAJANDO
df -BM      # VER ALMACENAMIENTO DISPONIBLE



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

chmod 777 [CARPETA] # PERMISOS A LA CARPETA
smbpasswd -a [nombre-usuario] # GENERAMOS LA CLAVE PARA EL USUARIO

# ---------------- INSTALACION DOCKER - DOCKER COM 2022 ---------------- # 

sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce

sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose



