WEB_DIR := 'web'
API_DIR := 'api'
MOBILE_DIR := 'mobile'

api:
    cd {{API_DIR}} && air -c .air.toml

web:
    cd {{WEB_DIR}} && pnpm dev

mobile:
    cd {{MOBILE_DIR}} && pnpm start

dev-web:
    #!/bin/bash -eu
    (stdbuf -oL just api | sed "s/^/$(printf '\033[32m[API]\033[0m ')/") &
    (stdbuf -oL just web | sed "s/^/$(printf '\033[34m[WEB]\033[0m ')/") &
    trap 'kill $(jobs -pr)' EXIT
    wait

dev-mobile:
    #!/bin/bash -eu
    (stdbuf -oL just api | sed "s/^/$(printf '\033[32m[API]\033[0m ')/") &
    (stdbuf -oL just mobile | sed "s/^/$(printf '\033[35m[MOBILE]\033[0m ')/") &
    trap 'kill $(jobs -pr)' EXIT
    wait