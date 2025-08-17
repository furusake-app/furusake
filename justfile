WEB_DIR := 'web'
API_DIR := 'api'
MOBILE_DIR := 'mobile'
API_CLIENT_DIR := 'packages/api-client'

api:
    cd {{API_DIR}} && air -c .air.toml

web:
    cd {{WEB_DIR}} && pnpm dev

mobile:
    cd {{MOBILE_DIR}} && pnpm start

openapi:
    cd {{API_DIR}} && go run ./cmd/openapi/main.go

api-client:
    cd {{API_CLIENT_DIR}} && API_BASE_URL=http://localhost:8080 pnpm gen:watch

dev-web:
    bash -c '\
    set -eu; \
    (stdbuf -oL just api | sed "s/^/$(printf \"\\033[32m[API]\\033[0m \")/") & \
    (stdbuf -oL just web | sed "s/^/$(printf \"\\033[34m[WEB]\\033[0m \")/") & \
    (stdbuf -oL just api-client | sed "s/^/$(printf \"\\033[36m[API-CLIENT]\\033[0m \")/") & \
    trap "kill $$(jobs -pr)" EXIT; \
    wait'

dev-mobile:
    bash -c '\
    set -eu; \
    (stdbuf -oL just api | sed "s/^/$(printf \"\\033[32m[API]\\033[0m \")/") & \
    (stdbuf -oL just mobile | sed "s/^/$(printf \"\\033[35m[MOBILE]\\033[0m \")/") & \
    (stdbuf -oL just api-client | sed "s/^/$(printf \"\\033[36m[API-CLIENT]\\033[0m \")/") & \
    trap "kill $$(jobs -pr)" EXIT; \
    wait'
