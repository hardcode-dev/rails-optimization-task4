### Задание 4

Развернул проект локально, не используя Docker (на маке приложения в докере работают медленнее).

Установил skylight, newrelic, grafana + prometheus, rack-mini-profiler, rails-panel.

Сделал возможность запуска продакшен окружения локально (предварительно необходимо создать бд и откорректировать database.yml):

`LOCAL_PRODUCTION=true bin/startup`
