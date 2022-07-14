## Подготовка

- [x] Локальный запуск репозитория `dev.to`.
- [x] Настройка `NewRelic`.
- [x] Настройка `Skylight`.
- [x] Настройка `Prometheus` + `Grafana`.
- [x] Настройка `rack-mini-profiler`.
- [x] Настройка `rails-panel`.
- [x] Настройка окружения `local_production`.

## Оптимизация

Все инструменты мониторинга показывают, что самой горячей точкой является главная страница, `StoriesController#index`, заметное время занимает рендеринг паршелов `_single_story.html.erb`.

Я решил рассмотреть гипотезу о том, что можно закешировать `<%= render "articles/single_story", story: story %>` в `_main_stories_feed.html.erb` и это даст заметный эффект.

Для удобства расчетов я сделал 100 запросов на главную страницу при помощи утилиты `ab` в окружении `local_production`:

```
Time per request:       457.159 [ms] (mean)
...
Percentage of the requests served within a certain time (ms)
  50%    384
  66%    399
  75%    407
  80%    414
  90%    449
  95%    561
  98%   3400
  99%   3494
 100%   3494 (longest request)
```

Я закэшировал этот паршел, средняя скорость выполнения запросов возросла более чем в два раза:

```
Time per request:       200.347 [ms] (mean, across all concurrent requests)
...
Percentage of the requests served within a certain time (ms)
  50%    123
  66%    142
  75%    151
  80%    157
  90%    171
  95%    238
  98%   3294
  99%   3412
 100%   3412 (longest request)
```

## Результаты

В результате проделанной работы мне удалось значительно уменьшить время загрузки заглавной страницы:

![alt text](newrelic.png 'new relic')

Я познакомился и установил инструменты мониторинга `new relic`, `Skylight`, также собрал DIY-APM на базе `Prometheus` и `Grafana`. Это оказалось очень полезным опытом, так как до этого у меня был только небольшой опыт работы со стеком `ELK`.
