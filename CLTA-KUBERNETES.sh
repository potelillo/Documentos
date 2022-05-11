# CHULETA PARA KUBERNETES

# ---------------- DESPLIEGUE KUBER, PASOS ---------------- #

# 1. LO PRIMERO QUE VAMOS A HACER ES GENERAR UNA CLAVE RSA
 -> sudo ssh-keygen 

# 2. COPIAMOS LAS CLAVES EN CADA NODO QUE DISPONGAMOS

 -> sudo ssh-copy-id root@ipServidor 
# 3. DESCARGAMOS KUBERNETES Y DAMOS PERMISOS (HACE TAMBIEN DIRECTORIO PARA KUBER)
 -> sudo wget https://github.com/k0sproject/k0sctl/releases/download/v0.8.4/k0sctl-linux-x64 && mv k0sctl-linux-x64 k0sctl && chmod 777 k0sctl

# 4. GENERAMOS EL FICHERO DE CONFIGURACION Y LO METEMOS EN UN ARCHIVO .YAML
    # EN ESTE FICHERO CONFIGURAREMOS LOS NODOS DISPONIBLES (ESTABLECEMOS DIRECCION IP PUBLICA Y ROL DEL NODO)
 -> sudo ./k0sctl init > k0sctl.yaml 
    # ASI SE VERIA EL ARCHIVO DE CONFIGURACION DE NUESTRO KUBERNETES, CON DOS NODOS:
apiVersion: k0sctl.k0sproject.io/v1beta1
kind: Cluster
metadata:
    name: <nombreCluster>
spec:
  hosts:
  - ssh:
      address: <IP publica NODO 1>
      user: <Usuario para el acceso remoto> # root
      port: <puerto> # 22
      keyPath: <Directorio de la clave RSA>
    role: <controller+worker> # rol que va a realizar el nodo en cuestion
  - ssh:
      address: <IP publica NODO 1>
      user: <Usuario para el acceso remoto> # root
      port: <puerto> # 22
      keyPath: <Directorio de la clave RSA>
    role: <worker> # rol que va a realizar el nodo en cuestion

# 5. AHORA LO QUE HAREMOS SERA DESPLEGAR O INSTALAR KUBERNETES EN NUESTRO CLUSTER
 -> sudo ./k0sctl apply --config k0sctl.yaml
    # CON SOLO ESTE COMANDO YA TENDRIAMOS KUBERNETES EN NUESTROS NODOS

# 6. GENERAMOS LA CONFIGURACION A UN FICHERO PROPIO
 -> sudo ./k0sctl kubeconfig > kubeconfig

# 7. EXPORTAMOS LA VARIABLE DE ENTORNO KUBECONFIG CON LA RUTA DE NUESTRO FICHERO DE CONFIGURACION DEL PASO ANTERIOR
 -> sudo export KUBECONFIG=/home/usuario/kubeconfig # o la ruta en la que se encuentre
    # AHORA PODREMOS LANZAR COMANDOS PARA OBTENER INFORMACION O HACER CUALQUIER COSA CON NUESTRO CLUSTER

# ---------------- PODS ---------------- #

# UN POD ES LO MINIMO QUE PODEMOS DESPLEGAR EN KUBERNETES, TENDRA UNA 
# UNICA DIRECCION IP, PUEDE TENER UNO O VARIOS CONTENEDORES

# PARA CREAR EL POD HAREMOS LO SIGUIENTE:
 -> nano nombreApp.yml

# DENTRO DEL FICHERO ESCRIBIREMOS:
apiVersion: v1 # Version de la api

kind: Pod # El tipo de objeto que vamos a crear, en este caso un pod

metadata:
  name: <nombrePod> # Nombre para nuestro objeto
  labels: # Etiquetas con informacion para encontrar nuestro pod
    app: web

