## Шаг 1 развертывание

- Развернул приложение в докере - сначала сделал local_production затем увидев, что в коде много `is Rails.env.production?` переделал production env добавив переменных и запускаю в нем

- Подключил Skylight так как знаком с ним и есть аккаунт

- [Добавил yabeda и контейнеры с прометеусом и графаной](https://prnt.sc/rabe1v)

- Добавил в прод Rack-mini-profiler и rails-panel

## Шаг 2 кеширование

- [Skylight показал слона на главной странице](https://prnt.sc/rab23x)
- [Добавил в кеширование app/views/articles/\_single_story.html.erb, сллона урезал скорость поднял на 30% получил регрессию на перво загрузке](https://prnt.sc/rab8m8)
