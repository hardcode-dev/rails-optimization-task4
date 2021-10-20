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