spec: # Aqui sera donde expecifiquemos lo que va a haber en nuestro pod
  containers:
    - name: <nombreContenedor> # Especificamos el nombre del contenedor
      image: <imagenContenedor> # La imagen de nuestro contenedor, ej. httpd:latest 
      ports: 
        - containerPort: 80 # Especificamos el puerto, aunque es solo informativo

    - name: <nombreContenedor> # Asi desplegamos otro contenedor en el mismo pod
      image: <imagenContenedor>
      command: ["/bin/sh"] # Podemos desplegar una maquina de ubuntu que ejecute X comando
      args: []  
      ports: 
        - containerPort: 80 

# DESPLEGAR Y APLICAR LOS CAMBIOS DE NUESTRO POD
 -> kubectl apply -f nombreApp.yml

# ---------------- NAME-SPACES ---------------- #

# IMAGINEMOS QUE TENEMOS UNA SEGUNDA APLICACION, CON LOS ESPACIOS DE NOMBRES,
# SEPARAREMOS LOS PODS QUE TENGAMOS USANDO ESTE METODO

# PARA CREAR UN ESPACIO DE NOMBRES EJECUTAREMOS LO SIGUIENTE:
 -> kubectl create namespace <nombre>

# CUANDO LEVANTAMOS EL POD, LE ASIGNAMOS EL ESPACIO DE NOMBRES
 -> kubectl apply -f pod.yml --namespace=<nombre>

# PARA FILTRAR POR ESPACIO DE NOMBRE, TENDREMOS DOS FORMAS
 -> kubectl config set-context -current --namespace=<nombre> 
    # De esta manera cuando ejecutemos cualquier comando para obtener informacion,
    # solo veremos info con lo que haya bajo ese espacio de nombre 
 -> kubectl get all --namespace=<nombre>
    # O directamente en el comando que ejecutemos, establecemos el filtro del namespace
    # en concreto para que unicamente nos salga lo relacionado con este mismo

# ---------------- SERVICIOS ---------------- #

# CON LOS SERVICIOS DAREMOS VISIBILIDAD A NUESTROS PODS, TANTO DENTRO COMO FUERA DE NUESTRA APP
# ESTOS NOS CONCEDEN UNA IP, BALANCEO DE CARGA, NOS OFRECEN EL ACCESO AL SERVICIO A TRAVES DE UN NOMBRE
# TENEMOS TRES TIPOS DE SERVICIOS:
#   - CLUSTER IP: ESTE SERVICIO UNICAMENTE LE DA VISIBILIDAD AL POD DENTRO DEL CLUSTER DE KUBERNETES
#   - NODE PORT: VISIBILIDAD DENTRO DEL CLUSTER, Y CONCEDE UN PUERTO PARA QUE LA APP SEA VISIBLE DESDE FUERA
#   - LOAD-BALANCER: NOS CONCEDE UNA IP PUBLICA (SOLO DISPONIBLES EN CLOUD PUBLICOS)
# PARA CREAR UN SERVICIO, NOS IREMOS AL ARCHIVO .YML DONDE TENGAMOS EL POD CON LOS CONTENEDORES, DEBAJO, AÑADIREMOS
# LO SIGUIENTE, LA ESTRUCTURA SERA SIMILAR:

[..Desc Pod..]
---
apiVersion: v1

kind: Service

metadata:
  name: servicio1

spec:
  type: NodePort # Aqui especificaremos de que va a ser el servicio, con los tipos explicados arriba
  selector: # En el selecctor introduciremos las etiquetas que hemos establecido antes para nuestro pod, para asi enlazarlo
    app: web
  ports:
    - protocol: TCP
      port: 80 # El puerto en cuestion
      targetPort: 80 # El puerto donde va a apuntar

# Despues de hacer los cambios hay que volver a hacer el apply del fichero .yml de nuestro pod

# ---------------- CREAR EL DEPLOYMENT ---------------- #

# LO QUE HARA ESTE METODO SERA ESCALAR NUESTROS PODS, O LEVANTARLOS AUTOMATICAMENTE EN CASO DE PERDIDA
# PARA HACER UN DEPLOYMENT TENDREMOS QUE MODIFICAR EL ARCHIVO .yml DE NUESTRA APLICACION, NOS TENDRA
# QUE QUEDAR DE LA SIGUIENTE MANERA:
apiVersion: apps/v1 

