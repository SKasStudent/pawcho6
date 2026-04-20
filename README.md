# Projekt Docker - Laboratorium 6

## Opis

Projekt zawiera Dockerfile z Laboratorium 5, zmodyfikowany tak by pełnił role frontend'u dla silnika Buildkit i pozwalał pobrać zawartość repozytorium pawcho6

## Autor
Szymon Kasperczuk
Adres Email: s101587@pollub.edu.pl

## Wprowadzone modyfikacje

### Inicjalizacja git i openssh 
`RUN apk add --no-cache git openssh-client`

### Dodanie Github do known host
`RUN mkdir -p /root/.ssh && ssh-keyscan github.com >> /root/.ssh/known_hosts`

### Montowanie ssh i klonowanie
`RUN --mount=type=ssh git clone git@github.com:SKasStudent/pawcho6.git .`

## Wykorzystane polecenia

### Tworzenie repo za pomocą gh
```bash
gh repo create pawcho6 --public --source=. --remote=origin --push
```

### Zbudowanie
**Po zalogowaniu do ghcr.io i załadowaniu klucza do agenta ssh.** 
```bash
docker buildx build --ssh default=$SSH_AUTH_SOCK --build-arg VERSION=101.587 --tag ghcr.io/skasstudent/pawcho6:lab6 --push .
```

