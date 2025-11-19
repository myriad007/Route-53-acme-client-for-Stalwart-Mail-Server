#!/bin/bash
ACME_DIR="/root/.acme.sh"
TARGET_BASE="/etc/ssl/acme"
LOGFILE="/var/log/deploy.log"

# Directories to ignore
IGNORE_DIRS="ca deploy dnsapi notify"

for domain_dir in "$ACME_DIR"/*/; do
  domain=$(basename "$domain_dir")

  # Skip ignored directories
  if echo "$IGNORE_DIRS" | grep -qw "$domain"; then
    continue
  fi

  # Strip _ecc suffix if present
  clean_domain=${domain%_ecc}

  echo "$(date '+%Y-%m-%d %H:%M:%S') Deploying cert for $clean_domain ..." >> "$LOGFILE"

  key="$domain_dir/$clean_domain.key"
  cert="$domain_dir/$clean_domain.cer"
  fullchain="$domain_dir/fullchain.cer"
  ca="$domain_dir/ca.cer"

  target="$TARGET_BASE/$clean_domain"
  mkdir -p "$target"

  # Copy only if newer
  if [ -f "$key" ]; then
    if [ ! -f "$target/privkey.pem" ] || [ "$key" -nt "$target/privkey.pem" ]; then
      cp -f "$key" "$target/privkey.pem"
      echo "  privkey.pem updated" >> "$LOGFILE"
    else
      echo "  privkey.pem skipped (up to date)" >> "$LOGFILE"
    fi
  fi

  if [ -f "$cert" ]; then
    if [ ! -f "$target/cert.pem" ] || [ "$cert" -nt "$target/cert.pem" ]; then
      cp -f "$cert" "$target/cert.pem"
      echo "  cert.pem updated" >> "$LOGFILE"
    else
      echo "  cert.pem skipped (up to date)" >> "$LOGFILE"
    fi
  fi

  if [ -f "$fullchain" ]; then
    if [ ! -f "$target/fullchain.pem" ] || [ "$fullchain" -nt "$target/fullchain.pem" ]; then
      cp -f "$fullchain" "$target/fullchain.pem"
      echo "  fullchain.pem updated" >> "$LOGFILE"
    else
      echo "  fullchain.pem skipped (up to date)" >> "$LOGFILE"
    fi
  fi

  if [ -f "$ca" ]; then
    if [ ! -f "$target/ca.pem" ] || [ "$ca" -nt "$target/ca.pem" ]; then
      cp -f "$ca" "$target/ca.pem"
      echo "  ca.pem updated" >> "$LOGFILE"
    else
      echo "  ca.pem skipped (up to date)" >> "$LOGFILE"
    fi
  fi
done
