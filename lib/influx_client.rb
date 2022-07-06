class InfluxClient
  def self.client
    @client ||= InfluxDB2::Client.new(
      ENV.fetch("INFLUXDB_URL", 'http://localhost:8086'),
      ApplicationConfig["INFLUXDB_TOKEN"],
      bucket: ApplicationConfig["INFLUXDB_BUCKET"],
      org: ApplicationConfig["INFLUXDB_ORG"],
      precision: InfluxDB2::WritePrecision::NANOSECOND,
      use_ssl: false
    )
  end

  def self.write(data)
    write_api = client.create_write_api
    write_api.write(data: data)
  end
end
