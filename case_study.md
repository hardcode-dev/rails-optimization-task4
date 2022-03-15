## Задача - попрактиковаться в оптимизации живого open-source проекта.

1. Установил и попрактиковался в инструментах, показанных в лекции. За исключением prometheus, с ним совладать не удалось

`prometheus_1 | time="2020-02-25T15:19:51Z" level=error msg="Couldn't load configuration (-config.file=/prometheus.yml): read /prometheus.yml: is a directory" source="main.go:214" rails-optimization-task4_prometheus_1 exited with code 1`

2. Настроил local_production, долго возился с покривившимся вебпакером, но все-таки наша взяла.
3. Попробовал профилировщик в local_production окружении, правда рельсовая инфраструктура сильно глаза режет, но хотя бы время показывает. В моем рабочем проекте, у меня вообще отчеты только с количеством вызовов выдавались, так и не понял, почему
4. Попробовал ab, наверное самый удобный инструмент за последнее время.
5. С его помощщью удалось измерить профит от кэширования не динамических паршалов и с 253 ms медианного и 423 ms максимального запроса снизить время загрузки титульной страницы до 137 ms медианного и 296 ms максимального запросов. То есть примерно на треть.

===============
25.02.2020
Развернул проект, интегрировал с new relic, skylight, rack-mini-profiler и rails-panel. Но вот prometheus и Graphana у меня что-то не взлетели.

`prometheus_1 | time="2020-02-25T15:19:51Z" level=error msg="Couldn't load configuration (-config.file=/prometheus.yml): read /prometheus.yml: is a directory" source="main.go:214" rails-optimization-task4_prometheus_1 exited with code 1`

думаю, пока без него буду оптимизировать

================
26.02.2020
Построим фидбэк луп и изучим, как дела обстоят с загрузкой индекс страницы (root "stories#index")
Судя по логам, из одного контроллера запрос перенаправляется и в другие тоже. И сложно разобрать, какой из них, сколько времени на самом деле занимает

rack-mini-profiler также показывает несколько запросов, начнем с самого тяжелого из них, 5_776 ms:

`GET http://localhost:3000/yundt_lucy/-dulce-e... 60.7 +0.0 Executing action: show 419.0 +52.0 11 sql 55.5 Rendering: articles/show 4774.6 +471.0 8 sql 27.3 Rendering: articles/_actions 26.2 +5129.0 Rendering: articles/_full_comment_area 11.1 +5170.0 Rendering: comments/_form 15.7 +5176.0 Rendering: articles/_comments_actions 6.6 +5197.0 Rendering: articles/_bottom_content 375.5 +5272.0 7 sql 21.4 Rendering: articles/_sticky_nav 84.8 +5654.0 2 sql 4.0`

Попробуем запрофилировать этот экшн в callgrind, чтобы понять, какой из используемых им методов потребляет больше всего времени. Для этого сделаем local_production окружение
Настроил local_production окружение, проверил - страницы открываются вроде без ошибок.

Но stackprof у меня не открывает отчеты (хоть и генерирует), а callgrind в локал_прод окружении почему то 500 завершает работу. Хотя отчеты генерирует. А в дев среде отрабатывает нормально. Завтра буду разбираться, в чем дело.

================
28.02.2020
Каким то образом оказался покалечен webpacker, починил его и производные, а в local_production окружении настройку config.public_file_server выставил как девелопменте, теперь удалось запустить профилировщик внутри контроллера. Отчет 54883 показывает, что 25% времени уходит на какой-то <cycle 2>, в котором все выглядит, как рельсовая инфраструктура, и еще 25% времени съедает PG Connection. Вообще в рамках этого контроллера выполняется чересчур много вызовов, мне кажется, если убрать эту вложенную цикличность, то удастся сократить время выполнения экшна. Ну и запросы к базе тоже проанализировать надо будет завтра

================
29.02.2020

