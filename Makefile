include .env
export

export PROJECT_ROOT=$(CURDIR)# <(shell pwd)> if using Ubuntu WSL
export MSYS_NO_PATHCONV=1 # Prevents path conversion issues on Windows when using Docker

env-up:
	@docker compose up -d todoapp-postgres

env-down:
	docker compose down todoapp-postgres

env-cleanup:
	@read -p "This will remove all data in the database. Are you sure? (y/n) " ans; \
	if [ "$$ans" = "y" ]; then \
		docker compose down todoapp-postgres && \
		rm -rf out/pgdata && \
		echo "Environment cleaned up."; \
	else \
		echo "Cleanup aborted."; \
	fi

env-port-forward:
	@docker compose up -d port-forwarder

env-port-close:
	@docker compose down port-forwarder

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Error: Migration name is required. Usage: make migrate-create seq=<migration_name>"; \
		exit 1; \
	fi; \

	@docker compose run --rm todoapp-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"
	
migrate-up:
	@make migrate-action action=up

migrate-down:
	@make migrate-action action=down

migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "Error: Action is required. Usage: make migrate-action action=<up|down>"; \
		exit 1; \
	fi; \

	@docker compose run --rm todoapp-postgres-migrate \
		-path /migrations \
		-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@todoapp-postgres:5432/${POSTGRES_DB}?sslmode=disable \
		"$(action)"

todoapp-run:
	@export LOGGER_FOLDER=${PROJECT_ROOT}/out/logs && \
	go mod tidy && \
	go run cmd/todoapp/main.go