Создал окружение local_production (на базе production). Подключил rack-mini-profiler для работы с ним. Интегрировал в приложение связку prometheus + grafana. Подключил мониторинг приложения в newrelic_rpm и scout_apm в триальном режиме.

Результаты бенчмарка для окружения development:

ab -n 1000 -c 5 http://2128506.net:9999/
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 2128506.net (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests

Server Software:  
Server Hostname: 2128506.net
Server Port: 9999

Document Path: /
Document Length: 184778 bytes

Concurrency Level: 5
Time taken for tests: 966.573 seconds
Complete requests: 1000
Failed requests: 997
(Connect: 0, Receive: 0, Length: 997, Exceptions: 0)
Non-2xx responses: 1
Total transferred: 186257241 bytes
HTML transferred: 185268960 bytes
Requests per second: 1.03 [#/sec](mean)
Time per request: 4832.866 [ms](mean)
Time per request: 966.573 [ms] (mean, across all concurrent requests)
Transfer rate: 188.18 [Kbytes/sec] received

Connection Times (ms)
min mean[+/-sd] median max
Connect: 3 5 3.5 4 33
Processing: 1749 4815 1660.8 4905 11631
Waiting: 1696 4731 1651.0 4819 10657
Total: 1753 4821 1660.8 4910 11636

Percentage of the requests served within a certain time (ms)
50% 4910
66% 5622
75% 5992
80% 6354
90% 7017
95% 7468
98% 7860
99% 8053
100% 11636 (longest request)

Результаты бенчмарка для окружения local_production (без оптимизации):

ab -n 1000 -c 5 http://2128506.net:9999/
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 2128506.net (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests

Server Software:
Server Hostname: 2128506.net
Server Port: 9999

Document Path: /
Document Length: 142351 bytes

Concurrency Level: 5
Time taken for tests: 242.324 seconds
Complete requests: 1000
Failed requests: 0
Total transferred: 142866250 bytes
HTML transferred: 142351000 bytes
Requests per second: 4.13 [#/sec](mean)
Time per request: 1211.621 [ms](mean)
Time per request: 242.324 [ms] (mean, across all concurrent requests)
Transfer rate: 575.75 [Kbytes/sec] received

Connection Times (ms)
min mean[+/-sd] median max
Connect: 1 1 0.6 1 12
Processing: 382 1205 462.9 1168 3189
Waiting: 365 1148 450.5 1095 3035
Total: 383 1206 462.9 1169 3190

Percentage of the requests served within a certain time (ms)
50% 1169
66% 1400
75% 1546
80% 1602
90% 1814
95% 1957
98% 2208
99% 2374
100% 3190 (longest request)

Результаты бенчмарка для окружения local_production (с оптимизацией в виде кэширования паршиала _single_story):

ab -n 1000 -c 5 http://2128506.net:9999/
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 2128506.net (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests

Server Software:
Server Hostname: 2128506.net
Server Port: 9999

Document Path: /
Document Length: 141079 bytes

Concurrency Level: 5
Time taken for tests: 181.183 seconds
Complete requests: 1000
Failed requests: 0
Total transferred: 141591170 bytes
HTML transferred: 141079000 bytes
Requests per second: 5.52 [#/sec](mean)
Time per request: 905.915 [ms](mean)
Time per request: 181.183 [ms] (mean, across all concurrent requests)
Transfer rate: 763.17 [Kbytes/sec] received

Connection Times (ms)
min mean[+/-sd] median max
Connect: 1 1 0.6 1 12
Processing: 315 901 353.1 877 2484
Waiting: 301 853 340.7 819 2456
Total: 316 902 353.2 878 2486

Percentage of the requests served within a certain time (ms)
50% 878
66% 1053
75% 1143
80% 1213
90% 1373
95% 1507
98% 1653
99% 1779
100% 2486 (longest request)

Вывод: гипотеза о целесообразности кэширования паршиала _single_story верна. По пятидесятому перцентилю время загрузки уменьшилось на 25%.

Скриншот из scout_apm (первая группа запросов -- без оптимизации, вторая -- с кэшированием паршиала):