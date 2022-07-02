## Подготовка

- [x] Завести `dev.to` локально (прямо в этом репозитории, не нужно клонировать `dev.to` от них, иначе будут отличаться версии)
- [ ] Настроить свой `NewRelic` для мониторинга локального `dev.to` (не работает отправка email)
- [x] Настроить свой `Skylight` / `Scout` / `Datadog` для мониторинга локального dev.to
- [x] Настроить свой `Prometheus` + `Grafana` для мониторинга локального `dev.to`
- [x] Настроить `rack-mini-profiler`
- [x] Настроить `rails-panel`
- [x] Сделать возможность запуска проекта в `local_production`

Инструменты мониторинга показывают, что точкой роста является главная страница, `StoriesController#index`.
В частности, заметное время занимает рендеринг `partial`-ов `_single_story.html.erb`.

## Решение

Закешировать каждую статью.

## Замеры

| Инструмент (`StoriesController#index`) | Было          | Стало         |
| -------------------------------------- | ------------- | ------------- |
| rack-mini-profiler                     | 335.0ms       | 114.4ms       |
| rails-console                          | 229ms         | 95ms          |
| skylight                               | 202ms / 960ms | 202ms / 412ms |

## AB Тестирование

### Было

```bash
Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        139595 bytes

Concurrency Level:      1
Time taken for tests:   15.113 seconds
Complete requests:      30
Failed requests:        19
   (Connect: 0, Receive: 0, Length: 19, Exceptions: 0)
Total transferred:      4219145 bytes
HTML transferred:       4187867 bytes
Requests per second:    1.99 [#/sec] (mean)
Time per request:       503.760 [ms] (mean)
Time per request:       503.760 [ms] (mean, across all concurrent requests)
Transfer rate:          272.63 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:    99  504 1399.4    118    5810
Waiting:       99  504 1399.4    118    5810
Total:         99  504 1399.4    118    5810

Percentage of the requests served within a certain time (ms)
  50%    118
  66%    152
  75%    159
  80%    170
  90%    258
  95%   5484
  98%   5810
  99%   5810
 100%   5810 (longest request)
```

### Стало

```bash
Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        141516 bytes

Concurrency Level:      1
Time taken for tests:   7.628 seconds
Complete requests:      30
Failed requests:        14
   (Connect: 0, Receive: 0, Length: 14, Exceptions: 0)
Total transferred:      4276741 bytes
HTML transferred:       4245465 bytes
Requests per second:    3.93 [#/sec] (mean)
Time per request:       254.271 [ms] (mean)
Time per request:       254.271 [ms] (mean, across all concurrent requests)
Transfer rate:          547.51 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:   198  254  52.6    250     380
Waiting:      197  254  52.6    250     379
Total:        198  254  52.6    251     380

Percentage of the requests served within a certain time (ms)
  50%    251
  66%    262
  75%    275
  80%    289
  90%    367
  95%    376
  98%    380
  99%    380
 100%    380 (longest request)
```

Итог: Ускорение загрузки в ~2 раза.
