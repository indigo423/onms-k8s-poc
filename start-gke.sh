#!env bash
# @author Alejandro Galue <agalue@opennms.com>
#
# WARNING: For testing purposes only

set -e

PROJECT_ID="${PROJECT_ID-k8s-playground-334616}"
COMPUTE_ZONE="${COMPUTE_ZONE-us-east1-b}"
DOMAIN="${DOMAIN-k8s.agalue.net}"
GCP_NODE_COUNT="${GCP_NODE_COUNT-4}"
GCP_VM_SIZE="${GCP_VM_SIZE-n1-standard-4}"

gcloud config set project $PROJECT_ID
gcloud config set compute/zone $COMPUTE_ZONE

REGION="${COMPUTE_ZONE::-2}"
CHANNEL="regular"
VERSION=$(gcloud container get-server-config --region $REGION --format "value(channels[1].validVersions[0])")

echo "Starting Kubernetes version $VERSION"
gcloud container clusters create "$USER-opennms" \
  --addons=GcpFilestoreCsiDriver \
  --num-nodes=$GCP_NODE_COUNT \
  --cluster-version=$VERSION \
  --release-channel=$CHANNEL \
  --machine-type=$GCP_VM_SIZE

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud/deploy.yaml
kubectl wait pod -l app.kubernetes.io/component=controller --for=condition=Ready --timeout=300s -n ingress-nginx
