web: rake assets:precompile && RAILS_ENV=local_production bin/rails s -p 3000
webpacker: ./bin/webpack-dev-server
job: bin/rake jobs:work
