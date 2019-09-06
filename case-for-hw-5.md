# Home Work 5

- [x] Настроил SSL (mkcert + nginx) + HTTP2

![ssl](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/ssl.png)

- [x] В StoriesController вызывал метож push_headers для всех svg данной страницы

#### Было

![ssl](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/svg.png)

```cassandraql
Requests per second:    29.07 [#/sec] (mean)
Time per request:       171.980 [ms] (mean)
Time per request:       34.396 [ms] (mean, across all concurrent requests)
Transfer rate:          3929.74 [Kbytes/sec] received
```

#### Cтало

![ssl](https://raw.githubusercontent.com/VidgarVii/rails-optimization-2-task4/master/fixtures/svg3.png)

```cassandraql
Requests per second:    29.89 [#/sec] (mean)
Time per request:       167.293 [ms] (mean)
Time per request:       33.459 [ms] (mean, across all concurrent requests)
Transfer rate:          3981.13 [Kbytes/sec] received

```
