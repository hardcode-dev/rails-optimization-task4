# Case-study

## Подготовка

1. Завел `dev.to` локально
2. Настроил инструменты мониторинга:
  - `NewRelic`
  - `Skylight`
  - `Prometheus` + `Grafana`
  - `rack-mini-profiler`
  - `rails-panel`
3. Настроил `local_production`

## Оптимизация

Рассмотрим гипотезу о том, что можно закешировать `<%= render "articles/single_story", story: story %>` в `_main_stories_feed.html.erb`.

### До оптимизации
```
Concurrency Level:      8
Time taken for tests:   17.478 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      13691100 bytes
HTML transferred:       13645700 bytes
Requests per second:    5.72 [#/sec] (mean)
Time per request:       1398.210 [ms] (mean)
Time per request:       174.776 [ms] (mean, across all concurrent requests)
Transfer rate:          764.99 [Kbytes/sec] received

Connection Times (ms)
min  mean[+/-sd] median   max
Connect:        0    0   0.2      0       1
Processing:   605 1370 245.7   1376    1819
Waiting:      595 1360 242.5   1366    1817
Total:        605 1370 245.6   1376    1819

Percentage of the requests served within a certain time (ms)
50%   1376
66%   1480
75%   1553
80%   1590
90%   1700
95%   1774
98%   1818
99%   1819
100%   1819 (longest request)
```

### После оптимизации

```
Concurrency Level:      8
Time taken for tests:   4.836 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      13696100 bytes
HTML transferred:       13650700 bytes
Requests per second:    20.68 [#/sec] (mean)
Time per request:       386.843 [ms] (mean)
Time per request:       48.355 [ms] (mean, across all concurrent requests)
Transfer rate:          2766.00 [Kbytes/sec] received

Connection Times (ms)
min  mean[+/-sd] median   max
Connect:        0    0   0.2      0       1
Processing:   132  380 110.0    372     661
Waiting:      127  373 109.0    365     652
Total:        132  381 110.0    372     661

Percentage of the requests served within a certain time (ms)
50%    372
66%    403
75%    463
80%    477
90%    551
95%    593
98%    636
99%    661
100%   661 (longest request)
```

### Выводы

Гипотеза оказалась верна, производительность значительно улучшилась(более чем в 3 раза).
