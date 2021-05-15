### 1.1 `Gemfile`

поправил часть путей в `Gemfile` так как они были неактуальны

### 2 Algolia

Создал аккаунт и настроил ключи, проблем не возникло

## 3. NewRelic

Настроил NewRelic, с помощью гема все настроилось быстро и легко

## 4. Skylight

Настроил Skylight, все прошло без проблем

## 5. Prometheus + Grafana

Пришлось немного повозиться так как с docker особо не работал и у него есть свои особенности

## 6. rack-mini-profiler

ранее уже подключал, проблем не возникло

## 7. local_production

## 8. Проверил через new relic и skylight и самый медленным действительно оказался StoriesController#index

изначально скорость загрузки составила:

[<img src="https://i.ibb.co/mFbQfLD/2021-05-15-20-06.png">](https://i.ibb.co/mFbQfLD/2021-05-15-20-06.png/)
[<img src="https://i.ibb.co/yqkKNHs/2021-05-15-19-47-1.png">](https://i.ibb.co/yqkKNHs/2021-05-15-19-47-1.png/)

После кэширования проблемного паршиала время сократилось до:
[<img src="https://i.ibb.co/P6FGSsj/2021-05-15-20-10.png">](https://i.ibb.co/P6FGSsj/2021-05-15-20-10.png/)
[<img src="https://i.ibb.co/M9ptzWr/2021-05-15-19-54.png">](https://i.ibb.co/M9ptzWr/2021-05-15-19-54.png)

touch: true не использовал так как в проекте используется counter_culture

На бонус не хватило времени