kind: Deployment

metadata:
  name: <nombreDeployment> 
  labels: 
    app: web

spec:
  replicas: 2 # El numero de replicas del deployment

  selector:
    matchLabels:
      app: web # Enlazar con las etiquetas

  template: # Descripcion de los contenedores, como creando el pod
    metadata:
      labels:
      app: web
    
    spec:
      containers:
          - name: <nombreContenedor> 
          image: <imagenContenedor> 
          ports: 
              - containerPort: 80 

          - name: <nombreContenedor> 
          image: <imagenContenedor>
          command: ["/bin/sh"] 
          args: []  
          ports: 
              - containerPort: 80 
---
apiVersion: v1 # El apartado de los servicios lo dejamos igual

kind: Service

metadata:
  name: servicio1

spec:
  type: NodePort 
  selector: 
    app: web
  ports:
    - protocol: TCP
      port: 80 
      targetPort: 80  

# UNA VEZ HECHO EL ARCHIVO VOLVEMOS A HACER EL APPLY

# ---------------- CREAR EL STATEFULSET ---------------- #

# ESTE METODO LO USAREMOS PARA QUE HAYA UN ORDEN EN NUESTROS PODS
# AL IGUAL QUE LOS DEPLOYMENT, LOS PODS Y DEMAS, DEFINIREMOS UN ARCHIVO .yml
# QUE CONTENGA LOS SERVICIOS INDICADOS, LOS CONTENEDORES Y TODO LO QUE VIENE 
# SIENDO NUESTRA APP, LO DEPPLEGAMOS CON EL APPLY, Y CON ESTO TENDRIAMOS TODO ORDENADO,
# Y TENDRIAMOS NUMERADOS LOS PODS ACTIVOS

apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: nginx-statefulset
  labels:
    app: nginx
spec:
  serviceName: nginx-service
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
          - containerPort: 80

# COMO SIEMPRE, SE HACE EL APPLY DESPUES DE MODIFICAR

# ---------------- VOLUMENES ---------------- #

# LOS VOLUMENES NOS SERAN UTILES PARA NO PERDER INFORMACION, YA QUE LOS CONTENEDORES
# PUEDEN TENER POCA VIDA UTIL, ENTONCES PERDERIAMOS LA INFORMACION,
# LO MAS COMUN EN PRODUCCION ES USAR UN SERVIDOR NFS, PERO TAMBIEN TENEMOS
# LA OPCION DE USAR NUESTRA MAQUINA LOCAL, AUNQUE SOLO PARA FORMACION
# AL ARCHIVO DE NUESTRA APP .yml TENDRIAMOS QUE AÑADIR LO SIGUIENTE:

apiVersion: v1
kind: Pod
metadata:
  name: test-pd
  labels:
    app: test-app

spec:
  containers:
  - image: nginx
    name: test-container
    volumeMounts:
    - mountPath: "/usr/share/nginx/html" # Indicamos el volumen
      name: host-volume

  volumes:
#  - name: empty-volume --> Directorio vacio
#    emptyDir: {} 
#  - name: host-volume --> Para almacenar la informacion en la maquina local
#    hostPath:
#      path: /home/docker/html
#      type: Directory
  - name: nfs-volume # --> Servidor en red
      nfs: 
        server: 10.108.211.244 # Nuestro servidor NFS
        path: / # La ruta

  
---
Servicio...

# ---------------- VOLUMENES PERSISTENTES ---------------- #

# ESTO NOS VA A PERMITIR QUE EL ADMINISTRADOR DESTINE UN VOLUMEN DONDE ALMACENAR ARCHIVOS
# NOS PERMITIRA AÑADIR REGLAS COMO SI QUEREMOS QUE EL ESPACIO SEA DE LECTURA, O SIMPLEMENTE
# SOLO DE ESCRITURA, O ESCRITURA Y LECTURA
 
