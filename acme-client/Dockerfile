FROM alpine:latest

LABEL maintainer="Richard Houghton"

# Install dependencies (bash included here, no need to repeat later)
RUN apk --no-cache add \
  curl \
  nano \
  socat \
  dcron \
  bash \
  openssl \
  dos2unix \
  tzdata

ENV VISUAL=nano

# Set timezone to America/Toronto
RUN cp /usr/share/zoneinfo/America/Toronto /etc/localtime && \
    echo "America/Toronto" > /etc/timezone

# Install acme.sh
RUN curl https://get.acme.sh | bash

# Symlink acme.sh
RUN ln -s /root/.acme.sh/acme.sh /usr/local/bin/acme.sh

# Acme account registration
RUN /root/.acme.sh/acme.sh --register-account -m noreply@myriad.ca

# Create log file for cron
RUN touch /var/log/cron.log

# Copy crontab file
COPY crontab /etc/crontabs/root
RUN dos2unix /etc/crontabs/root

# Copy deploy hooks
COPY deploy_all.sh /root/.acme.sh/deploy/deploy_all.sh
COPY deploy_all_from_acme.sh /root/.acme.sh/deploy/deploy_all_from_acme.sh
COPY issue_domains.sh /root/.acme.sh/deploy/issue_domains.sh

# Normalize line endings and ensure executability
RUN dos2unix /root/.acme.sh/deploy/deploy_all.sh && \
    dos2unix /root/.acme.sh/deploy/deploy_all_from_acme.sh && \
    dos2unix /root/.acme.sh/deploy/issue_domains.sh && \
    chmod +x /root/.acme.sh/deploy/deploy_all.sh \
             /root/.acme.sh/deploy/deploy_all_from_acme.sh \
             /root/.acme.sh/deploy/issue_domains.sh


# Remove ash history and configure bash defaults
RUN rm -rf /root/.ash_history
RUN mkdir -p /data && touch /data/.bash_history && \
    echo 'export HISTFILE=/data/.bash_history' >> /root/.bashrc && \
    echo 'export HISTFILESIZE=10000' >> /root/.bashrc && \
    echo 'export HISTSIZE=10000' >> /root/.bashrc && \
    echo 'export PROMPT_COMMAND="history -a; history -n"' >> /root/.bashrc

# Force Docker to use bash for subsequent RUN commands
SHELL ["/bin/bash", "-c"]

# Ensure cert directory exists
RUN mkdir -p /etc/ssl/acme

# Declare volumes
VOLUME ["/etc/ssl/acme"]
VOLUME ["/data"]

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Start cron in foreground
CMD ["crond", "-f", "-l", "5"]
