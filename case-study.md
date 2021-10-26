До оптимизаций в `development`

```
Server Software:
Server Hostname:        localhost
Server Port:            3000

Document Path:          /
Document Length:        171022 bytes

Concurrency Level:      1
Time taken for tests:   56.957 seconds
Complete requests:      200
Failed requests:        80
   (Connect: 0, Receive: 0, Length: 80, Exceptions: 0)
Total transferred:      34412795 bytes
HTML transferred:       34204295 bytes
Requests per second:    3.51 [#/sec] (mean)
Time per request:       284.784 [ms] (mean)
Time per request:       284.784 [ms] (mean, across all concurrent requests)
Transfer rate:          590.03 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:   172  285 379.5    220    4095
Waiting:      172  260 365.2    219    4095
Total:        172  285 379.5    220    4095

Percentage of the requests served within a certain time (ms)
  50%    220
  66%    235
  75%    253
  80%    265
  90%    432
  95%    468
  98%    555
  99%   3794
 100%   4095 (longest request)

```

До оптимизаций в `local_production`

```
Server Software:
Server Hostname:        localhost
Server Port:            3000

Document Path:          /
Document Length:        142308 bytes

Concurrency Level:      1
Time taken for tests:   12.574 seconds
Complete requests:      200
Failed requests:        0
Total transferred:      28546200 bytes
HTML transferred:       28461600 bytes
Requests per second:    15.91 [#/sec] (mean)
Time per request:       62.868 [ms] (mean)
Time per request:       62.868 [ms] (mean, across all concurrent requests)
Transfer rate:          2217.13 [Kbytes/sec] received

Connection Times (ms)
min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:    47   63  16.7     57     152
Waiting:       46   62  16.8     57     152
Total:         47   63  16.7     57     152

Percentage of the requests served within a certain time (ms)
50%     57
66%     59
75%     61
80%     64
90%     91
95%     96
98%    110
99%    151
100%    152 (longest request)
```

При кэшировании `render partial: "articles/single_story", locals: { story: story }`. Предварительно произвел прогрев,
дабы все что нужно закэшировалось.

```
Server Hostname:        localhost
Server Port:            3000

Document Path:          /
Document Length:        142356 bytes

Concurrency Level:      1
Time taken for tests:   9.312 seconds
Complete requests:      200
Failed requests:        0
Total transferred:      28555800 bytes
HTML transferred:       28471200 bytes
Requests per second:    21.48 [#/sec] (mean)
Time per request:       46.559 [ms] (mean)
Time per request:       46.559 [ms] (mean, across all concurrent requests)
Transfer rate:          2994.73 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:    29   46  23.7     37     151
Waiting:       29   46  23.2     37     151
Total:         29   47  23.7     37     152

Percentage of the requests served within a certain time (ms)
  50%     37
  66%     41
  75%     53
  80%     55
  90%     84
  95%    104
  98%    132
  99%    139
 100%    152 (longest request)
```

Выводы:

- `local_production` в сревнении с `development` показывает прирост производительности на главной странице в ~4.5 раза;
- гипотеза о том, что кэширование `articles/single_story` позволит увеличить производительность, оказалась верна,
  уменьшив среднее время ответа на ~35%;
- 95 персентиль немного увеличился, полагаю можно списать это на погрешность.
  Он занимает ~3.2x среднего времени ответа эндпоинта (46.5 мс), что является допустимым по правилам Nate Berkopec.