Так, значит,
если наводить на tag, то в контроллер летит Parameters: {"i"=>"i", "tag"=>"python"} [controller_call]
если наводить на название статьи, то в контроллер летит Parameters: {"i"=>"i", "username"=>"delois_dr_roberts"} [controller_call]

если ни того, ни другого, то обрабатывается handle_base_index

Так, если взглянуть на домашнее задание, там, в приницпе, дается понимание того, что именно нужно оптимизирвать.
Паршал

замерим без кэша скоросьт загрузки первой страницы с помощью ab (100 запросов)

без кэша

Benchmarking localhost (be patient).....done

Server Software:
Server Hostname: localhost
Server Port: 3000

Document Path: /
Document Length: 181094 bytes

Concurrency Level: 1
Time taken for tests: 25.937 seconds
Complete requests: 100
Failed requests: 99
(Connect: 0, Receive: 0, Length: 99, Exceptions: 0)
Total transferred: 18209359 bytes
HTML transferred: 18109579 bytes
Requests per second: 3.86 [#/sec](mean)
Time per request: 259.370 [ms](mean)
Time per request: 259.370 [ms] (mean, across all concurrent requests)
Transfer rate: 685.61 [Kbytes/sec] received

Connection Times (ms)
min mean[+/-sd] median max
Connect: 0 0 0.3 0 3
Processing: 193 259 47.7 252 423
Waiting: 193 259 47.7 251 423
Total: 193 259 47.7 253 423

Percentage of the requests served within a certain time (ms)
50% 253
66% 277
75% 293
80% 298
90% 318
95% 361
98% 394
99% 423
100% 423 (longest request)

с кэшем

Benchmarking localhost (be patient).....done

Server Software:
Server Hostname: localhost
Server Port: 3000

Document Path: /
Document Length: 179186 bytes

Concurrency Level: 1
Time taken for tests: 17.942 seconds
Complete requests: 100
Failed requests: 97
(Connect: 0, Receive: 0, Length: 97, Exceptions: 0)
Total transferred: 18018477 bytes
HTML transferred: 17918737 bytes
Requests per second: 5.57 [#/sec](mean)
Time per request: 179.424 [ms](mean)
Time per request: 179.424 [ms] (mean, across all concurrent requests)
Transfer rate: 980.70 [Kbytes/sec] received

Connection Times (ms)
min mean[+/-sd] median max
Connect: 0 0 0.2 0 1
Processing: 105 179 68.4 163 455
Waiting: 105 179 68.3 163 455
Total: 106 179 68.5 163 455

Percentage of the requests served within a certain time (ms)
50% 163
66% 197
75% 222
80% 234
90% 252
95% 321
98% 453
99% 455
100% 455 (longest request)

думаю, самым показательным тут является медианное значение, и оно снизилось на треть.

Добавил везде, где используется этот паршал, кэширование, удалось получить еще более приятные результаты

Benchmarking localhost (be patient).....done

Server Software:
Server Hostname: localhost
Server Port: 3000

Document Path: /
Document Length: 179186 bytes

Concurrency Level: 1
Time taken for tests: 14.888 seconds
Complete requests: 100
Failed requests: 98
(Connect: 0, Receive: 0, Length: 98, Exceptions: 0)
Total transferred: 18018518 bytes
HTML transferred: 17918758 bytes
Requests per second: 6.72 [#/sec](mean)
Time per request: 148.876 [ms](mean)
Time per request: 148.876 [ms] (mean, across all concurrent requests)
Transfer rate: 1181.93 [Kbytes/sec] received

Connection Times (ms)
min mean[+/-sd] median max
Connect: 0 0 0.2 0 1
Processing: 109 149 35.8 137 296
Waiting: 108 149 35.8 137 296
Total: 109 149 35.8 137 296

Percentage of the requests served within a certain time (ms)
50% 137
66% 155
75% 174
80% 177
90% 207
95% 215
98% 258
99% 296
100% 296 (longest request)
