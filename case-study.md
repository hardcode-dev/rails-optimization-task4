# Case-study оптимизации

### Добавил необходимые гемы для профилирования:

- rack-mini-profiler
- newrelic
- skylight

### local_production

- добавил новое окружение: `local_production`
- перекомпилировал ассеты: `RAILS_ENV=local_production rake assets:precompile`

### Feedback-Loop

- поиск больного места (по условию задачи `StoriesController#index`)
- профилирование
- поиск главной точки роста
- рефакторинг
- прогон `ab`

### Находки

- запустил `ab -n 30 -c 10 http://127.0.0.1:3000/`

```bigquery
Time per request:       1014.515 [ms] (mean)
Time per request:       101.451 [ms] (mean, across all concurrent requests)
Transfer rate:          1377.54 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       0
Processing:   266  747 427.2    592    1901
Waiting:      266  743 428.0    588    1899
Total:        266  747 427.3    592    1901

Percentage of the requests served within a certain time (ms)
  50%    592
  66%    693
  75%    821
  80%    862
  90%   1881
  95%   1886
  98%   1901
  99%   1901
 100%   1901 (longest request)
```

- главная точка роста в рендеринге partial
- решил сделать матрешечное кэширование `@stories` и `story`
- не требуется вешать touch т.к. используется `counter_culture`
- делал кастомное кэширвоание в контроллере, но особого прироста не дало
- переделал рендеринг на паршал коллекции

```bigquery
Requests per second:    15.34 [#/sec] (mean)
Time per request:       130.349 [ms] (mean)
Time per request:       65.174 [ms] (mean, across all concurrent requests)
Transfer rate:          2139.87 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:    99  123  20.5    113     170
Waiting:       99  123  20.5    112     170
Total:         99  123  20.5    113     170

Percentage of the requests served within a certain time (ms)
  50%    113
  66%    125
  75%    142
  80%    147
  90%    154
  95%    160
  98%    170
  99%    170
 100%    170 (longest request)
```

### Результаты

- получилось значительно сократить время ожидания рендеринга страницы
- понравилось работать с ab, интересный инструмент
- пока изучал проект, познакомился с counter_culture +++
