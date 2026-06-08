# Variáveis de Build
GIT_COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
BUILD_TIME := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
# Ajuste o caminho abaixo para o seu repositório real
LDFLAGS := -X github.com/brunocdti/animal-wiki/internal/version.Commit=$(GIT_COMMIT) \
           -X github.com/brunocdti/animal-wiki/internal/version.BuildTime=$(BUILD_TIME)

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^## //p' ${MAKEFILE_LIST} | column -t -s '|' | sed -e 's/^/ /'

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

# ----- DEVELOPMENT -------------------------------------------------------------------- #

## setup: install all the development tools needed
.PHONY: setup
setup:
	@echo 'Installing development tools...'
	CGO_ENABLED=0 go install github.com/vektra/mockery/v2@latest
	CGO_ENABLED=0 go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	CGO_ENABLED=0 go install github.com/pressly/goose/v3/cmd/goose@latest
	CGO_ENABLED=0 go install github.com/air-verse/air@latest
	CGO_ENABLED=0 go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest

## run: run the application with hot reload (Air)
.PHONY: run
run:
	air

## tidy: tidy and verify module dependencies
.PHONY: tidy
tidy:
	@echo 'Tidying module dependencies...'
	go mod tidy
	go mod verify

# ------ DATABASE ---------------------------------------------------------------------- #

# Atalho para extrair a string de conexão direto do .env sem falhas no Windows
DB_URL_RECOVERY = $(shell grep DATABASE_URL .env | cut -d '=' -f2-)

## db/migrations/new name=$1: create a new database migration (ex: make db/migrations/new name=add_animals)
.PHONY: db/migrations/new
db/migrations/new:
	@echo 'Creating migration files for ${name}...'
	goose -dir internal/db/migrations create ${name} sql

## db/migrations/up: apply all database migrations to Neon cloud
.PHONY: db/migrations/up
db/migrations/up: confirm
	@echo 'Running up migrations...'
	goose -dir internal/db/migrations postgres "$(DB_URL_RECOVERY)" up

## db/migrations/down: roll back the last database migration
.PHONY: db/migrations/down
db/migrations/down: confirm
	@echo 'Rolling back the last migration...'
	goose -dir internal/db/migrations postgres "$(DB_URL_RECOVERY)" down
	
# ----- QUALITY CONTROL ---------------------------------------------------------------- #

## audit: run quality control checks (lint, vet, tests)
.PHONY: audit
audit:
	@printf '\033[1;34m==> [1/3] Go Vet\033[0m\n'
	go vet ./...
	@printf '\033[1;34m==> [2/3] Golangci-lint\033[0m\n'
	golangci-lint run
	@printf '\033[1;34m==> [3/3] Tests\033[0m\n'
	@if [ -f .env ]; then set -a && . ./.env && set +a; fi; \
	go test -race -parallel 5 ./...

# ------ TESTS & COVERAGE -------------------------------------------------------------- #

## test/coverage: run tests and generate HTML coverage report
.PHONY: test/coverage
test/coverage:
	@if [ -f .env ]; then set -a && . ./.env && set +a; fi; \
	go test -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out

## test/%: run tests in a specific internal directory (ex: make test/core)
.PHONY: test/%
test/%:
	@if [ -f .env ]; then set -a && . ./.env && set +a; fi; \
	go test -v ./internal/$*