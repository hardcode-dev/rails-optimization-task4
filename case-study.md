Case-study оптимизации

## Актуальная проблема

Нужно оптимизировать механизм загрузки главной страницы проекта `StoriesController#index`.

Я решил исправить эту проблему, оптимизировав рендеринг шаблонов.

## Формирование метрики

Для того, чтобы понимать, дают ли мои изменения положительный эффект на быстродействие программы я придумал использовать такую метрику: число секунд, требуемые для прохождения нагрузочного бенчмарка `ab` с 100 запросами к главной странице проекта. Результаты:

```
    Document Path:          /
    Document Length:        137188 bytes

    Concurrency Level:      1
    Time taken for tests:   5.048 seconds
    Complete requests:      100
    Failed requests:        0
    Total transferred:      13773200 bytes
    HTML transferred:       13718800 bytes
    Requests per second:    19.81 [#/sec] (mean)
    Time per request:       50.475 [ms] (mean)
    Time per request:       50.475 [ms] (mean, across all concurrent requests)
    Transfer rate:          2664.75 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    0   0.1      0       0
    Processing:    39   50  18.3     45     165
    Waiting:       39   50  18.3     45     164
    Total:         39   50  18.3     45     165

    Percentage of the requests served within a certain time (ms)
    50%     45
    66%     48
    75%     50
    80%     51
    90%     64
    95%     84
    98%    138
    99%    165
    100%    165 (longest request)
```

## Вникаем в детали системы, чтобы найти главные точки роста

Для того, чтобы найти "точки роста" для оптимизации я воспользовался rack-mini-profiler.

### Ваша находка №1

- rack-mini-profiler показал заметное время занимает рендеринг partial `articles/_single_story.html.erb` (24 вызова в контексте `Rendering: stories/_main_stories_feed.html.er... 4.6 +23.2`).

- добавил кеширование фрагмента:

  ```
  <% cache(story) do %>
      <%= render "articles/single_story", story: story %>
  <% end %>
  ```

- метрика снизилась с 5с до 3.5с

```
Document Path:          /
Document Length:        137271 bytes

Concurrency Level:      1
Time taken for tests:   3.444 seconds
Complete requests:      100
Failed requests:        46
  (Connect: 0, Receive: 0, Length: 46, Exceptions: 0)
Total transferred:      13782190 bytes
HTML transferred:       13727790 bytes
Requests per second:    29.03 [#/sec] (mean)
Time per request:       34.441 [ms] (mean)
Time per request:       34.441 [ms] (mean, across all concurrent requests)
Transfer rate:          3907.84 [Kbytes/sec] received

Connection Times (ms)
             min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:    25   34  14.5     31     141
Waiting:       25   34  14.5     31     141
Total:         25   34  14.5     31     141

Percentage of the requests served within a certain time (ms)
 50%     31
 66%     33
 75%     35
 80%     35
 90%     46
 95%     51
 98%     96
 99%    141
100%    141 (longest request)
```

- `Rendering: stories/_main_stories_feed.html.er... 3.4 +18.5`

## Результаты

В результате проделанной оптимизации удалось ускорить время рендеринга `StoriesController#index` ~ в 1.5 раза.
