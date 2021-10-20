web: bin/rails s -e local_production -p 3000
job: bin/rake jobs:work
prometheus_exporter: bundle exec prometheus_exporter
