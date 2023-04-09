.PHONY: run

run:
	docker-compose build && docker-compose run --rm web rails db:setup

siege:
	siege -c 10 -t180s http://localhost:3000

setup:
	bin/setup

dev:
	bin/startup

clean:
	bin/rails jobs:clear

lprod:
	RAILS_ENV=local_production bin/startup
