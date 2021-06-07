## Проблема

Все системы мониторинга указывают на проблему в controller Stories#index
[скриншоты]

Bullet и Scout указывают на проблему N+1 в этом контроллере
[скриншот]
И большинство указывают на проблему с рендерингом шаблона \_single_story
[скриншот]

Для оптимизации этого участка для начала я создал local_production окружение, в котором переопределил часть development переменных

```
  'ENVIRONMENT_CACHE_CLASSES' => 'true',
  'ENVIRONMENT_EAGER_LOAD' => 'true',
  'ENVIRONMENT_PERFORM_CACHING' => 'true',

  'ENVIRONMENT_ASSETS_DEBUG' => 'false',
  'ENVIRONMENT_ASSETS_COMPILE' => 'false',
  'ENVIRONMENT_ASSETS_DIGEST' => 'true'
```

В development окружении показатели систем мониторинга при запуске на 10 минут

```
siege -c 5 -t 360s -p http://localhost:3000/
```

- development env
  [скриншоты]

- local_production
  [скирншоты]

Для проведения оптимизации я выбрал инструмент ab, которым формирую 10 запросов к stories#index
ab -n 100 -c 5 http://localhost:3000/
Метрика, которую оптимизирую Request per Seconds
Бюджет – ??? 100ms время ответа страницы в 99 персентиле

Фидбек луп

- внесение изменений с целью оптимизации
- запуск ab
- анализ результатов
- к шагу 1

Фидбек луп позволяет получить результат за пару минут

### Оптимизация 1

- scout и bullet указывают на N+1. Bullet предлагает добавить preload :users
- Добавляю прелоад

```
@stories = @stories.preload(:user)
```

- Метрика улучшилась 11.33 -> 11.42
  [скриншот]

### Оптимизация 2

- scout и bullet указывают на N+1. Bullet предлагает добавить preload :organizations
- Добавляю прелоад

```
@stories = @stories.preload(:user, :organization)
```

- Метрика улучшилась 11.42 -> 12.88
  [скриншот]

### Оптимизация 3

- Мониторинги указывают на проблему с рендером \_single_story
- добавляю cache: true в рендер каждой single_story
  `<%= render "articles/single_story", story: story, cached: true %>`
- Метрика улучшилась 12.88 -> 13.29
  [скриншот]

### Оптимизация 4

- Проблема с рендером по-прежнему актуальна
- кеширую полностью кусок со всеми историями cache("unsigned_stories", expires_in: 1.minutes) do

```
<% cache("unsigned_stories", expires_in: 1.minutes) do %>
    <% @stories.each_with_index do |story, i| %>
      <% next if story.id == @featured_story.id %>
      <% if !user_signed_in? && i == 4 %>
        <%= render "stories/sign_in_invitation" %>
      <% end %>
      <%= render "articles/single_story", story: story, cached: true %>
    <% end %>
  <% end %>
```

- Метрика улучшилась 13.29 -> 23.62
  [скриншот]
