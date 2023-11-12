# Оптимизация

## Кэширование `_single_story.html.erb` в `_main_stories_feed.html.erb`

Добавление кэширования по стори позволило ускорить загрузку главной страницы почти в 2 раза.

### AB

#### before

Time per request: 212.047 ms

https://gist.github.com/peresvetjke/22b0076f71bb49000aa3c3f082889d85

#### after

Time per request: 114.685 ms

https://gist.github.com/peresvetjke/5b0a328f332dda0c43c7d8466f927bde
