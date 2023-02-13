top -i                 # VER RECURSOS UTILIZADOS EN EL SISTEMA
mdir                   # CREAR UNA CARPETA
nano                   # CREAR UN ARCHIVO
clear                  # LIMPIAR LA PANTALLA
history                # 500 ULTIMOS COMANDOS INTRODUCIDOS
cd                     # MOVERSE ENTRE DIRECTORIOS
ls                     # LISTAR UN DIRECTORIO
pwd                    # MUESTRA EL DIRECTORIO ACTUAL
rm                     # BORRAR ARCHIVO
rmdir                  # BORRAR UN DIRECTORIO
rmdir -r               # BORRAR UN DIRECTORIO CON ARCHIVOS O DIRECTORIOS DENTRO
tree                   # MUESTRA EL ARBOL DE DIRECTORIOS
cat                    # VISUALIZAR UN ARCHIVO
nano                   # VISUALIZAR Y EDITAR UN ARCHIVO
cp or-des              # COPIAR UN ARCHIVO O DIRECTORIO
mv or-des              # MOVER UN ARCHIVO, O CAMBIARLE EL NOMBRE
chmod                  # CAMBIAR PERMISOS
chmod -R               # PERMISOS RECURSIVOS (A TODOS LOS DIRECTORIOS)
grep                   # BUSCAR OCURRENCIAS
grep -v                # BUSCAR OCURRENCIAS Y QUITARLAS AL IMPRIMIRLAS POR PANTALLA
whoami                 # VER CON QUE USUARIO ESTAMOS TRABAJANDO
df -BM                 # VER ALMACENAMIENTO DISPONIBLE
/etc/init.d/ssh start  # INICIAR SERVICIO SSH
awk                    # OBTENER, MOSTRAR Y DIVIDIR CADENAS (SEMEJANTE A LA FUNCION SPLIT)
ls -lh                 # MIRAR DIRECTORIOS CON EL TAMAÑO QUE OCUPAN
pkginfo| grep tar      # COMPROBAR VERSION DEL TAR SOLARIS
pkginfo -l SUNWgtar    # COMPROBAR VERSION DEL TAR SOLARIS
tr -d "\n\r" < salida.txt > salida2.txt # ELIMINAR SALTOS DE LINEA
while IFS= read -r line; do echo $line"-"; done < maquinas.txt > salida.txt # LEER FICHERO Y FORMATEAR TEXTO

# ---------------- COMANDOS UNIX/LINUX CURRO ---------------- # 

sh recuento_maquinas_v2.sh |grep -v "=" | grep -v "-" | grep -v ^$|awk '{ print $0".*,"}'
# Obtener máquinas con formato para lanzar ejecución en ansible


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

# ---------------- ESTABLECER IP ESTATICA EN UBUNTU 20 ---------------- # 

sudo nano /etc/netplan/00-installer-config.yaml

# ARCHIVO:

network:
  version: 2
  renderer: networkd
  ethenets:
    enp0s3:
      dhcp4: false
      dhcp6: false
      addresses:
       - 192.168.1.54
      routes:
       - to: default
         via: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8]
        
sudo netplan apply

# ----------------  INSTALAR AQUA TRIVY EN UBUNTU 20  ---------------- # 

sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
