❯ ab -n 100 -c 5 http://2128506.net:9999/
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 2128506.net (be patient).....done

Server Software:  
Server Hostname: 2128506.net
Server Port: 9999

Document Path: /
Document Length: 142351 bytes

Concurrency Level: 5
Time taken for tests: 19.442 seconds
Complete requests: 100
Failed requests: 0
Total transferred: 14275000 bytes
HTML transferred: 14235100 bytes
Requests per second: 5.14 [#/sec](mean)
Time per request: 972.105 [ms](mean)
Time per request: 194.421 [ms] (mean, across all concurrent requests)
Transfer rate: 717.02 [Kbytes/sec] received

Connection Times (ms)
min mean[+/-sd] median max
Connect: 3 6 5.1 4 44
Processing: 306 922 438.5 858 2079
Waiting: 287 838 399.1 774 1897
Total: 319 928 438.7 862 2086

Percentage of the requests served within a certain time (ms)
50% 862
66% 1171
75% 1247
80% 1290
90% 1483
95% 1818
98% 2059
99% 2086
100% 2086 (longest request)
~ ··················································································································································· 22s  12:40:30
❯ ab -n 100 -c 5 http://2128506.net:9999/
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 2128506.net (be patient).....done

Server Software:  
Server Hostname: 2128506.net
Server Port: 9999

Document Path: /
Document Length: 142351 bytes

Concurrency Level: 5
Time taken for tests: 17.739 seconds
Complete requests: 100
Failed requests: 0
Total transferred: 14275000 bytes
HTML transferred: 14235100 bytes
Requests per second: 5.64 [#/sec](mean)
Time per request: 886.973 [ms](mean)
Time per request: 177.395 [ms] (mean, across all concurrent requests)
Transfer rate: 785.84 [Kbytes/sec] received

Connection Times (ms)
min mean[+/-sd] median max
Connect: 3 6 4.7 4 25
Processing: 312 851 353.0 828 1807
Waiting: 286 768 339.1 769 1775
Total: 317 857 352.2 834 1810

Percentage of the requests served within a certain time (ms)
50% 834
66% 1010
75% 1129
80% 1196
90% 1366
95% 1453
98% 1670
99% 1810
100% 1810 (longest request)
~ ··················································································································································· 18s  12:40:52
❯ ab -n 100 -c 5 http://2128506.net:9999/
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 2128506.net (be patient).....done

Server Software:  
Server Hostname: 2128506.net
Server Port: 9999

Document Path: /
Document Length: 184150 bytes

Concurrency Level: 5
Time taken for tests: 82.538 seconds
Complete requests: 100
Failed requests: 1
(Connect: 0, Receive: 0, Length: 1, Exceptions: 0)
Total transferred: 18317871 bytes
HTML transferred: 18275571 bytes
Requests per second: 1.21 [#/sec](mean)
Time per request: 4126.878 [ms](mean)
Time per request: 825.376 [ms] (mean, across all concurrent requests)
Transfer rate: 216.73 [Kbytes/sec] received

Connection Times (ms)
min mean[+/-sd] median max
Connect: 3 270 1721.1 4 15509
Processing: 1360 3738 1983.2 3639 17562
Waiting: 1321 3618 1957.4 3545 17531
Total: 1364 4009 2533.7 3950 18700

Percentage of the requests served within a certain time (ms)
50% 3950
66% 4399
75% 4630
80% 4923
90% 5707
95% 6411
98% 17566
99% 18700
100% 18700 (longest request)
