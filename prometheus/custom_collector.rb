class CustomCollector < PrometheusExporter::Server::TypeCollector
  unless defined? Rails
    require File.expand_path("../../config/environment", __FILE__)
  end

  def type
    "mariela_posts"
  end

  def metrics
    mariela_posts_gague = PrometheusExporter::Metric::Gauge.new('mariela_posts', 'number of mariela posts')
    mariela_posts_gague.observe User.find_by_name('Mariela Ledner').articles.count
    [mariela_posts_gague]
  end
end
