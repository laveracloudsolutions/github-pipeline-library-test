#!/bin/bash
#set -xe

# Usage Exemple:
# ./http-get-response-time.sh "https://app1-int.petrolavera.com/api/v1/healthcheck"
# ./http-get-response-time.sh "https://app1-stg.petrolavera.com/api/v1/healthcheck"
# ./http-get-response-time.sh "http://localhost:8080/api/v1/healthcheck"

# Check Parameters
if [[ $# -lt 1 ]] ; then
    echo "Usage: $0 <site-url>"
    exit 1
fi
URL=$1

# Nombre d'appels
NOMBRE_APPELS=20
# Initialisation des variables
total_time=0
max_time=0
echo "Test de l'URL: $URL"

for ((i=1; i<=NOMBRE_APPELS; i++))
do
  # Obtenir le temps de réponse et le code HTTP
  response=$(curl -s -o /dev/null -w "%{http_code} %{time_total}" "$URL")

  # Extraire le code HTTP et le temps
  http_code=$(echo "$response" | awk '{print $1}')
  response_time=$(echo "$response" | awk '{print $2}')

  # Vérifier si le code HTTP est 200
  if [ "$http_code" -ne 200 ]; then
    echo "Réponse HTTP inattendue : $http_code. Arrêt du script."
    exit 1
  fi

  # Accumuler le total et le maximum avec awk
  echo "response_time : $response_time"
  temps_total=$(awk -v rt="$response_time" -v total="$temps_total" 'BEGIN {printf "%.6f", total + rt}')
  temps_max=$(awk -v rt="$response_time" -v max="$temps_max" 'BEGIN {print (rt > max) ? rt : max}')
done

# Calculer la moyenne
moyenne=$(awk -v total="$temps_total" -v count="$NOMBRE_APPELS" 'BEGIN {printf "%.3f", total / count}')

echo "Temps de réponse moyen après $NOMBRE_APPELS appels : $moyenne secondes"
echo "Temps de réponse maximum : $temps_max secondes"
