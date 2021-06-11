## Подготовка

Перед началось работы я создал local_production окружение, в котором переопределил часть development переменных

```
  'ENVIRONMENT_CACHE_CLASSES' => 'true',
  'ENVIRONMENT_EAGER_LOAD' => 'true',
  'ENVIRONMENT_PERFORM_CACHING' => 'true',

  'ENVIRONMENT_ASSETS_DEBUG' => 'false',
  'ENVIRONMENT_ASSETS_COMPILE' => 'false',
  'ENVIRONMENT_ASSETS_DIGEST' => 'true'
```

Для запуска приложение в окружении local_production достаточно запустить скрипт bin/startup_local_production

## Показатели приложения под нагрузкой в 5 конкурентных запрос в течении 10 минут

```
siege -c 5 -t 360s -p http://localhost:3000/
```

### В development окружении

  <img width="1300" alt="Pasted Graphic 18" src="https://user-images.githubusercontent.com/2257408/120965835-f9cec980-c797-11eb-9455-60050af90448.png">
  <img width="1440" alt="Pasted Graphic 19" src="https://user-images.githubusercontent.com/2257408/120965866-00f5d780-c798-11eb-8d17-b58d76057ad8.png">
  <img width="815" alt="Throuthput" src="https://user-images.githubusercontent.com/2257408/120965894-094e1280-c798-11eb-832e-ef5f610d8681.png">
  <img width="1368" alt="Pasted Graphic 25" src="https://user-images.githubusercontent.com/2257408/120965923-11a64d80-c798-11eb-88c2-2a2260e3784e.png">

Запуск ab на 100 запросов показал **3.28 запроса в секунду**
По прометею продолжительность запроса к stories#index на старте – **1.52 секунд**, после прогрева плато – **0.33 sec**

### В local_production окружении

  <img width="1347" alt="Pasted Graphic 28" src="https://user-images.githubusercontent.com/2257408/120965935-166b0180-c798-11eb-9ef5-715239322e5f.png">
  <img width="1440" alt="Pasted Graphic 29" src="https://user-images.githubusercontent.com/2257408/120965945-19fe8880-c798-11eb-996c-25d99d93b8ad.png">
  <img width="821" alt="Web transactions time" src="https://user-images.githubusercontent.com/2257408/120965957-1d920f80-c798-11eb-8e7e-3e6ce6b72be0.png">
  <img width="1378" alt="Pasted Graphic 32" src="https://user-images.githubusercontent.com/2257408/120965972-21be2d00-c798-11eb-886c-67804be95fea.png">

Запуск ab на 100 запросов показал **7.34 запроса в секунду**
По прометею продолжительность запроса к stories#index на старте – **5.19 секунд**, после прогрева плато – **0.76 sec**

## Сравнение development vs local_production

<img width="1429" alt="Pasted Graphic 37" src="https://user-images.githubusercontent.com/2257408/120966240-8e392c00-c798-11eb-9591-cec7cad9fc29.png">

skylight в период без прогревочных запросов
development
<img width="1330" alt="Pasted Graphic 38" src="https://user-images.githubusercontent.com/2257408/120966305-9e510b80-c798-11eb-9e3c-e558ce871b4a.png">

local_production
<img width="1306" alt="Pasted Graphic 39" src="https://user-images.githubusercontent.com/2257408/120966321-a315bf80-c798-11eb-8bc4-f139a2c5a2d4.png">

## Определение проблемы

Все системы мониторинга указывают на проблему в controller Stories#index
<img width="1289" alt="image" src="https://user-images.githubusercontent.com/2257408/120966735-3bac3f80-c799-11eb-9fe6-3f79e4d1ffe3.png">

Конретнее, указывают на проблему с рендерингом шаблона \_single_story
<img width="703" alt="image" src="https://user-images.githubusercontent.com/2257408/120966977-87f77f80-c799-11eb-9a6e-100e7afb2360.png">

Для проведения оптимизации я выбрал инструмент ab, которым формирую 500 запросов к stories#index
ab -n 500 -c 5 http://localhost:3000/
Метрика, которую оптимизирую Request per Seconds. Перед началом оптимизаций ее значение было – 11.81rps

Бюджет – убрать агонию в контроллере stories#index, и добиться среднего времени ответа < 100ms

Фидбек луп

- внесение изменений с целью оптимизации
- запуск ab
- анализ результатов
- к шагу 1

Фидбек луп позволяет получить результат за пару минут

### Оптимизация 1

- Мониторинги указывают на проблему с рендером \_single_story
- добавляю cache: true в рендер каждой single_story
  `<%= render "articles/single_story", story: story, cached: true %>`
- Метрика не изменилась 11.81rps -> 11.53rps

### Оптимизация 2

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

- Метрика улучшилась радикально 11.53rps -> 25.06

## Рефакторинг

Так как внутри single_story есть счетчики комментариев, я переделал кеширование на более гибкое. Чтобы кеш этого фрагмента инвалидировался при изменении счетчиков story.comments_count

```
cache("unsigned_stories", expires_in: 1.minutes) -> cache(@stories)
```

Насколько я понял, так как мы используем counter_culture, нам не нужно добавлять :touch в модели, так как comments_count является полем таблицы articles и при его изменении кеш будет инвалидирован (поправьте, если я не прав)

Так как есть каунтеры нужно улучшить стратегию кеширования и сделать динамическую инвалидацию

Вот почему не нужен touch, потому что есть counter_culture и он является уже аттрибутом модели который поменяется

## Результат

По данным Skylight типичный запрос к оптимизируемому эндпоинту теперь занимает 78ms, а значит, удалось уложиться в бюджет
<img width="1227" alt="image" src="https://user-images.githubusercontent.com/2257408/121464374-5a534600-c9e6-11eb-945c-7e7f8613a3d5.png">
