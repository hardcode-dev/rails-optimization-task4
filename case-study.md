# Case-study оптимизации

## Предварительная настройка

- подключен NewRelic (Skylight используется на работе), Cloudinary, Github, Algolia
- установлены race-mini-profiler, rails_panel
- настройка local_production окружения, чтобы получить данные о производительности, приближенные к production
- отключил пару логгеров, вместо memcached - redis

Результаты через ab -n 20 -c 5 http://127.0.0.1:3000/ до модификации в development
Requests per second: 2.31 [#/sec](mean)
Time per request: 2162.129 [ms](mean)
Time per request: 432.426 [ms] (mean, across all concurrent requests)
Transfer rate: 414.03 [Kbytes/sec] received

Percentage of the requests served within a certain time (ms)
50% 1795
66% 1962
75% 2385
80% 3160
90% 3584
95% 3672

## Feedback-Loop

`feedback_loop` для оптимизации:

- поиск точки роста
- модификация кода
- проверка результата
- повторение

## Находка 1

NewRelic показал основную точку роста - рендеринг паршиалов
articles/tag_index.html.erb Template
articles/sidebar.html.erb Partial
articles/single_story.html.erb Partial

Rack-mini-profiler указывает на articles/sidebar.html.erb Partial

Sidebar

- в паршиале articles/sidebar_nav лишний раз сделана проверка на залогиненность
- в паршиале articles/sidebar_nav делается запрос Tag.where..., что не есть хорошо, т.к. и запрос делается постоянно, но данные вероятно одинаковые, решил закэшировать

Результат после через ab -n 30 -c 5 http://127.0.0.1:3000/
Requests per second: 2.92 [#/sec](mean)
Time per request: 1714.784 [ms](mean)
Time per request: 342.957 [ms] (mean, across all concurrent requests)
Transfer rate: 522.05 [Kbytes/sec] received

Percentage of the requests served within a certain time (ms)
50% 1773
66% 1904
75% 1921
80% 2062
90% 2201
95% 2335

## Находка 2

После получения большого кол-ва данных NewRelic показал как основную точку роста - articles/single_story.html.erb Partial (20%)
Вызов в tag_index для каждой story своего паршиала с еще одним паршиалом, перенос всё в один файл, кэширование, добавил touch: true в зависимые модели, чтобы story.updated_at обновлялось и кэш модифицировался
Не мог понять, почему результат не улучшается - забыл включить кэширование в development режиме
Результат сразу улучшился примерно в 2 раза по NewRelic

Requests per second: 5.02 [#/sec](mean)
Time per request: 996.298 [ms](mean)
Time per request: 199.260 [ms] (mean, across all concurrent requests)

Percentage of the requests served within a certain time (ms)
50% 937
66% 1110
75% 1140
80% 1179
90% 1424
95% 1431

## Предположение 3

Переключить логи в error

Requests per second: 5.27 [#/sec](mean)
Time per request: 947.920 [ms](mean)
Time per request: 189.584 [ms] (mean, across all concurrent requests)

Percentage of the requests served within a certain time (ms)
50% 953
66% 1035
75% 1135
80% 1169
90% 1249
95% 1288

Еще немного отыгранного времени, но в принципе на production не повлияет

## Находка 4

Следующая важная точка роста - stories/main_stories_feed.html.erb Partial
Там такая же история со stories, тоже надо кэшировать

Requests per second: 8.64 [#/sec](mean)
Time per request: 578.776 [ms](mean)
Time per request: 115.755 [ms] (mean, across all concurrent requests)

Percentage of the requests served within a certain time (ms)
50% 566
66% 624
75% 711
80% 825
90% 839
95% 875

Примерный рост для 95% запросов - в 4 раза быстрее загрузка в development режиме

## Находка 5

Уже менее значительная точка роста по NewRelic - articles/tag_identifier.html.erb Partial
Перенос в основной файл

Requests per second: 8.57 [#/sec](mean)
Time per request: 583.698 [ms](mean)
Time per request: 116.740 [ms] (mean, across all concurrent requests)

Percentage of the requests served within a certain time (ms)
50% 587
66% 638
75% 667
80% 691
90% 775
95% 794

Не выиграно особо много времени

## Итоги

Замеры для local_production ab -n 50 -c 5 http://127.0.0.1:5000/ до проведения модификаций
Requests per second: 24.75 [#/sec](mean)
Time per request: 202.033 [ms](mean)
Time per request: 40.407 [ms] (mean, across all concurrent requests)

Percentage of the requests served within a certain time (ms)
50% 165
66% 232
75% 258
80% 268
90% 288
95% 296

Замеры для local_production ab -n 50 -c 5 http://127.0.0.1:5000/ после проведения модификаций

Requests per second: 33.32 [#/sec](mean)
Time per request: 150.056 [ms](mean)
Time per request: 30.011 [ms] (mean, across all concurrent requests)

Percentage of the requests served within a certain time (ms)
50% 128
66% 182
75% 188
80% 193
90% 241
95% 243

Результат
Благодаря кэшированию обрабатывается на 10 запросов в секунду больше, рост 25%
