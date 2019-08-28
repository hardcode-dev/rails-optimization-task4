class CustomCollector < PrometheusExporter::Server::TypeCollector
  unless defined? Rails
    require File.expand_path("../../../config/environment", __FILE__)
  end

  def type
    "count_users"
  end

  def metrics
    count_users = PrometheusExporter::Metric::Gauge.new('count_users', 'number of users')
    count_articles = PrometheusExporter::Metric::Gauge.new('count_articles', 'number of articles')
    count_users.observe User.count
    count_articles.observe Article.count
    [count_users, count_articles]
  end
end
