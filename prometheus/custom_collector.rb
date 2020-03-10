class CustomCollector < PrometheusExporter::Server::TypeCollector
  unless defined? Rails
    require File.expand_path("../../config/environment", __FILE__)
  end

  def type
    "spajic_posts"
  end

  def metrics
    posts_gague = PrometheusExporter::Metric::Gauge.new('posts', 'number of posts')
    posts_gague.observe Article.count
    [posts_gague]
  end
end
