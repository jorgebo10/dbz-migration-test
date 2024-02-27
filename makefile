PHONY: start status install check-dependencies stop clobber

# Start all dependencies as local Docker containers using docker-compose.
start:
	docker-compose up -d --build

# Show the status of all running Docker containers
status:
	docker-compose ps

# Install the Debezium connector specified in your connector.yaml.
# If we already got a connector installed, it will be deleted first.
connector-install: connector.yaml check-dependencies
	http --quiet DELETE "localhost:8083/connectors/$$(yaml2json connector.yaml | jq -r .name)"
	yaml2json connector.yaml | http --headers --check-status POST :8083/connectors

plugins-list: check-dependencies
	http GET "localhost:8083/connector-plugins"

connector-get:
	http GET "localhost:8083/connectors/$$(yaml2json connector.yaml | jq -r .name)"

connector.yaml:
	@echo >&2 "ERROR: missing $@. Please manually copy one of the connector_example*.yaml files"; exit 1

# Check we have all CLI applications installed.
check-dependencies:
	@type http >/dev/null 2>&1 || { echo >&2 "ERROR: You need to install Httpie. Please visit https://httpie.io/cli"; exit 1; }
	@type docker-compose >/dev/null 2>&1 || { echo >&2 "ERROR: You need to install docker-compose"; exit 1; }
	@type yaml2json >/dev/null 2>&1 || { echo >&2 "ERROR: You need to install yaml2json. Please run go install github.com/fgrosse/yaml2json@latest"; exit 1; }
	@type jq >/dev/null 2>&1 || { echo >&2 "ERROR: You need to install jq. Please visit https://stedolan.github.io/jq/"; exit 1; }

# Stop all running containers
stop:
	docker-compose stop

connect-logs:
	docker-compose logs -f kafka-connect

mysql:
	docker exec -it mysql mysql -u mysqluser -p inventory

topics:
	docker exec -it kafka kafka-topics --bootstrap-server localhost:9092 --list

history:
	docker exec -it kafka kafka-console-consumer --topic inventory --from-beginning --bootstrap-server localhost:9092 --from-beginning

schema-changes:
	docker exec -it kafka kafka-console-consumer --topic schema-changes.inventory --from-beginning --bootstrap-server localhost:9092 --from-beginning

payment-method:
	docker exec -it kafka kafka-console-consumer --topic kafka-connect-automation.cloudcomms.inventory.payment_method --from-beginning --bootstrap-server kafka:9092 --from-beginning



# Delete all Docker containers.
clobber:
	docker-compose down
	$(shell docker volume ls  | docker volume rm)
	docker-compose rm
