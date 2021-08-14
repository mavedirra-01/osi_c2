FROM mavedirra/osiris:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y ssh rsync vim nano cron zsh tmux && service ssh start && mkdir -p /share/pentest
COPY backup.sh /bin/backup.sh
RUN crontab -l | { cat; echo "* * * * * root /bin/bash /bin/backup.sh"; } | crontab - && service cron start
