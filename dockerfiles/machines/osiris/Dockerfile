FROM mavedirra/osiris:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y neofetch wget kitty vim nano zsh openvpn tmux git
RUN runuser -l xuser -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
RUN chsh -s /usr/bin/zsh xuser
COPY .zshrc /home/xuser/.zshrc
RUN git clone https://github.com/stevemcilwain/quiver.git /home/xuser/.oh-my-zsh/custom/plugins/quiver &&  \
  git clone https://github.com/jhwohlgemuth/zsh-pentest.git /home/xuser/.oh-my-zsh/custom/plugins/zsh-pentest && \
  git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/xuser/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/xuser/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN echo "xuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir -p /home/xuser/.vpn/
COPY osiris.ovpn /home/xuser/.vpn/
RUN cd /home/xuser/ && git clone https://github.com/gpakosz/.tmux.git && ln -s -f .tmux/.tmux.conf && cp .tmux/.tmux.conf.local .
RUN runuser -l xuser -c 'curl -sLf https://spacevim.org/install.sh | bash'
COPY init.toml /home/xuser/.SpaceVim.d/init.toml
RUN chown -R xuser:xuser /home/xuser/
