#!/bin/bash
set -e

# Issue domains
/root/.acme.sh/deploy/issue_domains.sh

# Deploy certs after issuance
/root/.acme.sh/deploy/deploy_all_from_acme.sh

# Finally start cron in foreground
exec crond -f -l 5
