PHONY: start status connector-mysql-install connector-postgres-install stop clobber

# "topic.creation.default.partitions": 2 affects those topics prefixed with "topic.prefix".
# history topic is always 1 partition, probably taken from broker config

# Start all dependencies as local Docker containers using docker-compose.
start:
	docker-compose up -d

# Show the status of all running Docker containers
status:
	docker-compose ps

# Install the Debezium connector specified in your mysql-connector.json.
# If we already got a connector installed, it will be deleted first.
connector-mysql-install:
	http --quiet DELETE "localhost:8083/connectors/inventory-mysql-connector"
	curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @mysql-connector.json

connector-postgres-install:
	http --quiet DELETE "localhost:8083/connectors/inventory-postgres-connector"
	curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @postgres-connector.json

plugins-list:
	http GET "localhost:8083/connector-plugins"


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
	docker-compose logs -f connect

mysql:
	docker exec -it mysql mysql -u root -p inventory  #pw debezium

topics:
	docker exec -it kafka /kafka/bin/kafka-topics.sh --bootstrap-server kafka:9092 --list

offset-storage:
	docker exec -it kafka /kafka/bin/kafka-console-consumer.sh --topic my_offset_configs --bootstrap-server kafka:9092 --from-beginning

status-storage:
	docker exec -it kafka  /kafka/bin/kafka-console-consumer.sh --topic my_status_configs --bootstrap-server kafka:9092 --from-beginning

config-storage:
	docker exec -it kafka  /kafka/bin/kafka-console-consumer.sh --topic my_connect_configs --bootstrap-server kafka:9092 --from-beginning

describe-history:
	docker exec -it kafka  /kafka/bin/kafka-topics.sh \
		 --bootstrap-server kafka:9092 \
		 --describe \
		 --topic dbserver1.schema-changes.inventory

describe-customers:
	docker exec -it kafka  /kafka/bin/kafka-topics.sh \
		 --bootstrap-server kafka:9092 \
		 --describe \
		 --topic dbserver1.inventory.customers


delete-customers:
	docker exec -it kafka  /kafka/bin/kafka-topics.sh \
		 --bootstrap-server kafka:9092 \
		 --delete \
		 --topic order-planning-service.topo-integration.pqr.v1

describe-heartbeat:
	docker exec -it kafka  /kafka/bin/kafka-topics.sh \
		 --bootstrap-server kafka:9092 \
		 --describe \
		 --topic __debezium-hearbeat.dbserver1

create-topic:
	docker exec -it kafka  /kafka/bin/kafka-topics.sh \
		 --bootstrap-server kafka:9092 \
		 --create \
		  --replication-factor 1 \
		  --partitions 1 \
		  --topic order-planning-service.topo-integration.pqr.v1

consume-customers:
	docker exec -it kafka  /kafka/bin/kafka-console-consumer.sh \
		 --bootstrap-server kafka:9092 \
		 --from-beginning \
		 --topic order-planning-service.topo-integration.pqr.v1


# Delete all Docker containers.
clobber:
	docker-compose down
	$(shell docker volume ls  | docker volume rm)
	docker-compose rm
