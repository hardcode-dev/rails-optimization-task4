## Оптимизация 1

### до оптимизации вот эта штука рендерилась по 10 раз

Rendered articles/\_single_story.html.erb (10.1ms)
Rendered articles/\_single_story.html.erb (5.2ms)
Rendered articles/\_single_story.html.erb (11.3ms)

### и общая вьюха рендерилась

Rendered stories/\_main_stories_feed.html.erb (548.7ms)

### добавил рендеринг коллекции

```
1
<div id="sign_in_invitation" style="display: none;"><%= render "stories/sign_in_invitation" %></div>
<%= render partial: "articles/single_story", collection: @stories, as: :story, cached: true %>

2
вместо: <% next if story.id == @featured_story.id %>

@stories = @stories.where.not(id: @featured_story.id) if @featured_story&.id

3 докидываем блок на js
<script>
  var sign_in_invitation = document.getElementById('sign_in_invitation');
  var thirdEl = document.querySelector('#substories .single-article:nth-child(5)')
  thirdEl.insertAdjacentHTML('afterend', sign_in_invitation.innerHTML);
</script>

```

## Результат

```
  Rendered collection of articles/_single_story.html.erb [0 / 24 cache hits] (439.9ms)
  Rendered stories/_main_stories_feed.html.erb (449.3ms)
```

## Оптимизация 2

Вместо того чтобы искать каждый раз нужный тэг, подготовим коллекцию в контроллере и прокиним во вьюху

```
было
  flare && flare != except_tag ? Tag.select(%i[name bg_color_hex text_color_hex]).find_by_name(flare) : nil
стало
  flare && flare != except_tag ? @list_tags[flare] : nil
```

метрика

```
Rendered articles/_tag_identifier.html.erb (20.9ms)
Rendered articles/_tag_identifier.html.erb (4.2ms)
Rendered articles/_tag_identifier.html.erb (5.0ms)
Rendered articles/_tag_identifier.html.erb (3.5ms)
Rendered articles/_tag_identifier.html.erb (14.9ms)
Rendered articles/_tag_identifier.html.erb (2.5ms)
Rendered articles/_tag_identifier.html.erb (4.0ms)
Rendered articles/_tag_identifier.html.erb (6.1ms)
Rendered articles/_tag_identifier.html.erb (3.1ms)
Rendered articles/_tag_identifier.html.erb (4.1ms)
Rendered articles/_tag_identifier.html.erb (2.7ms)

  Rendered stories/_main_stories_feed.html.erb (449.3ms)

```

стало

```
  Rendered articles/_tag_identifier.html.erb (0.4ms)
  Rendered articles/_tag_identifier.html.erb (0.3ms)
  Rendered articles/_tag_identifier.html.erb (0.2ms)
  Rendered articles/_tag_identifier.html.erb (0.3ms)
  Rendered articles/_tag_identifier.html.erb (0.3ms)
  Rendered articles/_tag_identifier.html.erb (0.2ms)
  Rendered articles/_tag_identifier.html.erb (0.3ms)
  Rendered articles/_tag_identifier.html.erb (0.3ms)
  Rendered articles/_tag_identifier.html.erb (0.3ms)
  Rendered articles/_tag_identifier.html.erb (0.3ms)
  Rendered articles/_tag_identifier.html.erb (0.4ms)

  Rendered stories/_main_stories_feed.html.erb (366.5ms)

```

## Тест на local_production

```
До оптимизации
Rendered stories/_main_stories_feed.html.erb (316.7ms)

После оптимизации
Rendered stories/_main_stories_feed.html.erb (55.7ms)
```
