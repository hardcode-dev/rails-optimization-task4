class Metrics < PrometheusExporter::Server::TypeCollector
  unless defined? Rails
    require File.expand_path("../../config/environment", __FILE__)
  end

  def type
    "main"
  end

  def metrics
    users_gauge = PrometheusExporter::Metric::Gauge.new('user_count', 'Count of User')
    users_gauge.observe User.all.size
    page_views_gauge = PrometheusExporter::Metric::Gauge.new('page_views_count', 'count of PageView')
    page_views_gauge.observe PageView.all.size
    [users_gauge, page_views_gauge]
  end
end
