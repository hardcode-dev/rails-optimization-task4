class CustomCollector < PrometheusExporter::Server::TypeCollector
  unless defined? Rails
    require File.expand_path("../../config/environment", __FILE__)
  end

  def type
    "my_posts"
  end

  def metrics
    my_posts_gague = PrometheusExporter::Metric::Gauge.new('my_posts', 'number of my posts')
    my_posts_gague.observe User.find_by_name('Yuriy Kirillov').articles.count
    [my_posts_gague]
  end
end
