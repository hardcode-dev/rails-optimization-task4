Бенчмарк до кэша

```
Requests per second:    12.53 [#/sec] (mean)
Time per request:       79.815 [ms] (mean)
Time per request:       79.815 [ms] (mean, across all concurrent requests)
Transfer rate:          1766.58 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:    59   80  20.6     71     118
Waiting:       59   80  20.6     71     118
Total:         59   80  20.6     71     118

Percentage of the requests served within a certain time (ms)
  50%     71
  66%     89
  75%    100
  80%    101
  90%    118
  95%    118
  98%    118
  99%    118
 100%    118 (longest request)
```

Бенчмарк после кэширования фрагмента story в app/views/stories/_main_stories_feed.html.erb

```
Requests per second:    21.13 [#/sec] (mean)
Time per request:       47.333 [ms] (mean)
Time per request:       47.333 [ms] (mean, across all concurrent requests)
Transfer rate:          2979.84 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:    38   47  13.6     44      85
Waiting:       38   47  13.6     44      85
Total:         38   47  13.6     44      85

Percentage of the requests served within a certain time (ms)
  50%     44
  66%     46
  75%     46
  80%     48
  90%     85
  95%     85
  98%     85
  99%     85
 100%     85 (longest request)
```

По медиане оптимизация принесла 60% ускорения загрузки
