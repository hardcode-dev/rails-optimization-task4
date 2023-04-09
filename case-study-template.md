# Case-study оптимизации

## Подготовка

- Удалось накатить 2.6.3 на M1 с помощью RUBY_CFLAGS="-w", поднял `dev.to` локально (node 12)
- `Skylight` запустить не удалось (не добавляется свое окружение), дальше - без него
- Настроил `NewRelic` для 'development', заюзал siege
- Настроил `Scout` для 'development', понравился больше за счет дружественного UI.
- `Datadog` победить не смог, опять проблемы с arm64 - не стал терять время ибо имеющихся средств достаточно
- Настроил `Prometheus` + `Grafana` для мониторинга локального `dev.to`
- Настроил `local_production` для проекта и подкючил `NewRelic`, `Scout`, `Prometheus` + `Grafana`
- Настроил `rack-mini-profiler` и `rails-panel` для `local_production`

## Оптимизация

Использовались ab, RMP и newrelic
_Initial state_

1. benchmark с помощью `ab` (100 requests)
   `development`:
   Time taken for tests: 33.005 seconds
   Requests per second: 3.03 [#/sec](mean)

`local_production`:
Concurrency Level: 1
Time taken for tests: 18.913 seconds
Complete requests: 100
Failed requests: 14
(Connect: 0, Receive: 0, Length: 14, Exceptions: 0)
Total transferred: 14026571 bytes
HTML transferred: 13922285 bytes
Requests per second: 5.29 [#/sec](mean)
Time per request: 189.132 [ms](mean)
Time per request: 189.132 [ms] (mean, across all concurrent requests)
Transfer rate: 724.25 [Kbytes/sec] received

`Базовая метрика`:
Time taken for tests: 18.913 seconds

2. RMP
   "stories#index" - 218.9 ms
   проблема - много вызовов паршла `_single_story.html.erb`
   Rendering: articles/\_single_story.html.erb (по ~1,5ms отъедает)

3. newrelic
   Controller/stories/index: ~240 ms

_Actions_
Корень проблемы: root "stories#index" -> articles/index -> stories/main_stories_feed -> articles/single_story
Кэшируется с юзером, но не без. Добавляем кэширование single_story

_Filnal state_

1. ab

Concurrency Level: 1
Time taken for tests: 11.005 seconds
Complete requests: 100
Failed requests: 20
(Connect: 0, Receive: 0, Length: 20, Exceptions: 0)
Total transferred: 14031359 bytes
HTML transferred: 13927079 bytes
Requests per second: 9.09 [#/sec](mean)
Time per request: 110.053 [ms](mean)
Time per request: 110.053 [ms] (mean, across all concurrent requests)
Transfer rate: 1245.09 [Kbytes/sec] received

2. RMP
   "stories#index" - 131.2 ms

3. newrelic
   Controller/stories/index: ~120 ms

`Базовая метрика`:
Time taken for tests: 11.005 seconds (- 9 sec)

Данные new relic - в png:
замерялись на `siege -c 10 -t180s http://localhost:3000` + 1 мин. фона

Не сказать что большой прогресс, но ОК.
В целом хорошо зарекомендовали newlelic, RMP и ab. Сборка кривоватая - не все работает, особенно на M1, но инструменты изучить позволяет
