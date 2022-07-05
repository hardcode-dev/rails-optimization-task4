class InfluxClient
  def self.client
    @client ||= InfluxDB2::Client.new(
      'http://localhost:8086',
      '173D18zGM7iJoSSbdP37AYeGXj_RoUvFUYUUCS0T-8aZcUtWTSRGkavrsYIscGqi_Lx7jEnkaQBQVtLXjRO_WQ==',
      bucket: 'devto',
      org: 'devto',
      precision: InfluxDB2::WritePrecision::NANOSECOND,
      use_ssl: false
    )
  end

  def self.write(data)
    write_api = client.create_write_api
    write_api.write(data: data)
  end
end
