# Case-study

## Подготовка

- Поставил нужную версию ноды
- Завел `dev.to` локально
- Настроил `NewRelic`
- Настроил `Skylight`
- Не стал настраивать `Prometheus` + `Grafana` т.к. использую их в рабочем проекте
- Настроил `rack-mini-profiler`
- Настроил `rails-panel`
- Сделал возможность запуска проекта в `local_production`

### local_production

- Настроил энвайронмент local_production согласно рекомендациям в Readme

## Оптимизация

Рассмотрим гипотезу о том, что можно закешировать `<%= render "articles/single_story", story: story %>` в `_main_stories_feed.html.erb` и это даст заметный эффект.

### До оптимизации

Time taken for tests: 2.112 seconds
Complete requests: 50
Failed requests: 0
Total transferred: 6980100 bytes
HTML transferred: 6958950 bytes
Requests per second: 23.68 [#/sec](mean)
Time per request: 42.234 [ms](mean)
Time per request: 42.234 [ms] (mean, across all concurrent requests)
Transfer rate: 3227.98 [Kbytes/sec] received

Connection Times (ms)
min mean[+/-sd] median max
Connect: 0 0 0.0 0 0
Processing: 34 42 8.9 38 66
Waiting: 34 42 8.9 38 66
Total: 35 42 8.9 38 66

Percentage of the requests served within a certain time (ms)
50% 38
66% 40
75% 42
80% 44
90% 60
95% 63
98% 66
99% 66
100% 66 (longest request)

### После оптимизации

Time taken for tests: 1.283 seconds
Complete requests: 50
Failed requests: 0
Total transferred: 6982500 bytes
HTML transferred: 6961350 bytes
Requests per second: 38.98 [#/sec](mean)
Time per request: 25.657 [ms](mean)
Time per request: 25.657 [ms] (mean, across all concurrent requests)
Transfer rate: 5315.33 [Kbytes/sec] received

Connection Times (ms)
min mean[+/-sd] median max
Connect: 0 0 0.0 0 0
Processing: 20 26 7.1 24 55
Waiting: 20 25 7.1 24 53
Total: 20 26 7.1 24 55

Percentage of the requests served within a certain time (ms)
50% 24
66% 26
75% 26
80% 27
90% 28
95% 46
98% 55
99% 55
100% 55 (longest request)

### Выводы

Видно, что гипотеза была верна и производительность значительно увеличилась
Дополнительно гипотезу подтверждает NewRelic, который показывал что время обработки паршала занимает 22% времени от рендера страницы
