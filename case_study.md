# ДЗ №3

1 Добавил новое окружение local_production

Benchmark на основе утилиты ab

#### local_production

```cassandraql
enchmarking 127.0.0.1 (be patient).....done


Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        141111 bytes

Concurrency Level:      5
Time taken for tests:   0.444 seconds
Complete requests:      10
Failed requests:        0
Total transferred:      1415340 bytes
HTML transferred:       1411110 bytes
Requests per second:    22.55 [#/sec] (mean)
Time per request:       221.776 [ms] (mean)
Time per request:       44.355 [ms] (mean, across all concurrent requests)
Transfer rate:          3116.14 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       0
Processing:    71  200 111.6    214     358
Waiting:       71  200 111.6    212     358
Total:         71  200 111.6    214     359

Percentage of the requests served within a certain time (ms)
  50%    214
  66%    214
  75%    340
  80%    345
  90%    359
  95%    359
  98%    359
  99%    359
 100%    359 (longest request)

```

#### development

Отчет после второго запуска ab (Чтобы дать закешировать всё что можно закешировать =) )

```cassandraql
Benchmarking 127.0.0.1 (be patient).....done


Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        179823 bytes

Concurrency Level:      5
Time taken for tests:   3.254 seconds
Complete requests:      10
Failed requests:        0
Total transferred:      1802460 bytes
HTML transferred:       1798230 bytes
Requests per second:    3.07 [#/sec] (mean)
Time per request:       1626.898 [ms] (mean)
Time per request:       325.380 [ms] (mean, across all concurrent requests)
Transfer rate:          540.97 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       0
Processing:   587 1351 409.8   1561    1806
Waiting:      587 1350 409.7   1560    1803
Total:        587 1351 409.8   1561    1806

Percentage of the requests served within a certain time (ms)
  50%   1561
  66%   1564
  75%   1673
  80%   1778
  90%   1806
  95%   1806
  98%   1806
  99%   1806
 100%   1806 (longest request)

```

У local_production прирост в 3 секунды

## New Rellic

![newrellic](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/new_rellic.png)

Утилитой siege отправлял запросы и собрал некоторую метрику для главной страницы

## Prometheus + Grafana

Сегодня день prometheus! Подключал экспортеры не только для dev.to но и для микро сервисов на работе. Научился писать prometheus без ошибок.

Создал учебный кастомный коллектор

![grafana](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/grafana.png)

Дизайн у графаны классный.

Добавил метрику на http запросы. Вывел главную страницу
![si](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/store.png)

## rack mini profiler и rails panel - жить

![rmp](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/rmp.png)

![rails_panel](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/rails_panel.png)

С помощью stackprof выявил проблемный метод
StoriesController#handle_base_index
![stackprof](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/stack.png)
![stackprof](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/stack2.png)

Запустил на главную страницу `siege -c 10 -t320s http://localhost:3000/`

Skylight и rails panel указывают на проблемную зону при рендеринге страницы. Паршл stories/\_main_stories_feed.html.erb

![skylight](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/skylite.png)
![rp](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/rails_panel2.png)
В данном паршиле итерируется истории статьи (articles/single_story). Так же имеется пришлошение на аутентификацию.
Я добавил кеширование паршола.

#### Результаты ab тестирования

```cassandraql
Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        137870 bytes

Concurrency Level:      5
Time taken for tests:   0.344 seconds
Complete requests:      10
Failed requests:        0
Total transferred:      1384110 bytes
HTML transferred:       1378700 bytes
Requests per second:    29.07 [#/sec] (mean)
Time per request:       171.980 [ms] (mean)
Time per request:       34.396 [ms] (mean, across all concurrent requests)
Transfer rate:          3929.74 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.5      1       1
Processing:   106  161  46.9    169     221
Waiting:       98  160  48.0    168     221
Total:        106  161  46.7    170     221
ERROR: The median and mean for the initial connection time are more than twice the standard
       deviation apart. These results are NOT reliable.

Percentage of the requests served within a certain time (ms)
  50%    170
  66%    192
  75%    213
  80%    218
  90%    221
  95%    221
  98%    221
  99%    221
 100%    221 (longest request)

```

Заметен прирост в производительности.
####Профит

- Кол-во запросов в секунду. Было - 22 Стало -29 запросов в секунду.

| Метрика                    |    Было |    Стало |
| -------------------------- | ------: | -------: |
| Кол-во запросов в секунду  |      22 |       29 |
| Время на обработку запроса | 221.7ms | 171.9 ms |

##ЮХУУ!
![yhuu](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/yhuu.png)
