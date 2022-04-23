git init # INICIALIZAMOS EL DIRECTORIO
git add . # AÑADIMOS LOS ARCHIVOS
git commit -m "mensaje" # HACEMOS EL COMMIT
git config --global user.email "email@email" # AÑADIMOS EL MAIL (SOLO INFO)
git config --global user.name "Pepe" # AÑADIMOS EL NOMBRE DEL AUTOR (SOLO INFO)
sudo git config --global github.token # AÑADIR EL TOKEN
sudo git config --global --add safe.directory /home/DOCUMENTOS # HACER EL DIRECTORIO SEGURO
git branch -M main
git remote add origin https://github.com/usuario/repo.git # AÑADIMOS EL REPOSITORIO REMOTO
git push -u origin main # SUBIMOS LOS ARCHIVOS AL REPOSITORIO
git remote remove origin # ELIMINAR REPOSITORIO REMOTO