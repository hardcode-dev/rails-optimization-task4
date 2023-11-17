# Case-study оптимизации

## Актуальная проблема

Нужно оптимизировать механизм загрузки главной страницы проекта `StoriesController#index`.

Я решил исправить эту проблему, оптимизировав рендеринг шаблонов.

## Формирование метрики

Для того, чтобы понимать, дают ли мои изменения положительный эффект на быстродействие программы я придумал использовать такую метрику: число секунд, требуемые для прохождения нагрузочного бенчмарка `ab` с 30 запросами к главной странице проекта.

## Вникаем в детали системы, чтобы найти главные точки роста

Для того, чтобы найти "точки роста" для оптимизации я воспользовался инструментами rack-mini-profiler, Prometheus, Grafana.

Вот какие проблемы удалось найти и решить

### Ваша находка №1

- какой отчёт показал главную точку роста

  - rack-mini-profiler: заметное время занимает рендеринг `partial`-ов `_single_story.html.erb`, делаются 11 вызовов. Rendering: stories/\_main_stories_feed.html.erb duration 3.3ms, with children 57.1ms
  - ```
      Document Path:          /
      Document Length:        139178 bytes

      Concurrency Level:      1
      Time taken for tests:   2.373 seconds
      Complete requests:      30
      Failed requests:        0
      Total transferred:      4206630 bytes
      HTML transferred:       4175340 bytes
      Requests per second:    12.64 [#/sec] (mean)
      Time per request:       79.097 [ms] (mean)
      Time per request:       79.097 [ms] (mean, across all concurrent requests)
      Transfer rate:          1731.23 [Kbytes/sec] received

      Connection Times (ms)
                    min  mean[+/-sd] median   max
      Connect:        0    0   0.2      0       1
      Processing:    69   79  18.0     74     164
      Waiting:       69   79  18.0     74     164
      Total:         69   79  18.2     75     166

      Percentage of the requests served within a certain time (ms)
        50%     75
        66%     77
        75%     79
        80%     80
        90%     89
        95%    111
        98%    166
        99%    166
      100%    166 (longest request)
    ```

    Нашей точкой роста будет число вызовов отдельных шаблонов `articles/_single_story.html.erb`

- как вы решили её оптимизировать
  - Применил кэширование в шаблоне при работе с коллекциями stories. Гипотеза состоит в том, что в случае не частых обновлений постов на главной странице кэширование снизит время изначальной загрузки за счет переиспользования данных об уже имеющихся постах.
- как изменилась метрика

  - Метрика снизилась с 2.37 сек до 1.42 сек

    ```
      Document Path:          /
      Document Length:        Variable

      Concurrency Level:      1
      Time taken for tests:   1.423 seconds
      Complete requests:      30
      Failed requests:        0
      Total transferred:      4208029 bytes
      HTML transferred:       4176759 bytes
      Requests per second:    21.08 [#/sec] (mean)
      Time per request:       47.445 [ms] (mean)
      Time per request:       47.445 [ms] (mean, across all concurrent requests)
      Transfer rate:          2887.15 [Kbytes/sec] received

      Connection Times (ms)
                    min  mean[+/-sd] median   max
      Connect:        0    0   0.2      0       1
      Processing:    39   47  15.7     44     120
      Waiting:       39   47  15.7     43     119
      Total:         39   47  15.9     44     121

      Percentage of the requests served within a certain time (ms)
        50%     44
        66%     45
        75%     45
        80%     47
        90%     49
        95%     84
        98%    121
        99%    121
      100%    121 (longest request)
    ```

- как изменился отчёт профилировщика
  - Rendering: stories/\_main_stories_feed.html.erb duration 10.1ms, with children 10.2ms

## Результаты

В результате проделанной оптимизации удалось ускорить время рендеринга главной страницы более чем в полтора раза.
