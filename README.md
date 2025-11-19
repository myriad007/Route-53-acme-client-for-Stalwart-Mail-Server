📬 Route 53 ACME Client for Stalwart Mail

A lightweight, automation-friendly ACME client that issues and deploys TLS certificates via Route 53 DNS-01 challenges for Stalwart Mail. This project fills the gap while native Route 53 support is pending in Stalwart.

🧩 Why This Exists

Stalwart Mail currently lacks native integration with AWS Route 53 for ACME DNS-01 challenges. This client automates:

Certificate issuance via acme.sh

DNS validation using Route 53

Deployment of certs to Stalwart Mail’s expected paths

Filtering to only deploy certs for mail* domains

Safe renewal via cron or container entrypoint

How to deploy

Step 1: Set up your paths in the Route 53 Acme-client using the docker-compose file's suggested format: - /docker/stalwart/opt/etc/certs:/etc/ssl/acme
        Make sure your folder is mapped to Stawarts "/opt/etc/certs" directory. See the stalwart folder's compose example, as the acme-client & stalwart            container need to be mapped to the same folder. Make sure you set the permissions on the two containers so they have r/w privileges. 
        The other path that needs to be mapped is: "/docker/acme-client:/data". Using Tiny File Manager, I copy all of the files in the acme-client                 directory (except the dockefile) to the "/docker/acme-client" folder. You will need to customize the scripts where indicated to add your domain(s).

Step 2: Deploy the acme-client container. It will issue your domain certs and copy them in the stalwart/opt/etc/certs directory.

Step 3: In the Stalwart UI go to: Management/settings/certificate and click "Add Certificate" And add your domains cert & privatekey info:
        %{file:/opt/stalwart/etc/certs/mail.domain.ca/fullchain.pem}%
        %{file:/opt/stalwart/etc/certs/mail.domain.ca/privkey.pem}%
        This will set up entries in Stalwart's config.toml and will survive reboots. I don't recommend editing the config manually.
