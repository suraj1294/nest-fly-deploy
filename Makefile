start-postgres:
	docker compose --env-file development.env -f docker-postgres-compose.yml up -d

stop-postgres:
	docker compose --env-file development.env -f docker-postgres-compose.yml down

build-local:
	docker build -t nest-fly-deploy .

start-dev:
	docker compose -f docker-compose-developer.yml up --build

start-app:	
	docker compose up --build -d

stop-app:
	docker compose down -d


