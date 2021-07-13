FROM debian:bullseye-slim 
RUN apt update && apt install -y apache2 apache2-utils
EXPOSE 80 
CMD ["apache2ctl", "-D" , "FOREGROUND"]
