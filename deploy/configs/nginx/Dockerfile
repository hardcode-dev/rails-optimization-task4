
FROM nginx
LABEL maintainer="Taras Bilous <tbilous@gmail.com>"

VOLUME /etc/letsencrypt
EXPOSE 8080
EXPOSE 443
ARG CONFIG_FILE

# Do this apt/pip stuff all in one RUN command to avoid creating large
# intermediate layers on non-squashable docker installs
RUN apt update && \
    apt install -y python python-dev libffi6 libffi-dev libssl-dev curl build-essential && \
    curl -L 'https://bootstrap.pypa.io/get-pip.py' | python && \
    pip install -U cffi certbot && \
    apt remove --purge -y python-dev build-essential libffi-dev libssl-dev curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/letsencrypt/.well-known \
    && chgrp www-data /var/lib/letsencrypt \
    && chmod g+s /var/lib/letsencrypt

COPY configs/nginx.conf /etc/nginx/nginx.conf

COPY configs/${CONFIG_FILE} /etc/nginx/sites-enabled/${CONFIG_FILE}
COPY configs/letsencrypt.conf /etc/nginx/snippets/letsencrypt.conf
COPY configs/default.conf /etc/nginx/snippets/default.conf
COPY configs/default-no-key.conf /etc/nginx/default-no-key.conf
COPY configs/http.conf /etc/nginx/snippets/http.conf
COPY configs/https.conf /etc/nginx/snippets/https.conf


COPY ./docker-entrypoint.sh /
RUN chmod +x ./docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
