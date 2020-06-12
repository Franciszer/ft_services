minikube config set vm-driver virtualbox
minikube stop
minikube delete
cd /goinfre
minikube delete
minikube config set vm-driver virtualbox
minikube delete
rm -rf ~/.minikube
mkdir -p /sgoinfre/goinfre/Perso/frthierr/.minikube
ln -sf /sgoinfre/goinfre/Perso/frthierr/.minikube ~/.minikube
docker-machine create --driver virtualbox default
docker-machine start

