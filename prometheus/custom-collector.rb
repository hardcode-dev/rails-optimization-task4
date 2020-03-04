class CustomCollector < PrometheusExporter::Server::TypeCollector
  unless defined? Rails
    require File.expand_path("../../config/environment", __FILE__)
  end

  def type
    "spajic_posts"
  end

  def metrics
    kuvalis_posts_gague = PrometheusExporter::Metric::Gauge.new('kuvalis_posts', 'number of kuvalis posts')
    kuvalis_posts_gague.observe User.find_by_name('Mr. Numbers Kuvalis').articles.count
    [kuvalis_posts_gague]
  end
end
