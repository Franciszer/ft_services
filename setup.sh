                                    # VARIABLES

# SETUP

minikube start --cpus=2 --memory 4000 --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000
minikube addons enable dashboard
minikube addons enable ingress
eval $(minikube docker-env)
kubectl apply -f srcs/nginx_setup.yml
kubectl apply -f srcs/ingress_setup.yml
kubectl apply -f srcs/WordPress/wordpress-deployment.yaml
kubectl apply -f srcs/MySQL/mysql-deployment.yaml

docker build -t nginx_alpine srcs/nginx