📬 Route 53 ACME Client for Stalwart Mail
A lightweight, automation-friendly ACME client that issues and deploys TLS certificates via Route 53 DNS-01 challenges for Stalwart Mail. This project fills the gap while native Route 53 support is pending in Stalwart.

🧩 Why This Exists

Stalwart Mail currently lacks native integration with AWS Route 53 for ACME DNS-01 challenges. This client automates:

Certificate issuance via acme.sh

DNS validation using Route 53

Deployment of certs to Stalwart Mail’s expected paths

Filtering to only deploy certs for mail* domains

Safe renewal via cron or container entrypoint
Build app
Go to root folder of project
Run scripts/prebuild.sh script
/bin/bash scripts/prebuild.sh
Build
iOS:
flutter build ios 
Android:
flutter build apk
Web:
change SERVER_URL in env.file with your JMAP server

SERVER_URL=http://your-jmap-server.domain
then run:

flutter build web
or you can find our images in: https://hub.docker.com/r/linagora/tmail-web
