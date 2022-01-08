web: SEND_LOGS_TO_TIMBER=false LOCAL_PRODUCTION=true bin/rails s -p 3000 -e production
webpacker: ./bin/webpack-dev-server
job: bin/rake jobs:work
prometheus: bundle exec prometheus_exporter
