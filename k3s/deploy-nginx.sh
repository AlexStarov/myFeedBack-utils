#!/bin/bash

# mkdir -p ~/.kube
# sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
# sudo chown $USER:$USER ~/.kube/config
# sudo chmod 600 ~/.kube/config

# Явно указываем путь к конфигу, чтобы kubectl не пытался читать системный файл root-а
export KUBECONFIG=$HOME/.kube/config

K8S_DIR="/home/ubuntu/FeedBack/k3s"
CERTS_DIR="/home/ubuntu/FeedBack/certs/ua.pp.feedback-app"
PORTAINER_DIR="/home/ubuntu/FeedBack/portainer"

# Проверяем наличие kubectl
if ! command -v kubectl &> /dev/null
then
    echo "kubectl не найден. Убедитесь, что Kubernetes (K3s) установлен и настроен."
    exit 1
fi

echo "Создание или обновление секретов..."
# Создаем секрет для SSL сертификатов
kubectl create secret tls feedback-app-certs \
  --cert="${CERTS_DIR}/fullchain.pem" \
  --key="${CERTS_DIR}/key.pem" \
  --dry-run=client -o yaml | kubectl apply -f -

# Создаем секрет для Basic Auth (.htpasswd)
kubectl create secret generic nginx-basic-auth \
  --from-file=.htpasswd="${PORTAINER_DIR}/.htpasswd" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Применение Kubernetes манифестов для Nginx..."
kubectl apply -f "${K8S_DIR}/nginx-configmap.yaml"
kubectl apply -f "${K8S_DIR}/nginx-deployment.yaml"
kubectl apply -f "${K8S_DIR}/nginx-service.yaml"

echo "Развертывание Nginx завершено."