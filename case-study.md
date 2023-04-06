## Цели

- Попрактиковаться в настройке мониторинга
- Попрактиковаться в поиске возможностей для оптимизации

- Попрактиковаться в проверке гипотез и обосновании предложений по оптимизации
- Познакомиться с интересным живым Rails open-source проектом

## Настройка систем профилирования

- Подключил NewRelic
- Подключил Skylight
- Подключил Prometheus + Grafana

- Настроил rack-mini-profiler
- Настроил rails-panel

## Настройка local_production окружения

Добавил новый environment profile - для профилирования в среде максимально приближенной к Production

## Нагрузочное тестирование

Для проверки гипотиз и выстраивания максимально эффективного фидбэк лупа benchmark осуществлял при помощи утилиты ApacheBench.

## Оптимизация

Все инструменты мониторинга показывают, что самой горячей точкой является главная страница, StoriesController#index.

В частности, заметное время занимает рендеринг partial-ов \_single_story.html.erb.

Статистика 200 запросов в ab:

```Benchmarking 127.0.0.1 (be patient)
Completed 100 requests
Completed 200 requests
Finished 200 requests


Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        142263 bytes

Concurrency Level:      5
Time taken for tests:   10.545 seconds
Complete requests:      200
Failed requests:        0
Total transferred:      28537200 bytes
HTML transferred:       28452600 bytes
Requests per second:    18.97 [#/sec] (mean)
Time per request:       263.633 [ms] (mean)
Time per request:       52.727 [ms] (mean, across all concurrent requests)
Transfer rate:          2642.73 [Kbytes/sec] received

Connection Times (ms)
min  mean[+/-sd] median   max
Connect:        0    0   0.4      0       3
Processing:    84  258  92.6    260     536
Waiting:       84  247  89.2    246     498
Total:         85  258  92.6    260     536

Percentage of the requests served within a certain time (ms)
50%    260
66%    301
75%    328
80%    339
90%    378
95%    412
98%    455
99%    489
100%    536 (longest request)
```

Скрин NewRelic до оптимизации: https://disk.yandex.ru/i/ocwtqArpKiEQbQ

Рассмотрел гипотезу о том, что можно закешировать <%= render "articles/single_story", story: story %> в \_main_stories_feed.html.erb и это даст заметный эффект.

Статистика 200 запросов в ab после отимизации:

```Benchmarking 127.0.0.1 (be patient)
Completed 100 requests
Completed 200 requests
Finished 200 requests


Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        142311 bytes

Concurrency Level:      5
Time taken for tests:   6.603 seconds
Complete requests:      200
Failed requests:        0
Total transferred:      28546800 bytes
HTML transferred:       28462200 bytes
Requests per second:    30.29 [#/sec] (mean)
Time per request:       165.066 [ms] (mean)
Time per request:       33.013 [ms] (mean, across all concurrent requests)
Transfer rate:          4222.22 [Kbytes/sec] received

Connection Times (ms)
min  mean[+/-sd] median   max
Connect:        0    0   0.2      0       2
Processing:    57  162  59.0    154     384
Waiting:       55  153  56.2    143     374
Total:         57  162  59.0    154     384

Percentage of the requests served within a certain time (ms)
50%    154
66%    173
75%    184
80%    203
90%    254
95%    289
98%    319
99%    347
100%    384 (longest request)
```

Изменение графика в NewRelic помле оптимизации https://disk.yandex.ru/i/d40doyOEVx7P2Q

Время ответа для 200 запросов уменьшилось с 10.545 до 6.603 секунд
