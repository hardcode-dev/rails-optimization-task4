### Проблема

Все инструменты мониторинга показывают, что самой горячей точкой является главная страница, StoriesController#index.

В частности, заметное время занимает рендеринг partial-ов \_single_story.html.erb.

### Решение

Необходимо закешировать <%= render "articles/single_story", story: story %> в \_main_stories_feed.html.erb

С помощью AB-теста проверил увеличение производительности, получил следующие результаты:

#### Было

Time taken for tests: 16.943 seconds

Complete requests: 30

#### Стало

Time taken for tests: 7.227 seconds

Complete requests: 30

##### Производительность улучшилась ~ в `2.3` раза
