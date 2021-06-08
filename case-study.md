## Проблема



Перед началось работы я создал local_production окружение, в котором переопределил часть development переменных

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
<img width="1300" alt="Pasted Graphic 18" src="https://user-images.githubusercontent.com/2257408/120965835-f9cec980-c797-11eb-9455-60050af90448.png">
<img width="1440" alt="Pasted Graphic 19" src="https://user-images.githubusercontent.com/2257408/120965866-00f5d780-c798-11eb-8d17-b58d76057ad8.png">
<img width="815" alt="Throuthput" src="https://user-images.githubusercontent.com/2257408/120965894-094e1280-c798-11eb-832e-ef5f610d8681.png">
<img width="1368" alt="Pasted Graphic 25" src="https://user-images.githubusercontent.com/2257408/120965923-11a64d80-c798-11eb-88c2-2a2260e3784e.png">

Запуск ab на 100 запросов показал **3.28 запроса в секунду**
По прометею продолжительность запроса к stories#index на старте – **1.52 секунд**, после прогрева плато – **0.33 sec**

  [скриншоты]

- local_production
<img width="1347" alt="Pasted Graphic 28" src="https://user-images.githubusercontent.com/2257408/120965935-166b0180-c798-11eb-9ef5-715239322e5f.png">
<img width="1440" alt="Pasted Graphic 29" src="https://user-images.githubusercontent.com/2257408/120965945-19fe8880-c798-11eb-996c-25d99d93b8ad.png">
<img width="821" alt="Web transactions time" src="https://user-images.githubusercontent.com/2257408/120965957-1d920f80-c798-11eb-8e7e-3e6ce6b72be0.png">
<img width="1378" alt="Pasted Graphic 32" src="https://user-images.githubusercontent.com/2257408/120965972-21be2d00-c798-11eb-886c-67804be95fea.png">

Запуск ab на 100 запросов показал **7.34 запроса в секунду**
По прометею продолжительность запроса к stories#index на старте – **5.19 секунд**, после прогрева плато – **0.76 sec**

  [скирншоты]
  
Сравнению development vs local_production

<img width="1429" alt="Pasted Graphic 37" src="https://user-images.githubusercontent.com/2257408/120966240-8e392c00-c798-11eb-9591-cec7cad9fc29.png">

skylight в период без прогревочных запросов
development
<img width="1330" alt="Pasted Graphic 38" src="https://user-images.githubusercontent.com/2257408/120966305-9e510b80-c798-11eb-9e3c-e558ce871b4a.png">

local_production
<img width="1306" alt="Pasted Graphic 39" src="https://user-images.githubusercontent.com/2257408/120966321-a315bf80-c798-11eb-8bc4-f139a2c5a2d4.png">

## Определение проблемы
Все системы мониторинга указывают на проблему в controller Stories#index
<img width="1289" alt="image" src="https://user-images.githubusercontent.com/2257408/120966735-3bac3f80-c799-11eb-9fe6-3f79e4d1ffe3.png">

[скриншоты]

Bullet и Scout указывают на проблему N+1 в этом stories#index
<img width="1412" alt="image" src="https://user-images.githubusercontent.com/2257408/120966773-46ff6b00-c799-11eb-8e11-7fc98939ae1c.png">
<img width="361" alt="image" src="https://user-images.githubusercontent.com/2257408/120967720-6ea30300-c79a-11eb-9e8c-50bc93ef20cc.png">

[скриншот]
И большинство указывают на проблему с рендерингом шаблона \_single_story
<img width="703" alt="image" src="https://user-images.githubusercontent.com/2257408/120966977-87f77f80-c799-11eb-9a6e-100e7afb2360.png">

[скриншот]


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
