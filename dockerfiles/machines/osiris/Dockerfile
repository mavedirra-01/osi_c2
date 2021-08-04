FROM docker.io/linuxserver/webtop:ubuntu-xfce
RUN apt update
RUN echo 'deb https://http.kali.org/kali kali-rolling main non-free contrib' > /etc/apt/sources.list.d/kali.list
RUN apt install -y net-tools rofi vim conky inetutils-ping aptitude gnupg wget && \
      wget -q -O - https://archive.kali.org/archive-key.asc | apt-key add && \
      echo 'Package: *'>/etc/apt/preferences.d/kali.pref; echo 'Pin: release a=kali-rolling'>>/etc/apt/preferences.d/kali.pref; echo 'Pin-Priority: 50'>>/etc/apt/preferences.d/kali.pref
RUN apt update && aptitude install -y -t kali-rolling nikto wpscan gobuster metasploit-framework netcat unicorn powershell-empire nmap seclists
