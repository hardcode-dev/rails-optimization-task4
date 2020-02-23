class CustomCollector < PrometheusExporter::Server::TypeCollector
  unless defined? Rails
    require File.expand_path("../config/environment", __DIR__)
  end

  def type
    "permidon_posts"
  end

  def metrics
    permidon_posts_gague = PrometheusExporter::Metric::Gauge.new("permidon_posts", "number of permidon posts")
    permidon_posts_gague.observe User.find_by_name("Roman Perminov").articles.count
    [permidon_posts_gague]
  end
end
