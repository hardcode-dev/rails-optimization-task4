# Case-study оптимизации

## Подготовка

1. Запустил `DEV.TO` локально
2. Настроил `New Relic`
   - Нагрузил систему спомощью `siege`, чтобы проверить работу New Relic
   - `New Relic => Monitoring => Transaction`: показал что точка роста `StoriesController#index`
3. Подключил `Skylight`
4. Подключил `Prometheus`+`Grafana`
