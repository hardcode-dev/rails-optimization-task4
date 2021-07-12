# frozen_string_literal: true

class TestDurationMetric < Influxer::Metrics
  set_series :test

  tags :user

  attributes :run_time

  validates :user, :run_time, presence: true
  validates :run_time, numericality: true
end
