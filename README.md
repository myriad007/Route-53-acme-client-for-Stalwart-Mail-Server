# 📬 Route 53 ACME Client for Stalwart Mail

A lightweight, automation‑friendly ACME client that issues and deploys TLS certificates via **Route 53 DNS‑01 challenges** for **Stalwart Mail**. This project fills the gap while native Route 53 support is pending in Stalwart.

## 🧩 Why This Exists

Stalwart Mail currently lacks native integration with AWS Route 53 for ACME DNS‑01 challenges. This client automates:

- Certificate issuance via **acme.sh**
- DNS validation using **Route 53**
- Deployment of certificates to Stalwart Mail’s expected paths
- Filtering to only deploy certs for mail* domains
- Safe renewal via cron or container entrypoint

## ⚙️ Deployment Guide

### Step 1: Configure Paths

### - In your docker-compose.yml, map volumes:

```
- /docker/stalwart/opt/etc/certs:/etc/ssl/acme
- /docker/acme-client:/data
```
- Ensure `/docker/stalwart/opt/etc/certs` maps to Stalwart’s `/opt/etc/certs` directory.
- Both acme-client and stalwart containers must share this folder with read/write privileges.
- Copy all files from the acme-client directory (except the Dockerfile) into `/docker/acme-client`.
- Customize the provided scripts to include your domain(s).

### Step 2: Create your own ACME Client custom container
- Open the above dockerfile and customize all of the needed components and then build your custom container

### Step 3: Register Certificates in Stalwart

### - In the Stalwart UI, navigate to:
**Management → Settings → Certificate → Add Certificate**
- Add your domain’s certificate and private key:

```
%{file:/opt/stalwart/etc/certs/mail.domain.ca/fullchain.pem}%
%{file:/opt/stalwart/etc/certs/mail.domain.ca/privkey.pem}%
```
- This updates Stalwart’s `config.toml` automatically and persists across reboots.
- ⚠️ Avoid editing `config.toml` manually.
- 🔁 **Repeat this process for each additional domain** you want to secure (e.g., `mail.example.com`, `mail.anotherdomain.net`). Each domain will need its own certificate and private key entry.

### Step 4: Deploy your custom ACME Client container

- Start the **acme-client** container.
- It will issue certificates for your domains and copy them into /opt/etc/certs

## ✅ Notes

- Renewal is handled safely via cron or container entrypoint.
- Certificates are filtered to only deploy for mail* domains.
- Permissions must be correctly set for both containers to ensure smooth operation.

