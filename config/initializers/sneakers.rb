# frozen_string_literal: true

require 'sneakers/handlers/maxretry'
require 'sneakers/metrics/logging_metrics'

rabbitmq_connection = Bunny.new(
  Rails.application.config.rabbitmq_url,
  connection_name: "errmon-events-api-#{Rails.application.config.instance_name}",
  heartbeat: 0,
)

Sneakers.configure(
  connection: rabbitmq_connection,
  amqp_heartbeat: nil,
  heartbeat: 0,
  workers: 1,
  threads: Rails.application.config.max_threads,
  prefetch: Rails.application.config.max_threads,
  share_threads: true,
  handler: Sneakers::Handlers::Maxretry,
  metrics: Sneakers::Metrics::LoggingMetrics.new,
  timeout_job_after: 1.minute.in_milliseconds,
  retry_timeout: 1.minute.in_milliseconds,
  retry_max_times: 10,
  log: SemanticLogger[Sneakers],
  exchange_options: {
    auto_delete: false,
    durable: true,
    type: :topic,
  },
)

Sneakers::ContentType.register(
  content_type: 'application/json',
  serializer: ->object { Oj.dump(object, mode: :compat) },
  deserializer: ->payload { Oj.load(payload, mode: :compat, symbolize_names: true) },
)

Sneakers.logger.level = Logger::INFO
