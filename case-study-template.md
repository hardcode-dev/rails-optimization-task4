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