apiVersion: v1 # ESTE SERÁ EL PRIMER OBJETO QUE CREEMOS INDEPENDIENTE DEL POD
kind: PersistentVolume
metadata:
  name: pv0002
spec:
  capacity:
    storage: 0.2Gi # Almacenamiento disponible
  accessModes:
    - ReadWriteOnce # Modo de Acceso, Lectura/Escritura
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: standard
  hostPath: # Donde se va a almacenar la informacion, podemos poner un directorio remoto como vemos abajo
      path: /home/docker/html
      type: Directory
#  nfs: 
#    server: 10.108.211.244 
#    path: / 

---
apiVersion: v1
kind: PersistentVolumeClaim # PARA PODER SOLICITAR ESPACIOS PARA ALMACENAR INFORMACION, LO QUE SE VA A REQUERIR PARA LA APP
metadata:
  name: claim-1 # Nomber
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 0.2Gi # El espacio solicitado
---
apiVersion: v1 # NUESTRA APP
kind: Pod
metadata:
  name: task-pv-pod
  labels:
    app: test-app

spec:
  volumes:
    - name: task-pv-storage
      persistentVolumeClaim:
        claimName: claim-1 # El volumen persistente solicitado, en este caso claim-1
  containers:
    - name: task-pv-container
      image: nginx
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/usr/share/nginx/html" # El volumen del contenedor
          name: task-pv-storage
---
Servicios..

# ---------------- INGRESS ---------------- #

# INGRESS NOS PROPORCIONARA EL SERVICIO DE ENRUTAMIENTO, SI DISPONEMOS DE VARIOS PODS
# PODEMOS CONFIGURAR RUTAS POR SI TENEMOS NUESTRA APLICACION DIVIDIDA EN MICROSERVICIOS
# POR EJEMPLO, IMAGINEMOS QUE TENEMOS DOS PODS, UNO CON UN SERVIDOR WEB DE NGINX, Y OTRO 
# CON APACHE, GENERAREMOS UN INGRESS QUE ENCAMINE EL TRAFICO QUE VAYA HACIA CADA SERVER,
# TENDREMOS QUE ENLAZAR LA RUTA CON EL NOMBRE DEL SERVICIO DE CADA SERVIDOR:

apiVersion: v1                      # TENEMOS EL POD DE NGINX
kind: Pod
metadata:
  name: test-pd1              
  labels:
    app: test-nginx                 # LA ETIQUETAS

spec: 
  containers:
  - image: nginx                    # EL CONTENEDOR
    name: test-container1
---
apiVersion: v1                      # TAMBIEN TENDREMOS EL SERVIDOR DE APACHE
kind: Pod
metadata:
  name: test-pd2
  labels:
    app: test-apache

spec:
  containers:
  - image: httpd
    name: test-container2
---
apiVersion: v1                      # EL SERVICIO DE NGINX
kind: Service
metadata:
  name: nginx1                      # NOMBRE DEL SERVICIO
spec:
  type: NodePort
  selector:
    app: test-nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
---
apiVersion: v1                      # EL SERVICIO DE APACHE
kind: Service
metadata:
  name: apache1                     # NOMBRE DEL SERVICIO
spec:
  type: NodePort
  selector:
    app: test-apache
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
---
apiVersion: networking.k8s.io/v1    # TENEMOS NUESTRO INGRESS  
kind: Ingress
metadata:
  name: ingress1
spec:
  rules:
  - http:
      paths:
      - path: /nginx
        pathType: Prefix
        backend:
          service:
            name: nginx1            # ENLAZAMOS EL SERVICIO DE NGINX CON SU RUTA CORRESPONDIENTE
            port: 
              number: 80
      - path: /apache
        pathType: Prefix
        backend:
          service:
            name: apache1           # ENLAZAMOS EL SERVICIO DE APACHE CON SU RUTA CORRESPONDIENTE
            port: 
              number: 80

# ---------------- DAEMONSETS ---------------- #

