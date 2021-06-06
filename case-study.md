# Case-study

## Подготовка

Использовал:

- Newrelic
- Skylight
- rack-mini-profiler

## Оптимизация

Все инструменты мониторинга показывают, что самой горячей точкой является главная страница, `StoriesController#index`.

В частности, заметное время занимает рендеринг `partial`-ов `_single_story.html.erb`.
single_story

```
Benchmarking 127.0.0.1 (be patient).....done


Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        139635 bytes

Concurrency Level:      5
Time taken for tests:   0.676 seconds
Complete requests:      10
Failed requests:        0
Total transferred:      1401210 bytes
HTML transferred:       1396350 bytes
Requests per second:    14.79 [#/sec] (mean)
Time per request:       338.126 [ms] (mean)
Time per request:       67.625 [ms] (mean, across all concurrent requests)
Transfer rate:          2023.46 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:   118  239  77.1    260     349
Waiting:      117  227  79.5    246     347
Total:        118  239  77.1    260     349

Percentage of the requests served within a certain time (ms)
  50%    260
  66%    271
  75%    287
  80%    326
  90%    349
  95%    349
  98%    349
  99%    349
 100%    349 (longest request)
```

После кэширования story

```
Benchmarking 127.0.0.1 (be patient).....done


Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        137367 bytes

Concurrency Level:      5
Time taken for tests:   0.434 seconds
Complete requests:      10
Failed requests:        0
Total transferred:      1377900 bytes
HTML transferred:       1373670 bytes
Requests per second:    23.04 [#/sec] (mean)
Time per request:       217.055 [ms] (mean)
Time per request:       43.411 [ms] (mean, across all concurrent requests)
Transfer rate:          3099.69 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:    73  155  78.9    123     267
Waiting:       72  142  68.8    123     264
Total:         73  155  78.9    123     267

Percentage of the requests served within a certain time (ms)
  50%    123
  66%    144
  75%    264
  80%    267
  90%    267
  95%    267
  98%    267
  99%    267
 100%    267 (longest request)
```
