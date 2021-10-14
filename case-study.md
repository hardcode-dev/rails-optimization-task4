# Case-study оптимизации

## Подготовка

- Запустил dev.to локально
- Настроил свой NewRelic для мониторинга локального dev.to
- Настроил свой Skylight для мониторинга локального dev.to
- Настроил свой Prometheus + Grafana для мониторинга локального dev.to
- Настроил rack-mini-profiler
- Настроил rails-panel
- Сделал возможность запуска проекта в local_production (с определенными трудностями)

## Оптимизация

Все инструменты мониторинга показывают, что самой горячей точкой является главная страница, `StoriesController#index`.
В частности, заметное время занимает рендеринг `partial`-ов `_single_story.html.erb`.

```
ab -n 30 http://127.0.0.1:3000/

Time taken for tests:   8.084 seconds
Requests per second:    3.71 [#/sec] (mean)
Time per request:       269.473 [ms] (mean)

Percentage of the requests served within a certain time (ms)
  50%    225
  66%    234
  75%    247
  80%    251
  90%    465
  95%    678
  98%   1031
  99%   1031
 100%   1031 (longest request)
```

Сделал кэширование story в `_main_stories_feed.html.erb`, после чего большое кол-во рендерингов `articles/_single_story` пропало, время выполнения apache benchmark теста сократилось более чем в 2 раза.

```
Time taken for tests:   3.377 seconds
Requests per second:    8.88 [#/sec] (mean)
Time per request:       112.582 [ms] (mean)

Percentage of the requests served within a certain time (ms)
  50%     99
  66%    112
  75%    138
  80%    152
  90%    156
  95%    156
  98%    158
  99%    158
 100%    158 (longest request)
```