# ESTO SERA UN TIPO DE OBJETO ENCARGADO DE MANTENER EL POD DESPLEGADO EN CADA
# NODO DEL CLUSTER, TAMBIEN PODREMOS ESPECIFICAR EN QUE TIPO DE NODOS, ESTO 
# NOS OFRECE LA POSIBILIDAD DE NO TENER PORQUE SABER CUANTOS NODOS HAY EN NUESTRO 
# CLUSTER, SI AÑADIMOS UN NUEVO NODO, DAEMON SE ENCARGARA DE DESPLEGAR EL POD EN 
# ESTE NODO NUEVO, ESTE METODO NO ES ACONSEJABLE PARA GESTIONAR LA ESCALABILIDAD
# DE LA APLICACION, LO CONFIGURAMOS DE LA SIGUIENTE MANERA:

apiVersion: apps/v1 
kind: DaemonSet
metadata:
  name: daemonset-pods

spec:
  selector:
    matchLabels:
      name: daemonset-pods
  template:
    metadata:
      labels:
        name: daemonset-pods
    spec:
      containers:
        - name: test1
          image: nginx

# ---------------- COMANDOS DE UTILIDAD KUBERNETES ---------------- #

# OBTENER INFORMACION NODOS, SERVICIOS, PODS
 -> kubectl get nodes
    # NOS MOSTRARA NOMBRE, ESTADO, ROL, TIEMPO ACTIVO Y VERSION
 -> kubectl cluster-info
    # MAS INFORMACION DE NUESTRO CLUSTER
 -> kubectl descibe node <nombreNodo>
    # MAS INFORMACION SOBRE UN NODO EN CONCRETO, LOGS, USO DE RECURSOS, INFO DEL EQUIPO O SISTEMA...
 -> kubectl top node <nombreNodo>
    # MAS INFO SOBRE LOS RECURSOS UTILIZADOS EN EL NODO
 -> kubectl get all
    # VER INFORMACION DE TODOS NUESTROS PODS Y SERVICIOS
 -> kubectl get pods 
    # VER INFORMACION DE LOS PODS
 -> kubectl describe pod <nombrePod> # El nombre que hemos establecido en los metadatos, no el nombre del fichero
    # OBTENER INFORMACION DE UN POD ESPECIFICO
 -> kubectl top pod <nombrePod>
    # MAS INFO DE NUESTRO POD
 -> kubectl logs <nombrePod> -c <nombreContenedor> 
    # VER LOS LOGS DE UN  POD, ESPECIFICAREMOS EL CONTENEDOR EN EL CASO DE QUE TENGAMOS VARIOS EN EL MISMO POD
 -> kubectl get namespaces
    # VER LOS ESPACIOS DE NOMBRES QUE TENEMOS DISPONIBLES

# MARCAR UN NODO COMO NO PLANIFICABLE
 -> kubectl uncordon <nombreNodo>
    # SI EN ALGUN MOMENTO QUEREMOS PARAR EL NODO PARA SACARLO DE PRODUCCION 
    # Y QUE EL MANAGER NO LE MANDE CARGA DE TRABAJO

# DRENAR UN NODO DE LA CARGA DE TRABAJO
 -> kubectl drain <nombreNodo>

# ABRIR UN TERMINAL EN UN CONTENEDOR DE UN POD
 -> kubectl exec <nombrePod> -it -c <nombreContenedor> /bin/bash

# PASAR FICHEROS DE UNA MAQUINA LOCAL A UN CONTENEDOR [REVISAR]
 -> kubectl  cp /directorioOrigen pod:/rutaContenedor <nombrePod> -c <nombreContenedor>

# MAPEAR UN PUERTO CON UN POD (NO SE USA EN PRODUCCION YA QUE PARA ESO EXISTEN LOS SERVICIOS)
 -> kubectl port-forward -address 0.0.0.0 pod/<nombrepod> <puerto:puerto> # Ej. 8080:80

# ESCALAR UN DEPLOYMENT YA CREADO
 -> kubectl scale --replicas <numReplicas> deployment/<nombreDeploy>

