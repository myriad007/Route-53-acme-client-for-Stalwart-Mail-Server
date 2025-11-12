#!/bin/bash

DOMAINS=(
  mail.kampk.ca
  mail.sarahbrooks.ca
  mail.myriad.ca
  mail.triptychentertainment.com
  mail.triptychdesigns.com
)

for domain in "${DOMAINS[@]}"; do
  # Check if cert already exists (ECC or RSA)
  if [ -d "/root/.acme.sh/${domain}_ecc" ] || [ -d "/root/.acme.sh/${domain}" ]; then
    echo "Skipping $domain — cert already exists."
    continue
  fi

  echo "Issuing cert for $domain..."
  acme.sh --issue --dns dns_aws -d "$domain"
  sleep 60
done
