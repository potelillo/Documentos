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
chmod 0777 [CARPETA]
