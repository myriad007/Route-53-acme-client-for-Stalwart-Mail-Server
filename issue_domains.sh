#!/bin/bash
# Add or remove domains as needed
DOMAINS=(
  mail.domain.ca
  mail.domain2.ca
  mail.domain3.ca
  mail.domain4.com
  mail.domain5.com
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
