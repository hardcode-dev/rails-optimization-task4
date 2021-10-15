# Case-study оптимизации

## Подготовка

1. Запустил `DEV.TO` локально
2. Настроил `New Relic`
   - Нагрузил систему спомощью `siege`, чтобы проверить работу New Relic
   - `New Relic => Monitoring => Transaction`: показал что точка роста `StoriesController#index`
3. Подключил `Skylight`
4. Подключил `Prometheus`+`Grafana`
5. Добавил `rack-mini-profiler` и настроил `RailsPanel`

## Оптимизация

Проверил гипотезу рендеринга `partial`-ов `_single_story.html.erb` .

- Сделайте `benchmark` с помощью `ab`

```
ab -n 100 http://127.0.0.1:3000/

This is ApacheBench, Version 2.3 <$Revision: 1879490 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 127.0.0.1 (be patient).....done


Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        141580 bytes

Concurrency Level:      1
Time taken for tests:   9.085 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      14213900 bytes
HTML transferred:       14158000 bytes
Requests per second:    11.01 [#/sec] (mean)
Time per request:       90.854 [ms] (mean)
Time per request:       90.854 [ms] (mean, across all concurrent requests)
Transfer rate:          1527.80 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:    47   91 145.8     56    1139
Waiting:       47   91 145.6     56    1137
Total:         47   91 145.8     56    1140

Percentage of the requests served within a certain time (ms)
  50%     56
  66%     60
  75%     62
  80%     76
  90%    116
  95%    186
  98%    969
  99%   1140
 100%   1140 (longest request)
```

- Сделайте оптимизацию
- Перезапустите `benchmark`

```
Benchmarking 127.0.0.1 (be patient).....done


Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        141630 bytes

Concurrency Level:      1
Time taken for tests:   4.203 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      14218900 bytes
HTML transferred:       14163000 bytes
Requests per second:    23.79 [#/sec] (mean)
Time per request:       42.030 [ms] (mean)
Time per request:       42.030 [ms] (mean, across all concurrent requests)
Transfer rate:          3303.77 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:    29   42  16.8     38     149
Waiting:       28   42  16.8     37     149
Total:         29   42  16.8     38     149

Percentage of the requests served within a certain time (ms)
  50%     38
  66%     42
  75%     44
  80%     47
  90%     57
  95%     72
  98%    105
  99%    149
 100%    149 (longest request)
```

### Заключение

Время сократилось в два раза, но я решил отказаться от оптимизации так как время запроса на данный момент допустимое для меня
