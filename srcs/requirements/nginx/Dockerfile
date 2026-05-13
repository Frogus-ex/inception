FROM debian:bookworm

RUN apt-get update -y && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

# -x509: certificat auto-signé
# -nodes: pas de mot de passe sur la clé
# -out / -keyout: où enregistrer les fichiers
# -subj: les infos du certificat
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=tlorette.42.fr/UID=tlorette"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
