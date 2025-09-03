#!/bin/bash
#set -xe

# URL à tester
#URL="https://app1-int.petrolavera.com/api/v1/healthcheck"
# URL="http://100.100.58.149/api/v1/healthcheck"

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
  # Obtenir le temps de réponse
  response_time=$(curl -s -o /dev/null -w "%{time_total}" "$URL")
  echo "response_time : $response_time"

  # Accumuler le total et le maximum avec awk
  temps_total=$(awk -v rt="$response_time" -v total="$temps_total" 'BEGIN {printf "%.6f", total + rt}')
  temps_max=$(awk -v rt="$response_time" -v max="$temps_max" 'BEGIN {print (rt > max) ? rt : max}')
done

# Calculer la moyenne
moyenne=$(awk -v total="$temps_total" -v count="$NOMBRE_APPELS" 'BEGIN {printf "%.3f", total / count}')

echo "Temps de réponse moyen après $NOMBRE_APPELS appels : $moyenne secondes"
echo "Temps de réponse maximum : $temps_max secondes"
