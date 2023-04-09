.PHONY: run

run:
	docker-compose build && docker-compose run --rm web rails db:setup

siege:
	siege -c 10 -t180s http://localhost:3000

siege-short:
	siege -c 10 -t30s http://localhost:3000

setup:
	bin/setup

dev:
	bin/startup

clean:
	bin/rails jobs:clear

lprod:
	RAILS_ENV=local_production bin/startup

ab: siege-short
	sleep 5
	ab -n 100 http://127.0.0.1:3000/
