FROM mavedirra/osiris:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y vim nano zsh tmux git
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN chsh -s /usr/bin/zsh xuser
RUN git clone https://github.com/stevemcilwain/quiver.git /home/xuser/.oh-my-zsh/custom/plugins/quiver &&  \
git clone https://github.com/jhwohlgemuth/zsh-pentest.git ${ZSH_CUSTOM:-/home/xuser/.oh-my-zsh/custom}/plugins/zsh-pentest
RUN sed -i "s/quiver nmap zsh-pentest/git/;s/dpoggi/bobbyrussel/" /home/xuser/.zshrc
RUN chown -R xuser:xuser /home/xuser
