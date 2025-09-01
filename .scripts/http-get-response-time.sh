#!/bin/bash
#set -xe

# URL à tester
#URL="https://app1-int.petrolavera.com/api/v1/healthcheck"
URL="http://100.100.58.149/api/v1/healthcheck"

# Nombre d'appels
NOMBRE_APPELS=200
# Initialisation des variables
total_time=0
max_time=0

for ((i=1; i<=NOMBRE_APPELS; i++))
do
  # Mesurer le temps de réponse en secondes
  response_time=$(curl -s -o /dev/null -w "%{time_total}" "$URL")

  # Ajouter le temps à la somme
  total_time=$(echo "$total_time + $response_time" | awk '{printf "%.6f", $0 + $1}')

  # Vérifier si c'est le maximum
  comparison=$(echo "$response_time > $max_time" | awk '{print ($0 ? 1 : 0)}')
  if [ "$comparison" -eq 1 ]; then
    max_time=$response_time
  fi
done

# Calcul du temps moyen
moyenne=$(echo "$total_time / $NOMBRE_APPELS" | awk '{printf "%.3f", $0}')

echo "Temps de réponse moyen après $NOMBRE_APPELS appels : $moyenne secondes"
echo "Temps de réponse maximum : $max_time secondes"