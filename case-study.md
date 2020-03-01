# Case-study оптимизации

## Предварительная настройка

- подключен NewRelic (Skylight используется на работе), Cloudinary, Github, Algolia
- установлены race-mini-profiler, rails_panel
- настройка local_production окружения, чтобы получить данные о производительности, приближенные к production
- отключил пару логгеров, вместо memcached - redis

## Feedback-Loop

`feedback_loop` для оптимизации:

- поиск точки роста
- модификация кода
- проверка результата
- повторение
