start-postgres:
	docker compose --env-file development.env -f docker-postgres-compose.yml up -d

stop-postgres:
	docker compose --env-file development.env -f docker-postgres-compose.yml down

build-local:
	docker build -t nest-fly-deploy .

start-local:
	docker build -t nest-fly-deploy .
	docker compose --env-file development.env -f docker-postgres-compose.yml up -d
	docker run --name nestjs-fly-local -d --env-file docker.env  -p 3001:3000 nest-fly-deploy

clean-local:
	docker container stop nestjs-fly-local
	docker container rm nestjs-fly-local
	docker compose --env-file development.env -f docker-postgres-compose.yml down

start-app:
	docker compose --env-file docker.env up -d

stop-app:
	docker compose --env-file docker.env up -d


