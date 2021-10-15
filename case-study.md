# Case-study оптимизации

## Подготовка

- Запустил dev.to локально - Столкнулся со следующими трудностями:

  - Сначала при bundle вылетела ошибка с неправильным путем для гемов `'fix-db-schema-conflicts'` и `gem 'acts_as_follower'`. Поправил путь и все норм.
  - Добавил ключи Алголии в файл application.yml.
  - Дальше запускаю bin/setup, Yarn начинает ругаться. Просто отключил эту проверку в конфиге как и предлагалось у меня в консоли.
  - Дальше bin/startup. И вылетает ошибка: No such file or directory ... node_modules ... Это пофиксил следующей командой в консоли (предварительно установив npm): npm install -g webpack-dev-server \* Опять запускаю bin/startup и вылетает следующая ошибка: `Error: Cannot find module 'webpack'`. Ввел в консоли команду: `npm link webpack`,
    а затем:

        	    rm -Rf node_modules
        	    rm -f package-lock.json
        	    npm install

- Настроил свой NewRelic для мониторинга локального dev.to

  - Установил утилиту siege и запустил ее командой siege -c 5 -t120s http://localhost:3000
  - Определил, что главной точкой роста является StoriesController#index, а именно запрос составляет почти 4 с или 56,8 % \* Скрин с экрана лежит в папке task_images/01_new_relic_before.png

- Настроил свой Skylight для мониторинга локального dev.to
- Настроил свой Prometheus + Grafana для мониторинга локального dev.to
- Настроил rack-mini-profiler

## Оптимизация

Все инструменты мониторинга показывают, что самой горячей точкой является `StoriesController#index`.
В частности, заметное время занимает рендеринг `partial`-ов `_main_stories_feed.html.erb`.

Я не знаю, правильно ли я понял, что сокращение времени отрисовки вьюхи при кэшировании происходит на 2-ой запрос (???), потому что у меня по сути особо ничего не поменялось.

Было 39 сек....

```

RAIL_ENV='local_production' ab -n 30 -c 10  http://127.0.0.1:3000/


Benchmarking 127.0.0.1 (be patient).....done


Concurrency Level:      10
Time taken for tests:   38.723 seconds
Complete requests:      30
Failed requests:        0
Non-2xx responses:      30
Total transferred:      617465 bytes
HTML transferred:       611040 bytes
Requests per second:    0.77 [#/sec] (mean)
Time per request:       12907.667 [ms] (mean)
Time per request:       1290.767 [ms] (mean, across all concurrent requests)
Transfer rate:          15.57 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       0
Processing:   577 6602 11953.4   1287   32813
Waiting:      576 6601 11952.4   1287   32812
Total:        577 6602 11953.4   1287   32813

Percentage of the requests served within a certain time (ms)
  50%   1287
  66%   1580
  75%   1632
  80%   5911
  90%  32802
  95%  32810
  98%  32813
  99%  32813
 100%  32813 (longest request)


====================================================================================
Теперь перезагружаю сервер приложения и повторяю ap benchmark.
====================================================================================

Concurrency Level:      10
Time taken for tests:   31.668 seconds
Complete requests:      30
Failed requests:        1
   (Connect: 0, Receive: 0, Length: 1, Exceptions: 0)
Non-2xx responses:      30
Total transferred:      620238 bytes
HTML transferred:       613814 bytes
Requests per second:    0.95 [#/sec] (mean)
Time per request:       10555.919 [ms] (mean)
Time per request:       1055.592 [ms] (mean, across all concurrent requests)
Transfer rate:          19.13 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       0
Processing:   768 4822 8347.4   1298   25558
Waiting:      768 4821 8346.9   1298   25558
Total:        768 4822 8347.5   1298   25558

Percentage of the requests served within a certain time (ms)
  50%   1298
  66%   1623
  75%   2074
  80%   5715
  90%  25542
  95%  25553
  98%  25558
  99%  25558
 100%  25558 (longest request)



====================================================================================
Теперь без перезагрузки сервера повторяю ap benchmark
====================================================================================


Concurrency Level:      10
Time taken for tests:   3.865 seconds
Complete requests:      30
Failed requests:        0
Non-2xx responses:      30
Total transferred:      617460 bytes
HTML transferred:       611040 bytes
Requests per second:    7.76 [#/sec] (mean)
Time per request:       1288.442 [ms] (mean)
Time per request:       128.844 [ms] (mean, across all concurrent requests)
Transfer rate:          156.00 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:   210 1117 310.1   1128    1859
Waiting:      209 1113 310.5   1128    1858
Total:        210 1117 310.1   1128    1859

Percentage of the requests served within a certain time (ms)
  50%   1128
  66%   1163
  75%   1295
  80%   1382
  90%   1504
  95%   1665
  98%   1859
  99%   1859
 100%   1859 (longest request)
```
