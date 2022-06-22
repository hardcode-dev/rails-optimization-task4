class CustomCollector < PrometheusExporter::Server::TypeCollector
  unless defined? Rails
    require File.expand_path("../../config/environment", __FILE__)
  end

  def type
    'users_count'
  end

  def metrics
    users_count_gague = PrometheusExporter::Metric::Gauge.new(type, 'users count')
    users_count_gague.observe(User.count)

    [users_count_gague]
  end
end
