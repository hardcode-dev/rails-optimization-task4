# Case-study оптимизации

## Подготовка

- Запустил dev.to локально - Столкнулся со следующими трудностями:
  _ Сначала при bundle вылетела ошибка с неправильным путем для гемов `'fix-db-schema-conflicts'` и `gem 'acts_as_follower'`. Поправил путь и все норм.
  _ Добавил ключи Алголии в файл application.yml.
  _ Дальше запускаю bin/setup, Yarn начинает ругаться. Просто отключил эту проверку в конфиге как и предлагалось у меня в консоли.
  _ Дальше bin/startup. И вылетает ошибка: No such file or directory ... node_modules ... Это пофиксил следующей командой в консоли (предварительно установив npm): npm install -g webpack-dev-server \* Опять запускаю bin/startup и вылетает следующая ошибка: `Error: Cannot find module 'webpack'`. Ввел в консоли команду: `npm link webpack`,
  а затем:

      	    rm -Rf node_modules
      	    rm -f package-lock.json
      	    npm install

- Настроил свой NewRelic для мониторинга локального dev.to
  _ Установил утилиту siege и запустил ее командой siege -c 5 -t120s http://localhost:3000
  _ Определил, что главной точкой роста является StoriesController#index, а именно запрос составляет почти 4 с или 56,8 % \* Скрин с экрана лежит в папке task_images/01_new_relic_before.png
