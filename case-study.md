### Setup

Увидел в readme запуск через докер и решил юзать докер
поставил версию руби как в докерфайле

```
# gemfile
ruby "2.6.1"
```

поправил docker-compose

```yaml
DATABASE_URL: postgres://postgres:password@db:5432/postgres

db:
  image: postgres:9.6-alpine
  ports:
    - '5432:5432'
  environment:
    POSTGRES_PASSWORD: password
  volumes:
    - ./tmp/postgres_data:/var/lib/postgresql/data
```

###### дальше я добавил newrelic

```ruby
gem 'newrelic_rpm'
```

и добавил config/newrelic.yml

###### потом сконфигурировал skylight

```ruby
# application.rb
config.skylight.environments += %w[development]
```

`docker-compose exec web bundle exec skylight setup $MY_KEY`

###### добавил mini-profiler и rails-panel

##### добавил prometheus-exporter

```yaml
command: /bin/bash -c "
  [ "$RAILS_ENV" == "local_production" ] && bundle exec rake assets:precompile;
  rm -f /tmp/server.pid
  && bundle exec prometheus_exporter -b 0.0.0.0
  & bundle exec rails server -b 0.0.0.0 -P /tmp/server.pid
  "
```

###### добавил local_production

### Optimizing

в докере в девелопмент моде приложение страшно педалит

```shell script
Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        165340 bytes

Concurrency Level:      5
Time taken for tests:   66.037 seconds
Complete requests:      5
Failed requests:        0
Total transferred:      831920 bytes
HTML transferred:       826700 bytes
Requests per second:    0.08 [#/sec] (mean)
Time per request:       66037.014 [ms] (mean)
Time per request:       13207.403 [ms] (mean, across all concurrent requests)
Transfer rate:          12.30 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing: 16775 42749 14520.1  49244   49267
Waiting:    16770 42746 14521.1  49241   49264
Total:      16775 42749 14520.1  49244   49267

Percentage of the requests served within a certain time (ms)
  50%  49234
  66%  49254
  75%  49254
  80%  49267
  90%  49267
  95%  49267
  98%  49267
  99%  49267
 100%  49267 (longest request)
```

заглянув в skylight я увидел что в StoriesController#index
основное время тратится в `_single_story.html.erb`
(также сервис сообщает о n+1 и большом количестве аллокаций)

в newrelic - такая же ситуация

в local_production
все работает намного быстрее

```shell script
Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        141422 bytes

Concurrency Level:      5
Time taken for tests:   11.771 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      14184500 bytes
HTML transferred:       14142200 bytes
Requests per second:    8.50 [#/sec] (mean)
Time per request:       588.528 [ms] (mean)
Time per request:       117.706 [ms] (mean, across all concurrent requests)
Transfer rate:          1176.84 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:   164  558 312.3    514    2590
Waiting:      161  547 307.4    507    2544
Total:        164  558 312.3    515    2590

Percentage of the requests served within a certain time (ms)
  50%    515
  66%    577
  75%    613
  80%    667
  90%    817
  95%   1228
  98%   1633
  99%   2590
 100%   2590 (longest request)
```

после добавления кэша

```ruby
<% cache story do %>
  <%= render partial: "articles/single_story", locals: { story: story } %>
<% end %>
```

```shell script
Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        141470 bytes

Concurrency Level:      5
Time taken for tests:   10.506 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      14189300 bytes
HTML transferred:       14147000 bytes
Requests per second:    9.52 [#/sec] (mean)
Time per request:       525.304 [ms] (mean)
Time per request:       105.061 [ms] (mean, across all concurrent requests)
Transfer rate:          1318.93 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:   166  467 200.3    441    1378
Waiting:      159  454 198.2    428    1375
Total:        166  467 200.3    441    1378

Percentage of the requests served within a certain time (ms)
  50%    441
  66%    502
  75%    587
  80%    620
  90%    745
  95%    814
  98%   1054
  99%   1378
 100%   1378 (longest request)
```

добавление кэша помогло :)

### Выводы

мне понравился skylight очень удобный сервис и ab
я потренировался настраивать мониторинг
