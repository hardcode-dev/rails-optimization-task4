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

## rack mini profiler - жить

![rmp](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/rmp.png)
