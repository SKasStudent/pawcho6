# syntax=docker/dockerfile:1

FROM alpine AS builder
ARG VERSION

RUN apk add --no-cache git openssh-client

WORKDIR /app

RUN mkdir -p /root/.ssh && ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN --mount=type=ssh git clone git@github.com:SKasStudent/pawcho6.git .

RUN cat <<EOF > index.html
<html><body>
<h1>Informacje</h1>
<p>IP: _ip Hostname: _hostname Wersja: ${VERSION}</p>
</body></html>
EOF

FROM nginx:alpine
RUN apk add --no-cache curl

COPY --from=builder /app/index.html /usr/share/nginx/html/index.html

RUN cat <<'EOF' > /load_info.sh
#!/bin/sh
IP=$(hostname -i)
HOSTNAME=$(hostname)
awk -v ip="$IP" '{gsub(/_ip/,ip)}1' /usr/share/nginx/html/index.html > /tmp/index.html
awk -v hn="$HOSTNAME" '{gsub(/_hostname/,hn)}1' /tmp/index.html > /usr/share/nginx/html/index.html
rm /tmp/index.html
nginx -g "daemon off;"
EOF

RUN chmod +x /load_info.sh

CMD ["/load_info.sh"]

HEALTHCHECK CMD curl -f http://localhost || exit 1
