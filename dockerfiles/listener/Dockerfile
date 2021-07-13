FROM debian:bullseye-slim
RUN apt update && apt install -y netcat git python3 python3-pip && \
	git clone https://github.com/calebstewart/pwncat.git && cd pwncat && python3 setup.py install && pip install -U git+https://github.com/calebstewart/paramiko && pip install git+https://github.com/JohnHammond/base64io-python
COPY startpwncat.sh /usr/local/bin
RUN chmod +x /usr/local/bin/startpwncat.sh
