# Case-study оптимизации

## Подготовка

- Развертка dev.to локально
- Настройка local_production environment
- Настройка NewRelic
- Настройка Skylight
- Настройка rack-mini-profiler

## Оптимизация

Все инструменты мониторинга показывают, что самой горячей точкой является главная страница, `StoriesController#index`.
В частности, заметное время занимает рендеринг `partial`-ов `_single_story.html.erb`.

В качестве основной метрики используем время ответа страницы:

`ab -n 100 http://127.0.0.1:3000/`

Текущее значение:

```
Time taken for tests:   6.735 seconds
Requests per second:    14.85 [#/sec] (mean)
Time per request:       67.355 [ms] (mean)
Percentage of the requests served within a certain time (ms)
  50%     65
  66%     68
  75%     70
  80%     71
  90%     93
  95%    140
  98%    166
  99%    199
 100%    199 (longest request)
```

После добавления кэша:

```
Time taken for tests:   3.193 seconds
Requests per second:    31.32 [#/sec] (mean)
Time per request:       31.932 [ms] (mean)

Percentage of the requests served within a certain time (ms)
  50%     25
  66%     26
  75%     29
  80%     43
  90%     46
  95%     64
  98%    121
  99%    151
 100%    151 (longest request)
```
