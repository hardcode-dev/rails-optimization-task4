# Задание №4

## Цели выполнения задания

- [x] Познакомиться с интересным живым `Rails` `open-source` проектом
- [ ] Попрактиковаться в настройке мониторинга
- [ ] Попрактиковаться в поиске возможностей для оптимизации
- [ ] Попрактиковаться в проверке гипотез и обосновании предложений по оптимизации

## Подготовка

- [x] Завести `dev.to` локально (прямо в этом репозитории, не нужно клонировать `dev.to` от них, иначе будут отличаться версии)
- [x] Настроить свой `Skylight` или `Scout` или `Datadog` для мониторинга локального dev.to
- [x] Настроить свой `NewRelic` для мониторинга локального `dev.to`
- [x] Настроить свой `Prometheus` + `Grafana` для мониторинга локального `dev.to`
- [ ] Настроить `rack-mini-profiler`
- [ ] Настроить `rails-panel`
- [ ] Сделать возможность запуска проекта в `local_production`

### local_production

Можно

- либо сделать новый `environment`, `local_production`
- либо использовать `production`, но найти способ переопределить нужные настройки локально

Основное, что должно отличать ваш `local_production` от `development`:

- `cache_classes: true`
- `eager_load: true`
- `perform_caching: true`
- `assets_debug: false`
- `assets_compile: false`

Для работы потребуется прекомпиляция ассетов `rake assets:precompile`

## Оптимизация

Все инструменты мониторинга показывают, что самой горячей точкой является главная страница, `StoriesController#index`.

В частности, заметное время занимает рендеринг `partial`-ов `_single_story.html.erb`.

Рассмотрите гипотезу о том, что можно закешировать `<%= render "articles/single_story", story: story %>` в `_main_stories_feed.html.erb` и это даст заметный эффект.

- Не забудьте включить локальное кэширование (`touch tmp/caching-dev.txt`)
- Сделайте `benchmark` с помощью `ab`
- Сделайте оптимизацию
- Перезапустите `benchmark`

#### Этап №1

Установлено приложение `dev.to` на локали

#### Этап №2

Установлены профилировщики:

- `SKYLIGHT` https://www.skylight.io
- `New Relic` https://newrelic.com
  Важно, нам нужно только [Install the New Relic Ruby agent](https://docs.newrelic.com/docs/agents/ruby-agent/installation/install-new-relic-ruby-agent/).
- `Prometheus` + `Grafana` https://prometheus.io ; https://grafana.com
  Установил через докерконтейнеры. Настроил приложение `dev.to`. Что-то показывает. Чтобы добавить собственные метрики для их мониторинга, надо научиться работать с этими инструментами по документации. Поскольку увидел эти инструменты в первый раз, в рамках ДЗ на изучение доков нет времени.

#### Этап №3

Сняты показания по точкам роста:

- `SKYLIGHT`:
  ![skylight_before_1.1](https://github.com/rubygitflow/rails-optimization-task4/raw/profiler4/statistics_report/skylight_before_1.1.jpg)
  ![skylight_before_1.2](https://github.com/rubygitflow/rails-optimization-task4/raw/profiler4/statistics_report/skylight_before_1.2.jpg)

- `New Relic`:
  ![newrelic_before_1.4](https://github.com/rubygitflow/rails-optimization-task4/raw/profiler4/statistics_report/newrelic_before_1.4.jpg)

- `Prometheus`
  ![skylight_before_1.1](https://github.com/rubygitflow/rails-optimization-task4/raw/profiler4/statistics_report/prometheus_before_1.1.jpg)
