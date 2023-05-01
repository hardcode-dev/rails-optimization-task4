.PHONY: test

# run:
# 	docker-compose build && docker-compose run --rm web rails db:setup

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

test:
	rake test:run

profile:
	bundle exec rspec --profile

test-event:
	EVENT_PROF='sql.active_record' bundle exec rspec
test-factory:
	EVENT_PROF='factory.create' bundle exec rspec
test-pro:
	FPROF='1' bundle exec rspec
test-doc:
	FDOC='1' bundle exec rspec

test-all: test-event test-factory test-pro
