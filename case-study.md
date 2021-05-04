# Case Study

- [x] 1 - Завести dev.to локально (прямо в этом репозитории, не нужно
      клонировать dev.to от них, иначе будут отличаться версии)
- [ ] 2 - Настроить свой NewRelic для мониторинга локального dev.to
- [ ] 3 - Настроить свой Skylight / Scout / Datadog для мониторинга
      локального dev.to
- [ ] 4 - Настроить свой Prometheus + Grafana для мониторинга локального dev.to
- [ ] 5 - Настроить rack-mini-profiler
- [ ] 6 - Настроить rails-panel
- [ ] 7 - Сделать возможность запуска проекта в local_production

## 1. Завести dev.to локально

### 1.1 `Gemset`

Понадобилось поправить пути в `Gemset`: проект dev.to поменял в GitHub
название на `fastly/fastly`, используемые гемы перенеслись в новый неймспейс,
причем некоторые перестали быть актуальны и теперь отсутствуют.
Поправил пути, заменил ссылки на репозитории.

### 1.2 Algolia Search

Прописал переменные окружения. Тут все прошло штатно.

### 1.3 Авторизация через GitHub

Текущий гем `omniauth-github` работал по уже неподдерживаемой схеме авторизации:

```json
E, [2021-05-05T09:36:59.256293 #188787] ERROR -- omniauth: (github) Authentication failure! invalid_credentials: OAuth2::Error, :
{"message":"Must specify access token via Authorization header. https://developer.github.com/changes/2020-02-10-deprecating-auth-through-query-param","documentation_url":"https://docs.github.com/v3/#oauth2-token-sent-in-a-header"}
```

Пришлось обновить на версию 1.4 (минимально возможное обновление
для поддержания совместимости).

Далее, при входи через omniauth стала происходить ошибка с потерей токена формы:

```json
Processing by UsersController#onboarding_update as */*
  Parameters: {"saw_onboarding"=>"true"} [controller_call]
HTTP Origin header (http://2dev.lvh.me:3000) didn't match request.base_url (http://2dev.lvh.me:3000)
  Role Load (0.6ms)  SELECT "roles".* FROM "roles" INNER JOIN "users_roles" ON "roles"."id" = "users_roles"."role_id" WHERE "users_roles"."user_id" = $1 AND (((roles.name = 'super_admin') AND (roles.resource_type IS NULL) AND (roles.resource_id IS NULL)))  [["user_id", 11]] [sql_query]
ActionController::InvalidAuthenticityToken (ActionController::InvalidAuthenticityToken) [error]
```

Временное решение: во время авторизации отключил вызов экшена
контроллера `protect_from_forgery with: :exception, prepend: true`
в `app/controllers/application_controller.rb:2`.
Понятно, что это совсем временное решение.
В реальном проекте я бы создал отдельную задачу на восстановление
такой функциональности, так как к текущей это не особенно имеет отношение,
и есть способ обойти проблему в рамках решения текущей задачи.
