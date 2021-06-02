# Case-study оптимизации

### Добавил необходимые гемы для профилирования:

- bullet
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
