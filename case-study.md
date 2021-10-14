## Подготовка

- Завел `dev.to` локально (не без проблем, ключик от Algolia почему-то не работал, сгенерировал новый - все завелось)
- Настроил `NewRelic`
- Настроил`Skylight`
- `Prometheus` + `Grafana` для мониторинга не настроил, дабы не терять время, решил прикрутить его в рабочем проекте
- Настроил `rack-mini-profiler`
- Настроил `rails-panel`
- Сделал возможность запуска проекта в `local_production` - красиво, как в скринкасте с реворком конфигов делать не стал, зато начал прибираться в рабочем проекте

Первое, чем я занялся после подготовительной части - нагрузил сервер - уж больно хотелось потыкаться в NewRelic, поковырять алерты и прочее:

- Поставил `siege`, `ab`
- "Побомбил" приложение осадой

```
 ** SIEGE 4.0.4
 ** Preparing 10 concurrent users for battle.
 The server is now under siege...
 Lifting the server siege...
 Transactions:		         969 hits
 Availability:		      100.00 %
 Elapsed time:		       29.07 secs
 Data transferred:	      320.39 MB
 Response time:		        0.29 secs
 Transaction rate:	       33.33 trans/sec
 Throughput:		       11.02 MB/sec
 Concurrency:		        9.74
 Successful transactions:         550
 Failed transactions:	           0
 Longest transaction:	        4.70
 Shortest transaction:	        0.00
```

- Проделал подобное с `ab`

```
Benchmarking 127.0.0.1 (be patient).....done

Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        142622 bytes

Concurrency Level:      1
Time taken for tests:   35.284 seconds
Complete requests:      50
Failed requests:        0
Total transferred:      7152250 bytes
HTML transferred:       7131100 bytes
Requests per second:    1.42 [#/sec] (mean)
Time per request:       705.677 [ms] (mean)
Time per request:       705.677 [ms] (mean, across all concurrent requests)
Transfer rate:          197.96 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       0
Processing:   233  705 351.2    667    2150
Waiting:      233  700 352.9    665    2148
Total:        233  706 351.2    667    2150

Percentage of the requests served within a certain time (ms)
  50%    667
  66%    752
  75%    813
  80%    878
  90%   1215
  95%   1250
  98%   2150
  99%   2150
 100%   2150 (longest request)
```

- Зафиксировал время работы
- `NewRelic` сказал, что действительно, дольше всего работает `StoriesController#index`

## Формирование метрики

Метрикой выбрал скорость выполнения скрипта `ab` - вполне себе показатель

## Feedback-Loop

Цикл простой: внес оптимизацию, замерил, повторил

### И вот что я сделал:

### находка №1

- полядел, что происходит при рендеринге `_main_stories_feed.html.erb`
- поскольку много времени занимает рендер `articles/single_story` - начал с него.
- Поглядел на схему таблицы. Смутило, что есть поле со счетчиком комментариев, но нет никакой инфы в модели
- Полез читать про некий `counter_culture` - с ним не встречался, но судя по всему он сам добавляет и обновляет счетчики
- Закэшировал истории, как было сказано в гипотезе, `touch` по описанным выше причинам добавлять не стал.
- Прогнал `ab` с теми же параметрами
- О чудо - оптимизация удалась :)

```
Benchmarking 127.0.0.1 (be patient).....done

Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        142672 bytes

Concurrency Level:      1
Time taken for tests:   11.088 seconds
Complete requests:      50
Failed requests:        0
Total transferred:      7154366 bytes
HTML transferred:       7133600 bytes
Requests per second:    4.51 [#/sec] (mean)
Time per request:       221.766 [ms] (mean)
Time per request:       221.766 [ms] (mean, across all concurrent requests)
Transfer rate:          630.09 [Kbytes/sec] received

Connection Times (ms)
min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:   143  222 200.8    181    1173
Waiting:      143  221 200.7    181    1173
Total:        143  222 200.8    181    1173

Percentage of the requests served within a certain time (ms)
50%    181
66%    190
75%    195
80%    199
90%    310
95%    377
98%   1173
99%   1173
100%   1173 (longest request)
```

- Время работы сократилось более чем в 3 раза.
- Бонусом догвоорился с руководством на выделение средств на `NewRelic` для нашего проетка - уж больно он мне понравился
- Осталось найти свободное время для внедрения
